Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCBE5F3C6C
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 07:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiJDFUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 01:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiJDFUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 01:20:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E3B13D2D;
        Mon,  3 Oct 2022 22:20:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB1FBB81630;
        Tue,  4 Oct 2022 05:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C545CC433D6;
        Tue,  4 Oct 2022 05:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664860802;
        bh=QzqDEj4eNVnxQZAR3AmLIk6u5DY15TKtmFTufpKDlxw=;
        h=From:To:Cc:Subject:Date:From;
        b=L/mKZYFVaHBCZq/F2Ole2rXloeBrDmfYdNzW063UqYd2ZF158F87Y7PIUJ/6O8NR6
         v3Y85cj6LBFLr5hw7htii18SNCyfMNTUZmX44DQjOCsRAAf4fIGb1nM23QHkER0GX9
         zFUC2FEUzAh6z59cm3N2ettaeco1QR87HevHB5/lzjqrIWSsfTpysjyW9sxR6dWSL9
         qqBrv6rl6CmsYXpHXRqYLak7gm8770533+aZGzs9WyHCLEA45WKaKlHJN+7ULzd+nj
         r6/xJFxY3aW4Blmo8RtPRYuY+WrmNGMA1LhDQCdy4hqx6hJ4KDxJqKgDHcd0Aa106P
         85vqJ+fuVqFUQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Subject: [PULL] Networking for next-6.1
Date:   Mon,  3 Oct 2022 22:20:00 -0700
Message-Id: <20221004052000.2645894-1-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
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

Unideally, one of my systems sees a CFI-looking warning here:

vmlinux.o: warning: objtool: ___ksymtab+bpf_dispatcher_xdp_func+0x0: data relocation to !ENDBR: bpf_dispatcher_xdp_func+0x0
vmlinux.o: warning: objtool: bpf_dispatcher_xdp+0xa0: data relocation to !ENDBR: bpf_dispatcher_xdp_func+0x0

after the latest BPF pull, but the system has fairly old gcc (8.5).
I don't see it with clang or gcc 12. Which perhaps explains why
it wasn't caught until now. We'll follow up as soon as we figure
out if it can/should be fixed or silenced. Or perhaps you'll tell
us to go away and fix it first...

We have a small conflict with your current tree between:
  9440155ccb94 ("ftrace: Add HAVE_DYNAMIC_FTRACE_NO_PATCHABLE")
  3c68a92d17ad ("objtool: Disable CFI warnings")

I didn't see it being reported by Steven, but it's trivial:

@@@ -4118,7 -4114,7 +4118,8 @@@ static int validate_ibt(struct objtool_
                    !strcmp(sec->name, "__ex_table")                    ||
                    !strcmp(sec->name, "__jump_table")                  ||
                    !strcmp(sec->name, "__mcount_loc")                  ||
-                   !strcmp(sec->name, ".kcfi_traps"))
++                  !strcmp(sec->name, ".kcfi_traps")                   ||
+                   strstr(sec->name, "__patchable_function_entries"))
                        continue;

There's also a conflict with the i2c tree, the conflict there
is also trivial (one side removes return statements while
the other removes setting driver_priv to NULL - both should go).

The following changes since commit 511cce163b75bc3933fa3de769a82bb7e8663f2b:

  Merge tag 'net-6.0-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-09-29 08:32:53 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-6.1

for you to fetch changes up to 681bf011b9b5989c6e9db6beb64494918aab9a43:

  eth: pse: add missing static inlines (2022-10-03 21:52:33 -0700)

----------------------------------------------------------------
Networking changes for 6.1.

Core
----

 - Introduce and use a single page frag cache for allocating small skb
   heads, clawing back the 10-20% performance regression in UDP flood
   test from previous fixes.

 - Run packets which already went thru HW coalescing thru SW GRO.
   This significantly improves TCP segment coalescing and simplifies
   deployments as different workloads benefit from HW or SW GRO.

 - Shrink the size of the base zero-copy send structure.

 - Move TCP init under a new slow / sleepable version of DO_ONCE().

BPF
---

 - Add BPF-specific, any-context-safe memory allocator.

 - Add helpers/kfuncs for PKCS#7 signature verification from BPF
   programs.

 - Define a new map type and related helpers for user space -> kernel
   communication over a ring buffer (BPF_MAP_TYPE_USER_RINGBUF).

 - Allow targeting BPF iterators to loop through resources of one
   task/thread.

 - Add ability to call selected destructive functions.
   Expose crash_kexec() to allow BPF to trigger a kernel dump.
   Use CAP_SYS_BOOT check on the loading process to judge permissions.

 - Enable BPF to collect custom hierarchical cgroup stats efficiently
   by integrating with the rstat framework.

 - Support struct arguments for trampoline based programs.
   Only structs with size <= 16B and x86 are supported.

 - Invoke cgroup/connect{4,6} programs for unprivileged ICMP ping
   sockets (instead of just TCP and UDP sockets).

 - Add a helper for accessing CLOCK_TAI for time sensitive network
   related programs.

 - Support accessing network tunnel metadata's flags.

 - Make TCP SYN ACK RTO tunable by BPF programs with TCP Fast Open.

 - Add support for writing to Netfilter's nf_conn:mark.

Protocols
---------

 - WiFi: more Extremely High Throughput (EHT) and Multi-Link
   Operation (MLO) work (802.11be, WiFi 7).

 - vsock: improve support for SO_RCVLOWAT.

 - SMC: support SO_REUSEPORT.

 - Netlink: define and document how to use netlink in a "modern" way.
   Support reporting missing attributes via extended ACK.

 - IPSec: support collect metadata mode for xfrm interfaces.

 - TCPv6: send consistent autoflowlabel in SYN_RECV state
   and RST packets.

 - TCP: introduce optional per-netns connection hash table to allow
   better isolation between namespaces (opt-in, at the cost of memory
   and cache pressure).

 - MPTCP: support TCP_FASTOPEN_CONNECT.

 - Add NEXT-C-SID support in Segment Routing (SRv6) End behavior.

 - Adjust IP_UNICAST_IF sockopt behavior for connected UDP sockets.

 - Open vSwitch:
   - Allow specifying ifindex of new interfaces.
   - Allow conntrack and metering in non-initial user namespace.

 - TLS: support the Korean ARIA-GCM crypto algorithm.

 - Remove DECnet support.

Driver API
----------

 - Allow selecting the conduit interface used by each port
   in DSA switches, at runtime.

 - Ethernet Power Sourcing Equipment and Power Device support.

 - Add tc-taprio support for queueMaxSDU parameter, i.e. setting
   per traffic class max frame size for time-based packet schedules.

 - Support PHY rate matching - adapting between differing host-side
   and link-side speeds.

 - Introduce QUSGMII PHY mode and 1000BASE-KX interface mode.

 - Validate OF (device tree) nodes for DSA shared ports; make
   phylink-related properties mandatory on DSA and CPU ports.
   Enforcing more uniformity should allow transitioning to phylink.

 - Require that flash component name used during update matches one
   of the components for which version is reported by info_get().

 - Remove "weight" argument from driver-facing NAPI API as much
   as possible. It's one of those magic knobs which seemed like
   a good idea at the time but is too indirect to use in practice.

 - Support offload of TLS connections with 256 bit keys.

New hardware / drivers
----------------------

 - Ethernet:
   - Microchip KSZ9896 6-port Gigabit Ethernet Switch
   - Renesas Ethernet AVB (EtherAVB-IF) Gen4 SoCs
   - Analog Devices ADIN1110 and ADIN2111 industrial single pair
     Ethernet (10BASE-T1L) MAC+PHY.
   - Rockchip RV1126 Gigabit Ethernet (a version of stmmac IP).

 - Ethernet SFPs / modules:
   - RollBall / Hilink / Turris 10G copper SFPs
   - HALNy GPON module

 - WiFi:
   - CYW43439 SDIO chipset (brcmfmac)
   - CYW89459 PCIe chipset (brcmfmac)
   - BCM4378 on Apple platforms (brcmfmac)

Drivers
-------

 - CAN:
   - gs_usb: HW timestamp support

 - Ethernet PHYs:
   - lan8814: cable diagnostics

 - Ethernet NICs:
   - Intel (100G):
     - implement control of FCS/CRC stripping
     - port splitting via devlink
     - L2TPv3 filtering offload
   - nVidia/Mellanox:
     - tunnel offload for sub-functions
     - MACSec offload, w/ Extended packet number and replay
       window offload
     - significantly restructure, and optimize the AF_XDP support,
       align the behavior with other vendors
   - Huawei:
     - configuring DSCP map for traffic class selection
     - querying standard FEC statistics
     - querying SerDes lane number via ethtool
   - Marvell/Cavium:
     - egress priority flow control
     - MACSec offload
   - AMD/SolarFlare:
     - PTP over IPv6 and raw Ethernet
   - small / embedded:
     - ax88772: convert to phylink (to support SFP cages)
     - altera: tse: convert to phylink
     - ftgmac100: support fixed link
     - enetc: standard Ethtool counters
     - macb: ZynqMP SGMII dynamic configuration support
     - tsnep: support multi-queue and use page pool
     - lan743x: Rx IP & TCP checksum offload
     - igc: add xdp frags support to ndo_xdp_xmit

 - Ethernet high-speed switches:
   - Marvell (prestera):
     - support SPAN port features (traffic mirroring)
     - nexthop object offloading
   - Microchip (sparx5):
     - multicast forwarding offload
     - QoS queuing offload (tc-mqprio, tc-tbf, tc-ets)

 - Ethernet embedded switches:
   - Marvell (mv88e6xxx):
     - support RGMII cmode
   - NXP (felix):
     - standardized ethtool counters
   - Microchip (lan966x):
     - QoS queuing offload (tc-mqprio, tc-tbf, tc-cbs, tc-ets)
     - traffic policing and mirroring
     - link aggregation / bonding offload
     - QUSGMII PHY mode support

 - Qualcomm 802.11ax WiFi (ath11k):
   - cold boot calibration support on WCN6750
   - support to connect to a non-transmit MBSSID AP profile
   - enable remain-on-channel support on WCN6750
   - Wake-on-WLAN support for WCN6750
   - support to provide transmit power from firmware via nl80211
   - support to get power save duration for each client
   - spectral scan support for 160 MHz

 - MediaTek WiFi (mt76):
   - WiFi-to-Ethernet bridging offload for MT7986 chips

 - RealTek WiFi (rtw89):
   - P2P support

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Abhishek Pandit-Subedi (2):
      Bluetooth: Prevent double register of suspend
      Bluetooth: Call shutdown for HCI_USER_CHANNEL

Adel Abouchaev (1):
      selftests/net: fix reinitialization of TEST_PROGS in net self tests.

Aditya Kumar Singh (2):
      wifi: ath11k: move firmware stats out of debugfs
      wifi: ath11k: add get_txpower mac ops

Alex Elder (48):
      net: ipa: use an array for transactions
      net: ipa: track allocated transactions with an ID
      net: ipa: track committed transactions with an ID
      net: ipa: track pending transactions with an ID
      net: ipa: track completed transactions with an ID
      net: ipa: track polled transactions with an ID
      net: ipa: rework last transaction determination
      net: ipa: use IDs for last allocated transaction
      net: ipa: use IDs exclusively for last transaction
      net: ipa: simplify gsi_channel_trans_last()
      net: ipa: further simplify gsi_channel_trans_last()
      net: ipa: verify a few more IDs
      net: ipa: always use transaction IDs instead of lists
      net: ipa: kill the allocated transaction list
      net: ipa: kill all other transaction lists
      net: ipa: update channel in gsi_channel_trans_complete()
      net: ipa: don't have gsi_channel_update() return a value
      net: ipa: don't define unneeded GSI register offsets
      net: ipa: move the definition of gsi_ee_id
      net: ipa: move and redefine ipa_version_valid()
      net: ipa: don't reuse variable names
      net: ipa: update sequencer definition constraints
      net: ipa: fix two symbol names
      net: ipa: don't use u32p_replace_bits()
      net: ipa: introduce ipa_qtime_val()
      net: ipa: rearrange functions for similarity
      net: ipa: define BCR values using an enum
      net: ipa: tidy up register enum definitions
      net: ipa: encapsulate setting the FILT_ROUT_HASH_EN register
      net: ipa: encapsulate updating the COUNTER_CFG register
      net: ipa: encapsulate updating three more registers
      net: ipa: introduce IPA register IDs
      net: ipa: use IPA register IDs to determine offsets
      net: ipa: add per-version IPA register definition files
      net: ipa: use ipa_reg[] array for register offsets
      net: ipa: introduce ipa_reg()
      net: ipa: introduce ipa_reg field masks
      net: ipa: define COMP_CFG IPA register fields
      net: ipa: define CLKON_CFG and ROUTE IPA register fields
      net: ipa: define some more IPA register fields
      net: ipa: define more IPA register fields
      net: ipa: define even more IPA register fields
      net: ipa: define resource group/type IPA register fields
      net: ipa: define some IPA endpoint register fields
      net: ipa: define more IPA endpoint register fields
      net: ipa: define remaining IPA register fields
      net: ipa: update comments
      net: ipa: update copyrights

Alexander Coffin (1):
      wifi: brcmfmac: fix use-after-free bug in brcmf_netdev_start_xmit()

Alexander Prutskov (1):
      brcmfmac: Support 89459 pcie

Alexandru Tachici (4):
      net: phy: adin1100: add PHY IDs of adin1110/adin2111
      net: ethernet: adi: Add ADIN1110 support
      dt-bindings: net: adin1110: Add docs
      net: ethernet: adi: Fix invalid parent name length

Alexei Starovoitov (35):
      Merge branch 'Add BPF-helper for accessing CLOCK_TAI'
      Merge branch 'destructive bpf_kfuncs'
      Merge branch 'bpf: net: Remove duplicated code from bpf_setsockopt()'
      Merge branch 'bpf: expose bpf_{g,s}et_retval to more cgroup hooks'
      Merge branch 'Fix reference state management for synchronous callbacks'
      Merge branch 'bpf: rstat: cgroup hierarchical'
      Merge branch 'bpf: net: Remove duplicated code from bpf_getsockopt()'
      bpf: Introduce any context BPF specific memory allocator.
      bpf: Convert hash map to bpf_mem_alloc.
      selftests/bpf: Improve test coverage of test_maps
      samples/bpf: Reduce syscall overhead in map_perf_test.
      bpf: Relax the requirement to use preallocated hash maps in tracing progs.
      bpf: Optimize element count in non-preallocated hash map.
      bpf: Optimize call_rcu in non-preallocated hash map.
      bpf: Adjust low/high watermarks in bpf_mem_cache
      bpf: Batch call_rcu callbacks instead of SLAB_TYPESAFE_BY_RCU.
      bpf: Add percpu allocation support to bpf_mem_alloc.
      bpf: Convert percpu hash map to per-cpu bpf_mem_alloc.
      bpf: Remove tracing program restriction on map types
      bpf: Prepare bpf_mem_alloc to be used by sleepable bpf programs.
      bpf: Remove prealloc-only restriction for sleepable bpf programs.
      bpf: Remove usage of kmem_cache from bpf_mem_cache.
      bpf: Optimize rcu_barrier usage between hash map and bpf_mem_alloc.
      bpf: Replace __ksize with ksize.
      Merge branch 'bpf: Support struct argument for trampoline base progs'
      Merge branch 'bpf-core changes for preparation of HID-bpf'
      Merge branch 'Support direct writes to nf_conn:mark'
      Merge branch 'bpf: Add kfuncs for PKCS#7 signature verification'
      Merge branch 'Introduce bpf_ct_set_nat_info kfunc helper'
      Merge branch 'veristat: CSV output, comparison mode, filtering'
      Merge branch 'veristat: further usability improvements'
      Merge branch 'bpf: Fixes for CONFIG_X86_KERNEL_IBT'
      Merge branch 'enforce W^X for trampoline and dispatcher'
      Merge branch 'bpf: Remove recursion check for struct_ops prog'
      bpf, docs: Delete misformatted table.

Amit Cohen (13):
      selftests: mlxsw: Add ingress RIF configuration test for 802.1D bridge
      selftests: mlxsw: Add ingress RIF configuration test for 802.1Q bridge
      selftests: mlxsw: Add ingress RIF configuration test for VXLAN
      selftests: mlxsw: Add egress VID classification test
      mlxsw: cmd: Edit the comment of 'max_lag' field in CONFIG_PROFILE
      mlxsw: Support configuring 'max_lag' via CONFIG_PROFILE
      mlxsw: Add a helper function for getting maximum LAG ID
      mlxsw: spectrum: Add a copy of 'struct mlxsw_config_profile' for Spectrum-4
      selftests: mlxsw: Use shapers in QOS tests instead of forcing speed
      selftests: mlxsw: Use shapers in QOS RED tests instead of forcing speed
      selftests: devlink_lib: Add function for querying maximum pool size
      selftests: mlxsw: Add QOS test for maximum use of descriptors
      selftests: mlxsw: Remove qos_burst test

Anand Moon (2):
      dt-bindings: net: rockchip-dwmac: add rv1126 compatible
      net: ethernet: stmicro: stmmac: dwmac-rk: Add rv1126 support

Anatolii Gerasymenko (3):
      ice: Implement FCS/CRC and VLAN stripping co-existence policy
      ice: Add port option admin queue commands
      ice: Implement devlink port split operations

Andrea Mayer (3):
      seg6: add netlink_ext_ack support in parsing SRv6 behavior attributes
      seg6: add NEXT-C-SID support for SRv6 End behavior
      selftests: seg6: add selftest for NEXT-C-SID flavor in SRv6 End behavior

Andrew Gaul (1):
      r8152: Rate limit overflow messages

Andrey Zhadchenko (2):
      openvswitch: allow specifying ifindex of new interfaces
      openvswitch: add OVS_DP_ATTR_PER_CPU_PIDS to get requests

Andrii Nakryiko (24):
      libbpf: Reject legacy 'maps' ELF section
      libbpf: preserve errno across pr_warn/pr_info/pr_debug
      libbpf: Fix potential NULL dereference when parsing ELF
      libbpf: Streamline bpf_attr and perf_event_attr initialization
      libbpf: Clean up deprecated and legacy aliases
      selftests/bpf: Few fixes for selftests/bpf built in release mode
      selftests/bpf: Fix test_verif_scale{1,3} SEC() annotations
      libbpf: Fix crash if SEC("freplace") programs don't have attach_prog_fd set
      selftests/bpf: Add veristat tool for mass-verifying BPF object files
      Merge branch 'bpf: Add user-space-publisher ring buffer map type'
      selftests/bpf: fix double bpf_object__close() in veristate
      selftests/bpf: add CSV output mode for veristat
      selftests/bpf: add comparison mode to veristat
      selftests/bpf: add ability to filter programs in veristat
      libbpf: restore memory layout of bpf_object_open_opts
      selftests/bpf: add sign-file to .gitignore
      selftests/bpf: make veristat's verifier log parsing faster and more robust
      selftests/bpf: make veristat skip non-BPF and failing-to-open BPF objects
      selftests/bpf: emit processing progress and add quiet mode to veristat
      selftests/bpf: allow to adjust BPF verifier log level in veristat
      libbpf: Don't require full struct enum64 in UAPI headers
      Merge branch 'Parameterize task iterators.'
      Merge branch 'bpf/selftests: convert some tests to ASSERT_* macros'
      Merge branch 'tools: bpftool: Remove unused struct'

André Apitzsch (1):
      r8152: Add MAC passthrough support for Lenovo Travel Hub

Andy Shevchenko (1):
      ptp_ocp: use device_find_any_child() instead of custom approach

Anirudh Venkataramanan (2):
      ice: Allow 100M speeds for some devices
      ice: Print human-friendly PHY types

Antoine Tenart (9):
      netfilter: conntrack: fix the gc rescheduling delay
      netfilter: conntrack: revisit the gc initial rescheduling bias
      net: phy: mscc: macsec: make the prepare phase a noop
      net: atlantic: macsec: make the prepare phase a noop
      net: macsec: remove the prepare phase when offloading
      net: phy: mscc: macsec: remove checks on the prepare phase
      net: atlantic: macsec: remove checks on the prepare phase
      net/mlx5e: macsec: remove checks on the prepare phase
      net: macsec: remove the prepare flag from the MACsec offloading context

Archie Pusaka (1):
      Bluetooth: hci_event: Fix checking conn for le_conn_complete_evt

Arkadiusz Kubalewski (2):
      ice: Merge pin initialization of E810 and E810T adapters
      ice: support features on new E810T variants

Arseniy Krasnov (9):
      vsock: SO_RCVLOWAT transport set callback
      hv_sock: disable SO_RCVLOWAT support
      virtio/vsock: use 'target' in notify_poll_in callback
      vmci/vsock: use 'target' in notify_poll_in callback
      vsock: pass sock_rcvlowat to notify_poll_in as target
      vsock: add API call for data ready
      virtio/vsock: check SO_RCVLOWAT before wake up reader
      vmci/vsock: check SO_RCVLOWAT before wake up reader
      vsock_test: POLLIN + SO_RCVLOWAT test

Artem Savkov (4):
      bpf: add destructive kfunc flag
      bpf: export crash_kexec() as destructive kfunc
      selftests/bpf: add destructive kfunc test
      selftests/bpf: Fix attach point for non-x86 arches in test_progs/lsm

Arun Ramadoss (10):
      net: dsa: microchip: add reference to ksz_device inside the ksz_port
      net: dsa: microchip: lan937x: clear the POR_READY_INT status bit
      net: dsa: microchip: lan937x: add interrupt support for port phy link
      net: dsa: microchip: add the support for set_ageing_time
      net: dsa: microchip: determine number of port irq based on switch type
      net: dsa: microchip: enable phy interrupts only if interrupt enabled in dts
      net: dsa: microchip: lan937x: return zero if mdio node not present
      net: dsa: microchip: move interrupt handling logic from lan937x to ksz_common
      net: dsa: microchip: use common irq routines for girq and pirq
      net: phy: micrel: enable interrupt for ksz9477 phy

Arınç ÜNAL (16):
      dt-bindings: net: dsa: mediatek,mt7530: make trivial changes
      dt-bindings: net: dsa: mediatek,mt7530: fix description of mediatek,mcm
      dt-bindings: net: dsa: mediatek,mt7530: fix reset lines
      dt-bindings: net: dsa: mediatek,mt7530: update examples
      dt-bindings: net: dsa: mediatek,mt7530: define phy-mode per switch
      dt-bindings: net: dsa: mediatek,mt7530: update binding description
      dt-bindings: net: drop old mediatek bindings
      dt-bindings: net: dsa: mediatek,mt7530: change mt7530 switch address
      dt-bindings: net: dsa: mediatek,mt7530: expand gpio-controller description
      dt-bindings: memory: mt7621: add syscon as compatible string
      mips: dts: ralink: mt7621: fix some dtc warnings
      mips: dts: ralink: mt7621: remove interrupt-parent from switch node
      mips: dts: ralink: mt7621: change phy-mode of gmac1 to rgmii
      mips: dts: ralink: mt7621: change mt7530 switch address
      mips: dts: ralink: mt7621: fix external phy on GB-PC2
      mips: dts: ralink: mt7621: add GB-PC2 LEDs

Aya Levin (2):
      net/mlx5: Expose NPPS related registers
      net/mlx5: Add support for NPPS with real time mode

Bagas Sanjaya (2):
      Documentation: sysctl: align cells in second content column
      Documentation: bpf: Add implementation notes documentations to table of contents

Baochen Qiang (5):
      wifi: ath11k: Split PCI write/read functions
      wifi: ath11k: implement SRAM dump debugfs interface
      wifi: ath11k: Include STA_KEEPALIVE_ARP_RESPONSE TLV header by default
      wifi: ath11k: Remove redundant ath11k_mac_drain_tx
      wifi: ath11k: Fix deadlock during WoWLAN suspend

Baowen Zheng (1):
      nfp: add support for eeprom get and set command

Beniamin Sandu (1):
      net: sfp: use simplified HWMON_CHANNEL_INFO macro

Benjamin Berg (3):
      wifi: mac80211: use correct rx link_sta instead of default
      wifi: mac80211: make smps_mode per-link
      wifi: mac80211: keep A-MSDU data in sta and per-link

Benjamin Hesmans (3):
      mptcp: add TCP_FASTOPEN_CONNECT socket option
      tcp: export tcp_sendmsg_fastopen
      mptcp: poll allow write call before actual connect

Benjamin Tissoires (10):
      btf: Add a new kfunc flag which allows to mark a function to be sleepable
      bpf: prepare for more bpf syscall to be used from kernel and user space.
      libbpf: add map_get_fd_by_id and map_delete_elem in light skeleton
      selftests/bpf: regroup and declare similar kfuncs selftests in an array
      bpf: split btf_check_subprog_arg_match in two
      bpf/verifier: allow all functions to read user provided context
      selftests/bpf: add test for accessing ctx from syscall program type
      bpf/btf: bump BTF_KFUNC_SET_MAX_CNT
      bpf/verifier: allow kfunc to return an allocated mem
      selftests/bpf: Add tests for kfunc returning a memory pointer

Bhupesh Sharma (1):
      net: stmmac: Minor spell fix related to 'stmmac_clk_csr_set()'

Biju Das (3):
      dt-bindings: can: nxp,sja1000: Document RZ/N1 power-domains support
      can: sja1000: Add support for RZ/N1 SJA1000 CAN Controller
      ravb: Add RZ/G2L MII interface support

Bitterblue Smith (6):
      wifi: rtl8xxxu: Fix skb misuse in TX queue selection
      wifi: rtl8xxxu: gen2: Fix mistake in path B IQ calibration
      wifi: rtl8xxxu: Remove copy-paste leftover in gen2_update_rate_mask
      wifi: rtl8xxxu: gen2: Enable 40 MHz channel width
      wifi: rtl8xxxu: Fix AIFS written to REG_EDCA_*_PARAM
      wifi: rtl8xxxu: Improve rtl8xxxu_queue_select

Bo Liu (1):
      ptp: Remove usage of the deprecated ida_simple_xxx API

Brian Gix (12):
      Bluetooth: Convert le_scan_disable timeout to hci_sync
      Bluetooth: Rework le_scan_restart for hci_sync
      Bluetooth: Delete unused hci_req_stop_discovery()
      Bluetooth: Convert SCO configure_datapath to hci_sync
      Bluetooth: Move Adv Instance timer to hci_sync
      Bluetooth: Delete unreferenced hci_request code
      Bluetooth: move hci_get_random_address() to hci_sync
      Bluetooth: convert hci_update_adv_data to hci_sync
      Bluetooth: Normalize HCI_OP_READ_ENC_KEY_SIZE cmdcmplt
      Bluetooth: Move hci_abort_conn to hci_conn.c
      Bluetooth: Implement support for Mesh
      Bluetooth: Add experimental wrapper for MGMT based mesh

Bryan O'Donoghue (1):
      wifi: wcn36xx: Add RX frame SNR as a source of system entropy

Casper Andersson (4):
      ethernet: Add helpers to recognize addresses mapped to IP multicast
      net: sparx5: add list for mdb entries in driver
      net: sparx5: add support for mrouter ports
      net: sparx5: fix function return type to match actual type

Cheng-Chieh Hsieh (1):
      wifi: rtw89: enlarge the CFO tracking boundary

Chia-Yuan Li (6):
      wifi: rtw89: 8852a: correct WDE IMR settings
      rtw89: 8852c: modify PCIE prebkf time
      rtw89: 8852c: adjust mactxen delay of mac/phy interface
      wifi: rtw89: 8852c: set TBTT shift configuration
      wifi: rtw89: pci: fix PCI PHY auto adaption by using software restore
      wifi: rtw89: set response rate selection

Chih-Kang Chang (9):
      wifi: rtw88: fix stopping queues in wrong timing when HW scan
      wifi: rtw88: fix store OP channel info timing when HW scan
      wifi: rtw88: add mutex when set SAR
      wifi: rtw88: add mutex when set regulatory and get Tx power table
      wifi: rtw88: add the update channel flow to support setting by parameters
      wifi: rtw88: fix WARNING:rtw_get_tx_power_params() during HW scan
      wifi: rtw88: add flushing queue before HW scan
      wifi: rtw88: add flag check before enter or leave IPS
      wifi: rtw88: prohibit enter IPS during HW scan

Chin-Yen Lee (7):
      wifi: rtw89: add retry to change power_mode state
      wifi: rtw89: pci: enable CLK_REQ, ASPM, L1 and L1ss for 8852c
      wifi: rtw89: pci: correct suspend/resume setting for variant chips
      wifi: rtw89: support deep ps mode for rtw8852c
      wifi: rtw89: call tx_wake notify for 8852c in deep ps mode
      wifi: rtw89: correct enable functions of HCI/PCI DMA
      wifi: rtw89: pci: concentrate control function of TX DMA channel

Ching-Te Ku (24):
      rtw89: coex: update radio state for RTL8852A/RTL8852C
      rtw89: coex: Move Wi-Fi firmware coexistence matching version to chip
      rtw89: coex: Add logic to parsing rtl8852c firmware type ctrl report
      rtw89: coex: Define BT B1 slot length
      rtw89: coex: Add v1 version TDMA format and parameters
      rtw89: coex: update WL role info v1 for RTL8852C branch using
      rtw89: coex: Move _set_policy to chip_ops
      rtw89: coex: Add v1 Wi-Fi SCC coexistence policy
      rtw89: coex: Update Wi-Fi driver/firmware TDMA cycle report for RTL8852c
      wifi: rtw89: coex: Add v1 Wi-Fi firmware power-saving null data report
      wifi: rtw89: coex: Move coexistence firmware buffer size parameter to chip info
      wifi: rtw89: coex: Parsing Wi-Fi firmware error message from reports
      wifi: rtw89: coex: Parsing Wi-Fi firmware TDMA info from reports
      wifi: rtw89: coex: Remove trace_step at COEX-MECH control structure for RTL8852C
      wifi: rtw89: coex: Combine set grant WL/BT and correct the debug log
      wifi: rtw89: coex: add v1 cycle report to parsing Bluetooth A2DP status
      wifi: rtw89: coex: translate slot ID to readable name
      wifi: rtw89: coex: add v1 summary info to parse the traffic status from firmware
      wifi: rtw89: coex: add v1 Wi-Fi firmware steps report
      wifi: rtw89: coex: add WL_S0 hardware TX/RX mask to allow WL_S0 TX/RX during GNT_BT
      wifi: rtw89: coex: modify LNA2 setting to avoid BT destroyed Wi-Fi aggregation
      wifi: rtw89: coex: summarize Wi-Fi to BT scoreboard and inform BT one time a cycle
      wifi: rtw89: coex: add logic to control BT scan priority
      wifi: rtw89: coex: update coexistence to 6.3.0

Chris Lu (1):
      Bluetooth: btusb: Add a new PID/VID 13d3/3578 for MT7921

Chris Mi (2):
      RDMA/mlx5: Move function mlx5_core_query_ib_ppcnt() to mlx5_ib
      net/mlx5: E-switch, Don't update group if qos is not enabled

Christian Marangi (1):
      wifi: ath11k: fix peer addition/deletion error on sta band migration

Christophe JAILLET (6):
      can: rcar_canfd: Use dev_err_probe() to simplify code and better handle -EPROBE_DEFER
      ice: switch: Simplify memory allocation
      ice: Simplify memory allocation in ice_sched_init_port()
      headers: Remove some left-over license text
      headers: Remove some left-over license text in include/uapi/linux/netfilter/
      headers: Remove some left-over license text

Chunhao Lin (1):
      r8169: add rtl_disable_rxdvgate()

Clark Wang (1):
      net: phy: realtek: add support for RTL8211F(D)(I)-VD-CG

Coco Li (1):
      gro: add support of (hw)gro packets to gro stack

Colin Foster (10):
      mfd: ocelot: Add helper to get regmap from a resource
      net: mdio: mscc-miim: add ability to be used in a non-mmio configuration
      pinctrl: ocelot: add ability to be used in a non-mmio configuration
      pinctrl: microchip-sgpio: allow sgpio driver to be used as a module
      pinctrl: microchip-sgpio: add ability to be used in a non-mmio configuration
      resource: add define macro for register address resources
      dt-bindings: mfd: ocelot: Add bindings for VSC7512
      mfd: ocelot: Add support for the vsc7512 chip via spi
      net: mscc: ocelot: utilize readx_poll_timeout() for chip reset
      net: mscc: ocelot: check return values of writes during reset

Colin Ian King (6):
      selftests/bpf: Fix spelling mistake.
      net: lan966x: Fix spelling mistake "tarffic" -> "traffic"
      bnx2: Fix spelling mistake "bufferred" -> "buffered"
      net: bna: Fix spelling mistake "muliple" -> "multiple"
      net/mlx5: Fix spelling mistake "syndrom" -> "syndrome"
      selftests/bpf: Fix spelling mistake "unpriviledged" -> "unprivileged"

Dan Carpenter (10):
      net: fman: memac: Uninitialized variable on error path
      net_sched: remove impossible conditions
      mlxsw: minimal: Return -ENOMEM on allocation failure
      wifi: rtl8xxxu: tighten bounds checking in rtl8xxxu_read_efuse()
      wifi: wfx: prevent underflow in wfx_send_pds()
      wifi: mt76: mt7915: fix an uninitialized variable bug
      wifi: mt76: mt7921: fix use after free in mt7921_acpi_read()
      wifi: mt76: mt7921: delete stray if statement
      iov_iter: use "maxpages" parameter
      wifi: rtw89: uninitialized variable on error in rtw89_early_fw_feature_recognize()

Daniel Borkmann (2):
      Merge branch 'bpf-allocator'
      libbpf: Remove gcc support for bpf_tail_call_static for now

Daniel Golle (14):
      Bluetooth: btusb: Add a new VID/PID 0e8d/0608 for MT7921
      net: dsa: mt7530: add support for in-band link status
      wifi: rt2x00: add support for external PA on MT7620
      wifi: rt2x00: move up and reuse busy wait functions
      wifi: rt2x00: don't run Rt5592 IQ calibration on MT7620
      wifi: rt2x00: move helper functions up in file
      wifi: rt2x00: fix HT20/HT40 bandwidth switch on MT7620
      wifi: rt2x00: set correct TX_SW_CFG1 MAC register for MT7620
      wifi: rt2x00: set VGC gain for both chains of MT7620
      wifi: rt2x00: set SoC wmac clock register
      wifi: rt2x00: correctly set BBP register 86 for MT7620
      net: ethernet: mtk_eth_soc: fix wrong use of new helper function
      net: ethernet: mtk_eth_soc: fix usage of foe_entry_size
      net: ethernet: mtk_eth_soc: fix state in __mtk_foe_entry_clear

Daniel Machon (5):
      net: microchip: sparx5: add tc setup hook
      net: microchip: sparx5: add support for offloading mqprio qdisc
      net: microchip: sparx5: add support for offloading tbf qdisc
      net: microchip: sparx5: add support for offloading ets qdisc
      maintainers: update MAINTAINERS file.

Daniel Müller (2):
      selftests/bpf: Add cb_refs test to s390x deny list
      selftests/bpf: Store BPF object files with .bpf.o extension

Daniel Xu (14):
      selftests/bpf: Fix vmtest.sh -h to not require root
      selftests/bpf: Fix vmtest.sh getopts optstring
      selftests/bpf: Add existing connection bpf_*_ct_lookup() test
      selftests/bpf: Add connmark read test
      selftests/bpf: Update CI kconfig
      bpf: Remove duplicate PTR_TO_BTF_ID RO check
      bpf: Add stub for btf_struct_access()
      bpf: Use 0 instead of NOT_INIT for btf_struct_access() writes
      bpf: Export btf_type_by_id() and bpf_log()
      bpf: Add support for writing to nf_conn:mark
      selftests/bpf: Add tests for writing to nf_conn:mark
      bpf: Remove unused btf_struct_access stub
      bpf: Rename nfct_bsa to nfct_btf_struct_access
      bpf: Move nf_conn extern declarations to filter.h

