Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC76C488EC3
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 03:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238253AbiAJCwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 21:52:09 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57466 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbiAJCwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 21:52:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E02FB811DA;
        Mon, 10 Jan 2022 02:52:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9FFC36AEB;
        Mon, 10 Jan 2022 02:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641783124;
        bh=gfQSAmj3Tte6HLCL9RYiPS4R/oZOHRYYDZZF4f0zwEE=;
        h=From:To:Cc:Subject:Date:From;
        b=NtXdGmjiRUTy3zjgrq35wOTR+1/n7bD9ZQq05kwvoz1Ass8tZyc8wzCQap2ZQ4iYd
         oLP+JOrduPFCbzFblAQnOn7CHF4Hx73yBoTOBFZp/8bAM6Q+ZvkXlM7Nukux7gnkeI
         SYkn0TtFGuNvcSShk40Zsq5ASBuPXLsMQnHXDMuGfj1rWwitiNyUYgKrFhZlGV4mmk
         qY24jVkJfNAMqCZCEPboRfFAU2H9IdDX6OVEPCgplr9ih+wNhiZ7XVcTEKD/rYCmyP
         XcMsKMsKuMeeIZneUpfHA0DwhPwMc/2OAdIro7oel++6eIqpPKAYu/vVwQCLrFzLdq
         YM5aG1oDEkhSw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.17
Date:   Sun,  9 Jan 2022 18:52:03 -0800
Message-Id: <20220110025203.2545903-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

At the time of writing we have one known conflict (/build failure)
with tip, Stephen's resolution looks good:

https://lore.kernel.org/all/20220110121205.1bf54032@canb.auug.org.au/

We have done some of our own header de-tangling before Ingo posted
his RFC - which required sprinkling missing headers in other subsystems.
There were no conflicts reported but it's something to keep an eye on.


The following changes since commit 75acfdb6fd922598a408a0d864486aeb167c1a97:

  Merge tag 'net-5.16-final' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-01-05 14:08:56 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/5.17-net-next

for you to fetch changes up to 8aaaf2f3af2ae212428f4db1af34214225f5cec3:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-01-09 17:00:17 -0800)

----------------------------------------------------------------
Networking changes for 5.17.

Core
----

 - Defer freeing TCP skbs to the BH handler, whenever possible,
   or at least perform the freeing outside of the socket lock section
   to decrease cross-CPU allocator work and improve latency.

 - Add netdevice refcount tracking to locate sources of netdevice
   and net namespace refcount leaks.

 - Make Tx watchdog less intrusive - avoid pausing Tx and restarting
   all queues from a single CPU removing latency spikes.

 - Various small optimizations throughout the stack from Eric Dumazet.

 - Make netdev->dev_addr[] constant, force modifications to go via
   appropriate helpers to allow us to keep addresses in ordered data
   structures.

 - Replace unix_table_lock with per-hash locks, improving performance
   of bind() calls.

 - Extend skb drop tracepoint with a drop reason.

 - Allow SO_MARK and SO_PRIORITY setsockopt under CAP_NET_RAW.

BPF
---

 - New helpers:
   - bpf_find_vma(), find and inspect VMAs for profiling use cases
   - bpf_loop(), runtime-bounded loop helper trading some execution
     time for much faster (if at all converging) verification
   - bpf_strncmp(), improve performance, avoid compiler flakiness
   - bpf_get_func_arg(), bpf_get_func_ret(), bpf_get_func_arg_cnt()
     for tracing programs, all inlined by the verifier

 - Support BPF relocations (CO-RE) in the kernel loader.

 - Further the support for BTF_TYPE_TAG annotations.

 - Allow access to local storage in sleepable helpers.

 - Convert verifier argument types to a composable form with different
   attributes which can be shared across types (ro, maybe-null).

 - Prepare libbpf for upcoming v1.0 release by cleaning up APIs,
   creating new, extensible ones where missing and deprecating those
   to be removed.

Protocols
---------

 - WiFi (mac80211/cfg80211):
   - notify user space about long "come back in N" AP responses,
     allow it to react to such temporary rejections
   - allow non-standard VHT MCS 10/11 rates
   - use coarse time in airtime fairness code to save CPU cycles

 - Bluetooth:
   - rework of HCI command execution serialization to use a common
     queue and work struct, and improve handling errors reported
     in the middle of a batch of commands
   - rework HCI event handling to use skb_pull_data, avoiding packet
     parsing pitfalls
   - support AOSP Bluetooth Quality Report

 - SMC:
   - support net namespaces, following the RDMA model
   - improve connection establishment latency by pre-clearing buffers
   - introduce TCP ULP for automatic redirection to SMC

 - Multi-Path TCP:
   - support ioctls: SIOCINQ, OUTQ, and OUTQNSD
   - support socket options: IP_TOS, IP_FREEBIND, IP_TRANSPARENT,
     IPV6_FREEBIND, and IPV6_TRANSPARENT, TCP_CORK and TCP_NODELAY
   - support cmsgs: TCP_INQ
   - improvements in the data scheduler (assigning data to subflows)
   - support fastclose option (quick shutdown of the full MPTCP
     connection, similar to TCP RST in regular TCP)

 - MCTP (Management Component Transport) over serial, as defined by
   DMTF spec DSP0253 - "MCTP Serial Transport Binding".

Driver API
----------

 - Support timestamping on bond interfaces in active/passive mode.

 - Introduce generic phylink link mode validation for drivers which
   don't have any quirks and where MAC capability bits fully express
   what's supported. Allow PCS layer to participate in the validation.
   Convert a number of drivers.

 - Add support to set/get size of buffers on the Rx rings and size of
   the tx copybreak buffer via ethtool.

 - Support offloading TC actions as first-class citizens rather than
   only as attributes of filters, improve sharing and device resource
   utilization.

 - WiFi (mac80211/cfg80211):
   - support forwarding offload (ndo_fill_forward_path)
   - support for background radar detection hardware
   - SA Query Procedures offload on the AP side

New hardware / drivers
----------------------

 - tsnep - FPGA based TSN endpoint Ethernet MAC used in PLCs with
   real-time requirements for isochronous communication with protocols
   like OPC UA Pub/Sub.

 - Qualcomm BAM-DMUX WWAN - driver for data channels of modems
   integrated into many older Qualcomm SoCs, e.g. MSM8916 or
   MSM8974 (qcom_bam_dmux).

 - Microchip LAN966x multi-port Gigabit AVB/TSN Ethernet Switch
   driver with support for bridging, VLANs and multicast forwarding
   (lan966x).

 - iwlmei driver for co-operating between Intel's WiFi driver and
   Intel's Active Management Technology (AMT) devices.

 - mse102x - Vertexcom MSE102x Homeplug GreenPHY chips

 - Bluetooth:
   - MediaTek MT7921 SDIO devices
   - Foxconn MT7922A
   - Realtek RTL8852AE

Drivers
-------

 - Significantly improve performance in the datapaths of:
   lan78xx, ax88179_178a, lantiq_xrx200, bnxt.

 - Intel Ethernet NICs:
   - igb: support PTP/time PEROUT and EXTTS SDP functions on
     82580/i354/i350 adapters
   - ixgbevf: new PF -> VF mailbox API which avoids the risk of
     mailbox corruption with ESXi
   - iavf: support configuration of VLAN features of finer granularity,
     stacked tags and filtering
   - ice: PTP support for new E822 devices with sub-ns precision
   - ice: support firmware activation without reboot

 - Mellanox Ethernet NICs (mlx5):
   - expose control over IRQ coalescing mode (CQE vs EQE) via ethtool
   - support TC forwarding when tunnel encap and decap happen between
     two ports of the same NIC
   - dynamically size and allow disabling various features to save
     resources for running in embedded / SmartNIC scenarios

 - Broadcom Ethernet NICs (bnxt):
   - use page frag allocator to improve Rx performance
   - expose control over IRQ coalescing mode (CQE vs EQE) via ethtool

 - Other Ethernet NICs:
   - amd-xgbe: add Ryzen 6000 (Yellow Carp) Ethernet support

 - Microsoft cloud/virtual NIC (mana):
   - add XDP support (PASS, DROP, TX)

 - Mellanox Ethernet switches (mlxsw):
   - initial support for Spectrum-4 ASICs
   - VxLAN with IPv6 underlay

 - Marvell Ethernet switches (prestera):
   - support flower flow templates
   - add basic IP forwarding support

 - NXP embedded Ethernet switches (ocelot & felix):
   - support Per-Stream Filtering and Policing (PSFP)
   - enable cut-through forwarding between ports by default
   - support FDMA to improve packet Rx/Tx to CPU

 - Other embedded switches:
   - hellcreek: improve trapping management (STP and PTP) packets
   - qca8k: support link aggregation and port mirroring

 - Qualcomm 802.11ax WiFi (ath11k):
   - qca6390, wcn6855: enable 802.11 power save mode in station mode
   - BSS color change support
   - WCN6855 hw2.1 support
   - 11d scan offload support
   - scan MAC address randomization support
   - full monitor mode, only supported on QCN9074
   - qca6390/wcn6855: report signal and tx bitrate
   - qca6390: rfkill support
   - qca6390/wcn6855: regdb.bin support

 - Intel WiFi (iwlwifi):
   - support SAR GEO Offset Mapping (SGOM) and Time-Aware-SAR (TAS)
     in cooperation with the BIOS
   - support for Optimized Connectivity Experience (OCE) scan
   - support firmware API version 68
   - lots of preparatory work for the upcoming Bz device family

 - MediaTek WiFi (mt76):
   - Specific Absorption Rate (SAR) support
   - mt7921: 160 MHz channel support

 - RealTek WiFi (rtw88):
   - Specific Absorption Rate (SAR) support
   - scan offload

 - Other WiFi NICs
   - ath10k: support fetching (pre-)calibration data from nvmem
   - brcmfmac: configure keep-alive packet on suspend
   - wcn36xx: beacon filter support

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Aaron Ma (2):
      Bluetooth: btusb: Add support for Foxconn MT7922A
      Bluetooth: btusb: Add support for Foxconn QCA 0xe0d0

Aditya Garg (3):
      Bluetooth: add quirk disabling LE Read Transmit Power
      Bluetooth: btbcm: disable read tx power for some Macs with the T2 Security chip
      Bluetooth: btbcm: disable read tx power for MacBook Air 8,1 and 8,2

Ajay Singh (1):
      wilc1000: remove '-Wunused-but-set-variable' warning in chip_wakeup()

Alan Maguire (2):
      selftests/bpf: Add exception handling selftests for tp_bpf program
      libbpf: Silence uninitialized warning/error in btf_dump_dump_type_data

Aleksander Jan Bajkowski (11):
      net: lantiq_etop: add missing comment for wmb()
      net: lantiq_etop: add blank line after declaration
      net: lantiq_etop: replace strlcpy with strscpy
      net: lantiq_etop: avoid precedence issues
      net: lantiq_etop: remove multiple assignments
      net: lantiq_etop: make alignment match open parenthesis
      net: lantiq_etop: remove unnecessary space in cast
      net: lantiq_xrx200: add ingress SG DMA support
      MIPS: lantiq: dma: increase descritor count
      net: lantiq_xrx200: increase napi poll weigth
      net: lantiq_xrx200: convert to build_skb

Alex Elder (11):
      net: ipa: kill ipa_modem_init()
      net: ipa: zero unused portions of filter table memory
      net: ipa: rework how HOL_BLOCK handling is specified
      net: ipa: explicitly disable HOLB drop during setup
      net: ipa: skip SKB copy if no netdev
      net: ipa: GSI only needs one completion
      net: ipa: rearrange GSI structure fields
      net: ipa: introduce channel flow control
      net: ipa: support enhanced channel flow control
      ARM: dts: qcom: sdx55: fix IPA interconnect definitions
      net: ipa: fix IPA v4.5 interconnect data

Alexander Lobakin (13):
      stmmac: fix build due to brainos in trans_start changes
      samples: bpf: Fix conflicting types in fds_example
      samples: bpf: Fix xdp_sample_user.o linking with Clang
      samples: bpf: Fix 'unknown warning group' build warning on Clang
      e1000: switch to napi_consume_skb()
      e1000: switch to napi_build_skb()
      i40e: switch to napi_build_skb()
      iavf: switch to napi_build_skb()
      ice: switch to napi_build_skb()
      igb: switch to napi_build_skb()
      igc: switch to napi_build_skb()
      ixgbe: switch to napi_build_skb()
      ixgbevf: switch to napi_build_skb()

Alexander Usyskin (1):
      mei: bus: add client dma interface

Alexei Starovoitov (41):
      Merge branch 'libbpf ELF sanity checking improvements'
      Merge branch 'libbpf: add unified bpf_prog_load() low-level API'
      Merge branch 'Fix leaks in libbpf and selftests'
      Merge branch 'introduce bpf_find_vma'
      Merge branch 'Get ingress_ifindex in BPF_SK_LOOKUP prog type'
      Merge branch 'selftests/bpf: fix test_progs' log_level logic'
      Merge branch 'Future-proof more tricky libbpf APIs'
      Merge branch 'Support BTF_KIND_TYPE_TAG for btf_type_tag attributes'
      Merge branch 'introduce btf_tracing_ids'
      Merge branch 'Add bpf_loop helper'
      libbpf: Replace btf__type_by_id() with btf_type_by_id().
      bpf: Rename btf_member accessors.
      bpf: Prepare relo_core.c for kernel duty.
      bpf: Define enum bpf_core_relo_kind as uapi.
      bpf: Pass a set of bpf_core_relo-s to prog_load command.
      bpf: Adjust BTF log size limit.
      bpf: Add bpf_core_add_cands() and wire it into bpf_core_apply_relo_insn().
      libbpf: Use CO-RE in the kernel in light skeleton.
      libbpf: Support init of inner maps in light skeleton.
      libbpf: Clean gen_loader's attach kind.
      selftests/bpf: Add lskel version of kfunc test.
      selftests/bpf: Improve inner_map test coverage.
      selftests/bpf: Convert map_ptr_kern test to use light skeleton.
      selftests/bpf: Additional test for CO-RE in the kernel.
      selftests/bpf: Revert CO-RE removal in test_ksyms_weak.
      selftests/bpf: Add CO-RE relocations to verifier scale test.
      Merge branch 'Deprecate bpf_prog_load_xattr() API'
      libbpf: Reduce bpf_core_apply_relo_insn() stack usage.
      bpftool: Add debug mode for gen_loader.
      bpf: Silence purge_cand_cache build warning.
      Merge branch 'Enhance and rework logging controls in libbpf'
      libbpf: Fix gen_loader assumption on number of programs.
      Merge branch 'introduce bpf_strncmp() helper'
      bpf: Silence coverity false positive warning.
      Merge branch 'bpf: Add helpers to access traced function arguments'
      Merge branch 'bpf: remove the cgroup -> bpf header dependecy'
      Merge branch 'Introduce composable bpf types'
      Merge branch 'Sleepable local storage'
      Merge branch 'lighten uapi/bpf.h rebuilds'
      Merge branch 'samples/bpf: xdpsock app enhancements'
      Merge branch 'net: bpf: handle return value of post_bind{4,6} and add selftests for it'

Alvin Šipraga (3):
      net: dsa: realtek-smi: don't log an error on EPROBE_DEFER
      net: dsa: rtl8365mb: fix garbled comment
      net: dsa: rtl8365mb: set RGMII RX delay in steps of 0.3 ns

Amit Cohen (42):
      mlxsw: spectrum: Bump minimum FW version to xx.2010.1006
      mlxsw: reg: Remove unused functions
      mlxsw: item: Add support for local_port field in a split form
      mlxsw: reg: Align existing registers to use extended local_port field
      mlxsw: reg: Increase 'port_num' field in PMTDB register
      mlxsw: reg: Adjust PPCNT register to support local port 255
      mlxsw: Use u16 for local_port field instead of u8
      mlxsw: Add support for more than 256 ports in SBSR register
      mlxsw: Use Switch Flooding Table Register Version 2
      mlxsw: Use Switch Multicast ID Register Version 2
      mlxsw: spectrum: Add hash table for IPv6 address mapping
      mlxsw: spectrum_ipip: Use common hash table for IPv6 address mapping
      mlxsw: spectrum_nve_vxlan: Make VxLAN flags check per address family
      mlxsw: Split handling of FDB tunnel entries between address families
      mlxsw: reg: Add a function to fill IPv6 unicast FDB entries
      mlxsw: spectrum_nve: Keep track of IPv6 addresses used by FDB entries
      mlxsw: Add support for VxLAN with IPv6 underlay
      selftests: mlxsw: vxlan: Remove IPv6 test case
      mlxsw: spectrum_flower: Make vlan_id limitation more specific
      selftests: lib.sh: Add PING_COUNT to allow sending configurable amount of packets
      selftests: forwarding: Add VxLAN tests with a VLAN-unaware bridge for IPv6
      selftests: forwarding: Add VxLAN tests with a VLAN-aware bridge for IPv6
      selftests: forwarding: vxlan_bridge_1q: Remove unused function
      selftests: forwarding: Add a test for VxLAN asymmetric routing with IPv6
      selftests: forwarding: Add a test for VxLAN symmetric routing with IPv6
      selftests: forwarding: Add Q-in-VNI test for IPv6
      selftests: mlxsw: vxlan: Make the test more flexible for future use
      selftests: mlxsw: Add VxLAN configuration test for IPv6
      selftests: mlxsw: vxlan_fdb_veto: Make the test more flexible for future use
      selftests: mlxsw: Add VxLAN FDB veto test for IPv6
      selftests: mlxsw: spectrum: Add a test for VxLAN flooding with IPv6
      selftests: mlxsw: spectrum-2: Add a test for VxLAN flooding with IPv6
      selftests: mlxsw: Add test for VxLAN related traps for IPv6
      selftests: mlxsw: devlink_trap_tunnel_vxlan: Fix 'decap_error' case
      mlxsw: Rename virtual router flex key element
      mlxsw: Introduce flex key elements for Spectrum-4
      mlxsw: spectrum_acl_bloom_filter: Reorder functions to make the code more aesthetic
      mlxsw: spectrum_acl_bloom_filter: Make mlxsw_sp_acl_bf_key_encode() more flexible
      mlxsw: spectrum_acl_bloom_filter: Rename Spectrum-2 specific objects for future use
      mlxsw: Add operations structure for bloom filter calculation
      mlxsw: spectrum_acl_bloom_filter: Add support for Spectrum-4 calculation
      mlxsw: spectrum: Extend to support Spectrum-4 ASIC

Andrii Nakryiko (105):
      Merge branch 'libbpf: deprecate bpf_program__get_prog_info_linear'
      libbpf: Detect corrupted ELF symbols section
      libbpf: Improve sanity checking during BTF fix up
      libbpf: Validate that .BTF and .BTF.ext sections contain data
      libbpf: Fix section counting logic
      libbpf: Improve ELF relo sanitization
      libbpf: Deprecate bpf_program__load() API
      libbpf: Fix non-C89 loop variable declaration in gen_loader.c
      libbpf: Rename DECLARE_LIBBPF_OPTS into LIBBPF_OPTS
      libbpf: Pass number of prog load attempts explicitly
      libbpf: Unify low-level BPF_PROG_LOAD APIs into bpf_prog_load()
      libbpf: Remove internal use of deprecated bpf_prog_load() variants
      libbpf: Stop using to-be-deprecated APIs
      bpftool: Stop using deprecated bpf_load_program()
      libbpf: Remove deprecation attribute from struct bpf_prog_prep_result
      selftests/bpf: Fix non-strict SEC() program sections
      selftests/bpf: Convert legacy prog load APIs to bpf_prog_load()
      selftests/bpf: Merge test_stub.c into testing_helpers.c
      selftests/bpf: Use explicit bpf_prog_test_load() calls everywhere
      selftests/bpf: Use explicit bpf_test_load_program() helper calls
      selftests/bpf: Pass sanitizer flags to linker through LDFLAGS
      libbpf: Free up resources used by inner map definition
      selftests/bpf: Fix memory leaks in btf_type_c_dump() helper
      selftests/bpf: Free per-cpu values array in bpf_iter selftest
      selftests/bpf: Free inner strings index in btf selftest
      selftests/bpf: Clean up btf and btf_dump in dump_datasec test
      selftests/bpf: Avoid duplicate btf__parse() call
      selftests/bpf: Destroy XDP link correctly
      selftests/bpf: Fix bpf_object leak in skb_ctx selftest
      libbpf: Add ability to get/set per-program load flags
      selftests/bpf: Fix bpf_prog_test_load() logic to pass extra log level
      bpftool: Normalize compile rules to specify output file last
      selftests/bpf: Minor cleanups and normalization of Makefile
      libbpf: Turn btf_dedup_opts into OPTS-based struct
      libbpf: Ensure btf_dump__new() and btf_dump_opts are future-proof
      libbpf: Make perf_buffer__new() use OPTS-based interface
      selftests/bpf: Migrate all deprecated perf_buffer uses
      selftests/bpf: Update btf_dump__new() uses to v1.0+ variant
      tools/runqslower: Update perf_buffer__new() calls
      bpftool: Update btf_dump__new() and perf_buffer__new_raw() calls
      Merge branch 'bpftool: miscellaneous fixes'
      selftests/bpf: Add uprobe triggering overhead benchmarks
      libbpf: Add runtime APIs to query libbpf version
      libbpf: Accommodate DWARF/compiler bug with duplicated structs
      libbpf: Load global data maps lazily on legacy kernels
      selftests/bpf: Mix legacy (maps) and modern (vars) BPF in one test
      libbpf: Unify low-level map creation APIs w/ new bpf_map_create()
      libbpf: Use bpf_map_create() consistently internally
      libbpf: Prevent deprecation warnings in xsk.c
      selftests/bpf: Migrate selftests to bpf_map_create()
      tools/resolve_btf_ids: Close ELF file on error
      libbpf: Fix potential misaligned memory access in btf_ext__new()
      libbpf: Don't call libc APIs with NULL pointers
      libbpf: Fix glob_syms memory leak in bpf_linker
      libbpf: Fix using invalidated memory in bpf_linker
      selftests/bpf: Fix UBSan complaint about signed __int128 overflow
      selftests/bpf: Fix possible NULL passed to memcpy() with zero size
      selftests/bpf: Prevent misaligned memory access in get_stack_raw_tp test
      selftests/bpf: Fix misaligned memory access in queue_stack_map test
      selftests/bpf: Prevent out-of-bounds stack access in test_bpffs
      selftests/bpf: Fix misaligned memory accesses in xdp_bonding test
      selftests/bpf: Fix misaligned accesses in xdp and xdp_bpf2bpf tests
      Merge branch 'Support static initialization of BPF_MAP_TYPE_PROG_ARRAY'
      Merge branch 'Apply suggestions for typeless/weak ksym series'
      libbpf: Cleanup struct bpf_core_cand.
      Merge branch 'bpf: CO-RE support in the kernel'
      libbpf: Use __u32 fields in bpf_map_create_opts
      libbpf: Add API to get/set log_level at per-program level
      bpftool: Migrate off of deprecated bpf_create_map_xattr() API
      selftests/bpf: Remove recently reintroduced legacy btf__dedup() use
      selftests/bpf: Mute xdpxceiver.c's deprecation warnings
      selftests/bpf: Remove all the uses of deprecated bpf_prog_load_xattr()
      samples/bpf: Clean up samples/bpf build failes
      samples/bpf: Get rid of deprecated libbpf API uses
      libbpf: Deprecate bpf_prog_load_xattr() API
      perf: Mute libbpf API deprecations temporarily
      Merge branch 'samples: bpf: fix build issues with Clang/LLVM'
      libbpf: Fix bpf_prog_load() log_buf logic for log_level 0
      libbpf: Add OPTS-based bpf_btf_load() API
      libbpf: Allow passing preallocated log_buf when loading BTF into kernel
      libbpf: Allow passing user log setting through bpf_object_open_opts
      libbpf: Improve logging around BPF program loading
      libbpf: Preserve kernel error code and remove kprobe prog type guessing
      libbpf: Add per-program log buffer setter and getter
      libbpf: Deprecate bpf_object__load_xattr()
      selftests/bpf: Replace all uses of bpf_load_btf() with bpf_btf_load()
      selftests/bpf: Add test for libbpf's custom log_buf behavior
      selftests/bpf: Remove the only use of deprecated bpf_object__load_xattr()
      bpftool: Switch bpf_object__load_xattr() to bpf_object__load()
      selftests/bpf: Remove last bpf_create_map_xattr from test_verifier
      libbpf: Don't validate TYPE_ID relo's original imm value
      libbpf: Fix potential uninit memory read
      libbpf: Add sane strncpy alternative and use it internally
      libbpf: Auto-bump RLIMIT_MEMLOCK if kernel needs it for BPF
      selftests/bpf: Remove explicit setrlimit(RLIMIT_MEMLOCK) in main selftests
      Merge branch 'Stop using bpf_object__find_program_by_title API'
      libbpf: Avoid reading past ELF data section end when copying license
      Merge branch 'tools/bpf: Enable cross-building with clang'
      libbpf: Rework feature-probing APIs
      selftests/bpf: Add libbpf feature-probing API selftests
      bpftool: Reimplement large insn size limit feature probing
      libbpf: Normalize PT_REGS_xxx() macro definitions
      libbpf: Use 100-character limit to make bpf_tracing.h easier to read
      libbpf: Improve LINUX_VERSION_CODE detection
      selftests/bpf: Don't rely on preserving volatile in PT_REGS macros in loop3

Andy Gospodarek (1):
      bnxt_en: enable interrupt sampling on 5750X for DIM

Andy Shevchenko (7):
      net: dsa: vsc73xxx: Get rid of duplicate of_node assignment
      can: hi311x: hi3110_can_probe(): use devm_clk_get_optional() to get the input clock
      can: hi311x: hi3110_can_probe(): try to get crystal clock rate from property
      can: hi311x: hi3110_can_probe(): make use of device property API
      can: hi311x: hi3110_can_probe(): convert to use dev_err_probe()
      wwan: Replace kernel.h with the necessary inclusions
      can: mcp251x: mcp251x_gpio_setup(): Get rid of duplicate of_node assignment

Anilkumar Kolli (8):
      ath11k: Add missing qmi_txn_cancel()
      ath11k: Fix mon status ring rx tlv processing
      ath11k: Use host CE parameters for CE interrupts configuration
      ath11k: Add htt cmd to enable full monitor mode
      ath11k: add software monitor ring descriptor for full monitor
      ath11k: Process full monitor mode rx support
      dt: bindings: add new DT entry for ath11k PCI device support
      ath11k: Use reserved host DDR addresses from DT for PCI devices

Ansuel Smith (15):
      regmap: allow to define reg_update_bits for no bus configuration
      net: dsa: qca8k: remove redundant check in parse_port_config
      net: dsa: qca8k: convert to GENMASK/FIELD_PREP/FIELD_GET
      net: dsa: qca8k: remove extra mutex_init in qca8k_setup
      net: dsa: qca8k: move regmap init in probe and set it mandatory
      net: dsa: qca8k: initial conversion to regmap helper
      net: dsa: qca8k: add additional MIB counter and make it dynamic
      net: dsa: qca8k: add support for port fast aging
      net: dsa: qca8k: add set_ageing_time support
      net: dsa: qca8k: add support for mdb_add/del
      net: dsa: qca8k: add support for mirror mode
      net: dsa: qca8k: add LAG support
      net: dsa: qca8k: fix warning in LAG feature
      dt-bindings: net: dsa: split generic port definition from dsa.yaml
      dt-bindings: net: dsa: qca8k: improve port definition documentation

Antoine Tenart (3):
      sections: global data can be in .bss
      net-sysfs: update the queue counts in the unregistration path
      net-sysfs: warn if new queue objects are being created during device unregistration

Antony Antony (4):
      xfrm: interface with if_id 0 should return error
      xfrm: state and policy should fail if XFRMA_IF_ID 0
      xfrm: update SA curlft.use_time
      xfrm: rate limit SA mapping change message to user space

Archie Pusaka (5):
      Bluetooth: Fix removing adv when processing cmd complete
      Bluetooth: Ignore HCI_ERROR_CANCELLED_BY_HOST on adv set terminated event
      Bluetooth: Attempt to clear HCI_LE_ADV on adv set terminated error event
      Bluetooth: Send device found event on name resolve failure
      Bluetooth: Limit duration of Remote Name Resolve

Arnd Bergmann (4):
      mlx5: fix psample_sample_packet link error
      mlx5: fix mlx5i_grp_sw_update_stats() stack usage
      net: wwan: iosm: select CONFIG_RELAY
      iwlwifi: work around reverse dependency on MEI

Arthur Kiyanovski (10):
      net: ena: Change return value of ena_calc_io_queue_size() to void
      net: ena: Add capabilities field with support for ENI stats capability
      net: ena: Change ENI stats support check to use capabilities field
      net: ena: Update LLQ header length in ena documentation
      net: ena: Remove redundant return code check
      net: ena: Move reset completion print to the reset function
      net: ena: Remove ena_calc_queue_size_ctx struct
      net: ena: Add debug prints for invalid req_id resets
      net: ena: Change the name of bad_csum variable
      net: ena: Extract recurring driver reset code into a function

Avihai Horon (1):
      net/mlx5: Dynamically resize flow counters query buffer

Avraham Stern (4):
      iwlwifi: mvm: add support for OCE scan
      iwlwifi: mvm: perform 6GHz passive scan after suspend
      iwlwifi: mvm: set protected flag only for NDP ranging
      iwlwifi: mvm: fix AUX ROC removal

Aya Levin (5):
      net/mlx5: Avoid printing health buffer when firmware is unavailable
      net/mlx5e: Fix feature check per profile
      net/mlx5e: Fix page DMA map/unmap attributes
      Revert "net/mlx5e: Block offload of outer header csum for UDP tunnels"
      Revert "net/mlx5e: Block offload of outer header csum for GRE tunnel"

Ayala Barazani (2):
      iwlwifi: support SAR GEO Offset Mapping override via BIOS
      iwlwifi: mvm: Add list of OEMs allowed to use TAS

Ayala Beker (3):
      cfg80211: Use the HE operation IE to determine a 6GHz BSS channel
      iwlwifi: mvm: correctly set channel flags
      iwlwifi: mvm: correctly set schedule scan profiles

Baochen Qiang (5):
      ath11k: Fix crash caused by uninitialized TX ring
      ath11k: Set IRQ affinity to CPU0 in case of one MSI vector
      ath11k: add support for WCN6855 hw2.1
      ath11k: Avoid false DEADLOCK warning reported by lockdep
      ath11k: Fix unexpected return buffer manager error for QCA6390

Baowen Zheng (14):
      flow_offload: fill flags to action structure
      flow_offload: reject to offload tc actions in offload drivers
      flow_offload: add index to flow_action_entry structure
      flow_offload: rename offload functions with offload instead of flow
      flow_offload: add ops to tc_action_ops for flow action setup
      flow_offload: allow user to offload tc action to net device
      flow_offload: add skip_hw and skip_sw to control if offload the action
      flow_offload: rename exts stats update functions with hw
      flow_offload: add process to update action stats from hardware
      net: sched: save full flags for tc action
      flow_offload: add reoffload process to update hw_count
      flow_offload: validate flags of filter and actions
      selftests: tc-testing: add action offload selftest for action and filter
      flow_offload: fix suspicious RCU usage when offloading tc action

Ben Ben-Ishay (1):
      net/mlx5e: SHAMPO, clean MLX5E_MAX_KLM_PER_WQE macro

Ben Greear (1):
      ath11k: Fix napi related hang

Benjamin Berg (5):
      Bluetooth: Reset more state when cancelling a sync command
      Bluetooth: Add hci_cmd_sync_cancel to public API
      Bluetooth: hci_core: Cancel sync command if sending a frame failed
      Bluetooth: btusb: Cancel sync commands for certain URB errors
      Bluetooth: hci_sync: Push sync command cancellation to workqueue

Benjamin Li (5):
      wcn36xx: add debug prints for sw_scan start/complete
      wcn36xx: implement flush op to speed up connected scan
      wcn36xx: ensure pairing of init_scan/finish_scan and start_scan/end_scan
      wcn36xx: populate band before determining rate on RX
      wcn36xx: fix RX BD rate mapping for 5GHz legacy rates

Benjamin Poirier (2):
      net: mpls: Remove duplicate variable from iterator macro
      net: mpls: Make for_nexthops iterator const

Benjamin Yim (1):
      tcp: tcp_send_challenge_ack delete useless param `skb`

Bernard Zhao (2):
      net/bridge: replace simple_strtoul to kstrtol
      netfilter: ctnetlink: remove useless type conversion to bool

Bhupesh Sharma (2):
      net: stmmac: dwmac-qcom-ethqos: add platform level clocks management
      net: stmmac: Add platform level debug register dump feature

Bjoern A. Zeeb (2):
      iwlwifi: iwl-eeprom-parse: mostly dvm only
      iwlwifi: do not use __unused as variable name

Bo Jiao (1):
      mt76: fix the wiphy's available antennas to the correct value

Brett Creeley (7):
      ice: Refactor promiscuous functions
      virtchnl: Add support for new VLAN capabilities
      iavf: Add support for VIRTCHNL_VF_OFFLOAD_VLAN_V2 negotiation
      iavf: Add support VIRTCHNL_VF_OFFLOAD_VLAN_V2 during netdev config
      iavf: Add support for VIRTCHNL_VF_OFFLOAD_VLAN_V2 hotpath
      iavf: Add support for VIRTCHNL_VF_OFFLOAD_VLAN_V2 offload enable/disable
      iavf: Restrict maximum VLAN filters for VIRTCHNL_VF_OFFLOAD_VLAN_V2

Brian Gix (14):
      Bluetooth: hci_sync: Convert MGMT_OP_SET_FAST_CONNECTABLE
      Bluetooth: hci_sync: Enable synch'd set_bredr
      Bluetooth: hci_sync: Convert MGMT_OP_GET_CONN_INFO
      Bluetooth: hci_sync: Convert MGMT_OP_SET_SECURE_CONN
      Bluetooth: hci_sync: Convert MGMT_OP_GET_CLOCK_INFO
      Bluetooth: hci_sync: Convert MGMT_OP_SET_LE
      Bluetooth: hci_sync: Convert MGMT_OP_READ_LOCAL_OOB_DATA
      Bluetooth: hci_sync: Convert MGMT_OP_READ_LOCAL_OOB_EXT_DATA
      Bluetooth: hci_sync: Convert MGMT_OP_SET_LOCAL_NAME
      Bluetooth: hci_sync: Convert MGMT_OP_SET_PHY_CONFIGURATION
      Bluetooth: hci_sync: Convert MGMT_OP_SET_ADVERTISING
      Bluetooth: hci_sync: Convert adv_expire
      Bluetooth: hci_sync: Convert MGMT_OP_SSP
      Bluetooth: refactor malicious adv data check

