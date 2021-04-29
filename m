Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5703436E355
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 04:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236561AbhD2CiB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 22:38:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229805AbhD2CiA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 22:38:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49B396143E;
        Thu, 29 Apr 2021 02:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619663834;
        bh=OCZDY/+gxy//HEsWWaHSRA86EmjxrDUANLWhGvfQLJE=;
        h=From:To:Cc:Subject:Date:From;
        b=oaj2ejictxGOVrHsXVR2vGoUCsLLyNKncwR45T7SF9k+fq1UfuW6pSiKI3mQMRn4/
         WKpBkWtjU5K6glO3eynJYSyJ4Ylci+BWN63HHfO8WMWytg68vF6958Mh4BOs5bB8ny
         oo2nY6IiQ2JjsvRQEnzCjDutrFpJ7sm8foRiLD6PanGgGda71l96E9tK55/uobitJq
         DF/hAJbG21j6WxxXTn71u6qqFY4sknLgq7QwWv6NNAHMVrGamTtzUORrOXCcYdgbkW
         BKcq48XLGixts0mFrjCDMOqQGAhOkLLGFGnnwMfJuEUZC446O40Mr170dlOnGBqzR1
         G6+UAySlNMkcg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.13
Date:   Wed, 28 Apr 2021 19:37:12 -0700
Message-Id: <20210429023712.2011727-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

This is the 5.13 netdev PR. At the time of writing we expect two minor
conflicts - trivial in drivers/of/of_net.c, and net/nfc/nci/uart.c.
For the latter removal of the code is correct, our only change was
a spelling fix.

The following changes since commit 88a5af943985fb43b4c9472b5abd9c0b9705533d:

  Merge tag 'net-5.12-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-04-17 09:57:15 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-5.13

for you to fetch changes up to 4a52dd8fefb45626dace70a63c0738dbd83b7edb:

  net: selftest: fix build issue if INET is disabled (2021-04-28 14:06:45 -0700)

----------------------------------------------------------------
Networking changes for 5.13.

Core:

 - bpf:
	- allow bpf programs calling kernel functions (initially to
	  reuse TCP congestion control implementations)
	- enable task local storage for tracing programs - remove the
	  need to store per-task state in hash maps, and allow tracing
	  programs access to task local storage previously added for
	  BPF_LSM
	- add bpf_for_each_map_elem() helper, allowing programs to
	  walk all map elements in a more robust and easier to verify
	  fashion
	- sockmap: support UDP and cross-protocol BPF_SK_SKB_VERDICT
	  redirection
	- lpm: add support for batched ops in LPM trie
	- add BTF_KIND_FLOAT support - mostly to allow use of BTF
	  on s390 which has floats in its headers files
	- improve BPF syscall documentation and extend the use of kdoc
	  parsing scripts we already employ for bpf-helpers
	- libbpf, bpftool: support static linking of BPF ELF files
	- improve support for encapsulation of L2 packets

 - xdp: restructure redirect actions to avoid a runtime lookup,
	improving performance by 4-8% in microbenchmarks

 - xsk: build skb by page (aka generic zerocopy xmit) - improve
	performance of software AF_XDP path by 33% for devices
	which don't need headers in the linear skb part (e.g. virtio)

 - nexthop: resilient next-hop groups - improve path stability
	on next-hops group changes (incl. offload for mlxsw)

 - ipv6: segment routing: add support for IPv4 decapsulation

 - icmp: add support for RFC 8335 extended PROBE messages

 - inet: use bigger hash table for IP ID generation

 - tcp: deal better with delayed TX completions - make sure we don't
	give up on fast TCP retransmissions only because driver is
	slow in reporting that it completed transmitting the original

 - tcp: reorder tcp_congestion_ops for better cache locality

 - mptcp:
	- add sockopt support for common TCP options
	- add support for common TCP msg flags
	- include multiple address ids in RM_ADDR
	- add reset option support for resetting one subflow

 - udp: GRO L4 improvements - improve 'forward' / 'frag_list'
	co-existence with UDP tunnel GRO, allowing the first to take
	place correctly	even for encapsulated UDP traffic

 - micro-optimize dev_gro_receive() and flow dissection, avoid
	retpoline overhead on VLAN and TEB GRO

 - use less memory for sysctls, add a new sysctl type, to allow using
	u8 instead of "int" and "long" and shrink networking sysctls

 - veth: allow GRO without XDP - this allows aggregating UDP
	packets before handing them off to routing, bridge, OvS, etc.

 - allow specifing ifindex when device is moved to another namespace

 - netfilter:
	- nft_socket: add support for cgroupsv2
	- nftables: add catch-all set element - special element used
	  to define a default action in case normal lookup missed
	- use net_generic infra in many modules to avoid allocating
	  per-ns memory unnecessarily

 - xps: improve the xps handling to avoid potential out-of-bound
	accesses and use-after-free when XPS change race with other
	re-configuration under traffic

 - add a config knob to turn off per-cpu netdev refcnt to catch
	underflows in testing

Device APIs:

 - add WWAN subsystem to organize the WWAN interfaces better and
   hopefully start driving towards more unified and vendor-
   -independent APIs

 - ethtool:
	- add interface for reading IEEE MIB stats (incl. mlx5 and
	  bnxt support)
	- allow network drivers to dump arbitrary SFP EEPROM data,
	  current offset+length API was a poor fit for modern SFP
	  which define EEPROM in terms of pages (incl. mlx5 support)

 - act_police, flow_offload: add support for packet-per-second
	policing (incl. offload for nfp)

 - psample: add additional metadata attributes like transit delay
	for packets sampled from switch HW (and corresponding egress
	and policy-based sampling in the mlxsw driver)

 - dsa: improve support for sandwiched LAGs with bridge and DSA

 - netfilter:
	- flowtable: use direct xmit in topologies with IP
	  forwarding, bridging, vlans etc.
	- nftables: counter hardware offload support

 - Bluetooth:
	- improvements for firmware download w/ Intel devices
	- add support for reading AOSP vendor capabilities
	- add support for virtio transport driver

 - mac80211:
	- allow concurrent monitor iface and ethernet rx decap
	- set priority and queue mapping for injected frames

 - phy: add support for Clause-45 PHY Loopback

 - pci/iov: add sysfs MSI-X vector assignment interface
	to distribute MSI-X resources to VFs (incl. mlx5 support)

New hardware/drivers:

 - dsa: mv88e6xxx: add support for Marvell mv88e6393x -
	11-port Ethernet switch with 8x 1-Gigabit Ethernet
	and 3x 10-Gigabit interfaces.

 - dsa: support for legacy Broadcom tags used on BCM5325, BCM5365
	and BCM63xx switches

 - Microchip KSZ8863 and KSZ8873; 3x 10/100Mbps Ethernet switches

 - ath11k: support for QCN9074 a 802.11ax device

 - Bluetooth: Broadcom BCM4330 and BMC4334

 - phy: Marvell 88X2222 transceiver support

 - mdio: add BCM6368 MDIO mux bus controller

 - r8152: support RTL8153 and RTL8156 (USB Ethernet) chips

 - mana: driver for Microsoft Azure Network Adapter (MANA)

 - Actions Semi Owl Ethernet MAC

 - can: driver for ETAS ES58X CAN/USB interfaces

Pure driver changes:

 - add XDP support to: enetc, igc, stmmac
 - add AF_XDP support to: stmmac

 - virtio:
	- page_to_skb() use build_skb when there's sufficient tailroom
	  (21% improvement for 1000B UDP frames)
	- support XDP even without dedicated Tx queues - share the Tx
	  queues with the stack when necessary

 - mlx5:
	- flow rules: add support for mirroring with conntrack,
	  matching on ICMP, GTP, flex filters and more
	- support packet sampling with flow offloads
	- persist uplink representor netdev across eswitch mode
	  changes
	- allow coexistence of CQE compression and HW time-stamping
	- add ethtool extended link error state reporting

 - ice, iavf: support flow filters, UDP Segmentation Offload

 - dpaa2-switch:
	- move the driver out of staging
	- add spanning tree (STP) support
	- add rx copybreak support
	- add tc flower hardware offload on ingress traffic

 - ionic:
	- implement Rx page reuse
	- support HW PTP time-stamping

 - octeon: support TC hardware offloads - flower matching on ingress
	and egress ratelimitting.

 - stmmac:
	- add RX frame steering based on VLAN priority in tc flower
	- support frame preemption (FPE)
	- intel: add cross time-stamping freq difference adjustment

 - ocelot:
	- support forwarding of MRP frames in HW
	- support multiple bridges
	- support PTP Sync one-step timestamping

 - dsa: mv88e6xxx, dpaa2-switch: offload bridge port flags like
	learning, flooding etc.

 - ipa: add IPA v4.5, v4.9 and v4.11 support (Qualcomm SDX55, SM8350,
	SC7280 SoCs)

 - mt7601u: enable TDLS support

 - mt76:
	- add support for 802.3 rx frames (mt7915/mt7615)
	- mt7915 flash pre-calibration support
	- mt7921/mt7663 runtime power management fixes

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Abhishek Pandit-Subedi (2):
      Bluetooth: Notify suspend on le conn failed
      Bluetooth: Remove unneeded commands for suspend

Adam Ford (3):
      dt-bindings: net: renesas,etheravb: Add additional clocks
      net: ethernet: ravb: Enable optional refclk
      net: ethernet: ravb: Fix release of refclk

Aditya Srivastava (1):
      rsi: fix comment syntax in file headers

Ajay Singh (1):
      wilc1000: use wilc handler as cookie in request_threaded_irq()

Alaa Hleihel (1):
      net/mlx5: Display the command index in command mailbox dump

Aleksander Jan Bajkowski (3):
      net: dsa: lantiq: allow to use all GPHYs on xRX300 and xRX330
      net: dsa: lantiq: verify compatible strings against hardware
      dt-bindings: net: dsa: lantiq: add xRx300 and xRX330 switch bindings

Aleksandr Loktionov (1):
      i40e: refactor repeated link state reporting code

Alex Elder (71):
      net: ipa: make ipa_table_hash_support() inline
      net: qualcomm: rmnet: mark trailer field endianness
      net: qualcomm: rmnet: simplify some byte order logic
      net: qualcomm: rmnet: kill RMNET_MAP_GET_*() accessor macros
      net: qualcomm: rmnet: use masks instead of C bit-fields
      net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum trailer
      net: qualcomm: rmnet: don't use C bit-fields in rmnet checksum header
      net: ipa: fix a duplicated tlv_type value
      net: ipa: fix another QMI message definition
      net: ipa: extend the INDICATION_REGISTER request
      net: ipa: fix assumptions about DMA address size
      net: ipa: use upper_32_bits()
      net: ipa: fix table alignment requirement
      net: ipa: relax 64-bit build requirement
      net: ipa: make all configuration data constant
      net: ipa: fix canary count for SC7180 UC_INFO region
      net: ipa: don't define empty memory regions
      net: ipa: define some new memory regions
      net: ipa: define QSB limits in configuration data
      net: ipa: use configuration data for QSB settings
      net: ipa: implement MAX_READS_BEATS QSB data
      net: ipa: split sequencer type in two
      net: ipa: sequencer type is for TX endpoints only
      net: ipa: update some comments in "ipa_data.h"
      net: ipa: avoid 64-bit modulus
      net: ipa: reduce IPA version assumptions
      net: ipa: update version definitions
      net: ipa: define the ENDP_INIT_NAT register
      net: ipa: limit local processing context address
      net: ipa: move ipa_aggr_granularity_val()
      net: ipa: increase channels and events
      net: ipa: update IPA register comments
      net: ipa: update component config register
      net: ipa: support IPA interrupt addresses for IPA v4.7
      net: ipa: GSI register cleanup
      net: ipa: update GSI ring size registers
      net: ipa: expand GSI channel types
      net: ipa: introduce ipa_resource.c
      net: ipa: fix bug in resource group limit programming
      net: ipa: identify resource groups
      net: ipa: add some missing resource limits
      net: ipa: combine resource type definitions
      net: ipa: index resource limits with type
      net: ipa: move ipa_resource_type definition
      net: ipa: combine source and destination group limits
      net: ipa: combine source and destation resource types
      net: ipa: pass data for source and dest resource config
      net: ipa: record number of groups in data
      net: ipa: support more than 6 resource groups
      net: ipa: fix all kernel-doc warnings
      net: ipa: store BCR register values in config data
      net: ipa: don't define endpoints unnecessarily
      net: ipa: switch to version based configuration
      net: ipa: use version based configuration for SC7180
      net: ipa: DMA addresses are nicely aligned
      net: ipa: kill IPA_TABLE_ENTRY_SIZE
      net: ipa: relax pool entry size requirement
      net: ipa: update sequence type for modem TX endpoint
      net: ipa: only set endpoint netdev pointer when in use
      net: ipa: ipa_stop() does not return an error
      net: ipa: get rid of empty IPA functions
      net: ipa: get rid of empty GSI functions
      net: ipa: three small fixes
      dt-bindings: net: qcom,ipa: add some compatible strings
      net: ipa: disable checksum offload for IPA v4.5+
      net: ipa: add IPA v4.5 configuration data
      net: ipa: add IPA v4.11 configuration data
      dt-bindings: net: qcom,ipa: add support for SM8350
      net: ipa: add IPA v4.9 configuration data
      dt-bindings: net: qcom,ipa: add firmware-name property
      net: ipa: optionally define firmware name via DT

Alexander Duyck (10):
      ethtool: Add common function for filling out strings
      intel: Update drivers to use ethtool_sprintf
      nfp: Replace nfp_pr_et with ethtool_sprintf
      hisilicon: Update drivers to use ethtool_sprintf
      ena: Update driver to use ethtool_sprintf
      netvsc: Update driver to use ethtool_sprintf
      virtio_net: Update driver to use ethtool_sprintf
      vmxnet3: Update driver to use ethtool_sprintf
      bna: Update driver to use ethtool_sprintf
      ionic: Update driver to use ethtool_sprintf

Alexander Lobakin (17):
      netdevice: Add missing IFF_PHONY_HEADROOM self-definition
      xsk: Respect device's headroom and tailroom on generic xmit path
      gro: simplify gro_list_prepare()
      gro: consistentify napi->gro_hash[x] access in dev_gro_receive()
      gro: give 'hash' variable in dev_gro_receive() a less confusing name
      flow_dissector: constify bpf_flow_dissector's data pointers
      skbuff: make __skb_header_pointer()'s data argument const
      flow_dissector: constify raw input data argument
      linux/etherdevice.h: misc trailing whitespace cleanup
      ethernet: constify eth_get_headlen()'s data argument
      skbuff: micro-optimize {,__}skb_header_pointer()
      gro: make net/gro.h self-contained
      gro: add combined call_gro_receive() + INDIRECT_CALL_INET() helper
      vlan/8021q: avoid retpoline overhead on GRO
      ethernet: avoid retpoline overhead on TEB (GENEVE, NvGRE, VxLAN) GRO
      dsa: simplify Kconfig symbols and dependencies
      gro: fix napi_gro_frags() Fast GRO breakage due to IP alignment check

Alexei Starovoitov (25):
      Merge branch 'bpf: enable task local storage for tracing'
      Merge branch 'selftests/bpf: xsk improvements and new stats'
      Merge branch 'sock_map: clean up and refactor code for BPF_SK_SKB_VERDICT'
      Merge branch 'bpf: add bpf_for_each_map_elem() helper'
      Merge branch 'Add BTF_KIND_FLOAT support'
      Merge branch 'Improve BPF syscall command documentation'
      Merge branch 'PROG_TEST_RUN support for sk_lookup programs'
      Merge branch 'Add clang-based BTF_KIND_FLOAT tests'
      Merge branch 'Build BPF selftests and its libbpf, bpftool in debug mode'
      Merge branch 'Provide NULL and KERNEL_VERSION macros in bpf_helpers.h'
      Merge branch 'BPF static linking'
      Merge branch 'add support for batched ops in LPM trie'
      Merge branch 'bpf: Support calling kernel function'
      Merge branch 'bpf: Update doc about calling kernel function'
      Merge branch 'AF_XDP selftests improvements & bpf_link'
      Merge branch 'sockmap: introduce BPF_SK_SKB_VERDICT and support UDP'
      libbpf: Remove unused field.
      Merge branch 'bpf: tools: support build selftests/bpf with clang'
      Merge branch 'Add a snprintf eBPF helper'
      Merge branch 'bpf: refine retval for bpf_get_task_stack helper'
      Merge branch 'Simplify bpf_snprintf verifier code'
      Merge branch 'BPF static linker: support externs'
      Merge branch 'bpf: Tracing and lsm programs re-attach'
      Merge branch 'CO-RE relocation selftests fixes'
      Merge branch 'Implement formatted output helpers with bstr_printf'

Alexey Dobriyan (2):
      atm: delete include/linux/atm_suni.h
      netlink: simplify nl_set_extack_cookie_u64(), nl_set_extack_cookie_u32()

Aloka Dixit (1):
      nl80211: Add missing line in nl80211_fils_discovery_policy

Amit Cohen (8):
      mlxsw: reg: Fix comment about slot_index field in PMAOS register
      mlxsw: reg: Add egr_et_set field to SPVID
      mlxsw: reg: Add Switch Port Egress VLAN EtherType Register
      mlxsw: spectrum: Add mlxsw_sp_port_egress_ethtype_set()
      mlxsw: Add struct mlxsw_sp_switchdev_ops per ASIC
      mlxsw: Allow 802.1d and .1ad VxLAN bridges to coexist on Spectrum>=2
      selftests: forwarding: Add test for dual VxLAN bridge
      selftests: mlxsw: spectrum-2: Remove q_in_vni_veto test

Andre Edich (1):
      net: phy: lan87xx: fix access to wrong register of LAN87xx

Andre Guedes (8):
      igc: Remove unused argument from igc_tx_cmd_type()
      igc: Introduce igc_rx_buffer_flip() helper
      igc: Introduce igc_get_rx_frame_truesize() helper
      igc: Refactor Rx timestamp handling
      igc: Add set/clear large buffer helpers
      igc: Add initial XDP support
      igc: Add support for XDP_TX action
      igc: Add support for XDP_REDIRECT action

Andrea Mayer (1):
      net: seg6: trivial fix of a spelling mistake in comment

Andreas Roeseler (8):
      icmp: add support for RFC 8335 PROBE
      ICMPV6: add support for RFC 8335 PROBE
      net: add sysctl for enabling RFC 8335 PROBE messages
      net: add support for sending RFC 8335 PROBE messages
      ipv6: add ipv6_dev_find to stubs
      icmp: add response to RFC 8335 PROBE messages
      icmp: ICMPV6: pass RFC 8335 reply messages to ping_rcv
      icmp: standardize naming of RFC 8335 PROBE constants

Andrei Vagin (3):
      net: Allow to specify ifindex when device is moved to another namespace
      net: introduce nla_policy for IFLA_NEW_IFINDEX
      net: remove the new_ifindex argument from dev_change_net_namespace

Andrew Lunn (4):
      net: ethtool: Export helpers for getting EEPROM info
      phy: sfp: add netlink SFP support to generic SFP code
      ethtool: wire in generic SFP module access
      net: phy: Add support for microchip SMI0 MDIO bus

Andrii Nakryiko (51):
      tools/runqslower: Allow substituting custom vmlinux.h for the build
      Merge branch 'load-acquire/store-release barriers for'
      selftests/bpf: Fix compiler warning in BPF_KPROBE definition in loop6.c
      Merge branch 'libbpf/xsk cleanups'
      libbpf: Add explicit padding to bpf_xdp_set_link_opts
      bpftool: Fix maybe-uninitialized warnings
      selftests/bpf: Fix maybe-uninitialized warning in xdpxceiver test
      selftests/bpf: Build everything in debug mode
      libbpf: provide NULL and KERNEL_VERSION macros in bpf_helpers.h
      selftests/bpf: drop custom NULL #define in skb_pkt_end selftest
      libbpf: Expose btf_type_by_id() internally
      libbpf: Generalize BTF and BTF.ext type ID and strings iteration
      libbpf: Rename internal memory-management helpers
      libbpf: Extract internal set-of-strings datastructure APIs
      libbpf: Add generic BTF type shallow copy API
      libbpf: Add BPF static linker APIs
      libbpf: Add BPF static linker BTF and BTF.ext support
      bpftool: Add ability to specify custom skeleton object name
      bpftool: Add `gen object` command to perform BPF static linking
      selftests/bpf: Re-generate vmlinux.h and BPF skeletons if bpftool changed
      selftests/bpf: Pass all BPF .o's through BPF static linker
      selftests/bpf: Add multi-file statically linked BPF object file test
      libbpf: Skip BTF fixup if object file has no BTF
      libbpf: Constify few bpf_program getters
      libbpf: Preserve empty DATASEC BTFs during static linking
      libbpf: Fix memory leak when emitting final btf_ext
      libbpf: Add bpf_map__inner_map API
      Merge branch 'bpf/selftests: page size fixes'
      bpftool: Support dumping BTF VAR's "extern" linkage
      bpftool: Dump more info about DATASEC members
      libbpf: Suppress compiler warning when using SEC() macro with externs
      libbpf: Mark BPF subprogs with hidden visibility as static for BPF verifier
      libbpf: Allow gaps in BPF program sections to support overriden weak functions
      libbpf: Refactor BTF map definition parsing
      libbpf: Factor out symtab and relos sanity checks
      libbpf: Make few internal helpers available outside of libbpf.c
      libbpf: Extend sanity checking ELF symbols with externs validation
      libbpf: Tighten BTF type ID rewriting with error checking
      libbpf: Add linker extern resolution support for functions and global variables
      libbpf: Support extern resolution for BTF-defined maps in .maps section
      selftests/bpf: Use -O0 instead of -Og in selftests builds
      selftests/bpf: Omit skeleton generation for multi-linked BPF object files
      selftests/bpf: Add function linking selftest
      selftests/bpf: Add global variables linking selftest
      selftests/bpf: Add map linking selftest
      selftests/bpf: Document latest Clang fix expectations for linking tests
      selftests/bpf: Add remaining ASSERT_xxx() variants
      libbpf: Support BTF_KIND_FLOAT during type compatibility checks in CO-RE
      selftests/bpf: Fix BPF_CORE_READ_BITFIELD() macro
      selftests/bpf: Fix field existence CO-RE reloc tests
      selftests/bpf: Fix core_reloc test runner

Andy Shevchenko (2):
      stmmac: intel: Drop duplicate ID in the list of PCI device IDs
      time64.h: Consolidated PSEC_PER_SEC definition

Anilkumar Kolli (7):
      ath11k: Refactor ath11k_msi_config
      ath11k: Move qmi service_ins_id to hw_params
      ath11k: qmi: increase the number of fw segments
      ath11k: Update memory segment count for qcn9074
      ath11k: Add qcn9074 mhi controller config
      ath11k: add qcn9074 pci device support
      ath11k: fix warning in ath11k_mhi_config

Anirudh Venkataramanan (15):
      ice: Delay netdev registration
      ice: Check for bail out condition early
      ice: Consolidate VSI state and flags
      ice: Align macro names to the specification
      ice: Ignore EMODE return for opcode 0x0605
      ice: Remove unnecessary checker loop
      ice: Rename a couple of variables
      ice: Fix error return codes in ice_set_link_ksettings
      ice: Replace some memsets and memcpys with assignment
      ice: Use default configuration mode for PHY configuration
      ice: Remove unnecessary variable
      ice: Use local variable instead of pointer derefs
      ice: Remove rx_gro_dropped stat
      ice: Drop leading underscores in enum ice_pf_state
      ice: Add new VSI states to track netdev alloc/registration

Antoine Tenart (14):
      net-sysfs: convert xps_cpus_show to bitmap_zalloc
      net-sysfs: store the return of get_netdev_queue_index in an unsigned int
      net-sysfs: make xps_cpus_show and xps_rxqs_show consistent
      net: embed num_tc in the xps maps
      net: embed nr_ids in the xps maps
      net: remove the xps possible_mask
      net: move the xps maps to an array
      net: add an helper to copy xps maps to the new dev_maps
      net: improve queue removal readability in __netif_set_xps_queue
      net-sysfs: move the rtnl unlock up in the xps show helpers
      net-sysfs: move the xps cpus/rxqs retrieval in a common function
      net: fix use after free in xps
      net: NULL the old xps map entries when freeing them
      net-sysfs: remove possible sleep from an RCU read-side critical section

Archie Pusaka (4):
      Bluetooth: Set CONF_NOT_COMPLETE as l2cap_chan default
      Bluetooth: verify AMP hci_chan before amp_destroy
      Bluetooth: check for zapped sk before connecting
      Bluetooth: Check inquiry status before sending one

Ariel Levkovich (2):
      net/mlx5: CT: Add support for matching on ct_state inv and rel flags
      net/mlx5e: Reject tc rules which redirect from a VF to itself

Arnaldo Carvalho de Melo (1):
      net: Fix typo in comment about ancillary data

Arnd Bergmann (20):
      net/mlx5e: fix mlx5e_tc_tun_update_header_ipv6 dummy definition
      net/mlx5e: allocate 'indirection_rqt' buffer dynamically
      Bluetooth: fix set_ecdh_privkey() prototype
      misdn: avoid -Wempty-body warning
      bpf: Avoid old-style declaration warnings
      octeontx2: fix -Wnonnull warning
      rhashtable: avoid -Wrestrict warning on overlapping sprintf output
      hinic: avoid gcc -Wrestrict warning
      ipv6: fix clang Wformat warning
      can: ucan: fix alignment constraints
      iwlegacy: avoid -Wempty-body warning
      net: Space: remove hp100 probe
      libertas: avoid -Wempty-body warning
      wlcore: fix overlapping snprintf arguments in debugfs
      airo: work around stack usage warning
      net: mana: fix PCI_HYPERV dependency
      net: enetc: fix link error again
      vxge: avoid -Wemtpy-body warnings
      netfilter: nft_socket: fix an unused variable warning
      netfilter: nft_socket: fix build with CONFIG_SOCK_CGROUP_DATA=n

Atul Gopinathan (1):
      bpf: tcp: Remove comma which is causing build error

Avraham Stern (5):
      iwlwifi: mvm: support range request command version 12
      iwlwifi: mvm: responder: support responder config command version 8
      iwlwifi: mvm: when associated with PMF, use protected NDP ranging negotiation
      ieee80211: add the values of ranging parameters max LTF total field
      nl80211/cfg80211: add a flag to negotiate for LMR feedback in NDP ranging

Aya Levin (23):
      net/mlx5e: Allow creating mpwqe info without channel
      net/mlx5: Add helper to set time-stamp translator on a queue
      net/mlx5e: Generalize open RQ
      net/mlx5e: Generalize RQ activation
      net/mlx5e: Generalize close RQ
      net/mlx5e: Generalize direct-TIRs and direct-RQTs API
      net/mlx5e: Generalize PTP implementation
      net/mlx5e: Cleanup PTP
      net/mlx5e: Add states to PTP channel
      net/mlx5e: Add RQ to PTP channel
      net/mlx5e: Add PTP-RX statistics
      net:mlx5e: Add PTP-TIR and PTP-RQT
      net/mlx5e: Refactor RX reporter diagnostics
      net/mlx5e: Add PTP RQ to RX reporter
      net/mlx5e: Cleanup Flow Steering level
      net/mlx5e: Introduce Flow Steering UDP API
      net/mlx5e: Introduce Flow Steering ANY API
      net/mlx5e: Add PTP Flow Steering support
      net/mlx5e: Allow coexistence of CQE compression and HW TS PTP
      net/mlx5e: Update ethtool setting of CQE compression
      net/mlx5e: Fix RQ creation flow for queues which doesn't support XDP
      net/mlx5: Add helper to initialize 1PPS
      net/mlx5: Enhance diagnostics info for TX/RX reporters

Ayush Garg (1):
      Bluetooth: Fix incorrect status handling in LE PHY UPDATE event

Baowen Zheng (4):
      flow_offload: reject configuration of packet-per-second policing in offload drivers
      net/sched: act_police: add support for packet-per-second policing
      selftests: tc-testing: add action police selftest for packets per second
      selftests: forwarding: Add tc-police tests for packets per second

Benita Bose (1):
      ice: Add Support for XPS

Bhaskar Chowdhury (39):
      net: fddi: skfp: Mundane typo fixes throughout the file smt.h
      net: ethernet: marvell: Fixed typo in the file sky2.c
      ethernet: amazon: ena: A typo fix in the file ena_com.h
      net: ethernet: intel: igb: Typo fix in the file igb_main.c
      net: ethernet: neterion: Fix a typo in the file s2io.c
      net: ppp: Mundane typo fixes in the file pppoe.c
      Fix a typo
      selftests: net: forwarding: Fix a typo
      Bluetooth: hci_qca: Mundane typo fix
      NFC: Fix a typo
      openvswitch: Fix a typo
      linux/qed: Mundane spelling fixes throughout the file
      net: l2tp: Fix a typo
      octeontx2-af: Few mundane typos fixed
      net: sched: Mundane typo fixes
      sfc-falcon: Fix a typo
      Bluetooth: L2CAP: Rudimentary typo fixes
      af_x25.c: Fix a spello
      bearer.h: Spellos fixed
      ipv4: ip_output.c: Couple of typo fixes
      ipv4: tcp_lp.c: Couple of typo fixes
      ipv6: addrconf.c: Fix a typo
      ipv6: route.c: A spello fix
      iucv: af_iucv.c: Couple of typo fixes
      kcm: kcmsock.c: Couple of typo fixes
      llc: llc_core.c: COuple of typo fixes
      mac80211: cfg.c: A typo fix
      mptcp: subflow.c: Fix a typo
      ncsi: internal.h: Fix a spello
      netfilter: ipvs: A spello fix
      netfilter: nf_conntrack_acct.c: A typo fix
      node.c: A typo fix
      reg.c: Fix a spello
      sm_statefuns.c: Mundane spello fixes
      xfrm_policy.c : Mundane typo fix
      xfrm_user.c: Added a punctuation
      net: ethernet: intel: Fix a typo in the file ixgbe_dcb_nl.c
      rtlwifi: Few mundane typo fixes
      brcmfmac: A typo fix

Bjarni Jonasson (3):
      net: phy: mscc: Applying LCPLL reset to VSC8584
      net: phy: mscc: improved serdes calibration applied to VSC8584
      net: phy: mscc: coma mode disabled for VSC8584

Bjorn Andersson (1):
      net: qrtr: Avoid potential use after free in MHI send

Björn Töpel (9):
      xsk: Update rings for load-acquire/store-release barriers
      libbpf, xsk: Add libbpf_smp_store_release libbpf_smp_load_acquire
      bpf, xdp: Make bpf_redirect_map() a map operation
      bpf, xdp: Restructure redirect actions
      libbpf: xsk: Remove linux/compiler.h header
      libbpf: xsk: Move barriers from libbpf_util.h to xsk.h
      selftests: xsk: Remove thread attribute
      selftests: xsk: Remove mutex and condition variable
      selftests: xsk: Remove unused defines

Brendan Jackman (1):
      bpf: Rename fixup_bpf_calls and add some comments

Brett Creeley (8):
      ice: Change ice_vsi_setup_q_map() to not depend on RSS
      ice: Refactor get/set RSS LUT to use struct parameter
      ice: Refactor ice_set/get_rss into LUT and key specific functions
      ice: Remove unnecessary checks in add/kill_vid ndo ops
      ice: Set vsi->vf_id as ICE_INVAL_VFID for non VF VSI types
      ice: Advertise virtchnl UDP segmentation offload capability
      iavf: add support for UDP Segmentation Offload
      ice: Add helper function to get the VF's VSI

Brian Norris (1):
      mwifiex: don't print SSID to logs

Bruce Allan (5):
      ice: remove unnecessary duplicated AQ command flag setting
      ice: correct memory allocation call
      ice: cleanup style issues
      ice: use kernel definitions for IANA protocol ports and ether-types
      ice: suppress false cppcheck issues

Calvin Johnson (1):
      net: mdio: Alphabetically sort header inclusion

Carlos Llamas (1):
      selftests/net: so_txtime multi-host support

Chen Lin (3):
      net: intel: Remove unused function pointer typedef ixgbe_mc_addr_itr
      cw1200: Remove unused function pointer typedef cw1200_wsm_handler
      cw1200: Remove unused function pointer typedef wsm_*

Chen Yu (2):
      e1000e: Leverage direct_complete to speed up s2ram
      e1000e: Remove the runtime suspend restriction on CNP+

Ching-Te Ku (1):
      rtw88: coex: fix A2DP stutters while WL busy + WL scan

Chinh T Cao (1):
      ice: Re-send some AQ commands, as result of EBUSY AQ error

Chinmay Agarwal (1):
      neighbour: Prevent Race condition in neighbour subsytem

Chris Mi (13):
      net/mlx5: E-switch, Move vport table functions to a new file
      net/mlx5: E-switch, Rename functions to follow naming convention.
      net/mlx5: E-switch, Generalize per vport table API
      net/mlx5: E-switch, Set per vport table default group number
      net/mlx5: Map register values to restore objects
      net/mlx5: Instantiate separate mapping objects for FDB and NIC tables
      net/mlx5e: TC, Parse sample action
      net/mlx5e: TC, Add sampler termination table API
      net/mlx5e: TC, Add sampler object API
      net/mlx5e: TC, Add sampler restore handle API
      net/mlx5e: TC, Refactor tc update skb function
      net/mlx5e: TC, Handle sampled packets
      net/mlx5e: TC, Add support to offload sample action

Christophe JAILLET (12):
      net: openvswitch: Use 'skb_push_rcsum()' instead of hand coding it
      net: ag71xx: Slightly simplify 'ag71xx_rx_packets()'
      ibmvnic: Use 'skb_frag_address()' instead of hand coding it
      sfc: Use 'skb_add_rx_frag()' instead of hand coding it
      qede: Remove a erroneous ++ in 'qede_rx_build_jumbo()'
      qede: Use 'skb_add_rx_frag()' instead of hand coding it
      rtlwifi: remove rtl_get_tid_h
      rtlwifi: Simplify locking of a skb list accesses
      rtl8xxxu: Simplify locking of a skb list accesses
      carl9170: remove get_tid_h
      brcmfmac: Avoid GFP_ATOMIC when GFP_KERNEL is enough
      macvlan: Use 'hash' iterators to simplify code

Ciara Loftus (3):
      selftests/bpf: Expose and rename debug argument
      selftests/bpf: Restructure xsk selftests
      selftests/bpf: Introduce xsk statistics tests

Claudiu Manoil (3):
      enetc: Use generic rule to map Tx rings to interrupt vectors
      gianfar: Drop GFAR_MQ_POLLING support
      powerpc: dts: fsl: Drop obsolete fsl,rx-bit-map and fsl,tx-bit-map properties

Coiby Xu (3):
      i40e: use minimal Tx and Rx pairs for kdump
      i40e: use minimal Rx and Tx ring buffers for kdump
      i40e: use minimal admin queue for kdump

Colin Ian King (30):
      ath11k: debugfs: Fix spelling mistake "Opportunies" -> "Opportunities"
      octeontx2-af: Remove redundant initialization of pointer pfvf
      octeontx2-pf: Fix spelling mistake "ratelimitter" -> "ratelimiter"
      net: bridge: Fix missing return assignment from br_vlan_replay_one call
      net/mlx5: Fix spelling mistakes in mlx5_core_info message
      drivers: net: smc91x: remove redundant initialization of pointer gpio
      lan743x: remove redundant intializations of pointers adapter and phydev
      ieee802154: hwsim: remove redundant initialization of variable res
      bpf: Remove redundant assignment of variable id
      xircom: remove redundant error check on variable err
      liquidio: Fix unintented sign extension of a left shift of a u16
      mac80211: remove redundant assignment of variable result
      mt7601u: fix always true expression
      mt76: mt7921: remove redundant check on type
      cxgb4: Fix unintentional sign extension issues
      net: thunderx: Fix unintentional sign extension issue
      net: hns3: Fix potential null pointer defererence of null ae_dev
      net/mlx5: Fix bit-wise and with zero
      rtlwifi: remove redundant assignment to variable err
      mac80211: minstrel_ht: remove extraneous indentation on if statement
      net: mana: remove redundant initialization of variable err
      net: davinci_emac: Fix incorrect masking of tx and rx error channel
      mt76: mt7615: Fix a dereference of pointer sta before it is null checked
      ath11k: qmi: Fix spelling mistake "requeqst" -> "request"
      wlcore: Fix buffer overrun by snprintf due to incorrect buffer size
      ice: remove redundant assignment to pointer vsi
      net/atm: Fix spelling mistake "requed" -> "requeued"
      can: etas_es58x: Fix missing null check on netdev pointer
      can: etas_es58x: Fix a couple of spelling mistakes
      net: dsa: ksz: Make reg_mib_cnt a u8 as it never exceeds 255

