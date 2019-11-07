Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F095F2C75
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 11:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388576AbfKGKcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 05:32:46 -0500
Received: from mo4-p03-ob.smtp.rzone.de ([81.169.146.174]:18343 "EHLO
        mo4-p03-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbfKGKbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 05:31:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1573122677;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=eKQR3EPPbTjhKVGosZU1J1d+4FAu+brxjLws3a77fGY=;
        b=R9pIMhgIJrHwBZ6/mtds/UBg9OiEGczSWyYkAKLEfq+OgQ5cZ06F+LorV70p989z6V
        dFeTj3GlK/uKkfMrB00PBTw3BeFRbOKOz/8bXkOFW3LtYWMrEfZA2VwEfnf+277Cxyyt
        rvQBd6ClBk/VE0SKhCmr/rSfOLAOpQuTVStPwAdVfs7Lm0FTNyHTqgfVOzPayKeGaAb/
        kpQcrEgwZwGFivAUcrW/bnkrVYj5mIsCw2ZFHcGRju+SGXDk+wleF36fsNLYCjWJUmSy
        FKl7lV4LaLKlwqhZKzV7E3pHmIwRzYTq/LzVBkTzE/ZFjzdsv2Vyx9gCRvkD0Uas6w8Y
        n42Q==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1OAA2UNf2M7PR5/L9P0"
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 44.29.0 DYNA|AUTH)
        with ESMTPSA id L09db3vA7AUodRt
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Thu, 7 Nov 2019 11:30:50 +0100 (CET)
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
To:     =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        David Sterba <dsterba@suse.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Petr Mladek <pmladek@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com, stable@vger.kernel.org
Subject: [PATCH v3 04/12] mmc: host: omap_hsmmc: add code for special init of wl1251 to get rid of pandora_wl1251_init_card
Date:   Thu,  7 Nov 2019 11:30:37 +0100
Message-Id: <2f050912668e5e3581ccc22707df54d8bb14c696.1573122644.git.hns@goldelico.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <cover.1573122644.git.hns@goldelico.com>
References: <cover.1573122644.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pandora_wl1251_init_card was used to do special pdata based
setup of the sdio mmc interface. This does no longer work with
v4.7 and later. A fix requires a device tree based mmc3 setup.

Therefore we move the special setup to omap_hsmmc.c instead
of calling some pdata supplied init_card function.

The new code checks for a DT child node compatible to wl1251
so it will not affect other MMC3 use cases.

Generally, this code was and still is a hack and should be
moved to mmc core to e.g. read such properties from optional
DT child nodes.

Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel")

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Cc: <stable@vger.kernel.org> # 4.7.0
---
 drivers/mmc/host/omap_hsmmc.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 952fa4063ff8..a7192731ac13 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1512,6 +1512,34 @@ static void omap_hsmmc_init_card(struct mmc_host *mmc, struct mmc_card *card)
 
 	if (mmc_pdata(host)->init_card)
 		mmc_pdata(host)->init_card(card);
+	else if (card->type == MMC_TYPE_SDIO || card->type == MMC_TYPE_SD_COMBO) {
+		struct device_node *np = mmc_dev(mmc)->of_node;
+
+		/*
+		 * REVISIT: should be moved to sdio core and made more
+		 * general e.g. by expanding the DT bindings of child nodes
+		 * to provide a mechanism to provide this information:
+		 * Documentation/devicetree/bindings/mmc/mmc-card.txt
+		 */
+
+		np = of_get_compatible_child(np, "ti,wl1251");
+		if (np) {
+			/*
+			 * We have TI wl1251 attached to MMC3. Pass this information to
+			 * SDIO core because it can't be probed by normal methods.
+			 */
+
+			dev_info(host->dev, "found wl1251\n");
+			card->quirks |= MMC_QUIRK_NONSTD_SDIO;
+			card->cccr.wide_bus = 1;
+			card->cis.vendor = 0x104c;
+			card->cis.device = 0x9066;
+			card->cis.blksize = 512;
+			card->cis.max_dtr = 24000000;
+			card->ocr = 0x80;
+			of_node_put(np);
+		}
+	}
 }
 
 static void omap_hsmmc_enable_sdio_irq(struct mmc_host *mmc, int enable)
-- 
2.23.0

