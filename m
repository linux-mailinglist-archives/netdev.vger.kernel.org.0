Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEFF4E581F
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 19:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238740AbiCWSJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 14:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235363AbiCWSJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 14:09:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439C6888F9;
        Wed, 23 Mar 2022 11:07:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65FCF61358;
        Wed, 23 Mar 2022 18:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A96C340EE;
        Wed, 23 Mar 2022 18:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648058859;
        bh=XGWLdYgv/evIgfQSuyjdaBUe2+1zBHPTeiCJ5wvG0/8=;
        h=From:To:Cc:Subject:Date:From;
        b=unLqlUyydQWgssG8GgxYRmupjN0lwFgeUJPDQUorl+P8zUEdTqogr+ra5c6AozOA6
         dW2nyA4HZiCNtelOwmyk9mfO9aUhQkNLN7rwvXIuJbp6hEK6O0LhtqKXF11LPMivCY
         SugC/8BjitSCdmmIivpFx0gLsrmHlBWGMXSHQhSNlkiofwerDUXElcVDH6zMv+Uxvw
         3EFdqJ95n1Hb5khy8Vrmn9tdcreJCmp2YaZPi8iT49AnXoSIN2sDiDZDjm3ctuZKh0
         43Gnosp6pK4mQ1YTSd1Ot/x+Ipz++NAHPWZ+vDWYK/3RoDCXsZRP28ypU6aoAB1x+O
         RcSqYaE6xiY2Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 5.18
Date:   Wed, 23 Mar 2022 11:07:38 -0700
Message-Id: <20220323180738.3978487-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

The sprinkling of SPI drivers is because we added a new one and
Mark sent us a SPI driver interface conversion PR.

The following changes since commit 551acdc3c3d2b6bc97f11e31dcf960bc36343bfc:

  Merge tag 'net-5.17-final' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-03-17 12:55:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git net-next-5.18

for you to fetch changes up to 89695196f0ba78a17453f9616355f2ca6b293402:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-03-23 10:53:49 -0700)

----------------------------------------------------------------
Networking changes for 5.18.

Core
----

 - Introduce XDP multi-buffer support, allowing the use of XDP with
   jumbo frame MTUs and combination with Rx coalescing offloads (LRO).

 - Speed up netns dismantling (5x) and lower the memory cost a little.
   Remove unnecessary per-netns sockets. Scope some lists to a netns.
   Cut down RCU syncing. Use batch methods. Allow netdev registration
   to complete out of order.

 - Support distinguishing timestamp types (ingress vs egress) and
   maintaining them across packet scrubbing points (e.g. redirect).

 - Continue the work of annotating packet drop reasons throughout
   the stack.

 - Switch netdev error counters from an atomic to dynamically
   allocated per-CPU counters.

 - Rework a few preempt_disable(), local_irq_save() and busy waiting
   sections problematic on PREEMPT_RT.

 - Extend the ref_tracker to allow catching use-after-free bugs.

BPF
---

 - Introduce "packing allocator" for BPF JIT images. JITed code is
   marked read only, and used to be allocated at page granularity.
   Custom allocator allows for more efficient memory use, lower
   iTLB pressure and prevents identity mapping huge pages from
   getting split.

 - Make use of BTF type annotations (e.g. __user, __percpu) to enforce
   the correct probe read access method, add appropriate helpers.

 - Convert the BPF preload to use light skeleton and drop
   the user-mode-driver dependency.

 - Allow XDP BPF_PROG_RUN test infra to send real packets, enabling
   its use as a packet generator.

 - Allow local storage memory to be allocated with GFP_KERNEL if called
   from a hook allowed to sleep.

 - Introduce fprobe (multi kprobe) to speed up mass attachment (arch
   bits to come later).

 - Add unstable conntrack lookup helpers for BPF by using the BPF
   kfunc infra.

 - Allow cgroup BPF progs to return custom errors to user space.

 - Add support for AF_UNIX iterator batching.

 - Allow iterator programs to use sleepable helpers.

 - Support JIT of add, and, or, xor and xchg atomic ops on arm64.

 - Add BTFGen support to bpftool which allows to use CO-RE in kernels
   without BTF info.

 - Large number of libbpf API improvements, cleanups and deprecations.

Protocols
---------

 - Micro-optimize UDPv6 Tx, gaining up to 5% in test on dummy netdev.

 - Adjust TSO packet sizes based on min_rtt, allowing very low latency
   links (data centers) to always send full-sized TSO super-frames.

 - Make IPv6 flow label changes (AKA hash rethink) more configurable,
   via sysctl and setsockopt. Distinguish between server and client
   behavior.

 - VxLAN support to "collect metadata" devices to terminate only
   configured VNIs. This is similar to VLAN filtering in the bridge.

 - Support inserting IPv6 IOAM information to a fraction of frames.

 - Add protocol attribute to IP addresses to allow identifying where
   given address comes from (kernel-generated, DHCP etc.)

 - Support setting socket and IPv6 options via cmsg on ping6 sockets.

 - Reject mis-use of ECN bits in IP headers as part of DSCP/TOS.
   Define dscp_t and stop taking ECN bits into account in fib-rules.

 - Add support for locked bridge ports (for 802.1X).

 - tun: support NAPI for packets received from batched XDP buffs,
   doubling the performance in some scenarios.

 - IPv6 extension header handling in Open vSwitch.

 - Support IPv6 control message load balancing in bonding, prevent
   neighbor solicitation and advertisement from using the wrong port.
   Support NS/NA monitor selection similar to existing ARP monitor.

 - SMC
   - improve performance with TCP_CORK and sendfile()
   - support auto-corking
   - support TCP_NODELAY

 - MCTP (Management Component Transport Protocol)
   - add user space tag control interface
   - I2C binding driver (as specified by DMTF DSP0237)

 - Multi-BSSID beacon handling in AP mode for WiFi.

 - Bluetooth:
   - handle MSFT Monitor Device Event
   - add MGMT Adv Monitor Device Found/Lost events

 - Multi-Path TCP:
   - add support for the SO_SNDTIMEO socket option
   - lots of selftest cleanups and improvements

 - Increase the max PDU size in CAN ISOTP to 64 kB.

Driver API
----------

 - Add HW counters for SW netdevs, a mechanism for devices which
   offload packet forwarding to report packet statistics back to
   software interfaces such as tunnels.

 - Select the default NIC queue count as a fraction of number of
   physical CPU cores, instead of hard-coding to 8.

 - Expose devlink instance locks to drivers. Allow device layer of
   drivers to use that lock directly instead of creating their own
   which always runs into ordering issues in devlink callbacks.

 - Add header/data split indication to guide user space enabling
   of TCP zero-copy Rx.

 - Allow configuring completion queue event size.

 - Refactor page_pool to enable fragmenting after allocation.

 - Add allocation and page reuse statistics to page_pool.

 - Improve Multiple Spanning Trees support in the bridge to allow
   reuse of topologies across VLANs, saving HW resources in switches.

 - DSA (Distributed Switch Architecture):
   - replay and offload of host VLAN entries
   - offload of static and local FDB entries on LAG interfaces
   - FDB isolation and unicast filtering

New hardware / drivers
----------------------

 - Ethernet:
   - LAN937x T1 PHYs
   - Davicom DM9051 SPI NIC driver
   - Realtek RTL8367S, RTL8367RB-VB switch and MDIO
   - Microchip ksz8563 switches
   - Netronome NFP3800 SmartNICs
   - Fungible SmartNICs
   - MediaTek MT8195 switches

 - WiFi:
   - mt76: MediaTek mt7916
   - mt76: MediaTek mt7921u USB adapters
   - brcmfmac: Broadcom BCM43454/6

 - Mobile:
   - iosm: Intel M.2 7360 WWAN card

Drivers
-------

 - Convert many drivers to the new phylink API built for split PCS
   designs but also simplifying other cases.

 - Intel Ethernet NICs:
   - add TTY for GNSS module for E810T device
   - improve AF_XDP performance
   - GTP-C and GTP-U filter offload
   - QinQ VLAN support

 - Mellanox Ethernet NICs (mlx5):
   - support xdp->data_meta
   - multi-buffer XDP
   - offload tc push_eth and pop_eth actions

 - Netronome Ethernet NICs (nfp):
   - flow-independent tc action hardware offload (police / meter)
   - AF_XDP

 - Other Ethernet NICs:
   - at803x: fiber and SFP support
   - xgmac: mdio: preamble suppression and custom MDC frequencies
   - r8169: enable ASPM L1.2 if system vendor flags it as safe
   - macb/gem: ZynqMP SGMII
   - hns3: add TX push mode
   - dpaa2-eth: software TSO
   - lan743x: multi-queue, mdio, SGMII, PTP
   - axienet: NAPI and GRO support

 - Mellanox Ethernet switches (mlxsw):
   - source and dest IP address rewrites
   - RJ45 ports

 - Marvell Ethernet switches (prestera):
   - basic routing offload
   - multi-chain TC ACL offload

 - NXP embedded Ethernet switches (ocelot & felix):
   - PTP over UDP with the ocelot-8021q DSA tagging protocol
   - basic QoS classification on Felix DSA switch using dcbnl
   - port mirroring for ocelot switches

 - Microchip high-speed industrial Ethernet (sparx5):
   - offloading of bridge port flooding flags
   - PTP Hardware Clock

 - Other embedded switches:
   - lan966x: PTP Hardward Clock
   - qca8k: mdio read/write operations via crafted Ethernet packets

 - Qualcomm 802.11ax WiFi (ath11k):
   - add LDPC FEC type and 802.11ax High Efficiency data in radiotap
   - enable RX PPDU stats in monitor co-exist mode

 - Intel WiFi (iwlwifi):
   - UHB TAS enablement via BIOS
   - band disablement via BIOS
   - channel switch offload
   - 32 Rx AMPDU sessions in newer devices

 - MediaTek WiFi (mt76):
   - background radar detection
   - thermal management improvements on mt7915
   - SAR support for more mt76 platforms
   - MBSSID and 6 GHz band on mt7915

 - RealTek WiFi:
   - rtw89: AP mode
   - rtw89: 160 MHz channels and 6 GHz band
   - rtw89: hardware scan

 - Bluetooth:
   - mt7921s: wake on Bluetooth, SCO over I2S, wide-band-speed (WBS)

 - Microchip CAN (mcp251xfd):
   - multiple RX-FIFOs and runtime configurable RX/TX rings
   - internal PLL, runtime PM handling simplification
   - improve chip detection and error handling after wakeup

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Aaron Conole (1):
      openvswitch: always update flow key after nat

Abhishek Naik (2):
      iwlwifi: nvm: Correct HE capability
      iwlwifi: tlc: Add logs in rs_fw_rate_init func to print TLC configuration

Aditya Kumar Singh (1):
      ath11k: fix workqueue not getting destroyed after rmmod

Adrian Ratiu (1):
      tools: Fix unavoidable GCC call in Clang builds

Ahmad Fatoum (1):
      net: dsa: microchip: add ksz8563 to ksz9477 I2C driver

Akhmat Karakotov (6):
      txhash: Make rethinking txhash behavior configurable via sysctl
      txhash: Add socket option to control TX hash rethink behavior
      txhash: Add txrehash sysctl description
      bpf: Add SO_TXREHASH setsockopt
      tcp: Change SYN ACK retransmit behaviour to account for rehash
      tcp: Use BPF timeout setting for SYN ACK RTO

Aleksander Jan Bajkowski (1):
      net: dsa: lantiq_gswip: enable jumbo frames on GSWIP

Alex Elder (20):
      net: ipa: define per-endpoint receive buffer size
      net: ipa: set IPA v4.11 AP<-modem RX buffer size to 32KB
      net: ipa: kill replenish_saved
      net: ipa: allocate transaction before pages when replenishing
      net: ipa: increment backlog in replenish caller
      net: ipa: decide on doorbell in replenish loop
      net: ipa: allocate transaction in replenish loop
      net: ipa: don't use replenish_backlog
      net: ipa: introduce gsi_channel_trans_idle()
      net: ipa: kill replenish_backlog
      net: ipa: replenish after delivering payload
      net: ipa: determine replenish doorbell differently
      net: ipa: kill struct ipa_interconnect
      net: ipa: use icc_enable() and icc_disable()
      net: ipa: use interconnect bulk enable/disable operations
      net: ipa: use bulk operations to set up interconnects
      net: ipa: use bulk interconnect initialization
      net: ipa: embed interconnect array in the power structure
      net: ipa: use IPA power device pointer
      net: ipa: use struct_size() for the interconnect array

Alex Liu (1):
      net/mlx5e: Add support for using xdp->data_meta

Alexander Duyck (1):
      page_pool: Refactor page_pool to enable fragmenting after allocation

Alexander Gordeev (2):
      s390/iucv: sort out physical vs virtual pointers usage
      s390/net: sort out physical vs virtual pointers usage

Alexander Lobakin (12):
      i40e: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
      i40e: respect metadata on XSK Rx to skb
      ice: respect metadata in legacy-rx/ice_construct_skb()
      ice: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
      ice: respect metadata on XSK Rx to skb
      igc: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
      ixgbe: pass bi->xdp to ixgbe_construct_skb_zc() directly
      ixgbe: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
      ixgbe: respect metadata on XSK Rx to skb
      i40e: remove dead stores on XSK hotpath
      ice: fix 'scheduling while atomic' on aux critical err interrupt
      ice: don't allow to run ice_send_event_to_aux() in atomic ctx

Alexei Starovoitov (43):
      Merge branch 'Introduce unstable CT lookup helpers'
      Merge branch 'bpf: Batching iter for AF_UNIX sockets.'
      Merge branch 'bpf: allow cgroup progs to export custom retval to userspace'
      Merge branch 'libbpf: deprecate legacy BPF map definitions'
      Merge branch 'libbpf: streamline netlink-based XDP APIs'
      Merge branch 'mvneta: introduce XDP multi-buffer support'
      Merge branch 'Add bpf_copy_from_user_task helper and sleepable bpf iterator programs'
      Merge branch 'libbpf: deprecate some setter and getter APIs'
      Merge branch 'bpf: add __user tagging support in vmlinux BTF'
      Merge branch 'selftests/bpf: use temp netns for testing'
      Merge branch 'Split bpf_sock dst_port field'
      libbpf: Add support for bpf iter in light skeleton.
      libbpf: Open code low level bpf commands.
      libbpf: Open code raw_tp_open and link_create commands.
      bpf: Remove unnecessary setrlimit from bpf preload.
      bpf: Convert bpf preload to light skeleton.
      bpf: Open code obj_get_info_by_fd in bpf preload.
      bpf: Drop libbpf, libelf, libz dependency from bpf preload.
      Merge branch 'bpf_prog_pack allocator'
      Merge branch 'fix bpf_prog_pack build errors'
      Merge branch 'Split bpf_sk_lookup remote_port field'
      bpf: Extend sys_bpf commands for bpf_syscall programs.
      libbpf: Prepare light skeleton for the kernel.
      bpftool: Generalize light skeleton generation.
      bpf: Update iterators.lskel.h.
      bpf: Convert bpf_preload.ko to use light skeleton.
      Merge branch 'Make BPF skeleton easier to use from C++ code'
      Merge branch 'fixes for bpf_prog_pack'
      Merge branch 'libbpf: support custom SEC() handlers'
      Merge branch 'Fixes for bad PTR_TO_BTF_ID offset'
      Merge branch 'bpf: add __percpu tagging in vmlinux BTF'
      Merge branch 'Add support for transmitting packets using XDP in bpf_prog_run()'
      Merge branch 'bpf-lsm: Extend interoperability with IMA'
      Merge branch 'Remove libcap dependency from bpf selftests'
      Merge branch 'fprobe: Introduce fprobe function entry/exit probe'
      Merge branch 'bpf: Add kprobe multi link'
      Merge branch 'Enable non-atomic allocations in local storage'
      Merge branch 'Make 2-byte access to bpf_sk_lookup->remote_port endian-agnostic'
      Revert "ARM: rethook: Add rethook arm implementation"
      Revert "powerpc: Add rethook support"
      Revert "arm64: rethook: Add arm64 rethook implementation"
      Revert "rethook: x86: Add rethook x86 implementation"
      selftests/bpf: Fix kprobe_multi test.

Aloka Dixit (1):
      ath11k: move function ath11k_dp_rx_process_mon_status

Alvin Šipraga (2):
      net: dsa: realtek: allow subdrivers to externally lock regmap
      net: dsa: realtek: rtl8365mb: serialize indirect PHY register access

Amit Cohen (1):
      mlxsw: spectrum: Guard against invalid local ports

Amit Kumar Mahapatra (1):
      dt-bindings: can: xilinx_can: Convert Xilinx CAN binding to YAML

Amritha Nambiar (1):
      ice: Add support for outer dest MAC for ADQ tunnels

Anders Roxell (1):
      net: phy: Kconfig: micrel_phy: fix dependency issue

Andrei Otcheretianski (1):
      iwlwifi: pcie: make sure iwl_rx_packet_payload_len() will not underflow

Andrii Nakryiko (50):
      Merge branch 'libbpf: rename bpf_prog_attach_xattr to bpf_prog_attach_opts'
      Merge branch 'libbpf 1.0: deprecate bpf_map__def() API'
      Merge branch 'rely on ASSERT marcos in xdp_bpf2bpf.c/xdp_adjust_tail.c'
      selftests/bpf: fail build on compilation warning
      selftests/bpf: convert remaining legacy map definitions
      libbpf: deprecate legacy BPF map definitions
      docs/bpf: update BPF map definition example
      libbpf: streamline low-level XDP APIs
      bpftool: use new API for attaching XDP program
      selftests/bpf: switch to new libbpf XDP APIs
      samples/bpf: adapt samples/bpf to bpf_xdp_xxx() APIs
      Merge branch 'deprecate bpf_object__open_buffer() API'
      Merge branch 'Fix the incorrect register read for syscalls on x86_64'
      libbpf: hide and discourage inconsistently named getters
      libbpf: deprecate bpf_map__resize()
      libbpf: deprecate bpf_program__is_<type>() and bpf_program__set_<type>() APIs
      bpftool: use preferred setters/getters instead of deprecated ones
      selftests/bpf: use preferred setter/getter APIs instead of deprecated ones
      samples/bpf: use preferred getters/setters instead of deprecated ones
      perf: use generic bpf_program__set_type() to set BPF prog type
      selftests/bpf: fix uprobe offset calculation in selftests
      Merge branch 'libbpf: deprecate xdp_cpumap, xdp_devmap and classifier sec definitions'
      Merge branch 'migrate from bpf_prog_test_run{,_xattr}'
      libbpf: Stop using deprecated bpf_map__is_offload_neutral()
      bpftool: Stop supporting BPF offload-enabled feature probing
      bpftool: Fix uninit variable compilation warning
      selftests/bpf: Remove usage of deprecated feature probing APIs
      selftests/bpf: Redo the switch to new libbpf XDP APIs
      samples/bpf: Get rid of bpf_prog_load_xattr() use
      libbpf: Deprecate forgotten btf__get_map_kv_tids()
      Merge branch 'bpf: Fix strict mode calculation'
      Merge branch 'Fix accessing syscall arguments'
      Merge branch 'libbpf: Add syscall-specific variant of BPF_KPROBE'
      libbpf: Fix compilation warning due to mismatched printf format
      Merge branch 'bpftool: Switch to new versioning scheme (align on libbpf's)'
      libbpf: Fix libbpf.map inheritance chain for LIBBPF_0.7.0
      selftests/bpf: Fix GCC11 compiler warnings in -O2 mode
      bpftool: Add C++-specific open/load/etc skeleton wrappers
      selftests/bpf: Add Skeleton templated wrapper as an example
      Merge branch 'libbpf: Implement BTFGen'
      bpftool: Fix C++ additions to skeleton
      libbpf: Fix memleak in libbpf_netlink_recv()
      selftests/bpf: Fix btfgen tests
      libbpf: Allow BPF program auto-attach handlers to bail out
      libbpf: Support custom SEC() handlers
      selftests/bpf: Add custom SEC() handling selftest
      Merge branch 'BPF test_progs tests improvement'
      Merge branch 'Subskeleton support for BPF librariesThread-Topic: [PATCH bpf-next v4 0/5'
      bpftool: Add BPF_TRACE_KPROBE_MULTI to attach type names table
      libbpf: Avoid NULL deref when initializing map BTF info

André Apitzsch (1):
      ath6kl: add device ID for WLU5150-D81

Andy Shevchenko (6):
      ptp_pch: use mac_pton()
      ptp_pch: Use ioread64_lo_hi() / iowrite64_lo_hi()
      ptp_pch: Use ioread64_hi_lo() / iowrite64_hi_lo()
      ptp_pch: Switch to use module_pci_driver() macro
      ptp_pch: Convert to use managed functions pcim_* and devm_*
      ptp_pch: Remove unused pch_pm_ops

Anilkumar Kolli (1):
      ath11k: Fix uninitialized symbol 'rx_buf_sz'

Ansuel Smith (14):
      net: dsa: tag_qca: convert to FIELD macro
      net: dsa: tag_qca: move define to include linux/dsa
      net: dsa: tag_qca: enable promisc_on_master flag
      net: dsa: tag_qca: add define for handling mgmt Ethernet packet
      net: dsa: tag_qca: add define for handling MIB packet
      net: dsa: tag_qca: add support for handling mgmt and MIB Ethernet packet
      net: dsa: qca8k: add tracking state of master port
      net: dsa: qca8k: add support for mgmt read/write in Ethernet packet
      net: dsa: qca8k: add support for mib autocast in Ethernet packet
      net: dsa: qca8k: add support for phy read/write with mgmt Ethernet
      net: dsa: qca8k: move page cache to driver priv
      net: dsa: qca8k: cache lo and hi for mdio write
      net: dsa: qca8k: add support for larger read/write size with mgmt Ethernet
      net: dsa: qca8k: introduce qca8k_bulk_read/write function

Arnd Bergmann (1):
      iwlwifi: mei: fix building iwlmei

Arun Ramadoss (8):
      net: phy: used genphy_soft_reset for phy reset in LAN87xx
      net: phy: used the PHY_ID_MATCH_MODEL macro for LAN87XX
      net: phy: removed empty lines in LAN87XX
      net: phy: updated the initialization routine for LAN87xx
      net: phy: added the LAN937x phy support
      net: phy: added ethtool master-slave configuration support
      net: phy: exported the genphy_read_master_slave function
      net: phy: lan87xx: use genphy_read_master_slave in read_status

Avraham Stern (2):
      cfg80211: don't add non transmitted BSS to 6GHz scanned channels
      mac80211: fix struct ieee80211_tx_info size

Aya Levin (4):
      net/mlx5e: Read max WQEBBs on the SQ from firmware
      net/mlx5e: Use FW limitation for max MPW WQEBBs
      net/mlx5e: E-Switch, Add PTP counters for uplink representor
      net/mlx5e: E-Switch, Add support for tx_port_ts in switchdev mode

Ayala Barazani (4):
      iwlwifi: mvm: allow enabling UHB TAS in the USA via ACPI setting
      iwlwifi: mvm: Disable WiFi bands selectively with BIOS
      iwlwifi: mvm: add a flag to reduce power command.
      iwlwifi: Configure FW debug preset via module param.

Baligh Gasmi (1):
      mac80211: remove useless ieee80211_vif_is_mesh() check

Baochen Qiang (3):
      ath11k: Reconfigure hardware rate for WCN6855 after vdev is started
      ath11k: Fix missing rx_desc_get_ldpc_support in wcn6855_ops
      ath11k: Fix frames flush failure caused by deadlock

Baowen Zheng (7):
      nfp: refactor policer config to support ingress/egress meter
      nfp: add support to offload tc action to hardware
      nfp: add hash table to store meter table
      nfp: add process to get action stats from hardware
      nfp: add support to offload police action from flower table
      nfp: add NFP_FL_FEATS_QOS_METER to host features to enable meter offload
      flow_offload: improve extack msg for user when adding invalid filter

Baruch Siach (2):
      net: dsa: mv88e6xxx: don't error out cmode set on missing lane
      net: dsa: mv88e6xxx: support RMII cmode

Ben Evans (1):
      can: gs_usb: add VID/PID for ABE CAN Debugger devices

Ben Greear (1):
      mt76: mt7921: fix crash when startup fails.

Beni Lev (1):
      mac80211_hwsim: Add debugfs to control rx status RSSI

Biao Huang (7):
      stmmac: dwmac-mediatek: add platform level clocks management
      stmmac: dwmac-mediatek: Reuse more common features
      stmmac: dwmac-mediatek: re-arrange clock setting
      arm64: dts: mt2712: update ethernet device node
      net: dt-bindings: dwmac: Convert mediatek-dwmac to DT schema
      stmmac: dwmac-mediatek: add support for mt8195
      net: dt-bindings: dwmac: add support for mt8195

Biju Das (2):
      dt-bindings: net: renesas,etheravb: Document RZ/V2L SoC
      dt-bindings: net: renesas,etheravb: Document RZ/G2UL SoC

Bill Wendling (5):
      enetc: use correct format characters
      bnx2x: use correct format characters
      net/fsl: xgmac_mdio: use correct format characters
      vlan: use correct format characters
      bnx2x: truncate value to original sizing

Bixuan Cui (1):
      iwlwifi: mvm: rfi: use kmemdup() to replace kzalloc + memcpy

Bjoern A. Zeeb (2):
      iwlwifi: de-const properly where needed
      iwlwifi: propagate (const) type qualifier

Bjorn Andersson (1):
      net: stmmac: dwmac-qcom-ethqos: Adjust rgmii loopback_en per platform

Bo Jiao (17):
      mt76: mt7915: add mt7915_mmio_probe() as a common probing function
      mt76: mt7915: refine register definition
      mt76: add MT_RXQ_MAIN_WA for mt7916
      mt76: mt7915: rework dma.c to adapt mt7916 changes
      mt76: mt7915: add firmware support for mt7916
      mt76: mt7915: rework eeprom.c to adapt mt7916 changes
      mt76: mt7915: enlarge wcid size to 544
      mt76: mt7915: add txfree event v3
      mt76: mt7915: update rx rate reporting for mt7916
      mt76: mt7915: update mt7915_chan_mib_offs for mt7916
      mt76: mt7915: add mt7916 calibrated data support
      mt76: set wlan_idx_hi on mt7916
      mt76: mt7915: add device id for mt7916
      mt76: redefine mt76_for_each_q_rx to adapt mt7986 changes
      mt76: mt7915: Fix channel state update error issue
      mt76: mt7915: add support for MT7986
      mt76: mt7915: introduce band_idx in mt7915_phy

Brett Creeley (22):
      ionic: Don't send reset commands if FW isn't running
      ionic: Correctly print AQ errors if completions aren't received
      ionic: Allow flexibility for error reporting on dev commands
      ionic: Query FW when getting VF info via ndo_get_vf_config
      ionic: Prevent filter add/del err msgs when the device is not available
      ionic: Cleanups in the Tx hotpath code
      ionic: disable napi when ionic_lif_init() fails
      ice: Refactor spoofcheck configuration functions
      ice: Add helper function for adding VLAN 0
      ice: Add new VSI VLAN ops
      ice: Introduce ice_vlan struct
      ice: Refactor vf->port_vlan_info to use ice_vlan
      ice: Use the proto argument for VLAN ops
      ice: Adjust naming for inner VLAN operations
      ice: Add outer_vlan_ops and VSI specific VLAN ops implementations
      ice: Add hot path support for 802.1Q and 802.1ad VLAN offloads
      ice: Add support for VIRTCHNL_VF_OFFLOAD_VLAN_V2
      ice: Support configuring the device to Double VLAN Mode
      ice: Advertise 802.1ad VLAN filtering and offloads for PF netdev
      ice: Add support for 802.1ad port VLANs VF
      ice: Add ability for PF admin to enable VF VLAN pruning
      ionic: Use vzalloc for large per-queue related buffers

Brian Norris (1):
      Revert "ath: add support for special 0x0 regulatory domain"

Bryan O'Donoghue (5):
      wcn36xx: Implement get_snr()
      wcn36xx: Track the band and channel we are tuned to
      wcn36xx: Track SNR and RSSI for each RX frame
      wcn36xx: Add SNR reporting via get_survey()
      wcn36xx: Differentiate wcn3660 from wcn3620

Cai Huoqing (1):
      iwlwifi: Make use of the helper macro LIST_HEAD()

Carl Huang (1):
      ath11k: fix invalid m3 buffer address

Casper Andersson (5):
      net: sparx5: Support offloading of bridge port flooding flags
      net: sparx5: Use Switchdev fdb events for managing fdb entries
      net: sparx5: Use vid 1 when bridge default vid 0 to avoid collision
      net: sparx5: Add arbiter for managing PGID table
      net: sparx5: Add mdb handlers

Chad Monroe (1):
      mt76: connac: adjust wlan_idx size from u8 to u16

Changcheng Deng (4):
      wilc1000: use min_t() to make code cleaner
      mt76: mt7915: use min_t() to make code cleaner
      Bluetooth: mgmt: Replace zero-length array with flexible-array member
      net: ethernet: sun: use min_t() to make code cleaner

Chen Yu (1):
      e1000e: Print PHY register address when MDI read/write fails

Chia-Yuan Li (3):
      rtw89: modify MAC enable functions
      rtw89: disable FW and H2C function if CPU disabled
      rtw89: 8852c: add mac_ctrl_path and mac_cfg_gnt APIs

Chien-Hsun Liao (2):
      rtw88: recover rates of rate adaptive mechanism
      rtw89: recover rates of rate adaptive mechanism

Chih-Ying Chiang (1):
      Bluetooth: mt7921s: support bluetooth reset mechanism

Chin-Yen Lee (3):
      rtw89: use pci_read/write_config instead of dbi read/write
      rtw88: 8822ce: add support for TX/RX 1ss mode
      rtw89: add tx_wake notify for low ps mode

Ching-Te Ku (5):
      rtw88: coex: Improve WLAN throughput when HFP COEX
      rtw88: coex: update BT PTA counter regularly
      rtw88: coex: Add WLAN MIMO power saving for Bluetooth gaming controller
      rtw88: coex: Add C2H/H2C handshake with BT mailbox for asking HID Info
      rtw88: coex: Update rtl8822c COEX version to 22020720

Chris J Arges (1):
      bpftool: Ensure bytes_memlock json output is correct

Chris Packham (2):
      dt-bindings: net: mvneta: Add marvell,armada-ac5-neta
      net: mvneta: Add support for 98DX2530 Ethernet port

Christian Lamparter (5):
      carl9170: replace GFP_ATOMIC in ampdu_action, it can sleep
      carl9170: devres-ing hwrng_register usage
      carl9170: devres-ing input_allocate_device
      carl9170: replace bitmap_zalloc with devm_bitmap_zalloc
      carl9170: devres ar->survey_info

Christo du Toit (1):
      nfp: remove pessimistic NFP_QCP_MAX_ADD limits

Christoph Hellwig (6):
      bpf, docs: Document the byte swapping instructions
      bpf, docs: Better document the regular load and store instructions
      bpf, docs: Better document the legacy packet access instruction
      bpf, docs: Better document the extended instruction format
      bpf, docs: Better document the atomic instructions
      tcp: unexport tcp_ca_get_key_by_name and tcp_ca_get_name_by_key

Christophe JAILLET (22):
      ath: dfs_pattern_detector: Avoid open coded arithmetic in memory allocation
      batman-adv: Remove redundant 'flush_workqueue()' calls
      ixgb: Remove useless DMA-32 fallback configuration
      ixgbe: Remove useless DMA-32 fallback configuration
      ixgbevf: Remove useless DMA-32 fallback configuration
      i40e: Remove useless DMA-32 fallback configuration
      e1000e: Remove useless DMA-32 fallback configuration
      iavf: Remove useless DMA-32 fallback configuration
      ice: Remove useless DMA-32 fallback configuration
      igc: Remove useless DMA-32 fallback configuration
      igb: Remove useless DMA-32 fallback configuration
      igbvf: Remove useless DMA-32 fallback configuration
      net: hso: Use GFP_KERNEL instead of GFP_ATOMIC when possible
      net: nixge: Use GFP_KERNEL instead of GFP_ATOMIC when possible
      net: ll_temac: Use GFP_KERNEL instead of GFP_ATOMIC when possible
      atm: nicstar: Use kcalloc() to simplify code
      net: qualcomm: rmnet: Use skb_put_zero() to simplify code
      ravb: Use GFP_KERNEL instead of GFP_ATOMIC when possible
      nfp: flower: Remove usage of the deprecated ida_simple_xxx API
      Bluetooth: 6lowpan: No need to clear memory twice
      mac80211: Use GFP_KERNEL instead of GFP_ATOMIC when possible
      Bluetooth: Don't assign twice the same value

Christophe Leroy (2):
      net: core: Use csum_replace_by_diff() and csum_sub() instead of opencoding
      powerpc/net: Implement powerpc specific csum_shift() to remove branch

Christy Lee (10):
      libbpf: Rename bpf_prog_attach_xattr() to bpf_prog_attach_opts()
      selftests/bpf: Change bpf_prog_attach_xattr() to bpf_prog_attach_opts()
      samples/bpf: Stop using bpf_map__def() API
      bpftool: Stop using bpf_map__def() API
      perf: Stop using bpf_map__def() API
      selftests/bpf: Stop using bpf_map__def() API
      libbpf: Deprecate bpf_map__def() API
      libbpf: Mark bpf_object__open_buffer() API deprecated
      perf: Stop using bpf_object__open_buffer() API
      libbpf: Mark bpf_object__open_xattr() deprecated

Chung-Hsuan Hung (1):
      rtw89: 8852c: add read/write rf register function

Colin Foster (5):
      net: mscc: ocelot: remove unnecessary stat reading from ethtool
      net: ocelot: align macros for consistency
      net: mscc: ocelot: add ability to perform bulk reads
      net: mscc: ocelot: use bulk reads for stats
      net: dsa: felix: remove prevalidate_phy_mode interface

Colin Ian King (29):
      net: usb: asix: remove redundant assignment to variable reg
      net: fec_ptp: remove redundant initialization of variable val
      net: tulip: remove redundant assignment to variable new_csr6
      net/fsl: xgmac_mdio: Fix spelling mistake "frequecy" -> "frequency"
      carl9170: fix missing bit-wise or operator for tx_params
      cw1200: wsm: make array queue_id_to_wmm_aci static const
      rtlwifi: remove redundant initialization of variable ul_encalgo
      brcmfmac: of: remove redundant variable len
      selftests: net: cmsg_sender: Fix spelling mistake "MONOTINIC" -> "MONOTONIC"
      net: dm9051: Fix spelling mistake "eror" -> "error"
      net/mlx5e: Fix spelling mistake "supoported" -> "supported"
      iwlwifi: Fix -EIO error code that is never returned
      net: dsa: qca8k: return with -EINVAL on invalid port
      Bluetooth: make array bt_uuid_any static const
      net: prestera: acl: make read-only array client_map static const
      ath9k: make array voice_priority static const
      bcma: gpio: remove redundant re-assignment of chip->owner
      brcmfmac: make the read-only array pktflags static const
      mwifiex: make read-only array wmm_oui static const
      mt76: connac: make read-only array ba_range static const
      gve: Fix spelling mistake "droping" -> "dropping"
      net: hns3: Fix spelling mistake "does't" -> "doesn't"
      brcmfmac: p2p: Fix spelling mistake "Comback" -> "Comeback"
      rtw89: Fix spelling mistake "Mis-Match" -> "Mismatch"
      net: ethernet: ti: Fix spelling mistake and clean up message
      ethernet: sun: Fix spelling mistake "mis-matched" -> "mismatched"
      Bluetooth: mgmt: remove redundant assignment to variable cur_len
      atl1c: remove redundant assignment to variable size
      qlcnic: remove redundant assignment to variable index

Connor O'Brien (2):
      tools/resolve_btfids: Build with host flags
      bpf: Add config to allow loading modules with BTF mismatches

Corentin Labbe (1):
      net: ethernet: cortina: permit to set mac address in DT

Corinna Vinschen (2):
      igc: avoid kernel warning when changing RX ring parameters
      igb: refactor XDP registration

Cédric Le Goater (1):
      net/ibmvnic: Cleanup workaround doing an EOI after partition migration

D. Wythe (6):
      net/smc: Make smc_tcp_listen_work() independent
      net/smc: Limit backlog connections
      net/smc: Limit SMC visits when handshake workqueue congested
      net/smc: Dynamic control handshake limitation by socket options
      net/smc: Add global configure for handshake limitation by netlink
      net/smc: return ETIMEDOUT when smc_connect_clc() timeout

Dan Carpenter (20):
      Bluetooth: hci_sync: unlock on error in hci_inquiry_result_with_rssi_evt()
      ath11k: fix error code in ath11k_qmi_assign_target_mem_chunk()
      net: dsa: qca8k: check correct variable in qca8k_phy_eth_command()
      net: dsa: mv88e6xxx: Fix off by in one in mv88e6185_phylink_get_caps()
      net: dsa: mv88e6xxx: Unlock on error in mv88e6xxx_port_bridge_join()
      libbpf: Fix signedness bug in btf_dump_array_data()
      rtw88: fix use after free in rtw_hw_scan_update_probe_req()
      wcn36xx: Uninitialized variable in wcn36xx_change_opchannel()
      iwlwifi: mvm: fix off by one in iwl_mvm_stat_iterator_all_macs()
      iwlwifi: mvm: Fix an error code in iwl_mvm_up()
      net/smc: unlock on error paths in __smc_setsockopt()
      net: dm9051: Fix use after free in dm9051_loop_tx()
      ptp: ocp: off by in in ptp_ocp_tod_gnss_name()
      vxlan_core: delete unnecessary condition
      net/mlx5e: TC, Fix use after free in mlx5e_clone_flow_attr_for_post_act()
      net: sparx5: fix a couple warning messages
      mt76: mt7915: check for devm_pinctrl_get() failure
      net: stmmac: clean up impossible condition
      Bluetooth: btmtkuart: fix error handling in mtk_hci_wmt_sync()
      ptp: ocp: use snprintf() in ptp_ocp_verify()

Daniel Borkmann (9):
      selftests, bpf: Do not yet switch to new libbpf XDP APIs
      Merge branch 'xsk-batching'
      Merge branch 'bpf-drop-libbpf-from-preload'
      Merge branch 'bpf-btf-dwarf5'
      Merge branch 'bpf-libbpf-deprecated-cleanup'
      Merge branch 'bpf-light-skel'
      Merge branch 'for-next/insn' of ssh://gitolite.kernel.org/pub/scm/linux/kernel/git/arm64/linux
      Merge branch 'bpf-tstamp-follow-ups'
      Merge branch 'bpf-fix-sock-field-tests'

Daniel Braunwarth (2):
      if_ether.h: add PROFINET Ethertype
      if_ether.h: add EtherCAT Ethertype

Daniel Xu (1):
      bpftool: man: Add missing top level docs

Danielle Ratson (12):
      mlxsw: Add netdev argument to mlxsw_env_get_module_info()
      mlxsw: spectrum_ethtool: Add support for two new link modes
      mlxsw: reg: Add Port Module Type Mapping register
      mlxsw: core_env: Query and store port module's type during initialization
      mlxsw: core_env: Forbid getting module EEPROM on RJ45 ports
      mlxsw: core_env: Forbid power mode set and get on RJ45 ports
      mlxsw: core_env: Forbid module reset on RJ45 ports
      mlxsw: core_acl_flex_actions: Add SIP_DIP_ACTION
      mlxsw: Support FLOW_ACTION_MANGLE for SIP and DIP IPv4 addresses
      mlxsw: Support FLOW_ACTION_MANGLE for SIP and DIP IPv6 addresses
      selftests: forwarding: Add a test for pedit munge SIP and DIP
      mlxsw: core: Add support for OSFP transceiver modules

Dave Ertman (2):
      ice: add support for DSCP QoS for IDC
      ice: Simplify tracking status of RDMA support

Dave Marchevsky (1):
      libbpf: Deprecate btf_ext rec_size APIs

David Ahern (4):
      net: Adjust sk_gso_max_size once when set
      ipv4: Make ip_idents_reserve static
      ipv6: Add reasons for skb drops to __udp6_lib_rcv
      net: Add l3mdev index to flow struct and avoid oif reset for port devices

David Girault (1):
      net: ieee802154: Provide a kdoc to the address structure

David S. Miller (132):
      Merge branch 'ionic-fw-recovery'
      Merge branch 'netns-speedup-dismantle'
      Merge branch 'dsa-avoid-cross-chip-vlan-sync'
      Merge branch 'mlxsw-RJ45'
      Merge branch 'stmmac-PCS-modernize'
      Merge branch 'bnxt_en-RTC'
      Merge branch 'axienet-pcs-modernize'
      Merge branch 'at803x-sfp-fiber'
      Merge branch 'mvneta-mac_select_pcs'
      Merge branch 'xgmac_mdio-preamble-suppression-and-custom-MDC-frequerncies'
      Merge branch 'static-inlines'
      Merge branch 'ksz-switch-refclk'
      Merge branch 'ethtool-hdrsplit'
      Merge branch 'sunrpc-netns-refcnt-tracking'
      Merge branch 'dsa-realtek-MDIO'
      Merge branch 'Cadence-ZyncMP-SGMII'
      Merge branch 'dsa-mv88e6xxx-Improve-indirect-addressing-performance'
      Merge branch 'renesas-dead-code'
      Merge branch 'hash-rethink'
      Merge branch 'smc-improvements'
      Merge branch 'mana-XDP-counters'
      Merge branch '10GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next -queue
      Merge branch 'lan966x-ptp'
      Merge branch 'qca8k-mdio'
      Merge branch 'mptcp-next'
      Merge branch 'dsa-phylink_generic_validate'
      Merge branch 'ptp-virtual-clock-improvements'
      Merge branch 'dsa-mv88e6xxx-port-isolation'
      Merge branch 'dsa-mv88e6xxx-phylink_generic_validate'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'ipa-RX-replenish'
      Merge branch 'lan966x-mcast-snooping'
      Merge branch 'gro-minor-opts'
      Merge branch 'ipv6-mc_forwarding-changes'
      Merge branch 'net-dev-tracking-improvements'
      Merge branch 'net-mana-next'
      Merge branch 'ipv6-kfree_skb_reason'
      Merge branch 'mlxsw-dip-sip-mangling'
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next -queue
      Merge branch 'MCTP-tag-control-interface'
      Merge branch 'octeontx2-af-priority-flow-control'
      Merge branch 'dpaa2-eth-sw-TSO'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge tag 'ieee802154-for-davem-2022-02-10' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan-next
      Merge branch 'ping6-cmsg'
      Merge branch 'smc-optimizations'
      Merge branch 'dsa-cleanup'
      Merge branch 'ipv6-loopback'
      Merge tag 'wireless-next-2022-02-11' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
      Merge branch 'lan743x-enhancements'
      Merge branch 'dm9051'
      Merge branch 'ocelot-stats'
      Merge branch 'netdev-RT'
      Merge branch 'dsa-realtek-next'
      Merge branch 'wwan-debugfs'
      Merge tag 'mlx5-updates-2022-02-14' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'Replay-and-offload-host-VLAN-entries-in-DSA'
      Merge tag 'mlx5-updates-2022-02-16' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'ptp-over-udp-dsa'
      Merge branch 'switchdev-BRENTRY'
      Merge branch 'ping6-SOL_IPV6'
      Merge branch 'prestera-route-offloading'
      Merge branch 'qca8k-phylink'
      Merge branch 'mctp-i2c'
      Merge branch 'dpaa2-eth-one-step-register'
      Merge branch 'phylink-remove-pcs_poll'
      Merge branch 'tcp_drop_reason'
      Merge branch 'ipv4-invalidate-broadcast-neigh-upon-address-addition'
      Merge branch 'bonding-ipv6-NA-NS-monitor'
      Merge branch 'octeontx2-ptp-updates'
      Merge branch 'net-dsa-b53-non-legacy'
      Merge branch 'dsa-realtek-phy-read-corruption'
      Merge branch 'mctp-incorrect-addr-refs'
      Merge branch 'mlxsw-next'
      Merge branch 'locked-bridge-ports'
      Merge tag 'linux-can-next-for-5.18-20220224' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge branch 'sja1105-phylink-updates'
      Merge branch 'dsa-ocelot-phylink-updates'
      Merge branch 'ip-neigh-skb-reason'
      Merge branch 'FFungible-ethernet-driver'
      Merge branch 'dsa-fdb-isolation'
      Merge branch 'flow_offload-tc-police-parameters'
      Merge branch 'vxlan-vnifiltering'
      Merge branch 'smc-datapath-opts'
      Merge branch 'page_pool-stats'
      Merge branch 'stmmac-SA8155p-ADP'
      Merge branch 'net-hw-counters-for-soft-devices'
      Merge branch 'nfc-llcp-cleanups'
      Merge branch 'dsa-unicast-filtering'
      Merge branch 'skb-mono-delivery-time'
      Merge branch 'ptp-ocp-next'
      Merge branch 'ocelot-felix-cleanups'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'netif_rx'
      Merge branch 'skb-drop-reasons'
      Merge branch 'lan8814-1588-support'
      Merge branch 'lan937x-t1-phy-driver'
      Merge branch 'sparx5-ptp'
      Merge branch 'nfp-AF_XDP-zero-copy'
      Merge branch 'dsa-realtek-add-rtl8_4t-tags'
      Merge branch 'axienet-napi-gro-support'
      Merge branch 'bnxt_en-updates'
      Merge branch 'tuntap-kfree_skb_reason'
      Merge branch 'netif_rx-conversions-part2'
      Merge branch 'ptp-is_sync'
      Merge branch 'netif_rx-part3'
      Merge branch '10GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next -queue
      Merge branch 'ptrp-ocp-next'
      Merge branch 'dsa-next-fixups'
      Merge tag 'mlx5-updates-2022-03-10' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'ptp-ocp-new-firmware-support'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge tag 'linux-can-next-for-5.18-20220313' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge branch 'macvlan-uaf'
      Merge branch 'dsa-felix-qos'
      Merge branch 'dpaa2-mac-protocol-change'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'mediatek-next'
      Merge tag 'mlx5-updates-2022-03-17' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge branch 'lan743x-PCI11010-#PCI11414'
      Merge branch 'af_unix-OOB-fixes'
      Merge tag 'wireless-next-2022-03-18' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ ipsec-next
      Merge tag 'mlx5-updates-2022-03-18' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'ax25-fixes'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next
      Merge branch 'nfp3800'
      Merge branch 'sparx5-mcast'
      Merge branch 'too-short'
      Merge branch 'devlink-locking'

Davide Caratti (1):
      net/sched: act_police: more accurate MTU policing

Delyan Kratunov (11):
      selftests/bpf: Migrate from bpf_prog_test_run
      selftests/bpf: Migrate from bpf_prog_test_run_xattr
      bpftool: Migrate from bpf_prog_test_run_xattr
      libbpf: Deprecate bpf_prog_test_run_xattr and bpf_prog_test_run
      libbpf: Deprecate priv/set_priv storage
      bpftool: Bpf skeletons assert type sizes
      libbpf: .text routines are subprograms in strict mode
      libbpf: Init btf_{key,value}_type_id on internal map open
      libbpf: Add subskeleton scaffolding
      bpftool: Add support for subskeletons
      selftests/bpf: Test subskeleton functionality

Deren Wu (6):
      mt76: mt7921s: fix missing fc type/sub-type for 802.11 pkts
      mt76: mt7615: fix compiler warning on frame size
      mt76: fix monitor mode crash with sdio driver
      mt76: fix invalid rssi report
      mt76: fix wrong HE data rate in sniffer tool
      mt76: fix monitor rx FCS error in DFS channel

Di Zhu (2):
      bpf: support BPF_PROG_QUERY for progs attached to sockmap
      selftests: bpf: test BPF_PROG_QUERY for progs attached to sockmap

Dima Chumak (2):
      net/mlx5: Introduce software defined steering capabilities
      net/mlx5: VLAN push on RX, pop on TX

Dimitris Michailidis (12):
      PCI: Add Fungible Vendor ID to pci_ids.h
      net/fungible: Add service module for Fungible drivers
      net/funeth: probing and netdev ops
      net/funeth: ethtool operations
      net/funeth: devlink support
      net/funeth: add the data path
      net/funeth: add kTLS TX control part
      net/fungible: Kconfig, Makefiles, and MAINTAINERS
      net/fungible: Fix local_memory_node error
      net/fungible: CONFIG_FUN_CORE needs SBITMAP
      net/tls: Provide {__,}tls_driver_ctx() unconditionally
      net/fungible: fix errors when CONFIG_TLS_DEVICE=n

Dirk van der Merwe (3):
      nfp: use PCI_DEVICE_ID_NETRONOME_NFP6000_VF for VFs instead
      nfp: use PluDevice register for model for non-NFP6000 chips
      nfp: add support for NFP3800/NFP3803 PCIe devices

Divya Koppera (3):
      net: phy: micrel: Fix concurrent register access
      dt-bindings: net: micrel: Configure latency values and timestamping check for LAN8814 phy
      net: phy: micrel: 1588 support for LAN8814 phy

Dmitrii Dolgov (1):
      bpftool: Add bpf_cookie to link output

Dmitry Safonov (1):
      net/tcp: Merge TCP-MD5 inbound callbacks

Dongli Zhang (3):
      net: tap: track dropped skb via kfree_skb_reason()
      net: tun: split run_ebpf_filter() and pskb_trim() into different "if statement"
      net: tun: track dropped skb via kfree_skb_reason()

Double Lo (1):
      MAINTAINERS: brcm80211: remove Infineon maintainers

Duoming Zhou (2):
      ax25: Fix refcount leaks caused by ax25_cb_del()
      ax25: Fix NULL pointer dereferences in ax25 timers

Dust Li (11):
      net/smc: add sysctl interface for SMC
      net/smc: add autocorking support
      net/smc: add sysctl for autocorking
      net/smc: send directly on setting TCP_NODELAY
      net/smc: correct settings of RMB window update limit
      net/smc: don't req_notify until all CQEs drained
      net/smc: don't send in the BH context if sock_owned_by_user
      net/smc: fix document build WARNING from smc-sysctl.rst
      Revert "net/smc: don't req_notify until all CQEs drained"
      net/smc: fix compile warning for smc_sysctl
      net/smc: fix -Wmissing-prototypes warning when CONFIG_SYSCTL not set

Edwin Peer (2):
      bnxt_en: introduce initial link state of unknown
      bnxt_en: Do not destroy health reporters during reset

Eelco Chaudron (3):
      bpf: add frags support to the bpf_xdp_adjust_tail() API
      bpf: add frags support to xdp copy helpers
      bpf: selftests: update xdp_adjust_tail selftest to include xdp frags

Emmanuel Grumbach (3):
      iwlwifi: mvm: starting from 22000 we have 32 Rx AMPDU sessions
      iwlwifi: don't dump_stack() when we get an unexpected interrupt
      iwlwifi: mvm: always remove the session protection after association

Eric Dumazet (62):
      ipv4: get rid of fib_info_hash_{alloc|free}
      tcp/dccp: add tw->tw_bslot
      tcp/dccp: no longer use twsk_net(tw) from tw_timer_handler()
      tcp/dccp: get rid of inet_twsk_purge()
      ipv4: do not use per netns icmp sockets
      ipv6: do not use per netns icmp sockets
      ipv4/tcp: do not use per netns ctl sockets
      tcp: allocate tcp_death_row outside of struct netns_ipv4
      SUNRPC: add netns refcount tracker to struct svc_xprt
      SUNRPC: add netns refcount tracker to struct gss_auth
      SUNRPC: add netns refcount tracker to struct rpc_xprt
      net: minor __dev_alloc_name() optimization
      ipv6: make mc_forwarding atomic
      ip6mr: ip6mr_sk_done() can exit early in common cases
      ref_tracker: implement use-after-free detection
      ref_tracker: add a count of untracked references
      net: refine dev_put()/dev_hold() debugging
      net: typhoon: implement ndo_features_check method
      skmsg: convert struct sk_msg_sg::copy to a bitmap
      net: initialize init_net earlier
      ref_tracker: remove filter_irq_stacks() call
      ip6mr: fix use-after-free in ip6mr_sk_done()
      net: typhoon: include <net/vxlan.h>
      et131x: support arbitrary MAX_SKB_FRAGS
      net: add dev->dev_registered_tracker
      ipv6/addrconf: allocate a per netns hash table
      ipv6/addrconf: use one delayed work per netns
      ipv6/addrconf: switch to per netns inet6_addr_lst hash table
      nexthop: change nexthop_net_exit() to nexthop_net_exit_batch()
      ipv4: add fib_net_exit_batch()
      ipv6: change fib6_rules_net_exit() to batch mode
      ip6mr: introduce ip6mr_net_exit_batch()
      ipmr: introduce ipmr_net_exit_batch()
      can: gw: switch cangw_pernet_exit() to batch mode
      bonding: switch bond_net_exit() to batch mode
      net: remove default_device_exit()
      ip6_tunnel: fix possible NULL deref in ip6_tnl_xmit
      net: make net->dev_unreg_count atomic
      ipv6: get rid of net->ipv6.rt6_stats->fib_rt_uncache
      ipv6: give an IPv6 dev to blackhole_netdev
      ipv6: add (struct uncached_list)->quarantine list
      ipv4: add (struct uncached_list)->quarantine list
      ipv6/addrconf: ensure addrconf_verify_rtnl() has completed
      net: add sanity check in proto_register()
      ipv6: annotate some data-races around sk->sk_prot
      net: avoid quadratic behavior in netdev_wait_allrefs_any()
      bpf: Call maybe_wait_bpf_programs() only once from generic_map_delete_batch()
      bridge: switch br_net_exit to batch mode
      net: get rid of rtnl_lock_unregistering()
      gro_cells: avoid using synchronize_rcu() in gro_cells_destroy()
      ipv6: tcp: consistently use MAX_TCP_HEADER
      net: add skb_set_end_offset() helper
      net: preserve skb_end_offset() in skb_unclone_keeptruesize()
      drop_monitor: remove quadratic behavior
      can: gw: use call_rcu() instead of costly synchronize_rcu()
      net/sysctl: avoid two synchronize_rcu() calls
      tcp: autocork: take MSG_EOR hint into consideration
      tcp: adjust TSO packet sizes based on min_rtt
      net: add per-cpu storage and net->core_stats
      net: disable preemption in dev_core_stats_XXX_inc() helpers
      net: bridge: mst: prevent NULL deref in br_mst_info_size()
      llc: fix netdevice reference leaks in llc_ui_bind()

Evelyn Tsai (1):
      mt76: mt7915: fix DFS no radar detection event

Eyal Birger (2):
      net: geneve: support IPv4/IPv6 as inner protocol
      net: geneve: add missing netlink policy and size for IFLA_GENEVE_INNER_PROTO_INHERIT

Felix Fietkau (13):
      mt76: mt7915: fix polling firmware-own status
      mt76: mt7915: move pci specific code back to pci.c
      mt76: connac: add support for passing the cipher field in bss_info
      mt76: mt7615: update bss_info with cipher after setting the group key
      mt76: mt7915: update bss_info with cipher after setting the group key
      mt76: mt7915: add support for passing chip/firmware debug data to user space
      mt76x02: improve mac error check/reset reliability
      mt76: mt76x02: improve tx hang detection
      mt76: mt7915: fix/rewrite the dfs state handling logic
      mt76: mt7615: fix/rewrite the dfs state handling logic
      mt76: mt76x02: use mt76_phy_dfs_state to determine radar detector state
      mt76: improve signal strength reporting
      mt76: fix dfs state issue with 160 MHz channels

Felix Maurer (3):
      selftests: bpf: Fix bind on used port
      selftests: bpf: Less strict size check in sockopt_sk
      selftests/bpf: Make test_lwt_ip_encap more stable and faster

Florian Westphal (18):
      netfilter: conntrack: make all extensions 8-byte alignned
      netfilter: conntrack: move extension sizes into core
      netfilter: conntrack: handle ->destroy hook via nat_ops instead
      netfilter: conntrack: remove extension register api
      netfilter: conntrack: pptp: use single option structure
      netfilter: exthdr: add support for tcp option removal
      netfilter: nft_compat: suppress comment match
      netfilter: ecache: don't use nf_conn spinlock
      netfilter: cttimeout: use option structure
      netfilter: ctnetlink: use dump structure instead of raw args
      mptcp: mark ops structures as ro_after_init
      mptcp: don't save tcp data_ready and write space callbacks
      Revert "netfilter: conntrack: mark UDP zero checksum as CHECKSUM_UNNECESSARY"
      netfilter: conntrack: revisit gc autotuning
      netfilter: nft_lookup: only cancel tracking for clobbered dregs
      netfilter: nft_meta: extend reduce support to bridge family
      netfilter: nft_fib: add reduce support
      netfilter: nft_exthdr: add reduce support

Francesco Magliocca (2):
      ath10k: abstract htt_rx_desc structure
      ath10k: fix pointer arithmetic error in trace call

Gal Pressman (4):
      net: gro: Fix a 'directive in macro's argument list' sparse warning
      net/mlx5: Query the maximum MCIA register read size from firmware
      net/mlx5: Parse module mapping using mlx5_ifc
      net/mlx5e: Remove overzealous validations in netlink EEPROM query

Gavin Li (1):
      Bluetooth: fix incorrect nonblock bitmask in bt_sock_wait_ready()

Geliang Tang (35):
      mptcp: move the declarations of ssk and subflow
      mptcp: print out reset infos of MP_RST
      mptcp: set fullmesh flag in pm_netlink
      selftests: mptcp: set fullmesh flag in pm_nl_ctl
      selftests: mptcp: add fullmesh setting tests
      mptcp: allow to use port and non-signal in set_flags
      selftests: mptcp: add the port argument for set_flags
      selftests: mptcp: add backup with port testcase
      selftests: mptcp: add ip mptcp wrappers
      selftests: mptcp: add wrapper for showing addrs
      selftests: mptcp: add wrapper for setting flags
      selftests: mptcp: add the id argument for set_flags
      selftests: mptcp: add set_flags tests in pm_netlink.sh
      selftests: mptcp: set ip_mptcp in command line
      mptcp: add SNDTIMEO setsockopt support
      mptcp: drop unused sk in mptcp_get_options
      mptcp: drop unneeded type casts for hmac
      mptcp: drop port parameter of mptcp_pm_add_addr_signal
      selftests: mptcp: simplify pm_nl_change_endpoint
      selftests: mptcp: add csum mib check for mptcp_connect
      selftests: mptcp: adjust output alignment for more tests
      mptcp: add the mibs for MP_FASTCLOSE
      selftests: mptcp: add the MP_FASTCLOSE mibs check
      mptcp: add the mibs for MP_RST
      selftests: mptcp: add the MP_RST mibs check
      selftests: mptcp: add extra_args in do_transfer
      selftests: mptcp: reuse linkfail to make given size files
      selftests: mptcp: add fastclose testcase
      selftests: mptcp: add invert check in check_transfer
      selftests: mptcp: add more arguments for chk_join_nr
      selftests: mptcp: update output info of chk_rm_nr
      mptcp: add tracepoint in mptcp_sendmsg_frag
      mptcp: use MPTCP_SUBFLOW_NODATA
      mptcp: add fullmesh flag check for adding address
      selftests: mptcp: drop msg argument of chk_csum_nr

Gerhard Engleder (1):
      selftests/net: timestamping: Fix bind_phc check

Golan Ben Ami (1):
      iwlwifi: bump FW API to 70 for AX devices

Gregory Greenman (1):
      iwlwifi: mvm: rfi: handle deactivation notification

Guillaume Nault (14):
      selftests: fib rule: Make 'getmatch' and 'match' local variables
      selftests: fib rule: Drop erroneous TABLE variable
      selftests: fib rule: Log test description
      selftests: fib rule: Don't echo modified sysctls
      selftests: fib offload: use sensible tos values
      selftests: rtnetlink: Use more sensible tos values
      ipv6: Define dscp_t and stop taking ECN bits into account in fib6-rules
      ipv4: Stop taking ECN bits into account in fib4-rules
      ipv4: Reject routes specifying ECN bits in rtm_tos
      ipv4: Use dscp_t in struct fib_alias
      ipv4: Reject again rules with high DSCP values
      ipv6: Reject routes configurations that specify dsfield (tos)
      ipv4: Fix route lookups when handling ICMP redirects and PMTU updates
      selftest: net: Test IPv4 PMTU exceptions with DSCP and ECN

Guo Zhengkui (7):
      nfp: xsk: avoid newline at the end of message in NL_SET_ERR_MSG_MOD
      selftests: net: fix array_size.cocci warning
      libbpf: Fix array_size.cocci warning
      drivers: vxlan: fix returnvar.cocci warning
      selftests/bpf: Clean up array_size.cocci warnings
      selftests: net: fix array_size.cocci warning
      selftests: net: change fprintf format specifiers

Gustavo A. R. Silva (20):
      net: mana: Use struct_size() helper in mana_gd_create_dma_region()
      mlxsw: spectrum_kvdl: Use struct_size() helper in kzalloc()
      nfp: flower: Use struct_size() helper in kmalloc()
      bnx2x: Replace one-element array with flexible-array member
      net: sundance: Replace one-element array with non-array object
      brcmfmac: p2p: Replace one-element arrays with flexible-array members
      brcmfmac: Replace zero-length arrays with flexible-array members
      rtw89: core.h: Replace zero-length array with flexible-array member
      ath10k: Replace zero-length array with flexible-array member
      ath11k: Replace zero-length arrays with flexible-array members
      ath6kl: Replace zero-length arrays with flexible-array members
      ath: Replace zero-length arrays with flexible-array members
      usbnet: gl620a: Replace one-element array with flexible-array member
      carl9170: Replace zero-length arrays with flexible-array members
      ath6kl: wmi: Replace one-element array with flexible-array member in struct wmi_begin_scan_cmd
      ath6kl: wmi: Replace one-element array with flexible-array member in struct wmi_start_scan_cmd
      ath6kl: wmi: Replace one-element array with flexible-array member in struct wmi_channel_list_reply
      ath6kl: wmi: Replace one-element array with flexible-array member in struct wmi_connect_event
      ath6kl: wmi: Replace one-element array with flexible-array member in struct wmi_disconnect_event
      ath6kl: wmi: Replace one-element array with flexible-array member in struct wmi_aplist_event

Haiyang Zhang (5):
      net: mana: Add counter for packet dropped by XDP
      net: mana: Add counter for XDP_TX
      net: mana: Reuse XDP dropped page
      net: mana: Add handling of CQE_RX_TRUNCATED
      net: mana: Remove unnecessary check of cqe_type in mana_process_rx_cqe()

Haiyue Wang (1):
      gve: enhance no queue page list detection

Hangbin Liu (14):
      selftests/bpf/test_xdp_redirect_multi: use temp netns for testing
      selftests/bpf/test_xdp_veth: use temp netns for testing
      selftests/bpf/test_xdp_vlan: use temp netns for testing
      selftests/bpf/test_lwt_seg6local: use temp netns for testing
      selftests/bpf/test_tcp_check_syncookie: use temp netns for testing
      selftests/bpf/test_xdp_meta: use temp netns for testing
      selftests/bpf/test_xdp_redirect: use temp netns for testing
      ipv6: separate ndisc_ns_create() from ndisc_send_ns()
      Bonding: split bond_handle_vlan from bond_arp_send
      bonding: add extra field for bond_opt_value
      bonding: add new parameter ns_targets
      bonding: add new option ns_ip6_target
      bareudp: use ipv6_mod_enabled to check if IPv6 enabled
      selftests/bpf/test_lirc_mode2.sh: Exit with proper code

Hans Schultz (5):
      net: bridge: Add support for bridge port in locked mode
      net: bridge: Add support for offloading of locked port flag
      net: dsa: Include BR_PORT_LOCKED in the list of synced brport flags
      net: dsa: mv88e6xxx: Add support for bridge port locked mode
      selftests: forwarding: tests of locked port feature

Hans de Goede (2):
      brcmfmac: use ISO3166 country code and 0 rev as fallback on some devices
      Bluetooth: hci_bcm: Add the Asus TF103C to the bcm_broken_irq_dmi_table

Hao Luo (6):
      bpf: Cache the last valid build_id
      bpf: Fix checking PTR_TO_BTF_ID in check_mem_access
      compiler_types: Define __percpu as __attribute__((btf_type_tag("percpu")))
      bpf: Reject programs that try to load __percpu memory.
      selftests/bpf: Add a test for btf_type_tag "percpu"
      compiler_types: Refactor the use of btf_type_tag attribute.

Haowen Bai (1):
      net: marvell: Use min() instead of doing it manually

Hariprasad Kelam (4):
      octeontx2-af: Don't enable Pause frames by default
      octeontx2-af: Flow control resource management
      octeontx2-pf: PFC config support with DCBx
      octeontx2-af: fix array bound error

Harold Huang (2):
      tun: support NAPI for packets received from batched XDP buffs
      tuntap: add sanity checks about msg_controllen in sendmsg

Hector Martin (8):
      brcmfmac: pcie: Release firmwares in the brcmf_pcie_setup error path
      brcmfmac: firmware: Allocate space for default boardrev in nvram
      brcmfmac: pcie: Declare missing firmware files in pcie.c
      brcmfmac: pcie: Replace brcmf_pcie_copy_mem_todev with memcpy_toio
      brcmfmac: pcie: Fix crashes due to early IRQs
      brcmfmac: of: Use devm_kstrdup for board_type & check for errors
      brcmfmac: fwil: Constify iovar name arguments
      brcmfmac: pcie: Read the console on init and shutdown

Heiner Kallweit (8):
      r8169: use new PM macros
      r8169: enable ASPM L1.2 if system vendor flags it as safe
      r8169: add rtl_disable_exit_l1()
      r8169: support L1.2 control on RTL8168h
      r8169: factor out redundant RTL8168d PHY config functionality to rtl8168d_1_common()
      net: mdio-mux: add bus name to bus id
      net: stmmac: switch no PTP HW support message to info level
      r8169: improve driver unload and system shutdown behavior on DASH-enabled systems

Helmut Grohne (1):
      Bluetooth: btusb: Add another Realtek 8761BU

Hengqi Chen (4):
      libbpf: Add BPF_KPROBE_SYSCALL macro
      selftests/bpf: Test BPF_KPROBE_SYSCALL macro
      bpf: Fix comment for helper bpf_current_task_under_cgroup()
      libbpf: Close fd in bpf_object__reuse_map

Hoang Le (1):
      tipc: fix the timer expires after interval 100ms

Holger Brunck (1):
      dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude configurable

Horatiu Vultur (26):
      dt-bindings: net: lan966x: Extend with the ptp interrupt
      net: lan966x: Add registers that are use for ptp functionality
      net: lan966x: Add support for ptp clocks
      net: lan966x: Implement SIOCSHWTSTAMP and SIOCGHWTSTAMP
      net: lan966x: Update extraction/injection for timestamping
      net: lan966x: Add support for ptp interrupts
      net: lan966x: Implement get_ts_info
      net: lan966x: use .mac_select_pcs() interface
      net: lan966x: Update the PGID used by IPV6 data frames
      net: lan966x: Implement the callback SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED
      net: lan966x: Update mdb when enabling/disabling mcast_snooping
      net: lan966x: Fix when CONFIG_PTP_1588_CLOCK is compiled as module
      net: lan966x: Fix when CONFIG_IPV6 is not set
      net: sparx5: Move ifh from port to local variable
      dt-bindings: net: sparx5: Extend with the ptp interrupt
      dts: sparx5: Enable ptp interrupt
      net: sparx5: Add registers that are used by ptp functionality
      net: sparx5: Add support for ptp clocks
      net: sparx5: Implement SIOCSHWTSTAMP and SIOCGHWTSTAMP
      net: sparx5: Update extraction/injection for timestamping
      net: sparx5: Add support for ptp interrupts
      net: sparx5: Implement get_ts_info
      net: sparx5: Fix initialization of variables on stack
      net: lan966x: allow offloading timestamp operations to the PHY
      net: lan966x: Add spinlock for frame transmission from CPU.
      net: lan966x: Improve the CPU TX bitrate.

Hou Tao (11):
      bpf, x86: Remove unnecessary handling of BPF_SUB atomic op
      bpf, arm64: Enable kfunc call
      selftests/bpf: Do not export subtest as standalone test
      bpf: Reject kfunc calls that overflow insn->imm
      bpf, arm64: Call build_prologue() first in first JIT pass
      bpf, arm64: Feed byte-offset into bpf line info
      bpf, arm64: Support more atomic operations
      bpf, selftests: Use raw_tp program for atomic test
      bpf, x86: Fall back to interpreter mode when extra pass fails
      bpf: Fix net.core.bpf_jit_harden race
      selftests/bpf: Test subprog jit when toggle bpf_jit_harden repeatedly

Hyeonggon Yoo (1):
      net: ena: Do not waste napi skb cache

Ido Schimmel (10):
      mlxsw: spectrum_ethtool: Remove redundant variable
      mlxsw: core_env: Do not pass number of modules as argument
      mlxsw: spectrum_acl: Allocate default actions for internal TCAM regions
      ipv6: blackhole_netdev needs snmp6 counters
      ipv4: Invalidate neighbour for broadcast address upon address addition
      selftests: fib_test: Add a test case for IPv4 broadcast neighbours
      mlxsw: spectrum_span: Ignore VLAN entries not used by the bridge in mirroring
      mlxsw: Remove resource query check
      selftests: forwarding: Disable learning before link up
      selftests: forwarding: Use same VRF for port and VLAN upper

Ilan Peer (16):
      mac80211_hwsim: Add custom regulatory for 6GHz
      ieee80211: Add EHT (802.11be) definitions
      cfg80211: Add data structures to capture EHT capabilities
      cfg80211: add NO-EHT flag to regulatory
      cfg80211: Support configuration of station EHT capabilities
      mac80211: Support parsing EHT elements
      mac80211: Add initial support for EHT and 320 MHz channels
      mac80211: Add EHT capabilities to association/probe request
      mac80211: Handle station association response with EHT
      mac80211: Add support for storing station EHT capabilities
      mac80211_hwsim: Advertise support for EHT capabilities
      iwlwifi: mvm: Correctly set fragmented EBS
      iwlwifi: scan: Modify return value of a function
      iwlwifi: mvm: Passively scan non PSC channels only when requested so
      iwlwifi: mvm: Unify the scan iteration functions
      iwlwifi: mvm: Consider P2P GO operation during scan

Ilya Leoshkevich (10):
      selftests/bpf: Fix an endianness issue in bpf_syscall_macro test
      libbpf: Add PT_REGS_SYSCALL_REGS macro
      selftests/bpf: Use PT_REGS_SYSCALL_REGS in bpf_syscall_macro
      libbpf: Fix accessing syscall arguments on powerpc
      libbpf: Fix riscv register names
      libbpf: Fix accessing syscall arguments on riscv
      selftests/bpf: Skip test_bpf_syscall_macro's syscall_arg1 on arm64 and s390
      libbpf: Allow overriding PT_REGS_PARM1{_CORE}_SYSCALL
      libbpf: Fix accessing the first syscall argument on arm64
      libbpf: Fix accessing the first syscall argument on s390

Ilya Maximets (1):
      net: openvswitch: fix uAPI incompatibility with existing user space

Ioana Ciornei (15):
      dpaa2-eth: rearrange variable declaration in __dpaa2_eth_tx
      dpaa2-eth: allocate a fragment already aligned
      dpaa2-eth: extract the S/G table buffer cache interaction into functions
      dpaa2-eth: use the S/G table cache also for the normal S/G path
      dpaa2-eth: work with an array of FDs
      dpaa2-eth: add support for software TSO
      soc: fsl: dpio: read the consumer index from the cache inhibited area
      phy: add support for the Layerscape SerDes 28G
      dt-bindings: phy: add bindings for Lynx 28G PHY
      dpaa2-mac: add the MC API for retrieving the version
      dpaa2-mac: add the MC API for reconfiguring the protocol
      dpaa2-mac: retrieve API version and detect features
      dpaa2-mac: move setting up supported_interfaces into a function
      dpaa2-mac: configure the SerDes phy on a protocol change
      arch: arm64: dts: lx2160a: describe the SerDes block #1

Ismael Ferreras Morezuelas (3):
      Bluetooth: btusb: Whitespace fixes for btusb_setup_csr()
      Bluetooth: hci_sync: Add a new quirk to skip HCI_FLT_CLEAR_ALL
      Bluetooth: btusb: Use quirk to skip HCI_FLT_CLEAR_ALL on fake CSR controllers

Jacob Keller (37):
      ice: refactor unwind cleanup in eswitch mode
      ice: store VF pointer instead of VF ID
      ice: pass num_vfs to ice_set_per_vf_res()
      ice: move clear_malvf call in ice_free_vfs
      ice: move VFLR acknowledge during ice_free_vfs
      ice: remove checks in ice_vc_send_msg_to_vf
      ice: use ice_for_each_vf for iteration during removal
      ice: convert ice_for_each_vf to include VF entry iterator
      ice: factor VF variables to separate structure
      ice: introduce VF accessor functions
      ice: convert VF storage to hash table with krefs and RCU
      ice: rename ice_sriov.c to ice_vf_mbx.c
      ice: rename ice_virtchnl_pf.c to ice_sriov.c
      ice: remove circular header dependencies on ice.h
      ice: convert vf->vc_ops to a const pointer
      ice: remove unused definitions from ice_sriov.h
      ice: rename ICE_MAX_VF_COUNT to avoid confusion
      ice: refactor spoofchk control code in ice_sriov.c
      ice: move ice_set_vf_port_vlan near other .ndo ops
      ice: cleanup error logging for ice_ena_vfs
      ice: log an error message when eswitch fails to configure
      ice: use ice_is_vf_trusted helper function
      ice: introduce ice_vf_lib.c, ice_vf_lib.h, and ice_vf_lib_private.h
      ice: fix incorrect dev_dbg print mistaking 'i' for vf->vf_id
      ice: introduce VF operations structure for reset flows
      ice: fix a long line warning in ice_reset_vf
      ice: move reset functionality into ice_vf_lib.c
      ice: drop is_vflr parameter from ice_reset_all_vfs
      ice: make ice_reset_all_vfs void
      ice: convert ice_reset_vf to standard error codes
      ice: convert ice_reset_vf to take flags
      ice: introduce ICE_VF_RESET_NOTIFY flag
      ice: introduce ICE_VF_RESET_LOCK flag
      ice: cleanup long lines in ice_sriov.c
      ice: introduce ice_virtchnl.c and ice_virtchnl.h
      ice: remove PF pointer from ice_check_vf_init
      ice: add trace events for tx timestamps

Jacques de Laval (1):
      net: Add new protocol attribute to IP addresses

Jakub Kicinski (154):
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      ipv6: gro: flush instead of assuming different flows on hop_limit mismatch
      bpf: remove unused static inlines
      mii: remove mii_lpa_to_linkmode_lpa_sgmii()
      nfc: use *_set_vendor_cmds() helpers
      net: remove net_invalid_timestamp()
      net: remove linkmode_change_bit()
      net: remove bond_slave_has_mac_rcu()
      net: ax25: remove route refcount
      hsr: remove get_prp_lan_id()
      ipv6: remove inet6_rsk() and tcp_twsk_ipv6only()
      dccp: remove max48()
      udp: remove inner_udp_hdr()
      udplite: remove udplite_csum_outgoing()
      netlink: remove nl_set_extack_cookie_u32()
      net: sched: remove psched_tdiff_bounded()
      net: sched: remove qdisc_qlen_cpu()
      net: tipc: remove unused static inlines
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge tag 'mlx5-updates-2022-01-27' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'mlxsw-various-updates'
      Merge branch 'udp-ipv6-optimisations'
      net: mii: remove mii_lpa_mod_linkmode_lpa_sgmii()
      ethtool: add header/data split indication
      bnxt: report header-data split state
      Merge tag 'for-net-next-2022-01-28' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next
      ipv4: drop fragmentation code from ip_options_build()
      net: allow SO_MARK with CAP_NET_RAW via cmsg
      Merge branch 'net-ipa-support-variable-rx-buffer-size'
      i40e: remove enum i40e_client_state
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      tls: cap the output scatter list to something reasonable
      net: don't include ndisc.h from ipv6.h
      Merge branch 'support-for-the-ioam-insertion-frequency'
      Merge branch 'mptcp-improve-set-flags-command-and-update-self-tests'
      net: dsa: realtek: don't default Kconfigs to y
      Merge branch 'inet-separate-dscp-from-ecn-bits-using-new-dscp_t-type'
      Merge branch 'iwl-next' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/linux
      Merge branch 'net-speedup-netns-dismantles'
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next
      net: ping6: remove a pr_debug() statement
      net: ping6: support packet timestamping
      net: ping6: support setting socket options via cmsg
      selftests: net: rename cmsg_so_mark
      selftests: net: make cmsg_so_mark ready for more options
      selftests: net: cmsg_sender: support icmp and raw sockets
      selftests: net: cmsg_so_mark: test ICMP and RAW sockets
      selftests: net: cmsg_so_mark: test with SO_MARK set by setsockopt
      selftests: net: cmsg_sender: support setting SO_TXTIME
      selftests: net: cmsg_sender: support Tx timestamping
      selftests: net: test standard socket cmsgs across UDP and ICMP sockets
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Revert "net: ethernet: cavium: use div64_u64() instead of do_div()"
      Merge branch 'mptcp-so_sndtimeo-and-misc-cleanup'
      net: ping6: support setting basic SOL_IPV6 options via cmsg
      selftests: net: test IPV6_DONTFRAG
      selftests: net: test IPV6_TCLASS
      selftests: net: test IPV6_HOPLIMIT
      selftests: net: basic test for IPV6_2292*
      net: transition netdev reg state earlier in run_todo
      net: allow out-of-order netdev unregistration
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge branch 'mptcp-selftest-fine-tuning-and-cleanup'
      Merge branch 'ionic-driver-updates'
      Merge branch 'add-checks-for-incoming-packet-addresses'
      Merge branch 's390-net-updates-2022-02-21'
      Merge branch 'tcp-take-care-of-another-syzbot-issue'
      mlx5: remove unused static inlines
      Merge branch 'add-ethtool-support-for-completion-queue-event-size'
      Merge branch '10GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'fdb-entries-on-dsa-lag-interfaces'
      Merge branch 'nfp-flow-independent-tc-action-hardware-offload'
      Merge branch 'small-fixes-for-mctp'
      Merge tag 'spi-remove-void' of https://git.kernel.org/pub/scm/linux/kernel/git/broonie/spi
      Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux
      net: smc: fix different types in min()
      Merge branch 'sfc-optimize-rxqs-count-and-affinities'
      Merge branch 'if_ether-h-add-industrial-fieldbus-ethertypes'
      Merge tag 'batadv-next-pullrequest-20220302' of git://git.open-mesh.org/linux-merge
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      nfp: wrap napi add/del logic
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge tag 'for-net-next-2022-03-04' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next
      Merge branch 'mptcp-selftest-refinements-and-a-new-test'
      Merge branch 'mptcp-advertisement-reliability-improvement-and-misc-updates'
      skb: make drop reason booleanable
      bnxt: revert hastily merged uAPI aberrations
      Merge branch 'net-fungible-fix-errors-when-config_tls_device-n'
      Merge branch 'mptcp-selftests-refactor-join-tests'
      Merge tag 'mlx5-updates-2022-03-09' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge tag 'linux-can-next-for-5.18-20220310' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      net: account alternate interface name memory
      net: limit altnames to 64k total
      Merge branch 'net-control-the-length-of-the-altname-list'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'net-ipa-use-bulk-interconnect-interfaces'
      Merge tag 'wireless-next-2022-03-11' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
      net: remove exports for netdev_name_node_alt_create() and destroy
      nfp: remove define for an unused control bit
      nfp: sort the device ID tables
      nfp: introduce dev_info static chip data
      nfp: use dev_info for PCIe config space BAR offsets
      nfp: use dev_info for the DMA mask
      nfp: parametrize QCP offset/size using dev_info
      nfp: take chip version into account for ring sizes
      Merge branch 'nfp-preliminary-support-for-nfp-3800'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      devlink: expose instance locking and add locked port registering
      eth: nfp: wrap locking assertions in helpers
      eth: nfp: replace driver's "pf" lock with devlink instance lock
      eth: mlxsw: switch to explicit locking for port registration
      devlink: hold the instance lock in port_split / port_unsplit callbacks
      devlink: pass devlink_port to port_split / port_unsplit callbacks
      Merge branch 'devlink-expose-instance-locking-and-simplify-port-splitting'
      Merge tag 'linux-can-next-for-5.18-20220316' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge branch 'flow_offload-add-tc-vlan-push_eth-and-pop_eth-actions'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'net-bridge-multiple-spanning-trees'
      Merge branch 'mirroring-for-ocelot-switches'
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge branch 'ipv4-handle-tos-and-scope-properly-for-icmp-redirects-and-pmtu-updates'
      Merge tag 'for-net-next-2022-03-18' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      nfp: calculate ring masks without conditionals
      nfp: move the fast path code to separate files
      nfp: use callbacks for slow path ring related functions
      nfp: prepare for multi-part descriptors
      nfp: move tx_ring->qcidx into cold data
      nfp: use TX ring pointer write back
      nfp: add per-data path feature mask
      nfp: choose data path based on version
      nfp: add support for NFDK data path
      bnxt: use the devlink instance lock to protect sriov
      devlink: add explicitly locked flavor of the rate node APIs
      netdevsim: replace port_list_lock with devlink instance lock
      netdevsim: replace vfs_lock with devlink instance lock
      devlink: hold the instance lock during eswitch_mode callbacks
      tcp: ensure PMTU updates are processed during fastopen
      Merge branch 'net-tls-some-optimizations-for-tls'
      Merge branch 'net-dsa-mv88e6xxx-mst-fixes'
      Merge branch 'net-mscc-miim-add-integrated-phy-reset-support'
      netdevice: add missing dm_private kdoc
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge branch 'ice-avoid-sleeping-scheduling-in-atomic-contexts'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net

Jakub Sitnicki (11):
      bpf: Make dst_port field in struct bpf_sock 16-bit wide
      selftests/bpf: Extend verifier and bpf_sock tests for dst_port loads
      bpf: Make remote_port field in struct bpf_sk_lookup 16-bit wide
      selftests/bpf: Cover 4-byte load from remote_port in bpf_sk_lookup
      selftests/bpf: Fix error reporting from sock_fields programs
      selftests/bpf: Check dst_port only on the client socket
      selftests/bpf: Use constants for socket states in sock_fields test
      selftests/bpf: Fix test for 4-byte load from dst_port on big-endian
      bpf: Treat bpf_sk_lookup remote_port as a 2-byte field
      selftests/bpf: Fix u8 narrow load checks for bpf_sk_lookup remote_port
      selftests/bpf: Fix test for 4-byte load from remote_port on big-endian

Jason A. Donenfeld (1):
      ath9k: use hw_random API instead of directly dumping into random.c

Jedrzej Jagielski (4):
      i40e: Add sending commands in atomic context
      i40e: Add new versions of send ASQ command functions
      i40e: Add new version of i40e_aq_add_macvlan function
      i40e: Fix race condition while adding/deleting MAC/VLAN filters

Jeremy Kerr (6):
      mctp: tests: Rename FL_T macro to FL_TO
      mctp: tests: Add key state tests
      mctp: Add helper for address match checking
      mctp: Allow keys matching any local address
      mctp: replace mctp_address_ok with more fine-grained helpers
      mctp: add address validity checking for packet receive

Jeremy Linton (1):
      net: bcmgenet: Use stronger register read/writes to assure ordering

Jia Ding (1):
      cfg80211: Add support for EHT 320 MHz channel width

Jianbo Liu (2):
      net: flow_offload: add tc police action parameters
      flow_offload: reject offload for all drivers with invalid police parameters

Jiapeng Chong (3):
      mac80211: Remove redundent assignment channel_type
      net: ethernet: sun: Remove redundant code
      netfilter: bridge: clean up some inconsistent indenting

Jiasheng Jiang (1):
      ray_cs: Check ioremap return value

Jiri Kosina (1):
      rtw89: fix RCU usage in rtw89_core_txq_push()

Jiri Olsa (17):
      bpftool: Fix pretty print dump for maps without BTF loaded
      ftrace: Add ftrace_set_filter_ips function
      lib/sort: Add priv pointer to swap function
      kallsyms: Skip the name search for empty string
      bpf: Add multi kprobe link
      bpf: Add bpf_get_func_ip kprobe helper for multi kprobe link
      bpf: Add support to inline bpf_get_func_ip helper on x86
      bpf: Add cookie support to programs attached with kprobe multi link
      libbpf: Add libbpf_kallsyms_parse function
      libbpf: Add bpf_link_create support for multi kprobes
      libbpf: Add bpf_program__attach_kprobe_multi_opts function
      selftests/bpf: Add kprobe_multi attach test
      selftests/bpf: Add kprobe_multi bpf_cookie test
      selftests/bpf: Add attach test for bpf_program__attach_kprobe_multi_opts
      selftests/bpf: Add cookie test for bpf_program__attach_kprobe_multi_opts
      Revert "bpf: Add support to inline bpf_get_func_ip helper on x86"
      bpf: Fix kprobe_multi return probe backtrace

Jiri Pirko (6):
      mlxsw: spectrum: Set basic trap groups from an array
      mlxsw: core: Move basic_trap_groups_set() call out of EMAD init code
      mlxsw: core: Move basic trap group initialization from spectrum.c
      mlxsw: core: Move functions to register/unregister array of traps to core.c
      mlxsw: core: Consolidate trap groups to a single event group
      mlxsw: spectrum: Remove SP{1,2,3} defines for FW minor and subminor

Jisheng Zhang (2):
      net: use bool values to pass bool param of phy_init_eee()
      net: stmmac: dwmac-sun8i: make clk really gated during rpm suspended

Joanne Koong (3):
      bpf: Enable non-atomic allocations in local storage
      selftests/bpf: Test for associating multiple elements with the local storage
      bpf: Fix warning for cast from restricted gfp_t in verifier

Joe Damato (11):
      i40e: Remove unused RX realloc stat
      i40e: Remove rx page reuse double count
      i40e: Aggregate and export RX page reuse stat
      i40e: Add a stat tracking new RX page allocations
      i40e: Add a stat for tracking pages waived
      i40e: Add a stat for tracking busy rx pages
      page_pool: Add allocation stats
      page_pool: Add recycle stats
      page_pool: Add function to batch and return stats
      Documentation: update networking/page_pool.rst
      mlx5: add support for page_pool_get_stats

Johan Almbladh (1):
      mt76: mt7915: fix injected MPDU transmission to not use HW A-MSDU

Johannes Berg (49):
      mac80211: limit bandwidth in HE capabilities
      cfg80211/mac80211: assume CHECKSUM_COMPLETE includes SNAP
      ieee80211: fix -Wcast-qual warnings
      cfg80211: fix -Wcast-qual warnings
      ieee80211: radiotap: fix -Wcast-qual warnings
      mac80211: airtime: avoid variable shadowing
      cfg80211: pmsr: remove useless ifdef guards
      mac80211: remove unused macros
      ieee80211: use tab to indent struct ieee80211_neighbor_ap_info
      nl80211: use RCU to read regdom in reg get/dump
      ieee80211: add helper to check HE capability element size
      mac80211: parse only HE capability elements with valid size
      nl80211: accept only HE capability elements with valid size
      mac80211_hwsim: check TX and STA bandwidth
      mac80211_hwsim: don't shadow a global variable
      iwlwifi: prefer WIDE_ID() over iwl_cmd_id()
      iwlwifi: mvm: fw: clean up hcmd struct creation
      iwlwifi: make iwl_fw_lookup_cmd_ver() take a cmd_id
      iwlwifi: fix various more -Wcast-qual warnings
      iwlwifi: avoid void pointer arithmetic
      iwlwifi: mvm: refactor iwl_mvm_sta_rx_agg()
      iwlwifi: mvm: support new BAID allocation command
      iwlwifi: mvm: align locking in D3 test debugfs
      iwlwifi: mvm: support v3 of station HE context command
      iwlwifi: fw: make dump_start callback void
      iwlwifi: move symbols into a separate namespace
      iwlwifi: dbg-tlv: clean up iwl_dbg_tlv_update_drams()
      iwlwifi: avoid variable shadowing
      iwlwifi: make some functions friendly to sparse
      iwlwifi: mei: avoid -Wpointer-arith and -Wcast-qual warnings
      iwlwifi: pcie: adjust to Bz completion descriptor
      iwlwifi: drv: load tlv debug data earlier
      iwlwifi: eeprom: clean up macros
      iwlwifi: remove unused macros
      iwlwifi: debugfs: remove useless double condition
      iwlwifi: mei: use C99 initializer for device IDs
      iwlwifi: mvm: make iwl_mvm_reconfig_scd() static
      iwlwifi: make iwl_txq_dyn_alloc_dma() return the txq
      iwlwifi: remove command ID argument from queue allocation
      iwlwifi: mvm: remove iwl_mvm_disable_txq() flags argument
      iwlwifi: support new queue allocation command
      iwlwifi: api: remove ttl field from TX command
      iwlwifi: mvm: update BAID allocation command again
      rtw89: fix HE PHY bandwidth capability
      iwlwifi: mvm: remove cipher scheme support
      iwlwifi: pcie: fix SW error MSI-X mapping
      iwlwifi: use 4k queue size for Bz A-step
      mac80211: always have ieee80211_sta_restart()
      rfkill: make new event layout opt-in

John Crispin (3):
      ath11k: add WMI calls to manually add/del/pause/resume TWT dialogs
      ath11k: add debugfs for TWT debug calls
      mac80211: MBSSID channel switch

Johnson Lin (1):
      rtw89: refine DIG feature to support 160M and CCK PD

Jonathan Lemon (18):
      docs: ABI: Document new timecard sysfs nodes.
      ptp: ocp: Add serial port information to the debug summary
      ptp: ocp: correct label for error path
      ptp: ocp: add nvmem interface for accessing eeprom
      ptp: ocp: Update devlink firmware display path.
      ptp: ocp: add UPF_NO_THRE_TEST flag for serial ports
      ptp: ocp: Add support for selectable SMA directions.
      ptp: ocp: Add ability to disable input selectors.
      ptp: ocp: Rename output selector 'GNSS' to 'GNSS1'
      ptp: ocp: Add GND and VCC output selectors
      ptp: ocp: Add firmware capability bits for feature gating
      ptp: ocp: Add signal generators and update sysfs nodes
      ptp: ocp: Program the signal generators via PTP_CLK_REQ_PEROUT
      ptp: ocp: Add 4 frequency counters
      ptp: ocp: Add 2 more timestampers
      docs: ABI: Document new timecard sysfs nodes.
      ptp: ocp: Fix PTP_PF_* verification requests
      ptp: ocp: Make debugfs variables the correct bitwidth

Jonathan Teh (1):
      rtlwifi: rtl8192cu: Add On Networks N150

Jonathan Toppins (1):
      ice: change "can't set link" message to dbg level

Joseph CHAMG (2):
      dt-bindings: net: Add Davicom dm9051 SPI ethernet controller
      net: Add dm9051 driver

Juhee Kang (3):
      net: hsr: use hlist_head instead of list_head for mac addresses
      net: hsr: fix suspicious RCU usage warning in hsr_node_get_first()
      net: hsr: fix hsr build error when lockdep is not enabled

Julia Lawall (9):
      net: moxa: use GFP_KERNEL
      drivers: net: packetengines: fix typos in comments
      net/mlx4_en: use kzalloc
      zd1201: use kzalloc
      rtlwifi: rtl8821ae: fix typos in comments
      airo: fix typos in comments
      mt76: mt7915: fix typos in comments
      can: ucan: fix typos in comments
      bpf, arm: Fix various typos in comments

Justin Iurman (2):
      uapi: ioam: Insertion frequency
      ipv6: ioam: Insertion frequency in lwtunnel output

KP Singh (2):
      bpf/docs: Update vmtest docs for static linking
      bpf/docs: Update list of architectures supported.

Kaixi Fan (1):
      selftests/bpf: Fix tunnel remote IP comments

Kalash Nainwal (1):
      Generate netlink notification when default IPv6 route preference changes

Kalesh AP (4):
      bnxt_en: refactor error handling of HWRM_NVM_INSTALL_UPDATE
      bnxt_en: add more error checks to HWRM_NVM_INSTALL_UPDATE
      bnxt_en: parse result field when NVRAM package install fails
      bnxt_en: implement hw health reporter

Kalle Valo (10):
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      ath11k: pci: fix crash on suspend if board file is not found
      ath11k: mhi: use mhi_sync_power_up()
      Merge tag 'mt76-for-kvalo-2022-02-04' of https://github.com/nbd168/wireless into main
      Merge tag 'iwlwifi-next-for-kalle-2022-02-18' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      Merge tag 'mt76-for-kvalo-2022-02-24' of https://github.com/nbd168/wireless
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge tag 'iwlwifi-next-for-kalle-2022-03-10' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge tag 'mt76-for-kvalo-2022-03-16' of https://github.com/nbd168/wireless

Karol Kolacinski (1):
      ice: add TTY for GNSS module for E810T device

Karthikeyan Kathirvel (1):
      ath11k: fix destination monitor ring out of sync

Karthikeyan Periyasamy (1):
      ath11k: Refactor the fallback routine when peer create fails

Kees Cook (2):
      etherdevice: Adjust ether_addr* prototypes to silence -Wstringop-overead
      iwlwifi: dbg_ini: Split memcpy() to avoid multi-field write

Kenny Yu (4):
      bpf: Add support for bpf iterator programs to use sleepable helpers
      bpf: Add bpf_copy_from_user_task() helper
      libbpf: Add "iter.s" section for sleepable bpf iterator programs
      selftests/bpf: Add test for sleepable bpf iterator programs

Kenta Tada (4):
      selftests/bpf: Extract syscall wrapper
      libbpf: Fix the incorrect register read for syscalls on x86_64
      selftests/bpf: Add a test to confirm PT_REGS_PARM4_SYSCALL
      bpf: make bpf_copy_from_user_task() gpl only

Kevin Mitchell (1):
      netfilter: conntrack: mark UDP zero checksum as CHECKSUM_UNNECESSARY

Kiran K (1):
      Bluetooth: btusb: Add support for Intel Madison Peak (MsP2) device

Krasnov Arseniy Vladimirovich (2):
      af_vsock: SOCK_SEQPACKET receive timeout test
      af_vsock: SOCK_SEQPACKET broken buffer test

Krzysztof Kozlowski (6):
      nfc: llcp: nullify llcp_sock->dev on connect() error paths
      nfc: llcp: simplify llcp_sock_connect() error paths
      nfc: llcp: use centralized exiting of bind on errors
      nfc: llcp: use test_bit()
      nfc: llcp: protect nfc_llcp_sock_unlink() calls
      nfc: llcp: Revert "NFC: Keep socket alive until the DISC PDU is actually sent"

Kui-Feng Lee (2):
      libbpf: Improve btf__add_btf() with an additional hashmap for strings.
      scripts/pahole-flags.sh: Parse DWARF and generate BTF with multithreading.

Kumar Kartikeya Dwivedi (22):
      bpf: Fix UAF due to race between btf_try_get_module and load_module
      bpf: Populate kfunc BTF ID sets in struct btf
      bpf: Remove check_kfunc_call callback and old kfunc BTF ID API
      bpf: Introduce mem, size argument pair support for kfunc
      bpf: Add reference tracking support to kfunc
      net/netfilter: Add unstable CT lookup helpers for XDP and TC-BPF
      selftests/bpf: Add test for unstable CT lookup API
      selftests/bpf: Add test_verifier support to fixup kfunc call insns
      selftests/bpf: Extend kfunc selftests
      selftests/bpf: Add test for race in btf_try_get_module
      selftests/bpf: Do not fail build if CONFIG_NF_CONNTRACK=m/n
      selftests/bpf: Add test for reg2btf_ids out of bounds access
      bpf: Add check_func_arg_reg_off function
      bpf: Fix PTR_TO_BTF_ID var_off check
      bpf: Disallow negative offset in check_ptr_off_reg
      bpf: Harden register offset checks for release helpers and kfuncs
      compiler_types.h: Add unified __diag_ignore_all for GCC/LLVM
      bpf: Replace __diag_ignore with unified __diag_ignore_all
      selftests/bpf: Add tests for kfunc register offset checks
      bpf: Factor out fd returning from bpf_btf_find_by_name_kind
      bpf: Always raise reference in btf_get_module_btf
      bpf: Check for NULL return from bpf_get_btf_vmlinux

Kuniyuki Iwashima (8):
      af_unix: Refactor unix_next_socket().
      bpf: af_unix: Use batching algorithm in bpf unix iter.
      bpf: Support bpf_(get|set)sockopt() in bpf unix iter.
      selftest/bpf: Test batching and bpf_(get|set)sockopt in bpf unix iter.
      selftest/bpf: Fix a stale comment.
      af_unix: Fix some data-races around unix_sk(sk)->oob_skb.
      af_unix: Support POLLPRI for OOB.
      af_unix: Remove unnecessary brackets around CONFIG_AF_UNIX_OOB.

Kurt Kanzenbach (5):
      flow_dissector: Add support for HSR
      ptp: Add generic PTP is_sync() function
      dp83640: Use generic ptp_msg_is_sync() function
      micrel: Use generic ptp_msg_is_sync() function
      flow_dissector: Add support for HSRv0

Lad Prabhakar (3):
      ath10k: Use platform_get_irq() to get the interrupt
      wcn36xx: Use platform_get_irq_byname() to get the interrupt
      net: ethernet: ti: davinci_emac: Use platform_get_irq() to get the interrupt

Larry Finger (1):
      Bluetooth: btusb: Add one more Bluetooth part for the Realtek RTL8852AE

Leon Romanovsky (3):
      xfrm: delete duplicated functions that calls same xfrm_api_check()
      net/mlx4: Delete useless moduleparam include
      net/mlx5: Delete useless module.h include

Leon Yen (1):
      mt76: mt7921s: fix mt7921s_mcu_[fw|drv]_pmctrl

Lianjie Zhang (1):
      bonding: helper macro __ATTR_RO to make code more clear

Linus Lüssing (1):
      mac80211: fix potential double free on mesh join

Lorenz Bauer (1):
      bpf: Remove Lorenz Bauer from L7 BPF maintainers

Lorenzo Bianconi (116):
      bpf: selftests: Get rid of CHECK macro in xdp_adjust_tail.c
      bpf: selftests: Get rid of CHECK macro in xdp_bpf2bpf.c
      net: skbuff: add size metadata to skb_shared_info for xdp
      xdp: introduce flags field in xdp_buff/xdp_frame
      net: mvneta: update frags bit before passing the xdp buffer to eBPF layer
      net: mvneta: simplify mvneta_swbm_add_rx_fragment management
      net: xdp: add xdp_update_skb_shared_info utility routine
      net: marvell: rely on xdp_update_skb_shared_info utility routine
      xdp: add frags support to xdp_return_{buff/frame}
      net: mvneta: add frags support to XDP_TX
      bpf: introduce BPF_F_XDP_HAS_FRAGS flag in prog_flags loading the ebpf program
      net: mvneta: enable jumbo frames if the loaded XDP program support frags
      bpf: introduce bpf_xdp_get_buff_len helper
      bpf: move user_size out of bpf_test_init
      bpf: introduce frags support to bpf_prog_test_run_xdp()
      bpf: test_run: add xdp_shared_info pointer in bpf_test_finish signature
      libbpf: Add SEC name for xdp frags programs
      net: xdp: introduce bpf_xdp_pointer utility routine
      bpf: selftests: introduce bpf_xdp_{load,store}_bytes selftest
      bpf: selftests: add CPUMAP/DEVMAP selftests for xdp frags
      xdp: disable XDP_REDIRECT for xdp frags
      net: ethernet: mtk_star_emac: fix unused variable
      net: mvneta: remove unnecessary if condition in mvneta_xdp_submit_frame
      libbpf: Deprecate xdp_cpumap, xdp_devmap and classifier sec definitions
      selftests/bpf: Update cpumap/devmap sec_name
      samples/bpf: Update cpumap/devmap sec_name
      mt76: connac: fix sta_rec_wtbl tag len
      mt76: mt7915: rely on mt76_connac_mcu_alloc_sta_req
      mt76: mt7915: rely on mt76_connac_mcu_alloc_wtbl_req
      mt76: mt7915: rely on mt76_connac_mcu_add_tlv routine
      mt76: connac: move mt76_connac_mcu_get_cipher in common code
      mt76: connac: move mt76_connac_chan_bw in common code
      mt76: mt7915: rely on mt76_connac_get_phy utilities
      mt76: connac: move mt76_connac_mcu_add_key in connac module
      mt76: make mt76_sar_capa static
      mt76: mt7915: use proper aid value in mt7915_mcu_wtbl_generic_tlv in sta mode
      mt76: mt7915: use proper aid value in mt7915_mcu_sta_basic_tlv
      mt76: mt7915: remove duplicated defs in mcu.h
      mt76: connac: move mt76_connac_mcu_bss_omac_tlv in connac module
      mt76: connac: move mt76_connac_mcu_bss_ext_tlv in connac module
      mt76: connac: move mt76_connac_mcu_bss_basic_tlv in connac module
      mt76: mt7915: rely on mt76_connac_mcu_sta_ba_tlv
      mt76: mt7915: rely on mt76_connac_mcu_wtbl_ba_tlv
      mt76: mt7915: rely on mt76_connac_mcu_sta_ba
      mt76: mt7915: rely on mt76_connac_mcu_wtbl_generic_tlv
      mt76: mt7915: rely on mt76_connac_mcu_sta_basic_tlv
      mt76: mt7915: rely on mt76_connac_mcu_sta_uapsd
      mt76: mt7915: rely on mt76_connac_mcu_wtbl_smps_tlv
      mt76: mt7915: rely on mt76_connac_mcu_wtbl_ht_tlv
      mt76: mt7915: rely on mt76_connac_mcu_wtbl_hdr_trans_tlv
      mt76: connac: move mt76_connac_mcu_wtbl_update_hdr_trans in connac module
      mt76: connac: introduce is_connac_v1 utility routine
      mt76: connac: move mt76_connac_mcu_set_pm in connac module
      mt76: mt7921: get rid of mt7921_mcu_get_eeprom
      mt76: mt7915: rely on mt76_connac_mcu_start_firmware
      mt76: connac: move mt76_connac_mcu_restart in common module
      mt76: mt7915: rely on mt76_connac_mcu_patch_sem_ctrl/mt76_connac_mcu_start_patch
      mt76: mt7915: rely on mt76_connac_mcu_init_download
      mt76: connac: move mt76_connac_mcu_gen_dl_mode in mt76-connac module
      mt76: mt7915: rely on mt76_connac_mcu_set_rts_thresh
      mt76: connac: move mt76_connac_mcu_rdd_cmd in mt76-connac module
      mt76: mt7615: fix a possible race enabling/disabling runtime-pm
      mt76: mt7921e: process txfree and txstatus without allocating skbs
      mt76: mt7615e: process txfree and txstatus without allocating skbs
      mt76: mt7921: do not always disable fw runtime-pm
      mt76: mt7921: fix a leftover race in runtime-pm
      mt76: mt7615: fix a leftover race in runtime-pm
      mt76: mt7921: fix endianness issues in mt7921_mcu_set_tx()
      mt76: mt7921: toggle runtime-pm adding a monitor vif
      mt76: mt7915: introduce mt7915_set_radar_background routine
      mt76: mt7915: enable radar trigger on rdd2
      mt76: mt7915: introduce rdd_monitor debugfs node
      mt76: mt7915: report radar pattern if detected by rdd2
      mt76: mt7915: enable radar background detection
      dt-bindings:net:wireless:mediatek,mt76: add disable-radar-offchan
      mt76: connac: move mt76_connac_lmac_mapping in mt76-connac module
      mt76: mt7915: add missing DATA4_TB_SPTL_REUSE1 to mt7915_mac_decode_he_radiotap
      mt76: mt7921: remove duplicated code in mt7921_mac_decode_he_radiotap
      mt76: mt7663s: flush runtime-pm queue after waking up the device
      mt76: mt7603: check sta_rates pointer in mt7603_sta_rate_tbl_update
      mt76: mt7615: check sta_rates pointer in mt7615_sta_rate_tbl_update
      mt76: mt7915: fix possible memory leak in mt7915_mcu_add_sta
      mt76: mt7921s: fix a possible memory leak in mt7921_load_patch
      mt76: do not always copy ethhdr in reverse_frag0_hdr_trans
      mt76: dma: initialize skip_unmap in mt76_dma_rx_fill
      bpf: test_run: Fix OOB access in bpf_prog_test_run_xdp
      selftest/bpf: Check invalid length in test_xdp_update_frags
      mt76: mt7615: introduce SAR support
      mt76: fix endianness errors in reverse_frag0_hdr_trans
      mt76: mt7915: fix endianness warnings in mt7915_debugfs_rx_fw_monitor
      mt76: mt7915: fix endianness warnings in mt7915_mac_tx_free()
      mt76: mt7921: fix injected MPDU transmission to not use HW A-MSDU
      net: netsec: enable pp skb recycling
      MAINTAINERS: add devicetree bindings entry for mt76
      mac80211: MBSSID beacon handling in AP mode
      mac80211: update bssid_indicator in ieee80211_assign_beacon
      mt76: mt7615: honor ret from mt7615_mcu_restart in mt7663u_mcu_init
      mt76: mt7663u: introduce mt7663u_mcu_power_on routine
      mt76: mt7921: make mt7921_init_tx_queues static
      mt76: mt7921: fix xmit-queue dump for usb and sdio
      mt76: mt7921: fix mt7921_queues_acq implementation
      mt76: mt7921: get rid of mt7921_wait_for_mcu_init declaration
      mt76: usb: add req_type to ___mt76u_rr signature
      mt76: usb: add req_type to ___mt76u_wr signature
      mt76: usb: introduce __mt76u_init utility routine
      mt76: mt7921: disable runtime pm for usb
      mt76: mt7921: update mt7921_skb_add_usb_sdio_hdr to support usb
      mt76: mt7921: move mt7921_usb_sdio_tx_prepare_skb in common mac code
      mt76: mt7921: move mt7921_usb_sdio_tx_complete_skb in common mac code.
      mt76: mt7921: move mt7921_usb_sdio_tx_status_data in mac common code.
      mt76: mt7921: add mt7921u driver
      mt76: mt7921: move mt7921_init_hw in a dedicated work
      mt76: mt7915: introduce 802.11ax multi-bss support
      net: veth: Account total xdp_frame len running ndo_xdp_xmit
      veth: Rework veth_xdp_rcv_skb in order to accept non-linear skb
      veth: Allow jumbo frames in xdp mode

Louis Peens (1):
      net/sched: fix incorrect vlan_push_eth dest field

Lu Jicong (1):
      rtlwifi: rtl8192ce: remove duplicated function '_rtl92ce_phy_set_rf_sleep'

Luca Coelho (7):
      iwlwifi: mvm: don't iterate unadded vifs when handling FW SMPS req
      iwlwifi: read and print OTP minor version
      iwlwifi: remove unused DC2DC_CONFIG_CMD definitions
      iwlwifi: mvm: don't send BAID removal to the FW during hw_restart
      iwlwifi: fix small doc mistake for iwl_fw_ini_addr_val
      iwlwifi: bump FW API to 71 for AX devices
      iwlwifi: bump FW API to 72 for AX devices

Luca Weiss (1):
      Bluetooth: hci_bcm: add BCM43430A0 & BCM43430A1

Luiz Angelo Daros de Luca (22):
      net: dsa: realtek-smi: fix kdoc warnings
      net: dsa: realtek-smi: move to subdirectory
      net: dsa: realtek: rename realtek_smi to realtek_priv
      net: dsa: realtek: remove direct calls to realtek-smi
      net: dsa: realtek: convert subdrivers into modules
      net: dsa: realtek: add new mdio interface for drivers
      net: dsa: realtek: rtl8365mb: rename extport to extint
      net: dsa: realtek: rtl8365mb: use GENMASK(n-1,0) instead of BIT(n)-1
      net: dsa: realtek: rtl8365mb: use DSA CPU port
      net: dsa: realtek: rtl8365mb: add RTL8367S support
      net: dsa: realtek: rtl8365mb: add RTL8367RB-VB support
      net: dsa: realtek: rtl8365mb: allow non-cpu extint ports
      net: dsa: realtek: rtl8365mb: fix trap_door > 7
      net: dsa: typo in comment
      dt-bindings: net: dsa: realtek: convert to YAML schema, add MDIO
      net: dsa: realtek: rename macro to match filename
      net: dsa: realtek: realtek-smi: clean-up reset
      net: dsa: realtek: realtek-mdio: reset before setup
      dt-bindings: net: dsa: add rtl8_4 and rtl8_4t tag formats
      net: dsa: tag_rtl8_4: add rtl8_4t trailing variant
      net: dsa: realtek: rtl8365mb: add support for rtl8_4t
      net: dsa: tag_rtl8_4: fix typo in modalias name

Luiz Augusto von Dentz (7):
      Bluetooth: hci_sync: Fix compilation warning
      Bluetooth: hci_core: Rate limit the logging of invalid SCO handle
      Bluetooth: hci_event: Fix HCI_EV_VENDOR max_len
      Bluetooth: hci_sync: Fix queuing commands when HCI_UNREGISTER is set
      Bluetooth: Fix not checking for valid hdev on bt_dev_{info,warn,err,dbg}
      Bluetooth: btusb: Make use of of BIT macro to declare flags
      Bluetooth: Fix use after free in hci_send_acl

Lukas Bulwahn (2):
      MAINTAINERS: rectify entry for REALTEK RTL83xx SMI DSA ROUTER CHIPS
      MAINTAINERS: fix ath11k DT bindings location

Lv Ruyi (CGEL ZTE) (1):
      ath11k: remove unneeded flush_workqueue

M Chetan Kumar (3):
      net: wwan: iosm: Enable M.2 7360 WWAN card support
      net: wwan: debugfs obtained dev reference not dropped
      net: wwan: iosm: drop debugfs dev reference

Maciej Fijalkowski (9):
      ice: Remove likely for napi_complete_done
      ice: xsk: Force rings to be sized to power of 2
      ice: xsk: Handle SW XDP ring wrap and bump tail more often
      ice: Make Tx threshold dependent on ring length
      ice: xsk: Avoid potential dead AF_XDP Tx processing
      ice: xsk: Improve AF_XDP ZC Tx and use batching API
      ice: xsk: Borrow xdp_tx_active logic from i40e
      ice: xsk: fix GCC version checking against pragma unroll presence
      ice: avoid XDP checks in ice_clean_tx_irq()

Maciek Machnikowski (1):
      testptp: add option to shift clock by nanoseconds

Magnus Karlsson (4):
      selftests, xsk: Fix rx_full stats test
      i40e: xsk: Move tmp desc array from driver to pool
      selftests, xsk: Fix bpf_res cleanup test
      xsk: Fix race at socket teardown

Manish Chopra (2):
      qed: display VF trust config
      qed: validate and restrict untrusted VFs vlan promisc mode

Manish Mandlik (4):
      Bluetooth: msft: Handle MSFT Monitor Device Event
      Bluetooth: mgmt: Add MGMT Adv Monitor Device Found/Lost events
      Bluetooth: msft: Clear tracked devices on resume
      Bluetooth: Send AdvMonitor Dev Found for all matched devices

Maor Dickman (3):
      net/sched: add vlan push_eth and pop_eth action to the hardware IR
      net/mlx5e: MPLSoUDP decap, use vlan push_eth instead of pedit
      net/mlx5e: MPLSoUDP encap, support action vlan pop_eth explicitly

Marc Kleine-Budde (59):
      dt-binding: can: mcp251xfd: include common CAN controller bindings
      dt-binding: can: sun4i_can: include common CAN controller bindings
      dt-binding: can: m_can: list Chandrasekar Ramakrishnan as maintainer
      dt-binding: can: m_can: fix indention of table in bosch,mram-cfg description
      dt-binding: can: m_can: include common CAN controller bindings
      can: bittiming: can_validate_bitrate(): simplify bit rate checking
      can: bittiming: mark function arguments and local variables as const
      can: kvaser_usb: kvaser_usb_send_cmd(): remove redundant variable actual_len
      can: c_can: ethtool: use default drvinfo
      can: mcp251xfd: mcp251xfd_reg_invalid(): rename from mcp251xfd_osc_invalid()
      can: mcp251xfd: mcp251xfd_regmap_crc_read(): ignore CRC error only if solely OSC register is read
      can: mcp251xfd: mcp251xfd_unregister(): simplify runtime PM handling
      can: mcp251xfd: mcp251xfd_chip_sleep(): introduce function to bring chip into sleep mode
      can: mcp251xfd: mcp251xfd_chip_stop(): convert to a void function
      can: mcp251xfd: mcp251xfd_chip_wait_for_osc_ready(): factor out into separate function
      can: mcp251xfd: mcp251xfd_chip_wait_for_osc_ready(): improve chip detection and error handling
      can: mcp251xfd: mcp251xfd_chip_wait_for_osc_ready(): prepare for PLL support
      can: mcp251xfd: mcp251xfd_chip_softreset_check(): wait for OSC ready before accessing chip
      can: mcp251xfd: mcp251xfd_chip_timestamp_init(): factor out into separate function
      can: mcp251xfd: mcp251xfd_chip_wake(): renamed from mcp251xfd_chip_clock_enable()
      can: mcp251xfd: __mcp251xfd_chip_set_mode(): prepare for PLL support: improve error handling and diagnostics
      can: mcp251xfd: mcp251xfd_chip_clock_init(): prepare for PLL support, wait for OSC ready
      can: mcp251xfd: mcp251xfd_register(): prepare to activate PLL after softreset
      can: mcp251xfd: add support for internal PLL
      can: mcp251xfd: introduce struct mcp251xfd_tx_ring::nr and ::fifo_nr and make use of it
      can: mcp251xfd: mcp251xfd_ring_init(): split ring_init into separate functions
      can: mcp251xfd: ring: prepare to change order of TX and RX FIFOs
      can: mcp251xfd: ring: change order of TX and RX FIFOs
      can: mcp251xfd: ring: mcp251xfd_ring_init(): checked RAM usage of ring setup
      can: mcp251xfd: ring: update FIFO setup debug info
      can: mcp251xfd: prepare for multiple RX-FIFOs
      can: mcp251xfd: mcp251xfd_priv: introduce macros specifying the number of supported TEF/RX/TX rings
      can: gs_usb: use consistent one space indention
      can: gs_usb: fix checkpatch warning
      can: gs_usb: sort include files alphabetically
      can: gs_usb: GS_CAN_FLAG_OVERFLOW: make use of BIT()
      can: gs_usb: rewrap error messages
      can: gs_usb: rewrap usb_control_msg() and usb_fill_bulk_urb()
      can: gs_usb: gs_make_candev(): call SET_NETDEV_DEV() after handling all bt_const->feature
      can: gs_usb: add HW timestamp mode bit
      can: gs_usb: update GS_CAN_FEATURE_IDENTIFY documentation
      can: gs_usb: document the USER_ID feature
      can: gs_usb: document the PAD_PKTS_TO_MAX_PKT_SIZE feature
      can: gs_usb: gs_usb_probe(): introduce udev and make use of it
      can: gs_usb: support up to 3 channels per device
      can: gs_usb: add quirk for CANtact Pro overlapping GS_USB_BREQ value
      can: vxcan: vxcan_xmit(): use kfree_skb() instead of kfree() to free skb
      can: mcp251xfd: mcp251xfd_ring_init(): use %d to print free RAM
      can: mcp251xfd: ram: add helper function for runtime ring size calculation
      can: mcp251xfd: ram: coalescing support
      can: mcp251xfd: ethtool: add support
      can: mcp251xfd: ring: prepare support for runtime configurable RX/TX ring parameters
      can: mcp251xfd: update macros describing ring, FIFO and RAM layout
      can: mcp251xfd: ring: add support for runtime configurable RX/TX ring parameters
      can: mcp251xfd: add RX IRQ coalescing support
      can: mcp251xfd: add RX IRQ coalescing ethtool support
      can: mcp251xfd: add TX IRQ coalescing support
      can: mcp251xfd: add TX IRQ coalescing ethtool support
      can: mcp251xfd: ring: increase number of RX-FIFOs to 3 and increase max TX-FIFO depth to 16

Marcel Holtmann (1):
      Bluetooth: Increment management interface revision

Marcin Szycik (2):
      ice: Add slow path offload stats on port representor in switchdev
      ice: Support GTP-U and GTP-C offload in switchdev

Marek Behún (1):
      dt-bindings: phy: Add `tx-p2p-microvolt` property binding

Mark Bloch (7):
      net/mlx5: Add ability to insert to specific flow group
      net/mlx5: E-switch, remove special uplink ingress ACL handling
      net/mlx5: E-switch, add drop rule support to ingress ACL
      net/mlx5: Lag, use local variable already defined to access E-Switch
      net/mlx5: Lag, don't use magic numbers for ports
      net/mlx5: Lag, record inactive state of bond device
      net/mlx5: Lag, offload active-backup drops to hardware

Mark Chen (6):
      Bluetooth: mt7921s: Support wake on bluetooth
      Bluetooth: mt7921s: Enable SCO over I2S
      Bluetooth: mt7921s: fix firmware coredump retrieve
      Bluetooth: btmtksdio: refactor btmtksdio_runtime_[suspend|resume]()
      Bluetooth: mt7921s: fix bus hang with wrong privilege
      Bluetooth: mt7921s: fix btmtksdio_[drv|fw]_pmctrl()

Martin Habets (1):
      sfc: The size of the RX recycle ring should be more flexible

Martin KaFai Lau (21):
      net: Add skb->mono_delivery_time to distinguish mono delivery_time from (rcv) timestamp
      net: Add skb_clear_tstamp() to keep the mono delivery_time
      net: Handle delivery_time in skb->tstamp during network tapping with af_packet
      net: Clear mono_delivery_time bit in __skb_tstamp_tx()
      net: Set skb->mono_delivery_time and clear it after sch_handle_ingress()
      net: ip: Handle delivery_time in ip defrag
      net: ipv6: Handle delivery_time in ipv6 defrag
      net: ipv6: Get rcv timestamp if needed when handling hop-by-hop IOAM option
      net: Get rcv tstamp if needed in nfnetlink_{log, queue}.c
      net: Postpone skb_clear_delivery_time() until knowing the skb is delivered locally
      bpf: Keep the (rcv) timestamp behavior for the existing tc-bpf@ingress
      bpf: Add __sk_buff->delivery_time_type and bpf_skb_set_skb_delivery_time()
      bpf: selftests: test skb->tstamp in redirect_neigh
      bpf: net: Remove TC_AT_INGRESS_OFFSET and SKB_MONO_DELIVERY_TIME_OFFSET macro
      bpf: Simplify insn rewrite on BPF_READ __sk_buff->tstamp
      bpf: Simplify insn rewrite on BPF_WRITE __sk_buff->tstamp
      bpf: Remove BPF_SKB_DELIVERY_TIME_NONE and rename s/delivery_time_/tstamp_/
      bpf: selftests: Update tests after s/delivery_time/tstamp/ change in bpf.h
      bpf: selftests: Add helpers to directly use the capget and capset syscall
      bpf: selftests: Remove libcap usage from test_verifier
      bpf: selftests: Remove libcap usage from test_progs

Martyna Szapar-Mudlaw (1):
      ice: Add support for inner etype in switchdev

Masami Hiramatsu (11):
      fprobe: Add ftrace based probe APIs
      rethook: Add a generic return hook
      rethook: x86: Add rethook x86 implementation
      arm64: rethook: Add arm64 rethook implementation
      powerpc: Add rethook support
      ARM: rethook: Add rethook arm implementation
      fprobe: Add exit_handler support
      fprobe: Add sample program for fprobe
      fprobe: Introduce FPROBE_FL_KPROBE_SHARED flag for fprobe
      docs: fprobe: Add fprobe description to ftrace-use.rst
      fprobe: Add a selftest for fprobe

Mat Martineau (1):
      selftests: mptcp: Rename wait function

Mateusz Palczewski (7):
      i40e: Disable hw-tc-offload feature on driver load
      iavf: Add support for 50G/100G in AIM algorithm
      iavf: refactor processing of VLAN V2 capability message
      iavf: Add usage of new virtchnl format to set default MAC
      iavf: stop leaking iavf_status as "errno" values
      iavf: Fix incorrect use of assigning iavf_status to int
      iavf: Remove non-inclusive language

Matt Chen (1):
      iwlwifi: acpi: move ppag code from mvm to fw/acpi

Matt Johnston (9):
      mctp: Add SIOCMCTP{ALLOC,DROP}TAG ioctls for tag control
      dt-bindings: net: New binding mctp-i2c-controller
      mctp i2c: MCTP I2C binding driver
      mctp: make __mctp_dev_get() take a refcount hold
      mctp: Fix incorrect netdev unref for extended addr
      mctp: Fix warnings reported by clang-analyzer
      mctp: Avoid warning if unregister notifies twice
      mctp i2c: Fix potential use-after-free
      mctp i2c: Fix hard head TX bounds length check

Matteo Croce (2):
      bpf: Implement bpf_core_types_are_compat().
      selftests/bpf: Test bpf_core_types_are_compat() functionality.

Matthieu Baerts (18):
      mptcp: reduce branching when writing MP_FAIL option
      mptcp: clarify when options can be used
      mptcp: mptcp_parse_option is no longer exported
      selftests: mptcp: increase timeout to 20 minutes
      selftests: mptcp: join: exit after usage()
      selftests: mptcp: join: remove unused vars
      selftests: mptcp: join: create tmp files only if needed
      selftests: mptcp: join: check for tools only if needed
      selftests: mptcp: join: allow running -cCi
      selftests: mptcp: join: define tests groups once
      selftests: mptcp: join: reset failing links
      selftests: mptcp: join: option to execute specific tests
      selftests: mptcp: join: alt. to exec specific tests
      selftests: mptcp: join: list failure at the end
      selftests: mptcp: join: helper to filter TCP
      selftests: mptcp: join: clarify local/global vars
      selftests: mptcp: join: avoid backquotes
      selftests: mptcp: join: make it shellcheck compliant

Matti Gottlieb (1):
      iwlwifi: pcie: Adapt rx queue write pointer for Bz family

Mauricio Vásquez (12):
      libbpf: Use IS_ERR_OR_NULL() in hashmap__free()
      bpftool: Fix error check when calling hashmap__new()
      libbpf: Remove mode check in libbpf_set_strict_mode()
      bpftool: Fix strict mode calculation
      selftests/bpf: Fix strict mode calculation
      libbpf: Split bpf_core_apply_relo()
      libbpf: Expose bpf_core_{add,free}_cands() to bpftool
      bpftool: Add gen min_core_btf command
      bpftool: Implement "gen min_core_btf" logic
      bpftool: Implement btfgen_get_btf()
      selftests/bpf: Test "bpftool gen min_core_btf"
      bpftool: Remove usage of reallocarray()

Max Chou (1):
      Bluetooth: btrtl: Add support for RTL8852B

Maxim Mikityanskiy (30):
      net/mlx5e: Cleanup of start/stop all queues
      net/mlx5e: Disable TX queues before registering the netdev
      net/mlx5e: Use a barrier after updating txq2sq
      net/mlx5e: Sync txq2sq updates with mlx5e_xmit for HTB queues
      net/mlx5e: Introduce select queue parameters
      net/mlx5e: Move mlx5e_select_queue to en/selq.c
      net/mlx5e: Use select queue parameters to sync with control flow
      net/mlx5e: Move repeating code that gets TC prio into a function
      net/mlx5e: Use READ_ONCE/WRITE_ONCE for DCBX trust state
      net/mlx5e: Optimize mlx5e_select_queue
      net/mlx5e: Optimize modulo in mlx5e_select_queue
      net/mlx5e: Optimize the common case condition in mlx5e_select_queue
      net/mlx5e: Validate MTU when building non-linear legacy RQ fragments info
      net/mlx5e: Add headroom only to the first fragment in legacy RQ
      net/mlx5e: Build SKB in place over the first fragment in non-linear legacy RQ
      net/mlx5e: Drop the len output parameter from mlx5e_xdp_handle
      net/mlx5e: Drop cqe_bcnt32 from mlx5e_skb_from_cqe_mpwrq_linear
      net/mlx5e: Prepare non-linear legacy RQ for XDP multi buffer support
      net/mlx5e: Use fragments of the same size in non-linear legacy RQ with XDP
      net/mlx5e: Use page-sized fragments with XDP multi buffer
      net/mlx5e: Add XDP multi buffer support to the non-linear legacy RQ
      net/mlx5e: Store DMA address inside struct page
      net/mlx5e: Move mlx5e_xdpi_fifo_push out of xmit_xdp_frame
      net/mlx5e: Remove assignment of inline_hdr.sz on XDP TX
      net/mlx5e: Don't prefill WQEs in XDP SQ in the multi buffer mode
      net/mlx5e: Implement sending multi buffer XDP frames
      net/mlx5e: Unindent the else-block in mlx5e_xmit_xdp_buff
      net/mlx5e: Support multi buffer XDP_TX
      net/mlx5e: Permit XDP with non-linear legacy RQ
      net/mlx5e: Remove MLX5E_XDP_TX_DS_COUNT

MeiChia Chiu (6):
      mt76: mt7915: fix the nss setting in bitrates
      mt76: mt7915: fix the muru tlv issue
      mac80211: correct legacy rates check in ieee80211_calc_rx_airtime
      mt76: split single ldpc cap bit into bits
      mt76: connac: add 6 GHz support for wtbl and starec configuration
      mt76: mt7915: add 6 GHz support

Meng Tang (2):
      bcm63xx_enet: Use platform_get_irq() to get the interrupt
      hamradio: Fix wrong assignment of 'bbc->cfg.loopback'

Menglong Dong (28):
      test: selftests: Remove unused various in sockmap_verdict_prog.c
      net: skb_drop_reason: add document for drop reasons
      net: netfilter: use kfree_drop_reason() for NF_DROP
      net: ipv4: use kfree_skb_reason() in ip_rcv_core()
      net: ipv4: use kfree_skb_reason() in ip_rcv_finish_core()
      net: ipv4: use kfree_skb_reason() in ip_protocol_deliver_rcu()
      net: udp: use kfree_skb_reason() in udp_queue_rcv_one_skb()
      net: udp: use kfree_skb_reason() in __udp_queue_rcv_skb()
      net: drop_monitor: support drop reason
      net: tcp: introduce tcp_drop_reason()
      net: tcp: add skb drop reasons to tcp_v4_rcv()
      net: tcp: use kfree_skb_reason() for tcp_v6_rcv()
      net: tcp: add skb drop reasons to tcp_v{4,6}_inbound_md5_hash()
      net: tcp: add skb drop reasons to tcp_add_backlog()
      net: tcp: use kfree_skb_reason() for tcp_v{4,6}_do_rcv()
      net: tcp: use tcp_drop_reason() for tcp_rcv_established()
      net: tcp: use tcp_drop_reason() for tcp_data_queue()
      net: tcp: use tcp_drop_reason() for tcp_data_queue_ofo()
      net: ip: add skb drop reasons for ip egress path
      net: neigh: use kfree_skb_reason() for __neigh_event_send()
      net: neigh: add skb drop reasons to arp_error_report()
      net: dev: use kfree_skb_reason() for sch_handle_egress()
      net: skb: introduce the function kfree_skb_list_reason()
      net: dev: add skb drop reasons to __dev_xmit_skb()
      net: dev: use kfree_skb_reason() for enqueue_to_backlog()
      net: dev: use kfree_skb_reason() for do_xdp_generic()
      net: dev: use kfree_skb_reason() for sch_handle_ingress()
      net: dev: use kfree_skb_reason() for __netif_receive_skb_core()

Mianhan Liu (2):
      Bluetooth: bcm203x: remove superfluous header files
      Bluetooth: ath3k: remove superfluous header files

Miaoqian Lin (1):
      ath10k: Fix error handling in ath10k_setup_msa_resources

Michael Catanzaro (1):
      virtio_net: Fix code indent error

Michael Chan (3):
      bnxt_en: Update firmware interface to 1.10.2.73
      bnxt_en: Properly report no pause support on some cards
      bnxt_en: Eliminate unintended link toggle during FW reset

Michael Sit Wei Hong (1):
      stmmac: intel: Add ADL-N PCI ID

Michael Walle (4):
      net: sfp: add 2500base-X quirk for Lantech SFP module
      dt-bindings: net: mscc-miim: add lan966x compatible
      net: mdio: mscc-miim: replace magic numbers for the bus reset
      net: mdio: mscc-miim: add lan966x internal phy reset support

Michal Swiatkowski (1):
      ice: Fix FV offset searching

Mike Golant (1):
      iwlwifi: add support for BZ-U and BZ-L HW

Miles Hu (1):
      ath11k: enable RX PPDU stats in monitor co-exist mode

Min Li (1):
      ptp: idt82p33: use rsmu driver to access i2c/spi bus

Minghao Chi (6):
      ath9k: remove redundant status variable
      can: softing: softing_netdev_open(): remove redundant ret variable
      iavf: remove redundant ret variable
      Bluetooth: mgmt: Remove unneeded variable
      net: mv643xx_eth: use platform_get_irq() instead of platform_get_resource()
      net: mv643xx_eth: undo some opreations in mv643xx_eth_probe

Minghao Chi (CGEL ZTE) (5):
      net/switchdev: use struct_size over open coded arithmetic
      wcn36xx: use struct_size over open coded arithmetic
      iwlwifi/fw: use struct_size over open coded arithmetic
      iwlwifi: dvm: use struct_size over open coded arithmetic
      Bluetooth: use memset avoid memory leaks

Miquel Raynal (3):
      net: ieee802154: hwsim: Ensure frame checksum are valid
      net: ieee802154: Use the IEEE802154_MAX_PAGE define when relevant
      net: mac802154: Explain the use of ieee802154_wake/stop_queue()

Miri Korenblit (5):
      iwlwifi: mvm: add support for CT-KILL notification version 2
      iwlwifi: mvm: use debug print instead of WARN_ON()
      iwlwifi: mvm: refactor setting PPE thresholds in STA_HE_CTXT_CMD
      iwlwifi: mvm: move only to an enabled channel
      iwlwifi: mvm: Don't fail if PPAG isn't supported

Miroslav Lichvar (4):
      ptp: unregister virtual clocks when unregistering physical clock.
      ptp: increase maximum adjustment of virtual clocks.
      ptp: add gettimex64() to virtual clocks.
      ptp: add getcrosststamp() to virtual clocks.

Mobashshera Rasool (1):
      net: ip6mr: add support for passing full packet on wrong mif

Mordechay Goodstein (15):
      mac80211: consider RX NSS in UHB connection
      mac80211: vht: use HE macros for parsing HE capabilities
      mac80211: mlme: add documentation from spec to code
      mac80211: mlme: validate peer HE supported rates
      ieee80211: add EHT 1K aggregation definitions
      mac80211: calculate max RX NSS for EHT mode
      mac80211: parse AddBA request with extended AddBA element
      iwlwifi: cfg: add support for 1K BA queue
      iwlwifi: dbg: add infra for tracking free buffer size
      iwlwifi: mvm: only enable HE DCM if we also support TX
      iwlwifi: advertise support for HE - DCM BPSK RX/TX
      iwlwifi: mvm: add additional info for boot info failures
      iwlwifi: mvm: add additional info for boot info failures
      iwlwifi: dbg: in sync mode don't call schedule
      iwlwifi: dbg: check trigger data before access

Moshe Shemesh (10):
      net/mlx5: Add reset_state field to MFRL register
      net/mlx5: Add clarification on sync reset failure
      net/mlx5: Add command failures data to debugfs
      net/mlx5: Remove redundant notify fail on give pages
      net/mlx5: Remove redundant error on give pages
      net/mlx5: Remove redundant error on reclaim pages
      net/mlx5: Change release_all_pages cap bit location
      net/mlx5: Move debugfs entries to separate struct
      net/mlx5: Add pages debugfs
      net/mlx5: Add debugfs counters for page commands failures

Muhammad Usama Anjum (1):
      rtw88: check for validity before using a pointer

Mukesh Sisodiya (7):
      iwlwifi: yoyo: add IMR DRAM dump support
      iwlwifi: yoyo: Avoid using dram data if allocation failed
      iwlwifi: yoyo: support dump policy for the dump size
      iwlwifi: yoyo: send hcmd to fw after dump collection completes.
      iwlwifi: yoyo: disable IMR DRAM region if IMR is disabled
      iwlwifi: mvm: add support for IMR based on platform
      iwlwifi: yoyo: dump IMR DRAM only for HW and FW error

Mykola Lysenko (4):
      bpf: Small BPF verifier log improvements
      Improve perf related BPF tests (sample_freq issue)
      Improve send_signal BPF test stability
      Improve stability of find_vma BPF test

Namhyung Kim (2):
      bpf: Adjust BPF stack helper functions to accommodate skip > 0
      selftests/bpf: Test skipping stacktrace

Nathan Chancellor (6):
      MAINTAINERS: Add scripts/pahole-flags.sh to BPF section
      kbuild: Add CONFIG_PAHOLE_VERSION
      scripts/pahole-flags.sh: Use pahole-version.sh
      lib/Kconfig.debug: Use CONFIG_PAHOLE_VERSION
      lib/Kconfig.debug: Allow BTF + DWARF5 with pahole 1.21+
      compiler-clang.h: Add __diag infrastructure for clang

Nathan Errera (1):
      iwlwifi: mvm: offload channel switch timing to FW

Naveen Mamindlapalli (2):
      octeontx2-pf: cn10k: add support for new ptp timestamp format
      octeontx2-af: cn10k: add workaround for ptp errata

Naveen N. Rao (2):
      selftests/bpf: Use "__se_" prefix on architectures without syscall wrapper
      selftests/bpf: Fix tests to use arch-dependent syscall entry points

Nicolas Cavallari (3):
      mt76: mt7915e: Fix degraded performance after temporary overheat
      mt76: mt7915e: Add a hwmon attribute to get the actual throttle state.
      mt76: mt7915e: Enable thermal management by default

Nicolas Dichtel (3):
      netfilter: nfqueue: enable to get skb->priority
      nfqueue: enable to set skb->priority
      xfrm: rework default policy structure

Niels Dossche (3):
      Bluetooth: hci_event: Add missing locking on hdev in hci_le_ext_adv_term_evt
      Bluetooth: move adv_instance_cnt read within the device lock
      Bluetooth: call hci_le_conn_failed with hdev lock in hci_le_conn_failed

Niklas Söderlund (7):
      nfp: expose common functions to be used for AF_XDP
      nfp: xsk: add an array of xsk buffer pools to each data path
      nfp: xsk: add configuration check for XSK socket chunk size
      nfp: xsk: add AF_XDP zero-copy Rx and Tx support
      bpftool: Restore support for BPF offload-enabled feature probing
      nfp: flower: avoid newline at the end of message in NL_SET_ERR_MSG_MOD
      samples/bpf, xdpsock: Fix race when running for fix duration of time

Nikolay Aleksandrov (2):
      drivers: vxlan: vnifilter: per vni stats
      drivers: vxlan: vnifilter: add support for stats dumping

Oleksij Rempel (10):
      net: usb: smsc95xx: add generic selftest support
      net: dsa: microchip: ksz9477: export HW stats over stats64 interface
      net: dsa: microchip: ksz9477: reduce polling interval for statistics
      net: asix: remove code duplicates in asix_mdio_read/write and asix_mdio_read/write_nopm
      net: dsa: microchip: ksz9477: implement MTU configuration
      net: usb: asix: unify ax88772_resume code
      net: usb: asix: store chipid to avoid reading it on reset
      net: usb: asix: make use of mdiobus_get_phy and phy_connect_direct
      net: usb: asix: suspend embedded PHY if external is used
      net: dsa: microchip: ksz8795: handle eee specif erratum

Oliver Hartkopp (8):
      can: isotp: add local echo tx processing for consecutive frames
      can: isotp: set default value for N_As to 50 micro seconds
      can: isotp: set max PDU size to 64 kByte
      vxcan: remove sk reference in peer skb
      vxcan: enable local echo for sent CAN frames
      can: isotp: sanitize CAN ID checks in isotp_bind()
      can: isotp: return -EADDRNOTAVAIL when reading from unbound socket
      can: isotp: support MSG_TRUNC flag when reading from socket

P Praneesh (1):
      ath11k: add LDPC FEC type in 802.11 radiotap header

Pablo Neira Ayuso (16):
      netfilter: nft_cmp: optimize comparison for 16-bytes
      netfilter: flowtable: Fix QinQ and pppoe support for inet table
      netfilter: nf_tables: validate registers coming from userspace.
      netfilter: nf_tables: initialize registers in nft_do_chain()
      netfilter: nf_tables: do not reduce read-only expressions
      netfilter: nf_tables: cancel tracking for clobbered destination registers
      netfilter: nft_ct: track register operations
      netfilter: nft_numgen: cancel register tracking
      netfilter: nft_osf: track register operations
      netfilter: nft_hash: track register operations
      netfilter: nft_immediate: cancel register tracking for data destination register
      netfilter: nft_socket: track register operations
      netfilter: nft_xfrm: track register operations
      netfilter: nft_tunnel: track register operations
      netfilter: flowtable: remove redundant field in flow_offload_work struct
      netfilter: flowtable: pass flowtable to nf_flow_table_iterate()

Paolo Abeni (11):
      net: gro: avoid re-computing truesize twice on recycle
      net: gro: minor optimization for dev_gro_receive()
      mptcp: constify a bunch of of helpers
      Merge branch 'net-phy-lan87xx-use-genphy_read_master_slave-function'
      mptcp: more careful RM_ADDR generation
      mptcp: introduce implicit endpoints
      mptcp: strict local address ID selection
      selftests: mptcp: add implicit endpoint test case
      Merge branch 'netdevsim-support-for-l3-hw-stats'
      Merge branch 'net-mvneta-armada-98dx2530-soc'
      Merge branch 'selftests-forwarding-locked-bridge-port-fixes'

Paul Blakey (8):
      net/sched: Enable tc skb ext allocation on chain miss only when needed
      net/mlx5e: TC, Move flow hashtable to be per rep
      net/mlx5: CT: Introduce a platform for multiple flow steering providers
      net/mlx5: DR, Add helper to get backing dr table from a mlx5 flow table
      net/mlx5: Add smfs lib to export direct steering API to CT
      net/mlx5: CT: Add software steering ct flow steering provider
      net/mlx5: CT: Create smfs dr matchers dynamically
      net/mlx5: CT: Remove extra rhashtable remove on tuple entries

Pavan Chebbi (4):
      bnxt_en: PTP: Refactor PTP initialization functions
      bnxt_en: Add driver support to use Real Time Counter for PTP
      bnxt_en: Implement .adjtime() for PTP RTC mode
      bnxt_en: Handle async event when the PHC is updated in RTC mode

Pavel Begunkov (11):
      cgroup/bpf: fast path skb BPF filtering
      ipv6: optimise dst refcounting on skb init
      udp6: shuffle up->pending AF_INET bits
      ipv6: remove daddr temp buffer in __ip6_make_skb
      ipv6: clean up cork setup/release
      ipv6: don't zero inet_cork_full::fl after use
      ipv6: pass full cork into __ip6_append_data()
      udp6: pass flow in ip6_make_skb together with cork
      udp6: don't make extra copies of iflow
      ipv6: optimise dst refcounting on cork init
      ipv6: partially inline ipv6_fixup_options

Pavel Skripkin (5):
      ieee802154: atusb: move to new USB API
      Bluetooth: hci_serdev: call init_rwsem() before p->open()
      ath9k_htc: fix uninit value bugs
      net: asix: add proper error handling of usb read errors
      Bluetooth: hci_uart: add missing NULL check in h5_enqueue

Peter Chiu (7):
      mt76: mt7915: fix ht mcs in mt7915_mac_add_txs_skb()
      mt76: mt7921: fix ht mcs in mt7921_mac_add_txs_skb()
      mt76: mt7915: fix mcs_map in mt7915_mcu_set_sta_he_mcs()
      mt76: mt7915: update max_mpdu_size in mt7915_mcu_sta_amsdu_tlv()
      dt-bindings: net: wireless: mt76: document bindings for MT7986
      mt76: mt7915: initialize smps mode in mt7915_mcu_sta_rate_ctrl_tlv()
      mt76: mt7915: fix phy cap in mt7915_set_stream_he_txbf_caps()

Peter Fink (6):
      can: gs_usb: use union and FLEX_ARRAY for data in struct gs_host_frame
      can: gs_usb: add CAN-FD support
      can: gs_usb: add usb quirk for NXP LPC546xx controllers
      can: gs_usb: activate quirks for CANtact Pro unconditionally
      can: gs_usb: add extended bt_const feature
      can: gs_usb: add VID/PID for CES CANext FD devices

Peter Seiderer (5):
      ath5k: remove unused ah_txq_isr_qtrig member from struct ath5k_hw
      ath5k: remove unused ah_txq_isr_qcburn member from struct ath5k_hw
      ath5k: remove unused ah_txq_isr_qcborn member from struct ath5k_hw
      ath5k: remove unused ah_txq_isr_txurn member from struct ath5k_hw
      ath5k: fix ah_txq_isr_txok_all setting

Petr Machata (19):
      net: rtnetlink: rtnl_stats_get(): Emit an extack for unset filter_mask
      net: rtnetlink: Namespace functions related to IFLA_OFFLOAD_XSTATS_*
      net: rtnetlink: Stop assuming that IFLA_OFFLOAD_XSTATS_* are dev-backed
      net: rtnetlink: RTM_GETSTATS: Allow filtering inside nests
      net: rtnetlink: Propagate extack to rtnl_offload_xstats_fill()
      net: rtnetlink: rtnl_fill_statsinfo(): Permit non-EMSGSIZE error returns
      net: dev: Add hardware stats support
      net: rtnetlink: Add UAPI for obtaining L3 offload xstats
      net: rtnetlink: Add RTM_SETSTATS
      net: rtnetlink: Add UAPI toggle for IFLA_OFFLOAD_XSTATS_L3_STATS
      mlxsw: reg: Fix packing of router interface counters
      mlxsw: spectrum_router: Drop mlxsw_sp arg from counter alloc/free functions
      mlxsw: Extract classification of router-related events to a helper
      mlxsw: Add support for IFLA_OFFLOAD_XSTATS_L3_STATS
      selftests: forwarding: hw_stats_l3: Add a new test
      netdevsim: Introduce support for L3 offload xstats
      selftests: netdevsim: hw_stats_l3: Add a new test
      selftests: mlxsw: hw_stats_l3: Add a new test
      af_netlink: Fix shift out of bounds in group mask calculation

Phil Sutter (2):
      netfilter: nf_tables: Reject tables of unsupported family
      netfilter: conntrack: Add and use nf_ct_set_auto_assign_helper_warned()

Ping-Ke Shih (50):
      rtw89: remove duplicate definition of hardware port number
      rtw89: Add RX counters of VHT MCS-10/11 to debugfs
      rtw89: encapsulate RX handlers to single function
      rtw89: correct use of BA CAM
      rtw89: configure rx_filter according to FIF_PROBE_REQ
      rtw89: use hardware SSN to TX management frame
      rtw89: download beacon content to firmware
      rtw89: add C2H handle of BCN_CNT
      rtw89: implement mac80211_ops::set_tim to indicate STA to receive packets
      rtw89: allocate mac_id for each station in AP mode
      rtw89: extend firmware commands on states of sta_assoc and sta_disconnect
      rtw89: rename vif_maintain to role_maintain
      rtw89: configure mac port HIQ registers
      rtw89: send broadcast/multicast packets via HIQ if STAs are in sleep mode
      rtw89: set mac_id and port ID to TXWD
      rtw89: separate {init,deinit}_addr_cam functions
      rtw88: rtw8821c: enable rfe 6 devices
      rtw89: extend role_maintain to support AP mode
      rtw89: add addr_cam field to sta to support AP mode
      rtw89: only STA mode change vif_type mapping dynamically
      rtw89: maintain assoc/disassoc STA states of firmware and hardware
      rtw89: implement ieee80211_ops::start_ap and stop_ap
      rtw89: debug: add stations entry to show ID assignment
      rtw89: declare AP mode support
      rtw89: coex: set EN bit to PLT register
      rtw89: add 6G support to rate adaptive mechanism
      rtw89: declare if chip support 160M bandwidth
      rtw89: handle TX/RX 160M bandwidth
      rtw88: change rtw_info() to proper message level
      rtw89: get channel parameters of 160MHz bandwidth
      rtw89: declare HE capabilities in 6G band
      rtw89: 8852c: add 8852c empty files
      rtw89: pci: add struct rtw89_pci_info
      rtw89: pci: add V1 of PCI channel address
      rtw89: pci: use a struct to describe all registers address related to DMA channel
      rtw89: read chip version depends on chip ID
      rtw89: add power_{on/off}_func
      rtw89: add hci_func_en_addr to support variant generation
      rtw89: add chip_info::{h2c,c2h}_reg to support more chips
      rtw89: add page_regs to handle v1 chips
      rtw89: 8852c: add chip::dle_mem
      rtw89: support DAV efuse reading operation
      rtw89: 8852c: process efuse of phycap
      rtw89: 8852c: process logic efuse map
      rtw89: fix uninitialized variable of rtw89_append_probe_req_ie()
      rtw89: add config_rf_reg_v1 to configure RF parameter tables
      rtw89: initialize preload window of D-MAC
      rtw89: change value assignment style of rtw89_mac_cfg_gnt()
      rtw89: extend mac tx_en bits from 16 to 32
      rtw89: implement stop and resume channels transmission v1

Piotr Dymacz (2):
      mt76: mt7615: add support for LG LGSBWAC02 (MT7663BUN)
      Bluetooth: btusb: add support for LG LGSBWAC02 (MT7663BUN)

Piotr Skajewski (1):
      ixgbe: Remove non-inclusive language

Po Hao Huang (1):
      rtw89: 8852a: add ieee80211_ops::hw_scan

Po Liu (3):
      net:enetc: allocate CBD ring data memory using DMA coherent methods
      net:enetc: command BD ring data memory alloc as one function alone
      net:enetc: enetc qos using the CBDR dma alloc function

Po-Hao Huang (2):
      rtw88: fix idle mode flow for hw scan
      rtw88: fix memory overrun and memory leak during hw_scan

Pradeep Kumar Chitrapu (3):
      ath11k: switch to using ieee80211_tx_status_ext()
      ath11k: decode HE status tlv
      ath11k: translate HE status to radiotap format

Qing Deng (1):
      ip6_tunnel: allow routing IPv4 traffic in NBMA mode

Quentin Monnet (2):
      bpftool: Add libbpf's version number to "bpftool version" output
      bpftool: Update versioning scheme, align on libbpf's version number

Radoslaw Biernacki (2):
      Bluetooth: Fix skb allocation in mgmt_remote_name() & mgmt_device_connected()
      Bluetooth: Improve skb handling in mgmt_device_connected()

Radu Bulie (2):
      dpaa2-eth: Update dpni_get_single_step_cfg command
      dpaa2-eth: Update SINGLE_STEP register access

Rafael David Tinoco (1):
      bpftool: Gen min_core_btf explanation and examples

Rafael J. Wysocki (1):
      drivers: net: Replace acpi_bus_get_device()

Raju Lakkaraju (10):
      net: lan743x: Add PCI11010 / PCI11414 device IDs
      net: lan743x: Add support for 4 Tx queues
      net: lan743x: Increase MSI(x) vectors to 16 and Int de-assertion timers to 10
      net: lan743x: Add support for SGMII interface
      net: lan743x: Add support for Clause-45 MDIO PHY management
      net: lan743x: Add support to display Tx Queue statistics
      net: lan743x: Add support for EEPROM
      net: lan743x: Add support for OTP
      net: lan743x: Add support for PTP-IO Event Input External Timestamp (extts)
      net: lan743x: Add support for PTP-IO Event Output (Periodic Output)

Raman Shukhau (1):
      bpftool: Adding support for BTF program names

Rameshkumar Sundaram (1):
      ath11k: Invalidate cached reo ring entry before accessing it

Randy Dunlap (1):
      netfilter: nf_nat_h323: eliminate anonymous module_init & module_exit

Robert Hancock (16):
      net: phy: at803x: move page selection fix to config_init
      net: phy: at803x: add fiber support
      net: phy: at803x: Support downstream SFP cage
      net: dsa: microchip: Document property to disable reference clock
      net: dsa: microchip: Add property to disable reference clock
      dt-bindings: net: cdns,macb: added generic PHY and reset mappings for ZynqMP
      net: macb: Added ZynqMP-specific initialization
      arm64: dts: zynqmp: Added GEM reset definitions
      net: axienet: fix RX ring refill allocation failure handling
      net: axienet: Clean up device used for DMA calls
      net: axienet: Clean up DMA start/stop and error handling
      net: axienet: don't set IRQ timer when IRQ delay not used
      net: axienet: implement NAPI and GRO receive
      net: axienet: reduce default RX interrupt threshold to 1
      net: axienet: add coalesce timer ethtool configuration
      net: axienet: Use napi_alloc_skb when refilling RX ring

Roberto Sassu (9):
      ima: Fix documentation-related warnings in ima_main.c
      ima: Always return a file measurement in ima_file_hash()
      bpf-lsm: Introduce new helper bpf_ima_file_hash()
      selftests/bpf: Move sample generation code to ima_test_common()
      selftests/bpf: Add test for bpf_ima_file_hash()
      selftests/bpf: Check if the digest is refreshed after a file write
      bpf-lsm: Make bpf_lsm_kernel_read_file() as sleepable
      selftests/bpf: Add test for bpf_lsm_kernel_read_file()
      selftests/bpf: Check that bpf_kernel_read_file() denies reading IMA policy

Robin Murphy (1):
      nfp: Simplify array allocation

Roi Dayan (21):
      net/mlx5e: Move code chunk setting encap dests into its own function
      net/mlx5e: Pass attr arg for attaching/detaching encaps
      net/mlx5e: Move counter creation call to alloc_flow_attr_counter()
      net/mlx5e: TC, Move pedit_headers_action to parse_attr
      net/mlx5e: TC, Split pedit offloads verify from alloc_tc_pedit_action()
      net/mlx5e: TC, Pass attr to tc_act can_offload()
      net/mlx5e: TC, Refactor mlx5e_tc_add_flow_mod_hdr() to get flow attr
      net/mlx5e: TC, Reject rules with multiple CT actions
      net/mlx5e: TC, Hold sample_attr on stack instead of pointer
      net/mlx5e: CT, Don't set flow flag CT for ct clear flow
      net/mlx5e: Refactor eswitch attr flags to just attr flags
      net/mlx5e: Test CT and SAMPLE on flow attr
      net/mlx5e: TC, Store mapped tunnel id on flow attr
      net/mlx5e: CT, Remove redundant flow args from tc ct calls
      net/mlx5e: Pass actions param to actions_match_supported()
      net/mlx5e: Add post act offload/unoffload API
      net/mlx5e: Create new flow attr for multi table actions
      net/mlx5e: Use multi table support for CT and sample actions
      net/mlx5e: TC, Clean redundant counter flag from tc action parsers
      net/mlx5e: TC, Make post_act parse CT and sample actions
      net/mlx5e: TC, Allow sample action with CT

Rongwei Liu (6):
      net/mlx5: DR, Adjust structure member to reduce memory hole
      net/mlx5: DR, Remove mr_addr rkey from struct mlx5dr_icm_chunk
      net/mlx5: DR, Remove icm_addr from mlx5dr_icm_chunk to reduce memory
      net/mlx5: DR, Remove num_of_entries byte_size from struct mlx5_dr_icm_chunk
      net/mlx5: DR, Remove 4 members from mlx5dr_ste_htbl to reduce memory
      net/mlx5: DR, Remove hw_ste from mlx5dr_ste to reduce memory

Roopa Prabhu (10):
      vxlan: move to its own directory
      vxlan_core: fix build warnings in vxlan_xmit_one
      vxlan_core: move common declarations to private header file
      vxlan_core: move some fdb helpers to non-static
      vxlan_core: make multicast helper take rip and ifindex explicitly
      vxlan_core: add helper vxlan_vni_in_use
      rtnetlink: add new rtm tunnel api for tunnel id filtering
      vxlan_multicast: Move multicast helpers to a separate file
      vxlan: vni filtering support on collect metadata device
      selftests: add new tests for vxlan vnifiltering

Rotem Saado (3):
      iwlwifi: yoyo: fix DBGI_SRAM ini dump header.
      iwlwifi: yoyo: fix DBGC allocation flow
      iwlwifi: yoyo: remove DBGI_SRAM address reset writing

Russell King (Oracle) (53):
      net: xpcs: add support for retrieving supported interface modes
      net: stmmac: convert to phylink_get_linkmodes()
      net: stmmac: fill in supported_interfaces
      net: stmmac/xpcs: convert to pcs_validate()
      net: stmmac: remove phylink_config.pcs_poll usage
      net: stmmac: convert to phylink_generic_validate()
      net: stmmac: use .mac_select_pcs() interface
      net: axienet: convert to phylink_pcs
      net: axienet: replace mdiobus_write() with mdiodev_write()
      net: dpaa2-mac: use .mac_select_pcs() interface
      net: enetc: use .mac_select_pcs() interface
      net: mvneta: reorder initialisation
      net: mvneta: use .mac_select_pcs() interface
      net: sparx5: use .mac_select_pcs() interface
      net: dsa: ar9331: convert to phylink_generic_validate()
      net: dsa: bcm_sf2: convert to phylink_generic_validate()
      net: dsa: ksz8795: convert to phylink_generic_validate()
      net: dsa: qca8k: convert to phylink_generic_validate()
      net: dsa: xrs700x: convert to phylink_generic_validate()
      net: dsa: mv88e6xxx: add mv88e6352_g2_scratch_port_has_serdes()
      net: dsa: mv88e6xxx: populate supported_interfaces and mac_capabilities
      net: dsa: mv88e6xxx: convert to phylink_generic_validate()
      net: dsa: mv88e6xxx: improve 88e6352 serdes statistics detection
      net: dsa: realtek: convert to phylink_generic_validate()
      net: phylink: remove phylink_set_10g_modes()
      net: sparx5: remove phylink_config.pcs_poll usage
      net: dsa: add support for phylink mac_select_pcs()
      net: dsa: qca8k: move qca8k_setup()
      net: dsa: qca8k: move qca8k_phylink_mac_link_state()
      net: dsa: qca8k: convert to use phylink_pcs
      net: dsa: qca8k: move pcs configuration
      net: dsa: qca8k: mark as non-legacy
      net: dsa: remove pcs_poll
      net: phylink: remove phylink_config's pcs_poll
      net: dsa: b53: clean up if() condition to be more readable
      net: dsa: b53: populate supported_interfaces and mac_capabilities
      net: dsa: b53: drop use of phylink_helper_basex_speed()
      net: dsa: b53: switch to using phylink_generic_validate()
      net: dsa: b53: mark as non-legacy
      net: phy: phylink: fix DSA mac_select_pcs() introduction
      net: dsa: sja1105: populate supported_interfaces
      net: dsa: sja1105: remove interface checks
      net: dsa: sja1105: use .mac_select_pcs() interface
      net: dsa: sja1105: mark as non-legacy
      net: dsa: sja1105: convert to phylink_generic_validate()
      net: dsa: sja1105: support switching between SGMII and 2500BASE-X
      net: dsa: ocelot: populate supported_interfaces
      net: dsa: ocelot: remove interface checks
      net: dsa: ocelot: convert to mac_select_pcs()
      net: dsa: ocelot: mark as non-legacy
      net: phylink: remove phylink_set_pcs()
      net: phylink: use %pe for printing errors
      net: sfp: use %pe for printing errors

Ryder Lee (3):
      mt76: mt7915: check band idx for bcc event
      mt76: mt7915: allow beaconing on all chains
      mt76: use le32/16_get_bits() whenever possible

Saeed Mahameed (9):
      net/mlx5: cmdif, Return value improvements
      net/mlx5: cmdif, cmd_check refactoring
      net/mlx5: cmdif, Add new api for command execution
      net/mlx5: Use mlx5_cmd_do() in core create_{cq,dct}
      net/mlx5: cmdif, Refactor error handling and reporting of async commands
      RDMA/mlx5: Use new command interface API
      net/mlx5e: Fix use-after-free in mlx5e_stats_grp_sw_update_stats
      net/mlx5e: HTB, remove unused function declaration
      net/mlx5e: Fix build warning, detected write beyond size of field

Samuel Thibault (1):
      SO_ZEROCOPY should return -EOPNOTSUPP rather than -ENOTSUPP

Saurabh Sengar (1):
      net: netvsc: remove break after return

Sean Wang (22):
      Bluetooth: btmtksdio: rename btsdio_mtk_reg_read
      Bluetooth: btmtksdio: move struct reg_read_cmd to common file
      Bluetooth: btmtksdio: clean up inconsistent error message in btmtksdio_mtk_reg_read
      Bluetooth: btmtksdio: lower log level in btmtksdio_runtime_[resume|suspend]()
      Bluetooth: btmtksdio: run sleep mode by default
      Bluetooth: btmtksdio: mask out interrupt status
      mt76: sdio: lock sdio when it is needed
      mt76: mt7921s: clear MT76_STATE_MCU_RUNNING immediately after reset
      mt76: mt7921e: make dev->fw_assert usage consistent
      mt76: mt76_connac: fix MCU_CE_CMD_SET_ROC definition error
      mt76: mt7921: set EDCA parameters with the MCU CE command
      mt76: mt7921e: fix possible probe failure after reboot
      mt76: sdio: disable interrupt in mt76s_sdio_irq
      mt76: sdio: honor the largest Tx buffer the hardware can support
      mt76: mt7921s: run sleep mode by default
      Bluetooth: mediatek: fix the conflict between mtk and msft vendor event
      mt76: mt7921: fix up the monitor mode
      mt76: mt7921: use mt76_hw instead of open coding it
      mt76: mt7921: don't enable beacon filter when IEEE80211_CONF_CHANGE_MONITOR is set
      Bluetooth: btmtkuart: rely on BT_MTK module
      Bluetooth: btmtkuart: add .set_bdaddr support
      Bluetooth: btmtkuart: fix the conflict between mtk and msft vendor event

Sebastian Andrzej Siewior (34):
      tcp: Don't acquire inet_listen_hashbucket::lock with disabled BH.
      net: dev: Remove preempt_disable() and get_cpu() in netif_rx_internal().
      net: dev: Makes sure netif_rx() can be invoked in any context.
      net: dev: Make rps_lock() disable interrupts.
      net: Correct wrong BH disable in hard-interrupt.
      docs: networking: Use netif_rx().
      net: xtensa: Use netif_rx().
      net: sgi-xp: Use netif_rx().
      net: caif: Use netif_rx().
      net: dsa: Use netif_rx().
      net: ethernet: Use netif_rx().
      net: macvlan: Use netif_rx().
      net: bridge: Use netif_rx().
      net: dev: Use netif_rx().
      net: phy: Use netif_rx().
      can: Use netif_rx().
      mctp: serial: Use netif_rx().
      slip/plip: Use netif_rx().
      wireless: Atheros: Use netif_rx().
      wireless: brcmfmac: Use netif_rx().
      wireless: Marvell: Use netif_rx().
      wireless: Use netif_rx().
      s390: net: Use netif_rx().
      staging: Use netif_rx().
      tun: vxlan: Use netif_rx().
      tipc: Use netif_rx().
      batman-adv: Use netif_rx().
      bluetooth: Use netif_rx().
      phonet: Use netif_rx().
      net: phy: micrel: Use netif_rx().
      net: Remove netif_rx_any_context() and netif_rx_ni().
      net: phy: micrel: Move netif_rx() outside of IRQ-off section.
      net: Add lockdep asserts to ____napi_schedule().
      net: Revert the softirq will run annotation in ____napi_schedule().

Seevalamuthu Mariappan (2):
      ath11k: Add debugfs interface to configure firmware debug log level
      ath11k: Handle failure in qmi firmware ready

Sergey Shtylyov (4):
      phy: make phy_set_max_speed() *void*
      ravb: ravb_close() always returns 0
      sh_eth: sh_eth_close() always returns 0
      sh_eth: kill useless initializers in sh_eth_{suspend|resume}()

Shannon Nelson (14):
      ionic: fix type complaint in ionic_dev_cmd_clean()
      ionic: start watchdog after all is setup
      ionic: separate function for watchdog init
      ionic: add FW_STOPPING state
      ionic: better handling of RESET event
      ionic: fix up printing of timeout error
      ionic: remove the dbid_inuse bitmap
      ionic: stretch heartbeat detection
      ionic: replace set_vf data with union
      ionic: catch transition back to RUNNING with fw_generation 0
      ionic: prefer strscpy over strlcpy
      ionic: clean up comments and whitespace
      ionic: use vmalloc include
      ionic: no transition while stopping

Shayne Chen (6):
      mt76: mt7915: set bssinfo/starec command when adding interface
      mt76: mt7915: fix potential memory leak of fw monitor packets
      mt76: mt7915: fix eeprom fields of txpower init values
      mt76: mt7915: add txpower init for 6GHz
      mt76: mt7915: set band1 TGID field in tx descriptor
      mt76: mt7915: fix beamforming mib stats

Shun Hao (1):
      net/mlx5: DR, Align mlx5dv_dr API vport action with FW behavior

Shung-Hsi Yu (1):
      bpf: Determine buf_info inside check_buffer_access()

Siddharth Vadapalli (1):
      net: ethernet: ti: am65-cpsw: Convert to PHYLINK

Simon Horman (1):
      nfp: only use kdoc style comments for kdoc

Simon Wunderlich (1):
      batman-adv: Start new development cycle

Slawomir Mrozowicz (3):
      ixgbe: add the ability for the PF to disable VF link state
      ixgbe: add improvement for MDD response functionality
      ixgbevf: add disable link state

Soenke Huster (3):
      Bluetooth: fix null ptr deref on hci_sync_conn_complete_evt
      Bluetooth: msft: fix null pointer deref on msft_monitor_device_evt
      Bluetooth: hci_event: Ignore multiple conn complete events

Sondhauß, Jan (1):
      drivers: ethernet: cpsw: fix panic when interrupt coaleceing is set via ethtool

Song Liu (19):
      x86/Kconfig: Select HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP
      bpf: Use bytes instead of pages for bpf_jit_[charge|uncharge]_modmem
      bpf: Use size instead of pages in bpf_binary_header
      bpf: Use prog->jited_len in bpf_prog_ksym_set_addr()
      x86/alternative: Introduce text_poke_copy
      bpf: Introduce bpf_arch_text_copy
      bpf: Introduce bpf_prog_pack allocator
      bpf: Introduce bpf_jit_binary_pack_[alloc|finalize|free]
      bpf, x86_64: Use bpf_jit_binary_pack_alloc
      bpf, x86_64: Fail gracefully on bpf_jit_binary_pack_finalize failures
      bpf: Fix leftover header->pages in sparc and powerpc code.
      bpf: Fix bpf_prog_pack build HPAGE_PMD_SIZE
      bpf: Fix bpf_prog_pack build for ppc64_defconfig
      bpf: bpf_prog_pack: Set proper size before freeing ro_header
      x86: Disable HAVE_ARCH_HUGE_VMALLOC on 32-bit x86
      bpf, x86: Set header->size properly before freeing it
      bpf: Select proper size for bpf_prog_pack
      bpf: Fix bpf_prog_pack for multi-node setup
      bpf: Fix bpf_prog_pack when PMU_SIZE is not defined

Soontak Lee (1):
      brcmfmac: add CYW43570 PCIE device

Souptick Joarder (HPE) (1):
      bpf: Initialize ret to 0 inside btf_populate_kfunc_set()

Srinivas Neeli (1):
      can: xilinx_can: Add check for NAPI Poll function

Sriram R (1):
      nl80211: add support for 320MHz channel limitation

Stanislav Fomichev (4):
      bpf: fix register_btf_kfunc_id_set for !CONFIG_DEBUG_INFO_BTF
      bpf: test_run: Fix overflow in xdp frags parsing
      bpf: test_run: Fix overflow in bpf_test_finish frags parsing
      bpf, test_run: Fix overflow in XDP frags bpf_test_finish

Stephane Graber (1):
      drivers: net: xgene: Fix regression in CRC stripping

Stephen Rothwell (1):
      net: dm9051: Make remove() callback a void function

Stijn Tintel (1):
      libbpf: Fix BPF_MAP_TYPE_PERF_EVENT_ARRAY auto-pinning

Subbaraya Sundeep (4):
      octeontx2-pf: Change receive buffer size using ethtool
      octeontx2-pf: Add TC feature for VFs
      ethtool: add support to set/get completion queue event size
      octeontx2-pf: Vary completion queue event size

Sukadev Bhattiprolu (1):
      ibmvnic: fix race between xmit and reset

Sun Shouxin (1):
      net: bonding: Add support for IPV6 ns/na to balance-alb/balance-tlb mode

Sunil Kumar Kori (1):
      octeontx2-af: Priority flow control configuration support

Sunil Rani (1):
      net/mlx5: E-Switch, reserve and use same uplink metadata across ports

Sven Eckelmann (3):
      macvtap: advertise link netns via netlink
      batman-adv: Migrate to linux/container_of.h
      batman-adv: Demote batadv-on-batadv skip error message

Takashi Iwai (2):
      iwlwifi: mvm: Don't call iwl_mvm_sta_from_mac80211() with NULL sta
      Bluetooth: btusb: Add missing Chicony device for Realtek RTL8723BE

Tao Chen (1):
      tcp: Remove the unused api

Tariq Toukan (14):
      net/mlx5: Remove unused TIR modify bitmask enums
      net/mlx5e: Remove unused tstamp SQ field
      net/mlx5e: Generalize packet merge error message
      net/mlx5e: Default to Striding RQ when not conflicting with CQE compression
      net/mlx5e: RX, Restrict bulk size for small Striding RQs
      net/mlx5: Node-aware allocation for the IRQ table
      net/mlx5: Node-aware allocation for the EQ table
      net/mlx5: Node-aware allocation for the EQs
      net/mlx5: Node-aware allocation for UAR
      net/mlx5: Node-aware allocation for the doorbell pgdir
      net/mlx5e: RX, Test the XDP program existence out of the handler
      net/mlx5: Remove unused exported contiguous coherent buffer allocation API
      net/mlx5: Remove unused fill page array API function
      net/mlx5e: Statify function mlx5_cmd_trigger_completions

Tedd Ho-Jeong An (2):
      Bluetooth: btintel: Fix WBS setting for Intel legacy ROM products
      Bluetooth: Remove kernel-doc style comment block

Tianyu Lan (1):
      Netvsc: Call hv_unmap_memory() in the netvsc_device_remove()

Tiezhu Yang (1):
      bpf: Add some description about BPF_JIT_ALWAYS_ON in Kconfig

Tobias Waldekranz (36):
      net: dsa: Move VLAN filtering syncing out of dsa_switch_bridge_leave
      net: dsa: Avoid cross-chip syncing of VLAN filtering
      dt-bindings: net: xgmac_mdio: Remove unsupported "bus-frequency"
      net/fsl: xgmac_mdio: Use managed device resources
      net/fsl: xgmac_mdio: Support preamble suppression
      net/fsl: xgmac_mdio: Support setting the MDC frequency
      dt-bindings: net: xgmac_mdio: Add "clock-frequency" and "suppress-preamble"
      net: dsa: mv88e6xxx: Improve performance of busy bit polling
      net: dsa: mv88e6xxx: Improve indirect addressing performance
      net: dsa: mv88e6xxx: Improve isolation of standalone ports
      net: dsa: mv88e6xxx: Support policy entries in the VTU
      net: dsa: mv88e6xxx: Enable port policy support on 6097
      net: dsa: mv88e6xxx: Improve multichip isolation of standalone ports
      selftests: net: bridge: Parameterize ageing timeout
      net: dsa: mv88e6xxx: Fix validation of built-in PHYs on 6095/6097
      net: dsa: tag_dsa: Fix tx from VLAN uppers on non-filtering bridges
      net: dsa: Never offload FDB entries on standalone ports
      net: bridge: mst: Multiple Spanning Tree (MST) mode
      net: bridge: mst: Allow changing a VLAN's MSTI
      net: bridge: mst: Support setting and reporting MST port states
      net: bridge: mst: Notify switchdev drivers of MST mode changes
      net: bridge: mst: Notify switchdev drivers of VLAN MSTI migrations
      net: bridge: mst: Notify switchdev drivers of MST state changes
      net: bridge: mst: Add helper to map an MSTI to a VID set
      net: bridge: mst: Add helper to check if MST is enabled
      net: bridge: mst: Add helper to query a port's MST state
      net: dsa: Validate hardware support for MST
      net: dsa: Pass VLAN MSTI migration notifications to driver
      net: dsa: Handle MST state changes
      net: dsa: mv88e6xxx: Disentangle STU from VTU
      net: dsa: mv88e6xxx: Export STU as devlink region
      net: dsa: mv88e6xxx: MST Offloading
      net: dsa: mv88e6xxx: Require ops be implemented to claim STU support
      net: dsa: mv88e6xxx: Ensure STU support in VLAN MSTI callback
      net: dsa: mv88e6xxx: Fill in STU support for all supported chips
      net: bridge: mst: Restrict info size queries to bridge ports

Toke Hoiland-Jorgensen (1):
      bpf: generalise tail call map compatibility check

Toke Høiland-Jørgensen (10):
      libbpf: Define BTF_KIND_* constants in btf.h to avoid compilation errors
      libbpf: Use dynamically allocated buffer when receiving netlink messages
      bpf: Add "live packet" mode for XDP in BPF_PROG_RUN
      Documentation/bpf: Add documentation for BPF_PROG_RUN
      libbpf: Support batch_size option to bpf_prog_test_run
      selftests/bpf: Move open_netns() and close_netns() into network_helpers.c
      selftests/bpf: Add selftest for XDP_REDIRECT in BPF_PROG_RUN
      bpf: Initialise retval in bpf_prog_test_run_xdp()
      bpf, test_run: Fix packet size check for live packet mode
      selftests/bpf: Add a test for maximum packet size in xdp_do_redirect

Tom Rix (10):
      caif: cleanup double word in comment
      net: ethernet: altera: cleanup comments
      net: ethernet: xilinx: cleanup comments
      bcma: cleanup comments
      bpf: Cleanup comments
      Bluetooth: hci_sync: fix undefined return of hci_disconnect_all_sync()
      net: dsa: return success if there was nothing to do
      net: rtnetlink: fix error handling in rtnl_fill_statsinfo()
      i40e: little endian only valid checksums
      igb: zero hwtstamp by default

Toms Atteka (1):
      net: openvswitch: IPv6: Add IPv6 extension header support

Tong Zhang (4):
      ar5523: fix typo "to short" -> "too short"
      s390/ctcm: fix typo "length to short" -> "length too short"
      i825xx: fix typo "Frame to short" -> "Frame too short"
      mISDN: fix typo "frame to short" -> "frame too short"

Tony Lu (5):
      net/smc: Send directly when TCP_CORK is cleared
      net/smc: Remove corked dealyed work
      net/smc: Cork when sendpage with MSG_SENDPAGE_NOTLAST flag
      net/smc: Add comment for smc_tx_pending
      net/smc: Call trace_smc_tx_sendmsg when data corked

Toshiaki Makita (3):
      netfilter: flowtable: Support GRE
      act_ct: Support GRE offload
      net/mlx5: Support GRE conntrack offload

Ulrich Hecht (2):
      dt-bindings: can: renesas,rcar-canfd: Document r8a779a0 support
      can: rcar_canfd: Add support for r8a779a0 SoC

Usama Arif (4):
      bpf/scripts: Raise an exception if the correct number of helpers are not generated
      uapi/bpf: Add missing description and returns for helper documentation
      bpf/scripts: Make description and returns section for helpers/syscalls mandatory
      bpf/scripts: Raise an exception if the correct number of sycalls are not generated

Vadim Fedorenko (4):
      ptp: ocp: add TOD debug information
      ptp: ocp: Expose clock status drift and offset
      ptp: ocp: add tod_correction attribute
      ptp: ocp: adjust utc_tai_offset to TOD info

Vadim Pasternak (8):
      mlxsw: core: Prevent trap group setting if driver does not support EMAD
      mlxsw: core_thermal: Avoid creation of virtual hwmon objects by thermal module
      mlxsw: core_hwmon: Fix variable names for hwmon attributes
      mlxsw: core_thermal: Rename labels according to naming convention
      mlxsw: core_thermal: Remove obsolete API for query resource
      mlxsw: reg: Add "mgpir_" prefix to MGPIR fields comments
      mlxsw: core: Remove unnecessary asserts
      mlxsw: core: Unify method of trap support validation

Veerendranath Jakkam (2):
      nl80211: add EHT MCS support
      nl80211: fix typo of NL80211_IF_TYPE_OCB in documentation

Venkata Sudheer Kumar Bhavaraju (2):
      qed: use msleep() in qed_mcp_cmd() and add qed_mcp_cmd_nosleep() for udelay.
      qed: prevent a fw assert during device shutdown

Venkateswara Naralasetty (5):
      ath11k: Rename ath11k_ahb_ext_irq_config
      ath11k: fix kernel panic during unload/load ath11k modules
      ath11k: fix WARN_ON during ath11k_mac_update_vif_chan
      ath11k: fix radar detection in 160 Mhz
      ath11k: add dbring debug support

Victor Nogueira (1):
      selftests: tc-testing: Increase timeout in tdc config file

Vikas Gupta (1):
      bnxt_en: add an nvm test for hw diagnose

Vincent Mailhol (2):
      can: etas_es58x: use BITS_PER_TYPE() instead of manual calculation
      can: etas_es58x: es58x_fd_rx_event_msg(): initialize rx_event_msg before calling es58x_check_msg_len()

Vinod Koul (1):
      net: stmmac: Add support for SM8150

Vladimir Oltean (94):
      net: dsa: provide switch operations for tracking the master state
      net: dsa: replay master state events in dsa_tree_{setup,teardown}_master
      net: dsa: remove ndo_get_phys_port_name and ndo_get_port_parent_id
      net: dsa: remove lockdep class for DSA master address list
      net: dsa: remove lockdep class for DSA slave address list
      net: bridge: vlan: check for errors from __vlan_del in __vlan_flush
      net: bridge: vlan: check early for lack of BRENTRY flag in br_vlan_add_existing
      net: bridge: vlan: don't notify to switchdev master VLANs without BRENTRY flag
      net: bridge: vlan: make __vlan_add_flags react only to PVID and UNTAGGED
      net: bridge: vlan: notify switchdev only when something changed
      net: bridge: switchdev: differentiate new VLANs from changed ones
      net: bridge: make nbp_switchdev_unsync_objs() follow reverse order of sync()
      net: bridge: switchdev: replay all VLAN groups
      net: switchdev: rename switchdev_lower_dev_find to switchdev_lower_dev_find_rcu
      net: switchdev: introduce switchdev_handle_port_obj_{add,del} for foreign interfaces
      net: dsa: add explicit support for host bridge VLANs
      net: dsa: offload bridge port VLANs on foreign interfaces
      net: dsa: tag_8021q: only call skb_push/skb_pull around __skb_vlan_pop
      net: mscc: ocelot: use a consistent cookie for MRP traps
      net: mscc: ocelot: consolidate cookie allocation for private VCAP rules
      net: mscc: ocelot: delete OCELOT_MRP_CPUQ
      net: mscc: ocelot: use a single VCAP filter for all MRP traps
      net: mscc: ocelot: avoid overlap in VCAP IS2 between PTP and MRP traps
      net: dsa: felix: use DSA port iteration helpers
      net: mscc: ocelot: keep traps in a list
      net: mscc: ocelot: annotate which traps need PTP timestamping
      net: dsa: felix: remove dead code in felix_setup_mmio_filtering()
      net: dsa: felix: update destinations of existing traps with ocelot-8021q
      net: dsa: tag_ocelot_8021q: calculate TX checksum in software for deferred packets
      mlxsw: spectrum: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
      net: lan966x: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
      net: sparx5: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
      net: ti: am65-cpsw-nuss: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
      net: ti: cpsw: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
      net: dsa: delete unused exported symbols for ethtool PHY stats
      net: switchdev: avoid infinite recursion from LAG to bridge with port object handler
      net: dsa: rename references to "lag" as "lag_dev"
      net: dsa: mv88e6xxx: rename references to "lag" as "lag_dev"
      net: dsa: qca8k: rename references to "lag" as "lag_dev"
      net: dsa: make LAG IDs one-based
      net: dsa: mv88e6xxx: use dsa_switch_for_each_port in mv88e6xxx_lag_sync_masks
      net: dsa: create a dsa_lag structure
      net: switchdev: remove lag_mod_cb from switchdev_handle_fdb_event_to_device
      net: dsa: remove "ds" and "port" from struct dsa_switchdev_event_work
      net: dsa: call SWITCHDEV_FDB_OFFLOADED for the orig_dev
      net: dsa: support FDB events on offloaded LAG interfaces
      net: dsa: felix: support FDB entries on offloaded LAG interfaces
      net: dsa: tag_8021q: replace the SVL bridging with VLAN-unaware IVL bridging
      net: dsa: tag_8021q: add support for imprecise RX based on the VBID
      docs: net: dsa: sja1105: document limitations of tc-flower rule VLAN awareness
      net: dsa: felix: delete workarounds present due to SVL tag_8021q bridging
      net: dsa: tag_8021q: merge RX and TX VLANs
      net: dsa: tag_8021q: rename dsa_8021q_bridge_tx_fwd_offload_vid
      net: dsa: request drivers to perform FDB isolation
      net: dsa: pass extack to .port_bridge_join driver methods
      net: dsa: sja1105: enforce FDB isolation
      net: mscc: ocelot: enforce FDB isolation when VLAN-unaware
      net: dsa: remove workarounds for changing master promisc/allmulti only while up
      net: dsa: rename the host FDB and MDB methods to contain the "bridge" namespace
      net: dsa: install secondary unicast and multicast addresses as host FDB/MDB
      net: dsa: install the primary unicast MAC address as standalone port host FDB
      net: dsa: manage flooding on the CPU ports
      net: dsa: felix: migrate host FDB and MDB entries when changing tag proto
      net: dsa: felix: migrate flood settings from NPI to tag_8021q CPU port
      net: dsa: felix: start off with flooding disabled on the CPU port
      net: dsa: felix: stop clearing CPU flooding in felix_setup_tag_8021q
      net: mscc: ocelot: accept configuring bridge port flags on the NPI port
      net: mscc: ocelot: use list_for_each_entry in ocelot_vcap_block_remove_filter
      net: mscc: ocelot: use pretty names for IPPROTO_UDP and IPPROTO_TCP
      net: dsa: felix: remove ocelot->npi assignment from felix_8021q_cpu_port_init
      net: dsa: felix: drop the ptp_type argument from felix_check_xtr_pkt()
      net: dsa: felix: initialize "err" to 0 in felix_check_xtr_pkt()
      net: dsa: felix: print error message in felix_check_xtr_pkt()
      net: dsa: felix: remove redundant assignment in felix_8021q_cpu_port_deinit
      net: dsa: warn if port lists aren't empty in dsa_port_teardown
      net: dsa: move port lists initialization to dsa_port_touch
      net: dsa: felix: drop "bool change" from felix_set_tag_protocol
      net: dsa: be mostly no-op in dsa_slave_set_mac_address when down
      net: dsa: felix: actually disable flooding towards NPI port
      net: dsa: felix: avoid early deletion of host FDB entries
      net: tcp: fix shim definition of tcp_inbound_md5_hash
      net: dsa: report and change port default priority using dcbnl
      net: dsa: report and change port dscp priority using dcbnl
      net: dsa: felix: configure default-prio and dscp priorities
      net: mscc: ocelot: fix build error due to missing IEEE_8021QAZ_MAX_TCS
      net: mscc: ocelot: refactor policer work out of ocelot_setup_tc_cls_matchall
      net: mscc: ocelot: add port mirroring support using tc-matchall
      net: mscc: ocelot: establish functions for handling VCAP aux resources
      net: mscc: ocelot: offload per-flow mirroring using tc-mirred and VCAP IS2
      net: dsa: pass extack to dsa_switch_ops :: port_mirror_add()
      net: dsa: felix: add port mirroring support
      net: dsa: felix: allow PHY_INTERFACE_MODE_INTERNAL on port 5
      net: dsa: fix panic on shutdown if multi-chip tree failed to probe
      net: dsa: fix missing host-filtered multicast addresses

Volodymyr Mytnyk (3):
      net: prestera: acl: add multi-chain support offload
      net: prestera: flower: fix destroy tmpl in chain
      net: prestera: acl: fix 'client_map' buff overflow

Vyacheslav Bocharov (2):
      Bluetooth: btrtl: Add support for RTL8822C hci_ver 0x08
      Bluetooth: hci_h5: Add power reset via gpio in h5_btrtl_open

Wan Jiabing (4):
      mt76: mt7915: simplify conditional
      bpf, docs: Add a missing colon in verifier.rst
      nfp: avoid newline at end of message in NL_SET_ERR_MSG_MOD
      qed: remove unnecessary memset in qed_init_fw_funcs

Wang Qing (9):
      net: ethernet: cavium: use div64_u64() instead of do_div()
      net: ethernet: use time_is_before_eq_jiffies() instead of open coding it
      net: qlcnic: use time_is_before_jiffies() instead of open coding it
      net: ethernet: sun: use time_is_before_jiffies() instead of open coding it
      net: hamradio: use time_is_after_jiffies() instead of open coding it
      net: wan: lmc: use time_is_before_jiffies() instead of open coding it
      net: decnet: use time_is_before_jiffies() instead of open coding it
      net: hamradio: fix compliation error
      cw1200: use time_is_after_jiffies() instead of open coding it

Wang Yufen (5):
      bpf, sockmap: Fix memleak in sk_psock_queue_msg
      bpf, sockmap: Fix memleak in tcp_bpf_sendmsg while sk msg is full
      bpf, sockmap: Fix more uncharged while msg has more_data
      bpf, sockmap: Fix double uncharge the mem of sk_msg
      netlabel: fix out-of-bounds memory accesses

Wei Fu (1):
      bpftool: Only set obj->skeleton on complete success

Wei Yongjun (1):
      net/fsl: xgmac_mdio: fix return value check in xgmac_mdio_probe()

Wen Gong (7):
      ath10k: fix memory overwrite of the WoWLAN wakeup packet pattern
      ath11k: free peer for station when disconnect from AP for QCA6390/WCN6855
      ath11k: set WMI_PEER_40MHZ while peer assoc for 6 GHz
      ath11k: avoid firmware crash when reg set for QCA6390/WCN6855
      ath11k: fix uninitialized rate_idx in ath11k_dp_tx_update_txcompl()
      ath11k: add ath11k_qmi_free_resource() for recovery
      ath11k: configure RDDM size to mhi for recovery by firmware

Wojciech Drewek (7):
      gtp: Allow to create GTP device without FDs
      gtp: Implement GTP echo response
      gtp: Implement GTP echo request
      net/sched: Allow flower to match on GTP options
      gtp: Add support for checking GTP device type
      gtp: Fix inconsistent indenting
      ice: Fix inconsistent indenting in ice_switch

Wong Vee Khee (1):
      stmmac: intel: Enable 2.5Gbps for Intel AlderLake-S

Xiang wangx (1):
      iwlwifi: Fix syntax errors in comments

Xin Long (1):
      Revert "vlan: move dev_put into vlan_dev_uninit"

Xing Song (1):
      mt76: stop the radar detector after leaving dfs channel

Xu Kuohai (2):
      libbpf: Skip forward declaration when counting duplicated type names
      selftests/bpf: Update btf_dump case for conflicting names

Xu Wang (1):
      s390/qeth: Remove redundant 'flush_workqueue()' calls

YN Chen (2):
      mt76: mt7921s: update mt7921s_wfsys_reset sequence
      mt76: mt7921: forbid the doze mode when coredump is in progress

Yaara Baruch (2):
      iwlwifi: pcie: add support for MS devices
      iwlwifi: pcie: iwlwifi: fix device id 7F70 struct

Yafang Shao (2):
      libbpf: Fix possible NULL pointer dereference when destroying skeleton
      bpftool: Fix print error when show bpf map

Yake Yang (7):
      Bluetooth: btusb: Add a new PID/VID 13d3/3567 for MT7921
      Bluetooth: btmtksdio: Fix kernel oops when sdio suspend.
      Bluetooth: btmtksdio: Fix kernel oops in btmtksdio_interrupt
      Bluetooth: mt7921s: Set HCI_QUIRK_VALID_LE_STATES
      Bluetooth: mt7921s: Add .get_data_path_id
      Bluetooth: mt7921s: Add .btmtk_get_codec_config_data
      Bluetooth: mt7921s: Add WBS support

Yang Guang (2):
      ptp: replace snprintf with sysfs_emit
      ssb: fix boolreturn.cocci warning

Yang Li (8):
      wcn36xx: clean up some inconsistent indenting
      dpaa2-eth: Simplify bool conversion
      net: Fix an ignored error return from dm9051_get_regs()
      ixgbevf: clean up some inconsistent indenting
      mt76: mt7615: Fix assigning negative values to unsigned variable
      net: openvswitch: remove unneeded semicolon
      ethernet: 8390: Remove unnecessary print function dev_err()
      phy: Remove duplicated include in phy-fsl-lynx-28g.c

Yang Yingliang (7):
      ath11k: add missing of_node_put() to avoid leak
      net: marvell: prestera: Fix return value check in prestera_fib_node_find()
      net: marvell: prestera: Fix return value check in prestera_kern_fib_cache_find()
      ice: fix return value check in ice_gnss.c
      nfc: st21nfca: remove unnecessary skb check before kfree_skb()
      net: wwan: qcom_bam_dmux: fix wrong pointer passed to IS_ERR()
      net: marvell: prestera: add missing destroy_workqueue() in prestera_module_init()

Yannick Vignon (1):
      net: stmmac: optimize locking around PTP clock reads

Yevgeny Kliteynik (6):
      net/mlx5: DR, Add support for matching on Internet Header Length (IHL)
      net/mlx5: DR, Remove unneeded comments
      net/mlx5: DR, Fix handling of different actions on the same STE in STEv1
      net/mlx5: DR, Rename action modify fields to reflect naming in HW spec
      net/mlx5: DR, Refactor ste_ctx handling for STE v0/1
      net/mlx5: DR, Add support for ConnectX-7 steering

Yevhen Orlov (3):
      net: marvell: prestera: Add router LPM ABI
      net: marvell: prestera: add hardware router objects accounting for lpm
      net: marvell: prestera: handle fib notifications

Yi-Tang Chiu (1):
      rtw89: Limit the CFO boundaries of x'tal value

YiFei Zhu (5):
      bpf: Make BPF_PROG_RUN_ARRAY return -err instead of allow boolean
      bpf: Move getsockopt retval to struct bpf_cg_run_ctx
      bpf: Add cgroup helpers bpf_{get,set}_retval to get/set syscall return value
      selftests/bpf: Test bpf_{get,set}_retval behavior with cgroup/sockopt
      selftests/bpf: Update sockopt_sk test to the use bpf_set_retval

Yihao Han (3):
      bpf, test_run: Use kvfree() for memory allocated with kvmalloc()
      mac80211: replace DEFINE_SIMPLE_ATTRIBUTE with DEFINE_DEBUGFS_ATTRIBUTE
      net: ethernet: ezchip: fix platform_get_irq.cocci warning

Yinjun Zhang (3):
      bpftool: Fix the error when lookup in no-btf maps
      nfp: xsk: fix a warning when allocating rx rings
      nfp: nfdk: implement xdp tx path for NFDK

Yonghong Song (14):
      selftests/bpf: Fix a clang compilation error
      selftests/bpf: fix a clang compilation error
      compiler_types: define __user as __attribute__((btf_type_tag("user")))
      bpf: reject program if a __user tagged memory accessed in kernel way
      selftests/bpf: rename btf_decl_tag.c to test_btf_decl_tag.c
      selftests/bpf: add a selftest with __user tag
      selftests/bpf: specify pahole version requirement for btf_tag test
      docs/bpf: clarify how btf_type_tag gets encoded in the type chain
      bpf: Fix a btf decl_tag bug when tagging a function
      selftests/bpf: Add a selftest for invalid func btf with btf decl_tag
      libbpf: Fix build issue with llvm-readelf
      selftests/bpf: Fix a clang deprecated-declarations compilation error
      selftests/bpf: Fix a clang compilation error for send_signal.c
      bpftool: Fix a bug in subskeleton code generation

Yonglong Li (2):
      mptcp: Fix crash due to tcp_tsorted_anchor was initialized before release skb
      mptcp: send ADD_ADDR echo before create subflows

Youghandhar Chintala (1):
      mac80211: Add support to trigger sta disconnect on hardware restart

Yuan-Han Zhang (3):
      rtw89: modify dcfo_comp to share with chips
      rtw89: 8852c: add write/read crystal function in CFO tracking
      rtw89: 8852c: add setting of TB UL TX power offset

Yucong Sun (3):
      selftests/bpf: Fix vmtest.sh to launch smp vm.
      selftests/bpf: Fix crash in core_reloc when bpftool btfgen fails
      bpf: Fix issue with bpf preload module taking over stdout/stdin of kernel.

YueHaibing (1):
      net: hns3: Remove unused inline function hclge_is_reset_pending()

Yufeng Mo (1):
      net: hns3: add support for TX push mode

Yuntao Wang (8):
      libbpf: Remove redundant check in btf_fixup_datasec()
      libbpf: Simplify the find_elf_sec_sz() function
      bpftool: Remove redundant slashes
      libbpf: Add a check to ensure that page_cnt is non-zero
      bpf: Replace strncpy() with strscpy()
      bpf: Remove redundant slash
      bpf: Use offsetofend() to simplify macro definition
      bpf: Simplify check in btf_parse_hdr()

Zekun Shen (1):
      ath5k: fix OOB in ath5k_eeprom_read_pcal_info_5111

Zhao, Jiaqing (1):
      brcmfmac: Add BCM43454/6 support

Zheyu Ma (1):
      net: cxgb3: Fix an error code when probing the driver

Zijun Hu (1):
      Bluetooth: btusb: Improve stability for QCA devices

Ziyang Xuan (4):
      net: macvlan: fix potential UAF problem for lowerdev
      net: macvlan: add net device refcount tracker
      net/tls: remove unnecessary jump instructions in do_tls_setsockopt_conf()
      net/tls: optimize judgement processes in tls_set_device_offload()

Zong-Zhe Yang (8):
      rtw89: extract modules by chipset
      rtw89: handle 6G band if supported by a chipset
      rtw89: include subband type in channel params
      rtw89: make rfk helpers common across chips
      rtw89: refine naming of rfk helpers with prefix
      rtw89: extend subband for 6G band
      rtw89: phy: handle txpwr lmt/lmt_ru of 6G band
      rtw89: phy: handle txpwr lmt/lmt_ru of 160M bandwidth

jeffreyji (1):
      teaming: deliver link-local packets with the link they arrive on

kernel test robot (2):
      bpf: Fix flexible_array.cocci warnings
      net: dsa: qca8k: fix noderef.cocci warnings

lic121 (1):
      libbpf: Unmap rings when umem deleted

wujunwen (1):
      net: ksz884x: optimize netdev_open flow and remove static variable

xu xin (1):
      ipv4: Namespaceify min_adv_mss sysctl knob

Íñigo Huguet (4):
      rtw89: fix maybe uninitialized `qempty` variable
      sfc: default config to 1 channel/core in local NUMA node only
      sfc: set affinity hints in local NUMA node only
      net: set default rss queues num to physical cores / 2

 Documentation/ABI/testing/sysfs-timecard           |  116 +-
 Documentation/admin-guide/sysctl/net.rst           |    9 +
 Documentation/bpf/bpf_prog_run.rst                 |  117 +
 Documentation/bpf/btf.rst                          |   45 +-
 Documentation/bpf/index.rst                        |    1 +
 Documentation/bpf/instruction-set.rst              |  215 +-
 Documentation/bpf/verifier.rst                     |    2 +-
 Documentation/devicetree/bindings/i2c/i2c.txt      |    4 +
 .../bindings/net/can/allwinner,sun4i-a10-can.yaml  |    3 +
 .../devicetree/bindings/net/can/bosch,m_can.yaml   |    9 +-
 .../bindings/net/can/microchip,mcp251xfd.yaml      |    3 +
 .../bindings/net/can/renesas,rcar-canfd.yaml       |    2 +
 .../devicetree/bindings/net/can/xilinx,can.yaml    |  161 +
 .../devicetree/bindings/net/can/xilinx_can.txt     |   61 -
 .../devicetree/bindings/net/cdns,macb.yaml         |   56 +
 .../devicetree/bindings/net/davicom,dm9051.yaml    |   62 +
 .../devicetree/bindings/net/dsa/dsa-port.yaml      |    2 +
 .../devicetree/bindings/net/dsa/microchip,ksz.yaml |    6 +
 .../devicetree/bindings/net/dsa/realtek-smi.txt    |  240 -
 .../devicetree/bindings/net/dsa/realtek.yaml       |  394 ++
 Documentation/devicetree/bindings/net/fsl-fman.txt |   22 +-
 .../bindings/net/marvell-armada-370-neta.txt       |    1 +
 .../bindings/net/mctp-i2c-controller.yaml          |   92 +
 .../devicetree/bindings/net/mediatek-dwmac.txt     |   91 -
 .../devicetree/bindings/net/mediatek-dwmac.yaml    |  175 +
 Documentation/devicetree/bindings/net/micrel.txt   |   17 +
 .../bindings/net/microchip,lan966x-switch.yaml     |    2 +
 .../bindings/net/microchip,sparx5-switch.yaml      |    2 +
 .../devicetree/bindings/net/mscc-miim.txt          |    2 +-
 .../devicetree/bindings/net/renesas,etheravb.yaml  |    4 +-
 .../bindings/net/wireless/mediatek,mt76.yaml       |   42 +-
 .../devicetree/bindings/phy/fsl,lynx-28g.yaml      |   40 +
 .../bindings/phy/transmit-amplitude.yaml           |  103 +
 Documentation/networking/bonding.rst               |   11 +
 Documentation/networking/devlink/index.rst         |   16 +
 Documentation/networking/dsa/sja1105.rst           |   27 +
 Documentation/networking/ethtool-netlink.rst       |   19 +
 Documentation/networking/index.rst                 |    1 +
 Documentation/networking/ip-sysctl.rst             |   23 +
 Documentation/networking/mctp.rst                  |   48 +
 Documentation/networking/page_pool.rst             |   56 +
 Documentation/networking/smc-sysctl.rst            |   23 +
 Documentation/networking/timestamping.rst          |    2 +-
 Documentation/trace/fprobe.rst                     |  174 +
 Documentation/trace/index.rst                      |    1 +
 MAINTAINERS                                        |   27 +-
 arch/alpha/include/uapi/asm/socket.h               |    2 +
 arch/arm/net/bpf_jit_32.c                          |    4 +-
 .../dts/freescale/fsl-lx2160a-clearfog-itx.dtsi    |    4 +
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi     |    6 +
 arch/arm64/boot/dts/mediatek/mt2712-evb.dts        |    1 +
 arch/arm64/boot/dts/mediatek/mt2712e.dtsi          |   14 +-
 arch/arm64/boot/dts/microchip/sparx5.dtsi          |    5 +-
 arch/arm64/boot/dts/xilinx/zynqmp.dtsi             |    8 +
 arch/arm64/include/asm/debug-monitors.h            |   12 -
 arch/arm64/include/asm/insn-def.h                  |   14 +
 arch/arm64/include/asm/insn.h                      |   80 +-
 arch/arm64/lib/insn.c                              |  187 +-
 arch/arm64/net/bpf_jit.h                           |   44 +-
 arch/arm64/net/bpf_jit_comp.c                      |  246 +-
 arch/mips/include/uapi/asm/socket.h                |    2 +
 arch/parisc/include/uapi/asm/socket.h              |    2 +
 arch/powerpc/include/asm/checksum.h                |    7 +
 arch/powerpc/net/bpf_jit_comp.c                    |    2 +-
 arch/sparc/include/uapi/asm/socket.h               |    2 +
 arch/sparc/net/bpf_jit_comp_64.c                   |    2 +-
 arch/x86/Kconfig                                   |    1 +
 arch/x86/include/asm/text-patching.h               |    1 +
 arch/x86/kernel/alternative.c                      |   34 +
 arch/x86/net/bpf_jit_comp.c                        |   82 +-
 arch/xtensa/platforms/iss/network.c                |    2 +-
 drivers/atm/nicstar.c                              |   10 +-
 drivers/bcma/driver_chipcommon.c                   |    2 +-
 drivers/bcma/driver_chipcommon_pmu.c               |    6 +-
 drivers/bcma/driver_gpio.c                         |    1 -
 drivers/bcma/driver_pci_host.c                     |    6 +-
 drivers/bcma/main.c                                |    4 +-
 drivers/bcma/sprom.c                               |    4 +-
 drivers/bluetooth/Kconfig                          |    1 +
 drivers/bluetooth/ath3k.c                          |    1 -
 drivers/bluetooth/bcm203x.c                        |    1 -
 drivers/bluetooth/btintel.c                        |   11 +-
 drivers/bluetooth/btintel.h                        |    1 +
 drivers/bluetooth/btmrvl_debugfs.c                 |    2 +-
 drivers/bluetooth/btmrvl_sdio.c                    |    2 +-
 drivers/bluetooth/btmtk.c                          |    1 +
 drivers/bluetooth/btmtk.h                          |   43 +
 drivers/bluetooth/btmtksdio.c                      |  471 +-
 drivers/bluetooth/btmtkuart.c                      |  198 +-
 drivers/bluetooth/btrtl.c                          |   21 +
 drivers/bluetooth/btusb.c                          |  100 +-
 drivers/bluetooth/hci_bcm.c                        |   46 +-
 drivers/bluetooth/hci_h5.c                         |   13 +-
 drivers/bluetooth/hci_ll.c                         |    2 +-
 drivers/bluetooth/hci_serdev.c                     |    3 +-
 drivers/bus/moxtet.c                               |    4 +-
 drivers/char/tpm/st33zp24/i2c.c                    |    5 +-
 drivers/char/tpm/st33zp24/spi.c                    |    9 +-
 drivers/char/tpm/st33zp24/st33zp24.c               |    3 +-
 drivers/char/tpm/st33zp24/st33zp24.h               |    2 +-
 drivers/char/tpm/tpm_tis_spi_main.c                |    3 +-
 drivers/clk/clk-lmk04832.c                         |    4 +-
 drivers/gpio/gpio-74x164.c                         |    4 +-
 drivers/gpio/gpio-max3191x.c                       |    4 +-
 drivers/gpio/gpio-max7301.c                        |    4 +-
 drivers/gpio/gpio-mc33880.c                        |    4 +-
 drivers/gpio/gpio-pisosr.c                         |    4 +-
 drivers/gpu/drm/panel/panel-abt-y030xx067a.c       |    4 +-
 drivers/gpu/drm/panel/panel-ilitek-ili9322.c       |    4 +-
 drivers/gpu/drm/panel/panel-ilitek-ili9341.c       |    3 +-
 drivers/gpu/drm/panel/panel-innolux-ej030na.c      |    4 +-
 drivers/gpu/drm/panel/panel-lg-lb035q02.c          |    4 +-
 drivers/gpu/drm/panel/panel-lg-lg4573.c            |    4 +-
 drivers/gpu/drm/panel/panel-nec-nl8048hl11.c       |    4 +-
 drivers/gpu/drm/panel/panel-novatek-nt39016.c      |    4 +-
 drivers/gpu/drm/panel/panel-samsung-db7430.c       |    3 +-
 drivers/gpu/drm/panel/panel-samsung-ld9040.c       |    4 +-
 drivers/gpu/drm/panel/panel-samsung-s6d27a1.c      |    3 +-
 drivers/gpu/drm/panel/panel-samsung-s6e63m0-spi.c  |    3 +-
 drivers/gpu/drm/panel/panel-sitronix-st7789v.c     |    4 +-
 drivers/gpu/drm/panel/panel-sony-acx565akm.c       |    4 +-
 drivers/gpu/drm/panel/panel-tpo-td028ttec1.c       |    4 +-
 drivers/gpu/drm/panel/panel-tpo-td043mtea1.c       |    4 +-
 drivers/gpu/drm/panel/panel-tpo-tpg110.c           |    3 +-
 drivers/gpu/drm/panel/panel-widechips-ws2401.c     |    3 +-
 drivers/gpu/drm/tiny/hx8357d.c                     |    4 +-
 drivers/gpu/drm/tiny/ili9163.c                     |    4 +-
 drivers/gpu/drm/tiny/ili9225.c                     |    4 +-
 drivers/gpu/drm/tiny/ili9341.c                     |    4 +-
 drivers/gpu/drm/tiny/ili9486.c                     |    4 +-
 drivers/gpu/drm/tiny/mi0283qt.c                    |    4 +-
 drivers/gpu/drm/tiny/repaper.c                     |    4 +-
 drivers/gpu/drm/tiny/st7586.c                      |    4 +-
 drivers/gpu/drm/tiny/st7735r.c                     |    4 +-
 drivers/hwmon/adcxx.c                              |    4 +-
 drivers/hwmon/adt7310.c                            |    3 +-
 drivers/hwmon/max1111.c                            |    3 +-
 drivers/hwmon/max31722.c                           |    4 +-
 drivers/iio/accel/bma400_spi.c                     |    4 +-
 drivers/iio/accel/bmc150-accel-spi.c               |    4 +-
 drivers/iio/accel/bmi088-accel-spi.c               |    4 +-
 drivers/iio/accel/kxsd9-spi.c                      |    4 +-
 drivers/iio/accel/mma7455_spi.c                    |    4 +-
 drivers/iio/accel/sca3000.c                        |    4 +-
 drivers/iio/adc/ad7266.c                           |    4 +-
 drivers/iio/adc/ltc2496.c                          |    4 +-
 drivers/iio/adc/mcp320x.c                          |    4 +-
 drivers/iio/adc/mcp3911.c                          |    4 +-
 drivers/iio/adc/ti-adc12138.c                      |    4 +-
 drivers/iio/adc/ti-ads7950.c                       |    4 +-
 drivers/iio/adc/ti-ads8688.c                       |    4 +-
 drivers/iio/adc/ti-tlc4541.c                       |    4 +-
 drivers/iio/amplifiers/ad8366.c                    |    4 +-
 drivers/iio/common/ssp_sensors/ssp_dev.c           |    4 +-
 drivers/iio/dac/ad5360.c                           |    4 +-
 drivers/iio/dac/ad5380.c                           |    4 +-
 drivers/iio/dac/ad5446.c                           |    4 +-
 drivers/iio/dac/ad5449.c                           |    4 +-
 drivers/iio/dac/ad5504.c                           |    4 +-
 drivers/iio/dac/ad5592r.c                          |    4 +-
 drivers/iio/dac/ad5624r_spi.c                      |    4 +-
 drivers/iio/dac/ad5686-spi.c                       |    4 +-
 drivers/iio/dac/ad5761.c                           |    4 +-
 drivers/iio/dac/ad5764.c                           |    4 +-
 drivers/iio/dac/ad5791.c                           |    4 +-
 drivers/iio/dac/ad8801.c                           |    4 +-
 drivers/iio/dac/ltc1660.c                          |    4 +-
 drivers/iio/dac/ltc2632.c                          |    4 +-
 drivers/iio/dac/mcp4922.c                          |    4 +-
 drivers/iio/dac/ti-dac082s085.c                    |    4 +-
 drivers/iio/dac/ti-dac7311.c                       |    3 +-
 drivers/iio/frequency/adf4350.c                    |    4 +-
 drivers/iio/gyro/bmg160_spi.c                      |    4 +-
 drivers/iio/gyro/fxas21002c_spi.c                  |    4 +-
 drivers/iio/health/afe4403.c                       |    4 +-
 drivers/iio/magnetometer/bmc150_magn_spi.c         |    4 +-
 drivers/iio/magnetometer/hmc5843_spi.c             |    4 +-
 drivers/iio/potentiometer/max5487.c                |    4 +-
 drivers/iio/pressure/ms5611_spi.c                  |    4 +-
 drivers/iio/pressure/zpa2326_spi.c                 |    4 +-
 drivers/infiniband/hw/mlx5/cong.c                  |    3 +-
 drivers/infiniband/hw/mlx5/devx.c                  |   61 +-
 drivers/infiniband/hw/mlx5/main.c                  |    2 +-
 drivers/infiniband/hw/mlx5/mr.c                    |   17 +-
 drivers/infiniband/hw/mlx5/qp.c                    |    1 +
 drivers/infiniband/hw/mlx5/qpc.c                   |    2 +-
 drivers/input/keyboard/applespi.c                  |    4 +-
 drivers/input/misc/adxl34x-spi.c                   |    4 +-
 drivers/input/touchscreen/ads7846.c                |    4 +-
 drivers/input/touchscreen/cyttsp4_spi.c            |    4 +-
 drivers/input/touchscreen/tsc2005.c                |    4 +-
 drivers/isdn/hardware/mISDN/mISDNipac.c            |    2 +-
 drivers/isdn/hardware/mISDN/mISDNisar.c            |    4 +-
 drivers/leds/leds-cr0014114.c                      |    4 +-
 drivers/leds/leds-dac124s085.c                     |    4 +-
 drivers/leds/leds-el15203000.c                     |    4 +-
 drivers/leds/leds-spi-byte.c                       |    4 +-
 drivers/media/spi/cxd2880-spi.c                    |    4 +-
 drivers/media/spi/gs1662.c                         |    4 +-
 drivers/media/tuners/msi001.c                      |    3 +-
 drivers/mfd/arizona-spi.c                          |    4 +-
 drivers/mfd/da9052-spi.c                           |    3 +-
 drivers/mfd/ezx-pcap.c                             |    4 +-
 drivers/mfd/madera-spi.c                           |    4 +-
 drivers/mfd/mc13xxx-spi.c                          |    3 +-
 drivers/mfd/rsmu_spi.c                             |    4 +-
 drivers/mfd/stmpe-spi.c                            |    4 +-
 drivers/mfd/tps65912-spi.c                         |    4 +-
 drivers/misc/ad525x_dpot-spi.c                     |    3 +-
 drivers/misc/eeprom/eeprom_93xx46.c                |    4 +-
 drivers/misc/lattice-ecp3-config.c                 |    4 +-
 drivers/misc/lis3lv02d/lis3lv02d_spi.c             |    4 +-
 drivers/misc/sgi-xp/xpnet.c                        |    2 +-
 drivers/mmc/host/mmc_spi.c                         |    3 +-
 drivers/mtd/devices/mchp23k256.c                   |    4 +-
 drivers/mtd/devices/mchp48l640.c                   |    4 +-
 drivers/mtd/devices/mtd_dataflash.c                |    4 +-
 drivers/mtd/devices/sst25l.c                       |    4 +-
 drivers/net/Makefile                               |    2 +-
 drivers/net/amt.c                                  |    4 +-
 drivers/net/bareudp.c                              |   19 +-
 drivers/net/bonding/bond_alb.c                     |   31 +-
 drivers/net/bonding/bond_main.c                    |  324 +-
 drivers/net/bonding/bond_netlink.c                 |   59 +
 drivers/net/bonding/bond_options.c                 |   74 +-
 drivers/net/bonding/bond_procfs.c                  |    1 -
 drivers/net/bonding/bond_sysfs_slave.c             |    8 +-
 drivers/net/caif/caif_serial.c                     |    2 +-
 drivers/net/can/c_can/c_can_ethtool.c              |    9 -
 drivers/net/can/dev/bittiming.c                    |   20 +-
 drivers/net/can/dev/dev.c                          |    2 +-
 drivers/net/can/m_can/tcan4x5x-core.c              |    4 +-
 drivers/net/can/rcar/rcar_canfd.c                  |  353 +-
 drivers/net/can/slcan.c                            |    2 +-
 drivers/net/can/softing/softing_main.c             |    5 +-
 drivers/net/can/spi/hi311x.c                       |   10 +-
 drivers/net/can/spi/mcp251x.c                      |    8 +-
 drivers/net/can/spi/mcp251xfd/Makefile             |    2 +
 .../net/can/spi/mcp251xfd/mcp251xfd-chip-fifo.c    |    4 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |  353 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c     |    4 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c  |  143 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.c      |  153 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.h      |   62 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c   |   24 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c     |  417 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c       |   22 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c      |    6 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h          |   96 +-
 drivers/net/can/usb/etas_es58x/es58x_fd.c          |    6 +-
 drivers/net/can/usb/gs_usb.c                       |  446 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |    4 +-
 drivers/net/can/usb/ucan.c                         |    4 +-
 drivers/net/can/vcan.c                             |    2 +-
 drivers/net/can/vxcan.c                            |   21 +-
 drivers/net/can/xilinx_can.c                       |    9 +-
 drivers/net/dsa/Kconfig                            |   12 +-
 drivers/net/dsa/Makefile                           |    3 +-
 drivers/net/dsa/b53/b53_common.c                   |   87 +-
 drivers/net/dsa/b53/b53_priv.h                     |   25 +-
 drivers/net/dsa/b53/b53_serdes.c                   |   19 +-
 drivers/net/dsa/b53/b53_serdes.h                   |    5 +-
 drivers/net/dsa/b53/b53_spi.c                      |    4 +-
 drivers/net/dsa/b53/b53_srab.c                     |   35 +-
 drivers/net/dsa/bcm_sf2.c                          |   54 +-
 drivers/net/dsa/dsa_loop.c                         |    3 +-
 drivers/net/dsa/hirschmann/hellcreek.c             |    9 +-
 drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c    |    2 +-
 drivers/net/dsa/lan9303-core.c                     |   16 +-
 drivers/net/dsa/lantiq_gswip.c                     |   62 +-
 drivers/net/dsa/microchip/ksz8.h                   |    1 +
 drivers/net/dsa/microchip/ksz8795.c                |   92 +-
 drivers/net/dsa/microchip/ksz8795_reg.h            |    4 +
 drivers/net/dsa/microchip/ksz8795_spi.c            |    4 +-
 drivers/net/dsa/microchip/ksz9477.c                |  156 +-
 drivers/net/dsa/microchip/ksz9477_i2c.c            |    1 +
 drivers/net/dsa/microchip/ksz9477_reg.h            |    3 +
 drivers/net/dsa/microchip/ksz9477_spi.c            |    4 +-
 drivers/net/dsa/microchip/ksz_common.c             |   21 +-
 drivers/net/dsa/microchip/ksz_common.h             |   15 +-
 drivers/net/dsa/mt7530.c                           |   19 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |  925 ++-
 drivers/net/dsa/mv88e6xxx/chip.h                   |   51 +-
 drivers/net/dsa/mv88e6xxx/devlink.c                |   94 +
 drivers/net/dsa/mv88e6xxx/global1.h                |   11 +
 drivers/net/dsa/mv88e6xxx/global1_vtu.c            |  316 +-
 drivers/net/dsa/mv88e6xxx/global2.h                |    3 +
 drivers/net/dsa/mv88e6xxx/global2_scratch.c        |   28 +
 drivers/net/dsa/mv88e6xxx/hwtstamp.c               |    2 +-
 drivers/net/dsa/mv88e6xxx/port.c                   |   41 +-
 drivers/net/dsa/mv88e6xxx/port.h                   |   16 +-
 drivers/net/dsa/mv88e6xxx/serdes.c                 |   81 +-
 drivers/net/dsa/mv88e6xxx/serdes.h                 |    5 +
 drivers/net/dsa/mv88e6xxx/smi.c                    |   35 +-
 drivers/net/dsa/ocelot/felix.c                     |  843 ++-
 drivers/net/dsa/ocelot/felix.h                     |    9 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             |   48 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c           |   48 +-
 drivers/net/dsa/qca/ar9331.c                       |   45 +-
 drivers/net/dsa/qca8k.c                            | 1598 +++--
 drivers/net/dsa/qca8k.h                            |   54 +-
 drivers/net/dsa/realtek-smi-core.c                 |  523 --
 drivers/net/dsa/realtek/Kconfig                    |   40 +
 drivers/net/dsa/realtek/Makefile                   |    6 +
 drivers/net/dsa/realtek/realtek-mdio.c             |  290 +
 drivers/net/dsa/realtek/realtek-smi.c              |  581 ++
 .../dsa/{realtek-smi-core.h => realtek/realtek.h}  |   91 +-
 drivers/net/dsa/{ => realtek}/rtl8365mb.c          |  734 ++-
 .../net/dsa/{rtl8366.c => realtek/rtl8366-core.c}  |  164 +-
 drivers/net/dsa/{ => realtek}/rtl8366rb.c          |  460 +-
 drivers/net/dsa/sja1105/sja1105_flower.c           |   47 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |  202 +-
 drivers/net/dsa/sja1105/sja1105_ptp.c              |    2 +-
 drivers/net/dsa/sja1105/sja1105_vl.c               |   16 +-
 drivers/net/dsa/vitesse-vsc73xx-spi.c              |    6 +-
 drivers/net/dsa/xrs700x/xrs700x.c                  |   32 +-
 drivers/net/ethernet/3com/typhoon.c                |   24 +-
 drivers/net/ethernet/8390/mcf8390.c                |    4 +-
 drivers/net/ethernet/Kconfig                       |    1 +
 drivers/net/ethernet/Makefile                      |    1 +
 drivers/net/ethernet/agere/et131x.c                |   14 +-
 drivers/net/ethernet/altera/altera_sgdma.c         |    2 +-
 drivers/net/ethernet/altera/altera_tse_main.c      |    8 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |    5 +-
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c   |   12 +-
 drivers/net/ethernet/asix/ax88796c_main.c          |    6 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |    2 +-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c       |   16 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c   |    6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   83 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   19 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c      |    3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |   44 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h  |    2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   56 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h      |  499 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |  152 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h      |    5 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c    |    4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c      |   22 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |    6 +-
 drivers/net/ethernet/cadence/macb.h                |    4 +
 drivers/net/ethernet/cadence/macb_main.c           |   63 +-
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c  |    3 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |    1 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c |   59 +-
 drivers/net/ethernet/cortina/gemini.c              |    8 +
 drivers/net/ethernet/davicom/Kconfig               |   31 +
 drivers/net/ethernet/davicom/Makefile              |    1 +
 drivers/net/ethernet/davicom/dm9051.c              | 1260 ++++
 drivers/net/ethernet/davicom/dm9051.h              |  162 +
 drivers/net/ethernet/dec/tulip/pnic.c              |    2 +-
 drivers/net/ethernet/dlink/sundance.c              |   60 +-
 drivers/net/ethernet/ezchip/nps_enet.c             |    1 -
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |  437 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h   |   32 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |    2 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c   |  171 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h   |    8 +
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |    5 +-
 drivers/net/ethernet/freescale/dpaa2/dpmac-cmd.h   |   12 +
 drivers/net/ethernet/freescale/dpaa2/dpmac.c       |   54 +
 drivers/net/ethernet/freescale/dpaa2/dpmac.h       |    5 +
 drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h    |    6 +-
 drivers/net/ethernet/freescale/dpaa2/dpni.c        |    2 +
 drivers/net/ethernet/freescale/dpaa2/dpni.h        |    6 +
 drivers/net/ethernet/freescale/enetc/enetc.h       |   38 +
 drivers/net/ethernet/freescale/enetc/enetc_cbdr.c  |   41 +-
 drivers/net/ethernet/freescale/enetc/enetc_mdio.c  |    2 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |   14 +-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |  150 +-
 drivers/net/ethernet/freescale/fec_main.c          |    2 +-
 drivers/net/ethernet/freescale/fec_ptp.c           |    1 -
 drivers/net/ethernet/freescale/xgmac_mdio.c        |   93 +-
 drivers/net/ethernet/fungible/Kconfig              |   28 +
 drivers/net/ethernet/fungible/Makefile             |    7 +
 drivers/net/ethernet/fungible/funcore/Makefile     |    5 +
 drivers/net/ethernet/fungible/funcore/fun_dev.c    |  843 +++
 drivers/net/ethernet/fungible/funcore/fun_dev.h    |  150 +
 drivers/net/ethernet/fungible/funcore/fun_hci.h    | 1202 ++++
 drivers/net/ethernet/fungible/funcore/fun_queue.c  |  601 ++
 drivers/net/ethernet/fungible/funcore/fun_queue.h  |  175 +
 drivers/net/ethernet/fungible/funeth/Kconfig       |   17 +
 drivers/net/ethernet/fungible/funeth/Makefile      |   10 +
 drivers/net/ethernet/fungible/funeth/fun_port.h    |   97 +
 drivers/net/ethernet/fungible/funeth/funeth.h      |  171 +
 .../net/ethernet/fungible/funeth/funeth_devlink.c  |   40 +
 .../net/ethernet/fungible/funeth/funeth_devlink.h  |   13 +
 .../net/ethernet/fungible/funeth/funeth_ethtool.c  | 1162 ++++
 drivers/net/ethernet/fungible/funeth/funeth_ktls.c |  155 +
 drivers/net/ethernet/fungible/funeth/funeth_ktls.h |   30 +
 drivers/net/ethernet/fungible/funeth/funeth_main.c | 2091 ++++++
 drivers/net/ethernet/fungible/funeth/funeth_rx.c   |  826 +++
 .../net/ethernet/fungible/funeth/funeth_trace.h    |  117 +
 drivers/net/ethernet/fungible/funeth/funeth_tx.c   |  763 +++
 drivers/net/ethernet/fungible/funeth/funeth_txrx.h |  264 +
 drivers/net/ethernet/google/gve/gve_main.c         |    6 +-
 drivers/net/ethernet/google/gve/gve_rx.c           |    2 +-
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c   |    4 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |    1 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   79 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |    6 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |    2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   11 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   13 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |    2 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   11 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |    8 +
 drivers/net/ethernet/i825xx/sun3_82586.h           |    2 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   98 +-
 drivers/net/ethernet/ibm/ibmvnic.h                 |    7 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |   22 +-
 drivers/net/ethernet/intel/e1000e/phy.c            |    8 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |    4 +
 drivers/net/ethernet/intel/i40e/i40e_adminq.c      |   92 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c      |  155 +-
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c     |    3 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |    4 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   52 +-
 drivers/net/ethernet/intel/i40e/i40e_nvm.c         |    5 +-
 drivers/net/ethernet/intel/i40e/i40e_prototype.h   |   25 +
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   36 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h        |    5 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |   23 +-
 drivers/net/ethernet/intel/iavf/iavf.h             |   22 +-
 drivers/net/ethernet/intel/iavf/iavf_common.c      |    4 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  311 +-
 drivers/net/ethernet/intel/iavf/iavf_status.h      |    2 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c        |   62 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |  194 +-
 drivers/net/ethernet/intel/ice/Makefile            |   15 +-
 drivers/net/ethernet/intel/ice/ice.h               |   37 +-
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h    |  276 +-
 drivers/net/ethernet/intel/ice/ice_arfs.h          |    3 +
 drivers/net/ethernet/intel/ice/ice_base.c          |   21 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |  102 +-
 drivers/net/ethernet/intel/ice/ice_common.h        |   13 +-
 drivers/net/ethernet/intel/ice/ice_dcb.h           |    1 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c       |    8 +-
 drivers/net/ethernet/intel/ice/ice_eswitch.c       |  170 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   29 +-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c     |  345 +-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.h     |   15 +-
 drivers/net/ethernet/intel/ice/ice_flex_type.h     |   46 +-
 drivers/net/ethernet/intel/ice/ice_flow.c          |    1 +
 drivers/net/ethernet/intel/ice/ice_flow.h          |    2 +
 drivers/net/ethernet/intel/ice/ice_fltr.c          |   37 +-
 drivers/net/ethernet/intel/ice/ice_fltr.h          |   10 +-
 drivers/net/ethernet/intel/ice/ice_gnss.c          |  376 ++
 drivers/net/ethernet/intel/ice/ice_gnss.h          |   50 +
 drivers/net/ethernet/intel/ice/ice_idc.c           |   14 +-
 drivers/net/ethernet/intel/ice/ice_idc_int.h       |    1 -
 drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h     |    2 +
 drivers/net/ethernet/intel/ice/ice_lib.c           |  596 +-
 drivers/net/ethernet/intel/ice/ice_lib.h           |   22 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  466 +-
 drivers/net/ethernet/intel/ice/ice_osdep.h         |   12 +-
 .../net/ethernet/intel/ice/ice_pf_vsi_vlan_ops.c   |   38 +
 .../net/ethernet/intel/ice/ice_pf_vsi_vlan_ops.h   |   13 +
 drivers/net/ethernet/intel/ice/ice_protocol_type.h |   21 +
 drivers/net/ethernet/intel/ice/ice_ptp.c           |    8 +
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c        |   31 +
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h        |    7 +
 drivers/net/ethernet/intel/ice/ice_repr.c          |  111 +-
 drivers/net/ethernet/intel/ice/ice_repr.h          |    1 -
 drivers/net/ethernet/intel/ice/ice_sriov.c         | 2205 +++++--
 drivers/net/ethernet/intel/ice/ice_sriov.h         |  163 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        | 1154 +++-
 drivers/net/ethernet/intel/ice/ice_switch.h        |   33 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c        |  152 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.h        |    3 +
 drivers/net/ethernet/intel/ice/ice_trace.h         |   24 +
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   58 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h          |   13 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c      |   24 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h      |   30 +-
 drivers/net/ethernet/intel/ice/ice_type.h          |   20 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.c        | 1029 +++
 drivers/net/ethernet/intel/ice/ice_vf_lib.h        |  290 +
 .../net/ethernet/intel/ice/ice_vf_lib_private.h    |   40 +
 drivers/net/ethernet/intel/ice/ice_vf_mbx.c        |  532 ++
 drivers/net/ethernet/intel/ice/ice_vf_mbx.h        |   52 +
 .../net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c   |  211 +
 .../net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.h   |   19 +
 .../ice/{ice_virtchnl_pf.c => ice_virtchnl.c}      | 6704 ++++++++------------
 drivers/net/ethernet/intel/ice/ice_virtchnl.h      |   82 +
 .../ethernet/intel/ice/ice_virtchnl_allowlist.c    |   10 +
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.c |   14 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_fdir.h |    1 +
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h   |  343 -
 drivers/net/ethernet/intel/ice/ice_vlan.h          |   18 +
 drivers/net/ethernet/intel/ice/ice_vlan_mode.c     |  439 ++
 drivers/net/ethernet/intel/ice/ice_vlan_mode.h     |   13 +
 drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c  |  707 +++
 drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h  |   32 +
 drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.c  |  103 +
 drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.h  |   29 +
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  396 +-
 drivers/net/ethernet/intel/ice/ice_xsk.h           |   28 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |    4 -
 drivers/net/ethernet/intel/igb/igb_main.c          |   38 +-
 drivers/net/ethernet/intel/igb/igb_ptp.c           |    6 +-
 drivers/net/ethernet/intel/igbvf/netdev.c          |   22 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |   35 +-
 drivers/net/ethernet/intel/ixgb/ixgb_main.c        |   19 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |    6 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c    |   36 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |   21 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   63 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_mbx.h       |    2 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |  207 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.h     |    4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h      |   10 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   27 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf.h       |    2 +
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |   33 +-
 drivers/net/ethernet/intel/ixgbevf/mbx.h           |    2 +
 drivers/net/ethernet/intel/ixgbevf/vf.c            |   42 +
 drivers/net/ethernet/intel/ixgbevf/vf.h            |    1 +
 drivers/net/ethernet/jme.c                         |    3 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c         |   14 +-
 drivers/net/ethernet/marvell/mvneta.c              |  331 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  247 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |   13 +
 .../ethernet/marvell/octeontx2/af/lmac_common.h    |   10 +
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   19 +
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c    |  131 +-
 drivers/net/ethernet/marvell/octeontx2/af/ptp.h    |    2 +
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c    |  224 +-
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h    |   30 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |    3 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  117 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   17 +-
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |    3 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   79 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   21 +
 .../ethernet/marvell/octeontx2/nic/otx2_dcbnl.c    |  170 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |   30 +-
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |   50 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   75 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  |    8 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.h  |   15 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |   48 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |    6 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   55 +-
 drivers/net/ethernet/marvell/prestera/prestera.h   |    5 +
 .../net/ethernet/marvell/prestera/prestera_acl.c   |  124 +-
 .../net/ethernet/marvell/prestera/prestera_acl.h   |   30 +-
 .../net/ethernet/marvell/prestera/prestera_flow.c  |    5 +-
 .../net/ethernet/marvell/prestera/prestera_flow.h  |    3 +-
 .../ethernet/marvell/prestera/prestera_flower.c    |   87 +-
 .../ethernet/marvell/prestera/prestera_flower.h    |    1 -
 .../net/ethernet/marvell/prestera/prestera_hw.c    |   55 +
 .../net/ethernet/marvell/prestera/prestera_hw.h    |    6 +
 .../net/ethernet/marvell/prestera/prestera_main.c  |   13 +
 .../ethernet/marvell/prestera/prestera_router.c    |  412 ++
 .../ethernet/marvell/prestera/prestera_router_hw.c |  132 +-
 .../ethernet/marvell/prestera/prestera_router_hw.h |   44 +
 drivers/net/ethernet/mediatek/mtk_star_emac.c      |    2 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |    3 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |    1 -
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   11 +-
 drivers/net/ethernet/mellanox/mlx5/core/alloc.c    |   64 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |  355 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       |   18 +-
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c  |   59 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   49 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |  106 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |    3 +
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |    3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c   |   42 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.h   |    1 -
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/rss.c   |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/selq.c  |  231 +
 drivers/net/ethernet/mellanox/mlx5/core/en/selq.h  |   51 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/accept.c |    8 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.c    |   80 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.h    |   32 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/csum.c   |    5 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c |   27 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/drop.c   |    6 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/goto.c   |   15 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/mark.c   |    3 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/mirred.c |   20 +-
 .../mellanox/mlx5/core/en/tc/act/mirred_nic.c      |    6 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/mpls.c   |   16 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/pedit.c  |   64 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/pedit.h  |    2 -
 .../ethernet/mellanox/mlx5/core/en/tc/act/ptype.c  |    3 +-
 .../mlx5/core/en/tc/act/redirect_ingress.c         |   11 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/sample.c |   40 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/sample.h |   14 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/trap.c   |    8 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/tun.c    |    6 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/vlan.c   |   32 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/vlan.h   |    1 -
 .../mellanox/mlx5/core/en/tc/act/vlan_mangle.c     |   11 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/ct_fs.h  |   49 +
 .../ethernet/mellanox/mlx5/core/en/tc/ct_fs_dmfs.c |   79 +
 .../ethernet/mellanox/mlx5/core/en/tc/ct_fs_smfs.c |  372 ++
 .../ethernet/mellanox/mlx5/core/en/tc/post_act.c   |   68 +-
 .../ethernet/mellanox/mlx5/core/en/tc/post_act.h   |    8 +
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |   89 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.h |    6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  209 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |    6 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |   21 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |   75 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.h  |    6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |   53 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |  212 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |   16 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    |   16 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |    2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |    5 +-
 .../mellanox/mlx5/core/en_accel/en_accel.h         |    9 -
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |    1 -
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |    6 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c |   12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  167 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   36 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |    6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  223 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   78 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |   28 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  844 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   39 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  128 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   10 +-
 .../mellanox/mlx5/core/esw/acl/ingress_ofld.c      |   87 +
 .../net/ethernet/mellanox/mlx5/core/esw/acl/ofld.h |   15 +
 .../ethernet/mellanox/mlx5/core/esw/indir_table.c  |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   20 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  180 +-
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |    6 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/core.c    |    1 -
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |   14 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h   |    3 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   25 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |    7 +
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |    1 -
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |   57 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h |    3 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |    1 -
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |  142 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h  |    2 +
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c   |    2 +-
 .../net/ethernet/mellanox/mlx5/core/lib/hv_vhca.h  |    7 -
 .../net/ethernet/mellanox/mlx5/core/lib/port_tun.c |    1 -
 drivers/net/ethernet/mellanox/mlx5/core/lib/smfs.c |   68 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/smfs.h |   36 +
 .../net/ethernet/mellanox/mlx5/core/lib/vxlan.c    |    1 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   13 +-
 drivers/net/ethernet/mellanox/mlx5/core/mcg.c      |    1 -
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |    1 -
 drivers/net/ethernet/mellanox/mlx5/core/mr.c       |    1 -
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |   41 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/pd.c       |    1 -
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |   57 +-
 drivers/net/ethernet/mellanox/mlx5/core/rl.c       |    1 -
 .../mellanox/mlx5/core/steering/dr_action.c        |   24 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_dbg.c  |   17 +-
 .../mellanox/mlx5/core/steering/dr_domain.c        |    2 +-
 .../mellanox/mlx5/core/steering/dr_icm_pool.c      |   57 +-
 .../mellanox/mlx5/core/steering/dr_matcher.c       |   37 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |   71 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |   34 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |  129 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.h  |    7 +-
 .../mellanox/mlx5/core/steering/dr_ste_v0.c        |   10 +-
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        |  253 +-
 .../mellanox/mlx5/core/steering/dr_ste_v1.h        |   94 +
 .../mellanox/mlx5/core/steering/dr_ste_v2.c        |  231 +
 .../mellanox/mlx5/core/steering/dr_table.c         |   23 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |   36 +-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |   11 +
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |    5 +-
 drivers/net/ethernet/mellanox/mlx5/core/uar.c      |    9 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c         |  143 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h         |   17 +-
 .../mellanox/mlxsw/core_acl_flex_actions.c         |   77 +
 .../mellanox/mlxsw/core_acl_flex_actions.h         |    3 +
 drivers/net/ethernet/mellanox/mlxsw/core_env.c     |  159 +-
 drivers/net/ethernet/mellanox/mlxsw/core_env.h     |    3 +-
 drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c   |   79 +-
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c |   66 +-
 drivers/net/ethernet/mellanox/mlxsw/minimal.c      |   10 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h          |   76 +-
 drivers/net/ethernet/mellanox/mlxsw/resources.h    |    2 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  178 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |   32 +-
 .../net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c   |    5 +-
 .../ethernet/mellanox/mlxsw/spectrum2_acl_tcam.c   |   12 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c |   91 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_dpipe.c   |    4 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_ethtool.c |   28 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_flower.c  |   53 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c |    3 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  305 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.h  |    6 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c    |    3 +-
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c   |    6 +-
 drivers/net/ethernet/micrel/ks8851_spi.c           |    6 +-
 drivers/net/ethernet/micrel/ksz884x.c              |    9 +-
 drivers/net/ethernet/microchip/enc28j60.c          |    6 +-
 drivers/net/ethernet/microchip/encx24j600.c        |    4 +-
 drivers/net/ethernet/microchip/lan743x_ethtool.c   |  380 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |  276 +-
 drivers/net/ethernet/microchip/lan743x_main.h      |  221 +-
 drivers/net/ethernet/microchip/lan743x_ptp.c       |  566 +-
 drivers/net/ethernet/microchip/lan743x_ptp.h       |   10 +
 drivers/net/ethernet/microchip/lan966x/Kconfig     |    1 +
 drivers/net/ethernet/microchip/lan966x/Makefile    |    3 +-
 .../ethernet/microchip/lan966x/lan966x_ethtool.c   |   34 +
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |  148 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.h  |   56 +
 .../net/ethernet/microchip/lan966x/lan966x_mdb.c   |   45 +
 .../ethernet/microchip/lan966x/lan966x_phylink.c   |    9 +
 .../net/ethernet/microchip/lan966x/lan966x_ptp.c   |  618 ++
 .../net/ethernet/microchip/lan966x/lan966x_regs.h  |  121 +
 .../ethernet/microchip/lan966x/lan966x_switchdev.c |   85 +-
 drivers/net/ethernet/microchip/sparx5/Makefile     |    3 +-
 .../net/ethernet/microchip/sparx5/sparx5_ethtool.c |   34 +
 .../net/ethernet/microchip/sparx5/sparx5_fdma.c    |    2 +
 .../ethernet/microchip/sparx5/sparx5_mactable.c    |   44 +-
 .../net/ethernet/microchip/sparx5/sparx5_main.c    |   26 +-
 .../net/ethernet/microchip/sparx5/sparx5_main.h    |   92 +-
 .../ethernet/microchip/sparx5/sparx5_main_regs.h   |  335 +-
 .../net/ethernet/microchip/sparx5/sparx5_netdev.c  |   42 +-
 .../net/ethernet/microchip/sparx5/sparx5_packet.c  |   37 +-
 .../net/ethernet/microchip/sparx5/sparx5_pgid.c    |   60 +
 .../net/ethernet/microchip/sparx5/sparx5_phylink.c |   10 +
 drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c |  685 ++
 .../ethernet/microchip/sparx5/sparx5_switchdev.c   |  251 +-
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |    4 +-
 drivers/net/ethernet/microsoft/mana/mana.h         |   15 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |   70 +-
 drivers/net/ethernet/microsoft/mana/mana_ethtool.c |   35 +-
 drivers/net/ethernet/moxa/moxart_ether.c           |    4 +-
 drivers/net/ethernet/mscc/ocelot.c                 |  662 +-
 drivers/net/ethernet/mscc/ocelot.h                 |   18 +-
 drivers/net/ethernet/mscc/ocelot_flower.c          |   38 +-
 drivers/net/ethernet/mscc/ocelot_io.c              |   13 +
 drivers/net/ethernet/mscc/ocelot_mrp.c             |   64 +-
 drivers/net/ethernet/mscc/ocelot_net.c             |  251 +-
 drivers/net/ethernet/mscc/ocelot_police.c          |   41 +
 drivers/net/ethernet/mscc/ocelot_police.h          |    5 +
 drivers/net/ethernet/mscc/ocelot_vcap.c            |   66 +-
 drivers/net/ethernet/netronome/nfp/Makefile        |    8 +
 drivers/net/ethernet/netronome/nfp/flower/action.c |   58 +
 drivers/net/ethernet/netronome/nfp/flower/cmsg.h   |    7 +
 drivers/net/ethernet/netronome/nfp/flower/main.c   |    4 +-
 drivers/net/ethernet/netronome/nfp/flower/main.h   |   49 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |   16 +-
 .../net/ethernet/netronome/nfp/flower/qos_conf.c   |  470 +-
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    |   12 +-
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c       | 1350 ++++
 drivers/net/ethernet/netronome/nfp/nfd3/nfd3.h     |  106 +
 drivers/net/ethernet/netronome/nfp/nfd3/rings.c    |  275 +
 drivers/net/ethernet/netronome/nfp/nfd3/xsk.c      |  408 ++
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c       | 1524 +++++
 drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h     |  129 +
 drivers/net/ethernet/netronome/nfp/nfdk/rings.c    |  195 +
 drivers/net/ethernet/netronome/nfp/nfp_app.c       |    2 +-
 drivers/net/ethernet/netronome/nfp/nfp_app.h       |   12 +-
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c   |   58 +-
 drivers/net/ethernet/netronome/nfp/nfp_main.c      |   43 +-
 drivers/net/ethernet/netronome/nfp/nfp_main.h      |    8 +-
 drivers/net/ethernet/netronome/nfp/nfp_net.h       |  204 +-
 .../net/ethernet/netronome/nfp/nfp_net_common.c    | 2188 +------
 drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h  |   87 +-
 .../net/ethernet/netronome/nfp/nfp_net_debugfs.c   |   66 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_dp.c    |  442 ++
 drivers/net/ethernet/netronome/nfp/nfp_net_dp.h    |  215 +
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   18 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_main.c  |   51 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c  |    4 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h |    3 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_xsk.c   |  170 +
 drivers/net/ethernet/netronome/nfp/nfp_net_xsk.h   |   41 +
 .../net/ethernet/netronome/nfp/nfp_netvf_main.c    |   32 +-
 drivers/net/ethernet/netronome/nfp/nfp_port.c      |   17 -
 drivers/net/ethernet/netronome/nfp/nfp_port.h      |    5 +-
 .../ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c  |   29 +-
 .../ethernet/netronome/nfp/nfpcore/nfp6000_pcie.h  |    3 +-
 .../net/ethernet/netronome/nfp/nfpcore/nfp_cpp.h   |    4 -
 .../ethernet/netronome/nfp/nfpcore/nfp_cpplib.c    |    9 +-
 .../net/ethernet/netronome/nfp/nfpcore/nfp_dev.c   |   49 +
 .../net/ethernet/netronome/nfp/nfpcore/nfp_dev.h   |   34 +
 .../net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c   |    2 +-
 drivers/net/ethernet/ni/nixge.c                    |    5 +-
 drivers/net/ethernet/packetengines/yellowfin.c     |    2 +-
 drivers/net/ethernet/pensando/ionic/ionic.h        |    7 +-
 .../net/ethernet/pensando/ionic/ionic_bus_pci.c    |   17 +-
 drivers/net/ethernet/pensando/ionic/ionic_dev.c    |  164 +-
 drivers/net/ethernet/pensando/ionic/ionic_dev.h    |    6 +-
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    |    6 +-
 drivers/net/ethernet/pensando/ionic/ionic_if.h     |    6 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  206 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.h    |    2 +-
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |  125 +-
 .../net/ethernet/pensando/ionic/ionic_rx_filter.c  |   37 +-
 drivers/net/ethernet/pensando/ionic/ionic_stats.c  |    1 -
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |   67 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |    3 +
 .../net/ethernet/qlogic/qed/qed_init_fw_funcs.c    |    2 -
 drivers/net/ethernet/qlogic/qed/qed_mcp.c          |   90 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.h          |   38 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c        |   29 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.h        |    1 +
 .../net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c    |    2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c     |    3 +-
 drivers/net/ethernet/qualcomm/qca_spi.c            |    6 +-
 drivers/net/ethernet/qualcomm/qca_uart.c           |    2 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   |    2 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   |    4 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   94 +-
 drivers/net/ethernet/realtek/r8169_phy_config.c    |   71 +-
 drivers/net/ethernet/renesas/ravb_main.c           |   15 +-
 drivers/net/ethernet/renesas/sh_eth.c              |   18 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |    2 +-
 drivers/net/ethernet/sfc/ef10.c                    |   26 +
 drivers/net/ethernet/sfc/ef100_nic.c               |    9 +
 drivers/net/ethernet/sfc/efx_channels.c            |   63 +-
 drivers/net/ethernet/sfc/net_driver.h              |    2 +
 drivers/net/ethernet/sfc/nic_common.h              |    5 +
 drivers/net/ethernet/sfc/rx_common.c               |   18 +-
 drivers/net/ethernet/sfc/rx_common.h               |    6 +
 drivers/net/ethernet/sfc/siena.c                   |    8 +
 drivers/net/ethernet/socionext/netsec.c            |    2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |    9 +-
 .../net/ethernet/stmicro/stmmac/dwmac-mediatek.c   |  388 +-
 .../ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c    |   37 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |   30 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |    2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |    4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  154 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |   22 +-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |    8 +-
 drivers/net/ethernet/sun/cassini.c                 |   23 +-
 drivers/net/ethernet/sun/niu.c                     |    2 +-
 drivers/net/ethernet/ti/am65-cpsw-ethtool.c        |   56 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  228 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h           |    5 +-
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c      |    4 -
 drivers/net/ethernet/ti/cpsw_ethtool.c             |    6 +-
 drivers/net/ethernet/ti/cpsw_switchdev.c           |    4 -
 drivers/net/ethernet/ti/davinci_emac.c             |   25 +-
 drivers/net/ethernet/ti/netcp_core.c               |    2 +-
 drivers/net/ethernet/vertexcom/mse102x.c           |    6 +-
 drivers/net/ethernet/wiznet/w5100-spi.c            |    4 +-
 drivers/net/ethernet/wiznet/w5100.c                |    2 +-
 drivers/net/ethernet/xilinx/Kconfig                |    2 +-
 drivers/net/ethernet/xilinx/ll_temac.h             |    4 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c        |    7 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |   20 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  608 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |    2 +-
 drivers/net/fjes/fjes_main.c                       |    5 +-
 drivers/net/geneve.c                               |   89 +-
 drivers/net/gtp.c                                  |  567 +-
 drivers/net/hamradio/baycom_epp.c                  |    4 +-
 drivers/net/hamradio/dmascc.c                      |    7 +-
 drivers/net/hyperv/netvsc.c                        |   25 +-
 drivers/net/ieee802154/adf7242.c                   |    4 +-
 drivers/net/ieee802154/at86rf230.c                 |    4 +-
 drivers/net/ieee802154/atusb.c                     |  186 +-
 drivers/net/ieee802154/ca8210.c                    |    6 +-
 drivers/net/ieee802154/cc2520.c                    |    4 +-
 drivers/net/ieee802154/mac802154_hwsim.c           |    2 +-
 drivers/net/ieee802154/mcr20a.c                    |    4 +-
 drivers/net/ieee802154/mrf24j40.c                  |    4 +-
 drivers/net/ipa/gsi_trans.c                        |   11 +
 drivers/net/ipa/gsi_trans.h                        |   10 +
 drivers/net/ipa/ipa_data-v3.1.c                    |    2 +
 drivers/net/ipa/ipa_data-v3.5.1.c                  |    2 +
 drivers/net/ipa/ipa_data-v4.11.c                   |    2 +
 drivers/net/ipa/ipa_data-v4.2.c                    |    2 +
 drivers/net/ipa/ipa_data-v4.5.c                    |    2 +
 drivers/net/ipa/ipa_data-v4.9.c                    |    2 +
 drivers/net/ipa/ipa_data.h                         |    2 +
 drivers/net/ipa/ipa_endpoint.c                     |  217 +-
 drivers/net/ipa/ipa_endpoint.h                     |    8 +-
 drivers/net/ipa/ipa_power.c                        |  178 +-
 drivers/net/ipvlan/ipvlan_core.c                   |    2 +-
 drivers/net/loopback.c                             |    6 +-
 drivers/net/macsec.c                               |    6 +-
 drivers/net/macvlan.c                              |   22 +-
 drivers/net/macvtap.c                              |    6 +
 drivers/net/mctp/Kconfig                           |   12 +
 drivers/net/mctp/Makefile                          |    1 +
 drivers/net/mctp/mctp-i2c.c                        | 1082 ++++
 drivers/net/mctp/mctp-serial.c                     |    2 +-
 drivers/net/mdio/mdio-mscc-miim.c                  |   67 +-
 drivers/net/mdio/mdio-mux.c                        |    4 +-
 drivers/net/mdio/mdio-xgene.c                      |    3 +-
 drivers/net/mhi_net.c                              |    2 +-
 drivers/net/net_failover.c                         |    2 +-
 drivers/net/netdevsim/Makefile                     |    2 +-
 drivers/net/netdevsim/dev.c                        |  102 +-
 drivers/net/netdevsim/hwstats.c                    |  486 ++
 drivers/net/netdevsim/netdevsim.h                  |   25 +-
 drivers/net/ntb_netdev.c                           |    2 +-
 drivers/net/pcs/pcs-xpcs.c                         |   41 +-
 drivers/net/phy/Kconfig                            |    1 +
 drivers/net/phy/aquantia_main.c                    |    4 +-
 drivers/net/phy/at803x.c                           |  146 +-
 drivers/net/phy/dp83640.c                          |   19 +-
 drivers/net/phy/micrel.c                           | 1103 +++-
 drivers/net/phy/microchip_t1.c                     |  359 +-
 drivers/net/phy/mscc/mscc_ptp.c                    |    2 +-
 drivers/net/phy/nxp-c45-tja11xx.c                  |    2 +-
 drivers/net/phy/phy-core.c                         |   22 +-
 drivers/net/phy/phy_device.c                       |   19 +-
 drivers/net/phy/phylink.c                          |   90 +-
 drivers/net/phy/sfp-bus.c                          |    6 +
 drivers/net/phy/sfp.c                              |   48 +-
 drivers/net/phy/spi_ks8995.c                       |    4 +-
 drivers/net/plip/plip.c                            |    2 +-
 drivers/net/rionet.c                               |    2 +-
 drivers/net/sb1000.c                               |    2 +-
 drivers/net/slip/slip.c                            |    2 +-
 drivers/net/tap.c                                  |   38 +-
 drivers/net/team/team.c                            |    5 +
 drivers/net/tun.c                                  |  102 +-
 drivers/net/usb/Kconfig                            |    1 +
 drivers/net/usb/asix.h                             |   10 +-
 drivers/net/usb/asix_common.c                      |   81 +-
 drivers/net/usb/asix_devices.c                     |  104 +-
 drivers/net/usb/cdc_mbim.c                         |    1 +
 drivers/net/usb/gl620a.c                           |    2 +-
 drivers/net/usb/hso.c                              |    2 +-
 drivers/net/usb/smsc95xx.c                         |   25 +
 drivers/net/veth.c                                 |  194 +-
 drivers/net/virtio_net.c                           |    3 +-
 drivers/net/vrf.c                                  |    9 +-
 drivers/net/vxlan/Makefile                         |    7 +
 drivers/net/{vxlan.c => vxlan/vxlan_core.c}        |  495 +-
 drivers/net/vxlan/vxlan_multicast.c                |  272 +
 drivers/net/vxlan/vxlan_private.h                  |  162 +
 drivers/net/vxlan/vxlan_vnifilter.c                |  999 +++
 drivers/net/wan/lmc/lmc_main.c                     |    3 +-
 drivers/net/wan/slic_ds26522.c                     |    3 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |    2 +-
 drivers/net/wireless/ath/ath10k/core.c             |   16 +
 drivers/net/wireless/ath/ath10k/htt.c              |  153 +
 drivers/net/wireless/ath/ath10k/htt.h              |  296 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |  331 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c           |   36 +-
 drivers/net/wireless/ath/ath10k/hw.c               |   15 +-
 drivers/net/wireless/ath/ath10k/hw.h               |   27 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h          |   40 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |   17 +-
 drivers/net/wireless/ath/ath10k/swap.h             |    2 +-
 drivers/net/wireless/ath/ath10k/txrx.c             |    2 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |    2 +-
 drivers/net/wireless/ath/ath10k/wow.c              |    7 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |    6 +-
 drivers/net/wireless/ath/ath11k/ce.h               |    2 +-
 drivers/net/wireless/ath/ath11k/core.c             |   15 +
 drivers/net/wireless/ath/ath11k/core.h             |   12 +-
 drivers/net/wireless/ath/ath11k/dbring.c           |   19 +-
 drivers/net/wireless/ath/ath11k/debugfs.c          |  515 ++
 drivers/net/wireless/ath/ath11k/debugfs.h          |  180 +-
 drivers/net/wireless/ath/ath11k/dp.h               |   13 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  357 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |   35 +-
 drivers/net/wireless/ath/ath11k/hal_desc.h         |    1 +
 drivers/net/wireless/ath/ath11k/hal_rx.c           |  471 +-
 drivers/net/wireless/ath/ath11k/hal_rx.h           |  143 +-
 drivers/net/wireless/ath/ath11k/hw.c               |   23 +
 drivers/net/wireless/ath/ath11k/hw.h               |    3 +
 drivers/net/wireless/ath/ath11k/mac.c              |  116 +-
 drivers/net/wireless/ath/ath11k/mhi.c              |    5 +-
 drivers/net/wireless/ath/ath11k/pci.c              |   10 +
 drivers/net/wireless/ath/ath11k/peer.c             |   40 +-
 drivers/net/wireless/ath/ath11k/qmi.c              |   15 +-
 drivers/net/wireless/ath/ath11k/qmi.h              |    1 +
 drivers/net/wireless/ath/ath11k/reg.c              |   25 +-
 drivers/net/wireless/ath/ath11k/rx_desc.h          |    6 +-
 drivers/net/wireless/ath/ath11k/spectral.c         |    2 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |  300 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |  132 +
 drivers/net/wireless/ath/ath5k/ath5k.h             |    4 -
 drivers/net/wireless/ath/ath5k/dma.c               |   23 +-
 drivers/net/wireless/ath/ath5k/eeprom.c            |    3 +
 drivers/net/wireless/ath/ath6kl/txrx.c             |    2 +-
 drivers/net/wireless/ath/ath6kl/usb.c              |    1 +
 drivers/net/wireless/ath/ath6kl/wmi.c              |   22 +-
 drivers/net/wireless/ath/ath6kl/wmi.h              |   38 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |    3 +-
 drivers/net/wireless/ath/ath9k/eeprom.c            |    6 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |    5 +
 drivers/net/wireless/ath/ath9k/mci.c               |    2 +-
 drivers/net/wireless/ath/ath9k/rng.c               |   72 +-
 drivers/net/wireless/ath/carl9170/carl9170.h       |    1 -
 drivers/net/wireless/ath/carl9170/fwdesc.h         |    2 +-
 drivers/net/wireless/ath/carl9170/main.c           |   61 +-
 drivers/net/wireless/ath/carl9170/wlan.h           |    2 +-
 drivers/net/wireless/ath/dfs_pattern_detector.c    |    6 +-
 drivers/net/wireless/ath/regd.c                    |   10 +-
 drivers/net/wireless/ath/spectral_common.h         |    4 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |  107 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |    2 +-
 drivers/net/wireless/ath/wcn36xx/txrx.c            |   36 +
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h         |   14 +
 drivers/net/wireless/ath/wil6210/txrx.c            |    2 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    |    4 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   35 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |    2 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   18 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |    3 +-
 .../broadcom/brcm80211/brcmfmac/firmware.c         |    2 +
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.c    |   34 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.h    |   28 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |    2 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |   10 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.h         |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |    5 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |   10 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |   20 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   78 +-
 .../wireless/broadcom/brcm80211/brcmfmac/proto.h   |    6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/xtlv.h    |    2 +-
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |    2 +
 drivers/net/wireless/cisco/airo.c                  |    2 +-
 drivers/net/wireless/intel/iwlwifi/Kconfig         |    1 +
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   55 +-
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c  |    2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |    1 +
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c        |    7 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |  229 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |   39 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |   13 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/config.h |   33 -
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   |  148 +-
 .../net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h    |   37 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h  |   19 +-
 .../net/wireless/intel/iwlwifi/fw/api/mac-cfg.h    |   34 +
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h    |  127 +-
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |   52 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/phy.h    |   16 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h  |   27 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rfi.h    |   10 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     |    6 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |    7 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/txq.h    |    4 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |  331 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |    5 +-
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c    |    4 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   36 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.c        |    7 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |   14 +-
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |    5 +-
 drivers/net/wireless/intel/iwlwifi/fw/paging.c     |    4 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |   22 +-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |    5 +-
 drivers/net/wireless/intel/iwlwifi/fw/smem.c       |    4 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c       |   12 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   17 +-
 .../wireless/intel/iwlwifi/iwl-context-info-gen3.h |    4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |    3 +
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |   72 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h   |    4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  181 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h       |    2 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-read.c   |   12 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h        |   30 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        |   18 +-
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h |    5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |   43 +-
 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c    |    4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |   13 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c     |   12 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   59 +-
 drivers/net/wireless/intel/iwlwifi/mei/main.c      |   10 +-
 drivers/net/wireless/intel/iwlwifi/mei/net.c       |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   29 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |   18 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |   25 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-responder.c |   24 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  405 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   50 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  361 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   17 +-
 .../net/wireless/intel/iwlwifi/mvm/offloading.c    |    3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   34 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |   43 +-
 drivers/net/wireless/intel/iwlwifi/mvm/quota.c     |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rfi.c       |   13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |   32 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |    2 -
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |    6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |    7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  294 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  313 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |    3 +
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   20 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        |   11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   20 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   40 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |    5 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   38 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   46 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  112 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   51 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |    4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |   14 +-
 drivers/net/wireless/intel/iwlwifi/queue/tx.c      |  101 +-
 drivers/net/wireless/intel/iwlwifi/queue/tx.h      |   21 +-
 drivers/net/wireless/intersil/p54/p54spi.c         |    4 +-
 drivers/net/wireless/mac80211_hwsim.c              |  410 +-
 drivers/net/wireless/marvell/libertas/if_spi.c     |    4 +-
 drivers/net/wireless/marvell/libertas/rx.c         |    4 +-
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c     |    2 +-
 drivers/net/wireless/marvell/mwifiex/uap_txrx.c    |    2 +-
 drivers/net/wireless/marvell/mwifiex/util.c        |    2 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   14 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   63 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   36 +-
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |   14 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |    3 +
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |   29 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |    1 -
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  194 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   36 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |  236 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |    1 +
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   23 +-
 drivers/net/wireless/mediatek/mt76/mt7615/sdio.c   |   15 +-
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c    |   91 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_mcu.c    |   36 +-
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |   76 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  422 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |  118 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |    3 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c   |    5 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |   27 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |   30 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_regs.h  |    2 +
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/Kconfig  |   13 +-
 drivers/net/wireless/mediatek/mt76/mt7915/Makefile |    1 +
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |  225 +-
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    |  466 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |  188 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h |   54 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |  310 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  777 ++-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.h    |   15 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |  152 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    | 1535 ++---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |   63 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |  691 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |  130 +-
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |  259 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |  893 ++-
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c    | 1212 ++++
 .../net/wireless/mediatek/mt76/mt7915/testmode.c   |  106 +-
 drivers/net/wireless/mediatek/mt76/mt7921/Kconfig  |   11 +
 drivers/net/wireless/mediatek/mt76/mt7921/Makefile |    2 +
 .../net/wireless/mediatek/mt76/mt7921/debugfs.c    |   65 +-
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c    |  121 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |   70 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |  209 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.h    |    4 +
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   70 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  313 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |   63 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |  126 +
 .../net/wireless/mediatek/mt76/mt7921/pci_mac.c    |   48 +-
 .../net/wireless/mediatek/mt76/mt7921/pci_mcu.c    |   20 +-
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |   64 +-
 drivers/net/wireless/mediatek/mt76/mt7921/sdio.c   |   22 +-
 .../net/wireless/mediatek/mt76/mt7921/sdio_mac.c   |   89 +-
 .../net/wireless/mediatek/mt76/mt7921/sdio_mcu.c   |   40 +-
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c    |  306 +
 .../net/wireless/mediatek/mt76/mt7921/usb_mac.c    |  252 +
 drivers/net/wireless/mediatek/mt76/sdio.c          |   14 +-
 drivers/net/wireless/mediatek/mt76/sdio.h          |    2 +
 drivers/net/wireless/mediatek/mt76/sdio_txrx.c     |   28 +-
 drivers/net/wireless/mediatek/mt76/testmode.c      |    5 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |  125 +-
 drivers/net/wireless/microchip/wilc1000/spi.c      |    9 +-
 drivers/net/wireless/ray_cs.c                      |    6 +
 drivers/net/wireless/realtek/rtlwifi/cam.c         |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/phy.c   |   32 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/sw.c    |    1 +
 .../net/wireless/realtek/rtlwifi/rtl8821ae/dm.c    |    6 +-
 drivers/net/wireless/realtek/rtw88/coex.c          |  298 +-
 drivers/net/wireless/realtek/rtw88/coex.h          |    5 +
 drivers/net/wireless/realtek/rtw88/debug.c         |    6 +-
 drivers/net/wireless/realtek/rtw88/debug.h         |    1 +
 drivers/net/wireless/realtek/rtw88/fw.c            |   59 +-
 drivers/net/wireless/realtek/rtw88/fw.h            |    9 +
 drivers/net/wireless/realtek/rtw88/mac80211.c      |   13 +-
 drivers/net/wireless/realtek/rtw88/main.c          |  127 +-
 drivers/net/wireless/realtek/rtw88/main.h          |   52 +-
 drivers/net/wireless/realtek/rtw88/rtw8723d.c      |    1 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |    4 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |    5 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   47 +-
 drivers/net/wireless/realtek/rtw88/sar.c           |    8 +-
 drivers/net/wireless/realtek/rtw88/tx.c            |    2 +-
 drivers/net/wireless/realtek/rtw89/Kconfig         |    4 +
 drivers/net/wireless/realtek/rtw89/Makefile        |   13 +-
 drivers/net/wireless/realtek/rtw89/cam.c           |   40 +-
 drivers/net/wireless/realtek/rtw89/cam.h           |    5 +
 drivers/net/wireless/realtek/rtw89/coex.c          |   41 +-
 drivers/net/wireless/realtek/rtw89/core.c          |  679 +-
 drivers/net/wireless/realtek/rtw89/core.h          |  291 +-
 drivers/net/wireless/realtek/rtw89/debug.c         |   93 +-
 drivers/net/wireless/realtek/rtw89/debug.h         |    1 +
 drivers/net/wireless/realtek/rtw89/efuse.c         |  160 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |  686 +-
 drivers/net/wireless/realtek/rtw89/fw.h            |  491 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |  646 +-
 drivers/net/wireless/realtek/rtw89/mac.h           |   84 +-
 drivers/net/wireless/realtek/rtw89/mac80211.c      |  147 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |  361 +-
 drivers/net/wireless/realtek/rtw89/pci.h           |   81 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |  521 +-
 drivers/net/wireless/realtek/rtw89/phy.h           |   75 +
 drivers/net/wireless/realtek/rtw89/reg.h           |  217 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |   79 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a.h      |    2 +
 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk.c  |   86 +-
 .../wireless/realtek/rtw89/rtw8852a_rfk_table.c    | 2744 ++++----
 .../wireless/realtek/rtw89/rtw8852a_rfk_table.h    |   49 +-
 drivers/net/wireless/realtek/rtw89/rtw8852ae.c     |   46 +
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |  529 ++
 drivers/net/wireless/realtek/rtw89/rtw8852c.h      |   76 +
 drivers/net/wireless/realtek/rtw89/rtw8852ce.c     |   43 +
 drivers/net/wireless/realtek/rtw89/txrx.h          |    3 +
 drivers/net/wireless/st/cw1200/cw1200_spi.c        |    4 +-
 drivers/net/wireless/st/cw1200/queue.c             |    3 +-
 drivers/net/wireless/st/cw1200/wsm.c               |    2 +-
 drivers/net/wireless/ti/wl1251/spi.c               |    4 +-
 drivers/net/wireless/ti/wlcore/spi.c               |    4 +-
 drivers/net/wireless/zydas/zd1201.c                |    3 +-
 drivers/net/wwan/iosm/iosm_ipc_debugfs.c           |    5 +-
 drivers/net/wwan/iosm/iosm_ipc_imem.c              |   54 +-
 drivers/net/wwan/iosm/iosm_ipc_imem.h              |    7 +
 drivers/net/wwan/iosm/iosm_ipc_mmio.c              |    6 +-
 drivers/net/wwan/iosm/iosm_ipc_mmio.h              |    6 +-
 drivers/net/wwan/iosm/iosm_ipc_mux.c               |   21 +-
 drivers/net/wwan/iosm/iosm_ipc_mux.h               |  133 +-
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c         |  742 ++-
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.h         |  142 +-
 drivers/net/wwan/iosm/iosm_ipc_pcie.c              |    1 +
 drivers/net/wwan/iosm/iosm_ipc_pcie.h              |    1 +
 drivers/net/wwan/qcom_bam_dmux.c                   |    2 +-
 drivers/net/wwan/wwan_core.c                       |   36 +
 drivers/nfc/nfcmrvl/spi.c                          |    3 +-
 drivers/nfc/st-nci/spi.c                           |    4 +-
 drivers/nfc/st-nci/vendor_cmds.c                   |    2 +-
 drivers/nfc/st21nfca/i2c.c                         |    3 +-
 drivers/nfc/st21nfca/vendor_cmds.c                 |    4 +-
 drivers/nfc/st95hf/core.c                          |    4 +-
 drivers/nfc/trf7970a.c                             |    4 +-
 drivers/phy/freescale/Kconfig                      |   10 +
 drivers/phy/freescale/Makefile                     |    1 +
 drivers/phy/freescale/phy-fsl-lynx-28g.c           |  623 ++
 drivers/platform/chrome/cros_ec.c                  |    4 +-
 drivers/platform/chrome/cros_ec.h                  |    2 +-
 drivers/platform/chrome/cros_ec_i2c.c              |    4 +-
 drivers/platform/chrome/cros_ec_lpc.c              |    4 +-
 drivers/platform/chrome/cros_ec_spi.c              |    4 +-
 drivers/platform/olpc/olpc-xo175-ec.c              |    4 +-
 drivers/ptp/ptp_clock.c                            |   11 +-
 drivers/ptp/ptp_idt82p33.c                         |  344 +-
 drivers/ptp/ptp_idt82p33.h                         |  151 +-
 drivers/ptp/ptp_ocp.c                              | 1748 ++++-
 drivers/ptp/ptp_pch.c                              |  195 +-
 drivers/ptp/ptp_sysfs.c                            |    4 +-
 drivers/ptp/ptp_vclock.c                           |   56 +-
 drivers/rtc/rtc-ds1302.c                           |    3 +-
 drivers/rtc/rtc-ds1305.c                           |    4 +-
 drivers/rtc/rtc-ds1343.c                           |    4 +-
 drivers/s390/net/ctcm_fsms.c                       |    2 +-
 drivers/s390/net/ctcm_main.c                       |    2 +-
 drivers/s390/net/lcs.c                             |    8 +-
 drivers/s390/net/netiucv.c                         |    6 +-
 drivers/s390/net/qeth_core_main.c                  |    2 +-
 drivers/s390/net/qeth_l3_main.c                    |    1 -
 drivers/soc/fsl/dpio/qbman-portal.c                |    8 +-
 drivers/spi/spi-mem.c                              |    6 +-
 drivers/spi/spi-slave-system-control.c             |    3 +-
 drivers/spi/spi-slave-time.c                       |    3 +-
 drivers/spi/spi-tle62x0.c                          |    3 +-
 drivers/spi/spi.c                                  |   11 +-
 drivers/spi/spidev.c                               |    4 +-
 drivers/staging/fbtft/fbtft.h                      |   92 +-
 drivers/staging/gdm724x/gdm_lte.c                  |    2 +-
 drivers/staging/pi433/pi433_if.c                   |    4 +-
 drivers/staging/wfx/bus_spi.c                      |    3 +-
 drivers/staging/wlan-ng/p80211netdev.c             |    4 +-
 drivers/tty/serial/max3100.c                       |    5 +-
 drivers/tty/serial/max310x.c                       |    3 +-
 drivers/tty/serial/sc16is7xx.c                     |    4 +-
 drivers/usb/gadget/udc/max3420_udc.c               |    4 +-
 drivers/usb/host/max3421-hcd.c                     |    3 +-
 drivers/vhost/net.c                                |    1 +
 drivers/video/backlight/ams369fg06.c               |    3 +-
 drivers/video/backlight/corgi_lcd.c                |    3 +-
 drivers/video/backlight/ili922x.c                  |    3 +-
 drivers/video/backlight/l4f00242t03.c              |    3 +-
 drivers/video/backlight/lms501kf03.c               |    3 +-
 drivers/video/backlight/ltv350qv.c                 |    3 +-
 drivers/video/backlight/tdo24m.c                   |    3 +-
 drivers/video/backlight/tosa_lcd.c                 |    4 +-
 drivers/video/backlight/vgg2432a4.c                |    4 +-
 drivers/video/fbdev/omap/lcd_mipid.c               |    4 +-
 .../omapfb/displays/panel-lgphilips-lb035q02.c     |    4 +-
 .../omap2/omapfb/displays/panel-nec-nl8048hl11.c   |    4 +-
 .../omap2/omapfb/displays/panel-sony-acx565akm.c   |    4 +-
 .../omap2/omapfb/displays/panel-tpo-td028ttec1.c   |    4 +-
 .../omap2/omapfb/displays/panel-tpo-td043mtea1.c   |    4 +-
 include/linux/bpf-cgroup.h                         |   24 +-
 include/linux/bpf.h                                |  131 +-
 include/linux/bpf_local_storage.h                  |    7 +-
 include/linux/bpf_types.h                          |    1 +
 include/linux/bpf_verifier.h                       |   11 +
 include/linux/btf.h                                |   85 +-
 include/linux/btf_ids.h                            |   13 +-
 include/linux/can/bittiming.h                      |    6 +-
 include/linux/compiler-clang.h                     |   25 +
 include/linux/compiler-gcc.h                       |    3 +
 include/linux/compiler_types.h                     |   15 +-
 include/linux/dsa/8021q.h                          |   26 +-
 include/linux/dsa/tag_qca.h                        |   82 +
 include/linux/etherdevice.h                        |    5 +-
 include/linux/ethtool.h                            |    6 +
 include/linux/filter.h                             |   36 +-
 include/linux/fprobe.h                             |  105 +
 include/linux/ftrace.h                             |    3 +
 include/linux/ieee80211.h                          |  347 +-
 include/linux/if_bridge.h                          |   20 +
 include/linux/if_hsr.h                             |   16 +
 include/linux/if_macvlan.h                         |    1 +
 include/linux/inetdevice.h                         |    1 +
 include/linux/ipv6.h                               |    9 +-
 include/linux/kprobes.h                            |    3 +
 include/linux/linkmode.h                           |    5 -
 include/linux/mfd/idt82p33_reg.h                   |    3 +
 include/linux/mii.h                                |   50 -
 include/linux/mlx5/cq.h                            |    2 +
 include/linux/mlx5/driver.h                        |   61 +-
 include/linux/mlx5/fs.h                            |    1 +
 include/linux/mlx5/mlx5_ifc.h                      |   40 +-
 include/linux/mlx5/port.h                          |    2 -
 include/linux/mlx5/qp.h                            |    5 +
 include/linux/net/intel/i40e_client.h              |   10 -
 include/linux/net/intel/iidc.h                     |    4 +
 include/linux/netdevice.h                          |  175 +-
 include/linux/netfilter.h                          |    1 +
 include/linux/netfilter/nf_conntrack_pptp.h        |   38 +-
 include/linux/netlink.h                            |    9 -
 include/linux/pci_ids.h                            |    4 +
 include/linux/pcs/pcs-xpcs.h                       |    3 +-
 include/linux/phy.h                                |    3 +-
 include/linux/phylink.h                            |    4 -
 include/linux/ptp_classify.h                       |   15 +
 include/linux/ref_tracker.h                        |    4 +
 include/linux/rethook.h                            |  100 +
 include/linux/rtnetlink.h                          |    3 +
 include/linux/sched.h                              |    3 +
 include/linux/skbuff.h                             |  246 +-
 include/linux/skmsg.h                              |   29 +-
 include/linux/socket.h                             |    1 +
 include/linux/sort.h                               |    2 +-
 include/linux/spi/spi.h                            |    2 +-
 include/linux/ssb/ssb_driver_gige.h                |    2 +-
 include/linux/sunrpc/svc_xprt.h                    |    1 +
 include/linux/sunrpc/xprt.h                        |    1 +
 include/linux/tcp.h                                |    1 +
 include/linux/trace_events.h                       |    7 +
 include/linux/types.h                              |    1 +
 include/linux/udp.h                                |    5 -
 include/linux/uio.h                                |   17 +
 include/linux/wwan.h                               |    2 +
 include/net/addrconf.h                             |    2 +
 include/net/arp.h                                  |    1 +
 include/net/ax25.h                                 |   12 -
 include/net/bluetooth/bluetooth.h                  |   16 +-
 include/net/bluetooth/hci.h                        |   10 +
 include/net/bluetooth/hci_core.h                   |   17 +
 include/net/bluetooth/mgmt.h                       |   16 +
 include/net/bond_options.h                         |   31 +-
 include/net/bonding.h                              |   42 +-
 include/net/cfg80211.h                             |   97 +-
 include/net/cfg802154.h                            |   10 +
 include/net/checksum.h                             |    2 +
 include/net/devlink.h                              |   19 +-
 include/net/dsa.h                                  |  203 +-
 include/net/flow.h                                 |    6 +-
 include/net/flow_offload.h                         |   21 +
 include/net/gro.h                                  |   57 +-
 include/net/gtp.h                                  |   42 +
 include/net/ieee80211_radiotap.h                   |    4 +-
 include/net/if_inet6.h                             |    2 +
 include/net/inet_connection_sock.h                 |    8 +
 include/net/inet_dscp.h                            |   57 +
 include/net/inet_frag.h                            |    2 +
 include/net/inet_timewait_sock.h                   |    8 +-
 include/net/ip.h                                   |    3 +-
 include/net/ip6_fib.h                              |    3 +-
 include/net/ip_fib.h                               |    3 +-
 include/net/ipv6.h                                 |   21 +-
 include/net/ipv6_frag.h                            |    1 +
 include/net/mac80211.h                             |   37 +-
 include/net/mac802154.h                            |   12 +
 include/net/mctp.h                                 |   28 +-
 include/net/mptcp.h                                |    6 -
 include/net/ndisc.h                                |    5 +
 include/net/net_namespace.h                        |    8 +-
 include/net/netfilter/nf_conntrack_acct.h          |    1 -
 include/net/netfilter/nf_conntrack_bpf.h           |   23 +
 include/net/netfilter/nf_conntrack_ecache.h        |   15 +-
 include/net/netfilter/nf_conntrack_extend.h        |   18 +-
 include/net/netfilter/nf_conntrack_helper.h        |    1 +
 include/net/netfilter/nf_conntrack_labels.h        |    3 -
 include/net/netfilter/nf_conntrack_seqadj.h        |    3 -
 include/net/netfilter/nf_conntrack_timeout.h       |   20 +-
 include/net/netfilter/nf_conntrack_timestamp.h     |   13 -
 include/net/netfilter/nf_flow_table.h              |   18 +
 include/net/netfilter/nf_tables.h                  |   22 +
 include/net/netfilter/nf_tables_core.h             |    9 +
 include/net/netfilter/nft_fib.h                    |    3 +
 include/net/netfilter/nft_meta.h                   |    3 +
 include/net/netns/core.h                           |    1 +
 include/net/netns/ipv4.h                           |   14 +-
 include/net/netns/ipv6.h                           |    6 +-
 include/net/netns/smc.h                            |    6 +
 include/net/netns/xfrm.h                           |    6 +-
 include/net/page_pool.h                            |  133 +-
 include/net/pkt_cls.h                              |   11 +
 include/net/pkt_sched.h                            |    6 -
 include/net/request_sock.h                         |    2 +
 include/net/sch_generic.h                          |    5 -
 include/net/sock.h                                 |   28 +-
 include/net/switchdev.h                            |   72 +-
 include/net/tc_act/tc_police.h                     |   30 +
 include/net/tc_act/tc_vlan.h                       |   10 +
 include/net/tcp.h                                  |   24 +-
 include/net/tls.h                                  |    2 -
 include/net/udplite.h                              |   43 -
 include/net/vxlan.h                                |   54 +-
 include/net/xdp.h                                  |  122 +-
 include/net/xdp_sock_drv.h                         |    5 +-
 include/net/xfrm.h                                 |   48 +-
 include/net/xsk_buff_pool.h                        |    1 +
 include/soc/mscc/ocelot.h                          |  113 +-
 include/soc/mscc/ocelot_vcap.h                     |   18 +
 include/trace/events/mctp.h                        |    5 +-
 include/trace/events/mptcp.h                       |    4 +
 include/trace/events/net.h                         |   14 -
 include/trace/events/skb.h                         |   45 +
 include/uapi/asm-generic/socket.h                  |    2 +
 include/uapi/linux/bpf.h                           |  163 +-
 include/uapi/linux/can/isotp.h                     |   28 +-
 include/uapi/linux/ethtool_netlink.h               |    8 +
 include/uapi/linux/gtp.h                           |    1 +
 include/uapi/linux/if_addr.h                       |    9 +-
 include/uapi/linux/if_bridge.h                     |   18 +
 include/uapi/linux/if_ether.h                      |    2 +
 include/uapi/linux/if_link.h                       |   91 +
 include/uapi/linux/if_tunnel.h                     |    4 +-
 include/uapi/linux/ioam6_iptunnel.h                |    9 +
 include/uapi/linux/mctp.h                          |   18 +
 include/uapi/linux/mptcp.h                         |    1 +
 include/uapi/linux/mroute6.h                       |    1 +
 include/uapi/linux/net_dropmon.h                   |    1 +
 include/uapi/linux/netfilter/nfnetlink_queue.h     |    1 +
 include/uapi/linux/nl80211.h                       |   97 +-
 include/uapi/linux/openvswitch.h                   |   22 +-
 include/uapi/linux/pkt_cls.h                       |   15 +
 include/uapi/linux/rfkill.h                        |   14 +-
 include/uapi/linux/rtnetlink.h                     |   14 +
 include/uapi/linux/smc.h                           |   15 +
 include/uapi/linux/socket.h                        |    4 +
 init/Kconfig                                       |    4 +
 init/main.c                                        |    2 +
 kernel/bpf/Kconfig                                 |    5 +
 kernel/bpf/arraymap.c                              |    4 +-
 kernel/bpf/bpf_inode_storage.c                     |    9 +-
 kernel/bpf/bpf_iter.c                              |   20 +-
 kernel/bpf/bpf_local_storage.c                     |   60 +-
 kernel/bpf/bpf_lsm.c                               |   21 +
 kernel/bpf/bpf_task_storage.c                      |   10 +-
 kernel/bpf/btf.c                                   |  681 +-
 kernel/bpf/cgroup.c                                |  187 +-
 kernel/bpf/core.c                                  |  364 +-
 kernel/bpf/cpumap.c                                |    8 +-
 kernel/bpf/devmap.c                                |    3 +-
 kernel/bpf/hashtab.c                               |    2 +-
 kernel/bpf/helpers.c                               |   45 +-
 kernel/bpf/inode.c                                 |   39 +-
 kernel/bpf/local_storage.c                         |    2 +-
 kernel/bpf/preload/Kconfig                         |    7 +-
 kernel/bpf/preload/Makefile                        |   41 +-
 kernel/bpf/preload/bpf_preload.h                   |    8 +-
 kernel/bpf/preload/bpf_preload_kern.c              |  126 +-
 kernel/bpf/preload/bpf_preload_umd_blob.S          |    7 -
 kernel/bpf/preload/iterators/Makefile              |    6 +-
 kernel/bpf/preload/iterators/bpf_preload_common.h  |   13 -
 kernel/bpf/preload/iterators/iterators.c           |   94 -
 kernel/bpf/preload/iterators/iterators.lskel.h     |  425 ++
 kernel/bpf/preload/iterators/iterators.skel.h      |  412 --
 kernel/bpf/reuseport_array.c                       |    2 +-
 kernel/bpf/stackmap.c                              |   68 +-
 kernel/bpf/syscall.c                               |   97 +-
 kernel/bpf/trampoline.c                            |    8 +-
 kernel/bpf/verifier.c                              |  468 +-
 kernel/exit.c                                      |    2 +
 kernel/fork.c                                      |    3 +
 kernel/kallsyms.c                                  |    4 +
 kernel/trace/Kconfig                               |   26 +
 kernel/trace/Makefile                              |    2 +
 kernel/trace/bpf_trace.c                           |  353 +-
 kernel/trace/fprobe.c                              |  332 +
 kernel/trace/ftrace.c                              |   58 +-
 kernel/trace/rethook.c                             |  317 +
 lib/Kconfig.debug                                  |   34 +-
 lib/Makefile                                       |    2 +
 lib/ref_tracker.c                                  |   19 +-
 lib/sort.c                                         |   40 +-
 lib/test_fprobe.c                                  |  174 +
 net/6lowpan/core.c                                 |    1 +
 net/8021q/vlan_dev.c                               |    8 +-
 net/8021q/vlanproc.c                               |    2 +-
 net/Kconfig                                        |   13 +
 net/ax25/af_ax25.c                                 |   18 +-
 net/ax25/ax25_route.c                              |    5 +-
 net/ax25/ax25_subr.c                               |   20 +-
 net/batman-adv/bat_iv_ogm.c                        |    2 +-
 net/batman-adv/bat_v_elp.c                         |    2 +-
 net/batman-adv/bat_v_ogm.c                         |    2 +-
 net/batman-adv/bridge_loop_avoidance.c             |    3 +-
 net/batman-adv/distributed-arp-table.c             |    2 +-
 net/batman-adv/gateway_client.c                    |    1 +
 net/batman-adv/hard-interface.c                    |    6 +-
 net/batman-adv/main.c                              |    2 +-
 net/batman-adv/main.h                              |    2 +-
 net/batman-adv/multicast.c                         |    3 +-
 net/batman-adv/network-coding.c                    |    2 +-
 net/batman-adv/originator.c                        |    2 +-
 net/batman-adv/send.c                              |    2 +-
 net/batman-adv/soft-interface.c                    |    2 +-
 net/batman-adv/tp_meter.c                          |    2 +-
 net/batman-adv/translation-table.c                 |    2 +-
 net/batman-adv/tvlv.c                              |    2 +-
 net/bluetooth/6lowpan.c                            |    3 +-
 net/bluetooth/af_bluetooth.c                       |    4 +-
 net/bluetooth/bnep/core.c                          |    2 +-
 net/bluetooth/eir.h                                |   20 +
 net/bluetooth/hci_conn.c                           |    3 +
 net/bluetooth/hci_core.c                           |    5 +-
 net/bluetooth/hci_event.c                          |  111 +-
 net/bluetooth/hci_sync.c                           |   25 +-
 net/bluetooth/l2cap_core.c                         |    2 +-
 net/bluetooth/mgmt.c                               |  181 +-
 net/bluetooth/msft.c                               |  183 +-
 net/bpf/bpf_dummy_struct_ops.c                     |    6 +-
 net/bpf/test_run.c                                 |  629 +-
 net/bridge/Makefile                                |    2 +-
 net/bridge/br.c                                    |   20 +-
 net/bridge/br_arp_nd_proxy.c                       |    4 +-
 net/bridge/br_forward.c                            |    2 +-
 net/bridge/br_input.c                              |   28 +-
 net/bridge/br_mst.c                                |  357 ++
 net/bridge/br_netlink.c                            |   50 +-
 net/bridge/br_private.h                            |   67 +-
 net/bridge/br_stp.c                                |    6 +
 net/bridge/br_switchdev.c                          |  141 +-
 net/bridge/br_vlan.c                               |  137 +-
 net/bridge/br_vlan_options.c                       |   20 +
 net/bridge/netfilter/nf_conntrack_bridge.c         |    7 +-
 net/bridge/netfilter/nft_meta_bridge.c             |    5 +-
 net/bridge/netfilter/nft_reject_bridge.c           |    1 +
 net/caif/caif_dev.c                                |    2 +-
 net/caif/chnl_net.c                                |    2 +-
 net/can/af_can.c                                   |    2 +-
 net/can/gw.c                                       |   25 +-
 net/can/isotp.c                                    |  303 +-
 net/core/bpf_sk_storage.c                          |   23 +-
 net/core/dev.c                                     |  687 +-
 net/core/devlink.c                                 |  234 +-
 net/core/drop_monitor.c                            |  120 +-
 net/core/filter.c                                  |  450 +-
 net/core/flow_dissector.c                          |   18 +
 net/core/gro.c                                     |   16 +-
 net/core/gro_cells.c                               |   38 +-
 net/core/link_watch.c                              |    6 +-
 net/core/neighbour.c                               |    6 +-
 net/core/net_namespace.c                           |   20 +-
 net/core/page_pool.c                               |  102 +-
 net/core/ptp_classifier.c                          |   12 +
 net/core/rtnetlink.c                               |  541 +-
 net/core/skbuff.c                                  |   62 +-
 net/core/skmsg.c                                   |   17 +-
 net/core/sock.c                                    |   26 +-
 net/core/sock_map.c                                |   77 +-
 net/core/sysctl_net_core.c                         |   20 +-
 net/core/utils.c                                   |    4 +-
 net/core/xdp.c                                     |   79 +-
 net/dccp/dccp.h                                    |    5 -
 net/dccp/ipv4.c                                    |    6 -
 net/dccp/ipv6.c                                    |    6 -
 net/dccp/minisocks.c                               |    1 +
 net/decnet/dn_nsp_out.c                            |    3 +-
 net/dsa/dsa.c                                      |  100 +
 net/dsa/dsa2.c                                     |  147 +-
 net/dsa/dsa_priv.h                                 |  114 +-
 net/dsa/master.c                                   |    4 -
 net/dsa/port.c                                     |  509 +-
 net/dsa/slave.c                                    |  797 ++-
 net/dsa/switch.c                                   |  426 +-
 net/dsa/tag_8021q.c                                |  323 +-
 net/dsa/tag_dsa.c                                  |   19 +-
 net/dsa/tag_ocelot_8021q.c                         |   11 +-
 net/dsa/tag_qca.c                                  |   85 +-
 net/dsa/tag_rtl8_4.c                               |  152 +-
 net/dsa/tag_sja1105.c                              |   28 +-
 net/ethtool/netlink.h                              |    2 +-
 net/ethtool/rings.c                                |   30 +-
 net/hsr/hsr_debugfs.c                              |   40 +-
 net/hsr/hsr_device.c                               |   12 +-
 net/hsr/hsr_forward.c                              |    7 +-
 net/hsr/hsr_framereg.c                             |  209 +-
 net/hsr/hsr_framereg.h                             |   14 +-
 net/hsr/hsr_main.h                                 |   30 +-
 net/hsr/hsr_netlink.c                              |    4 +-
 net/ieee802154/6lowpan/core.c                      |    1 +
 net/ieee802154/6lowpan/reassembly.c                |    1 +
 net/ieee802154/nl-phy.c                            |    4 +-
 net/ipv4/arp.c                                     |   11 +-
 net/ipv4/bpf_tcp_ca.c                              |   28 +-
 net/ipv4/devinet.c                                 |    7 +
 net/ipv4/fib_frontend.c                            |   42 +-
 net/ipv4/fib_lookup.h                              |    3 +-
 net/ipv4/fib_rules.c                               |   19 +-
 net/ipv4/fib_semantics.c                           |   60 +-
 net/ipv4/fib_trie.c                                |   65 +-
 net/ipv4/icmp.c                                    |   91 +-
 net/ipv4/inet_connection_sock.c                    |    8 +-
 net/ipv4/inet_fragment.c                           |    1 +
 net/ipv4/inet_hashtables.c                         |   53 +-
 net/ipv4/inet_timewait_sock.c                      |   75 +-
 net/ipv4/ip_forward.c                              |    2 +-
 net/ipv4/ip_fragment.c                             |    1 +
 net/ipv4/ip_input.c                                |   32 +-
 net/ipv4/ip_options.c                              |   31 +-
 net/ipv4/ip_output.c                               |   20 +-
 net/ipv4/ipmr.c                                    |   20 +-
 net/ipv4/netfilter/nf_nat_h323.c                   |    8 +-
 net/ipv4/netfilter/nf_nat_pptp.c                   |   24 +-
 net/ipv4/netfilter/nft_dup_ipv4.c                  |    1 +
 net/ipv4/netfilter/nft_fib_ipv4.c                  |    2 +
 net/ipv4/netfilter/nft_reject_ipv4.c               |    1 +
 net/ipv4/nexthop.c                                 |   12 +-
 net/ipv4/proc.c                                    |    4 +-
 net/ipv4/route.c                                   |   61 +-
 net/ipv4/sysctl_net_ipv4.c                         |   27 +-
 net/ipv4/tcp.c                                     |   73 +-
 net/ipv4/tcp_bbr.c                                 |   18 +-
 net/ipv4/tcp_bpf.c                                 |   14 +-
 net/ipv4/tcp_cong.c                                |    2 -
 net/ipv4/tcp_cubic.c                               |   17 +-
 net/ipv4/tcp_dctcp.c                               |   18 +-
 net/ipv4/tcp_input.c                               |   53 +-
 net/ipv4/tcp_ipv4.c                                |  172 +-
 net/ipv4/tcp_minisocks.c                           |    7 +-
 net/ipv4/tcp_output.c                              |   58 +-
 net/ipv4/udp.c                                     |   22 +-
 net/ipv4/xfrm4_policy.c                            |    4 +-
 net/ipv6/addrconf.c                                |  234 +-
 net/ipv6/af_inet6.c                                |   24 +-
 net/ipv6/exthdrs.c                                 |    8 +-
 net/ipv6/fib6_rules.c                              |   30 +-
 net/ipv6/icmp.c                                    |   62 +-
 net/ipv6/inet6_hashtables.c                        |    5 +-
 net/ipv6/ioam6.c                                   |   19 +-
 net/ipv6/ioam6_iptunnel.c                          |   59 +-
 net/ipv6/ip6_input.c                               |    3 +-
 net/ipv6/ip6_offload.c                             |    5 +-
 net/ipv6/ip6_output.c                              |  116 +-
 net/ipv6/ip6_tunnel.c                              |    8 +
 net/ipv6/ip6mr.c                                   |   53 +-
 net/ipv6/ipv6_sockglue.c                           |    6 +-
 net/ipv6/ndisc.c                                   |   55 +-
 net/ipv6/netfilter.c                               |    5 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |    1 +
 net/ipv6/netfilter/nft_dup_ipv6.c                  |    1 +
 net/ipv6/netfilter/nft_fib_ipv6.c                  |    2 +
 net/ipv6/netfilter/nft_reject_ipv6.c               |    1 +
 net/ipv6/ping.c                                    |   29 +-
 net/ipv6/reassembly.c                              |    1 +
 net/ipv6/route.c                                   |   60 +-
 net/ipv6/tcp_ipv6.c                                |  104 +-
 net/ipv6/udp.c                                     |  114 +-
 net/ipv6/xfrm6_policy.c                            |    4 +-
 net/iucv/iucv.c                                    |    2 +-
 net/l3mdev/l3mdev.c                                |   43 +-
 net/llc/af_llc.c                                   |    8 +
 net/mac80211/Makefile                              |    3 +-
 net/mac80211/agg-rx.c                              |   20 +-
 net/mac80211/airtime.c                             |   15 +-
 net/mac80211/cfg.c                                 |  139 +-
 net/mac80211/chan.c                                |    5 +-
 net/mac80211/debugfs.c                             |    2 +
 net/mac80211/debugfs_key.c                         |    2 +-
 net/mac80211/debugfs_netdev.c                      |    4 +-
 net/mac80211/eht.c                                 |   76 +
 net/mac80211/ieee80211_i.h                         |   38 +-
 net/mac80211/main.c                                |   14 +-
 net/mac80211/mesh.c                                |    9 +-
 net/mac80211/mlme.c                                |  369 +-
 net/mac80211/rc80211_minstrel_ht.c                 |    2 +-
 net/mac80211/rx.c                                  |    2 +
 net/mac80211/sta_info.c                            |    3 +-
 net/mac80211/status.c                              |   14 +-
 net/mac80211/tx.c                                  |   24 +-
 net/mac80211/util.c                                |  299 +-
 net/mac80211/vht.c                                 |   38 +-
 net/mctp/af_mctp.c                                 |  189 +-
 net/mctp/device.c                                  |   34 +-
 net/mctp/neigh.c                                   |    2 +-
 net/mctp/route.c                                   |  149 +-
 net/mctp/test/route-test.c                         |  157 +-
 net/mctp/test/utils.c                              |    1 -
 net/mptcp/mib.c                                    |    4 +
 net/mptcp/mib.h                                    |    4 +
 net/mptcp/options.c                                |   82 +-
 net/mptcp/pm.c                                     |   11 +-
 net/mptcp/pm_netlink.c                             |  200 +-
 net/mptcp/protocol.c                               |    5 +
 net/mptcp/protocol.h                               |   32 +-
 net/mptcp/sockopt.c                                |    2 +
 net/mptcp/subflow.c                                |  112 +-
 net/netfilter/Makefile                             |    5 +
 net/netfilter/core.c                               |    3 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |    6 +-
 net/netfilter/nf_conntrack_acct.c                  |   19 -
 net/netfilter/nf_conntrack_bpf.c                   |  258 +
 net/netfilter/nf_conntrack_core.c                  |  187 +-
 net/netfilter/nf_conntrack_ecache.c                |   47 +-
 net/netfilter/nf_conntrack_extend.c                |  132 +-
 net/netfilter/nf_conntrack_helper.c                |   21 +-
 net/netfilter/nf_conntrack_labels.c                |   20 +-
 net/netfilter/nf_conntrack_netlink.c               |   36 +-
 net/netfilter/nf_conntrack_pptp.c                  |   60 +-
 net/netfilter/nf_conntrack_seqadj.c                |   16 -
 net/netfilter/nf_conntrack_timeout.c               |   50 +-
 net/netfilter/nf_conntrack_timestamp.c             |   20 -
 net/netfilter/nf_dup_netdev.c                      |    2 +-
 net/netfilter/nf_flow_table_core.c                 |   30 +-
 net/netfilter/nf_flow_table_inet.c                 |   17 +
 net/netfilter/nf_flow_table_ip.c                   |   84 +-
 net/netfilter/nf_flow_table_offload.c              |   33 +-
 net/netfilter/nf_nat_core.c                        |   28 +-
 net/netfilter/nf_synproxy_core.c                   |   24 +-
 net/netfilter/nf_tables_api.c                      |  112 +-
 net/netfilter/nf_tables_core.c                     |   18 +-
 net/netfilter/nfnetlink_cttimeout.c                |   11 +-
 net/netfilter/nfnetlink_log.c                      |    6 +-
 net/netfilter/nfnetlink_queue.c                    |   21 +-
 net/netfilter/nft_bitwise.c                        |   24 +-
 net/netfilter/nft_byteorder.c                      |    3 +-
 net/netfilter/nft_cmp.c                            |  105 +-
 net/netfilter/nft_compat.c                         |   10 +
 net/netfilter/nft_connlimit.c                      |    1 +
 net/netfilter/nft_counter.c                        |    1 +
 net/netfilter/nft_ct.c                             |   51 +
 net/netfilter/nft_dup_netdev.c                     |    1 +
 net/netfilter/nft_dynset.c                         |    1 +
 net/netfilter/nft_exthdr.c                         |  129 +-
 net/netfilter/nft_fib.c                            |   42 +
 net/netfilter/nft_fib_inet.c                       |    1 +
 net/netfilter/nft_fib_netdev.c                     |    1 +
 net/netfilter/nft_flow_offload.c                   |   14 +
 net/netfilter/nft_fwd_netdev.c                     |    4 +-
 net/netfilter/nft_hash.c                           |   36 +
 net/netfilter/nft_immediate.c                      |   12 +
 net/netfilter/nft_last.c                           |    1 +
 net/netfilter/nft_limit.c                          |    2 +
 net/netfilter/nft_log.c                            |    1 +
 net/netfilter/nft_lookup.c                         |   12 +
 net/netfilter/nft_masq.c                           |    3 +
 net/netfilter/nft_meta.c                           |   19 +-
 net/netfilter/nft_nat.c                            |    2 +
 net/netfilter/nft_numgen.c                         |   22 +
 net/netfilter/nft_objref.c                         |    2 +
 net/netfilter/nft_osf.c                            |   25 +
 net/netfilter/nft_payload.c                        |   12 +-
 net/netfilter/nft_queue.c                          |    2 +
 net/netfilter/nft_quota.c                          |    1 +
 net/netfilter/nft_range.c                          |    1 +
 net/netfilter/nft_redir.c                          |    3 +
 net/netfilter/nft_reject_inet.c                    |    1 +
 net/netfilter/nft_reject_netdev.c                  |    1 +
 net/netfilter/nft_rt.c                             |    1 +
 net/netfilter/nft_socket.c                         |   28 +
 net/netfilter/nft_synproxy.c                       |    1 +
 net/netfilter/nft_tproxy.c                         |    1 +
 net/netfilter/nft_tunnel.c                         |   28 +
 net/netfilter/nft_xfrm.c                           |   28 +
 net/netlabel/netlabel_kapi.c                       |    2 +
 net/netlink/af_netlink.c                           |    2 +
 net/nfc/llcp.h                                     |    1 -
 net/nfc/llcp_core.c                                |    9 +-
 net/nfc/llcp_sock.c                                |   49 +-
 net/openvswitch/conntrack.c                        |  118 +-
 net/openvswitch/datapath.c                         |   18 +-
 net/openvswitch/datapath.h                         |    2 -
 net/openvswitch/flow.c                             |  143 +-
 net/openvswitch/flow.h                             |   14 +
 net/openvswitch/flow_netlink.c                     |   37 +-
 net/openvswitch/vport.c                            |    2 +-
 net/packet/af_packet.c                             |    4 +-
 net/phonet/af_phonet.c                             |    8 +-
 net/rfkill/core.c                                  |   48 +-
 net/sched/act_api.c                                |    2 +
 net/sched/act_bpf.c                                |    2 +
 net/sched/act_ct.c                                 |  128 +-
 net/sched/act_police.c                             |   62 +-
 net/sched/act_vlan.c                               |   13 +
 net/sched/cls_api.c                                |   45 +-
 net/sched/cls_bpf.c                                |    2 +
 net/sched/cls_flower.c                             |  116 +
 net/smc/Makefile                                   |    1 +
 net/smc/af_smc.c                                   |  231 +-
 net/smc/smc.h                                      |   19 +-
 net/smc/smc_cdc.c                                  |   24 +-
 net/smc/smc_core.c                                 |    2 +-
 net/smc/smc_netlink.c                              |   15 +
 net/smc/smc_pnet.c                                 |    3 +
 net/smc/smc_sysctl.c                               |   65 +
 net/smc/smc_sysctl.h                               |   33 +
 net/smc/smc_tx.c                                   |  154 +-
 net/smc/smc_tx.h                                   |    3 +
 net/sunrpc/auth_gss/auth_gss.c                     |   10 +-
 net/sunrpc/svc_xprt.c                              |    4 +-
 net/sunrpc/xprt.c                                  |    4 +-
 net/switchdev/switchdev.c                          |  232 +-
 net/tipc/bearer.c                                  |    2 +-
 net/tipc/msg.h                                     |   23 -
 net/tipc/socket.c                                  |    3 +-
 net/tls/tls_device.c                               |   62 +-
 net/tls/tls_main.c                                 |   15 +-
 net/tls/tls_sw.c                                   |    3 +-
 net/unix/af_unix.c                                 |  272 +-
 net/wireless/chan.c                                |   91 +-
 net/wireless/nl80211.c                             |  137 +-
 net/wireless/pmsr.c                                |    4 -
 net/wireless/reg.c                                 |    6 +
 net/wireless/scan.c                                |    9 +-
 net/wireless/util.c                                |  141 +-
 net/xdp/xsk.c                                      |   82 +-
 net/xdp/xsk_buff_pool.c                            |    7 +
 net/xdp/xsk_queue.h                                |   19 +-
 net/xfrm/xfrm_device.c                             |   16 +-
 net/xfrm/xfrm_interface.c                          |    2 +-
 net/xfrm/xfrm_policy.c                             |   10 +-
 net/xfrm/xfrm_user.c                               |   43 +-
 samples/Kconfig                                    |    7 +
 samples/Makefile                                   |    1 +
 samples/bpf/map_perf_test_user.c                   |    2 +-
 samples/bpf/xdp1_user.c                            |   24 +-
 samples/bpf/xdp_adjust_tail_user.c                 |   25 +-
 samples/bpf/xdp_fwd_user.c                         |   19 +-
 samples/bpf/xdp_redirect_cpu.bpf.c                 |    8 +-
 samples/bpf/xdp_redirect_cpu_user.c                |    2 +-
 samples/bpf/xdp_redirect_map.bpf.c                 |    2 +-
 samples/bpf/xdp_redirect_map_multi.bpf.c           |    2 +-
 samples/bpf/xdp_router_ipv4_user.c                 |   27 +-
 samples/bpf/xdp_rxq_info_user.c                    |   34 +-
 samples/bpf/xdp_sample_pkts_user.c                 |    8 +-
 samples/bpf/xdp_sample_user.c                      |   11 +-
 samples/bpf/xdp_sample_user.h                      |    2 +-
 samples/bpf/xdp_tx_iptunnel_user.c                 |   27 +-
 samples/bpf/xdpsock_ctrl_proc.c                    |    2 +-
 samples/bpf/xdpsock_user.c                         |   16 +-
 samples/bpf/xsk_fwd.c                              |    4 +-
 samples/fprobe/Makefile                            |    3 +
 samples/fprobe/fprobe_example.c                    |  120 +
 scripts/bpf_doc.py                                 |  124 +-
 scripts/pahole-flags.sh                            |    5 +-
 scripts/pahole-version.sh                          |   13 +
 security/device_cgroup.c                           |    2 +-
 security/integrity/ima/ima_main.c                  |   57 +-
 security/selinux/nlmsgtab.c                        |    6 +-
 sound/pci/hda/cs35l41_hda_spi.c                    |    4 +-
 sound/soc/codecs/adau1761-spi.c                    |    3 +-
 sound/soc/codecs/adau1781-spi.c                    |    3 +-
 sound/soc/codecs/cs35l41-spi.c                     |    4 +-
 sound/soc/codecs/pcm3168a-spi.c                    |    4 +-
 sound/soc/codecs/pcm512x-spi.c                     |    3 +-
 sound/soc/codecs/tlv320aic32x4-spi.c               |    4 +-
 sound/soc/codecs/tlv320aic3x-spi.c                 |    4 +-
 sound/soc/codecs/wm0010.c                          |    4 +-
 sound/soc/codecs/wm8804-spi.c                      |    3 +-
 sound/spi/at73c213.c                               |    4 +-
 tools/bpf/bpftool/Documentation/bpftool-gen.rst    |  115 +
 tools/bpf/bpftool/Documentation/bpftool.rst        |   13 +-
 tools/bpf/bpftool/Documentation/common_options.rst |   13 +-
 tools/bpf/bpftool/Makefile                         |   34 +-
 tools/bpf/bpftool/bash-completion/bpftool          |   18 +-
 tools/bpf/bpftool/btf.c                            |    2 +-
 tools/bpf/bpftool/cgroup.c                         |    6 +-
 tools/bpf/bpftool/common.c                         |   46 +-
 tools/bpf/bpftool/feature.c                        |  141 +-
 tools/bpf/bpftool/gen.c                            | 1419 ++++-
 tools/bpf/bpftool/link.c                           |    3 +-
 tools/bpf/bpftool/main.c                           |   31 +-
 tools/bpf/bpftool/main.h                           |    8 +-
 tools/bpf/bpftool/map.c                            |   44 +-
 tools/bpf/bpftool/net.c                            |    2 +-
 tools/bpf/bpftool/pids.c                           |   11 +-
 tools/bpf/bpftool/prog.c                           |   52 +-
 tools/bpf/bpftool/skeleton/pid_iter.bpf.c          |   22 +
 tools/bpf/bpftool/skeleton/pid_iter.h              |    2 +
 tools/bpf/bpftool/struct_ops.c                     |    4 +-
 tools/bpf/bpftool/xlated_dumper.c                  |    5 +-
 tools/bpf/resolve_btfids/Makefile                  |    6 +-
 tools/include/uapi/linux/bpf.h                     |  155 +-
 tools/include/uapi/linux/if_link.h                 |    1 +
 tools/lib/bpf/Makefile                             |    4 +-
 tools/lib/bpf/bpf.c                                |   22 +-
 tools/lib/bpf/bpf.h                                |   20 +-
 tools/lib/bpf/bpf_helpers.h                        |    2 +-
 tools/lib/bpf/bpf_tracing.h                        |  103 +-
 tools/lib/bpf/btf.c                                |   31 +-
 tools/lib/bpf/btf.h                                |   34 +-
 tools/lib/bpf/btf_dump.c                           |   11 +-
 tools/lib/bpf/gen_loader.c                         |   15 +-
 tools/lib/bpf/hashmap.c                            |    3 +-
 tools/lib/bpf/libbpf.c                             |  934 ++-
 tools/lib/bpf/libbpf.h                             |  234 +-
 tools/lib/bpf/libbpf.map                           |   18 +-
 tools/lib/bpf/libbpf_internal.h                    |   17 +
 tools/lib/bpf/libbpf_legacy.h                      |   26 +
 tools/lib/bpf/libbpf_version.h                     |    2 +-
 tools/lib/bpf/netlink.c                            |  180 +-
 tools/lib/bpf/relo_core.c                          |   79 +-
 tools/lib/bpf/relo_core.h                          |   42 +-
 tools/lib/bpf/skel_internal.h                      |  253 +-
 tools/lib/bpf/xsk.c                                |   15 +-
 tools/perf/tests/llvm.c                            |    2 +-
 tools/perf/util/bpf-loader.c                       |   74 +-
 tools/perf/util/bpf_map.c                          |   28 +-
 tools/scripts/Makefile.include                     |    4 +
 tools/testing/selftests/bpf/.gitignore             |    2 +
 tools/testing/selftests/bpf/Makefile               |   29 +-
 tools/testing/selftests/bpf/README.rst             |   12 +-
 .../testing/selftests/bpf/benchs/bench_ringbufs.c  |    2 +-
 tools/testing/selftests/bpf/benchs/bench_trigger.c |    6 +-
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        |   60 +-
 tools/testing/selftests/bpf/cap_helpers.c          |   67 +
 tools/testing/selftests/bpf/cap_helpers.h          |   19 +
 tools/testing/selftests/bpf/config                 |    5 +
 tools/testing/selftests/bpf/ima_setup.sh           |   35 +-
 tools/testing/selftests/bpf/network_helpers.c      |   86 +
 tools/testing/selftests/bpf/network_helpers.h      |    9 +
 tools/testing/selftests/bpf/prog_tests/align.c     |  218 +-
 tools/testing/selftests/bpf/prog_tests/atomics.c   |  149 +-
 .../selftests/bpf/prog_tests/attach_probe.c        |   18 +-
 tools/testing/selftests/bpf/prog_tests/bind_perm.c |   64 +-
 .../testing/selftests/bpf/prog_tests/bpf_cookie.c  |  195 +-
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |   20 +
 .../bpf/prog_tests/bpf_iter_setsockopt_unix.c      |  100 +
 .../selftests/bpf/prog_tests/bpf_mod_race.c        |  230 +
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c    |   52 +
 tools/testing/selftests/bpf/prog_tests/btf.c       |   25 +-
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  |   54 +-
 tools/testing/selftests/bpf/prog_tests/btf_tag.c   |  207 +-
 .../bpf/prog_tests/cgroup_attach_autodetach.c      |    2 +-
 .../selftests/bpf/prog_tests/cgroup_attach_multi.c |   14 +-
 .../bpf/prog_tests/cgroup_attach_override.c        |    2 +-
 .../bpf/prog_tests/cgroup_getset_retval.c          |  481 ++
 tools/testing/selftests/bpf/prog_tests/check_mtu.c |   40 +-
 .../selftests/bpf/prog_tests/cls_redirect.c        |   10 +-
 tools/testing/selftests/bpf/prog_tests/core_kern.c |   16 +-
 .../selftests/bpf/prog_tests/core_kern_overflow.c  |   13 +
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |   63 +-
 .../selftests/bpf/prog_tests/custom_sec_handlers.c |  176 +
 .../selftests/bpf/prog_tests/dummy_st_ops.c        |   27 +-
 .../selftests/bpf/prog_tests/fentry_fexit.c        |   24 +-
 .../testing/selftests/bpf/prog_tests/fentry_test.c |    7 +-
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |   34 +-
 .../selftests/bpf/prog_tests/fexit_stress.c        |   22 +-
 .../testing/selftests/bpf/prog_tests/fexit_test.c  |    7 +-
 tools/testing/selftests/bpf/prog_tests/find_vma.c  |   30 +-
 .../selftests/bpf/prog_tests/flow_dissector.c      |   33 +-
 .../bpf/prog_tests/flow_dissector_load_bytes.c     |   24 +-
 tools/testing/selftests/bpf/prog_tests/for_each.c  |   32 +-
 .../selftests/bpf/prog_tests/get_func_args_test.c  |   12 +-
 .../selftests/bpf/prog_tests/get_func_ip_test.c    |   10 +-
 .../bpf/prog_tests/get_stackid_cannot_attach.c     |    2 +-
 .../testing/selftests/bpf/prog_tests/global_data.c |   32 +-
 .../selftests/bpf/prog_tests/global_data_init.c    |    2 +-
 .../selftests/bpf/prog_tests/global_func_args.c    |   14 +-
 tools/testing/selftests/bpf/prog_tests/kfree_skb.c |   16 +-
 .../testing/selftests/bpf/prog_tests/kfunc_call.c  |   46 +-
 .../selftests/bpf/prog_tests/kprobe_multi_test.c   |  323 +
 .../selftests/bpf/prog_tests/ksyms_module.c        |   27 +-
 tools/testing/selftests/bpf/prog_tests/l4lb_all.c  |   35 +-
 tools/testing/selftests/bpf/prog_tests/log_buf.c   |    6 +-
 tools/testing/selftests/bpf/prog_tests/map_lock.c  |   15 +-
 tools/testing/selftests/bpf/prog_tests/map_ptr.c   |   16 +-
 .../selftests/bpf/prog_tests/modify_return.c       |   33 +-
 tools/testing/selftests/bpf/prog_tests/obj_name.c  |    2 +-
 .../selftests/bpf/prog_tests/perf_branches.c       |    4 +-
 tools/testing/selftests/bpf/prog_tests/perf_link.c |    2 +-
 .../testing/selftests/bpf/prog_tests/pkt_access.c  |   26 +-
 .../selftests/bpf/prog_tests/pkt_md_access.c       |   14 +-
 .../selftests/bpf/prog_tests/prog_run_opts.c       |   77 +
 .../selftests/bpf/prog_tests/prog_run_xattr.c      |   83 -
 .../selftests/bpf/prog_tests/queue_stack_map.c     |   46 +-
 .../selftests/bpf/prog_tests/raw_tp_test_run.c     |   64 +-
 .../bpf/prog_tests/raw_tp_writable_test_run.c      |   16 +-
 .../testing/selftests/bpf/prog_tests/send_signal.c |   17 +-
 .../selftests/bpf/prog_tests/signal_pending.c      |   23 +-
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c   |   81 +-
 .../testing/selftests/bpf/prog_tests/skb_helpers.c |   16 +-
 .../testing/selftests/bpf/prog_tests/sock_fields.c |   58 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c       |   86 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c      |   12 +-
 .../testing/selftests/bpf/prog_tests/sockopt_sk.c  |    4 +-
 tools/testing/selftests/bpf/prog_tests/spinlock.c  |   14 +-
 .../bpf/prog_tests/stacktrace_build_id_nmi.c       |    2 +-
 .../selftests/bpf/prog_tests/stacktrace_map_skip.c |   63 +
 tools/testing/selftests/bpf/prog_tests/subprogs.c  |   77 +-
 .../testing/selftests/bpf/prog_tests/subskeleton.c |   78 +
 tools/testing/selftests/bpf/prog_tests/syscall.c   |   10 +-
 tools/testing/selftests/bpf/prog_tests/tailcalls.c |  274 +-
 .../selftests/bpf/prog_tests/task_pt_regs.c        |   16 +-
 .../testing/selftests/bpf/prog_tests/tc_redirect.c |  523 +-
 .../bpf/prog_tests/test_bpf_syscall_macro.c        |   73 +
 tools/testing/selftests/bpf/prog_tests/test_ima.c  |  149 +-
 .../selftests/bpf/prog_tests/test_profiler.c       |   14 +-
 .../selftests/bpf/prog_tests/test_skb_pkt_end.c    |   15 +-
 tools/testing/selftests/bpf/prog_tests/timer.c     |    7 +-
 tools/testing/selftests/bpf/prog_tests/timer_mim.c |    7 +-
 tools/testing/selftests/bpf/prog_tests/trace_ext.c |   28 +-
 tools/testing/selftests/bpf/prog_tests/xdp.c       |   34 +-
 .../selftests/bpf/prog_tests/xdp_adjust_frags.c    |  146 +
 .../selftests/bpf/prog_tests/xdp_adjust_tail.c     |  251 +-
 .../testing/selftests/bpf/prog_tests/xdp_attach.c  |   29 +-
 .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |  141 +-
 .../selftests/bpf/prog_tests/xdp_cpumap_attach.c   |   72 +-
 .../selftests/bpf/prog_tests/xdp_devmap_attach.c   |   63 +-
 .../selftests/bpf/prog_tests/xdp_do_redirect.c     |  201 +
 tools/testing/selftests/bpf/prog_tests/xdp_info.c  |   14 +-
 tools/testing/selftests/bpf/prog_tests/xdp_link.c  |   26 +-
 .../selftests/bpf/prog_tests/xdp_noinline.c        |   44 +-
 tools/testing/selftests/bpf/prog_tests/xdp_perf.c  |   19 +-
 tools/testing/selftests/bpf/progs/atomics.c        |   28 +-
 .../selftests/bpf/progs/bloom_filter_bench.c       |    7 +-
 .../testing/selftests/bpf/progs/bloom_filter_map.c |    5 +-
 .../selftests/bpf/progs/bpf_iter_setsockopt_unix.c |   60 +
 tools/testing/selftests/bpf/progs/bpf_iter_task.c  |   54 +
 tools/testing/selftests/bpf/progs/bpf_iter_unix.c  |    2 +-
 tools/testing/selftests/bpf/progs/bpf_loop.c       |    9 +-
 tools/testing/selftests/bpf/progs/bpf_loop_bench.c |    3 +-
 tools/testing/selftests/bpf/progs/bpf_misc.h       |   19 +
 tools/testing/selftests/bpf/progs/bpf_mod_race.c   |  100 +
 .../selftests/bpf/progs/bpf_syscall_macro.c        |   84 +
 .../testing/selftests/bpf/progs/bpf_tracing_net.h  |    2 +
 .../selftests/bpf/progs/btf_type_tag_percpu.c      |   66 +
 .../selftests/bpf/progs/btf_type_tag_user.c        |   40 +
 .../bpf/progs/cgroup_getset_retval_getsockopt.c    |   45 +
 .../bpf/progs/cgroup_getset_retval_setsockopt.c    |   52 +
 tools/testing/selftests/bpf/progs/core_kern.c      |   16 +
 .../selftests/bpf/progs/core_kern_overflow.c       |   22 +
 tools/testing/selftests/bpf/progs/fexit_sleep.c    |    9 +-
 .../selftests/bpf/progs/freplace_cls_redirect.c    |   12 +-
 tools/testing/selftests/bpf/progs/ima.c            |   66 +-
 .../testing/selftests/bpf/progs/kfunc_call_race.c  |   14 +
 .../testing/selftests/bpf/progs/kfunc_call_test.c  |   52 +-
 tools/testing/selftests/bpf/progs/kprobe_multi.c   |  100 +
 tools/testing/selftests/bpf/progs/ksym_race.c      |   13 +
 tools/testing/selftests/bpf/progs/local_storage.c  |   19 +
 tools/testing/selftests/bpf/progs/perfbuf_bench.c  |    3 +-
 tools/testing/selftests/bpf/progs/ringbuf_bench.c  |    3 +-
 .../testing/selftests/bpf/progs/sample_map_ret0.c  |   24 +-
 .../selftests/bpf/progs/sockmap_parse_prog.c       |    2 -
 tools/testing/selftests/bpf/progs/sockopt_sk.c     |   35 +-
 .../selftests/bpf/progs/stacktrace_map_skip.c      |   68 +
 tools/testing/selftests/bpf/progs/test_bpf_nf.c    |  118 +
 .../progs/{btf_decl_tag.c => test_btf_decl_tag.c}  |    0
 tools/testing/selftests/bpf/progs/test_btf_haskv.c |    3 +
 tools/testing/selftests/bpf/progs/test_btf_newkv.c |    3 +
 tools/testing/selftests/bpf/progs/test_btf_nokv.c  |   12 +-
 .../selftests/bpf/progs/test_custom_sec_handlers.c |   63 +
 .../testing/selftests/bpf/progs/test_probe_user.c  |   15 +-
 tools/testing/selftests/bpf/progs/test_ringbuf.c   |    3 +-
 .../selftests/bpf/progs/test_send_signal_kern.c    |    2 +-
 tools/testing/selftests/bpf/progs/test_sk_lookup.c |   15 +-
 .../selftests/bpf/progs/test_skb_cgroup_id_kern.c  |   12 +-
 .../testing/selftests/bpf/progs/test_sock_fields.c |   63 +-
 .../selftests/bpf/progs/test_sockmap_progs_query.c |   24 +
 .../testing/selftests/bpf/progs/test_subskeleton.c |   28 +
 .../selftests/bpf/progs/test_subskeleton_lib.c     |   61 +
 .../selftests/bpf/progs/test_subskeleton_lib2.c    |   16 +
 tools/testing/selftests/bpf/progs/test_tc_dtime.c  |  349 +
 tools/testing/selftests/bpf/progs/test_tc_edt.c    |   12 +-
 .../bpf/progs/test_tcp_check_syncookie_kern.c      |   12 +-
 .../bpf/progs/test_xdp_adjust_tail_grow.c          |   10 +-
 .../bpf/progs/test_xdp_adjust_tail_shrink.c        |   32 +-
 .../testing/selftests/bpf/progs/test_xdp_bpf2bpf.c |    2 +-
 .../selftests/bpf/progs/test_xdp_do_redirect.c     |  100 +
 .../selftests/bpf/progs/test_xdp_update_frags.c    |   42 +
 .../bpf/progs/test_xdp_with_cpumap_frags_helpers.c |   27 +
 .../bpf/progs/test_xdp_with_cpumap_helpers.c       |    8 +-
 .../bpf/progs/test_xdp_with_devmap_frags_helpers.c |   27 +
 .../bpf/progs/test_xdp_with_devmap_helpers.c       |    9 +-
 tools/testing/selftests/bpf/progs/trace_printk.c   |    3 +-
 tools/testing/selftests/bpf/progs/trace_vprintk.c  |    3 +-
 tools/testing/selftests/bpf/progs/trigger_bench.c  |    9 +-
 .../selftests/bpf/progs/xdp_redirect_multi_kern.c  |    2 +-
 tools/testing/selftests/bpf/test_cgroup_storage.c  |    2 +-
 tools/testing/selftests/bpf/test_cpp.cpp           |   90 +-
 tools/testing/selftests/bpf/test_lirc_mode2.sh     |    5 +-
 tools/testing/selftests/bpf/test_lru_map.c         |   15 +-
 tools/testing/selftests/bpf/test_lwt_ip_encap.sh   |   10 +-
 tools/testing/selftests/bpf/test_lwt_seg6local.sh  |  170 +-
 tools/testing/selftests/bpf/test_maps.c            |    2 +-
 tools/testing/selftests/bpf/test_sock_addr.c       |    6 +-
 tools/testing/selftests/bpf/test_sockmap.c         |    4 +-
 .../selftests/bpf/test_tcp_check_syncookie.sh      |    5 +-
 tools/testing/selftests/bpf/test_tunnel.sh         |    2 +-
 tools/testing/selftests/bpf/test_verifier.c        |  136 +-
 tools/testing/selftests/bpf/test_xdp_meta.sh       |   38 +-
 tools/testing/selftests/bpf/test_xdp_redirect.sh   |   30 +-
 .../selftests/bpf/test_xdp_redirect_multi.sh       |   60 +-
 tools/testing/selftests/bpf/test_xdp_veth.sh       |   39 +-
 tools/testing/selftests/bpf/test_xdp_vlan.sh       |   66 +-
 tools/testing/selftests/bpf/trace_helpers.c        |   77 +-
 tools/testing/selftests/bpf/trace_helpers.h        |    3 +-
 .../selftests/bpf/verifier/atomic_invalid.c        |    6 +-
 tools/testing/selftests/bpf/verifier/bounds.c      |    4 +-
 .../selftests/bpf/verifier/bounds_deduction.c      |    2 +-
 tools/testing/selftests/bpf/verifier/calls.c       |  183 +-
 tools/testing/selftests/bpf/verifier/ctx.c         |   12 +-
 .../selftests/bpf/verifier/direct_packet_access.c  |    2 +-
 .../selftests/bpf/verifier/helper_access_var_len.c |    6 +-
 tools/testing/selftests/bpf/verifier/jmp32.c       |   16 +-
 tools/testing/selftests/bpf/verifier/precise.c     |    4 +-
 tools/testing/selftests/bpf/verifier/raw_stack.c   |    4 +-
 .../testing/selftests/bpf/verifier/ref_tracking.c  |    6 +-
 .../selftests/bpf/verifier/search_pruning.c        |    2 +-
 tools/testing/selftests/bpf/verifier/sock.c        |   83 +-
 tools/testing/selftests/bpf/verifier/spill_fill.c  |   38 +-
 tools/testing/selftests/bpf/verifier/unpriv.c      |    4 +-
 .../selftests/bpf/verifier/value_illegal_alu.c     |    4 +-
 .../selftests/bpf/verifier/value_ptr_arith.c       |    4 +-
 tools/testing/selftests/bpf/verifier/var_off.c     |    2 +-
 tools/testing/selftests/bpf/vmtest.sh              |    2 +-
 tools/testing/selftests/bpf/xdp_redirect_multi.c   |    8 +-
 tools/testing/selftests/bpf/xdping.c               |    4 +-
 tools/testing/selftests/bpf/xdpxceiver.c           |   85 +-
 tools/testing/selftests/bpf/xdpxceiver.h           |    2 +-
 .../selftests/drivers/net/mlxsw/hw_stats_l3.sh     |   31 +
 .../selftests/drivers/net/netdevsim/hw_stats_l3.sh |  421 ++
 tools/testing/selftests/net/.gitignore             |    2 +-
 tools/testing/selftests/net/Makefile               |    3 +-
 .../testing/selftests/net/af_unix/test_unix_oob.c  |    6 +-
 tools/testing/selftests/net/cmsg_ipv6.sh           |  156 +
 tools/testing/selftests/net/cmsg_sender.c          |  506 ++
 tools/testing/selftests/net/cmsg_so_mark.c         |   67 -
 tools/testing/selftests/net/cmsg_so_mark.sh        |   32 +-
 tools/testing/selftests/net/cmsg_time.sh           |   83 +
 tools/testing/selftests/net/fcnal-test.sh          |    2 +-
 tools/testing/selftests/net/fib_rule_tests.sh      |   86 +-
 tools/testing/selftests/net/fib_tests.sh           |  147 +-
 tools/testing/selftests/net/forwarding/Makefile    |    1 +
 .../selftests/net/forwarding/bridge_locked_port.sh |  176 +
 .../selftests/net/forwarding/bridge_vlan_aware.sh  |    5 +-
 .../net/forwarding/bridge_vlan_unaware.sh          |    5 +-
 .../selftests/net/forwarding/fib_offload_lib.sh    |   12 +-
 .../net/forwarding/forwarding.config.sample        |    2 +
 .../selftests/net/forwarding/hw_stats_l3.sh        |  332 +
 tools/testing/selftests/net/forwarding/lib.sh      |   69 +
 tools/testing/selftests/net/forwarding/pedit_ip.sh |  201 +
 .../testing/selftests/net/forwarding/tc_police.sh  |   52 +
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |   19 +
 tools/testing/selftests/net/mptcp/mptcp_join.sh    | 2751 +++++---
 tools/testing/selftests/net/mptcp/pm_netlink.sh    |   18 +
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c      |   88 +-
 tools/testing/selftests/net/mptcp/settings         |    2 +-
 tools/testing/selftests/net/pmtu.sh                |  141 +-
 tools/testing/selftests/net/psock_fanout.c         |    5 +-
 tools/testing/selftests/net/reuseport_bpf_numa.c   |    2 +-
 tools/testing/selftests/net/rtnetlink.sh           |    4 +-
 .../selftests/net/test_vxlan_vnifiltering.sh       |  579 ++
 tools/testing/selftests/net/timestamping.c         |    4 +-
 tools/testing/selftests/net/toeplitz.c             |    6 +-
 tools/testing/selftests/net/txtimestamp.c          |    6 +-
 tools/testing/selftests/ptp/testptp.c              |   18 +-
 tools/testing/selftests/tc-testing/tdc_config.py   |    2 +-
 tools/testing/vsock/vsock_test.c                   |  215 +
 2212 files changed, 122793 insertions(+), 38761 deletions(-)
 create mode 100644 Documentation/bpf/bpf_prog_run.rst
 create mode 100644 Documentation/devicetree/bindings/net/can/xilinx,can.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/xilinx_can.txt
 create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
 create mode 100644 Documentation/devicetree/bindings/net/dsa/realtek.yaml
 create mode 100644 Documentation/devicetree/bindings/net/mctp-i2c-controller.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.txt
 create mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
 create mode 100644 Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
 create mode 100644 Documentation/devicetree/bindings/phy/transmit-amplitude.yaml
 create mode 100644 Documentation/networking/smc-sysctl.rst
 create mode 100644 Documentation/trace/fprobe.rst
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.c
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.h
 delete mode 100644 drivers/net/dsa/realtek-smi-core.c
 create mode 100644 drivers/net/dsa/realtek/Kconfig
 create mode 100644 drivers/net/dsa/realtek/Makefile
 create mode 100644 drivers/net/dsa/realtek/realtek-mdio.c
 create mode 100644 drivers/net/dsa/realtek/realtek-smi.c
 rename drivers/net/dsa/{realtek-smi-core.h => realtek/realtek.h} (51%)
 rename drivers/net/dsa/{ => realtek}/rtl8365mb.c (73%)
 rename drivers/net/dsa/{rtl8366.c => realtek/rtl8366-core.c} (61%)
 rename drivers/net/dsa/{ => realtek}/rtl8366rb.c (78%)
 create mode 100644 drivers/net/ethernet/davicom/dm9051.c
 create mode 100644 drivers/net/ethernet/davicom/dm9051.h
 create mode 100644 drivers/net/ethernet/fungible/Kconfig
 create mode 100644 drivers/net/ethernet/fungible/Makefile
 create mode 100644 drivers/net/ethernet/fungible/funcore/Makefile
 create mode 100644 drivers/net/ethernet/fungible/funcore/fun_dev.c
 create mode 100644 drivers/net/ethernet/fungible/funcore/fun_dev.h
 create mode 100644 drivers/net/ethernet/fungible/funcore/fun_hci.h
 create mode 100644 drivers/net/ethernet/fungible/funcore/fun_queue.c
 create mode 100644 drivers/net/ethernet/fungible/funcore/fun_queue.h
 create mode 100644 drivers/net/ethernet/fungible/funeth/Kconfig
 create mode 100644 drivers/net/ethernet/fungible/funeth/Makefile
 create mode 100644 drivers/net/ethernet/fungible/funeth/fun_port.h
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth.h
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_devlink.c
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_devlink.h
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_ethtool.c
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_ktls.c
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_ktls.h
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_main.c
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_rx.c
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_trace.h
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_tx.c
 create mode 100644 drivers/net/ethernet/fungible/funeth/funeth_txrx.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_gnss.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_gnss.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_pf_vsi_vlan_ops.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_pf_vsi_vlan_ops.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vf_lib.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vf_lib.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vf_lib_private.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vf_mbx.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vf_mbx.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vf_vsi_vlan_ops.h
 rename drivers/net/ethernet/intel/ice/{ice_virtchnl_pf.c => ice_virtchnl.c} (50%)
 create mode 100644 drivers/net/ethernet/intel/ice/ice_virtchnl.h
 delete mode 100644 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vlan.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vlan_mode.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vlan_mode.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vsi_vlan_lib.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_vsi_vlan_ops.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_dcbnl.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/selq.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/selq.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/sample.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_dmfs.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_smfs.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/smfs.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/smfs.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v1.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste_v2.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_pgid.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfd3/dp.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfd3/nfd3.h
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfd3/rings.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfd3/xsk.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfdk/dp.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfdk/nfdk.h
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfdk/rings.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfp_net_dp.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfp_net_dp.h
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfp_net_xsk.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfp_net_xsk.h
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfpcore/nfp_dev.h
 create mode 100644 drivers/net/mctp/mctp-i2c.c
 create mode 100644 drivers/net/netdevsim/hwstats.c
 create mode 100644 drivers/net/vxlan/Makefile
 rename drivers/net/{vxlan.c => vxlan/vxlan_core.c} (93%)
 create mode 100644 drivers/net/vxlan/vxlan_multicast.c
 create mode 100644 drivers/net/vxlan/vxlan_private.h
 create mode 100644 drivers/net/vxlan/vxlan_vnifilter.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/soc.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/usb.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/usb_mac.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852ae.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852c.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852c.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852ce.c
 create mode 100644 drivers/phy/freescale/phy-fsl-lynx-28g.c
 create mode 100644 include/linux/dsa/tag_qca.h
 create mode 100644 include/linux/fprobe.h
 create mode 100644 include/linux/rethook.h
 create mode 100644 include/net/inet_dscp.h
 create mode 100644 include/net/netfilter/nf_conntrack_bpf.h
 delete mode 100644 kernel/bpf/preload/bpf_preload_umd_blob.S
 delete mode 100644 kernel/bpf/preload/iterators/bpf_preload_common.h
 delete mode 100644 kernel/bpf/preload/iterators/iterators.c
 create mode 100644 kernel/bpf/preload/iterators/iterators.lskel.h
 delete mode 100644 kernel/bpf/preload/iterators/iterators.skel.h
 create mode 100644 kernel/trace/fprobe.c
 create mode 100644 kernel/trace/rethook.c
 create mode 100644 lib/test_fprobe.c
 create mode 100644 net/bridge/br_mst.c
 create mode 100644 net/mac80211/eht.c
 create mode 100644 net/netfilter/nf_conntrack_bpf.c
 create mode 100644 net/smc/smc_sysctl.c
 create mode 100644 net/smc/smc_sysctl.h
 create mode 100644 samples/fprobe/Makefile
 create mode 100644 samples/fprobe/fprobe_example.c
 create mode 100755 scripts/pahole-version.sh
 create mode 100644 tools/testing/selftests/bpf/cap_helpers.c
 create mode 100644 tools/testing/selftests/bpf/cap_helpers.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_iter_setsockopt_unix.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_mod_race.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_nf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_getset_retval.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/core_kern_overflow.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/custom_sec_handlers.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/prog_run_opts.c
 delete mode 100644 tools/testing/selftests/bpf/prog_tests/prog_run_xattr.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/stacktrace_map_skip.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/subskeleton.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_bpf_syscall_macro.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_adjust_frags.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_setsockopt_unix.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_misc.h
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_mod_race.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_syscall_macro.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_type_tag_percpu.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_type_tag_user.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_getset_retval_getsockopt.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_getset_retval_setsockopt.c
 create mode 100644 tools/testing/selftests/bpf/progs/core_kern_overflow.c
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_race.c
 create mode 100644 tools/testing/selftests/bpf/progs/kprobe_multi.c
 create mode 100644 tools/testing/selftests/bpf/progs/ksym_race.c
 create mode 100644 tools/testing/selftests/bpf/progs/stacktrace_map_skip.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_nf.c
 rename tools/testing/selftests/bpf/progs/{btf_decl_tag.c => test_btf_decl_tag.c} (100%)
 create mode 100644 tools/testing/selftests/bpf/progs/test_custom_sec_handlers.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_progs_query.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_subskeleton.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_subskeleton_lib.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_subskeleton_lib2.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_dtime.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_update_frags.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_cpumap_frags_helpers.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_with_devmap_frags_helpers.c
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/hw_stats_l3.sh
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/hw_stats_l3.sh
 create mode 100755 tools/testing/selftests/net/cmsg_ipv6.sh
 create mode 100644 tools/testing/selftests/net/cmsg_sender.c
 delete mode 100644 tools/testing/selftests/net/cmsg_so_mark.c
 create mode 100755 tools/testing/selftests/net/cmsg_time.sh
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_locked_port.sh
 create mode 100755 tools/testing/selftests/net/forwarding/hw_stats_l3.sh
 create mode 100755 tools/testing/selftests/net/forwarding/pedit_ip.sh
 create mode 100755 tools/testing/selftests/net/test_vxlan_vnifiltering.sh