Cong Wang (29):
      bpf: Clean up sockmap related Kconfigs
      skmsg: Get rid of struct sk_psock_parser
      bpf: Compute data_end dynamically with JIT code
      skmsg: Move sk_redir from TCP_SKB_CB to skb
      sock_map: Rename skb_parser and skb_verdict
      sock_map: Make sock_map_prog_update() static
      skmsg: Make __sk_psock_purge_ingress_msg() static
      skmsg: Get rid of sk_psock_bpf_run()
      skmsg: Remove unused sk_psock_stop() declaration
      skmsg: Add function doc for skb->_sk_redir
      skmsg: Lock ingress_skb when purging
      skmsg: Introduce a spinlock to protect ingress_msg
      net: Introduce skb_send_sock() for sock_map
      skmsg: Avoid lock_sock() in sk_psock_backlog()
      skmsg: Use rcu work for destroying psock
      skmsg: Use GFP_KERNEL in sk_psock_create_ingress_msg()
      sock_map: Simplify sock_map_link() a bit
      sock_map: Kill sock_map_link_no_progs()
      sock_map: Introduce BPF_SK_SKB_VERDICT
      sock: Introduce sk->sk_prot->psock_update_sk_prot()
      udp: Implement ->read_sock() for sockmap
      skmsg: Extract __tcp_bpf_recvmsg() and tcp_bpf_wait_data()
      udp: Implement udp_bpf_recvmsg() for sockmap
      sock_map: Update sock type checks for UDP
      selftests/bpf: Add a test case for udp sockmap
      selftests/bpf: Add a test case for loading BPF_SK_SKB_VERDICT
      bpf, udp: Remove some pointless comments
      skmsg: Pass psock pointer to ->psock_update_sk_prot()
      sock_map: Fix a potential use-after-free in sock_map_close()

Cooper Lees (1):
      Add Open Routing Protocol ID to `rtnetlink.h`

Cristian Ciocaltea (3):
      dt-bindings: net: Add Actions Semi Owl Ethernet MAC binding
      net: ethernet: actions: Add Actions Semi Owl Ethernet MAC driver
      MAINTAINERS: Add entries for Actions Semi Owl Ethernet MAC

DENG Qingfang (2):
      net: dsa: mt7530: support MDB and bridge flag operations
      net: ethernet: mediatek: fix a typo bug in flow offloading

Dan Carpenter (12):
      nfc: pn533: prevent potential memory corruption
      netfilter: nftables: fix a warning message in nf_tables_commit_audit_collect()
      net: enetc: fix array underflow in error handling code
      rtw88: Fix an error code in rtw_debugfs_set_rsvd_page()
      ionic: return -EFAULT if copy_to_user() fails
      ipw2x00: potential buffer overflow in libipw_wx_set_encodeext()
      wilc1000: fix a loop timeout condition
      stmmac: intel: unlock on error path in intel_crosststamp()
      mt76: mt7615: fix a precision vs width bug in printk
      mt76: mt7915: fix a precision vs width bug in printk
      mt76: mt7921: fix a precision vs width bug in printk
      bnxt_en: fix ternary sign extension bug in bnxt_show_temp()

Dan Nowlin (1):
      ice: Update to use package info from ice segment

Daniel Borkmann (4):
      Merge branch 'bpf-xdp-redirect'
      bpf: Undo ptr_to_map_key alu sanitation for now
      bpf: Sync bpf headers in tooling infrastucture
      bpf: Fix propagation of 32 bit unsigned bounds from 64 bit bounds

Daniel Winkler (3):
      Bluetooth: Allow scannable adv with extended MGMT APIs
      Bluetooth: Use ext adv handle from requests in CCs
      Bluetooth: Do not set cur_adv_instance in adv param MGMT request

Danielle Ratson (7):
      mlxsw: spectrum: Reword an error message for Q-in-Q veto
      mlxsw: reg: Extend MFDE register with new log_ip field
      mlxsw: core: Expose MFDE.log_ip to devlink health
      mlxsw: Adjust some MFDE fields shift and size to fw implementation
      selftests: mlxsw: Remove a redundant if statement in port_scale test
      selftests: mlxsw: Remove a redundant if statement in tc_flower_scale test
      selftests: mlxsw: Return correct error code in resource scale tests

Daode Huang (6):
      net: hinic: Remove unnecessary 'out of memory' message
      net: hinic: add a blank line after declarations
      net: hinic: remove the repeat word "the" in comment.
      net: hinic: convert strlcpy to strscpy
      net: gve: convert strlcpy to strscpy
      net: gve: remove duplicated allowed

Dario Binacchi (6):
      can: c_can: remove unused code
      can: c_can: fix indentation
      can: c_can: add a comment about IF_RX interface's use
      can: c_can: use 32-bit write to set arbitration register
      can: c_can: prepare to up the message objects number
      can: c_can: add support to 64 message objects

Dave Marchevsky (3):
      bpf: Refine retval for bpf_get_task_stack helper
      bpf/selftests: Add bpf_get_task_stack retval bounds verifier test
      bpf/selftests: Add bpf_get_task_stack retval bounds test_prog

David Bauer (2):
      mt76: mt76x0: disable GTK offloading
      net: phy: at803x: select correct page on config init

David Mosberger-Tang (6):
      wilc1000: Support chip sleep over SPI
      wilc1000: Make SPI transfers work at 48MHz
      wilc1000: Introduce symbolic names for SPI protocol register
      wilc1000: Check for errors at end of DMA write
      wilc1000: Add support for enabling CRC
      wilc1000: Bring MAC address setting in line with typical Linux behavior

David S. Miller (202):
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge branch 'mlxsw-misc-updates'
      Merge branch 'defxx-updates'
      Merge branch 'enetc-cleanups'
      Merge branch 'dpaa2-switch-next'
      Merge branch 'ionic-next'
      Merge branch 'hns3-next'
      Merge branch 'seg6-next'
      Merge branch 'nexthop-Resilient-next-hop-groups'
      Merge tag 'mlx5-updates-2021-03-11' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'mlxsw-Implement-sampling-using-mirroring'
      Merge branch 'tcp-delayed-completions'
      Merge tag 'mlx5-updates-2021-03-12' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'macb-fixed-link-fixes'
      Merge branch 'ptp-warnings'
      Merge branch 'resil-nhgroups-netdevsim-selftests'
      Merge branch 'mptcp-Include-multiple-address-ids-in-RM_ADDR'
      Merge branch 'sh_eth-reg-defs'
      Merge branch 'hns3-imp-phys'
      Merge branch 'pps-policing'
      Merge tag 'batadv-next-pullrequest-20210312' of git://git.open-mesh.org/linux-merge
      Merge branch 'dsa-hewllcreek-dumps'
      Merge branch 'pktgen-scripts-improvements'
      Merge branch 'gro-micro-optimize-dev_gro_receive'
      Merge branch 'skbuff-micro-optimize-flow-dissection'
      Merge branch 'psample-Add-additional-metadata-attributes'
      Merge branch 'net-pcs-stmmac=add-C37-AN-SGMII-support'
      Merge branch 'stmmac-clocks'
      Merge branch 'net-qualcomm-rmnet-stop-using-C-bit-fields'
      Merge branch 'ionic-tx-updates'
      Merge branch 'ipa-qmi-fixes'
      Merge branch 'bcm6368'
      Merge branch 'bridge-m,cast-cleanups'
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'switchdev-dsa-docs'
      Merge branch 'dpaa2-switch-small-cleanup'
      Merge branch 'mlxsw-Add-support-for-egress-and-policy-based-sampling'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'ocelot-mrp'
      Revert "net: socket: use BIT() for MSG_*"
      Merge tag 'mlx5-updates-2021-03-16' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'ethtool-strings'
      Merge branch 'tipc-cleanups-and-simplifications'
      Merge branch 'b53-legacy-tags'
      Merge branch 'mlxsw-vlan-=vxlan'
      Merge branch 'octeontx2-refactor'
      Merge branch 'dsa-doc-fixups'
      Merge branch 'mv88e6393x'
      Merge branch 'octeon-tc-offloads'
      Merge branch 'stmmac-vlan-priority-rx-steering'
      Merge branch 'stmmac-EST-interrupts-and-ethtool'
      Merge branch 'net-xps-improve-the-xps-maps-handling'
      Merge branch 's390-qeth-next'
      Merge branch 'ipa-32bit'
      Merge branch 'mv88e6xxx-offload-bridge-flags'
      Merge branch 'ionic-fixes'
      Merge branch 'gro-retpoline'
      Merge branch 'hinic-cleanups'
      hinic: Remove unused variable.
      Merge branch 'mscc-VSC8584-fixes'
      Merge branch 'ipa-update-config-data'
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'ipa-cfg-data-updates'
      Merge branch 'actions-semi-ethernet-mac'
      Merge branch 'hns3-flow-director'
      Merge branch 'bnxt_en-Error-recovery-improvements'
      Merge branch 'mlxsw-resil-nexthop-groups-prep'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'lantiq-xrx300-xrx330'
      Merge branch 'dpaa2-switch-offload-port-flags'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next
      Merge branch 'bridge-dsa-sandwiched-LAG'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'hns-cleanups'
      Merge branch 'bridge-mrp-next'
      Merge branch 'netfilter-flowtable'
      Merge branch 'phy-c45-loopback'
      Merge branch 'mlxsw-resilient-nh-groups' Ido Schimmel says:
      Merge branch 'ipa-versions-and-registers'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge branch 'ethtool-FEC'
      Merge branch 'gve-cleanups'
      Merge branch 'ipa-reg-versions'
      Merge branch 'stmmac-multivector-msi'
      Merge branch 'sysctl-less-storage'
      Merge tag 'mlx5-updates-2021-03-24' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'hns3-cleanups'
      Merge branch 'ipa-resource'
      Merge branch 'mptcp-cleanups'
      Merge branch 'ethtool-kdoc-touchups'
      Merge branch 'mld-sleepable'
      Merge branch 'axienet-clock-additions'
      Merge branch 'llc-kdoc'
      Merge branch 'selftests-packets-per-second'
      Merge branch 'ipa-next'
      Merge branch 'hns3-misc'
      Merge branch 'marvell-cleanups'
      Merge branch 'mlxsw-sampling-fixes'
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge tag 'mlx5-updates-2021-03-29' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge tag 'linux-can-next-for-5.13-20210330' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge branch 'rfc8335-probe'
      Merge branch 'obsdolete-todo'
      Merge branch 'net-repeated-words'
      Merge branch 'udp-gro-L4'
      Merge branch 'dpaa2-switch-STP'
      Merge branch 'ionic-cleanups'
      Merge branch 'mptcp-subflow-disconnected'
      Merge branch 'ethtool-fec-netlink'
      Merge branch 'net-coding-style'
      Merge branch 'inet-shrink-netns'
      Merge branch 'nxp-enetc-xdp'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge branch 'ionic-ptp'
      Merge branch 'mptcp-misc'
      Merge branch 'dpaa2-rx-copybreak'
      Merge branch 'stmmac-xdp'
      Merge tag 'mlx5-updates-2021-04-02' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'usbnet-speed'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next
      Merge branch 'mptcp-next'
      Merge tag 'mlx5-updates-2021-04-06' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge tag 'linux-can-next-for-5.13-20210407' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge branch 'marvell10g-updates'
      Merge branch 'ionic-hwtstamp-tweaks'
      Merge branch 'hns3-pm_ops'
      Merge branch 'net-sched-action-tests'
      Merge tag 'batadv-next-pullrequest-20210408' of git://git.open-mesh.org/linux-merge
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge tag 'for-net-next-2021-04-08' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next
      Merge branch 'ethtool-eeprom'
      Merge branch 'veth-gro'
      Merge branch 'ipa-next'
      Merge branch 'bnxt_en-error-recovery'
      Merge branch 'netns-sysctl-isolation'
      Merge branch 'ibmvnic-errors'
      Merge branch 'enetc-ptp'
      Merge tag 'wireless-drivers-next-2021-04-13' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next
      Merge branch 'non-platform-devices-of_get_mac_address'
      Merge tag 'linux-can-next-for-5.13-20210413' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge branch 'ipa-SM8350-SoC'
      Merge branch 'stmmac-xdp-zc'
      Merge branch 'dpaa2-switch-tc-hw-offload'
      Merge branch 'marvell-88x2222-improvements'
      Merge branch '10GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next
      Merge tag 'mlx5-updates-2021-04-13' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge tag 'linux-can-next-for-5.13-20210414' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'hns3-next'
      Merge branch 'ehtool-fec-stats'
      Merge branch 'BR_FDB_LOCAL'
      Merge branch 'mptcp-socket-options'
      Merge branch 'r8152--new-chips'
      Merge branch 'ipa-fw-names'
      Merge branch 'gianfar-mq-polling'
      Merge tag 'mlx5-updates-2021-04-16' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'ethtool-stats'
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'enetc-xdp-fixes'
      Merge branch 'mptcp-fixes-and-tracepoints'
      Merge tag 'wireless-drivers-next-2021-04-18' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next
      Merge branch 'nh-flushing'
      Merge branch 'enetc-flow-control'
      Merge branch 'hns3-next'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next
      Merge branch 'mtk_ppe_offload-fixes'
      Merge branch 'korina-next'
      Merge branch 'tja1103-driver'
      Merge branch 'net-generic-selftest-support'
      Merge tag 'mlx5-updates-2021-04-19' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      korina: Fix conflict with global symbol desc_empty on x86.
      Merge branch 'marvell-phy-hwmon'
      korina: Fix build.
      Merge branch 'mlxsw-refactor-qdisc-offload'
      Merge tag 'mac80211-next-for-net-next-2021-04-20' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next
      Merge branch 'dsa-tag-override'
      Merge branch 'sfc-txq-lookups'
      Merge tag 'wireless-drivers-2021-04-21' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers
      Merge branch 'octeontx2-af-cn10k'
      Merge branch 'mv88e6xxx-small-improvements'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'stmmac-swmac-desc-prefetch'
      Merge branch 'RTL8211E-RGMII-D'
      Merge branch 'mk_eth_soc_fixes-perf-improvements'
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next
      Merge branch 'r8152-adjust-REALTEK_USB_DEVICE'
      Merge tag 'wireless-drivers-next-2021-04-23' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next
      Merge branch 'mlxsw-selftest-fixes'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'mptcp-msg-flags'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge tag 'mlx5-updates-2021-04-21' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'bnxt_en-next'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next
      Merge tag 'linux-can-next-for-5.13-20210426' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge branch 'ocelot-ptp'
      Merge branch 'microchip-ksz88x3'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next

Davide Caratti (2):
      mptcp: drop all sub-options except ADD_ADDR when the echo bit is set
      net/sched: act_ct: fix wild memory access when clearing fragments

Dexuan Cui (3):
      net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)
      net: mana: Use int to check the return value of mana_gd_poll_cq()
      hv_netvsc: Make netvsc/VF binding check both MAC and serial number

Di Zhu (1):
      net: fix a data race when get vlan device

Dmitrii Banshchikov (1):
      bpf: Use MAX_BPF_FUNC_REG_ARGS macro

Dmitry Vyukov (2):
      net: make unregister netdev warning timeout configurable
      net: change netdev_unregister_timeout_secs min value to 1

Du Cheng (1):
      net: sched: tapr: prevent cycle_time == 0 in parse_taprio_schedule

Ederson de Souza (3):
      igb: Redistribute memory for transmit packet buffers when in Qav mode
      igc: Enable internal i225 PPS
      igc: enable auxiliary PHC functions for the i225

Edward Cree (3):
      sfc: farch: fix TX queue lookup in TX flush done handling
      sfc: farch: fix TX queue lookup in TX event handling
      sfc: ef10: fix TX queue lookup in TX event handling

Edwin Peer (4):
      bnxt_en: don't fake firmware response success when PCI is disabled
      bnxt_en: report signal mode in link up messages
      bnxt_en: allow promiscuous mode for trusted VFs
      bnxt_en: allow VF config ops when PF is closed

Eli Cohen (1):
      net/mlx5: Avoid unnecessary operation

Emmanuel Grumbach (10):
      cfg80211: allow specifying a reason for hw_rfkill
      mac80211: clear the beacon's CRC after channel switch
      iwlwifi: mvm: don't allow CSA if we haven't been fully associated
      iwlwifi: remove TCM events
      iwlwifi: don't warn if we can't wait for empty tx queues
      iwlwifi: mvm: don't disconnect immediately if we don't hear beacons after CSA
      iwlwifi: mvm: don't WARN if we can't remove a time event
      cfg80211: fix an htmldoc warning
      mac80211: make ieee80211_vif_to_wdev work when the vif isn't in the driver
      mac80211: properly drop the connection in case of invalid CSA IE

Eric Dumazet (36):
      tcp: plug skb_still_in_host_queue() to TSQ
      tcp: consider using standard rtx logic in tcp_rcv_fastopen_synack()
      tcp: remove obsolete check in __tcp_retransmit_skb()
      net: add CONFIG_PCPU_DEV_REFCNT
      net: set initial device refcount to 1
      inet: use bigger hash table for IP ID generation
      tcp_metrics: tcpm_hash_bucket is strictly local
      sysctl: add proc_dou8vec_minmax()
      ipv4: shrink netns_ipv4 with sysctl conversions
      ipv4: convert ip_forward_update_priority sysctl to u8
      inet: convert tcp_early_demux and udp_early_demux to u8
      tcp: convert elligible sysctls to u8
      ip6_gre: proper dev_{hold|put} in ndo_[un]init methods
      ip6_vti: proper dev_{hold|put} in ndo_[un]init methods
      sit: proper dev_{hold|put} in ndo_[un]init methods
      tcp: fix tcp_min_tso_segs sysctl
      net: fix icmp_echo_enable_probe sysctl
      ip6_tunnel: sit: proper dev_{hold|put} in ndo_[un]init methods
      inet: shrink inet_timewait_death_row by 48 bytes
      inet: shrink netns_ipv4 by another cache line
      ipv4: convert fib_notify_on_flag_change sysctl to u8
      ipv4: convert udp_l3mdev_accept sysctl to u8
      ipv4: convert fib_multipath_{use_neigh|hash_policy} sysctls to u8
      ipv4: convert igmp_link_local_mcast_reports sysctl to u8
      tcp: convert tcp_comp_sack_nr sysctl to u8
      ipv6: convert elligible sysctls to u8
      ipv6: move ip6_dst_ops first in netns_ipv6
      ipv6: remove extra dev_hold() for fallback tunnels
      net: reorganize fields in netns_mib
      tcp: reorder tcp_congestion_ops for better cache locality
      Revert "tcp: Reset tcp connections in SYN-SENT state"
      net/packet: remove data races in fanout operations
      scm: optimize put_cmsg()
      scm: fix a typo in put_cmsg()
      virtio-net: restrict build_skb() use to some arches
      virtio-net: fix use-after-free in page_to_skb()

Eric Lin (2):
      net: ethernet: Fix typo of 'network' in comment
      wl3501: fix typo of 'Networks' in comment

Eric Y.Y. Wong (1):
      mt76: mt76x0u: Add support for TP-Link T2UHP(UN) v1

Erik Flodin (2):
      can: add a note that RECV_OWN_MSGS frames are subject to filtering
      can: proc: fix rcvlist_* header alignment on 64-bit system

Ezequiel Garcia (3):
      arm64: dts: rockchip: Remove unnecessary reset in rk3328.dtsi
      dt-bindings: net: dwmac: Add Rockchip DWMAC support
      dt-bindings: net: convert rockchip-dwmac to json-schema

Felix Fietkau (40):
      net: bridge: resolve forwarding path for VLAN tag actions in bridge devices
      net: ppp: resolve forwarding path for bridge pppoe devices
      net: dsa: resolve forwarding path for dsa slave ports
      netfilter: flowtable: bridge vlan hardware offload and switchdev
      net: ethernet: mtk_eth_soc: fix parsing packets in GDM
      net: ethernet: mtk_eth_soc: add support for initializing the PPE
      net: ethernet: mtk_eth_soc: add flow offloading support
      mt76: add support for 802.3 rx frames
      mt76: mt7915: add rx checksum offload support
      mt76: mt7915: add support for rx decapsulation offload
      mt76: mt7615: fix key set/delete issues
      mt76: mt7615: fix tx skb dma unmap
      mt76: mt7915: fix tx skb dma unmap
      mt76: use threaded NAPI
      mt76: mt7915: fix key set/delete issue
      mt76: mt7915: refresh repeater entry MAC address when setting BSSID
      mt76: mt7615: fix chip reset on MT7622 and MT7663e
      mt76: mt7615: limit firmware log message printk to buffer length
      mt76: mt7915: limit firmware log message printk to buffer length
      mt76: fix potential DMA mapping leak
      mt76: mt7921: remove 80+80 MHz support capabilities
      mt76: mt7615: always add rx header translation tlv when adding stations
      mt76: flush tx status queue on DMA reset
      mt76: add functions for parsing rate power limits from DT
      mt76: mt7615: implement support for using DT rate power limits
      mt76: mt7615: fix hardware error recovery for mt7663
      mt76: mt7615: fix entering driver-own state on mt7663
      mt76: mt7615: load ROM patch before checking patch semaphore status
      net: ethernet: mtk_eth_soc: fix RX VLAN offload
      net: ethernet: mtk_eth_soc: unmap RX data before calling build_skb
      net: ethernet: mtk_eth_soc: use napi_consume_skb
      net: ethernet: mtk_eth_soc: reduce MDIO bus access latency
      net: ethernet: mtk_eth_soc: remove unnecessary TX queue stops
      net: ethernet: mtk_eth_soc: use larger burst size for QDMA TX
      net: ethernet: mtk_eth_soc: increase DMA ring sizes
      net: ethernet: mtk_eth_soc: implement dynamic interrupt moderation
      net: ethernet: mtk_eth_soc: cache HW pointer of last freed TX descriptor
      net: ethernet: mtk_eth_soc: only read the full RX descriptor if DMA is done
      net: ethernet: mtk_eth_soc: reduce unnecessary interrupts
      net: ethernet: mtk_eth_soc: set PPE flow hash as skb hash if present

Flavio Leitner (1):
      openvswitch: Warn over-mtu packets only if iface is UP.

Florent Revest (12):
      selftests/bpf: Fix the ASSERT_ERR_PTR macro
      bpf: Factorize bpf_trace_printk and bpf_seq_printf
      bpf: Add a ARG_PTR_TO_CONST_STR argument type
      bpf: Add a bpf_snprintf helper
      libbpf: Initialize the bpf_seq_printf parameters array field by field
      libbpf: Introduce a BPF_SNPRINTF helper macro
      selftests/bpf: Add a series of tests for bpf_snprintf
      bpf: Notify user if we ever hit a bpf_snprintf verifier bug
      bpf: Remove unnecessary map checks for ARG_PTR_TO_CONST_STR
      bpf: Lock bpf_trace_printk's tmp buf before it is written to
      seq_file: Add a seq_bprintf function
      bpf: Implement formatted output helpers with bstr_printf

Florian Fainelli (6):
      net: dsa: b53: Add debug prints in b53_vlan_enable()
      net: phy: Expose phydev::dev_flags through sysfs
      net: dsa: bcm_sf2: Fill in BCM4908 CFP entries
      Documentation: networking: switchdev: clarify device driver behavior
      net: phy: broadcom: Add statistics for all Gigabit PHYs
      net: bridge: propagate error code and extack from br_mc_disabled_update

Florian Westphal (55):
      netfilter: nf_log_ipv4: rename to nf_log_syslog
      netfilter: nf_log_arp: merge with nf_log_syslog
      netfilter: nf_log_ipv6: merge with nf_log_syslog
      netfilter: nf_log_netdev: merge with nf_log_syslog
      netfilter: nf_log_bridge: merge with nf_log_syslog
      netfilter: nf_log_common: merge with nf_log_syslog
      netfilter: nf_log: add module softdeps
      netfilter: nft_log: perform module load from nf_tables
      mptcp: add mptcp reset option support
      netfilter: ipvs: do not printk on netns creation
      netfilter: nfnetlink: add and use nfnetlink_broadcast
      netfilter: nfnetlink: use net_generic infra
      netfilter: cttimeout: use net_generic infra
      netfilter: nf_defrag_ipv6: use net_generic infra
      netfilter: nf_defrag_ipv4: use net_generic infra
      netfilter: ebtables: use net_generic infra
      netfilter: nf_tables: use net_generic infra for transaction data
      netfilter: x_tables: move known table lists to net_generic infra
      netfilter: conntrack: move sysctl pointer to net_generic infra
      netfilter: conntrack: move ecache dwork to net_generic infra
      net: remove obsolete members from struct net
      net: dccp: use net_generic storage
      netfilter: conntrack: move autoassign warning member to net_generic data
      netfilter: conntrack: move autoassign_helper sysctl to net_generic data
      netfilter: conntrack: move expect counter to net_generic data
      netfilter: conntrack: move ct counter to net_generic data
      netfilter: conntrack: convert sysctls to u8
      mptcp: add skeleton to sync msk socket options to subflows
      mptcp: tag sequence_seq with socket state
      mptcp: setsockopt: handle SO_KEEPALIVE and SO_PRIORITY
      mptcp: setsockopt: handle receive/send buffer and device bind
      mptcp: setsockopt: support SO_LINGER
      mptcp: setsockopt: add SO_MARK support
      mptcp: setsockopt: add SO_INCOMING_CPU
      mptcp: setsockopt: SO_DEBUG and no-op options
      mptcp: sockopt: add TCP_CONGESTION and TCP_INFO
      selftests: mptcp: add packet mark test case
      flow: remove spi key from flowi struct
      xfrm: remove stray synchronize_rcu from xfrm_init
      xfrm: avoid synchronize_rcu during netns destruction
      netfilter: nat: move nf_xfrm_me_harder to where it is used
      netfilter: disable defrag once its no longer needed
      netfilter: ebtables: remove the 3 ebtables pointers from struct net
      netfilter: x_tables: remove ipt_unregister_table
      netfilter: x_tables: add xt_find_table
      netfilter: iptables: unregister the tables by name
      netfilter: ip6tables: unregister the tables by name
      netfilter: arptables: unregister the tables by name
      netfilter: x_tables: remove paranoia tests
      netfilter: xt_nat: pass table to hookfn
      netfilter: ip_tables: pass table pointer via nf_hook_ops
      netfilter: arp_tables: pass table pointer via nf_hook_ops
      netfilter: ip6_tables: pass table pointer via nf_hook_ops
      netfilter: remove all xt_table anchors from struct net
      netfilter: allow to turn off xtables compat layer

Frank Wunderlich (1):
      net: mediatek: add flow offload for mt7623

Gatis Peisenieks (1):
      atl1c: move tx cleanup processing out of interrupt

Geliang Tang (42):
      mptcp: add rm_list in mptcp_out_options
      mptcp: add rm_list_tx in mptcp_pm_data
      mptcp: add rm_list in mptcp_options_received
      mptcp: add rm_list_rx in mptcp_pm_data
      mptcp: remove multi addresses in PM
      mptcp: remove multi subflows in PM
      mptcp: remove multi addresses and subflows in PM
      mptcp: remove a list of addrs when flushing
      selftests: mptcp: add invert argument for chk_rm_nr
      selftests: mptcp: set addr id for removing testcases
      selftests: mptcp: add testcases for removing addrs
      mptcp: drop argument port from mptcp_pm_announce_addr
      mptcp: skip connecting the connected address
      mptcp: drop unused subflow in mptcp_pm_subflow_established
      mptcp: move to next addr when timeout
      selftests: mptcp: add cfg_do_w for cfg_remove
      selftests: mptcp: timeout testcases for multi addresses
      mptcp: export lookup_anno_list_by_saddr
      mptcp: move to next addr when subflow creation fail
      mptcp: drop useless addr_signal clear
      mptcp: send ack for rm_addr
      mptcp: rename mptcp_pm_nl_add_addr_send_ack
      selftests: mptcp: signal addresses testcases
      mptcp: remove all subflows involving id 0 address
      mptcp: unify RM_ADDR and RM_SUBFLOW receiving
      mptcp: remove id 0 address
      selftests: mptcp: add addr argument for del_addr
      selftests: mptcp: remove id 0 address testcases
      mptcp: move flags and ifindex out of mptcp_addr_info
      mptcp: use mptcp_addr_info in mptcp_out_options
      mptcp: drop OPTION_MPTCP_ADD_ADDR6
      mptcp: use mptcp_addr_info in mptcp_options_received
      mptcp: drop MPTCP_ADDR_IPVERSION_4/6
      mptcp: unify add_addr(6)_generate_hmac
      selftests: mptcp: add the net device name testcase
      mptcp: fix format specifiers for unsigned int
      mptcp: export mptcp_subflow_active
      mptcp: add tracepoint in mptcp_subflow_get_send
      mptcp: add tracepoint in get_mapping_status
      mptcp: add tracepoint in ack_update_msk
      mptcp: add tracepoint in subflow_check_data_avail
      mptcp: use mptcp_for_each_subflow in mptcp_close

Gong, Sishuai (1):
      net: fix a concurrency bug in l2tp_tunnel_register()

Grant Grundler (1):
      net: cdc_ether: record speed in status method

Grant Seltzer (1):
      bpf: Add kernel/modules BTF presence checks to bpftool feature command

Grzegorz Siwik (1):
      igb: Add double-check MTA_REGISTER for i210 and i211

Guangbin Huang (7):
      net: hns3: add support for imp-controlled PHYs
      net: hns3: add get/set pause parameters support for imp-controlled PHYs
      net: hns3: add ioctl support for imp-controlled PHYs
      net: hns3: add phy loopback support for imp-controlled PHYs
      net: hns3: remediate a potential overflow risk of bd_num_list
      net: hns3: PF add support for pushing link status to VFs
      net: hns3: VF not request link status when PF support push link status feature

Guo-Feng Fan (4):
      rtw88: 8822c: reorder macro position according to the register number
      rtw88: 8822c: Add gap-k calibration to improve long range performance
      rtw88: 8822c: debug: allow debugfs to enable/disable TXGAPK
      rtw88: 8821c: Don't set RX_FLAG_DECRYPTED if packet has no encryption

Guobin Huang (12):
      mt76: mt7615: remove redundant dev_err call in mt7622_wmac_probe()
      net: dsa: hellcreek: Remove redundant dev_err call in hellcreek_probe()
      net: lantiq: Remove redundant dev_err call in xrx200_probe()
      net: moxa: remove redundant dev_err call in moxart_mac_probe()
      net: mdio: Remove redundant dev_err call in mdio_mux_iproc_probe()
      net: axienet: Remove redundant dev_err call in axienet_probe()
      net: stmmac: remove redundant dev_err call in qcom_ethqos_probe()
      net: mscc: ocelot: remove redundant dev_err call in vsc9959_mdio_bus_alloc()
      rfkill: use DEFINE_SPINLOCK() for spinlock
      mac80211_hwsim: use DEFINE_SPINLOCK() for spinlock
      mt76: mt7615: remove redundant dev_err call in mt7622_wmac_probe()
      rtlwifi: rtl8192de: Use DEFINE_SPINLOCK() for spinlock

Guojia Liao (2):
      net: hns3: split out hclge_tm_vport_tc_info_update()
      net: hns3: expand the tc config command

Gustavo A. R. Silva (24):
      net: fddi: skfp: smt: Replace one-element array with flexible-array member
      net: mscc: ocelot: Fix fall-through warnings for Clang
      net: 3c509: Fix fall-through warnings for Clang
      net: cassini: Fix fall-through warnings for Clang
      decnet: Fix fall-through warnings for Clang
      net: ax25: Fix fall-through warnings for Clang
      net: bridge: Fix fall-through warnings for Clang
      net: core: Fix fall-through warnings for Clang
      net: rose: Fix fall-through warnings for Clang
      net: plip: Fix fall-through warnings for Clang
      qed: Fix fall-through warnings for Clang
      netfilter: Fix fall-through warnings for Clang
      ice: Fix fall-through warnings for Clang
      fm10k: Fix fall-through warnings for Clang
      ixgbe: Fix fall-through warnings for Clang
      igb: Fix fall-through warnings for Clang
      ixgbevf: Fix fall-through warnings for Clang
      e1000: Fix fall-through warnings for Clang
      sctp: Fix out-of-bounds warning in sctp_process_asconf_param()
      flow_dissector: Fix out-of-bounds warning in __skb_flow_bpf_to_target()
      rtl8xxxu: Fix fall-through warnings for Clang
      ethtool: ioctl: Fix out-of-bounds warning in store_link_ksettings_for_user()
      wl3501_cs: Fix out-of-bounds warnings in wl3501_send_pkt
      wl3501_cs: Fix out-of-bounds warnings in wl3501_mgmt_join

Haiyang Zhang (1):
      hv_netvsc: Add error handling while switching data path

Haiyue Wang (12):
      iavf: Add framework to enable ethtool ntuple filters
      iavf: Support IPv4 Flow Director filters
      iavf: Support IPv6 Flow Director filters
      iavf: Support Ethernet Type Flow Director filters
      iavf: Enable flex-bytes support
      iavf: Add framework to enable ethtool RSS config
      iavf: Support for modifying TCP RSS flow hashing
      iavf: Support for modifying UDP RSS flow hashing
      iavf: Support for modifying SCTP RSS flow hashing
      iavf: change the flex-byte support number to macro definition
      iavf: enhance the duplicated FDIR list scan handling
      iavf: redefine the magic number for FDIR GTP-U header fields

Hangbin Liu (1):
      bpf: Remove blank line in bpf helper description comment

Hans Westgaard Ry (1):
      net/mlx4: Treat VFs fair when handling comm_channel_events

Harish Mitty (1):
      iwlwifi: mvm: refactor ACPI DSM evaluation function

Hayes Wang (10):
      r8152: set inter fram gap time depending on speed
      r8152: adjust rtl8152_check_firmware function
      r8152: add help function to change mtu
      r8152: support new chips
      r8152: support PHY firmware for RTL8156 series
      r8152: search the configuration of vendor mode
      r8152: replace return with break for ram code speedup mode timeout
      r8152: remove NCM mode from REALTEK_USB_DEVICE macro
      r8152: redefine REALTEK_USB_DEVICE macro
      r8152: remove some bit operations

He Fengqing (2):
      bpf: Remove unused bpf_load_pointer
      bpf: Remove unused parameter from ___bpf_prog_run

Heiner Kallweit (8):
      r8169: use lower_32_bits/upper_32_bits macros
      r8169: add support for ethtool get_ringparam
      r8169: remove rtl_hw_start_8168c_3
      net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM
      net: fec: use mac-managed PHY PM
      r8169: use mac-managed PHY PM
      r8169: add support for pause ethtool ops
      r8169: keep pause settings on interface down/up cycle

Hengqi Chen (2):
      libbpf: Fix KERNEL_VERSION macro
      bpf, docs: Fix literal block for example code

Hoang Huu Le (1):
      tipc: clean up warnings detected by sparse

Hoang Le (4):
      tipc: convert dest node's address to network order
      tipc: add extack messages for bearer/media failure
      tipc: fix kernel-doc warnings
      tipc: fix unique bearer names sanity check

Horatiu Vultur (6):
      net: ocelot: Add PGID_BLACKHOLE
      net: ocelot: Extend MRP
      net: ocelot: Remove ocelot_xfh_get_cpuq
      net: ocelot: Fix deletetion of MRP entries from MAC table
      bridge: mrp: Disable roles before deleting the MRP instance
      net: ocelot: Simplify MRP deletion

Huazhong Tan (12):
      net: hns: remove unused get_autoneg()
      net: hns: remove unused set_autoneg()
      net: hns: remove unused set_rx_ignore_pause_frames()
      net: hns: remove unused config_half_duplex()
      net: hns: remove unused NIC_LB_TEST_RX_PKG_ERR
      net: hns: remove unused HNS_LED_PC_REG
      net: hns3: remove unused parameter from hclge_dbg_dump_loopback()
      net: hns3: fix prototype warning
      net: hns3: fix some typos in hclge_main.c
      net: hns3: remove a duplicate pf reset counting
      net: hns3: cleanup inappropriate spaces in struct hlcgevf_tqp_stats
      net: hns3: change the value of the SEPARATOR_VALUE macro in hclgevf_main.c

