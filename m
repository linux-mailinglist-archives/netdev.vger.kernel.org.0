Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92852E91AC
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 09:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbhADIXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 03:23:47 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:54806 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbhADIXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 03:23:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1609748626; x=1641284626;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rreaNov0rckAIQ12g/4NUVOigVKvsV+c0gSkHKloWh8=;
  b=NHVSCosy8oioPSITSj4fDjSqvpY+hxfyvErWoARGNHUsJnMIvdJ6dO47
   wyLtyBBN1jMzqveCE2CuoK7POQIYxLyK6SzBvSISTSeVoDfbkDekJG0+n
   nbVOUqCYcPBt+dlJ1B7Okzoy5qSmC+RQTBMc2CFx9Tvp4znFxVbbXzfbS
   3kzk6kwz9gRxELmnFIM89PMRSWmLb/ioKCoVsktKicYXAK/IPxho8/gNz
   bnYXpwEs81Xi4x26+mJEdrXWGKrtTx4vXuLoAn0rslwCNGvWIYT0+2DXW
   fquFU6s2RJKTIqxL9sCveNTACd5qTqznhx3H+pR2doHQTg/FjCD49Dq0d
   w==;
IronPort-SDR: PNPHLuzM0/SDXsT1H0xB1EKMmmoTr/kuXOM1D1tvyguw7NJBPjJ7z0v4OjEPFzyD/2zxrC7ZvO
 CRgr+gqAX71Axf6EdPTlJencjEGCfUPFW9MWCQ3Z1DNjSQVM1JH5mScSZt6sLqQcSFG1KQV6st
 EDOgQpNLTmmqvrw25VuSmibn4Os9WD58zd5Iv9GCWRbj68RBuwuZ/Ojd1j7DgL3dgaJaQlmOn6
 cvpcceiuaPKDqNvvjZWv1kpK/1Cf3SycOgcanUTYUSOmTwlIxI3vuabvrl5+rehpohamxN77zq
 YhM=
X-IronPort-AV: E=Sophos;i="5.78,473,1599548400"; 
   d="scan'208";a="109665867"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jan 2021 01:22:30 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 4 Jan 2021 01:22:27 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 4 Jan 2021 01:22:25 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v11 0/4] Adding the Sparx5 Serdes driver
Date:   Mon, 4 Jan 2021 09:22:14 +0100
Message-ID: <20210104082218.1389450-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding the Sparx5 Serdes driver

This series of patches provides the serdes driver for the Microchip Sparx5
ethernet switch.

The serdes driver supports the 10G and 25G serdes instances available in the
Sparx5.

The Sparx5 serdes support several interface modes with several speeds and also
allows the client to change the mode and the speed according to changing in the
environment such as changing cables from DAC to fiber.

The serdes driver is to be used by the Sparx5 switchdev driver that
will follow in subsequent series.

Sparx5 Arhitecture:
===================

Below is a diagram of the Ethernet transport part of the Sparx5 chip.

The diagram shows the switch core that sends/receives traffic via the Frame Bus
and passes to the Port Modules.
The Port Modules are able to talk to a SerDes via a Port Muxing configuration.
The SerDes instances (33 in all) then passes the traffic on its lanes to the
attached cuPHY or SFP module.

 +---------------------------------------------------------+
 |                                                         |
 |                         Switch Core                     |
 |                                                         |
 +----------------------------+----------------------------+
                              |
 -------+--------------+------+-------+--------------+-----+   Frame Bus
        |              |              |              |
 +------+-----+ +------+-----+ +------+-----+ +------+-----+
 |1G/2.G Port | |5G Port     | |10G Port    | |25GG Port   |
 |Modules     | |Modules     | |Modules     | |Modules     |
 |MAC, PCS    | |MAC, PCS    | |MAC, PCS    | |MAC, PCS    |
 +------+-----+ +------+-----+ +------+-----+ +------+-----+
        |              |              |              |
 -------+-+------------+-------+------+----------+---+-----+  Port Muxing
          |                    |                 |
    +-----+----+         +-----+----+         +--+-------+
    |SerDes 5G |         |SerDes 10G|         |SerDes 25G|    SerDes Driver
    |Lane (13) |         |Lane (12) |         |Lane (8)  |    Controls these
    +-----+----+         +-----+----+         +-----+----+
          |                    |                    |
       to cuPHY             to cuPHY             to cuPHY
       or SFP               or SFP               or SFP

The 33 SerDes instances are handled internally by 2 SerDes macros types:

- A 10G SerDes macro that supports the following rates and modes:
  - 100 Mbps:
       - 100BASE-FX
  - 1.25 Gbps:
       - SGMII
       - 1000BASE-X
       - 1000BASE-KX
  - 3.125 Gbps:
       - 2.5GBASE-X
       - 2.5GBASE-KX
  - 5 Gbps:
       - QSGMII
       - USGMII
  - 5.15625 Gbps:
       - 5GBASE-KR
       - 5G-USXGMII
  - 10 Gbps:
       - 10G-USGMII
  - 10.3125 Gbps:
       - 10GBASE-R
       - 10GBASE-KR
       - USXGMII

