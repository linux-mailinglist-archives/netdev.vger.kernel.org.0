Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAB54426DB
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 06:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhKBFpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 01:45:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229659AbhKBFpm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 01:45:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DF8E60F4B;
        Tue,  2 Nov 2021 05:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635831788;
        bh=4/QyqaRgeqPBZUEf5dE8TkTHvuyKoIkkfUqqWaw06n4=;
        h=From:To:Cc:Subject:Date:From;
        b=Su6f82MRgtSs4IjVfcwShhJuuayGyf7EqQGIU4Hz9WPrx43SH27DSDzarRedtPDRv
         L0Q+v+jhPoHfM3ievGYWoCu40JTiCjQ1vOa092Hzt2vTB+QJNYRSZrbAhwqwDbjIBY
         h/VNI7Xs5vz+JEUyx1gb7SSi1SaJ8I2Acf1BV1K3pe7Vky63KG7n2H90aagggFenuv
         vAePal9PMXJ/3dyF/DFsx+DNLkTj/ycWsucXlK123LvbulQUGifjeeMSZlKj972MVe
         U4Qn7pPVJNU9z2i3SC9rr3QlEtzdlXN71uR2Oo7liLs9fgW2qmq4V6WDYWOZg1ViJ0
         EJaS0SPhIuphQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        kvalo@codeaurora.org, miriam.rachel.korenblit@intel.com
Subject: [GIT PULL] Networking for 5.16
Date:   Mon,  1 Nov 2021 22:42:36 -0700
Message-Id: <20211102054237.3307077-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

Networking changes for the 5.16 merge window.

We have a small conflict/adjacent change between our:

  dc52fac37c87 ("iwlwifi: mvm: Support new TX_RSP and COMPRESSED_BA_RES versions")

And Kees's:

  fa7845cfd53f ("treewide: Replace open-coded flex arrays in unions")

The resolution is rather trivial:

diff --cc drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
index 5fddfd391941,9b3bce83efb6..000000000000
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
@@@ -715,11 -720,10 +722,12 @@@ struct iwl_mvm_compressed_ba_notif 
  	__le32 tx_rate;
  	__le16 tfd_cnt;
  	__le16 ra_tid_cnt;
 -	struct iwl_mvm_compressed_ba_ratid ra_tid[0];
 -	struct iwl_mvm_compressed_ba_tfd tfd[];
 +	union {
 +		DECLARE_FLEX_ARRAY(struct iwl_mvm_compressed_ba_ratid, ra_tid);
 +		DECLARE_FLEX_ARRAY(struct iwl_mvm_compressed_ba_tfd, tfd);
 +	};
- } __packed; /* COMPRESSED_BA_RES_API_S_VER_4 */
+ } __packed; /* COMPRESSED_BA_RES_API_S_VER_4,
+ 	       COMPRESSED_BA_RES_API_S_VER_5 */
  
  /**
   * struct iwl_mac_beacon_cmd_v6 - beacon template command

----------------------------------------------------------------
The following changes since commit 411a44c24a561e449b592ff631b7ae321f1eb559:

  Merge tag 'net-5.15-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-10-28 10:17:31 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-for-5.16

for you to fetch changes up to 84882cf72cd774cf16fd338bdbf00f69ac9f9194:

  Revert "net: avoid double accounting for pure zerocopy skbs" (2021-11-01 22:26:08 -0700)

----------------------------------------------------------------
Core:

 - Remove socket skb caches

 - Add a SO_RESERVE_MEM socket op to forward allocate buffer space
   and avoid memory accounting overhead on each message sent

 - Introduce managed neighbor entries - added by control plane and
   resolved by the kernel for use in acceleration paths (BPF / XDP
   right now, HW offload users will benefit as well)

 - Make neighbor eviction on link down controllable by userspace
   to work around WiFi networks with bad roaming implementations

 - vrf: Rework interaction with netfilter/conntrack

 - fq_codel: implement L4S style ce_threshold_ect1 marking

 - sch: Eliminate unnecessary RCU waits in mini_qdisc_pair_swap()

BPF:

 - Add support for new btf kind BTF_KIND_TAG, arbitrary type tagging
   as implemented in LLVM14

 - Introduce bpf_get_branch_snapshot() to capture Last Branch Records

 - Implement variadic trace_printk helper

 - Add a new Bloomfilter map type

 - Track <8-byte scalar spill and refill

 - Access hw timestamp through BPF's __sk_buff

 - Disallow unprivileged BPF by default

 - Document BPF licensing

Netfilter:

 - Introduce egress hook for looking at raw outgoing packets

 - Allow matching on and modifying inner headers / payload data

 - Add NFT_META_IFTYPE to match on the interface type either from
   ingress or egress

Protocols:

 - Multi-Path TCP:
   - increase default max additional subflows to 2
   - rework forward memory allocation
   - add getsockopts: MPTCP_INFO, MPTCP_TCPINFO, MPTCP_SUBFLOW_ADDRS

 - MCTP flow support allowing lower layer drivers to configure msg
   muxing as needed

 - Automatic Multicast Tunneling (AMT) driver based on RFC7450

 - HSR support the redbox supervision frames (IEC-62439-3:2018)

 - Support for the ip6ip6 encapsulation of IOAM

 - Netlink interface for CAN-FD's Transmitter Delay Compensation

 - Support SMC-Rv2 eliminating the current same-subnet restriction,
   by exploiting the UDP encapsulation feature of RoCE adapters

 - TLS: add SM4 GCM/CCM crypto support

 - Bluetooth: initial support for link quality and audio/codec
   offload

Driver APIs:

 - Add a batched interface for RX buffer allocation in AF_XDP
   buffer pool

 - ethtool: Add ability to control transceiver modules' power mode

 - phy: Introduce supported interfaces bitmap to express MAC
   capabilities and simplify PHY code

 - Drop rtnl_lock from DSA .port_fdb_{add,del} callbacks

New drivers:

 - WiFi driver for Realtek 8852AE 802.11ax devices (rtw89)

 - Ethernet driver for ASIX AX88796C SPI device (x88796c)

Drivers:

 - Broadcom PHYs
   - support 72165, 7712 16nm PHYs
   - support IDDQ-SR for additional power savings

 - PHY support for QCA8081, QCA9561 PHYs

 - NXP DPAA2: support for IRQ coalescing

 - NXP Ethernet (enetc): support for software TCP segmentation

 - Renesas Ethernet (ravb) - support DMAC and EMAC blocks of
   Gigabit-capable IP found on RZ/G2L SoC

 - Intel 100G Ethernet
   - support for eswitch offload of TC/OvS flow API, including
     offload of GRE, VxLAN, Geneve tunneling
   - support application device queues - ability to assign Rx and Tx
     queues to application threads
   - PTP and PPS (pulse-per-second) extensions

 - Broadcom Ethernet (bnxt)
   - devlink health reporting and device reload extensions

 - Mellanox Ethernet (mlx5)
   - offload macvlan interfaces
   - support HW offload of TC rules involving OVS internal ports
   - support HW-GRO and header/data split
   - support application device queues

 - Marvell OcteonTx2:
   - add XDP support for PF
   - add PTP support for VF

 - Qualcomm Ethernet switch (qca8k): support for QCA8328

 - Realtek Ethernet DSA switch (rtl8366rb)
   - support bridge offload
   - support STP, fast aging, disabling address learning
   - support for Realtek RTL8365MB-VC, a 4+1 port 10M/100M/1GE switch

 - Mellanox Ethernet/IB switch (mlxsw)
   - multi-level qdisc hierarchy offload (e.g. RED, prio and shaping)
   - offload root TBF qdisc as port shaper
   - support multiple routing interface MAC address prefixes
   - support for IP-in-IP with IPv6 underlay

 - MediaTek WiFi (mt76)
   - mt7921 - ASPM, 6GHz, SDIO and testmode support
   - mt7915 - LED and TWT support

 - Qualcomm WiFi (ath11k)
   - include channel rx and tx time in survey dump statistics
   - support for 80P80 and 160 MHz bandwidths
   - support channel 2 in 6 GHz band
   - spectral scan support for QCN9074
   - support for rx decapsulation offload (data frames in 802.3
     format)

 - Qualcomm phone SoC WiFi (wcn36xx)
   - enable Idle Mode Power Save (IMPS) to reduce power consumption
     during idle

 - Bluetooth driver support for MediaTek MT7922 and MT7921

 - Enable support for AOSP Bluetooth extension in Qualcomm WCN399x
   and Realtek 8822C/8852A

 - Microsoft vNIC driver (mana)
   - support hibernation and kexec

 - Google vNIC driver (gve)
   - support for jumbo frames
   - implement Rx page reuse

Refactor:

 - Make all writes to netdev->dev_addr go thru helpers, so that we
   can add this address to the address rbtree and handle the updates

 - Various TCP cleanups and optimizations including improvements
   to CPU cache use

 - Simplify the gnet_stats, Qdisc stats' handling and remove
   qdisc->running sequence counter

 - Driver changes and API updates to address devlink locking
   deficiencies

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Aaron Ma (1):
      ath11k: qmi: avoid error messages when dma allocation fails

Abhiram R N (1):
      net/mlx5e: Add extack msgs related to TC for better debug

Abinaya Kalaiselvan (1):
      ath10k: fix module load regression with iram-recovery feature

Aharon Landau (8):
      net/mlx5: Add ifc bits to support optional counters
      net/mlx5: Add priorities for counters in RDMA namespaces
      RDMA/mlx5: Remove iova from struct mlx5_core_mkey
      RDMA/mlx5: Remove size from struct mlx5_core_mkey
      RDMA/mlx5: Remove pd from struct mlx5_core_mkey
      RDMA/mlx5: Replace struct mlx5_core_mkey by u32 key
      RDMA/mlx5: Move struct mlx5_core_mkey to mlx5_ib
      RDMA/mlx5: Attach ndescs to mlx5_ib_mkey

Ahmed S. Darwish (5):
      u64_stats: Introduce u64_stats_set()
      net: sched: Protect Qdisc::bstats with u64_stats
      net: sched: Use _bstats_update/set() instead of raw writes
      net: sched: Merge Qdisc::bstats and Qdisc::cpu_bstats data types
      net: sched: Remove Qdisc::running sequence counter

Ajay Singh (11):
      wilc1000: move 'deinit_lock' lock init/destroy inside module probe
      wilc1000: fix possible memory leak in cfg_scan_result()
      wilc1000: add new WID to pass wake_enable information to firmware
      wilc1000: configure registers to handle chip wakeup sequence
      wilc1000: add reset/terminate/repeat command support for SPI bus
      wilc1000: handle read failure issue for clockless registers
      wilc1000: ignore clockless registers status response for SPI
      wilc1000: invoke chip reset register before firmware download
      wilc1000: add 'initialized' flag check before adding an element to TX queue
      wilc1000: use correct write command sequence in wilc_spi_sync_ext()
      wilc1000: increase config packets response wait timeout limit

Alagu Sankar (1):
      ath10k: high latency fixes for beacon buffer

Aleksander Jan Bajkowski (11):
      MIPS: lantiq: dma: add small delay after reset
      MIPS: lantiq: dma: reset correct number of channel
      MIPS: lantiq: dma: fix burst length for DEU
      MIPS: lantiq: dma: make the burst length configurable by the drivers
      net: lantiq: configure the burst length in ethernet drivers
      dt-bindings: net: lantiq-xrx200-net: convert to the json-schema
      dt-bindings: net: lantiq,etop-xway: Document Lantiq Xway ETOP bindings
      dt-bindings: net: lantiq: Add the burst length properties
      net: lantiq: add support for jumbo frames
      net: lantiq_xrx200: Hardcode the burst length value
      dt-bindings: net: lantiq-xrx200-net: Remove the burst length properties

Alexander Kuznetsov (1):
      ipv6: enable net.ipv6.route.max_size sysctl in network namespace

Alexander Lobakin (1):
      ax88796c: fix fetching error stats from percpu containers

Alexei Starovoitov (25):
      Merge branch 'bpf: introduce bpf_get_branch_snapshot'
      Merge branch 'libbpf: Streamline internal BPF program sections handling'
      Merge branch 'bpf: add support for new btf kind BTF_KIND_TAG'
      Merge branch 'Improve set_attach_target() and deprecate open_opts.attach_prog_fd'
      Merge branch 'bpf: implement variadic printk helper'
      Merge branch 'libbpf: add legacy uprobe support'
      bpf: Document BPF licensing.
      Merge branch 'bpf: Support <8-byte scalar spill and refill'
      Merge branch 'libbpf: stricter BPF program section name handling'
      Merge branch 'bpf: Build with -Wcast-function-type'
      libbpf: Make gen_loader data aligned.
      Merge branch 'Support kernel module function calls from eBPF'
      Merge branch 'Add bpf_skc_to_unix_sock() helper'
      Merge branch 'libbpf: support custom .rodata.*/.data.* sections'
      Merge branch 'bpf: add support for BTF_KIND_DECL_TAG typedef'
      Merge branch 'Parallelize verif_scale selftests'
      Merge branch 'libbpf: add bpf_program__insns() accessor'
      Merge branch 'bpf: use 32bit safe version of u64_stats'
      Merge branch 'Implement bloom filter map'
      Merge branch 'Typeless/weak ksym for gen_loader + misc fixups'
      Merge branch 'introduce dummy BPF STRUCT_OPS'
      Merge branch '"map_extra" and bloom filter fixups'
      bpf: Fix propagation of bounds from 64-bit min/max into 32-bit and var_off.
      bpf: Fix propagation of signed bounds from 64-bit min/max into 32-bit.
      selftests/bpf: Add a testcase for 64-bit bounds propagation issue.

Aloka Dixit (1):
      mac80211: split beacon retrieval functions

Alvin Šipraga (7):
      ether: add EtherType for proprietary Realtek protocols
      net: dsa: allow reporting of standard ethtool stats for slave devices
      net: dsa: move NET_DSA_TAG_RTL4_A to right place in Kconfig/Makefile
      dt-bindings: net: dsa: realtek-smi: document new compatible rtl8365mb
      net: dsa: tag_rtl8_4: add realtek 8 byte protocol 4 tag
      net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC
      net: phy: realtek: add support for RTL8365MB-VC internal PHYs

Amir Tzin (3):
      net/mlx5: Add layout to support default timeouts register
      net/mlx5: Read timeout values from init segment
      net/mlx5: Read timeout values from DTOR

Amit Cohen (22):
      mlxsw: spectrum_router: Create common function for fib_entry_type_unset() code
      mlxsw: spectrum_ipip: Pass IP tunnel parameters by reference and as 'const'
      mlxsw: spectrum_router: Fix arguments alignment
      mlxsw: spectrum_ipip: Create common function for mlxsw_sp_ipip_ol_netdev_change_gre()
      mlxsw: Take tunnel's type into account when searching underlay device
      mlxsw: reg: Add Router IP version Six Register
      mlxsw: reg: Add support for rtdp_ipip6_pack()
      mlxsw: reg: Add support for ratr_ipip6_entry_pack()
      mlxsw: reg: Add support for ritr_loopback_ipip6_pack()
      mlxsw: Create separate ipip_ops_arr for different ASICs
      mlxsw: spectrum_ipip: Add mlxsw_sp_ipip_gre6_ops
      mlxsw: Add IPV6_ADDRESS kvdl entry type
      mlxsw: spectrum_router: Increase parsing depth for IPv6 decapsulation
      mlxsw: Add support for IP-in-IP with IPv6 underlay for Spectrum-2 and above
      testing: selftests: forwarding.config.sample: Add tc flag
      testing: selftests: tc_common: Add tc_check_at_least_x_packets()
      selftests: forwarding: Add IPv6 GRE flat tests
      selftests: forwarding: Add IPv6 GRE hierarchical tests
      selftests: mlxsw: devlink_trap_tunnel_ipip6: Add test case for IPv6 decap_error
      selftests: mlxsw: devlink_trap_tunnel_ipip: Align topology drawing correctly
      selftests: mlxsw: devlink_trap_tunnel_ipip: Remove code duplication
      selftests: mlxsw: devlink_trap_tunnel_ipip: Send a full-length key

Anders Roxell (1):
      marvell: octeontx2: build error: unknown type name 'u64'

Andrea Righi (1):
      selftests/bpf: Fix fclose/pclose mismatch in test_progs

Andreas Oetken (1):
      net: hsr: Add support for redbox supervision frames

Andrey Ignatov (1):
      bpf: Avoid retpoline for bpf_for_each_map_elem

Andrii Nakryiko (70):
      Merge branch 'Bpf skeleton helper method'
      libbpf: Fix build with latest gcc/binutils with LTO
      libbpf: Make libbpf_version.h non-auto-generated
      selftests/bpf: Update selftests to always provide "struct_ops" SEC
      libbpf: Ensure BPF prog types are set before relocations
      libbpf: Simplify BPF program auto-attach code
      libbpf: Minimize explicit iterator of section definition array
      selftests/bpf: Fix .gitignore to not ignore test_progs.c
      libbpf: Use pre-setup sec_def in libbpf_find_attach_btf_id()
      selftests/bpf: Stop using relaxed_core_relocs which has no effect
      libbpf: Deprecated bpf_object_open_opts.relaxed_core_relocs
      libbpf: Allow skipping attach_func_name in bpf_program__set_attach_target()
      selftests/bpf: Switch fexit_bpf2bpf selftest to set_attach_target() API
      libbpf: Schedule open_opts.attach_prog_fd deprecation since v0.7
      libbpf: Constify all high-level program attach APIs
      libbpf: Fix memory leak in legacy kprobe attach logic
      selftests/bpf: Adopt attach_probe selftest to work on old kernels
      libbpf: Refactor and simplify legacy kprobe code
      libbpf: Add legacy uprobe attaching support
      libbpf: Add "tc" SEC_DEF which is a better name for "classifier"
      selftests/bpf: Normalize XDP section names in selftests
      selftests/bpf: Switch SEC("classifier*") usage to a strict SEC("tc")
      selftests/bpf: Normalize all the rest SEC() uses
      libbpf: Refactor internal sec_def handling to enable pluggability
      libbpf: Reduce reliance of attach_fns on sec_def internals
      libbpf: Refactor ELF section handler definitions
      libbpf: Complete SEC() table unification for BPF_APROG_SEC/BPF_EAPROG_SEC
      libbpf: Add opt-in strict BPF program section name handling logic
      selftests/bpf: Switch sk_lookup selftests to strict SEC("sk_lookup") use
      Merge branch 'libbpf: Support uniform BTF-defined key/value specification across all BPF maps'
      libbpf: Add API that copies all BTF types from one BTF object to another
      selftests/bpf: Refactor btf_write selftest to reuse BTF generation logic
      selftests/bpf: Test new btf__add_btf() API
      Merge branch 'libbpf: Deprecate bpf_{map,program}__{prev,next} APIs since v0.7'
      Merge branch 'install libbpf headers when using the library'
      Merge branch 'add support for writable bare tracepoint'
      Merge branch 'selftests/bpf: Add parallelism to test_progs'
      Merge branch 'fixes for bpftool's Makefile'
      Merge branch 'btf_dump fixes for s390'
      Merge branch 'bpf: keep track of verifier insn_processed'
      Merge branch 'selftests/bpf: Fixes for perf_buffer test'
      libbpf: Deprecate btf__finalize_data() and move it into libbpf.c
      libbpf: Extract ELF processing state into separate struct
      libbpf: Use Elf64-specific types explicitly for dealing with ELF
      libbpf: Remove assumptions about uniqueness of .rodata/.data/.bss maps
      bpftool: Support multiple .rodata/.data internal maps in skeleton
      bpftool: Improve skeleton generation for data maps without DATASEC type
      libbpf: Support multiple .rodata.* and .data.* BPF maps
      selftests/bpf: Demonstrate use of custom .rodata/.data sections
      libbpf: Simplify look up by name of internal maps
      selftests/bpf: Switch to ".bss"/".rodata"/".data" lookups for internal maps
      libbpf: Fix the use of aligned attribute
      selftests/bpf: Make perf_buffer selftests work on 4.9 kernel again
      Merge branch 'libbpf: Add btf__type_cnt() and btf__raw_data() APIs'
      Merge branch 'libbpf: use func name when pinning programs with LIBBPF_STRICT_SEC_NAME'
      libbpf: Fix overflow in BTF sanity checks
      libbpf: Fix BTF header parsing checks
      selftests/bpf: Normalize selftest entry points
      selftests/bpf: Support multiple tests per file
      selftests/bpf: Mark tc_redirect selftest as serial
      selftests/bpf: Split out bpf_verif_scale selftests into multiple tests
      Merge branch 'bpftool: Switch to libbpf's hashmap for referencing BPF objects'
      libbpf: Fix off-by-one bug in bpf_core_apply_relo()
      libbpf: Add ability to fetch bpf_program's underlying instructions
      libbpf: Deprecate multi-instance bpf_program APIs
      libbpf: Deprecate ambiguously-named bpf_program__size() API
      Merge branch 'core_reloc fixes for s390'
      Merge branch 'selftests/bpf: parallel mode improvement'
      selftests/bpf: Fix strobemeta selftest regression
      selftests/bpf: Fix also no-alu32 strobemeta selftest

Anilkumar Kolli (5):
      ath11k: use hw_params to access board_size and cal_offset
      ath11k: clean up BDF download functions
      ath11k: add caldata file for multiple radios
      ath11k: add caldata download support from EEPROM
      ath11k: Fix pktlog lite rx events

Anirudh Venkataramanan (2):
      ice: Add feature bitmap, helpers and a check for DSCP
      ice: Fix link mode handling

Ansuel Smith (25):
      net: phy: at803x: add support for qca 8327 internal phy
      net: phy: at803x: add support for qca 8327 A variant internal phy
      net: phy: at803x: add resume/suspend function to qca83xx phy
      net: phy: at803x: fix spacing and improve name for 83xx phy
      net: phy: at803x: fix resume for QCA8327 phy
      net: phy: at803x: add DAC amplitude fix for 8327 phy
      net: phy: at803x: enable prefer master for 83xx internal phy
      net: phy: at803x: better describe debug regs
      dsa: qca8k: add mac_power_sel support
      dt-bindings: net: dsa: qca8k: Add SGMII clock phase properties
      net: dsa: qca8k: add support for sgmii falling edge
      dt-bindings: net: dsa: qca8k: Document support for CPU port 6
      net: dsa: qca8k: add support for cpu port 6
      net: dsa: qca8k: rework rgmii delay logic and scan for cpu port 6
      dt-bindings: net: dsa: qca8k: Document qca,sgmii-enable-pll
      net: dsa: qca8k: add explicit SGMII PLL enable
      dt-bindings: net: dsa: qca8k: Document qca,led-open-drain binding
      net: dsa: qca8k: add support for pws config reg
      dt-bindings: net: dsa: qca8k: document support for qca8328
      net: dsa: qca8k: add support for QCA8328
      net: dsa: qca8k: set internal delay also for sgmii
      net: dsa: qca8k: move port config to dedicated struct
      dt-bindings: net: ipq8064-mdio: fix warning with new qca8k switch
      net: dsa: qca8k: fix delay applied to wrong cpu in parse_port_config
      net: dsa: qca8k: tidy for loop in setup and add cpu port check

Antoine Tenart (5):
      net-sysfs: try not to restart the syscall if it will fail eventually
      net: introduce a function to check if a netdev name is in use
      bonding: use the correct function to check for netdev name collision
      ppp: use the correct function to check if a netdev name is in use
      net: make dev_get_port_parent_id slightly more readable

Ariel Levkovich (9):
      net/mlx5e: Refactor rx handler of represetor device
      net/mlx5e: Use generic name for the forwarding dev pointer
      net/mlx5: E-Switch, Add ovs internal port mapping to metadata support
      net/mlx5e: Accept action skbedit in the tc actions list
      net/mlx5e: Offload tc rules that redirect to ovs internal port
      net/mlx5e: Offload internal port as encap route device
      net/mlx5e: Add indirect tc offload of ovs internal port
      net/mlx5e: Term table handling of internal port rules
      net/mlx5: Support internal port as decap route device

Arnd Bergmann (11):
      net: stmmac: fix gcc-10 -Wrestrict warning
      cxgb: avoid open-coded offsetof()
      ath11k: Wstringop-overread warning
      am65-cpsw: avoid null pointer arithmetic
      net: stmmac: fix off-by-one error in sanity check
      gve: DQO: avoid unused variable warnings
      net: of: fix stub of_net helpers for CONFIG_NET=n
      octeontx2-nic: fix mixed module build
      ath10k: fix invalid dma_addr_t token assignment
      net: sched: gred: dynamically allocate tc_gred_qopt_offload
      ifb: fix building without CONFIG_NET_CLS_ACT

Avihai Horon (1):
      net/mlx5: Reduce flow counters bulk query buffer size for SFs

Avraham Stern (1):
      iwlwifi: mvm: add support for 160Mhz in ranging measurements

Aya Levin (5):
      net/mlx5e: Add error flow for ethtool -X command
      net/mlx5: Tolerate failures in debug features while driver load
      net/mlx5: Extend health buffer dump
      net/mlx5: Print health buffer by log level
      net/mlx5: Add periodic update of host time to firmware

Ayala Barazani (1):
      iwlwifi: ACPI: support revision 3 WGDS tables

Baochen Qiang (8):
      ath11k: Drop MSDU with length error in DP rx path
      ath11k: Fix inaccessible debug registers
      ath11k: Fix memory leak in ath11k_qmi_driver_event_work
      ath11k: Change DMA_FROM_DEVICE to DMA_TO_DEVICE when map reinjected packets
      ath11k: Handle MSI enablement during rmmod and SSR
      ath11k: Change number of TCL rings to one for QCA6390
      ath11k: Identify DFS channel when sending scan channel list command
      ath11k: change return buffer manager for QCA6390

Ben Ben-Ishay (5):
      net/mlx5e: Rename lro_timeout to packet_merge_timeout
      net/mlx5: Add SHAMPO caps, HW bits and enumerations
      net/mlx5e: Add support to klm_umr_wqe
      net/mlx5e: Add control path for SHAMPO feature
      net/mlx5e: Add data path for SHAMPO feature

Ben Ben-ishay (1):
      net: Prevent HW-GRO and LRO features operate together

Ben Greear (9):
      mt76: mt7915: fix he_mcs capabilities for 160mhz
      mt76: mt7915: fix potential NPE in TXS processing
      mt76: mt7915: fix hwmon temp sensor mem use-after-free
      mt76: mt7915: add ethtool stats support
      mt76: mt7915: add tx stats gathered from tx-status callbacks
      mt76: mt7915: add some per-station tx stats to ethtool
      mt76: mt7915: add tx mu/su counters to mib
      mt76: mt7915: add more MIB registers
      mt76: mt7915: add mib counters to ethtool stats

Benjamin Li (4):
      wcn36xx: handle connection loss indication
      wcn36xx: add proper DMA memory barriers in rx path
      wcn36xx: switch on antenna diversity feature bit
      wcn36xx: add missing 5GHz channels 136 and 144

Biju Das (24):
      ravb: Rename "ravb_set_features_rx_csum" function to "ravb_set_features_rcar"
      ravb: Rename "no_ptp_cfg_active" and "ptp_cfg_active" variables
      ravb: Add nc_queue to struct ravb_hw_info
      ravb: Add support for RZ/G2L SoC
      ravb: Initialize GbEthernet DMAC
      ravb: Exclude gPTP feature support for RZ/G2L
      ravb: Add tsrq to struct ravb_hw_info
      ravb: Add magic_pkt to struct ravb_hw_info
      ravb: Add half_duplex to struct ravb_hw_info
      ravb: Initialize GbEthernet E-MAC
      ravb: Use ALIGN macro for max_rx_len
      ravb: Add rx_max_buf_size to struct ravb_hw_info
      ravb: Fillup ravb_alloc_rx_desc_gbeth() stub
      ravb: Fillup ravb_rx_ring_free_gbeth() stub
      ravb: Fillup ravb_rx_ring_format_gbeth() stub
      ravb: Fillup ravb_rx_gbeth() stub
      ravb: Add carrier_counters to struct ravb_hw_info
      ravb: Add support to retrieve stats for GbEthernet
      ravb: Rename "tsrq" variable
      ravb: Optimize ravb_emac_init_gbeth function
      ravb: Rename "nc_queue" feature bit
      ravb: Document PFRI register bit
      ravb: Update ravb_emac_init_gbeth()
      ravb: Fix typo AVB->DMAC

Björn Töpel (4):
      riscv, bpf: Increase the maximum number of iterations
      tools, build: Add RISC-V to HOSTARCH parsing
      riscv, libbpf: Add RISC-V (RV64) support to bpf_tracing.h
      selftests, bpf: Fix broken riscv build

Bo Jiao (2):
      mt76: mt7915: fix calling mt76_wcid_alloc with incorrect parameter
      mt76: mt7915: adapt new firmware to update BA winsize for Rx session

Boris Sukholitko (1):
      dissector: do not set invalid PPP protocol

Brendan Jackman (1):
      selftests/bpf: Some more atomic tests

Brett Creeley (5):
      ice: Add support for VF rate limiting
      ice: Add support to print error on PHY FW load failure
      ice: Remove boolean vlan_promisc flag from function
      virtchnl: Remove unused VIRTCHNL_VF_OFFLOAD_RSVD define
      virtchnl: Use the BIT() macro for capability/offload flags

Brian Gix (1):
      Bluetooth: mgmt: Disallow legacy MGMT_OP_READ_LOCAL_OOB_EXT_DATA

Bryan O'Donoghue (6):
      wcn36xx: Fix Antenna Diversity Switching
      wcn36xx: Add ability for wcn36xx_smd_dump_cmd_req to pass two's complement
      wcn36xx: Implement Idle Mode Power Save
      wcn36xx: Treat repeated BMPS entry fail as connection loss
      Revert "wcn36xx: Disable bmps when encryption is disabled"
      Revert "wcn36xx: Enable firmware link monitoring"

Cai Huoqing (24):
      net: arc_emac: Make use of the helper function dev_err_probe()
      net: atl1c: Make use of the helper function dev_err_probe()
      net: atl1e: Make use of the helper function dev_err_probe()
      net: chelsio: cxgb4vf: Make use of the helper function dev_err_probe()
      net: enetc: Make use of the helper function dev_err_probe()
      net: ethoc: Make use of the helper function dev_err_probe()
      net: hinic: Make use of the helper function dev_err_probe()
      net: thunderx: Make use of the helper function dev_err_probe()
      net: netsec: Make use of the helper function dev_err_probe()
      net: stmmac: dwmac-visconti: Make use of the helper function dev_err_probe()
      FDDI: defxx: Fix function names in coments
      net: fddi: skfp: Fix a function name in comments
      net: atl1c: Fix a function name in print messages
      net: broadcom: Fix a function name in comments
      net: sis: Fix a function name in comments
      net: smsc: Fix function names in print messages and comments
      net: cisco: Fix a function name in comments
      ibmveth: Use dma_alloc_coherent() instead of kmalloc/dma_map_single()
      ipw2200: Fix a function name in print messages
      net: ethernet: ixp4xx: Make use of dma_pool_zalloc() instead of dma_pool_alloc/memset()
      ice: Make use of the helper function devm_add_action_or_reset()
      net: liquidio: Make use of the helper macro kthread_run()
      mt76: Make use of the helper macro kthread_run()
      can: mscan: mpc5xxx_can: Make use of the helper function dev_err_probe()

Carlos Llamas (1):
      ptp: fix code indentation issues

Catherine Sullivan (3):
      gve: Add rx buffer pagecnt bias
      gve: Add netif_set_xps_queue call
      gve: Track RX buffer allocation failures

Chen Wandun (1):
      net: delete redundant function declaration

Chethan T N (2):
      Bluetooth: btintel: support link statistics telemetry events
      Bluetooth: Allow usb to auto-suspend when SCO use non-HCI transport

Chin-Yen Lee (1):
      rtw88: move adaptivity mechanism to firmware

Chris Chiu (1):
      rtl8xxxu: Use lower tx rates for the ack packet

Chris Mi (1):
      net/mlx5e: Specify out ifindex when looking up encap route

Christian Lamparter (5):
      ath9k: fetch calibration data via nvmem subsystem
      ath9k: owl-loader: fetch pci init values through nvmem
      net: ethernet: emac: utilize of_net's of_get_mac_address()
      dt-bindings: net: wireless: qca,ath9k: convert to the json-schema
      ath9k: support DT ieee80211-freq-limit property to limit channels

Christophe JAILLET (6):
      s390/ism: switch from 'pci_' to 'dma_' API
      ethernet: Remove redundant 'flush_workqueue()' calls
      wireless: Remove redundant 'flush_workqueue()' calls
      ieee802154: Remove redundant 'flush_workqueue()' calls
      mt76: switch from 'pci_' to 'dma_' API
      mlxsw: spectrum: Use 'bitmap_zalloc()' when applicable

Claudiu Beznea (4):
      net: macb: add description for SRTSM
      net: macb: align for OSSMODE offset
      net: macb: add support for mii on rgmii
      net: macb: enable mii on rgmii for sama7g5

Colin Ian King (13):
      Bluetooth: btintel: Fix incorrect out of memory check
      octeontx2-af: Fix uninitialized variable val
      octeontx2-af: Remove redundant initialization of variable blkaddr
      octeontx2-af: Remove redundant initialization of variable pin
      qed: Fix spelling mistake "ctx_bsaed" -> "ctx_based"
      ath11k: Fix spelling mistake "incompaitiblity" -> "incompatibility"
      ath11k: Remove redundant assignment to variable fw_size
      rtlwifi: rtl8192ee: Remove redundant initialization of variable version
      mt7601u: Remove redundant initialization of variable ret
      xen-netback: Remove redundant initialization of variable err
      rtw89: Fix two spelling mistakes in debug messages
      rtw89: Remove redundant check of ret after call to rtw89_mac_enable_bb_rf
      net: ixgbevf: Remove redundant initialization of variable ret_val

DENG Qingfang (1):
      net: dsa: rtl8366rb: Support bridge offloading

Dan Carpenter (8):
      ath11k: fix some sleeping in atomic bugs
      mlxsw: spectrum_buffers: silence uninitialized warning
      b43legacy: fix a lower bounds test
      b43: fix a lower bounds test
      ath9k: fix an IS_ERR() vs NULL check
      net: enetc: fix check for allocation failure
      ice: fix an error code in ice_ena_vfs()
      mt76: mt7915: fix info leak in mt7915_mcu_set_pre_cal()

Dan Nowlin (2):
      ice: manage profiles and field vectors
      ice: create advanced switch recipe

Daniel Borkmann (11):
      Merge branch 'bpf-xsk-selftests'
      bpf, selftests: Replicate tailcall limit test for indirect call case
      Merge branch 'bpf-xsk-rx-batch'
      Merge branch 'bpf-mips-jit'
      bpf, arm: Remove dummy bpf_jit_compile stub
      net, neigh: Fix NTF_EXT_LEARNED in combination with NTF_USE
      net, neigh: Enable state migration between NUD_PERMANENT and NTF_USE
      net, neigh: Add NTF_MANAGED flag for managed neighbor entries
      net, neigh: Add build-time assertion to avoid neigh->flags overflow
      net, neigh: Use NLA_POLICY_MASK helper for NDA_FLAGS_EXT attribute
      net, neigh: Reject creating NUD_PERMANENT with NTF_MANAGED entries

Daniel Golle (2):
      mt76: support reading EEPROM data embedded in fdt
      dt: bindings: net: mt76: add eeprom-data property

Danielle Ratson (9):
      mlxsw: reg: Add MAC profile ID field to RITR register
      mlxsw: resources: Add resource identifier for RIF MAC profiles
      mlxsw: spectrum_router: Propagate extack further
      mlxsw: spectrum_router: Add RIF MAC profiles support
      mlxsw: spectrum_router: Expose RIF MAC profiles to devlink resource
      selftests: mlxsw: Add a scale test for RIF MAC profiles
      selftests: mlxsw: Add forwarding test for RIF MAC profiles
      selftests: Add an occupancy test for RIF MAC profiles
      selftests: mlxsw: Remove deprecated test cases

Dave Ertman (1):
      ice: Add DSCP support

Dave Marchevsky (13):
      bpf: Merge printk and seq_printf VARARG max macros
      selftests/bpf: Stop using bpf_program__load
      bpf: Add bpf_trace_vprintk helper
      libbpf: Modify bpf_printk to choose helper based on arg count
      libbpf: Use static const fmt string in __bpf_printk
      bpftool: Only probe trace_vprintk feature in 'full' mode
      selftests/bpf: Migrate prog_tests/trace_printk CHECKs to ASSERTs
      selftests/bpf: Add trace_vprintk test prog
      bpf: Clarify data_len param in bpf_snprintf and bpf_seq_printf comments
      selftests/bpf: Remove SEC("version") from test progs
      libbpf: Migrate internal use of bpf_program__get_prog_info_linear
      bpf: Add verified_insns to bpf_prog_info and fdinfo
      selftests/bpf: Add verif_stats test

David Awogbemila (2):
      gve: Add RX context.
      gve: Implement packet continuation for RX.

David Bauer (1):
      net: phy: at803x: add QCA9561 support

