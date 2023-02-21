Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C77269EB4C
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 00:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbjBUXiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 18:38:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbjBUXiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 18:38:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754431C590;
        Tue, 21 Feb 2023 15:38:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB420B81032;
        Tue, 21 Feb 2023 23:38:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7C1C433D2;
        Tue, 21 Feb 2023 23:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677022690;
        bh=sV/DLXzFejr+dy3EK7cwoeu9TeqQDWSSm+iAPqI1QeQ=;
        h=From:To:Cc:Subject:Date:From;
        b=NERu7iFw2Y+3BofznIQEA63obPnPMZ/1sXxzybUtTZPjCjEPLmaMVkH4d6LEcCXG/
         ic2V1gsC5McKXe7RUG6J3Or3B4dnvJZQhSTEVPZEe/T8z8ESkY+j6BlGTVxpZ+ufmw
         rbx/4wWwu3Rljwl/3gOiK0cuUtZl0AH9k3hkAOLhb56w+BFeuH83FRzgQ7TEpu/aWm
         EW7XAPS5OOFhk0t4KD5HM2Rci/pgfeQRA8WRD9Jfo6vAG0hMEh1X/FxkQPimjIi1eu
         mYeArkDei8gS++nVP2qxibf4HgLHTtk3hZSKF4OL9wCfp9A1ya7jhoUmYaBBErojgA
         1698mtCs2i4dQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com,
        bpf@vger.kernel.org, ast@kernel.org
Subject: [PULL] Networking for v6.3
Date:   Tue, 21 Feb 2023 15:38:08 -0800
Message-Id: <20230221233808.1565509-1-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The following changes since commit ec35307e18ba8174e2a3f701956059f6a36f22fb:

  Merge tag 'drm-fixes-2023-02-17' of git://anongit.freedesktop.org/drm/drm (2023-02-16 20:23:32 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-6.3

for you to fetch changes up to d1fabc68f8e0541d41657096dc713cb01775652d:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2023-02-21 09:29:25 -0800)

----------------------------------------------------------------
Networking changes for 6.3.

Core
----

 - Add dedicated kmem_cache for typical/small skb->head, avoid having
   to access struct page at kfree time, and improve memory use.

 - Introduce sysctl to set default RPS configuration for new netdevs.

 - Define Netlink protocol specification format which can be used
   to describe messages used by each family and auto-generate parsers.
   Add tools for generating kernel data structures and uAPI headers.

 - Expose all net/core sysctls inside netns.

 - Remove 4s sleep in netpoll if carrier is instantly detected on boot.

 - Add configurable limit of MDB entries per port, and port-vlan.

 - Continue populating drop reasons throughout the stack.

 - Retire a handful of legacy Qdiscs and classifiers.

Protocols
---------

 - Support IPv4 big TCP (TSO frames larger than 64kB).

 - Add IP_LOCAL_PORT_RANGE socket option, to control local port range
   on socket by socket basis.

 - Track and report in procfs number of MPTCP sockets used.

 - Support mixing IPv4 and IPv6 flows in the in-kernel MPTCP
   path manager.

 - IPv6: don't check net.ipv6.route.max_size and rely on garbage
   collection to free memory (similarly to IPv4).

 - Support Penultimate Segment Pop (PSP) flavor in SRv6 (RFC8986).

 - ICMP: add per-rate limit counters.

 - Add support for user scanning requests in ieee802154.

 - Remove static WEP support.

 - Support minimal Wi-Fi 7 Extremely High Throughput (EHT) rate
   reporting.

 - WiFi 7 EHT channel puncturing support (client & AP).

BPF
---

 - Add a rbtree data structure following the "next-gen data structure"
   precedent set by recently added linked list, that is, by using
   kfunc + kptr instead of adding a new BPF map type.

 - Expose XDP hints via kfuncs with initial support for RX hash and
   timestamp metadata.

 - Add BPF_F_NO_TUNNEL_KEY extension to bpf_skb_set_tunnel_key
   to better support decap on GRE tunnel devices not operating
   in collect metadata.

 - Improve x86 JIT's codegen for PROBE_MEM runtime error checks.

 - Remove the need for trace_printk_lock for bpf_trace_printk
   and bpf_trace_vprintk helpers.

 - Extend libbpf's bpf_tracing.h support for tracing arguments of
   kprobes/uprobes and syscall as a special case.

 - Significantly reduce the search time for module symbols
   by livepatch and BPF.

 - Enable cpumasks to be used as kptrs, which is useful for tracing
   programs tracking which tasks end up running on which CPUs in
   different time intervals.

 - Add support for BPF trampoline on s390x and riscv64.

 - Add capability to export the XDP features supported by the NIC.

 - Add __bpf_kfunc tag for marking kernel functions as kfuncs.

 - Add cgroup.memory=nobpf kernel parameter option to disable BPF
   memory accounting for container environments.

Netfilter
---------

 - Remove the CLUSTERIP target. It has been marked as obsolete
   for years, and we still have WARN splats wrt. races of
   the out-of-band /proc interface installed by this target.

 - Add 'destroy' commands to nf_tables. They are identical to
   the existing 'delete' commands, but do not return an error if
   the referenced object (set, chain, rule...) did not exist.

Driver API
----------

 - Improve cpumask_local_spread() locality to help NICs set the right
   IRQ affinity on AMD platforms.

 - Separate C22 and C45 MDIO bus transactions more clearly.

 - Introduce new DCB table to control DSCP rewrite on egress.

 - Support configuration of Physical Layer Collision Avoidance (PLCA)
   Reconciliation Sublayer (RS) (802.3cg-2019). Modern version of
   shared medium Ethernet.

 - Support for MAC Merge layer (IEEE 802.3-2018 clause 99). Allowing
   preemption of low priority frames by high priority frames.

 - Add support for controlling MACSec offload using netlink SET.

 - Rework devlink instance refcounts to allow registration and
   de-registration under the instance lock. Split the code into multiple
   files, drop some of the unnecessarily granular locks and factor out
   common parts of netlink operation handling.

 - Add TX frame aggregation parameters (for USB drivers).

 - Add a new attr TCA_EXT_WARN_MSG to report TC (offload) warning
   messages with notifications for debug.

 - Allow offloading of UDP NEW connections via act_ct.

 - Add support for per action HW stats in TC.

 - Support hardware miss to TC action (continue processing in SW from
   a specific point in the action chain).

 - Warn if old Wireless Extension user space interface is used with
   modern cfg80211/mac80211 drivers. Do not support Wireless Extensions
   for Wi-Fi 7 devices at all. Everyone should switch to using nl80211
   interface instead.

 - Improve the CAN bit timing configuration. Use extack to return error
   messages directly to user space, update the SJW handling, including
   the definition of a new default value that will benefit CAN-FD
   controllers, by increasing their oscillator tolerance.

New hardware / drivers
----------------------

 - Ethernet:
   - nVidia BlueField-3 support (control traffic driver)
   - Ethernet support for imx93 SoCs
   - Motorcomm yt8531 gigabit Ethernet PHY
   - onsemi NCN26000 10BASE-T1S PHY (with support for PLCA)
   - Microchip LAN8841 PHY (incl. cable diagnostics and PTP)
   - Amlogic gxl MDIO mux

 - WiFi:
   - RealTek RTL8188EU (rtl8xxxu)
   - Qualcomm Wi-Fi 7 devices (ath12k)

 - CAN:
   - Renesas R-Car V4H

Drivers
-------

 - Bluetooth:
   - Set Per Platform Antenna Gain (PPAG) for Intel controllers.

 - Ethernet NICs:
   - Intel (1G, igc):
     - support TSN / Qbv / packet scheduling features of i226 model
   - Intel (100G, ice):
     - use GNSS subsystem instead of TTY
     - multi-buffer XDP support
     - extend support for GPIO pins to E823 devices
   - nVidia/Mellanox:
     - update the shared buffer configuration on PFC commands
     - implement PTP adjphase function for HW offset control
     - TC support for Geneve and GRE with VF tunnel offload
     - more efficient crypto key management method
     - multi-port eswitch support
   - Netronome/Corigine:
     - add DCB IEEE support
     - support IPsec offloading for NFP3800
   - Freescale/NXP (enetc):
     - enetc: support XDP_REDIRECT for XDP non-linear buffers
     - enetc: improve reconfig, avoid link flap and waiting for idle
     - enetc: support MAC Merge layer
   - Other NICs:
     - sfc/ef100: add basic devlink support for ef100
     - ionic: rx_push mode operation (writing descriptors via MMIO)
     - bnxt: use the auxiliary bus abstraction for RDMA
     - r8169: disable ASPM and reset bus in case of tx timeout
     - cpsw: support QSGMII mode for J721e CPSW9G
     - cpts: support pulse-per-second output
     - ngbe: add an mdio bus driver
     - usbnet: optimize usbnet_bh() by avoiding unnecessary queuing
     - r8152: handle devices with FW with NCM support
     - amd-xgbe: support 10Mbps, 2.5GbE speeds and rx-adaptation
     - virtio-net: support multi buffer XDP
     - virtio/vsock: replace virtio_vsock_pkt with sk_buff
     - tsnep: XDP support

 - Ethernet high-speed switches:
   - nVidia/Mellanox (mlxsw):
     - add support for latency TLV (in FW control messages)
   - Microchip (sparx5):
     - separate explicit and implicit traffic forwarding rules, make
       the implicit rules always active
     - add support for egress DSCP rewrite
     - IS0 VCAP support (Ingress Classification)
     - IS2 VCAP filters (protos, L3 addrs, L4 ports, flags, ToS etc.)
     - ES2 VCAP support (Egress Access Control)
     - support for Per-Stream Filtering and Policing (802.1Q, 8.6.5.1)

 - Ethernet embedded switches:
   - Marvell (mv88e6xxx):
     - add MAB (port auth) offload support
     - enable PTP receive for mv88e6390
   - NXP (ocelot):
     - support MAC Merge layer
     - support for the the vsc7512 internal copper phys
   - Microchip:
     - lan9303: convert to PHYLINK
     - lan966x: support TC flower filter statistics
     - lan937x: PTP support for KSZ9563/KSZ8563 and LAN937x
     - lan937x: support Credit Based Shaper configuration
     - ksz9477: support Energy Efficient Ethernet
   - other:
     - qca8k: convert to regmap read/write API, use bulk operations
     - rswitch: Improve TX timestamp accuracy

 - Intel WiFi (iwlwifi):
   - EHT (Wi-Fi 7) rate reporting
   - STEP equalizer support: transfer some STEP (connection to radio
     on platforms with integrated wifi) related parameters from the
     BIOS to the firmware.

 - Qualcomm 802.11ax WiFi (ath11k):
   - IPQ5018 support
   - Fine Timing Measurement (FTM) responder role support
   - channel 177 support

 - MediaTek WiFi (mt76):
   - per-PHY LED support
   - mt7996: EHT (Wi-Fi 7) support
   - Wireless Ethernet Dispatch (WED) reset support
   - switch to using page pool allocator

 - RealTek WiFi (rtw89):
   - support new version of Bluetooth co-existance

 - Mobile:
   - rmnet: support TX aggregation.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Aaron Ma (1):
      wifi: mt76: mt7921: fix error code of return in mt7921_acpi_read

Adham Faris (2):
      net/mlx5e: Fail with messages when params are not valid for XSK
      net/mlx5e: Add warning when log WQE size is smaller than log stride size

Ajit Khaparde (7):
      bnxt_en: Add auxiliary driver support
      RDMA/bnxt_re: Use auxiliary driver interface
      bnxt_en: Remove usage of ulp_id
      bnxt_en: Use direct API instead of indirection
      bnxt_en: Use auxiliary bus calls over proprietary calls
      RDMA/bnxt_re: Remove the sriov config callback
      bnxt_en: Remove runtime interrupt vector allocation

Alan Maguire (1):
      bpf: Add --skip_encoding_btf_inconsistent_proto, --btf_gen_optimized to pahole flags for v1.25

Alejandro Lucero (9):
      sfc: add devlink support for ef100
      sfc: add devlink info support for ef100
      sfc: enumerate mports in ef100
      sfc: add mport lookup based on driver's mport data
      sfc: add devlink port support for ef100
      sfc: obtain device mac address based on firmware handle for ef100
      sfc: add support for devlink port_function_hw_addr_get in ef100
      sfc: add support for devlink port_function_hw_addr_set in ef100
      sfc: fix builds without CONFIG_RTC_LIB

Alex Elder (51):
      net: ipa: introduce a common microcontroller interrupt handler
      net: ipa: introduce ipa_interrupt_enable()
      net: ipa: enable IPA interrupt handlers separate from registration
      net: ipa: register IPA interrupt handlers directly
      net: ipa: kill ipa_interrupt_add()
      net: ipa: don't maintain IPA interrupt handler array
      net: ipa: refactor status buffer parsing
      net: ipa: stop using sizeof(status)
      net: ipa: define all IPA status mask bits
      net: ipa: rename the NAT enumerated type
      net: ipa: define remaining IPA status field values
      net: ipa: IPA status preparatory cleanups
      net: ipa: introduce generalized status decoder
      net: ipa: add IPA v5.0 packet status support
      net: ipa: support more endpoints
      net: ipa: extend endpoints in packet init command
      net: ipa: define IPA v5.0+ registers
      net: ipa: update table cache flushing
      net: ipa: support zeroing new cache tables
      net: ipa: greater timer granularity options
      net: ipa: support a third pulse register
      net: ipa: define two new memory regions
      net: ipa: generic command param fix
      net: ipa: get rid of ipa->reg_addr
      net: ipa: add some new IPA versions
      net: ipa: tighten up IPA register validity checking
      net: ipa: use bitmasks for GSI IRQ values
      net: ipa: GSI register cleanup
      net: ipa: start generalizing "ipa_reg"
      net: ipa: generalize register offset functions
      net: ipa: generalize register field functions
      net: ipa: introduce gsi_reg_init()
      net: ipa: introduce GSI register IDs
      net: ipa: start creating GSI register definitions
      net: ipa: add more GSI register definitions
      net: ipa: define IPA v3.1 GSI event ring register offsets
      net: ipa: define IPA v3.1 GSI interrupt register offsets
      net: ipa: add "gsi_v3.5.1.c"
      net: ipa: define IPA remaining GSI register offsets
      net: ipa: populate more GSI register files
      net: ipa: define GSI CH_C_QOS register fields
      net: ipa: define more fields for GSI registers
      net: ipa: define fields for event-ring related registers
      net: ipa: add "gsi_v4.11.c"
      net: ipa: define fields for remaining GSI registers
      net: ipa: fix an incorrect assignment
      net: ipa: kill gsi->virt_raw
      net: ipa: kill ev_ch_e_cntxt_1_length_encode()
      net: ipa: avoid setting an undefined field
      net: ipa: support different event ring encoding
      net: ipa: add HW_PARAM_4 GSI register

Alexander Lobakin (7):
      ice: fix ice_tx_ring:: Xdp_tx_active underflow
      ice: Fix XDP Tx ring overrun
      ice: Remove two impossible branches on XDP Tx cleaning
      ice: Robustify cleaning/completing XDP Tx buffers
      ice: Fix freeing XDP frames backed by Page Pool
      ice: Micro-optimize .ndo_xdp_xmit() path
      bpf, test_run: fix &xdp_frame misplacement for LIVE_FRAMES

Alexander Wetzel (1):
      wifi: cfg80211: Fix use after free for wext

Alexandra Winter (1):
      s390/ctcm: cleanup indenting

Alexei Starovoitov (16):
      libbpf: Restore errno after pr_warn.
      Merge branch 'selftests/xsk: speed-ups, fixes, and new XDP programs'
      Merge branch 'samples/bpf: modernize BPF functionality test programs'
      Merge branch 'kallsyms: Optimize the search for module symbols by livepatch and bpf'
      Merge branch 'Dynptr fixes'
      Merge branch 'Enable cpumasks to be used as kptrs'
      Merge branch 'Enable struct_ops programs to be sleepable'
      Merge branch 'Support bpf trampoline for s390x'
      Merge branch ' docs/bpf: Add description of register liveness tracking algorithm'
      Merge branch 'xdp: introduce xdp-feature support'
      Merge branch 'bpf, mm: introduce cgroup.memory=nobpf'
      Merge branch 'BPF rbtree next-gen datastructure'
      Revert "bpf: Add --skip_encoding_btf_inconsistent_proto, --btf_gen_optimized to pahole flags for v1.25"
      selftests/bpf: Fix map_kptr test.
      Merge branch 'Improvements for BPF_ST tracking by verifier '
      Merge branch 'Use __GFP_ZERO in bpf memory allocator'

Alexey Kodanev (1):
      wifi: orinoco: check return value of hermes_write_wordrec()

Alok Tiwari (1):
      netfilter: nf_tables: NULL pointer dereference in nf_tables_updobj()

Aloka Dixit (4):
      wifi: cfg80211: move puncturing bitmap validation from mac80211
      wifi: nl80211: validate and configure puncturing bitmap
      wifi: cfg80211: include puncturing bitmap in channel switch events
      wifi: mac80211: configure puncturing bitmap

Alvin Šipraga (2):
      wifi: nl80211: emit CMD_START_AP on multicast group when an AP is started
      wifi: nl80211: add MLO_LINK_ID to CMD_STOP_AP event

Amit Cohen (6):
      mlxsw: reg: Add TLV related fields to MGIR register
      mlxsw: Enable string TLV usage according to MGIR output
      mlxsw: core: Do not worry about changing 'enable_string_tlv' while sending EMADs
      mlxsw: emad: Add support for latency TLV
      mlxsw: core: Define latency TLV fields
      mlxsw: Add support of latency TLV

Amritha Nambiar (1):
      ice: Support drop action

Anand Moon (1):
      dt-bindings: net: rockchip-dwmac: fix rv1126 compatible warning

Anatolii Gerasymenko (1):
      ice: Handle LLDP MIB Pending change

Andrea Mayer (3):
      seg6: factor out End lookup nexthop processing to a dedicated function
      seg6: add PSP flavor support for SRv6 End behavior
      selftests: seg6: add selftest for PSP flavor in SRv6 End behavior

Andrei Otcheretianski (1):
      wifi: mac80211: Don't translate MLD addresses for multicast

Andrew Halaney (1):
      dt-bindings: net: snps,dwmac: Fix snps,reset-delays-us dependency

Andrew Lunn (46):
      net: mdio: Add dedicated C45 API to MDIO bus drivers
      net: pcs: pcs-xpcs: Use C45 MDIO API
      net: mdio: mdiobus_register: update validation test
      net: mdio: C22 is now optional, EOPNOTSUPP if not provided
      net: mdio: Move mdiobus_c45_addr() next to users
      net: mdio: mdio-bitbang: Separate C22 and C45 transactions
      net: mdio: mvmdio: Convert XSMI bus to new API
      net: mdio: xgmac_mdio: Separate C22 and C45 transactions
      net: fec: Separate C22 and C45 transactions
      net: mdio: add mdiobus_c45_read/write_nested helpers
      net: dsa: mv88e6xxx: Separate C22 and C45 transactions
      net: mdio: cavium: Separate C22 and C45 transactions
      net: mdio: i2c: Separate C22 and C45 transactions
      net: mdio: mux-bcm-iproc: Separate C22 and C45 transactions
      net: mdio: aspeed: Separate C22 and C45 transactions
      net: mdio: ipq4019: Separate C22 and C45 transactions
      net: ethernet: mtk_eth_soc: Separate C22 and C45 transactions
      net: lan743x: Separate C22 and C45 transactions
      net: stmmac: Separate C22 and C45 transactions for xgmac2
      net: stmmac: Separate C22 and C45 transactions for xgmac
      enetc: Separate C22 and C45 transactions
      regmap: Rework regmap_mdio_c45_{read|write} for new C45 API.
      net: mdio: cavium: Remove unneeded simicolons
      net: dsa: mt7530: Separate C22 and C45 MDIO bus transactions
      net: sxgbe: Separate C22 and C45 transactions
      net: nixge: Separate C22 and C45 transactions
      net: macb: Separate C22 and C45 transactions
      ixgbe: Separate C22 and C45 transactions
      ixgbe: Use C45 mdiobus accessors
      net: hns: Separate C22 and C45 transactions
      amd-xgbe: Separate C22 and C45 transactions
      amd-xgbe: Replace MII_ADDR_C45 with XGBE_ADDR_C45
      net: dsa: sja1105: C45 only transactions for PCS
      net: dsa: sja1105: Separate C22 and C45 transactions for T1 MDIO bus
      net: mdio: Move mdiobus_scan() within file
      net: mdio: Rework scanning of bus ready for quirks
      net: mdio: Add workaround for Micrel PHYs which are not C45 compatible
      net: mdio: scan bus based on bus capabilities for C22 and C45
      net: phy: Decide on C45 capabilities based on presence of method
      net: phy: Remove probe_capabilities
      net: phy: Remove fallback to old C45 method
      net: Remove C45 check in C22 only MDIO bus drivers
      net: mdio: Remove support for building C45 muxed addresses
      net: phy: marvell: Use the unlocked genphy_c45_ethtool_get_eee()
      net: phy: Add locks to ethtool functions
      net: phy: Read EEE abilities when using .features

Andrii Nakryiko (45):
      libbpf: Fix single-line struct definition output in btf_dump
      libbpf: Handle non-standardly sized enums better in BTF-to-C dumper
      selftests/bpf: Add non-standardly sized enum tests for btf_dump
      libbpf: Fix btf__align_of() by taking into account field offsets
      libbpf: Fix BTF-to-C converter's padding logic
      selftests/bpf: Add few corner cases to test padding handling of btf_dump
      libbpf: Fix btf_dump's packed struct determination
      Merge branch 'bpftool: improve error handing for missing .BTF section'
      libbpf: start v1.2 development cycle
      bpf: teach refsafe() to take into account ID remapping
      bpf: reorganize struct bpf_reg_state fields
      bpf: generalize MAYBE_NULL vs non-MAYBE_NULL rule
      bpf: reject non-exact register type matches in regsafe()
      bpf: perform byte-by-byte comparison only when necessary in regsafe()
      bpf: fix regs_exact() logic in regsafe() to remap IDs correctly
      Merge branch 'samples/bpf: enhance syscall tracing program'
      libbpf: Add support for fetching up to 8 arguments in kprobes
      libbpf: Add 6th argument support for x86-64 in bpf_tracing.h
      libbpf: Fix arm and arm64 specs in bpf_tracing.h
      libbpf: Complete mips spec in bpf_tracing.h
      libbpf: Complete powerpc spec in bpf_tracing.h
      libbpf: Complete sparc spec in bpf_tracing.h
      libbpf: Complete riscv arch spec in bpf_tracing.h
      libbpf: Fix and complete ARC spec in bpf_tracing.h
      libbpf: Complete LoongArch (loongarch) spec in bpf_tracing.h
      libbpf: Add BPF_UPROBE and BPF_URETPROBE macro aliases
      selftests/bpf: Validate arch-specific argument registers limits
      libbpf: Improve syscall tracing support in bpf_tracing.h
      libbpf: Define x86-64 syscall regs spec in bpf_tracing.h
      libbpf: Define i386 syscall regs spec in bpf_tracing.h
      libbpf: Define s390x syscall regs spec in bpf_tracing.h
      libbpf: Define arm syscall regs spec in bpf_tracing.h
      libbpf: Define arm64 syscall regs spec in bpf_tracing.h
      libbpf: Define mips syscall regs spec in bpf_tracing.h
      libbpf: Define powerpc syscall regs spec in bpf_tracing.h
      libbpf: Define sparc syscall regs spec in bpf_tracing.h
      libbpf: Define riscv syscall regs spec in bpf_tracing.h
      libbpf: Define arc syscall regs spec in bpf_tracing.h
      libbpf: Define loongarch syscall regs spec in bpf_tracing.h
      selftests/bpf: Add 6-argument syscall tracing test
      libbpf: Clean up now not needed __PT_PARM{1-6}_SYSCALL_REG defaults
      Merge branch 'New benchmark for hashmap lookups'
      bpf: Fix global subprog context argument resolution logic
      selftests/bpf: Convert test_global_funcs test to test_loader framework
      selftests/bpf: Add global subprog context passing tests

Andy Shevchenko (6):
      ACPI: utils: Add acpi_evaluate_dsm_typed() and acpi_check_dsm() stubs
      net: hns: Switch to use acpi_evaluate_dsm_typed()
      net: mdiobus: Convert to use fwnode_device_is_compatible()
      string_helpers: Move string_is_valid() to the header
      genetlink: Use string_is_terminated() helper
      openvswitch: Use string_is_terminated() helper

Anirudh Venkataramanan (2):
      ice: remove redundant non-null check in ice_setup_pf_sw()
      ice: Add support for 100G KR2/CR2/SR2 link reporting

Anton Protopopov (7):
      selftest/bpf/benchs: Fix a typo in bpf_hashmap_full_update
      selftest/bpf/benchs: Make a function static in bpf_hashmap_full_update
      selftest/bpf/benchs: Enhance argp parsing
      selftest/bpf/benchs: Remove an unused header
      selftest/bpf/benchs: Make quiet option common
      selftest/bpf/benchs: Print less if the quiet option is set
      selftest/bpf/benchs: Add benchmark for hashmap lookups

Archie Pusaka (2):
      Bluetooth: Free potentially unfreed SCO connection
      Bluetooth: Make sure LE create conn cancel is sent when timeout

Arend van Spriel (1):
      wifi: brcmfmac: change cfg80211_set_channel() name and signature

Arkadiusz Kubalewski (1):
      ice: use GNSS subsystem instead of TTY

Arnd Bergmann (11):
      at86rf230: convert to gpio descriptors
      fec: convert to gpio descriptor
      cc2520: move to gpio descriptors
      net: dsa: microchip: ptp: fix up PTP dependency
      amd-xgbe: fix mismatched prototype
      mlx5: reduce stack usage in mlx5_setup_tc
      net: dsa: ocelot: add PTP dependency for NET_DSA_MSCC_OCELOT_EXT
      wifi: mac80211: avoid u32_encode_bits() warning
      wifi: rtl8xxxu: add LEDS_CLASS dependency
      sfc: use IS_ENABLED() checks for CONFIG_SFC_SRIOV
      net: microchip: sparx5: reduce stack usage

Arseniy Krasnov (3):
      test/vsock: rework message bounds test
      test/vsock: add big message test
      test/vsock: vsock_perf utility

Arun Ramadoss (7):
      net: dsa: microchip: ptp: add 4 bytes in tail tag when ptp enabled
      net: dsa: microchip: ptp: enable interrupt for timestamping
      net: dsa: microchip: ptp: add support for perout programmable pins
      net: dsa: microchip: ptp: lan937x: add 2 step timestamping
      net: dsa: microchip: ptp: lan937x: Enable periodic output in LED pins
      net: dsa: microchip: enable port queues for tc mqprio
      net: dsa: microchip: add support for credit based shaper

Arınç ÜNAL (1):
      dt-bindings: net: dsa: mediatek,mt7530: improve binding description

Ayala Barazani (1):
      wifi: iwlwifi: mvm: Support STEP equalizer settings from BIOS.

Bagas Sanjaya (1):
      Documentation: bpf: Add missing line break separator in node_data struct code block

Bin Chen (1):
      nfp: add DCB IEEE support

Bitterblue Smith (15):
      wifi: rtl8xxxu: Fix assignment to bit field priv->pi_enabled
      wifi: rtl8xxxu: Fix assignment to bit field priv->cck_agc_report_type
      wifi: rtl8xxxu: Deduplicate the efuse dumping code
      wifi: rtl8xxxu: Make rtl8xxxu_load_firmware take const char*
      wifi: rtl8xxxu: Define masks for cck_agc_rpt bits
      wifi: rtl8xxxu: Add rate control code for RTL8188EU
      wifi: rtl8xxxu: Fix memory leaks with RTL8723BU, RTL8192EU
      wifi: rtl8xxxu: Report the RSSI to the firmware
      wifi: rtl8xxxu: Use a longer retry limit of 48
      wifi: rtl8xxxu: Print the ROM version too
      wifi: rtl8xxxu: Dump the efuse only for untested devices
      wifi: rtl8xxxu: Register the LED and make it blink
      wifi: rtl8xxxu: Add LED control code for RTL8188EU
      wifi: rtl8xxxu: Add LED control code for RTL8192EU
      wifi: rtl8xxxu: Add LED control code for RTL8723AU

Bjorn Helgaas (8):
      e1000e: Remove redundant pci_enable_pcie_error_reporting()
      fm10k: Remove redundant pci_enable_pcie_error_reporting()
      i40e: Remove redundant pci_enable_pcie_error_reporting()
      iavf: Remove redundant pci_enable_pcie_error_reporting()
      ice: Remove redundant pci_enable_pcie_error_reporting()
      igb: Remove redundant pci_enable_pcie_error_reporting()
      igc: Remove redundant pci_enable_pcie_error_reporting()
      ixgbe: Remove redundant pci_enable_pcie_error_reporting()

Björn Töpel (1):
      selftests/bpf: Cross-compile bpftool

Bjørn Mork (2):
      r8152: add USB device driver for config selection
      cdc_ether: no need to blacklist any r8152 devices

Bo Liu (3):
      net: dsa: Use sysfs_emit() to instead of sprintf()
      rfkill: Use sysfs_emit() to instead of sprintf()
      ethtool: pse-pd: Fix double word in comments

Bobby Eshleman (2):
      vsock: return errors other than -ENOMEM to socket
      virtio/vsock: replace virtio_vsock_pkt with sk_buff

Borislav Petkov (AMD) (1):
      hamradio: baycom_epp: Do not use x86-specific rdtsc()

Breno Leitao (1):
      netpoll: Remove 4s sleep during carrier detection

Brett Creeley (1):
      ice: Add more usage of existing function ice_get_vf_vsi(vf)

Brian Haley (1):
      neighbor: fix proxy_delay usage when it is zero

Caleb Connolly (1):
      net: ipa: use dev PM wakeirq handling

Changbin Du (3):
      libbpf: Show error info about missing ".BTF" section
      bpf: makefiles: Do not generate empty vmlinux.h
      libbpf: Return -ENODATA for missing btf section

Chethan Suresh (1):
      bpftool: fix output for skipping kernel config check

Chih-Kang Chang (2):
      wifi: rtw89: 8852c: rfk: refine AGC tuning flow of DPK for irregular PA
      wifi: rtw89: 8852c: rfk: correct ADC clock settings

Chin-Yen Lee (4):
      wifi: rtw89: fix potential wrong mapping for pkt-offload
      wifi: rtw89: refine packet offload flow
      wifi: rtw89: 8852be: enable CLKREQ of PCI capability
      wifi: rtw89: move H2C of del_pkt_offload before polling FW status ready

Ching-Te Ku (27):
      wifi: rtw89: coex: Enable Bluetooth report when show debug info
      wifi: rtw89: coex: Update BTC firmware report bitmap definition
      wifi: rtw89: coex: Add v2 BT AFH report and related variable
      wifi: rtw89: coex: refactor _chk_btc_report() to extend more features
      wifi: rtw89: coex: Change TDMA related logic to version separate
      wifi: rtw89: coex: Remove le32 to CPU translator at firmware cycle report
      wifi: rtw89: coex: Rename BTC firmware cycle report by feature version
      wifi: rtw89: coex: Add v4 version firmware cycle report
      wifi: rtw89: coex: Change firmware control report to version separate
      wifi: rtw89: coex: Add v5 firmware control report
      wifi: rtw89: coex: only read Bluetooth counter of report version 1 for RTL8852A
      wifi: rtw89: coex: Update WiFi role info H2C report
      wifi: rtw89: coex: Add version code for Wi-Fi firmware coexistence control
      wifi: rtw89: coex: Change Wi-Fi Null data report to version separate
      wifi: rtw89: coex: Change firmware steps report to version separate
      wifi: rtw89: coex: refactor debug log of slot list
      wifi: rtw89: coex: Packet traffic arbitration hardware owner monitor
      wifi: rtw89: coex: Change RTL8852B use v1 TDMA policy
      wifi: rtw89: coex: Change Wi-Fi role info related logic to version separate
      wifi: rtw89: coex: Update Wi-Fi external control TDMA parameters/tables
      wifi: rtw89: coex: Clear Bluetooth HW PTA counter when radio state change
      wifi: rtw89: coex: Force to update TDMA parameter when radio state change
      wifi: rtw89: coex: Refine coexistence log
      wifi: rtw89: coex: Set Bluetooth background scan PTA request priority
      wifi: rtw89: coex: Correct A2DP exist variable source
      wifi: rtw89: coex: Fix test fail when coexist with raspberryPI A2DP idle
      wifi: rtw89: coex: Update Wi-Fi Bluetooth coexistence version to 7.0.0

Christian Eggers (8):
      net: dsa: microchip: ptp: add the posix clock support
      net: dsa: microchip: ptp: Initial hardware time stamping support
      net: dsa: microchip: ptp: manipulating absolute time using ptp hw clock
      net: ptp: add helper for one-step P2P clocks
      net: dsa: microchip: ptp: add packet reception timestamping
      net: dsa: microchip: ptp: add packet transmission timestamping
      net: dsa: microchip: ptp: move pdelay_rsp correction field to tail tag
      net: dsa: microchip: ptp: add periodic output signal

Christian Ehrig (2):
      bpf: Add flag BPF_F_NO_TUNNEL_KEY to bpf_skb_set_tunnel_key()
      selftests/bpf: Add BPF_F_NO_TUNNEL_KEY test

Christian Marangi (2):
      net: dsa: qca8k: add QCA8K_ATU_TABLE_SIZE define for fdb access
      net: dsa: qca8k: convert to regmap read/write API

Christoph Heiss (1):
      net: alx: Switch to DEFINE_SIMPLE_DEV_PM_OPS() and pm_sleep_ptr()

Christophe JAILLET (1):
      net: ethernet: mtk_wed: No need to clear memory after a dma_alloc_coherent() call

Chuanhong Guo (1):
      wifi: mt76: mt7921u: add support for Comfast CF-952AX

Clark Wang (7):
      net: stmmac: add imx93 platform support
      dt-bindings: add mx93 description
      dt-bindings: net: fec: add mx93 description
      arm64: dts: imx93: add eqos support
      arm64: dts: imx93: add FEC support
      arm64: dts: imx93-11x11-evk: enable eqos
      arm64: dts: imx93-11x11-evk: enable fec function