Ian Denhardt (2):
      tools, bpf_asm: Hard error on out of range jumps
      tools, bpf_asm: Exit non-zero on errors

Ido Schimmel (77):
      sched: act_sample: Implement stats_update callback
      nexthop: Add netlink defines and enumerators for resilient NH groups
      nexthop: Add data structures for resilient group notifications
      nexthop: Allow setting "offload" and "trap" indication of nexthop buckets
      nexthop: Allow reporting activity of nexthop buckets
      mlxsw: spectrum_span: Add SPAN session identifier support
      mlxsw: reg: Extend mirroring registers with probability rate field
      mlxsw: spectrum_span: Add SPAN probability rate support
      mlxsw: spectrum_matchall: Split sampling support between ASICs
      mlxsw: spectrum_trap: Split sampling traps between ASICs
      mlxsw: spectrum_matchall: Implement sampling using mirroring
      netdevsim: Create a helper for setting nexthop hardware flags
      netdevsim: Add support for resilient nexthop groups
      netdevsim: Allow reporting activity on nexthop buckets
      selftests: fib_nexthops: Declutter test output
      selftests: fib_nexthops: List each test case in a different line
      selftests: fib_nexthops: Test resilient nexthop groups
      selftests: forwarding: Add resilient hashing test
      selftests: forwarding: Add resilient multipath tunneling nexthop test
      selftests: netdevsim: Add test for resilient nexthop groups offload API
      psample: Encapsulate packet metadata in a struct
      psample: Add additional metadata attributes
      netdevsim: Add dummy psample implementation
      selftests: netdevsim: Test psample functionality
      mlxsw: pci: Add more metadata fields to CQEv2
      mlxsw: Create dedicated field for Rx metadata in skb control block
      mlxsw: pci: Set extra metadata in skb control block
      mlxsw: spectrum: Remove unnecessary RCU read-side critical section
      mlxsw: spectrum: Remove mlxsw_sp_sample_receive()
      mlxsw: spectrum: Report extra metadata to psample module
      selftests: mlxsw: Add tc sample tests
      mlxsw: spectrum_matchall: Propagate extack further
      mlxsw: spectrum_matchall: Push sampling checks to per-ASIC operations
      mlxsw: spectrum_matchall: Pass matchall entry to sampling operations
      mlxsw: spectrum: Track sampling triggers in a hash table
      mlxsw: spectrum: Start using sampling triggers hash table
      mlxsw: spectrum_matchall: Add support for egress sampling
      mlxsw: core_acl_flex_actions: Add mirror sampler action
      mlxsw: spectrum_acl: Offload FLOW_ACTION_SAMPLE
      selftests: mlxsw: Add tc sample tests for new triggers
      selftests: mlxsw: Test egress sampling limitation on Spectrum-1 only
      mlxsw: spectrum_router: Remove RTNL assertion
      mlxsw: spectrum_router: Consolidate nexthop helpers
      mlxsw: spectrum_router: Only provide MAC address for valid nexthops
      mlxsw: spectrum_router: Adjust comments on nexthop fields
      mlxsw: spectrum_router: Introduce nexthop action field
      mlxsw: spectrum_router: Prepare for nexthops with trap action
      mlxsw: spectrum_router: Add nexthop trap action support
      mlxsw: spectrum_router: Rename nexthop update function to reflect its type
      mlxsw: spectrum_router: Encapsulate nexthop update in a function
      mlxsw: spectrum_router: Break nexthop group entry validation to a separate function
      mlxsw: spectrum_router: Avoid unnecessary neighbour updates
      mlxsw: spectrum_router: Create per-ASIC router operations
      mlxsw: spectrum_router: Encode adjacency group size ranges in an array
      mlxsw: spectrum_router: Add Spectrum-{2, 3} adjacency group size ranges
      mlxsw: spectrum_router: Add support for resilient nexthop groups
      mlxsw: spectrum_router: Add ability to overwrite adjacency entry only when inactive
      mlxsw: spectrum_router: Pass payload pointer to nexthop update function
      mlxsw: spectrum_router: Add nexthop bucket replacement support
      mlxsw: spectrum_router: Update hardware flags on nexthop buckets
      mlxsw: reg: Add Router Adjacency Table Activity Dump Register
      mlxsw: spectrum_router: Periodically update activity of nexthop buckets
      mlxsw: spectrum_router: Enable resilient nexthop groups to be programmed
      selftests: mlxsw: Test unresolved neigh trap with resilient nexthop groups
      selftests: mlxsw: Add resilient nexthop groups configuration tests
      mlxsw: spectrum_matchall: Perform protocol check earlier
      mlxsw: spectrum_matchall: Convert if statements to a switch statement
      mlxsw: spectrum_matchall: Perform priority checks earlier
      selftests: mlxsw: Test matchall failure with protocol match
      mlxsw: spectrum: Veto sampling if already enabled on port
      selftests: mlxsw: Test vetoing of double sampling
      mlxsw: spectrum_router: Only perform atomic nexthop bucket replacement when requested
      netfilter: Dissect flow after packet mangling
      selftests: fib_tests: Add test cases for interaction with mangling
      nexthop: Restart nexthop dump based on last dumped nexthop identifier
      selftests: fib_nexthops: Test large scale nexthop flushing
      netdevsim: Only use sampling truncation length when valid

Ignat Korchagin (1):
      sfc: adjust efx->xdp_tx_queue_count with the real number of initialized queues

Igor Russkikh (2):
      samples: pktgen: allow to specify delay parameter via new opt
      samples: pktgen: new append mode

Ilan Peer (3):
      cfg80211: Remove wrong RNR IE validation check
      iwlwifi: mvm: Add support for 6GHz passive scan
      nl80211: Add new RSNXE related nl80211 extended features

Ilya Leoshkevich (14):
      selftests/bpf: Copy extras in out-of-srctree builds
      bpf: Add BTF_KIND_FLOAT to uapi
      libbpf: Fix whitespace in btf_add_composite() comment
      libbpf: Add BTF_KIND_FLOAT support
      tools/bpftool: Add BTF_KIND_FLOAT support
      selftests/bpf: Use the 25th bit in the "invalid BTF_INFO" test
      bpf: Add BTF_KIND_FLOAT support
      selftest/bpf: Add BTF_KIND_FLOAT tests
      selftests/bpf: Add BTF_KIND_FLOAT to the existing deduplication tests
      bpf: Document BTF_KIND_FLOAT in btf.rst
      selftests/bpf: Add BTF_KIND_FLOAT to test_core_reloc_size
      selftests/bpf: Add BTF_KIND_FLOAT to btf_dump_test_case_syntax
      s390/bpf: Implement new atomic ops
      bpf: Generate BTF_KIND_FLOAT when linking vmlinux

Ilya Lipnitskiy (5):
      net: dsa: mt7530: clean up core and TRGMII clock setup
      net: ethernet: mediatek: ppe: fix busy wait loop
      net: ethernet: mtk_eth_soc: fix build_skb cleanup
      net: ethernet: mtk_eth_soc: rework NAPI callbacks
      net: ethernet: mtk_eth_soc: use iopoll.h macro for DMA init

Ilya Maximets (1):
      openvswitch: meter: remove rate from the bucket size calculation

Ioana Ciornei (39):
      staging: dpaa2-switch: remove broken learning and flooding support
      staging: dpaa2-switch: fix up initial forwarding configuration done by firmware
      staging: dpaa2-switch: remove obsolete .ndo_fdb_{add|del} callbacks
      staging: dpaa2-switch: get control interface attributes
      staging: dpaa2-switch: setup buffer pool and RX path rings
      staging: dpaa2-switch: setup dpio
      staging: dpaa2-switch: handle Rx path on control interface
      staging: dpaa2-switch: add .ndo_start_xmit() callback
      staging: dpaa2-switch: enable the control interface
      staging: dpaa2-switch: properly setup switching domains
      staging: dpaa2-switch: move the notifier register to module_init()
      staging: dpaa2-switch: accept only vlan-aware upper devices
      staging: dpaa2-switch: add fast-ageing on bridge leave
      staging: dpaa2-switch: prevent joining a bridge while VLAN uppers are present
      staging: dpaa2-switch: move the driver out of staging
      dpaa2-switch: remove unused ABI functions
      dpaa2-switch: fix kdoc warnings
      dpaa2-switch: reduce the size of the if_id bitmap to 64 bits
      dpaa2-switch: fit the function declaration on the same line
      dpaa2-eth: fixup kdoc warnings
      dpaa2-switch: move the dpaa2_switch_fdb_set_egress_flood function
      dpaa2-switch: refactor the egress flooding domain setup
      dpaa2-switch: add support for configuring learning state per port
      dpaa2-switch: add support for configuring per port broadcast flooding
      dpaa2-switch: add support for configuring per port unknown flooding
      dpaa2-switch: mark skbs with offload_fwd_mark
      dpaa2-switch: fix the translation between the bridge and dpsw STP states
      dpaa2-switch: create and assign an ACL table per port
      dpaa2-switch: keep track of the current learning state per port
      dpaa2-switch: trap STP frames to the CPU
      dpaa2-switch: setup learning state on STP state change
      dpaa2-eth: rename dpaa2_eth_xdp_release_buf into dpaa2_eth_recycle_buf
      dpaa2-eth: add rx copybreak support
      dpaa2-eth: export the rx copybreak value as an ethtool tunable
      dpaa2-switch: create a central dpaa2_switch_acl_tbl structure
      dpaa2-switch: install default STP trap rule with the highest priority
      dpaa2-switch: add tc flower hardware offload on ingress traffic
      dpaa2-switch: add tc matchall filter support
      dpaa2-switch: reuse dpaa2_switch_acl_entry_add() for STP frames trap

Ivan Bornyakov (5):
      net: phy: add Marvell 88X2222 transceiver support
      net: phy: marvell-88x2222: check that link is operational
      net: phy: marvell-88x2222: move read_status after config_aneg
      net: phy: marvell-88x2222: swap 1G/10G modes on autoneg
      net: phy: marvell-88x2222: enable autoneg by default

Jacob Keller (1):
      ice: replace custom AIM algorithm with kernel's DIM library

Jakub Kicinski (40):
      docs: net: tweak devlink health documentation
      docs: net: add missing devlink health cmd - trigger
      ethtool: fec: fix typo in kdoc
      ethtool: fec: remove long structure description
      ethtool: fec: sanitize ethtool_fecparam->reserved
      ethtool: fec: sanitize ethtool_fecparam->active_fec
      ethtool: fec: sanitize ethtool_fecparam->fec
      ethtool: clarify the ethtool FEC interface
      ethtool: fec: add note about reuse of reserved
      ethtool: fec: fix FEC_NONE check
      ethtool: document the enum values not defines
      ethtool: support FEC settings over netlink
      netdevsim: add FEC settings support
      selftests: ethtool: add a netdevsim FEC test
      docs: ethtool: correct quotes
      ethtool: document PHY tunable callbacks
      Merge branch 'net-make-phy-pm-ops-a-no-op-if-mac-driver-manages-phy-pm'
      Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'net-ipa-a-few-small-fixes'
      ethtool: move ethtool_stats_init
      ethtool: fec_prepare_data() - jump to error handling
      ethtool: add FEC statistics
      bnxt: implement ethtool::get_fec_stats
      sfc: ef10: implement ethtool::get_fec_stats
      mlx5: implement ethtool::get_fec_stats
      docs: networking: extend the statistics documentation
      docs: ethtool: document standard statistics
      ethtool: add a new command for reading standard stats
      ethtool: add interface to read standard MAC stats
      ethtool: add interface to read standard MAC Ctrl stats
      ethtool: add interface to read RMON stats
      mlxsw: implement ethtool standard stats
      bnxt: implement ethtool standard stats
      mlx5: implement ethtool standard stats
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      bnxt: add more ethtool standard stats
      ethtool: stats: clarify the initialization to ETHTOOL_STAT_NOT_SET
      ethtool: add missing EEPROM to list of messages
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next

James Prestwood (1):
      nl80211: better document CMD_ROAM behavior

Jean-Philippe Brucker (2):
      libbpf: Fix arm64 build
      selftests/bpf: Fix typo in Makefile

Jeb Cramer (1):
      ice: Limit forced overrides based on FW version

Jesse Brandeburg (7):
      intel: clean up mismatched header comments
      ice: refactor interrupt moderation writes
      ice: manage interrupts during poll exit
      ice: refactor ITR data structures
      ice: print name in /proc/iomem
      ice: use local for consistency
      ice: remove unused struct member

Jethro Beekman (1):
      macvlan: Add nodst option to macvlan type source

Jian Shen (11):
      net: hns3: refactor out hclge_add_fd_entry()
      net: hns3: refactor out hclge_fd_get_tuple()
      net: hns3: refactor for function hclge_fd_convert_tuple
      net: hns3: add support for traffic class tuple support for flow director by ethtool
      net: hns3: refactor flow director configuration
      net: hns3: refine for hns3_del_all_fd_entries()
      net: hns3: add support for user-def data of flow director
      net: hns3: remove unused code of vmdq
      net: hns3: fix missing rule state assignment
      net: hns3: fix use-after-free issue for hclge_add_fd_entry_common()
      net: hns3: remove the rss_size limitation by vector num

Jianbo Liu (1):
      net/mlx5: DR, Use variably sized data structures for different actions

Jianlin Lv (2):
      bonding: Added -ENODEV interpret for slaves option
      bpf: Remove insn_buf[] declaration in inner block

Jiapeng Chong (24):
      bpf: Simplify the calculation of variables
      selftests/bpf: Simplify the calculation of variables
      selftests/bpf: Fix warning comparing pointer to 0
      bpf: Fix warning comparing pointer to 0
      netdevsim: fib: Remove redundant code
      esp4: Simplify the calculation of variables
      net/mlx5: remove unneeded semicolon
      selftests/bpf: Fix warning comparing pointer to 0
      cxgb4: Remove redundant NULL check
      ppp: deflate: Remove useless call "zlib_inflateEnd"
      mt76: mt7921: remove unneeded semicolon
      atm: idt77252: remove unused function
      wil6210: wmi: Remove useless code
      bcma: remove unused function
      ch_ktls: Remove redundant variable result
      pcnet32: Remove redundant variable prev_link and curr_link
      net: davicom: Remove redundant assignment to ret
      rxrpc: rxkad: Remove redundant variable offset
      rds: Remove redundant assignment to nr_sig
      net/tls: Remove redundant initialization of record
      llc2: Remove redundant assignment to rc
      mpls: Remove redundant assignment to err
      net/smc: Remove redundant assignment to rc
      net: netrom: nr_in: Remove redundant assignment to ns

Jiapeng Zhong (1):
      igc: Assign boolean values to a bool variable

Jiaran Zhang (3):
      net: hns3: remove redundant query in hclge_config_tm_hw_err_int()
      net: hns3: change flr_prepare/flr_done function names
      net: hns3: add suspend and resume pm_ops

Jiri Kosina (2):
      Bluetooth: avoid deadlock between hci_dev->lock and socket lock
      iwlwifi: Fix softirq/hardirq disabling in iwl_pcie_gen2_enqueue_hcmd()

Jiri Olsa (8):
      selftests/bpf: Fix test_attach_probe for powerpc uprobes
      selftests/bpf: Add docs target as all dependency
      bpf: Allow trampoline re-attach for tracing and lsm programs
      selftests/bpf: Add re-attach test to fentry_test
      selftests/bpf: Add re-attach test to fexit_test
      selftests/bpf: Add re-attach test to lsm test
      selftests/bpf: Test that module can't be unloaded with attached trampoline
      selftests/bpf: Use ASSERT macros in lsm test

Joakim Zhang (3):
      net: stmmac: add clocks management for gmac driver
      net: stmmac: add platform level clocks management
      net: stmmac: dwmac-imx: add platform level clocks management for i.MX

Joe Perches (1):
      cfg80211: constify ieee80211_get_response_rate return

Joe Stringer (16):
      bpf: Import syscall arg documentation
      bpf: Add minimal bpf() command documentation
      bpf: Document BPF_F_LOCK in syscall commands
      bpf: Document BPF_PROG_PIN syscall command
      bpf: Document BPF_PROG_ATTACH syscall command
      bpf: Document BPF_PROG_TEST_RUN syscall command
      bpf: Document BPF_PROG_QUERY syscall command
      bpf: Document BPF_MAP_*_BATCH syscall commands
      scripts/bpf: Abstract eBPF API target parameter
      scripts/bpf: Add syscall commands printer
      tools/bpf: Remove bpf-helpers from bpftool docs
      selftests/bpf: Templatize man page generation
      selftests/bpf: Test syscall command parsing
      docs/bpf: Add bpf() syscall command reference
      tools: Sync uapi bpf.h header with latest changes
      bpf: Document PROG_TEST_RUN limitations

Johan Almbladh (1):
      mac80211: Set priority and queue mapping for injected frames

Johan Hovold (3):
      net: cdc_ncm: drop redundant driver-data assignment
      net: wan: z85230: drop unused async state
      net: hso: fix NULL-deref on disconnect regression

Johannes Berg (19):
      mac80211: don't apply flow control on management frames
      mac80211: bail out if cipher schemes are invalid
      iwlwifi: pcie: avoid unnecessarily taking spinlock
      iwlwifi: pcie: normally grab NIC access for inflight-hcmd
      iwlwifi: pcie: make cfg vs. trans_cfg more robust
      iwlwifi: mvm: write queue_sync_state only for sync
      iwlwifi: mvm: clean up queue sync implementation
      iwlwifi: remove remaining software checksum code
      iwlwifi: mvm: don't lock mutex in RCU critical section
      iwlwifi: warn on SKB free w/o op-mode
      iwlwifi: trans/pcie: defer transport initialisation
      iwlwifi: fw: print out trigger delay when collecting data
      iwlwifi: pcie: don't enable BHs with IRQs disabled
      mac80211: properly process TXQ management frames
      mac80211: aes_cmac: check crypto_shash_setkey() return value
      wireless: align some HE capabilities with the spec
      wireless: align HE capabilities A-MPDU Length Exponent Extension
      wireless: fix spelling of A-MSDU in HE capabilities
      cfg80211: scan: drop entry from hidden_list on overflow

John Fastabend (1):
      bpf, selftests: test_maps generating unrecognized data section

Jon Maloy (17):
      tipc: re-organize members of struct publication
      tipc: move creation of publication item one level up in call chain
      tipc: introduce new unified address type for internal use
      tipc: simplify signature of tipc_namtbl_publish()
      tipc: simplify call signatures for publication creation
      tipc: simplify signature of tipc_nametbl_withdraw() functions
      tipc: rename binding table lookup functions
      tipc: refactor tipc_sendmsg() and tipc_lookup_anycast()
      tipc: simplify signature of tipc_namtbl_lookup_mcast_sockets()
      tipc: simplify signature of tipc_nametbl_lookup_mcast_nodes()
      tipc: simplify signature of tipc_nametbl_lookup_group()
      tipc: simplify signature of tipc_service_find_range()
      tipc: simplify signature of tipc_find_service()
      tipc: simplify api between binding table and topology server
      tipc: add host-endian copy of user subscription to struct tipc_subscription
      tipc: remove some unnecessary warnings
      tipc: fix htmldoc and smatch warnings

Jonathan McDowell (1):
      net: stmmac: Set FIFO sizes for ipq806x

Jonathan Neuschäfer (1):
      docs: networking: phy: Improve placement of parenthesis

Jonathon Reinhart (2):
      net: Ensure net namespace isolation of sysctls
      netfilter: conntrack: Make global sysctls readonly in non-init netns

Jostar Yang (1):
      ixgbe: Support external GBE SerDes PHY BCM54616s

Julian Wiedmann (3):
      s390/qeth: allocate initial TX Buffer structs with GFP_KERNEL
      s390/qeth: enable napi_consume_skb() for pending TX buffers
      s390/qeth: remove RX VLAN filter stubs in L3 driver

Julien Massonneau (2):
      seg6: add support for IPv4 decapsulation in ipv6_srh_rcv()
      seg6: ignore routing header with segments left equal to 0

Junlin Yang (3):
      esp6: remove a duplicative condition
      net/mlx5: use kvfree() for memory allocated with kvzalloc()
      mt76: Convert to DEFINE_SHOW_ATTRIBUTE

KP Singh (4):
      selftests/bpf: Propagate error code of the command to vmtest.sh
      libbpf: Add explicit padding to btf_dump_emit_type_decl_opts
      selftests/bpf: Better error messages for ima_setup.sh failures
      selftests/bpf: Add an option for a debug shell in vmtest.sh

Kai Ye (1):
      Bluetooth: use the correct print format for L2CAP debug statements

Kalle Valo (7):
      ath11k: print hardware name and version during initialisation
      ath11k: qmi: add more debug messages
      ath11k: qmi: cosmetic changes to error messages
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge tag 'mt76-for-kvalo-2021-04-12' of https://github.com/nbd168/wireless
      Merge tag 'iwlwifi-next-for-kalle-2021-04-12-v2' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      Merge tag 'mt76-for-kvalo-2021-04-21' of https://github.com/nbd168/wireless

Karthikeyan Periyasamy (5):
      ath11k: add static window support for register access
      ath11k: add hal support for QCN9074
      ath11k: add data path support for QCN9074
      ath11k: add CE interrupt support for QCN9074
      ath11k: add extended interrupt support for QCN9074

Kiran K (2):
      Bluetooth: btusb: print firmware file name on error loading firmware
      Bluetooth: btintel: Fix offset calculation boot address parameter

Krzysztof Kozlowski (1):
      net: smsc911x: skip acpi_device_id table when !CONFIG_ACPI

Kunihiko Hayashi (2):
      ARM: dts: uniphier: Change phy-mode to RGMII-ID to enable delay pins for RTL8211E
      arm64: dts: uniphier: Change phy-mode to RGMII-ID to enable delay pins for RTL8211E

Kurt Kanzenbach (7):
      net: dsa: hellcreek: Add devlink VLAN region
      net: dsa: hellcreek: Use boolean value
      net: dsa: hellcreek: Move common code to helper
      net: dsa: hellcreek: Add devlink FDB region
      net: dsa: hellcreek: Offload bridge port flags
      taprio: Handle short intervals and large packets
      net: dsa: hellcreek: Report switch name and ID

Lavanya Suresh (3):
      ath11k: Fix sounding dimension config in HE cap
      ath11k: Enable radar detection for 160MHz secondary segment
      ath11k: Add support for STA to handle beacon miss

Lee Gibson (1):
      qtnfmac: Fix possible buffer overflow in qtnf_event_handle_external_auth

Lee Jones (5):
      ptp_pch: Remove unused function 'pch_ch_control_read()'
      ptp_pch: Move 'pch_*()' prototypes to shared header
      ptp: ptp_clockmatrix: Demote non-kernel-doc header to standard comment
      ptp: ptp_p: Demote non-conformant kernel-doc headers and supply a param description
      of: of_net: Provide function name and param description

Leon Romanovsky (9):
      net/mlx5: Remove impossible checks of interface state
      net/mlx5: Separate probe vs. reload flows
      net/mlx5: Remove second FW tracer check
      net/mlx5: Don't rely on interface state bit
      net/mlx5: Check returned value from health recover sequence
      PCI/IOV: Add sysfs MSI-X vector assignment interface
      net/mlx5: Add dynamic MSI-X capabilities bits
      net/mlx5: Dynamically assign MSI-X vectors count
      net/mlx5: Implement sriov_get_vf_total_msix/count() callbacks

Li RongQing (1):
      xsk: Align XDP socket batch size with DPDK

Lijun Pan (6):
      ibmvnic: clean up the remaining debugfs data structures
      ibmvnic: print reset reason as a string
      ibmvnic: print adapter state as a string
      ibmvnic: improve failover sysfs entry
      ibmvnic: queue reset work in system_long_wq
      MAINTAINERS: update

Linus Lüssing (2):
      batman-adv: Fix order of kernel doc in batadv_priv
      net: bridge: mcast: fix broken length + header check for MRDv6 Adv.

Linus Walleij (8):
      Bluetooth: btbcm: Rewrite bindings in YAML and add reset
      Bluetooth: btbcm: Obtain and handle reset GPIO
      Bluetooth: btbcm: Add BCM4334 DT binding
      Bluetooth: btbcm: Add BCM4330 and BCM4334 compatibles
      net: ethernet: ixp4xx: Set the DMA masks explicitly
      net: ethernet: ixp4xx: Add DT bindings
      net: ethernet: ixp4xx: Retire ancient phy retrieveal
      net: ethernet: ixp4xx: Support device tree probing

Liu Jian (2):
      farsync: use DEFINE_SPINLOCK() for spinlock
      net: hns3: no return statement in hclge_clear_arfs_rules

Liu xuzhi (1):
      kernel/bpf/: Fix misspellings using codespell tool

Loic Poulain (7):
      net: mhi: Add support for non-linear MBIM skb processing
      net: mhi: Allow decoupled MTU/MRU
      net: Add a WWAN subsystem
      net: Add Qcom WWAN control driver
      net: wwan: Fix bit ops double shift
      net: wwan: mhi_wwan_ctrl: Fix RX buffer starvation
      net: wwan: core: Return poll error in case of port removal

Lokendra Singh (3):
      Bluetooth: btintel: Reorganized bootloader mode tlv checks in intel_version_tlv parsing
      Bluetooth: btintel: Collect tlv based active firmware build info in FW mode
      Bluetooth: btintel: Skip reading firmware file version while in bootloader mode

Lorenz Bauer (5):
      bpf: Consolidate shared test timing code
      bpf: Add PROG_TEST_RUN support for sk_lookup programs
      selftests: bpf: Convert sk_lookup ctx access tests to PROG_TEST_RUN
      selftests: bpf: Check that PROG_TEST_RUN repeats as requested
      selftests: bpf: Don't run sk_lookup in verifier tests

Lorenzo Bianconi (82):
      net: export dev_set_threaded symbol
      bpf, devmap: Move drop error path to devmap for XDP_REDIRECT
      mac80211: set sk_pacing_shift for 802.3 txpath
      mt7601u: enable TDLS support
      mt76: mt7915: enable hw rx-amsdu de-aggregation
      mt76: mt7921: enable random mac addr during scanning
      mt76: mt7921: removed unused definitions in mcu.h
      mt76: connac: always check return value from mt76_connac_mcu_alloc_wtbl_req
      mt76: mt7915: always check return value from mt7915_mcu_alloc_wtbl_req
      mt76: mt7615: fix memory leak in mt7615_coredump_work
      mt76: mt7921: fix aggr length histogram
      mt76: mt7915: fix aggr len debugfs node
      mt76: mt7921: fix stats register definitions
      mt76: mt7615: fix mib stats counter reporting to mac80211
      mt76: connac: fix kernel warning adding monitor interface
      mt76: check return value of mt76_txq_send_burst in mt76_txq_schedule_list
      mt76: mt7921: get rid of mt7921_sta_rc_update routine
      mt76: mt7921: check mcu returned values in mt7921_start
      mt76: mt7921: reduce mcu timeouts for suspend, offload and hif_ctrl msg
      mt76: introduce mcu_reset function pointer in mt76_mcu_ops structure
      mt76: mt7921: introduce mt7921_run_firmware utility routine.
      mt76: mt7921: introduce __mt7921_start utility routine
      mt76: dma: introduce mt76_dma_queue_reset routine
      mt76: dma: export mt76_dma_rx_cleanup routine
      mt76: mt7921: add wifi reset support
      mt76: mt7921: remove leftovers from dbdc configuration
      mt76: mt7921: remove duplicated macros in mcu.h
      mt76: mt7921: get rid of mt7921_mac_wtbl_lmac_addr
      mt76: connac: introduce mt76_sta_cmd_info data structure
      mt76: mt7921: properly configure rcpi adding a sta to the fw
      dt-bindings:net:wireless:ieee80211: txt to yaml conversion
      dt-bindings:net:wireless:mediatek,mt76: txt to yaml conversion
      mt76: mt7921: fix key set/delete issue
      mt76: mt7921: always wake the device in mt7921_remove_interface
      mt76: mt7921: rework mt7921_mcu_debug_msg_event routine
      mt76: mt7921: introduce MT_WFDMA_DUMMY_CR definition
      mt76: mt7921: introduce MCU_EVENT_LP_INFO event parsing
      mt76: mt7921: add rcu section in mt7921_mcu_tx_rate_report
      mt76: mt7921: add mt7921_dma_cleanup in mt7921_unregister_device
      dt-bindings:net:wireless:mediatek,mt76: introduce power-limits node
      mt76: mt7615: do not use mt7615 single-sku values for mt7663
      mt76: introduce single-sku support for mt7663/mt7921
      mt76: mt7921: move hw configuration in mt7921_register_device
      mt76: improve mcu error logging
      mt76: mt7921: run mt7921_mcu_fw_log_2_host holding mt76 mutex
      mt76: mt7921: do not use 0 as NULL pointer
      mt76: connac: move mcu_update_arp_filter in mt76_connac module
      mt76: mt7921: remove leftover function declaration
      mt76: mt7921: fix a race between mt7921_mcu_drv_pmctrl and mt7921_mcu_fw_pmctrl
      mt76: mt7663: fix a race between mt7615_mcu_drv_pmctrl and mt7615_mcu_fw_pmctrl
      mt76: connac: introduce wake counter for fw_pmctrl synchronization
      mt76: mt7921: rely on mt76_connac_pm_ref/mt76_connac_pm_unref in tx path
      mt76: mt7663: rely on mt76_connac_pm_ref/mt76_connac_pm_unref in tx path
      mt76: dma: add the capability to define a custom rx napi poll routine
      mt76: mt7921: rely on mt76_connac_pm_ref/mt76_connac_pm_unref in tx/rx napi
      mt76: mt7663: rely on mt76_connac_pm_ref/mt76_connac_pm_unref in tx/rx napi
      mt76: connac: unschedule ps_work in mt76_connac_pm_wake
      mt76: connac: check wake refcount in mcu_fw_pmctrl
      mt76: connac: remove MT76_STATE_PM in mac_tx_free
      mt76: mt7921: get rid of useless MT76_STATE_PM in mt7921_mac_work
      mt76: connac: alaways wake the device before scanning
      mt76: mt7615: rely on pm refcounting in mt7615_led_set_config
      mt76: connac: do not run mt76_txq_schedule_all directly
      mt76: connac: use waitqueue for runtime-pm
      mt76: remove MT76_STATE_PM in tx path
      mt76: mt7921: add awake and doze time accounting
      mt76: mt7921: enable sw interrupts
      mt76: mt7921: move mt7921_dma_reset in dma.c
      mt76: mt7921: introduce mt7921_wpdma_reset utility routine
      mt76: mt7921: introduce mt7921_dma_{enable,disable} utilities
      mt76: mt7921: introduce mt7921_wpdma_reinit_cond utility routine
      mt76: move token_lock, token and token_count in mt76_dev
      mt76: move token utilities in mt76 common module
      mt76: mt7921: get rid of mcu_reset function pointer
      mt76: mt7921: improve doze opportunity
      mt76: mt7663: add awake and doze time accounting
      mt76: connac: unschedule mac_work before going to sleep
      mt76: mt7921: introduce mt7921_mcu_sta_add routine
      mt76: debugfs: introduce napi_threaded node
      mt76: move mt76_token_init in mt76_alloc_device
      mt76: mt7921: reinit wpdma during drv_own if necessary
      bpf, cpumap: Bulk skb using netif_receive_skb_list

Lu Wei (11):
      net: Fix a misspell in socket.c
      net: ceph: Fix a typo in osdmap.c
      net: core: Fix a typo in dev_addr_lists.c
      net: decnet: Fix a typo in dn_nsp_in.c
      net: dsa: Fix a typo in tag_rtl4_a.c
      net: ipv4: Fix some typos
      bpf: Remove unused headers
      net: rds: Fix a typo
      net: sctp: Fix some typos
      net: vsock: Fix a typo
      net: hns: Fix some typos

Luca Coelho (1):
      iwlwifi: bump FW API to 63 for AX devices

Luiz Augusto von Dentz (10):
      Bluetooth: SMP: Fail if remote and local public keys are identical
      Bluetooth: L2CAP: Fix not checking for maximum number of DCID
      Bluetooth: SMP: Convert BT_ERR/BT_DBG to bt_dev_err/bt_dev_dbg
      Bluetooth: btintel: Check firmware version before download
      Bluetooth: btintel: Move operational checks after version check
      Bluetooth: btintel: Consolidate intel_version_tlv parsing
      Bluetooth: btintel: Consolidate intel_version parsing
      Bluetooth: btusb: Consolidate code for waiting firmware download
      Bluetooth: btusb: Consolidate code for waiting firmware to boot
      Bluetooth: SMP: Fix variable dereferenced before check 'conn'

Lv Yunlong (4):
      mwl8k: Fix a double Free in mwl8k_probe_hw
      ath10k: Fix a use after free in ath10k_htc_send_bundle
      net:emac/emac-mac: Fix a use after free in emac_mac_tx_buf_send
      net:nfc:digital: Fix a double free in digital_tg_recv_dep_req

Maciej Fijalkowski (14):
      selftests: xsk: Don't call worker_pkt_dump() for stats test
      selftests: xsk: Remove struct ifaceconfigobj
      selftests: xsk: Remove unused function
      selftests: xsk: Remove inline keyword from source file
      selftests: xsk: Simplify frame traversal in dumping thread
      libbpf: xsk: Use bpf_link
      samples: bpf: Do not unload prog within xdpsock
      selftests: xsk: Remove thread for netns switch
      selftests: xsk: Split worker thread
      selftests: xsk: Remove Tx synchronization resources
      selftests: xsk: Refactor teardown/bidi test cases and testapp_validate
      selftests: xsk: Remove sync_mutex_tx and atomic var
      veth: Implement ethtool's get_channels() callback
      selftests: xsk: Implement bpf_link test

Maciej W. Rozycki (7):
      FDDI: if_fddi.h: Update my e-mail address
      FDDI: defxx: Update my e-mail address
      FDDI: defza: Update my e-mail address
      FDDI: defxx: Bail out gracefully with unassigned PCI resource for CSR
      FDDI: defxx: Make MMIO the configuration default except for EISA
      FDDI: defxx: Implement dynamic CSR I/O address space selection
      FDDI: defxx: Use driver's name with resource requests

Magnus Karlsson (4):
      selftest/bpf: Make xsk tests less verbose
      i40e: optimize for XDP_REDIRECT in xsk path
      ixgbe: optimize for XDP_REDIRECT in xsk path
      ice: optimize for XDP_REDIRECT in xsk path

Manoj Basapathi (1):
      tcp: Reset tcp connections in SYN-SENT state

Manu Bretelle (1):
      bpf: Add getter and setter for SO_REUSEPORT through bpf_{g,s}etsockopt

Maor Dickman (2):
      net/mlx5e: Allow to match on ICMP parameters
      net/mlx5: Allocate FC bulk structs with kvzalloc() instead of kzalloc()

Marc Kleine-Budde (33):
      MAINTAINERS: remove Dan Murphy from m_can and tcan4x5x
      can: dev: always create TX echo skb
      can: dev: can_free_echo_skb(): don't crash the kernel if can_priv::echo_skb is accessed out of bounds
      can: dev: can_free_echo_skb(): extend to return can frame length
      can: grcan: add missing Kconfig dependency to HAS_IOMEM
      can: mcp251xfd: add dev coredump support
      can: mcp251xfd: simplify UINC handling
      can: mcp251xfd: move netdevice.h to mcp251xfd.h
      can: mcp251xfd: mcp251xfd_get_timestamp(): move to mcp251xfd.h
      can: mcp251xfd: add HW timestamp infrastructure
      can: mcp251xfd: add HW timestamp to RX, TX and error CAN frames
      can: c_can: convert block comments to network style comments
      can: c_can: remove unnecessary blank lines and add suggested ones
      can: c_can: fix indention
      can: c_can: fix print formating string
      can: c_can: replace double assignments by two single ones
      can: c_can: fix remaining checkpatch warnings
      can: skb: alloc_can{,fd}_skb(): set "cf" to NULL if skb allocation fails
      can: m_can: m_can_receive_skb(): add missing error handling to can_rx_offload_queue_sorted() call
      can: c_can: remove unused enum BOSCH_C_CAN_PLATFORM
      can: mcp251xfd: add BQL support
      can: mcp251xfd: mcp251xfd_regmap_crc_read_one(): Factor out crc check into separate function
      can: mcp251xfd: mcp251xfd_regmap_crc_read(): work around broken CRC on TBC register
      can: peak_usb: fix checkpatch warnings
      can: peak_usb: pcan_usb_pro.h: remove double space in indention
      can: peak_usb: remove unused variables from struct peak_usb_device
      can: peak_usb: remove write only variable struct peak_usb_adapter::ts_period
      can: peak_usb: peak_usb_probe(): make use of driver_info
      can: peak_usb: pcan_usb_{,pro}_get_device_id(): remove unneeded check for device_id
      can: peak_usb: pcan_usb_get_serial(): remove error message from error path
      can: peak_usb: pcan_usb_get_serial(): make use of le32_to_cpup()
      can: peak_usb: pcan_usb_get_serial(): unconditionally assign serial_number
      can: peak_usb: pcan_usb: replace open coded endianness conversion of unaligned data

