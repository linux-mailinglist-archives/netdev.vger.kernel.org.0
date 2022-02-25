Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF884C421C
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 11:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239405AbiBYKTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 05:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239386AbiBYKS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 05:18:57 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9212119F444;
        Fri, 25 Feb 2022 02:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=M6t65cwOUuBGDbHJK0sMurL9y2EPfQSv/Exhw8Fx+nA=; b=hej7Bda+3BCyQ5s97vFrY++P5n
        70iuaMdcped/cDKvjuZck3P/NjieODF7pDy/Et86ThFC3tva/IeM8fmaG4ZxHa84HqY0bAGBAhwTy
        pnGIvmXGS2OFhEJptHBqiDQWsw1v8GDlQ+I0EjoOBIboLGcPSAQJArUqftrY7r3ewNLI=;
Received: from p200300daa7204f00f847964d075b2b3d.dip0.t-ipconnect.de ([2003:da:a720:4f00:f847:964d:75b:2b3d] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1nNXg1-0007J1-VK; Fri, 25 Feb 2022 11:18:18 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     David Bentham <db260179@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/11] net: ethernet: mtk_eth_soc: add ipv6 flow offload support
Date:   Fri, 25 Feb 2022 11:18:05 +0100
Message-Id: <20220225101811.72103-7-nbd@nbd.name>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
In-Reply-To: <20220225101811.72103-1-nbd@nbd.name>
References: <20220225101811.72103-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Bentham <db260179@gmail.com>

Add the missing IPv6 flow offloading support for routing only.
Hardware flow offloading is done by the packet processing engine (PPE)
of the Ethernet MAC and as it doesn't support mangling of IPv6 packets,
IPv6 NAT cannot be supported.

Signed-off-by: David Bentham <db260179@gmail.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/ethernet/mediatek/mtk_ppe_offload.c   | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index bcf342bb9051..0113cddcebf4 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -6,6 +6,7 @@
 #include <linux/if_ether.h>
 #include <linux/rhashtable.h>
 #include <linux/ip.h>
+#include <linux/ipv6.h>
 #include <net/flow_offload.h>
 #include <net/pkt_cls.h>
 #include <net/dsa.h>
@@ -20,6 +21,11 @@ struct mtk_flow_data {
 			__be32 src_addr;
 			__be32 dst_addr;
 		} v4;
+
+		struct {
+			struct in6_addr src_addr;
+			struct in6_addr dst_addr;
+		} v6;
 	};
 
 	__be16 src_port;
@@ -65,6 +71,14 @@ mtk_flow_set_ipv4_addr(struct mtk_foe_entry *foe, struct mtk_flow_data *data,
 					    data->v4.dst_addr, data->dst_port);
 }
 
+static int
+mtk_flow_set_ipv6_addr(struct mtk_foe_entry *foe, struct mtk_flow_data *data)
+{
+	return mtk_foe_entry_set_ipv6_tuple(foe,
+					    data->v6.src_addr.s6_addr32, data->src_port,
+					    data->v6.dst_addr.s6_addr32, data->dst_port);
+}
+
 static void
 mtk_flow_offload_mangle_eth(const struct flow_action_entry *act, void *eth)
 {
@@ -296,6 +310,9 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 	case FLOW_DISSECTOR_KEY_IPV4_ADDRS:
 		offload_type = MTK_PPE_PKT_TYPE_IPV4_HNAPT;
 		break;
+	case FLOW_DISSECTOR_KEY_IPV6_ADDRS:
+		offload_type = MTK_PPE_PKT_TYPE_IPV6_ROUTE_5T;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -331,6 +348,17 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 		mtk_flow_set_ipv4_addr(&foe, &data, false);
 	}
 
+	if (addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
+		struct flow_match_ipv6_addrs addrs;
+
+		flow_rule_match_ipv6_addrs(rule, &addrs);
+
+		data.v6.src_addr = addrs.key->src;
+		data.v6.dst_addr = addrs.key->dst;
+
+		mtk_flow_set_ipv6_addr(&foe, &data);
+	}
+
 	flow_action_for_each(i, act, &rule->action) {
 		if (act->id != FLOW_ACTION_MANGLE)
 			continue;
-- 
2.32.0 (Apple Git-132)