Clément Léger (1):
      net: pcs: rzn1-miic: remove unused struct members and use miic variable

Colin Foster (24):
      dt-bindings: dsa: sync with maintainers
      dt-bindings: net: dsa: sf2: fix brcm,use-bcm-hdr documentation
      dt-bindings: net: dsa: qca8k: remove address-cells and size-cells from switch node
      dt-bindings: net: dsa: utilize base definitions for standard dsa switches
      dt-bindings: net: dsa: allow additional ethernet-port properties
      dt-bindings: net: dsa: qca8k: utilize shared dsa.yaml
      dt-bindings: net: dsa: mediatek,mt7530: remove unnecessary dsa-port reference
      dt-bindings: net: add generic ethernet-switch
      dt-bindings: net: add generic ethernet-switch-port binding
      dt-bindings: net: mscc,vsc7514-switch: utilize generic ethernet-switch.yaml
      net: mscc: ocelot: expose ocelot wm functions
      net: mscc: ocelot: expose regfield definition to be used by other drivers
      net: mscc: ocelot: expose vcap_props structure
      net: mscc: ocelot: expose ocelot_reset routine
      net: mscc: ocelot: expose vsc7514_regmap definition
      net: dsa: felix: add configurable device quirks
      net: dsa: felix: add support for MFD configurations
      net: dsa: felix: add functionality when not all ports are supported
      mfd: ocelot: prepend resource size macros to be 32-bit
      dt-bindings: net: mscc,vsc7514-switch: add dsa binding for the vsc7512
      dt-bindings: mfd: ocelot: add ethernet-switch hardware support
      net: dsa: ocelot: add external ocelot switch control
      mfd: ocelot: add external ocelot switch control
      net: mscc: ocelot: un-export unused regmap symbols

Colin Ian King (2):
      selftests/bpf: Fix spelling mistake "detecion" -> "detection"
      sfc: Fix spelling mistake "creationg" -> "creating"

Connor O'Brien (1):
      bpf: btf: limit logging of ignored BTF mismatches

D. Wythe (6):
      net/smc: llc_conf_mutex refactor, replace it with rw_semaphore
      net/smc: use read semaphores to reduce unnecessary blocking in smc_buf_create() & smcr_buf_unuse()
      net/smc: reduce unnecessary blocking in smcr_lgr_reg_rmbs()
      net/smc: replace mutex rmbs_lock and sndbufs_lock with rw_semaphore
      net/smc: fix potential panic dues to unprotected smc_llc_srv_add_link()
      net/smc: fix application data exception

Dai Shixin (1):
      qed: fix a typo in comment

Dan Carpenter (6):
      devlink: remove some unnecessary code
      net: dsa: microchip: ptp: Fix error code in ksz_hwtstamp_set()
      net: microchip: sparx5: Fix uninitialized variable in vcap_path_exist()
      net: libwx: fix an error code in wx_alloc_page_pool()
      wifi: mwifiex: fix loop iterator in mwifiex_update_ampdu_txwinsize()
      net: phy: motorcomm: uninitialized variables in yt8531_link_change_notify()

Daniel Borkmann (6):
      selftests/bpf: Add jit probe_mem corner case tests to s390x denylist
      Merge branch 'libbpf-extend-arguments-tracing'
      Merge branch 'xdp-ice-mbuf'
      Merge branch 'kfunc-annotation'
      docs, bpf: Ensure IETF's BPF mailing list gets copied for ISA doc changes
      Merge branch 'xdp-ice-mbuf'

Daniel Machon (16):
      net: dcb: modify dcb_app_add to take list_head ptr as parameter
      net: dcb: add new common function for set/del of app/rewr entries
      net: dcb: add new rewrite table
      net: dcb: add helper functions to retrieve PCP and DSCP rewrite maps
      net: microchip: sparx5: add support for PCP rewrite
      net: microchip: sparx5: add support for DSCP rewrite
      net: microchip: add registers needed for PSFP
      net: microchip: sparx5: add resource pools
      net: microchip: sparx5: add support for Service Dual Leacky Buckets
      net: microchip: sparx5: add support for service policers
      net: microchip: sparx5: add support for PSFP flow-meters
      net: microchip: sparx5: add function for calculating PTP basetime
      net: microchip: sparx5: add support for PSFP stream gates
      net: microchip: sparx5: add support for PSFP stream filters
      net: microchip: sparx5: initialize PSFP
      sparx5: add support for configuring PSFP via tc

Daniel T. Lee (20):
      samples/bpf: remove unused function with test_lru_dist
      samples/bpf: replace meaningless counter with tracex4
      samples/bpf: fix uninitialized warning with test_current_task_under_cgroup
      samples/bpf: Use kyscall instead of kprobe in syscall tracing program
      samples/bpf: Use vmlinux.h instead of implicit headers in syscall tracing program
      samples/bpf: Change _kern suffix to .bpf with syscall tracing program
      samples/bpf: Fix tracex2 by using BPF_KSYSCALL macro
      samples/bpf: Use BPF_KSYSCALL macro in syscall tracing programs
      libbpf: Fix invalid return address register in s390
      samples/bpf: ensure ipv6 is enabled before running tests
      samples/bpf: refactor BPF functionality testing scripts
      samples/bpf: fix broken lightweight tunnel testing
      samples/bpf: fix broken cgroup socket testing
      samples/bpf: replace broken overhead microbenchmark with fib_table_lookup
      samples/bpf: replace legacy map with the BTF-defined map
      samples/bpf: split common macros to net_shared.h
      samples/bpf: replace BPF programs header with net_shared.h
      samples/bpf: use vmlinux.h instead of implicit headers in BPF test program
      samples/bpf: change _kern suffix to .bpf with BPF test programs
      selftests/bpf: Fix vmtest static compilation error

Daniel Vacek (1):
      ice/ptp: fix the PTP worker retrying indefinitely if the link went down

Daniele Palmas (3):
      ethtool: add tx aggregation parameters
      net: qualcomm: rmnet: add tx packets aggregation
      net: qualcomm: rmnet: add ethtool support for configuring tx aggregation

Danielle Ratson (1):
      mlxsw: spectrum: Remove pointless call to devlink_param_driverinit_value_set()

Dave Marchevsky (12):
      bpf, x86: Improve PROBE_MEM runtime load check
      selftests/bpf: Add verifier test exercising jit PROBE_MEM logic
      bpf: rename list_head -> graph_root in field info types
      bpf: Migrate release_on_unlock logic to non-owning ref semantics
      bpf: Add basic bpf_rb_{root,node} support
      bpf: Add bpf_rbtree_{add,remove,first} kfuncs
      bpf: Add support for bpf_rb_root and bpf_rb_node in kfunc args
      bpf: Add callback validation to kfunc verifier logic
      bpf: Special verifier handling for bpf_rbtree_{remove, first}
      bpf: Add bpf_rbtree_{add,remove,first} decls to bpf_experimental.h
      selftests/bpf: Add rbtree selftests
      bpf, documentation: Add graph documentation for non-owning refs

Dave Thaler (3):
      bpf, docs: Fix modulo zero, division by zero, overflow, and underflow
      bpf, docs: Use consistent names for the same field
      bpf, docs: Add note about type convention

David Howells (18):
      rxrpc: Fix trace string
      rxrpc: Remove whitespace before ')' in trace header
      rxrpc: Shrink the tabulation in the rxrpc trace header a bit
      rxrpc: Convert call->recvmsg_lock to a spinlock
      rxrpc: Allow a delay to be injected into packet reception
      rxrpc: Generate extra pings for RTT during heavy-receive call
      rxrpc: De-atomic call->ackr_window and call->ackr_nr_unacked
      rxrpc: Simplify ACK handling
      rxrpc: Don't lock call->tx_lock to access call->tx_buffer
      rxrpc: Remove local->defrag_sem
      rxrpc: Show consumed and freed packets as non-dropped in dropwatch
      rxrpc: Change rx_packet tracepoint to display securityIndex not type twice
      rxrpc: Kill service bundle
      rxrpc: Use consume_skb() rather than kfree_skb_reason()
      rxrpc: Fix overwaking on call poking
      rxrpc: Trace ack.rwind
      rxrpc: Reduce unnecessary ack transmission
      rxrpc: Fix overproduction of wakeups to recvmsg()

David S. Miller (58):
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'devlink-unregister'
      Merge branch 'phy-micrel-warnings'
      Merge branch 'mptcp-next'
      Merge branch 'r8152-NCM-firmwares'
      Merge branch 'NCN26000-PLCA-RS-support'
      Merge tag 'mlx5-updates-2023-01-10' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'dsa-microchip-ptp'
      Merge branch 'rmnet-tx-pkt-aggregation'
      Merge branch 'virtio-net-xdp-multi-buffer'
      Merge branch '10GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'net-microchip-vcap-rules'
      Merge branch 'dt-bindings-ocelot-switches'
      Merge branch 'stmmac-imx93'
      Merge branch 'am65-cpts-PPS'
      Merge branch 'tsnep-xdp-support'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next
      Merge branch 'sparx5-vcap-improve-locking'
      Merge branch 'lan9303-phylink'
      Merge branch 'net-dcb-rewrite-table'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'ethtool-mac-merge'
      Merge branch 'enetc-mac-merge-prep'
      ethtool: Add and use ethnl_update_bool.
      Merge branch 's390-ism-generalized-interface'
      Merge branch 'ipa-abstract-status'
      Merge branch 'net-skbuff-includes'
      Merge branch 'ethtool-netlink-next'
      Merge branch 'devlink-parama-cleanup'
      Merge tag 'batadv-next-pullrequest-20230127' of git://git.open-mesh.org/linux-merge
      Merge branch 'sparx5-ES2-VCAP-support'
      Merge branch 'devlink-next'
      Merge branch 'rswitch-SERDES-PHY-init'
      Merge branch 'act_ct-UDP-NEW'
      Merge branch 'yt8531-support'
      Merge branch 'net-smc-parallelism'
      Merge branch 'sparx5-PSFP-support'
      Merge branch 'bridge-mdb-limit'
      Merge tag 'mlx5-updates-2023-02-04' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'wangxun-interrupts'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'ENETC-mqprio-taprio-cleanup'
      Merge branch 'tuntap-socket-uid'
      Merge branch 'micrel-lan8841-support'
      Merge branch 'taprio-auto-qmaxsdu-new-tx'
      Merge tag 'rxrpc-next-20230208' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs
      Merge branch 'net-ipa-GSI'
      Merge branch 'devlink-params-cleanup'
      Merge branch 'net-ipa-GSI-regs'
      Merge branch 'ionic-on-chip-desc'
      Merge branch 'ksz9477-eee-support'
      Merge ra.kernel.org:/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'icmp6-drop-reason'
      Merge branch 'phydev-locks'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next
      Merge tag 'wireless-next-2023-02-17' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
      Merge branch 'default_rps_mask-follow-up'
      Merge tag 'linux-can-next-for-6.3-20230217' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next Marc Kleine-Budde says:

David Thompson (4):
      mlxbf_gige: add MDIO support for BlueField-3
      mlxbf_gige: support 10M/100M/1G speeds on BlueField-3
      mlxbf_gige: add "set_link_ksettings" ethtool callback
      mlxbf_gige: fix white space in mlxbf_gige_eth_ioctl

David Vernet (21):
      selftests/bpf: Use __failure macro in task kfunc testsuite
      bpf: Enable annotating trusted nested pointers
      bpf: Allow trusted args to walk struct when checking BTF IDs
      bpf: Disallow NULLable pointers for trusted kfuncs
      bpf: Enable cpumasks to be queried and used as kptrs
      selftests/bpf: Add nested trust selftests suite
      selftests/bpf: Add selftest suite for cpumask kfuncs
      bpf/docs: Document cpumask kfuncs in a new file
      bpf/docs: Document how nested trusted fields may be defined
      bpf/docs: Document the nocast aliasing behavior of ___init
      bpf: Allow BPF_PROG_TYPE_STRUCT_OPS programs to be sleepable
      libbpf: Support sleepable struct_ops.s section
      bpf: Pass const struct bpf_prog * to .check_member
      bpf/selftests: Verify struct_ops prog sleepable behavior
      bpf: Build-time assert that cpumask offset is zero
      bpf: Add __bpf_kfunc tag for marking kernel functions as kfuncs
      bpf: Document usage of the new __bpf_kfunc macro
      bpf: Add __bpf_kfunc tag to all kfuncs
      selftests/bpf: Add testcase for static kfunc with unused arg
      bpf/docs: Document kfunc lifecycle / stability expectations
      bpf, docs: Add myself to BPF docs MAINTAINERS entry

Davide Caratti (3):
      net/sched: act_mirred: better wording on protection against excessive stack growth
      act_mirred: use the backlog for nested calls to mirred ingress
      selftests: forwarding: tc_actions: cleanup temporary files when test is aborted

Deren Wu (9):
      wifi: mt76: mt7921s: fix slab-out-of-bounds access in sdio host
      wifi: mt76: fix coverity uninit_use_in_call in mt76_connac2_reverse_frag0_hdr_trans()
      wifi: mt76: mt7921: fix channel switch fail in monitor mode
      wifi: mt76: mt7921: add ack signal support
      wifi: mt76: mt7921: fix invalid remain_on_channel duration
      wifi: mt76: add flexible polling wait-interval support
      wifi: mt76: mt7921: reduce polling time in pmctrl
      wifi: mt76: add memory barrier to SDIO queue kick
      wifi: mt76: support ww power config in dts node

Dinesh Karthikeyan (3):
      wifi: ath12k: Fix incorrect qmi_file_type enum values
      wifi: ath12k: Add new qmi_bdf_type to handle caldata
      wifi: ath12k: Add support to read EEPROM caldata

Divya Koppera (2):
      net: phy: micrel: Fixed error related to uninitialized symbol ret
      net: phy: micrel: Fix warn: passing zero to PTR_ERR

Dmitry Torokhov (4):
      ieee802154: at86rf230: drop support for platform data
      ieee802154: at86rf230: switch to using gpiod API
      net: fec: restore handling of PHY reset line as optional
      net: fec: do not double-parse 'phy-reset-active-high' property

Doug Berger (1):
      net: bcmgenet: fix MoCA LED control

Doug Brown (4):
      wifi: libertas: fix code style in Marvell structs
      wifi: libertas: only add RSN/WPA IE in lbs_add_wpa_tlv
      wifi: libertas: add new TLV type for WPS enrollee IE
      wifi: libertas: add support for WPS enrollee IE in probe requests

Dragos Tatulea (1):
      net/mlx5e: IPoIB, Add support for XDR speed

Eddy Tao (1):
      net: openvswitch: reduce cpu_used_mask memory

Eduard Zingerman (6):
      selftests/bpf: convenience macro for use with 'asm volatile' blocks
      docs/bpf: Add description of register liveness tracking algorithm
      bpf: track immediate values written to stack by BPF_ST instruction
      selftests/bpf: check if verifier tracks constants spilled by BPF_ST_MEM
      bpf: BPF_ST with variable offset should preserve STACK_ZERO marks
      selftests/bpf: check if BPF_ST with variable offset preserves STACK_ZERO

Emeel Hakim (2):
      macsec: add support for IFLA_MACSEC_OFFLOAD in macsec_changelink
      macsec: dump IFLA_MACSEC_OFFLOAD attribute as part of macsec dump

Emmanuel Grumbach (1):
      wifi: iwlwifi: mention the response structure in the kerneldoc

Eric Dumazet (25):
      selftests: net: tcp_mmap: populate pages in send path
      tcp: add TCP_MINTTL drop reason
      ipv6: raw: add drop reasons
      ipv4: raw: add drop reasons
      raw: use net_hash_mix() in hash function
      net: add SKB_HEAD_ALIGN() helper
      net: remove osize variable in __alloc_skb()
      net: factorize code in kmalloc_reserve()
      net: add dedicated kmem_cache for typical/small skb->head
      net: enable usercopy for skb_small_head_cache
      net/sched: fix error recovery in qdisc_create()
      net: dropreason: add SKB_DROP_REASON_IPV6_BAD_EXTHDR
      net: add pskb_may_pull_reason() helper
      ipv6: icmp6: add drop reason support to icmpv6_notify()
      ipv6: icmp6: add drop reason support to ndisc_rcv()
      net: add location to trace_consume_skb()
      ipv6: icmp6: add drop reason support to ndisc_recv_ns()
      ipv6: icmp6: add drop reason support to ndisc_recv_na()
      ipv6: icmp6: add drop reason support to ndisc_recv_rs()
      ipv6: icmp6: add drop reason support to ndisc_router_discovery()
      ipv6: icmp6: add drop reason support to ndisc_redirect_rcv()
      ipv6: icmp6: add SKB_DROP_REASON_IPV6_NDISC_BAD_OPTIONS
      ipv6: icmp6: add SKB_DROP_REASON_IPV6_NDISC_NS_OTHERHOST
      ipv6: icmp6: add drop reason support to icmpv6_echo_reply()
      scm: add user copy checks to put_cmsg()

Eric Huang (2):
      wifi: rtw89: 8852b: update BSS color mapping register
      wifi: rtw89: correct register definitions of digital CFO and spur elimination

Fedor Pchelkin (2):
      wifi: ath9k: htc_hst: free skb in ath9k_htc_rx_msg() if there is no callback function
      wifi: ath9k: hif_usb: clean up skbs if ath9k_hif_usb_rx_stream() fails

Felix Fietkau (6):
      wifi: mt76: mt7921: fix deadlock in mt7921_abort_roc
      wifi: cfg80211: move A-MSDU check in ieee80211_data_to_8023_exthdr
      wifi: cfg80211: factor out bridge tunnel / RFC1042 header check
      wifi: mac80211: remove mesh forwarding congestion check
      wifi: mac80211: fix receiving A-MSDU frames on mesh interfaces
      wifi: mac80211: add a workaround for receiving non-standard mesh A-MSDU

Fernando Fernandez Mancera (1):
      netfilter: nf_tables: add support to destroy operation

Florian Fainelli (2):
      net: bcmgenet: Add a check for oversized packets
      net: bcmgenet: Support wake-up from s2idle

Florian Lehner (1):
      bpf: fix typo in header for bpf_perf_prog_read_value

Florian Westphal (10):
      netfilter: conntrack: sctp: use nf log infrastructure for invalid packets
      netfilter: conntrack: remove pr_debug calls
      netfilter: conntrack: avoid reload of ct->status
      netfilter: conntrack: move rcu read lock to nf_conntrack_find_get
      netfilter: ip_tables: remove clusterip target
      netfilter: nf_tables: add static key to skip retpoline workarounds
      netfilter: nf_tables: avoid retpoline overhead for objref calls
      netfilter: nf_tables: avoid retpoline overhead for some ct expression calls
      netfilter: conntrack: udp: fix seen-reply test
      netfilter: let reset rules clean out conntrack entries

Frank Jungclaus (3):
      can: esd_usb: Move mislocated storage of SJA1000_ECC_SEG bits in case of a bus error
      can: esd_usb: Make use of can_change_state() and relocate checking skb for NULL
      can: esd_usb: Improve readability on decoding ESD_EV_CAN_ERROR_EXT messages

Frank Sae (7):
      net: phy: fix the spelling problem of Sentinel
      net: phy: motorcomm: change the phy id of yt8521 and yt8531s to lowercase
      dt-bindings: net: Add Motorcomm yt8xxx ethernet phy
      net: phy: Add BIT macro for Motorcomm yt8521/yt8531 gigabit ethernet phy
      net: phy: Add dts support for Motorcomm yt8521 gigabit ethernet phy
      net: phy: Add dts support for Motorcomm yt8531s gigabit ethernet phy
      net: phy: Add driver for Motorcomm yt8531 gigabit ethernet phy

Gal Pressman (7):
      net/mlx5e: Add Ethernet driver debugfs
      net/mlx5e: Add hairpin params structure
      net/mlx5e: Add flow steering debugfs directory
      net/mlx5e: Add hairpin debugfs files
      net/mlx5e: Remove incorrect debugfs_create_dir NULL check in hairpin
      net/mlx5e: Remove incorrect debugfs_create_dir NULL check in TLS
      net/mlx5e: RX, Remove doubtful unlikely call

Gavrilov Ilia (1):
      netfilter: conntrack: remote a return value of the 'seq_print_acct' function.

Geert Uytterhoeven (11):
      dt-bindings: can: renesas,rcar-canfd: R-Car V3U is R-Car Gen4
      dt-bindings: can: renesas,rcar-canfd: Document R-Car V4H support
      dt-bindings: can: renesas,rcar-canfd: Add transceiver support
      can: rcar_canfd: Fix R-Car V3U CAN mode selection
      can: rcar_canfd: Fix R-Car V3U GAFLCFG field accesses
      can: rcar_canfd: Abstract out DCFG address differences
      can: rcar_canfd: Add support for R-Car Gen4
      can: rcar_canfd: Fix R-Car Gen4 DCFG.DSJW field width
      can: rcar_canfd: Fix R-Car Gen4 CFCC.CFTML field width
      can: rcar_canfd: Sort included header files
      can: rcar_canfd: Add helper variable dev

Geetha sowjanya (1):
      octeontx2-af: Add NIX Errata workaround on CN10K silicon

Geliang Tang (3):
      mptcp: use msk_owned_by_me helper
      mptcp: use net instead of sock_net
      mptcp: use local variable ssk in write_options

Gerhard Engleder (9):
      tsnep: Replace TX spin_lock with __netif_tx_lock
      tsnep: Forward NAPI budget to napi_consume_skb()
      tsnep: Do not print DMA mapping error
      tsnep: Add XDP TX support
      tsnep: Subtract TSNEP_RX_INLINE_METADATA_SIZE once
      tsnep: Prepare RX buffer for XDP support
      tsnep: Add RX queue info for XDP support
      tsnep: Add XDP RX support
      tsnep: Support XDP BPF program setup

Gerhard Uttenthaler (8):
      can: ems_pci: Fix code style, copyright and email address
      can: ems_pci: Add Asix AX99100 definitions
      can: ems_pci: Initialize BAR registers
      can: ems_pci: Add read/write register and post irq functions
      can: ems_pci: Initialize CAN controller base addresses
      can: ems_pci: Add IRQ enable
      can: ems_pci: Deassert hardware reset
      can: ems_pci: Add myself as module author

Gilad Itzkovitch (1):
      wifi: mac80211: Fix for Rx fragmented action frames

Golan Ben Ami (1):
      wifi: iwlwifi: bump FW API to 74 for AX devices

Govindaraj Saminathan (1):
      wifi: ath11k: Fix race condition with struct htt_ppdu_stats_info

Grant Seltzer (2):
      libbpf: Fix malformed documentation formatting
      libbpf: Add documentation to map pinning API functions

Gregory Greenman (2):
      wifi: iwlwifi: mvm: always send nullfunc frames on MGMT queue
      wifi: iwlwifi: mei: fix compilation errors in rfkill()

Grygorii Strashko (3):
      dt-binding: net: ti: am65x-cpts: add 'ti,pps' property
      net: ethernet: ti: am65-cpts: add pps support
      net: ethernet: ti: am65-cpts: adjust pps following ptp changes

Guillaume Nault (1):
      ipv6: Make ip6_route_output_flags_noref() static.

Gustavo A. R. Silva (5):
      net/mlx5e: Replace zero-length array with flexible-array member
      Bluetooth: HCI: Replace zero-length arrays with flexible-array members
      wifi: brcmfmac: Replace one-element array with flexible-array member
      wifi: mwifiex: Replace one-element arrays with flexible-array members
      wifi: mwifiex: Replace one-element array with flexible-array member

Haiyue Wang (1):
      bpf: Remove the unnecessary insn buffer comparison

Hangbin Liu (2):
      sched: add new attr TCA_EXT_WARN_MSG to report tc extact message
      selftests/net: mv bpf/nat6to4.c to net folder

Hans J. Schultz (3):
      net: dsa: mv88e6xxx: change default return of mv88e6xxx_port_bridge_flags
      net: dsa: mv88e6xxx: shorten the locked section in mv88e6xxx_g1_atu_prob_irq_thread_fn()
      net: dsa: mv88e6xxx: mac-auth/MAB implementation

Hao Xiang (1):
      libbpf: Correctly set the kernel code version in Debian kernel.

Hayes Wang (3):
      r8152: avoid to change cfg for all devices
      r8152: remove rtl_vendor_mode function
      r8152: reduce the control transfer of rtl8152_get_version()

Hector Martin (4):
      wifi: brcmfmac: Rename Cypress 89459 to BCM4355
      wifi: brcmfmac: pcie: Add IDs/properties for BCM4355
      wifi: brcmfmac: pcie: Add IDs/properties for BCM4377
      wifi: brcmfmac: pcie: Perform correct BCM4364 firmware selection

Heiner Kallweit (6):
      r8169: disable ASPM in case of tx timeout
      r8169: reset bus if NIC isn't accessible after tx timeout
      net: mdio: mux-meson-g12a: use devm_clk_get_enabled to simplify the code
      net: mdio: warn once if addr parameter is invalid in mdiobus_get_phy()
      net: mdio: mux-meson-g12a: use __clk_is_enabled to simplify the code
      wifi: iwlwifi: improve tag handling in iwl_request_firmware

Heng Qi (11):
      virtio-net: disable the hole mechanism for xdp
      virtio-net: fix calculation of MTU for single-buffer xdp
      virtio-net: set up xdp for multi buffer packets
      virtio-net: update bytes calculation for xdp_frame
      virtio-net: build xdp_buff with multi buffers
      virtio-net: construct multi-buffer xdp in mergeable
      virtio-net: transmit the multi-buffer xdp
      virtio-net: build skb from multi-buffer xdp
      virtio-net: remove xdp related info from page_to_skb()
      virtio-net: support multi-buffer xdp
      virtio-net: fix possible unsigned integer overflow

Hengqi Chen (2):
      libbpf: Add LoongArch support to bpf_tracing.h
      LoongArch, bpf: Use 4 instructions for function address in JIT

Holger Hoffstätte (1):
      bpftool: Always disable stack protection for BPF objects

Hongguang Gao (1):
      bnxt_en: Remove struct bnxt access from RoCE driver

Horatiu Vultur (10):
      net: phy: micrel: Change handler interrupt for lan8814
      net: lan966x: Add VCAP debugFS support
      net: lan966x: Add support for TC flower filter statistics
      net: micrel: Add support for lan8841 PHY
      dt-bindings: net: micrel-ksz90x1.txt: Update for lan8841
      net: micrel: Cable Diagnostics feature for lan8841 PHY
      net: microchip: vcap: Add tc flower keys for lan966x
      net: micrel: Add PHC support for lan8841
      net: lan966x: Use automatic selection of VCAP rule actionset
      net: lan966x: Fix possible deadlock inside PTP

Hou Tao (2):
      bpf: Zeroing allocated object from slab in bpf memory allocator
      selftests/bpf: Add test case for element reuse in htab map

Howard Hsu (4):
      wifi: mt76: mt7915: call mt7915_mcu_set_thermal_throttling() only after init_work
      wifi: mt76: mt7915: rework mt7915_mcu_set_thermal_throttling
      wifi: mt76: mt7915: rework mt7915_thermal_temp_store()
      wifi: mt76: mt7915: add error message in mt7915_thermal_set_cur_throttle_state()

Huanhuan Wang (1):
      nfp: support IPsec offloading for NFP3800

Huayu Chen (1):
      nfp: correct cleanup related to DCB resources

Ian Rogers (3):
      tools/resolve_btfids: Install subcmd headers
      tools/resolve_btfids: Alter how HOSTCC is forced
      tools/resolve_btfids: Tidy HOST_OVERRIDES

Ido Schimmel (9):
      mlxsw: spectrum_acl_tcam: Add missing mutex_destroy()
      mlxsw: spectrum_acl_tcam: Make fini symmetric to init
      mlxsw: spectrum_acl_tcam: Reorder functions to avoid forward declarations
      mlxsw: spectrum_acl_tcam: Move devlink param to TCAM code
      mlxsw: core: Register devlink instance before sub-objects
      bridge: mcast: Use correct define in MDB dump
      bridge: mcast: Remove pointless sequence generation counter assignment
      bridge: mcast: Move validation to a policy
      selftests: forwarding: Add MDB dump test cases

Ilias Apalodimas (1):
      page_pool: add a comment explaining the fragment counter usage

Ilya Leoshkevich (47):
      bpf: Use ARG_CONST_SIZE_OR_ZERO for 3rd argument of bpf_tcp_raw_gen_syncookie_ipv{4,6}()
      bpf: Change BPF_MAX_TRAMP_LINKS to enum
      selftests/bpf: Query BPF_MAX_TRAMP_LINKS using BTF
      selftests/bpf: Fix liburandom_read.so linker error
      selftests/bpf: Fix symlink creation error
      selftests/bpf: Fix kfree_skb on s390x
      selftests/bpf: Set errno when urand_spawn() fails
      selftests/bpf: Fix decap_sanity_ns cleanup
      selftests/bpf: Fix verify_pkcs7_sig on s390x
      selftests/bpf: Fix xdp_do_redirect on s390x
      selftests/bpf: Fix cgrp_local_storage on s390x
      selftests/bpf: Check stack_mprotect() return value
      selftests/bpf: Increase SIZEOF_BPF_LOCAL_STORAGE_ELEM on s390x
      selftests/bpf: Add a sign-extension test for kfuncs
      selftests/bpf: Fix test_lsm on s390x
      selftests/bpf: Fix test_xdp_adjust_tail_grow2 on s390x
      selftests/bpf: Fix vmlinux test on s390x
      selftests/bpf: Fix xdp_synproxy/tc on s390x
      selftests/bpf: Fix profiler on s390x
      libbpf: Simplify barrier_var()
      libbpf: Fix unbounded memory access in bpf_usdt_arg()
      libbpf: Fix BPF_PROBE_READ{_STR}_INTO() on s390x
      bpf: iterators: Split iterators.lskel.h into little- and big- endian versions
      bpf: btf: Add BTF_FMODEL_SIGNED_ARG flag
      s390/bpf: Fix a typo in a comment
      selftests/bpf: Fix sk_assign on s390x
      s390/bpf: Add expoline to tail calls
      s390/bpf: Implement bpf_arch_text_poke()
      s390/bpf: Implement arch_prepare_bpf_trampoline()
      s390/bpf: Implement bpf_jit_supports_subprog_tailcalls()
      s390/bpf: Implement bpf_jit_supports_kfunc_call()
      selftests/bpf: Fix s390x vmlinux path
      selftests/bpf: Trim DENYLIST.s390x
      selftests/bpf: Initialize tc in xdp_synproxy
      selftests/bpf: Quote host tools
      tools: runqslower: Add EXTRA_CFLAGS and EXTRA_LDFLAGS support
      selftests/bpf: Split SAN_CFLAGS and SAN_LDFLAGS
      selftests/bpf: Forward SAN_CFLAGS and SAN_LDFLAGS to runqslower and libbpf
      selftests/bpf: Attach to fopen()/fclose() in uprobe_autoattach
      selftests/bpf: Attach to fopen()/fclose() in attach_probe
      libbpf: Fix alen calculation in libbpf_nla_dump_errormsg()
      selftests/bpf: Fix out-of-srctree build
      libbpf: Introduce bpf_{btf,link,map,prog}_get_info_by_fd()
      libbpf: Use bpf_{btf,link,map,prog}_get_info_by_fd()
      bpftool: Use bpf_{btf,link,map,prog}_get_info_by_fd()
      samples/bpf: Use bpf_{btf,link,map,prog}_get_info_by_fd()
      selftests/bpf: Use bpf_{btf,link,map,prog}_get_info_by_fd()

Ivan Bornyakov (1):
      net: phylink: support validated pause and autoneg in fixed-link

Jack Morgenstein (1):
      net/mlx5: Enhance debug print in page allocation failure

Jacob Keller (14):
      ice: stop hard coding the ICE_VSI_CTRL location
      ice: fix function comment referring to ice_vsi_alloc
      ice: drop unnecessary VF parameter from several VSI functions
      ice: refactor VSI setup to use parameter structure
      ice: move vsi_type assignment from ice_vsi_alloc to ice_vsi_cfg
      ice: move ice_vf_vsi_release into ice_vf_lib.c
      ice: Pull common tasks into ice_vf_post_vsi_rebuild
      ice: add a function to initialize vf entry
      ice: introduce ice_vf_init_host_cfg function
      ice: convert vf_ops .vsi_rebuild to .create_vsi
      ice: introduce clear_reset_state operation
      ice: introduce .irq_close VF operation
      ice: remove unnecessary virtchnl_ether_addr struct use
      devlink: stop using NL_SET_ERR_MSG_MOD

Jaewan Kim (2):
      wifi: mac80211_hwsim: Rename pid to portid to avoid confusion
      wifi: nl80211: return error message for malformed chandef

