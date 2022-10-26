Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F8460E0BB
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 14:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbiJZMeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 08:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbiJZMeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 08:34:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1A8AF1AA;
        Wed, 26 Oct 2022 05:34:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 434DAB821D9;
        Wed, 26 Oct 2022 12:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DAFC433D6;
        Wed, 26 Oct 2022 12:34:02 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Xx5KKuxr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1666787640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZeAi1MGyrPwsr84DGCNB/7Ek0xszjHGR2vlAtEQhd1A=;
        b=Xx5KKuxrtpwoY9Wy+CYd1WDXBT9sCoNC9fjwsGkstHhNbN1WpvKcBizZeRpT/FCzCiS4RQ
        tcs+Bt7NF3eTh8IExPNnbvvnyDYVtjOIBQ7zCHExZIsoRAGhDA8m5Mp/+dUQ/2ed4jN+pX
        1b2G92MsVRvv78DJhUgz7++3kx0ah/c=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8a7530bf (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 26 Oct 2022 12:33:59 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Julian Anastasov <ja@ssi.bg>,
        Simon Horman <horms@verge.net.au>, stable@vger.kernel.org
Subject: [PATCH] ipvs: use explicitly signed chars
Date:   Wed, 26 Oct 2022 14:32:16 +0200
Message-Id: <20221026123216.1575440-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The `char` type with no explicit sign is sometimes signed and sometimes
unsigned. This code will break on platforms such as arm, where char is
unsigned. So mark it here as explicitly signed, so that the
todrop_counter decrement and subsequent comparison is correct.

Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Julian Anastasov <ja@ssi.bg>
Cc: Simon Horman <horms@verge.net.au>
Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 net/netfilter/ipvs/ip_vs_conn.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 8c04bb57dd6f..7c4866c04343 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1249,40 +1249,40 @@ static const struct seq_operations ip_vs_conn_sync_seq_ops = {
 	.next  = ip_vs_conn_seq_next,
 	.stop  = ip_vs_conn_seq_stop,
 	.show  = ip_vs_conn_sync_seq_show,
 };
 #endif
 
 
 /* Randomly drop connection entries before running out of memory
  * Can be used for DATA and CTL conns. For TPL conns there are exceptions:
  * - traffic for services in OPS mode increases ct->in_pkts, so it is supported
  * - traffic for services not in OPS mode does not increase ct->in_pkts in
  * all cases, so it is not supported
  */
 static inline int todrop_entry(struct ip_vs_conn *cp)
 {
 	/*
 	 * The drop rate array needs tuning for real environments.
 	 * Called from timer bh only => no locking
 	 */
-	static const char todrop_rate[9] = {0, 1, 2, 3, 4, 5, 6, 7, 8};
-	static char todrop_counter[9] = {0};
+	static const signed char todrop_rate[9] = {0, 1, 2, 3, 4, 5, 6, 7, 8};
+	static signed char todrop_counter[9] = {0};
 	int i;
 
 	/* if the conn entry hasn't lasted for 60 seconds, don't drop it.
 	   This will leave enough time for normal connection to get
 	   through. */
 	if (time_before(cp->timeout + jiffies, cp->timer.expires + 60*HZ))
 		return 0;
 
 	/* Don't drop the entry if its number of incoming packets is not
 	   located in [0, 8] */
 	i = atomic_read(&cp->in_pkts);
 	if (i > 8 || i < 0) return 0;
 
 	if (!todrop_rate[i]) return 0;
 	if (--todrop_counter[i] > 0) return 0;
 
 	todrop_counter[i] = todrop_rate[i];
 	return 1;
 }
-- 
2.38.1

