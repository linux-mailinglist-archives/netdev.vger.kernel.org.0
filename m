Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1DD316196
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 09:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbhBJI4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 03:56:36 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:60494 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhBJIyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 03:54:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612947258; x=1644483258;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Dse980+UuN5jebdE850O9AhI4HYHS4fBhwNXLRf5BeQ=;
  b=zMEkHvMkVSzGfNyVFV2uBKWr2EcyraRo1cUyepNvTz1B4un4z90lAD0A
   uJMmZL6sa56G3X8TvSAUS2HctPhiN7BUdlaNsm+h166BV8dTK2kqOytvH
   WVQy8Nw65Mr7DaWqlVpm5ZDKyL6I0VYVfIXAOMvwKSP/20PhHXYRJUJsW
   LE1kM1RXwwDIH3LBVvg83/tSx/8LfNo6alvs5nUWkzbswh1HenGRys8zN
   hKYqTQTvkP6FiA8e2Uh8RMNim7FjKH+4qMV5Uaj4BzzEgy0UUrZXn00Qb
   Gpt/CK3c5lVWi4EozwV4VRTTTxXgs3Q/+2UWPW1mXCb4ijsvNalOr5IE+
   Q==;
IronPort-SDR: 9qHdUdqxH3A5XvC7SKpCB7HnllTVhO9MJWZz+dJ/hsD+PGyKQE89FAMlen7YSwcxTwqdohSv8J
 qCb7z1RqARJ7MuPPURvAm0UKiCVGu+R3jkV6G6D1gWSrXpsa99K4IuBDaUMrhxXzYzllUAnTem
 4skeKsWY5mUHeOn6KAaNA1/9GQRtDjNuqSe2TSqO9dLFYkpHSYkHxs474ShKeYDNluWATdQI49
 Ikn294epUpfKyLkBVwCv+xcgDoGVCkRfz3xO2a3Ar/zLA/pM2RwsSGFCRODaNtW4Aiie5hZomr
 f8A=
X-IronPort-AV: E=Sophos;i="5.81,167,1610434800"; 
   d="scan'208";a="114526914"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Feb 2021 01:53:02 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 10 Feb 2021 01:53:02 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 10 Feb 2021 01:53:00 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v14 0/4] Adding the Sparx5 Serdes driver
Date:   Wed, 10 Feb 2021 09:52:51 +0100
Message-ID: <20210210085255.2006824-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.30.0
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

Sparx5 Architecture:
====================

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
v13 -> v14:
    Changed the 25g apply, 10g apply and the CMU configuration functions to
    use a table based register update structure.
    The table entries still need serdes indices/instances so the table must
    be generated per serdes.

v12 -> v13:
    Interface changes:
        - Added set_media and set_speed interfaces on the generic phy
        - Removed the ethernet SerDes configuration structure and its
          header file.
    Implementation changes:
        - Implemented the new media and speed interfaces in the Serdes driver
        - Removed the configure interface function in the SerDes driver
        - The existing configuration function is now only used internally

v11 -> v12:
    Used bitfields for bools in configuration structures.
    Removed vertical alignment in structures.
    Removed CONFIG_DEBUG_KERNEL guard around warning checks

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

Steen Hegelund (4):
  dt-bindings: phy: Add sparx5-serdes bindings
  phy: Add media type and speed serdes configuration interfaces
  phy: Add Sparx5 ethernet serdes PHY driver
  arm64: dts: sparx5: Add Sparx5 serdes driver node

 .../bindings/phy/microchip,sparx5-serdes.yaml |  100 +
 arch/arm64/boot/dts/microchip/sparx5.dtsi     |    8 +
 drivers/phy/Kconfig                           |    1 +
 drivers/phy/Makefile                          |    1 +
 drivers/phy/microchip/Kconfig                 |   12 +
 drivers/phy/microchip/Makefile                |    6 +
 drivers/phy/microchip/sparx5_serdes.c         | 2467 +++++++++++++++
 drivers/phy/microchip/sparx5_serdes.h         |  136 +
 drivers/phy/microchip/sparx5_serdes_regs.h    | 2695 +++++++++++++++++
 drivers/phy/phy-core.c                        |   30 +
 include/linux/phy/phy.h                       |   26 +
 11 files changed, 5482 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/microchip,sparx5-serdes.yaml
 create mode 100644 drivers/phy/microchip/Kconfig
 create mode 100644 drivers/phy/microchip/Makefile
 create mode 100644 drivers/phy/microchip/sparx5_serdes.c
 create mode 100644 drivers/phy/microchip/sparx5_serdes.h
 create mode 100644 drivers/phy/microchip/sparx5_serdes_regs.h

-- 
2.30.0

