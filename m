Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3217A490A5E
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 15:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239863AbiAQObI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 09:31:08 -0500
Received: from marcansoft.com ([212.63.210.85]:55880 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239253AbiAQOas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jan 2022 09:30:48 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id EF4854219F;
        Mon, 17 Jan 2022 14:30:38 +0000 (UTC)
From:   Hector Martin <marcan@marcan.st>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: [PATCH v3 3/9] brcmfmac: firmware: Do not crash on a NULL board_type
Date:   Mon, 17 Jan 2022 23:29:13 +0900
Message-Id: <20220117142919.207370-4-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220117142919.207370-1-marcan@marcan.st>
References: <20220117142919.207370-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This unbreaks support for USB devices, which do not have a board_type
to create an alt_path out of and thus were running into a NULL
dereference.

Fixes: 5ff013914c62 ("brcmfmac: firmware: Allow per-board firmware binaries")
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 1001c8888bfe..63821856bbe1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -599,6 +599,9 @@ static char *brcm_alt_fw_path(const char *path, const char *board_type)
 	char alt_path[BRCMF_FW_NAME_LEN];
 	char suffix[5];
 
+	if (!board_type)
+		return NULL;
+
 	strscpy(alt_path, path, BRCMF_FW_NAME_LEN);
 	/* At least one character + suffix */
 	if (strlen(alt_path) < 5)
-- 
2.33.0