Jakub Kicinski (148):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'enetc-unlock-xdp_redirect-for-xdp-non-linear-buffers'
      Merge branch 'net-ipa-simplify-ipa-interrupt-handling'
      devlink: move code to a dedicated directory
      devlink: rename devlink_netdevice_event -> devlink_port_netdevice_event
      devlink: split out core code
      devlink: split out netlink code
      netlink: add macro for checking dump ctx size
      devlink: use an explicit structure for dump context
      devlink: remove start variables from dumps
      devlink: drop the filter argument from devlinks_xa_find_get
      devlink: health: combine loops in dump
      devlink: restart dump based on devlink instance ids (simple)
      devlink: restart dump based on devlink instance ids (nested)
      devlink: restart dump based on devlink instance ids (function)
      devlink: uniformly take the devlink instance lock in the dump loop
      devlink: add by-instance dump infra
      devlink: convert remaining dumps to the by-instance scheme
      Merge branch 'devlink-code-split-and-structured-instance-walk'
      devlink: bump the instance index directly when iterating
      devlink: update the code in netns move to latest helpers
      devlink: protect devlink->dev by the instance lock
      devlink: always check if the devlink instance is registered
      devlink: remove the registration guarantee of references
      devlink: don't require setting features before registration
      devlink: allow registering parameters after the instance
      netdevsim: rename a label
      netdevsim: move devlink registration under the instance lock
      Merge branch 'net-wangxun-adjust-code-structure'
      net: skb: remove old comments about frag_size for build_skb()
      Merge branch 'net-mdio-start-separating-c22-and-c45'
      Merge branch 'dt-bindings-first-batch-of-dt-schema-conversions-for-amlogic-meson-bindings'
      devlink: keep the instance mutex alive until references are gone
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'net-thunderbolt-add-tracepoints'
      Merge branch 'add-support-to-offload-macsec-using-netlink-update'
      Merge branch 'net-mdio-continue-separating-c22-and-c45'
      Merge branch 'mlxbf_gige-add-bluefield-3-support'
      Merge tag 'regmap-mdio-c45-rework' of https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap
      Merge tag 'i2c-fwnode-api-2023017' of https://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
      Merge branch 'net-mdio-continue-separating-c22-and-c45'
      Merge branch 'enetc-bd-ring-cleanup'
      Merge branch 'net-sfp-cleanup-i2c-dt-acpi-fwnode-includes'
      Merge branch 'devlink-linecard-and-reporters-locking-cleanup'
      Merge tag 'mlx5-updates-2023-01-18' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'octeontx2-af-miscellaneous-changes-for-cpt'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'r8152-improve-the-code'
      Merge branch 'net-mdio-remove-support-for-building-c45-muxed-addresses'
      Merge branch 'mlxsw-add-support-of-latency-tlv'
      Merge tag 'wireless-next-2023-01-23' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
      Merge branch 'net-dsa-microchip-add-support-for-credit-based-shaper'
      docs: add more netlink docs (incl. spec docs)
      netlink: add schemas for YAML specs
      net: add basic C code generators for Netlink
      netlink: add a proto specification for FOU
      net: fou: regenerate the uAPI from the spec
      net: fou: rename the source for linking
      net: fou: use policy and operation tables generated from the spec
      tools: ynl: add a completely generic client
      netlink: fix spelling mistake in dump size assert
      devlink: remove a dubious assumption in fmsg dumping
      Merge branch 'add-ip_local_port_range-socket-option'
      Merge branch 'convert-drivers-to-return-xfrm-configuration-errors-through-extack'
      tools: ynl: support kdocs for flags in code generation
      tools: ynl: rename ops_list -> msg_list
      tools: ynl: store ops in ordered dict to avoid random ordering
      Merge branch 'tools-ynl-prevent-reorder-and-fix-flags'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      net: add missing includes of linux/net.h
      net: skbuff: drop the linux/net.h include
      net: checksum: drop the linux/uaccess.h include
      net: skbuff: drop the linux/textsearch.h include
      net: add missing includes of linux/sched/clock.h
      net: skbuff: drop the linux/sched/clock.h include
      net: skbuff: drop the linux/sched.h include
      net: add missing includes of linux/splice.h
      net: skbuff: drop the linux/splice.h include
      net: skbuff: drop the linux/hrtimer.h include
      net: remove unnecessary includes from net/flow.h
      ethtool: netlink: handle SET intro/outro in the common code
      ethtool: netlink: convert commands to common SET
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      sh: checksum: add missing linux/uaccess.h include
      Merge branch 'add-support-for-the-the-vsc7512-internal-copper-phys'
      tools: ynl-gen: prevent do / dump reordering
      tools: ynl: move the cli and netlink code around
      tools: ynl: add an object hierarchy to represent parsed spec
      tools: ynl: use the common YAML loading and validation code
      tools: ynl: add support for types needed by ethtool
      tools: ynl: support directional enum-model in CLI
      tools: ynl: support multi-attr
      tools: ynl: support pretty printing bad attribute names
      tools: ynl: use operation names from spec on the CLI
      tools: ynl: load jsonschema on demand
      netlink: specs: finish up operation enum-models
      netlink: specs: add partial specification for ethtool
      docs: netlink: add a starting guide for working with specs
      tools: net: use python3 explicitly
      Merge branch 'tools-ynl-more-docs-and-basic-ethtool-support'
      Merge branch 'net-mdio-add-amlogic-gxl-mdio-mux-support'
      Merge branch 'selftests-mlxsw-convert-to-iproute2-dcb'
      Merge branch '10GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge tag 'mlx5-updates-2023-01-30' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'net-ipa-remaining-ipa-v5-0-support'
      Merge branch 'devlink-trivial-names-cleanup'
      Merge branch 'virtio_net-vdpa-update-mac-address-when-it-is-generated-by-virtio-net'
      Merge branch 'net-support-ipv4-big-tcp'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      netdev-genl: create a simple family for netdev stuff
      Merge branch 'devlink-move-devlink-dev-code-to-a-separate-file'
      Merge branch 'raw-add-drop-reasons-and-use-another-hash-function'
      Merge branch 'updates-to-enetc-txq-management'
      Merge branch 'aux-bus-v11' of https://github.com/ajitkhaparde1/linux
      Merge branch 'net-core-use-a-dedicated-kmem_cache-for-skb-head-allocs'
      Merge branch 'sched-cpumask-improve-on-cpumask_local_spread-locality'
      Merge branch 'mlxsw-misc-devlink-changes'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge tag 'mlx5-updates-2023-02-07' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge tag 'mlx5-next-netdev-deadlock' of git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux
      Merge tag 'linux-can-next-for-6.3-20230208' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'net-introduce-rps_default_mask'
      net: skbuff: drop the word head from skb cache
      Merge branch 'net-move-more-duplicate-code-of-ovs-and-tc-conntrack-into-nf_conntrack_ovs'
      Daniel Borkmann says:
      Merge tag 'for-net-next-2023-02-09' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next
      Merge branch 'bridge-mcast-preparations-for-vxlan-mdb'
      Merge branch 'net-renesas-rswitch-improve-tx-timestamp-accuracy'
      Merge branch 's390-net-updates-2023-02-06'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'ipv6-more-drop-reason'
      Merge branch 'net-ipa-define-gsi-register-fields-differently'
      Merge branch 'net-make-kobj_type-structures-constant'
      netlink-specs: add rx-push to ethtool family
      Merge branch 'devlink-cleanups-and-move-devlink-health-functionality-to-separate-file'
      Merge tag 'mlx5-updates-2023-02-10' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge tag 'wireless-next-2023-03-16' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
      Merge branch 'mlx5-next' of https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux
      Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge tag 'ieee802154-for-net-next-2023-02-20' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan-next
      Merge branch 'net-sched-cls_api-support-hardware-miss-to-tc-action'
      Merge tag 'mlx5-updates-2023-02-15' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net

Jakub Sitnicki (3):
      inet: Add IP_LOCAL_PORT_RANGE socket option
      selftests/net: Cover the IP_LOCAL_PORT_RANGE socket option
      selftests/net: Interpret UDP_GRO cmsg data as an int value

Jamal Hadi Salim (5):
      net/sched: Retire CBQ qdisc
      net/sched: Retire ATM qdisc
      net/sched: Retire dsmark qdisc
      net/sched: Retire tcindex classifier
      net/sched: Retire rsvp classifier

James Hershaw (2):
      nfp: flower: change get/set_eeprom logic and enable for flower reps
      nfp: flower: add check for flower VF netdevs for get/set_eeprom

James Hilliard (1):
      bpftool: Add missing quotes to libbpf bootstrap submake vars

Jamie Bainbridge (1):
      icmp: Add counters for rate limits

Jamie Gloudon (1):
      e1000e: Enable Link Partner Advertised Support

Jan Sokolowski (4):
      i40e: Remove unused i40e status codes
      i40e: Remove string printing for i40e_status
      i40e: use int for i40e_status
      i40e: use ERR_PTR error print in i40e messages

Jason Xing (1):
      net: no longer support SOCK_REFCNT_DEBUG feature

Jerome Brunet (2):
      dt-bindings: net: add amlogic gxl mdio multiplexer
      net: mdio: add amlogic gxl mdio mux support

Jerry Ray (7):
      dsa: lan9303: align dsa_switch_ops members
      dsa: lan9303: move Turbo Mode bit init
      dsa: lan9303: Add exception logic for read failure
      dsa: lan9303: write reg only if necessary
      dsa: lan9303: Port 0 is xMII port
      dsa: lan9303: Migrate to PHYLINK
      dsa: lan9303: Add flow ctrl in link_up

Jes Sorensen (1):
      wifi: rtl8xxxu: Support new chip RTL8188EU

Jesper Dangaard Brouer (10):
      net: fix call location in kfree_skb_list_reason
      net: kfree_skb_list use kmem_cache_free_bulk
      net: fix kfree_skb_list use of skb_mark_not_on_list
      net: avoid irqsave in skb_defer_free_flush
      selftests/bpf: Fix unmap bug in prog_tests/xdp_metadata.c
      selftests/bpf: xdp_hw_metadata clear metadata when -EOPNOTSUPP
      selftests/bpf: xdp_hw_metadata cleanup cause segfault
      selftests/bpf: xdp_hw_metadata correct status value in error(3)
      selftests/bpf: xdp_hw_metadata use strncpy for ifname
      net: introduce skb_poison_list and use in kfree_skb_list

Jesse Brandeburg (8):
      ixgbe: XDP: fix checker warning from rcu pointer
      ice: add missing checks for PF vsi type
      virtchnl: remove unused structure declaration
      virtchnl: update header and increase header clarity
      virtchnl: do structure hardening
      virtchnl: i40e/iavf: rename iwarp to rdma
      net/core: print message for allmulticast
      net/core: refactor promiscuous mode message

Jianbo Liu (14):
      net/mlx5: Add IFC bits for general obj create param
      net/mlx5: Add IFC bits and enums for crypto key
      net/mlx5: Change key type to key purpose
      net/mlx5: Prepare for fast crypto key update if hardware supports it
      net/mlx5: Add const to the key pointer of encryption key creation
      net/mlx5: Refactor the encryption key creation
      net/mlx5: Add new APIs for fast update encryption key
      net/mlx5: Add support SYNC_CRYPTO command
      net/mlx5: Add bulk allocation and modify_dek operation
      net/mlx5: Use bulk allocation for fast update encryption key
      net/mlx5: Reuse DEKs after executing SYNC_CRYPTO command
      net/mlx5: Add async garbage collector for DEK bulk
      net/mlx5: Keep only one bulk of full available DEKs
      net/mlx5e: kTLS, Improve connection rate by using fast update encryption key

Jiapeng Chong (4):
      wifi: rt2x00: Remove useless else if
      wifi: ath10k: Remove the unused function ath10k_ce_shadow_src_ring_write_index_set()
      net: b44: Remove the unused function __b44_cam_read()
      ipv6: ICMPV6: Use swap() instead of open coding it

Jiasheng Jiang (3):
      wifi: rtw89: Add missing check for alloc_workqueue
      wifi: iwl3945: Add missing check for create_singlethread_workqueue
      wifi: iwl4965: Add missing check for create_singlethread_workqueue()

Jiawen Wu (13):
      net: txgbe: Remove structure txgbe_hw
      net: ngbe: Remove structure ngbe_hw
      net: txgbe: Move defines into unified file
      net: ngbe: Move defines into unified file
      net: wangxun: Move MAC address handling to libwx
      net: wangxun: Rename private structure in libwx
      net: txgbe: Remove structure txgbe_adapter
      net: txgbe: Add interrupt support
      net: libwx: Configure Rx and Tx unit on hardware
      net: libwx: Allocate Rx and Tx resources
      net: txgbe: Setup Rx and Tx ring
      net: libwx: Support to receive packets in NAPI
      net: txgbe: Support Rx and Tx process path

Jiri Olsa (9):
      bpf: Add struct for bin_args arg in bpf_bprintf_prepare
      bpf: Do cleanup in bpf_bprintf_cleanup only when needed
      bpf: Remove trace_printk_lock
      bpf: Do not allow to load sleepable BPF_TRACE_RAW_TP program
      bpf/selftests: Add verifier tests for loading sleepable programs
      selftests/bpf: Add serial_test_kprobe_multi_bench_attach_kernel/module tests
      bpf: Change modules resolving for kprobe multi link
      tools/resolve_btfids: Compile resolve_btfids as host program
      tools/resolve_btfids: Pass HOSTCFLAGS as EXTRA_CFLAGS to prepare targets

Jiri Pirko (50):
      devlink: remove linecards lock
      devlink: remove linecard reference counting
      net/mlx5e: Create separate devlink instance for ethernet auxiliary device
      net/mlx5: Remove MLX5E_LOCKED_FLOW flag
      devlink: protect health reporter operation with instance lock
      devlink: remove reporters_lock
      devlink: remove devl*_port_health_reporter_destroy()
      devlink: remove reporter reference counting
      devlink: convert linecards dump to devlink_nl_instance_iter_dump()
      devlink: convert reporters dump to devlink_nl_instance_iter_dump()
      devlink: remove devlink_dump_for_each_instance_get() helper
      devlink: add instance lock assertion in devl_is_registered()
      net/mlx5: Change devlink param register/unregister function names
      net/mlx5: Covert devlink params registration to use devlink_params_register/unregister()
      devlink: make devlink_param_register/unregister static
      devlink: don't work with possible NULL pointer in devlink_param_unregister()
      ice: remove pointless calls to devlink_param_driverinit_value_set()
      qed: remove pointless call to devlink_param_driverinit_value_set()
      devlink: make devlink_param_driverinit_value_set() return void
      devlink: put couple of WARN_ONs in devlink_param_driverinit_value_get()
      devlink: protect devlink param list by instance lock
      net/mlx5: Move fw reset devlink param to fw reset code
      net/mlx5: Move flow steering devlink param to flow steering code
      net/mlx5: Move eswitch port metadata devlink param to flow eswitch code
      devlink: move devlink reload notifications back in between _down() and _up() calls
      devlink: send objects notifications during devlink reload
      devlink: remove devlink features
      devlink: rename devlink_nl_instance_iter_dump() to "dumpit"
      devlink: remove "gen" from struct devlink_gen_cmd name
      devlink: rename and reorder instances of struct devlink_cmd
      net/mlx5e: Fix trap event handling
      net/mlx5e: Propagate an internal event in case uplink netdev changes
      RDMA/mlx5: Track netdev to avoid deadlock during netdev notifier unregister
      devlink: don't use strcpy() to copy param value
      devlink: make sure driver does not read updated driverinit param before reload
      devlink: fix the name of value arg of devl_param_driverinit_value_get()
      devlink: use xa_for_each_start() helper in devlink_nl_cmd_port_get_dump_one()
      devlink: convert param list to xarray
      devlink: allow to call devl_param_driverinit_value_get() without holding instance lock
      devlink: add forgotten devlink instance lock assertion to devl_param_driverinit_value_set()
      devlink: don't allow to change net namespace for FW_ACTIVATE reload action
      net/mlx5: Remove outdated comment
      net/mlx5e: Pass mdev to mlx5e_devlink_port_register()
      net/mlx5e: Replace usage of mlx5e_devlink_get_dl_port() by netdev->devlink_port
      net/mlx5e: Move dl_port to struct mlx5e_dev
      net/mlx5e: Move devlink port registration to be done before netdev alloc
      net/mlx5e: Create auxdev devlink instance in the same ns as parent devlink
      net/mlx5: Remove "recovery" arg from mlx5_load_one() function
      net/mlx5: Suspend auxiliary devices only in case of PCI device suspend
      sefltests: netdevsim: wait for devlink instance after netns removal

Jisoo Jang (3):
      wifi: brcmfmac: Fix potential stack-out-of-bounds in brcmf_c_preinit_dcmds()
      wifi: brcmfmac: ensure CLM version is null-terminated to prevent stack-out-of-bounds
      wifi: mt7601u: fix an integer underflow

Joanne Koong (2):
      selftests/bpf: Clean up user_ringbuf, cgrp_kfunc, kfunc_dynptr_param tests
      selftests/bpf: Clean up dynptr prog_tests

Johannes Berg (17):
      wifi: cfg80211: remove support for static WEP
      mac80211: support minimal EHT rate reporting on RX
      wifi: mac80211: add kernel-doc for EHT structure
      bitfield: add FIELD_PREP_CONST()
      wifi: mac80211: drop extra 'e' from ieeee80211... name
      wifi: wireless: warn on most wireless extension usage
      wifi: wireless: deny wireless extensions on MLO-capable devices
      net: netlink: recommend policy range validation
      wifi: iwlwifi: mvm: add minimal EHT rate reporting
      wifi: cfg80211: trace: remove MAC_PR_{FMT,ARG}
      wifi: mac80211: mlme: handle EHT channel puncturing
      wifi: mac80211: fix off-by-one link setting
      wifi: mac80211: pass 'sta' to ieee80211_rx_data_set_sta()
      wifi: mac80211: always initialize link_sta with sta
      wifi: mac80211: add documentation for amsdu_mesh_control
      wifi: iwlwifi: mvm: remove unused iwl_dbgfs_is_match()
      wifi: iwlegacy: avoid fortify warning

Jon Doron (1):
      libbpf: Add sample_period to creation options

Jon Maxwell (2):
      ipv6: remove max_size check inline with ipv4
      ipv6: Document that max_size sysctl is deprecated

Jonathan Neuschäfer (1):
      wifi: wl1251: Fix a typo ("boradcast")

Julian Anastasov (1):
      ipvs: avoid kfree_rcu without 2nd arg

Jun ASAKA (1):
      wifi: rtl8xxxu: fixing transmisison failure for rtl8192eu

Kalle Valo (10):
      wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices
      Merge tag 'mt76-for-kvalo-2022-12-09' of https://github.com/nbd168/wireless
      wifi: ath11k: debugfs: fix to work with multiple PCI devices
      Merge wireless into wireless-next
      wifi: ath12k: hal: add ab parameter to macros using it
      wifi: ath12k: hal: convert offset macros to functions
      wifi: ath12k: wmi: delete PSOC_HOST_MAX_NUM_SS
      Merge tag 'iwlwifi-next-for-kalle-2023-01-30' of http://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      Merge tag 'mt76-for-kvalo-2023-02-03' of https://github.com/nbd168/wireless
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Karol Kolacinski (1):
      ice: Add GPIO pin support for E823 products

Karthikeyan Kathirvel (1):
      wifi: ath11k: Fix scan request param frame size warning

Karthikeyan Periyasamy (1):
      wifi: mac80211: fix non-MLO station association

Kees Cook (9):
      ipv6: ioam: Replace 0-length array with flexible array
      net: ipv6: rpl_iptunnel: Replace 0-length arrays with flexible arrays
      ethtool: Replace 0-length array with flexible array
      bpf: Replace 0-length arrays with flexible arrays
      net/mlx5e: Replace 0-length array with flexible array
      net/i40e: Replace 0-length array with flexible array
      Bluetooth: hci_conn: Refactor hci_bind_bis() since it always succeeds
      wifi: brcmfmac: p2p: Introduce generic flexible array frame member
      net/mlx4_en: Introduce flexible array to silence overflow warning

Keith Busch (1):
      caif: don't assume iov_iter type

Khem Raj (1):
      libbpf: Fix build warning on ref_ctr_off for 32-bit architectures

Kirill Tkhai (1):
      unix: Improve locking scheme in unix_show_fdinfo()

Konstantin Ryabitsev (1):
      wifi: rtlwifi: rtl8723ae: fix obvious spelling error tyep->type

Krzysztof Kozlowski (2):
      dt-bindings: net: asix,ax88796c: allow SPI peripheral properties
      dt-bindings: net: wireless: minor whitespace and name cleanups

Kuan-Chung Chen (3):
      wifi: rtw89: fix null vif pointer when get management frame date rate
      wifi: rtw89: set the correct mac_id for management frames
      wifi: rtw89: disallow enter PS mode after create TDLS link

Kui-Feng Lee (2):
      bpf: Check the protocol of a sock to agree the calls to bpf_setsockopt().
      selftests/bpf: Calls bpf_setsockopt() on a ktls enabled socket.

Kumar Kartikeya Dwivedi (11):
      bpf: Fix state pruning for STACK_DYNPTR stack slots
      bpf: Fix missing var_off check for ARG_PTR_TO_DYNPTR
      bpf: Fix partial dynptr stack slot reads/writes
      bpf: Invalidate slices on destruction of dynptrs on stack
      bpf: Allow reinitializing unreferenced dynptr stack slots
      bpf: Combine dynptr_get_spi and is_spi_bounds_valid
      bpf: Avoid recomputing spi in process_dynptr_func
      selftests/bpf: Add dynptr pruning tests
      selftests/bpf: Add dynptr var_off tests
      selftests/bpf: Add dynptr partial slot overwrite tests
      selftests/bpf: Add dynptr helper tests

Kuniyuki Iwashima (1):
      net/ulp: Remove redundant ->clone() test in inet_clone_ulp().

Kurt Kanzenbach (1):
      net: dsa: mv88e6xxx: Enable PTP receive for mv88e6390

Laurent Vivier (2):
      virtio_net: disable VIRTIO_NET_F_STANDBY if VIRTIO_NET_F_MAC is not set
      virtio_net: notify MAC address change on device initialization

Leesoo Ahn (1):
      usbnet: optimize usbnet_bh() to reduce CPU load

Leon Romanovsky (14):
      net/mlx5e: Use read lock for eswitch get callbacks
      xfrm: extend add policy callback to set failure reason
      net/mlx5e: Fill IPsec policy validation failure reason
      xfrm: extend add state callback to set failure reason
      net/mlx5e: Fill IPsec state validation failure reason
      netdevsim: Fill IPsec state validation failure reason
      nfp: fill IPsec state validation failure reason
      ixgbevf: fill IPsec state validation failure reason
      ixgbe: fill IPsec state validation failure reason
      bonding: fill IPsec state validation failure reason
      cxgb4: fill IPsec state validation failure reason
      netlink: provide an ability to set default extack message
      net/mlx5e: Don't listen to remove flows event
      net/mlx5e: Align IPsec ASO result memory to be as required by hardware

Li Zetao (1):
      wifi: rtlwifi: Fix global-out-of-bounds bug in _rtl8812ae_phy_set_txpower_limit()

Linus Lüssing (2):
      batman-adv: mcast: remove now redundant single ucast forwarding
      batman-adv: tvlv: prepare for tvlv enabled multicast packet type

Lorenzo Bianconi (61):
      wifi: mt76: mt7996: fix endianness warning in mt7996_mcu_sta_he_tlv
      wifi: mt76: mt76x0: fix oob access in mt76x0_phy_get_target_power
      wifi: mt76: move leds field in leds struct
      wifi: mt76: move leds struct in mt76_phy
      wifi: mt76: mt7915: enable per-phy led support
      wifi: mt76: mt7615: enable per-phy led support
      wifi: mt76: dma: do not increment queue head if mt76_dma_add_buf fails
      wifi: mt76: handle possible mt76_rx_token_consume failures
      wifi: mt76: dma: rely on queue page_frag_cache for wed rx queues
      wifi: mt76: mt7915: get rid of wed rx_buf_ring page_frag_cache
      net: ethernet: enetc: unlock XDP_REDIRECT for XDP non-linear buffers
      net: ethernet: enetc: get rid of xdp_redirect_sg counter
      net: ethernet: enetc: do not always access skb_shared_info in the XDP path
      net: ethernet: mtk_wed: get rid of queue lock for rx queue
      net: ethernet: mtk_wed: get rid of queue lock for tx queue
      net: ethernet: mtk_eth_soc: introduce mtk_hw_reset utility routine
      net: ethernet: mtk_eth_soc: introduce mtk_hw_warm_reset support
      net: ethernet: mtk_eth_soc: align reset procedure to vendor sdk
      net: ethernet: mtk_eth_soc: add dma checks to mtk_hw_reset_check
      net: ethernet: mtk_wed: add reset/reset_complete callbacks
      libbpf: add the capability to specify netlink proto in libbpf_netlink_send_recv
      libbpf: add API to get XDP/XSK supported features
      bpf: devmap: check XDP features in __xdp_enqueue routine
      selftests/bpf: add test for bpf_xdp_query xdp-features support
      selftests/bpf: introduce XDP compliance test tool
      wifi: mt76: introduce mt76_queue_is_wed_rx utility routine
      wifi: mt76: mt7915: fix memory leak in mt7915_mcu_exit
      wifi: mt76: mt7996: fix memory leak in mt7996_mcu_exit
      wifi: mt76: dma: free rx_head in mt76_dma_rx_cleanup
      wifi: mt76: dma: fix memory leak running mt76_dma_tx_cleanup
      wifi: mt76: mt7915: avoid mcu_restart function pointer
      wifi: mt76: mt7603: avoid mcu_restart function pointer
      wifi: mt76: mt7615: avoid mcu_restart function pointer
      wifi: mt76: mt7921: avoid mcu_restart function pointer
      wifi: mt76: fix switch default case in mt7996_reverse_frag0_hdr_trans
      wifi: mt76: mt7915: fix memory leak in mt7915_mmio_wed_init_rx_buf
      wifi: mt76: switch to page_pool allocator
      wifi: mt76: enable page_pool stats
      wifi: mt76: mt7996: rely on mt76_connac2_mac_tx_rate_val
      wifi: mt76: mt7996: rely on mt76_connac_txp_common structure
      wifi: mt76: mt7996: rely on mt76_connac_txp_skb_unmap
      wifi: mt76: mt7996: rely on mt76_connac_tx_complete_skb
      wifi: mt76: mt7996: avoid mcu_restart function pointer
      wifi: mt76: remove __mt76_mcu_restart macro
      wifi: mt76: mt7915: add mt7915 wed reset callbacks
      wifi: mt76: mt7915: complete wed reset support
      wifi: mt76: mt76x0u: report firmware version through ethtool
      libbpf: Always use libbpf_err to return an error in bpf_xdp_query()
      virtio_net: Update xdp_features with xdp multi-buff
      net, xdp: Add missing xdp_features description
      sfc: move xdp_features configuration in efx_pci_probe_post_io()
      net: lan966x: set xdp_features flag
      net: stmmac: add missing NETDEV_XDP_ACT_XSK_ZEROCOPY bit to xdp_features
      hv_netvsc: add missing NETDEV_XDP_ACT_NDO_XMIT xdp-features flag
      net: mvneta: do not set xdp_features for hw buffer devices
      wifi: mac80211: move color collision detection report in a delayed work
      wifi: cfg80211: get rid of gfp in cfg80211_bss_color_notify
      wifi: cfg80211: remove gfp parameter from cfg80211_obss_color_collision_notify description
      i40e: check vsi type before setting xdp_features flag
      ice: update xdp_features with xdp multi-buff
      net: dpaa2-eth: do not always set xsk support in xdp_features flag

Ludovic L'Hours (1):
      libbpf: Fix map creation flags sanitization

Luiz Augusto von Dentz (2):
      Bluetooth: qca: Fix sparse warnings
      Bluetooth: L2CAP: Fix potential user-after-free

Lukas Bulwahn (2):
      net: remove redundant config PCI dependency for some network driver configs
      net: dsa: ocelot: fix selecting MFD_OCELOT

Lukas Magel (3):
      can: peak_usb: export PCAN CAN channel ID as sysfs device attribute
      can: peak_usb: align CAN channel ID format in log with sysfs attribute
      can: peak_usb: Reorder include directives alphabetically

Lukas Wunner (4):
      wifi: cfg80211: Deduplicate certificate loading
      wifi: mwifiex: Add missing compatible string for SD8787
      wifi: mwifiex: Support SD8978 chipset
      wifi: mwifiex: Support firmware hotfix version in GET_HW_SPEC responses

Maciej Fijalkowski (14):
      ice: Prepare legacy-rx for upcoming XDP multi-buffer support
      ice: Add xdp_buff to ice_rx_ring struct
      ice: Store page count inside ice_rx_buf
      ice: Pull out next_to_clean bump out of ice_put_rx_buf()
      ice: Inline eop check
      ice: Centrallize Rx buffer recycling
      ice: Use ice_max_xdp_frame_size() in ice_xdp_setup_prog()
      ice: Do not call ice_finalize_xdp_rx() unnecessarily
      ice: Use xdp->frame_sz instead of recalculating truesize
      ice: Add support for XDP multi-buffer on Rx side
      ice: Add support for XDP multi-buffer on Tx side
      ice: Remove next_{dd,rs} fields from ice_tx_ring
      ice: xsk: Do not convert to buff to frame for XDP_TX
      xsk: check IFF_UP earlier in Tx path

Magnus Karlsson (16):
      selftests/xsk: print correct payload for packet dump
      selftests/xsk: do not close unused file descriptors
      selftests/xsk: submit correct number of frames in populate_fill_ring
      selftests/xsk: print correct error codes when exiting
      selftests/xsk: remove unused variable outstanding_tx
      selftests/xsk: add debug option for creating netdevs
      selftests/xsk: replace asm acquire/release implementations
      selftests/xsk: remove namespaces
      selftests/xsk: load and attach XDP program only once per mode
      selftests/xsk: remove unnecessary code in control path
      selftests/xsk: get rid of built-in XDP program
      selftests/xsk: add test when some packets are XDP_DROPed
      selftests/xsk: merge dual and single thread dispatchers
      selftests/xsk: automatically restore packet stream
      selftests/xsk: automatically switch XDP programs
      xdp: document xdp_do_flush() before napi_complete_done()

Maher Sanalla (4):
      net/mlx5: Expose shared buffer registers bits and structs
      net/mlx5e: Add API to query/modify SBPR and SBCM registers
      net/mlx5e: Update shared buffer along with device buffer changes
      net/mlx5: Fix memory leak in error flow of port set buffer

Mahesh Bandewar (1):
      sysctl: expose all net/core sysctls inside netns

Manish Chopra (1):
      qede: fix interrupt coalescing configuration

Maor Dickman (3):
      net/mlx5e: Support Geneve and GRE with VF tunnel offload
      net/mlx5e: Remove redundant allocation of spec in create indirect fwd group
      net/mlx5: fs_core, Remove redundant variable err

Marc Bornand (1):
      wifi: cfg80211: Set SSID if it is not already set

Marc Kleine-Budde (23):
      Merge patch series "can: rcar_canfd: Add support for R-Car V4H systems"
      Merge patch series "can: ems_pci: Add support for CPC-PCIe v3"
      Merge patch series "can: peak_usb: Introduce configurable CAN channel ID"
      can: bittiming(): replace open coded variants of can_bit_time()
      can: bittiming: can_fixup_bittiming(): use CAN_SYNC_SEG instead of 1
      can: bittiming: can_fixup_bittiming(): set effective tq
      can: bittiming: can_get_bittiming(): use direct return and remove unneeded else
      can: dev: register_candev(): ensure that bittiming const are valid
      can: dev: register_candev(): bail out if both fixed bit rates and bit timing constants are provided
      can: netlink: can_validate(): validate sample point for CAN and CAN-FD
      can: netlink: can_changelink(): convert from netdev_err() to NL_SET_ERR_MSG_FMT()
      can: bittiming: can_changelink() pass extack down callstack
      can: bittiming: factor out can_sjw_set_default() and can_sjw_check()
      can: bittiming: can_fixup_bittiming(): report error via netlink and harmonize error value
      can: bittiming: can_sjw_check(): report error via netlink and harmonize error value
      can: bittiming: can_sjw_check(): check that SJW is not longer than either Phase Buffer Segment
      can: bittiming: can_sjw_set_default(): use Phase Seg2 / 2 as default for SJW
      can: bittiming: can_calc_bittiming(): clean up SJW handling
      can: bittiming: can_calc_bittiming(): convert from netdev_err() to NL_SET_ERR_MSG_FMT()
      can: bittiming: can_validate_bitrate(): report error via netlink
      Merge patch series "can: bittiming: cleanups and rework SJW handling"
      can: bittiming: can_calc_bittiming(): add missing parameter to no-op function
      Merge patch series "can: esd_usb: Some more preparation for supporting esd CAN-USB/3"

Marcel Holtmann (1):
      Bluetooth: Fix issue with Actions Semi ATS2851 based devices

Marek Majtyka (2):
      drivers: net: turn on XDP features
      xsk: add usage of XDP features flags

Mario Limonciello (1):
      Bluetooth: btusb: Add new PID/VID 0489:e0f2 for MT7921

Mark Bloch (2):
      net/mlx5: Lag, Use flag to check for shared FDB mode
      net/mlx5: Lag, Add single RDMA device in multiport mode

Mark Zhang (4):
      net/mlx5: Implement new destination type TABLE_TYPE
      net/mlx5: Add IPSec priorities in RDMA namespaces
      net/mlx5: Configure IPsec steering for ingress RoCEv2 traffic
      net/mlx5: Configure IPsec steering for egress RoCEv2 traffic

Martin Blumenstingl (8):
      wifi: mac80211: Drop stations iterator where the iterator function may sleep
      wifi: rtw88: Move register access from rtw_bf_assoc() outside the RCU
      wifi: rtw88: Use rtw_iterate_vifs() for rtw_vif_watch_dog_iter()
      wifi: rtw88: Use non-atomic sta iterator in rtw_ra_mask_info_update()
      wifi: rtw88: pci: Use enum type for rtw_hw_queue_mapping() and ac_to_hwq
      wifi: rtw88: pci: Change queue datatype to enum rtw_tx_queue_type
      wifi: rtw88: Move enum rtw_tx_queue_type mapping code to tx.{c,h}
      wifi: rtw88: mac: Use existing macros in rtw_pwr_seq_parser()

Martin KaFai Lau (10):
      Merge branch 'samples/bpf: fix LLVM compilation warning'
      bpf: Reduce smap->elem_size
      Merge branch 'bpf: Add ipip6 and ip6ip decap support for bpf_skb_adjust_room()'
      Merge branch 'xdp: hints via kfuncs'
      Merge branch 'Enable bpf_setsockopt() on ktls enabled sockets.'
      bpf: Disable bh in bpf_test_run for xdp and tc prog
      bpf: bpf_fib_lookup should not return neigh in NUD_FAILED state
      Revert "bpf, test_run: fix &xdp_frame misplacement for LIVE_FRAMES"
      bpf: Add BPF_FIB_LOOKUP_SKIP_NEIGH for bpf_fib_lookup
      selftests/bpf: Add bpf_fib_lookup test

Martin Rodriguez Reboredo (1):
      btf, scripts: Exclude Rust CUs with pahole

Maryam Tahhan (1):
      docs: BPF_MAP_TYPE_SOCK[MAP|HASH]

Masanari Iida (1):
      wifi: rtw89: Fix a typo in debug message

