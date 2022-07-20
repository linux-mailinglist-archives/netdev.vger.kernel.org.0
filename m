Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B2557AB9A
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 03:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240705AbiGTBOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 21:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240434AbiGTBNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 21:13:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA366715F;
        Tue, 19 Jul 2022 18:12:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E391E6174C;
        Wed, 20 Jul 2022 01:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979DCC341CB;
        Wed, 20 Jul 2022 01:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279569;
        bh=o/87EYz9U4fJ7ak5Y23ib5Mkj/giQielN245gdpiIMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DPWmSt4VopaSKy8gGTgDc/YsyoV5KOn/WHrG4L5drzQ96Rwb8zV3Zeq0MlAP6OYLy
         Lhupphb9EBT7xgr7EKQYYs25DRfP4V3xeACNI6GhEWB89m/UJ3LBFLOglw0mP1kmiC
         ePeF3F4U/hupQnnIbW5CcIniwKOH16ryDhq9l2eIFeneFqL2D0zFX+vWKwaSF11yQJ
         lEV41XoIdYjUNovyBwnJhDy4d3VDUcIscgz2dLHK3FF8y6hI42wzZoQnVStH9OSF39
         ZBsCgUtLgnuf4V5NYYX3285/2X2fMhtdRAPp6+fug7Yt3gRAMapPFmwNf39TnITBVu
         VbZTZQ5fTa50g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        bigeasy@linutronix.de, imagedong@tencent.com, petrm@nvidia.com,
        arnd@arndb.de, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 34/54] xdp: Fix spurious packet loss in generic XDP TX path
Date:   Tue, 19 Jul 2022 21:10:11 -0400
Message-Id: <20220720011031.1023305-34-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011031.1023305-1-sashal@kernel.org>
References: <20220720011031.1023305-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Almbladh <johan.almbladh@anyfinetworks.com>

[ Upstream commit 1fd6e5675336daf4747940b4285e84b0c114ae32 ]

The byte queue limits (BQL) mechanism is intended to move queuing from
the driver to the network stack in order to reduce latency caused by
excessive queuing in hardware. However, when transmitting or redirecting
a packet using generic XDP, the qdisc layer is bypassed and there are no
additional queues. Since netif_xmit_stopped() also takes BQL limits into
account, but without having any alternative queuing, packets are
silently dropped.

This patch modifies the drop condition to only consider cases when the
driver itself cannot accept any more packets. This is analogous to the
condition in __dev_direct_xmit(). Dropped packets are also counted on
the device.

Bypassing the qdisc layer in the generic XDP TX path means that XDP
packets are able to starve other packets going through a qdisc, and
DDOS attacks will be more effective. In-driver-XDP use dedicated TX
queues, so they do not have this starvation issue.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220705082345.2494312-1-johan.almbladh@anyfinetworks.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 842917883adb..c908d1b3e3bd 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4792,7 +4792,10 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 }
 
 /* When doing generic XDP we have to bypass the qdisc layer and the
- * network taps in order to match in-driver-XDP behavior.
+ * network taps in order to match in-driver-XDP behavior. This also means
+ * that XDP packets are able to starve other packets going through a qdisc,
+ * and DDOS attacks will be more effective. In-driver-XDP use dedicated TX
+ * queues, so they do not have this starvation issue.
  */
 void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog)
 {
@@ -4804,7 +4807,7 @@ void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog)
 	txq = netdev_core_pick_tx(dev, skb, NULL);
 	cpu = smp_processor_id();
 	HARD_TX_LOCK(dev, txq, cpu);
-	if (!netif_xmit_stopped(txq)) {
+	if (!netif_xmit_frozen_or_drv_stopped(txq)) {
 		rc = netdev_start_xmit(skb, dev, txq, 0);
 		if (dev_xmit_complete(rc))
 			free_skb = false;
@@ -4812,6 +4815,7 @@ void generic_xdp_tx(struct sk_buff *skb, struct bpf_prog *xdp_prog)
 	HARD_TX_UNLOCK(dev, txq);
 	if (free_skb) {
 		trace_xdp_exception(dev, xdp_prog, XDP_TX);
+		dev_core_stats_tx_dropped_inc(dev);
 		kfree_skb(skb);
 	}
 }
-- 
2.35.1

