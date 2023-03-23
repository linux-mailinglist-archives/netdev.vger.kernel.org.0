Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450C76C6925
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 14:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbjCWNIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 09:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjCWNIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 09:08:35 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D85B450
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 06:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KA2oH1SDRmplQJUEe4rTRO2Ooiicz6rXc3GsgXPN5Ok=; b=n5oL9+qSRpq2IT2jkXX3PKu0+j
        N1qAzaNOzWeBbwusQC9uUg1MY0m6ROIVv+wDpiZVH85GyUtSyXHBIQV5/N49iIKdG7R3SrjWb6pLJ
        xAaceEjNuExkapDRUK3OKo/mth8miPk3VHQsPZMVCIvLqxwOrtxS6rI0ay/2qZizJlFQ=;
Received: from [217.114.218.29] (helo=localhost.localdomain)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pfKfw-0062oc-Tw
        for netdev@vger.kernel.org; Thu, 23 Mar 2023 14:08:17 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Subject: [PATCH v2 3/3] net: ethernet: mtk_eth_soc: add missing ppe cache flush when deleting a flow
Date:   Thu, 23 Mar 2023 14:08:15 +0100
Message-Id: <20230323130815.7753-3-nbd@nbd.name>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230323130815.7753-1-nbd@nbd.name>
References: <20230323130815.7753-1-nbd@nbd.name>
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

The cache needs to be flushed to ensure that the hardware stops offloading
the flow immediately.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/ethernet/mediatek/mtk_ppe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index a038b99ecbda..fd07d6e14273 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -459,6 +459,7 @@ __mtk_foe_entry_clear(struct mtk_ppe *ppe, struct mtk_flow_entry *entry)
 		hwe->ib1 &= ~MTK_FOE_IB1_STATE;
 		hwe->ib1 |= FIELD_PREP(MTK_FOE_IB1_STATE, MTK_FOE_STATE_INVALID);
 		dma_wmb();
+		mtk_ppe_cache_clear(ppe);
 	}
 	entry->hash = 0xffff;
 
-- 
2.39.0