Brian Norris (1):
      mwifiex: Fix possible ABBA deadlock

Brian Silverman (1):
      can: gs_usb: gs_can_start_xmit(): zero-initialize hf->{flags,reserved}

Bryan O'Donoghue (7):
      wcn36xx: Indicate beacon not connection loss on MISSED_BEACON_IND
      wcn36xx: Fix DMA channel enable/disable cycle
      wcn36xx: Release DMA channel descriptor allocations
      wcn36xx: Put DXE block into reset before freeing memory
      wcn36xx: Fix beacon filter structure definitions
      wcn36xx: Fix physical location of beacon filter comment
      wcn36xx: Implement beacon filtering

Carl Huang (9):
      ath11k: enable 802.11 power save mode in station mode
      ath11k: get msi_data again after request_irq is called
      ath11k: add CE and ext IRQ flag to indicate irq_handler
      ath11k: use ATH11K_PCI_IRQ_DP_OFFSET for DP IRQ
      ath11k: refactor multiple MSI vector implementation
      ath11k: add support one MSI vector
      ath11k: do not restore ASPM in case of single MSI vector
      ath11k: support MAC address randomization in scan
      ath11k: set DTIM policy to stick mode for station interface

Catherine Sullivan (4):
      gve: Move the irq db indexes out of the ntfy block struct
      gve: Update gve_free_queue_page_list signature
      gve: remove memory barrier around seqno
      gve: Implement suspend/resume/shutdown

Changcheng Deng (4):
      rtw89: remove unneeded variable
      pktgen: use min() to make code cleaner
      net: dsa: microchip: remove unneeded variable
      mt76: mt7921: fix boolreturn.cocci warning

Cheng Wang (1):
      ath11k: add support of firmware logging for WCN6855

Chia-Yuan Li (1):
      rtw89: add AXIDMA and TX FIFO dump in mac_mem_dump

Chin-Yen Lee (2):
      rtw88: don't check CRC of VHT-SIG-B in 802.11ac signal
      rtw88: don't consider deep PS mode when transmitting packet

Ching-Te Ku (7):
      rtw89: coex: correct C2H header length
      rtw89: coex: Not to send H2C when WL not ready and count H2C
      rtw89: coex: Add MAC API to get BT polluted counter
      rtw89: coex: Define LPS state for BTC using
      rtw89: coex: Update BT counters while receiving report
      rtw89: coex: Cancel PS leaving while C2H comes
      rtw89: coex: Update COEX to 5.5.8

Chris Chiu (1):
      rtl8xxxu: Improve the A-MPDU retransmission rate with RTS/CTS protection

Chris Mi (2):
      net/mlx5e: Specify out ifindex when looking up decap route
      net/sched: act_ct: Offload only ASSURED connections

Christian Lamparter (1):
      ath10k: fetch (pre-)calibration data via nvmem subsystem

Christoph Hellwig (15):
      x86, bpf: Cleanup the top of file header in bpf_jit_comp.c
      bpf: Remove a redundant comment on bpf_prog_free
      bpf, docs: Prune all references to "internal BPF"
      bpf, docs: Move handling of maps to Documentation/bpf/maps.rst
      bpf, docs: Split general purpose eBPF documentation out of filter.rst
      bpf, docs: Fix verifier references
      bpf, docs: Split the comparism to classic BPF from instruction-set.rst
      bpf, docs: Generate nicer tables for instruction encodings
      bpf, docs: Move the packet access instructions last in instruction-set.rst
      bpf, docs: Add a setion to explain the basic instruction encoding
      bpf, docs: Add subsections for ALU and JMP instructions
      bpf, docs: Document the opcode classes
      bpf, docs: Fully document the ALU opcodes
      bpf, docs: Fully document the JMP opcodes
      bpf, docs: Fully document the JMP mode modifiers

Christophe JAILLET (39):
      net: bridge: Slightly optimize 'find_portno()'
      net: ipa: Use 'for_each_clear_bit' when possible
      rds: Fix a typo in a comment
      net-sysfs: Slightly optimize 'xps_queue_show()'
      qed: Use the bitmap API to simplify some functions
      hv_netvsc: Use bitmap_zalloc() when applicable
      ethtool: netlink: Slightly simplify 'ethnl_features_to_bitmap()'
      net: spider_net: Use non-atomic bitmap API when applicable
      net/mlx5: Fix some error handling paths in 'mlx5e_tc_add_fdb_flow()'
      carl9170: Use the bitmap API when applicable
      lib: objagg: Use the bitmap API when applicable
      net/smc: Use the bitmap API when applicable
      enic: Use dma_set_mask_and_coherent()
      tehuti: Use dma_set_mask_and_coherent() and simplify code
      sun/cassini: Use dma_set_mask_and_coherent() and simplify code
      chelsio: cxgb: Use dma_set_mask_and_coherent() and simplify code
      qed: Use dma_set_mask_and_coherent() and simplify code
      enic: Remove usage of the deprecated "pci-dma-compat.h" API
      ethernet: s2io: Use dma_set_mask_and_coherent() and simplify code
      net: vxge: Use dma_set_mask_and_coherent() and simplify code
      ice: Slightly simply ice_find_free_recp_res_idx
      ice: Optimize a few bitmap operations
      ice: Use bitmap_free() to free bitmap
      qlcnic: Simplify DMA setting
      myri10ge: Simplify DMA setting
      net: alteon: Simplify DMA setting
      bna: Simplify DMA setting
      vmxnet3: Remove useless DMA-32 fallback configuration
      be2net: Remove useless DMA-32 fallback configuration
      et131x: Remove useless DMA-32 fallback configuration
      bnx2x: Remove useless DMA-32 fallback configuration
      cxgb3: Remove useless DMA-32 fallback configuration
      cxgb4: Remove useless DMA-32 fallback configuration
      cxgb4vf: Remove useless DMA-32 fallback configuration
      net: enetc: Remove useless DMA-32 fallback configuration
      lan743x: Remove useless DMA-32 fallback configuration
      hinic: Remove useless DMA-32 fallback configuration
      rocker: Remove useless DMA-32 fallback configuration
      net/qla3xxx: Remove useless DMA-32 fallback configuration

Christophe Leroy (1):
      net/wan/fsl_ucc_hdlc: fix sparse warnings

Christy Lee (6):
      bpf: Only print scratched registers and stack slots to verifier logs.
      bpf: Right align verifier states in verifier logs.
      Only output backtracking information in log level 2
      libbpf: Deprecate bpf_perf_event_read_simple() API
      libbpf 1.0: Deprecate bpf_map__is_offload_neutral()
      libbpf 1.0: Deprecate bpf_object__find_map_by_offset() API

Chung-Hsuan Hung (1):
      rtw89: 8852a: correct bit definition of dfs_en

Clément Léger (6):
      net: ocelot: export ocelot_ifh_port_set() to setup IFH
      net: ocelot: add and export ocelot_ptp_rx_timestamp()
      net: ocelot: add support for ndo_change_mtu
      net: ocelot: add FDMA support
      net: ocelot: use dma_unmap_addr to get tx buffer dma_addr
      net: ocelot: add support to get port mac from device-tree

Coco Li (1):
      gro: add ability to control gro max packet size

Colin Foster (13):
      net: mdio: mscc-miim: convert to a regmap implementation
      net: dsa: ocelot: seville: utilize of_mdiobus_register
      net: dsa: ocelot: felix: utilize shared mscc-miim driver for indirect MDIO access
      net: dsa: ocelot: remove unnecessary pci_bar variables
      net: dsa: ocelot: felix: Remove requirement for PCS in felix devices
      net: dsa: ocelot: felix: add interface for custom regmaps
      net: mscc: ocelot: split register definitions to a separate file
      net: ocelot: fix missed include in the vsc7514_regs.h file
      net: phy: lynx: refactor Lynx PCS module to use generic phylink_pcs
      net: dsa: felix: name change for clarity from pcs to mdio_device
      net: dsa: seville: name change for clarity from pcs to mdio_device
      net: ethernet: enetc: name change for clarity from pcs to mdio_device
      net: pcs: lynx: use a common naming scheme for all lynx_pcs variables

Colin Ian King (12):
      mac80211_hwsim: Fix spelling mistake "Droping" -> "Dropping"
      ath11k: Fix spelling mistake "detetction" -> "detection"
      net: dsa: qca8k: Fix spelling mistake "Mismateched" -> "Mismatched"
      iwlwifi: mei: Fix spelling mistake "req_ownserhip" -> "req_ownership"
      net: hns3: Fix spelling mistake "faile" -> "failed"
      bpf: Remove redundant assignment to pointer t
      net: broadcom: bcm4908enet: remove redundant variable bytes
      Bluetooth: MGMT: Fix spelling mistake "simultanous" -> "simultaneous"
      netfilter: nft_set_pipapo_avx2: remove redundant pointer lt
      net: caif: remove redundant assignment to variable expectlen
      nfc: st21nfca: remove redundant assignment to variable i
      net/smc: remove redundant re-assignment of pointer link

Conley Lee (2):
      sun4i-emac.c: remove unnecessary branch
      sun4i-emac.c: add dma support

Dan Carpenter (13):
      net/mlx5: SF, silence an uninitialized variable warning
      net: lan966x: fix a IS_ERR() vs NULL check in lan966x_create_targets()
      ice: Remove unnecessary casts
      net: mtk_eth_soc: delete an unneeded variable
      net: ethernet: mtk_eth_soc: delete some dead code
      wilc1000: fix double free error in probe()
      iwlwifi: mvm: fix a stray tab
      iwlwifi: mvm: clean up indenting in iwl_mvm_tlc_update_notif()
      rocker: fix a sleeping in atomic bug
      Bluetooth: L2CAP: uninitialized variables in l2cap_sock_setsockopt()
      Bluetooth: hci_sock: fix endian bug in hci_sock_setsockopt()
      ax25: uninitialized variable in ax25_setsockopt()
      netrom: fix api breakage in nr_setsockopt()

Daniel Borkmann (3):
      bpf: Don't promote bogus looking registers after null check.
      bpf, selftests: Add verifier test for mem_or_null register with offset.
      veth: Do not record rx queue hint in veth_xmit

Daniel Golle (3):
      mt76: eeprom: tolerate corrected bit-flips
      net: ethernet: mtk_eth_soc: fix return values and refactor MDIO ops
      net: ethernet: mtk_eth_soc: implement Clause 45 MDIO access

Danielle Ratson (7):
      mlxsw: spectrum_router: Remove deadcode in mlxsw_sp_rif_mac_profile_find
      mlxsw: pci: Add shutdown method in PCI driver
      mlxsw: Fix naming convention of MFDE fields
      mlxsw: core: Convert a series of if statements to switch case
      mlxsw: reg: Extend MFDE register with new events and parameters
      mlxsw: core: Extend devlink health reporter with new events and parameters
      mlxsw: pci: Avoid flow control for EMAD packets

Dany Madden (2):
      ibmvnic: Update driver return codes
      ibmvnic: remove unused defines

Dario Binacchi (4):
      can: flexcan: allow to change quirks at runtime
      can: flexcan: add ethtool support to get rx/tx ring parameters
      docs: networking: device drivers: add can sub-folder
      docs: networking: device drivers: can: add flexcan

Dave Marchevsky (4):
      bpftool: Migrate -1 err checks of libbpf fn calls
      bpftool: Use bpf_obj_get_info_by_fd directly
      perf: Pull in bpf_program__get_prog_info_linear
      libbpf: Deprecate bpf_program__get_prog_info_linear

Dave Tucker (3):
      bpf, docs: Change underline in btf to match style guide
      bpf, docs: Rename bpf_lsm.rst to prog_lsm.rst
      bpf, docs: Fix ordering of bpf documentation

David Mosberger-Tang (13):
      wilc1000: Add id_table to spi_driver
      wilc1000: Fix copy-and-paste typo in wilc_set_mac_address
      wilc1000: Fix missing newline in error message
      wilc1000: Remove misleading USE_SPI_DMA macro
      wilc1000: Fix spurious "FW not responding" error
      wilc1000: Rename SPI driver from "WILC_SPI" to "wilc1000_spi"
      wilc1000: Rename irq handler from "WILC_IRQ" to netdev name
      wilc1000: Rename tx task from "K_TXQ_TASK" to NETDEV-tx
      wilc1000: Rename workqueue from "WILC_wq" to "NETDEV-wq"
      wilc1000: Improve WILC TX performance when power_save is off
      wilc1000: Convert static "chipid" variable to device-local variable
      wilc1000: Add reset/enable GPIO support to SPI driver
      wilc1000: Document enable-gpios and reset-gpios properties

David S. Miller (90):
      Merge branch 'mctp-i2c-driver'
      Merge branch 'generic-phylink-validation'
      Merge branch 'tcp-optimizations'
      Merge branch 'gro-out-of-core-files'
      Merge branch 'inuse-cleanups'
      Merge tag 'mlx5-updates-2021-11-16' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'xilinx-phylink'
      Merge branch 'enetc-phylink'
      Merge branch 'sparx5-phylink'
      Merge branch 'mtk_eth_soc-phylink'
      Merge branch 'ocelot_net-phylink'
      Merge tag 'for-net-next-2021-11-16' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next
      Merge branch 'dev_watchdog-less-intrusive'
      Merge branch 'ag71xx-phylink'
      Merge branch 'dpaa2-phylink'
      Merge branch '10GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'dsa-felix-psfp'
      Merge branch 'lan78xx-napi'
      Merge branch 'dev_addr-const-x86'
      Merge branch 'hw_addr_set-arch'
      Merge branch 's390-next'
      Merge branch 'dev_addr-const'
      Merge branch 'mptcp-more-socket-options'
      Merge branch 'ethtool-copybreak'
      Merge branch 'tsn-endpoint-driver'
      tsn:  Fix build.
      Merge branch 'skbuff-struct-group'
      Merge branch 'qca8k-next'
      Merge branch 'mlxsw-updates'
      Merge branch 'qca8k-mirror-and-lag-support'
      Merge branch 'mvpp2-5gbase-r-support'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'hns3-next'
      Merge branch 'mvneta-next'
      Merge branch 'vxlan-port'
      Merge branch 'qualcomm-bam-dmux'
      Merge branch 'mpls-cleanups'
      Merge branch 'lan966x-driver'
      Merge branch 'seville-shared-mdio'
      Merge branch 'hns3-cleanups'
      Merge branch 'prestera-next'
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'mlxsw-Spectrum-4-prep'
      Merge branch 'hns3-cleanups'
      Merge branch 'hns3-cleanups'
      Merge branch 'dsa-tagger-storage'
      Merge branch 'bareudp-remove-unused'
      Merge branch 'mse102x-support'
      Merge branch 'hwtstamp_bonding'
      Merge branch 'dsa-fixups'
      Revert "pktgen: use min() to make code cleaner"
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge tag 'mlx5-updates-2021-12-14' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'mlxsw-ipv6-underlay'
      Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/nex t-queue
      Merge branch 'phylink-pcs-validation'
      Merge branch 'gve-improvements'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'tc-action-offload'
      Merge branch 'mlxsw-devlink=health-reporter-extensions'
      Merge branch 'lan966x-switchdev-and-vlan'
      Merge branch 'mlxsw-tests'
      Merge branch 'bnxt_en-next'
      Merge branch 'prestera-router-driver'
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next- queue
      Merge branch 'hnsd3-next'
      Merge tag 'mlx5-updates-2021-12-28' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge branch 'smc-RDMA-net-namespace'
      Merge branch 'lynx-pcs-interface-cleanup'
      Merge branch 'act_tc-offload-originating-device'
      Merge branch 'namespacify-mtu-ipv4'
      Merge branch 'mtk_eth_soc-refactoring-and-clause45'
      Merge branch 'lan966x-extend-switchdev-and-mdb-support'
      Merge branch 'hns3-stats-refactor'
      Merge branch 'dsa-cleanups'
      Merge tag 'linux-can-next-for-5.17-20220105' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge branch 'dsa-notifier-cleanup'
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec
      Merge branch 'dsa-init-cleanups'
      Merge tag 'mlx5-fixes-2022-01-06' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge tag 'mlx5-updates-2022-01-06' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'mptcp-next'
      Merge branch 'mptcp-fixes'
      Merge branch 'octeontx2-ptp-bugs'
      Merge tag 'linux-can-next-for-5.17-20220108' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next

David Yang (1):
      Bluetooth: btusb: Fix application of sizeof to pointer

Davide Caratti (1):
      mptcp: allow changing the "backup" bit by endpoint id

Deren Wu (5):
      mt76: mt7921: add support for PCIe ID 0x0608/0x0616
      mt76: mt7921: introduce 160 MHz channel bandwidth support
      mt76: mt7921s: fix bus hang with wrong privilege
      mt76: mt7921: fix network buffer leak by txs missing
      mt76: mt7921s: fix cmd timeout in throughput test

Dexuan Cui (1):
      net: mana: Add RX fencing

Dima Chumak (1):
      net/mlx5e: Fix nullptr on deleting mirroring rule

Divya Koppera (1):
      net: phy: micrel: Adding interrupt support for Link up/Link down in LAN8814 Quad phy

Dmytro Linkin (2):
      net/mlx5: E-switch, Enable vport QoS on demand
      net/mlx5: E-switch, Create QoS on demand

Drew Fustini (1):
      selftests/bpf: Fix trivial typo

Dust Li (1):
      net/smc: add comments for smc_link_{usable|sendable}

Edwin Peer (5):
      bnxt_en: convert to xdp_do_flush
      bnxt_en: add dynamic debug support for HWRM messages
      bnxt_en: improve VF error messages when PF is unavailable
      bnxt_en: use firmware provided max timeout for messages
      bnxt_en: improve firmware timeout messaging

Emmanuel Grumbach (12):
      iwlwifi: mei: add the driver to allow cooperation with CSME
      iwlwifi: mei: add debugfs hooks
      iwlwifi: integrate with iwlmei
      iwlwifi: mvm: add vendor commands needed for iwlmei
      iwlwifi: mvm: read the rfkill state and feed it to iwlmei
      iwlwifi: mei: fix linking when tracing is not enabled
      iwlwifi: mei: don't rely on the size from the shared area
      iwlwifi: mvm: fix a possible NULL pointer deference
      iwlwifi: mvm: remove session protection upon station removal
      rfkill: allow to get the software rfkill state
      iwlwifi: mei: clear the ownership when the driver goes down
      iwlwifi: mei: wait before mapping the shared area

Eric Dumazet (104):
      tcp: minor optimization in tcp_add_backlog()
      tcp: remove dead code in __tcp_v6_send_check()
      tcp: small optimization in tcp_v6_send_check()
      net: use sk_is_tcp() in more places
      net: remove sk_route_forced_caps
      net: remove sk_route_nocaps
      ipv6: shrink struct ipcm6_cookie
      net: shrink struct sock by 8 bytes
      net: forward_alloc_get depends on CONFIG_MPTCP
      net: cache align tcp_memory_allocated, tcp_sockets_allocated
      tcp: small optimization in tcp recvmsg()
      tcp: add RETPOLINE mitigation to sk_backlog_rcv
      tcp: annotate data-races on tp->segs_in and tp->data_segs_in
      tcp: annotate races around tp->urg_data
      tcp: tp->urg_data is unlikely to be set
      tcp: avoid indirect calls to sock_rfree
      tcp: defer skb freeing after socket lock is released
      tcp: check local var (timeo) before socket fields in one test
      tcp: do not call tcp_cleanup_rbuf() if we have a backlog
      net: move early demux fields close to sk_refcnt
      net: move gro definitions to include/net/gro.h
      net: gro: move skb_gro_receive_list to udp_offload.c
      net: gro: move skb_gro_receive into net/core/gro.c
      net: gro: populate net/core/gro.c
      net: inline sock_prot_inuse_add()
      net: make sock_inuse_add() available
      net: merge net->core.prot_inuse and net->core.sock_inuse
      net: drop nopreempt requirement on sock_prot_inuse_add()
      once: use __section(".data.once")
      net: use .data.once section in netdev_level_once()
      net: align static siphash keys
      net: use an atomic_long_t for queue->trans_timeout
      net: annotate accesses to queue->trans_start
      net: do not inline netif_tx_lock()/netif_tx_unlock()
      net: no longer stop all TX queues in dev_watchdog()
      net: add missing include in include/net/gro.h
      tcp: add missing htmldocs for skb->ll_node and sk->defer_list
      ipv6: ip6_skb_dst_mtu() cleanups
      net: annotate accesses to dev->gso_max_size
      net: annotate accesses to dev->gso_max_segs
      gro: remove rcu_read_lock/rcu_read_unlock from gro_receive handlers
      gro: remove rcu_read_lock/rcu_read_unlock from gro_complete handlers
      gro: optimize skb_gro_postpull_rcsum()
      net: optimize skb_postpull_rcsum()
      Revert "net: snmp: add statistics for tcp small queue check"
      lib: add reference counting tracking infrastructure
      lib: add tests for reference tracker
      net: add net device refcount tracker infrastructure
      net: add net device refcount tracker to struct netdev_rx_queue
      net: add net device refcount tracker to struct netdev_queue
      net: add net device refcount tracker to ethtool_phys_id()
      net: add net device refcount tracker to dev_ifsioc()
      drop_monitor: add net device refcount tracker
      net: dst: add net device refcount tracking to dst_entry
      ipv6: add net device refcount tracker to rt6_probe_deferred()
      sit: add net device refcount tracking to ip_tunnel
      ipv6: add net device refcount tracker to struct ip6_tnl
      net: add net device refcount tracker to struct neighbour
      net: add net device refcount tracker to struct pneigh_entry
      net: add net device refcount tracker to struct neigh_parms
      net: add net device refcount tracker to struct netdev_adjacent
      ipv6: add net device refcount tracker to struct inet6_dev
      ipv4: add net device refcount tracker to struct in_device
      net/sched: add net device refcount tracker to struct Qdisc
      net: linkwatch: add net device refcount tracker
      net: failover: add net device refcount tracker
      ipmr, ip6mr: add net device refcount tracker to struct vif_device
      netpoll: add net device refcount tracker to struct netpoll
      net: fix recent csum changes
      vrf: use dev_replace_track() for better tracking
      net: eql: add net device refcount tracker
      vlan: add net device refcount tracker
      net: bridge: add net device refcount tracker
      net: watchdog: add net device refcount tracker
      net: switchdev: add net device refcount tracker
      inet: add net device refcount tracker to struct fib_nh_common
      ax25: add net device refcount tracker
      llc: add net device refcount tracker
      pktgen add net device refcount tracker
      net/smc: add net device tracker to struct smc_pnetentry
      netlink: add net device refcount tracker to struct ethnl_req_info
      openvswitch: add net device refcount tracker to struct vport
      net: sched: act_mirred: add net device refcount tracker
      xfrm: fix a small bug in xfrm_sa_len()
      xfrm: use net device refcount tracker helpers
      net: add networking namespace refcount tracker
      net: add netns refcount tracker to struct sock
      net: add netns refcount tracker to struct seq_net_private
      net: sched: add netns refcount tracker to struct tcf_exts
      l2tp: add netns refcount tracker to l2tp_dfs_seq_data
      ppp: add netns refcount tracker
      xfrm: add net device refcount tracker to struct xfrm_state_offload
      ipv6: use GFP_ATOMIC in rt6_probe()
      mptcp: adjust to use netns refcount tracker
      net: linkwatch: be more careful about dev->linkwatch_dev_tracker
      net: dev_replace_track() cleanup
      ethtool: use ethnl_parse_header_dev_put()
      net: add net device refcount tracker to struct packet_type
      netfilter: nfnetlink: add netns refcount tracker to struct nfulnl_instance
      netfilter: nf_nat_masquerade: add netns refcount tracker to masq_dev_work
      net/sched: add missing tracker information in qdisc_create()
      netlink: do not allocate a device refcount tracker in ethnl_default_notify()
      ppp: ensure minimum packet size in ppp_write()
      af_packet: fix tracking issues in packet_do_bind()

Erik Ekman (1):
      net: bna: Update supported link modes

Evgeny Boger (3):
      dt-bindings: net: can: add support for Allwinner R40 CAN controller
      can: sun4i_can: add support for R40 CAN controller
      ARM: dts: sun8i: r40: add node for CAN controller

Fabio Estevam (1):
      ath10k: Fix the MTU size on QCA9377 SDIO

Felix Fietkau (13):
      mac80211: add support for .ndo_fill_forward_path
      mt76: mt7915: fix decap offload corner case with 4-addr VLAN frames
      mt76: mt7615: fix decap offload corner case with 4-addr VLAN frames
      mt76: mt7615: improve wmm index allocation
      mt76: mt7915: improve wmm index allocation
      mt76: clear sta powersave flag after notifying driver
      mt76: mt7603: improve reliability of tx powersave filtering
      mt76: mt7615: clear mcu error interrupt status on mt7663
      mt76: allow drivers to drop rx packets early
      mt76: mt7915: process txfree and txstatus without allocating skbs
      mt76: mt7615: in debugfs queue stats, skip wmm index 3 on mt7663
      mac80211: use coarse boottime for airtime fairness code
      nl80211: clarify comment for mesh PLINK_BLOCKED state

Florent Revest (1):
      libbpf: Change bpf_program__set_extra_flags to bpf_program__set_flags

Florian Fainelli (2):
      net: mdio: Replaced BUG_ON() with WARN()
      net: mdio: Demote probed message to debug print

Florian Westphal (23):
      mptcp: sockopt: add SOL_IP freebind & transparent options
      selftests: mptcp: add tproxy test case
      netfilter: nf_queue: remove leftover synchronize_rcu
      netfilter: bridge: add support for pppoe filtering
      mptcp: add TCP_INQ cmsg support
      selftests: mptcp: add TCP_INQ support
      mptcp: add SIOCINQ, OUTQ and OUTQNSD ioctls
      selftests: mptcp: add inq test case
      mptcp: getsockopt: add support for IP_TOS
      selftests: mptcp: check IP_TOS in/out are the same
      fib: rules: remove duplicated nla policies
      fib: expand fib_rule_policy
      selftests: mptcp: try to set mptcp ulp mode in different sk states
      netfilter: conntrack: tag conntracks picked up in local out hook
      netfilter: nat: force port remap to prevent shadowing well-known ports
      netfilter: flowtable: remove ipv4/ipv6 modules
      netfilter: nft_set_pipapo: allocate pcpu scratch maps on clone
      netfilter: conntrack: convert to refcount_t api
      netfilter: core: move ip_ct_attach indirection to struct nf_ct_hook
      netfilter: make function op structures const
      netfilter: conntrack: avoid useless indirection during conntrack destruction
      net: prefer nf_ct_put instead of nf_conntrack_put
      netfilter: egress: avoid a lockdep splat

Gal Pressman (3):
      net/mlx5e: Move HW-GRO and CQE compression check to fix features flow
      net/mlx5e: Add recovery flow in case of error CQE
      net/tls: Fix skb memory leak when running kTLS traffic

Geert Uytterhoeven (1):
      sh_eth: Use dev_err_probe() helper

Geliang Tang (3):
      mptcp: fix a DSS option writing error
      mptcp: change the parameter of __mptcp_make_csum
      mptcp: reuse __mptcp_make_csum in validate_data_csum

Gerhard Engleder (6):
      dt-bindings: Add vendor prefix for Engleder
      dt-bindings: net: Add tsnep Ethernet controller
      tsnep: Add TSN endpoint Ethernet MAC driver
      tsnep: Fix set MAC address
      tsnep: Fix resource_size cocci warning
      tsnep: Fix s390 devm_ioremap_resource warning

Ghalem Boudour (1):
      xfrm: fix policy lookup for ipv6 gre packets

Grant Seltzer (3):
      libbpf: Add doc comments in libbpf.h
      libbpf: Add doc comments for bpf_program__(un)pin()
      libbpf: Add documentation for bpf_map batch operations

Greg Kroah-Hartman (1):
      ethernet: ibmveth: use default_groups in kobj_type

Gregory Greenman (1):
      iwlwifi: mvm: rfi: update rfi table

Grzegorz Szczurek (1):
      iavf: Log info when VF is entering and leaving Allmulti mode

Guangbin Huang (7):
      net: hns3: refine function hclge_cfg_mac_speed_dup_hw()
      net: hns3: add new function hclge_tm_schd_mode_tc_base_cfg()
      net: hns3: refine function hclge_tm_pri_q_qs_cfg()
      net: hns3: refactor function hclge_set_vlan_filter_hw
      net: hns3: add print vport id for failed message of vlan
      net: hns3: modify one argument type of function hclge_ncl_config_data_print
      Revert "net: hns3: add void before function which don't receive ret"

Guillaume Nault (3):
      bareudp: Remove bareudp_dev_create()
      bareudp: Move definition of struct bareudp_conf to bareudp.c
      bareudp: Add extack support to bareudp_configure()

Guo Zhengkui (1):
      hinic: use ARRAY_SIZE instead of ARRAY_LEN

GuoYong Zheng (1):
      ipvs: remove unused variable for ip_vs_new_dest

Gustavo A. R. Silva (2):
      net: hinic: Use devm_kcalloc() instead of devm_kzalloc()
      net: huawei: hinic: Use devm_kcalloc() instead of devm_kzalloc()

Haim Dreyfuss (1):
      iwlwifi: pcie: support Bz suspend/resume trigger

Haimin Zhang (1):
      bpf: Add missing map_get_next_key method to bloom filter map.

Haiyang Zhang (1):
      net: mana: Add XDP support

Haiyue Wang (1):
      ice: Add package PTYPE enable information

Hamish MacDonald (1):
      net: socket.c: style fix

Hangbin Liu (7):
      Bonding: add arp_missed_max option
      bond: pass get_ts_info and SIOC[SG]HWTSTAMP ioctl to active device
      net_tstamp: add new flag HWTSTAMP_FLAG_BONDED_PHC_INDEX
      Bonding: force user to add HWTSTAMP_FLAG_BONDED_PHC_INDEX when get/set HWTSTAMP
      net_tstamp: define new flag HWTSTAMP_FLAG_BONDED_PHC_INDEX
      Bonding: return HWTSTAMP_FLAG_BONDED_PHC_INDEX to notify user space
      selftests: netfilter: switch to socat for tests using -q option

Hao Chen (15):
      ethtool: add support to set/get tx copybreak buf size via ethtool
      net: hns3: add support to set/get tx copybreak buf size via ethtool for hns3 driver
      ethtool: add support to set/get rx buf len via ethtool
      ethtool: extend ringparam setting/getting API with rx_buf_len
      net: hns3: add support to set/get rx buf len via ethtool for hns3 driver
      net: hns3: remove the way to set tx spare buf via module parameter
      net: vxlan: add macro definition for number of IANA VXLAN-GPE port
      net: hns3: use macro IANA_VXLAN_GPE_UDP_PORT to replace number 4790
      net: hns3: refactor hns3_nic_reuse_page()
      net: hns3: Align type of some variables with their print type
      net: hns3: align return value type of atomic_read() with its output
      net: hns3: add void before function which don't receive ret
      net: hns3: add comments for hclge_dbg_fill_content()
      net: hns3: remove rebundant line for hclge_dbg_dump_tm_pg()
      net: hns3: replace one tab with space in for statement

Hao Luo (10):
      bpf: Introduce composable reg, ret and arg types.
      bpf: Replace ARG_XXX_OR_NULL with ARG_XXX | PTR_MAYBE_NULL
      bpf: Replace RET_XXX_OR_NULL with RET_XXX | PTR_MAYBE_NULL
      bpf: Replace PTR_TO_XXX_OR_NULL with PTR_TO_XXX | PTR_MAYBE_NULL
      bpf: Introduce MEM_RDONLY flag
      bpf: Convert PTR_TO_MEM_OR_NULL to composable types.
      bpf: Make per_cpu_ptr return rdonly PTR_TO_MEM.
      bpf: Add MEM_RDONLY for helper args that are pointers to rdonly mem.
      bpf/selftests: Test PTR_TO_RDONLY_MEM
      bpf/selftests: Test bpf_d_path on rdonly_mem.

Hari Nagalla (1):
      net: phy: add support for TI DP83561-SP phy

Harshit Mogalapalli (1):
      net: sched: sch_netem: Refactor code in 4-state loss generator

Heiko Carstens (5):
      net/iucv: fix kernel doc comments
      net/af_iucv: fix kernel doc comments
      s390/ctcm: fix format string
      s390/ctcm: add __printf format attribute to ctcm_dbf_longtext
      s390/lcs: add braces around empty function body

Heiner Kallweit (7):
      r8169: enable ASPM L1/L1.1 from RTL8168h
      r8169: disable detection of chip versions 49 and 50
      r8169: disable detection of chip version 45
      r8169: disable detection of chip version 41
      sky2: use PCI VPD API in eeprom ethtool ops
      r8169: disable detection of chip version 60
      stmmac: remove ethtool driver version info

Hengqi Chen (3):
      bpftool: Use libbpf_get_error() to check error
      libbpf: Support static initialization of BPF_MAP_TYPE_PROG_ARRAY
      selftests/bpf: Test BPF_MAP_TYPE_PROG_ARRAY static initialization

Horatiu Vultur (26):
      dt-bindings: net: lan966x: Add lan966x-switch bindings
      net: lan966x: add the basic lan966x driver
      net: lan966x: add port module support
      net: lan966x: add mactable support
      net: lan966x: add ethtool configuration and statistics
      net: lan966x: Update MAINTAINERS to include lan966x driver
      net: mdio: mscc-miim: Set back the optional resource.
      net: lan966x: Fix duplicate check in frame extraction
      dt-bindings: net: lan966x: Add additional properties for lan966x
      net: lan966x: Fix builds for lan966x driver
      net: lan966x: Fix the configuration of the pcs
      net: lan966x: Add registers that are used for switch and vlan functionality
      dt-bindings: net: lan966x: Extend with the analyzer interrupt
      net: lan966x: add support for interrupts from analyzer
      net: lan966x: More MAC table functionality
      net: lan966x: Remove .ndo_change_rx_flags
      net: lan966x: Add support to offload the forwarding.
      net: lan966x: Add vlan support.
      net: lan966x: Extend switchdev bridge flags
      net: lan966x: Extend switchdev with fdb support
      net: lan966x: Add support for multiple bridge flags
      net: phy: micrel: Add config_init for LAN8814
      net: lan966x: Fix the vlan used by host ports
      net: lan966x: Add function lan966x_mac_ip_learn()
      net: lan966x: Add PGID_GP_START and PGID_GP_END
      net: lan966x: Extend switchdev with mdb support

