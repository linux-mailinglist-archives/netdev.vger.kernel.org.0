Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821FB5AD310
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 14:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238283AbiIEMoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 08:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238462AbiIEMnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 08:43:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D671C2BFC
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 05:42:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A9F8B81132
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 12:42:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D98EC433D6;
        Mon,  5 Sep 2022 12:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662381719;
        bh=A3Dk0C+/NFeEaI2QcQ57zIr68Wf8F5QyJBIX1DLuFNo=;
        h=From:To:Cc:Subject:Date:From;
        b=HVS+cN1ij3/dhZkBHIa89J/DU9v5eXplWO4sWk3ELS/TNY0AHROe7VILJiZnbNV1s
         ol/18k4MVqNpvgL/toMIbS3vnMBun9CvAs3/kIrODGCE0/naGxPwiE5twEt5e1hxFA
         NRP/1IY1yojgWfKl8QnCaPdOeSvrhbh1OKHhW1CUltRW+lbQg7DR0C7F7d4h1PmX8d
         Bl6IBunhPz/7gOp4L4cGLARR8n4D+4Jiw9TCl9Artx7h5sZPvrOZ3YfMkM2Ba0Rad1
         7LwCK/KnA8PdQYtQXW0HkBoEQyvkB2aMMDrZ+Ex+C+MJGDS2Rha2ytRSMJsdqZPkpG
         6Sey3CPHtnqNw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com
Subject: [PATCH net] net: ethernet: mtk_eth_soc: check max allowed hash in mtk_ppe_check_skb
Date:   Mon,  5 Sep 2022 14:41:28 +0200
Message-Id: <b9f18ec4dd40d53b401a1b9935999bf025f3357d.1662381450.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even if max hash configured in hw in mtk_ppe_hash_entry is
MTK_PPE_ENTRIES - 1, check theoretical OOB accesses in
mtk_ppe_check_skb routine

Fixes: c4f033d9e03e9 ("net: ethernet: mtk_eth_soc: rework hardware flow table management")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_ppe.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethernet/mediatek/mtk_ppe.h
index 1f5cf1c9a947..69ffce04d630 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
@@ -293,6 +293,9 @@ mtk_ppe_check_skb(struct mtk_ppe *ppe, struct sk_buff *skb, u16 hash)
 	if (!ppe)
 		return;
 
+	if (hash > MTK_PPE_HASH_MASK)
+		return;
+
 	now = (u16)jiffies;
 	diff = now - ppe->foe_check_time[hash];
 	if (diff < HZ / 10)
-- 
2.37.3

