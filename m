Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA09343FD3
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 12:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbhCVLbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 07:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbhCVLar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 07:30:47 -0400
Received: from mxwww.masterlogin.de (mxwww.masterlogin.de [IPv6:2a03:2900:1:1::a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDC9C061574;
        Mon, 22 Mar 2021 04:30:46 -0700 (PDT)
Received: from mxout4.routing.net (unknown [192.168.10.112])
        by backup.mxwww.masterlogin.de (Postfix) with ESMTPS id E889C2C51F;
        Mon, 22 Mar 2021 11:21:46 +0000 (UTC)
Received: from mxbox3.masterlogin.de (unknown [192.168.10.78])
        by mxout4.routing.net (Postfix) with ESMTP id 692E51007B4;
        Mon, 22 Mar 2021 11:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1616412101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XYeVx8d4LjQCrMjqtdwToyONIZtgo42NmTTPNbi924c=;
        b=ug9Ij2wqVs5oPGAjn8m8HMPznXHwXLmTNqJMlob3uRaB5fQPY/2E12aV+pZc65+yxC+9RN
        WubOvEBS1NhliP5ZGYApPt/8Jl9tPaMzERFP8zbW/sEE+W6xkM8Fv3SKrKtqSpskAZTkmf
        aZAiDp/JC2BNK0qNoJQZnAU1d7JKV6c=
Received: from localhost.localdomain (unknown [80.245.73.88])
        by mxbox3.masterlogin.de (Postfix) with ESMTPSA id B761436010D;
        Mon, 22 Mar 2021 11:21:40 +0000 (UTC)
From:   Frank Wunderlich <linux@fw-web.de>
To:     linux-mediatek@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] [RFC] net: ethernet: mtk_eth_soc: add ipv6 flow offload support
Date:   Mon, 22 Mar 2021 12:21:17 +0100
Message-Id: <20210322112117.16162-3-linux@fw-web.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210322112117.16162-1-linux@fw-web.de>
References: <20210322112117.16162-1-linux@fw-web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mail-ID: ce223c4d-bd77-4263-a479-9b2339e766b7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

adding ipv6 hardware offload support

patch by user graphine (https://github.com/graphine27/)
http://forum.banana-pi.org/u/graphine/summary

Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
---
 .../net/ethernet/mediatek/mtk_ppe_offload.c   | 55 +++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index d0c46786571f..29cf0eb25a22 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -7,6 +7,7 @@
 #include <linux/rhashtable.h>
 #include <linux/if_ether.h>
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
@@ -64,6 +70,14 @@ mtk_flow_set_ipv4_addr(struct mtk_foe_entry *foe, struct mtk_flow_data *data,
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
@@ -127,6 +141,29 @@ mtk_flow_mangle_ipv4(const struct flow_action_entry *act,
 	return 0;
 }
 
+static int
+mtk_flow_mangle_ipv6(const struct flow_action_entry *act,
+		     struct mtk_flow_data *data)
+{
+	__be32 *dest;
+	size_t offset_of_ip6_daddr = offsetof(struct ipv6hdr, daddr);
+	size_t offset_of_ip6_saddr = offsetof(struct ipv6hdr, saddr);
+	u32 idx;
+
+	if (act->mangle.offset >= offset_of_ip6_daddr && act->mangle.offset < offset_of_ip6_daddr) {
+		idx = (act->mangle.offset - offset_of_ip6_saddr) / 4;
+		dest = &data->v6.src_addr.s6_addr32[idx];
+	} else if (act->mangle.offset >= offset_of_ip6_daddr &&
+		   act->mangle.offset < offset_of_ip6_daddr + 16) {
+		idx = (act->mangle.offset - offset_of_ip6_daddr) / 4;
+		dest = &data->v6.dst_addr.s6_addr32[idx];
+	}
+
+	memcpy(dest, &act->mangle.val, sizeof(u32));
+
+	return 0;
+}
+
 static int
 mtk_flow_get_dsa_port(struct net_device **dev)
 {
@@ -249,6 +286,9 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 	case FLOW_DISSECTOR_KEY_IPV4_ADDRS:
 		offload_type = MTK_PPE_PKT_TYPE_IPV4_HNAPT;
 		break;
+	case FLOW_DISSECTOR_KEY_IPV6_ADDRS:
+		offload_type = MTK_PPE_PKT_TYPE_IPV6_ROUTE_5T;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -284,6 +324,18 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 		mtk_flow_set_ipv4_addr(&foe, &data, false);
 	}
 
+
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
@@ -296,6 +348,9 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct flow_cls_offload *f)
 		case FLOW_ACT_MANGLE_HDR_TYPE_IP4:
 			err = mtk_flow_mangle_ipv4(act, &data);
 			break;
+		case FLOW_ACT_MANGLE_HDR_TYPE_IP6:
+			err = mtk_flow_mangle_ipv6(act, &data);
+			break;
 		case FLOW_ACT_MANGLE_HDR_TYPE_ETH:
 			/* handled earlier */
 			break;
-- 
2.25.1

