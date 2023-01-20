Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01A2675426
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 13:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjATMIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 07:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjATMIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 07:08:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3387EE56
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 04:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674216468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=XrQIns4v3R/JI6/PNKtT3XSFSTET1jyxMJucMrfnVi4=;
        b=bkXEQxkkc5FK0dcMSSF7jisE8/UDdLp0eWBQlstgnGZLWr2b/CllkUkrL5y4qUU+Qgne8w
        eCUR/btmAKq7cT5PeUed2b5Bgm3HCMz4K+m/qLeY+Cu1/7SsrQtnX67HABfLv/PFRHPQoo
        zbrU1GZMQ+a2RTrtffIGX7oWdR5ETd4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-ump80R-wPFyEeFi2IEDsFA-1; Fri, 20 Jan 2023 07:07:45 -0500
X-MC-Unique: ump80R-wPFyEeFi2IEDsFA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CEFE2280558F;
        Fri, 20 Jan 2023 12:07:44 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-208-34.brq.redhat.com [10.40.208.34])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9022B492B02;
        Fri, 20 Jan 2023 12:07:44 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 5B2D930721A6C;
        Fri, 20 Jan 2023 13:07:43 +0100 (CET)
Subject: [PATCH net-next V2] net: avoid irqsave in skb_defer_free_flush
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Date:   Fri, 20 Jan 2023 13:07:43 +0100
Message-ID: <167421646327.1321776.7390743166998776914.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The spin_lock irqsave/restore API variant in skb_defer_free_flush can
be replaced with the faster spin_lock irq variant, which doesn't need
to read and restore the CPU flags.

Using the unconditional irq "disable/enable" API variant is safe,
because the skb_defer_free_flush() function is only called during
NAPI-RX processing in net_rx_action(), where it is known the IRQs
are enabled.

Expected gain is 14 cycles from avoiding reading and restoring CPU
flags in a spin_lock_irqsave/restore operation, measured via a
microbencmark kernel module[1] on CPU E5-1650 v4 @ 3.60GHz.

Microbenchmark overhead of spin_lock+unlock:
 - spin_lock_unlock_irq     cost: 34 cycles(tsc)  9.486 ns
 - spin_lock_unlock_irqsave cost: 48 cycles(tsc) 13.567 ns

We don't expect to see a measurable packet performance gain, as
skb_defer_free_flush() is called infrequently once per NIC device NAPI
bulk cycle and conditionally only if SKBs have been deferred by other
CPUs via skb_attempt_defer_free().

[1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/time_bench_sample.c

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/dev.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index cf78f35bc0b9..9c60190fe352 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6616,17 +6616,16 @@ static int napi_threaded_poll(void *data)
 static void skb_defer_free_flush(struct softnet_data *sd)
 {
 	struct sk_buff *skb, *next;
-	unsigned long flags;
 
 	/* Paired with WRITE_ONCE() in skb_attempt_defer_free() */
 	if (!READ_ONCE(sd->defer_list))
 		return;
 
-	spin_lock_irqsave(&sd->defer_lock, flags);
+	spin_lock_irq(&sd->defer_lock);
 	skb = sd->defer_list;
 	sd->defer_list = NULL;
 	sd->defer_count = 0;
-	spin_unlock_irqrestore(&sd->defer_lock, flags);
+	spin_unlock_irq(&sd->defer_lock);
 
 	while (skb != NULL) {
 		next = skb->next;


