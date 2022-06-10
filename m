Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9498C545A8A
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 05:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238390AbiFJDec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 23:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiFJDeb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 23:34:31 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72613BFBC;
        Thu,  9 Jun 2022 20:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654832069; x=1686368069;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hYDsR4TQbviXC62T26WO5bArOW3LiQlcMfbeilBZIJc=;
  b=GTLp4fyIlcibv9o0ZFt/vilKREbok2rfVM77lte5VWiC2qTYjq+a13sA
   TA+X/jQTe0IAHvR2HgwrgNa2ytTTWSSM99vtodbUca2MXnrTNn2fqbp2w
   AJA6S5ksE0yb6PBwd2EPqRi54M7KFGiEbhjYTMeFs7VpiWc84ZOr3hz55
   ysXQzR/KwE21ZyxFGwUnK/R72jbImNrCBAUE1FSkMw8gLTenJHtJQDhh0
   J2fbN6TbBZry3DNwaEM0HO6QOlM0s5NkqtsNqUJxtxLrE/Lo6Euj5kiD/
   ITR7+qSlWCZ7hDT3OJdNYYn2b8PoskWoOtqCFofcq/2IIxxz2AQHO2XhT
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="341564084"
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="341564084"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2022 20:34:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="585971579"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by fmsmga007.fm.intel.com with ESMTP; 09 Jun 2022 20:34:24 -0700
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Emilio Riva <emilio.riva@ericsson.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net-next v2 0/7] pcs-xpcs, stmmac: add 1000BASE-X AN for network switch
Date:   Fri, 10 Jun 2022 11:29:35 +0800
Message-Id: <20220610032941.113690-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks Russell King [1] and Andrew Lunn [2] for v1 review and suggestion.
Since then, I have worked on refactoring the implementation as follow:

v2 changes:
1/7 - [New] Update xpcs_do_config to accept advertising input
2/7 - [New] Fix to compilation issue introduced v1. Update xpcs_do_config
            for sja1105.
3/7 - Same as 3/4 of v1 series.
4/7 - [Fix] Fix numerous issues identified by Russell King [1].
5/7 - [New] Make fixed-link setting takes precedence over ovr_an_inband.
            This is a fix to a bug introduced earlier. Separate patch
            will be sent later.
6/7 - [New] Allow phy-mode ACPI _DSD setting for dwmac-intel to overwrite
            the phy_interface detected through PCI DevID.
7/7 - [New] Make mdio register flow to skip PHY scanning if fixed-link
            is specified.

I have tested the patch-series on a 3-port SGMII Ethernet on Elkhart Lake
customer platform and PSE GbE1 (0000:00:1d.2) is setup for fixed-link
with below ACPI _DSD modification based on [3]:-

        Device (OTN1)
        {
            <snippet-remove>

            Name (_DSD, Package () {
                ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
                    Package () {
                        Package () {"phy-mode", "1000base-x"},
                    },
                ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
                    Package () {
                        Package () {"fixed-link", "LNK0"}
                    }
            })

            Name (LNK0, Package(){ // Data-only subnode of port
                ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
                    Package () {
                        Package () {"speed", 1000},
                        Package () {"full-duplex", 1}
                    }
            })
        }

The modified ACPI DSDT table is inserted into OS based on [4] for
testing purpose. This method will not be required if respective BIOS has
the matching ACPI _DSD changes. In gist, we avoid the need to add board
specific DMI based configuration to Linux driver and let ACPI DSDT table
customized according to hardware/port configuration design to decide how
the driver is loaded up per port-basis.

From dmesg below (whereby non-relevant section removed), we can see that:-

[    4.112037] intel-eth-pci 0000:00:1d.1 eno1: configuring for inband/sgmii link mode
[    4.132016] intel-eth-pci 0000:00:1d.2 eno2: configuring for fixed/1000base-x link mode
[    4.162069] intel-eth-pci 0000:00:1e.4 eno3: configuring for inband/sgmii link mode

