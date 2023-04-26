Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7996EF687
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 16:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241435AbjDZOeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 10:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241426AbjDZOd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 10:33:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB03F3
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 07:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682519586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=iL2fwKPzbehBTb2HzQyHhDeCvDMnMhil6lEdQds/wmk=;
        b=iePCq7MbcQTCJVGsty1TqozFWChKDDpBzyUwg97Z0ASdHVdyE2+uDc8E+JzkPH+hSxy1RK
        CEdTq06eea5oFwsN6hzC+4kGKkMxjdFkcm2W0rv5j4f0kSGrpubSbFeS4yvOJBooxcByn0
        mmXdXyXhYqSk2ihDleKFjfkZIAS2Pfo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-480-cxeqcNvsOP-camu-S5JtLg-1; Wed, 26 Apr 2023 10:33:01 -0400
X-MC-Unique: cxeqcNvsOP-camu-S5JtLg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 060AA1C0758E;
        Wed, 26 Apr 2023 14:32:47 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.147])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA1022027045;
        Wed, 26 Apr 2023 14:32:43 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 6.4
Date:   Wed, 26 Apr 2023 16:31:18 +0200
Message-Id: <20230426143118.53556-1-pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

We have a few conflicts with your current tree, specifically:

- between commits:

  dbb0ea153401 ("thermal: Use thermal_zone_device_type() accessor")
  5601ef91fba8 ("mlxsw: core_thermal: Use static trip points for transceiver modules")

the latter removed the code updated by the former, the resolution
is deleting mlxsw_thermal_module_trips_reset() and
mlxsw_thermal_module_trips_update().

- between commits:

  cb8865fd865f (".gitignore: Unignore .kunitconfig")
  2bc42f482bed (".gitignore: Do not ignore .kunitconfig files")

the solution is accepting one or the other.

- between commits:

  1d0027dc9a3c ("bpf: switch to fdget_raw()")
  d7ba4cc900bf ("bpf: return long from bpf_map_ops funcs")

the solution is accepting the chunks from both changes.

- between commits:

  da8bdfbd4223 ("ftrace: Rename _ftrace_direct_multi APIs to _ftrace_direct APIs")
  31bf1dbccfb0 ("bpf: Fix attaching fentry/fexit/fmod_ret/lsm to modules")

the solution is accepting the chunks from both changes.

There are a few new knobs that will be silently set to 'y' only with
suitable old config, specifically: NET_HANDSHAKE, NETFILTER_BPF_LINK
and PHYLIB_LEDS.


The following changes since commit 0f2a4af27b649c13ba76431552fe49c60120d0f6:

  wifi: ath9k: Don't mark channelmap stack variable read-only in ath9k_mci_update_wlan_channels() (2023-04-20 15:26:37 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-6.4

for you to fetch changes up to 9b78d919632b7149d311aaad5a977e4b48b10321:

  net: phy: hide the PHYLIB_LEDS knob (2023-04-26 11:54:50 +0200)

----------------------------------------------------------------
Networking changes for 6.4.

Core
----

 - Introduce a config option to tweak MAX_SKB_FRAGS. Increasing the
   default value allows for better BIG TCP performances.

 - Reduce compound page head access for zero-copy data transfers.

 - RPS/RFS improvements, avoiding unneeded NET_RX_SOFTIRQ when possible.

 - Threaded NAPI improvements, adding defer skb free support and unneeded
   softirq avoidance.

 - Address dst_entry reference count scalability issues, via false
   sharing avoidance and optimize refcount tracking.

 - Add lockless accesses annotation to sk_err[_soft].

 - Optimize again the skb struct layout.

 - Extends the skb drop reasons to make it usable by multiple
   subsystems.

 - Better const qualifier awareness for socket casts.

BPF
---

 - Add skb and XDP typed dynptrs which allow BPF programs for more
   ergonomic and less brittle iteration through data and variable-sized
   accesses.

 - Add a new BPF netfilter program type and minimal support to hook
   BPF programs to netfilter hooks such as prerouting or forward.

 - Add more precise memory usage reporting for all BPF map types.

 - Adds support for using {FOU,GUE} encap with an ipip device operating
   in collect_md mode and add a set of BPF kfuncs for controlling encap
   params.

 - Allow BPF programs to detect at load time whether a particular kfunc
   exists or not, and also add support for this in light skeleton.

 - Bigger batch of BPF verifier improvements to prepare for upcoming BPF
   open-coded iterators allowing for less restrictive looping capabilities.

 - Rework RCU enforcement in the verifier, add kptr_rcu and enforce BPF
   programs to NULL-check before passing such pointers into kfunc.

 - Add support for kptrs in percpu hashmaps, percpu LRU hashmaps and in
   local storage maps.

 - Enable RCU semantics for task BPF kptrs and allow referenced kptr
   tasks to be stored in BPF maps.

 - Add support for refcounted local kptrs to the verifier for allowing
   shared ownership, useful for adding a node to both the BPF list and
   rbtree.

 - Add BPF verifier support for ST instructions in convert_ctx_access()
   which will help new -mcpu=v4 clang flag to start emitting them.

 - Add ARM32 USDT support to libbpf.

 - Improve bpftool's visual program dump which produces the control
   flow graph in a DOT format by adding C source inline annotations.

Protocols
---------

 - IPv4: Allow adding to IPv4 address a 'protocol' tag. Such value
   indicates the provenance of the IP address.

 - IPv6: optimize route lookup, dropping unneeded R/W lock acquisition.

 - Add the handshake upcall mechanism, allowing the user-space
   to implement generic TLS handshake on kernel's behalf.

 - Bridge: support per-{Port, VLAN} neighbor suppression, increasing
   resilience to nodes failures.

 - SCTP: add support for Fair Capacity and Weighted Fair Queueing
   schedulers.

 - MPTCP: delay first subflow allocation up to its first usage. This
   will allow for later better LSM interaction.

 - xfrm: Remove inner/outer modes from input/output path. These are
   not needed anymore.

 - WiFi:
   - reduced neighbor report (RNR) handling for AP mode
   - HW timestamping support
   - support for randomized auth/deauth TA for PASN privacy
   - per-link debugfs for multi-link
   - TC offload support for mac80211 drivers
   - mac80211 mesh fast-xmit and fast-rx support
   - enable Wi-Fi 7 (EHT) mesh support

Netfilter
---------

 - Add nf_tables 'brouting' support, to force a packet to be routed
   instead of being bridged.

 - Update bridge netfilter and ovs conntrack helpers to handle
   IPv6 Jumbo packets properly, i.e. fetch the packet length
   from hop-by-hop extension header. This is needed for BIT TCP
   support.

 - The iptables 32bit compat interface isn't compiled in by default
   anymore.

 - Move ip(6)tables builtin icmp matches to the udptcp one.
   This has the advantage that icmp/icmpv6 match doesn't load the
   iptables/ip6tables modules anymore when iptables-nft is used.

 - Extended netlink error report for netdevice in flowtables and
   netdev/chains. Allow for incrementally add/delete devices to netdev
   basechain. Allow to create netdev chain without device.

Driver API
----------

 - Remove redundant Device Control Error Reporting Enable, as PCI core
   has already error reporting enabled at enumeration time.

 - Move Multicast DB netlink handlers to core, allowing devices other
   then bridge to use them.

 - Allow the page_pool to directly recycle the pages from safely
   localized NAPI.

 - Implement lockless TX queue stop/wake combo macros, allowing for
   further code de-duplication and sanitization.

 - Add YNL support for user headers and struct attrs.

 - Add partial YNL specification for devlink.

 - Add partial YNL specification for ethtool.

 - Add tc-mqprio and tc-taprio support for preemptible traffic classes.

 - Add tx push buf len param to ethtool, specifies the maximum number
   of bytes of a transmitted packet a driver can push directly to the
   underlying device.

 - Add basic LED support for switch/phy.

 - Add NAPI documentation, stop relaying on external links.

 - Convert dsa_master_ioctl() to netdev notifier. This is a preparatory
   work to make the hardware timestamping layer selectable by user
   space.

 - Add transceiver support and improve the error messages for CAN-FD
   controllers.

New hardware / drivers
----------------------

 - Ethernet:
   - AMD/Pensando core device support
   - MediaTek MT7981 SoC
   - MediaTek MT7988 SoC
   - Broadcom BCM53134 embedded switch
   - Texas Instruments CPSW9G ethernet switch
   - Qualcomm EMAC3 DWMAC ethernet
   - StarFive JH7110 SoC
   - NXP CBTX ethernet PHY

 - WiFi:
   - Apple M1 Pro/Max devices
   - RealTek rtl8710bu/rtl8188gu
   - RealTek rtl8822bs, rtl8822cs and rtl8821cs SDIO chipset

 - Bluetooth:
   - Realtek RTL8821CS, RTL8851B, RTL8852BS
   - Mediatek MT7663, MT7922
   - NXP w8997
   - Actions Semi ATS2851
   - QTI WCN6855
   - Marvell 88W8997

 - Can:
   - STMicroelectronics bxcan stm32f429

Drivers
-------
 - Ethernet NICs:
   - Intel (1G, icg):
     - add tracking and reporting of QBV config errors.
     - add support for configuring max SDU for each Tx queue.
   - Intel (100G, ice):
     - refactor mailbox overflow detection to support Scalable IOV
     - GNSS interface optimization
   - Intel (i40e):
     - support XDP multi-buffer
   - nVidia/Mellanox:
     - add the support for linux bridge multicast offload
     - enable TC offload for egress and engress MACVLAN over bond
     - add support for VxLAN GBP encap/decap flows offload
     - extend packet offload to fully support libreswan
     - support tunnel mode in mlx5 IPsec packet offload
     - extend XDP multi-buffer support
     - support MACsec VLAN offload
     - add support for dynamic msix vectors allocation
     - drop RX page_cache and fully use page_pool
     - implement thermal zone to report NIC temperature
   - Netronome/Corigine:
     - add support for multi-zone conntrack offload
   - Solarflare/Xilinx:
     - support offloading TC VLAN push/pop actions to the MAE
     - support TC decap rules
     - support unicast PTP

 - Other NICs:
   - Broadcom (bnxt): enforce software based freq adjustments only
		on shared PHC NIC
   - RealTek (r8169): refactor to addess ASPM issues during NAPI poll.
   - Micrel (lan8841): add support for PTP_PF_PEROUT
   - Cadence (macb): enable PTP unicast
   - Engleder (tsnep): add XDP socket zero-copy support
   - virtio-net: implement exact header length guest feature
   - veth: add page_pool support for page recycling
   - vxlan: add MDB data path support
   - gve: add XDP support for GQI-QPL format
   - geneve: accept every ethertype
   - macvlan: allow some packets to bypass broadcast queue
   - mana: add support for jumbo frame

 - Ethernet high-speed switches:
   - Microchip (sparx5): Add support for TC flower templates.

 - Ethernet embedded switches:
   - Broadcom (b54):
     - configure 6318 and 63268 RGMII ports
   - Marvell (mv88e6xxx):
     - faster C45 bus scan
   - Microchip:
     - lan966x:
       - add support for IS1 VCAP
       - better TX/RX from/to CPU performances
     - ksz9477: add ETS Qdisc support
     - ksz8: enhance static MAC table operations and error handling
     - sama7g5: add PTP capability
   - NXP (ocelot):
     - add support for external ports
     - add support for preemptible traffic classes
   - Texas Instruments:
     - add CPSWxG SGMII support for J7200 and J721E

 - Intel WiFi (iwlwifi):
   - preparation for Wi-Fi 7 EHT and multi-link support
   - EHT (Wi-Fi 7) sniffer support
   - hardware timestamping support for some devices/firwmares
   - TX beacon protection on newer hardware

 - Qualcomm 802.11ax WiFi (ath11k):
   - MU-MIMO parameters support
   - ack signal support for management packets

 - RealTek WiFi (rtw88):
   - SDIO bus support
   - better support for some SDIO devices
     (e.g. MAC address from efuse)

 - RealTek WiFi (rtw89):
   - HW scan support for 8852b
   - better support for 6 GHz scanning
   - support for various newer firmware APIs
   - framework firmware backwards compatibility

 - MediaTek WiFi (mt76):
   - P2P support
   - mesh A-MSDU support
   - EHT (Wi-Fi 7) support
   - coredump support

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Aaradhana Sahu (1):
      wifi: ath12k: fix packets are sent in native wifi mode while we set raw mode

Aaron Conole (3):
      selftests: openvswitch: add interface support
      selftests: openvswitch: add flow dump support
      selftests: openvswitch: add support for upcall testing

Abhishek Kumar (1):
      wifi: ath10k: snoc: enable threaded napi on WCN3990

Abhishek Naik (1):
      wifi: iwlwifi: mvm: Add debugfs to get TAS status

Abhishek Pandit-Subedi (2):
      Bluetooth: Add support for hci devcoredump
      Bluetooth: btintel: Add Intel devcoredump support

Abinaya Kalaiselvan (1):
      wifi: ath11k: Add tx ack signal support for management packets

Adham Faris (6):
      net/mlx5e: Rename RQ/SQ adaptive moderation state flag
      net/mlx5e: Stringify RQ SW state in RQ devlink health diagnostics
      net/mlx5e: Expose SQ SW state as part of SQ health diagnostics
      net/mlx5e: Add XSK RQ state flag for RQ devlink health diagnostics
      net/mlx5e: Fix RQ SW state layout in RQ devlink health diagnostics
      net/mlx5e: Fix SQ SW state layout in SQ devlink health diagnostics

Aditya Kumar Singh (5):
      wifi: ath11k: use proper regulatory reference for bands
      wifi: ath11k: add support to parse new WMI event for 6 GHz
      wifi: ath11k: add debug prints in regulatory WMI event processing
      wifi: ath11k: fix deinitialization of firmware resources
      wifi: ath12k: fix firmware assert during channel switch for peer sta

Alain Volmat (1):
      net: ethernet: stmmac: dwmac-sti: remove stih415/stih416/stid127

Alejandro Colomar (1):
      bpf: Remove extra whitespace in SPDX tag for syscall/helpers man pages

Alex Elder (5):
      dt-bindings: net: qcom,ipa: add SDX65 compatible
      net: ipa: add IPA v5.0 register definitions
      net: ipa: add IPA v5.0 GSI register definitions
      net: ipa: add IPA v5.0 configuration data
      net: ipa: add IPA v5.0 to ipa_version_string()

Alexander Lobakin (6):
      selftests/bpf: robustify test_xdp_do_redirect with more payload magics
      net: page_pool, skbuff: make skb_mark_for_recycle() always available
      xdp: recycle Page Pool backed skbs built from XDP frames
      xdp: remove unused {__,}xdp_release_frame()
      bpf, test_run: fix crashes due to XDP frame overwriting/corruption
      selftests/bpf: fix "metadata marker" getting overwritten by the netstack

Alexander Mikhalitsyn (1):
      scm: fix MSG_CTRUNC setting condition for SO_PASSSEC

Alexander Stein (3):
      net: phy: dp83867: Disable IRQs on suspend
      net: phy: Fix reading LED reg property
      net: phy: dp83867: Add led_brightness_set support

Alexei Starovoitov (61):
      Merge branch 'Add skb + xdp dynptrs'
      Merge branch 'Add support for kptrs in more BPF maps'
      bpf: Rename __kptr_ref -> __kptr and __kptr -> __kptr_untrusted.
      bpf: Mark cgroups and dfl_cgrp fields as trusted.
      bpf: Introduce kptr_rcu.
      selftests/bpf: Add a test case for kptr_rcu.
      selftests/bpf: Tweak cgroup kfunc test.
      bpf: Refactor RCU enforcement in the verifier.
      Merge branch 'bpf: allow ctx writes using BPF_ST_MEM instruction'
      Merge branch 'bpf: bpf memory usage'
      Merge branch 'BPF open-coded iterators'
      Merge branch 'selftests/bpf: make BPF_CFLAGS stricter with -Wall'
      Merge branch 'Support stashing local kptrs with bpf_kptr_xchg'
      bpf: Fix bpf_strncmp proto.
      bpf: Allow helpers access trusted PTR_TO_BTF_ID.
      selftests/bpf: Add various tests to check helper access into ptr_to_btf_id.
      Merge branch 'xdp: recycle Page Pool backed skbs built from XDP frames'
      selftests/bpf: Fix trace_virtqueue_add_sgs test issue with LLVM 17.
      Merge branch 'Fix attaching fentry/fexit/fmod_ret/lsm to modules'
      Merge branch 'Make struct bpf_cpumask RCU safe'
      Merge branch 'double-fix bpf_test_run + XDP_PASS recycling'
      bpf: Allow ld_imm64 instruction to point to kfunc.
      libbpf: Fix relocation of kfunc ksym in ld_imm64 insn.
      libbpf: Introduce bpf_ksym_exists() macro.
      selftests/bpf: Add test for bpf_ksym_exists().
      libbpf: Fix ld_imm64 copy logic for ksym in light skeleton.
      selftest/bpf: Add a test case for ld_imm64 copy logic.
      libbpf: Rename RELO_EXTERN_VAR/FUNC.
      bpf: Teach the verifier to recognize rdonly_mem as not null.
      libbpf: Support kfunc detection in light skeleton.
      selftests/bpf: Add light skeleton test for kfunc detection.
      Merge branch 'error checking where helpers call bpf_map_ops'
      Merge branch 'Don't invoke KPTR_REF destructor on NULL xchg'
      Merge branch 'First set of verifier/*.c migrated to inline assembly'
      Merge branch 'bpf: Use bpf_mem_cache_alloc/free in bpf_local_storage'
      Merge branch 'veristat: add better support of freplace programs'
      Merge branch 'selftests/bpf: Add read_build_id function'
      Merge branch 'Prepare veristat for packaging'
      Merge branch 'Enable RCU semantics for task kptrs'
      bpf: Invoke btf_struct_access() callback only for writes.
      bpf: Remove unused arguments from btf_struct_access().
      bpf: Refactor btf_nested_type_is_trusted().
      bpf: Teach verifier that certain helpers accept NULL pointer.
      bpf: Refactor NULL-ness check in check_reg_type().
      bpf: Allowlist few fields similar to __rcu tag.
      bpf: Undo strict enforcement for walking untagged fields.
      selftests/bpf: Add tracing tests for walking skb and req.
      Merge branch 'bpftool: Add inline annotations when dumping program CFGs'
      Merge branch 'bpf: Improve verifier for cond_op and spilled loop index variables'
      bpf: Handle NULL in bpf_local_storage_free.
      Merge branch 'Add FOU support for externally controlled ipip devices'
      mm: Fix copy_from_user_nofault().
      selftests/bpf: Fix merge conflict due to SYS() macro change.
      selftests/bpf: Workaround for older vm_sockets.h.
      Merge branch 'Shared ownership for local kptrs'
      Merge branch 'Remove KF_KPTR_GET kfunc flag'
      Merge branch 'Provide bpf_for() and bpf_for_each() by libbpf'
      Merge branch 'Access variable length array relaxed for integer type'
      Merge branch 'fix __retval() being always ignored'
      bpf: Fix race between btf_put and btf_idr walk.
      Merge branch 'bpf: add netfilter program type'

Alexey V. Vissarionov (1):
      wifi: ath6kl: minor fix for allocation size

Aloka Dixit (7):
      wifi: mac80211: generate EMA beacons in AP mode
      wifi: mac80211_hwsim: move beacon transmission to a separate function
      wifi: mac80211_hwsim: Multiple BSSID support
      wifi: mac80211_hwsim: EMA support
      cfg80211: support RNR for EMA AP
      mac80211: support RNR for EMA AP
      wifi: mac80211: set EHT support flag in AP mode

Alon Giladi (3):
      wifi: iwlwifi: mvm: allow Microsoft to use TAS
      wifi: iwlwifi: acpi: support modules with high antenna gain
      wifi: iwlwifi: fw: fix argument to efi.get_variable

Andrew Halaney (9):
      dt-bindings: net: qcom,ethqos: Add Qualcomm sc8280xp compatibles
      net: stmmac: Remove unnecessary if statement brackets
      net: stmmac: Fix DMA typo
      net: stmmac: Remove some unnecessary void pointers
      net: stmmac: Pass stmmac_priv in some callbacks
      net: stmmac: dwmac4: Allow platforms to specify some DMA/MTL offsets
      net: stmmac: dwmac-qcom-ethqos: Respect phy-mode and TX delay
      net: stmmac: dwmac-qcom-ethqos: Use loopback_en for all speeds
      net: stmmac: dwmac-qcom-ethqos: Add EMAC3 support

Andrew Lunn (10):
      net: dsa: mv88e6xxx: Correct cmode to PHY_INTERFACE_
      net: ethernet: Add missing depends on MDIO_DEVRES
      leds: Provide stubs for when CLASS_LED & NEW_LEDS are disabled
      net: phy: Add a binding for PHY LEDs
      net: phy: phy_device: Call into the PHY driver to set LED brightness
      net: phy: marvell: Add software control of the LEDs
      net: phy: phy_device: Call into the PHY driver to set LED blinking
      net: phy: marvell: Implement led_blink_set()
      arm: mvebu: dt: Add PHY LED support for 370-rd WAN port
      Documentation: LEDs: Describe good names for network LEDs

Andrii Nakryiko (74):
      Merge branch 'libbpf: fix several issues reported by static analysers'
      selftests/bpf: Support custom per-test flags and multiple expected messages
      Merge branch 'selftests/bpf: support custom per-test flags and multiple expected messages'
      Merge branch 'Make uprobe attachment APK aware'
      bpf: improve stack slot state printing
      bpf: improve regsafe() checks for PTR_TO_{MEM,BUF,TP_BUFFER}
      selftests/bpf: enhance align selftest's expected log matching
      bpf: honor env->test_state_freq flag in is_state_visited()
      selftests/bpf: adjust log_fixup's buffer size for proper truncation
      bpf: clean up visit_insn()'s instruction processing
      bpf: fix visit_insn()'s detection of BPF_FUNC_timer_set_callback helper
      bpf: ensure that r0 is marked scratched after any function call
      bpf: move kfunc_call_arg_meta higher in the file
      bpf: mark PTR_TO_MEM as non-null register type
      bpf: generalize dynptr_get_spi to be usable for iters
      bpf: add support for fixed-size memory pointer returns for kfuncs
      Merge branch 'libbpf: allow users to set kprobe/uprobe attach mode'
      Merge branch 'libbpf: usdt arm arg parsing support'
      bpf: factor out fetching basic kfunc metadata
      bpf: add iterator kfuncs registration and validation logic
      bpf: add support for open-coded iterator loops
      bpf: implement numbers iterator
      selftests/bpf: add bpf_for_each(), bpf_for(), and bpf_repeat() macros
      selftests/bpf: add iterators tests
      selftests/bpf: add number iterator tests
      selftests/bpf: implement and test custom testmod_seq iterator
      selftests/bpf: prevent unused variable warning in bpf_for()
      selftests/bpf: add __sink() macro to fake variable consumption
      selftests/bpf: fix lots of silly mistakes pointed out by compiler
      selftests/bpf: make BPF compiler flags stricter
      bpf: ensure state checkpointing at iter_next() call sites
      bpf: take into account liveness when propagating precision
      bpf: fix precision propagation verbose logging
      Merge branch 'bpf: Add detection of kfuncs.'
      Merge branch 'bpf: Support ksym detection in light skeleton.'
      bpf: remember meta->iter info only for initialized iters
      Merge branch 'verifier/xdp_direct_packet_access.c converted to inline assembly'
      libbpf: disassociate section handler on explicit bpf_program__set_type() call
      veristat: add -d debug mode option to see debug libbpf log
      veristat: guess and substitue underlying program type for freplace (EXT) progs
      veristat: change guess for __sk_buff from CGROUP_SKB to SCHED_CLS
      veristat: relicense veristat.c as dual GPL-2.0-only or BSD-2-Clause licensed
      veristat: improve version reporting
      veristat: avoid using kernel-internal headers
      veristat: small fixed found in -O2 mode
      Merge branch 'bpf: Follow up to RCU enforcement in the verifier.'
      bpf: Split off basic BPF verifier log into separate file
      bpf: Remove minimum size restrictions on verifier log buffer
      bpf: Switch BPF verifier log to be a rotating log by default
      libbpf: Don't enforce unnecessary verifier log restrictions on libbpf side
      veristat: Add more veristat control over verifier log options
      selftests/bpf: Add fixed vs rotating verifier log tests
      bpf: Ignore verifier log reset in BPF_LOG_KERNEL mode
      bpf: Fix missing -EFAULT return on user log buf error in btf_parse()
      bpf: Avoid incorrect -EFAULT error in BPF_LOG_KERNEL mode
      bpf: Simplify logging-related error conditions handling
      bpf: Keep track of total log content size in both fixed and rolling modes
      bpf: Add log_true_size output field to return necessary log buffer size
      bpf: Simplify internal verifier log interface
      bpf: Relax log_buf NULL conditions when log_level>0 is requested
      libbpf: Wire through log_true_size returned from kernel for BPF_PROG_LOAD
      libbpf: Wire through log_true_size for bpf_btf_load() API
      selftests/bpf: Add tests to validate log_true_size feature
      selftests/bpf: Add testing of log_buf==NULL condition for BPF_PROG_LOAD
      selftests/bpf: Add verifier log tests for BPF_BTF_LOAD command
      selftests/bpf: Remove stand-along test_verifier_log test binary
      selftests/bpf: Fix compiler warnings in bpf_testmod for kfuncs
      libbpf: misc internal libbpf clean ups around log fixup
      libbpf: report vmlinux vs module name when dealing with ksyms
      libbpf: improve handling of unresolved kfuncs
      selftests/bpf: add missing __weak kfunc log fixup test
      libbpf: move bpf_for(), bpf_for_each(), and bpf_repeat() into bpf_helpers.h
      libbpf: mark bpf_iter_num_{new,next,destroy} as __weak
      selftests/bpf: avoid mark_all_scalars_precise() trigger in one of iter tests

Andrii Staikov (1):
      igb: refactor igb_ptp_adjfine_82580 to use diff_by_scaled_ppm

Andy Shevchenko (3):
      net: dsa: hellcreek: Get rid of custom led_init_default_state_get()
      net: smc91x: Replace of_gpio.h with what indeed is used
      net: phy: at803x: Replace of_gpio.h with what indeed is used

Anton Protopopov (2):
      bpf: optimize hashmap lookups when key_size is divisible by 4
      bpf: compute hashes in bloom filter similar to hashmap

Archie Pusaka (2):
      Bluetooth: hci_sync: Don't wait peer's reply when powering off
      Bluetooth: Cancel sync command before suspend and power off

Armin Wolf (1):
      wifi: rt2x00: Fix memory leak when handling surveys

Arnd Bergmann (5):
      net: mscc: ocelot: remove incompatible prototypes
      wifi: airo: remove ISA_DMA_API dependency
      net: phy: fix circular LEDS_CLASS dependencies
      net: dsa: qca8k: fix LEDS_CLASS dependency
      Bluetooth: NXP: select CONFIG_CRC8

Arseniy Krasnov (7):
      virtio/vsock: check transport before skb allocation
      virtio/vsock: allocate multiple skbuffs on tx
      virtio/vsock: check argument to avoid no effect call
      vsock/vmci: convert VMCI error code to -ENOMEM on receive
      vsock: return errors other than -ENOMEM to socket
      vsock/test: update expected return values
      vsock/loopback: don't disable irqs for queue access

Arınç ÜNAL (1):
      dt-bindings: net: dsa: mediatek,mt7530: change some descriptions to literal

Avraham Stern (19):
      wifi: nl80211: add a command to enable/disable HW timestamping
      wifi: mac80211: add support for set_hw_timestamp command
      wifi: iwlwifi: mvm: read synced time from firmware if supported
      wifi: iwlwifi: mvm: report hardware timestamps in RX/TX status
      wifi: iwlwifi: mvm: implement PHC clock adjustments
      wifi: iwlwifi: mvm: select ptp cross timestamp from multiple reads
      wifi: iwlwifi: mvm: support enabling and disabling HW timestamping
      wifi: iwlwifi: mvm: add set_hw_timestamp to mld ops
      wifi: iwlwifi: mvm: adjust iwl_mvm_scan_respect_p2p_go_iter() for MLO
      wifi: iwlwifi: mvm: use OFDM rate if IEEE80211_TX_CTL_NO_CCK_RATE is set
      wifi: iwlwifi: trans: don't trigger d3 interrupt twice
      wifi: iwlwifi: mvm: don't set CHECKSUM_COMPLETE for unsupported protocols
      wifi: iwlwifi: mvm: fix shift-out-of-bounds
      wifi: iwlwifi: mvm: make HLTK configuration for PASN station optional
      wifi: iwlwifi: mvm: avoid iterating over an un-initialized list
      wifi: iwlwifi: modify scan request and results when in link protection
      wifi: iwlwifi: mei: make mei filtered scan more aggressive
      wifi: iwlwifi: mei: re-ask for ownership after it was taken by CSME
      wifi: iwlwifi: mvm: fix RFKILL report when driver is going down

Aya Levin (1):
      net/mlx5e: Nullify table pointer when failing to create

Ayala Beker (2):
      wifi: iwlwifi: mvm: don't drop unencrypted MCAST frames
      wifi: iwlwifi: mvm: scan legacy bands and UHB channels with same antenna

Bagas Sanjaya (2):
      bpf, docs: Use internal linking for link to netdev subsystem doc
      wifi: mac80211: use bullet list for amsdu_mesh_control formats list

Baochen Qiang (2):
      wifi: ath12k: Identify DFS channel when sending scan channel list command
      wifi: ath12k: Enable IMPS for WCN7850

Barret Rhoden (1):
      bpf: ensure all memory is initialized in bpf_get_current_comm

Bartosz Wawrzyniak (1):
      net: macb: Set MDIO clock divisor for pclk higher than 160MHz

Bastian Germann (1):
      wifi: ath9k: Remove Qwest/Actiontec 802AIN ID

Benjamin Berg (5):
      wifi: mac80211: add pointer from bss_conf to vif
      wifi: mac80211: remove SMPS from AP debugfs
      wifi: mac80211: add netdev per-link debugfs data and driver hook
      wifi: iwlwifi: mvm: use appropriate link for rate selection
      wifi: iwlwifi: mvm: initialize max_rc_amsdu_len per-link

Bhagavathi Perumal S (1):
      wifi: ath11k: Fix invalid management rx frame length issue

Bhupesh Sharma (3):
      dt-bindings: net: snps,dwmac: Update interrupt-names
      dt-bindings: net: snps,dwmac: Add Qualcomm Ethernet ETHQOS compatibles
      dt-bindings: net: qcom,ethqos: Convert bindings to yaml

Bitterblue Smith (8):
      wifi: rtl8xxxu: Remove always true condition in rtl8xxxu_print_chipinfo
      wifi: rtl8xxxu: RTL8192EU always needs full init
      wifi: rtl8xxxu: Support new chip RTL8710BU aka RTL8188GU
      wifi: rtl8xxxu: Clean up some messy ifs
      wifi: rtl8xxxu: Support devices with 5-6 out endpoints
      wifi: rtl8xxxu: Don't print the vendor/product/serial
      wifi: rtl8xxxu: Add rtl8xxxu_write{8,16,32}_{set,clear}
      wifi: rtl8xxxu: Simplify setting the initial gain

Bjorn Helgaas (29):
      alx: Drop redundant pci_enable_pcie_error_reporting()
      be2net: Drop redundant pci_enable_pcie_error_reporting()
      bnx2: Drop redundant pci_enable_pcie_error_reporting()
      bnx2x: Drop redundant pci_enable_pcie_error_reporting()
      bnxt: Drop redundant pci_enable_pcie_error_reporting()
      cxgb4: Drop redundant pci_enable_pcie_error_reporting()
      net/fungible: Drop redundant pci_enable_pcie_error_reporting()
      net: hns3: remove unnecessary aer.h include
      netxen_nic: Drop redundant pci_enable_pcie_error_reporting()
      octeon_ep: Drop redundant pci_enable_pcie_error_reporting()
      qed: Drop redundant pci_enable_pcie_error_reporting()
      net: qede: Remove unnecessary aer.h include
      qlcnic: Drop redundant pci_enable_pcie_error_reporting()
      qlcnic: Remove unnecessary aer.h include
      sfc: Drop redundant pci_enable_pcie_error_reporting()
      sfc: falcon: Drop redundant pci_enable_pcie_error_reporting()
      sfc/siena: Drop redundant pci_enable_pcie_error_reporting()
      sfc_ef100: Drop redundant pci_disable_pcie_error_reporting()
      net: ngbe: Drop redundant pci_enable_pcie_error_reporting()
      net: txgbe: Drop redundant pci_enable_pcie_error_reporting()
      e1000e: Remove unnecessary aer.h include
      fm10k: Remove unnecessary aer.h include
      i40e: Remove unnecessary aer.h include
      iavf: Remove unnecessary aer.h include
      ice: Remove unnecessary aer.h include
      igb: Remove unnecessary aer.h include
      igc: Remove unnecessary aer.h include
      ixgbe: Remove unnecessary aer.h include
      net: restore alpha order to Ethernet devices in config

Bo Jiao (1):
      wifi: mt76: mt7996: enable full system reset support

Bobby Eshleman (4):
      testing/vsock: add vsock_perf to gitignore
      vsock: support sockmap
      selftests/bpf: add vsock to vmtest.sh
      selftests/bpf: add a test case for vsock sockmap

Brett Creeley (1):
      ionic: Don't overwrite the cyclecounter bitmask

Brian Gix (1):
      Bluetooth: Convert MSFT filter HCI cmd to hci_sync

Cai Huoqing (18):
      net: liquidio: Remove redundant pci_clear_master
      net: hisilicon: Remove redundant pci_clear_master
      net: cxgb4vf: Remove redundant pci_clear_master
      net/fungible: Remove redundant pci_clear_master
      net/mlx5: Remove redundant pci_clear_master
      net: mana: Remove redundant pci_clear_master
      ionic: Remove redundant pci_clear_master
      ethernet: ec_bhf: Remove redundant pci_clear_master
      isdn: mISDN: netjet: Remove redundant pci_clear_master
      net/ism: Remove redundant pci_clear_master
      can: c_can: Remove redundant pci_clear_master
      can: ctucanfd: Remove redundant pci_clear_master
      can: kvaser_pciefd: Remove redundant pci_clear_master
      wifi: rtw88: Remove redundant pci_clear_master
      wifi: rtw89: Remove redundant pci_clear_master
      wifi: ath11k: Remove redundant pci_clear_master
      wifi: ath10k: Remove redundant pci_clear_master
      wifi: ath12k: Remove redundant pci_clear_master

Chethan T N (1):
      Bluetooth: btintel: Add LE States quirk support

Chih-Kang Chang (6):
      wifi: rtw89: fix SER L1 might stop entering LPS issue
      wifi: rtw89: set data lowest rate according to AP supported rate
      wifi: rtw89: fix incorrect channel info during scan due to ppdu_sts filtering
      wifi: rtw89: config EDCCA threshold during scan to prevent TX failed
      wifi: rtw89: fix power save function in WoWLAN mode
      wifi: rtw89: prohibit enter IPS during HW scan

Chin-Yen Lee (3):
      wifi: rtw89: add tx_wake notify for 8852B
      wifi: rtw89: remove superfluous H2C of join_info
      wifi: rtw89: support WoWLAN mode for 8852be

Ching-Te Ku (15):
      wifi: rtw89: coex: Add more error_map and counter to log
      wifi: rtw89: coex: Add WiFi role info v2
      wifi: rtw89: coex: Add traffic TX/RX info and its H2C
      wifi: rtw89: coex: Add register monitor report v2 format
      wifi: rtw89: coex: Fix wrong structure assignment at null data report
      wifi: rtw89: coex: Add v2 Bluetooth scan info
      wifi: rtw89: coex: Add v5 firmware cycle status report
      wifi: rtw89: coex: Add LPS protocol radio state for RTL8852B
      wifi: rtw89: coex: Not to enable firmware report when WiFi is power saving
      wifi: rtw89: coex: Update RTL8852B LNA2 hardware parameter
      wifi: rtw89: coex: Add report control v5 variation
      wifi: rtw89: coex: Update Wi-Fi Bluetooth coexistence version to 7.0.1
      wifi: rtw89: coex: Enable Wi-Fi RX gain control for free run solution
      wifi: rtw89: coex: Add path control register to monitor list
      wifi: rtw89: coex: Update function to get BT RSSI and hardware counter

Chris Mi (3):
      net/mlx5: E-switch, Create per vport table based on devlink encap mode
      net/mlx5: E-switch, Don't destroy indirect table in split rule
      net/mlx5: Release tunnel device after tc update skb

Chris Morgan (3):
      dt-bindings: net: realtek-bluetooth: Add RTL8821CS
      Bluetooth: hci_h5: btrtl: Add support for RTL8821CS
      arm64: dts: rockchip: Update compatible for bluetooth

Christian Ehrig (3):
      ipip,ip_tunnel,sit: Add FOU support for externally controlled ipip devices
      bpf,fou: Add bpf_skb_{set,get}_fou_encap kfuncs
      selftests/bpf: Test FOU kfuncs for externally controlled ipip devices

Christian Marangi (10):
      wifi: ath11k: fix SAC bug on peer addition with sta band migration
      net: dsa: qca8k: move qca8k_port_to_phy() to header
      net: dsa: qca8k: add LEDs basic support
      net: dsa: qca8k: add LEDs blink_set() support
      dt-bindings: net: ethernet-controller: Document support for LEDs node
      dt-bindings: net: dsa: qca8k: add LEDs definition example
      ARM: dts: qcom: ipq8064-rb3011: Drop unevaluated properties in switch nodes
      ARM: dts: qcom: ipq8064-rb3011: Add Switch LED for each port
      dt-bindings: net: phy: Document support for LEDs node
      net: phy: marvell: Fix inconsistent indenting in led_blink_set

