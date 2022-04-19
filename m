Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A88F50780A
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 20:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356776AbiDSSYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 14:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357295AbiDSSXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 14:23:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4783EA80;
        Tue, 19 Apr 2022 11:15:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4A1DB818FE;
        Tue, 19 Apr 2022 18:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B2BC385A7;
        Tue, 19 Apr 2022 18:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650392141;
        bh=IcmxqFD2X9nhz3AXQeNNFZ8G21v+9P1J/I/J4ImEWk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oayH0Ua0wJgFN3FOUwQ+VYHKtsID0fDFlD07l6P8qr2tlGnVB9Qa9p/4DCYlh7Kn0
         M4pEg9bOIFAv7LQeCIEOt6xXpX9iV0zUpghOL8+ynQ4dSWXeAcFfwpqpRFgkOZo1z5
         hiqyZWw3Nf/vpeD8e+7KL/zXePM7osJ5YgiXOTAFJdWYW761/31GcnJYM0YS+R2eMz
         PAjBAj48JlNYTyO2UeNi7XqBJmFFLD1ZaGdXGy4WBXryJoMIX/wTIqO7FCpVgXHrb3
         +uk/XjQuTUUWddGQ++TuLi4dlA7nocvmBYNIgiW2rvNqDShbXgx6+PjI1WF4HvX+aY
         BAwFzwnWJMAdg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Borislav Petkov <bp@suse.de>, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>, lorenzo@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 07/12] mt76: Fix undefined behavior due to shift overflowing the constant
Date:   Tue, 19 Apr 2022 14:15:20 -0400
Message-Id: <20220419181525.486166-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220419181525.486166-1-sashal@kernel.org>
References: <20220419181525.486166-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit dbc2b1764734857d68425468ffa8486e97ab89df ]

Fix:

  drivers/net/wireless/mediatek/mt76/mt76x2/pci.c: In function ‘mt76x2e_probe’:
  ././include/linux/compiler_types.h:352:38: error: call to ‘__compiletime_assert_946’ \
	declared with attribute error: FIELD_PREP: mask is not constant
    _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)

See https://lore.kernel.org/r/YkwQ6%2BtIH8GQpuct@zn.tnic for the gory
details as to why it triggers with older gccs only.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Felix Fietkau <nbd@nbd.name>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: Ryder Lee <ryder.lee@mediatek.com>
Cc: Shayne Chen <shayne.chen@mediatek.com>
Cc: Sean Wang <sean.wang@mediatek.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220405151517.29753-9-bp@alien8.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_pci.c b/drivers/net/wireless/mediatek/mt76/mt76x2_pci.c
index 26cfda24ce08..e26947f89299 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_pci.c
@@ -73,7 +73,7 @@ mt76pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mt76_rmw_field(dev, 0x15a10, 0x1f << 16, 0x9);
 
 	/* RG_SSUSB_G1_CDR_BIC_LTR = 0xf */
-	mt76_rmw_field(dev, 0x15a0c, 0xf << 28, 0xf);
+	mt76_rmw_field(dev, 0x15a0c, 0xfU << 28, 0xf);
 
 	/* RG_SSUSB_CDR_BR_PE1D = 0x3 */
 	mt76_rmw_field(dev, 0x15c58, 0x3 << 6, 0x3);
-- 
2.35.1