Matthieu Baerts (6):
      mptcp: propagate sk_ipv6only to subflows
      mptcp: userspace pm: use a single point of exit
      selftests: mptcp: userspace: print titles
      selftests: mptcp: userspace: refactor asserts
      selftests: mptcp: userspace: print error details if any
      selftests: mptcp: userspace: avoid read errors

Maxim Mikityanskiy (1):
      net/mlx5e: Trigger NAPI after activating an SQ

MeiChia Chiu (2):
      wifi: mt76: mt7915: remove BW160 and BW80+80 support
      wifi: mt76: mt7996: add EHT beamforming support

Menglong Dong (7):
      mptcp: introduce 'sk' to replace 'sock->sk' in mptcp_listen()
      mptcp: init sk->sk_prot in build_msk()
      mptcp: rename 'sk' to 'ssk' in mptcp_token_new_connect()
      mptcp: add statistics for mptcp socket in use
      selftest: mptcp: exit from copyfd_io_poll() when receive SIGUSR1
      selftest: mptcp: add test for mptcp socket in use
      libbpf: Replace '.' with '_' in legacy kprobe event name

Mengyuan Lou (8):
      net: ngbe: Remove structure ngbe_adapter
      net: ngbe: Add ngbe mdio bus driver.
      net: wangxun: clean up the code
      net: libwx: Add irq flow functions
      net: ngbe: Add irqs request flow
      net: libwx: Add tx path to process packets
      net: ngbe: Support Rx and Tx process path
      net: wangxun: Add the basic ethtool interfaces

Miaoqian Lin (2):
      net: Fix documentation for unregister_netdevice_notifier_net
      wifi: ath11k: Fix memory leak in ath11k_peer_rx_frag_setup

Michael Kelley (1):
      hv_netvsc: Check status in SEND_RNDIS_PKT completion message

Michael Walle (6):
      dt-bindings: vendor-prefixes: add MaxLinear
      dt-bindings: net: phy: add MaxLinear GPY2xx bindings
      net: phy: allow a phy to opt-out of interrupt handling
      net: phy: mxl-gpy: disable interrupts on GPY215 by default
      net: ethernet: renesas: rswitch: C45 only transactions
      net: ngbe: Drop mdiobus_c45_regad()

Michal Suchanek (1):
      bpf_doc: Fix build error with older python versions

Michal Swiatkowski (10):
      ice: move RDMA init to ice_idc.c
      ice: alloc id for RDMA using xa_array
      ice: cleanup in VSI config/deconfig code
      ice: split ice_vsi_setup into smaller functions
      ice: split probe into smaller functions
      ice: sync netdev filters after clearing VSI
      ice: move VSI delete outside deconfig
      ice: update VSI instead of init in some case
      ice: implement devlink reinit action
      ice: properly alloc ICE_VSI_LB

Mika Westerberg (3):
      net: thunderbolt: Move into own directory
      net: thunderbolt: Add debugging when sending/receiving control packets
      net: thunderbolt: Add tracepoints

Minsuk Kang (2):
      wifi: ath9k: Fix use-after-free in ath9k_hif_usb_disconnect()
      wifi: ath9k: Fix potential stack-out-of-bounds write in ath9k_wmi_rsp_callback()

Miquel Raynal (15):
      ieee802154: Add support for user scanning requests
      ieee802154: Define a beacon frame header
      ieee802154: Introduce a helper to validate a channel
      mac802154: Prepare forcing specific symbol duration
      mac802154: Add MLME Tx locked helpers
      mac802154: Handle passive scanning
      ieee802154: Add support for user beaconing requests
      mac802154: Handle basic beaconing
      mac802154: Avoid superfluous endianness handling
      ieee802154: Use netlink policies when relevant on scan parameters
      ieee802154: Convert scan error messages to extack
      ieee802154: Change error code on monitor scan netlink request
      mac802154: Send beacons using the MLME Tx path
      mac802154: Fix an always true condition
      ieee802154: Drop device trackers

Moises Cardona (1):
      Bluetooth: btusb: Add VID:PID 13d3:3529 for Realtek RTL8821CE

Mordechay Goodstein (3):
      wifi: iwlwifi: rx: add sniffer support for EHT mode
      wifi: iwlwifi: mvm: add sniffer meta data APIs
      wifi: iwlwifi: mvm: simplify by using SKB MAC header pointer

Moshe Shemesh (19):
      devlink: Split out dev get and dump code
      devlink: Move devlink dev reload code to dev
      devlink: Move devlink dev eswitch code to dev
      devlink: Move devlink dev info code to dev
      devlink: Move devlink dev flash code to dev
      devlink: Move devlink_info_req struct to be local
      devlink: Move devlink dev selftest code to dev
      net/mlx5: fw reset: Skip device ID check if PCI link up failed
      devlink: Fix memleak in health diagnose callback
      devlink: Split out health reporter create code
      devlink: health: Fix nla_nest_end in error flow
      devlink: Move devlink health get and set code to health file
      devlink: Move devlink health report and recover to health file
      devlink: Move devlink fmsg and health diagnose to health file
      devlink: Move devlink health dump to health file
      devlink: Move devlink health test to health file
      devlink: Move health common function to health file
      devlink: Update devlink health documentation
      devlink: Fix TP_STRUCT_entry in trace of devlink health report

Muhammad Husaini Zulkifli (2):
      igc: remove I226 Qbv BaseTime restriction
      igc: Remove reset adapter task for i226 during disable tsn config

Mukesh Sisodiya (1):
      wifi: iwlwifi: mvm: Reset rate index if rate is wrong

Muna Sinada (2):
      wifi: mac80211: Add VHT MU-MIMO related flags in ieee80211_bss_conf
      wifi: mac80211: Add HE MU-MIMO related flags in ieee80211_bss_conf

Nagarajan Maran (1):
      wifi: ath11k: fix monitor mode bringup crash

Neil Armstrong (1):
      dt-bindings: net: convert mdio-mux-meson-g12a.txt to dt-schema

Neil Chen (1):
      wifi: mt76: mt7921: fix rx filter incorrect by drv/fw inconsistent

Nick Child (1):
      ibmvnic: Toggle between queue types in affinity mapping

Nick Hainke (1):
      wifi: mac80211: fix double space in comment

Nikhil Gupta (1):
      ptp_qoriq: fix latency in ptp_qoriq_adjtime() operation

Nithin Dabilpuram (1):
      octeontx2-af: restore rxc conf after teardown sequence

Oleksij Rempel (10):
      net: dsa: microchip: enable EEE support
      net: phy: add genphy_c45_read_eee_abilities() function
      net: phy: micrel: add ksz9477_get_features()
      net: phy: export phy_check_valid() function
      net: phy: add genphy_c45_ethtool_get/set_eee() support
      net: phy: c22: migrate to genphy_c45_write_eee_adv()
      net: phy: c45: migrate to genphy_c45_write_eee_adv()
      net: phy: migrate phy_init_eee() to genphy_c45_eee_is_active()
      net: phy: start using genphy_c45_ethtool_get/set_eee()
      net: phy: c45: genphy_c45_an_config_aneg(): fix uninitialized symbol error

Oliver Hartkopp (3):
      can: gw: give feedback on missing CGW_FLAGS_CAN_IIF_TX_OK flag
      can: isotp: check CAN address family in isotp_bind()
      can: raw: use temp variable instead of rolling back config

Oz Shlomo (9):
      net/sched: optimize action stats api calls
      net/sched: act_pedit, setup offload action for action stats query
      net/sched: pass flow_stats instead of multiple stats args
      net/sched: introduce flow_offload action cookie
      net/sched: support per action hw stats
      net/mlx5e: TC, add hw counter to branching actions
      net/mlx5e: TC, store tc action cookies per attr
      net/mlx5e: TC, map tc action cookie to a hw counter
      net/mlx5e: TC, support per action stats

Paolo Abeni (35):
      Merge branch 'add-support-for-qsgmii-mode-for-j721e-cpsw9g-to-am65-cpsw-driver'
      Merge branch 'mv88e6xxx-add-mab-offload-support'
      Merge branch 'net-phy-mxl-gpy-broken-interrupt-fixes'
      Merge branch 'vsock-update-tools-and-error-handling'
      Merge branch 'net-use-kmem_cache_free_bulk-in-kfree_skb_list'
      Merge branch 'net-ethernet-mtk_wed-introduce-reset-support'
      Merge branch 'generic-implementation-of-phy-interface-and-fixed_phy-support-for-the-lan743x-device'
      Merge branch 'net-phy-remove-probe_capabilities'
      Merge branch 'fix-cpts-release-action-in-am65-cpts-driver'
      Merge branch 'net-sched-use-the-backlog-for-nested-mirred-ingress'
      Merge branch 'netlink-protocol-specs'
      Merge branch 'adding-sparx5-is0-vcap-support'
      mptcp: let the in-kernel PM use mixed IPv4 and IPv6 addresses
      selftests: mptcp: add test-cases for mixed v4/v6 subflows
      Merge branch 'mptcp-add-mixed-v4-v6-support-for-the-in-kernel-pm'
      Merge tag 'rxrpc-next-20230131' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs
      Merge branch 'net-sched-transition-act_pedit-to-rcu-and-percpu-stats'
      Merge branch 'amd-xgbe-add-support-for-2-5gbe-and-rx-adaptation'
      Merge tag 'linux-can-next-for-6.3-20230206' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      net-sysctl: factor out cpumask parsing helper
      net-sysctl: factor-out rpm mask manipulation helpers
      net: introduce default_rps_mask netns attribute
      self-tests: introduce self-tests for RPS default mask
      Merge branch 'add-support-for-per-action-hw-stats'
      Merge branch 'adding-sparx5-es0-vcap-support'
      Merge branch 'net-sched-retire-some-tc-qdiscs-and-classifiers'
      Merge branch 'net-core-commmon-prints-for-promisc'
      Merge branch 'net-sched-transition-actions-to-pcpu-stats-and-rcu'
      Merge branch 'sfc-devlink-support-for-ef100'
      Merge branch 'seg6-add-psp-flavor-support-for-srv6-end-behavior'
      Merge branch 'net-final-gsi-register-updates'
      Merge branch 'taprio-queuemaxsdu-fixes'
      net: make default_rps_mask a per netns attribute
      self-tests: more rps self tests
      devlink: drop leftover duplicate/unused code

Parav Pandit (4):
      virtio_net: Reuse buffer free function
      virtio-net: Reduce debug name field size to 16 bytes
      virtio-net: Maintain reverse cleanup order
      net/mlx5: Simplify eq list traversal

Patrisious Haddad (2):
      net/mlx5: Introduce CQE error syndrome
      net/mlx5: Introduce new destination type TABLE_TYPE

Paul Blakey (8):
      net/sched: Rename user cookie and act cookie
      net/sched: cls_api: Support hardware miss to tc action
      net/sched: flower: Move filter handle initialization earlier
      net/sched: flower: Support hardware miss to tc action
      net/mlx5: Kconfig: Make tc offload depend on tc skb extension
      net/mlx5: Refactor tc miss handling to a single function
      net/mlx5e: Rename CHAIN_TO_REG to MAPPED_OBJ_TO_REG
      net/mlx5e: TC, Set CT miss to the specific ct action instance

Pauli Virtanen (1):
      Bluetooth: MGMT: add CIS feature bits to controller information

Pavithra Sathyanarayanan (3):
      net: lan743x: remove unwanted interface select settings
      net: lan743x: add generic implementation for phy interface selection
      net: lan743x: add fixed phy support for LAN7431 device

Pawel Chmielewski (1):
      ice: add support BIG TCP on IPv6

Pedro Tammela (6):
      net/sched: transition act_pedit to rcu and percpu stats
      net/sched: simplify tcf_pedit_act
      net/sched: act_nat: transition to percpu stats and rcu
      net/sched: act_connmark: transition to percpu stats and rcu
      net/sched: act_gate: use percpu stats
      net/sched: act_pedit: use percpu overlimit counter when available

Peilin Ye (1):
      net/sock: Introduce trace_sk_data_ready()

Peter Chiu (2):
      wifi: mt76: mt7915: set sku initial value to zero
      wifi: mt76: mt7915: wed: enable red per-band token drop

Peter Lafreniere (1):
      wifi: rsi: Avoid defines prefixed with CONFIG

Petr Machata (20):
      selftests: mlxsw: qos_dscp_bridge: Convert from lldptool to dcb
      selftests: mlxsw: qos_dscp_router: Convert from lldptool to dcb
      selftests: mlxsw: qos_defprio: Convert from lldptool to dcb
      selftests: net: forwarding: lib: Drop lldpad_app_wait_set(), _del()
      net: bridge: Set strict_start_type at two policies
      net: bridge: Add extack to br_multicast_new_port_group()
      net: bridge: Move extack-setting to br_multicast_new_port_group()
      net: bridge: Add br_multicast_del_port_group()
      net: bridge: Change a cleanup in br_multicast_new_port_group() to goto
      net: bridge: Add a tracepoint for MDB overflows
      net: bridge: Maintain number of MDB entries in net_bridge_mcast_port
      net: bridge: Add netlink knobs for number / maximum MDB entries
      selftests: forwarding: Move IGMP- and MLD-related functions to lib
      selftests: forwarding: bridge_mdb: Fix a typo
      selftests: forwarding: lib: Add helpers for IP address handling
      selftests: forwarding: lib: Add helpers for checksum handling
      selftests: forwarding: lib: Parameterize IGMPv3/MLDv2 generation
      selftests: forwarding: lib: Allow list of IPs for IGMPv3/MLDv2
      selftests: forwarding: lib: Add helpers to build IGMP/MLD leave packets
      selftests: forwarding: bridge_mdb_max: Add a new selftest

Philipp Zabel (2):
      dt-bindings: net: Add rfkill-gpio binding
      net: rfkill: gpio: add DT support

Piergiorgio Beruto (7):
      net/ethtool: add netlink interface for the PLCA RS
      drivers/net/phy: add the link modes for the 10BASE-T1S Ethernet PHY
      drivers/net/phy: add connection between ethtool and phylib for PLCA
      drivers/net/phy: add helpers to get/set PLCA configuration
      drivers/net/phy: add driver for the onsemi NCN26000 10BASE-T1S PHY
      plca.c: fix obvious mistake in checking retval
      net: phy: fix use of uninit variable when setting PLCA config

Pietro Borrello (5):
      inet: fix fast path in __inet_hash_connect()
      net: add sock_init_data_uid()
      tun: tun_chr_open(): correctly initialize socket uid
      tap: tap_open(): correctly initialize socket uid
      rds: rds_rm_zerocopy_callback() correct order for list_add_tail()

Ping-Ke Shih (15):
      wifi: rtw89: consider ER SU as a TX capability
      wifi: rtw89: fw: adapt to new firmware format of security section
      wifi: rtw89: 8852c: rfk: correct DACK setting
      wifi: rtw89: 8852c: rfk: correct DPK settings
      wifi: rtw89: 8852c: rfk: recover RX DCK failure
      wifi: rtw89: coex: add BTC format version derived from firmware version
      wifi: rtw89: coex: use new introduction BTC version format
      wifi: rtw89: add use of pkt_list offload to debug entry
      wifi: rtw89: 8852b: reset IDMEM mode to default value
      wifi: rtw89: 8852b: don't support LPS-PG mode after firmware 0.29.26.0
      wifi: rtw89: 8852b: try to use NORMAL_CE type firmware first
      wifi: rtw89: 8852b: correct register mask name of TX power offset
      wifi: rtl8xxxu: fix txdw7 assignment of TX DESC v3
      wifi: rtw89: use readable return 0 in rtw89_mac_cfg_ppdu_status()
      wifi: rtw88: use RTW_FLAG_POWERON flag to prevent to power on/off twice

Po-Hao Huang (2):
      wifi: rtw89: refine 6 GHz scanning dwell time
      wifi: rtw89: fix AP mode authentication transmission failed

Praveen Kaligineedi (1):
      gve: Fix gve interrupt names

Przemek Kitszel (1):
      ice: combine cases in ice_ksettings_find_adv_link_speed()

Pu Lehui (5):
      bpf, x86: Simplify the parsing logic of structure parameters
      riscv: Extend patch_text for multiple instructions
      riscv, bpf: Factor out emit_call for kernel and bpf context
      riscv, bpf: Add bpf_arch_text_poke support for RV64
      riscv, bpf: Add bpf trampoline support for RV64

Qingfang DENG (1):
      net: page_pool: use in_softirq() instead

Quan Zhou (1):
      wifi: mt76: mt7921: add support to update fw capability with MTFG table

Raed Salem (1):
      net/mlx5e: IPsec, support upper protocol selector field offload

Rahul Rameshbabu (9):
      net/mlx5e: Suppress Send WQEBB room warning for PAGE_SIZE >= 16KB
      net/mlx5: Add adjphase function to support hardware-only offset control
      net/mlx5: Add hardware extended range support for PTP adjtime and adjphase
      net/mlx5: Separate mlx5 driver documentation into multiple pages
      net/mlx5: Update Kconfig parameter documentation
      net/mlx5: Document previously implemented mlx5 tracepoints
      net/mlx5: Add counter information to mlx5 driver documentation
      net/mlx5: Document support for RoCE HCA disablement capability
      net/mlx5: Add firmware support for MTUTC scaled_ppm frequency adjustments

Raj Kumar Bhagat (1):
      wifi: ath11k: fix ce memory mapping for ahb devices

Raju Rangoju (3):
      amd-xgbe: Add support for 10 Mbps speed
      amd-xgbe: add 2.5GbE support to 10G BaseT mode
      amd-xgbe: add support for rx-adaptation

Rakesh Sankaranarayanan (1):
      net: phy: microchip: run phy initialization during each link update

Rameshkumar Sundaram (2):
      wifi: cfg80211: Allow action frames to be transmitted with link BSS in MLD
      wifi: mac80211: Allow NSS change only up to capability

Randy Dunlap (5):
      net: Kconfig: fix spellos
      Documentation: bpf: correct spelling
      Documentation: networking: correct spelling
      Documentation: isdn: correct spelling
      Documentation: core-api: packing: correct spelling

Ricardo Ribalda (1):
      bpf: Remove unused field initialization in bpf's ctl_table

Robert Hancock (1):
      net: macb: simplify TX timestamp handling

Roberto Valenzuela (1):
      selftests/bpf: Fix missing space error

Roi Dayan (19):
      net/mlx5: E-switch, Remove redundant comment about meta rules
      net/mlx5e: TC, Pass flow attr to attach/detach mod hdr functions
      net/mlx5e: TC, Add tc prefix to attach/detach hdr functions
      net/mlx5e: TC, Use common function allocating flow mod hdr or encap mod hdr
      net/mlx5e: Warn when destroying mod hdr hash table that is not empty
      net/mlx5: E-Switch, Fix typo for egress
      net/mlx5: Lag, Update multiport eswitch check to log an error
      net/mlx5: Lag, Use mlx5_lag_dev() instead of derefering pointers
      net/mlx5: Lag, Remove redundant bool allocation on the stack
      net/mlx5: Lag, Move mpesw related definitions to mpesw.h
      net/mlx5e: Remove redundant code for handling vlan actions
      net/mlx5: fs, Remove redundant vport_number assignment
      net/mlx5: fs, Remove redundant assignment of size
      net/mlx5: Lag, Control MultiPort E-Switch single FDB mode
      net/mlx5e: TC, Add peer flow in mpesw mode
      net/mlx5: E-Switch, rename bond update function to be reused
      net/mlx5: Lag, set different uplink vport metadata in multiport eswitch mode
      net/mlx5e: Use a simpler comparison for uplink rep
      net/mlx5e: TC, Remove redundant parse_attr argument

Rong Tao (2):
      libbpf: Poison strlcpy()
      samples/bpf: Add openat2() enter/exit tracepoint to syscall_tp sample

Roxana Nicolescu (1):
      selftest: fib_tests: Always cleanup before exit

Russell King (Oracle) (7):
      net: pcs: pcs-lynx: use phylink_get_link_timer_ns() helper
      i2c: add fwnode APIs
      net: sfp: use i2c_get_adapter_by_fwnode()
      net: sfp: use device_get_match_data()
      net: sfp: rename gpio_of_names[]
      net: sfp: remove acpi.h include
      net: sfp: remove unused ctype.h include

Ryder Lee (13):
      wifi: mt76: mt7915: fix mt7915_rate_txpower_get() resource leaks
      wifi: mt76: mt7996: fix insecure data handling of mt7996_mcu_ie_countdown()
      wifi: mt76: mt7996: fix insecure data handling of mt7996_mcu_rx_radar_detected()
      wifi: mt76: mt7996: fix integer handling issue of mt7996_rf_regval_set()
      wifi: mt76: mt7915: split mcu chan_mib array up
      wifi: mt76: mt7915: check return value before accessing free_block_num
      wifi: mt76: mt7996: check return value before accessing free_block_num
      wifi: mt76: mt7915: check the correctness of event data
      wifi: mt76: mt7915: drop always true condition of __mt7915_reg_addr()
      wifi: mt76: mt7996: drop always true condition of __mt7996_reg_addr()
      wifi: mt76: mt7996: fix unintended sign extension of mt7996_hw_queue_read()
      wifi: mt76: mt7915: fix unintended sign extension of mt7915_hw_queue_read()
      wifi: mt76: mt7915: fix WED TxS reporting

Sascha Hauer (3):
      wifi: rtw88: usb: Set qsel correctly
      wifi: rtw88: usb: send Zero length packets if necessary
      wifi: rtw88: usb: drop now unnecessary URB size check

Sean Wang (1):
      wifi: mt76: mt7921: resource leaks at mt7921_check_offload_capability()

Sebastian Czapla (1):
      ixgbe: Filter out spurious link up indication

Seema Sreemantha (1):
      Bluetooth: btintel: Set Per Platform Antenna Gain(PPAG)

Sergei Antonov (1):
      net: ftmac100: handle netdev flags IFF_PROMISC and IFF_ALLMULTI

Sergey Temerkhanov (1):
      ice: Move support DDP code out of ice_flex_pipe.c

Shannon Nelson (4):
      ionic: remove unnecessary indirection
      ionic: remove unnecessary void casts
      net: ethtool: extend ringparam set/get APIs for rx_push
      ionic: add tx/rx-push support with device Component Memory Buffers

Shay Drory (6):
      net/mlx5: Enable management PF initialization
      net/mlx5: Remove redundant health work lock
      net/mlx5: fw_tracer: Fix debug print
      net/mlx5: fw_tracer, allow 0 size string DBs
      net/mlx5: fw_tracer, Add support for strings DB update event
      net/mlx5: fw_tracer, Add support for unrecognized string

Shayne Chen (18):
      wifi: mt76: mt7915: add chip id condition in mt7915_check_eeprom()
      wifi: mt76: mt7996: fix chainmask calculation in mt7996_set_antenna()
      wifi: mt76: mt7996: update register for CFEND_RATE
      wifi: mt76: mt7996: do not hardcode vht beamform cap
      wifi: mt76: connac: fix POWER_CTRL command name typo
      wifi: mt76: add EHT phy type
      wifi: mt76: connac: add CMD_CBW_320MHZ
      wifi: mt76: connac: add helpers for EHT capability
      wifi: mt76: connac: add cmd id related to EHT support
      wifi: mt76: increase wcid size to 1088
      wifi: mt76: add EHT rate stats for ethtool
      wifi: mt76: mt7996: add variants support
      wifi: mt76: mt7996: add helpers for wtbl and interface limit
      wifi: mt76: mt7996: rework capability init
      wifi: mt76: mt7996: add EHT capability init
      wifi: mt76: mt7996: add support for EHT rate report
      wifi: mt76: mt7996: enable EHT support in firmware
      wifi: mac80211: make rate u32 in sta_set_rate_info_rx()

Shen Jiamin (1):
      tools/resolve_btfids: Use pkg-config to locate libelf

Shigeru Yoshida (1):
      l2tp: Avoid possible recursive deadlock in l2tp_tunnel_register()

Shivani Baranwal (2):
      wifi: cfg80211: Fix extended KCK key length check in nl80211_set_rekey_data()
      wifi: cfg80211: Support 32 bytes KCK key in GTK rekey offload

Siddaraju DH (1):
      ice: restrict PTP HW clock freq adjustments to 100, 000, 000 PPB

Siddharth Vadapalli (6):
      dt-bindings: net: ti: k3-am654-cpsw-nuss: Add J721e CPSW9G support
      net: ethernet: ti: am65-cpsw: Enable QSGMII mode for J721e CPSW9G
      net: ethernet: ti: am65-cpsw: Add support for SERDES configuration
      net: ethernet: ti: am65-cpsw: Handle -EPROBE_DEFER for Serdes PHY
      net: ethernet: ti: am65-cpsw: Delete unreachable error handling code
      net: ethernet: ti: am65-cpsw/cpts: Fix CPTS release action

Simon Wunderlich (1):
      batman-adv: Start new development cycle

Sowmiya Sree Elavalagan (1):
      wifi: ath11k: Add support to configure FTM responder role

Sriram R (8):
      dt: bindings: net: ath11k: add IPQ5018 compatible
      wifi: ath11k: update hw params for IPQ5018
      wifi: ath11k: update ce configurations for IPQ5018
      wifi: ath11k: remap ce register space for IPQ5018
      wifi: ath11k: update hal srng regs for IPQ5018
      wifi: ath11k: initialize hw_ops for IPQ5018
      wifi: ath11k: add new hw ops for IPQ5018 to get rx dest ring hashmap
      wifi: ath11k: add ipq5018 device support

Srujana Challa (7):
      octeontx2-af: update CPT inbound inline IPsec config mailbox
      octeontx2-af: recover CPT engine when it gets fault
      octeontx2-af: add mbox for CPT LF reset
      octeontx2-af: modify FLR sequence for CPT
      octeontx2-af: optimize cpt pf identification
      octeontx2-af: update cpt lf alloc mailbox
      octeontx2-af: add mbox to return CPT_AF_FLT_INT info

Stanislav Fomichev (16):
      bpf: Document XDP RX metadata
      bpf: Rename bpf_{prog,map}_is_dev_bound to is_offloaded
      bpf: Move offload initialization into late_initcall
      bpf: Reshuffle some parts of bpf/offload.c
      bpf: Introduce device-bound XDP programs
      selftests/bpf: Update expected test_offload.py messages
      bpf: XDP metadata RX kfuncs
      veth: Introduce veth_xdp_buff wrapper for xdp_buff
      veth: Support RX XDP metadata
      selftests/bpf: Verify xdp_metadata xdp->af_xdp path
      net/mlx4_en: Introduce wrapper for xdp_buff
      net/mlx4_en: Support RX XDP metadata
      selftests/bpf: Simple program to dump XDP RX metadata
      selftests/bpf: Properly enable hwtstamp in xdp_hw_metadata
      selftest/bpf: Make crashes more debuggable in test_progs
      selftests/bpf: Don't refill on completion in xdp_metadata

Steen Hegelund (39):
      net: microchip: vcap api: Erase VCAP cache before encoding rule
      net: microchip: sparx5: Reset VCAP counter for new rules
      net: microchip: vcap api: Always enable VCAP lookups
      net: microchip: vcap api: Convert multi-word keys/actions when encoding
      net: microchip: vcap api: Use src and dst chain id to chain VCAP lookups
      net: microchip: vcap api: Check chains when adding a tc flower filter
      net: microchip: vcap api: Add a storage state to a VCAP rule
      net: microchip: vcap api: Enable/Disable rules via chains in VCAP HW
      net: microchip: sparx5: Add support for rule count by cookie
      net: microchip: sparx5: Add support to check for existing VCAP rule id
      net: microchip: sparx5: Add VCAP admin locking in debugFS
      net: microchip: sparx5: Improve VCAP admin locking in the VCAP API
      net: microchip: sparx5: Add lock initialization to the KUNIT tests
      net: microchip: sparx5: Add IS0 VCAP model and updated KUNIT VCAP model
      net: microchip: sparx5: Add IS0 VCAP keyset configuration for Sparx5
      net: microchip: sparx5: Add actionset type id information to rule
      net: microchip: sparx5: Add TC support for IS0 VCAP
      net: microchip: sparx5: Add TC filter chaining support for IS0 and IS2 VCAPs
      net: microchip: sparx5: Add automatic selection of VCAP rule actionset
      net: microchip: sparx5: Add support for IS0 VCAP ethernet protocol types
      net: microchip: sparx5: Add support for IS0 VCAP CVLAN TC keys
      net: microchip: sparx5: Add support for getting keysets without a type id
      net: microchip: sparx5: Improve the IP frame key match for IPv6 frames
      net: microchip: sparx5: Improve error message when parsing CVLAN filter
      net: microchip: sparx5: Add ES2 VCAP model and updated KUNIT VCAP model
      net: microchip: sparx5: Add ES2 VCAP keyset configuration for Sparx5
      net: microchip: sparx5: Add ingress information to VCAP instance
      net: microchip: sparx5: Add TC support for the ES2 VCAP
      net: microchip: sparx5: Add KUNIT tests for enabling/disabling chains
      net: microchip: sparx5: Discard frames with SMAC multicast addresses
      net: microchip: sparx5: Clear rule counter even if lookup is disabled
      net: microchip: sparx5: Egress VLAN TPID configuration follows IFH
      net: microchip: sparx5: Use chain ids without offsets when enabling rules
      net: microchip: sparx5: Improve the error handling for linked rules
      net: microchip: sparx5: Add ES0 VCAP model and updated KUNIT VCAP model
      net: microchip: sparx5: Updated register interface with VCAP ES0 access
      net: microchip: sparx5: Add ES0 VCAP keyset configuration for Sparx5
      net: microchip: sparx5: Add TC support for the ES0 VCAP
      net: microchip: sparx5: Add TC vlan action support for the ES0 VCAP

Stefan Raspl (8):
      net/smc: Terminate connections prior to device removal
      net/ism: Add missing calls to disable bus-mastering
      s390/ism: Introduce struct ism_dmb
      net/ism: Add new API for client registration
      net/smc: Register SMC-D as ISM client
      net/smc: Separate SMC-D and ISM APIs
      s390/ism: Consolidate SMC-D-related code
      net/smc: De-tangle ism and smc device initialization

Stefan Schmidt (5):
      Revert "at86rf230: convert to gpio descriptors"
      MAINTAINERS: Switch maintenance for cc2520 driver over
      MAINTAINERS: Switch maintenance for mcr20a driver over
      MAINTAINERS: Switch maintenance for mrf24j40 driver over
      MAINTAINERS: Add Miquel Raynal as additional maintainer for ieee802154

Stephane Grosjean (5):
      can: peak_usb: rename device_id to CAN channel ID
      can: peak_usb: add callback to read CAN channel ID of PEAK CAN-FD devices
      can: peak_usb: allow flashing of the CAN channel ID
      can: peak_usb: replace unregister_netdev() with unregister_candev()
      can: peak_usb: add ethtool interface to user-configurable CAN channel identifier

Sujuan Chen (3):
      wifi: mt76: mt7915: release rxwi in mt7915_wed_release_rx_buf
      wifi: mt76: dma: add reset to mt76_dma_wed_setup signature
      wifi: mt76: dma: reset wed queues in mt76_dma_rx_reset

Sunil Goutham (1):
      octeontx2-af: Removed unnecessary debug messages.

Sven Eckelmann (2):
      batman-adv: Drop prandom.h includes
      batman-adv: Fix mailing list address

Taichi Nishimura (1):
      Fix typos in selftest/bpf files

Tan Tee Min (1):
      igc: enable Qbv configuration for 2nd GCL

Tanmay Bhushan (1):
      ipv6: Remove extra counter pull before gc

Tariq Toukan (10):
      net/mlx5e: kTLS, Add debugfs
      net/mlx5: Introduce and use opcode getter in command interface
      net/mlx5: Prevent high-rate FW commands from populating all slots
      net/mlx5: Header file for crypto
      net/mlx5e: Improve remote NUMA preferences used for the IRQ affinity hints
      net/mlx5e: Switch to using napi_build_skb()
      net/mlx5e: Remove redundant page argument in mlx5e_xmit_xdp_buff()
      net/mlx5e: Remove redundant page argument in mlx5e_xdp_handle()
      net/mlx5e: Remove unused function mlx5e_sq_xmit_simple
      net/mlx5e: Fix outdated TLS comment

Thiraviyam Mariyappan (4):
      wifi: ath12k: Fix uninitilized variable clang warnings
      wifi: ath12k: hal_rx: Use memset_startat() for clearing queue descriptors
      wifi: ath12k: dp_mon: Fix out of bounds clang warning
      wifi: ath12k: dp_mon: Fix uninitialized warning related to the pktlog

Thomas Gleixner (1):
      u64_stat: Remove the obsolete fetch_irq() variants.

Thomas Kopp (1):
      can: mcp251xfd: regmap: optimizing transfer size for CRC transfers size 1

Thomas Weißschuh (2):
      net: bridge: make kobj_type structure constant
      net-sysfs: make kobj_type structures constant

Thorsten Winkler (3):
      s390/qeth: Use constant for IP address buffers
      s390/qeth: Convert sysfs sprintf to sysfs_emit
      s390/qeth: Convert sprintf/snprintf to scnprintf

Tiezhu Yang (4):
      selftests/bpf: Fix build errors if CONFIG_NF_CONNTRACK=m
      tools/bpf: Use tab instead of white spaces to sync bpf.h
      selftests/bpf: Use semicolon instead of comma in test_verifier.c
      selftests/bpf: Fix build error for LoongArch

Tobias Klauser (1):
      bpf: Drop always true do_idr_lock parameter to bpf_map_free_id

Toke Høiland-Jørgensen (5):
      bpf: Support consuming XDP HW metadata from fext programs
      xsk: Add cb area to struct xdp_buff_xsk
      net/mlx5e: Introduce wrapper for xdp_buff
      net/mlx5e: Support RX XDP metadata
      bpf/docs: Update design QA to be consistent with kfunc lifecycle docs

Tom Rix (2):
      wifi: iwlwifi: mvm: remove h from printk format specifier
      wifi: zd1211rw: remove redundant decls

Tonghao Zhang (1):
      bpftool: profile online CPUs instead of possible

Tony Nguyen (7):
      ice: Remove cppcheck suppressions
      ice: Reduce scope of variables
      ice: Explicitly return 0
      ice: Match parameter name for ice_cfg_phy_fc()
      ice: Introduce local var for readability
      ice: Remove excess space
      ice: Change ice_vsi_realloc_stat_arrays() to void

