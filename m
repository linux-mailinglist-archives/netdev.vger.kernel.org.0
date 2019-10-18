Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 401C7DD069
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 22:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443429AbfJRUhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 16:37:47 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.169]:8676 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406234AbfJRUhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 16:37:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1571431055;
        s=strato-dkim-0002; d=goldelico.com;
        h=Message-Id:Date:Subject:Cc:To:From:X-RZG-CLASS-ID:X-RZG-AUTH:From:
        Subject:Sender;
        bh=i+n9s4XwY9DLFEIv0Q1xv72dgRxe/+bXdwtMcjVj36s=;
        b=DnXSM2HC/JHpy2J/44VXu+nFlqO3wv+oww3syCf7Jmj9JLUseaVYBmA6E9eoDfi+w+
        om538tJJQWSIFxJNjLfI0uwnlPuB74zcTGXHu1a3k0D9/IdwNsh+6N6NPwusZy429iyv
        BWT17m8Mr6hEqN9FWKSRNjuyoMYYNHmkUMacbyfIVQvFzw2VkwRZL5/TSG7OcpQFBHfZ
        kv/usJq1AmghNxjT8ZGyy9v59Et7ynwMRsHQeiVLtHDrIGrGpKH5+P173qWkcrWdVYje
        k295rK7E04ZSydn2Wb2Xbzk+o0RxyCRXKf8cjarzM8XTv7rebJqTeRUiHUs0oB+2TOD0
        1JNQ==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMhflhwDubTJ9o1mfYzBGHXH6F3CFF60="
X-RZG-CLASS-ID: mo00
Received: from iMac.fritz.box
        by smtp.strato.de (RZmta 44.28.1 DYNA|AUTH)
        with ESMTPSA id R0b2a8v9IKPVDUm
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Fri, 18 Oct 2019 22:25:31 +0200 (CEST)
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
        kernel@pyra-handheld.com
Subject: [PATCH 0/9] OpenPandora: make wl1251 connected to mmc3 sdio port of OpenPandora work again
Date:   Fri, 18 Oct 2019 22:25:21 +0200
Message-Id: <cover.1571430329.git.hns@goldelico.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
DT:     Pandora: fixes and extensions
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here we have a set of scattered patches to make the OpenPandora WiFi work again.

v4.7 did break the pdata-quirks which made the mmc3 interface
fail completely, because some code now assumes device tree
based instantiation.

Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel")

v4.11 did break the sdio qirks for wl1251 which made the driver no longer
load, although the device was found as an sdio client.

Fixes: 884f38607897 ("mmc: core: move some sdio IDs out of quirks file")

To solve these issues:
* we convert mmc3 and wl1251 initialization from pdata-quirks
  to device tree
* we make the wl1251 driver read properties from device tree
* we fix the mmc core vendor ids and quirks
* we fix the wl1251 (and wl1271) driver to use only vendor ids
  from header file instead of (potentially conflicting) local
  definitions


H. Nikolaus Schaller (9):
  Documentation: dt: wireless: update wl1251 for sdio
  net: wireless: ti: wl1251 add device tree support
  DTS: ARM: pandora-common: define wl1251 as child node of mmc3
  mmc: host: omap_hsmmc: add code for special init of wl1251 to get rid
    of pandora_wl1251_init_card
  omap: pdata-quirks: remove openpandora quirks for mmc3 and wl1251
  mmc: sdio: fix wl1251 vendor id
  mmc: core: fix wl1251 sdio quirks
  net: wireless: ti: wl1251 use new SDIO_VENDOR_ID_TI_WL1251 definition
  net: wireless: ti: remove local VENDOR_ID and DEVICE_ID definitions

 .../bindings/net/wireless/ti,wl1251.txt       | 26 +++++++++++++
 arch/arm/boot/dts/omap3-pandora-common.dtsi   | 37 ++++++++++++++++++-
 arch/arm/mach-omap2/pdata-quirks.c            | 13 +++----
 drivers/mmc/core/quirks.h                     |  7 ++++
 drivers/mmc/host/omap_hsmmc.c                 | 21 +++++++++++
 drivers/net/wireless/ti/wl1251/sdio.c         | 23 +++++++-----
 drivers/net/wireless/ti/wlcore/sdio.c         |  8 ----
 include/linux/mmc/sdio_ids.h                  |  2 +
 8 files changed, 111 insertions(+), 26 deletions(-)

-- 
2.19.1