-----------------------------------------------------------------------------------------------------------
[    1.471347] intel-eth-pci 0000:00:1d.1: stmmac_config_multi_msi: multi MSI enablement successful
[    1.471518] intel-eth-pci 0000:00:1d.1: User ID: 0x51, Synopsys ID: 0x52
[    1.471525] intel-eth-pci 0000:00:1d.1:      DWMAC4/5
[    1.471531] intel-eth-pci 0000:00:1d.1: DMA HW capability register supported
[    1.471533] intel-eth-pci 0000:00:1d.1: RX Checksum Offload Engine supported
[    1.471535] intel-eth-pci 0000:00:1d.1: TX Checksum insertion supported
[    1.471536] intel-eth-pci 0000:00:1d.1: TSO supported
[    1.471537] intel-eth-pci 0000:00:1d.1: Enable RX Mitigation via HW Watchdog Timer
[    1.471542] intel-eth-pci 0000:00:1d.1: device MAC address a8:a1:59:9d:2b:64
[    1.471545] intel-eth-pci 0000:00:1d.1: Enabled L3L4 Flow TC (entries=2)
[    1.471547] intel-eth-pci 0000:00:1d.1: Enabled RFS Flow TC (entries=10)
[    1.471552] intel-eth-pci 0000:00:1d.1: Enabling HW TC (entries=256, max_off=256)
[    1.471555] intel-eth-pci 0000:00:1d.1: TSO feature enabled
[    1.471556] intel-eth-pci 0000:00:1d.1: Using 32 bits DMA width
[    1.471770] mdio_bus stmmac-2: GPIO lookup for consumer reset
[    1.471774] mdio_bus stmmac-2: using lookup tables for GPIO lookup
[    1.471777] mdio_bus stmmac-2: No GPIO consumer reset found
[    1.481872] mdio_bus stmmac-2:01: GPIO lookup for consumer reset
[    1.481879] mdio_bus stmmac-2:01: using lookup tables for GPIO lookup
[    1.481881] mdio_bus stmmac-2:01: No GPIO consumer reset found
[    1.483206] Maxlinear Ethernet GPY215B stmmac-2:01: Firmware Version: 0x8764 (release)

[    1.683631] Maxlinear Ethernet GPY215B stmmac-2:01: attached PHY driver (mii_bus:phy_addr=stmmac-2:01, irq=POLL)

[    1.749607] intel-eth-pci 0000:00:1d.2: stmmac_config_multi_msi: multi MSI enablement successful
[    1.749677] intel-eth-pci 0000:00:1d.2: User ID: 0x51, Synopsys ID: 0x52
[    1.749681] intel-eth-pci 0000:00:1d.2:      DWMAC4/5
[    1.749688] intel-eth-pci 0000:00:1d.2: DMA HW capability register supported
[    1.749690] intel-eth-pci 0000:00:1d.2: RX Checksum Offload Engine supported
[    1.749692] intel-eth-pci 0000:00:1d.2: TX Checksum insertion supported
[    1.749693] intel-eth-pci 0000:00:1d.2: TSO supported
[    1.749694] intel-eth-pci 0000:00:1d.2: Enable RX Mitigation via HW Watchdog Timer
[    1.749701] intel-eth-pci 0000:00:1d.2: device MAC address a8:a1:59:9d:2b:46
[    1.749703] intel-eth-pci 0000:00:1d.2: Enabled L3L4 Flow TC (entries=2)
[    1.749705] intel-eth-pci 0000:00:1d.2: Enabled RFS Flow TC (entries=10)
[    1.749710] intel-eth-pci 0000:00:1d.2: Enabling HW TC (entries=256, max_off=256)
[    1.749712] intel-eth-pci 0000:00:1d.2: TSO feature enabled
[    1.749714] intel-eth-pci 0000:00:1d.2: Using 32 bits DMA width

[    1.749821] mdio_bus stmmac-3: GPIO lookup for consumer reset
[    1.749823] mdio_bus stmmac-3: using lookup tables for GPIO lookup
[    1.749825] mdio_bus stmmac-3: No GPIO consumer reset found
[    1.759184] mdio_bus stmmac-3:01: GPIO lookup for consumer reset
[    1.759188] mdio_bus stmmac-3:01: using lookup tables for GPIO lookup
[    1.759190] mdio_bus stmmac-3:01: No GPIO consumer reset found
[    1.760419] Maxlinear Ethernet GPY215B stmmac-3:01: Firmware Version: 0x8764 (release)