Dario Binacchi (1):
      docs: networking: device drivers: flexcan: fix invalid email

Dave Marchevsky (4):
      bpf: Improve docstring for BPF_F_USER_BUILD_ID flag
      bpf: Cleanup check_refcount_ok
      bpf: Add verifier support for custom callback return range
      bpf: Add verifier check for BPF_PTR_POISON retval and arg

Dave Thaler (5):
      bpf, docs: Move legacy packet instructions to a separate file
      bpf, docs: Linux byteswap note
      bpf, docs: Move Clang notes to a separate file
      bpf, docs: Add Clang note about BPF_ALU
      bpf, docs: Add TOC and fix formatting.

David Bauer (1):
      wifi: rt2x00: add throughput LED trigger

David S. Miller (57):
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/nex t-queue
      Merge branch 'wwan-t7xx-fw-flashing-and-coredump-support'
      Merge branch 'net-phy-QUSGMII'
      Merge branch 'tsnep-minor-improvements'
      Merge branch 'lan966x-lag-support'
      Merge branch 'j7200-support'
      Merge tag 'mlx5-updates-2022-08-22' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'r8169-next'
      Merge branch 'prestera-matchall'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge tag 'wireless-next-2022-08-26-v2' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
      Merge branch 'sparx5-mrouter'
      Merge branch 'net-dsa-microchip-error-hndling-reg-access-validation'
      Merge branch 'thunderbolt-end-to-end-flow-control'
      Merge branch 'hns3-next'
      Merge branch 'lan966x-make-reset-optional'
      Merge branch 'net-ipa-transaction-state-IDs'
      Merge branch 'net_sched-redundant-resource-cleanups'
      Merge tag 'wireless-next-2022-09-03' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
      Merge branch 'altera-tse-phylink'
      Merge branch 'ipa-transaction-IDs'
      Merge branch 'lan937x-phy-link-interrupt'
      Merge branch 'dpaa-cleanups'
      Merge branch 'sfc-ptp'
      Merge branch 'netlink-be-policy'
      Merge branch 'macsec-offload-mlx5'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'hns3-new-features'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next
      Merge branch 'lan743x-next'
      Merge branch 'tc_action_ops-refactor'
      Merge branch 'felix-dsa-ethtool-stats'
      Merge branch 'net-ipa-next'
      Merge branch 'net-amd-static-checker-warnings'
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'net-tc-testing-new-tests'
      Merge tag 'linux-can-next-for-6.1-20220915' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge branch 'octeontx2-cn10k-ptp'
      Merge branch 'net-dev_err_probe'
      Merge branch 'sparx5-qos'
      Merge branch 'mt7621-dt'
      Merge branch 'phy-rate-matching'
      Merge branch 'lan966x-mqprio-taprio'
      Merge branch 'tc-testing-qdisc'
      Merge branch 'lan966x-qos'
      Merge branch 'sfc-tc-offload'
      Merge branch 'net-tsnep-multiqueue'
      Merge branch 'Mediatek-mt8188'
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec
      Merge branch 'tc-bind_class-hook'
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next
      Merge branch 'ip_tunnel-netlink-parms'
      Merge branch 'RollBall-Hilink-Turris-10G-copper-SFP-support'
      Merge branch 'mptcp-fastclose'
      Merge branch 'lan966x-police-mirroring'
      Merge branch 'octeontx2-macsec-offload'

David Vernet (4):
      bpf: Define new BPF_MAP_TYPE_USER_RINGBUF map type
      bpf: Add bpf_user_ringbuf_drain() helper
      bpf: Add libbpf logic for user-space ring buffer
      selftests/bpf: Add selftests validating the user ringbuf

David Wu (1):
      net: ethernet: stmmac: dwmac-rk: Add gmac support for rk3588

Deming Wang (1):
      samples/bpf: Fix typo in xdp_router_ipv4 sample

Deren Wu (4):
      wifi: mt76: mt7921e: fix rmmod crash in driver reload test
      wifi: mt76: mt7921e: fix random fw download fail
      wifi: mt76: mt7663s: Switch to DEFINE_SIMPLE_DEV_PM_OPS() and pm_sleep_ptr()
      wifi: mt76: mt7921s: Switch to DEFINE_SIMPLE_DEV_PM_OPS() and pm_sleep_ptr()

Dian-Syuan Yang (3):
      wifi: rtw89: send OFDM rate only in P2P mode
      wifi: rtw89: support WMM-PS in P2P GO mode
      wifi: rtw89: support for processing P2P power saving

Divya Koppera (1):
      net: phy: micrel: Cable Diag feature for lan8814 phy

Dmitry Torokhov (4):
      net: davicom: dm9000: switch to using gpiod API
      net: ks8851: switch to using gpiod API
      net: phy: spi_ks8895: switch to using gpiod API
      dt-bindings: nfc: marvell,nci: fix reset line polarity in examples

Dmytro Shytyi (1):
      mptcp: handle defer connect in mptcp_sendmsg

Donald Hunter (1):
      Add skb drop reasons to IPv6 UDP receive path

Duoming Zhou (2):
      mwifiex: fix sleep in atomic context bugs caused by dev_coredumpv
      mISDN: fix use-after-free bugs in l1oip timer handlers

Edward Cree (7):
      docs: net: add an explanation of VF (and other) Representors
      sfc: bind blocks for TC offload on EF100
      sfc: bind indirect blocks for TC offload on EF100
      sfc: optional logging of TC offload errors
      sfc: add a hashtable for offloaded TC rules
      sfc: interrogate MAE capabilities at probe time
      sfc: bare bones TC offload on EF100

Emeel Hakim (11):
      net: macsec: Expose MACSEC_SALT_LEN definition to user space
      net: macsec: Expose extended packet number (EPN) properties to macsec offload
      net/mlx5: Fix fields name prefix in MACsec
      net/mlx5e: Fix MACsec initialization error path
      net/mlx5e: Fix MACsec initial packet number
      net/mlx5: Add ifc bits for MACsec extended packet number (EPN) and replay protection
      net/mlx5e: Expose memory key creation (mkey) function
      net/mlx5e: Create advanced steering operation (ASO) object for MACsec
      net/mlx5e: Move MACsec initialization from profile init stage to profile enable stage
      net/mlx5e: Support MACsec offload extended packet number (EPN)
      net/mlx5e: Support MACsec offload replay window

Eric Dumazet (5):
      tcp: annotate data-race around tcp_md5sig_pool_populated
      ipv6: tcp: send consistent autoflowlabel in SYN_RECV state
      net: bql: add more documentation
      ipv6: tcp: send consistent autoflowlabel in RST packets
      once: add DO_ONCE_SLOW() for sleepable contexts

Eric Huang (1):
      wifi: rtw89: add DIG register struct to share common algorithm

Eyal Birger (4):
      bpf/scripts: Assert helper enum value is aligned with comment order
      net: allow storing xfrm interface metadata in metadata_dst
      xfrm: interface: support collect metadata mode
      xfrm: lwtunnel: add lwtunnel support for xfrm interfaces in collect_md mode

Fabio M. De Francesco (1):
      ixgbe: Don't call kmap() on page allocated with GFP_ATOMIC

Fabio Porcedda (2):
      net: wwan: mhi_wwan_ctrl: Add DUN2 to have a secondary AT port
      bus: mhi: host: pci_generic: Add a secondary AT port to Telit FN990

Fae (1):
      Bluetooth: Add VID/PID 0489/e0e0 for MediaTek MT7921

Fei Qin (1):
      nfp: add support restart of link auto-negotiation

Fernando Fernandez Mancera (1):
      Documentation: bonding: clarify supported modes for tlb_dynamic_lb

Florian Fainelli (4):
      libbpf: Initialize err in probe_map_create
      net: phy: broadcom: Implement suspend/resume for AC131 and BCM5241
      net: dsa: bcm_sf2: Introduce helper for port override offset
      net: dsa: bcm_sf2: Have PHYLINK configure CPU/IMP port(s)

Florian Westphal (9):
      netlink: introduce NLA_POLICY_MAX_BE
      netfilter: nft_payload: reject out-of-range attributes via policy
      netfilter: conntrack: prepare tcp_in_window for ternary return value
      netfilter: conntrack: ignore overly delayed tcp packets
      netfilter: conntrack: remove unneeded indent level
      netfilter: conntrack: reduce timeout when receiving out-of-window fin or rst
      netfilter: remove NFPROTO_DECNET
      netfilter: nat: move repetitive nat port reserve loop to a helper
      netfilter: nat: avoid long-running port range loop

GUO Zihua (4):
      net: broadcom: Fix return type for implementation of
      net: xscale: Fix return type for implementation of ndo_start_xmit
      net: sunplus: Fix return type for implementation of ndo_start_xmit
      net: lantiq_etop: Fix return type for implementation of ndo_start_xmit

Gal Pressman (7):
      net: ieee802154: Fix compilation error when CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled
      net/tls: Use cipher sizes structs
      net/tls: Support 256 bit keys with TX device offload
      net/mlx5e: Support 256 bit keys with kTLS device offload
      net/mlx5: Remove unused functions
      net/mlx5: Remove unused structs
      net/mlx5e: Expose rx_oversize_pkts_buffer counter

Gaosheng Cui (6):
      net: ethernet: remove fs_mii_disconnect and fs_mii_connect declarations
      rxrpc: remove rxrpc_max_call_lifetime declaration
      mlxsw: reg: Remove deprecated code about SFTR-V2 Register
      neighbour: Remove unused inline function neigh_key_eq16()
      net: Remove unused inline function sk_nulls_node_init()
      net: Remove unused inline function dst_hold_and_use()

Gautam Menghani (1):
      selftests/net: Refactor xfrm_fill_key() to use array of structs

Geert Uytterhoeven (3):
      dt-bindings: net: renesas,etheravb: R-Car V3U is R-Car Gen4
      dt-bindings: net: renesas,etheravb: Add r8a779g0 support
      net: ravb: Add R-Car Gen4 support

Geetha sowjanya (7):
      octeontx2-af: cn10k: Introduce driver for macsec block.
      octeontx2-af: cn10k: mcs: Add mailboxes for port related operations
      octeontx2-af: cn10k: mcs: Manage the MCS block hardware resources
      octeontx2-af: cn10k: mcs: Install a default TCAM for normal traffic
      octeontx2-af: cn10k: mcs: Support for stats collection
      octeontx2-af: cn10k: mcs: Handle MCS block interrupts
      octeontx2-af: cn10k: mcs: Add debugfs support

Geliang Tang (2):
      selftests: mptcp: move prefix tests of addr_nr_ns2 together
      mptcp: add do_check_data_fin to replace copied

Gergo Koteles (1):
      wifi: mt76: mt76_usb.mt76u_mcu.burst is always false remove related code

Gerhard Engleder (11):
      tsnep: Fix TSNEP_INFO_TX_TIME register define
      tsnep: Add loopback support
      tsnep: Improve TX length handling
      tsnep: Support full DMA mask
      tsnep: Record RX queue
      dt-bindings: net: tsnep: Allow dma-coherent
      dt-bindings: net: tsnep: Allow additional interrupts
      tsnep: Move interrupt from device to queue
      tsnep: Support multiple TX/RX queue pairs
      tsnep: Add EtherType RX flow classification support
      tsnep: Use page pool for RX

Guangbin Huang (8):
      net: hns3: add getting capabilities of gro offload and fd from firmware
      net: hns3: add querying fec ability from firmware
      net: hns3: net: hns3: add querying and setting fec off mode from firmware
      net: hns3: add support config dscp map to tc
      net: hns3: support ndo_select_queue()
      net: hns3: debugfs add dump dscp map info
      net: hns3: optimize converting dscp to priority process of hns3_nic_select_queue()
      net: hns3: add judge fd ability for sync and clear process of flow director

Guillaume Nault (2):
      netfilter: rpfilter: Remove unused variable 'ret'.
      net: Remove DECnet leftovers from flow.h.

Guofeng Yue (3):
      net: amd: Unified the comparison between pointers and NULL to the same writing
      net: amd: Correct spelling errors
      net: amd: Switch and case should be at the same indent

Gustavo A. R. Silva (6):
      net/ipv4: Use __DECLARE_FLEX_ARRAY() helper
      can: etas_es58x: Replace zero-length array with DECLARE_FLEX_ARRAY() helper
      ipw2x00: Replace zero-length array with DECLARE_FLEX_ARRAY() helper
      iwlegacy: Replace zero-length arrays with DECLARE_FLEX_ARRAY() helper
      net: ethernet: rmnet: Replace zero-length array with DECLARE_FLEX_ARRAY() helper
      netns: Replace zero-length array with DECLARE_FLEX_ARRAY() helper

Haijun Liu (3):
      net: wwan: t7xx: Add AP CLDMA
      net: wwan: t7xx: Infrastructure for early port configuration
      net: wwan: t7xx: PCIe reset rescan

Haim Dreyfuss (5):
      wifi: iwlwifi: mvm: don't check D0I3 version
      wifi: iwlwifi: mvm: Add support for wowlan info notification
      wifi: iwlwifi: mvm: Add support for wowlan wake packet notification
      wifi: iwlwifi: mvm: Add support for d3 end notification
      wifi: iwlwifi: mvm: enable resume based on notifications

Haim, Dreyfuss (1):
      wifi: iwlwifi: mvm: trigger resume flow before wait for notifications

Hangbin Liu (3):
      libbpf: Add names for auxiliary maps
      libbpf: Making bpf_prog_load() ignore name if kernel doesn't support
      selftests/bonding: add a test for bonding lladdr target

Hans de Goede (4):
      Bluetooth: hci_event: Fix vendor (unknown) opcode status handling
      wifi: brcmfmac: Use ISO3166 country code and rev 0 as fallback on 43430
      wifi: brcmfmac: Add DMI nvram filename quirk for Chuwi Hi8 Pro tablet
      wifi: rt2x00: Fix "Error - Attempt to send packet over invalid queue 2"

Hao Chen (1):
      net: hns3: add support to query and set lane number by ethtool

Hao Lan (3):
      net: hns3: add querying and setting fec llrs mode from firmware
      net: hns3: add querying fec statistics
      net: hns3: refactor function hclge_mbx_handler()

Hao Luo (7):
      bpf, iter: Fix the condition on p when calling stop.
      libbpf: Allows disabling auto attach
      selftests/bpf: Tests libbpf autoattach APIs
      bpf: Introduce cgroup iter
      selftests/bpf: Test cgroup_iter.
      bpf: Add CGROUP prefix to cgroup_iter_order
      bpftool: Add support for querying cgroup_iter link

Haoyue Xu (1):
      net: ll_temac: Cleanup for function name in a string

Hari Chandrakanthan (1):
      wifi: mac80211: allow bw change during channel switch in mesh

Hariprasad Kelam (1):
      octeontx2-pf: Add support for ptp 1-step mode on CN10K silicon

Hector Martin (12):
      dt-bindings: net: bcm4329-fmac: Add Apple properties & chips
      wifi: brcmfmac: firmware: Handle per-board clm_blob files
      wifi: brcmfmac: pcie/sdio/usb: Get CLM blob via standard firmware mechanism
      wifi: brcmfmac: firmware: Support passing in multiple board_types
      wifi: brcmfmac: pcie: Read Apple OTP information
      wifi: brcmfmac: of: Fetch Apple properties
      wifi: brcmfmac: pcie: Perform firmware selection for Apple platforms
      wifi: brcmfmac: firmware: Allow platform to override macaddr
      wifi: brcmfmac: msgbuf: Increase RX ring sizes to 1024
      wifi: brcmfmac: pcie: Support PCIe core revisions >= 64
      wifi: brcmfmac: pcie: Add IDs/properties for BCM4378
      arm64: dts: apple: Add WiFi module and antenna properties

Heiner Kallweit (14):
      r8169: remove support for chip version 41
      r8169: remove support for chip versions 45 and 47
      r8169: remove support for chip version 49
      r8169: remove support for chip version 50
      r8169: remove support for chip version 60
      net: phy: smsc: use device-managed clock API
      r8169: merge handling of chip versions 12 and 17 (RTL8168B)
      r8169: remove comment about apparently non-existing chip versions
      r8169: use devm_clk_get_optional_enabled() to simplify the code
      r8169: remove useless PCI region size check
      r8169: remove not needed net_ratelimit() check
      r8169: merge support for chip versions 10, 13, 16
      r8169: remove rtl_wol_shutdown_quirk()
      r8169: disable detection of chip version 36

Hengqi Chen (1):
      libbpf: Do not require executable permission for shared libraries

Hongbin Wang (2):
      xfrm: Drop unused argument
      ip6_vti:Remove the space before the comma

Horatiu Vultur (20):
      net: lan966x: Add registers used to configure lag interfaces
      net: lan966x: Split lan966x_fdb_event_work
      net: lan966x: Flush fdb workqueue when port is leaving a bridge.
      net: lan966x: Expose lan966x_switchdev_nb and lan966x_switchdev_blocking_nb
      net: lan966x: Extend lan966x_foreign_bridging_check
      net: lan966x: Add lag support for lan966x
      net: lan966x: Extend FDB to support also lag
      net: lan966x: Extend MAC to support also lag interfaces.
      net: lan966x: Extend lan966x with RGMII support
      net: phy: micrel: Add interrupts support for LAN8804 PHY
      net: phy: micrel: Fix double spaces inside lan8814_config_intr
      net: lan966x: Add define for number of priority queues NUM_PRIO_QUEUES
      net: lan966x: Add offload support for mqprio
      net: lan966x: Add registers used by taprio
      net: lan966x: Add offload support for taprio
      net: lan966x: Add offload support for tbf
      net: lan966x: Add offload support for cbs
      net: lan966x: Add offload support for ets
      net: lan966x: Add port police support using tc-matchall
      net: lan966x: Add port mirroring support using tc-matchall

Hou Tao (13):
      bpf: Disable preemption when increasing per-cpu map_locked
      bpf: Propagate error from htab_lock_bucket() to userspace
      selftests/bpf: Add test cases for htab update
      bpf: Use this_cpu_{inc|dec|inc_return} for bpf_task_storage_busy
      bpf: Use this_cpu_{inc_return|dec} for prog->active
      selftests/bpf: Move sys_pidfd_open() into task_local_storage_helpers.h
      selftests/bpf: Test concurrent updates on bpf_task_storage_busy
      bpf: Only add BTF IDs for socket security hooks when CONFIG_SECURITY_NETWORK is on
      selftests/bpf: Add test result messages for test_task_storage_map_stress_lookup
      bpf: Check whether or not node is NULL before free it in free_bulk
      bpf: Always use raw spinlock for hash bucket lock
      selftests/bpf: Destroy the skeleton when CONFIG_PREEMPT is off
      selftests/bpf: Free the allocated resources after test case succeeds

Howard Hsu (2):
      wifi: mt76: mt7915: fix mcs value in ht mode
      wifi: mt76: mt7915: do not check state before configuring implicit beamform

Hui Zhou (2):
      nfp: flower: support hw offload for ct nat action
      nfp: flower: support vlan action in pre_ct

Ian Rogers (1):
      selftests/xsk: Avoid use-after-free on ctx

Ilan Peer (2):
      wifi: cfg80211: Update RNR parsing to align with Draft P802.11be_D2.0
      wifi: iwlwifi: mvm: Add handling for scan offload match info notification

Jack Wang (1):
      net/mlx4: Fix error check for dma_map_sg

Jacob Keller (7):
      ice: set tx_tstamps when creating new Tx rings via ethtool
      ice: initialize cached_phctime when creating Rx rings
      ice: track Tx timestamp stats similar to other Intel drivers
      ice: track and warn when PHC update is late
      ice: re-arrange some static functions in ice_ptp.c
      ice: introduce ice_ptp_reset_cached_phctime function
      ice: Add additional flags to ice_nvm_write_activate

Jakub Kicinski (93):
      Merge branch 'net-dsa-bcm_sf2-utilize-phylink-for-all-ports'
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge branch 'add-dt-property-to-disable-hibernation-mode'
      Merge branch 'selftests-mlxsw-add-ordering-tests-for-unified-bridge-model'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Revert "Merge branch 'wwan-t7xx-fw-flashing-and-coredump-support'"
      Merge branch 'net-dpaa-cleanups-in-preparation-for-phylink-conversion'
      Merge branch 'validate-of-nodes-for-dsa-shared-ports'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch '10GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      net: improve and fix netlink kdoc
      docs: netlink: basic introduction to Netlink
      Merge branch 'mlxsw-introduce-modular-system-support-by-minimal-driver'
      Merge branch 'add-interface-mode-select-and-rmii'
      Merge branch 'add-a-second-bind-table-hashed-by-port-and-address'
      Merge branch 'net-devlink-sync-flash-and-dev-info-commands'
      Merge branch 'mlxsw-remove-some-unused-code'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'openvswitch-allow-specifying-ifindex-of-new-interfaces'
      genetlink: start to validate reserved header bytes
      netlink: factor out extack composition
      netlink: add support for ext_ack missing attributes
      netlink: add helpers for extack attr presence checking
      devlink: use missing attribute ext_ack
      ethtool: strset: report missing ETHTOOL_A_STRINGSET_ID via ext_ack
      ethtool: report missing header via ext_ack in the default handler
      Merge branch 'completely-rework-mediatek-mt7530-binding'
      Merge branch 'mlxsw-configure-max-lag-id-for-spectrum-4'
      Merge branch 'net-sched-remove-unused-variables'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      net: remove netif_tx_napi_add()
      Merge tag 'ib-mfd-net-pinctrl-v6.0' of git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd
      Merge branch 'add-fec-support-on-s32v234-platform'
      Merge branch 'dt-bindings-net-renesas-etheravb-r-car-gen4-updates'
      Merge branch 'standardized-ethtool-counters-for-nxp-enetc'
      Merge branch 'remove-label-cpu-from-dsa-dt-bindings'
      Merge branch 'mlxsw-adjust-qos-tests-for-spectrum-4-testing'
      Merge tag 'batadv-next-pullrequest-20220916' of git://git.open-mesh.org/linux-merge
      Merge branch 'net-ipa-a-mix-of-cleanups'
      Merge branch 'sfp-add-support-for-halny-gpon-module'
      Merge branch 'macb-add-zynqmp-sgmii-dynamic-configuration-support'
      Merge branch 'tcp-introduce-optional-per-netns-ehash'
      Merge branch 'nfp-flower-police-validation-and-ct-enhancements'
      Merge branch 'small-tc-taprio-improvements'
      Merge branch 'refactor-duplicate-codes-in-the-tc-cls-walk-function'
      Merge branch 'add-a-secondary-at-port-to-the-telit-fn990'
      Merge branch 'net-hns3-updates-for-next'
      Merge branch 'net-ll_temac-cleanup-for-clearing-static-warnings'
      Merge branch 'clean-up-ocelot_reset-routine'
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'support-256-bit-tls-keys-with-device-offload'
      Merge branch 'refactor-duplicate-codes-in-the-qdisc-class-walk-function'
      Merge branch 'cleanup-in-huawei-hinic-driver'
      Merge branch 'mlx5-macsec-extended-packet-number-and-replay-window-offload'
      Merge branch 'net-dsa-remove-unnecessary-set_drvdata'
      Merge branch 'net-macsec-remove-the-preparation-phase-when-offloading-operations'
      Merge tag 'linux-can-next-for-6.1-20220923' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge branch 'net-ipa-another-set-of-cleanups'
      Merge branch 'remove-useless-inline-functions-from-net'
      Merge branch 'net-dsa-microchip-ksz9477-enable-interrupt-for-internal-phy-link-detection'
      Merge branch 'improve-tsn_lib-selftests-for-future-distributed-tasks'
      Merge branch 'net-dsa-remove-unnecessary-i2c_set_clientdata'
      Merge branch 'net-sunhme-cleanups-and-logging-improvements'
      Merge branch 'devlink-fix-order-of-port-and-netdev-register-in-drivers'
      Merge branch 'net-ipa-generalized-register-definitions'
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next
      Merge branch 'shrink-struct-ubuf_info'
      Merge branch 'mptcp-mptcp-support-for-tcp_fastopen_connect'
      net: drop the weight argument from netif_napi_add
      Merge branch 'rework-resource-allocation-in-felix-dsa-driver'
      Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux
      Merge tag 'mlx5-updates-2022-09-27' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      docs: netlink: clarify the historical baggage of Netlink flags
      Merge branch 'add-tc-taprio-support-for-queuemaxsdu'
      eth: alx: take rtnl_lock on resume
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'mlx5-xsk-updates-part2-2022-09-28'
      Merge tag 'wireless-next-2022-09-30' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
      genetlink: reject use of nlmsg_flags for new commands
      Merge tag 'for-net-next-2022-09-30' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next
      Merge branch 'devlink-sanitize-per-port-region-creation-destruction'
      Merge branch 'nfp-support-fec-mode-reporting-and-auto-neg'
      Merge branch 'mlx5-xsk-updates-part3-2022-09-30'
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge branch 'mlx5-xsk-updates-part4-and-more'
      eth: octeon: fix build after netif_napi_add() changes
      Merge branch 'net-marvell-prestera-add-nexthop-routes-offloading'
      Merge branch 'add-generic-pse-support'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      eth: pse: add missing static inlines

Jalal Mostafa (1):
      xsk: Inherit need_wakeup flag for shared sockets

Jamal Hadi Salim (1):
      net: sched: remove unused tcf_result extension

James Hilliard (7):
      libbpf: Skip empty sections in bpf_object__init_global_data_maps
      libbpf: Ensure functions with always_inline attribute are inline
      selftests/bpf: fix type conflict in test_tc_dtime
      selftests/bpf: Declare subprog_noise as static in tailcall_bpf2bpf4
      selftests/bpf: Fix bind{4,6} tcp/socket header type conflict
      selftests/bpf: Fix connect4_prog tcp/socket header type conflict
      libbpf: Add GCC support for bpf_tail_call_static

James Prestwood (2):
      wifi: nl80211: Add POWERED_ADDR_CHANGE feature
      wifi: mac80211: Support POWERED_ADDR_CHANGE feature

Jaroslaw Gawin (1):
      i40e: add description and modify interrupts configuration procedure

Jason A. Donenfeld (1):
      once: rename _SLOW to _SLEEPABLE

Jason Wang (2):
      wifi: mwifiex: Fix comment typo
      wifi: p54: Fix comment typo

Jean-Francois Le Fillatre (1):
      r8152: add PID for the Lenovo OneLink+ Dock

Jeff Daly (1):
      ixgbe: Manual AN-37 for troublesome link partners for X550 SFI

Jeff Johnson (3):
      wifi: ath10k: Fix miscellaneous spelling errors
      wifi: ath11k: Fix miscellaneous spelling errors
      wifi: ath11k: Fix kernel-doc issues

Jerry Ray (3):
      micrel: ksz8851: fixes struct pointer issue
      net: dsa: LAN9303: Add early read to sync
      net: dsa: LAN9303: Add basic support for LAN9354

Jesper Dangaard Brouer (3):
      bpf: Add BPF-helper for accessing CLOCK_TAI
      xdp: improve page_pool xdp_return performance
      xdp: Adjust xdp_frame layout to avoid using bitfields

Jesse Brandeburg (1):
      ice: Implement control of FCS/CRC stripping

Jesus Fernandez Manzano (1):
      wifi: ath11k: fix number of VHT beamformee spatial streams

Jian Shen (1):
      net: ethernet: ti: am65-cpsw: remove unused parameter of am65_cpsw_nuss_common_open()

Jianbo Liu (2):
      net/mlx5: E-Switch, Add default drop rule for unmatched packets
      net/mlx5: E-Switch, Return EBUSY if can't get mode lock

Jianglei Nie (2):
      wifi: ath11k: mhi: fix potential memory leak in ath11k_mhi_register()
      bnx2x: fix potential memory leak in bnx2x_tpa_stop()

Jianguo Zhang (4):
      dt-bindings: net: mediatek-dwmac: add support for mt8188
      dt-bindings: net: snps,dwmac: add new property snps,clk-csr
      arm64: dts: mediatek: mt2712e: Update the name of property 'clk_csr'
      net: stmmac: add a parse for new property 'snps,clk-csr'

Jiapeng Chong (1):
      bpf: Remove useless else if

Jiasheng Jiang (1):
      net: prestera: acl: Add check for kmemdup

Jie Meng (1):
      tcp: Make SYN ACK RTO tunable by BPF programs with TFO

Jilin Yuan (5):
      net: openvswitch: fix repeated words in comments
      vsock/vmci: fix repeated words in comments
      wifi: wcn36xx: fix repeated words in comments
      wifi: ath9k: fix repeated to words in a comment
      wifi: ath9k: fix repeated the words in a comment

Jinpeng Cui (7):
      netdevsim: remove redundant variable ret
      wifi: wilc1000: remove redundant ret variable
      wifi: nl80211: remove redundant err variable
      can: sja1000: remove redundant variable ret
      can: kvaser_pciefd: remove redundant variable ret
      wifi: brcmfmac: remove redundant variable err
      net: sched: act_ct: remove redundant variable err

Jiri Olsa (8):
      bpf: Move bpf_dispatcher function out of ftrace locations
      bpf: Prevent bpf program recursion for raw tracepoint probes
      kprobes: Add new KPROBE_FLAG_ON_FUNC_ENTRY kprobe flag
      ftrace: Keep the resolved addr in kallsyms_callback
      bpf: Use given function address for trampoline ip arg
      bpf: Adjust kprobe_multi entry_ip for CONFIG_X86_KERNEL_IBT
      bpf: Return value in kprobe get_func_ip only for entry address
      selftests/bpf: Fix get_func_ip offset test for CONFIG_X86_KERNEL_IBT

Jiri Pirko (20):
      Documentation: devlink: fix the locking section
      net: devlink: extend info_get() version put to indicate a flash component
      netdevsim: add version fw.mgmt info info_get() and mark as a component
      net: devlink: limit flash component name to match version returned by info_get()
      mlxsw: Remove unused IB stuff
      mlxsw: Remove unused port_type_set devlink op
      mlxsw: Remove unused mlxsw_core_port_type_get()
      mlx4: Do type_clear() for devlink ports when type_set() was called previously
      net: devlink: add RNLT lock assertion to devlink_compat_switch_id_get()
      genetlink: hold read cb_lock during iteration of genl_fam_idr in genl_bind()
      net: devlink: stub port params cmds for they are unused internally
      funeth: remove pointless check of devlink pointer in create/destroy_netdev() flows
      funeth: unregister devlink port after netdevice unregister
      ice: reorder PF/representor devlink port register/unregister flows
      ionic: change order of devlink port register and netdev register
      net: devlink: introduce port registered assert helper and use it
      net: devlink: introduce a flag to indicate devlink port being registered
      net: devlink: add port_init/fini() helpers to allow pre-register/post-unregister functions
      net: dsa: move port_setup/teardown to be called outside devlink port registered area
      net: dsa: don't do devlink port setup early

Joanne Koong (7):
      selftests/bpf: Clean up sys_nanosleep uses
      bpf: Verifier cleanups
      bpf: Fix ref_obj_id for dynptr data slices in verifier
      selftests/bpf: add extra test for using dynptr data slice after release
      net: Add a bhash2 table hashed by port and address
      selftests/net: Add test for timing a bind request to a port with a populated bhash entry
      selftests/net: Add sk_bind_sendto_listen and sk_connect_zero_addr

Johannes Berg (56):
      wifi: mac80211: accept STA changes without link changes
      wifi: mac80211: fix use-after-free
      wifi: mac80211: properly implement MLO key handling
      wifi: mac80211: use link ID for MLO in queued frames
      wifi: mac80211_hwsim: split iftype data into AP/non-AP
      wifi: cfg80211/mac80211: check EHT capability size correctly
      wifi: mac80211: maintain link_id in link_sta
      wifi: mac80211_hwsim: fix link change handling
      wifi: mac80211: set link ID in TX info for beacons
      wifi: mac80211: fix control port frame addressing
      wifi: mac80211: allow link address A2 in TXQ dequeue
      wifi: mac80211: correct SMPS mode in HE 6 GHz capability
      wifi: mac80211: prevent VLANs on MLDs
      wifi: mac80211: prevent 4-addr use on MLDs
      wifi: mac80211_hwsim: remove multicast workaround
      wifi: mac80211: remove unused arg to ieee80211_chandef_eht_oper
      wifi: mac80211_hwsim: check STA magic in change_sta_links
      wifi: mac80211_hwsim: refactor RX a bit
      wifi: mac80211: move link code to a new file
      wifi: mac80211: mlme: assign link address correctly
      wifi: mac80211: fix double SW scan stop
      wifi: mac80211_hwsim: warn on invalid link address
      wifi: mac80211: mlme: refactor QoS settings code
      wifi: nl80211: add MLD address to assoc BSS entries
      wifi: mac80211: call drv_sta_state() under sdata_lock() in reconfig
      wifi: mac80211_hwsim: fix multi-channel handling in netlink RX
      Merge remote-tracking branch 'wireless/main' into wireless-next
      wifi: mac80211: set link_sta in reorder timeout
      wifi: mac80211: isolate driver from inactive links
      wifi: mac80211: add ieee80211_find_sta_by_link_addrs API
      wifi: mac80211_hwsim: skip inactive links on TX
      wifi: mac80211_hwsim: track active STA links
      wifi: mac80211: extend ieee80211_nullfunc_get() for MLO
      wifi: mac80211_hwsim: send NDP for link (de)activation
      wifi: mac80211: add vif/sta link RCU dereference macros
      wifi: mac80211: set up beacon timing config on links
      wifi: mac80211: implement link switching
      wifi: mac80211_hwsim: always activate all links
      wifi: rsi: fix kernel-doc warning
      wifi: ipw2100: fix warnings about non-kernel-doc
      wifi: libertas: fix a couple of sparse warnings
      wifi: wl18xx: add some missing endian conversions
      wifi: mwifiex: mark a variable unused
      wifi: mwifiex: fix endian conversion
      wifi: mwifiex: fix endian annotations in casts
      wifi: cw1200: remove RCU STA pointer handling in TX
      wifi: cw1200: use get_unaligned_le64()
      wifi: b43: remove empty switch statement
      wifi: iwlwifi: mvm: fix typo in struct iwl_rx_no_data API
      wifi: iwlwifi: mvm: rxmq: refactor mac80211 rx_status setting
      wifi: iwlwifi: mvm: rxmq: further unify some VHT/HE code
      wifi: iwlwifi: mvm: refactor iwl_mvm_set_sta_rate() a bit
      wifi: iwlwifi: cfg: remove IWL_DEVICE_BZ_COMMON macro
      wifi: ipw2x00: fix array of flexible structures warnings
      wifi: rndis_wlan: fix array of flexible structures warning
      wifi: mwifiex: fix array of flexible structures warnings

John Whittington (1):
      can: gs_usb: add RX and TX hardware timestamp support

Jon Doron (1):
      libbpf: Fix the case of running as non-root with capabilities

Juhee Kang (1):
      net: rtnetlink: use netif_oper_up instead of open code

Jules Irenge (2):
      bpf: Fix resetting logic for unreferenced kptrs
      octeon_ep: Remove useless casting value returned by vzalloc to structure

Jun Yu (1):
      wifi: ath11k: retrieve MAC address from system firmware if provided

Junichi Uekawa (1):
      vhost/vsock: Use kvmalloc/kvfree for larger packets.

KP Singh (1):
      bpf: Allow kfuncs to be used in LSM programs

Kalle Valo (4):
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge tag 'mt76-for-kvalo-2022-09-15' of https://github.com/nbd168/wireless
      Merge tag 'iwlwifi-next-for-kalle-2022-09-18' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Karol Kolacinski (1):
      ice: Add low latency Tx timestamp read

