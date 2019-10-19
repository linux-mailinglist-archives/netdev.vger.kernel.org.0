Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF0BADDA5C
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 20:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfJSSmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 14:42:44 -0400
Received: from mo4-p03-ob.smtp.rzone.de ([81.169.146.173]:15653 "EHLO
        mo4-p03-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbfJSSlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 14:41:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1571510508;
        s=strato-dkim-0002; d=goldelico.com;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=FJTzAJtOyW1fELY6o5Xc6FD2/JieVkVYHZp5uH7ofjY=;
        b=lVZk/bwVmpmZqSWt4cVxF7cI1gfROYPkiJkwPySisMIDfQibOzkDj9Iwyne305xklI
        3xW/TUwLsuj40LVY9C93/8K1VA24T32zs0/4oKfSiXaE/b9i3099BaA4o2zQKuPTpJja
        D62JtAnTQTbEWRXeHB/AfXK66yitfXVoeNcx9hngP60c26R0EEIC47jKh4AALxEbXBjJ
        2KzHtKPES9kZA5uH7tlVfCWbfRaRjv95RtL23VRDM9tPToxNs1tBe4EMtBsSVu2VOCtc
        Ct0lWxN3+dT3lnMTcYYS96jc8Ma5KKC6NTR6i++0v5joCtHMcSS61kval50pFBILWCet
        eGsw==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o12DNOsPj0pAyXkHTz8="
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 44.28.1 DYNA|AUTH)
        with ESMTPSA id R0b2a8v9JIfVFMP
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Sat, 19 Oct 2019 20:41:31 +0200 (CEST)
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
Subject: [PATCH v2 04/11] mmc: host: omap_hsmmc: add code for special init of wl1251 to get rid of pandora_wl1251_init_card
Date:   Sat, 19 Oct 2019 20:41:19 +0200
Message-Id: <0887d84402f796d1e7361261b88ec6057fbb0065.1571510481.git.hns@goldelico.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1571510481.git.hns@goldelico.com>
References: <cover.1571510481.git.hns@goldelico.com>
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

Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel")

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Cc: <stable@vger.kernel.org> # 4.7.0
---
 drivers/mmc/host/omap_hsmmc.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 952fa4063ff8..03ba80bcf319 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1512,6 +1512,27 @@ static void omap_hsmmc_init_card(struct mmc_host *mmc, struct mmc_card *card)
 
 	if (mmc_pdata(host)->init_card)
 		mmc_pdata(host)->init_card(card);
+	else if (card->type == MMC_TYPE_SDIO || card->type == MMC_TYPE_SD_COMBO) {
+		struct device_node *np = mmc_dev(mmc)->of_node;
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
2.19.1