[    2.025792] intel-eth-pci 0000:00:1e.4: stmmac_config_multi_msi: multi MSI enablement successful
[    2.025876] intel-eth-pci 0000:00:1e.4: User ID: 0x51, Synopsys ID: 0x52
[    2.025881] intel-eth-pci 0000:00:1e.4:      DWMAC4/5
[    2.025887] sdhci-pci 0000:00:1a.1: No GPIO consumer (null) found
[    2.025888] intel-eth-pci 0000:00:1e.4: DMA HW capability register supported
[    2.025891] intel-eth-pci 0000:00:1e.4: RX Checksum Offload Engine supported
[    2.025893] intel-eth-pci 0000:00:1e.4: TX Checksum insertion supported
[    2.025894] intel-eth-pci 0000:00:1e.4: TSO supported
[    2.025896] intel-eth-pci 0000:00:1e.4: Enable RX Mitigation via HW Watchdog Timer
[    2.025913] intel-eth-pci 0000:00:1e.4: device MAC address a8:a1:59:9d:2b:7a
[    2.025915] intel-eth-pci 0000:00:1e.4: Enabled L3L4 Flow TC (entries=2)
[    2.025917] intel-eth-pci 0000:00:1e.4: Enabled RFS Flow TC (entries=10)
[    2.025924] intel-eth-pci 0000:00:1e.4: Enabling HW TC (entries=256, max_off=256)
[    2.025926] intel-eth-pci 0000:00:1e.4: TSO feature enabled
[    2.025928] intel-eth-pci 0000:00:1e.4: Using 40 bits DMA width
[    2.026024] mdio_bus stmmac-1: GPIO lookup for consumer reset
[    2.026027] mdio_bus stmmac-1: using lookup tables for GPIO lookup
[    2.026029] mdio_bus stmmac-1: No GPIO consumer reset found
[    2.035547] mdio_bus stmmac-1:01: GPIO lookup for consumer reset
[    2.035551] mdio_bus stmmac-1:01: using lookup tables for GPIO lookup
[    2.035553] mdio_bus stmmac-1:01: No GPIO consumer reset found
[    2.036905] Maxlinear Ethernet GPY215B stmmac-1:01: Firmware Version: 0x8764 (release)

[    2.239477] Maxlinear Ethernet GPY215B stmmac-1:01: attached PHY driver (mii_bus:phy_addr=stmmac-1:01, irq=POLL)

[    2.305510] intel-eth-pci 0000:00:1d.2 eno2: renamed from eth1
[    2.315038] intel-eth-pci 0000:00:1d.1 eno1: renamed from eth0
[    2.320776] intel-eth-pci 0000:00:1e.4 eno3: renamed from eth2

[    4.098137] intel-eth-pci 0000:00:1d.1 eno1: Register MEM_TYPE_PAGE_POOL RxQ-0
[    4.098647] intel-eth-pci 0000:00:1d.1 eno1: Register MEM_TYPE_PAGE_POOL RxQ-1
[    4.099187] intel-eth-pci 0000:00:1d.1 eno1: Register MEM_TYPE_PAGE_POOL RxQ-2
[    4.099695] intel-eth-pci 0000:00:1d.1 eno1: Register MEM_TYPE_PAGE_POOL RxQ-3
[    4.100168] intel-eth-pci 0000:00:1d.1 eno1: Register MEM_TYPE_PAGE_POOL RxQ-4
[    4.100636] intel-eth-pci 0000:00:1d.1 eno1: Register MEM_TYPE_PAGE_POOL RxQ-5
[    4.101114] intel-eth-pci 0000:00:1d.1 eno1: Register MEM_TYPE_PAGE_POOL RxQ-6
[    4.101586] intel-eth-pci 0000:00:1d.1 eno1: Register MEM_TYPE_PAGE_POOL RxQ-7
[    4.111664] dwmac4: Master AXI performs any burst length
[    4.111750] intel-eth-pci 0000:00:1d.1 eno1: Enabling Safety Features
[    4.111795] intel-eth-pci 0000:00:1d.1 eno1: IEEE 1588-2008 Advanced Timestamp supported
[    4.111897] intel-eth-pci 0000:00:1d.1 eno1: registered PTP clock
[    4.112033] intel-eth-pci 0000:00:1d.1 eno1: FPE workqueue start
[    4.112037] intel-eth-pci 0000:00:1d.1 eno1: configuring for inband/sgmii link mode
[    4.113621] 8021q: adding VLAN 0 to HW filter on device eno1

