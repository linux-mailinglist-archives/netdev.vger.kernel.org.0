Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E325C12BB4E
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 22:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbfL0Vgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 16:36:52 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40541 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfL0Vgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 16:36:51 -0500
Received: by mail-wr1-f67.google.com with SMTP id c14so27252587wrn.7
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 13:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ynEyBeI1f4M7llci1SYKagOobQdCRROOHBB8XzBuNXc=;
        b=izhE4JlsY7axlN51z/tuEB3eZv4KNzwdaACmIPckwuZLANPWqm0/DtxSxazV9nV/nG
         ZCEqP2eHPRJkWy8edhK0LQ2/DjGkJyYkkf7wkToSFtYD6QBoESEDDIb2TRzEfwp4VZ2g
         lgS+JEiA3Afw9FbpJElT/vaqk9NNV+BFTUDOp+uQvEvF2IZ9tmw3mDJjJNQoaSGQ5EFV
         EZ5Emt7tjxZ1+2wxI//XVijSLXFDwsKKM0LglAlwW/bKMHDBvyxhNvAngJ5U9hfodAqN
         vJcvfvhIsqt5SocaCLC4o6ISwobx50a+RHZuPLhNFSXNLy27XnnjDu/hOislfjC+Fcji
         xAag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ynEyBeI1f4M7llci1SYKagOobQdCRROOHBB8XzBuNXc=;
        b=WL0SHRp+KNwsZtcWERD7/5+FqKWJf9Pcp2QcP5gKdjhDjkN0ktBB6ya9XJZdcG39Hm
         VC7J2l3nZJ3o7cpvZAzTvBV19B+j2bKAh95OR6u7exJyckIzT3rpoSEOloEustqzL1Jc
         XDfgeXYzAzioBjXv8YgBrV5Sl0HSIfGMD86D2mvvndo+UeIR7eiGEiCNaLvA2fzkUObx
         DDGaDdKZJqm5Z7Zr8B/EhorJ5vz7dAkF9yuNWl7IMx7GWQ0C/Sljgvh4lZlMgMpVXi98
         kKum5796qVF/2325F7HNjyAl1KZzG+GDSkeUUlQqCTPPMr9NinSf4uiG3PcNEkbDS25q
         ldwA==
X-Gm-Message-State: APjAAAV1sUw51A0AKlcSdmyIlUqNIgXje04EgEOq2JJY3CEqe3i8Uv2s
        uI1au8HuXJX4mzAb06I5t4c=
X-Google-Smtp-Source: APXvYqydm0Hc7ZPWUwIQdtM3XN1Z0ieJZL+RpNRRiDH9BmqmWz/85kf/49l1FR8U1kbpeMnPZUvdSQ==
X-Received: by 2002:a5d:4ed0:: with SMTP id s16mr50790796wrv.144.1577482609399;
        Fri, 27 Dec 2019 13:36:49 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id v3sm36330504wru.32.2019.12.27.13.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Dec 2019 13:36:48 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 00/11] Convert Felix DSA switch to PHYLINK
Date:   Fri, 27 Dec 2019 23:36:15 +0200
Message-Id: <20191227213626.4404-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike most other conversions, this one is not by far a trivial one, and should
be seen as "Layerscape PCS meets PHYLINK". Actually, the PCS doesn't
need a lot of hand-holding and most of our other devices 'just work'
(this one included) without any sort of operating system awareness, just
an initialization procedure done typically in the bootloader.
Our issues start when the PCS stops from "just working", and that is
where PHYLINK comes in handy.

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

But on the other hand it isn't completely compatible with Base-X either,
since it doesn't do 802.3z / clause 37 auto negotiation (flow control,
local/remote fault etc). It is compatible with 2500Base-X without
in-band AN, and that is exactly how we decided to expose it (this is
actually similar to what others do).