David S. Miller (128):
      Merge branch 'nfc-printk-cleanup'
      Merge branch 'mlxsw-next'
      Merge branch 's390-next'
      Merge branch 'smc-EDID-support'
      Merge branch 'hns3-mac'
      Merge branch 'ptp-ocp-timecard-v13-fw'
      Merge branch 'ibmvnic-next'
      Merge branch 'qdisc-visibility'
      Merge branch 'devlink-delete-publidh-api'
      Merge branch 'mlxsw-Add-support-for-transceiver-modules-reset'
      Merge branch 'macb-MII-on-RGMII'
      Merge branch 'mptcp-next'
      Merge branch 'wwan-iosm-fw-flashing'
      Merge branch 'iddq-sr-mode'
      Merge branch 'mlxsw-trap-adjacency'
      Merge branch 'ja1105-deps'
      Merge branch 'remove-sk-skb-caches'
      Merge branch 'mlxsw-next'
      Merge branch 'devlink-fixes'
      Merge tag 'mlx5-updates-2021-09-24' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'mptcp-fixes'
      Merge branch 'octeontx2-af-kpu'
      Merge branch 'devlink_register-last'
      Merge branch 'rtl8366-cleanups'
      Merge branch 'bcmgenet-flow-control'
      Merge branch 'octeontx2-af-external-ptp-clock'
      Merge branch 'octeontx2-ptp-vf'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/nex t-queue
      Merge branch 'mctp-core-updates'
      Merge branch 'SO_RESEVED_MEM'
      Merge branch 'snmp-optimizations'
      Merge tag 'mlx5-fixes-2021-09-30' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'mctp-kunit-tests'
      sparc: add SO_RESERVE_MEM definition.
      Revert "Merge branch 'mctp-kunit-tests'"
      Merge branch 'ravb-gigabit'
      Merge branch 'ionic-cleanups'
      Merge branch 'ocelot-vlan'
      Merge branch 'hw_addr_set'
      Merge branch 'mctp-kunit-tests'
      Merge branch 'ipv6-ioam-encap'
      Merge branch 'qed-new-fw'
      Merge branch 'phy-10g-mode-helper'
      sparc: Fix typo.
      Merge tag 'mlx5-updates-2021-10-04' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'mlx4-const-dev_addr'
      Merge branch 'RTL8366RB-enhancements'
      Merge branch 'nfc-pn533-const'
      Merge branch 'dev_addr-fw-helpers'
      Merge tag 'wireless-drivers-next-2021-10-07' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'dev_addr-helpers'
      Merge branch 'ip6gre-tests'
      Merge branch 'enetc-swtso'
      Merge branch 'netdev-name-in-use'
      Merge branch 'dev_addr-direct-writes'
      Merge branch 'ionic-vlanid-mgmt'
      Merge branch 'net-use-helpers'
      Merge branch 'gve-improvements'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/nex t-queue
      Merge branch 'mlxsw-ECN-mirroring'
      Merge branch 'Managed-Neighbor-Entries'
      Merge branch 'qca8337-improvements'
      Merge branch 'L4S-style-ce_threshold_ect1-marking'
      Merge branch 'dpaa2-irq-coalescing'
      Merge branch 'mptcp-fixes'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge tag 'mlx5-updates-2021-10-15' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'dev_addr-conversions-part-1'
      Merge branch 'smc-rv23'
      Merge branch 'remove-qdisc-running-counter'
      Merge branch 'uniphier-nx1'
      Merge branch 'rtl8365mb-vc-support'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge tag 'mlx5-updates-2021-10-18' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'mlxsw-multi-level-qdisc-offload'
      Merge branch 'dev_addr-conversions-part-two'
      Merge branch 'eth_hw_addr_gen-for-switches'
      Merge branch 'sja1105-next'
      Merge branch 'dev_addr-conversions-part-three'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'mscc-ocelot-all-ports-vlan-untagged-egress'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'dsa_to_port-loops'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      ice:  Nuild fix.
      Merge branch 'dsa-rtnl'
      Merge branch 'dev_addr-dont-write'
      Merge tag 'linux-can-next-for-5.16-20211024' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Revert "Merge branch 'dsa-rtnl'"
      Merge branch 'dsa-rtnl'
      Merge branch 's390-qeth-next'
      Merge branch 'hns3-next'
      Merge branch 'qca8081-phy-driver'
      Merge branch 'mlxsw-selftests-updates'
      Merge branch 'gve-jumbo-frame'
      Merge tag 'wireless-drivers-next-2021-10-25' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next
      Merge tag 'mlx5-updates-2021-10-25' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'netfilter-vrf-rework'
      Merge branch 'mlxsw-rif-mac-prefixes'
      Merge branch 'tcp_stream_alloc_skb'
      Merge branch 'dsa-isolation-prep'
      Merge branch 'phy-supported-interfaces-bitmap'
      Merge tag 'mlx5-updates-2021-10-26' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'mvneta-phylink'
      Merge branch 'br-fdb-refactoring'
      Merge branch 'tcp-tx-side-cleanups'
      Merge branch 'mvpp2-phylink'
      Merge tag 'mlx5-net-next-5.15-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'octeontx2-debugfs-updates'
      Merge branch 'bnxt_en-devlink'
      Merge branch 'sctp-plpmtud-fixes'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'eth_hw_addr_set'
      Merge branch 'MCTP-flow-support'
      Merge branch 'nfp-fixes'
      Merge tag 'mlx5-updates-2021-10-29' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'SO_MARK-routing'
      Merge branch 'mptcp-selftests'
      Merge branch 'mana-misc'
      Merge branch 'devlink-locking'
      Merge branch 'netdevsim-device-and-bus'
      Merge branch 'amt-driver'
      Merge branch 'SMC-tracepoints'

David Yang (1):
      samples/bpf: Fix application of sizeof to pointer

Davide Caratti (1):
      net/sched: sch_ets: properly init all active DRR list handles

Deren Wu (4):
      mt76: mt7921: Fix out of order process by invalid event pkt
      mt76: mt7921: Add mt7922 support
      mt76: mt7921: fix dma hang in rmmod
      mt76: mt7921: add delay config for sched scan

Desmond Cheong Zhi Xi (2):
      Bluetooth: call sock_hold earlier in sco_conn_del
      Bluetooth: fix init and cleanup of sco_conn.timeout_work

Dexuan Cui (4):
      net: mana: Fix the netdev_err()'s vPort argument in mana_init_port()
      net: mana: Report OS info to the PF driver
      net: mana: Improve the HWC error handling
      net: mana: Support hibernation and kexec

Dima Chumak (2):
      net/mlx5e: Enable TC offload for egress MACVLAN
      net/mlx5e: Enable TC offload for ingress MACVLAN

Dinghao Liu (1):
      Bluetooth: btmtkuart: fix a memleak in mtk_hci_wmt_sync

Dongliang Mu (1):
      can: xilinx_can: xcan_remove(): remove redundant netif_napi_del()

Doug Berger (4):
      net: bcmgenet: remove netif_carrier_off from adjust_link
      net: bcmgenet: remove old link state values
      net: bcmgenet: pull mac_config from adjust_link
      net: bcmgenet: add support for ethtool flow control

Dust Li (1):
      ipvs: add sysctl_run_estimation to support disable estimation

Edwin Peer (14):
      bnxt_en: refactor printing of device info
      bnxt_en: refactor cancellation of resource reservations
      bnxt_en: implement devlink dev reload driver_reinit
      bnxt_en: implement devlink dev reload fw_activate
      bnxt_en: add enable_remote_dev_reset devlink parameter
      bnxt_en: improve error recovery information messages
      bnxt_en: remove fw_reset devlink health reporter
      bnxt_en: consolidate fw devlink health reporters
      bnxt_en: improve fw diagnose devlink health messages
      bnxt_en: Refactor coredump functions
      bnxt_en: move coredump functions into dedicated file
      bnxt_en: extract coredump command line from current task
      bnxt_en: implement dump callback for fw health reporter
      bnxt_en: implement firmware live patching

Emmanuel Grumbach (2):
      nl80211: vendor-cmd: intel: add more details for IWL_MVM_VENDOR_CMD_HOST_GET_OWNERSHIP
      iwlwifi: mvm: fix some kerneldoc issues

Eric Dumazet (36):
      tcp: remove sk_{tr}x_skb_cache
      net: snmp: inline snmp_get_cpu_field()
      mptcp: use batch snmp operations in mptcp_seq_show()
      net/mlx4_en: avoid one cache line miss to ring doorbell
      tcp: switch orphan_count to bare per-cpu counters
      net: add skb_get_dsfield() helper
      fq_codel: implement L4S style ce_threshold_ect1 marking
      net: sched: fix logic error in qdisc_run_begin()
      net: sched: remove one pair of atomic operations
      tcp: move inet->rx_dst_ifindex to sk->sk_rx_dst_ifindex
      ipv6: move inet6_sk(sk)->rx_dst_cookie to sk->sk_rx_dst_cookie
      net: avoid dirtying sk->sk_napi_id
      net: avoid dirtying sk->sk_rx_queue_mapping
      net: annotate accesses to sk->sk_rx_queue_mapping
      ipv6: annotate data races around np->min_hopcount
      ipv6: guard IPV6_MINHOPCOUNT with a static key
      ipv4: annotate data races arount inet->min_ttl
      ipv4: guard IP_MINTTL with a static key
      ipv6/tcp: small drop monitor changes
      net: annotate data-race in neigh_output()
      tcp: rename sk_stream_alloc_skb
      tcp: use MAX_TCP_HEADER in tcp_stream_alloc_skb
      tcp: remove unneeded code from tcp_stream_alloc_skb()
      bpf: Avoid races in __bpf_prog_run() for 32bit arches
      bpf: Fixes possible race in update_prog_stats() for 32bit arches
      bpf: Use u64_stats_t in struct bpf_prog_stats
      inet: remove races in inet{6}_getname()
      tcp: remove dead code from tcp_sendmsg_locked()
      tcp: cleanup tcp_remove_empty_skb() use
      tcp: remove dead code from tcp_collapse_retrans()
      tcp: no longer set skb->reserved_tailroom
      tcp: factorize ip_summed setting
      tcp: do not clear skb->csum if already zero
      tcp: do not clear TCP_SKB_CB(skb)->sacked if already zero
      net: cleanup __sk_stream_memory_free()
      bpf: Add missing map_delete_elem method to bloom filter map

Erik Ekman (1):
      sfc: Fix reading non-legacy supported link modes

Fabio Estevam (1):
      ath10k: sdio: Add missing BH locking around napi_schdule()

Felix Fietkau (5):
      mt76: mt7615: fix skb use-after-free on mac reset
      mt76: mt7915: fix WMM index on DBDC cards
      mt76: disable BH around napi_schedule() calls
      mt76: do not access 802.11 header in ccmp check for 802.3 rx skbs
      mt76: connac: fix unresolved symbols when CONFIG_PM is unset

Florian Fainelli (12):
      net: phy: broadcom: Enable 10BaseT DAC early wake
      net: phy: bcm7xxx: Add EPHY entry for 72165
      net: bcmgenet: Patch PHY interface for dedicated PHY driver
      net: phy: broadcom: Add IDDQ-SR mode
      net: phy: broadcom: Wire suspend/resume for BCM50610 and BCM50610M
      net: phy: broadcom: Utilize appropriate suspend for BCM54810/11
      net: bcmgenet: Request APD, DLL disable and IDDQ-SR
      net: dsa: bcm_sf2: Request APD, DLL disable and IDDQ-SR
      net: phy: broadcom: Fix PHY_BRCM_IDDQ_SUSPEND definition
      net: phy: bcm7xxx: Add EPHY entry for 7712
      dt-bindings: net: bcmgenet: Document 7712 binding
      net: bcmgenet: Add support for 7712 16nm internal EPHY

Florian Westphal (19):
      mptcp: add new mptcp_fill_diag helper
      mptcp: add MPTCP_INFO getsockopt
      mptcp: add MPTCP_TCPINFO getsockopt support
      mptcp: add MPTCP_SUBFLOW_ADDRS getsockopt support
      selftests: mptcp: add mptcp getsockopt test cases
      mptcp: do not shrink snd_nxt when recovering
      mptcp: remove tx_pending_data
      mptcp: re-arm retransmit timer if data is pending
      netlink: remove netlink_broadcast_filtered
      netfilter: iptables: allow use of ipt_do_table as hookfn
      netfilter: arp_tables: allow use of arpt_do_table as hookfn
      netfilter: ip6tables: allow use of ip6t_do_table as hookfn
      netfilter: ebtables: allow use of ebt_do_table as hookfn
      netfilter: ipvs: prepare for hook function reduction
      netfilter: ipvs: remove unneeded output wrappers
      netfilter: ipvs: remove unneeded input wrappers
      netfilter: ipvs: merge ipv4 + ipv6 icmp reply handlers
      netfilter: conntrack: skip confirmation and nat hooks in postrouting for vrf
      vrf: run conntrack only in context of lower/physdev for locally generated packets

Francesco Dolcini (1):
      net: phy: micrel: ksz9131 led errata workaround

Geert Uytterhoeven (4):
      dt-bindings: net: renesas,ether: Update example to match reality
      dt-bindings: net: renesas,etheravb: Update example to match reality
      can: rcar: drop unneeded ARM dependency
      wlcore: spi: Use dev_err_probe()

Geetha sowjanya (2):
      octeontx2-pf: Use hardware register for CQE count
      octeontx2-pf: Add XDP support to netdev PF

Geliang Tang (3):
      mptcp: use OPTIONS_MPTCP_MPC
      mptcp: drop unused sk in mptcp_push_release
      selftests: mptcp: fix proto type in link_failure tests

Gokul Sivakumar (2):
      samples: bpf: Convert route table network order fields into readable format
      samples: bpf: Convert ARP table network order fields into readable format

Grant Seltzer (3):
      libbpf: Add sphinx code documentation comments
      libbpf: Add doc comments in libbpf.h
      libbpf: Add API documentation convention guidelines

Gregory Greenman (2):
      iwlwifi: mvm: improve log when processing CSA
      iwlwifi: mvm: update RFI TLV

Grishma Kotecha (2):
      ice: implement low level recipes functions
      ice: allow adding advanced rules

Grzegorz Nitka (5):
      ice: set and release switchdev environment
      ice: introduce new type of VSI for switchdev
      ice: enable/disable switchdev when managing VFs
      ice: rebuild switchdev when resetting all VFs
      ice: switchdev slow path

Guangbin Huang (7):
      net: hns3: PF support get unicast MAC address space assigned by firmware
      net: hns3: PF support get multicast MAC address space assigned by firmware
      net: hns3: modify mac statistics update process for compatibility
      net: hns3: device specifications add number of mac statistics
      net: hns3: add support pause/pfc durations for mac statistics
      net: hns3: modify functions of converting speed ability to ethtool link mode
      net: hns3: add update ethtool advertised link modes for FIBRE port when autoneg off

Guenter Roeck (1):
      net: macb: Fix mdio child node detection

Guo-Feng Fan (2):
      rtw88: 8821c: support RFE type4 wifi NIC
      rtw88: 8821c: correct 2.4G tx power for type 2/4 NIC

Gustavo A. R. Silva (17):
      ath11k: Replace one-element array with flexible-array member
      ethtool: ioctl: Use array_size() helper in copy_{from,to}_user()
      net: bridge: Use array_size() helper in copy_to_user()
      net/mlx4: Use array_size() helper in copy_to_user()
      gve: Use kvcalloc() instead of kvzalloc()
      net_sched: Use struct_size() and flex_array_size() helpers
      net/mlx5: Use kvcalloc() instead of kvzalloc()
      net/mlx5: Use struct_size() helper in kvzalloc()
      net/mlx5e: Use array_size() helper
      net: sched: Use struct_size() helper in kvmalloc()
      net: broadcom: bcm4908_enet: use kcalloc() instead of kzalloc()
      net: mana: Use kcalloc() instead of kzalloc()
      net: stmmac: selftests: Use kcalloc() instead of kzalloc()
      ethernet: ti: cpts: Use devm_kcalloc() instead of devm_kzalloc()
      ath11k: Use kcalloc() instead of kzalloc()
      ice: use devm_kcalloc() instead of devm_kzalloc()
      netfilter: ebtables: use array_size() helper in copy_{from,to}_user()

Gyeongun Kang (1):
      gtp: use skb_dst_update_pmtu_no_confirm() instead of direct call

Gyumin Hwang (1):
      net:dev: Change napi_gro_complete return type to void

Haiyang Zhang (1):
      net: mana: Allow setting the number of queues while the NIC is down

Hans de Goede (3):
      Bluetooth: hci_h5: Fix (runtime)suspend issues on RTL8723BS HCIs
      Bluetooth: hci_h5: directly return hci_uart_register_device() ret-val
      brcmfmac: Add DMI nvram filename quirk for Cyberbook T116 tablet

Hao Chen (2):
      net: e1000e: solve insmod 'Unknown symbol mutex_lock' error
      net: hns3: debugfs add support dumping page pool info

Hariprasad Kelam (3):
      octeontx2-pf: CN10K: Hide RPM stats over ethtool
      octeontx2-af: verify CQ context updates
      octeontx2-af: cn10k: RPM hardware timestamp configuration

Harman Kalra (2):
      octeontx2-af: Reset PTP config in FLR handler
      octeontx2-af: cn10k: debugfs for dumping LMTST map table

Hauke Mehrtens (1):
      mt76: Print error message when reading EEPROM from mtd failed

Heiko Carstens (6):
      s390/ctcm: remove incorrect kernel doc indicators
      s390/lcs: remove incorrect kernel doc indicators
      s390/netiucv: remove incorrect kernel doc indicators
      s390/qeth: fix various format strings
      s390/qeth: add __printf format attribute to qeth_dbf_longtext
      s390/qeth: fix kernel doc comments

Heiner Kallweit (3):
      r8169: remove support for chip version RTL_GIGA_MAC_VER_27
      ethtool: prevent endless loop if eeprom size is smaller than announced
      sky2: Stop printing VPD info to debugfs

Hengqi Chen (12):
      libbpf: Support uniform BTF-defined key/value specification across all BPF maps
      selftests/bpf: Use BTF-defined key/value for map definitions
      libbpf: Deprecate bpf_{map,program}__{prev,next} APIs since v0.7
      selftests/bpf: Switch to new bpf_object__next_{map,program} APIs
      libbpf: Deprecate bpf_object__unload() API since v0.6
      bpf: Add bpf_skc_to_unix_sock() helper
      selftests/bpf: Test bpf_skc_to_unix_sock() helper
      libbpf: Add btf__type_cnt() and btf__raw_data() APIs
      perf bpf: Switch to new btf__raw_data API
      tools/resolve_btfids: Switch to new btf__type_cnt API
      bpftool: Switch to new btf__type_cnt API
      selftests/bpf: Switch to new btf__type_cnt/btf__raw_data APIs

Hilda Wu (1):
      Bluetooth: btrtl: Ask ic_info to drop firmware

Horatiu Vultur (1):
      net: phy: micrel: Add support for LAN8804 PHY

Hou Tao (7):
      bpf: Support writable context for bare tracepoint
      libbpf: Support detecting and attaching of writable tracepoint program
      bpf/selftests: Add test for writable bare tracepoint
      bpf: Factor out a helper to prepare trampoline for struct_ops prog
      bpf: Factor out helpers for ctx access checking
      bpf: Add dummy BPF STRUCT_OPS for test purpose
      selftests/bpf: Add test cases for struct_ops prog

Huazhong Tan (1):
      net: hns3: add debugfs support for interrupt coalesce

Ido Schimmel (21):
      mlxsw: core: Initialize switch driver last
      mlxsw: core: Remove mlxsw_core_is_initialized()
      mlxsw: core_env: Defer handling of module temperature warning events
      mlxsw: core_env: Convert 'module_info_lock' to a mutex
      mlxsw: spectrum: Do not return an error in ndo_stop()
      mlxsw: spectrum: Do not return an error in mlxsw_sp_port_module_unmap()
      mlxsw: Track per-module port status
      mlxsw: reg: Add fields to PMAOS register
      mlxsw: Make PMAOS pack function more generic
      mlxsw: Add support for transceiver modules reset
      mlxsw: spectrum_router: Add trap adjacency entry upon first nexthop group
      mlxsw: spectrum_router: Start using new trap adjacency entry
      ethtool: Add ability to control transceiver modules' power mode
      mlxsw: reg: Add Port Module Memory Map Properties register
      mlxsw: reg: Add Management Cable IO and Notifications register
      mlxsw: Add ability to control transceiver modules' power mode
      ethtool: Add transceiver module extended state
      mlxsw: Add support for transceiver module extended state
      mlxsw: item: Annotate item helpers with '__maybe_unused'
      selftests: mlxsw: Use permanent neighbours instead of reachable ones
      selftests: mlxsw: Reduce test run time

Ilan Peer (1):
      iwlwifi: mvm: Use all Rx chains for roaming scan

Ilya Leoshkevich (11):
      selftests/bpf: Skip verifier tests that fail to load with ENOTSUPP
      selftests/bpf: Use cpu_number only on arches that have it
      libbpf: Fix dumping big-endian bitfields
      libbpf: Fix dumping non-aligned __int128
      libbpf: Fix ptr_is_aligned() usages
      libbpf: Fix endianness detection in BPF_CORE_READ_BITFIELD_PROBED()
      libbpf: Use __BYTE_ORDER__
      selftests/bpf: Use __BYTE_ORDER__
      samples: seccomp: Use __BYTE_ORDER__
      selftests/seccomp: Use __BYTE_ORDER__
      selftests/bpf: Fix test_core_reloc_mods on big-endian machines

Ioana Ciornei (8):
      net: enetc: declare NETIF_F_HW_CSUM and do it in software
      net: enetc: add support for software TSO
      net: enetc: include ip6_checksum.h for csum_ipv6_magic
      soc: fsl: dpio: extract the QBMAN clock frequency from the attributes
      soc: fsl: dpio: add support for irq coalescing per software portal
      net: dpaa2: add support for manual setup of IRQ coalesing
      soc: fsl: dpio: add Net DIM integration
      net: dpaa2: add adaptive interrupt coalescing

Ivan Vecera (1):
      net: bridge: fix uninitialized variables when BRIDGE_CFM is disabled

Jacob Keller (2):
      ice: refactor devlink getter/fallback functions to void
      devlink: report maximum number of snapshots with regions

Jakub Kicinski (216):
      net: sched: update default qdisc visibility after Tx queue cnt changes
      netdevsim: add ability to change channel count
      selftests: net: test ethtool -L vs mq
      Revert "net: wwan: iosm: firmware flashing and coredump collection"
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'net-dsa-b53-clean-up-cpu-imp-ports'
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      net: sched: move and reuse mq_change_real_num_tx()
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      net: make napi_disable() symmetric with enable
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge tag 'mlx5-updates-2021-09-30' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      arch: use eth_hw_addr_set()
      net: use eth_hw_addr_set()
      ethernet: use eth_hw_addr_set()
      net: usb: use eth_hw_addr_set()
      net: use eth_hw_addr_set() instead of ether_addr_copy()
      ethernet: use eth_hw_addr_set() instead of ether_addr_copy()
      net: usb: use eth_hw_addr_set() instead of ether_addr_copy()
      ethernet: chelsio: use eth_hw_addr_set()
      ethernet: s2io: use eth_hw_addr_set()
      fddi: use eth_hw_addr_set()
      ethernet: use eth_hw_addr_set() - casts
      ethernet: ehea: add missing cast
      mlx4: replace mlx4_mac_to_u64() with ether_addr_to_u64()
      mlx4: replace mlx4_u64_to_mac() with u64_to_ether_addr()
      mlx4: remove custom dev_addr clearing
      mlx4: constify args for const dev_addr
      ethernet: use eth_hw_addr_set() for dev->addr_len cases
      net: usb: use eth_hw_addr_set() for dev->addr_len cases
      Merge tag 'for-net-next-2021-10-01' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next
      Merge branch 'ethtool-add-ability-to-control-transceiver-modules-power-mode'
      Merge branch 'add-mdiobus_modify_changed-helper'
      of: net: move of_net under net/
      of: net: add a helper for loading netdev->dev_addr
      ethernet: use of_get_ethdev_address()
      device property: move mac addr helpers to eth.c
      eth: fwnode: change the return type of mac address helpers
      eth: fwnode: remove the addr len from mac helpers
      eth: fwnode: add a helper for loading netdev->dev_addr
      ethernet: use device_get_ethdev_address()
      ethernet: make more use of device_get_ethdev_address()
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      ethernet: un-export nvmem_get_mac_address()
      eth: platform: add a helper for loading netdev->dev_addr
      ethernet: use platform_get_ethdev_address()
      ethernet: forcedeth: remove direct netdev->dev_addr writes
      ethernet: tg3: remove direct netdev->dev_addr writes
      ethernet: tulip: remove direct netdev->dev_addr writes
      ethernet: sun: remove direct netdev->dev_addr writes
      ethernet: 8390: remove direct netdev->dev_addr writes
      net: use dev_addr_set()
      Merge branch 'nfc-minor-printk-cleanup'
      tulip: fix setting device address from rom
      ethernet: tulip: avoid duplicate variable name on sparc
      Merge branch 'devlink-reload-simplification'
      Merge branch 'add-functional-support-for-gigabit-ethernet-driver'
      ax25: constify dev_addr passing
      rose: constify dev_addr passing
      llc/snap: constify dev_addr passing
      ipv6: constify dev_addr passing
      tipc: constify dev_addr passing
      decnet: constify dev_addr passing
      Merge branch 'net-constify-dev_addr-passing-for-protocols'
      netdevice: demote the type of some dev_addr_set() helpers
      hamradio: use dev_addr_set() for setting device address
      ip: use dev_addr_set() in tunnels
      Merge branch 'net-use-dev_addr_set-in-hamradio-and-ip-tunnels'
      net: remove single-byte netdev->dev_addr writes
      Merge branch 'mlxsw-show-per-band-ecn-marked-counter-on-qdisc'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      ethernet: constify references to netdev->dev_addr in drivers
      ethernet: make eth_hw_addr_random() use dev_addr_set()
      ethernet: make use of eth_hw_addr_random() where appropriate
      ethernet: manually convert memcpy(dev_addr,..., sizeof(addr))
      ethernet: ibm/emac: use of_get_ethdev_address() to load dev_addr
      ethernet: replace netdev->dev_addr assignment loops
      ethernet: replace netdev->dev_addr 16bit writes
      Merge branch 'ethernet-more-netdev-dev_addr-write-removals'
      ethernet: remove random_ether_addr()
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'minor-managed-neighbor-follow-ups'
      Merge branch 'octeontx2-af-miscellaneous-changes-for-cpt'
      ethernet: adaptec: use eth_hw_addr_set()
      ethernet: aeroflex: use eth_hw_addr_set()
      ethernet: alteon: use eth_hw_addr_set()
      ethernet: amd: use eth_hw_addr_set()
      ethernet: aquantia: use eth_hw_addr_set()
      ethernet: bnx2x: use eth_hw_addr_set()
      ethernet: bcmgenet: use eth_hw_addr_set()
      ethernet: enic: use eth_hw_addr_set()
      ethernet: ec_bhf: use eth_hw_addr_set()
      ethernet: enetc: use eth_hw_addr_set()
      ethernet: ibmveth: use ether_addr_to_u64()
      ethernet: ixgb: use eth_hw_addr_set()
      net: stream: don't purge sk_error_queue in sk_stream_kill_queues()
      ethernet: use eth_hw_addr_set() in unmaintained drivers
      mlx5: prevent 64bit divide
      ethernet: mv643xx: use eth_hw_addr_set()
      ethernet: sky2/skge: use eth_hw_addr_set()
      ethernet: lpc: use eth_hw_addr_set()
      ethernet: netxen: use eth_hw_addr_set()
      ethernet: r8169: use eth_hw_addr_set()
      ethernet: renesas: use eth_hw_addr_set()
      ethernet: rocker: use eth_hw_addr_set()
      ethernet: sxgbe: use eth_hw_addr_set()
      ethernet: sis190: use eth_hw_addr_set()
      ethernet: sis900: use eth_hw_addr_set()
      ethernet: smc91x: use eth_hw_addr_set()
      ethernet: smsc: use eth_hw_addr_set()
      ethernet: add a helper for assigning port addresses
      ethernet: ocelot: use eth_hw_addr_gen()
      ethernet: prestera: use eth_hw_addr_gen()
      ethernet: fec: use eth_hw_addr_gen()
      ethernet: mlxsw: use eth_hw_addr_gen()
      ethernet: sparx5: use eth_hw_addr_gen()
      Merge branch 'net-sched-fixes-after-recent-qdisc-running-changes'
      wireless: use eth_hw_addr_set()
      wireless: use eth_hw_addr_set() instead of ether_addr_copy()
      wireless: use eth_hw_addr_set() for dev->addr_len cases
      ath6kl: use eth_hw_addr_set()
      wil6210: use eth_hw_addr_set()
      atmel: use eth_hw_addr_set()
      brcmfmac: prepare for const netdev->dev_addr
      airo: use eth_hw_addr_set()
      ipw2200: prepare for const netdev->dev_addr
      hostap: use eth_hw_addr_set()
      wilc1000: use eth_hw_addr_set()
      ray_cs: use eth_hw_addr_set()
      wl3501_cs: use eth_hw_addr_set()
      zd1201: use eth_hw_addr_set()
      ethernet: netsec: use eth_hw_addr_set()
      ethernet: stmmac: use eth_hw_addr_set()
      ethernet: tehuti: use eth_hw_addr_set()
      ethernet: tlan: use eth_hw_addr_set()
      ethernet: via-rhine: use eth_hw_addr_set()
      ethernet: via-velocity: use eth_hw_addr_set()
      batman-adv: prepare for const netdev->dev_addr
      mac802154: use dev_addr_set()
      mac802154: use dev_addr_set() - manual
      batman-adv: use eth_hw_addr_set() instead of ether_addr_copy()
      wireless: mac80211_hwsim: use eth_hw_addr_set()
      mac80211: use eth_hw_addr_set()
      cfg80211: prepare for const netdev->dev_addr
      Merge branch 'enetc-trivial-ptp-one-step-tx-timestamping-cleanups'
      Merge branch 'ax88796c-spi-ethernet-adapter'
      mlx5: fix build after merge
      net: xen: use eth_hw_addr_set()
      usb: smsc: use eth_hw_addr_set()
      net: qmi_wwan: use dev_addr_mod()
      net: usb: don't write directly to netdev->dev_addr
      fddi: defxx,defza: use dev_addr_set()
      fddi: skfp: constify and use dev_addr_set()
      net: fjes: constify and use eth_hw_addr_set()
      net: hippi: use dev_addr_set()
      net: s390: constify and use eth_hw_addr_set()
      net: plip: use eth_hw_addr_set()
      net: sb1000,rionet: use eth_hw_addr_set()
      net: hldc_fr: use dev_addr_set()
      Merge branch 'net-don-t-write-directly-to-netdev-dev_addr'
      Merge tag 'mac80211-next-for-net-next-2021-10-21' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next
      Merge tag 'wireless-drivers-next-2021-10-22' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next
      Merge branch 'delete-impossible-devlink-notifications'
      net: core: constify mac addrs in selftests
      net: rtnetlink: use __dev_addr_set()
      net: phy: constify netdev->dev_addr references
      net: bonding: constify and use dev_addr_set()
      net: hsr: get ready for const netdev->dev_addr
      net: caif: get ready for const netdev->dev_addr
      net: drivers: get ready for const netdev->dev_addr
      net: atm: use address setting helpers
      fddi: defza: add missing pointer type cast
      bluetooth: use eth_hw_addr_set()
      bluetooth: use dev_addr_set()
      Merge branch 'bluetooth-don-t-write-directly-to-netdev-dev_addr'
      net/mlx5e: don't write directly to netdev->dev_addr
      Merge branch 'tcp-receive-path-optimizations'
      Merge branch 'small-fixes-for-true-expression-checks'
      net/mlx5: remove the recent devlink params
      Merge branch 'two-reverts-to-calm-down-devlink-discussion'
      staging: use of_get_ethdev_address()
      net: thunderbolt: use eth_hw_addr_set()
      Merge branch 'mptcp-rework-fwd-memory-allocation-and-one-cleanup'
      media: use eth_hw_addr_set()
      firewire: don't write directly to netdev->dev_addr
      mpt fusion: use dev_addr_set()
      net: virtio: use eth_hw_addr_set()
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'mlxsw-offload-root-tbf-as-port-shaper'
      Merge branch 'code-movement-to-br_switchdev-c'
      net: sgi-xp: use eth_hw_addr_set()
      net: um: use eth_hw_addr_set()
      net: xtensa: use eth_hw_addr_set()
      devlink: make all symbols GPL-only
      Merge tag 'wireless-drivers-next-2021-10-29' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next
      netdevsim: remove max_vfs dentry
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      udp6: allow SO_MARK ctrl msg to affect routing
      selftests: udp: test for passing SO_MARK as cmsg
      ethtool: push the rtnl_lock into dev_ethtool()
      ethtool: handle info/flash data copying outside rtnl_lock
      devlink: expose get/put functions
      ethtool: don't drop the rtnl_lock half way thru the ioctl
      netdevsim: take rtnl_lock when assigning num_vfs
      netdevsim: move vfconfig to nsim_dev
      netdevsim: move details of vf config to dev
      netdevsim: move max vf config to dev
      netdevsim: rename 'driver' entry points
      netdevsim: fix uninit value in nsim_drv_configure_vfs()
      Merge branch 'accurate-memory-charging-for-msg_zerocopy'
      Merge branch 'make-neighbor-eviction-controllable-by-userspace'
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Revert "net: avoid double accounting for pure zerocopy skbs"

James Prestwood (4):
      brcmfmac: fix incorrect error prints
      net: arp: introduce arp_evict_nocarrier sysctl parameter
      net: ndisc: introduce ndisc_evict_nocarrier sysctl parameter
      selftests: net: add arp_ndisc_evict_nocarrier

Jan Kundrát (1):
      igb: unbreak I2C bit-banging on i350

Jason Xing (1):
      ixgbe: let the xdpdrv work with more than 64 cpus

Jean Sacren (10):
      net: tg3: fix obsolete check of !err
      net: tg3: fix redundant check of true expression
      net: qed_debug: fix check of false (grc_param < 0) expression
      net: macvtap: fix template string argument of device_create() call
      net: ipvtap: fix template string argument of device_create() call
      net: qed_ptp: fix check of true !rc expression
      net: qed_dev: fix check of true !rc expression
      net: netxen: fix code indentation
      net: bareudp: fix duplicate checks of data[] expressions
      net: vmxnet3: remove multiple false checks in vmxnet3_ethtool.c

Jeff Guo (1):
      ice: Fix macro name for IPv4 fragment flag

Jeremy Kerr (21):
      mctp: Allow local delivery to the null EID
      mctp: locking, lifetime and validity changes for sk_keys
      mctp: Add refcounts to mctp_dev
      mctp: Implement a timeout for tags
      mctp: Add tracepoints for tag/key handling
      mctp: Do inits as a subsys_initcall
      doc/mctp: Add a little detail about kernel internals
      mctp: Add initial test structure and fragmentation test
      mctp: Add test utils
      mctp: Add packet rx tests
      mctp: Add route input to socket tests
      mctp: Add input reassembly tests
      mctp: Add initial test structure and fragmentation test
      mctp: Add test utils
      mctp: Add packet rx tests
      mctp: Add route input to socket tests
      mctp: Add input reassembly tests
      mctp: Implement extended addressing
      mctp: Return new key from mctp_alloc_local_tag
      mctp: Add flow extension to skb
      mctp: Pass flow data & flow release events to drivers

Jesse Brandeburg (4):
      ice: update dim usage and moderation
      ice: fix rate limit update after coalesce change
      ice: fix software generating extra interrupts
      net-core: use netdev_* calls for kernel messages

Jiapeng Chong (1):
      net: phy: Fix unsigned comparison with less than zero

Jiaran Zhang (1):
      net: hns3: add error recovery module and type for himac

Jiasheng Jiang (2):
      rxrpc: Fix _usecs_to_jiffies() by using usecs_to_jiffies()
      hv_netvsc: Add comment of netvsc_xdp_xmit()

Jie Meng (3):
      bpf,x64 Emit IMUL instead of MUL for x86-64
      bpf, x64: Save bytes for DIV by reducing reg copies
      bpf, x64: Factor out emission of REX byte in more cases

Jiri Benc (1):
      seltests: bpf: test_tunnel: Use ip neigh

Jiri Olsa (5):
      selftest/bpf: Switch recursion test to use htab_map_delete_elem
      selftests/bpf: Fix perf_buffer test on system with offline cpus
      selftests/bpf: Fix possible/online index mismatch in perf_buffer test
      selftests/bpf: Use nanosleep tracepoint in perf buffer test
      kbuild: Unify options for BTF generation for vmlinux and modules

Jiri Pirko (8):
      mlxsw: spectrum: Bump minimum FW version to xx.2008.3326
      mlxsw: spectrum: Move port module mapping before core port init
      mlxsw: spectrum: Move port SWID set before core port init
      mlxsw: reg: Add Port Local port to Label Port mapping Register
      mlxsw: spectrum: Use PLLP to get front panel number and split number
      mlxsw: reg: Add Port Module To local DataBase Register
      mlxsw: spectrum: Use PMTDB register to obtain split info
      mlxsw: reg: Remove PMTM register

Joanne Koong (8):
      bpf: Add bloom filter map implementation
      libbpf: Add "map_extra" as a per-map-type extra flag
      selftests/bpf: Add bloom filter map test cases
      bpf/benchs: Add benchmark tests for bloom filter throughput + false positive
      bpf/benchs: Add benchmarks for comparing hashmap lookups w/ vs. w/out bloom filter
      bpf: Bloom filter map naming fixups
      bpf: Add alignment padding for "map_extra" + consolidate holes
      selftests/bpf: Add bloom map success test for userspace calls