Kees Cook (7):
      netlink: Bounds-check struct nlmsgerr creation
      wifi: iwlwifi: calib: Refactor iwl_calib_result usage for clarity
      NFC: hci: Split memcpy() of struct hcp_message flexible array
      s390/qeth: Split memcpy() of struct qeth_ipacmd_addr_change flexible array
      mlxsw: core_acl_flex_actions: Split memcpy() of struct flow_action_cookie flexible array
      wifi: iwlwifi: Track scan_cmd allocation size explicitly
      net: sched: cls_u32: Avoid memcpy() false-positive warning

Kenneth Lee (1):
      can: kvaser_usb: kvaser_usb_hydra: Use kzalloc for allocating only one element

Khalid Masum (1):
      xfrm: Update ipcomp_scratches with NULL when freed

Kiran K (2):
      Bluetooth: btintel: Add support for Magnetor
      Bluetooth: btintel: Mark Intel controller to support LE_STATES quirk

Kirill Tkhai (1):
      af_unix: Show number of inflight fds for sockets in TCP_LISTEN state too

Krzysztof Kozlowski (2):
      dt-bindings: wireless: use spi-peripheral-props.yaml
      dt-bindings: net: can: nxp,sja1000: drop ref from reg-io-width

Kuan-Chung Chen (4):
      wifi: rtw89: support for setting HE GI and LTF
      wifi: rtw89: support for setting TID specific configuration
      wifi: rtw89: disable 26-tone RU HE TB PPDU transmissions
      wifi: rtw89: support for enable/disable MSDU aggregation

Kui-Feng Lee (5):
      bpf: Parameterize task iterators.
      bpf: Handle bpf_link_info for the parameterized task BPF iterators.
      bpf: Handle show_fdinfo for the parameterized task BPF iterators
      selftests/bpf: Test parameterized task BPF iterators.
      bpftool: Show parameters of BPF task iterators.

Kumar Kartikeya Dwivedi (10):
      net: netfilter: Remove ifdefs for code shared by BPF and ctnetlink
      bpf: Move bpf_loop and bpf_for_each_map_elem under CAP_BPF
      bpf: Fix reference state management for synchronous callbacks
      selftests/bpf: Add tests for reference state fixes for callbacks
      bpf: Add copy_map_value_long to copy to remote percpu memory
      bpf: Support kptrs in percpu arraymap
      bpf: Add zero_map_value to zero map value with special fields
      bpf: Add helper macro bpf_for_each_reg_in_vstate
      bpf: Gate dynptr API behind CAP_BPF
      bpf: Tweak definition of KF_TRUSTED_ARGS

Kuniyuki Iwashima (7):
      tcp: Clean up some functions.
      tcp: Don't allocate tcp_death_row outside of struct netns_ipv4.
      tcp: Set NULL to sk->sk_prot->h.hashinfo.
      tcp: Access &tcp_hashinfo via net.
      tcp: Save unnecessary inet_twsk_purge() calls.
      tcp: Introduce optional per-netns ehash.
      af_unix: Fix memory leaks of the whole sk due to OOB skb.

Kurt Kanzenbach (3):
      selftests/bpf: Add BPF-helper test for CLOCK_TAI access
      net: stmmac: Disable automatic FCS/Pad stripping
      net: dsa: hellcreek: Offload per-tc max SDU from tc-taprio

Lam Thai (1):
      bpftool: Fix a wrong type cast in btf_dumper_int

Lama Kayal (11):
      net/mlx5e: Introduce flow steering API
      net/mlx5e: Decouple fs_tt_redirect from en.h
      net/mlx5e: Decouple fs_tcp from en.h
      net/mlx5e: Drop priv argument of ptp function in en_fs
      net/mlx5e: Convert ethtool_steering member of flow_steering struct to pointer
      net/mlx5e: Directly get flow_steering struct as input when init/cleanup ethtool steering
      net/mlx5e: Separate ethtool_steering from fs.h and make private
      net/mlx5e: Introduce flow steering debug macros
      net/mlx5e: Make flow steering arfs independent of priv
      net/mlx5e: Make all ttc functions of en_fs get fs struct as argument
      net/mlx5e: Completely eliminate priv from fs.h

Larry Finger (1):
      Bluetooth: btusb: Add BT device 0cb8:c549 from RTW8852AE to tables

Lee Jones (1):
      bpf: Ensure correct locking around vulnerable function find_vpid()

Leon Romanovsky (2):
      Merge branch 'mlx5-vfio' into mlx5-next
      net/mlx5: Remove from FPGA IFC file not-needed definitions

Li Zhong (2):
      drivers/net/ethernet/e1000e: check return value of e1e_rphy()
      ethtool: tunnels: check the return value of nla_nest_start()

Linus Walleij (1):
      net/rds: Pass a pointer to virt_to_page()

Lior Nahmanson (17):
      net/macsec: Add MACsec skb_metadata_dst Tx Data path support
      net/macsec: Add MACsec skb_metadata_dst Rx Data path support
      net/macsec: Move some code for sharing with various drivers that implements offload
      net/mlx5: Removed esp_id from struct mlx5_flow_act
      net/mlx5: Generalize Flow Context for new crypto fields
      net/mlx5: Introduce MACsec Connect-X offload hardware bits and structures
      net/mlx5: Add MACsec offload Tx command support
      net/mlx5: Add MACsec Tx tables support to fs_core
      net/mlx5e: Add MACsec TX steering rules
      net/mlx5e: Implement MACsec Tx data path using MACsec skb_metadata_dst
      net/mlx5e: Add MACsec offload Rx command support
      net/mlx5: Add MACsec Rx tables support to fs_core
      net/mlx5e: Add MACsec RX steering rules
      net/mlx5e: Implement MACsec Rx data path using MACsec skb_metadata_dst
      net/mlx5e: Add MACsec offload SecY support
      net/mlx5e: Add MACsec stats support for Rx/Tx flows
      net/mlx5e: Add support to configure more than one macsec offload device

Liu Jian (6):
      net: If sock is dead don't access sock's sk_wq in sk_stream_wait_memory
      selftests/bpf: Add wait send memory test for sockmap redirect
      skmsg: Schedule psock work if the cached skb exists on the psock
      xfrm: Reinject transport-mode packets through workqueue
      net: Add helper function to parse netlink msg of ip_tunnel_encap
      net: Add helper function to parse netlink msg of ip_tunnel_parm

Liu Shixin (2):
      net: sysctl: remove unused variable long_max
      net: ethernet: mtk_eth_soc: use DEFINE_SHOW_ATTRIBUTE to simplify code

Liu, Changcheng (5):
      net/mlx5: add IFC bits for bypassing port select flow table
      RDMA/mlx5: Don't set tx affinity when lag is in hash mode
      net/mlx5: Lag, set active ports if support bypass port select flow table
      net/mlx5: Lag, enable hash mode by default for all NICs
      net/mlx5: detect and enable bypass port select flow table

Lo(Double)Hsiang Lo (1):
      brcmfmac: increase dcmd maximum buffer size

Lorenz Bauer (1):
      bpf: btf: fix truncated last_member_type_id in btf_struct_resolve

Lorenzo Bianconi (27):
      net: ethernet: mtk_eth_soc: remove unused txd_pdma pointer in mtk_xdp_submit_frame
      igc: add xdp frags support to ndo_xdp_xmit
      net: ethernet: mtk_eth_soc: remove mtk_foe_entry_timestamp
      selftests/bpf: fix ct status check in bpf_nf selftests
      wifi: mt76: connac: introduce mt76_connac_reg_map structure
      wifi: mt76: add rx_check callback for usb devices
      wifi: mt76: mt7921: move mt7921_rx_check and mt7921_queue_rx_skb in mac.c
      wifi: mt76: sdio: add rx_check callback for sdio devices
      wifi: mt76: mt7615: add mt7615_mutex_acquire/release in mt7615_sta_set_decap_offload
      wifi: mt76: mt7915: fix possible unaligned access in mt7915_mac_add_twt_setup
      wifi: mt76: connac: fix possible unaligned access in mt76_connac_mcu_add_nested_tlv
      wifi: mt76: mt7663s: add rx_check callback
      wifi: mt76: fix uninitialized pointer in mt7921_mac_fill_rx
      net: netfilter: add bpf_ct_set_nat_info kfunc helper
      selftests/bpf: add tests for bpf_ct_set_nat_info kfunc
      arm64: dts: mediatek: mt7986: add support for Wireless Ethernet Dispatch
      dt-bindings: net: mediatek: add WED binding for MT7986 eth driver
      net: ethernet: mtk_eth_soc: move gdma_to_ppe and ppe_base definitions in mtk register map
      net: ethernet: mtk_eth_soc: move ppe table hash offset to mtk_soc_data structure
      net: ethernet: mtk_eth_soc: add the capability to run multiple ppe
      net: ethernet: mtk_eth_soc: move wdma_base definitions in mtk register map
      net: ethernet: mtk_eth_soc: add foe_entry_size to mtk_eth_soc
      net: ethernet: mtk_eth_wed: add mtk_wed_configure_irq and mtk_wed_dma_{enable/disable}
      net: ethernet: mtk_eth_wed: add wed support for mt7986 chipset
      net: ethernet: mtk_eth_wed: add axi bus support
      net: ethernet: mtk_eth_soc: introduce flow offloading support for mt7986
      net: netfilter: move bpf_ct_set_nat_info kfunc in nf_nat_bpf.c

Luiz Augusto von Dentz (13):
      Bluetooth: hci_sync: Fix suspend performance regression
      Bluetooth: L2CAP: Fix build errors in some archs
      Bluetooth: MGMT: Fix Get Device Flags
      Bluetooth: ISO: Fix not handling shutdown condition
      Bluetooth: hci_sync: Fix hci_read_buffer_size_sync
      Bluetooth: Fix HCIGETDEVINFO regression
      Bluetooth: RFCOMM: Fix possible deadlock on socket shutdown/release
      Bluetooth: hci_sysfs: Fix attempting to call device_add multiple times
      Bluetooth: hci_debugfs: Fix not checking conn->debugfs
      Bluetooth: hci_event: Make sure ISO events don't affect non-ISO connections
      Bluetooth: hci_core: Fix not handling link timeouts propertly
      Bluetooth: L2CAP: Fix user-after-free
      Bluetooth: hci_sync: Fix not indicating power state

Lukas Bulwahn (2):
      wifi: mac80211: clean up a needless assignment in ieee80211_sta_activate_link()
      net: make NET_(DEV|NS)_REFCNT_TRACKER depend on NET

M Chetan Kumar (2):
      net: wwan: t7xx: Enable devlink based fw flashing and coredump collection
      net: wwan: t7xx: Devlink documentation

Maciej Fijalkowski (8):
      xsk: Fix backpressure mechanism on Tx
      selftests/xsk: Add missing close() on netns fd
      selftests/xsk: Query for native XDP support
      selftests/xsk: Introduce default Rx pkt stream
      selftests/xsk: Increase chars for interface name to 16
      selftests/xsk: Add support for executing tests on physical device
      selftests/xsk: Make sure single threaded test terminates
      selftests/xsk: Add support for zero copy testing

Magnus Karlsson (1):
      selftests/xsk: Fix double free

Maher Sanalla (1):
      net/mlx5: Set default grace period based on function type

Maksym Glubokiy (3):
      net: prestera: add missing ABI compatibility check
      net: prestera: cache port state for non-phylink ports too
      net: prestera: manage matchall and flower priorities

Manikanta Pubbisetty (12):
      wifi: ath11k: Register shutdown handler for WCN6750
      wifi: ath11k: Fix incorrect QMI message ID mappings
      wifi: ath11k: Add cold boot calibration support on WCN6750
      wifi: ath11k: Add TWT debugfs support for STA interface
      wifi: ath11k: Fix hardware restart failure due to twt debugfs failure
      wifi: ath11k: Add support to connect to non-transmit MBSSID profiles
      ath11k: Enable remain-on-channel support on WCN6750
      wifi: ath11k: Enable threaded NAPI
      wifi: ath11k: Add multi TX ring support for WCN6750
      wifi: ath11k: Increase TCL data ring size for WCN6750
      dt: bindings: net: add bindings to add WoW support on WCN6750
      wifi: ath11k: Add WoW support for WCN6750

Manu Bretelle (1):
      bpftool: Remove BPF_OBJ_NAME_LEN restriction when looking up bpf program by name

Marc Kleine-Budde (14):
      can: rx-offload: can_rx_offload_init_queue(): fix typo
      can: flexcan: fix typo: FLEXCAN_QUIRK_SUPPPORT_* -> FLEXCAN_QUIRK_SUPPORT_*
      can: gs_usb: use common spelling of GS_USB in macros
      Merge patch series "can: gs_usb: hardware timestamp support"
      Merge patch series "can: raw: random optimizations"
      Merge patch series "can: support CAN XL"
      Merge patch series "can: bcm: can: bcm: random optimizations"
      can: gs_usb: gs_usb_get_timestamp(): fix endpoint parameter for usb_control_msg_recv()
      can: gs_usb: add missing lock to protect struct timecounter::cycle_last
      can: gs_usb: gs_can_open(): initialize time counter before starting device
      can: gs_usb: gs_cmd_reset(): rename variable holding struct gs_can pointer to dev
      can: gs_usb: convert from usb_control_msg() to usb_control_msg_{send,recv}()
      can: gs_usb: gs_make_candev(): clean up error handling
      can: gs_usb: add switchable termination support

Marcin Szycik (2):
      ice: Add support for ip TTL & ToS offload
      ice: Add L2TPv3 hardware offload support

Marcus Carlberg (2):
      net: dsa: mv88e6xxx: support RGMII cmode
      net: dsa: mv88e6xxx: Allow external SMI if serial

Marek Behún (7):
      net: phylink: pass supported host PHY interface modes to phylib for SFP's PHYs
      net: phy: marvell10g: Use tabs instead of spaces for indentation
      net: phylink: allow attaching phy for SFP modules on 802.3z mode
      net: sfp: Add and use macros for SFP quirks definitions
      net: sfp: create/destroy I2C mdiobus before PHY probe/after PHY release
      net: phy: mdio-i2c: support I2C MDIO protocol for RollBall SFP modules
      net: sfp: add support for multigig RollBall transceivers

Marek Lindner (1):
      batman-adv: remove unused struct definitions

Marek Vasut (2):
      wifi: brcmfmac: add 43439 SDIO ids and initialization
      dt-bindings: net: snps,dwmac: Document stmmac-axi-config subnode

Martin KaFai Lau (47):
      net: Add sk_setsockopt() to take the sk ptr instead of the sock ptr
      bpf: net: Avoid sk_setsockopt() taking sk lock when called from bpf
      bpf: net: Consider has_current_bpf_ctx() when testing capable() in sk_setsockopt()
      bpf: net: Change do_tcp_setsockopt() to use the sockopt's lock_sock() and capable()
      bpf: net: Change do_ip_setsockopt() to use the sockopt's lock_sock() and capable()
      bpf: net: Change do_ipv6_setsockopt() to use the sockopt's lock_sock() and capable()
      bpf: Initialize the bpf_run_ctx in bpf_iter_run_prog()
      bpf: Embed kernel CONFIG check into the if statement in bpf_setsockopt
      bpf: Change bpf_setsockopt(SOL_SOCKET) to reuse sk_setsockopt()
      bpf: Refactor bpf specific tcp optnames to a new function
      bpf: Change bpf_setsockopt(SOL_TCP) to reuse do_tcp_setsockopt()
      bpf: Change bpf_setsockopt(SOL_IP) to reuse do_ip_setsockopt()
      bpf: Change bpf_setsockopt(SOL_IPV6) to reuse do_ipv6_setsockopt()
      bpf: Add a few optnames to bpf_setsockopt
      selftests/bpf: bpf_setsockopt tests
      selftest/bpf: Add setget_sockopt to DENYLIST.s390x
      bpf, net: Avoid loading module when calling bpf_setsockopt(TCP_CONGESTION)
      selftest/bpf: Ensure no module loading in bpf_setsockopt(TCP_CONGESTION)
      Merge branch 'fixes for concurrent htab updates'
      Merge branch 'Use this_cpu_xxx for preemption-safety'
      net: Change sock_getsockopt() to take the sk ptr instead of the sock ptr
      bpf: net: Change sk_getsockopt() to take the sockptr_t argument
      bpf: net: Avoid sk_getsockopt() taking sk lock when called from bpf
      bpf: net: Change do_tcp_getsockopt() to take the sockptr_t argument
      bpf: net: Avoid do_tcp_getsockopt() taking sk lock when called from bpf
      bpf: net: Change do_ip_getsockopt() to take the sockptr_t argument
      bpf: net: Avoid do_ip_getsockopt() taking sk lock when called from bpf
      net: Remove unused flags argument from do_ipv6_getsockopt
      net: Add a len argument to compat_ipv6_get_msfilter()
      bpf: net: Change do_ipv6_getsockopt() to take the sockptr_t argument
      bpf: net: Avoid do_ipv6_getsockopt() taking sk lock when called from bpf
      bpf: Embed kernel CONFIG check into the if statement in bpf_getsockopt
      bpf: Change bpf_getsockopt(SOL_SOCKET) to reuse sk_getsockopt()
      bpf: Change bpf_getsockopt(SOL_TCP) to reuse do_tcp_getsockopt()
      bpf: Change bpf_getsockopt(SOL_IP) to reuse do_ip_getsockopt()
      bpf: Change bpf_getsockopt(SOL_IPV6) to reuse do_ipv6_getsockopt()
      selftest/bpf: Add test for bpf_getsockopt()
      Merge branch 'cgroup/connect{4,6} programs for unprivileged ICMP ping'
      Merge branch 'bpf: Small nf_conn cleanups'
      Merge branch 'Fix wrong cgroup attach flags being assigned to effective progs'
      Merge branch 'Fix resource leaks in test_maps'
      net: Fix incorrect address comparison when searching for a bind2 bucket
      bpf: Add __bpf_prog_{enter,exit}_struct_ops for struct_ops trampoline
      bpf: Move the "cdg" tcp-cc check to the common sol_tcp_sockopt()
      bpf: Refactor bpf_setsockopt(TCP_CONGESTION) handling into another function
      bpf: tcp: Stop bpf_setsockopt(TCP_CONGESTION) in init ops to recur itself
      selftests/bpf: Check -EBUSY for the recurred bpf_setsockopt(TCP_CONGESTION)

Martyna Szapar-Mudlaw (1):
      ice: Add support for VLAN priority filters in switchdev

Matthias May (1):
      selftests/net: test l2 tunnel TOS/TTL inheriting

Matthieu Baerts (2):
      mptcp: add mptcp_for_each_subflow_safe helper
      selftests/bonding: re-add lladdr target test

Max Chou (1):
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x13D3:0x3592

Maxim Mikityanskiy (58):
      net/mlx5: Add the log_min_mkey_entity_size capability
      net/mlx5e: Convert mlx5e_get_max_sq_wqebbs to u8
      net/mlx5e: Remove unused fields from datapath structs
      net/mlx5e: Make mlx5e_verify_rx_mpwqe_strides static
      net/mlx5e: Validate striding RQ before enabling XDP
      net/mlx5e: Let mlx5e_get_sw_max_sq_mpw_wqebbs accept mdev
      net/mlx5e: Use mlx5e_stop_room_for_max_wqe where appropriate
      net/mlx5e: Fix a typo in mlx5e_xdp_mpwqe_is_full
      net/mlx5e: Use the aligned max TX MPWQE size
      net/mlx5e: kTLS, Check ICOSQ WQE size in advance
      net/mlx5e: Simplify stride size calculation for linear RQ
      net/mlx5e: xsk: Remove dead code in validation
      net/mlx5e: xsk: Fix SKB headroom calculation in validation
      net/mlx5e: Improve the MTU change shortcut
      net/mlx5e: Make dma_info array dynamic in struct mlx5e_mpw_info
      net/mlx5e: Use runtime values of striding RQ parameters in datapath
      xsk: Expose min chunk size to drivers
      net/mlx5e: Use runtime page_shift for striding RQ
      net/mlx5e: xsk: Use XSK frame size as striding RQ page size
      net/mlx5e: Keep a separate MKey for striding RQ
      net/mlx5: Add MLX5_FLEXIBLE_INLEN to safely calculate cmd inlen
      net/mlx5e: xsk: Use KSM for unaligned XSK
      xsk: Remove unused xsk_buff_discard
      net/mlx5e: Fix calculations for ICOSQ size
      net/mlx5e: Optimize the page cache reducing its size 2x
      net/mlx5e: Rename mlx5e_dma_info to prepare for removal of DMA address
      net/mlx5e: Remove DMA address from mlx5e_alloc_unit
      net/mlx5e: Convert struct mlx5e_alloc_unit to a union
      net/mlx5e: xsk: Remove mlx5e_xsk_page_alloc_pool
      net/mlx5e: Split out channel (de)activation in rx_res
      net/mlx5e: Move repeating clear_bit in mlx5e_rx_reporter_err_rq_cqe_recover
      net/mlx5e: Clean up and fix error flows in mlx5e_alloc_rq
      net/mlx5e: xsk: Use mlx5e_trigger_napi_icosq for XSK wakeup
      net/mlx5e: xsk: Drop the check for XSK state in mlx5e_xsk_wakeup
      net/mlx5e: Introduce wqe_index_mask for legacy RQ
      net/mlx5e: Make the wqe_index_mask calculation more exact
      net/mlx5e: Use partial batches in legacy RQ
      net/mlx5e: xsk: Use partial batches in legacy RQ with XSK
      net/mlx5e: Remove the outer loop when allocating legacy RQ WQEs
      net/mlx5e: xsk: Split out WQE allocation for legacy XSK RQ
      net/mlx5e: xsk: Use xsk_buff_alloc_batch on legacy RQ
      net/mlx5e: xsk: Use xsk_buff_alloc_batch on striding RQ
      net/mlx5e: Use non-XSK page allocator in SHAMPO
      net/mlx5e: Call mlx5e_page_release_dynamic directly where possible
      net/mlx5e: Optimize RQ page deallocation
      net/mlx5e: xsk: Support XDP metadata on XSK RQs
      net/mlx5e: Introduce the mlx5e_flush_rq function
      net/mlx5e: xsk: Use queue indices starting from 0 for XSK queues
      net: wwan: iosm: Call mutex_init before locking it
      net/mlx5e: xsk: Flush RQ on XSK activation to save memory
      net/mlx5e: xsk: Set napi_id to support busy polling
      net/mlx5e: xsk: Include XSK skb_from_cqe callbacks in INDIRECT_CALL
      net/mlx5e: xsk: Improve need_wakeup logic
      net/mlx5e: xsk: Use umr_mode to calculate striding RQ parameters
      net/mlx5e: Improve MTT/KSM alignment
      net/mlx5e: xsk: Use KLM to protect frame overrun in unaligned mode
      net/mlx5e: xsk: Print a warning in slow configurations
      net/mlx5e: xsk: Optimize for unaligned mode with 3072-byte frames

Maxime Chevallier (11):
      net: ethernet: altera: Add use of ethtool_op_get_ts_info
      net: phy: Introduce QUSGMII PHY mode
      dt-bindings: net: ethernet-controller: add QUSGMII mode
      net: phy: Add helper to derive the number of ports from a phy mode
      net: lan966x: Add QUSGMII support for lan966x
      phy: lan966x: add support for QUSGMII
      dt-bindings: net: Convert Altera TSE bindings to yaml
      net: altera: tse: cosmetic change to use reverse xmas tree ordering
      net: pcs: add new PCS driver for altera TSE PCS
      net: altera: tse: convert to phylink
      dt-bindings: net: altera: tse: add an optional pcs register range

Menglong Dong (1):
      net: skb: prevent the split of kfree_skb_reason() by gcc

Mengyuan Lou (1):
      net: ngbe: Add build support for ngbe

Michael Walle (2):
      dt-bindings: net: sparx5: don't require a reset line
      net: lan966x: make reset optional

Michael Weiß (2):
      net: openvswitch: allow metering in non-initial user namespace
      net: openvswitch: allow conntrack in non-initial user namespace

Michal Jaron (1):
      iavf: Fix race between iavf_close and iavf_reset_task

Michal Michalik (1):
      ice: Check if reset in progress while waiting for offsets

Mika Westerberg (5):
      net: thunderbolt: Enable DMA paths only after rings are enabled
      thunderbolt: Show link type for XDomain connections too
      thunderbolt: Add back Intel Falcon Ridge end-to-end flow control workaround
      net: thunderbolt: Enable full end-to-end flow control
      net: thunderbolt: Update module description with mention of USB4

Mikael Barsehyan (1):
      ice: remove non-inclusive language

Mike Pattrick (2):
      openvswitch: Fix double reporting of drops in dropwatch
      openvswitch: Fix overreporting of drops in dropwatch

Ming Yen Hsieh (1):
      wifi: mt76: mt7921: introduce Country Location Control support

Minghao Chi (1):
      xen-netback: use kstrdup instead of open-coding it

Mordechay Goodstein (1):
      wifi: mac80211: mlme: don't add empty EML capabilities

Moshe Shemesh (1):
      net/mlx5: Start health poll at earlier stage of driver load

Naftali Goldstein (1):
      wifi: iwlwifi: mvm: d3: parse keys from wowlan info notification

Nathan Chancellor (2):
      net/mlx5e: Do not use err uninitialized in mlx5e_rep_add_meta_tunnel_rule()
      net/mlx5e: Ensure macsec_rule is always initiailized in macsec_fs_{r,t}x_add_rule()

Nathan Huckleberry (10):
      net: ax88796c: Fix return type of ax88796c_start_xmit
      net: davicom: Fix return type of dm9000_start_xmit
      net: ethernet: ti: davinci_emac: Fix return type of emac_dev_xmit
      net: ethernet: litex: Fix return type of liteeth_start_xmit
      net: korina: Fix return type of korina_send_packet
      net: wwan: iosm: Fix return type of ipc_wwan_link_transmit
      net: wwan: t7xx: Fix return type of t7xx_ccmni_start_xmit
      openvswitch: Change the return type for vport_ops.send function hook to int
      net: sparx5: Fix return type of sparx5_port_xmit_impl
      net: lan966x: Fix return type of lan966x_port_xmit

Naveen Mamindlapalli (3):
      octeontx2-af: return correct ptp timestamp for CN10K silicon
      octeontx2-af: Add PTP PPS Errata workaround on CN10K silicon
      octeontx2-af: Initialize PTP_SEC_ROLLOVER register properly

Neal Cardwell (1):
      tcp: fix tcp_cwnd_validate() to not forget is_cwnd_limited

Nick Child (3):
      ibmveth: Copy tx skbs into a premapped buffer
      ibmveth: Implement multi queue on xmit
      ibmveth: Ethtool set queue support

Nicolas Dichtel (1):
      rtnetlink: advertise allmulti counter

Oleksandr Mazur (1):
      net: marvell: prestera: implement br_port_locked flag offloading

Oleksij Rempel (26):
      net: asix: ax88772: migrate to phylink
      net: asix: ax88772: add ethtool pause configuration
      net: dsa: microchip: add separate struct ksz_chip_data for KSZ8563 chip
      net: dsa: microchip: do per-port Gbit detection instead of per-chip
      net: dsa: microchip: don't announce extended register support on non Gbit chips
      net: dsa: microchip: allow to pass return values for PHY read/write accesses
      net: dsa: microchip: forward error value on all ksz_pread/ksz_pwrite functions
      net: dsa: microchip: ksz9477: add error handling to ksz9477_r/w_phy
      net: dsa: microchip: ksz8795: add error handling to ksz8_r/w_phy
      net: dsa: microchip: KSZ9893: do not write to not supported Output Clock Control Register
      net: dsa: microchip: add support for regmap_access_tables
      net: dsa: microchip: add regmap_range for KSZ8563 chip
      net: dsa: microchip: ksz9477: remove MII_CTRL1000 check from ksz9477_w_phy()
      net: dsa: microchip: add regmap_range for KSZ9477 chip
      net: dsa: microchip: ksz9477: use internal_phy instead of phy_port_cnt
      net: dsa: microchip: remove unused port phy variable
      net: dsa: microchip: ksz9477: remove unused "on" variable
      net: dsa: microchip: remove unused sgmii variable
      net: dsa: microchip: remove IS_9893 flag
      dt-bindings: net: phy: add PoDL PSE property
      net: add framework to support Ethernet PSE and PDs devices
      net: mdiobus: fwnode_mdiobus_register_phy() rework error handling
      net: mdiobus: search for PSE nodes by parsing PHY nodes.
      ethtool: add interface to interact with Ethernet Power Equipment
      dt-bindings: net: pse-dt: add bindings for regulator based PoDL PSE controller
      net: pse-pd: add regulator based PSE driver

Oliver Hartkopp (7):
      can: skb: unify skb CAN frame identification helpers
      can: skb: add skb CAN frame data length helpers
      can: set CANFD_FDF flag in all CAN FD frame structures
      can: canxl: introduce CAN XL data structure
      can: canxl: update CAN infrastructure for CAN XL frames
      can: dev: add CAN XL support to virtual CAN
      can: raw: add CAN XL support

Paolo Abeni (21):
      Merge branch 'vsock-updates-for-so_rcvlowat-handling'
      Merge branch 'dsa-changes-for-multiple-cpu-ports-part-3'
      Merge branch 'nfp-port-speed-and-eeprom-get-set-updates'
      Merge branch 'netlink-support-reporting-missing-attributes'
      Merge branch 'rk3588-ethernet-support'
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'mptcp-allow-privileged-operations-from-user-ns-cleanup'
      Merge branch 'net-ftgmac100-support-fixed-link'
      Merge branch 'ice-l2tpv3-offload-support'
      Merge branch 'dsa-changes-for-multiple-cpu-ports-part-4'
      Merge branch 'seg6-add-next-c-sid-support-for-srv6-end-behavior'
      Merge branch 'net-ethernet-adi-add-adin1110-support'
      Merge branch 'separate-smc-parameter-settings-from-tcp-sysctls'
      Merge branch 'add-wed-support-for-mt7986-chipset'
      Merge branch 'net-openvswitch-metering-and-conntrack-in-userns'
      net: skb: introduce and use a single page frag cache
      mptcp: propagate fastclose error
      mptcp: use fastclose on more edge scenarios
      selftests: mptcp: update and extend fastclose test-cases
      mptcp: update misleading comments.

Paul Greenwalt (1):
      ice: add helper function to check FW API version

Pavel Begunkov (6):
      net: unify alloclen calculation for paged requests
      selftests/net: enable io_uring sendzc testing
      net: introduce struct ubuf_info_msgzc
      xen/netback: use struct ubuf_info_msgzc
      vhost/net: use struct ubuf_info_msgzc
      net: shrink struct ubuf_info

Peilin Ye (3):
      bpf/btf: Use btf_type_str() whenever possible
      udp: Refactor udp_read_skb()
      af_unix: Refactor unix_read_skb()

Peter Zijlstra (Intel) (1):
      ftrace: Add HAVE_DYNAMIC_FTRACE_NO_PATCHABLE

Phil Sutter (2):
      net: rtnetlink: Enslave device before bringing it up
      netfilter: nft_fib: Fix for rpath check with VRF devices

Pieter Jansen van Vuuren (1):
      sfc: introduce shutdown entry point in efx pci driver

Ping-Ke Shih (37):
      wifi: rtw88: access chip_info by const pointer
      wifi: rtlwifi: 8192de: correct checking of IQK reload
      wifi: rtw88: fix uninitialized use of primary channel index
      rtw89: declare support HE HTC always
      wifi: rtw89: 8852c: update RF radio A/B parameters to R49
      wifi: rtw89: 8852c: declare correct BA CAM number
      wifi: rtw89: 8852c: initialize and correct BA CAM content
      wifi: rtw89: correct BA CAM allocation
      wifi: rtw89: pci: fix interrupt stuck after leaving low power mode
      wifi: rtw89: pci: correct TX resource checking in low power mode
      wifi: rtw89: no HTC field if TX rate might fallback to legacy
      wifi: rtw89: correct polling address of address CAM
      wifi: rtw89: declare to support beamformee above bandwidth 80MHz
      wifi: rtw89: use u32_get_bits to access C2H content of PHY capability
      wifi: rtw89: parse phycap of TX/RX antenna number
      wifi: rtw89: configure TX path via H2C command
      wifi: rtw89: record signal strength per RF path
      wifi: rtw89: support TX diversity for 1T2R chipset
      wifi: rtw89: 8852c: enable the interference cancellation of MU-MIMO on 6GHz
      wifi: rtw89: 8852c: enlarge polling timeout of RX DCK
      wifi: rtw89: coex: use void pointer as temporal type to copy report
      wifi: rtw89: coex: show connecting state in debug message
      wifi: rtw89: unify use of rtw89_h2c_tx()
      wifi: rtw89: initialize DMA of CMAC
      wifi: rtw89: mac: set NAV upper to 25ms
      wifi: rtw89: pci: update LTR settings
      wifi: rtw89: reset halt registers before turn on wifi CPU
      wifi: rtw89: set wifi_role of P2P
      wifi: rtw89: pci: mask out unsupported TX channels
      wifi: rtw89: mac: define DMA channel mask to avoid unsupported channels
      wifi: rtw89: add DMA busy checking bits to chip info
      wifi: rtw89: 8852b: implement chip_ops::{enable,disable}_bb_rf
      wifi: rtw89: pci: add to do PCI auto calibration
      wifi: rtw89: pci: set power cut closed for 8852be
      wifi: rtw89: mac: correct register of report IMR
      wifi: rtw89: check DLE FIFO size with reserved size
      wifi: rtw89: 8852b: configure DLE mem

Po Hao Huang (1):
      wifi: rtw89: support P2P

Po-Hao Huang (7):
      wifi: rtw88: 8822c: extend supported probe request size
      rtw89: 8852c: disable dma during mac init
      wifi: rtw89: 8852c: support hw_scan
      wifi: rtw89: split scan including lots of channels
      wifi: rtw89: free unused skb to prevent memory leak
      wifi: rtw89: fix rx filter after scan
      wifi: rtw89: 8852c: add multi-port ID to TX descriptor

Pu Lehui (3):
      bpf, cgroup: Reject prog_attach_flags array when effective query
      bpftool: Fix wrong cgroup attach flags being assigned to effective progs
      selftests/bpf: Adapt cgroup effective query uapi change

Punit Agrawal (1):
      bpf: Simplify code by using for_each_cpu_wrap()

Qingfang DENG (1):
      net: phylink: allow RGMII/RTBI in-band status

Qingqing Yang (1):
      flow_dissector: Do not count vlan tags inside tunnel payload

Quentin Monnet (6):
      bpftool: Fix a typo in a comment
      bpf: Clear up confusion in bpf_skb_adjust_room()'s documentation
      bpftool: Clear errno after libcap's checks
      scripts/bpf: Set version attribute for bpf-helpers(7) man page
      scripts/bpf: Set date attribute for bpf-helpers(7) man page
      bpf: Fix a few typos in BPF helpers documentation

Radhey Shyam Pandey (1):
      net: macb: Add zynqmp SGMII dynamic configuration support

Rafał Miłecki (1):
      net: broadcom: bcm4908_enet: handle -EPROBE_DEFER when getting MAC

Raju Lakkaraju (3):
      net: lan743x: Fix to use multiqueue start/stop APIs
      net: lan743x: Add support for Rx IP & TCP checksum offload
      eth: lan743x: reject extts for non-pci11x1x devices

Ramesh Rangavittal (1):
      brcmfmac: Remove the call to "dtim_assoc" IOVAR

Randy Dunlap (1):
      net: ethernet: ti: davinci_mdio: fix build for mdio bitbang uses

Ravi Gunasekaran (1):
      net: ethernet: ti: davinci_mdio: Add workaround for errata i2329

Ren Zhijie (1):
      octeontx2-pf: Fix unused variable build error

Richard Gobert (4):
      net: gro: skb_gro_header helper function
      net-next: Fix IP_UNICAST_IF option behavior for connected sockets
      net-next: gro: Fix use of skb_gro_header_slow
      net-next: skbuff: refactor pskb_pull