Hou Tao (7):
      bpf: Clean-up bpf_verifier_vlog() for BPF_LOG_KERNEL log level
      bpf: Disallow BPF_LOG_KERNEL log level for bpf(BPF_BTF_LOAD)
      bpf: Add bpf_strncmp helper
      selftests/bpf: Fix checkpatch error on empty function parameter
      selftests/bpf: Add benchmark for bpf_strncmp() helper
      selftests/bpf: Add test cases for bpf_strncmp()
      bpf, arm64: Use emit_addr_mov_i64() for BPF_PSEUDO_FUNC

Ido Schimmel (1):
      net: bridge: Allow base 16 inputs in sysfs

Ilan Peer (8):
      iwlwifi: mvm: Fix wrong documentation for scan request command
      iwlwifi: mvm: Add support for a new version of scan request command
      mac80211: Remove a couple of obsolete TODO
      cfg80211: Fix order of enum nl80211_band_iftype_attr documentation
      cfg80211: Add support for notifying association comeback
      mac80211: Notify cfg80211 about association comeback
      iwlwifi: mvm: Increase the scan timeout guard to 30 seconds
      iwlwifi: mvm: Fix calculation of frame length

Ilya Leoshkevich (1):
      selfetests/bpf: Adapt vmtest.sh to s390 libbpf CI changes

Ioana Ciornei (2):
      dpaa2-mac: return -EPROBE_DEFER from dpaa2_mac_open in case the fwnode is not set
      dpaa2-switch: check if the port priv is valid

Ivan Vecera (1):
      selftests: net: bridge: fix typo in vlan_filtering dependency test

Jackie Liu (1):
      Bluetooth: fix uninitialized variables notify_evt

Jacky Chou (1):
      net: usb: ax88179_178a: add TSO feature

Jacob Keller (15):
      iavf: return errno code instead of status code
      ice: devlink: add shadow-ram region to snapshot Shadow RAM
      ice: move and rename ice_check_for_pending_update
      ice: move ice_devlink_flash_update and merge with ice_flash_pldm_image
      ice: reduce time to read Option ROM CIVD data
      ice: support immediate firmware activation via devlink reload
      ice: introduce ice_base_incval function
      ice: PTP: move setting of tstamp_config
      ice: use 'int err' instead of 'int status' in ice_ptp_hw.c
      ice: introduce ice_ptp_init_phc function
      ice: convert clk_freq capability into time_ref
      ice: implement basic E822 PTP support
      ice: ensure the hardware Clock Generation Unit is configured
      ice: exit bypass mode once hardware finishes timestamp calibration
      ice: support crosstimestamping on E822 devices if supported

Jakub Kicinski (116):
      Revert "Merge branch 'mctp-i2c-driver'"
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge branch 'net-better-packing-of-global-vars'
      Merge branch 'r8169-disable-detection-of-further-chip-versions-that-didn-t-make-it-to-the-mass-market'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge tag 'regmap-no-bus-update-bits' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap
      net: ax88796c: don't write to netdev->dev_addr directly
      mlxsw: constify address in mlxsw_sp_port_dev_addr_set
      wilc1000: copy address before calling wilc_set_mac_address
      ipw2200: constify address in ipw_send_adapter_address
      amd: lance: use eth_hw_addr_set()
      amd: ni65: use eth_hw_addr_set()
      amd: a2065/ariadne: use eth_hw_addr_set()
      amd: hplance: use eth_hw_addr_set()
      amd: atarilance: use eth_hw_addr_set()
      amd: mvme147: use eth_hw_addr_set()
      8390: smc-ultra: use eth_hw_addr_set()
      8390: hydra: use eth_hw_addr_set()
      8390: mac8390: use eth_hw_addr_set()
      8390: wd: use eth_hw_addr_set()
      smc9194: use eth_hw_addr_set()
      lasi_82594: use eth_hw_addr_set()
      apple: macmace: use eth_hw_addr_set()
      cirrus: mac89x0: use eth_hw_addr_set()
      natsemi: macsonic: use eth_hw_addr_set()
      82596: use eth_hw_addr_set()
      bnx2x: constify static inline stub for dev_addr
      net: constify netdev->dev_addr
      net: unexport dev_addr_init() & dev_addr_flush()
      dev_addr: add a modification check
      dev_addr_list: put the first addr on the tree
      net: kunit: add a test for dev_addr_lists
      octeon: constify netdev->dev_addr
      pcmcia: hide the MAC address helpers if !NET
      net: remove .ndo_change_proto_down
      Merge branch 'dccp-tcp-minor-fixes-for-inet_csk_listen_start'
      Merge branch 'gro-remove-redundant-rcu_read_lock'
      Merge branch 'net-ipa-small-collected-improvements'
      Merge branch 'mctp-serial-minor-fixes'
      Merge branch 'net-ipa-gsi-channel-flow-control'
      Merge branch 'net-small-csum-optimizations'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'selftests-net-bridge-vlan-multicast-tests'
      Merge branch 'af_unix-replace-unix_table_lock-with-per-hash-locks'
      Merge branch 'net-dsa-convert-two-drivers-to-phylink_generic_validate'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge tag 'mlx5-updates-2021-12-02' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'qed-enhancements'
      Merge branch 'net-add-preliminary-netdev-refcount-tracking'
      Merge branch 'mptcp-new-features-for-mptcp-sockets-and-netlink-pm'
      Merge branch 'net-second-round-of-netdevice-refcount-tracking'
      Merge tag 'wireless-drivers-next-2021-12-07' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next
      Merge branch 'prepare-ocelot-for-external-interface-control'
      Merge branch 's390-net-updates-2021-12-06'
      Merge branch 'rework-dsa-bridge-tx-forwarding-offload-api'
      Merge tag 'linux-can-next-for-5.17-20211208' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge branch 'wwan-debugfs-tweaks'
      Merge branch 'net-track-the-queue-count-at-unregistration'
      Merge branch 'net-phylink-introduce-legacy-mode-flag'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'net-netns-refcount-tracking-base-series'
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge branch 'net-wwan-iosm-improvements'
      Merge branch 'add-fdma-support-on-ocelot-switch-driver'
      ethtool: fix null-ptr-deref on ref tracker
      Merge branch 'net-dsa-hellcreek-fix-handling-of-mgmt-protocols'
      ethtool: always write dev in ethnl_parse_header_dev_get
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next
      Merge branch 'fib-merge-nl-policies'
      add includes masked by cgroup -> bpf dependency
      add missing bpf-cgroup.h includes
      bpf: Remove the cgroup -> bpf header dependecy
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge tag 'wireless-drivers-next-2021-12-17' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next
      Merge branch 'mptcp-miscellaneous-changes-for-5-17'
      Merge branch 'net-amd-xgbe-add-support-for-yellow-carp-ethernet-device'
      Merge tag 'mac80211-next-for-net-next-2021-12-21' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      codel: remove unnecessary sock.h include
      codel: remove unnecessary pkt_sched.h include
      Merge tag 'mlx5-updates-2021-12-21' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'add-tests-for-vxlan-with-ipv6-underlay'
      Merge tag 'wireless-drivers-next-2021-12-23' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      bnxt_en: Use page frag RX buffers for better software GRO performance
      Merge branch '10GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      net: Don't include filter.h from net/sock.h
      Merge branch 'net-define-new-hwtstamp-flag-and-return-it-to-userspace'
      Merge tag 'for-net-next-2021-12-29' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next
      net: Add includes masked by netdevice.h including uapi/bpf.h
      bpf: Invert the dependency between bpf-netns.h and netns/bpf.h
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge tag 'batadv-next-pullrequest-20220103' of git://git.open-mesh.org/linux-merge
      net: fixup build after bpf header changes
      Merge tag 'mac80211-next-for-net-next-2022-01-04' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next
      Merge branch 'fix-rgmii-delays-for-88e1118'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge tag 'linux-can-fixes-for-5.16-20220105' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge branch 'net-lantiq_xrx200-improve-ethernet-performance'
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
      Merge branch 'dpaa2-eth-small-cleanup'
      Merge branch 'mlxsw-add-spectrum-4-support'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'mptcp-refactoring-for-one-selftest-and-csum-validation'
      Merge branch 'ena-capabilities-field-and-cosmetic-changes'
      Merge tag 'linux-can-fixes-for-5.16-20220109' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge tag 'for-net-next-2022-01-07' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next
      Merge branch 'bnxt_en-update-for-net-next'
      net/mlx5e: Fix build error in fec_set_block_stats()
      Merge branch 'net-skb-introduce-kfree_skb_with_reason'
      net: allwinner: Fix print format
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net

