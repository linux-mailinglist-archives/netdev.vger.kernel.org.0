Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE9BD6D20CA
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 14:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbjCaMrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 08:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbjCaMrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 08:47:41 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22972063F
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 05:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CsmjTgEV6kFloiv2nSNJQ7iVO39BaGcPQE7Ysr1Ve5M=; b=Piq5Vu742q/i7TjQRniZkQMYAw
        0uCe5buWkTKs7lil83VY7ImPOJp7LDc0cp0kXZi1p+eoi7OmbMCIBy0ibVsi+snzl+wpiqcRPV80S
        rwiJnTXTUyu9dJbeA0feHYEWx1KcJuWnICj0VeIkD/VgxSknSWI7VEZQXDr1c6uMfcDQ=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1piE9s-008vKV-55
        for netdev@vger.kernel.org; Fri, 31 Mar 2023 14:47:08 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Subject: [PATCH v3 net-next 2/2] net: ethernet: mtk_eth_soc: mtk_ppe: prefer newly added l2 flows
Date:   Fri, 31 Mar 2023 14:47:07 +0200
Message-Id: <20230331124707.40296-2-nbd@nbd.name>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230331124707.40296-1-nbd@nbd.name>
References: <20230331124707.40296-1-nbd@nbd.name>
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

When a device is roaming between interfaces and a new flow entry is
created, we should assume that its output device is more up to date than
whatever entry existed already.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
v2: fix patch description
 drivers/net/ethernet/mediatek/mtk_ppe.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index f9c9f2ea4206..dd9581334b05 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -635,10 +635,20 @@ void mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 static int
 mtk_foe_entry_commit_l2(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 {
+	struct mtk_flow_entry *prev;
+
 	entry->type = MTK_FLOW_TYPE_L2;
 
-	return rhashtable_insert_fast(&ppe->l2_flows, &entry->l2_node,
-				      mtk_flow_l2_ht_params);
+	prev = rhashtable_lookup_get_insert_fast(&ppe->l2_flows, &entry->l2_node,
+						 mtk_flow_l2_ht_params);
+	if (likely(!prev))
+		return 0;
+
+	if (IS_ERR(prev))
+		return PTR_ERR(prev);
+
+	return rhashtable_replace_fast(&ppe->l2_flows, &prev->l2_node,
+				       &entry->l2_node, mtk_flow_l2_ht_params);
 }
 
 int mtk_foe_entry_commit(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
-- 
2.39.0

