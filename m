Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2A3130B8C
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 02:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbgAFBef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 20:34:35 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40969 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbgAFBee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 20:34:34 -0500
Received: by mail-wr1-f68.google.com with SMTP id c9so48004500wrw.8
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 17:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Wn9lD4wf2fXeKDISFAmCHmR1qNNsSr0HKZ2iA/Fz8fg=;
        b=Sb74lQCSTQ+Pwco2zKdJ5X+IPynreOMUdWuXxC32H+cpQncohIX+FNiivh0A0g4buK
         CW/ivRocrJPUhiHlZHcvbHWWA4yhfW+NVgUCbs3BEYFS/4Z3iVzY1sa1auSsqdV6zcmg
         1rSxOxdoBqVyXJwuGlcZdoxKhLt3h4Q0DT+OwIbkHwXOYHT+PFDfMVo42/fy5Op5lGV8
         OfpsBdvUp7gNSRRatlRtlK9FMVB6eDNs1SOJfjsxbJf4GYxYWSn/j9TsK6et4+e5Yta/
         DcbYokyPVsafPDT1FKOhpvTmOC+xrZU9ZqS+I4F0+6nBMoUR0sJ3PTjNW5kTGnqoNBLm
         ifoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Wn9lD4wf2fXeKDISFAmCHmR1qNNsSr0HKZ2iA/Fz8fg=;
        b=UOSw1rw5Tup/l5zEOJ/Fm0NbDDVh6K749z1pvmGs40SeJlQj5ILMe1cPH+8IxeL6fI
         eoUpIRwqLoqUj3S/Lp8EV7Cd8YZRrAi6Umq2K/EtzgDG1qZ5lHSXUZ8yb+zAMN53jRwR
         CCQkM7HSnPfja++lIg8PTUw2ZbrjSd7GVg9a2nksd+8SU8mUcgXjvtjeXLE9tL1ATBPF
         bwdwy3K/3aqThalTibN9aX0sVfaQ1c+ViXxKFoHW3oLXIrQoCQFuLeunzsptj0RFxDRG
         HM/JUnvOzFpddr4C5d0vLSyTymCUmgI2SzVkrMvyl8aDg1SKGwt6fOIji1BaqsPFgf8z
         Jwag==
X-Gm-Message-State: APjAAAVvZACsUDVmv1xkjaUX8Has48+P2ib/0INchE7rCgXKcHfF3byc
        dupwboptd1AgqHTzclCIAhM=
X-Google-Smtp-Source: APXvYqwr+DibRqbfbhBLkZhne0h8qwjQkJkuamlfEt7DB/tKv2kyhGaMDelyHrg+weGiiAnSBj1+aw==
X-Received: by 2002:a5d:51c1:: with SMTP id n1mr99036750wrv.335.1578274471510;
        Sun, 05 Jan 2020 17:34:31 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id l6sm1412756wmf.21.2020.01.05.17.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jan 2020 17:34:31 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com,
        linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Cc:     alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com,
        netdev@vger.kernel.org, alexandre.belloni@bootlin.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v5 net-next 0/9] Convert Felix DSA switch to PHYLINK
Date:   Mon,  6 Jan 2020 03:34:08 +0200
Message-Id: <20200106013417.12154-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

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
it in patch 9/9 (in a comment above vsc9959_pcs_init_2500basex).
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
attached PHY follows suite, but there is a gap here: the PHY driver does
not react to this setting, so only one of "AN on" and "AN off" works on
any particular PHY, even though that PHY might support bypassing the
SGMII AN process, as is the case on the VSC8514 PHY present on the
LS1028A-RDB board. A separate series will be sent to propose a way to
deal with that.

I dropped the Ocelot PHYLINK conversion because:
* I don't have VSC7514 hardware anyway
* The hardware is so different in this regard that there's almost nothing to
  share anyway.

Changes in v5:

- Added the register write to DEV_CLOCK_CFG back in
  felix_phylink_mac_config in patch 9/9.

Changes in v4:

- This is mostly a resend of v3, with the only notable change that I've
  dropped the PHY core patches for in_band_autoneg and I'll propose them
  independently.

v1 series:
https://www.spinics.net/lists/netdev/msg613869.html

RFC v2 series:
https://www.spinics.net/lists/netdev/msg620128.html

v3 series:
https://www.spinics.net/lists/netdev/msg622060.html

v4 series:
https://www.spinics.net/lists/netdev/msg622606.html

[0]: https://www.spinics.net/lists/netdev/msg613869.html
[1]: https://patents.google.com/patent/US7356047B1/en

Claudiu Manoil (1):
  enetc: Make MDIO accessors more generic and export to
    include/linux/fsl

Vladimir Oltean (8):
  mii: Add helpers for parsing SGMII auto-negotiation
  net: phylink: make QSGMII a valid PHY mode for in-band AN
  net: phylink: add support for polling MAC PCS
  net: dsa: Pass pcs_poll flag from driver to PHYLINK
  enetc: Set MDIO_CFG_HOLD to the recommended value of 2
  net: mscc: ocelot: make phy_mode a member of the common struct
    ocelot_port
  net: mscc: ocelot: export ANA, DEV and QSYS registers to
    include/soc/mscc
  net: dsa: felix: Add PCS operations for PHYLINK

 Documentation/networking/sfp-phylink.rst      |   3 +-
 drivers/net/dsa/ocelot/Kconfig                |   2 +
 drivers/net/dsa/ocelot/felix.c                | 265 ++++++++-
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
 drivers/net/phy/phylink.c                     |   4 +-
 include/linux/fsl/enetc_mdio.h                |  55 ++
 include/linux/mii.h                           |  50 ++
 include/linux/phylink.h                       |   2 +
 include/net/dsa.h                             |   5 +
 include/soc/mscc/ocelot.h                     |   2 +
 .../soc}/mscc/ocelot_ana.h                    |   0
 .../soc}/mscc/ocelot_dev.h                    |   0
 .../soc}/mscc/ocelot_qsys.h                   |   0
 include/uapi/linux/mii.h                      |  12 +
 net/dsa/port.c                                |   1 +
 27 files changed, 1036 insertions(+), 130 deletions(-)
 delete mode 100644 drivers/net/ethernet/freescale/enetc/enetc_mdio.h
 create mode 100644 include/linux/fsl/enetc_mdio.h
 rename {drivers/net/ethernet => include/soc}/mscc/ocelot_ana.h (100%)
 rename {drivers/net/ethernet => include/soc}/mscc/ocelot_dev.h (100%)
 rename {drivers/net/ethernet => include/soc}/mscc/ocelot_qsys.h (100%)

-- 
2.17.1

