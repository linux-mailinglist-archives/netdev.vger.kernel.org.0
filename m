Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C683D323CD6
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 14:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235470AbhBXM4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 07:56:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:50206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234713AbhBXMwY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 07:52:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55DF164F08;
        Wed, 24 Feb 2021 12:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171057;
        bh=wSLg7UG1E0Bc3+E/7Mg/ToevwJcWlTFMn4NDpoHxxEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r2ia6iCCDWfRKpGroGjbfaRr8YYC2ilUzShMOhQ4bbpi5gD+LDAHXrcOxqtIhNDP/
         vMPdKqJpoxLNhCm6RDk8mrTDBL9QnuQq8vc1gOkMGS5ojhy099Rj2mtGcWlJ1qBSIk
         bgwCz7ThcE1oInRneynUpfT3wKuiS6nVw8pNIoxvKqa7lQX7beFPz9gCmxA9jHAdFF
         x+XeQNkTKxyR3ICriPssnyzDuWQFpj2JuKJpcwCxvWL4l3c8Ufzv9U6wy7XCqQt1BF
         lO4X+PGzUjpqeNNkLotJpxxw1jmnLrisjEupbL4UmIRnR+bDp3JrGtXf7iUsaYmCc1
         IxDjogblD8O8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 22/67] brcmfmac: Add DMI nvram filename quirk for Predia Basic tablet
Date:   Wed, 24 Feb 2021 07:49:40 -0500
Message-Id: <20210224125026.481804-22-sashal@kernel.org>
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

[ Upstream commit af4b3a6f36d6c2fc5fca026bccf45e0fdcabddd9 ]

The Predia Basic tablet contains quite generic names in the sys_vendor and
product_name DMI strings, without this patch brcmfmac will try to load:
brcmfmac43340-sdio.Insyde-CherryTrail.txt as nvram file which is a bit
too generic.

Add a DMI quirk so that a unique and clearly identifiable nvram file name
is used on the Predia Basic tablet.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210129171413.139880-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/dmi.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
index 4aa2561934d77..824a79f243830 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
@@ -40,6 +40,10 @@ static const struct brcmf_dmi_data pov_tab_p1006w_data = {
 	BRCM_CC_43340_CHIP_ID, 2, "pov-tab-p1006w-data"
 };
 
+static const struct brcmf_dmi_data predia_basic_data = {
+	BRCM_CC_43341_CHIP_ID, 2, "predia-basic"
+};
+
 static const struct dmi_system_id dmi_platform_data[] = {
 	{
 		/* ACEPC T8 Cherry Trail Z8350 mini PC */
@@ -111,6 +115,16 @@ static const struct dmi_system_id dmi_platform_data[] = {
 		},
 		.driver_data = (void *)&pov_tab_p1006w_data,
 	},
+	{
+		/* Predia Basic tablet (+ with keyboard dock) */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Insyde"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "CherryTrail"),
+			/* Mx.WT107.KUBNGEA02 with the version-nr dropped */
+			DMI_MATCH(DMI_BIOS_VERSION, "Mx.WT107.KUBNGEA"),
+		},
+		.driver_data = (void *)&predia_basic_data,
+	},
 	{}
 };
 
-- 
2.27.0

