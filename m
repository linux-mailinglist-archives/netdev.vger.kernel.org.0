Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A53665E65
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 15:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbjAKOvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 09:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbjAKOvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 09:51:25 -0500
Received: from wizmail.org (wizmail.org [85.158.153.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B492B18689
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 06:51:24 -0800 (PST)
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=wizmail.org; s=e202001; h=Content-Transfer-Encoding:MIME-Version:References
        :In-Reply-To:Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive:
        Autocrypt; bh=3+CQfwVwEGyUTJszb1A4+bgPKX5sA46Wdfx5jhzLUxg=; b=YDWq/FlPZOBCI2d
        /4xiIUxFznpnGXJNmjaGbc20mcOuT5AfDlIzJQoEdGjSZsZuwm7qiPRg3NtagSSIz90eYDg==;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=wizmail.org
        ; s=r202001; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive:
        Autocrypt; bh=3+CQfwVwEGyUTJszb1A4+bgPKX5sA46Wdfx5jhzLUxg=; b=doPpMy8McZxjT0A
        q2w6jet7eBIDJMP+PThTjC+JzGPQowxln119BxF3DW/G8O680Ah/TCexD2l2ZHkdMWpsucsGrjL4g
        E2eQvrRjNtnp42QFBiwWU1iOEafk6NvZzFmbJI/u1DWR8589/NOo6TA6VPlyT6uHVf46j3elRuJK1
        ltAaVX2x1Kt3SdPETbx3GnVF3dCCYsTdehOAoDMSFLb84EuX3xQciFdLlGHO/c5p0DHCIPQSZ/fhY
        k3VC2dc8isKbTBs173VJxDeAI/oIw7x63XeXTh0OCu9YtO/XeMsjgbdGWGd8BIlxVkEXkgIMzd+Fn
        kKmlIfhPcHsrGYUg7+A==;
Authentication-Results: wizmail.org;
        local=pass (non-smtp, wizmail.org) u=root
Received: from root
        by [] (Exim 4.96.108)
        with local
        id 1pFcBW-004jFJ-1K
        (return-path <root@w81.gulag.org.uk>);
        Wed, 11 Jan 2023 14:34:34 +0000
From:   jgh@redhat.com
To:     netdev@vger.kernel.org
Cc:     Jeremy Harris <jgh@redhat.com>
Subject: [RFC PATCH 3/7] drivers: net: xgene: NIC driver Rx ring ECN
Date:   Wed, 11 Jan 2023 14:34:23 +0000
Message-Id: <20230111143427.1127174-4-jgh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230111143427.1127174-1-jgh@redhat.com>
References: <20230111143427.1127174-1-jgh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Harris <jgh@redhat.com>

Sample NIC driver support.
This is the preferred model, usable where the driver has explicit
knowlege of the receive ring size and fill count.

Signed-off-by: Jeremy Harris <jgh@redhat.com>
---
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 390671640388..4f48f5a8ea8b 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -667,7 +667,8 @@ static bool xgene_enet_errata_10GE_8(struct sk_buff *skb, u32 len, u8 status)
 
 static int xgene_enet_rx_frame(struct xgene_enet_desc_ring *rx_ring,
 			       struct xgene_enet_raw_desc *raw_desc,
-			       struct xgene_enet_raw_desc *exp_desc)
+			       struct xgene_enet_raw_desc *exp_desc,
+			       bool congestion)
 {
 	struct xgene_enet_desc_ring *buf_pool, *page_pool;
 	u32 datalen, frag_size, skb_index;
@@ -757,6 +758,7 @@ static int xgene_enet_rx_frame(struct xgene_enet_desc_ring *rx_ring,
 
 	rx_ring->rx_packets++;
 	rx_ring->rx_bytes += datalen;
+	skb->congestion_experienced = congestion;
 	napi_gro_receive(&rx_ring->napi, skb);
 
 out:
@@ -814,7 +816,9 @@ static int xgene_enet_process_ring(struct xgene_enet_desc_ring *ring,
 			desc_count++;
 		}
 		if (is_rx_desc(raw_desc)) {
-			ret = xgene_enet_rx_frame(ring, raw_desc, exp_desc);
+			/* We are congested when the ring is 7/8'ths full
+			 */
+			ret = xgene_enet_rx_frame(ring, raw_desc, exp_desc, count > slots * 7 / 8);
 		} else {
 			ret = xgene_enet_tx_completion(ring, raw_desc);
 			is_completion = true;
-- 
2.39.0

