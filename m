Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C464320A2A1
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 18:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405809AbgFYQHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 12:07:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:52176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403863AbgFYQHn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 12:07:43 -0400
Received: from ziggy.de (unknown [213.195.114.138])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0396E2082F;
        Thu, 25 Jun 2020 16:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593101263;
        bh=QubKcWc+CTAGsj/zoI+CVXhnO4FPR3/tYHewrnyJwXQ=;
        h=From:To:Cc:Subject:Date:From;
        b=lYZ6hFaNv/WLDbYsEQ2xr/TmakMNyTlO8fwWj9FdUcFXRBrK7Lnb7oDBcN4sImSR8
         64q9gZZzKSiT05qa2cSzk3chMrKJ7bdjgu9BYfUmSkNnItnMewiPHUfQEV9fboDn4c
         cU4toUHFA+Om/IMeK+n5KXxV6kLoyNAA1g/CgVss=
From:   matthias.bgg@kernel.org
To:     arend.vanspriel@broadcom.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        chi-hsien.lin@cypress.com, wright.feng@cypress.com,
        mbrugger@suse.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, matthias.bgg@kernel.org,
        hdegoede@redhat.com
Subject: [PATCH] brcmfmac: Transform compatible string for FW loading
Date:   Thu, 25 Jun 2020 18:07:25 +0200
Message-Id: <20200625160725.31581-1-matthias.bgg@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthias Brugger <mbrugger@suse.com>

The driver relies on the compatible string from DT to determine which
FW configuration file it should load. The DTS spec allows for '/' as
part of the compatible string. We change this to '-' so that we will
still be able to load the config file, even when the compatible has a
'/'. This fixes explicitly the firmware loading for
"solidrun,cubox-i/q".

Signed-off-by: Matthias Brugger <mbrugger@suse.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/of.c  | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index b886b56a5e5a..8a41b7f9cad3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -17,7 +17,6 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 {
 	struct brcmfmac_sdio_pd *sdio = &settings->bus.sdio;
 	struct device_node *root, *np = dev->of_node;
-	struct property *prop;
 	int irq;
 	u32 irqf;
 	u32 val;
@@ -25,8 +24,21 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 	/* Set board-type to the first string of the machine compatible prop */
 	root = of_find_node_by_path("/");
 	if (root) {
-		prop = of_find_property(root, "compatible", NULL);
-		settings->board_type = of_prop_next_string(prop, NULL);
+		int i;
+		char *board_type;
+		const char *tmp;
+
+		of_property_read_string_index(root, "compatible", 0, &tmp);
+
+		/* get rid of '/' in the compatible string to be able to find the FW */
+		board_type = devm_kzalloc(dev, strlen(tmp), GFP_KERNEL);
+		strncpy(board_type, tmp, strlen(tmp));
+		for (i = 0; i < strlen(board_type); i++) {
+			if (board_type[i] == '/')
+				board_type[i] = '-';
+		}
+		settings->board_type = board_type;
+
 		of_node_put(root);
 	}
 
-- 
2.27.0

