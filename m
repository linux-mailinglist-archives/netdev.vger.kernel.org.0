Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F374C1239A9
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 23:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfLQWTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 17:19:44 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35392 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbfLQWTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 17:19:42 -0500
Received: by mail-wr1-f68.google.com with SMTP id g17so160925wro.2
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 14:19:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=yy84TR/jlWT0C0eYXNt2vi5jaxQ9SOIspzQmKyIayVs=;
        b=PnEVmdCYa2vkrxI9WdgRzbQhiyce+JynE03bQYXKwyIq9VwS66dpBLuyV9ztmI/LWT
         8xI/gUkhPEd3qgbpLPLqFz+tRwbwhZWS4g2HiNvtIM9p78cWIVbyc8tQCxhegyluP0Vb
         6P4BOrYeL5QJZBTFNQcmwCWbmTp4zXrg1Ab16qADVGhaSWJmpo6jVq3Ydu1i4oirC0xp
         +6RK6KhXCkqS8qA1LsUPEUiWNxay4bRqJnRUolRuNuPYW4mC5Rvgaw9BZR2H5ySoE9GC
         vRVXnRj+JmDSxeNpfd9PKcB2iiWUaBzHBulI0WNR4dospRqOIgE7mgT8cAjHGKvFWGoz
         VYcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yy84TR/jlWT0C0eYXNt2vi5jaxQ9SOIspzQmKyIayVs=;
        b=ePaXM8YRmevjS1MWKuYBrgk30+BTjdl5kKnvlwRWDbD/iRU1XYwbUNXJWpABxszJPn
         HXXiHdrXgC9vx4lh2uRkLuHu0OVgMPKm8alKJeT/y8fzRnVWltnkRo784nS8RAvkXZo3
         pIKUGOu7A01Xp3a2SgidTFIPh+SxAsPz5dYIzwSjy3zTIG69hjB8kEMCn6WtansutI58
         dzJ9k3jm+0ZzxsV70w+HAX6ozJaQ4vnqESQwaxtid+BVk1aKoaWgCuPjf09+bDeXDd0B
         rCR76JQvoZTS0B/flXxlxWHW7q8Hw2zHQjaeEDSWpx21rNqMSiEJ3FQ7DL23Tk89RiUk
         Tl6Q==
X-Gm-Message-State: APjAAAVIRRFNrXbovi9bWZ9lwZ18Ak2y3dpvjcc+bvxPNNyIgO2w+ldP
        4mWH44+NFzM/D2dN57ZGC/hnxDhQx30=
X-Google-Smtp-Source: APXvYqx5g97is0BextvsvOhCF/662cR3V7XpgfqNfAy6EVSHzbslI+UCk0neAKNfh3VqG+5xUnLGag==
X-Received: by 2002:a5d:4c85:: with SMTP id z5mr38501612wrs.42.1576621179035;
        Tue, 17 Dec 2019 14:19:39 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id e6sm196808wru.44.2019.12.17.14.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:19:38 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 0/8] Convert Felix DSA switch to PHYLINK
Date:   Wed, 18 Dec 2019 00:18:23 +0200
Message-Id: <20191217221831.10923-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Unlike most other conversions, and unlike this series' own v1 [0] from which it
is radically different, this conversion is not by far a trivial one, and should
be seen as "Layerscape PCS meets PHYLINK". Depending on the feedback received,
the PCS driver from felix_vsc9959 can in fact be generalized to cover most of
the Layerscape devices, or we can scrap the idea.  Actually, the PCS doesn't
need a lot of hand-holding and most of our other devices 'just work' (this one
included) without any sort of operating system awareness, just an
initialization procedure done typically in the bootloader.

The PCS is not specific to the Vitesse / Microsemi / Microchip switching core
at all. Variations of this SerDes/PCS design can also be found on DPAA1 and
DPAA2 hardware.

The main idea of the abstraction provided is that the PCS looks so much like a
PHY device, that we model it as an actual PHY device and run the generic PHY
functions on it, where appropriate.

The 4xSGMII, QSGMII and QSXGMII modes are fairly straightforward.

The SerDes protocol which the driver calls 2500Base-X mode (a misnomer) is more
interesting. There is a description of how it works and what can be done with
it in patch 8/8 (in a comment above vsc9959_pcs_init_2500basex).
In short, it is a fixed speed protocol with no auto-negotiation whatsoever.
From my research of the SGMII-2500 patent [1], it has nothing to do with
SGMII-2500. That one:
* does not define any change to the AN base page compared to plain 10/100/1000
  SGMII. This implies that the 2500 speed is not negotiable, but the other
  speeds are. In our case, when the SerDes is configured for this protocol it's
  configured for good, there's no going back to SGMII.
* runs at a higher base frequency than regular SGMII. So SGMII-2500 operating
  at 1000 Mbps wouldn't interoperate with plain SGMII at 1000 Mbps. Strange,
  but ok..
* Emulates lower link speeds than 2500 by duplicating the codewords twice, then
  thrice, then twice again etc (2.5/25/250 times on average). The Layerscape
  PCS doesn't do that (it is fixed at 2500 Mbaud).

But on the other hand it isn't Base-X either, since it doesn't do 802.3z /
clause 37 auto negotiation (flow control, local/remote fault etc).