Tsotne Chakhvadze (1):
      ice: Add 'Execute Pending LLDP MIB' Admin Queue command

Uwe Kleine-König (2):
      net: stmmac: Make stmmac_dvr_remove() return void
      net: stmmac: dwc-qos: Make struct dwc_eth_dwmac_data::remove return void

Valentin Schneider (2):
      sched/topology: Introduce sched_numa_hop_mask()
      sched/topology: Introduce for_each_numa_hop_mask()

Veerendranath Jakkam (4):
      wifi: cfg80211: Use MLD address to indicate MLD STA disconnection
      wifi: cfg80211: Authentication offload to user space for MLO connection in STA mode
      wifi: cfg80211: Extend cfg80211_new_sta() for MLD AP
      wifi: cfg80211: Extend cfg80211_update_owe_info_event() for MLD AP

Vinay Gannevaram (1):
      wifi: nl80211: Allow authentication frames and set keys on NAN interface

Vlad Buslov (9):
      net: flow_offload: provision conntrack info in ct_metadata
      netfilter: flowtable: fixup UDP timeout depending on ct state
      netfilter: flowtable: allow unidirectional rules
      netfilter: flowtable: cache info of last offload
      net/sched: act_ct: set ctinfo in meta action depending on ct state
      net/sched: act_ct: offload UDP NEW connections
      netfilter: nf_conntrack: allow early drop of offloaded UDP conns
      net/mlx5e: Implement CT entry update
      net/mlx5e: Allow offloading of ct 'new' match

Vladimir Oltean (74):
      net: enetc: set next_to_clean/next_to_use just from enetc_setup_txbdr()
      net: enetc: set up RX ring indices from enetc_setup_rxbdr()
      net: enetc: create enetc_dma_free_bdr()
      net: enetc: rx_swbd and tx_swbd are never NULL in enetc_free_rxtx_rings()
      net: enetc: drop redundant enetc_free_tx_frame() call from enetc_free_txbdr()
      net: enetc: bring "bool extended" to top-level in enetc_open()
      net: enetc: split ring resource allocation from assignment
      net: enetc: move phylink_start/stop out of enetc_start/stop
      net: enetc: implement ring reconfiguration procedure for PTP RX timestamping
      net: enetc: rename "xdp" and "dev" in enetc_setup_bpf()
      net: enetc: set up XDP program under enetc_reconfigure()
      net: enetc: prioritize ability to go down over packet processing
      net: ethtool: add support for MAC Merge layer
      docs: ethtool-netlink: document interface for MAC Merge layer
      net: ethtool: netlink: retrieve stats from multiple sources (eMAC, pMAC)
      docs: ethtool: document ETHTOOL_A_STATS_SRC and ETHTOOL_A_PAUSE_STATS_SRC
      net: ethtool: add helpers for aggregate statistics
      net: ethtool: add helpers for MM fragment size translation
      net: dsa: add plumbing for changing and getting MAC merge layer state
      net: mscc: ocelot: allow ocelot_stat_layout elements with no name
      net: mscc: ocelot: hide access to ocelot_stats_layout behind a helper
      net: mscc: ocelot: export ethtool MAC Merge stats for Felix VSC9959
      net: mscc: ocelot: add MAC Merge layer support for VSC9959
      net: enetc: build common object files into a separate module
      net: enetc: detect frame preemption hardware capability
      net: enetc: add definition for offset between eMAC and pMAC regs
      net: enetc: stop configuring pMAC in lockstep with eMAC
      net: enetc: implement software lockstep for port MAC registers
      net: enetc: stop auto-configuring the port pMAC
      net: mscc: ocelot: fix incorrect verify_enabled reporting in ethtool get_mm()
      net: ethtool: fix NULL pointer dereference in stats_prepare_data()
      net: ethtool: fix NULL pointer dereference in pause_prepare_data()
      net: ethtool: provide shims for stats aggregation helpers when CONFIG_ETHTOOL_NETLINK=n
      net: dsa: ocelot: build felix.c into a dedicated kernel module
      net: dsa: use NL_SET_ERR_MSG_WEAK_MOD() more consistently
      net: enetc: simplify enetc_num_stack_tx_queues()
      net: enetc: allow the enetc_reconfigure() callback to fail
      net: enetc: recalculate num_real_tx_queues when XDP program attaches
      net: enetc: ensure we always have a minimum number of TXQs for stack
      net/sched: mqprio: refactor nlattr parsing to a separate function
      net/sched: mqprio: refactor offloading and unoffloading to dedicated functions
      net/sched: move struct tc_mqprio_qopt_offload from pkt_cls.h to pkt_sched.h
      net/sched: mqprio: allow reverse TC:TXQ mappings
      net/sched: mqprio: allow offloading drivers to request queue count validation
      net/sched: mqprio: add extack messages for queue count validation
      net/sched: taprio: centralize mqprio qopt validation
      net/sched: refactor mqprio qopt reconstruction to a library function
      net/sched: taprio: pass mqprio queue configuration to ndo_setup_tc()
      net/sched: taprio: only pass gate mask per TXQ for igc, stmmac, tsnep, am65_cpsw
      net: enetc: request mqprio to validate the queue counts
      net: enetc: act upon the requested mqprio queue configuration
      net: enetc: act upon mqprio queue config in taprio offload
      ethtool: mm: fix get_mm() return code not propagating to user space
      net: enetc: add support for MAC Merge layer
      net: enetc: add support for MAC Merge statistics counters
      net/sched: taprio: delete peek() implementation
      net/sched: taprio: continue with other TXQs if one dequeue() failed
      net/sched: taprio: refactor one skb dequeue from TXQ to separate function
      net/sched: taprio: avoid calling child->ops->dequeue(child) twice
      net/sched: taprio: give higher priority to higher TCs in software dequeue mode
      net/sched: taprio: calculate tc gate durations
      net/sched: taprio: rename close_time to end_time
      net/sched: taprio: calculate budgets per traffic class
      net/sched: taprio: calculate guard band against actual TC gate close time
      net/sched: make stab available before ops->init() call
      net/sched: taprio: warn about missing size table
      net/sched: keep the max_frm_len information inside struct sched_gate_list
      net/sched: taprio: automatically calculate queueMaxSDU based on TC gate durations
      net/sched: taprio: split segmentation logic from qdisc_enqueue()
      net/sched: taprio: don't segment unnecessarily
      net/sched: taprio: fix calculation of maximum gate durations
      net/sched: taprio: don't allow dynamic max_sdu to go negative after stab adjustment
      net/sched: taprio: dynamic max_sdu larger than the max_mtu is unlimited
      net: ethtool: fix __ethtool_dev_mm_supported() implementation

Wang Yufen (2):
      wifi: mt76: mt7915: add missing of_node_put()
      wifi: wilc1000: add missing unregister_netdev() in wilc_netdev_ifc_init()

Wen Gong (2):
      wifi: ath11k: add channel 177 into 5 GHz channel list
      wifi: cfg80211: call reg_notifier for self managed wiphy from driver hint

Wenli Looi (1):
      wifi: ath9k: remove most hidden macro dependencies on ah

Willem de Bruijn (1):
      net: msg_zerocopy: elide page accounting if RLIM_INFINITY

Xin Liu (3):
      libbpf: Optimized return value in libbpf_strerror when errno is libbpf errno
      libbpf: fix errno is overwritten after being closed.
      libbpf: Added the description of some API functions

Xin Long (15):
      net: add a couple of helpers for iph tot_len
      bridge: use skb_ip_totlen in br netfilter
      openvswitch: use skb_ip_totlen in conntrack
      net: sched: use skb_ip_totlen and iph_totlen
      netfilter: use skb_ip_totlen and iph_totlen
      cipso_ipv4: use iph_set_totlen in skbuff_setattr
      ipvlan: use skb_ip_totlen in ipvlan_get_L3_hdr
      packet: add TP_STATUS_GSO_TCP for tp_status
      net: add gso_ipv4_max_size and gro_ipv4_max_size per device
      net: add support for ipv4 big tcp
      net: create nf_conntrack_ovs for ovs and tc use
      net: extract nf_ct_skb_network_trim function to nf_conntrack_ovs
      openvswitch: move key and ovs_cb update out of handle_fragments
      net: sched: move frag check and tc_skb_cb update out of handle_fragments
      net: extract nf_ct_handle_fragments to nf_conntrack_ovs

Xuan Zhuo (2):
      xsk: support use vaddr as ring
      xsk: add linux/vmalloc.h to xsk.c

Yafang Shao (4):
      mm: memcontrol: add new kernel parameter cgroup.memory=nobpf
      bpf: use bpf_map_kvcalloc in bpf_local_storage
      bpf: allow to disable bpf map memory accounting
      bpf: allow to disable bpf prog memory accounting

Yang Li (4):
      net: libwx: clean up one inconsistent indenting
      net: libwx: Remove unneeded semicolon
      can: ctucanfd: ctucan_platform_probe(): use devm_platform_ioremap_resource()
      sfc: clean up some inconsistent indentings

Yang Yingliang (13):
      wifi: rtlwifi: rtl8821ae: don't call kfree_skb() under spin_lock_irqsave()
      wifi: rtlwifi: rtl8188ee: don't call kfree_skb() under spin_lock_irqsave()
      wifi: rtlwifi: rtl8723be: don't call kfree_skb() under spin_lock_irqsave()
      wifi: iwlegacy: common: don't call dev_kfree_skb() under spin_lock_irqsave()
      wifi: rtl8xxxu: don't call dev_kfree_skb() under spin_lock_irqsave()
      wifi: ipw2x00: don't call dev_kfree_skb() under spin_lock_irqsave()
      wifi: libertas_tf: don't call kfree_skb() under spin_lock_irqsave()
      wifi: libertas: if_usb: don't call kfree_skb() under spin_lock_irqsave()
      wifi: libertas: main: don't call kfree_skb() under spin_lock_irqsave()
      wifi: libertas: cmdresp: don't call kfree_skb() under spin_lock_irqsave()
      wifi: wl3501_cs: don't call kfree_skb() under spin_lock_irqsave()
      net: microchip: vcap: use kmemdup() to allocate memory
      netfilter: nf_tables: fix wrong pointer passed to PTR_ERR()

Ye Xingchen (1):
      selftests/bpf: Remove duplicate include header in xdp_hw_metadata

Yishai Hadas (1):
      net/mlx5: Suppress error logging on UCTX creation

Yoshihiro Shimoda (9):
      net: renesas: rswitch: Simplify struct phy * handling
      net: renesas: rswitch: Convert to phy_device
      net: renesas: rswitch: Add host_interfaces setting
      net: renesas: rswitch: Add phy_power_{on,off}() calling
      net: renesas: rswitch: Add "max-speed" handling
      net: renesas: rswitch: Rename rings in struct rswitch_gwca_queue
      net: renesas: rswitch: Move linkfix variables to rswitch_gwca
      net: renesas: rswitch: Remove gptp flag from rswitch_gwca_queue
      net: renesas: rswitch: Improve TX timestamp accuracy

Yu Xiao (1):
      nfp: ethtool: supplement nfp link modes supported

Yuan Can (1):
      wifi: rsi: Fix memory leak in rsi_coex_attach()

YueHaibing (1):
      net/mlx5e: Use kzalloc() in mlx5e_accel_fs_tcp_create()

Yunhui Cui (1):
      sock: add tracepoint for send recv length

Yury Norov (7):
      lib/find: introduce find_nth_and_andnot_bit
      cpumask: introduce cpumask_nth_and_andnot
      sched: add sched_numa_find_nth_cpu()
      cpumask: improve on cpumask_local_spread() locality
      lib/cpumask: reorganize cpumask_local_spread() logic
      lib/cpumask: update comment for cpumask_local_spread()
      sched/topology: fix KASAN warning in hop_cmp()

Zhang Changzhong (2):
      wifi: wilc1000: fix potential memory leak in wilc_mac_xmit()
      wifi: brcmfmac: fix potential memory leak in brcmf_netdev_start_xmit()

Zhen Lei (1):
      livepatch: Improve the search performance of module_kallsyms_on_each_symbol()

Zhengchao Shao (3):
      wifi: libertas: fix memory leak in lbs_init_adapter()
      wifi: ipw2200: fix memory leak in ipw_wdev_init()
      wifi: brcmfmac: unmap dma buffer in brcmf_msgbuf_alloc_pktid()

Zhengping Jiang (1):
      Bluetooth: hci_qca: get wakeup status from serdev device handle

Zhu Yanjun (1):
      ice: Mention CEE DCBX in code comment

Ziyang Xuan (2):
      bpf: Add ipip6 and ip6ip decap support for bpf_skb_adjust_room()
      selftests/bpf: add ipip6 and ip6ip decap to test_tc_tunnel

Zong-Zhe Yang (12):
      wifi: rtw89: fix potential leak in rtw89_append_probe_req_ie()
      wifi: rtw89: fix assignation of TX BD RAM table
      wifi: rtw89: 8852b: fill the missing configuration about queue empty checking
      wifi: rtw89: correct unit for port offset and refine macro
      wifi: rtw89: split out generic part of rtw89_mac_port_tsf_sync()
      wifi: rtw89: mac: add function to get TSF
      wifi: rtw89: debug: avoid invalid access on RTW89_DBG_SEL_MAC_30
      wifi: rtw89: deal with RXI300 error
      wifi: rtw89: fix parsing offset for MCC C2H
      wifi: rtw89: refine MCC C2H debug logs
      wifi: rtw89: use passed channel in set_tx_shape_dfir()
      wifi: rtw89: phy: set TX power according to RF path number by chip