Joe Burton (1):
      libbpf: Deprecate bpf_objects_list

Johan Almbladh (33):
      bpf/tests: Allow different number of runs per test case
      bpf/tests: Reduce memory footprint of test suite
      bpf/tests: Add exhaustive tests of ALU shift values
      bpf/tests: Add exhaustive tests of ALU operand magnitudes
      bpf/tests: Add exhaustive tests of JMP operand magnitudes
      bpf/tests: Add staggered JMP and JMP32 tests
      bpf/tests: Add exhaustive test of LD_IMM64 immediate magnitudes
      bpf/tests: Add test case flag for verifier zero-extension
      bpf/tests: Add JMP tests with small offsets
      bpf/tests: Add JMP tests with degenerate conditional
      bpf/tests: Expand branch conversion JIT test
      bpf/tests: Add more BPF_END byte order conversion tests
      bpf/tests: Fix error in tail call limit tests
      bpf/tests: Add tail call limit test with external function call
      bpf/tests: Add tests of BPF_LDX and BPF_STX with small sizes
      bpf/tests: Add zero-extension checks in BPF_ATOMIC tests
      bpf/tests: Add exhaustive tests of BPF_ATOMIC magnitudes
      bpf/tests: Add tests to check source register zero-extension
      bpf/tests: Add more tests for ALU and ATOMIC register clobbering
      bpf/tests: Minor restructuring of ALU tests
      bpf/tests: Add exhaustive tests of ALU register combinations
      bpf/tests: Add exhaustive tests of BPF_ATOMIC register combinations
      bpf/tests: Add test of ALU shifts with operand register aliasing
      bpf/tests: Add test of LDX_MEM with operand aliasing
      mips, uasm: Add workaround for Loongson-2F nop CPU errata
      mips, bpf: Add eBPF JIT for 32-bit MIPS
      mips, bpf: Add new eBPF JIT for 64-bit MIPS
      mips, bpf: Add JIT workarounds for CPU errata
      mips, bpf: Enable eBPF JITs
      mips, bpf: Remove old BPF JIT implementations
      mips, bpf: Fix Makefile that referenced a removed file
      mips, bpf: Optimize loading of 64-bit constants
      bpf, tests: Add more LD_IMM64 tests

Johan Hovold (7):
      ath10k: fix control-message timeout
      ath6kl: fix control-message timeout
      ath10k: fix division by zero in send path
      ath6kl: fix division by zero in send path
      rtl8187: fix control-message timeouts
      rsi: fix control-message timeout
      mwifiex: fix division by zero in fw download path

Johannes Berg (50):
      cfg80211: honour V=1 in certificate code generation
      mac80211: reduce stack usage in debugfs
      mac80211: mesh: clean up rx_bcn_presp API
      mac80211: move CRC into struct ieee802_11_elems
      mac80211: mlme: find auth challenge directly
      mac80211: always allocate struct ieee802_11_elems
      nl80211: don't put struct cfg80211_ap_settings on stack
      mac80211: twt: don't use potentially unaligned pointer
      cfg80211: always free wiphy specific regdomain
      nl80211: don't kfree() ERR_PTR() value
      iwlwifi: mvm: reset PM state on unsuccessful resume
      iwlwifi: pnvm: don't kmemdup() more than we have
      iwlwifi: pnvm: read EFI data only if long enough
      iwlwifi: cfg: set low-latency-xtal for some integrated So devices
      mac80211: fix memory leaks with element parsing
      mac80211: fils: use cfg80211_find_ext_elem()
      nl80211: use element finding functions
      cfg80211: scan: use element finding functions in easy cases
      mac80211: use ieee80211_bss_get_elem() in most places
      cfg80211: fix kernel-doc for MBSSID EMA
      iwlwifi: mvm: fix ieee80211_get_he_iftype_cap() iftype
      iwlwifi: mvm: disable RX-diversity in powersave
      iwlwifi: add vendor specific capabilities for some RFs
      iwlwifi: add some missing kernel-doc in struct iwl_fw
      iwlwifi: api: remove unused RX status bits
      iwlwifi: remove MODULE_AUTHOR() statements
      iwlwifi: remove contact information
      iwlwifi: fix fw/img.c license statement
      iwlwifi: api: fix struct iwl_wowlan_status_v7 kernel-doc
      iwlwifi: mvm: correct sta-state logic for TDLS
      iwlwifi: fw dump: add infrastructure for dump scrubbing
      iwlwifi: parse debug exclude data from firmware file
      iwlwifi: mvm: scrub key material in firmware dumps
      iwlwifi: remove redundant iwl_finish_nic_init() argument
      iwlwifi: mvm: remove session protection after auth/assoc
      iwlwifi: allow rate-limited error messages
      iwlwifi: mvm: reduce WARN_ON() in TX status path
      iwlwifi: pcie: try to grab NIC access early
      iwlwifi: mvm: set BT-coex high priority for 802.1X/4-way-HS
      iwlwifi: pnvm: print out the version properly
      iwlwifi: pcie: fix killer name matching for AX200
      iwlwifi: pcie: remove duplicate entry
      iwlwifi: pcie: refactor dev_info lookup
      iwlwifi: pcie: remove two duplicate PNJ device entries
      iwlwifi: pcie: simplify iwl_pci_find_dev_info()
      iwlwifi: dump host monitor data when NIC doesn't init
      iwlwifi: fw: uefi: add missing include guards
      iwlwifi: mvm: d3: use internal data representation
      iwlwifi: mvm: remove session protection on disassoc
      iwlwifi: mvm: extend session protection on association

John Crispin (2):
      nl80211: MBSSID and EMA support in AP mode
      mac80211: MBSSID support in interface handling

John Fraker (1):
      gve: Recover from queue stall due to missed IRQ

Jon Maxwell (1):
      tcp: don't free a FIN sk_buff in tcp_remove_empty_skb()

Jonas Dreßler (16):
      mwifiex: Small cleanup for handling virtual interface type changes
      mwifiex: Use function to check whether interface type change is allowed
      mwifiex: Run SET_BSS_MODE when changing from P2P to STATION vif-type
      mwifiex: Use helper function for counting interface types
      mwifiex: Update virtual interface counters right after setting bss_type
      mwifiex: Allow switching interface type from P2P_CLIENT to P2P_GO
      mwifiex: Handle interface type changes from AP to STATION
      mwifiex: Properly initialize private structure on interface type changes
      mwifiex: Fix copy-paste mistake when creating virtual interface
      mwifiex: Read a PCI register after writing the TX ring write pointer
      mwifiex: Try waking the firmware until we get an interrupt
      mwifiex: Don't log error on suspend if wake-on-wlan is disabled
      mwifiex: Log an error on command failure during key-material upload
      mwifiex: Fix an incorrect comment
      mwifiex: Send DELBA requests according to spec
      mwifiex: Deactive host sleep using HSCFG after it was activated manually

Jonathan Lemon (18):
      ptp: ocp: parameterize the i2c driver used
      ptp: ocp: Parameterize the TOD information display.
      ptp: ocp: Skip I2C flash read when there is no controller.
      ptp: ocp: Skip resources with out of range irqs
      ptp: ocp: Report error if resource registration fails.
      ptp: ocp: Add third timestamper
      ptp: ocp: Add SMA selector and controls
      ptp: ocp: Add IRIG-B and DCF blocks
      ptp: ocp: Add IRIG-B output mode control
      ptp: ocp: Add sysfs attribute utc_tai_offset
      ptp: ocp: Separate the init and info logic
      ptp: ocp: Add debugfs entry for timecard
      ptp: ocp: Add NMEA output
      ptp: ocp: Add second GNSS device
      ptp: ocp: Enable 4th timestamper / PPS generator
      ptp: ocp: Have FPGA fold in ns adjustment for adjtime.
      ptp: ocp: Add timestamp window adjustment
      docs: ABI: Add sysfs documentation for timecard

Jordan Kim (1):
      gve: Allow pageflips on larger pages

Joseph Hwang (6):
      Bluetooth: btusb: disable Intel link statistics telemetry events
      Bluetooth: refactor set_exp_feature with a feature table
      Bluetooth: Support the quality report events
      Bluetooth: set quality report callback for Intel
      Bluetooth: hci_qca: enable Qualcomm WCN399x for AOSP extension
      Bluetooth: btrtl: enable Realtek 8822C/8852A to support AOSP extension

Joshua Roys (2):
      net: mlx4: Add support for XDP_REDIRECT
      net/mlx4_en: Add XDP_REDIRECT statistics

Juhee Kang (3):
      bnxt: use netif_is_rxfh_configured instead of open code
      hv_netvsc: use netif_is_bond_master() instead of open code
      mlxsw: spectrum: use netif_is_macsec() instead of open code

Julian Wiedmann (6):
      s390/qeth: improve trace entries for MAC address (un)registration
      s390/qeth: remove .do_ioctl() callback from driver discipline
      s390/qeth: move qdio's QAOB cache into qeth
      s390/qeth: clarify remaining dev_kfree_skb_any() users
      s390/qeth: don't keep track of Input Queue count
      s390/qeth: update kerneldoc for qeth_add_hw_header()

Justin Iurman (4):
      ipv6: ioam: Distinguish input and output for hop-limit
      ipv6: ioam: Prerequisite patch for ioam6_iptunnel
      ipv6: ioam: Add support for the ip6ip6 encapsulation
      selftests: net: Test for the IOAM encapsulation with IPv6

Kalle Valo (8):
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      ath11k: fix m68k and xtensa build failure in ath11k_peer_assoc_h_smps()
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge tag 'mt76-for-kvalo-2021-10-20' of https://github.com/nbd168/wireless
      Merge tag 'iwlwifi-next-for-kalle-2021-10-22' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      Merge tag 'mt76-for-kvalo-2021-10-23' of https://github.com/nbd168/wireless
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge tag 'iwlwifi-next-for-kalle-2021-10-28' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next

Karen Sornek (1):
      iavf: Add helper function to go from pci_dev to adapter

Karsten Graul (13):
      net/smc: add support for user defined EIDs
      net/smc: keep static copy of system EID
      net/smc: add generic netlink support for system EID
      net/smc: save stack space and allocate smc_init_info
      net/smc: prepare for SMC-Rv2 connection
      net/smc: add SMC-Rv2 connection establishment
      net/smc: add listen processing for SMC-Rv2
      net/smc: add v2 format of CLC decline message
      net/smc: retrieve v2 gid from IB device
      net/smc: add v2 support to the work request layer
      net/smc: extend LLC layer for SMC-Rv2
      net/smc: add netlink support for SMC-Rv2
      net/smc: stop links when their GID is removed

Karthikeyan Periyasamy (6):
      ath11k: fix 4addr multicast packet tx
      ath11k: Refactor spectral FFT bin size
      ath11k: Introduce spectral hw configurable param
      ath11k: Fix the spectral minimum FFT bin count
      ath11k: Add spectral scan support for QCN9074
      ath11k: Avoid "No VIF found" warning message

Kees Cook (2):
      bpf: Replace "want address" users of BPF_CAST_CALL with BPF_CALL_IMM
      bpf: Replace callers of BPF_CAST_CALL with proper function typedef

Kev Jackson (1):
      bpf, xdp, docs: Correct some English grammar and spelling

Kevin Lo (2):
      rtw89: remove duplicate register definitions
      rtw89: fix return value in hfc_pub_cfg_chk

Khalid Manaa (6):
      net/mlx5e: Rename TIR lro functions to TIR packet merge functions
      net/mlx5e: Add handle SHAMPO cqe support
      net/mlx5e: HW_GRO cqe handler implementation
      net/mlx5e: Add HW_GRO statistics
      net/mlx5e: Add HW-GRO offload
      net/mlx5e: Prevent HW-GRO and CQE-COMPRESS features operate together

Kiran K (14):
      Bluetooth: btintel: Fix boot address
      Bluetooth: btintel: Read boot address irrespective of controller mode
      Bluetooth: Enumerate local supported codec and cache details
      Bluetooth: Add support for Read Local Supported Codecs V2
      Bluetooth: btintel: Read supported offload use cases
      Bluetooth: Allow querying of supported offload codecs over SCO socket
      Bluetooth: btintel: Define callback to fetch data_path_id
      Bluetooth: Allow setting of codec for HFP offload use case
      Bluetooth: Add support for HCI_Enhanced_Setup_Synchronous_Connection command
      Bluetooth: Configure codec for HFP offload use case
      Bluetooth: btintel: Define a callback to fetch codec config data
      Bluetooth: Add support for msbc coding format
      Bluetooth: Add offload feature under experimental flag
      Bluetooth: hci_vhci: Add support for offload codecs over SCO

Kiran Kumar K (4):
      octeontx2-af: Limit KPU parsing for GTPU packets
      octeontx2-af: Optimize KPU1 processing for variable-length headers
      octeontx2-af: Adjust LA pointer for cpt parse header
      octeontx2-af: Increase number of reserved entries in KPU

Kiran Patil (4):
      ice: ndo_setup_tc implementation for PF
      ice: Add infrastructure for mqprio support via ndo_setup_tc
      ice: enable ndo_setup_tc support for mqprio_qdisc
      ice: Add tc-flower filter support for channel

Krzysztof Kozlowski (19):
      nfc: do not break pr_debug() call into separate lines
      nfc: fdp: drop unneeded debug prints
      nfc: pn533: drop unneeded debug prints
      nfc: pn533: use dev_err() instead of pr_err()
      nfc: pn544: drop unneeded debug prints
      nfc: pn544: drop unneeded memory allocation fail messages
      nfc: microread: drop unneeded memory allocation fail messages
      nfc: mrvl: drop unneeded memory allocation fail messages
      net: microchip: encx24j600: drop unneeded MODULE_ALIAS
      zd1211rw: remove duplicate USB device ID
      ar5512: remove duplicate USB device ID
      rt2x00: remove duplicate USB device ID
      nfc: drop unneeded debug prints
      nfc: nci: replace GPLv2 boilerplate with SPDX
      nfc: s3fwrn5: simplify dereferencing pointer to struct device
      nfc: st-nci: drop unneeded debug prints
      nfc: st21nfca: drop unneeded debug prints
      nfc: trf7970a: drop unneeded debug prints
      nfc: microread: drop unneeded debug prints

Kumar Kartikeya Dwivedi (20):
      bpf: selftests: Fix fd cleanup in get_branch_snapshot
      libbpf: Fix skel_internal.h to set errno on loader retval < 0
      bpf: Introduce BPF support for kernel module function calls
      bpf: Be conservative while processing invalid kfunc calls
      bpf: btf: Introduce helpers for dynamic BTF set registration
      tools: Allow specifying base BTF file in resolve_btfids
      bpf: Enable TCP congestion control kfunc from modules
      libbpf: Support kernel module function calls
      libbpf: Resolve invalid weak kfunc calls with imm = 0, off = 0
      libbpf: Update gen_loader to emit BTF_KIND_FUNC relocations
      bpf: selftests: Add selftests for module kfunc support
      bpf: Silence Coverity warning for find_kfunc_desc_btf
      bpf: Add bpf_kallsyms_lookup_name helper
      libbpf: Add typeless ksym support to gen_loader
      libbpf: Add weak ksym support to gen_loader
      libbpf: Ensure that BPF syscall fds are never 0, 1, or 2
      libbpf: Use O_CLOEXEC uniformly when opening fds
      selftests/bpf: Add weak/typeless ksym test for light skeleton
      selftests/bpf: Fix fd cleanup in sk_lookup test
      selftests/bpf: Fix memory leak in test_ima

Kunihiko Hayashi (2):
      dt-bindings: net: ave: Add bindings for NX1 SoC
      net: ethernet: ave: Add compatible string and SoC-dependent data for NX1 SoC

Kyungrok Chung (1):
      net: make use of helper netif_is_bridge_master()

Lama Kayal (1):
      net/mlx5: Warn for devlink reload when there are VFs alive

Larry Finger (1):
      Bbluetooth: btusb: Add another Bluetooth part for Realtek 8852AE

Lars-Peter Clausen (1):
      net: macb: ptp: Switch to gettimex64() interface

Lay, Kuan Loon (1):
      net: phy: dp83867: introduce critical chip default init for non-of platform

Len Baker (6):
      nfp: Prefer struct_size over open coded arithmetic
      nl80211: prefer struct_size over open coded arithmetic
      brcmfmac: Replace zero-length array with flexible array member
      ice: Prefer kcalloc over open coded arithmetic
      net: hns: Prefer struct_size over open coded arithmetic
      net/mlx5: DR, Prefer kcalloc over open coded arithmetic

Leon Romanovsky (48):
      net/mlx5: Publish and unpublish all devlink parameters at once
      devlink: Delete not-used single parameter notification APIs
      devlink: Delete not-used devlink APIs
      devlink: Make devlink_register to be void
      bnxt_en: Check devlink allocation and registration status
      bnxt_en: Properly remove port parameter support
      devlink: Delete not used port parameters APIs
      devlink: Remove single line function obfuscations
      ice: Delete always true check of PF pointer
      qed: Don't ignore devlink allocation failures
      devlink: Notify users when objects are accessible
      bnxt_en: Register devlink instance at the end devlink configuration
      liquidio: Overcome missing device lock protection in init/remove flows
      dpaa2-eth: Register devlink instance at the end of probe
      net: hinic: Open device for the user access when it is ready
      ice: Open devlink when device is ready
      octeontx2: Move devlink registration to be last devlink command
      net/prestera: Split devlink and traps registrations to separate routines
      net/mlx4: Move devlink_register to be the last initialization command
      net/mlx5: Accept devlink user input after driver initialization complete
      mlxsw: core: Register devlink instance last
      net: mscc: ocelot: delay devlink registration to the end
      nfp: Move delink_register to be last command
      ionic: Move devlink registration to be last devlink command
      qed: Move devlink registration to be last devlink command
      net: ethernet: ti: Move devlink registration to be last devlink command
      netdevsim: Move devlink registration to be last devlink command
      net: wwan: iosm: Move devlink_register to be last devlink command
      ptp: ocp: Move devlink registration to be last devlink command
      staging: qlge: Move devlink registration to be last devlink command
      net: dsa: Move devlink registration to be last devlink command
      devlink: Add missed notifications iterators
      devlink: Reduce struct devlink exposure
      devlink: Move netdev_to_devlink helpers to devlink.c
      devlink: Annotate devlink API calls
      devlink: Allow control devlink ops behavior through feature mask
      net/mlx5: Set devlink reload feature bit for supported devices only
      devlink: Delete reload enable/disable interface
      devlink: Remove extra device_lock assert checks
      Merge brank 'mlx5_mkey' into rdma.git for-next
      devlink: Delete obsolete parameters publish API
      devlink: Remove not-executed trap policer notifications
      devlink: Remove not-executed trap group notifications
      devlink: Clean not-executed param notifications
      Revert "devlink: Remove not-executed trap group notifications"
      Revert "devlink: Remove not-executed trap policer notifications"
      devlink: Simplify internal devlink params implementation
      bnxt_en: Remove not used other ULP define

Leon Yen (2):
      mt76: connac: fix mt76_connac_gtk_rekey_tlv usage
      mt76: connac: fix GTK rekey offload failure on WPA mixed mode

Li RongQing (2):
      skbuff: pass the result of data ksize to __build_skb_around
      virtio_net: skip RCU read lock by checking xdp_enabled of vi

Linus Lüssing (2):
      ath9k: add option to reset the wifi chip via debugfs
      ath9k: Fix potential interrupt storm on queue reset

Linus Walleij (10):
      net: dsa: tag_rtl4_a: Drop bit 9 from egress frames
      net: dsa: rtl8366: Drop custom VLAN set-up
      net: dsa: rtl8366rb: Rewrite weird VLAN filering enablement
      net: dsa: rtl8366rb: Fix off-by-one bug
      net: dsa: rtl8366: Fix a bug in deleting VLANs
      net: dsa: rtl8366: Drop and depromote pointless prints
      net: dsa: rtl8366rb: Use core filtering tracking
      net: dsa: rtl8366rb: Support disabling learning
      net: dsa: rtl8366rb: Support fast aging
      net: dsa: rtl8366rb: Support setting STP state

Liu Jian (3):
      skmsg: Lose offset info in sk_psock_skb_ingress
      selftests, bpf: Fix test_txmsg_ingress_parser error
      selftests, bpf: Add one test for sockmap with strparser

Loic Poulain (11):
      ath10k: Fix missing frame timestamp for beacon/probe-resp
      mac80211: Prevent AP probing during suspend
      wcn36xx: Fix (QoS) null data frame bitrate/modulation
      wcn36xx: Fix tx_status mechanism
      wcn36xx: Correct band/freq reporting on RX
      wcn36xx: Enable hardware scan offload for 5Ghz band
      wcn36xx: Add chained transfer support for AMSDU
      wcn36xx: Fix HT40 capability for 2Ghz band
      wcn36xx: Fix discarded frames due to wrong sequence number
      wcn36xx: Fix packet drop on resume
      wcn36xx: Channel list update before hardware scan

Lorenz Bauer (1):
      bpf: Do not invoke the XDP dispatcher for PROG_RUN with single repeat

Lorenzo Bianconi (68):
      mac80211: check hostapd configuration parsing twt requests
      mt76: mt7921: fix endianness in mt7921_mcu_tx_done_event
      mt76: mt7921: avoid unnecessary spin_lock/spin_unlock in mt7921_mcu_tx_done_event
      mt76: mt7915: fix endianness warning in mt7915_mac_add_txs_skb
      mt76: mt7921: fix endianness warning in mt7921_update_txs
      mt76: mt7615: fix endianness warning in mt7615_mac_write_txwi
      mt76: mt7921: fix survey-dump reporting
      mt76: mt76x02: fix endianness warnings in mt76x02_mac.c
      mt76: mt7921: introduce testmode support
      mt76: mt7921: get rid of monitor_vif
      mt76: mt7921: get rid of mt7921_mac_set_beacon_filter
      mt76: mt7921: introduce mt7921_mcu_set_beacon_filter utility routine
      mt76: overwrite default reg_ops if necessary
      mt76: mt7615: move mt7615_mcu_set_p2p_oppps in mt76_connac module
      mt76: mt7921: fix endianness warnings in mt7921_mac_decode_he_mu_radiotap
      mt76: mt7915: introduce bss coloring support
      mt76: mt7915: improve code readability in mt7915_mcu_sta_bfer_ht
      mt76: mt7921: move mt7921_queue_rx_skb to mac.c
      mt76: mt7921: always wake device if necessary in debugfs
      mt76: mt7921: update mib counters dumping phy stats
      mt76: mt7921: start reworking tx rate reporting
      mt76: mt7921: add support for tx status reporting
      mt76: mt7921: report tx rate directly from tx status
      mt76: mt7921: remove mcu rate reporting code
      mt76: mt7921: remove mt7921_sta_stats
      mt76: mt7915: honor all possible error conditions in mt7915_mcu_init()
      mt76: mt7915: fix possible infinite loop release semaphore
      mt76: connac: set 6G phymode in mt76_connac_get_phy_mode{,v2}
      mt76: connac: enable 6GHz band for hw scan
      mt76: connac: add 6GHz support to mt76_connac_mcu_set_channel_domain
      mt76: connac: set 6G phymode in single-sku support
      mt76: connac: add 6GHz support to mt76_connac_mcu_sta_tlv
      mt76: connac: add 6GHz support to mt76_connac_mcu_uni_add_bss
      mt76: connac: enable hw amsdu @ 6GHz
      mt76: add 6GHz support
      mt76: mt7921: add 6GHz support
      mt76: introduce packet_id idr
      mt76: remove mt76_wcid pointer from mt76_tx_status_check signature
      mt76: substitute sk_buff_head status_list with spinlock_t status_lock
      mt76: schedule status timeout at dma completion
      mt76: introduce __mt76_mcu_send_firmware routine
      mt76: mt7915: introduce __mt7915_get_tsf routine
      mt76: mt7915: introduce mt7915_mcu_twt_agrt_update mcu command
      mt76: mt7915: introduce mt7915_mac_add_twt_setup routine
      mt76: mt7915: enable twt responder capability
      mt76: mt7915: add twt_stats knob in debugfs
      mt76: debugfs: improve queue node readability
      mt76: connac: fix possible NULL pointer dereference in mt76_connac_get_phy_mode_v2
      mt76: rely on phy pointer in mt76_register_debugfs_fops routine signature
      mt76: mt7915: introduce mt76 debugfs sub-dir for ext-phy
      mt76: mt7915: improve code readability for xmit-queue handler
      mt76: sdio: export mt76s_alloc_rx_queue and mt76s_alloc_tx routines
      mt76: mt7915: remove dead code in debugfs code
      mt76: sdio: move common code in mt76_sdio module
      mt76: sdio: introduce parse_irq callback
      mt76: move mt76_sta_stats in mt76.h
      mt76: move mt76_ethtool_worker_info in mt76 module
      mt76: mt7915: run mt7915_get_et_stats holding mt76 mutex
      mt76: mt7915: move tx amsdu stats in mib_stats
      mt76: do not reset MIB counters in get_stats callback
      mt76: mt7921: add some more MIB counters
      mt76: mt7921: introduce stats reporting through ethtool
      mt76: mt7921: add sta stats accounting in mt7921_mac_add_txs_skb
      mt76: mt7921: move tx amsdu stats in mib_stats
      mt76: mt7921: add per-vif counters in ethtool
      mt76: mt7921: fix mt7921s Kconfig
      mt76: mt7915: fix endiannes warning mt7915_mcu_beacon_check_caps
      mt76: mt7921: disable 4addr capability

Luca Coelho (7):
      iwlwifi: mvm: Support new rate_n_flags for REPLY_RX_MPDU_CMD and RX_NO_DATA_NOTIF
      iwlwifi: mvm: remove csi from iwl_mvm_pass_packet_to_mac80211()
      iwlwifi: mvm: read 6E enablement flags from DSM and pass to FW
      iwlwifi: mvm: don't get address of mvm->fwrt just to dereference as a pointer
      iwlwifi: rename GEO_TX_POWER_LIMIT to PER_CHAIN_LIMIT_OFFSET_CMD
      iwlwifi: mvm: fix WGDS table print in iwl_mvm_chub_update_mcc()
      iwlwifi: bump FW API to 67 for AX devices

Luca Weiss (1):
      net: qrtr: combine nameservice into main module

Luiz Augusto von Dentz (17):
      Bluetooth: Fix enabling advertising for central role
      Bluetooth: Fix using address type from events
      Bluetooth: Fix using RPA when address has been resolved
      Bluetooth: Add bt_skb_sendmsg helper
      Bluetooth: Add bt_skb_sendmmsg helper
      Bluetooth: SCO: Replace use of memcpy_from_msg with bt_skb_sendmsg
      Bluetooth: RFCOMM: Replace use of memcpy_from_msg with bt_skb_sendmmsg
      Bluetooth: eir: Move EIR/Adv Data functions to its own file
      Bluetooth: hci_sock: Add support for BT_{SND,RCV}BUF
      Bluetooth: Fix passing NULL to PTR_ERR
      Bluetooth: SCO: Fix sco_send_frame returning skb->len
      Bluetooth: hci_core: Move all debugfs handling to hci_debugfs.c
      Bluetooth: Make use of hci_{suspend,resume}_dev on suspend notifier
      Bluetooth: hci_vhci: Add force_suspend entry
      Bluetooth: hci_vhci: Add force_prevent_wake entry
      Bluetooth: hci_sock: Replace use of memcpy_from_msg with bt_skb_sendmsg
      Bluetooth: Rename driver .prevent_wake to .wakeup

Lukas Bulwahn (1):
      MAINTAINERS: adjust file entry for of_net.c after movement

Lukas Wunner (5):
      netfilter: Rename ingress hook include file
      netfilter: Generalize ingress hook include file
      netfilter: Introduce egress hook
      netfilter: core: Fix clang warnings about unused static inlines
      ifb: Depend on netfilter alternatively to tc

Luo Jie (15):
      net: phy: at803x: replace AT803X_DEVICE_ADDR with MDIO_MMD_PCS
      net: phy: at803x: use phy_modify()
      net: phy: at803x: improve the WOL feature
      net: phy: at803x: use GENMASK() for speed status
      net: phy: add qca8081 ethernet phy driver
      net: phy: add qca8081 read_status
      net: phy: add qca8081 get_features
      net: phy: add qca8081 config_aneg
      net: phy: add constants for fast retrain related register
      net: phy: add genphy_c45_fast_retrain
      net: phy: add qca8081 config_init
      net: phy: add qca8081 soft_reset and enable master/slave seed
      net: phy: adjust qca8081 master/slave seed value if link down
      net: phy: add qca8081 cdt feature
      net: phy: fixed warning: Function parameter not described

Lv Ruyi (1):
      rtw89: fix error function parameter

M Chetan Kumar (10):
      net: wwan: iosm: firmware flashing and coredump collection
      net: wwan: iosm: fix linux-next build error
      net: wwan: iosm: devlink registration
      net: wwan: iosm: fw flashing support
      net: wwan: iosm: coredump collection support
      net: wwan: iosm: transport layer support for fw flashing/cd
      net: wwan: iosm: devlink fw flashing & cd collection documentation
      net: wwan: iosm: fw flashing & cd collection infrastructure changes
      net: wwan: iosm: fw flashing and cd improvements
      net: wwan: iosm: correct devlink extra params

Maciej Fijalkowski (9):
      ice: remove ring_active from ice_ring
      ice: move ice_container_type onto ice_ring_container
      ice: split ice_ring onto Tx/Rx separate structs
      ice: unify xdp_rings accesses
      ice: do not create xdp_frame on XDP_TX
      ice: propagate xdp_ring onto rx_ring
      ice: optimize XDP_TX workloads
      ice: introduce XDP_TX fallback path
      ice: make use of ice_for_each_* macros

Maciej Machnikowski (4):
      ice: Refactor ice_aqc_link_topo_addr
      ice: Implement functions for reading and setting GPIO pins
      ice: Add support for SMA control multiplexer
      ice: Implement support for SMA and U.FL on E810-T

Magnus Karlsson (35):
      selftests: xsk: Simplify xsk and umem arrays
      selftests: xsk: Introduce type for thread function
      selftests: xsk: Introduce test specifications
      selftests: xsk: Move num_frames and frame_headroom to xsk_umem_info
      selftests: xsk: Move rxqsize into xsk_socket_info
      selftests: xsk: Make frame_size configurable
      selftests: xsx: Introduce test name in test spec
      selftests: xsk: Add use_poll to ifobject
      selftests: xsk: Introduce rx_on and tx_on in ifobject
      selftests: xsk: Replace second_step global variable
      selftests: xsk: Specify number of sockets to create
      selftests: xsk: Make xdp_flags and bind_flags local
      selftests: xsx: Make pthreads local scope
      selftests: xsk: Eliminate MAX_SOCKS define
      selftests: xsk: Allow for invalid packets
      selftests: xsk: Introduce replacing the default packet stream
      selftests: xsk: Add test for unaligned mode
      selftests: xsk: Eliminate test specific if-statement in test runner
      selftests: xsk: Add tests for invalid xsk descriptors
      selftests: xsk: Add tests for 2K frame size
      xsk: Get rid of unused entry in struct xdp_buff_xsk
      xsk: Batched buffer allocation for the pool
      ice: Use xdp_buf instead of rx_buf for xsk zero-copy
      ice: Use the xsk batched rx allocation interface
      i40e: Use the xsk batched rx allocation interface
      xsk: Optimize for aligned case
      selftests: xsk: Fix missing initialization
      selftests: xsk: Put the same buffer only once in the fill ring
      selftests: xsk: Fix socket creation retry
      selftests: xsk: Introduce pacing of traffic
      selftests: xsk: Add single packet test
      selftests: xsk: Change interleaving of packets in unaligned mode
      selftests: xsk: Add frame_headroom test
      xsk: Fix clang build error in __xp_alloc
      libbpf: Deprecate AF_XDP support

Manish Chopra (1):
      qed: fix ll2 establishment during load of RDMA driver

Manish Mandlik (1):
      Bluetooth: Fix Advertisement Monitor Suspend/Resume

Maor Dickman (3):
      net/mlx5: E-Switch, Use dynamic alloc for dest array
      net/mlx5: E-Switch, Increase supported number of forward destinations to 32
      net/mlx5: Lag, Make mlx5_lag_is_multipath() be static inline

Maor Gottlieb (11):
      net/mlx5: Support partial TTC rules
      net/mlx5: Introduce port selection namespace
      net/mlx5: Add support to create match definer
      net/mlx5: Introduce new uplink destination type
      net/mlx5: Lag, move lag files into directory
      net/mlx5: Lag, set LAG traffic type mapping
      net/mlx5: Lag, set match mask according to the traffic type bitmap
      net/mlx5: Lag, add support to create definers for LAG
      net/mlx5: Lag, add support to create TTC tables for LAG port selection
      net/mlx5: Lag, add support to create/destroy/modify port selection
      net/mlx5: Lag, use steering to select the affinity port in LAG

Marc Kleine-Budde (2):
      can: bittiming: can_fixup_bittiming(): change type of tseg1 and alltseg to unsigned int
      can: gs_usb: use %u to print unsigned values

Marcel Holtmann (4):
      Bluetooth: Fix handling of experimental feature for quality reports
      Bluetooth: Fix handling of experimental feature for codec offload
      Bluetooth: btrtl: Set VsMsftOpCode based on device table
      Bluetooth: btrtl: Add support for MSFT extension to rtl8821c devices

Marcin Szycik (3):
      ice: Add support for changing MTU on PR in switchdev mode
      ice: Clear synchronized addrs when adding VFs in switchdev mode
      ice: Hide bus-info in ethtool for PRs in switchdev mode

Marek Behún (1):
      net: dsa: populate supported_interfaces member

Marek Vasut (1):
      rsi: Fix module dev_oper_mode parameter description

Martin Fuzzey (3):
      rsi: fix occasional initialisation failure with BT coex
      rsi: fix key enabled check causing unwanted encryption for vap_id > 0
      rsi: fix rate mask set leading to P2P failure

Martin KaFai Lau (4):
      bpf: Check the other end of slot_type for STACK_SPILL
      bpf: Support <8-byte scalar spill and refill
      bpf: selftest: A bpf prog that has a 32bit scalar spill
      bpf: selftest: Add verifier tests for <8-byte scalar spill and refill

Masahiro Yamada (2):
      net: ipv6: squash $(ipv6-offload) in Makefile
      net: ipv6: use ipv6-y directly instead of ipv6-objs

Mat Martineau (1):
      mptcp: Make mptcp_pm_nl_mp_prio_send_ack() static

Mateusz Palczewski (3):
      iavf: Refactor iavf state machine tracking
      iavf: Add __IAVF_INIT_FAILED state
      iavf: Combine init and watchdog state machines

Matt Johnston (4):
      mctp: Allow MCTP on tun devices
      mctp: Set route MTU via netlink
      mctp: Warn if pointer is set for a wrong dev type
      mctp: Avoid leak of mctp_sk_key

Matt Smith (3):
      libbpf: Change bpf_object_skeleton data field to const pointer
      bpftool: Provide a helper method for accessing skeleton's embedded ELF data
      selftests/bpf: Add checks for X__elf_bytes() skeleton helper

Matteo Croce (1):
      bpf: Update bpf_get_smp_processor_id() documentation

Matthew Hagan (1):
      dt-bindings: net: dsa: qca8k: convert to YAML schema

Matthias Schiffer (1):
      net: phy: micrel: make *-skew-ps check more lenient

Matti Gottlieb (3):
      iwlwifi: Add support for getting rf id with blank otp
      iwlwifi: Add support for more BZ HWs
      iwlwifi: Start scratch debug register for Bz family

Mauricio Vásquez (1):
      libbpf: Fix memory leak in btf__dedup()

Max Chou (1):
      Bluetooth: btusb: Add the new support ID for Realtek RTL8852A

Maxim Mikityanskiy (1):
      sch_htb: Add extack messages for EOPNOTSUPP errors

Maxime Chevallier (1):
      net: ipconfig: Release the rtnl_lock while waiting for carrier

MeiChia Chiu (1):
      mt76: mt7915: add LED support

Meir Lichtinger (2):
      net/mlx5: Add uid field to UAR allocation structures
      IB/mlx5: Enable UAR to have DevX UID

Mianhan Liu (13):
      net/ipv4/route.c: remove superfluous header files from route.c
      net/ipv4/tcp_fastopen.c: remove superfluous header files from tcp_fastopen.c
      net/ipv4/tcp_minisocks.c: remove superfluous header files from tcp_minisocks.c
      net/ipv4/udp_tunnel_core.c: remove superfluous header files from udp_tunnel_core.c
      net/ipv4/syncookies.c: remove superfluous header files from syncookies.c
      net/ipv4/sysctl_net_ipv4.c: remove superfluous header files from sysctl_net_ipv4.c
      net/ipv4/xfrm4_tunnel.c: remove superfluous header files from xfrm4_tunnel.c
      net/ipv4/tcp_nv.c: remove superfluous header files from tcp_nv.c
      Bluetooth: btrsi: remove superfluous header files from btrsi.c
      net: ipv4: remove superfluous header files from fib_notifier.c
      net/dsa/tag_8021q.c: remove superfluous headers
      net/dsa/tag_ksz.c: remove superfluous headers
      net/ipv4/datagram.c: remove superfluous header files from datagram.c

Miao-chen Chou (1):
      Bluetooth: Keep MSFT ext info throughout a hci_dev's life cycle

Michael Chan (2):
      bnxt_en: Update firmware interface to 1.10.2.63
      bnxt_en: Update bnxt.rst devlink documentation

