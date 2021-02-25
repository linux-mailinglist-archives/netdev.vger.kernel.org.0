Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D880325595
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 19:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbhBYSfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 13:35:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47412 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233671AbhBYSd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 13:33:29 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lFLRJ-0002oE-GG; Thu, 25 Feb 2021 18:32:41 +0000
From:   Colin King <colin.king@canonical.com>
To:     Jakub Kicinski <kubakici@wp.pl>, Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mt7601u: fix always true expression
Date:   Thu, 25 Feb 2021 18:32:41 +0000
Message-Id: <20210225183241.1002129-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the expression ~nic_conf1 is always true because nic_conf1
is a u16 and according to 6.5.3.3 of the C standard the ~ operator
promotes the u16 to an integer before flipping all the bits. Thus
the top 16 bits of the integer result are all set so the expression
is always true.  If the intention was to flip all the bits of nic_conf1
then casting the integer result back to a u16 is a suitabel fix.

Interestingly static analyzers seem to thing a bitwise ! should be
used instead of ~ for this scenario, so I think the original intent
of the expression may need some extra consideration.

Addresses-Coverity: ("Logical vs. bitwise operator")
Fixes: c869f77d6abb ("add mt7601u driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/mediatek/mt7601u/eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/eeprom.c b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
index c868582c5d22..aa3b64902cf9 100644
--- a/drivers/net/wireless/mediatek/mt7601u/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
@@ -99,7 +99,7 @@ mt7601u_has_tssi(struct mt7601u_dev *dev, u8 *eeprom)
 {
 	u16 nic_conf1 = get_unaligned_le16(eeprom + MT_EE_NIC_CONF_1);
 
-	return ~nic_conf1 && (nic_conf1 & MT_EE_NIC_CONF_1_TX_ALC_EN);
+	return (u16)~nic_conf1 && (nic_conf1 & MT_EE_NIC_CONF_1_TX_ALC_EN);
 }
 
 static void
-- 
2.30.0