zhang songyi (1):
      net/mlx5: remove redundant ret variable

 Documentation/ABI/testing/sysfs-class-net-peak_usb |   19 +
 Documentation/admin-guide/kernel-parameters.txt    |    1 +
 Documentation/admin-guide/sysctl/net.rst           |    6 +
 Documentation/bpf/bpf_design_QA.rst                |   25 +-
 Documentation/bpf/cpumasks.rst                     |  393 ++
 Documentation/bpf/graph_ds_impl.rst                |  267 +
 Documentation/bpf/index.rst                        |    1 +
 Documentation/bpf/instruction-set.rst              |  136 +-
 Documentation/bpf/kfuncs.rst                       |  219 +-
 .../bpf/libbpf/libbpf_naming_convention.rst        |    6 +-
 Documentation/bpf/map_sockmap.rst                  |  498 ++
 Documentation/bpf/map_xskmap.rst                   |    2 +-
 Documentation/bpf/other.rst                        |    3 +-
 Documentation/bpf/ringbuf.rst                      |    4 +-
 Documentation/bpf/verifier.rst                     |  297 +-
 Documentation/conf.py                              |    3 +
 Documentation/core-api/index.rst                   |    1 +
 Documentation/core-api/netlink.rst                 |  101 +
 Documentation/core-api/packing.rst                 |    2 +-
 .../devicetree/bindings/mfd/mscc,ocelot.yaml       |    9 +
 .../bindings/net/amlogic,g12a-mdio-mux.yaml        |   80 +
 .../bindings/net/amlogic,gxl-mdio-mux.yaml         |   64 +
 .../devicetree/bindings/net/asix,ax88796c.yaml     |    3 +-
 .../bindings/net/can/renesas,rcar-canfd.yaml       |   16 +-
 .../devicetree/bindings/net/dsa/arrow,xrs700x.yaml |    2 +-
 .../devicetree/bindings/net/dsa/brcm,b53.yaml      |    2 +-
 .../devicetree/bindings/net/dsa/brcm,sf2.yaml      |   15 +-
 .../devicetree/bindings/net/dsa/dsa-port.yaml      |   30 +-
 Documentation/devicetree/bindings/net/dsa/dsa.yaml |   49 +-
 .../bindings/net/dsa/hirschmann,hellcreek.yaml     |    2 +-
 .../bindings/net/dsa/mediatek,mt7530.yaml          |   58 +-
 .../devicetree/bindings/net/dsa/microchip,ksz.yaml |    2 +-
 .../bindings/net/dsa/microchip,lan937x.yaml        |    2 +-
 .../devicetree/bindings/net/dsa/mscc,ocelot.yaml   |    2 +-
 .../devicetree/bindings/net/dsa/nxp,sja1105.yaml   |    2 +-
 .../devicetree/bindings/net/dsa/qca8k.yaml         |   14 +-
 .../devicetree/bindings/net/dsa/realtek.yaml       |    2 +-
 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml       |    2 +-
 .../bindings/net/ethernet-switch-port.yaml         |   26 +
 .../devicetree/bindings/net/ethernet-switch.yaml   |   62 +
 Documentation/devicetree/bindings/net/fsl,fec.yaml |    1 +
 .../devicetree/bindings/net/maxlinear,gpy2xx.yaml  |   47 +
 .../bindings/net/mdio-mux-meson-g12a.txt           |   48 -
 .../devicetree/bindings/net/micrel-ksz90x1.txt     |    1 +
 .../devicetree/bindings/net/motorcomm,yt8xxx.yaml  |  117 +
 .../bindings/net/mscc,vsc7514-switch.yaml          |  140 +-
 .../devicetree/bindings/net/nxp,dwmac-imx.yaml     |    4 +-
 .../devicetree/bindings/net/rfkill-gpio.yaml       |   51 +
 .../devicetree/bindings/net/rockchip-dwmac.yaml    |    2 +-
 .../devicetree/bindings/net/snps,dwmac.yaml        |    2 +-
 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml        |   33 +-
 .../devicetree/bindings/net/ti,k3-am654-cpts.yaml  |    8 +
 .../bindings/net/wireless/esp,esp8089.yaml         |   20 +-
 .../bindings/net/wireless/ieee80211.yaml           |    1 -
 .../bindings/net/wireless/marvell-8xxx.txt         |    4 +-
 .../bindings/net/wireless/mediatek,mt76.yaml       |    1 -
 .../bindings/net/wireless/qcom,ath11k.yaml         |   12 +-
 .../bindings/net/wireless/silabs,wfx.yaml          |    1 -
 .../bindings/net/wireless/ti,wlcore.yaml           |   70 +-
 .../devicetree/bindings/vendor-prefixes.yaml       |    4 +
 Documentation/isdn/interface_capi.rst              |    2 +-
 Documentation/isdn/m_isdn.rst                      |    2 +-
 Documentation/netlink/genetlink-c.yaml             |  331 +
 Documentation/netlink/genetlink-legacy.yaml        |  361 +
 Documentation/netlink/genetlink.yaml               |  296 +
 Documentation/netlink/specs/ethtool.yaml           |  397 ++
 Documentation/netlink/specs/fou.yaml               |  128 +
 Documentation/netlink/specs/netdev.yaml            |  100 +
 Documentation/networking/af_xdp.rst                |    4 +-
 Documentation/networking/arcnet-hardware.rst       |    2 +-
 Documentation/networking/batman-adv.rst            |    2 +-
 Documentation/networking/can.rst                   |    2 +-
 Documentation/networking/can_ucan_protocol.rst     |    2 +-
 Documentation/networking/cdc_mbim.rst              |    2 +-
 .../networking/device_drivers/atm/iphase.rst       |    2 +-
 .../device_drivers/can/ctu/ctucanfd-driver.rst     |    4 +-
 .../device_drivers/can/ctu/fsm_txt_buffer_user.svg |    4 +-
 .../device_drivers/ethernet/3com/vortex.rst        |    2 +-
 .../device_drivers/ethernet/aquantia/atlantic.rst  |    6 +-
 .../ethernet/freescale/dpaa2/mac-phy-support.rst   |    2 +-
 .../networking/device_drivers/ethernet/index.rst   |    2 +-
 .../device_drivers/ethernet/intel/ice.rst          |   16 +-
 .../device_drivers/ethernet/marvell/octeontx2.rst  |    2 +-
 .../device_drivers/ethernet/mellanox/mlx5.rst      |  746 ---
 .../ethernet/mellanox/mlx5/counters.rst            | 1302 ++++
 .../ethernet/mellanox/mlx5/devlink.rst             |  224 +
 .../ethernet/mellanox/mlx5/index.rst               |   26 +
 .../ethernet/mellanox/mlx5/kconfig.rst             |  168 +
 .../ethernet/mellanox/mlx5/switchdev.rst           |  239 +
 .../ethernet/mellanox/mlx5/tracepoints.rst         |  229 +
 .../device_drivers/ethernet/pensando/ionic.rst     |    2 +-
 .../ethernet/ti/am65_nuss_cpsw_switchdev.rst       |    2 +-
 .../device_drivers/ethernet/ti/cpsw_switchdev.rst  |    2 +-
 .../networking/device_drivers/wwan/iosm.rst        |    2 +-
 .../networking/devlink/devlink-health.rst          |   23 +-
 Documentation/networking/devlink/ice.rst           |    4 +-
 Documentation/networking/devlink/index.rst         |    1 +
 Documentation/networking/devlink/mlx5.rst          |   18 +
 Documentation/networking/devlink/netdevsim.rst     |    2 +-
 Documentation/networking/devlink/prestera.rst      |    2 +-
 Documentation/networking/devlink/sfc.rst           |   57 +
 Documentation/networking/dsa/configuration.rst     |    2 +-
 Documentation/networking/ethtool-netlink.rst       |  272 +-
 Documentation/networking/gtp.rst                   |    2 +-
 Documentation/networking/ieee802154.rst            |    2 +-
 Documentation/networking/index.rst                 |    1 +
 Documentation/networking/ip-sysctl.rst             |   17 +-
 Documentation/networking/ipvlan.rst                |    2 +-
 Documentation/networking/j1939.rst                 |    2 +-
 Documentation/networking/net_failover.rst          |    2 +-
 Documentation/networking/netconsole.rst            |    2 +-
 Documentation/networking/page_pool.rst             |    6 +-
 Documentation/networking/phonet.rst                |    2 +-
 Documentation/networking/phy.rst                   |    2 +-
 Documentation/networking/regulatory.rst            |    4 +-
 Documentation/networking/rxrpc.rst                 |    2 +-
 Documentation/networking/snmp_counter.rst          |    4 +-
 Documentation/networking/statistics.rst            |    1 +
 Documentation/networking/sysfs-tagging.rst         |    2 +-
 Documentation/networking/xdp-rx-metadata.rst       |  110 +
 Documentation/networking/xfrm_device.rst           |    4 +-
 Documentation/userspace-api/netlink/c-code-gen.rst |  107 +
 .../userspace-api/netlink/genetlink-legacy.rst     |  178 +
 Documentation/userspace-api/netlink/index.rst      |    6 +
 .../userspace-api/netlink/intro-specs.rst          |   80 +
 Documentation/userspace-api/netlink/specs.rst      |  425 ++
 MAINTAINERS                                        |   55 +-
 arch/arm/include/asm/checksum.h                    |    1 +
 arch/arm64/boot/dts/freescale/imx93-11x11-evk.dts  |   78 +
 arch/arm64/boot/dts/freescale/imx93.dtsi           |   48 +
 arch/loongarch/net/bpf_jit.c                       |    2 +-
 arch/loongarch/net/bpf_jit.h                       |   21 +
 arch/riscv/include/asm/patch.h                     |    2 +-
 arch/riscv/kernel/patch.c                          |   19 +-
 arch/riscv/kernel/probes/kprobes.c                 |   15 +-
 arch/riscv/net/bpf_jit.h                           |    5 +
 arch/riscv/net/bpf_jit_comp64.c                    |  435 +-
 arch/s390/net/bpf_jit_comp.c                       |  715 +-
 arch/sh/include/asm/checksum_32.h                  |    1 +
 arch/x86/include/asm/checksum_64.h                 |    1 -
 arch/x86/net/bpf_jit_comp.c                        |  171 +-
 crypto/asymmetric_keys/x509_loader.c               |    1 +
 drivers/base/regmap/regmap-mdio.c                  |   41 +-
 drivers/bluetooth/btintel.c                        |  116 +
 drivers/bluetooth/btintel.h                        |   13 +
 drivers/bluetooth/btusb.c                          |   16 +
 drivers/bluetooth/hci_qca.c                        |   11 +-
 drivers/i2c/i2c-core-acpi.c                        |   13 +-
 drivers/i2c/i2c-core-base.c                        |   98 +
 drivers/i2c/i2c-core-of.c                          |   66 -
 drivers/infiniband/hw/bnxt_re/bnxt_re.h            |   10 +-
 drivers/infiniband/hw/bnxt_re/main.c               |  635 +-
 drivers/infiniband/hw/erdma/erdma_cm.c             |    3 +
 drivers/infiniband/hw/mlx5/ib_rep.c                |   18 +-
 drivers/infiniband/hw/mlx5/main.c                  |   78 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |    3 +
 drivers/infiniband/sw/siw/siw_cm.c                 |    5 +
 drivers/infiniband/sw/siw/siw_qp.c                 |    3 +
 drivers/mfd/ocelot-core.c                          |   68 +-
 drivers/net/Kconfig                                |   13 +-
 drivers/net/Makefile                               |    4 +-
 drivers/net/bonding/bond_main.c                    |   10 +-
 drivers/net/can/ctucanfd/ctucanfd_platform.c       |    4 +-
 drivers/net/can/dev/bittiming.c                    |  120 +-
 drivers/net/can/dev/calc_bittiming.c               |   34 +-
 drivers/net/can/dev/dev.c                          |   21 +
 drivers/net/can/dev/netlink.c                      |   49 +-
 drivers/net/can/rcar/rcar_canfd.c                  |  225 +-
 drivers/net/can/sja1000/ems_pci.c                  |  154 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c     |   18 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h          |   26 +-
 drivers/net/can/usb/esd_usb.c                      |   70 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c            |   44 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |  122 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.h       |   12 +-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |   68 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |   30 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.h        |    1 +
 drivers/net/dsa/lan9303-core.c                     |  169 +-
 drivers/net/dsa/microchip/Kconfig                  |   10 +
 drivers/net/dsa/microchip/Makefile                 |    5 +
 drivers/net/dsa/microchip/ksz9477.c                |   25 +
 drivers/net/dsa/microchip/ksz9477.h                |    2 +
 drivers/net/dsa/microchip/ksz9477_reg.h            |   33 +-
 drivers/net/dsa/microchip/ksz_common.c             |  246 +-
 drivers/net/dsa/microchip/ksz_common.h             |   69 +
 drivers/net/dsa/microchip/ksz_ptp.c                | 1201 ++++
 drivers/net/dsa/microchip/ksz_ptp.h                |   86 +
 drivers/net/dsa/microchip/ksz_ptp_reg.h            |  142 +
 drivers/net/dsa/microchip/lan937x.h                |    1 +
 drivers/net/dsa/microchip/lan937x_main.c           |    9 +
 drivers/net/dsa/microchip/lan937x_reg.h            |    3 +
 drivers/net/dsa/mt7530.c                           |   87 +-
 drivers/net/dsa/mt7530.h                           |   15 +-
 drivers/net/dsa/mv88e6xxx/Makefile                 |    1 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |  201 +-
 drivers/net/dsa/mv88e6xxx/chip.h                   |   23 +
 drivers/net/dsa/mv88e6xxx/global1.c                |   12 +
 drivers/net/dsa/mv88e6xxx/global1.h                |    2 +
 drivers/net/dsa/mv88e6xxx/global1_atu.c            |   24 +-
 drivers/net/dsa/mv88e6xxx/global2.c                |   66 +-
 drivers/net/dsa/mv88e6xxx/global2.h                |   18 +-
 drivers/net/dsa/mv88e6xxx/phy.c                    |   32 +
 drivers/net/dsa/mv88e6xxx/phy.h                    |    4 +
 drivers/net/dsa/mv88e6xxx/ptp.c                    |   46 +
 drivers/net/dsa/mv88e6xxx/ptp.h                    |    2 +
 drivers/net/dsa/mv88e6xxx/serdes.c                 |    8 +-
 drivers/net/dsa/mv88e6xxx/switchdev.c              |   83 +
 drivers/net/dsa/mv88e6xxx/switchdev.h              |   19 +
 drivers/net/dsa/ocelot/Kconfig                     |   32 +
 drivers/net/dsa/ocelot/Makefile                    |   13 +-
 drivers/net/dsa/ocelot/felix.c                     |   59 +-
 drivers/net/dsa/ocelot/felix.h                     |    2 +
 drivers/net/dsa/ocelot/felix_vsc9959.c             |   64 +-
 drivers/net/dsa/ocelot/ocelot_ext.c                |  163 +
 drivers/net/dsa/ocelot/seville_vsc9953.c           |    1 +
 drivers/net/dsa/qca/qca8k-8xxx.c                   |   92 +-
 drivers/net/dsa/qca/qca8k-common.c                 |   49 +-
 drivers/net/dsa/qca/qca8k.h                        |    5 +-
 drivers/net/dsa/rzn1_a5psw.c                       |    6 -
 drivers/net/dsa/sja1105/sja1105.h                  |   16 +-
 drivers/net/dsa/sja1105/sja1105_mdio.c             |  137 +-
 drivers/net/dsa/sja1105/sja1105_spi.c              |   24 +-
 drivers/net/ethernet/actions/owl-emac.c            |    6 -
 drivers/net/ethernet/adi/adin1110.c                |    1 -
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |    4 +
 drivers/net/ethernet/amd/xgbe/xgbe-common.h        |   49 +-
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c           |   94 +-
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |   24 +
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |  415 +-
 drivers/net/ethernet/amd/xgbe/xgbe.h               |   14 +-
 drivers/net/ethernet/aquantia/atlantic/aq_main.c   |    1 +
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |    5 +
 drivers/net/ethernet/atheros/alx/main.c            |   10 +-
 drivers/net/ethernet/broadcom/Kconfig              |    1 +
 drivers/net/ethernet/broadcom/b44.c                |   22 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   13 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |    8 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |    1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c    |    7 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c      |  474 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h      |   51 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |    2 +
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |    8 +
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |    8 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |   11 +-
 drivers/net/ethernet/cadence/macb.h                |   29 +-
 drivers/net/ethernet/cadence/macb_main.c           |  177 +-
 drivers/net/ethernet/cadence/macb_ptp.c            |   83 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |    2 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |    8 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h   |    2 +-
 .../chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c    |   34 +-
 drivers/net/ethernet/engleder/Makefile             |    2 +-
 drivers/net/ethernet/engleder/tsnep.h              |   16 +-
 drivers/net/ethernet/engleder/tsnep_main.c         |  479 +-
 drivers/net/ethernet/engleder/tsnep_tc.c           |   21 +
 drivers/net/ethernet/engleder/tsnep_xdp.c          |   19 +
 drivers/net/ethernet/faraday/ftmac100.c            |    6 +
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |    4 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |    6 +
 drivers/net/ethernet/freescale/enetc/Kconfig       |   14 +-
 drivers/net/ethernet/freescale/enetc/Makefile      |    7 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |  746 ++-
 drivers/net/ethernet/freescale/enetc/enetc.h       |   40 +-
 drivers/net/ethernet/freescale/enetc/enetc_cbdr.c  |    8 +
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |  232 +-
 drivers/net/ethernet/freescale/enetc/enetc_hw.h    |  137 +-
 drivers/net/ethernet/freescale/enetc/enetc_mdio.c  |  119 +-
 .../net/ethernet/freescale/enetc/enetc_pci_mdio.c  |    6 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |  113 +-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |   27 +-
 drivers/net/ethernet/freescale/fec_main.c          |  182 +-
 drivers/net/ethernet/freescale/xgmac_mdio.c        |  149 +-
 drivers/net/ethernet/fungible/funeth/Kconfig       |    2 +-
 drivers/net/ethernet/fungible/funeth/funeth_main.c |    6 +
 drivers/net/ethernet/google/gve/gve_main.c         |    9 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c |   20 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |    1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |    1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |    1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c |    1 -
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |    2 +
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c        |    1 -
 drivers/net/ethernet/hisilicon/hns_mdio.c          |  192 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   29 +-
 drivers/net/ethernet/intel/Kconfig                 |    3 +
 drivers/net/ethernet/intel/e1000e/ethtool.c        |   10 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |    7 -
 drivers/net/ethernet/intel/e1000e/phy.c            |    9 +
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c       |    5 -
 drivers/net/ethernet/intel/i40e/i40e.h             |    9 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq.c      |   68 +-
 drivers/net/ethernet/intel/i40e/i40e_alloc.h       |   22 +-
 drivers/net/ethernet/intel/i40e/i40e_client.c      |   14 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c      | 1038 ++-
 drivers/net/ethernet/intel/i40e/i40e_dcb.c         |   60 +-
 drivers/net/ethernet/intel/i40e/i40e_dcb.h         |   28 +-
 drivers/net/ethernet/intel/i40e/i40e_dcb_nl.c      |   16 +-
 drivers/net/ethernet/intel/i40e/i40e_ddp.c         |   14 +-
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c     |    8 +-
 drivers/net/ethernet/intel/i40e/i40e_diag.c        |   12 +-
 drivers/net/ethernet/intel/i40e/i40e_diag.h        |    4 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   65 +-
 drivers/net/ethernet/intel/i40e/i40e_hmc.c         |   56 +-
 drivers/net/ethernet/intel/i40e/i40e_hmc.h         |   46 +-
 drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c     |   94 +-
 drivers/net/ethernet/intel/i40e/i40e_lan_hmc.h     |   34 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  421 +-
 drivers/net/ethernet/intel/i40e/i40e_nvm.c         |  252 +-
 drivers/net/ethernet/intel/i40e/i40e_osdep.h       |    1 -
 drivers/net/ethernet/intel/i40e/i40e_prototype.h   |  643 +-
 drivers/net/ethernet/intel/i40e/i40e_status.h      |   35 -
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  157 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.h |    6 +-
 drivers/net/ethernet/intel/iavf/iavf.h             |    7 +-
 drivers/net/ethernet/intel/iavf/iavf_client.c      |   32 +-
 drivers/net/ethernet/intel/iavf/iavf_client.h      |    2 +-
 drivers/net/ethernet/intel/iavf/iavf_common.c      |    4 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |    7 +-
 drivers/net/ethernet/intel/iavf/iavf_status.h      |    2 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |    6 +-
 drivers/net/ethernet/intel/ice/Makefile            |    3 +-
 drivers/net/ethernet/intel/ice/ice.h               |   15 +-
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h    |   18 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |   21 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |   49 +-
 drivers/net/ethernet/intel/ice/ice_common.h        |    4 +-
 drivers/net/ethernet/intel/ice/ice_dcb.c           |   43 +-
 drivers/net/ethernet/intel/ice/ice_dcb.h           |    2 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c       |   70 +-
 drivers/net/ethernet/intel/ice/ice_ddp.c           | 1897 ++++++
 drivers/net/ethernet/intel/ice/ice_ddp.h           |  445 ++
 drivers/net/ethernet/intel/ice/ice_devlink.c       |  124 +-
 drivers/net/ethernet/intel/ice/ice_eswitch.c       |   26 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   69 +-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c     | 2258 +------
 drivers/net/ethernet/intel/ice/ice_flex_pipe.h     |   69 -
 drivers/net/ethernet/intel/ice/ice_flex_type.h     |  328 +-
 drivers/net/ethernet/intel/ice/ice_fltr.c          |    5 +
 drivers/net/ethernet/intel/ice/ice_gnss.c          |  377 +-
 drivers/net/ethernet/intel/ice/ice_gnss.h          |   18 +-
 drivers/net/ethernet/intel/ice/ice_idc.c           |   53 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           | 1051 ++-
 drivers/net/ethernet/intel/ice/ice_lib.h           |   50 +-
 drivers/net/ethernet/intel/ice/ice_main.c          | 1225 ++--
 drivers/net/ethernet/intel/ice/ice_nvm.c           |    1 -
 drivers/net/ethernet/intel/ice/ice_ptp.c           |   74 +-
 drivers/net/ethernet/intel/ice/ice_sched.c         |    7 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c         |  133 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c        |   50 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.h        |   10 +
 drivers/net/ethernet/intel/ice/ice_txrx.c          |  463 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h          |   87 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c      |  264 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h      |   75 +-
 drivers/net/ethernet/intel/ice/ice_vf_lib.c        |  183 +-
 drivers/net/ethernet/intel/ice/ice_vf_lib.h        |   12 +-
 .../net/ethernet/intel/ice/ice_vf_lib_private.h    |    3 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |   24 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c |    8 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  206 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   32 +-
 drivers/net/ethernet/intel/igc/igc_base.c          |   29 +
 drivers/net/ethernet/intel/igc/igc_base.h          |    2 +
 drivers/net/ethernet/intel/igc/igc_defines.h       |    1 +
 drivers/net/ethernet/intel/igc/igc_main.c          |   39 +-
 drivers/net/ethernet/intel/igc/igc_tsn.c           |   56 +-
 drivers/net/ethernet/intel/igc/igc_xdp.c           |    5 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c    |   21 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c     |   27 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   30 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c       |  237 +-
 drivers/net/ethernet/intel/ixgbevf/ipsec.c         |   21 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |    1 +
 drivers/net/ethernet/marvell/mvmdio.c              |   30 +-
 drivers/net/ethernet/marvell/mvneta.c              |    8 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |    4 +
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   33 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |    8 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   21 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cn10k.c  |   18 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cpt.c    |  309 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   56 +-
 .../ethernet/marvell/octeontx2/af/rvu_npc_hash.c   |   18 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |    4 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |    8 +-
 drivers/net/ethernet/marvell/pxa168_eth.c          |    2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  482 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |   38 +
 drivers/net/ethernet/mediatek/mtk_ppe.c            |   27 +
 drivers/net/ethernet/mediatek/mtk_ppe.h            |    1 +
 drivers/net/ethernet/mediatek/mtk_ppe_regs.h       |    6 +
 drivers/net/ethernet/mediatek/mtk_star_emac.c      |    6 -
 drivers/net/ethernet/mediatek/mtk_wed.c            |   43 +-
 drivers/net/ethernet/mediatek/mtk_wed.h            |    9 +
 drivers/net/ethernet/mediatek/mtk_wed_wo.c         |   11 -
 drivers/net/ethernet/mediatek/mtk_wed_wo.h         |    1 -
 drivers/net/ethernet/mellanox/mlx4/en_clock.c      |   13 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |    8 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |   63 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   22 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |   81 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |    5 +
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  124 +-
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |   46 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  312 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.h  |   10 +-
 .../mellanox/mlx5/core/diag/fs_tracepoint.c        |    4 +
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |   79 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.h   |    9 +
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c     |    8 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   14 +-
 .../net/ethernet/mellanox/mlx5/core/en/devlink.c   |   68 +-
 .../net/ethernet/mellanox/mlx5/core/en/devlink.h   |   14 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |    6 +-
 .../net/ethernet/mellanox/mlx5/core/en/mod_hdr.c   |    1 +
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |   18 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  |   72 +
 drivers/net/ethernet/mellanox/mlx5/core/en/port.h  |    6 +
 .../ethernet/mellanox/mlx5/core/en/port_buffer.c   |  222 +-
 .../ethernet/mellanox/mlx5/core/en/port_buffer.h   |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |    2 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/bond.c  |    6 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |  227 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |    6 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |   10 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/mirred.c |   15 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/vlan.c   |   35 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act_stats.c  |  197 +
 .../ethernet/mellanox/mlx5/core/en/tc/act_stats.h  |   27 +
 .../net/ethernet/mellanox/mlx5/core/en/tc/meter.c  |    8 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  174 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |    2 +
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |    3 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |    8 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |    5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |    8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   40 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |   12 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    |   47 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h    |    2 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   19 +-
 .../mellanox/mlx5/core/en_accel/en_accel.h         |    2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c  |    6 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |  126 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |   14 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |   77 +-
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c    |   11 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    |   49 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |   19 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |   21 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |   37 +-
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  |    2 +-
 .../net/ethernet/mellanox/mlx5/core/en_common.c    |   10 +
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |   22 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  112 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   44 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |    5 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  115 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  678 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   47 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   15 -
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   38 +-
 .../mellanox/mlx5/core/esw/acl/ingress_ofld.c      |    4 +-
 .../net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h |    4 +-
 .../ethernet/mellanox/mlx5/core/esw/indir_table.c  |  213 +-
 .../ethernet/mellanox/mlx5/core/esw/indir_table.h  |    4 -
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   18 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   11 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  337 +-
 drivers/net/ethernet/mellanox/mlx5/core/events.c   |    2 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |   13 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  131 +-
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |   10 +
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |    6 +
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |   51 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h |    2 -
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   30 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |    2 +
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |    3 +-
 .../net/ethernet/mellanox/mlx5/core/lag/debugfs.c  |   12 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |   15 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h  |   19 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c   |    8 +-
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.c    |  164 +-
 .../net/ethernet/mellanox/mlx5/core/lag/mpesw.h    |   30 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |   56 +-
 .../net/ethernet/mellanox/mlx5/core/lib/crypto.c   |  755 ++-
 .../net/ethernet/mellanox/mlx5/core/lib/crypto.h   |   34 +
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |   14 +-
 .../mellanox/mlx5/core/lib/ipsec_fs_roce.c         |  368 +
 .../mellanox/mlx5/core/lib/ipsec_fs_roce.h         |   25 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h |   17 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   68 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |    8 +-
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |    3 +-
 .../ethernet/mellanox/mlx5/core/sf/dev/driver.c    |    2 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |    5 +-
 .../net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h  |   27 +
 .../mellanox/mlxbf_gige/mlxbf_gige_ethtool.c       |    1 +
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c |  109 +-
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c |  178 +-
 .../mellanox/mlxbf_gige/mlxbf_gige_mdio_bf2.h      |   53 +
 .../mellanox/mlxbf_gige/mlxbf_gige_mdio_bf3.h      |   54 +
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h |   22 +
 drivers/net/ethernet/mellanox/mlxsw/core.c         |  166 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h         |    4 -
 .../net/ethernet/mellanox/mlxsw/core_linecards.c   |    8 +-
 drivers/net/ethernet/mellanox/mlxsw/emad.h         |    4 +
 drivers/net/ethernet/mellanox/mlxsw/reg.h          |   12 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   63 -
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |    3 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c |   21 +-
 .../ethernet/mellanox/mlxsw/spectrum_acl_tcam.c    |  244 +-
 .../ethernet/mellanox/mlxsw/spectrum_acl_tcam.h    |    5 -
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  |    2 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |  167 +-
 drivers/net/ethernet/microchip/lan743x_main.h      |    1 +
 drivers/net/ethernet/microchip/lan966x/Makefile    |    2 +
 .../net/ethernet/microchip/lan966x/lan966x_goto.c  |   10 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |    9 +
 .../net/ethernet/microchip/lan966x/lan966x_main.h  |   32 +-
 .../net/ethernet/microchip/lan966x/lan966x_ptp.c   |    7 +-
 .../net/ethernet/microchip/lan966x/lan966x_tc.c    |    3 +-
 .../ethernet/microchip/lan966x/lan966x_tc_flower.c |  198 +-
 .../microchip/lan966x/lan966x_tc_matchall.c        |   16 +-
 .../microchip/lan966x/lan966x_vcap_debugfs.c       |   94 +
 .../ethernet/microchip/lan966x/lan966x_vcap_impl.c |   46 +-
 drivers/net/ethernet/microchip/sparx5/Makefile     |    3 +-
 drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c |  121 +-
 .../net/ethernet/microchip/sparx5/sparx5_main.c    |    7 +-
 .../net/ethernet/microchip/sparx5/sparx5_main.h    |  124 +
 .../ethernet/microchip/sparx5/sparx5_main_regs.h   | 2511 +++++--
 .../net/ethernet/microchip/sparx5/sparx5_police.c  |   53 +
 .../net/ethernet/microchip/sparx5/sparx5_pool.c    |   81 +
 .../net/ethernet/microchip/sparx5/sparx5_port.c    |  102 +
 .../net/ethernet/microchip/sparx5/sparx5_port.h    |   41 +
 .../net/ethernet/microchip/sparx5/sparx5_psfp.c    |  332 +
 drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c |    3 +-
 drivers/net/ethernet/microchip/sparx5/sparx5_qos.c |   59 +
 .../net/ethernet/microchip/sparx5/sparx5_sdlb.c    |  335 +
 drivers/net/ethernet/microchip/sparx5/sparx5_tc.c  |    1 +
 drivers/net/ethernet/microchip/sparx5/sparx5_tc.h  |   74 +
 .../ethernet/microchip/sparx5/sparx5_tc_flower.c   | 1262 ++--
 .../ethernet/microchip/sparx5/sparx5_tc_matchall.c |   16 +-
 .../ethernet/microchip/sparx5/sparx5_vcap_ag_api.c | 3489 ++++++++--
 .../microchip/sparx5/sparx5_vcap_debugfs.c         |  291 +-
 .../ethernet/microchip/sparx5/sparx5_vcap_impl.c   | 1356 +++-
 .../ethernet/microchip/sparx5/sparx5_vcap_impl.h   |  120 +
 .../net/ethernet/microchip/sparx5/sparx5_vlan.c    |    4 +-
 drivers/net/ethernet/microchip/vcap/Makefile       |    2 +-
 drivers/net/ethernet/microchip/vcap/vcap_ag_api.h  |  499 +-
 drivers/net/ethernet/microchip/vcap/vcap_api.c     | 1203 +++-
 drivers/net/ethernet/microchip/vcap/vcap_api.h     |   13 +-
 .../net/ethernet/microchip/vcap/vcap_api_client.h  |   13 +-
 .../net/ethernet/microchip/vcap/vcap_api_debugfs.c |   77 +-
 .../microchip/vcap/vcap_api_debugfs_kunit.c        |   19 +-
 .../net/ethernet/microchip/vcap/vcap_api_kunit.c   |  127 +-
 .../net/ethernet/microchip/vcap/vcap_api_private.h |   15 +-
 .../net/ethernet/microchip/vcap/vcap_model_kunit.c | 2348 ++-----
 .../net/ethernet/microchip/vcap/vcap_model_kunit.h |   10 +-
 drivers/net/ethernet/microchip/vcap/vcap_tc.c      |  412 ++
 drivers/net/ethernet/microchip/vcap/vcap_tc.h      |   32 +
 drivers/net/ethernet/microsoft/mana/mana_en.c      |    2 +
 drivers/net/ethernet/mscc/Kconfig                  |    1 +
 drivers/net/ethernet/mscc/Makefile                 |    1 +
 drivers/net/ethernet/mscc/ocelot.c                 |   66 +-
 drivers/net/ethernet/mscc/ocelot.h                 |    2 +
 drivers/net/ethernet/mscc/ocelot_devlink.c         |   31 +
 drivers/net/ethernet/mscc/ocelot_mm.c              |  215 +
 drivers/net/ethernet/mscc/ocelot_stats.c           |  332 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c         |  190 +-
 drivers/net/ethernet/mscc/vsc7514_regs.c           |  159 +-
 drivers/net/ethernet/netronome/Kconfig             |    2 +-
 drivers/net/ethernet/netronome/nfp/Makefile        |    4 +-
 drivers/net/ethernet/netronome/nfp/crypto/ipsec.c  |   50 +-
 drivers/net/ethernet/netronome/nfp/devlink_param.c |    8 +-
 .../net/ethernet/netronome/nfp/flower/conntrack.c  |   24 +
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c       |   11 +-
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c       |   49 +-
 drivers/net/ethernet/netronome/nfp/nfdk/ipsec.c    |   17 +
 drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h     |    8 +
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |    5 +
 drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h  |    1 +
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   35 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_main.c  |    7 +-
 .../net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h   |    3 +
 drivers/net/ethernet/netronome/nfp/nic/dcb.c       |  571 ++
 drivers/net/ethernet/netronome/nfp/nic/main.c      |   43 +-
 drivers/net/ethernet/netronome/nfp/nic/main.h      |   46 +
 drivers/net/ethernet/ni/nixge.c                    |  141 +-
 .../net/ethernet/pensando/ionic/ionic_bus_pci.c    |    6 +-
 drivers/net/ethernet/pensando/ionic/ionic_dev.c    |   67 +
 drivers/net/ethernet/pensando/ionic/ionic_dev.h    |   13 +
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    |  117 +-
 drivers/net/ethernet/pensando/ionic/ionic_if.h     |    3 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  165 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.h    |   40 +-
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |    4 +-
 drivers/net/ethernet/pensando/ionic/ionic_phc.c    |    2 +-
 .../net/ethernet/pensando/ionic/ionic_rx_filter.c  |    4 +-
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |   22 +-
 drivers/net/ethernet/qlogic/qed/qed_devlink.c      |    6 -
 drivers/net/ethernet/qlogic/qed/qed_sriov.c        |    2 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |   14 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c |    5 +
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h |   20 +
 .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   |   18 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h    |    6 +
 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   |  191 +
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c    |   54 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h    |    1 +
 drivers/net/ethernet/realtek/r8169_main.c          |   24 +-
 drivers/net/ethernet/renesas/rswitch.c             |  554 +-
 drivers/net/ethernet/renesas/rswitch.h             |   50 +-
 drivers/net/ethernet/renesas/sh_eth.c              |   37 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_mdio.c    |  105 +-
 drivers/net/ethernet/sfc/Kconfig                   |    1 +
 drivers/net/ethernet/sfc/Makefile                  |    3 +-
 drivers/net/ethernet/sfc/ef100_netdev.c            |   30 +
 drivers/net/ethernet/sfc/ef100_nic.c               |  114 +-
 drivers/net/ethernet/sfc/ef100_nic.h               |    7 +
 drivers/net/ethernet/sfc/ef100_rep.c               |   57 +-
 drivers/net/ethernet/sfc/ef100_rep.h               |   10 +
 drivers/net/ethernet/sfc/efx.c                     |    4 +
 drivers/net/ethernet/sfc/efx_devlink.c             |  731 ++
 drivers/net/ethernet/sfc/efx_devlink.h             |   47 +
 drivers/net/ethernet/sfc/mae.c                     |  218 +-
 drivers/net/ethernet/sfc/mae.h                     |   40 +
 drivers/net/ethernet/sfc/mcdi.c                    |   72 +
 drivers/net/ethernet/sfc/mcdi.h                    |    8 +
 drivers/net/ethernet/sfc/net_driver.h              |    8 +
 drivers/net/ethernet/sfc/siena/efx.c               |    4 +
 drivers/net/ethernet/socionext/netsec.c            |    3 +
 .../ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c    |   21 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c    |   55 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |    5 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c    |    5 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c  |    5 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |    5 +
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |    2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    9 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c  |  334 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |    5 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |   20 +
 drivers/net/ethernet/sunplus/spl2sw_mdio.c         |    6 -
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   85 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h           |    1 +
 drivers/net/ethernet/ti/am65-cpsw-qos.c            |   22 +
 drivers/net/ethernet/ti/am65-cpts.c                |  170 +-
 drivers/net/ethernet/ti/am65-cpts.h                |    5 +
 drivers/net/ethernet/ti/cpsw.c                     |    4 +
 drivers/net/ethernet/ti/cpsw_new.c                 |    4 +
 drivers/net/ethernet/ti/cpsw_priv.c                |    1 +
 drivers/net/ethernet/ti/davinci_mdio.c             |   50 +-
 drivers/net/ethernet/wangxun/Kconfig               |    2 +
 drivers/net/ethernet/wangxun/libwx/Makefile        |    2 +-
 drivers/net/ethernet/wangxun/libwx/wx_ethtool.c    |   18 +
 drivers/net/ethernet/wangxun/libwx/wx_ethtool.h    |    8 +
 drivers/net/ethernet/wangxun/libwx/wx_hw.c         | 1197 +++-
 drivers/net/ethernet/wangxun/libwx/wx_hw.h         |   42 +-
 drivers/net/ethernet/wangxun/libwx/wx_lib.c        | 2004 ++++++
 drivers/net/ethernet/wangxun/libwx/wx_lib.h        |   32 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h       |  409 +-
 drivers/net/ethernet/wangxun/ngbe/Makefile         |    2 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe.h           |   79 -
 drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.c   |   22 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.h   |    9 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c        |   70 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h        |    5 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c      |  583 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c      |  286 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.h      |   12 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h      |   98 +-
 drivers/net/ethernet/wangxun/txgbe/Makefile        |    3 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe.h         |   43 -
 drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c |   19 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.h |    9 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c      |  116 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h      |    6 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c    |  569 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_type.h    |   35 +-
 drivers/net/hamradio/baycom_epp.c                  |    8 +-
 drivers/net/hyperv/netvsc.c                        |   18 +
 drivers/net/hyperv/netvsc_drv.c                    |    3 +
 drivers/net/ieee802154/at86rf230.c                 |   90 +-
 drivers/net/ieee802154/cc2520.c                    |  136 +-
 drivers/net/ipa/Makefile                           |    9 +-
 drivers/net/ipa/gsi.c                              |  486 +-
 drivers/net/ipa/gsi.h                              |    7 +-
 drivers/net/ipa/gsi_reg.c                          |  151 +
 drivers/net/ipa/gsi_reg.h                          |  504 +-
 drivers/net/ipa/ipa.h                              |    4 +-
 drivers/net/ipa/ipa_cmd.c                          |   38 +-
 drivers/net/ipa/ipa_endpoint.c                     |  585 +-
 drivers/net/ipa/ipa_endpoint.h                     |    4 +-
 drivers/net/ipa/ipa_interrupt.c                    |  142 +-
 drivers/net/ipa/ipa_interrupt.h                    |   48 +-
 drivers/net/ipa/ipa_main.c                         |  122 +-
 drivers/net/ipa/ipa_mem.c                          |   22 +-
 drivers/net/ipa/ipa_mem.h                          |    8 +-
 drivers/net/ipa/ipa_power.c                        |   19 +-
 drivers/net/ipa/ipa_power.h                        |   12 +
 drivers/net/ipa/ipa_reg.c                          |   90 +-
 drivers/net/ipa/ipa_reg.h                          |  190 +-
 drivers/net/ipa/ipa_resource.c                     |   16 +-
 drivers/net/ipa/ipa_table.c                        |   68 +-
 drivers/net/ipa/ipa_uc.c                           |   27 +-
 drivers/net/ipa/ipa_uc.h                           |    8 +
 drivers/net/ipa/ipa_version.h                      |    6 +-
 drivers/net/ipa/reg.h                              |  133 +
 drivers/net/ipa/reg/gsi_reg-v3.1.c                 |  291 +
 drivers/net/ipa/reg/gsi_reg-v3.5.1.c               |  303 +
 drivers/net/ipa/reg/gsi_reg-v4.0.c                 |  308 +
 drivers/net/ipa/reg/gsi_reg-v4.11.c                |  313 +
 drivers/net/ipa/reg/gsi_reg-v4.5.c                 |  311 +
 drivers/net/ipa/reg/gsi_reg-v4.9.c                 |  312 +
 drivers/net/ipa/reg/ipa_reg-v3.1.c                 |  283 +-
 drivers/net/ipa/reg/ipa_reg-v3.5.1.c               |  269 +-
 drivers/net/ipa/reg/ipa_reg-v4.11.c                |  271 +-
 drivers/net/ipa/reg/ipa_reg-v4.2.c                 |  255 +-
 drivers/net/ipa/reg/ipa_reg-v4.5.c                 |  287 +-
 drivers/net/ipa/reg/ipa_reg-v4.7.c                 |  271 +-
 drivers/net/ipa/reg/ipa_reg-v4.9.c                 |  271 +-
 drivers/net/ipvlan/ipvlan_core.c                   |    2 +-
 drivers/net/macsec.c                               |  125 +-
 drivers/net/mdio/Kconfig                           |   11 +
 drivers/net/mdio/Makefile                          |    1 +
 drivers/net/mdio/fwnode_mdio.c                     |    8 +-
 drivers/net/mdio/mdio-aspeed.c                     |   48 +-
 drivers/net/mdio/mdio-bitbang.c                    |   77 +-
 drivers/net/mdio/mdio-cavium.c                     |  111 +-
 drivers/net/mdio/mdio-cavium.h                     |    9 +-
 drivers/net/mdio/mdio-i2c.c                        |   38 +-
 drivers/net/mdio/mdio-ipq4019.c                    |  154 +-
 drivers/net/mdio/mdio-ipq8064.c                    |    8 -
 drivers/net/mdio/mdio-mscc-miim.c                  |    6 -
 drivers/net/mdio/mdio-mux-bcm-iproc.c              |   54 +-
 drivers/net/mdio/mdio-mux-meson-g12a.c             |   38 +-
 drivers/net/mdio/mdio-mux-meson-gxl.c              |  164 +
 drivers/net/mdio/mdio-mvusb.c                      |    6 -
 drivers/net/mdio/mdio-octeon.c                     |    6 +-
 drivers/net/mdio/mdio-thunder.c                    |    6 +-
 drivers/net/netdevsim/bpf.c                        |    4 -
 drivers/net/netdevsim/dev.c                        |   50 +-
 drivers/net/netdevsim/health.c                     |   20 +-
 drivers/net/netdevsim/ipsec.c                      |   14 +-
 drivers/net/netdevsim/netdev.c                     |    1 +
 drivers/net/pcs/pcs-lynx.c                         |   20 +-
 drivers/net/pcs/pcs-rzn1-miic.c                    |    6 +-
 drivers/net/pcs/pcs-xpcs.c                         |    4 +-
 drivers/net/phy/Kconfig                            |    9 +-
 drivers/net/phy/Makefile                           |    1 +
 drivers/net/phy/marvell.c                          |    2 +-
 drivers/net/phy/mdio-open-alliance.h               |   46 +
 drivers/net/phy/mdio_bus.c                         |  464 +-
 drivers/net/phy/micrel.c                           |  870 ++-
 drivers/net/phy/microchip_t1.c                     |   70 +-
 drivers/net/phy/motorcomm.c                        |  559 +-
 drivers/net/phy/mxl-gpy.c                          |    5 +
 drivers/net/phy/ncn26000.c                         |  171 +
 drivers/net/phy/phy-c45.c                          |  514 +-
 drivers/net/phy/phy-core.c                         |    5 +-
 drivers/net/phy/phy.c                              |  417 +-
 drivers/net/phy/phy_device.c                       |   56 +-
 drivers/net/phy/phylink.c                          |   23 +-
 drivers/net/phy/sfp.c                              |   39 +-
 drivers/net/tap.c                                  |    2 +-
 drivers/net/thunderbolt/Kconfig                    |   12 +
 drivers/net/thunderbolt/Makefile                   |    6 +
 drivers/net/{thunderbolt.c => thunderbolt/main.c}  |   48 +-
 drivers/net/thunderbolt/trace.c                    |   10 +
 drivers/net/thunderbolt/trace.h                    |  141 +
 drivers/net/tun.c                                  |    7 +-
 drivers/net/usb/cdc_ether.c                        |  114 -
 drivers/net/usb/r8152.c                            |  179 +-
 drivers/net/usb/usbnet.c                           |   29 +-
 drivers/net/veth.c                                 |   91 +-
 drivers/net/virtio_net.c                           |  428 +-
 drivers/net/wireless/ath/Kconfig                   |    1 +
 drivers/net/wireless/ath/Makefile                  |    1 +
 drivers/net/wireless/ath/ath10k/ce.c               |    8 -
 drivers/net/wireless/ath/ath11k/ahb.c              |   47 +-
 drivers/net/wireless/ath/ath11k/ce.h               |   16 +
 drivers/net/wireless/ath/ath11k/core.c             |   93 +
 drivers/net/wireless/ath/ath11k/core.h             |   18 +-
 drivers/net/wireless/ath/ath11k/debugfs.c          |   48 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   24 +-
 drivers/net/wireless/ath/ath11k/hal.c              |   17 +-
 drivers/net/wireless/ath/ath11k/hal.h              |    5 +
 drivers/net/wireless/ath/ath11k/hw.c               |  371 ++
 drivers/net/wireless/ath/ath11k/hw.h               |   12 +
 drivers/net/wireless/ath/ath11k/mac.c              |  104 +-
 drivers/net/wireless/ath/ath11k/pci.c              |    2 +
 drivers/net/wireless/ath/ath11k/wmi.c              |    4 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |    1 +
 drivers/net/wireless/ath/ath12k/Kconfig            |   34 +
 drivers/net/wireless/ath/ath12k/Makefile           |   27 +
 drivers/net/wireless/ath/ath12k/ce.c               |  964 +++
 drivers/net/wireless/ath/ath12k/ce.h               |  184 +
 drivers/net/wireless/ath/ath12k/core.c             |  939 +++
 drivers/net/wireless/ath/ath12k/core.h             |  822 +++
 drivers/net/wireless/ath/ath12k/dbring.c           |  357 +
 drivers/net/wireless/ath/ath12k/dbring.h           |   80 +
 drivers/net/wireless/ath/ath12k/debug.c            |  102 +
 drivers/net/wireless/ath/ath12k/debug.h            |   67 +
 drivers/net/wireless/ath/ath12k/dp.c               | 1580 +++++
 drivers/net/wireless/ath/ath12k/dp.h               | 1816 +++++
 drivers/net/wireless/ath/ath12k/dp_mon.c           | 2596 ++++++++
 drivers/net/wireless/ath/ath12k/dp_mon.h           |  106 +
 drivers/net/wireless/ath/ath12k/dp_rx.c            | 4234 ++++++++++++
 drivers/net/wireless/ath/ath12k/dp_rx.h            |  145 +
 drivers/net/wireless/ath/ath12k/dp_tx.c            | 1211 ++++
 drivers/net/wireless/ath/ath12k/dp_tx.h            |   41 +
 drivers/net/wireless/ath/ath12k/hal.c              | 2222 ++++++
 drivers/net/wireless/ath/ath12k/hal.h              | 1142 ++++
 drivers/net/wireless/ath/ath12k/hal_desc.h         | 2961 ++++++++
 drivers/net/wireless/ath/ath12k/hal_rx.c           |  850 +++
 drivers/net/wireless/ath/ath12k/hal_rx.h           |  704 ++
 drivers/net/wireless/ath/ath12k/hal_tx.c           |  145 +
 drivers/net/wireless/ath/ath12k/hal_tx.h           |  194 +
 drivers/net/wireless/ath/ath12k/hif.h              |  144 +
 drivers/net/wireless/ath/ath12k/htc.c              |  789 +++
 drivers/net/wireless/ath/ath12k/htc.h              |  316 +
 drivers/net/wireless/ath/ath12k/hw.c               | 1041 +++
 drivers/net/wireless/ath/ath12k/hw.h               |  312 +
 drivers/net/wireless/ath/ath12k/mac.c              | 7038 ++++++++++++++++++++
 drivers/net/wireless/ath/ath12k/mac.h              |   76 +
 drivers/net/wireless/ath/ath12k/mhi.c              |  616 ++
 drivers/net/wireless/ath/ath12k/mhi.h              |   46 +
 drivers/net/wireless/ath/ath12k/pci.c              | 1374 ++++
 drivers/net/wireless/ath/ath12k/pci.h              |  135 +
 drivers/net/wireless/ath/ath12k/peer.c             |  342 +
 drivers/net/wireless/ath/ath12k/peer.h             |   67 +
 drivers/net/wireless/ath/ath12k/qmi.c              | 3087 +++++++++
 drivers/net/wireless/ath/ath12k/qmi.h              |  569 ++
 drivers/net/wireless/ath/ath12k/reg.c              |  732 ++
 drivers/net/wireless/ath/ath12k/reg.h              |   95 +
 drivers/net/wireless/ath/ath12k/rx_desc.h          | 1441 ++++
 drivers/net/wireless/ath/ath12k/trace.c            |   10 +
 drivers/net/wireless/ath/ath12k/trace.h            |  152 +
 drivers/net/wireless/ath/ath12k/wmi.c              | 6600 ++++++++++++++++++
 drivers/net/wireless/ath/ath12k/wmi.h              | 4803 +++++++++++++
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |    2 +-
 drivers/net/wireless/ath/ath9k/ar5008_phy.c        |   10 +-
 drivers/net/wireless/ath/ath9k/ar9002_calib.c      |   30 +-
 drivers/net/wireless/ath/ath9k/ar9002_hw.c         |   10 +-
 drivers/net/wireless/ath/ath9k/ar9002_mac.c        |   14 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.c        |    4 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |   74 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   64 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h     |   12 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |    4 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |   12 +-
 drivers/net/wireless/ath/ath9k/ar9003_mci.c        |    6 +-
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c      |   56 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |   26 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |   82 +-
 drivers/net/wireless/ath/ath9k/ar9003_wow.c        |   18 +-
 drivers/net/wireless/ath/ath9k/btcoex.c            |   14 +-
 drivers/net/wireless/ath/ath9k/calib.c             |   32 +-
 drivers/net/wireless/ath/ath9k/eeprom.h            |   12 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c        |   10 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   33 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    6 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |    4 +-
 drivers/net/wireless/ath/ath9k/hw.c                |  128 +-
 drivers/net/wireless/ath/ath9k/mac.c               |   42 +-
 drivers/net/wireless/ath/ath9k/pci.c               |    4 +-
 drivers/net/wireless/ath/ath9k/reg.h               |  148 +-
 drivers/net/wireless/ath/ath9k/rng.c               |    6 +-
 drivers/net/wireless/ath/ath9k/wmi.c               |    1 +
 drivers/net/wireless/ath/ath9k/xmit.c              |    2 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |    7 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |    6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |    7 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |    1 +
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |    5 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |    4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   33 +-
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |    8 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |   11 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |   16 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |   14 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |    4 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |    2 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |    1 +
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   |    2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |  145 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c       |   59 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.h       |   19 +-
 .../wireless/intel/iwlwifi/iwl-context-info-gen3.h |   21 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   12 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |    4 +
 drivers/net/wireless/intel/iwlwifi/mei/main.c      |    6 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |    7 -
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |    6 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |    7 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |    1 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   80 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |    7 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |    5 +
 drivers/net/wireless/intersil/orinoco/hermes.c     |    1 +
 drivers/net/wireless/intersil/orinoco/hw.c         |    2 +
 drivers/net/wireless/mac80211_hwsim.c              |    6 +-
 drivers/net/wireless/marvell/libertas/cfg.c        |   76 +-
 drivers/net/wireless/marvell/libertas/cmdresp.c    |    2 +-
 drivers/net/wireless/marvell/libertas/if_usb.c     |    2 +-
 drivers/net/wireless/marvell/libertas/main.c       |    3 +-
 drivers/net/wireless/marvell/libertas/types.h      |   21 +-
 drivers/net/wireless/marvell/libertas_tf/if_usb.c  |    2 +-
 drivers/net/wireless/marvell/mwifiex/11h.c         |    2 +-
 drivers/net/wireless/marvell/mwifiex/11n.c         |    6 +-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |    2 +-
 drivers/net/wireless/marvell/mwifiex/Kconfig       |    5 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |    5 +
 drivers/net/wireless/marvell/mwifiex/fw.h          |   23 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c        |   26 +-
 drivers/net/wireless/marvell/mwifiex/sdio.h        |    1 +
 drivers/net/wireless/mediatek/mt76/Kconfig         |    1 +
 drivers/net/wireless/mediatek/mt76/debugfs.c       |    2 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |  132 +-
 drivers/net/wireless/mediatek/mt76/dma.h           |    1 +
 drivers/net/wireless/mediatek/mt76/eeprom.c        |    1 +
 drivers/net/wireless/mediatek/mt76/mac80211.c      |  124 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   67 +-
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |   34 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c    |    3 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |   85 +
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |    3 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |   16 -
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |    6 +
 .../net/wireless/mediatek/mt76/mt7615/pci_init.c   |   62 +-
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |    1 +
 .../net/wireless/mediatek/mt76/mt7615/sdio_mcu.c   |    1 -
 .../net/wireless/mediatek/mt76/mt7615/usb_mcu.c    |    1 -
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |    5 +
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |    9 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   46 +
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |   16 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    |    7 +-
 .../net/wireless/mediatek/mt76/mt76x0/usb_mcu.c    |    1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |   35 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |    6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    |   45 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |   24 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |  194 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |   12 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   39 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  193 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |    1 +
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |   99 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |    7 +
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |   13 +-
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c    |    3 +
 .../net/wireless/mediatek/mt76/mt7921/acpi_sar.c   |   62 +-
 .../net/wireless/mediatek/mt76/mt7921/acpi_sar.h   |   12 +
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |   14 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |   15 +
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  116 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  110 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |   16 +
 .../net/wireless/mediatek/mt76/mt7921/pci_mcu.c    |    9 +-
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |    8 +
 .../net/wireless/mediatek/mt76/mt7921/testmode.c   |    1 -
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c    |    4 +-
 .../net/wireless/mediatek/mt76/mt7996/debugfs.c    |   13 +-
 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c |   45 +-
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |  416 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |  149 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.h    |   24 -
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |   17 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |  249 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h    |   16 +
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c   |    7 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |   26 +-
 drivers/net/wireless/mediatek/mt76/mt7996/regs.h   |   16 +-
 drivers/net/wireless/mediatek/mt76/sdio.c          |    4 +
 drivers/net/wireless/mediatek/mt76/sdio_txrx.c     |    4 +
 drivers/net/wireless/mediatek/mt76/usb.c           |   42 +-
 drivers/net/wireless/mediatek/mt76/util.c          |   10 +-
 drivers/net/wireless/mediatek/mt7601u/dma.c        |    3 +-
 drivers/net/wireless/microchip/wilc1000/netdev.c   |    8 +-
 drivers/net/wireless/quantenna/qtnfmac/event.c     |    3 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |    2 -
 drivers/net/wireless/realtek/rtl8xxxu/Kconfig      |    3 +-
 drivers/net/wireless/realtek/rtl8xxxu/Makefile     |    3 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  142 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188e.c | 1899 ++++++
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c |   24 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c |   13 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |   45 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c |   28 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c |   18 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |  450 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |   46 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |    6 +-
 .../realtek/rtlwifi/rtl8723ae/hal_bt_coexist.h     |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   |   52 +-
 drivers/net/wireless/realtek/rtw88/bf.c            |   13 +-
 drivers/net/wireless/realtek/rtw88/coex.c          |    2 +-
 drivers/net/wireless/realtek/rtw88/mac.c           |   14 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |    4 +-
 drivers/net/wireless/realtek/rtw88/main.c          |    6 +-
 drivers/net/wireless/realtek/rtw88/main.h          |    2 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |   50 +-
 drivers/net/wireless/realtek/rtw88/ps.c            |    4 +-
 drivers/net/wireless/realtek/rtw88/tx.c            |   41 +
 drivers/net/wireless/realtek/rtw88/tx.h            |    3 +
 drivers/net/wireless/realtek/rtw88/usb.c           |   18 +-
 drivers/net/wireless/realtek/rtw88/wow.c           |    2 +-
 drivers/net/wireless/realtek/rtw89/coex.c          | 1813 +++--
 drivers/net/wireless/realtek/rtw89/coex.h          |    1 +
 drivers/net/wireless/realtek/rtw89/core.c          |  130 +-
 drivers/net/wireless/realtek/rtw89/core.h          |  295 +-
 drivers/net/wireless/realtek/rtw89/debug.c         |   43 +
 drivers/net/wireless/realtek/rtw89/debug.h         |    1 +
 drivers/net/wireless/realtek/rtw89/fw.c            |  146 +-
 drivers/net/wireless/realtek/rtw89/fw.h            |   54 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |   99 +-
 drivers/net/wireless/realtek/rtw89/mac.h           |   19 +-
 drivers/net/wireless/realtek/rtw89/mac80211.c      |    1 +
 drivers/net/wireless/realtek/rtw89/pci.c           |   17 +-
 drivers/net/wireless/realtek/rtw89/pci.h           |   15 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |   19 +-
 drivers/net/wireless/realtek/rtw89/reg.h           |   25 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |   26 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk.c  |    2 +-
 drivers/net/wireless/realtek/rtw89/rtw8852ae.c     |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852b.c      |   27 +-
 drivers/net/wireless/realtek/rtw89/rtw8852be.c     |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |   20 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c  |  353 +-
 drivers/net/wireless/realtek/rtw89/rtw8852ce.c     |    1 +
 drivers/net/wireless/realtek/rtw89/ser.c           |    1 +
 drivers/net/wireless/realtek/rtw89/txrx.h          |    2 +
 drivers/net/wireless/realtek/rtw89/wow.c           |   26 +-
 drivers/net/wireless/rsi/rsi_91x_coex.c            |    1 +
 drivers/net/wireless/rsi/rsi_91x_hal.c             |    4 +-
 drivers/net/wireless/rsi/rsi_hal.h                 |    2 +-
 drivers/net/wireless/ti/wl1251/init.c              |    2 +-
 drivers/net/wireless/wl3501_cs.c                   |    2 +-
 drivers/net/wireless/zydas/zd1211rw/zd_rf.h        |    3 -
 drivers/net/xen-netfront.c                         |    2 +
 drivers/nvme/host/tcp.c                            |    3 +
 drivers/nvme/target/tcp.c                          |    5 +
 drivers/ptp/ptp_qoriq.c                            |   50 +-
 drivers/s390/net/ctcm_fsms.c                       |   32 +-
 drivers/s390/net/ctcm_main.c                       |   16 +-
 drivers/s390/net/ctcm_mpc.c                        |   15 +-
 drivers/s390/net/ism.h                             |   19 +-
 drivers/s390/net/ism_drv.c                         |  376 +-
 drivers/s390/net/qeth_core_main.c                  |   14 +-
 drivers/s390/net/qeth_core_sys.c                   |   66 +-
 drivers/s390/net/qeth_ethtool.c                    |    6 +-
 drivers/s390/net/qeth_l2_main.c                    |   53 +-
 drivers/s390/net/qeth_l2_sys.c                     |   28 +-
 drivers/s390/net/qeth_l3_main.c                    |    7 +-
 drivers/s390/net/qeth_l3_sys.c                     |   83 +-
 drivers/scsi/iscsi_tcp.c                           |    3 +
 drivers/scsi/lpfc/lpfc_init.c                      |    1 +
 drivers/soc/qcom/qmi_interface.c                   |    3 +
 drivers/target/iscsi/iscsi_target_nego.c           |    2 +
 drivers/vhost/vsock.c                              |  214 +-
 drivers/xen/pvcalls-back.c                         |    5 +
 fs/dlm/lowcomms.c                                  |    5 +
 fs/ocfs2/cluster/tcp.c                             |    5 +
 include/linux/acpi.h                               |   15 +
 include/linux/avf/virtchnl.h                       |  159 +-
 include/linux/bitfield.h                           |   26 +
 include/linux/bpf.h                                |  156 +-
 include/linux/bpf_verifier.h                       |   83 +-
 include/linux/btf.h                                |   23 +-
 include/linux/can/bittiming.h                      |   12 +-
 include/linux/cpumask.h                            |   20 +
 include/linux/dsa/ksz_common.h                     |   53 +
 include/linux/ethtool.h                            |  265 +-
 include/linux/ethtool_netlink.h                    |   42 +
 include/linux/filter.h                             |    1 +
 include/linux/find.h                               |   33 +
 include/linux/fsl/enetc_mdio.h                     |   21 +-
 include/linux/fsl/ptp_qoriq.h                      |    1 +
 include/linux/i2c.h                                |   24 +-
 include/linux/ieee80211.h                          |    1 +
 include/linux/ieee802154.h                         |    7 +
 include/linux/igmp.h                               |    1 +
 include/linux/ip.h                                 |   21 +
 include/linux/ism.h                                |   98 +
 include/linux/mdio-bitbang.h                       |    6 +-
 include/linux/mdio.h                               |  150 +-
 include/linux/memcontrol.h                         |   11 +
 include/linux/micrel_phy.h                         |    3 +
 include/linux/mlx4/qp.h                            |    1 +
 include/linux/mlx5/device.h                        |    6 +
 include/linux/mlx5/driver.h                        |   24 +-
 include/linux/mlx5/fs.h                            |    5 +
 include/linux/mlx5/mlx5_ifc.h                      |  297 +-
 include/linux/mmc/sdio_ids.h                       |    1 +
 include/linux/module.h                             |    6 +-
 include/linux/netdevice.h                          |   22 +-
 include/linux/netfilter.h                          |    3 +
 include/linux/netlink.h                            |   14 +
 include/linux/phy.h                                |  116 +-
 include/linux/poison.h                             |    3 +
 include/linux/ptp_classify.h                       |   73 +
 include/linux/regmap.h                             |    8 +
 include/linux/skbuff.h                             |   49 +-
 include/linux/soc/mediatek/mtk_wed.h               |    3 +-
 include/linux/spi/at86rf230.h                      |   20 -
 include/linux/spi/cc2520.h                         |   21 -
 include/linux/string_helpers.h                     |    5 +
 include/linux/topology.h                           |   33 +
 include/linux/u64_stats_sync.h                     |   12 -
 include/linux/virtio_vsock.h                       |  129 +-
 include/net/act_api.h                              |    2 +-
 include/net/bluetooth/hci.h                        |    4 +-
 include/net/bluetooth/mgmt.h                       |    2 +
 include/net/cfg80211.h                             |  148 +-
 include/net/cfg802154.h                            |   78 +-
 include/net/checksum.h                             |    4 +-
 include/net/dcbnl.h                                |   18 +
 include/net/devlink.h                              |   55 +-
 include/net/dropreason.h                           |   26 +
 include/net/dsa.h                                  |   11 +
 include/net/dst_ops.h                              |    2 +-
 include/net/flow.h                                 |    5 +-
 include/net/flow_offload.h                         |    6 +-
 include/net/ieee802154_netdev.h                    |   52 +
 include/net/inet_sock.h                            |    4 +
 include/net/ip.h                                   |    3 +-
 include/net/ip6_route.h                            |    4 -
 include/net/ip_vs.h                                |    1 +
 include/net/ipv6.h                                 |    3 +-
 include/net/mac80211.h                             |   81 +-
 include/net/ndisc.h                                |    2 +-
 include/net/netfilter/nf_conntrack.h               |   12 +
 include/net/netfilter/nf_flow_table.h              |    8 +-
 include/net/netfilter/nf_tables_core.h             |   16 +
 include/net/netfilter/nf_tables_ipv4.h             |    4 +-
 include/net/netlink.h                              |    3 +-
 include/net/netns/core.h                           |    5 +
 include/net/nl802154.h                             |   61 +
 include/net/page_pool.h                            |   14 +-
 include/net/pkt_cls.h                              |   74 +-
 include/net/pkt_sched.h                            |   21 +
 include/net/raw.h                                  |   13 +-
 include/net/route.h                                |    3 -
 include/net/sch_generic.h                          |    2 +
 include/net/smc.h                                  |   24 +-
 include/net/sock.h                                 |   35 +-
 include/net/tc_act/tc_connmark.h                   |    9 +-
 include/net/tc_act/tc_nat.h                        |   10 +-
 include/net/tc_act/tc_pedit.h                      |   81 +-
 include/net/tc_wrapper.h                           |   15 -
 include/net/xdp.h                                  |   36 +
 include/net/xsk_buff_pool.h                        |    5 +
 include/soc/mscc/ocelot.h                          |   64 +
 include/soc/mscc/ocelot_dev.h                      |   23 +
 include/soc/mscc/vsc7514_regs.h                    |   18 +-
 include/trace/events/bridge.h                      |   58 +
 include/trace/events/devlink.h                     |    2 +-
 include/trace/events/rxrpc.h                       |  492 +-
 include/trace/events/skb.h                         |   10 +-
 include/trace/events/sock.h                        |   69 +
 include/uapi/linux/batadv_packet.h                 |    2 +
 include/uapi/linux/bpf.h                           |   35 +-
 include/uapi/linux/dcbnl.h                         |    2 +
 include/uapi/linux/ethtool.h                       |   48 +-
 include/uapi/linux/ethtool_netlink.h               |   79 +
 include/uapi/linux/fou.h                           |   54 +-
 include/uapi/linux/if_bridge.h                     |    2 +
 include/uapi/linux/if_link.h                       |    5 +
 include/uapi/linux/if_packet.h                     |    1 +
 include/uapi/linux/in.h                            |    1 +
 include/uapi/linux/ioam6.h                         |    2 +-
 include/uapi/linux/mdio.h                          |    8 +
 include/uapi/linux/netdev.h                        |   59 +
 include/uapi/linux/netfilter/nf_tables.h           |   14 +
 include/uapi/linux/nl80211.h                       |   36 +-
 include/uapi/linux/rpl.h                           |    4 +-
 include/uapi/linux/rtnetlink.h                     |    1 +
 include/uapi/linux/snmp.h                          |    3 +
 init/Kconfig                                       |    2 +-
 kernel/bpf/Makefile                                |    1 +
 kernel/bpf/bpf_local_storage.c                     |    8 +-
 kernel/bpf/btf.c                                   |  394 +-
 kernel/bpf/core.c                                  |   25 +-
 kernel/bpf/cpumap.c                                |    2 +-
 kernel/bpf/cpumask.c                               |  479 ++
 kernel/bpf/devmap.c                                |   16 +-
 kernel/bpf/hashtab.c                               |    4 +-
 kernel/bpf/helpers.c                               |  203 +-
 kernel/bpf/memalloc.c                              |    5 +-
 kernel/bpf/offload.c                               |  419 +-
 kernel/bpf/preload/bpf_preload_kern.c              |    6 +-
 kernel/bpf/preload/iterators/Makefile              |   12 +-
 kernel/bpf/preload/iterators/README                |    5 +-
 .../preload/iterators/iterators.lskel-big-endian.h |  419 ++
 ...ors.lskel.h => iterators.lskel-little-endian.h} |    0
 kernel/bpf/syscall.c                               |  106 +-
 kernel/bpf/verifier.c                              | 1293 +++-
 kernel/cgroup/rstat.c                              |    4 +-
 kernel/kexec_core.c                                |    3 +-
 kernel/livepatch/core.c                            |   10 +-
 kernel/module/kallsyms.c                           |   13 +-
 kernel/sched/topology.c                            |   95 +
 kernel/trace/bpf_trace.c                           |  157 +-
 kernel/trace/ftrace.c                              |    2 +-
 lib/Kconfig.debug                                  |    9 +
 lib/cpumask.c                                      |   52 +-
 lib/find_bit.c                                     |    9 +
 mm/memcontrol.c                                    |   18 +
 net/Makefile                                       |    1 +
 net/batman-adv/bat_iv_ogm.c                        |    1 -
 net/batman-adv/bat_v_elp.c                         |    1 -
 net/batman-adv/bat_v_ogm.c                         |    5 +-
 net/batman-adv/distributed-arp-table.c             |    2 +-
 net/batman-adv/gateway_common.c                    |    2 +-
 net/batman-adv/main.h                              |    2 +-
 net/batman-adv/multicast.c                         |  251 +-
 net/batman-adv/multicast.h                         |   38 +-
 net/batman-adv/network-coding.c                    |    4 +-
 net/batman-adv/routing.c                           |    7 +-
 net/batman-adv/soft-interface.c                    |   26 +-
 net/batman-adv/translation-table.c                 |    4 +-
 net/batman-adv/tvlv.c                              |   71 +-
 net/batman-adv/tvlv.h                              |    9 +-
 net/batman-adv/types.h                             |    6 +
 net/bluetooth/hci_conn.c                           |   23 +-
 net/bluetooth/l2cap_core.c                         |   24 -
 net/bluetooth/l2cap_sock.c                         |    8 +
 net/bluetooth/mgmt.c                               |   12 +
 net/bluetooth/rfcomm/core.c                        |    4 +
 net/bpf/bpf_dummy_struct_ops.c                     |   18 +
 net/bpf/test_run.c                                 |   77 +-
 net/bridge/br_if.c                                 |    2 +-
 net/bridge/br_mdb.c                                |   66 +-
 net/bridge/br_multicast.c                          |  179 +-
 net/bridge/br_netfilter_hooks.c                    |    2 +-
 net/bridge/br_netlink.c                            |   19 +-
 net/bridge/br_netlink_tunnel.c                     |    3 +
 net/bridge/br_private.h                            |   12 +-
 net/bridge/br_switchdev.c                          |   10 +-
 net/bridge/br_vlan.c                               |   11 +-
 net/bridge/br_vlan_options.c                       |   27 +-
 net/bridge/netfilter/nf_conntrack_bridge.c         |    4 +-
 net/caif/caif_socket.c                             |    4 -
 net/can/gw.c                                       |    7 +
 net/can/isotp.c                                    |    3 +
 net/can/raw.c                                      |   11 +-
 net/ceph/messenger.c                               |    4 +
 net/core/Makefile                                  |    4 +-
 net/core/dev.c                                     |   30 +-
 net/core/dev.h                                     |   20 +
 net/core/dst.c                                     |    8 +-
 net/core/filter.c                                  |  116 +-
 net/core/gro.c                                     |   12 +-
 net/core/neighbour.c                               |   14 +-
 net/core/net-sysfs.c                               |   92 +-
 net/core/net-traces.c                              |    3 +
 net/core/netdev-genl-gen.c                         |   48 +
 net/core/netdev-genl-gen.h                         |   23 +
 net/core/netdev-genl.c                             |  179 +
 net/core/netpoll.c                                 |   12 +-
 net/core/page_pool.c                               |    6 +-
 net/core/rtnetlink.c                               |   35 +-
 net/core/scm.c                                     |    2 +
 net/core/skbuff.c                                  |  237 +-
 net/core/skmsg.c                                   |    5 +
 net/core/sock.c                                    |   56 +-
 net/core/sysctl_net_core.c                         |  111 +-
 net/core/xdp.c                                     |   88 +-
 net/dcb/dcbnl.c                                    |  272 +-
 net/devlink/Makefile                               |    3 +
 net/devlink/core.c                                 |  320 +
 net/devlink/dev.c                                  | 1346 ++++
 net/devlink/devl_internal.h                        |  239 +
 net/devlink/health.c                               | 1333 ++++
 net/{core/devlink.c => devlink/leftover.c}         | 6807 +++++--------------
 net/devlink/netlink.c                              |  251 +
 net/dsa/master.c                                   |    6 +-
 net/dsa/slave.c                                    |   50 +-
 net/dsa/tag_ksz.c                                  |  216 +-
 net/ethtool/Makefile                               |    4 +-
 net/ethtool/channels.c                             |   92 +-
 net/ethtool/coalesce.c                             |  114 +-
 net/ethtool/common.c                               |    8 +
 net/ethtool/common.h                               |    2 +
 net/ethtool/debug.c                                |   71 +-
 net/ethtool/eee.c                                  |   78 +-
 net/ethtool/fec.c                                  |   83 +-
 net/ethtool/linkinfo.c                             |   81 +-
 net/ethtool/linkmodes.c                            |   91 +-
 net/ethtool/mm.c                                   |  251 +
 net/ethtool/module.c                               |   89 +-
 net/ethtool/netlink.c                              |  135 +-
 net/ethtool/netlink.h                              |   74 +-
 net/ethtool/pause.c                                |  125 +-
 net/ethtool/plca.c                                 |  248 +
 net/ethtool/privflags.c                            |   84 +-
 net/ethtool/pse-pd.c                               |   81 +-
 net/ethtool/rings.c                                |  118 +-
 net/ethtool/stats.c                                |  159 +-
 net/ethtool/wol.c                                  |   79 +-
 net/ieee802154/header_ops.c                        |   24 +
 net/ieee802154/nl802154.c                          |  283 +-
 net/ieee802154/nl802154.h                          |    4 +
 net/ieee802154/rdev-ops.h                          |   56 +
 net/ieee802154/trace.h                             |   61 +
 net/ipv4/Makefile                                  |    1 +
 net/ipv4/af_inet.c                                 |   10 +-
 net/ipv4/bpf_tcp_ca.c                              |    3 +-
 net/ipv4/cipso_ipv4.c                              |    2 +-
 net/ipv4/{fou.c => fou_core.c}                     |   47 +-
 net/ipv4/fou_nl.c                                  |   48 +
 net/ipv4/fou_nl.h                                  |   25 +
 net/ipv4/icmp.c                                    |    3 +
 net/ipv4/inet_connection_sock.c                    |   30 +-
 net/ipv4/inet_hashtables.c                         |   14 +-
 net/ipv4/inet_timewait_sock.c                      |    3 -
 net/ipv4/ip_input.c                                |    2 +-
 net/ipv4/ip_output.c                               |    2 +-
 net/ipv4/ip_sockglue.c                             |   18 +
 net/ipv4/netfilter/Kconfig                         |   14 -
 net/ipv4/netfilter/Makefile                        |    1 -
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |  929 ---
 net/ipv4/netfilter/nf_reject_ipv4.c                |    1 +
 net/ipv4/proc.c                                    |    8 +-
 net/ipv4/raw.c                                     |   21 +-
 net/ipv4/tcp_bbr.c                                 |   16 +-
 net/ipv4/tcp_cong.c                                |   10 +-
 net/ipv4/tcp_cubic.c                               |   12 +-
 net/ipv4/tcp_dctcp.c                               |   12 +-
 net/ipv4/tcp_ipv4.c                                |    1 +
 net/ipv4/udp.c                                     |    2 +-
 net/ipv6/af_inet6.c                                |   10 -
 net/ipv6/icmp.c                                    |   49 +-
 net/ipv6/ipv6_sockglue.c                           |   12 -
 net/ipv6/ndisc.c                                   |  168 +-
 net/ipv6/netfilter/nf_reject_ipv6.c                |    1 +
 net/ipv6/proc.c                                    |    1 +
 net/ipv6/raw.c                                     |   16 +-
 net/ipv6/route.c                                   |   23 +-
 net/ipv6/rpl_iptunnel.c                            |    2 +-
 net/ipv6/seg6_local.c                              |  352 +-
 net/ipv6/tcp_ipv6.c                                |    3 +-
 net/kcm/kcmsock.c                                  |    3 +
 net/l2tp/l2tp_ppp.c                                |  125 +-
 net/mac80211/cfg.c                                 |   86 +-
 net/mac80211/chan.c                                |    2 +-
 net/mac80211/debugfs_netdev.c                      |    3 -
 net/mac80211/ieee80211_i.h                         |    6 +-
 net/mac80211/link.c                                |    3 +
 net/mac80211/mlme.c                                |  167 +-
 net/mac80211/rx.c                                  |  416 +-
 net/mac80211/sta_info.c                            |   14 +-
 net/mac80211/sta_info.h                            |   27 +-
 net/mac80211/tx.c                                  |    2 +-
 net/mac80211/util.c                                |   26 +-
 net/mac80211/vht.c                                 |   25 +-
 net/mac802154/Makefile                             |    2 +-
 net/mac802154/cfg.c                                |   60 +-
 net/mac802154/ieee802154_i.h                       |   61 +-
 net/mac802154/iface.c                              |    6 +
 net/mac802154/llsec.c                              |    5 +-
 net/mac802154/main.c                               |   37 +-
 net/mac802154/rx.c                                 |   36 +-
 net/mac802154/scan.c                               |  456 ++
 net/mac802154/tx.c                                 |   42 +-
 net/mptcp/options.c                                |    3 +-
 net/mptcp/pm_netlink.c                             |   63 +-
 net/mptcp/pm_userspace.c                           |    5 +-
 net/mptcp/protocol.c                               |   39 +-
 net/mptcp/protocol.h                               |    2 +-
 net/mptcp/sockopt.c                                |    3 +-
 net/mptcp/subflow.c                                |    3 +
 net/mptcp/token.c                                  |   14 +-
 net/mptcp/token_test.c                             |    3 +
 net/netfilter/Kconfig                              |    3 +
 net/netfilter/Makefile                             |    7 +
 net/netfilter/core.c                               |   16 +
 net/netfilter/ipset/Kconfig                        |    2 +-
 net/netfilter/ipvs/ip_vs_est.c                     |    2 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |    2 +-
 net/netfilter/nf_conntrack_bpf.c                   |   20 +-
 net/netfilter/nf_conntrack_core.c                  |   69 +-
 net/netfilter/nf_conntrack_helper.c                |   98 -
 net/netfilter/nf_conntrack_netlink.c               |    2 +-
 net/netfilter/nf_conntrack_ovs.c                   |  178 +
 net/netfilter/nf_conntrack_proto.c                 |   20 +-
 net/netfilter/nf_conntrack_proto_sctp.c            |   44 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |   44 +-
 net/netfilter/nf_conntrack_proto_udp.c             |   10 +-
 net/netfilter/nf_conntrack_standalone.c            |   12 +-
 net/netfilter/nf_flow_table_core.c                 |    5 +-
 net/netfilter/nf_flow_table_inet.c                 |    2 +-
 net/netfilter/nf_flow_table_offload.c              |   18 +-
 net/netfilter/nf_log_syslog.c                      |    2 +-
 net/netfilter/nf_nat_bpf.c                         |    6 +-
 net/netfilter/nf_tables_api.c                      |  114 +-
 net/netfilter/nf_tables_core.c                     |   35 +-
 net/netfilter/nft_ct.c                             |   39 +-
 net/netfilter/nft_ct_fast.c                        |   56 +
 net/netfilter/nft_objref.c                         |   12 +-
 net/netfilter/xt_length.c                          |    2 +-
 net/netlink/genetlink.c                            |    4 +-
 net/openvswitch/Kconfig                            |    1 +
 net/openvswitch/conntrack.c                        |   85 +-
 net/openvswitch/flow.c                             |   12 +-
 net/openvswitch/flow.h                             |    2 +-
 net/openvswitch/flow_table.c                       |    8 +-
 net/packet/af_packet.c                             |    8 +-
 net/phonet/pep-gprs.c                              |    4 +
 net/qrtr/ns.c                                      |    3 +
 net/rds/ib_recv.c                                  |    1 +
 net/rds/message.c                                  |    2 +-
 net/rds/recv.c                                     |    1 +
 net/rds/tcp_listen.c                               |    2 +
 net/rds/tcp_recv.c                                 |    2 +
 net/rfkill/core.c                                  |   16 +-
 net/rfkill/rfkill-gpio.c                           |   20 +-
 net/rxrpc/Kconfig                                  |    9 +
 net/rxrpc/af_rxrpc.c                               |    2 +-
 net/rxrpc/ar-internal.h                            |   15 +-
 net/rxrpc/call_accept.c                            |    2 +-
 net/rxrpc/call_event.c                             |   15 +-
 net/rxrpc/call_object.c                            |   13 +-
 net/rxrpc/conn_event.c                             |    2 +-
 net/rxrpc/conn_service.c                           |    7 -
 net/rxrpc/input.c                                  |   62 +-
 net/rxrpc/io_thread.c                              |   48 +-
 net/rxrpc/local_object.c                           |    7 +-
 net/rxrpc/misc.c                                   |    7 +
 net/rxrpc/output.c                                 |   79 +-
 net/rxrpc/proc.c                                   |    4 +-
 net/rxrpc/recvmsg.c                                |   36 +-
 net/rxrpc/skbuff.c                                 |    4 +-
 net/rxrpc/sysctl.c                                 |   17 +-
 net/rxrpc/txbuf.c                                  |   12 +-
 net/sched/Kconfig                                  |   91 +-
 net/sched/Makefile                                 |    7 +-
 net/sched/act_api.c                                |   57 +-
 net/sched/act_connmark.c                           |  107 +-
 net/sched/act_ct.c                                 |  141 +-
 net/sched/act_gate.c                               |   30 +-
 net/sched/act_mirred.c                             |   23 +-
 net/sched/act_nat.c                                |   72 +-
 net/sched/act_pedit.c                              |  300 +-
 net/sched/cls_api.c                                |  304 +-
 net/sched/cls_flower.c                             |   80 +-
 net/sched/cls_matchall.c                           |    6 +-
 net/sched/cls_rsvp.c                               |   26 -
 net/sched/cls_rsvp.h                               |  764 ---
 net/sched/cls_rsvp6.c                              |   26 -
 net/sched/cls_tcindex.c                            |  742 ---
 net/sched/sch_api.c                                |   87 +-
 net/sched/sch_atm.c                                |  706 --
 net/sched/sch_cake.c                               |    2 +-
 net/sched/sch_cbq.c                                | 1727 -----
 net/sched/sch_dsmark.c                             |  518 --
 net/sched/sch_mqprio.c                             |  291 +-
 net/sched/sch_mqprio_lib.c                         |  117 +
 net/sched/sch_mqprio_lib.h                         |   18 +
 net/sched/sch_taprio.c                             |  745 ++-
 net/sctp/ipv6.c                                    |    2 -
 net/sctp/protocol.c                                |    2 -
 net/sctp/socket.c                                  |    5 +-
 net/smc/af_smc.c                                   |   40 +-
 net/smc/smc_clc.c                                  |   11 +-
 net/smc/smc_core.c                                 |  105 +-
 net/smc/smc_core.h                                 |    6 +-
 net/smc/smc_diag.c                                 |    3 +-
 net/smc/smc_ism.c                                  |  180 +-
 net/smc/smc_ism.h                                  |    3 +-
 net/smc/smc_llc.c                                  |   34 +-
 net/smc/smc_pnet.c                                 |   40 +-
 net/smc/smc_rx.c                                   |    4 +
 net/socket.c                                       |   33 +-
 net/sunrpc/svcsock.c                               |    5 +
 net/sunrpc/xprtsock.c                              |    3 +
 net/tipc/netlink_compat.c                          |   16 +-
 net/tipc/socket.c                                  |    3 +
 net/tipc/topsrv.c                                  |    5 +
 net/tls/tls_sw.c                                   |    3 +
 net/unix/af_unix.c                                 |   21 +-
 net/vmw_vsock/af_vsock.c                           |    3 +-
 net/vmw_vsock/virtio_transport.c                   |  149 +-
 net/vmw_vsock/virtio_transport_common.c            |  422 +-
 net/vmw_vsock/vsock_loopback.c                     |   51 +-
 net/wireless/ap.c                                  |    2 +-
 net/wireless/chan.c                                |   69 +
 net/wireless/core.h                                |    4 +-
 net/wireless/ibss.c                                |    5 +-
 net/wireless/mlme.c                                |    5 +-
 net/wireless/nl80211.c                             |  162 +-
 net/wireless/nl80211.h                             |    2 +-
 net/wireless/reg.c                                 |   57 +-
 net/wireless/sme.c                                 |   54 +-
 net/wireless/trace.h                               |  309 +-
 net/wireless/util.c                                |  185 +-
 net/wireless/wext-compat.c                         |    2 +-
 net/wireless/wext-core.c                           |   20 +-
 net/wireless/wext-sme.c                            |    2 +-
 net/xdp/xsk.c                                      |   73 +-
 net/xdp/xsk_buff_pool.c                            |    7 +-
 net/xdp/xsk_queue.c                                |   11 +-
 net/xdp/xsk_queue.h                                |    1 +
 net/xfrm/espintcp.c                                |    3 +
 net/xfrm/xfrm_device.c                             |    8 +-
 net/xfrm/xfrm_interface_bpf.c                      |    7 +-
 net/xfrm/xfrm_state.c                              |    2 +-
 samples/bpf/Makefile                               |   24 +-
 samples/bpf/gnu/stubs.h                            |    1 +
 .../{lwt_len_hist_kern.c => lwt_len_hist.bpf.c}    |   29 +-
 samples/bpf/lwt_len_hist.sh                        |    4 +-
 .../{map_perf_test_kern.c => map_perf_test.bpf.c}  |   48 +-
 samples/bpf/map_perf_test_user.c                   |    2 +-
 samples/bpf/net_shared.h                           |   32 +
 .../bpf/{sock_flags_kern.c => sock_flags.bpf.c}    |   24 +-
 samples/bpf/syscall_tp_kern.c                      |   14 +
 samples/bpf/tc_l2_redirect.sh                      |    3 +
 samples/bpf/test_cgrp2_sock.sh                     |   16 +-
 samples/bpf/test_cgrp2_sock2.sh                    |    9 +-
 .../{test_cgrp2_tc_kern.c => test_cgrp2_tc.bpf.c}  |   34 +-
 samples/bpf/test_cgrp2_tc.sh                       |    8 +-
 ...kern.c => test_current_task_under_cgroup.bpf.c} |   11 +-
 samples/bpf/test_current_task_under_cgroup_user.c  |    8 +-
 samples/bpf/test_lru_dist.c                        |    5 -
 samples/bpf/test_lwt_bpf.c                         |   50 +-
 samples/bpf/test_lwt_bpf.sh                        |   19 +-
 ...est_map_in_map_kern.c => test_map_in_map.bpf.c} |    8 +-
 samples/bpf/test_map_in_map_user.c                 |    4 +-
 ...ad_kprobe_kern.c => test_overhead_kprobe.bpf.c} |    6 +-
 ...ad_raw_tp_kern.c => test_overhead_raw_tp.bpf.c} |    4 +-
 ...t_overhead_tp_kern.c => test_overhead_tp.bpf.c} |   29 +-
 samples/bpf/test_overhead_user.c                   |   34 +-
 ...ite_user_kern.c => test_probe_write_user.bpf.c} |   20 +-
 samples/bpf/test_probe_write_user_user.c           |    2 +-
 samples/bpf/trace_common.h                         |   13 -
 .../{trace_output_kern.c => trace_output.bpf.c}    |    6 +-
 samples/bpf/trace_output_user.c                    |    2 +-
 samples/bpf/{tracex2_kern.c => tracex2.bpf.c}      |   13 +-
 samples/bpf/tracex2_user.c                         |    2 +-
 samples/bpf/tracex4_user.c                         |    4 +-
 samples/bpf/xdp1_user.c                            |    2 +-
 samples/bpf/xdp_adjust_tail_user.c                 |    2 +-
 samples/bpf/xdp_fwd_user.c                         |    4 +-
 samples/bpf/xdp_redirect_cpu_user.c                |    4 +-
 samples/bpf/xdp_rxq_info_user.c                    |    2 +-
 samples/bpf/xdp_sample.bpf.h                       |   22 +-
 samples/bpf/xdp_sample_pkts_user.c                 |    2 +-
 samples/bpf/xdp_tx_iptunnel_user.c                 |    2 +-
 scripts/bpf_doc.py                                 |    2 +-
 scripts/pahole-flags.sh                            |    4 +
 tools/bpf/bpftool/Makefile                         |    8 +-
 tools/bpf/bpftool/btf.c                            |   13 +-
 tools/bpf/bpftool/btf_dumper.c                     |    4 +-
 tools/bpf/bpftool/cgroup.c                         |    4 +-
 tools/bpf/bpftool/common.c                         |   13 +-
 tools/bpf/bpftool/feature.c                        |    8 +-
 tools/bpf/bpftool/link.c                           |    4 +-
 tools/bpf/bpftool/main.h                           |    3 +-
 tools/bpf/bpftool/map.c                            |    8 +-
 tools/bpf/bpftool/prog.c                           |   60 +-
 tools/bpf/bpftool/struct_ops.c                     |    6 +-
 tools/bpf/resolve_btfids/Build                     |    4 +-
 tools/bpf/resolve_btfids/Makefile                  |   47 +-
 tools/bpf/resolve_btfids/main.c                    |    2 +-
 tools/bpf/runqslower/Makefile                      |    2 +
 tools/include/uapi/asm/bpf_perf_event.h            |    2 +
 tools/include/uapi/linux/bpf.h                     |   35 +-
 tools/include/uapi/linux/netdev.h                  |   59 +
 tools/lib/bpf/bpf.c                                |   20 +
 tools/lib/bpf/bpf.h                                |    9 +
 tools/lib/bpf/bpf_core_read.h                      |    4 +-
 tools/lib/bpf/bpf_helpers.h                        |    2 +-
 tools/lib/bpf/bpf_tracing.h                        |  320 +-
 tools/lib/bpf/btf.c                                |   24 +-
 tools/lib/bpf/btf_dump.c                           |  199 +-
 tools/lib/bpf/libbpf.c                             |   72 +-
 tools/lib/bpf/libbpf.h                             |  126 +-
 tools/lib/bpf/libbpf.map                           |    8 +
 tools/lib/bpf/libbpf_errno.c                       |   16 +-
 tools/lib/bpf/libbpf_internal.h                    |    5 +-
 tools/lib/bpf/libbpf_probes.c                      |   83 +
 tools/lib/bpf/libbpf_version.h                     |    2 +-
 tools/lib/bpf/netlink.c                            |  120 +-
 tools/lib/bpf/nlattr.c                             |    2 +-
 tools/lib/bpf/nlattr.h                             |   12 +
 tools/lib/bpf/ringbuf.c                            |    4 +-
 tools/lib/bpf/usdt.bpf.h                           |    5 +-
 tools/net/ynl/cli.py                               |   52 +
 tools/net/ynl/lib/__init__.py                      |    7 +
 tools/net/ynl/lib/nlspec.py                        |  310 +
 tools/net/ynl/lib/ynl.py                           |  528 ++
 tools/net/ynl/ynl-gen-c.py                         | 2357 +++++++
 tools/net/ynl/ynl-regen.sh                         |   30 +
 tools/testing/selftests/bpf/.gitignore             |    2 +
 tools/testing/selftests/bpf/DENYLIST.s390x         |   67 +-
 tools/testing/selftests/bpf/Makefile               |   87 +-
 tools/testing/selftests/bpf/bench.c                |   59 +-
 tools/testing/selftests/bpf/bench.h                |    2 +
 .../selftests/bpf/benchs/bench_bloom_filter_map.c  |    5 +
 .../bpf/benchs/bench_bpf_hashmap_full_update.c     |    5 +-
 .../bpf/benchs/bench_bpf_hashmap_lookup.c          |  283 +
 .../testing/selftests/bpf/benchs/bench_bpf_loop.c  |    1 +
 .../selftests/bpf/benchs/bench_local_storage.c     |    3 +
 .../benchs/bench_local_storage_rcu_tasks_trace.c   |   16 +-
 .../testing/selftests/bpf/benchs/bench_ringbufs.c  |    4 +
 tools/testing/selftests/bpf/benchs/bench_strncmp.c |    2 +
 .../benchs/run_bench_bpf_hashmap_full_update.sh    |    2 +-
 .../run_bench_local_storage_rcu_tasks_trace.sh     |    2 +-
 tools/testing/selftests/bpf/bpf_experimental.h     |   24 +
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        |    2 +-
 .../selftests/bpf/map_tests/map_in_map_batch_ops.c |    2 +-
 tools/testing/selftests/bpf/netcnt_common.h        |    6 +-
 .../selftests/bpf/prog_tests/attach_probe.c        |   10 +-
 .../testing/selftests/bpf/prog_tests/bpf_cookie.c  |    6 +-
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |    8 +-
 .../testing/selftests/bpf/prog_tests/bpf_obj_id.c  |   20 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       |   24 +-
 .../selftests/bpf/prog_tests/btf_map_in_map.c      |    2 +-
 .../testing/selftests/bpf/prog_tests/cgrp_kfunc.c  |   69 +-
 .../selftests/bpf/prog_tests/cgrp_local_storage.c  |    2 +-
 tools/testing/selftests/bpf/prog_tests/check_mtu.c |    2 +-
 tools/testing/selftests/bpf/prog_tests/cpumask.c   |   74 +
 .../selftests/bpf/prog_tests/decap_sanity.c        |    2 +-
 .../selftests/bpf/prog_tests/dummy_st_ops.c        |   52 +-
 tools/testing/selftests/bpf/prog_tests/dynptr.c    |   18 +-
 .../selftests/bpf/prog_tests/enable_stats.c        |    2 +-
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |   14 +-
 .../selftests/bpf/prog_tests/fexit_stress.c        |   22 +-
 .../testing/selftests/bpf/prog_tests/fib_lookup.c  |  187 +
 .../bpf/prog_tests/flow_dissector_reattach.c       |   10 +-
 .../testing/selftests/bpf/prog_tests/htab_reuse.c  |  101 +
 .../selftests/bpf/prog_tests/jit_probe_mem.c       |   28 +
 tools/testing/selftests/bpf/prog_tests/kfree_skb.c |    2 +-
 .../testing/selftests/bpf/prog_tests/kfunc_call.c  |    2 +
 .../selftests/bpf/prog_tests/kfunc_dynptr_param.c  |   72 +-
 .../selftests/bpf/prog_tests/kprobe_multi_test.c   |   19 +-
 .../bpf/prog_tests/libbpf_get_fd_by_id_opts.c      |    4 +-
 .../testing/selftests/bpf/prog_tests/linked_list.c |   51 +-
 .../testing/selftests/bpf/prog_tests/lsm_cgroup.c  |    3 +-
 tools/testing/selftests/bpf/prog_tests/metadata.c  |    8 +-
 .../selftests/bpf/prog_tests/migrate_reuseport.c   |    2 +-
 tools/testing/selftests/bpf/prog_tests/mmap.c      |    2 +-
 .../selftests/bpf/prog_tests/nested_trust.c        |   12 +
 tools/testing/selftests/bpf/prog_tests/perf_link.c |    2 +-
 tools/testing/selftests/bpf/prog_tests/pinning.c   |    2 +-
 .../selftests/bpf/prog_tests/prog_run_opts.c       |    2 +-
 tools/testing/selftests/bpf/prog_tests/rbtree.c    |  117 +
 tools/testing/selftests/bpf/prog_tests/recursion.c |    4 +-
 .../selftests/bpf/prog_tests/setget_sockopt.c      |   73 +
 tools/testing/selftests/bpf/prog_tests/sk_assign.c |   25 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c       |    6 +-
 .../testing/selftests/bpf/prog_tests/task_kfunc.c  |   71 +-
 .../selftests/bpf/prog_tests/task_local_storage.c  |    8 +-
 tools/testing/selftests/bpf/prog_tests/tc_bpf.c    |    4 +-
 .../bpf/prog_tests/test_bpf_syscall_macro.c        |   17 +
 .../selftests/bpf/prog_tests/test_global_funcs.c   |  133 +-
 tools/testing/selftests/bpf/prog_tests/test_lsm.c  |    3 +-
 .../selftests/bpf/prog_tests/tp_attach_query.c     |    5 +-
 .../selftests/bpf/prog_tests/trampoline_count.c    |   18 +-
 .../selftests/bpf/prog_tests/unpriv_bpf_disabled.c |    8 +-
 .../selftests/bpf/prog_tests/uprobe_autoattach.c   |   47 +-
 tools/testing/selftests/bpf/prog_tests/usdt.c      |    1 +
 .../selftests/bpf/prog_tests/user_ringbuf.c        |   62 +-
 .../testing/selftests/bpf/prog_tests/verif_stats.c |    5 +-
 .../selftests/bpf/prog_tests/verify_pkcs7_sig.c    |    3 +
 .../selftests/bpf/prog_tests/xdp_adjust_tail.c     |    7 +-
 .../testing/selftests/bpf/prog_tests/xdp_attach.c  |    4 +-
 .../selftests/bpf/prog_tests/xdp_cpumap_attach.c   |    8 +-
 .../selftests/bpf/prog_tests/xdp_devmap_attach.c   |    8 +-
 .../selftests/bpf/prog_tests/xdp_do_redirect.c     |   31 +-
 tools/testing/selftests/bpf/prog_tests/xdp_info.c  |   10 +-
 tools/testing/selftests/bpf/prog_tests/xdp_link.c  |   10 +-
 .../selftests/bpf/prog_tests/xdp_metadata.c        |  409 ++
 .../selftests/bpf/progs/bpf_hashmap_lookup.c       |   63 +
 tools/testing/selftests/bpf/progs/bpf_misc.h       |   32 +
 .../selftests/bpf/progs/bpf_syscall_macro.c        |   26 +
 .../bpf/progs/btf_dump_test_case_bitfields.c       |    2 +-
 .../bpf/progs/btf_dump_test_case_packing.c         |   80 +-
 .../bpf/progs/btf_dump_test_case_padding.c         |  162 +-
 .../bpf/progs/btf_dump_test_case_syntax.c          |   38 +-
 .../selftests/bpf/progs/cgrp_kfunc_failure.c       |   17 +-
 tools/testing/selftests/bpf/progs/cpumask_common.h |  114 +
 .../testing/selftests/bpf/progs/cpumask_failure.c  |  126 +
 .../testing/selftests/bpf/progs/cpumask_success.c  |  426 ++
 .../selftests/bpf/progs/dummy_st_ops_fail.c        |   27 +
 .../{dummy_st_ops.c => dummy_st_ops_success.c}     |   19 +-
 tools/testing/selftests/bpf/progs/dynptr_fail.c    |  455 +-
 tools/testing/selftests/bpf/progs/fib_lookup.c     |   22 +
 tools/testing/selftests/bpf/progs/htab_reuse.c     |   19 +
 tools/testing/selftests/bpf/progs/jit_probe_mem.c  |   61 +
 .../testing/selftests/bpf/progs/kfunc_call_test.c  |   29 +
 tools/testing/selftests/bpf/progs/linked_list.c    |    2 +-
 .../testing/selftests/bpf/progs/linked_list_fail.c |  100 +-
 tools/testing/selftests/bpf/progs/lsm.c            |    7 +-
 tools/testing/selftests/bpf/progs/map_kptr.c       |   12 +-
 .../selftests/bpf/progs/nested_trust_common.h      |   12 +
 .../selftests/bpf/progs/nested_trust_failure.c     |   33 +
 .../selftests/bpf/progs/nested_trust_success.c     |   19 +
 tools/testing/selftests/bpf/progs/profiler.inc.h   |   62 +-
 tools/testing/selftests/bpf/progs/rbtree.c         |  176 +
 .../bpf/progs/rbtree_btf_fail__add_wrong_type.c    |   52 +
 .../bpf/progs/rbtree_btf_fail__wrong_node_type.c   |   49 +
 tools/testing/selftests/bpf/progs/rbtree_fail.c    |  322 +
 tools/testing/selftests/bpf/progs/setget_sockopt.c |    8 +
 tools/testing/selftests/bpf/progs/strobemeta.h     |    2 +-
 .../selftests/bpf/progs/task_kfunc_failure.c       |   18 +
 .../selftests/bpf/progs/test_attach_probe.c        |   11 +-
 tools/testing/selftests/bpf/progs/test_bpf_nf.c    |   11 +-
 .../selftests/bpf/progs/test_cls_redirect.c        |    6 +-
 .../selftests/bpf/progs/test_global_func1.c        |    6 +-
 .../selftests/bpf/progs/test_global_func10.c       |    4 +-
 .../selftests/bpf/progs/test_global_func11.c       |    4 +-
 .../selftests/bpf/progs/test_global_func12.c       |    4 +-
 .../selftests/bpf/progs/test_global_func13.c       |    4 +-
 .../selftests/bpf/progs/test_global_func14.c       |    4 +-
 .../selftests/bpf/progs/test_global_func15.c       |    4 +-
 .../selftests/bpf/progs/test_global_func16.c       |    4 +-
 .../selftests/bpf/progs/test_global_func17.c       |    4 +-
 .../selftests/bpf/progs/test_global_func2.c        |   43 +-
 .../selftests/bpf/progs/test_global_func3.c        |   10 +-
 .../selftests/bpf/progs/test_global_func4.c        |   55 +-
 .../selftests/bpf/progs/test_global_func5.c        |    4 +-
 .../selftests/bpf/progs/test_global_func6.c        |    4 +-
 .../selftests/bpf/progs/test_global_func7.c        |    4 +-
 .../selftests/bpf/progs/test_global_func8.c        |    4 +-
 .../selftests/bpf/progs/test_global_func9.c        |    4 +-
 .../bpf/progs/test_global_func_ctx_args.c          |  104 +
 .../selftests/bpf/progs/test_kfunc_dynptr_param.c  |    4 +
 tools/testing/selftests/bpf/progs/test_sk_assign.c |   11 +
 .../selftests/bpf/progs/test_sk_assign_libbpf.c    |    3 +
 tools/testing/selftests/bpf/progs/test_subprogs.c  |    2 +-
 tools/testing/selftests/bpf/progs/test_tc_tunnel.c |   91 +-
 .../testing/selftests/bpf/progs/test_tunnel_kern.c |   21 +
 .../selftests/bpf/progs/test_uprobe_autoattach.c   |   64 +-
 .../selftests/bpf/progs/test_verify_pkcs7_sig.c    |   12 +-
 tools/testing/selftests/bpf/progs/test_vmlinux.c   |    4 +-
 .../bpf/progs/test_xdp_adjust_tail_grow.c          |    8 +-
 tools/testing/selftests/bpf/progs/test_xdp_vlan.c  |    4 +-
 .../selftests/bpf/progs/user_ringbuf_fail.c        |   31 +-
 tools/testing/selftests/bpf/progs/xdp_features.c   |  269 +
 .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |   85 +
 tools/testing/selftests/bpf/progs/xdp_metadata.c   |   64 +
 tools/testing/selftests/bpf/progs/xdp_metadata2.c  |   23 +
 .../selftests/bpf/progs/xdp_synproxy_kern.c        |    2 +-
 tools/testing/selftests/bpf/progs/xsk_xdp_progs.c  |   30 +
 tools/testing/selftests/bpf/test_cpp.cpp           |    2 +-
 tools/testing/selftests/bpf/test_maps.c            |    2 +-
 tools/testing/selftests/bpf/test_offload.py        |   10 +-
 tools/testing/selftests/bpf/test_progs.c           |   42 +-
 tools/testing/selftests/bpf/test_progs.h           |    2 +
 .../selftests/bpf/test_skb_cgroup_id_user.c        |    2 +-
 tools/testing/selftests/bpf/test_tc_tunnel.sh      |   15 +-
 .../selftests/bpf/test_tcp_check_syncookie_user.c  |    2 +-
 tools/testing/selftests/bpf/test_tunnel.sh         |   40 +-
 tools/testing/selftests/bpf/test_verifier.c        |   12 +-
 tools/testing/selftests/bpf/test_xdp_features.sh   |  107 +
 tools/testing/selftests/bpf/test_xsk.sh            |   42 +-
 tools/testing/selftests/bpf/testing_helpers.c      |    2 +-
 .../bpf/verifier/bounds_mix_sign_unsign.c          |  110 +-
 tools/testing/selftests/bpf/verifier/bpf_st_mem.c  |   67 +
 tools/testing/selftests/bpf/verifier/sleepable.c   |   91 +
 tools/testing/selftests/bpf/veristat.c             |    4 +-
 tools/testing/selftests/bpf/vmtest.sh              |    2 +-
 tools/testing/selftests/bpf/xdp_features.c         |  699 ++
 tools/testing/selftests/bpf/xdp_features.h         |   20 +
 tools/testing/selftests/bpf/xdp_hw_metadata.c      |  445 ++
 tools/testing/selftests/bpf/xdp_metadata.h         |   15 +
 tools/testing/selftests/bpf/xdp_synproxy.c         |   16 +-
 tools/testing/selftests/bpf/xsk.c                  |  677 +-
 tools/testing/selftests/bpf/xsk.h                  |   97 +-
 tools/testing/selftests/bpf/xsk_prereqs.sh         |   12 +-
 tools/testing/selftests/bpf/xskxceiver.c           |  382 +-
 tools/testing/selftests/bpf/xskxceiver.h           |   17 +-
 .../selftests/drivers/net/mlxsw/qos_defprio.sh     |   68 +-
 .../selftests/drivers/net/mlxsw/qos_dscp_bridge.sh |   23 +-
 .../selftests/drivers/net/mlxsw/qos_dscp_router.sh |   27 +-
 .../selftests/drivers/net/netdevsim/devlink.sh     |   18 +
 tools/testing/selftests/net/Makefile               |   54 +-
 tools/testing/selftests/net/bpf/Makefile           |   51 -
 tools/testing/selftests/net/config                 |    3 +
 tools/testing/selftests/net/fib_tests.sh           |    2 +
 tools/testing/selftests/net/forwarding/Makefile    |    1 +
 .../testing/selftests/net/forwarding/bridge_mdb.sh |  159 +-
 .../selftests/net/forwarding/bridge_mdb_max.sh     | 1336 ++++
 tools/testing/selftests/net/forwarding/lib.sh      |  237 +-
 .../testing/selftests/net/forwarding/tc_actions.sh |   53 +-
 tools/testing/selftests/net/ip_local_port_range.c  |  447 ++
 tools/testing/selftests/net/ip_local_port_range.sh |    5 +
 tools/testing/selftests/net/mptcp/diag.sh          |   56 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |    4 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   53 +-
 tools/testing/selftests/net/mptcp/userspace_pm.sh  |  153 +-
 tools/testing/selftests/net/{bpf => }/nat6to4.c    |    0
 tools/testing/selftests/net/rps_default_mask.sh    |   74 +
 .../testing/selftests/net/srv6_end_flavors_test.sh |  869 +++
 tools/testing/selftests/net/tcp_mmap.c             |    3 +-
 tools/testing/selftests/net/udpgro_frglist.sh      |    8 +-
 tools/testing/selftests/net/udpgso_bench_rx.c      |    6 +-
 .../tc-testing/tc-tests/filters/rsvp.json          |  203 -
 .../tc-testing/tc-tests/filters/tcindex.json       |  227 -
 .../selftests/tc-testing/tc-tests/qdiscs/atm.json  |   94 -
 .../selftests/tc-testing/tc-tests/qdiscs/cbq.json  |  184 -
 .../tc-testing/tc-tests/qdiscs/dsmark.json         |  140 -
 tools/testing/vsock/Makefile                       |    3 +-
 tools/testing/vsock/README                         |   34 +
 tools/testing/vsock/control.c                      |   28 +
 tools/testing/vsock/control.h                      |    2 +
 tools/testing/vsock/util.c                         |   13 +
 tools/testing/vsock/util.h                         |    1 +
 tools/testing/vsock/vsock_perf.c                   |  427 ++
 tools/testing/vsock/vsock_test.c                   |  197 +-
 1823 files changed, 158044 insertions(+), 45179 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-net-peak_usb
 create mode 100644 Documentation/bpf/cpumasks.rst
 create mode 100644 Documentation/bpf/graph_ds_impl.rst
 create mode 100644 Documentation/bpf/map_sockmap.rst
 create mode 100644 Documentation/core-api/netlink.rst
 create mode 100644 Documentation/devicetree/bindings/net/amlogic,g12a-mdio-mux.yaml
 create mode 100644 Documentation/devicetree/bindings/net/amlogic,gxl-mdio-mux.yaml
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch.yaml
 create mode 100644 Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/mdio-mux-meson-g12a.txt
 create mode 100644 Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
 create mode 100644 Documentation/devicetree/bindings/net/rfkill-gpio.yaml
 create mode 100644 Documentation/netlink/genetlink-c.yaml
 create mode 100644 Documentation/netlink/genetlink-legacy.yaml
 create mode 100644 Documentation/netlink/genetlink.yaml
 create mode 100644 Documentation/netlink/specs/ethtool.yaml
 create mode 100644 Documentation/netlink/specs/fou.yaml
 create mode 100644 Documentation/netlink/specs/netdev.yaml
 delete mode 100644 Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
 create mode 100644 Documentation/networking/device_drivers/ethernet/mellanox/mlx5/counters.rst
 create mode 100644 Documentation/networking/device_drivers/ethernet/mellanox/mlx5/devlink.rst
 create mode 100644 Documentation/networking/device_drivers/ethernet/mellanox/mlx5/index.rst
 create mode 100644 Documentation/networking/device_drivers/ethernet/mellanox/mlx5/kconfig.rst
 create mode 100644 Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst
 create mode 100644 Documentation/networking/device_drivers/ethernet/mellanox/mlx5/tracepoints.rst
 create mode 100644 Documentation/networking/devlink/sfc.rst
 create mode 100644 Documentation/networking/xdp-rx-metadata.rst
 create mode 100644 Documentation/userspace-api/netlink/c-code-gen.rst
 create mode 100644 Documentation/userspace-api/netlink/genetlink-legacy.rst
 create mode 100644 Documentation/userspace-api/netlink/intro-specs.rst
 create mode 100644 Documentation/userspace-api/netlink/specs.rst
 create mode 100644 drivers/net/dsa/microchip/ksz_ptp.c
 create mode 100644 drivers/net/dsa/microchip/ksz_ptp.h
 create mode 100644 drivers/net/dsa/microchip/ksz_ptp_reg.h
 create mode 100644 drivers/net/dsa/mv88e6xxx/switchdev.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/switchdev.h
 create mode 100644 drivers/net/dsa/ocelot/ocelot_ext.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_xdp.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_ddp.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_ddp.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act_stats.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.h
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio_bf2.h
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio_bf3.h
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_vcap_debugfs.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_police.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_pool.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_sdlb.c
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_tc.c
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_tc.h
 create mode 100644 drivers/net/ethernet/mscc/ocelot_mm.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfdk/ipsec.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nic/dcb.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nic/main.h
 create mode 100644 drivers/net/ethernet/sfc/efx_devlink.c
 create mode 100644 drivers/net/ethernet/sfc/efx_devlink.h
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_ethtool.c
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_ethtool.h
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_lib.c
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_lib.h
 delete mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe.h
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.c
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_ethtool.h
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.c
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_mdio.h
 delete mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe.h
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.h
 create mode 100644 drivers/net/ipa/gsi_reg.c
 create mode 100644 drivers/net/ipa/reg.h
 create mode 100644 drivers/net/ipa/reg/gsi_reg-v3.1.c
 create mode 100644 drivers/net/ipa/reg/gsi_reg-v3.5.1.c
 create mode 100644 drivers/net/ipa/reg/gsi_reg-v4.0.c
 create mode 100644 drivers/net/ipa/reg/gsi_reg-v4.11.c
 create mode 100644 drivers/net/ipa/reg/gsi_reg-v4.5.c
 create mode 100644 drivers/net/ipa/reg/gsi_reg-v4.9.c
 create mode 100644 drivers/net/mdio/mdio-mux-meson-gxl.c
 create mode 100644 drivers/net/phy/mdio-open-alliance.h
 create mode 100644 drivers/net/phy/ncn26000.c
 create mode 100644 drivers/net/thunderbolt/Kconfig
 create mode 100644 drivers/net/thunderbolt/Makefile
 rename drivers/net/{thunderbolt.c => thunderbolt/main.c} (96%)
 create mode 100644 drivers/net/thunderbolt/trace.c
 create mode 100644 drivers/net/thunderbolt/trace.h
 create mode 100644 drivers/net/wireless/ath/ath12k/Kconfig
 create mode 100644 drivers/net/wireless/ath/ath12k/Makefile
 create mode 100644 drivers/net/wireless/ath/ath12k/ce.c
 create mode 100644 drivers/net/wireless/ath/ath12k/ce.h
 create mode 100644 drivers/net/wireless/ath/ath12k/core.c
 create mode 100644 drivers/net/wireless/ath/ath12k/core.h
 create mode 100644 drivers/net/wireless/ath/ath12k/dbring.c
 create mode 100644 drivers/net/wireless/ath/ath12k/dbring.h
 create mode 100644 drivers/net/wireless/ath/ath12k/debug.c
 create mode 100644 drivers/net/wireless/ath/ath12k/debug.h
 create mode 100644 drivers/net/wireless/ath/ath12k/dp.c
 create mode 100644 drivers/net/wireless/ath/ath12k/dp.h
 create mode 100644 drivers/net/wireless/ath/ath12k/dp_mon.c
 create mode 100644 drivers/net/wireless/ath/ath12k/dp_mon.h
 create mode 100644 drivers/net/wireless/ath/ath12k/dp_rx.c
 create mode 100644 drivers/net/wireless/ath/ath12k/dp_rx.h
 create mode 100644 drivers/net/wireless/ath/ath12k/dp_tx.c
 create mode 100644 drivers/net/wireless/ath/ath12k/dp_tx.h
 create mode 100644 drivers/net/wireless/ath/ath12k/hal.c
 create mode 100644 drivers/net/wireless/ath/ath12k/hal.h
 create mode 100644 drivers/net/wireless/ath/ath12k/hal_desc.h
 create mode 100644 drivers/net/wireless/ath/ath12k/hal_rx.c
 create mode 100644 drivers/net/wireless/ath/ath12k/hal_rx.h
 create mode 100644 drivers/net/wireless/ath/ath12k/hal_tx.c
 create mode 100644 drivers/net/wireless/ath/ath12k/hal_tx.h
 create mode 100644 drivers/net/wireless/ath/ath12k/hif.h
 create mode 100644 drivers/net/wireless/ath/ath12k/htc.c
 create mode 100644 drivers/net/wireless/ath/ath12k/htc.h
 create mode 100644 drivers/net/wireless/ath/ath12k/hw.c
 create mode 100644 drivers/net/wireless/ath/ath12k/hw.h
 create mode 100644 drivers/net/wireless/ath/ath12k/mac.c
 create mode 100644 drivers/net/wireless/ath/ath12k/mac.h
 create mode 100644 drivers/net/wireless/ath/ath12k/mhi.c
 create mode 100644 drivers/net/wireless/ath/ath12k/mhi.h
 create mode 100644 drivers/net/wireless/ath/ath12k/pci.c
 create mode 100644 drivers/net/wireless/ath/ath12k/pci.h
 create mode 100644 drivers/net/wireless/ath/ath12k/peer.c
 create mode 100644 drivers/net/wireless/ath/ath12k/peer.h
 create mode 100644 drivers/net/wireless/ath/ath12k/qmi.c
 create mode 100644 drivers/net/wireless/ath/ath12k/qmi.h
 create mode 100644 drivers/net/wireless/ath/ath12k/reg.c
 create mode 100644 drivers/net/wireless/ath/ath12k/reg.h
 create mode 100644 drivers/net/wireless/ath/ath12k/rx_desc.h
 create mode 100644 drivers/net/wireless/ath/ath12k/trace.c
 create mode 100644 drivers/net/wireless/ath/ath12k/trace.h
 create mode 100644 drivers/net/wireless/ath/ath12k/wmi.c
 create mode 100644 drivers/net/wireless/ath/ath12k/wmi.h
 create mode 100644 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188e.c
 create mode 100644 include/linux/dsa/ksz_common.h
 create mode 100644 include/linux/ism.h
 delete mode 100644 include/linux/spi/at86rf230.h
 delete mode 100644 include/linux/spi/cc2520.h
 create mode 100644 include/uapi/linux/netdev.h
 create mode 100644 kernel/bpf/cpumask.c
 create mode 100644 kernel/bpf/preload/iterators/iterators.lskel-big-endian.h
 rename kernel/bpf/preload/iterators/{iterators.lskel.h => iterators.lskel-little-endian.h} (100%)
 create mode 100644 net/core/netdev-genl-gen.c
 create mode 100644 net/core/netdev-genl-gen.h
 create mode 100644 net/core/netdev-genl.c
 create mode 100644 net/devlink/Makefile
 create mode 100644 net/devlink/core.c
 create mode 100644 net/devlink/dev.c
 create mode 100644 net/devlink/devl_internal.h
 create mode 100644 net/devlink/health.c
 rename net/{core/devlink.c => devlink/leftover.c} (68%)
 create mode 100644 net/devlink/netlink.c
 create mode 100644 net/ethtool/mm.c
 create mode 100644 net/ethtool/plca.c
 rename net/ipv4/{fou.c => fou_core.c} (94%)
 create mode 100644 net/ipv4/fou_nl.c
 create mode 100644 net/ipv4/fou_nl.h
 delete mode 100644 net/ipv4/netfilter/ipt_CLUSTERIP.c
 create mode 100644 net/mac802154/scan.c
 create mode 100644 net/netfilter/nf_conntrack_ovs.c
 create mode 100644 net/netfilter/nft_ct_fast.c
 delete mode 100644 net/sched/cls_rsvp.c
 delete mode 100644 net/sched/cls_rsvp.h
 delete mode 100644 net/sched/cls_rsvp6.c
 delete mode 100644 net/sched/cls_tcindex.c
 delete mode 100644 net/sched/sch_atm.c
 delete mode 100644 net/sched/sch_cbq.c
 delete mode 100644 net/sched/sch_dsmark.c
 create mode 100644 net/sched/sch_mqprio_lib.c
 create mode 100644 net/sched/sch_mqprio_lib.h
 create mode 100644 samples/bpf/gnu/stubs.h
 rename samples/bpf/{lwt_len_hist_kern.c => lwt_len_hist.bpf.c} (75%)
 rename samples/bpf/{map_perf_test_kern.c => map_perf_test.bpf.c} (85%)
 create mode 100644 samples/bpf/net_shared.h
 rename samples/bpf/{sock_flags_kern.c => sock_flags.bpf.c} (66%)
 rename samples/bpf/{test_cgrp2_tc_kern.c => test_cgrp2_tc.bpf.c} (70%)
 rename samples/bpf/{test_current_task_under_cgroup_kern.c => test_current_task_under_cgroup.bpf.c} (84%)
 rename samples/bpf/{test_map_in_map_kern.c => test_map_in_map.bpf.c} (97%)
 rename samples/bpf/{test_overhead_kprobe_kern.c => test_overhead_kprobe.bpf.c} (92%)
 rename samples/bpf/{test_overhead_raw_tp_kern.c => test_overhead_raw_tp.bpf.c} (82%)
 rename samples/bpf/{test_overhead_tp_kern.c => test_overhead_tp.bpf.c} (61%)
 rename samples/bpf/{test_probe_write_user_kern.c => test_probe_write_user.bpf.c} (71%)
 delete mode 100644 samples/bpf/trace_common.h
 rename samples/bpf/{trace_output_kern.c => trace_output.bpf.c} (82%)
 rename samples/bpf/{tracex2_kern.c => tracex2.bpf.c} (89%)
 create mode 100644 tools/include/uapi/linux/netdev.h
 create mode 100755 tools/net/ynl/cli.py
 create mode 100644 tools/net/ynl/lib/__init__.py
 create mode 100644 tools/net/ynl/lib/nlspec.py
 create mode 100644 tools/net/ynl/lib/ynl.py
 create mode 100755 tools/net/ynl/ynl-gen-c.py
 create mode 100755 tools/net/ynl/ynl-regen.sh
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_bpf_hashmap_lookup.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cpumask.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fib_lookup.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/htab_reuse.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/jit_probe_mem.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/nested_trust.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/rbtree.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_hashmap_lookup.c
 create mode 100644 tools/testing/selftests/bpf/progs/cpumask_common.h
 create mode 100644 tools/testing/selftests/bpf/progs/cpumask_failure.c
 create mode 100644 tools/testing/selftests/bpf/progs/cpumask_success.c
 create mode 100644 tools/testing/selftests/bpf/progs/dummy_st_ops_fail.c
 rename tools/testing/selftests/bpf/progs/{dummy_st_ops.c => dummy_st_ops_success.c} (72%)
 create mode 100644 tools/testing/selftests/bpf/progs/fib_lookup.c
 create mode 100644 tools/testing/selftests/bpf/progs/htab_reuse.c
 create mode 100644 tools/testing/selftests/bpf/progs/jit_probe_mem.c
 create mode 100644 tools/testing/selftests/bpf/progs/nested_trust_common.h
 create mode 100644 tools/testing/selftests/bpf/progs/nested_trust_failure.c
 create mode 100644 tools/testing/selftests/bpf/progs/nested_trust_success.c
 create mode 100644 tools/testing/selftests/bpf/progs/rbtree.c
 create mode 100644 tools/testing/selftests/bpf/progs/rbtree_btf_fail__add_wrong_type.c
 create mode 100644 tools/testing/selftests/bpf/progs/rbtree_btf_fail__wrong_node_type.c
 create mode 100644 tools/testing/selftests/bpf/progs/rbtree_fail.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_global_func_ctx_args.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sk_assign_libbpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_features.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_metadata2.c
 create mode 100644 tools/testing/selftests/bpf/progs/xsk_xdp_progs.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_features.sh
 create mode 100644 tools/testing/selftests/bpf/verifier/bpf_st_mem.c
 create mode 100644 tools/testing/selftests/bpf/verifier/sleepable.c
 create mode 100644 tools/testing/selftests/bpf/xdp_features.c
 create mode 100644 tools/testing/selftests/bpf/xdp_features.h
 create mode 100644 tools/testing/selftests/bpf/xdp_hw_metadata.c
 create mode 100644 tools/testing/selftests/bpf/xdp_metadata.h
 delete mode 100644 tools/testing/selftests/net/bpf/Makefile
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_mdb_max.sh
 create mode 100644 tools/testing/selftests/net/ip_local_port_range.c
 create mode 100755 tools/testing/selftests/net/ip_local_port_range.sh
 rename tools/testing/selftests/net/{bpf => }/nat6to4.c (100%)
 create mode 100755 tools/testing/selftests/net/rps_default_mask.sh
 create mode 100755 tools/testing/selftests/net/srv6_end_flavors_test.sh
 delete mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/rsvp.json
 delete mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/tcindex.json
 delete mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/atm.json
 delete mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/cbq.json
 delete mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/dsmark.json
 create mode 100644 tools/testing/vsock/vsock_perf.c
