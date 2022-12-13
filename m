Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED13564BA79
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 18:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236219AbiLMRAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 12:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236227AbiLMQ7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 11:59:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DFB233BB
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 08:56:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670950537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ry9HsEeg/3t+F9f5xjTCaoAdm98gIxE2PfI3ss38QhY=;
        b=aWAF53Z5O9XxYldbZgNY2NWCAcoX72LeVoM6DifJWz2EucGi3gGl0wlzY7WD7U5swv3j8z
        MAo5EhBSO61l0oo1/6xlqts8Y03WrI3GUKeFoJVjKyUq1F3L57OLhQlgypAKXYWlhDh5o+
        IaNgvfzsgF6avVVILaFYlg5mrtLP7p4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618--xYbjSWlO_6GaE1j9BXpgg-1; Tue, 13 Dec 2022 11:55:32 -0500
X-MC-Unique: -xYbjSWlO_6GaE1j9BXpgg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 169D583397C;
        Tue, 13 Dec 2022 16:55:32 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 90D5E51EF;
        Tue, 13 Dec 2022 16:55:27 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 6.2
Date:   Tue, 13 Dec 2022 17:54:44 +0100
Message-Id: <20221213165444.361342-1-pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

There are a couple of new config knobs enabled by default:

- BT_LE_L2CAP_ECRED introduce by:
commit 462fcd53924c ("Bluetooth: Add CONFIG_BT_LE_L2CAP_ECRED")
- CONFIG_BT_HCIBTUSB_POLL_SYNC introduced by:
commit db11223571d4 ("Bluetooth: btusb: Default CONFIG_BT_HCIBTUSB_POLL_SYNC=y")

I think both are valid exceptions to the 'no new config=y' rule
because:
462fcd53924c is recommended by the standard and other features.
db11223571d4 has proven over time to improve stability.

Additionally we have a couple of trivial conflicts with your current
tree:

MAINTAINERS:
  8a06127602de ("Bluetooth: hci_bcm4377: Add new driver for BCM4377 PCIe boards")
  8b49c30d8fd6 ("MAINTAINERS: Add entries for Apple SoC cpufreq driver")

arch/arm64/boot/dts/apple/t8103-jxxx.dtsi:
  8a3df85ad87d ("arm64: dts: apple: t8103: Add MCA and its support")
  7a73b976eda9 ("arm64: dts: apple: t8103: Add Bluetooth controller")

In both cases no manual resolution is needed, and all the new lines
from the relevant commit should be accepted.

