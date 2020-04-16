Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB481ACF01
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 19:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393269AbgDPRpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 13:45:04 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:9431 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728701AbgDPRpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 13:45:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587059101; x=1618595101;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5ZWBmVoYMO/hCFi0Ml2DiGaGCI33pC6mAPMVtPWs/Mw=;
  b=Ma9Wt4tBIlioUm6kmKOHCEZrIlc3P1pCTzkv1GYe65NRYjz//bMwapRG
   NjzikHI1UKfT6eZ8fidbFVWD5hWx5QGgvaziBmwi64Z01EoHazfPpCK1U
   7ZQ6dWf2O+APg8uB9LYAZ/sQ80XfKtdfaIvKuwdCKsyKi3vkop+hoGdFG
   GT3ZaBO9yH+OFy4kgOCYtnjkEK87krMzeiIMSeYX3lu7LFTYwaHgvClFR
   ZoMYQusvXX0yfuUwUIQVnrVYYxS5ovi2aPQ3h5WVGLDvFEWpHUOl/B61A
   PxrBtpwaa28FOxjBpiCdEI9diIQmqepdOWfBrODsAer+iKJFBqjzPJXjz
   w==;
IronPort-SDR: PtSZ4I31iksvGuzc9xhP9LVWGcyCXG8fRlBsa6MUe7f0kTawT44YjJW/Ol87YLQhSd/TWC06CN
 vY3kUgO7yvYkMZdIj+THMSmt5tNVA09qVx/ltYeBsCpReLtfGehSmxuqAEQCuXp+3ajKkuhYLg
 Aa6DHA/Ln42W8mtSjfNspxx1fMguUeZWpgI9znGdV4MVvQd3kWPobVaHh3rHewD3ersvdUVH8z
 /7ym+dIl2VSnL1J7zsSvMomtoTVyGUY0+R1f3eBBjww1K6IxRNwQ/tA0STASxoi4fWAK+GT6rC
 7gU=
X-IronPort-AV: E=Sophos;i="5.72,391,1580799600"; 
   d="scan'208";a="9428364"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Apr 2020 10:45:00 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 16 Apr 2020 10:45:00 -0700
Received: from ness.corp.atmel.com (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 16 Apr 2020 10:44:55 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <pthombar@cadence.com>, <sergio.prado@e-labworks.com>,
        <antoine.tenart@bootlin.com>, <f.fainelli@gmail.com>,
        <linux@armlinux.org.uk>, <andrew@lunn.ch>,
        <michal.simek@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH 0/5] net: macb: Wake-on-Lan magic packet fixes and GEM handling
Date:   Thu, 16 Apr 2020 19:44:27 +0200
Message-ID: <cover.1587058078.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@microchip.com>

Hi,
Here are some of my patches in order to fix WoL magic-packet on the current
macb driver.
I also add, in the second part of this series the feature to GEM types of IPs.
Please tell me if they should be separated; but the two last patches cannot go
without the 3 fixes first ones.

MACB and GEM code must co-exist and as they don't share exactly the same
register layout, I had to specialize a bit the suspend/resume paths and plug a
specific IRQ handler in order to avoid overloading the "normal" IRQ hot path.

The use of dumb buffers for RX that Harini implemented in [1] might
need to be considered for a follow-up patch series in order to address
lower-power modes on some of the platforms.
For instance, I didn't have to implement dumb buffers for some of the simpler
ARM9 platforms using MACB+FIFO types of controllers.

Please give feedback. Best regards,
  Nicolas

[1]:
https://github.com/Xilinx/linux-xlnx/commit/e9648006e8d9132db2594e50e700af362b3c9226#diff-41909d180431659ccc1229aa30fd4e5a
https://github.com/Xilinx/linux-xlnx/commit/60a21c686f7e4e50489ae04b9bb1980b145e52ef


Nicolas Ferre (5):
  net: macb: fix wakeup test in runtime suspend/resume routines
  net: macb: mark device wake capable when "magic-packet" property
    present
  net: macb: fix macb_get/set_wol() when moving to phylink
  net: macb: WoL support for GEM type of Ethernet controller
  net: macb: Add WoL interrupt support for MACB type of Ethernet
    controller

 drivers/net/ethernet/cadence/macb.h      |   3 +
 drivers/net/ethernet/cadence/macb_main.c | 181 +++++++++++++++++++----
 2 files changed, 158 insertions(+), 26 deletions(-)

-- 
2.20.1