Christophe JAILLET (3):
      wifi: wfx: Remove some dead code
      wifi: wcn36xx: Slightly optimize PREPARE_HAL_BUF()
      wifi: rsi: Slightly simplify rsi_set_channel()

Chuck Lever (4):
      .gitignore: Do not ignore .kunitconfig files
      net/handshake: Create a NETLINK service for handling handshake requests
      net/handshake: Add a kernel API for requesting a TLSv1.3 handshake
      net/handshake: Add Kunit tests for the handshake consumer API

Colin Foster (9):
      phy: phy-ocelot-serdes: add ability to be used in a non-syscon configuration
      mfd: ocelot: add ocelot-serdes capability
      net: mscc: ocelot: expose ocelot_pll5_init routine
      net: mscc: ocelot: expose generic phylink_mac_config routine
      net: mscc: ocelot: expose serdes configuration function
      net: dsa: felix: attempt to initialize internal hsio plls
      net: dsa: felix: allow configurable phylink_mac_config
      net: dsa: felix: allow serdes configuration for dsa ports
      net: dsa: ocelot: add support for external phys

Colin Ian King (4):
      wifi: ath12k: Fix spelling mistakes in warning messages and comments
      net: phy: micrel: Fix spelling mistake "minimim" -> "minimum"
      wifi: iwlwifi: Fix spelling mistake "upto" -> "up to"
      wifi: iwlwifi: mvm: Fix spelling mistake "Gerenal" -> "General"

Corinna Vinschen (2):
      net: stmmac: propagate feature flags to vlan
      stmmac: fix changing mac address

Dan Carpenter (7):
      wifi: ath12k: use kfree_skb() instead of kfree()
      wifi: ath5k: fix an off by one check in ath5k_eeprom_read_freq_list()
      octeon_ep: unlock the correct lock on error path
      wifi: rndis_wlan: clean up a type issue
      wifi: mt76: mt7915: unlock on error in mt7915_thermal_temp_store()
      net: dpaa: Fix uninitialized variable in dpaa_stop()
      Bluetooth: vhci: Fix info leak in force_devcd_write()

Daniel Borkmann (5):
      Merge branch 'bpf-kptr-rcu'
      bpf: Fix __reg_bound_offset 64->32 var_off subreg propagation
      Merge branch 'bpf-verifier-log-rotation'
      bpf, sockmap: Revert buggy deadlock fix in the sockhash and sockmap
      bpf: Set skb redirect and from_ingress info in __bpf_tx_skb

Daniel Gabay (4):
      wifi: iwlwifi: nvm: Update HE capabilities on 6GHz band for EHT device
      wifi: iwlwifi: pcie: fix possible NULL pointer dereference
      wifi: iwlwifi: yoyo: skip dump correctly on hw error
      wifi: iwlwifi: yoyo: Fix possible division by zero

Daniel Golle (26):
      net: ethernet: mtk_eth_soc: add support for MT7981 SoC
      dt-bindings: net: mediatek,net: add mt7981-eth binding
      dt-bindings: arm: mediatek: sgmiisys: Convert to DT schema
      dt-bindings: net: pcs: mediatek,sgmiisys: add MT7981 SoC
      net: ethernet: mtk_eth_soc: set MDIO bus clock frequency
      net: ethernet: mtk_eth_soc: ppe: add support for flow accounting
      net: pcs: add driver for MediaTek SGMII PCS
      net: ethernet: mtk_eth_soc: switch to external PCS driver
      net: dsa: mt7530: use external PCS driver
      net: dsa: mt7530: make some noise if register read fails
      net: dsa: mt7530: refactor SGMII PCS creation
      net: dsa: mt7530: use unlocked regmap accessors
      net: dsa: mt7530: use regmap to access switch register space
      net: dsa: mt7530: move SGMII PCS creation to mt7530_probe function
      net: dsa: mt7530: introduce mutex helpers
      net: dsa: mt7530: move p5_intf_modes() function to mt7530.c
      net: dsa: mt7530: introduce mt7530_probe_common helper function
      net: dsa: mt7530: introduce mt7530_remove_common helper function
      net: dsa: mt7530: split-off common parts from mt7531_setup
      net: dsa: mt7530: introduce separate MDIO driver
      net: dsa: mt7530: skip locking if MDIO bus isn't present
      net: dsa: mt7530: introduce driver for MT7988 built-in switch
      dt-bindings: net: dsa: mediatek,mt7530: add mediatek,mt7988-switch
      net: dsa: mt7530: fix support for MT7531BE
      dt-bindings: net: mediatek: add WED RX binding for MT7981 eth driver
      net: ethernet: mtk_eth_soc: use WO firmware for MT7981

Daniel Müller (5):
      libbpf: Implement basic zip archive parsing support
      libbpf: Introduce elf_find_func_offset_from_file() function
      libbpf: Add support for attaching uprobes to shared objects in APKs
      libbpf: Fix theoretical u32 underflow in find_cd() function
      libbpf: Ignore warnings about "inefficient alignment"

Dario Binacchi (5):
      dt-bindings: arm: stm32: add compatible for syscon gcan node
      dt-bindings: net: can: add STM32 bxcan DT bindings
      ARM: dts: stm32: add CAN support on stm32f429
      ARM: dts: stm32: add pin map for CAN controller on stm32f4
      can: bxcan: add support for ST bxCAN controller

Dave Marchevsky (20):
      selftests/bpf: Add -Wuninitialized flag to bpf prog flags
      bpf: verifier: Rename kernel_type_name helper to btf_type_name
      bpf: btf: Remove unused btf_field_info_type enum
      bpf: Change btf_record_find enum parameter to field_mask
      bpf: Support __kptr to local kptrs
      bpf: Allow local kptrs to be exchanged via bpf_kptr_xchg
      selftests/bpf: Add local kptr stashing test
      bpf: Disable migration when freeing stashed local kptr using obj drop
      bpf: Fix struct_meta lookup for bpf_obj_free_fields kfunc call
      bpf: Remove btf_field_offs, use btf_record's fields instead
      bpf: Introduce opaque bpf_refcount struct and add btf_record plumbing
      bpf: Support refcounted local kptrs in existing semantics
      bpf: Add bpf_refcount_acquire kfunc
      bpf: Migrate bpf_rbtree_add and bpf_list_push_{front,back} to possibly fail
      selftests/bpf: Modify linked_list tests to work with macro-ified inserts
      bpf: Migrate bpf_rbtree_remove to possibly fail
      bpf: Centralize btf_field-specific initialization logic
      selftests/bpf: Add refcounted_kptr tests
      bpf: Fix bpf_refcount_acquire's refcount_t address calculation
      bpf: Disable bpf_refcount_acquire kfunc calls until race conditions are fixed

Dave Thaler (5):
      bpf, docs: Add explanation of endianness
      bpf, docs: Explain helper functions
      bpf, docs: Add signed comparison example
      bpf, docs: Add extended call instructions
      bpf, docs: Add docs on extended 64-bit immediate instructions

David Arinzon (1):
      net: ena: Add an option to configure large LLQ headers

David Howells (1):
      rxrpc: Fix potential race in error handling in afs_make_call()

David S. Miller (53):
      Merge branch 'r8169-disable-ASPM-during-NAPI-poll'
      Merge branch 'sparx5-tc-flower-templates'
      Merge branch 'dsa-microchip-tc-ets'
      Merge branch 'net-smc-updates'
      Merge branch 'J784S4-CPSW9G-bindings'
      Merge branch 'vxlan-MDB-support'
      Merge branch 'pcs_get_state-fixes'
      Merge branch 'net-sk_err-lockless-annotate'
      Merge branch 'gve-xdp-support'
      Merge branch 'net-packet-KCSAN'
      Merge branch 'inet-const'
      Merge branch 'net-better-const'
      Merge branch 'lan966x-tx-rx-improve'
      Merge branch 'ocelot-external-ports'
      Merge branch 'reuse-smsc-phy-functionality'
      Merge branch 'ipv4-address-protocol'
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'bcm53134-support'
      Merge branch 'octeon_ep-deferred-probe-and-mailbox'
      Merge branch 'sunhme-cleanups'
      Merge branch 'vsock-sockmap-support'
      Merge branch 'in6addr_any-cleanups'
      Merge branch 'mptcp-cleanups'
      Merge branch 'macvlan-broadcast-queue-bypass'
      Merge branch 'sfc-tc-decap-support'
      Merge branch 'mlxsw-transceiver-trip-points'
      Merge branch 'dsa_master_ioctl-notifier'
      Merge branch 'phy-smsc-edpd-tunable'
      Merge branch 'mt7988-support'
      Merge branch 'dsa-trace-events'
      Merge branch 'rk3588-error-prints'
      Merge branch 'mana-jumbo-frames'
      Merge branch 'msg_control-split'
      Merge branch 'ovs-selftests'
      Merge tag 'mlx5-updates-2023-04-14' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'mptcp-subflow-init'
      Merge branch 'mptcp-cleanups'
      Merge branch 'sctp-info-dump'
      Merge branch 'mlx5e-xdp-extend'
      Merge branch 'switch-phy-leds'
      Merge branch 'skbuff-bitfields'
      Merge branch 'sctp-nested-flex-arrays'
      Merge branch 'macsec-vlan'
      Merge branch 'bridge-neigh-suppression'
      Merge branch 'pds_core'
      Merge branch 'mlx5-ipsec-fixes'
      Merge branch 'mtk_eth_soc-firmware'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'napi_threaded_poll-enhancements'
      Merge branch 'dsa-skb_mac_header'
      Merge branch 'act_pedit-minor-improvements'
      Merge branch 'net-sched-parsing-prints'
      Merge tag 'for-net-next-2023-04-23' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next

David Vernet (26):
      bpf: Fix bpf_cgroup_from_id() doxygen header
      bpf: Fix doxygen comments for dynptr slice kfuncs
      bpf, docs: Fix __uninit kfunc doc section
      bpf, docs: Fix link to netdev-FAQ target
      bpf, docs: Fix final bpf docs build failure
      bpf/selftests: Fix send_signal tracepoint tests
      tasks: Extract rcu_users out of union
      bpf: Free struct bpf_cpumask in call_rcu handler
      bpf: Mark struct bpf_cpumask as rcu protected
      bpf/selftests: Test using global cpumask kptr with RCU
      bpf: Remove bpf_cpumask_kptr_get() kfunc
      bpf,docs: Remove bpf_cpumask_kptr_get() from documentation
      bpf: Only invoke kptr dtor following non-NULL xchg
      bpf: Remove now-unnecessary NULL checks for KF_RELEASE kfuncs
      bpf: Treat KF_RELEASE kfuncs as KF_TRUSTED_ARGS
      bpf: Handle PTR_MAYBE_NULL case in PTR_TO_BTF_ID helper call arg
      selftests/bpf: Add testcases for ptr_*_or_null_ in bpf_kptr_xchg
      bpf: Make struct task_struct an RCU-safe type
      bpf: Remove now-defunct task kfuncs
      bpf,docs: Update documentation to reflect new task kfuncs
      bpf: Make bpf_cgroup_acquire() KF_RCU | KF_RET_NULL
      bpf: Remove bpf_cgroup_kptr_get() kfunc
      bpf,docs: Remove references to bpf_cgroup_kptr_get()
      bpf: Remove bpf_kfunc_call_test_kptr_get() test kfunc
      bpf: Remove KF_KPTR_GET kfunc flag
      bpf,docs: Remove KF_KPTR_GET from documentation

Davide Caratti (5):
      net/sched: act_tunnel_key: add support for "don't fragment"
      selftests: tc-testing: add "depends_on" property to skip tests
      selftests: tc-testing: add tunnel_key "nofrag" test case
      selftests: forwarding: add tunnel_key "nofrag" test case
      net/sched: sch_fq: fix integer overflow of "credit"

Dawid Wesierski (1):
      igbvf: add PCI reset handler functions

Deren Wu (3):
      wifi: mt76: remove redundent MCU_UNI_CMD_* definitions
      wifi: mt76: mt7921: fix wrong command to set STA channel
      wifi: mt76: mt7921: fix PCI DMA hang after reboot

Donald Hunter (7):
      tools: ynl: Add struct parsing to nlspec
      tools: ynl: Add C array attribute decoding to ynl
      tools: ynl: Add struct attr decoding to ynl
      tools: ynl: Add fixed-header support to ynl
      netlink: specs: add partial specification for openvswitch
      docs: netlink: document struct support for genetlink-legacy
      docs: netlink: document the sub-type attribute property

Dongliang Mu (1):
      wifi: rtw88: fix memory leak in rtw_usb_probe()

Douglas Anderson (2):
      wifi: ath11k: Use platform_get_irq() to get the interrupt
      wifi: ath5k: Use platform_get_irq() to get the interrupt

Dragos Tatulea (18):
      net/mlx5e: RX, Remove mlx5e_alloc_unit argument in page allocation
      net/mlx5e: RX, Remove alloc unit layout constraint for legacy rq
      net/mlx5e: RX, Remove alloc unit layout constraint for striding rq
      net/mlx5e: RX, Store SHAMPO header pages in array
      net/mlx5e: RX, Remove internal page_cache
      net/mlx5e: RX, Enable dma map and sync from page_pool allocator
      net/mlx5e: RX, Enable skb page recycling through the page_pool
      net/mlx5e: RX, Rename xdp_xmit_bitmap to a more generic name
      net/mlx5e: RX, Defer page release in striding rq for better recycling
      net/mlx5e: RX, Change wqe last_in_page field from bool to bit flags
      net/mlx5e: RX, Defer page release in legacy rq for better recycling
      net/mlx5e: RX, Split off release path for xsk buffers for legacy rq
      net/mlx5e: RX, Increase WQE bulk size for legacy rq
      net/mlx5e: RX, Break the wqe bulk refill in smaller chunks
      net/mlx5e: RX, Remove unnecessary recycle parameter and page_cache stats
      net/mlx5e: RX, Fix releasing page_pool pages twice for striding RQ
      net/mlx5e: RX, Fix XDP_TX page release for legacy rq nonlinear case
      net/mlx5e: RX, Hook NAPIs to page pools

Durai Manickam KR (2):
      net: macb: Add PTP support to GEM for sama7g5
      net: macb: Add PTP support to EMAC for sama7g5

Eduard Zingerman (76):
      bpf: allow ctx writes using BPF_ST_MEM instruction
      selftests/bpf: test if pointer type is tracked for BPF_ST_MEM
      selftests/bpf: Disassembler tests for verifier.c:convert_ctx_access()
      selftests/bpf: Report program name on parse_test_spec error
      selftests/bpf: __imm_insn & __imm_const macro for bpf_misc.h
      selftests/bpf: Unprivileged tests for test_loader.c
      selftests/bpf: Tests execution support for test_loader.c
      selftests/bpf: prog_tests entry point for migrated test_verifier tests
      selftests/bpf: verifier/and.c converted to inline assembly
      selftests/bpf: verifier/array_access.c converted to inline assembly
      selftests/bpf: verifier/basic_stack.c converted to inline assembly
      selftests/bpf: verifier/bounds_deduction.c converted to inline assembly
      selftests/bpf: verifier/bounds_mix_sign_unsign.c converted to inline assembly
      selftests/bpf: verifier/cfg.c converted to inline assembly
      selftests/bpf: verifier/cgroup_inv_retcode.c converted to inline assembly
      selftests/bpf: verifier/cgroup_skb.c converted to inline assembly
      selftests/bpf: verifier/cgroup_storage.c converted to inline assembly
      selftests/bpf: verifier/const_or.c converted to inline assembly
      selftests/bpf: verifier/ctx_sk_msg.c converted to inline assembly
      selftests/bpf: verifier/direct_stack_access_wraparound.c converted to inline assembly
      selftests/bpf: verifier/div0.c converted to inline assembly
      selftests/bpf: verifier/div_overflow.c converted to inline assembly
      selftests/bpf: verifier/helper_access_var_len.c converted to inline assembly
      selftests/bpf: verifier/helper_packet_access.c converted to inline assembly
      selftests/bpf: verifier/helper_restricted.c converted to inline assembly
      selftests/bpf: verifier/helper_value_access.c converted to inline assembly
      selftests/bpf: verifier/int_ptr.c converted to inline assembly
      selftests/bpf: verifier/ld_ind.c converted to inline assembly
      selftests/bpf: verifier/leak_ptr.c converted to inline assembly
      selftests/bpf: verifier/map_ptr.c converted to inline assembly
      selftests/bpf: verifier/map_ret_val.c converted to inline assembly
      selftests/bpf: verifier/masking.c converted to inline assembly
      selftests/bpf: verifier/meta_access.c converted to inline assembly
      selftests/bpf: verifier/raw_stack.c converted to inline assembly
      selftests/bpf: verifier/raw_tp_writable.c converted to inline assembly
      selftests/bpf: verifier/ringbuf.c converted to inline assembly
      selftests/bpf: verifier/spill_fill.c converted to inline assembly
      selftests/bpf: verifier/stack_ptr.c converted to inline assembly
      selftests/bpf: verifier/uninit.c converted to inline assembly
      selftests/bpf: verifier/value_adj_spill.c converted to inline assembly
      selftests/bpf: verifier/value.c converted to inline assembly
      selftests/bpf: verifier/value_or_null.c converted to inline assembly
      selftests/bpf: verifier/var_off.c converted to inline assembly
      selftests/bpf: verifier/xadd.c converted to inline assembly
      selftests/bpf: verifier/xdp.c converted to inline assembly
      libbpf: Fix double-free when linker processes empty sections
      selftests/bpf: Verifier/xdp_direct_packet_access.c converted to inline assembly
      selftests/bpf: Remove verifier/xdp_direct_packet_access.c, converted to progs/verifier_xdp_direct_packet_access.c
      selftests/bpf: Prevent infinite loop in veristat when base file is too short
      selftests/bpf: disable program test run for progs/refcounted_kptr.c
      selftests/bpf: fix __retval() being always ignored
      selftests/bpf: add pre bpf_prog_test_run_opts() callback for test_loader
      selftests/bpf: populate map_array_ro map for verifier_array_access test
      selftests/bpf: Add notion of auxiliary programs for test_loader
      selftests/bpf: verifier/bounds converted to inline assembly
      selftests/bpf: verifier/bpf_get_stack converted to inline assembly
      selftests/bpf: verifier/btf_ctx_access converted to inline assembly
      selftests/bpf: verifier/ctx converted to inline assembly
      selftests/bpf: verifier/d_path converted to inline assembly
      selftests/bpf: verifier/direct_packet_access converted to inline assembly
      selftests/bpf: verifier/jeq_infer_not_null converted to inline assembly
      selftests/bpf: verifier/loops1 converted to inline assembly
      selftests/bpf: verifier/lwt converted to inline assembly
      selftests/bpf: verifier/map_in_map converted to inline assembly
      selftests/bpf: verifier/map_ptr_mixing converted to inline assembly
      selftests/bpf: verifier/ref_tracking converted to inline assembly
      selftests/bpf: verifier/regalloc converted to inline assembly
      selftests/bpf: verifier/runtime_jit converted to inline assembly
      selftests/bpf: verifier/search_pruning converted to inline assembly
      selftests/bpf: verifier/sock converted to inline assembly
      selftests/bpf: verifier/spin_lock converted to inline assembly
      selftests/bpf: verifier/subreg converted to inline assembly
      selftests/bpf: verifier/unpriv converted to inline assembly
      selftests/bpf: verifier/value_illegal_alu converted to inline assembly
      selftests/bpf: verifier/value_ptr_arith converted to inline assembly
      selftests/bpf: verifier/prevent_map_lookup converted to inline assembly

Edward Cree (7):
      sfc: support offloading TC VLAN push/pop actions to the MAE
      sfc: document TC-to-EF100-MAE action translation concepts
      sfc: add notion of match on enc keys to MAE machinery
      sfc: handle enc keys in efx_tc_flower_parse_match()
      sfc: add functions to insert encap matches into the MAE
      sfc: add code to register and unregister encap matches
      sfc: add offloading of 'foreign' TC (decap) rules

Eli Cohen (15):
      lib: cpu_rmap: Avoid use after free on rmap->obj array entries
      lib: cpu_rmap: Use allocator for rmap entries
      lib: cpu_rmap: Add irq_cpu_rmap_remove to complement irq_cpu_rmap_add
      net/mlx5e: Coding style fix, add empty line
      net/mlx5: Fix wrong comment
      net/mlx5: Modify struct mlx5_irq to use struct msi_map
      net/mlx5: Use newer affinity descriptor
      net/mlx5: Improve naming of pci function vectors
      net/mlx5: Refactor completion irq request/release code
      net/mlx5: Use dynamic msix vectors allocation
      net/mlx5: Move devlink registration before mlx5_load
      net/mlx5: Refactor calculation of required completion vectors
      net/mlx5: Use one completion vector if eth is disabled
      net/mlx5: Provide external API for allocating vectors
      net/mlx5: Include linux/pci.h for pci_msix_can_alloc_dyn()

Emeel Hakim (6):
      net/mlx5e: Remove redundant macsec code
      vlan: Add MACsec offload operations for VLAN interface
      net/mlx5: Enable MACsec offload feature for VLAN interface
      net/mlx5: Support MACsec over VLAN
      net/mlx5: Consider VLAN interface in MACsec TX steering rules
      macsec: Don't rely solely on the dst MAC address to identify destination MACsec device

Emil Renner Berthing (2):
      dt-bindings: net: snps,dwmac: Add dwmac-5.20 version
      net: stmmac: platform: Add snps,dwmac-5.20 IP compatible string

Emmanuel Grumbach (2):
      wifi: iwlwifi: make the loop for card preparation effective
      wifi: iwlwifi: mvm: adopt the latest firmware API

Eric Dumazet (58):
      net: remove enum skb_free_reason
      net: reclaim skb->scm_io_uring bit
      net: sched: remove qdisc_watchdog->last_expires
      neighbour: annotate lockless accesses to n->nud_state
      ipv6: remove one read_lock()/read_unlock() pair in rt6_check_neigh()
      tcp: annotate lockless accesses to sk->sk_err_soft
      dccp: annotate lockless accesses to sk->sk_err_soft
      net: annotate lockless accesses to sk->sk_err_soft
      tcp: annotate lockless access to sk->sk_err
      mptcp: annotate lockless accesses to sk->sk_err
      af_unix: annotate lockless accesses to sk->sk_err
      net/packet: annotate accesses to po->xmit
      net/packet: convert po->origdev to an atomic flag
      net/packet: convert po->auxdata to an atomic flag
      net/packet: annotate accesses to po->tp_tstamp
      net/packet: convert po->tp_tx_has_off to an atomic flag
      net/packet: convert po->tp_loss to an atomic flag
      net/packet: convert po->has_vnet_hdr to an atomic flag
      net/packet: convert po->running to an atomic flag
      net/packet: convert po->pressure to an atomic flag
      inet: preserve const qualifier in inet_sk()
      ipv4: constify ip_mc_sf_allow() socket argument
      udp: constify __udp_is_mcast_sock() socket argument
      ipv6: constify inet6_mc_check()
      udp6: constify __udp_v6_is_mcast_sock() socket argument
      ipv6: raw: constify raw_v6_match() socket argument
      ipv4: raw: constify raw_v4_match() socket argument
      inet_diag: constify raw_lookup() socket argument
      udp: preserve const qualifier in udp_sk()
      af_packet: preserve const qualifier in pkt_sk()
      raw: preserve const qualifier in raw_sk()
      ipv6: raw: preserve const qualifier in raw6_sk()
      dccp: preserve const qualifier in dccp_sk()
      af_unix: preserve const qualifier in unix_sk()
      smc: preserve const qualifier in smc_sk()
      x25: preserve const qualifier in [a]x25_sk()
      mptcp: preserve const qualifier in mptcp_sk()
      tcp: preserve const qualifier in tcp_sk()
      net/packet: remove po->xmit
      ipv6: flowlabel: do not disable BH where not needed
      neighbour: switch to standard rcu, instead of rcu_bh
      net: remove rcu_dereference_bh_rtnl()
      net: do not use skb_mac_header() in qdisc_pkt_len_init()
      sch_cake: do not use skb_mac_header() in cake_overhead()
      net/sched: remove two skb_mac_header() uses
      net: introduce a config option to tweak MAX_SKB_FRAGS
      net: napi_schedule_rps() cleanup
      net: add softnet_data.in_net_rx_action
      net: optimize napi_schedule_rps()
      net: optimize ____napi_schedule() to avoid extra NET_RX_SOFTIRQ
      selftests/net: fix typo in tcp_mmap
      net: make SO_BUSY_POLL available to all users
      wifi: mac80211_hwsim: fix potential NULL deref in hwsim_pmsr_report_nl()
      net: add debugging checks in skb_attempt_defer_free()
      net: do not provide hard irq safety for sd->defer_lock
      net: move skb_defer_free_flush() up
      net: make napi_threaded_poll() aware of sd->defer_list
      net: optimize napi_threaded_poll() vs RPS/RFS

Eric Huang (2):
      wifi: rtw89: use hardware CFO to improve performance
      wifi: rtw89: correct 5 MHz mask setting

Eric Sage (1):
      netfilter: nfnetlink_queue: enable classid socket info retrieval

Fedor Pchelkin (2):
      wifi: ath9k: hif_usb: fix memory leak of remain_skbs
      wifi: ath6kl: reduce WARN to dev_dbg() in callback

Felix Fietkau (14):
      wifi: mac80211: add support for letting drivers register tc offload support
      wifi: mac80211: fix race in mesh sequence number assignment
      wifi: mac80211: mesh fast xmit support
      wifi: mac80211: use mesh header cache to speed up mesh forwarding
      wifi: mac80211: add mesh fast-rx support
      wifi: mac80211: implement support for yet another mesh A-MSDU format
      net: ethernet: mtk_eth_soc: add code for offloading flows from wlan devices
      net: ethernet: mtk_eth_soc: mtk_ppe: prefer newly added l2 flows
      wifi: mt76: add missing locking to protect against concurrent rx/status calls
      wifi: mac80211: remove ieee80211_tx_status_8023
      wifi: mt76: mt7615: increase eeprom size for mt7663
      wifi: mt76: dma: use napi_build_skb
      wifi: mt76: set NL80211_EXT_FEATURE_CAN_REPLACE_PTK0 on supported drivers
      net: mtk_eth_soc: mediatek: fix ppe flow accounting for v1 hardware

Feng Zhou (4):
      bpf/btf: Fix is_int_ptr()
      selftests/bpf: Add test to access u32 ptr argument in tracing program
      bpf: support access variable length array of integer type
      selftests/bpf: Add test to access integer type of variable array

Florent Revest (1):
      selftests/bpf: Fix cross compilation with CLANG_CROSS_FLAGS

Florian Fainelli (1):
      net: phy: Improved PHY error reporting in state machine

Florian Westphal (21):
      netlink: remove unused 'compare' function
      netfilter: xtables: disable 32bit compat interface by default
      xtables: move icmp/icmpv6 logic to xt_tcpudp
      netfilter: nfnetlink_log: remove rcu_bh usage
      bpf: add bpf_link support for BPF_NETFILTER programs
      bpf: minimal support for programs hooked into netfilter framework
      netfilter: nfnetlink hook: dump bpf prog id
      netfilter: disallow bpf hook attachment at same priority
      tools: bpftool: print netfilter link info
      bpf: add test_run support for netfilter program type
      selftests/bpf: add missing netfilter return value and ctx access tests
      netfilter: nf_tables: merge nft_rules_old structure and end of ruleblob marker
      netfilter: nf_tables: don't store address of last rule on jump
      netfilter: nf_tables: don't store chain address on jump
      netfilter: nf_tables: don't write table validation state without mutex
      netfilter: nf_tables: make validation state per table
      netfilter: nf_tables: remove unneeded conditional
      netfilter: nf_tables: do not store pktinfo in traceinfo structure
      netfilter: nf_tables: do not store verdict in traceinfo structure
      netfilter: nf_tables: do not store rule in traceinfo structure
      bpf: fix link failure with NETFILTER=y INET=n

Frank Jungclaus (2):
      can: esd_usb: Improve code readability by means of replacing struct esd_usb_msg with a union
      can: esd_usb: Add support for CAN_CTRLMODE_BERR_REPORTING

Frank Wunderlich (1):
      dt-bindings: mt76: add active-low property for led

Gal Pressman (6):
      skbuff: Replace open-coded skb_propagate_pfmemalloc()s
      skbuff: Add likely to skb pointer in build_skb()
      net/mlx5: Move needed PTYS functions to core layer
      net/mlx5e: Add devlink hairpin queues parameters
      net/mlx5e: Add more information to hairpin table dump
      net/mlx5e: Rename misleading skb_pc/cc references in ptp code

Ganesh Babu Jothiram (1):
      wifi: ath11k: Configure the FTM responder role using firmware capability flag

Gavin Li (5):
      vxlan: Remove unused argument from vxlan_build_gbp_hdr( ) and vxlan_build_gpe_hdr( )
      vxlan: Expose helper vxlan_build_gbp_hdr
      net/mlx5e: Add helper for encap_info_equal for tunnels with options
      ip_tunnel: Preserve pointer const in ip_tunnel_info_opts
      net/mlx5e: TC, Add support for VxLAN GBP encap/decap flows offload

Geert Uytterhoeven (5):
      net: ethernet: ti: am65-cpsw: Convert to devm_of_phy_optional_get()
      can: rcar_canfd: Add transceiver support
      can: rcar_canfd: Improve error messages
      can: rcar_canfd: rcar_canfd_probe(): fix plain integer in transceivers[] init
      net/handshake: Fix section mismatch in handshake_exit

Geliang Tang (2):
      selftests: mptcp: add mptcp_info tests
      mptcp: make userspace_pm_append_new_local_addr static

Gencen Gan (1):
      net: amd: Fix link leak when verifying config failed

Gerhard Engleder (6):
      tsnep: Replace modulo operation with mask
      tsnep: Rework TX/RX queue initialization
      tsnep: Add functions for queue enable/disable
      tsnep: Move skb receive action to separate function
      tsnep: Add XDP socket zero-copy RX support
      tsnep: Add XDP socket zero-copy TX support

Golan Ben Ami (4):
      wifi: iwlwifi: reduce verbosity of some logging events
      wifi: iwlwifi: Add support for B step of BnJ-Fm4
      wifi: iwlwifi: mvm: enable bz hw checksum from c step
      wifi: iwlwifi: move debug buffer allocation failure to info verbosity

Gregory Greenman (29):
      wifi: iwlwifi: mvm: fix NULL deref in iwl_mvm_mld_disable_txq
      wifi: iwlwifi: mvm: vif preparation for MLO
      wifi: iwlwifi: mvm: sta preparation for MLO
      wifi: iwlwifi: mvm: adjust smart fifo configuration to MLO
      wifi: iwlwifi: mvm: adjust mld_mac_ctxt_/beacon_changed() for MLO
      wifi: iwlwifi: mvm: adjust some PS and PM methods to MLD
      wifi: iwlwifi: mvm: adjust SMPS for MLO
      wifi: iwlwifi: mvm: add link_conf parameter for add/remove/change link
      wifi: iwlwifi: mvm: replace bss_info_changed() with vif_cfg/link_info_changed()
      wifi: iwlwifi: mvm: adjust internal stations to MLO
      wifi: iwlwifi: mvm: add fw link id allocation
      wifi: iwlwifi: mvm: adjust to MLO assign/unassign/switch_vif_chanctx()
      wifi: iwlwifi: mvm: update iwl_mvm_tx_reclaim() for MLO
      wifi: iwlwifi: mvm: refactor iwl_mvm_mac_sta_state_common()
      wifi: iwlwifi: mvm: adjust some cleanup functions to MLO
      wifi: iwlwifi: mvm: adjust iwl_mvm_sec_key_remove_ap to MLO
      wifi: iwlwifi: mvm: adjust radar detection to MLO
      wifi: iwlwifi: mvm: adjust rs init to MLO
      wifi: iwlwifi: mvm: update mac config when assigning chanctx
      wifi: iwlwifi: mvm: rework active links counting
      wifi: iwlwifi: mvm: move max_agg_bufsize into host TLC lq_sta
      wifi: iwlwifi: bump FW API to 75 for AX devices
      wifi: iwlwifi: mvm: fix the order of TIMING_MEASUREMENT notifications
      wifi: iwlwifi: fix duplicate entry in iwl_dev_info_table
      wifi: iwlwifi: call napi_synchronize() before freeing rx/tx queues
      wifi: iwlwifi: bump FW API to 77 for AX devices
      wifi: iwlwifi: mvm: update mac id management
      wifi: iwlwifi: bump FW API to 78 for AX devices
      wifi: iwlwifi: mvm: enable support for MLO APIs

Grygorii Strashko (3):
      net: ethernet: ti: am65-cpts: adjust estf following ptp changes
      net: ethernet: ti: am65-cpsw: add .ndo to set dma per-queue rate
      net: ethernet: ti: am65-cpsw: enable p0 host port rx_vlan_remap

Gustavo A. R. Silva (10):
      netxen_nic: Replace fake flex-array with flexible-array member
      net/mlx4_en: Replace fake flex-array with flexible-array member
      wifi: ath11k: Replace fake flex-array with flexible-array member
      wifi: carl9170: Fix multiple -Warray-bounds warnings
      wifi: carl9170: Replace fake flex-array with flexible-array member
      wifi: rndis_wlan: Replace fake flex-array with flexible-array member
      wifi: rtlwifi: Replace fake flex-array with flex-array member
      wifi: mt76: Replace zero-length array with flexible-array member
      wifi: mt76: mt7921: Replace fake flex-arrays with flexible-array members
      rxrpc: Replace fake flex-array with flexible-array member

Haim Dreyfuss (1):
      wifi: iwlwifi: mvm: support wowlan info notification version 2

Haiyang Zhang (6):
      net: mana: Use napi_build_skb in RX path
      net: mana: Refactor RX buffer allocation code to prepare for various MTU
      net: mana: Enable RX path to handle various MTU sizes
      net: mana: Add support for jumbo frame
      net: mana: Rename mana_refill_rxoob and remove some empty lines
      net: mana: Check if netdev/napi_alloc_frag returns single page

Hangbin Liu (3):
      selftests/bpf: move SYS() macro into the test_progs.h
      selftests/bpf: run mptcp in a dedicated netns
      bonding: add software tx timestamping support

Hans de Goede (6):
      wifi: brcmfmac: Use ISO3166 country code and rev 0 as fallback on 4356
      wifi: iwlwifi: dvm: Fix memcpy: detected field-spanning write backtrace
      Bluetooth: hci_bcm: Fall back to getting bdaddr from EFI if not set
      Bluetooth: hci_bcm: Limit bcm43430a0 / bcm43430a1 baudrate to 2000000
      Bluetooth: hci_bcm: Add Lenovo Yoga Tablet 2 830 / 1050 to the bcm_broken_irq_dmi_table
      Bluetooth: hci_bcm: Add Acer Iconia One 7 B1-750 to the bcm_broken_irq_dmi_table

Hao Lan (1):
      net: hns3: support wake on lan configuration and query

Hao Zeng (1):
      samples/bpf: Fix fout leak in hbm's run_bpf_prog

Harini Katakam (5):
      net: macb: Increase halt timeout to accommodate 10Mbps link
      net: macb: Reset TX when TX halt times out
      net: macb: Update gem PTP support check
      net: macb: Enable PTP unicast
      net: macb: Optimize reading HW timestamp

Harshit Mogalapalli (1):
      wifi: ath12k: Add missing unwind goto in ath12k_pci_probe()

Harshitha Prem (8):
      wifi: ath11k: fix BUFFER_DONE read on monitor ring rx  buffer
      wifi: ath12k: fix incorrect handling of AMSDU frames
      wifi: ath12k: incorrect channel survey dump
      wifi: ath11k: Ignore frags from uninitialized peer in dp.
      wifi: ath11k: fix undefined behavior with __fls in dp
      wifi: ath11k: fix double free of peer rx_tid during reo cmd failure
      wifi: ath11k: Prevent REO cmd failures
      wifi: ath11k: add peer mac information in failure cases

Hector Martin (13):
      wifi: brcmfmac: acpi: Add support for fetching Apple ACPI properties
      wifi: brcmfmac: pcie: Provide a buffer of random bytes to the device
      wifi: brcmfmac: chip: Only disable D11 cores; handle an arbitrary number
      wifi: brcmfmac: chip: Handle 1024-unit sizes for TCM blocks
      wifi: brcmfmac: cfg80211: Add support for scan params v2
      wifi: brcmfmac: feature: Add support for setting feats based on WLC version
      wifi: brcmfmac: cfg80211: Add support for PMKID_V3 operations
      wifi: brcmfmac: cfg80211: Pass the PMK in binary instead of hex
      wifi: brcmfmac: pcie: Add IDs/properties for BCM4387
      wifi: brcmfmac: common: Add support for downloading TxCap blobs
      wifi: brcmfmac: pcie: Load and provide TxCap blobs
      wifi: brcmfmac: common: Add support for external calibration blobs
      wifi: brcmfmac: pcie: Add BCM4378B3 support

