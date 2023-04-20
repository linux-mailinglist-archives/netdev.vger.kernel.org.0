Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECBEA6E919B
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 13:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234718AbjDTLFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 07:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235116AbjDTLEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 07:04:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A81776BB;
        Thu, 20 Apr 2023 04:03:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 190D6647C3;
        Thu, 20 Apr 2023 11:02:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850AFC433D2;
        Thu, 20 Apr 2023 11:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681988539;
        bh=hw4xNWiwp8slyxeG+kC8WnPTYTvoQBMrOBS9+9t7ozY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e0J8tkYUjcx9zrUeI+yQC7z7JQ00pXcrF7kWoBo9EyUIAmFRSpyJHaQrpSiFET/eE
         b9OeOlABXdPQLrh7HVA+mkCuGBzHJmqd7kR9TQW7lCavtgOC6nifgjMjbnZW+4407t
         3oqG1kT/dZoqqvh1hTLoZZlhlnigmZurkFfynfJIfs5FJOpLTxs9D3LOetofozcGDD
         S+1+enaNoYiC0YnU95M85DdvxB7PCwU/T22kLYR0L3xtSGcB9qpUSNvMcBx6V6qL/z
         Rb5ueq50DcD4orp2f6fTMgpn1OsqAbjXX8o9U1E3Lh1gGIPJzcNtSRzOaMy1QNHp42
         MYSlPY7SeZ8MA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Greear <greearb@candelatech.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Kalle Valo <kvalo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, ryder.lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com, deren.wu@mediatek.com,
        sean.wang@mediatek.com, mingyen.hsieh@mediatek.com,
        yn.chen@mediatek.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.2 11/17] wifi: mt76: mt7921: Fix use-after-free in fw features query.
Date:   Thu, 20 Apr 2023 07:01:40 -0400
Message-Id: <20230420110148.505779-11-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420110148.505779-1-sashal@kernel.org>
References: <20230420110148.505779-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Ben Greear <greearb@candelatech.com>

[ Upstream commit 2ceb76f734e37833824b7fab6af17c999eb48d2b ]

Stop referencing 'features' memory after release_firmware is called.

Fixes this crash:

RIP: 0010:mt7921_check_offload_capability+0x17d
mt7921_pci_probe+0xca/0x4b0
...

Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Acked-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/51fd8f76494348aa9ecbf0abc471ebe47a983dfd.1679502607.git.lorenzo@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/init.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index d4b681d7e1d22..f2c6ec4d8e2ee 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -162,12 +162,12 @@ mt7921_mac_init_band(struct mt7921_dev *dev, u8 band)
 
 u8 mt7921_check_offload_capability(struct device *dev, const char *fw_wm)
 {
-	struct mt7921_fw_features *features = NULL;
 	const struct mt76_connac2_fw_trailer *hdr;
 	struct mt7921_realease_info *rel_info;
 	const struct firmware *fw;
 	int ret, i, offset = 0;
 	const u8 *data, *end;
+	u8 offload_caps = 0;
 
 	ret = request_firmware(&fw, fw_wm, dev);
 	if (ret)
@@ -199,7 +199,10 @@ u8 mt7921_check_offload_capability(struct device *dev, const char *fw_wm)
 		data += sizeof(*rel_info);
 
 		if (rel_info->tag == MT7921_FW_TAG_FEATURE) {
+			struct mt7921_fw_features *features;
+
 			features = (struct mt7921_fw_features *)data;
+			offload_caps = features->data;
 			break;
 		}
 
@@ -209,7 +212,7 @@ u8 mt7921_check_offload_capability(struct device *dev, const char *fw_wm)
 out:
 	release_firmware(fw);
 
-	return features ? features->data : 0;
+	return offload_caps;
 }
 EXPORT_SYMBOL_GPL(mt7921_check_offload_capability);
 
-- 
2.39.2

