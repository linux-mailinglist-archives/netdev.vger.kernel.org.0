Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCD350F620
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 10:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345724AbiDZIwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 04:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346847AbiDZIuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 04:50:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0243A17035F;
        Tue, 26 Apr 2022 01:39:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0F055CE1BBB;
        Tue, 26 Apr 2022 08:39:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB564C385A0;
        Tue, 26 Apr 2022 08:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962340;
        bh=4Wxgi3OSyAND3xCtQ83fZNlx1WUMKKBOUaA3R2KTe98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vs7OClKK8Ch9ScopDyKQM7F4nd7SBqqOBM413HPjZQie6Rum1B07zHQbWf33lhVKD
         0WzguPzk8yYXMxU/onieZoqcAmmsGeDLwx+DLMX7dj1mgyY5LA7xH/3B4OnpCxb+V2
         hTFivP2lwk6snZyDoxSxN9NyFxzToc5hoSH/2C8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/124] mt76: Fix undefined behavior due to shift overflowing the constant
Date:   Tue, 26 Apr 2022 10:21:04 +0200
Message-Id: <20220426081749.091859619@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
index adf288e50e21..5cd0379d86de 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
@@ -80,7 +80,7 @@ mt76x2e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mt76_rmw_field(dev, 0x15a10, 0x1f << 16, 0x9);
 
 	/* RG_SSUSB_G1_CDR_BIC_LTR = 0xf */
-	mt76_rmw_field(dev, 0x15a0c, 0xf << 28, 0xf);
+	mt76_rmw_field(dev, 0x15a0c, 0xfU << 28, 0xf);
 
 	/* RG_SSUSB_CDR_BR_PE1D = 0x3 */
 	mt76_rmw_field(dev, 0x15c58, 0x3 << 6, 0x3);
-- 
2.35.1



