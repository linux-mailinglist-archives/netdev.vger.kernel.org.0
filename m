Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365CD6B616E
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 23:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjCKWS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 17:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjCKWSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 17:18:53 -0500
X-Greylist: delayed 2487 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 11 Mar 2023 14:18:51 PST
Received: from mx23lb.world4you.com (mx23lb.world4you.com [81.19.149.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5D730288;
        Sat, 11 Mar 2023 14:18:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tTU8edbQ8WhDCPaKCQrG3SKzi8q7/ZcWvfsOl5UYY7E=; b=OpfregP54/us2Paze67Z1R8u/L
        83k8qLcAuOeWv9SXkEyswUPj4ZXl3NvAMJdOzGlNumsvzgfiNpawGMI7xBRKpADTYmWMpHzOYmyZQ
        3FYzNtFLBFGQvNd8psaD9nXxonEZEcbvkgmINCRukVcVTAoJftf9uzZ15LYSYeULYU4Q=;
Received: from [88.117.63.48] (helo=hornet.engleder.at)
        by mx23lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pb6u0-0005IZ-2S; Sat, 11 Mar 2023 22:37:20 +0100
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        song@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        toke@redhat.com, Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [RFC PATCH net] bpf: Fix unregister memory model in BPF_PROG_RUN in test runner
Date:   Sat, 11 Mar 2023 22:37:09 +0100
Message-Id: <20230311213709.42625-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-ACL-Warn: X-W4Y-Internal
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After executing xdp-trafficgen the following kernel output appeared:
[  214.564375] page_pool_release_retry() stalled pool shutdown 64 inflight 60 sec

xdp_test_run_batch() in combination with xdp-trafficgen uses a batch
size of 64. So it seems that a single batch does find its way back to
the page pool. I checked my tsnep driver, but the page pool entries were
not lost in the driver according to my analysis.

Executing xdp-trafficgen with n=1000 resulted in this output:
[  251.652376] page_pool_release_retry() stalled pool shutdown 40 inflight 60 sec

Executing xdp-trafficgen with n=10000 resulted in this output:
[  267.332374] page_pool_release_retry() stalled pool shutdown 16 inflight 60 sec

So interestingly in both cases the last batch with a size lower than 64
does not find its way back to the page pool. So what's the problem with
the last batch?

After xdp_test_run_batch() clean up is done in xdp_test_run_teardown()
no matter if page pool entries are still in flight. No problem for
page_pool_destroy() as the page pool is released later when no entries
are in flight.

With commit 425d239379db0 unregistering memory model has been added to
xdp_test_run_teardown(). Otherwise the page pool would not be released.
But xdp_unreg_mem_model() resets the memory model type immediately to 0
(which is actually MEM_TYPE_PAGE_SHARED). So the memory model type
MEM_TYPE_PAGE_POOL is lost and any inflight page pool entries have no
chance to find its way back to the page pool. I assume that's the reason
why the last batch does not find its way back to the page pool.

A simple sleep before xdp_unreg_mem_model() solved this problem, but
this is no valid fix of course. It needs to be ensured that the memory
model is not in use anymore. This is the case when the page pool has no
entries in flight.

How could it be ensured that a call to xdp_unreg_mem_model() is safe?
In my opinion drivers suffer the same problem. Is there a pattern how
this can be solved? Or did I misinterprete something?

Fixes: 425d239379db0 ("bpf: Fix release of page_pool in BPF_PROG_RUN in test runner")
Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 net/bpf/test_run.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index b766a84c8536..eaccfdab0be3 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -202,6 +202,8 @@ static int xdp_test_run_setup(struct xdp_test_data *xdp, struct xdp_buff *orig_c
 
 static void xdp_test_run_teardown(struct xdp_test_data *xdp)
 {
+	usleep_range(10000, 11000);
+
 	xdp_unreg_mem_model(&xdp->mem);
 	page_pool_destroy(xdp->pp);
 	kfree(xdp->frames);
-- 
2.30.2