Rob Herring (1):
      dt-bindings: net: Add missing (unevaluated|additional)Properties on child nodes

Robert Hancock (1):
      net: axienet: Switch to 64-bit RX/TX statistics

Roberto Sassu (12):
      btf: Export bpf_dynptr definition
      bpf: Move dynptr type check to is_dynptr_type_expected()
      btf: Allow dynamic pointer parameters in kfuncs
      bpf: Export bpf_dynptr_get_size()
      KEYS: Move KEY_LOOKUP_ to include/linux/key.h and define KEY_LOOKUP_ALL
      bpf: Add bpf_lookup_*_key() and bpf_key_put() kfuncs
      bpf: Add bpf_verify_pkcs7_signature() kfunc
      selftests/bpf: Compile kernel with everything as built-in
      selftests/bpf: Add verifier tests for bpf_lookup_*_key() and bpf_key_put()
      selftests/bpf: Add additional tests for bpf_lookup_*_key()
      selftests/bpf: Add test for bpf_verify_pkcs7_signature() kfunc
      selftests/bpf: Add tests for dynamic pointers parameters in kfuncs

Roi Dayan (4):
      net/mlx5: E-Switch, Split creating fdb tables into smaller chunks
      net/mlx5: E-Switch, Move send to vport meta rule creation
      net/mlx5: TC, Add support for SF tunnel offload
      net/mlx5: E-Switch, Allow offloading fwd dest flow table with vport

Rolf Eike Beer (3):
      sunhme: remove unused tx_dump_ring()
      sunhme: forward the error code from pci_enable_device()
      sunhme: switch to devres

Romain Naour (4):
      net: dsa: microchip: add KSZ9896 switch support
      net: dsa: microchip: add KSZ9896 to KSZ9477 I2C driver
      net: dsa: microchip: ksz9477: remove 0x033C and 0x033D addresses from regmap_access_tables
      net: dsa: microchip: add regmap_range for KSZ9896 chip

Ronak Jain (1):
      firmware: xilinx: add support for sd/gem config

Rong Tao (1):
      samples/bpf: Replace blk_account_io_done() with __blk_account_io_done()

Ruffalo Lavoisier (3):
      wifi: brcmsmac: remove duplicate words
      wifi: mt76: connac: fix in comment
      liquidio: CN23XX: delete repeated words, add missing words and fix typo in comment

Russell King (3):
      net: sfp: augment SFP parsing with phy_interface_t bitmap
      net: phylink: use phy_interface_t bitmaps for optical modules
      net: phy: marvell10g: select host interface configuration

Russell King (Oracle) (8):
      net: sfp: re-implement soft state polling setup
      net: sfp: move quirk handling into sfp.c
      net: sfp: move Alcatel Lucent 3FE46541AA fixup
      net: sfp: move Huawei MA5671A fixup
      net: sfp: add support for HALNy GPON SFP
      net: phylink: add ability to validate a set of interface modes
      net: phylink: rename phylink_sfp_config()
      net: mvpp2: fix mvpp2 debugfs leak

Ryder Lee (3):
      wifi: mac80211: read ethtool's sta_stats from sinfo
      wifi: mt76: move move mt76_sta_stats to mt76_wcid
      wifi: mt76: add PPDU based TxS support for WED device

Ryohei Kondo (1):
      brcmfmac: increase default max WOWL patterns to 16

Sabrina Dubroca (21):
      esp: choose the correct inner protocol for GSO on inter address family tunnels
      xfrm: propagate extack to all netlink doit handlers
      xfrm: add extack support to verify_newpolicy_info
      xfrm: add extack to verify_policy_dir
      xfrm: add extack to verify_policy_type
      xfrm: add extack to validate_tmpl
      xfrm: add extack to verify_sec_ctx_len
      xfrm: add extack support to verify_newsa_info
      xfrm: add extack to verify_replay
      xfrm: add extack to verify_one_alg, verify_auth_trunc, verify_aead
      xfrm: add extack support to xfrm_dev_state_add
      xfrm: add extack to attach_*
      xfrm: add extack to __xfrm_init_state
      xfrm: add extack support to xfrm_init_replay
      macsec: don't free NULL metadata_dst
      xfrm: pass extack down to xfrm_type ->init_state
      xfrm: ah: add extack to ah_init_state, ah6_init_state
      xfrm: esp: add extack to esp_init_state, esp6_init_state
      xfrm: tunnel: add extack to ipip_init_state, xfrm6_tunnel_init_state
      xfrm: ipcomp: add extack to ipcomp{4,6}_init_state
      xfrm: mip6: add extack to mip6_destopt_init_state, mip6_rthdr_init_state

Sasha Neftin (1):
      igc: Remove IGC_MDIC_INT_EN definition

Sean Anderson (45):
      dt-bindings: net: Convert FMan MAC bindings to yaml
      net: fman: Convert to SPDX identifiers
      net: fman: Don't pass comm_mode to enable/disable
      net: fman: Store en/disable in mac_device instead of mac_priv_s
      net: fman: dtsec: Always gracefully stop/start
      net: fman: Get PCS node in per-mac init
      net: fman: Store initialization function in match data
      net: fman: Move struct dev to mac_device
      net: fman: Configure fixed link in memac_initialization
      net: fman: Export/rename some common functions
      net: fman: memac: Use params instead of priv for max_speed
      net: fman: Move initialization to mac-specific files
      net: fman: Mark mac methods static
      net: fman: Inline several functions into initialization
      net: fman: Remove internal_phy_node from params
      net: fman: Map the base address once
      net: fman: Pass params directly to mac init
      net: fman: Use mac_dev for some params
      net: fman: Specify type of mac_dev for exception_cb
      net: fman: Clean up error handling
      net: fman: Change return type of disable to void
      net: dpaa: Use mac_dev variable in dpaa_netdev_init
      soc: fsl: qbman: Add helper for sanity checking cgr ops
      soc: fsl: qbman: Add CGR update function
      net: dpaa: Adjust queue depth on rate change
      net: phy: Add 1000BASE-KX interface mode
      net: phylink: Document MAC_(A)SYM_PAUSE
      net: phylink: Export phylink_caps_to_linkmodes
      net: phylink: Generate caps and convert to linkmodes separately
      net: phy: Add support for rate matching
      net: phylink: Adjust link settings based on rate matching
      net: phylink: Adjust advertisement based on rate matching
      net: phy: aquantia: Add some additional phy interfaces
      net: phy: aquantia: Add support for rate matching
      sunhme: Remove version
      sunhme: Return an ERR_PTR from quattro_pci_find
      sunhme: Regularize probe errors
      sunhme: Convert FOO((...)) to FOO(...)
      sunhme: Clean up debug infrastructure
      sunhme: Convert printk(KERN_FOO ...) to pr_foo(...)
      sunhme: Use (net)dev_foo wherever possible
      sunhme: Combine continued messages
      sunhme: Use vdbg for spam-y prints
      sunhme: Add myself as a maintainer
      net: sunhme: Fix undersized zeroing of quattro->happy_meals

Sean Wang (13):
      Bluetooth: btusb: mediatek: fix WMT failure during runtime suspend
      Bluetooth: btusb: Add a new PID/VID 13d3/3583 for MT7921
      wifi: mt76: mt7921e: fix race issue between reset and suspend/resume
      wifi: mt76: mt7921s: fix race issue between reset and suspend/resume
      wifi: mt76: mt7921u: fix race issue between reset and suspend/resume
      wifi: mt76: mt7921u: remove unnecessary MT76_STATE_SUSPEND
      wifi: mt76: sdio: fix the deadlock caused by sdio->stat_work
      wifi: mt76: sdio: poll sta stat when device transmits data
      wifi: mt76: mt7921: add mt7921_mutex_acquire at mt7921_[start, stop]_ap
      wifi: mt76: mt7921: add mt7921_mutex_acquire at mt7921_sta_set_decap_offload
      wifi: mt76: mt7921: fix the firmware version report
      wifi: mt76: mt7921: get rid of the false positive reset
      wifi: mt76: mt7921: reset msta->airtime_ac while clearing up hw value

Sebastian Reichel (1):
      dt-bindings: net: rockchip-dwmac: add rk3588 gmac compatible

Sebin Sebastian (1):
      wifi: qtnfmac: remove braces around single statement blocks

Sergei Antonov (4):
      net: ftmac100: set max_mtu to allow DSA overhead setting
      net: ftmac100: add an opportunity to get ethaddr from the platform
      net: ftmac100: fix endianness-related issues from 'sparse'
      net: moxa: fix endianness-related issues from 'sparse'

Serhiy Boiko (2):
      net: prestera: acl: extract matchall logic into a separate file
      net: prestera: add support for egress traffic mirroring

Shang XiaoJing (6):
      can: ctucanfd: Remove redundant dev_err call
      net: wwan: iosm: Use skb_put_data() instead of skb_put/memcpy pair
      ethernet: s2io: Use skb_put_data() instead of skb_put/memcpy pair
      net: ax88796c: Use skb_put_data() instead of skb_put/memcpy pair
      wwan_hwsim: Use skb_put_data() instead of skb_put/memcpy pair
      nfp: Use skb_put_data() instead of skb_put/memcpy pair

Shaomin Deng (1):
      bcma: Fix typo in comments

Shaul Triebitz (5):
      wifi: mac80211: properly set old_links when removing a link
      wifi: cfg80211: get correct AP link chandef
      wifi: mac80211: set link BSSID
      wifi: cfg80211: add link id to txq params
      wifi: mac80211: use link in TXQ parameter configuration

Shayne Chen (1):
      wifi: mt76: testmode: use random payload for tx packets

Shenwei Wang (1):
      net: fec: using page pool to manage RX buffers

Shibin Koikkara Reeny (1):
      selftests/xsk: Update poll test cases

Shmulik Ladkani (6):
      flow_dissector: Make 'bpf_flow_dissect' return the bpf program retcode
      bpf, flow_dissector: Introduce BPF_FLOW_DISSECTOR_CONTINUE retcode for bpf progs
      bpf, test_run: Propagate bpf_flow_dissect's retval to user's bpf_attr.test.retval
      bpf, selftests: Test BPF_FLOW_DISSECTOR_CONTINUE
      bpf: Support getting tunnel flags
      selftests/bpf: Amend test_tunnel to exercise BPF_F_TUNINFO_FLAGS

Shung-Hsi Yu (2):
      MAINTAINERS: Add include/linux/tnum.h to BPF CORE
      bpf, tnums: Warn against the usage of tnum_in(tnum_range(), ...)

Siddharth Vadapalli (3):
      dt-bindings: net: ti: k3-am654-cpsw-nuss: Update bindings for J7200 CPSW5G
      net: ethernet: ti: am65-cpsw: Add support for J7200 CPSW5G
      net: ethernet: ti: am65-cpsw: Move phy_set_mode_ext() to correct location

Simon Wunderlich (1):
      batman-adv: Start new development cycle

Song Liu (2):
      bpf: use bpf_prog_pack for bpf_dispatcher
      bpf: Enforce W^X for bpf trampoline

Stanislav Fomichev (5):
      bpf: Introduce cgroup_{common,current}_func_proto
      bpf: Use cgroup_{common,current}_func_proto in more hooks
      bpf: expose bpf_strtol and bpf_strtoul to all program types
      bpf: update bpf_{g,s}et_retval documentation
      selftests/bpf: Make sure bpf_{g,s}et_retval is exposed everywhere

Stanislaw Grzeszczak (1):
      i40e: Add basic support for I710 devices

Stefan Wahren (2):
      dt-bindings: vertexcom-mse102x: Update email address
      net: vertexcom: mse102x: Update email address

Steffen Klassert (3):
      Merge remote-tracking branch 'xfrm: start adding netlink extack support'
      Merge branch 'xfrm: add netlink extack for state creation'
      Merge branch 'xfrm: add netlink extack to all the ->init_stat'

Stephen Hemminger (1):
      Remove DECnet support from kernel

Steven Hsieh (1):
      net: bridge: assign path_cost for 2.5G and 5G link speed

Subbaraya Sundeep (1):
      octeontx2-pf: mcs: Introduce MACSEC hardware offloading

Suman Ghosh (1):
      octeontx2-pf: Add egress PFC support

Sun Ke (3):
      wifi: mac80211: fix potential deadlock in ieee80211_key_link()
      net: dsa: microchip: lan937x: fix reference count leak in lan937x_mdio_register()
      net: ethernet: altera: TSE: fix error return code in altera_tse_probe()

Sven Eckelmann (2):
      batman-adv: Drop unused headers in trace.h
      batman-adv: Drop initialization of flexible ethtool_link_ksettings

Sven van Ashbrook (1):
      r8152: allow userland to disable multicast

Sylwester Dziedziuch (1):
      ice: Remove ucast_shared

Szabolcs Sipos (2):
      Bluetooth: btusb: RTL8761BUV consistent naming
      Bluetooth: btusb: Add RTL8761BUV device (Edimax BT-8500)

Taehee Yoo (1):
      net: tls: Add ARIA-GCM algorithm

Tamizh Chelvam Raja (1):
      wifi: ath11k: Add spectral scan support for 160 MHz

Tao Chen (1):
      libbpf: Support raw BTF placed in the default search path

Tao Ren (2):
      net: ftgmac100: support fixed link
      ARM: dts: aspeed: elbert: Enable mac3 controller

Tariq Toukan (1):
      net/tls: Describe ciphers sizes by const structs

Tetsuo Handa (9):
      Bluetooth: hci_sync: fix double mgmt_pending_free() in remove_adv_monitor()
      wifi: ath9k: avoid uninit memory read in ath9k_htc_rx_msg()
      bpf: add missing percpu_counter_destroy() in htab_map_alloc()
      Bluetooth: avoid hci_dev_test_and_set_flag() in mgmt_init_hdev()
      Bluetooth: L2CAP: initialize delayed works at l2cap_chan_create()
      Bluetooth: use hdev->workqueue when queuing hdev->{cmd,ncmd}_timer works
      Bluetooth: hci_{ldisc,serdev}: check percpu_init_rwsem() failure
      net: rds: don't hold sock lock when cancelling work from rds_tcp_reset_callbacks()
      net/ieee802154: reject zero-sized raw_sendmsg()

Thomas Haller (2):
      mptcp: allow privileged operations from user namespaces
      mptcp: account memory allocation in mptcp_nl_cmd_add_addr() to user

Tianyi Liu (1):
      bpftool: Fix error message of strerror

Tiezhu Yang (1):
      bpf, mips: No need to use min() to get MAX_TAIL_CALL_CNT

Tomislav Požega (6):
      wifi: rt2x00: define RF5592 in init_eeprom routine
      wifi: rt2x00: add RF self TXDC calibration for MT7620
      wifi: rt2x00: add r calibration for MT7620
      wifi: rt2x00: add RXDCOC calibration for MT7620
      wifi: rt2x00: add RXIQ calibration for MT7620
      wifi: rt2x00: add TX LOFT calibration for MT7620

Tony Lu (2):
      net/smc: Unbind r/w buffer size from clcsock and make them tunable
      net/smc: Support SO_REUSEPORT

Tony Nguyen (1):
      ice: Allow operation with reduced device MSI-X

Uros Bizjak (1):
      netdev: Use try_cmpxchg in napi_if_scheduled_mark_missed

Uwe Kleine-König (2):
      net: fjes: Reorder symbols to get rid of a few forward declarations
      ethernet: tundra: Drop forward declaration of static functions

Vadim Fedorenko (1):
      bnxt_en: replace reset with config timestamps

Vadim Pasternak (8):
      mlxsw: core_linecards: Separate line card init and fini flow
      mlxsw: core: Add registration APIs for system event handler
      mlxsw: core_linecards: Register a system event handler
      mlxsw: i2c: Add support for system interrupt handling
      mlxsw: minimal: Extend APIs with slot index for modular system support
      mlxsw: minimal: Move ports allocation to separate routine
      mlxsw: minimal: Extend module to port mapping with slot index
      mlxsw: minimal: Extend to support line card dynamic operations

Vasanth Sadhasivan (1):
      can: gs_usb: remove dma allocations

Vasanthakumar Thiagarajan (2):
      wifi: mac80211: add link information in ieee80211_rx_status
      wifi: mac80211: use the corresponding link for stats update

Veerendranath Jakkam (5):
      wifi: cfg80211: reject connect response with MLO params for WEP
      wifi: cfg80211: Prevent cfg80211_wext_siwencodeext() on MLD
      wifi: cfg80211: Add link_id parameter to various key operations for MLO
      wifi: nl80211: send MLO links channel info in GET_INTERFACE
      wifi: cfg80211: Add link_id to cfg80211_ch_switch_started_notify()

Venkateswara Naralasetty (1):
      wifi: ath11k: Add support to get power save duration for each client

Vlad Buslov (1):
      Revert "net: devlink: add RNLT lock assertion to devlink_compat_switch_id_get()"

Vladimir Oltean (79):
      dt-bindings: net: dsa: xrs700x: add missing CPU port phy-mode to example
      dt-bindings: net: dsa: hellcreek: add missing CPU port phy-mode/fixed-link to example
      dt-bindings: net: dsa: b53: add missing CPU port phy-mode to example
      dt-bindings: net: dsa: microchip: add missing CPU port phy-mode to example
      dt-bindings: net: dsa: rzn1-a5psw: add missing CPU port phy-mode to example
      dt-bindings: net: dsa: make phylink bindings required for CPU/DSA ports
      of: base: export of_device_compatible_match() for use in modules
      net: dsa: avoid dsa_port_link_{,un}register_of() calls with platform data
      net: dsa: rename dsa_port_link_{,un}register_of
      net: dsa: make phylink-related OF properties mandatory on DSA and CPU ports
      net: dsa: tag_8021q: remove old comment regarding dsa_8021q_netdev_ops
      net: dsa: walk through all changeupper notifier functions
      net: dsa: don't stop at NOTIFY_OK when calling ds->ops->port_prechangeupper
      net: bridge: move DSA master bridging restriction to DSA
      net: dsa: existing DSA masters cannot join upper interfaces
      net: dsa: only bring down user ports assigned to a given DSA master
      net: dsa: all DSA masters must be down when changing the tagging protocol
      net: dsa: use dsa_tree_for_each_cpu_port in dsa_tree_{setup,teardown}_master
      net: mscc: ocelot: set up tag_8021q CPU ports independent of user port affinity
      net: mscc: ocelot: adjust forwarding domain for CPU ports in a LAG
      selftests: net: dsa: symlink the tc_actions.sh test
      net: dsa: felix: add definitions for the stream filter counters
      net: mscc: ocelot: make access to STAT_VIEW sleepable again
      net: dsa: felix: check the 32-bit PSFP stats against overflow
      net: mscc: ocelot: report FIFO drop counters through stats->rx_dropped
      net: mscc: ocelot: sort Makefile files alphabetically
      net: mscc: ocelot: move stats code to ocelot_stats.c
      net: mscc: ocelot: unexport ocelot_port_fdb_do_dump from the common lib
      net: mscc: ocelot: move more PTP code from the lib to ocelot_ptp.c
      net: dsa: felix: use ocelot's ndo_get_stats64 method
      net: mscc: ocelot: exclude stats from bulk regions based on reg, not name
      net: mscc: ocelot: add support for all sorts of standardized counters present in DSA
      net: mscc: ocelot: harmonize names of SYS_COUNT_TX_AGING and OCELOT_STAT_TX_AGED
      net: mscc: ocelot: minimize definitions for stats
      net: mscc: ocelot: share the common stat definitions between all drivers
      net: enetc: parameterize port MAC stats to also cover the pMAC
      net: enetc: expose some standardized ethtool counters
      dt-bindings: net: dsa: mt7530: replace label = "cpu" with proper checks
      dt-bindings: net: dsa: mt7530: stop requiring phy-mode on CPU ports
      dt-bindings: net: dsa: remove label = "cpu" from examples
      net: introduce iterators over synced hw addresses
      net: dsa: introduce dsa_port_get_master()
      net: dsa: allow the DSA master to be seen and changed through rtnetlink
      net: dsa: don't keep track of admin/oper state on LAG DSA masters
      net: dsa: suppress appending ethtool stats to LAG DSA masters
      net: dsa: suppress device links to LAG DSA masters
      net: dsa: propagate extack to port_lag_join
      net: dsa: allow masters to join a LAG
      docs: net: dsa: update information about multiple CPU ports
      net: dsa: felix: add support for changing DSA master
      dt-bindings: net: dsa: convert ocelot.txt to dt-schema
      net/sched: taprio: taprio_offload_config_changed() is protected by rtnl_mutex
      net/sched: taprio: taprio_dump and taprio_change are protected by rtnl_mutex
      net/sched: taprio: use rtnl_dereference for oper and admin sched in taprio_destroy()
      net/sched: taprio: remove redundant FULL_OFFLOAD_IS_ENABLED check in taprio_enqueue
      net/sched: taprio: stop going through private ops for dequeue and peek
      net/sched: taprio: add extack messages in taprio_init
      net/sched: taprio: replace safety precautions with comments
      net/sched: taprio: remove unnecessary taprio_list_lock
      net: dsa: make user ports return to init_net on netns deletion
      net/sched: taprio: simplify list iteration in taprio_dev_notifier()
      selftests: net: tsn_lib: don't overwrite isochron receiver extra args with UDS
      selftests: net: tsn_lib: allow running ptp4l on multiple interfaces
      selftests: net: tsn_lib: allow multiple isochron receivers
      selftests: net: tsn_lib: run phc2sys in automatic mode
      net: dsa: felix: remove felix_info :: imdio_res
      net: dsa: felix: remove felix_info :: imdio_base
      net: dsa: felix: remove felix_info :: init_regmap
      net: dsa: felix: use DEFINE_RES_MEM_NAMED for resources
      net: dsa: felix: update regmap requests to be string-based
      net/sched: query offload capabilities through ndo_setup_tc()
      net/sched: taprio: allow user input of per-tc max SDU
      net: dsa: felix: offload per-tc max SDU from tc-taprio
      net: dsa: hellcreek: refactor hellcreek_port_setup_tc() to use switch/case
      net: enetc: cache accesses to &priv->si->hw
      net: enetc: use common naming scheme for PTGCR and PTGCAPR registers
      net: enetc: offload per-tc max SDU from tc-taprio
      net: dsa: don't leave dangling pointers in dp->pl when failing
      net: dsa: remove bool devlink_port_setup

Wang Yufen (17):
      bpf: use kvmemdup_bpfptr helper
      libbpf: Add pathname_concat() helper
      selftests/bpf: Convert sockmap_basic test to ASSERT_* macros
      selftests/bpf: Convert sockmap_ktls test to ASSERT_* macros
      selftests/bpf: Convert sockopt test to ASSERT_* macros
      selftests/bpf: Convert sockopt_inherit test to ASSERT_* macros
      selftests/bpf: Convert sockopt_multi test to ASSERT_* macros
      selftests/bpf: Convert sockopt_sk test to ASSERT_* macros
      selftests/bpf: Convert tcp_estats test to ASSERT_* macros
      selftests/bpf: Convert tcp_hdr_options test to ASSERT_* macros
      selftests/bpf: Convert tcp_rtt test to ASSERT_* macros
      selftests/bpf: Convert tcpbpf_user test to ASSERT_* macros
      selftests/bpf: Convert udp_limit test to ASSERT_* macros
      net: phy: Convert to use sysfs_emit() APIs
      net: tun: Convert to use sysfs_emit() APIs
      net-sysfs: Convert to use sysfs_emit() APIs
      net: bonding: Convert to use sysfs_emit()/sysfs_emit_at() APIs

Wataru Gohda (2):
      wifi: brcmfmac: Fix to add brcmf_clear_assoc_ies when rmmod
      wifi: brcmfmac: Fix to add skb free for TIM update info when tx is completed

Wei Fang (8):
      dt-bindings: net: ar803x: add disable-hibernation-mode propetry
      net: phy: at803x: add disable hibernation mode support
      dt-bindings: net: tja11xx: add nxp,refclk_in property
      net: phy: tja11xx: add interface mode and RMII REF_CLK support
      net: fec: add stop mode support for imx8 platform
      net: fec: add pm runtime force suspend and resume support
      dt-bindings: net: fec: add fsl,s32v234-fec to compatible property
      net: fec: Add initial s32v234 support

Wei Yongjun (2):
      net: ethernet: adi: Fix return value check in adin1110_probe_netdevs()
      net: vertexcom: mse102x: Silence no spi_device_id warnings

Wen Gong (4):
      wifi: ath10k: add peer map clean up for peer delete in ath10k_sta_state()
      wifi: ath11k: change complete() to complete_all() for scan.completed
      wifi: ath11k: fix failed to find the peer with peer_id 0 when disconnected
      wifi: ath10k: reset pointer after memory free to avoid potential use-after-free

Wen Gu (1):
      net/smc: Introduce a specific sysctl for TEST_LINK time

Wenjuan Geng (1):
      nfp: flower: support case of match on ct_state(0/0x3f)

William Dean (2):
      bpf: simplify code in btf_parse_hdr
      net: sched: simplify code in mall_reoffload

Wojciech Drewek (4):
      uapi: move IPPROTO_L2TP to in.h
      flow_dissector: Add L2TPv3 dissectors
      net/sched: flower: Add L2TPv3 filter
      flow_offload: Introduce flow_match_l2tpv3

Wolfram Sang (20):
      isdn: move from strlcpy with unused retval to strscpy
      vlan: move from strlcpy with unused retval to strscpy
      ax25: move from strlcpy with unused retval to strscpy
      bridge: move from strlcpy with unused retval to strscpy
      caif: move from strlcpy with unused retval to strscpy
      ipv4: move from strlcpy with unused retval to strscpy
      ipv6: move from strlcpy with unused retval to strscpy
      l2tp: move from strlcpy with unused retval to strscpy
      packet: move from strlcpy with unused retval to strscpy
      net: move from strlcpy with unused retval to strscpy
      dsa: move from strlcpy with unused retval to strscpy
      ethtool: move from strlcpy with unused retval to strscpy
      openvswitch: move from strlcpy with unused retval to strscpy
      net_sched: move from strlcpy with unused retval to strscpy
      Bluetooth: move from strlcpy with unused retval to strscpy
      wifi: mac80211: move from strlcpy with unused retval to strscpy
      net: move from strlcpy with unused retval to strscpy
      net: ethernet: move from strlcpy with unused retval to strscpy
      wifi: move from strlcpy with unused retval to strscpy
      netfilter: move from strlcpy with unused retval to strscpy

Wong Vee Khee (1):
      stmmac: intel: remove unused 'has_crossts' flag

Wright Feng (3):
      wifi: brcmfmac: fix continuous 802.1x tx pending timeout error
      wifi: brcmfmac: fix scheduling while atomic issue when deleting flowring
      wifi: brcmfmac: fix invalid address access when enabling SCAN log level

Xiaomeng Tong (1):
      cw1200: fix incorrect check to determine if no element is found in list

Xin Gao (2):
      wifi: mac80211: use full 'unsigned int' type
      core: Variable type completion

Xin Liu (3):
      libbpf: Clean up legacy bpf maps declaration in bpf_helpers
      libbpf: Fix NULL pointer exception in API btf_dump__dump_type_data
      libbpf: Fix overrun in netlink attribute iteration

Xin Long (1):
      sctp: handle the error returned from sctp_auth_asoc_init_active_key

Xiu Jianfeng (3):
      net: rds: add missing __init/__exit annotations to module init/exit funcs
      net: hns3: add __init/__exit annotations to module init/exit funcs
      net: macvtap: add __init/__exit annotations to module init/exit funcs

YN Chen (1):
      wifi: mt76: sdio: fix transmitting packet hangs

Yaara Baruch (1):
      wifi: iwlwifi: pcie: add support for BZ devices

Yafang Shao (4):
      bpf: Remove unneeded memset in queue_stack_map creation
      bpf: Use bpf_map_area_free instread of kvfree
      bpf: Make __GFP_NOWARN consistent in bpf map creation
      bpf: Use bpf_map_area_alloc consistently on bpf map creation

Yang Yingliang (39):
      amt: remove unnecessary skb pointer check
      selftests/bpf: Fix wrong size passed to bpf_setsockopt()
      wifi: rtw88: add missing destroy_workqueue() on error path in rtw_core_init()
      can: flexcan: Switch to use dev_err_probe() helper
      net/mlx5e: add missing error code in error path
      net/mlx5e: Switch to kmemdup() when allocate dev_addr
      net: mdio: mux-meson-g12a: Switch to use dev_err_probe() helper
      net: mdio: mux-mmioreg: Switch to use dev_err_probe() helper
      net: mdio: mux-multiplexer: Switch to use dev_err_probe() helper
      net: ethernet: ti: am65-cpts: Switch to use dev_err_probe() helper
      net: ethernet: ti: cpsw: Switch to use dev_err_probe() helper
      net: ethernet: ti: cpsw_new: Switch to use dev_err_probe() helper
      net: dsa: lantiq: Switch to use dev_err_probe() helper
      net: ibm: emac: Switch to use dev_err_probe() helper
      net: stmmac: dwc-qos: Switch to use dev_err_probe() helper
      net: ll_temac: Switch to use dev_err_probe() helper
      net: dsa: b53: remove unnecessary set_drvdata()
      net: dsa: bcm_sf2: remove unnecessary platform_set_drvdata()
      net: dsa: loop: remove unnecessary dev_set_drvdata()
      net: dsa: hellcreek: remove unnecessary platform_set_drvdata()
      net: dsa: lan9303: remove unnecessary dev_set_drvdata()
      net: dsa: lantiq_gswip: remove unnecessary platform_set_drvdata()
      net: dsa: microchip: remove unnecessary set_drvdata()
      net: dsa: mt7530: remove unnecessary dev_set_drvdata()
      net: dsa: mv88e6060: remove unnecessary dev_set_drvdata()
      net: dsa: mv88e6xxx: remove unnecessary dev_set_drvdata()
      net: dsa: ocelot: remove unnecessary set_drvdata()
      net: dsa: ar9331: remove unnecessary dev_set_drvdata()
      net: dsa: qca8k: remove unnecessary dev_set_drvdata()
      net: dsa: realtek: remove unnecessary set_drvdata()
      net: dsa: rzn1-a5psw: remove unnecessary platform_set_drvdata()
      net: dsa: sja1105: remove unnecessary spi_set_drvdata()
      net: dsa: vitesse-vsc73xx: remove unnecessary set_drvdata()
      net: dsa: xrs700x: remove unnecessary dev_set_drvdata()
      net: ethernet: adin1110: Add missing MODULE_DEVICE_TABLE
      net: dsa: lan9303: remove unnecessary i2c_set_clientdata()
      net: dsa: microchip: ksz9477: remove unnecessary i2c_set_clientdata()
      net: dsa: xrs700x: remove unnecessary i2c_set_clientdata()
      ethernet: 8390: remove unnecessary check of mem

Yauheni Kaliuta (4):
      bpf: Use bpf_capable() instead of CAP_SYS_ADMIN for blinding decision
      selftests: bpf: test_kmod.sh: Pass parameters to the module
      selftests/bpf: Add liburandom_read.so to TEST_GEN_FILES
      selftests/bpf: Fix passing arguments via function in test_kmod.sh

Yedidya Benshimol (1):
      wifi: iwlwifi: mvm: iterate over interfaces after an assert in d3

Yevhen Orlov (9):
      net: marvell: prestera: Add router nexthops ABI
      net: marvell: prestera: Add cleanup of allocated fib_nodes
      net: marvell: prestera: Add strict cleanup of fib arbiter
      net: marvell: prestera: add delayed wq and flush wq on deinit
      net: marvell: prestera: Add length macros for prestera_ip_addr
      net: marvell: prestera: Add heplers to interact with fib_notifier_info
      net: marvell: prestera: add stub handler neighbour events
      net: marvell: prestera: Add neighbour cache accounting
      net: marvell: prestera: Propagate nh state from hw to kernel

Yi-Tang Chiu (1):
      wifi: rtw89: 8852c: set TX to single path TX on path B in 6GHz band

YiFei Zhu (3):
      bpf: Invoke cgroup/connect{4,6} programs for unprivileged ICMP ping
      selftests/bpf: Deduplicate write_sysctl() to test_progs.c
      selftests/bpf: Ensure cgroup/connect{4,6} programs can bind unpriv ICMP ping

Yihao Han (1):
      Bluetooth: MGMT: fix zalloc-simple.cocci warnings

Yinjun Zhang (6):
      nfp: propagate port speed from management firmware
      nfp: check if application firmware is indifferent to port speed
      nfp: add support for reporting active FEC mode
      nfp: avoid halt of driver init process when non-fatal error happens
      nfp: refine the ABI of getting `sp_indiff` info
      nfp: add support for link auto negotiation

Yishai Hadas (2):
      net/mlx5: Introduce ifc bits for page tracker
      net/mlx5: Query ADV_VIRTUALIZATION capabilities

Yonghong Song (10):
      bpf: Always return corresponding btf_type in __get_type_size()
      bpf: Allow struct argument in trampoline based programs
      bpf: x86: Support in-register struct arguments in trampoline programs
      bpf: Update descriptions for helpers bpf_get_func_arg[_cnt]()
      bpf: arm64: No support of struct argument in trampoline programs
      libbpf: Add new BPF_PROG2 macro
      selftests/bpf: Add struct argument tests with fentry/fexit programs.
      selftests/bpf: Use BPF_PROG2 for some fentry programs without struct arguments
      selftests/bpf: Add tracing_struct test in DENYLIST.s390x
      libbpf: Improve BPF_PROG2 macro code quality and description

Yonglong Liu (1):
      net: hns3: add support for external loopback test

Yosry Ahmed (5):
      cgroup: enable cgroup_get_from_file() on cgroup1
      cgroup: bpf: enable bpf programs to integrate with rstat
      selftests/bpf: extend cgroup helpers
      selftests/bpf: add a selftest for cgroup hierarchical stats collection
      selftests/bpf: Simplify cgroup_hierarchical_stats selftest

Youghandhar Chintala (1):
      wifi: ath10k: Set tx credit to one for WCN3990 snoc based devices

Yuan Can (4):
      net: liquidio: Remove unused struct lio_trusted_vf_ctx
      net/tipc: Remove unused struct distr_queue_item
      bpftool: Remove unused struct btf_attach_point
      bpftool: Remove unused struct event_ring_info

Zheng Wang (1):
      eth: sp7021: fix use after free bug in spl2sw_nvmem_get_mac_address

Zheng Yongjun (1):
      net: fs_enet: Fix wrong check in do_pd_setup

