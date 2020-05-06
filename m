Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB4F1C6F77
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 13:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbgEFLlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 07:41:52 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:2166 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbgEFLlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 07:41:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1588765312; x=1620301312;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gXKvzJw9g7LAOQgi97R5QafLHw2jX68aP/tQVwVwRa4=;
  b=KC5O09eW3WS3b+9zsfoL3P+MuTQcujtUAlrvEE4FyDpyTgW08w8MmVz+
   o5WY5/L+vIzbF+slD8pxcC4HavqJOan23lknbC5b3ieqHrYoiWsetptYH
   Xo0TYoBG0DgSJ9aCe86n+X+mEQDIwn/SLcP/hxjIC5dTiUHGpppLaSgQm
   g+JccwusnX5J+BGEc6+7XPvhS9CGbS+tcC1qU+QXFWMPExl5EQk1g++Vi
   G6+xOTOsQ5GvQ/6YMBCePKK09dU7Ojwgm7VhlEbXcwtLaydqudg/sIdjo
   xqaMoYKmUN8GSiKPMC4AhyZl26FhwgAIFMHvHeVKCzYmqEJREMP2+12xg
   w==;
IronPort-SDR: pV2N48h6LeiTsUHgpKHyNfJ/PapuF0UDYwEHle6+16FTUWVt5NCG1LTvntaKbTycJbxpt9FUIj
 gSAg8fYnXWgPu7+QoAaZS9SFojxNpQG9HaAwAmFkdOwz7BevhML/RudCL0McHBueMd2r7JDCAw
 GaSYiBPXJhdkJ2HLgSaoMS7v6ydcANGgICNe5XRAbw1+H1IfWGfVAU1usQERCIYN8pH9ewJ6vH
 4d9xA6jCV9Dn7PMgDD1b8fzW1FKfdFWNW9W8hYkUr+8UvFo5UFTDl+GznHrd6eR3ZBIEqyGua6
 ShM=
X-IronPort-AV: E=Sophos;i="5.73,358,1583218800"; 
   d="scan'208";a="74979844"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 May 2020 04:41:52 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 6 May 2020 04:41:52 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Wed, 6 May 2020 04:41:47 -0700
From:   <nicolas.ferre@microchip.com>
To:     <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        "Claudiu Beznea" <claudiu.beznea@microchip.com>,
        <harini.katakam@xilinx.com>
CC:     <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <antoine.tenart@bootlin.com>, <f.fainelli@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [PATCH v4 0/5] net: macb: Wake-on-Lan magic packet fixes and GEM handling
Date:   Wed, 6 May 2020 13:37:36 +0200
Message-ID: <cover.1588763703.git.nicolas.ferre@microchip.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@microchip.com>

Hi,
Here is a split series to fix WoL magic-packet on the current macb driver. Only
fixes in this one based on current net/master.

Best regards,
  Nicolas

Changes in v4:
- Pure bug fix series for 'net'. GEM addition and MACB update removed: will be
  sent later.

Changes in v3:
- Revert some of the v2 changes done in macb_resume(). Now the resume function
  supports in-depth re-configuration of the controller in order to deal with
  deeper sleep states. Basically as it was before changes introduced by this
  series
- Tested for non-regression with our deeper Power Management mode which cuts
  power to the controller completely

Changes in v2:
- Add patch 4/7 ("net: macb: fix macb_suspend() by removing call to netif_carrier_off()")
  needed for keeping phy state consistent
- Add patch 5/7 ("net: macb: fix call to pm_runtime in the suspend/resume functions") that prevent
  putting the macb in runtime pm suspend mode when WoL is used
- Collect review tags on 3 first patches from Florian: Thanks!
- Review of macb_resume() function
- Addition of pm_wakeup_event() in both MACB and GEM WoL IRQ handlers


Nicolas Ferre (5):
  net: macb: fix wakeup test in runtime suspend/resume routines
  net: macb: mark device wake capable when "magic-packet" property
    present
  net: macb: fix macb_get/set_wol() when moving to phylink
  net: macb: fix macb_suspend() by removing call to netif_carrier_off()
  net: macb: fix call to pm_runtime in the suspend/resume functions

 drivers/net/ethernet/cadence/macb_main.c | 31 +++++++++++++-----------
 1 file changed, 17 insertions(+), 14 deletions(-)

-- 
2.26.2