FYI this also includes the eBPF change removing the dependency on
error injection, see commit 5b481acab4ce ("bpf: do not rely on 
ALLOW_ERROR_INJECTION for fmod_ret").

The following changes since commit 010b6761a9fc5006267d99abb6f9f196bf5d3d13:

  Merge tag 'net-6.1-rc9' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-12-08 15:32:13 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-6.2

for you to fetch changes up to 7c4a6309e27f411743817fe74a832ec2d2798a4b:

  ipvs: fix type warning in do_div() on 32 bit (2022-12-13 10:44:02 +0100)

----------------------------------------------------------------
Networking changes for 6.2.

Core
----
 - Allow live renaming when an interface is up

 - Add retpoline wrappers for tc, improving considerably the
   performances of complex queue discipline configurations.

 - Add inet drop monitor support.

 - A few GRO performance improvements.

 - Add infrastructure for atomic dev stats, addressing long standing
   data races.

 - De-duplicate common code between OVS and conntrack offloading
   infrastructure.

 - A bunch of UBSAN_BOUNDS/FORTIFY_SOURCE improvements.

 - Netfilter: introduce packet parser for tunneled packets

 - Replace IPVS timer-based estimators with kthreads to scale up
   the workload with the number of available CPUs.

 - Add the helper support for connection-tracking OVS offload.

BPF
---
 - Support for user defined BPF objects: the use case is to allocate
   own objects, build own object hierarchies and use the building
   blocks to build own data structures flexibly, for example, linked
   lists in BPF.

 - Make cgroup local storage available to non-cgroup attached BPF
   programs.

 - Avoid unnecessary deadlock detection and failures wrt BPF task
   storage helpers.

 - A relevant bunch of BPF verifier fixes and improvements.

 - Veristat tool improvements to support custom filtering, sorting,
   and replay of results.

 - Add LLVM disassembler as default library for dumping JITed code.

 - Lots of new BPF documentation for various BPF maps.

 - Add bpf_rcu_read_{,un}lock() support for sleepable programs.

 - Add RCU grace period chaining to BPF to wait for the completion
   of access from both sleepable and non-sleepable BPF programs.

 - Add support storing struct task_struct objects as kptrs in maps.

 - Improve helper UAPI by explicitly defining BPF_FUNC_xxx integer
   values.

 - Add libbpf *_opts API-variants for bpf_*_get_fd_by_id() functions.

Protocols
---------
 - TCP: implement Protective Load Balancing across switch links.

 - TCP: allow dynamically disabling TCP-MD5 static key, reverting
   back to fast[er]-path.

 - UDP: Introduce optional per-netns hash lookup table.

 - IPv6: simplify and cleanup sockets disposal.

 - Netlink: support different type policies for each generic
   netlink operation.

 - MPTCP: add MSG_FASTOPEN and FastOpen listener side support.

 - MPTCP: add netlink notification support for listener sockets
   events.

 - SCTP: add VRF support, allowing sctp sockets binding to VRF
   devices.

 - Add bridging MAC Authentication Bypass (MAB) support.

 - Extensions for Ethernet VPN bridging implementation to better
   support multicast scenarios.

 - More work for Wi-Fi 7 support, comprising conversion of all
   the existing drivers to internal TX queue usage.

 - IPSec: introduce a new offload type (packet offload) allowing
   complete header processing and crypto offloading.

 - IPSec: extended ack support for more descriptive XFRM error
   reporting.

 - RXRPC: increase SACK table size and move processing into a
   per-local endpoint kernel thread, reducing considerably the
   required locking.

 - IEEE 802154: synchronous send frame and extended filtering
   support, initial support for scanning available 15.4 networks.

 - Tun: bump the link speed from 10Mbps to 10Gbps.

 - Tun/VirtioNet: implement UDP segmentation offload support.

Driver API
----------

 - PHY/SFP: improve power level switching between standard
   level 1 and the higher power levels.

 - New API for netdev <-> devlink_port linkage.

 - PTP: convert existing drivers to new frequency adjustment
   implementation.

 - DSA: add support for rx offloading.

 - Autoload DSA tagging driver when dynamically changing protocol.

 - Add new PCP and APPTRUST attributes to Data Center Bridging.

 - Add configuration support for 800Gbps link speed.

 - Add devlink port function attribute to enable/disable RoCE and
   migratable.

 - Extend devlink-rate to support strict prioriry and weighted fair
   queuing.

 - Add devlink support to directly reading from region memory.

 - New device tree helper to fetch MAC address from nvmem.

 - New big TCP helper to simplify temporary header stripping.

New hardware / drivers
----------------------

 - Ethernet:
   - Marvel Octeon CNF95N and CN10KB Ethernet Switches.
   - Marvel Prestera AC5X Ethernet Switch.
   - WangXun 10 Gigabit NIC.
   - Motorcomm yt8521 Gigabit Ethernet.
   - Microchip ksz9563 Gigabit Ethernet Switch.
   - Microsoft Azure Network Adapter.
   - Linux Automation 10Base-T1L adapter.

 - PHY:
   - Aquantia AQR112 and AQR412.
   - Motorcomm YT8531S.

 - PTP:
   - Orolia ART-CARD.

 - WiFi:
   - MediaTek Wi-Fi 7 (802.11be) devices.
   - RealTek rtw8821cu, rtw8822bu, rtw8822cu and rtw8723du USB
     devices.

 - Bluetooth:
   - Broadcom BCM4377/4378/4387 Bluetooth chipsets.
   - Realtek RTL8852BE and RTL8723DS.
   - Cypress.CYW4373A0 WiFi + Bluetooth combo device.

Drivers
-------
 - CAN:
   - gs_usb: bus error reporting support.
   - kvaser_usb: listen only and bus error reporting support.

 - Ethernet NICs:
   - Intel (100G):
     - extend action skbedit to RX queue mapping.
     - implement devlink-rate support.
     - support direct read from memory.
   - nVidia/Mellanox (mlx5):
     - SW steering improvements, increasing rules update rate.
     - Support for enhanced events compression.
     - extend H/W offload packet manipulation capabilities.
     - implement IPSec packet offload mode.
   - nVidia/Mellanox (mlx4):
     - better big TCP support.
   - Netronome Ethernet NICs (nfp):
     - IPsec offload support.
     - add support for multicast filter.
   - Broadcom:
     - RSS and PTP support improvements.
   - AMD/SolarFlare:
     - netlink extened ack improvements.
     - add basic flower matches to offload, and related stats.
   - Virtual NICs:
     - ibmvnic: introduce affinity hint support.
   - small / embedded:
     - FreeScale fec: add initial XDP support.
     - Marvel mv643xx_eth: support MII/GMII/RGMII modes for Kirkwood.
     - TI am65-cpsw: add suspend/resume support.
     - Mediatek MT7986: add RX wireless wthernet dispatch support.
     - Realtek 8169: enable GRO software interrupt coalescing per
       default.

 - Ethernet high-speed switches:
   - Microchip (sparx5):
     - add support for Sparx5 TC/flower H/W offload via VCAP.
   - Mellanox mlxsw:
     - add 802.1X and MAC Authentication Bypass offload support.
     - add ip6gre support.

 - Embedded Ethernet switches:
   - Mediatek (mtk_eth_soc):
     - improve PCS implementation, add DSA untag support.
     - enable flow offload support.
   - Renesas:
     - add rswitch R-Car Gen4 gPTP support.
   - Microchip (lan966x):
     - add full XDP support.
     - add TC H/W offload via VCAP.
     - enable PTP on bridge interfaces.
   - Microchip (ksz8):
     - add MTU support for KSZ8 series.

 - Qualcomm 802.11ax WiFi (ath11k):
   - support configuring channel dwell time during scan.

 - MediaTek WiFi (mt76):
   - enable Wireless Ethernet Dispatch (WED) offload support.
   - add ack signal support.
   - enable coredump support.
   - remain_on_channel support.

 - Intel WiFi (iwlwifi):
   - enable Wi-Fi 7 Extremely High Throughput (EHT) PHY capabilities.
   - 320 MHz channels support.

 - RealTek WiFi (rtw89):
   - new dynamic header firmware format support.
   - wake-over-WLAN support.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Abhishek Naik (1):
      wifi: iwlwifi: nvm: Update EHT capabilities for GL device

Aditya Kumar Singh (2):
      wifi: ath11k: stop tx queues immediately upon firmware exit
      wifi: ath11k: fix firmware assert during bandwidth change for peer sta

Ajay Sharma (3):
      net: mana: Set the DMA device max segment size
      net: mana: Define and process GDMA response code GDMA_STATUS_MORE_ENTRIES
      net: mana: Define data structures for protection domain and memory registration

Alan Maguire (1):
      libbpf: Btf dedup identical struct test needs check for nested structs/arrays

Alex Elder (36):
      net: ipa: kill two constant symbols
      net: ipa: remove two memory region checks
      net: ipa: validate IPA table memory earlier
      net: ipa: verify table sizes fit in commands early
      net: ipa: introduce ipa_cmd_init()
      net: ipa: kill ipa_table_valid()
      net: ipa: check table memory regions earlier
      net: ipa: record the route table size in the IPA structure
      net: ipa: determine route table size from memory region
      net: ipa: don't assume 8 modem routing table entries
      net: ipa: determine filter table size from memory region
      net: ipa: define IPA v5.0
      net: ipa: change an IPA v5.0 memory requirement
      net: ipa: no more global filtering starting with IPA v5.0
      net: ipa: more completely check endpoint validity
      net: ipa: refactor endpoint loops
      net: ipa: determine the maximum endpoint ID
      net: ipa: record and use the number of defined endpoint IDs
      net: ipa: reduce arguments to ipa_table_init_add()
      net: ipa: use ipa_table_mem() in ipa_table_reset_add()
      net: ipa: add a parameter to aggregation registers
      net: ipa: add a parameter to suspend registers
      net: ipa: use a bitmap for defined endpoints
      net: ipa: use a bitmap for available endpoints
      net: ipa: support more filtering endpoints
      net: ipa: use a bitmap for set-up endpoints
      net: ipa: use a bitmap for enabled endpoints
      dt-bindings: net: qcom,ipa: remove an unnecessary restriction
      dt-bindings: net: qcom,ipa: restate a requirement
      dt-bindings: net: qcom,ipa: deprecate modem-init
      net: ipa: encapsulate decision about firmware load
      net: ipa: introduce "qcom,gsi-loader" property
      dt-bindings: net: qcom,ipa: support skipping GSI firmware load
      net: ipa: permit GSI firmware loading to be skipped
      net: ipa: avoid a null pointer dereference
      net: ipa: add IPA v4.7 support

Alexander Aring (5):
      mac802154: util: fix release queue handling
      mac802154: fix atomic_dec_and_test checks
      mac802154: move receive parameters above start
      mac802154: set filter at drv_start()
      ieee802154: atusb: add support for trac feature

Alexander Wetzel (4):
      wifi: mac80211: add internal handler for wake_tx_queue
      wifi: mac80211: add wake_tx_queue callback to drivers
      wifi: mac80211: Drop support for TX push path
      wifi: mac80211: Drop not needed check for NULL

Alexandru Tachici (3):
      net: ethernet: adi: adin1110: Fix SPI transfers
      net: ethernet: adi: adin1110: add reset GPIO
      dt-bindings: net: adin1110: Document reset

Alexei Starovoitov (28):
      Merge branch 'Remove unnecessary RCU grace period chaining'
      Merge branch 'libbpf: support non-mmap()'able data sections'
      Merge branch 'bpf,x64: Use BMI2 for shifts'
      Merge branch 'bpftool: Add autoattach for bpf prog load|loadall'
      Merge branch 'bpftool: Add LLVM as default library for disassembling JIT-ed programs'
      Merge branch 'bpf: Fixes for kprobe multi on kernel modules'
      Merge branch 'bpf: Avoid unnecessary deadlock detection and failure in task storage'
      Merge branch 'bpf: Implement cgroup local storage available to non-cgroup-attached bpf progs'
      Merge branch 'veristat: replay, filtering, sorting'
      Merge branch 'BPF verifier precision tracking improvements'
      Merge branch 'propagate nullness information for reg to reg comparisons'
      Merge branch 'Allocated objects, BPF linked lists'
      Merge branch 'Support storing struct task_struct objects as kptrs'
      Merge branch 'bpf: Implement two type cast kfuncs'
      Merge branch 'clean-up bpftool from legacy support'
      Revert "selftests/bpf: Temporarily disable linked list tests"
      selftests/bpf: Workaround for llvm nop-4 bug
      Merge branch 'Support storing struct cgroup * objects as kptrs'
      Merge branch 'bpf: Add bpf_rcu_read_lock() support'
      bpf: Don't mark arguments to fentry/fexit programs as trusted.
      bpf: Tighten ptr_to_btf_id checks.
      Merge branch 'bpf: Handle MEM_RCU type properly'
      Merge branch 'Refactor verifier prune and jump point handling'
      Merge "do not rely on ALLOW_ERROR_INJECTION for fmod_ret" into bpf-next
      Merge branch 'Document some recent core kfunc additions'
      Merge branch 'Misc optimizations for bpf mem allocator'
      Merge branch 'Dynptr refactorings'
      Merge branch 'stricter register ID checking in regsafe()'

Alexey Kodanev (3):
      sctp: remove unnecessary NULL check in sctp_association_init()
      sctp: remove unnecessary NULL check in sctp_ulpq_tail_event()
      sctp: remove unnecessary NULL checks in sctp_enqueue_event()

Alicja Kowalska (1):
      i40e: Add appropriate error message logged for incorrect duplex setting

Amit Cohen (3):
      ethtool: Add support for 800Gbps link modes
      mlxsw: Add support for 800Gbps link modes
      bonding: 3ad: Add support for 800G speed

Amritha Nambiar (3):
      act_skbedit: skbedit queue mapping for receive queue
      ice: Enable RX queue selection using skbedit action
      Documentation: networking: TC queue based filtering

Anatolii Gerasymenko (1):
      ice: Use ICE_RLAN_BASE_S instead of magic number

Andrew Melnychenko (6):
      udp: allow header check for dodgy GSO_UDP_L4 packets.
      uapi/linux/if_tun.h: Added new offload types for USO4/6.
      driver/net/tun: Added features for USO.
      uapi/linux/virtio_net.h: Added USO types.
      linux/virtio_net.h: Support USO offload in vnet header.
      drivers/net/virtio_net.c: Added USO support.

Andrii Nakryiko (42):
      selftests/bpf: allow requesting log level 2 in test_verifier
      selftests/bpf: avoid reporting +100% difference in veristat for actual 0%
      selftests/bpf: add BPF object fixup step to veristat
      bpf: explicitly define BPF_FUNC_xxx integer values
      scripts/bpf_doc.py: update logic to not assume sequential enum values
      Merge branch 'Add _opts variant for bpf_*_get_fd_by_id()'
      Merge branch 'Fix bugs found by ASAN when running selftests'
      Merge branch 'libbpf: fix fuzzer-reported issues'
      libbpf: clean up and refactor BTF fixup step
      libbpf: only add BPF_F_MMAPABLE flag for data maps with global vars
      libbpf: add non-mmapable data section selftest
      Merge branch 'Add support for aarch64 to selftests/bpf/vmtest.sh'
      selftests/bpf: add veristat replay mode
      selftests/bpf: shorten "Total insns/states" column names in veristat
      selftests/bpf: consolidate and improve file/prog filtering in veristat
      selftests/bpf: ensure we always have non-ambiguous sorting in veristat
      selftests/bpf: allow to define asc/desc ordering for sort specs in veristat
      selftests/bpf: support simple filtering of stats in veristat
      selftests/bpf: make veristat emit all stats in CSV mode by default
      selftests/bpf: handle missing records in comparison mode better in veristat
      selftests/bpf: support stats ordering in comparison mode in veristat
      selftests/bpf: support stat filtering in comparison mode in veristat
      bpf: propagate precision in ALU/ALU64 operations
      bpf: propagate precision across all frames, not just the last one
      bpf: allow precision tracking for programs with subprogs
      bpf: stop setting precise in current state
      bpf: aggressively forget precise markings during state checkpointing
      selftests/bpf: make test_align selftest more robust
      Merge branch 'libbpf: Resolve unambigous forward declarations'
      Merge branch 'bpf: Add hwtstamp field for the sockops prog'
      selftests/bpf: fix veristat's singular file-or-prog filter
      Merge branch 'libbpf: Fixed various checkpatch issues'
      libbpf: Ignore hashmap__find() result explicitly in btf_dump
      libbpf: Avoid enum forward-declarations in public API in C++ mode
      selftests/bpf: Make sure enum-less bpf_enable_stats() API works in C++ mode
      Merge branch 'BPF selftests fixes'
      bpf: decouple prune and jump points
      bpf: mostly decouple jump history management from is_state_visited()
      bpf: remove unnecessary prune and jump points
      bpf: Remove unused insn_cnt argument from visit_[func_call_]insn()
      selftests/bpf: add generic BPF program tester-loader
      selftests/bpf: convert dynptr_fail and map_kptr_fail subtests to generic tester

Andy Chi (1):
      Bluetooth: btusb: Add a new VID/PID 0489/e0f2 for MT7922

Andy Chiu (4):
      net: axiemac: add PM callbacks to support suspend/resume
      net: axienet: Unexport and remove unused mdio functions
      dt-bindings: describe the support of "clock-frequency" in mdio
      net: axienet: set mdio clock according to bus-frequency

Andy Ren (1):
      net/core: Allow live renaming when an interface is up

Andy Shevchenko (3):
      mac_pton: Don't access memory over expected length
      net: thunderbolt: Switch from __maybe_unused to pm_sleep_ptr() etc
      net: thunderbolt: Use bitwise types in the struct thunderbolt_ip_frame_header

Angel Iglesias (1):
      i2c: core: Introduce i2c_client_get_device_id helper function

Angelo Dureghello (1):
      net: dsa: mv88e6xxx: enable set_policy

Anirudh Venkataramanan (9):
      e1000e: Remove unnecessary use of kmap_atomic()
      e1000: Remove unnecessary use of kmap_atomic()
      ixgbe: Remove local variable
      ch_ktls: Use memcpy_from_page() instead of k[un]map_atomic()
      sfc: Use kmap_local_page() instead of kmap_atomic()
      cassini: Use page_address() instead of kmap_atomic()
      cassini: Use memcpy_from_page() instead of k[un]map_atomic()
      sunvnet: Use kmap_local_page() instead of kmap_atomic()
      net: thunderbolt: Use kmap_local_page() instead of kmap_atomic()

Anisse Astier (1):
      net/mlx5e: remove unused list in arfs

Anssi Hannula (5):
      can: kvaser_usb_leaf: Set Warning state even without bus errors
      can: kvaser_usb_leaf: Fix improved state not being reported
      can: kvaser_usb_leaf: Fix wrong CAN state after stopping
      can: kvaser_usb_leaf: Ignore stale bus-off after start
      can: kvaser_usb_leaf: Fix bogus restart events

Antoine Tenart (1):
      net: phy: mscc: macsec: do not copy encryption keys

Antony Antony (1):
      xfrm: update x->lastused for every packet

Archie Pusaka (2):
      Bluetooth: btusb: Introduce generic USB reset
      Bluetooth: hci_sync: cancel cmd_timer if hci_open failed

Arend van Spriel (7):
      wifi: brcmfmac: add function to unbind device to bus layer api
      wifi: brcmfmac: add firmware vendor info in driver info
      wifi: brcmfmac: add support for vendor-specific firmware api
      wifi: brcmfmac: add support for Cypress firmware api
      wifi: brcmfmac: add support Broadcom BCA firmware api
      wifi: brcmfmac: add vendor name in revinfo debugfs file
      wifi: brcmfmac: introduce BRCMFMAC exported symbols namespace

Arnd Bergmann (1):
      net: remove smc911x driver

Artem Chernyshev (1):
      net: vmw_vsock: vmci: Check memcpy_from_msg()

Artem Lukyanov (1):
      Bluetooth: btusb: Add Realtek RTL8852BE support ID 0x0cb8:0xc559

Artem Savkov (1):
      selftests/bpf: Use consistent build-id type for liburandom_read.so

Arınç ÜNAL (1):
      dt-bindings: net: qca,ar71xx: remove label = "cpu" from examples

Avraham Stern (9):
      wifi: iwlwifi: mvm: send TKIP connection status to csme
      wifi: iwlwifi: mei: make sure ownership confirmed message is sent
      wifi: iwlwifi: mei: avoid blocking sap messages handling due to rtnl lock
      wifi: iwlwifi: mei: implement PLDR flow
      wifi: iwlwifi: mei: use wait_event_timeout() return value
      wifi: iwlwifi: iwlmei: report disconnection as temporary
      wifi: iwlwifi: mei: wait for the mac to stop on suspend
      wifi: iwlwifi: mvm: trigger PCI re-enumeration in case of PLDR sync
      wifi: iwlwifi: mvm: return error value in case PLDR sync failed

Bagas Sanjaya (2):
      Documentation: bpf: Escape underscore in BPF type name prefix
      Documentation: devlink: Add blank line padding on numbered lists in Devlink Port documentation

Baochen Qiang (2):
      wifi: ath11k: Don't exit on wakeup failure
      wifi: ath11k: Send PME message during wakeup from D3cold

Bartosz Staszewski (2):
      iavf: Change information about device removal in dmesg
      i40e: Fix the inability to attach XDP program on downed interface

Ben Greear (3):
      wifi: iwlwifi: mvm: fix double free on tx path.
      wifi: mt76: mt7915: fix bounds checking for tx-free-done command
      Revert "mt76: use IEEE80211_OFFLOAD_ENCAP_ENABLED instead of MT_DRV_AMSDU_OFFLOAD"

Benjamin Berg (3):
      wifi: mac80211: add pointer from link STA to STA
      wifi: mac80211: add API to show the link STAs in debugfs
      wifi: mac80211: include link address in debugfs

Benjamin Mikailenko (2):
      ice: Accumulate HW and Netdev statistics over reset
      ice: Accumulate ring statistics over reset

Benjamin Tissoires (1):
      bpf: do not rely on ALLOW_ERROR_INJECTION for fmod_ret

Bhadram Varka (1):
      net: stmmac: tegra: Add MGBE support

Biju Das (6):
      can: rcar_canfd: Use devm_reset_control_get_optional_exclusive
      can: rcar_canfd: rcar_canfd_probe: Add struct rcar_canfd_hw_info to driver data
      can: rcar_canfd: Add max_channels to struct rcar_canfd_hw_info
      can: rcar_canfd: Add shared_global_irqs to struct rcar_canfd_hw_info
      can: rcar_canfd: Add postdiv to struct rcar_canfd_hw_info
      can: rcar_canfd: Add multi_channel_irqs to struct rcar_canfd_hw_info

Bitterblue Smith (20):
      wifi: rtl8xxxu: Support new chip RTL8188FU
      wifi: rtl8xxxu: gen2: Turn on the rate control
      wifi: rtl8xxxu: Make some arrays const
      wifi: rtl8xxxu: Fix reading the vendor of combo chips
      wifi: rtl8xxxu: Update module description
      wifi: rtl8xxxu: Add central frequency offset tracking
      wifi: rtl8xxxu: Fix the CCK RSSI calculation
      wifi: rtl8xxxu: Recognise all possible chip cuts
      wifi: rtl8xxxu: Set IEEE80211_HW_SUPPORT_FAST_XMIT
      wifi: rtl8xxxu: Use dev_* instead of pr_info
      wifi: rtl8xxxu: Move burst init to a function
      wifi: rtl8xxxu: Split up rtl8xxxu_identify_chip
      wifi: rtl8xxxu: Rename rtl8xxxu_8188f_channel_to_group
      wifi: rtl8xxxu: Name some bits used in burst init
      wifi: rtl8xxxu: Use strscpy instead of sprintf
      wifi: rtl8xxxu: Use u32_get_bits in *_identify_chip
      wifi: rtl8xxxu: Fix use after rcu_read_unlock in rtl8xxxu_bss_info_changed
      wifi: rtl8xxxu: Add __packed to struct rtl8723bu_c2h
      wifi: rtl8xxxu: Fix the channel width reporting
      wifi: rtl8xxxu: Introduce rtl8xxxu_update_ra_report

Björn Töpel (5):
      selftests/bpf: Explicitly pass RESOLVE_BTFIDS to sub-make
      selftests/bpf: Pass target triple to get_sys_includes macro
      selftests: net: Add cross-compilation support for BPF programs
      bpf: Do not zero-extend kfunc return values
      selftests: net: Fix O=dir builds

Bo Jiao (2):
      wifi: mt76: mt7915: rework mt7915_dma_reset()
      wifi: mt76: mt7915: enable full system reset support

Brett Creeley (1):
      ice: Remove and replace ice speed defines with ethtool.h versions

Brian Henriquez (1):
      wifi: brcmfmac: correctly remove all p2p vif

Cai Huoqing (4):
      net: hinic: Convert the cmd code from decimal to hex to be more readable
      net: hinic: Add control command support for VF PMD driver in DPDK
      net: hinic: Add support for configuration of rx-vlan-filter by ethtool
      MAINTAINERS: Update hinic maintainers from orphan

Chen Zhongjin (1):
      wifi: cfg80211: Fix not unregister reg_pdev when load_builtin_regdb_keys() fails

Chethan Tumkur Narayan (1):
      btusb: Avoid reset of ISOC endpoint alt settings to zero

Chia-Yuan Li (2):
      wifi: rtw89: dump dispatch status via debug port
      wifi: rtw89: update D-MAC and C-MAC dump to diagnose SER

Chih-Kang Chang (4):
      wifi: rtw89: collect and send RF parameters to firmware for WoWLAN
      wifi: rtw89: move enable_cpu/disable_cpu into fw_download
      wifi: rtw89: add function to adjust and restore PLE quota
      wifi: rtw89: add drop tx packet function

Chin-Yen Lee (3):
      wifi: rtw89: add related H2C for WoWLAN mode
      wifi: rtw89: add WoWLAN function support
      wifi: rtw89: add WoWLAN pattern match support

Ching-Te Ku (1):
      wifi: rtw89: coex: move chip_ops::btc_bt_aci_imp to a generic code

Christophe JAILLET (14):
      net: usb: Use kstrtobool() instead of strtobool()
      wifi: Use kstrtobool() instead of strtobool()
      wifi: rtw89: Fix some error handling path in rtw89_wow_enable()
      wifi: rtw89: Fix some error handling path in rtw89_core_sta_assoc()
      net/mlx5e: Remove unneeded io-mapping.h #include
      octeontx2-af: Fix a potentially spurious error message
      octeontx2-af: Slightly simplify rvu_npc_exact_init()
      octeontx2-af: Use the bitmap API to allocate bitmaps
      octeontx2-af: Fix the size of memory allocated for the 'id_bmap' bitmap
      octeontx2-af: Simplify a size computation in rvu_npc_exact_init()
      net: xsk: Don't include <linux/rculist.h>
      Bluetooth: Fix EALREADY and ELOOP cases in bt_status()
      octeontx2-af: cn10k: mcs: Fix a resource leak in the probe and remove functions
      net: lan966x: Remove a useless test in lan966x_ptp_add_trap()

Chuang Wang (1):
      net: tun: rebuild error handling in tun_get_user

Coco Li (2):
      IPv6/GRO: generic helper to remove temporary HBH/jumbo header in driver
      bnxt: Use generic HBH removal helper in tx path

Colin Foster (3):
      net: mscc: ocelot: remove redundant stats_layout pointers
      net: mscc: ocelot: remove unnecessary exposure of stats structures
      net: mscc: ocelot: issue a warning if stats are incorrectly ordered

Colin Ian King (19):
      wifi: ath11k: Fix spelling mistake "chnange" -> "change"
      wifi: ath9k: Make arrays prof_prio and channelmap static const
      esp6: remove redundant variable err
      wifi: rtl8xxxu: Fix reads of uninitialized variables hw_ctrl_s1, sw_ctrl_s1
      bna: remove variable num_entries
      net: dl2k: remove variable tx_use
      bpftool: Fix spelling mistake "disasembler" -> "disassembler"
      net/rds: remove variable total_copied
      net: mvneta: Remove unused variable i
      wifi: rtw89: 8852b: Fix spelling mistake KIP_RESOTRE -> KIP_RESTORE
      wifi: ath9k: remove variable sent
      rds: remove redundant variable total_payload_len
      wifi: rtlwifi: rtl8192ee: remove static variable stop_report_cnt
      wifi: iwlegacy: remove redundant variable len
      wifi: ath9k: Remove unused variable mismatch
      net/mlx5: Fix spelling mistake "destoy" -> "destroy"
      sundance: remove unused variable cnt
      nfp: Fix spelling mistake "tha" -> "the"
      xfrm: Fix spelling mistake "oflload" -> "offload"

Daan De Meyer (3):
      selftests/bpf: Install all required files to run selftests
      selftests/bpf: Use "is not set" instead of "=n"
      selftests/bpf: Use CONFIG_TEST_BPF=m instead of CONFIG_TEST_BPF=y

Dan Carpenter (8):
      net: ethernet: renesas: Fix return type in rswitch_etha_wait_link_verification()
      rxrpc: fix rxkad_verify_response()
      rxrpc: uninitialized variable in rxrpc_send_ack_packet()
      net: microchip: sparx5: prevent uninitialized variable
      net: microchip: sparx5: fix uninitialized variables
      netfilter: nft_inner: fix IS_ERR() vs NULL check
      bonding: uninitialized variable in bond_miimon_inspect()
      net: microchip: sparx5: Fix error handling in vcap_show_admin()

Daniel Borkmann (1):
      selftests/bpf: Add bench test to arm64 and s390x denylist

Daniel Gabay (1):
      wifi: iwlwifi: mvm: print OTP info after alive

Daniel Machon (7):
      net: dcb: add new pcp selector to app object
      net: dcb: add new apptrust attribute
      net: microchip: sparx5: add support for offloading pcp table
      net: microchip: sparx5: add support for apptrust
      net: microchip: sparx5: add support for offloading dscp table
      net: microchip: sparx5: add support for offloading default prio
      net: dcb: move getapptrust to separate function

Daniel Müller (6):
      bpf/docs: Update README for most recent vmtest.sh
      samples/bpf: Fix typos in README
      bpf/docs: Summarize CI system and deny lists
      selftests/bpf: Panic on hard/soft lockup
      bpf/docs: Document how to run CI without patch submission
      bpf/docs: Include blank lines between bullet points in bpf_devel_QA.rst

Daniel S. Trevitz (1):
      can: add termination resistor documentation

Daniel Willenson (1):
      ixgbe: change MAX_RXD/MAX_TXD based on adapter type

Dave Marchevsky (7):
      bpf: Allow ringbuf memory to be used as map key
      bpf: Consider all mem_types compatible for map_{key,value} args
      selftests/bpf: Add test verifying bpf_ringbuf_reserve retval use in map ops
      selftests/bpf: Add write to hashmap to array_map iter test
      bpf: Fix release_on_unlock release logic for multiple refs
      selftests/bpf: Validate multiple ref release_on_unlock logic
      bpf: Loosen alloc obj test in verifier's reg_btf_record

Dave Tucker (1):
      bpf, docs: Document BPF_MAP_TYPE_ARRAY

David Girault (1):
      mac802154: Trace the registration of new PANs

David Howells (65):
      net, proc: Provide PROC_FS=n fallback for proc_create_net_single_write()
      rxrpc: Trace setting of the request-ack flag
      rxrpc: Split call timer-expiration from call timer-set tracepoint
      rxrpc: Track highest acked serial
      rxrpc: Add stats procfile and DATA packet stats
      rxrpc: Record statistics about ACK types
      rxrpc: Record stats for why the REQUEST-ACK flag is being set
      rxrpc: Fix ack.bufferSize to be 0 when generating an ack
      net: Change the udp encap_err_rcv to allow use of {ip,ipv6}_icmp_error()
      rxrpc: Use the core ICMP/ICMP6 parsers
      rxrpc: Call udp_sendmsg() directly
      rxrpc: Remove unnecessary header inclusions
      rxrpc: Remove the flags from the rxrpc_skb tracepoint
      rxrpc: Remove call->tx_phase
      rxrpc: Define rxrpc_txbuf struct to carry data to be transmitted
      rxrpc: Allocate ACK records at proposal and queue for transmission
      rxrpc: Clean up ACK handling
      rxrpc: Split the rxrpc_recvmsg tracepoint
      rxrpc: Clone received jumbo subpackets and queue separately
      rxrpc: Get rid of the Rx ring
      rxrpc: Don't use a ring buffer for call Tx queue
      rxrpc: Remove call->lock
      rxrpc: Save last ACK's SACK table rather than marking txbufs
      rxrpc: Remove the rxtx ring
      rxrpc: Fix congestion management
      rxrpc: Allocate an skcipher each time needed rather than reusing
      rxrpc: Fix missing IPV6 #ifdef
      rxrpc: Fix oops from calling udpv6_sendmsg() on AF_INET socket
      rxrpc: Fix network address validation
      rxrpc: Fix checker warning
      rxrpc: Implement an in-kernel rxperf server for testing purposes
      rxrpc: Fix call leak
      rxrpc: Remove decl for rxrpc_kernel_call_is_complete()
      rxrpc: Remove handling of duplicate packets in recvmsg_queue
      rxrpc: Remove the [k_]proto() debugging macros
      rxrpc: Remove the [_k]net() debugging macros
      rxrpc: Drop rxrpc_conn_parameters from rxrpc_connection and rxrpc_bundle
      rxrpc: Extract the code from a received ABORT packet much earlier
      rxrpc: trace: Don't use __builtin_return_address for rxrpc_local tracing
      rxrpc: trace: Don't use __builtin_return_address for rxrpc_peer tracing
      rxrpc: trace: Don't use __builtin_return_address for rxrpc_conn tracing
      rxrpc: trace: Don't use __builtin_return_address for rxrpc_call tracing
      rxrpc: Trace rxrpc_bundle refcount
      rxrpc: trace: Don't use __builtin_return_address for sk_buff tracing
      rxrpc: Don't hold a ref for call timer or workqueue
      rxrpc: Don't hold a ref for connection workqueue
      rxrpc: Split the receive code
      rxrpc: Create a per-local endpoint receive queue and I/O thread
      rxrpc: Move packet reception processing into I/O thread
      rxrpc: Move error processing into the local endpoint I/O thread
      rxrpc: Remove call->input_lock
      rxrpc: Don't use sk->sk_receive_queue.lock to guard socket state changes
      rxrpc: Implement a mechanism to send an event notification to a call
      rxrpc: Copy client call parameters into rxrpc_call earlier
      rxrpc: Move DATA transmission into call processor work item
      rxrpc: Remove RCU from peer->error_targets list
      rxrpc: Simplify skbuff accounting in receive path
      rxrpc: Reduce the use of RCU in packet input
      rxrpc: Extract the peer address from an incoming packet earlier
      rxrpc: Make the I/O thread take over the call and local processor work
      rxrpc: Remove the _bh annotation from all the spinlocks
      rxrpc: Trace/count transmission underflows and cwnd resets
      rxrpc: Move the cwnd degradation after transmitting packets
      rxrpc: Fold __rxrpc_unuse_local() into rxrpc_unuse_local()
      rxrpc: Transmit ACKs at the point of generation

David Michael (1):
      libbpf: Fix uninitialized warning in btf_dump_dump_type_data

David S. Miller (53):
      Merge branch 'net-marvell-yaml'
      Merge branch 'dpaa-phylink'
      Merge branch 'net-bridge-mc-cleanups'
      Merge branch 'dpaa2-eth-AF_XDP-zc'
      Merge branch 'inet6_destroy_sock-calls-remove'
      Merge branch 'sparx5-IS2-VCAP'
      Merge branch 'net-800Gbps-support'
      Merge branch 'udp-false-sharing'
      Merge branch 'ptp-ocxp-Oroli-ART-CARD'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge tag 'ieee802154-for-net-next-2022-10-25' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan-next
      Merge branch 'mxl-gpy-MDI-X'
      Merge branch 'tcp-plb'
      Merge branch 'txgbe'
      Merge branch 'ptp-adjfine'
      Merge branch 'txgbe'
      Merge branch 'renesas-eswitch'
      Merge branch 'net-ipa-more-endpoints'
      Merge branch 'am65-cpsw-suspend-resume'
      Merge branch 'genetlink-per-op-type-policies'
      Merge branch 'dsa-microchip-checking'
      Merge tag 'rxrpc-next-20221108' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs
      Merge branch 'mt7986-WED-RX'
      Merge branch 'sparx5-TC-key'
      Merge branch 'lan966x-xdp'
      Merge branch 'marvell-prestera-AC5X-support'
      Merge branch 'ptp-adjfreq-copnvert'
      Merge branch 'ibmvnic-affinity-hints'
      Merge branch 'sparx5-sorted-VCAP-rules'
      Merge tag 'mlx5-updates-2022-11-12' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'sfc-TC-offload-counters'
      Merge branch 'udp-pernetns-hash'
      Merge branch 'net-try_cmpxchg-conversions'
      Merge branch 'net-atomic-dev-stats'
      Merge branch 'sctp-vrf'
      Merge tag 'wireless-next-2022-11-18' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
      Merge tag 'rxrpc-next-20221116' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs
      Merge branch 'nfp-ipsec-offload'
      Merge branch 'axiennet-mdio-bus-freq'
      Merge branch 'gve-alternate-missed-completions'
      Merge branch 'sarx5-VCAP-debugfs'
      Merge branch 'mptcp-netlink'
      Merge branch 'sparx5-tc-protocol-all'
      Merge branch 'lan966x-extend-xdp-support'
      Merge branch 'net-remove-kmap_atomic'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'r8169-irq-coalesce'
      Merge tag 'rxrpc-next-20221201-b' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs
      Merge branch 'net-sched-retpoline'
      Merge branch 'tun-vnet-uso'
      Merge branch 'net-dev_kfree_skb_irq'
      Merge branch 'ovs-tc-dedup'
      Merge tag 'linux-can-next-for-6.2-20221212' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next

David Vernet (15):
      selftests/bpf: Alphabetize DENYLISTs
      bpf: Allow multiple modifiers in reg_type_str() prefix
      bpf: Allow trusted pointers to be passed to KF_TRUSTED_ARGS kfuncs
      bpf: Add kfuncs for storing struct task_struct * as a kptr
      bpf/selftests: Add selftests for new task kfuncs
      bpf: Enable cgroups to be used as kptrs
      selftests/bpf: Add cgroup kfunc / kptr selftests
      bpf: Add bpf_cgroup_ancestor() kfunc
      selftests/bpf: Add selftests for bpf_cgroup_ancestor() kfunc
      bpf: Don't use idx variable when registering kfunc dtors
      bpf: Add bpf_task_from_pid() kfunc
      selftests/bpf: Add selftests for bpf_task_from_pid()
      bpf: Don't use rcu_users to refcount in task kfuncs
      bpf/docs: Document struct task_struct * kfuncs
      bpf/docs: Document struct cgroup * kfuncs

David Yang (1):
      net: mv643xx_eth: support MII/GMII/RGMII modes for Kirkwood

Davide Tronchin (1):
      net: usb: cdc_ether: add u-blox 0x1343 composition

Delyan Kratunov (1):
      selftests/bpf: fix task_local_storage/exit_creds rcu usage

Denis Kirjanov (1):
      drivers: net: convert to boolean for the mac_managed_pm flag

Deren Wu (3):
      wifi: mt76: fix coverity overrun-call in mt76_get_txpower()
      wifi: mt76: mt7921: Add missing __packed annotation of struct mt7921_clc
      wifi: mt76: do not send firmware FW_FEATURE_NON_DL region

Diana Wang (1):
      nfp: add support for multicast filter

Dmitry Safonov (5):
      jump_label: Prevent key->enabled int overflow
      net/tcp: Separate tcp_md5sig_info allocation into tcp_md5sig_info_add()
      net/tcp: Disable TCP-MD5 static key on tcp_md5sig_info destruction
      net/tcp: Do cleanup on tcp_md5_key_copy() failure
      net/tcp: Separate initialization of twsk

Dmitry Torokhov (4):
      nfc: s3fwrn5: use devm_clk_get_optional_enabled() helper
      ARM: OMAP2+: pdata-quirks: stop including wl12xx.h
      wifi: wl1251: drop support for platform data
      wifi: wl1251: switch to using gpiod API

Dmitry Vyukov (3):
      nfc: Add KCOV annotations
      NFC: nci: Allow to create multiple virtual nci devices
      NFC: nci: Extend virtual NCI deinit test

Dmytro Shytyi (5):
      mptcp: add MSG_FASTOPEN sendmsg flag support
      mptcp: implement delayed seq generation for passive fastopen
      mptcp: add subflow_v(4,6)_send_synack()
      mptcp: add TCP_FASTOPEN sock option
      selftests: mptcp: mptfo Initiator/Listener

Domenico Cerasuolo (1):
      selftests: Fix test group SKIPPED result

Donald Hunter (9):
      bpf, docs: Reformat BPF maps page to be more readable
      docs/bpf: Document BPF_MAP_TYPE_LPM_TRIE map
      docs/bpf: Document BPF ARRAY_OF_MAPS and HASH_OF_MAPS
      docs/bpf: Document BPF map types QUEUE and STACK
      docs/bpf: Fix sample code in MAP_TYPE_ARRAY docs
      docs/bpf: Add table of BPF program types to libbpf docs
      docs/bpf: Document BPF_MAP_TYPE_BLOOM_FILTER
      docs/bpf: Fix sphinx warnings in BPF map docs
      docs/bpf: Add documentation for BPF_MAP_TYPE_SK_STORAGE

Dongliang Mu (1):
      can: ucan: ucan_disconnect(): change unregister_netdev() to unregister_candev()

Double Lo (1):
      brcmfmac: fix CERT-P2P:5.1.10 failure

Doug Berger (1):
      net: bcmgenet: add RX_CLS_LOC_ANY support

Dr. David Alan Gilbert (1):
      net: core: inet[46]_pton strlen len types

Eduard Zingerman (17):
      bpftool: Print newline before '}' for struct with padding only fields
      selftests/bpf: Test btf dump for struct with padding only fields
      libbpf: Resolve enum fwd as full enum64 and vice versa
      selftests/bpf: Tests for enum fwd resolved as full enum64
      libbpf: Hashmap interface update to allow both long and void* keys/values
      libbpf: Resolve unambigous forward declarations
      selftests/bpf: Tests for btf_dedup_resolve_fwds
      libbpf: Hashmap.h update to fix build issues using LLVM14
      bpf: propagate nullness information for reg to reg comparisons
      selftests/bpf: check nullness propagation for reg to reg comparisons
      selftests/bpf: allow unpriv bpf for selftests by default
      bpf: regsafe() must not skip check_ids()
      selftests/bpf: test cases for regsafe() bug skipping check_id()
      bpf: states_equal() must build idmap for all function frames
      selftests/bpf: verify states_equal() maintains idmap across all frames
      bpf: use check_ids() for active_lock comparison
      selftests/bpf: test case for relaxed prunning of active_lock.id

Edward Cree (21):
      netlink: add support for formatted extack messages
      sfc: use formatted extacks instead of efx_tc_err()
      sfc: remove 'log-tc-errors' ethtool private flag
      sfc: check recirc_id match caps before MAE offload
      sfc: add Layer 2 matches to ef100 TC offload
      sfc: add Layer 3 matches to ef100 TC offload
      sfc: add Layer 3 flag matches to ef100 TC offload
      sfc: add Layer 4 matches to ef100 TC offload
      sfc: fix ef100 RX prefix macro
      sfc: add ability for an RXQ to grant credits on refill
      sfc: add start and stop methods to channels
      sfc: add ability for extra channels to receive raw RX buffers
      sfc: add ef100 MAE counter support functions
      sfc: add extra RX channel to receive MAE counter updates on ef100
      sfc: add hashtables for MAE counters and counter ID mappings
      sfc: add functions to allocate/free MAE counters
      sfc: accumulate MAE counter values from update packets
      sfc: attach an MAE counter to TC actions that need it
      sfc: validate MAE action order
      sfc: implement counters readout to TC stats
      sfc: ensure type is valid before updating seen_gen

Edwin Peer (2):
      bnxt_en: refactor VNIC RSS update functions
      bnxt_en: update RSS config using difference algorithm

Eli Cohen (1):
      net/mlx5: Expose vhca_id to debugfs

Emmanuel Grumbach (2):
      wifi: iwlwifi: mei: don't send SAP commands if AMT is disabled
      wifi: iwlwifi: mei: fix tx DHCP packet for devices with new Tx API

Eric Dumazet (30):
      net: add a refcount tracker for kernel sockets
      mptcp: fix tracking issue in mptcp_subflow_create_socket()
      net: dropreason: add SKB_CONSUMED reason
      net: dropreason: propagate drop_reason to skb_release_data()
      net: dropreason: add SKB_DROP_REASON_DUP_FRAG
      net: dropreason: add SKB_DROP_REASON_FRAG_REASM_TIMEOUT
      net: dropreason: add SKB_DROP_REASON_FRAG_TOO_FAR
      tcp: refine tcp_prune_ofo_queue() logic
      net: remove skb->vlan_present
      net: gro: no longer use skb_vlan_tag_present()
      tcp: adopt try_cmpxchg() in tcp_release_cb()
      tcp: tcp_wfree() refactoring
      net: mm_account_pinned_pages() optimization
      ipv6: fib6_new_sernum() optimization
      net: net_{enable|disable}_timestamp() optimizations
      net: adopt try_cmpxchg() in napi_schedule_prep() and napi_complete_done()
      net: adopt try_cmpxchg() in napi_{enable|disable}()
      net: __sock_gen_cookie() cleanup
      net: add atomic_long_t to net_device_stats fields
      ipv6/sit: use DEV_STATS_INC() to avoid data-races
      ipv6: tunnels: use DEV_STATS_INC()
      ipv4: tunnels: use DEV_STATS_INC()
      tcp: annotate data-race around queue->synflood_warned
      net: fix napi_disable() logic error
      net: fix __sock_gen_cookie()
      tcp: use 2-arg optimal variant of kfree_rcu()
      bpf, sockmap: fix race in sock_map_free()
      net/mlx4: rename two constants
      net/mlx4: MLX4_TX_BOUNCE_BUFFER_SIZE depends on MAX_SKB_FRAGS
      net/mlx4: small optimization in mlx4_en_xmit()

Eric Huang (4):
      wifi: rtw89: parse PHY status only when PPDU is to_self
      wifi: rtw89: add BW info for both TX and RX in phy_info
      wifi: rtw89: read CFO from FD or preamble CFO field of phy status ie_type 1 accordingly
      wifi: rtw89: switch BANDEDGE and TX_SHAPE based on OFDMA trigger frame

Eric Pilmore (1):
      ntb_netdev: Use dev_kfree_skb_any() in interrupt context

Evelyn Tsai (2):
      wifi: mt76: mt7915: reserve 8 bits for the index of rf registers
      wifi: mt76: connac: update nss calculation in txs

Eyal Birger (4):
      xfrm: interface: rename xfrm_interface.c to xfrm_interface_core.c
      xfrm: interface: Add unstable helpers for setting/getting XFRM metadata from TC-BPF
      tools: add IFLA_XFRM_COLLECT_METADATA to uapi/linux/if_link.h
      selftests/bpf: add xfrm_info tests

Fabio Estevam (1):
      net: dp83822: Print the SOR1 strap status

Fedor Pchelkin (3):
      wifi: ath9k: hif_usb: fix memory leak of urbs in ath9k_hif_usb_dealloc_tx_urbs()
      wifi: ath9k: hif_usb: Fix use-after-free in ath9k_hif_usb_reg_in_cb()
      wifi: ath9k: verify the expected usb_endpoints are present

Felix Fietkau (14):
      net: dsa: add support for DSA rx offloading via metadata dst
      net: ethernet: mtk_eth_soc: pass correct VLAN protocol ID to the network stack
      net: ethernet: mtk_eth_soc: add support for configuring vlan rx offload
      net: ethernet: mtk_eth_soc: enable hardware DSA untagging
      net: ethernet: mtk_eth_soc: increase tx ring size for QDMA devices
      net: ethernet: mtk_eth_soc: drop packets to WDMA if the ring is full
      net: ethernet: mtk_eth_soc: avoid port_mg assignment on MT7622 and newer
      net: ethernet: mtk_eth_soc: implement multi-queue support for per-port queues
      net: dsa: tag_mtk: assign per-port queues
      net: ethernet: mediatek: ppe: assign per-port queues for offloaded traffic
      wifi: mac80211: add support for restricting netdev features per vif
      wifi: mac80211: fix and simplify unencrypted drop check for mesh
      wifi: mt76: move mt76_rate_power from core to mt76x02 driver code
      wifi: mt76: mt76x02: simplify struct mt76x02_rate_power

Firo Yang (1):
      sctp: sysctl: make extra pointers netns aware

Florian Fainelli (4):
      net: systemport: Add support for RDMA overflow statistic counter
      net: bcmgenet: Clear RGMII_LINK upon link down
      MAINTAINERS: Update NXP FEC maintainer
      dt-bindings: FEC/i.MX DWMAC and INTMUX maintainer

Florian Lehner (1):
      bpf: check max_entries before allocating memory

Florian Westphal (5):
      netfilter: nf_tables: reduce nft_pktinfo by 8 bytes
      netfilter: nft_objref: make it builtin
      netfilter: conntrack: use siphash_4u64
      netfilter: conntrack: merge ipv4+ipv6 confirm functions
      netfilter: conntrack: set icmpv6 redirects as RELATED

Frank (3):
      net: phy: Add driver for Motorcomm yt8521 gigabit ethernet phy
      net: phy: fix yt8521 duplicated argument to & or |
      net: phy: add Motorcomm YT8531S phy id.

Gal Pressman (2):
      ethtool: Fail number of channels change when it conflicts with rxnfc
      net/mlx5e: Use clamp operation instead of open coding it

Gaosheng Cui (2):
      wifi: mt76: Remove unused inline function mt76_wcid_mask_test()
      net: stmmac: fix possible memory leak in stmmac_dvr_probe()

Gavrilov Ilia (1):
      net: devlink: Add missing error check to devlink_resource_put()

Geert Uytterhoeven (1):
      dt-bindings: can: renesas,rcar-canfd: Fix number of channels for R-Car V3U

Geliang Tang (11):
      mptcp: use msk instead of mptcp_sk
      mptcp: change 'first' as a parameter
      mptcp: get sk from msk directly
      selftests: mptcp: use max_time instead of time
      mptcp: add pm listener events
      selftests: mptcp: enhance userspace pm tests
      selftests: mptcp: make evts global in userspace_pm
      selftests: mptcp: listener test for userspace PM
      selftests: mptcp: make evts global in mptcp_join
      selftests: mptcp: listener test for in-kernel PM
      mptcp: use nlmsg_free instead of kfree_skb

Gerhard Engleder (6):
      samples/bpf: Fix map iteration in xdp1_user
      samples/bpf: Fix MAC address swapping in xdp2_kern
      tsnep: Consistent naming of struct net_device
      tsnep: Add ethtool::get_channels support
      tsnep: Throttle interrupts
      tsnep: Rework RX buffer allocation

Gongwei Li (1):
      Bluetooth: btusb: Add a new PID/VID 13d3/3549 for RTL8822CU

Govindarajulu Varadarajan (1):
      enic: define constants for legacy interrupts offset

Gregory Greenman (1):
      wifi: iwlwifi: mei: fix parameter passing to iwl_mei_alive_notif()

Gustavo A. R. Silva (14):
      wifi: ath10k: Replace zero-length arrays with DECLARE_FLEX_ARRAY() helper
      carl9170: Replace zero-length array with DECLARE_FLEX_ARRAY() helper
      can: ucan: Replace zero-length array with DECLARE_FLEX_ARRAY() helper
      wifi: orinoco: Avoid clashing function prototypes
      wifi: cfg80211: Avoid clashing function prototypes
      wifi: hostap: Avoid clashing function prototypes
      wifi: zd1201: Avoid clashing function prototypes
      wifi: airo: Avoid clashing function prototypes
      bna: Avoid clashing function prototypes
      wifi: brcmfmac: Replace one-element array with flexible-array member
      wifi: brcmfmac: Use struct_size() and array_size() in code ralated to struct brcmf_gscan_config
      wifi: brcmfmac: replace one-element array with flexible-array member in struct brcmf_dload_data_le
      wifi: brcmfmac: Use struct_size() in code ralated to struct brcmf_dload_data_le
      net/mlx5e: Replace zero-length arrays with DECLARE_FLEX_ARRAY() helper

Guy Truzman (1):
      net/mlx5e: Add error flow when failing update_rx

Haibo Chen (2):
      can: flexcan: add auto stop mode for IMX93 to support wakeup
      dt-bindings: can: fsl,flexcan: add imx93 compatible

Haijun Liu (1):
      net: wwan: t7xx: Add NAPI support

Haim Dreyfuss (1):
      wifi: mac80211: advertise TWT requester only with HW support

Hangbin Liu (5):
      rtnetlink: pass netlink message header and portid to rtnl_configure_link()
      net: add new helper unregister_netdevice_many_notify
      rtnetlink: Honour NLM_F_ECHO flag in rtnl_newlink_create
      rtnetlink: Honour NLM_F_ECHO flag in rtnl_delete_link
      net/tunnel: wait until all sk_user_data reader finish before releasing the sock

Hans J. Schultz (4):
      bridge: Add MAC Authentication Bypass (MAB) support
      selftests: forwarding: Add MAC Authentication Bypass (MAB) test cases
      bridge: switchdev: Allow device drivers to install locked FDB entries
      net: dsa: mv88e6xxx: read FID when handling ATU violations

Hariprasad Kelam (3):
      octeontx2-af: cn10kb: Add RPM_USX MAC support
      octeontx2-pf: ethtool: Implement get_fec_stats
      octeontx2-af: Add FEC stats for RPM/RPM_USX block

Heiner Kallweit (2):
      net: add netdev_sw_irq_coalesce_default_on()
      r8169: enable GRO software interrupt coalescing per default

Heng Qi (3):
      veth: Avoid drop packets when xdp_redirect performs
      Revert "bpf: veth driver panics when xdp prog attached before veth_open"
      Revert "veth: Avoid drop packets when xdp_redirect performs"

Hilda Wu (2):
      Bluetooth: btrtl: Add btrealtek data struct
      Bluetooth: btusb: Ignore zero length of USB packets on ALT 6 for specific chip

Horatiu Vultur (26):
      net: lan966x: Add define IFH_LEN_BYTES
      net: lan966x: Split function lan966x_fdma_rx_get_frame
      net: lan966x: Add basic XDP support
      net: lan96x: Use page_pool API
      net: microchip: sparx5: kunit test: Fix compile warnings.
      net: lan966x: Add XDP_PACKET_HEADROOM
      net: lan966x: Introduce helper functions
      net: lan966x: Add len field to lan966x_tx_dcb_buf
      net: lan966x: Update rxq memory model
      net: lan966x: Update dma_dir of page_pool_params
      net: lan966x: Add support for XDP_TX
      net: lan966x: Add support for XDP_REDIRECT
      net: microchip: vcap: Merge the vcap_ag_api_kunit.h into vcap_ag_api.h
      net: microchip: vcap: Extend vcap with lan966x
      net: lan966x: Add initial VCAP
      net: lan966x: Add is2 vcap model to vcap API.
      net: lan966x: add vcap registers
      net: lan966x: add tc flower support for VCAP API
      net: lan966x: add tc matchall goto action
      net: lan966x: Add port keyset config and callback interface
      net: microchip: vcap: Implement w32be
      net: microchip: vcap: Change how the rule id is generated
      net: microchip: vcap: Add vcap_get_rule
      net: microchip: vcap: Add vcap_mod_rule
      net: microchip: vcap: Add vcap_rule_get_key_u32
      net: lan966x: Add ptp trap rules

Hou Tao (10):
      selftests/bpf: Use sys_pidfd_open() helper when possible
      bpf: Use rcu_trace_implies_rcu_gp() in bpf memory allocator
      bpf: Use rcu_trace_implies_rcu_gp() in local storage map
      bpf: Use rcu_trace_implies_rcu_gp() for program array freeing
      bpf: Pass map file to .map_update_batch directly
      bpf: Pin the start cgroup in cgroup_iter_seq_init()
      selftests/bpf: Add cgroup helper remove_cgroup()
      selftests/bpf: Add test for cgroup iterator on a dead cgroup
      bpf: Reuse freed element in free_by_rcu during allocation
      bpf: Skip rcu_barrier() if rcu_trace_implies_rcu_gp() is true

Huanhuan Wang (2):
      nfp: add framework to support ipsec offloading
      nfp: implement xfrm callbacks and expose ipsec offload feature to upper layer

Ido Schimmel (51):
      selftests: bridge_vlan_mcast: Delete qdiscs during cleanup
      selftests: bridge_igmp: Remove unnecessary address deletion
      bridge: mcast: Use spin_lock() instead of spin_lock_bh()
      bridge: mcast: Simplify MDB entry creation
      rocker: Avoid unnecessary scheduling of work item
      rocker: Explicitly mark learned FDB entries as offloaded
      bridge: switchdev: Let device drivers determine FDB offload indication
      bridge: switchdev: Reflect MAB bridge port flag to device drivers
      devlink: Add packet traps for 802.1X operation
      mlxsw: spectrum_trap: Register 802.1X packet traps with devlink
      mlxsw: reg: Add Switch Port FDB Security Register
      mlxsw: spectrum: Add an API to configure security checks
      mlxsw: spectrum_switchdev: Prepare for locked FDB notifications
      mlxsw: spectrum_switchdev: Add support for locked FDB notifications
      mlxsw: spectrum_switchdev: Use extack in bridge port flag validation
      mlxsw: spectrum_switchdev: Add locked bridge port support
      selftests: devlink_lib: Split out helper
      selftests: mlxsw: Add a test for EAPOL trap
      selftests: mlxsw: Add a test for locked port trap
      selftests: mlxsw: Add a test for invalid locked bridge port configurations
      devlink: Fix warning when unregistering a port
      bridge: Add missing parentheses
      bridge: mcast: Centralize netlink attribute parsing
      bridge: mcast: Remove redundant checks
      bridge: mcast: Use MDB configuration structure where possible
      bridge: mcast: Propagate MDB configuration structure further
      bridge: mcast: Use MDB group key from configuration structure
      bridge: mcast: Remove br_mdb_parse()
      bridge: mcast: Move checks out of critical section
      bridge: mcast: Remove redundant function arguments
      bridge: mcast: Constify 'group' argument in br_multicast_new_port_group()
      mlxsw: spectrum_router: Use gen_pool for RIF index allocation
      mlxsw: spectrum_router: Parametrize RIF allocation size
      mlxsw: spectrum_router: Add support for double entry RIFs
      mlxsw: spectrum_ipip: Rename Spectrum-2 ip6gre operations
      mlxsw: spectrum_ipip: Add Spectrum-1 ip6gre support
      selftests: mlxsw: Move IPv6 decap_error test to shared directory
      bridge: mcast: Do not derive entry type from its filter mode
      bridge: mcast: Split (*, G) and (S, G) addition into different functions
      bridge: mcast: Place netlink policy before validation functions
      bridge: mcast: Add a centralized error path
      bridge: mcast: Expose br_multicast_new_group_src()
      bridge: mcast: Expose __br_multicast_del_group_src()
      bridge: mcast: Add a flag for user installed source entries
      bridge: mcast: Avoid arming group timer when (S, G) corresponds to a source
      bridge: mcast: Add support for (*, G) with a source list and filter mode
      bridge: mcast: Allow user space to add (*, G) with a source list and filter mode
      bridge: mcast: Allow user space to specify MDB entry routing protocol
      bridge: mcast: Support replacement of MDB port group entries
      selftests: forwarding: Rename bridge_mdb test
      selftests: forwarding: Add bridge MDB test

Igor Skalkin (1):
      virtio_bt: Fix alignment in configuration struct

Ilan Peer (7):
      wifi: ieee80211: Support validating ML station profile length
      wifi: cfg80211/mac80211: Fix ML element common size calculation
      wifi: cfg80211/mac80211: Fix ML element common size validation
      wifi: mac80211: Parse station profile from association response
      wifi: mac80211: Process association status for affiliated links
      wifi: iwlwifi: mvm: Fix getting the lowest rate
      wifi: iwlwifi: mvm: Advertise EHT capabilities

Ilpo Järvinen (1):
      net: wwan: t7xx: Use needed_headroom instead of hard_header_len

Ilya Maximets (1):
      net: tun: bump the link speed from 10Mbps to 10Gbps

Inga Stotland (1):
      Bluetooth: MGMT: Fix error report for ADD_EXT_ADV_PARAMS

Ioana Ciornei (4):
      net: dpaa2-eth: rearrange variable in dpaa2_eth_get_ethtool_stats
      net: dpaa2-eth: export the CH#<index> in the 'ch_stats' debug file
      net: dpaa2-eth: export buffer pool info into a new debugfs file
      net: dpaa2-eth: use dev_close/open instead of the internal functions

JUN-KYU SHIN (1):
      wifi: cfg80211: fix comparison of BSS frequencies

Jacob Keller (38):
      ptp: add missing documentation for parameters
      ptp: introduce helpers to adjust by scaled parts per million
      drivers: convert unsupported .adjfreq to .adjfine
      ptp: mlx4: convert to .adjfine and adjust_by_scaled_ppm
      ptp: mlx5: convert to .adjfine and adjust_by_scaled_ppm
      ptp: lan743x: remove .adjfreq implementation
      ptp: lan743x: use diff_by_scaled_ppm in .adjfine implementation
      ptp: ravb: convert to .adjfine and adjust_by_scaled_ppm
      ptp: xgbe: convert to .adjfine and adjust_by_scaled_ppm
      ptp_phc: convert .adjfreq to .adjfine
      ptp_ixp46x: convert .adjfreq to .adjfine
      ptp: tg3: convert .adjfreq to .adjfine
      ptp: hclge: convert .adjfreq to .adjfine
      ptp: stmac: convert .adjfreq to .adjfine
      ptp: cpts: convert .adjfreq to .adjfine
      ptp: bnxt: convert .adjfreq to .adjfine
      ptp: convert remaining drivers to adjfine interface
      ptp: remove the .adjfreq interface function
      mlxsw: update adjfine to use adjust_by_scaled_ppm
      devlink: use min_t to calculate data_size
      devlink: report extended error message in region_read_dumpit()
      devlink: find snapshot in devlink_nl_cmd_region_read_dumpit
      devlink: remove unnecessary parameter from chunk_fill function
      devlink: refactor region_read_snapshot_fill to use a callback function
      devlink: support directly reading from region memory
      ice: use same function to snapshot both NVM and Shadow RAM
      ice: document 'shadow-ram' devlink region
      ice: implement direct read for NVM and Shadow RAM regions
      ice: fix misuse of "link err" with "link status"
      ice: always call ice_ptp_link_change and make it void
      ice: handle discarding old Tx requests in ice_ptp_tx_tstamp
      ice: check Tx timestamp memory register for ready timestamps
      ice: synchronize the misc IRQ when tearing down Tx tracker
      ice: protect init and calibrating check in ice_ptp_request_ts
      ice: cleanup allocations in ice_ptp_alloc_tx_tracker
      ice: handle flushing stale Tx timestamps in ice_ptp_tx_tstamp
      ice: only check set bits in ice_ptp_flush_tx_tracker
      ice: reschedule ice_ptp_wait_for_offset_valid during reset

Jakob Koschel (1):
      wifi: iwlwifi: mvm: replace usage of found with dedicated list iterator variable

Jakub Kicinski (113):
      Merge tag 'for-netdev' of git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge branch 'netlink-formatted-extacks'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'bnxt_en-driver-updates'
      Merge branch 'net-sfp-improve-high-power-module-implementation'
      Merge branch 'net-lan743x-pci11010-pci11414-devices-enhancements'
      Merge tag 'ieee802154-for-net-next-2022-10-26' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan-next
      phylink: require valid state argument to phylink_validate_mask_caps()
      eth: fealnx: delete the driver for Myson MTD-800
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'ionic-vf-attr-replay-and-other-updates'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next
      Kalle Valo says:
      Merge branch 'net-remove-the-obsolte-u64_stats_fetch_-_irq'
      Merge branch 'net-mtk_eth_soc-improve-pcs-implementation'
      Merge branch 'clean-up-sfp-register-definitions'
      Merge branch 'net-ipa-start-adding-ipa-v5-0-functionality'
      Merge tag 'mlx5-updates-2022-10-24' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      netlink: split up copies in the ack construction
      net: geneve: fix array of flexible structures warnings
      Merge branch 'rtnetlink-honour-nlm_f_echo-flag-in-rtnl_-new-del-link'
      Merge branch 'inet-add-drop-monitor-support'
      Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge branch 'rocker-two-small-changes'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'bridge-add-mac-authentication-bypass-mab-support'
      Merge branch 'net-fix-netdev-to-devlink_port-linkage-and-expose-to-user'
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'sfc-add-basic-flower-matches-to-offload'
      genetlink: refactor the cmd <> policy mapping dump
      genetlink: move the private fields in struct genl_family
      genetlink: introduce split op representation
      genetlink: load policy based on validation flags
      genetlink: check for callback type at op load time
      genetlink: add policies for both doit and dumpit in ctrl_dumppolicy_start()
      genetlink: support split policies in ctrl_dumppolicy_put_op()
      genetlink: inline genl_get_cmd()
      genetlink: add iterator for walking family ops
      genetlink: use iterator in the op to policy map dumping
      genetlink: inline old iteration helpers
      genetlink: allow families to use split ops directly
      genetlink: convert control family to split ops
      Merge branch '10GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'net-txgbe-fix-two-bugs-in-txgbe_calc_eeprom_checksum'
      ethtool: linkstate: add a statistic for PHY down events
      genetlink: correctly begin the iteration over policies
      Merge branch 'net-devlink-move-netdev-notifier-block-to-dest-namespace-during-reload'
      Merge branch 'mlxsw-add-802-1x-and-mab-offload-support'
      Merge branch 'net-lan743x-pci11010-pci11414-devices-enhancements'
      Merge branch 'clean-up-pcs-xpcs-accessors'
      Merge branch 'mana-shared-6.2' of https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma
      genetlink: fix single op policy dump when do is present
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'net-vlan-claim-one-bit-from-sk_buff'
      Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge branch 'mptcp-miscellaneous-refactoring-and-small-fixes'
      Merge branch 'dt-bindings-net-qcom-ipa-relax-some-restrictions'
      Merge branch 'genirq-msi-treewide-cleanup-of-pointless-linux-msi-h-includes'
      Merge branch 'mtk_eth_soc-rx-vlan-offload-improvement-dsa-hardware-untag-support'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next
      Merge branch 'remove-phylink_validate-from-felix-dsa-driver'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'net-dsa-use-more-appropriate-net_name_-constants-for-user-ports'
      Merge branch 'autoload-dsa-tagging-driver-when-dynamically-changing-protocol'
      Merge branch 'implement-devlink-rate-api-and-extend-it'
      Merge branch 'net-ipa-change-gsi-firmware-load-specification'
      netlink: remove the flex array from struct nlmsghdr
      Merge branch 'i2c/client_device_id_helper-immutable' of git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
      Merge branch 'remove-dsa_priv-h'
      Merge branch 'revert-veth-avoid-drop-packets-when-xdp_redirect-performs-and-its-fix'
      Merge branch 'net-complete-conversion-to-i2c_probe_new'
      Merge branch 'bonding-fix-bond-recovery-in-mode-2'
      Daniel Borkmann says:
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'mptcp-msg_fastopen-and-tfo-listener-side-support'
      Merge branch 'net-pcs-altera-tse-simplify-and-clean-up-the-driver'
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next
      Merge branch 'support-direct-read-from-region'
      Merge branch 'net-devlink-return-the-driver-name-in-devlink_nl_info_fill'
      Merge tag 'mlx5-updates-2022-11-29' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'locking/core' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
      Merge branch 'net-tcp-dynamically-disable-tcp-md5-static-key'
      Merge branch 'remove-label-cpu-from-dsa-dt-binding'
      bnxt: report FEC block stats via standard interface
      Merge branch 'mptcp-pm-listener-events-selftests-cleanup'
      Merge branch 'hsr'
      Merge tag 'wireless-next-2022-12-02' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
      Merge tag 'ieee802154-for-net-next-2022-12-05' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan-next
      Merge branch 'bridge-mcast-preparations-for-evpn-extensions'
      Merge branch 'devlink-add-port-function-attribute-to-enable-disable-roce-and-migratable'
      Merge branch 'net-ethernet-ti-am65-cpsw-fix-set-channel-operation'
      Merge branch 'mlx5-Support-tc-police-jump-conform-exceed-attribute'
      Merge branch 'mlx4-better-big-tcp-support'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'mlxsw-add-spectrum-1-ip6gre-support'
      Merge branch 'fix-possible-deadlock-during-wed-attach'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge tag 'mlx5-updates-2022-12-08' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'mptcp-miscellaneous-cleanup'
      Merge tag 'ipsec-next-2022-12-09' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next
      Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge tag 'wireless-next-2022-12-12' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
      Merge branch 'update-joakim-zhang-entries'
      Merge branch 'mptcp-fix-ipv6-reqsk-ops-and-some-netlink-error-codes'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next
      Merge tag 'for-net-next-2022-12-12' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next
      Merge branch 'trace-points-for-mv88e6xxx'
      Merge branch 'net-add-iff_no_addrconf-to-prevent-ipv6-addrconf'
      Merge branch 'bridge-mcast-extensions-for-evpn'
      Merge branch 'net-ipa-enable-ipa-v4-7-support'
      ipvs: fix type warning in do_div() on 32 bit

James Hilliard (2):
      selftests/bpf: Add GCC compatible builtins to bpf_legacy.h
      selftests/bpf: Fix conflicts with built-in functions in bpf_iter_ksym

Jamie Bainbridge (1):
      tcp: Add listening address to SYN flood message

Jan Sokolowski (1):
      ixgbevf: Add error messages on vlan error

Jean Delvare (1):
      can: ctucanfd: Drop obsolete dependency on COMPILE_TEST

Jeff Johnson (3):
      net: ipa: Make QMI message rules const
      wifi: ath10k: Make QMI message rules const
      wifi: ath11k: Make QMI message rules const

Jeroen Hofstee (4):
      can: gs_usb: document GS_CAN_FEATURE_BERR_REPORTING
      can: gs_usb: add ability to enable / disable berr reporting
      can: gs_usb: document GS_CAN_FEATURE_GET_STATE
      can: gs_usb: add support for reading error counters

Jeroen de Borst (2):
      gve: Adding a new AdminQ command to verify driver
      gve: Handle alternate miss completions

Jerry Ray (1):
      net: lan9303: Fix read error execution path

Ji Rongfeng (1):
      bpf: Update bpf_{g,s}etsockopt() documentation

Ji-Pin Jou (1):
      wifi: rtw88: fix race condition when doing H2C command

Jiapeng Chong (8):
      net: ip6_gre: Remove the unused function ip6gre_tnl_addr_conflict()
      wifi: ipw2200: Remove the unused function ipw_alive()
      netfilter: rpfilter/fib: clean up some inconsistent indenting
      lib/test_rhashtable: Remove set but unused variable 'insert_retries'
      wifi: ipw2x00: Remove some unused functions
      net: bcmgenet: Remove the unused function
      Bluetooth: Use kzalloc instead of kmalloc/memset
      qlcnic: Clean up some inconsistent indenting

Jiawen Wu (6):
      net: txgbe: Store PCI info
      net: txgbe: Reset hardware
      net: txgbe: Set MAC address and register netdev
      net: libwx: Implement interaction with firmware
      net: txgbe: Add operations to interact with firmware
      net: libwx: Fix dead code for duplicate check

Jie Meng (4):
      bpf, x64: Remove unnecessary check on existence of SSE2
      bpf,x64: avoid unnecessary instructions when shift dest is ecx
      bpf,x64: use shrx/sarx/shlx when available
      bpf: add selftests for lsh, rsh, arsh with reg operand

Jilin Yuan (1):
      net/ieee802154: fix repeated words in comments

Jimmy Assarsson (5):
      can: kvaser_usb: kvaser_usb_leaf: Get capabilities from device
      can: kvaser_usb: kvaser_usb_leaf: Rename {leaf,usbcan}_cmd_error_event to {leaf,usbcan}_cmd_can_error_event
      can: kvaser_usb: kvaser_usb_leaf: Handle CMD_ERROR_EVENT
      can: kvaser_usb: Add struct kvaser_usb_busparams
      can: kvaser_usb: Compare requested bittiming parameters with actual parameters in do_set_{,data}_bittiming

Jiri Olsa (9):
      selftests/bpf: Add missing bpf_iter_vma_offset__destroy call
      kallsyms: Make module_kallsyms_on_each_symbol generally available
      ftrace: Add support to resolve module symbols in ftrace_lookup_symbols
      bpf: Rename __bpf_kprobe_multi_cookie_cmp to bpf_kprobe_multi_addrs_cmp
      bpf: Take module reference on kprobe_multi link
      selftests/bpf: Add load_kallsyms_refresh function
      selftests/bpf: Add bpf_testmod_fentry_* functions
      selftests/bpf: Add kprobe_multi check to module attach test
      selftests/bpf: Add kprobe_multi kmod attach api tests

Jiri Pirko (17):
      net: devlink: convert devlink port type-specific pointers to union
      net: devlink: move port_type_warn_schedule() call to __devlink_port_type_set()
      net: devlink: move port_type_netdev_checks() call to __devlink_port_type_set()
      net: devlink: take RTNL in port_fill() function only if it is not held
      net: devlink: track netdev with devlink_port assigned
      net: make drivers to use SET_NETDEV_DEVLINK_PORT to set devlink_port
      net: devlink: remove netdev arg from devlink_port_type_eth_set()
      net: devlink: remove net namespace check from devlink_nl_port_fill()
      net: devlink: store copy netdevice ifindex and ifname to allow port_fill() without RTNL held
      net: devlink: add not cleared type warning to port unregister
      net: devlink: use devlink_port pointer instead of ndo_get_devlink_port
      net: remove unused ndo_get_devlink_port
      net: expose devlink port over rtnetlink
      net: introduce a helper to move notifier block to different namespace
      net: devlink: move netdev notifier block to dest namespace during reload
      net: devlink: add WARN_ON_ONCE to check return value of unregister_netdevice_notifier_net() call
      net: devlink: convert port_list into xarray

Jiri Slaby (SUSE) (4):
      wifi: ath11k: synchronize ath11k_mac_he_gi_to_nl80211_he_gi()'s return type
      qed (gcc13): use u16 for fid to be big enough
      bonding (gcc13): synchronize bond_{a,t}lb_xmit() types
      sfc (gcc13): synchronize ef100_enqueue_skb()'s return type

Jisoo Jang (1):
      wifi: brcmfmac: Fix potential NULL pointer dereference in 'brcmf_c_preinit_dcmds()'

Joe Damato (4):
      i40e: Store the irq number in i40e_q_vector
      i40e: Record number TXes cleaned during NAPI
      i40e: Record number of RXes cleaned during NAPI
      i40e: Add i40e_napi_poll tracepoint

Johannes Berg (34):
      wifi: mac80211: recalc station aggregate data during link switch
      wifi: cfg80211: support reporting failed links
      wifi: mac80211: wme: use ap_addr instead of deflink BSSID
      wifi: mac80211: transmit AddBA with MLD address
      wifi: nl80211: use link ID in NL80211_CMD_SET_BSS
      wifi: mac80211: use link_id in ieee80211_change_bss()
      wifi: mac80211: set internal scan request BSSID
      wifi: mac80211: fix AddBA response addressing
      wifi: mac80211: add RCU _check() link access variants
      wifi: fix multi-link element subelement iteration
      wifi: mac80211: mlme: fix null-ptr deref on failed assoc
      wifi: mac80211: check link ID in auth/assoc continuation
      wifi: mac80211: mlme: mark assoc link in output
      wifi: mac80211: change AddBA deny error message
      wifi: mac80211: don't clear DTIM period after setting it
      wifi: mac80211: prohibit IEEE80211_HT_CAP_DELAY_BA with MLO
      wifi: mac80211: agg-rx: avoid band check
      wifi: mac80211: remove support for AddBA with fragmentation
      wifi: mac80211: fix ifdef symbol name
      Merge remote-tracking branch 'wireless/main' into wireless-next
      wifi: realtek: remove duplicated wake_tx_queue
      wifi: iwlwifi: mei: fix potential NULL-ptr deref after clone
      wifi: iwlwifi: mvm: use old checksum for Bz A-step
      wifi: iwlwifi: mvm: support new key API
      wifi: iwlwifi: mvm: support 320 MHz PHY configuration
      wifi: iwlwifi: mvm: set HE PHY bandwidth according to band
      wifi: iwlwifi: mvm: advertise 320 MHz in 6 GHz only conditionally
      wifi: iwlwifi: nvm-parse: support A-MPDU in EHT 2.4 GHz
      wifi: mac80211: remove unnecessary synchronize_net()
      wifi: cfg80211: use bss_from_pub() instead of container_of()
      wifi: mac80211: don't parse multi-BSSID in assoc resp
      wifi: iwlwifi: nvm-parse: enable WiFi7 for Fm radio for now
      wifi: iwlwifi: modify new queue allocation command
      wifi: iwlwifi: fw: use correct IML/ROM status register

John Fastabend (1):
      bpf: veth driver panics when xdp prog attached before veth_open

Jonathan Neuschäfer (1):
      wifi: brcmfmac: Fix a typo "unknow"

Jonathan Toppins (4):
      selftests: bonding: up/down delay w/ slave link flapping
      bonding: fix link recovery in mode 2 when updelay is nonzero
      Documentation: bonding: update miimon default to 100
      Documentation: bonding: correct xmit hash steps

Juhee Kang (2):
      net: remove unused netdev_unregistering()
      r8169: use tp_to_dev instead of open code

Julian Anastasov (6):
      ipvs: add rcu protection to stats
      ipvs: use common functions for stats allocation
      ipvs: use u64_stats_t for the per-cpu counters
      ipvs: use kthreads for stats estimation
      ipvs: add est_cpulist and est_nice sysctl vars
      ipvs: run_estimation should control the kthread tasks

Jun ASAKA (1):
      wifi: rtl8xxxu: fixing IQK failures for rtl8192eu

Junxiao Chang (1):
      net: stmmac: remove duplicate dma queue channel macros

Kalle Valo (7):
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge tag 'iwlwifi-next-for-kalle-2022-11-06-v2' of http://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge tag 'mt76-for-kvalo-2022-12-01' of https://github.com/nbd168/wireless
      Merge tag 'iwlwifi-next-for-kalle-2022-11-28' of http://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      wifi: ath10k: fix QCOM_SMEM dependency
      Merge tag 'iwlwifi-next-for-kalle-2022-12-07' of http://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next

Kang Minchul (6):
      samples/bpf: Fix typo in README
      selftests/bpf: Fix u32 variable compared with less than zero
      libbpf: checkpatch: Fixed code alignments in btf.c
      libbpf: Fixed various checkpatch issues in libbpf.c
      libbpf: checkpatch: Fixed code alignments in ringbuf.c
      Bluetooth: Use kzalloc instead of kmalloc/memset

Karol Kolacinski (2):
      ice: Check for PTP HW lock more frequently
      ice: Reset TS memory for all quads

Karthikeyan Periyasamy (1):
      wifi: ath11k: suppress add interface error

Kees Cook (18):
      wifi: atmel: Avoid clashing function prototypes
      wifi: ath9k: Remove -Warray-bounds exception
      wifi: carl9170: Remove -Warray-bounds exception
      can: kvaser_usb: Remove -Warray-bounds exception
      openvswitch: Use kmalloc_size_roundup() to match ksize() usage
      net: ipa: Proactively round up to kmalloc bucket size
      bnx2: Use kmalloc_size_roundup() to match ksize() usage
      net: dev: Convert sa_data to flexible array in struct sockaddr
      skbuff: Proactively round up to kmalloc bucket size
      wifi: atmel: Fix atmel_private_handler array size
      igb: Do not free q_vector unless new one was allocated
      igb: Proactively round up to kmalloc bucket size
      bpf/verifier: Use kmalloc_size_roundup() to match ksize() usage
      wifi: p54: Replace zero-length array of trailing structs with flex-array
      wifi: carl9170: Replace zero-length array of trailing structs with flex-array
      wifi: ieee80211: Do not open-code qos address offsets
      net/ncsi: Silence runtime memcpy() false positive warning
      skbuff: Introduce slab_build_skb()

Kieran Frewen (1):
      wifi: mac80211: update TIM for S1G specification changes

Krzysztof Kozlowski (2):
      dt-bindings: net: constrain number of 'reg' in ethernet ports
      dt-bindings: net: dsa-port: constrain number of 'reg' in ports

Kumar Kartikeya Dwivedi (49):
      bpf: Document UAPI details for special BPF types
      bpf: Allow specifying volatile type modifier for kptrs
      bpf: Clobber stack slot when writing over spilled PTR_TO_BTF_ID
      bpf: Fix slot type check in check_stack_write_var_off
      bpf: Drop reg_type_may_be_refcounted_or_null
      bpf: Refactor kptr_off_tab into btf_record
      bpf: Consolidate spin_lock, timer management into btf_record
      bpf: Refactor map->off_arr handling
      bpf: Remove local kptr references in documentation
      bpf: Remove BPF_MAP_OFF_ARR_MAX
      bpf: Fix copy_map_value, zero_map_value
      bpf: Support bpf_list_head in map values
      bpf: Rename RET_PTR_TO_ALLOC_MEM
      bpf: Rename MEM_ALLOC to MEM_RINGBUF
      bpf: Refactor btf_struct_access
      bpf: Fix early return in map_check_btf
      bpf: Do btf_record_free outside map_free callback
      bpf: Free inner_map_meta when btf_record_dup fails
      bpf: Populate field_offs for inner_map_meta
      bpf: Introduce allocated objects support
      bpf: Recognize lock and list fields in allocated objects
      bpf: Verify ownership relationships for user BTF types
      bpf: Allow locking bpf_spin_lock in allocated objects
      bpf: Allow locking bpf_spin_lock global variables
      bpf: Allow locking bpf_spin_lock in inner map values
      bpf: Rewrite kfunc argument handling
      bpf: Support constant scalar arguments for kfuncs
      bpf: Introduce bpf_obj_new
      bpf: Introduce bpf_obj_drop
      bpf: Permit NULL checking pointer with non-zero fixed offset
      bpf: Introduce single ownership BPF linked list API
      bpf: Add 'release on unlock' logic for bpf_list_push_{front,back}
      bpf: Add comments for map BTF matching requirement for bpf_list_head
      selftests/bpf: Add __contains macro to bpf_experimental.h
      selftests/bpf: Update spinlock selftest
      selftests/bpf: Add failure test cases for spin lock pairing
      selftests/bpf: Add BPF linked list API tests
      selftests/bpf: Add BTF sanity tests
      selftests/bpf: Temporarily disable linked list tests
      selftests/bpf: Skip spin lock failure test on s390x
      bpf: Disallow bpf_obj_new_impl call when bpf_mem_alloc_init fails
      bpf: Refactor ARG_PTR_TO_DYNPTR checks into process_dynptr_func
      bpf: Propagate errors from process_* checks in check_func_arg
      bpf: Rework process_dynptr_func
      bpf: Rework check_func_arg_reg_off
      bpf: Move PTR_TO_STACK alignment check to process_dynptr_func
      bpf: Use memmove for bpf_dynptr_{read,write}
      selftests/bpf: Add test for dynptr reinit in user_ringbuf callback
      selftests/bpf: Add pruning test case for bpf_spin_lock

Kunihiko Hayashi (1):
      net: ethernet: ave: Remove duplicate phy_resume() calls

Kuniyuki Iwashima (13):
      inet6: Remove inet6_destroy_sock() in sk->sk_prot->destroy().
      dccp: Call inet6_destroy_sock() via sk->sk_destruct().
      sctp: Call inet6_destroy_sock() via sk->sk_destruct().
      inet6: Remove inet6_destroy_sock().
      inet6: Clean up failure path in do_ipv6_setsockopt().
      soreuseport: Fix socket selection for SO_INCOMING_CPU.
      selftest: Add test for SO_INCOMING_CPU.
      udp: Clean up some functions.
      udp: Set NULL to sk->sk_prot->h.udp_table.
      udp: Set NULL to udp_seq_afinfo.udp_table.
      udp: Access &udp_table via net.
      udp: Introduce optional per-netns hash table.
      net: Return errno in sk->sk_prot->get_port().

Kurt Kanzenbach (1):
      dt-bindings: net: dsa: hellcreek: Sync DSA maintainers

Lad Prabhakar (1):
      dt-bindings: can: renesas,rcar-canfd: Document RZ/Five SoC

Leon Romanovsky (41):
      xfrm: Remove not-used total variable
      net/mlx5e: Don't access directly DMA device pointer
      net/mlx5e: Delete always true DMA check
      net/mlx5: Remove redundant check
      net/mlx5e: Support devlink reload of IPsec core
      xfrm: add new packet offload flag
      xfrm: allow state packet offload mode
      xfrm: add an interface to offload policy
      xfrm: add TX datapath support for IPsec packet offload mode
      xfrm: add RX datapath protection for IPsec packet offload mode
      xfrm: speed-up lookup of HW policies
      xfrm: add support to HW update soft and hard limits
      xfrm: document IPsec packet offload mode
      net/mlx5: Return ready to use ASO WQE
      net/mlx5: Add HW definitions for IPsec packet offload
      net/mlx5e: Advertise IPsec packet offload support
      net/mlx5e: Store replay window in XFRM attributes
      net/mlx5e: Remove extra layers of defines
      net/mlx5e: Create symmetric IPsec RX and TX flow steering structs
      net/mlx5e: Use mlx5 print routines for low level IPsec code
      net/mlx5e: Remove accesses to priv for low level IPsec FS code
      net/mlx5e: Create Advanced Steering Operation object for IPsec
      net/mlx5e: Create hardware IPsec packet offload objects
      net/mlx5e: Move IPsec flow table creation to separate function
      net/mlx5e: Refactor FTE setup code to be more clear
      net/mlx5e: Flatten the IPsec RX add rule path
      net/mlx5e: Make clear what IPsec rx_err does
      net/mlx5e: Group IPsec miss handles into separate struct
      net/mlx5e: Generalize creation of default IPsec miss group and rule
      net/mlx5e: Create IPsec policy offload tables
      net/mlx5e: Add XFRM policy offload logic
      net/mlx5e: Use same coding pattern for Rx and Tx flows
      net/mlx5e: Configure IPsec packet offload flow steering
      net/mlx5e: Improve IPsec flow steering autogroup
      net/mlx5e: Skip IPsec encryption for TX path without matching policy
      net/mlx5e: Provide intermediate pointer to access IPsec struct
      net/mlx5e: Store all XFRM SAs in Xarray
      net/mlx5e: Update IPsec soft and hard limits
      net/mlx5e: Handle hardware IPsec limits events
      net/mlx5e: Handle ESN update events
      net/mlx5e: Open mlx5 driver to accept IPsec packet offload

Leon Yen (1):
      wifi: mt76: mt7921e: add pci .shutdown() support

Li Qiong (1):
      netfilter: flowtable: add a 'default' case to flowtable datapath

Li Zetao (1):
      net: farsync: Fix kmemleak when rmmods farsync

Li zeming (2):
      ax25: af_ax25: Remove unnecessary (void*) conversions
      sctp: sm_statefuns: Remove pointer casts of the same type

Linus Walleij (4):
      bcma: support SPROM rev 11
      bcma: gpio: Convert to immutable gpio irqchip
      bcma: Use the proper gpio include
      bcma: Fail probe if GPIO subdriver fails

Liu Shixin (1):
      wifi: wil6210: debugfs: use DEFINE_SHOW_ATTRIBUTE to simplify fw_capabilities/fw_version

Long Li (8):
      net: mana: Add support for auxiliary device
      net: mana: Record the physical address for doorbell page region
      net: mana: Handle vport sharing between devices
      net: mana: Export Work Queue functions for use by RDMA driver
      net: mana: Record port number in netdev
      net: mana: Move header files to a common location
      net: mana: Define max values for SGL entries
      net: mana: Define data structures for allocating doorbell page from GDMA

Lorenzo Bianconi (34):
      arm64: dts: mediatek: mt7986: add support for RX Wireless Ethernet Dispatch
      dt-bindings: net: mediatek: add WED RX binding for MT7986 eth driver
      net: ethernet: mtk_wed: introduce wed wo support
      net: ethernet: mtk_wed: rename tx_wdma array in rx_wdma
      net: ethernet: mtk_wed: add configure wed wo support
      net: ethernet: mtk_wed: add rx mib counters
      MAINTAINERS: update MEDIATEK ETHERNET entry
      net: ethernet: mtk_eth_soc: do not overwrite mtu configuration running reset routine
      net: ethernet: mtk_eth_soc: remove cpu_relax in mtk_pending_work
      net: ethernet: mtk_eth_soc: fix RSTCTRL_PPE{0,1} definitions
      net: ethernet: mtk_wed: return status value in mtk_wdma_rx_reset
      net: ethernet: mtk_wed: move MTK_WDMA_RESET_IDX_TX configuration in mtk_wdma_tx_reset
      net: ethernet: mtk_wed: update mtk_wed_stop
      net: ethernet: mtk_wed: add mtk_wed_rx_reset routine
      net: ethernet: mtk_wed: add reset to tx_ring_setup callback
      wifi: mt76: mt7915: move wed init routines in mmio.c
      wifi: mt76: mt7915: enable wed for mt7986 chipset
      wifi: mt76: mt7915: enable wed for mt7986-wmac chipset
      wifi: mt76: mt7915: fix reporting of TX AGGR histogram
      wifi: mt76: mt7921: fix reporting of TX AGGR histogram
      wifi: mt76: mt7615: rely on mt7615_phy in mt7615_mac_reset_counters
      wifi: mt76: move aggr_stats array in mt76_phy
      wifi: mt76: do not run mt76u_status_worker if the device is not running
      wifi: mt76: add WED RX support to mt76_dma_{add,get}_buf
      wifi: mt76: add WED RX support to mt76_dma_rx_fill
      wifi: mt76: add WED RX support to dma queue alloc
      wifi: mt76: mt7915: enable WED RX support
      wifi: mt76: mt76x0: remove dead code in mt76x0_phy_get_target_power
      wifi: mt76: mt7915: mmio: fix naming convention
      net: ethernet: mtk_wed: fix sleep while atomic in mtk_wed_wo_queue_refill
      net: mtk_eth_soc: enable flow offload support for MT7986 SoC
      net: ethernet: mtk_wed: add reset to rx_ring_setup callback
      net: ethernet: mtk_wed: fix some possible NULL pointer dereferences
      net: ethernet: mtk_wed: fix possible deadlock if mtk_wed_wo_init fails

Luca Coelho (2):
      wifi: iwlwifi: cfg: disable STBC for BL step A devices
      wifi: iwlwifi: mvm: print an error instead of a warning on invalid rate

Luca Weiss (3):
      dt-bindings: nfc: nxp,nci: Document NQ310 compatible
      dt-bindings: bluetooth: broadcom: add BCM43430A0 & BCM43430A1
      dt-bindings: net: qcom,ipa: Add SM6350 compatible

Luiz Augusto von Dentz (11):
      Bluetooth: hci_sync: Fix not setting static address
      Bluetooth: hci_sync: Fix not able to set force_static_address
      Bluetooth: btusb: Add CONFIG_BT_HCIBTUSB_POLL_SYNC
      Bluetooth: btusb: Default CONFIG_BT_HCIBTUSB_POLL_SYNC=y
      Bluetooth: Add CONFIG_BT_LE_L2CAP_ECRED
      Bluetooth: btusb: Fix new sparce warnings
      Bluetooth: btusb: Fix existing sparce warning
      Bluetooth: btintel: Fix existing sparce warnings
      Bluetooth: hci_conn: Fix crash on hci_create_cis_sync
      Bluetooth: ISO: Avoid circular locking dependency
      Bluetooth: Wait for HCI_OP_WRITE_AUTH_PAYLOAD_TO to complete

Lukas Bulwahn (2):
      net: fman: remove reference to non-existing config PCS
      wifi: b43: remove reference to removed config B43_PCMCIA

Lukasz Czapnik (1):
      ice: Add additional CSR registers to ETHTOOL_GREGS

M Chetan Kumar (2):
      net: wwan: t7xx: use union to group port type specific data
      net: wwan: t7xx: Add port for modem logging

Maksym Glubokiy (1):
      net: marvell: prestera: pci: add support for AC5X family devices

Manikanta Pubbisetty (1):
      wifi: ath11k: add support to configure channel dwell time

Manu Bretelle (4):
      selftests/bpf: Remove entries from config.s390x already present in config
      selftests/bpf: Add config.aarch64
      selftests/bpf: Update vmtests.sh to support aarch64
      selftests/bpf: Initial DENYLIST for aarch64

Maor Dickman (2):
      net/mlx5e: TC, Add offload support for trap with additional actions
      net/mlx5e: multipath, support routes with more than 2 nexthops

Marc Kleine-Budde (16):
      can: m_can: is_lec_err(): clean up LEC error handling
      can: gs_usb: mention candleLight as supported device
      can: gs_usb: gs_make_candev(): set netdev->dev_id
      can: gs_usb: gs_can_open(): allow loopback and listen only at the same time
      can: gs_usb: gs_can_open(): sort checks for ctrlmode
      can: gs_usb: gs_can_open(): merge setting of timestamp flags and init
      Merge patch series "can: gs_usb: new features: GS_CAN_FEATURE_GET_STATE, GS_CAN_FEATURE_BERR_REPORTING"
      Merge patch series "can: kvaser_usb: Fixes and improvements"
      can: m_can: use consistent indention
      can: kvaser_usb: kvaser_usb_set_bittiming(): fix redundant initialization warning for err
      can: kvaser_usb: kvaser_usb_set_{,data}bittiming(): remove empty lines in variable declaration
      Merge patch series "R-Car CAN FD driver enhancements"
      Merge patch series "can: etas_es58x: report firmware, bootloader and hardware version"
      Merge patch series "can: usb: remove pointers to struct usb_interface in device's priv structures"
      can: raw: add support for SO_MARK
      Merge patch series "can: m_can: Optimizations for tcan and peripheral chips"

Marcin Szycik (1):
      ice: Fix configuring VIRTCHNL_OP_CONFIG_VSI_QUEUES with unbalanced queues

Marcin Wojtas (2):
      arm64: dts: marvell: Update network description to match schema
      ARM: dts: armada-375: Update network description to match schema

Marek Vasut (3):
      wifi: rsi: Fix handling of 802.3 EAPOL frames sent via control port
      dt-bindings: net: broadcom-bluetooth: Add CYW4373A0 DT binding
      Bluetooth: hci_bcm: Add CYW4373A0 support

Markus Schneider-Pargmann (11):
      can: m_can: Eliminate double read of TXFQS in tx_handler
      can: m_can: Avoid reading irqstatus twice
      can: m_can: Read register PSR only on error
      can: m_can: Count TXE FIFO getidx in the driver
      can: m_can: Count read getindex in the driver
      can: m_can: Batch acknowledge transmit events
      can: m_can: Batch acknowledge rx fifo
      can: tcan4x5x: Remove invalid write in clear_interrupts
      can: tcan4x5x: Fix use of register error status mask
      can: tcan4x5x: Fix register range of first two blocks
      can: tcan4x5x: Specify separate read/write ranges

Martin KaFai Lau (23):
      selftests/bpf: S/iptables/iptables-legacy/ in the bpf_nf and xdp_synproxy test
      bpf: Remove prog->active check for bpf_lsm and bpf_iter
      bpf: Append _recur naming to the bpf_task_storage helper proto
      bpf: Refactor the core bpf_task_storage_get logic into a new function
      bpf: Avoid taking spinlock in bpf_task_storage_get if potential deadlock is detected
      bpf: Add new bpf_task_storage_get proto with no deadlock detection
      bpf: bpf_task_storage_delete_recur does lookup first before the deadlock check
      bpf: Add new bpf_task_storage_delete proto with no deadlock detection
      selftests/bpf: Ensure no task storage failure for bpf_lsm.s prog due to deadlock detection
      selftests/bpf: Tracing prog can still do lookup under busy lock
      Merge branch 'fix panic bringing up veth with xdp progs'
      bpf: Add hwtstamp field for the sockops prog
      selftests/bpf: Fix incorrect ASSERT in the tcp_hdr_options test
      selftests/bpf: Test skops->skb_hwtstamp
      selftests/bpf: Use if_nametoindex instead of reading the /sys/net/class/*/ifindex
      selftests/bpf: Avoid pinning bpf prog in the tc_redirect_dtime test
      selftests/bpf: Avoid pinning bpf prog in the tc_redirect_peer_l3 test
      selftests/bpf: Avoid pinning bpf prog in the netns_load_bpf() callers
      selftests/bpf: Remove the "/sys" mount and umount dance in {open,close}_netns
      selftests/bpf: Remove serial from tests using {open,close}_netns
      selftests/bpf: Avoid pinning prog when attaching to tc ingress in btf_skc_cls_ingress
      Merge branch 'xfrm: interface: Add unstable helpers for XFRM metadata'
      selftests/bpf: Allow building bpf tests with CONFIG_XFRM_INTERFACE=[m|n]

Maryam Tahhan (6):
      docs/bpf: Document BPF_MAP_TYPE_CPUMAP map
      bpf, docs: Fixup cpumap sphinx >= 3.1 warning
      bpf, docs: DEVMAPs and XDP_REDIRECT
      docs/bpf: Fix sphinx warnings for cpumap
      docs/bpf: Fix sphinx warnings for devmap
      docs/bpf: Add BPF_MAP_TYPE_XSKMAP documentation

Mat Martineau (1):
      mptcp: Fix grammar in a comment

Matthieu Baerts (13):
      mptcp: sockopt: make 'tcp_fastopen_connect' generic
      mptcp: add TCP_FASTOPEN_NO_COOKIE support
      mptcp: sockopt: use new helper for TCP_DEFER_ACCEPT
      mptcp: add support for TCP_FASTOPEN_KEY sockopt
      selftests: mptcp: run mptcp_inq from a clean netns
      selftests: mptcp: removed defined but unused vars
      selftests: mptcp: uniform 'rndh' variable
      selftests: mptcp: clearly declare global ns vars
      selftests: mptcp: declare var as local
      mptcp: return 0 instead of 'err' var
      mptcp: remove MPTCP 'ifdef' in TCP SYN cookies
      mptcp: dedicated request sock for subflow in v6
      mptcp: use proper req destructor for IPv6

Maxim Korotkov (1):
      ethtool: avoiding integer overflow in ethtool_phys_id()

Maxime Chevallier (3):
      net: pcs: altera-tse: use read_poll_timeout to wait for reset
      net: pcs: altera-tse: don't set the speed for 1000BaseX
      net: pcs: altera-tse: remove unnecessary register definitions

Md Fahad Iqbal Polash (1):
      ice: virtchnl rss hena support

Mengyuan Lou (1):
      net: ngbe: Initialize sw info and register netdev

Miaoqian Lin (1):
      bpftool: Fix memory leak in do_build_table_cb

Michael Chan (1):
      bnxt_en: Update firmware interface to 1.10.2.118

Michael Guralnik (1):
      net/mlx5: Expose steering dropped packets counter

Michael S. Tsirkin (1):
      Bluetooth: virtio_bt: fix device removal

Michael Sit Wei Hong (1):
      net: stmmac: Add check for taprio basetime configuration

Michael Walle (2):
      wifi: wilc1000: sdio: fix module autoloading
      net: phy: mxl-gpy: rename MMD_VEND1 macros to match datasheet

Michal Jaron (1):
      ice: Add support Flex RXD

Michal Wilczynski (11):
      devlink: Introduce new attribute 'tx_priority' to devlink-rate
      devlink: Introduce new attribute 'tx_weight' to devlink-rate
      devlink: Enable creation of the devlink-rate nodes from the driver
      devlink: Allow for devlink-rate nodes parent reassignment
      devlink: Allow to set up parent in devl_rate_leaf_create()
      ice: Introduce new parameters in ice_sched_node
      ice: Add an option to pre-allocate memory for ice_sched_node
      ice: Implement devlink-rate API
      ice: Prevent ADQ, DCB coexistence with Custom Tx scheduler
      ice: Add documentation for devlink-rate implementation
      Documentation: Add documentation for new devlink-rate attributes

Michał Grzelak (1):
      dt-bindings: net: marvell,pp2: convert to json-schema

Milena Olech (1):
      ice: Remove the E822 vernier "bypass" logic

Min Li (2):
      ptp: idt82p33: Add PTP_CLK_REQ_EXTTS support
      ptp: idt82p33: remove PEROUT_ENABLE_OUTPUT_MASK

Ming Yen Hsieh (1):
      wifi: mt76: fix bandwidth 80MHz link fail in 6GHz band

Minghao Chi (1):
      can: c_can: use devm_platform_get_and_ioremap_resource()

Minsuk Kang (2):
      wifi: brcmfmac: Fix potential shift-out-of-bounds in brcmf_fw_alloc_request()
      wifi: brcmfmac: Check the count value of channel spec to prevent out-of-bounds reads

Miquel Raynal (32):
      net: mac802154: Rename the synchronous xmit worker
      net: mac802154: Rename the main tx_work struct
      net: mac802154: Enhance the error path in the main tx helper
      net: mac802154: Follow the count of ongoing transmissions
      net: mac802154: Bring the ability to hold the transmit queue
      net: mac802154: Create a hot tx path
      net: mac802154: Introduce a helper to disable the queue
      net: mac802154: Introduce a tx queue flushing mechanism
      net: mac802154: Introduce a synchronous API for MLME commands
      net: mac802154: Add a warning in the hot path
      net: mac802154: Add a warning in the slow path
      net: mac802154: Fix a Tx warning check
      mac802154: Introduce filtering levels
      ieee802154: hwsim: Record the address filter values
      ieee802154: hwsim: Implement address filtering
      mac802154: Drop IEEE802154_HW_RX_DROP_BAD_CKSUM
      mac802154: Avoid delivering frames received in a non satisfying filtering mode
      net: mac802154: Avoid displaying misleading debug information
      ieee802154: hwsim: Introduce a helper to update all the PIB attributes
      ieee802154: hwsim: Save the current filtering level and use it
      mac802154: Ensure proper scan-level filtering
      mac802154: Move an skb free within the rx path
      mac802154: Clarify an expression
      mac802154: Allow the creation of coordinator interfaces
      Revert "dt-bindings: marvell,prestera: Add description for device-tree bindings"
      dt-bindings: net: marvell,dfx-server: Convert to yaml
      dt-bindings: net: marvell,prestera: Convert to yaml
      dt-bindings: net: marvell,prestera: Describe PCI devices of the prestera family
      of: net: export of_get_mac_address_nvmem()
      net: marvell: prestera: Avoid unnecessary DT lookups
      net: mvpp2: Consider NVMEM cells as possible MAC address source
      ieee802154: Advertize coordinators discovery

Miri Korenblit (2):
      wifi: iwlwifi: mvm: support PPE Thresholds for EHT
      wifi: iwlwifi: mvm: Don't use deprecated register

Mordechay Goodstein (3):
      wifi: iwlwifi: rs: add support for parsing max MCS per NSS/BW in 11be
      wifi: iwlwifi: mvm: add support for EHT 1K aggregation size
      wifi: iwlwifi: mvm: don't access packet before checking len

Moshe Shemesh (2):
      net/mlx5: Unregister traps on driver unload flow
      devlink: remove redundant health state set to error

Mubashir Adnan Qureshi (5):
      tcp: add sysctls for TCP PLB parameters
      tcp: add PLB functionality for TCP
      tcp: add support for PLB in DCTCP
      tcp: add u32 counter in tcp_sock and an SNMP counter for PLB
      tcp: add rcv_wnd and plb_rehash to TCP_INFO

Muhammad Husaini Zulkifli (1):
      igc: Correct the launchtime offset

Mukesh Sisodiya (3):
      wifi: iwlwifi: dump: Update check for valid FW address
      wifi: iwlwifi: pcie: Add reading and storing of crf and cdb id.
      wifi: iwlwifi: dump: Update check for UMAC valid FW address

Naftali Goldstein (1):
      wifi: iwlwifi: mvm: d3: add TKIP to the GTK iterator

Nagarajan Maran (1):
      wifi: ath11k: fix monitor vdev creation with firmware recovery

Nathan Chancellor (6):
      net: ethernet: ti: Fix return type of netcp_ndo_start_xmit()
      hamradio: baycom_epp: Fix return type of baycom_send_packet()
      net: ethernet: renesas: Fix return type of rswitch_start_xmit()
      s390/ctcm: Fix return type of ctc{mp,}m_tx()
      s390/netiucv: Fix return type of netiucv_tx()
      s390/lcs: Fix return type of lcs_start_xmit()

Nathan Huckleberry (1):
      net: mana: Fix return type of mana_start_xmit()

Neel Patel (2):
      ionic: enable tunnel offloads
      ionic: refactor use of ionic_rx_fill()

Nick Child (4):
      ibmveth: Always stop tx queues during close
      ibmvnic: Assign IRQ affinity hints to device queues
      ibmvnic: Add hotpluggable CPU callbacks to reassign affinity hints
      ibmvnic: Update XPS assignments during affinity binding

Nicolas Cavallari (4):
      wifi: mt76: mt7915: Fix chainmask calculation on mt7915 DBDC
      wifi: mt76: mt7915: Fix VHT beamforming capabilities with DBDC
      wifi: mt76: mt7915: don't claim 160MHz support with mt7915 DBDC
      Bluetooth: Work around SCO over USB HCI design defect

Ofer Levi (1):
      net/mlx5e: Support enhanced CQE compression

Oleksandr Mazur (2):
      net: marvell: prestera: pci: use device-id defines
      net: marvell: prestera: pci: bump supported FW min version

Oleksij Rempel (8):
      net: dsa: microchip: move max mtu to one location
      net: dsa: microchip: do not store max MTU for all ports
      net: dsa: microchip: add ksz_rmw8() function
      net: dsa: microchip: ksz8: add MTU configuration support
      net: dsa: microchip: enable MTU normalization for KSZ8795 and KSZ9477 compatible switches
      net: dsa: microchip: ksz8: move all DSA configurations to one location
      net: asix: add support for the Linux Automation GmbH USB 10Base-T1L
      net: dsa: microchip: add stats64 support for ksz8 series of switches

Oliver Hartkopp (1):
      can: remove obsolete PCH CAN driver

Or Har-Toov (1):
      net/mlx5: Refactor and expand rep vport stat group

Oz Shlomo (15):
      net/mlx5e: CT, optimize pre_ct table lookup
      net/mlx5e: E-Switch, handle flow attribute with no destinations
      net/mlx5: fs, assert null dest pointer when dest_num is 0
      net/mlx5e: TC, reuse flow attribute post parser processing
      net/mlx5e: TC, add terminating actions
      net/mlx5e: TC, validate action list per attribute
      net/mlx5e: TC, set control params for branching actions
      net/mlx5e: TC, initialize branch flow attributes
      net/mlx5e: TC, initialize branching action with target attr
      net/mlx5e: TC, rename post_meter actions
      net/mlx5e: TC, init post meter rules with branching attributes
      net/mlx5e: TC, allow meter jump control action
      net/mlx5e: meter, refactor to allow multiple post meter tables
      net/mlx5e: meter, add mtu post meter tables
      net/mlx5e: TC, add support for meter mtu offload

Pablo Neira Ayuso (9):
      netfilter: nft_payload: move struct nft_payload_set definition where it belongs
      netfilter: nft_payload: access GRE payload via inner offset
      netfilter: nft_payload: access ipip payload for inner offset
      netfilter: nft_inner: support for inner tunnel header matching
      netfilter: nft_inner: add percpu inner context
      netfilter: nft_meta: add inner match support
      netfilter: nft_inner: add geneve support
      netfilter: nft_inner: set tunnel offset to GRE header offset
      netfilter: nft_payload: use __be16 to store gre version

Paolo Abeni (23):
      net: introduce and use custom sockopt socket flag
      udp: track the forward memory release threshold in an hot cacheline
      Merge branch 'extend-action-skbedit-to-rx-queue-mapping'
      Merge branch 'net-ipa-validation-cleanup'
      Merge branch 'soreuseport-fix-broken-so_incoming_cpu'
      Merge branch 'mptcp-socket-option-updates'
      Merge branch 'net-ipa-don-t-use-fixed-table-sizes'
      Merge branch 'add-new-pcp-and-apptrust-attributes-to-dcbnl'
      Merge branch 'net-add-helper-support-in-tc-act_ct-for-ovs-offloading'
      Merge branch 'bnxt_en-updates'
      mptcp: deduplicate error paths on endpoint creation
      mptcp: more detailed error reporting on endpoint creation
      Merge branch 'cleanup-ocelot_stats-exposure'
      Merge branch 'marvell-nvmem-mac-addresses-support'
      Merge branch 'refactor-mtk_wed-code-to-introduce-ser-support'
      Merge branch 'add-support-for-lan966x-is2-vcap'
      mptcp: track accurately the incoming MPC suboption type
      mptcp: consolidate initial ack seq generation
      Merge branch 'fix-rtnl_mutex-deadlock-with-dpaa2-and-sfp-modules'
      Merge branch 'net-lan966x-enable-ptp-on-bridge-interfaces'
      Merge branch 'net-dsa-microchip-add-mtu-support-for-ksz8-series'
      Merge branch 'cn10kb-mac-block-support'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net

Paul E. McKenney (1):
      rcu-tasks: Provide rcu_trace_implies_rcu_gp()

Pauli Virtanen (1):
      Bluetooth: hci_conn: use HCI dst_type values also for BIS

Pavan Chebbi (1):
      bnxt_en: Add a non-real time mode to access NIC clock

Pedro Tammela (4):
      net/sched: move struct action_ops definition out of ifdef
      net/sched: add retpoline wrapper for tc
      net/sched: avoid indirect act functions on retpoline kernels
      net/sched: avoid indirect classify functions on retpoline kernels

Peng Wu (1):
      netfilter: nft_inner: fix return value check in nft_inner_parse_l2l3()

Pengcheng Yang (4):
      bpf, sockmap: Fix repeated calls to sock_put() when msg has more_data
      bpf, sockmap: Fix missing BPF_F_INGRESS flag when using apply_bytes
      bpf, sockmap: Fix data loss caused by using apply_bytes on ingress redirect
      selftests/bpf: Add ingress tests for txmsg with apply_bytes

Peter Chiu (1):
      wifi: mt76: mt7915: deal with special variant of mt7916

Peter Kosyh (3):
      wifi: ath10k: Check return value of ath10k_get_arvif() in ath10k_wmi_event_tdls_peer()
      wifi: rtlwifi: rtl8192se: remove redundant rtl_get_bbreg() call
      wifi: rtlwifi: btcoexist: fix conditions branches that are never executed

Peter Seiderer (1):
      wifi: mac80211: minstrel_ht: remove unused has_mrr member from struct minstrel_priv

Petr Pavlu (1):
      net/mlx5: Remove unused ctx variables

Phil Sutter (2):
      netfilter: nf_tables: Extend nft_expr_ops::dump callback parameters
      netfilter: nf_tables: Introduce NFT_MSG_GETRULE_RESET

Philipp Hortmann (1):
      wifi: cfg80211: Correct example of ieee80211_iface_limit

Piergiorgio Beruto (1):
      stmmac: fix potential division by 0

Ping-Ke Shih (44):
      wifi: rtw89: 8852b: add BB and RF tables (1 of 2)
      wifi: rtw89: 8852b: add BB and RF tables (2 of 2)
      wifi: rtw89: 8852b: add tables for RFK
      wifi: rtw89: 8852b: add chip_ops::set_txpwr
      wifi: rtw89: 8852b: add chip_ops to read efuse
      wifi: rtw89: 8852b: add chip_ops to read phy cap
      wifi: rtw89: 8852be: add 8852BE PCI entry
      wifi: rtw89: 8852c: correct set of IQK backup registers
      wifi: rtw89: 8852c: rfk: correct miscoding delay of DPK
      wifi: rtw89: 8852c: update BB parameters to v28
      wifi: rtw89: phy: ignore warning of bb gain cfg_type 4
      wifi: rtw89: 8852c: set pin MUX to enable BT firmware log
      wifi: rtw89: add to dump TX FIFO 0/1 for 8852C
      wifi: rtw89: 8852b: set proper configuration before loading NCTL
      wifi: rtw89: 8852b: add HFC quota arrays
      wifi: rtw89: make generic functions to convert subband gain index
      wifi: rtw89: 8852b: add chip_ops::set_channel
      wifi: rtw89: 8852b: add chip_ops::set_channel_help
      wifi: rtw89: 8852b: add power on/off functions
      wifi: rtw89: 8852b: add basic baseband chip_ops
      wifi: rtw89: 8852b: add chip_ops to get thermal
      wifi: rtw89: 8852b: add chip_ops related to BT coexistence
      wifi: rtw89: 8852b: add chip_ops to query PPDU
      wifi: rtw89: 8852b: add chip_ops to configure TX/RX path
      wifi: rtw89: 8852b: add functions to control BB to assist RF calibrations
      wifi: rtw89: 8852b: add basic attributes of chip_info
      wifi: rtw89: 8852b: rfk: add DACK
      wifi: rtw89: 8852b: rfk: add RCK
      wifi: rtw89: 8852b: rfk: add RX DCK
      wifi: rtw89: 8852b: rfk: add IQK
      wifi: rtw89: 8852b: rfk: add TSSI
      wifi: rtw89: 8852b: rfk: add DPK
      wifi: rtw89: 8852b: add chip_ops related to RF calibration
      wifi: rtw89: phy: add dummy C2H handler to avoid warning message
      wifi: rtw89: 8852b: add 8852be to Makefile and Kconfig
      wifi: rtw89: fw: adapt to new firmware format of dynamic header
      wifi: rtw89: 8852c: make table of RU mask constant
      wifi: rtw89: use u32_encode_bits() to fill MAC quota value
      wifi: rtw89: 8852b: change debug mask of message of no TX resource
      wifi: rtw89: 8852b: correct TX power controlled by BT-coexistence
      wifi: rtw89: avoid inaccessible IO operations during doing change_interface()
      wifi: rtw89: add HE radiotap for monitor mode
      wifi: rtw89: 8852b: turn off PoP function in monitor mode
      wifi: rtw88: 8821c: enable BT device recovery mechanism

Po-Hao Huang (6):
      wifi: rtw89: correct 6 GHz scan behavior
      wifi: rtw89: fix wrong bandwidth settings after scan
      wifi: rtw89: add mac TSF sync function
      wifi: rtw89: stop mac port function when stop_ap()
      wifi: rtw89: fix unsuccessful interface_add flow
      wifi: rtw89: add join info upon create interface

Prasanna Kerekoppa (2):
      brcmfmac: Fix AP interface delete issue
      wifi: brcmfmac: Avoiding Connection delay

Pu Lehui (1):
      riscv, bpf: Emit fixed-length instructions for BPF_PSEUDO_FUNC

Quan Zhou (1):
      wifi: mt76: mt7921: add unified ROC cmd/event support

Quentin Monnet (10):
      bpftool: Set binary name to "bpftool" in help and version output
      bpftool: Add "bootstrap" feature to version output
      bpftool: Define _GNU_SOURCE only once
      bpftool: Remove asserts from JIT disassembler
      bpftool: Split FEATURE_TESTS/FEATURE_DISPLAY definitions in Makefile
      bpftool: Group libbfd defs in Makefile, only pass them if we use libbfd
      bpftool: Refactor disassembler for JIT-ed programs
      bpftool: Add LLVM as default library for disassembling JIT-ed programs
      bpftool: Support setting alternative arch for JIT disasm with LLVM
      bpftool: Add llvm feature to "bpftool version"

Raed Salem (1):
      net/mlx5e: Add statistics for Rx/Tx IPsec offloaded flows

Rafał Miłecki (2):
      net: broadcom: bcm4908_enet: use build_skb()
      net: broadcom: bcm4908_enet: report queued and transmitted bytes

Rahul Bhattacharjee (1):
      wifi: ath11k: Fix qmi_msg_handler data structure initialization

Rahul Rameshbabu (1):
      net/mlx5: Fix orthography errors in documentation

Raju Lakkaraju (6):
      net: lan743x: Add support for get_pauseparam and set_pauseparam
      net: phy: micrel: Add PHY Auto/MDI/MDI-X set driver for KSZ9131
      net: phy: mxl-gpy: Change gpy_update_interface() function return type
      net: phy: mxl-gpy: Add PHY Auto/MDI/MDI-X set driver for GPY211 chips
      net: lan743x: Remove unused argument in lan743x_common_regs( )
      net: lan743x: Add support to SGMII register dump for PCI11010/PCI11414 chips

Rakesh Babu Saladi (1):
      octeontx2-af: Support variable number of lmacs

Rakesh Sankaranarayanan (5):
      net: dsa: microchip: add ksz9563 in ksz_switch_ops and select based on compatible string
      net: dsa: microchip: add irq in i2c probe
      net: dsa: microchip: add error checking for ksz_pwrite
      net: dsa: microchip: ksz8563: Add number of port irq
      net: dsa: microchip: add dev_err_probe in probe functions

Raman Varabets (1):
      Bluetooth: btusb: Add Realtek 8761BUV support ID 0x2B89:0x8761

Ramesh Rangavittal (1):
      brcmfmac: Fix authentication latency caused by OBSS stats survey

Randy Dunlap (1):
      net: phy: remove redundant "depends on" lines

Rasmus Villemoes (3):
      net: dsa: refactor name assignment for user ports
      net: dsa: use NET_NAME_PREDICTABLE for user ports with name given in DT
      net: dsa: set name_assign_type to NET_NAME_ENUM for enumerated user ports

Revanth Kumar Uppala (1):
      net: stmmac: Power up SERDES after the PHY link

Richard Gobert (2):
      gro: avoid checking for a failed search
      net: setsockopt: fix IPV6_UNICAST_IF option for connected sockets

Rob Herring (1):
      dt-bindings: net: Convert Socionext NetSec Ethernet to DT schema

Robert Marko (4):
      dt-bindings: net: ipq4019-mdio: document IPQ6018 compatible
      dt-bindings: net: ipq4019-mdio: add IPQ8074 compatible
      dt-bindings: net: ipq4019-mdio: require and validate clocks
      dt-bindings: net: ipq4019-mdio: document required clock-names

Robert-Ionut Alexa (8):
      net: dpaa2-eth: add support to query the number of queues through ethtool
      net: dpaa2-eth: add support for multiple buffer pools per DPNI
      net: dpaa2-eth: update the dpni_set_pools() API to support per QDBIN pools
      net: dpaa2-eth: create and export the dpaa2_eth_alloc_skb function
      net: dpaa2-eth: create and export the dpaa2_eth_receive_skb() function
      net: dpaa2-eth: AF_XDP RX zero copy support
      net: dpaa2-eth: AF_XDP TX zero copy support
      net: dpaa2-eth: add trace points on XSK events

Roberto Sassu (6):
      libbpf: Fix LIBBPF_1.0.0 declaration in libbpf.map
      libbpf: Introduce bpf_get_fd_by_id_opts and bpf_map_get_fd_by_id_opts()
      libbpf: Introduce bpf_prog_get_fd_by_id_opts()
      libbpf: Introduce bpf_btf_get_fd_by_id_opts()
      libbpf: Introduce bpf_link_get_fd_by_id_opts()
      selftests/bpf: Add tests for _opts variants of bpf_*_get_fd_by_id()

Roger Quadros (12):
      net: ethernet: ti: am65-cpsw/cpts: Add suspend/resume helpers
      net: ethernet: ti: am65-cpsw: Add suspend/resume support
      net: ethernet: ti: cpsw_ale: Add cpsw_ale_restore() helper
      net: ethernet: ti: am65-cpsw: retain PORT_VLAN_REG after suspend/resume
      net: ethernet: ti: am65-cpsw: Fix hardware switch mode on suspend/resume
      Revert "net: ethernet: ti: am65-cpsw: Fix hardware switch mode on suspend/resume"
      Revert "net: ethernet: ti: am65-cpsw: retain PORT_VLAN_REG after suspend/resume"
      Revert "net: ethernet: ti: am65-cpsw: Add suspend/resume support"
      net: ethernet: ti: am65-cpsw: Add suspend/resume support
      net: ethernet: ti: am65-cpsw: retain PORT_VLAN_REG after suspend/resume
      net: ethernet: ti: am65-cpsw: Fix hardware switch mode on suspend/resume
      net: ethernet: ti: am65-cpsw: Fix PM runtime leakage in am65_cpsw_nuss_ndo_slave_open()

Roi Dayan (4):
      net/mlx5: Bridge, Use debug instead of warn if entry doesn't exists
      net/mlx5e: TC, Remove redundant WARN_ON()
      net/mlx5e: Don't use termination table when redundant
      net/mlx5e: Do early return when setup vports dests for slow path flow

Roman Gushchin (1):
      net: macb: implement live mac addr change

Rong Tao (5):
      samples/bpf: Fix tracex2 error: No such file or directory
      selftests/bpf: cgroup_helpers.c: Fix strncpy() fortify warning
      samples/bpf: Fix sockex3 error: Missing BPF prog type
      docs/bpf: Update btf selftests program and add link
      samples/bpf: Fix wrong allocation size in xdp_router_ipv4_user

Rotem Saado (2):
      wifi: iwlwifi: dbg: add support for DBGC4 on BZ family and above
      wifi: iwlwifi: dbg: use bit of DRAM alloc ID to store failed allocs

Russell King (Oracle) (26):
      net: phylink: provide phylink_validate_mask_caps() helper
      dt-bindings: net: sff,sfp: update binding
      net: sfp: check firmware provided max power
      net: sfp: ignore power level 2 prior to SFF-8472 Rev 10.2
      net: sfp: ignore power level 3 prior to SFF-8472 Rev 11.4
      net: sfp: provide a definition for the power level select bit
      net: sfp: add sfp_modify_u8() helper
      net: sfp: get rid of DM7052 hack when enabling high power
      net: phylink: add phylink_get_link_timer_ns() helper
      net: mtk_eth_soc: add definitions for PCS
      net: mtk_eth_soc: eliminate unnecessary error handling
      net: mtk_eth_soc: add pcs_get_state() implementation
      net: mtk_eth_soc: convert mtk_sgmii to use regmap_update_bits()
      net: mtk_eth_soc: add out of band forcing of speed and duplex in pcs_link_up
      net: mtk_eth_soc: move PHY power up
      net: mtk_eth_soc: move interface speed selection
      net: mtk_eth_soc: add advertisement programming
      net: mtk_eth_soc: move and correct link timer programming
      net: mtk_eth_soc: add support for in-band 802.3z negotiation
      net: sfp: convert register indexes from hex to decimal
      net: sfp: move field definitions along side register index
      net: lan966x: move unnecessary linux/sfp.h include
      net: remove explicit phylink_generic_validate() references
      net: mdio: add mdiodev_c45_(read|write)
      net: pcs: xpcs: use mdiodev accessors
      net: sfp: clean up i2c-bus property parsing

Ryder Lee (18):
      wifi: mt76: mt7915: fix mt7915_mac_set_timing()
      wifi: mt76: mt7915: improve accuracy of time_busy calculation
      wifi: mt76: mt7915: add ack signal support
      wifi: mt76: mt7915: enable use_cts_prot support
      wifi: mt76: mt7615: enable use_cts_prot support
      wifi: mt76: mt7915: add full system reset into debugfs
      wifi: mt76: mt7915: enable coredump support
      wifi: mt76: mt7915: add missing MODULE_PARM_DESC
      wifi: mt76: mt7915: add support to configure spatial reuse parameter set
      wifi: mt76: mt7915: add basedband Txpower info into debugfs
      wifi: mt76: mt7915: enable .sta_set_txpwr support
      wifi: mt76: mt7915: fix band_idx usage
      wifi: mt76: mt7915: introduce mt7915_get_power_bound()
      wifi: mt76: mt7915: enable per bandwidth power limit support
      wifi: mt76: mt7915: rely on band_idx of mt76_phy
      wifi: mt76: mt7996: enable use_cts_prot support
      wifi: mt76: mt7996: enable ack signal support
      wifi: mt76: mt7996: add support to configure spatial reuse parameter set

Sabrina Dubroca (7):
      xfrm: a few coding style clean ups
      xfrm: add extack to xfrm_add_sa_expire
      xfrm: add extack to xfrm_del_sa
      xfrm: add extack to xfrm_new_ae and xfrm_replay_verify_len
      xfrm: add extack to xfrm_do_migrate
      xfrm: add extack to xfrm_alloc_userspi
      xfrm: add extack to xfrm_set_spdinfo

Saeed Mahameed (2):
      net/mlx5e: ethtool: get_link_ext_stats for PHY down events
      tcp: Fix build break when CONFIG_IPV6=n

Sahid Orentino Ferdjaoui (5):
      bpftool: remove support of --legacy option for bpftool
      bpftool: replace return value PTR_ERR(NULL) with 0
      bpftool: fix error message when function can't register struct_ops
      bpftool: clean-up usage of libbpf_get_error()
      bpftool: remove function free_btf_vmlinux()

Samuel Holland (1):
      dt-bindings: net: realtek-bluetooth: Add RTL8723DS

Sascha Hauer (11):
      wifi: rtw88: print firmware type in info message
      wifi: rtw88: Call rtw_fw_beacon_filter_config() with rtwdev->mutex held
      wifi: rtw88: Drop rf_lock
      wifi: rtw88: Drop h2c.lock
      wifi: rtw88: Drop coex mutex
      wifi: rtw88: iterate over vif/sta list non-atomically
      wifi: rtw88: Add common USB chip support
      wifi: rtw88: Add rtw8821cu chipset support
      wifi: rtw88: Add rtw8822bu chipset support
      wifi: rtw88: Add rtw8822cu chipset support
      wifi: rtw88: Add rtw8723du chipset support

Sasha Neftin (3):
      e1000e: Separate MTP board type from ADP
      e1000e: Add support for the next LOM generation
      e1000e: Add e1000e trace module

Saurabh Sengar (1):
      net: mana: Assign interrupts to CPUs based on NUMA nodes

Schspa Shi (1):
      mrp: introduce active flags to prevent UAF when applicant uninit

Sean Anderson (10):
      dt-bindings: net: Expand pcs-handle to an array
      dt-bindings: net: Add Lynx PCS binding
      dt-bindings: net: fman: Add additional interface properties
      net: fman: memac: Add serdes support
      net: fman: memac: Use lynx pcs driver
      net: dpaa: Convert to phylink
      powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G
      powerpc: dts: qoriq: Add nodes for QSGMII PCSs
      arm64: dts: layerscape: Add nodes for QSGMII PCSs
      net: dpaa2: Add some debug prints on deferred probe

Sean Wang (7):
      wifi: mt76: mt7921: fix antenna signal are way off in monitor mode
      wifi: mt76: connac: add mt76_connac_mcu_uni_set_chctx
      wifi: mt76: mt7921: add chanctx parameter to mt76_connac_mcu_uni_add_bss signature
      wifi: mt76: mt7921: drop ieee80211_[start, stop]_queues in driver
      wifi: mt76: connac: accept hw scan request at a time
      wifi: mt76: mt7921: introduce remain_on_channel support
      wifi: mt76: mt7921: introduce chanctx support

Sebastian Andrzej Siewior (8):
      Revert "net: hsr: use hlist_head instead of list_head for mac addresses"
      hsr: Add a rcu-read lock to hsr_forward_skb().
      hsr: Avoid double remove of a node.
      hsr: Disable netpoll.
      hsr: Synchronize sending frames to have always incremented outgoing seq nr.
      hsr: Synchronize sequence number updates.
      hsr: Use a single struct for self_node.
      selftests: Add a basic HSR test.

Sebastian Reichel (1):
      dt-bindings: net: snps,dwmac: Document queue config subnodes

Sergei Antonov (1):
      net: ftmac100: allow increasing MTU to make most use of single-segment buffers

Sergey Temerkhanov (1):
      ice: Use more generic names for ice_ptp_tx fields

Shailend Chand (1):
      gve: Reduce alloc and copy costs in the GQ rx path

Shane Parslow (1):
      net: wwan: iosm: add rpc interface for xmm modems

Shannon Nelson (3):
      ionic: replay VF attributes after fw crash recovery
      ionic: only save the user set VF attributes
      ionic: new ionic device identity level and VF start control

Shaomin Deng (1):
      samples/bpf: Fix double word in comments

Shay Drory (6):
      devlink: Validate port function request
      devlink: Move devlink port function hw_addr attr documentation
      devlink: Expose port function commands to control RoCE
      net/mlx5: Add generic getters for other functions caps
      devlink: Expose port function commands to control migratable
      net/mlx5: E-Switch, Implement devlink port function cmds to control migratable

Shayne Chen (14):
      wifi: mt76: mt7915: rework eeprom tx paths and streams init
      wifi: mt76: mt7915: rework testmode tx antenna setting
      wifi: mt76: connac: introduce mt76_connac_spe_idx()
      wifi: mt76: mt7915: add spatial extension index support
      wifi: mt76: mt7915: set correct antenna for radar detection on MT7915D
      wifi: mt76: connac: rework macros for unified command
      wifi: mt76: connac: update struct sta_rec_phy
      wifi: mt76: connac: rework fields for larger bandwidth support in sta_rec_bf
      wifi: mt76: connac: add more unified command IDs
      wifi: mt76: connac: introduce unified event table
      wifi: mt76: connac: add more bss info command tags
      wifi: mt76: connac: add more starec command tags
      wifi: mt76: connac: introduce helper for mt7996 chipset
      wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices

Shengyu Qu (1):
      Bluetooth: btusb: Add more device IDs for WCN6855

Shenwei Wang (4):
      net: fec: remove the unused functions
      net: fec: add initial XDP support
      net: fec: simplify the code logic of quirks
      net: fec: add xdp and page pool statistics

Shigeru Yoshida (1):
      wifi: ar5523: Fix use-after-free on ar5523_cmd() timed out

Shung-Hsi Yu (3):
      libbpf: Use elf_getshdrnum() instead of e_shnum
      libbpf: Deal with section with no data gracefully
      libbpf: Fix null-pointer dereference in find_prog_by_sec_insn()

Siddaraju DH (1):
      ice: make Tx and Rx vernier offset calibration independent

Sowmiya Sree Elavalagan (1):
      wifi: ath11k: Fix firmware crash on vdev delete race condition

Sreevani Sreejith (1):
      bpf, docs: BPF Iterator Document

Sriram Yagnaraman (1):
      netfilter: conntrack: add sctp DATA_SENT state

Stanislav Fomichev (10):
      bpf: make sure skb->len != 0 when redirecting to a tunneling device
      bpf: Move skb->len == 0 checks into __bpf_redirect
      selftests/bpf: Make sure zero-len skbs aren't redirectable
      ppp: associate skb with a device at tx
      selftests/bpf: Mount debugfs in setns_by_fd
      bpf: Prevent decl_tag from being referenced in func_proto arg
      selftests/bpf: Add reproducer for decl_tag in func_proto argument
      bpf: Unify and simplify btf_func_proto_check error handling
      net: use %pS for kfree_skb tracing event location
      selftests/bpf: Bring test_offload.py back to life

Steen Hegelund (35):
      net: microchip: sparx5: Adding initial VCAP API support
      net: microchip: sparx5: Adding IS2 VCAP model to VCAP API
      net: microchip: sparx5: Adding IS2 VCAP register interface
      net: microchip: sparx5: Adding initial tc flower support for VCAP API
      net: microchip: sparx5: Adding port keyset config and callback interface
      net: microchip: sparx5: Adding basic rule management in VCAP API
      net: microchip: sparx5: Writing rules to the IS2 VCAP
      net: microchip: sparx5: Adding KUNIT test VCAP model
      net: microchip: sparx5: Adding KUNIT test for the VCAP API
      net: microchip: sparx5: Differentiate IPv4 and IPv6 traffic in keyset config
      net: microchip: sparx5: Adding more tc flower keys for the IS2 VCAP
      net: microchip: sparx5: Find VCAP lookup from chain id
      net: microchip: sparx5: Adding TC goto action and action checking
      net: microchip: sparx5: Match keys in configured port keysets
      net: microchip: sparx5: Let VCAP API validate added key- and actionfields
      net: microchip: sparx5: Add tc matchall filter and enable VCAP lookups
      net: microchip: sparx5: Adding KUNIT tests of key/action values in VCAP API
      net: flow_offload: add support for ARP frame matching
      net: microchip: sparx5: Add support for TC flower ARP dissector
      net: microchip: sparx5: Add/delete rules in sorted order
      net: microchip: sparx5: Add support for IS2 VCAP rule counters
      net: microchip: sparx5: Add support for TC flower filter statistics
      net: microchip: sparx5: Add KUNIT test of counters and sorted rules
      net: microchip: sparx5: Ensure L3 protocol has a default value
      net: microchip: sparx5: Ensure VCAP last_used_addr is set back to default
      net: microchip: sparx5: Add VCAP debugFS support
      net: microchip: sparx5: Add raw VCAP debugFS support for the VCAP API
      net: microchip: sparx5: Add VCAP rule debugFS support for the VCAP API
      net: microchip: sparx5: Add VCAP debugFS key/action support for the VCAP API
      net: microchip: sparx5: Add VCAP locking to protect rules
      net: microchip: sparx5: Add VCAP debugfs KUNIT test
      net: microchip: sparx5: Support for copying and modifying rules in the API
      net: microchip: sparx5: Support for TC protocol all
      net: microchip: sparx5: Support for displaying a list of keysets
      net: microchip: sparx5: Add VCAP filter keys KUNIT test

Stefan Schmidt (1):
      net: mac802154: Fixup function parameter name in docs

Steffen Bätz (1):
      net: dsa: mv88e6xxx: Add RGMII delay to 88E6320

Steffen Klassert (4):
      Merge branch 'xfrm: add extack support to some more message types'
      Merge branch 'Extend XFRM core to allow packet offload configuration'
      Merge branch 'mlx5 IPsec packet offload support (Part I)'
      Merge branch 'mlx5 IPsec packet offload support (Part II)'

Sudheer Mogilappagari (1):
      ethtool: add netlink based get rss support

Sujuan Chen (6):
      net: ethernet: mtk_wed: introduce wed mcu support
      net: ethernet: mtk_wed: add wcid overwritten support for wed v1
      wifi: mt76: introduce rxwi and rx token utility routines
      wifi: mt76: add info parameter to rx_skb signature
      wifi: mt76: connac: introduce mt76_connac_mcu_sta_wed_update utility routine
      wifi: mt76: mt7915: enable WED RX stats

Suman Ghosh (3):
      octeontx2-af: Allow mkex profile without DMAC and add L2M/L2B header extraction support
      octeontx2-pf: Add additional checks while configuring ucast/bcast/mcast rules
      octeontx2-pf: Add support to filter packet based on IP fragment

Sven Peter (7):
      dt-bindings: net: Add generic Bluetooth controller
      dt-bindings: net: Add Broadcom BCM4377 family PCIe Bluetooth
      arm64: dts: apple: t8103: Add Bluetooth controller
      Bluetooth: hci_event: Ignore reserved bits in LE Extended Adv Report
      Bluetooth: Add quirk to disable extended scanning
      Bluetooth: Add quirk to disable MWS Transport Configuration
      Bluetooth: hci_bcm4377: Add new driver for BCM4377 PCIe boards

Tan Tee Min (1):
      net: phy: dp83867: add TI PHY loopback

Tao Chen (1):
      netlink: Fix potential skb memleak in netlink_ack

Taras Chornyi (1):
      MAINTAINERS: Update email address for Marvell Prestera Ethernet Switch driver

Tariq Toukan (9):
      bond: Disable TLS features indication
      net/mlx5e: Move params kernel log print to probe function
      net/mlx5e: kTLS, Remove unused work field
      net/mlx5e: kTLS, Remove unnecessary per-callback completion
      net/mlx5e: kTLS, Use a single async context object per a callback bulk
      net/mlx5e: Add padding when needed in UMR WQEs
      net/mlx5: Remove unused UMR MTT definitions
      net/mlx5: Generalize name of UMR alignment definition
      net/mlx5: Use generic definition for UMR KLM alignment

Tejun Heo (1):
      rhashtable: Allow rhashtable to be used from irq-safe contexts

Thomas Gleixner (5):
      net: Remove the obsolte u64_stats_fetch_*_irq() users (drivers).
      net: Remove the obsolte u64_stats_fetch_*_irq() users (net).
      bpf: Remove the obsolte u64_stats_fetch_*_irq() users.
      net: dpaa2: Remove linux/msi.h includes
      net: nfp: Remove linux/msi.h includes

Tiezhu Yang (3):
      bpftool: Check argc first before "file" in do_batch()
      bpf, samples: Use "grep -E" instead of "egrep"
      samples: pktgen: Use "grep -E" instead of "egrep"

Timo Hunziker (1):
      libbpf: Parse usdt args without offset on x86 (e.g. 8@(%rsp))

Tirthendu Sarkar (1):
      i40e: allow toggling loopback mode via ndo_set_features callback

Toke Høiland-Jørgensen (3):
      dev: Move received_rps counter next to RPS members in softnet data
      bpf: Expand map key argument of bpf_redirect_map to u64
      bpf: Add dummy type reference to nf_conn___init to fix type deduplication

Tom Lendacky (2):
      net: amd-xgbe: Fix logic around active and passive cables
      net: amd-xgbe: Check only the minimum speed for active/passive cables

Tom Rix (1):
      wifi: iwlwifi: mei: clean up comments

Uladzislau Koshchanka (1):
      lib: packing: replace bit_reverse() with bitrev8()

Uwe Kleine-König (12):
      net: dsa: lan9303: Convert to i2c's .probe_new()
      net: dsa: microchip: ksz9477: Convert to i2c's .probe_new()
      net: dsa: xrs700x: Convert to i2c's .probe_new()
      net/mlxsw: Convert to i2c's .probe_new()
      nfc: microread: Convert to i2c's .probe_new()
      nfc: mrvl: Convert to i2c's .probe_new()
      NFC: nxp-nci: Convert to i2c's .probe_new()
      nfc: pn533: Convert to i2c's .probe_new()
      nfc: pn544: Convert to i2c's .probe_new()
      nfc: s3fwrn5: Convert to i2c's .probe_new()
      nfc: st-nci: Convert to i2c's .probe_new()
      nfc: st21nfca: i2c: Convert to i2c's .probe_new()

Vadim Fedorenko (5):
      ptp: ocp: upgrade serial line information
      ptp: ocp: add Orolia timecard support
      ptp: ocp: add serial port of mRO50 MAC on ART card
      ptp: ocp: expose config and temperature for ART card
      ptp: ocp: remove flash image header check fallback

Veerasenareddy Burru (1):
      octeon_ep: support Octeon device CNF95N

Victor Nogueira (1):
      selftests: tc-testing: Add matchJSON to tdc

Vikas Gupta (2):
      bnxt_en: add .get_module_eeprom_by_page() support
      bnxt_en: check and resize NVRAM UPDATE entry before flashing

Vinayak Yadawad (1):
      cfg80211: Update Transition Disable policy during port authorization

Vincent Mailhol (15):
      ethtool: ethtool_get_drvinfo: populate drvinfo fields even if callback exits
      ethtool: doc: clarify what drivers can implement in their get_drvinfo()
      net: devlink: let the core report the driver name instead of the drivers
      net: devlink: make the devlink_ops::info_get() callback optional
      net: devlink: clean-up empty devlink_ops::info_get()
      can: etas_es58x: sort the includes by alphabetic order
      can: etas_es58x: add devlink support
      can: etas_es58x: add devlink port support
      USB: core: export usb_cache_string()
      net: devlink: add DEVLINK_INFO_VERSION_GENERIC_FW_BOOTLOADER
      can: etas_es58x: export product information through devlink_ops::info_get()
      can: etas_es58x: remove es58x_get_product_info()
      Documentation: devlink: add devlink documentation for the etas_es58x driver
      can: ucan: remove unused ucan_priv::intf
      can: gs_usb: remove gs_can::iface

Vishwanath Pai (1):
      netfilter: ipset: Add support for new bitmask parameter

Vivek Yadav (3):
      can: m_can: m_can_handle_bus_errors(): add support for handling DLEC error on CAN-FD frames
      can: m_can: sort header inclusion alphabetically
      can: m_can: Call the RAM init directly from m_can_chip_config

Vladimir Oltean (48):
      net: ftmac100: prepare data path for receiving single segment packets > 1514
      net: ftmac100: report the correct maximum MTU of 1500
      net: phy: aquantia: add AQR112 and AQR412 PHY IDs
      net: dsa: felix: use phylink_generic_validate()
      net: mscc: ocelot: drop workaround for forcing RX flow control
      net: dsa: remove phylink_validate() method
      net: linkwatch: only report IF_OPER_LOWERLAYERDOWN if iflink is actually down
      net: dsa: stop exposing tag proto module helpers to the world
      net: dsa: rename tagging protocol driver modalias
      net: dsa: provide a second modalias to tag proto drivers based on their name
      net: dsa: strip sysfs "tagging" string of trailing newline
      net: dsa: rename dsa_tag_driver_get() to dsa_tag_driver_get_by_id()
      net: dsa: autoload tag driver module on tagging protocol change
      net: dsa: unexport dsa_dev_to_net_device()
      net: dsa: modularize DSA_TAG_PROTO_NONE
      net: dsa: move bulk of devlink code to devlink.{c,h}
      net: dsa: if ds->setup is true, ds->devlink is always non-NULL
      net: dsa: move rest of devlink setup/teardown to devlink.c
      net: dsa: move headers exported by port.c to port.h
      net: dsa: move headers exported by master.c to master.h
      net: dsa: move headers exported by slave.c to slave.h
      net: dsa: move tagging protocol code to tag.{c,h}
      net: dsa: move headers exported by switch.c to switch.h
      net: dsa: move dsa_tree_notify() and dsa_broadcast() to switch.c
      net: dsa: move notifier definitions to switch.h
      net: dsa: merge dsa.c into dsa2.c
      net: dsa: rename dsa2.c back into dsa.c and create its header
      net: dsa: move definitions from dsa_priv.h to slave.c
      net: dsa: move tag_8021q headers to their proper place
      net: dsa: kill off dsa_priv.h
      Revert "net: stmmac: use sysfs_streq() instead of strncmp()"
      net: dpaa2-eth: don't use -ENOTSUPP error code
      net: dpaa2: replace dpaa2_mac_is_type_fixed() with dpaa2_mac_is_type_phy()
      net: dpaa2-mac: absorb phylink_start() call into dpaa2_mac_start()
      net: dpaa2-mac: remove defensive check in dpaa2_mac_disconnect()
      net: dpaa2-eth: assign priv->mac after dpaa2_mac_connect() call
      net: dpaa2-switch: assign port_priv->mac after dpaa2_mac_connect() call
      net: dpaa2: publish MAC stringset to ethtool -S even if MAC is missing
      net: dpaa2-switch replace direct MAC access with dpaa2_switch_port_has_mac()
      net: dpaa2-eth: connect to MAC before requesting the "endpoint changed" IRQ
      net: dpaa2-eth: serialize changes to priv->mac with a mutex
      net: dpaa2-switch: serialize changes to priv->mac with a mutex
      net: dpaa2-mac: move rtnl_lock() only around phylink_{,dis}connect_phy()
      net: dsa: mv88e6xxx: remove ATU age out violation print
      net: dsa: mv88e6xxx: replace ATU violation prints with trace points
      net: dsa: mv88e6xxx: replace VTU violation prints with trace points
      net: dsa: don't call ptp_classify_raw() if switch doesn't provide RX timestamping
      net: dsa: tag_8021q: avoid leaking ctx on dsa_tag_8021q_register() error path

Walter Heymans (1):
      Documentation: nfp: update documentation

Wang ShaoBo (1):
      Bluetooth: btintel: Fix missing free skb in btintel_setup_combined()

Wang Yufen (6):
      selftests/bpf: fix missing BPF object files
      bpftool: Add autoattach for bpf prog load|loadall
      bpftool: Update doc (add autoattach to prog load)
      bpftool: Update the bash completion(add autoattach to prog load)
      selftests/bpf: fix memory leak of lsm_cgroup
      wifi: brcmfmac: Fix error return code in brcmf_sdio_download_firmware()

Wataru Gohda (1):
      wifi: brcmfmac: Fix for when connect request is not success

Wei Fang (1):
      net: fec: Add support for periodic output signal of PPS

Wei Yongjun (1):
      mptcp: netlink: fix some error return code

Wen Gong (2):
      wifi: ath11k: fix warning in dma_free_coherent() of memory chunks while recovery
      wifi: ath11k: avoid deadlock during regulatory update in ath11k_regd_update()

Willem de Bruijn (3):
      net/packet: add PACKET_FANOUT_FLAG_IGNORE_OUTGOING
      selftests/net: add csum offload test
      net_tstamp: add SOF_TIMESTAMPING_OPT_ID_TCP

Wright Feng (7):
      brcmfmac: Add dump_survey cfg80211 ops for HostApd AutoChannelSelection
      brcmfmac: fix firmware trap while dumping obss stats
      brcmfmac: add a timer to read console periodically in PCIE bus
      brcmfmac: return error when getting invalid max_flowrings from dongle
      brcmfmac: dump dongle memory when attaching failed
      brcmfmac: add creating station interface support
      brcmfmac: support station interface creation version 1, 2 and 3

Xiaolei Wang (1):
      net: phy: Add link between phy dev and mac dev

Xin Liu (1):
      libbpf: Improve usability of libbpf Makefile

Xin Long (22):
      net: move the ct helper function to nf_conntrack_helper for ovs and tc
      net: move add ct helper function to nf_conntrack_helper for ovs and tc
      net: sched: call tcf_ct_params_free to free params in tcf_ct_init
      net: sched: add helper support in act_ct
      sctp: change to include linux/sctp.h in net/sctp/checksum.h
      sctp: move SCTP_PAD4 and SCTP_TRUNC4 to linux/sctp.h
      sctp: verify the bind address with the tb_id from l3mdev
      sctp: check ipv6 addr with sk_bound_dev if set
      sctp: check sk_bound_dev_if when matching ep in get_port
      sctp: add skb_sdif in struct sctp_af
      sctp: add dif and sdif check in asoc and ep lookup
      sctp: add sysctl net.sctp.l3mdev_accept
      selftests: add a selftest for sctp vrf
      sctp: delete free member from struct sctp_sched_ops
      openvswitch: delete the unncessary skb_pull_rcsum call in ovs_ct_nat_execute
      openvswitch: return NF_ACCEPT when OVS_CT_NAT is not set in info nat
      openvswitch: return NF_DROP when fails to add nat ext in ovs_ct_nat
      net: sched: update the nat flag for icmp error packets in ct_nat_execute
      net: move the nat function to nf_nat_ovs for ovs and tc
      net: add IFF_NO_ADDRCONF and use it in bonding to prevent ipv6 addrconf
      net: team: use IFF_NO_ADDRCONF flag to prevent ipv6 addrconf
      net: failover: use IFF_NO_ADDRCONF flag to prevent ipv6 addrconf

Xiongfeng Wang (1):
      mt76: mt7915: Fix PCI device refcount leak in mt7915_pci_init_hif2()

Xiu Jianfeng (1):
      wifi: ath10k: Fix return value in ath10k_pci_init()

Xu Kuohai (8):
      libbpf: Fix use-after-free in btf_dump_name_dups
      libbpf: Fix memory leak in parse_usdt_arg()
      selftests/bpf: Fix memory leak caused by not destroying skeleton
      selftest/bpf: Fix memory leak in kprobe_multi_test
      selftests/bpf: Fix error failure of case test_xdp_adjust_tail_grow
      selftest/bpf: Fix error usage of ASSERT_OK in xdp_adjust_tail.c
      libbpf: Avoid allocating reg_name with sscanf in parse_usdt_arg()
      bpf: Fix a typo in comment for DFS algorithm

Xu Panda (6):
      net: stmmac: use sysfs_streq() instead of strncmp()
      hns: use strscpy() to instead of strncpy()
      liquidio: use strscpy() to instead of strncpy()
      myri10ge: use strscpy() to instead of strncpy()
      can: ucan: use strscpy() to instead of strncpy()
      net: hns3: use strscpy() to instead of strncpy()

YN Chen (1):
      wifi: mt76: mt7921: fix wrong power after multiple SAR set

Yang Jihong (2):
      selftests/bpf: Fix xdp_synproxy compilation failure in 32-bit arch
      bpf: Fix comment error in fixup_kfunc_call function

Yang Li (3):
      net: dpaa2-eth: Simplify bool conversion
      ixgbe: Remove unneeded semicolon
      lib: Fix some kernel-doc comments

Yang Yingliang (21):
      net: ieee802154: mcr20a: Switch to use dev_err_probe() helper
      net: hns: hnae: remove unnecessary __module_get() and module_put()
      net: microchip: sparx5: kunit test: change test_callbacks and test_vctrl to static
      gve: Fix error return code in gve_prefill_rx_pages()
      ethernet: s2io: don't call dev_kfree_skb() under spin_lock_irqsave()
      net: apple: mace: don't call dev_kfree_skb() under spin_lock_irqsave()
      net: apple: bmac: don't call dev_kfree_skb() under spin_lock_irqsave()
      net: emaclite: don't call dev_kfree_skb() under spin_lock_irqsave()
      net: ethernet: dnet: don't call dev_kfree_skb() under spin_lock_irqsave()
      hamradio: don't call dev_kfree_skb() under spin_lock_irqsave()
      net: amd: lance: don't call dev_kfree_skb() under spin_lock_irqsave()
      af_unix: call proto_unregister() in the error path in af_unix_init()
      Bluetooth: hci_core: fix error handling in hci_register_dev()
      Bluetooth: hci_bcm4377: Fix missing pci_disable_device() on error in bcm4377_probe()
      Bluetooth: btusb: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: hci_qca: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: hci_ll: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: hci_h5: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: hci_bcsp: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: hci_core: don't call kfree_skb() under spin_lock_irqsave()
      Bluetooth: RFCOMM: don't call kfree_skb() under spin_lock_irqsave()

Yanguo Li (1):
      nfp: flower: tunnel neigh support bond offload

Ye Bin (1):
      net: af_can: remove useless parameter 'err' in 'can_rx_register()'

Yevgeny Kliteynik (23):
      net/mlx5: DR, In destroy flow, free resources even if FW command failed
      net/mlx5: DR, Fix the SMFS sync_steering for fast teardown
      net/mlx5: DR, Check device state when polling CQ
      net/mlx5: DR, Remove unneeded argument from dr_icm_chunk_destroy
      net/mlx5: DR, For short chains of STEs, avoid allocating ste_arr dynamically
      net/mlx5: DR, Initialize chunk's ste_arrays at chunk creation
      net/mlx5: DR, Handle domain memory resources init/uninit separately
      net/mlx5: DR, In rehash write the line in the entry immediately
      net/mlx5: DR, Manage STE send info objects in pool
      net/mlx5: DR, Allocate icm_chunks from their own slab allocator
      net/mlx5: DR, Allocate htbl from its own slab allocator
      net/mlx5: DR, Lower sync threshold for ICM hot memory
      net/mlx5: DR, Keep track of hot ICM chunks in an array instead of list
      net/mlx5: DR, Remove the buddy used_list
      net/mlx5: mlx5_ifc updates for MATCH_DEFINER general object
      net/mlx5: fs, add match on ranges API
      net/mlx5: DR, Add functions to create/destroy MATCH_DEFINER general object
      net/mlx5: DR, Rework is_fw_table function
      net/mlx5: DR, Handle FT action in a separate function
      net/mlx5: DR, Manage definers with refcounts
      net/mlx5: DR, Some refactoring of miss address handling
      net/mlx5: DR, Add function that tells if STE miss addr has been initialized
      net/mlx5: DR, Add support for range match action

Yinjun Zhang (2):
      nfp: take numa node into account when setting irq affinity
      nfp: extend capability and control words

Yishai Hadas (2):
      net/mlx5: Introduce IFC bits for migratable
      net/mlx5: E-Switch, Implement devlink port function cmds to control RoCE

Yonghong Song (27):
      selftests/bpf: Add selftest deny_namespace to s390x deny list
      bpf: Make struct cgroup btf id global
      bpf: Refactor some inode/task/sk storage functions for reuse
      bpf: Implement cgroup storage available to non-cgroup-attached bpf progs
      libbpf: Support new cgroup local storage
      bpftool: Support new cgroup local storage
      selftests/bpf: Fix test test_libbpf_str/bpf_map_type_str
      selftests/bpf: Add selftests for new cgroup local storage
      selftests/bpf: Add test cgrp_local_storage to DENYLIST.s390x
      docs/bpf: Add documentation for new cgroup local storage
      selftests/bpf: Fix bpftool synctypes checking failure
      bpf: Add support for kfunc set with common btf_ids
      bpf: Add a kfunc to type cast from bpf uapi ctx to kernel ctx
      bpf: Add a kfunc for generic type cast
      bpf: Add type cast unit tests
      bpf: Fix a BTF_ID_LIST bug with CONFIG_DEBUG_INFO_BTF not set
      compiler_types: Define __rcu as __attribute__((btf_type_tag("rcu")))
      bpf: Introduce might_sleep field in bpf_func_proto
      bpf: Add kfunc bpf_rcu_read_lock/unlock()
      selftests/bpf: Add tests for bpf_rcu_read_lock()
      bpf: Fix a compilation failure with clang lto build
      bpf: Handle MEM_RCU type properly
      selftests/bpf: Fix rcu_read_lock test with new MEM_RCU semantics
      docs/bpf: Add KF_RCU documentation
      bpf: Do not mark certain LSM hook arguments as trusted
      bpf: Enable sleeptable support for cgrp local storage
      bpf: Add sleepable prog tests for cgrp local storage

Yongqiang Liu (1):
      net: defxx: Fix missing err handling in dfx_init()

Yoshihiro Shimoda (6):
      dt-bindings: net: renesas: Document Renesas Ethernet Switch
      net: ethernet: renesas: Add support for "Ethernet Switch"
      net: ethernet: renesas: rswitch: Add R-Car Gen4 gPTP support
      net: ethernet: renesas: rswitch: Fix endless loop in error paths
      net: ethernet: renesas: rswitch: Fix build error about ptp
      net: ethernet: renesas: rswitch: Fix MAC address info

Youghandhar Chintala (3):
      wifi: ath10k: Delay the unmapping of the buffer
      wifi: ath11k: Trigger sta disconnect on hardware restart
      wifi: ath10k: Store WLAN firmware version in SMEM image table

Yu Xiao (1):
      nfp: ethtool: support reporting link modes

Yuan Can (4):
      udp_tunnel: Add checks for nla_nest_start() in __udp_tunnel_nic_dump_write()
      wifi: nl80211: Add checks for nla_nest_start() in nl80211_send_iface()
      net: ethernet: mtk_wed: Fix missing of_node_put() in mtk_wed_wo_hardware_init()
      drivers: net: qlcnic: Fix potential memory leak in qlcnic_sriov_init()

YueHaibing (2):
      net: txgbe: Fix memleak in txgbe_calc_eeprom_checksum()
      net: txgbe: Fix unsigned comparison to zero in txgbe_calc_eeprom_checksum()

Yunsheng Lin (2):
      net: skb: move skb_pp_recycle() to skbuff.c
      net: tso: inline tso_count_descs()

Zhang Changzhong (2):
      can: j1939: j1939_session_tx_eoma(): fix debug info
      net: stmmac: selftests: fix potential memleak in stmmac_test_arpoffload()

Zheng Yejian (1):
      bpf, docs: Correct the example of BPF_XOR

Zhengchao Shao (2):
      net: remove redundant check in ip_metrics_convert()
      wifi: mac80211: fix memory leak in ieee80211_if_add()

Zhengping Jiang (1):
      Bluetooth: hci_qca: only assign wakeup with serial port support

Zhi-Jun You (2):
      wifi: ath10k: Use IEEE80211_SEQ_TO_SN() for seq_ctrl conversion
      wifi: ath10k: Remove redundant argument offset

Ziyang Xuan (1):
      wifi: plfxlc: fix potential memory leak in __lf_x_usb_enable_rx()

Zong-Zhe Yang (14):
      wifi: rtw89: phy: make generic txpwr setting functions
      wifi: rtw89: debug: txpwr_table considers sign
      wifi: rtw89: declare support bands with const
      wifi: rtw89: check if sta's mac_id is valid under AP/TDLS
      wifi: rtw89: fix physts IE page check
      wifi: rtw89: enable mac80211 virtual monitor interface
      wifi: rtw89: rfk: rename rtw89_mcc_info to rtw89_rfk_mcc_info
      wifi: rtw89: check if atomic before queuing c2h
      wifi: rtw89: introduce helpers to wait/complete on condition
      wifi: rtw89: mac: process MCC related C2H
      wifi: rtw89: fw: implement MCC related H2C
      wifi: rtw89: link rtw89_vif and chanctx stuffs
      wifi: rtw89: don't request partial firmware if SECURITY_LOADPIN_ENFORCE
      wifi: rtw89: request full firmware only once if it's early requested

caihuoqing (1):
      net: hinic: Set max_mtu/min_mtu directly to simplify the code.

wangchuanlei (1):
      net: openvswitch: Add support to count upcall packets

xu xin (2):
      net: remove useless parameter of __sock_cmsg_send
      ipasdv4/tcp_ipv4: remove redundant assignment

ye xingchen (4):
      iavf: Replace __FUNCTION__ with __func__
      net: ipa: use sysfs_emit() to instead of scnprintf()
      sfc: use sysfs_emit() to instead of scnprintf()
      net: ethernet: use sysfs_emit() to instead of scnprintf()

zhang songyi (1):
      net: microchip: vcap: Remove unneeded semicolons

Íñigo Huguet (1):
      wifi: mac80211: fix maybe-unused warning

 Documentation/bpf/bpf_design_QA.rst                |    45 +
 Documentation/bpf/bpf_devel_QA.rst                 |    27 +
 Documentation/bpf/bpf_iterators.rst                |   485 +
 Documentation/bpf/btf.rst                          |     7 +-
 Documentation/bpf/index.rst                        |     2 +
 Documentation/bpf/instruction-set.rst              |     4 +-
 Documentation/bpf/kfuncs.rst                       |   255 +-
 Documentation/bpf/libbpf/index.rst                 |     3 +
 Documentation/bpf/libbpf/program_types.rst         |   203 +
 Documentation/bpf/map_array.rst                    |   262 +
 Documentation/bpf/map_bloom_filter.rst             |   174 +
 Documentation/bpf/map_cgrp_storage.rst             |   109 +
 Documentation/bpf/map_cpumap.rst                   |   177 +
 Documentation/bpf/map_devmap.rst                   |   238 +
 Documentation/bpf/map_hash.rst                     |    33 +-
 Documentation/bpf/map_lpm_trie.rst                 |   197 +
 Documentation/bpf/map_of_maps.rst                  |   130 +
 Documentation/bpf/map_queue_stack.rst              |   146 +
 Documentation/bpf/map_sk_storage.rst               |   155 +
 Documentation/bpf/map_xskmap.rst                   |   192 +
 Documentation/bpf/maps.rst                         |   101 +-
 Documentation/bpf/programs.rst                     |     3 +
 Documentation/bpf/redirect.rst                     |    81 +
 .../bindings/arm/mediatek/mediatek,mt7622-wed.yaml |    52 +
 .../bindings/interrupt-controller/fsl,intmux.yaml  |     3 +-
 .../devicetree/bindings/net/adi,adin1110.yaml      |     4 +
 .../devicetree/bindings/net/asix,ax88178.yaml      |     4 +-
 .../devicetree/bindings/net/bluetooth.txt          |     5 -
 .../net/bluetooth/bluetooth-controller.yaml        |    29 +
 .../net/bluetooth/brcm,bcm4377-bluetooth.yaml      |    81 +
 .../net/{ => bluetooth}/qualcomm-bluetooth.yaml    |     6 +-
 .../bindings/net/broadcom-bluetooth.yaml           |     3 +
 .../devicetree/bindings/net/can/fsl,flexcan.yaml   |     1 +
 .../bindings/net/can/renesas,rcar-canfd.yaml       |   135 +-
 .../devicetree/bindings/net/dsa/dsa-port.yaml      |     3 +-
 .../bindings/net/dsa/hirschmann,hellcreek.yaml     |     2 +-
 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml       |     2 +-
 .../bindings/net/ethernet-controller.yaml          |    11 +-
 Documentation/devicetree/bindings/net/fsl,fec.yaml |     4 +-
 .../devicetree/bindings/net/fsl,fman-dtsec.yaml    |    53 +-
 .../bindings/net/fsl,qoriq-mc-dpmac.yaml           |     2 +-
 Documentation/devicetree/bindings/net/fsl-fman.txt |     5 +-
 .../bindings/net/marvell,dfx-server.yaml           |    62 +
 .../devicetree/bindings/net/marvell,pp2.yaml       |   305 +
 .../devicetree/bindings/net/marvell,prestera.txt   |    81 -
 .../devicetree/bindings/net/marvell,prestera.yaml  |    91 +
 .../devicetree/bindings/net/marvell-pp2.txt        |   141 -
 .../devicetree/bindings/net/microchip,lan95xx.yaml |     4 +-
 .../devicetree/bindings/net/nfc/nxp,nci.yaml       |     4 +-
 .../devicetree/bindings/net/nxp,dwmac-imx.yaml     |     4 +-
 .../devicetree/bindings/net/pcs/fsl,lynx-pcs.yaml  |    40 +
 .../devicetree/bindings/net/qca,ar71xx.yaml        |     1 -
 .../devicetree/bindings/net/qcom,ipa.yaml          |    86 +-
 .../devicetree/bindings/net/qcom,ipq4019-mdio.yaml |    46 +-
 .../devicetree/bindings/net/realtek-bluetooth.yaml |     1 +
 .../net/renesas,r8a779f0-ether-switch.yaml         |   262 +
 Documentation/devicetree/bindings/net/sff,sfp.yaml |     3 +-
 .../devicetree/bindings/net/snps,dwmac.yaml        |   345 +-
 .../bindings/net/socionext,synquacer-netsec.yaml   |    73 +
 .../devicetree/bindings/net/socionext-netsec.txt   |    56 -
 .../devicetree/bindings/net/xilinx_axienet.txt     |     2 +
 .../soc/mediatek/mediatek,mt7986-wo-ccif.yaml      |    51 +
 .../devicetree/bindings/soc/qcom/qcom,wcnss.yaml   |     8 +-
 Documentation/networking/bonding.rst               |     4 +-
 Documentation/networking/can.rst                   |    33 +
 .../ethernet/freescale/dpaa2/mac-phy-support.rst   |     9 +-
 .../device_drivers/ethernet/marvell/octeon_ep.rst  |     1 +
 .../device_drivers/ethernet/mellanox/mlx5.rst      |   124 +-
 .../device_drivers/ethernet/netronome/nfp.rst      |   165 +-
 Documentation/networking/devlink/devlink-info.rst  |     5 +
 Documentation/networking/devlink/devlink-port.rst  |   168 +-
 .../networking/devlink/devlink-region.rst          |    13 +
 Documentation/networking/devlink/devlink-trap.rst  |    13 +
 Documentation/networking/devlink/etas_es58x.rst    |    36 +
 Documentation/networking/devlink/ice.rst           |   128 +-
 Documentation/networking/ethtool-netlink.rst       |    32 +-
 Documentation/networking/index.rst                 |     1 +
 Documentation/networking/ip-sysctl.rst             |   111 +
 Documentation/networking/ipvs-sysctl.rst           |    24 +-
 Documentation/networking/tc-queue-filters.rst      |    37 +
 Documentation/networking/timestamping.rst          |    32 +-
 Documentation/networking/xfrm_device.rst           |    62 +-
 MAINTAINERS                                        |    23 +-
 arch/arm/boot/dts/armada-375.dtsi                  |    12 +-
 arch/arm/mach-omap2/pdata-quirks.c                 |     1 -
 arch/arm64/boot/dts/apple/t8103-j274.dts           |     4 +
 arch/arm64/boot/dts/apple/t8103-j293.dts           |     4 +
 arch/arm64/boot/dts/apple/t8103-j313.dts           |     4 +
 arch/arm64/boot/dts/apple/t8103-j456.dts           |     4 +
 arch/arm64/boot/dts/apple/t8103-j457.dts           |     4 +
 arch/arm64/boot/dts/apple/t8103-jxxx.dtsi          |     8 +
 arch/arm64/boot/dts/freescale/fsl-ls1043-post.dtsi |    24 +
 arch/arm64/boot/dts/freescale/fsl-ls1046-post.dtsi |    25 +
 arch/arm64/boot/dts/marvell/armada-cp11x.dtsi      |    17 +-
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi          |    65 +
 arch/arm64/net/bpf_jit_comp.c                      |     9 +-
 arch/mips/configs/mtx1_defconfig                   |     1 -
 .../dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi   |     3 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi |    10 +-
 .../dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi   |    10 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi |    10 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi |    45 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi |    45 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi  |     3 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi  |    10 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi  |    10 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi  |    10 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi  |     3 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi  |    10 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi |    10 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi |    10 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi  |     3 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi  |    10 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi  |    10 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi  |    10 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi  |     3 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi  |    10 +-
 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi        |     4 +-
 arch/powerpc/configs/ppc6xx_defconfig              |     1 -
 arch/riscv/net/bpf_jit_comp64.c                    |    29 +-
 arch/sparc/net/bpf_jit_comp_32.c                   |    10 +-
 arch/x86/net/bpf_jit_comp.c                        |   128 +-
 drivers/bcma/driver_gpio.c                         |     8 +-
 drivers/bcma/main.c                                |     4 +-
 drivers/bcma/sprom.c                               |     2 +-
 drivers/bluetooth/Kconfig                          |    23 +
 drivers/bluetooth/Makefile                         |     1 +
 drivers/bluetooth/btintel.c                        |    21 +-
 drivers/bluetooth/btrtl.c                          |     7 +
 drivers/bluetooth/btrtl.h                          |    21 +
 drivers/bluetooth/btusb.c                          |   236 +-
 drivers/bluetooth/hci_bcm.c                        |    13 +-
 drivers/bluetooth/hci_bcm4377.c                    |  2514 ++
 drivers/bluetooth/hci_bcsp.c                       |     2 +-
 drivers/bluetooth/hci_h5.c                         |     2 +-
 drivers/bluetooth/hci_ll.c                         |     2 +-
 drivers/bluetooth/hci_qca.c                        |     5 +-
 drivers/bluetooth/virtio_bt.c                      |    35 +-
 .../crypto/marvell/octeontx2/otx2_cpt_devlink.c    |     4 -
 drivers/hv/hv_util.c                               |     4 +-
 drivers/i2c/i2c-core-base.c                        |    14 +
 drivers/infiniband/hw/mlx5/odp.c                   |     3 +-
 drivers/infiniband/hw/mlx5/umr.c                   |    14 +-
 drivers/net/bonding/bond_3ad.c                     |     9 +
 drivers/net/bonding/bond_main.c                    |    44 +-
 drivers/net/bonding/bond_options.c                 |    18 -
 drivers/net/can/Kconfig                            |     8 -
 drivers/net/can/Makefile                           |     1 -
 drivers/net/can/c_can/Kconfig                      |     3 +-
 drivers/net/can/c_can/c_can_platform.c             |     3 +-
 drivers/net/can/ctucanfd/Kconfig                   |     2 +-
 drivers/net/can/flexcan/flexcan-core.c             |    37 +-
 drivers/net/can/flexcan/flexcan.h                  |     2 +
 drivers/net/can/m_can/m_can.c                      |   156 +-
 drivers/net/can/m_can/m_can.h                      |    18 +-
 drivers/net/can/m_can/m_can_platform.c             |     6 +-
 drivers/net/can/m_can/tcan4x5x-core.c              |    18 +-
 drivers/net/can/m_can/tcan4x5x-regmap.c            |    47 +-
 drivers/net/can/pch_can.c                          |  1249 -
 drivers/net/can/rcar/rcar_canfd.c                  |   109 +-
 drivers/net/can/usb/Kconfig                        |    10 +-
 drivers/net/can/usb/etas_es58x/Makefile            |     2 +-
 drivers/net/can/usb/etas_es58x/es581_4.c           |     4 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c        |   104 +-
 drivers/net/can/usb/etas_es58x/es58x_core.h        |    58 +-
 drivers/net/can/usb/etas_es58x/es58x_devlink.c     |   235 +
 drivers/net/can/usb/etas_es58x/es58x_fd.c          |     4 +-
 drivers/net/can/usb/gs_usb.c                       |    99 +-
 drivers/net/can/usb/kvaser_usb/Makefile            |     5 -
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h        |    30 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   113 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |   160 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |   464 +-
 drivers/net/can/usb/ucan.c                         |    12 +-
 drivers/net/can/vxcan.c                            |     2 +-
 drivers/net/dsa/Kconfig                            |     2 +
 drivers/net/dsa/b53/Kconfig                        |     1 +
 drivers/net/dsa/hirschmann/hellcreek.c             |     5 -
 drivers/net/dsa/lan9303-core.c                     |     4 +-
 drivers/net/dsa/lan9303_i2c.c                      |     5 +-
 drivers/net/dsa/microchip/Kconfig                  |     1 +
 drivers/net/dsa/microchip/ksz8.h                   |     1 +
 drivers/net/dsa/microchip/ksz8795.c                |    75 +-
 drivers/net/dsa/microchip/ksz8795_reg.h            |     3 +
 drivers/net/dsa/microchip/ksz8863_smi.c            |     9 +-
 drivers/net/dsa/microchip/ksz9477.c                |    24 +-
 drivers/net/dsa/microchip/ksz9477.h                |     1 -
 drivers/net/dsa/microchip/ksz9477_i2c.c            |    17 +-
 drivers/net/dsa/microchip/ksz9477_reg.h            |     2 -
 drivers/net/dsa/microchip/ksz_common.c             |   150 +-
 drivers/net/dsa/microchip/ksz_common.h             |    17 +-
 drivers/net/dsa/microchip/ksz_spi.c                |    10 +-
 drivers/net/dsa/microchip/lan937x_main.c           |     6 +-
 drivers/net/dsa/mv88e6xxx/Makefile                 |     4 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |     4 +
 drivers/net/dsa/mv88e6xxx/devlink.c                |     5 -
 drivers/net/dsa/mv88e6xxx/global1_atu.c            |    85 +-
 drivers/net/dsa/mv88e6xxx/global1_vtu.c            |     7 +-
 drivers/net/dsa/mv88e6xxx/port.c                   |     9 +
 drivers/net/dsa/mv88e6xxx/port.h                   |     2 +
 drivers/net/dsa/mv88e6xxx/trace.c                  |     6 +
 drivers/net/dsa/mv88e6xxx/trace.h                  |    96 +
 drivers/net/dsa/ocelot/felix.c                     |    17 +-
 drivers/net/dsa/ocelot/felix.h                     |     4 -
 drivers/net/dsa/ocelot/felix_vsc9959.c             |    35 -
 drivers/net/dsa/ocelot/seville_vsc9953.c           |    32 -
 drivers/net/dsa/sja1105/sja1105_devlink.c          |    12 +-
 drivers/net/dsa/xrs700x/xrs700x_i2c.c              |     5 +-
 drivers/net/dummy.c                                |     7 -
 drivers/net/ethernet/Kconfig                       |    10 -
 drivers/net/ethernet/Makefile                      |     1 -
 drivers/net/ethernet/adi/adin1110.c                |    58 +-
 drivers/net/ethernet/alacritech/slic.h             |    12 +-
 drivers/net/ethernet/altera/altera_tse_main.c      |     1 -
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |     4 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |    12 +-
 drivers/net/ethernet/amd/atarilance.c              |     2 +-
 drivers/net/ethernet/amd/lance.c                   |     2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |    23 +-
 drivers/net/ethernet/amd/xgbe/xgbe-ptp.c           |    20 +-
 drivers/net/ethernet/apple/bmac.c                  |     2 +-
 drivers/net/ethernet/apple/mace.c                  |     2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c   |     8 +-
 drivers/net/ethernet/asix/ax88796c_main.c          |     4 +-
 drivers/net/ethernet/atheros/ag71xx.c              |     1 -
 drivers/net/ethernet/broadcom/b44.c                |     8 +-
 drivers/net/ethernet/broadcom/bcm4908_enet.c       |    57 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |    23 +-
 drivers/net/ethernet/broadcom/bcmsysport.h         |    11 +
 drivers/net/ethernet/broadcom/bnx2.c               |     7 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |     9 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   112 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |     3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |     4 -
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   134 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h      |   281 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |    39 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h      |     7 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |    49 +-
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |    19 +-
 drivers/net/ethernet/broadcom/tg3.c                |    22 +-
 drivers/net/ethernet/brocade/bna/bfa_cs.h          |    60 +-
 drivers/net/ethernet/brocade/bna/bfa_ioc.c         |    10 +-
 drivers/net/ethernet/brocade/bna/bfa_ioc.h         |     8 +-
 drivers/net/ethernet/brocade/bna/bfa_msgq.c        |     2 -
 drivers/net/ethernet/brocade/bna/bfa_msgq.h        |     8 +-
 drivers/net/ethernet/brocade/bna/bna_enet.c        |     6 +-
 drivers/net/ethernet/brocade/bna/bna_tx_rx.c       |     6 +-
 drivers/net/ethernet/brocade/bna/bna_types.h       |    27 +-
 drivers/net/ethernet/cadence/macb_main.c           |    17 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |    11 +-
 .../net/ethernet/cavium/liquidio/octeon_console.c  |     7 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c     |    13 +-
 .../chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c    |     4 +
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c      |    26 +-
 drivers/net/ethernet/cisco/enic/enic.h             |    23 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |    11 +-
 drivers/net/ethernet/cortina/gemini.c              |    24 +-
 drivers/net/ethernet/dlink/dl2k.c                  |     2 -
 drivers/net/ethernet/dlink/sundance.c              |     2 -
 drivers/net/ethernet/dnet.c                        |     4 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c     |    12 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |    16 +-
 drivers/net/ethernet/engleder/tsnep.h              |     8 +
 drivers/net/ethernet/engleder/tsnep_ethtool.c      |   165 +-
 drivers/net/ethernet/engleder/tsnep_hw.h           |     7 +
 drivers/net/ethernet/engleder/tsnep_main.c         |   245 +-
 drivers/net/ethernet/faraday/ftmac100.c            |    65 +-
 drivers/net/ethernet/fealnx.c                      |  1953 --
 drivers/net/ethernet/freescale/Kconfig             |     1 +
 drivers/net/ethernet/freescale/dpaa/Kconfig        |     4 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |    89 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c |    90 +-
 drivers/net/ethernet/freescale/dpaa2/Makefile      |     2 +-
 .../ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c   |    57 +-
 .../ethernet/freescale/dpaa2/dpaa2-eth-devlink.c   |    22 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth-trace.h |   142 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   609 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h   |   112 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |   128 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c   |    22 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h   |    10 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c   |     1 -
 .../freescale/dpaa2/dpaa2-switch-ethtool.c         |    45 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |    60 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.h    |     9 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c   |   454 +
 drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h    |    19 +-
 drivers/net/ethernet/freescale/dpaa2/dpni.c        |     6 +-
 drivers/net/ethernet/freescale/dpaa2/dpni.h        |     9 +
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |     1 -
 drivers/net/ethernet/freescale/fec.h               |    20 +-
 drivers/net/ethernet/freescale/fec_main.c          |   397 +-
 drivers/net/ethernet/freescale/fec_ptp.c           |   177 +-
 drivers/net/ethernet/freescale/fman/Kconfig        |     3 +-
 drivers/net/ethernet/freescale/fman/fman_dtsec.c   |   457 +-
 drivers/net/ethernet/freescale/fman/fman_mac.h     |    10 -
 drivers/net/ethernet/freescale/fman/fman_memac.c   |   744 +-
 drivers/net/ethernet/freescale/fman/fman_tgec.c    |   130 +-
 drivers/net/ethernet/freescale/fman/mac.c          |   168 +-
 drivers/net/ethernet/freescale/fman/mac.h          |    23 +-
 .../net/ethernet/fungible/funeth/funeth_devlink.c  |     7 -
 drivers/net/ethernet/fungible/funeth/funeth_main.c |    13 +-
 drivers/net/ethernet/fungible/funeth/funeth_txrx.h |     4 +-
 drivers/net/ethernet/google/gve/gve.h              |    27 +-
 drivers/net/ethernet/google/gve/gve_adminq.c       |    21 +-
 drivers/net/ethernet/google/gve/gve_adminq.h       |    51 +
 drivers/net/ethernet/google/gve/gve_desc_dqo.h     |     5 +
 drivers/net/ethernet/google/gve/gve_ethtool.c      |    18 +-
 drivers/net/ethernet/google/gve/gve_main.c         |    64 +-
 drivers/net/ethernet/google/gve/gve_rx.c           |   544 +-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c       |     2 +-
 drivers/net/ethernet/google/gve/gve_tx_dqo.c       |    20 +-
 drivers/net/ethernet/google/gve/gve_utils.c        |    30 +-
 drivers/net/ethernet/google/gve/gve_utils.h        |     2 +-
 drivers/net/ethernet/hisilicon/hns/hnae.c          |     3 -
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c   |    11 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |     4 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |     6 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_devlink.c |     5 -
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c |    22 +-
 .../hisilicon/hns3/hns3vf/hclgevf_devlink.c        |     5 -
 drivers/net/ethernet/huawei/hinic/hinic_dev.h      |     4 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h   |   170 +-
 drivers/net/ethernet/huawei/hinic/hinic_main.c     |    13 +-
 drivers/net/ethernet/huawei/hinic/hinic_port.c     |    50 +-
 drivers/net/ethernet/huawei/hinic/hinic_port.h     |    12 +
 drivers/net/ethernet/huawei/hinic/hinic_rx.c       |     4 +-
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c    |    18 +
 drivers/net/ethernet/huawei/hinic/hinic_tx.c       |     4 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |    18 +-
 drivers/net/ethernet/ibm/ibmveth.h                 |     1 -
 drivers/net/ethernet/ibm/ibmvnic.c                 |   239 +-
 drivers/net/ethernet/ibm/ibmvnic.h                 |     5 +
 drivers/net/ethernet/intel/e1000/e1000_main.c      |     9 +-
 drivers/net/ethernet/intel/e1000e/Makefile         |     3 +
 drivers/net/ethernet/intel/e1000e/e1000.h          |     4 +-
 drivers/net/ethernet/intel/e1000e/e1000e_trace.h   |    42 +
 drivers/net/ethernet/intel/e1000e/ethtool.c        |     2 +
 drivers/net/ethernet/intel/e1000e/hw.h             |     9 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |    27 +
 drivers/net/ethernet/intel/e1000e/netdev.c         |    51 +-
 drivers/net/ethernet/intel/e1000e/ptp.c            |    17 +-
 drivers/net/ethernet/intel/fm10k/fm10k_netdev.c    |     8 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |     1 +
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h  |     8 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c      |    26 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |    12 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |    85 +-
 drivers/net/ethernet/intel/i40e/i40e_prototype.h   |     3 +
 drivers/net/ethernet/intel/i40e/i40e_ptp.c         |    17 +-
 drivers/net/ethernet/intel/i40e/i40e_trace.h       |    49 +
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |    27 +-
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c     |     8 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |     4 +-
 drivers/net/ethernet/intel/ice/ice.h               |    24 +
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h    |     4 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |     2 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |    48 +-
 drivers/net/ethernet/intel/ice/ice_common.h        |     1 +
 drivers/net/ethernet/intel/ice/ice_dcb.c           |     2 +-
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c       |    10 +
 drivers/net/ethernet/intel/ice/ice_devlink.c       |   634 +-
 drivers/net/ethernet/intel/ice/ice_devlink.h       |     3 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   181 +-
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h    |     3 +
 drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h     |    12 -
 drivers/net/ethernet/intel/ice/ice_lib.c           |   272 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   135 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           |   564 +-
 drivers/net/ethernet/intel/ice/ice_ptp.h           |    39 +-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c        |   348 +-
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h        |     8 +-
 drivers/net/ethernet/intel/ice/ice_repr.c          |    40 +-
 drivers/net/ethernet/intel/ice/ice_sched.c         |   104 +-
 drivers/net/ethernet/intel/ice/ice_sched.h         |    31 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c        |   351 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.h        |    40 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |    40 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h          |    18 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c      |     2 +-
 drivers/net/ethernet/intel/ice/ice_type.h          |     9 +
 drivers/net/ethernet/intel/ice/ice_vf_lib.c        |    24 +
 .../net/ethernet/intel/ice/ice_vf_lib_private.h    |     1 +
 drivers/net/ethernet/intel/ice/ice_vf_mbx.c        |    92 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |   195 +
 drivers/net/ethernet/intel/ice/ice_virtchnl.h      |     4 +
 .../ethernet/intel/ice/ice_virtchnl_allowlist.c    |     6 +
 drivers/net/ethernet/intel/ice/ice_xsk.c           |    25 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |    12 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |    18 +-
 drivers/net/ethernet/intel/igb/igb_ptp.c           |    18 +-
 drivers/net/ethernet/intel/igc/igc_defines.h       |     9 +
 drivers/net/ethernet/intel/igc/igc_ethtool.c       |    12 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |    15 +-
 drivers/net/ethernet/intel/igc/igc_regs.h          |     1 +
 drivers/net/ethernet/intel/igc/igc_tsn.c           |    30 +
 drivers/net/ethernet/intel/igc/igc_tsn.h           |     1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |    10 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |    61 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c     |     5 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |     8 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c       |    26 +-
 drivers/net/ethernet/intel/ixgbevf/ethtool.c       |    12 +-
 drivers/net/ethernet/intel/ixgbevf/ipsec.c         |     5 +
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |    25 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c         |    49 +-
 drivers/net/ethernet/marvell/mvneta.c              |    13 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |    16 +-
 .../net/ethernet/marvell/octeon_ep/octep_main.c    |    20 +-
 .../net/ethernet/marvell/octeon_ep/octep_main.h    |     2 +
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |    78 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |     9 +-
 .../ethernet/marvell/octeontx2/af/lmac_common.h    |    15 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |    18 +
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c    |     6 +-
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |     3 +
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c    |   262 +-
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h    |    36 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |    13 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |    49 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |    16 +-
 .../ethernet/marvell/octeontx2/af/rvu_devlink.c    |     7 -
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |    10 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |    22 +
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |   151 +-
 .../ethernet/marvell/octeontx2/af/rvu_npc_hash.c   |    21 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |     3 +
 .../ethernet/marvell/octeontx2/nic/otx2_devlink.c  |    15 -
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |    34 +
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |    52 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |     2 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |    25 +
 .../ethernet/marvell/prestera/prestera_devlink.c   |    22 -
 .../ethernet/marvell/prestera/prestera_devlink.h   |     5 -
 .../net/ethernet/marvell/prestera/prestera_main.c  |    21 +-
 .../net/ethernet/marvell/prestera/prestera_pci.c   |   119 +-
 drivers/net/ethernet/marvell/sky2.c                |     8 +-
 drivers/net/ethernet/mediatek/Makefile             |     2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   504 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |    59 +-
 drivers/net/ethernet/mediatek/mtk_ppe.c            |    22 +-
 drivers/net/ethernet/mediatek/mtk_ppe.h            |     4 +
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |    12 +-
 drivers/net/ethernet/mediatek/mtk_sgmii.c          |   174 +-
 drivers/net/ethernet/mediatek/mtk_wed.c            |   863 +-
 drivers/net/ethernet/mediatek/mtk_wed.h            |    21 +
 drivers/net/ethernet/mediatek/mtk_wed_debugfs.c    |    87 +
 drivers/net/ethernet/mediatek/mtk_wed_mcu.c        |   390 +
 drivers/net/ethernet/mediatek/mtk_wed_regs.h       |   140 +-
 drivers/net/ethernet/mediatek/mtk_wed_wo.c         |   512 +
 drivers/net/ethernet/mediatek/mtk_wed_wo.h         |   282 +
 drivers/net/ethernet/mellanox/mlx4/en_clock.c      |    29 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |     9 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |    18 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |     2 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |    18 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |     1 +
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |     1 -
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |    19 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.h  |     2 +
 .../mellanox/mlx5/core/diag/fs_tracepoint.c        |    16 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |    11 +-
 .../net/ethernet/mellanox/mlx5/core/en/devlink.c   |    17 -
 .../net/ethernet/mellanox/mlx5/core/en/devlink.h   |     2 -
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |     3 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |    16 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |    14 +
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |     1 -
 .../ethernet/mellanox/mlx5/core/en/tc/act/accept.c |     1 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.c    |     2 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.h    |    12 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/drop.c   |     1 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/goto.c   |     1 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/mirred.c |     7 +
 .../mellanox/mlx5/core/en/tc/act/mirred_nic.c      |     1 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/police.c |    86 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/trap.c   |    10 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/meter.c  |    40 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/meter.h  |     5 +-
 .../ethernet/mellanox/mlx5/core/en/tc/post_meter.c |   402 +-
 .../ethernet/mellanox/mlx5/core/en/tc/post_meter.h |    39 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |    89 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |     4 -
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |   371 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |   137 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |  1069 +-
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c    |   303 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       |    22 +-
 .../mellanox/mlx5/core/en_accel/ipsec_stats.c      |    52 +
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |    65 +-
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  |    12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |     2 -
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |     1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |    29 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   148 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   171 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |    18 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |    19 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   445 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |     9 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |     5 +
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |     8 +-
 .../net/ethernet/mellanox/mlx5/core/esw/debugfs.c  |    22 +-
 .../ethernet/mellanox/mlx5/core/esw/devlink_port.c |     4 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |    43 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |    16 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   270 +-
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |    32 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |    20 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |     1 +
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |     7 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c |     6 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/mp.c   |    79 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c  |    10 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h  |     4 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |    22 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |    22 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |     5 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |     3 +-
 .../mellanox/mlx5/core/steering/dr_action.c        |   300 +-
 .../mellanox/mlx5/core/steering/dr_buddy.c         |     2 -
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |    84 +
 .../ethernet/mellanox/mlx5/core/steering/dr_dbg.c  |    29 +-
 .../mellanox/mlx5/core/steering/dr_definer.c       |   151 +
 .../mellanox/mlx5/core/steering/dr_domain.c        |    96 +-
 .../mellanox/mlx5/core/steering/dr_icm_pool.c      |   174 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |   119 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |   141 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |    22 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.h  |     1 +
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        |    69 +
 .../mellanox/mlx5/core/steering/dr_ste_v1.h        |     1 +
 .../mellanox/mlx5/core/steering/dr_ste_v2.c        |     1 +
 .../mellanox/mlx5/core/steering/dr_table.c         |     2 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |    59 +-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |    53 +-
 .../mlx5/core/steering/mlx5_ifc_dr_ste_v1.h        |    35 +
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |    22 +-
 drivers/net/ethernet/mellanox/mlx5/core/uar.c      |     1 -
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |    30 +-
 drivers/net/ethernet/mellanox/mlx5/core/wq.h       |    17 +
 drivers/net/ethernet/mellanox/mlxsw/core.c         |    25 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h         |     7 +-
 drivers/net/ethernet/mellanox/mlxsw/i2c.c          |     6 +-
 drivers/net/ethernet/mellanox/mlxsw/minimal.c      |    17 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h          |    36 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |    42 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |     5 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_ethtool.c |    21 +
 .../net/ethernet/mellanox/mlxsw/spectrum_ipip.c    |   160 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_ipip.h    |     1 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c |    18 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |   102 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.h  |     4 +
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c   |    64 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_trap.c    |    25 +
 drivers/net/ethernet/mellanox/mlxsw/trap.h         |     2 +
 drivers/net/ethernet/microchip/Kconfig             |     1 +
 drivers/net/ethernet/microchip/Makefile            |     1 +
 drivers/net/ethernet/microchip/lan743x_ethtool.c   |   159 +-
 drivers/net/ethernet/microchip/lan743x_ethtool.h   |    71 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |     6 +-
 drivers/net/ethernet/microchip/lan743x_main.h      |     3 +
 drivers/net/ethernet/microchip/lan743x_ptp.c       |    54 +-
 drivers/net/ethernet/microchip/lan966x/Kconfig     |     2 +
 drivers/net/ethernet/microchip/lan966x/Makefile    |     7 +-
 .../net/ethernet/microchip/lan966x/lan966x_fdma.c  |   433 +-
 .../net/ethernet/microchip/lan966x/lan966x_goto.c  |    54 +
 .../net/ethernet/microchip/lan966x/lan966x_ifh.h   |     1 +
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |    42 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.h  |    95 +-
 .../ethernet/microchip/lan966x/lan966x_phylink.c   |     2 -
 .../net/ethernet/microchip/lan966x/lan966x_ptp.c   |   234 +-
 .../net/ethernet/microchip/lan966x/lan966x_regs.h  |   196 +
 .../net/ethernet/microchip/lan966x/lan966x_tc.c    |     2 +
 .../ethernet/microchip/lan966x/lan966x_tc_flower.c |   254 +
 .../microchip/lan966x/lan966x_tc_matchall.c        |     6 +
 .../microchip/lan966x/lan966x_vcap_ag_api.c        |  1608 ++
 .../microchip/lan966x/lan966x_vcap_ag_api.h        |    11 +
 .../ethernet/microchip/lan966x/lan966x_vcap_impl.c |   549 +
 .../net/ethernet/microchip/lan966x/lan966x_xdp.c   |   140 +
 drivers/net/ethernet/microchip/sparx5/Kconfig      |    12 +
 drivers/net/ethernet/microchip/sparx5/Makefile     |    11 +-
 drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c |   310 +
 .../net/ethernet/microchip/sparx5/sparx5_main.c    |    12 +
 .../net/ethernet/microchip/sparx5/sparx5_main.h    |    20 +
 .../ethernet/microchip/sparx5/sparx5_main_regs.h   |   583 +-
 .../net/ethernet/microchip/sparx5/sparx5_phylink.c |     1 -
 .../net/ethernet/microchip/sparx5/sparx5_port.c    |    99 +
 .../net/ethernet/microchip/sparx5/sparx5_port.h    |    42 +
 drivers/net/ethernet/microchip/sparx5/sparx5_qos.c |     4 +
 drivers/net/ethernet/microchip/sparx5/sparx5_tc.c  |    51 +
 drivers/net/ethernet/microchip/sparx5/sparx5_tc.h  |    19 +
 .../ethernet/microchip/sparx5/sparx5_tc_flower.c   |  1016 +
 .../ethernet/microchip/sparx5/sparx5_tc_matchall.c |    97 +
 .../ethernet/microchip/sparx5/sparx5_vcap_ag_api.c |  1351 ++
 .../ethernet/microchip/sparx5/sparx5_vcap_ag_api.h |    18 +
 .../microchip/sparx5/sparx5_vcap_debugfs.c         |   200 +
 .../microchip/sparx5/sparx5_vcap_debugfs.h         |    33 +
 .../ethernet/microchip/sparx5/sparx5_vcap_impl.c   |   723 +
 .../ethernet/microchip/sparx5/sparx5_vcap_impl.h   |    81 +
 drivers/net/ethernet/microchip/vcap/Kconfig        |    53 +
 drivers/net/ethernet/microchip/vcap/Makefile       |    10 +
 drivers/net/ethernet/microchip/vcap/vcap_ag_api.h  |   735 +
 drivers/net/ethernet/microchip/vcap/vcap_api.c     |  2883 +++
 drivers/net/ethernet/microchip/vcap/vcap_api.h     |   280 +
 .../net/ethernet/microchip/vcap/vcap_api_client.h  |   265 +
 .../net/ethernet/microchip/vcap/vcap_api_debugfs.c |   431 +
 .../net/ethernet/microchip/vcap/vcap_api_debugfs.h |    41 +
 .../microchip/vcap/vcap_api_debugfs_kunit.c        |   555 +
 .../net/ethernet/microchip/vcap/vcap_api_kunit.c   |  2245 ++
 .../net/ethernet/microchip/vcap/vcap_api_private.h |   113 +
 .../net/ethernet/microchip/vcap/vcap_model_kunit.c |  5570 +++++
 .../net/ethernet/microchip/vcap/vcap_model_kunit.h |    10 +
 drivers/net/ethernet/microsoft/Kconfig             |     1 +
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |    70 +-
 drivers/net/ethernet/microsoft/mana/hw_channel.c   |     6 +-
 drivers/net/ethernet/microsoft/mana/mana_bpf.c     |     2 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |   185 +-
 drivers/net/ethernet/microsoft/mana/mana_ethtool.c |    10 +-
 drivers/net/ethernet/microsoft/mana/shm_channel.c  |     2 +-
 drivers/net/ethernet/mscc/ocelot.c                 |     6 +-
 drivers/net/ethernet/mscc/ocelot_net.c             |    12 +-
 drivers/net/ethernet/mscc/ocelot_stats.c           |   244 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c         |    14 -
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |     3 +-
 drivers/net/ethernet/neterion/s2io.c               |     2 +-
 drivers/net/ethernet/netronome/Kconfig             |    11 +
 drivers/net/ethernet/netronome/nfp/Makefile        |     2 +
 drivers/net/ethernet/netronome/nfp/ccm_mbox.c      |     2 +-
 drivers/net/ethernet/netronome/nfp/crypto/crypto.h |    23 +
 drivers/net/ethernet/netronome/nfp/crypto/ipsec.c  |   592 +
 .../net/ethernet/netronome/nfp/flower/lag_conf.c   |    52 +-
 drivers/net/ethernet/netronome/nfp/flower/main.c   |     9 +
 drivers/net/ethernet/netronome/nfp/flower/main.h   |    21 +-
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    |    53 +-
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c       |    58 +-
 drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c    |    18 +
 drivers/net/ethernet/netronome/nfp/nfd3/nfd3.h     |     8 +
 drivers/net/ethernet/netronome/nfp/nfp_app.h       |     2 -
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c   |    27 +-
 drivers/net/ethernet/netronome/nfp/nfp_main.h      |     2 +-
 drivers/net/ethernet/netronome/nfp/nfp_net.h       |    16 +
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |    89 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h  |    37 +-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |    81 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_main.c  |    12 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c  |     5 +-
 drivers/net/ethernet/netronome/nfp/nfp_port.h      |     2 -
 .../net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c   |    17 +
 .../net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h   |    56 +
 .../ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c   |    26 +
 drivers/net/ethernet/nvidia/forcedeth.c            |     8 +-
 drivers/net/ethernet/pensando/ionic/ionic_dev.c    |    14 +
 drivers/net/ethernet/pensando/ionic/ionic_dev.h    |     3 +
 .../net/ethernet/pensando/ionic/ionic_devlink.c    |     6 +-
 drivers/net/ethernet/pensando/ionic/ionic_if.h     |    45 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |   113 +-
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |     2 +-
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |    31 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.c        |     3 +-
 drivers/net/ethernet/qlogic/qed/qed_devlink.c      |     4 -
 drivers/net/ethernet/qlogic/qed/qed_ll2.c          |     2 +-
 drivers/net/ethernet/qlogic/qede/qede_ptp.c        |    13 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c    |     2 +-
 .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |     2 +
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c    |     4 +-
 drivers/net/ethernet/realtek/8139too.c             |     8 +-
 drivers/net/ethernet/realtek/r8169_main.c          |     9 +-
 drivers/net/ethernet/renesas/Kconfig               |    12 +
 drivers/net/ethernet/renesas/Makefile              |     4 +
 drivers/net/ethernet/renesas/ravb_ptp.c            |    17 +-
 drivers/net/ethernet/renesas/rcar_gen4_ptp.c       |   181 +
 drivers/net/ethernet/renesas/rcar_gen4_ptp.h       |    72 +
 drivers/net/ethernet/renesas/rswitch.c             |  1841 ++
 drivers/net/ethernet/renesas/rswitch.h             |   973 +
 drivers/net/ethernet/rocker/rocker_ofdpa.c         |    15 +-
 drivers/net/ethernet/sfc/Makefile                  |     2 +-
 drivers/net/ethernet/sfc/ef100_ethtool.c           |     2 -
 drivers/net/ethernet/sfc/ef100_rx.c                |    23 +-
 drivers/net/ethernet/sfc/ef100_tx.c                |     3 +-
 drivers/net/ethernet/sfc/efx_channels.c            |     9 +-
 drivers/net/ethernet/sfc/efx_common.c              |     2 +-
 drivers/net/ethernet/sfc/ethtool_common.c          |    37 -
 drivers/net/ethernet/sfc/ethtool_common.h          |     2 -
 drivers/net/ethernet/sfc/mae.c                     |   306 +-
 drivers/net/ethernet/sfc/mae.h                     |     7 +
 drivers/net/ethernet/sfc/mae_counter_format.h      |    73 +
 drivers/net/ethernet/sfc/mcdi.h                    |    17 +
 drivers/net/ethernet/sfc/net_driver.h              |    19 +-
 drivers/net/ethernet/sfc/ptp.c                     |     7 +-
 drivers/net/ethernet/sfc/rx_common.c               |     3 +
 drivers/net/ethernet/sfc/siena/efx_common.c        |     2 +-
 drivers/net/ethernet/sfc/siena/ptp.c               |     7 +-
 drivers/net/ethernet/sfc/tc.c                      |   302 +-
 drivers/net/ethernet/sfc/tc.h                      |    48 +-
 drivers/net/ethernet/sfc/tc_counters.c             |   503 +
 drivers/net/ethernet/sfc/tc_counters.h             |    59 +
 drivers/net/ethernet/sfc/tx.c                      |     4 +-
 drivers/net/ethernet/smsc/Kconfig                  |    14 -
 drivers/net/ethernet/smsc/Makefile                 |     1 -
 drivers/net/ethernet/smsc/smc911x.c                |  2198 --
 drivers/net/ethernet/smsc/smc911x.h                |   901 -
 drivers/net/ethernet/socionext/sni_ave.c           |    14 +-
 drivers/net/ethernet/stmicro/stmmac/Kconfig        |     9 +
 drivers/net/ethernet/stmicro/stmmac/Makefile       |     1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c  |   388 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h       |     4 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |    21 +-
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |     3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    11 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c   |    23 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h   |     2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |     8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |     3 +
 drivers/net/ethernet/sun/cassini.c                 |    48 +-
 drivers/net/ethernet/sun/sunvnet_common.c          |     4 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   266 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h           |     6 +
 drivers/net/ethernet/ti/am65-cpts.c                |    81 +-
 drivers/net/ethernet/ti/am65-cpts.h                |    10 +
 drivers/net/ethernet/ti/cpsw_ale.c                 |    10 +
 drivers/net/ethernet/ti/cpsw_ale.h                 |     1 +
 drivers/net/ethernet/ti/cpts.c                     |    20 +-
 drivers/net/ethernet/ti/netcp_core.c               |    10 +-
 drivers/net/ethernet/via/via-rhine.c               |     8 +-
 drivers/net/ethernet/wangxun/Kconfig               |     7 +
 drivers/net/ethernet/wangxun/Makefile              |     1 +
 drivers/net/ethernet/wangxun/libwx/Makefile        |     7 +
 drivers/net/ethernet/wangxun/libwx/wx_hw.c         |   936 +
 drivers/net/ethernet/wangxun/libwx/wx_hw.h         |    28 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h       |   352 +
 drivers/net/ethernet/wangxun/ngbe/Makefile         |     2 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe.h           |    55 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c        |    87 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h        |    12 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c      |   368 +
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h      |    99 +-
 drivers/net/ethernet/wangxun/txgbe/Makefile        |     3 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe.h         |    23 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c      |   312 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h      |    11 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c    |   465 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_type.h    |    47 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |     2 -
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |    45 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c  |    79 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |     2 +-
 drivers/net/ethernet/xscale/ptp_ixp46x.c           |    19 +-
 drivers/net/fddi/defxx.c                           |    22 +-
 drivers/net/geneve.c                               |     2 +-
 drivers/net/hamradio/baycom_epp.c                  |     2 +-
 drivers/net/hamradio/scc.c                         |     6 +-
 drivers/net/hyperv/netvsc_drv.c                    |    32 +-
 drivers/net/ieee802154/atusb.c                     |    33 +-
 drivers/net/ieee802154/mac802154_hwsim.c           |   179 +-
 drivers/net/ieee802154/mcr20a.c                    |     9 +-
 drivers/net/ifb.c                                  |    12 +-
 drivers/net/ipa/Makefile                           |     2 +-
 drivers/net/ipa/data/ipa_data-v3.1.c               |    19 +-
 drivers/net/ipa/data/ipa_data-v3.5.1.c             |    27 +-
 drivers/net/ipa/data/ipa_data-v4.11.c              |    17 +-
 drivers/net/ipa/data/ipa_data-v4.2.c               |    17 +-
 drivers/net/ipa/data/ipa_data-v4.5.c               |    17 +-
 drivers/net/ipa/data/ipa_data-v4.7.c               |   405 +
 drivers/net/ipa/data/ipa_data-v4.9.c               |    17 +-
 drivers/net/ipa/gsi_trans.c                        |     7 +-
 drivers/net/ipa/ipa.h                              |    32 +-
 drivers/net/ipa/ipa_cmd.c                          |    74 +-
 drivers/net/ipa/ipa_cmd.h                          |    16 +-
 drivers/net/ipa/ipa_data.h                         |     3 +
 drivers/net/ipa/ipa_endpoint.c                     |   277 +-
 drivers/net/ipa/ipa_endpoint.h                     |     2 +-
 drivers/net/ipa/ipa_interrupt.c                    |    34 +-
 drivers/net/ipa/ipa_main.c                         |   112 +-
 drivers/net/ipa/ipa_mem.c                          |    19 +-
 drivers/net/ipa/ipa_qmi.c                          |     9 +-
 drivers/net/ipa/ipa_qmi_msg.c                      |    20 +-
 drivers/net/ipa/ipa_qmi_msg.h                      |    20 +-
 drivers/net/ipa/ipa_reg.c                          |     2 +
 drivers/net/ipa/ipa_reg.h                          |     1 +
 drivers/net/ipa/ipa_sysfs.c                        |     6 +-
 drivers/net/ipa/ipa_table.c                        |   350 +-
 drivers/net/ipa/ipa_table.h                        |    30 +-
 drivers/net/ipa/ipa_version.h                      |     4 +
 drivers/net/ipa/reg/ipa_reg-v3.1.c                 |    13 +-
 drivers/net/ipa/reg/ipa_reg-v3.5.1.c               |    13 +-
 drivers/net/ipa/reg/ipa_reg-v4.11.c                |    13 +-
 drivers/net/ipa/reg/ipa_reg-v4.2.c                 |    13 +-
 drivers/net/ipa/reg/ipa_reg-v4.5.c                 |    13 +-
 drivers/net/ipa/reg/ipa_reg-v4.7.c                 |   507 +
 drivers/net/ipa/reg/ipa_reg-v4.9.c                 |    13 +-
 drivers/net/ipvlan/ipvlan_main.c                   |     4 +-
 drivers/net/loopback.c                             |     4 +-
 drivers/net/macsec.c                               |    12 +-
 drivers/net/macvlan.c                              |     4 +-
 drivers/net/mhi_net.c                              |     8 +-
 drivers/net/netdevsim/dev.c                        |     7 +-
 drivers/net/netdevsim/ipsec.c                      |     5 +
 drivers/net/netdevsim/netdev.c                     |    14 +-
 drivers/net/ntb_netdev.c                           |     4 +-
 drivers/net/pcs/pcs-altera-tse.c                   |    21 +-
 drivers/net/pcs/pcs-xpcs.c                         |    10 +-
 drivers/net/phy/Kconfig                            |     5 +-
 drivers/net/phy/aquantia_main.c                    |    40 +
 drivers/net/phy/dp83822.c                          |     2 +
 drivers/net/phy/dp83867.c                          |     7 +
 drivers/net/phy/micrel.c                           |    77 +
 drivers/net/phy/motorcomm.c                        |  1677 +-
 drivers/net/phy/mscc/mscc_macsec.c                 |    57 +-
 drivers/net/phy/mscc/mscc_macsec.h                 |     2 -
 drivers/net/phy/mxl-gpy.c                          |   106 +-
 drivers/net/phy/phy-core.c                         |    11 +-
 drivers/net/phy/phy.c                              |     1 +
 drivers/net/phy/phy_device.c                       |    12 +
 drivers/net/phy/phylink.c                          |    43 +-
 drivers/net/phy/sfp.c                              |   162 +-
 drivers/net/ppp/ppp_generic.c                      |     2 +
 drivers/net/tap.c                                  |    10 +-
 drivers/net/team/team.c                            |     6 +-
 drivers/net/team/team_mode_loadbalance.c           |     4 +-
 drivers/net/thunderbolt.c                          |    26 +-
 drivers/net/tun.c                                  |    75 +-
 drivers/net/usb/asix_devices.c                     |    23 +-
 drivers/net/usb/cdc_ether.c                        |     6 +
 drivers/net/usb/cdc_ncm.c                          |     3 +-
 drivers/net/usb/qmi_wwan.c                         |     5 +-
 drivers/net/veth.c                                 |    14 +-
 drivers/net/virtio_net.c                           |    35 +-
 drivers/net/vrf.c                                  |     4 +-
 drivers/net/vxlan/vxlan_core.c                     |     4 +-
 drivers/net/vxlan/vxlan_vnifilter.c                |     4 +-
 drivers/net/wan/farsync.c                          |     2 +
 drivers/net/wireless/admtek/adm8211.c              |     1 +
 drivers/net/wireless/ath/ar5523/ar5523.c           |     7 +
 drivers/net/wireless/ath/ath10k/Kconfig            |     1 +
 drivers/net/wireless/ath/ath10k/core.c             |    16 +
 drivers/net/wireless/ath/ath10k/debug.c            |     5 +-
 drivers/net/wireless/ath/ath10k/htc.c              |     9 +
 drivers/net/wireless/ath/ath10k/htt.h              |     6 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |    25 +-
 drivers/net/wireless/ath/ath10k/hw.h               |     2 +
 drivers/net/wireless/ath/ath10k/pci.c              |    20 +-
 drivers/net/wireless/ath/ath10k/qmi.c              |    37 +-
 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c     |   126 +-
 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h     |   102 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |     7 +
 drivers/net/wireless/ath/ath11k/core.c             |    15 +-
 drivers/net/wireless/ath/ath11k/core.h             |     3 +
 drivers/net/wireless/ath/ath11k/hw.h               |     1 +
 drivers/net/wireless/ath/ath11k/mac.c              |   232 +-
 drivers/net/wireless/ath/ath11k/mac.h              |     2 +-
 drivers/net/wireless/ath/ath11k/pcic.c             |    13 +-
 drivers/net/wireless/ath/ath11k/qmi.c              |    87 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |     2 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |     1 +
 drivers/net/wireless/ath/ath9k/Makefile            |     5 -
 drivers/net/wireless/ath/ath9k/ar9003_mci.c        |     3 +-
 drivers/net/wireless/ath/ath9k/ath9k.h             |     1 +
 drivers/net/wireless/ath/ath9k/hif_usb.c           |    46 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |     1 +
 drivers/net/wireless/ath/ath9k/mci.c               |     8 +-
 drivers/net/wireless/ath/ath9k/tx99.c              |     2 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |     2 -
 drivers/net/wireless/ath/carl9170/Makefile         |     5 -
 drivers/net/wireless/ath/carl9170/fwcmd.h          |     4 +-
 drivers/net/wireless/ath/carl9170/main.c           |     1 +
 drivers/net/wireless/ath/carl9170/wlan.h           |     2 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |     1 +
 drivers/net/wireless/ath/wil6210/debugfs.c         |    36 +-
 drivers/net/wireless/atmel/at76c50x-usb.c          |     1 +
 drivers/net/wireless/atmel/atmel.c                 |   162 +-
 drivers/net/wireless/broadcom/b43/main.c           |    11 +-
 drivers/net/wireless/broadcom/b43legacy/main.c     |     1 +
 .../wireless/broadcom/brcm80211/brcmfmac/Makefile  |    11 +
 .../broadcom/brcm80211/brcmfmac/bca/Makefile       |    12 +
 .../broadcom/brcm80211/brcmfmac/bca/core.c         |    27 +
 .../broadcom/brcm80211/brcmfmac/bca/module.c       |    27 +
 .../broadcom/brcm80211/brcmfmac/bca/vops.h         |    11 +
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |    52 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |    36 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   587 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |    15 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |    15 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |     9 +
 .../broadcom/brcm80211/brcmfmac/cyw/Makefile       |    12 +
 .../broadcom/brcm80211/brcmfmac/cyw/core.c         |    27 +
 .../broadcom/brcm80211/brcmfmac/cyw/module.c       |    27 +
 .../broadcom/brcm80211/brcmfmac/cyw/vops.h         |    11 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |     3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |     4 +-
 .../broadcom/brcm80211/brcmfmac/firmware.c         |     5 +
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |     4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fwvid.c   |   199 +
 .../wireless/broadcom/brcm80211/brcmfmac/fwvid.h   |    47 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |     8 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   211 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.c |     6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |    17 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |    27 +-
 .../broadcom/brcm80211/brcmfmac/wcc/Makefile       |    12 +
 .../broadcom/brcm80211/brcmfmac/wcc/core.c         |    27 +
 .../broadcom/brcm80211/brcmfmac/wcc/module.c       |    27 +
 .../broadcom/brcm80211/brcmfmac/wcc/vops.h         |    11 +
 .../net/wireless/broadcom/brcm80211/brcmsmac/led.c |     3 -
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |     1 +
 drivers/net/wireless/cisco/airo.c                  |   204 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |    11 -
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |    16 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |     7 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |     1 +
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |    36 +-
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c  |     1 +
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   |    95 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h    |     6 +-
 .../net/wireless/intel/iwlwifi/fw/api/phy-ctxt.h   |    33 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     |    10 +-
 drivers/net/wireless/intel/iwlwifi/fw/dump.c       |     7 +-
 drivers/net/wireless/intel/iwlwifi/fw/rs.c         |     2 +
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |     7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |     3 +
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.h  |     3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h |     1 +
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |   237 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |     5 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |     5 +
 drivers/net/wireless/intel/iwlwifi/mei/iwl-mei.h   |    36 +-
 drivers/net/wireless/intel/iwlwifi/mei/main.c      |   304 +-
 drivers/net/wireless/intel/iwlwifi/mei/net.c       |    10 +-
 drivers/net/wireless/intel/iwlwifi/mei/sap.h       |    65 +-
 .../net/wireless/intel/iwlwifi/mei/trace-data.h    |     2 +-
 drivers/net/wireless/intel/iwlwifi/mei/trace.h     |     2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/Makefile    |     1 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |     9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |     4 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |    12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |    38 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |    60 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   212 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c   |   226 +
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |    21 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |    25 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |    54 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |   125 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |    46 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |    29 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |     7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |    27 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |    33 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |    85 +-
 .../net/wireless/intersil/hostap/hostap_ioctl.c    |   244 +-
 drivers/net/wireless/intersil/orinoco/wext.c       |   131 +-
 drivers/net/wireless/intersil/p54/eeprom.h         |     4 +-
 drivers/net/wireless/intersil/p54/main.c           |     1 +
 drivers/net/wireless/mac80211_hwsim.c              |     1 +
 drivers/net/wireless/marvell/libertas_tf/main.c    |     1 +
 drivers/net/wireless/marvell/mwifiex/debugfs.c     |     2 +-
 drivers/net/wireless/marvell/mwifiex/main.h        |     1 +
 drivers/net/wireless/marvell/mwl8k.c               |     1 +
 drivers/net/wireless/mediatek/mt76/Kconfig         |     1 +
 drivers/net/wireless/mediatek/mt76/Makefile        |     1 +
 drivers/net/wireless/mediatek/mt76/debugfs.c       |    19 -
 drivers/net/wireless/mediatek/mt76/dma.c           |   246 +-
 drivers/net/wireless/mediatek/mt76/dma.h           |     8 +
 drivers/net/wireless/mediatek/mt76/mac80211.c      |    27 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |    50 +-
 .../net/wireless/mediatek/mt76/mt7603/debugfs.c    |     2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |     2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |     6 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |     2 +-
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |     6 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |    34 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |     7 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |     2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |     6 +-
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |     2 +
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |    16 +
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |    17 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   214 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |    99 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |    28 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h |     2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |     2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    |    13 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |    16 +-
 .../net/wireless/mediatek/mt76/mt76x02_debugfs.c   |    19 +-
 .../net/wireless/mediatek/mt76/mt76x02_eeprom.h    |     2 -
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |     6 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.c   |    22 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_phy.h   |     6 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_txrx.c  |    14 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c |    16 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.h |     2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/init.c   |     2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/phy.c    |     6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/Kconfig  |     1 +
 drivers/net/wireless/mediatek/mt76/mt7915/Makefile |     3 +-
 .../net/wireless/mediatek/mt76/mt7915/coredump.c   |   410 +
 .../net/wireless/mediatek/mt76/mt7915/coredump.h   |   136 +
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |   307 +-
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    |   207 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |    66 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h |     5 -
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   135 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |   635 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   142 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   495 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |    60 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |   414 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |    65 +-
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |   106 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |    88 +-
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c    |    21 +-
 .../net/wireless/mediatek/mt76/mt7915/testmode.c   |    71 +-
 .../net/wireless/mediatek/mt76/mt7921/debugfs.c    |     2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |    91 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |    56 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   233 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |   161 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |    74 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |    59 +-
 drivers/net/wireless/mediatek/mt76/mt7921/sdio.c   |    31 +-
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c    |    22 +-
 drivers/net/wireless/mediatek/mt76/mt7996/Kconfig  |    12 +
 drivers/net/wireless/mediatek/mt76/mt7996/Makefile |     6 +
 .../net/wireless/mediatek/mt76/mt7996/debugfs.c    |   851 +
 drivers/net/wireless/mediatek/mt76/mt7996/dma.c    |   360 +
 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c |   229 +
 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.h |    75 +
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |   823 +
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |  2498 ++
 drivers/net/wireless/mediatek/mt76/mt7996/mac.h    |   398 +
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |  1334 ++
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |  3607 +++
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h    |   669 +
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c   |   386 +
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |   523 +
 drivers/net/wireless/mediatek/mt76/mt7996/pci.c    |   222 +
 drivers/net/wireless/mediatek/mt76/mt7996/regs.h   |   542 +
 drivers/net/wireless/mediatek/mt76/sdio.c          |     2 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |    30 +
 drivers/net/wireless/mediatek/mt76/usb.c           |    13 +-
 drivers/net/wireless/mediatek/mt76/util.h          |     6 -
 drivers/net/wireless/mediatek/mt7601u/main.c       |     1 +
 drivers/net/wireless/microchip/wilc1000/sdio.c     |     1 +
 drivers/net/wireless/purelifi/plfxlc/mac.c         |     1 +
 drivers/net/wireless/purelifi/plfxlc/usb.c         |     1 +
 drivers/net/wireless/ralink/rt2x00/rt2400pci.c     |     1 +
 drivers/net/wireless/ralink/rt2x00/rt2500pci.c     |     1 +
 drivers/net/wireless/ralink/rt2x00/rt2500usb.c     |     1 +
 drivers/net/wireless/ralink/rt2x00/rt2800pci.c     |     1 +
 drivers/net/wireless/ralink/rt2x00/rt2800soc.c     |     1 +
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c     |     1 +
 drivers/net/wireless/ralink/rt2x00/rt61pci.c       |     1 +
 drivers/net/wireless/ralink/rt2x00/rt73usb.c       |     1 +
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |     1 +
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |     1 +
 drivers/net/wireless/realtek/rtl8xxxu/Kconfig      |     7 +-
 drivers/net/wireless/realtek/rtl8xxxu/Makefile     |     2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |    97 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c |  1766 ++
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c |    73 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |   161 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c |   114 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c |    93 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   683 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |    30 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    |     5 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |     1 +
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   |     8 -
 .../net/wireless/realtek/rtlwifi/rtl8192se/phy.c   |     3 -
 drivers/net/wireless/realtek/rtw88/Kconfig         |    47 +
 drivers/net/wireless/realtek/rtw88/Makefile        |    15 +
 drivers/net/wireless/realtek/rtw88/coex.c          |     3 +-
 drivers/net/wireless/realtek/rtw88/debug.c         |    15 +
 drivers/net/wireless/realtek/rtw88/fw.c            |    31 +-
 drivers/net/wireless/realtek/rtw88/fw.h            |    11 +
 drivers/net/wireless/realtek/rtw88/hci.h           |     9 +-
 drivers/net/wireless/realtek/rtw88/mac.c           |    21 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |     2 +-
 drivers/net/wireless/realtek/rtw88/main.c          |    12 +-
 drivers/net/wireless/realtek/rtw88/main.h          |    12 +-
 drivers/net/wireless/realtek/rtw88/phy.c           |     6 +-
 drivers/net/wireless/realtek/rtw88/ps.c            |     2 +-
 drivers/net/wireless/realtek/rtw88/reg.h           |     1 +
 drivers/net/wireless/realtek/rtw88/rtw8723d.c      |    28 +
 drivers/net/wireless/realtek/rtw88/rtw8723d.h      |    13 +-
 drivers/net/wireless/realtek/rtw88/rtw8723du.c     |    36 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |    18 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.h      |    21 +
 drivers/net/wireless/realtek/rtw88/rtw8821cu.c     |    50 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |    19 +
 drivers/net/wireless/realtek/rtw88/rtw8822bu.c     |    90 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |    24 +
 drivers/net/wireless/realtek/rtw88/rtw8822cu.c     |    44 +
 drivers/net/wireless/realtek/rtw88/tx.h            |    31 +
 drivers/net/wireless/realtek/rtw88/usb.c           |   911 +
 drivers/net/wireless/realtek/rtw88/usb.h           |   107 +
 drivers/net/wireless/realtek/rtw88/util.c          |   103 +
 drivers/net/wireless/realtek/rtw88/util.h          |    12 +-
 drivers/net/wireless/realtek/rtw89/Kconfig         |    14 +
 drivers/net/wireless/realtek/rtw89/Makefile        |    11 +
 drivers/net/wireless/realtek/rtw89/chan.c          |    40 +-
 drivers/net/wireless/realtek/rtw89/coex.c          |     9 +-
 drivers/net/wireless/realtek/rtw89/core.c          |   102 +-
 drivers/net/wireless/realtek/rtw89/core.h          |   238 +-
 drivers/net/wireless/realtek/rtw89/debug.c         |  1052 +-
 drivers/net/wireless/realtek/rtw89/debug.h         |     2 +
 drivers/net/wireless/realtek/rtw89/fw.c            |   790 +-
 drivers/net/wireless/realtek/rtw89/fw.h            |   731 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |   770 +-
 drivers/net/wireless/realtek/rtw89/mac.h           |   120 +
 drivers/net/wireless/realtek/rtw89/mac80211.c      |    70 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |    41 +-
 drivers/net/wireless/realtek/rtw89/pci.h           |    12 +
 drivers/net/wireless/realtek/rtw89/phy.c           |   358 +-
 drivers/net/wireless/realtek/rtw89/phy.h           |    87 +-
 drivers/net/wireless/realtek/rtw89/ps.c            |     2 +-
 drivers/net/wireless/realtek/rtw89/ps.h            |     1 +
 drivers/net/wireless/realtek/rtw89/reg.h           |   466 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |   179 +-
 drivers/net/wireless/realtek/rtw89/rtw8852a.h      |     1 -
 drivers/net/wireless/realtek/rtw89/rtw8852b.c      |  2445 +-
 drivers/net/wireless/realtek/rtw89/rtw8852b.h      |   137 +
 drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c  |  4174 ++++
 drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.h  |    25 +
 .../wireless/realtek/rtw89/rtw8852b_rfk_table.c    |   794 +
 .../wireless/realtek/rtw89/rtw8852b_rfk_table.h    |    62 +
 .../net/wireless/realtek/rtw89/rtw8852b_table.c    | 22877 +++++++++++++++++++
 .../net/wireless/realtek/rtw89/rtw8852b_table.h    |    30 +
 drivers/net/wireless/realtek/rtw89/rtw8852be.c     |    64 +
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |   232 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c.h      |     1 -
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c  |    25 +-
 .../net/wireless/realtek/rtw89/rtw8852c_table.c    |   988 +-
 drivers/net/wireless/realtek/rtw89/txrx.h          |     4 +-
 drivers/net/wireless/realtek/rtw89/util.h          |    11 +
 drivers/net/wireless/realtek/rtw89/wow.c           |   859 +
 drivers/net/wireless/realtek/rtw89/wow.h           |    21 +
 drivers/net/wireless/rsi/rsi_91x_core.c            |     4 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |     6 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |     1 +
 drivers/net/wireless/silabs/wfx/main.c             |     1 +
 drivers/net/wireless/st/cw1200/main.c              |     1 +
 drivers/net/wireless/ti/Kconfig                    |     8 -
 drivers/net/wireless/ti/wilink_platform_data.c     |    35 -
 drivers/net/wireless/ti/wl1251/main.c              |     1 +
 drivers/net/wireless/ti/wl1251/sdio.c              |     8 +-
 drivers/net/wireless/ti/wl1251/spi.c               |    76 +-
 drivers/net/wireless/ti/wl1251/wl1251.h            |     1 -
 drivers/net/wireless/ti/wlcore/main.c              |     1 +
 drivers/net/wireless/ti/wlcore/spi.c               |     1 -
 drivers/net/wireless/zydas/zd1201.c                |   174 +-
 drivers/net/wireless/zydas/zd1211rw/zd_mac.c       |     1 +
 drivers/net/wwan/Kconfig                           |     1 +
 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c          |     2 +-
 drivers/net/wwan/mhi_wwan_mbim.c                   |     8 +-
 drivers/net/wwan/t7xx/Makefile                     |     3 +
 drivers/net/wwan/t7xx/t7xx_hif_cldma.c             |     2 +
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif.h            |    14 +-
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.c         |   218 +-
 drivers/net/wwan/t7xx/t7xx_hif_dpmaif_rx.h         |     1 +
 drivers/net/wwan/t7xx/t7xx_netdev.c                |    91 +-
 drivers/net/wwan/t7xx/t7xx_netdev.h                |     5 +
 drivers/net/wwan/t7xx/t7xx_pci.h                   |     3 +
 drivers/net/wwan/t7xx/t7xx_port.h                  |     9 +-
 drivers/net/wwan/t7xx/t7xx_port_proxy.c            |    12 +
 drivers/net/wwan/t7xx/t7xx_port_proxy.h            |     4 +
 drivers/net/wwan/t7xx/t7xx_port_trace.c            |   116 +
 drivers/net/wwan/t7xx/t7xx_port_wwan.c             |    16 +-
 drivers/net/wwan/wwan_core.c                       |     6 +-
 drivers/net/xen-netfront.c                         |     8 +-
 drivers/nfc/microread/i2c.c                        |     5 +-
 drivers/nfc/nfcmrvl/i2c.c                          |     5 +-
 drivers/nfc/nxp-nci/i2c.c                          |     5 +-
 drivers/nfc/pn533/i2c.c                            |     5 +-
 drivers/nfc/pn544/i2c.c                            |     5 +-
 drivers/nfc/s3fwrn5/i2c.c                          |    24 +-
 drivers/nfc/st-nci/i2c.c                           |     5 +-
 drivers/nfc/st21nfca/i2c.c                         |     5 +-
 drivers/nfc/virtual_ncidev.c                       |   147 +-
 drivers/ptp/ptp_clock.c                            |     5 +-
 drivers/ptp/ptp_dte.c                              |     5 +-
 drivers/ptp/ptp_idt82p33.c                         |   709 +-
 drivers/ptp/ptp_idt82p33.h                         |    21 +-
 drivers/ptp/ptp_kvm_common.c                       |     4 +-
 drivers/ptp/ptp_ocp.c                              |   567 +-
 drivers/ptp/ptp_pch.c                              |    19 +-
 drivers/ptp/ptp_vmw.c                              |     4 +-
 drivers/s390/net/ctcm_main.c                       |    11 +-
 drivers/s390/net/lcs.c                             |     8 +-
 drivers/s390/net/netiucv.c                         |     9 +-
 drivers/staging/vt6655/device_main.c               |     1 +
 drivers/staging/vt6656/main_usb.c                  |     1 +
 drivers/usb/core/message.c                         |     1 +
 drivers/usb/core/usb.h                             |     1 -
 include/linux/avf/virtchnl.h                       |    14 +-
 include/linux/bcma/bcma_driver_chipcommon.h        |     2 +-
 include/linux/bpf.h                                |   357 +-
 include/linux/bpf_local_storage.h                  |    17 +-
 include/linux/bpf_lsm.h                            |     6 +
 include/linux/bpf_types.h                          |     1 +
 include/linux/bpf_verifier.h                       |    66 +-
 include/linux/btf.h                                |   150 +-
 include/linux/btf_ids.h                            |     4 +-
 include/linux/cgroup-defs.h                        |     4 +
 include/linux/compiler_types.h                     |     3 +-
 include/linux/cpuhotplug.h                         |     1 +
 include/linux/dsa/8021q.h                          |    31 +-
 include/linux/ethtool.h                            |    25 +-
 include/linux/filter.h                             |    20 +-
 include/linux/i2c.h                                |     1 +
 include/linux/ieee80211.h                          |    84 +-
 include/linux/ieee802154.h                         |    24 +
 include/linux/if_bridge.h                          |     1 +
 include/linux/if_vlan.h                            |     9 +-
 include/linux/jump_label.h                         |    21 +-
 include/linux/mdio.h                               |    13 +
 include/linux/mlx5/device.h                        |    13 +-
 include/linux/mlx5/driver.h                        |     2 -
 include/linux/mlx5/fs.h                            |    12 +
 include/linux/mlx5/mlx5_ifc.h                      |   127 +-
 include/linux/mlx5/vport.h                         |     2 +
 include/linux/module.h                             |     9 +
 include/linux/mv643xx_eth.h                        |     2 +
 include/linux/net.h                                |     1 +
 include/linux/netdevice.h                          |   103 +-
 include/linux/netfilter/ipset/ip_set.h             |    10 +
 include/linux/netlink.h                            |    29 +-
 include/linux/of_net.h                             |     6 +
 include/linux/phy.h                                |     7 +
 include/linux/phylink.h                            |    32 +
 include/linux/proc_fs.h                            |     2 +
 include/linux/ptp_clock_kernel.h                   |    60 +-
 include/linux/rcupdate.h                           |    12 +
 include/linux/rhashtable.h                         |    61 +-
 include/linux/rtnetlink.h                          |     9 +-
 include/linux/sctp.h                               |     5 +
 include/linux/sfp.h                                |   189 +-
 include/linux/skbuff.h                             |    26 +-
 include/linux/skmsg.h                              |     1 +
 include/linux/smc911x.h                            |    14 -
 include/linux/soc/mediatek/mtk_wed.h               |   121 +-
 include/linux/socket.h                             |     5 +-
 include/linux/stmmac.h                             |     1 +
 include/linux/tcp.h                                |     1 +
 include/linux/udp.h                                |     8 +-
 include/linux/usb.h                                |     1 +
 include/linux/virtio_net.h                         |     9 +
 include/linux/wl12xx.h                             |    44 -
 include/linux/wwan.h                               |     2 +
 include/net/act_api.h                              |    11 +-
 include/net/af_rxrpc.h                             |     2 +-
 include/net/bluetooth/hci.h                        |    21 +
 include/net/bluetooth/hci_core.h                   |     8 +-
 include/net/bond_alb.h                             |     4 +-
 include/net/bonding.h                              |     4 -
 include/net/cfg80211-wext.h                        |    20 +-
 include/net/cfg80211.h                             |    15 +-
 include/net/cfg802154.h                            |    38 +-
 include/net/dcbnl.h                                |     4 +
 include/net/devlink.h                              |   118 +-
 include/net/dropreason.h                           |    14 +
 include/net/dsa.h                                  |    76 +-
 include/net/dst.h                                  |     5 +-
 include/net/dst_metadata.h                         |     1 +
 include/net/flow_offload.h                         |     8 +
 include/net/fq_impl.h                              |    16 +-
 include/net/genetlink.h                            |    79 +-
 include/net/geneve.h                               |     2 +-
 include/net/ieee802154_netdev.h                    |     8 +
 include/net/inet_frag.h                            |     6 +-
 include/net/ip_vs.h                                |   171 +-
 include/net/ipv6.h                                 |    33 +
 include/net/ipv6_frag.h                            |     3 +-
 include/net/mac80211.h                             |    78 +-
 include/net/mac802154.h                            |    31 -
 .../ethernet/microsoft => include/net}/mana/gdma.h |   159 +-
 .../microsoft => include/net}/mana/hw_channel.h    |     0
 .../ethernet/microsoft => include/net}/mana/mana.h |    22 +-
 include/net/mana/mana_auxiliary.h                  |    10 +
 .../microsoft => include/net}/mana/shm_channel.h   |     0
 include/net/mptcp.h                                |    12 +-
 include/net/mrp.h                                  |     1 +
 include/net/net_namespace.h                        |    30 +-
 include/net/netfilter/nf_conntrack_core.h          |     3 +-
 include/net/netfilter/nf_conntrack_helper.h        |     5 +
 include/net/netfilter/nf_nat.h                     |     4 +
 include/net/netfilter/nf_tables.h                  |    15 +-
 include/net/netfilter/nf_tables_core.h             |    36 +-
 include/net/netfilter/nf_tables_ipv4.h             |     4 +
 include/net/netfilter/nf_tables_ipv6.h             |     6 +-
 include/net/netfilter/nft_fib.h                    |     2 +-
 include/net/netfilter/nft_meta.h                   |    10 +-
 include/net/netfilter/nft_reject.h                 |     3 +-
 include/net/netlink.h                              |    32 +
 include/net/netns/ipv4.h                           |     8 +
 include/net/netns/sctp.h                           |     4 +
 include/net/netns/xdp.h                            |     2 +-
 include/net/nl802154.h                             |    43 +
 include/net/rtnetlink.h                            |     5 +-
 include/net/sctp/checksum.h                        |     2 +-
 include/net/sctp/sctp.h                            |    11 +-
 include/net/sctp/stream_sched.h                    |     2 -
 include/net/sctp/structs.h                         |     9 +-
 include/net/sctp/ulpqueue.h                        |     3 +-
 include/net/sock.h                                 |     8 +-
 include/net/sock_reuseport.h                       |     2 +
 include/net/switchdev.h                            |     1 +
 include/net/tc_act/tc_ct.h                         |     1 +
 include/net/tc_act/tc_skbedit.h                    |    29 +
 include/net/tc_wrapper.h                           |   251 +
 include/net/tcp.h                                  |    42 +-
 include/net/transp_v6.h                            |     2 -
 include/net/tso.h                                  |     8 +-
 include/net/udp.h                                  |     9 +
 include/net/udp_tunnel.h                           |     4 +-
 include/net/xfrm.h                                 |   149 +-
 include/soc/mscc/ocelot.h                          |   216 -
 include/trace/events/rxrpc.h                       |   821 +-
 include/trace/events/skb.h                         |     2 +-
 include/uapi/linux/bpf.h                           |   524 +-
 include/uapi/linux/dcbnl.h                         |     8 +
 include/uapi/linux/devlink.h                       |    18 +
 include/uapi/linux/ethtool.h                       |    18 +-
 include/uapi/linux/ethtool_netlink.h               |    15 +
 include/uapi/linux/if_bridge.h                     |    21 +
 include/uapi/linux/if_link.h                       |     3 +
 include/uapi/linux/if_packet.h                     |     1 +
 include/uapi/linux/if_tun.h                        |     2 +
 include/uapi/linux/mptcp.h                         |     9 +
 include/uapi/linux/neighbour.h                     |     8 +-
 include/uapi/linux/net_tstamp.h                    |     3 +-
 include/uapi/linux/netfilter/ipset/ip_set.h        |     2 +
 include/uapi/linux/netfilter/nf_conntrack_sctp.h   |     1 +
 include/uapi/linux/netfilter/nf_tables.h           |    29 +
 include/uapi/linux/netfilter/nfnetlink_cttimeout.h |     1 +
 include/uapi/linux/nl80211.h                       |     3 +
 include/uapi/linux/openvswitch.h                   |    14 +
 include/uapi/linux/snmp.h                          |     1 +
 include/uapi/linux/tc_act/tc_ct.h                  |     3 +
 include/uapi/linux/tcp.h                           |     6 +
 include/uapi/linux/virtio_bt.h                     |     8 +
 include/uapi/linux/virtio_net.h                    |     4 +
 include/uapi/linux/xfrm.h                          |     6 +
 kernel/bpf/Makefile                                |     2 +-
 kernel/bpf/arraymap.c                              |    29 +-
 kernel/bpf/bpf_cgrp_storage.c                      |   246 +
 kernel/bpf/bpf_inode_storage.c                     |    42 +-
 kernel/bpf/bpf_local_storage.c                     |   206 +-
 kernel/bpf/bpf_lsm.c                               |    22 +-
 kernel/bpf/bpf_task_storage.c                      |   161 +-
 kernel/bpf/btf.c                                   |  1308 +-
 kernel/bpf/cgroup_iter.c                           |    16 +-
 kernel/bpf/core.c                                  |    24 +-
 kernel/bpf/cpumap.c                                |    33 +-
 kernel/bpf/devmap.c                                |     4 +-
 kernel/bpf/hashtab.c                               |    37 +-
 kernel/bpf/helpers.c                               |   439 +-
 kernel/bpf/local_storage.c                         |     2 +-
 kernel/bpf/map_in_map.c                            |    61 +-
 kernel/bpf/memalloc.c                              |    46 +-
 kernel/bpf/ringbuf.c                               |     6 +-
 kernel/bpf/syscall.c                               |   469 +-
 kernel/bpf/trampoline.c                            |    80 +-
 kernel/bpf/verifier.c                              |  2753 ++-
 kernel/cgroup/cgroup.c                             |     1 +
 kernel/jump_label.c                                |    58 +-
 kernel/module/kallsyms.c                           |     2 -
 kernel/rcu/tasks.h                                 |     2 +
 kernel/trace/bpf_trace.c                           |   113 +-
 kernel/trace/ftrace.c                              |    16 +-
 lib/Kconfig                                        |     1 +
 lib/net_utils.c                                    |     3 +-
 lib/nlattr.c                                       |     2 +-
 lib/packing.c                                      |    16 +-
 lib/rhashtable.c                                   |    16 +-
 lib/test_bpf.c                                     |     1 -
 lib/test_rhashtable.c                              |     6 +-
 net/802/mrp.c                                      |    18 +-
 net/8021q/vlan_dev.c                               |     4 +-
 net/ax25/af_ax25.c                                 |     4 +-
 net/batman-adv/netlink.c                           |     6 +-
 net/bluetooth/Kconfig                              |    11 +
 net/bluetooth/hci_conn.c                           |    17 +-
 net/bluetooth/hci_core.c                           |     4 +-
 net/bluetooth/hci_debugfs.c                        |     2 +-
 net/bluetooth/hci_event.c                          |    24 +-
 net/bluetooth/hci_sync.c                           |    21 +-
 net/bluetooth/iso.c                                |    67 +-
 net/bluetooth/l2cap_core.c                         |     2 +-
 net/bluetooth/lib.c                                |     4 +-
 net/bluetooth/mgmt.c                               |     2 +-
 net/bluetooth/rfcomm/core.c                        |     2 +-
 net/bpf/bpf_dummy_struct_ops.c                     |    14 +-
 net/bpf/test_run.c                                 |    19 +-
 net/bridge/br.c                                    |     5 +-
 net/bridge/br_fdb.c                                |    46 +-
 net/bridge/br_input.c                              |    21 +-
 net/bridge/br_mdb.c                                |   824 +-
 net/bridge/br_multicast.c                          |    30 +-
 net/bridge/br_netlink.c                            |    21 +-
 net/bridge/br_private.h                            |    30 +-
 net/bridge/br_switchdev.c                          |     6 +-
 net/bridge/br_vlan.c                               |     4 +-
 net/bridge/netfilter/nf_conntrack_bridge.c         |    32 +-
 net/can/af_can.c                                   |     3 +-
 net/can/j1939/transport.c                          |     2 +-
 net/can/raw.c                                      |     1 +
 net/core/bpf_sk_storage.c                          |    42 +-
 net/core/dev.c                                     |   185 +-
 net/core/dev.h                                     |     7 +
 net/core/dev_ioctl.c                               |     2 +-
 net/core/devlink.c                                 |   789 +-
 net/core/drop_monitor.c                            |    12 +-
 net/core/dst.c                                     |     8 +-
 net/core/failover.c                                |     6 +-
 net/core/filter.c                                  |   141 +-
 net/core/flow_dissector.c                          |     4 +-
 net/core/flow_offload.c                            |     7 +
 net/core/gen_stats.c                               |    16 +-
 net/core/gro.c                                     |    74 +-
 net/core/link_watch.c                              |    20 +-
 net/core/net-sysfs.c                               |     4 +-
 net/core/net_namespace.c                           |     5 +
 net/core/of_net.c                                  |     5 +-
 net/core/rtnetlink.c                               |    90 +-
 net/core/skbuff.c                                  |   165 +-
 net/core/skmsg.c                                   |     9 +-
 net/core/sock.c                                    |    29 +-
 net/core/sock_diag.c                               |    15 +-
 net/core/sock_map.c                                |     2 +
 net/core/sock_reuseport.c                          |    94 +-
 net/core/tso.c                                     |     8 -
 net/core/utils.c                                   |     4 +-
 net/dcb/dcbnl.c                                    |   153 +-
 net/dccp/dccp.h                                    |     1 +
 net/dccp/ipv6.c                                    |    15 +-
 net/dccp/proto.c                                   |     8 +-
 net/dsa/Kconfig                                    |     6 +
 net/dsa/Makefile                                   |     4 +-
 net/dsa/devlink.c                                  |   391 +
 net/dsa/devlink.h                                  |    16 +
 net/dsa/dsa.c                                      |  1745 +-
 net/dsa/dsa.h                                      |    40 +
 net/dsa/dsa2.c                                     |  1829 --
 net/dsa/dsa_priv.h                                 |   588 -
 net/dsa/master.c                                   |    25 +-
 net/dsa/master.h                                   |    19 +
 net/dsa/netlink.c                                  |     3 +-
 net/dsa/netlink.h                                  |     8 +
 net/dsa/port.c                                     |    24 +-
 net/dsa/port.h                                     |   114 +
 net/dsa/slave.c                                    |    75 +-
 net/dsa/slave.h                                    |    69 +
 net/dsa/switch.c                                   |    53 +-
 net/dsa/switch.h                                   |   120 +
 net/dsa/tag.c                                      |   243 +
 net/dsa/tag.h                                      |   310 +
 net/dsa/tag_8021q.c                                |    30 +-
 net/dsa/tag_8021q.h                                |    27 +
 net/dsa/tag_ar9331.c                               |     8 +-
 net/dsa/tag_brcm.c                                 |    18 +-
 net/dsa/tag_dsa.c                                  |    13 +-
 net/dsa/tag_gswip.c                                |     8 +-
 net/dsa/tag_hellcreek.c                            |     8 +-
 net/dsa/tag_ksz.c                                  |    24 +-
 net/dsa/tag_lan9303.c                              |     8 +-
 net/dsa/tag_mtk.c                                  |    10 +-
 net/dsa/tag_none.c                                 |    30 +
 net/dsa/tag_ocelot.c                               |    14 +-
 net/dsa/tag_ocelot_8021q.c                         |    10 +-
 net/dsa/tag_qca.c                                  |     8 +-
 net/dsa/tag_rtl4_a.c                               |     8 +-
 net/dsa/tag_rtl8_4.c                               |     9 +-
 net/dsa/tag_rzn1_a5psw.c                           |     8 +-
 net/dsa/tag_sja1105.c                              |    15 +-
 net/dsa/tag_trailer.c                              |     8 +-
 net/dsa/tag_xrs700x.c                              |     8 +-
 net/ethernet/eth.c                                 |     2 +-
 net/ethtool/Makefile                               |     2 +-
 net/ethtool/channels.c                             |    19 +-
 net/ethtool/common.c                               |    81 +
 net/ethtool/common.h                               |     1 +
 net/ethtool/ioctl.c                                |    44 +-
 net/ethtool/linkstate.c                            |    24 +-
 net/ethtool/netlink.c                              |     7 +
 net/ethtool/netlink.h                              |     2 +
 net/ethtool/rss.c                                  |   153 +
 net/hsr/hsr_debugfs.c                              |    40 +-
 net/hsr/hsr_device.c                               |    31 +-
 net/hsr/hsr_forward.c                              |    14 +-
 net/hsr/hsr_framereg.c                             |   265 +-
 net/hsr/hsr_framereg.h                             |    17 +-
 net/hsr/hsr_main.h                                 |    15 +-
 net/hsr/hsr_netlink.c                              |     4 +-
 net/ieee802154/core.c                              |     3 +
 net/ieee802154/nl802154.c                          |   109 +-
 net/ieee802154/nl802154.h                          |     2 +
 net/ipv4/Makefile                                  |     2 +-
 net/ipv4/af_inet.c                                 |     8 +-
 net/ipv4/bpf_tcp_ca.c                              |    17 +-
 net/ipv4/inet_connection_sock.c                    |     7 +-
 net/ipv4/inet_fragment.c                           |    14 +-
 net/ipv4/ip_fragment.c                             |    19 +-
 net/ipv4/ip_gre.c                                  |    12 +-
 net/ipv4/ip_sockglue.c                             |     3 +-
 net/ipv4/ip_tunnel.c                               |    32 +-
 net/ipv4/ip_vti.c                                  |    20 +-
 net/ipv4/ipip.c                                    |     2 +-
 net/ipv4/ipmr.c                                    |    12 +-
 net/ipv4/metrics.c                                 |     3 -
 net/ipv4/netfilter/nft_dup_ipv4.c                  |     3 +-
 net/ipv4/netfilter/nft_fib_ipv4.c                  |     5 +-
 net/ipv4/ping.c                                    |     2 +-
 net/ipv4/proc.c                                    |     1 +
 net/ipv4/syncookies.c                              |     7 +-
 net/ipv4/sysctl_net_ipv4.c                         |    83 +
 net/ipv4/tcp.c                                     |    10 +-
 net/ipv4/tcp_bpf.c                                 |    19 +-
 net/ipv4/tcp_dctcp.c                               |    23 +-
 net/ipv4/tcp_input.c                               |    67 +-
 net/ipv4/tcp_ipv4.c                                |   105 +-
 net/ipv4/tcp_minisocks.c                           |    61 +-
 net/ipv4/tcp_output.c                              |    41 +-
 net/ipv4/tcp_plb.c                                 |   109 +
 net/ipv4/udp.c                                     |   217 +-
 net/ipv4/udp_diag.c                                |     6 +-
 net/ipv4/udp_offload.c                             |     8 +-
 net/ipv4/udp_tunnel_core.c                         |     1 +
 net/ipv4/udp_tunnel_nic.c                          |     2 +
 net/ipv6/addrconf.c                                |     4 +-
 net/ipv6/af_inet6.c                                |    13 +-
 net/ipv6/datagram.c                                |    18 +-
 net/ipv6/esp6_offload.c                            |     3 +-
 net/ipv6/ip6_fib.c                                 |     7 +-
 net/ipv6/ip6_gre.c                                 |    31 +-
 net/ipv6/ip6_offload.c                             |    27 +-
 net/ipv6/ip6_tunnel.c                              |    26 +-
 net/ipv6/ip6_vti.c                                 |    16 +-
 net/ipv6/ip6mr.c                                   |    10 +-
 net/ipv6/ipv6_sockglue.c                           |     6 +-
 net/ipv6/netfilter/nf_conntrack_reasm.c            |     2 +-
 net/ipv6/netfilter/nft_dup_ipv6.c                  |     3 +-
 net/ipv6/ping.c                                    |     6 -
 net/ipv6/raw.c                                     |     2 -
 net/ipv6/reassembly.c                              |    13 +-
 net/ipv6/seg6_local.c                              |     4 +-
 net/ipv6/sit.c                                     |    22 +-
 net/ipv6/tcp_ipv6.c                                |    29 +-
 net/ipv6/udp.c                                     |    41 +-
 net/ipv6/udp_offload.c                             |     8 +-
 net/key/af_key.c                                   |     6 +-
 net/l2tp/l2tp_ip6.c                                |     2 -
 net/mac80211/agg-rx.c                              |    25 +-
 net/mac80211/agg-tx.c                              |     2 +-
 net/mac80211/cfg.c                                 |    45 +-
 net/mac80211/debugfs.c                             |     4 +-
 net/mac80211/debugfs_netdev.c                      |     3 +-
 net/mac80211/debugfs_sta.c                         |   148 +-
 net/mac80211/debugfs_sta.h                         |    12 +
 net/mac80211/driver-ops.c                          |    27 +-
 net/mac80211/driver-ops.h                          |    16 +
 net/mac80211/ieee80211_i.h                         |    22 +-
 net/mac80211/iface.c                               |    74 +-
 net/mac80211/link.c                                |    17 +
 net/mac80211/main.c                                |    23 +-
 net/mac80211/mlme.c                                |   133 +-
 net/mac80211/rc80211_minstrel_ht.c                 |     3 -
 net/mac80211/rc80211_minstrel_ht.h                 |     1 -
 net/mac80211/rx.c                                  |    41 +-
 net/mac80211/sta_info.c                            |   118 +-
 net/mac80211/sta_info.h                            |     7 +
 net/mac80211/tdls.c                                |     1 -
 net/mac80211/tx.c                                  |   327 +-
 net/mac80211/util.c                                |   246 +-
 net/mac80211/wme.c                                 |    63 +-
 net/mac80211/wme.h                                 |     4 +-
 net/mac802154/cfg.c                                |     6 +-
 net/mac802154/driver-ops.h                         |   253 +-
 net/mac802154/ieee802154_i.h                       |    56 +-
 net/mac802154/iface.c                              |    59 +-
 net/mac802154/main.c                               |     4 +-
 net/mac802154/rx.c                                 |    53 +-
 net/mac802154/trace.h                              |    25 +
 net/mac802154/tx.c                                 |   132 +-
 net/mac802154/util.c                               |    71 +-
 net/mpls/af_mpls.c                                 |     4 +-
 net/mptcp/Makefile                                 |     2 +-
 net/mptcp/fastopen.c                               |    73 +
 net/mptcp/options.c                                |    25 +-
 net/mptcp/pm_netlink.c                             |   126 +-
 net/mptcp/pm_userspace.c                           |     8 +-
 net/mptcp/protocol.c                               |    87 +-
 net/mptcp/protocol.h                               |    30 +-
 net/mptcp/sockopt.c                                |    45 +-
 net/mptcp/subflow.c                                |   168 +-
 net/mptcp/token.c                                  |     4 +-
 net/ncsi/ncsi-cmd.c                                |     3 +-
 net/netfilter/Kconfig                              |     9 +-
 net/netfilter/Makefile                             |     5 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |    71 +-
 net/netfilter/ipset/ip_set_hash_ip.c               |    19 +-
 net/netfilter/ipset/ip_set_hash_ipport.c           |    24 +-
 net/netfilter/ipset/ip_set_hash_netnet.c           |    26 +-
 net/netfilter/ipvs/ip_vs_core.c                    |    40 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   452 +-
 net/netfilter/ipvs/ip_vs_est.c                     |   883 +-
 net/netfilter/nf_conntrack_bpf.c                   |    17 +-
 net/netfilter/nf_conntrack_core.c                  |    30 +-
 net/netfilter/nf_conntrack_helper.c                |   100 +
 net/netfilter/nf_conntrack_proto.c                 |   124 +-
 net/netfilter/nf_conntrack_proto_icmpv6.c          |    53 +
 net/netfilter/nf_conntrack_proto_sctp.c            |   104 +-
 net/netfilter/nf_conntrack_standalone.c            |     8 +
 net/netfilter/nf_flow_table_ip.c                   |     8 +
 net/netfilter/nf_nat_ovs.c                         |   135 +
 net/netfilter/nf_tables_api.c                      |    90 +-
 net/netfilter/nf_tables_core.c                     |     2 +
 net/netfilter/nft_bitwise.c                        |     6 +-
 net/netfilter/nft_byteorder.c                      |     3 +-
 net/netfilter/nft_cmp.c                            |     9 +-
 net/netfilter/nft_compat.c                         |     9 +-
 net/netfilter/nft_connlimit.c                      |     3 +-
 net/netfilter/nft_counter.c                        |     5 +-
 net/netfilter/nft_ct.c                             |     6 +-
 net/netfilter/nft_dup_netdev.c                     |     3 +-
 net/netfilter/nft_dynset.c                         |     7 +-
 net/netfilter/nft_exthdr.c                         |    10 +-
 net/netfilter/nft_fib.c                            |     2 +-
 net/netfilter/nft_flow_offload.c                   |     3 +-
 net/netfilter/nft_fwd_netdev.c                     |     6 +-
 net/netfilter/nft_hash.c                           |     4 +-
 net/netfilter/nft_immediate.c                      |     3 +-
 net/netfilter/nft_inner.c                          |   385 +
 net/netfilter/nft_last.c                           |     3 +-
 net/netfilter/nft_limit.c                          |     5 +-
 net/netfilter/nft_log.c                            |     3 +-
 net/netfilter/nft_lookup.c                         |     3 +-
 net/netfilter/nft_masq.c                           |     3 +-
 net/netfilter/nft_meta.c                           |    67 +-
 net/netfilter/nft_nat.c                            |     3 +-
 net/netfilter/nft_numgen.c                         |     6 +-
 net/netfilter/nft_objref.c                         |    28 +-
 net/netfilter/nft_osf.c                            |     3 +-
 net/netfilter/nft_payload.c                        |   141 +-
 net/netfilter/nft_queue.c                          |     6 +-
 net/netfilter/nft_quota.c                          |     5 +-
 net/netfilter/nft_range.c                          |     3 +-
 net/netfilter/nft_redir.c                          |     3 +-
 net/netfilter/nft_reject.c                         |     3 +-
 net/netfilter/nft_rt.c                             |     2 +-
 net/netfilter/nft_socket.c                         |     2 +-
 net/netfilter/nft_synproxy.c                       |     3 +-
 net/netfilter/nft_tproxy.c                         |     2 +-
 net/netfilter/nft_tunnel.c                         |     2 +-
 net/netfilter/nft_xfrm.c                           |     2 +-
 net/netfilter/xt_sctp.c                            |     1 -
 net/netlink/af_netlink.c                           |    42 +-
 net/netlink/genetlink.c                            |   495 +-
 net/nfc/nci/core.c                                 |     8 +-
 net/nfc/nci/hci.c                                  |     4 +-
 net/nfc/rawsock.c                                  |     3 +
 net/openvswitch/Kconfig                            |     1 +
 net/openvswitch/conntrack.c                        |   251 +-
 net/openvswitch/datapath.c                         |    45 +-
 net/openvswitch/flow_netlink.c                     |     2 +-
 net/openvswitch/flow_table.c                       |     9 +-
 net/openvswitch/vport-geneve.c                     |     2 +-
 net/openvswitch/vport-gre.c                        |     2 +-
 net/openvswitch/vport-netdev.c                     |     2 +-
 net/openvswitch/vport-vxlan.c                      |     2 +-
 net/openvswitch/vport.c                            |    50 +
 net/openvswitch/vport.h                            |    16 +
 net/packet/af_packet.c                             |    11 +-
 net/rds/message.c                                  |     2 -
 net/rds/send.c                                     |     3 +-
 net/rds/tcp.c                                      |     3 +
 net/rxrpc/Kconfig                                  |     7 +
 net/rxrpc/Makefile                                 |     5 +
 net/rxrpc/af_rxrpc.c                               |    32 +-
 net/rxrpc/ar-internal.h                            |   415 +-
 net/rxrpc/call_accept.c                            |   195 +-
 net/rxrpc/call_event.c                             |   569 +-
 net/rxrpc/call_object.c                            |   361 +-
 net/rxrpc/conn_client.c                            |   146 +-
 net/rxrpc/conn_event.c                             |   128 +-
 net/rxrpc/conn_object.c                            |   313 +-
 net/rxrpc/conn_service.c                           |    29 +-
 net/rxrpc/input.c                                  |  1223 +-
 net/rxrpc/insecure.c                               |    16 +-
 net/rxrpc/io_thread.c                              |   496 +
 net/rxrpc/key.c                                    |    16 +-
 net/rxrpc/local_event.c                            |    46 +-
 net/rxrpc/local_object.c                           |   174 +-
 net/rxrpc/misc.c                                   |    23 +-
 net/rxrpc/net_ns.c                                 |     4 +-
 net/rxrpc/output.c                                 |   525 +-
 net/rxrpc/peer_event.c                             |   425 +-
 net/rxrpc/peer_object.c                            |    59 +-
 net/rxrpc/proc.c                                   |   169 +-
 net/rxrpc/protocol.h                               |     9 +-
 net/rxrpc/recvmsg.c                                |   308 +-
 net/rxrpc/rxkad.c                                  |   314 +-
 net/rxrpc/rxperf.c                                 |   619 +
 net/rxrpc/security.c                               |    34 +-
 net/rxrpc/sendmsg.c                                |   233 +-
 net/rxrpc/server_key.c                             |    25 +
 net/rxrpc/skbuff.c                                 |    44 +-
 net/rxrpc/sysctl.c                                 |    11 +-
 net/rxrpc/txbuf.c                                  |   142 +
 net/sched/Kconfig                                  |     1 +
 net/sched/act_api.c                                |     3 +-
 net/sched/act_bpf.c                                |     6 +-
 net/sched/act_connmark.c                           |     6 +-
 net/sched/act_csum.c                               |     6 +-
 net/sched/act_ct.c                                 |   257 +-
 net/sched/act_ctinfo.c                             |     6 +-
 net/sched/act_gact.c                               |     6 +-
 net/sched/act_gate.c                               |     6 +-
 net/sched/act_ife.c                                |     6 +-
 net/sched/act_ipt.c                                |     6 +-
 net/sched/act_mirred.c                             |     6 +-
 net/sched/act_mpls.c                               |     6 +-
 net/sched/act_nat.c                                |     7 +-
 net/sched/act_pedit.c                              |     6 +-
 net/sched/act_police.c                             |     6 +-
 net/sched/act_sample.c                             |     6 +-
 net/sched/act_simple.c                             |     6 +-
 net/sched/act_skbedit.c                            |    20 +-
 net/sched/act_skbmod.c                             |     6 +-
 net/sched/act_tunnel_key.c                         |     6 +-
 net/sched/act_vlan.c                               |     6 +-
 net/sched/cls_api.c                                |    10 +-
 net/sched/cls_basic.c                              |     6 +-
 net/sched/cls_bpf.c                                |     6 +-
 net/sched/cls_cgroup.c                             |     6 +-
 net/sched/cls_flow.c                               |     6 +-
 net/sched/cls_flower.c                             |     6 +-
 net/sched/cls_fw.c                                 |     6 +-
 net/sched/cls_matchall.c                           |     6 +-
 net/sched/cls_route.c                              |     6 +-
 net/sched/cls_rsvp.c                               |     2 +
 net/sched/cls_rsvp.h                               |     6 +-
 net/sched/cls_rsvp6.c                              |     2 +
 net/sched/cls_tcindex.c                            |     7 +-
 net/sched/cls_u32.c                                |     6 +-
 net/sched/sch_api.c                                |     5 +
 net/sctp/associola.c                               |     4 +-
 net/sctp/diag.c                                    |     3 +-
 net/sctp/endpointola.c                             |    13 +-
 net/sctp/input.c                                   |   108 +-
 net/sctp/ipv6.c                                    |    22 +-
 net/sctp/protocol.c                                |    19 +-
 net/sctp/sm_statefuns.c                            |     2 +-
 net/sctp/socket.c                                  |    38 +-
 net/sctp/stream_interleave.c                       |    12 +-
 net/sctp/stream_sched.c                            |    38 +-
 net/sctp/stream_sched_prio.c                       |    27 -
 net/sctp/stream_sched_rr.c                         |     6 -
 net/sctp/sysctl.c                                  |    84 +-
 net/sctp/ulpqueue.c                                |    10 +-
 net/socket.c                                       |     8 +-
 net/tls/tls_sw.c                                   |     6 +-
 net/unix/af_unix.c                                 |     1 +
 net/vmw_vsock/vmci_transport.c                     |     6 +-
 net/wireless/core.h                                |     5 +-
 net/wireless/mlme.c                                |     4 +
 net/wireless/nl80211.c                             |    26 +-
 net/wireless/nl80211.h                             |     3 +-
 net/wireless/reg.c                                 |     4 +-
 net/wireless/scan.c                                |    47 +-
 net/wireless/sme.c                                 |    26 +-
 net/wireless/util.c                                |     4 +-
 net/wireless/wext-compat.c                         |   180 +-
 net/wireless/wext-compat.h                         |     8 +-
 net/wireless/wext-sme.c                            |     5 +-
 net/xdp/xskmap.c                                   |     4 +-
 net/xfrm/Makefile                                  |     8 +
 net/xfrm/xfrm_device.c                             |   109 +-
 net/xfrm/xfrm_input.c                              |     1 +
 net/xfrm/xfrm_interface_bpf.c                      |   115 +
 .../{xfrm_interface.c => xfrm_interface_core.c}    |    14 +
 net/xfrm/xfrm_output.c                             |    15 +-
 net/xfrm/xfrm_policy.c                             |   122 +-
 net/xfrm/xfrm_state.c                              |   212 +-
 net/xfrm/xfrm_user.c                               |   104 +-
 samples/bpf/README.rst                             |     6 +-
 samples/bpf/hbm_edt_kern.c                         |     2 +-
 samples/bpf/sockex3_kern.c                         |    95 +-
 samples/bpf/sockex3_user.c                         |    23 +-
 samples/bpf/test_cgrp2_tc.sh                       |     2 +-
 samples/bpf/tracex2_kern.c                         |     4 +-
 samples/bpf/tracex2_user.c                         |     3 +-
 samples/bpf/xdp1_user.c                            |     2 +-
 samples/bpf/xdp2_kern.c                            |     4 +
 samples/bpf/xdp_router_ipv4_user.c                 |     2 +-
 samples/pktgen/functions.sh                        |     2 +-
 scripts/bpf_doc.py                                 |    49 +-
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |     2 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |    15 +-
 tools/bpf/bpftool/Documentation/common_options.rst |    17 +-
 tools/bpf/bpftool/Documentation/substitutions.rst  |     2 +-
 tools/bpf/bpftool/Makefile                         |    74 +-
 tools/bpf/bpftool/bash-completion/bpftool          |     3 +-
 tools/bpf/bpftool/btf.c                            |    44 +-
 tools/bpf/bpftool/btf_dumper.c                     |     2 +-
 tools/bpf/bpftool/common.c                         |    23 +-
 tools/bpf/bpftool/gen.c                            |    29 +-
 tools/bpf/bpftool/iter.c                           |    12 +-
 tools/bpf/bpftool/jit_disasm.c                     |   261 +-
 tools/bpf/bpftool/link.c                           |    10 +-
 tools/bpf/bpftool/main.c                           |   116 +-
 tools/bpf/bpftool/main.h                           |    49 +-
 tools/bpf/bpftool/map.c                            |    33 +-
 tools/bpf/bpftool/net.c                            |     2 +
 tools/bpf/bpftool/perf.c                           |     2 +
 tools/bpf/bpftool/pids.c                           |    16 +-
 tools/bpf/bpftool/prog.c                           |   124 +-
 tools/bpf/bpftool/struct_ops.c                     |    22 +-
 tools/bpf/bpftool/xlated_dumper.c                  |     2 +
 tools/include/uapi/linux/bpf.h                     |   524 +-
 tools/include/uapi/linux/if_link.h                 |     1 +
 tools/lib/bpf/Makefile                             |    17 +
 tools/lib/bpf/bpf.c                                |    48 +-
 tools/lib/bpf/bpf.h                                |    23 +
 tools/lib/bpf/btf.c                                |   272 +-
 tools/lib/bpf/btf_dump.c                           |    46 +-
 tools/lib/bpf/hashmap.c                            |    18 +-
 tools/lib/bpf/hashmap.h                            |    91 +-
 tools/lib/bpf/libbpf.c                             |   266 +-
 tools/lib/bpf/libbpf.map                           |     6 +-
 tools/lib/bpf/libbpf_probes.c                      |     1 +
 tools/lib/bpf/ringbuf.c                            |     4 +-
 tools/lib/bpf/strset.c                             |    18 +-
 tools/lib/bpf/usdt.c                               |    63 +-
 tools/perf/tests/expr.c                            |    28 +-
 tools/perf/tests/pmu-events.c                      |     6 +-
 tools/perf/util/bpf-loader.c                       |    11 +-
 tools/perf/util/evsel.c                            |     2 +-
 tools/perf/util/expr.c                             |    36 +-
 tools/perf/util/hashmap.c                          |    18 +-
 tools/perf/util/hashmap.h                          |    91 +-
 tools/perf/util/metricgroup.c                      |    10 +-
 tools/perf/util/stat-shadow.c                      |     2 +-
 tools/perf/util/stat.c                             |     9 +-
 tools/testing/selftests/Makefile                   |     1 +
 tools/testing/selftests/bpf/DENYLIST               |     3 +-
 tools/testing/selftests/bpf/DENYLIST.aarch64       |    84 +
 tools/testing/selftests/bpf/DENYLIST.s390x         |    47 +-
 tools/testing/selftests/bpf/Makefile               |    37 +-
 tools/testing/selftests/bpf/README.rst             |    53 +-
 tools/testing/selftests/bpf/bpf_experimental.h     |    68 +
 tools/testing/selftests/bpf/bpf_legacy.h           |    19 +-
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        |    24 +
 tools/testing/selftests/bpf/bpf_util.h             |    19 +
 tools/testing/selftests/bpf/cgroup_helpers.c       |    22 +-
 tools/testing/selftests/bpf/cgroup_helpers.h       |     1 +
 tools/testing/selftests/bpf/config                 |     7 +-
 tools/testing/selftests/bpf/config.aarch64         |   181 +
 tools/testing/selftests/bpf/config.s390x           |     3 -
 tools/testing/selftests/bpf/config.x86_64          |     1 -
 tools/testing/selftests/bpf/network_helpers.c      |    47 +-
 tools/testing/selftests/bpf/prog_tests/align.c     |    38 +-
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |    41 +-
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c    |     6 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       |   278 +-
 .../selftests/bpf/prog_tests/btf_dedup_split.c     |    45 +-
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  |     4 +-
 .../selftests/bpf/prog_tests/btf_skc_cls_ingress.c |    25 +-
 .../testing/selftests/bpf/prog_tests/cgroup_iter.c |    76 +
 .../testing/selftests/bpf/prog_tests/cgrp_kfunc.c  |   175 +
 .../selftests/bpf/prog_tests/cgrp_local_storage.c  |   265 +
 tools/testing/selftests/bpf/prog_tests/dynptr.c    |    80 +-
 tools/testing/selftests/bpf/prog_tests/empty_skb.c |   146 +
 tools/testing/selftests/bpf/prog_tests/hashmap.c   |   190 +-
 .../selftests/bpf/prog_tests/kfunc_dynptr_param.c  |     7 +-
 .../selftests/bpf/prog_tests/kprobe_multi_test.c   |    32 +-
 .../bpf/prog_tests/kprobe_multi_testmod_test.c     |    89 +
 .../bpf/prog_tests/libbpf_get_fd_by_id_opts.c      |    87 +
 .../testing/selftests/bpf/prog_tests/libbpf_str.c  |     8 +
 .../testing/selftests/bpf/prog_tests/linked_list.c |   740 +
 .../testing/selftests/bpf/prog_tests/lsm_cgroup.c  |    17 +-
 tools/testing/selftests/bpf/prog_tests/map_kptr.c  |    83 +-
 .../selftests/bpf/prog_tests/module_attach.c       |     7 +
 .../selftests/bpf/prog_tests/rcu_read_lock.c       |   158 +
 tools/testing/selftests/bpf/prog_tests/ringbuf.c   |    66 +-
 tools/testing/selftests/bpf/prog_tests/skeleton.c  |    11 +-
 tools/testing/selftests/bpf/prog_tests/spin_lock.c |   142 +
 tools/testing/selftests/bpf/prog_tests/spinlock.c  |    45 -
 .../testing/selftests/bpf/prog_tests/task_kfunc.c  |   164 +
 .../selftests/bpf/prog_tests/task_local_storage.c  |   164 +-
 .../testing/selftests/bpf/prog_tests/tc_redirect.c |   314 +-
 .../selftests/bpf/prog_tests/tcp_hdr_options.c     |     6 +-
 .../testing/selftests/bpf/prog_tests/test_tunnel.c |     2 +-
 .../selftests/bpf/prog_tests/tracing_struct.c      |     3 +-
 tools/testing/selftests/bpf/prog_tests/type_cast.c |   114 +
 .../selftests/bpf/prog_tests/user_ringbuf.c        |     6 +-
 .../selftests/bpf/prog_tests/xdp_adjust_tail.c     |     7 +-
 .../selftests/bpf/prog_tests/xdp_synproxy.c        |     6 +-
 tools/testing/selftests/bpf/prog_tests/xfrm_info.c |   362 +
 .../selftests/bpf/progs/bpf_iter_bpf_array_map.c   |    21 +-
 tools/testing/selftests/bpf/progs/bpf_iter_ksym.c  |     6 +-
 tools/testing/selftests/bpf/progs/bpf_misc.h       |     5 +
 .../testing/selftests/bpf/progs/bpf_tracing_net.h  |     3 +
 .../bpf/progs/btf_dump_test_case_padding.c         |     9 +
 .../selftests/bpf/progs/btf_type_tag_percpu.c      |     1 +
 .../selftests/bpf/progs/cgrp_kfunc_common.h        |    72 +
 .../selftests/bpf/progs/cgrp_kfunc_failure.c       |   260 +
 .../selftests/bpf/progs/cgrp_kfunc_success.c       |   170 +
 .../selftests/bpf/progs/cgrp_ls_attach_cgroup.c    |   101 +
 .../testing/selftests/bpf/progs/cgrp_ls_negative.c |    26 +
 .../selftests/bpf/progs/cgrp_ls_recursion.c        |    70 +
 .../selftests/bpf/progs/cgrp_ls_sleepable.c        |    80 +
 tools/testing/selftests/bpf/progs/cgrp_ls_tp_btf.c |    88 +
 tools/testing/selftests/bpf/progs/dynptr_fail.c    |    31 +
 tools/testing/selftests/bpf/progs/dynptr_success.c |     1 +
 tools/testing/selftests/bpf/progs/empty_skb.c      |    37 +
 tools/testing/selftests/bpf/progs/kprobe_multi.c   |    50 +
 tools/testing/selftests/bpf/progs/linked_list.c    |   385 +
 tools/testing/selftests/bpf/progs/linked_list.h    |    56 +
 .../testing/selftests/bpf/progs/linked_list_fail.c |   581 +
 tools/testing/selftests/bpf/progs/lsm_cgroup.c     |     8 +
 tools/testing/selftests/bpf/progs/map_kptr_fail.c  |    27 +
 tools/testing/selftests/bpf/progs/rcu_read_lock.c  |   330 +
 .../selftests/bpf/progs/task_kfunc_common.h        |    72 +
 .../selftests/bpf/progs/task_kfunc_failure.c       |   284 +
 .../selftests/bpf/progs/task_kfunc_success.c       |   227 +
 .../bpf/progs/task_local_storage_exit_creds.c      |     3 +
 .../selftests/bpf/progs/task_ls_recursion.c        |    43 +-
 .../selftests/bpf/progs/task_storage_nodeadlock.c  |    47 +
 .../selftests/bpf/progs/test_kfunc_dynptr_param.c  |    12 -
 .../bpf/progs/test_libbpf_get_fd_by_id_opts.c      |    36 +
 .../bpf/progs/test_misc_tcp_hdr_options.c          |     4 +
 .../selftests/bpf/progs/test_module_attach.c       |     6 +
 .../selftests/bpf/progs/test_ringbuf_map_key.c     |    70 +
 tools/testing/selftests/bpf/progs/test_skeleton.c  |    17 +
 tools/testing/selftests/bpf/progs/test_spin_lock.c |     4 +-
 .../selftests/bpf/progs/test_spin_lock_fail.c      |   204 +
 tools/testing/selftests/bpf/progs/type_cast.c      |    83 +
 .../selftests/bpf/progs/user_ringbuf_fail.c        |    51 +-
 tools/testing/selftests/bpf/progs/xfrm_info.c      |    40 +
 .../selftests/bpf/task_local_storage_helpers.h     |     4 +
 .../testing/selftests/bpf/test_bpftool_metadata.sh |     7 +-
 .../selftests/bpf/test_bpftool_synctypes.py        |    14 +-
 tools/testing/selftests/bpf/test_cpp.cpp           |    13 +-
 tools/testing/selftests/bpf/test_flow_dissector.sh |     6 +-
 tools/testing/selftests/bpf/test_loader.c          |   233 +
 tools/testing/selftests/bpf/test_lwt_ip_encap.sh   |    17 +-
 tools/testing/selftests/bpf/test_lwt_seg6local.sh  |     9 +-
 tools/testing/selftests/bpf/test_offload.py        |     8 +-
 tools/testing/selftests/bpf/test_progs.c           |    38 +-
 tools/testing/selftests/bpf/test_progs.h           |    33 +
 tools/testing/selftests/bpf/test_sockmap.c         |    18 +
 tools/testing/selftests/bpf/test_tc_edt.sh         |     3 +-
 tools/testing/selftests/bpf/test_tc_tunnel.sh      |     5 +-
 tools/testing/selftests/bpf/test_tunnel.sh         |     5 +-
 tools/testing/selftests/bpf/test_verifier.c        |    13 +-
 tools/testing/selftests/bpf/test_xdp_meta.sh       |     9 +-
 tools/testing/selftests/bpf/test_xdp_vlan.sh       |     8 +-
 tools/testing/selftests/bpf/trace_helpers.c        |    20 +-
 tools/testing/selftests/bpf/trace_helpers.h        |     2 +
 tools/testing/selftests/bpf/verifier/calls.c       |    86 +-
 .../selftests/bpf/verifier/direct_packet_access.c  |    54 +
 .../selftests/bpf/verifier/jeq_infer_not_null.c    |   174 +
 tools/testing/selftests/bpf/verifier/jit.c         |    24 +
 tools/testing/selftests/bpf/verifier/map_ptr.c     |     8 +-
 .../testing/selftests/bpf/verifier/ref_tracking.c  |     4 +-
 tools/testing/selftests/bpf/verifier/ringbuf.c     |     2 +-
 tools/testing/selftests/bpf/verifier/spill_fill.c  |     2 +-
 tools/testing/selftests/bpf/verifier/spin_lock.c   |   114 +
 .../testing/selftests/bpf/verifier/value_or_null.c |    49 +
 tools/testing/selftests/bpf/veristat.c             |   918 +-
 tools/testing/selftests/bpf/vmtest.sh              |     6 +
 tools/testing/selftests/bpf/xdp_synproxy.c         |     5 +-
 tools/testing/selftests/bpf/xsk.c                  |    26 +-
 tools/testing/selftests/bpf/xskxceiver.c           |     3 +-
 .../testing/selftests/drivers/net/bonding/Makefile |     4 +-
 .../selftests/drivers/net/bonding/lag_lib.sh       |   106 +
 .../drivers/net/bonding/mode-1-recovery-updelay.sh |    45 +
 .../drivers/net/bonding/mode-2-recovery-updelay.sh |    45 +
 .../testing/selftests/drivers/net/bonding/settings |     2 +-
 .../drivers/net/mlxsw/devlink_trap_control.sh      |    22 +
 .../drivers/net/mlxsw/devlink_trap_l2_drops.sh     |   105 +
 .../{spectrum-2 => }/devlink_trap_tunnel_ipip6.sh  |     2 +-
 .../selftests/drivers/net/mlxsw/rtnetlink.sh       |    31 +
 tools/testing/selftests/nci/nci_dev.c              |    11 +
 tools/testing/selftests/net/.gitignore             |     2 +
 tools/testing/selftests/net/Makefile               |     4 +
 tools/testing/selftests/net/bpf/Makefile           |    45 +-
 tools/testing/selftests/net/csum.c                 |   986 +
 tools/testing/selftests/net/forwarding/Makefile    |     1 +
 .../selftests/net/forwarding/bridge_igmp.sh        |     3 -
 .../selftests/net/forwarding/bridge_locked_port.sh |   155 +-
 .../testing/selftests/net/forwarding/bridge_mdb.sh |  1127 +-
 .../selftests/net/forwarding/bridge_mdb_host.sh    |   103 +
 .../selftests/net/forwarding/bridge_vlan_mcast.sh  |     3 +
 .../selftests/net/forwarding/devlink_lib.sh        |    19 +-
 tools/testing/selftests/net/forwarding/lib.sh      |     8 +
 tools/testing/selftests/net/hsr/Makefile           |     7 +
 tools/testing/selftests/net/hsr/config             |     4 +
 tools/testing/selftests/net/hsr/hsr_ping.sh        |   256 +
 tools/testing/selftests/net/mptcp/diag.sh          |     1 +
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |   171 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |    27 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |   118 +-
 tools/testing/selftests/net/mptcp/mptcp_sockopt.sh |    69 +-
 tools/testing/selftests/net/mptcp/simult_flows.sh  |     8 +-
 tools/testing/selftests/net/mptcp/userspace_pm.sh  |   298 +-
 tools/testing/selftests/net/sctp_hello.c           |   137 +
 tools/testing/selftests/net/sctp_vrf.sh            |   178 +
 tools/testing/selftests/net/so_incoming_cpu.c      |   242 +
 .../selftests/netfilter/conntrack_icmp_related.sh  |    36 +-
 tools/testing/selftests/tc-testing/tdc.py          |   125 +-
 2015 files changed, 165996 insertions(+), 34404 deletions(-)
 create mode 100644 Documentation/bpf/bpf_iterators.rst
 create mode 100644 Documentation/bpf/libbpf/program_types.rst
 create mode 100644 Documentation/bpf/map_array.rst
 create mode 100644 Documentation/bpf/map_bloom_filter.rst
 create mode 100644 Documentation/bpf/map_cgrp_storage.rst
 create mode 100644 Documentation/bpf/map_cpumap.rst
 create mode 100644 Documentation/bpf/map_devmap.rst
 create mode 100644 Documentation/bpf/map_lpm_trie.rst
 create mode 100644 Documentation/bpf/map_of_maps.rst
 create mode 100644 Documentation/bpf/map_queue_stack.rst
 create mode 100644 Documentation/bpf/map_sk_storage.rst
 create mode 100644 Documentation/bpf/map_xskmap.rst
 create mode 100644 Documentation/bpf/redirect.rst
 delete mode 100644 Documentation/devicetree/bindings/net/bluetooth.txt
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/bluetooth-controller.yaml
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/brcm,bcm4377-bluetooth.yaml
 rename Documentation/devicetree/bindings/net/{ => bluetooth}/qualcomm-bluetooth.yaml (96%)
 create mode 100644 Documentation/devicetree/bindings/net/marvell,dfx-server.yaml
 create mode 100644 Documentation/devicetree/bindings/net/marvell,pp2.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/marvell,prestera.txt
 create mode 100644 Documentation/devicetree/bindings/net/marvell,prestera.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/marvell-pp2.txt
 create mode 100644 Documentation/devicetree/bindings/net/pcs/fsl,lynx-pcs.yaml
 create mode 100644 Documentation/devicetree/bindings/net/renesas,r8a779f0-ether-switch.yaml
 create mode 100644 Documentation/devicetree/bindings/net/socionext,synquacer-netsec.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/socionext-netsec.txt
 create mode 100644 Documentation/devicetree/bindings/soc/mediatek/mediatek,mt7986-wo-ccif.yaml
 create mode 100644 Documentation/networking/devlink/etas_es58x.rst
 create mode 100644 Documentation/networking/tc-queue-filters.rst
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
 create mode 100644 drivers/bluetooth/hci_bcm4377.c
 delete mode 100644 drivers/net/can/pch_can.c
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_devlink.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/trace.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/trace.h
 delete mode 100644 drivers/net/ethernet/fealnx.c
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c
 create mode 100644 drivers/net/ethernet/intel/e1000e/e1000e_trace.h
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_mcu.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_wo.c
 create mode 100644 drivers/net/ethernet/mediatek/mtk_wed_wo.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_definer.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_goto.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_vcap_ag_api.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_vcap_ag_api.h
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_dcb.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_tc_matchall.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_vcap_ag_api.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_vcap_ag_api.h
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_vcap_debugfs.h
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_vcap_impl.h
 create mode 100644 drivers/net/ethernet/microchip/vcap/Kconfig
 create mode 100644 drivers/net/ethernet/microchip/vcap/Makefile
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_ag_api.h
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_api.c
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_api.h
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_api_client.h
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.c
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_api_debugfs.h
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_api_debugfs_kunit.c
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_api_private.h
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_model_kunit.c
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_model_kunit.h
 create mode 100644 drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/nfd3/ipsec.c
 create mode 100644 drivers/net/ethernet/renesas/rcar_gen4_ptp.c
 create mode 100644 drivers/net/ethernet/renesas/rcar_gen4_ptp.h
 create mode 100644 drivers/net/ethernet/renesas/rswitch.c
 create mode 100644 drivers/net/ethernet/renesas/rswitch.h
 create mode 100644 drivers/net/ethernet/sfc/mae_counter_format.h
 create mode 100644 drivers/net/ethernet/sfc/tc_counters.c
 create mode 100644 drivers/net/ethernet/sfc/tc_counters.h
 delete mode 100644 drivers/net/ethernet/smsc/smc911x.c
 delete mode 100644 drivers/net/ethernet/smsc/smc911x.h
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c
 create mode 100644 drivers/net/ethernet/wangxun/libwx/Makefile
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_hw.c
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_hw.h
 create mode 100644 drivers/net/ethernet/wangxun/libwx/wx_type.h
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.c
 create mode 100644 drivers/net/ethernet/wangxun/ngbe/ngbe_hw.h
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_hw.h
 create mode 100644 drivers/net/ipa/data/ipa_data-v4.7.c
 create mode 100644 drivers/net/ipa/reg/ipa_reg-v4.7.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/Makefile
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/core.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/module.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bca/vops.h
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/Makefile
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/module.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/vops.h
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwvid.h
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/Makefile
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/core.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/module.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/wcc/vops.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/coredump.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/coredump.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/Kconfig
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/Makefile
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/debugfs.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/dma.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/init.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/mac.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/main.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/pci.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/regs.h
 create mode 100644 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723du.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821cu.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822bu.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822cu.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/usb.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/usb.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852b.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852b_rfk.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852b_rfk_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852b_rfk_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852b_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8852b_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/wow.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/wow.h
 delete mode 100644 drivers/net/wireless/ti/wilink_platform_data.c
 create mode 100644 drivers/net/wwan/t7xx/t7xx_port_trace.c
 delete mode 100644 include/linux/smc911x.h
 delete mode 100644 include/linux/wl12xx.h
 rename {drivers/net/ethernet/microsoft => include/net}/mana/gdma.h (80%)
 rename {drivers/net/ethernet/microsoft => include/net}/mana/hw_channel.h (100%)
 rename {drivers/net/ethernet/microsoft => include/net}/mana/mana.h (95%)
 create mode 100644 include/net/mana/mana_auxiliary.h
 rename {drivers/net/ethernet/microsoft => include/net}/mana/shm_channel.h (100%)
 create mode 100644 include/net/tc_wrapper.h
 create mode 100644 kernel/bpf/bpf_cgrp_storage.c
 create mode 100644 net/dsa/devlink.c
 create mode 100644 net/dsa/devlink.h
 create mode 100644 net/dsa/dsa.h
 delete mode 100644 net/dsa/dsa2.c
 delete mode 100644 net/dsa/dsa_priv.h
 create mode 100644 net/dsa/master.h
 create mode 100644 net/dsa/netlink.h
 create mode 100644 net/dsa/port.h
 create mode 100644 net/dsa/slave.h
 create mode 100644 net/dsa/switch.h
 create mode 100644 net/dsa/tag.c
 create mode 100644 net/dsa/tag.h
 create mode 100644 net/dsa/tag_8021q.h
 create mode 100644 net/dsa/tag_none.c
 create mode 100644 net/ethtool/rss.c
 create mode 100644 net/ipv4/tcp_plb.c
 create mode 100644 net/mptcp/fastopen.c
 create mode 100644 net/netfilter/nf_nat_ovs.c
 create mode 100644 net/netfilter/nft_inner.c
 create mode 100644 net/rxrpc/io_thread.c
 create mode 100644 net/rxrpc/rxperf.c
 create mode 100644 net/rxrpc/txbuf.c
 create mode 100644 net/xfrm/xfrm_interface_bpf.c
 rename net/xfrm/{xfrm_interface.c => xfrm_interface_core.c} (98%)
 create mode 100644 tools/testing/selftests/bpf/DENYLIST.aarch64
 create mode 100644 tools/testing/selftests/bpf/bpf_experimental.h
 create mode 100644 tools/testing/selftests/bpf/config.aarch64
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgrp_kfunc.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgrp_local_storage.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/empty_skb.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/kprobe_multi_testmod_test.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/libbpf_get_fd_by_id_opts.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/linked_list.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/rcu_read_lock.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/spin_lock.c
 delete mode 100644 tools/testing/selftests/bpf/prog_tests/spinlock.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/task_kfunc.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/type_cast.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xfrm_info.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h
 create mode 100644 tools/testing/selftests/bpf/progs/cgrp_kfunc_failure.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgrp_kfunc_success.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgrp_ls_attach_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgrp_ls_negative.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgrp_ls_recursion.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgrp_ls_sleepable.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgrp_ls_tp_btf.c
 create mode 100644 tools/testing/selftests/bpf/progs/empty_skb.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_list.c
 create mode 100644 tools/testing/selftests/bpf/progs/linked_list.h
 create mode 100644 tools/testing/selftests/bpf/progs/linked_list_fail.c
 create mode 100644 tools/testing/selftests/bpf/progs/rcu_read_lock.c
 create mode 100644 tools/testing/selftests/bpf/progs/task_kfunc_common.h
 create mode 100644 tools/testing/selftests/bpf/progs/task_kfunc_failure.c
 create mode 100644 tools/testing/selftests/bpf/progs/task_kfunc_success.c
 create mode 100644 tools/testing/selftests/bpf/progs/task_storage_nodeadlock.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_libbpf_get_fd_by_id_opts.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ringbuf_map_key.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_spin_lock_fail.c
 create mode 100644 tools/testing/selftests/bpf/progs/type_cast.c
 create mode 100644 tools/testing/selftests/bpf/progs/xfrm_info.c
 create mode 100644 tools/testing/selftests/bpf/test_loader.c
 create mode 100644 tools/testing/selftests/bpf/verifier/jeq_infer_not_null.c
 create mode 100755 tools/testing/selftests/drivers/net/bonding/mode-1-recovery-updelay.sh
 create mode 100755 tools/testing/selftests/drivers/net/bonding/mode-2-recovery-updelay.sh
 rename tools/testing/selftests/drivers/net/mlxsw/{spectrum-2 => }/devlink_trap_tunnel_ipip6.sh (99%)
 create mode 100644 tools/testing/selftests/net/csum.c
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_mdb_host.sh
 create mode 100644 tools/testing/selftests/net/hsr/Makefile
 create mode 100644 tools/testing/selftests/net/hsr/config
 create mode 100755 tools/testing/selftests/net/hsr/hsr_ping.sh
 create mode 100644 tools/testing/selftests/net/sctp_hello.c
 create mode 100755 tools/testing/selftests/net/sctp_vrf.sh
 create mode 100644 tools/testing/selftests/net/so_incoming_cpu.c

