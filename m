Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE11421D36D
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 12:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729572AbgGMKFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 06:05:52 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:27478 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729143AbgGMKFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 06:05:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594634749; x=1626170749;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iEPXg4m/PV2bFSjHkkjCWZpki+k4rKh/UyV/yzZSQ0M=;
  b=plSd9J0bmW18eTQhfQR9VlIqV5bR2Fl9Q1kPYz+65he0PykjFFlWLjci
   u2xGCaEibyiYPfXbFeHDOQ3AOckaXkQ3POlfimZKmiiwtZC+axlJrSp3W
   199P6OLiIv5ynG9JvNwoaPW2FuApHMVk6niPBXMT81h76+25WrfpemPZi
   7bHWXvKnwOtxh3Zi3EdU5xhBq6x0SsP3VyWQZpNxJww0FQdotITdPPKw3
   SuEycNvccYk3tszcMbQ7xL3lBCpVLEqoApIlZy62hx+nn2YQk80wlzDnR
   D5vdAnGaEoBHjGUjgE0zRxGt7J6xmFjOIXrQz8Jqy+2/qMcrVNZ8Y3XXx
   g==;
IronPort-SDR: meGEHEUjaT0fMMXyYcZqeGoQpnTvH3DTaH1aev/07RNploieJ9h5IeW0beRH6EslITv1iyRox5
 B9lI9X/I7pXsUmozhMp91rOkhmkObZ8bWzT3EjC+szJAzGkxc1J69/x3bQWy5/kXfSFe7+sBKm
 5VKZNBlbk7pFzSs/WzPAEtVRd2FL5W7syFD+bh2uG7OUDXsqOpwVMNZhPV2r06+4yUp8r9GUXF
 O/84ZMtUJgJh2mWt2zIHCxxMgA+w0hzBCkPIj2iWDz97VIaqTkW9ebCUuP0MSy9BGPA/F+GJgm
 0fg=
X-IronPort-AV: E=Sophos;i="5.75,347,1589266800"; 
   d="scan'208";a="79679482"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jul 2020 03:05:48 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 13 Jul 2020 03:05:48 -0700
Received: from ness.mchp-main.com (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 13 Jul 2020 03:05:14 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux@armlinux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <netdev@vger.kernel.org>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>, <f.fainelli@gmail.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <antoine.tenart@bootlin.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH v6 0/2] net: macb: Wake-on-Lan magic packet GEM and MACB handling
Date:   Mon, 13 Jul 2020 12:05:24 +0200
Message-ID: <cover.1594632220.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@microchip.com>

Hi,

Here is the second part of support for WoL magic-packet on the current macb driver. This one
is addressing the bulk of the feature and is based on current net-next/master.

MACB and GEM code must co-exist and as they don't share exactly the same
register layout, I had to specialize a bit the suspend/resume paths and plug a
specific IRQ handler in order to avoid overloading the "normal" IRQ hot path.

These changes were tested on both sam9x60 which embeds a MACB+FIFO controller
and sama5d2 which has a GEM+packet buffer type of controller.

Best regards,
  Nicolas

Changes in v6:
- rebase on net-next/master now that the "fixes" patches of the series are
  merged in both net and net-next.
- GEM addition and MACB update to finish the support of WoL magic-packet on the
  two revisions of the controller.

These 2 patches were last posted in v3 series.

History of previous changes already added to git commit message here:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f9f41e3db40ee8d61b427d4d88c7365d968052a9

Nicolas Ferre (2):
  net: macb: WoL support for GEM type of Ethernet controller
  net: macb: Add WoL interrupt support for MACB type of Ethernet
    controller

 drivers/net/ethernet/cadence/macb.h      |   3 +
 drivers/net/ethernet/cadence/macb_main.c | 188 +++++++++++++++++++----
 2 files changed, 164 insertions(+), 27 deletions(-)

-- 
2.27.0

