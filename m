Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 030946D045D
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 14:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231391AbjC3MIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 08:08:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbjC3MIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 08:08:44 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9525B8E
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 05:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8Yi98WnnEZXeSa4ie4gS+ln51EB8FzcJXqLs2igmflI=; b=W+/hdCRNnYnIMemrRmIyrLmyRo
        2Bn6MvH5eND+f3WZNrO08ywl1NNjS/VR9TXC+AllA7NXv0B7m69vt2v1418uIE0xaZQx1aIhcQKbm
        pJPgrylWZReTXlF7kbpPU1kjGlTy+EmRx+5955iUSKOb+LogzIyAbZolAyDd2GPdNsJo=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1phr57-008WKJ-G4
        for netdev@vger.kernel.org; Thu, 30 Mar 2023 14:08:41 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org
Subject: [PATCH net v2 3/3] net: ethernet: mtk_eth_soc: add missing ppe cache flush when deleting a flow
Date:   Thu, 30 Mar 2023 14:08:40 +0200
Message-Id: <20230330120840.52079-3-nbd@nbd.name>
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

The cache needs to be flushed to ensure that the hardware stops offloading
the flow immediately.

Fixes: 33fc42de3327 ("net: ethernet: mtk_eth_soc: support creating mac address based offload entries")
Reviewed-by: Simon Horman <simon.horman@corigine.com>
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