- A 25G SerDes macro that supports the following rates and modes:
  - 1.25 Gbps:
       - SGMII
       - 1000BASE-X
       - 1000BASE-KX
  - 3.125 Gbps:
       - 2.5GBASE-X
       - 2.5GBASE-KX
  - 5 Gbps:
       - QSGMII
       - USGMII
  - 5.15625 Gbps:
       - 5GBASE-KR
       - 5G-USXGMII
  - 10 Gbps:
       - 10G-USGMII
  - 10.3125 Gbps:
       - 10GBASE-R
       - 10GBASE-KR
       - USXGMII
  - 10.3125 Gbps:
       - 10GBASE-R
       - 10GBASE-KR
       - USXGMII
  - 25.78125 Gbps:
       - 25GBASE-KR
       - 25GBASE-CR
       - 25GBASE-SR
       - 25GBASE-LR
       - 25GBASE-ER

The SerDes driver handles these SerDes instances and configures them based on
the selected mode, speed and media type.

In the current version of the SerDes driver only a subset of the above modes
are supported: the modes that can be tested on our current evaluation boards
(PCB134 and PCB35).

The first 13 10G SerDes macros are limited to 6G, and this gives the SerDes
instance architecture shown on the diagram above.

The Port Muxing allows a Port Module to use a specific SerDes instance, but not
all combinations are allowed.
This is functionality as well as the configuration of the Port Modules is
handled by the SwitchDev Driver.



History:
--------
v10 -> v11:
    Rebased on v5.11-rc1

v9 -> v10:
    Only add the new folder to the phy Kconfig (no sort fix)
    Corrected the serdes mode conversion for 2.5G mode.
    Clarified the SGMII and 1000BASEX conversion.
    Improved some of the more cryptic error messages.
    Expanded the validate function a bit, and removed the link status
    from the return value.

v8 -> v9:
    Replace pr_err with dev_err
    Expanded the description here in the cover letter (should probably og into
    the driver, at least part of it).

v7 -> v8:
    Provide the IO targets as offsets from the start of the IO range
    Initialise resource index

v6 -> v7:
    This series changes the way the IO targets are provided to the driver.
    Now only one IO range is available in the DT, and the driver has a table
    to map its targets (as their order is still not sequential), thus reducing
    the DT needed information and binding requirements.
    The register access macros have been converted to functions.

    - Bindings:
      - reg prop: minItems set to 1
      - reg-names prop: removed
    - Driver
      - Use one IO range and map targets via this.
      - Change register access macros to use functions.
      - Provided a new header files with reg access functions.
    - Device tree
      - Provide only one IO range

v5 -> v6:
     Series error: This had the same content as v5

v4 -> v5:
    - Bindings:
      - Removed .yaml from compatible string
      - reg prop: removed description and added minItems
      - reg-names prop: removed description and added const name list and
        minItems
      - #phy-cells prop: removed description and added maxItems
    - Configuration interface
      - Removed include of linux/phy.h
      - Added include of linux/types.h
    - Driver
       - Added include of linux/phy.h

v3 -> v4:
    - Add a reg-names item to the binding description
    - Add a clocks item to the binding description
    - Removed the clock parameter from the configuration interface
    - Use the clock dt node to get the coreclock, and using that when 
      doing the actual serdes configuration
    - Added a clocks entry with a system clock reference to the serdes node in
      the device tree

v2 -> v3:
    - Sorted the Kconfig sourced folders
    - Sorted the Makefile included folders
    - Changed the configuration interface documentation to use kernel style

v1 -> v2: Fixed kernel test robot warnings
    - Made these structures static:
      - media_presets_25g
      - mode_presets_25g
      - media_presets_10g
      - mode_presets_10g
    - Removed these duplicate initializations:
      - sparx5_sd25g28_params.cfg_rx_reserve_15_8
      - sparx5_sd25g28_params.cfg_pi_en
      - sparx5_sd25g28_params.cfg_cdrck_en
      - sparx5_sd10g28_params.cfg_cdrck_en

Lars Povlsen (2):
  dt-bindings: phy: Add sparx5-serdes bindings
  arm64: dts: sparx5: Add Sparx5 serdes driver node

Steen Hegelund (2):
  phy: Add ethernet serdes configuration option
  phy: Add Sparx5 ethernet serdes PHY driver

 .../bindings/phy/microchip,sparx5-serdes.yaml |  100 +
 arch/arm64/boot/dts/microchip/sparx5.dtsi     |    8 +
 drivers/phy/Kconfig                           |    1 +
 drivers/phy/Makefile                          |    1 +
 drivers/phy/microchip/Kconfig                 |   12 +
 drivers/phy/microchip/Makefile                |    6 +
 drivers/phy/microchip/sparx5_serdes.c         | 2443 +++++++++++++++
 drivers/phy/microchip/sparx5_serdes.h         |  129 +
 drivers/phy/microchip/sparx5_serdes_regs.h    | 2695 +++++++++++++++++
 include/linux/phy/phy-ethernet-serdes.h       |   30 +
 include/linux/phy/phy.h                       |    4 +
 11 files changed, 5429 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/microchip,sparx5-serdes.yaml
 create mode 100644 drivers/phy/microchip/Kconfig
 create mode 100644 drivers/phy/microchip/Makefile
 create mode 100644 drivers/phy/microchip/sparx5_serdes.c
 create mode 100644 drivers/phy/microchip/sparx5_serdes.h
 create mode 100644 drivers/phy/microchip/sparx5_serdes_regs.h
 create mode 100644 include/linux/phy/phy-ethernet-serdes.h

-- 
2.29.2