Heiner Kallweit (26):
      net: phy: improve phy_read_poll_timeout
      net: phy: smsc: simplify lan95xx_config_aneg_ext
      r8169: use spinlock to protect mac ocp register access
      r8169: use spinlock to protect access to registers Config2 and Config5
      r8169: enable cfg9346 config register access in atomic context
      r8169: prepare rtl_hw_aspm_clkreq_enable for usage in atomic context
      r8169: disable ASPM during NAPI poll
      r8169: remove ASPM restrictions now that ASPM is disabled during NAPI poll
      net: phy: smsc: use phy_set_bits in smsc_phy_config_init
      net: phy: smsc: use device_property_present in smsc_phy_probe
      net: phy: smsc: export functions for use by meson-gxl PHY driver
      net: phy: meson-gxl: reuse functionality of the SMSC PHY driver
      r8169: consolidate disabling ASPM before EPHY access
      net: phy: bcm7xxx: use devm_clk_get_optional_enabled to simplify the code
      dev_ioctl: fix a W=1 warning
      net: phy: smsc: rename flag energy_enable
      net: phy: smsc: add helper smsc_phy_config_edpd
      net: phy: smsc: clear edpd_enable if interrupt mode is used
      net: phy: smsc: add flag edpd_mode_set_by_user
      net: phy: smsc: prepare for making edpd wait period configurable
      net: phy: smsc: add support for edpd tunable
      net: phy: smsc: enable edpd tunable support
      net: phy: meson-gxl: enable edpd tunable support for G12A internal PHY
      net: add macro netif_subqueue_completed_wake
      r8169: use new macro netif_subqueue_maybe_stop in rtl8169_start_xmit
      r8169: use new macro netif_subqueue_completed_wake in the tx cleanup path

Hengqi Chen (2):
      LoongArch: BPF: Support mixing bpf2bpf and tailcalls
      selftests/bpf: Don't assume page size is 4096

Herbert Xu (5):
      xfrm: Remove inner/outer modes from input path
      xfrm: Remove inner/outer modes from output path
      macvlan: Skip broadcast queue if multicast with single receiver
      macvlan: Add netlink attribute for broadcast cutoff
      macvlan: Fix mc_filter calculation

Horatiu Vultur (14):
      net: lan966x: Add IS1 VCAP model
      net: lan966x: Add IS1 VCAP keyset configuration for lan966x
      net: lan966x: Add TC support for IS1 VCAP
      net: lan966x: Add TC filter chaining support for IS1 and IS2 VCAPs
      net: lan966x: Add support for IS1 VCAP ethernet protocol types
      net: phy: micrel: Add support for PTP_PF_PEROUT for lan8841
      net: lan966x: Change lan966x_police_del return type
      net: lan966x: Don't read RX timestamp if not needed
      net: lan966x: Stop using packing library
      net: phy: micrel: Add support for PTP_PF_EXTTS for lan8841
      net: phy: micrel: Fix PTP_PF_PEROUT for lan8841
      net: lan966x: Fix lan966x_ifh_get
      net: micrel: Update the list of supported phys
      lan966x: Don't use xdp_frame when action is XDP_TX

Hou Tao (1):
      bpf: Only allocate one bpf_mem_cache for bpf_cpumask_ma

Howard Hsu (1):
      wifi: mt76: mt7915: rework init flow in mt7915_thermal_init()

Huanhuan Wang (1):
      nfp: fix incorrect pointer deference when offloading IPsec with bonding

Hyunwoo Kim (1):
      wifi: iwlwifi: pcie: Fix integer overflow in iwl_write_to_user_buf

Ido Schimmel (23):
      net: Add MDB net device operations
      bridge: mcast: Implement MDB net device operations
      rtnetlink: bridge: mcast: Move MDB handlers out of bridge driver
      rtnetlink: bridge: mcast: Relax group address validation in common code
      vxlan: Move address helpers to private headers
      vxlan: Expose vxlan_xmit_one()
      vxlan: mdb: Add MDB control path support
      vxlan: mdb: Add an internal flag to indicate MDB usage
      vxlan: Add MDB data path support
      vxlan: Enable MDB support
      selftests: net: Add VXLAN MDB test
      mlxsw: core_thermal: Use static trip points for transceiver modules
      mlxsw: core_thermal: Make mlxsw_thermal_module_init() void
      mlxsw: core_thermal: Simplify transceiver module get_temp() callback
      bridge: Reorder neighbor suppression check when flooding
      bridge: Pass VLAN ID to br_flood()
      bridge: Add internal flags for per-{Port, VLAN} neighbor suppression
      bridge: Take per-{Port, VLAN} neighbor suppression into account
      bridge: Encapsulate data path neighbor suppression logic
      bridge: Add per-{Port, VLAN} neighbor suppression data path support
      bridge: vlan: Allow setting VLAN neighbor suppression state
      bridge: Allow setting per-{Port, VLAN} neighbor suppression state
      selftests: net: Add bridge neighbor suppression test

Ilan Peer (5):
      wifi: nl80211: Update the documentation of NL80211_SCAN_FLAG_COLOCATED_6GHZ
      wifi: mac80211_hwsim: Indicate support for NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT
      wifi: iwlwifi: Do not include radiotap EHT user info if not needed
      wifi: iwlwifi: mvm: Fix setting the rate for non station cases
      wifi: iwlwifi: mvm: Fix _iwl_mvm_get_scan_type()

Ilpo Järvinen (1):
      Bluetooth: hci_ldisc: Fix tty_set_termios() return value assumptions

Ilya Leoshkevich (4):
      bpf: Check for helper calls in check_subprogs()
      libbpf: Document bpf_{btf,link,map,prog}_get_info_by_fd()
      selftests/bpf: Add RESOLVE_BTFIDS dependency to bpf_testmod.ko
      bpf: Support 64-bit pointers to kfuncs

Inga Stotland (1):
      Bluetooth: hci_sync: Remove duplicate statement

Iulia Tanasescu (2):
      Bluetooth: Split bt_iso_qos into dedicated structures
      Bluetooth: hci_conn: remove extra line in hci_le_big_create_sync

Ivan Vecera (2):
      bnxt_en: Allow to set switchdev mode without existing VFs
      net/sched: cls_api: Initialize miss_cookie_node when action miss is not used

JP Kobryn (3):
      bpf/selftests: coverage for bpf_map_ops errors
      bpf: return long from bpf_map_ops funcs
      libbpf: Ensure print callback usage is thread-safe

Jacob Keller (18):
      wifi: nl80211: convert cfg80211_scan_request allocation to *_size macros
      wifi: ipw2x00: convert ipw_fw_error->elem to flexible array[]
      wifi: qtnfmac: use struct_size and size_sub for payload length
      ice: re-order ice_mbx_reset_snapshot function
      ice: convert ice_mbx_clear_malvf to void and use WARN
      ice: track malicious VFs in new ice_mbx_vf_info structure
      ice: move VF overflow message count into struct ice_mbx_vf_info
      ice: remove ice_mbx_deinit_snapshot
      ice: merge ice_mbx_report_malvf with ice_mbx_vf_state_handler
      ice: initialize mailbox snapshot earlier in PF init
      ice: declare ice_vc_process_vf_msg in ice_virtchnl.h
      ice: always report VF overflowing mailbox even without PF VSI
      ice: remove unnecessary &array[0] and just use array
      ice: pass mbxdata to ice_is_malicious_vf()
      ice: print message if ice_mbx_vf_state_handler returns an error
      ice: move ice_is_malicious_vf() to ice_virtchnl.c
      ice: call ice_is_malicious_vf() from ice_vc_process_vf_msg()
      ice: remove comment about not supporting driver reinit

Jaewan Kim (5):
      mac80211_hwsim: add PMSR capability support
      wifi: nl80211: make nl80211_send_chandef non-static
      mac80211_hwsim: add PMSR request support via virtio
      mac80211_hwsim: add PMSR abort support via virtio
      mac80211_hwsim: add PMSR report support via virtio

Jaime Breva (1):
      net: wwan: Expose secondary AT port on DATA1

Jakub Kicinski (118):
      Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge branch 'pci-aer-remove-redundant-device-control-error-reporting-enable'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'main' of git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'net-lan966x-add-support-for-is1-vcap'
      Merge branch 'couple-of-minor-improvements-to-build_skb-variants'
      Merge branch 'rework-sfp-a2-access-conditionals'
      Merge tag 'wireless-next-2023-03-10' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
      Merge branch 'update-cpsw-bindings-for-serdes-phy'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'ipv6-optimize-rt6_score_route'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge mlx5 updates 2023-03-13
      Merge branch 'nfp-flower-add-support-for-multi-zone-conntrack'
      Merge branch 'add-ptp-support-for-sama7g5'
      netlink-specs: add partial specification for devlink
      netlink: specs: allow uapi-header in genetlink
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'net-dsa-mv88e6xxx-accelerate-c45-scan'
      Merge branch 'net-mlx5e-add-gbp-vxlan-hw-offload-support'
      Merge branch 'net-ethernet-mtk_eth_soc-various-enhancements'
      net: skbuff: rename __pkt_vlan_present_offset to __mono_tc_offset
      net: skbuff: reorder bytes 2 and 3 of the bitfield
      net: skbuff: move the fields BPF cares about directly next to the offset marker
      Merge branch 'net-remove-some-rcu_bh-cruft'
      tools: ynl: skip the explicit op array size when not needed
      Merge branch 'bnxt-ptp-optimizations'
      Merge branch 'net-dsa-b53-configure-6318-and-63268-rgmii-ports'
      Merge tag 'ipsec-libreswan-mlx5' of https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux
      Merge branch 'add-cpswxg-sgmii-support-for-j7200-and-j721e'
      Merge branch 'remove-phylink_state-s-an_enabled-member'
      Merge branch 'net-remove-some-skb_mac_header-assumptions'
      Merge branch 'quirk-for-oem-sfp-2-5g-t-copper-module'
      Merge branch 'net-ipa-fully-support-ipa-v5-0'
      docs: networking: document NAPI
      docs: netdev: add note about Changes Requested and revising commit messages
      Merge branch 'main' of ssh://gitolite.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      selftests: tls: add a test for queuing data before setting the ULP
      tools: ynl: default to treating enums as flags for mask generation
      Merge branch 'add-tx-push-buf-len-param-to-ethtool'
      Merge tag 'linux-can-next-for-6.4-20230327' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge branch 'locking/rcuref' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
      Merge branch 'net-refcount-address-dst_entry-reference-count-scalability-issues'
      docs: netdev: clarify the need to sending reverts as patches
      Merge tag 'mlx5-updates-2023-03-20' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'ynl-add-support-for-user-headers-and-struct-attrs'
      Merge tag 'mlx5-updates-2023-03-28' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'net-sched-act_tunnel_key-add-support-for-tunnel_dont_fragment'
      Merge branch 'tools-ynl-fill-in-some-gaps-of-ethtool-spec'
      Merge tag 'wireless-next-2023-03-30' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
      Merge tag 'nf-next-2023-03-30' of https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      net: minor reshuffle of napi_struct
      Merge branch 'sfc-support-unicast-ptp'
      Merge tag 'linux-can-next-for-6.4-20230404-2' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge tag 'wireless-next-2023-04-05' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge tag 'mlx5-updates-2023-04-05' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'add-support-for-j784s4-cpsw9g'
      Merge tag 'ipsec-esn-replay' of https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux
      Merge branch 'net-stmmac-dwmac-anarion-address-issues-flagged-by-sparse'
      Merge branch 'hwmon-const' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging
      docs: net: reformat driver.rst from a list to sections
      docs: net: move the probe and open/close sections of driver.rst up
      docs: net: use C syntax highlight in driver.rst
      net: provide macros for commonly copied lockless queue stop/wake code
      ixgbe: use new queue try_stop/try_wake macros
      bnxt: use new queue try_stop/try_wake macros
      net: piggy back on the memory barrier in bql when waking queues
      Merge branch 'net-lockless-stop-wake-combo-macros'
      tools: ynl: throw a more meaningful exception if family not supported
      Merge branch 'net-thunderbolt-fix-for-sparse-warnings-and-typos'
      net: docs: update the sample code in driver.rst
      bnxt: use READ_ONCE/WRITE_ONCE for ring indexes
      mlx4: use READ_ONCE/WRITE_ONCE for ring indexes
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Daniel Borkmann says:
      Merge branch 'ocelot-felix-driver-cleanup'
      Merge branch 'macb-ptp-minor-updates'
      Merge branch 'add-kernel-tc-mqprio-and-tc-taprio-support-for-preemptible-traffic-classes'
      Merge tag 'mlx5-updates-2023-04-11' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      net: skb: plumb napi state thru skb freeing paths
      page_pool: allow caching from safely localized NAPI
      bnxt: hook NAPIs to page pools
      Merge branch 'page_pool-allow-caching-from-safely-localized-napi'
      Merge branch 'support-tunnel-mode-in-mlx5-ipsec-packet-offload'
      Merge branch 'xdp-rx-hwts-metadata-for-stmmac-driver'
      Merge branch 'ocelot-felix-driver-support-for-preemptible-traffic-classes'
      net: skbuff: hide wifi_acked when CONFIG_WIRELESS not set
      net: skbuff: hide csum_not_inet when CONFIG_IP_SCTP not set
      net: skbuff: move alloc_cpu into a potential hole
      net: skbuff: push nf_trace down the bitfield
      net: skbuff: hide nf_trace and ipvs_property
      page_pool: add DMA_ATTR_WEAK_ORDERING on all mappings
      Merge tag 'ipsec-next-2023-04-19' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next
      Merge branch 'another-crack-at-a-handshake-upcall-mechanism'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      page_pool: unlink from napi during destroy
      eth: mlx5: avoid iterator use outside of a loop
      net: skbuff: update and rename __kfree_skb_defer()
      Merge branch 'ethtool-mm-api-consolidation'
      Merge branch 'net-extend-drop-reasons'
      Merge tag 'wireless-next-2023-04-21' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
      Merge tag 'nf-23-04-21' of git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf
      Merge branch '10GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge tag 'mlx5-fixes-2023-04-20' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge tag 'mlx5-updates-2023-04-20' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge tag 'nf-next-23-04-22' of git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next
      Merge branch 'add-page_pool-support-for-page-recycling-in-veth-driver'
      Merge branch 'update-coding-style-and-check-alloc_frag'
      net: ethtool: coalesce: try to make user settings stick twice
      Merge branch 'tsnep-xdp-socket-zero-copy-support'
      Merge tag 'for-netdev' of https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next

James Hilliard (1):
      selftests/bpf: Fix conflicts with built-in functions in bench_local_storage_create

Jason Xing (2):
      udp: introduce __sk_mem_schedule() usage
      net-sysfs: display two backlog queue len separately

Jens Axboe (2):
      tun: flag the device as supporting FMODE_NOWAIT
      tap: add support for IOCB_NOWAIT

Jeremi Piotrowski (1):
      ptp: kvm: Use decrypted memory in confidential guest on x86

Jeremy Sowden (4):
      netfilter: conntrack: fix typo
      netfilter: nat: fix indentation of function arguments
      netfilter: nft_redir: use `struct nf_nat_range2` throughout and deduplicate eval call-backs
      netfilter: nft_masq: deduplicate eval call-backs

Jernej Skrabec (1):
      wifi: rtw88: Add support for the SDIO based RTL8822BS chipset

Jeroen de Borst (1):
      gve: update MAINTAINERS

Jianfeng Tan (1):
      net/packet: support mergeable feature of virtio

Jianuo Kuang (1):
      drivers: nfc: nfcsim: remove return value check of `dev_dir`

Jiapeng Chong (6):
      wifi: ath10k: Remove redundant assignment to changed_flags
      wifi: rtlwifi: rtl8192de: Remove the unused variable bcnfunc_enable
      wifi: rtlwifi: rtl8192se: Remove some unused variables
      emulex/benet: clean up some inconsistent indenting
      wifi: b43legacy: Remove the unused function prev_slot()
      net: fddi: skfp: rmt: Clean up some inconsistent indenting

Jiaxun Yang (2):
      bpf, mips: Implement DADDI workarounds for JIT
      bpf, mips: Implement R4000 workarounds for JIT

Jiefeng Li (1):
      wifi: mt76: mt7921: fix missing unwind goto in `mt7921u_probe`

Jiri Olsa (4):
      selftests/bpf: Add err.h header
      selftests/bpf: Add read_build_id function
      selftests/bpf: Replace extract_build_id with read_build_id
      kallsyms: Disable preemption for find_kallsyms_symbol_value

Jiri Pirko (3):
      net: virtio_net: implement exact header length guest feature
      net/mlx5: Add comment to mlx5_devlink_params_register()
      ynl: allow to encode u8 attr

Jisoo Jang (1):
      wifi: brcmfmac: slab-out-of-bounds read in brcmf_get_assoc_ies()

Joanne Koong (11):
      bpf: Support "sk_buff" and "xdp_buff" as valid kfunc arg types
      bpf: Refactor process_dynptr_func
      bpf: Allow initializing dynptrs in kfuncs
      bpf: Define no-ops for externally called bpf dynptr functions
      bpf: Refactor verifier dynptr into get_dynptr_arg_reg
      bpf: Add __uninit kfunc annotation
      bpf: Add skb dynptrs
      bpf: Add xdp dynptrs
      bpf: Add bpf_dynptr_slice and bpf_dynptr_slice_rdwr
      selftests/bpf: tests for using dynptrs to parse skb and xdp buffers
      bpf: Fix bpf_dynptr_slice{_rdwr} to return NULL instead of 0

Joe Damato (2):
      ixgbe: Allow flow hash to be set via ethtool
      ixgbe: Enable setting RSS table to default values

Johan Hovold (1):
      dt-bindings: net: wireless: add ath11k pcie bindings

Johannes Berg (86):
      wifi: mac80211: adjust scan cancel comment/check
      wifi: mac80211: check key taint for beacon protection
      wifi: mac80211: allow beacon protection HW offload
      wifi: cfg80211/mac80211: report link ID on control port RX
      wifi: mac80211: warn only once on AP probe
      wifi: mac80211: mlme: remove pointless sta check
      wifi: mac80211: simplify reasoning about EHT capa handling
      wifi: mac80211: fix ieee80211_link_set_associated() type
      wifi: iwlwifi: mvm: avoid UB shift of snif_queue
      wifi: iwlwifi: mvm: make flush code a bit clearer
      wifi: iwlwifi: mvm: fix EOF bit reporting
      wifi: iwlwifi: mvm: avoid sta lookup in queue alloc
      wifi: iwlwifi: mvm: rs: print BAD_RATE for invalid HT/VHT index
      wifi: iwlwifi: fw: pnvm: fix uefi reduced TX power loading
      wifi: iwlwifi: suppress printf warnings in tracing
      wifi: iwlwifi: mvm: enable TX beacon protection
      wifi: iwlwifi: mvm: add link to firmware earlier
      wifi: iwlwifi: mvm: don't check dtim_period in new API
      wifi: iwlwifi: mvm: implement link change ops
      wifi: iwlwifi: mvm: make some HW flags conditional
      wifi: iwlwifi: mvm: fix narrow RU check for MLO
      wifi: iwlwifi: mvm: skip MEI update for MLO
      wifi: iwlwifi: mvm: use STA link address
      wifi: iwlwifi: mvm: rs-fw: don't crash on missing channel
      wifi: iwlwifi: mvm: coex: start handling multiple links
      wifi: iwlwifi: mvm: make a few warnings only trigger once
      wifi: iwlwifi: mvm: rxmq: report link ID to mac80211
      wifi: iwlwifi: mvm: skip inactive links
      wifi: iwlwifi: mvm: remove only link-specific AP keys
      wifi: iwlwifi: mvm: avoid sending MAC context for idle
      wifi: iwlwifi: mvm: remove chanctx WARN_ON
      wifi: iwlwifi: mvm: use the new lockdep-checking macros
      wifi: iwlwifi: mvm: fix station link data leak
      wifi: iwlwifi: mvm: clean up mac_id vs. link_id in MLD sta
      wifi: iwlwifi: mvm: send full STA during HW restart
      wifi: iwlwifi: mvm: free probe_resp_data later
      wifi: iwlwifi: separate AP link management queues
      wifi: iwlwifi: mvm: correctly use link in iwl_mvm_sta_del()
      wifi: clean up erroneously introduced file
      Merge wireless/main into wireless-next/main
      wifi: iwlwifi: debug: fix crash in __iwl_err()
      wifi: iwlwifi: nvm-parse: enable 160/320 MHz for AP mode
      wifi: iwlwifi: mvm: convert TID to FW value on queue remove
      wifi: iwlwifi: mvm: fix A-MSDU checks
      wifi: iwlwifi: mvm: refactor TX csum mode check
      wifi: ieee80211: clean up public action codes
      wifi: ieee80211: correctly mark FTM frames non-bufferable
      wifi: mac80211: flush queues on STA removal
      wifi: mac80211: add flush_sta method
      wifi: iwlwifi: mvm: request limiting to 8 MSDUs per A-MSDU
      wifi: iwlwifi: mvm: add DSM_FUNC_ENABLE_6E value to debugfs
      wifi: iwlwifi: pcie: work around ROM bug on AX210 integrated
      wifi: iwlwifi: mvm: track AP STA pointer and use it for MFP
      wifi: iwlwifi: mvm: make iwl_mvm_mac_ctxt_send_beacon() static
      wifi: iwlwifi: mvm: fix ptk_pn memory leak
      wifi: iwlwifi: mvm: set STA mask for keys in MLO
      wifi: iwlwifi: mvm: validate station properly in flush
      wifi: iwlwifi: mvm: tx: remove misleading if statement
      wifi: iwlwifi: nvm-parse: add full BW UL MU-MIMO support
      wifi: iwlwifi: mvm: fix getting lowest TX rate for MLO
      wifi: iwlwifi: mvm: properly implement HE AP support
      wifi: iwlwifi: mvm: factor out iwl_mvm_sta_fw_id_mask()
      wifi: iwlwifi: mvm: use correct sta mask to remove queue
      wifi: iwlwifi: mvm: track station mask for BAIDs
      wifi: iwlwifi: mvm: implement BAID link switching
      wifi: iwlwifi: mvm: implement key link switching
      wifi: iwlwifi: mvm: allow number of beacons from FW
      wifi: iwlwifi: mvm: use BSSID when building probe requests
      wifi: iwlwifi: mvm: allow NL80211_EXT_FEATURE_SCAN_MIN_PREQ_CONTENT
      wifi: iwlwifi: mvm: remove per-STA MFP setting
      wifi: iwlwifi: mvm: fix iwl_mvm_sta_rc_update for MLO
      wifi: iwlwifi: mvm: only clients can be 20MHz-only
      wifi: iwlwifi: mvm: rs-fw: properly access sband->iftype_data
      wifi: iwlwifi: mvm: initialize per-link STA ratescale data
      wifi: iwlwifi: mvm: remove RS rate init update argument
      wifi: iwlwifi: fix iwl_mvm_max_amsdu_size() for MLO
      wifi: iwlwifi: mvm: configure TLC on link activation
      wifi: iwlwifi: mvm: add MLO support to SF - use sta pointer
      wifi: iwlwifi: mvm: check firmware response size
      wifi: iwlwifi: fw: fix memory leak in debugfs
      wifi: iwlwifi: mvm: fix MIC removal confusion
      wifi: iwlwifi: mvm: fix potential memory leak
      wifi: iwlwifi: mvm: prefer RCU_INIT_POINTER()
      net: move dropreason.h to dropreason-core.h
      net: extend drop reasons for multiple subsystems
      mac80211: use the new drop reasons infrastructure

John Keeping (1):
      wifi: brcmfmac: support CQM RSSI notification with older firmware

Jonas Jelonek (1):
      wifi: ath9k: fix per-packet TX-power cap for TPC

Jose E. Marchesi (1):
      bpf, docs: Document BPF insn encoding in term of stored bytes

Josef Miegl (2):
      net: geneve: set IFF_POINTOPOINT with IFLA_GENEVE_INNER_PROTO_INHERIT
      net: geneve: accept every ethertype

Julia Lawall (1):
      wifi: iwlwifi: fix typos in comment

Kai Shen (1):
      net/smc: Use percpu ref for wr tx reference

Kal Conley (9):
      selftests: xsk: Add xskxceiver.h dependency to Makefile
      selftests: xsk: Use correct UMEM size in testapp_invalid_desc
      selftests: xsk: Add test case for packets at end of UMEM
      selftests: xsk: Disable IPv6 on VETH1
      selftests: xsk: Deflakify STATS_RX_DROPPED test
      xsk: Fix unaligned descriptor validation
      selftests: xsk: Add test UNALIGNED_INV_DESC_4K1_FRAME_SIZE
      xsk: Simplify xp_aligned_validate_desc implementation
      xsk: Elide base_addr comparison in xp_unaligned_validate_desc

Kalle Valo (7):
      wifi: ath12k: remove memset with byte count of 278528
      wifi: move mac80211_hwsim and virt_wifi to virtual directory
      wifi: move raycs, wl3501 and rndis_wlan to legacy directory
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      wifi: ath11k: print a warning when crypto_alloc_shash() fails
      Merge tag 'mt76-for-kvalo-2023-04-18' of https://github.com/nbd168/wireless
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Kang Chen (1):
      wifi: mt76: handle failure of vzalloc in mt7615_coredump_work

Kees Cook (1):
      wifi: ath: Silence memcpy run-time false positive warning

Kevin Brodsky (3):
      net: Ensure ->msg_control_user is used for user buffers
      net/compat: Update msg_control_is_user when setting a kernel pointer
      net/ipv6: Initialise msg_control_is_user

Kieran Frewen (2):
      wifi: mac80211: S1G capabilities information element in probe request
      wifi: nl80211: support advertising S1G capabilities

Klaus Kudielka (3):
      net: dsa: mv88e6xxx: re-order functions
      net: dsa: mv88e6xxx: move call to mv88e6xxx_mdios_register()
      net: dsa: mv88e6xxx: mask apparently non-existing phys during probing

Konrad Dybcio (2):
      wifi: brcmfmac: pcie: Add 4359C0 firmware definition
      dt-bindings: net: Convert ath10k to YAML

Krishnanand Prabhu (2):
      wifi: iwlwifi: mvm: add support for PTP HW clock (PHC)
      wifi: iwlwifi: mvm: add support for timing measurement

Kristian Overskeid (1):
      net: hsr: Don't log netdev_err message on unknown prp dst node

Krzysztof Kozlowski (31):
      net: stmmac: qcom: drop of_match_ptr for ID table
      net: stmmac: generic: drop of_match_ptr for ID table
      net: marvell: pxa168_eth: drop of_match_ptr for ID table
      net: samsung: sxgbe: drop of_match_ptr for ID table
      net: ni: drop of_match_ptr for ID table
      nfc: trf7970a: mark OF related data as maybe unused
      net: dsa: lantiq_gswip: mark OF related data as maybe unused
      net: dsa: lan9303: drop of_match_ptr for ID table
      net: dsa: seville_vsc9953: drop of_match_ptr for ID table
      net: dsa: ksz9477: drop of_match_ptr for ID table
      net: dsa: ocelot: drop of_match_ptr for ID table
      net: phy: ks8995: drop of_match_ptr for ID table
      net: ieee802154: adf7242: drop of_match_ptr for ID table
      net: ieee802154: mcr20a: drop of_match_ptr for ID table
      net: ieee802154: at86rf230: drop of_match_ptr for ID table
      net: ieee802154: ca8210: drop of_match_ptr for ID table
      net: ieee802154: adf7242: drop owner from driver
      net: ieee802154: ca8210: drop owner from driver
      ptp: ines: drop of_match_ptr for ID table
      net: nfp: constify pointers to hwmon_channel_info
      net: aquantia: constify pointers to hwmon_channel_info
      net: phy: aquantia: constify pointers to hwmon_channel_info
      net: phy: bcm54140: constify pointers to hwmon_channel_info
      net: phy: marvell: constify pointers to hwmon_channel_info
      net: phy: mxl: constify pointers to hwmon_channel_info
      net: phy: nxp-tja11xx: constify pointers to hwmon_channel_info
      net: phy: sfp: constify pointers to hwmon_channel_info
      Bluetooth: hci_ll: drop of_match_ptr for ID table
      Bluetooth: btmrvl_sdio: mark OF related data as maybe unused
      Bluetooth: hci_qca: mark OF related data as maybe unused
      Bluetooth: btmtkuart: mark OF related data as maybe unused

Kui-Feng Lee (10):
      bpf: Retire the struct_ops map kvalue->refcnt.
      net: Update an existing TCP congestion control algorithm.
      bpf: Create links for BPF struct_ops maps.
      libbpf: Create a bpf_link in bpf_map__attach_struct_ops().
      bpf: Update the struct_ops of a bpf_link.
      libbpf: Update a bpf_link with another struct_ops.
      libbpf: Use .struct_ops.link section to indicate a struct_ops with a link.
      selftests/bpf: Test switching TCP Congestion Control algorithms.
      bpftool: Register struct_ops with a link.
      bpftool: Update doc to explain struct_ops register subcommand.

Kumar Kartikeya Dwivedi (8):
      bpf: Annotate data races in bpf_local_storage
      bpf: Remove unused MEM_ALLOC | PTR_TRUSTED checks
      bpf: Fix check_reg_type for PTR_TO_BTF_ID
      bpf: Wrap register invalidation with a helper
      bpf: Support kptrs in percpu hashmap and percpu LRU hashmap
      bpf: Support kptrs in local storage maps
      selftests/bpf: Add more tests for kptrs in maps
      bpf: Use separate RCU callbacks for freeing selem

Kuniyuki Iwashima (5):
      ipv6: Remove in6addr_any alternatives.
      6lowpan: Remove redundant initialisation.
      tcp: Refine SYN handling for PAWS.
      netlink: Use copy_to_user() for optval in netlink_getsockopt().
      tcp/udp: Fix memleaks of sk and zerocopy skbs with TX timestamp.

Lanzhe Li (1):
      Bluetooth: fix inconsistent indenting

Larry Finger (3):
      wifi: rtw88: Fix memory leak in rtw88_usb
      bluetooth: Add device 0bda:887b to device tables
      bluetooth: Add device 13d3:3571 to device tables

Leon Romanovsky (26):
      neighbour: delete neigh_lookup_nodev as not used
      net/mlx5e: Factor out IPsec ASO update function
      net/mlx5e: Prevent zero IPsec soft/hard limits
      net/mlx5e: Add SW implementation to support IPsec 64 bit soft and hard limits
      net/mlx5e: Overcome slow response for first IPsec ASO WQE
      xfrm: don't require advance ESN callback for packet offload
      net/mlx5e: Remove ESN callbacks if it is not supported
      net/mlx5e: Set IPsec replay sequence numbers
      net/mlx5e: Reduce contention in IPsec workqueue
      net/mlx5e: Generalize IPsec work structs
      net/mlx5e: Simulate missing IPsec TX limits hardware functionality
      net/mlx5e: Add IPsec packet offload tunnel bits
      net/mlx5e: Check IPsec packet offload tunnel capabilities
      net/mlx5e: Configure IPsec SA tables to support tunnel mode
      net/mlx5e: Prepare IPsec packet reformat code for tunnel mode
      net/mlx5e: Support IPsec RX packet offload in tunnel mode
      net/mlx5e: Support IPsec TX packet offload in tunnel mode
      net/mlx5e: Listen to ARP events to update IPsec L2 headers in tunnel mode
      net/mlx5: Allow blocking encap changes in eswitch
      net/mlx5e: Create IPsec table with tunnel support only when encap is disabled
      net/mlx5e: Accept tunnel mode for IPsec packet offload
      net/mlx5e: Fix FW error while setting IPsec policy block action
      net/mlx5e: Don't overwrite extack message returned from IPsec SA validator
      net/mlx5e: Compare all fields in IPv6 address
      net/mlx5e: Properly release work data structure
      net/mlx5e: Refactor duplicated code in mlx5e_ipsec_init_macs

Liu Jian (1):
      Revert "Bluetooth: btsdio: fix use after free bug in btsdio_remove due to unfinished work"

Liu Pan (1):
      libbpf: Explicitly call write to append content to file

Lorenz Bauer (1):
      selftests/bpf: Fix use of uninitialized op_name in log tests

Lorenz Brun (1):
      wifi: mt76: mt7915: expose device tree match table

Lorenzo Bianconi (12):
      selftests/bpf: Use ifname instead of ifindex in XDP compliance test tool
      selftests/bpf: Improve error logs in XDP compliance test tool
      wifi: mt76: mt7921: introduce mt7921_get_mac80211_ops utility routine
      wifi: mt76: move irq_tasklet in mt76_dev struct
      wifi: mt76: add mt76_connac_irq_enable utility routine
      wifi: mt76: get rid of unused sta_ps callbacks
      wifi: mt76: add mt76_connac_gen_ppe_thresh utility routine
      wifi: mt76: mt7921: get rid of eeprom.h
      wifi: mt76: move shared mac definitions in mt76_connac2_mac.h
      wifi: mt76: move mcu_uni_event and mcu_reg_event in common code
      net: veth: add page_pool for page recycling
      net: veth: add page_pool stats

Lu jicong (1):
      wifi: rtlwifi: rtl8192ce: fix dealing empty EEPROM values

Luis Gerhorst (2):
      tools: bpftool: Remove invalid \' json escape
      bpf: Remove misleading spec_v1 check on var-offset stack read

Luiz Angelo Daros de Luca (1):
      net: dsa: realtek: rtl8365mb: add change_mtu

Luiz Augusto von Dentz (10):
      Bluetooth: MGMT: Use BIT macro when defining bitfields
      Bluetooth: hci_core: Make hci_conn_hash_add append to the list
      Bluetooth: hci_sync: Fix smatch warning
      Bluetooth: L2CAP: Delay identity address updates
      Bluetooth: Enable all supported LE PHY by default
      Bluetooth: hci_conn: Add support for linking multiple hcon
      Bluetooth: hci_conn: Fix not matching by CIS ID
      Bluetooth: hci_conn: Fix not waiting for HCI_EVT_LE_CIS_ESTABLISHED
      Bluetooth: btnxpuart: Fix sparse warnings
      Bluetooth: hci_sync: Only allow hci_cmd_sync_queue if running

Lukas Bulwahn (3):
      MAINTAINERS: adjust file entries after wifi driver movement
      MAINTAINERS: remove file entry in NFC SUBSYSTEM after platform_data movement
      ethernet: broadcom/sb1250-mac: clean up after SIBYTE_BCM1x55 removal

Madhu Koriginja (1):
      netfilter: keep conntrack reference until IPsecv6 policy checks are done

Magnus Karlsson (2):
      selftests/xsk: Fix munmap for hugepage allocated umem
      selftests/xsk: Put MAP_HUGE_2MB in correct argument

Maher Sanalla (4):
      Revert "net/mlx5: Expose steering dropped packets counter"
      Revert "net/mlx5: Expose vnic diagnostic counters for eswitch managed vports"
      net/mlx5: Add vnic devlink health reporter to PFs/VFs
      net/mlx5e: Add vnic devlink health reporter to representors

Mahesh Bandewar (1):
      ipv6: add icmpv6_error_anycast_as_unicast for ICMPv6

Manikanta Pubbisetty (3):
      wifi: nl80211: Update the documentation of NL80211_SCAN_FLAG_COLOCATED_6GHZ
      wifi: ath11k: Optimize 6 GHz scan time
      wifi: ath11k: Send 11d scan start before WMI_START_SCAN_CMDID

Manish Mandlik (2):
      Bluetooth: Add vhci devcoredump support
      Bluetooth: btusb: Add btusb devcoredump support

Manu Bretelle (3):
      selftests/bpf: Add --json-summary option to test_progs
      tools: bpftool: json: Fix backslash escape typo in jsonw_puts
      selftests/bpf: Reset err when symbol name already exist in kprobe_multi_test

Maor Dickman (3):
      net/mlx5e: TC, Extract indr setup block checks to function
      net/mlx5e: Enable TC offload for ingress MACVLAN over bond
      net/mlx5e: Enable TC offload for egress MACVLAN over bond

Marc Dionne (1):
      rxrpc: Fix error when reading rxrpc tokens

Marc Kleine-Budde (4):
      Merge patch series "can: rcar_canfd: Add transceiver support"
      Merge patch series "can: remove redundant pci_clear_master()"
      Merge patch series "can: m_can: Optimizations for m_can/tcan part 2"
      Merge patch series "can: bxcan: add support for ST bxCAN controller"

Marek Behún (1):
      net: dsa: mv88e6xxx: fix mdio bus' phy_mask member

Marek Vasut (1):
      wifi: brcmfmac: add Cypress 43439 SDIO ids

Mario Limonciello (1):
      wifi: mt76: mt7921e: Set memory space enable in PCI_COMMAND if unset

Markus Schneider-Pargmann (5):
      can: m_can: Remove repeated check for is_peripheral
      can: m_can: Always acknowledge all interrupts
      can: m_can: Remove double interrupt enable
      can: m_can: Disable unused interrupts
      can: m_can: Keep interrupts enabled during peripheral read

Martin Blumenstingl (15):
      wifi: rtw88: mac: Add support for the SDIO HCI in rtw_pwr_seq_parser()
      wifi: rtw88: mac: Add SDIO HCI support in the TX/page table setup
      wifi: rtw88: rtw8821c: Implement RTL8821CS (SDIO) efuse parsing
      wifi: rtw88: rtw8822b: Implement RTL8822BS (SDIO) efuse parsing
      wifi: rtw88: rtw8822c: Implement RTL8822CS (SDIO) efuse parsing
      wifi: rtw88: mac: Return the original error from rtw_pwr_seq_parser()
      wifi: rtw88: mac: Return the original error from rtw_mac_power_switch()
      wifi: rtw88: Clear RTW_FLAG_POWERON early in rtw_mac_power_switch()
      wifi: rtw88: sdio: Add HCI implementation for SDIO based chipsets
      wifi: rtw88: mac: Support SDIO specific bits in the power on sequence
      wifi: rtw88: main: Add the {cpwm,rpwm}_addr for SDIO based chipsets
      wifi: rtw88: main: Reserve 8 bytes of extra TX headroom for SDIO cards
      mmc: sdio: add Realtek SDIO vendor ID and various wifi device IDs
      wifi: rtw88: Add support for the SDIO based RTL8822CS chipset
      wifi: rtw88: Add support for the SDIO based RTL8821CS chipset