So it is a protocol in its own right (a rather fixed one). If reviewers think
it should have its own phy-mode, different than 2500base-x, I'm in favor of
that. It's just that I couldn't find a suitable name for it. quarter-xaui?
3125mhz-8b10b?

When inter-operating with the Aquantia AQR112 and AQR412 PHYs in this mode (for
which the PHY uses a proprietary name "OCSGMII"), we do still need to support
the lower link speeds negotiated by the PHY on copper side. So what we
typically do is we enable rate adaptation in the PHY firmware, with pause
frames and a fixed link speed on the system side. Raising this as a discussion
item to understand how we can model this quirky operating mode in Linux without
imposing limitations on others (we have some downstream patches on the Aquantia
PHY driver as well).

Another item to discuss is whether we should be able to disable AN in the PCS
independently of whether we have a PHY as a peer or not. With an SGMII PHY-less
connection, there may be no auto-negotiation master so the link partners will
bounce for a while and then they'll settle on 10 Mbps as link speed. For those
connections (such as an SGMII link to a downstream switch) we need to disable
AN in the PCS and force the speed to 1000.
So:
* If we have a PHY we want to do auto-neg
* If we don't have a PHY, maybe we want AN, maybe we don't
* In the 2500Base-X mode, we can't do AN because the hardware doesn't support it

I have found the 'managed = "in-band-status"' DTS binding to somewhat address
this concern, but I am a bit reluctant to disable SGMII AN if it isn't set.
We have boards with device trees that need to be migrated from PHYLIB and I
am concerned that changing the behavior w.r.t. in-band AN (when the
"in-band-status" property is not present) is not going to be pleasant.
I do understand that the "in-band-status" property is primarily intended to be
used with PHY-less setups, and it looks like the fact it does work with PHYs as
well is more of an oversight (as patch 2/8 shows). So I'm not sure who else
really uses it with a phy-handle.

There are some more open questions in patch 8/8.

I dropped the Ocelot PHYLINK conversion because:
* I don't have VSC7514 hardware anyway
* The hardware is so different in this regard that there's almost nothing to
  share anyway.

[0]: https://www.spinics.net/lists/netdev/msg613869.html
[1]: https://patents.google.com/patent/US7356047B1/en

Claudiu Manoil (1):
  enetc: Make MDIO accessors more generic and export to
    include/linux/fsl

Vladimir Oltean (7):
  mii: Add helpers for parsing SGMII auto-negotiation
  net: phylink: make QSGMII a valid PHY mode for in-band AN
  net: phylink: call mac_an_restart for SGMII/QSGMII inband interfaces
    too
  enetc: Set MDIO_CFG_HOLD to the recommended value of 2
  net: mscc: ocelot: make phy_mode a member of the common struct
    ocelot_port
  net: mscc: ocelot: export ANA, DEV and QSYS registers to
    include/soc/mscc
  net: dsa: felix: Add PCS operations for PHYLINK

 drivers/net/dsa/ocelot/Kconfig                     |   1 +
 drivers/net/dsa/ocelot/felix.c                     | 260 ++++++++-
 drivers/net/dsa/ocelot/felix.h                     |  16 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             | 475 +++++++++++++++-
 drivers/net/ethernet/freescale/enetc/enetc_hw.h    |   1 +
 drivers/net/ethernet/freescale/enetc/enetc_mdio.c  |  88 ++-
 drivers/net/ethernet/freescale/enetc/enetc_mdio.h  |  12 -
 .../net/ethernet/freescale/enetc/enetc_pci_mdio.c  |  43 +-
 drivers/net/ethernet/mscc/ocelot.c                 |   7 +-
 drivers/net/ethernet/mscc/ocelot.h                 |   7 +-
 drivers/net/ethernet/mscc/ocelot_ana.h             | 625 ---------------------
 drivers/net/ethernet/mscc/ocelot_board.c           |   4 +-
 drivers/net/ethernet/mscc/ocelot_dev.h             | 275 ---------
 drivers/net/ethernet/mscc/ocelot_qsys.h            | 270 ---------
 drivers/net/phy/phylink.c                          |   5 +-
 include/linux/fsl/enetc_mdio.h                     |  34 ++
 include/linux/mii.h                                |  50 ++
 include/soc/mscc/ocelot.h                          |   2 +
 include/soc/mscc/ocelot_ana.h                      | 625 +++++++++++++++++++++
 include/soc/mscc/ocelot_dev.h                      | 275 +++++++++
 include/soc/mscc/ocelot_qsys.h                     | 270 +++++++++
 include/uapi/linux/mii.h                           |  10 +
 22 files changed, 2100 insertions(+), 1255 deletions(-)
 delete mode 100644 drivers/net/ethernet/freescale/enetc/enetc_mdio.h
 delete mode 100644 drivers/net/ethernet/mscc/ocelot_ana.h
 delete mode 100644 drivers/net/ethernet/mscc/ocelot_dev.h
 delete mode 100644 drivers/net/ethernet/mscc/ocelot_qsys.h
 create mode 100644 include/linux/fsl/enetc_mdio.h
 create mode 100644 include/soc/mscc/ocelot_ana.h
 create mode 100644 include/soc/mscc/ocelot_dev.h
 create mode 100644 include/soc/mscc/ocelot_qsys.h

-- 
2.7.4