For SGMII and USXGMII, the driver is using the PHYLINK 'managed =
"in-band-status"' DTS binding to figure out whether in-band AN is
expected to be enabled in the PCS or not. It is expected that the
attached PHY follows suite, and patches 5/11 and 6/11 implement this
knob for the quad PHY attached to the Felix switch on the LS1028A-RDB
board. This way, traffic works in both cases when in-band AN is enabled
and disabled, independently of U-Boot pre-configuration.

I dropped the Ocelot PHYLINK conversion because:
* I don't have VSC7514 hardware anyway
* The hardware is so different in this regard that there's almost nothing to
  share anyway.

[0]: https://www.spinics.net/lists/netdev/msg613869.html
[1]: https://patents.google.com/patent/US7356047B1/en

Alex Marginean (1):
  net: phy: vsc8514: configure explicit in-band SGMII auto-negotiation
    settings

Claudiu Manoil (1):
  enetc: Make MDIO accessors more generic and export to
    include/linux/fsl

Vladimir Oltean (9):
  mii: Add helpers for parsing SGMII auto-negotiation
  net: phylink: make QSGMII a valid PHY mode for in-band AN
  net: phylink: add support for polling MAC PCS
  net: dsa: Pass pcs_poll flag from driver to PHYLINK
  net: phy: Add a property for controlling in-band auto-negotiation
  enetc: Set MDIO_CFG_HOLD to the recommended value of 2
  net: mscc: ocelot: make phy_mode a member of the common struct
    ocelot_port
  net: mscc: ocelot: export ANA, DEV and QSYS registers to
    include/soc/mscc
  net: dsa: felix: Add PCS operations for PHYLINK

 Documentation/networking/sfp-phylink.rst      |   3 +-
 drivers/net/dsa/ocelot/Kconfig                |   2 +
 drivers/net/dsa/ocelot/felix.c                | 266 +++++++++-
 drivers/net/dsa/ocelot/felix.h                |  16 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c        | 501 +++++++++++++++++-
 drivers/net/ethernet/freescale/enetc/Kconfig  |   1 +
 drivers/net/ethernet/freescale/enetc/Makefile |   2 +-
 .../net/ethernet/freescale/enetc/enetc_hw.h   |   1 +
 .../net/ethernet/freescale/enetc/enetc_mdio.c | 120 ++---
 .../net/ethernet/freescale/enetc/enetc_mdio.h |  12 -
 .../ethernet/freescale/enetc/enetc_pci_mdio.c |  43 +-
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  47 ++
 .../net/ethernet/freescale/enetc/enetc_pf.h   |   4 -
 drivers/net/ethernet/mscc/ocelot.c            |   7 +-
 drivers/net/ethernet/mscc/ocelot.h            |   7 +-
 drivers/net/ethernet/mscc/ocelot_board.c      |   4 +-
 drivers/net/phy/mscc.c                        |  15 +
 drivers/net/phy/phylink.c                     |   6 +-
 include/linux/fsl/enetc_mdio.h                |  55 ++
 include/linux/mii.h                           |  50 ++
 include/linux/phy.h                           |  18 +
 include/linux/phylink.h                       |   2 +
 include/net/dsa.h                             |   5 +
 include/soc/mscc/ocelot.h                     |   2 +
 .../soc}/mscc/ocelot_ana.h                    |   0
 .../soc}/mscc/ocelot_dev.h                    |   0
 .../soc}/mscc/ocelot_qsys.h                   |   0
 include/uapi/linux/mii.h                      |  12 +
 net/dsa/port.c                                |   1 +
 29 files changed, 1072 insertions(+), 130 deletions(-)
 delete mode 100644 drivers/net/ethernet/freescale/enetc/enetc_mdio.h
 create mode 100644 include/linux/fsl/enetc_mdio.h
 rename {drivers/net/ethernet => include/soc}/mscc/ocelot_ana.h (100%)
 rename {drivers/net/ethernet => include/soc}/mscc/ocelot_dev.h (100%)
 rename {drivers/net/ethernet => include/soc}/mscc/ocelot_qsys.h (100%)

-- 
2.17.1