Martin KaFai Lau (30):
      Merge branch 'move SYS() macro to test_progs.h and run mptcp in a dedicated netns'
      selftests/bpf: Fix flaky fib_lookup test
      bpf: Move a few bpf_local_storage functions to static scope
      bpf: Refactor codes into bpf_local_storage_destroy
      bpf: Remove __bpf_local_storage_map_alloc
      bpf: Remove the preceding __ from __bpf_selem_unlink_storage
      bpf: Remember smap in bpf_local_storage
      bpf: Repurpose use_trace_rcu to reuse_now in bpf_local_storage
      bpf: Remove bpf_selem_free_fields*_rcu
      bpf: Add bpf_selem_free_rcu callback
      bpf: Add bpf_selem_free()
      bpf: Add bpf_local_storage_rcu callback
      bpf: Add bpf_local_storage_free()
      selftests/bpf: Replace CHECK with ASSERT in test_local_storage
      selftests/bpf: Check freeing sk->sk_local_storage with sk_local_storage->smap is NULL
      selftests/bpf: Add local-storage-create benchmark
      Merge branch 'bpf: Allow helpers access ptr_to_btf_id.'
      selftests/bpf: Use ASSERT_EQ instead ASSERT_OK for testing memcmp result
      selftests/bpf: Fix a fd leak in an error path in network_helpers.c
      Merge branch 'net: skbuff: skb bitfield compaction - bpf'
      Merge branch 'Transit between BPF TCP congestion controls.'
      bpf: Check IS_ERR for the bpf_map_get() return value
      bpf: Add a few bpf mem allocator functions
      bpf: Use bpf_mem_cache_alloc/free in bpf_local_storage_elem
      bpf: Use bpf_mem_cache_alloc/free for bpf_local_storage
      selftests/bpf: Test task storage when local_storage->smap is NULL
      selftests/bpf: Add bench for task storage creation
      Merge branch 'Allow BPF TCP CCs to write app_limited'
      Merge branch 'selftests: xsk: Add test case for packets at end of UMEM'
      Merge branch 'xsk: Fix unaligned descriptor validation'

Martin Kaiser (2):
      wifi: rtl8xxxu: mark Edimax EW-7811Un V2 as tested
      wifi: rtl8xxxu: use module_usb_driver

Matthieu Baerts (5):
      mptcp: do not fill info not used by the PM in used
      MAINTAINERS: add git trees for MPTCP
      mptcp: remove unused 'remaining' variable
      selftests: mptcp: remove duplicated entries in usage
      selftests: mptcp: join: fix ShellCheck warnings

Matthieu De Beule (1):
      netfilter: Correct documentation errors in nf_tables.h

Max Chou (3):
      Bluetooth: btrtl: check for NULL in btrtl_set_quirks()
      Bluetooth: btrtl: Firmware format v2 support
      Bluetooth: btrtl: Add the support for RTL8851B

Maxim Korotkov (2):
      bnxt: avoid overflow in bnxt_get_nvram_directory()
      bnx2: remove deadcode in bnx2_init_cpus()

Maxime Bizon (1):
      net: dst: fix missing initialization of rt_uncached

Meng Tang (2):
      Bluetooth: btusb: Add new PID/VID 04ca:3801 for MT7663
      Bluetooth: Add VID/PID 0489/e0e4 for MediaTek MT7922

Menglong Dong (3):
      libbpf: Add support to set kprobe/uprobe attach mode
      selftests/bpf: Split test_attach_probe into multi subtests
      selftests/bpf: Add test for legacy/perf kprobe/uprobe attach mode

Mengyuan Lou (1):
      net: wangxun: Implement the ndo change mtu interface

Michael Weiß (1):
      bpf: Fix a typo for BPF_F_ANY_ALIGNMENT in bpf.h

Michal Michalik (2):
      tools: ynl: add the Python requirements.txt file
      tools: ynl: Add missing types to encode/decode

Michal Schmidt (6):
      ice: do not busy-wait to read GNSS data
      ice: increase the GNSS data polling interval to 20 ms
      ice: remove ice_ctl_q_info::sq_cmd_timeout
      ice: sleep, don't busy-wait, for ICE_CTL_Q_SQ_CMD_TIMEOUT
      ice: remove unused buffer copy code in ice_sq_send_cmd_retry()
      ice: sleep, don't busy-wait, in the SQ send retry loop

Mika Westerberg (3):
      net: thunderbolt: Fix sparse warnings in tbnet_check_frame() and tbnet_poll()
      net: thunderbolt: Fix sparse warnings in tbnet_xmit_csum_and_map()
      net: thunderbolt: Fix typos in comments

Min Li (1):
      Bluetooth: L2CAP: fix "bad unlock balance" in l2cap_disconnect_rsp

Ming Yen Hsieh (1):
      wifi: mt76: fix 6GHz high channel not be scanned

Miquel Raynal (1):
      net: mvpp2: Defer probe if MAC address source is not yet ready

Miri Korenblit (35):
      wifi: iwlwifi: mvm: Refactor STA_HE_CTXT_CMD sending flow
      wifi: iwlwifi: mvm: Refactor MAC_CONTEXT_CMD sending flow
      wifi: iwlwifi: mvm: add support for the new MAC CTXT command
      wifi: iwlwifi: mvm: add support for the new LINK command
      wifi: iwlwifi: mvm: add support for the new STA related commands
      wifi: iwlwifi: mvm: Add an add_interface() callback for mld mode
      wifi: iwlwifi: mvm: Add a remove_interface() callback for mld mode
      wifi: iwlwifi: mvm: refactor __iwl_mvm_assign_vif_chanctx()
      wifi: iwlwifi: mvm: add an assign_vif_chanctx() callback for MLD mode
      wifi: iwlwifi: mvm: refactor __iwl_mvm_unassign_vif_chanctx()
      wifi: iwlwifi: mvm: add an unassign_vif_chanctx() callback for MLD mode
      wifi: iwlwifi: mvm: add start_ap() and join_ibss() callbacks for MLD mode
      wifi: iwlwifi: mvm: add stop_ap() and leave_ibss() callbacks for MLD mode
      wifi: iwlwifi: mvm: Don't send MAC CTXT cmd after deauthorization
      wifi: iwlwifi: mvm: refactor iwl_mvm_cfg_he_sta()
      wifi: iwlwifi: mvm: refactor iwl_mvm_sta
      wifi: iwlwifi: mvm: refactor iwl_mvm_sta_send_to_fw()
      wifi: iwlwifi: mvm: remove not needed initializations
      wifi: iwlwifi: mvm: refactor iwl_mvm_add_sta(), iwl_mvm_rm_sta()
      wifi: iwlwifi: mvm: add an indication that the new MLD API is used
      wifi: iwlwifi: mvm: add sta handling flows for MLD mode
      wifi: iwlwifi: mvm: add some new MLD ops
      wifi: iwlwifi: mvm: refactor iwl_mvm_roc()
      wifi: iwlwifi: mvm: add cancel/remain_on_channel for MLD mode
      wifi: iwlwifi: mvm: unite sta_modify_disable_tx flows
      wifi: iwlwifi: mvm: add support for post_channel_switch in MLD mode
      wifi: iwlwifi: mvm: add all missing ops to iwl_mvm_mld_ops
      wifi: iwlwifi: mvm: fix "modify_mask" value in the link cmd.
      wifi: iwlwifi: mvm: fix crash on queue removal for MLD API too
      wifi: iwlwifi: mvm: modify link instead of removing it during csa
      wifi: iwlwifi: mvm: always use the sta->addr as the peers addr
      wifi: iwlwifi: mvm: align to the LINK cmd update in the FW
      wifi: iwlwifi: add a validity check of queue_id in iwl_txq_reclaim
      wifi: iwlwifi: mvm: cleanup beacon_inject_active during hw restart
      wifi: iwlwifi: mvm: enable new MLD FW API

Mordechay Goodstein (19):
      wifi: mac80211: clear all bits that relate rtap fields on skb
      wifi: wireless: return primary channel regardless of DUP
      wifi: wireless: correct primary channel validation on 6 GHz
      wifi: wireless: cleanup unused function parameters
      wifi: radiotap: Add EHT radiotap definitions
      wifi: mac80211: add support for driver adding radiotap TLVs
      wifi: iwlwifi: mvm: add LSIG info to radio tap info in EHT
      wifi: iwlwifi: mvm: mark mac header with no data frames
      wifi: radiotap: separate vendor TLV into header/content
      wifi: iwlwifi: mvm: add an helper function radiotap TLVs
      wifi: iwlwifi: mvm: add EHT radiotap info based on rate_n_flags
      wifi: iwlwifi: mvm: add all EHT based on data0 info from HW
      wifi: iwlwifi: mvm: rename define to generic name
      wifi: iwlwifi: mvm: decode USIG_B1_B7 RU to nl80211 RU width
      wifi: iwlwifi: mvm: parse FW frame metadata for EHT sniffer mode
      wifi: iwlwifi: mvm: add primary 80 known for EHT radiotap
      wifi: iwlwifi: rs-fw: break out for unsupported bandwidth
      wifi: iwlwifi: mvm: clean up duplicated defines
      wifi: iwlwifi: mvm: add EHT RU allocation to radiotap

Moshe Shemesh (4):
      net/mlx5: remove redundant clear_bit
      net/mlx5: Stop waiting for PCI up if teardown was triggered
      Revert "net/mlx5: Remove "recovery" arg from mlx5_load_one() function"
      net/mlx5: Use recovery timeout on sync reset flow

Muhammad Husaini Zulkifli (1):
      igc: Add qbv_config_change_errors counter

Muhammad Usama Anjum (1):
      qede: remove linux/version.h and linux/compiler.h

Mukesh Sisodiya (15):
      wifi: iwlwifi: Adding the code to get RF name for MsP device
      wifi: iwlwifi: Update logs for yoyo reset sw changes
      wifi: iwlwifi: yoyo: Add new tlv for dump file name extension
      wifi: iwlwifi: yoyo: Add driver defined dump file name
      wifi: iwlwifi: Update configurations for Bnj and Bz devices
      wifi: iwlwifi: Update configurations for Bnj device
      wifi: iwlwifi: Update configuration for SO,SOF MAC and HR RF
      wifi: iwlwifi: mvm: move function sequence
      wifi: iwlwifi: Update init sequence if tx diversity supported
      wifi: iwlwifi: Update configurations for Bnj-a0 and specific rf devices
      wifi: iwlwifi: dbg: print pc register data once fw dump occurred
      wifi: iwlwifi: Fix the duplicate dump name
      wifi: iwlwifi: Add RF Step Type for BZ device
      wifi: iwlwifi: add a new PCI device ID for BZ device
      wifi: iwlwifi: Update support for b0 version

Muna Sinada (5):
      wifi: ath11k: modify accessor macros to match index size
      wifi: ath11k: push MU-MIMO params from hostapd to hardware
      wifi: ath11k: move HE MCS mapper to a separate function
      wifi: ath11k: generate rx and tx mcs maps for supported HE mcs
      wifi: ath11k: Remove disabling of 80+80 and 160 MHz

Nagarajan Maran (1):
      wifi: ath11k: Fix SKB corruption in REO destination ring

Nathan Chancellor (5):
      bpf: Increase size of BTF_ID_LIST without CONFIG_DEBUG_INFO_BTF again
      wifi: iwlwifi: Avoid disabling GCC specific flag with clang
      net: pasemi: Fix return type of pasemi_mac_start_tx()
      wifi: iwlwifi: mvm: Use 64-bit division helper in iwl_mvm_get_crosstimestamp_fw()
      net: ethernet: ti: Fix format specifier in netcp_create_interface()

Neeraj Sanjay Kale (9):
      serdev: Replace all instances of ENOTSUPP with EOPNOTSUPP
      serdev: Add method to assert break signal over tty UART port
      dt-bindings: net: bluetooth: Add NXP bluetooth support
      Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets
      Bluetooth: btnxpuart: Add support to download helper FW file for w8997
      Bluetooth: btnxpuart: Deasset UART break before closing serdev device
      Bluetooth: btnxpuart: Disable Power Save feature on startup
      Bluetooth: btnxpuart: No need to check the received bootloader signature
      Bluetooth: btnxpuart: Enable flow control before checking boot signature

Neil Chen (1):
      wifi: mt76: mt7921: use driver flags rather than mac80211 flags to mcu

Nick Alcock (2):
      mctp: remove MODULE_LICENSE in non-modules
      lib: packing: remove MODULE_LICENSE in non-modules

Nick Child (2):
      net: Catch invalid index in XPS mapping
      netdev: Enforce index cap in netdev_get_tx_queue

Nuno Gonçalves (1):
      xsk: allow remap of fill and/or completion rings

Oleksij Rempel (9):
      net: dsa: microchip: add ksz_setup_tc_mode() function
      net: dsa: microchip: add ETS Qdisc support for KSZ9477 series
      net: dsa: microchip: ksz8: Separate static MAC table operations for code reuse
      net: dsa: microchip: ksz8: Implement add/del_fdb and use static MAC table operations
      net: dsa: microchip: ksz8: Make ksz8_r_sta_mac_table() static
      net: dsa: microchip: ksz8_r_sta_mac_table(): Avoid using error code for empty entries
      net: dsa: microchip: ksz8_r_sta_mac_table(): Utilize error values from read/write functions
      net: dsa: microchip: Make ksz8_w_sta_mac_table() static
      net: dsa: microchip: Utilize error values in ksz8_w_sta_mac_table()

Oliver Hartkopp (2):
      can: isotp: add module parameter for maximum pdu size
      kvaser_usb: convert USB IDs to hexadecimal values

P Praneesh (3):
      wifi: ath12k: fill peer meta data during reo_reinject
      wifi: ath11k: fix rssi station dump not updated in QCN9074
      wifi: ath11k: fix writing to unintended memory region

Pablo Neira Ayuso (7):
      netfilter: conntrack: restore IPS_CONFIRMED out of nf_conntrack_hash_check_insert()
      netfilter: nf_tables: extended netlink error reporting for netdevice
      netfilter: nf_tables: do not send complete notification of deletions
      netfilter: nf_tables: rename function to destroy hook list
      netfilter: nf_tables: support for adding new devices to an existing netdev chain
      netfilter: nf_tables: support for deleting devices in an existing netdev chain
      netfilter: nf_tables: allow to create netdev chain without device

Paolo Abeni (19):
      Merge branch 'various-mtk_eth_soc-cleanups'
      Merge branch 'sctp-add-another-two-stream-schedulers'
      Merge branch 'allocate-multiple-skbuffs-on-tx'
      mptcp: avoid unneeded address copy
      mptcp: simplify subflow_syn_recv_sock()
      Merge branch 'net-rps-rfs-improvements'
      Merge branch 'vsock-return-errors-other-than-enomem-to-socket'
      Merge branch 'net-dsa-microchip-ksz8-enhance-static-mac-table-operations-and-error-handling'
      Merge branch 'add-emac3-support-for-sa8540p-ride'
      Merge branch 'net-use-read_once-write_once-for-ring-index-accesses'
      mptcp: drop unneeded argument
      mptcp: avoid unneeded __mptcp_nmpc_socket() usage
      mptcp: move fastopen subflow check inside mptcp_sendmsg_fastopen()
      mptcp: move first subflow allocation at mpc access time
      mptcp: fastclose msk when cleaning unaccepted sockets
      Merge branch 'r8169-use-new-macros-from-netdev_queues-h'
      Merge branch 'add-ethernet-driver-for-starfive-jh7110-soc'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      net: phy: hide the PHYLIB_LEDS knob

Parav Pandit (1):
      net/mlx5: Create a new profile for SFs

Paul Blakey (14):
      net/mlx5: fs_chains: Refactor to detach chains from tc usage
      net/mlx5: fs_core: Allow ignore_flow_level on TX dest
      net/mlx5e: Use chains for IPsec policy priority offload
      netfilter: ctnetlink: Support offloaded conntrack entry deletion
      net/mlx5e: Set default can_offload action
      net/mlx5e: TC, Remove unused vf_tun variable
      net/mlx5e: TC, Move main flow attribute cleanup to helper func
      net/mlx5e: CT: Use per action stats
      net/mlx5e: TC, Remove CT action reordering
      net/mlx5e: TC, Remove special handling of CT action
      net/mlx5e: TC, Remove multiple ct actions limitation
      net/mlx5e: TC, Remove tuple rewrite and ct limitation
      net/mlx5e: TC, Remove mirror and ct limitation
      net/mlx5e: TC, Remove sample and ct limitation

Paul Geurts (1):
      net: dsa: b53: mdio: add support for BCM53134

Paul Mackerras (1):
      MAINTAINERS: Remove PPP maintainer

Pavan Chebbi (3):
      bnxt: Change fw_cap to u64 to accommodate more capability bits
      bnxt: Defer PTP initialization to after querying function caps
      bnxt: Enforce PTP software freq adjustments only when in non-RTC mode

Pedro Tammela (12):
      selftests: tc-testing: add tests for action binding
      net/sched: act_api: use the correct TCA_ACT attributes in dump
      net/sched: sch_mqprio: use netlink payload helpers
      net/sched: act_pedit: use NLA_POLICY for parsing 'ex' keys
      net/sched: act_pedit: use extack in 'ex' parsing errors
      net/sched: act_pedit: check static offsets a priori
      net/sched: act_pedit: remove extra check for key type
      net/sched: act_pedit: rate limit datapath messages
      net/sched: sch_htb: use extack on errors messages
      net/sched: sch_qfq: use extack on errors messages
      net/sched: sch_qfq: refactor parsing of netlink parameters
      selftests: tc-testing: add more tests for sch_qfq

Peng Fan (2):
      dt-bindings: net: fec: add power-domains property
      dt-bindings: can: fsl,flexcan: add optional power-domains property

Peter Chiu (4):
      wifi: mt76: drop the incorrect scatter and gather frame
      wifi: mt76: mt7996: fix pointer calculation in ie countdown event
      wifi: mt76: mt7996: init mpdu density cap
      wifi: mt76: mt7996: remove mt7996_mcu_set_pm()

Petr Machata (7):
      net: ipv4: Allow changing IPv4 address protocol
      selftests: rtnetlink: Make the set of tests to run configurable
      selftests: rtnetlink: Add an address proto test
      selftests: rtnetlink: Fix do_test_address_proto()
      selftests: forwarding: hw_stats_l3: Detect failure to install counters
      selftests: forwarding: sch_tbf_*: Add a pre-run hook
      selftests: forwarding: generalize bail_on_lldpad from mlxsw

Ping-Ke Shih (18):
      wifi: rtl8xxxu: 8188e: parse single one element of RA report for station mode
      wifi: rtw89: 8852b: enable hw_scan support
      wifi: rtw89: release RX standby timer of beamformee CSI to save power
      wifi: rtw89: add counters of register-based H2C/C2H
      wifi: rtw89: fix potential race condition between napi_init and napi_enable
      wifi: rtw89: use schedule_work to request firmware
      wifi: rtw89: add firmware format version to backward compatible with older drivers
      wifi: rtw89: read version of analog hardware
      wifi: rtw89: 8851b: fix TX path to path A for one RF path chip
      wifi: rtw89: mac: update MAC settings to support 8851b
      wifi: rtw89: pci: update PCI related settings to support 8851B
      wifi: rtw89: 8851b: add BB and RF tables (1 of 2)
      wifi: rtw89: 8851b: add BB and RF tables (2 of 2)
      wifi: rtw89: 8851b: add tables for RFK
      wifi: rtw89: fix crash due to null pointer of sta in AP mode
      wifi: rtw89: coex: send more hardware module info to firmware for 8851B
      wifi: rtw89: use struct instead of macros to set H2C command of hardware scan
      wifi: rtw89: mac: use regular int as return type of DLE buffer request

Po-Hao Huang (20):
      wifi: rtw89: add RNR support for 6 GHz scan
      wifi: rtw89: adjust channel encoding to common function
      wifi: rtw89: 8852b: add channel encoding for hw_scan
      wifi: rtw89: 8852c: add beacon filter and CQM support
      wifi: rtw89: add function to wait for completion of TX skbs
      wifi: rtw89: add ieee80211::remain_on_channel ops
      wifi: rtw89: add flag check for power state
      wifi: rtw89: fix authentication fail during scan
      wifi: rtw89: refine scan function after chanctx
      wifi: rtw89: update statistics to FW for fine-tuning performance
      wifi: rtw89: Disallow power save with multiple stations
      wifi: rtw89: add support of concurrent mode
      wifi: rtw88: add bitmap for dynamic port settings
      wifi: rtw88: add port switch for AP mode
      wifi: rtw88: 8822c: extend reserved page number
      wifi: rtw88: disallow PS during AP mode
      wifi: rtw88: refine reserved page flow for AP mode
      wifi: rtw88: prevent scan abort with other VIFs
      wifi: rtw88: handle station mode concurrent scan with AP mode
      wifi: rtw88: 8822c: add iface combination

Pradeep Kumar Chitrapu (2):
      wifi: ath11k: fix tx status reporting in encap offload mode
      wifi: ath11k: Fix incorrect update of radiotap fields

Praveen Kaligineedi (5):
      gve: XDP support GQI-QPL: helper function changes
      gve: Changes to add new TX queues
      gve: Add XDP DROP and TX support for GQI-QPL format
      gve: Add XDP REDIRECT support for GQI-QPL format
      gve: Add AF_XDP zero-copy support for GQI-QPL format

Pu Lehui (1):
      riscv, bpf: Add kfunc support for RV64

Puranjay Mohan (3):
      libbpf: Fix arm syscall regs spec in bpf_tracing.h
      libbpf: Refactor parse_usdt_arg() to re-use code
      libbpf: USDT arm arg parsing support

Qiqi Zhang (1):
      Bluetooth: hci_h5: Complements reliable packet processing logic

Quan Zhou (3):
      wifi: mt76: mt7921e: fix probe timeout after reboot
      wifi: mt76: mt7921e: improve reliability of dma reset
      wifi: mt76: mt7921e: stop chip reset worker in unregister hook

Quentin Monnet (8):
      bpftool: Fix documentation about line info display for prog dumps
      bpftool: Fix bug for long instructions in program CFG dumps
      bpftool: Support inline annotations when dumping the CFG of a program
      bpftool: Return an error on prog dumps if both CFG and JSON are required
      bpftool: Support "opcodes", "linum", "visual" simultaneously
      bpftool: Support printing opcodes and source file references in CFG
      bpftool: Clean up _bpftool_once_attr() calls in bash completion
      bpftool: Replace "__fallthrough" by a comment to address merge conflict

Raed Salem (6):
      xfrm: add new device offload acquire flag
      xfrm: copy_to_user_state fetch offloaded SA packets/bytes statistics
      net/mlx5e: Allow policies with reqid 0, to support IKE policy holes
      net/mlx5e: Support IPsec acquire default SA
      net/mlx5e: Use one rule to count all IPsec Tx offloaded traffic
      net/mlx5e: Update IPsec per SA packets/bytes count

Rahul Rameshbabu (4):
      net/mlx5e: Utilize the entire fifo
      net/mlx5: Update cyclecounter shift value to improve ptp free running mode precision
      tools: ynl: Remove absolute paths to yaml files from ethtool testing tool
      tools: ynl: Rename ethtool to ethtool.py

Rajat Soni (1):
      wifi: ath12k: fix memory leak in ath12k_qmi_driver_event_work()

Ramya Gnanasekar (2):
      wifi: ath12k: Handle lock during peer_id find
      wifi: ath12k: PCI ops for wakeup/release MHI

Ramón Nordin Rodriguez (1):
      drivers/net/phy: add driver for Microchip LAN867x 10BASE-T1S PHY

Raul Cheleguini (2):
      Bluetooth: Improve support for Actions Semi ATS2851 based devices
      Bluetooth: Add new quirk for broken set random RPA timeout for ATS2851

Reese Russell (1):
      wifi: mt76: mt7921: add Netgear AXE3000 (A8000) support

Rob Herring (9):
      net: Use of_property_present() for testing DT property presence
      nfc: mrvl: Move platform_data struct into driver
      nfc: mrvl: Use of_property_read_bool() for boolean properties
      dt-bindings: net: Drop unneeded quotes
      bcma: Use of_address_to_resource()
      dt-bindings: net: ethernet-switch: Make "#address-cells/#size-cells" required
      dt-bindings: net: dsa: brcm,sf2: Drop unneeded "#address-cells/#size-cells"
      bcma: Add explicit of_device.h include
      dt-bindings: net: ethernet: Fix JSON pointer references

Roberto Sassu (1):
      selftests/bpf: Fix IMA test

Roi Dayan (4):
      net/mlx5: E-Switch, Remove redundant dev arg from mlx5_esw_vport_alloc()
      net/mlx5: E-Switch, Remove unused mlx5_esw_offloads_vport_metadata_set()
      net/mlx5: Update op_mode to op_mod for port selection
      net/mlx5e: Fix error flow in representor failing to add vport rx rule

Rong Tao (3):
      selftests/bpf: Fix compilation errors: Assign a value to a constant
      tools/resolve_btfids: Add /libsubcmd to .gitignore
      samples/bpf: sampleip: Replace PAGE_OFFSET with _text address

Ross Zwisler (2):
      bpf: use canonical ftrace path
      selftests/bpf: use canonical ftrace path

Ruihan Li (2):
      bluetooth: Add cmd validity checks at the start of hci_sock_ioctl()
      bluetooth: Perform careful capability checks in hci_sock_ioctl()

Russell King (Oracle) (14):
      net: mtk_eth_soc: tidy mtk_gmac0_rgmii_adjust()
      net: mtk_eth_soc: move trgmii ddr2 check to probe function
      net: mtk_eth_soc: remove unnecessary checks in mtk_mac_config()
      net: mtk_eth_soc: remove support for RMII and REVMII modes
      net: sfp: add A2h presence flag
      net: sfp: only use soft polling if we have A2h access
      net: pcs: xpcs: remove double-read of link state when using AN
      net: pcs: lynx: don't print an_enabled in pcs_get_state()
      net: dsa: qca8k: remove assignment of an_enabled in pcs_get_state()
      net: dpaa2-mac: use Autoneg bit rather than an_enabled
      net: pcs: xpcs: use Autoneg bit rather than an_enabled
      net: phylink: remove an_enabled
      net: sfp-bus: allow SFP quirks to override Autoneg and pause bits
      net: sfp: add quirk for 2.5G copper SFP

Ryder Lee (19):
      wifi: mac80211: introduce ieee80211_refresh_tx_agg_session_timer()
      wifi: mac80211: add EHT MU-MIMO related flags in ieee80211_bss_conf
      wifi: mac80211: add LDPC related flags in ieee80211_bss_conf
      wifi: mac80211: enable EHT mesh support
      wifi: mt76: mt7996: fix radiotap bitfield
      wifi: mt76: dynamic channel bandwidth changes in AP mode
      wifi: mt76: connac: refresh tx session timer for WED device
      wifi: mt76: mt7915: remove mt7915_mcu_beacon_check_caps()
      wifi: mt76: mt7996: remove mt7996_mcu_beacon_check_caps()
      wifi: mt76: mt7915: drop redundant prefix of mt7915_txpower_puts()
      wifi: mt76: mt7996: add full system reset knobs into debugfs
      wifi: mt76: mt7996: enable coredump support
      wifi: mt76: connac: fix txd multicast rate setting
      wifi: mt76: connac: add nss calculation into mt76_connac2_mac_tx_rate_val()
      wifi: mt76: mt7996: enable BSS_CHANGED_BASIC_RATES support
      wifi: mt76: mt7996: enable BSS_CHANGED_MCAST_RATE support
      wifi: mt76: mt7996: enable configured beacon tx rate
      wifi: mt76: mt7996: enable mesh HW amsdu/de-amsdu support
      wifi: mt76: mt7996: fill txd by host driver

Saeed Mahameed (1):
      net/mlx5e: Fix build break on 32bit

Samin Guo (3):
      dt-bindings: net: snps,dwmac: Add 'ahb' reset/reset-name
      net: stmmac: Add glue layer for StarFive JH7110 SoC
      net: stmmac: dwmac-starfive: Add phy interface settings

Sandipan Patra (1):
      net/mlx5: Implement thermal zone

Sascha Hauer (4):
      wifi: rtw88: usb: fix priority queue to endpoint mapping
      wifi: rtw88: rtw8821c: Fix rfe_option field width
      wifi: rtw88: set pkg_type correctly for specific rtw8821c variants
      wifi: rtw88: call rtw8821c_switch_rf_set() according to chip variant

Sasha Neftin (2):
      igc: Clean up and optimize watchdog task
      igc: Remove obsolete DMA coalescing code

Sean Anderson (10):
      net: sunhme: Fix uninitialized return code
      net: sunhme: Just restart autonegotiation if we can't bring the link up
      net: sunhme: Remove residual polling code
      net: sunhme: Unify IRQ requesting
      net: sunhme: Alphabetize includes
      net: sunhme: Switch SBUS to devres
      net: sunhme: Consolidate mac address initialization
      net: sunhme: Clean up mac address init
      net: sunhme: Inline error returns
      net: sunhme: Consolidate common probe tasks

Sean Wang (2):
      wifi: mt76: mt7921: enable p2p support
      mt76: mt7921: fix kernel panic by accessing unallocated eeprom.data

Sean Young (1):
      bpf: lirc program type should not require SYS_CAP_ADMIN

Sebastian Reichel (2):
      net: ethernet: stmmac: dwmac-rk: rework optional clock handling
      net: ethernet: stmmac: dwmac-rk: fix optional phy regulator handling

Shailend Chand (1):
      gve: Unify duplicate GQ min pkt desc size constants

Shannon Nelson (14):
      pds_core: initial framework for pds_core PF driver
      pds_core: add devcmd device interfaces
      pds_core: health timer and workqueue
      pds_core: add devlink health facilities
      pds_core: set up device and adminq
      pds_core: Add adminq processing and commands
      pds_core: add FW update feature to devlink
      pds_core: set up the VIF definitions and defaults
      pds_core: add initial VF device handling
      pds_core: add auxiliary_bus devices
      pds_core: devlink params for enabling VIF support
      pds_core: add the aux client API
      pds_core: publish events to the clients
      pds_core: Kconfig and pds_core.rst

Shaul Triebitz (5):
      wifi: iwlwifi: mvm: use the link sta address
      wifi: iwlwifi: mvm: implement mac80211 callback change_sta_links
      wifi: iwlwifi: mvm: translate management frame address
      wifi: iwlwifi: mvm: use bcast/mcast link station id
      wifi: iwlwifi: mvm: use the correct link queue

Shay Agroskin (6):
      netlink: Add a macro to set policy message with format string
      ethtool: Add support for configuring tx_push_buf_len
      net: ena: Make few cosmetic preparations to support large LLQ
      net: ena: Recalculate TX state variables every device reset
      net: ena: Add support to changing tx_push_buf_len
      net: ena: Advertise TX push support

Shayne Chen (3):
      wifi: mt76: mt7996: add eht rx rate support
      wifi: mt76: mt7996: let non-bufferable MMPDUs use correct hw queue
      wifi: mt76: mt7996: remove unused eeprom band selection

Shenwei Wang (2):
      net: stmmac: add support for platform specific reset
      net: stmmac: dwmac-imx: use platform specific reset for imx93 SoCs

Shradha Gupta (1):
      net: mana: Add new MANA VF performance counters for easier troubleshooting

Siddharth Vadapalli (11):
      dt-bindings: net: ti: k3-am654-cpsw-nuss: Document Serdes PHY
      net: ethernet: ti: am65-cpsw: Update name of Serdes PHY
      dt-bindings: net: ti: k3-am654-cpsw-nuss: Fix compatible order
      dt-bindings: net: ti: k3-am654-cpsw-nuss: Add J784S4 CPSW9G support
      net: ethernet: ti: am65-cpsw: Simplify setting supported interface
      net: ethernet: ti: am65-cpsw: Add support for SGMII mode
      net: ethernet: ti: am65-cpsw: Enable SGMII mode for J7200
      net: ethernet: ti: am65-cpsw: Enable SGMII mode for J721E
      net: ethernet: ti: am65-cpsw: Move mode specific config to mac_config()
      net: ethernet: ti: am65-cpsw: Enable QSGMII for J784S4 CPSW9G
      net: ethernet: ti: am65-cpsw: Enable USXGMII mode for J784S4 CPSW9G

Simon Horman (15):
      net: ena: removed unused tx_bytes variable
      octeontx2-af: update type of prof fields in nix_aw_enq_req
      net: qrtr: correct types of trace event parameters
      net: sunhme: move asm includes to below linux includes
      net: stmmac: dwmac-anarion: Use annotation __iomem for register base
      net: stmmac: dwmac-anarion: Always return struct anarion_gmac * from anarion_config_dt()
      net: ethernet: mtk_eth_soc: use be32 type to store be32 values
      ksz884x: Remove unused functions
      net: stmmac: dwmac-meson8b: Avoid cast to incompatible function type
      wifi: rtw88: Update spelling in main.h
      flow_dissector: Address kdoc warnings
      ipvs: Update width of source for ip_vs_sync_conn_options
      ipvs: Consistently use array_size() in ip_vs_conn_init()
      ipvs: Remove {Enter,Leave}Function
      ipvs: Correct spelling in comments

Slark Xiao (1):
      wwan: core: add print for wwan port attach/disconnect

Solomon Tan (3):
      wifi: iwlwifi: Remove prohibited spaces
      wifi: iwlwifi: Add required space before open '('
      wifi: iwlwifi: Replace space with tabs as code indent

Song Liu (4):
      selftests/bpf: Use PERF_COUNT_HW_CPU_CYCLES event for get_branch_snapshot
      selftests/bpf: Use read_perf_max_sample_freq() in perf_event_stackmap
      selftests/bpf: Fix leaked bpf_link in get_stackid_cannot_attach
      selftests/bpf: Keep the loop in bpf_testmod_loop_test

Song Yoong Siang (3):
      net: stmmac: introduce wrapper for struct xdp_buff
      net: stmmac: add Rx HWTS metadata to XDP receive pkt
      net: stmmac: add Rx HWTS metadata to XDP ZC receive pkt

Sreevani Sreejith (1):
      bpf, docs: Libbpf overview documentation

Sriram Yagnaraman (1):
      netfilter: bridge: introduce broute meta statement

Stanislav Fomichev (7):
      selftests/bpf: Fix BPF_FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL for empty flow label
      tools: ynl: support byte-order in cli
      tools: ynl: populate most of the ethtool spec
      tools: ynl: replace print with NlError
      tools: ynl: ethtool testing tool
      bpf: Don't EFAULT for getsockopt with optval=NULL
      selftests/bpf: Verify optval=NULL case

StanleyYP Wang (1):
      wifi: mt76: mt7996: fix eeprom tx path bitfields

Steen Hegelund (5):
      net: microchip: sparx5: Correct the spelling of the keysets in debugfs
      net: microchip: sparx5: Provide rule count, key removal and keyset select
      net: microchip: sparx5: Add TC template list to a port
      net: microchip: sparx5: Add port keyset changing functionality
      net: microchip: sparx5: Add TC template support

Steev Klimaszewski (3):
      dt-bindings: net: Add WCN6855 Bluetooth
      Bluetooth: hci_qca: Add support for QTI Bluetooth chip wcn6855
      Bluetooth: hci_qca: mark OF related data as maybe unused

Stefan Eichenberger (4):
      dt-bindings: bluetooth: marvell: add 88W8997
      dt-bindings: bluetooth: marvell: add max-speed property
      Bluetooth: hci_mrvl: use maybe_unused macro for device tree ids
      Bluetooth: hci_mrvl: Add serdev support for 88W8997

Stefan Raspl (2):
      net/smc: Introduce explicit check for v2 support
      net/ism: Remove extra include

Sujuan Chen (1):
      wifi: mt76: mt7915: add dev->hif2 support for mt7916 WED device

Sylwester Dziedziuch (1):
      i40e: Add support for VF to specify its primary MAC address

