Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24D9210A39
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 13:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730274AbgGALWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 07:22:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:32924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730234AbgGALWJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 07:22:09 -0400
Received: from ziggy.cz (unknown [213.195.114.138])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A67C20702;
        Wed,  1 Jul 2020 11:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593602528;
        bh=S1NAV77dXwv+fjwoqyD9mo/JlNrWtWQH78lHIrJHCRA=;
        h=From:To:Cc:Subject:Date:From;
        b=oSO9TszIlrcVn+okb5AAX78/ETthqH1FmT2U+ld2nI39STpo0xmVnUM1NsXTTlPVo
         k6S182Y6hNn284JH0svEkZikLvr5bOP8qVu1K6raiVyLBPr+OKaK9/HgARfWT2Qn8W
         zMol/oRSi/kXaGFAwPZW24eO3GE9kWGV/OUt/7cI=
From:   matthias.bgg@kernel.org
To:     arend.vanspriel@broadcom.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     brcm80211-dev-list.pdl@broadcom.com, mbrugger@suse.com,
        netdev@vger.kernel.org, chi-hsien.lin@cypress.com,
        linux-wireless@vger.kernel.org, hante.meuleman@broadcom.com,
        linux-kernel@vger.kernel.org, hdegoede@redhat.com,
        wright.feng@cypress.com, matthias.bgg@kernel.org,
        brcm80211-dev-list@cypress.com, franky.lin@broadcom.com
Subject: [PATCH v3] brcmfmac: Transform compatible string for FW loading
Date:   Wed,  1 Jul 2020 13:22:00 +0200
Message-Id: <20200701112201.6449-1-matthias.bgg@kernel.org>
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

Changes in v3:
- use len variable to store length of string (Hans de Goede)
- fix for loop to stop on first NULL-byte (Hans de Goede)

Changes in v2:
- use strscpy instead of strncpy (Hans de Goede)
- use strlen(tmp) + 1 for allocation (Hans de Goede, kernel test robot)

 .../wireless/broadcom/brcm80211/brcmfmac/of.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index b886b56a5e5a..a7554265f95f 100644
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
@@ -25,8 +24,22 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 	/* Set board-type to the first string of the machine compatible prop */
 	root = of_find_node_by_path("/");
 	if (root) {
-		prop = of_find_property(root, "compatible", NULL);
-		settings->board_type = of_prop_next_string(prop, NULL);
+		int i, len;
+		char *board_type;
+		const char *tmp;
+
+		of_property_read_string_index(root, "compatible", 0, &tmp);
+
+		/* get rid of '/' in the compatible string to be able to find the FW */
+		len = strlen(tmp) + 1;
+		board_type = devm_kzalloc(dev, len, GFP_KERNEL);
+		strscpy(board_type, tmp, len);
+		for (i = 0; i < board_type[i]; i++) {
+			if (board_type[i] == '/')
+				board_type[i] = '-';
+		}
+		settings->board_type = board_type;
+
 		of_node_put(root);
 	}
 
-- 
2.27.0