Jason Wang (5):
      wlcore: no need to initialise statics to false
      isdn: cpai: no need to initialise statics to 0
      igb: remove never changed variable `ret_val'
      ath10k: replace strlcpy with strscpy
      iavf: remove an unneeded variable

Jean Sacren (5):
      net: cxgb3: fix typos in kernel doc
      net: cxgb: fix a typo in kernel doc
      net: xfrm: drop check of pols[0] for the second time
      net: x25: drop harmless check of !more
      mptcp: clean up harmless false expressions

Jean-Philippe Brucker (8):
      selftests/bpf: Build testing_helpers.o out of tree
      selftests/bpf: Fix segfault in bpf_tcp_ca
      tools: Help cross-building with clang
      tools/resolve_btfids: Support cross-building the kernel with clang
      tools/libbpf: Enable cross-building with clang
      bpftool: Enable cross-building with clang
      tools/runqslower: Enable cross-building with clang
      selftests/bpf: Enable cross-building with clang

Jedrzej Jagielski (4):
      iavf: Add trace while removing device
      iavf: Refactor iavf_mac_filter struct memory usage
      iavf: Fix displaying queue statistics shown by ethtool
      i40e: Minimize amount of busy-waiting during AQ send

Jeff Guo (1):
      ice: refactor PTYPE validating

Jeremy Kerr (5):
      mctp/test: Update refcount checking in route fragment tests
      mctp: Add MCTP-over-serial transport binding
      mctp: serial: cancel tx work on ldisc close
      mctp: serial: enforce fixed MTU
      mctp: serial: remove unnecessary ldisc data check

Jeroen de Borst (1):
      gve: Correct order of processing device options

Jesper Dangaard Brouer (2):
      igc: AF_XDP zero-copy metadata adjust breaks SKBs on XDP_PASS
      igc: enable XDP metadata in driver

Jesse Brandeburg (5):
      ice: update to newer kernel API
      ice: use prefetch methods
      ice: tighter control over VSI_DOWN state
      ice: use modern kernel API for kick
      ice: trivial: fix odd indenting

Jesse Melhuish (1):
      Bluetooth: Don't initialize msft/aosp when using user channel

Jian Shen (3):
      net: hns3: split function hclge_init_vlan_config()
      net: hns3: split function hclge_get_fd_rule_info()
      net: hns3: split function hclge_update_port_base_vlan_cfg()

Jiapeng Chong (4):
      lan78xx: Clean up some inconsistent indenting
      bpf: Use kmemdup() to replace kmalloc + memcpy
      sfc: Use swap() instead of open coding it
      netfilter: conntrack: Use max() instead of doing it manually

Jiaran Zhang (1):
      net: hns3: refactor reset_prepare_general retry statement

Jiasheng Jiang (3):
      fsl/fman: Check for null pointer after calling devm_ioremap
      Bluetooth: hci_bcm: Check for error irq
      can: xilinx_can: xcan_probe(): check for error irq

Jie Wang (34):
      net: hns3: debugfs add drop packet statistics of multicast and broadcast for igu
      net: hns3: refactor two hns3 debugfs functions
      net: hns3: refactor function hclge_configure()
      net: hns3: refactor function hclge_set_channels()
      net: hns3: refactor function hns3_get_vector_ring_chain()
      net: hns3: fix hns3 driver header file not self-contained issue
      net: hns3: refactor hns3 makefile to support hns3_common module
      net: hns3: create new cmdq hardware description structure hclge_comm_hw
      net: hns3: use struct hclge_desc to replace hclgevf_desc in VF cmdq module
      net: hns3: create new set of unified hclge_comm_cmd_send APIs
      net: hns3: refactor hclge_cmd_send with new hclge_comm_cmd_send API
      net: hns3: refactor hclgevf_cmd_send with new hclge_comm_cmd_send API
      net: hns3: create common cmdq resource allocate/free/query APIs
      net: hns3: refactor PF cmdq resource APIs with new common APIs
      net: hns3: refactor VF cmdq resource APIs with new common APIs
      net: hns3: create common cmdq init and uninit APIs
      net: hns3: refactor PF cmdq init and uninit APIs with new common APIs
      net: hns3: refactor VF cmdq init and uninit APIs with new common APIs
      net: hns3: delete the hclge_cmd.c and hclgevf_cmd.c
      net: hns3: create new rss common structure hclge_comm_rss_cfg
      net: hns3: refactor hclge_comm_send function in PF/VF drivers
      net: hns3: create new set of common rss get APIs for PF and VF rss module
      net: hns3: refactor PF rss get APIs with new common rss get APIs
      net: hns3: refactor VF rss get APIs with new common rss get APIs
      net: hns3: create new set of common rss set APIs for PF and VF module
      net: hns3: refactor PF rss set APIs with new common rss set APIs
      net: hns3: refactor VF rss set APIs with new common rss set APIs
      net: hns3: create new set of common rss init APIs for PF and VF reuse
      net: hns3: refactor PF rss init APIs with new common rss init APIs
      net: hns3: refactor VF rss init APIs with new common rss init APIs
      net: hns3: create new set of common tqp stats APIs for PF and VF reuse
      net: hns3: refactor PF tqp stats APIs with new common tqp stats APIs
      net: hns3: refactor VF tqp stats APIs with new common tqp stats APIs
      net: hns3: create new common cmd code for PF and VF modules

Jimmy Assarsson (1):
      can: kvaser_usb: make use of units.h in assignment of frequency

Jiri Olsa (9):
      selftests/bpf: Add btf_dedup case with duplicated structs within CU
      bpf: Allow access to int pointer arguments in tracing programs
      selftests/bpf: Add test to access int ptr argument in tracing program
      bpf, x64: Replace some stack_size usage with offset variables
      bpf: Add get_func_[arg|ret|arg_cnt] helpers
      selftests/bpf: Add tests for get_func_[arg|ret|arg_cnt] helpers
      libbpf: Do not use btf_dump__new() macro in C++ mode
      selftests/bpf: Add btf_dump__new to test_cpp
      bpf/selftests: Fix namespace mount setup in tc_redirect

Joakim Zhang (1):
      net: fec: fix system hang during suspend/resume

Joanne Koong (5):
      bpf: Add bpf_loop helper
      selftests/bpf: Add bpf_loop test
      selftests/bpf: Measure bpf_loop verifier performance
      selftest/bpf/benchs: Add bpf_loop benchmark
      net: Enable max_dgram_qlen unix sysctl to be configurable by non-init user namespaces

Johan Hovold (2):
      Bluetooth: bfusb: fix division by zero in send path
      can: softing_cs: softingcs_probe(): fix memleak on registration failure

Johannes Berg (43):
      cfg80211: use ieee80211_bss_get_elem() instead of _get_ie()
      iwlwifi: mvm: fix delBA vs. NSSN queue sync race
      iwlwifi: mvm: synchronize with FW after multicast commands
      iwlwifi: mvm: d3: move GTK rekeys condition
      iwlwifi: mvm: parse firmware alive message version 6
      iwlwifi: mvm: d3: support v12 wowlan status
      iwlwifi: mvm: support RLC configuration command
      iwlwifi: fw: api: add link to PHY context command struct v1
      iwlwifi: mvm: add support for PHY context command v4
      iwlwifi: mvm: add some missing command strings
      iwlwifi: mvm/api: define system control command
      iwlwifi: mvm: always use 4K RB size by default
      iwlwifi: pcie: retake ownership after reset
      iwlwifi: implement reset flow for Bz devices
      iwlwifi: fw: correctly detect HW-SMEM region subtype
      iwlwifi: mvm: optionally suppress assert log
      cfg80211: simplify cfg80211_chandef_valid()
      mac80211: add more HT/VHT/HE state logging
      nl82011: clarify interface combinations wrt. channels
      cfg80211: refactor cfg80211_get_ies_channel_number()
      iwlwifi: mei: fix W=1 warnings
      iwlwifi: mvm: add missing min_size to kernel-doc
      iwlwifi: mvm: add dbg_time_point to debugfs
      iwlwifi: fix Bz NMI behaviour
      iwlwifi: fw: remove dead error log code
      iwlwifi: parse error tables from debug TLVs
      iwlwifi: dump CSR scratch from outer function
      iwlwifi: dump both TCM error tables if present
      iwlwifi: dump RCM error tables
      iwlwifi: mvm: fix 32-bit build in FTM
      iwlwifi: fix debug TLV parsing
      iwlwifi: fix leaks/bad data after failed firmware load
      iwlwifi: mvm: isolate offload assist (checksum) calculation
      iwlwifi: remove module loading failure message
      iwlwifi: mvm: use a define for checksum flags mask
      iwlwifi: mvm: handle RX checksum on Bz devices
      iwlwifi: mvm: don't trust hardware queue number
      iwlwifi: mvm: change old-SN drop threshold
      iwlwifi: mvm: support Bz TX checksum offload
      iwlwifi: mvm: drop too short packets silently
      iwlwifi: mvm: remove card state notification code
      iwlwifi: fw: fix some scan kernel-doc
      mac80211: use ieee80211_bss_get_elem()

John Crispin (2):
      ath11k: add support for BSS color change
      mac80211: notify non-transmitting BSS of color changes

John Efstathiades (6):
      lan78xx: Fix memory allocation bug
      lan78xx: Introduce Tx URB processing improvements
      lan78xx: Introduce Rx URB processing improvements
      lan78xx: Re-order rx_submit() to remove forward declaration
      lan78xx: Remove hardware-specific header update
      lan78xx: Introduce NAPI polling support

John Fastabend (2):
      bpf, sockmap: Fix return codes from tcp_bpf_recvmsg_parser()
      bpf, sockmap: Fix double bpf_prog_put on error case in map_link

Jonas Dreßler (4):
      mwifiex: Use a define for firmware version string length
      mwifiex: Add quirk to disable deep sleep with certain hardware revision
      mwifiex: Ensure the version string from the firmware is 0-terminated
      mwifiex: Ignore BTCOEX events from the 88W8897 firmware

Jonas Jelonek (2):
      ath9k: switch to rate table based lookup
      ath5k: switch to rate table based lookup

Jordan Kim (1):
      gve: Add consumed counts to ethtool stats

Joseph Hwang (2):
      Bluetooth: Add struct of reading AOSP vendor capabilities
      Bluetooth: aosp: Support AOSP Bluetooth Quality Report

José Expósito (1):
      net: prestera: replace zero-length array with flexible-array member

Julian Wiedmann (6):
      s390/qeth: allocate RX queue at probe time
      s390/qeth: simplify qeth_receive_skb()
      s390/qeth: split up L2 netdev_ops
      s390/qeth: don't offer .ndo_bridge_* ops for OSA devices
      s390/qeth: fine-tune .ndo_select_queue()
      s390/qeth: remove check for packing mode in qeth_check_outbound_queue()

Justin Iurman (1):
      ipv6: ioam: Support for Queue depth data field

KP Singh (2):
      bpf: Allow bpf_local_storage to be used by sleepable programs
      bpf/selftests: Update local storage selftest for sleepable programs

Kai-Heng Feng (3):
      rtw88: Disable PCIe ASPM while doing NAPI poll on 8821CE
      net: wwan: iosm: Let PCI core handle PCI power transition
      net: wwan: iosm: Keep device at D0 for s2idle case

Kajol Jain (1):
      bpf: Remove config check to enable bpf support for branch records

Kalle Valo (11):
      ath11k: convert ath11k_wmi_pdev_set_ps_mode() to use enum wmi_sta_ps_mode
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Revert "ath11k: add read variant from SMBIOS for download board data"
      ath10k: htt: remove array of flexible structures
      ath10k: wmi: remove array of flexible structures
      ath11k: add ab to TARGET_NUM_VDEVS & co
      Merge tag 'iwlwifi-next-for-kalle-2021-12-08' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge tag 'mt76-for-kvalo-2021-12-18' of https://github.com/nbd168/wireless
      Merge tag 'iwlwifi-next-for-kalle-2021-12-21-v2' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Karen Sornek (5):
      iavf: Fix static code analysis warning
      iavf: Refactor text of informational message
      iavf: Refactor string format to avoid static analysis warnings
      igbvf: Refactor trace
      i40e: Add ensurance of MacVlan resources for every trusted VF

Karol Kolacinski (1):
      ice: Fix E810 PTP reset flow

Karthikeyan Kathirvel (2):
      ath11k: clear the keys properly via DISABLE_KEY
      ath11k: reset RSN/WPA present state for open BSS

Karthikeyan Periyasamy (4):
      ath11k: fix fw crash due to peer get authorized before key install
      ath11k: fix error routine when fallback of add interface fails
      ath11k: avoid unnecessary BH disable lock in STA kickout event
      ath11k: fix DMA memory free in CE pipe cleanup

Kees Cook (23):
      cxgb3: Use struct_group() for memcpy() region
      cxgb4: Use struct_group() for memcpy() region
      bnx2x: Use struct_group() for memcpy() region
      net: dccp: Use memset_startat() for TP zeroing
      net: 802: Use memset_startat() to clear struct fields
      ipv6: Use memset_after() to zero rt6_info
      net/af_iucv: Use struct_group() to zero struct iucv_sock region
      ethtool: stats: Use struct_group() to clear all stats at once
      skbuff: Move conditional preprocessor directives out of struct sk_buff
      skbuff: Switch structure bounds to struct_group()
      ath11k: Use memset_startat() for clearing queue descriptors
      mac80211: Use memset_after() to clear tx status
      libertas: Use struct_group() for memcpy() region
      libertas_tf: Use struct_group() for memcpy() region
      intersil: Use struct_group() for memcpy() region
      mwl8k: Use named struct for memcpy() region
      rtlwifi: rtl8192de: Style clean-ups
      netfilter: conntrack: Use memset_startat() to zero struct nf_conn
      hv_sock: Extract hvs_send_data() helper that takes only header
      libertas: Add missing __packed annotation with struct_group()
      libertas_tf: Add missing __packed annotations
      ath6kl: Use struct_group() to avoid size-mismatched casting
      skbuff: Extract list pointers to silence compiler warnings

Kevin Bracey (1):
      sch_cake: revise Diffserv docs

Kiran K (2):
      Bluetooth: Read codec capabilities only if supported
      Bluetooth: btintel: Fix bdaddress comparison with garbage value

Kiran Patil (1):
      ice: Add flow director support for channel mode

Kris Van Hees (1):
      bpf: Fix verifier support for validation of async callbacks

Kui-Feng Lee (4):
      selftests/bpf: Stop using bpf_object__find_program_by_title API.
      samples/bpf: Stop using bpf_object__find_program_by_title API.
      tools/perf: Stop using bpf_object__find_program_by_title API.
      libbpf: Mark bpf_object__find_program_by_title API deprecated.

Kumar Kartikeya Dwivedi (5):
      libbpf: Compile using -std=gnu89
      bpf: Change bpf_kallsyms_lookup_name size type to ARG_CONST_SIZE_OR_ZERO
      libbpf: Avoid double stores for success/failure case of ksym relocations
      libbpf: Avoid reload of imm for weak, unresolved, repeating ksym
      bpf: Extend kfunc with PTR_TO_CTX, PTR_TO_MEM argument support

Kuniyuki Iwashima (18):
      dccp/tcp: Remove an unused argument in inet_csk_listen_start().
      dccp: Inline dccp_listen_start().
      af_unix: Use offsetof() instead of sizeof().
      af_unix: Pass struct sock to unix_autobind().
      af_unix: Factorise unix_find_other() based on address types.
      af_unix: Return an error as a pointer in unix_find_other().
      af_unix: Cut unix_validate_addr() out of unix_mkname().
      af_unix: Copy unix_mkname() into unix_find_(bsd|abstract)().
      af_unix: Remove unix_mkname().
      af_unix: Allocate unix_address in unix_bind_(bsd|abstract)().
      af_unix: Remove UNIX_ABSTRACT() macro and test sun_path[0] instead.
      af_unix: Add helpers to calculate hashes.
      af_unix: Save hash in sk_hash.
      af_unix: Replace the big lock with small locks.
      af_unix: Relax race in unix_autobind().
      sock: Use sock_owned_by_user_nocheck() instead of sk_lock.owned.
      bpf: Fix SO_RCVBUF/SO_SNDBUF handling in _bpf_setsockopt().
      bpf: Add SO_RCVBUF/SO_SNDBUF in _bpf_getsockopt().

Kurt Kanzenbach (6):
      net: ethernet: ti: cpsw: Enable PHY timestamping
      net: stmmac: Calculate CDC error only once
      net: dsa: hellcreek: Fix insertion of static FDB entries
      net: dsa: hellcreek: Add STP forwarding rule
      net: dsa: hellcreek: Allow PTP P2P measurements on blocked ports
      net: dsa: hellcreek: Add missing PTP via UDP rules

Kyle Copperfield (1):
      Bluetooth: btsdio: Do not bind to non-removable BCM4345 and BCM43455

Lad Prabhakar (9):
      ethernet: netsec: Use platform_get_irq() to get the interrupt
      net: pxa168_eth: Use platform_get_irq() to get the interrupt
      fsl/fman: Use platform_get_irq() to get the interrupt
      net: ethoc: Use platform_get_irq() to get the interrupt
      net: xilinx: emaclite: Use platform_get_irq() to get the interrupt
      net: ethernet: ti: davinci_emac: Use platform_get_irq() to get the interrupt
      can: ti_hecc: ti_hecc_probe(): use platform_get_irq() to get the interrupt
      can: sja1000: sp_probe(): use platform_get_irq() to get the interrupt
      can: rcar_canfd: rcar_canfd_channel_probe(): make sure we free CAN network device

Lama Kayal (2):
      net/mlx5e: Allocate per-channel stats dynamically at first usage
      net/mlx5e: Expose FEC counters via ethtool

Larry Finger (2):
      Bluetooth: btusb: Add one more Bluetooth part for the Realtek RTL8852AE
      rtlwifi: rtl8192cu: Fix WARNING when calling local_irq_restore() with interrupts enabled

Leon Huayra (1):
      bpf: Fix typo in a comment in bpf lpm_trie.

Leon Romanovsky (2):
      devlink: Remove misleading internal_flags from health reporter dump
      devlink: Simplify devlink resources unregister call

Li Zhijian (1):
      selftests: net: remove meaningless help option

Linus Lüssing (1):
      batman-adv: allow netlink usage in unprivileged containers

Linus Walleij (2):
      dt-bindings: net: Add bindings for IXP4xx V.35 WAN HSS
      net: ixp4xx_hss: Convert to use DT probing

Loic Poulain (4):
      wcn36xx: Use correct SSN for ADD BA request
      brcmfmac: Configure keep-alive packet on suspend
      wcn36xx: Fix max channels retrieval
      brcmfmac: Fix incorrect type assignments for keep-alive

Lorenzo Bianconi (34):
      cfg80211: implement APIs for dedicated radar detection HW
      mac80211: introduce set_radar_offchan callback
      cfg80211: move offchan_cac_event to a dedicated work
      cfg80211: fix possible NULL pointer dereference in cfg80211_stop_offchan_radar_detection
      cfg80211: schedule offchan_cac_abort_wk in cfg80211_radar_event
      cfg80211: allow continuous radar monitoring on offchannel chain
      net: mtk_eth: add COMPILE_TEST support
      mt76: mt7915: get rid of mt7915_mcu_set_fixed_rate routine
      mt76: debugfs: fix queue reporting for mt76-usb
      mt76: fix possible OOB issue in mt76_calculate_default_rate
      mt76: mt7921: fix possible NULL pointer dereference in mt7921_mac_write_txwi
      mt76: connac: fix a theoretical NULL pointer dereference in mt76_connac_get_phy_mode
      mt76: mt7615: remove dead code in get_omac_idx
      mt76: connac: remove PHY_MODE_AX_6G configuration in mt76_connac_get_phy_mode
      mt76: mt7921: honor mt76_connac_mcu_set_rate_txpower return value in mt7921_config
      mt76: move sar utilities to mt76-core module
      mt76: mt76x02: introduce SAR support
      mt76: mt7603: introduce SAR support
      mt76: mt7915: introduce SAR support
      mt76: connac: fix last_chan configuration in mt76_connac_mcu_rate_txpower_band
      mt76: move sar_capa configuration in common code
      mt76: mt7663: disable 4addr capability
      mt76: connac: introduce MCU_EXT macros
      mt76: connac: align MCU_EXT definitions with 7915 driver
      mt76: connac: remove MCU_FW_PREFIX bit
      mt76: connac: introduce MCU_UNI_CMD macro
      mt76: connac: introduce MCU_CE_CMD macro
      mt76: connac: rely on MCU_CMD macro
      mt76: mt7915: rely on mt76_connac definitions
      mt76: mt7915: introduce mt76_vif in mt7915_vif
      mt76: mt7921: remove dead definitions
      mt76: connac: rely on le16_add_cpu in mt76_connac_mcu_add_nested_tlv
      cfg80211: rename offchannel_chain structs to background_chain to avoid confusion with ETSI standard
      mt76: mt7921: fix a possible race enabling/disabling runtime-pm

Luca Coelho (8):
      iwlwifi: remove unused iwlax210_2ax_cfg_so_hr_a0 structure
      iwlwifi: add missing entries for Gf4 with So and SoF
      iwlwifi: bump FW API to 68 for AX devices
      iwlwifi: mvm: fix imbalanced locking in iwl_mvm_start_get_nvm()
      iwlwifi: recognize missing PNVM data and then log filename
      iwlwifi: don't pass actual WGDS revision number in table_revision
      iwlwifi: bump FW API to 69 for AX devices
      iwlwifi: pcie: make sure prph_info is set when treating wakeup IRQ

Luiz Angelo Daros de Luca (1):
      net: dsa: rtl8365mb: add GMII as user port mode

Luiz Augusto von Dentz (55):
      Bluetooth: hci_vhci: Fix calling hci_{suspend,resume}_dev
      Bluetooth: Fix handling of SUSPEND_DISCONNECTING
      Bluetooth: L2CAP: Fix not initializing sk_peer_pid
      Bluetooth: vhci: Add support for setting msft_opcode and aosp_capable
      Bluetooth: vhci: Fix checking of msft_opcode
      Bluetooth: hci_sync: Make use of hci_cmd_sync_queue set 1
      Bluetooth: hci_sync: Make use of hci_cmd_sync_queue set 2
      Bluetooth: hci_sync: Make use of hci_cmd_sync_queue set 3
      Bluetooth: hci_sync: Enable advertising when LL privacy is enabled
      Bluetooth: hci_sync: Rework background scan
      Bluetooth: hci_sync: Convert MGMT_SET_POWERED
      Bluetooth: hci_sync: Convert MGMT_OP_START_DISCOVERY
      Bluetooth: hci_sync: Rework init stages
      Bluetooth: hci_sync: Rework hci_suspend_notifier
      Bluetooth: hci_sync: Fix missing static warnings
      Bluetooth: hci_sync: Fix not setting adv set duration
      Bluetooth: hci_sync: Convert MGMT_OP_SET_DISCOVERABLE to use cmd_sync
      Bluetooth: hci_sync: Convert MGMT_OP_SET_CONNECTABLE to use cmd_sync
      Bluetooth: hci_request: Remove bg_scan_update work
      Bluetooth: HCI: Fix definition of hci_rp_read_stored_link_key
      Bluetooth: HCI: Fix definition of hci_rp_delete_stored_link_key
      skbuff: introduce skb_pull_data
      Bluetooth: HCI: Use skb_pull_data to parse BR/EDR events
      Bluetooth: HCI: Use skb_pull_data to parse Command Complete event
      Bluetooth: HCI: Use skb_pull_data to parse Number of Complete Packets event
      Bluetooth: HCI: Use skb_pull_data to parse Inquiry Result event
      Bluetooth: HCI: Use skb_pull_data to parse Inquiry Result with RSSI event
      Bluetooth: HCI: Use skb_pull_data to parse Extended Inquiry Result event
      Bluetooth: HCI: Use skb_pull_data to parse LE Metaevents
      Bluetooth: HCI: Use skb_pull_data to parse LE Advertising Report event
      Bluetooth: HCI: Use skb_pull_data to parse LE Ext Advertising Report event
      Bluetooth: HCI: Use skb_pull_data to parse LE Direct Advertising Report event
      Bluetooth: hci_event: Use of a function table to handle HCI events
      Bluetooth: hci_event: Use of a function table to handle LE subevents
      Bluetooth: hci_event: Use of a function table to handle Command Complete
      Bluetooth: hci_event: Use of a function table to handle Command Status
      Bluetooth: MGMT: Use hci_dev_test_and_{set,clear}_flag
      Bluetooth: hci_core: Rework hci_conn_params flags
      Bluetooth: btusb: Add support for queuing during polling interval
      Bluetooth: Introduce HCI_CONN_FLAG_DEVICE_PRIVACY device flag
      Bluetooth: hci_sync: Set Privacy Mode when updating the resolving list
      Bluetooth: msft: Fix compilation when CONFIG_BT_MSFTEXT is not set
      Bluetooth: mgmt: Introduce mgmt_alloc_skb and mgmt_send_event_skb
      Bluetooth: mgmt: Make use of mgmt_send_event_skb in MGMT_EV_DEVICE_FOUND
      Bluetooth: mgmt: Make use of mgmt_send_event_skb in MGMT_EV_DEVICE_CONNECTED
      Bluetooth: hci_sync: Fix not always pausing advertising when necessary
      Bluetooth: L2CAP: Fix using wrong mode
      Bluetooth: hci_event: Use skb_pull_data when processing inquiry results
      Bluetooth: hci_sync: Add hci_le_create_conn_sync
      Bluetooth: hci_sync: Add support for waiting specific LE subevents
      Bluetooth: hci_sync: Wait for proper events when connecting LE
      Bluetooth: hci_sync: Add check simultaneous roles support
      Bluetooth: MGMT: Fix LE simultaneous roles UUID if not supported
      Bluetooth: vhci: Set HCI_QUIRK_VALID_LE_STATES
      Bluetooth: hci_event: Rework hci_inquiry_result_with_rssi_evt

Lukas Bulwahn (1):
      net: remove references to CONFIG_IRDA in network header files

Lv Ruyi (1):
      net: mscc: ocelot: fix mutex_lock not released

Lv Yunlong (1):
      wireless: iwlwifi: Fix a double free in iwl_txq_dyn_alloc_dma

M Chetan Kumar (7):
      net: wwan: common debugfs base dir for wwan device
      net: wwan: iosm: device trace collection using relayfs
      net: wwan: iosm: set tx queue len
      net: wwan: iosm: release data channel in case no active IP session
      net: wwan: iosm: removed unused function decl
      net: wwan: iosm: correct open parenthesis alignment
      Revert "net: wwan: iosm: Keep device at D0 for s2idle case"

Maciej Fijalkowski (1):
      xsk: Wipe out dead zero_copy_allocator declarations

Maciej Żenczykowski (4):
      net: allow CAP_NET_RAW to setsockopt SO_PRIORITY
      net: allow SO_MARK with CAP_NET_RAW
      net-ipv6: do not allow IPV6_TCLASS to muck with tcp's ECN
      net-ipv6: changes to ->tclass (via IPV6_TCLASS) should sk_dst_reset()

Maher Sanalla (1):
      net/mlx5: Update log_max_qp value to FW max capability

Manish Chopra (4):
      qed*: enhance tx timeout debug info
      qed*: esl priv flag support through ethtool
      bnx2x: Utilize firmware 7.13.21.0
      bnx2x: Invalidate fastpath HSI version for VFs

Maor Dickman (4):
      net/mlx5e: Unblock setting vid 0 for VF in case PF isn't eswitch manager
      net/mlx5e: Fix wrong usage of fib_info_nh when routes with nexthop objects are used
      net/mlx5e: Don't block routes with nexthop objects in SW
      net/mlx5e: Sync VXLAN udp ports during uplink representor profile change

Maor Gottlieb (4):
      net/mlx5: Separate FDB namespace
      net/mlx5: Refactor mlx5_get_flow_namespace
      net/mlx5: Create more priorities for FDB bypass namespace
      RDMA/mlx5: Add support to multiple priorities for FDB rules

Marc Kleine-Budde (21):
      can: usb_8dev: remove unused member echo_skb from struct usb_8dev_priv
      can: gs_usb: fix use of uninitialized variable, detach device on reception of invalid USB data
      can: isotp: convert struct tpcon::{idx,len} to unsigned int
      can: mcp251xfd: remove double blank lines
      can: mcp251xfd: mcp251xfd_tef_obj_read(): fix typo in error message
      can: mcp251xfd: add missing newline to printed strings
      can: mcp251xfd: mcp251xfd_open(): open_candev() first
      can: mcp251xfd: mcp251xfd_open(): make use of pm_runtime_resume_and_get()
      can: mcp251xfd: mcp251xfd_handle_rxovif(): denote RX overflow message to debug + add rate limiting
      can: mcp251xfd: mcp251xfd.h: sort function prototypes
      can: mcp251xfd: move RX handling into separate file
      can: mcp251xfd: move TX handling into separate file
      can: mcp251xfd: move TEF handling into separate file
      can: mcp251xfd: move chip FIFO init into separate file
      can: mcp251xfd: move ring init into separate function
      can: mcp251xfd: introduce and make use of mcp251xfd_is_fd_mode()
      can: flexcan: move driver into separate sub directory
      can: flexcan: rename RX modes
      can: flexcan: add more quirks to describe RX path capabilities
      can: flexcan: add ethtool support to change rx-rtr setting during runtime
      can: softing: softing_startstop(): fix set but not used variable warning

Marcel Holtmann (1):
      Bluetooth: Add helper for serialized HCI command execution

Marek Behún (2):
      phy: marvell: phy-mvebu-cp110-comphy: add support for 5gbase-r
      net: marvell: mvpp2: Add support for 5gbase-r

Mark Chen (2):
      Bluetooth: btusb: Handle download_firmware failure cases
      Bluetooth: btusb: Return error code when getting patch status failed

Mark Pashmfouroush (2):
      bpf: Add ingress_ifindex to bpf_sk_lookup
      selftests/bpf: Add tests for accessing ingress_ifindex in bpf_sk_lookup

Mark-YW.Chen (1):
      Bluetooth: btusb: fix memory leak in btusb_mtk_submit_wmt_recv_urb()

Mark-yw Chen (1):
      Bluetooth: btmtksdio: transmit packet according to status TX_EMPTY

Martin Blumenstingl (1):
      mac80211: Add stations iterator where the iterator function may sleep

Mat Martineau (1):
      mptcp: Check reclaim amount before reducing allocation

Mateusz Palczewski (2):
      i40e: Update FW API version
      i40e: Remove non-inclusive language

Matt Johnston (7):
      i2c: core: Allow 255 byte transfers for SMBus 3.x
      i2c: dev: Handle 255 byte blocks for i2c ioctl
      i2c: aspeed: Allow 255 byte block transfers
      i2c: npcm7xx: Allow 255 byte block SMBus transfers
      dt-bindings: net: New binding mctp-i2c-controller
      mctp i2c: MCTP I2C binding driver
      mctp: emit RTM_NEWADDR and RTM_DELADDR

Matthieu Baerts (1):
      mptcp: fix opt size when sending DSS + MP_FAIL

Matti Gottlieb (2):
      iwlwifi: Fix FW name for gl
      iwlwifi: Read the correct addresses when getting the crf id

Max Filippov (1):
      net: natsemi: fix hw address initialization for jazz and xtensa

Maxim Galaganov (3):
      tcp: expose __tcp_sock_set_cork and __tcp_sock_set_nodelay
      mptcp: expose mptcp_check_and_set_pending
      mptcp: support TCP_CORK and TCP_NODELAY

Maxim Mikityanskiy (1):
      bpf: Fix the test_task_vma selftest to support output shorter than 1 kB

Maxime Chevallier (4):
      net: mvneta: Use struct tc_mqprio_qopt_offload for MQPrio configuration
      net: mvneta: Don't force-set the offloading flag
      net: mvneta: Allow having more than one queue per TC
      net: mvneta: Add TC traffic shaping offload

Mehrdad Arshad Rad (1):
      libbpf: Remove duplicate assignments

MeiChia Chiu (1):
      mt76: mt7915: add mu-mimo and ofdma debugfs knobs

Menglong Dong (7):
      net: snmp: add statistics for tcp small queue check
      net: bpf: Handle return value of BPF_CGROUP_RUN_PROG_INET{4,6}_POST_BIND()
      bpf: selftests: Use C99 initializers in test_sock.c
      bpf: selftests: Add bind retry for post_bind{4, 6}
      net: skb: introduce kfree_skb_reason()
      net: skb: use kfree_skb_reason() in tcp_v4_rcv()
      net: skb: use kfree_skb_reason() in __udp4_lib_rcv()

Merlijn Wajer (1):
      wl1251: specify max. IE length

Miaoqian Lin (1):
      Bluetooth: hci_qca: Fix NULL vs IS_ERR_OR_NULL check in qca_serdev_probe

Michael Chan (3):
      bnxt_en: Log error report for dropped doorbell
      bnxt_en: Support configurable CQE coalescing mode
      bnxt_en: Support CQE coalescing mode in ethtool

Mike Golant (4):
      iwlwifi: support 4-bits in MAC step value
      iwlwifi: add support for Bz-Z HW
      iwlwifi: pcie: add jacket bit to device configuration parsing
      iwlwifi: add support for BNJ HW

Minghao Chi (3):
      samples/bpf: Remove unneeded variable
      batman-adv: remove unneeded variable in batadv_nc_init
      ethernet/sfc: remove redundant rc variable

Miri Korenblit (5):
      ieee80211: change HE nominal packet padding value defines
      iwlwifi: acpi: fix wgds rev 3 size
      iwlwifi: mvm: support revision 1 of WTAS table
      iwlwifi: mvm: always store the PPAG table as the latest version.
      iwlwifi: mvm: add US/CA to TAS block list if OEM isn't allowed

Miroslav Lichvar (2):
      testptp: set pin function before other requests
      net: fix SOF_TIMESTAMPING_BIND_PHC to work with multiple sockets

Mordechay Goodstein (5):
      iwlwifi: mvm: add support for statistics update version 15
      iwlwifi: mvm: update rate scale in moving back to assoc state
      iwlwifi: fw: add support for splitting region type bits
      iwlwifi: rs: add support for TLC config command ver 4
      iwlwifi: return op_mode only in case the failure is from MEI

Moshe Shemesh (2):
      net/mlx5: Set command entry semaphore up once got index free
      Revert "net/mlx5: Add retry mechanism to the command entry index allocation"

Muhammad Sammar (5):
      net/mlx5: DR, Add missing reserved fields to dr_match_param
      net/mlx5: DR, Add support for dumping steering info
      net/mlx5: Add misc5 flow table match parameters
      net/mlx5: DR, Add misc5 to match_param structs
      net/mlx5: DR, Support matching on tunnel headers 0 and 1

Mukesh Sisodiya (4):
      iwlwifi: yoyo: support for DBGC4 for dram
      iwlwifi: dbg: disable ini debug in 8000 family and below
      iwlwifi: yoyo: support TLV-based firmware reset
      iwlwifi: yoyo: fix issue with new DBGI_SRAM region read.

Nathan Chancellor (1):
      iwlwifi: mvm: Use div_s64 instead of do_div in iwl_mvm_ftm_rtt_smoothing()

Nathan Errera (2):
      mac80211: introduce channel switch disconnect function
      iwlwifi: mvm: test roc running status bits before removing the sta

Nguyen Dinh Phi (1):
      Bluetooth: hci_sock: purge socket queues in the destruct() callback

Nicolas Dichtel (1):
      xfrm: fix dflt policy check when there is no policy configured

Nikolay Aleksandrov (12):
      selftests: net: bridge: add vlan mcast snooping control test
      selftests: net: bridge: add vlan mcast querier test
      selftests: net: bridge: add vlan mcast igmp/mld version tests
      selftests: net: bridge: add vlan mcast_last_member_count/interval tests
      selftests: net: bridge: add vlan mcast_startup_query_count/interval tests
      selftests: net: bridge: add vlan mcast_membership_interval test
      selftests: net: bridge: add vlan mcast_querier_interval tests
      selftests: net: bridge: add vlan mcast query and query response interval tests
      selftests: net: bridge: add vlan mcast_router tests
      selftests: net: bridge: add test for vlan_filtering dependency
      net: nexthop: reduce rcu synchronizations when replacing resilient groups
      net: ipv6: use the new fib6_nh_release_dsts helper in fib6_nh_release

Ong Boon Leong (10):
      net: stmmac: enhance XDP ZC driver level switching performance
      net: stmmac: perserve TX and RX coalesce value during XDP setup
      net: stmmac: add tc flower filter for EtherType matching
      samples/bpf: xdpsock: Add VLAN support for Tx-only operation
      samples/bpf: xdpsock: Add Dest and Src MAC setting for Tx-only operation
      samples/bpf: xdpsock: Add clockid selection support
      samples/bpf: xdpsock: Add cyclic TX operation capability
      samples/bpf: xdpsock: Add sched policy and priority support
      samples/bpf: xdpsock: Add time-out for cleaning Tx
      samples/bpf: xdpsock: Add timestamp for Tx-only operation

P Praneesh (17):
      ath11k: disable unused CE8 interrupts for ipq8074
      ath11k: allocate dst ring descriptors from cacheable memory
      ath11k: modify dp_rx desc access wrapper calls inline
      ath11k: avoid additional access to ath11k_hal_srng_dst_num_free
      ath11k: avoid active pdev check for each msdu
      ath11k: remove usage quota while processing rx packets
      ath11k: add branch predictors in process_rx
      ath11k: allocate HAL_WBM2SW_RELEASE ring from cacheable memory
      ath11k: remove mod operator in dst ring processing
      ath11k: avoid while loop in ring selection of tx completion interrupt
      ath11k: add branch predictors in dp_tx path
      ath11k: avoid unnecessary lock contention in tx_completion path
      ath11k: fix FCS_ERR flag in radio tap header
      ath11k: send proper txpower and maxregpower values to firmware
      ath11k: Increment pending_mgmt_tx count before tx send invoke
      ath11k: Disabling credit flow for WMI path
      mac80211: fix FEC flag in radio tap header

Pablo Neira Ayuso (21):
      netfilter: nft_fwd_netdev: Support egress hook
      netfilter: nf_tables: remove rcu read-size lock
      netfilter: nft_payload: WARN_ON_ONCE instead of BUG
      netfilter: nf_tables: consolidate rule verdict trace call
      netfilter: nf_tables: replace WARN_ON by WARN_ON_ONCE for unknown verdicts
      netfilter: nf_tables: make counter support built-in
      netfilter: nft_payload: do not update layer 4 checksum when mangling fragments
      netfilter: nft_connlimit: move stateful fields out of expression data
      netfilter: nft_last: move stateful fields out of expression data
      netfilter: nft_quota: move stateful fields out of expression data
      netfilter: nft_numgen: move stateful fields out of expression data
      netfilter: nft_limit: rename stateful structure
      netfilter: nft_limit: move stateful fields out of expression data
      netfilter: nf_tables: add rule blob layout
      netfilter: nf_tables: add NFT_REG32_NUM
      netfilter: nf_tables: add register tracking infrastructure
      netfilter: nft_payload: track register operations
      netfilter: nft_meta: track register operations
      netfilter: nft_bitwise: track register operations
      netfilter: nft_payload: cancel register tracking after payload update
      netfilter: nft_meta: cancel register tracking after meta update

Panicker Harish (1):
      Bluetooth: hci_qca: Stop IBS timer during BT OFF

Paolo Abeni (17):
      bpf: Do not WARN in bpf_warn_invalid_xdp_action()
      bpf: Let bpf_warn_invalid_xdp_action() report more info
      mptcp: enforce HoL-blocking estimation
      mptcp: keep snd_una updated for fallback socket
      mptcp: implement fastclose xmit path
      mptcp: full disconnect implementation
      mptcp: cleanup accept and poll
      mptcp: implement support for user-space disconnect
      selftests: mptcp: add disconnect tests
      mptcp: fix per socket endpoint accounting
      mptcp: clean-up MPJ option writing
      mptcp: keep track of local endpoint still available for each msk
      mptcp: do not block subflows creation on errors
      selftests: mptcp: add tests for subflow creation failure
      mptcp: cleanup MPJ subflow list handling
      mptcp: avoid atomic bit manipulation when possible
      selftests: mptcp: more stable join tests-cases

Parav Pandit (3):
      net/mlx5: E-switch, Remove vport enabled check
      net/mlx5: E-switch, Reuse mlx5_eswitch_set_vport_mac
      net/mlx5: E-switch, move offloads mode callbacks to offloads file

Patryk Małek (1):
      iavf: Add change MTU message

Paul Blakey (7):
      net/mlx5e: Refactor mod header management API
      net/mlx5: CT: Allow static allocation of mod headers
      net/sched: act_ct: Fill offloading tuple iifidx
      net: openvswitch: Fill act ct extension
      net/mlx5: CT: Set flow source hint from provided tuple device
      net/mlx5e: Fix matching on modified inner ip_ecn bits
      net: openvswitch: Fix ct_state nat flags for conns arriving from tc

Paul Cercueil (1):
      Bluetooth: hci_bcm: Remove duplicated entry in OF table

Paul Chaignon (4):
      bpftool: Enable line buffering for stdout
      bpftool: Refactor misc. feature probe
      bpftool: Probe for bounded loop support
      bpftool: Probe for instruction set extensions

Paul E. McKenney (1):
      selftests/bpf: Update test names for xchg and cmpxchg

Pavel Skripkin (2):
      Bluetooth: stop proccessing malicious adv data
      net: mcs7830: handle usb read errors properly

Peng Li (2):
      net: hns3: extract macro to simplify ring stats update code
      net: hns3: refactor function hns3_fill_skb_desc to simplify code

Peter Chiu (1):
      mt76: mt7615: fix possible deadlock while mt7615_register_ext_phy()

Peter Oh (1):
      ath: regdom: extend South Korea regulatory domain support

Peter Seiderer (2):
      ath9k: fix intr_txqs setting
      mac80211: minstrel_ht: remove unused SAMPLE_SWITCH_THR define

Ping-Ke Shih (8):
      rtw89: fix potentially access out of range of RF register array
      rtw88: add quirk to disable pci caps on HP 250 G7 Notebook PC
      rtw89: add const in the cast of le32_get_bits()
      rtw89: use inline function instead macro to set H2C and CAM
      rtw89: update scan_mac_addr during scanning period
      rtw89: fix sending wrong rtwsta->mac_id to firmware to fill address CAM
      rtw89: don't kick off TX DMA if failed to write skb
      mac80211: allow non-standard VHT MCS-10/11

Po Hao Huang (1):
      rtw89: fix incorrect channel info during scan

Po-Hao Huang (2):
      rtw88: 8822c: update rx settings to prevent potential hw deadlock
      rtw88: 8822c: add ieee80211_ops::hw_scan

Poorva Sonparote (2):
      ipv4: Exposing __ip_sock_set_tos() in ip.h
      mptcp: Support for IP_TOS for MPTCP setsockopt()

Prabhakar Kushwaha (1):
      qed: Enhance rammod debug prints to provide pretty details

Pu Lehui (1):
      selftests/bpf: Correct the INDEX address in vmtest.sh

Qiang Wang (2):
      libbpf: Use probe_name for legacy kprobe
      libbpf: Support repeated legacy kprobes on same function

Quentin Monnet (9):
      bpftool: Fix SPDX tag for Makefiles and .gitignore
      bpftool: Fix memory leak in prog_dump()
      bpftool: Remove inclusion of utilities.mak from Makefiles
      bpftool: Fix indent in option lists in the documentation
      bpftool: Update the lists of names for maps and prog-attach types
      bpftool: Fix mixed indentation in documentation
      bpftool: Add SPDX tags to RST documentation files
      bpftool: Update doc (use susbtitutions) and test_bpftool_synctypes.py
      selftests/bpf: Configure dir paths via env in test_bpftool_synctypes.py

Radoslaw Tyl (5):
      ixgbevf: Rename MSGTYPE to SUCCESS and FAILURE
      ixgbevf: Improve error handling in mailbox
      ixgbevf: Add legacy suffix to old API mailbox functions
      ixgbevf: Mailbox improvements
      ixgbevf: Add support for new mailbox communication between PF and VF

Radu Pirea (NXP OSS) (1):
      phy: nxp-c45-tja11xx: add extts and perout support

Raed Salem (1):
      net/xfrm: IPsec tunnel mode fix inner_ipproto setting in sec_path

Rafał Miłecki (2):
      of: net: support NVMEM cells with MAC in text format
      net: dsa: bcm_sf2: refactor LED regs access

Rahul Lakkireddy (1):
      cxgb4: allow reading unrecognized port module eeprom

Raju Rangoju (3):
      net: amd-xgbe: Add Support for Yellow Carp Ethernet device
      net: amd-xgbe: Alter the port speed bit range
      net: amd-xgbe: Disable the CDR workaround path for Yellow Carp Devices

Rakesh Babu Saladi (1):
      octeontx2-nicvf: Free VF PTP resources.

Rameshkumar Sundaram (4):
      ath11k: Send PPDU_STATS_CFG with proper pdev mask to firmware
      ath11k: Clear auth flag only for actual association in security mode
      ath11k: use cache line aligned buffers for dbring
      ath11k: Fix deleting uninitialized kernel timer during fragment cache flush

Randy Dunlap (2):
      Bluetooth: btmrvl_main: repair a non-kernel-doc comment
      net: wan/lmc: fix spelling of "its"

Remi Pommarel (1):
      net: bridge: Get SIOCGIFBR/SIOCSIFBR ioctl working in compat mode

Riccardo Paolo Bestetti (1):
      ipv4/raw: support binding to nonlocal addresses

Robert-Ionut Alexa (1):
      dpaa2-mac: bail if the dpmacs fwnode is not found

Roi Dayan (25):
      net/mlx5e: TC, Destroy nic flow counter if exists
      net/mlx5e: TC, Move kfree() calls after destroying all resources
      net/mlx5e: TC, Move comment about mod header flag to correct place
      net/mlx5e: TC, Remove redundant action stack var
      net/mlx5e: Remove redundant actions arg from validate_goto_chain()
      net/mlx5e: Remove redundant actions arg from vlan push/pop funcs
      net/mlx5e: TC, Move common flow_action checks into function
      net/mlx5e: TC, Set flow attr ip_version earlier
      net/mlx5e: Add tc action infrastructure
      net/mlx5e: Add goto to tc action infra
      net/mlx5e: Add tunnel encap/decap to tc action infra
      net/mlx5e: Add csum to tc action infra
      net/mlx5e: Add pedit to tc action infra
      net/mlx5e: Add vlan push/pop/mangle to tc action infra
      net/mlx5e: Add mpls push/pop to tc action infra
      net/mlx5e: Add mirred/redirect to tc action infra
      net/mlx5e: Add ct to tc action infra
      net/mlx5e: Add sample and ptype to tc_action infra
      net/mlx5e: Add redirect ingress to tc action infra
      net/mlx5e: TC action parsing loop
      net/mlx5e: Move sample attr allocation to tc_action sample parse op
      net/mlx5e: Add post_parse() op to tc action infrastructure
      net/mlx5e: Move vlan action chunk into tc action vlan post parse op
      net/mlx5e: Move goto action checks into tc_action goto post parse op
      net/mlx5e: TC, Remove redundant error logging

Russell King (7):
      arm64/bpf: Remove 128MB limit for BPF JIT programs
      net: ag71xx: populate supported_interfaces member
      net: dpaa2-mac: populate supported_interfaces member
      net: phylink: tidy up disable bit clearing
      net: mvneta: program 1ms autonegotiation clock divisor
      net: mvneta: convert to use mac_prepare()/mac_finish()
      net: mvneta: convert to phylink pcs operations

Russell King (Oracle) (50):
      net: phylink: add generic validate implementation
      net: mvneta: use phylink_generic_validate()
      net: mvpp2: use phylink_generic_validate()
      net: document SMII and correct phylink's new validation mechanism
      net: axienet: populate supported_interfaces member
      net: axienet: remove interface checks in axienet_validate()
      net: axienet: use phylink_generic_validate()
      net: enetc: populate supported_interfaces member
      net: enetc: remove interface checks in enetc_pl_mac_validate()
      net: enetc: use phylink_generic_validate()
      net: sparx5: populate supported_interfaces member
      net: sparx5: clean up sparx5_phylink_validate()
      net: sparx5: use phylink_generic_validate()
      net: mtk_eth_soc: populate supported_interfaces member
      net: mtk_eth_soc: remove interface checks in mtk_validate()
      net: mtk_eth_soc: drop use of phylink_helper_basex_speed()
      net: mtk_eth_soc: use phylink_generic_validate()
      net: ocelot_net: populate supported_interfaces member
      net: ocelot_net: remove interface checks in macb_validate()
      net: ocelot_net: use phylink_generic_validate()
      net: ag71xx: remove interface checks in ag71xx_mac_validate()
      net: ag71xx: use phylink_generic_validate()
      net: dpaa2-mac: remove interface checks in dpaa2_mac_validate()
      net: dpaa2-mac: use phylink_generic_validate()
      net: phylink: add 1000base-KX to phylink_caps_to_linkmodes()
      net: phylink: handle NA interface mode in phylink_fwnode_phy_connect()
      net: macb: convert to phylink_generic_validate()
      net: dsa: consolidate phylink creation
      net: dsa: replace phylink_get_interfaces() with phylink_get_caps()
      net: dsa: support use of phylink_generic_validate()
      net: dsa: hellcreek: convert to phylink_generic_validate()
      net: dsa: lantiq: convert to phylink_generic_validate()
      net: phylink: add legacy_pre_march2020 indicator
      net: dsa: mark DSA phylink as legacy_pre_march2020
      net: mtk_eth_soc: mark as a legacy_pre_march2020 driver
      net: phylink: use legacy_pre_march2020
      net: ag71xx: remove unnecessary legacy methods
      net: phy: prefer 1000baseT over 1000baseKX
      net: axienet: mark as a legacy_pre_march2020 driver
      net: mvneta: mark as a legacy_pre_march2020 driver
      net: phylink: add mac_select_pcs() method to phylink_mac_ops
      net: phylink: add pcs_validate() method
      net: mvpp2: use .mac_select_pcs() interface
      net: mvpp2: convert to pcs_validate() and phylink_generic_validate()
      net: mvneta: convert to pcs_validate() and phylink_generic_validate()
      net: mdio: add helpers to extract clause 45 regad and devad fields
      net: phy: marvell: use phy_write_paged() to set MSCR
      net: phy: marvell: configure RGMII delays for 88E1118
      net: gemini: allow any RGMII interface mode
      net: macb: use .mac_select_pcs() interface

Ruud Bos (4):
      igb: move SDP config initialization to separate function
      igb: move PEROUT and EXTTS isr logic to separate functions
      igb: support PEROUT on 82580/i354/i350
      igb: support EXTTS on 82580/i354/i350

Ryder Lee (3):
      mt76: mt7915: fix SMPS operation fail
      mt76: only set rx radiotap flag from within decoder functions
      mt76: only access ieee80211_hdr after mt76_insert_ccmp_hdr

Saeed Mahameed (7):
      net/mlx5e: Support ethtool cq mode
      net/mlx5: Fix format-security build warnings
      net/mlx5: Print more info on pci error handlers
      net: vertexcom: default to disabled on kbuild
      net/mlx5: mlx5e_hv_vhca_stats_create return type to void
      net/mlx5e: Refactor set_pflag_cqe_based_moder
      Documentation: devlink: mlx5.rst: Fix htmldoc build warning

Sai Teja Aluvala (1):
      Bluetooth: btqca: sequential validation

Sasha Neftin (5):
      igc: Remove unused _I_PHY_ID define
      igc: Remove unused phy type
      igc: Remove obsolete nvm type
      igc: Remove obsolete mask
      igc: Remove obsolete define

Sean Anderson (2):
      net: macb: Fix several edge cases in validate
      net: phylink: Add helpers for c22 registers without MDIO

Sean Wang (23):
      Bluetooth: mediatek: add BT_MTK module
      Bluetooth: btmtksido: rely on BT_MTK module
      Bluetooth: btmtksdio: add .set_bdaddr support
      Bluetooth: btmtksdio: explicitly set WHISR as write-1-clear
      Bluetooth: btmtksdio: move interrupt service to work
      Bluetooth: btmtksdio: update register CSDIOCSR operation
      Bluetooth: btmtksdio: use register CRPLR to read packet length
      mmc: add MT7921 SDIO identifiers for MediaTek Bluetooth devices
      Bluetooth: btmtksdio: add MT7921s Bluetooth support
      Bluetooth: btmtksdio: add support of processing firmware coredump and log
      Bluetooth: btmtksdio: drop the unnecessary variable created
      Bluetooth: btmtksdio: handle runtime pm only when sdio_func is available
      Bluetooth: btmtksdio: fix resume failure
      Bluetooth: btmtksdio: enable AOSP extension for MT7921
      mt76: mt7921: drop offload_flags overwritten
      mt76: mt7921: fix MT7921E reset failure
      mt76: mt7921: move mt76_connac_mcu_set_hif_suspend to bus-related files
      mt76: mt7921s: fix the device cannot sleep deeply in suspend
      mt76: mt7921s: fix possible kernel crash due to invalid Rx count
      mt76: mt7921: clear pm->suspended in mt7921_mac_reset_work
      mt76: mt7921: fix possible resume failure
      mt76: mt7921s: make pm->suspended usage consistent
      mt76: mt7921s: fix suspend error with enlarging mcu timeout value

Sebastian Andrzej Siewior (4):
      net: Write lock dev_base_lock without disabling bottom halves.
      u64_stats: Disable preemption on 32bit UP+SMP PREEMPT_RT during updates.
      net: dev: Always serialize on Qdisc::busylock in __dev_xmit_skb() on PREEMPT_RT.
      net: dev: Change the order of the arguments for the contended condition.

Sebastian Gottschall (1):
      ath10k: Fix tx hanging

Seevalamuthu Mariappan (4):
      ath11k: Fix 'unused-but-set-parameter' error
      ath11k: add hw_param for wakeup_mhi
      ath11k: Fix QMI file type enum value
      ath11k: Change qcn9074 fw to operate in mode-2

Sergey Ryazanov (4):
      net: wwan: iosm: consolidate trace port init code
      net: wwan: iosm: allow trace port be uninitialized
      net: wwan: iosm: move debugfs knobs into a subdir
      net: wwan: make debugfs optional

Shaokun Zhang (1):
      net/mlx5: Remove the repeated declaration

Shaul Triebitz (1):
      iwlwifi: mvm: avoid clearing a just saved session protection id

Shay Drory (13):
      net/mlx5: Introduce log_max_current_uc_list_wr_supported bit
      devlink: Add new "io_eq_size" generic device param
      net/mlx5: Let user configure io_eq_size param
      devlink: Add new "event_eq_size" generic device param
      net/mlx5: Let user configure event_eq_size param
      devlink: Clarifies max_macs generic devlink param
      net/mlx5: Let user configure max_macs generic param
      net/mlx5: Introduce control IRQ request API
      net/mlx5: Move affinity assignment into irq_request
      net/mlx5: Split irq_pool_affinity logic to new file
      net/mlx5: Introduce API for bulk request and release of IRQs
      net/mlx5: SF, Use all available cpu for setting cpu affinity
      net/mlx5: Fix access to sf_dev_table on allocation failure

Shayne Chen (5):
      mt76: mt7915: fix return condition in mt7915_tm_reg_backup_restore()
      mt76: mt7915: add default calibrated data support
      mt76: testmode: add support to set MAC
      mt76: mt7615: fix unused tx antenna mask in testmode
      mt76: mt7921: use correct iftype data on 6GHz cap init

Shiraz Saleem (5):
      devlink: Add 'enable_iwarp' generic device param
      net/ice: Add support for enable_iwarp and enable_roce devlink param
      RDMA/irdma: Set protocol based on PF rdma_mode flag
      net/ice: Fix boolean assignment
      net/ice: Remove unused enum

Shuyi Cheng (1):
      libbpf: Add "bool skipped" to struct bpf_map

Simon Wunderlich (1):
      batman-adv: Start new development cycle

Soenke Huster (1):
      Bluetooth: virtio_bt: fix memory leak in virtbt_rx_handle()

Somnath Kotur (1):
      bnxt_en: Add event handler for PAUSE Storm event

Song Liu (5):
      bpf: Introduce helper bpf_find_vma
      selftests/bpf: Add tests for bpf_find_vma
      bpf: Extend BTF_ID_LIST_GLOBAL with parameter for number of IDs
      bpf: Introduce btf_tracing_ids
      perf/bpf_counter: Use bpf_map_create instead of bpf_create_map

Sriram R (2):
      ath11k: Avoid NULL ptr access during mgmt tx cleanup
      cfg80211: Enable regulatory enforcement checks for drivers supporting mesh iface

Stanislav Fomichev (2):
      bpftool: Enable libbpf's strict mode by default
      bpftool: Add current libbpf_strict mode to version output

Stefan Wahren (3):
      dt-bindings: add vendor Vertexcom
      dt-bindings: net: add Vertexcom MSE102x support
      net: vertexcom: Add MSE102x SPI support

Stephan Gerhold (2):
      dt-bindings: net: Add schema for Qualcomm BAM-DMUX
      net: wwan: Add Qualcomm BAM-DMUX WWAN network driver

Subbaraya Sundeep (1):
      octeontx2-af: Increment ptp refcount before use

Sunil Goutham (1):
      octeontx2-af: Fix interrupt name strings

Suresh Kumar (1):
      net: bonding: debug: avoid printing debug logs when bond is not notifying peers

Sven Eckelmann (2):
      ath11k: Fix ETSI regd with weather radar overlap
      ath11k: Fix buffer overflow when scanning with extraie

Taehee Yoo (1):
      amt: fix wrong return type of amt_send_membership_update()

Tao Liu (1):
      gve: Add tx|rx-coalesce-usec for DQO

Tariq Toukan (7):
      net/mlx5e: Hide function mlx5e_num_channels_changed
      net/mlx5e: Use bitmap field for profile features
      net/mlx5e: Add profile indications for PTP and QOS HTB features
      net/mlx5e: Save memory by using dynamic allocation in netdev priv
      net/mlx5e: Allow profile-specific limitation on max num of channels
      net/mlx5e: Use dynamic per-channel allocations in stats
      net/mlx5e: Take packet_merge params directly from the RX res struct

Tedd Ho-Jeong An (4):
      Bluetooth: hci_vhci: Fix to set the force_wakeup value
      Bluetooth: mgmt: Fix Experimental Feature Changed event
      Bluetooth: btintel: Add missing quirks and msft ext for legacy bootloader
      Bluetooth: btintel: Fix broken LED quirk for legacy ROM devices

Tetsuo Handa (2):
      ath9k_htc: fix NULL pointer dereference at ath9k_htc_rxep()
      ath9k_htc: fix NULL pointer dereference at ath9k_htc_tx_get_packet()

Thomas Gleixner (1):
      r8169: don't use pci_irq_vector() in atomic context

Tianchen Ding (1):
      net: mdio: mscc-miim: Add depend of REGMAP_MMIO on MDIO_MSCC_MIIM

Tianjia Zhang (1):
      net/tls: simplify the tls_set_sw_offload function

Tiezhu Yang (2):
      bpf: Change value of MAX_TAIL_CALL_CNT from 32 to 33
      bpf, mips: Fix build errors about __NR_bpf undeclared

Tim Jiang (1):
      Bluetooth: btusb: Add support using different nvm for variant WCN6855 controller

Tirthendu Sarkar (1):
      selftests/bpf: Fix xdpxceiver failures for no hugepages

Tobias Waldekranz (1):
      net: dsa: mv88e6xxx: Add tx fwd offload PVT on intermediate devices

Toke Høiland-Jørgensen (5):
      xdp: Allow registering memory model without rxq reference
      page_pool: Add callback to init pages when they are allocated
      page_pool: Store the XDP mem id
      xdp: Move conversion to xdp_frame out of map functions
      xdp: Add xdp_do_redirect_frame() for pre-computed xdp_frames

Tom Parkin (1):
      net/l2tp: convert tunnel rwlock_t to rcu

Tom Rix (2):
      ethtool: use phydev variable
      can: janz-ican3: initialize dlc variable

Tonghao Zhang (3):
      veth: use ethtool_sprintf instead of snprintf
      net: ethtool: set a default driver name
      net: ifb: support ethtools stats

Tony Lu (6):
      net/smc: Clear memory when release and reuse buffer
      net/smc: Introduce net namespace support for linkgroup
      net/smc: Add netlink net namespace support
      net/smc: Print net namespace in log
      net/smc: Add net namespace for tracepoints
      net/smc: Introduce TCP ULP support

Tony Nguyen (8):
      iavf: Enable setting RSS hash key
      ice: Remove string printing for ice_status
      ice: Use int for ice_status
      ice: Remove enum ice_status
      ice: Cleanup after ice_status removal
      ice: Remove excess error variables
      ice: Propagate error codes
      ice: Remove unused ICE_FLOW_SEG_HDRS_L2_MASK

Tzung-Bi Shih (1):
      mt76: mt7921: reduce log severity levels for informative messages

Uwe Kleine-König (1):
      net: dsa: vsc73xxx: Make vsc73xx_remove() return void

Vasudev Kamath (1):
      Documentation: networking: net_failover: Fix documentation

Veerendranath Jakkam (2):
      nl80211: Add support to set AP settings flags with single attribute
      nl80211: Add support to offload SA Query procedures for AP SME device

Venkateswara Naralasetty (3):
      ath11k: fix firmware crash during channel switch
      ath11k: add trace log support
      ath11k: add spectral/CFR buffer validation support

Victor Raj (1):
      ice: replay advanced rules after reset

Vincent Mailhol (11):
      can: bittiming: replace CAN units with the generic ones from linux/units.h
      can: etas_es58x: es58x_init_netdev: populate net_device::dev_port
      can: do not increase rx statistics when generating a CAN rx error message frame
      can: kvaser_usb: do not increase tx statistics when sending error message frames
      can: do not copy the payload of RTR frames
      can: do not increase rx_bytes statistics for RTR frames
      can: do not increase tx_bytes statistics for RTR frames
      can: dev: replace can_priv::ctrlmode_static by can_get_static_ctrlmode()
      can: dev: add sanity check in can_set_static_ctrlmode()
      can: dev: reorder struct can_priv members for better packing
      can: netlink: report the CAN controller mode supported flags

Vincent Minet (1):
      libbpf: Fix typo in btf__dedup@LIBBPF_0.0.2 definition

Vladimir Oltean (48):
      net: ocelot: remove "bridge" argument from ocelot_get_bridge_fwd_mask
      net: dsa: felix: enable cut-through forwarding between ports by default
      net: dsa: make dp->bridge_num one-based
      net: dsa: assign a bridge number even without TX forwarding offload
      net: dsa: mt7530: iterate using dsa_switch_for_each_user_port in bridging ops
      net: dsa: mv88e6xxx: iterate using dsa_switch_for_each_user_port in mv88e6xxx_port_check_hw_vlan
      net: dsa: mv88e6xxx: compute port vlan membership based on dp->bridge_dev comparison
      net: dsa: hide dp->bridge_dev and dp->bridge_num in the core behind helpers
      net: dsa: hide dp->bridge_dev and dp->bridge_num in drivers behind helpers
      net: dsa: rename dsa_port_offloads_bridge to dsa_port_offloads_bridge_dev
      net: dsa: export bridging offload helpers to drivers
      net: dsa: keep the bridge_dev and bridge_num as part of the same structure
      net: dsa: add a "tx_fwd_offload" argument to ->port_bridge_join
      net: dsa: eliminate dsa_switch_ops :: port_bridge_tx_fwd_{,un}offload
      net: dsa: introduce tagger-owned storage for private and shared data
      net: dsa: tag_ocelot: convert to tagger-owned data
      net: dsa: sja1105: let deferred packets time out when sent to ports going down
      net: dsa: sja1105: bring deferred xmit implementation in line with ocelot-8021q
      net: dsa: sja1105: remove hwts_tx_en from tagger data
      net: dsa: sja1105: make dp->priv point directly to sja1105_tagger_data
      net: dsa: sja1105: move ts_id from sja1105_tagger_data
      net: dsa: tag_sja1105: convert to tagger-owned data
      Revert "net: dsa: move sja1110_process_meta_tstamp inside the tagging protocol driver"
      net: dsa: tag_sja1105: split sja1105_tagger_data into private and public sections
      net: dsa: remove dp->priv
      net: dsa: tag_sja1105: fix zeroization of ds->priv on tag proto disconnect
      net: dsa: sja1105: fix broken connection with the sja1110 tagger
      net: dsa: make tagging protocols connect to individual switches from a tree
      net: dsa: move dsa_port :: stp_state near dsa_port :: mac
      net: dsa: merge all bools of struct dsa_port into a single u8
      net: dsa: move dsa_port :: type near dsa_port :: index
      net: dsa: merge all bools of struct dsa_switch into a single u32
      net: dsa: make dsa_switch :: num_ports an unsigned int
      net: dsa: move dsa_switch_tree :: ports and lags to first cache line
      net: dsa: combine two holes in struct dsa_switch_tree
      net: dsa: fix incorrect function pointer check for MRP ring roles
      net: dsa: remove cross-chip support for MRP
      net: dsa: remove cross-chip support for HSR
      net: dsa: reorder PHY initialization with MTU setup in slave.c
      net: dsa: merge rtnl_lock sections in dsa_slave_create
      net: dsa: stop updating master MTU from master.c
      net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}
      net: dsa: first set up shared ports, then non-shared ports
      net: dsa: setup master before ports
      net: dsa: don't enumerate dsa_switch and dsa_port bit fields using commas
      net: dsa: warn about dsa_port and dsa_switch bit fields being non atomic
      net: mscc: ocelot: fix incorrect balancing with down LAG ports
      net: dsa: felix: add port fast age support

Volodymyr Mytnyk (4):
      net: prestera: acl: migrate to new vTCAM api
      net: prestera: add counter HW API
      net: prestera: acl: add rule stats support
      net: prestera: flower template support

Wang Hai (1):
      Bluetooth: cmtp: fix possible panic when cmtp_init_sockets() fails

Wei Yongjun (5):
      Bluetooth: Fix debugfs entry leak in hci_register_dev()
      Bluetooth: Fix memory leak of hci device
      net: hns3: make symbol 'hclge_mac_speed_map_to_fw' static
      net: ixp4xx_hss: drop kfree for memory allocated with devm_kzalloc
      net/mlx5: Fix error return code in esw_qos_create()

Wen Gong (25):
      ath11k: set correct NL80211_FEATURE_DYNAMIC_SMPS for WCN6855
      ath11k: enable IEEE80211_VHT_EXT_NSS_BW_CAPABLE if NSS ratio enabled
      ath11k: remove return for empty tx bitrate in mac_op_sta_statistics
      ath11k: fix the value of msecs_to_jiffies in ath11k_debugfs_fw_stats_request
      ath11k: move peer delete after vdev stop of station for QCA6390 and WCN6855
      ath11k: add string type to search board data in board-2.bin for WCN6855
      ath11k: change to treat alpha code na as world wide regdomain
      ath11k: calculate the correct NSS of peer for HE capabilities
      ath11k: fix read fail for htt_stats and htt_peer_stats for single pdev
      ath11k: skip sending vdev down for channel switch
      ath11k: add read variant from SMBIOS for download board data
      ath11k: change to use dynamic memory for channel list of scan
      ath11k: avoid deadlock by change ieee80211_queue_work for regd_update_work
      ath11k: add configure country code for QCA6390 and WCN6855
      ath11k: add 11d scan offload support
      ath11k: add wait operation for tx management packets for flush from mac80211
      ath10k: fix scan abort when duration is set for hw scan
      ath11k: enable IEEE80211_HW_SINGLE_SCAN_ON_ALL_BANDS for WCN6855
      ath10k: drop beacon and probe response which leak from other channel
      ath11k: report rssi of each chain to mac80211 for QCA6390/WCN6855
      ath11k: add signal report to mac80211 for QCA6390 and WCN6855
      ath11k: fix warning of RCU usage for ath11k_mac_get_arvif_by_vdev_id()
      ath11k: report tx bitrate for iw wlan station dump
      ath11k: add support for hardware rfkill for QCA6390
      ath11k: add regdb.bin download for regdb offload

Wen Gu (1):
      net/smc: Reset conn->lgr when link group registration fails

Wen Zhiwei (1):
      net:Remove initialization of static variables to 0

Willem de Bruijn (2):
      selftests/net: expand gro with two machine test
      gve: Add optional metadata descriptor type GVE_TXD_MTD

Wojciech Drewek (2):
      ice: Refactor status flow for DDP load
      ice: improve switchdev's slow-path

Xiang wangx (1):
      fm10k: Fix syntax errors in comments

Xiaoliang Yang (9):
      net: mscc: ocelot: add MAC table stream learn and lookup operations
      net: mscc: ocelot: set vcap IS2 chain to goto PSFP chain
      net: mscc: ocelot: add gate and police action offload to PSFP
      net: dsa: felix: support psfp filter on vsc9959
      net: dsa: felix: add stream gate settings for psfp
      net: mscc: ocelot: use index to set vcap policer
      net: dsa: felix: use vcap policer to set flow meter for psfp
      net: dsa: felix: restrict psfp rules on ingress port
      net: stmmac: bump tc when get underflow error from DMA descriptor

Xin Long (5):
      tipc: delete the unlikely branch in tipc_aead_encrypt
      sctp: make the raise timer more simple and accurate
      bridge: use __set_bit in __br_vlan_set_default_pvid
      tipc: discard MSG_CRYPTO msgs when key_exchange_enabled is not set
      sctp: move hlist_node and hashent out of sctp_ep_common

Xin Xiong (1):
      netfilter: ipt_CLUSTERIP: fix refcount leak in clusterip_tg_check()

Xing Song (2):
      mt76: reverse the first fragmented frame to 802.11
      mt76: do not pass the received frame with decryption error

Xiu Jianfeng (1):
      bpf: Use struct_size() helper

Xu Jia (2):
      xfrm: Add support for SM3 secure hash
      xfrm: Add support for SM4 symmetric cipher algorithm

Xu Wang (3):
      ipvlan: Remove redundant if statements
      net: openvswitch: Remove redundant if statements
      mctp: Remove redundant if statements

Yaara Baruch (4):
      iwlwifi: swap 1650i and 1650s killer struct names
      iwlwifi: add new Qu-Hr device
      iwlwifi: add new ax1650 killer device
      iwlwifi: pcie: add killer devices to the driver

Yacov Simhony (1):
      Fix coverity issue 'Uninitialized scalar variable"

Yajun Deng (3):
      arp: Remove #ifdef CONFIG_PROC_FS
      neigh: introduce neigh_confirm() helper function
      xdp: move the if dev statements to the first

Yan-Hsuan Chuang (1):
      rtw88: add debugfs to fix tx rate

Yang Guang (1):
      ath9k: use swap() to make code cleaner

Yang Li (6):
      ethernet: renesas: Use div64_ul instead of do_div
      tsnep: fix platform_no_drv_owner.cocci warning
      mt76: remove variable set but not used
      net: vertexcom: remove unneeded semicolon
      net/sched: use min() macro instead of doing it manually
      i40e: remove variables set but not used

Yang Shen (1):
      iwlwifi: mvm: demote non-compliant kernel-doc header

Yang Yingliang (5):
      tsnep: Add missing of_node_put() in tsnep_mdio_init()
      net: mdio: ipq8064: replace ioremap() with devm_ioremap()
      net: lantiq: fix missing free_netdev() on error in ltq_etop_probe()
      mctp: remove unnecessary check before calling kfree_skb()
      net: prestera: acl: fix return value check in prestera_acl_rule_entry_find()

Yao Jing (1):
      ipv6: ah6: use swap() to make code cleaner

Ye Guojin (2):
      rtw89: remove unnecessary conditional operators
      selftests: mptcp: remove duplicate include in mptcp_inq.c

Yevgeny Kliteynik (11):
      net/mlx5: DR, Fix error flow in creating matcher
      net/mlx5: DR, Fix lower case macro prefix "mlx5_" to "MLX5_"
      net/mlx5: DR, Remove unused struct member in matcher
      net/mlx5: DR, Rename list field in matcher struct to list_node
      net/mlx5: DR, Add check for flex parser ID value
      net/mlx5: DR, Add support for UPLINK destination type
      net/mlx5: DR, Warn on failure to destroy objects due to refcount
      net/mlx5: DR, Add support for matching on geneve_tlv_option_0_exist field
      net/mlx5: DR, Improve steering for empty or RX/TX-only matchers
      net/mlx5: DR, Ignore modify TTL if device doesn't support it
      net/mlx5: Set SMFS as a default steering mode if device supports it

Yevhen Orlov (6):
      net: marvell: prestera: add virtual router ABI
      net: marvell: prestera: Add router interface ABI
      net: marvell: prestera: Add prestera router infra
      net: marvell: prestera: add hardware router objects accounting
      net: marvell: prestera: Register inetaddr stub notifiers
      net: marvell: prestera: Implement initial inetaddr notifiers

Yihao Han (3):
      net: fddi: use swap() to make code cleaner
      net/mlx5: TC, using swap() instead of tmp variable
      net: dsa: felix: use kmemdup() to replace kmalloc + memcpy

Yinjun Zhang (1):
      nfp: flower: refine the use of circular buffer

Yonghong Song (15):
      bpf: Support BTF_KIND_TYPE_TAG for btf_type_tag attributes
      libbpf: Support BTF_KIND_TYPE_TAG
      bpftool: Support BTF_KIND_TYPE_TAG
      selftests/bpf: Test libbpf API function btf__add_type_tag()
      selftests/bpf: Add BTF_KIND_TYPE_TAG unit tests
      selftests/bpf: Test BTF_KIND_DECL_TAG for deduplication
      selftests/bpf: Rename progs/tag.c to progs/btf_decl_tag.c
      selftests/bpf: Add a C test for btf_type_tag
      selftests/bpf: Clarify llvm dependency with btf_tag selftest
      docs/bpf: Update documentation for BTF_KIND_TYPE_TAG support
      selftests/bpf: Fix an unused-but-set-variable compiler warning
      selftests/bpf: Fix a tautological-constant-out-of-range-compare compiler warning
      libbpf: Fix a couple of missed btf_type_tag handling in btf.c
      selftests/bpf: Add a dedup selftest with equivalent structure types
      selftests/bpf: Fix a compilation warning

Yu Xiao (1):
      nfp: flower: correction of error handling

Yu-Yen Ting (2):
      rtw88: follow the AP basic rates for tx mgmt frame
      rtw88: add debugfs to force lowest basic rate

Yucong Sun (3):
      selftests/bpf: Move summary line after the error logs
      selftests/bpf: Variable naming fix
      selftests/bpf: Mark variable as static

Yufeng Mo (9):
      net: hns3: add log for workqueue scheduled late
      net: hns3: format the output of the MAC address
      net: hns3: add dql info when tx timeout
      net: hns3: split function hns3_get_tx_timeo_queue_info()
      net: hns3: split function hns3_nic_get_stats64()
      net: hns3: split function hns3_handle_bdinfo()
      net: hns3: split function hns3_set_l2l3l4()
      net: hns3: split function hns3_nic_net_xmit()
      net: hns3: optimize function hclge_cfg_common_loopback()

Yunsheng Lin (1):
      page_pool: remove spinlock in page_pool_refill_alloc_cache()

Zekun Shen (5):
      ar5523: Fix null-ptr-deref with unexpected WDCMSG_TARGET_START reply
      mwifiex: Fix skb_over_panic in mwifiex_usb_recv()
      rsi: Fix use-after-free in rsi_rx_done_handler()
      rsi: Fix out-of-bounds read in rsi_read_pkt()
      ath9k: Fix out-of-bound memcpy in ath9k_hif_usb_rx_stream

Zhou Qingyang (1):
      ath11k: Fix a NULL pointer dereference in ath11k_mac_op_hw_scan()

Zijun Hu (3):
      Bluetooth: hci_h4: Fix padding calculation error within h4_recv_buf()
      Bluetooth: btusb: Add one more Bluetooth part for WCN6855
      Bluetooth: btusb: Add two more Bluetooth parts for WCN6855

Zong-Zhe Yang (7):
      rtw89: fill regd field of limit/limit_ru tables by enum
      rtw89: update rtw89 regulation definition to R58-R31
      rtw89: update tx power limit/limit_ru tables to R54
      rtw89: update rtw89_regulatory map to R58-R31
      rtw88: refine tx_pwr_tbl debugfs to show channel and bandwidth
      rtw89: remove cch_by_bw which is not used
      rtw88: support SAR via kernel common API

huangxuesen (1):
      libbpf: Fix trivial typo

kernel test robot (1):
      net: dsa: felix: fix flexible_array.cocci warnings

liuguoqiang (1):
      cfg80211: delete redundant free code

luo penghao (8):
      ipv4: drop unused assignment
      ipv4: Remove duplicate assignments
      ipv6: Remove duplicate statements
      ipv6/esp6: Remove structure variables and alignment statements
      xfrm: Remove duplicate assignment
      mac80211: Remove unused assignment statements
      netfilter: conntrack: Remove useless assignment statements
      ethtool: Remove redundant ret assignments

mark-yw.chen (1):
      Bluetooth: btusb: enable Mediatek to support AOSP extension

tjiang@codeaurora.org (2):
      Bluetooth: btusb: re-definition for board_id in struct qca_version
      Bluetooth: btusb: Add the new support IDs for WCN6855

wengjianfeng (1):
      nfc: fdp: Merge the same judgment

xu xin (3):
      net: Enable neighbor sysctls that is save for userns root
      Namespaceify min_pmtu sysctl
      Namespaceify mtu_expires sysctl

zhangyue (1):
      rsi: fix array out of bound

Łukasz Bartosik (1):
      Bluetooth: btmtksdio: enable msft opcode

 Documentation/bpf/btf.rst                          |    57 +-
 Documentation/bpf/classic_vs_extended.rst          |   376 +
 Documentation/bpf/faq.rst                          |    11 +
 Documentation/bpf/helpers.rst                      |     7 +
 Documentation/bpf/index.rst                        |   103 +-
 Documentation/bpf/instruction-set.rst              |   279 +
 Documentation/bpf/libbpf/index.rst                 |     4 +-
 Documentation/bpf/maps.rst                         |    52 +
 Documentation/bpf/other.rst                        |     9 +
 Documentation/bpf/{bpf_lsm.rst => prog_lsm.rst}    |     0
 Documentation/bpf/programs.rst                     |     9 +
 Documentation/bpf/syscall_api.rst                  |    11 +
 Documentation/bpf/test_debug.rst                   |     9 +
 Documentation/bpf/verifier.rst                     |   529 +
 .../intel,ixp4xx-network-processing-engine.yaml    |    35 +
 .../bindings/net/can/allwinner,sun4i-a10-can.yaml  |    24 +
 .../devicetree/bindings/net/dsa/dsa-port.yaml      |    77 +
 Documentation/devicetree/bindings/net/dsa/dsa.yaml |    60 +-
 .../devicetree/bindings/net/dsa/qca8k.yaml         |    40 +-
 .../devicetree/bindings/net/engleder,tsnep.yaml    |    79 +
 .../devicetree/bindings/net/intel,ixp4xx-hss.yaml  |   100 +
 .../bindings/net/microchip,lan966x-switch.yaml     |   169 +
 .../devicetree/bindings/net/qcom,bam-dmux.yaml     |    92 +
 .../devicetree/bindings/net/vertexcom-mse102x.yaml |    71 +
 .../bindings/net/wireless/microchip,wilc1000.yaml  |    19 +
 .../bindings/net/wireless/qcom,ath11k.yaml         |    30 +
 .../devicetree/bindings/vendor-prefixes.yaml       |     4 +
 Documentation/networking/bonding.rst               |    11 +
 .../device_drivers/can/freescale/flexcan.rst       |    54 +
 .../networking/device_drivers/can/index.rst        |    20 +
 .../device_drivers/ethernet/amazon/ena.rst         |     2 +-
 Documentation/networking/device_drivers/index.rst  |     1 +
 .../networking/devlink/devlink-params.rst          |    15 +-
 Documentation/networking/devlink/ice.rst           |    24 +-
 Documentation/networking/devlink/mlx5.rst          |    11 +
 Documentation/networking/ethtool-netlink.rst       |    10 +-
 Documentation/networking/filter.rst                |  1036 +-
 Documentation/networking/net_failover.rst          |   111 +-
 Documentation/networking/phy.rst                   |     5 +
 MAINTAINERS                                        |    17 +-
 arch/arm/boot/dts/qcom-sdx55.dtsi                  |     6 +-
 arch/arm/boot/dts/sun8i-r40.dtsi                   |    19 +
 arch/arm/net/bpf_jit_32.c                          |     7 +-
 arch/arm64/include/asm/extable.h                   |     9 -
 arch/arm64/include/asm/memory.h                    |     5 +-
 arch/arm64/kernel/traps.c                          |     2 +-
 arch/arm64/mm/ptdump.c                             |     2 -
 arch/arm64/net/bpf_jit_comp.c                      |    19 +-
 arch/mips/include/asm/mach-lantiq/xway/xway_dma.h  |     2 +-
 arch/mips/net/bpf_jit_comp32.c                     |     3 +-
 arch/mips/net/bpf_jit_comp64.c                     |     2 +-
 arch/powerpc/net/bpf_jit_comp32.c                  |     4 +-
 arch/powerpc/net/bpf_jit_comp64.c                  |     4 +-
 arch/riscv/net/bpf_jit_comp32.c                    |     6 +-
 arch/riscv/net/bpf_jit_comp64.c                    |     7 +-
 arch/s390/mm/hugetlbpage.c                         |     1 +
 arch/s390/net/bpf_jit_comp.c                       |     6 +-
 arch/sparc/net/bpf_jit_comp_64.c                   |     4 +-
 arch/um/drivers/vector_kern.c                      |     4 +-
 arch/x86/net/bpf_jit_comp.c                        |    69 +-
 arch/x86/net/bpf_jit_comp32.c                      |     4 +-
 drivers/base/regmap/regmap.c                       |     1 +
 drivers/bluetooth/Kconfig                          |     6 +
 drivers/bluetooth/Makefile                         |     1 +
 drivers/bluetooth/bfusb.c                          |     3 +
 drivers/bluetooth/btbcm.c                          |    51 +
 drivers/bluetooth/btintel.c                        |    68 +-
 drivers/bluetooth/btintel.h                        |     2 +-
 drivers/bluetooth/btmrvl_main.c                    |     2 +-
 drivers/bluetooth/btmtk.c                          |   290 +
 drivers/bluetooth/btmtk.h                          |   111 +
 drivers/bluetooth/btmtksdio.c                      |   535 +-
 drivers/bluetooth/btqca.c                          |    48 +
 drivers/bluetooth/btqca.h                          |     2 +
 drivers/bluetooth/btsdio.c                         |     2 +
 drivers/bluetooth/btusb.c                          |   588 +-
 drivers/bluetooth/hci_bcm.c                        |     8 +-
 drivers/bluetooth/hci_h4.c                         |     4 +-
 drivers/bluetooth/hci_qca.c                        |     9 +-
 drivers/bluetooth/hci_vhci.c                       |   122 +-
 drivers/bluetooth/virtio_bt.c                      |     3 +
 drivers/infiniband/core/cache.c                    |     1 +
 drivers/infiniband/hw/irdma/ctrl.c                 |     2 +
 drivers/infiniband/hw/irdma/main.c                 |     3 +-
 drivers/infiniband/hw/irdma/uda.c                  |     2 +
 drivers/infiniband/hw/mlx5/doorbell.c              |     1 +
 drivers/infiniband/hw/mlx5/fs.c                    |    18 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |     3 +-
 drivers/infiniband/hw/mlx5/odp.c                   |     6 -
 drivers/infiniband/hw/mlx5/qp.c                    |     1 +
 drivers/isdn/capi/kcapi.c                          |     2 +-
 drivers/misc/mei/bus.c                             |    67 +-
 drivers/misc/mei/client.c                          |     3 +
 drivers/misc/mei/hw.h                              |     5 +
 drivers/net/amt.c                                  |     3 +-
 drivers/net/appletalk/ipddp.c                      |     1 +
 drivers/net/bareudp.c                              |    54 +-
 drivers/net/bonding/bond_main.c                    |   100 +-
 drivers/net/bonding/bond_netlink.c                 |    15 +
 drivers/net/bonding/bond_options.c                 |    28 +
 drivers/net/bonding/bond_procfs.c                  |     2 +
 drivers/net/bonding/bond_sysfs.c                   |    13 +
 drivers/net/can/Makefile                           |     2 +-
 drivers/net/can/at91_can.c                         |    18 +-
 drivers/net/can/c_can/c_can.h                      |     1 -
 drivers/net/can/c_can/c_can_ethtool.c              |     4 +-
 drivers/net/can/c_can/c_can_main.c                 |    16 +-
 drivers/net/can/cc770/cc770.c                      |    16 +-
 drivers/net/can/dev/bittiming.c                    |     5 +-
 drivers/net/can/dev/dev.c                          |     9 +-
 drivers/net/can/dev/netlink.c                      |    33 +-
 drivers/net/can/dev/rx-offload.c                   |     7 +-
 drivers/net/can/flexcan/Makefile                   |     7 +
 .../net/can/{flexcan.c => flexcan/flexcan-core.c}  |   234 +-
 drivers/net/can/flexcan/flexcan-ethtool.c          |   114 +
 drivers/net/can/flexcan/flexcan.h                  |   163 +
 drivers/net/can/grcan.c                            |    23 +-
 drivers/net/can/ifi_canfd/ifi_canfd.c              |    11 +-
 drivers/net/can/janz-ican3.c                       |     8 +-
 drivers/net/can/kvaser_pciefd.c                    |    16 +-
 drivers/net/can/m_can/m_can.c                      |    23 +-
 drivers/net/can/mscan/mscan.c                      |    14 +-
 drivers/net/can/pch_can.c                          |    33 +-
 drivers/net/can/peak_canfd/peak_canfd.c            |    14 +-
 drivers/net/can/rcar/rcar_can.c                    |    22 +-
 drivers/net/can/rcar/rcar_canfd.c                  |    22 +-
 drivers/net/can/sja1000/sja1000.c                  |    11 +-
 drivers/net/can/sja1000/sja1000_platform.c         |    15 +-
 drivers/net/can/slcan.c                            |     7 +-
 drivers/net/can/softing/softing_cs.c               |     2 +-
 drivers/net/can/softing/softing_fw.c               |    11 +-
 drivers/net/can/softing/softing_main.c             |     8 +-
 drivers/net/can/spi/hi311x.c                       |    83 +-
 drivers/net/can/spi/mcp251x.c                      |    34 +-
 drivers/net/can/spi/mcp251xfd/Makefile             |     5 +
 .../net/can/spi/mcp251xfd/mcp251xfd-chip-fifo.c    |   119 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |  1083 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c   |     1 -
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c     |   269 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c       |   260 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c      |   260 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c       |   205 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h          |    36 +-
 drivers/net/can/sun4i_can.c                        |    84 +-
 drivers/net/can/ti_hecc.c                          |     8 +-
 drivers/net/can/usb/ems_usb.c                      |    14 +-
 drivers/net/can/usb/esd_usb2.c                     |    13 +-
 drivers/net/can/usb/etas_es58x/es581_4.c           |     5 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c        |     8 +-
 drivers/net/can/usb/etas_es58x/es58x_fd.c          |     5 +-
 drivers/net/can/usb/gs_usb.c                       |    12 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h        |     5 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |     4 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |    78 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |    29 +-
 drivers/net/can/usb/mcba_usb.c                     |    23 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c            |    10 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |    20 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.h       |     1 -
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |    11 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |    12 +-
 drivers/net/can/usb/ucan.c                         |    17 +-
 drivers/net/can/usb/usb_8dev.c                     |    19 +-
 drivers/net/can/vcan.c                             |     7 +-
 drivers/net/can/vxcan.c                            |     2 +-
 drivers/net/can/xilinx_can.c                       |    26 +-
 drivers/net/dsa/b53/b53_common.c                   |     9 +-
 drivers/net/dsa/b53/b53_priv.h                     |     5 +-
 drivers/net/dsa/bcm_sf2.c                          |    54 +-
 drivers/net/dsa/bcm_sf2.h                          |    10 +
 drivers/net/dsa/bcm_sf2_regs.h                     |    65 +-
 drivers/net/dsa/dsa_loop.c                         |     9 +-
 drivers/net/dsa/hirschmann/hellcreek.c             |   116 +-
 drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c    |     4 -
 drivers/net/dsa/lan9303-core.c                     |     7 +-
 drivers/net/dsa/lantiq_gswip.c                     |   145 +-
 drivers/net/dsa/microchip/ksz8795.c                |     1 +
 drivers/net/dsa/microchip/ksz_common.c             |    10 +-
 drivers/net/dsa/microchip/ksz_common.h             |     4 +-
 drivers/net/dsa/mt7530.c                           |    58 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   146 +-
 drivers/net/dsa/mv88e6xxx/hwtstamp.c               |     4 -
 drivers/net/dsa/ocelot/Kconfig                     |     1 +
 drivers/net/dsa/ocelot/felix.c                     |   109 +-
 drivers/net/dsa/ocelot/felix.h                     |    10 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             |   929 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c           |   140 +-
 drivers/net/dsa/qca8k.c                            |   666 +-
 drivers/net/dsa/qca8k.h                            |   198 +-
 drivers/net/dsa/realtek-smi-core.c                 |     2 +-
 drivers/net/dsa/rtl8365mb.c                        |    20 +-
 drivers/net/dsa/rtl8366rb.c                        |     9 +-
 drivers/net/dsa/sja1105/sja1105.h                  |     6 +-
 drivers/net/dsa/sja1105/sja1105_flower.c           |     2 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |   163 +-
 drivers/net/dsa/sja1105/sja1105_ptp.c              |    86 +-
 drivers/net/dsa/sja1105/sja1105_ptp.h              |    24 +
 drivers/net/dsa/vitesse-vsc73xx-core.c             |     7 +-
 drivers/net/dsa/vitesse-vsc73xx.h                  |     2 +-
 drivers/net/dsa/xrs700x/xrs700x.c                  |    11 +-
 drivers/net/eql.c                                  |     4 +-
 drivers/net/ethernet/3com/typhoon.c                |     4 +-
 drivers/net/ethernet/8390/hydra.c                  |     4 +-
 drivers/net/ethernet/8390/mac8390.c                |     4 +-
 drivers/net/ethernet/8390/smc-ultra.c              |     4 +-
 drivers/net/ethernet/8390/wd.c                     |     4 +-
 drivers/net/ethernet/Kconfig                       |     2 +
 drivers/net/ethernet/Makefile                      |     2 +
 drivers/net/ethernet/agere/et131x.c                |     5 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |   218 +-
 drivers/net/ethernet/alteon/acenic.c               |     9 +-
 drivers/net/ethernet/alteon/acenic.h               |     1 -
 drivers/net/ethernet/amazon/ena/ena_admin_defs.h   |    10 +-
 drivers/net/ethernet/amazon/ena/ena_com.c          |     8 +
 drivers/net/ethernet/amazon/ena/ena_com.h          |    13 +
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |    23 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |   127 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.h       |    25 +-
 drivers/net/ethernet/amd/a2065.c                   |    18 +-
 drivers/net/ethernet/amd/ariadne.c                 |    20 +-
 drivers/net/ethernet/amd/atarilance.c              |     7 +-
 drivers/net/ethernet/amd/hplance.c                 |     4 +-
 drivers/net/ethernet/amd/lance.c                   |     4 +-
 drivers/net/ethernet/amd/mvme147.c                 |    14 +-
 drivers/net/ethernet/amd/ni65.c                    |     8 +-
 drivers/net/ethernet/amd/pcnet32.c                 |     8 +-
 drivers/net/ethernet/amd/xgbe/xgbe-common.h        |     6 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |     3 -
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c       |    11 +-
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c           |    11 +-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |     8 +-
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c   |     2 +-
 drivers/net/ethernet/apple/macmace.c               |    14 +-
 .../net/ethernet/aquantia/atlantic/aq_ethtool.c    |     8 +-
 drivers/net/ethernet/aquantia/atlantic/aq_main.c   |     3 -
 drivers/net/ethernet/asix/ax88796c_main.c          |    18 +-
 drivers/net/ethernet/atheros/ag71xx.c              |   111 +-
 drivers/net/ethernet/atheros/atlx/atl1.c           |     8 +-
 drivers/net/ethernet/broadcom/b44.c                |     8 +-
 drivers/net/ethernet/broadcom/bcm4908_enet.c       |     2 -
 drivers/net/ethernet/broadcom/bcm63xx_enet.c       |    25 +-
 drivers/net/ethernet/broadcom/bnx2.c               |     8 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |    11 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |     7 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c    |     8 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_fw_defs.h    |     2 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_hsi.h    |     3 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |    99 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  |    13 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h  |     2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c  |     7 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.h  |    14 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   139 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |     6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c |     4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |     1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |    41 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c     |   103 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h     |     7 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |     3 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c       |     2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |     2 +-
 drivers/net/ethernet/broadcom/tg3.c                |    13 +-
 drivers/net/ethernet/brocade/bna/bnad.c            |    34 +-
 drivers/net/ethernet/brocade/bna/bnad_ethtool.c    |    30 +-
 drivers/net/ethernet/cadence/macb.h                |     3 +-
 drivers/net/ethernet/cadence/macb_main.c           |   133 +-
 drivers/net/ethernet/cadence/macb_ptp.c            |     4 -
 drivers/net/ethernet/cavium/liquidio/lio_ethtool.c |    11 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |     3 -
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c |     3 -
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c   |     5 +-
 .../net/ethernet/cavium/thunder/nicvf_ethtool.c    |     8 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |     6 +-
 drivers/net/ethernet/cavium/thunder/nicvf_queues.c |     1 +
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c          |    27 +-
 drivers/net/ethernet/chelsio/cxgb/sge.c            |     2 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |    19 +-
 drivers/net/ethernet/chelsio/cxgb3/sge.c           |    13 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c |    19 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |    17 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |     8 +-
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h      |    10 +-
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |    28 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c         |     7 +-
 drivers/net/ethernet/cirrus/mac89x0.c              |     7 +-
 drivers/net/ethernet/cisco/enic/enic.h             |     2 +-
 drivers/net/ethernet/cisco/enic/enic_ethtool.c     |     8 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |    16 +-
 drivers/net/ethernet/cortina/gemini.c              |    17 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c     |     4 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |    14 +-
 drivers/net/ethernet/engleder/Kconfig              |    39 +
 drivers/net/ethernet/engleder/Makefile             |    10 +
 drivers/net/ethernet/engleder/tsnep.h              |   189 +
 drivers/net/ethernet/engleder/tsnep_ethtool.c      |   293 +
 drivers/net/ethernet/engleder/tsnep_hw.h           |   230 +
 drivers/net/ethernet/engleder/tsnep_main.c         |  1272 ++
 drivers/net/ethernet/engleder/tsnep_ptp.c          |   218 +
 drivers/net/ethernet/engleder/tsnep_selftests.c    |   811 ++
 drivers/net/ethernet/engleder/tsnep_tc.c           |   443 +
 drivers/net/ethernet/ethoc.c                       |    17 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |    14 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |     6 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |     2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c   |   142 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h   |     3 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |     9 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |    10 +-
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |     4 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |    81 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.h    |     4 +-
 drivers/net/ethernet/freescale/enetc/enetc_ptp.c   |     9 +-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |     6 +-
 drivers/net/ethernet/freescale/fec_main.c          |    48 +-
 drivers/net/ethernet/freescale/fec_ptp.c           |     4 -
 drivers/net/ethernet/freescale/fman/fman.c         |    32 +-
 drivers/net/ethernet/freescale/fman/mac.c          |    21 +-
 drivers/net/ethernet/freescale/gianfar.c           |     4 -
 drivers/net/ethernet/freescale/gianfar_ethtool.c   |     8 +-
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c  |     8 +-
 drivers/net/ethernet/google/gve/gve.h              |    21 +-
 drivers/net/ethernet/google/gve/gve_adminq.c       |     2 +-
 drivers/net/ethernet/google/gve/gve_desc.h         |    20 +
 drivers/net/ethernet/google/gve/gve_dqo.h          |    24 +-
 drivers/net/ethernet/google/gve/gve_ethtool.c      |    86 +-
 drivers/net/ethernet/google/gve/gve_main.c         |   111 +-
 drivers/net/ethernet/google/gve/gve_rx.c           |     2 -
 drivers/net/ethernet/google/gve/gve_tx.c           |    73 +-
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c   |     6 +-
 drivers/net/ethernet/hisilicon/hns3/Makefile       |    19 +-
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |     3 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |    14 +
 .../hisilicon/hns3/hns3_common/hclge_comm_cmd.c    |   610 +
 .../hisilicon/hns3/hns3_common/hclge_comm_cmd.h    |   458 +
 .../hisilicon/hns3/hns3_common/hclge_comm_rss.c    |   525 +
 .../hisilicon/hns3/hns3_common/hclge_comm_rss.h    |   136 +
 .../hns3/hns3_common/hclge_comm_tqp_stats.c        |   115 +
 .../hns3/hns3_common/hclge_comm_tqp_stats.h        |    39 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |     2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h |     2 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   904 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |    17 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   116 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/Makefile    |    12 -
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |   591 -
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   434 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |     2 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |   116 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h |    13 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |    25 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  1414 +--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |    95 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |    33 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c    |     4 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h    |     4 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c |     2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h |     3 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |   110 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |     6 +
 .../net/ethernet/hisilicon/hns3/hns3vf/Makefile    |    10 -
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |   556 -
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |   218 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   822 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |    90 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c   |    23 +-
 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c  |    40 +-
 .../net/ethernet/huawei/hinic/hinic_hw_api_cmd.c   |     5 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c  |    10 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c   |     5 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c   |     9 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_io.c    |    17 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c    |    23 +-
 drivers/net/ethernet/huawei/hinic/hinic_main.c     |    18 +-
 drivers/net/ethernet/huawei/hinic/hinic_tx.c       |    10 +-
 drivers/net/ethernet/i825xx/82596.c                |     3 +-
 drivers/net/ethernet/i825xx/lasi_82596.c           |     6 +-
 drivers/net/ethernet/ibm/emac/core.c               |     7 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |     3 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |    74 +-
 drivers/net/ethernet/ibm/ibmvnic.h                 |     2 -
 drivers/net/ethernet/intel/Kconfig                 |    10 +
 drivers/net/ethernet/intel/e100.c                  |     8 +-
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c   |     8 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |    14 +-
 drivers/net/ethernet/intel/e1000e/ethtool.c        |     8 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |     4 -
 drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c   |     8 +-
 drivers/net/ethernet/intel/fm10k/fm10k_tlv.c       |     2 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq.c      |    29 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h  |     4 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c      |    15 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |     8 +-
 drivers/net/ethernet/intel/i40e/i40e_prototype.h   |    14 +-
 drivers/net/ethernet/intel/i40e/i40e_ptp.c         |     4 -
 drivers/net/ethernet/intel/i40e/i40e_status.h      |     2 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |     4 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |    34 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |     2 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.h         |     1 -
 drivers/net/ethernet/intel/iavf/iavf.h             |   115 +-
 drivers/net/ethernet/intel/iavf/iavf_adminq.c      |     4 +-
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |    60 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   796 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c        |    75 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.h        |    30 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |   558 +-
 drivers/net/ethernet/intel/ice/ice.h               |    11 +-
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h    |     7 +
 drivers/net/ethernet/intel/ice/ice_base.c          |    22 +-
 drivers/net/ethernet/intel/ice/ice_cgu_regs.h      |   116 +
 drivers/net/ethernet/intel/ice/ice_common.c        |   429 +-
 drivers/net/ethernet/intel/ice/ice_common.h        |    96 +-
 drivers/net/ethernet/intel/ice/ice_controlq.c      |   120 +-
 drivers/net/ethernet/intel/ice/ice_dcb.c           |    92 +-
 drivers/net/ethernet/intel/ice/ice_dcb.h           |    27 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c       |     2 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c       |   398 +-
 drivers/net/ethernet/intel/ice/ice_devlink.h       |     2 +
 drivers/net/ethernet/intel/ice/ice_eswitch.c       |   169 +-
 drivers/net/ethernet/intel/ice/ice_eswitch.h       |    25 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   157 +-
 drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c  |   304 +-
 drivers/net/ethernet/intel/ice/ice_fdir.c          |    20 +-
 drivers/net/ethernet/intel/ice/ice_fdir.h          |    13 +-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c     |   702 +-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.h     |    83 +-
 drivers/net/ethernet/intel/ice/ice_flex_type.h     |    42 +
 drivers/net/ethernet/intel/ice/ice_flow.c          |   214 +-
 drivers/net/ethernet/intel/ice/ice_flow.h          |    22 +-
 drivers/net/ethernet/intel/ice/ice_fltr.c          |   216 +-
 drivers/net/ethernet/intel/ice/ice_fltr.h          |    41 +-
 drivers/net/ethernet/intel/ice/ice_fw_update.c     |   397 +-
 drivers/net/ethernet/intel/ice/ice_fw_update.h     |     9 +-
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h    |     9 +
 drivers/net/ethernet/intel/ice/ice_idc.c           |     4 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   302 +-
 drivers/net/ethernet/intel/ice/ice_lib.h           |     6 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   739 +-
 drivers/net/ethernet/intel/ice/ice_nvm.c           |   208 +-
 drivers/net/ethernet/intel/ice/ice_nvm.h           |    36 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           |   860 +-
 drivers/net/ethernet/intel/ice/ice_ptp.h           |    38 +-
 drivers/net/ethernet/intel/ice/ice_ptp_consts.h    |   374 +
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c        |  2814 ++++-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h        |   345 +
 drivers/net/ethernet/intel/ice/ice_repr.c          |    17 +
 drivers/net/ethernet/intel/ice/ice_repr.h          |     5 +
 drivers/net/ethernet/intel/ice/ice_sched.c         |   402 +-
 drivers/net/ethernet/intel/ice/ice_sched.h         |    37 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c         |    40 +-
 drivers/net/ethernet/intel/ice/ice_sriov.h         |    12 +-
 drivers/net/ethernet/intel/ice/ice_status.h        |    44 -
 drivers/net/ethernet/intel/ice/ice_switch.c        |   557 +-
 drivers/net/ethernet/intel/ice/ice_switch.h        |    56 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c        |    12 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |    44 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c      |     5 +-
 drivers/net/ethernet/intel/ice/ice_type.h          |    36 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c |   298 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |   468 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h   |     2 +
 drivers/net/ethernet/intel/ice/ice_xsk.c           |     2 +-
 drivers/net/ethernet/intel/igb/e1000_i210.c        |     3 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |     8 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   156 +-
 drivers/net/ethernet/intel/igb/igb_ptp.c           |   192 +-
 drivers/net/ethernet/intel/igbvf/ethtool.c         |     8 +-
 drivers/net/ethernet/intel/igbvf/netdev.c          |     2 +-
 drivers/net/ethernet/intel/igc/igc_defines.h       |     7 -
 drivers/net/ethernet/intel/igc/igc_ethtool.c       |    14 +-
 drivers/net/ethernet/intel/igc/igc_hw.h            |     3 -
 drivers/net/ethernet/intel/igc/igc_i225.c          |     2 -
 drivers/net/ethernet/intel/igc/igc_main.c          |    39 +-
 drivers/net/ethernet/intel/igc/igc_ptp.c           |     4 -
 drivers/net/ethernet/intel/igc/igc_xdp.c           |     1 +
 drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c     |     8 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |     8 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |     4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c       |     4 -
 .../net/ethernet/intel/ixgbe/ixgbe_txrx_common.h   |     2 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |     2 +-
 drivers/net/ethernet/intel/ixgbevf/defines.h       |     4 +
 drivers/net/ethernet/intel/ixgbevf/ethtool.c       |     8 +-
 drivers/net/ethernet/intel/ixgbevf/ipsec.c         |    11 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h       |     5 +
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |    15 +-
 drivers/net/ethernet/intel/ixgbevf/mbx.c           |   323 +-
 drivers/net/ethernet/intel/ixgbevf/mbx.h           |    19 +-
 drivers/net/ethernet/intel/ixgbevf/vf.c            |    62 +-
 drivers/net/ethernet/intel/ixgbevf/vf.h            |     5 +-
 drivers/net/ethernet/lantiq_etop.c                 |    55 +-
 drivers/net/ethernet/lantiq_xrx200.c               |   107 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c         |    10 +-
 drivers/net/ethernet/marvell/mvneta.c              |   432 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h         |     3 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   229 +-
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c    |     2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cpt.c    |     5 +-
 .../ethernet/marvell/octeontx2/af/rvu_devlink.c    |     2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |     8 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |     6 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |     2 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |     7 +-
 drivers/net/ethernet/marvell/prestera/Makefile     |     3 +-
 drivers/net/ethernet/marvell/prestera/prestera.h   |    39 +
 .../net/ethernet/marvell/prestera/prestera_acl.c   |   727 +-
 .../net/ethernet/marvell/prestera/prestera_acl.h   |   215 +-
 .../ethernet/marvell/prestera/prestera_counter.c   |   475 +
 .../ethernet/marvell/prestera/prestera_counter.h   |    30 +
 .../net/ethernet/marvell/prestera/prestera_flow.c  |   108 +-
 .../net/ethernet/marvell/prestera/prestera_flow.h  |    18 +
 .../ethernet/marvell/prestera/prestera_flower.c    |   353 +-
 .../ethernet/marvell/prestera/prestera_flower.h    |     8 +-
 .../net/ethernet/marvell/prestera/prestera_hw.c    |   630 +-
 .../net/ethernet/marvell/prestera/prestera_hw.h    |    73 +-
 .../net/ethernet/marvell/prestera/prestera_main.c  |    16 +-
 .../ethernet/marvell/prestera/prestera_router.c    |   182 +
 .../ethernet/marvell/prestera/prestera_router_hw.c |   208 +
 .../ethernet/marvell/prestera/prestera_router_hw.h |    36 +
 .../net/ethernet/marvell/prestera/prestera_span.c  |     1 +
 drivers/net/ethernet/marvell/pxa168_eth.c          |     9 +-
 drivers/net/ethernet/marvell/skge.c                |     8 +-
 drivers/net/ethernet/marvell/sky2.c                |    92 +-
 drivers/net/ethernet/mediatek/Kconfig              |     3 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   217 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |    19 +-
 drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c    |     3 -
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |     8 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |     5 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |     2 +-
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |     1 +
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |    14 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |    36 +-
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |     2 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |    88 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |    36 +-
 .../ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c |    10 +-
 .../ethernet/mellanox/mlx5/core/en/hv_vhca_stats.h |    13 +-
 .../net/ethernet/mellanox/mlx5/core/en/mod_hdr.c   |    58 +
 .../net/ethernet/mellanox/mlx5/core/en/mod_hdr.h   |    26 +
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |     2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |     6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c   |     1 +
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |     3 +
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |     2 +-
 .../net/ethernet/mellanox/mlx5/core/en/rx_res.c    |    14 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/accept.c |    31 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.c    |   103 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.h    |    75 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/csum.c   |    61 +
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c |    50 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/drop.c   |    30 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/goto.c   |   122 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/mark.c   |    35 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/mirred.c |   307 +
 .../mellanox/mlx5/core/en/tc/act/mirred_nic.c      |    51 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/mpls.c   |    86 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/pedit.c  |   165 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/pedit.h  |    32 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/ptype.c  |    35 +
 .../mlx5/core/en/tc/act/redirect_ingress.c         |    79 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/sample.c |    51 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/trap.c   |    38 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/tun.c    |    61 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/vlan.c   |   218 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/vlan.h   |    30 +
 .../mellanox/mlx5/core/en/tc/act/vlan_mangle.c     |    87 +
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |     5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |    90 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |    12 +
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |    23 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.h    |     3 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |     6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |     2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/pool.c  |     4 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |     2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |     2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |     2 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |    78 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   197 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |    38 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |    32 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   119 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  1354 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |     6 -
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   138 +-
 .../ethernet/mellanox/mlx5/core/esw/indir_table.c  |     5 +-
 .../net/ethernet/mellanox/mlx5/core/esw/legacy.c   |     6 +-
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  |   221 +-
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h  |    14 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |    94 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |    14 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |    87 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |     7 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |    84 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |     2 +-
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |    74 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |     5 +
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |    12 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |    15 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c |     1 -
 .../net/ethernet/mellanox/mlx5/core/irq_affinity.c |   226 +
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c   |     6 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |    80 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |     1 +
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h |    30 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |   310 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h  |    39 +
 .../net/ethernet/mellanox/mlx5/core/sf/dev/dev.c   |     5 +-
 .../net/ethernet/mellanox/mlx5/core/sf/hw_table.c  |     2 +-
 .../mellanox/mlx5/core/steering/dr_action.c        |    23 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |    29 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_dbg.c  |   649 +
 .../ethernet/mellanox/mlx5/core/steering/dr_dbg.h  |    15 +
 .../mellanox/mlx5/core/steering/dr_domain.c        |     5 +-
 .../mellanox/mlx5/core/steering/dr_matcher.c       |   250 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |    47 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |    61 +
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.h  |     2 +
 .../mellanox/mlx5/core/steering/dr_ste_v0.c        |    25 +-
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        |    52 +-
 .../mellanox/mlx5/core/steering/dr_table.c         |    94 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |   262 +-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |    18 +-
 .../mellanox/mlx5/core/steering/mlx5_ifc_dr.h      |    16 +
 .../mellanox/mlxbf_gige/mlxbf_gige_ethtool.c       |     7 +-
 drivers/net/ethernet/mellanox/mlxsw/Kconfig        |     2 +-
 drivers/net/ethernet/mellanox/mlxsw/cmd.h          |    12 +
 drivers/net/ethernet/mellanox/mlxsw/core.c         |   239 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h         |    44 +-
 .../mellanox/mlxsw/core_acl_flex_actions.c         |    22 +-
 .../mellanox/mlxsw/core_acl_flex_actions.h         |    16 +-
 .../ethernet/mellanox/mlxsw/core_acl_flex_keys.c   |     4 +-
 .../ethernet/mellanox/mlxsw/core_acl_flex_keys.h   |     4 +-
 drivers/net/ethernet/mellanox/mlxsw/item.h         |    36 +
 drivers/net/ethernet/mellanox/mlxsw/minimal.c      |    10 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c          |     7 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.h          |     1 +
 drivers/net/ethernet/mellanox/mlxsw/reg.h          |   642 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   306 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |    44 +-
 .../ethernet/mellanox/mlxsw/spectrum2_mr_tcam.c    |    12 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c |     2 +-
 .../mellanox/mlxsw/spectrum_acl_bloom_filter.c     |   351 +-
 .../mellanox/mlxsw/spectrum_acl_flex_actions.c     |    14 +-
 .../mellanox/mlxsw/spectrum_acl_flex_keys.c        |    46 +-
 .../ethernet/mellanox/mlxsw/spectrum_acl_tcam.h    |     6 +
 .../net/ethernet/mellanox/mlxsw/spectrum_buffers.c |    58 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_ethtool.c |     4 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c |    30 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  |     5 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_ipip.c    |    28 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c |   165 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h |     2 +
 .../ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c   |    97 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c |    12 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h |    16 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |    19 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c    |    20 +-
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c   |   187 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_trap.c    |    24 +-
 drivers/net/ethernet/micrel/ksz884x.c              |     6 +-
 drivers/net/ethernet/microchip/Kconfig             |     1 +
 drivers/net/ethernet/microchip/Makefile            |     1 +
 drivers/net/ethernet/microchip/lan743x_main.c      |    22 +-
 drivers/net/ethernet/microchip/lan743x_ptp.c       |     6 -
 drivers/net/ethernet/microchip/lan966x/Kconfig     |     9 +
 drivers/net/ethernet/microchip/lan966x/Makefile    |    10 +
 .../ethernet/microchip/lan966x/lan966x_ethtool.c   |   682 ++
 .../net/ethernet/microchip/lan966x/lan966x_fdb.c   |   244 +
 .../net/ethernet/microchip/lan966x/lan966x_ifh.h   |   173 +
 .../net/ethernet/microchip/lan966x/lan966x_mac.c   |   469 +
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |  1002 ++
 .../net/ethernet/microchip/lan966x/lan966x_main.h  |   278 +
 .../net/ethernet/microchip/lan966x/lan966x_mdb.c   |   506 +
 .../ethernet/microchip/lan966x/lan966x_phylink.c   |   127 +
 .../net/ethernet/microchip/lan966x/lan966x_port.c  |   406 +
 .../net/ethernet/microchip/lan966x/lan966x_regs.h  |   871 ++
 .../ethernet/microchip/lan966x/lan966x_switchdev.c |   544 +
 .../net/ethernet/microchip/lan966x/lan966x_vlan.c  |   317 +
 .../net/ethernet/microchip/sparx5/sparx5_main.c    |    27 +
 .../net/ethernet/microchip/sparx5/sparx5_phylink.c |    75 +-
 drivers/net/ethernet/microsoft/mana/Makefile       |     2 +-
 drivers/net/ethernet/microsoft/mana/mana.h         |    15 +
 drivers/net/ethernet/microsoft/mana/mana_bpf.c     |   162 +
 drivers/net/ethernet/microsoft/mana/mana_en.c      |   140 +-
 drivers/net/ethernet/mscc/Makefile                 |     4 +-
 drivers/net/ethernet/mscc/ocelot.c                 |   299 +-
 drivers/net/ethernet/mscc/ocelot.h                 |    15 +-
 drivers/net/ethernet/mscc/ocelot_fdma.c            |   894 ++
 drivers/net/ethernet/mscc/ocelot_fdma.h            |   166 +
 drivers/net/ethernet/mscc/ocelot_flower.c          |    84 +-
 drivers/net/ethernet/mscc/ocelot_net.c             |    85 +-
 drivers/net/ethernet/mscc/ocelot_vcap.c            |   103 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c         |   535 +-
 drivers/net/ethernet/mscc/vsc7514_regs.c           |   523 +
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |    17 +-
 drivers/net/ethernet/natsemi/jazzsonic.c           |     6 +-
 drivers/net/ethernet/natsemi/macsonic.c            |    27 +-
 drivers/net/ethernet/natsemi/xtsonic.c             |     6 +-
 drivers/net/ethernet/neterion/s2io.c               |    25 +-
 drivers/net/ethernet/neterion/s2io.h               |     1 -
 drivers/net/ethernet/neterion/vxge/vxge-main.c     |    31 +-
 .../net/ethernet/netronome/nfp/flower/metadata.c   |    70 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |     3 +
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |     4 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |     8 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c  |     6 +-
 drivers/net/ethernet/nvidia/forcedeth.c            |    10 +-
 .../ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c    |    12 +-
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |     3 -
 drivers/net/ethernet/pasemi/pasemi_mac_ethtool.c   |     4 +-
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    |     8 +-
 .../ethernet/qlogic/netxen/netxen_nic_ethtool.c    |     8 +-
 drivers/net/ethernet/qlogic/qed/qed_cxt.c          |    24 +-
 drivers/net/ethernet/qlogic/qed/qed_hsi.h          |    19 +
 .../net/ethernet/qlogic/qed/qed_init_fw_funcs.c    |   102 +
 drivers/net/ethernet/qlogic/qed/qed_int.c          |    22 +
 drivers/net/ethernet/qlogic/qed/qed_int.h          |    13 +
 drivers/net/ethernet/qlogic/qed/qed_main.c         |   100 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c          |    22 +
 drivers/net/ethernet/qlogic/qed/qed_mcp.h          |    22 +
 drivers/net/ethernet/qlogic/qed/qed_mfw_hsi.h      |     1 +
 drivers/net/ethernet/qlogic/qed/qed_reg_addr.h     |     2 +
 drivers/net/ethernet/qlogic/qed/qed_sp_commands.c  |    10 +-
 drivers/net/ethernet/qlogic/qed/qed_spq.c          |    42 +-
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c    |    21 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |     3 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |    91 +-
 drivers/net/ethernet/qlogic/qede/qede_ptp.c        |     5 -
 drivers/net/ethernet/qlogic/qla3xxx.c              |    11 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h        |     2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.h    |     2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  |     4 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c    |     8 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |    38 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h  |     2 +-
 .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |     9 +-
 drivers/net/ethernet/qualcomm/emac/emac-ethtool.c  |     8 +-
 drivers/net/ethernet/qualcomm/qca_debug.c          |     8 +-
 drivers/net/ethernet/realtek/8139cp.c              |     4 +-
 drivers/net/ethernet/realtek/r8169_main.c          |    67 +-
 drivers/net/ethernet/renesas/ravb_main.c           |    18 +-
 drivers/net/ethernet/renesas/sh_eth.c              |    11 +-
 drivers/net/ethernet/rocker/rocker_main.c          |    29 +-
 drivers/net/ethernet/rocker/rocker_ofdpa.c         |     3 +-
 drivers/net/ethernet/sfc/ef100_ethtool.c           |     7 +-
 drivers/net/ethernet/sfc/ef100_nic.c               |     6 +-
 drivers/net/ethernet/sfc/efx.c                     |     3 +-
 drivers/net/ethernet/sfc/efx_channels.c            |    15 +-
 drivers/net/ethernet/sfc/efx_common.c              |     1 +
 drivers/net/ethernet/sfc/ethtool.c                 |    14 +-
 drivers/net/ethernet/sfc/falcon/efx.c              |     2 +-
 drivers/net/ethernet/sfc/falcon/ethtool.c          |    14 +-
 drivers/net/ethernet/sfc/mcdi_port_common.c        |     4 +-
 drivers/net/ethernet/sfc/ptp.c                     |     3 -
 drivers/net/ethernet/sfc/rx.c                      |     2 +-
 drivers/net/ethernet/smsc/smc9194.c                |     6 +-
 drivers/net/ethernet/socionext/netsec.c            |    15 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |     1 +
 .../ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c    |    33 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c |     8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |     9 +-
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |     9 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   216 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |     5 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |   121 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c   |     4 +-
 drivers/net/ethernet/sun/cassini.c                 |    26 +-
 drivers/net/ethernet/tehuti/tehuti.c               |    40 +-
 drivers/net/ethernet/ti/am65-cpsw-ethtool.c        |     7 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |     2 +-
 drivers/net/ethernet/ti/cpmac.c                    |     8 +-
 drivers/net/ethernet/ti/cpsw_ethtool.c             |     8 +-
 drivers/net/ethernet/ti/cpsw_priv.c                |    28 +-
 drivers/net/ethernet/ti/cpsw_priv.h                |    10 +-
 drivers/net/ethernet/ti/davinci_emac.c             |    69 +-
 drivers/net/ethernet/ti/netcp_ethss.c              |     4 -
 drivers/net/ethernet/toshiba/spider_net.c          |    12 +-
 drivers/net/ethernet/toshiba/spider_net_ethtool.c  |     4 +-
 drivers/net/ethernet/vertexcom/Kconfig             |    25 +
 drivers/net/ethernet/vertexcom/Makefile            |     6 +
 drivers/net/ethernet/vertexcom/mse102x.c           |   769 ++
 drivers/net/ethernet/xilinx/ll_temac_main.c        |    14 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |    86 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |     9 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c           |     3 -
 drivers/net/fddi/skfp/hwmtm.c                      |     6 +-
 drivers/net/fddi/skfp/smt.c                        |    14 +-
 drivers/net/geneve.c                               |     9 +-
 drivers/net/hamradio/hdlcdrv.c                     |     1 +
 drivers/net/hamradio/scc.c                         |     1 +
 drivers/net/hyperv/netvsc.c                        |    10 +-
 drivers/net/hyperv/netvsc_bpf.c                    |     2 +-
 drivers/net/hyperv/netvsc_drv.c                    |     8 +-
 drivers/net/ifb.c                                  |   146 +-
 drivers/net/ipa/gsi.c                              |   114 +-
 drivers/net/ipa/gsi.h                              |    21 +-
 drivers/net/ipa/gsi_reg.h                          |     4 +
 drivers/net/ipa/ipa_data-v4.5.c                    |     7 +-
 drivers/net/ipa/ipa_endpoint.c                     |    93 +-
 drivers/net/ipa/ipa_main.c                         |     6 +-
 drivers/net/ipa/ipa_mem.c                          |     4 +-
 drivers/net/ipa/ipa_modem.c                        |    10 -
 drivers/net/ipa/ipa_modem.h                        |     3 -
 drivers/net/ipa/ipa_table.c                        |    48 +-
 drivers/net/ipvlan/ipvlan_core.c                   |     3 +-
 drivers/net/ipvlan/ipvlan_main.c                   |    11 +-
 drivers/net/loopback.c                             |     1 +
 drivers/net/macvlan.c                              |    11 +-
 drivers/net/mctp/Kconfig                           |    18 +
 drivers/net/mctp/Makefile                          |     1 +
 drivers/net/mctp/mctp-serial.c                     |   515 +
 drivers/net/mdio/Kconfig                           |     2 +-
 drivers/net/mdio/mdio-ipq8064.c                    |     2 +-
 drivers/net/mdio/mdio-mscc-miim.c                  |   176 +-
 drivers/net/netconsole.c                           |     2 +-
 drivers/net/netdevsim/dev.c                        |     4 +-
 drivers/net/netdevsim/ethtool.c                    |     8 +-
 drivers/net/pcs/pcs-lynx.c                         |    36 +-
 drivers/net/phy/dp83640.c                          |     3 -
 drivers/net/phy/dp83869.c                          |    42 +-
 drivers/net/phy/marvell.c                          |    26 +-
 drivers/net/phy/mdio_bus.c                         |    18 +-
 drivers/net/phy/micrel.c                           |    99 +
 drivers/net/phy/mscc/mscc_ptp.c                    |     3 -
 drivers/net/phy/nxp-c45-tja11xx.c                  |   220 +
 drivers/net/phy/phy-core.c                         |     2 +-
 drivers/net/phy/phylink.c                          |   492 +-
 drivers/net/ppp/ppp_generic.c                      |    12 +-
 drivers/net/tun.c                                  |     2 +-
 drivers/net/usb/ax88179_178a.c                     |    17 +-
 drivers/net/usb/lan78xx.c                          |  1214 +-
 drivers/net/usb/mcs7830.c                          |    12 +-
 drivers/net/usb/r8152.c                            |     8 +-
 drivers/net/veth.c                                 |    36 +-
 drivers/net/virtio_net.c                           |    10 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |    22 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c              |    10 +-
 drivers/net/vrf.c                                  |     9 +-
 drivers/net/vxlan.c                                |    10 +-
 drivers/net/wan/fsl_ucc_hdlc.c                     |    62 +-
 drivers/net/wan/ixp4xx_hss.c                       |   261 +-
 drivers/net/wan/lmc/lmc_main.c                     |     2 +-
 drivers/net/wireguard/queueing.h                   |     4 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |     4 +
 drivers/net/wireless/ath/ath10k/core.c             |    83 +-
 drivers/net/wireless/ath/ath10k/core.h             |     6 +
 drivers/net/wireless/ath/ath10k/coredump.c         |     6 +-
 drivers/net/wireless/ath/ath10k/htt.h              |   110 -
 drivers/net/wireless/ath/ath10k/htt_tx.c           |     3 +
 drivers/net/wireless/ath/ath10k/hw.h               |     3 +
 drivers/net/wireless/ath/ath10k/mac.c              |     9 +-
 drivers/net/wireless/ath/ath10k/txrx.c             |     2 -
 drivers/net/wireless/ath/ath10k/wmi.c              |    33 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |     4 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |    28 +-
 drivers/net/wireless/ath/ath11k/ce.c               |    55 +-
 drivers/net/wireless/ath/ath11k/ce.h               |     3 +-
 drivers/net/wireless/ath/ath11k/core.c             |   272 +-
 drivers/net/wireless/ath/ath11k/core.h             |    52 +-
 drivers/net/wireless/ath/ath11k/dbring.c           |    46 +-
 drivers/net/wireless/ath/ath11k/dbring.h           |     4 +-
 drivers/net/wireless/ath/ath11k/debug.c            |    12 +-
 drivers/net/wireless/ath/ath11k/debug.h            |     3 +-
 drivers/net/wireless/ath/ath11k/debugfs.c          |    41 +-
 drivers/net/wireless/ath/ath11k/debugfs.h          |     8 +
 drivers/net/wireless/ath/ath11k/debugfs_sta.c      |    78 +-
 drivers/net/wireless/ath/ath11k/debugfs_sta.h      |     2 -
 drivers/net/wireless/ath/ath11k/dp.c               |    49 +-
 drivers/net/wireless/ath/ath11k/dp.h               |    58 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   686 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |   247 +-
 drivers/net/wireless/ath/ath11k/dp_tx.h            |     3 +
 drivers/net/wireless/ath/ath11k/hal.c              |    57 +-
 drivers/net/wireless/ath/ath11k/hal.h              |     3 +
 drivers/net/wireless/ath/ath11k/hal_desc.h         |    19 +
 drivers/net/wireless/ath/ath11k/hal_rx.c           |    74 +-
 drivers/net/wireless/ath/ath11k/hal_rx.h           |    56 +-
 drivers/net/wireless/ath/ath11k/htc.c              |    71 +-
 drivers/net/wireless/ath/ath11k/htc.h              |     9 +-
 drivers/net/wireless/ath/ath11k/hw.c               |    16 +-
 drivers/net/wireless/ath/ath11k/hw.h               |    34 +-
 drivers/net/wireless/ath/ath11k/mac.c              |   962 +-
 drivers/net/wireless/ath/ath11k/mac.h              |    17 +
 drivers/net/wireless/ath/ath11k/mhi.c              |    49 +-
 drivers/net/wireless/ath/ath11k/pci.c              |   246 +-
 drivers/net/wireless/ath/ath11k/pci.h              |     3 +
 drivers/net/wireless/ath/ath11k/peer.h             |     1 +
 drivers/net/wireless/ath/ath11k/qmi.c              |   214 +-
 drivers/net/wireless/ath/ath11k/qmi.h              |    17 +-
 drivers/net/wireless/ath/ath11k/reg.c              |   120 +-
 drivers/net/wireless/ath/ath11k/spectral.c         |    14 +
 drivers/net/wireless/ath/ath11k/trace.c            |     1 +
 drivers/net/wireless/ath/ath11k/trace.h            |   200 +
 drivers/net/wireless/ath/ath11k/wmi.c              |   633 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |   119 +-
 drivers/net/wireless/ath/ath5k/base.c              |    50 +-
 drivers/net/wireless/ath/ath6kl/htc.h              |    19 +-
 drivers/net/wireless/ath/ath6kl/htc_mbox.c         |    15 +-
 drivers/net/wireless/ath/ath9k/ar9002_mac.c        |     2 +-
 drivers/net/wireless/ath/ath9k/ar9003_calib.c      |    14 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |     7 +
 drivers/net/wireless/ath/ath9k/htc.h               |     2 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |    13 +
 drivers/net/wireless/ath/ath9k/wmi.c               |     4 +
 drivers/net/wireless/ath/ath9k/xmit.c              |    45 +-
 drivers/net/wireless/ath/carl9170/main.c           |     9 +-
 drivers/net/wireless/ath/carl9170/tx.c             |    12 +-
 drivers/net/wireless/ath/regd.h                    |     1 +
 drivers/net/wireless/ath/regd_common.h             |     3 +
 drivers/net/wireless/ath/wcn36xx/dxe.c             |    96 +-
 drivers/net/wireless/ath/wcn36xx/dxe.h             |     1 +
 drivers/net/wireless/ath/wcn36xx/hal.h             |    29 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |    74 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |   125 +-
 drivers/net/wireless/ath/wcn36xx/smd.h             |     5 +-
 drivers/net/wireless/ath/wcn36xx/txrx.c            |    41 +-
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h         |     1 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |    21 +
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |    19 +
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |     2 +-
 drivers/net/wireless/intel/iwlwifi/Kconfig         |    26 +
 drivers/net/wireless/intel/iwlwifi/Makefile        |     1 +
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |    85 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |     8 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |    51 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |    23 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/alive.h  |    26 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |    23 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h     |    81 +-
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   |    62 +
 .../net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h    |    35 +-
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |    30 +-
 .../net/wireless/intel/iwlwifi/fw/api/phy-ctxt.h   |     9 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h  |    22 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     |    56 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |    93 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/stats.h  |    92 +-
 .../intel/iwlwifi/fw/api/{soc.h => system.h}       |    16 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |    11 +
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |    28 +-
 drivers/net/wireless/intel/iwlwifi/fw/dump.c       |   153 +-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |    18 +
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |     1 -
 drivers/net/wireless/intel/iwlwifi/fw/img.c        |     6 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |     4 +
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |     2 +-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |     7 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c       |    88 +
 drivers/net/wireless/intel/iwlwifi/fw/uefi.h       |    20 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |    15 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |    24 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |    70 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |    96 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.c  |     4 +
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h        |     2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        |     2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |    69 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h |    11 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |     9 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |    28 +-
 drivers/net/wireless/intel/iwlwifi/mei/Makefile    |     8 +
 drivers/net/wireless/intel/iwlwifi/mei/internal.h  |    20 +
 drivers/net/wireless/intel/iwlwifi/mei/iwl-mei.h   |   505 +
 drivers/net/wireless/intel/iwlwifi/mei/main.c      |  2001 +++
 drivers/net/wireless/intel/iwlwifi/mei/net.c       |   409 +
 drivers/net/wireless/intel/iwlwifi/mei/sap.h       |   733 ++
 .../net/wireless/intel/iwlwifi/mei/trace-data.h    |    82 +
 drivers/net/wireless/intel/iwlwifi/mei/trace.c     |    15 +
 drivers/net/wireless/intel/iwlwifi/mei/trace.h     |    76 +
 drivers/net/wireless/intel/iwlwifi/mvm/Makefile    |     1 +
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |     2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   184 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |     9 +
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |     4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    |     2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   227 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   189 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |    87 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   261 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |    62 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rfi.c       |    48 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |   105 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |   261 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |    53 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |    91 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |    10 +
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |     4 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |    36 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   109 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |    51 +-
 .../net/wireless/intel/iwlwifi/mvm/vendor-cmd.c    |   152 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   343 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |     7 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |    13 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   136 +-
 drivers/net/wireless/intel/iwlwifi/queue/tx.c      |     8 +-
 drivers/net/wireless/intersil/hostap/hostap_hw.c   |     5 +-
 drivers/net/wireless/intersil/hostap/hostap_wlan.h |    14 +-
 drivers/net/wireless/intersil/p54/txrx.c           |     6 +-
 drivers/net/wireless/mac80211_hwsim.c              |     2 +-
 drivers/net/wireless/marvell/libertas/host.h       |    10 +-
 drivers/net/wireless/marvell/libertas/tx.c         |     5 +-
 .../net/wireless/marvell/libertas_tf/libertas_tf.h |    36 +-
 drivers/net/wireless/marvell/libertas_tf/main.c    |     3 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |     4 +-
 drivers/net/wireless/marvell/mwifiex/init.c        |     2 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |    18 +
 drivers/net/wireless/marvell/mwifiex/main.h        |     5 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c        |     3 +
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |    28 +-
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |    11 +-
 drivers/net/wireless/marvell/mwifiex/usb.c         |     3 +-
 drivers/net/wireless/marvell/mwl8k.c               |    10 +-
 drivers/net/wireless/mediatek/mt76/debugfs.c       |     2 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |    19 +-
 drivers/net/wireless/mediatek/mt76/eeprom.c        |     2 +
 drivers/net/wireless/mediatek/mt76/mac80211.c      |    90 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |    12 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |     9 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |    31 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c    |     4 +-
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |     3 +
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |     1 +
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   122 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h    |     2 +
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |    15 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |   200 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h    |   127 -
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |     1 +
 .../net/wireless/mediatek/mt76/mt7615/pci_init.c   |     8 +-
 .../net/wireless/mediatek/mt76/mt7615/testmode.c   |    25 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_mcu.c    |     2 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |     3 -
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   169 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |   521 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |     5 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |    34 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |     2 +
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |     1 +
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |     1 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |     2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |     4 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/init.c   |    29 +
 drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h |     2 +
 .../net/wireless/mediatek/mt76/mt76x2/pci_init.c   |     5 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_main.c   |     7 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_init.c   |     4 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_main.c   |     9 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |   227 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |    83 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |     3 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |   205 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |    70 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   267 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |   841 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |    27 +-
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |     1 +
 .../net/wireless/mediatek/mt76/mt7915/testmode.c   |    17 +-
 .../net/wireless/mediatek/mt76/mt7921/debugfs.c    |    12 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |    12 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |   136 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |    83 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   160 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h    |   153 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |     2 +
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |    25 +-
 .../net/wireless/mediatek/mt76/mt7921/pci_mac.c    |     4 +
 .../net/wireless/mediatek/mt76/mt7921/pci_mcu.c    |     4 +-
 drivers/net/wireless/mediatek/mt76/mt7921/sdio.c   |    51 +-
 .../net/wireless/mediatek/mt76/mt7921/sdio_mac.c   |     2 +-
 .../net/wireless/mediatek/mt76/mt7921/sdio_mcu.c   |     2 +-
 .../net/wireless/mediatek/mt76/mt7921/testmode.c   |     4 +-
 drivers/net/wireless/mediatek/mt76/sdio.c          |    11 +-
 drivers/net/wireless/mediatek/mt76/sdio_txrx.c     |     3 +-
 drivers/net/wireless/mediatek/mt76/testmode.c      |    36 +-
 drivers/net/wireless/mediatek/mt76/testmode.h      |     6 +
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |    10 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      |     5 +-
 drivers/net/wireless/microchip/wilc1000/netdev.c   |    28 +-
 drivers/net/wireless/microchip/wilc1000/netdev.h   |     2 +
 drivers/net/wireless/microchip/wilc1000/sdio.c     |     2 +
 drivers/net/wireless/microchip/wilc1000/spi.c      |    80 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c     |    41 +-
 drivers/net/wireless/microchip/wilc1000/wlan.h     |     2 -
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |     4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    |     1 +
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   |    17 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |     1 -
 drivers/net/wireless/realtek/rtw88/Makefile        |     1 +
 drivers/net/wireless/realtek/rtw88/bf.c            |    14 +-
 drivers/net/wireless/realtek/rtw88/bf.h            |     7 +-
 drivers/net/wireless/realtek/rtw88/debug.c         |   100 +-
 drivers/net/wireless/realtek/rtw88/debug.h         |     1 +
 drivers/net/wireless/realtek/rtw88/fw.c            |   388 +
 drivers/net/wireless/realtek/rtw88/fw.h            |   143 +
 drivers/net/wireless/realtek/rtw88/mac80211.c      |    91 +-
 drivers/net/wireless/realtek/rtw88/main.c          |    88 +-
 drivers/net/wireless/realtek/rtw88/main.h          |    77 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |    69 +-
 drivers/net/wireless/realtek/rtw88/pci.h           |     2 +
 drivers/net/wireless/realtek/rtw88/phy.c           |    63 +-
 drivers/net/wireless/realtek/rtw88/phy.h           |     1 +
 drivers/net/wireless/realtek/rtw88/ps.c            |     3 +
 drivers/net/wireless/realtek/rtw88/ps.h            |     1 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |     3 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.h      |     2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |     4 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |    14 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.h      |     4 +
 drivers/net/wireless/realtek/rtw88/rx.c            |    10 +
 drivers/net/wireless/realtek/rtw88/sar.c           |   114 +
 drivers/net/wireless/realtek/rtw88/sar.h           |    22 +
 drivers/net/wireless/realtek/rtw88/tx.c            |    36 +-
 drivers/net/wireless/realtek/rtw89/cam.c           |    61 +-
 drivers/net/wireless/realtek/rtw89/cam.h           |   472 +-
 drivers/net/wireless/realtek/rtw89/coex.c          |    73 +-
 drivers/net/wireless/realtek/rtw89/coex.h          |     6 +
 drivers/net/wireless/realtek/rtw89/core.c          |    93 +-
 drivers/net/wireless/realtek/rtw89/core.h          |    39 +-
 drivers/net/wireless/realtek/rtw89/debug.c         |    11 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |     7 +-
 drivers/net/wireless/realtek/rtw89/fw.h            |  2170 ++--
 drivers/net/wireless/realtek/rtw89/mac.c           |    21 +-
 drivers/net/wireless/realtek/rtw89/mac.h           |    11 +
 drivers/net/wireless/realtek/rtw89/mac80211.c      |     7 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |   158 +-
 drivers/net/wireless/realtek/rtw89/phy.h           |    60 +
 drivers/net/wireless/realtek/rtw89/reg.h           |    25 +-
 drivers/net/wireless/realtek/rtw89/regd.c          |   375 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |    25 +-
 .../net/wireless/realtek/rtw89/rtw8852a_table.c    | 12201 +++++++++++--------
 drivers/net/wireless/realtek/rtw89/txrx.h          |    91 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |     3 +
 drivers/net/wireless/rsi/rsi_91x_main.c            |     4 +
 drivers/net/wireless/rsi/rsi_91x_usb.c             |     9 +-
 drivers/net/wireless/rsi/rsi_usb.h                 |     2 +
 drivers/net/wireless/ti/wl1251/main.c              |     6 +
 drivers/net/wireless/ti/wlcore/sdio.c              |     2 +-
 drivers/net/wwan/Kconfig                           |    25 +
 drivers/net/wwan/Makefile                          |     1 +
 drivers/net/wwan/iosm/Makefile                     |     4 +
 drivers/net/wwan/iosm/iosm_ipc_debugfs.c           |    29 +
 drivers/net/wwan/iosm/iosm_ipc_debugfs.h           |    17 +
 drivers/net/wwan/iosm/iosm_ipc_imem.c              |    11 +-
 drivers/net/wwan/iosm/iosm_ipc_imem.h              |     8 +
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c          |    13 +-
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h          |     9 +-
 drivers/net/wwan/iosm/iosm_ipc_mmio.c              |     2 +-
 drivers/net/wwan/iosm/iosm_ipc_mux.c               |    28 +-
 drivers/net/wwan/iosm/iosm_ipc_mux.h               |     1 -
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c         |    18 +-
 drivers/net/wwan/iosm/iosm_ipc_pcie.c              |    49 +-
 drivers/net/wwan/iosm/iosm_ipc_port.c              |     2 +-
 drivers/net/wwan/iosm/iosm_ipc_trace.c             |   182 +
 drivers/net/wwan/iosm/iosm_ipc_trace.h             |    74 +
 drivers/net/wwan/iosm/iosm_ipc_wwan.c              |     3 +-
 drivers/net/wwan/iosm/iosm_ipc_wwan.h              |    10 -
 drivers/net/wwan/qcom_bam_dmux.c                   |   907 ++
 drivers/net/wwan/wwan_core.c                       |    39 +-
 drivers/net/xen-netfront.c                         |     2 +-
 drivers/nfc/fdp/i2c.c                              |     4 +-
 drivers/nfc/st21nfca/i2c.c                         |     4 +-
 drivers/pcmcia/pcmcia_cis.c                        |     3 +-
 drivers/phy/marvell/phy-mvebu-cp110-comphy.c       |     9 +
 drivers/ptp/ptp_ines.c                             |     4 -
 drivers/ptp/ptp_vclock.c                           |    10 +-
 drivers/s390/net/ctcm_dbug.h                       |     1 +
 drivers/s390/net/ctcm_fsms.c                       |     2 +-
 drivers/s390/net/lcs.c                             |    11 +-
 drivers/s390/net/qeth_core.h                       |     4 +-
 drivers/s390/net/qeth_core_main.c                  |    89 +-
 drivers/s390/net/qeth_ethtool.c                    |     4 +-
 drivers/s390/net/qeth_l2_main.c                    |    52 +-
 drivers/s390/net/qeth_l3_main.c                    |    13 +-
 drivers/staging/rtl8192e/rtllib_softmac.c          |     2 +-
 fs/nfs/dir.c                                       |     1 +
 fs/nfs/fs_context.c                                |     1 +
 fs/proc/proc_net.c                                 |    19 +-
 fs/select.c                                        |     1 +
 include/asm-generic/sections.h                     |    14 +-
 include/linux/atalk.h                              |     2 +-
 include/linux/avf/virtchnl.h                       |   377 +
 include/linux/bpf-cgroup-defs.h                    |    70 +
 include/linux/bpf-cgroup.h                         |    57 +-
 include/linux/bpf-netns.h                          |     8 +-
 include/linux/bpf.h                                |   139 +-
 include/linux/bpf_local_storage.h                  |     6 +
 include/linux/bpf_verifier.h                       |    34 +
 include/linux/btf.h                                |    89 +-
 include/linux/btf_ids.h                            |    20 +-
 include/linux/can/bittiming.h                      |     7 -
 include/linux/can/dev.h                            |    24 +-
 include/linux/can/skb.h                            |     5 +-
 include/linux/cgroup-defs.h                        |     2 +-
 include/linux/dsa/8021q.h                          |     9 +-
 include/linux/dsa/loop.h                           |     1 +
 include/linux/dsa/ocelot.h                         |    12 +-
 include/linux/dsa/sja1105.h                        |    62 +-
 include/linux/ethtool.h                            |    26 +-
 include/linux/filter.h                             |    13 +-
 include/linux/ieee80211.h                          |    11 +-
 include/linux/if_eql.h                             |     1 +
 include/linux/if_vlan.h                            |     3 +
 include/linux/inetdevice.h                         |     2 +
 include/linux/mdio.h                               |    12 +
 include/linux/mdio/mdio-mscc-miim.h                |    19 +
 include/linux/mei_cl_bus.h                         |     3 +
 include/linux/mlx5/device.h                        |     1 +
 include/linux/mlx5/driver.h                        |     4 +
 include/linux/mlx5/eq.h                            |     4 +-
 include/linux/mlx5/fs.h                            |     1 +
 include/linux/mlx5/mlx5_ifc.h                      |    37 +-
 include/linux/mmc/sdio_ids.h                       |     1 +
 include/linux/mroute_base.h                        |     2 +
 include/linux/net/intel/iidc.h                     |     7 +-
 include/linux/netdevice.h                          |   529 +-
 include/linux/netfilter.h                          |    10 +-
 include/linux/netfilter/nf_conntrack_common.h      |    10 +-
 include/linux/netfilter_netdev.h                   |     2 +-
 include/linux/netpoll.h                            |     1 +
 include/linux/once.h                               |     2 +-
 include/linux/pcs-lynx.h                           |     9 +-
 include/linux/perf_event.h                         |     1 +
 include/linux/phy.h                                |     2 +-
 include/linux/phylink.h                            |    96 +-
 include/linux/ptp_clock_kernel.h                   |    12 +-
 include/linux/qed/qed_if.h                         |    14 +
 include/linux/ref_tracker.h                        |    73 +
 include/linux/regmap.h                             |     7 +
 include/linux/rfkill.h                             |     7 +
 include/linux/seq_file_net.h                       |     3 +-
 include/linux/siphash.h                            |     2 +
 include/linux/skbuff.h                             |   108 +-
 include/linux/skmsg.h                              |     6 -
 include/linux/stmmac.h                             |     2 +
 include/linux/tcp.h                                |     2 +
 include/linux/u64_stats_sync.h                     |    42 +-
 include/linux/wwan.h                               |    18 +-
 include/net/act_api.h                              |    27 +-
 include/net/af_unix.h                              |     3 +-
 include/net/arp.h                                  |     8 +-
 include/net/ax25.h                                 |     3 +
 include/net/bareudp.h                              |    13 +-
 include/net/bluetooth/bluetooth.h                  |     9 +
 include/net/bluetooth/hci.h                        |    82 +-
 include/net/bluetooth/hci_core.h                   |    73 +-
 include/net/bluetooth/hci_sync.h                   |   108 +
 include/net/bluetooth/mgmt.h                       |     9 +-
 include/net/bond_options.h                         |     1 +
 include/net/bonding.h                              |     1 +
 include/net/cfg80211.h                             |    90 +-
 include/net/checksum.h                             |     4 +
 include/net/codel.h                                |     2 -
 include/net/codel_impl.h                           |     2 +
 include/net/codel_qdisc.h                          |     2 +
 include/net/devlink.h                              |    46 +-
 include/net/dsa.h                                  |   281 +-
 include/net/dst.h                                  |     1 +
 include/net/failover.h                             |     1 +
 include/net/fib_rules.h                            |    21 -
 include/net/flow_offload.h                         |    20 +-
 include/net/gro.h                                  |   421 +-
 include/net/if_inet6.h                             |     1 +
 include/net/inet_connection_sock.h                 |     2 +-
 include/net/inet_sock.h                            |    12 +
 include/net/ip.h                                   |     9 +-
 include/net/ip6_checksum.h                         |    20 +-
 include/net/ip6_fib.h                              |     1 +
 include/net/ip6_route.h                            |    18 +-
 include/net/ip6_tunnel.h                           |     1 +
 include/net/ip_fib.h                               |     2 +
 include/net/ip_tunnels.h                           |     3 +
 include/net/ipv6.h                                 |     4 +-
 include/net/iucv/af_iucv.h                         |    10 +-
 include/net/llc_conn.h                             |     1 +
 include/net/mac80211.h                             |    57 +-
 include/net/ndisc.h                                |    16 +-
 include/net/neighbour.h                            |    14 +
 include/net/net_namespace.h                        |    34 +
 include/net/net_trackers.h                         |    18 +
 include/net/netfilter/nf_conntrack.h               |    11 +-
 include/net/netfilter/nf_conntrack_act_ct.h        |    50 +
 include/net/netfilter/nf_conntrack_extend.h        |     4 +
 include/net/netfilter/nf_tables.h                  |    40 +-
 include/net/netfilter/nf_tables_core.h             |     6 +
 include/net/netns/bpf.h                            |     9 +-
 include/net/netns/core.h                           |     1 -
 include/net/netns/ipv4.h                           |     3 +
 include/net/page_pool.h                            |    11 +-
 include/net/pkt_cls.h                              |    46 +-
 include/net/pkt_sched.h                            |     4 +-
 include/net/route.h                                |     1 +
 include/net/sch_generic.h                          |     2 +-
 include/net/sctp/sctp.h                            |     4 +-
 include/net/sctp/structs.h                         |    15 +-
 include/net/sock.h                                 |   112 +-
 include/net/tc_act/tc_gate.h                       |     5 -
 include/net/tc_act/tc_mirred.h                     |     1 +
 include/net/tcp.h                                  |    18 +-
 include/net/udp.h                                  |    24 -
 include/net/vxlan.h                                |     1 +
 include/net/xdp.h                                  |     3 +
 include/net/xdp_priv.h                             |     1 -
 include/net/xdp_sock.h                             |     1 +
 include/net/xfrm.h                                 |    10 +-
 include/soc/mscc/ocelot.h                          |    66 +-
 include/soc/mscc/ocelot_ana.h                      |    10 +
 include/soc/mscc/ocelot_vcap.h                     |     1 +
 include/soc/mscc/vsc7514_regs.h                    |    29 +
 include/trace/events/skb.h                         |    41 +-
 include/uapi/linux/bpf.h                           |   165 +-
 include/uapi/linux/btf.h                           |     3 +-
 include/uapi/linux/can/netlink.h                   |    13 +
 include/uapi/linux/ethtool.h                       |     1 +
 include/uapi/linux/ethtool_netlink.h               |     1 +
 include/uapi/linux/if_link.h                       |     2 +
 include/uapi/linux/net_tstamp.h                    |    17 +-
 include/uapi/linux/nl80211.h                       |    63 +-
 include/uapi/linux/pfkeyv2.h                       |     2 +
 include/uapi/linux/pkt_cls.h                       |     9 +-
 include/uapi/linux/rtnetlink.h                     |     2 +
 include/uapi/linux/smc.h                           |     2 +
 include/uapi/linux/smc_diag.h                      |    11 +-
 include/uapi/linux/tty.h                           |     1 +
 include/uapi/linux/xfrm.h                          |     1 +
 include/uapi/rdma/mlx5_user_ioctl_cmds.h           |     2 +-
 kernel/bpf/Makefile                                |     4 +
 kernel/bpf/bloom_filter.c                          |     6 +
 kernel/bpf/bpf_inode_storage.c                     |     6 +-
 kernel/bpf/bpf_iter.c                              |    35 +
 kernel/bpf/bpf_local_storage.c                     |    50 +-
 kernel/bpf/bpf_struct_ops.c                        |     6 +-
 kernel/bpf/bpf_task_storage.c                      |    10 +-
 kernel/bpf/btf.c                                   |   541 +-
 kernel/bpf/cgroup.c                                |     2 +-
 kernel/bpf/core.c                                  |     6 +-
 kernel/bpf/cpumap.c                                |    12 +-
 kernel/bpf/devmap.c                                |    36 +-
 kernel/bpf/helpers.c                               |    31 +-
 kernel/bpf/local_storage.c                         |     3 +-
 kernel/bpf/lpm_trie.c                              |     2 +-
 kernel/bpf/map_iter.c                              |     4 +-
 kernel/bpf/mmap_unlock_work.h                      |    65 +
 kernel/bpf/net_namespace.c                         |     1 +
 kernel/bpf/reuseport_array.c                       |     6 +-
 kernel/bpf/ringbuf.c                               |     2 +-
 kernel/bpf/stackmap.c                              |    82 +-
 kernel/bpf/syscall.c                               |     7 +-
 kernel/bpf/task_iter.c                             |    82 +-
 kernel/bpf/trampoline.c                            |     8 +
 kernel/bpf/verifier.c                              |   913 +-
 kernel/cgroup/cgroup.c                             |     1 +
 kernel/sysctl.c                                    |     1 +
 kernel/trace/bpf_trace.c                           |    93 +-
 kernel/trace/trace_kprobe.c                        |     1 +
 kernel/trace/trace_uprobe.c                        |     1 +
 lib/Kconfig                                        |     5 +
 lib/Kconfig.debug                                  |    15 +
 lib/Makefile                                       |     4 +-
 lib/objagg.c                                       |     7 +-
 lib/ref_tracker.c                                  |   140 +
 lib/test_bpf.c                                     |     4 +-
 lib/test_ref_tracker.c                             |   115 +
 net/802/hippi.c                                    |     2 +-
 net/8021q/vlan.c                                   |     4 +-
 net/8021q/vlan_core.c                              |     7 +-
 net/8021q/vlan_dev.c                               |     8 +-
 net/8021q/vlanproc.c                               |     2 +-
 net/Kconfig                                        |     5 +
 net/Kconfig.debug                                  |    19 +
 net/ax25/af_ax25.c                                 |    10 +-
 net/ax25/ax25_dev.c                                |     8 +-
 net/batman-adv/main.h                              |     2 +-
 net/batman-adv/netlink.c                           |    30 +-
 net/batman-adv/network-coding.c                    |     8 +-
 net/bluetooth/Makefile                             |     2 +-
 net/bluetooth/aosp.c                               |   168 +-
 net/bluetooth/aosp.h                               |    13 +
 net/bluetooth/bnep/sock.c                          |     1 +
 net/bluetooth/cmtp/core.c                          |     4 +-
 net/bluetooth/eir.h                                |     2 +
 net/bluetooth/hci_codec.c                          |    18 +-
 net/bluetooth/hci_conn.c                           |   325 +-
 net/bluetooth/hci_core.c                           |  1356 +--
 net/bluetooth/hci_event.c                          |  3329 ++---
 net/bluetooth/hci_request.c                        |   567 +-
 net/bluetooth/hci_request.h                        |    18 +-
 net/bluetooth/hci_sock.c                           |    16 +-
 net/bluetooth/hci_sync.c                           |  5281 ++++++++
 net/bluetooth/hci_sysfs.c                          |     2 +
 net/bluetooth/hidp/sock.c                          |     1 +
 net/bluetooth/l2cap_core.c                         |     2 +-
 net/bluetooth/l2cap_sock.c                         |    46 +-
 net/bluetooth/mgmt.c                               |  2408 ++--
 net/bluetooth/mgmt_util.c                          |    81 +-
 net/bluetooth/mgmt_util.h                          |     8 +
 net/bluetooth/msft.c                               |   513 +-
 net/bluetooth/msft.h                               |    20 +-
 net/bridge/br_if.c                                 |    18 +-
 net/bridge/br_ioctl.c                              |    76 +-
 net/bridge/br_netfilter_hooks.c                    |     7 +-
 net/bridge/br_private.h                            |     1 +
 net/bridge/br_sysfs_br.c                           |     7 +-
 net/bridge/br_vlan.c                               |     4 +-
 net/bridge/netfilter/nft_meta_bridge.c             |    20 +
 net/caif/caif_socket.c                             |     1 +
 net/caif/cfserl.c                                  |     1 -
 net/can/isotp.c                                    |     4 +-
 net/core/Makefile                                  |     4 +-
 net/core/bpf_sk_storage.c                          |    10 +-
 net/core/dev.c                                     |   735 +-
 net/core/dev_addr_lists.c                          |    93 +-
 net/core/dev_addr_lists_test.c                     |   236 +
 net/core/dev_ioctl.c                               |     7 +-
 net/core/devlink.c                                 |    81 +-
 net/core/drop_monitor.c                            |    16 +-
 net/core/dst.c                                     |     8 +-
 net/core/failover.c                                |     4 +-
 net/core/fib_rules.c                               |    25 +-
 net/core/filter.c                                  |   187 +-
 net/core/flow_dissector.c                          |     3 +-
 net/core/flow_offload.c                            |    46 +-
 net/core/gro.c                                     |   770 ++
 net/core/link_watch.c                              |    17 +-
 net/core/lwt_bpf.c                                 |     1 +
 net/core/neighbour.c                               |    22 +-
 net/core/net-sysfs.c                               |    34 +-
 net/core/net_namespace.c                           |     3 +
 net/core/netpoll.c                                 |     4 +-
 net/core/of_net.c                                  |    33 +-
 net/core/page_pool.c                               |    10 +-
 net/core/pktgen.c                                  |     8 +-
 net/core/rtnetlink.c                               |    37 +-
 net/core/secure_seq.c                              |     4 +-
 net/core/skbuff.c                                  |   198 +-
 net/core/sock.c                                    |    71 +-
 net/core/sock_diag.c                               |     1 +
 net/core/sock_map.c                                |    23 +-
 net/core/sysctl_net_core.c                         |     1 +
 net/core/xdp.c                                     |   104 +-
 net/dccp/proto.c                                   |    27 +-
 net/dccp/trace.h                                   |     4 +-
 net/decnet/dn_nsp_in.c                             |     1 +
 net/decnet/dn_rules.c                              |     5 -
 net/dsa/dsa.c                                      |     2 +-
 net/dsa/dsa2.c                                     |   201 +-
 net/dsa/dsa_priv.h                                 |    91 +-
 net/dsa/master.c                                   |    29 +-
 net/dsa/port.c                                     |   252 +-
 net/dsa/slave.c                                    |    64 +-
 net/dsa/switch.c                                   |   132 +-
 net/dsa/tag_8021q.c                                |    20 +-
 net/dsa/tag_dsa.c                                  |     5 +-
 net/dsa/tag_ocelot.c                               |     2 +-
 net/dsa/tag_ocelot_8021q.c                         |    52 +-
 net/dsa/tag_sja1105.c                              |   214 +-
 net/ethernet/eth.c                                 |     7 +-
 net/ethtool/cabletest.c                            |     4 +-
 net/ethtool/channels.c                             |     2 +-
 net/ethtool/coalesce.c                             |     2 +-
 net/ethtool/common.c                               |     1 +
 net/ethtool/debug.c                                |     2 +-
 net/ethtool/eee.c                                  |     2 +-
 net/ethtool/features.c                             |     3 +-
 net/ethtool/fec.c                                  |     2 +-
 net/ethtool/ioctl.c                                |    28 +-
 net/ethtool/linkinfo.c                             |     2 +-
 net/ethtool/linkmodes.c                            |     2 +-
 net/ethtool/module.c                               |     2 +-
 net/ethtool/netlink.c                              |     9 +-
 net/ethtool/netlink.h                              |     9 +-
 net/ethtool/pause.c                                |     2 +-
 net/ethtool/privflags.c                            |     2 +-
 net/ethtool/rings.c                                |    34 +-
 net/ethtool/stats.c                                |    15 +-
 net/ethtool/tunnels.c                              |     6 +-
 net/ethtool/wol.c                                  |     2 +-
 net/hsr/hsr_device.c                               |     6 +-
 net/ieee802154/socket.c                            |     4 +-
 net/ipv4/af_inet.c                                 |    31 +-
 net/ipv4/arp.c                                     |    33 +-
 net/ipv4/bpf_tcp_ca.c                              |     6 +-
 net/ipv4/devinet.c                                 |     4 +-
 net/ipv4/esp4_offload.c                            |     1 +
 net/ipv4/fib_rules.c                               |     6 -
 net/ipv4/fib_semantics.c                           |    12 +-
 net/ipv4/fou.c                                     |    26 +-
 net/ipv4/gre_offload.c                             |    13 +-
 net/ipv4/igmp.c                                    |     1 -
 net/ipv4/inet_connection_sock.c                    |     2 +-
 net/ipv4/inet_hashtables.c                         |     8 +-
 net/ipv4/ip_output.c                               |     1 -
 net/ipv4/ip_sockglue.c                             |     2 +-
 net/ipv4/ipmr.c                                    |     8 +-
 net/ipv4/netfilter/Kconfig                         |     8 +-
 net/ipv4/netfilter/Makefile                        |     3 -
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |     5 +-
 net/ipv4/netfilter/nf_flow_table_ipv4.c            |    37 -
 net/ipv4/nexthop.c                                 |     9 +-
 net/ipv4/ping.c                                    |    15 +-
 net/ipv4/raw.c                                     |    15 +-
 net/ipv4/route.c                                   |    83 +-
 net/ipv4/syncookies.c                              |     2 +-
 net/ipv4/tcp.c                                     |    95 +-
 net/ipv4/tcp_bpf.c                                 |    27 +
 net/ipv4/tcp_input.c                               |    18 +-
 net/ipv4/tcp_ipv4.c                                |    25 +-
 net/ipv4/tcp_offload.c                             |     1 +
 net/ipv4/tcp_output.c                              |     2 +-
 net/ipv4/udp.c                                     |    22 +-
 net/ipv4/udp_offload.c                             |    32 +-
 net/ipv4/xfrm4_policy.c                            |     2 +-
 net/ipv6/addrconf.c                                |     4 +-
 net/ipv6/addrconf_core.c                           |     2 +-
 net/ipv6/af_inet6.c                                |     9 +-
 net/ipv6/ah6.c                                     |     5 +-
 net/ipv6/esp6.c                                    |     3 +-
 net/ipv6/esp6_offload.c                            |     1 +
 net/ipv6/exthdrs.c                                 |     1 -
 net/ipv6/fib6_rules.c                              |     5 -
 net/ipv6/inet6_hashtables.c                        |     8 +-
 net/ipv6/ioam6.c                                   |    16 +-
 net/ipv6/ip6_fib.c                                 |     1 +
 net/ipv6/ip6_gre.c                                 |    13 +-
 net/ipv6/ip6_offload.c                             |    14 +-
 net/ipv6/ip6_output.c                              |     2 +-
 net/ipv6/ip6_tunnel.c                              |     4 +-
 net/ipv6/ip6_vti.c                                 |     4 +-
 net/ipv6/ip6mr.c                                   |     8 +-
 net/ipv6/ipv6_sockglue.c                           |    17 +-
 net/ipv6/netfilter/Kconfig                         |     8 +-
 net/ipv6/netfilter/nf_flow_table_ipv6.c            |    38 -
 net/ipv6/ping.c                                    |     1 +
 net/ipv6/route.c                                   |    38 +-
 net/ipv6/seg6_local.c                              |     1 +
 net/ipv6/sit.c                                     |     4 +-
 net/ipv6/syncookies.c                              |     2 +-
 net/ipv6/tcp_ipv6.c                                |    11 +-
 net/ipv6/tcpv6_offload.c                           |     1 +
 net/ipv6/udp.c                                     |    10 +-
 net/ipv6/udp_offload.c                             |     3 +-
 net/ipv6/xfrm6_policy.c                            |     4 +-
 net/iucv/af_iucv.c                                 |    41 +-
 net/iucv/iucv.c                                    |   124 +-
 net/kcm/kcmsock.c                                  |     1 +
 net/l2tp/l2tp_core.c                               |    52 +-
 net/l2tp/l2tp_core.h                               |     2 +-
 net/l2tp/l2tp_debugfs.c                            |    22 +-
 net/llc/af_llc.c                                   |     5 +-
 net/llc/llc_proc.c                                 |     2 +-
 net/mac80211/cfg.c                                 |    45 +-
 net/mac80211/debugfs_sta.c                         |     9 +-
 net/mac80211/driver-ops.h                          |    22 +
 net/mac80211/ethtool.c                             |     8 +-
 net/mac80211/ieee80211_i.h                         |     2 +-
 net/mac80211/iface.c                               |    59 +
 net/mac80211/main.c                                |    13 +-
 net/mac80211/mlme.c                                |    67 +-
 net/mac80211/rc80211_minstrel_ht.c                 |     2 -
 net/mac80211/rx.c                                  |     9 +-
 net/mac80211/trace.h                               |     7 +
 net/mac80211/tx.c                                  |    10 +-
 net/mac80211/util.c                                |    13 +
 net/mac80211/wpa.c                                 |     4 -
 net/mctp/af_mctp.c                                 |     3 +-
 net/mctp/device.c                                  |    53 +-
 net/mctp/route.c                                   |     7 +-
 net/mctp/test/route-test.c                         |     5 -
 net/mpls/af_mpls.c                                 |     8 +-
 net/mpls/internal.h                                |    13 +-
 net/mptcp/options.c                                |   119 +-
 net/mptcp/pm.c                                     |    34 +-
 net/mptcp/pm_netlink.c                             |   215 +-
 net/mptcp/protocol.c                               |   476 +-
 net/mptcp/protocol.h                               |    69 +-
 net/mptcp/sockopt.c                                |   262 +-
 net/mptcp/subflow.c                                |    34 +-
 net/mptcp/token.c                                  |     1 +
 net/netfilter/Kconfig                              |     6 -
 net/netfilter/Makefile                             |     3 +-
 net/netfilter/core.c                               |    29 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |     7 +-
 net/netfilter/nf_conntrack_core.c                  |    68 +-
 net/netfilter/nf_conntrack_expect.c                |     6 +-
 net/netfilter/nf_conntrack_netlink.c               |    14 +-
 net/netfilter/nf_conntrack_standalone.c            |     4 +-
 net/netfilter/nf_flow_table_core.c                 |     2 +-
 net/netfilter/nf_flow_table_inet.c                 |    26 +
 net/netfilter/nf_nat_core.c                        |    47 +-
 net/netfilter/nf_nat_masquerade.c                  |     4 +-
 net/netfilter/nf_synproxy_core.c                   |     1 -
 net/netfilter/nf_tables_api.c                      |   160 +-
 net/netfilter/nf_tables_core.c                     |    87 +-
 net/netfilter/nf_tables_trace.c                    |     2 +-
 net/netfilter/nfnetlink_hook.c                     |     1 +
 net/netfilter/nfnetlink_log.c                      |     5 +-
 net/netfilter/nfnetlink_queue.c                    |    14 +-
 net/netfilter/nft_bitwise.c                        |    95 +
 net/netfilter/nft_connlimit.c                      |    26 +-
 net/netfilter/nft_counter.c                        |    58 +-
 net/netfilter/nft_ct.c                             |     4 +-
 net/netfilter/nft_fwd_netdev.c                     |     7 +-
 net/netfilter/nft_last.c                           |    69 +-
 net/netfilter/nft_limit.c                          |   172 +-
 net/netfilter/nft_meta.c                           |    48 +
 net/netfilter/nft_numgen.c                         |    34 +-
 net/netfilter/nft_payload.c                        |    60 +-
 net/netfilter/nft_quota.c                          |    52 +-
 net/netfilter/nft_reject_netdev.c                  |     1 +
 net/netfilter/nft_set_pipapo.c                     |     8 +
 net/netfilter/nft_set_pipapo_avx2.c                |     4 +-
 net/netfilter/xt_CT.c                              |     3 +-
 net/netlink/af_netlink.c                           |     6 +-
 net/netrom/af_netrom.c                             |    12 +-
 net/openvswitch/conntrack.c                        |    21 +-
 net/openvswitch/flow.c                             |    16 +-
 net/openvswitch/vport-netdev.c                     |     9 +-
 net/openvswitch/vport.h                            |     2 +
 net/packet/af_packet.c                             |    32 +-
 net/rds/send.c                                     |     2 +-
 net/rfkill/core.c                                  |    12 +
 net/rose/rose_in.c                                 |     1 +
 net/sched/act_api.c                                |   459 +-
 net/sched/act_bpf.c                                |     2 +-
 net/sched/act_connmark.c                           |     2 +-
 net/sched/act_csum.c                               |    19 +
 net/sched/act_ct.c                                 |    64 +-
 net/sched/act_ctinfo.c                             |     2 +-
 net/sched/act_gact.c                               |    38 +
 net/sched/act_gate.c                               |    51 +-
 net/sched/act_ife.c                                |     2 +-
 net/sched/act_ipt.c                                |     2 +-
 net/sched/act_mirred.c                             |    68 +-
 net/sched/act_mpls.c                               |    54 +-
 net/sched/act_nat.c                                |     2 +-
 net/sched/act_pedit.c                              |    36 +-
 net/sched/act_police.c                             |    27 +-
 net/sched/act_sample.c                             |    32 +-
 net/sched/act_simple.c                             |     2 +-
 net/sched/act_skbedit.c                            |    38 +-
 net/sched/act_skbmod.c                             |     2 +-
 net/sched/act_tunnel_key.c                         |    54 +
 net/sched/act_vlan.c                               |    48 +
 net/sched/cls_api.c                                |   280 +-
 net/sched/cls_flower.c                             |    29 +-
 net/sched/cls_matchall.c                           |    27 +-
 net/sched/cls_u32.c                                |    12 +-
 net/sched/sch_api.c                                |     2 +-
 net/sched/sch_cake.c                               |    40 +-
 net/sched/sch_frag.c                               |     1 +
 net/sched/sch_generic.c                            |    83 +-
 net/sched/sch_netem.c                              |    18 +-
 net/sctp/input.c                                   |    27 +-
 net/sctp/output.c                                  |     2 +-
 net/sctp/outqueue.c                                |     3 +
 net/sctp/proc.c                                    |    10 +-
 net/sctp/sm_statefuns.c                            |    11 +-
 net/sctp/socket.c                                  |    11 +-
 net/sctp/transport.c                               |    26 +-
 net/smc/af_smc.c                                   |   103 +-
 net/smc/smc_clc.c                                  |     1 -
 net/smc/smc_core.c                                 |    56 +-
 net/smc/smc_core.h                                 |    21 +-
 net/smc/smc_diag.c                                 |    16 +-
 net/smc/smc_ib.c                                   |     2 +
 net/smc/smc_ib.h                                   |     7 +
 net/smc/smc_ism.c                                  |     1 +
 net/smc/smc_llc.c                                  |    19 +-
 net/smc/smc_pnet.c                                 |    30 +-
 net/smc/smc_tracepoint.h                           |    23 +-
 net/smc/smc_wr.c                                   |    15 +-
 net/socket.c                                       |    32 +-
 net/switchdev/switchdev.c                          |     5 +-
 net/tipc/bearer.c                                  |     4 +-
 net/tipc/crypto.c                                  |    19 +-
 net/tipc/link.c                                    |     3 +-
 net/tls/tls_sw.c                                   |    37 +-
 net/unix/af_unix.c                                 |   572 +-
 net/unix/diag.c                                    |    23 +-
 net/unix/sysctl_net_unix.c                         |     4 -
 net/vmw_vsock/af_vsock.c                           |     1 +
 net/vmw_vsock/hyperv_transport.c                   |    18 +-
 net/wireless/chan.c                                |    78 +-
 net/wireless/core.c                                |     9 +
 net/wireless/core.h                                |    16 +
 net/wireless/mlme.c                                |   153 +-
 net/wireless/nl80211.c                             |   123 +-
 net/wireless/rdev-ops.h                            |    17 +
 net/wireless/reg.c                                 |     2 +
 net/wireless/scan.c                                |   121 +-
 net/wireless/sme.c                                 |    22 +-
 net/wireless/trace.h                               |    47 +-
 net/wireless/wext-sme.c                            |    12 +-
 net/x25/x25_in.c                                   |     2 +-
 net/xdp/xsk.c                                      |     4 -
 net/xdp/xskmap.c                                   |     1 +
 net/xfrm/xfrm_algo.c                               |    41 +
 net/xfrm/xfrm_compat.c                             |     6 +-
 net/xfrm/xfrm_device.c                             |     3 +-
 net/xfrm/xfrm_input.c                              |     1 +
 net/xfrm/xfrm_interface.c                          |    14 +-
 net/xfrm/xfrm_output.c                             |    31 +-
 net/xfrm/xfrm_policy.c                             |    24 +-
 net/xfrm/xfrm_state.c                              |    24 +-
 net/xfrm/xfrm_user.c                               |    42 +-
 samples/bpf/Makefile                               |    18 +-
 samples/bpf/Makefile.target                        |    11 -
 samples/bpf/cookie_uid_helper_example.c            |    14 +-
 samples/bpf/fds_example.c                          |    29 +-
 samples/bpf/hbm.c                                  |    11 +-
 samples/bpf/lwt_len_hist_kern.c                    |     7 -
 samples/bpf/map_perf_test_user.c                   |    15 +-
 samples/bpf/sock_example.c                         |    12 +-
 samples/bpf/sockex1_user.c                         |    15 +-
 samples/bpf/sockex2_user.c                         |    14 +-
 samples/bpf/test_cgrp2_array_pin.c                 |     4 +-
 samples/bpf/test_cgrp2_attach.c                    |    13 +-
 samples/bpf/test_cgrp2_sock.c                      |     8 +-
 samples/bpf/test_lru_dist.c                        |    11 +-
 samples/bpf/trace_output_user.c                    |     4 +-
 samples/bpf/xdp_fwd_user.c                         |    12 +-
 samples/bpf/xdp_redirect_cpu.bpf.c                 |     4 +-
 samples/bpf/xdp_sample_pkts_user.c                 |    22 +-
 samples/bpf/xdp_sample_user.h                      |     2 +
 samples/bpf/xdpsock_ctrl_proc.c                    |     3 +
 samples/bpf/xdpsock_user.c                         |   366 +-
 samples/bpf/xsk_fwd.c                              |     3 +
 security/device_cgroup.c                           |     1 +
 tools/bpf/bpftool/.gitignore                       |     2 +-
 tools/bpf/bpftool/Documentation/Makefile           |     5 +-
 tools/bpf/bpftool/Documentation/bpftool-btf.rst    |     7 +-
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |    17 +-
 .../bpf/bpftool/Documentation/bpftool-feature.rst  |     6 +-
 tools/bpf/bpftool/Documentation/bpftool-gen.rst    |     7 +-
 tools/bpf/bpftool/Documentation/bpftool-iter.rst   |     6 +-
 tools/bpf/bpftool/Documentation/bpftool-link.rst   |     7 +-
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |    13 +-
 tools/bpf/bpftool/Documentation/bpftool-net.rst    |    72 +-
 tools/bpf/bpftool/Documentation/bpftool-perf.rst   |     6 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |    14 +-
 .../bpftool/Documentation/bpftool-struct_ops.rst   |     6 +-
 tools/bpf/bpftool/Documentation/bpftool.rst        |    11 +-
 tools/bpf/bpftool/Documentation/common_options.rst |    11 +
 tools/bpf/bpftool/Documentation/substitutions.rst  |     3 +
 tools/bpf/bpftool/Makefile                         |    26 +-
 tools/bpf/bpftool/bash-completion/bpftool          |     5 +-
 tools/bpf/bpftool/btf.c                            |    13 +-
 tools/bpf/bpftool/btf_dumper.c                     |    42 +-
 tools/bpf/bpftool/common.c                         |     1 +
 tools/bpf/bpftool/feature.c                        |   111 +-
 tools/bpf/bpftool/gen.c                            |    23 +-
 tools/bpf/bpftool/iter.c                           |     7 +-
 tools/bpf/bpftool/main.c                           |    27 +-
 tools/bpf/bpftool/main.h                           |     3 +-
 tools/bpf/bpftool/map.c                            |    36 +-
 tools/bpf/bpftool/map_perf_ring.c                  |     9 +-
 tools/bpf/bpftool/prog.c                           |   260 +-
 tools/bpf/bpftool/struct_ops.c                     |    31 +-
 tools/bpf/resolve_btfids/Makefile                  |     1 +
 tools/bpf/resolve_btfids/main.c                    |     5 +-
 tools/bpf/runqslower/Makefile                      |     4 +-
 tools/bpf/runqslower/runqslower.c                  |     6 +-
 tools/build/feature/test-bpf.c                     |     6 +
 tools/include/uapi/linux/bpf.h                     |   165 +-
 tools/include/uapi/linux/btf.h                     |     3 +-
 tools/include/uapi/linux/if_link.h                 |     2 +
 tools/lib/bpf/Makefile                             |     4 +-
 tools/lib/bpf/bpf.c                                |   471 +-
 tools/lib/bpf/bpf.h                                |   246 +-
 tools/lib/bpf/bpf_gen_internal.h                   |    17 +-
 tools/lib/bpf/bpf_tracing.h                        |   431 +-
 tools/lib/bpf/btf.c                                |   206 +-
 tools/lib/bpf/btf.h                                |    88 +-
 tools/lib/bpf/btf_dump.c                           |    46 +-
 tools/lib/bpf/gen_loader.c                         |   192 +-
 tools/lib/bpf/libbpf.c                             |  1111 +-
 tools/lib/bpf/libbpf.h                             |   297 +-
 tools/lib/bpf/libbpf.map                           |    30 +
 tools/lib/bpf/libbpf_common.h                      |    19 +-
 tools/lib/bpf/libbpf_internal.h                    |   117 +-
 tools/lib/bpf/libbpf_legacy.h                      |    13 +-
 tools/lib/bpf/libbpf_probes.c                      |   271 +-
 tools/lib/bpf/libbpf_version.h                     |     2 +-
 tools/lib/bpf/linker.c                             |    10 +-
 tools/lib/bpf/relo_core.c                          |   251 +-
 tools/lib/bpf/relo_core.h                          |   103 +-
 tools/lib/bpf/skel_internal.h                      |    13 +-
 tools/lib/bpf/xsk.c                                |    61 +-
 tools/perf/builtin-trace.c                         |    13 +-
 tools/perf/tests/bpf.c                             |     4 +
 tools/perf/util/bpf-loader.c                       |     3 +
 tools/perf/util/bpf_counter.c                      |    18 +-
 tools/scripts/Makefile.include                     |    13 +-
 tools/testing/selftests/bpf/Makefile               |    94 +-
 tools/testing/selftests/bpf/README.rst             |     9 +-
 tools/testing/selftests/bpf/bench.c                |    71 +-
 tools/testing/selftests/bpf/bench.h                |    11 +-
 .../selftests/bpf/benchs/bench_bloom_filter_map.c  |    17 +-
 .../testing/selftests/bpf/benchs/bench_bpf_loop.c  |   105 +
 tools/testing/selftests/bpf/benchs/bench_count.c   |     2 +-
 tools/testing/selftests/bpf/benchs/bench_rename.c  |    16 +-
 .../testing/selftests/bpf/benchs/bench_ringbufs.c  |    22 +-
 tools/testing/selftests/bpf/benchs/bench_strncmp.c |   161 +
 tools/testing/selftests/bpf/benchs/bench_trigger.c |   162 +-
 .../selftests/bpf/benchs/run_bench_bpf_loop.sh     |    15 +
 .../selftests/bpf/benchs/run_bench_strncmp.sh      |    12 +
 tools/testing/selftests/bpf/benchs/run_common.sh   |    15 +
 tools/testing/selftests/bpf/btf_helpers.c          |    17 +-
 tools/testing/selftests/bpf/config                 |     2 +
 tools/testing/selftests/bpf/flow_dissector_load.h  |     3 +-
 tools/testing/selftests/bpf/get_cgroup_id_user.c   |     5 +-
 .../selftests/bpf/map_tests/array_map_batch_ops.c  |    13 +-
 .../selftests/bpf/map_tests/htab_map_batch_ops.c   |    13 +-
 .../bpf/map_tests/lpm_trie_map_batch_ops.c         |    15 +-
 .../selftests/bpf/map_tests/sk_storage_map.c       |    52 +-
 tools/testing/selftests/bpf/prog_tests/align.c     |   202 +-
 tools/testing/selftests/bpf/prog_tests/atomics.c   |     4 +-
 .../selftests/bpf/prog_tests/bloom_filter_map.c    |    36 +-
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |    21 +-
 tools/testing/selftests/bpf/prog_tests/bpf_loop.c  |   145 +
 .../testing/selftests/bpf/prog_tests/bpf_obj_id.c  |     6 +-
 .../testing/selftests/bpf/prog_tests/bpf_tcp_ca.c  |     7 +-
 .../selftests/bpf/prog_tests/bpf_verif_scale.c     |    42 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       |   335 +-
 .../selftests/bpf/prog_tests/btf_dedup_split.c     |   119 +-
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  |    45 +-
 tools/testing/selftests/bpf/prog_tests/btf_split.c |     4 +-
 tools/testing/selftests/bpf/prog_tests/btf_tag.c   |    44 +-
 tools/testing/selftests/bpf/prog_tests/btf_write.c |    67 +-
 .../bpf/prog_tests/cgroup_attach_autodetach.c      |     2 +-
 .../selftests/bpf/prog_tests/cgroup_attach_multi.c |    14 +-
 .../bpf/prog_tests/cgroup_attach_override.c        |     2 +-
 .../selftests/bpf/prog_tests/connect_force_port.c  |    35 +-
 tools/testing/selftests/bpf/prog_tests/core_kern.c |    14 +
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |    84 +-
 tools/testing/selftests/bpf/prog_tests/d_path.c    |    22 +-
 tools/testing/selftests/bpf/prog_tests/exhandler.c |    43 +
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |    25 +-
 .../selftests/bpf/prog_tests/fexit_stress.c        |    33 +-
 tools/testing/selftests/bpf/prog_tests/find_vma.c  |   117 +
 .../bpf/prog_tests/flow_dissector_load_bytes.c     |     2 +-
 .../bpf/prog_tests/flow_dissector_reattach.c       |     4 +-
 .../selftests/bpf/prog_tests/get_func_args_test.c  |    44 +
 .../selftests/bpf/prog_tests/get_stack_raw_tp.c    |    27 +-
 .../testing/selftests/bpf/prog_tests/global_data.c |     2 +-
 .../selftests/bpf/prog_tests/global_func_args.c    |     2 +-
 tools/testing/selftests/bpf/prog_tests/kfree_skb.c |    64 +-
 .../testing/selftests/bpf/prog_tests/kfunc_call.c  |    24 +
 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c |    14 +
 tools/testing/selftests/bpf/prog_tests/l4lb_all.c  |     2 +-
 .../selftests/bpf/prog_tests/legacy_printk.c       |    65 +
 .../selftests/bpf/prog_tests/libbpf_probes.c       |   124 +
 .../selftests/bpf/prog_tests/load_bytes_relative.c |     2 +-
 tools/testing/selftests/bpf/prog_tests/log_buf.c   |   276 +
 tools/testing/selftests/bpf/prog_tests/map_lock.c  |     4 +-
 tools/testing/selftests/bpf/prog_tests/map_ptr.c   |    16 +-
 .../selftests/bpf/prog_tests/migrate_reuseport.c   |     4 +-
 .../testing/selftests/bpf/prog_tests/perf_buffer.c |     6 +-
 tools/testing/selftests/bpf/prog_tests/pinning.c   |     4 +-
 .../testing/selftests/bpf/prog_tests/pkt_access.c  |     2 +-
 .../selftests/bpf/prog_tests/pkt_md_access.c       |     2 +-
 .../selftests/bpf/prog_tests/prog_array_init.c     |    32 +
 .../selftests/bpf/prog_tests/queue_stack_map.c     |    14 +-
 .../raw_tp_writable_reject_nbd_invalid.c           |    14 +-
 .../bpf/prog_tests/raw_tp_writable_test_run.c      |    29 +-
 .../selftests/bpf/prog_tests/ringbuf_multi.c       |     4 +-
 .../selftests/bpf/prog_tests/select_reuseport.c    |    22 +-
 .../selftests/bpf/prog_tests/signal_pending.c      |     2 +-
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c |    32 +-
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c   |     4 +-
 .../testing/selftests/bpf/prog_tests/skb_helpers.c |     2 +-
 .../testing/selftests/bpf/prog_tests/sock_fields.c |     1 -
 .../selftests/bpf/prog_tests/sockmap_basic.c       |     4 +-
 .../selftests/bpf/prog_tests/sockmap_ktls.c        |     2 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c      |     4 +-
 tools/testing/selftests/bpf/prog_tests/sockopt.c   |    19 +-
 .../selftests/bpf/prog_tests/sockopt_inherit.c     |    27 +-
 .../selftests/bpf/prog_tests/sockopt_multi.c       |    12 +-
 tools/testing/selftests/bpf/prog_tests/spinlock.c  |     4 +-
 .../selftests/bpf/prog_tests/stacktrace_map.c      |     6 +-
 .../bpf/prog_tests/stacktrace_map_raw_tp.c         |     6 +-
 tools/testing/selftests/bpf/prog_tests/tailcalls.c |    18 +-
 .../selftests/bpf/prog_tests/task_fd_query_rawtp.c |     2 +-
 .../selftests/bpf/prog_tests/task_fd_query_tp.c    |     4 +-
 .../testing/selftests/bpf/prog_tests/tc_redirect.c |     7 +
 .../testing/selftests/bpf/prog_tests/tcp_estats.c  |     2 +-
 tools/testing/selftests/bpf/prog_tests/tcp_rtt.c   |    21 +-
 .../testing/selftests/bpf/prog_tests/test_bpffs.c  |     6 +-
 .../selftests/bpf/prog_tests/test_global_funcs.c   |    28 +-
 .../selftests/bpf/prog_tests/test_local_storage.c  |    20 +-
 .../selftests/bpf/prog_tests/test_overhead.c       |    20 +-
 .../selftests/bpf/prog_tests/test_strncmp.c        |   167 +
 .../selftests/bpf/prog_tests/tp_attach_query.c     |     2 +-
 .../selftests/bpf/prog_tests/trampoline_count.c    |     6 +-
 tools/testing/selftests/bpf/prog_tests/xdp.c       |    13 +-
 .../selftests/bpf/prog_tests/xdp_adjust_tail.c     |     6 +-
 .../testing/selftests/bpf/prog_tests/xdp_attach.c  |     6 +-
 .../testing/selftests/bpf/prog_tests/xdp_bonding.c |    36 +-
 .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |    13 +-
 tools/testing/selftests/bpf/prog_tests/xdp_info.c  |     2 +-
 tools/testing/selftests/bpf/prog_tests/xdp_perf.c  |     2 +-
 tools/testing/selftests/bpf/progs/bpf_iter_unix.c  |     2 +-
 tools/testing/selftests/bpf/progs/bpf_loop.c       |   112 +
 tools/testing/selftests/bpf/progs/bpf_loop_bench.c |    26 +
 .../testing/selftests/bpf/progs/bpf_tracing_net.h  |     2 -
 .../selftests/bpf/progs/{tag.c => btf_decl_tag.c}  |     4 -
 tools/testing/selftests/bpf/progs/btf_type_tag.c   |    25 +
 tools/testing/selftests/bpf/progs/core_kern.c      |   104 +
 tools/testing/selftests/bpf/progs/exhandler_kern.c |    43 +
 tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c  |     2 +-
 tools/testing/selftests/bpf/progs/find_vma.c       |    69 +
 tools/testing/selftests/bpf/progs/find_vma_fail1.c |    29 +
 tools/testing/selftests/bpf/progs/find_vma_fail2.c |    29 +
 .../selftests/bpf/progs/get_func_args_test.c       |   123 +
 tools/testing/selftests/bpf/progs/local_storage.c  |    24 +-
 tools/testing/selftests/bpf/progs/loop3.c          |     4 +-
 tools/testing/selftests/bpf/progs/map_ptr_kern.c   |    16 +-
 tools/testing/selftests/bpf/progs/pyperf.h         |    71 +-
 .../selftests/bpf/progs/pyperf600_bpf_loop.c       |     6 +
 tools/testing/selftests/bpf/progs/strncmp_bench.c  |    50 +
 tools/testing/selftests/bpf/progs/strncmp_test.c   |    54 +
 tools/testing/selftests/bpf/progs/strobemeta.h     |    75 +-
 .../selftests/bpf/progs/strobemeta_bpf_loop.c      |     9 +
 .../bpf/progs/test_d_path_check_rdonly_mem.c       |    28 +
 .../bpf/progs/test_ksyms_btf_write_check.c         |    29 +
 .../testing/selftests/bpf/progs/test_ksyms_weak.c  |     2 +-
 tools/testing/selftests/bpf/progs/test_l4lb.c      |     2 +-
 .../selftests/bpf/progs/test_l4lb_noinline.c       |     2 +-
 .../selftests/bpf/progs/test_legacy_printk.c       |    73 +
 tools/testing/selftests/bpf/progs/test_log_buf.c   |    24 +
 tools/testing/selftests/bpf/progs/test_map_lock.c  |     2 +-
 .../selftests/bpf/progs/test_prog_array_init.c     |    39 +
 .../selftests/bpf/progs/test_queue_stack_map.h     |     2 +-
 tools/testing/selftests/bpf/progs/test_sk_lookup.c |     8 +
 .../selftests/bpf/progs/test_sk_storage_tracing.c  |     2 +-
 tools/testing/selftests/bpf/progs/test_skb_ctx.c   |     2 +-
 .../selftests/bpf/progs/test_skc_to_unix_sock.c    |     2 +-
 tools/testing/selftests/bpf/progs/test_spin_lock.c |     2 +-
 .../testing/selftests/bpf/progs/test_tcp_estats.c  |     2 +-
 .../selftests/bpf/progs/test_verif_scale2.c        |     4 +-
 tools/testing/selftests/bpf/progs/trigger_bench.c  |     7 +
 .../selftests/bpf/test_bpftool_synctypes.py        |    94 +-
 tools/testing/selftests/bpf/test_btf.h             |     3 +
 tools/testing/selftests/bpf/test_cgroup_storage.c  |    11 +-
 tools/testing/selftests/bpf/test_cpp.cpp           |     9 +-
 tools/testing/selftests/bpf/test_dev_cgroup.c      |     3 +-
 tools/testing/selftests/bpf/test_lirc_mode2_user.c |     6 +-
 tools/testing/selftests/bpf/test_lpm_map.c         |    27 +-
 tools/testing/selftests/bpf/test_lru_map.c         |    25 +-
 tools/testing/selftests/bpf/test_maps.c            |   118 +-
 tools/testing/selftests/bpf/test_progs.c           |    30 +-
 tools/testing/selftests/bpf/test_sock.c            |   393 +-
 tools/testing/selftests/bpf/test_sock_addr.c       |    46 +-
 tools/testing/selftests/bpf/test_stub.c            |    44 -
 tools/testing/selftests/bpf/test_sysctl.c          |    23 +-
 tools/testing/selftests/bpf/test_tag.c             |     8 +-
 tools/testing/selftests/bpf/test_tcpnotify_user.c  |     7 +-
 tools/testing/selftests/bpf/test_verifier.c        |   110 +-
 tools/testing/selftests/bpf/testing_helpers.c      |    62 +
 tools/testing/selftests/bpf/testing_helpers.h      |     6 +
 .../selftests/bpf/verifier/btf_ctx_access.c        |    12 +
 .../testing/selftests/bpf/verifier/ctx_sk_lookup.c |    32 +
 tools/testing/selftests/bpf/verifier/spill_fill.c  |    28 +
 tools/testing/selftests/bpf/vmtest.sh              |    48 +-
 tools/testing/selftests/bpf/xdp_redirect_multi.c   |    15 +-
 tools/testing/selftests/bpf/xdping.c               |     3 +-
 tools/testing/selftests/bpf/xdpxceiver.c           |    14 +-
 .../drivers/net/mlxsw/devlink_trap_tunnel_vxlan.sh |     7 +-
 .../net/mlxsw/devlink_trap_tunnel_vxlan_ipv6.sh    |   342 +
 .../net/mlxsw/spectrum-2/vxlan_flooding_ipv6.sh    |   322 +
 .../net/mlxsw/spectrum/vxlan_flooding_ipv6.sh      |   334 +
 tools/testing/selftests/drivers/net/mlxsw/vxlan.sh |   242 +-
 .../selftests/drivers/net/mlxsw/vxlan_fdb_veto.sh  |    39 +-
 .../drivers/net/mlxsw/vxlan_fdb_veto_ipv6.sh       |    12 +
 .../selftests/drivers/net/mlxsw/vxlan_ipv6.sh      |    65 +
 tools/testing/selftests/net/fcnal-test.sh          |    42 +-
 .../selftests/net/forwarding/bridge_vlan_mcast.sh  |   543 +
 tools/testing/selftests/net/forwarding/lib.sh      |     7 +-
 .../selftests/net/forwarding/q_in_vni_ipv6.sh      |   347 +
 .../net/forwarding/vxlan_asymmetric_ipv6.sh        |   504 +
 .../net/forwarding/vxlan_bridge_1d_ipv6.sh         |   804 ++
 .../forwarding/vxlan_bridge_1d_port_8472_ipv6.sh   |    11 +
 .../selftests/net/forwarding/vxlan_bridge_1q.sh    |    20 -
 .../net/forwarding/vxlan_bridge_1q_ipv6.sh         |   837 ++
 .../forwarding/vxlan_bridge_1q_port_8472_ipv6.sh   |    11 +
 .../net/forwarding/vxlan_symmetric_ipv6.sh         |   563 +
 tools/testing/selftests/net/gro.c                  |    38 +-
 tools/testing/selftests/net/mptcp/.gitignore       |     1 +
 tools/testing/selftests/net/mptcp/Makefile         |     2 +-
 tools/testing/selftests/net/mptcp/config           |     9 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |   350 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |   139 +-
 tools/testing/selftests/net/mptcp/mptcp_inq.c      |   602 +
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   203 +-
 tools/testing/selftests/net/mptcp/mptcp_sockopt.c  |    63 +
 tools/testing/selftests/net/mptcp/mptcp_sockopt.sh |    44 +-
 tools/testing/selftests/net/nettest.c              |    33 +-
 .../selftests/netfilter/ipip-conntrack-mtu.sh      |     9 +-
 tools/testing/selftests/netfilter/nf_nat_edemux.sh |    10 +-
 tools/testing/selftests/netfilter/nft_nat.sh       |     5 +-
 tools/testing/selftests/ptp/testptp.c              |    24 +-
 .../tc-testing/tc-tests/actions/police.json        |    24 +
 .../tc-testing/tc-tests/filters/matchall.json      |    72 +
 2006 files changed, 111849 insertions(+), 44860 deletions(-)
 create mode 100644 Documentation/bpf/classic_vs_extended.rst
 create mode 100644 Documentation/bpf/faq.rst
 create mode 100644 Documentation/bpf/helpers.rst
 create mode 100644 Documentation/bpf/instruction-set.rst
 create mode 100644 Documentation/bpf/maps.rst
 create mode 100644 Documentation/bpf/other.rst
 rename Documentation/bpf/{bpf_lsm.rst => prog_lsm.rst} (100%)
 create mode 100644 Documentation/bpf/programs.rst
 create mode 100644 Documentation/bpf/syscall_api.rst
 create mode 100644 Documentation/bpf/test_debug.rst
 create mode 100644 Documentation/bpf/verifier.rst
 create mode 100644 Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
 create mode 100644 Documentation/devicetree/bindings/net/engleder,tsnep.yaml
 create mode 100644 Documentation/devicetree/bindings/net/intel,ixp4xx-hss.yaml
 create mode 100644 Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
 create mode 100644 Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml
 create mode 100644 Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml
 create mode 100644 Documentation/networking/device_drivers/can/freescale/flexcan.rst
 create mode 100644 Documentation/networking/device_drivers/can/index.rst
 create mode 100644 drivers/bluetooth/btmtk.c
 create mode 100644 drivers/bluetooth/btmtk.h
 create mode 100644 drivers/net/can/flexcan/Makefile
 rename drivers/net/can/{flexcan.c => flexcan/flexcan-core.c} (90%)
 create mode 100644 drivers/net/can/flexcan/flexcan-ethtool.c
 create mode 100644 drivers/net/can/flexcan/flexcan.h
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-chip-fifo.c
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c
 create mode 100644 drivers/net/ethernet/engleder/Kconfig
 create mode 100644 drivers/net/ethernet/engleder/Makefile
 create mode 100644 drivers/net/ethernet/engleder/tsnep.h
 create mode 100644 drivers/net/ethernet/engleder/tsnep_ethtool.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_hw.h
 create mode 100644 drivers/net/ethernet/engleder/tsnep_main.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_ptp.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_selftests.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_tc.c
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.c
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_cmd.h
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.c
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_rss.h
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.c
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.h
 delete mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile
 delete mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
 delete mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/Makefile
 delete mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_cgu_regs.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_ptp_consts.h
 delete mode 100644 drivers/net/ethernet/intel/ice/ice_status.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_counter.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_counter.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_router.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_router_hw.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/accept.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/act.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/csum.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/drop.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/goto.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mark.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred_nic.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mpls.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/pedit.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/ptype.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/redirect_ingress.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/trap.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/tun.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/vlan_mangle.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/irq_affinity.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_dbg.h
 create mode 100644 drivers/net/ethernet/microchip/lan966x/Kconfig
 create mode 100644 drivers/net/ethernet/microchip/lan966x/Makefile
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_ifh.h
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_main.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_main.h
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_mdb.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_phylink.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_port.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_regs.h
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_switchdev.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_vlan.c
 create mode 100644 drivers/net/ethernet/microsoft/mana/mana_bpf.c
 create mode 100644 drivers/net/ethernet/mscc/ocelot_fdma.c
 create mode 100644 drivers/net/ethernet/mscc/ocelot_fdma.h
 create mode 100644 drivers/net/ethernet/mscc/vsc7514_regs.c
 create mode 100644 drivers/net/ethernet/vertexcom/Kconfig
 create mode 100644 drivers/net/ethernet/vertexcom/Makefile
 create mode 100644 drivers/net/ethernet/vertexcom/mse102x.c
 create mode 100644 drivers/net/mctp/mctp-serial.c
 rename drivers/net/wireless/intel/iwlwifi/fw/api/{soc.h => system.h} (70%)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mei/Makefile
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mei/internal.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mei/iwl-mei.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mei/main.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mei/net.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mei/sap.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mei/trace-data.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mei/trace.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mei/trace.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/vendor-cmd.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/sar.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/sar.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_debugfs.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_debugfs.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_trace.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_trace.h
 create mode 100644 drivers/net/wwan/qcom_bam_dmux.c
 create mode 100644 include/linux/bpf-cgroup-defs.h
 create mode 100644 include/linux/mdio/mdio-mscc-miim.h
 create mode 100644 include/linux/ref_tracker.h
 create mode 100644 include/net/bluetooth/hci_sync.h
 create mode 100644 include/net/net_trackers.h
 create mode 100644 include/net/netfilter/nf_conntrack_act_ct.h
 create mode 100644 include/soc/mscc/vsc7514_regs.h
 create mode 100644 kernel/bpf/mmap_unlock_work.h
 create mode 100644 lib/ref_tracker.c
 create mode 100644 lib/test_ref_tracker.c
 create mode 100644 net/Kconfig.debug
 create mode 100644 net/bluetooth/hci_sync.c
 create mode 100644 net/core/dev_addr_lists_test.c
 create mode 100644 net/core/gro.c
 create mode 100644 tools/bpf/bpftool/Documentation/substitutions.rst
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_bpf_loop.c
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_strncmp.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_bpf_loop.sh
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_strncmp.sh
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_loop.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/core_kern.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/exhandler.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/find_vma.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_func_args_test.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/legacy_printk.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/libbpf_probes.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/log_buf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/prog_array_init.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_strncmp.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_loop.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_loop_bench.c
 rename tools/testing/selftests/bpf/progs/{tag.c => btf_decl_tag.c} (94%)
 create mode 100644 tools/testing/selftests/bpf/progs/btf_type_tag.c
 create mode 100644 tools/testing/selftests/bpf/progs/core_kern.c
 create mode 100644 tools/testing/selftests/bpf/progs/exhandler_kern.c
 create mode 100644 tools/testing/selftests/bpf/progs/find_vma.c
 create mode 100644 tools/testing/selftests/bpf/progs/find_vma_fail1.c
 create mode 100644 tools/testing/selftests/bpf/progs/find_vma_fail2.c
 create mode 100644 tools/testing/selftests/bpf/progs/get_func_args_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/pyperf600_bpf_loop.c
 create mode 100644 tools/testing/selftests/bpf/progs/strncmp_bench.c
 create mode 100644 tools/testing/selftests/bpf/progs/strncmp_test.c
 create mode 100644 tools/testing/selftests/bpf/progs/strobemeta_bpf_loop.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_d_path_check_rdonly_mem.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_btf_write_check.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_legacy_printk.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_log_buf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_prog_array_init.c
 delete mode 100644 tools/testing/selftests/bpf/test_stub.c
 create mode 100644 tools/testing/selftests/bpf/verifier/btf_ctx_access.c
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/devlink_trap_tunnel_vxlan_ipv6.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/vxlan_flooding_ipv6.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/spectrum/vxlan_flooding_ipv6.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/vxlan_fdb_veto_ipv6.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/vxlan_ipv6.sh
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_vlan_mcast.sh
 create mode 100755 tools/testing/selftests/net/forwarding/q_in_vni_ipv6.sh
 create mode 100755 tools/testing/selftests/net/forwarding/vxlan_asymmetric_ipv6.sh
 create mode 100755 tools/testing/selftests/net/forwarding/vxlan_bridge_1d_ipv6.sh
 create mode 100755 tools/testing/selftests/net/forwarding/vxlan_bridge_1d_port_8472_ipv6.sh
 create mode 100755 tools/testing/selftests/net/forwarding/vxlan_bridge_1q_ipv6.sh
 create mode 100755 tools/testing/selftests/net/forwarding/vxlan_bridge_1q_port_8472_ipv6.sh
 create mode 100755 tools/testing/selftests/net/forwarding/vxlan_symmetric_ipv6.sh
 create mode 100644 tools/testing/selftests/net/mptcp/mptcp_inq.c
