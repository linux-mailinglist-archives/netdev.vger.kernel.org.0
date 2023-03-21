Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56CE16C3304
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 14:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjCUNgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 09:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjCUNgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 09:36:13 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC21410BD
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 06:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hQpztYzTvPWuMgtfhUP/XQkoQAhcdWqfTvxwZgO1478=; b=ArsdVY3M6jC+lRt39f82zp3wvv
        go3hIDlbh6BKscGtwG0LtE217U0vvJtl1LbhpCzOVGFzJ+N6GsBCTDKROiD1UYu+VAGiSLxUYUINJ
        9IWtT8nS3rydswPltvVV2KBQJFIc8sfewOByvHazazjfGCvbhYSfI6gW99F2Qn/I1Br0=;
Received: from [217.114.218.22] (helo=localhost.localdomain)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pec9q-005Liy-1c
        for netdev@vger.kernel.org; Tue, 21 Mar 2023 14:36:10 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] net: ethernet: mediatek: mtk_ppe: prefer newly added l2 flows over existing ones
Date:   Tue, 21 Mar 2023 14:36:09 +0100
Message-Id: <20230321133609.49591-2-nbd@nbd.name>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230321133609.49591-1-nbd@nbd.name>
References: <20230321133609.49591-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a device is roaming between interfaces and a new flow entry is created,
we should assume that its output device is more up to date than whatever
entry existed already.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_ppe.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 6883eb34cd8b..5e150007bb7d 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -580,10 +580,20 @@ void mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
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

