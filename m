Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1200D20E533
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391261AbgF2VeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:34:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728610AbgF2Sk5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 14:40:57 -0400
Received: from ziggy.de (unknown [213.195.114.138])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08DD423A03;
        Mon, 29 Jun 2020 11:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593428511;
        bh=jARi/R4D3lgWV8NV1MNg8COPXHS+phn3bVWAQun1iT0=;
        h=From:To:Cc:Subject:Date:From;
        b=gJff2v4TXpfy6hF9V6idvI8o6WC2i340W5y4znsunb9GxFAXu2t/OxlZeOr4CANCE
         v3g+wgVTjfgtjZKl617qqJw7N+PNK3gGuMBcDHarUaPqWnyMR5N6EyMprUao3IZOp8
         qsythEBwnsU7SofzrpVhPdVTaGeMNKm0wslVZVMY=
From:   matthias.bgg@kernel.org
To:     arend.vanspriel@broadcom.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     brcm80211-dev-list.pdl@broadcom.com, mbrugger@suse.com,
        netdev@vger.kernel.org, chi-hsien.lin@cypress.com,
        linux-wireless@vger.kernel.org, hante.meuleman@broadcom.com,
        linux-kernel@vger.kernel.org, hdegoede@redhat.com,
        wright.feng@cypress.com, matthias.bgg@kernel.org,
        brcm80211-dev-list@cypress.com, franky.lin@broadcom.com
Subject: [PATCH v2] brcmfmac: Transform compatible string for FW loading
Date:   Mon, 29 Jun 2020 13:01:41 +0200
Message-Id: <20200629110141.22419-1-matthias.bgg@kernel.org>
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

Changes in v2:
- use strscpy instead of strncpy (Hans de Goede)
- use strlen(tmp) + 1 for allocation (Hans de Goede, kernel test robot)

 .../wireless/broadcom/brcm80211/brcmfmac/of.c  | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index b886b56a5e5a..5f0ebaf4d64e 100644
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
+		board_type = devm_kzalloc(dev, strlen(tmp) + 1, GFP_KERNEL);
+		strscpy(board_type, tmp, sizeof(board_type));
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