Zhengchao Shao (102):
      net: sched: remove the unused return value of unregister_qdisc
      net: sched: delete unused input parameter in qdisc_create
      net: sched: remove duplicate check of user rights in qdisc
      netlink: fix some kernel-doc comments
      net: sched: delete duplicate cleanup of backlog and qlen
      net: sched: remove unnecessary init of qdisc skb head
      net: sched: using TCQ_MIN_PRIO_BANDS in prio_tune()
      net: sched: choke: remove unused variables in struct choke_sched_data
      net: sched: gred/red: remove unused variables in struct red_stats
      net: sched: remove redundant NULL check in change hook function
      net: sched: gred: remove NULL check before free table->tab in gred_destroy()
      net: sched: etf: remove true check in etf_enable_offload()
      net/sched: cls_api: remove redundant 0 check in tcf_qevent_init()
      net: sched: fq_codel: remove redundant resource cleanup in fq_codel_init()
      net: sched: htb: remove redundant resource cleanup in htb_init()
      net: sched: act: move global static variable net_id to tc_action_ops
      net: sched: act_api: implement generic walker and search for tc action
      net: sched: act_bpf: get rid of tcf_bpf_walker and tcf_bpf_search
      net: sched: act_connmark: get rid of tcf_connmark_walker and tcf_connmark_search
      net: sched: act_csum: get rid of tcf_csum_walker and tcf_csum_search
      net: sched: act_ct: get rid of tcf_ct_walker and tcf_ct_search
      net: sched: act_ctinfo: get rid of tcf_ctinfo_walker and tcf_ctinfo_search
      net: sched: act_gact: get rid of tcf_gact_walker and tcf_gact_search
      net: sched: act_gate: get rid of tcf_gate_walker and tcf_gate_search
      net: sched: act_ife: get rid of tcf_ife_walker and tcf_ife_search
      net: sched: act_ipt: get rid of tcf_ipt_walker/tcf_xt_walker and tcf_ipt_search/tcf_xt_search
      net: sched: act_mirred: get rid of tcf_mirred_walker and tcf_mirred_search
      net: sched: act_mpls: get rid of tcf_mpls_walker and tcf_mpls_search
      net: sched: act_nat: get rid of tcf_nat_walker and tcf_nat_search
      net: sched: act_pedit: get rid of tcf_pedit_walker and tcf_pedit_search
      net: sched: act_police: get rid of tcf_police_walker and tcf_police_search
      net: sched: act_sample: get rid of tcf_sample_walker and tcf_sample_search
      net: sched: act_simple: get rid of tcf_simp_walker and tcf_simp_search
      net: sched: act_skbedit: get rid of tcf_skbedit_walker and tcf_skbedit_search
      net: sched: act_skbmod: get rid of tcf_skbmod_walker and tcf_skbmod_search
      net: sched: act_tunnel_key: get rid of tunnel_key_walker and tunnel_key_search
      net: sched: act_vlan: get rid of tcf_vlan_walker and tcf_vlan_search
      selftests/tc-testings: add selftests for ctinfo action
      selftests/tc-testings: add selftests for gate action
      selftests/tc-testings: add selftests for xt action
      selftests/tc-testings: add connmark action deleting test case
      selftests/tc-testings: add ife action deleting test case
      selftests/tc-testings: add nat action deleting test case
      selftests/tc-testings: add sample action deleting test case
      selftests/tc-testings: add tunnel_key action deleting test case
      net/sched: cls_api: add helper for tc cls walker stats dump
      net/sched: use tc_cls_stats_dump() in filter
      selftests/tc-testings: add selftests for bpf filter
      selftests/tc-testings: add selftests for cgroup filter
      selftests/tc-testings: add selftests for flow filter
      selftests/tc-testings: add selftests for route filter
      selftests/tc-testings: add selftests for rsvp filter
      selftests/tc-testings: add selftests for tcindex filter
      selftests/tc-testings: add list case for basic filter
      net/sched: sch_api: add helper for tc qdisc walker stats dump
      net/sched: use tc_qdisc_stats_dump() in qdisc
      selftests/tc-testing: add selftests for cake qdisc
      selftests/tc-testing: add selftests for cbq qdisc
      selftests/tc-testing: add selftests for cbs qdisc
      selftests/tc-testing: add selftests for drr qdisc
      selftests/tc-testing: add selftests for dsmark qdisc
      selftests/tc-testing: add selftests for fq_codel qdisc
      selftests/tc-testing: add selftests for hfsc qdisc
      selftests/tc-testing: add selftests for htb qdisc
      selftests/tc-testing: add selftests for mqprio qdisc
      selftests/tc-testing: add selftests for multiq qdisc
      selftests/tc-testing: add selftests for netem qdisc
      selftests/tc-testing: add selftests for qfq qdisc
      selftests/tc-testing: add show class case for ingress qdisc
      selftests/tc-testing: add show class case for mq qdisc
      selftests/tc-testing: add show class case for prio qdisc
      selftests/tc-testing: add show class case for red qdisc
      net: hinic: modify kernel doc comments
      net: hinic: change type of function to be static
      net: hinic: remove unused functions
      net: hinic: remove unused macro
      net: hinic: remove duplicate macro definition
      net: hinic: simplify code logic
      net: hinic: change hinic_deinit_vf_hw() to void
      net: hinic: remove unused enumerated value
      net: hinic: replace magic numbers with macro
      net: hinic: remove the unused input parameter prod_idx in sq_prepare_ctrl()
      selftests/tc-testing: add selftests for atm qdisc
      selftests/tc-testing: add selftests for choke qdisc
      selftests/tc-testing: add selftests for codel qdisc
      selftests/tc-testing: add selftests for etf qdisc
      selftests/tc-testing: add selftests for fq qdisc
      selftests/tc-testing: add selftests for gred qdisc
      selftests/tc-testing: add selftests for hhf qdisc
      selftests/tc-testing: add selftests for pfifo_fast qdisc
      selftests/tc-testing: add selftests for plug qdisc
      selftests/tc-testing: add selftests for sfb qdisc
      selftests/tc-testing: add selftests for sfq qdisc
      selftests/tc-testing: add selftests for skbprio qdisc
      selftests/tc-testing: add selftests for taprio qdisc
      selftests/tc-testing: add selftests for tbf qdisc
      selftests/tc-testing: add selftests for teql qdisc
      net: sched: act_bpf: simplify code logic in tcf_bpf_init()
      selftests/tc-testing: update qdisc/cls/action features in config
      net: sched: ensure n arg not empty before call bind_class
      net: sched: cls_api: introduce tc_cls_bind_class() helper
      net: sched: use tc_cls_bind_class() in filter

Zhengping Jiang (2):
      Bluetooth: hci_sync: hold hdev->lock when cleanup hci_conn
      Bluetooth: hci_sync: allow advertise when scan without RPA

Zheyu Ma (1):
      wifi: rtl8xxxu: Simplify the error handling code

Ziyang Chen (1):
      nfp: flower: add validation of for police actions which are independent of flows

Ziyang Xuan (5):
      can: raw: process optimization in raw_init()
      can: raw: use guard clause to optimize nesting in raw_rcv()
      net/af_packet: registration process optimization in packet_init()
      can: bcm: registration process optimization in bcm_module_init()
      can: bcm: check the result of can_send() in bcm_can_tx()

Zong-Zhe Yang (23):
      wifi: rtw88: phy: fix warning of possible buffer overflow
      wifi: rtw89: refine leaving LPS function
      wifi: rtw89: rewrite decision on channel by entity state
      wifi: rtw89: introduce rtw89_chan for channel stuffs
      wifi: rtw89: re-arrange channel related stuffs under HAL
      wifi: rtw89: create rtw89_chan centrally to avoid breakage
      wifi: rtw89: txpwr: concentrate channel related control to top
      wifi: rtw89: rfk: concentrate parameter control while set_channel()
      wifi: rtw89: concentrate parameter control for setting channel callback
      wifi: rtw89: concentrate chandef setting to stack callback
      wifi: rtw89: initialize entity and configure default chandef
      wifi: rtw89: introduce entity mode and its recalculated prototype
      wifi: rtw89: add skeleton of mac80211 chanctx ops support
      wifi: rtw89: declare support for mac80211 chanctx ops by chip
      wifi: rtw89: early recognize FW feature to decide if chanctx
      rtw89: 8852a: update HW setting on BB
      rtw89: ser: leave lps with mutex
      wifi: rtw89: TX power limit/limit_ru consider negative
      wifi: rtw89: 8852c: update TX power tables to R49
      wifi: rtw89: 8852c: L1 DMA reset has offloaded to FW
      wifi: rtw89: introudce functions to drop packets
      wifi: rtw89: 8852c: support fw crash simulation
      wifi: rtw89: support SER L1 simulation

huangjunxian (6):
      net: ll_temac: fix the format of block comments
      net: ll_temac: axienet: align with open parenthesis
      net: ll_temac: delete unnecessary else branch
      net: ll_temac: fix the missing spaces around '='
      net: ll_temac: move trailing statements to next line
      net: ll_temac: axienet: delete unnecessary blank lines and spaces

ruanjinjie (2):
      xen-netfront: make bounce_skb static
      net: cpmac: Add __init/__exit annotations to module init/exit funcs

wangjianli (1):
      mellanox/mlxsw: fix repeated words in comments

zhaoxiao (1):
      net: freescale: xgmac: Do not dereference fwnode in struct device

