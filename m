Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB426D045E
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 14:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbjC3MIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 08:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbjC3MIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 08:08:44 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DF75240
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 05:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zh+HIIxPkDiG5NAfP3sUWNvjoPplvO8Cu8OWI/NfDXE=; b=pgLsmp384JbLYX1/FPHl69Onrq
        09wU9mmH1dtNGv9hr/SrN40li14nu59LOFPN8KbuC95YQ/JqXN65Ly7qpQ8Eoneqs1SLAy8fbCQ6H
        5UTvfCNcqwA49zy5s0hBokMToHwyNO5UwGWt5R1uFgItqVY4ntFkghoT3sHy7QKnmg90=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1phr57-008WKJ-9e
        for netdev@vger.kernel.org; Thu, 30 Mar 2023 14:08:41 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Subject: [PATCH net v2 2/3] net: ethernet: mtk_eth_soc: fix L2 offloading with DSA untag offload
Date:   Thu, 30 Mar 2023 14:08:39 +0200
Message-Id: <20230330120840.52079-2-nbd@nbd.name>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230330120840.52079-1-nbd@nbd.name>
References: <20230330120840.52079-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check for skb metadata in order to detect the case where the DSA header
is not present.

Fixes: 2d7605a72906 ("net: ethernet: mtk_eth_soc: enable hardware DSA untagging")
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 6 +++---
 drivers/net/ethernet/mediatek/mtk_ppe.c     | 5 ++++-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 20d3e5ab1b2a..e14050e17862 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2058,9 +2058,6 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			skb_checksum_none_assert(skb);
 		skb->protocol = eth_type_trans(skb, netdev);
 
-		if (reason == MTK_PPE_CPU_REASON_HIT_UNBIND_RATE_REACHED)
-			mtk_ppe_check_skb(eth->ppe[0], skb, hash);
-
 		if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
 			if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
 				if (trxd.rxd3 & RX_DMA_VTAG_V2) {
@@ -2088,6 +2085,9 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 			__vlan_hwaccel_put_tag(skb, htons(vlan_proto), vlan_tci);
 		}
 
+		if (reason == MTK_PPE_CPU_REASON_HIT_UNBIND_RATE_REACHED)
+			mtk_ppe_check_skb(eth->ppe[0], skb, hash);
+
 		skb_record_rx_queue(skb, 0);
 		napi_gro_receive(napi, skb);
 
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 6883eb34cd8b..a038b99ecbda 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -8,6 +8,7 @@
 #include <linux/platform_device.h>
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
+#include <net/dst_metadata.h>
 #include <net/dsa.h>
 #include "mtk_eth_soc.h"
 #include "mtk_ppe.h"
@@ -699,7 +700,9 @@ void __mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash)
 		    skb->dev->dsa_ptr->tag_ops->proto != DSA_TAG_PROTO_MTK)
 			goto out;
 
-		tag += 4;
+		if (!skb_metadata_dst(skb))
+			tag += 4;
+
 		if (get_unaligned_be16(tag) != ETH_P_8021Q)
 			break;
 
-- 
2.39.0