Taichi Nishimura (1):
      fix typos in net/sched/* files

Takashi Iwai (1):
      wifi: ath11k: pci: Add more MODULE_FIRMWARE() entries

Tamizh Chelvam Raja (2):
      wifi: ath11k: Set ext passive scan flag to adjust passive scan start time
      wifi: ath11k: Disable Spectral scan upon removing interface

Tan Tee Min (1):
      igc: offload queue max SDU from tc-taprio

Tariq Toukan (15):
      net/mlx5e: Move XDP struct and enum to XDP header
      net/mlx5e: Move struct mlx5e_xmit_data to datapath header
      net/mlx5e: Introduce extended version for mlx5e_xmit_data
      net/mlx5e: XDP, Remove doubtful unlikely calls
      net/mlx5e: XDP, Use multiple single-entry objects in xdpi_fifo
      net/mlx5e: XDP, Add support for multi-buffer XDP redirect-in
      net/mlx5e: XDP, Improve Striding RQ check with XDP
      net/mlx5e: XDP, Let XDP checker function get the params as input
      net/mlx5e: XDP, Consider large muti-buffer packets in Striding RQ params calculations
      net/mlx5e: XDP, Remove un-established assumptions on XDP buffer
      net/mlx5e: XDP, Allow non-linear single-segment frames in XDP TX MPWQE
      net/mlx5e: RX, Take shared info fragment addition into a function
      net/mlx5e: RX, Generalize mlx5e_fill_mxbuf()
      net/mlx5e: RX, Prepare non-linear striding RQ for XDP multi-buffer support
      net/mlx5e: RX, Add XDP multi-buffer support in Striding RQ

Tejun Heo (4):
      bpf: Add bpf_cgroup_from_id() kfunc
      selftests/bpf: Add a test case for bpf_cgroup_from_id()
      bpf: Make bpf_get_current_[ancestor_]cgroup_id() available for all program types
      cgroup: Make current_cgns_cgroup_dfl() safe to call after exit_task_namespace()

Tero Kristo (2):
      bpf: Add support for absolute value BPF timers
      selftests/bpf: Add absolute timer test

Thomas Gleixner (3):
      atomics: Provide atomic_add_negative() variants
      atomics: Provide rcuref - scalable reference counting
      net: dst: Switch to rcuref_t reference counting

Tianfei Zhang (1):
      ptp: add ToD device driver for Intel FPGA cards

Tiezhu Yang (4):
      selftests/bpf: Remove not used headers
      libbpf: Use struct user_pt_regs to define __PT_REGS_CAST() for LoongArch
      selftests/bpf: Use __NR_prlimit64 instead of __NR_getrlimit in user_ringbuf test
      selftests/bpf: Set __BITS_PER_LONG if target is bpf for LoongArch

Tim Jiang (1):
      Bluetooth: btusb: Add WCN6855 devcoredump support

Tirthendu Sarkar (8):
      i40e: consolidate maximum frame size calculation for vsi
      i40e: change Rx buffer size for legacy-rx to support XDP multi-buffer
      i40e: add pre-xdp page_count in rx_buffer
      i40e: Change size to truesize when using i40e_rx_buffer_flip()
      i40e: use frame_sz instead of recalculating truesize for building skb
      i40e: introduce next_to_process to i40e_ring
      i40e: add xdp_buff to i40e_ring struct
      i40e: add support for XDP multi-buffer Rx

Toke Høiland-Jørgensen (1):
      wifi: ath9k: Don't mark channelmap stack variable read-only in ath9k_mci_update_wlan_channels()

Tom Rix (20):
      wifi: iwlwifi: mvm: remove setting of 'sta' parameter
      net: cxgb3: remove unused fl_to_qset function
      net: atheros: atl1c: remove unused atl1c_irq_reset function
      liquidio: remove unused IQ_INSTR_MODE_64B function
      wifi: ath10k: remove unused ath10k_get_ring_byte function
      mISDN: remove unused vpm_read_address and cpld_read_reg functions
      qed: remove unused num_ooo_add_to_peninsula variable
      net: ethernet: 8390: axnet_cs: remove unused xfer_count variable
      mac80211: minstrel_ht: remove unused n_supported variable
      net: ksz884x: remove unused change variable
      wifi: ipw2x00: remove unused _ipw_read16 function
      wifi: rtw88: remove unused rtw_pci_get_tx_desc function
      wifi: b43legacy: remove unused freq_r3A_value function
      wifi: brcmsmac: remove unused has_5g variable
      wifi: brcmsmac: ampdu: remove unused suc_mpdu variable
      wifi: mwifiex: remove unused evt_buf variable
      bcma: remove unused mips_read32 function
      net: alteon: remove unused len variable
      wifi: iwlwifi: mvm: initialize seq variable
      wifi: iwlwifi: fw: move memset before early return

Tomasz Moń (1):
      Bluetooth: btusb: Do not require hardcoded interface numbers

Tony Nguyen (3):
      ixgb: Remove ixgb driver
      Documentation/eth/intel: Update address for driver support
      Documentation/eth/intel: Remove references to SourceForge

Tushar Vyavahare (1):
      selftests/xsk: add xdp populate metadata test

Tzung-Bi Shih (1):
      netfilter: conntrack: fix wrong ct->timeout value

Vadim Fedorenko (3):
      net-timestamp: extend SOF_TIMESTAMPING_OPT_ID to HW timestamps
      ptp_ocp: add force_irq to xilinx_spi configuration
      vlan: partially enable SIOCSHWTSTAMP in container

Vasily Khoruzhick (2):
      Bluetooth: Add new quirk for broken local ext features page 2
      Bluetooth: btrtl: add support for the RTL8723CS

Veerasenareddy Burru (8):
      octeon_ep: defer probe if firmware not ready
      octeon_ep: poll for control messages
      octeon_ep: control mailbox for multiple PFs
      octeon_ep: add separate mailbox command and response queues
      octeon_ep: include function id in mailbox commands
      octeon_ep: support asynchronous notifications
      octeon_ep: function id in link info and stats mailbox commands
      octeon_ep: add heartbeat monitor

Veerendranath Jakkam (1):
      wifi: nl80211: Add support for randomizing TA of auth and deauth frames

Victor Hassan (1):
      Bluetooth: btrtl: Add support for RTL8852BS

Viktor Malik (7):
      libbpf: Remove unnecessary ternary operator
      libbpf: Remove several dead assignments
      libbpf: Cleanup linker_append_elf_relos
      bpf: Fix attaching fentry/fexit/fmod_ret/lsm to modules
      bpf/selftests: Test fentry attachment to shadowed functions
      kallsyms, bpf: Move find_kallsyms_symbol_value out of internal header
      kallsyms: move module-related functions under correct configs

Vincenzo Palazzo (1):
      net: socket: suppress unused warning

Vlad Buslov (12):
      net/mlx5: Add mlx5_ifc definitions for bridge multicast support
      net/mlx5: Bridge, increase bridge tables sizes
      net/mlx5: Bridge, move additional data structures to priv header
      net/mlx5: Bridge, extract code to lookup parent bridge of port
      net/mlx5: Bridge, snoop igmp/mld packets
      net/mlx5: Bridge, add per-port multicast replication tables
      net/mlx5: Bridge, support multicast VLAN pop
      net/mlx5: Bridge, implement mdb offload
      net/mlx5: Bridge, add tracepoints for multicast
      net/mlx5e: Don't clone flow post action attributes second time
      net/mlx5e: Release the label when replacing existing ct entry
      Revert "net/mlx5e: Don't use termination table when redundant"

Vladimir Lypak (1):
      wifi: wcn36xx: add support for pronto-v3

Vladimir Oltean (54):
      net: dsa: mv88e6xxx: don't dispose of Global2 IRQ mappings from mdiobus code
      net: dsa: fix db type confusion in host fdb/mdb add/del
      net: don't abuse "default" case for unknown ioctl in dev_ifsioc()
      net: simplify handling of dsa_ndo_eth_ioctl() return code
      net: promote SIOCSHWTSTAMP and SIOCGHWTSTAMP ioctls to dedicated handlers
      net: move copy_from_user() out of net_hwtstamp_validate()
      net: add struct kernel_hwtstamp_config and make net_hwtstamp_validate() use it
      net: dsa: make dsa_port_supports_hwtstamp() construct a fake ifreq
      net: create a netdev notifier for DSA to reject PTP on DSA master
      net: stmmac: remove set but unused mask in stmmac_ethtool_set_link_ksettings()
      net: dsa: replace NETDEV_PRE_CHANGE_HWTSTAMP notifier with a stub
      net: dsa: add trace points for FDB/MDB operations
      net: dsa: add trace points for VLAN operations
      net: mscc: ocelot: strengthen type of "u32 reg" in I/O accessors
      net: mscc: ocelot: refactor enum ocelot_reg decoding to helper
      net: mscc: ocelot: debugging print for statistics regions
      net: mscc: ocelot: remove blank line at the end of ocelot_stats.c
      net: dsa: felix: remove confusing/incorrect comment from felix_setup()
      net: mscc: ocelot: strengthen type of "u32 reg" and "u32 base" in ocelot_stats.c
      net: mscc: ocelot: strengthen type of "int i" in ocelot_stats.c
      net: mscc: ocelot: fix ineffective WARN_ON() in ocelot_stats.c
      net: ethtool: create and export ethtool_dev_mm_supported()
      net/sched: mqprio: simplify handling of nlattr portion of TCA_OPTIONS
      net/sched: mqprio: add extack to mqprio_parse_nlattr()
      net/sched: mqprio: add an extack message to mqprio_parse_opt()
      net/sched: pass netlink extack to mqprio and taprio offload
      net/sched: mqprio: allow per-TC user input of FP adminStatus
      net/sched: taprio: allow per-TC user input of FP adminStatus
      net: enetc: rename "mqprio" to "qopt"
      net: enetc: add support for preemptible traffic classes
      net: mscc: ocelot: export a single ocelot_mm_irq()
      net: mscc: ocelot: remove struct ocelot_mm_state :: lock
      net: mscc: ocelot: optimize ocelot_mm_irq()
      net: mscc: ocelot: don't rely on cached verify_status in ocelot_port_get_mm()
      net: mscc: ocelot: add support for mqprio offload
      net: dsa: felix: act upon the mqprio qopt in taprio offload
      net: mscc: ocelot: add support for preemptible traffic classes
      net: enetc: fix MAC Merge layer remaining enabled until a link down event
      net: enetc: report mm tx-active based on tx-enabled and verify-status
      net: enetc: only commit preemptible TCs to hardware when MM TX is active
      net: enetc: include MAC Merge / FP registers in register dump
      net: ethtool: mm: sanitize some UAPI configurations
      selftests: forwarding: introduce helper for standard ethtool counters
      selftests: forwarding: add a test for MAC Merge layer
      net: phy: add basic driver for NXP CBTX PHY
      net: vlan: don't adjust MAC header in __vlan_insert_inner_tag() unless set
      net: vlan: introduce skb_vlan_eth_hdr()
      net: dpaa: avoid one skb_reset_mac_header() in dpaa_enable_tx_csum()
      net: dsa: tag_ocelot: do not rely on skb_mac_header() for VLAN xmit
      net: dsa: tag_ksz: do not rely on skb_mac_header() in TX paths
      net: dsa: tag_sja1105: don't rely on skb_mac_header() in TX paths
      net: dsa: tag_sja1105: replace skb_mac_header() with vlan_eth_hdr()
      net: dsa: update TX path comments to not mention skb_mac_header()
      net: dsa: tag_ocelot: call only the relevant portion of __skb_vlan_pop() on TX

Wang Zhang (1):
      net: ethernet: mediatek: remove return value check of `mtk_wed_hw_add_debugfs`

Wangyang Guo (1):
      net: dst: Prevent false sharing vs. dst_entry:: __refcnt

Wei Chen (2):
      wifi: rtlwifi: fix incorrect error codes in rtl_debugfs_set_write_rfreg()
      wifi: rtlwifi: fix incorrect error codes in rtl_debugfs_set_write_reg()

Wei Yongjun (1):
      bpftool: Set program type only if it differs from the desired one

Wentao Jia (6):
      nfp: flower: add get_flow_act_ct() for ct action
      nfp: flower: refactor function "is_pre_ct_flow"
      nfp: flower: refactor function "is_post_ct_flow"
      nfp: flower: add goto_chain_index for ct entry
      nfp: flower: prepare for parameterisation of number of offload rules
      nfp: flower: offload tc flows of multiple conntrack zones

Wolfram Sang (7):
      ravb: remove R-Car H3 ES1.* handling
      net: phy: update obsolete comment about PHY_STARTING
      net: phy: micrel: drop superfluous use of temp variable
      sh_eth: remove open coded netif_running()
      ethernet: remove superfluous clearing of phydev
      Revert "sh_eth: remove open coded netif_running()"
      smsc911x: remove superfluous variable init

Xiaoyan Li (2):
      net-zerocopy: Reduce compound page head access
      selftests/net: Add SHA256 computation over data sent in tcp_mmap

Xin Liu (1):
      bpf, sockmap: fix deadlocks in the sockhash and sockmap

Xin Long (17):
      netfilter: bridge: call pskb_may_pull in br_nf_check_hbh_len
      netfilter: bridge: check len before accessing more nh data
      netfilter: bridge: move pskb_trim_rcsum out of br_nf_check_hbh_len
      netfilter: move br_nf_check_hbh_len to utils
      netfilter: use nf_ip6_check_hbh_len in nf_ct_skb_network_trim
      selftests: add a selftest for big tcp
      sctp: add fair capacity stream scheduler
      sctp: add weighted fair queueing stream scheduler
      ipv6: prevent router_solicitations for team port
      sctp: delete the obsolete code for the host name address param
      sctp: add intl_capable and reconf_capable in ss peer_capable
      sctp: delete the nested flexible array params
      sctp: delete the nested flexible array skip
      sctp: delete the nested flexible array variable
      sctp: delete the nested flexible array peer_init
      sctp: delete the nested flexible array hmac
      sctp: delete the nested flexible array payload

Xu Kuohai (2):
      selftests/bpf: Check when bounds are not in the 32-bit range
      selftests/bpf: Rewrite two infinite loops in bound check cases

Xu Liang (1):
      net: phy: mxl-gpy: enhance delay time required by loopback disable function

Yafang (1):
      bpf: Add preempt_count_{sub,add} into btf id deny list

Yafang Shao (19):
      bpf: add new map ops ->map_mem_usage
      bpf: lpm_trie memory usage
      bpf: hashtab memory usage
      bpf: arraymap memory usage
      bpf: stackmap memory usage
      bpf: reuseport_array memory usage
      bpf: ringbuf memory usage
      bpf: bloom_filter memory usage
      bpf: cpumap memory usage
      bpf: devmap memory usage
      bpf: queue_stack_maps memory usage
      bpf: bpf_struct_ops memory usage
      bpf: local_storage memory usage
      bpf, net: bpf_local_storage memory usage
      bpf, net: sock_map memory usage
      bpf, net: xskmap memory usage
      bpf: offload map memory usage
      bpf: enforce all maps having memory usage callback
      bpf: Add __rcu_read_{lock,unlock} into btf id deny list

Yajun Deng (1):
      net: sched: Print msecs when transmit queue time out

Yan Wang (1):
      net: stmmac:fix system hang when setting up tag_8021q VLAN for DSA ports

Yang Li (4):
      wifi: ath12k: dp_mon: Fix unsigned comparison with less than zero
      wifi: ath12k: dp_mon: clean up some inconsistent indentings
      wifi: ath10k: Remove the unused function shadow_dst_wr_ind_addr() and ath10k_ce_error_intr_enable()
      wifi: mt76: mt7996: Remove unneeded semicolon

Yang Yingliang (1):
      wifi: ath11k: fix return value check in ath11k_ahb_probe()

Yanhong Wang (1):
      dt-bindings: net: Add support StarFive dwmac

Yevgeny Kliteynik (24):
      net/mlx5: DR, Set counter ID on the last STE for STEv1 TX
      net/mlx5: Add mlx5_ifc bits for modify header argument
      net/mlx5: Add new WQE for updating flow table
      net/mlx5: DR, Prepare sending new WQE type
      net/mlx5: DR, Add modify-header-pattern ICM pool
      net/mlx5: DR, Move ACTION_CACHE_LINE_SIZE macro to header
      net/mlx5: DR, Add cache for modify header pattern
      net/mlx5: DR, Split chunk allocation to HW-dependent ways
      net/mlx5: DR, Check for modify_header_argument device capabilities
      net/mlx5: DR, Add create/destroy for modify-header-argument general object
      net/mlx5: DR, Add support for writing modify header argument
      net/mlx5: DR, Read ICM memory into dedicated buffer
      net/mlx5: DR, Fix QP continuous allocation
      net/mlx5: DR, Add modify header arg pool mechanism
      net/mlx5: DR, Add modify header argument pointer to actions attributes
      net/mlx5: DR, Apply new accelerated modify action and decapl3
      net/mlx5: DR, Support decap L3 action using pattern / arg mechanism
      net/mlx5: DR, Modify header action of size 1 optimization
      net/mlx5: DR, Add support for the pattern/arg parameters in debug dump
      net/mlx5: DR, Enable patterns and arguments for supporting devices
      net/mlx5: DR, Fix dumping of legacy modify_hdr in debug dump
      net/mlx5: DR, Calculate sync threshold of each pool according to its type
      net/mlx5: DR, Add more info in domain dbg dump
      net/mlx5: DR, Add memory statistics for domain object

YiFei Zhu (1):
      selftests/bpf: Wait for receive in cg_storage_multi test

Yingsha Xu (1):
      wifi: mac80211: remove return value check of debugfs_create_dir()

Yinjun Zhang (1):
      nfp: initialize netdev's dev_port with correct id

Yixin Shen (2):
      bpf: allow a TCP CC to write app_limited
      selftests/bpf: test a BPF CC writing app_limited

Yonghong Song (8):
      libbpf: Fix bpf_xdp_query() in old kernels
      selftests/bpf: Workaround verification failure for fexit_bpf2bpf/func_replace_return_code
      bpf: Improve verifier JEQ/JNE insn branch taken checking
      selftests/bpf: Add tests for non-constant cond_op NE/EQ bound deduction
      bpf: Improve handling of pattern '<const> <cond_op> <non_const>' in verifier
      selftests/bpf: Add verifier tests for code pattern '<const> <cond_op> <non_const>'
      bpf: Improve verifier u32 scalar equality checking
      selftests/bpf: Add a selftest for checking subreg equality

Youghandhar Chintala (1):
      wifi: ath11k: enable SAR support on WCN6750

Zhengchao Shao (1):
      net: libwx: fix memory leak in wx_setup_rx_resources

Zijun Hu (1):
      Bluetooth: Devcoredump: Fix storing u32 without specifying byte order issue

Ziyang Xuan (1):
      ipv4: Fix potential uninit variable access bug in __ip_make_skb()

Zong-Zhe Yang (4):
      wifi: rtw89: fw: configure CRASH_TRIGGER feature for 8852B
      wifi: rtw89: refine FW feature judgement on packet drop
      wifi: rtw89: fw: use generic flow to set/check features
      wifi: rtw89: support parameter tables by RFE type

haozhe chang (1):
      wwan: core: Support slicing in port TX flow of WWAN subsystem

mengyuanlou (1):
      net: wangxun: Remove macro that is redefined

wuych (2):
      net: phy: dp83867: Remove unnecessary (void*) conversions
      net: phy: marvell-88x2222: remove unnecessary (void*) conversions

Álvaro Fernández Rojas (6):
      net: dsa: b53: add support for BCM63xx RGMIIs
      dt-bindings: net: dsa: b53: add more 63xx SoCs
      net: dsa: b53: mmap: add more 63xx SoCs
      net: dsa: b53: mmap: allow passing a chip ID
      net: dsa: b53: add BCM63268 RGMII configuration
      dt-bindings: net: dsa: b53: add BCM53134 support

Íñigo Huguet (4):
      sfc: store PTP filters in a list
      sfc: allow insertion of filters for unicast PTP
      sfc: support unicast PTP
      sfc: remove expired unicast PTP filters

 .gitignore                                         |     1 +
 Documentation/PCI/pci-error-recovery.rst           |     1 -
 Documentation/bpf/bpf_design_QA.rst                |     4 +-
 Documentation/bpf/bpf_devel_QA.rst                 |    20 +-
 Documentation/bpf/clang-notes.rst                  |     6 +
 Documentation/bpf/cpumasks.rst                     |    34 +-
 Documentation/bpf/instruction-set.rst              |   169 +-
 Documentation/bpf/kfuncs.rst                       |   182 +-
 Documentation/bpf/libbpf/index.rst                 |    25 +-
 Documentation/bpf/libbpf/libbpf_overview.rst       |   228 +
 Documentation/bpf/linux-notes.rst                  |    30 +
 Documentation/bpf/maps.rst                         |     7 +-
 .../bindings/arm/mediatek/mediatek,mt7622-wed.yaml |     1 +
 .../bindings/arm/mediatek/mediatek,sgmiisys.txt    |    27 -
 .../bindings/arm/stm32/st,stm32-syscon.yaml        |     2 +
 .../devicetree/bindings/net/actions,owl-emac.yaml  |     2 +-
 .../bindings/net/allwinner,sun4i-a10-emac.yaml     |     2 +-
 .../bindings/net/allwinner,sun4i-a10-mdio.yaml     |     2 +-
 .../devicetree/bindings/net/altr,tse.yaml          |     2 +-
 .../bindings/net/amlogic,meson-dwmac.yaml          |     4 +-
 .../bindings/net/aspeed,ast2600-mdio.yaml          |     2 +-
 .../bindings/net/bluetooth/nxp,88w8987-bt.yaml     |    45 +
 .../bindings/net/bluetooth/qualcomm-bluetooth.yaml |    17 +
 .../devicetree/bindings/net/brcm,amac.yaml         |     2 +-
 .../devicetree/bindings/net/brcm,systemport.yaml   |     2 +-
 .../bindings/net/broadcom-bluetooth.yaml           |     2 +-
 .../devicetree/bindings/net/can/fsl,flexcan.yaml   |     3 +
 .../bindings/net/can/st,stm32-bxcan.yaml           |    85 +
 .../devicetree/bindings/net/can/xilinx,can.yaml    |     6 +-
 .../devicetree/bindings/net/dsa/brcm,b53.yaml      |     4 +
 .../devicetree/bindings/net/dsa/brcm,sf2.yaml      |    12 +-
 .../bindings/net/dsa/mediatek,mt7530.yaml          |    32 +-
 .../devicetree/bindings/net/dsa/qca8k.yaml         |    24 +-
 .../devicetree/bindings/net/engleder,tsnep.yaml    |     2 +-
 .../bindings/net/ethernet-controller.yaml          |    37 +-
 .../devicetree/bindings/net/ethernet-phy.yaml      |    45 +-
 .../devicetree/bindings/net/ethernet-switch.yaml   |     6 +-
 Documentation/devicetree/bindings/net/fsl,fec.yaml |     3 +
 .../bindings/net/fsl,qoriq-mc-dpmac.yaml           |     2 +-
 .../bindings/net/intel,ixp46x-ptp-timer.yaml       |     4 +-
 .../bindings/net/intel,ixp4xx-ethernet.yaml        |    12 +-
 .../devicetree/bindings/net/intel,ixp4xx-hss.yaml  |    18 +-
 .../devicetree/bindings/net/marvell,mvusb.yaml     |     2 +-
 .../devicetree/bindings/net/marvell-bluetooth.yaml |    24 +-
 .../devicetree/bindings/net/mdio-gpio.yaml         |     2 +-
 .../devicetree/bindings/net/mediatek,net.yaml      |    55 +-
 .../bindings/net/mediatek,star-emac.yaml           |     2 +-
 .../bindings/net/microchip,lan966x-switch.yaml     |     2 +-
 .../bindings/net/microchip,sparx5-switch.yaml      |     4 +-
 .../devicetree/bindings/net/mscc,miim.yaml         |     2 +-
 .../devicetree/bindings/net/nfc/marvell,nci.yaml   |     2 +-
 .../devicetree/bindings/net/nfc/nxp,pn532.yaml     |     2 +-
 .../bindings/net/pcs/mediatek,sgmiisys.yaml        |    55 +
 .../bindings/net/pse-pd/podl-pse-regulator.yaml    |     2 +-
 .../devicetree/bindings/net/qcom,ethqos.txt        |    66 -
 .../devicetree/bindings/net/qcom,ethqos.yaml       |   111 +
 .../devicetree/bindings/net/qcom,ipa.yaml          |     1 +
 .../devicetree/bindings/net/qcom,ipq4019-mdio.yaml |     2 +-
 .../devicetree/bindings/net/qcom,ipq8064-mdio.yaml |     6 +-
 .../devicetree/bindings/net/realtek-bluetooth.yaml |    24 +-
 .../devicetree/bindings/net/rockchip,emac.yaml     |     2 +-
 .../devicetree/bindings/net/rockchip-dwmac.yaml    |     4 +-
 Documentation/devicetree/bindings/net/sff,sfp.yaml |     4 +-
 .../devicetree/bindings/net/snps,dwmac.yaml        |    28 +-
 .../bindings/net/starfive,jh7110-dwmac.yaml        |   144 +
 .../devicetree/bindings/net/stm32-dwmac.yaml       |     8 +-
 .../devicetree/bindings/net/ti,cpsw-switch.yaml    |    10 +-
 .../devicetree/bindings/net/ti,davinci-mdio.yaml   |     2 +-
 .../devicetree/bindings/net/ti,dp83822.yaml        |     6 +-
 .../devicetree/bindings/net/ti,dp83867.yaml        |     6 +-
 .../devicetree/bindings/net/ti,dp83869.yaml        |     6 +-
 .../bindings/net/ti,k3-am654-cpsw-nuss.yaml        |    24 +-
 .../bindings/net/toshiba,visconti-dwmac.yaml       |     4 +-
 .../devicetree/bindings/net/vertexcom-mse102x.yaml |     4 +-
 .../bindings/net/wireless/mediatek,mt76.yaml       |     5 +
 .../bindings/net/wireless/qcom,ath10k.txt          |   215 -
 .../bindings/net/wireless/qcom,ath10k.yaml         |   358 +
 .../bindings/net/wireless/qcom,ath11k-pci.yaml     |    58 +
 Documentation/hwmon/hwmon-kernel-api.rst           |     6 +-
 Documentation/leds/well-known-leds.txt             |    30 +
 Documentation/netlink/genetlink-c.yaml             |     2 +-
 Documentation/netlink/genetlink-legacy.yaml        |    18 +-
 Documentation/netlink/genetlink.yaml               |     3 +
 Documentation/netlink/specs/devlink.yaml           |   198 +
 Documentation/netlink/specs/ethtool.yaml           |  1484 +-
 Documentation/netlink/specs/handshake.yaml         |   124 +
 Documentation/netlink/specs/ovs_datapath.yaml      |   153 +
 Documentation/netlink/specs/ovs_vport.yaml         |   139 +
 .../device_drivers/can/ctu/ctucanfd-driver.rst     |     3 +-
 .../device_drivers/ethernet/amd/pds_core.rst       |   139 +
 .../networking/device_drivers/ethernet/index.rst   |     2 +-
 .../device_drivers/ethernet/intel/e100.rst         |     7 +-
 .../device_drivers/ethernet/intel/e1000.rst        |     9 +-
 .../device_drivers/ethernet/intel/e1000e.rst       |     7 +-
 .../device_drivers/ethernet/intel/fm10k.rst        |     7 +-
 .../device_drivers/ethernet/intel/i40e.rst         |    11 +-
 .../device_drivers/ethernet/intel/iavf.rst         |     7 +-
 .../device_drivers/ethernet/intel/ice.rst          |     9 +-
 .../device_drivers/ethernet/intel/igb.rst          |     7 +-
 .../device_drivers/ethernet/intel/igbvf.rst        |     7 +-
 .../device_drivers/ethernet/intel/ixgb.rst         |   468 -
 .../device_drivers/ethernet/intel/ixgbe.rst        |     7 +-
 .../device_drivers/ethernet/intel/ixgbevf.rst      |     7 +-
 .../ethernet/mellanox/mlx5/counters.rst            |    26 -
 .../ethernet/mellanox/mlx5/devlink.rst             |    68 +
 Documentation/networking/devlink/mlx5.rst          |    12 +
 Documentation/networking/driver.rst                |   156 +-
 Documentation/networking/ethtool-netlink.rst       |    51 +-
 Documentation/networking/index.rst                 |     2 +
 Documentation/networking/ip-sysctl.rst             |     7 +
 Documentation/networking/napi.rst                  |   254 +
 Documentation/networking/page_pool.rst             |     1 +
 Documentation/networking/rxrpc.rst                 |    17 +-
 Documentation/networking/tls-handshake.rst         |   217 +
 Documentation/process/maintainer-netdev.rst        |    38 +-
 .../userspace-api/netlink/genetlink-legacy.rst     |    88 +-
 Documentation/userspace-api/netlink/specs.rst      |    10 +
 MAINTAINERS                                        |    79 +-
 arch/arm/boot/dts/armada-370-rd.dts                |    12 +
 arch/arm/boot/dts/qcom-ipq8064-rb3011.dts          |   124 +-
 arch/arm/boot/dts/stm32f4-pinctrl.dtsi             |    30 +
 arch/arm/boot/dts/stm32f429.dtsi                   |    29 +
 .../boot/dts/rockchip/rk3566-anbernic-rgxx3.dtsi   |     2 +-
 arch/loongarch/configs/loongson3_defconfig         |     1 -
 arch/loongarch/net/bpf_jit.c                       |     6 +
 arch/mips/Kconfig                                  |     5 +-
 arch/mips/configs/loongson2k_defconfig             |     1 -
 arch/mips/configs/loongson3_defconfig              |     1 -
 arch/mips/configs/mtx1_defconfig                   |     1 -
 arch/mips/net/bpf_jit_comp.c                       |     4 +
 arch/mips/net/bpf_jit_comp64.c                     |     3 +
 arch/powerpc/configs/powernv_defconfig             |     1 -
 arch/powerpc/configs/ppc64_defconfig               |     1 -
 arch/powerpc/configs/ppc64e_defconfig              |     1 -
 arch/powerpc/configs/ppc6xx_defconfig              |     1 -
 arch/powerpc/configs/pseries_defconfig             |     1 -
 arch/powerpc/configs/skiroot_defconfig             |     1 -
 arch/riscv/net/bpf_jit_comp64.c                    |     5 +
 arch/s390/net/bpf_jit_comp.c                       |     5 +
 drivers/accel/habanalabs/common/hwmon.c            |     2 +-
 drivers/bcma/driver_mips.c                         |     6 -
 drivers/bcma/main.c                                |    11 +-
 drivers/bluetooth/Kconfig                          |    14 +
 drivers/bluetooth/Makefile                         |     1 +
 drivers/bluetooth/btbcm.c                          |    47 +-
 drivers/bluetooth/btintel.c                        |    77 +-
 drivers/bluetooth/btintel.h                        |    12 +-
 drivers/bluetooth/btmrvl_sdio.c                    |     2 +-
 drivers/bluetooth/btmtkuart.c                      |     6 +-
 drivers/bluetooth/btnxpuart.c                      |  1352 ++
 drivers/bluetooth/btqca.c                          |    14 +-
 drivers/bluetooth/btqca.h                          |    10 +
 drivers/bluetooth/btrtl.c                          |   502 +-
 drivers/bluetooth/btrtl.h                          |    58 +-
 drivers/bluetooth/btsdio.c                         |     1 -
 drivers/bluetooth/btusb.c                          |   318 +-
 drivers/bluetooth/hci_bcm.c                        |    60 +-
 drivers/bluetooth/hci_h5.c                         |     6 +
 drivers/bluetooth/hci_ldisc.c                      |     8 +-
 drivers/bluetooth/hci_ll.c                         |     2 +-
 drivers/bluetooth/hci_mrvl.c                       |    90 +-
 drivers/bluetooth/hci_qca.c                        |    67 +-
 drivers/bluetooth/hci_vhci.c                       |   101 +
 drivers/hid/bpf/hid_bpf_dispatch.c                 |     3 -
 drivers/hwmon/hwmon.c                              |     4 +-
 drivers/isdn/hardware/mISDN/hfcmulti.c             |    31 -
 drivers/isdn/hardware/mISDN/netjet.c               |     1 -
 drivers/mfd/ocelot-core.c                          |    13 +
 drivers/net/Kconfig                                |     2 +
 drivers/net/bonding/bond_main.c                    |    30 +
 drivers/net/can/Kconfig                            |    12 +
 drivers/net/can/Makefile                           |     1 +
 drivers/net/can/bxcan.c                            |  1098 ++
 drivers/net/can/c_can/c_can_pci.c                  |     2 -
 drivers/net/can/ctucanfd/ctucanfd_pci.c            |     8 +-
 drivers/net/can/kvaser_pciefd.c                    |     1 -
 drivers/net/can/m_can/m_can.c                      |    37 +-
 drivers/net/can/rcar/rcar_canfd.c                  |    71 +-
 drivers/net/can/usb/esd_usb.c                      |   195 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   102 +-
 drivers/net/dsa/Kconfig                            |    26 +-
 drivers/net/dsa/Makefile                           |     2 +
 drivers/net/dsa/b53/b53_common.c                   |    78 +
 drivers/net/dsa/b53/b53_mdio.c                     |     5 +-
 drivers/net/dsa/b53/b53_mmap.c                     |    29 +-
 drivers/net/dsa/b53/b53_priv.h                     |    17 +-
 drivers/net/dsa/b53/b53_regs.h                     |     1 +
 drivers/net/dsa/hirschmann/hellcreek_ptp.c         |    45 +-
 drivers/net/dsa/lan9303_i2c.c                      |     2 +-
 drivers/net/dsa/lan9303_mdio.c                     |     2 +-
 drivers/net/dsa/lantiq_gswip.c                     |     2 +-
 drivers/net/dsa/microchip/ksz8.h                   |     8 +-
 drivers/net/dsa/microchip/ksz8795.c                |   179 +-
 drivers/net/dsa/microchip/ksz9477_i2c.c            |     2 +-
 drivers/net/dsa/microchip/ksz_common.c             |   240 +-
 drivers/net/dsa/microchip/ksz_common.h             |    18 +-
 drivers/net/dsa/mt7530-mdio.c                      |   271 +
 drivers/net/dsa/mt7530-mmio.c                      |   101 +
 drivers/net/dsa/mt7530.c                           |   720 +-
 drivers/net/dsa/mt7530.h                           |    89 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   387 +-
 drivers/net/dsa/mv88e6xxx/global2.c                |    20 +-
 drivers/net/dsa/ocelot/felix.c                     |    24 +-
 drivers/net/dsa/ocelot/felix.h                     |     7 +
 drivers/net/dsa/ocelot/felix_vsc9959.c             |    43 +-
 drivers/net/dsa/ocelot/ocelot_ext.c                |    18 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c           |     2 +-
 drivers/net/dsa/qca/Kconfig                        |     8 +
 drivers/net/dsa/qca/Makefile                       |     3 +
 drivers/net/dsa/qca/qca8k-8xxx.c                   |    21 +-
 drivers/net/dsa/qca/qca8k-leds.c                   |   277 +
 drivers/net/dsa/qca/qca8k.h                        |    74 +
 drivers/net/dsa/qca/qca8k_leds.h                   |    16 +
 drivers/net/dsa/realtek/rtl8365mb.c                |    40 +-
 drivers/net/ethernet/8390/axnet_cs.c               |     3 -
 drivers/net/ethernet/Kconfig                       |     2 +-
 drivers/net/ethernet/alteon/acenic.c               |     3 +-
 drivers/net/ethernet/amazon/ena/ena_eth_com.h      |     4 +
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |    66 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |   261 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.h       |    15 +-
 drivers/net/ethernet/amd/Kconfig                   |    12 +
 drivers/net/ethernet/amd/Makefile                  |     1 +
 drivers/net/ethernet/amd/nmclan_cs.c               |     2 +-
 drivers/net/ethernet/amd/pds_core/Makefile         |    14 +
 drivers/net/ethernet/amd/pds_core/adminq.c         |   290 +
 drivers/net/ethernet/amd/pds_core/auxbus.c         |   264 +
 drivers/net/ethernet/amd/pds_core/core.c           |   597 +
 drivers/net/ethernet/amd/pds_core/core.h           |   312 +
 drivers/net/ethernet/amd/pds_core/debugfs.c        |   170 +
 drivers/net/ethernet/amd/pds_core/dev.c            |   351 +
 drivers/net/ethernet/amd/pds_core/devlink.c        |   183 +
 drivers/net/ethernet/amd/pds_core/fw.c             |   194 +
 drivers/net/ethernet/amd/pds_core/main.c           |   475 +
 .../net/ethernet/aquantia/atlantic/aq_drvinfo.c    |     2 +-
 drivers/net/ethernet/atheros/alx/main.c            |     4 -
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |    10 -
 drivers/net/ethernet/broadcom/bnx2.c               |    52 +-
 drivers/net/ethernet/broadcom/bnx2.h               |     1 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h        |     1 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |     3 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |    19 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |    57 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |    66 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |     2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |    14 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c    |    16 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c      |    29 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.h      |     6 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |     6 +-
 drivers/net/ethernet/broadcom/sb1250-mac.c         |     6 +-
 drivers/net/ethernet/cadence/macb.h                |     8 +-
 drivers/net/ethernet/cadence/macb_main.c           |    41 +-
 drivers/net/ethernet/cadence/macb_ptp.c            |     4 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |     1 -
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c |     1 -
 .../net/ethernet/cavium/liquidio/request_manager.c |     9 -
 drivers/net/ethernet/chelsio/cxgb3/sge.c           |     5 -
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |     4 -
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |     2 -
 drivers/net/ethernet/ec_bhf.c                      |     2 -
 drivers/net/ethernet/emulex/benet/be_cmds.c        |    27 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |    10 +-
 drivers/net/ethernet/engleder/tsnep.h              |    16 +-
 drivers/net/ethernet/engleder/tsnep_main.c         |   864 +-
 drivers/net/ethernet/engleder/tsnep_xdp.c          |    66 +
 drivers/net/ethernet/freescale/Kconfig             |     1 +
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |    12 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c   |     3 +-
 drivers/net/ethernet/freescale/enetc/Kconfig       |     1 +
 drivers/net/ethernet/freescale/enetc/enetc.c       |    20 +-
 drivers/net/ethernet/freescale/enetc/enetc.h       |     4 +
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |    94 +-
 drivers/net/ethernet/freescale/enetc/enetc_hw.h    |     7 +
 drivers/net/ethernet/fungible/funcore/fun_dev.c    |     7 -
 drivers/net/ethernet/google/gve/gve.h              |   110 +-
 drivers/net/ethernet/google/gve/gve_adminq.c       |     8 +-
 drivers/net/ethernet/google/gve/gve_adminq.h       |     4 +-
 drivers/net/ethernet/google/gve/gve_ethtool.c      |    91 +-
 drivers/net/ethernet/google/gve/gve_main.c         |   719 +-
 drivers/net/ethernet/google/gve/gve_rx.c           |   147 +-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c       |     2 +-
 drivers/net/ethernet/google/gve/gve_tx.c           |   298 +-
 drivers/net/ethernet/google/gve/gve_utils.c        |     6 +-
 drivers/net/ethernet/google/gve/gve_utils.h        |     3 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |    12 +
 .../hisilicon/hns3/hns3_common/hclge_comm_cmd.c    |     1 +
 .../hisilicon/hns3/hns3_common/hclge_comm_cmd.h    |     3 +
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |     3 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |     3 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |     6 +
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |    27 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |    12 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |   137 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |     8 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |     6 +-
 drivers/net/ethernet/intel/Kconfig                 |    17 -
 drivers/net/ethernet/intel/Makefile                |     1 -
 drivers/net/ethernet/intel/e1000e/netdev.c         |     1 -
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c       |     1 -
 drivers/net/ethernet/intel/i40e/i40e.h             |     1 -
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |     7 +
 drivers/net/ethernet/intel/i40e/i40e_main.c        |    88 +-
 drivers/net/ethernet/intel/i40e/i40e_trace.h       |    20 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   422 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h        |    20 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |    74 +-
 drivers/net/ethernet/intel/iavf/iavf.h             |     1 -
 drivers/net/ethernet/intel/ice/ice.h               |     1 -
 drivers/net/ethernet/intel/ice/ice_common.c        |    29 +-
 drivers/net/ethernet/intel/ice/ice_controlq.c      |    12 +-
 drivers/net/ethernet/intel/ice/ice_controlq.h      |     3 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c       |     1 -
 drivers/net/ethernet/intel/ice/ice_gnss.c          |    42 +-
 drivers/net/ethernet/intel/ice/ice_gnss.h          |     3 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |    12 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c         |    77 +-
 drivers/net/ethernet/intel/ice/ice_sriov.h         |    15 -
 drivers/net/ethernet/intel/ice/ice_type.h          |    17 +-
 drivers/net/ethernet/intel/ice/ice_vf_lib.c        |    15 +-
 drivers/net/ethernet/intel/ice/ice_vf_lib.h        |     2 +-
 drivers/net/ethernet/intel/ice/ice_vf_mbx.c        |   249 +-
 drivers/net/ethernet/intel/ice/ice_vf_mbx.h        |    17 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |    49 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl.h      |     8 +
 drivers/net/ethernet/intel/igb/igb_main.c          |     1 -
 drivers/net/ethernet/intel/igb/igb_ptp.c           |    11 +-
 drivers/net/ethernet/intel/igbvf/netdev.c          |    29 +
 drivers/net/ethernet/intel/igc/igc.h               |     4 +-
 drivers/net/ethernet/intel/igc/igc_defines.h       |     3 -
 drivers/net/ethernet/intel/igc/igc_ethtool.c       |     1 +
 drivers/net/ethernet/intel/igc/igc_hw.h            |     1 +
 drivers/net/ethernet/intel/igc/igc_i225.c          |    19 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |    52 +-
 drivers/net/ethernet/intel/igc/igc_regs.h          |     1 -
 drivers/net/ethernet/intel/igc/igc_tsn.c           |    12 +
 drivers/net/ethernet/intel/ixgb/Makefile           |     9 -
 drivers/net/ethernet/intel/ixgb/ixgb.h             |   179 -
 drivers/net/ethernet/intel/ixgb/ixgb_ee.c          |   580 -
 drivers/net/ethernet/intel/ixgb/ixgb_ee.h          |    79 -
 drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c     |   642 -
 drivers/net/ethernet/intel/ixgb/ixgb_hw.c          |  1229 --
 drivers/net/ethernet/intel/ixgb/ixgb_hw.h          |   767 -
 drivers/net/ethernet/intel/ixgb/ixgb_ids.h         |    23 -
 drivers/net/ethernet/intel/ixgb/ixgb_main.c        |  2285 ---
 drivers/net/ethernet/intel/ixgb/ixgb_osdep.h       |    39 -
 drivers/net/ethernet/intel/ixgb/ixgb_param.c       |   442 -
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |     1 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |    23 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |    44 +-
 drivers/net/ethernet/marvell/Kconfig               |     1 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |    24 +-
 .../net/ethernet/marvell/octeon_ep/octep_cn9k_pf.c |    72 +-
 .../net/ethernet/marvell/octeon_ep/octep_config.h  |     6 +
 .../ethernet/marvell/octeon_ep/octep_ctrl_mbox.c   |   276 +-
 .../ethernet/marvell/octeon_ep/octep_ctrl_mbox.h   |    88 +-
 .../ethernet/marvell/octeon_ep/octep_ctrl_net.c    |   387 +-
 .../ethernet/marvell/octeon_ep/octep_ctrl_net.h    |   196 +-
 .../net/ethernet/marvell/octeon_ep/octep_ethtool.c |    12 +-
 .../net/ethernet/marvell/octeon_ep/octep_main.c    |   184 +-
 .../net/ethernet/marvell/octeon_ep/octep_main.h    |    18 +-
 .../marvell/octeon_ep/octep_regs_cn9k_pf.h         |     6 +
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |     4 +-
 drivers/net/ethernet/marvell/pxa168_eth.c          |     2 +-
 drivers/net/ethernet/mediatek/Kconfig              |     2 +
 drivers/net/ethernet/mediatek/Makefile             |     2 +-
 drivers/net/ethernet/mediatek/mtk_eth_path.c       |    14 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   192 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |   121 +-
 drivers/net/ethernet/mediatek/mtk_ppe.c            |   135 +-
 drivers/net/ethernet/mediatek/mtk_ppe.h            |    26 +-
 drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c    |    11 +-
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |    48 +-
 drivers/net/ethernet/mediatek/mtk_ppe_regs.h       |    14 +
 drivers/net/ethernet/mediatek/mtk_sgmii.c          |   207 -
 drivers/net/ethernet/mediatek/mtk_wed.c            |   101 +
 drivers/net/ethernet/mediatek/mtk_wed_debugfs.c    |     2 -
 drivers/net/ethernet/mediatek/mtk_wed_mcu.c        |     7 +-
 drivers/net/ethernet/mediatek/mtk_wed_wo.h         |     1 +
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |     8 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |     2 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |    11 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |     6 +-
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |    14 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |    73 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.h  |    13 +
 .../mellanox/mlx5/core/diag/reporter_vnic.c        |   125 +
 .../mellanox/mlx5/core/diag/reporter_vnic.h        |    16 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   114 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |    87 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |     3 +
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  |   157 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.h  |    14 -
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |    22 +-
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |    16 +
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |    64 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |    46 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |    38 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/accept.c |    10 -
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.c    |    20 -
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.h    |     8 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/act/ct.c |    66 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/drop.c   |    10 -
 .../ethernet/mellanox/mlx5/core/en/tc/act/mirred.c |     6 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/pedit.c  |    10 -
 .../ethernet/mellanox/mlx5/core/en/tc/act/ptype.c  |    10 -
 .../ethernet/mellanox/mlx5/core/en/tc/act/sample.c |    20 -
 .../ethernet/mellanox/mlx5/core/en/tc/act/trap.c   |    10 -
 .../ethernet/mellanox/mlx5/core/en/tc/act/tun.c    |    10 -
 .../ethernet/mellanox/mlx5/core/en/tc/act/vlan.c   |    10 -
 .../mellanox/mlx5/core/en/tc/act/vlan_mangle.c     |    10 -
 .../ethernet/mellanox/mlx5/core/en/tc/post_act.c   |    11 +-
 .../ethernet/mellanox/mlx5/core/en/tc/post_act.h   |     2 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |     4 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   170 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |    31 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |    11 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.h    |     3 +
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |    37 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_geneve.c |    24 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c  |    72 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |    21 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   311 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |    55 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    |    54 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |    10 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |    12 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |   593 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |    71 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |   790 +-
 .../mellanox/mlx5/core/en_accel/ipsec_offload.c    |   236 +-
 .../ethernet/mellanox/mlx5/core/en_accel/macsec.c  |    42 +-
 .../mellanox/mlx5/core/en_accel/macsec_fs.c        |    12 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |    12 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |     5 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   270 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |    54 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |     1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   660 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |    20 -
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |    10 -
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   357 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |     4 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   225 +-
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |   287 +-
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.h   |    17 +
 .../ethernet/mellanox/mlx5/core/esw/bridge_mcast.c |  1126 ++
 .../ethernet/mellanox/mlx5/core/esw/bridge_priv.h  |   181 +
 .../net/ethernet/mellanox/mlx5/core/esw/debugfs.c  |   198 -
 .../mlx5/core/esw/diag/bridge_tracepoint.h         |    35 +
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c  |     2 +-
 .../net/ethernet/mellanox/mlx5/core/esw/vporttbl.c |    12 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |    20 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |    22 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |    83 +-
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |    32 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |     7 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |     4 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |     8 +
 .../net/ethernet/mellanox/mlx5/core/irq_affinity.c |    42 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |     2 +-
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |    89 +-
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.h    |     9 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |    47 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |     3 +-
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h |    10 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |   249 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h  |     4 +-
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |   151 +
 .../ethernet/mellanox/mlx5/core/sf/dev/driver.c    |     2 +-
 .../mellanox/mlx5/core/steering/dr_action.c        |    92 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_arg.c  |   273 +
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |    60 +
 .../ethernet/mellanox/mlx5/core/steering/dr_dbg.c  |    46 +-
 .../mellanox/mlx5/core/steering/dr_domain.c        |    58 +-
 .../mellanox/mlx5/core/steering/dr_icm_pool.c      |    82 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ptrn.c |   241 +
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |   270 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |    57 +
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.h  |     2 +
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        |   120 +-
 .../mellanox/mlx5/core/steering/dr_ste_v1.h        |     2 +
 .../mellanox/mlx5/core/steering/dr_ste_v2.c        |     2 +
 .../mellanox/mlx5/core/steering/dr_types.h         |    76 +-
 .../mlx5/core/steering/mlx5_ifc_dr_ste_v1.h        |     2 +-
 drivers/net/ethernet/mellanox/mlx5/core/thermal.c  |   108 +
 drivers/net/ethernet/mellanox/mlx5/core/thermal.h  |    20 +
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c |   165 +-
 drivers/net/ethernet/micrel/ksz884x.c              |   304 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |     1 -
 drivers/net/ethernet/microchip/lan966x/Kconfig     |     1 -
 .../net/ethernet/microchip/lan966x/lan966x_fdma.c  |    37 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.c  |    76 +-
 .../net/ethernet/microchip/lan966x/lan966x_main.h  |    49 +-
 .../ethernet/microchip/lan966x/lan966x_police.c    |    13 +-
 .../net/ethernet/microchip/lan966x/lan966x_ptp.c   |    20 +-
 .../net/ethernet/microchip/lan966x/lan966x_regs.h  |    36 +
 .../ethernet/microchip/lan966x/lan966x_tc_flower.c |   221 +-
 .../microchip/lan966x/lan966x_vcap_ag_api.c        |  1402 +-
 .../microchip/lan966x/lan966x_vcap_debugfs.c       |   133 +-
 .../ethernet/microchip/lan966x/lan966x_vcap_impl.c |   192 +-
 .../net/ethernet/microchip/lan966x/lan966x_xdp.c   |    10 +-
 .../net/ethernet/microchip/sparx5/sparx5_main.c    |     1 +
 .../net/ethernet/microchip/sparx5/sparx5_main.h    |     1 +
 .../ethernet/microchip/sparx5/sparx5_tc_flower.c   |   209 +-
 .../microchip/sparx5/sparx5_vcap_debugfs.c         |     2 +-
 .../ethernet/microchip/sparx5/sparx5_vcap_impl.c   |   270 +
 .../ethernet/microchip/sparx5/sparx5_vcap_impl.h   |     6 +
 drivers/net/ethernet/microchip/vcap/vcap_ag_api.h  |   217 +-
 drivers/net/ethernet/microchip/vcap/vcap_api.c     |    61 +
 .../net/ethernet/microchip/vcap/vcap_api_client.h  |    11 +
 .../microchip/vcap/vcap_api_debugfs_kunit.c        |     4 +-
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |     2 -
 drivers/net/ethernet/microsoft/mana/mana_bpf.c     |    22 +-
 drivers/net/ethernet/microsoft/mana/mana_en.c      |   457 +-
 drivers/net/ethernet/microsoft/mana/mana_ethtool.c |    52 +-
 drivers/net/ethernet/mscc/ocelot.c                 |   157 +-
 drivers/net/ethernet/mscc/ocelot.h                 |    15 +-
 drivers/net/ethernet/mscc/ocelot_io.c              |    50 +-
 drivers/net/ethernet/mscc/ocelot_mm.c              |   107 +-
 drivers/net/ethernet/mscc/ocelot_net.c             |    50 +-
 drivers/net/ethernet/mscc/ocelot_stats.c           |    42 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c         |    30 -
 drivers/net/ethernet/netronome/nfp/crypto/ipsec.c  |     4 +-
 .../net/ethernet/netronome/nfp/flower/conntrack.c  |   260 +-
 .../net/ethernet/netronome/nfp/flower/conntrack.h  |    32 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |     2 +-
 drivers/net/ethernet/netronome/nfp/nfp_hwmon.c     |     2 +-
 drivers/net/ethernet/netronome/nfp/nfp_port.c      |     1 +
 drivers/net/ethernet/ni/nixge.c                    |     2 +-
 drivers/net/ethernet/pasemi/pasemi_mac.c           |     2 +-
 .../net/ethernet/pensando/ionic/ionic_bus_pci.c    |     1 -
 drivers/net/ethernet/pensando/ionic/ionic_phc.c    |     5 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic.h    |     2 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |    12 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c          |     3 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c         |     9 -
 drivers/net/ethernet/qlogic/qede/qede.h            |     2 -
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c    |     1 -
 drivers/net/ethernet/qlogic/qede/qede_main.c       |     1 -
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |     1 -
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c     |     4 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |     4 -
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sysfs.c  |     1 -
 drivers/net/ethernet/qualcomm/Kconfig              |     1 +
 drivers/net/ethernet/realtek/r8169_main.c          |   238 +-
 drivers/net/ethernet/renesas/ravb_main.c           |    15 -
 drivers/net/ethernet/renesas/rswitch.c             |     4 +-
 .../net/ethernet/samsung/sxgbe/sxgbe_platform.c    |     2 +-
 drivers/net/ethernet/sfc/ef100.c                   |     3 -
 drivers/net/ethernet/sfc/efx.c                     |     5 -
 drivers/net/ethernet/sfc/falcon/efx.c              |     9 -
 drivers/net/ethernet/sfc/mae.c                     |   239 +-
 drivers/net/ethernet/sfc/mae.h                     |    11 +
 drivers/net/ethernet/sfc/mcdi.h                    |     5 +
 drivers/net/ethernet/sfc/ptp.c                     |   274 +-
 drivers/net/ethernet/sfc/siena/efx.c               |     5 -
 drivers/net/ethernet/sfc/tc.c                      |   642 +-
 drivers/net/ethernet/sfc/tc.h                      |    41 +
 drivers/net/ethernet/sfc/tx_tso.c                  |     2 +-
 drivers/net/ethernet/smsc/smc91x.c                 |     2 +-
 drivers/net/ethernet/smsc/smsc911x.c               |     4 +-
 drivers/net/ethernet/stmicro/stmmac/Kconfig        |    12 +
 drivers/net/ethernet/stmicro/stmmac/Makefile       |     1 +
 drivers/net/ethernet/stmicro/stmmac/chain_mode.c   |    10 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |     2 +-
 .../net/ethernet/stmicro/stmmac/dwmac-anarion.c    |    14 +-
 .../net/ethernet/stmicro/stmmac/dwmac-generic.c    |     2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c    |    27 +
 .../net/ethernet/stmicro/stmmac/dwmac-meson8b.c    |     8 +-
 .../ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c    |   180 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |   197 +-
 .../net/ethernet/stmicro/stmmac/dwmac-starfive.c   |   171 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-sti.c    |    60 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |    36 +-
 .../net/ethernet/stmicro/stmmac/dwmac1000_core.c   |     3 +-
 .../net/ethernet/stmicro/stmmac/dwmac1000_dma.c    |    19 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac100_dma.c |    14 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h       |   101 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |    50 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c |     8 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c   |   201 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.h   |    92 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_lib.c   |   105 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac_dma.h    |    22 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac_lib.c    |    18 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |     9 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_descs.c   |     6 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c |    71 +-
 drivers/net/ethernet/stmicro/stmmac/enh_desc.c     |    11 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.c         |    13 +
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |   179 +-
 drivers/net/ethernet/stmicro/stmmac/norm_desc.c    |     8 +-
 drivers/net/ethernet/stmicro/stmmac/ring_mode.c    |    10 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |     7 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |     9 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   105 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c  |     3 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |     3 +-
 drivers/net/ethernet/sun/sunhme.c                  |  1190 +-
 drivers/net/ethernet/sun/sunhme.h                  |     6 +-
 drivers/net/ethernet/sunplus/spl2sw_phy.c          |     4 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   105 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h           |     2 +
 drivers/net/ethernet/ti/am65-cpsw-qos.c            |   113 +
 drivers/net/ethernet/ti/am65-cpsw-qos.h            |     4 +
 drivers/net/ethernet/ti/am65-cpts.c                |    34 +-
 drivers/net/ethernet/ti/netcp_core.c               |     4 +-
 drivers/net/ethernet/wangxun/libwx/wx_hw.c         |    21 +-
 drivers/net/ethernet/wangxun/libwx/wx_hw.h         |     1 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c        |     5 +-
 drivers/net/ethernet/wangxun/libwx/wx_type.h       |     7 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c      |     9 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h      |     1 -
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c    |    10 +-
 drivers/net/ethernet/wangxun/txgbe/txgbe_type.h    |     1 -
 drivers/net/fddi/skfp/rmt.c                        |     6 +-
 drivers/net/geneve.c                               |    11 +-
 drivers/net/ieee802154/adf7242.c                   |     3 +-
 drivers/net/ieee802154/at86rf230.c                 |     2 +-
 drivers/net/ieee802154/ca8210.c                    |     3 +-
 drivers/net/ieee802154/mcr20a.c                    |     2 +-
 drivers/net/ipa/Makefile                           |    12 +-
 drivers/net/ipa/data/ipa_data-v5.0.c               |   481 +
 drivers/net/ipa/gsi.h                              |     4 +-
 drivers/net/ipa/gsi_reg.c                          |     3 +
 drivers/net/ipa/gsi_reg.h                          |     1 +
 drivers/net/ipa/ipa_data.h                         |     3 +-
 drivers/net/ipa/ipa_main.c                         |     6 +-
 drivers/net/ipa/ipa_reg.c                          |     2 +
 drivers/net/ipa/ipa_reg.h                          |     1 +
 drivers/net/ipa/ipa_sysfs.c                        |     2 +
 drivers/net/ipa/reg/gsi_reg-v5.0.c                 |   317 +
 drivers/net/ipa/reg/ipa_reg-v5.0.c                 |   564 +
 drivers/net/macsec.c                               |    14 +-
 drivers/net/macvlan.c                              |    98 +-
 drivers/net/mdio/Kconfig                           |     3 +
 drivers/net/mdio/of_mdio.c                         |     4 +-
 drivers/net/pcs/Kconfig                            |     7 +
 drivers/net/pcs/Makefile                           |     1 +
 drivers/net/pcs/pcs-lynx.c                         |     4 +-
 drivers/net/pcs/pcs-mtk-lynxi.c                    |   305 +
 drivers/net/pcs/pcs-xpcs.c                         |    23 +-
 drivers/net/phy/Kconfig                            |    18 +
 drivers/net/phy/Makefile                           |     2 +
 drivers/net/phy/aquantia_hwmon.c                   |     2 +-
 drivers/net/phy/at803x.c                           |     3 +-
 drivers/net/phy/bcm54140.c                         |     2 +-
 drivers/net/phy/bcm7xxx.c                          |    22 +-
 drivers/net/phy/dp83867.c                          |    62 +-
 drivers/net/phy/marvell-88x2222.c                  |     4 +-
 drivers/net/phy/marvell.c                          |    83 +-
 drivers/net/phy/marvell10g.c                       |     2 +-
 drivers/net/phy/meson-gxl.c                        |    81 +-
 drivers/net/phy/micrel.c                           |   563 +-
 drivers/net/phy/microchip_t1s.c                    |   138 +
 drivers/net/phy/mxl-gpy.c                          |    37 +-
 drivers/net/phy/nxp-cbtx.c                         |   227 +
 drivers/net/phy/nxp-tja11xx.c                      |     2 +-
 drivers/net/phy/phy.c                              |    33 +-
 drivers/net/phy/phy_device.c                       |   112 +-
 drivers/net/phy/phylink.c                          |    37 +-
 drivers/net/phy/sfp-bus.c                          |     8 +-
 drivers/net/phy/sfp.c                              |    68 +-
 drivers/net/phy/smsc.c                             |   170 +-
 drivers/net/phy/spi_ks8995.c                       |     2 +-
 drivers/net/tap.c                                  |    15 +-
 drivers/net/thunderbolt/main.c                     |    25 +-
 drivers/net/tun.c                                  |     2 +
 drivers/net/veth.c                                 |    68 +-
 drivers/net/virtio_net.c                           |     6 +-
 drivers/net/vxlan/Makefile                         |     2 +-
 drivers/net/vxlan/vxlan_core.c                     |   109 +-
 drivers/net/vxlan/vxlan_mdb.c                      |  1462 ++
 drivers/net/vxlan/vxlan_private.h                  |    84 +
 drivers/net/wireless/Kconfig                       |    75 +-
 drivers/net/wireless/Makefile                      |    11 +-
 drivers/net/wireless/ath/ath.h                     |    12 +-
 drivers/net/wireless/ath/ath10k/ce.c               |    59 -
 drivers/net/wireless/ath/ath10k/mac.c              |     1 -
 drivers/net/wireless/ath/ath10k/pci.c              |     6 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |     1 +
 drivers/net/wireless/ath/ath11k/ahb.c              |    16 +-
 drivers/net/wireless/ath/ath11k/core.c             |    10 +-
 drivers/net/wireless/ath/ath11k/dbring.c           |    12 +-
 .../net/wireless/ath/ath11k/debugfs_htt_stats.h    |    73 +-
 drivers/net/wireless/ath/ath11k/dp.c               |     4 +-
 drivers/net/wireless/ath/ath11k/dp.h               |     6 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   140 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |    33 +-
 drivers/net/wireless/ath/ath11k/dp_tx.h            |     1 +
 drivers/net/wireless/ath/ath11k/hal_rx.c           |    14 +-
 drivers/net/wireless/ath/ath11k/hal_rx.h           |    20 +-
 drivers/net/wireless/ath/ath11k/hw.c               |    29 +-
 drivers/net/wireless/ath/ath11k/hw.h               |     3 +-
 drivers/net/wireless/ath/ath11k/mac.c              |   297 +-
 drivers/net/wireless/ath/ath11k/pci.c              |    14 +-
 drivers/net/wireless/ath/ath11k/peer.c             |     5 +-
 drivers/net/wireless/ath/ath11k/peer.h             |     1 +
 drivers/net/wireless/ath/ath11k/reg.c              |    59 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |   654 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |   371 +-
 drivers/net/wireless/ath/ath12k/ce.c               |     2 +-
 drivers/net/wireless/ath/ath12k/core.h             |     3 +-
 drivers/net/wireless/ath/ath12k/dp.c               |     7 +-
 drivers/net/wireless/ath/ath12k/dp.h               |     6 +-
 drivers/net/wireless/ath/ath12k/dp_mon.c           |    19 +-
 drivers/net/wireless/ath/ath12k/dp_rx.c            |    26 +-
 drivers/net/wireless/ath/ath12k/dp_tx.c            |     6 +-
 drivers/net/wireless/ath/ath12k/hal.c              |     2 +-
 drivers/net/wireless/ath/ath12k/hal.h              |    12 +-
 drivers/net/wireless/ath/ath12k/hal_desc.h         |    10 +-
 drivers/net/wireless/ath/ath12k/hw.c               |     2 +-
 drivers/net/wireless/ath/ath12k/mac.c              |   117 +-
 drivers/net/wireless/ath/ath12k/pci.c              |    55 +-
 drivers/net/wireless/ath/ath12k/pci.h              |     6 +
 drivers/net/wireless/ath/ath12k/qmi.c              |     4 +-
 drivers/net/wireless/ath/ath12k/rx_desc.h          |     2 +-
 drivers/net/wireless/ath/ath12k/wmi.c              |    12 +-
 drivers/net/wireless/ath/ath12k/wmi.h              |     4 +-
 drivers/net/wireless/ath/ath5k/ahb.c               |    10 +-
 drivers/net/wireless/ath/ath5k/eeprom.c            |     2 +-
 drivers/net/wireless/ath/ath6kl/bmi.c              |     2 +-
 drivers/net/wireless/ath/ath6kl/htc_pipe.c         |     4 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |    21 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |    30 +-
 drivers/net/wireless/ath/carl9170/cmd.c            |     2 +-
 drivers/net/wireless/ath/carl9170/fwcmd.h          |     4 +-
 drivers/net/wireless/ath/key.c                     |     2 +-
 drivers/net/wireless/ath/wcn36xx/dxe.c             |    23 +-
 drivers/net/wireless/ath/wcn36xx/dxe.h             |     4 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |     1 +
 drivers/net/wireless/ath/wcn36xx/smd.c             |     4 +-
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h         |     1 +
 drivers/net/wireless/broadcom/b43legacy/dma.c      |     8 -
 drivers/net/wireless/broadcom/b43legacy/radio.c    |    17 -
 .../wireless/broadcom/brcm80211/brcmfmac/Makefile  |     2 +
 .../wireless/broadcom/brcm80211/brcmfmac/acpi.c    |    51 +
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |     9 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |     1 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   330 +-
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |    25 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |   118 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.h  |    11 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |    49 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |     6 +-
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |   157 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |     9 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |    61 +-
 .../wireless/broadcom/brcm80211/brcmsmac/ampdu.c   |     3 +-
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |     2 -
 .../broadcom/brcm80211/include/brcm_hw_ids.h       |     2 +
 drivers/net/wireless/cisco/Kconfig                 |     2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |    20 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.h       |     3 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   174 +-
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c       |     5 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |    41 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |    18 +
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h     |    37 +-
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   |   184 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h  |    96 +
 .../net/wireless/intel/iwlwifi/fw/api/mac-cfg.h    |   418 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     |    27 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |    86 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |     3 +
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |    10 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |    42 +-
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c    |     4 +-
 drivers/net/wireless/intel/iwlwifi/fw/dump.c       |    69 +-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |    17 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |     7 +
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |     5 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |    20 +-
 drivers/net/wireless/intel/iwlwifi/fw/rs.c         |     4 +-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |     5 +
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c       |     2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |    15 +
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |     5 +
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |    34 +-
 drivers/net/wireless/intel/iwlwifi/iwl-debug.c     |     3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c  |     3 +
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |    18 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.h  |     5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |    27 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |     7 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |    25 +-
 drivers/net/wireless/intel/iwlwifi/mei/iwl-mei.h   |     4 +-
 drivers/net/wireless/intel/iwlwifi/mei/main.c      |    40 +-
 drivers/net/wireless/intel/iwlwifi/mvm/Makefile    |     4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/binding.c   |    13 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c      |   104 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |    75 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |    14 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |   258 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |    31 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-responder.c |    21 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   278 +-
 drivers/net/wireless/intel/iwlwifi/mvm/link.c      |   294 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   494 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  2154 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mld-key.c   |   129 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mld-mac.c   |   309 +
 .../net/wireless/intel/iwlwifi/mvm/mld-mac80211.c  |  1101 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c   |  1167 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   557 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |    58 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |     4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |    45 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ptp.c       |   326 +
 drivers/net/wireless/intel/iwlwifi/mvm/quota.c     |    11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |   207 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |    90 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.h        |    31 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |    43 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   700 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   140 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sf.c        |    57 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   713 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |   136 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c      |     8 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |    12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/time-sync.c |   173 +
 drivers/net/wireless/intel/iwlwifi/mvm/time-sync.h |    30 +
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        |     4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   162 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |    91 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   436 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |     1 +
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |    18 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |    78 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |    15 +-
 drivers/net/wireless/intel/iwlwifi/queue/tx.c      |    10 +-
 drivers/net/wireless/legacy/Kconfig                |    55 +
 drivers/net/wireless/legacy/Makefile               |     6 +
 drivers/net/wireless/{ => legacy}/ray_cs.c         |     0
 drivers/net/wireless/{ => legacy}/ray_cs.h         |     0
 drivers/net/wireless/{ => legacy}/rayctl.h         |     0
 drivers/net/wireless/{ => legacy}/rndis_wlan.c     |     8 +-
 drivers/net/wireless/{ => legacy}/wl3501.h         |     0
 drivers/net/wireless/{ => legacy}/wl3501_cs.c      |     0
 drivers/net/wireless/marvell/mwifiex/11h.c         |     4 -
 drivers/net/wireless/mediatek/mt76/dma.c           |    10 +-
 drivers/net/wireless/mediatek/mt76/dma.h           |     1 +
 drivers/net/wireless/mediatek/mt76/mac80211.c      |    17 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |    19 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |     5 +-
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |     5 +-
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |     7 +-
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.h |     2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |     1 +
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |    18 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h    |    12 -
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |    11 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h    |    11 -
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |    11 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |    11 +-
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c    |     2 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_init.c   |     2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/sdio.c   |     1 -
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c    |     1 -
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |    21 +
 .../net/wireless/mediatek/mt76/mt76_connac2_mac.h  |    22 +
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |    78 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |    21 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |    19 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |     5 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |    36 +-
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    |    10 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |    35 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |     6 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.h    |    33 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |     1 -
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   115 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |    17 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |    18 +-
 drivers/net/wireless/mediatek/mt76/mt7915/soc.c    |     2 +
 .../net/wireless/mediatek/mt76/mt7921/acpi_sar.h   |    10 +-
 .../net/wireless/mediatek/mt76/mt7921/debugfs.c    |     1 -
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c    |    50 +-
 drivers/net/wireless/mediatek/mt76/mt7921/eeprom.h |    30 -
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |    43 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |    18 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.h    |    53 -
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |    42 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |    31 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h    |    11 -
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |    23 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |    64 +-
 .../net/wireless/mediatek/mt76/mt7921/pci_mac.c    |     2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/sdio.c   |    23 +-
 .../net/wireless/mediatek/mt76/mt7921/sdio_mac.c   |     2 +-
 .../net/wireless/mediatek/mt76/mt7921/sdio_mcu.c   |     2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c    |    27 +-
 .../net/wireless/mediatek/mt76/mt7921/usb_mac.c    |     2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/Kconfig  |     1 +
 drivers/net/wireless/mediatek/mt76/mt7996/Makefile |     2 +
 .../net/wireless/mediatek/mt76/mt7996/coredump.c   |   268 +
 .../net/wireless/mediatek/mt76/mt7996/coredump.h   |    97 +
 .../net/wireless/mediatek/mt76/mt7996/debugfs.c    |   149 +-
 drivers/net/wireless/mediatek/mt76/mt7996/dma.c    |    64 +
 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c |     4 -
 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.h |     9 +-
 drivers/net/wireless/mediatek/mt76/mt7996/init.c   |    72 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c    |   501 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mac.h    |    62 +-
 drivers/net/wireless/mediatek/mt76/mt7996/main.c   |    78 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c    |   222 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.h    |    30 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mmio.c   |    23 +-
 drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h |    76 +-
 drivers/net/wireless/mediatek/mt76/mt7996/regs.h   |    51 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |     6 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |     7 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c     |     1 +
 drivers/net/wireless/realtek/rtl8xxxu/Kconfig      |     2 +-
 drivers/net/wireless/realtek/rtl8xxxu/Makefile     |     2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   332 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188e.c |    22 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8188f.c |    15 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c |     7 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |    60 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8710b.c |  1887 +++
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c |     9 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c |    11 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   396 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h  |    44 +
 drivers/net/wireless/realtek/rtlwifi/debug.c       |    12 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.c    |    25 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.c    |     6 -
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.c    |     9 -
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |     2 +-
 drivers/net/wireless/realtek/rtw88/Kconfig         |    36 +
 drivers/net/wireless/realtek/rtw88/Makefile        |    12 +
 drivers/net/wireless/realtek/rtw88/debug.h         |     1 +
 drivers/net/wireless/realtek/rtw88/fw.c            |    20 +-
 drivers/net/wireless/realtek/rtw88/fw.h            |     2 +-
 drivers/net/wireless/realtek/rtw88/mac.c           |    68 +-
 drivers/net/wireless/realtek/rtw88/mac.h           |     1 -
 drivers/net/wireless/realtek/rtw88/mac80211.c      |    40 +-
 drivers/net/wireless/realtek/rtw88/main.c          |   157 +-
 drivers/net/wireless/realtek/rtw88/main.h          |    23 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |     8 -
 drivers/net/wireless/realtek/rtw88/reg.h           |    12 +
 drivers/net/wireless/realtek/rtw88/rtw8723d.c      |     1 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |    35 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.h      |     6 +
 drivers/net/wireless/realtek/rtw88/rtw8821cs.c     |    36 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |    10 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.h      |     8 +-
 drivers/net/wireless/realtek/rtw88/rtw8822bs.c     |    36 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |    10 +
 drivers/net/wireless/realtek/rtw88/rtw8822c.h      |     8 +-
 drivers/net/wireless/realtek/rtw88/rtw8822cs.c     |    36 +
 drivers/net/wireless/realtek/rtw88/sdio.c          |  1394 ++
 drivers/net/wireless/realtek/rtw88/sdio.h          |   178 +
 drivers/net/wireless/realtek/rtw88/usb.c           |    73 +-
 drivers/net/wireless/realtek/rtw89/chan.c          |    35 +
 drivers/net/wireless/realtek/rtw89/chan.h          |     3 +
 drivers/net/wireless/realtek/rtw89/coex.c          |  1268 +-
 drivers/net/wireless/realtek/rtw89/coex.h          |     6 +
 drivers/net/wireless/realtek/rtw89/core.c          |   452 +-
 drivers/net/wireless/realtek/rtw89/core.h          |   429 +-
 drivers/net/wireless/realtek/rtw89/debug.c         |    13 +-
 drivers/net/wireless/realtek/rtw89/fw.c            |   752 +-
 drivers/net/wireless/realtek/rtw89/fw.h            |   456 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |   183 +-
 drivers/net/wireless/realtek/rtw89/mac.h           |     5 +-
 drivers/net/wireless/realtek/rtw89/mac80211.c      |    94 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |    58 +-
 drivers/net/wireless/realtek/rtw89/pci.h           |     4 +-
 drivers/net/wireless/realtek/rtw89/phy.c           |   183 +-
 drivers/net/wireless/realtek/rtw89/phy.h           |     4 +
 drivers/net/wireless/realtek/rtw89/ps.c            |    12 +-
 drivers/net/wireless/realtek/rtw89/ps.h            |    19 +-
 drivers/net/wireless/realtek/rtw89/reg.h           |    15 +
 .../wireless/realtek/rtw89/rtw8851b_rfk_table.c    |   534 +
 .../wireless/realtek/rtw89/rtw8851b_rfk_table.h    |    38 +
 .../net/wireless/realtek/rtw89/rtw8851b_table.c    | 14824 +++++++++++++++++++
 .../net/wireless/realtek/rtw89/rtw8851b_table.h    |    21 +
 drivers/net/wireless/realtek/rtw89/rtw8852a.c      |    36 +-
 .../net/wireless/realtek/rtw89/rtw8852a_table.c    |    15 +
 .../net/wireless/realtek/rtw89/rtw8852a_table.h    |    11 +-
 drivers/net/wireless/realtek/rtw89/rtw8852b.c      |   121 +-
 .../net/wireless/realtek/rtw89/rtw8852b_table.c    |    15 +
 .../net/wireless/realtek/rtw89/rtw8852b_table.h    |    11 +-
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |   128 +-
 .../net/wireless/realtek/rtw89/rtw8852c_table.c    |    21 +
 .../net/wireless/realtek/rtw89/rtw8852c_table.h    |    16 +-
 drivers/net/wireless/realtek/rtw89/ser.c           |     5 +
 drivers/net/wireless/realtek/rtw89/wow.c           |    11 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |     7 +-
 drivers/net/wireless/silabs/wfx/main.c             |    10 +-
 drivers/net/wireless/virtual/Kconfig               |    20 +
 drivers/net/wireless/virtual/Makefile              |     3 +
 .../net/wireless/{ => virtual}/mac80211_hwsim.c    |   928 +-
 .../net/wireless/{ => virtual}/mac80211_hwsim.h    |    58 +
 drivers/net/wireless/{ => virtual}/virt_wifi.c     |     0
 drivers/net/wwan/iosm/iosm_ipc_port.c              |     3 +-
 drivers/net/wwan/mhi_wwan_ctrl.c                   |     2 +-
 drivers/net/wwan/rpmsg_wwan_ctrl.c                 |     3 +-
 drivers/net/wwan/t7xx/t7xx_port_wwan.c             |    36 +-
 drivers/net/wwan/wwan_core.c                       |    61 +-
 drivers/net/wwan/wwan_hwsim.c                      |     2 +-
 drivers/nfc/nfcmrvl/i2c.c                          |     2 +-
 drivers/nfc/nfcmrvl/main.c                         |     6 +-
 drivers/nfc/nfcmrvl/nfcmrvl.h                      |    30 +-
 drivers/nfc/nfcmrvl/uart.c                         |    11 +-
 drivers/nfc/nfcsim.c                               |     5 -
 drivers/nfc/trf7970a.c                             |     2 +-
 drivers/phy/mscc/phy-ocelot-serdes.c               |     9 +
 drivers/ptp/Kconfig                                |    14 +
 drivers/ptp/Makefile                               |     1 +
 drivers/ptp/ptp_dfl_tod.c                          |   332 +
 drivers/ptp/ptp_ines.c                             |     2 +-
 drivers/ptp/ptp_kvm_arm.c                          |     4 +
 drivers/ptp/ptp_kvm_common.c                       |     1 +
 drivers/ptp/ptp_kvm_x86.c                          |    59 +-
 drivers/ptp/ptp_ocp.c                              |     1 +
 drivers/s390/net/ism_drv.c                         |    10 +-
 drivers/scsi/cxgbi/libcxgbi.c                      |     4 +-
 drivers/staging/gdm724x/gdm_lte.c                  |     4 +-
 drivers/tty/serdev/core.c                          |    17 +-
 drivers/tty/serdev/serdev-ttyport.c                |    16 +-
 drivers/usb/class/cdc-wdm.c                        |     3 +-
 drivers/vhost/vsock.c                              |     1 +
 fs/afs/rxrpc.c                                     |     9 +-
 fs/dlm/lowcomms.c                                  |     7 +-
 include/linux/atomic/atomic-arch-fallback.h        |   208 +-
 include/linux/atomic/atomic-instrumented.h         |    68 +-
 include/linux/atomic/atomic-long.h                 |    38 +-
 include/linux/bpf.h                                |   250 +-
 include/linux/bpf_local_storage.h                  |    20 +-
 include/linux/bpf_mem_alloc.h                      |     9 +
 include/linux/bpf_types.h                          |     4 +
 include/linux/bpf_verifier.h                       |    83 +-
 include/linux/btf.h                                |    13 +-
 include/linux/btf_ids.h                            |     2 +-
 include/linux/cpu_rmap.h                           |     4 +-
 include/linux/dccp.h                               |     6 +-
 include/linux/ethtool.h                            |    15 +-
 include/linux/ethtool_netlink.h                    |     6 +
 include/linux/filter.h                             |    56 +-
 include/linux/hwmon.h                              |     2 +-
 include/linux/ieee80211.h                          |    63 +-
 include/linux/if_bridge.h                          |     1 +
 include/linux/if_vlan.h                            |    36 +-
 include/linux/igmp.h                               |     2 +-
 include/linux/ipv6.h                               |     5 +-
 include/linux/leds.h                               |    18 +
 include/linux/mlx5/device.h                        |     8 +
 include/linux/mlx5/driver.h                        |    11 +
 include/linux/mlx5/mlx5_ifc.h                      |    84 +-
 include/linux/mlx5/port.h                          |    16 +
 include/linux/mlx5/qp.h                            |    10 +
 include/linux/mmc/sdio_ids.h                       |    14 +-
 include/linux/module.h                             |   127 +-
 include/linux/net_tstamp.h                         |    33 +
 include/linux/netdevice.h                          |    71 +-
 include/linux/netfilter.h                          |     1 +
 include/linux/netfilter/nfnetlink.h                |     1 -
 include/linux/netfilter_ipv6.h                     |     2 +
 include/linux/netlink.h                            |    23 +-
 include/linux/pcs/pcs-mtk-lynxi.h                  |    13 +
 include/linux/pds/pds_adminq.h                     |   647 +
 include/linux/pds/pds_auxbus.h                     |    20 +
 include/linux/pds/pds_common.h                     |    68 +
 include/linux/pds/pds_core_if.h                    |   571 +
 include/linux/pds/pds_intr.h                       |   163 +
 include/linux/phy.h                                |    46 +-
 include/linux/phylink.h                            |     2 -
 include/linux/platform_data/nfcmrvl.h              |    48 -
 include/linux/ptp_kvm.h                            |     1 +
 include/linux/rcuref.h                             |   155 +
 include/linux/rtnetlink.h                          |    10 -
 include/linux/sched.h                              |     7 +-
 include/linux/sctp.h                               |    18 +-
 include/linux/serdev.h                             |    10 +-
 include/linux/skbuff.h                             |   127 +-
 include/linux/smscphy.h                            |    10 +
 include/linux/soc/mediatek/mtk_wed.h               |     6 +
 include/linux/stmmac.h                             |    20 +
 include/linux/tcp.h                                |    10 +-
 include/linux/types.h                              |     6 +
 include/linux/udp.h                                |     5 +-
 include/linux/virtio_vsock.h                       |     1 +
 include/linux/wwan.h                               |    11 +
 include/net/addrconf.h                             |     2 +-
 include/net/af_rxrpc.h                             |     3 +-
 include/net/af_unix.h                              |     6 +-
 include/net/af_vsock.h                             |    17 +
 include/net/arp.h                                  |     8 +-
 include/net/ax25.h                                 |     5 +-
 include/net/bluetooth/bluetooth.h                  |    43 +-
 include/net/bluetooth/coredump.h                   |   116 +
 include/net/bluetooth/hci.h                        |    15 +
 include/net/bluetooth/hci_core.h                   |    55 +-
 include/net/bluetooth/hci_sync.h                   |     4 +
 include/net/bluetooth/l2cap.h                      |     2 +-
 include/net/bluetooth/mgmt.h                       |    80 +-
 include/net/cfg80211.h                             |    75 +-
 include/net/dropreason-core.h                      |   370 +
 include/net/dropreason.h                           |   374 +-
 include/net/dsa.h                                  |    51 -
 include/net/dsa_stubs.h                            |    48 +
 include/net/dst.h                                  |    30 +-
 include/net/flow_dissector.h                       |    38 +-
 include/net/fou.h                                  |     2 +
 include/net/handshake.h                            |    43 +
 include/net/ieee80211_radiotap.h                   |   215 +-
 include/net/inet_frag.h                            |     2 +-
 include/net/inet_sock.h                            |     5 +-
 include/net/ip6_fib.h                              |    12 +-
 include/net/ip6_route.h                            |     2 +-
 include/net/ip_tunnels.h                           |    38 +-
 include/net/ip_vs.h                                |    32 +-
 include/net/mac80211.h                             |   195 +-
 include/net/mana/gdma.h                            |     4 +
 include/net/mana/mana.h                            |    45 +-
 include/net/ndisc.h                                |    12 +-
 include/net/neighbour.h                            |    10 +-
 include/net/netdev_queues.h                        |   173 +
 include/net/netfilter/nf_bpf_link.h                |    15 +
 include/net/netfilter/nf_conntrack_core.h          |     6 +-
 include/net/netfilter/nf_nat_redirect.h            |     3 +-
 include/net/netfilter/nf_tables.h                  |    35 +-
 include/net/netns/ipv6.h                           |     1 +
 include/net/nexthop.h                              |     6 +-
 include/net/page_pool.h                            |     8 +-
 include/net/pkt_sched.h                            |     4 +-
 include/net/raw.h                                  |     7 +-
 include/net/rawv6.h                                |     2 +-
 include/net/route.h                                |     3 -
 include/net/scm.h                                  |    13 +-
 include/net/sctp/sctp.h                            |    12 +-
 include/net/sctp/stream_sched.h                    |     2 +
 include/net/sctp/structs.h                         |    11 +-
 include/net/smc.h                                  |     1 +
 include/net/sock.h                                 |     4 +-
 include/net/tcp.h                                  |     5 +-
 include/net/vxlan.h                                |    25 +
 include/net/x25.h                                  |     5 +-
 include/net/xdp.h                                  |    29 -
 include/net/xdp_sock.h                             |     1 +
 include/net/xfrm.h                                 |     5 +
 include/net/xsk_buff_pool.h                        |     9 +-
 include/soc/mscc/ocelot.h                          |    40 +-
 include/trace/events/fib.h                         |     5 +-
 include/trace/events/fib6.h                        |     5 +-
 include/trace/events/handshake.h                   |   159 +
 include/trace/events/qrtr.h                        |    33 +-
 include/trace/events/sock.h                        |     4 +-
 include/trace/events/tcp.h                         |     2 +-
 include/uapi/linux/bpf.h                           |   112 +-
 include/uapi/linux/ethtool_netlink.h               |     2 +
 include/uapi/linux/handshake.h                     |    73 +
 include/uapi/linux/if_bridge.h                     |    11 +
 include/uapi/linux/if_link.h                       |     2 +
 include/uapi/linux/if_packet.h                     |     1 +
 include/uapi/linux/netfilter/nf_tables.h           |    10 +-
 include/uapi/linux/netfilter/nfnetlink_hook.h      |    24 +-
 include/uapi/linux/netfilter/nfnetlink_queue.h     |     1 +
 include/uapi/linux/nl80211.h                       |    59 +-
 include/uapi/linux/pkt_sched.h                     |    17 +
 include/uapi/linux/sctp.h                          |     4 +-
 include/uapi/linux/tc_act/tc_tunnel_key.h          |     1 +
 include/uapi/linux/virtio_net.h                    |     1 +
 io_uring/rsrc.c                                    |     3 +-
 kernel/bpf/Makefile                                |     3 +-
 kernel/bpf/arraymap.c                              |    40 +-
 kernel/bpf/bloom_filter.c                          |    41 +-
 kernel/bpf/bpf_cgrp_storage.c                      |    24 +-
 kernel/bpf/bpf_inode_storage.c                     |    23 +-
 kernel/bpf/bpf_iter.c                              |    70 +
 kernel/bpf/bpf_local_storage.c                     |   371 +-
 kernel/bpf/bpf_struct_ops.c                        |   276 +-
 kernel/bpf/bpf_task_storage.c                      |    28 +-
 kernel/bpf/btf.c                                   |   467 +-
 kernel/bpf/cgroup.c                                |    62 +-
 kernel/bpf/core.c                                  |    11 +
 kernel/bpf/cpumap.c                                |    18 +-
 kernel/bpf/cpumask.c                               |    87 +-
 kernel/bpf/devmap.c                                |    50 +-
 kernel/bpf/hashtab.c                               |   140 +-
 kernel/bpf/helpers.c                               |   509 +-
 kernel/bpf/local_storage.c                         |    13 +-
 kernel/bpf/log.c                                   |   330 +
 kernel/bpf/lpm_trie.c                              |    17 +-
 kernel/bpf/map_in_map.c                            |    15 -
 kernel/bpf/memalloc.c                              |    59 +-
 kernel/bpf/offload.c                               |     6 +
 kernel/bpf/queue_stack_maps.c                      |    32 +-
 kernel/bpf/reuseport_array.c                       |    10 +-
 kernel/bpf/ringbuf.c                               |    26 +-
 kernel/bpf/stackmap.c                              |    20 +-
 kernel/bpf/syscall.c                               |   170 +-
 kernel/bpf/trampoline.c                            |    28 -
 kernel/bpf/verifier.c                              |  2369 ++-
 kernel/cgroup/cgroup.c                             |    14 +-
 kernel/module/internal.h                           |     1 -
 kernel/module/kallsyms.c                           |    16 +-
 kernel/trace/bpf_trace.c                           |     4 -
 lib/Makefile                                       |     2 +-
 lib/cpu_rmap.c                                     |    57 +-
 lib/packing.c                                      |     1 -
 lib/rcuref.c                                       |   281 +
 mm/maccess.c                                       |    16 +-
 mm/usercopy.c                                      |     2 +-
 net/6lowpan/iphc.c                                 |     2 +-
 net/8021q/vlan_dev.c                               |   244 +-
 net/Kconfig                                        |    32 +
 net/Makefile                                       |     3 +-
 net/atm/signaling.c                                |     2 +-
 net/batman-adv/soft-interface.c                    |     2 +-
 net/bluetooth/Makefile                             |     2 +
 net/bluetooth/coredump.c                           |   536 +
 net/bluetooth/hci_conn.c                           |   365 +-
 net/bluetooth/hci_core.c                           |     4 +
 net/bluetooth/hci_debugfs.c                        |     2 +-
 net/bluetooth/hci_event.c                          |   132 +-
 net/bluetooth/hci_sock.c                           |    37 +-
 net/bluetooth/hci_sync.c                           |   137 +-
 net/bluetooth/iso.c                                |   133 +-
 net/bluetooth/l2cap_core.c                         |     8 +-
 net/bluetooth/mgmt.c                               |    16 +-
 net/bluetooth/msft.c                               |    36 +-
 net/bluetooth/smp.c                                |     9 +-
 net/bpf/bpf_dummy_struct_ops.c                     |    14 +-
 net/bpf/test_run.c                                 |   207 +-
 net/bridge/br_arp_nd_proxy.c                       |    37 +-
 net/bridge/br_device.c                             |    11 +-
 net/bridge/br_forward.c                            |     8 +-
 net/bridge/br_if.c                                 |     2 +-
 net/bridge/br_input.c                              |     2 +-
 net/bridge/br_mdb.c                                |   219 +-
 net/bridge/br_netfilter_hooks.c                    |     3 +-
 net/bridge/br_netfilter_ipv6.c                     |    79 +-
 net/bridge/br_netlink.c                            |    11 +-
 net/bridge/br_nf_core.c                            |     2 +-
 net/bridge/br_private.h                            |    27 +-
 net/bridge/br_vlan.c                               |     1 +
 net/bridge/br_vlan_options.c                       |    20 +-
 net/bridge/netfilter/nft_meta_bridge.c             |    71 +-
 net/can/isotp.c                                    |    65 +-
 net/compat.c                                       |    13 +-
 net/core/bpf_sk_storage.c                          |    25 +-
 net/core/datagram.c                                |    14 +-
 net/core/dev.c                                     |   144 +-
 net/core/dev_ioctl.c                               |   105 +-
 net/core/drop_monitor.c                            |    33 +-
 net/core/dst.c                                     |    27 +-
 net/core/filter.c                                  |   244 +-
 net/core/gro.c                                     |     2 +-
 net/core/neighbour.c                               |   123 +-
 net/core/net-procfs.c                              |    18 +-
 net/core/netdev-genl-gen.c                         |     2 +-
 net/core/page_pool.c                               |    36 +-
 net/core/rtnetlink.c                               |   222 +-
 net/core/scm.c                                     |     9 +-
 net/core/skbuff.c                                  |   132 +-
 net/core/sock.c                                    |    13 +-
 net/core/sock_map.c                                |    28 +-
 net/core/xdp.c                                     |    19 +-
 net/dccp/ipv4.c                                    |    12 +-
 net/dccp/ipv6.c                                    |    12 +-
 net/dccp/timer.c                                   |     2 +-
 net/dsa/Makefile                                   |    12 +-
 net/dsa/dsa.c                                      |    19 +
 net/dsa/master.c                                   |    50 +-
 net/dsa/master.h                                   |     3 +
 net/dsa/port.c                                     |    34 +-
 net/dsa/port.h                                     |     2 +-
 net/dsa/stubs.c                                    |    10 +
 net/dsa/switch.c                                   |    85 +-
 net/dsa/tag.h                                      |     2 +-
 net/dsa/tag_8021q.c                                |     4 +-
 net/dsa/tag_ksz.c                                  |    18 +-
 net/dsa/tag_ocelot.c                               |     4 +-
 net/dsa/tag_sja1105.c                              |     4 +-
 net/dsa/trace.c                                    |    39 +
 net/dsa/trace.h                                    |   447 +
 net/ethtool/coalesce.c                             |    54 +-
 net/ethtool/ioctl.c                                |    10 +-
 net/ethtool/mm.c                                   |    33 +
 net/ethtool/netlink.h                              |     2 +-
 net/ethtool/rings.c                                |    34 +-
 net/handshake/.kunitconfig                         |    11 +
 net/handshake/Makefile                             |    13 +
 net/handshake/genl.c                               |    58 +
 net/handshake/genl.h                               |    24 +
 net/handshake/handshake-test.c                     |   523 +
 net/handshake/handshake.h                          |    87 +
 net/handshake/netlink.c                            |   319 +
 net/handshake/request.c                            |   344 +
 net/handshake/tlshd.c                              |   418 +
 net/handshake/trace.c                              |    20 +
 net/ipv4/Makefile                                  |     2 +-
 net/ipv4/af_inet.c                                 |     2 +-
 net/ipv4/arp.c                                     |     8 +-
 net/ipv4/bpf_tcp_ca.c                              |    23 +-
 net/ipv4/devinet.c                                 |     3 +
 net/ipv4/fib_semantics.c                           |     8 +-
 net/ipv4/fou_bpf.c                                 |   119 +
 net/ipv4/fou_core.c                                |     5 +
 net/ipv4/igmp.c                                    |     4 +-
 net/ipv4/inet_hashtables.c                         |    11 +-
 net/ipv4/ip_output.c                               |    29 +-
 net/ipv4/ip_tunnel.c                               |    22 +-
 net/ipv4/ipip.c                                    |     1 +
 net/ipv4/netfilter/ip_tables.c                     |    68 +-
 net/ipv4/nexthop.c                                 |    12 +-
 net/ipv4/raw.c                                     |     4 +-
 net/ipv4/raw_diag.c                                |     2 +-
 net/ipv4/route.c                                   |    24 +-
 net/ipv4/tcp.c                                     |    17 +-
 net/ipv4/tcp_cong.c                                |    66 +-
 net/ipv4/tcp_input.c                               |    14 +-
 net/ipv4/tcp_ipv4.c                                |    10 +-
 net/ipv4/tcp_minisocks.c                           |     5 +-
 net/ipv4/tcp_output.c                              |    11 +-
 net/ipv4/tcp_recovery.c                            |     2 +-
 net/ipv4/tcp_timer.c                               |     6 +-
 net/ipv4/udp.c                                     |    31 +-
 net/ipv4/xfrm4_policy.c                            |     4 +-
 net/ipv6/addrconf.c                                |    17 +-
 net/ipv6/af_inet6.c                                |     3 +-
 net/ipv6/icmp.c                                    |    15 +-
 net/ipv6/inet6_connection_sock.c                   |     2 +-
 net/ipv6/ip6_flowlabel.c                           |    51 +-
 net/ipv6/ip6_input.c                               |    14 +-
 net/ipv6/ip6_output.c                              |    14 +-
 net/ipv6/ipv6_sockglue.c                           |     1 +
 net/ipv6/mcast.c                                   |     8 +-
 net/ipv6/ndisc.c                                   |     4 +-
 net/ipv6/netfilter/ip6_tables.c                    |    68 +-
 net/ipv6/ping.c                                    |     2 +-
 net/ipv6/raw.c                                     |     7 +-
 net/ipv6/route.c                                   |    53 +-
 net/ipv6/sit.c                                     |     2 +-
 net/ipv6/tcp_ipv6.c                                |    17 +-
 net/ipv6/udp.c                                     |     8 +-
 net/ipv6/xfrm6_policy.c                            |     4 +-
 net/mac80211/agg-tx.c                              |    17 +
 net/mac80211/cfg.c                                 |   120 +-
 net/mac80211/debugfs.c                             |     4 -
 net/mac80211/debugfs_netdev.c                      |   223 +-
 net/mac80211/debugfs_netdev.h                      |    16 +
 net/mac80211/driver-ops.c                          |    25 +-
 net/mac80211/driver-ops.h                          |    48 +
 net/mac80211/drop.h                                |    56 +
 net/mac80211/ieee80211_i.h                         |    67 +-
 net/mac80211/iface.c                               |    11 +
 net/mac80211/link.c                                |     5 +
 net/mac80211/main.c                                |    31 +
 net/mac80211/mesh.c                                |   171 +-
 net/mac80211/mesh.h                                |    48 +
 net/mac80211/mesh_hwmp.c                           |    37 +-
 net/mac80211/mesh_pathtbl.c                        |   282 +
 net/mac80211/mesh_plink.c                          |    16 +-
 net/mac80211/mlme.c                                |     6 +-
 net/mac80211/rc80211_minstrel_ht.c                 |     6 -
 net/mac80211/rx.c                                  |   279 +-
 net/mac80211/scan.c                                |     8 +-
 net/mac80211/sta_info.c                            |    12 +
 net/mac80211/sta_info.h                            |     9 +-
 net/mac80211/status.c                              |    24 -
 net/mac80211/trace.h                               |    32 +
 net/mac80211/tx.c                                  |   211 +-
 net/mac80211/util.c                                |    94 +
 net/mac80211/wpa.c                                 |    24 +-
 net/mctp/af_mctp.c                                 |     1 -
 net/mptcp/options.c                                |     9 +-
 net/mptcp/pm.c                                     |     4 +-
 net/mptcp/pm_netlink.c                             |     6 +-
 net/mptcp/pm_userspace.c                           |     4 +-
 net/mptcp/protocol.c                               |   107 +-
 net/mptcp/protocol.h                               |    15 +-
 net/mptcp/sockopt.c                                |    46 +-
 net/mptcp/subflow.c                                |    49 +-
 net/netfilter/Kconfig                              |     4 +-
 net/netfilter/Makefile                             |     1 +
 net/netfilter/core.c                               |    12 +
 net/netfilter/ipvs/ip_vs_conn.c                    |    12 +-
 net/netfilter/ipvs/ip_vs_core.c                    |     8 -
 net/netfilter/ipvs/ip_vs_ctl.c                     |    26 +-
 net/netfilter/ipvs/ip_vs_sync.c                    |     7 +-
 net/netfilter/ipvs/ip_vs_xmit.c                    |    66 +-
 net/netfilter/nf_bpf_link.c                        |   228 +
 net/netfilter/nf_conntrack_bpf.c                   |     6 +-
 net/netfilter/nf_conntrack_core.c                  |     3 +-
 net/netfilter/nf_conntrack_netlink.c               |    24 +-
 net/netfilter/nf_conntrack_ovs.c                   |    11 +-
 net/netfilter/nf_nat_core.c                        |     4 +-
 net/netfilter/nf_nat_redirect.c                    |    71 +-
 net/netfilter/nf_tables_api.c                      |   539 +-
 net/netfilter/nf_tables_core.c                     |    59 +-
 net/netfilter/nf_tables_trace.c                    |    62 +-
 net/netfilter/nfnetlink.c                          |     2 -
 net/netfilter/nfnetlink_hook.c                     |    81 +-
 net/netfilter/nfnetlink_log.c                      |    36 +-
 net/netfilter/nfnetlink_queue.c                    |    20 +
 net/netfilter/nft_masq.c                           |    75 +-
 net/netfilter/nft_redir.c                          |    84 +-
 net/netfilter/utils.c                              |    52 +
 net/netfilter/xt_REDIRECT.c                        |    10 +-
 net/netfilter/xt_tcpudp.c                          |   110 +
 net/netlink/af_netlink.c                           |    77 +-
 net/netlink/af_netlink.h                           |     1 -
 net/packet/af_packet.c                             |   191 +-
 net/packet/diag.c                                  |    12 +-
 net/packet/internal.h                              |    37 +-
 net/rxrpc/af_rxrpc.c                               |    37 +-
 net/rxrpc/key.c                                    |     2 +-
 net/rxrpc/protocol.h                               |     2 +-
 net/rxrpc/rxperf.c                                 |     3 +-
 net/sched/act_api.c                                |     8 +-
 net/sched/act_csum.c                               |     3 +-
 net/sched/act_mirred.c                             |     2 +-
 net/sched/act_mpls.c                               |     2 +-
 net/sched/act_pedit.c                              |    85 +-
 net/sched/act_tunnel_key.c                         |     5 +
 net/sched/cls_api.c                                |     1 +
 net/sched/cls_flower.c                             |     2 +-
 net/sched/em_meta.c                                |     2 +-
 net/sched/sch_api.c                                |     6 +-
 net/sched/sch_cake.c                               |     6 +-
 net/sched/sch_fq.c                                 |     6 +-
 net/sched/sch_generic.c                            |    10 +-
 net/sched/sch_htb.c                                |    17 +-
 net/sched/sch_mqprio.c                             |   196 +-
 net/sched/sch_mqprio_lib.c                         |    14 +
 net/sched/sch_mqprio_lib.h                         |     2 +
 net/sched/sch_pie.c                                |     2 +-
 net/sched/sch_qfq.c                                |    34 +-
 net/sched/sch_taprio.c                             |    77 +-
 net/sctp/Makefile                                  |     3 +-
 net/sctp/associola.c                               |     5 +-
 net/sctp/auth.c                                    |     2 +-
 net/sctp/input.c                                   |     4 +-
 net/sctp/ipv6.c                                    |     2 +-
 net/sctp/outqueue.c                                |    11 +-
 net/sctp/sm_make_chunk.c                           |    32 +-
 net/sctp/sm_sideeffect.c                           |     3 +-
 net/sctp/sm_statefuns.c                            |    14 +-
 net/sctp/socket.c                                  |     5 +-
 net/sctp/stream.c                                  |     2 +-
 net/sctp/stream_interleave.c                       |     4 +-
 net/sctp/stream_sched.c                            |     2 +
 net/sctp/stream_sched_fc.c                         |   225 +
 net/smc/smc.h                                      |     5 +-
 net/smc/smc_core.h                                 |    10 +-
 net/smc/smc_ism.c                                  |     2 +-
 net/smc/smc_wr.c                                   |    35 +-
 net/smc/smc_wr.h                                   |     5 +-
 net/socket.c                                       |     4 +-
 net/unix/af_unix.c                                 |     9 +-
 net/unix/garbage.c                                 |     2 +-
 net/unix/scm.c                                     |     6 +
 net/vmw_vsock/Makefile                             |     1 +
 net/vmw_vsock/af_vsock.c                           |    68 +-
 net/vmw_vsock/virtio_transport.c                   |     2 +
 net/vmw_vsock/virtio_transport_common.c            |    96 +-
 net/vmw_vsock/vmci_transport.c                     |    11 +-
 net/vmw_vsock/vsock_bpf.c                          |   174 +
 net/vmw_vsock/vsock_loopback.c                     |     5 +-
 net/wireless/mlme.c                                |    55 +-
 net/wireless/nl80211.c                             |   171 +-
 net/wireless/rdev-ops.h                            |    17 +
 net/wireless/scan.c                                |    38 +-
 net/wireless/trace.h                               |    36 +-
 net/wireless/util.c                                |    36 +-
 net/xdp/xsk.c                                      |     9 +-
 net/xdp/xsk_queue.h                                |    19 +-
 net/xdp/xskmap.c                                   |    21 +-
 net/xfrm/xfrm_device.c                             |     2 +-
 net/xfrm/xfrm_input.c                              |    66 +-
 net/xfrm/xfrm_output.c                             |    33 +-
 net/xfrm/xfrm_state.c                              |     1 +
 net/xfrm/xfrm_user.c                               |     2 +
 samples/bpf/cpustat_kern.c                         |     4 +-
 samples/bpf/hbm.c                                  |     5 +-
 samples/bpf/ibumad_kern.c                          |     4 +-
 samples/bpf/lwt_len_hist.sh                        |     2 +-
 samples/bpf/offwaketime_kern.c                     |     2 +-
 samples/bpf/sampleip_user.c                        |    11 +-
 samples/bpf/task_fd_query_user.c                   |     4 +-
 samples/bpf/test_lwt_bpf.sh                        |     2 +-
 samples/bpf/test_overhead_tp.bpf.c                 |     4 +-
 scripts/atomic/atomics.tbl                         |     2 +-
 scripts/atomic/fallbacks/add_negative              |    11 +-
 scripts/bpf_doc.py                                 |     2 +-
 security/lsm_audit.c                               |     6 +-
 tools/arch/arm64/include/uapi/asm/bpf_perf_event.h |     9 -
 tools/arch/s390/include/uapi/asm/bpf_perf_event.h  |     9 -
 tools/arch/s390/include/uapi/asm/ptrace.h          |   458 -
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |    18 +-
 .../bpftool/Documentation/bpftool-struct_ops.rst   |    12 +-
 tools/bpf/bpftool/bash-completion/bpftool          |    42 +-
 tools/bpf/bpftool/btf_dumper.c                     |    83 +
 tools/bpf/bpftool/cfg.c                            |    29 +-
 tools/bpf/bpftool/cfg.h                            |     5 +-
 tools/bpf/bpftool/common.c                         |    14 +
 tools/bpf/bpftool/json_writer.c                    |     5 +-
 tools/bpf/bpftool/json_writer.h                    |     1 +
 tools/bpf/bpftool/link.c                           |    83 +
 tools/bpf/bpftool/main.h                           |     8 +
 tools/bpf/bpftool/net.c                            |   106 +
 tools/bpf/bpftool/prog.c                           |    94 +-
 tools/bpf/bpftool/struct_ops.c                     |    70 +-
 tools/bpf/bpftool/xlated_dumper.c                  |    54 +-
 tools/bpf/bpftool/xlated_dumper.h                  |     3 +-
 tools/bpf/resolve_btfids/.gitignore                |     1 +
 tools/include/uapi/linux/bpf.h                     |   112 +-
 tools/include/uapi/linux/if_link.h                 |     1 +
 tools/lib/bpf/Build                                |     2 +-
 tools/lib/bpf/bpf.c                                |    25 +-
 tools/lib/bpf/bpf.h                                |    94 +-
 tools/lib/bpf/bpf_gen_internal.h                   |     4 +-
 tools/lib/bpf/bpf_helpers.h                        |   110 +-
 tools/lib/bpf/bpf_tracing.h                        |     3 +
 tools/lib/bpf/btf.c                                |     2 -
 tools/lib/bpf/gen_loader.c                         |    48 +-
 tools/lib/bpf/libbpf.c                             |   552 +-
 tools/lib/bpf/libbpf.h                             |    53 +-
 tools/lib/bpf/libbpf.map                           |     1 +
 tools/lib/bpf/libbpf_probes.c                      |     1 +
 tools/lib/bpf/linker.c                             |    25 +-
 tools/lib/bpf/netlink.c                            |     8 +-
 tools/lib/bpf/relo_core.c                          |     3 -
 tools/lib/bpf/usdt.c                               |   196 +-
 tools/lib/bpf/zip.c                                |   333 +
 tools/lib/bpf/zip.h                                |    47 +
 tools/net/ynl/ethtool.py                           |   424 +
 tools/net/ynl/lib/nlspec.py                        |    91 +-
 tools/net/ynl/lib/ynl.py                           |   120 +-
 tools/net/ynl/requirements.txt                     |     2 +
 tools/net/ynl/ynl-gen-c.py                         |     7 +-
 tools/scripts/Makefile.include                     |     2 +
 tools/testing/selftests/bpf/DENYLIST.aarch64       |     1 +
 tools/testing/selftests/bpf/DENYLIST.s390x         |     4 +
 tools/testing/selftests/bpf/Makefile               |    23 +-
 tools/testing/selftests/bpf/autoconf_helper.h      |     9 +
 tools/testing/selftests/bpf/bench.c                |     4 +
 .../bpf/benchs/bench_local_storage_create.c        |   264 +
 tools/testing/selftests/bpf/bpf_experimental.h     |    60 +-
 tools/testing/selftests/bpf/bpf_kfuncs.h           |    38 +
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        |    80 +-
 .../selftests/bpf/bpf_testmod/bpf_testmod.h        |     6 +
 tools/testing/selftests/bpf/config.aarch64         |     2 +
 tools/testing/selftests/bpf/config.s390x           |     3 +
 tools/testing/selftests/bpf/config.x86_64          |     3 +
 tools/testing/selftests/bpf/disasm.c               |     1 +
 tools/testing/selftests/bpf/disasm.h               |     1 +
 tools/testing/selftests/bpf/get_cgroup_id_user.c   |     9 +-
 tools/testing/selftests/bpf/json_writer.c          |     1 +
 tools/testing/selftests/bpf/json_writer.h          |     1 +
 tools/testing/selftests/bpf/network_helpers.c      |     2 +-
 .../bpf/prog_tests/access_variable_array.c         |    16 +
 tools/testing/selftests/bpf/prog_tests/align.c     |    22 +-
 .../selftests/bpf/prog_tests/attach_probe.c        |   291 +-
 .../testing/selftests/bpf/prog_tests/bpf_tcp_ca.c  |   160 +
 .../selftests/bpf/prog_tests/bpf_verif_scale.c     |     6 +
 .../selftests/bpf/prog_tests/cg_storage_multi.c    |     8 +-
 .../testing/selftests/bpf/prog_tests/cgrp_kfunc.c  |     1 +
 .../selftests/bpf/prog_tests/cgrp_local_storage.c  |    14 +-
 .../selftests/bpf/prog_tests/cls_redirect.c        |    25 +
 tools/testing/selftests/bpf/prog_tests/cpumask.c   |     2 +-
 .../testing/selftests/bpf/prog_tests/ctx_rewrite.c |   917 ++
 .../selftests/bpf/prog_tests/decap_sanity.c        |    16 +-
 tools/testing/selftests/bpf/prog_tests/dynptr.c    |    74 +-
 tools/testing/selftests/bpf/prog_tests/empty_skb.c |    25 +-
 .../testing/selftests/bpf/prog_tests/fib_lookup.c  |    38 +-
 .../selftests/bpf/prog_tests/flow_dissector.c      |    24 +
 .../selftests/bpf/prog_tests/get_branch_snapshot.c |     4 +-
 .../bpf/prog_tests/get_stackid_cannot_attach.c     |     1 +
 tools/testing/selftests/bpf/prog_tests/iters.c     |   106 +
 .../selftests/bpf/prog_tests/kprobe_multi_test.c   |    11 +-
 tools/testing/selftests/bpf/prog_tests/l4lb_all.c  |     2 +
 .../testing/selftests/bpf/prog_tests/linked_list.c |    96 +-
 .../selftests/bpf/prog_tests/local_kptr_stash.c    |    60 +
 tools/testing/selftests/bpf/prog_tests/log_fixup.c |    34 +-
 tools/testing/selftests/bpf/prog_tests/map_kptr.c  |   136 +-
 tools/testing/selftests/bpf/prog_tests/map_ops.c   |   162 +
 .../bpf/prog_tests/module_fentry_shadow.c          |   128 +
 tools/testing/selftests/bpf/prog_tests/mptcp.c     |    19 +-
 .../selftests/bpf/prog_tests/parse_tcp_hdr_opt.c   |    93 +
 .../selftests/bpf/prog_tests/perf_event_stackmap.c |     3 +-
 tools/testing/selftests/bpf/prog_tests/rbtree.c    |    25 +
 .../selftests/bpf/prog_tests/rcu_read_lock.c       |    16 +-
 .../selftests/bpf/prog_tests/refcounted_kptr.c     |    16 +
 .../testing/selftests/bpf/prog_tests/send_signal.c |     6 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c      |   168 +
 .../testing/selftests/bpf/prog_tests/sockopt_sk.c  |    28 +
 .../selftests/bpf/prog_tests/stacktrace_build_id.c |    19 +-
 .../bpf/prog_tests/stacktrace_build_id_nmi.c       |    32 +-
 .../selftests/bpf/prog_tests/task_fd_query_tp.c    |     9 +-
 .../testing/selftests/bpf/prog_tests/task_kfunc.c  |     3 +-
 .../testing/selftests/bpf/prog_tests/tc_redirect.c |   100 +-
 .../selftests/bpf/prog_tests/tcp_hdr_options.c     |     4 +-
 tools/testing/selftests/bpf/prog_tests/test_ima.c  |    29 +-
 .../selftests/bpf/prog_tests/test_local_storage.c  |    54 +-
 .../testing/selftests/bpf/prog_tests/test_tunnel.c |   224 +-
 tools/testing/selftests/bpf/prog_tests/timer.c     |     3 +
 .../selftests/bpf/prog_tests/tp_attach_query.c     |     9 +-
 .../selftests/bpf/prog_tests/trace_printk.c        |    10 +-
 .../selftests/bpf/prog_tests/trace_vprintk.c       |    10 +-
 .../selftests/bpf/prog_tests/tracing_struct.c      |     2 +
 .../selftests/bpf/prog_tests/uprobe_autoattach.c   |     1 -
 .../selftests/bpf/prog_tests/user_ringbuf.c        |     2 +-
 tools/testing/selftests/bpf/prog_tests/verifier.c  |   216 +
 .../selftests/bpf/prog_tests/verifier_log.c        |   450 +
 .../testing/selftests/bpf/prog_tests/xdp_attach.c  |    11 +-
 .../testing/selftests/bpf/prog_tests/xdp_bonding.c |    40 +-
 .../selftests/bpf/prog_tests/xdp_do_redirect.c     |    41 +-
 .../selftests/bpf/prog_tests/xdp_metadata.c        |    23 +-
 .../selftests/bpf/prog_tests/xdp_synproxy.c        |    41 +-
 tools/testing/selftests/bpf/prog_tests/xfrm_info.c |    67 +-
 .../bpf/progs/bench_local_storage_create.c         |    82 +
 tools/testing/selftests/bpf/progs/bpf_flow.c       |     2 +-
 tools/testing/selftests/bpf/progs/bpf_iter_ksym.c  |     1 -
 .../selftests/bpf/progs/bpf_iter_setsockopt.c      |     1 -
 tools/testing/selftests/bpf/progs/bpf_loop.c       |     2 -
 tools/testing/selftests/bpf/progs/bpf_misc.h       |    74 +
 tools/testing/selftests/bpf/progs/cb_refs.c        |     3 +-
 .../bpf/progs/cgroup_skb_sk_lookup_kern.c          |     1 -
 .../selftests/bpf/progs/cgrp_kfunc_common.h        |    11 +-
 .../selftests/bpf/progs/cgrp_kfunc_failure.c       |   104 +-
 .../selftests/bpf/progs/cgrp_kfunc_success.c       |    69 +-
 .../selftests/bpf/progs/cgrp_ls_attach_cgroup.c    |     1 -
 .../selftests/bpf/progs/cgrp_ls_sleepable.c        |     5 +-
 tools/testing/selftests/bpf/progs/connect4_prog.c  |     2 +-
 tools/testing/selftests/bpf/progs/core_kern.c      |     2 +-
 tools/testing/selftests/bpf/progs/cpumask_common.h |     9 +-
 .../testing/selftests/bpf/progs/cpumask_failure.c  |    98 +-
 .../testing/selftests/bpf/progs/cpumask_success.c  |    30 +-
 tools/testing/selftests/bpf/progs/dynptr_fail.c    |   292 +-
 tools/testing/selftests/bpf/progs/dynptr_success.c |    54 +-
 tools/testing/selftests/bpf/progs/err.h            |    18 +
 tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c  |     2 -
 tools/testing/selftests/bpf/progs/find_vma_fail1.c |     2 +-
 .../selftests/bpf/progs/freplace_attach_probe.c    |     2 +-
 tools/testing/selftests/bpf/progs/iters.c          |   723 +
 tools/testing/selftests/bpf/progs/iters_looping.c  |   163 +
 tools/testing/selftests/bpf/progs/iters_num.c      |   242 +
 .../selftests/bpf/progs/iters_state_safety.c       |   426 +
 .../selftests/bpf/progs/iters_testmod_seq.c        |    79 +
 tools/testing/selftests/bpf/progs/jit_probe_mem.c  |     2 +-
 tools/testing/selftests/bpf/progs/linked_funcs1.c  |     3 +
 tools/testing/selftests/bpf/progs/linked_funcs2.c  |     3 +
 tools/testing/selftests/bpf/progs/linked_list.c    |    38 +-
 tools/testing/selftests/bpf/progs/linked_list.h    |     4 +-
 .../testing/selftests/bpf/progs/linked_list_fail.c |    97 +-
 .../testing/selftests/bpf/progs/local_kptr_stash.c |   108 +
 tools/testing/selftests/bpf/progs/local_storage.c  |    76 +-
 tools/testing/selftests/bpf/progs/loop6.c          |     3 +
 tools/testing/selftests/bpf/progs/lru_bug.c        |     2 +-
 tools/testing/selftests/bpf/progs/lsm.c            |     4 +-
 tools/testing/selftests/bpf/progs/map_kptr.c       |   373 +-
 tools/testing/selftests/bpf/progs/map_kptr_fail.c  |    87 +-
 .../selftests/bpf/progs/nested_trust_failure.c     |     2 +-
 tools/testing/selftests/bpf/progs/netcnt_prog.c    |     1 -
 .../selftests/bpf/progs/netif_receive_skb.c        |     1 -
 tools/testing/selftests/bpf/progs/perfbuf_bench.c  |     1 -
 tools/testing/selftests/bpf/progs/profiler.inc.h   |     3 +-
 tools/testing/selftests/bpf/progs/pyperf.h         |    16 +-
 tools/testing/selftests/bpf/progs/pyperf600_iter.c |     7 +
 .../selftests/bpf/progs/pyperf600_nounroll.c       |     3 -
 tools/testing/selftests/bpf/progs/rbtree.c         |    76 +-
 .../bpf/progs/rbtree_btf_fail__wrong_node_type.c   |    11 -
 tools/testing/selftests/bpf/progs/rbtree_fail.c    |    83 +-
 tools/testing/selftests/bpf/progs/rcu_read_lock.c  |    19 +-
 .../selftests/bpf/progs/rcu_tasks_trace_gp.c       |    36 +
 .../bpf/progs/read_bpf_task_storage_busy.c         |     1 -
 tools/testing/selftests/bpf/progs/recvmsg4_prog.c  |     2 -
 tools/testing/selftests/bpf/progs/recvmsg6_prog.c  |     2 -
 .../testing/selftests/bpf/progs/refcounted_kptr.c  |   406 +
 .../selftests/bpf/progs/refcounted_kptr_fail.c     |    72 +
 tools/testing/selftests/bpf/progs/sendmsg4_prog.c  |     2 -
 .../selftests/bpf/progs/sockmap_verdict_prog.c     |     4 +
 tools/testing/selftests/bpf/progs/sockopt_sk.c     |    12 +
 tools/testing/selftests/bpf/progs/strobemeta.h     |     1 -
 .../selftests/bpf/progs/tailcall_bpf2bpf3.c        |    11 +
 .../selftests/bpf/progs/tailcall_bpf2bpf6.c        |     3 +
 .../selftests/bpf/progs/task_kfunc_common.h        |     8 +-
 .../selftests/bpf/progs/task_kfunc_failure.c       |   178 +-
 .../selftests/bpf/progs/task_kfunc_success.c       |    78 +-
 tools/testing/selftests/bpf/progs/tcp_ca_update.c  |    80 +
 .../selftests/bpf/progs/tcp_ca_write_sk_pacing.c   |    13 +-
 .../bpf/progs/test_access_variable_array.c         |    19 +
 .../bpf/progs/test_attach_kprobe_sleepable.c       |    23 +
 .../selftests/bpf/progs/test_attach_probe.c        |    35 +-
 .../selftests/bpf/progs/test_attach_probe_manual.c |    53 +
 tools/testing/selftests/bpf/progs/test_bpf_nf.c    |     1 -
 .../selftests/bpf/progs/test_cls_redirect_dynptr.c |   979 ++
 .../bpf/progs/test_core_reloc_bitfields_probed.c   |     1 -
 .../selftests/bpf/progs/test_global_func1.c        |     4 +
 .../selftests/bpf/progs/test_global_func2.c        |     4 +
 .../selftests/bpf/progs/test_hash_large_key.c      |     2 +-
 .../selftests/bpf/progs/test_kfunc_dynptr_param.c  |     2 +-
 .../bpf/progs/test_ksyms_btf_write_check.c         |     1 -
 .../testing/selftests/bpf/progs/test_ksyms_weak.c  |    17 +-
 .../bpf/progs/test_l4lb_noinline_dynptr.c          |   487 +
 .../selftests/bpf/progs/test_legacy_printk.c       |     2 +-
 tools/testing/selftests/bpf/progs/test_log_fixup.c |    10 +
 tools/testing/selftests/bpf/progs/test_map_lock.c  |     2 +-
 tools/testing/selftests/bpf/progs/test_map_ops.c   |   138 +
 tools/testing/selftests/bpf/progs/test_obj_id.c    |     2 +
 .../selftests/bpf/progs/test_parse_tcp_hdr_opt.c   |   118 +
 .../bpf/progs/test_parse_tcp_hdr_opt_dynptr.c      |   114 +
 .../testing/selftests/bpf/progs/test_pkt_access.c  |     5 +
 tools/testing/selftests/bpf/progs/test_ringbuf.c   |     1 -
 .../selftests/bpf/progs/test_ringbuf_map_key.c     |     1 +
 .../selftests/bpf/progs/test_ringbuf_multi.c       |     1 -
 .../bpf/progs/test_select_reuseport_kern.c         |     2 +-
 tools/testing/selftests/bpf/progs/test_sk_assign.c |     4 +-
 tools/testing/selftests/bpf/progs/test_sk_lookup.c |     9 +-
 .../selftests/bpf/progs/test_sk_lookup_kern.c      |     4 +-
 .../selftests/bpf/progs/test_sk_storage_tracing.c  |    16 +
 .../testing/selftests/bpf/progs/test_sock_fields.c |     2 +-
 .../selftests/bpf/progs/test_sockmap_kern.h        |    14 +-
 tools/testing/selftests/bpf/progs/test_spin_lock.c |     3 +
 .../selftests/bpf/progs/test_stacktrace_map.c      |     2 +-
 tools/testing/selftests/bpf/progs/test_tc_dtime.c  |     4 +-
 tools/testing/selftests/bpf/progs/test_tc_neigh.c  |     4 +-
 .../testing/selftests/bpf/progs/test_tcpbpf_kern.c |     2 -
 .../testing/selftests/bpf/progs/test_tracepoint.c  |     2 +-
 .../testing/selftests/bpf/progs/test_tunnel_kern.c |   133 +-
 .../selftests/bpf/progs/test_usdt_multispec.c      |     2 -
 .../selftests/bpf/progs/test_verif_scale1.c        |     2 +-
 .../selftests/bpf/progs/test_verif_scale2.c        |     2 +-
 .../selftests/bpf/progs/test_verif_scale3.c        |     2 +-
 .../bpf/progs/test_xdp_adjust_tail_grow.c          |     2 -
 .../testing/selftests/bpf/progs/test_xdp_bpf2bpf.c |     2 -
 .../selftests/bpf/progs/test_xdp_do_redirect.c     |    38 +-
 .../testing/selftests/bpf/progs/test_xdp_dynptr.c  |   255 +
 .../selftests/bpf/progs/test_xdp_noinline.c        |    43 -
 tools/testing/selftests/bpf/progs/test_xdp_vlan.c  |    13 -
 tools/testing/selftests/bpf/progs/timer.c          |    45 +
 tools/testing/selftests/bpf/progs/tracing_struct.c |    13 +
 tools/testing/selftests/bpf/progs/type_cast.c      |     1 -
 tools/testing/selftests/bpf/progs/udp_limit.c      |     2 -
 .../selftests/bpf/progs/user_ringbuf_success.c     |     8 +-
 tools/testing/selftests/bpf/progs/verifier_and.c   |   107 +
 .../selftests/bpf/progs/verifier_array_access.c    |   529 +
 .../selftests/bpf/progs/verifier_basic_stack.c     |   100 +
 .../testing/selftests/bpf/progs/verifier_bounds.c  |  1076 ++
 .../bpf/progs/verifier_bounds_deduction.c          |   171 +
 .../progs/verifier_bounds_deduction_non_const.c    |   639 +
 .../bpf/progs/verifier_bounds_mix_sign_unsign.c    |   554 +
 .../selftests/bpf/progs/verifier_bpf_get_stack.c   |   124 +
 .../selftests/bpf/progs/verifier_btf_ctx_access.c  |    32 +
 tools/testing/selftests/bpf/progs/verifier_cfg.c   |   100 +
 .../bpf/progs/verifier_cgroup_inv_retcode.c        |    89 +
 .../selftests/bpf/progs/verifier_cgroup_skb.c      |   227 +
 .../selftests/bpf/progs/verifier_cgroup_storage.c  |   308 +
 .../selftests/bpf/progs/verifier_const_or.c        |    82 +
 tools/testing/selftests/bpf/progs/verifier_ctx.c   |   221 +
 .../selftests/bpf/progs/verifier_ctx_sk_msg.c      |   228 +
 .../testing/selftests/bpf/progs/verifier_d_path.c  |    48 +
 .../bpf/progs/verifier_direct_packet_access.c      |   803 +
 .../verifier_direct_stack_access_wraparound.c      |    56 +
 tools/testing/selftests/bpf/progs/verifier_div0.c  |   213 +
 .../selftests/bpf/progs/verifier_div_overflow.c    |   144 +
 .../bpf/progs/verifier_helper_access_var_len.c     |   825 ++
 .../bpf/progs/verifier_helper_packet_access.c      |   550 +
 .../bpf/progs/verifier_helper_restricted.c         |   279 +
 .../bpf/progs/verifier_helper_value_access.c       |  1245 ++
 .../testing/selftests/bpf/progs/verifier_int_ptr.c |   157 +
 .../bpf/progs/verifier_jeq_infer_not_null.c        |   213 +
 .../testing/selftests/bpf/progs/verifier_ld_ind.c  |   110 +
 .../selftests/bpf/progs/verifier_leak_ptr.c        |    92 +
 .../testing/selftests/bpf/progs/verifier_loops1.c  |   259 +
 tools/testing/selftests/bpf/progs/verifier_lwt.c   |   234 +
 .../selftests/bpf/progs/verifier_map_in_map.c      |   142 +
 .../testing/selftests/bpf/progs/verifier_map_ptr.c |   159 +
 .../selftests/bpf/progs/verifier_map_ptr_mixing.c  |   265 +
 .../selftests/bpf/progs/verifier_map_ret_val.c     |   110 +
 .../testing/selftests/bpf/progs/verifier_masking.c |   410 +
 .../selftests/bpf/progs/verifier_meta_access.c     |   284 +
 .../selftests/bpf/progs/verifier_netfilter_ctx.c   |   121 +
 .../bpf/progs/verifier_netfilter_retcode.c         |    49 +
 .../bpf/progs/verifier_prevent_map_lookup.c        |    61 +
 .../selftests/bpf/progs/verifier_raw_stack.c       |   371 +
 .../selftests/bpf/progs/verifier_raw_tp_writable.c |    50 +
 .../selftests/bpf/progs/verifier_ref_tracking.c    |  1495 ++
 .../selftests/bpf/progs/verifier_reg_equal.c       |    58 +
 .../selftests/bpf/progs/verifier_regalloc.c        |   364 +
 .../testing/selftests/bpf/progs/verifier_ringbuf.c |   131 +
 .../selftests/bpf/progs/verifier_runtime_jit.c     |   360 +
 .../selftests/bpf/progs/verifier_search_pruning.c  |   339 +
 tools/testing/selftests/bpf/progs/verifier_sock.c  |   980 ++
 .../selftests/bpf/progs/verifier_spill_fill.c      |   374 +
 .../selftests/bpf/progs/verifier_spin_lock.c       |   533 +
 .../selftests/bpf/progs/verifier_stack_ptr.c       |   484 +
 .../testing/selftests/bpf/progs/verifier_subreg.c  |   673 +
 .../testing/selftests/bpf/progs/verifier_uninit.c  |    61 +
 .../testing/selftests/bpf/progs/verifier_unpriv.c  |   726 +
 .../selftests/bpf/progs/verifier_unpriv_perf.c     |    34 +
 tools/testing/selftests/bpf/progs/verifier_value.c |   158 +
 .../selftests/bpf/progs/verifier_value_adj_spill.c |    78 +
 .../bpf/progs/verifier_value_illegal_alu.c         |   149 +
 .../selftests/bpf/progs/verifier_value_or_null.c   |   288 +
 .../selftests/bpf/progs/verifier_value_ptr_arith.c |  1423 ++
 .../testing/selftests/bpf/progs/verifier_var_off.c |   349 +
 tools/testing/selftests/bpf/progs/verifier_xadd.c  |   124 +
 tools/testing/selftests/bpf/progs/verifier_xdp.c   |    24 +
 .../bpf/progs/verifier_xdp_direct_packet_access.c  |  1722 +++
 tools/testing/selftests/bpf/progs/xdp_features.c   |     1 -
 tools/testing/selftests/bpf/progs/xdping_kern.c    |     2 -
 tools/testing/selftests/bpf/progs/xdpwall.c        |     1 -
 tools/testing/selftests/bpf/progs/xsk_xdp_progs.c  |    25 +
 tools/testing/selftests/bpf/test_ftrace.sh         |     7 +-
 tools/testing/selftests/bpf/test_loader.c          |   614 +-
 tools/testing/selftests/bpf/test_progs.c           |   108 +-
 tools/testing/selftests/bpf/test_progs.h           |    27 +-
 tools/testing/selftests/bpf/test_tcp_hdr_options.h |     1 +
 tools/testing/selftests/bpf/test_tunnel.sh         |    13 +-
 tools/testing/selftests/bpf/test_verifier.c        |    49 +-
 tools/testing/selftests/bpf/test_verifier_log.c    |   175 -
 tools/testing/selftests/bpf/test_xsk.sh            |     1 +
 tools/testing/selftests/bpf/testing_helpers.c      |    22 +-
 tools/testing/selftests/bpf/testing_helpers.h      |     2 +
 tools/testing/selftests/bpf/trace_helpers.c        |    90 +-
 tools/testing/selftests/bpf/trace_helpers.h        |     5 +
 tools/testing/selftests/bpf/unpriv_helpers.c       |    26 +
 tools/testing/selftests/bpf/unpriv_helpers.h       |     7 +
 tools/testing/selftests/bpf/verifier/and.c         |    68 -
 .../testing/selftests/bpf/verifier/array_access.c  |   379 -
 tools/testing/selftests/bpf/verifier/basic_stack.c |    64 -
 tools/testing/selftests/bpf/verifier/bounds.c      |   755 -
 .../selftests/bpf/verifier/bounds_deduction.c      |   136 -
 .../bpf/verifier/bounds_mix_sign_unsign.c          |   411 -
 .../testing/selftests/bpf/verifier/bpf_get_stack.c |    87 -
 .../selftests/bpf/verifier/btf_ctx_access.c        |    12 -
 tools/testing/selftests/bpf/verifier/calls.c       |    14 +-
 tools/testing/selftests/bpf/verifier/cfg.c         |    73 -
 .../selftests/bpf/verifier/cgroup_inv_retcode.c    |    72 -
 tools/testing/selftests/bpf/verifier/cgroup_skb.c  |   197 -
 .../selftests/bpf/verifier/cgroup_storage.c        |   220 -
 tools/testing/selftests/bpf/verifier/const_or.c    |    60 -
 tools/testing/selftests/bpf/verifier/ctx.c         |   197 -
 tools/testing/selftests/bpf/verifier/ctx_sk_msg.c  |   181 -
 tools/testing/selftests/bpf/verifier/d_path.c      |    37 -
 .../selftests/bpf/verifier/direct_packet_access.c  |   710 -
 .../bpf/verifier/direct_stack_access_wraparound.c  |    40 -
 tools/testing/selftests/bpf/verifier/div0.c        |   184 -
 .../testing/selftests/bpf/verifier/div_overflow.c  |   110 -
 .../selftests/bpf/verifier/helper_access_var_len.c |   650 -
 .../selftests/bpf/verifier/helper_packet_access.c  |   460 -
 .../selftests/bpf/verifier/helper_restricted.c     |   196 -
 .../selftests/bpf/verifier/helper_value_access.c   |   953 --
 tools/testing/selftests/bpf/verifier/int_ptr.c     |   161 -
 .../selftests/bpf/verifier/jeq_infer_not_null.c    |   174 -
 tools/testing/selftests/bpf/verifier/ld_ind.c      |    72 -
 tools/testing/selftests/bpf/verifier/leak_ptr.c    |    67 -
 tools/testing/selftests/bpf/verifier/loops1.c      |   206 -
 tools/testing/selftests/bpf/verifier/lwt.c         |   189 -
 tools/testing/selftests/bpf/verifier/map_in_map.c  |    96 -
 tools/testing/selftests/bpf/verifier/map_kptr.c    |    29 +-
 tools/testing/selftests/bpf/verifier/map_ptr.c     |    99 -
 .../selftests/bpf/verifier/map_ptr_mixing.c        |   100 -
 tools/testing/selftests/bpf/verifier/map_ret_val.c |    65 -
 tools/testing/selftests/bpf/verifier/masking.c     |   322 -
 tools/testing/selftests/bpf/verifier/meta_access.c |   235 -
 .../selftests/bpf/verifier/prevent_map_lookup.c    |    29 -
 tools/testing/selftests/bpf/verifier/raw_stack.c   |   305 -
 .../selftests/bpf/verifier/raw_tp_writable.c       |    35 -
 .../testing/selftests/bpf/verifier/ref_tracking.c  |  1082 --
 tools/testing/selftests/bpf/verifier/regalloc.c    |   277 -
 tools/testing/selftests/bpf/verifier/ringbuf.c     |    95 -
 tools/testing/selftests/bpf/verifier/runtime_jit.c |   231 -
 .../selftests/bpf/verifier/search_pruning.c        |   266 -
 tools/testing/selftests/bpf/verifier/sock.c        |   706 -
 tools/testing/selftests/bpf/verifier/spill_fill.c  |   345 -
 tools/testing/selftests/bpf/verifier/spin_lock.c   |   447 -
 tools/testing/selftests/bpf/verifier/stack_ptr.c   |   359 -
 tools/testing/selftests/bpf/verifier/subreg.c      |   533 -
 tools/testing/selftests/bpf/verifier/uninit.c      |    39 -
 tools/testing/selftests/bpf/verifier/unpriv.c      |   539 -
 tools/testing/selftests/bpf/verifier/value.c       |   104 -
 .../selftests/bpf/verifier/value_adj_spill.c       |    43 -
 .../selftests/bpf/verifier/value_illegal_alu.c     |    95 -
 .../testing/selftests/bpf/verifier/value_or_null.c |   220 -
 .../selftests/bpf/verifier/value_ptr_arith.c       |  1140 --
 tools/testing/selftests/bpf/verifier/var_off.c     |   291 -
 tools/testing/selftests/bpf/verifier/xadd.c        |    97 -
 tools/testing/selftests/bpf/verifier/xdp.c         |    14 -
 .../bpf/verifier/xdp_direct_packet_access.c        |  1468 --
 tools/testing/selftests/bpf/veristat.c             |   207 +-
 tools/testing/selftests/bpf/xdp_features.c         |    67 +-
 tools/testing/selftests/bpf/xsk_xdp_metadata.h     |     5 +
 tools/testing/selftests/bpf/xskxceiver.c           |   110 +-
 tools/testing/selftests/bpf/xskxceiver.h           |     5 +-
 .../selftests/drivers/net/mlxsw/qos_headroom.sh    |     3 +-
 .../testing/selftests/drivers/net/mlxsw/qos_lib.sh |    28 -
 .../testing/selftests/drivers/net/mlxsw/qos_pfc.sh |     3 +-
 .../testing/selftests/drivers/net/mlxsw/sch_ets.sh |     3 +-
 .../selftests/drivers/net/mlxsw/sch_red_core.sh    |     1 -
 .../selftests/drivers/net/mlxsw/sch_red_ets.sh     |     2 +-
 .../selftests/drivers/net/mlxsw/sch_red_root.sh    |     2 +-
 .../selftests/drivers/net/mlxsw/sch_tbf_ets.sh     |     6 +-
 .../selftests/drivers/net/mlxsw/sch_tbf_prio.sh    |     6 +-
 .../selftests/drivers/net/mlxsw/sch_tbf_root.sh    |     6 +-
 tools/testing/selftests/net/Makefile               |     5 +-
 tools/testing/selftests/net/big_tcp.sh             |   180 +
 tools/testing/selftests/net/config                 |     1 +
 tools/testing/selftests/net/forwarding/Makefile    |     2 +
 .../testing/selftests/net/forwarding/ethtool_mm.sh |   288 +
 .../selftests/net/forwarding/hw_stats_l3.sh        |    15 +-
 tools/testing/selftests/net/forwarding/lib.sh      |    60 +
 .../selftests/net/forwarding/sch_tbf_etsprio.sh    |     4 +
 .../selftests/net/forwarding/sch_tbf_root.sh       |     4 +
 .../selftests/net/forwarding/tc_tunnel_key.sh      |   161 +
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |     8 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |    57 +-
 .../selftests/net/openvswitch/openvswitch.sh       |    89 +-
 .../testing/selftests/net/openvswitch/ovs-dpctl.py |  1276 +-
 tools/testing/selftests/net/rtnetlink.sh           |   161 +-
 tools/testing/selftests/net/tcp_mmap.c             |   102 +-
 .../selftests/net/test_bridge_neigh_suppress.sh    |   862 ++
 tools/testing/selftests/net/test_vxlan_mdb.sh      |  2318 +++
 tools/testing/selftests/net/tls.c                  |    45 +
 .../creating-testcases/AddingTestCases.txt         |     2 +
 .../tc-testing/tc-tests/actions/tunnel_key.json    |    25 +
 .../tc-testing/tc-tests/infra/actions.json         |   416 +
 .../selftests/tc-testing/tc-tests/qdiscs/fq.json   |    22 +
 .../selftests/tc-testing/tc-tests/qdiscs/qfq.json  |    72 +
 tools/testing/selftests/tc-testing/tdc.py          |    13 +
 tools/testing/vsock/.gitignore                     |     1 +
 tools/testing/vsock/vsock_test.c                   |     4 +-
 1930 files changed, 138918 insertions(+), 47352 deletions(-)
 create mode 100644 Documentation/bpf/libbpf/libbpf_overview.rst
 delete mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.txt
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
 create mode 100644 Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
 create mode 100644 Documentation/devicetree/bindings/net/pcs/mediatek,sgmiisys.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/qcom,ethqos.txt
 create mode 100644 Documentation/devicetree/bindings/net/qcom,ethqos.yaml
 create mode 100644 Documentation/devicetree/bindings/net/starfive,jh7110-dwmac.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
 create mode 100644 Documentation/devicetree/bindings/net/wireless/qcom,ath10k.yaml
 create mode 100644 Documentation/devicetree/bindings/net/wireless/qcom,ath11k-pci.yaml
 create mode 100644 Documentation/netlink/specs/devlink.yaml
 create mode 100644 Documentation/netlink/specs/handshake.yaml
 create mode 100644 Documentation/netlink/specs/ovs_datapath.yaml
 create mode 100644 Documentation/netlink/specs/ovs_vport.yaml
 create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
 delete mode 100644 Documentation/networking/device_drivers/ethernet/intel/ixgb.rst
 create mode 100644 Documentation/networking/napi.rst
 create mode 100644 Documentation/networking/tls-handshake.rst
 create mode 100644 drivers/bluetooth/btnxpuart.c
 create mode 100644 drivers/net/can/bxcan.c
 create mode 100644 drivers/net/dsa/mt7530-mdio.c
 create mode 100644 drivers/net/dsa/mt7530-mmio.c
 create mode 100644 drivers/net/dsa/qca/qca8k-leds.c
 create mode 100644 drivers/net/dsa/qca/qca8k_leds.h
 create mode 100644 drivers/net/ethernet/amd/pds_core/Makefile
 create mode 100644 drivers/net/ethernet/amd/pds_core/adminq.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/auxbus.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/core.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/core.h
 create mode 100644 drivers/net/ethernet/amd/pds_core/debugfs.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/dev.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/devlink.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/fw.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/main.c
 delete mode 100644 drivers/net/ethernet/intel/ixgb/Makefile
 delete mode 100644 drivers/net/ethernet/intel/ixgb/ixgb.h
 delete mode 100644 drivers/net/ethernet/intel/ixgb/ixgb_ee.c
 delete mode 100644 drivers/net/ethernet/intel/ixgb/ixgb_ee.h
 delete mode 100644 drivers/net/ethernet/intel/ixgb/ixgb_ethtool.c
 delete mode 100644 drivers/net/ethernet/intel/ixgb/ixgb_hw.c
 delete mode 100644 drivers/net/ethernet/intel/ixgb/ixgb_hw.h
 delete mode 100644 drivers/net/ethernet/intel/ixgb/ixgb_ids.h
 delete mode 100644 drivers/net/ethernet/intel/ixgb/ixgb_main.c
 delete mode 100644 drivers/net/ethernet/intel/ixgb/ixgb_osdep.h
 delete mode 100644 drivers/net/ethernet/intel/ixgb/ixgb_param.c
 delete mode 100644 drivers/net/ethernet/mediatek/mtk_sgmii.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/reporter_vnic.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/reporter_vnic.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_mcast.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/debugfs.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_arg.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ptrn.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/thermal.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/thermal.h
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-starfive.c
 create mode 100644 drivers/net/ipa/data/ipa_data-v5.0.c
 create mode 100644 drivers/net/ipa/reg/gsi_reg-v5.0.c
 create mode 100644 drivers/net/ipa/reg/ipa_reg-v5.0.c
 create mode 100644 drivers/net/pcs/pcs-mtk-lynxi.c
 create mode 100644 drivers/net/phy/microchip_t1s.c
 create mode 100644 drivers/net/phy/nxp-cbtx.c
 create mode 100644 drivers/net/vxlan/vxlan_mdb.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/link.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/mld-mac.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/mld-mac80211.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/mld-sta.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/ptp.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/time-sync.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/mvm/time-sync.h
 create mode 100644 drivers/net/wireless/legacy/Kconfig
 create mode 100644 drivers/net/wireless/legacy/Makefile
 rename drivers/net/wireless/{ => legacy}/ray_cs.c (100%)
 rename drivers/net/wireless/{ => legacy}/ray_cs.h (100%)
 rename drivers/net/wireless/{ => legacy}/rayctl.h (100%)
 rename drivers/net/wireless/{ => legacy}/rndis_wlan.c (99%)
 rename drivers/net/wireless/{ => legacy}/wl3501.h (100%)
 rename drivers/net/wireless/{ => legacy}/wl3501_cs.c (100%)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/eeprom.h
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/mac.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/coredump.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7996/coredump.h
 create mode 100644 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8710b.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821cs.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822bs.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822cs.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/sdio.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/sdio.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8851b_rfk_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8851b_rfk_table.h
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8851b_table.c
 create mode 100644 drivers/net/wireless/realtek/rtw89/rtw8851b_table.h
 create mode 100644 drivers/net/wireless/virtual/Kconfig
 create mode 100644 drivers/net/wireless/virtual/Makefile
 rename drivers/net/wireless/{ => virtual}/mac80211_hwsim.c (86%)
 rename drivers/net/wireless/{ => virtual}/mac80211_hwsim.h (80%)
 rename drivers/net/wireless/{ => virtual}/virt_wifi.c (100%)
 create mode 100644 drivers/ptp/ptp_dfl_tod.c
 create mode 100644 include/linux/net_tstamp.h
 create mode 100644 include/linux/pcs/pcs-mtk-lynxi.h
 create mode 100644 include/linux/pds/pds_adminq.h
 create mode 100644 include/linux/pds/pds_auxbus.h
 create mode 100644 include/linux/pds/pds_common.h
 create mode 100644 include/linux/pds/pds_core_if.h
 create mode 100644 include/linux/pds/pds_intr.h
 delete mode 100644 include/linux/platform_data/nfcmrvl.h
 create mode 100644 include/linux/rcuref.h
 create mode 100644 include/net/bluetooth/coredump.h
 create mode 100644 include/net/dropreason-core.h
 create mode 100644 include/net/dsa_stubs.h
 create mode 100644 include/net/handshake.h
 create mode 100644 include/net/netdev_queues.h
 create mode 100644 include/net/netfilter/nf_bpf_link.h
 create mode 100644 include/trace/events/handshake.h
 create mode 100644 include/uapi/linux/handshake.h
 create mode 100644 kernel/bpf/log.c
 create mode 100644 lib/rcuref.c
 create mode 100644 net/bluetooth/coredump.c
 create mode 100644 net/dsa/stubs.c
 create mode 100644 net/dsa/trace.c
 create mode 100644 net/dsa/trace.h
 create mode 100644 net/handshake/.kunitconfig
 create mode 100644 net/handshake/Makefile
 create mode 100644 net/handshake/genl.c
 create mode 100644 net/handshake/genl.h
 create mode 100644 net/handshake/handshake-test.c
 create mode 100644 net/handshake/handshake.h
 create mode 100644 net/handshake/netlink.c
 create mode 100644 net/handshake/request.c
 create mode 100644 net/handshake/tlshd.c
 create mode 100644 net/handshake/trace.c
 create mode 100644 net/ipv4/fou_bpf.c
 create mode 100644 net/mac80211/drop.h
 create mode 100644 net/netfilter/nf_bpf_link.c
 create mode 100644 net/sctp/stream_sched_fc.c
 create mode 100644 net/vmw_vsock/vsock_bpf.c
 delete mode 100644 tools/arch/arm64/include/uapi/asm/bpf_perf_event.h
 delete mode 100644 tools/arch/s390/include/uapi/asm/bpf_perf_event.h
 delete mode 100644 tools/arch/s390/include/uapi/asm/ptrace.h
 create mode 100644 tools/lib/bpf/zip.c
 create mode 100644 tools/lib/bpf/zip.h
 create mode 100755 tools/net/ynl/ethtool.py
 create mode 100644 tools/net/ynl/requirements.txt
 create mode 100644 tools/testing/selftests/bpf/autoconf_helper.h
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_local_storage_create.c
 create mode 100644 tools/testing/selftests/bpf/bpf_kfuncs.h
 create mode 120000 tools/testing/selftests/bpf/disasm.c
 create mode 120000 tools/testing/selftests/bpf/disasm.h
 create mode 120000 tools/testing/selftests/bpf/json_writer.c
 create mode 120000 tools/testing/selftests/bpf/json_writer.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/access_variable_array.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ctx_rewrite.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/iters.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/local_kptr_stash.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/map_ops.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/module_fentry_shadow.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/parse_tcp_hdr_opt.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/refcounted_kptr.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/verifier.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/verifier_log.c
 create mode 100644 tools/testing/selftests/bpf/progs/bench_local_storage_create.c
 create mode 100644 tools/testing/selftests/bpf/progs/err.h
 create mode 100644 tools/testing/selftests/bpf/progs/iters.c
 create mode 100644 tools/testing/selftests/bpf/progs/iters_looping.c
 create mode 100644 tools/testing/selftests/bpf/progs/iters_num.c
 create mode 100644 tools/testing/selftests/bpf/progs/iters_state_safety.c
 create mode 100644 tools/testing/selftests/bpf/progs/iters_testmod_seq.c
 create mode 100644 tools/testing/selftests/bpf/progs/local_kptr_stash.c
 create mode 100644 tools/testing/selftests/bpf/progs/pyperf600_iter.c
 create mode 100644 tools/testing/selftests/bpf/progs/rcu_tasks_trace_gp.c
 create mode 100644 tools/testing/selftests/bpf/progs/refcounted_kptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/refcounted_kptr_fail.c
 create mode 100644 tools/testing/selftests/bpf/progs/tcp_ca_update.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_access_variable_array.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_attach_kprobe_sleepable.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_attach_probe_manual.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_cls_redirect_dynptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_l4lb_noinline_dynptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_map_ops.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_parse_tcp_hdr_opt.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_parse_tcp_hdr_opt_dynptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_dynptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_and.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_array_access.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_basic_stack.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_bounds.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_bounds_deduction.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_bounds_deduction_non_const.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_bounds_mix_sign_unsign.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_bpf_get_stack.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_btf_ctx_access.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_cfg.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_cgroup_inv_retcode.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_cgroup_skb.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_cgroup_storage.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_const_or.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_ctx.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_ctx_sk_msg.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_d_path.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_direct_packet_access.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_direct_stack_access_wraparound.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_div0.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_div_overflow.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_helper_access_var_len.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_helper_packet_access.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_helper_restricted.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_helper_value_access.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_int_ptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_jeq_infer_not_null.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_ld_ind.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_leak_ptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_loops1.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_lwt.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_map_in_map.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_map_ptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_map_ptr_mixing.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_map_ret_val.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_masking.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_meta_access.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_netfilter_ctx.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_netfilter_retcode.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_prevent_map_lookup.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_raw_stack.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_raw_tp_writable.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_ref_tracking.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_reg_equal.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_regalloc.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_ringbuf.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_runtime_jit.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_search_pruning.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_sock.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_spill_fill.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_spin_lock.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_stack_ptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_subreg.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_uninit.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_unpriv.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_unpriv_perf.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_value.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_value_adj_spill.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_value_illegal_alu.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_value_or_null.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_value_ptr_arith.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_var_off.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_xadd.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_xdp.c
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_xdp_direct_packet_access.c
 delete mode 100644 tools/testing/selftests/bpf/test_verifier_log.c
 create mode 100644 tools/testing/selftests/bpf/unpriv_helpers.c
 create mode 100644 tools/testing/selftests/bpf/unpriv_helpers.h
 delete mode 100644 tools/testing/selftests/bpf/verifier/and.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/array_access.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/basic_stack.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/bounds.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/bounds_deduction.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/bounds_mix_sign_unsign.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/bpf_get_stack.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/btf_ctx_access.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/cfg.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/cgroup_inv_retcode.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/cgroup_skb.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/cgroup_storage.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/const_or.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/ctx.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/ctx_sk_msg.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/d_path.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/direct_packet_access.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/direct_stack_access_wraparound.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/div0.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/div_overflow.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/helper_access_var_len.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/helper_packet_access.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/helper_restricted.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/helper_value_access.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/int_ptr.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/jeq_infer_not_null.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/ld_ind.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/leak_ptr.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/loops1.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/lwt.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/map_in_map.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/map_ptr.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/map_ptr_mixing.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/map_ret_val.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/masking.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/meta_access.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/prevent_map_lookup.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/raw_stack.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/raw_tp_writable.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/ref_tracking.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/regalloc.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/ringbuf.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/runtime_jit.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/search_pruning.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/sock.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/spill_fill.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/spin_lock.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/stack_ptr.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/subreg.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/uninit.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/unpriv.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/value.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/value_adj_spill.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/value_illegal_alu.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/value_or_null.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/value_ptr_arith.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/var_off.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/xadd.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/xdp.c
 delete mode 100644 tools/testing/selftests/bpf/verifier/xdp_direct_packet_access.c
 create mode 100644 tools/testing/selftests/bpf/xsk_xdp_metadata.h
 create mode 100755 tools/testing/selftests/net/big_tcp.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ethtool_mm.sh
 create mode 100755 tools/testing/selftests/net/forwarding/tc_tunnel_key.sh
 create mode 100755 tools/testing/selftests/net/test_bridge_neigh_suppress.sh
 create mode 100755 tools/testing/selftests/net/test_vxlan_mdb.sh
 create mode 100644 tools/testing/selftests/tc-testing/tc-tests/infra/actions.json