Michal Simek (1):
      can: xilinx_can: remove repeated word from the kernel-doc

Michal Swiatkowski (12):
      ice: support basic E-Switch mode control
      ice: introduce VF port representor
      ice: allow process VF opcodes in different ways
      ice: manage VSI antispoof and destination override
      ice: allow changing lan_en and lb_en on dflt rules
      ice: Allow changing lan_en and lb_en on all kinds of filters
      ice: ndo_setup_tc implementation for PR
      ice: support for indirect notification
      ice: VXLAN and Geneve TC support
      ice: low level support for tunnels
      ice: support for GRE in eswitch
      ice: send correct vc status in switchdev

MichelleJin (4):
      net/mlx5e: check return value of rhashtable_init
      net: ipv6: check return value of rhashtable_init
      net: mac80211: check return value of rhashtable_init
      net: ipv6: fix use after free of struct seg6_pernet_data

Mike Golant (1):
      iwlwifi: pcie: update sw error interrupt for BZ family

Miles Hu (1):
      ath11k: add support for setting fixed HE rate/gi/ltf

Min Li (4):
      ptp: ptp_clockmatrix: Remove idtcm_enable_tod_sync()
      ptp: ptp_clockmatrix: Add support for FW 5.2 (8A34005)
      ptp: ptp_clockmatrix: Add support for pll_mode=0 and manual ref switch of WF and WP
      ptp: clockmatrix: use rsmu driver to access i2c/spi bus

Miri Korenblit (11):
      iwlwifi: mvm: Remove antenna c references
      iwlwifi: mvm: update definitions due to new rate & flags
      iwlwifi: mvm: add definitions for new rate & flags
      iwlwifi: mvm: convert old rate & flags to the new format.
      iwlwifi: mvm: Support version 3 of tlc_update_notif.
      iwlwifi: mvm: Support new version of ranging response notification
      iwlwifi: mvm: Add support for new rate_n_flags in tx_cmd.
      iwlwifi: mvm: Support new version of BEACON_TEMPLATE_CMD.
      iwlwifi: mvm: Support new TX_RSP and COMPRESSED_BA_RES versions
      iwlwifi: mvm: Add RTS and CTS flags to iwl_tx_cmd_flags.
      iwlwifi: mvm: Read acpi dsm to get channel activation bitmap

Moosa Baransi (1):
      net/mlx5i: Enable Rx steering for IPoIB via ethtool

Mordechay Goodstein (2):
      mac80211: debugfs: calculate free buffer size correctly
      iwlwifi: mvm: add lmac/umac PC info in case of error

Muhammad Sammar (1):
      net/mlx5: DR, Add check for unsupported fields in match param

Mukesh Sisodiya (2):
      iwlwifi: yoyo: fw debug config from context info and preset
      iwlwifi: yoyo: support for ROM usniffer

Nathan Chancellor (5):
      ptp: ocp: Avoid operator precedence warning in ptp_ocp_summary_show()
      net: ax88796c: Fix clang -Wimplicit-fallthrough in ax88796c_set_mac()
      net: ax88796c: Remove pointless check in ax88796c_open()
      ice: Fix clang -Wimplicit-fallthrough in ice_pull_qvec_from_rc()
      net/mlx5: Add esw assignment back in mlx5e_tc_sample_unoffload()

Nathan Errera (1):
      iwlwifi: rename CHANNEL_SWITCH_NOA_NOTIF to CHANNEL_SWITCH_START_NOTIF

Naveen Mamindlapalli (1):
      octeontx2-nicvf: Add PTP hardware clock support to NIX VF

Neil Spring (1):
      bpf: Permit ingress_ifindex in bpf_prog_test_run_xattr

Nicholas Flintham (1):
      Bluetooth: btusb: Add support for TP-Link UB500 Adapter

Nick Hainke (1):
      mt76: mt7615: mt7622: fix ibss and meshpoint

Nikolay Aleksandrov (1):
      selftests: net: bridge: update IGMP/MLD membership interval value

Nikolay Assa (1):
      qed: Update TCP silly-window-syndrome timeout for iwarp, scsi

Nithin Dabilpuram (1):
      octeontx2-af: Perform cpt lf teardown in non FLR path

Oliver Neukum (1):
      usbb: catc: use correct API for MAC addresses

Omkar Kulkarni (2):
      qed: Split huge qed_hsi.h header file
      qed: Update FW init functions to support FW 8.59.1.0

P Praneesh (2):
      ath11k: add support for 80P80 and 160 MHz bandwidth
      ath11k: Add wmi peer create conf event in wmi_tlv_event_id

Pablo Neira Ayuso (6):
      netfilter: nft_dynset: relax superfluous check on set updates
      af_packet: Introduce egress hook
      netfilter: conntrack: set on IPS_ASSURED if flows enters internal stream state
      netfilter: nft_meta: add NFT_META_IFTYPE
      netfilter: nf_tables: convert pktinfo->tprot_set to flags field
      netfilter: nft_payload: support for inner header matching / mangling

Paolo Abeni (10):
      mptcp: ensure tx skbs always have the MPTCP ext
      tcp: expose the tcp_mark_push() and tcp_skb_entail() helpers
      mptcp: stop relying on tcp_tx_skb_cache
      tcp: make tcp_build_frag() static
      mptcp: use lockdep_assert_held_once() instead of open-coding it
      mptcp: increase default max additional subflows to 2
      tcp: define macros for a couple reclaim thresholds
      net: introduce sk_forward_alloc_get()
      mptcp: allocate fwd memory separately on the rx and tx path
      selftests: mptcp: more stable simult_flows tests

Parav Pandit (2):
      net/mlx5: SF, Add SF trace points
      net/mlx5: SF_DEV Add SF device trace points

Paul Blakey (4):
      net/mlx5: CT: Fix missing cleanup of ct nat table on init failure
      net/mlx5: Remove unnecessary checks for slow path flag
      net/mlx5: CT: Remove warning of ignore_flow_level support for VFs
      net/mlx5: Allow skipping counter refresh on creation

Pavel Skripkin (1):
      Bluetooth: hci_uart: fix GPF in h5_recv

Pawan Gupta (1):
      bpf: Disallow unprivileged bpf by default

Petr Machata (25):
      selftests: net: fib_nexthops: Wait before checking reported idle time
      mlxsw: spectrum_qdisc: Pass extack to mlxsw_sp_qevent_entry_configure()
      mlxsw: spectrum_qdisc: Distinguish between ingress and egress triggers
      mlxsw: spectrum_qdisc: Track permissible actions per binding
      mlxsw: spectrum_qdisc: Offload RED qevent mark
      selftests: mlxsw: sch_red_core: Drop two unused variables
      selftests: mlxsw: RED: Add selftests for the mark qevent
      mlxsw: reg: Fix a typo in a group heading
      mlxsw: reg: Rename MLXSW_REG_PPCNT_TC_CONG_TC to _CNT
      mlxsw: reg: Add ecn_marked_tc to Per-TC Congestion Counters
      mlxsw: spectrum_qdisc: Introduce per-TC ECN counters
      selftests: mlxsw: RED: Test per-TC ECN counters
      net: sch_tbf: Add a graft command
      mlxsw: spectrum_qdisc: Query tclass / priomap instead of caching it
      mlxsw: spectrum_qdisc: Extract two helpers for handling future FIFOs
      mlxsw: spectrum_qdisc: Destroy children in mlxsw_sp_qdisc_destroy()
      mlxsw: spectrum_qdisc: Unify graft validation
      mlxsw: spectrum_qdisc: Clean stats recursively when priomap changes
      mlxsw: spectrum_qdisc: Validate qdisc topology
      mlxsw: spectrum_qdisc: Make RED, TBF offloads classful
      selftests: mlxsw: Add a test for un/offloadable qdisc trees
      selftests: mlxsw: Add helpers for skipping selftests
      mlxsw: spectrum_qdisc: Offload root TBF as port shaper
      selftests: mlxsw: Test offloadability of root TBF
      selftests: mlxsw: Test port shaper

Ping-Ke Shih (3):
      rtw89: add Realtek 802.11ax driver
      MAINTAINERS: add rtw89 wireless driver
      rtw89: Fix variable dereferenced before check 'sta'

Po-Hsu Lin (1):
      selftests/bpf: Use kselftest skip code for skipped tests

Prabhakar Kushwaha (9):
      qed: Fix kernel-doc warnings
      qed: Update common_hsi for FW ver 8.59.1.0
      qed: Update qed_mfw_hsi.h for FW ver 8.59.1.0
      qed: Update qed_hsi.h for fw 8.59.1.0
      qed: Use enum as per FW 8.59.1.0 in qed_iro_hsi.h
      qed: Add '_GTT' suffix to the IRO RAM macros
      qed: Update debug related changes
      qed: Update the TCP active termination 2 MSL timer ("TIME_WAIT")
      qed: Fix compilation for CONFIG_QED_SRIOV undefined scenario

Pradeep Kumar Chitrapu (6):
      ath11k: add channel 2 into 6 GHz channel list
      ath11k: fix packet drops due to incorrect 6 GHz freq value in rx status
      ath11k: fix survey dump collection in 6 GHz
      ieee80211: Add new A-MPDU factor macro for HE 6 GHz peer caps
      ath11k: add 6 GHz params in peer assoc command
      ath11k: support SMPS configuration for 6 GHz

Przemyslaw Patynowski (1):
      iavf: Fix kernel BUG in free_msi_irqs

Pu Lehui (1):
      samples: bpf: Suppress readelf stderr when probing for BTF support

Qing Wang (3):
      ath5k: replace snprintf in show functions with sysfs_emit
      net: bpf: Switch over to memdup_user()
      can: at91/janz-ican3: replace snprintf() in show functions with sysfs_emit()

Quentin Monnet (26):
      libbpf: Add LIBBPF_DEPRECATED_SINCE macro for scheduling API deprecations
      bpf: Use $(pound) instead of \# in Makefiles
      libbpf: Skip re-installing headers file if source is older than target
      bpftool: Remove unused includes to <bpf/bpf_gen_internal.h>
      bpftool: Install libbpf headers instead of including the dir
      tools/resolve_btfids: Install libbpf headers when building
      tools/runqslower: Install libbpf headers when building
      bpf: preload: Install libbpf headers when building
      bpf: iterators: Install libbpf headers when building
      samples/bpf: Update .gitignore
      samples/bpf: Install libbpf headers when building
      samples/bpf: Do not FORCE-recompile libbpf
      selftests/bpf: Better clean up for runqslower in test_bpftool_build.sh
      bpftool: Add install-bin target to install binary only
      libbpf: Remove Makefile warnings on out-of-sync netlink.h/if_link.h
      bpftool: Fix install for libbpf's internal header(s)
      bpftool: Do not FORCE-build libbpf
      bpftool: Turn check on zlib from a phony target into a conditional error
      bpf/preload: Clean up .gitignore and "clean-files" target
      bpftool: Remove useless #include to <perf-sys.h> from map_perf_ring.c
      bpftool: Avoid leaking the JSON writer prepared for program metadata
      bpftool: Remove Makefile dep. on $(LIBBPF) for $(LIBBPF_INTERNAL_HDRS)
      bpftool: Do not expose and init hash maps for pinned path in main.c
      bpftool: Switch to libbpf's hashmap for pinned paths of BPF objects
      bpftool: Switch to libbpf's hashmap for programs/maps in BTF listing
      bpftool: Switch to libbpf's hashmap for PIDs/names references

Raed Salem (1):
      net/mlx5e: IPsec: Refactor checksum code in tx data path

Rafael David Tinoco (1):
      libbpf: Introduce legacy kprobe events support

Rafał Miłecki (6):
      net: dsa: b53: Include all ports in "enabled_ports"
      net: dsa: b53: Drop BCM5301x workaround for a wrong CPU/IMP port
      net: dsa: b53: Improve flow control setup on BCM5301x
      net: dsa: b53: Drop unused "cpu_port" field
      net: bgmac: improve handling PHY
      net: bgmac: support MDIO described in DT

Rakesh Babu (2):
      octeontx2-pf: Enable promisc/allmulti match MCAM entries.
      octeontx2-af: debugfs: Add channel and channel mask.

Rakesh Babu Saladi (1):
      octeontx2-af: debugfs: Minor changes.

Ramon Fontes (1):
      mac80211_hwsim: enable 6GHz channels

Randy Dunlap (4):
      net: fealnx: fix build for UML
      net: intel: igc_ptp: fix build for UML
      net: tulip: winbond-840: fix build for UML
      mt76: mt7921: fix Wformat build warning

Richard Huynh (1):
      mt76: mt76x0: correct VHT MCS 8/9 tx power eeprom offset

Richard Palethorpe (2):
      vsock: Refactor vsock_*_getsockopt to resemble sock_getsockopt
      vsock: Enable y2038 safe timeval for timeout

Rikard Falkeborn (2):
      nfc: pn533: Constify serdev_device_ops
      nfc: pn533: Constify pn533_phy_ops

Robert Hancock (1):
      net: phylink: Support disabling autonegotiation for PCS

Roee Goldfiner (2):
      iwlwifi: BZ Family BUS_MASTER_DISABLE_REQ code duplication
      iwlwifi: BZ Family SW reset support

Roi Dayan (12):
      net/mlx5e: Use correct return type
      net/mlx5e: Remove incorrect addition of action fwd flag
      net/mlx5e: Set action fwd flag when parsing tc action goto
      net/mlx5e: Check action fwd/drop flag exists also for nic flows
      net/mlx5e: Remove redundant priv arg from parse_pedit_to_reformat()
      net/mlx5e: Use tc sample stubs instead of ifdefs in source file
      net/mlx5e: Use NL_SET_ERR_MSG_MOD() for errors parsing tunnel attributes
      net/mlx5e: loopback test is not supported in switchdev mode
      net/mlx5e: TC, Refactor sample offload error flow
      net/mlx5e: Move mod hdr allocation to a single place
      net/mlx5e: Split actions_match_supported() into a sub function
      net/mlx5e: Move parse fdb check into actions_match_supported_fdb()

Rongwei Liu (4):
      net/mlx5: Check return status first when querying system_image_guid
      net/mlx5: Introduce new device index wrapper
      net/mlx5: Use native_port_num as 1st option of device index
      net/mlx5: Use system_image_guid to determine bonding

Roopa Prabhu (1):
      net, neigh: Extend neigh->flags to 32 bit to allow for extensions

Rotem Saado (2):
      iwlwifi: dbg: treat dbgc allocation failure when tlv is missing
      iwlwifi: dbg: treat non active regions as unsupported regions

Russell King (5):
      net: dpaa2-mac: add support for more ethtool 10G link modes
      net: phy: marvell10g: add downshift tunable support
      net: phylink: add MAC phy_interface_t bitmap
      net: mvneta: populate supported_interfaces member
      net: mvpp2: populate supported_interfaces member

Russell King (Oracle) (16):
      net: phylink: don't call netif_carrier_off() with NULL netdev
      net: phylink: add phylink_set_10g_modes() helper
      net: ethernet: use phylink_set_10g_modes()
      net: mdio: add mdiobus_modify_changed()
      net: phylink: use mdiobus_modify_changed() helper
      net: mdio: ensure the type of mdio devices match mdio drivers
      net: phylib: ensure phy device drivers do not match by DT
      net: phylink: rejig SFP interface selection in ksettings_set()
      net: phy: add phy_interface_t bitmap support
      net: phylink: use supported_interfaces for phylink validation
      net: mvneta: remove interface checks in mvneta_validate()
      net: mvneta: drop use of phylink_helper_basex_speed()
      net: mvpp2: remove interface checks in mvpp2_phylink_validate()
      net: mvpp2: drop use of phylink_helper_basex_speed()
      net: mvpp2: clean up mvpp2_phylink_validate()
      net: phylink: avoid mvneta warning when setting pause parameters

Ryder Lee (27):
      MAINTAINERS: mt76: update MTK folks
      mt76: mt7915: report HE MU radiotap
      mt76: mt7915: fix an off-by-one bound check
      mt76: mt7915: take RCU read lock when calling ieee80211_bss_get_elem()
      mt76: mt7915: cleanup -Wunused-but-set-variable
      mt76: mt7915: report tx rate directly from tx status
      mt76: mt7915: remove mt7915_sta_stats
      mt76: mt7915: add control knobs for thermal throttling
      mt76: mt7915: send EAPOL frames at lowest rate
      mt76: mt7921: send EAPOL frames at lowest rate
      mt76: add support for setting mcast rate
      mt76: mt7915: add HE-LTF into fixed rate command
      mt76: mt7915: update mac timing settings
      mt76: use IEEE80211_OFFLOAD_ENCAP_ENABLED instead of MT_DRV_AMSDU_OFFLOAD
      mt76: mt7915: rework debugfs queue info
      mt76: mt7915: rename debugfs tx-queues
      mt76: fill boottime_ns in Rx path
      mt76: mt7915: enable configured beacon tx rate
      mt76: mt7615: fix hwmon temp sensor mem use-after-free
      mt76: mt7615: fix monitor mode tear down crash
      mt76: mt7915: introduce mt7915_mcu_beacon_check_caps()
      mt76: mt7915: fix txbf starec TLV issues
      mt76: mt7915: improve starec readability of txbf
      mt76: mt7615: apply cached RF data for DBDC
      mt76: mt7915: remove mt7915_mcu_add_he()
      mt76: mt7915: rework .set_bitrate_mask() to support more options
      mt76: mt7915: rework debugfs fixed-rate knob

Saeed Mahameed (1):
      Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux into net-next

Sara Sharon (1):
      iwlwifi: mvm: set inactivity timeouts also for PS-poll

Sasha Neftin (3):
      igc: Remove media type checking on the PHY initialization
      igc: Add new device ID
      igc: Change Device Reset to Port Reset

Sathishkumar Muruganandam (1):
      ath11k: fix 4-addr tx failure for AP and STA modes

Sean Anderson (6):
      net: mdio: Add helper functions for accessing MDIO devices
      net: phylink: Convert some users of mdiobus_* to mdiodev_*
      net: Convert more users of mdiobus_* to mdiodev_*
      dt-bindings: net: macb: Add mdio bus child node
      net: macb: Use mdio child node for MDIO bus if it exists
      net: convert users of bitmap_foo() to linkmode_foo()

Sean Wang (27):
      mt76: mt7921: enable aspm by default
      mt76: fix build error implicit enumeration conversion
      mt76: add mt76_default_basic_rate more devices can rely on
      mt76: mt7921: fix mgmt frame using unexpected bitrate
      mt76: mt7915: fix mgmt frame using unexpected bitrate
      mt76: mt7921: report HE MU radiotap
      mt76: mt7921: fix firmware usage of RA info using legacy rates
      mt76: mt7921: fix kernel warning from cfg80211_calculate_bitrate
      mt76: mt7921: robustify hardware initialization flow
      mt76: mt7921: fix retrying release semaphore without end
      mt76: drop MCU header size from buffer size in __mt76_mcu_send_firmware
      mt76: mt7921: add MU EDCA cmd support
      mt76: mt7921: refactor mac.c to be bus independent
      mt76: mt7921: refactor dma.c to be pcie specific
      mt76: mt7921: refactor mcu.c to be bus independent
      mt76: mt7921: refactor init.c to be bus independent
      mt76: mt7921: add MT7921_COMMON module
      mt76: connac: move mcu reg access utility routines in mt76_connac_lib module
      mt76: mt7663s: rely on mcu reg access utility
      mt76: mt7921: make all event parser reusable between mt7921s and mt7921e
      mt76: mt7921: use physical addr to unify register access
      mt76: sdio: extend sdio module to support CONNAC2
      mt76: connac: extend mcu_get_nic_capability
      mt76: mt7921: rely on mcu_get_nic_capability
      mt76: mt7921: refactor mt7921_mcu_send_message
      mt76: mt7921: introduce mt7921s support
      mt76: mt7921s: add reset support

Sebastian Andrzej Siewior (7):
      net/core: disable NET_RX_BUSY_POLL on PREEMPT_RT
      gen_stats: Add instead Set the value in __gnet_stats_copy_basic().
      gen_stats: Add gnet_stats_add_queue().
      mq, mqprio: Use gnet_stats_add_queue().
      gen_stats: Move remaining users to gnet_stats_add_queue().
      net: sched: Allow statistics reads from softirq.
      net: stats: Read the statistics in ___gnet_stats_copy_basic() instead of adding.

Seevalamuthu Mariappan (12):
      ath11k: Rename atf_config to flag1 in target_resource_config
      ath11k: add support in survey dump with bss_chan_info
      ath11k: Align bss_chan_info structure with firmware
      ath11k: move static function ath11k_mac_vdev_setup_sync to top
      ath11k: add separate APIs for monitor mode
      ath11k: monitor mode clean up to use separate APIs
      ath11k: Add vdev start flag to disable hardware encryption
      ath11k: Assign free_vdev_map value before ieee80211_register_hw
      ath11k: Rename macro ARRAY_TO_STRING to PRINT_ARRAY_TO_BUF
      ath11k: Replace HTT_DBG_OUT with scnprintf
      ath11k: Remove htt stats fixed size array usage
      ath11k: Change masking and shifting in htt stats

Seth Forshee (2):
      net: sch: eliminate unnecessary RCU waits in mini_qdisc_pair_swap()
      net: sch: simplify condtion for selecting mini_Qdisc_pair buffer

Shai Malin (4):
      qed: Improve the stack space of filter_config()
      qed: Remove e4_ and _e4 from FW HSI
      qed: Optimize the ll2 ooo flow
      qed: Change the TCP common variable - "iscsi_ooo"

Shailend Chand (1):
      gve: Add a jumbo-frame device option.

Shannon Nelson (17):
      ionic: remove debug stats
      ionic: check for binary values in FW ver string
      ionic: move lif mutex setup and delete
      ionic: widen queue_lock use around lif init and deinit
      ionic: add polling to adminq wait
      ionic: have ionic_qcq_disable decide on sending to hardware
      ionic: add lif param to ionic_qcq_disable
      ionic: add filterlist to debugfs
      ionic: move lif mac address functions
      ionic: remove mac overflow flags
      ionic: add generic filter search
      ionic: generic filter add
      ionic: generic filter delete
      ionic: handle vlan id overflow
      ionic: allow adminq requests to override default error message
      ionic: tame the filter no space message
      ionic: no devlink_unregister if not registered

Shay Drory (7):
      net/mlx5: Shift control IRQ to the last index
      net/mlx5: Enable single IRQ for PCI Function
      net/mlx5: Disable roce at HCA level
      net/mlx5: Fix unused function warning of mlx5i_flow_type_mask
      net/mlx5: Let user configure io_eq_size param
      net/mlx5: Let user configure event_eq_size param
      net/mlx5: Let user configure max_macs param

Shayne Chen (14):
      mt76: mt7915: fix potential overflow of eeprom page index
      mt76: mt7915: switch proper tx arbiter mode in testmode
      mt76: mt7915: fix bit fields for HT rate idx
      mt76: mt7915: fix sta_rec_wtbl tag len
      mt76: mt7915: rework starec TLV tags
      mt76: mt7915: fix muar_idx in mt7915_mcu_alloc_sta_req()
      mt76: mt7915: set VTA bit in tx descriptor
      mt76: mt7915: set muru platform type
      mt76: mt7915: enable HE UL MU-MIMO
      mt76: mt7915: rework mt7915_mcu_sta_muru_tlv()
      mt76: mt7915: fix missing HE phy cap
      mt76: mt7915: change max rx len limit of hw modules
      mt76: mt7915: add WA firmware log support
      mt76: mt7915: add debugfs knobs for MCU utilization

Shivanshu Shukla (1):
      ice: allow deleting advanced rules

Shuah Khan (1):
      selftests/net: update .gitignore with newly added tests

Shyam Sundar S K (1):
      net: amd-xgbe: Toggle PLL settings during rate change

Sohaib Mohamed (1):
      bcma: drop unneeded initialization value

Song Liu (6):
      perf: Enable branch record for software events
      bpf: Introduce helper bpf_get_branch_snapshot
      selftests/bpf: Add test for bpf_get_branch_snapshot
      selftests/bpf: Skip the second half of get_branch_snapshot in vm
      selftests/bpf: Skip all serial_test_get_branch_snapshot in vm
      selftests/bpf: Guess function end for test_get_branch_snapshot

Srinivasan Raju (1):
      nl80211: Add LC placeholder band definition to nl80211_band

Sriram R (5):
      ath11k: Add support for RX decapsulation offload
      ath11k: Update pdev tx and rx firmware stats
      ath11k: Avoid reg rules update during firmware recovery
      ath11k: Avoid race during regd updates
      ath11k: Fix crash during firmware recovery on reo cmd ring access

Srujana Challa (3):
      octeontx2-af: Hardware configuration for inline IPsec
      octeontx2-af: Enable CPT HW interrupts
      octeontx2-af: Add support to flush full CPT CTX cache

Stanislav Fomichev (2):
      libbpf: Use func name when pinning programs with LIBBPF_STRICT_SEC_NAME
      selftests/bpf: Fix flow dissector tests

Stefan Agner (1):
      phy: micrel: ksz8041nl: do not use power down mode

Stephane Grosjean (1):
      can: peak_usb: CANFD: store 64-bits hw timestamps

Stephen Boyd (1):
      ath10k: Don't always treat modem stop events as crashes

Stephen Rothwell (3):
      fix up for "net: add new socket option SO_RESERVE_MEM"
      ethernet: fix up ps3_gelic_net.c for "ethernet: use  eth_hw_addr_set()"
      ethernet: sun: add missing semicolon, fix build

Stephen Suryaputra (1):
      gre/sit: Don't generate link-local addr if addr_gen_mode is IN6_ADDR_GEN_MODE_NONE

Subbaraya Sundeep (3):
      octeontx2-af: Use ptp input clock info from firmware data
      octeontx2-pf: Simplify the receive buffer size calculation
      devlink: add documentation for octeontx2 driver

Subrat Mishra (1):
      cfg80211: AP mode driver offload for FILS association crypto

Sukadev Bhattiprolu (12):
      ibmvnic: Consolidate code in replenish_rx_pool()
      ibmvnic: Fix up some comments and messages
      ibmvnic: Use/rename local vars in init_rx_pools
      ibmvnic: Use/rename local vars in init_tx_pools
      ibmvnic: init_tx_pools move loop-invariant code
      ibmvnic: Use bitmap for LTB map_ids
      ibmvnic: Reuse LTB when possible
      ibmvnic: Reuse rx pools when possible
      ibmvnic: Reuse tx pools when possible
      ibmvnic: don't stop queue in xmit
      ibmvnic: Process crqs after enabling interrupts
      ibmvnic: delay complete()

Sven Eckelmann (1):
      ath10k: fix max antenna gain unit

Taehee Yoo (5):
      amt: add control plane of amt interface
      amt: add data plane of amt interface
      amt: add multicast(IGMP) report message handler
      amt: add mld report message handler
      selftests: add amt interface selftest script

Takashi Iwai (1):
      Bluetooth: sco: Fix lock_sock() blockage by memcpy_from_msg()

Talal Ahmad (2):
      tcp: rename sk_wmem_free_skb
      net: avoid double accounting for pure zerocopy skbs

Tao Liu (1):
      gve: Do lazy cleanup in TX path

Tariq Toukan (3):
      net/mlx5e: Specify SQ stats struct for mlx5e_open_txqsq()
      net/mlx5e: Add TX max rate support for MQPRIO channel mode
      lib: bitmap: Introduce node-aware alloc API

Tetsuo Handa (1):
      Bluetooth: reorganize functions from hci_sock_sendmsg()

Thadeu Lima de Souza Cascardo (1):
      Bluetooth: hci_ldisc: require CAP_NET_ADMIN to attach N_HCI ldisc

Thomas Gleixner (2):
      net: iosm: Use hrtimer_forward_now()
      can: bcm: Use hrtimer_forward_now()

Tianjia Zhang (5):
      net/tls: support SM4 GCM/CCM algorithm
      net/tls: support SM4 CCM algorithm
      selftests/tls: add SM4 GCM/CCM to tls selftests
      net/tls: tls_crypto_context add supported algorithms context
      net/tls: getsockopt supports complete algorithm list

Tiezhu Yang (3):
      bpf, mips: Clean up config options about JIT
      bpf, mips: Fix comment on tail call count limiting
      bpf, tests: Add module parameter test_suite to test_bpf module

Tim Gardner (5):
      ath11k: Remove unused variable in ath11k_dp_rx_mon_merg_msdus()
      qed: Initialize debug string array
      mptcp: Avoid NULL dereference in mptcp_getsockopt_subflow_addrs()
      soc: fsl: dpio: Unsigned compared against 0 in qbman_swp_set_irq_coalescing()
      net: enetc: unmap DMA in enetc_send_cmd()

Toke Høiland-Jørgensen (4):
      libbpf: Don't crash on object files with no symbol tables
      libbpf: Ignore STT_SECTION symbols in 'maps' section
      libbpf: Properly ignore STT_SECTION symbols in legacy map definitions
      fq_codel: generalise ce_threshold marking for subset of traffic

Tong Tiangen (1):
      riscv, bpf: Add BPF exception tables

Tony Ambardar (1):
      mips, uasm: Enable muhu opcode for MIPS R6

Tony Lu (4):
      virtio_net: introduce TX timeout watchdog
      net/smc: Introduce tracepoint for fallback
      net/smc: Introduce tracepoints for tx and rx msg
      net/smc: Introduce tracepoint for smcr link down

Tuo Li (1):
      ath: dfs_pattern_detector: Fix possible null-pointer dereference in channel_detector_create()

Uwe Kleine-König (2):
      net: ks8851: Make ks8851_remove_common() return void
      net: w5100: Make w5100_remove() return void

Vadim Fedorenko (2):
      bpf: Add hardware timestamp field to __sk_buff
      selftests/bpf: Test new __sk_buff field hwtstamp

Vasundhara Volam (2):
      bnxt_en: Add compression flags information in coredump segment header
      bnxt_en: Retrieve coredump and crashdump size via FW command

Venkateswara Naralasetty (1):
      ath11k: add HTT stats support for new stats

Victor Raj (1):
      ice: cleanup rules info

Vikas Gupta (1):
      bnxt_en: Provide stored devlink "fw" version on older firmware

Vincent Mailhol (6):
      can: bittiming: allow TDC{V,O} to be zero and add can_tdc_const::tdc{v,o,f}_min
      can: bittiming: change unit of TDC parameters to clock periods
      can: bittiming: change can_calc_tdco()'s prototype to not directly modify priv
      can: netlink: add interface for CAN-FD Transmitter Delay Compensation (TDC)
      can: netlink: add can_priv::do_get_auto_tdcv() to retrieve tdcv from device
      can: dev: add can_tdc_get_relative_tdco() helper function

Vlad Buslov (9):
      net/mlx5e: Reserve a value from TC tunnel options mapping
      net/mlx5e: Support accept action
      net/mlx5: Bridge, refactor eswitch instance usage
      net/mlx5: Bridge, extract VLAN pop code to dedicated functions
      net/mlx5: Bridge, mark reg_c1 when pushing VLAN
      net/mlx5: Bridge, pop VLAN on egress table miss
      net/mlx5: Bridge, provide flow source hints
      net/mlx5: Bridge, extract code to lookup and del/notify entry
      net/mlx5: Bridge, support replacing existing FDB entry

Vladimir Oltean (68):
      net: dsa: sja1105: remove sp->dp
      net: dsa: move sja1110_process_meta_tstamp inside the tagging protocol driver
      net: dsa: sja1105: break dependency between dsa_port_is_sja1105 and switch driver
      net: dsa: sja1105: don't keep a persistent reference to the reset GPIO
      net: dsa: sja1105: stop using priv->vlan_aware
      net: dsa: felix: accept "ethernet-ports" OF node name
      net: mscc: ocelot: support egress VLAN rewriting via VCAP ES0
      net: mscc: ocelot: write full VLAN TCI in the injection header
      net: dsa: tag_ocelot: set the classified VLAN during xmit
      selftests: net: mscc: ocelot: bring up the ports automatically
      selftests: net: mscc: ocelot: rename the VLAN modification test to ingress
      selftests: net: mscc: ocelot: add a test for egress VLAN modification
      dt-bindings: net: dsa: fix typo in dsa-tag-protocol description
      dt-bindings: net: dsa: document felix family in dsa-tag-protocol
      net: dsa: unregister cross-chip notifier after ds->ops->teardown
      dt-bindings: net: dsa: sja1105: fix example so all ports have a phy-handle of fixed-link
      dt-bindings: net: dsa: inherit the ethernet-controller DT schema
      dt-bindings: net: dsa: sja1105: add {rx,tx}-internal-delay-ps
      net: dsa: sja1105: parse {rx, tx}-internal-delay-ps properties for RGMII delays
      net: mscc: ocelot: add a type definition for REW_TAG_CFG_TAG_CFG
      net: mscc: ocelot: convert the VLAN masks to a list
      net: mscc: ocelot: allow a config where all bridge VLANs are egress-untagged
      net: mscc: ocelot: add the local station MAC addresses in VID 0
      net: mscc: ocelot: track the port pvid using a pointer
      net: dsa: introduce helpers for iterating through ports using dp
      net: dsa: remove the "dsa_to_port in a loop" antipattern from the core
      net: dsa: do not open-code dsa_switch_for_each_port
      net: dsa: remove gratuitous use of dsa_is_{user,dsa,cpu}_port
      net: dsa: convert cross-chip notifiers to iterate using dp
      net: dsa: tag_sja1105: do not open-code dsa_switch_for_each_port
      net: dsa: tag_8021q: make dsa_8021q_{rx,tx}_vid take dp as argument
      net: enetc: remove local "priv" variable in enetc_clean_tx_ring()
      net: enetc: use the skb variable directly in enetc_clean_tx_ring()
      net: dsa: sja1105: wait for dynamic config command completion on writes too
      net: dsa: sja1105: serialize access to the dynamic config interface
      net: mscc: ocelot: serialize access to the MAC table
      net: dsa: b53: serialize access to the ARL table
      net: dsa: lantiq_gswip: serialize access to the PCE table
      net: dsa: introduce locking for the address lists on CPU and DSA ports
      net: dsa: drop rtnl_lock from dsa_slave_switchdev_event_work
      selftests: lib: forwarding: allow tests to not require mz and jq
      selftests: net: dsa: add a stress test for unlocked FDB operations
      net: dsa: avoid refcount warnings when ->port_{fdb,mdb}_del returns error
      net: dsa: sja1105: wait for dynamic config command completion on writes too
      net: dsa: sja1105: serialize access to the dynamic config interface
      net: mscc: ocelot: serialize access to the MAC table
      net: dsa: b53: serialize access to the ARL table
      net: dsa: lantiq_gswip: serialize access to the PCE registers
      net: dsa: introduce locking for the address lists on CPU and DSA ports
      net: dsa: drop rtnl_lock from dsa_slave_switchdev_event_work
      selftests: lib: forwarding: allow tests to not require mz and jq
      selftests: net: dsa: add a stress test for unlocked FDB operations
      net: dsa: flush switchdev workqueue when leaving the bridge
      net: dsa: stop calling dev_hold in dsa_slave_fdb_event
      net: bridge: remove fdb_notify forward declaration
      net: bridge: remove fdb_insert forward declaration
      net: bridge: rename fdb_insert to fdb_add_local
      net: bridge: rename br_fdb_insert to br_fdb_add_local
      net: bridge: reduce indentation level in fdb_create
      net: bridge: move br_fdb_replay inside br_switchdev.c
      net: bridge: create a common function for populating switchdev FDB entries
      net: switchdev: merge switchdev_handle_fdb_{add,del}_to_device
      net: bridge: provide shim definition for br_vlan_flags
      net: bridge: move br_vlan_replay to br_switchdev.c
      net: bridge: split out the switchdev portion of br_mdb_notify
      net: bridge: mdb: move all switchdev logic to br_switchdev.c
      net: bridge: switchdev: consistent function naming
      net: bridge: switchdev: fix shim definition for br_switchdev_mdb_notify

Volodymyr Mytnyk (1):
      net: marvell: prestera: add firmware v4.0 support

Wan Jiabing (2):
      selftests/bpf: Remove duplicated include in cgroup_helpers
      net: dsa: sja1105: Add of_node_put() before return

Wang Hai (3):
      libertas_tf: Fix possible memory leak in probe and disconnect
      libertas: Fix possible memory leak in probe and disconnect
      ice: fix error return code in ice_get_recp_frm_fw()

Wang ShaoBo (1):
      Bluetooth: fix use-after-free error in lock_sock_nested()

Wei Wang (3):
      net: add new socket option SO_RESERVE_MEM
      tcp: adjust sndbuf according to sk_reserved_mem
      tcp: adjust rcv_ssthresh according to sk_reserved_mem

Weihang Li (1):
      net: hns3: add new ras error type for roce

Wen Gong (11):
      mac80211: use ieee802_11_parse_elems() in ieee80211_prep_channel()
      ieee80211: add power type definition for 6 GHz
      mac80211: add parse regulatory info in 6 GHz operation information
      mac80211: save transmit power envelope element and power constraint
      ath11k: re-enable ht_cap/vht_cap for 5G band for WCN6855
      ath11k: enable 6G channels for WCN6855
      ath11k: copy cap info of 6G band under WMI_HOST_WLAN_5G_CAP for WCN6855
      ath11k: add handler for scan event WMI_SCAN_EVENT_DEQUEUED
      ath11k: indicate scan complete for scan canceled when scan running
      ath11k: indicate to mac80211 scan complete with aborted flag for ATH11K_SCAN_STARTING state
      cfg80211: separate get channel number from ies