Marcel Holtmann (10):
      Bluetooth: Fix mgmt status for LL Privacy experimental feature
      Bluetooth: Fix wrong opcode error for read advertising features
      Bluetooth: Add missing entries for PHY configuration commands
      Bluetooth: Move the advertisement monitor events to correct list
      Bluetooth: Increment management interface revision
      Bluetooth: Add support for reading AOSP vendor capabilities
      Bluetooth: Add support for virtio transport driver
      Bluetooth: Fix default values for advertising interval
      Bluetooth: Set defaults for le_scan_{int,window}_adv_monitor
      Bluetooth: Allow Microsoft extension to indicate curve validation

Marcus Folkesson (1):
      wilc1000: write value to WILC_INTR2_ENABLE register

Marek Behún (24):
      net: dsa: mv88e6xxx: wrap .set_egress_port method
      net: dsa: mv88e6xxx: implement .port_set_policy for Amethyst
      net: phy: marvell10g: rename register
      net: phy: marvell10g: fix typo
      net: phy: marvell10g: allow 5gbase-r and usxgmii
      net: phy: marvell10g: indicate 88X33x0 only port control registers
      net: phy: marvell10g: add all MACTYPE definitions for 88X33x0
      net: phy: marvell10g: add MACTYPE definitions for 88E21xx
      net: phy: marvell10g: support all rate matching modes
      net: phy: marvell10g: check for correct supported interface mode
      net: phy: marvell10g: store temperature read method in chip strucutre
      net: phy: marvell10g: support other MACTYPEs
      net: phy: marvell10g: add separate structure for 88X3340
      net: phy: marvell10g: fix driver name for mv88e2110
      net: phy: add constants for 2.5G and 5G speed in PCS speed register
      net: phy: marvell10g: differentiate 88E2110 vs 88E2111
      net: phy: marvell10g: change module description
      MAINTAINERS: add myself as maintainer of marvell10g driver
      net: phy: marvell: refactor HWMON OOP style
      net: phy: marvell: fix HWMON enable register for 6390
      net: phy: marvell: use assignment by bitwise AND operator
      net: dsa: mv88e6xxx: simulate Amethyst PHY model number
      net: phy: marvell: add support for Amethyst internal PHY
      net: phy: marvell: don't use empty switch default case

Marek Vasut (1):
      rsi: Use resume_noirq for SDIO

Mark Bloch (5):
      net/mlx5: E-Switch, Add match on vhca id to default send rules
      net/mlx5: E-Switch, Add eswitch pointer to each representor
      RDMA/mlx5: Use representor E-Switch when getting netdev and metadata
      net/mlx5: E-Switch, Refactor send to vport to be more generic
      net/mlx5: Add IFC bits needed for single FDB mode

Mark Zhang (1):
      net/mlx5: Read congestion counters from all ports when lag is active

Martin KaFai Lau (19):
      bpf: Simplify freeing logic in linfo and jited_linfo
      bpf: Refactor btf_check_func_arg_match
      bpf: Support bpf program calling kernel function
      bpf: Support kernel function call in x86-32
      tcp: Rename bictcp function prefix to cubictcp
      bpf: tcp: Put some tcp cong functions in allowlist for bpf-tcp-cc
      libbpf: Refactor bpf_object__resolve_ksyms_btf_id
      libbpf: Refactor codes for finding btf id of a kernel symbol
      libbpf: Rename RELO_EXTERN to RELO_EXTERN_VAR
      libbpf: Record extern sym relocation first
      libbpf: Support extern kernel function
      bpf: selftests: Rename bictcp to bpf_cubic
      bpf: selftests: Bpf_cubic and bpf_dctcp calling kernel functions
      bpf: selftests: Add kfunc_call test
      bpf: tcp: Fix an error in the bpf_tcp_ca_kfunc_ids list
      bpf: tcp: Limit calling some tcp cc functions to CONFIG_DYNAMIC_FTRACE
      bpf: Update bpf_design_QA.rst to clarify the kfunc call is not ABI
      bpf: selftests: Update clang requirement in README.rst for testing kfunc call
      bpf: selftests: Specify CONFIG_DYNAMIC_FTRACE in the testing config

Martin Schiller (1):
      net: phy: intel-xway: enable integrated led functions

Martin Willi (1):
      net, xdp: Update pkt_type if generic XDP changes unicast MAC

Masanari Iida (1):
      samples: bpf: Fix a spelling typo in do_hbm_test.sh

Mat Martineau (1):
      mptcp: Retransmit DATA_FIN

Matthew Wilcox (Oracle) (1):
      qrtr: Convert qrtr_ports from IDR to XArray

Matthieu Baerts (5):
      selftests: mptcp: avoid calling pm_nl_ctl with bad IDs
      selftests: mptcp: launch mptcp_connect with timeout
      selftests: mptcp: init nstat history
      selftests: mptcp: dump more info on mpjoin errors
      mptcp: revert "mptcp: forbit mcast-related sockopt on MPTCP sockets"

Matti Gottlieb (2):
      iwlwifi: pcie: Add support for Bz Family
      iwlwifi: pcie: Change ma product string name

Maxim Kochetkov (3):
      net: phy: marvell: fix m88e1011_set_downshift
      net: phy: marvell: fix m88e1111_set_downshift
      net: phy: marvell: add downshift support for M88E1240

Maxim Mikityanskiy (5):
      net/mlx5e: Use net_prefetchw instead of prefetchw in MPWQE TX datapath
      net/mlx5e: Allow mlx5e_safe_switch_channels to work with channels closed
      net/mlx5e: Use mlx5e_safe_switch_channels when channels are closed
      net/mlx5e: Refactor on-the-fly configuration changes
      net/mlx5e: Cleanup safe switch channels API by passing params

Meng Yu (4):
      Bluetooth: Remove trailing semicolon in macros
      Bluetooth: Remove trailing semicolon in macros
      Bluetooth: Remove 'return' in void function
      Bluetooth: Coding style fix

Menglong Dong (1):
      net: socket: use BIT() for MSG_*

Miaoqing Pan (1):
      ath11k: fix potential wmi_mgmt_tx_queue race condition

Michael Chan (13):
      bnxt_en: Improve the status_reliable flag in bp->fw_health.
      bnxt_en: Set BNXT_STATE_FW_RESET_DET flag earlier for the RDMA driver.
      bnxt_en: Enhance retry of the first message to the firmware.
      bnxt_en: Treat health register value 0 as valid in bnxt_try_reover_fw().
      bnxt_en: Refactor __bnxt_vf_reps_destroy().
      bnxt_en: Fix RX consumer index logic in the error path.
      bnxt_en: Add a new phy_flags field to the main driver structure.
      bnxt_en: Add support for fw managed link down feature.
      bnxt_en: Move bnxt_approve_mac().
      bnxt_en: Call bnxt_approve_mac() after the PF gives up control of the VF MAC.
      bnxt_en: Add PCI IDs for Hyper-V VF devices.
      bnxt_en: Support IFF_SUPP_NOFCS feature to transmit without ethernet FCS.
      bnxt_en: Implement .ndo_features_check().

Michael Grzeschik (7):
      net: dsa: microchip: ksz8795: change drivers prefix to be generic
      net: dsa: microchip: ksz8795: move cpu_select_interface to extra function
      net: dsa: microchip: ksz8795: move register offsets and shifts to separate struct
      net: dsa: microchip: Add Microchip KSZ8863 SPI based driver support
      dt-bindings: net: dsa: document additional Microchip KSZ8863/8873 switch
      net: dsa: microchip: Add Microchip KSZ8863 SMI based driver support
      dt-bindings: net: mdio-gpio: add compatible for microchip,mdio-smi0

Michael Tretter (1):
      net: macb: simplify clk_init with dev_err_probe

Michael Walle (6):
      net: phy: at803x: remove at803x_aneg_done()
      of: net: pass the dst buffer to of_get_mac_address()
      of: net: fix of_get_mac_addr_nvmem() for non-platform devices
      net: enetc: fetch MAC address from device tree
      net: enetc: automatically select IERB module
      net: phy: at803x: fix probe error if copper page is selected

Michal Simek (1):
      can: xilinx_can: Simplify code by using dev_err_probe()

Michal Swiatkowski (1):
      ice: Allow ignoring opcodes on specific VF

Mikhael Goikhman (1):
      net/mlx5: Remove unused mlx5_core_health member recover_work

Miri Korenblit (3):
      iwlwifi: mvm: enable PPAG in China
      iwlwifi: mvm: support BIOS enable/disable for 11ax in Ukraine
      iwlwifi: mvm: add support for version 3 of LARI_CONFIG_CHANGE command.

Mohammad Athari Bin Ismail (3):
      net: stmmac: Fix kernel panic due to NULL pointer dereference of fpe_cfg
      net: stmmac: Add HW descriptor prefetch setting for DWMAC Core 5.20 onwards
      stmmac: intel: Enable HW descriptor prefetch by default

Mordechay Goodstein (7):
      iwlwifi: pcie: clear only FH bits handle in the interrupt
      iwlwifi: move iwl_configure_rxq to be used by other op_modes
      iwlwifi: queue: avoid memory leak in reset flow
      iwlwifi: mvm: remove PS from lower rates.
      iwlwifi: pcie: merge napi_poll_msix functions
      iwlwifi: pcie: add ISR debug info for msix debug
      iwlwifi: rs-fw: don't support stbc for HE 160

Moshe Tal (2):
      net/mlx5: Add register layout to support extended link state
      net/mlx5e: Add ethtool extended link state

Muhammad Sammar (1):
      net/mlx5: DR, Remove protocol-specific flex_parser_3 definitions

Muhammad Usama Anjum (1):
      bpf, inode: Remove second initialization of the bpf_preload_lock

Mukesh Sisodiya (1):
      iwlwifi: dbg: disable ini debug in 9000 family and below

Naftali Goldstein (1):
      mac80211: drop the connection if firmware crashed while in CSA

Nalla, Pradeep (1):
      octeontx2-af: Add support for multi channel in NIX promisc entry

Naveen Mamindlapalli (6):
      octeontx2-af: refactor function npc_install_flow for default entry
      octeontx2-af: Use npc_install_flow API for promisc and broadcast entries
      octeontx2-af: Modify the return code for unsupported flow keys
      octeontx2-pf: Add ip tos and ip proto icmp/icmpv6 flow offload support
      octeontx2-pf: Add tc flower hardware offload on ingress traffic
      octeontx2-pf: add tc flower stats handler for hw offloads

Nico Pache (1):
      kunit: mptcp: adhere to KUNIT formatting standard

Nigel Christian (1):
      mt76: mt7921: remove unnecessary variable

Nikolay Aleksandrov (3):
      net: bridge: mcast: remove unreachable EHT code
      net: bridge: mcast: factor out common allow/block EHT handling
      net: bridge: when suppression is enabled exclude RARP packets

Oleksij Rempel (9):
      net: phy: execute genphy_loopback() per default on all PHYs
      net: phy: genphy_loopback: add link speed configuration
      net: add generic selftest support
      net: fec: make use of generic NET_SELFTESTS library
      net: ag71xx: make use of generic NET_SELFTESTS library
      net: dsa: enable selftest support for all switches by default
      net: dsa: fix bridge support for drivers without port_bridge_flags callback
      net: dsa: microchip: ksz8795: add support for ksz88xx chips
      net: selftest: fix build issue if INET is disabled

Oliver Neukum (3):
      usbnet: add _mii suffix to usbnet_set/get_link_ksettings
      usbnet: add method for reporting speed without MII
      net: cdc_ncm: record speed in status method

Ong Boon Leong (30):
      net: pcs: rearrange C73 functions to prepare for C37 support later
      net: pcs: add C37 SGMII AN support for intel mGbE controller
      net: phylink: make phylink_parse_mode() support non-DT platform
      net: stmmac: make in-band AN mode parsing is supported for non-DT
      net: stmmac: ensure phydev is attached to phylink for C37 AN
      stmmac: intel: add pcs-xpcs for Intel mGbE controller
      net: stmmac: add per-queue TX & RX coalesce ethtool support
      net: stmmac: restructure tc implementation for RX VLAN Priority steering
      net: stmmac: add RX frame steering based on VLAN priority in tc flower
      net: stmmac: Add EST errors into ethtool statistic
      net: stmmac: support FPE link partner hand-shaking procedure
      net: stmmac: introduce DMA interrupt status masking per traffic direction
      net: stmmac: make stmmac_interrupt() function more friendly to MSI
      net: stmmac: introduce MSI Interrupt routines for mac, safety, RX & TX
      stmmac: intel: add support for multi-vector msi and msi-x
      net: stmmac: set IRQ affinity hint for multi MSI vectors
      net: stmmac: make SPH enable/disable to be configurable
      net: stmmac: arrange Tx tail pointer update to stmmac_flush_tx_descriptors
      net: stmmac: Add initial XDP support
      net: stmmac: Add support for XDP_TX action
      net: stmmac: Add support for XDP_REDIRECT action
      net: stmmac: rearrange RX buffer allocation and free functions
      net: stmmac: introduce dma_recycle_rx_skbufs for stmmac_reinit_rx_buffers
      net: stmmac: refactor stmmac_init_rx_buffers for stmmac_reinit_rx_buffers
      net: stmmac: rearrange RX and TX desc init into per-queue basis
      net: stmmac: Refactor __stmmac_xdp_run_prog for XDP ZC
      net: stmmac: Enable RX via AF_XDP zero-copy
      net: stmmac: Add TX via XDP zero-copy socket
      stmmac: intel: set TSO/TBS TX Queues default settings
      net: stmmac: fix TSO and TBS feature enabling during driver open

Otto Hollmann (1):
      net: document a side effect of ip_local_reserved_ports

Oz Shlomo (1):
      netfilter: flowtable: separate replace, destroy and stats to different workqueues

