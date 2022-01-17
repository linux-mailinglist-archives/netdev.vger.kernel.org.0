Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03ECA490A6B
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 15:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239963AbiAQObj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 09:31:39 -0500
Received: from marcansoft.com ([212.63.210.85]:56132 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239983AbiAQObV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jan 2022 09:31:21 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 4E31A42137;
        Mon, 17 Jan 2022 14:31:11 +0000 (UTC)
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
Subject: [PATCH v3 7/9] brcmfmac: of: Use devm_kstrdup for board_type & check for errors
Date:   Mon, 17 Jan 2022 23:29:17 +0900
Message-Id: <20220117142919.207370-8-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220117142919.207370-1-marcan@marcan.st>
References: <20220117142919.207370-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This was missing a NULL check, and we can collapse the strlen/alloc/copy
into a devm_kstrdup().

Signed-off-by: Hector Martin <marcan@marcan.st>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index 513c7e6421b2..5dc1e942e9e7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -79,8 +79,12 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 
 		/* get rid of '/' in the compatible string to be able to find the FW */
 		len = strlen(tmp) + 1;
-		board_type = devm_kzalloc(dev, len, GFP_KERNEL);
-		strscpy(board_type, tmp, len);
+		board_type = devm_kstrdup(dev, tmp, GFP_KERNEL);
+		if (!board_type) {
+			brcmf_err("out of memory allocating board_type\n");
+			of_node_put(root);
+			return;
+		}
 		for (i = 0; i < board_type[i]; i++) {
 			if (board_type[i] == '/')
 				board_type[i] = '-';
-- 
2.33.0