Wojciech Drewek (5):
      ice: Move devlink port to PF/VF struct
      ice: add port representor ethtool ops and stats
      ice: Forbid trusted VFs in switchdev mode
      ice: Manage act flags for switchdev offloads
      ice: Refactor PR ethtool ops

Xin Long (4):
      sctp: allow IP fragmentation when PLPMTUD enters Error state
      sctp: reset probe_timer in sctp_transport_pl_update
      sctp: subtract sctphdr len in sctp_transport_pl_hlen
      sctp: return true only for pathmtu update in sctp_transport_pl_toobig

Xing Song (1):
      mt76: use a separate CCMP PN receive counter for management frames

Xingbang Liu (1):
      mt76: move spin_lock_bh to spin_lock in tasklet

Xuan Zhuo (1):
      virtio_net: use netdev_warn_once to output warn when without enough queues

YN Chen (2):
      mt76: mt7921: add .set_sar_specs support
      mt76: connac: add support for limiting to maximum regulatory Tx power

Yaara Baruch (4):
      iwlwifi: change all JnP to NO-160 configuration
      iwlwifi: add new killer devices to the driver
      iwlwifi: add new device id 7F70
      iwlwifi: add new pci SoF with JF

Yajun Deng (4):
      skbuff: inline page_frag_alloc_align()
      net: net_namespace: Fix undefined member in key_remove_domain()
      net: rtnetlink: convert rcu_assign_pointer to RCU_INIT_POINTER
      xdp: Remove redundant warning

Yang Li (4):
      net: sparx5: fix resource_size.cocci warnings
      net: dsa: rtl8366rb: remove unneeded semicolon
      rtw89: remove unneeded semicolon
      intel: Simplify bool conversion

Yang Yingliang (1):
      rtw89: fix return value check in rtw89_cam_send_sec_key_cmd()

Yangchun Fu (1):
      gve: Switch to use napi_complete_done

Ye Guojin (1):
      libertas: replace snprintf in show functions with sysfs_emit

Yevgeny Kliteynik (11):
      net/mlx5: DR, Fix code indentation in dr_ste_v1
      net/mlx5: DR, Fix vport number data type to u16
      net/mlx5: DR, Replace local WIRE_PORT macro with the existing MLX5_VPORT_UPLINK
      net/mlx5: DR, Add missing query for vport 0
      net/mlx5: DR, Align error messages for failure to obtain vport caps
      net/mlx5: DR, Support csum recalculation flow table on SFs
      net/mlx5: DR, Add support for SF vports
      net/mlx5: DR, Increase supported num of actions to 32
      net/mlx5: DR, Fix typo 'offeset' to 'offset'
      net/mlx5: DR, init_next_match only if needed
      net/mlx5: DR, Add missing string for action type SAMPLER

Yi Guo (1):
      octeontx2-af: Add external ptp input clock

Yinjun Zhang (2):
      nfp: fix NULL pointer access when scheduling dim work
      nfp: fix potential deadlock when canceling dim work

Yonghong Song (21):
      btf: Change BTF_KIND_* macros to enums
      bpf: Support for new btf kind BTF_KIND_TAG
      libbpf: Rename btf_{hash,equal}_int to btf_{hash,equal}_int_tag
      libbpf: Add support for BTF_KIND_TAG
      bpftool: Add support for BTF_KIND_TAG
      selftests/bpf: Test libbpf API function btf__add_tag()
      selftests/bpf: Change NAME_NTH/IS_NAME_NTH for BTF_KIND_TAG format
      selftests/bpf: Add BTF_KIND_TAG unit tests
      selftests/bpf: Test BTF_KIND_TAG for deduplication
      selftests/bpf: Add a test with a bpf program with btf_tag attributes
      docs/bpf: Add documentation for BTF_KIND_TAG
      selftests/bpf: Skip btf_tag test if btf_tag attribute not supported
      selftests/bpf: Fix a few compiler warnings
      selftests/bpf: Fix btf_dump __int128 test failure with clang build kernel
      selftests/bpf: Fix probe_user test failure with clang build kernel
      bpf: Rename BTF_KIND_TAG to BTF_KIND_DECL_TAG
      bpf: Add BTF_KIND_DECL_TAG typedef support
      selftests/bpf: Add BTF_KIND_DECL_TAG typedef unit tests
      selftests/bpf: Test deduplication for BTF_KIND_DECL_TAG typedef
      selftests/bpf: Add BTF_KIND_DECL_TAG typedef example in tag.c
      docs/bpf: Update documentation for BTF_KIND_DECL_TAG typedef support

Yoshiki Komachi (1):
      cls_flower: Fix inability to match GRE/IPIP packets

Yu Xiao (1):
      nfp: flower: Allow ipv6gretap interface for offloading

Yuchung Cheng (1):
      tcp: tracking packets with CE marks in BW rate sample

Yucong Sun (13):
      bpftool: Avoid using "?: " in generated code
      selftests/bpf: Fix btf_dump test under new clang
      selftests/bpf: Add parallelism to test_progs
      selftests/bpf: Allow some tests to be executed in sequence
      selftests/bpf: Add per worker cgroup suffix
      selftests/bpf: Fix race condition in enable_stats
      selftests/bpf: Make cgroup_v1v2 use its own port
      selftests/bpf: Adding pid filtering for atomics test
      selftests/bpf: Fix pid check in fexit_sleep test
      selfetest/bpf: Make some tests serial
      selfetests/bpf: Update vmtest.sh defaults
      selftests/bpf: Fix attach_probe in parallel mode
      selftests/bpf: Adding a namespace reset for tc_redirect

Yuiko Oshino (3):
      net: microchip: lan743x: add support for PTP pulse width (duty cycle)
      net: phy: microchip_t1: add cable test support for lan87xx phy
      net: ethernet: microchip: lan743x: Increase rx ring size to improve rx performance

Yun-Hao Chung (1):
      Bluetooth: Fix wrong opcode when LL privacy enabled

Yunsheng Lin (1):
      page_pool: disable dma mapping support for 32-bit arch with 64-bit DMA

Yuval Shaia (1):
      net: mvneta: Delete unused variable

Zheyu Ma (1):
      mwl8k: Fix use-after-free in mwl8k_fw_state_machine()

Ziyang Xuan (1):
      rsi: stop thread firstly in rsi_91x_init() error handling

Zong-Zhe Yang (5):
      rtw88: upgrade rtw_regulatory mechanism and mapping
      rtw88: add regulatory strategy by chip type
      rtw88: support adaptivity for ETSI/JP DFS region
      rtw88: fix RX clock gate setting while fifo dump
      rtw88: refine fw_crash debugfs to show non-zero while triggering

jing yangyang (1):
      mt76: fix boolreturn.cocci warnings

luo penghao (5):
      e1000e: Remove redundant statement
      ethernet: Remove redundant statement
      net/core: Remove unused assignment operations and variable
      xfrm: Remove redundant fields and related parentheses
      sky2: Remove redundant assignment and parentheses

mark-yw.chen (3):
      Bluetooth: btusb: Support public address configuration for MediaTek Chip.
      Bluetooth: btusb: Add protocol for MediaTek bluetooth devices(MT7922)
      Bluetooth: btusb: Add support for IMC Networks Mediatek Chip(MT7921)

tjiang@codeaurora.org (1):
      Bluetooth: btusb: Add gpio reset way for qca btsoc in cmd_timeout

wangzhitong (1):
      NET: IPV4: fix error "do not initialise globals to 0"

