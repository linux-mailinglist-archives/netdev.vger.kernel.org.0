Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C8F3157E1
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 21:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233945AbhBIUnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 15:43:53 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:42818 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233606AbhBIUfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 15:35:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612902908; x=1644438908;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mScHVWGIFuV1tfRo50B5fq0AL0izsRJ5iX46aUKbLLE=;
  b=k+rkaZ+l4dQ9Dj8x20PC8gDT/bI+2OqgtHSwhZCaPmVZP1Ld2i/zajQB
   CCMjUZM/x3zun3YZPJTr+9chF+PNIK5mR3pbtwsTmOffER89uq/JJdPVb
   jwxsik7LqALRjJ+79JPLqawpCpK2JT6Ko6SLdmon6jPen5hEXs5FgGVr+
   NkgSYKP0SHKErIVTmIQLNsA7UW23UXdGYYRbbPNUgwUYpY3QB8Ud5Agmq
   1/EnF64YwboXmwMB+4stwtjs6e+Qxbcbsm7DfbFYV8KGnRQtJbj4tiB65
   wCjRJTTAfnI5a8Ulm11Jp/Jf+gZr7z4i0n/Zoqi9IKOLn1PKSxRNXEEOw
   g==;
IronPort-SDR: KjYwtPOHWP5tWem3jg22SO7acL0+yz1lFMGHjo0eSG+/LPoamWxx+LdtPW6YMKnALP1of4Aytk
 asUmOmfSttvcFGeyZ0UuuHAtS/LurkxIscutOh8fEwo3mICPV91OFl3E3FjMujLBIE713QfWTR
 N1hAKbpk8A3u1CKBm3qjWerBUFPIhrgSjUU1bvlK3wWK6bU3NPjbnGBTymNLE1xrhhN78dWIi0
 bCtQ4F7l6zytIusbblU0SKrT5Q7j9UTkjrrKaBgaZ+PEqR4UbPqEUa+Scgatj2uNyyY168ck+U
 Kdc=
X-IronPort-AV: E=Sophos;i="5.81,166,1610434800"; 
   d="scan'208";a="106029114"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Feb 2021 13:24:16 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 9 Feb 2021 13:24:15 -0700
Received: from soft-dev3.localdomain (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Tue, 9 Feb 2021 13:24:12 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <rasmus.villemoes@prevas.dk>, <andrew@lunn.ch>,
        <vladimir.oltean@nxp.com>, <claudiu.manoil@nxp.com>,
        <alexandre.belloni@bootlin.com>, <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v3 0/5] bridge: mrp: Extend br_mrp_switchdev_*
Date:   Tue, 9 Feb 2021 21:21:07 +0100
Message-ID: <20210209202112.2545325-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series extends MRP switchdev to allow the SW to have a better
understanding if the HW can implement the MRP functionality or it needs
to help the HW to run it. There are 3 cases:
- when HW can't implement at all the functionality.
- when HW can implement a part of the functionality but needs the SW
  implement the rest. For example if it can't detect when it stops
  receiving MRP Test frames but it can copy the MRP frames to CPU to
  allow the SW to determine this.  Another example is generating the MRP
  Test frames. If HW can't do that then the SW is used as backup.
- when HW can implement completely the functionality.

So, initially the SW tries to offload the entire functionality in HW, if
that fails it tries offload parts of the functionality in HW and use the
SW as helper and if also this fails then MRP can't run on this HW.

Also implement the switchdev calls for Ocelot driver. This is an example
where the HW can't run completely the functionality but it can help the SW
to run it, by trapping all MRP frames to CPU.

v3:
 - implement the switchdev calls needed by Ocelot driver.
v2:
 - fix typos in comments and in commit messages
 - remove some of the comments
 - move repeated code in helper function
 - fix issue when deleting a node when sw_backup was true

Horatiu Vultur (5):
  switchdev: mrp: Extend ring_role_mrp and in_role_mrp
  bridge: mrp: Add 'enum br_mrp_hw_support'
  bridge: mrp: Extend br_mrp_switchdev to detect better the errors
  bridge: mrp: Update br_mrp to use new return values of
    br_mrp_switchdev
  net: mscc: ocelot: Add support for MRP

 drivers/net/ethernet/mscc/ocelot_net.c     | 154 +++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |   6 +
 include/net/switchdev.h                    |   2 +
 include/soc/mscc/ocelot.h                  |   6 +
 net/bridge/br_mrp.c                        |  43 ++++--
 net/bridge/br_mrp_switchdev.c              | 171 +++++++++++++--------
 net/bridge/br_private_mrp.h                |  38 +++--
 7 files changed, 327 insertions(+), 93 deletions(-)

-- 
2.27.0