Pablo Neira Ayuso (47):
      netfilter: flowtable: consolidate skb_try_make_writable() call
      netfilter: flowtable: move skb_try_make_writable() before NAT in IPv4
      netfilter: flowtable: move FLOW_OFFLOAD_DIR_MAX away from enumeration
      netfilter: flowtable: fast NAT functions never fail
      netfilter: flowtable: call dst_check() to fall back to classic forwarding
      netfilter: flowtable: refresh timeout after dst and writable checks
      netfilter: nftables: update table flags from the commit phase
      net: resolve forwarding path from virtual netdevice and HW destination address
      net: 8021q: resolve forwarding path for vlan devices
      net: bridge: resolve forwarding path for bridge devices
      netfilter: flowtable: add xmit path types
      netfilter: flowtable: use dev_fill_forward_path() to obtain ingress device
      netfilter: flowtable: use dev_fill_forward_path() to obtain egress device
      netfilter: flowtable: add vlan support
      netfilter: flowtable: add bridge vlan filtering support
      netfilter: flowtable: add pppoe support
      netfilter: flowtable: add dsa support
      selftests: netfilter: flowtable bridge and vlan support
      netfilter: flowtable: add offload support for xmit path types
      netfilter: nft_flow_offload: use direct xmit if hardware offload is enabled
      net: flow_offload: add FLOW_ACTION_PPPOE_PUSH
      netfilter: flowtable: support for FLOW_ACTION_PPPOE_PUSH
      dsa: slave: add support for TC_SETUP_FT
      docs: nf_flowtable: update documentation with enhancements
      docs: nf_flowtable: fix compilation and warnings
      netfilter: flowtable: dst_check() from garbage collector path
      netfilter: nftables: add helper function to set the base sequence number
      netfilter: add helper function to set up the nfnetlink header and use it
      netfilter: nftables: remove documentation on static functions
      netfilter: nft_payload: fix C-VLAN offload support
      netfilter: nftables_offload: VLAN id needs host byteorder in flow dissector
      netfilter: nftables_offload: special ethertype handling for VLAN
      netfilter: nftables: counter hardware offload support
      net: ethernet: mtk_eth_soc: fix undefined reference to `dsa_port_from_netdev'
      net: ethernet: mtk_eth_soc: missing mutex
      net: ethernet: mtk_eth_soc: handle VLAN pop action
      netfilter: nft_socket: add support for cgroupsv2
      netfilter: nftables: add nft_pernet() helper function
      netfilter: nfnetlink: add struct nfnl_info and pass it to callbacks
      netfilter: nfnetlink: pass struct nfnl_info to rcu callbacks
      netfilter: nfnetlink: pass struct nfnl_info to batch callbacks
      netfilter: nfnetlink: consolidate callback types
      netfilter: nftables: rename set element data activation/deactivation functions
      netfilter: nftables: add loop check helper function
      netfilter: nftables: add helper function to flush set elements
      netfilter: nftables: add helper function to validate set element data
      netfilter: nftables: add catch-all set element support

Pankaj Sharma (1):
      MAINTAINERS: Update MCAN MMIO device driver maintainer

Paolo Abeni (22):
      mptcp: clean-up the rtx path
      udp: fixup csum for GSO receive slow path
      udp: skip L4 aggregation for UDP tunnel packets
      udp: properly complete L4 GRO over UDP tunnel packet
      udp: never accept GSO_FRAGLIST packets
      vxlan: allow L4 GRO passthrough
      geneve: allow UDP L4 GRO passthrou
      bareudp: allow UDP L4 GRO passthrou
      selftests: net: add UDP GRO forwarding self-tests
      mptcp: add mib for token creation fallback
      mptcp: add active MPC mibs
      mptcp: remove unneeded check on first subflow
      veth: use skb_orphan_partial instead of skb_orphan
      veth: allow enabling NAPI even without XDP
      veth: refine napi usage
      self-tests: add veth tests
      skbuff: revert "skbuff: remove some unnecessary operation in skb_segment_list()"
      mptcp: move sockopt function into a new file
      mptcp: only admit explicitly supported sockopt
      mptcp: implement dummy MSG_ERRQUEUE support
      mptcp: implement MSG_TRUNC support
      mptcp: ignore unsupported msg flags

Parav Pandit (31):
      net/mlx5: E-Switch, cut down mlx5_vport_info structure size by 8 bytes
      net/mlx5: E-Switch, move QoS specific fields to existing qos struct
      net/mlx5: Use unsigned int for free_count
      net/mlx5: Pack mlx5_rl_entry structure
      net/mlx5: Do not hold mutex while reading table constants
      net/mlx5: Use helpers to allocate and free rl table entries
      net/mlx5: Use helper to increment, decrement rate entry refcount
      net/mlx5: Allocate rate limit table when rate is configured
      net/mlx5: Pair mutex_destory with mutex_init for rate limit table
      net/mlx5: E-Switch, cut down mlx5_vport_info structure size by 8 bytes
      net/mlx5: E-Switch, move QoS specific fields to existing qos struct
      net/mlx5: E-Switch, let user to enable disable metadata
      net/mlx5: E-Switch, Skip querying SF enabled bits
      net/mlx5: E-Switch, Make vport number u16
      net/mlx5: E-Switch Make cleanup sequence mirror of init
      net/mlx5: E-Switch, Convert a macro to a helper routine
      net/mlx5: E-Switch, Move legacy code to a individual file
      net/mlx5: E-Switch, Initialize eswitch acls ns when eswitch is enabled
      net/mlx5: SF, Use device pointer directly
      net/mlx5: SF, Reuse stored hardware function id
      net/mlx5: E-Switch, Return eswitch max ports when eswitch is supported
      net/mlx5: E-Switch, Prepare to return total vports from eswitch struct
      net/mlx5: E-Switch, Use xarray for vport number to vport and rep mapping
      net/mlx5: E-Switch, Consider SF ports of host PF
      net/mlx5: SF, Rely on hw table for SF devlink port allocation
      devlink: Extend SF port attributes to have external attribute
      net/mlx5: SF, Store and use start function id
      net/mlx5: SF, Consider own vhca events of SF devices
      net/mlx5: SF, Use helpers for allocation and free
      net/mlx5: SF, Split mlx5_sf_hw_table into two parts
      net/mlx5: SF, Extend SF table for additional SF id range

Paul Blakey (1):
      net/mlx5: CT: Add support for mirroring

Paul Greenwalt (1):
      ice: change link misconfiguration message

Paul M Stillwell Jr (3):
      ice: handle increasing Tx or Rx ring sizes
      ice: remove return variable
      ice: reduce scope of variable

Pavan Chebbi (1):
      bnxt_en: Improve wait for firmware commands completion

Pavana Sharma (2):
      net: dsa: mv88e6xxx: change serdes lane parameter type from u8 type to int
      net: dsa: mv88e6xxx: add support for mv88e6393x family

Pedro Tammela (7):
      libbpf: Avoid inline hint definition from 'linux/stddef.h'
      bpf: selftests: Remove unused 'nospace_err' in tests for batched ops in array maps
      bpf: Add support for batched ops in LPM trie maps
      bpf: selftests: Add tests for batched ops in LPM trie maps
      libbpf: Clarify flags in ringbuf helpers
      bpf: Add batched ops support for percpu array
      bpf, selftests: Update array map tests for per-cpu batched ops

Peng Li (6):
      net: hns3: remove redundant blank lines
      net: hns3: remove unused parameter from hclge_set_vf_vlan_common()
      net: i40e: remove repeated words
      net: bonding: remove repeated word
      net: phy: remove repeated word
      net: ipa: remove repeated words

Peng Zhang (1):
      nfp: flower: add support for packet-per-second policing

Petr Machata (27):
      mlxsw: spectrum: Bump minimum FW version to xx.2008.2406
      nexthop: Pass nh_config to replace_nexthop()
      nexthop: __nh_notifier_single_info_init(): Make nh_info an argument
      nexthop: Add a dedicated flag for multipath next-hop groups
      nexthop: Add implementation of resilient next-hop groups
      nexthop: Implement notifiers for resilient nexthop groups
      nexthop: Add netlink handlers for resilient nexthop groups
      nexthop: Add netlink handlers for bucket dump
      nexthop: Add netlink handlers for bucket get
      nexthop: Notify userspace about bucket migrations
      nexthop: Enable resilient next-hop groups
      netdevsim: fib: Introduce a lock to guard nexthop hashtable
      nexthop: Rename artifacts related to legacy multipath nexthop groups
      Documentation: net: Document resilient next-hop groups
      mlxsw: spectrum_qdisc: Drop one argument from check_params callback
      mlxsw: spectrum_qdisc: Simplify mlxsw_sp_qdisc_compare()
      mlxsw: spectrum_qdisc: Drop an always-true condition
      mlxsw: spectrum_qdisc: Track tclass_num as int, not u8
      mlxsw: spectrum_qdisc: Promote backlog reduction to mlxsw_sp_qdisc_destroy()
      mlxsw: spectrum_qdisc: Track children per qdisc
      mlxsw: spectrum_qdisc: Guard all qdisc accesses with a lock
      mlxsw: spectrum_qdisc: Allocate child qdiscs dynamically
      mlxsw: spectrum_qdisc: Index future FIFOs by band number
      selftests: mlxsw: sch_red_ets: Test proper counter cleaning in ETS
      selftests: net: mirror_gre_vlan_bridge_1q: Make an FDB entry static
      selftests: mlxsw: Increase the tolerance of backlog buildup
      selftests: mlxsw: Fix mausezahn invocation in ERSPAN scale test

Phil Sutter (1):
      netfilter: nf_log_syslog: Unset bridge logger in pernet exit

Phillip Potter (2):
      net: usb: ax88179_178a: initialize local variables before use
      net: geneve: modify IP header check in geneve6_xmit_skb and geneve_xmit_skb

Ping-Ke Shih (4):
      rtw88: coex: add power off setting
      rtlwifi: 8821ae: upgrade PHY and RF parameters
      rtw88: Fix array overrun in rtw_get_tx_power_params()
      rtlwifi: implement set_tim by update beacon content

Po-Hao Huang (4):
      rtw88: 8822c: add LC calibration for RTL8822C
      rtw88: update statistics to fw for fine-tuning performance
      rtw88: 8822c: add CFO tracking
      rtw88: refine napi deinit flow

Po-Hsu Lin (1):
      selftests/net: bump timeout to 5 minutes

Pradeep Kumar Chitrapu (1):
      ath11k: fix thermal temperature read

Qi Zhang (16):
      ice: Add more basic protocol support for flow filter
      ice: Support non word aligned input set field
      ice: Add more advanced protocol support in flow filter
      ice: Support to separate GTP-U uplink and downlink
      ice: Enhanced IPv4 and IPv6 flow filter
      ice: Add support for per VF ctrl VSI enabling
      ice: Enable FDIR Configure for AVF
      ice: Add FDIR pattern action parser for VF
      ice: Add new actions support for VF FDIR
      ice: Add non-IP Layer2 protocol FDIR filter for AVF
      ice: Add GTPU FDIR filter for AVF
      ice: Add more FDIR filter type for AVF
      ice: Check FDIR program status for AVF
      ice: rename ptype bitmap
      ice: Enable RSS configure for AVF
      ice: Support RSS configure removal for AVF

Qiheng Lin (6):
      net: ethernet: mtk_eth_soc: remove unused variable 'count'
      net: ethernet: mtk_eth_soc: remove unneeded semicolon
      netdevsim: remove unneeded semicolon
      cfg80211: regulatory: use DEFINE_SPINLOCK() for spinlock
      cxgb4: remove unneeded if-null-free check
      ehea: add missing MODULE_DEVICE_TABLE

Qinglang Miao (1):
      net: dsa: b53: spi: add missing MODULE_DEVICE_TABLE

Radu Pirea (NXP OSS) (4):
      net: phy: add genphy_c45_pma_suspend/resume
      phy: nxp-c45: add driver for tja1103
      phy: nxp-c45-tja11xx: fix phase offset calculation
      phy: nxp-c45-tja11xx: add interrupt support

Rafael David Tinoco (1):
      libbpf: Add bpf object kern_version attribute setter

Rafał Miłecki (7):
      net: broadcom: bcm4908_enet: read MAC from OF
      dt-bindings: net: bcm4908-enet: add optional TX interrupt
      net: broadcom: bcm4908_enet: support TX interrupt
      net: dsa: bcm_sf2: store PHY interface/mode in port structure
      net: dsa: bcm_sf2: setup BCM4908 internal crossbar
      net: dsa: bcm_sf2: add function finding RGMII register
      net: dsa: bcm_sf2: fix BCM4908 RGMII reg(s)

Randy Dunlap (2):
      cfg80211: fix a few kernel-doc warnings
      net: xilinx: drivers need/depend on HAS_IOMEM

Rasmus Moorats (1):
      Bluetooth: btusb: support 0cb5:c547 Realtek 8822CE device

Ravi Bangoria (1):
      selftests/bpf: Use nanosleep() syscall instead of sleep() in get_cgroup_id

Ravi Darsi (1):
      iwlwifi: mvm: Use IWL_INFO in fw_reset_handshake()

René van Dorst (1):
      net: dsa: mt7530: Add support for EEE features

Ricardo Ribalda (1):
      bpf: Fix typo 'accesible' into 'accessible'

Richard Guy Briggs (1):
      audit: log nftables configuration change events once per table

Robert Hancock (4):
      net: macb: poll for fixed link state in SGMII mode
      net: macb: Disable PCS auto-negotiation for SGMII fixed-link mode
      dt-bindings: net: xilinx_axienet: Document additional clocks
      net: axienet: Enable more clocks

Roee Goldfiner (1):
      iwlwifi: mvm: umac error table mismatch

Roi Dayan (22):
      net/mlx5e: CT, Avoid false lock dependency warning
      net/mlx5: SF, Fix return type
      net/mlx5e: Alloc flow spec using kvzalloc instead of kzalloc
      net/mlx5e: Remove redundant newline in NL_SET_ERR_MSG_MOD
      net: Change dev parameter to const in netif_device_present()
      net/mlx5e: Allow legacy vf ndos only if in legacy mode
      net/mlx5e: Distinguish nic and esw offload in tc setup block cb
      net/mlx5e: Add offload stats ndos to nic netdev ops
      net/mlx5e: Use nic mode netdev ndos and ethtool ops for uplink representor
      net/mlx5e: Verify dev is present in some ndos
      net/mlx5e: Move devlink port register and unregister calls
      net/mlx5e: Register nic devlink port with switch id
      net/mlx5: Move mlx5e hw resources into a sub object
      net/mlx5: Move devlink port from mlx5e priv to mlx5e resources
      net/mlx5e: Unregister eth-reps devices first
      net/mlx5e: Do not reload ethernet ports when changing eswitch mode
      net/mlx5: E-Switch, Change mode lock from mutex to rw semaphore
      net/mlx5: E-Switch, Protect changing mode while adding rules
      net/mlx5: Use ida_alloc_range() instead of ida_simple_alloc()
      netfilter: flowtable: Add FLOW_OFFLOAD_XMIT_UNSPEC xmit type
      net/mlx5: DR, Alloc cmd buffer with kvzalloc() instead of kzalloc()
      net/sched: act_ct: Remove redundant ct get and check

Ryder Lee (38):
      mt76: always use WTBL_MAX_SIZE for tlv allocation
      mt76: use PCI_VENDOR_ID_MEDIATEK to avoid open coded
      mt76: mt7615: enable hw rx-amsdu de-aggregation
      mt76: mt7615: add rx checksum offload support
      mt76: mt7615: add support for rx decapsulation offload
      mt76: mt7615: fix TSF configuration
      mt76: mt7615: remove hdr->fw_ver check
      mt76: mt7915: fix mib stats counter reporting to mac80211
      mt76: mt7915: add missing capabilities for DBDC
      mt76: mt7615: fix CSA notification for DBDC
      mt76: mt7615: stop ext_phy queue when mac reset happens
      mt76: mt7915: fix CSA notification for DBDC
      mt76: mt7915: stop ext_phy queue when mac reset happens
      mt76: mt7915: fix PHY mode for DBDC
      mt76: mt7915: fix rxrate reporting
      mt76: mt7915: fix txrate reporting
      mt76: mt7915: check mcu returned values in mt7915_ops
      mt76: mt7615: check mcu returned values in mt7615_ops
      mt76: mt7615: add missing capabilities for DBDC
      mt76: mt7915: fix possible deadlock while mt7915_register_ext_phy()
      mt76: mt7615: only enable DFS test knobs for mt7615
      mt76: mt7615: cleanup mcu tx queue in mt7615_dma_reset()
      mt76: mt7622: trigger hif interrupt for system reset
      mt76: mt7615: keep mcu_add_bss_info enabled till interface removal
      mt76: mt7915: keep mcu_add_bss_info enabled till interface removal
      mt76: mt7915: cleanup mcu tx queue in mt7915_dma_reset()
      mt76: mt7615: fix .add_beacon_offload()
      mt76: mt7915: fix mt7915_mcu_add_beacon
      mt76: mt7915: add wifi subsystem reset
      mt76: report Rx timestamp
      mt76: mt7915: add mmio.c
      mt76: mt7615: add missing SPDX tag in mmio.c
      mt76: mt7615: fix memleak when mt7615_unregister_device()
      mt76: mt7915: fix memleak when mt7915_unregister_device()
      mt76: mt7915: only free skbs after mt7915_dma_reset() when reset happens
      mt76: mt7615: only free skbs after mt7615_dma_reset() when reset happens
      mt76: mt7615: use ieee80211_free_txskb() in mt7615_tx_token_put()
      mt76: mt7915: add support for applying pre-calibration data

Sabrina Dubroca (1):
      xfrm: ipcomp: remove unnecessary get_cpu()

Saeed Mahameed (6):
      net/mlx5: Don't skip vport check
      net/mlx5e: mlx5_tc_ct_init does not fail
      net/mlx5e: rep: Improve reg_cX conditions
      net/mlx5: Cleanup prototype warning
      net/mlx5e: Same max num channels for both nic and uplink profiles
      net/mlx5e: alloc the correct size for indirection_rqt

Sai Kalyaan Palla (2):
      net: decnet: Fixed multiple coding style issues
      net: decnet: Fixed multiple Coding Style issues

Salil Mehta (1):
      net: hns3: Limiting the scope of vector_ring_chain variable

Sander Vanheule (1):
      mt76: mt7615: support loading EEPROM for MT7613BE

Sanjana Srinidhi (1):
      drivers: net: vxlan.c: Fix declaration issue

Sara Sharon (1):
      iwlwifi: mvm: enable TX on new CSA channel before disconnecting

Sasha Neftin (7):
      igc: Remove unused MII_CR_RESET
      igc: Remove unused MII_CR_SPEED
      igc: Remove unused MII_CR_LOOPBACK
      igc: Fix prototype warning
      e1000e: Fix prototype warning
      igc: Fix overwrites return value
      igc: Expose LPI counters

Sathish Narasimman (2):
      Bluetooth: Handle own address type change with HCI_ENABLE_LL_PRIVACY
      Bluetooth: LL privacy allow RPA

Scott Branden (1):
      bnxt_en: check return value of bnxt_hwrm_func_resc_qcaps

Scott W Taylor (1):
      ice: Reimplement module reads used by ethtool

Sean Wang (24):
      mt76: mt7921: fix suspend/resume sequence
      mt76: mt7921: fix memory leak in mt7921_coredump_work
      mt76: mt7921: switch to new api for hardware beacon filter
      mt76: connac: fix up the setting for ht40 mode in mt76_connac_mcu_uni_add_bss
      mt76: mt7921: fixup rx bitrate statistics
      mt76: mt7921: add flush operation
      mt76: connac: update sched_scan cmd usage
      mt76: mt7921: fix the base of PCIe interrupt
      mt76: mt7921: fix the base of the dynamic remap
      mt76: mt7663: fix when beacon filter is being applied
      mt76: mt7663s: make all of packets 4-bytes aligned in sdio tx aggregation
      mt76: mt7663s: fix the possible device hang in high traffic
      mt76: mt7921: fix inappropriate WoW setup with the missing ARP informaiton
      mt76: mt7921: fix the dwell time control
      mt76: mt7921: fix kernel crash when the firmware fails to download
      mt76: mt7921: fix the insmod hangs
      mt76: mt7921: reduce the data latency during hw scan
      mt76: mt7921: add dumping Tx power table
      mt76: mt7921: add wifisys reset support in debugfs
      mt76: mt7921: abort uncompleted scan by wifi reset
      mt76: connac: introduce mt76_connac_mcu_set_deep_sleep utility
      mt76: mt7921: enable deep sleep when the device suspends
      mt76: mt7921: fix possible invalid register access
      mt76: mt7921: mt7921_stop should put device in fw_own state

Sebastian Andrzej Siewior (1):
      batman-adv: Use netif_rx_any_context().

Sergey Shtylyov (4):
      sh_eth: rename TRSCER bits
      sh_eth: rename PSR bits
      sh_eth: rename *enum*s still not matching register names
      sh_eth: place RX/TX descriptor *enum*s after their *struct*s

Shachar Raindel (1):
      hv_netvsc: Add a comment clarifying batching logic

Shannon Nelson (42):
      ionic: move rx_page_alloc and free
      ionic: implement Rx page reuse
      ionic: optimize fastpath struct usage
      ionic: simplify rx skb alloc
      ionic: rebuild debugfs on qcq swap
      ionic: simplify use of completion types
      ionic: simplify TSO descriptor mapping
      ionic: generic tx skb mapping
      ionic: simplify tx clean
      ionic: aggregate Tx byte counting calls
      ionic: code cleanup details
      ionic: simplify the intr_index use in txq_init
      ionic: fix unchecked reference
      ionic: update ethtool support bits for BASET
      ionic: block actions during fw reset
      ionic: stop watchdog when in broken state
      ionic: protect adminq from early destroy
      ionic: count dma errors
      ionic: fix sizeof usage
      ionic: avoid races in ionic_heartbeat_check
      ionic: pull per-q stats work out of queue loops
      ionic: add new queue features to interface
      ionic: add handling of larger descriptors
      ionic: add hw timestamp structs to interface
      ionic: split adminq post and wait calls
      ionic: add hw timestamp support files
      ionic: link in the new hw timestamp code
      ionic: add rx filtering for hw timestamp steering
      ionic: set up hw timestamp queues
      ionic: add and enable tx and rx timestamp handling
      ionic: add ethtool support for PTP
      ionic: ethtool ptp stats
      ionic: advertise support for hardware timestamps
      ionic: fix up a couple of code style nits
      ionic: remove unnecessary compat ifdef
      ionic: check for valid tx_mode on SKBTX_HW_TSTAMP xmit
      ionic: add SKBTX_IN_PROGRESS
      ionic: re-start ptp after queues up
      ionic: ignore EBUSY on queue start
      ionic: add ts_config replay
      ionic: extend ts_config set locking
      ionic: git_ts_info bit shifters

Shayne Chen (9):
      mt76: mt7915: fix txpower init for TSSI off chips
      mt76: testmode: add support to send larger packet
      mt76: mt7915: rework mt7915_tm_set_tx_len()
      mt76: mt7915: fix rate setting of tx descriptor in testmode
      mt76: extend DT rate power limits to support 11ax devices
      mt76: mt7915: add support for DT rate power limits
      mt76: mt7915: rework the flow of txpower setting
      mt76: mt7915: directly read per-rate tx power from registers
      mt76: mt7915: do not read rf value from efuse in flash mode

Shixin Liu (2):
      mISDN: Use DEFINE_SPINLOCK() for spinlock
      mISDN: Use LIST_HEAD() for list_head

Shuah Khan (3):
      ath9k: fix ath_tx_process_buffer() potential null ptr dereference
      Revert "ath9k: fix ath_tx_process_buffer() potential null ptr dereference"
      ath10k: Fix ath10k_wmi_tlv_op_pull_peer_stats_info() unlock without lock

Shubhankar Kuranagatti (3):
      net: ipv6: route.c:fix indentation
      net: ipv4: route.c: fix space before tab
      net: ipv4: route.c: Fix indentation of multi line comment.

Sieng Piaw Liew (2):
      atl1c: switch to napi_gro_receive
      atl1c: use napi_alloc_skb

Song Liu (6):
      bpf: Enable task local storage for tracing programs
      bpf: Prevent deadlock from recursive bpf_task_storage_[get|delete]
      selftests/bpf: Add non-BPF_LSM test for task local storage
      selftests/bpf: Test deadlock from recursive bpf_task_storage_[get|delete]
      bpf: runqslower: Prefer using local vmlimux to generate vmlinux.h
      bpf: runqslower: Use task local storage

Sonny Sasaka (1):
      Bluetooth: Cancel le_scan_restart work when stopping discovery

Sriharsha Basavapatna (2):
      bnxt_en: Refactor bnxt_vf_reps_create().
      bnxt_en: Free and allocate VF-Reps during error recovery.

Sriram R (2):
      ath11k: Update signal filled flag during sta_statistics drv op
      mac80211: Allow concurrent monitor iface and ethernet rx decap

Srujana Challa (3):
      octeontx2-af: cn10k: Mailbox changes for CN10K CPT
      octeontx2-af: cn10k: Add mailbox to configure reassembly timeout
      octeontx2-af: Add mailbox for CPT stats

Stanislav Fomichev (1):
      tools/resolve_btfids: Fix warnings

Stefan Assmann (1):
      iavf: remove duplicate free resources calls

Stefan Chulski (1):
      net: mvpp2: Add parsing support for different IPv4 IHL values

Stefano Garzarella (2):
      vsock/vmci: log once the failed queue pair allocation
      vsock/virtio: free queued packets when closing socket

Stephane Grosjean (3):
      can: peak_usb: pcan_usb_pro_encode_msg(): use macros for flags instead of plain integers
      can: peak_usb: add support of ethtool set_phys_id()
      can: peak_usb: add support of ONE_SHOT mode

Subbaraya Sundeep (1):
      octeontx2-af: Avoid duplicate unicast rule in mcam_rules list

Sunil Goutham (1):
      octeontx2-pf: TC_MATCHALL egress ratelimiting offload

Sven Eckelmann (2):
      batman-adv: Drop unused header preempt.h
      batman-adv: Fix misspelled "wont"

Taehee Yoo (10):
      mld: convert from timer to delayed work
      mld: get rid of inet6_dev->mc_lock
      mld: convert ipv6_mc_socklist->sflist to RCU
      mld: convert ip6_sf_list to RCU
      mld: convert ifmcaddr6 to RCU
      mld: add new workqueues for process mld events
      mld: add mc_lock for protecting per-interface mld data
      mld: change lockdep annotation for ip6_sf_socklist and ipv6_mc_socklist
      mld: fix suspicious RCU usage in __ipv6_dev_mc_dec()
      mld: remove unnecessary prototypes

Tan Tee Min (2):
      net: stmmac: Add hardware supported cross-timestamp
      net: stmmac: Add support for external trigger timestamping

Tariq Toukan (12):
      net/mlx5: Use order-0 allocations for EQs
      net/mlx5e: Dump ICOSQ WQE descriptor on CQE with error events
      net/mlx5e: Pass q_counter indentifier as parameter to rq_param builders
      net/mlx5e: Move params logic into its dedicated file
      net/mlx5e: Restrict usage of mlx5e_priv in params logic functions
      net/mlx5e: Remove non-essential TLS SQ state bit
      net/mlx5e: Cleanup unused function parameter
      net/mlx5e: TX, Inline TLS skb check
      net/mlx5e: TX, Inline function mlx5e_tls_handle_tx_wqe()
      net/mlx5e: kTLS, Add resiliency to RX resync failures
      net/mlx5e: Fix lost changes during code movements
      net/mlx5e: RX, Add checks for calculated Striding RQ attributes

Tetsuo Handa (1):
      Bluetooth: initialize skb_queue_head at l2cap_chan_create()

Thomas Bogendoerfer (10):
      net: korina: Fix MDIO functions
      net: korina: Use devres functions
      net: korina: Remove not needed cache flushes
      net: korina: Remove nested helpers
      net: korina: Use DMA API
      net: korina: Only pass mac address via platform data
      net: korina: Add support for device tree
      net: korina: Get mdio input clock via common clock framework
      net: korina: Make driver COMPILE_TESTable
      dt-bindings: net: korina: Add DT bindings for IDT 79RC3243x SoCs

Tian Tao (1):
      net: qed: remove unused including <linux/version.h>

Tiezhu Yang (2):
      bpf, doc: Fix some invalid links in bpf_devel_QA.rst
      bpf: Document the pahole release info related to libbpf in bpf_devel_QA.rst

Tobias Waldekranz (18):
      net: dsa: Add helper to resolve bridge port from DSA port
      net: dsa: mv88e6xxx: Avoid useless attempts to fast-age LAGs
      net: dsa: mv88e6xxx: Provide generic VTU iterator
      net: dsa: mv88e6xxx: Remove some bureaucracy around querying the VTU
      net: dsa: mv88e6xxx: Use standard helper for broadcast address
      net: dsa: mv88e6xxx: Flood all traffic classes on standalone ports
      net: dsa: mv88e6xxx: Offload bridge learning flag
      net: dsa: mv88e6xxx: Offload bridge broadcast flooding flag
      net: bridge: switchdev: refactor br_switchdev_fdb_notify
      net: dsa: mv88e6xxx: Mark chips with undocumented EDSA tag support
      net: dsa: mv88e6xxx: Allow dynamic reconfiguration of tag protocol
      net: dsa: Only notify CPU ports of changes to the tag protocol
      net: dsa: Allow default tag protocol to be overridden from DT
      dt-bindings: net: dsa: Document dsa-tag-protocol property
      net: dsa: mv88e6xxx: Correct spelling of define "ADRR" -> "ADDR"
      net: dsa: mv88e6xxx: Fix off-by-one in VTU devlink region size
      net: dsa: mv88e6xxx: Export cross-chip PVT as devlink region
      net: dsa: mv88e6xxx: Fix 6095/6097/6185 ports in non-SERDES CMODE

Toke Høiland-Jørgensen (4):
      bpf: Return target info when a tracing bpf_link is queried
      selftests/bpf: Add tests for target information in bpf_link info queries
      veth: check for NAPI instead of xdp_prog before xmit of XDP frame
      ath9k: Fix error check in ath9k_hw_read_revisions() for PCI devices

Tong Zhang (1):
      isdn: remove extra spaces in the header file

Tonghao Zhang (1):
      net: sock: remove the unnecessary check in proto_register

Tony Nguyen (3):
      ice: Fix prototype warnings
      ice: Correct comment block style
      ice: Remove unnecessary blank line

Torin Cooper-Bennun (3):
      can: m_can: add infrastructure for internal timestamps
      can: m_can: m_can_chip_config(): enable and configure internal timestamps
      can: m_can: fix periph RX path: use rx-offload to ensure skbs are sent from softirq context

Vadim Pasternak (1):
      mlxsw: core: Remove critical trip points from thermal zones

Vadym Kochan (2):
      net: marvell: prestera: add support for AC3X 98DX3265 device
      net: marvell: prestera: fix port event handling on init

Vamsi Krishna (1):
      nl80211: Add interface to indicate TDLS peer's HE capability

Vasundhara Volam (2):
      bnxt_en: Remove the read of BNXT_FW_RESET_INPROG_REG after firmware reset.
      bnxt_en: Invalidate health register mapping at the end of probe.

Venkata Lakshmi Narayana Gubba (1):
      Bluetooth: hci_qca: Add device_may_wakeup support

Victor Raj (1):
      ice: Modify recursive way of adding nodes

Vignesh Sridhar (1):
      ice: warn about potentially malicious VFs

Vincent Mailhol (10):
      netdev: add netdev_queue_set_dql_min_limit()
      can: add new CAN FD bittiming parameters: Transmitter Delay Compensation (TDC)
      can: dev: reorder struct can_priv members for better packing
      can: netlink: move '=' operators back to previous line (checkpatch fix)
      can: bittiming: add calculation for CAN FD Transmitter Delay Compensation (TDC)
      can: bittiming: add CAN_KBPS, CAN_MBPS and CAN_MHZ macros
      can: etas_es58x: add core support for ETAS ES58X CAN USB interfaces
      can: etas_es58x: add support for ETAS ES581.4 CAN USB interface
      can: etas_es58x: add support for the ETAS ES58X_FD CAN USB interfaces
      can: etas_es58x: fix null pointer dereference when handling error frames

Vlad Buslov (5):
      net/mlx5e: Add missing include
      net/mlx5: Fix indir stable stubs
      tc-testing: add simple action change test
      tc-testing: add simple action test to verify batch add cleanup
      tc-testing: add simple action test to verify batch change cleanup

Vladimir Oltean (78):
      net: add a helper to avoid issues with HW TX timestamping and SO_TXTIME
      net: enetc: move the CBDR API to enetc_cbdr.c
      net: enetc: save the DMA device for enetc_free_cbdr
      net: enetc: squash enetc_alloc_cbdr and enetc_setup_cbdr
      net: enetc: save the mode register address inside struct enetc_cbdr
      net: enetc: squash clear_cbdr and free_cbdr into teardown_cbdr
      net: enetc: pass bd_count as an argument to enetc_setup_cbdr
      net: enetc: don't initialize unused ports from a separate code path
      net: enetc: simplify callers of enetc_rxbd_next
      net: enetc: use enum enetc_active_offloads
      net: enetc: remove forward-declarations of enetc_clean_{rx,tx}_ring
      net: enetc: remove forward declaration for enetc_map_tx_buffs
      net: enetc: make enetc_refill_rx_ring update the consumer index
      Documentation: networking: update the graphical representation
      Documentation: networking: dsa: rewrite chapter about tagging protocol
      Documentation: networking: dsa: remove static port count from limitations
      Documentation: networking: dsa: remove references to switchdev prepare/commit
      Documentation: networking: dsa: remove TODO about porting more vendor drivers
      Documentation: networking: dsa: document the port_bridge_flags method
      Documentation: networking: dsa: mention integration with devlink
      Documentation: networking: dsa: add paragraph for the LAG offload
      Documentation: networking: dsa: add paragraph for the MRP offload
      Documentation: networking: dsa: add paragraph for the HSR/PRP offload
      Documentation: networking: switchdev: fix command for static FDB entries
      Documentation: networking: switchdev: separate bulleted items with new line
      Documentation: networking: switchdev: add missing "and" word
      Documentation: networking: dsa: add missing new line in devlink section
      Documentation: networking: dsa: demote subsections to simple emphasized words
      Documentation: networking: dsa: mention that the master is brought up automatically
      net: ocelot: support multiple bridges
      net: enetc: teardown CBDR during PF/VF unbind
      Revert "net: dsa: sja1105: Clear VLAN filtering offload netdev feature"
      net/sched: cls_flower: use ntohs for struct flow_dissector_key_ports
      net/sched: cls_flower: use nla_get_be32 for TCA_FLOWER_KEY_FLAGS
      net: dsa: mv88e6xxx: fix up kerneldoc some more
      net: bridge: declare br_vlan_tunnel_lookup argument tunnel_id as __be64
      net: make xps_needed and xps_rxqs_needed static
      net: move the ptype_all and ptype_base declarations to include/linux/netdevice.h
      net: bridge: add helper for retrieving the current bridge port STP state
      net: bridge: add helper to retrieve the current ageing time
      net: bridge: add helper to replay port and host-joined mdb entries
      net: bridge: add helper to replay port and local fdb entries
      net: bridge: add helper to replay VLANs installed on port
      net: dsa: call dsa_port_bridge_join when joining a LAG that is already in a bridge
      net: dsa: pass extack to dsa_port_{bridge,lag}_join
      net: dsa: inherit the actual bridge port flags at join time
      net: dsa: sync up switchdev objects and port attributes when joining the bridge
      net: ocelot: call ocelot_netdevice_bridge_join when joining a bridged LAG
      net: ocelot: replay switchdev events when joining bridge
      net: enetc: don't depend on system endianness in enetc_set_vlan_ht_filter
      net: enetc: don't depend on system endianness in enetc_set_mac_ht_flt
      net: enetc: consume the error RX buffer descriptors in a dedicated function
      net: enetc: move skb creation into enetc_build_skb
      net: enetc: add a dedicated is_eof bit in the TX software BD
      net: enetc: clean the TX software BD on the TX confirmation path
      net: enetc: move up enetc_reuse_page and enetc_page_reusable
      net: enetc: add support for XDP_DROP and XDP_PASS
      net: enetc: add support for XDP_TX
      net: enetc: increase RX ring default size
      net: enetc: add support for XDP_REDIRECT
      net: enetc: fix TX ring interrupt storm
      net: bridge: switchdev: include local flag in FDB notifications
      net: enetc: remove redundant clearing of skb/xdp_frame pointer in TX conf path
      net: enetc: rename the buffer reuse helpers
      net: enetc: recycle buffers for frames with RX errors
      net: enetc: stop XDP NAPI processing when build_skb() fails
      net: enetc: remove unneeded xdp_do_flush_map()
      net: enetc: increase TX ring size
      net: enetc: use dedicated TX rings for XDP
      net: enetc: handle the invalid XDP action the same way as XDP_DROP
      net: enetc: fix buffer leaks with XDP_TX enqueue rejections
      net: enetc: apply the MDIO workaround for XDP_REDIRECT too
      net: enetc: create a common enetc_pf_to_port helper
      dt-bindings: net: fsl: enetc: add the IERB documentation
      net: enetc: add a mini driver for the Integrated Endpoint Register Block
      arm64: dts: ls1028a: declare the Integrated Endpoint Register Block node
      net: enetc: add support for flow control
      net: bridge: fix error in br_multicast_add_port when CONFIG_NET_SWITCHDEV=n

Vladyslav Tarasiuk (6):
      ethtool: Allow network drivers to dump arbitrary EEPROM data
      net/mlx5: Refactor module EEPROM query
      net/mlx5: Implement get_module_eeprom_by_page()
      net/mlx5: Add support for DSFP module EEPROM dumps
      ethtool: Add fallback to get_module_eeprom from netlink command
      net/mlx5e: Fix possible non-initialized struct usage

Voon Weifeng (4):
      net: stmmac: add timestamp correction to rid CDC sync error
      net: stmmac: EST interrupts handling and error reporting
      net: stmmac: enable MTL ECC Error Address Status Over-ride by default
      stmmac: intel: Enable SERDES PHY rx clk for PSE

Vu Pham (2):
      net/mlx5e: Dynamic alloc arfs table for netdev when needed
      net/mlx5e: Dynamic alloc vlan table for netdev when needed

Wan Jiabing (16):
      net: ethernet: indir_table.h is included twice
      net: ethernet: Remove duplicate include of vhca_event.h
      drivers: net: ethernet: struct sk_buff is declared duplicately
      bpf: struct sock is declared twice in bpf_sk_storage header
      can: tcan4x5x: remove duplicate include of regmap.h
      netfilter: ipset: Remove duplicate declaration
      net: ethernet: stmicro: Remove duplicate struct declaration
      include: net: Remove repeated struct declaration
      net: smc: Remove repeated struct declaration
      bpf, cgroup: Delete repeated struct bpf_prog declaration
      bpf: Remove repeated struct btf_type declaration
      sfc: Remove duplicate argument
      libertas: struct lbs_private is declared duplicately
      brcmfmac: Remove duplicate struct declaration
      wilc1000: Remove duplicate struct declaration
      libertas_tf: Remove duplicate struct declaration

Wang Hai (3):
      net/tls: Fix a typo in tls_device.c
      net/packet: Fix a typo in af_packet.c
      6lowpan: Fix some typos in nhc_udp.c

Wang Qing (8):
      drivers: isdn: mISDN: fix spelling typo of 'wheter'
      net: ethernet: chelsiofix: spelling typo of 'rewriteing'
      mips/sgi-ip27: Delete obsolete TODO file
      scsi/aacraid: Delete obsolete TODO file
      fs/befs: Delete obsolete TODO file
      fs/jffs2: Delete obsolete TODO file
      net/ax25: Delete obsolete TODO file
      net/decnet: Delete obsolete TODO file

Wei Yongjun (14):
      net: dsa: sja1105: fix error return code in sja1105_cls_flower_add()
      bpf: Make symbol 'bpf_task_storage_busy' static
      octeontx2-pf: Fix missing spin_lock_init() in otx2_tc_add_flow()
      e1000e: Mark e1000e_pm_prepare() as __maybe_unused
      net: stmmac: platform: fix build error with !CONFIG_PM_SLEEP
      netdevsim: switch to memdup_user_nul()
      net: encx24j600: use module_spi_driver to simplify the code
      enic: use module_pci_driver to simplify the code
      tulip: windbond-840: use module_pci_driver to simplify the code
      tulip: de2104x: use module_pci_driver to simplify the code
      net: sundance: use module_pci_driver to simplify the code
      net: atheros: atl2: use module_pci_driver to simplify the code
      net: fealnx: use module_pci_driver to simplify the code
      mac80211: minstrel_ht: remove unused variable 'mg' in minstrel_ht_next_jump_rate()

Wenpeng Liang (3):
      net/mlx5: Add a blank line after declarations
      net/mlx5: Remove return statement exist at the end of void function
      net/mlx5: Replace spaces with tab at the start of a line

Wong Vee Khee (6):
      net: phy: add genphy_c45_loopback
      net: phy: marvell10g: Add PHY loopback support
      stmmac: intel: add cross time-stamping freq difference adjustment
      stmmac: intel: use managed PCI function on probe and resume
      net: stmmac: remove unnecessary pci_enable_msi() call
      net: stmmac: fix memory leak during driver probe

Wong, Vee Khee (2):
      stmmac: intel: Add PSE and PCH PTP clock source selection
      net: stmmac: use interrupt mode INTM=1 for multi-MSI

Wu XiangCheng (1):
      tipc: Fix a kernel-doc warning in name_table.c

Xiaoliang Yang (1):
      net: dsa: felix: disable always guard band bit for TAS config

Xie He (4):
      net: lapbether: Prevent racing when checking whether the netif is running
      net: lapbether: Close the LAPB device before its underlying Ethernet device closes
      net: lapb: Make "lapb_t1timer_running" able to detect an already running timer
      net: x25: Queue received packets in the drivers instead of per-CPU queues

Xingfeng Hu (1):
      flow_offload: add support for packet-per-second policing

Xiong Zhenwu (2):
      /net/hsr: fix misspellings using codespell tool
      /net/core/: fix misspellings using codespell tool

Xiongfeng Wang (9):
      l3mdev: Correct function names in the kerneldoc comments
      netlabel: Correct function name netlbl_mgmt_add() in the kerneldoc comments
      net: core: Correct function name dev_uc_flush() in the kerneldoc
      net: core: Correct function name netevent_unregister_notifier() in the kerneldoc
      net: 9p: Correct function name errstr2errno() in the kerneldoc comments
      9p/trans_fd: Correct function name p9_mux_destroy() in the kerneldoc
      net: 9p: Correct function names in the kerneldoc comments
      ip6_tunnel:: Correct function name parse_tvl_tnl_enc_lim() in the kerneldoc comments
      NFC: digital: Correct function name in the kerneldoc comments

Xu Jia (2):
      net: ethernet: remove duplicated include
      net: ipv6: Refactor in rt6_age_examine_exception

Xuan Zhuo (6):
      net: Add priv_flags for allow tx skb without linear
      virtio-net: Support IFF_TX_SKB_NO_LINEAR flag
      xsk: Build skb by page (aka generic zerocopy xmit)
      virtio-net: support XDP when not more queues
      virtio-net: page_to_skb() use build_skb when there's sufficient tailroom
      virtio-net: fix use-after-free in skb_gro_receive

Xuesen Huang (2):
      bpf: Add bpf_skb_adjust_room flag BPF_F_ADJ_ROOM_ENCAP_L2_ETH
      selftests, bpf: Extend test_tc_tunnel test with vxlan

Xulin Sun (1):
      can: m_can: m_can_class_allocate_dev(): remove impossible error return judgment

Yang Li (4):
      isdn: mISDN: remove unneeded variable 'ret'
      rsi: remove unused including <linux/version.h>
      rtlwifi: rtl8188ee: remove redundant assignment of variable rtlpriv->btcoexist.reg_bt_sco
      net: tun: Remove redundant assignment to ret

Yang Yingliang (12):
      net: llc: Correct some function names in header
      net: llc: Correct function name llc_sap_action_unitdata_ind() in header
      net: llc: Correct function name llc_pdu_set_pf_bit() in header
      net: stmmac: fix missing unlock on error in stmmac_suspend()
      net: phy: Correct function name mdiobus_register_board_info() in comment
      net: bonding: Correct function name bond_change_active_slave() in comment
      net: mdio: Correct function name mdio45_links_ok() in comment
      net: mhi: remove pointless conditional before kfree_skb()
      netfilter: nftables: remove unnecessary spin_lock_init()
      net/tipc: fix missing destroy_workqueue() on error in tipc_crypto_start()
      lan743x: remove redundant semi-colon
      libbpf: Remove redundant semi-colon

Yangbo Lu (11):
      enetc: mark TX timestamp type per skb
      enetc: support PTP Sync packet one-step timestamping
      enetc: convert to schedule_work()
      enetc: fix locking for one-step timestamping packet transfer
      net: dsa: check tx timestamp request in core driver
      net: dsa: no longer identify PTP packet in core driver
      net: dsa: no longer clone skb in core driver
      net: dsa: free skb->cb usage in core driver
      docs: networking: timestamping: update for DSA switches
      net: mscc: ocelot: convert to ocelot_port_txtstamp_request()
      net: mscc: ocelot: support PTP Sync one-step timestamping

Yangyang Li (5):
      net: marvell: Delete duplicate word in comments
      net: marvell: Fix the trailing format of some block comments
      net: marvell: Delete extra spaces
      net: marvell: Fix an alignment problem
      net: lpc_eth: fix format warnings of block comments

Yaqi Chen (1):
      samples/bpf: Fix broken tracex1 due to kprobe argument change

Yauheni Kaliuta (8):
      selftests/bpf: test_progs/sockopt_sk: Remove version
      selftests/bpf: test_progs/sockopt_sk: Convert to use BPF skeleton
      selftests/bpf: Pass page size from userspace in sockopt_sk
      selftests/bpf: Pass page size from userspace in map_ptr
      selftests/bpf: mmap: Use runtime page size
      selftests/bpf: ringbuf: Use runtime page size
      selftests/bpf: ringbuf_multi: Use runtime page size
      selftests/bpf: ringbuf_multi: Test bpf_map__set_inner_map_fd

Yejune Deng (2):
      net/rds: Drop duplicate sin and sin6 assignments
      net: ipv4: route.c: simplify procfs code

Yevgeny Kliteynik (14):
      net/mlx5: DR, Fixed typo in STE v0
      net/mlx5: DR, Remove unneeded rx_decap_l3 function for STEv1
      net/mlx5: DR, Add missing vhca_id consume from STEv1
      net/mlx5: DR, Rename an argument in dr_rdma_segments
      net/mlx5: DR, Fix SQ/RQ in doorbell bitmask
      net/mlx5: E-Switch, Improve error messages in term table creation
      net/mlx5: mlx5_ifc updates for flex parser
      net/mlx5: DR, Add support for dynamic flex parser
      net/mlx5: DR, Set STEv0 ICMP flex parser dynamically
      net/mlx5: DR, Add support for matching on geneve TLV option
      net/mlx5: DR, Set flex parser for TNL_MPLS dynamically
      net/mlx5: DR, Add support for matching tunnel GTP-U
      net/mlx5: DR, Add support for force-loopback QP
      net/mlx5: DR, Add support for isolate_vl_tc QP

Yinjun Zhang (1):
      nfp: devlink: initialize the devlink port attribute "lanes"

Yixing Liu (6):
      net: ena: fix inaccurate print type
      net: ena: remove extra words from comments
      net: amd8111e: fix inappropriate spaces
      net: amd: correct some format issues
      net: ocelot: fix a trailling format issue with block comments
      net: toshiba: fix the trailing format of some block comments

Yonghong Song (20):
      bpf: Factor out visit_func_call_insn() in check_cfg()
      bpf: Factor out verbose_invalid_scalar()
      bpf: Refactor check_func_call() to allow callback function
      bpf: Change return value of verifier function add_subprog()
      bpf: Add bpf_for_each_map_elem() helper
      bpf: Add hashtab support for bpf_for_each_map_elem() helper
      bpf: Add arraymap support for bpf_for_each_map_elem() helper
      libbpf: Move function is_ldimm64() earlier in libbpf.c
      libbpf: Support subprog address relocation
      bpftool: Print subprog address properly
      selftests/bpf: Add hashmap test for bpf_for_each_map_elem() helper
      selftests/bpf: Add arraymap test for bpf_for_each_map_elem() helper
      selftests/bpf: Add a verifier scale test with unknown bounded loop
      bpf: net: Emit anonymous enum with BPF_TCP_CLOSE value explicitly
      bpf: Fix NULL pointer dereference in bpf_get_local_storage() helper
      selftests: Set CC to clang in lib.mk if LLVM is set
      tools: Allow proper CC/CXX/... override with LLVM=1 in Makefile.include
      selftests/bpf: Fix test_cpp compilation failure with clang
      selftests/bpf: Silence clang compilation warnings
      bpftool: Fix a clang compilation warning

Yonglong Li (2):
      mptcp: add MSG_PEEK support
      selftests: mptcp: add a test case for MSG_PEEK

Yonglong Liu (2):
      net: hns: remove unnecessary !! operation in hns_mac_config_sds_loopback_acpi()
      net: hns: remove redundant variable initialization

Yoshihiro Shimoda (2):
      dt-bindings: net: can: rcar_can: Document r8a77961 support
      net: renesas: ravb: Fix a stuck issue when a lot of frames are received

Youghandhar Chintala (1):
      ath10k: skip the wait for completion to recovery in shutdown path

Yu-Yen Ting (1):
      rtw88: Fix potential unrecoverable tx queue stop

YueHaibing (1):
      netfilter: conntrack: Remove unused variable declaration

Yufeng Mo (4):
      net: hns3: use FEC capability queried from firmware
      net: hns3: use pause capability queried from firmware
      net: hns3: split function hclge_reset_rebuild()
      net: hns3: optimize the process of queue reset

Yunsheng Lin (4):
      skbuff: remove some unnecessary operation in skb_segment_list()
      net: hns3: add handling for xmit skb with recursive fraglist
      net: hns3: add tx send size handling for tso skb
      net: hns3: add stats logging when skb padding fails

Zheng Yongjun (5):
      net/mlx5: simplify the return expression of mlx5_esw_offloads_pair()
      net: usb: lan78xx: remove unused including <linux/version.h>
      qede: remove unused including <linux/version.h>
      net: bcmgenet: remove unused including <linux/version.h>
      net: nfc: Fix spelling errors in net/nfc module

Zhichao Cai (1):
      Simplify the code by using module_platform_driver macro

Zihao Tang (1):
      net: ipa: Remove useless error message

Zong-Zhe Yang (4):
      rtw88: 8822c: support FW crash dump when FW crash
      rtw88: add flush hci support
      rtw88: fix DIG min setting
      rtw88: 8822c: update tx power limit table to RF v40.1

dingsenjie (2):
      ethernet/broadcom:remove unneeded variable: "ret"
      ethernet/microchip:remove unneeded variable: "ret"

jinyiting (1):
      bonding: 3ad: Fix the conflict between bond_update_slave_arr and the state machine

kernel test robot (1):
      sit: use min

mark-yw.chen (2):
      Bluetooth: btusb: Fix incorrect type in assignment and uninitialized symbol
      Bluetooth: btusb: Enable quirk boolean flag for Mediatek Chip.

qhjindev (1):
      fddi/skfp: fix typo

wengjianfeng (7):
      rtw88: remove unnecessary variable
      nfc: s3fwrn5: remove unnecessary label
      nfc/fdp: remove unnecessary assignment and label
      nfc: pn533: remove redundant assignment
      nfc: st-nci: remove unnecessary label
      qtnfmac: remove meaningless labels
      qtnfmac: remove meaningless goto statement and labels

wenxu (2):
      netfilter: flowtable: add vlan match offload support
      netfilter: flowtable: add vlan pop action offload support

ybaruch (5):
      iwlwifi: change step in so-gf struct
      iwlwifi: change name to AX 211 and 411 family
      iwlwifi: add 160Mhz to killer 1550 name
      iwlwifi: add ax201 killer device
      iwlwifi: add new so-gf device

zuoqilin (3):
      nfc/fdp: Simplify the return expression of fdp_nci_open()
      tools/testing: Remove unused variable
      mwifiex: Remove unneeded variable: "ret"

Álvaro Fernández Rojas (7):
      net: dsa: b53: spi: allow device tree probing
      dt-bindings: net: Add bcm6368-mdio-mux bindings
      net: mdio: Add BCM6368 MDIO mux bus controller
      net: dsa: b53: relax is63xx() condition
      net: dsa: tag_brcm: add support for legacy tags
      net: dsa: b53: support legacy tags
      net: dsa: b53: mmap: Add device tree support

 Documentation/ABI/testing/sysfs-bus-pci            |   29 +
 Documentation/ABI/testing/sysfs-class-net-phydev   |   12 +
 Documentation/admin-guide/sysctl/net.rst           |   11 +
 Documentation/bpf/bpf_design_QA.rst                |   15 +
 Documentation/bpf/bpf_devel_QA.rst                 |   30 +-
 Documentation/bpf/btf.rst                          |   17 +-
 Documentation/bpf/index.rst                        |    9 +-
 .../devicetree/bindings/net/actions,owl-emac.yaml  |   92 +
 .../devicetree/bindings/net/brcm,bcm4908-enet.yaml |   17 +-
 .../bindings/net/brcm,bcm6368-mdio-mux.yaml        |   76 +
 .../devicetree/bindings/net/broadcom-bluetooth.txt |   56 -
 .../bindings/net/broadcom-bluetooth.yaml           |  118 +
 .../devicetree/bindings/net/can/rcar_can.txt       |    5 +-
 Documentation/devicetree/bindings/net/dsa/dsa.yaml |    9 +
 .../devicetree/bindings/net/dsa/lantiq-gswip.txt   |    4 +
 .../devicetree/bindings/net/dsa/microchip,ksz.yaml |    2 +
 .../devicetree/bindings/net/fsl-enetc.txt          |   15 +
 .../devicetree/bindings/net/idt,3243x-emac.yaml    |   73 +
 .../bindings/net/intel,ixp4xx-ethernet.yaml        |  102 +
 .../devicetree/bindings/net/mdio-gpio.txt          |    1 +
 .../devicetree/bindings/net/qcom,ipa.yaml          |   26 +-
 .../devicetree/bindings/net/renesas,etheravb.yaml  |   11 +-
 .../devicetree/bindings/net/rockchip-dwmac.txt     |   76 -
 .../devicetree/bindings/net/rockchip-dwmac.yaml    |  120 +
 .../devicetree/bindings/net/snps,dwmac.yaml        |   13 +-
 .../devicetree/bindings/net/wireless/ieee80211.txt |   24 -
 .../bindings/net/wireless/ieee80211.yaml           |   45 +
 .../bindings/net/wireless/mediatek,mt76.txt        |   78 -
 .../bindings/net/wireless/mediatek,mt76.yaml       |  228 ++
 .../devicetree/bindings/net/xilinx_axienet.txt     |   25 +-
 .../devicetree/bindings/serial/ingenic,uart.yaml   |    2 +-
 Documentation/networking/can.rst                   |    2 +
 .../device_drivers/ethernet/mellanox/mlx5.rst      |   34 +
 .../device_drivers/ethernet/microsoft/netvsc.rst   |   14 +-
 .../networking/device_drivers/fddi/defza.rst       |    2 +-
 .../networking/devlink/devlink-health.rst          |   17 +-
 Documentation/networking/dsa/configuration.rst     |  330 +-
 Documentation/networking/dsa/dsa.rst               |  372 +-
 Documentation/networking/ethtool-netlink.rst       |  269 +-
 Documentation/networking/filter.rst                |    2 +-
 Documentation/networking/index.rst                 |    1 +
 Documentation/networking/ip-sysctl.rst             |   10 +-
 .../networking/nexthop-group-resilient.rst         |  293 ++
 Documentation/networking/nf_flowtable.rst          |  172 +-
 Documentation/networking/phy.rst                   |    4 +-
 Documentation/networking/statistics.rst            |   46 +-
 Documentation/networking/switchdev.rst             |  200 +-
 Documentation/networking/timestamping.rst          |   63 +-
 Documentation/networking/x25-iface.rst             |   65 +-
 Documentation/userspace-api/ebpf/index.rst         |   17 +
 Documentation/userspace-api/ebpf/syscall.rst       |   24 +
 Documentation/userspace-api/index.rst              |    1 +
 MAINTAINERS                                        |   31 +-
 arch/arm/boot/dts/uniphier-pxs2.dtsi               |    2 +-
 arch/arm/mach-mvebu/kirkwood.c                     |    3 +-
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi     |    6 +
 arch/arm64/boot/dts/rockchip/rk3328.dtsi           |    4 +-
 arch/arm64/boot/dts/socionext/uniphier-ld20.dtsi   |    2 +-
 arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi   |    4 +-
 arch/mips/rb532/devices.c                          |   25 +-
 arch/mips/sgi-ip27/TODO                            |   19 -
 arch/powerpc/boot/dts/fsl/bsc9131si-post.dtsi      |    4 -
 arch/powerpc/boot/dts/fsl/bsc9132si-post.dtsi      |    4 -
 arch/powerpc/boot/dts/fsl/c293si-post.dtsi         |    4 -
 arch/powerpc/boot/dts/fsl/p1010si-post.dtsi        |   21 -
 arch/powerpc/sysdev/tsi108_dev.c                   |    5 +-
 arch/s390/net/bpf_jit_comp.c                       |   64 +-
 arch/x86/net/bpf_jit_comp.c                        |    5 +
 arch/x86/net/bpf_jit_comp32.c                      |  198 +
 drivers/atm/fore200e.c                             |    1 -
 drivers/atm/idt77252.c                             |    6 -
 drivers/atm/iphase.c                               |    2 +-
 drivers/atm/suni.c                                 |    1 -
 drivers/bcma/driver_mips.c                         |    7 -
 drivers/bluetooth/Kconfig                          |   10 +
 drivers/bluetooth/Makefile                         |    2 +
 drivers/bluetooth/btintel.c                        |  232 +-
 drivers/bluetooth/btintel.h                        |   19 +-
 drivers/bluetooth/btusb.c                          |  408 +--
 drivers/bluetooth/hci_bcm.c                        |   19 +
 drivers/bluetooth/hci_intel.c                      |    7 +-
 drivers/bluetooth/hci_qca.c                        |   17 +-
 drivers/bluetooth/virtio_bt.c                      |  401 ++
 drivers/infiniband/hw/mlx5/fs.c                    |    2 +-
 drivers/infiniband/hw/mlx5/ib_rep.c                |    5 +-
 drivers/infiniband/hw/mlx5/main.c                  |    3 +-
 drivers/isdn/hardware/mISDN/hfcmulti.c             |    9 +-
 drivers/isdn/hardware/mISDN/iohelper.h             |   14 +-
 drivers/isdn/mISDN/dsp_core.c                      |   13 +-
 drivers/isdn/mISDN/l1oip_core.c                    |    9 +-
 drivers/net/Kconfig                                |    3 +
 drivers/net/Makefile                               |    3 +-
 drivers/net/Space.c                                |    3 -
 drivers/net/bareudp.c                              |    1 +
 drivers/net/bonding/bond_alb.c                     |    2 +-
 drivers/net/bonding/bond_main.c                    |    9 +-
 drivers/net/bonding/bond_options.c                 |    9 +
 drivers/net/can/Kconfig                            |    2 +-
 drivers/net/can/c_can/c_can.c                      |  153 +-
 drivers/net/can/c_can/c_can.h                      |   43 +-
 drivers/net/can/c_can/c_can_pci.c                  |   31 +-
 drivers/net/can/c_can/c_can_platform.c             |    6 +-
 drivers/net/can/dev/bittiming.c                    |   28 +-
 drivers/net/can/dev/netlink.c                      |   27 +-
 drivers/net/can/dev/skb.c                          |   37 +-
 drivers/net/can/grcan.c                            |    2 +-
 drivers/net/can/m_can/m_can.c                      |  167 +-
 drivers/net/can/m_can/m_can.h                      |    2 +
 drivers/net/can/m_can/tcan4x5x.h                   |    1 -
 drivers/net/can/rcar/rcar_can.c                    |    2 +-
 drivers/net/can/rcar/rcar_canfd.c                  |    2 +-
 drivers/net/can/sja1000/sja1000.c                  |    2 +-
 drivers/net/can/spi/hi311x.c                       |    2 +-
 drivers/net/can/spi/mcp251x.c                      |    2 +-
 drivers/net/can/spi/mcp251xfd/Kconfig              |    1 +
 drivers/net/can/spi/mcp251xfd/Makefile             |    3 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |  125 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c     |  285 ++
 drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.h     |   45 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c   |   64 +-
 .../net/can/spi/mcp251xfd/mcp251xfd-timestamp.c    |   71 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h          |   28 +
 drivers/net/can/usb/Kconfig                        |   10 +
 drivers/net/can/usb/Makefile                       |    1 +
 drivers/net/can/usb/ems_usb.c                      |    2 +-
 drivers/net/can/usb/esd_usb2.c                     |    4 +-
 drivers/net/can/usb/etas_es58x/Makefile            |    3 +
 drivers/net/can/usb/etas_es58x/es581_4.c           |  507 +++
 drivers/net/can/usb/etas_es58x/es581_4.h           |  207 ++
 drivers/net/can/usb/etas_es58x/es58x_core.c        | 2301 ++++++++++++
 drivers/net/can/usb/etas_es58x/es58x_core.h        |  700 ++++
 drivers/net/can/usb/etas_es58x/es58x_fd.c          |  562 +++
 drivers/net/can/usb/etas_es58x/es58x_fd.h          |  243 ++
 drivers/net/can/usb/gs_usb.c                       |    2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |    2 +-
 drivers/net/can/usb/mcba_usb.c                     |    2 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c            |  106 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   64 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.h       |    9 +-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |   50 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |   52 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.h        |   82 +-
 drivers/net/can/usb/ucan.c                         |    8 +-
 drivers/net/can/usb/usb_8dev.c                     |    2 +-
 drivers/net/can/xilinx_can.c                       |   10 +-
 drivers/net/dsa/Kconfig                            |   17 +-
 drivers/net/dsa/b53/Kconfig                        |    1 +
 drivers/net/dsa/b53/b53_common.c                   |   23 +-
 drivers/net/dsa/b53/b53_mmap.c                     |   55 +
 drivers/net/dsa/b53/b53_priv.h                     |    4 -
 drivers/net/dsa/b53/b53_spi.c                      |   14 +
 drivers/net/dsa/bcm_sf2.c                          |  121 +-
 drivers/net/dsa/bcm_sf2.h                          |    2 +
 drivers/net/dsa/bcm_sf2_regs.h                     |    8 +-
 drivers/net/dsa/hirschmann/hellcreek.c             |  378 +-
 drivers/net/dsa/hirschmann/hellcreek.h             |    7 +
 drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c    |   28 +-
 drivers/net/dsa/hirschmann/hellcreek_hwtstamp.h    |    4 +-
 drivers/net/dsa/lantiq_gswip.c                     |  162 +-
 drivers/net/dsa/microchip/Kconfig                  |   10 +-
 drivers/net/dsa/microchip/Makefile                 |    1 +
 drivers/net/dsa/microchip/ksz8.h                   |   69 +
 drivers/net/dsa/microchip/ksz8795.c                |  884 +++--
 drivers/net/dsa/microchip/ksz8795_reg.h            |  125 +-
 drivers/net/dsa/microchip/ksz8795_spi.c            |   46 +-
 drivers/net/dsa/microchip/ksz8863_smi.c            |  213 ++
 drivers/net/dsa/microchip/ksz_common.h             |    5 +-
 drivers/net/dsa/mt7530.c                           |  196 +-
 drivers/net/dsa/mt7530.h                           |   15 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |  599 ++-
 drivers/net/dsa/mv88e6xxx/chip.h                   |   44 +-
 drivers/net/dsa/mv88e6xxx/devlink.c                |   58 +-
 drivers/net/dsa/mv88e6xxx/global1.c                |   19 +-
 drivers/net/dsa/mv88e6xxx/global1.h                |    2 +
 drivers/net/dsa/mv88e6xxx/global2.c                |   17 +
 drivers/net/dsa/mv88e6xxx/global2.h                |   12 +-
 drivers/net/dsa/mv88e6xxx/global2_scratch.c        |    6 +-
 drivers/net/dsa/mv88e6xxx/hwtstamp.c               |   26 +-
 drivers/net/dsa/mv88e6xxx/hwtstamp.h               |   10 +-
 drivers/net/dsa/mv88e6xxx/port.c                   |  418 ++-
 drivers/net/dsa/mv88e6xxx/port.h                   |   50 +
 drivers/net/dsa/mv88e6xxx/serdes.c                 |  344 +-
 drivers/net/dsa/mv88e6xxx/serdes.h                 |   98 +-
 drivers/net/dsa/ocelot/felix.c                     |   23 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             |   12 +-
 drivers/net/dsa/sja1105/sja1105_flower.c           |    9 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |   18 +-
 drivers/net/dsa/sja1105/sja1105_ptp.c              |   16 +-
 drivers/net/dsa/sja1105/sja1105_ptp.h              |    4 +-
 drivers/net/ethernet/3com/3c509.c                  |    1 +
 drivers/net/ethernet/Kconfig                       |    5 +-
 drivers/net/ethernet/Makefile                      |    2 +
 drivers/net/ethernet/actions/Kconfig               |   26 +
 drivers/net/ethernet/actions/Makefile              |    6 +
 drivers/net/ethernet/actions/owl-emac.c            | 1625 +++++++++
 drivers/net/ethernet/actions/owl-emac.h            |  280 ++
 drivers/net/ethernet/aeroflex/greth.c              |    6 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |   10 +-
 drivers/net/ethernet/altera/altera_tse_main.c      |    7 +-
 drivers/net/ethernet/amazon/ena/ena_com.c          |    4 +-
 drivers/net/ethernet/amazon/ena/ena_com.h          |    2 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |   25 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |   23 +-
 drivers/net/ethernet/amd/amd8111e.c                |  362 +-
 drivers/net/ethernet/amd/hplance.c                 |    3 +
 drivers/net/ethernet/amd/pcnet32.c                 |    3 +-
 drivers/net/ethernet/arc/emac_main.c               |    8 +-
 drivers/net/ethernet/atheros/Kconfig               |    1 +
 drivers/net/ethernet/atheros/ag71xx.c              |   31 +-
 drivers/net/ethernet/atheros/atl1c/atl1c.h         |    2 +
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |   74 +-
 drivers/net/ethernet/atheros/atlx/atl2.c           |   24 +-
 drivers/net/ethernet/broadcom/bcm4908_enet.c       |  143 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |    7 +-
 drivers/net/ethernet/broadcom/bgmac-bcma.c         |   10 +-
 drivers/net/ethernet/broadcom/bgmac-platform.c     |   11 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |    3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  264 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   32 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  154 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c    |   74 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.h    |    1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c      |  122 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.h      |   12 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |   20 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |    1 -
 drivers/net/ethernet/brocade/bna/bnad_ethtool.c    |  266 +-
 drivers/net/ethernet/cadence/macb.h                |   14 +
 drivers/net/ethernet/cadence/macb_main.c           |   59 +-
 .../net/ethernet/cavium/liquidio/cn23xx_pf_regs.h  |    2 +-
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c   |    8 +-
 drivers/net/ethernet/cavium/thunder/nicvf_queues.c |    2 +-
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c  |    5 +-
 drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c      |    3 +-
 drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c     |    3 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_cudbg.c   |    3 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |   24 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c |   11 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c  |    8 +-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c      |   10 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |   13 +-
 drivers/net/ethernet/davicom/dm9000.c              |   11 +-
 drivers/net/ethernet/dec/tulip/de2104x.c           |   13 +-
 drivers/net/ethernet/dec/tulip/winbond-840.c       |   13 +-
 drivers/net/ethernet/dlink/sundance.c              |   15 +-
 drivers/net/ethernet/ethoc.c                       |    6 +-
 drivers/net/ethernet/ezchip/nps_enet.c             |    7 +-
 drivers/net/ethernet/faraday/ftmac100.c            |   13 +-
 drivers/net/ethernet/fealnx.c                      |   13 +-
 drivers/net/ethernet/freescale/Kconfig             |    1 +
 drivers/net/ethernet/freescale/Makefile            |    4 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |   12 +-
 drivers/net/ethernet/freescale/dpaa2/Kconfig       |    8 +
 drivers/net/ethernet/freescale/dpaa2/Makefile      |    2 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   68 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h   |   10 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |   40 +
 .../freescale/dpaa2/dpaa2-switch-ethtool.c}        |    2 +-
 .../ethernet/freescale/dpaa2/dpaa2-switch-flower.c |  492 +++
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    | 3394 +++++++++++++++++
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.h    |  246 ++
 drivers/net/ethernet/freescale/dpaa2/dpkg.h        |    5 +-
 drivers/net/ethernet/freescale/dpaa2/dpmac.h       |   24 +-
 drivers/net/ethernet/freescale/dpaa2/dpni.c        |    6 +
 drivers/net/ethernet/freescale/dpaa2/dpni.h        |  162 +-
 drivers/net/ethernet/freescale/dpaa2/dprtc.h       |    3 -
 .../ethernet/freescale/dpaa2}/dpsw-cmd.h           |  219 +-
 .../ethsw => net/ethernet/freescale/dpaa2}/dpsw.c  |  781 ++--
 drivers/net/ethernet/freescale/dpaa2/dpsw.h        |  755 ++++
 drivers/net/ethernet/freescale/enetc/Kconfig       |    9 +
 drivers/net/ethernet/freescale/enetc/Makefile      |    3 +
 drivers/net/ethernet/freescale/enetc/enetc.c       | 1418 +++++--
 drivers/net/ethernet/freescale/enetc/enetc.h       |  129 +-
 drivers/net/ethernet/freescale/enetc/enetc_cbdr.c  |   82 +-
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |   40 +-
 drivers/net/ethernet/freescale/enetc/enetc_hw.h    |   16 +
 drivers/net/ethernet/freescale/enetc/enetc_ierb.c  |  155 +
 drivers/net/ethernet/freescale/enetc/enetc_ierb.h  |   20 +
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |  229 +-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |   21 +-
 drivers/net/ethernet/freescale/enetc/enetc_vf.c    |    8 +
 drivers/net/ethernet/freescale/fec_main.c          |   17 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c       |    7 +-
 drivers/net/ethernet/freescale/fman/mac.c          |    9 +-
 .../net/ethernet/freescale/fs_enet/fs_enet-main.c  |    5 +-
 drivers/net/ethernet/freescale/gianfar.c           |  178 +-
 drivers/net/ethernet/freescale/gianfar.h           |   17 -
 drivers/net/ethernet/freescale/ucc_geth.c          |    5 +-
 drivers/net/ethernet/google/gve/gve_ethtool.c      |    8 +-
 drivers/net/ethernet/hisilicon/hisi_femac.c        |    7 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c      |    7 +-
 drivers/net/ethernet/hisilicon/hns/hnae.h          |    6 -
 drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c  |   22 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_gmac.c |   27 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c  |    2 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h  |    4 -
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c |   16 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c |    2 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c  |   41 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c  |   95 +-
 .../net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c    |   26 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |   10 +-
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c   |  106 +-
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |    3 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   17 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |    5 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  210 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |    9 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   21 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |   14 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   70 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |   25 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |   10 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 2263 +++++++-----
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   64 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   38 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c    |   39 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h    |    2 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |   20 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |    1 -
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |    7 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  101 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |    6 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |    6 +
 drivers/net/ethernet/hisilicon/hns_mdio.c          |    4 +-
 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c  |   29 +-
 .../net/ethernet/huawei/hinic/hinic_hw_api_cmd.c   |    8 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.c    |    2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c  |    6 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c    |    1 -
 drivers/net/ethernet/huawei/hinic/hinic_rx.c       |    8 +-
 drivers/net/ethernet/huawei/hinic/hinic_tx.c       |    1 +
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |    1 +
 drivers/net/ethernet/ibm/ibmvnic.c                 |  124 +-
 drivers/net/ethernet/ibm/ibmvnic.h                 |   94 -
 drivers/net/ethernet/intel/Kconfig                 |    1 +
 drivers/net/ethernet/intel/e1000/e1000_hw.c        |    1 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |    4 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |   18 +-
 drivers/net/ethernet/intel/e1000e/phy.c            |    2 +-
 drivers/net/ethernet/intel/e1000e/ptp.c            |    2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_dcbnl.c     |    4 +-
 drivers/net/ethernet/intel/fm10k/fm10k_debugfs.c   |    2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_main.c      |    4 +-
 drivers/net/ethernet/intel/fm10k/fm10k_mbx.c       |    4 +-
 drivers/net/ethernet/intel/fm10k/fm10k_pf.c        |    2 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |    2 +
 drivers/net/ethernet/intel/i40e/i40e_common.c      |    6 +-
 drivers/net/ethernet/intel/i40e/i40e_dcb.c         |    4 +-
 drivers/net/ethernet/intel/i40e/i40e_dcb_nl.c      |    2 +-
 drivers/net/ethernet/intel/i40e/i40e_ddp.c         |    2 +-
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c     |    4 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   18 +-
 drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c     |    2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   33 +-
 drivers/net/ethernet/intel/i40e/i40e_nvm.c         |    2 +-
 drivers/net/ethernet/intel/i40e/i40e_ptp.c         |    2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   17 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |  108 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |   13 +-
 drivers/net/ethernet/intel/iavf/Makefile           |    3 +-
 drivers/net/ethernet/intel/iavf/iavf.h             |   22 +
 drivers/net/ethernet/intel/iavf/iavf_adv_rss.c     |  218 ++
 drivers/net/ethernet/intel/iavf/iavf_adv_rss.h     |   95 +
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |  883 ++++-
 drivers/net/ethernet/intel/iavf/iavf_fdir.c        |  779 ++++
 drivers/net/ethernet/intel/iavf/iavf_fdir.h        |  118 +
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   62 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c        |   17 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |  360 +-
 drivers/net/ethernet/intel/ice/Makefile            |    3 +-
 drivers/net/ethernet/intel/ice/ice.h               |  111 +-
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h    |   24 +-
 drivers/net/ethernet/intel/ice/ice_arfs.c          |    6 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |   48 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |  197 +-
 drivers/net/ethernet/intel/ice/ice_common.h        |   10 +-
 drivers/net/ethernet/intel/ice/ice_controlq.c      |    8 +-
 drivers/net/ethernet/intel/ice/ice_controlq.h      |    5 +-
 drivers/net/ethernet/intel/ice/ice_dcb.c           |   10 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c       |    2 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |  373 +-
 drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c  |    6 +-
 drivers/net/ethernet/intel/ice/ice_fdir.c          |  488 ++-
 drivers/net/ethernet/intel/ice/ice_fdir.h          |   58 +
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c     |  571 ++-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.h     |    3 +-
 drivers/net/ethernet/intel/ice/ice_flex_type.h     |   91 +-
 drivers/net/ethernet/intel/ice/ice_flow.c          |  835 ++++-
 drivers/net/ethernet/intel/ice/ice_flow.h          |  166 +-
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h    |   19 +
 drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h     |   22 +
 drivers/net/ethernet/intel/ice/ice_lib.c           |  443 ++-
 drivers/net/ethernet/intel/ice/ice_lib.h           |    7 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  784 ++--
 drivers/net/ethernet/intel/ice/ice_nvm.c           |    1 +
 drivers/net/ethernet/intel/ice/ice_protocol_type.h |   10 +
 drivers/net/ethernet/intel/ice/ice_sched.c         |  133 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c         |  400 +-
 drivers/net/ethernet/intel/ice/ice_sriov.h         |   20 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        |    2 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |  338 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h          |   45 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c      |    1 +
 drivers/net/ethernet/intel/ice/ice_type.h          |  117 +-
 .../ethernet/intel/ice/ice_virtchnl_allowlist.c    |  171 +
 .../ethernet/intel/ice/ice_virtchnl_allowlist.h    |   13 +
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c | 2204 +++++++++++
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.h |   55 +
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |  774 +++-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h   |   21 +
 drivers/net/ethernet/intel/ice/ice_xsk.c           |   21 +-
 drivers/net/ethernet/intel/igb/e1000_defines.h     |    8 +-
 drivers/net/ethernet/intel/igb/e1000_mac.c         |   27 +
 drivers/net/ethernet/intel/igb/e1000_mbx.c         |    2 +-
 drivers/net/ethernet/intel/igb/e1000_phy.c         |    1 +
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |   41 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   25 +-
 drivers/net/ethernet/intel/igb/igb_ptp.c           |    1 +
 drivers/net/ethernet/intel/igc/Makefile            |    2 +-
 drivers/net/ethernet/intel/igc/igc.h               |   31 +-
 drivers/net/ethernet/intel/igc/igc_defines.h       |   68 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c       |    2 +
 drivers/net/ethernet/intel/igc/igc_i225.c          |    6 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |  539 ++-
 drivers/net/ethernet/intel/igc/igc_ptp.c           |  320 +-
 drivers/net/ethernet/intel/igc/igc_regs.h          |   10 +
 drivers/net/ethernet/intel/igc/igc_xdp.c           |   60 +
 drivers/net/ethernet/intel/igc/igc_xdp.h           |   13 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c     |    4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c    |   16 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c    |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |   40 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c       |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   15 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c       |    8 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c       |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h      |    5 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_x540.c      |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c      |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   11 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |    1 +
 drivers/net/ethernet/intel/ixgbevf/vf.c            |   18 +-
 drivers/net/ethernet/intel/ixgbevf/vf.h            |    3 -
 drivers/net/ethernet/korina.c                      |  617 +++-
 drivers/net/ethernet/lantiq_xrx200.c               |   11 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c         |   11 +-
 drivers/net/ethernet/marvell/mvneta.c              |   31 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   13 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c     |  107 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.h     |    3 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |   60 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   89 +-
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |    7 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   17 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cpt.c    |  192 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |    4 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   10 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  196 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |   79 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |   21 +
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |    2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   20 +
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |   47 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   37 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_reg.h  |    1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |  787 ++++
 .../net/ethernet/marvell/prestera/prestera_main.c  |   14 +-
 .../net/ethernet/marvell/prestera/prestera_pci.c   |    1 +
 .../ethernet/marvell/prestera/prestera_switchdev.c |    2 +-
 drivers/net/ethernet/marvell/pxa168_eth.c          |    9 +-
 drivers/net/ethernet/marvell/skge.c                |    9 +-
 drivers/net/ethernet/marvell/sky2.c                |   19 +-
 drivers/net/ethernet/mediatek/Kconfig              |    2 +
 drivers/net/ethernet/mediatek/Makefile             |    2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  315 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |   73 +-
 drivers/net/ethernet/mediatek/mtk_ppe.c            |  509 +++
 drivers/net/ethernet/mediatek/mtk_ppe.h            |  288 ++
 drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c    |  217 ++
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |  495 +++
 drivers/net/ethernet/mediatek/mtk_ppe_regs.h       |  144 +
 drivers/net/ethernet/mellanox/mlx4/cmd.c           |   69 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |   12 +
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   12 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   32 +-
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |    3 -
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   72 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.h  |    1 +
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |    5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   57 +-
 .../net/ethernet/mellanox/mlx5/core/en/devlink.c   |   43 +-
 .../net/ethernet/mellanox/mlx5/core/en/devlink.h   |    6 +
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   60 +-
 .../mellanox/mlx5/core/en/fs_tt_redirect.c         |  605 +++
 .../mellanox/mlx5/core/en/fs_tt_redirect.h         |   26 +
 .../net/ethernet/mellanox/mlx5/core/en/health.c    |    2 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  548 ++-
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |   53 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |  399 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h   |   32 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c   |    4 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |   91 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |  183 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |   27 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   54 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |    1 +
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.h    |   10 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c  |  203 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   15 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   56 +-
 .../mellanox/mlx5/core/en_accel/en_accel.h         |    7 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |    4 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |   11 +
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |  131 +-
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h        |   20 +
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |    9 -
 .../mellanox/mlx5/core/en_accel/tls_rxtx.h         |   14 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |   99 +-
 .../net/ethernet/mellanox/mlx5/core/en_common.c    |   27 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |   34 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  434 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  147 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 1149 ++----
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  309 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   10 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |    6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  292 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |   15 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  225 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   13 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |    5 +
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   27 +-
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c       |    2 +-
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c       |    4 +-
 .../ethernet/mellanox/mlx5/core/esw/acl/helper.c   |    8 +-
 .../ethernet/mellanox/mlx5/core/esw/acl/helper.h   |    2 +-
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c      |    2 +-
 .../mellanox/mlx5/core/esw/acl/ingress_ofld.c      |    4 +-
 .../ethernet/mellanox/mlx5/core/esw/devlink_port.c |    9 +-
 .../ethernet/mellanox/mlx5/core/esw/indir_table.h  |    6 +-
 .../net/ethernet/mellanox/mlx5/core/esw/legacy.c   |  510 +++
 .../net/ethernet/mellanox/mlx5/core/esw/legacy.h   |   22 +
 .../net/ethernet/mellanox/mlx5/core/esw/sample.c   |  585 +++
 .../net/ethernet/mellanox/mlx5/core/esw/sample.h   |   42 +
 .../net/ethernet/mellanox/mlx5/core/esw/vporttbl.c |  140 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  979 ++---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  277 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  724 ++--
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |   14 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.c   |    9 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  102 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |    7 +
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |   16 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |   13 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |    6 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   38 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   |    2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |   25 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.h    |   11 +
 .../net/ethernet/mellanox/mlx5/core/lib/crypto.c   |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h   |   15 +-
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |   52 +-
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.h    |    6 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c  |   15 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h |    9 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  149 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   20 +-
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |   74 +-
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |  110 +-
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c     |    1 -
 drivers/net/ethernet/mellanox/mlx5/core/rl.c       |  139 +-
 .../net/ethernet/mellanox/mlx5/core/sf/dev/dev.c   |   12 +-
 .../net/ethernet/mellanox/mlx5/core/sf/dev/dev.h   |    2 +-
 .../ethernet/mellanox/mlx5/core/sf/dev/driver.c    |   14 +-
 .../net/ethernet/mellanox/mlx5/core/sf/devlink.c   |   43 +-
 .../net/ethernet/mellanox/mlx5/core/sf/hw_table.c  |  269 +-
 drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h  |    9 +-
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |   48 +-
 .../mellanox/mlx5/core/steering/dr_action.c        |  242 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |   70 +-
 .../mellanox/mlx5/core/steering/dr_matcher.c       |  256 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |   11 +
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |   65 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |  145 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.h  |   31 +-
 .../mellanox/mlx5/core/steering/dr_ste_v0.c        |  368 +-
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        |  289 +-
 .../mellanox/mlx5/core/steering/dr_table.c         |    4 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |  205 +-
 .../mellanox/mlx5/core/steering/mlx5_ifc_dr.h      |   16 +-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |   14 -
 drivers/net/ethernet/mellanox/mlx5/core/wq.c       |    5 -
 drivers/net/ethernet/mellanox/mlxsw/core.c         |    6 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h         |   21 +-
 .../mellanox/mlxsw/core_acl_flex_actions.c         |  131 +
 .../mellanox/mlxsw/core_acl_flex_actions.h         |   11 +
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c |   27 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c          |   55 +-
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h       |   71 +
 drivers/net/ethernet/mellanox/mlxsw/reg.h          |  130 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  215 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |   76 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c |   25 +
 .../mellanox/mlxsw/spectrum_acl_flex_actions.c     |   83 +
 .../net/ethernet/mellanox/mlxsw/spectrum_dpipe.c   |   21 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_ethtool.c |  129 +
 .../net/ethernet/mellanox/mlxsw/spectrum_flow.c    |    2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  |   23 +
 .../net/ethernet/mellanox/mlxsw/spectrum_ipip.c    |   10 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_ipip.h    |    3 +-
 .../ethernet/mellanox/mlxsw/spectrum_matchall.c    |  245 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h |    1 -
 .../ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c   |   15 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_qdisc.c   |  453 ++-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  682 +++-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.h  |   12 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c    |   21 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_span.h    |   16 +
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c   |   79 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_trap.c    |  213 +-
 drivers/net/ethernet/micrel/ks8851_common.c        |    7 +-
 drivers/net/ethernet/microchip/encx24j600.c        |   15 +-
 drivers/net/ethernet/microchip/lan743x_ethtool.c   |    4 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |    7 +-
 drivers/net/ethernet/microsoft/Kconfig             |   29 +
 drivers/net/ethernet/microsoft/Makefile            |    5 +
 drivers/net/ethernet/microsoft/mana/Makefile       |    6 +
 drivers/net/ethernet/microsoft/mana/gdma.h         |  673 ++++
 drivers/net/ethernet/microsoft/mana/gdma_main.c    | 1415 +++++++
 drivers/net/ethernet/microsoft/mana/hw_channel.c   |  843 +++++
 drivers/net/ethernet/microsoft/mana/hw_channel.h   |  190 +
 drivers/net/ethernet/microsoft/mana/mana.h         |  533 +++
 drivers/net/ethernet/microsoft/mana/mana_en.c      | 1895 ++++++++++
 drivers/net/ethernet/microsoft/mana/mana_ethtool.c |  250 ++
 drivers/net/ethernet/microsoft/mana/shm_channel.c  |  291 ++
 drivers/net/ethernet/microsoft/mana/shm_channel.h  |   21 +
 drivers/net/ethernet/moxa/moxart_ether.c           |    1 -
 drivers/net/ethernet/mscc/Kconfig                  |    3 +-
 drivers/net/ethernet/mscc/ocelot.c                 |  188 +-
 drivers/net/ethernet/mscc/ocelot_flower.c          |    5 +
 drivers/net/ethernet/mscc/ocelot_mrp.c             |  225 +-
 drivers/net/ethernet/mscc/ocelot_net.c             |  234 +-
 drivers/net/ethernet/mscc/ocelot_ptp.c             |    2 +
 drivers/net/ethernet/mscc/ocelot_vcap.c            |    1 +
 drivers/net/ethernet/neterion/s2io.c               |    2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.h     |   14 +-
 drivers/net/ethernet/netronome/nfp/abm/main.c      |    4 +-
 drivers/net/ethernet/netronome/nfp/flower/main.h   |    4 +-
 .../net/ethernet/netronome/nfp/flower/qos_conf.c   |  156 +-
 drivers/net/ethernet/netronome/nfp/nfp_app.h       |    1 -
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c   |    1 +
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   79 +-
 drivers/net/ethernet/netronome/nfp/nfp_port.h      |    2 -
 drivers/net/ethernet/nxp/lpc_eth.c                 |   13 +-
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h    |    9 -
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |    1 +
 drivers/net/ethernet/pensando/ionic/Makefile       |    1 +
 drivers/net/ethernet/pensando/ionic/ionic.h        |    6 +
 .../net/ethernet/pensando/ionic/ionic_bus_pci.c    |    4 +
 drivers/net/ethernet/pensando/ionic/ionic_dev.c    |  107 +-
 drivers/net/ethernet/pensando/ionic/ionic_dev.h    |   33 +-
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    |  109 +-
 drivers/net/ethernet/pensando/ionic/ionic_if.h     |  242 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  536 ++-
 drivers/net/ethernet/pensando/ionic/ionic_lif.h    |  104 +-
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |   43 +-
 drivers/net/ethernet/pensando/ionic/ionic_phc.c    |  615 ++++
 .../net/ethernet/pensando/ionic/ionic_rx_filter.c  |   21 +
 .../net/ethernet/pensando/ionic/ionic_rx_filter.h  |    1 +
 drivers/net/ethernet/pensando/ionic/ionic_stats.c  |  392 +-
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |  871 +++--
 drivers/net/ethernet/pensando/ionic/ionic_txrx.h   |    3 +
 drivers/net/ethernet/qlogic/qed/qed_l2.c           |    1 +
 drivers/net/ethernet/qlogic/qed/qed_sriov.c        |    1 +
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |   26 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |    1 -
 drivers/net/ethernet/qualcomm/emac/emac-mac.c      |    4 +-
 drivers/net/ethernet/qualcomm/qca_spi.c            |   10 +-
 drivers/net/ethernet/qualcomm/qca_uart.c           |    9 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   |   10 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h    |   12 -
 .../ethernet/qualcomm/rmnet/rmnet_map_command.c    |   11 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   |   56 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   68 +-
 drivers/net/ethernet/renesas/ravb.h                |    1 +
 drivers/net/ethernet/renesas/ravb_main.c           |   62 +-
 drivers/net/ethernet/renesas/sh_eth.c              |   15 +-
 drivers/net/ethernet/renesas/sh_eth.h              |  114 +-
 drivers/net/ethernet/rocker/rocker_main.c          |    4 +-
 .../net/ethernet/samsung/sxgbe/sxgbe_platform.c    |   13 +-
 drivers/net/ethernet/sfc/ef10.c                    |   20 +-
 drivers/net/ethernet/sfc/efx_channels.c            |    2 +
 drivers/net/ethernet/sfc/enum.h                    |    1 -
 drivers/net/ethernet/sfc/ethtool.c                 |   10 +
 drivers/net/ethernet/sfc/falcon/net_driver.h       |    2 +-
 drivers/net/ethernet/sfc/farch.c                   |   16 +-
 drivers/net/ethernet/sfc/net_driver.h              |    3 +
 drivers/net/ethernet/sfc/rx.c                      |   11 +-
 drivers/net/ethernet/sfc/tx.c                      |   15 +-
 drivers/net/ethernet/smsc/smc91x.c                 |    2 +-
 drivers/net/ethernet/smsc/smsc911x.c               |    2 +
 drivers/net/ethernet/socionext/netsec.c            |   16 +-
 drivers/net/ethernet/socionext/sni_ave.c           |   10 +-
 drivers/net/ethernet/stmicro/stmmac/Makefile       |    1 +
 drivers/net/ethernet/stmicro/stmmac/common.h       |   37 +
 .../net/ethernet/stmicro/stmmac/dwmac-anarion.c    |    2 +-
 .../ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c    |    2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-generic.c    |    2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c    |   62 +-
 .../net/ethernet/stmicro/stmmac/dwmac-intel-plat.c |    2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |  410 ++-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.h  |    1 +
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c    |    4 +-
 .../net/ethernet/stmicro/stmmac/dwmac-lpc18xx.c    |    2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-mediatek.c   |    2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-meson.c  |    2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-meson8b.c    |    2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-oxnas.c  |    2 +-
 .../ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c    |    3 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |    2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    |    2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c    |    2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-stm32.c  |    2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |   26 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c  |    2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-visconti.c   |    2 +-
 .../net/ethernet/stmicro/stmmac/dwmac1000_dma.c    |    2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h       |   15 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |    8 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |   22 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h   |   25 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c   |   30 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c       |  136 +
 drivers/net/ethernet/stmicro/stmmac/dwmac5.h       |   44 +
 drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h    |   22 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c    |    8 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h     |    6 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |   15 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |   24 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   92 +-
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |  124 +-
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |   50 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  | 2903 ++++++++++++---
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c  |  111 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c   |    2 -
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   44 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.h  |    2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |   75 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h   |   24 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |  124 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c   |  135 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.h   |   15 +
 drivers/net/ethernet/sun/cassini.c                 |    1 +
 drivers/net/ethernet/sun/sungem.c                  |    4 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   19 +-
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c      |    4 +-
 drivers/net/ethernet/ti/cpsw.c                     |   21 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |   21 +-
 drivers/net/ethernet/ti/cpsw_priv.c                |   11 +-
 drivers/net/ethernet/ti/cpsw_switchdev.c           |    4 +-
 drivers/net/ethernet/ti/davinci_emac.c             |   12 +-
 drivers/net/ethernet/ti/netcp_core.c               |    7 +-
 drivers/net/ethernet/toshiba/spider_net.c          |   42 +-
 drivers/net/ethernet/toshiba/tc35815.c             |    3 +-
 drivers/net/ethernet/via/via-velocity.c            |    2 +-
 drivers/net/ethernet/wiznet/w5100-spi.c            |    8 +-
 drivers/net/ethernet/wiznet/w5100.c                |    2 +-
 drivers/net/ethernet/xilinx/Kconfig                |    3 +
 drivers/net/ethernet/xilinx/ll_temac_main.c        |    8 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |    8 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |   50 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c  |    4 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |    8 +-
 drivers/net/ethernet/xircom/xirc2ps_cs.c           |    2 -
 drivers/net/ethernet/xscale/Kconfig                |    1 +
 drivers/net/ethernet/xscale/ixp4xx_eth.c           |  215 +-
 drivers/net/fddi/Kconfig                           |   16 -
 drivers/net/fddi/defxx.c                           |   96 +-
 drivers/net/fddi/defxx.h                           |    5 +-
 drivers/net/fddi/defza.c                           |    2 +-
 drivers/net/fddi/skfp/h/smc.h                      |    2 +-
 drivers/net/fddi/skfp/h/smt.h                      |   12 +-
 drivers/net/fddi/skfp/smt.c                        |    4 +-
 drivers/net/geneve.c                               |    5 +-
 drivers/net/hyperv/hyperv_net.h                    |    6 +-
 drivers/net/hyperv/netvsc.c                        |   55 +-
 drivers/net/hyperv/netvsc_drv.c                    |   65 +-
 drivers/net/ieee802154/mac802154_hwsim.c           |    2 +-
 drivers/net/ipa/Kconfig                            |    5 +-
 drivers/net/ipa/Makefile                           |    6 +-
 drivers/net/ipa/gsi.c                              |  106 +-
 drivers/net/ipa/gsi.h                              |    4 +-
 drivers/net/ipa/gsi_private.h                      |    4 +-
 drivers/net/ipa/gsi_reg.h                          |   69 +-
 drivers/net/ipa/gsi_trans.c                        |   13 +-
 drivers/net/ipa/gsi_trans.h                        |    5 +-
 drivers/net/ipa/ipa.h                              |    7 +-
 drivers/net/ipa/ipa_cmd.c                          |   28 +-
 drivers/net/ipa/ipa_cmd.h                          |   19 +-
 .../ipa/{ipa_data-sdm845.c => ipa_data-v3.5.1.c}   |  229 +-
 drivers/net/ipa/ipa_data-v4.11.c                   |  382 ++
 .../net/ipa/{ipa_data-sc7180.c => ipa_data-v4.2.c} |  158 +-
 drivers/net/ipa/ipa_data-v4.5.c                    |  437 +++
 drivers/net/ipa/ipa_data-v4.9.c                    |  430 +++
 drivers/net/ipa/ipa_data.h                         |  131 +-
 drivers/net/ipa/ipa_endpoint.c                     |   82 +-
 drivers/net/ipa/ipa_endpoint.h                     |   32 +-
 drivers/net/ipa/ipa_interrupt.c                    |   54 +-
 drivers/net/ipa/ipa_interrupt.h                    |    1 +
 drivers/net/ipa/ipa_main.c                         |  330 +-
 drivers/net/ipa/ipa_mem.c                          |   15 +-
 drivers/net/ipa/ipa_mem.h                          |   21 +-
 drivers/net/ipa/ipa_modem.c                        |   34 +-
 drivers/net/ipa/ipa_qmi.c                          |   14 +-
 drivers/net/ipa/ipa_qmi.h                          |   14 +-
 drivers/net/ipa/ipa_qmi_msg.c                      |   78 +-
 drivers/net/ipa/ipa_qmi_msg.h                      |    6 +-
 drivers/net/ipa/ipa_reg.h                          |  495 ++-
 drivers/net/ipa/ipa_resource.c                     |  176 +
 drivers/net/ipa/ipa_resource.h                     |   23 +
 drivers/net/ipa/ipa_smp2p.h                        |    2 +-
 drivers/net/ipa/ipa_table.c                        |  117 +-
 drivers/net/ipa/ipa_table.h                        |   27 +-
 drivers/net/ipa/ipa_uc.c                           |    5 +-
 drivers/net/ipa/ipa_version.h                      |   29 +-
 drivers/net/macvlan.c                              |   64 +-
 drivers/net/mdio.c                                 |    2 +-
 drivers/net/mdio/Kconfig                           |   11 +
 drivers/net/mdio/Makefile                          |    1 +
 drivers/net/mdio/mdio-bcm-unimac.c                 |   16 +-
 drivers/net/mdio/mdio-bitbang.c                    |   12 +-
 drivers/net/mdio/mdio-cavium.c                     |    2 +-
 drivers/net/mdio/mdio-gpio.c                       |   18 +-
 drivers/net/mdio/mdio-ipq4019.c                    |    4 +-
 drivers/net/mdio/mdio-ipq8064.c                    |    4 +-
 drivers/net/mdio/mdio-mscc-miim.c                  |    8 +-
 drivers/net/mdio/mdio-mux-bcm-iproc.c              |   14 +-
 drivers/net/mdio/mdio-mux-bcm6368.c                |  184 +
 drivers/net/mdio/mdio-mux-gpio.c                   |    8 +-
 drivers/net/mdio/mdio-mux-mmioreg.c                |    6 +-
 drivers/net/mdio/mdio-mux-multiplexer.c            |    2 +-
 drivers/net/mdio/mdio-mux.c                        |    6 +-
 drivers/net/mdio/mdio-octeon.c                     |    8 +-
 drivers/net/mdio/mdio-thunder.c                    |   10 +-
 drivers/net/mdio/mdio-xgene.c                      |    6 +-
 drivers/net/mdio/of_mdio.c                         |   10 +-
 drivers/net/mhi/mhi.h                              |    1 +
 drivers/net/mhi/net.c                              |    7 +-
 drivers/net/mhi/proto_mbim.c                       |   62 +-
 drivers/net/netdevsim/Makefile                     |    4 +
 drivers/net/netdevsim/dev.c                        |   17 +-
 drivers/net/netdevsim/ethtool.c                    |   36 +
 drivers/net/netdevsim/fib.c                        |  147 +-
 drivers/net/netdevsim/health.c                     |   11 +-
 drivers/net/netdevsim/netdevsim.h                  |   18 +
 drivers/net/netdevsim/psample.c                    |  265 ++
 drivers/net/pcs/pcs-xpcs.c                         |  257 +-
 drivers/net/phy/Kconfig                            |   12 +
 drivers/net/phy/Makefile                           |    2 +
 drivers/net/phy/at803x.c                           |  100 +-
 drivers/net/phy/broadcom.c                         |   76 +-
 drivers/net/phy/intel-xway.c                       |   21 +
 drivers/net/phy/marvell-88x2222.c                  |  621 ++++
 drivers/net/phy/marvell.c                          |  559 +--
 drivers/net/phy/marvell10g.c                       |  386 +-
 drivers/net/phy/mdio-boardinfo.c                   |    2 +-
 drivers/net/phy/mdio_bus.c                         |    2 +-
 drivers/net/phy/mscc/mscc_main.c                   |  217 +-
 drivers/net/phy/nxp-c45-tja11xx.c                  |  621 ++++
 drivers/net/phy/phy-c45.c                          |   51 +
 drivers/net/phy/phy.c                              |    3 +-
 drivers/net/phy/phy_device.c                       |   52 +-
 drivers/net/phy/phylink.c                          |    5 +-
 drivers/net/phy/sfp-bus.c                          |   20 +
 drivers/net/phy/sfp.c                              |   25 +
 drivers/net/phy/sfp.h                              |    3 +
 drivers/net/phy/smsc.c                             |    7 +-
 drivers/net/plip/plip.c                            |    2 +
 drivers/net/ppp/ppp_deflate.c                      |    1 -
 drivers/net/ppp/ppp_generic.c                      |   22 +
 drivers/net/ppp/pppoe.c                            |   27 +-
 drivers/net/tun.c                                  |   16 +-
 drivers/net/usb/asix_devices.c                     |   12 +-
 drivers/net/usb/ax88179_178a.c                     |    6 +-
 drivers/net/usb/cdc_ether.c                        |   27 +-
 drivers/net/usb/cdc_ncm.c                          |   56 +-
 drivers/net/usb/dm9601.c                           |    4 +-
 drivers/net/usb/hso.c                              |    2 +-
 drivers/net/usb/lan78xx.c                          |    1 -
 drivers/net/usb/mcs7830.c                          |    4 +-
 drivers/net/usb/r8152.c                            | 3853 +++++++++++++++++---
 drivers/net/usb/sierra_net.c                       |    4 +-
 drivers/net/usb/smsc75xx.c                         |    4 +-
 drivers/net/usb/sr9700.c                           |    4 +-
 drivers/net/usb/sr9800.c                           |    4 +-
 drivers/net/usb/usbnet.c                           |   38 +-
 drivers/net/veth.c                                 |  199 +-
 drivers/net/virtio_net.c                           |  190 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c              |   53 +-
 drivers/net/vxlan.c                                |    2 +
 drivers/net/wan/farsync.c                          |    3 +-
 drivers/net/wan/hdlc_x25.c                         |   30 +-
 drivers/net/wan/lapbether.c                        |   85 +-
 drivers/net/wan/z85230.h                           |   39 -
 drivers/net/wireless/ath/ath10k/htc.c              |    2 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |   29 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |    3 +
 drivers/net/wireless/ath/ath11k/ahb.c              |    2 +-
 drivers/net/wireless/ath/ath11k/ce.c               |   58 +-
 drivers/net/wireless/ath/ath11k/ce.h               |    1 +
 drivers/net/wireless/ath/ath11k/core.c             |   45 +-
 drivers/net/wireless/ath/ath11k/core.h             |    6 +
 .../net/wireless/ath/ath11k/debugfs_htt_stats.c    |    2 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  476 +--
 drivers/net/wireless/ath/ath11k/dp_tx.c            |    6 +-
 drivers/net/wireless/ath/ath11k/hal.c              |   96 +-
 drivers/net/wireless/ath/ath11k/hal.h              |   33 +-
 drivers/net/wireless/ath/ath11k/hal_desc.h         |   13 +-
 drivers/net/wireless/ath/ath11k/hal_tx.c           |    3 +
 drivers/net/wireless/ath/ath11k/hal_tx.h           |    1 +
 drivers/net/wireless/ath/ath11k/hif.h              |   10 +
 drivers/net/wireless/ath/ath11k/hw.c               |  796 ++++
 drivers/net/wireless/ath/ath11k/hw.h               |   53 +
 drivers/net/wireless/ath/ath11k/mac.c              |  103 +-
 drivers/net/wireless/ath/ath11k/mac.h              |    2 +
 drivers/net/wireless/ath/ath11k/mhi.c              |  125 +-
 drivers/net/wireless/ath/ath11k/pci.c              |  194 +-
 drivers/net/wireless/ath/ath11k/pci.h              |   21 +-
 drivers/net/wireless/ath/ath11k/qmi.c              |  118 +-
 drivers/net/wireless/ath/ath11k/qmi.h              |    9 +-
 drivers/net/wireless/ath/ath11k/rx_desc.h          |  212 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |   64 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    2 +-
 drivers/net/wireless/ath/ath9k/hw.c                |    2 +-
 drivers/net/wireless/ath/ath9k/init.c              |    5 +-
 drivers/net/wireless/ath/carl9170/carl9170.h       |    7 +-
 drivers/net/wireless/ath/carl9170/tx.c             |    2 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |    2 +-
 drivers/net/wireless/broadcom/b43/main.c           |    2 +-
 drivers/net/wireless/broadcom/b43legacy/main.c     |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/debug.h   |    1 -
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.h |    2 +-
 drivers/net/wireless/cisco/airo.c                  |  117 +-
 drivers/net/wireless/intel/ipw2x00/libipw_wx.c     |    6 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |    2 -
 drivers/net/wireless/intel/iwlegacy/common.c       |    2 -
 drivers/net/wireless/intel/iwlegacy/common.h       |    2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   72 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |    2 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |   78 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |   13 +-
 .../net/wireless/intel/iwlwifi/fw/api/location.h   |  173 +-
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |   20 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h  |   22 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |   30 -
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |    8 +
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |    4 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |    3 +
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |    5 +-
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |   59 +
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |    1 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   12 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |    3 +
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |    5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |    4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |   14 +-
 drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h   |    4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c     |   91 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |    6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |   11 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |    2 +
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |   10 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |   85 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-responder.c |   27 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  232 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   59 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |   20 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |    6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   58 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  128 +
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |   38 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   27 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   18 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   80 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |    5 +
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   68 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |    8 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   29 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |    7 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   80 +-
 drivers/net/wireless/intel/iwlwifi/queue/tx.c      |   41 +-
 drivers/net/wireless/intel/iwlwifi/queue/tx.h      |    3 +-
 drivers/net/wireless/mac80211_hwsim.c              |   24 +-
 drivers/net/wireless/marvell/libertas/decl.h       |    1 -
 drivers/net/wireless/marvell/libertas/mesh.h       |   12 +-
 .../net/wireless/marvell/libertas_tf/libertas_tf.h |    1 -
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   11 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        |    3 +-
 drivers/net/wireless/marvell/mwl8k.c               |    1 +
 drivers/net/wireless/mediatek/mt76/agg-rx.c        |   19 +-
 drivers/net/wireless/mediatek/mt76/debugfs.c       |   28 +
 drivers/net/wireless/mediatek/mt76/dma.c           |   65 +-
 drivers/net/wireless/mediatek/mt76/dma.h           |    1 +
 drivers/net/wireless/mediatek/mt76/eeprom.c        |  240 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   77 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   99 +-
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |    4 +-
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |    3 +
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |   35 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c    |    5 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/pci.c    |    2 +-
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |   61 +-
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |   71 +-
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |    1 +
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |   42 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  424 +--
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h    |    8 +
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |  209 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |  299 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h    |   34 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |   27 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   31 +-
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c    |    6 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_init.c   |   17 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_mac.c    |  183 +-
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |   20 +-
 .../net/wireless/mediatek/mt76/mt7615/sdio_txrx.c  |   11 +-
 drivers/net/wireless/mediatek/mt76/mt7615/soc.c    |    4 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_sdio.c   |    7 +-
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |   59 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |   23 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  272 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |   81 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |    6 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |    3 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |    4 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c   |    5 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |    6 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |    4 +
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c    |    6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/Makefile |    2 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |  116 +-
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    |  112 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |  184 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h |   51 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |  220 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  258 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.h    |   15 +
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |  132 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  437 ++-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |   16 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |  152 +
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |  106 +-
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |   37 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |   18 +
 .../net/wireless/mediatek/mt76/mt7915/testmode.c   |   22 +-
 drivers/net/wireless/mediatek/mt76/mt7921/Makefile |    4 +-
 .../net/wireless/mediatek/mt76/mt7921/debugfs.c    |  168 +-
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c    |  242 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |   48 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |  525 ++-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.h    |   10 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  236 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  210 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h    |   60 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |   83 +-
 .../wireless/mediatek/mt76/mt7921/mt7921_trace.h   |   51 +
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |   54 +-
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |   54 +-
 drivers/net/wireless/mediatek/mt76/mt7921/trace.c  |   12 +
 drivers/net/wireless/mediatek/mt76/sdio.c          |    3 +
 drivers/net/wireless/mediatek/mt76/testmode.c      |  159 +-
 drivers/net/wireless/mediatek/mt76/testmode.h      |    2 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |   94 +-
 drivers/net/wireless/mediatek/mt7601u/eeprom.c     |    2 +-
 drivers/net/wireless/mediatek/mt7601u/init.c       |    1 +
 drivers/net/wireless/microchip/wilc1000/Kconfig    |    1 +
 drivers/net/wireless/microchip/wilc1000/netdev.c   |   39 +-
 drivers/net/wireless/microchip/wilc1000/sdio.c     |    2 +-
 drivers/net/wireless/microchip/wilc1000/spi.c      |  298 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c     |   56 +-
 drivers/net/wireless/microchip/wilc1000/wlan.h     |    7 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |   27 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |   67 -
 drivers/net/wireless/quantenna/qtnfmac/event.c     |    6 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c     |    6 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |    1 -
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   19 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        |   15 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |   38 +-
 drivers/net/wireless/realtek/rtlwifi/core.h        |    1 +
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |    2 -
 .../net/wireless/realtek/rtlwifi/rtl8192de/sw.c    |   10 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/table.c |  500 ++-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |    4 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |    9 +-
 drivers/net/wireless/realtek/rtw88/coex.c          |   13 +-
 drivers/net/wireless/realtek/rtw88/coex.h          |    9 +
 drivers/net/wireless/realtek/rtw88/debug.c         |  134 +-
 drivers/net/wireless/realtek/rtw88/debug.h         |    1 +
 drivers/net/wireless/realtek/rtw88/fw.c            |   27 +
 drivers/net/wireless/realtek/rtw88/fw.h            |   18 +
 drivers/net/wireless/realtek/rtw88/hci.h           |   16 +
 drivers/net/wireless/realtek/rtw88/mac.c           |   19 +
 drivers/net/wireless/realtek/rtw88/mac.h           |    4 +
 drivers/net/wireless/realtek/rtw88/mac80211.c      |    2 +
 drivers/net/wireless/realtek/rtw88/main.c          |  104 +-
 drivers/net/wireless/realtek/rtw88/main.h          |   57 +
 drivers/net/wireless/realtek/rtw88/pci.c           |   98 +-
 drivers/net/wireless/realtek/rtw88/pci.h           |    1 +
 drivers/net/wireless/realtek/rtw88/phy.c           |   95 +-
 drivers/net/wireless/realtek/rtw88/phy.h           |    3 +
 drivers/net/wireless/realtek/rtw88/reg.h           |   15 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |    3 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |  892 ++++-
 drivers/net/wireless/realtek/rtw88/rtw8822c.h      |  339 +-
 .../net/wireless/realtek/rtw88/rtw8822c_table.c    |  686 ++--
 drivers/net/wireless/rsi/rsi_91x_ps.c              |    1 -
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |    2 +-
 drivers/net/wireless/rsi/rsi_boot_params.h         |    2 +-
 drivers/net/wireless/rsi/rsi_coex.h                |    2 +-
 drivers/net/wireless/rsi/rsi_common.h              |    2 +-
 drivers/net/wireless/rsi/rsi_debugfs.h             |    2 +-
 drivers/net/wireless/rsi/rsi_hal.h                 |    2 +-
 drivers/net/wireless/rsi/rsi_main.h                |    2 +-
 drivers/net/wireless/rsi/rsi_mgmt.h                |    2 +-
 drivers/net/wireless/rsi/rsi_ps.h                  |    2 +-
 drivers/net/wireless/rsi/rsi_sdio.h                |    2 +-
 drivers/net/wireless/rsi/rsi_usb.h                 |    2 +-
 drivers/net/wireless/st/cw1200/bh.c                |    3 -
 drivers/net/wireless/st/cw1200/wsm.h               |   12 -
 drivers/net/wireless/ti/wlcore/boot.c              |   13 +-
 drivers/net/wireless/ti/wlcore/debugfs.h           |    7 +-
 drivers/net/wireless/wl3501.h                      |   49 +-
 drivers/net/wireless/wl3501_cs.c                   |   54 +-
 drivers/net/wwan/Kconfig                           |   37 +
 drivers/net/wwan/Makefile                          |    9 +
 drivers/net/wwan/mhi_wwan_ctrl.c                   |  284 ++
 drivers/net/wwan/wwan_core.c                       |  554 +++
 drivers/net/xen-netfront.c                         |   18 +-
 drivers/nfc/fdp/fdp.c                              |   49 +-
 drivers/nfc/pn533/i2c.c                            |    8 +-
 drivers/nfc/pn533/pn533.c                          |   20 +-
 drivers/nfc/s3fwrn5/core.c                         |   12 +-
 drivers/nfc/st-nci/spi.c                           |    7 +-
 drivers/of/of_net.c                                |   88 +-
 drivers/pci/iov.c                                  |  102 +-
 drivers/pci/pci-sysfs.c                            |    3 +-
 drivers/pci/pci.h                                  |    3 +-
 drivers/phy/phy-core-mipi-dphy.c                   |    2 -
 drivers/phy/rockchip/phy-rockchip-inno-dsidphy.c   |    8 +-
 drivers/ptp/ptp_clockmatrix.c                      |    4 +-
 drivers/ptp/ptp_pch.c                              |   21 +-
 drivers/s390/net/qeth_core_main.c                  |   18 +-
 drivers/s390/net/qeth_l3_main.c                    |   31 +-
 drivers/scsi/aacraid/TODO                          |    3 -
 drivers/staging/Kconfig                            |    2 -
 drivers/staging/Makefile                           |    1 -
 drivers/staging/fsl-dpaa2/Kconfig                  |   19 -
 drivers/staging/fsl-dpaa2/Makefile                 |    6 -
 drivers/staging/fsl-dpaa2/ethsw/Makefile           |   10 -
 drivers/staging/fsl-dpaa2/ethsw/README             |  106 -
 drivers/staging/fsl-dpaa2/ethsw/TODO               |   13 -
 drivers/staging/fsl-dpaa2/ethsw/dpsw.h             |  594 ---
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c            | 1839 ----------
 drivers/staging/fsl-dpaa2/ethsw/ethsw.h            |   80 -
 drivers/staging/octeon/ethernet.c                  |   10 +-
 drivers/staging/wfx/main.c                         |    7 +-
 fs/befs/TODO                                       |   14 -
 fs/jffs2/TODO                                      |   37 -
 fs/proc/proc_sysctl.c                              |    6 +
 fs/seq_file.c                                      |   18 +
 include/linux/atm_suni.h                           |   12 -
 include/linux/avf/virtchnl.h                       |  303 ++
 include/linux/bpf-cgroup.h                         |   58 +-
 include/linux/bpf.h                                |  159 +-
 include/linux/bpf_local_storage.h                  |    3 +-
 include/linux/bpf_lsm.h                            |   22 -
 include/linux/bpf_types.h                          |    8 +-
 include/linux/bpf_verifier.h                       |   12 +
 include/linux/btf.h                                |    7 +
 include/linux/can/bittiming.h                      |   79 +
 include/linux/can/dev.h                            |   14 +-
 include/linux/can/skb.h                            |    3 +-
 include/linux/dsa/ocelot.h                         |    5 -
 include/linux/dsa/sja1105.h                        |    3 +-
 include/linux/etherdevice.h                        |    4 +-
 include/linux/ethtool.h                            |  189 +-
 include/linux/filter.h                             |   44 +-
 include/linux/ieee80211.h                          |   33 +-
 include/linux/if_bridge.h                          |   40 +
 include/linux/if_rmnet.h                           |   65 +-
 include/linux/marvell_phy.h                        |    8 +-
 include/linux/mdio-bitbang.h                       |    3 +
 include/linux/mlx5/device.h                        |    9 +-
 include/linux/mlx5/driver.h                        |   22 +-
 include/linux/mlx5/eswitch.h                       |   28 +-
 include/linux/mlx5/mlx5_ifc.h                      |  123 +-
 include/linux/mlx5/port.h                          |   12 +
 include/linux/mlx5/vport.h                         |    8 -
 include/linux/netdevice.h                          |  138 +-
 include/linux/netfilter/ipset/ip_set.h             |    2 -
 include/linux/netfilter/nfnetlink.h                |   62 +-
 include/linux/netfilter/x_tables.h                 |   16 +-
 include/linux/netfilter_arp/arp_tables.h           |    8 +-
 include/linux/netfilter_bridge/ebtables.h          |    9 +-
 include/linux/netfilter_ipv4/ip_tables.h           |   11 +-
 include/linux/netfilter_ipv6/ip6_tables.h          |   11 +-
 include/linux/netlink.h                            |   12 +-
 include/linux/of_net.h                             |    6 +-
 include/linux/pci.h                                |    8 +
 include/linux/pcs/pcs-xpcs.h                       |    5 +
 include/linux/phy.h                                |    6 +
 include/linux/phylink.h                            |    2 +
 include/linux/platform_data/eth_ixp4xx.h           |    2 +
 include/linux/platform_data/hirschmann-hellcreek.h |    1 +
 include/linux/ppp_channel.h                        |    3 +
 include/linux/ptp_pch.h                            |   22 +
 include/linux/qed/qed_chain.h                      |    8 +-
 include/linux/qed/qed_ll2_if.h                     |    1 -
 include/linux/sched.h                              |    5 +
 include/linux/seq_file.h                           |    4 +
 include/linux/sfp.h                                |   10 +
 include/linux/skbuff.h                             |   33 +-
 include/linux/skmsg.h                              |  162 +-
 include/linux/socket.h                             |    2 +-
 include/linux/stmmac.h                             |   46 +
 include/linux/sysctl.h                             |    2 +
 include/linux/udp.h                                |   22 +-
 include/linux/usb/usbnet.h                         |   11 +-
 include/linux/wwan.h                               |  111 +
 include/net/addrconf.h                             |    1 -
 include/net/bluetooth/hci.h                        |    1 +
 include/net/bluetooth/hci_core.h                   |   17 +-
 include/net/bluetooth/l2cap.h                      |    1 +
 include/net/bluetooth/mgmt.h                       |    1 +
 include/net/bpf_sk_storage.h                       |    1 -
 include/net/cfg80211.h                             |   24 +-
 include/net/devlink.h                              |    5 +-
 include/net/dsa.h                                  |   43 +-
 include/net/flow.h                                 |    3 -
 include/net/flow_dissector.h                       |    6 +-
 include/net/flow_offload.h                         |    6 +
 include/net/gro.h                                  |   13 +
 include/net/if_inet6.h                             |   37 +-
 include/net/ipv6.h                                 |    1 +
 include/net/ipv6_stubs.h                           |    2 +
 include/net/lapb.h                                 |    2 +-
 include/net/mac80211.h                             |   12 +-
 include/net/mld.h                                  |    3 +
 include/net/mptcp.h                                |   48 +-
 include/net/net_namespace.h                        |   14 -
 include/net/netfilter/ipv4/nf_defrag_ipv4.h        |    3 +-
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h     |    3 -
 include/net/netfilter/ipv6/nf_defrag_ipv6.h        |    9 +-
 include/net/netfilter/nf_conntrack.h               |   15 +
 include/net/netfilter/nf_conntrack_ecache.h        |   33 +-
 include/net/netfilter/nf_flow_table.h              |   67 +-
 include/net/netfilter/nf_log.h                     |   25 -
 include/net/netfilter/nf_nat.h                     |    2 -
 include/net/netfilter/nf_tables.h                  |   40 +-
 include/net/netfilter/nf_tables_offload.h          |   13 +-
 include/net/netns/conntrack.h                      |   27 +-
 include/net/netns/dccp.h                           |   12 -
 include/net/netns/ipv4.h                           |  143 +-
 include/net/netns/ipv6.h                           |   37 +-
 include/net/netns/mib.h                            |   30 +-
 include/net/netns/netfilter.h                      |    6 -
 include/net/netns/nftables.h                       |    7 -
 include/net/netns/x_tables.h                       |    9 -
 include/net/nexthop.h                              |   76 +-
 include/net/pkt_sched.h                            |    9 +
 include/net/psample.h                              |   21 +-
 include/net/sch_generic.h                          |   14 +
 include/net/selftests.h                            |   31 +
 include/net/sock.h                                 |    6 +
 include/net/switchdev.h                            |    2 +
 include/net/tc_act/tc_police.h                     |   52 +
 include/net/tcp.h                                  |   86 +-
 include/net/udp.h                                  |   30 +-
 include/net/xdp_sock.h                             |   19 -
 include/soc/mscc/ocelot.h                          |   46 +-
 include/soc/mscc/ocelot_ptp.h                      |    2 -
 include/trace/events/mptcp.h                       |  173 +
 include/trace/events/xdp.h                         |   62 +-
 include/uapi/linux/bpf.h                           |  834 ++++-
 include/uapi/linux/btf.h                           |    5 +-
 include/uapi/linux/ethtool.h                       |   55 +-
 include/uapi/linux/ethtool_netlink.h               |  187 +
 include/uapi/linux/icmp.h                          |   42 +
 include/uapi/linux/icmpv6.h                        |    3 +
 include/uapi/linux/if_fddi.h                       |    2 +-
 include/uapi/linux/if_link.h                       |    1 +
 include/uapi/linux/mdio.h                          |    2 +
 include/uapi/linux/mptcp.h                         |   11 +
 include/uapi/linux/netfilter/nf_tables.h           |    6 +
 include/uapi/linux/nexthop.h                       |   47 +-
 include/uapi/linux/nl80211.h                       |   22 +
 include/uapi/linux/pkt_cls.h                       |    2 +
 include/uapi/linux/psample.h                       |    7 +
 include/uapi/linux/rtnetlink.h                     |    8 +
 include/uapi/linux/virtio_bt.h                     |   31 +
 include/uapi/linux/virtio_ids.h                    |    1 +
 include/vdso/time64.h                              |    1 +
 init/Kconfig                                       |    2 +
 kernel/bpf/Makefile                                |    3 +-
 kernel/bpf/arraymap.c                              |   42 +
 kernel/bpf/bpf_inode_storage.c                     |    2 +-
 kernel/bpf/bpf_iter.c                              |   16 +
 kernel/bpf/bpf_local_storage.c                     |   39 +-
 kernel/bpf/bpf_lsm.c                               |    8 +-
 kernel/bpf/bpf_task_storage.c                      |  100 +-
 kernel/bpf/btf.c                                   |  325 +-
 kernel/bpf/core.c                                  |   54 +-
 kernel/bpf/cpumap.c                                |   27 +-
 kernel/bpf/devmap.c                                |   47 +-
 kernel/bpf/disasm.c                                |   13 +-
 kernel/bpf/hashtab.c                               |   67 +-
 kernel/bpf/helpers.c                               |  335 +-
 kernel/bpf/inode.c                                 |    2 -
 kernel/bpf/local_storage.c                         |    5 +-
 kernel/bpf/lpm_trie.c                              |    3 +
 kernel/bpf/syscall.c                               |   31 +-
 kernel/bpf/trampoline.c                            |    4 +-
 kernel/bpf/verifier.c                              |  820 ++++-
 kernel/fork.c                                      |    5 +
 kernel/sysctl.c                                    |   65 +
 kernel/trace/bpf_trace.c                           |  371 +-
 lib/test_rhashtable.c                              |    9 +-
 net/6lowpan/nhc_udp.c                              |    4 +-
 net/8021q/vlan.c                                   |    3 +
 net/8021q/vlan.h                                   |    4 +
 net/8021q/vlan_core.c                              |   10 +-
 net/8021q/vlan_dev.c                               |   21 +
 net/9p/client.c                                    |    4 +-
 net/9p/error.c                                     |    2 +-
 net/9p/trans_fd.c                                  |    2 +-
 net/Kconfig                                        |   18 +-
 net/ax25/TODO                                      |   20 -
 net/ax25/af_ax25.c                                 |    1 +
 net/batman-adv/bat_iv_ogm.c                        |    2 +-
 net/batman-adv/bridge_loop_avoidance.c             |    6 +-
 net/batman-adv/multicast.c                         |    6 +-
 net/batman-adv/types.h                             |   10 +-
 net/bluetooth/6lowpan.c                            |    5 +-
 net/bluetooth/Kconfig                              |    7 +
 net/bluetooth/Makefile                             |    1 +
 net/bluetooth/aosp.c                               |   35 +
 net/bluetooth/aosp.h                               |   16 +
 net/bluetooth/ecdh_helper.h                        |    2 +-
 net/bluetooth/hci_conn.c                           |   14 +-
 net/bluetooth/hci_core.c                           |    5 +
 net/bluetooth/hci_debugfs.c                        |    8 +-
 net/bluetooth/hci_event.c                          |   50 +-
 net/bluetooth/hci_request.c                        |   67 +-
 net/bluetooth/l2cap_core.c                         |   43 +-
 net/bluetooth/l2cap_sock.c                         |    8 +
 net/bluetooth/mgmt.c                               |   19 +-
 net/bluetooth/msft.c                               |    8 +
 net/bluetooth/msft.h                               |    6 +
 net/bluetooth/sco.c                                |    4 +-
 net/bluetooth/smp.c                                |  113 +-
 net/bpf/test_run.c                                 |  276 +-
 net/bridge/br_arp_nd_proxy.c                       |    4 +-
 net/bridge/br_device.c                             |   49 +
 net/bridge/br_fdb.c                                |   50 +
 net/bridge/br_input.c                              |    1 +
 net/bridge/br_mdb.c                                |  148 +-
 net/bridge/br_mrp.c                                |    7 +
 net/bridge/br_multicast.c                          |   61 +-
 net/bridge/br_multicast_eht.c                      |  141 +-
 net/bridge/br_netlink.c                            |    4 +-
 net/bridge/br_private.h                            |   23 +-
 net/bridge/br_stp.c                                |   27 +
 net/bridge/br_switchdev.c                          |   44 +-
 net/bridge/br_sysfs_br.c                           |    8 +-
 net/bridge/br_vlan.c                               |  128 +
 net/bridge/br_vlan_tunnel.c                        |    2 +-
 net/bridge/netfilter/Kconfig                       |    4 -
 net/bridge/netfilter/Makefile                      |    3 -
 net/bridge/netfilter/ebt_limit.c                   |    4 +-
 net/bridge/netfilter/ebt_mark.c                    |    4 +-
 net/bridge/netfilter/ebt_mark_m.c                  |    4 +-
 net/bridge/netfilter/ebtable_broute.c              |   10 +-
 net/bridge/netfilter/ebtable_filter.c              |   26 +-
 net/bridge/netfilter/ebtable_nat.c                 |   27 +-
 net/bridge/netfilter/ebtables.c                    |   96 +-
 net/bridge/netfilter/nf_log_bridge.c               |   79 -
 net/can/proc.c                                     |    6 +-
 net/ceph/osdmap.c                                  |    2 +-
 net/core/Makefile                                  |    7 +-
 net/core/bpf_sk_storage.c                          |    2 +-
 net/core/dev.c                                     |  404 +-
 net/core/dev_addr_lists.c                          |    4 +-
 net/core/devlink.c                                 |   11 +-
 net/core/drop_monitor.c                            |    2 +-
 net/core/filter.c                                  |  276 +-
 net/core/flow_dissector.c                          |   47 +-
 net/core/neighbour.c                               |    4 +
 net/core/net-procfs.c                              |    3 -
 net/core/net-sysfs.c                               |  177 +-
 net/core/netevent.c                                |    2 +-
 net/core/rtnetlink.c                               |   15 +-
 net/core/scm.c                                     |   23 +-
 net/core/selftests.c                               |  400 ++
 net/core/skbuff.c                                  |   55 +-
 net/core/skmsg.c                                   |  383 +-
 net/core/sock.c                                    |    2 +-
 net/core/sock_map.c                                |  194 +-
 net/core/sysctl_net_core.c                         |   10 +
 net/dccp/ipv4.c                                    |   24 +-
 net/dccp/ipv6.c                                    |   24 +-
 net/decnet/TODO                                    |   40 -
 net/decnet/dn_nsp_in.c                             |    2 +-
 net/decnet/dn_route.c                              |   49 +-
 net/dsa/Kconfig                                    |   20 +-
 net/dsa/dsa2.c                                     |  105 +-
 net/dsa/dsa_priv.h                                 |   23 +-
 net/dsa/port.c                                     |  199 +-
 net/dsa/slave.c                                    |   95 +-
 net/dsa/switch.c                                   |   25 +-
 net/dsa/tag_brcm.c                                 |  107 +-
 net/dsa/tag_mtk.c                                  |   14 +-
 net/dsa/tag_ocelot.c                               |   35 +-
 net/dsa/tag_ocelot_8021q.c                         |   41 +-
 net/dsa/tag_rtl4_a.c                               |    2 +-
 net/ethernet/eth.c                                 |   24 +-
 net/ethtool/Makefile                               |    2 +-
 net/ethtool/common.h                               |    5 +
 net/ethtool/eeprom.c                               |  246 ++
 net/ethtool/fec.c                                  |  310 ++
 net/ethtool/ioctl.c                                |   37 +-
 net/ethtool/netlink.c                              |   40 +
 net/ethtool/netlink.h                              |   14 +
 net/ethtool/pause.c                                |    6 -
 net/ethtool/stats.c                                |  413 +++
 net/ethtool/strset.c                               |   25 +
 net/hsr/hsr_debugfs.c                              |    2 +-
 net/ipv4/Makefile                                  |    2 +-
 net/ipv4/af_inet.c                                 |    1 +
 net/ipv4/bpf_tcp_ca.c                              |   43 +
 net/ipv4/esp4.c                                    |    6 +-
 net/ipv4/icmp.c                                    |  139 +-
 net/ipv4/ip_output.c                               |    4 +-
 net/ipv4/netfilter.c                               |    2 +
 net/ipv4/netfilter/Kconfig                         |   10 +-
 net/ipv4/netfilter/Makefile                        |    4 -
 net/ipv4/netfilter/arp_tables.c                    |   73 +-
 net/ipv4/netfilter/arptable_filter.c               |   17 +-
 net/ipv4/netfilter/ip_tables.c                     |   86 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |    8 +-
 net/ipv4/netfilter/iptable_filter.c                |   17 +-
 net/ipv4/netfilter/iptable_mangle.c                |   23 +-
 net/ipv4/netfilter/iptable_nat.c                   |   59 +-
 net/ipv4/netfilter/iptable_raw.c                   |   17 +-
 net/ipv4/netfilter/iptable_security.c              |   17 +-
 net/ipv4/netfilter/nf_defrag_ipv4.c                |   46 +-
 net/ipv4/netfilter/nf_log_arp.c                    |  172 -
 net/ipv4/netfilter/nf_log_ipv4.c                   |  395 --
 net/ipv4/nexthop.c                                 | 1570 +++++++-
 net/ipv4/ping.c                                    |    4 +-
 net/ipv4/route.c                                   |  183 +-
 net/ipv4/sysctl_net_ipv4.c                         |  249 +-
 net/ipv4/tcp.c                                     |   12 +
 net/ipv4/tcp_bpf.c                                 |  139 +-
 net/ipv4/tcp_cubic.c                               |   24 +-
 net/ipv4/tcp_input.c                               |   10 +-
 net/ipv4/tcp_ipv4.c                                |   24 +-
 net/ipv4/tcp_lp.c                                  |    4 +-
 net/ipv4/tcp_output.c                              |   20 +-
 net/ipv4/udp.c                                     |   37 +
 net/ipv4/udp_bpf.c                                 |   76 +-
 net/ipv4/udp_offload.c                             |   27 +-
 net/ipv6/addrconf.c                                |   13 +-
 net/ipv6/addrconf_core.c                           |    9 +-
 net/ipv6/af_inet6.c                                |    4 +-
 net/ipv6/ah6.c                                     |    2 +-
 net/ipv6/esp6.c                                    |    2 +-
 net/ipv6/esp6_offload.c                            |    2 +-
 net/ipv6/exthdrs.c                                 |    5 +-
 net/ipv6/icmp.c                                    |   20 +-
 net/ipv6/ip6_gre.c                                 |    7 +-
 net/ipv6/ip6_tunnel.c                              |    5 +-
 net/ipv6/ip6_vti.c                                 |    3 +-
 net/ipv6/mcast.c                                   | 1103 +++---
 net/ipv6/mcast_snoop.c                             |   12 +-
 net/ipv6/netfilter.c                               |    2 +
 net/ipv6/netfilter/Kconfig                         |    5 +-
 net/ipv6/netfilter/Makefile                        |    3 -
 net/ipv6/netfilter/ip6_tables.c                    |   84 +-
 net/ipv6/netfilter/ip6table_filter.c               |   17 +-
 net/ipv6/netfilter/ip6table_mangle.c               |   24 +-
 net/ipv6/netfilter/ip6table_nat.c                  |   58 +-
 net/ipv6/netfilter/ip6table_raw.c                  |   17 +-
 net/ipv6/netfilter/ip6table_security.c             |   17 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |   68 +-
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c          |   40 +-
 net/ipv6/netfilter/nf_log_ipv6.c                   |  427 ---
 net/ipv6/route.c                                   |   33 +-
 net/ipv6/seg6_local.c                              |   13 +-
 net/ipv6/sit.c                                     |    7 +-
 net/ipv6/sysctl_net_ipv6.c                         |   38 +-
 net/ipv6/tcp_ipv6.c                                |   17 +-
 net/ipv6/udp.c                                     |    4 +
 net/ipv6/udp_offload.c                             |    3 +-
 net/iucv/af_iucv.c                                 |    4 +-
 net/kcm/kcmsock.c                                  |    4 +-
 net/l2tp/l2tp_core.c                               |   12 +-
 net/l3mdev/l3mdev.c                                |    4 +-
 net/lapb/lapb_iface.c                              |    4 +-
 net/lapb/lapb_timer.c                              |   19 +-
 net/llc/llc_c_ev.c                                 |    4 +-
 net/llc/llc_core.c                                 |    4 +-
 net/llc/llc_pdu.c                                  |    2 +-
 net/llc/llc_s_ac.c                                 |    2 +-
 net/llc/llc_station.c                              |    2 -
 net/mac80211/aes_cmac.c                            |   11 +-
 net/mac80211/cfg.c                                 |    2 +-
 net/mac80211/debugfs.c                             |    1 +
 net/mac80211/debugfs_sta.c                         |   37 +-
 net/mac80211/ieee80211_i.h                         |    2 +
 net/mac80211/iface.c                               |    3 +-
 net/mac80211/main.c                                |   16 +-
 net/mac80211/mlme.c                                |   16 +-
 net/mac80211/rc80211_minstrel_ht.c                 |    4 +-
 net/mac80211/tx.c                                  |   58 +-
 net/mac80211/util.c                                |   10 +-
 net/mpls/af_mpls.c                                 |    1 -
 net/mptcp/Kconfig                                  |    2 +-
 net/mptcp/Makefile                                 |    4 +-
 net/mptcp/crypto.c                                 |    2 +-
 net/mptcp/mib.c                                    |    3 +
 net/mptcp/mib.h                                    |    3 +
 net/mptcp/options.c                                |  298 +-
 net/mptcp/pm.c                                     |   64 +-
 net/mptcp/pm_netlink.c                             |  328 +-
 net/mptcp/protocol.c                               |  381 +-
 net/mptcp/protocol.h                               |  117 +-
 net/mptcp/sockopt.c                                |  756 ++++
 net/mptcp/subflow.c                                |   58 +-
 net/mptcp/token.c                                  |    2 +-
 net/ncsi/internal.h                                |    2 +-
 net/netfilter/Kconfig                              |   30 +-
 net/netfilter/Makefile                             |    6 +-
 net/netfilter/ipset/ip_set_core.c                  |  182 +-
 net/netfilter/ipvs/ip_vs_core.c                    |    2 +-
 net/netfilter/ipvs/ip_vs_ftp.c                     |    2 -
 net/netfilter/nf_conntrack_acct.c                  |    2 +-
 net/netfilter/nf_conntrack_core.c                  |   53 +-
 net/netfilter/nf_conntrack_ecache.c                |   31 +-
 net/netfilter/nf_conntrack_expect.c                |   22 +-
 net/netfilter/nf_conntrack_helper.c                |   15 +-
 net/netfilter/nf_conntrack_netlink.c               |  384 +-
 net/netfilter/nf_conntrack_proto.c                 |    8 +-
 net/netfilter/nf_conntrack_proto_dccp.c            |    1 +
 net/netfilter/nf_conntrack_proto_tcp.c             |   34 +-
 net/netfilter/nf_conntrack_standalone.c            |   86 +-
 net/netfilter/nf_flow_table_core.c                 |  146 +-
 net/netfilter/nf_flow_table_ip.c                   |  453 ++-
 net/netfilter/nf_flow_table_offload.c              |  275 +-
 net/netfilter/nf_log.c                             |   10 -
 net/netfilter/nf_log_common.c                      |  224 --
 net/netfilter/nf_log_netdev.c                      |   78 -
 net/netfilter/nf_log_syslog.c                      | 1090 ++++++
 net/netfilter/nf_nat_core.c                        |   37 -
 net/netfilter/nf_nat_proto.c                       |   38 +
 net/netfilter/nf_tables_api.c                      | 1800 +++++----
 net/netfilter/nf_tables_offload.c                  |  116 +-
 net/netfilter/nf_tables_trace.c                    |    9 +-
 net/netfilter/nfnetlink.c                          |  115 +-
 net/netfilter/nfnetlink_acct.c                     |   94 +-
 net/netfilter/nfnetlink_cthelper.c                 |   68 +-
 net/netfilter/nfnetlink_cttimeout.c                |  203 +-
 net/netfilter/nfnetlink_log.c                      |   53 +-
 net/netfilter/nfnetlink_osf.c                      |   21 +-
 net/netfilter/nfnetlink_queue.c                    |   98 +-
 net/netfilter/nft_chain_filter.c                   |    8 +-
 net/netfilter/nft_cmp.c                            |   41 +-
 net/netfilter/nft_compat.c                         |   44 +-
 net/netfilter/nft_counter.c                        |   29 +
 net/netfilter/nft_ct.c                             |    1 +
 net/netfilter/nft_dynset.c                         |    3 +-
 net/netfilter/nft_flow_offload.c                   |  211 +-
 net/netfilter/nft_log.c                            |   20 +-
 net/netfilter/nft_lookup.c                         |   12 +-
 net/netfilter/nft_objref.c                         |   11 +-
 net/netfilter/nft_payload.c                        |   13 +-
 net/netfilter/nft_set_hash.c                       |    6 +
 net/netfilter/nft_set_pipapo.c                     |    6 +-
 net/netfilter/nft_set_rbtree.c                     |    6 +
 net/netfilter/nft_socket.c                         |   49 +
 net/netfilter/nft_tproxy.c                         |   24 +
 net/netfilter/x_tables.c                           |   80 +-
 net/netfilter/xt_LOG.c                             |    1 +
 net/netfilter/xt_NFLOG.c                           |    1 +
 net/netfilter/xt_TPROXY.c                          |   13 +
 net/netfilter/xt_TRACE.c                           |    1 +
 net/netfilter/xt_limit.c                           |    6 +-
 net/netfilter/xt_socket.c                          |   14 +
 net/netlabel/netlabel_mgmt.c                       |    2 +-
 net/netrom/nr_in.c                                 |    1 -
 net/nfc/digital_core.c                             |    2 +-
 net/nfc/digital_dep.c                              |    4 +-
 net/nfc/nci/core.c                                 |    2 +-
 net/nfc/nci/uart.c                                 |    4 +-
 net/openvswitch/conntrack.c                        |    6 +-
 net/openvswitch/meter.c                            |    4 +-
 net/openvswitch/vport-netdev.c                     |    7 +-
 net/openvswitch/vport.c                            |    8 +-
 net/openvswitch/vport.h                            |    2 +-
 net/packet/af_packet.c                             |   17 +-
 net/packet/internal.h                              |    2 +-
 net/psample/psample.c                              |   45 +-
 net/qrtr/mhi.c                                     |    8 +-
 net/qrtr/qrtr.c                                    |   42 +-
 net/rds/ib_send.c                                  |    1 -
 net/rds/recv.c                                     |    4 -
 net/rds/send.c                                     |    2 +-
 net/rfkill/input.c                                 |    4 +-
 net/rose/rose_route.c                              |    2 +
 net/rxrpc/rxkad.c                                  |    2 -
 net/sched/act_ct.c                                 |   10 +-
 net/sched/act_police.c                             |   59 +-
 net/sched/act_sample.c                             |   27 +-
 net/sched/cls_api.c                                |    3 +
 net/sched/cls_flower.c                             |   40 +-
 net/sched/sch_cbq.c                                |    4 +-
 net/sched/sch_generic.c                            |   75 +-
 net/sched/sch_taprio.c                             |   70 +-
 net/sctp/sm_make_chunk.c                           |    4 +-
 net/sctp/sm_statefuns.c                            |   10 +-
 net/sctp/socket.c                                  |    2 +-
 net/smc/af_smc.c                                   |    1 -
 net/smc/smc_core.h                                 |    1 -
 net/socket.c                                       |    2 +-
 net/sysctl_net.c                                   |   48 +
 net/tipc/addr.c                                    |    1 +
 net/tipc/addr.h                                    |   46 +-
 net/tipc/bearer.c                                  |   95 +-
 net/tipc/crypto.c                                  |   12 +-
 net/tipc/monitor.c                                 |   63 +-
 net/tipc/msg.c                                     |   23 +-
 net/tipc/name_distr.c                              |   93 +-
 net/tipc/name_table.c                              |  428 +--
 net/tipc/name_table.h                              |   63 +-
 net/tipc/net.c                                     |    8 +-
 net/tipc/netlink_compat.c                          |    2 +-
 net/tipc/node.c                                    |   35 +-
 net/tipc/socket.c                                  |  319 +-
 net/tipc/subscr.c                                  |   86 +-
 net/tipc/subscr.h                                  |   17 +-
 net/tipc/udp_media.c                               |    2 +
 net/tls/tls_device.c                               |    4 +-
 net/tls/tls_sw.c                                   |    4 +-
 net/vmw_vsock/af_vsock.c                           |    2 +-
 net/vmw_vsock/virtio_transport_common.c            |   28 +-
 net/vmw_vsock/vmci_transport.c                     |    3 +-
 net/wireless/core.c                                |    7 +-
 net/wireless/nl80211.c                             |    8 +-
 net/wireless/pmsr.c                                |   12 +-
 net/wireless/reg.c                                 |   12 +-
 net/wireless/scan.c                                |    4 +-
 net/wireless/util.c                                |    2 +-
 net/x25/af_x25.c                                   |    2 +-
 net/xdp/xsk.c                                      |  116 +-
 net/xdp/xsk_queue.h                                |   30 +-
 net/xdp/xskmap.c                                   |   17 +-
 net/xfrm/xfrm_ipcomp.c                             |   25 +-
 net/xfrm/xfrm_policy.c                             |   44 +-
 net/xfrm/xfrm_user.c                               |   12 +-
 samples/bpf/do_hbm_test.sh                         |    2 +-
 samples/bpf/sampleip_kern.c                        |    1 -
 samples/bpf/trace_event_kern.c                     |    1 -
 samples/bpf/tracex1_kern.c                         |    4 +-
 samples/bpf/xdpsock_user.c                         |   55 +-
 samples/pktgen/README.rst                          |   18 +
 samples/pktgen/functions.sh                        |    7 +-
 samples/pktgen/parameters.sh                       |   15 +-
 .../pktgen/pktgen_bench_xmit_mode_netif_receive.sh |    3 -
 .../pktgen/pktgen_bench_xmit_mode_queue_xmit.sh    |    3 -
 samples/pktgen/pktgen_sample01_simple.sh           |   25 +-
 samples/pktgen/pktgen_sample02_multiqueue.sh       |   29 +-
 .../pktgen/pktgen_sample03_burst_single_flow.sh    |   15 +-
 samples/pktgen/pktgen_sample04_many_flows.sh       |   17 +-
 samples/pktgen/pktgen_sample05_flow_per_thread.sh  |   17 +-
 ...tgen_sample06_numa_awared_queue_irq_affinity.sh |   31 +-
 scripts/{bpf_helpers_doc.py => bpf_doc.py}         |  191 +-
 scripts/link-vmlinux.sh                            |    7 +-
 security/selinux/nlmsgtab.c                        |    5 +-
 tools/bpf/Makefile.helpers                         |   60 -
 tools/bpf/bpf_dbg.c                                |    2 +-
 tools/bpf/bpf_exp.y                                |   14 +-
 tools/bpf/bpftool/.gitignore                       |    1 -
 tools/bpf/bpftool/Documentation/Makefile           |   11 +-
 tools/bpf/bpftool/Documentation/bpftool-gen.rst    |   78 +-
 tools/bpf/bpftool/bash-completion/bpftool          |   17 +-
 tools/bpf/bpftool/btf.c                            |   41 +-
 tools/bpf/bpftool/btf_dumper.c                     |    1 +
 tools/bpf/bpftool/common.c                         |    1 +
 tools/bpf/bpftool/feature.c                        |    4 +
 tools/bpf/bpftool/gen.c                            |   72 +-
 tools/bpf/bpftool/main.c                           |    3 +-
 tools/bpf/bpftool/map.c                            |    2 +-
 tools/bpf/bpftool/net.c                            |    2 +-
 tools/bpf/bpftool/prog.c                           |    1 +
 tools/bpf/bpftool/xlated_dumper.c                  |    3 +
 tools/bpf/resolve_btfids/main.c                    |   11 +-
 tools/bpf/runqslower/Makefile                      |    9 +-
 tools/bpf/runqslower/runqslower.bpf.c              |   33 +-
 tools/include/uapi/linux/bpf.h                     |  850 ++++-
 tools/include/uapi/linux/btf.h                     |    5 +-
 tools/lib/bpf/Build                                |    2 +-
 tools/lib/bpf/Makefile                             |    3 +-
 tools/lib/bpf/bpf_core_read.h                      |   16 +-
 tools/lib/bpf/bpf_helpers.h                        |   40 +-
 tools/lib/bpf/bpf_tracing.h                        |   58 +-
 tools/lib/bpf/btf.c                                |  768 ++--
 tools/lib/bpf/btf.h                                |    9 +
 tools/lib/bpf/btf_dump.c                           |   12 +-
 tools/lib/bpf/libbpf.c                             |  905 +++--
 tools/lib/bpf/libbpf.h                             |   20 +-
 tools/lib/bpf/libbpf.map                           |   12 +
 tools/lib/bpf/libbpf_internal.h                    |   85 +-
 tools/lib/bpf/libbpf_util.h                        |   47 -
 tools/lib/bpf/linker.c                             | 2883 +++++++++++++++
 tools/lib/bpf/strset.c                             |  176 +
 tools/lib/bpf/strset.h                             |   21 +
 tools/lib/bpf/xsk.c                                |  258 +-
 tools/lib/bpf/xsk.h                                |   87 +-
 tools/perf/MANIFEST                                |    2 +-
 tools/scripts/Makefile.include                     |   12 +-
 tools/testing/selftests/bpf/.gitignore             |    2 +
 tools/testing/selftests/bpf/Makefile               |   77 +-
 tools/testing/selftests/bpf/Makefile.docs          |   82 +
 tools/testing/selftests/bpf/README.rst             |   71 +
 tools/testing/selftests/bpf/bpf_tcp_helpers.h      |   29 +-
 tools/testing/selftests/bpf/btf_helpers.c          |    4 +
 tools/testing/selftests/bpf/config                 |    2 +
 tools/testing/selftests/bpf/get_cgroup_id_user.c   |    6 +-
 .../selftests/bpf/map_tests/array_map_batch_ops.c  |  109 +-
 .../bpf/map_tests/lpm_trie_map_batch_ops.c         |  158 +
 .../selftests/bpf/prog_tests/attach_probe.c        |   40 +-
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |    1 +
 .../selftests/bpf/prog_tests/bpf_verif_scale.c     |    1 +
 tools/testing/selftests/bpf/prog_tests/btf.c       |  176 +-
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  |    2 +-
 .../testing/selftests/bpf/prog_tests/btf_endian.c  |    4 +-
 .../testing/selftests/bpf/prog_tests/cgroup_link.c |    2 +-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |   52 +-
 .../testing/selftests/bpf/prog_tests/fentry_test.c |   52 +-
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |   58 +-
 .../testing/selftests/bpf/prog_tests/fexit_sleep.c |    4 +-
 .../testing/selftests/bpf/prog_tests/fexit_test.c  |   52 +-
 tools/testing/selftests/bpf/prog_tests/for_each.c  |  130 +
 tools/testing/selftests/bpf/prog_tests/kfree_skb.c |    2 +-
 .../testing/selftests/bpf/prog_tests/kfunc_call.c  |   59 +
 .../selftests/bpf/prog_tests/linked_funcs.c        |   42 +
 .../testing/selftests/bpf/prog_tests/linked_maps.c |   30 +
 .../testing/selftests/bpf/prog_tests/linked_vars.c |   43 +
 tools/testing/selftests/bpf/prog_tests/map_ptr.c   |   15 +-
 tools/testing/selftests/bpf/prog_tests/mmap.c      |   24 +-
 .../selftests/bpf/prog_tests/module_attach.c       |   23 +
 .../selftests/bpf/prog_tests/ns_current_pid_tgid.c |    4 +-
 .../selftests/bpf/prog_tests/prog_run_xattr.c      |   51 +-
 .../selftests/bpf/prog_tests/resolve_btfids.c      |    7 +-
 tools/testing/selftests/bpf/prog_tests/ringbuf.c   |   17 +-
 .../selftests/bpf/prog_tests/ringbuf_multi.c       |   37 +-
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c |   83 +-
 tools/testing/selftests/bpf/prog_tests/snprintf.c  |  125 +
 .../selftests/bpf/prog_tests/snprintf_btf.c        |    4 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c       |   40 +
 .../selftests/bpf/prog_tests/sockmap_listen.c      |  144 +-
 .../testing/selftests/bpf/prog_tests/sockopt_sk.c  |   65 +-
 .../selftests/bpf/prog_tests/static_linked.c       |   40 +
 .../selftests/bpf/prog_tests/task_local_storage.c  |   92 +
 tools/testing/selftests/bpf/prog_tests/test_ima.c  |    6 +-
 tools/testing/selftests/bpf/prog_tests/test_lsm.c  |   61 +-
 tools/testing/selftests/bpf/progs/bind4_prog.c     |   25 +
 tools/testing/selftests/bpf/progs/bind6_prog.c     |   25 +
 tools/testing/selftests/bpf/progs/bpf_cubic.c      |   36 +-
 tools/testing/selftests/bpf/progs/bpf_dctcp.c      |   22 +-
 .../selftests/bpf/progs/bpf_iter_task_stack.c      |   27 +
 ...tf__core_reloc_existence___err_wrong_arr_kind.c |    3 -
 ...re_reloc_existence___err_wrong_arr_value_type.c |    3 -
 ...tf__core_reloc_existence___err_wrong_int_kind.c |    3 -
 .../btf__core_reloc_existence___err_wrong_int_sz.c |    3 -
 ...tf__core_reloc_existence___err_wrong_int_type.c |    3 -
 ..._core_reloc_existence___err_wrong_struct_type.c |    3 -
 .../btf__core_reloc_existence___wrong_field_defs.c |    3 +
 .../bpf/progs/btf_dump_test_case_syntax.c          |    7 +
 .../testing/selftests/bpf/progs/core_reloc_types.h |   25 +-
 tools/testing/selftests/bpf/progs/fentry_test.c    |    2 +-
 tools/testing/selftests/bpf/progs/fexit_test.c     |    4 +-
 .../selftests/bpf/progs/for_each_array_map_elem.c  |   61 +
 .../selftests/bpf/progs/for_each_hash_map_elem.c   |   95 +
 .../testing/selftests/bpf/progs/kfunc_call_test.c  |   47 +
 .../selftests/bpf/progs/kfunc_call_test_subprog.c  |   42 +
 tools/testing/selftests/bpf/progs/linked_funcs1.c  |   73 +
 tools/testing/selftests/bpf/progs/linked_funcs2.c  |   73 +
 tools/testing/selftests/bpf/progs/linked_maps1.c   |   82 +
 tools/testing/selftests/bpf/progs/linked_maps2.c   |   76 +
 tools/testing/selftests/bpf/progs/linked_vars1.c   |   54 +
 tools/testing/selftests/bpf/progs/linked_vars2.c   |   55 +
 tools/testing/selftests/bpf/progs/loop6.c          |   99 +
 tools/testing/selftests/bpf/progs/map_ptr_kern.c   |    4 +-
 tools/testing/selftests/bpf/progs/skb_pkt_end.c    |    1 -
 .../selftests/bpf/progs/sockmap_tcp_msg_prog.c     |   12 -
 tools/testing/selftests/bpf/progs/sockopt_sk.c     |   11 +-
 .../selftests/bpf/progs/task_local_storage.c       |   64 +
 .../bpf/progs/task_local_storage_exit_creds.c      |   32 +
 .../selftests/bpf/progs/task_ls_recursion.c        |   70 +
 .../selftests/bpf/progs/test_core_reloc_size.c     |    3 +
 .../selftests/bpf/progs/test_global_func10.c       |    2 +-
 tools/testing/selftests/bpf/progs/test_mmap.c      |    2 -
 tools/testing/selftests/bpf/progs/test_ringbuf.c   |    1 -
 .../selftests/bpf/progs/test_ringbuf_multi.c       |   12 +-
 tools/testing/selftests/bpf/progs/test_sk_lookup.c |   62 +-
 tools/testing/selftests/bpf/progs/test_snprintf.c  |   73 +
 .../selftests/bpf/progs/test_snprintf_single.c     |   20 +
 .../selftests/bpf/progs/test_sockmap_listen.c      |   26 +-
 .../bpf/progs/test_sockmap_skb_verdict_attach.c    |   18 +
 .../selftests/bpf/progs/test_static_linked1.c      |   30 +
 .../selftests/bpf/progs/test_static_linked2.c      |   31 +
 tools/testing/selftests/bpf/progs/test_tc_tunnel.c |  113 +-
 .../testing/selftests/bpf/progs/test_tunnel_kern.c |    2 +-
 tools/testing/selftests/bpf/test_bpftool_build.sh  |   21 -
 tools/testing/selftests/bpf/test_btf.h             |    3 +
 tools/testing/selftests/bpf/test_doc_build.sh      |   13 +
 tools/testing/selftests/bpf/test_progs.h           |   63 +-
 tools/testing/selftests/bpf/test_sockmap.c         |    2 +-
 tools/testing/selftests/bpf/test_tc_tunnel.sh      |   15 +-
 tools/testing/selftests/bpf/test_verifier.c        |    4 +-
 tools/testing/selftests/bpf/test_xsk.sh            |  138 +-
 .../testing/selftests/bpf/verifier/array_access.c  |    2 +-
 .../testing/selftests/bpf/verifier/bpf_get_stack.c |   43 +
 tools/testing/selftests/bpf/verifier/calls.c       |   12 +-
 .../testing/selftests/bpf/verifier/ctx_sk_lookup.c |    1 +
 tools/testing/selftests/bpf/verifier/dead_code.c   |   10 +-
 tools/testing/selftests/bpf/vmtest.sh              |   59 +-
 tools/testing/selftests/bpf/xdpxceiver.c           |  862 +++--
 tools/testing/selftests/bpf/xdpxceiver.h           |   98 +-
 tools/testing/selftests/bpf/xsk_prereqs.sh         |   30 +-
 .../net/mlxsw/devlink_trap_l3_exceptions.sh        |   31 +
 .../drivers/net/mlxsw/mirror_gre_scale.sh          |    3 +-
 .../selftests/drivers/net/mlxsw/port_scale.sh      |    6 +-
 .../selftests/drivers/net/mlxsw/rtnetlink.sh       |   82 +
 .../selftests/drivers/net/mlxsw/sch_red_core.sh    |    4 +-
 .../selftests/drivers/net/mlxsw/sch_red_ets.sh     |    7 +
 .../drivers/net/mlxsw/spectrum-2/q_in_vni_veto.sh  |   77 -
 .../drivers/net/mlxsw/spectrum-2/resource_scale.sh |    4 +-
 .../drivers/net/mlxsw/spectrum/resource_scale.sh   |    4 +-
 .../selftests/drivers/net/mlxsw/tc_flower_scale.sh |    6 +-
 .../selftests/drivers/net/mlxsw/tc_restrictions.sh |   21 +-
 .../selftests/drivers/net/mlxsw/tc_sample.sh       |  657 ++++
 .../drivers/net/netdevsim/ethtool-common.sh        |    5 +-
 .../selftests/drivers/net/netdevsim/ethtool-fec.sh |  110 +
 .../selftests/drivers/net/netdevsim/nexthop.sh     |  620 ++++
 .../selftests/drivers/net/netdevsim/psample.sh     |  181 +
 tools/testing/selftests/lib.mk                     |    4 +
 tools/testing/selftests/net/Makefile               |    4 +
 tools/testing/selftests/net/fib_nexthops.sh        |  564 ++-
 tools/testing/selftests/net/fib_tests.sh           |  152 +-
 .../selftests/net/forwarding/dual_vxlan_bridge.sh  |  366 ++
 .../selftests/net/forwarding/fib_offload_lib.sh    |    2 +-
 .../net/forwarding/gre_multipath_nh_res.sh         |  361 ++
 tools/testing/selftests/net/forwarding/lib.sh      |   14 +
 .../net/forwarding/mirror_gre_vlan_bridge_1q.sh    |    2 +-
 .../testing/selftests/net/forwarding/mirror_lib.sh |   19 +-
 .../net/forwarding/router_mpath_nh_res.sh          |  400 ++
 .../testing/selftests/net/forwarding/tc_police.sh  |   56 +
 tools/testing/selftests/net/mptcp/Makefile         |    2 +-
 tools/testing/selftests/net/mptcp/diag.sh          |   55 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |   77 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |   51 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  248 +-
 tools/testing/selftests/net/mptcp/mptcp_sockopt.sh |  276 ++
 tools/testing/selftests/net/mptcp/pm_netlink.sh    |    6 +-
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c      |   34 +-
 tools/testing/selftests/net/mptcp/simult_flows.sh  |   13 +-
 tools/testing/selftests/net/settings               |    1 +
 tools/testing/selftests/net/so_txtime.c            |  247 +-
 tools/testing/selftests/net/so_txtime.sh           |   97 +-
 tools/testing/selftests/net/udpgro_fwd.sh          |  251 ++
 tools/testing/selftests/net/veth.sh                |  177 +
 tools/testing/selftests/netfilter/nft_flowtable.sh |   82 +
 .../tc-testing/tc-tests/actions/police.json        |   48 +
 .../tc-testing/tc-tests/actions/simple.json        |   83 +
 1897 files changed, 121455 insertions(+), 35439 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/actions,owl-emac.yaml
 create mode 100644 Documentation/devicetree/bindings/net/brcm,bcm6368-mdio-mux.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
 create mode 100644 Documentation/devicetree/bindings/net/broadcom-bluetooth.yaml
 create mode 100644 Documentation/devicetree/bindings/net/idt,3243x-emac.yaml
 create mode 100644 Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/rockchip-dwmac.txt
 create mode 100644 Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/wireless/ieee80211.txt
 create mode 100644 Documentation/devicetree/bindings/net/wireless/ieee80211.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/wireless/mediatek,mt76.txt
 create mode 100644 Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
 create mode 100644 Documentation/networking/nexthop-group-resilient.rst
 create mode 100644 Documentation/userspace-api/ebpf/index.rst
 create mode 100644 Documentation/userspace-api/ebpf/syscall.rst
 delete mode 100644 arch/mips/sgi-ip27/TODO
 create mode 100644 drivers/bluetooth/virtio_bt.c
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.h
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-timestamp.c
 create mode 100644 drivers/net/can/usb/etas_es58x/Makefile
 create mode 100644 drivers/net/can/usb/etas_es58x/es581_4.c
 create mode 100644 drivers/net/can/usb/etas_es58x/es581_4.h
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_core.c
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_core.h
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_fd.c
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_fd.h
 create mode 100644 drivers/net/dsa/microchip/ksz8.h
 create mode 100644 drivers/net/dsa/microchip/ksz8863_smi.c
 create mode 100644 drivers/net/ethernet/actions/Kconfig
 create mode 100644 drivers/net/ethernet/actions/Makefile
 create mode 100644 drivers/net/ethernet/actions/owl-emac.c
 create mode 100644 drivers/net/ethernet/actions/owl-emac.h
 rename drivers/{staging/fsl-dpaa2/ethsw/ethsw-ethtool.c => net/ethernet/freescale/dpaa2/dpaa2-switch-ethtool.c} (99%)
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.h
 rename drivers/{staging/fsl-dpaa2/ethsw => net/ethernet/freescale/dpaa2}/dpsw-cmd.h (64%)
 rename drivers/{staging/fsl-dpaa2/ethsw => net/ethernet/freescale/dpaa2}/dpsw.c (62%)
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpsw.h
 create mode 100644 drivers/net/ethernet/freescale/enetc/enetc_ierb.c
 create mode 100644 drivers/net/ethernet/freescale/enetc/enetc_ierb.h
 create mode 100644 drivers/net/ethernet/intel/iavf/iavf_adv_rss.c
 create mode 100644 drivers/net/ethernet/intel/iavf/iavf_adv_rss.h
 create mode 100644 drivers/net/ethernet/intel/iavf/iavf_fdir.c
 create mode 100644 drivers/net/ethernet/intel/iavf/iavf_fdir.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_virtchnl_allowlist.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_virtchnl_allowlist.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.h
 create mode 100644 drivers/net/ethernet/intel/igc/igc_xdp.c
 create mode 100644 drivers/net/ethernet/intel/igc/igc_xdp.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_ppe.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_ppe.h
 create mode 100644 drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_ppe_offload.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_ppe_regs.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/fs_tt_redirect.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/sample.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/vporttbl.c
 create mode 100644 drivers/net/ethernet/microsoft/Kconfig
 create mode 100644 drivers/net/ethernet/microsoft/Makefile
 create mode 100644 drivers/net/ethernet/microsoft/mana/Makefile
 create mode 100644 drivers/net/ethernet/microsoft/mana/gdma.h
 create mode 100644 drivers/net/ethernet/microsoft/mana/gdma_main.c
 create mode 100644 drivers/net/ethernet/microsoft/mana/hw_channel.c
 create mode 100644 drivers/net/ethernet/microsoft/mana/hw_channel.h
 create mode 100644 drivers/net/ethernet/microsoft/mana/mana.h
 create mode 100644 drivers/net/ethernet/microsoft/mana/mana_en.c
 create mode 100644 drivers/net/ethernet/microsoft/mana/mana_ethtool.c
 create mode 100644 drivers/net/ethernet/microsoft/mana/shm_channel.c
 create mode 100644 drivers/net/ethernet/microsoft/mana/shm_channel.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_phc.c
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.h
 rename drivers/net/ipa/{ipa_data-sdm845.c => ipa_data-v3.5.1.c} (52%)
 create mode 100644 drivers/net/ipa/ipa_data-v4.11.c
 rename drivers/net/ipa/{ipa_data-sc7180.c => ipa_data-v4.2.c} (60%)
 create mode 100644 drivers/net/ipa/ipa_data-v4.5.c
 create mode 100644 drivers/net/ipa/ipa_data-v4.9.c
 create mode 100644 drivers/net/ipa/ipa_resource.c
 create mode 100644 drivers/net/ipa/ipa_resource.h
 create mode 100644 drivers/net/mdio/mdio-mux-bcm6368.c
 create mode 100644 drivers/net/netdevsim/psample.c
 create mode 100644 drivers/net/phy/marvell-88x2222.c
 create mode 100644 drivers/net/phy/nxp-c45-tja11xx.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/mt7921_trace.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/trace.c
 create mode 100644 drivers/net/wwan/Kconfig
 create mode 100644 drivers/net/wwan/Makefile
 create mode 100644 drivers/net/wwan/mhi_wwan_ctrl.c
 create mode 100644 drivers/net/wwan/wwan_core.c
 delete mode 100644 drivers/scsi/aacraid/TODO
 delete mode 100644 drivers/staging/fsl-dpaa2/Kconfig
 delete mode 100644 drivers/staging/fsl-dpaa2/Makefile
 delete mode 100644 drivers/staging/fsl-dpaa2/ethsw/Makefile
 delete mode 100644 drivers/staging/fsl-dpaa2/ethsw/README
 delete mode 100644 drivers/staging/fsl-dpaa2/ethsw/TODO
 delete mode 100644 drivers/staging/fsl-dpaa2/ethsw/dpsw.h
 delete mode 100644 drivers/staging/fsl-dpaa2/ethsw/ethsw.c
 delete mode 100644 drivers/staging/fsl-dpaa2/ethsw/ethsw.h
 delete mode 100644 fs/befs/TODO
 delete mode 100644 fs/jffs2/TODO
 delete mode 100644 include/linux/atm_suni.h
 create mode 100644 include/linux/ptp_pch.h
 create mode 100644 include/linux/wwan.h
 delete mode 100644 include/net/netns/dccp.h
 create mode 100644 include/net/selftests.h
 create mode 100644 include/trace/events/mptcp.h
 create mode 100644 include/uapi/linux/virtio_bt.h
 delete mode 100644 net/ax25/TODO
 create mode 100644 net/bluetooth/aosp.c
 create mode 100644 net/bluetooth/aosp.h
 delete mode 100644 net/bridge/netfilter/nf_log_bridge.c
 create mode 100644 net/core/selftests.c
 delete mode 100644 net/decnet/TODO
 create mode 100644 net/ethtool/eeprom.c
 create mode 100644 net/ethtool/fec.c
 create mode 100644 net/ethtool/stats.c
 delete mode 100644 net/ipv4/netfilter/nf_log_arp.c
 delete mode 100644 net/ipv4/netfilter/nf_log_ipv4.c
 delete mode 100644 net/ipv6/netfilter/nf_log_ipv6.c
 create mode 100644 net/mptcp/sockopt.c
 delete mode 100644 net/netfilter/nf_log_common.c
 delete mode 100644 net/netfilter/nf_log_netdev.c
 create mode 100644 net/netfilter/nf_log_syslog.c
 rename scripts/{bpf_helpers_doc.py => bpf_doc.py} (82%)
 delete mode 100644 tools/bpf/Makefile.helpers
 delete mode 100644 tools/lib/bpf/libbpf_util.h
 create mode 100644 tools/lib/bpf/linker.c
 create mode 100644 tools/lib/bpf/strset.c
 create mode 100644 tools/lib/bpf/strset.h
 create mode 100644 tools/testing/selftests/bpf/Makefile.docs
 create mode 100644 tools/testing/selftests/bpf/map_tests/lpm_trie_map_batch_ops.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/for_each.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/kfunc_call.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/linked_funcs.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/linked_maps.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/linked_vars.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/snprintf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/static_linked.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/task_local_storage.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_kind.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_value_type.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_kind.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_sz.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_type.c
 delete mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_struct_type.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___wrong_field_defs.c
 create mode 100644 tools/testing/selftests/bpf/progs/for_each_array_map_elem.c
 create mode 100644 tools/testing/selftests/bpf/progs/for_each_hash_map_elem.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_test_subprog.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_funcs1.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_funcs2.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_maps1.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_maps2.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_vars1.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_vars2.c
 create mode 100644 tools/testing/selftests/bpf/progs/loop6.c
 create mode 100644 tools/testing/selftests/bpf/progs/task_local_storage.c
 create mode 100644 tools/testing/selftests/bpf/progs/task_local_storage_exit_creds.c
 create mode 100644 tools/testing/selftests/bpf/progs/task_ls_recursion.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_snprintf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_snprintf_single.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_skb_verdict_attach.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_static_linked1.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_static_linked2.c
 create mode 100755 tools/testing/selftests/bpf/test_doc_build.sh
 delete mode 100755 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/q_in_vni_veto.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/tc_sample.sh
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/ethtool-fec.sh
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/psample.sh
 create mode 100755 tools/testing/selftests/net/forwarding/dual_vxlan_bridge.sh
 create mode 100755 tools/testing/selftests/net/forwarding/gre_multipath_nh_res.sh
 create mode 100755 tools/testing/selftests/net/forwarding/router_mpath_nh_res.sh
 create mode 100755 tools/testing/selftests/net/mptcp/mptcp_sockopt.sh
 create mode 100644 tools/testing/selftests/net/settings
 create mode 100755 tools/testing/selftests/net/udpgro_fwd.sh
 create mode 100755 tools/testing/selftests/net/veth.sh