[    4.118316] intel-eth-pci 0000:00:1d.2 eno2: Register MEM_TYPE_PAGE_POOL RxQ-0
[    4.118835] intel-eth-pci 0000:00:1d.2 eno2: Register MEM_TYPE_PAGE_POOL RxQ-1
[    4.119338] intel-eth-pci 0000:00:1d.2 eno2: Register MEM_TYPE_PAGE_POOL RxQ-2
[    4.119815] intel-eth-pci 0000:00:1d.2 eno2: Register MEM_TYPE_PAGE_POOL RxQ-3
[    4.120282] intel-eth-pci 0000:00:1d.2 eno2: Register MEM_TYPE_PAGE_POOL RxQ-4
[    4.120758] intel-eth-pci 0000:00:1d.2 eno2: Register MEM_TYPE_PAGE_POOL RxQ-5
[    4.121228] intel-eth-pci 0000:00:1d.2 eno2: Register MEM_TYPE_PAGE_POOL RxQ-6
[    4.121706] intel-eth-pci 0000:00:1d.2 eno2: Register MEM_TYPE_PAGE_POOL RxQ-7
[    4.131662] dwmac4: Master AXI performs any burst length
[    4.131744] intel-eth-pci 0000:00:1d.2 eno2: Enabling Safety Features
[    4.131790] intel-eth-pci 0000:00:1d.2 eno2: IEEE 1588-2008 Advanced Timestamp supported
[    4.131873] intel-eth-pci 0000:00:1d.2 eno2: registered PTP clock
[    4.132010] intel-eth-pci 0000:00:1d.2 eno2: FPE workqueue start
[    4.132016] intel-eth-pci 0000:00:1d.2 eno2: configuring for fixed/1000base-x link mode
[    4.133517] 8021q: adding VLAN 0 to HW filter on device eno2
[    4.133677] intel-eth-pci 0000:00:1d.2 eno2: Link is Up - 1Gbps/Full - flow control off
[    4.133687] IPv6: ADDRCONF(NETDEV_CHANGE): eno2: link becomes ready

[    4.138058] intel-eth-pci 0000:00:1e.4 eno3: Register MEM_TYPE_PAGE_POOL RxQ-0
[    4.138557] intel-eth-pci 0000:00:1e.4 eno3: Register MEM_TYPE_PAGE_POOL RxQ-1
[    4.139105] intel-eth-pci 0000:00:1e.4 eno3: Register MEM_TYPE_PAGE_POOL RxQ-2
[    4.139581] intel-eth-pci 0000:00:1e.4 eno3: Register MEM_TYPE_PAGE_POOL RxQ-3
[    4.140071] intel-eth-pci 0000:00:1e.4 eno3: Register MEM_TYPE_PAGE_POOL RxQ-4
[    4.140547] intel-eth-pci 0000:00:1e.4 eno3: Register MEM_TYPE_PAGE_POOL RxQ-5
[    4.141041] intel-eth-pci 0000:00:1e.4 eno3: Register MEM_TYPE_PAGE_POOL RxQ-6
[    4.141519] intel-eth-pci 0000:00:1e.4 eno3: Register MEM_TYPE_PAGE_POOL RxQ-7
[    4.151671] dwmac4: Master AXI performs any burst length
[    4.151751] intel-eth-pci 0000:00:1e.4 eno3: Enabling Safety Features
[    4.161830] intel-eth-pci 0000:00:1e.4 eno3: IEEE 1588-2008 Advanced Timestamp supported
[    4.161916] intel-eth-pci 0000:00:1e.4 eno3: registered PTP clock
[    4.162063] intel-eth-pci 0000:00:1e.4 eno3: FPE workqueue start
[    4.162069] intel-eth-pci 0000:00:1e.4 eno3: configuring for inband/sgmii link mode
-----------------------------------------------------------------------------------------------------------

Also, thanks to Emilio Riva from Ericsson who has been helping me in testing the patch
on his system too.

Reference:
[1] https://patchwork.kernel.org/comment/24826650/
[2] https://patchwork.kernel.org/comment/24827101/
[3] https://www.kernel.org/doc/html/latest/firmware-guide/acpi/dsd/phy.html#mac-node-example-with-a-fixed-link-subnode
[4] https://www.kernel.org/doc/html/latest/admin-guide/acpi/initrd_table_override.html

Thanks
Boon Leong

Ong Boon Leong (7):
  net: pcs: xpcs: prepare xpcs_do_config to accept advertising input
  net: dsa: sja1105: update xpcs_do_config additional input
  stmmac: intel: prepare to support 1000BASE-X phy interface setting
  net: pcs: xpcs: add CL37 1000BASE-X AN support
  net: phylink: unset ovr_an_inband if fixed-link is selected
  stmmac: intel: add phy-mode ACPI _DSD setting support
  net: stmmac: make mdio register skips PHY scanning for fixed-link

 drivers/net/dsa/sja1105/sja1105_main.c        |   2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-intel.c |  19 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  11 +-
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |  14 ++
 drivers/net/pcs/pcs-xpcs.c                    | 186 +++++++++++++++++-
 drivers/net/phy/phylink.c                     |   4 +-
 include/linux/pcs/pcs-xpcs.h                  |   3 +-
 7 files changed, 226 insertions(+), 13 deletions(-)

--
2.25.1

