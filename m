Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E802323CE7
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 14:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235341AbhBXM6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 07:58:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:50940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235227AbhBXMwu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 07:52:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D268364F11;
        Wed, 24 Feb 2021 12:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171058;
        bh=C55yUIEY+idJC3u7aYC0wzE6M5fLtSGNPtLbMb/VWI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXz9GGfqfXaV23GrAMej6WCOZueJLq3FtJ4dVTqEzwclLj027zIwXMmuOp7eox5/y
         JsHg6FxnFyvlALP14NjgqCQiAS2KaIYP938GVUhL39+xgcWhMSRJGAkmiv95vNtwiC
         MYkAU7syvMzWk54qkBfklNfV7AQLLomg2vQM6Z4ticqa3wiG1J07Yvc/xugBRX7i/b
         sSyI3CXbOqB5HejanVCDA8iyf/ERA2+i5Kf76UB6rP1qxS8gr1pzd5FUpOx59JSGZ1
         Hg4FJMuL7oxZfNBy8DlzAd7nyWK1KV8nWqrcjzaKPr/yd8Lql0TdPeeou+tLg2jxlf
         c8xeklnGepgEw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 23/67] brcmfmac: Add DMI nvram filename quirk for Voyo winpad A15 tablet
Date:   Wed, 24 Feb 2021 07:49:41 -0500
Message-Id: <20210224125026.481804-23-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125026.481804-1-sashal@kernel.org>
References: <20210224125026.481804-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a338c874d3d9d2463f031e89ae14942929b93db6 ]

The Voyo winpad A15 tablet contains quite generic names in the sys_vendor
and product_name DMI strings, without this patch brcmfmac will try to load:
rcmfmac4330-sdio.To be filled by O.E.M.-To be filled by O.E.M..txt
as nvram file which is a bit too generic.

Add a DMI quirk so that a unique and clearly identifiable nvram file name
is used on the Voyo winpad A15 tablet.

While preparing a matching linux-firmware update I noticed that the nvram
is identical to the nvram used on the Prowise-PT301 tablet, so the new DMI
quirk entry simply points to the already existing Prowise-PT301 nvram file.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210129171413.139880-2-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/broadcom/brcm80211/brcmfmac/dmi.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
index 824a79f243830..6d5188b78f2de 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
@@ -44,6 +44,14 @@ static const struct brcmf_dmi_data predia_basic_data = {
 	BRCM_CC_43341_CHIP_ID, 2, "predia-basic"
 };
 
+/* Note the Voyo winpad A15 tablet uses the same Ampak AP6330 module, with the
+ * exact same nvram file as the Prowise-PT301 tablet. Since the nvram for the
+ * Prowise-PT301 is already in linux-firmware we just point to that here.
+ */
+static const struct brcmf_dmi_data voyo_winpad_a15_data = {
+	BRCM_CC_4330_CHIP_ID, 4, "Prowise-PT301"
+};
+
 static const struct dmi_system_id dmi_platform_data[] = {
 	{
 		/* ACEPC T8 Cherry Trail Z8350 mini PC */
@@ -125,6 +133,16 @@ static const struct dmi_system_id dmi_platform_data[] = {
 		},
 		.driver_data = (void *)&predia_basic_data,
 	},
+	{
+		/* Voyo winpad A15 tablet */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "Aptio CRB"),
+			/* Above strings are too generic, also match on BIOS date */
+			DMI_MATCH(DMI_BIOS_DATE, "11/20/2014"),
+		},
+		.driver_data = (void *)&voyo_winpad_a15_data,
+	},
 	{}
 };
 
-- 
2.27.0