Łukasz Stelmach (3):
      dt-bindings: vendor-prefixes: Add asix prefix
      dt-bindings: net: Add bindings for AX88796C SPI Ethernet Adapter
      net: ax88796c: ASIX AX88796C SPI Ethernet Adapter Driver

 Documentation/ABI/testing/sysfs-timecard           |   174 +
 Documentation/bpf/bpf_licensing.rst                |    92 +
 Documentation/bpf/btf.rst                          |    29 +-
 Documentation/bpf/index.rst                        |     9 +
 .../bpf/libbpf/libbpf_naming_convention.rst        |    40 +
 .../devicetree/bindings/net/asix,ax88796c.yaml     |    73 +
 .../devicetree/bindings/net/brcm,bcmgenet.txt      |     3 +-
 Documentation/devicetree/bindings/net/dsa/dsa.yaml |    12 +-
 .../devicetree/bindings/net/dsa/nxp,sja1105.yaml   |    43 +
 .../devicetree/bindings/net/dsa/qca8k.txt          |   215 -
 .../devicetree/bindings/net/dsa/qca8k.yaml         |   362 +
 .../devicetree/bindings/net/dsa/realtek-smi.txt    |    87 +
 .../devicetree/bindings/net/lantiq,etop-xway.yaml  |    69 +
 .../devicetree/bindings/net/lantiq,xrx200-net.txt  |    21 -
 .../devicetree/bindings/net/lantiq,xrx200-net.yaml |    59 +
 Documentation/devicetree/bindings/net/macb.txt     |     4 +
 .../devicetree/bindings/net/qcom,ipq8064-mdio.yaml |     5 +-
 .../devicetree/bindings/net/renesas,ether.yaml     |    17 +-
 .../devicetree/bindings/net/renesas,etheravb.yaml  |     3 +
 .../bindings/net/socionext,uniphier-ave4.yaml      |     1 +
 .../bindings/net/wireless/mediatek,mt76.yaml       |     5 +
 .../devicetree/bindings/net/wireless/qca,ath9k.txt |    48 -
 .../bindings/net/wireless/qca,ath9k.yaml           |    90 +
 .../devicetree/bindings/vendor-prefixes.yaml       |     2 +
 .../device_drivers/ethernet/mellanox/mlx5.rst      |    60 +
 Documentation/networking/devlink/bnxt.rst          |     2 +
 .../networking/devlink/devlink-region.rst          |     4 +-
 Documentation/networking/devlink/ice.rst           |     4 +
 Documentation/networking/devlink/index.rst         |     2 +
 Documentation/networking/devlink/iosm.rst          |   162 +
 Documentation/networking/devlink/octeontx2.rst     |    42 +
 Documentation/networking/ethtool-netlink.rst       |    81 +-
 Documentation/networking/ip-sysctl.rst             |    26 +-
 Documentation/networking/ipvs-sysctl.rst           |    11 +
 Documentation/networking/mctp.rst                  |    59 +
 MAINTAINERS                                        |    29 +-
 Makefile                                           |     3 +
 arch/alpha/include/uapi/asm/socket.h               |     2 +
 arch/arm/net/bpf_jit_32.c                          |     5 -
 arch/m68k/emu/nfeth.c                              |     2 +-
 arch/mips/Kconfig                                  |    15 +-
 arch/mips/include/asm/mach-lantiq/xway/xway_dma.h  |     2 +-
 arch/mips/include/asm/uasm.h                       |     5 +
 arch/mips/include/uapi/asm/socket.h                |     2 +
 arch/mips/lantiq/xway/dma.c                        |    57 +-
 arch/mips/mm/uasm-mips.c                           |     4 +-
 arch/mips/mm/uasm.c                                |     3 +-
 arch/mips/net/Makefile                             |     9 +-
 arch/mips/net/bpf_jit.c                            |  1299 -
 arch/mips/net/bpf_jit.h                            |    81 -
 arch/mips/net/bpf_jit_asm.S                        |   285 -
 arch/mips/net/bpf_jit_comp.c                       |  1034 +
 arch/mips/net/bpf_jit_comp.h                       |   235 +
 arch/mips/net/bpf_jit_comp32.c                     |  1899 +
 arch/mips/net/bpf_jit_comp64.c                     |  1060 +
 arch/mips/net/ebpf_jit.c                           |  1938 -
 arch/parisc/include/uapi/asm/socket.h              |     2 +
 arch/riscv/mm/extable.c                            |    19 +-
 arch/riscv/net/bpf_jit.h                           |     1 +
 arch/riscv/net/bpf_jit_comp64.c                    |   185 +-
 arch/riscv/net/bpf_jit_core.c                      |    21 +-
 arch/s390/include/asm/qdio.h                       |     2 -
 arch/sparc/include/uapi/asm/socket.h               |     3 +
 arch/um/drivers/net_kern.c                         |     3 +-
 arch/x86/events/intel/core.c                       |    67 +-
 arch/x86/events/intel/ds.c                         |     2 +-
 arch/x86/events/intel/lbr.c                        |    20 +-
 arch/x86/events/perf_event.h                       |    19 +
 arch/x86/net/bpf_jit_comp.c                        |   159 +-
 arch/xtensa/platforms/iss/network.c                |     5 +-
 drivers/base/property.c                            |    63 -
 drivers/base/regmap/regmap-mdio.c                  |     6 +-
 drivers/bcma/main.c                                |     2 +-
 drivers/bluetooth/btintel.c                        |   239 +-
 drivers/bluetooth/btintel.h                        |    11 +
 drivers/bluetooth/btmrvl_main.c                    |     6 +-
 drivers/bluetooth/btmtkuart.c                      |    13 +-
 drivers/bluetooth/btrsi.c                          |     1 -
 drivers/bluetooth/btrtl.c                          |    26 +-
 drivers/bluetooth/btusb.c                          |    64 +-
 drivers/bluetooth/hci_h5.c                         |    35 +-
 drivers/bluetooth/hci_ldisc.c                      |     3 +
 drivers/bluetooth/hci_qca.c                        |     5 +-
 drivers/bluetooth/hci_vhci.c                       |   122 +
 drivers/firewire/net.c                             |    14 +-
 drivers/hsi/clients/ssi_protocol.c                 |     4 +-
 drivers/infiniband/hw/mlx4/main.c                  |     2 +-
 drivers/infiniband/hw/mlx4/qp.c                    |     2 +-
 drivers/infiniband/hw/mlx5/cmd.c                   |    26 +
 drivers/infiniband/hw/mlx5/cmd.h                   |     2 +
 drivers/infiniband/hw/mlx5/devx.c                  |    13 +-
 drivers/infiniband/hw/mlx5/devx.h                  |     2 +-
 drivers/infiniband/hw/mlx5/main.c                  |    55 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |    31 +-
 drivers/infiniband/hw/mlx5/mr.c                    |    83 +-
 drivers/infiniband/hw/mlx5/odp.c                   |    39 +-
 drivers/infiniband/hw/mlx5/wr.c                    |    10 +-
 drivers/infiniband/hw/qedr/main.c                  |     2 +-
 drivers/media/dvb-core/dvb_net.c                   |     8 +-
 drivers/message/fusion/mptlan.c                    |     2 +-
 drivers/misc/sgi-xp/xpnet.c                        |     9 +-
 drivers/net/Kconfig                                |    18 +-
 drivers/net/Makefile                               |     1 +
 drivers/net/amt.c                                  |  3296 ++
 drivers/net/appletalk/cops.c                       |     2 +-
 drivers/net/appletalk/ltpc.c                       |     3 +-
 drivers/net/arcnet/arc-rimi.c                      |     5 +-
 drivers/net/arcnet/arcdevice.h                     |     5 +
 drivers/net/arcnet/com20020-isa.c                  |     2 +-
 drivers/net/arcnet/com20020-pci.c                  |     2 +-
 drivers/net/arcnet/com20020.c                      |     4 +-
 drivers/net/arcnet/com20020_cs.c                   |     2 +-
 drivers/net/arcnet/com90io.c                       |     2 +-
 drivers/net/arcnet/com90xx.c                       |     3 +-
 drivers/net/bareudp.c                              |     7 +-
 drivers/net/bonding/bond_alb.c                     |    28 +-
 drivers/net/bonding/bond_main.c                    |     4 +-
 drivers/net/bonding/bond_sysfs.c                   |     4 +-
 drivers/net/can/at91_can.c                         |     4 +-
 drivers/net/can/dev/bittiming.c                    |    30 +-
 drivers/net/can/dev/netlink.c                      |   221 +-
 drivers/net/can/janz-ican3.c                       |     2 +-
 drivers/net/can/mscan/mpc5xxx_can.c                |     6 +-
 drivers/net/can/rcar/Kconfig                       |     4 +-
 drivers/net/can/usb/etas_es58x/es58x_fd.c          |     7 +-
 drivers/net/can/usb/gs_usb.c                       |    12 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |    13 +
 drivers/net/can/usb/peak_usb/pcan_usb_core.h       |     1 +
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |     9 +-
 drivers/net/can/xilinx_can.c                       |     7 +-
 drivers/net/dsa/Kconfig                            |     1 +
 drivers/net/dsa/Makefile                           |     2 +-
 drivers/net/dsa/b53/b53_common.c                   |   101 +-
 drivers/net/dsa/b53/b53_priv.h                     |     2 +-
 drivers/net/dsa/bcm_sf2.c                          |    12 +-
 drivers/net/dsa/hirschmann/hellcreek.c             |     6 +-
 drivers/net/dsa/lantiq_gswip.c                     |    42 +-
 drivers/net/dsa/microchip/ksz8795.c                |     8 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |     5 +-
 drivers/net/dsa/ocelot/felix.c                     |     4 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             |     8 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c           |     8 +-
 drivers/net/dsa/qca/ar9331.c                       |    10 +-
 drivers/net/dsa/qca8k.c                            |   435 +-
 drivers/net/dsa/qca8k.h                            |    35 +-
 drivers/net/dsa/realtek-smi-core.c                 |     4 +
 drivers/net/dsa/realtek-smi-core.h                 |     4 +-
 drivers/net/dsa/rtl8365mb.c                        |  1982 +
 drivers/net/dsa/rtl8366.c                          |    96 +-
 drivers/net/dsa/rtl8366rb.c                        |   301 +-
 drivers/net/dsa/sja1105/sja1105.h                  |    29 +-
 drivers/net/dsa/sja1105/sja1105_clocking.c         |    35 +-
 drivers/net/dsa/sja1105/sja1105_dynamic_config.c   |    91 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |   144 +-
 drivers/net/dsa/sja1105/sja1105_vl.c               |    15 +-
 drivers/net/dsa/xrs700x/xrs700x.c                  |     8 +-
 drivers/net/dsa/xrs700x/xrs700x_mdio.c             |    12 +-
 drivers/net/ethernet/3com/3c509.c                  |     2 +-
 drivers/net/ethernet/3com/3c515.c                  |     5 +-
 drivers/net/ethernet/3com/3c574_cs.c               |    11 +-
 drivers/net/ethernet/3com/3c589_cs.c               |    10 +-
 drivers/net/ethernet/3com/3c59x.c                  |     4 +-
 drivers/net/ethernet/8390/apne.c                   |     3 +-
 drivers/net/ethernet/8390/ax88796.c                |    12 +-
 drivers/net/ethernet/8390/axnet_cs.c               |     7 +-
 drivers/net/ethernet/8390/mcf8390.c                |     3 +-
 drivers/net/ethernet/8390/ne.c                     |     4 +-
 drivers/net/ethernet/8390/ne2k-pci.c               |     2 +-
 drivers/net/ethernet/8390/pcnet_cs.c               |    22 +-
 drivers/net/ethernet/8390/stnic.c                  |     5 +-
 drivers/net/ethernet/8390/zorro8390.c              |     3 +-
 drivers/net/ethernet/Kconfig                       |     1 +
 drivers/net/ethernet/Makefile                      |     1 +
 drivers/net/ethernet/actions/owl-emac.c            |     6 +-
 drivers/net/ethernet/adaptec/starfire.c            |    14 +-
 drivers/net/ethernet/aeroflex/greth.c              |     8 +-
 drivers/net/ethernet/agere/et131x.c                |     4 +-
 drivers/net/ethernet/alacritech/slicoss.c          |     4 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |     4 +-
 drivers/net/ethernet/alteon/acenic.c               |    20 +-
 drivers/net/ethernet/altera/altera_tse_main.c      |     4 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |     2 +-
 drivers/net/ethernet/amd/Kconfig                   |     2 +-
 drivers/net/ethernet/amd/amd8111e.c                |     6 +-
 drivers/net/ethernet/amd/atarilance.c              |     4 +-
 drivers/net/ethernet/amd/au1000_eth.c              |     2 +-
 drivers/net/ethernet/amd/nmclan_cs.c               |     5 +-
 drivers/net/ethernet/amd/pcnet32.c                 |    15 +-
 drivers/net/ethernet/amd/sun3lance.c               |     4 +-
 drivers/net/ethernet/amd/sunlance.c                |     4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-common.h        |     8 +
 drivers/net/ethernet/amd/xgbe/xgbe-dev.c           |     2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |     4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c       |     8 +-
 drivers/net/ethernet/amd/xgbe/xgbe-main.c          |     2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |    20 +-
 drivers/net/ethernet/amd/xgbe/xgbe.h               |     2 +-
 drivers/net/ethernet/apm/xgene-v2/mac.c            |     2 +-
 drivers/net/ethernet/apm/xgene-v2/main.c           |     2 +-
 drivers/net/ethernet/apm/xgene/xgene_enet_hw.c     |     2 +-
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c   |     2 +-
 drivers/net/ethernet/apm/xgene/xgene_enet_sgmac.c  |     2 +-
 drivers/net/ethernet/apm/xgene/xgene_enet_xgmac.c  |     2 +-
 drivers/net/ethernet/apple/bmac.c                  |    15 +-
 drivers/net/ethernet/aquantia/atlantic/aq_hw.h     |     6 +-
 drivers/net/ethernet/aquantia/atlantic/aq_macsec.c |     2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |     8 +-
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c  |     4 +-
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c  |     4 +-
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.h  |     2 +-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c        |     4 +-
 .../aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c   |     4 +-
 .../ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c   |     2 +-
 drivers/net/ethernet/arc/Kconfig                   |     4 +-
 drivers/net/ethernet/arc/emac_main.c               |     4 +-
 drivers/net/ethernet/arc/emac_mdio.c               |     9 +-
 drivers/net/ethernet/asix/Kconfig                  |    35 +
 drivers/net/ethernet/asix/Makefile                 |     6 +
 drivers/net/ethernet/asix/ax88796c_ioctl.c         |   239 +
 drivers/net/ethernet/asix/ax88796c_ioctl.h         |    26 +
 drivers/net/ethernet/asix/ax88796c_main.c          |  1164 +
 drivers/net/ethernet/asix/ax88796c_main.h          |   568 +
 drivers/net/ethernet/asix/ax88796c_spi.c           |   115 +
 drivers/net/ethernet/asix/ax88796c_spi.h           |    69 +
 drivers/net/ethernet/atheros/ag71xx.c              |    12 +-
 drivers/net/ethernet/atheros/alx/main.c            |     4 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |    12 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |    10 +-
 drivers/net/ethernet/atheros/atlx/atl1.c           |     2 +-
 drivers/net/ethernet/atheros/atlx/atl2.c           |     4 +-
 drivers/net/ethernet/atheros/atlx/atlx.c           |     2 +-
 drivers/net/ethernet/broadcom/b44.c                |    12 +-
 drivers/net/ethernet/broadcom/bcm4908_enet.c       |     4 +-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c       |     6 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |     6 +-
 drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c    |     6 +-
 drivers/net/ethernet/broadcom/bgmac-bcma.c         |    37 +-
 drivers/net/ethernet/broadcom/bgmac-platform.c     |     2 +-
 drivers/net/ethernet/broadcom/bgmac.c              |     4 +-
 drivers/net/ethernet/broadcom/bnx2.c               |     6 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |     2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |     2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |    22 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c  |     2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h  |     3 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_vfpf.c   |     9 +-
 drivers/net/ethernet/broadcom/bnxt/Makefile        |     2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   283 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   113 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c |   444 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.h |    51 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |   785 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h  |    27 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   400 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h  |    46 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h      |   155 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |     2 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h      |     3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c    |     6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.h    |     2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h      |     3 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c      |     2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |    87 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.h     |    10 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |   202 +-
 drivers/net/ethernet/broadcom/tg3.c                |    60 +-
 drivers/net/ethernet/brocade/bna/bnad.c            |     5 +-
 drivers/net/ethernet/cadence/macb.h                |     7 +-
 drivers/net/ethernet/cadence/macb_main.c           |    42 +-
 drivers/net/ethernet/cadence/macb_ptp.c            |    13 +-
 drivers/net/ethernet/calxeda/xgmac.c               |     8 +-
 drivers/net/ethernet/cavium/liquidio/lio_core.c    |     3 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |    40 +-
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c |     4 +-
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c   |     2 +-
 drivers/net/ethernet/cavium/thunder/nic_main.c     |     3 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |    11 +-
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c  |     9 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c          |     2 +-
 drivers/net/ethernet/chelsio/cxgb/gmac.h           |     2 +-
 drivers/net/ethernet/chelsio/cxgb/pm3393.c         |     2 +-
 drivers/net/ethernet/chelsio/cxgb/subr.c           |     2 +-
 drivers/net/ethernet/chelsio/cxgb/vsc7326.c        |     4 +-
 drivers/net/ethernet/chelsio/cxgb3/common.h        |     2 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |     2 +-
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c         |     4 +-
 drivers/net/ethernet/chelsio/cxgb3/xgmac.c         |     2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h         |     2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |     2 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |     2 +-
 drivers/net/ethernet/chelsio/cxgb4vf/adapter.h     |     3 +-
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |     8 +-
 .../chelsio/inline_crypto/chtls/chtls_cm.c         |     2 +-
 .../chelsio/inline_crypto/chtls/chtls_cm.h         |     2 +-
 drivers/net/ethernet/cirrus/cs89x0.c               |    13 +-
 drivers/net/ethernet/cirrus/ep93xx_eth.c           |     2 +-
 drivers/net/ethernet/cirrus/mac89x0.c              |     2 +-
 drivers/net/ethernet/cisco/enic/enic_ethtool.c     |     4 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |     9 +-
 drivers/net/ethernet/cisco/enic/enic_pp.c          |     2 +-
 drivers/net/ethernet/cortina/gemini.c              |     6 +-
 drivers/net/ethernet/davicom/dm9000.c              |     9 +-
 drivers/net/ethernet/dec/tulip/de2104x.c           |    15 +-
 drivers/net/ethernet/dec/tulip/de4x5.c             |    35 +-
 drivers/net/ethernet/dec/tulip/dmfe.c              |     9 +-
 drivers/net/ethernet/dec/tulip/tulip_core.c        |    45 +-
 drivers/net/ethernet/dec/tulip/uli526x.c           |    11 +-
 drivers/net/ethernet/dec/tulip/winbond-840.c       |     6 +-
 drivers/net/ethernet/dec/tulip/xircom_cb.c         |     4 +-
 drivers/net/ethernet/dlink/dl2k.c                  |     5 +-
 drivers/net/ethernet/dlink/sundance.c              |     6 +-
 drivers/net/ethernet/dnet.c                        |     8 +-
 drivers/net/ethernet/ec_bhf.c                      |     4 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c        |     2 +-
 drivers/net/ethernet/emulex/benet/be_cmds.h        |     2 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |     7 +-
 drivers/net/ethernet/ethoc.c                       |    28 +-
 drivers/net/ethernet/ezchip/Kconfig                |     2 +-
 drivers/net/ethernet/ezchip/nps_enet.c             |     4 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |     9 +-
 drivers/net/ethernet/fealnx.c                      |     8 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |     6 +-
 .../ethernet/freescale/dpaa2/dpaa2-eth-devlink.c   |    21 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |    24 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h   |     7 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |    58 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c   |     2 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |     2 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |   332 +-
 drivers/net/ethernet/freescale/enetc/enetc.h       |     4 +
 drivers/net/ethernet/freescale/enetc/enetc_hw.h    |     6 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |    32 +-
 drivers/net/ethernet/freescale/enetc/enetc_ptp.c   |     6 +-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |    18 +-
 drivers/net/ethernet/freescale/enetc/enetc_vf.c    |    16 +-
 drivers/net/ethernet/freescale/fec_main.c          |     7 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c       |     4 +-
 drivers/net/ethernet/freescale/fman/fman_dtsec.c   |     8 +-
 drivers/net/ethernet/freescale/fman/fman_dtsec.h   |     2 +-
 drivers/net/ethernet/freescale/fman/fman_memac.c   |     8 +-
 drivers/net/ethernet/freescale/fman/fman_memac.h   |     2 +-
 drivers/net/ethernet/freescale/fman/fman_tgec.c    |     8 +-
 drivers/net/ethernet/freescale/fman/fman_tgec.h    |     2 +-
 drivers/net/ethernet/freescale/fman/mac.h          |     2 +-
 .../net/ethernet/freescale/fs_enet/fs_enet-main.c  |     2 +-
 drivers/net/ethernet/freescale/gianfar.c           |     2 +-
 drivers/net/ethernet/freescale/ucc_geth.c          |     4 +-
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c          |    14 +-
 drivers/net/ethernet/google/gve/gve.h              |    52 +-
 drivers/net/ethernet/google/gve/gve_adminq.c       |    61 +-
 drivers/net/ethernet/google/gve/gve_adminq.h       |    15 +
 drivers/net/ethernet/google/gve/gve_desc.h         |    13 +-
 drivers/net/ethernet/google/gve/gve_ethtool.c      |     7 +-
 drivers/net/ethernet/google/gve/gve_main.c         |   109 +-
 drivers/net/ethernet/google/gve/gve_rx.c           |   413 +-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c       |    68 +-
 drivers/net/ethernet/google/gve/gve_tx.c           |   117 +-
 drivers/net/ethernet/google/gve/gve_tx_dqo.c       |    84 +-
 drivers/net/ethernet/google/gve/gve_utils.c        |    37 +-
 drivers/net/ethernet/google/gve/gve_utils.h        |     2 +-
 drivers/net/ethernet/hisilicon/hip04_eth.c         |     2 +-
 drivers/net/ethernet/hisilicon/hisi_femac.c        |     6 +-
 drivers/net/ethernet/hisilicon/hix5hd2_gmac.c      |     4 +-
 drivers/net/ethernet/hisilicon/hns/hnae.h          |     4 +-
 drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c  |     7 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_gmac.c |     2 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c  |     2 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.h  |     5 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.h |     2 +-
 .../net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c    |     2 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |     4 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |    11 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   199 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |     4 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |     3 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |     1 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |     6 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |     3 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c |    18 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |    14 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h |     4 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   555 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |    34 +-
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c        |    18 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |     2 +-
 drivers/net/ethernet/huawei/hinic/hinic_devlink.c  |     4 +-
 drivers/net/ethernet/huawei/hinic/hinic_devlink.h  |     2 +-
 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c  |    10 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c   |    13 +-
 drivers/net/ethernet/huawei/hinic/hinic_main.c     |    12 +-
 drivers/net/ethernet/i825xx/sun3_82586.c           |     7 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |     4 +-
 drivers/net/ethernet/ibm/emac/core.c               |    14 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |    46 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   666 +-
 drivers/net/ethernet/ibm/ibmvnic.h                 |    10 +-
 drivers/net/ethernet/intel/Kconfig                 |    14 +
 drivers/net/ethernet/intel/e100.c                  |     4 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |     4 +-
 drivers/net/ethernet/intel/e1000e/e1000.h          |     1 +
 drivers/net/ethernet/intel/e1000e/netdev.c         |     5 +-
 drivers/net/ethernet/intel/fm10k/fm10k_netdev.c    |     2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c       |     4 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |     2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |     4 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |    52 +-
 drivers/net/ethernet/intel/iavf/iavf.h             |    48 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   238 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |     6 +-
 drivers/net/ethernet/intel/ice/Makefile            |     5 +-
 drivers/net/ethernet/intel/ice/ice.h               |   215 +-
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h    |    94 +-
 drivers/net/ethernet/intel/ice/ice_arfs.c          |     4 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |   121 +-
 drivers/net/ethernet/intel/ice/ice_base.h          |     8 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |   129 +-
 drivers/net/ethernet/intel/ice/ice_common.h        |     7 +
 drivers/net/ethernet/intel/ice/ice_dcb.c           |   225 +-
 drivers/net/ethernet/intel/ice/ice_dcb.h           |    18 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c       |   216 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h       |    32 +-
 drivers/net/ethernet/intel/ice/ice_dcb_nl.c        |   192 +-
 drivers/net/ethernet/intel/ice/ice_devids.h        |     2 +
 drivers/net/ethernet/intel/ice/ice_devlink.c       |   256 +-
 drivers/net/ethernet/intel/ice/ice_devlink.h       |     8 +-
 drivers/net/ethernet/intel/ice/ice_eswitch.c       |   655 +
 drivers/net/ethernet/intel/ice/ice_eswitch.h       |    83 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   236 +-
 drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c  |     4 +-
 drivers/net/ethernet/intel/ice/ice_fdir.c          |     2 +-
 drivers/net/ethernet/intel/ice/ice_fdir.h          |     2 +-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c     |   303 +-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.h     |    14 +
 drivers/net/ethernet/intel/ice/ice_flex_type.h     |    17 +
 drivers/net/ethernet/intel/ice/ice_fltr.c          |    80 +
 drivers/net/ethernet/intel/ice/ice_fltr.h          |     3 +
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h    |     1 +
 drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h     |    43 +
 drivers/net/ethernet/intel/ice/ice_lib.c           |   855 +-
 drivers/net/ethernet/intel/ice/ice_lib.h           |    38 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  1637 +-
 drivers/net/ethernet/intel/ice/ice_protocol_type.h |   204 +
 drivers/net/ethernet/intel/ice/ice_ptp.c           |   372 +-
 drivers/net/ethernet/intel/ice/ice_ptp.h           |    24 +-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c        |   151 +
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h        |    22 +
 drivers/net/ethernet/intel/ice/ice_repr.c          |   389 +
 drivers/net/ethernet/intel/ice/ice_repr.h          |    28 +
 drivers/net/ethernet/intel/ice/ice_sched.c         |   184 +
 drivers/net/ethernet/intel/ice/ice_sched.h         |     8 +
 drivers/net/ethernet/intel/ice/ice_switch.c        |  2888 +-
 drivers/net/ethernet/intel/ice/ice_switch.h        |   152 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c        |  1369 +
 drivers/net/ethernet/intel/ice/ice_tc_lib.h        |   162 +
 drivers/net/ethernet/intel/ice/ice_trace.h         |    28 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   326 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h          |   147 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c      |   102 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h      |    14 +-
 drivers/net/ethernet/intel/ice/ice_type.h          |    19 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |   447 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h   |    74 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |   158 +-
 drivers/net/ethernet/intel/ice/ice_xsk.h           |    20 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |    27 +-
 drivers/net/ethernet/intel/igbvf/netdev.c          |     8 +-
 drivers/net/ethernet/intel/igc/igc_base.c          |     8 +-
 drivers/net/ethernet/intel/igc/igc_defines.h       |     2 +-
 drivers/net/ethernet/intel/igc/igc_hw.h            |     1 +
 drivers/net/ethernet/intel/igc/igc_main.c          |     5 +-
 drivers/net/ethernet/intel/igc/igc_ptp.c           |     2 +-
 drivers/net/ethernet/intel/ixgb/ixgb_hw.c          |     2 +-
 drivers/net/ethernet/intel/ixgb/ixgb_hw.h          |     2 +-
 drivers/net/ethernet/intel/ixgb/ixgb_main.c        |    10 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |    23 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |     5 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c       |     9 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |    54 +-
 .../net/ethernet/intel/ixgbe/ixgbe_txrx_common.h   |     3 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |    16 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |     6 +-
 drivers/net/ethernet/intel/ixgbevf/vf.c            |     2 +-
 drivers/net/ethernet/jme.c                         |     4 +-
 drivers/net/ethernet/korina.c                      |     4 +-
 drivers/net/ethernet/lantiq_etop.c                 |    21 +-
 drivers/net/ethernet/lantiq_xrx200.c               |    74 +-
 drivers/net/ethernet/litex/Kconfig                 |     2 +-
 drivers/net/ethernet/litex/litex_liteeth.c         |     2 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c         |    16 +-
 drivers/net/ethernet/marvell/mvneta.c              |    75 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   117 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c     |     2 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |    11 +-
 drivers/net/ethernet/marvell/octeontx2/af/common.h |     1 +
 .../ethernet/marvell/octeontx2/af/lmac_common.h    |     5 +
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   138 +-
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |    20 +-
 .../ethernet/marvell/octeontx2/af/npc_profile.h    |   994 +-
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c    |   133 +-
 drivers/net/ethernet/marvell/octeontx2/af/ptp.h    |     1 +
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c    |    17 +
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h    |     3 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |    76 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |    19 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |    13 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cn10k.c  |     4 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cpt.c    |   601 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |   118 +-
 .../ethernet/marvell/octeontx2/af/rvu_devlink.c    |    16 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   222 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |    96 +
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |     3 +
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |     4 +
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |    18 +
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |     6 +-
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c |     2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |    52 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |    18 +-
 .../ethernet/marvell/octeontx2/nic/otx2_devlink.c  |    21 +-
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |    43 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   234 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  |   133 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |   273 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |    16 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |     8 +-
 drivers/net/ethernet/marvell/prestera/prestera.h   |    69 +-
 .../ethernet/marvell/prestera/prestera_devlink.c   |    35 +-
 .../ethernet/marvell/prestera/prestera_devlink.h   |     4 +-
 .../ethernet/marvell/prestera/prestera_ethtool.c   |   219 +-
 .../ethernet/marvell/prestera/prestera_ethtool.h   |     6 +
 .../net/ethernet/marvell/prestera/prestera_hw.c    |  1064 +-
 .../net/ethernet/marvell/prestera/prestera_hw.h    |    47 +-
 .../net/ethernet/marvell/prestera/prestera_main.c  |   161 +-
 .../net/ethernet/marvell/prestera/prestera_pci.c   |   114 +-
 .../net/ethernet/marvell/prestera/prestera_rxtx.c  |     7 -
 drivers/net/ethernet/marvell/pxa168_eth.c          |    21 +-
 drivers/net/ethernet/marvell/skge.c                |     6 +-
 drivers/net/ethernet/marvell/sky2.c                |    99 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |     2 +-
 drivers/net/ethernet/mediatek/mtk_star_emac.c      |     4 +-
 drivers/net/ethernet/mellanox/mlx4/cmd.c           |     6 +-
 drivers/net/ethernet/mellanox/mlx4/cq.c            |     3 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |    29 +-
 drivers/net/ethernet/mellanox/mlx4/en_main.c       |     1 -
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |    40 +-
 drivers/net/ethernet/mellanox/mlx4/en_port.c       |     4 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |    15 +
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |     4 +-
 drivers/net/ethernet/mellanox/mlx4/fw.c            |     2 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |    12 +-
 drivers/net/ethernet/mellanox/mlx4/mcg.c           |     2 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |     3 +
 drivers/net/ethernet/mellanox/mlx4/mlx4_stats.h    |     4 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |     8 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |    20 +-
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |    14 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |    30 +-
 .../mellanox/mlx5/core/diag/fs_tracepoint.c        |     3 +
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |     7 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.h   |     2 +-
 .../ethernet/mellanox/mlx5/core/diag/rsc_dump.c    |    10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |    87 +-
 .../net/ethernet/mellanox/mlx5/core/en/devlink.c   |     2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |     8 +-
 .../net/ethernet/mellanox/mlx5/core/en/health.h    |     1 -
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |   163 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |    18 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |     2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c   |   102 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.h   |     9 +
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |   134 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.h    |    14 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |     7 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |     7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/rss.c   |    50 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/rss.h   |     7 +-
 .../net/ethernet/mellanox/mlx5/core/en/rx_res.c    |    25 +-
 .../net/ethernet/mellanox/mlx5/core/en/rx_res.h    |     5 +-
 .../ethernet/mellanox/mlx5/core/en/tc/int_port.c   |   457 +
 .../ethernet/mellanox/mlx5/core/en/tc/int_port.h   |    65 +
 .../ethernet/mellanox/mlx5/core/en/tc/post_act.c   |    13 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |    39 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.h |    27 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |    51 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |     2 +
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |    44 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.h    |     1 +
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |    35 +
 .../ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c  |     9 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tir.c   |    32 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tir.h   |     6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c  |     2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |     6 +
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       |    26 +
 .../net/ethernet/mellanox/mlx5/core/en_common.c    |     6 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |    19 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |     4 +-
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |    12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   420 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |    18 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |     4 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   668 +-
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c  |    92 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |    15 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |    10 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   591 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |    11 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |    20 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |     9 +-
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |   293 +-
 .../ethernet/mellanox/mlx5/core/esw/bridge_priv.h  |     1 +
 .../ethernet/mellanox/mlx5/core/esw/devlink_port.c |     4 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |    18 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |    88 +-
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |     7 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/conn.c    |    10 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/core.h    |     2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |    66 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h   |     4 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   126 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |    12 +-
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  |    26 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |    21 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |    17 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   147 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |    30 +
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |    12 +-
 .../ethernet/mellanox/mlx5/core/{ => lag}/lag.c    |   102 +-
 .../ethernet/mellanox/mlx5/core/{ => lag}/lag.h    |     9 +-
 .../mellanox/mlx5/core/{lag_mp.c => lag/mp.c}      |     4 +-
 .../mellanox/mlx5/core/{lag_mp.h => lag/mp.h}      |     2 +-
 .../net/ethernet/mellanox/mlx5/core/lag/port_sel.c |   611 +
 .../net/ethernet/mellanox/mlx5/core/lag/port_sel.h |    52 +
 .../net/ethernet/mellanox/mlx5/core/lib/fs_ttc.c   |     4 +
 .../net/ethernet/mellanox/mlx5/core/lib/fs_ttc.h   |     2 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c |   162 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h |    41 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |    88 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |    24 +
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h |     2 -
 drivers/net/ethernet/mellanox/mlx5/core/mr.c       |    27 +-
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |    16 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |    36 +-
 .../net/ethernet/mellanox/mlx5/core/sf/dev/dev.c   |    23 +-
 .../net/ethernet/mellanox/mlx5/core/sf/dev/dev.h   |     1 +
 .../mlx5/core/sf/dev/diag/dev_tracepoint.h         |    58 +
 .../ethernet/mellanox/mlx5/core/sf/dev/driver.c    |     7 +-
 .../net/ethernet/mellanox/mlx5/core/sf/devlink.c   |    10 +-
 .../mellanox/mlx5/core/sf/diag/sf_tracepoint.h     |   173 +
 .../mellanox/mlx5/core/sf/diag/vhca_tracepoint.h   |    40 +
 .../net/ethernet/mellanox/mlx5/core/sf/hw_table.c  |     4 +
 .../ethernet/mellanox/mlx5/core/sf/vhca_event.c    |     3 +
 .../mellanox/mlx5/core/steering/dr_action.c        |    27 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |     6 +-
 .../mellanox/mlx5/core/steering/dr_domain.c        |   212 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_fw.c   |     2 +-
 .../mellanox/mlx5/core/steering/dr_icm_pool.c      |    10 +-
 .../mellanox/mlx5/core/steering/dr_matcher.c       |    28 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |     6 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |    11 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |   272 +-
 .../mellanox/mlx5/core/steering/dr_ste_v0.c        |    13 +-
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        |    20 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |    52 +-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |    17 +-
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |     2 +-
 drivers/net/ethernet/mellanox/mlx5/core/uar.c      |    14 +-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |    21 +-
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c |     2 +-
 drivers/net/ethernet/mellanox/mlxfw/mlxfw.h        |     2 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c         |    90 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h         |     2 -
 drivers/net/ethernet/mellanox/mlxsw/core_env.c     |   372 +-
 drivers/net/ethernet/mellanox/mlxsw/core_env.h     |    23 +
 drivers/net/ethernet/mellanox/mlxsw/item.h         |    56 +-
 drivers/net/ethernet/mellanox/mlxsw/minimal.c      |    66 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h          |   357 +-
 drivers/net/ethernet/mellanox/mlxsw/resources.h    |     8 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |   390 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |    10 +-
 .../net/ethernet/mellanox/mlxsw/spectrum2_kvdl.c   |     1 +
 .../ethernet/mellanox/mlxsw/spectrum_acl_atcam.c   |     8 +-
 .../ethernet/mellanox/mlxsw/spectrum_acl_tcam.c    |    15 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_buffers.c |     2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c |     9 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_ethtool.c |    45 +
 .../net/ethernet/mellanox/mlxsw/spectrum_ipip.c    |   432 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_ipip.h    |    27 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_qdisc.c   |   583 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |   662 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.h  |     9 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c    |    16 +
 .../net/ethernet/mellanox/mlxsw/spectrum_span.h    |     1 +
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c   |    11 +-
 drivers/net/ethernet/micrel/ks8842.c               |    15 +-
 drivers/net/ethernet/micrel/ks8851.h               |     2 +-
 drivers/net/ethernet/micrel/ks8851_common.c        |    14 +-
 drivers/net/ethernet/micrel/ks8851_par.c           |     4 +-
 drivers/net/ethernet/micrel/ks8851_spi.c           |     4 +-
 drivers/net/ethernet/micrel/ksz884x.c              |    16 +-
 drivers/net/ethernet/microchip/enc28j60.c          |     7 +-
 drivers/net/ethernet/microchip/encx24j600.c        |     7 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |     4 +-
 drivers/net/ethernet/microchip/lan743x_main.h      |     3 +-
 drivers/net/ethernet/microchip/lan743x_ptp.c       |    91 +-
 .../net/ethernet/microchip/sparx5/sparx5_main.c    |     3 +-
 .../net/ethernet/microchip/sparx5/sparx5_netdev.c  |     6 +-
 .../net/ethernet/microchip/sparx5/sparx5_phylink.c |     7 +-
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |   155 +-
 drivers/net/ethernet/microsoft/mana/hw_channel.c   |    75 +-
 drivers/net/ethernet/microsoft/mana/mana.h         |     4 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |    96 +-
 drivers/net/ethernet/microsoft/mana/mana_ethtool.c |     3 -
 drivers/net/ethernet/moxa/moxart_ether.c           |     2 +-
 drivers/net/ethernet/mscc/Kconfig                  |     2 +-
 drivers/net/ethernet/mscc/ocelot.c                 |   327 +-
 drivers/net/ethernet/mscc/ocelot.h                 |     1 +
 drivers/net/ethernet/mscc/ocelot_flower.c          |   125 +-
 drivers/net/ethernet/mscc/ocelot_mrp.c             |     8 +-
 drivers/net/ethernet/mscc/ocelot_net.c             |    24 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c         |     9 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |     9 +-
 drivers/net/ethernet/natsemi/natsemi.c             |     6 +-
 drivers/net/ethernet/natsemi/ns83820.c             |    11 +-
 drivers/net/ethernet/neterion/s2io.c               |     6 +-
 drivers/net/ethernet/neterion/s2io.h               |     2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c     |     6 +-
 drivers/net/ethernet/netronome/nfp/abm/main.c      |     2 +-
 drivers/net/ethernet/netronome/nfp/abm/qdisc.c     |     2 +-
 drivers/net/ethernet/netronome/nfp/devlink_param.c |     9 +-
 drivers/net/ethernet/netronome/nfp/flower/action.c |     3 +-
 drivers/net/ethernet/netronome/nfp/flower/cmsg.h   |     2 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |     2 +-
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    |     6 +-
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |     8 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_main.c  |    11 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c  |     3 +-
 .../net/ethernet/netronome/nfp/nfp_netvf_main.c    |     2 +-
 drivers/net/ethernet/ni/nixge.c                    |     2 +-
 drivers/net/ethernet/nvidia/forcedeth.c            |    51 +-
 drivers/net/ethernet/nxp/lpc_eth.c                 |    10 +-
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |     4 +-
 drivers/net/ethernet/packetengines/hamachi.c       |     5 +-
 drivers/net/ethernet/packetengines/yellowfin.c     |     6 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c           |     4 +-
 drivers/net/ethernet/pensando/ionic/ionic.h        |     8 +-
 .../net/ethernet/pensando/ionic/ionic_debugfs.c    |    48 +-
 drivers/net/ethernet/pensando/ionic/ionic_dev.c    |     1 -
 drivers/net/ethernet/pensando/ionic/ionic_dev.h    |     4 -
 .../net/ethernet/pensando/ionic/ionic_devlink.c    |    10 +-
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    |    41 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |   264 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.h    |    49 +-
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |    92 +-
 drivers/net/ethernet/pensando/ionic/ionic_phc.c    |     8 +-
 .../net/ethernet/pensando/ionic/ionic_rx_filter.c  |   241 +-
 .../net/ethernet/pensando/ionic/ionic_rx_filter.h  |     2 +
 drivers/net/ethernet/pensando/ionic/ionic_stats.c  |   121 -
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |    14 -
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |     8 +-
 drivers/net/ethernet/qlogic/qed/qed.h              |    44 +-
 drivers/net/ethernet/qlogic/qed/qed_cxt.c          |    16 +-
 drivers/net/ethernet/qlogic/qed/qed_cxt.h          |   143 +-
 drivers/net/ethernet/qlogic/qed/qed_dbg_hsi.h      |  1491 +
 drivers/net/ethernet/qlogic/qed/qed_dcbx.h         |    11 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.c        |  1389 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.h        |     7 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |   126 +-
 drivers/net/ethernet/qlogic/qed/qed_dev_api.h      |   347 +-
 drivers/net/ethernet/qlogic/qed/qed_devlink.c      |    12 +-
 drivers/net/ethernet/qlogic/qed/qed_fcoe.c         |    25 +-
 drivers/net/ethernet/qlogic/qed/qed_hsi.h          | 12643 ++---
 drivers/net/ethernet/qlogic/qed/qed_hw.h           |   222 +-
 .../net/ethernet/qlogic/qed/qed_init_fw_funcs.c    |   405 +-
 drivers/net/ethernet/qlogic/qed/qed_init_ops.c     |    98 +-
 drivers/net/ethernet/qlogic/qed/qed_init_ops.h     |    60 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c          |     4 +-
 drivers/net/ethernet/qlogic/qed/qed_int.h          |   286 +-
 drivers/net/ethernet/qlogic/qed/qed_iro_hsi.h      |   500 +
 drivers/net/ethernet/qlogic/qed/qed_iscsi.c        |    15 +-
 drivers/net/ethernet/qlogic/qed/qed_iscsi.h        |     9 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c        |     2 +
 drivers/net/ethernet/qlogic/qed/qed_l2.c           |    43 +-
 drivers/net/ethernet/qlogic/qed/qed_l2.h           |   135 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c          |   167 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.h          |   131 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c         |    23 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c          |    66 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.h          |   765 +-
 drivers/net/ethernet/qlogic/qed/qed_mfw_hsi.h      |  2474 +
 drivers/net/ethernet/qlogic/qed/qed_ooo.c          |    20 +-
 drivers/net/ethernet/qlogic/qed/qed_ptp.c          |     4 +-
 drivers/net/ethernet/qlogic/qed/qed_rdma.c         |     9 +-
 drivers/net/ethernet/qlogic/qed/qed_rdma.h         |     7 +-
 drivers/net/ethernet/qlogic/qed/qed_reg_addr.h     |    95 +-
 drivers/net/ethernet/qlogic/qed/qed_roce.c         |     1 -
 drivers/net/ethernet/qlogic/qed/qed_selftest.h     |    30 +-
 drivers/net/ethernet/qlogic/qed/qed_sp.h           |   223 +-
 drivers/net/ethernet/qlogic/qed/qed_sp_commands.c  |    10 +-
 drivers/net/ethernet/qlogic/qed/qed_spq.c          |    63 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c        |   201 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.h        |   138 +-
 drivers/net/ethernet/qlogic/qed/qed_vf.c           |    13 +-
 drivers/net/ethernet/qlogic/qed/qed_vf.h           |   311 +-
 drivers/net/ethernet/qlogic/qede/qede_filter.c     |    53 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |    21 +-
 drivers/net/ethernet/qlogic/qla3xxx.c              |    12 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |     4 +-
 drivers/net/ethernet/qualcomm/emac/emac-mac.c      |     2 +-
 drivers/net/ethernet/qualcomm/emac/emac.c          |     5 +-
 drivers/net/ethernet/qualcomm/qca_spi.c            |     2 +-
 drivers/net/ethernet/qualcomm/qca_uart.c           |     2 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c    |     2 +-
 drivers/net/ethernet/rdc/r6040.c                   |    24 +-
 drivers/net/ethernet/realtek/8139cp.c              |     7 +-
 drivers/net/ethernet/realtek/8139too.c             |     7 +-
 drivers/net/ethernet/realtek/atp.c                 |     4 +-
 drivers/net/ethernet/realtek/r8169.h               |     2 +-
 drivers/net/ethernet/realtek/r8169_main.c          |    44 +-
 drivers/net/ethernet/realtek/r8169_phy_config.c    |    59 -
 drivers/net/ethernet/renesas/ravb.h                |    52 +-
 drivers/net/ethernet/renesas/ravb_main.c           |   728 +-
 drivers/net/ethernet/renesas/sh_eth.c              |    18 +-
 drivers/net/ethernet/rocker/rocker_main.c          |    10 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_common.h  |     2 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_core.c    |     3 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |     9 +-
 .../net/ethernet/samsung/sxgbe/sxgbe_platform.c    |     2 +-
 drivers/net/ethernet/seeq/sgiseeq.c                |     4 +-
 drivers/net/ethernet/sfc/ef10.c                    |     4 +-
 drivers/net/ethernet/sfc/ef100_nic.c               |     2 +-
 drivers/net/ethernet/sfc/ef10_sriov.c              |     4 +-
 drivers/net/ethernet/sfc/ef10_sriov.h              |     6 +-
 drivers/net/ethernet/sfc/efx.c                     |     2 +-
 drivers/net/ethernet/sfc/efx_common.c              |     4 +-
 drivers/net/ethernet/sfc/ethtool_common.c          |    10 +-
 drivers/net/ethernet/sfc/falcon/efx.c              |     6 +-
 drivers/net/ethernet/sfc/net_driver.h              |     2 +-
 drivers/net/ethernet/sfc/siena_sriov.c             |     2 +-
 drivers/net/ethernet/sfc/siena_sriov.h             |     2 +-
 drivers/net/ethernet/sgi/ioc3-eth.c                |     4 +-
 drivers/net/ethernet/sgi/meth.c                    |     2 +-
 drivers/net/ethernet/silan/sc92031.c               |    14 +-
 drivers/net/ethernet/sis/sis190.c                  |    10 +-
 drivers/net/ethernet/sis/sis900.c                  |    19 +-
 drivers/net/ethernet/smsc/epic100.c                |     4 +-
 drivers/net/ethernet/smsc/smc911x.c                |     4 +-
 drivers/net/ethernet/smsc/smc91c92_cs.c            |    15 +-
 drivers/net/ethernet/smsc/smc91x.c                 |     4 +-
 drivers/net/ethernet/smsc/smsc911x.c               |    22 +-
 drivers/net/ethernet/smsc/smsc9420.c               |    26 +-
 drivers/net/ethernet/socionext/netsec.c            |    46 +-
 drivers/net/ethernet/socionext/sni_ave.c           |    17 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |     4 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |     2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-visconti.c   |     7 +-
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |     2 +-
 .../net/ethernet/stmicro/stmmac/dwmac100_core.c    |     2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |     2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c   |     2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c    |     2 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |     3 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |     3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    14 +-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |     8 +-
 drivers/net/ethernet/sun/cassini.c                 |     7 +-
 drivers/net/ethernet/sun/ldmvsw.c                  |     7 +-
 drivers/net/ethernet/sun/niu.c                     |    46 +-
 drivers/net/ethernet/sun/sunbmac.c                 |     6 +-
 drivers/net/ethernet/sun/sungem.c                  |    15 +-
 drivers/net/ethernet/sun/sunhme.c                  |    23 +-
 drivers/net/ethernet/sun/sunqe.c                   |     4 +-
 drivers/net/ethernet/sun/sunvnet.c                 |     4 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-common.c  |     2 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-hw.c      |     2 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-net.c     |     2 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac.h         |     2 +-
 drivers/net/ethernet/tehuti/tehuti.c               |     8 +-
 drivers/net/ethernet/ti/am65-cpsw-ethtool.c        |     2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |    26 +-
 drivers/net/ethernet/ti/cpmac.c                    |     2 +-
 drivers/net/ethernet/ti/cpsw.c                     |     6 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |    17 +-
 drivers/net/ethernet/ti/cpts.c                     |     6 +-
 drivers/net/ethernet/ti/davinci_emac.c             |     8 +-
 drivers/net/ethernet/ti/netcp_core.c               |     8 +-
 drivers/net/ethernet/ti/tlan.c                     |    14 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c       |     2 +-
 drivers/net/ethernet/toshiba/spider_net.c          |     2 +-
 drivers/net/ethernet/toshiba/tc35815.c             |    11 +-
 drivers/net/ethernet/via/via-rhine.c               |     4 +-
 drivers/net/ethernet/via/via-velocity.c            |     4 +-
 drivers/net/ethernet/wiznet/w5100-spi.c            |     4 +-
 drivers/net/ethernet/wiznet/w5100.c                |    11 +-
 drivers/net/ethernet/wiznet/w5100.h                |     2 +-
 drivers/net/ethernet/wiznet/w5300.c                |     4 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c        |     4 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |    10 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |    11 +-
 drivers/net/ethernet/xircom/xirc2ps_cs.c           |    14 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c           |     7 +-
 drivers/net/fddi/defxx.c                           |    12 +-
 drivers/net/fddi/defza.c                           |     2 +-
 drivers/net/fddi/skfp/h/smc.h                      |     2 +-
 drivers/net/fddi/skfp/skfddi.c                     |     9 +-
 drivers/net/fddi/skfp/smtinit.c                    |     4 +-
 drivers/net/fjes/fjes_hw.c                         |     3 +-
 drivers/net/fjes/fjes_hw.h                         |     2 +-
 drivers/net/fjes/fjes_main.c                       |    14 +-
 drivers/net/gtp.c                                  |     2 +-
 drivers/net/hamradio/6pack.c                       |     6 +-
 drivers/net/hamradio/baycom_epp.c                  |     4 +-
 drivers/net/hamradio/bpqether.c                    |     7 +-
 drivers/net/hamradio/dmascc.c                      |     5 +-
 drivers/net/hamradio/hdlcdrv.c                     |     4 +-
 drivers/net/hamradio/mkiss.c                       |     6 +-
 drivers/net/hamradio/scc.c                         |     7 +-
 drivers/net/hamradio/yam.c                         |     4 +-
 drivers/net/hippi/rrunner.c                        |     6 +-
 drivers/net/hyperv/netvsc_drv.c                    |     6 +-
 drivers/net/ieee802154/ca8210.c                    |     2 -
 drivers/net/ifb.c                                  |     5 +
 drivers/net/ipvlan/ipvlan_main.c                   |     4 +-
 drivers/net/ipvlan/ipvtap.c                        |     2 +-
 drivers/net/macsec.c                               |     4 +-
 drivers/net/macvlan.c                              |     7 +-
 drivers/net/macvtap.c                              |     2 +-
 drivers/net/net_failover.c                         |     3 +-
 drivers/net/netdevsim/bus.c                        |   155 +-
 drivers/net/netdevsim/dev.c                        |   204 +-
 drivers/net/netdevsim/ethtool.c                    |    28 +
 drivers/net/netdevsim/health.c                     |    32 -
 drivers/net/netdevsim/netdev.c                     |    72 +-
 drivers/net/netdevsim/netdevsim.h                  |    57 +-
 drivers/net/ntb_netdev.c                           |     2 +-
 drivers/net/pcs/pcs-xpcs.c                         |     2 +-
 drivers/net/phy/at803x.c                           |   778 +-
 drivers/net/phy/bcm7xxx.c                          |   203 +
 drivers/net/phy/broadcom.c                         |   106 +-
 drivers/net/phy/dp83867.c                          |    23 +-
 drivers/net/phy/dp83869.c                          |     4 +-
 drivers/net/phy/marvell10g.c                       |   107 +-
 drivers/net/phy/mdio_bus.c                         |    28 +
 drivers/net/phy/micrel.c                           |   107 +-
 drivers/net/phy/microchip_t1.c                     |   239 +
 drivers/net/phy/mscc/mscc_main.c                   |     2 +-
 drivers/net/phy/phy-c45.c                          |    35 +
 drivers/net/phy/phy_device.c                       |    10 +
 drivers/net/phy/phylink.c                          |   142 +-
 drivers/net/phy/realtek.c                          |     8 +
 drivers/net/phy/sfp-bus.c                          |     2 +-
 drivers/net/plip/plip.c                            |     8 +-
 drivers/net/ppp/ppp_generic.c                      |     2 +-
 drivers/net/rionet.c                               |    14 +-
 drivers/net/sb1000.c                               |    12 +-
 drivers/net/team/team.c                            |     2 +-
 drivers/net/thunderbolt.c                          |     8 +-
 drivers/net/usb/aqc111.c                           |     4 +-
 drivers/net/usb/asix_common.c                      |     2 +-
 drivers/net/usb/asix_devices.c                     |     2 +-
 drivers/net/usb/ax88172a.c                         |     2 +-
 drivers/net/usb/ax88179_178a.c                     |    12 +-
 drivers/net/usb/catc.c                             |    24 +-
 drivers/net/usb/cdc-phonet.c                       |     4 +-
 drivers/net/usb/ch9200.c                           |     4 +-
 drivers/net/usb/cx82310_eth.c                      |     5 +-
 drivers/net/usb/dm9601.c                           |     7 +-
 drivers/net/usb/ipheth.c                           |     2 +-
 drivers/net/usb/kalmia.c                           |     2 +-
 drivers/net/usb/kaweth.c                           |     3 +-
 drivers/net/usb/lan78xx.c                          |     4 +-
 drivers/net/usb/mcs7830.c                          |     9 +-
 drivers/net/usb/pegasus.c                          |     2 +-
 drivers/net/usb/qmi_wwan.c                         |     7 +-
 drivers/net/usb/r8152.c                            |     4 +-
 drivers/net/usb/rndis_host.c                       |     2 +-
 drivers/net/usb/rtl8150.c                          |     4 +-
 drivers/net/usb/sierra_net.c                       |     6 +-
 drivers/net/usb/smsc75xx.c                         |     9 +-
 drivers/net/usb/smsc95xx.c                         |     9 +-
 drivers/net/usb/sr9700.c                           |     9 +-
 drivers/net/usb/sr9800.c                           |     7 +-
 drivers/net/usb/usbnet.c                           |     6 +-
 drivers/net/virtio_net.c                           |    50 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |     8 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c              |    10 +-
 drivers/net/vrf.c                                  |    28 +-
 drivers/net/wan/hdlc_fr.c                          |     4 +-
 drivers/net/wan/lapbether.c                        |     2 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |     3 +-
 drivers/net/wireless/ath/ath10k/core.c             |    16 +-
 drivers/net/wireless/ath/ath10k/coredump.c         |    11 +-
 drivers/net/wireless/ath/ath10k/coredump.h         |     7 +
 drivers/net/wireless/ath/ath10k/mac.c              |    45 +-
 drivers/net/wireless/ath/ath10k/qmi.c              |     3 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |     6 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |    77 +
 drivers/net/wireless/ath/ath10k/snoc.h             |     5 +
 drivers/net/wireless/ath/ath10k/usb.c              |     7 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |     4 +
 drivers/net/wireless/ath/ath10k/wmi.h              |     3 +
 drivers/net/wireless/ath/ath11k/core.c             |    73 +-
 drivers/net/wireless/ath/ath11k/core.h             |    49 +-
 drivers/net/wireless/ath/ath11k/dbring.c           |    16 +-
 drivers/net/wireless/ath/ath11k/debugfs.c          |    27 +-
 drivers/net/wireless/ath/ath11k/debugfs.h          |     4 +
 .../net/wireless/ath/ath11k/debugfs_htt_stats.c    |  4344 +-
 .../net/wireless/ath/ath11k/debugfs_htt_stats.h    |   226 +
 drivers/net/wireless/ath/ath11k/debugfs_sta.c      |     8 +-
 drivers/net/wireless/ath/ath11k/dp.c               |    14 +-
 drivers/net/wireless/ath/ath11k/dp.h               |     9 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   282 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |    36 +-
 drivers/net/wireless/ath/ath11k/dp_tx.h            |     2 +-
 drivers/net/wireless/ath/ath11k/hal_desc.h         |     2 +
 drivers/net/wireless/ath/ath11k/hal_rx.c           |     6 +-
 drivers/net/wireless/ath/ath11k/hw.c               |    56 +-
 drivers/net/wireless/ath/ath11k/hw.h               |    24 +-
 drivers/net/wireless/ath/ath11k/mac.c              |  1445 +-
 drivers/net/wireless/ath/ath11k/mac.h              |     3 +
 drivers/net/wireless/ath/ath11k/pci.c              |    45 +-
 drivers/net/wireless/ath/ath11k/peer.c             |    11 +
 drivers/net/wireless/ath/ath11k/qmi.c              |   349 +-
 drivers/net/wireless/ath/ath11k/qmi.h              |    18 +-
 drivers/net/wireless/ath/ath11k/reg.c              |    18 +-
 drivers/net/wireless/ath/ath11k/reg.h              |     2 +-
 drivers/net/wireless/ath/ath11k/spectral.c         |    42 +-
 drivers/net/wireless/ath/ath11k/trace.h            |    11 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |   162 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |   107 +-
 drivers/net/wireless/ath/ath5k/sysfs.c             |     8 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |     9 +-
 drivers/net/wireless/ath/ath6kl/usb.c              |     7 +-
 .../net/wireless/ath/ath9k/ath9k_pci_owl_loader.c  |   105 +-
 drivers/net/wireless/ath/ath9k/debug.c             |    57 +-
 drivers/net/wireless/ath/ath9k/debug.h             |     1 +
 drivers/net/wireless/ath/ath9k/eeprom.c            |    12 +-
 drivers/net/wireless/ath/ath9k/hw.h                |     2 +
 drivers/net/wireless/ath/ath9k/init.c              |    58 +
 drivers/net/wireless/ath/ath9k/main.c              |     4 +-
 drivers/net/wireless/ath/dfs_pattern_detector.c    |    10 +-
 drivers/net/wireless/ath/spectral_common.h         |     1 -
 drivers/net/wireless/ath/wcn36xx/debug.c           |     2 +-
 drivers/net/wireless/ath/wcn36xx/dxe.c             |    49 +-
 drivers/net/wireless/ath/wcn36xx/hal.h             |    38 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |    55 +-
 drivers/net/wireless/ath/wcn36xx/pmc.c             |    13 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |   189 +-
 drivers/net/wireless/ath/wcn36xx/smd.h             |     4 +
 drivers/net/wireless/ath/wcn36xx/txrx.c            |   147 +-
 drivers/net/wireless/ath/wcn36xx/txrx.h            |     3 +-
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h         |     7 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c        |    10 +-
 drivers/net/wireless/ath/wil6210/main.c            |     6 +-
 drivers/net/wireless/ath/wil6210/wil6210.h         |     2 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |     2 +-
 drivers/net/wireless/atmel/atmel.c                 |    19 +-
 drivers/net/wireless/broadcom/b43/phy_g.c          |     2 +-
 drivers/net/wireless/broadcom/b43legacy/radio.c    |     2 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |    12 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |     6 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/dmi.c |    10 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |     2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |     4 +-
 drivers/net/wireless/cisco/airo.c                  |    27 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |     4 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |    12 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.h       |     2 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |     1 -
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |     1 -
 drivers/net/wireless/intel/iwlwifi/Makefile        |     2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/1000.c      |     5 -
 drivers/net/wireless/intel/iwlwifi/cfg/2000.c      |     5 -
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |    35 +-
 drivers/net/wireless/intel/iwlwifi/cfg/5000.c      |     5 -
 drivers/net/wireless/intel/iwlwifi/cfg/6000.c      |     5 -
 drivers/net/wireless/intel/iwlwifi/dvm/agn.h       |    11 +-
 drivers/net/wireless/intel/iwlwifi/dvm/debugfs.c   |     4 -
 drivers/net/wireless/intel/iwlwifi/dvm/dev.h       |     5 -
 drivers/net/wireless/intel/iwlwifi/dvm/devices.c   |     5 -
 drivers/net/wireless/intel/iwlwifi/dvm/led.c       |     5 -
 drivers/net/wireless/intel/iwlwifi/dvm/led.h       |     5 -
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c       |     5 -
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c  |     5 -
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |     7 -
 drivers/net/wireless/intel/iwlwifi/dvm/power.c     |     4 -
 drivers/net/wireless/intel/iwlwifi/dvm/power.h     |     4 -
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c        |     5 -
 drivers/net/wireless/intel/iwlwifi/dvm/rs.h        |     5 -
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c        |     5 -
 drivers/net/wireless/intel/iwlwifi/dvm/rxon.c      |     5 -
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c      |     4 -
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c       |     5 -
 drivers/net/wireless/intel/iwlwifi/dvm/tt.c        |     4 -
 drivers/net/wireless/intel/iwlwifi/dvm/tt.h        |     4 -
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c        |     5 -
 drivers/net/wireless/intel/iwlwifi/dvm/ucode.c     |     5 -
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |   150 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |    43 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h     |    45 +-
 .../net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h    |    57 +
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h  |    35 +
 .../net/wireless/intel/iwlwifi/fw/api/location.h   |    10 +-
 .../net/wireless/intel/iwlwifi/fw/api/mac-cfg.h    |    10 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h    |     3 +
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |    23 +
 drivers/net/wireless/intel/iwlwifi/fw/api/phy.h    |     6 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h  |    55 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     |   234 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |    31 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/sta.h    |     2 +
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |    40 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |    46 +-
 drivers/net/wireless/intel/iwlwifi/fw/dump.c       |     9 +-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |     4 -
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |    12 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.c        |    58 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |    12 +
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |     6 +-
 drivers/net/wireless/intel/iwlwifi/fw/paging.c     |     4 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |    15 +-
 drivers/net/wireless/intel/iwlwifi/fw/rs.c         |   252 +
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |     7 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.h       |     5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |     8 +-
 .../wireless/intel/iwlwifi/iwl-context-info-gen3.h |     4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |     8 +
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |   228 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h   |     2 +
 drivers/net/wireless/intel/iwlwifi/iwl-debug.c     |    24 +-
 drivers/net/wireless/intel/iwlwifi/iwl-debug.h     |    26 +-
 .../net/wireless/intel/iwlwifi/iwl-devtrace-data.h |     5 -
 .../net/wireless/intel/iwlwifi/iwl-devtrace-io.h   |     5 -
 .../wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h  |     5 -
 .../net/wireless/intel/iwlwifi/iwl-devtrace-msg.h  |     5 -
 .../wireless/intel/iwlwifi/iwl-devtrace-ucode.h    |     5 -
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c  |     5 -
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h  |     5 -
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |    44 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h       |     3 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-read.c   |     4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        |    50 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.h        |     5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |    17 +
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |    36 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |    30 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   362 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |    19 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |    15 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-responder.c |    15 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   106 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |    44 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   269 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |    17 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |     5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   194 +-
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |    28 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |    16 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   182 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        |    17 -
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |    39 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   119 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |    10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   117 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |    54 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |     4 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   306 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |     9 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |    38 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |    90 +-
 drivers/net/wireless/intersil/hostap/hostap_hw.c   |     5 +-
 drivers/net/wireless/intersil/hostap/hostap_main.c |     4 +-
 drivers/net/wireless/intersil/orinoco/main.c       |     2 +-
 drivers/net/wireless/mac80211_hwsim.c              |   163 +-
 drivers/net/wireless/marvell/libertas/cmd.c        |     5 +-
 drivers/net/wireless/marvell/libertas/if_usb.c     |     2 +
 drivers/net/wireless/marvell/libertas/main.c       |     4 +-
 drivers/net/wireless/marvell/libertas/mesh.c       |    18 +-
 drivers/net/wireless/marvell/libertas_tf/if_usb.c  |     2 +
 drivers/net/wireless/marvell/mwifiex/11n.c         |     7 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   384 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |    21 +
 drivers/net/wireless/marvell/mwifiex/main.c        |    22 +-
 drivers/net/wireless/marvell/mwifiex/main.h        |     1 +
 drivers/net/wireless/marvell/mwifiex/pcie.c        |    36 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |     4 +
 drivers/net/wireless/marvell/mwifiex/uap_event.c   |     3 +-
 drivers/net/wireless/marvell/mwifiex/usb.c         |    16 +
 drivers/net/wireless/marvell/mwl8k.c               |     2 +-
 drivers/net/wireless/mediatek/mt76/Makefile        |     2 +-
 drivers/net/wireless/mediatek/mt76/debugfs.c       |    22 +-
 drivers/net/wireless/mediatek/mt76/eeprom.c        |    19 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   242 +-
 drivers/net/wireless/mediatek/mt76/mcu.c           |     8 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   126 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |    11 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |     3 +
 drivers/net/wireless/mediatek/mt76/mt7603/pci.c    |     2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/Makefile |     2 +-
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |    29 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |     6 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |    62 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |    14 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |    90 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |    20 +-
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c    |     4 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_mac.c    |     5 +-
 drivers/net/wireless/mediatek/mt76/mt7615/sdio.c   |   296 +-
 .../net/wireless/mediatek/mt76/mt7615/sdio_mcu.c   |    11 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_sdio.c   |     2 +-
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |     7 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   357 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |    38 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |     2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |     4 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |    15 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |    12 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |     3 +
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c    |     5 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |   542 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   170 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |   652 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.h    |    11 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   366 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  1192 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |   128 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |     6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |   161 +-
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |     5 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |   166 +-
 .../net/wireless/mediatek/mt76/mt7915/testmode.c   |    23 +
 .../net/wireless/mediatek/mt76/mt7915/testmode.h   |     6 +
 drivers/net/wireless/mediatek/mt76/mt7921/Kconfig  |    19 +-
 drivers/net/wireless/mediatek/mt76/mt7921/Makefile |     7 +-
 .../net/wireless/mediatek/mt76/mt7921/debugfs.c    |    99 +-
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c    |    74 +-
 drivers/net/wireless/mediatek/mt76/mt7921/eeprom.c |   100 -
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |    96 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |   776 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.h    |    32 +
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   328 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   448 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h    |    63 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |   179 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |    66 +-
 .../net/wireless/mediatek/mt76/mt7921/pci_mac.c    |   348 +
 .../net/wireless/mediatek/mt76/mt7921/pci_mcu.c    |   115 +
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |    58 +-
 drivers/net/wireless/mediatek/mt76/mt7921/sdio.c   |   317 +
 .../net/wireless/mediatek/mt76/mt7921/sdio_mac.c   |   220 +
 .../net/wireless/mediatek/mt76/mt7921/sdio_mcu.c   |   135 +
 .../net/wireless/mediatek/mt76/mt7921/testmode.c   |   197 +
 drivers/net/wireless/mediatek/mt76/sdio.c          |   303 +-
 .../net/wireless/mediatek/mt76/{mt7615 => }/sdio.h |    33 +-
 .../mediatek/mt76/{mt7615 => }/sdio_txrx.c         |   134 +-
 drivers/net/wireless/mediatek/mt76/testmode.c      |     4 +-
 drivers/net/wireless/mediatek/mt76/testmode.h      |     7 +
 drivers/net/wireless/mediatek/mt76/tx.c            |    84 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |     2 +-
 drivers/net/wireless/mediatek/mt76/util.h          |    10 +-
 drivers/net/wireless/mediatek/mt7601u/dma.c        |     2 +-
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |    11 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      |    31 +-
 drivers/net/wireless/microchip/wilc1000/hif.h      |     1 +
 drivers/net/wireless/microchip/wilc1000/netdev.c   |    14 +-
 drivers/net/wireless/microchip/wilc1000/netdev.h   |     5 +-
 drivers/net/wireless/microchip/wilc1000/sdio.c     |     1 +
 drivers/net/wireless/microchip/wilc1000/spi.c      |    91 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c     |   134 +-
 drivers/net/wireless/microchip/wilc1000/wlan.h     |     5 +-
 drivers/net/wireless/microchip/wilc1000/wlan_cfg.c |     1 +
 drivers/net/wireless/microchip/wilc1000/wlan_if.h  |     7 +-
 drivers/net/wireless/quantenna/qtnfmac/core.c      |     6 +-
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c |     2 -
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c     |     1 -
 drivers/net/wireless/ray_cs.c                      |     2 +-
 drivers/net/wireless/realtek/Kconfig               |     1 +
 drivers/net/wireless/realtek/Makefile              |     1 +
 .../net/wireless/realtek/rtl818x/rtl8187/rtl8225.c |    14 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |     6 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |     2 +
 drivers/net/wireless/realtek/rtlwifi/pci.c         |     1 -
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.c    |     2 +-
 drivers/net/wireless/realtek/rtw88/debug.c         |    46 +-
 drivers/net/wireless/realtek/rtw88/debug.h         |     1 +
 drivers/net/wireless/realtek/rtw88/fw.c            |    54 +-
 drivers/net/wireless/realtek/rtw88/fw.h            |    24 +
 drivers/net/wireless/realtek/rtw88/main.c          |    22 +-
 drivers/net/wireless/realtek/rtw88/main.h          |    49 +-
 drivers/net/wireless/realtek/rtw88/phy.c           |   119 +-
 drivers/net/wireless/realtek/rtw88/phy.h           |     2 +
 drivers/net/wireless/realtek/rtw88/reg.h           |     6 +
 drivers/net/wireless/realtek/rtw88/regd.c          |   753 +-
 drivers/net/wireless/realtek/rtw88/regd.h          |     8 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |    19 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |    46 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.h      |     8 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |    47 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.h      |     3 +
 drivers/net/wireless/realtek/rtw89/Kconfig         |    50 +
 drivers/net/wireless/realtek/rtw89/Makefile        |    25 +
 drivers/net/wireless/realtek/rtw89/cam.c           |   695 +
 drivers/net/wireless/realtek/rtw89/cam.h           |   165 +
 drivers/net/wireless/realtek/rtw89/coex.c          |  5716 +++
 drivers/net/wireless/realtek/rtw89/coex.h          |   181 +
 drivers/net/wireless/realtek/rtw89/core.c          |  2502 +
 drivers/net/wireless/realtek/rtw89/core.h          |  3384 ++
 drivers/net/wireless/realtek/rtw89/debug.c         |  2489 +
 drivers/net/wireless/realtek/rtw89/debug.h         |    77 +
 drivers/net/wireless/realtek/rtw89/efuse.c         |   188 +
 drivers/net/wireless/realtek/rtw89/efuse.h         |    13 +
 drivers/net/wireless/realtek/rtw89/fw.c            |  1641 +
 drivers/net/wireless/realtek/rtw89/fw.h            |  1378 +
 drivers/net/wireless/realtek/rtw89/mac.c           |  3836 ++
 drivers/net/wireless/realtek/rtw89/mac.h           |   860 +
 drivers/net/wireless/realtek/rtw89/mac80211.c      |   676 +
 drivers/net/wireless/realtek/rtw89/pci.c           |  3060 ++
 drivers/net/wireless/realtek/rtw89/pci.h           |   630 +
 drivers/net/wireless/realtek/rtw89/phy.c           |  2868 ++
 drivers/net/wireless/realtek/rtw89/phy.h           |   311 +
 drivers/net/wireless/realtek/rtw89/ps.c            |   150 +
 drivers/net/wireless/realtek/rtw89/ps.h            |    16 +
 drivers/net/wireless/realtek/rtw89/reg.h           |  2159 +
 drivers/net/wireless/realtek/rtw89/regd.c          |   353 +
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |  2036 +
 drivers/net/wireless/realtek/rtw89/rtw8852a.h      |   109 +
 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk.c  |  3911 ++
 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk.h  |    24 +
 .../wireless/realtek/rtw89/rtw8852a_rfk_table.c    |  1607 +
 .../wireless/realtek/rtw89/rtw8852a_rfk_table.h    |   133 +
 .../net/wireless/realtek/rtw89/rtw8852a_table.c    | 48725 +++++++++++++++++++
 .../net/wireless/realtek/rtw89/rtw8852a_table.h    |    28 +
 drivers/net/wireless/realtek/rtw89/sar.c           |   190 +
 drivers/net/wireless/realtek/rtw89/sar.h           |    26 +
 drivers/net/wireless/realtek/rtw89/ser.c           |   491 +
 drivers/net/wireless/realtek/rtw89/ser.h           |    15 +
 drivers/net/wireless/realtek/rtw89/txrx.h          |   358 +
 drivers/net/wireless/realtek/rtw89/util.h          |    17 +
 drivers/net/wireless/rndis_wlan.c                  |     2 -
 drivers/net/wireless/rsi/rsi_91x_core.c            |     2 +
 drivers/net/wireless/rsi/rsi_91x_hal.c             |    10 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |    74 +-
 drivers/net/wireless/rsi/rsi_91x_main.c            |    17 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |    24 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |     5 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c             |     7 +-
 drivers/net/wireless/rsi/rsi_hal.h                 |    11 +
 drivers/net/wireless/rsi/rsi_main.h                |    15 +-
 drivers/net/wireless/st/cw1200/bh.c                |     2 -
 drivers/net/wireless/ti/wlcore/spi.c               |     9 +-
 drivers/net/wireless/wl3501_cs.c                   |     3 +-
 drivers/net/wireless/zydas/zd1201.c                |     9 +-
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c       |     1 -
 drivers/net/wwan/Kconfig                           |     1 +
 drivers/net/wwan/iosm/Makefile                     |     5 +-
 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c          |     6 +-
 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.h          |     1 +
 drivers/net/wwan/iosm/iosm_ipc_coredump.c          |   125 +
 drivers/net/wwan/iosm/iosm_ipc_coredump.h          |    59 +
 drivers/net/wwan/iosm/iosm_ipc_devlink.c           |   321 +
 drivers/net/wwan/iosm/iosm_ipc_devlink.h           |   205 +
 drivers/net/wwan/iosm/iosm_ipc_flash.c             |   594 +
 drivers/net/wwan/iosm/iosm_ipc_flash.h             |   229 +
 drivers/net/wwan/iosm/iosm_ipc_imem.c              |   107 +-
 drivers/net/wwan/iosm/iosm_ipc_imem.h              |    18 +-
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c          |   317 +
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h          |    49 +-
 drivers/net/xen-netback/interface.c                |     6 +-
 drivers/net/xen-netback/netback.c                  |     2 +-
 drivers/net/xen-netfront.c                         |     4 +-
 drivers/nfc/fdp/i2c.c                              |     1 -
 drivers/nfc/microread/i2c.c                        |     4 -
 drivers/nfc/microread/mei.c                        |     6 +-
 drivers/nfc/nfcmrvl/fw_dnld.c                      |     4 +-
 drivers/nfc/pn533/i2c.c                            |     6 +-
 drivers/nfc/pn533/pn533.c                          |     6 +-
 drivers/nfc/pn533/pn533.h                          |     4 +-
 drivers/nfc/pn533/uart.c                           |     4 +-
 drivers/nfc/pn533/usb.c                            |     2 +-
 drivers/nfc/pn544/mei.c                            |     8 +-
 drivers/nfc/s3fwrn5/firmware.c                     |    29 +-
 drivers/nfc/s3fwrn5/nci.c                          |    18 +-
 drivers/nfc/st-nci/i2c.c                           |     4 -
 drivers/nfc/st-nci/ndlc.c                          |     4 -
 drivers/nfc/st-nci/se.c                            |     6 -
 drivers/nfc/st-nci/spi.c                           |     4 -
 drivers/nfc/st21nfca/i2c.c                         |     4 -
 drivers/nfc/st21nfca/se.c                          |     4 -
 drivers/nfc/trf7970a.c                             |     8 -
 drivers/of/Kconfig                                 |     4 -
 drivers/of/Makefile                                |     1 -
 drivers/pcmcia/pcmcia_cis.c                        |     5 +-
 drivers/phy/broadcom/phy-bcm-ns-usb3.c             |     2 +-
 drivers/phy/broadcom/phy-bcm-ns2-pcie.c            |     6 +-
 drivers/ptp/idt8a340_reg.h                         |   720 -
 drivers/ptp/ptp_clock.c                            |     6 +-
 drivers/ptp/ptp_clockmatrix.c                      |  1588 +-
 drivers/ptp/ptp_clockmatrix.h                      |   109 +-
 drivers/ptp/ptp_ocp.c                              |  1354 +-
 drivers/s390/cio/qdio_setup.c                      |    34 +-
 drivers/s390/net/ctcm_fsms.c                       |    60 +-
 drivers/s390/net/ctcm_main.c                       |    38 +-
 drivers/s390/net/ctcm_mpc.c                        |     8 +-
 drivers/s390/net/fsm.c                             |     2 +-
 drivers/s390/net/ism_drv.c                         |     2 +-
 drivers/s390/net/lcs.c                             |   123 +-
 drivers/s390/net/netiucv.c                         |   104 +-
 drivers/s390/net/qeth_core.h                       |     4 +-
 drivers/s390/net/qeth_core_main.c                  |    63 +-
 drivers/s390/net/qeth_l2_main.c                    |    33 +-
 drivers/s390/net/qeth_l3_main.c                    |    15 +-
 drivers/scsi/qedf/drv_fcoe_fw_funcs.c              |     8 +-
 drivers/scsi/qedf/drv_fcoe_fw_funcs.h              |     2 +-
 drivers/scsi/qedf/qedf.h                           |     4 +-
 drivers/scsi/qedf/qedf_els.c                       |     2 +-
 drivers/scsi/qedf/qedf_io.c                        |    12 +-
 drivers/scsi/qedf/qedf_main.c                      |    10 +-
 drivers/scsi/qedi/qedi_debugfs.c                   |     4 +-
 drivers/scsi/qedi/qedi_fw.c                        |    40 +-
 drivers/scsi/qedi/qedi_fw_api.c                    |    22 +-
 drivers/scsi/qedi/qedi_fw_iscsi.h                  |     2 +-
 drivers/scsi/qedi/qedi_iscsi.h                     |     2 +-
 drivers/scsi/qedi/qedi_main.c                      |    11 +-
 drivers/soc/fsl/Kconfig                            |     1 +
 drivers/soc/fsl/dpio/dpio-cmd.h                    |     3 +
 drivers/soc/fsl/dpio/dpio-driver.c                 |     1 +
 drivers/soc/fsl/dpio/dpio-service.c                |   117 +
 drivers/soc/fsl/dpio/dpio.c                        |     1 +
 drivers/soc/fsl/dpio/dpio.h                        |     2 +
 drivers/soc/fsl/dpio/qbman-portal.c                |    58 +
 drivers/soc/fsl/dpio/qbman-portal.h                |    13 +
 drivers/staging/octeon/ethernet.c                  |     2 +-
 drivers/staging/qlge/qlge_main.c                   |    12 +-
 drivers/usb/gadget/function/f_phonet.c             |     5 +-
 drivers/vdpa/mlx5/core/mlx5_vdpa.h                 |     8 +-
 drivers/vdpa/mlx5/core/mr.c                        |     8 +-
 drivers/vdpa/mlx5/core/resources.c                 |    13 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |     2 +-
 include/linux/avf/virtchnl.h                       |    41 +-
 include/linux/bitmap.h                             |     2 +
 include/linux/bpf-cgroup.h                         |     1 +
 include/linux/bpf.h                                |    66 +-
 include/linux/bpf_types.h                          |     1 +
 include/linux/bpf_verifier.h                       |     2 +
 include/linux/bpfptr.h                             |     1 +
 include/linux/brcmphy.h                            |    11 +
 include/linux/btf.h                                |    39 +
 include/linux/can/bittiming.h                      |    89 +-
 include/linux/can/dev.h                            |    34 +
 include/linux/dsa/8021q.h                          |     5 +-
 include/linux/dsa/ocelot.h                         |     4 +-
 include/linux/dsa/sja1105.h                        |     1 -
 include/linux/etherdevice.h                        |    37 +-
 include/linux/ethtool.h                            |    23 +
 include/linux/filter.h                             |    22 +-
 include/linux/ieee80211.h                          |    39 +
 include/linux/inetdevice.h                         |     2 +
 include/linux/ipv6.h                               |     2 +-
 include/linux/mdio.h                               |    26 +
 include/linux/mfd/idt8a340_reg.h                   |    31 +-
 include/linux/micrel_phy.h                         |     1 +
 include/linux/mlx4/device.h                        |     2 +-
 include/linux/mlx4/driver.h                        |    22 -
 include/linux/mlx5/device.h                        |    63 +-
 include/linux/mlx5/driver.h                        |    61 +-
 include/linux/mlx5/eq.h                            |     1 -
 include/linux/mlx5/eswitch.h                       |     9 +
 include/linux/mlx5/fs.h                            |    15 +
 include/linux/mlx5/mlx5_ifc.h                      |   450 +-
 include/linux/mm_types.h                           |    13 +-
 include/linux/netdevice.h                          |    17 +-
 include/linux/netfilter_arp/arp_tables.h           |     5 +-
 include/linux/netfilter_bridge/ebtables.h          |     5 +-
 include/linux/netfilter_ingress.h                  |    58 -
 include/linux/netfilter_ipv4/ip_tables.h           |     6 +-
 include/linux/netfilter_ipv6/ip6_tables.h          |     5 +-
 include/linux/netfilter_netdev.h                   |   146 +
 include/linux/netlink.h                            |     4 -
 include/linux/of_net.h                             |     8 +-
 include/linux/perf_event.h                         |    23 +
 include/linux/phy.h                                |    35 +
 include/linux/phylink.h                            |    14 +-
 include/linux/platform_data/brcmfmac.h             |     2 +-
 include/linux/property.h                           |     5 +-
 include/linux/qed/common_hsi.h                     |   141 +-
 include/linux/qed/eth_common.h                     |     1 +
 include/linux/qed/fcoe_common.h                    |   362 +-
 include/linux/qed/iscsi_common.h                   |   360 +-
 include/linux/qed/nvmetcp_common.h                 |    18 +-
 include/linux/qed/qed_chain.h                      |    97 +-
 include/linux/qed/qed_eth_if.h                     |    23 +-
 include/linux/qed/qed_if.h                         |   265 +-
 include/linux/qed/qed_iscsi_if.h                   |     2 +-
 include/linux/qed/qed_ll2_if.h                     |    42 +-
 include/linux/qed/qed_nvmetcp_if.h                 |    17 +
 include/linux/qed/qed_rdma_if.h                    |     3 +-
 include/linux/qed/rdma_common.h                    |     1 +
 include/linux/skbuff.h                             |     7 +
 include/linux/skmsg.h                              |    18 +-
 include/linux/soc/marvell/octeontx2/asm.h          |    15 +
 include/linux/socket.h                             |     2 +
 include/linux/u64_stats_sync.h                     |    10 +
 include/net/act_api.h                              |    10 +-
 include/net/amt.h                                  |   385 +
 include/net/ax25.h                                 |    13 +-
 include/net/bluetooth/bluetooth.h                  |    90 +
 include/net/bluetooth/hci.h                        |   117 +
 include/net/bluetooth/hci_core.h                   |    75 +-
 include/net/busy_poll.h                            |     3 +-
 include/net/cfg80211.h                             |    79 +-
 include/net/codel.h                                |     5 +
 include/net/codel_impl.h                           |    18 +-
 include/net/datalink.h                             |     2 +-
 include/net/devlink.h                              |   128 +-
 include/net/dn.h                                   |     2 +-
 include/net/dsa.h                                  |    46 +-
 include/net/flow_dissector.h                       |     1 +
 include/net/gen_stats.h                            |    59 +-
 include/net/inet_connection_sock.h                 |     2 +-
 include/net/inet_ecn.h                             |    17 +
 include/net/inet_sock.h                            |     3 +-
 include/net/ioam6.h                                |     3 +-
 include/net/ip.h                                   |     8 +-
 include/net/ip_vs.h                                |    11 +
 include/net/ipv6.h                                 |     1 +
 include/net/llc.h                                  |     2 +-
 include/net/llc_if.h                               |     3 +-
 include/net/mac80211.h                             |    11 +
 include/net/mctp.h                                 |    82 +-
 include/net/mctpdevice.h                           |    21 +
 include/net/mptcp.h                                |     4 +
 include/net/ndisc.h                                |     2 +-
 include/net/neighbour.h                            |    45 +-
 include/net/netfilter/nf_tables.h                  |    10 +-
 include/net/netfilter/nf_tables_ipv4.h             |     7 +-
 include/net/netfilter/nf_tables_ipv6.h             |     6 +-
 include/net/netfilter/xt_rateest.h                 |     2 +-
 include/net/page_pool.h                            |    12 +-
 include/net/pkt_cls.h                              |     6 +-
 include/net/rose.h                                 |     8 +-
 include/net/sch_generic.h                          |    86 +-
 include/net/sctp/sctp.h                            |     7 +-
 include/net/sock.h                                 |   129 +-
 include/net/switchdev.h                            |    48 +-
 include/net/tcp.h                                  |    52 +-
 include/net/tls.h                                  |     5 +-
 include/net/xdp.h                                  |     8 +-
 include/net/xdp_sock_drv.h                         |    22 +
 include/net/xsk_buff_pool.h                        |    48 +-
 include/soc/fsl/dpaa2-io.h                         |     9 +
 include/soc/mscc/ocelot.h                          |    27 +-
 include/soc/mscc/ocelot_vcap.h                     |    10 +
 include/trace/bpf_probe.h                          |    19 +-
 include/trace/events/devlink.h                     |    72 +-
 include/trace/events/mctp.h                        |    75 +
 include/uapi/asm-generic/socket.h                  |     2 +
 include/uapi/linux/amt.h                           |    62 +
 include/uapi/linux/bpf.h                           |    76 +-
 include/uapi/linux/btf.h                           |    55 +-
 include/uapi/linux/can/netlink.h                   |    31 +-
 include/uapi/linux/devlink.h                       |     2 +
 include/uapi/linux/ethtool.h                       |    29 +
 include/uapi/linux/ethtool_netlink.h               |    17 +
 include/uapi/linux/if_ether.h                      |     1 +
 include/uapi/linux/ioam6_iptunnel.h                |    29 +
 include/uapi/linux/ip.h                            |     1 +
 include/uapi/linux/ipv6.h                          |     1 +
 include/uapi/linux/mctp.h                          |    11 +
 include/uapi/linux/mdio.h                          |     9 +
 include/uapi/linux/mptcp.h                         |    35 +
 include/uapi/linux/neighbour.h                     |    35 +-
 include/uapi/linux/netfilter.h                     |     1 +
 include/uapi/linux/netfilter/nf_tables.h           |     6 +-
 include/uapi/linux/nl80211-vnd-intel.h             |    29 +
 include/uapi/linux/nl80211.h                       |   115 +-
 include/uapi/linux/pkt_sched.h                     |     2 +
 include/uapi/linux/smc.h                           |    44 +-
 include/uapi/linux/sysctl.h                        |     1 +
 include/uapi/linux/tls.h                           |    30 +
 include/uapi/linux/vm_sockets.h                    |    13 +-
 kernel/bpf/Kconfig                                 |     7 +
 kernel/bpf/Makefile                                |     2 +-
 kernel/bpf/arraymap.c                              |     7 +-
 kernel/bpf/bloom_filter.c                          |   204 +
 kernel/bpf/bpf_struct_ops.c                        |    32 +-
 kernel/bpf/bpf_struct_ops_types.h                  |     3 +
 kernel/bpf/btf.c                                   |   183 +
 kernel/bpf/core.c                                  |     9 +
 kernel/bpf/hashtab.c                               |    13 +-
 kernel/bpf/helpers.c                               |    11 +-
 kernel/bpf/preload/.gitignore                      |     4 +-
 kernel/bpf/preload/Makefile                        |    26 +-
 kernel/bpf/preload/iterators/Makefile              |    38 +-
 kernel/bpf/syscall.c                               |    77 +-
 kernel/bpf/trampoline.c                            |    15 +-
 kernel/bpf/verifier.c                              |   373 +-
 kernel/events/core.c                               |     2 +
 kernel/trace/bpf_trace.c                           |   102 +-
 lib/bitmap.c                                       |    13 +
 lib/test_bpf.c                                     | 17416 ++++---
 net/802/hippi.c                                    |     2 +-
 net/802/p8022.c                                    |     2 +-
 net/802/psnap.c                                    |     2 +-
 net/8021q/vlan_dev.c                               |     6 +-
 net/Kconfig                                        |     2 +-
 net/atm/br2684.c                                   |     6 +-
 net/atm/lec.c                                      |     8 +-
 net/ax25/af_ax25.c                                 |     2 +-
 net/ax25/ax25_dev.c                                |     2 +-
 net/ax25/ax25_iface.c                              |     6 +-
 net/ax25/ax25_in.c                                 |     4 +-
 net/ax25/ax25_out.c                                |     2 +-
 net/batman-adv/bridge_loop_avoidance.c             |    14 +-
 net/batman-adv/multicast.c                         |     2 +-
 net/batman-adv/routing.c                           |     3 +-
 net/batman-adv/soft-interface.c                    |     2 +-
 net/batman-adv/tp_meter.c                          |     2 +-
 net/batman-adv/tvlv.c                              |     4 +-
 net/batman-adv/tvlv.h                              |     4 +-
 net/bluetooth/6lowpan.c                            |     4 +-
 net/bluetooth/Makefile                             |     3 +-
 net/bluetooth/bnep/core.c                          |     2 +-
 net/bluetooth/eir.c                                |   335 +
 net/bluetooth/eir.h                                |    72 +
 net/bluetooth/hci_codec.c                          |   238 +
 net/bluetooth/hci_codec.h                          |     7 +
 net/bluetooth/hci_conn.c                           |   168 +-
 net/bluetooth/hci_core.c                           |   320 +-
 net/bluetooth/hci_debugfs.c                        |   123 +
 net/bluetooth/hci_debugfs.h                        |     5 +
 net/bluetooth/hci_event.c                          |   135 +-
 net/bluetooth/hci_request.c                        |   478 +-
 net/bluetooth/hci_request.h                        |    25 +-
 net/bluetooth/hci_sock.c                           |   214 +-
 net/bluetooth/l2cap_core.c                         |     2 +-
 net/bluetooth/l2cap_sock.c                         |    10 +-
 net/bluetooth/mgmt.c                               |   445 +-
 net/bluetooth/msft.c                               |   172 +-
 net/bluetooth/msft.h                               |     9 +
 net/bluetooth/rfcomm/core.c                        |    50 +-
 net/bluetooth/rfcomm/sock.c                        |    46 +-
 net/bluetooth/sco.c                                |   209 +-
 net/bpf/Makefile                                   |     3 +
 net/bpf/bpf_dummy_struct_ops.c                     |   200 +
 net/bpf/test_run.c                                 |    50 +-
 net/bridge/br.c                                    |     4 +-
 net/bridge/br_fdb.c                                |   439 +-
 net/bridge/br_if.c                                 |     4 +-
 net/bridge/br_ioctl.c                              |    10 +-
 net/bridge/br_mdb.c                                |   242 +-
 net/bridge/br_netfilter_hooks.c                    |     2 +-
 net/bridge/br_netlink.c                            |     4 +-
 net/bridge/br_private.h                            |    41 +-
 net/bridge/br_stp_if.c                             |     2 +-
 net/bridge/br_switchdev.c                          |   438 +-
 net/bridge/br_vlan.c                               |    89 +-
 net/bridge/netfilter/ebtable_broute.c              |     2 +-
 net/bridge/netfilter/ebtable_filter.c              |    13 +-
 net/bridge/netfilter/ebtable_nat.c                 |    12 +-
 net/bridge/netfilter/ebtables.c                    |    13 +-
 net/caif/caif_usb.c                                |     2 +-
 net/can/bcm.c                                      |     2 +-
 net/core/Makefile                                  |     1 +
 net/core/dev.c                                     |    92 +-
 net/core/dev_ioctl.c                               |     2 -
 net/core/devlink.c                                 |   825 +-
 net/core/filter.c                                  |    44 +
 net/core/flow_dissector.c                          |    18 +-
 net/core/gen_estimator.c                           |    52 +-
 net/core/gen_stats.c                               |   186 +-
 net/core/neighbour.c                               |   204 +-
 net/core/net-sysfs.c                               |    57 +-
 net/core/net_namespace.c                           |     4 +
 {drivers/of => net/core}/of_net.c                  |    25 +
 net/core/page_pool.c                               |    10 +-
 net/core/rtnetlink.c                               |    13 +-
 net/core/selftests.c                               |     8 +-
 net/core/skbuff.c                                  |    46 +-
 net/core/skmsg.c                                   |    43 +-
 net/core/sock.c                                    |   104 +-
 net/core/stream.c                                  |     5 +-
 net/core/xdp.c                                     |     2 -
 net/dccp/dccp.h                                    |     2 +-
 net/dccp/proto.c                                   |    14 +-
 net/dsa/Kconfig                                    |    20 +-
 net/dsa/Makefile                                   |     3 +-
 net/dsa/dsa.c                                      |    22 +-
 net/dsa/dsa2.c                                     |    77 +-
 net/dsa/port.c                                     |    27 +-
 net/dsa/slave.c                                    |    90 +-
 net/dsa/switch.c                                   |   249 +-
 net/dsa/tag_8021q.c                                |   114 +-
 net/dsa/tag_ksz.c                                  |     1 -
 net/dsa/tag_ocelot.c                               |    39 +
 net/dsa/tag_ocelot_8021q.c                         |     2 +-
 net/dsa/tag_rtl4_a.c                               |     2 +-
 net/dsa/tag_rtl8_4.c                               |   178 +
 net/dsa/tag_sja1105.c                              |     9 +-
 net/ethernet/eth.c                                 |   102 +-
 net/ethtool/Makefile                               |     2 +-
 net/ethtool/ioctl.c                                |   171 +-
 net/ethtool/module.c                               |   180 +
 net/ethtool/netlink.c                              |    19 +
 net/ethtool/netlink.h                              |     4 +
 net/hsr/hsr_device.c                               |    10 +-
 net/hsr/hsr_forward.c                              |    54 +-
 net/hsr/hsr_framereg.c                             |    65 +-
 net/hsr/hsr_framereg.h                             |     4 +-
 net/hsr/hsr_main.c                                 |     2 +-
 net/hsr/hsr_main.h                                 |    16 +-
 net/ieee802154/6lowpan/core.c                      |     2 +-
 net/ipv4/af_inet.c                                 |    30 +-
 net/ipv4/arp.c                                     |    11 +-
 net/ipv4/bpf_tcp_ca.c                              |    45 +-
 net/ipv4/cipso_ipv4.c                              |     2 +-
 net/ipv4/datagram.c                                |     1 -
 net/ipv4/devinet.c                                 |     4 +
 net/ipv4/fib_notifier.c                            |     1 -
 net/ipv4/inet_connection_sock.c                    |     4 +-
 net/ipv4/inet_diag.c                               |     2 +-
 net/ipv4/inet_hashtables.c                         |     2 +-
 net/ipv4/ip_gre.c                                  |     2 +-
 net/ipv4/ip_sockglue.c                             |    11 +-
 net/ipv4/ip_tunnel.c                               |     2 +-
 net/ipv4/ip_vti.c                                  |     2 +-
 net/ipv4/ipconfig.c                                |    12 +-
 net/ipv4/ipip.c                                    |     2 +-
 net/ipv4/netfilter/arp_tables.c                    |     7 +-
 net/ipv4/netfilter/arptable_filter.c               |    10 +-
 net/ipv4/netfilter/ip_tables.c                     |     7 +-
 net/ipv4/netfilter/iptable_filter.c                |     9 +-
 net/ipv4/netfilter/iptable_mangle.c                |     8 +-
 net/ipv4/netfilter/iptable_nat.c                   |    15 +-
 net/ipv4/netfilter/iptable_raw.c                   |    10 +-
 net/ipv4/netfilter/iptable_security.c              |     9 +-
 net/ipv4/proc.c                                    |     2 +-
 net/ipv4/route.c                                   |     8 -
 net/ipv4/syncookies.c                              |     2 -
 net/ipv4/sysctl_net_ipv4.c                         |    21 -
 net/ipv4/tcp.c                                     |   132 +-
 net/ipv4/tcp_bbr.c                                 |    28 +-
 net/ipv4/tcp_cubic.c                               |    26 +-
 net/ipv4/tcp_dctcp.c                               |    26 +-
 net/ipv4/tcp_fastopen.c                            |     6 -
 net/ipv4/tcp_input.c                               |    37 +-
 net/ipv4/tcp_ipv4.c                                |    31 +-
 net/ipv4/tcp_minisocks.c                           |     7 -
 net/ipv4/tcp_nv.c                                  |     1 -
 net/ipv4/tcp_output.c                              |    39 +-
 net/ipv4/tcp_rate.c                                |     6 +
 net/ipv4/udp_tunnel_core.c                         |     3 -
 net/ipv4/xfrm4_tunnel.c                            |     2 -
 net/ipv6/Kconfig                                   |     6 +-
 net/ipv6/Makefile                                  |    11 +-
 net/ipv6/addrconf.c                                |    19 +-
 net/ipv6/af_inet6.c                                |    21 +-
 net/ipv6/exthdrs.c                                 |     2 +-
 net/ipv6/ila/ila_xlat.c                            |     6 +-
 net/ipv6/ioam6.c                                   |    11 +-
 net/ipv6/ioam6_iptunnel.c                          |   300 +-
 net/ipv6/ip6_gre.c                                 |     4 +-
 net/ipv6/ip6_tunnel.c                              |     2 +-
 net/ipv6/ip6_vti.c                                 |     2 +-
 net/ipv6/ipv6_sockglue.c                           |    11 +-
 net/ipv6/ndisc.c                                   |    16 +-
 net/ipv6/netfilter/ip6_tables.c                    |     6 +-
 net/ipv6/netfilter/ip6table_filter.c               |    10 +-
 net/ipv6/netfilter/ip6table_mangle.c               |     8 +-
 net/ipv6/netfilter/ip6table_nat.c                  |    15 +-
 net/ipv6/netfilter/ip6table_raw.c                  |    10 +-
 net/ipv6/netfilter/ip6table_security.c             |     9 +-
 net/ipv6/route.c                                   |    24 +-
 net/ipv6/seg6.c                                    |     8 +-
 net/ipv6/seg6_hmac.c                               |     4 +-
 net/ipv6/sit.c                                     |     4 +-
 net/ipv6/tcp_ipv6.c                                |    42 +-
 net/ipv6/udp.c                                     |     6 +-
 net/llc/llc_c_ac.c                                 |     2 +-
 net/llc/llc_if.c                                   |     2 +-
 net/llc/llc_output.c                               |     2 +-
 net/llc/llc_proc.c                                 |     2 +-
 net/mac80211/agg-rx.c                              |    14 +-
 net/mac80211/cfg.c                                 |    38 +
 net/mac80211/debugfs_sta.c                         |   123 +-
 net/mac80211/fils_aead.c                           |    22 +-
 net/mac80211/ibss.c                                |    33 +-
 net/mac80211/ieee80211_i.h                         |    35 +-
 net/mac80211/iface.c                               |    39 +-
 net/mac80211/mesh.c                                |    87 +-
 net/mac80211/mesh_hwmp.c                           |    44 +-
 net/mac80211/mesh_plink.c                          |    11 +-
 net/mac80211/mesh_sync.c                           |    26 +-
 net/mac80211/mlme.c                                |   355 +-
 net/mac80211/pm.c                                  |     4 +
 net/mac80211/rx.c                                  |    12 +-
 net/mac80211/s1g.c                                 |     8 +-
 net/mac80211/scan.c                                |    16 +-
 net/mac80211/sta_info.c                            |     3 +
 net/mac80211/tdls.c                                |    63 +-
 net/mac80211/tx.c                                  |   206 +-
 net/mac80211/util.c                                |    40 +-
 net/mac802154/iface.c                              |    17 +-
 net/mctp/Kconfig                                   |    12 +-
 net/mctp/Makefile                                  |     3 +
 net/mctp/af_mctp.c                                 |   152 +-
 net/mctp/device.c                                  |   104 +-
 net/mctp/neigh.c                                   |     4 +-
 net/mctp/route.c                                   |   362 +-
 net/mctp/test/route-test.c                         |   544 +
 net/mctp/test/utils.c                              |    67 +
 net/mctp/test/utils.h                              |    20 +
 net/mptcp/mib.c                                    |    17 +-
 net/mptcp/mptcp_diag.c                             |    26 +-
 net/mptcp/options.c                                |    15 +-
 net/mptcp/pm_netlink.c                             |     9 +-
 net/mptcp/protocol.c                               |   447 +-
 net/mptcp/protocol.h                               |    19 +-
 net/mptcp/sockopt.c                                |   279 +
 net/netfilter/Kconfig                              |    11 +
 net/netfilter/core.c                               |    38 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   166 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |     8 +
 net/netfilter/ipvs/ip_vs_est.c                     |     5 +
 net/netfilter/nf_conntrack_proto.c                 |    16 +
 net/netfilter/nf_conntrack_proto_udp.c             |     7 +-
 net/netfilter/nf_nat_core.c                        |    12 +-
 net/netfilter/nf_tables_core.c                     |     2 +-
 net/netfilter/nf_tables_trace.c                    |     4 +-
 net/netfilter/nfnetlink_hook.c                     |    16 +-
 net/netfilter/nft_chain_filter.c                   |     4 +-
 net/netfilter/nft_dynset.c                         |    11 +-
 net/netfilter/nft_meta.c                           |     8 +-
 net/netfilter/nft_payload.c                        |    60 +-
 net/netfilter/xt_RATEEST.c                         |     7 +-
 net/netlink/af_netlink.c                           |    23 +-
 net/netrom/af_netrom.c                             |     4 +-
 net/netrom/nr_dev.c                                |     8 +-
 net/netrom/nr_route.c                              |     4 +-
 net/nfc/hci/command.c                              |    16 -
 net/nfc/hci/llc_shdlc.c                            |    35 +-
 net/nfc/llcp_commands.c                            |     8 -
 net/nfc/llcp_core.c                                |     5 +-
 net/nfc/nci/core.c                                 |     4 -
 net/nfc/nci/hci.c                                  |     4 -
 net/nfc/nci/ntf.c                                  |     9 -
 net/nfc/nci/uart.c                                 |    16 +-
 net/packet/af_packet.c                             |    35 +
 net/qrtr/Makefile                                  |     3 +-
 net/qrtr/{qrtr.c => af_qrtr.c}                     |     0
 net/rose/af_rose.c                                 |     5 +-
 net/rose/rose_dev.c                                |     8 +-
 net/rose/rose_link.c                               |     8 +-
 net/rose/rose_route.c                              |    10 +-
 net/rxrpc/rtt.c                                    |     2 +-
 net/sched/act_api.c                                |    21 +-
 net/sched/act_bpf.c                                |     2 +-
 net/sched/act_ife.c                                |     4 +-
 net/sched/act_mpls.c                               |     2 +-
 net/sched/act_police.c                             |     4 +-
 net/sched/act_sample.c                             |     2 +-
 net/sched/act_simple.c                             |     3 +-
 net/sched/act_skbedit.c                            |     2 +-
 net/sched/act_skbmod.c                             |     2 +-
 net/sched/cls_flower.c                             |     3 +-
 net/sched/em_meta.c                                |     2 +-
 net/sched/sch_api.c                                |    25 +-
 net/sched/sch_atm.c                                |     6 +-
 net/sched/sch_cbq.c                                |    15 +-
 net/sched/sch_drr.c                                |    13 +-
 net/sched/sch_ets.c                                |    17 +-
 net/sched/sch_fq_codel.c                           |    20 +-
 net/sched/sch_generic.c                            |    84 +-
 net/sched/sch_gred.c                               |    65 +-
 net/sched/sch_hfsc.c                               |    11 +-
 net/sched/sch_htb.c                                |    51 +-
 net/sched/sch_mq.c                                 |    31 +-
 net/sched/sch_mqprio.c                             |    64 +-
 net/sched/sch_multiq.c                             |     3 +-
 net/sched/sch_netem.c                              |     2 +-
 net/sched/sch_prio.c                               |     4 +-
 net/sched/sch_qfq.c                                |    13 +-
 net/sched/sch_taprio.c                             |     2 +-
 net/sched/sch_tbf.c                                |    16 +
 net/sctp/output.c                                  |    13 +-
 net/sctp/transport.c                               |    11 +-
 net/smc/Makefile                                   |     2 +
 net/smc/af_smc.c                                   |   449 +-
 net/smc/smc.h                                      |    23 +-
 net/smc/smc_clc.c                                  |   463 +-
 net/smc/smc_clc.h                                  |    72 +-
 net/smc/smc_core.c                                 |   192 +-
 net/smc/smc_core.h                                 |    51 +-
 net/smc/smc_ib.c                                   |   160 +-
 net/smc/smc_ib.h                                   |    16 +-
 net/smc/smc_ism.c                                  |    16 +-
 net/smc/smc_ism.h                                  |     2 +-
 net/smc/smc_llc.c                                  |   623 +-
 net/smc/smc_llc.h                                  |    12 +-
 net/smc/smc_netlink.c                              |    47 +-
 net/smc/smc_netlink.h                              |     2 +
 net/smc/smc_pnet.c                                 |    41 +-
 net/smc/smc_rx.c                                   |     3 +
 net/smc/smc_tracepoint.c                           |     9 +
 net/smc/smc_tracepoint.h                           |   116 +
 net/smc/smc_tx.c                                   |     3 +
 net/smc/smc_wr.c                                   |   237 +-
 net/smc/smc_wr.h                                   |     8 +
 net/switchdev/switchdev.c                          |   156 +-
 net/tipc/bearer.c                                  |     4 +-
 net/tipc/bearer.h                                  |     2 +-
 net/tipc/eth_media.c                               |     2 +-
 net/tipc/ib_media.c                                |     2 +-
 net/tls/tls_main.c                                 |    88 +
 net/tls/tls_sw.c                                   |    54 +-
 net/vmw_vsock/af_vsock.c                           |    80 +-
 net/wireless/Makefile                              |     4 +-
 net/wireless/core.c                                |    10 +
 net/wireless/nl80211.c                             |   452 +-
 net/wireless/rdev-ops.h                            |    14 +
 net/wireless/scan.c                                |    59 +-
 net/wireless/trace.h                               |    31 +
 net/wireless/util.c                                |     2 +
 net/xdp/xsk.c                                      |    15 -
 net/xdp/xsk_buff_pool.c                            |   132 +-
 net/xdp/xsk_queue.h                                |    12 +-
 net/xfrm/xfrm_input.c                              |     4 +-
 samples/bpf/.gitignore                             |     4 +
 samples/bpf/Makefile                               |    47 +-
 samples/bpf/xdp1_user.c                            |     2 +-
 samples/bpf/xdp_redirect_cpu_user.c                |     6 +-
 samples/bpf/xdp_router_ipv4_user.c                 |    39 +-
 samples/bpf/xdp_sample_pkts_user.c                 |     2 +-
 samples/seccomp/bpf-helper.h                       |     8 +-
 scripts/Makefile.modfinal                          |     3 +-
 scripts/bpf_doc.py                                 |     2 +
 scripts/link-vmlinux.sh                            |    11 +-
 scripts/pahole-flags.sh                            |    20 +
 tools/bpf/bpftool/Makefile                         |    61 +-
 tools/bpf/bpftool/btf.c                            |   156 +-
 tools/bpf/bpftool/common.c                         |    50 +-
 tools/bpf/bpftool/feature.c                        |     1 +
 tools/bpf/bpftool/gen.c                            |   195 +-
 tools/bpf/bpftool/iter.c                           |     2 +-
 tools/bpf/bpftool/link.c                           |    45 +-
 tools/bpf/bpftool/main.c                           |    17 +-
 tools/bpf/bpftool/main.h                           |    54 +-
 tools/bpf/bpftool/map.c                            |    45 +-
 tools/bpf/bpftool/map_perf_ring.c                  |     1 -
 tools/bpf/bpftool/pids.c                           |    90 +-
 tools/bpf/bpftool/prog.c                           |    64 +-
 tools/bpf/resolve_btfids/Makefile                  |    19 +-
 tools/bpf/resolve_btfids/main.c                    |    36 +-
 tools/bpf/runqslower/Makefile                      |    22 +-
 tools/include/uapi/linux/bpf.h                     |    76 +-
 tools/include/uapi/linux/btf.h                     |    55 +-
 tools/lib/bpf/.gitignore                           |     1 -
 tools/lib/bpf/Makefile                             |    62 +-
 tools/lib/bpf/bpf.c                                |    63 +-
 tools/lib/bpf/bpf_core_read.h                      |     2 +-
 tools/lib/bpf/bpf_gen_internal.h                   |    24 +-
 tools/lib/bpf/bpf_helpers.h                        |    51 +-
 tools/lib/bpf/bpf_tracing.h                        |    32 +
 tools/lib/bpf/btf.c                                |   369 +-
 tools/lib/bpf/btf.h                                |   114 +
 tools/lib/bpf/btf_dump.c                           |    61 +-
 tools/lib/bpf/gen_loader.c                         |   422 +-
 tools/lib/bpf/libbpf.c                             |  2296 +-
 tools/lib/bpf/libbpf.h                             |   193 +-
 tools/lib/bpf/libbpf.map                           |    16 +
 tools/lib/bpf/libbpf_common.h                      |    24 +
 tools/lib/bpf/libbpf_internal.h                    |    94 +-
 tools/lib/bpf/libbpf_legacy.h                      |    18 +
 tools/lib/bpf/libbpf_probes.c                      |     2 +-
 tools/lib/bpf/libbpf_version.h                     |     9 +
 tools/lib/bpf/linker.c                             |    45 +-
 tools/lib/bpf/relo_core.c                          |     2 +-
 tools/lib/bpf/skel_internal.h                      |     6 +-
 tools/lib/bpf/xsk.c                                |    10 +-
 tools/lib/bpf/xsk.h                                |    90 +-
 tools/perf/util/bpf-event.c                        |     2 +-
 tools/scripts/Makefile.arch                        |     3 +-
 tools/testing/selftests/bpf/.gitignore             |     5 +-
 tools/testing/selftests/bpf/Makefile               |    55 +-
 tools/testing/selftests/bpf/README.rst             |    27 +
 tools/testing/selftests/bpf/bench.c                |    60 +-
 tools/testing/selftests/bpf/bench.h                |     3 +
 .../selftests/bpf/benchs/bench_bloom_filter_map.c  |   477 +
 .../bpf/benchs/run_bench_bloom_filter_map.sh       |    45 +
 .../selftests/bpf/benchs/run_bench_ringbufs.sh     |    30 +-
 tools/testing/selftests/bpf/benchs/run_common.sh   |    60 +
 .../selftests/bpf/bpf_testmod/bpf_testmod-events.h |    15 +
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        |    52 +-
 .../selftests/bpf/bpf_testmod/bpf_testmod.h        |     5 +
 tools/testing/selftests/bpf/btf_helpers.c          |    11 +-
 tools/testing/selftests/bpf/cgroup_helpers.c       |     5 +-
 tools/testing/selftests/bpf/cgroup_helpers.h       |     2 +-
 tools/testing/selftests/bpf/flow_dissector_load.c  |    18 +-
 tools/testing/selftests/bpf/flow_dissector_load.h  |    10 +-
 tools/testing/selftests/bpf/prog_tests/atomics.c   |    35 +-
 .../selftests/bpf/prog_tests/attach_probe.c        |    33 +-
 .../selftests/bpf/prog_tests/bloom_filter_map.c    |   211 +
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |     6 +-
 .../selftests/bpf/prog_tests/bpf_iter_setsockopt.c |     2 +-
 .../testing/selftests/bpf/prog_tests/bpf_obj_id.c  |     2 +-
 .../selftests/bpf/prog_tests/bpf_verif_scale.c     |   225 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       |   524 +-
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  |    39 +-
 .../testing/selftests/bpf/prog_tests/btf_endian.c  |    18 +-
 tools/testing/selftests/bpf/prog_tests/btf_split.c |     2 +-
 tools/testing/selftests/bpf/prog_tests/btf_tag.c   |    20 +
 tools/testing/selftests/bpf/prog_tests/btf_write.c |   162 +-
 .../selftests/bpf/prog_tests/cg_storage_multi.c    |     2 +-
 .../bpf/prog_tests/cgroup_attach_autodetach.c      |     2 +-
 .../selftests/bpf/prog_tests/cgroup_attach_multi.c |     2 +-
 .../bpf/prog_tests/cgroup_attach_override.c        |     2 +-
 .../testing/selftests/bpf/prog_tests/cgroup_link.c |     2 +-
 .../testing/selftests/bpf/prog_tests/cgroup_v1v2.c |     2 +-
 tools/testing/selftests/bpf/prog_tests/check_mtu.c |     2 +-
 .../selftests/bpf/prog_tests/core_autosize.c       |     4 +-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |    21 +-
 .../selftests/bpf/prog_tests/dummy_st_ops.c        |   115 +
 .../selftests/bpf/prog_tests/fentry_fexit.c        |    16 +-
 .../testing/selftests/bpf/prog_tests/fentry_test.c |    14 +-
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |    46 +-
 .../testing/selftests/bpf/prog_tests/fexit_sleep.c |    12 +-
 .../testing/selftests/bpf/prog_tests/fexit_test.c  |    14 +-
 .../selftests/bpf/prog_tests/flow_dissector.c      |     4 +-
 .../bpf/prog_tests/flow_dissector_load_bytes.c     |     2 +-
 .../bpf/prog_tests/flow_dissector_reattach.c       |     2 +-
 .../selftests/bpf/prog_tests/get_branch_snapshot.c |   130 +
 .../testing/selftests/bpf/prog_tests/global_data.c |    11 +-
 .../selftests/bpf/prog_tests/global_data_init.c    |     2 +-
 tools/testing/selftests/bpf/prog_tests/kfree_skb.c |     5 +-
 .../testing/selftests/bpf/prog_tests/kfunc_call.c  |     6 +-
 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c |    35 +-
 .../selftests/bpf/prog_tests/ksyms_module.c        |    57 +-
 .../selftests/bpf/prog_tests/migrate_reuseport.c   |     2 +-
 .../selftests/bpf/prog_tests/modify_return.c       |     3 +-
 .../selftests/bpf/prog_tests/module_attach.c       |    46 +-
 .../selftests/bpf/prog_tests/ns_current_pid_tgid.c |     3 +-
 .../testing/selftests/bpf/prog_tests/perf_buffer.c |    24 +-
 tools/testing/selftests/bpf/prog_tests/perf_link.c |     3 +-
 .../testing/selftests/bpf/prog_tests/probe_user.c  |     7 +-
 .../bpf/prog_tests/raw_tp_writable_test_run.c      |     3 +-
 .../testing/selftests/bpf/prog_tests/rdonly_maps.c |     2 +-
 tools/testing/selftests/bpf/prog_tests/recursion.c |    10 +-
 .../selftests/bpf/prog_tests/reference_tracking.c  |    52 +-
 .../selftests/bpf/prog_tests/resolve_btfids.c      |    14 +-
 tools/testing/selftests/bpf/prog_tests/ringbuf.c   |    12 +-
 .../selftests/bpf/prog_tests/select_reuseport.c    |     4 +-
 .../bpf/prog_tests/send_signal_sched_switch.c      |     3 +-
 .../selftests/bpf/prog_tests/signal_pending.c      |     2 +-
 tools/testing/selftests/bpf/prog_tests/sk_assign.c |     2 +-
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c |     4 +-
 .../selftests/bpf/prog_tests/sk_storage_tracing.c  |     2 +-
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c   |     6 +
 .../selftests/bpf/prog_tests/skc_to_unix_sock.c    |    54 +
 tools/testing/selftests/bpf/prog_tests/skeleton.c  |    35 +
 tools/testing/selftests/bpf/prog_tests/snprintf.c  |     4 +-
 .../selftests/bpf/prog_tests/snprintf_btf.c        |     2 +-
 .../testing/selftests/bpf/prog_tests/sock_fields.c |     2 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c      |     2 +-
 .../selftests/bpf/prog_tests/sockopt_multi.c       |    30 +-
 tools/testing/selftests/bpf/prog_tests/tailcalls.c |    83 +-
 .../testing/selftests/bpf/prog_tests/tc_redirect.c |    18 +-
 tools/testing/selftests/bpf/prog_tests/tcp_rtt.c   |     2 +-
 tools/testing/selftests/bpf/prog_tests/test_ima.c  |     3 +-
 tools/testing/selftests/bpf/prog_tests/timer.c     |     3 +-
 tools/testing/selftests/bpf/prog_tests/timer_mim.c |     2 +-
 .../selftests/bpf/prog_tests/tp_attach_query.c     |     2 +-
 .../selftests/bpf/prog_tests/trace_printk.c        |    40 +-
 .../selftests/bpf/prog_tests/trace_vprintk.c       |    68 +
 .../selftests/bpf/prog_tests/trampoline_count.c    |     3 +-
 .../testing/selftests/bpf/prog_tests/verif_stats.c |    28 +
 .../selftests/bpf/prog_tests/xdp_adjust_tail.c     |     6 +-
 .../testing/selftests/bpf/prog_tests/xdp_attach.c  |     2 +-
 .../testing/selftests/bpf/prog_tests/xdp_bonding.c |     2 +-
 .../selftests/bpf/prog_tests/xdp_cpumap_attach.c   |     2 +-
 .../selftests/bpf/prog_tests/xdp_devmap_attach.c   |     6 +-
 tools/testing/selftests/bpf/prog_tests/xdp_info.c  |     2 +-
 tools/testing/selftests/bpf/prog_tests/xdp_link.c  |     2 +-
 tools/testing/selftests/bpf/prog_tests/xdpwall.c   |    15 +
 tools/testing/selftests/bpf/progs/atomics.c        |    16 +
 .../selftests/bpf/progs/bloom_filter_bench.c       |   153 +
 .../testing/selftests/bpf/progs/bloom_filter_map.c |    82 +
 tools/testing/selftests/bpf/progs/bpf_cubic.c      |    12 +-
 tools/testing/selftests/bpf/progs/bpf_flow.c       |     3 +-
 .../bpf/progs/btf_dump_test_case_bitfields.c       |    10 +-
 .../bpf/progs/btf_dump_test_case_packing.c         |     4 +-
 .../bpf/progs/btf_dump_test_case_padding.c         |     2 +-
 .../bpf/progs/btf_dump_test_case_syntax.c          |     2 +-
 .../bpf/progs/cg_storage_multi_isolated.c          |     4 +-
 .../selftests/bpf/progs/cg_storage_multi_shared.c  |     4 +-
 .../bpf/progs/cgroup_skb_sk_lookup_kern.c          |     1 -
 .../testing/selftests/bpf/progs/connect4_dropper.c |     2 +-
 tools/testing/selftests/bpf/progs/connect4_prog.c  |     2 -
 tools/testing/selftests/bpf/progs/connect6_prog.c  |     2 -
 .../selftests/bpf/progs/connect_force_port4.c      |     1 -
 .../selftests/bpf/progs/connect_force_port6.c      |     1 -
 tools/testing/selftests/bpf/progs/dev_cgroup.c     |     1 -
 tools/testing/selftests/bpf/progs/dummy_st_ops.c   |    50 +
 tools/testing/selftests/bpf/progs/fexit_sleep.c    |     4 +-
 .../selftests/bpf/progs/for_each_array_map_elem.c  |     2 +-
 .../selftests/bpf/progs/for_each_hash_map_elem.c   |     2 +-
 .../selftests/bpf/progs/get_branch_snapshot.c      |    40 +
 .../selftests/bpf/progs/get_cgroup_id_kern.c       |     1 -
 tools/testing/selftests/bpf/progs/kfree_skb.c      |     4 +-
 .../testing/selftests/bpf/progs/kfunc_call_test.c  |     4 +-
 .../selftests/bpf/progs/kfunc_call_test_subprog.c  |     2 +-
 tools/testing/selftests/bpf/progs/map_ptr_kern.c   |     1 -
 tools/testing/selftests/bpf/progs/netcnt_prog.c    |     1 -
 .../selftests/bpf/progs/perf_event_stackmap.c      |     4 +-
 tools/testing/selftests/bpf/progs/recursion.c      |     9 +-
 tools/testing/selftests/bpf/progs/sendmsg4_prog.c  |     2 -
 tools/testing/selftests/bpf/progs/sendmsg6_prog.c  |     2 -
 tools/testing/selftests/bpf/progs/skb_pkt_end.c    |     2 +-
 .../selftests/bpf/progs/sockmap_parse_prog.c       |     2 -
 .../selftests/bpf/progs/sockmap_tcp_msg_prog.c     |     2 -
 .../selftests/bpf/progs/sockmap_verdict_prog.c     |    14 +-
 .../testing/selftests/bpf/progs/sockopt_inherit.c  |     1 -
 tools/testing/selftests/bpf/progs/sockopt_multi.c  |     5 +-
 tools/testing/selftests/bpf/progs/strobemeta.h     |     4 +-
 tools/testing/selftests/bpf/progs/tag.c            |    54 +
 tools/testing/selftests/bpf/progs/tailcall1.c      |     7 +-
 tools/testing/selftests/bpf/progs/tailcall2.c      |    23 +-
 tools/testing/selftests/bpf/progs/tailcall3.c      |     7 +-
 tools/testing/selftests/bpf/progs/tailcall4.c      |     7 +-
 tools/testing/selftests/bpf/progs/tailcall5.c      |     7 +-
 tools/testing/selftests/bpf/progs/tailcall6.c      |    34 +
 .../selftests/bpf/progs/tailcall_bpf2bpf1.c        |     7 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf2.c        |     7 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf3.c        |    11 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf4.c        |    15 +-
 tools/testing/selftests/bpf/progs/tcp_rtt.c        |     1 -
 tools/testing/selftests/bpf/progs/test_btf_haskv.c |     2 -
 .../selftests/bpf/progs/test_btf_map_in_map.c      |    14 +-
 tools/testing/selftests/bpf/progs/test_btf_newkv.c |     2 -
 tools/testing/selftests/bpf/progs/test_btf_nokv.c  |     2 -
 .../selftests/bpf/progs/test_btf_skc_cls_ingress.c |     2 +-
 .../testing/selftests/bpf/progs/test_cgroup_link.c |     4 +-
 tools/testing/selftests/bpf/progs/test_check_mtu.c |    12 +-
 .../selftests/bpf/progs/test_cls_redirect.c        |     2 +-
 .../selftests/bpf/progs/test_core_reloc_mods.c     |     9 +
 .../selftests/bpf/progs/test_enable_stats.c        |     2 +-
 .../testing/selftests/bpf/progs/test_global_data.c |     2 +-
 .../selftests/bpf/progs/test_global_func1.c        |     2 +-
 .../selftests/bpf/progs/test_global_func3.c        |     2 +-
 .../selftests/bpf/progs/test_global_func5.c        |     2 +-
 .../selftests/bpf/progs/test_global_func6.c        |     2 +-
 .../selftests/bpf/progs/test_global_func7.c        |     2 +-
 .../selftests/bpf/progs/test_ksyms_module.c        |    46 +-
 .../testing/selftests/bpf/progs/test_ksyms_weak.c  |     2 +-
 tools/testing/selftests/bpf/progs/test_l4lb.c      |     2 -
 .../testing/selftests/bpf/progs/test_map_in_map.c  |    13 +-
 .../selftests/bpf/progs/test_map_in_map_invalid.c  |     2 +-
 .../bpf/progs/test_misc_tcp_hdr_options.c          |     2 +-
 .../selftests/bpf/progs/test_module_attach.c       |    14 +
 .../selftests/bpf/progs/test_pe_preserve_elems.c   |     8 +-
 .../testing/selftests/bpf/progs/test_perf_buffer.c |    22 +-
 tools/testing/selftests/bpf/progs/test_pinning.c   |     2 -
 .../selftests/bpf/progs/test_pinning_invalid.c     |     2 -
 .../testing/selftests/bpf/progs/test_pkt_access.c  |     3 +-
 .../selftests/bpf/progs/test_pkt_md_access.c       |     4 +-
 .../testing/selftests/bpf/progs/test_probe_user.c  |    28 +-
 .../selftests/bpf/progs/test_queue_stack_map.h     |     2 -
 .../bpf/progs/test_select_reuseport_kern.c         |     6 +-
 tools/testing/selftests/bpf/progs/test_sk_assign.c |     3 +-
 tools/testing/selftests/bpf/progs/test_sk_lookup.c |    45 +-
 .../selftests/bpf/progs/test_sk_lookup_kern.c      |    37 +-
 .../selftests/bpf/progs/test_skb_cgroup_id_kern.c  |     2 -
 tools/testing/selftests/bpf/progs/test_skb_ctx.c   |     7 +-
 .../testing/selftests/bpf/progs/test_skb_helpers.c |     2 +-
 .../selftests/bpf/progs/test_skc_to_unix_sock.c    |    40 +
 tools/testing/selftests/bpf/progs/test_skeleton.c  |    18 +
 .../selftests/bpf/progs/test_sockmap_kern.h        |     1 -
 .../selftests/bpf/progs/test_sockmap_listen.c      |     3 +-
 .../bpf/progs/test_sockmap_skb_verdict_attach.c    |     2 +-
 .../selftests/bpf/progs/test_sockmap_update.c      |     2 +-
 .../selftests/bpf/progs/test_stacktrace_build_id.c |     5 +-
 .../selftests/bpf/progs/test_stacktrace_map.c      |     4 +-
 tools/testing/selftests/bpf/progs/test_tc_bpf.c    |     2 +-
 tools/testing/selftests/bpf/progs/test_tc_neigh.c  |     6 +-
 .../selftests/bpf/progs/test_tc_neigh_fib.c        |     6 +-
 tools/testing/selftests/bpf/progs/test_tc_peer.c   |    10 +-
 .../bpf/progs/test_tcp_check_syncookie_kern.c      |     4 +-
 .../testing/selftests/bpf/progs/test_tcp_estats.c  |     1 -
 .../selftests/bpf/progs/test_tcp_hdr_options.c     |     2 +-
 .../testing/selftests/bpf/progs/test_tcpbpf_kern.c |     1 -
 .../selftests/bpf/progs/test_tcpnotify_kern.c      |     6 +-
 .../testing/selftests/bpf/progs/test_tracepoint.c  |     1 -
 .../testing/selftests/bpf/progs/test_tunnel_kern.c |     2 -
 tools/testing/selftests/bpf/progs/test_xdp.c       |     4 +-
 .../bpf/progs/test_xdp_adjust_tail_grow.c          |     2 +-
 .../bpf/progs/test_xdp_adjust_tail_shrink.c        |     4 +-
 .../testing/selftests/bpf/progs/test_xdp_bpf2bpf.c |     4 +-
 .../selftests/bpf/progs/test_xdp_devmap_helpers.c  |     2 +-
 tools/testing/selftests/bpf/progs/test_xdp_link.c  |     2 +-
 tools/testing/selftests/bpf/progs/test_xdp_loop.c  |     4 +-
 .../selftests/bpf/progs/test_xdp_noinline.c        |     4 +-
 .../selftests/bpf/progs/test_xdp_redirect.c        |     2 -
 .../bpf/progs/test_xdp_with_cpumap_helpers.c       |     4 +-
 .../bpf/progs/test_xdp_with_devmap_helpers.c       |     4 +-
 tools/testing/selftests/bpf/progs/trace_vprintk.c  |    33 +
 tools/testing/selftests/bpf/progs/twfw.c           |    58 +
 tools/testing/selftests/bpf/progs/xdp_dummy.c      |     2 +-
 .../selftests/bpf/progs/xdp_redirect_multi_kern.c  |     4 +-
 tools/testing/selftests/bpf/progs/xdping_kern.c    |     4 +-
 tools/testing/selftests/bpf/progs/xdpwall.c        |   365 +
 tools/testing/selftests/bpf/test_bpftool.py        |    22 +-
 tools/testing/selftests/bpf/test_bpftool_build.sh  |     4 +
 tools/testing/selftests/bpf/test_btf.h             |     3 +
 tools/testing/selftests/bpf/test_flow_dissector.sh |    10 +-
 tools/testing/selftests/bpf/test_progs.c           |   710 +-
 tools/testing/selftests/bpf/test_progs.h           |    40 +-
 tools/testing/selftests/bpf/test_sockmap.c         |    35 +-
 tools/testing/selftests/bpf/test_sysctl.c          |     4 +-
 .../selftests/bpf/test_tcp_check_syncookie.sh      |     4 +-
 tools/testing/selftests/bpf/test_tunnel.sh         |     5 +-
 tools/testing/selftests/bpf/test_verifier.c        |    12 +-
 tools/testing/selftests/bpf/test_xdp_meta.sh       |     5 +-
 tools/testing/selftests/bpf/test_xdp_redirect.sh   |     4 +-
 .../selftests/bpf/test_xdp_redirect_multi.sh       |     2 +-
 tools/testing/selftests/bpf/test_xdp_veth.sh       |     4 +-
 tools/testing/selftests/bpf/test_xdp_vlan.sh       |     7 +-
 tools/testing/selftests/bpf/trace_helpers.c        |     1 +
 .../testing/selftests/bpf/verifier/array_access.c  |     2 +-
 .../selftests/bpf/verifier/atomic_cmpxchg.c        |    38 +
 .../testing/selftests/bpf/verifier/atomic_fetch.c  |    57 +
 .../selftests/bpf/verifier/atomic_invalid.c        |    25 +
 tools/testing/selftests/bpf/verifier/calls.c       |    23 +
 tools/testing/selftests/bpf/verifier/ctx_skb.c     |    74 +-
 tools/testing/selftests/bpf/verifier/jit.c         |    69 +-
 tools/testing/selftests/bpf/verifier/lwt.c         |     2 +-
 .../bpf/verifier/perf_event_sample_period.c        |     6 +-
 tools/testing/selftests/bpf/verifier/spill_fill.c  |   161 +
 tools/testing/selftests/bpf/vmtest.sh              |     6 +-
 tools/testing/selftests/bpf/xdping.c               |     7 +-
 tools/testing/selftests/bpf/xdpxceiver.c           |   961 +-
 tools/testing/selftests/bpf/xdpxceiver.h           |    75 +-
 .../drivers/net/dsa/test_bridge_fdb_stress.sh      |    47 +
 .../drivers/net/mlxsw/devlink_trap_control.sh      |     7 +-
 .../drivers/net/mlxsw/devlink_trap_policer.sh      |    32 +-
 .../drivers/net/mlxsw/devlink_trap_tunnel_ipip.sh  |    50 +-
 .../selftests/drivers/net/mlxsw/mlxsw_lib.sh       |    50 +
 .../drivers/net/mlxsw/rif_mac_profile_scale.sh     |    72 +
 .../drivers/net/mlxsw/rif_mac_profiles.sh          |   213 +
 .../drivers/net/mlxsw/rif_mac_profiles_occ.sh      |   117 +
 .../selftests/drivers/net/mlxsw/rtnetlink.sh       |   112 +-
 .../selftests/drivers/net/mlxsw/sch_offload.sh     |   290 +
 .../selftests/drivers/net/mlxsw/sch_red_core.sh    |   129 +-
 .../selftests/drivers/net/mlxsw/sch_red_ets.sh     |    64 +-
 .../selftests/drivers/net/mlxsw/sch_red_root.sh    |     8 +
 .../mlxsw/spectrum-2/devlink_trap_tunnel_ipip6.sh  |   250 +
 .../drivers/net/mlxsw/spectrum-2/resource_scale.sh |     9 +-
 .../net/mlxsw/spectrum-2/rif_mac_profile_scale.sh  |    16 +
 .../net/mlxsw/spectrum/devlink_lib_spectrum.sh     |     6 +-
 .../drivers/net/mlxsw/spectrum/resource_scale.sh   |     2 +-
 .../net/mlxsw/spectrum/rif_mac_profile_scale.sh    |    16 +
 .../selftests/drivers/net/mlxsw/tc_restrictions.sh |     3 +-
 .../selftests/drivers/net/mlxsw/tc_sample.sh       |    13 +-
 .../drivers/net/netdevsim/ethtool-common.sh        |     2 +-
 .../drivers/net/netdevsim/tc-mq-visibility.sh      |    77 +
 .../drivers/net/ocelot/tc_flower_chains.sh         |    50 +-
 tools/testing/selftests/net/.gitignore             |     5 +
 tools/testing/selftests/net/Makefile               |     3 +
 tools/testing/selftests/net/amt.sh                 |   284 +
 .../selftests/net/arp_ndisc_evict_nocarrier.sh     |   220 +
 tools/testing/selftests/net/cmsg_so_mark.c         |    67 +
 tools/testing/selftests/net/cmsg_so_mark.sh        |    61 +
 tools/testing/selftests/net/config                 |     1 +
 tools/testing/selftests/net/fib_nexthops.sh        |     1 +
 .../selftests/net/forwarding/bridge_igmp.sh        |    12 +-
 .../testing/selftests/net/forwarding/bridge_mld.sh |    12 +-
 .../selftests/net/forwarding/devlink_lib.sh        |     6 -
 .../net/forwarding/forwarding.config.sample        |     4 +
 .../selftests/net/forwarding/ip6gre_flat.sh        |    65 +
 .../selftests/net/forwarding/ip6gre_flat_key.sh    |    65 +
 .../selftests/net/forwarding/ip6gre_flat_keys.sh   |    65 +
 .../selftests/net/forwarding/ip6gre_hier.sh        |    65 +
 .../selftests/net/forwarding/ip6gre_hier_key.sh    |    65 +
 .../selftests/net/forwarding/ip6gre_hier_keys.sh   |    65 +
 .../testing/selftests/net/forwarding/ip6gre_lib.sh |   438 +
 tools/testing/selftests/net/forwarding/lib.sh      |    19 +-
 .../selftests/net/forwarding/sch_tbf_etsprio.sh    |    28 +
 .../testing/selftests/net/forwarding/tc_common.sh  |    10 +
 tools/testing/selftests/net/ioam6.sh               |   208 +-
 tools/testing/selftests/net/mptcp/.gitignore       |     1 +
 tools/testing/selftests/net/mptcp/Makefile         |     2 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |    72 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |     7 +-
 tools/testing/selftests/net/mptcp/mptcp_sockopt.c  |   683 +
 tools/testing/selftests/net/mptcp/mptcp_sockopt.sh |    31 +-
 tools/testing/selftests/net/mptcp/pm_netlink.sh    |     6 +-
 tools/testing/selftests/net/mptcp/simult_flows.sh  |    36 +-
 tools/testing/selftests/net/tls.c                  |    28 +-
 tools/testing/selftests/seccomp/seccomp_bpf.c      |     6 +-
 2296 files changed, 215137 insertions(+), 50034 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-timecard
 create mode 100644 Documentation/bpf/bpf_licensing.rst
 create mode 100644 Documentation/devicetree/bindings/net/asix,ax88796c.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/qca8k.txt
 create mode 100644 Documentation/devicetree/bindings/net/dsa/qca8k.yaml
 create mode 100644 Documentation/devicetree/bindings/net/lantiq,etop-xway.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/lantiq,xrx200-net.txt
 create mode 100644 Documentation/devicetree/bindings/net/lantiq,xrx200-net.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/wireless/qca,ath9k.txt
 create mode 100644 Documentation/devicetree/bindings/net/wireless/qca,ath9k.yaml
 create mode 100644 Documentation/networking/devlink/iosm.rst
 create mode 100644 Documentation/networking/devlink/octeontx2.rst
 delete mode 100644 arch/mips/net/bpf_jit.c
 delete mode 100644 arch/mips/net/bpf_jit.h
 delete mode 100644 arch/mips/net/bpf_jit_asm.S
 create mode 100644 arch/mips/net/bpf_jit_comp.c
 create mode 100644 arch/mips/net/bpf_jit_comp.h
 create mode 100644 arch/mips/net/bpf_jit_comp32.c
 create mode 100644 arch/mips/net/bpf_jit_comp64.c
 delete mode 100644 arch/mips/net/ebpf_jit.c
 create mode 100644 drivers/net/amt.c
 create mode 100644 drivers/net/dsa/rtl8365mb.c
 create mode 100644 drivers/net/ethernet/asix/Kconfig
 create mode 100644 drivers/net/ethernet/asix/Makefile
 create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.c
 create mode 100644 drivers/net/ethernet/asix/ax88796c_ioctl.h
 create mode 100644 drivers/net/ethernet/asix/ax88796c_main.c
 create mode 100644 drivers/net/ethernet/asix/ax88796c_main.h
 create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.c
 create mode 100644 drivers/net/ethernet/asix/ax88796c_spi.h
 create mode 100644 drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_eswitch.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_eswitch.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_repr.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_repr.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_tc_lib.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_tc_lib.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/int_port.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/int_port.h
 rename drivers/net/ethernet/mellanox/mlx5/core/{ => lag}/lag.c (92%)
 rename drivers/net/ethernet/mellanox/mlx5/core/{ => lag}/lag.h (89%)
 rename drivers/net/ethernet/mellanox/mlx5/core/{lag_mp.c => lag/mp.c} (99%)
 rename drivers/net/ethernet/mellanox/mlx5/core/{lag_mp.h => lag/mp.h} (91%)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lag/port_sel.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/diag/dev_tracepoint.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/diag/sf_tracepoint.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/sf/diag/vhca_tracepoint.h
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_dbg_hsi.h
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_iro_hsi.h
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_mfw_hsi.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/rs.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/eeprom.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/pci_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/sdio_mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/sdio_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/testmode.c
 rename drivers/net/wireless/mediatek/mt76/{mt7615 => }/sdio.h (72%)
 rename drivers/net/wireless/mediatek/mt76/{mt7615 => }/sdio_txrx.c (67%)
 create mode 100644 drivers/net/wireless/realtek/rtw89/Kconfig
 create mode 100644 drivers/net/wireless/realtek/rtw89/Makefile
 create mode 100644 drivers/net/wireless/realtek/rtw89/cam.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/cam.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/coex.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/coex.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/core.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/core.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/debug.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/debug.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/efuse.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/efuse.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/fw.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/fw.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/mac.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/mac.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/mac80211.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/pci.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/pci.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/phy.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/phy.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/ps.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/ps.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/reg.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/regd.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852a.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852a.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852a_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852a_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/sar.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/sar.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/ser.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/ser.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/txrx.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/util.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_coredump.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_coredump.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_devlink.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_devlink.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_flash.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_flash.h
 delete mode 100644 drivers/ptp/idt8a340_reg.h
 delete mode 100644 include/linux/netfilter_ingress.h
 create mode 100644 include/linux/netfilter_netdev.h
 create mode 100644 include/net/amt.h
 create mode 100644 include/trace/events/mctp.h
 create mode 100644 include/uapi/linux/amt.h
 create mode 100644 kernel/bpf/bloom_filter.c
 create mode 100644 net/bluetooth/eir.c
 create mode 100644 net/bluetooth/eir.h
 create mode 100644 net/bluetooth/hci_codec.c
 create mode 100644 net/bluetooth/hci_codec.h
 create mode 100644 net/bpf/bpf_dummy_struct_ops.c
 rename {drivers/of => net/core}/of_net.c (85%)
 create mode 100644 net/dsa/tag_rtl8_4.c
 create mode 100644 net/ethtool/module.c
 create mode 100644 net/mctp/test/route-test.c
 create mode 100644 net/mctp/test/utils.c
 create mode 100644 net/mctp/test/utils.h
 rename net/qrtr/{qrtr.c => af_qrtr.c} (100%)
 create mode 100644 net/smc/smc_tracepoint.c
 create mode 100644 net/smc/smc_tracepoint.h
 create mode 100755 scripts/pahole-flags.sh
 create mode 100644 tools/lib/bpf/libbpf_version.h
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_bloom_filter_map.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_bloom_filter_map.sh
 create mode 100644 tools/testing/selftests/bpf/benchs/run_common.sh
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bloom_filter_map.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_tag.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/dummy_st_ops.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/get_branch_snapshot.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/skc_to_unix_sock.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_vprintk.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/verif_stats.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdpwall.c
 create mode 100644 tools/testing/selftests/bpf/progs/bloom_filter_bench.c
 create mode 100644 tools/testing/selftests/bpf/progs/bloom_filter_map.c
 create mode 100644 tools/testing/selftests/bpf/progs/dummy_st_ops.c
 create mode 100644 tools/testing/selftests/bpf/progs/get_branch_snapshot.c
 create mode 100644 tools/testing/selftests/bpf/progs/tag.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall6.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_skc_to_unix_sock.c
 create mode 100644 tools/testing/selftests/bpf/progs/trace_vprintk.c
 create mode 100644 tools/testing/selftests/bpf/progs/twfw.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdpwall.c
 create mode 100644 tools/testing/selftests/bpf/verifier/atomic_fetch.c
 create mode 100644 tools/testing/selftests/bpf/verifier/atomic_invalid.c
 create mode 100755 tools/testing/selftests/drivers/net/dsa/test_bridge_fdb_stress.sh
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/rif_mac_profile_scale.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/rif_mac_profiles.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/rif_mac_profiles_occ.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/sch_offload.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/devlink_trap_tunnel_ipip6.sh
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/rif_mac_profile_scale.sh
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/spectrum/rif_mac_profile_scale.sh
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/tc-mq-visibility.sh
 create mode 100644 tools/testing/selftests/net/amt.sh
 create mode 100755 tools/testing/selftests/net/arp_ndisc_evict_nocarrier.sh
 create mode 100644 tools/testing/selftests/net/cmsg_so_mark.c
 create mode 100755 tools/testing/selftests/net/cmsg_so_mark.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_flat.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_flat_key.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_flat_keys.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_hier.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_hier_key.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_hier_keys.sh
 create mode 100644 tools/testing/selftests/net/forwarding/ip6gre_lib.sh
 create mode 100644 tools/testing/selftests/net/mptcp/mptcp_sockopt.c