Íñigo Huguet (3):
      sfc: allow more flexible way of adding filters for PTP
      sfc: support PTP over IPv6/UDP
      sfc: support PTP over Ethernet

 Documentation/admin-guide/kernel-parameters.txt    |     4 -
 Documentation/admin-guide/sysctl/net.rst           |    22 +-
 Documentation/bpf/clang-notes.rst                  |    30 +
 Documentation/bpf/index.rst                        |     2 +
 Documentation/bpf/instruction-set.rst              |   316 +-
 Documentation/bpf/kfuncs.rst                       |    39 +-
 Documentation/bpf/linux-notes.rst                  |    53 +
 .../bindings/arm/mediatek/mediatek,mt7622-wed.yaml |     1 +
 .../arm/mediatek/mediatek,mt7986-wed-pcie.yaml     |    43 +
 .../memory-controllers/mediatek,mt7621-memc.yaml   |     6 +-
 .../devicetree/bindings/mfd/mscc,ocelot.yaml       |   160 +
 .../devicetree/bindings/net/adi,adin1110.yaml      |    77 +
 .../devicetree/bindings/net/altera_tse.txt         |   113 -
 .../devicetree/bindings/net/altr,tse.yaml          |   168 +
 .../devicetree/bindings/net/can/nxp,sja1000.yaml   |     6 +-
 .../bindings/net/cortina,gemini-ethernet.yaml      |     1 +
 .../devicetree/bindings/net/dsa/ar9331.txt         |     1 -
 .../devicetree/bindings/net/dsa/arrow,xrs700x.yaml |     3 +-
 .../devicetree/bindings/net/dsa/brcm,b53.yaml      |     4 +-
 .../devicetree/bindings/net/dsa/dsa-port.yaml      |    17 +
 .../bindings/net/dsa/hirschmann,hellcreek.yaml     |     7 +-
 .../devicetree/bindings/net/dsa/lan9303.txt        |     2 -
 .../devicetree/bindings/net/dsa/lantiq-gswip.txt   |     1 -
 .../bindings/net/dsa/mediatek,mt7530.yaml          |   653 +-
 .../devicetree/bindings/net/dsa/microchip,ksz.yaml |     6 +-
 .../devicetree/bindings/net/dsa/mscc,ocelot.yaml   |   260 +
 .../devicetree/bindings/net/dsa/ocelot.txt         |   213 -
 .../devicetree/bindings/net/dsa/qca8k.yaml         |     3 -
 .../devicetree/bindings/net/dsa/realtek.yaml       |     2 -
 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml       |     3 +-
 .../bindings/net/dsa/vitesse,vsc73xx.txt           |     2 -
 .../devicetree/bindings/net/engleder,tsnep.yaml    |    43 +-
 .../bindings/net/ethernet-controller.yaml          |     1 +
 .../devicetree/bindings/net/ethernet-phy.yaml      |     6 +
 Documentation/devicetree/bindings/net/fsl,fec.yaml |     1 +
 .../devicetree/bindings/net/fsl,fman-dtsec.yaml    |   145 +
 Documentation/devicetree/bindings/net/fsl-fman.txt |   128 +-
 .../bindings/net/mediatek,mt7620-gsw.txt           |    24 -
 .../devicetree/bindings/net/mediatek,net.yaml      |    27 +-
 .../devicetree/bindings/net/mediatek-dwmac.yaml    |    10 +-
 .../bindings/net/microchip,sparx5-switch.yaml      |    36 +-
 .../devicetree/bindings/net/nfc/marvell,nci.yaml   |     6 +-
 .../devicetree/bindings/net/nxp,tja11xx.yaml       |    17 +
 .../bindings/net/pse-pd/podl-pse-regulator.yaml    |    40 +
 .../bindings/net/pse-pd/pse-controller.yaml        |    33 +
 .../devicetree/bindings/net/qca,ar803x.yaml        |     8 +
 .../devicetree/bindings/net/ralink,rt2880-net.txt  |    59 -
 .../devicetree/bindings/net/ralink,rt3050-esw.txt  |    30 -
 .../devicetree/bindings/net/renesas,etheravb.yaml  |     9 +-
 .../devicetree/bindings/net/rockchip-dwmac.yaml    |     9 +
 .../devicetree/bindings/net/snps,dwmac.yaml        |    60 +
 .../bindings/net/sunplus,sp7021-emac.yaml          |     2 +
 .../devicetree/bindings/net/ti,cpsw-switch.yaml    |     4 +
 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml        |    19 +-
 .../devicetree/bindings/net/ti,k3-am654-cpts.yaml  |     1 +
 .../devicetree/bindings/net/vertexcom-mse102x.yaml |     2 +-
 .../bindings/net/wireless/brcm,bcm4329-fmac.yaml   |    39 +-
 .../bindings/net/wireless/microchip,wilc1000.yaml  |     7 +-
 .../bindings/net/wireless/qcom,ath11k.yaml         |    14 +
 .../bindings/net/wireless/silabs,wfx.yaml          |    15 +-
 .../bindings/net/wireless/ti,wlcore.yaml           |    32 +-
 Documentation/networking/bonding.rst               |     2 +-
 Documentation/networking/decnet.rst                |   243 -
 .../device_drivers/can/freescale/flexcan.rst       |     2 +-
 .../networking/device_drivers/ethernet/index.rst   |     1 +
 .../device_drivers/ethernet/wangxun/ngbe.rst       |    14 +
 Documentation/networking/devlink/ice.rst           |    36 +
 Documentation/networking/devlink/index.rst         |     6 +-
 Documentation/networking/dsa/configuration.rst     |    96 +
 Documentation/networking/dsa/dsa.rst               |    38 +-
 Documentation/networking/ethtool-netlink.rst       |    61 +
 Documentation/networking/index.rst                 |     2 +-
 Documentation/networking/ip-sysctl.rst             |    29 +
 Documentation/networking/phy.rst                   |    15 +
 Documentation/networking/representors.rst          |   259 +
 Documentation/networking/smc-sysctl.rst            |    25 +
 Documentation/networking/switchdev.rst             |     1 +
 Documentation/userspace-api/index.rst              |     1 +
 Documentation/userspace-api/ioctl/ioctl-number.rst |     1 -
 Documentation/userspace-api/netlink/index.rst      |    12 +
 Documentation/userspace-api/netlink/intro.rst      |   681 +
 MAINTAINERS                                        |    32 +-
 arch/arm/boot/dts/aspeed-bmc-facebook-elbert.dts   |    18 +
 arch/arm64/boot/dts/apple/t8103-j274.dts           |     4 +
 arch/arm64/boot/dts/apple/t8103-j293.dts           |     4 +
 arch/arm64/boot/dts/apple/t8103-j313.dts           |     4 +
 arch/arm64/boot/dts/apple/t8103-j456.dts           |     4 +
 arch/arm64/boot/dts/apple/t8103-j457.dts           |     4 +
 arch/arm64/boot/dts/apple/t8103-jxxx.dtsi          |     2 +
 arch/arm64/boot/dts/mediatek/mt2712e.dtsi          |     2 +-
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi          |    24 +
 arch/arm64/net/bpf_jit_comp.c                      |     8 +-
 arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc1.dts |     8 +-
 arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts |    50 +-
 arch/mips/boot/dts/ralink/mt7621.dtsi              |    35 +-
 arch/mips/configs/decstation_64_defconfig          |     2 -
 arch/mips/configs/decstation_defconfig             |     2 -
 arch/mips/configs/decstation_r4k_defconfig         |     2 -
 arch/mips/configs/gpr_defconfig                    |     2 -
 arch/mips/configs/mtx1_defconfig                   |     2 -
 arch/mips/configs/rm200_defconfig                  |     2 -
 arch/mips/net/bpf_jit_comp32.c                     |    10 +-
 arch/mips/net/bpf_jit_comp64.c                     |    10 +-
 arch/powerpc/configs/ppc6xx_defconfig              |     2 -
 arch/x86/Kconfig                                   |     1 +
 arch/x86/net/bpf_jit_comp.c                        |    98 +-
 drivers/bcma/driver_mips.c                         |     2 +-
 drivers/block/nbd.c                                |     1 +
 drivers/bluetooth/btintel.c                        |    20 +-
 drivers/bluetooth/btusb.c                          |    38 +-
 drivers/bluetooth/hci_ldisc.c                      |     7 +-
 drivers/bluetooth/hci_serdev.c                     |    10 +-
 drivers/bus/mhi/host/pci_generic.c                 |     2 +
 drivers/firmware/xilinx/zynqmp.c                   |    31 +
 drivers/infiniband/hw/mlx5/mad.c                   |    25 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |    12 +
 drivers/isdn/capi/kcapi.c                          |     4 +-
 drivers/isdn/mISDN/l1oip.h                         |     1 +
 drivers/isdn/mISDN/l1oip_core.c                    |    13 +-
 drivers/mfd/Kconfig                                |    21 +
 drivers/mfd/Makefile                               |     3 +
 drivers/mfd/ocelot-core.c                          |   161 +
 drivers/mfd/ocelot-spi.c                           |   299 +
 drivers/mfd/ocelot.h                               |    49 +
 drivers/net/Kconfig                                |     2 +
 drivers/net/Makefile                               |     1 +
 drivers/net/Space.c                                |     2 +-
 drivers/net/amt.c                                  |     6 +-
 drivers/net/bonding/bond_main.c                    |     2 +-
 drivers/net/bonding/bond_sysfs.c                   |   106 +-
 drivers/net/bonding/bond_sysfs_slave.c             |    28 +-
 drivers/net/can/ctucanfd/ctucanfd_base.c           |     3 +-
 drivers/net/can/ctucanfd/ctucanfd_platform.c       |     1 -
 drivers/net/can/dev/rx-offload.c                   |     4 +-
 drivers/net/can/dev/skb.c                          |   113 +-
 drivers/net/can/flexcan/flexcan-core.c             |    59 +-
 drivers/net/can/flexcan/flexcan.h                  |    20 +-
 drivers/net/can/ifi_canfd/ifi_canfd.c              |     2 +-
 drivers/net/can/kvaser_pciefd.c                    |     7 +-
 drivers/net/can/m_can/m_can.c                      |     3 +-
 drivers/net/can/rcar/rcar_canfd.c                  |    26 +-
 drivers/net/can/sja1000/peak_pcmcia.c              |     2 +-
 drivers/net/can/sja1000/sja1000.c                  |     6 +-
 drivers/net/can/sja1000/sja1000_platform.c         |    38 +-
 drivers/net/can/usb/etas_es58x/es58x_core.h        |     2 +-
 drivers/net/can/usb/gs_usb.c                       |   661 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |    20 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |     2 +-
 drivers/net/can/vcan.c                             |    12 +-
 drivers/net/can/vxcan.c                            |     8 +-
 drivers/net/dsa/Kconfig                            |     6 +-
 drivers/net/dsa/b53/b53_common.c                   |     2 +-
 drivers/net/dsa/b53/b53_mdio.c                     |     2 -
 drivers/net/dsa/b53/b53_mmap.c                     |     2 -
 drivers/net/dsa/b53/b53_srab.c                     |     2 -
 drivers/net/dsa/bcm_sf2.c                          |   136 +-
 drivers/net/dsa/bcm_sf2_cfp.c                      |     6 +-
 drivers/net/dsa/dsa_loop.c                         |     2 -
 drivers/net/dsa/hirschmann/hellcreek.c             |    99 +-
 drivers/net/dsa/hirschmann/hellcreek.h             |     7 +
 drivers/net/dsa/lan9303-core.c                     |    34 +-
 drivers/net/dsa/lan9303_i2c.c                      |     2 -
 drivers/net/dsa/lan9303_mdio.c                     |     3 +-
 drivers/net/dsa/lantiq_gswip.c                     |    10 +-
 drivers/net/dsa/microchip/ksz8.h                   |     4 +-
 drivers/net/dsa/microchip/ksz8795.c                |   111 +-
 drivers/net/dsa/microchip/ksz8863_smi.c            |     2 -
 drivers/net/dsa/microchip/ksz9477.c                |   110 +-
 drivers/net/dsa/microchip/ksz9477.h                |     5 +-
 drivers/net/dsa/microchip/ksz9477_i2c.c            |     6 +-
 drivers/net/dsa/microchip/ksz9477_reg.h            |     4 +-
 drivers/net/dsa/microchip/ksz_common.c             |  1043 +-
 drivers/net/dsa/microchip/ksz_common.h             |   136 +-
 drivers/net/dsa/microchip/ksz_spi.c                |    15 +-
 drivers/net/dsa/microchip/lan937x.h                |     6 +-
 drivers/net/dsa/microchip/lan937x_main.c           |   114 +-
 drivers/net/dsa/microchip/lan937x_reg.h            |    18 +
 drivers/net/dsa/mt7530.c                           |    52 +-
 drivers/net/dsa/mt7530.h                           |     1 +
 drivers/net/dsa/mv88e6060.c                        |     2 -
 drivers/net/dsa/mv88e6xxx/chip.c                   |    39 +-
 drivers/net/dsa/mv88e6xxx/global2.h                |     2 +-
 drivers/net/dsa/mv88e6xxx/port.c                   |    19 +
 drivers/net/dsa/ocelot/felix.c                     |   255 +-
 drivers/net/dsa/ocelot/felix.h                     |    16 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             |   684 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c           |   518 +-
 drivers/net/dsa/qca/ar9331.c                       |     2 -
 drivers/net/dsa/qca/qca8k-8xxx.c                   |     2 -
 drivers/net/dsa/qca/qca8k-common.c                 |    23 +-
 drivers/net/dsa/qca/qca8k.h                        |     3 +-
 drivers/net/dsa/realtek/realtek-mdio.c             |     2 -
 drivers/net/dsa/realtek/realtek-smi.c              |     2 -
 drivers/net/dsa/rzn1_a5psw.c                       |     2 -
 drivers/net/dsa/sja1105/sja1105_main.c             |     2 -
 drivers/net/dsa/vitesse-vsc73xx-platform.c         |     2 -
 drivers/net/dsa/vitesse-vsc73xx-spi.c              |     2 -
 drivers/net/dsa/xrs700x/xrs700x_i2c.c              |     2 -
 drivers/net/dsa/xrs700x/xrs700x_mdio.c             |     2 -
 drivers/net/dummy.c                                |     2 +-
 drivers/net/ethernet/3com/3c509.c                  |     2 +-
 drivers/net/ethernet/3com/3c515.c                  |     2 +-
 drivers/net/ethernet/3com/3c589_cs.c               |     2 +-
 drivers/net/ethernet/3com/3c59x.c                  |     6 +-
 drivers/net/ethernet/3com/typhoon.c                |     8 +-
 drivers/net/ethernet/8390/ax88796.c                |     6 +-
 drivers/net/ethernet/8390/etherh.c                 |     6 +-
 drivers/net/ethernet/8390/mcf8390.c                |     3 +-
 drivers/net/ethernet/Kconfig                       |     1 +
 drivers/net/ethernet/Makefile                      |     1 +
 drivers/net/ethernet/actions/owl-emac.c            |     2 +-
 drivers/net/ethernet/adaptec/starfire.c            |     4 +-
 drivers/net/ethernet/adi/Kconfig                   |    28 +
 drivers/net/ethernet/adi/Makefile                  |     6 +
 drivers/net/ethernet/adi/adin1110.c                |  1697 +
 drivers/net/ethernet/aeroflex/greth.c              |     6 +-
 drivers/net/ethernet/agere/et131x.c                |     6 +-
 drivers/net/ethernet/alacritech/slicoss.c          |     6 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |     4 +-
 drivers/net/ethernet/alteon/acenic.c               |     4 +-
 drivers/net/ethernet/altera/Kconfig                |     2 +
 drivers/net/ethernet/altera/altera_tse.h           |    19 +-
 drivers/net/ethernet/altera/altera_tse_ethtool.c   |    23 +-
 drivers/net/ethernet/altera/altera_tse_main.c      |   456 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |     4 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |     8 +-
 drivers/net/ethernet/amd/a2065.c                   |     2 +-
 drivers/net/ethernet/amd/amd8111e.c                |    49 +-
 drivers/net/ethernet/amd/amd8111e.h                |     2 +-
 drivers/net/ethernet/amd/ariadne.c                 |     4 +-
 drivers/net/ethernet/amd/atarilance.c              |    10 +-
 drivers/net/ethernet/amd/au1000_eth.c              |     8 +-
 drivers/net/ethernet/amd/lance.c                   |     4 +-
 drivers/net/ethernet/amd/nmclan_cs.c               |    20 +-
 drivers/net/ethernet/amd/pcnet32.c                 |    16 +-
 drivers/net/ethernet/amd/sun3lance.c               |     4 +-
 drivers/net/ethernet/amd/sunlance.c                |     6 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |     4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c       |     4 +-
 drivers/net/ethernet/apm/xgene-v2/main.c           |     2 +-
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c   |     6 +-
 .../net/ethernet/aquantia/atlantic/aq_ethtool.c    |     2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_macsec.c |    57 -
 drivers/net/ethernet/aquantia/atlantic/aq_ptp.c    |     3 +-
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c    |     3 +-
 drivers/net/ethernet/arc/emac_main.c               |     2 +-
 drivers/net/ethernet/asix/ax88796c_main.c          |     4 +-
 drivers/net/ethernet/atheros/ag71xx.c              |     4 +-
 drivers/net/ethernet/atheros/alx/main.c            |     7 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c |     4 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |     2 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_ethtool.c |     6 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |     2 +-
 drivers/net/ethernet/atheros/atlx/atl1.c           |     6 +-
 drivers/net/ethernet/atheros/atlx/atl2.c           |     6 +-
 drivers/net/ethernet/broadcom/b44.c                |     8 +-
 drivers/net/ethernet/broadcom/bcm4908_enet.c       |    17 +-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c       |     4 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |     6 +-
 drivers/net/ethernet/broadcom/bgmac.c              |     8 +-
 drivers/net/ethernet/broadcom/bnx2.c               |    12 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |     9 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c    |     6 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |     2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h  |     2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c   |     2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |     6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |     8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |    10 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c      |     2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |     5 +-
 drivers/net/ethernet/broadcom/tg3.c                |    10 +-
 drivers/net/ethernet/brocade/bna/bnad.c            |     2 +-
 drivers/net/ethernet/brocade/bna/bnad_ethtool.c    |     8 +-
 drivers/net/ethernet/cadence/macb_main.c           |    26 +-
 drivers/net/ethernet/calxeda/xgmac.c               |     2 +-
 .../net/ethernet/cavium/liquidio/cn23xx_pf_regs.h  |     4 +-
 .../net/ethernet/cavium/liquidio/cn23xx_vf_regs.h  |     4 +-
 drivers/net/ethernet/cavium/liquidio/lio_core.c    |     2 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |     5 -
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c   |     6 +-
 .../net/ethernet/cavium/thunder/nicvf_ethtool.c    |     4 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |     3 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c          |     6 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |     7 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c |     4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |     4 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |     2 +-
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |     4 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c         |     2 +-
 .../chelsio/inline_crypto/chtls/chtls_cm.c         |     5 +-
 .../chelsio/inline_crypto/chtls/chtls_main.c       |     2 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c           |     4 +-
 drivers/net/ethernet/cisco/enic/enic_ethtool.c     |     6 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |     9 +-
 drivers/net/ethernet/cortina/gemini.c              |     2 +-
 drivers/net/ethernet/davicom/dm9000.c              |    32 +-
 drivers/net/ethernet/dec/tulip/de2104x.c           |     4 +-
 drivers/net/ethernet/dec/tulip/dmfe.c              |     4 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c        |     4 +-
 drivers/net/ethernet/dec/tulip/uli526x.c           |     4 +-
 drivers/net/ethernet/dec/tulip/winbond-840.c       |     4 +-
 drivers/net/ethernet/dlink/dl2k.c                  |     4 +-
 drivers/net/ethernet/dlink/sundance.c              |     4 +-
 drivers/net/ethernet/dnet.c                        |     6 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c        |    12 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c     |     6 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |     3 +-
 drivers/net/ethernet/engleder/Kconfig              |     1 +
 drivers/net/ethernet/engleder/Makefile             |     2 +-
 drivers/net/ethernet/engleder/tsnep.h              |    48 +-
 drivers/net/ethernet/engleder/tsnep_ethtool.c      |    40 +
 drivers/net/ethernet/engleder/tsnep_hw.h           |    16 +-
 drivers/net/ethernet/engleder/tsnep_main.c         |   465 +-
 drivers/net/ethernet/engleder/tsnep_rxnfc.c        |   307 +
 drivers/net/ethernet/ethoc.c                       |     2 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |    30 +-
 drivers/net/ethernet/faraday/ftmac100.c            |    12 +-
 drivers/net/ethernet/faraday/ftmac100.h            |    12 +-
 drivers/net/ethernet/fealnx.c                      |     4 +-
 drivers/net/ethernet/freescale/Kconfig             |     7 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |    62 +-
 .../net/ethernet/freescale/dpaa/dpaa_eth_sysfs.c   |     2 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c |     4 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |     3 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c   |     2 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |     5 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |    31 +-
 drivers/net/ethernet/freescale/enetc/enetc.h       |    14 +-
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |   239 +-
 drivers/net/ethernet/freescale/enetc/enetc_hw.h    |   116 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |    27 +-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |    94 +-
 drivers/net/ethernet/freescale/fec.h               |    26 +-
 drivers/net/ethernet/freescale/fec_main.c          |   225 +-
 drivers/net/ethernet/freescale/fec_ptp.c           |     2 +-
 drivers/net/ethernet/freescale/fman/fman.c         |    31 +-
 drivers/net/ethernet/freescale/fman/fman.h         |    31 +-
 drivers/net/ethernet/freescale/fman/fman_dtsec.c   |   321 +-
 drivers/net/ethernet/freescale/fman/fman_dtsec.h   |    58 +-
 drivers/net/ethernet/freescale/fman/fman_keygen.c  |    29 +-
 drivers/net/ethernet/freescale/fman/fman_keygen.h  |    29 +-
 drivers/net/ethernet/freescale/fman/fman_mac.h     |    24 +-
 drivers/net/ethernet/freescale/fman/fman_memac.c   |   238 +-
 drivers/net/ethernet/freescale/fman/fman_memac.h   |    57 +-
 drivers/net/ethernet/freescale/fman/fman_muram.c   |    31 +-
 drivers/net/ethernet/freescale/fman/fman_muram.h   |    32 +-
 drivers/net/ethernet/freescale/fman/fman_port.c    |    29 +-
 drivers/net/ethernet/freescale/fman/fman_port.h    |    29 +-
 drivers/net/ethernet/freescale/fman/fman_sp.c      |    29 +-
 drivers/net/ethernet/freescale/fman/fman_sp.h      |    28 +-
 drivers/net/ethernet/freescale/fman/fman_tgec.c    |   164 +-
 drivers/net/ethernet/freescale/fman/fman_tgec.h    |    54 +-
 drivers/net/ethernet/freescale/fman/mac.c          |   497 +-
 drivers/net/ethernet/freescale/fman/mac.h          |    45 +-
 .../net/ethernet/freescale/fs_enet/fs_enet-main.c  |     5 +-
 drivers/net/ethernet/freescale/fs_enet/mac-fec.c   |     2 +-
 drivers/net/ethernet/freescale/gianfar.c           |     2 +-
 drivers/net/ethernet/freescale/gianfar_ethtool.c   |     2 +-
 drivers/net/ethernet/freescale/ucc_geth.c          |     2 +-
 drivers/net/ethernet/freescale/ucc_geth_ethtool.c  |     4 +-
 drivers/net/ethernet/freescale/xgmac_mdio.c        |     2 +-
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c          |     4 +-
 drivers/net/ethernet/fungible/funeth/funeth_main.c |    15 +-
 drivers/net/ethernet/google/gve/gve_main.c         |     3 +-
 drivers/net/ethernet/hisilicon/hip04_eth.c         |     6 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c      |     2 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |     6 +-
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |    11 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |    42 +-
 .../hisilicon/hns3/hns3_common/hclge_comm_cmd.c    |    14 +-
 .../hisilicon/hns3/hns3_common/hclge_comm_cmd.h    |     6 +
 drivers/net/ethernet/hisilicon/hns3/hns3_dcbnl.c   |    28 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |    13 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   103 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |     3 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   109 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |    23 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |    89 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |    66 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   327 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |    25 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   415 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c    |     2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |    50 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |     5 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |     8 +-
 drivers/net/ethernet/huawei/hinic/hinic_debugfs.h  |     1 -
 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c  |     1 -
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c  |     9 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.h  |     3 -
 drivers/net/ethernet/huawei/hinic/hinic_hw_csr.h   |     1 -
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c   |    17 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h   |     5 -
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.c    |    35 -
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.h    |     9 -
 drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.c  |     9 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_mbox.h  |     4 -
 drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c    |    11 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h    |     5 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c    |     2 -
 drivers/net/ethernet/huawei/hinic/hinic_hw_wqe.h   |    25 -
 drivers/net/ethernet/huawei/hinic/hinic_main.c     |     4 -
 drivers/net/ethernet/huawei/hinic/hinic_rx.c       |     2 +-
 drivers/net/ethernet/huawei/hinic/hinic_rx.h       |     2 -
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c    |    15 +-
 drivers/net/ethernet/huawei/hinic/hinic_sriov.h    |     2 -
 drivers/net/ethernet/huawei/hinic/hinic_tx.c       |     6 +-
 drivers/net/ethernet/huawei/hinic/hinic_tx.h       |     2 -
 drivers/net/ethernet/ibm/ehea/ehea_ethtool.c       |     4 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |     2 +-
 drivers/net/ethernet/ibm/emac/core.c               |    12 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |   303 +-
 drivers/net/ethernet/ibm/ibmveth.h                 |    23 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |     2 +-
 drivers/net/ethernet/intel/e100.c                  |     4 +-
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c   |     4 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |     2 +-
 drivers/net/ethernet/intel/e1000e/ethtool.c        |     4 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |     8 +-
 drivers/net/ethernet/intel/e1000e/phy.c            |    20 +-
 drivers/net/ethernet/intel/fm10k/fm10k_main.c      |     3 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |    14 +
 drivers/net/ethernet/intel/i40e/i40e_common.c      |     3 +
 drivers/net/ethernet/intel/i40e/i40e_devids.h      |     4 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |     6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |    54 +-
 drivers/net/ethernet/intel/i40e/i40e_ptp.c         |     2 +-
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |     6 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   179 +-
 drivers/net/ethernet/intel/ice/ice.h               |     1 +
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h    |    60 +
 drivers/net/ethernet/intel/ice/ice_base.c          |     5 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |   372 +-
 drivers/net/ethernet/intel/ice/ice_common.h        |    10 +
 drivers/net/ethernet/intel/ice/ice_devids.h        |     5 +
 drivers/net/ethernet/intel/ice/ice_devlink.c       |   288 +
 drivers/net/ethernet/intel/ice/ice_eswitch.c       |     4 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |    23 +-
 drivers/net/ethernet/intel/ice/ice_lag.c           |    16 +-
 drivers/net/ethernet/intel/ice/ice_lag.h           |     2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |    29 +-
 drivers/net/ethernet/intel/ice/ice_lib.h           |     2 +
 drivers/net/ethernet/intel/ice/ice_main.c          |   298 +-
 drivers/net/ethernet/intel/ice/ice_nvm.c           |    13 +-
 drivers/net/ethernet/intel/ice/ice_nvm.h           |     2 +-
 drivers/net/ethernet/intel/ice/ice_protocol_type.h |     8 +
 drivers/net/ethernet/intel/ice/ice_ptp.c           |   813 +-
 drivers/net/ethernet/intel/ice/ice_ptp.h           |    26 +-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c        |    98 +-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h        |     7 +
 drivers/net/ethernet/intel/ice/ice_repr.c          |     2 +-
 drivers/net/ethernet/intel/ice/ice_sched.c         |     4 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        |   242 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c        |   242 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.h        |    16 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |     4 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h          |     3 +-
 drivers/net/ethernet/intel/ice/ice_type.h          |     6 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |     6 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |     5 +-
 drivers/net/ethernet/intel/igbvf/ethtool.c         |     4 +-
 drivers/net/ethernet/intel/igbvf/netdev.c          |     2 +-
 drivers/net/ethernet/intel/igc/igc_defines.h       |     1 -
 drivers/net/ethernet/intel/igc/igc_main.c          |   131 +-
 drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c     |     4 +-
 drivers/net/ethernet/intel/ixgb/ixgb_main.c        |     2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |    10 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c      |     2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c       |     3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |     4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h      |     3 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c      |    56 +-
 drivers/net/ethernet/intel/ixgbevf/ethtool.c       |     4 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |     2 +-
 drivers/net/ethernet/jme.c                         |     8 +-
 drivers/net/ethernet/korina.c                      |    11 +-
 drivers/net/ethernet/lantiq_etop.c                 |     2 +-
 drivers/net/ethernet/lantiq_xrx200.c               |     3 +-
 drivers/net/ethernet/litex/litex_liteeth.c         |     3 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c         |    10 +-
 drivers/net/ethernet/marvell/mvneta.c              |    11 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h         |     1 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c |    10 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |    25 +-
 .../net/ethernet/marvell/octeon_ep/octep_main.c    |     2 +-
 drivers/net/ethernet/marvell/octeon_ep/octep_rx.c  |     3 +-
 drivers/net/ethernet/marvell/octeontx2/af/Makefile |     2 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   473 +-
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c    |  1601 +
 drivers/net/ethernet/marvell/octeontx2/af/mcs.h    |   246 +
 .../ethernet/marvell/octeontx2/af/mcs_cnf10kb.c    |   214 +
 .../net/ethernet/marvell/octeontx2/af/mcs_reg.h    |  1102 +
 .../net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c |   889 +
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c    |   106 +-
 drivers/net/ethernet/marvell/octeontx2/af/ptp.h    |     3 +
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c    |    19 +-
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h    |     5 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |    20 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |    21 +
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |   346 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |     8 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |     1 +
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |     1 +
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c |     3 +-
 .../ethernet/marvell/octeontx2/nic/cn10k_macsec.c  |  1668 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |    60 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   131 +-
 .../ethernet/marvell/octeontx2/nic/otx2_dcbnl.c    |   300 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |    16 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |    84 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  |   103 +-
 .../ethernet/marvell/octeontx2/nic/otx2_struct.h   |    11 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |   110 +-
 drivers/net/ethernet/marvell/prestera/Makefile     |     2 +-
 drivers/net/ethernet/marvell/prestera/prestera.h   |    14 +
 .../net/ethernet/marvell/prestera/prestera_acl.c   |    51 +-
 .../net/ethernet/marvell/prestera/prestera_acl.h   |     6 +-
 .../ethernet/marvell/prestera/prestera_ethtool.c   |     4 +-
 .../net/ethernet/marvell/prestera/prestera_flow.c  |    12 +-
 .../net/ethernet/marvell/prestera/prestera_flow.h  |     5 +
 .../ethernet/marvell/prestera/prestera_flower.c    |    54 +-
 .../ethernet/marvell/prestera/prestera_flower.h    |     2 +
 .../net/ethernet/marvell/prestera/prestera_hw.c    |   179 +-
 .../net/ethernet/marvell/prestera/prestera_hw.h    |    18 +-
 .../net/ethernet/marvell/prestera/prestera_main.c  |    52 +-
 .../ethernet/marvell/prestera/prestera_matchall.c  |   125 +
 .../ethernet/marvell/prestera/prestera_matchall.h  |    17 +
 .../ethernet/marvell/prestera/prestera_router.c    |  1119 +-
 .../ethernet/marvell/prestera/prestera_router_hw.c |   366 +-
 .../ethernet/marvell/prestera/prestera_router_hw.h |    76 +-
 .../net/ethernet/marvell/prestera/prestera_rxtx.c  |     2 +-
 .../net/ethernet/marvell/prestera/prestera_span.c  |    66 +-
 .../net/ethernet/marvell/prestera/prestera_span.h  |    12 +-
 .../ethernet/marvell/prestera/prestera_switchdev.c |     8 +-
 drivers/net/ethernet/marvell/pxa168_eth.c          |     8 +-
 drivers/net/ethernet/marvell/skge.c                |     8 +-
 drivers/net/ethernet/marvell/sky2.c                |     8 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   120 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |    93 +-
 drivers/net/ethernet/mediatek/mtk_ppe.c            |   302 +-
 drivers/net/ethernet/mediatek/mtk_ppe.h            |    78 +-
 drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c    |    46 +-
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |    64 +-
 drivers/net/ethernet/mediatek/mtk_ppe_regs.h       |     8 +
 drivers/net/ethernet/mediatek/mtk_star_emac.c      |     5 +-
 drivers/net/ethernet/mediatek/mtk_wed.c            |   479 +-
 drivers/net/ethernet/mediatek/mtk_wed.h            |     8 +-
 drivers/net/ethernet/mediatek/mtk_wed_debugfs.c    |     3 +
 drivers/net/ethernet/mediatek/mtk_wed_regs.h       |    89 +-
 drivers/net/ethernet/mellanox/mlx4/en_cq.c         |     2 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |     6 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c            |     2 +-
 drivers/net/ethernet/mellanox/mlx4/icm.c           |     4 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |     3 +
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |     8 +
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |     3 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   138 +-
 .../net/ethernet/mellanox/mlx5/core/en/channels.c  |    29 +-
 .../net/ethernet/mellanox/mlx5/core/en/channels.h  |     3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   158 +-
 .../ethernet/mellanox/mlx5/core/en/fs_ethtool.h    |    29 +
 .../mellanox/mlx5/core/en/fs_tt_redirect.c         |   188 +-
 .../mellanox/mlx5/core/en/fs_tt_redirect.h         |    13 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |   559 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |    68 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |    46 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h   |     6 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |    30 +-
 .../net/ethernet/mellanox/mlx5/core/en/rx_res.c    |   180 +-
 .../net/ethernet/mellanox/mlx5/core/en/rx_res.h    |     9 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/goto.c   |     3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c  |    10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |    20 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |     2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |     2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/pool.c  |    36 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    |   227 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h    |    48 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |    23 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |    12 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.h    |    12 -
 .../mellanox/mlx5/core/en_accel/en_accel.h         |    15 +
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c  |   111 +-
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.h  |    14 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |    24 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       |     9 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    |    26 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |    12 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |    52 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |    41 +-
 .../mellanox/mlx5/core/en_accel/ktls_txrx.c        |    27 +-
 .../mellanox/mlx5/core/en_accel/ktls_utils.h       |     8 +-
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  |  1870 +
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.h  |    71 +
 .../mellanox/mlx5/core/en_accel/macsec_fs.c        |  1384 +
 .../mellanox/mlx5/core/en_accel/macsec_fs.h        |    47 +
 .../mellanox/mlx5/core/en_accel/macsec_stats.c     |    72 +
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |   141 +-
 .../net/ethernet/mellanox/mlx5/core/en_common.c    |     3 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |    31 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |   437 +-
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |    89 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   420 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |    78 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |     9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   373 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |    24 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |     5 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |    87 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |     1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |     3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |    33 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |     3 +
 .../ethernet/mellanox/mlx5/core/esw/indir_table.c  |     6 +-
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  |     6 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |     1 -
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |     7 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   511 +-
 drivers/net/ethernet/mellanox/mlx5/core/events.c   |     3 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |     9 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |    31 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |    13 +
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |    38 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |     3 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |    26 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c |     1 -
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |    91 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h  |     3 +
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |   139 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h |     1 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |    53 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |    30 +
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |    23 -
 .../mellanox/mlx5/core/steering/dr_types.h         |    14 -
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.h   |     4 -
 drivers/net/ethernet/mellanox/mlx5/core/wq.h       |     2 +-
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c |     2 +-
 drivers/net/ethernet/mellanox/mlxsw/cmd.h          |     3 +
 drivers/net/ethernet/mellanox/mlxsw/core.c         |   135 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h         |    18 +-
 .../mellanox/mlxsw/core_acl_flex_actions.c         |     5 +-
 .../net/ethernet/mellanox/mlxsw/core_linecards.c   |    96 +-
 drivers/net/ethernet/mellanox/mlxsw/i2c.c          |    87 +-
 drivers/net/ethernet/mellanox/mlxsw/minimal.c      |   379 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c          |     5 +
 drivers/net/ethernet/mellanox/mlxsw/reg.h          |   163 -
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |    49 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_ethtool.c |     6 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |     2 +-
 drivers/net/ethernet/micrel/ks8851.h               |     2 +-
 drivers/net/ethernet/micrel/ks8851_common.c        |    46 +-
 drivers/net/ethernet/micrel/ks8851_spi.c           |     5 +-
 drivers/net/ethernet/micrel/ksz884x.c              |     6 +-
 drivers/net/ethernet/microchip/enc28j60.c          |     6 +-
 drivers/net/ethernet/microchip/encx24j600.c        |     6 +-
 drivers/net/ethernet/microchip/lan743x_ethtool.c   |     4 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |    68 +-
 drivers/net/ethernet/microchip/lan743x_main.h      |    10 +-
 drivers/net/ethernet/microchip/lan743x_ptp.c       |     7 +
 drivers/net/ethernet/microchip/lan966x/Kconfig     |     1 +
 drivers/net/ethernet/microchip/lan966x/Makefile    |     5 +-
 .../net/ethernet/microchip/lan966x/lan966x_cbs.c   |    70 +
 .../net/ethernet/microchip/lan966x/lan966x_ets.c   |    96 +
 .../net/ethernet/microchip/lan966x/lan966x_fdb.c   |   155 +-
 .../net/ethernet/microchip/lan966x/lan966x_fdma.c  |     3 +-
 .../net/ethernet/microchip/lan966x/lan966x_lag.c   |   363 +
 .../net/ethernet/microchip/lan966x/lan966x_mac.c   |   104 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |    20 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.h  |   119 +
 .../ethernet/microchip/lan966x/lan966x_mirror.c    |   138 +
 .../ethernet/microchip/lan966x/lan966x_mqprio.c    |    28 +
 .../ethernet/microchip/lan966x/lan966x_phylink.c   |     6 +-
 .../ethernet/microchip/lan966x/lan966x_police.c    |   235 +
 .../net/ethernet/microchip/lan966x/lan966x_port.c  |    24 +-
 .../net/ethernet/microchip/lan966x/lan966x_ptp.c   |     9 +-
 .../net/ethernet/microchip/lan966x/lan966x_regs.h  |   356 +
 .../ethernet/microchip/lan966x/lan966x_switchdev.c |   138 +-
 .../ethernet/microchip/lan966x/lan966x_taprio.c    |   528 +
 .../net/ethernet/microchip/lan966x/lan966x_tbf.c   |    85 +
 .../net/ethernet/microchip/lan966x/lan966x_tc.c    |   133 +
 .../microchip/lan966x/lan966x_tc_matchall.c        |    95 +
 drivers/net/ethernet/microchip/sparx5/Makefile     |     2 +-
 .../ethernet/microchip/sparx5/sparx5_mactable.c    |     4 +-
 .../net/ethernet/microchip/sparx5/sparx5_main.c    |    11 +
 .../net/ethernet/microchip/sparx5/sparx5_main.h    |    21 +-
 .../ethernet/microchip/sparx5/sparx5_main_regs.h   |   165 +
 .../net/ethernet/microchip/sparx5/sparx5_netdev.c  |     8 +-
 .../net/ethernet/microchip/sparx5/sparx5_packet.c  |     4 +-
 drivers/net/ethernet/microchip/sparx5/sparx5_qos.c |   513 +
 drivers/net/ethernet/microchip/sparx5/sparx5_qos.h |    82 +
 .../ethernet/microchip/sparx5/sparx5_switchdev.c   |   271 +-
 drivers/net/ethernet/microchip/sparx5/sparx5_tc.c  |   125 +
 drivers/net/ethernet/microchip/sparx5/sparx5_tc.h  |    15 +
 .../net/ethernet/microchip/sparx5/sparx5_vlan.c    |     7 +
 drivers/net/ethernet/moxa/moxart_ether.c           |     4 +-
 drivers/net/ethernet/mscc/Makefile                 |    11 +-
 drivers/net/ethernet/mscc/ocelot.c                 |   801 +-
 drivers/net/ethernet/mscc/ocelot.h                 |    12 +-
 drivers/net/ethernet/mscc/ocelot_net.c             |    95 +-
 drivers/net/ethernet/mscc/ocelot_ptp.c             |   481 +
 drivers/net/ethernet/mscc/ocelot_stats.c           |   458 +
 drivers/net/ethernet/mscc/ocelot_vsc7514.c         |   419 +-
 drivers/net/ethernet/mscc/vsc7514_regs.c           |     3 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |     8 +-
 drivers/net/ethernet/natsemi/natsemi.c             |     8 +-
 drivers/net/ethernet/natsemi/ns83820.c             |     6 +-
 drivers/net/ethernet/neterion/s2io.c               |    13 +-
 drivers/net/ethernet/netronome/nfp/crypto/tls.c    |     5 +-
 .../net/ethernet/netronome/nfp/flower/conntrack.c  |   242 +-
 .../net/ethernet/netronome/nfp/flower/conntrack.h  |     6 +
 .../net/ethernet/netronome/nfp/flower/offload.c    |     9 +-
 .../net/ethernet/netronome/nfp/flower/qos_conf.c   |    31 +-
 drivers/net/ethernet/netronome/nfp/nfd3/xsk.c      |     2 +-
 drivers/net/ethernet/netronome/nfp/nfp_main.c      |    74 +-
 drivers/net/ethernet/netronome/nfp/nfp_main.h      |     4 +
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |    13 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h  |     7 +
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   254 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_main.c  |    61 +-
 drivers/net/ethernet/netronome/nfp/nfp_port.h      |     2 +
 .../net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h   |     3 +
 .../ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c   |    11 +-
 drivers/net/ethernet/ni/nixge.c                    |     6 +-
 drivers/net/ethernet/nvidia/forcedeth.c            |     8 +-
 drivers/net/ethernet/nxp/lpc_eth.c                 |     6 +-
 .../ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c    |     6 +-
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |     3 +-
 drivers/net/ethernet/packetengines/hamachi.c       |     6 +-
 drivers/net/ethernet/packetengines/yellowfin.c     |     6 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c           |     2 +-
 .../net/ethernet/pensando/ionic/ionic_bus_pci.c    |    16 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |    12 +-
 .../ethernet/qlogic/netxen/netxen_nic_ethtool.c    |     6 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |     3 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c          |     2 +-
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c    |     4 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |     5 +-
 drivers/net/ethernet/qlogic/qla3xxx.c              |     8 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c    |     6 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c     |    19 +-
 drivers/net/ethernet/qualcomm/emac/emac.c          |     3 +-
 drivers/net/ethernet/qualcomm/qca_debug.c          |     8 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h    |     2 +-
 drivers/net/ethernet/rdc/r6040.c                   |     8 +-
 drivers/net/ethernet/realtek/8139cp.c              |     6 +-
 drivers/net/ethernet/realtek/8139too.c             |     8 +-
 drivers/net/ethernet/realtek/r8169.h               |    18 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   241 +-
 drivers/net/ethernet/realtek/r8169_phy_config.c    |   133 -
 drivers/net/ethernet/renesas/ravb.h                |     8 +
 drivers/net/ethernet/renesas/ravb_main.c           |    13 +-
 drivers/net/ethernet/renesas/sh_eth.c              |     2 +-
 drivers/net/ethernet/rocker/rocker_main.c          |     7 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_ethtool.c |     4 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |     2 +-
 drivers/net/ethernet/sfc/Makefile                  |     2 +-
 drivers/net/ethernet/sfc/ef100_ethtool.c           |     2 +
 drivers/net/ethernet/sfc/ef100_netdev.c            |     4 +
 drivers/net/ethernet/sfc/ef100_nic.c               |     3 +
 drivers/net/ethernet/sfc/ef100_rep.c               |    21 +-
 drivers/net/ethernet/sfc/ef100_rep.h               |     1 +
 drivers/net/ethernet/sfc/efx.c                     |    14 +-
 drivers/net/ethernet/sfc/efx_channels.c            |     2 +-
 drivers/net/ethernet/sfc/efx_common.c              |     2 +-
 drivers/net/ethernet/sfc/ethtool_common.c          |    43 +-
 drivers/net/ethernet/sfc/ethtool_common.h          |     2 +
 drivers/net/ethernet/sfc/falcon/efx.c              |     6 +-
 drivers/net/ethernet/sfc/falcon/ethtool.c          |     8 +-
 drivers/net/ethernet/sfc/falcon/falcon.c           |     2 +-
 drivers/net/ethernet/sfc/falcon/nic.c              |     2 +-
 drivers/net/ethernet/sfc/filter.h                  |    22 +
 drivers/net/ethernet/sfc/mae.c                     |   165 +
 drivers/net/ethernet/sfc/mae.h                     |    14 +
 drivers/net/ethernet/sfc/mcdi.h                    |    10 +
 drivers/net/ethernet/sfc/mcdi_mon.c                |     2 +-
 drivers/net/ethernet/sfc/net_driver.h              |     2 +
 drivers/net/ethernet/sfc/nic.c                     |     2 +-
 drivers/net/ethernet/sfc/ptp.c                     |   128 +-
 drivers/net/ethernet/sfc/siena/efx.c               |    14 +-
 drivers/net/ethernet/sfc/siena/efx_channels.c      |     2 +-
 drivers/net/ethernet/sfc/siena/efx_common.c        |     2 +-
 drivers/net/ethernet/sfc/siena/ethtool_common.c    |     6 +-
 drivers/net/ethernet/sfc/siena/mcdi_mon.c          |     2 +-
 drivers/net/ethernet/sfc/siena/nic.c               |     2 +-
 drivers/net/ethernet/sfc/tc.c                      |   430 +-
 drivers/net/ethernet/sfc/tc.h                      |    36 +
 drivers/net/ethernet/sfc/tc_bindings.c             |   228 +
 drivers/net/ethernet/sfc/tc_bindings.h             |    29 +
 drivers/net/ethernet/sgi/ioc3-eth.c                |     6 +-
 drivers/net/ethernet/sis/sis190.c                  |     6 +-
 drivers/net/ethernet/sis/sis900.c                  |     6 +-
 drivers/net/ethernet/smsc/epic100.c                |     8 +-
 drivers/net/ethernet/smsc/smc911x.c                |     6 +-
 drivers/net/ethernet/smsc/smc91c92_cs.c            |     4 +-
 drivers/net/ethernet/smsc/smc91x.c                 |     6 +-
 drivers/net/ethernet/smsc/smsc911x.c               |     6 +-
 drivers/net/ethernet/smsc/smsc9420.c               |     8 +-
 drivers/net/ethernet/socionext/netsec.c            |     6 +-
 drivers/net/ethernet/socionext/sni_ave.c           |     7 +-
 .../ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c    |     4 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |     1 -
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |   280 +
 drivers/net/ethernet/stmicro/stmmac/dwmac100.h     |     2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac1000.h    |     2 +-
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |     9 -
 .../net/ethernet/stmicro/stmmac/dwmac100_core.c    |     8 -
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |     1 -
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |     8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    30 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |     5 +-
 drivers/net/ethernet/sun/cassini.c                 |     8 +-
 drivers/net/ethernet/sun/ldmvsw.c                  |     7 +-
 drivers/net/ethernet/sun/niu.c                     |     8 +-
 drivers/net/ethernet/sun/sunbmac.c                 |     4 +-
 drivers/net/ethernet/sun/sungem.c                  |     8 +-
 drivers/net/ethernet/sun/sunhme.c                  |   665 +-
 drivers/net/ethernet/sun/sunqe.c                   |     4 +-
 drivers/net/ethernet/sun/sunvnet.c                 |     7 +-
 drivers/net/ethernet/sunplus/spl2sw_driver.c       |     7 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-common.c  |     4 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-ethtool.c |     6 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-net.c     |     5 +-
 drivers/net/ethernet/tehuti/tehuti.c               |    10 +-
 drivers/net/ethernet/ti/Kconfig                    |     1 +
 drivers/net/ethernet/ti/am65-cpsw-ethtool.c        |     4 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |    51 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h           |     2 +
 drivers/net/ethernet/ti/am65-cpts.c                |     7 +-
 drivers/net/ethernet/ti/cpmac.c                    |    10 +-
 drivers/net/ethernet/ti/cpsw.c                     |    12 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |    15 +-
 drivers/net/ethernet/ti/davinci_emac.c             |     8 +-
 drivers/net/ethernet/ti/davinci_mdio.c             |   242 +-
 drivers/net/ethernet/ti/netcp_core.c               |     2 +-
 drivers/net/ethernet/ti/tlan.c                     |     6 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c       |     6 +-
 drivers/net/ethernet/toshiba/spider_net.c          |     3 +-
 drivers/net/ethernet/toshiba/spider_net_ethtool.c  |     8 +-
 drivers/net/ethernet/toshiba/tc35815.c             |     6 +-
 drivers/net/ethernet/tundra/tsi108_eth.c           |    25 +-
 drivers/net/ethernet/vertexcom/mse102x.c           |    10 +-
 drivers/net/ethernet/via/via-rhine.c               |     6 +-
 drivers/net/ethernet/via/via-velocity.c            |    10 +-
 drivers/net/ethernet/wangxun/Kconfig               |    13 +
 drivers/net/ethernet/wangxun/Makefile              |     1 +
 drivers/net/ethernet/wangxun/ngbe/Makefile         |     9 +
 drivers/net/ethernet/wangxun/ngbe/ngbe.h           |    24 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c      |   170 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h      |    50 +
 drivers/net/ethernet/wiznet/w5100.c                |     6 +-
 drivers/net/ethernet/wiznet/w5300.c                |     6 +-
 drivers/net/ethernet/xilinx/ll_temac.h             |   181 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c        |    81 +-
 drivers/net/ethernet/xilinx/ll_temac_mdio.c        |     6 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |    14 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |    51 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c  |     2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |     2 +-
 drivers/net/ethernet/xircom/xirc2ps_cs.c           |     2 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c           |     6 +-
 drivers/net/fjes/fjes_ethtool.c                    |     6 +-
 drivers/net/fjes/fjes_main.c                       |  1260 +-
 drivers/net/geneve.c                               |    13 +-
 drivers/net/gtp.c                                  |     1 +
 drivers/net/hamradio/hdlcdrv.c                     |     2 +-
 drivers/net/hyperv/netvsc.c                        |     3 +-
 drivers/net/hyperv/netvsc_drv.c                    |     4 +-
 drivers/net/hyperv/rndis_filter.c                  |     2 +-
 drivers/net/ieee802154/mac802154_hwsim.c           |     1 +
 drivers/net/ipa/Makefile                           |     2 +
 drivers/net/ipa/data/ipa_data-v3.1.c               |     2 +-
 drivers/net/ipa/data/ipa_data-v3.5.1.c             |    10 +-
 drivers/net/ipa/gsi.c                              |    94 +-
 drivers/net/ipa/gsi.h                              |    26 +-
 drivers/net/ipa/gsi_private.h                      |    14 +-
 drivers/net/ipa/gsi_reg.h                          |   210 +-
 drivers/net/ipa/gsi_trans.c                        |   221 +-
 drivers/net/ipa/gsi_trans.h                        |     7 +-
 drivers/net/ipa/ipa.h                              |     4 +-
 drivers/net/ipa/ipa_cmd.c                          |    11 +-
 drivers/net/ipa/ipa_cmd.h                          |     2 +-
 drivers/net/ipa/ipa_data.h                         |     4 +-
 drivers/net/ipa/ipa_endpoint.c                     |   494 +-
 drivers/net/ipa/ipa_endpoint.h                     |     2 +-
 drivers/net/ipa/ipa_interrupt.c                    |    47 +-
 drivers/net/ipa/ipa_interrupt.h                    |     2 +-
 drivers/net/ipa/ipa_main.c                         |   284 +-
 drivers/net/ipa/ipa_mem.c                          |    18 +-
 drivers/net/ipa/ipa_modem.c                        |     2 +-
 drivers/net/ipa/ipa_modem.h                        |     2 +-
 drivers/net/ipa/ipa_power.c                        |     2 +-
 drivers/net/ipa/ipa_power.h                        |     2 +-
 drivers/net/ipa/ipa_qmi.c                          |     2 +-
 drivers/net/ipa/ipa_qmi.h                          |     2 +-
 drivers/net/ipa/ipa_qmi_msg.c                      |     2 +-
 drivers/net/ipa/ipa_qmi_msg.h                      |     2 +-
 drivers/net/ipa/ipa_reg.c                          |    97 +-
 drivers/net/ipa/ipa_reg.h                          |  1121 +-
 drivers/net/ipa/ipa_resource.c                     |    65 +-
 drivers/net/ipa/ipa_smp2p.c                        |     2 +-
 drivers/net/ipa/ipa_smp2p.h                        |     2 +-
 drivers/net/ipa/ipa_sysfs.c                        |     2 +-
 drivers/net/ipa/ipa_sysfs.h                        |     2 +-
 drivers/net/ipa/ipa_table.c                        |    29 +-
 drivers/net/ipa/ipa_table.h                        |     2 +-
 drivers/net/ipa/ipa_uc.c                           |    11 +-
 drivers/net/ipa/ipa_uc.h                           |     2 +-
 drivers/net/ipa/ipa_version.h                      |    30 +-
 drivers/net/ipa/reg/ipa_reg-v3.1.c                 |   478 +
 drivers/net/ipa/reg/ipa_reg-v3.5.1.c               |   456 +
 drivers/net/ipa/reg/ipa_reg-v4.11.c                |   512 +
 drivers/net/ipa/reg/ipa_reg-v4.2.c                 |   456 +
 drivers/net/ipa/reg/ipa_reg-v4.5.c                 |   533 +
 drivers/net/ipa/reg/ipa_reg-v4.9.c                 |   509 +
 drivers/net/ipvlan/ipvlan_main.c                   |     4 +-
 drivers/net/macsec.c                               |    94 +-
 drivers/net/macvlan.c                              |     4 +-
 drivers/net/macvtap.c                              |     4 +-
 drivers/net/mdio/fwnode_mdio.c                     |    58 +-
 drivers/net/mdio/mdio-i2c.c                        |   310 +-
 drivers/net/mdio/mdio-mscc-miim.c                  |    42 +-
 drivers/net/mdio/mdio-mux-meson-g12a.c             |    20 +-
 drivers/net/mdio/mdio-mux-mmioreg.c                |     9 +-
 drivers/net/mdio/mdio-mux-multiplexer.c            |     9 +-
 drivers/net/net_failover.c                         |     4 +-
 drivers/net/netconsole.c                           |    10 +-
 drivers/net/netdevsim/dev.c                        |    20 +-
 drivers/net/ntb_netdev.c                           |     6 +-
 drivers/net/pcs/Kconfig                            |     6 +
 drivers/net/pcs/Makefile                           |     1 +
 drivers/net/pcs/pcs-altera-tse.c                   |   175 +
 drivers/net/phy/adin.c                             |     2 +-
 drivers/net/phy/adin1100.c                         |     7 +-
 drivers/net/phy/aquantia_main.c                    |    68 +-
 drivers/net/phy/at803x.c                           |    28 +-
 drivers/net/phy/bcm-phy-lib.c                      |     2 +-
 drivers/net/phy/broadcom.c                         |    39 +
 drivers/net/phy/marvell-88x2222.c                  |     3 +-
 drivers/net/phy/marvell.c                          |     5 +-
 drivers/net/phy/marvell10g.c                       |   133 +-
 drivers/net/phy/mdio_bus.c                         |     4 +-
 drivers/net/phy/micrel.c                           |   195 +-
 drivers/net/phy/mscc/mscc_macsec.c                 |   113 +-
 drivers/net/phy/mscc/mscc_main.c                   |     2 +-
 drivers/net/phy/nxp-tja11xx.c                      |    83 +-
 drivers/net/phy/phy-core.c                         |    74 +
 drivers/net/phy/phy.c                              |    28 +
 drivers/net/phy/phy_device.c                       |    14 +-
 drivers/net/phy/phylink.c                          |   487 +-
 drivers/net/phy/realtek.c                          |    44 +-
 drivers/net/phy/sfp-bus.c                          |   175 +-
 drivers/net/phy/sfp.c                              |   397 +-
 drivers/net/phy/sfp.h                              |    11 +-
 drivers/net/phy/smsc.c                             |    30 +-
 drivers/net/phy/spi_ks8995.c                       |    69 +-
 drivers/net/pse-pd/Kconfig                         |    22 +
 drivers/net/pse-pd/Makefile                        |     6 +
 drivers/net/pse-pd/pse_core.c                      |   314 +
 drivers/net/pse-pd/pse_regulator.c                 |   147 +
 drivers/net/rionet.c                               |     8 +-
 drivers/net/team/team.c                            |     5 +-
 drivers/net/thunderbolt.c                          |    64 +-
 drivers/net/tun.c                                  |    22 +-
 drivers/net/usb/Kconfig                            |     2 +-
 drivers/net/usb/aqc111.c                           |     2 +-
 drivers/net/usb/asix.h                             |     3 +
 drivers/net/usb/asix_common.c                      |     4 +-
 drivers/net/usb/asix_devices.c                     |   142 +-
 drivers/net/usb/catc.c                             |     4 +-
 drivers/net/usb/lan78xx.c                          |     2 +-
 drivers/net/usb/pegasus.c                          |     2 +-
 drivers/net/usb/r8152.c                            |    32 +-
 drivers/net/usb/rtl8150.c                          |     4 +-
 drivers/net/usb/sierra_net.c                       |     4 +-
 drivers/net/usb/usbnet.c                           |     6 +-
 drivers/net/veth.c                                 |     8 +-
 drivers/net/virtio_net.c                           |     6 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |     4 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c              |     6 +-
 drivers/net/vrf.c                                  |     4 +-
 drivers/net/vxlan/vxlan_core.c                     |    13 +-
 drivers/net/wireguard/netlink.c                    |     1 +
 drivers/net/wireguard/peer.c                       |     3 +-
 drivers/net/wireless/ath/ath10k/bmi.c              |     4 +-
 drivers/net/wireless/ath/ath10k/ce.c               |     2 +-
 drivers/net/wireless/ath/ath10k/core.c             |    18 +-
 drivers/net/wireless/ath/ath10k/core.h             |     4 +-
 drivers/net/wireless/ath/ath10k/coredump.c         |     2 +-
 drivers/net/wireless/ath/ath10k/coredump.h         |     2 +-
 drivers/net/wireless/ath/ath10k/debug.c            |     2 +-
 drivers/net/wireless/ath/ath10k/debugfs_sta.c      |     2 +-
 drivers/net/wireless/ath/ath10k/htc.c              |    11 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |     8 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c           |     2 +-
 drivers/net/wireless/ath/ath10k/hw.c               |     6 +-
 drivers/net/wireless/ath/ath10k/hw.h               |     2 +
 drivers/net/wireless/ath/ath10k/mac.c              |    68 +-
 drivers/net/wireless/ath/ath10k/pci.c              |     5 +-
 drivers/net/wireless/ath/ath10k/pci.h              |     2 +-
 drivers/net/wireless/ath/ath10k/qmi.c              |     2 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h          |     2 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |     5 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |     3 +-
 drivers/net/wireless/ath/ath10k/thermal.c          |     2 +-
 drivers/net/wireless/ath/ath10k/thermal.h          |     2 +-
 drivers/net/wireless/ath/ath10k/usb.c              |     3 +-
 drivers/net/wireless/ath/ath10k/usb.h              |     2 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h          |     4 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |     2 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |    14 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |   188 +-
 drivers/net/wireless/ath/ath11k/ahb.h              |    16 +
 drivers/net/wireless/ath/ath11k/ce.c               |     4 +-
 drivers/net/wireless/ath/ath11k/core.c             |   132 +-
 drivers/net/wireless/ath/ath11k/core.h             |    25 +-
 drivers/net/wireless/ath/ath11k/debugfs.c          |   488 +-
 drivers/net/wireless/ath/ath11k/debugfs.h          |    11 +-
 .../net/wireless/ath/ath11k/debugfs_htt_stats.h    |     4 +-
 drivers/net/wireless/ath/ath11k/debugfs_sta.c      |   107 +
 drivers/net/wireless/ath/ath11k/dp.c               |    28 +-
 drivers/net/wireless/ath/ath11k/dp.h               |    20 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |     5 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |    21 +-
 drivers/net/wireless/ath/ath11k/hal.c              |     4 +-
 drivers/net/wireless/ath/ath11k/hal.h              |    23 +-
 drivers/net/wireless/ath/ath11k/hal_desc.h         |     8 +-
 drivers/net/wireless/ath/ath11k/hal_tx.c           |     4 +-
 drivers/net/wireless/ath/ath11k/hal_tx.h           |     2 +
 drivers/net/wireless/ath/ath11k/hif.h              |    11 +
 drivers/net/wireless/ath/ath11k/hw.c               |   118 +-
 drivers/net/wireless/ath/ath11k/hw.h               |    23 +
 drivers/net/wireless/ath/ath11k/mac.c              |   165 +-
 drivers/net/wireless/ath/ath11k/mhi.c              |    17 +-
 drivers/net/wireless/ath/ath11k/pci.c              |     1 +
 drivers/net/wireless/ath/ath11k/pcic.c             |   118 +-
 drivers/net/wireless/ath/ath11k/pcic.h             |     6 +
 drivers/net/wireless/ath/ath11k/peer.c             |    30 +-
 drivers/net/wireless/ath/ath11k/qmi.c              |    54 +-
 drivers/net/wireless/ath/ath11k/qmi.h              |    10 +-
 drivers/net/wireless/ath/ath11k/rx_desc.h          |     2 +-
 drivers/net/wireless/ath/ath11k/spectral.c         |    22 +
 drivers/net/wireless/ath/ath11k/spectral.h         |     1 +
 drivers/net/wireless/ath/ath11k/thermal.c          |     2 +-
 drivers/net/wireless/ath/ath11k/thermal.h          |     2 +-
 drivers/net/wireless/ath/ath11k/trace.h            |    28 +
 drivers/net/wireless/ath/ath11k/wmi.c              |   246 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |    72 +-
 drivers/net/wireless/ath/ath11k/wow.c              |    21 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |     8 +-
 drivers/net/wireless/ath/ath6kl/init.c             |     2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c        |     2 +-
 drivers/net/wireless/ath/ath9k/channel.c           |     2 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |    43 +-
 drivers/net/wireless/ath/ath9k/hw.h                |     2 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |     2 +-
 drivers/net/wireless/ath/carl9170/fw.c             |     2 +-
 drivers/net/wireless/ath/wcn36xx/hal.h             |     2 +-
 drivers/net/wireless/ath/wcn36xx/txrx.c            |     4 +
 drivers/net/wireless/ath/wil6210/cfg80211.c        |    10 +-
 drivers/net/wireless/ath/wil6210/main.c            |     2 +-
 drivers/net/wireless/ath/wil6210/netdev.c          |     8 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |     2 +-
 drivers/net/wireless/atmel/atmel.c                 |     2 +-
 drivers/net/wireless/broadcom/b43/leds.c           |     2 +-
 drivers/net/wireless/broadcom/b43/phy_n.c          |     6 +-
 drivers/net/wireless/broadcom/b43legacy/leds.c     |     2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    |     7 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |     1 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |    19 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |    62 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |    10 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |    20 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.h  |     1 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |    15 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/dmi.c |    18 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |     3 +-
 .../broadcom/brcm80211/brcmfmac/firmware.c         |   118 +-
 .../broadcom/brcm80211/brcmfmac/firmware.h         |     4 +-
 .../broadcom/brcm80211/brcmfmac/flowring.c         |     5 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |     2 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |    18 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.h         |     3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |    25 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.h  |     4 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |    12 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   434 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.c |    12 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |    40 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |     2 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |    23 +-
 .../wireless/broadcom/brcm80211/brcmsmac/types.h   |     2 +-
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |     7 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |    10 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |     6 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.h       |     2 +-
 drivers/net/wireless/intel/ipw2x00/libipw.h        |    13 +-
 drivers/net/wireless/intel/ipw2x00/libipw_rx.c     |    10 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |     2 +-
 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |     2 +-
 drivers/net/wireless/intel/iwlegacy/commands.h     |     4 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |     8 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |    42 +-
 drivers/net/wireless/intel/iwlwifi/dvm/agn.h       |     2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/calib.c     |    22 +-
 drivers/net/wireless/intel/iwlwifi/dvm/dev.h       |     1 +
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c        |     6 +-
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c      |    10 +-
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c       |    10 +-
 drivers/net/wireless/intel/iwlwifi/dvm/ucode.c     |     8 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |     5 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h     |    61 +-
 .../net/wireless/intel/iwlwifi/fw/api/offload.h    |    17 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |     4 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |    20 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |     3 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   668 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |    14 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |    27 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |     4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |    21 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |    18 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |    17 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   376 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |     6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |     2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |     2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |    19 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |     2 +-
 .../net/wireless/intersil/hostap/hostap_ioctl.c    |     2 +-
 drivers/net/wireless/intersil/p54/main.c           |     2 +-
 drivers/net/wireless/mac80211_hwsim.c              |   545 +-
 drivers/net/wireless/marvell/libertas/cfg.c        |    11 +-
 drivers/net/wireless/marvell/libertas/ethtool.c    |     4 +-
 drivers/net/wireless/marvell/libertas/main.c       |     3 +-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   |     2 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |    10 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |     4 +-
 drivers/net/wireless/marvell/mwifiex/init.c        |     9 +-
 drivers/net/wireless/marvell/mwifiex/main.h        |     3 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c        |     2 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |     4 +-
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |     8 +-
 drivers/net/wireless/marvell/mwifiex/usb.c         |    12 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |     2 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |    50 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |     2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |     4 +
 drivers/net/wireless/mediatek/mt76/mt7615/sdio.c   |    16 +-
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c    |     1 +
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |    11 +-
 .../net/wireless/mediatek/mt76/mt76_connac2_mac.h  |     8 +
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |    76 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |    18 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |    11 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |     2 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   |    30 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |     6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |    27 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |    19 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |    18 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |   256 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |     2 -
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |    21 +
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |    12 +-
 .../net/wireless/mediatek/mt76/mt7921/acpi_sar.c   |     5 +-
 drivers/net/wireless/mediatek/mt76/mt7921/eeprom.h |     5 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |     1 +
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |   147 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |    28 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   198 +
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h    |     2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |    39 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |    99 +-
 .../net/wireless/mediatek/mt76/mt7921/pci_mac.c    |   148 -
 .../net/wireless/mediatek/mt76/mt7921/pci_mcu.c    |     9 +-
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |     2 +
 drivers/net/wireless/mediatek/mt76/mt7921/sdio.c   |    29 +-
 .../net/wireless/mediatek/mt76/mt7921/sdio_mcu.c   |     7 +-
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c    |    40 +-
 drivers/net/wireless/mediatek/mt76/sdio.c          |     8 +-
 drivers/net/wireless/mediatek/mt76/sdio_txrx.c     |    23 +-
 drivers/net/wireless/mediatek/mt76/testmode.c      |     8 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |     5 +
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |    22 +-
 drivers/net/wireless/microchip/wilc1000/mon.c      |     2 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |    18 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |     2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800.h        |     3 +
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |  1753 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h     |    10 +
 drivers/net/wireless/ralink/rt2x00/rt2x00.h        |     5 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c     |    18 +
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c   |     2 +-
 .../net/wireless/realtek/rtl818x/rtl8187/leds.c    |     2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |     6 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   108 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   |     9 +-
 drivers/net/wireless/realtek/rtw88/bf.c            |     2 +-
 drivers/net/wireless/realtek/rtw88/coex.c          |    88 +-
 drivers/net/wireless/realtek/rtw88/coex.h          |    14 +-
 drivers/net/wireless/realtek/rtw88/debug.c         |    11 +-
 drivers/net/wireless/realtek/rtw88/efuse.c         |     4 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |   101 +-
 drivers/net/wireless/realtek/rtw88/fw.h            |    21 +-
 drivers/net/wireless/realtek/rtw88/mac.c           |    18 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |    14 +-
 drivers/net/wireless/realtek/rtw88/main.c          |   220 +-
 drivers/net/wireless/realtek/rtw88/main.h          |    31 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |    23 +-
 drivers/net/wireless/realtek/rtw88/phy.c           |    65 +-
 drivers/net/wireless/realtek/rtw88/phy.h           |     2 +-
 drivers/net/wireless/realtek/rtw88/ps.c            |     7 +-
 drivers/net/wireless/realtek/rtw88/regd.c          |     2 +
 drivers/net/wireless/realtek/rtw88/rtw8723d.c      |     3 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |     3 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |     3 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |     3 +-
 drivers/net/wireless/realtek/rtw88/tx.c            |     8 +-
 drivers/net/wireless/realtek/rtw88/util.c          |     4 +-
 drivers/net/wireless/realtek/rtw89/Makefile        |     1 +
 drivers/net/wireless/realtek/rtw89/chan.c          |   235 +
 drivers/net/wireless/realtek/rtw89/chan.h          |    64 +
 drivers/net/wireless/realtek/rtw89/coex.c          |  2009 +-
 drivers/net/wireless/realtek/rtw89/coex.h          |     6 +-
 drivers/net/wireless/realtek/rtw89/core.c          |   489 +-
 drivers/net/wireless/realtek/rtw89/core.h          |   551 +-
 drivers/net/wireless/realtek/rtw89/debug.c         |   107 +-
 drivers/net/wireless/realtek/rtw89/debug.h         |     1 +
 drivers/net/wireless/realtek/rtw89/fw.c            |   702 +-
 drivers/net/wireless/realtek/rtw89/fw.h            |   299 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |   338 +-
 drivers/net/wireless/realtek/rtw89/mac.h           |    63 +-
 drivers/net/wireless/realtek/rtw89/mac80211.c      |   161 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |   410 +-
 drivers/net/wireless/realtek/rtw89/pci.h           |    73 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |   453 +-
 drivers/net/wireless/realtek/rtw89/phy.h           |    11 +-
 drivers/net/wireless/realtek/rtw89/ps.c            |    78 +-
 drivers/net/wireless/realtek/rtw89/ps.h            |     3 +-
 drivers/net/wireless/realtek/rtw89/reg.h           |   148 +-
 drivers/net/wireless/realtek/rtw89/regd.c          |     2 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |   244 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk.c  |    77 +-
 drivers/net/wireless/realtek/rtw89/rtw8852ae.c     |     7 +-
 drivers/net/wireless/realtek/rtw89/rtw8852b.c      |    94 +
 drivers/net/wireless/realtek/rtw89/rtw8852be.c     |    25 +
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |   411 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c  |    76 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.h  |     2 +-
 .../net/wireless/realtek/rtw89/rtw8852c_table.c    | 36992 ++++++++++++++-----
 drivers/net/wireless/realtek/rtw89/rtw8852ce.c     |     7 +-
 drivers/net/wireless/realtek/rtw89/sar.c           |     8 +-
 drivers/net/wireless/realtek/rtw89/ser.c           |    17 +-
 drivers/net/wireless/rndis_wlan.c                  |    25 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |     1 +
 drivers/net/wireless/silabs/wfx/main.c             |     2 +-
 drivers/net/wireless/st/cw1200/queue.c             |    18 +-
 drivers/net/wireless/st/cw1200/sta.c               |     4 +-
 drivers/net/wireless/st/cw1200/txrx.c              |     8 +-
 drivers/net/wireless/ti/wl1251/main.c              |     2 +-
 drivers/net/wireless/ti/wl18xx/event.c             |     8 +-
 drivers/net/wireless/ti/wlcore/cmd.c               |     4 +-
 drivers/net/wireless/wl3501_cs.c                   |     8 +-
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c          |     2 +-
 drivers/net/wwan/iosm/iosm_ipc_wwan.c              |     9 +-
 drivers/net/wwan/mhi_wwan_ctrl.c                   |     1 +
 drivers/net/wwan/t7xx/t7xx_netdev.c                |     2 +-
 drivers/net/wwan/wwan_hwsim.c                      |     6 +-
 drivers/net/xen-netback/common.h                   |     2 +-
 drivers/net/xen-netback/interface.c                |     7 +-
 drivers/net/xen-netback/netback.c                  |     7 +-
 drivers/net/xen-netback/xenbus.c                   |     3 +-
 drivers/net/xen-netfront.c                         |     5 +-
 drivers/of/base.c                                  |     1 +
 drivers/phy/microchip/lan966x_serdes.c             |     3 +
 drivers/pinctrl/Kconfig                            |     5 +-
 drivers/pinctrl/pinctrl-microchip-sgpio.c          |    14 +-
 drivers/pinctrl/pinctrl-ocelot.c                   |    16 +-
 drivers/ptp/ptp_clock.c                            |     6 +-
 drivers/ptp/ptp_ocp.c                              |     8 +-
 drivers/s390/net/qeth_l2_main.c                    |     6 +-
 drivers/s390/net/qeth_l3_main.c                    |     2 +-
 drivers/soc/fsl/qbman/qman.c                       |    77 +-
 drivers/staging/qlge/qlge_main.c                   |     4 +-
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c  |    13 +-
 drivers/staging/wlan-ng/cfg80211.c                 |    12 +-
 drivers/target/target_core_user.c                  |     1 +
 drivers/thermal/thermal_netlink.c                  |     1 +
 drivers/thunderbolt/nhi.c                          |    49 +-
 drivers/thunderbolt/tb.c                           |     8 +-
 drivers/thunderbolt/tb.h                           |     2 +-
 drivers/thunderbolt/usb4.c                         |     8 +-
 drivers/thunderbolt/usb4_port.c                    |     2 +
 drivers/vdpa/vdpa.c                                |     1 +
 drivers/vhost/net.c                                |    15 +-
 drivers/vhost/vsock.c                              |     2 +-
 fs/cifs/netlink.c                                  |     1 +
 fs/dlm/netlink.c                                   |     1 +
 fs/ksmbd/transport_ipc.c                           |     1 +
 include/asm-generic/vmlinux.lds.h                  |    11 +-
 include/linux/bcma/bcma_driver_chipcommon.h        |     1 +
 include/linux/bpf-cgroup.h                         |    17 +
 include/linux/bpf.h                                |   184 +-
 include/linux/bpf_mem_alloc.h                      |    28 +
 include/linux/bpf_types.h                          |     1 +
 include/linux/bpf_verifier.h                       |    40 +
 include/linux/brcmphy.h                            |     1 +
 include/linux/btf.h                                |    21 +
 include/linux/can/dev.h                            |     5 +
 include/linux/can/skb.h                            |    57 +-
 include/linux/compiler_attributes.h                |     7 +
 include/linux/etherdevice.h                        |    22 +
 include/linux/filter.h                             |    16 +-
 include/linux/firmware/xlnx-zynqmp.h               |    45 +
 include/linux/genl_magic_func.h                    |     1 +
 include/linux/ieee80211.h                          |    14 +-
 include/linux/if_pppol2tp.h                        |     2 -
 include/linux/if_pppox.h                           |     2 -
 include/linux/igmp.h                               |     4 +-
 include/linux/ioport.h                             |     5 +
 include/linux/key.h                                |     6 +
 include/linux/kprobes.h                            |     1 +
 include/linux/mdio/mdio-i2c.h                      |    10 +-
 include/linux/mfd/ocelot.h                         |    62 +
 include/linux/mlx5/device.h                        |    32 +-
 include/linux/mlx5/driver.h                        |    16 +-
 include/linux/mlx5/fs.h                            |    12 +-
 include/linux/mlx5/fs_helpers.h                    |    48 -
 include/linux/mlx5/mlx5_ifc.h                      |   282 +-
 include/linux/mlx5/mlx5_ifc_fpga.h                 |    24 -
 include/linux/mlx5/qp.h                            |     9 +
 include/linux/mmc/sdio_ids.h                       |     1 +
 include/linux/mroute.h                             |     6 +-
 include/linux/mroute6.h                            |     4 +-
 include/linux/netdevice.h                          |    55 +-
 include/linux/netfilter.h                          |     5 -
 include/linux/netfilter_defs.h                     |     8 -
 include/linux/netlink.h                            |    24 +
 include/linux/once.h                               |    28 +
 include/linux/pcs-altera-tse.h                     |    17 +
 include/linux/phy.h                                |    38 +-
 include/linux/phylink.h                            |    40 +-
 include/linux/poison.h                             |     3 +
 include/linux/pse-pd/pse.h                         |   129 +
 include/linux/sfp.h                                |     5 +-
 include/linux/skbuff.h                             |    41 +-
 include/linux/soc/mediatek/mtk_wed.h               |    19 +-
 include/linux/sockptr.h                            |     5 +
 include/linux/stmmac.h                             |     1 -
 include/linux/tcp.h                                |     8 +-
 include/linux/thunderbolt.h                        |     2 +
 include/linux/tnum.h                               |    20 +-
 include/linux/uio.h                                |     2 +-
 include/linux/verification.h                       |     8 +
 include/net/act_api.h                              |     1 +
 include/net/af_vsock.h                             |     2 +
 include/net/bluetooth/bluetooth.h                  |     1 +
 include/net/bluetooth/hci.h                        |     4 +
 include/net/bluetooth/hci_core.h                   |    17 +-
 include/net/bluetooth/hci_sync.h                   |     9 +-
 include/net/bluetooth/mgmt.h                       |    52 +
 include/net/cfg80211.h                             |    43 +-
 include/net/devlink.h                              |    27 +-
 include/net/dn.h                                   |   231 -
 include/net/dn_dev.h                               |   200 -
 include/net/dn_fib.h                               |   169 -
 include/net/dn_neigh.h                             |    32 -
 include/net/dn_nsp.h                               |   201 -
 include/net/dn_route.h                             |   118 -
 include/net/dsa.h                                  |    37 +-
 include/net/dst.h                                  |     6 -
 include/net/dst_metadata.h                         |    41 +
 include/net/flow.h                                 |    26 -
 include/net/flow_dissector.h                       |     9 +
 include/net/flow_offload.h                         |     6 +
 include/net/genetlink.h                            |    10 +
 include/net/gro.h                                  |    33 +-
 include/net/inet_connection_sock.h                 |     3 +
 include/net/inet_hashtables.h                      |    99 +-
 include/net/ip.h                                   |     4 +
 include/net/ip_tunnels.h                           |     6 +
 include/net/ipcomp.h                               |     2 +-
 include/net/ipv6.h                                 |     6 +-
 include/net/ipv6_stubs.h                           |     4 +
 include/net/mac80211.h                             |   198 +-
 include/net/macsec.h                               |    28 +-
 include/net/neighbour.h                            |     5 -
 include/net/netfilter/nf_conntrack_bpf.h           |    25 +-
 include/net/netfilter/nf_conntrack_core.h          |     6 -
 include/net/netfilter/nf_nat_helper.h              |     1 +
 include/net/netlink.h                              |    13 +-
 include/net/netns/generic.h                        |     2 +-
 include/net/netns/ipv4.h                           |     4 +-
 include/net/netns/netfilter.h                      |     3 -
 include/net/netns/smc.h                            |     3 +
 include/net/nl802154.h                             |     6 +-
 include/net/pkt_cls.h                              |    25 +
 include/net/pkt_sched.h                            |    25 +-
 include/net/red.h                                  |     1 -
 include/net/sch_generic.h                          |    16 +-
 include/net/sock.h                                 |    28 +-
 include/net/tcp.h                                  |    12 +-
 include/net/tls.h                                  |    10 +
 include/net/xdp.h                                  |     4 +-
 include/net/xdp_sock_drv.h                         |    10 +-
 include/net/xfrm.h                                 |    24 +-
 include/net/xsk_buff_pool.h                        |     2 +-
 include/soc/fsl/qman.h                             |     9 +
 include/soc/mscc/ocelot.h                          |   144 +-
 include/uapi/linux/bpf.h                           |   182 +-
 include/uapi/linux/can.h                           |    55 +-
 include/uapi/linux/can/raw.h                       |     1 +
 include/uapi/linux/dn.h                            |   149 -
 include/uapi/linux/ethtool.h                       |    63 +-
 include/uapi/linux/ethtool_netlink.h               |    17 +
 include/uapi/linux/if_ether.h                      |     1 +
 include/uapi/linux/if_link.h                       |    12 +
 include/uapi/linux/if_macsec.h                     |     2 +
 include/uapi/linux/in.h                            |    22 +-
 include/uapi/linux/l2tp.h                          |     2 -
 include/uapi/linux/lwtunnel.h                      |    10 +
 include/uapi/linux/netfilter.h                     |     2 +
 include/uapi/linux/netfilter/ipset/ip_set.h        |     4 -
 include/uapi/linux/netfilter/xt_AUDIT.h            |     4 -
 include/uapi/linux/netfilter/xt_connmark.h         |    13 +-
 include/uapi/linux/netfilter/xt_osf.h              |    14 -
 include/uapi/linux/netfilter_decnet.h              |    72 -
 include/uapi/linux/netlink.h                       |    31 +-
 include/uapi/linux/nl80211.h                       |    25 +-
 include/uapi/linux/openvswitch.h                   |     3 +
 include/uapi/linux/pkt_cls.h                       |     2 +
 include/uapi/linux/pkt_sched.h                     |    11 +
 include/uapi/linux/seg6_local.h                    |    24 +
 include/uapi/linux/tc_act/tc_bpf.h                 |     5 -
 include/uapi/linux/tc_act/tc_skbedit.h             |    13 -
 include/uapi/linux/tc_act/tc_skbmod.h              |     7 +-
 include/uapi/linux/tc_act/tc_tunnel_key.h          |     5 -
 include/uapi/linux/tc_act/tc_vlan.h                |     5 -
 include/uapi/linux/tls.h                           |    30 +
 kernel/bpf/Makefile                                |     5 +-
 kernel/bpf/arraymap.c                              |    33 +-
 kernel/bpf/bpf_iter.c                              |    10 +
 kernel/bpf/bpf_local_storage.c                     |    10 +-
 kernel/bpf/bpf_lsm.c                               |    23 +-
 kernel/bpf/bpf_task_storage.c                      |     8 +-
 kernel/bpf/btf.c                                   |   287 +-
 kernel/bpf/cgroup.c                                |   185 +-
 kernel/bpf/cgroup_iter.c                           |   282 +
 kernel/bpf/core.c                                  |    10 +-
 kernel/bpf/cpumap.c                                |     6 +-
 kernel/bpf/devmap.c                                |     6 +-
 kernel/bpf/dispatcher.c                            |    27 +-
 kernel/bpf/hashtab.c                               |   206 +-
 kernel/bpf/helpers.c                               |   120 +-
 kernel/bpf/local_storage.c                         |     5 +-
 kernel/bpf/lpm_trie.c                              |     4 +-
 kernel/bpf/memalloc.c                              |   635 +
 kernel/bpf/offload.c                               |     6 +-
 kernel/bpf/percpu_freelist.c                       |    48 +-
 kernel/bpf/queue_stack_maps.c                      |     2 -
 kernel/bpf/ringbuf.c                               |   253 +-
 kernel/bpf/syscall.c                               |    46 +-
 kernel/bpf/task_iter.c                             |   224 +-
 kernel/bpf/trampoline.c                            |    68 +-
 kernel/bpf/verifier.c                              |   588 +-
 kernel/cgroup/cgroup.c                             |     5 -
 kernel/cgroup/rstat.c                              |    48 +
 kernel/kprobes.c                                   |     6 +-
 kernel/taskstats.c                                 |     1 +
 kernel/trace/Kconfig                               |     6 +
 kernel/trace/bpf_trace.c                           |   211 +-
 kernel/trace/ftrace.c                              |     3 +-
 lib/nlattr.c                                       |    31 +-
 lib/once.c                                         |    30 +
 net/8021q/vlan_core.c                              |     9 +-
 net/8021q/vlan_dev.c                               |     6 +-
 net/Kconfig                                        |     2 -
 net/Kconfig.debug                                  |     4 +-
 net/Makefile                                       |     1 -
 net/ax25/af_ax25.c                                 |     2 +-
 net/batman-adv/bat_v_elp.c                         |     1 -
 net/batman-adv/main.h                              |     2 +-
 net/batman-adv/netlink.c                           |     1 +
 net/batman-adv/trace.h                             |     2 -
 net/batman-adv/types.h                             |    39 -
 net/bluetooth/hci_conn.c                           |   162 +-
 net/bluetooth/hci_core.c                           |    68 +-
 net/bluetooth/hci_debugfs.c                        |     2 +-
 net/bluetooth/hci_event.c                          |   175 +-
 net/bluetooth/hci_request.c                        |  1650 +-
 net/bluetooth/hci_request.h                        |    53 -
 net/bluetooth/hci_sock.c                           |     4 +-
 net/bluetooth/hci_sync.c                           |   491 +-
 net/bluetooth/hci_sysfs.c                          |     3 +
 net/bluetooth/l2cap_core.c                         |    17 +-
 net/bluetooth/mgmt.c                               |   610 +-
 net/bluetooth/mgmt_util.c                          |    74 +
 net/bluetooth/mgmt_util.h                          |    18 +
 net/bluetooth/rfcomm/sock.c                        |     3 +
 net/bpf/test_run.c                                 |    42 +
 net/bridge/br_device.c                             |     8 +-
 net/bridge/br_if.c                                 |    31 +-
 net/bridge/br_sysfs_if.c                           |     4 +-
 net/bridge/netfilter/ebtables.c                    |     2 +-
 net/caif/caif_dev.c                                |     2 +-
 net/caif/caif_usb.c                                |     2 +-
 net/caif/cfcnfg.c                                  |     4 +-
 net/caif/cfctrl.c                                  |     2 +-
 net/can/af_can.c                                   |    76 +-
 net/can/bcm.c                                      |    34 +-
 net/can/gw.c                                       |     4 +-
 net/can/isotp.c                                    |     2 +-
 net/can/j1939/main.c                               |     4 +
 net/can/raw.c                                      |    82 +-
 net/core/dev.c                                     |    25 +-
 net/core/devlink.c                                 |   339 +-
 net/core/drop_monitor.c                            |     3 +-
 net/core/filter.c                                  |   744 +-
 net/core/flow_dissector.c                          |    48 +-
 net/core/flow_offload.c                            |     7 +
 net/core/gro.c                                     |    18 +-
 net/core/gro_cells.c                               |     3 +-
 net/core/lwtunnel.c                                |     1 +
 net/core/neighbour.c                               |     3 -
 net/core/net-sysfs.c                               |    58 +-
 net/core/netclassid_cgroup.c                       |     2 +-
 net/core/netpoll.c                                 |     4 +-
 net/core/rtnetlink.c                               |    23 +-
 net/core/skbuff.c                                  |   151 +-
 net/core/skmsg.c                                   |    12 +-
 net/core/sock.c                                    |   134 +-
 net/core/sock_map.c                                |    12 +-
 net/core/stream.c                                  |     3 +-
 net/core/sysctl_net_core.c                         |     1 -
 net/core/xdp.c                                     |    10 +-
 net/dccp/ipv4.c                                    |    25 +-
 net/dccp/ipv6.c                                    |    18 +
 net/dccp/proto.c                                   |    36 +-
 net/decnet/Kconfig                                 |    43 -
 net/decnet/Makefile                                |    10 -
 net/decnet/README                                  |     8 -
 net/decnet/af_decnet.c                             |  2404 --
 net/decnet/dn_dev.c                                |  1433 -
 net/decnet/dn_fib.c                                |   798 -
 net/decnet/dn_neigh.c                              |   607 -
 net/decnet/dn_nsp_in.c                             |   907 -
 net/decnet/dn_nsp_out.c                            |   696 -
 net/decnet/dn_route.c                              |  1922 -
 net/decnet/dn_rules.c                              |   253 -
 net/decnet/dn_table.c                              |   929 -
 net/decnet/dn_timer.c                              |   104 -
 net/decnet/netfilter/Kconfig                       |    17 -
 net/decnet/netfilter/Makefile                      |     6 -
 net/decnet/netfilter/dn_rtmsg.c                    |   158 -
 net/decnet/sysctl_net_decnet.c                     |   362 -
 net/dsa/Makefile                                   |    10 +-
 net/dsa/dsa.c                                      |     9 +
 net/dsa/dsa2.c                                     |   304 +-
 net/dsa/dsa_priv.h                                 |    24 +-
 net/dsa/master.c                                   |    76 +-
 net/dsa/netlink.c                                  |    63 +
 net/dsa/port.c                                     |   372 +-
 net/dsa/slave.c                                    |   489 +-
 net/dsa/switch.c                                   |    26 +-
 net/dsa/tag_8021q.c                                |     8 +-
 net/ethernet/eth.c                                 |     9 +-
 net/ethtool/Makefile                               |     3 +-
 net/ethtool/common.h                               |     1 +
 net/ethtool/ioctl.c                                |     9 +-
 net/ethtool/linkmodes.c                            |     5 +
 net/ethtool/netlink.c                              |    21 +
 net/ethtool/netlink.h                              |     4 +
 net/ethtool/pse-pd.c                               |   185 +
 net/ethtool/strset.c                               |     2 +-
 net/ethtool/tunnels.c                              |     2 +
 net/hsr/hsr_netlink.c                              |     1 +
 net/ieee802154/netlink.c                           |     1 +
 net/ieee802154/nl802154.c                          |     1 +
 net/ieee802154/socket.c                            |     3 +
 net/ipv4/af_inet.c                                 |    35 +-
 net/ipv4/ah4.c                                     |    23 +-
 net/ipv4/arp.c                                     |     2 +-
 net/ipv4/bpf_tcp_ca.c                              |     2 +-
 net/ipv4/datagram.c                                |     2 +
 net/ipv4/esp4.c                                    |    58 +-
 net/ipv4/esp4_offload.c                            |     5 +-
 net/ipv4/fou.c                                     |    10 +-
 net/ipv4/gre_offload.c                             |     9 +-
 net/ipv4/igmp.c                                    |    22 +-
 net/ipv4/inet_connection_sock.c                    |   297 +-
 net/ipv4/inet_hashtables.c                         |   358 +-
 net/ipv4/inet_timewait_sock.c                      |     4 +-
 net/ipv4/ip_output.c                               |     7 +-
 net/ipv4/ip_sockglue.c                             |   114 +-
 net/ipv4/ip_tunnel_core.c                          |    67 +
 net/ipv4/ipcomp.c                                  |    10 +-
 net/ipv4/ipip.c                                    |    62 +-
 net/ipv4/ipmr.c                                    |     9 +-
 net/ipv4/netfilter/ipt_rpfilter.c                  |     1 -
 net/ipv4/netfilter/nf_nat_h323.c                   |    60 +-
 net/ipv4/netfilter/nf_socket_ipv4.c                |     4 +-
 net/ipv4/netfilter/nf_tproxy_ipv4.c                |    16 +-
 net/ipv4/netfilter/nft_fib_ipv4.c                  |     3 +
 net/ipv4/ping.c                                    |    15 +
 net/ipv4/proc.c                                    |     2 +-
 net/ipv4/sysctl_net_ipv4.c                         |    47 +-
 net/ipv4/tcp.c                                     |   151 +-
 net/ipv4/tcp_diag.c                                |    18 +-
 net/ipv4/tcp_fastopen.c                            |     3 +-
 net/ipv4/tcp_ipv4.c                                |   160 +-
 net/ipv4/tcp_metrics.c                             |     1 +
 net/ipv4/tcp_minisocks.c                           |    29 +-
 net/ipv4/tcp_offload.c                             |    26 +-
 net/ipv4/tcp_output.c                              |    19 +-
 net/ipv4/tcp_timer.c                               |     2 +-
 net/ipv4/udp.c                                     |    46 +-
 net/ipv4/xfrm4_tunnel.c                            |    10 +-
 net/ipv6/af_inet6.c                                |     2 +
 net/ipv6/ah6.c                                     |    23 +-
 net/ipv6/esp6.c                                    |    58 +-
 net/ipv6/esp6_offload.c                            |     5 +-
 net/ipv6/ila/ila_main.c                            |     1 +
 net/ipv6/inet6_hashtables.c                        |     4 +-
 net/ipv6/ioam6.c                                   |     1 +
 net/ipv6/ip6_gre.c                                 |     2 +-
 net/ipv6/ip6_offload.c                             |    11 +-
 net/ipv6/ip6_output.c                              |     7 +-
 net/ipv6/ip6_tunnel.c                              |    39 +-
 net/ipv6/ip6_vti.c                                 |     4 +-
 net/ipv6/ip6mr.c                                   |    10 +-
 net/ipv6/ipcomp6.c                                 |    10 +-
 net/ipv6/ipv6_sockglue.c                           |   113 +-
 net/ipv6/mcast.c                                   |     8 +-
 net/ipv6/mip6.c                                    |    14 +-
 net/ipv6/netfilter/nf_socket_ipv6.c                |     4 +-
 net/ipv6/netfilter/nf_tproxy_ipv6.c                |     8 +-
 net/ipv6/netfilter/nft_fib_ipv6.c                  |     6 +-
 net/ipv6/ping.c                                    |    16 +
 net/ipv6/seg6.c                                    |     1 +
 net/ipv6/seg6_local.c                              |   379 +-
 net/ipv6/sit.c                                     |    67 +-
 net/ipv6/tcp_ipv6.c                                |    82 +-
 net/ipv6/udp.c                                     |    22 +-
 net/ipv6/xfrm6_tunnel.c                            |    10 +-
 net/l2tp/l2tp_eth.c                                |     4 +-
 net/l2tp/l2tp_netlink.c                            |     1 +
 net/mac80211/Makefile                              |     1 +
 net/mac80211/cfg.c                                 |   136 +-
 net/mac80211/chan.c                                |     6 +
 net/mac80211/debugfs_netdev.c                      |    26 +
 net/mac80211/driver-ops.c                          |   172 +
 net/mac80211/driver-ops.h                          |   165 +-
 net/mac80211/eht.c                                 |     4 +-
 net/mac80211/ethtool.c                             |    10 +-
 net/mac80211/he.c                                  |    12 +-
 net/mac80211/ht.c                                  |    13 +-
 net/mac80211/ibss.c                                |     8 +-
 net/mac80211/ieee80211_i.h                         |    30 +-
 net/mac80211/iface.c                               |   330 +-
 net/mac80211/key.c                                 |   234 +-
 net/mac80211/key.h                                 |    16 +-
 net/mac80211/link.c                                |   473 +
 net/mac80211/main.c                                |     2 +
 net/mac80211/mesh.c                                |     2 +-
 net/mac80211/mlme.c                                |   234 +-
 net/mac80211/rc80211_minstrel_ht.c                 |     9 +-
 net/mac80211/rx.c                                  |   278 +-
 net/mac80211/scan.c                                |     2 +-
 net/mac80211/sta_info.c                            |   109 +-
 net/mac80211/sta_info.h                            |     3 +
 net/mac80211/tx.c                                  |   118 +-
 net/mac80211/util.c                                |    67 +-
 net/mac80211/vht.c                                 |     8 +-
 net/mptcp/mptcp_diag.c                             |     7 +-
 net/mptcp/pm_netlink.c                             |    23 +-
 net/mptcp/protocol.c                               |   161 +-
 net/mptcp/protocol.h                               |     2 +
 net/mptcp/sockopt.c                                |    19 +-
 net/ncsi/ncsi-netlink.c                            |     1 +
 net/netfilter/Makefile                             |     6 +
 net/netfilter/core.c                               |    10 -
 net/netfilter/ipset/ip_set_core.c                  |    12 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |     9 +-
 net/netfilter/nf_conntrack_bpf.c                   |    74 +-
 net/netfilter/nf_conntrack_core.c                  |    25 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |   321 +-
 net/netfilter/nf_log.c                             |     4 +-
 net/netfilter/nf_nat_amanda.c                      |    14 +-
 net/netfilter/nf_nat_bpf.c                         |    79 +
 net/netfilter/nf_nat_core.c                        |     4 +-
 net/netfilter/nf_nat_ftp.c                         |    17 +-
 net/netfilter/nf_nat_helper.c                      |    31 +
 net/netfilter/nf_nat_irc.c                         |    16 +-
 net/netfilter/nf_nat_sip.c                         |    14 +-
 net/netfilter/nf_tables_api.c                      |     2 +-
 net/netfilter/nfnetlink_hook.c                     |     7 -
 net/netfilter/nft_osf.c                            |     2 +-
 net/netfilter/nft_payload.c                        |     6 +-
 net/netfilter/x_tables.c                           |    20 +-
 net/netfilter/xt_RATEEST.c                         |     2 +-
 net/netlabel/netlabel_calipso.c                    |     1 +
 net/netlabel/netlabel_cipso_v4.c                   |     1 +
 net/netlabel/netlabel_mgmt.c                       |     1 +
 net/netlabel/netlabel_unlabeled.c                  |     1 +
 net/netlink/af_netlink.c                           |   105 +-
 net/netlink/genetlink.c                            |    38 +-
 net/nfc/hci/hcp.c                                  |    12 +-
 net/nfc/netlink.c                                  |     1 +
 net/openvswitch/conntrack.c                        |    14 +-
 net/openvswitch/datapath.c                         |    42 +-
 net/openvswitch/flow_netlink.c                     |     2 +-
 net/openvswitch/meter.c                            |    15 +-
 net/openvswitch/vport-internal_dev.c               |     5 +-
 net/openvswitch/vport.h                            |     4 +-
 net/packet/af_packet.c                             |    30 +-
 net/psample/psample.c                              |     1 +
 net/rds/af_rds.c                                   |     2 +-
 net/rds/message.c                                  |     2 +-
 net/rds/rdma_transport.c                           |     4 +-
 net/rds/tcp.c                                      |     4 +-
 net/rxrpc/ar-internal.h                            |     1 -
 net/sched/act_api.c                                |    33 +-
 net/sched/act_bpf.c                                |    30 +-
 net/sched/act_connmark.c                           |    28 +-
 net/sched/act_csum.c                               |    28 +-
 net/sched/act_ct.c                                 |    37 +-
 net/sched/act_ctinfo.c                             |    28 +-
 net/sched/act_gact.c                               |    28 +-
 net/sched/act_gate.c                               |    28 +-
 net/sched/act_ife.c                                |    28 +-
 net/sched/act_ipt.c                                |    61 +-
 net/sched/act_mirred.c                             |    31 +-
 net/sched/act_mpls.c                               |    28 +-
 net/sched/act_nat.c                                |    28 +-
 net/sched/act_pedit.c                              |    28 +-
 net/sched/act_police.c                             |    28 +-
 net/sched/act_sample.c                             |    28 +-
 net/sched/act_simple.c                             |    28 +-
 net/sched/act_skbedit.c                            |    28 +-
 net/sched/act_skbmod.c                             |    28 +-
 net/sched/act_tunnel_key.c                         |    28 +-
 net/sched/act_vlan.c                               |    28 +-
 net/sched/cls_api.c                                |    13 -
 net/sched/cls_basic.c                              |    16 +-
 net/sched/cls_bpf.c                                |    15 +-
 net/sched/cls_flow.c                               |     8 +-
 net/sched/cls_flower.c                             |    23 +-
 net/sched/cls_fw.c                                 |    16 +-
 net/sched/cls_matchall.c                           |    12 +-
 net/sched/cls_route.c                              |    20 +-
 net/sched/cls_rsvp.h                               |    16 +-
 net/sched/cls_tcindex.c                            |    25 +-
 net/sched/cls_u32.c                                |    33 +-
 net/sched/sch_api.c                                |    43 +-
 net/sched/sch_atm.c                                |     7 +-
 net/sched/sch_cake.c                               |    12 +-
 net/sched/sch_cbq.c                                |    10 +-
 net/sched/sch_cbs.c                                |     8 +-
 net/sched/sch_choke.c                              |     4 -
 net/sched/sch_codel.c                              |     3 -
 net/sched/sch_drr.c                                |    11 +-
 net/sched/sch_dsmark.c                             |    16 +-
 net/sched/sch_etf.c                                |     6 -
 net/sched/sch_ets.c                                |    16 +-
 net/sched/sch_fq.c                                 |     3 -
 net/sched/sch_fq_codel.c                           |    38 +-
 net/sched/sch_fq_pie.c                             |     6 -
 net/sched/sch_generic.c                            |     1 -
 net/sched/sch_gred.c                               |    13 +-
 net/sched/sch_hfsc.c                               |    13 +-
 net/sched/sch_hhf.c                                |     3 -
 net/sched/sch_htb.c                                |    49 +-
 net/sched/sch_mq.c                                 |     5 +-
 net/sched/sch_mqprio.c                             |     5 +-
 net/sched/sch_multiq.c                             |    10 +-
 net/sched/sch_netem.c                              |    11 +-
 net/sched/sch_pie.c                                |     3 -
 net/sched/sch_plug.c                               |     3 -
 net/sched/sch_prio.c                               |    13 +-
 net/sched/sch_qfq.c                                |    11 +-
 net/sched/sch_red.c                                |    13 +-
 net/sched/sch_sfb.c                                |     9 +-
 net/sched/sch_sfq.c                                |     8 +-
 net/sched/sch_skbprio.c                            |    12 +-
 net/sched/sch_taprio.c                             |   291 +-
 net/sched/sch_tbf.c                                |     9 +-
 net/sched/sch_teql.c                               |     3 +-
 net/sctp/auth.c                                    |    18 +-
 net/smc/af_smc.c                                   |     6 +-
 net/smc/smc_core.c                                 |     8 +-
 net/smc/smc_llc.c                                  |     2 +-
 net/smc/smc_llc.h                                  |     1 +
 net/smc/smc_netlink.c                              |     3 +-
 net/smc/smc_pnet.c                                 |     3 +-
 net/smc/smc_sysctl.c                               |    30 +
 net/tipc/name_distr.c                              |     8 -
 net/tipc/netlink.c                                 |     1 +
 net/tipc/netlink_compat.c                          |     1 +
 net/tls/tls_device.c                               |    61 +-
 net/tls/tls_device_fallback.c                      |    79 +-
 net/tls/tls_main.c                                 |    79 +
 net/tls/tls_sw.c                                   |    34 +
 net/unix/af_unix.c                                 |    83 +-
 net/vmw_vsock/af_vsock.c                           |    33 +-
 net/vmw_vsock/hyperv_transport.c                   |     7 +
 net/vmw_vsock/virtio_transport_common.c            |     9 +-
 net/vmw_vsock/vmci_transport.c                     |     2 +-
 net/vmw_vsock/vmci_transport_notify.c              |    10 +-
 net/vmw_vsock/vmci_transport_notify_qstate.c       |    12 +-
 net/wireless/core.c                                |    16 +
 net/wireless/ibss.c                                |     2 +-
 net/wireless/nl80211.c                             |   198 +-
 net/wireless/rdev-ops.h                            |    58 +-
 net/wireless/reg.c                                 |     4 +
 net/wireless/scan.c                                |     2 +-
 net/wireless/sme.c                                 |     5 +-
 net/wireless/trace.h                               |    97 +-
 net/wireless/util.c                                |     4 +-
 net/wireless/wext-compat.c                         |    18 +-
 net/xdp/xdp_umem.c                                 |     2 -
 net/xdp/xsk.c                                      |    26 +-
 net/xdp/xsk_buff_pool.c                            |     5 +-
 net/xdp/xsk_queue.h                                |    22 +-
 net/xfrm/espintcp.c                                |     2 +-
 net/xfrm/xfrm_device.c                             |    20 +-
 net/xfrm/xfrm_input.c                              |    25 +-
 net/xfrm/xfrm_interface.c                          |   206 +-
 net/xfrm/xfrm_ipcomp.c                             |    11 +-
 net/xfrm/xfrm_policy.c                             |    25 +-
 net/xfrm/xfrm_replay.c                             |    10 +-
 net/xfrm/xfrm_state.c                              |    30 +-
 net/xfrm/xfrm_user.c                               |   370 +-
 samples/bpf/map_perf_test_kern.c                   |    44 +-
 samples/bpf/map_perf_test_user.c                   |     2 +-
 samples/bpf/task_fd_query_kern.c                   |     2 +-
 samples/bpf/task_fd_query_user.c                   |     2 +-
 samples/bpf/tracex3_kern.c                         |     2 +-
 samples/bpf/xdp_router_ipv4_user.c                 |     2 +-
 scripts/bpf_doc.py                                 |    78 +-
 security/keys/internal.h                           |     2 -
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |     2 +-
 tools/bpf/bpftool/btf.c                            |    16 +-
 tools/bpf/bpftool/btf_dumper.c                     |     2 +-
 tools/bpf/bpftool/cgroup.c                         |    54 +-
 tools/bpf/bpftool/common.c                         |    15 +-
 tools/bpf/bpftool/feature.c                        |     2 +-
 tools/bpf/bpftool/gen.c                            |     4 +-
 tools/bpf/bpftool/link.c                           |    54 +
 tools/bpf/bpftool/main.c                           |    10 +
 tools/bpf/bpftool/map.c                            |     2 +-
 tools/bpf/bpftool/map_perf_ring.c                  |    14 +-
 tools/include/uapi/linux/bpf.h                     |   182 +-
 tools/include/uapi/linux/tc_act/tc_bpf.h           |     5 -
 tools/lib/bpf/bpf.c                                |   186 +-
 tools/lib/bpf/bpf_helpers.h                        |    12 -
 tools/lib/bpf/bpf_tracing.h                        |   121 +-
 tools/lib/bpf/btf.c                                |    34 +-
 tools/lib/bpf/btf.h                                |    26 +-
 tools/lib/bpf/btf_dump.c                           |     2 +-
 tools/lib/bpf/libbpf.c                             |   208 +-
 tools/lib/bpf/libbpf.h                             |   113 +-
 tools/lib/bpf/libbpf.map                           |    12 +
 tools/lib/bpf/libbpf_internal.h                    |     3 +
 tools/lib/bpf/libbpf_legacy.h                      |     2 +
 tools/lib/bpf/libbpf_probes.c                      |     3 +-
 tools/lib/bpf/libbpf_version.h                     |     2 +-
 tools/lib/bpf/netlink.c                            |     3 +-
 tools/lib/bpf/nlattr.c                             |     2 +-
 tools/lib/bpf/ringbuf.c                            |   271 +
 tools/lib/bpf/skel_internal.h                      |    33 +-
 tools/lib/bpf/usdt.bpf.h                           |     4 +-
 tools/lib/bpf/usdt.c                               |     2 +-
 tools/objtool/check.c                              |     3 +-
 tools/testing/selftests/bpf/.gitignore             |     2 +
 tools/testing/selftests/bpf/DENYLIST.s390x         |    11 +-
 tools/testing/selftests/bpf/Makefile               |    64 +-
 tools/testing/selftests/bpf/README.rst             |     8 +-
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        |    48 +
 .../selftests/bpf/cgroup_getset_retval_hooks.h     |    25 +
 tools/testing/selftests/bpf/cgroup_helpers.c       |   202 +-
 tools/testing/selftests/bpf/cgroup_helpers.h       |    19 +-
 tools/testing/selftests/bpf/config                 |    35 +-
 tools/testing/selftests/bpf/config.x86_64          |     7 +-
 tools/testing/selftests/bpf/get_cgroup_id_user.c   |     2 +-
 .../selftests/bpf/map_tests/array_map_batch_ops.c  |     2 +
 .../selftests/bpf/map_tests/htab_map_batch_ops.c   |     2 +
 .../bpf/map_tests/lpm_trie_map_batch_ops.c         |     2 +
 .../selftests/bpf/map_tests/task_storage_map.c     |   127 +
 .../selftests/bpf/prog_tests/attach_probe.c        |     6 +-
 .../testing/selftests/bpf/prog_tests/autoattach.c  |    30 +
 .../testing/selftests/bpf/prog_tests/bpf_cookie.c  |     2 +-
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |   282 +-
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c    |    71 +-
 .../testing/selftests/bpf/prog_tests/bpf_obj_id.c  |     2 +-
 .../testing/selftests/bpf/prog_tests/bpf_tcp_ca.c  |     4 +
 .../selftests/bpf/prog_tests/bpf_verif_scale.c     |    54 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       |     4 +-
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  |    10 +-
 .../testing/selftests/bpf/prog_tests/btf_endian.c  |     2 +-
 .../selftests/bpf/prog_tests/btf_skc_cls_ingress.c |    20 -
 tools/testing/selftests/bpf/prog_tests/cb_refs.c   |    48 +
 .../bpf/prog_tests/cgroup_getset_retval.c          |    48 +
 .../bpf/prog_tests/cgroup_hierarchical_stats.c     |   339 +
 .../testing/selftests/bpf/prog_tests/cgroup_iter.c |   224 +
 .../testing/selftests/bpf/prog_tests/cgroup_link.c |    11 +-
 .../selftests/bpf/prog_tests/connect_force_port.c  |     2 +-
 .../selftests/bpf/prog_tests/connect_ping.c        |   178 +
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |    74 +-
 tools/testing/selftests/bpf/prog_tests/dynptr.c    |     5 +-
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |    44 +-
 .../selftests/bpf/prog_tests/flow_dissector.c      |    44 +-
 .../bpf/prog_tests/flow_dissector_load_bytes.c     |     2 +-
 .../selftests/bpf/prog_tests/get_func_ip_test.c    |    59 +-
 .../selftests/bpf/prog_tests/get_stack_raw_tp.c    |     4 +-
 .../testing/selftests/bpf/prog_tests/global_data.c |     2 +-
 .../selftests/bpf/prog_tests/global_data_init.c    |     2 +-
 .../selftests/bpf/prog_tests/global_func_args.c    |     2 +-
 .../testing/selftests/bpf/prog_tests/htab_update.c |   126 +
 tools/testing/selftests/bpf/prog_tests/kfree_skb.c |     2 +-
 .../testing/selftests/bpf/prog_tests/kfunc_call.c  |   263 +-
 .../selftests/bpf/prog_tests/kfunc_dynptr_param.c  |   164 +
 tools/testing/selftests/bpf/prog_tests/l4lb_all.c  |     4 +-
 .../selftests/bpf/prog_tests/load_bytes_relative.c |     4 +-
 .../testing/selftests/bpf/prog_tests/lookup_key.c  |   112 +
 tools/testing/selftests/bpf/prog_tests/map_lock.c  |     2 +-
 tools/testing/selftests/bpf/prog_tests/pinning.c   |     4 +-
 .../testing/selftests/bpf/prog_tests/pkt_access.c  |     2 +-
 .../selftests/bpf/prog_tests/pkt_md_access.c       |     2 +-
 .../testing/selftests/bpf/prog_tests/probe_user.c  |     2 +-
 .../selftests/bpf/prog_tests/queue_stack_map.c     |     4 +-
 .../testing/selftests/bpf/prog_tests/rdonly_maps.c |     2 +-
 .../selftests/bpf/prog_tests/reference_tracking.c  |     2 +-
 .../selftests/bpf/prog_tests/resolve_btfids.c      |     2 +-
 .../selftests/bpf/prog_tests/select_reuseport.c    |     4 +-
 .../selftests/bpf/prog_tests/setget_sockopt.c      |   125 +
 tools/testing/selftests/bpf/prog_tests/sk_assign.c |     2 +-
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c   |     2 +-
 .../testing/selftests/bpf/prog_tests/skb_helpers.c |     2 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c       |    87 +-
 .../selftests/bpf/prog_tests/sockmap_ktls.c        |    39 +-
 tools/testing/selftests/bpf/prog_tests/sockopt.c   |     4 +-
 .../selftests/bpf/prog_tests/sockopt_inherit.c     |    32 +-
 .../selftests/bpf/prog_tests/sockopt_multi.c       |    12 +-
 .../testing/selftests/bpf/prog_tests/sockopt_sk.c  |     2 +-
 tools/testing/selftests/bpf/prog_tests/spinlock.c  |     2 +-
 .../selftests/bpf/prog_tests/stacktrace_map.c      |     2 +-
 .../bpf/prog_tests/stacktrace_map_raw_tp.c         |     2 +-
 tools/testing/selftests/bpf/prog_tests/tailcalls.c |    36 +-
 .../selftests/bpf/prog_tests/task_fd_query_rawtp.c |     2 +-
 .../selftests/bpf/prog_tests/task_fd_query_tp.c    |     2 +-
 .../selftests/bpf/prog_tests/task_pt_regs.c        |     2 +-
 .../testing/selftests/bpf/prog_tests/tcp_estats.c  |     6 +-
 .../selftests/bpf/prog_tests/tcp_hdr_options.c     |   100 +-
 tools/testing/selftests/bpf/prog_tests/tcp_rtt.c   |    13 +-
 .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |    32 +-
 .../selftests/bpf/prog_tests/test_bprm_opts.c      |    10 +-
 .../selftests/bpf/prog_tests/test_global_funcs.c   |    34 +-
 .../selftests/bpf/prog_tests/test_local_storage.c  |    10 +-
 .../selftests/bpf/prog_tests/test_overhead.c       |     2 +-
 tools/testing/selftests/bpf/prog_tests/time_tai.c  |    74 +
 .../selftests/bpf/prog_tests/tp_attach_query.c     |     2 +-
 .../selftests/bpf/prog_tests/tracing_struct.c      |    63 +
 .../selftests/bpf/prog_tests/trampoline_count.c    |     2 +-
 tools/testing/selftests/bpf/prog_tests/udp_limit.c |    18 +-
 .../selftests/bpf/prog_tests/user_ringbuf.c        |   754 +
 .../selftests/bpf/prog_tests/verify_pkcs7_sig.c    |   399 +
 tools/testing/selftests/bpf/prog_tests/xdp.c       |     2 +-
 .../selftests/bpf/prog_tests/xdp_adjust_frags.c    |     2 +-
 .../selftests/bpf/prog_tests/xdp_adjust_tail.c     |    10 +-
 .../testing/selftests/bpf/prog_tests/xdp_attach.c  |     2 +-
 tools/testing/selftests/bpf/prog_tests/xdp_info.c  |     2 +-
 tools/testing/selftests/bpf/prog_tests/xdp_perf.c  |     2 +-
 .../selftests/bpf/prog_tests/xdp_synproxy.c        |     2 +-
 tools/testing/selftests/bpf/progs/bind4_prog.c     |     2 -
 tools/testing/selftests/bpf/progs/bind6_prog.c     |     2 -
 tools/testing/selftests/bpf/progs/bpf_dctcp.c      |    25 +-
 tools/testing/selftests/bpf/progs/bpf_flow.c       |    15 +
 tools/testing/selftests/bpf/progs/bpf_iter.h       |     7 +
 tools/testing/selftests/bpf/progs/bpf_iter_task.c  |     9 +
 .../selftests/bpf/progs/bpf_iter_task_file.c       |     9 +-
 .../selftests/bpf/progs/bpf_iter_task_vma.c        |     7 +-
 .../selftests/bpf/progs/bpf_iter_vma_offset.c      |    37 +
 .../testing/selftests/bpf/progs/bpf_tracing_net.h  |    32 +-
 tools/testing/selftests/bpf/progs/cb_refs.c        |   116 +
 .../bpf/progs/cgroup_getset_retval_hooks.c         |    16 +
 .../bpf/progs/cgroup_hierarchical_stats.c          |   155 +
 tools/testing/selftests/bpf/progs/cgroup_iter.c    |    39 +
 tools/testing/selftests/bpf/progs/connect4_prog.c  |     5 +-
 tools/testing/selftests/bpf/progs/connect_ping.c   |    53 +
 tools/testing/selftests/bpf/progs/dynptr_fail.c    |    94 +-
 tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c  |     8 +-
 .../testing/selftests/bpf/progs/get_func_ip_test.c |    25 +-
 tools/testing/selftests/bpf/progs/htab_update.c    |    29 +
 .../selftests/bpf/progs/kfunc_call_destructive.c   |    14 +
 .../testing/selftests/bpf/progs/kfunc_call_fail.c  |   160 +
 .../testing/selftests/bpf/progs/kfunc_call_test.c  |    71 +
 tools/testing/selftests/bpf/progs/kprobe_multi.c   |     4 +-
 tools/testing/selftests/bpf/progs/lsm.c            |     3 +-
 .../bpf/progs/read_bpf_task_storage_busy.c         |    39 +
 tools/testing/selftests/bpf/progs/setget_sockopt.c |   395 +
 .../selftests/bpf/progs/tailcall_bpf2bpf4.c        |     2 +-
 .../testing/selftests/bpf/progs/test_autoattach.c  |    23 +
 .../testing/selftests/bpf/progs/test_bpf_cookie.c  |     4 +-
 tools/testing/selftests/bpf/progs/test_bpf_nf.c    |    60 +-
 .../testing/selftests/bpf/progs/test_bpf_nf_fail.c |    14 +
 .../selftests/bpf/progs/test_helper_restricted.c   |     4 +-
 .../selftests/bpf/progs/test_kfunc_dynptr_param.c  |    94 +
 .../testing/selftests/bpf/progs/test_lookup_key.c  |    46 +
 tools/testing/selftests/bpf/progs/test_tc_dtime.c  |     1 -
 tools/testing/selftests/bpf/progs/test_time_tai.c  |    24 +
 .../testing/selftests/bpf/progs/test_tunnel_kern.c |    24 +-
 .../selftests/bpf/progs/test_user_ringbuf.h        |    35 +
 .../selftests/bpf/progs/test_verif_scale1.c        |     2 +-
 .../selftests/bpf/progs/test_verif_scale3.c        |     2 +-
 .../selftests/bpf/progs/test_verify_pkcs7_sig.c    |    90 +
 tools/testing/selftests/bpf/progs/timer.c          |    15 +-
 tools/testing/selftests/bpf/progs/tracing_struct.c |   120 +
 .../selftests/bpf/progs/user_ringbuf_fail.c        |   177 +
 .../selftests/bpf/progs/user_ringbuf_success.c     |   218 +
 .../selftests/bpf/task_local_storage_helpers.h     |    18 +
 tools/testing/selftests/bpf/test_dev_cgroup.c      |     2 +-
 tools/testing/selftests/bpf/test_flow_dissector.sh |     8 +
 tools/testing/selftests/bpf/test_kmod.sh           |    20 +-
 tools/testing/selftests/bpf/test_lirc_mode2_user.c |     2 +-
 tools/testing/selftests/bpf/test_maps.c            |    74 +-
 tools/testing/selftests/bpf/test_maps.h            |     2 +
 tools/testing/selftests/bpf/test_offload.py        |    22 +-
 tools/testing/selftests/bpf/test_progs.c           |    17 +
 tools/testing/selftests/bpf/test_progs.h           |     1 +
 tools/testing/selftests/bpf/test_skb_cgroup_id.sh  |     2 +-
 tools/testing/selftests/bpf/test_sock_addr.c       |    16 +-
 tools/testing/selftests/bpf/test_sockmap.c         |    46 +-
 tools/testing/selftests/bpf/test_sysctl.c          |     6 +-
 .../selftests/bpf/test_tcp_check_syncookie.sh      |     2 +-
 tools/testing/selftests/bpf/test_tcpnotify_user.c  |     2 +-
 tools/testing/selftests/bpf/test_verifier.c        |     3 +-
 tools/testing/selftests/bpf/test_xdp_redirect.sh   |     8 +-
 .../selftests/bpf/test_xdp_redirect_multi.sh       |     2 +-
 tools/testing/selftests/bpf/test_xdp_veth.sh       |     8 +-
 tools/testing/selftests/bpf/test_xsk.sh            |    52 +-
 tools/testing/selftests/bpf/verifier/calls.c       |     2 +-
 .../testing/selftests/bpf/verifier/ref_tracking.c  |   139 +
 tools/testing/selftests/bpf/verifier/var_off.c     |     2 +-
 tools/testing/selftests/bpf/verify_sig_setup.sh    |   104 +
 tools/testing/selftests/bpf/veristat.c             |  1322 +
 tools/testing/selftests/bpf/veristat.cfg           |    17 +
 tools/testing/selftests/bpf/vmtest.sh              |    34 +-
 tools/testing/selftests/bpf/xdp_redirect_multi.c   |     2 +-
 tools/testing/selftests/bpf/xdp_synproxy.c         |     2 +-
 tools/testing/selftests/bpf/xdping.c               |     2 +-
 tools/testing/selftests/bpf/xsk.c                  |     6 +-
 tools/testing/selftests/bpf/xskxceiver.c           |   561 +-
 tools/testing/selftests/bpf/xskxceiver.h           |    19 +-
 .../testing/selftests/drivers/net/bonding/Makefile |     8 +-
 .../drivers/net/bonding/bond-lladdr-target.sh      |    65 +
 tools/testing/selftests/drivers/net/dsa/Makefile   |     3 +-
 .../selftests/drivers/net/dsa/tc_actions.sh        |     1 +
 .../testing/selftests/drivers/net/dsa/tc_common.sh |     1 +
 .../drivers/net/mlxsw/egress_vid_classification.sh |   273 +
 .../drivers/net/mlxsw/ingress_rif_conf_1d.sh       |   264 +
 .../drivers/net/mlxsw/ingress_rif_conf_1q.sh       |   264 +
 .../drivers/net/mlxsw/ingress_rif_conf_vxlan.sh    |   311 +
 .../selftests/drivers/net/mlxsw/mlxsw_lib.sh       |    14 +
 .../selftests/drivers/net/mlxsw/qos_burst.sh       |   480 -
 .../selftests/drivers/net/mlxsw/qos_ets_strict.sh  |     5 +-
 .../drivers/net/mlxsw/qos_max_descriptors.sh       |   282 +
 .../selftests/drivers/net/mlxsw/qos_mc_aware.sh    |     9 +-
 .../testing/selftests/drivers/net/mlxsw/sch_ets.sh |    15 +-
 .../selftests/drivers/net/mlxsw/sch_red_core.sh    |    23 +-
 .../selftests/drivers/net/mlxsw/sch_red_ets.sh     |     4 +-
 .../selftests/drivers/net/mlxsw/sch_red_root.sh    |     4 +-
 tools/testing/selftests/drivers/net/ocelot/psfp.sh |     2 +-
 tools/testing/selftests/net/.gitignore             |     3 +
 tools/testing/selftests/net/Makefile               |     8 +
 tools/testing/selftests/net/bind_bhash.c           |   144 +
 tools/testing/selftests/net/bind_bhash.sh          |    66 +
 tools/testing/selftests/net/fcnal-test.sh          |    30 +
 .../selftests/net/forwarding/devlink_lib.sh        |     5 +
 tools/testing/selftests/net/forwarding/tsn_lib.sh  |    52 +-
 tools/testing/selftests/net/ipsec.c                |   104 +-
 tools/testing/selftests/net/l2_tos_ttl_inherit.sh  |   390 +
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |    65 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   100 +-
 tools/testing/selftests/net/nettest.c              |    16 +-
 .../testing/selftests/net/sk_bind_sendto_listen.c  |    80 +
 tools/testing/selftests/net/sk_connect_zero_addr.c |    62 +
 .../selftests/net/srv6_end_next_csid_l3vpn_test.sh |  1145 +
 tools/testing/selftests/tc-testing/config          |    40 +-
 .../tc-testing/tc-tests/actions/connmark.json      |    50 +
 .../tc-testing/tc-tests/actions/ctinfo.json        |   316 +
 .../tc-testing/tc-tests/actions/gate.json          |   315 +
 .../selftests/tc-testing/tc-tests/actions/ife.json |    50 +
 .../selftests/tc-testing/tc-tests/actions/nat.json |    50 +
 .../tc-testing/tc-tests/actions/sample.json        |    50 +
 .../tc-testing/tc-tests/actions/tunnel_key.json    |    50 +
 .../selftests/tc-testing/tc-tests/actions/xt.json  |   219 +
 .../tc-testing/tc-tests/filters/basic.json         |    47 +
 .../selftests/tc-testing/tc-tests/filters/bpf.json |   171 +
 .../tc-testing/tc-tests/filters/cgroup.json        |  1236 +
 .../tc-testing/tc-tests/filters/flow.json          |   623 +
 .../tc-testing/tc-tests/filters/route.json         |   181 +
 .../tc-testing/tc-tests/filters/rsvp.json          |   203 +
 .../tc-testing/tc-tests/filters/tcindex.json       |   227 +
 .../selftests/tc-testing/tc-tests/qdiscs/atm.json  |    94 +
 .../selftests/tc-testing/tc-tests/qdiscs/cake.json |   487 +
 .../selftests/tc-testing/tc-tests/qdiscs/cbq.json  |   184 +
 .../selftests/tc-testing/tc-tests/qdiscs/cbs.json  |   234 +
 .../tc-testing/tc-tests/qdiscs/choke.json          |   188 +
 .../tc-testing/tc-tests/qdiscs/codel.json          |   211 +
 .../selftests/tc-testing/tc-tests/qdiscs/drr.json  |    71 +
 .../tc-testing/tc-tests/qdiscs/dsmark.json         |   140 +
 .../selftests/tc-testing/tc-tests/qdiscs/etf.json  |   117 +
 .../selftests/tc-testing/tc-tests/qdiscs/fq.json   |   395 +
 .../tc-testing/tc-tests/qdiscs/fq_codel.json       |   326 +
 .../selftests/tc-testing/tc-tests/qdiscs/gred.json |   164 +
 .../selftests/tc-testing/tc-tests/qdiscs/hfsc.json |   167 +
 .../selftests/tc-testing/tc-tests/qdiscs/hhf.json  |   210 +
 .../selftests/tc-testing/tc-tests/qdiscs/htb.json  |   285 +
 .../tc-testing/tc-tests/qdiscs/ingress.json        |    20 +
 .../selftests/tc-testing/tc-tests/qdiscs/mq.json   |    24 +-
 .../tc-testing/tc-tests/qdiscs/mqprio.json         |   114 +
 .../tc-testing/tc-tests/qdiscs/multiq.json         |   114 +
 .../tc-testing/tc-tests/qdiscs/netem.json          |   372 +
 .../tc-testing/tc-tests/qdiscs/pfifo_fast.json     |   119 +
 .../selftests/tc-testing/tc-tests/qdiscs/plug.json |   188 +
 .../selftests/tc-testing/tc-tests/qdiscs/prio.json |    20 +
 .../selftests/tc-testing/tc-tests/qdiscs/qfq.json  |   145 +
 .../selftests/tc-testing/tc-tests/qdiscs/red.json  |    23 +
 .../selftests/tc-testing/tc-tests/qdiscs/sfb.json  |   279 +
 .../selftests/tc-testing/tc-tests/qdiscs/sfq.json  |   232 +
 .../tc-testing/tc-tests/qdiscs/skbprio.json        |    95 +
 .../tc-testing/tc-tests/qdiscs/taprio.json         |   135 +
 .../selftests/tc-testing/tc-tests/qdiscs/tbf.json  |   211 +
 .../selftests/tc-testing/tc-tests/qdiscs/teql.json |    97 +
 tools/testing/vsock/vsock_test.c                   |   108 +
 2136 files changed, 127127 insertions(+), 50379 deletions(-)
 create mode 100644 Documentation/bpf/clang-notes.rst
 create mode 100644 Documentation/bpf/linux-notes.rst
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wed-pcie.yaml
 create mode 100644 Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml
 create mode 100644 Documentation/devicetree/bindings/net/adi,adin1110.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/altera_tse.txt
 create mode 100644 Documentation/devicetree/bindings/net/altr,tse.yaml
 create mode 100644 Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/ocelot.txt
 create mode 100644 Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/mediatek,mt7620-gsw.txt
 create mode 100644 Documentation/devicetree/bindings/net/pse-pd/podl-pse-regulator.yaml
 create mode 100644 Documentation/devicetree/bindings/net/pse-pd/pse-controller.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/ralink,rt2880-net.txt
 delete mode 100644 Documentation/devicetree/bindings/net/ralink,rt3050-esw.txt
 delete mode 100644 Documentation/networking/decnet.rst
 create mode 100644 Documentation/networking/device_drivers/ethernet/wangxun/ngbe.rst
 create mode 100644 Documentation/networking/representors.rst
 create mode 100644 Documentation/userspace-api/netlink/index.rst
 create mode 100644 Documentation/userspace-api/netlink/intro.rst
 create mode 100644 drivers/mfd/ocelot-core.c
 create mode 100644 drivers/mfd/ocelot-spi.c
 create mode 100644 drivers/mfd/ocelot.h
 create mode 100644 drivers/net/ethernet/adi/Kconfig
 create mode 100644 drivers/net/ethernet/adi/Makefile
 create mode 100644 drivers/net/ethernet/adi/adin1110.c
 create mode 100644 drivers/net/ethernet/engleder/tsnep_rxnfc.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/mcs.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/mcs.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/mcs_cnf10kb.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_matchall.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_matchall.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/fs_ethtool.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_stats.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_cbs.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_ets.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_mirror.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_mqprio.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_police.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_taprio.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_tbf.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_tc.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_tc_matchall.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_qos.h
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_tc.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_tc.h
 create mode 100644 drivers/net/ethernet/mscc/ocelot_stats.c
 create mode 100644 drivers/net/ethernet/sfc/tc_bindings.c
 create mode 100644 drivers/net/ethernet/sfc/tc_bindings.h
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/Makefile
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe.h
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
 create mode 100644 drivers/net/ipa/reg/ipa_reg-v3.1.c
 create mode 100644 drivers/net/ipa/reg/ipa_reg-v3.5.1.c
 create mode 100644 drivers/net/ipa/reg/ipa_reg-v4.11.c
 create mode 100644 drivers/net/ipa/reg/ipa_reg-v4.2.c
 create mode 100644 drivers/net/ipa/reg/ipa_reg-v4.5.c
 create mode 100644 drivers/net/ipa/reg/ipa_reg-v4.9.c
 create mode 100644 drivers/net/pcs/pcs-altera-tse.c
 create mode 100644 drivers/net/pse-pd/Kconfig
 create mode 100644 drivers/net/pse-pd/Makefile
 create mode 100644 drivers/net/pse-pd/pse_core.c
 create mode 100644 drivers/net/pse-pd/pse_regulator.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/chan.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/chan.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852b.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852be.c
 create mode 100644 include/linux/bpf_mem_alloc.h
 create mode 100644 include/linux/mfd/ocelot.h
 create mode 100644 include/linux/pcs-altera-tse.h
 create mode 100644 include/linux/pse-pd/pse.h
 delete mode 100644 include/net/dn.h
 delete mode 100644 include/net/dn_dev.h
 delete mode 100644 include/net/dn_fib.h
 delete mode 100644 include/net/dn_neigh.h
 delete mode 100644 include/net/dn_nsp.h
 delete mode 100644 include/net/dn_route.h
 delete mode 100644 include/uapi/linux/dn.h
 delete mode 100644 include/uapi/linux/netfilter_decnet.h
 create mode 100644 kernel/bpf/cgroup_iter.c
 create mode 100644 kernel/bpf/memalloc.c
 delete mode 100644 net/decnet/Kconfig
 delete mode 100644 net/decnet/Makefile
 delete mode 100644 net/decnet/README
 delete mode 100644 net/decnet/af_decnet.c
 delete mode 100644 net/decnet/dn_dev.c
 delete mode 100644 net/decnet/dn_fib.c
 delete mode 100644 net/decnet/dn_neigh.c
 delete mode 100644 net/decnet/dn_nsp_in.c
 delete mode 100644 net/decnet/dn_nsp_out.c
 delete mode 100644 net/decnet/dn_route.c
 delete mode 100644 net/decnet/dn_rules.c
 delete mode 100644 net/decnet/dn_table.c
 delete mode 100644 net/decnet/dn_timer.c
 delete mode 100644 net/decnet/netfilter/Kconfig
 delete mode 100644 net/decnet/netfilter/Makefile
 delete mode 100644 net/decnet/netfilter/dn_rtmsg.c
 delete mode 100644 net/decnet/sysctl_net_decnet.c
 create mode 100644 net/dsa/netlink.c
 create mode 100644 net/ethtool/pse-pd.c
 create mode 100644 net/mac80211/link.c
 create mode 100644 net/netfilter/nf_nat_bpf.c
 create mode 100644 tools/testing/selftests/bpf/cgroup_getset_retval_hooks.h
 create mode 100644 tools/testing/selftests/bpf/map_tests/task_storage_map.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/autoattach.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cb_refs.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_hierarchical_stats.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/connect_ping.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/htab_update.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/kfunc_dynptr_param.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/lookup_key.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/setget_sockopt.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/time_tai.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tracing_struct.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/user_ringbuf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/verify_pkcs7_sig.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_vma_offset.c
 create mode 100644 tools/testing/selftests/bpf/progs/cb_refs.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_getset_retval_hooks.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_hierarchical_stats.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter.c
 create mode 100644 tools/testing/selftests/bpf/progs/connect_ping.c
 create mode 100644 tools/testing/selftests/bpf/progs/htab_update.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_destructive.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_fail.c
 create mode 100644 tools/testing/selftests/bpf/progs/read_bpf_task_storage_busy.c
 create mode 100644 tools/testing/selftests/bpf/progs/setget_sockopt.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_autoattach.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_kfunc_dynptr_param.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_lookup_key.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_time_tai.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_user_ringbuf.h
 create mode 100644 tools/testing/selftests/bpf/progs/test_verify_pkcs7_sig.c
 create mode 100644 tools/testing/selftests/bpf/progs/tracing_struct.c
 create mode 100644 tools/testing/selftests/bpf/progs/user_ringbuf_fail.c
 create mode 100644 tools/testing/selftests/bpf/progs/user_ringbuf_success.c
 create mode 100644 tools/testing/selftests/bpf/task_local_storage_helpers.h
 create mode 100755 tools/testing/selftests/bpf/verify_sig_setup.sh
 create mode 100644 tools/testing/selftests/bpf/veristat.c
 create mode 100644 tools/testing/selftests/bpf/veristat.cfg
 create mode 100755 tools/testing/selftests/drivers/net/bonding/bond-lladdr-target.sh
 create mode 120000 tools/testing/selftests/drivers/net/dsa/tc_actions.sh
 create mode 120000 tools/testing/selftests/drivers/net/dsa/tc_common.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/egress_vid_classification.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/ingress_rif_conf_1d.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/ingress_rif_conf_1q.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/ingress_rif_conf_vxlan.sh
 delete mode 100755 tools/testing/selftests/drivers/net/mlxsw/qos_burst.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/qos_max_descriptors.sh
 create mode 100644 tools/testing/selftests/net/bind_bhash.c
 create mode 100755 tools/testing/selftests/net/bind_bhash.sh
 create mode 100755 tools/testing/selftests/net/l2_tos_ttl_inherit.sh
 create mode 100644 tools/testing/selftests/net/sk_bind_sendto_listen.c
 create mode 100644 tools/testing/selftests/net/sk_connect_zero_addr.c
 create mode 100755 tools/testing/selftests/net/srv6_end_next_csid_l3vpn_test.sh
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/ctinfo.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/gate.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/actions/xt.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/bpf.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/cgroup.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/flow.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/route.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/rsvp.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/filters/tcindex.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/atm.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/cake.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/cbq.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/cbs.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/choke.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/codel.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/drr.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/dsmark.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/etf.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq_codel.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/gred.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/hfsc.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/hhf.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/htb.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/mqprio.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/multiq.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/netem.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/pfifo_fast.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/plug.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/qfq.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/sfb.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/sfq.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/skbprio.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/taprio.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/tbf.json
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/qdiscs/teql.json
