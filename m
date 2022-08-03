Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F455588A32
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 12:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233057AbiHCKPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 06:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbiHCKPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 06:15:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D57C1FCD9
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 03:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659521699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2AosTdsbzlrT703LCI23ycSqjnT0/nm9ZoO/ZvL9bL4=;
        b=R3meZ9lNGNyXvS3ew0/vk52jCLdAEVIee2Y9QvbJwQIE5MMoAvepv/M34oXWe1dKvXC9JY
        OlaEX7XnBlY+ph6bKvhlCfbC+2623b/amIHCew/qxJVRxVn4Ris6sk4OK8oTo35YwcLwDc
        I1jsHBfgLdC+OQyEZgybjjqzwiZJurA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-307-vm_I8463OcSlofQezJCiPw-1; Wed, 03 Aug 2022 06:14:54 -0400
X-MC-Unique: vm_I8463OcSlofQezJCiPw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 02EDE1C1BD27;
        Wed,  3 Aug 2022 10:14:54 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2809D1121314;
        Wed,  3 Aug 2022 10:14:52 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for 6.0
Date:   Wed,  3 Aug 2022 12:14:38 +0200
Message-Id: <20220803101438.24327-1-pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

At the time of writing we have two known conflicts, one with arm-soc:

https://lore.kernel.org/linux-next/20220713125526.7fcf0bbc@canb.auug.org.au/

and one with rockchip:

https://lore.kernel.org/linux-next/20220616111635.3e27c15b@canb.auug.org.au/

in both cases Stephen's solution LGTM.

There is a little bit of noise all-around due to many spell fixes.


The following changes since commit 33ea1340bafe1f394e5bf96fceef73e9771d066b:

  Merge tag 'net-5.19-final' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-07-28 11:54:59 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-6.0

for you to fetch changes up to 7c6327c77d509e78bff76f2a4551fcfee851682e:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2022-08-03 09:04:55 +0200)

----------------------------------------------------------------
Networking changes for 6.0.

Core
----

 - Refactor the forward memory allocation to better cope with memory
   pressure with many open sockets, moving from a per socket cache to
   a per-CPU one

 - Replace rwlocks with RCU for better fairness in ping, raw sockets
   and IP multicast router.

 - Network-side support for IO uring zero-copy send.

 - A few skb drop reason improvements, including codegen the source file
   with string mapping instead of using macro magic.

 - Rename reference tracking helpers to a more consistent
   netdev_* schema.

 - Adapt u64_stats_t type to address load/store tearing issues.

 - Refine debug helper usage to reduce the log noise caused by bots.

BPF
---
 - Improve socket map performance, avoiding skb cloning on read
   operation.

 - Add support for 64 bits enum, to match types exposed by kernel.

 - Introduce support for sleepable uprobes program.

 - Introduce support for enum textual representation in libbpf.

 - New helpers to implement synproxy with eBPF/XDP.

 - Improve loop performances, inlining indirect calls when
   possible.

 - Removed all the deprecated libbpf APIs.

 - Implement new eBPF-based LSM flavor.

 - Add type match support, which allow accurate queries to the
   eBPF used types.

 - A few TCP congetsion control framework usability improvements.

 - Add new infrastructure to manipulate CT entries via eBPF programs.

 - Allow for livepatch (KLP) and BPF trampolines to attach to the same
   kernel function.

Protocols
---------

 - Introduce per network namespace lookup tables for unix sockets,
   increasing scalability and reducing contention.

 - Preparation work for Wi-Fi 7 Multi-Link Operation (MLO) support.

 - Add support to forciby close TIME_WAIT TCP sockets via user-space
   tools.

 - Significant performance improvement for the TLS 1.3 receive path,
   both for zero-copy and not-zero-copy.

 - Support for changing the initial MTPCP subflow priority/backup
   status

 - Introduce virtually contingus buffers for sockets over RDMA,
   to cope better with memory pressure.

 - Extend CAN ethtool support with timestamping capabilities

 - Refactor CAN build infrastructure to allow building only the needed
   features.

Driver API
----------

 - Remove devlink mutex to allow parallel commands on multiple links.

 - Add support for pause stats in distributed switch.

 - Implement devlink helpers to query and flash line cards.

 - New helper for phy mode to register conversion.

New hardware / drivers
----------------------

 - Ethernet DSA driver for the rockchip mt7531 on BPI-R2 Pro.

 - Ethernet DSA driver for the Renesas RZ/N1 A5PSW switch.

 - Ethernet DSA driver for the Microchip LAN937x switch.

 - Ethernet PHY driver for the Aquantia AQR113C EPHY.

 - CAN driver for the OBD-II ELM327 interface.

 - CAN driver for RZ/N1 SJA1000 CAN controller.

 - Bluetooth: Infineon CYW55572 Wi-Fi plus Bluetooth combo device.

Drivers
-------

 - Intel Ethernet NICs:
   - i40e: add support for vlan pruning
   - i40e: add support for XDP framented packets
   - ice: improved vlan offload support
   - ice: add support for PPPoE offload

 - Mellanox Ethernet (mlx5)
   - refactor packet steering offload for performance and scalability
   - extend support for TC offload
   - refactor devlink code to clean-up the locking schema
   - support stacked vlans for bridge offloads
   - use TLS objects pool to improve connection rate

 - Netronome Ethernet NICs (nfp):
   - extend support for IPv6 fields mangling offload
   - add support for vepa mode in HW bridge
   - better support for virtio data path acceleration (VDPA)
   - enable TSO by default

 - Microsoft vNIC driver (mana)
   - add support for XDP redirect

 - Others Ethernet drivers:
   - bonding: add per-port priority support
   - microchip lan743x: extend phy support
   - Fungible funeth: support UDP segmentation offload and XDP xmit
   - Solarflare EF100: add support for virtual function representors
   - MediaTek SoC: add XDP support

 - Mellanox Ethernet/IB switch (mlxsw):
   - dropped support for unreleased H/W (XM router).
   - improved stats accuracy
   - unified bridge model coversion improving scalability
     (parts 1-6)
   - support for PTP in Spectrum-2 asics

 - Broadcom PHYs
   - add PTP support for BCM54210E
   - add support for the BCM53128 internal PHY

 - Marvell Ethernet switches (prestera):
   - implement support for multicast forwarding offload

 - Embedded Ethernet switches:
   - refactor OcteonTx MAC filter for better scalability
   - improve TC H/W offload for the Felix driver
   - refactor the Microchip ksz8 and ksz9477 drivers to share
     the probe code (parts 1, 2), add support for phylink
     mac configuration

 - Other WiFi:
   - Microchip wilc1000: diable WEP support and enable WPA3
   - Atheros ath10k: encapsulation offload support

Old code removal:

 - Neterion vxge ethernet driver: this is untouched since more than
   10 years.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>

----------------------------------------------------------------
Aaron Ma (1):
      Bluetooth: btusb: Add support of IMC Networks PID 0x3568

Abhishek Pandit-Subedi (2):
      Bluetooth: Fix index added after unregister
      Bluetooth: Unregister suspend with userchannel

Aditya Kumar Singh (1):
      wifi: mac80211: fix mesh airtime link metric estimating

Ahmad Fatoum (2):
      dt-bindings: bluetooth: broadcom: Add BCM4349B1 DT binding
      Bluetooth: hci_bcm: Add BCM4349B1 variant

Ajay Singh (11):
      wifi: wilc1000: use correct sequence of RESET for chip Power-UP/Down
      wifi: wilc1000: remove WEP security support
      wifi: wilc1000: add WPA3 SAE support
      wifi: wilc1000: add IGTK support
      wifi: wilc1000: add WID_TX_POWER WID in g_cfg_byte array
      wifi: wilc1000: set correct value of 'close' variable in failure case
      wifi: wilc1000: set station_info flag only when signal value is valid
      wifi: wilc1000: get correct length of string WID from received config packet
      wifi: wilc1000: cancel the connect operation during interface down
      wifi: wilc1000: add 'isinit' flag for SDIO bus similar to SPI
      wifi: wilc1000: use existing iftype variable to store the interface type

Alaa Mohamed (1):
      selftests: net: fib_rule_tests: fix support for running individual tests

Alain Michaud (1):
      Bluetooth: clear the temporary linkkey in hci_conn_cleanup

Alan Brady (1):
      ping: support ipv6 ping socket flow labels

Alan Maguire (2):
      bpf: add a ksym BPF iterator
      selftests/bpf: add a ksym iter subtest

Alejandro Colomar (1):
      bpf, docs: Use SPDX license identifier in bpf_doc.py

Alex Elder (26):
      net: ipa: verify command channel TLV count
      net: ipa: rename channel->tlv_count
      net: ipa: rename endpoint->trans_tre_max
      net: ipa: simplify endpoint transaction completion
      net: ipa: determine channel from event
      net: ipa: derive channel from transaction
      net: ipa: use "tre_ring" for all TRE ring local variables
      net: ipa: rename two transaction fields
      net: ipa: introduce gsi_trans_tx_committed()
      net: ipa: simplify TX completion statistics
      net: ipa: stop counting total RX bytes and transactions
      net: ipa: rework gsi_channel_tx_update()
      net: ipa: don't assume one channel per event ring
      net: ipa: don't pass channel when mapping transaction
      net: ipa: pass GSI pointer to gsi_evt_ring_rx_update()
      net: ipa: call gsi_evt_ring_rx_update() unconditionally
      net: ipa: move more code out of gsi_channel_update()
      net: ipa: initialize ring indexes to 0
      net: ipa: add an endpoint device attribute group
      net: ipa: add a transaction committed list
      net: ipa: rearrange transaction initialization
      net: ipa: skip some cleanup for unused transactions
      net: ipa: report when the driver has been removed
      net: ipa: fix an outdated comment
      net: ipa: list supported IPA versions in the Makefile
      net: ipa: move configuration data files into a subdirectory

Alexander Aring (3):
      net: 6lowpan: remove const from scalars
      net: 6lowpan: use array for find nhc id
      net: 6lowpan: constify lowpan_nhc structures

Alexander Stein (1):
      dt-bindings: net: fsl,fec: Add nvmem-cells / nvmem-cell-names properties

Alexei Starovoitov (13):
      Merge branch 'bpf: Add 64bit enum value support'
      Merge branch 'Optimize performance of update hash-map when free is zero'
      Merge branch 'sleepable uprobe support'
      Merge branch 'New BPF helpers to accelerate synproxy'
      Merge branch 'bpf_loop inlining'
      Merge branch 'Align BPF TCP CCs implementing cong_control() with non-BPF CCs'
      Merge branch 'libbpf: remove deprecated APIs'
      Merge branch 'bpf: cgroup_sock lsm flavor'
      Merge branch 'bpf: add a ksym BPF iterator'
      bpf: Fix subprog names in stack traces.
      Merge branch 'Add SEC("ksyscall") support'
      Merge branch 'BPF array map fixes and improvements'
      Merge branch 'New nf_conntrack kfuncs for insertion, changing timeout, status'

Alexey Kodanev (1):
      wifi: iwlegacy: 4965: fix potential off-by-one overflow in il4965_rs_fill_link_cmd()

Aloka Dixit (1):
      wifi: nl80211: retrieve EHT related elements in AP mode

Alvin Šipraga (7):
      net: dsa: realtek: rtl8365mb: rename macro RTL8367RB -> RTL8367RB_VB
      net: dsa: realtek: rtl8365mb: remove port_mask private data member
      net: dsa: realtek: rtl8365mb: correct the max number of ports
      net: dsa: realtek: rtl8365mb: remove learn_limit_max private data member
      net: dsa: realtek: rtl8365mb: handle PHY interface modes correctly
      dt-bindings: bcm4329-fmac: add optional brcm,ccode-map-trivial
      wifi: brcmfmac: support brcm,ccode-map-trivial DT property

Amit Cohen (80):
      mlxsw: Trap ARP packets at layer 3 instead of layer 2
      selftests: mirror_gre_bridge_1q_lag: Enslave port to bridge before other configurations
      mlxsw: reg: Add 'flood_rsp' field to SFMR register
      mlxsw: reg: Add ingress RIF related fields to SFMR register
      mlxsw: reg: Add ingress RIF related fields to SVFA register
      mlxsw: reg: Add Switch Multicast Port to Egress VID Register
      mlxsw: Add SMPE related fields to SMID2 register
      mlxsw: reg: Add SMPE related fields to SFMR register
      mlxsw: reg: Add VID related fields to SFD register
      mlxsw: reg: Add flood related field to SFMR register
      mlxsw: reg: Replace MID related fields in SFGC register
      mlxsw: reg: Add Router Egress Interface to VID Register
      mlxsw: reg: Add egress FID field to RITR register
      mlxsw: Add support for egress FID classification after decapsulation
      mlxsw: reg: Add support for VLAN RIF as part of RITR register
      mlxsw: Remove lag_vid_valid indication
      mlxsw: spectrum_switchdev: Pass 'struct mlxsw_sp' to mlxsw_sp_bridge_mdb_mc_enable_sync()
      mlxsw: spectrum_switchdev: Do not set 'multicast_enabled' twice
      mlxsw: spectrum_switchdev: Simplify mlxsw_sp_port_mc_disabled_set()
      mlxsw: spectrum_switchdev: Add error path in mlxsw_sp_port_mc_disabled_set()
      mlxsw: spectrum_switchdev: Convert mlxsw_sp_mc_write_mdb_entry() to return int
      mlxsw: spectrum_switchdev: Handle error in mlxsw_sp_bridge_mdb_mc_enable_sync()
      mlxsw: Add enumerator for 'config_profile.flood_mode'
      mlxsw: cmd: Increase 'config_profile.flood_mode' length
      mlxsw: pci: Query resources before and after issuing 'CONFIG_PROFILE' command
      mlxsw: spectrum_fid: Save 'fid_offset' as part of FID structure
      mlxsw: spectrum_fid: Use 'fid->fid_offset' when setting VNI
      mlxsw: spectrum_fid: Implement missing operations for rFID and dummy FID
      mlxsw: spectrum_fid: Maintain {port, VID}->FID mappings
      mlxsw: spectrum_fid: Update FID structure prior to device configuration
      mlxsw: spectrum_fid: Rename mlxsw_sp_fid_vni_op()
      mlxsw: spectrum_fid: Pass FID structure to mlxsw_sp_fid_op()
      mlxsw: spectrum_fid: Pass FID structure to __mlxsw_sp_fid_port_vid_map()
      mlxsw: spectrum: Use different arrays of FID families per-ASIC type
      mlxsw: spectrum: Rename MLXSW_SP_RIF_TYPE_VLAN
      mlxsw: spectrum: Change mlxsw_sp_rif_vlan_fid_op() to be dedicated for FID RIFs
      mlxsw: spectrum: Add a temporary variable to indicate bridge model
      mlxsw: spectrum_fid: Configure flooding table type for rFID
      mlxsw: Prepare 'bridge_type' field for SFMR usage
      mlxsw: spectrum_fid: Store 'bridge_type' as part of FID family
      mlxsw: Set flood bridge type for FIDs
      mlxsw: spectrum_fid: Configure egress VID classification for multicast
      mlxsw: Add an initial PGT table support
      mlxsw: Add an indication of SMPE index validity for PGT table
      mlxsw: Add a dedicated structure for bitmap of ports
      mlxsw: Extend PGT APIs to support maintaining list of ports per entry
      mlxsw: spectrum: Initialize PGT table
      mlxsw: spectrum_fid: Set 'mid_base' as part of flood tables initialization
      mlxsw: spectrum_fid: Configure flooding entries using PGT APIs
      mlxsw: Align PGT index to legacy bridge model
      mlxsw: spectrum_switchdev: Rename MID structure
      mlxsw: spectrum_switchdev: Rename MIDs list
      mlxsw: spectrum_switchdev: Save MAC and FID as a key in 'struct mlxsw_sp_mdb_entry'
      mlxsw: spectrum_switchdev: Add support for maintaining hash table of MDB entries
      mlxsw: spectrum_switchdev: Add support for maintaining list of ports per MDB entry
      mlxsw: spectrum_switchdev: Implement mlxsw_sp_mc_mdb_entry_{init, fini}()
      mlxsw: spectrum_switchdev: Add support for getting and putting MDB entry
      mlxsw: spectrum_switchdev: Flush port from MDB entries according to FID index
      mlxsw: spectrum_switchdev: Convert MDB code to use PGT APIs
      mlxsw: Configure egress VID for unicast FDB entries
      mlxsw: spectrum_fid: Configure VNI to FID classification
      mlxsw: Configure ingress RIF classification
      mlxsw: spectrum_fid: Configure layer 3 egress VID classification
      mlxsw: spectrum_router: Do not configure VID for sub-port RIFs
      mlxsw: Configure egress FID classification after routing
      mlxsw: Add support for VLAN RIFs
      mlxsw: Add new FID families for unified bridge model
      mlxsw: Add support for 802.1Q FID family
      mlxsw: Add ubridge to config profile
      mlxsw: Enable unified bridge model
      mlxsw: spectrum_fid: Remove flood_index() from FID operation structure
      mlxsw: spectrum_fid: Remove '_ub_' indication from structures and defines
      mlxsw: resources: Add resource identifier for maximum number of FIDs
      mlxsw: spectrum_ptp: Initialize the clock to zero as part of initialization
      mlxsw: pci: Simplify FRC clock reading
      mlxsw: spectrum_ptp: Use 'struct mlxsw_sp_ptp_state' per ASIC
      mlxsw: spectrum_ptp: Use 'struct mlxsw_sp_ptp_clock' per ASIC
      mlxsw: spectrum_ptp: Rename mlxsw_sp_ptp_get_message_types()
      mlxsw: spectrum_ptp: Rename mlxsw_sp1_ptp_phc_adjfreq()
      mlxsw: spectrum_ptp: Add helper functions to configure PTP traps

Ammar Faizi (2):
      wifi: wil6210: debugfs: fix uninitialized variable use in `wil_write_file_wmi()`
      net: devlink: Fix missing mutex_unlock() call

Andrea Mayer (4):
      seg6: add support for SRv6 H.Encaps.Red behavior
      seg6: add support for SRv6 H.L2Encaps.Red behavior
      selftests: seg6: add selftest for SRv6 H.Encaps.Red behavior
      selftests: seg6: add selftest for SRv6 H.L2Encaps.Red behavior

Andrei Otcheretianski (14):
      wifi: mac80211_hwsim: Support link channel matching on rx
      wifi: mac80211: Consider MLO links in offchannel logic
      wifi: cfg80211: Allow MLO TX with link source address
      wifi: mac80211: Remove AP SMPS leftovers
      wifi: mac80211_hwsim: Ack link addressed frames
      wifi: nl80211: Support MLD parameters in nl80211_set_station()
      wifi: cfg80211/mac80211: Support control port TX from specific link
      wifi: mac80211: Allow EAPOL frames from link addresses
      wifi: mac80211: Allow EAPOL tx from specific link
      wifi: mac80211: don't check carrier in chanctx code
      wifi: mac80211: Support multi link in ieee80211_recalc_min_chandef()
      wifi: mac80211: select link when transmitting to non-MLO stations
      wifi: mac80211_hwsim: do rc update per link
      wifi: mac80211_hwsim: use MLO link ID for TX

Andrey Turkin (2):
      vmxnet3: Record queue number to incoming packets
      vmxnet3: Implement ethtool's get_channels command

Andrii Nakryiko (39):
      Merge branch 'libbpf: Textual representation of enums'
      libbpf: Fix uprobe symbol file offset calculation logic
      libbpf: Fix internal USDT address translation logic for shared libraries
      selftests/bpf: Don't force lld on non-x86 architectures
      Merge branch 'perf tools: Fix prologue generation'
      libbpf: move xsk.{c,h} into selftests/bpf
      libbpf: remove deprecated low-level APIs
      libbpf: remove deprecated XDP APIs
      libbpf: remove deprecated probing APIs
      libbpf: remove deprecated BTF APIs
      libbpf: clean up perfbuf APIs
      libbpf: remove prog_info_linear APIs
      libbpf: remove most other deprecated high-level APIs
      libbpf: remove multi-instance and custom private data APIs
      libbpf: cleanup LIBBPF_DEPRECATED_SINCE supporting macros for v0.x
      libbpf: remove internal multi-instance prog support
      libbpf: clean up SEC() handling
      selftests/bpf: remove last tests with legacy BPF map definitions
      libbpf: enforce strict libbpf 1.0 behaviors
      libbpf: fix up few libbpf.map problems
      libbpf: add bpf_core_type_matches() helper macro
      Merge branch 'Introduce type match support'
      Merge branch 'cleanup the legacy probe_event on failed scenario'
      selftests/bpf: Fix bogus uninitialized variable warning
      selftests/bpf: Fix few more compiler warnings
      libbpf: Remove unnecessary usdt_rel_ip assignments
      Merge branch 'Use lightweigt version of bpftool'
      libbpf: generalize virtual __kconfig externs and use it for USDT
      selftests/bpf: add test of __weak unknown virtual __kconfig extern
      libbpf: improve BPF_KPROBE_SYSCALL macro and rename it to BPF_KSYSCALL
      libbpf: add ksyscall/kretsyscall sections support for syscall kprobes
      selftests/bpf: use BPF_KSYSCALL and SEC("ksyscall") in selftests
      bpf: fix potential 32-bit overflow when accessing ARRAY map element
      bpf: make uniform use of array->elem_size everywhere in arraymap.c
      bpf: remove obsolete KMALLOC_MAX_SIZE restriction on array map value size
      selftests/bpf: validate .bss section bigger than 8MB is possible now
      libbpf: fallback to tracefs mount point if debugfs is not mounted
      libbpf: make RINGBUF map size adjustments more eagerly
      selftests/bpf: test eager BPF ringbuf size adjustment logic

Andy Gospodarek (1):
      samples/bpf: fixup some tools to be able to support xdp multibuffer

Andy Shevchenko (8):
      wifi: rtw88: use %*ph to print small buffer
      wifi: ray_cs: Utilize strnlen() in parse_addr()
      wifi: ray_cs: Drop useless status variable in parse_addr()
      ptp_ocp: use bits.h macros for all masks
      ptp_ocp: drop duplicate NULL check in ptp_ocp_detach()
      ptp_ocp: do not call pci_set_drvdata(pdev, NULL)
      ptp_ocp: replace kzalloc(x*y) by kcalloc(y, x)
      firewire: net: Make use of get_unaligned_be48(), put_unaligned_be48()

Anirudh Venkataramanan (1):
      ice: Add EXTTS feature to the feature bitmap

Anquan Wu (1):
      libbpf: Fix the name of a reused map

Antoine Tenart (1):
      Documentation: add a description for net.core.high_order_alloc_disable

Arun Ramadoss (52):
      net: dsa: microchip: ksz9477: cleanup the ksz9477_switch_detect
      net: dsa: microchip: move switch chip_id detection to ksz_common
      net: dsa: microchip: move tag_protocol to ksz_common
      net: dsa: microchip: ksz9477: use ksz_read_phy16 & ksz_write_phy16
      net: dsa: microchip: move vlan functionality to ksz_common
      net: dsa: microchip: move the port mirror to ksz_common
      net: dsa: microchip: get P_STP_CTRL in ksz_port_stp_state by ksz_dev_ops
      net: dsa: microchip: update the ksz_phylink_get_caps
      net: dsa: microchip: update the ksz_port_mdb_add/del
      net: dsa: microchip: update fdb add/del/dump in ksz_common
      net: dsa: microchip: move get_phy_flags & mtu to ksz_common
      net: dsa: microchip: rename shutdown to reset in ksz_dev_ops
      net: dsa: microchip: add config_cpu_port to struct ksz_dev_ops
      net: dsa: microchip: add the enable_stp_addr pointer in ksz_dev_ops
      net: dsa: microchip: move setup function to ksz_common
      net: dsa: microchip: move broadcast rate limit to ksz_setup
      net: dsa: microchip: move multicast enable to ksz_setup
      net: dsa: microchip: move start of switch to ksz_setup
      net: dsa: microchip: common dsa_switch_ops for ksz switches
      net: dsa: microchip: ksz9477: separate phylink mode from switch register
      net: dsa: microchip: common menuconfig for ksz series switch
      net: dsa: microchip: move ksz_dev_ops to ksz_common.c
      net: dsa: microchip: remove the ksz8/ksz9477_switch_register
      net: dsa: microchip: common ksz_spi_probe for ksz switches
      net: dsa: microchip: move ksz8->regs to ksz_common
      net: dsa: microchip: move ksz8->masks to ksz_common
      net: dsa: microchip: move ksz8->shifts to ksz_common
      net: dsa: microchip: remove the struct ksz8
      net: dsa: microchip: change the size of reg from u8 to u16
      net: dsa: microchip: add P_STP_CTRL to ksz_chip_reg
      net: dsa: microchip: move remaining register offset to ksz_chip_reg
      net: dsa: microchip: generic access to ksz9477 static and reserved table
      net: dsa: microchip: add DSA support for microchip LAN937x
      net: dsa: microchip: lan937x: add dsa_tag_protocol
      net: dsa: microchip: lan937x: add phy read and write support
      net: dsa: microchip: lan937x: register mdio-bus
      net: dsa: microchip: lan937x: add MTU and fast_age support
      net: dsa: microchip: lan937x: add phylink_get_caps support
      net: dsa: microchip: lan937x: add phylink_mac_link_up support
      net: dsa: microchip: lan937x: add phylink_mac_config support
      net: dsa: microchip: add LAN937x in the ksz spi probe
      net: dsa: microchip: fix Clang -Wunused-const-variable warning on 'ksz_dt_ids'
      net: dsa: microchip: fix the missing ksz8_r_mib_cnt
      net: dsa: microchip: add common gigabit set and get function
      net: dsa: microchip: add common ksz port xmii speed selection function
      net: dsa: microchip: add common duplex and flow control function
      net: dsa: microchip: add support for common phylink mac link up
      net: dsa: microchip: lan937x: add support for configuing xMII register
      net: dsa: microchip: apply rgmii tx and rx delay in phylink mac config
      net: dsa: microchip: ksz9477: use common xmii function
      net: dsa: microchip: ksz8795: use common xmii function
      net: dsa: microchip: add support for phylink mac config

Avinash Dayanand (1):
      iavf: Check for duplicate TC flower filter before parsing

Avraham Stern (6):
      wifi: ieee80211: add helper functions for detecting TM/FTM frames
      wifi: nl80211: add RX and TX timestamp attributes
      wifi: cfg80211: add a function for reporting TX status with hardware timestamps
      wifi: cfg80211/nl80211: move rx management data into a struct
      wifi: cfg80211: add hardware timestamps to frame RX info
      wifi: mac80211: add hardware timestamps for RX and TX

Aya Levin (2):
      net/mlx5: Expose ts_cqe_metadata_size2wqe_counter
      net/mlx5e: Add resiliency for PTP TX port timestamp

Bagas Sanjaya (1):
      Documentation: devlink: add add devlink-selftests to the table of contents

Baochen Qiang (1):
      ath11k: Fix warning on variable 'sar' dereference before check

Baowen Zheng (1):
      nfp: flower: add support for tunnel offload without key ID

Ben Dooks (3):
      bpf: Add endian modifiers to fix endian warnings
      bpf: Fix check against plain integer v 'NULL'
      net: macb: fixup sparse warnings on __be16 ports

Bernard Zhao (2):
      wifi: cw1200: cleanup the code a bit
      intel/i40e: delete if NULL check before dev_kfree_skb

Bhadram Varka (1):
      net: phy: Add support for AQR113C EPHY

Biao Huang (10):
      net: ethernet: mtk-star-emac: store bit_clk_div in compat structure
      net: ethernet: mtk-star-emac: modify IRQ trigger flags
      net: ethernet: mtk-star-emac: add support for MT8365 SoC
      dt-bindings: net: mtk-star-emac: add support for MT8365
      net: ethernet: mtk-star-emac: add clock pad selection for RMII
      net: ethernet: mtk-star-emac: add timing adjustment support
      dt-bindings: net: mtk-star-emac: add description for new properties
      net: ethernet: mtk-star-emac: add support for MII interface
      net: ethernet: mtk-star-emac: separate tx/rx handling with two NAPIs
      net: ethernet: mtk-star-emac: enable half duplex hardware support

Biju Das (5):
      dt-bindings: can: sja1000: Convert to json-schema
      dt-bindings: can: nxp,sja1000: Document RZ/N1{D,S} support
      can: sja1000: Add Quirk for RZ/N1 SJA1000 CAN controller
      can: sja1000: Use device_get_match_data to get device data
      can: sja1000: Change the return type as void for SoC specific init

Bill Wendling (1):
      netfilter: conntrack: use correct format characters

Bin Chen (2):
      ethernet: Remove vf rate limit check for drivers
      nfp: support VF rate limit with NFDK

Brian Gix (3):
      Bluetooth: Remove dead code from hci_request.c
      Bluetooth: Remove update_scan hci_request dependancy
      Bluetooth: Convert delayed discov_off to hci_sync

Bryan O'Donoghue (4):
      wifi: wcn36xx: Rename clunky firmware feature bit enum
      wifi: wcn36xx: Move firmware feature bit storage to dedicated firmware.c file
      wifi: wcn36xx: Move capability bitmap to string translation function to firmware.c
      wifi: wcn36xx: Add debugfs entry to read firmware feature strings

Casper Andersson (3):
      net: bridge: allow add/remove permanent mdb entries on disabled ports
      net: sparx5: Allow mdb entries to both CPU and ports
      selftest: net: bridge mdb add/del entry to port that is down

Chris Mi (4):
      net/mlx5: E-switch, Introduce flag to indicate if vport acl namespace is created
      net/mlx5: E-switch, Introduce flag to indicate if fdb table is created
      net/mlx5: E-switch, Remove dependency between sriov and eswitch mode
      net/mlx5: E-switch: Change eswitch mode only via devlink command

Christian Marangi (24):
      ath11k: fix missing skb drop on htc_tx_completion error
      net: ethernet: stmmac: add missing sgmii configure for ipq806x
      net: ethernet: stmmac: reset force speed bit for ipq806x
      net: ethernet: stmmac: remove select QCOM_SOCINFO and make it optional
      net: dsa: qca8k: move driver to qca dir
      net: ethernet: stmicro: stmmac: move queue reset to dedicated functions
      net: ethernet: stmicro: stmmac: first disable all queues and disconnect in release
      net: ethernet: stmicro: stmmac: move dma conf to dedicated struct
      net: ethernet: stmicro: stmmac: generate stmmac dma conf before open
      net: ethernet: stmicro: stmmac: permit MTU change with interface up
      net: dsa: qca8k: cache match data to speed up access
      net: dsa: qca8k: make mib autocast feature optional
      net: dsa: qca8k: move mib struct to common code
      net: dsa: qca8k: move qca8k read/write/rmw and reg table to common code
      net: dsa: qca8k: move qca8k bulk read/write helper to common code
      net: dsa: qca8k: move mib init function to common code
      net: dsa: qca8k: move port set status/eee/ethtool stats function to common code
      net: dsa: qca8k: move bridge functions to common code
      net: dsa: qca8k: move set age/MTU/port enable/disable functions to common code
      net: dsa: qca8k: move port FDB/MDB function to common code
      net: dsa: qca8k: move port mirror functions to common code
      net: dsa: qca8k: move port VLAN functions to common code
      net: dsa: qca8k: move port LAG functions to common code
      net: dsa: qca8k: move read_switch_id function to common code

Christophe JAILLET (23):
      net: altera: Replace kernel.h with the necessary inclusions
      net: dsa: microchip: ksz8xxx: Replace kernel.h with the necessary inclusions
      ice: Use correct order for the parameters of devm_kcalloc()
      nfp: Remove kernel.h when not needed
      hinic: Use the bitmap API when applicable
      cxgb4: Use the bitmap API to allocate bitmaps
      sfc/siena: Use the bitmap API to allocate bitmaps
      sfc: falcon: Use the bitmap API to allocate bitmaps
      bnxt: Use the bitmap API to allocate bitmaps
      cnic: Use the bitmap API to allocate bitmaps
      qed: Use the bitmap API to allocate bitmaps
      qed: Use bitmap_empty()
      wifi: mac80211: Use the bitmap API to allocate bitmaps
      net: dsa: hellcreek: Use the bitmap API to allocate bitmaps
      net/fq_impl: Use the bitmap API to allocate bitmaps
      atm: he: Use the bitmap API to allocate bitmaps
      net/mlx5: Use the bitmap API to allocate bitmaps
      wifi: p54: Fix an error handling path in p54spi_probe()
      wifi: p54: Use the bitmap API to allocate bitmaps
      netfilter: ipvs: Use the bitmap API to allocate bitmaps
      can: can327: fix a broken link to Documentation
      net: txgbe: Fix an error handling path in txgbe_probe()
      doc: sfp-phylink: Fix a broken reference

Chuang Wang (3):
      libbpf: Cleanup the legacy kprobe_event on failed add/attach_event()
      libbpf: Fix wrong variable used in perf_event_uprobe_open_legacy()
      libbpf: Cleanup the legacy uprobe_event on failed add/attach_event()

Ciara Loftus (1):
      i40e: read the XDP program once per NAPI

Claudiu Beznea (1):
      net: macb: change return type for gem_ptp_set_one_step_sync()

Clément Léger (18):
      net: dsa: allow port_bridge_join() to override extack message
      net: dsa: add support for ethtool get_rmon_stats()
      net: dsa: add Renesas RZ/N1 switch tag driver
      dt-bindings: net: pcs: add bindings for Renesas RZ/N1 MII converter
      net: pcs: add Renesas MII converter driver
      dt-bindings: net: dsa: add bindings for Renesas RZ/N1 Advanced 5 port switch
      net: dsa: rzn1-a5psw: add Renesas RZ/N1 advanced 5 port switch driver
      net: dsa: rzn1-a5psw: add statistics support
      net: dsa: rzn1-a5psw: add FDB support
      dt-bindings: net: snps,dwmac: add "power-domains" property
      dt-bindings: net: snps,dwmac: add "renesas,rzn1" compatible
      ARM: dts: r9a06g032: describe MII converter
      ARM: dts: r9a06g032: describe GMAC2
      ARM: dts: r9a06g032: describe switch
      ARM: dts: r9a06g032-rzn1d400-db: add switch description
      MAINTAINERS: add Renesas RZ/N1 switch related driver entry
      net: pcs: rzn1-miic: update speed only if interface is changed
      dt-bindings: net: dsa: renesas,rzn1-a5psw: add interrupts description

Colin Ian King (1):
      ipv6: remove redundant store to value after addition

Cong Wang (4):
      tcp: Introduce tcp_read_skb()
      net: Introduce a new proto_ops ->read_skb()
      skmsg: Get rid of skb_clone()
      skmsg: Get rid of unncessary memset()

Conor Dooley (7):
      dt-bindings: can: mpfs: document the mpfs CAN controller
      riscv: dts: microchip: add mpfs's CAN controllers
      dt-bindings: net: cdns,macb: document polarfire soc's macb
      net: macb: add polarfire soc reset support
      net: macb: unify macb_config alignment style
      net: macb: simplify error paths in init_reset_optional()
      net: macb: sort init_reset_optional() with other init()s

Dan Carpenter (14):
      wifi: rtlwifi: fix error codes in rtl_debugfs_set_write_h2c()
      net: lan743x: Use correct variable in lan743x_sgmii_config()
      net/mlx5: delete dead code in mlx5_esw_unlock()
      mt76: mt7915: fix endian bug in mt7915_rf_regval_set()
      wifi: wil6210: debugfs: fix info leak in wil_write_file_wmi()
      selftests/bpf: fix a test for snprintf() overflow
      libbpf: fix an snprintf() overflow check
      can: slcan: use scnprintf() as a hardening measure
      libbpf: Fix sign expansion bug in btf_dump_get_enum_value()
      libbpf: Fix str_has_sfx()'s return value
      Bluetooth: fix an error code in hci_register_dev()
      Bluetooth: clean up error pointer checking
      wifi: brcmfmac: use strreplace() in brcmf_of_probe()
      net: marvell: prestera: uninitialized variable bug

Daniel Müller (29):
      libbpf: Introduce libbpf_bpf_prog_type_str
      selftests/bpf: Add test for libbpf_bpf_prog_type_str
      bpftool: Use libbpf_bpf_prog_type_str
      libbpf: Introduce libbpf_bpf_map_type_str
      selftests/bpf: Add test for libbpf_bpf_map_type_str
      bpftool: Use libbpf_bpf_map_type_str
      libbpf: Introduce libbpf_bpf_attach_type_str
      selftests/bpf: Add test for libbpf_bpf_attach_type_str
      bpftool: Use libbpf_bpf_attach_type_str
      libbpf: Introduce libbpf_bpf_link_type_str
      selftests/bpf: Add test for libbpf_bpf_link_type_str
      bpftool: Use libbpf_bpf_link_type_str
      libbpf: Fix a couple of typos
      bpf: Merge "types_are_compat" logic into relo_core.c
      bpf: Introduce TYPE_MATCH related constants/macros
      bpftool: Honor BPF_CORE_TYPE_MATCHES relocation
      bpf, libbpf: Add type match support
      selftests/bpf: Add type-match checks to type-based tests
      selftests/bpf: Add test checking more characteristics
      selftests/bpf: Add nested type to type based tests
      selftests/bpf: Add type match test against kernel's task_struct
      bpftool: Add support for KIND_RESTRICT to gen min_core_btf command
      selftests/bpf: Add test involving restrict type qualifier
      bpf: Correctly propagate errors up from bpf_core_composites_match
      selftests/bpf: Sort configuration
      selftests/bpf: Copy over libbpf configs
      selftests/bpf: Adjust vmtest.sh to use local kernel configuration
      libbpf: Support PPC in arch_specific_syscall_pfx
      selftests/bpf: Bump internal send_signal/send_signal_tracepoint timeout

Daniel Xu (1):
      bpf, test_run: Remove unnecessary prog type checks

Danielle Ratson (16):
      mlxsw: Rename mlxsw_reg_mtptptp_pack() to mlxsw_reg_mtptpt_pack()
      mlxsw: reg: Add MTUTC register's fields for supporting PTP in Spectrum-2
      mlxsw: reg: Add Monitoring Time Precision Correction Port Configuration Register
      mlxsw: pci_hw: Add 'time_stamp' and 'time_stamp_type' fields to CQEv2
      mlxsw: cmd: Add UTC related fields to query firmware command
      mlxsw: Set time stamp type as part of config profile
      mlxsw: spectrum: Fix the shift of FID field in TX header
      mlxsw: Rename 'read_frc_capable' bit to 'read_clock_capable'
      mlxsw: Support CQEv2 for SDQ in Spectrum-2 and newer ASICs
      mlxsw: spectrum_ptp: Add PTP initialization / finalization for Spectrum-2
      mlxsw: Query UTC sec and nsec PCI offsets and values
      mlxsw: spectrum_ptp: Add implementation for physical hardware clock operations
      mlxsw: Send PTP packets as data packets to overcome a limitation
      mlxsw: spectrum: Support time stamping on Spectrum-2
      mlxsw: spectrum_ptp: Support SIOCGHWTSTAMP, SIOCSHWTSTAMP ioctls
      mlxsw: spectrum: Support ethtool 'get_ts_info' callback in Spectrum-2

Danny van Heumen (1):
      wifi: brcmfmac: prevent double-free on hardware-reset

Dario Binacchi (20):
      can: slcan: use the BIT() helper
      can: slcan: use netdev helpers to print out messages
      can: slcan: use the alloc_can_skb() helper
      can: netlink: dump bitrate 0 if can_priv::bittiming.bitrate is -1U
      can: slcan: use CAN network device driver API
      can: slcan: allow to send commands to the adapter
      can: slcan: set bitrate by CAN device driver API
      can: slcan: send the open/close commands to the adapter
      can: slcan: move driver into separate sub directory
      can: slcan: add ethtool support to reset adapter errors
      can: slcan: extend the protocol with error info
      can: slcan: extend the protocol with CAN state info
      can: slcan: do not sleep with a spin lock held
      can: c_can: remove wrong comment
      can: slcan: remove useless header inclusions
      can: slcan: remove legacy infrastructure
      can: slcan: change every `slc' occurrence in `slcan'
      can: slcan: use the generic can_change_mtu()
      can: slcan: add support for listen-only mode
      MAINTAINERS: Add maintainer for the slcan driver

Dave Marchevsky (2):
      selftests/bpf: Add benchmark for local_storage get
      selftests/bpf: Add benchmark for local_storage RCU Tasks Trace usage

David Lamparter (1):
      net: ip6mr: add RTM_GETROUTE netlink op

David S. Miller (60):
      Merge branch 'ipa-refactoring'
      Merge branch 'ipa-simplify-completion-stats'
      Merge branch 'tcp-mem-pressure-fixes'
      Merge branch 'mlxsw-L3-HW-stats-improvements'
      Merge branch 'pcs-xpcs-stmmac-add-1000BASE-X-AN-for-network-switch'
      tcp: fix build...
      Merge branch 'raw-RCU-conversion'
      Merge branch 'mii_bmcr_encode_fixed'
      Merge branch 'raw-rcu-fixes'
      Merge branch 'mlxsw-unified-bridge-conversion-part-1'
      Merge branch 'mlxsw-unified-bridge-conversion-part-2'
      Merge branch 'af_unix-per-netns-socket-hash'
      Merge branch 'bonding-per-port-priorities'
      Merge branch 'dsa-microchip-common-spi-probe'
      Merge branch 'ipmr-remove-rwlocks'
      Merge branch 'mlxsw-unified-bridge-conversion-part-3'
      Merge branch 'Renesas-rz-n1'
      Merge tag 'linux-can-next-for-5.20-20220625' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge branch 'mlxsw-unified-bridge-conversion-part-5'
      Merge branch 'sfc-add-extra-states-for-VDPA'
      Merge branch 'mtk-star-emac-features'
      Merge branch 'dsa-microchip-ksz_chip_reg'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/nex t-queue
      Merge branch 'mptcp-mem-scheduling'
      Merge branch 'lan8814-led'
      Merge branch 'lan937x-dsa-driver'
      Merge tag 'mlx5-updates-2022-06-29' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge tag 'linux-can-next-for-5.20-20220703' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge branch 'mlxsw-unified-bridge-conversion-part-6'
      Merge branch 'smsc95xx-deadlock'
      Merge branch 'nfp-vlan-strip-and-insert'
      Merge branch 'nfp-tso'
      Merge branch 'octeontx2-af-next'
      Merge branch 'tls-rx-nopad-and-backlog-flushing'
      Merge branch 'hinic-dev_get_stats-fixes'
      Merge branch 'mptcp-selftest-improvements-and-header-tweak'
      Merge branch 'prestera-mdb-offload'
      Merge branch 'prestera-port-range-filters'
      Merge branch 'devlink-cosmetic-fixes'
      Merge branch 'phy-mxl-gpy-version-fix-and-improvements'
      Merge tag 'wireless-next-2022-07-13' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
      Merge branch 'net-smc-virt-contig-buffers'
      Merge branch 'tls-rx-avoid-skb_cow_data'
      Merge tag 'linux-can-next-for-5.20-20220720' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge branch 'sfc-E100-VF-respresenters'
      Merge branch 'mtk_eth_soc-xdp'
      Merge branch 'macb-versal-device-support'
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next
      Merge branch 'mlxsw-Spectrum-2-PTP-preparations'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'dsa-microchip-phylink-mac-config'
      Merge branch 'smc-updates'
      Merge branch 'mlxsw-ptp-spectrum-2'
      Merge branch 'seg6-headend-reduced'
      Merge branch 'mtk_eth_soc-xdp-multi-frame'
      Merge branch 'netdevsim-fib-route-delete-leak'
      Merge tag 'linux-can-next-for-5.20-20220731' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next Marc Kleine-Budde says:
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'devlink-parallel-commands'
      Merge branch 'funeth-tx-xdp-frags'

David Thompson (1):
      mlxbf_gige: remove own module name define and use KBUILD_MODNAME instead

Davide Caratti (1):
      net/sched: remove qdisc_root_lock() helper

Delyan Kratunov (6):
      bpf: move bpf_prog to bpf.h
      bpf: implement sleepable uprobes by chaining gps
      bpf: allow sleepable uprobe programs to attach
      libbpf: add support for sleepable uprobe programs
      selftests/bpf: add tests for sleepable (uk)probes
      uprobe: gate bpf call behind BPF_EVENTS

Deming Wang (1):
      net: axienet: Modify function description

Deren Wu (9):
      mt76: add 6 GHz band support in mt76_sar_freq_ranges
      mt76: mt7921: introduce ACPI SAR support
      mt76: mt7921: introduce ACPI SAR config in tx power
      mt76: enable the VHT extended NSS BW feature
      mt76: mt7921: not support beacon offload disable command
      mt76: mt7921: fix command timeout in AP stop period
      mt76: mt7921s: fix possible sdio deadlock in command fail
      mt76: mt7921: fix aggregation subframes setting to HE max
      mt76: mt7921: enlarge maximum VHT MPDU length to 11454

Dexuan Cui (1):
      net: mana: Add the Linux MANA PF driver

Diana Wang (3):
      nfp: support RX VLAN ctag/stag strip
      nfp: support TX VLAN ctag insert
      nfp: support TX VLAN ctag insert in NFDK

Dimitris Michailidis (6):
      net/funeth: Support UDP segmentation offload
      net/funeth: Support for ethtool -m
      net/funeth: Unify skb/XDP Tx packet unmapping.
      net/funeth: Unify skb/XDP gather list writing.
      net/funeth: Unify skb/XDP packet mapping.
      net/funeth: Tx handling of XDP with fragments.

Divya Koppera (2):
      dt-bindings: net: Updated micrel,led-mode for LAN8814 PHY
      net: phy: micrel: Adding LED feature for LAN8814 PHY

Dominik Czerwik (1):
      net/cdc_ncm: Enable ZLP for DisplayLink ethernet devices

Donald Hunter (1):
      bpf, docs: document BPF_MAP_TYPE_HASH and variants

Douglas Raillard (1):
      libbpf: Fix determine_ptr_size() guessing

Eduard Zingerman (7):
      selftests/bpf: specify expected instructions in test_verifier tests
      selftests/bpf: allow BTF specs and func infos in test_verifier tests
      bpf: Inline calls to bpf_loop when callback is known
      selftests/bpf: BPF test_verifier selftests for bpf_loop inlining
      selftests/bpf: BPF test_prog selftests for bpf_loop inlining
      bpf: Fix for use-after-free bug in inline_bpf_loop
      selftest/bpf: Test for use-after-free bug fix in inline_bpf_loop

Edward Cree (20):
      sfc: update MCDI protocol headers
      sfc: update EF100 register descriptions
      sfc: detect ef100 MAE admin privilege/capability at probe time
      sfc: add skeleton ef100 VF representors
      sfc: add basic ethtool ops to ef100 reps
      sfc: phys port/switch identification for ef100 reps
      sfc: determine representee m-port for EF100 representors
      sfc: support passing a representor to the EF100 TX path
      sfc: hook up ef100 representor TX
      sfc: attach/detach EF100 representors along with their owning PF
      sfc: plumb ef100 representor stats
      sfc: ef100 representor RX NAPI poll
      sfc: ef100 representor RX top half
      sfc: determine wire m-port at EF100 PF probe time
      sfc: check ef100 RX packets are from the wire
      sfc: receive packets from EF100 VFs into representors
      sfc: insert default MAE rules to connect VFs to representors
      sfc: move table locking into filter_table_{probe,remove} methods
      sfc: use a dynamic m-port for representor RX and set it promisc
      sfc: implement ethtool get/set RX ring size for EF100 reps

Eric Dumazet (63):
      vlan: adopt u64_stats_t
      ipvlan: adopt u64_stats_t
      sit: use dev_sw_netstats_rx_add()
      ip6_tunnel: use dev_sw_netstats_rx_add()
      wireguard: receive: use dev_sw_netstats_rx_add()
      net: adopt u64_stats_t in struct pcpu_sw_netstats
      devlink: adopt u64_stats_t
      drop_monitor: adopt u64_stats_t
      team: adopt u64_stats_t
      net: use DEBUG_NET_WARN_ON_ONCE() in __release_sock()
      net: use DEBUG_NET_WARN_ON_ONCE() in dev_loopback_xmit()
      net: use WARN_ON_ONCE() in inet_sock_destruct()
      net: use WARN_ON_ONCE() in sk_stream_kill_queues()
      af_unix: use DEBUG_NET_WARN_ON_ONCE()
      net: use DEBUG_NET_WARN_ON_ONCE() in skb_release_head_state()
      net: add debug checks in napi_consume_skb and __napi_alloc_skb()
      net: add napi_get_frags_check() helper
      Revert "net: set SK_MEM_QUANTUM to 4096"
      net: remove SK_MEM_QUANTUM and SK_MEM_QUANTUM_SHIFT
      net: add per_cpu_fw_alloc field to struct proto
      net: implement per-cpu reserves for memory_allocated
      net: fix sk_wmem_schedule() and sk_rmem_schedule() errors
      net: keep sk->sk_forward_alloc as small as possible
      net: unexport __sk_mem_{raise|reduce}_allocated
      tcp: sk_forced_mem_schedule() optimization
      tcp: fix over estimation in sk_forced_mem_schedule()
      tcp: fix possible freeze in tx path under memory pressure
      tcp: fix possible freeze in tx path under memory pressure
      ping: convert to RCU lookups, get rid of rwlock
      raw: use more conventional iterators
      raw: convert raw sockets to RCU
      net: warn if mac header was not set
      raw: complete rcu conversion
      raw: remove unused variables from raw6_icmp_error()
      ip6mr: do not get a device reference in pim6_rcv()
      ipmr: add rcu protection over (struct vif_device)->dev
      ipmr: change igmpmsg_netlink_event() prototype
      ipmr: ipmr_cache_report() changes
      ipmr: do not acquire mrt_lock in __pim_rcv()
      ipmr: do not acquire mrt_lock in ioctl(SIOCGETVIFCNT)
      ipmr: do not acquire mrt_lock before calling ipmr_cache_unresolved()
      ipmr: do not acquire mrt_lock while calling ip_mr_forward()
      ipmr: do not acquire mrt_lock in ipmr_get_route()
      ip6mr: ip6mr_cache_report() changes
      ip6mr: do not acquire mrt_lock in pim6_rcv()
      ip6mr: do not acquire mrt_lock in ioctl(SIOCGETMIFCNT_IN6)
      ip6mr: do not acquire mrt_lock before calling ip6mr_cache_unresolved
      ip6mr: do not acquire mrt_lock while calling ip6_mr_forward()
      ip6mr: switch ip6mr_get_route() to rcu_read_lock()
      ipmr: adopt rcu_read_lock() in mr_dump()
      ipmr: convert /proc handlers to rcu_read_lock()
      ipmr: convert mrt_lock to a spinlock
      ip6mr: convert mrt_lock to a spinlock
      raw: fix a typo in raw_icmp_error()
      ipmr: fix a lockdep splat in ipmr_rtm_dumplink()
      tcp: diag: add support for TIME_WAIT sockets to tcp_abort()
      net: add skb_[inner_]tcp_all_headers helpers
      net: minor optimization in __alloc_skb()
      af_unix: fix unix_sysctl_register() error path
      ip6mr: remove stray rcu_read_unlock() from ip6_mr_forward()
      ax25: fix incorrect dev_tracker usage
      net: rose: fix netdev reference changes
      net: rose: add netdev ref tracker to 'struct rose_sock'

Eric Huang (1):
      rtw89: add new state to CFO state machine for UL-OFDMA

Eyal Birger (1):
      xfrm: no need to set DST_NOPOLICY in IPv4

Fedor Tokarev (1):
      bpf: btf: Fix vsnprintf return value check

Fei Qin (1):
      nfp: add support for 'ethtool -t DEVNAME' command

Felix Fietkau (18):
      wifi: mac80211: switch airtime fairness back to deficit round-robin scheduling
      wifi: mac80211: make sta airtime deficit field s32 instead of s64
      wifi: mac80211: consider aql_tx_pending when checking airtime deficit
      wifi: mac80211: keep recently active tx queues in scheduling list
      wifi: mac80211: add a per-PHY AQL limit to improve fairness
      wifi: mac80211: add debugfs file to display per-phy AQL pending airtime
      wifi: mac80211: only accumulate airtime deficit for active clients
      mt76: mt7915: add missing bh-disable around tx napi enable/schedule
      mt76: mt7615: add missing bh-disable around rx napi schedule
      mt76: mt7915: disable UL MU-MIMO for mt7915
      mt76: mt7615: add sta_rec with EXTRA_INFO_NEW for the first time only
      mt76: mt76x02: improve reliability of the beacon hang check
      mt76: allow receiving frames with invalid CCMP PN via monitor interfaces
      mt76: mt7615: fix throughput regression on DFS channels
      mt76: pass original queue id from __mt76_tx_queue_skb to the driver
      mt76: do not use skb_set_queue_mapping for internal purposes
      mt76: remove q->qid
      wifi: mac80211: exclude multicast packets from AQL pending airtime

Feng Zhou (2):
      bpf: avoid grabbing spin_locks of all cpus when no free elems
      selftest/bpf/benchs: Add bpf_map benchmark

Florian Westphal (10):
      netfilter: nf_conntrack: add missing __rcu annotations
      netfilter: nf_conntrack: use rcu accessors where needed
      netfilter: h323: merge nat hook pointers into one
      netfilter: nfnetlink: add missing __be16 cast
      netfilter: x_tables: use correct integer types
      netfilter: nf_tables: use the correct get/put helpers
      netfilter: nf_tables: add and use BE register load-store helpers
      netfilter: nf_tables: use correct integer types
      netfilter: nf_tables: move nft_cmp_fast_mask to where its used
      netfilter: flowtable: prefer refcount_inc

Frank Jungclaus (5):
      can/esd_usb2: Rename esd_usb2.c to esd_usb.c
      can/esd_usb: Add an entry to the MAINTAINERS file
      can/esd_usb: Rename all terms USB2 to USB
      can/esd_usb: Fixed some checkpatch.pl warnings
      can/esd_usb: Update to copyright, M_AUTHOR and M_DESCRIPTION

Frank Wunderlich (6):
      dt-bindings: net: dsa: convert binding for mediatek switches
      net: dsa: mt7530: rework mt7530_hw_vlan_{add,del}
      net: dsa: mt7530: rework mt753[01]_setup
      net: dsa: mt7530: get cpu-port via dp->cpu_dp instead of constant
      dt-bindings: net: dsa: make reset optional and add rgmii-mode to mt7531
      arm64: dts: rockchip: Add mt7531 dsa node to BPI-R2-Pro board

Gal Pressman (3):
      net/mlx5e: Report header-data split state through ethtool
      net/mlx5e: Remove WARN_ON when trying to offload an unsupported TLS cipher/version
      net/mlx5e: Fix wrong use of skb_tcp_all_headers() with encapsulation

Geliang Tang (5):
      mptcp: move MPTCPOPT_HMAC_LEN to net/mptcp.h
      selftests: mptcp: userspace pm address tests
      selftests: mptcp: userspace pm subflow tests
      selftests: mptcp: avoid Terminated messages in userspace_pm
      selftests: mptcp: update pm_nl_ctl usage header

Gregory Greenman (4):
      wifi: mac80211: replace link_id with link_conf in start/stop_ap()
      wifi: mac80211: replace link_id with link_conf in switch/(un)assign_vif_chanctx()
      wifi: mac80211: remove link_id parameter from link_info_changed()
      wifi: mac80211: add macros to loop over active links

Guangguan Wang (2):
      net/smc: remove redundant dma sync ops
      net/smc: optimize for smc_sndbuf_sync_sg_for_device and smc_rmb_sync_sg_for_cpu

Guillaume Nault (1):
      Documentation: Describe net.ipv4.tcp_reflect_tos.

Guo Zhengkui (2):
      ath5k: replace ternary operator with min()
      ath9k: replace ternary operator with max()

Haiyang Zhang (1):
      net: mana: Add support of XDP_REDIRECT action

Hakan Jansson (7):
      dt-bindings: net: broadcom-bluetooth: Add property for autobaud mode
      Bluetooth: hci_bcm: Add support for FW loading in autobaud mode
      dt-bindings: net: broadcom-bluetooth: Add CYW55572 DT binding
      dt-bindings: net: broadcom-bluetooth: Add conditional constraints
      Bluetooth: hci_bcm: Add DT compatible for CYW55572
      Bluetooth: hci_bcm: Prevent early baudrate setting in autobaud mode
      Bluetooth: hci_bcm: Increase host baudrate for CYW55572 in autobaud mode

Hangbin Liu (3):
      selftests/bpf: Add drv mode testing for xdping
      bonding: add slave_dev field for bond_opt_value
      Bonding: add per-port priority for failover re-selection

Hangyu Hua (2):
      wifi: libertas: Fix possible refcount leak in if_usb_probe()
      dccp: put dccp_qpolicy_full() and dccp_qpolicy_push() in the same lock

Hans de Goede (2):
      wifi: brcmfmac: Add brcmf_c_set_cur_etheraddr() helper
      wifi: brcmfmac: Replace default (not configured) MAC with a random MAC

Harini Katakam (2):
      net: macb: Sort CAPS flags by bit positions
      net: macb: Update tsu clk usage in runtime suspend/resume for Versal

Hariprasad Kelam (3):
      octeontx2-af: Don't reset previous pfc config
      octeontx2-af: Skip CGX/RPM probe incase of zero lmac count
      octeontx2-af: Limit link bringup time at firmware

He Wang (1):
      Bluetooth: btusb: Add a new VID/PID 0489/e0e2 for MT7922

Hector Martin (1):
      net: usb: ax88179_178a: Bind only to vendor-specific interface

Heiko Carstens (1):
      net/smc: Eliminate struct smc_ism_position

Hengqi Chen (1):
      libbpf: Error out when binary_path is NULL for uprobe and USDT

Hilda Wu (5):
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x04CA:0x4007
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x04C5:0x1675
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x0CB8:0xC558
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x13D3:0x3587
      Bluetooth: btusb: Add Realtek RTL8852C support ID 0x13D3:0x3586

Hoang Le (1):
      tipc: cleanup unused function

Hongyi Lu (1):
      bpf: Fix spelling in bpf_verifier.h

Ido Schimmel (5):
      selftests: mlxsw: resource_scale: Update scale target after test setup
      selftests: spectrum-2: tc_flower_scale: Dynamically set scale target
      netdevsim: fib: Fix reference count leak on route deletion failure
      netdevsim: fib: Add debugfs knob to simulate route deletion failure
      selftests: netdevsim: Add test cases for route deletion failure

Ilan Peer (3):
      wifi: mac80211: Align with Draft P802.11be_D1.5
      wifi: mac80211: Align with Draft P802.11be_D2.0
      wifi: nl80211: allow link ID in set_wiphy with frequency

Ilya Leoshkevich (2):
      libbpf: Extend BPF_KSYSCALL documentation
      selftests/bpf: Attach to socketcall() in test_probe_user

Indu Bhagat (1):
      docs/bpf: Update documentation for BTF_KIND_FUNC

Ioana Ciornei (4):
      dt-bindings: net: convert sff,sfp to dtschema
      dt-bindings: net: sff,sfp: rename example dt nodes to be more generic
      arch: arm64: dts: lx2160a-clearfog-itx: rename the sfp GPIO properties
      arch: arm64: dts: marvell: rename the sfp GPIO properties

Ivan Bornyakov (1):
      net: phy: marvell-88x2222: set proper phydev->port

Jackie Liu (1):
      netfilter: conntrack: use fallthrough to cleanup

Jacob Keller (7):
      ice: implement adjfine with mul_u64_u64_div_u64
      e1000e: remove unnecessary range check in e1000e_phc_adjfreq
      e1000e: convert .adjfreq to .adjfine
      i40e: use mul_u64_u64_div_u64 for PTP frequency calculation
      i40e: convert .adjfreq to .adjfine
      ixgbe: convert .adjfreq to .adjfine
      igb: convert .adjfreq to .adjfine

Jaehee Park (4):
      net: ipv4: new arp_accept option to accept garp only if in-network
      net: ipv6: new accept_untracked_na option to accept na only if in-network
      selftests: net: arp_ndisc_untracked_subnets: test for arp_accept and accept_untracked_na
      net: ipv6: avoid accepting values greater than 2 for accept_untracked_na

Jakub Kicinski (130):
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      net: rename reference+tracking helpers
      Merge branch 'net-adopt-u64_stats_t-type'
      Merge branch 'net-few-debug-refinements'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'bonding-netlink-errors-and-cleanup'
      Merge tag 'ieee802154-for-net-next-2022-06-09' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan-next
      Merge branch 'ptp_ocp-set-of-small-cleanups'
      Merge tag 'wireless-next-2022-06-10' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'net-reduce-tcp_memory_allocated-inflation'
      Merge branch '10GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      docs: tls: document the TLS_TX_ZEROCOPY_RO
      Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux
      Merge branch 'mlxsw-remove-xm-support'
      Merge branch 'support-mt7531-on-bpi-r2-pro'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'dt-bindings-dp83867-add-binding-for-io_impedance_ctrl-nvmem-cell'
      Merge branch 'net-ipa-more-multi-channel-event-ring-work'
      Merge branch 'net-dsa-realtek-rtl8365mb-improve-handling-of-phy-modes'
      Merge branch 'net-lan743x-pci11010-pci11414-devices-enhancements'
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'net-dsa-mv88e6xxx-get-rid-of-speed_max'
      Merge branch 'broadcom-ptp-phy-support'
      Merge branch 'net-use-new-hwmon_sanitize_name'
      Merge branch 'net-pcs-lynx-consolidate-gigabit-code'
      net: pcs: xpcs: depends on PHYLINK in Kconfig
      Merge branch 'nfp-add-vepa-and-adapter-selftest-support'
      Merge branch 'net-phylink-cleanup-pcs-code'
      Revert the ARM/dts changes for Renesas RZ/N1
      Merge branch 'net-dsa-add-pause-stats-support'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'prevent-permanently-closed-tc-taprio-gates-from-blocking-a-felix-dsa-switch-port'
      eth: remove neterion/vxge
      tls: rx: don't include tail size in data_len
      tls: rx: support optimistic decrypt to user buffer with TLS 1.3
      tls: rx: add sockopt for enabling optimistic decrypt with TLS 1.3
      selftests: tls: add selftest variant for pad
      tls: rx: periodically flush socket backlog
      Revert "Merge branch 'octeontx2-af-next'"
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'polarfire-soc-macb-reset-support'
      eth: mtk: switch to netif_napi_add_tx()
      eth: sp7021: switch to netif_napi_add_tx()
      strparser: pad sk_skb_cb to avoid straddling cachelines
      tls: rx: always allocate max possible aad size for decrypt
      tls: rx: wrap decrypt params in a struct
      tls: rx: coalesce exit paths in tls_decrypt_sg()
      tls: create an internal header
      tls: rx: make tls_wait_data() return an recvmsg retcode
      Merge branch 'tls-pad-strparser-internal-header-decrypt_ctx-etc'
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge branch 'octeontx2-exact-match-table'
      tls: fix spelling of MIB
      tls: rx: add counter for NoPad violations
      tls: rx: fix the NoPad getsockopt
      selftests: tls: add test for NoPad getsockopt
      Merge branch 'tls-rx-follow-ups-to-nopad'
      Merge branch 'dt-bindings-net-convert-sff-sfp-to-dtschema'
      Merge branch 'mptcp-support-changes-to-initial-subflow-priority'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'net-devlink-couple-of-trivial-fixes'
      Merge tag 'mlx5-updates-2022-07-13' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'net-ipv4-ipv6-new-option-to-accept-garp-untracked-na-only-if-in-network'
      tls: rx: allow only one reader at a time
      tls: rx: don't try to keep the skbs always on the list
      tls: rx: don't keep decrypted skbs on ctx->recv_pkt
      tls: rx: remove the message decrypted tracking
      tls: rx: factor out device darg update
      tls: rx: read the input skb from ctx->recv_pkt
      tls: rx: return the decrypted skb via darg
      tls: rx: async: adjust record geometry immediately
      tls: rx: async: hold onto the input skb
      tls: rx: async: don't put async zc on the list
      tls: rx: decrypt into a fresh skb
      Merge branch 'devlink-prepare-mlxsw-and-netdevsim-for-locked-reload'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'io_uring-zerocopy-send' of git://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge tag 'mlx5-updates-2022-07-17' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next
      Merge branch 'net-ipa-small-transaction-updates'
      Merge branch 'net-ipa-move-configuration-data-files'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge tag 'linux-can-next-for-5.20-20220721' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      tls: rx: release the sock lock on locking timeout
      selftests: tls: add a test for timeo vs lock
      net: add missing includes and forward declarations under net/
      Merge branch 'io_uring-zerocopy-send' of git://git.kernel.org/pub/scm/linux/kernel/git/kuba/linux
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge tag 'for-net-next-2022-07-22' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next
      Merge branch 'net-usb-ax88179_178a-improvements-and-bug-fixes'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge tag 'wireless-next-2022-07-25' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
      Merge branch 'add-mtu-change-with-stmmac-interface-running'
      Merge branch 'implement-dev-info-and-dev-flash-for-line-cards'
      tls: rx: wrap recv_pkt accesses in helpers
      tls: rx: factor SW handling out of tls_rx_one_record()
      tls: rx: don't free the output in case of zero-copy
      tls: rx: device: keep the zero copy status with offload
      tcp: allow tls to decrypt directly from the tcp rcv queue
      tls: rx: device: add input CoW helper
      tls: rx: do not use the standard strparser
      Merge branch 'tls-rx-decrypt-from-the-tcp-queue'
      add missing includes and forward declarations to networking includes under linux/
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      selftests: tls: handful of memrnd() and length checks
      tls: rx: don't consider sock_rcvtimeo() cumulative
      tls: strp: rename and multithread the workqueue
      tls: rx: fix the false positive warning
      Merge branch 'tls-rx-follow-ups-to-rx-work'
      Merge branch 'mlx5e-use-tls-tx-pool-to-improve-connection-rate'
      Merge branch 'add-framework-for-selftests-in-devlink'
      Merge branch 'take-devlink-lock-on-mlx4-and-mlx5-callbacks'
      Merge branch 'net-dsa-qca8k-code-split-for-qca8k'
      netdevsim: Avoid allocation warnings triggered from user space
      Merge https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge tag 'wireless-next-2022-07-29' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next
      Merge branch 'sfc-vf-representors-for-ef100-rx-side'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge tag 'mlx5-fixes-2022-07-28' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge tag 'mlx5-updates-2022-07-28' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'net-rose-fix-module-unload-issues'
      Merge branch 'net-fix-using-wrong-flags-to-check-features'
      Merge branch 'wireguard-patches-for-5-20-rc1'

Jakub Sitnicki (1):
      bpf, arm64: Keep tail call count across bpf2bpf calls

James Hilliard (1):
      libbpf: Disable SEC pragma macro on GCC

James Yonan (1):
      netfilter: nf_nat: in nf_nat_initialized(), use const struct nf_conn *

Jan Beulich (2):
      xen-netfront: remove leftover call to xennet_tx_buf_gc()
      xen-netfront: re-order error checks in xennet_get_responses()

Jason A. Donenfeld (3):
      wireguard: ratelimiter: use hrtimer in selftest
      wireguard: allowedips: don't corrupt stack when detecting overflow
      wireguard: selftests: support UML

Jason Wang (1):
      wifi: mwifiex: Fix comment typo

Jeongik Cha (1):
      wifi: mac80211_hwsim: fix race condition in pending packet

Jesper Dangaard Brouer (1):
      samples/bpf: Fix xdp_redirect_map egress devmap prog

Jesse Brandeburg (1):
      intel: remove unused macros

Jian Shen (4):
      test_bpf: fix incorrect netdev features
      net: amd8111e: remove repeated dev->features assignement
      net: ice: fix error NETIF_F_HW_VLAN_CTAG_FILTER check in ice_vsi_sync_fltr()
      net: ionic: fix error check for vlan flags in ionic_set_nic_features()

Jianbo Liu (12):
      net/mlx5: Add IFC bits and enums for flow meter
      net/mlx5: Add support EXECUTE_ASO action for flow entry
      net/mlx5: Add support to create SQ and CQ for ASO
      net/mlx5: Implement interfaces to control ASO SQ and CQ
      net/mlx5e: Prepare for flow meter offload if hardware supports it
      net/mlx5e: Add support to modify hardware flow meter parameters
      net/mlx5e: Get or put meter by the index of tc police action
      net/mlx5e: Add generic macros to use metadata register mapping
      net/mlx5e: Add post meter table for flow metering
      net/mlx5e: Add flow_action to parse state
      net/mlx5e: TC, Support offloading police action
      net/mlx5e: configure meter in flow action

Jiang Jian (10):
      cxgb4vf: remove unexpected word "the"
      net: ipa: remove unexpected word "the"
      isdn: mISDN: hfcsusb: drop unexpected word "the" in the comments
      bnxt: Fix typo in comments
      cxgb4/cxgb4vf: Fix typo in comments
      ixgbe: remove unexpected word "the"
      fm10k: remove unexpected word "the"
      igb: remove unexpected word "the"
      ixgbe: drop unexpected word 'for' in comments
      ath9k: remove unexpected words "the" in comments

Jiapeng Chong (1):
      octeontx2-af: Remove duplicate include

Jiaqing Zhao (3):
      e1000: Fix typos in comments
      ixgb: Fix typos in comments
      ixgbe: Fix typos in comments

Jiasheng Jiang (1):
      Bluetooth: hci_intel: Add check for platform_driver_register

Jiawen Wu (1):
      net: txgbe: Add build support for txgbe

Jie Wang (1):
      net: page_pool: optimize page pool page allocation in NUMA scenario

Jie2x Zhou (1):
      bpf/selftests: Fix couldn't retrieve pinned program in xdp veth test

Jilin Yuan (51):
      sfc: siena: fix repeated words in comments
      sfc: fix repeated words in comments
      sfc:falcon: fix repeated words in comments
      agere: fix repeated words in comments
      amd/xgbe: fix repeated words in comments
      net: atlantic:fix repeated words in comments
      atheros/atl1c:fix repeated words in comments
      intel/e1000:fix repeated words in comments
      intel/e1000e:fix repeated words in comments
      intel/fm10k:fix repeated words in comments
      intel/i40e:fix repeated words in comments
      intel/iavf:fix repeated words in comments
      intel/igb:fix repeated words in comments
      intel/igbvf:fix repeated words in comments
      intel/igc:fix repeated words in comments
      intel/ixgbevf:fix repeated words in comments
      intel/ice:fix repeated words in comments
      atheros/atl1e:fix repeated words in comments
      ethernet/emulex:fix repeated words in comments
      freescale/fs_enet:fix repeated words in comments
      google/gve:fix repeated words in comments
      hisilicon/hns3/hns3vf:fix repeated words in comments
      marvell/octeontx2/af: fix repeated words in comments
      ethernet/marvell: fix repeated words in comments
      mellanox/mlxsw: fix repeated words in comments
      ethernet/natsemi: fix repeated words in comments
      ethernet/neterion: fix repeated words in comments
      neterion/vxge: fix repeated words in comments
      ethernet/sun: fix repeated words in comments
      stmicro/stmmac: fix repeated words in comments
      samsung/sxgbe: fix repeated words in comments
      qlogic/qed: fix repeated words in comments
      ethernet/via: fix repeated words in comments
      fddi/skfp: fix repeated words in comments
      wifi: ath5k: fix repeated words in comments
      wifi: ath6kl: fix repeated words in comments
      wifi: ath: fix repeated words in comments
      wifi: wil6210: fix repeated words in comments
      wifi: wcn36xx: fix repeated words in comments
      wifi: atmel: fix repeated words in comments
      wifi: b43: fix repeated words in comments
      wifi: brcmfmac: fix repeated words in comments
      wifi: brcmsmac: fix repeated words in comments
      wifi: ipw2x00: fix repeated words in comments
      wifi: iwlegacy: fix repeated words in comments
      wifi: qtnfmac: fix repeated words in comments
      wifi: rt2x00: fix repeated words in comments
      wifi: rtlwifi: fix repeated words in comments
      wifi: rtl8192se: fix repeated words in comments
      wifi: rsi: fix repeated words in comments
      wifi: wl1251: fix repeated words in comments

Jiri Olsa (3):
      perf tools: Rework prologue generation code
      selftests/bpf: Do not attach kprobe_multi bench to bpf_dispatcher_xdp_func
      bpf, x64: Allow to use caller address from stack

Jiri Pirko (34):
      net: devlink: fix unlocked vs locked functions descriptions
      net: devlink: use helpers to work with devlink->lock mutex
      net: devlink: move unlocked function prototypes alongside the locked ones
      net: devlink: make devlink_dpipe_headers_register() return void
      net: devlink: fix a typo in function name devlink_port_new_notifiy()
      net: devlink: fix return statement in devlink_port_new_notify()
      net: devlink: add unlocked variants of devling_trap*() functions
      net: devlink: add unlocked variants of devlink_resource*() functions
      net: devlink: add unlocked variants of devlink_sb*() functions
      net: devlink: add unlocked variants of devlink_dpipe*() functions
      mlxsw: convert driver to use unlocked devlink API during init/fini
      net: devlink: add unlocked variants of devlink_region_create/destroy() functions
      netdevsim: convert driver to use unlocked devlink API during init/fini
      net: devlink: remove unused locked functions
      mlxsw: core: Fix use-after-free calling devl_unlock() in mlxsw_core_bus_device_unregister()
      net: devlink: make sure that devlink_try_get() works with valid pointer during xarray iteration
      net: devlink: move net check into devlinks_xa_for_each_registered_get()
      net: devlink: introduce nested devlink entity for line card
      mlxsw: core_linecards: Introduce per line card auxiliary device
      mlxsw: core_linecards: Expose HW revision and INI version
      mlxsw: reg: Extend MDDQ by device_info
      mlxsw: core_linecards: Probe active line cards for devices and expose FW version
      mlxsw: reg: Add Management DownStream Device Tunneling Register
      mlxsw: core_linecards: Expose device PSID over device info
      mlxsw: core_linecards: Implement line card device flashing
      selftests: mlxsw: Check line card info on provisioned line card
      selftests: mlxsw: Check line card info on activated line card
      net: devlink: remove redundant net_eq() check from sb_pool_get_dumpit()
      net: devlink: remove region snapshot ID tracking dependency on devlink->lock
      net: devlink: remove region snapshots list dependency on devlink->lock
      net: devlink: introduce "unregistering" mark and use it during devlinks iteration
      net: devlink: convert reload command to take implicit devlink->lock
      net: devlink: remove devlink_mutex
      net: devlink: enable parallel ops on netlink interface

Joanne Koong (4):
      bpf: Fix non-static bpf_func_proto struct definitions
      bpf: Tidy up verifier check_func_arg()
      bpf: fix bpf_skb_pull_data documentation
      bpf: Fix bpf_xdp_pointer return pointer

Joe Burton (1):
      libbpf: Add bpf_obj_get_opts()

Johan Hovold (2):
      ath11k: fix netdev open race
      ath11k: fix IRQ affinity warning on shutdown

Johannes Berg (170):
      wifi: mac80211: remove cipher scheme support
      wifi: mac80211: refactor some key code
      wifi: mac80211: reject WEP or pairwise keys with key ID > 3
      wifi: cfg80211: do some rework towards MLO link APIs
      wifi: mac80211: move some future per-link data to bss_conf
      wifi: mac80211: move interface config to new struct
      wifi: mac80211: reorg some iface data structs for MLD
      wifi: mac80211: split bss_info_changed method
      wifi: mac80211: add per-link configuration pointer
      wifi: mac80211: pass link ID where already present
      wifi: mac80211: make channel context code MLO-aware
      wifi: mac80211: remove sta_info_tx_streams()
      wifi: mac80211: refactor some sta_info link handling
      wifi: mac80211: use IEEE80211_MLD_MAX_NUM_LINKS
      wifi: mac80211: validate some driver features for MLO
      wifi: mac80211: refactor some link setup code
      wifi: mac80211: add link_id to vht.c code for MLO
      wifi: mac80211: add link_id to eht.c code for MLO
      wifi: mac80211: HT: make ieee80211_ht_cap_ie_to_sta_ht_cap() MLO-aware
      wifi: mac80211: make some SMPS code MLD-aware
      wifi: mac80211: make ieee80211_he_cap_ie_to_sta_he_cap() MLO-aware
      wifi: mac80211: correct link config data in tracing
      wifi: mac80211: sort trace.h file
      wifi: mac80211: status: look up band only where needed
      wifi: mac80211: tx: simplify chanctx_conf handling
      wifi: cfg80211: mlme: get BSS entry outside cfg80211_mlme_assoc()
      wifi: nl80211: refactor BSS lookup in nl80211_associate()
      wifi: ieee80211: add definitions for multi-link element
      wifi: cfg80211: simplify cfg80211_mlme_auth() prototype
      wifi: mac80211: ignore IEEE80211_CONF_CHANGE_SMPS in chanctx mode
      wifi: nl80211: support MLO in auth/assoc
      wifi: mac80211: add vif link addition/removal
      wifi: mac80211: remove band from TX info in MLO
      wifi: mac80211: add MLO link ID to TX frame metadata
      wifi: mac80211: add sta link addition/removal
      wifi: cfg80211: sort trace.h
      wifi: cfg80211: add optional link add/remove callbacks
      wifi: mac80211: implement add/del interface link callbacks
      wifi: mac80211: move ieee80211_bssid_match() function
      wifi: mac80211: ethtool: use deflink for now
      wifi: mac80211: RCU-ify link STA pointers
      wifi: mac80211: maintain link-sta hash table
      wifi: mac80211: set STA deflink addresses
      wifi: nl80211: expose link information for interfaces
      wifi: nl80211: expose link ID for associated BSSes
      wifi: mac80211_hwsim: support creating MLO-capable radios
      wifi: cfg80211: remove redundant documentation
      wifi: mac80211: fix a kernel-doc complaint
      wifi: mac80211: properly skip link info driver update
      wifi: cfg80211: handle IBSS in channel switch
      wifi: nl80211: hold wdev mutex for tid config
      wifi: nl80211: acquire wdev mutex earlier in start_ap
      wifi: nl80211: relax wdev mutex check in wdev_chandef()
      wifi: cfg80211: remove chandef check in cfg80211_cac_event()
      wifi: mac80211_hwsim: add back erroneously removed cast
      wifi: rsi: remove unused variable
      wifi: mac80211_hwsim: use 32-bit skb cookie
      wifi: mac80211: consistently use sdata_dereference()
      wifi: mac80211: rx: accept link-addressed frames
      wifi: nl80211: hold wdev mutex in add/mod/del link station
      wifi: nl80211: hold wdev mutex for channel switch APIs
      wifi: nl80211: hold wdev mutex for station APIs
      wifi: mac80211: RCU-ify link/link_conf pointers
      wifi: cfg80211: make cfg80211_auth_request::key_idx signed
      wifi: cfg80211: drop BSS elements from assoc trace for now
      wifi: mac80211: debug: omit link if non-MLO connection
      wifi: mac80211: skip powersave recalc if driver SUPPORTS_DYNAMIC_PS
      wifi: mac80211: separate out connection downgrade flags
      wifi: mac80211: fix key lookup
      wifi: nl80211: acquire wdev mutex for dump_survey
      wifi: mac80211: move ieee80211_request_smps_mgd_work
      wifi: mac80211: set up/tear down client vif links properly
      wifi: mac80211: provide link ID in link_conf
      wifi: mac80211: move ps setting to vif config
      wifi: mac80211: expect powersave handling in driver for MLO
      wifi: mac80211: change QoS settings API to take link into account
      wifi: mac80211: remove unused bssid variable
      wifi: mac80211: mlme: track AP (MLD) address separately
      wifi: mac80211: mlme: do IEEE80211_STA_RESET_SIGNAL_AVE per link
      wifi: mac80211: mlme: first adjustments for MLO
      wifi: mac80211: split IEEE80211_STA_DISABLE_WMM to link data
      wifi: mac80211: mlme: use ieee80211_get_link_sband()
      wifi: mac80211: mlme: remove sta argument from ieee80211_config_bw
      wifi: mac80211: mlme: use correct link_sta
      wifi: cfg80211: remove BSS pointer from cfg80211_disassoc_request
      wifi: cfg80211: prepare association failure APIs for MLO
      wifi: mac80211: mlme: unify assoc data event sending
      wifi: cfg80211: adjust assoc comeback for MLO
      wifi: cfg80211: put cfg80211_rx_assoc_resp() arguments into a struct
      wifi: cfg80211: extend cfg80211_rx_assoc_resp() for MLO
      wifi: mac80211: refactor elements parsing with parameter struct
      wifi: mac80211: don't re-parse elems in ieee80211_assoc_success()
      wifi: mac80211: move tdls_chan_switch_prohibited to link data
      wifi: mac80211: fix multi-BSSID element parsing
      wifi: mac80211: don't set link address for station
      wifi: mac80211: remove redundant condition
      wifi: cfg80211: add ieee80211_chanwidth_rate_flags()
      wifi: mac80211: use only channel width in ieee80211_parse_bitrates()
      wifi: mac80211: refactor adding rates to assoc request
      wifi: mac80211: refactor adding custom elements
      wifi: mac80211: mlme: simplify adding ht/vht/he/eht elements
      wifi: mac80211: consider EHT element size in assoc request
      wifi: cfg80211: clean up links appropriately
      wifi: mac80211: tighten locking check
      wifi: mac80211: fix link manipulation
      wifi: nl80211: better validate link ID for stations
      wifi: nl80211: add EML/MLD capabilities to per-iftype capabilities
      wifi: nl80211: set BSS to NULL if IS_ERR()
      wifi: mac80211: skip rate statistics for MLD STAs
      wifi: mac80211: add a helper to fragment an element
      wifi: nl80211: check MLO support in authenticate
      wifi: nl80211: advertise MLO support
      wifi: cfg80211: set country_elem to NULL
      wifi: nl80211: reject link specific elements on assoc link
      wifi: nl80211: reject fragmented and non-inheritance elements
      wifi: nl80211: fix some attribute policy entries
      wifi: mac80211: prohibit DEAUTH_NEED_MGD_TX_PREP in MLO
      wifi: mac80211: release channel context on link stop
      wifi: mac80211: mlme: clean up supported channels element code
      wifi: mac80211: add multi-link element to AUTH frames
      wifi: mac80211: make ieee80211_check_rate_mask() link-aware
      wifi: mac80211: move IEEE80211_SDATA_OPERATING_GMODE to link
      wifi: mac80211: mlme: refactor link station setup
      wifi: mac80211: mlme: shift some code around
      wifi: mac80211: mlme: change flags in ieee80211_determine_chantype()
      wifi: mac80211: mlme: switch some things back to deflink
      wifi: mac80211: mlme: refactor assoc req element building
      wifi: mac80211: mlme: refactor ieee80211_prep_channel() a bit
      wifi: mac80211: mlme: refactor assoc success handling
      wifi: mac80211: mlme: remove address arg to ieee80211_mark_sta_auth()
      wifi: mac80211: mlme: refactor assoc link setup
      wifi: mac80211: mlme: look up beacon elems only if needed
      wifi: cfg80211: add cfg80211_get_iftype_ext_capa()
      wifi: mac80211: mlme: refactor ieee80211_set_associated()
      wifi: mac80211: limit A-MSDU subframes for client too
      wifi: mac80211_hwsim: implement sta_state for MLO
      wifi: mac80211: fix up link station creation/insertion
      wifi: mac80211: do link->MLD address translation on RX
      wifi: mac80211_hwsim: fix TX link selection
      wifi: mac80211: add API to parse multi-link element
      wifi: mac80211: support MLO authentication/association with one link
      wifi: mac80211: remove stray printk
      wifi: mac80211: mlme: set sta.mlo correctly
      wifi: mac80211: tx: use AP address in some places for MLO
      wifi: mac80211: mlme: fix override calculation
      wifi: mac80211: fix NULL pointer deref with non-MLD STA
      wifi: mac80211: fix RX MLD address translation
      wifi: mac80211_hwsim: fix address translation for MLO
      wifi: mac80211: fast-xmit: handle non-MLO clients
      wifi: mac80211: mlme: set sta.mlo to mlo state
      wifi: mac80211: validate link address doesn't change
      wifi: mac80211: fix link sta hash table handling
      wifi: mac80211: more station handling sanity checks
      wifi: nl80211: require MLD address on link STA add/modify
      wifi: mac80211: return error from control port TX for drops
      wifi: nl80211/mac80211: clarify link ID in control port TX
      wifi: mac80211: mlme: fix link_sta setup
      wifi: mac80211: sta_info: fix link_sta insertion
      wifi: mac80211_hwsim: handle links for wmediumd/virtio
      wifi: cfg80211: report link ID in NL80211_CMD_FRAME
      wifi: mac80211: report link ID to cfg80211 on mgmt RX
      wifi: nl80211: add MLO link ID to the NL80211_CMD_FRAME TX API
      wifi: mac80211: expand ieee80211_mgmt_tx() for MLO
      wifi: mac80211: optionally implement MLO multicast TX
      wifi: mac80211: rx: track link in RX data
      wifi: mac80211: verify link addresses are different
      wifi: mac80211: mlme: transmit assoc frame with address translation
      wifi: mac80211: remove erroneous sband/link validation
      wifi: mac80211: mlme: fix disassoc with MLO
      wifi: mac80211: fix link data leak

John Fastabend (1):
      bpf: Fix sockmap calling sleepable function in teardown path

Jon Doron (1):
      libbpf: perfbuf: Add API to get the ring buffer

Jonathan Cooper (10):
      sfc: Split STATE_READY in to STATE_NET_DOWN and STATE_NET_UP.
      sfc: Add a PROBED state for EF100 VDPA use.
      sfc: Remove netdev init from efx_init_struct
      sfc: Change BUG_ON to WARN_ON and recovery code.
      sfc: Encapsulate access to netdev_priv()
      sfc: Separate efx_nic memory from net_device memory
      sfc: Move EF100 efx_nic_type structs to the end of the file
      sfc: Unsplit literal string.
      sfc: replace function name in string with __func__
      sfc: Separate netdev probe/remove from PCI probe/remove

Jonathan Lemon (3):
      net: phy: broadcom: Add Broadcom PTP hooks to bcm-phy-lib
      net: phy: broadcom: Add PTP support for some Broadcom PHYs.
      net: phy: Add support for 1PPS out and external timestamps

Jonathan Toppins (2):
      bonding: netlink error message support for options
      bonding: cleanup bond_create

Jose Ignacio Tornos Martinez (1):
      wifi: iwlwifi: mvm: fix double list_add at iwl_mvm_mac_wake_tx_queue

Juergen Gross (1):
      xen/netback: do some code cleanup

Juhee Kang (2):
      mlxsw: use netif_is_any_bridge_port() instead of open code
      net: marvell: prestera: use netif_is_any_bridge_port instead of open code

Jukka Rissanen (1):
      MAINTAINERS: Remove Jukka Rissanen as 6lowpan maintainer

Julia Lawall (4):
      ath6kl: fix typo in comment
      drivers/net/ethernet/intel: fix typos in comments
      wifi: virt_wifi: fix typo in comment
      wifi: nl80211: fix typo in comment

Justin Chen (5):
      net: usb: ax88179_178a: remove redundant init code
      net: usb: ax88179_178a: clean up pm calls
      net: usb: ax88179_178a: restore state on resume
      net: usb: ax88179_178a: move priv to driver_priv
      net: usb: ax88179_178a: wol optimizations

Justin Stitt (10):
      net: l2tp: fix clang -Wformat warning
      l2tp: l2tp_debugfs: fix Clang -Wformat warnings
      net: rxrpc: fix clang -Wformat warning
      amd-xgbe: fix clang -Wformat warnings
      nfp: fix clang -Wformat warnings
      qlogic: qed: fix clang -Wformat warnings
      wifi: mt7601u: eeprom: fix clang -Wformat warning
      wifi: mt7601u: fix clang -Wformat warning
      netfilter: xt_TPROXY: remove pr_debug invocations
      wifi: iwlwifi: mvm: fix clang -Wformat warnings

Jörn-Thorben Hinz (7):
      bpf: Allow a TCP CC to write sk_pacing_rate and sk_pacing_status
      bpf: Require only one of cong_avoid() and cong_control() from a TCP CC
      selftests/bpf: Test a BPF CC writing sk_pacing_*
      selftests/bpf: Test an incomplete BPF CC
      selftests/bpf: Test a BPF CC implementing the unsupported get_info()
      selftests/bpf: Fix rare segfault in sock_fields prog test
      bpftool: Don't try to return value from void function in skeleton

Kai-Heng Feng (2):
      igb: Remove duplicate defines
      mt76: mt7921: Let PCI core handle power state and use pm_sleep_ptr()

Kalle Valo (8):
      ath10k: fix recently introduced checkpatch warning
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      wifi: ath11k: mac: fix long line
      Merge tag 'mt76-for-kvalo-2022-07-11' of https://github.com/nbd168/wireless
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Revert "ath11k: add support for hardware rfkill for QCA6390"
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git

Karol Kolacinski (3):
      ice: remove u16 arithmetic in ice_gnss
      ice: add i2c write command
      ice: add write functionality for GNSS TTY

Ke Liu (2):
      xdp: Directly use ida_alloc()/free() APIs
      wifi: mac80211_hwsim: Directly use ida_alloc()/free()

Kees Cook (1):
      hinic: Replace memcpy() with direct assignment

Kleber Sacilotto de Souza (1):
      selftests: net: fix IOAM test skip return code

Kosuke Fujimoto (1):
      bpf, docs: Fix typo "BFP_ALU" to "BPF_ALU"

Krzysztof Kozlowski (5):
      ath10k: do not enforce interrupt trigger type
      dt-bindings: net: hirschmann,hellcreek: use absolute path to other schema
      dt-bindings: net: cdns,macb: use correct xlnx prefix for Xilinx
      net: cdns,macb: use correct xlnx prefix for Xilinx
      dt-bindings: nfc: use spi-peripheral-props.yaml

Kuan-Chung Chen (2):
      wifi: rtw89: fix potential TX stuck
      wifi: rtw89: enable VO TX AMPDU

Kumar Kartikeya Dwivedi (11):
      bpf: Introduce 8-byte BTF set
      tools/resolve_btfids: Add support for 8-byte BTF sets
      bpf: Switch to new kfunc flags infrastructure
      bpf: Add support for forcing kfunc args to be trusted
      bpf: Add documentation for kfuncs
      net: netfilter: Deduplicate code in bpf_{xdp,skb}_ct_lookup
      net: netfilter: Add kfuncs to set and change CT timeout
      selftests/bpf: Add verifier tests for trusted kfunc args
      selftests/bpf: Add negative tests for new nf_conntrack kfuncs
      selftests/bpf: Fix test_verifier failed test in unprivileged mode
      bpf: Fix build error in case of !CONFIG_DEBUG_INFO_BTF

Kuniyuki Iwashima (14):
      raw: Fix mixed declarations error in raw_icmp_error().
      raw: Use helpers for the hlist_nulls variant.
      af_unix: Clean up some sock_net() uses.
      af_unix: Include the whole hash table size in UNIX_HASH_SIZE.
      af_unix: Define a per-netns hash table.
      af_unix: Acquire/Release per-netns hash table's locks.
      af_unix: Put a socket into a per-netns hash table.
      af_unix: Remove unix_table_locks.
      af_unix: Do not call kmemdup() for init_net's sysctl table.
      af_unix: Put pathname sockets in the global hash table.
      selftests: net: af_unix: Test connect() with different netns.
      af_unix: Optimise hash table layout.
      selftests: net: af_unix: Fix a build error of unix_connect.c.
      udp: Remove redundant __udp_sysctl_init() call from udp_init().

Kurt Kanzenbach (2):
      net: phy: broadcom: Add support for BCM53128 internal PHYs
      igc: Lift TAPRIO schedule restriction

Lama Kayal (9):
      net/mlx5e: Convert mlx5e_tc_table member of mlx5e_flow_steering to pointer
      net/mlx5e: Make mlx5e_tc_table private
      net/mlx5e: Allocate VLAN and TC for featured profiles only
      net/mlx5e: Convert mlx5e_flow_steering member of mlx5e_priv to pointer
      net/mlx5e: Report flow steering errors with mdev err report API
      net/mlx5e: Add mdev to flow_steering struct
      net/mlx5e: Separate mlx5e_set_rx_mode_work and move caller to en_main
      net/mlx5e: Split en_fs ndo's and move to en_main
      net/mlx5e: Move mlx5e_init_l2_addr to en_main

Larry Finger (4):
      wifi: rtw88: Fix sparse warning for rtw8822b_hw_spec
      wifi: rtw88: Fix Sparse warning for rtw8822c_hw_spec
      wifi: rtw88: Fix Sparse warning for rtw8723d_hw_spec
      wifi: rtw88: Fix Sparse warning for rtw8821c_hw_spec

Leon Romanovsky (1):
      net/mlx5: Delete ipsec_fs header file as not used

Li Qiong (2):
      wifi: mwl8k: use time_after to replace "jiffies > a"
      net/rds: Use PTR_ERR instead of IS_ERR for rdsdebug()

Li kunyu (3):
      cxgb4: Fix typo in string
      net/cmsg_sender: Remove a semicolon
      net: usb: Remove unnecessary '0' values from hasdata

Lian Chen (1):
      wifi: mac80211: make 4addr null frames using min_rate for WDS

Liang He (2):
      mediatek: mt76: mac80211: Fix missing of_node_put() in mt76_led_init()
      mediatek: mt76: eeprom: fix missing of_node_put() in mt76_find_power_limits_node()

Linkui Xiao (2):
      samples: bpf: Replace sizeof(arr)/sizeof(arr[0]) with ARRAY_SIZE
      selftests/bpf: Return true/false (not 1/0) from bool functions

Linus Walleij (2):
      ixp4xx_eth: Fall back to random MAC address
      ixp4xx_eth: Set MAC address from device tree

Liu Jian (1):
      skmsg: Fix invalid last sg check in sk_msg_recvmsg()

Lorenzo Bianconi (57):
      sample: bpf: xdp_router_ipv4: Allow the kernel to send arp requests
      net: ethernet: mtk_eth_soc: enable rx cksum offload for MTK_NETSYS_V2
      i40e: add xdp frags support to ndo_xdp_xmit
      mt76: mt7915: fix endianness in mt7915_rf_regval_get
      mt76: mt76x02u: fix possible memory leak in __mt76x02u_mcu_send_msg
      mt76: mt7921: add missing bh-disable around rx napi schedule
      mt76: mt7921: get rid of mt7921_mcu_exit
      mt76: connac: move shared fw structures in connac module
      mt76: mt7921: move fw toggle in mt7921_load_firmware
      mt76: connac: move mt76_connac2_load_ram in connac module
      mt76: connac: move mt76_connac2_load_patch in connac module
      mt76: mt7663: rely on mt76_connac2_fw_trailer
      mt76: mt7921: rely on mt76_dev in mt7921_mac_write_txwi signature
      mt76: mt7915: rely on mt76_dev in mt7915_mac_write_txwi signature
      mt76: connac: move mac connac2 defs in mt76_connac2_mac.h
      mt76: connac: move connac2_mac_write_txwi in mt76_connac module
      mt76: connac: move mt76_connac2_mac_add_txs_skb in connac module
      mt76: connac: move HE radiotap parsing in connac module
      mt76: connac: move mt76_connac2_reverse_frag0_hdr_trans in mt76-connac module
      mt76: connac: move mt76_connac2_mac_fill_rx_rate in connac module
      mt76: mt7921s: remove unnecessary goto in mt7921s_mcu_drv_pmctrl
      mt76: mt7615: do not update pm stats in case of error
      mt76: mt7921: do not update pm states in case of error
      mt76: mt7915: get rid of unnecessary new line in mt7915_mac_write_txwi
      mt76: connac: move mt76_connac_fw_txp in common module
      mt76: move mt7615_txp_ptr in mt76_connac module
      mt76: connac: move mt76_connac_tx_free in shared code
      mt76: connac: move mt76_connac_tx_complete_skb in shared code
      mt76: connac: move mt76_connac_write_hw_txp in shared code
      mt76: connac: move mt7615_txp_skb_unmap in common code
      mt76: mt7915: rely on mt76_connac_tx_free
      mt76: move mcu_txd/mcu_rxd structures in shared code
      mt76: move mt76_connac2_mcu_fill_message in mt76_connac module
      mt76: mt7915: do not copy ieee80211_ops pointer in mt7915_mmio_probe
      mt76: mt7921: make mt7921_pci_driver static
      mt76: connac: move tx initialization/cleanup in mt76_connac module
      mt76: add len parameter to __mt76_mcu_msg_alloc signature
      mt76: introduce MT_RXQ_BAND2 and MT_RXQ_BAND2_WA in mt76_rxq_id
      mt76: add phy_idx in mt76_rx_status
      mt76: introduce phys array in mt76_dev structure
      mt76: add phy_idx to mt76_wcid
      mt76: convert MT_TX_HW_QUEUE_EXT_PHY to MT_TX_HW_QUEUE_PHY
      mt76: get rid of mt76_wcid_hw routine
      igb: add xdp frags support to ndo_xdp_xmit
      net: netfilter: Add kfuncs to allocate and insert CT
      net: netfilter: Add kfuncs to set and change CT status
      selftests/bpf: Add tests for new nf_conntrack kfuncs
      net: ethernet: mtk_eth_soc: rely on page_pool for single page buffers
      net: ethernet: mtk_eth_soc: add basic XDP support
      net: ethernet: mtk_eth_soc: introduce xdp ethtool counters
      net: ethernet: mtk_eth_soc: add xmit XDP support
      net: ethernet: mtk_eth_soc: add support for page_pool_get_stats
      net: ethernet: mtk-ppe: fix traffic offload with bridged wlan
      bpf, devmap: Compute proper xdp_frame len redirecting frames
      net: ethernet: mtk_eth_soc: introduce mtk_xdp_frame_map utility routine
      net: ethernet: mtk_eth_soc: introduce xdp multi-frag support
      net: ethernet: mtk_eth_soc: add xdp tx return bulking support

Lu Wei (1):
      ice: use eth_broadcast_addr() to set broadcast address

Luiz Augusto von Dentz (16):
      Bluetooth: eir: Fix using strlen with hdev->{dev_name,short_name}
      Bluetooth: HCI: Fix not always setting Scan Response/Advertising Data
      Bluetooth: hci_sync: Fix not updating privacy_mode
      Bluetooth: hci_sync: Don't remove connected devices from accept list
      Bluetooth: hci_sync: Split hci_dev_open_sync
      Bluetooth: Add bt_status
      Bluetooth: Use bt_status to convert from errno
      Bluetooth: mgmt: Fix using hci_conn_abort
      Bluetooth: MGMT: Fix holding hci_conn reference while command is queued
      Bluetooth: hci_core: Introduce hci_recv_event_data
      Bluetooth: Add initial implementation of CIS connections
      Bluetooth: Add BTPROTO_ISO socket type
      Bluetooth: Add initial implementation of BIS connections
      Bluetooth: ISO: Add broadcast support
      Bluetooth: btusb: Add support for ISO packets
      Bluetooth: btusb: Detect if an ACL packet is in fact an ISO packet

Lukas Bulwahn (1):
      wireguard: selftests: update config fragments

Lukas Wunner (5):
      net: phy: smsc: Deduplicate interrupt acknowledgement upon phy_init_hw()
      usbnet: Fix linkwatch use-after-free on disconnect
      usbnet: smsc95xx: Fix deadlock on runtime resume
      usbnet: smsc95xx: Clean up nopm handling
      usbnet: smsc95xx: Clean up unnecessary BUG_ON() upon register access

Maciej Fijalkowski (9):
      selftests/xsk: Avoid bpf_link probe for existing xsk
      selftests/xsk: Introduce XDP prog load based on existing AF_XDP socket
      selftests/xsk: Verify correctness of XDP prog attach point
      selftests/xsk: Destroy BPF resources only when ctx refcount drops to 0
      selftests, xsk: Rename AF_XDP testing app
      MAINTAINERS: Add entry for AF_XDP selftests files
      xsk: Mark napi_id on sendmsg()
      ice: compress branches in ice_set_features()
      ice: allow toggling loopback mode via ndo_set_features callback

Maciej Żenczykowski (1):
      net: usb: make USB_RTL8153_ECM non user configurable

Magnus Karlsson (1):
      bpf, samples: Remove AF_XDP samples

Maher Sanalla (1):
      net/mlx5: Adjust log_max_qp to be 18 at most

Maksym Glubokiy (5):
      net: prestera: acl: add support for 'egress' rules
      net: extract port range fields from fl_flow_key
      net: prestera: add support for port range filters
      net: prestera: acl: fix code formatting
      net: prestera: acl: add support for 'police' action on egress

Manikanta Pubbisetty (6):
      ath11k: Init hw_params before setting up AHB resources
      ath11k: Fix incorrect debug_mask mappings
      ath11k: Avoid REO CMD failed prints during firmware recovery
      ath11k: Fix LDPC config in set_bitrate_mask hook
      ath11k: Fix warnings reported by checkpatch
      wifi: ath11k: Fix register write failure on QCN9074

Manish Mandlik (2):
      Bluetooth: hci_sync: Refactor add Adv Monitor
      Bluetooth: hci_sync: Refactor remove Adv Monitor

Maor Dickman (1):
      net/mlx5e: TC, Fix post_act to not match on in_port metadata

Marc Kleine-Budde (25):
      can: xilinx_can: fix typo prescalar -> prescaler
      can: m_can: fix typo prescalar -> prescaler
      can: netlink: allow configuring of fixed bit rates without need for do_set_bittiming callback
      Merge branch 'can-refactoring-of-can-dev-module-and-of-Kbuild'
      Merge branch 'can-etas_es58x-cleanups-on-struct-es58x_device'
      Merge branch 'document-polarfire-soc-can-controller'
      can: netlink: allow configuring of fixed data bit rates without need for do_set_data_bittiming callback
      Merge branch 'preparation-for-supporting-esd-CAN-USB-3'
      Merge branch 'can327-CAN-ldisc-driver-for-ELM327-based-OBD-II-adapters'
      can: ctucanfd: ctucan_interrupt(): fix typo
      Merge branch 'can-slcan-extend-supported-features'
      can: slcan: convert comments to network style comments
      can: slcan: slcan_init() convert printk(LEVEL ...) to pr_level()
      can: slcan: fix whitespace issues
      can: slcan: convert comparison to NULL into !val
      can: slcan: clean up if/else
      Merge branch 'can-slcan-checkpatch-cleanups'
      Merge branch 'can-add-support-for-rz-n1-sja1000-can-controller'
      Merge branch 'can-peak_usb-cleanups-and-updates'
      Merge branch 'can-error-set-of-fixes-and-improvement-on-txerr-and-rxerr-reporting'
      can: mcp251xfd: mcp251xfd_dump(): fix comment
      Merge patch series "can: remove litteral strings used for driver names and remove DRV_VERSION"
      Merge patch series "can: export export slcan_ethtool_ops and remove setter functions"
      Merge patch series "can: slcan: extend supported features (step 2)"
      Merge patch series "can: add ethtool support and reporting of timestamping capabilities"

Marcin Szycik (1):
      ice: Add support for PPPoE hardware offload

Marcin Wojtas (1):
      net: dsa: mv88e6xxx: fix speed setting for CPU/DSA ports

Marco Bonelli (1):
      ethtool: Fix and simplify ethtool_convert_link_mode_to_legacy_u32()

Martin Blumenstingl (1):
      selftests: net: dsa: Add a Makefile which installs the selftests

Martin KaFai Lau (1):
      selftests/bpf: Fix tc_redirect_dtime

Martyna Szapar-Mudlaw (3):
      ice: Add support for double VLAN in switchdev
      ice: Add support for VLAN TPID filters in switchdev
      ice: switch: dynamically add VLAN headers to dummy packets

Mateusz Palczewski (3):
      i40e: Add VF VLAN pruning
      iavf: Add waiting for response from PF in set mac
      i40e: Add support for ethtool -s <interface> speed <speed in Mb>

Matthias May (5):
      ip_tunnel: allow to inherit from VLAN encapsulated IP
      ip6_gre: set DSCP for non-IP
      ip6_gre: use actual protocol to select xmit
      ip6_tunnel: allow to inherit from VLAN encapsulated IP
      ip_tunnels: allow VXLAN/GENEVE to inherit TOS/TTL from VLAN

Matthieu Baerts (1):
      bpf: Fix 'dubious one-bit signed bitfield' warnings

Mauro Carvalho Chehab (3):
      wifi: cfg80211: fix kernel-doc warnings all over the file
      wifi: mac80211: add a missing comma at kernel-doc markup
      wifi: mac80211: sta_info: fix a missing kernel-doc struct element

Max Staudt (3):
      can: Break loopback loop on loopback documentation
      tty: Add N_CAN327 line discipline ID for ELM327 based CAN driver
      can: can327: CAN/ldisc driver for ELM327 based OBD-II adapters

Maxim Mikityanskiy (14):
      bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie
      bpf: Allow helpers to accept pointers with a fixed size
      bpf: Add helpers to issue and check SYN cookies in XDP
      selftests/bpf: Add selftests for raw syncookie helpers
      bpf: Allow the new syncookie helpers to work with SKBs
      selftests/bpf: Add selftests for raw syncookie helpers in TC mode
      selftests/bpf: Enable config options needed for xdp_synproxy test
      selftests/bpf: Fix xdp_synproxy build failure if CONFIG_NF_CONNTRACK=m/n
      net/mlx5e: Move the LRO-XSK check to mlx5e_fix_features
      net/mlx5e: Remove the duplicating check for striding RQ when enabling LRO
      net/mlx5e: Fix the value of MLX5E_MAX_RQ_NUM_MTTS
      net/mlx5e: xsk: Account for XSK RQ UMRs when calculating ICOSQ size
      net/mlx5e: Fix calculations related to max MPWQE size
      net/mlx5e: xsk: Discard unaligned XSK frames on striding RQ

Maxime Bizon (1):
      ath10k: fix misreported tx bandwidth for 160Mhz

Maximilian Heyne (1):
      drivers, ixgbe: export vf statistics

MeiChia Chiu (4):
      wifi: mac80211: fix center freq calculation in ieee80211_chandef_downgrade
      mt76: do not check the ccmp pn for ONLY_MONITOR frame
      mt76: mt7915: update the maximum size of beacon offload
      mt76: mt7915 add ht mpdu density

Menglong Dong (4):
      net: skb: move enum skb_drop_reason to standalone header file
      net: skb: use auto-generation to convert skb drop reason to string
      net: dropreason: reformat the comment fo skb drop reasons
      net: mptcp: fix some spelling mistake in mptcp

Michael Guralnik (1):
      net/mlx5: Expose vnic diagnostic counters for eswitch managed vports

Michael Mullin (1):
      bpftool: Check for NULL ptr of btf in codegen_asserts

Michael Walle (8):
      net: sfp: use hwmon_sanitize_name()
      net: phy: nxp-tja11xx: use devm_hwmon_sanitize_name()
      net: phy: mxl-gpy: add temperature sensor
      net: phy: mxl-gpy: fix version reporting
      net: phy: mxl-gpy: cache PHY firmware version
      net: phy: mxl-gpy: rename the FW type field name
      net: phy: mxl-gpy: print firmware in human readable form
      NFC: nxp-nci: add error reporting

Michal Swiatkowski (2):
      ice: don't set VF VLAN caps in switchdev
      ice: remove VLAN representor specific ops

Michal Wilczynski (2):
      ice: Introduce enabling promiscuous mode on multiple VF's
      ice: Fix promiscuous mode not turning off

Mike Manning (1):
      net: allow unbound socket for packets in VRF when tcp_l3mdev_accept set

Minghao Chi (2):
      wifi: wfx: Remove redundant NULL check before release_firmware() call
      i40e: Remove unnecessary synchronize_irq() before free_irq()

Moshe Shemesh (17):
      net/mlx5: Remove devl_unlock from mlx5_eswtich_mode_callback_enter
      net/mlx5: Use devl_ API for rate nodes destroy
      devlink: Remove unused function devlink_rate_nodes_destroy
      net/mlx5: Use devl_ API in mlx5_esw_offloads_devlink_port_register
      net/mlx5: Use devl_ API in mlx5_esw_devlink_sf_port_register
      devlink: Remove unused functions devlink_rate_leaf_create/destroy
      net/mlx5: Use devl_ API in mlx5e_devlink_port_register
      net/mlx5: Remove devl_unlock from mlx5_devlink_eswitch_mode_set
      devlink: Hold the instance lock in port_new / port_del callbacks
      net: devlink: avoid false DEADLOCK warning reported by lockdep
      net/mlx5: Move fw reset unload to mlx5_fw_reset_complete_reload
      net/mlx5: Lock mlx5 devlink reload callbacks
      net/mlx4: Use devl_ API for devlink region create / destroy
      net/mlx4: Use devl_ API for devlink port register / unregister
      net/mlx4: Lock mlx4 devlink reload callback
      net/mlx5: Lock mlx5 devlink health recovery callback
      devlink: Hold the instance lock in health callbacks

Moshe Tal (7):
      net/mlx5e: Fix mqprio_rl handling on devlink reload
      net/mlx5e: HTB, move ids to selq_params struct
      net/mlx5e: HTB, move section comment to the right place
      net/mlx5e: HTB, move stats and max_sqs to priv
      net/mlx5e: HTB, remove priv from htb function calls
      net/mlx5e: HTB, change functions name to follow convention
      net/mlx5e: HTB, move htb functions to a new file

Nathan Chancellor (1):
      bpf, arm64: Mark dummy_tramp as global

Ofer Levi (1):
      net/mlx5: Add bits and fields to support enhanced CQE compression

Oleksandr Mazur (5):
      net: marvell: prestera: rework bridge flags setting
      net: marvell: prestera: define MDB/flood domain entries and HW API to offload them to the HW
      net: marvell: prestera: define and implement MDB / flood domain API for entries creation and deletion
      net: marvell: prestera: implement software MDB entries allocation
      net: marvell: prestera: add phylink support

Oleksij Rempel (8):
      net: ag71xx: fix discards 'const' qualifier warning
      net: macb: fix negative max_mtu size for sama5d3
      net: dsa: ar9331: fix potential dead lock on mdio access
      net: phy: dp83td510: add SQI support
      net: dsa: add get_pause_stats support
      net: dsa: ar9331: add support for pause stats
      net: dsa: microchip: add pause stats support
      net: dsa: microchip: count pause packets together will all other packets

Oliver Neukum (2):
      cdc-eem: always use BIT
      usbnet: remove vestiges of debug macros

Ong Boon Leong (5):
      net: make xpcs_do_config to accept advertising for pcs-xpcs and sja1105
      stmmac: intel: prepare to support 1000BASE-X phy interface setting
      net: pcs: xpcs: add CL37 1000BASE-X AN support
      stmmac: intel: add phy-mode and fixed-link ACPI _DSD setting support
      net: stmmac: make mdio register skips PHY scanning for fixed-link

Paolo Abeni (25):
      Merge branch 'reorganize-the-code-of-the-enum-skb_drop_reason'
      Merge branch 'vmxnet3-upgrade-to-version-7'
      Merge branch 'net-mana-add-pf-and-xdp_redirect-support'
      Merge branch 'net-dsa-microchip-common-spi-probe-for-the-ksz-series-switches-part-1'
      Merge branch 'mlxsw-unified-bridge-conversion-part-4-6'
      Merge branch 'net-neigh-introduce-interval_probe_time-for-periodic-probe'
      mptcp: never fetch fwd memory from the subflow
      mptcp: drop SK_RECLAIM_* macros
      mptcp: refine memory scheduling
      net: remove SK_RECLAIM_THRESHOLD and SK_RECLAIM_CHUNK
      Merge branch 'af_unix-fix-regression-by-the-per-netns-hash-table-series'
      net/mlx5: fix 32bit build
      selftests: mptcp: tweak simult_flows for debug kernels
      Merge branch 'mlx5-devlink-mutex-removal-part-1'
      mptcp: introduce and use mptcp_pm_send_ack()
      mptcp: address lookup improvements
      mptcp: allow the in kernel PM to set MPC subflow priority
      mptcp: more accurate MPC endpoint tracking
      selftests: mptcp: add MPC backup tests
      Merge branch 'xen-netfront-xsa-403-follow-on'
      net: ipa: fix build
      Merge branch 'octeontx2-minor-tc-fixes'
      Revert "Merge branch 'octeontx2-minor-tc-fixes'"
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net

Parthiban Veerasooran (1):
      net: smsc95xx: add support for Microchip EVB-LAN8670-USB

Paul Cercueil (1):
      wifi: brcmfmac: Remove #ifdef guards for PM related functions

Paul Chaignon (5):
      ip_tunnels: Add new flow flags field to ip_tunnel_key
      vxlan: Use ip_tunnel_key flow flags in route lookups
      geneve: Use ip_tunnel_key flow flags in route lookups
      bpf: Set flow flag to allow any source IP in bpf_tunnel_key
      selftests/bpf: Don't assign outer source IP to host

Pavel Pisa (1):
      can: ctucanfd: Update CTU CAN FD IP core registers to match version 3.x.

Pavel Skripkin (2):
      ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
      ath9k: htc: clean up statistics macros

Peilin Ye (1):
      net/sched: sch_cbq: Delete unused delay_timer

Peng Wu (1):
      net: dsa: rzn1-a5psw: fix a NULL vs IS_ERR() check in a5psw_probe()

Peter Chiu (3):
      wifi: ieee80211: s1g action frames are not robust
      dt-bindings: net: wireless: mt76: add clock description for MT7986.
      mt76: mt7915: update mpdu density in 6g capability

Peter Lafreniere (2):
      net: constify some inline functions in sock.h
      ax25: use GFP_KERNEL in ax25_dev_device_up()

Petr Machata (11):
      mlxsw: Revert "Introduce initial XM router support"
      mlxsw: Revert "Prepare for XM implementation - prefix insertion and removal"
      mlxsw: Revert "Prepare for XM implementation - LPM trees"
      mlxsw: Keep track of number of allocated RIFs
      mlxsw: Add a resource describing number of RIFs
      selftests: mlxsw: resource_scale: Introduce traffic tests
      selftests: mlxsw: resource_scale: Allow skipping a test
      selftests: mlxsw: resource_scale: Pass target count to cleanup
      selftests: mlxsw: tc_flower_scale: Add a traffic test
      selftests: mlxsw: Add a RIF counter scale test
      selftests: forwarding: ethtool_extended_state: Convert to busywait

Petr Vaněk (1):
      xfrm: improve wording of comment above XFRM_OFFLOAD flags

Ping-Ke Shih (13):
      rtw89: pci: handle hardware watchdog timeout interrupt status
      rtw89: 8852c: rfk: re-calibrate RX DCK once thermal changes a lot
      wifi: rtw89: support MULTI_BSSID and correct BSSID mask of H2C
      wifi: rtw89: allocate address CAM and MAC ID to TDLS peer
      wifi: rtw89: separate BSSID CAM operations
      wifi: rtw89: allocate BSSID CAM per TDLS peer
      wifi: rtw89: support TDLS
      wifi: rtw89: add UNEXP debug mask to keep monitor messages unexpected to happen frequently
      wifi: rtw89: drop invalid TX rate report of legacy rate
      wifi: rtw89: fix long RX latency in low power mode
      wifi: rtw89: pci: fix PCI doesn't reclaim TX BD properly
      wifi: rtw89: 8852a: rfk: fix div 0 exception
      wifi: rtw89: 8852a: update RF radio A/B R56

Po Hao Huang (4):
      rtw89: fix channel inconsistency during hw_scan
      rtw89: fix null vif pointer when hw_scan fails
      ieee80211: add trigger frame definition
      rtw89: 8852c: add trigger frame counter

Po-Hao Huang (2):
      rtw88: fix null vif pointer when hw_scan fails
      wifi: rtw89: disable invalid phy reports for all ICs

Prasanna Vengateshan (3):
      dt-bindings: net: make internal-delay-ps based on phy-mode
      dt-bindings: net: dsa: dt bindings for microchip lan937x
      net: dsa: tag_ksz: add tag handling for Microchip LAN937x

Przemyslaw Patynowski (3):
      i40e: Refactor tc mqprio checks
      iavf: Fix max_rate limiting
      iavf: Fix 'tc qdisc show' listing too many queues

Pu Lehui (7):
      bpf: Unify data extension operation of jited_ksyms and jited_linfo
      bpf, riscv: Support riscv jit to provide bpf_line_info
      bpf: Correct the comment about insn_to_jit_off
      bpf, docs: Remove deprecated xsk libbpf APIs description
      samples: bpf: Fix cross-compiling error by using bootstrap bpftool
      tools: runqslower: Build and use lightweight bootstrap version of bpftool
      bpf: iterators: Build and use lightweight bootstrap version of bpftool

Qiao Ma (2):
      net: hinic: fix bug that ethtool get wrong stats
      net: hinic: avoid kernel hung in hinic_get_stats64()

Quentin Monnet (7):
      Revert "bpftool: Use libbpf 1.0 API mode instead of RLIMIT_MEMLOCK"
      bpftool: Do not check return value from libbpf_set_strict_mode()
      bpftool: Probe for memcg-based accounting before bumping rlimit
      bpftool: Add feature list (prog/map/link/attach types, helpers)
      bpftool: Use feature list in bash completion
      bpftool: Rename "bpftool feature list" into "... feature list_builtins"
      bpftool: Remove zlib feature test from Makefile

Radhey Shyam Pandey (2):
      dt-bindings: net: xilinx: document xilinx emaclite driver binding
      dt-bindings: net: cdns,macb: Add versal compatible string

Raju Lakkaraju (4):
      net: lan743x: Add support to LAN743x register dump
      net: lan743x: Add support to Secure-ON WOL
      net: lan743x: Add support to SGMII 1G and 2.5G
      net: phy: add support to get Master-Slave configuration

Rasmus Villemoes (4):
      net: phy: fixed_phy: set phy_mask before calling mdiobus_register()
      dt-bindings: dp83867: add binding for io_impedance_ctrl nvmem cell
      linux/phy.h: add phydev_err_probe() wrapper for dev_err_probe()
      net: phy: dp83867: implement support for io_impedance_ctrl nvmem cell

Ratheesh Kannoth (25):
      octeontx2-af: Use hashed field in MCAM key
      octeontx2-af: Exact match support
      octeontx2-af: Exact match scan from kex profile
      octeontx2-af: devlink configuration support
      octeontx2-af: FLR handler for exact match table.
      octeontx2-af: Drop rules for NPC MCAM
      octeontx2-af: Debugsfs support for exact match.
      octeontx2: Modify mbox request and response structures
      octeontx2-af: Wrapper functions for MAC addr add/del/update/reset
      octeontx2-af: Invoke exact match functions if supported
      octeontx2-pf: Add support for exact match table.
      octeontx2-af: Enable Exact match flag in kex profile
      octeontx2-af: Use hashed field in MCAM key
      octeontx2-af: Exact match support
      octeontx2-af: Exact match scan from kex profile
      octeontx2-af: devlink configuration support
      octeontx2-af: FLR handler for exact match table.
      octeontx2-af: Drop rules for NPC MCAM
      octeontx2-af: Debugsfs support for exact match.
      octeontx2: Modify mbox request and response structures
      octeontx2-af: Wrapper functions for MAC addr add/del/update/reset
      octeontx2-af: Invoke exact match functions if supported
      octeontx2-pf: Add support for exact match table.
      octeontx2-af: Enable Exact match flag in kex profile
      octeontx2-af: Fixes static warnings

Richard Gobert (1):
      net: helper function skb_len_add

Rob Herring (1):
      dt-bindings: net: dsa: mediatek,mt7530: Add missing 'reg' property

Roi Dayan (5):
      net/mlx5: CT: Remove warning of ignore_flow_level support for non PF
      net/mlx5e: TC, Allocate post meter ft per rule
      net/mlx5e: Add red and green counters for metering
      net/mlx5e: TC, Separate get/update/replace meter functions
      net/mlx5e: TC, Support tc action api for police

Roman Gushchin (1):
      bpf: reparent bpf maps on memcg offlining

Ronak Doshi (10):
      vmxnet3: prepare for version 7 changes
      vmxnet3: add support for capability registers
      vmxnet3: add support for large passthrough BAR register
      vmxnet3: add support for out of order rx completion
      vmxnet3: add command to set ring buffer sizes
      vmxnet3: limit number of TXDs used for TSO packet
      vmxnet3: use ext1 field to indicate encapsulated packet
      vmxnet3: update to version 7
      vmxnet3: disable overlay offloads if UPT device does not support
      vmxnet3: do not reschedule napi for rx processing

Rongguang Wei (1):
      bpftool: Replace sizeof(arr)/sizeof(arr[0]) with ARRAY_SIZE macro

Ruffalo Lavoisier (1):
      amt: fix typo in comment

Russell King (1):
      net: dsa: mv88e6xxx: get rid of SPEED_MAX setting

Russell King (Oracle) (11):
      net: mii: add mii_bmcr_encode_fixed()
      net: phy: use mii_bmcr_encode_fixed()
      net: phy: marvell: use mii_bmcr_encode_fixed()
      net: pcs: pcs-xpcs: use mii_bmcr_encode_fixed()
      net: pcs: lynx: use mdiodev accessors
      net: dsa: mv88e6xxx: remove mv88e6065 dead code
      net: phylink: add QSGMII support to phylink_mii_c22_pcs_encode_advertisement()
      net: pcs: lynx: consolidate sgmii and 1000base-x config code
      net: phylink: remove pcs_ops member
      net: phylink: disable PCS polling over major configuration
      net: phylink: fix SGMII inband autoneg enable

Rustam Subkhankulov (2):
      net/mlx5e: Removed useless code in function
      wifi: p54: add missing parentheses in p54_flush()

Ryder Lee (2):
      mt76: mt7915: add more ethtool stats
      mt76: add DBDC rxq handlings into mac_reset_work

Saeed Mahameed (3):
      net/mlx5: Add HW definitions of vport debug counters
      net/mlx5e: HTB, reduce visibility of htb functions
      net/mlx5e: HTB, hide and dynamically allocate mlx5e_htb structure

Sai Teja Aluvala (1):
      Bluetooth: hci_qca: Return wakeup for qca_wakeup

Sam Edwards (1):
      ipv6/addrconf: fix timing bug in tempaddr regen

Sasha Neftin (2):
      igc: Remove MSI-X PBA Clear register
      igc: Remove forced_speed_duplex value

Schspa Shi (1):
      Bluetooth: When HCI work queue is drained, only queue chained work

Sean Wang (5):
      mt76: mt7921: enable HW beacon filter not depending on PM flag
      mt76: mt7921: enable HW beacon filter in the initialization stage
      mt76: mt7921: reduce log severity levels for informative messages
      mt76: mt7921: reduce the mutex lock scope during reset
      Bluetooth: btmtksdio: Add in-band wakeup support

Sebin Sebastian (2):
      octeontx2-af: returning uninitialized variable
      net: marvell: prestera: remove reduntant code

Sergey Ryazanov (4):
      ath10k: improve tx status reporting
      ath10k: htt_tx: do not interpret Eth frames as WiFi
      ath10k: turn rawmode into frame_mode
      ath10k: add encapsulation offloading support

Shahab Vahedi (2):
      bpftool: Fix bootstrapping during a cross compilation
      bpf, docs: Fix the code formatting in instruction-set

Shaul Triebitz (11):
      wifi: mac80211_hwsim: split bss_info_changed to vif/link info_changed
      wifi: mac80211: use link in start/stop ap
      wifi: mac80211: pass the link id in start/stop ap
      wifi: mac80211: return a beacon for a specific link
      wifi: mac80211_hwsim: send a beacon per link
      wifi: mac80211_hwsim: print the link id
      wifi: mac80211: add an ieee80211_get_link_sband
      wifi: cfg80211: add API to add/modify/remove a link station
      wifi: cfg80211/mac80211: separate link params from station params
      wifi: mac80211: implement callbacks for <add/mod/del>_link_station
      wifi: nl80211: enable setting the link address at new station

Shay Drory (3):
      net/mlx5: group fdb cleanup to single function
      net/mlx5: Remove not used MLX5_CAP_BITS_RW_MASK
      net/mlx5: Fix driver use of uninitialized timeout

Shayne Chen (2):
      mt76: mt7915: fix incorrect testmode ipg on band 1 caused by wmm_idx
      mt76: mt7915: add sta_rec with EXTRA_INFO_NEW for the first time only

Shijith Thotton (1):
      octeontx2-af: fix operand size in bitwise operation

Sieng Piaw Liew (2):
      net: don't check skb_count twice
      bcm63xx_enet: switch to napi_build_skb() to reuse skbuff_heads

Sieng-Piaw Liew (3):
      net: ag71xx: switch to napi_build_skb() to reuse skbuff_heads
      bcm63xx: fix Tx cleanup when NAPI poll budget is zero
      atl1c: use netif_napi_add_tx() for Tx NAPI

Simon Horman (2):
      Revert "nfp: update nfp_X logging definitions"
      nfp: enable TSO by default for nfp netdev

Simon Wang (1):
      bpf: Replace hard-coded 0 with BPF_K in check_alu_op

Sixiang Chen (1):
      nfp: add 'ethtool --identify' support

Slark Xiao (1):
      selftests: net: Fix typo 'the the' in comment

Song Liu (6):
      bpf, x86: fix freeing of not-finalized bpf_prog_pack
      ftrace: Add modify_ftrace_direct_multi_nolock
      ftrace: Allow IPMODIFY and DIRECT ops on the same function
      bpf: Support bpf_trampoline on functions with IPMODIFY (e.g. livepatch)
      bpf: Simplify bpf_prog_pack_[size|mask]
      bpf: Fix test_progs -j error with fentry/fexit tests

Srinivas Neeli (1):
      can: xilinx_can: add Transmitter Delay Compensation (TDC) feature support

Sriram R (1):
      ath11k: update missing MU-MIMO and OFDMA stats

Stanislav Fomichev (16):
      bpf: add bpf_func_t and trampoline helpers
      bpf: convert cgroup_bpf.progs to hlist
      bpf: per-cgroup lsm flavor
      bpf: minimize number of allocated lsm slots per program
      bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP
      bpf: expose bpf_{g,s}etsockopt to lsm cgroup
      tools/bpf: Sync btf_ids.h to tools
      libbpf: add lsm_cgoup_sock type
      libbpf: implement bpf_prog_query_opts
      bpftool: implement cgroup tree for BPF_LSM_CGROUP
      selftests/bpf: lsm_cgroup functional test
      selftests/bpf: Skip lsm_cgroup when we don't have trampolines
      bpf: Check attach_func_proto more carefully in check_return_code
      bpf: fix lsm_cgroup build errors on esoteric configs
      bpf: Fix bpf_trampoline_{,un}link_cgroup_shim ifdef guards
      bpf: Check attach_func_proto more carefully in check_helper_call

Stefan Raspl (3):
      s390/ism: Cleanups
      net/smc: Pass on DMBE bit mask in IRQ handler
      net/smc: Enable module load on netlink usage

Stephane Grosjean (3):
      can: peak_usb: pcan_dump_mem(): mark input prompt and data pointer as const
      can: peak_usb: correction of an initially misnamed field name
      can: peak_usb: include support for a new MCU

Stephen Hemminger (1):
      xfrm: convert alg_key to flexible array member

Subash Abhinov Kasiviswanathan (1):
      net: Print hashed skb addresses for all net and qdisc events

Subbaraya Sundeep (2):
      octeontx2-pf: Fix UDP/TCP src and dst port tc filters
      octeontx2-pf: Reduce minimum mtu size to 60

Sunil Goutham (2):
      octeontx2-af: Set NIX link credits based on max LMAC
      octeontx2-pf: cn10k: Fix egress ratelimit configuration

Tadeusz Struk (1):
      bpf: Fix KASAN use-after-free Read in compute_effective_progs

Tamas Koczka (1):
      Bluetooth: Collect kcov coverage from hci_rx_work

Tariq Toukan (8):
      net/mlx5: debugfs, Add num of in-use FW command interface slots
      net/tls: Perform immediate device ctx cleanup when possible
      net/tls: Multi-threaded calls to TX tls_dev_del
      net/mlx5e: kTLS, Introduce TLS-specific create TIS
      net/mlx5e: kTLS, Take stats out of OOO handler
      net/mlx5e: kTLS, Recycle objects of device-offloaded TLS TX connections
      net/mlx5e: kTLS, Dynamically re-size TX recycling pool
      net/tls: Remove redundant workqueue flush before destroy

Tetsuo Handa (2):
      ath6kl: avoid flush_scheduled_work() usage
      wifi: mac80211: do not abuse fq.lock in ieee80211_do_stop()

Thiraviyam Mariyappan (1):
      ath11k: support avg signal in station dump

Tobias Klauser (3):
      bpf: Fix bpf_skc_lookup comment wrt. return type
      bpftool: Remove attach_type_name forward declaration
      bpf: Omit superfluous address family check in __bpf_skc_lookup

Tony Ambardar (1):
      bpf, x64: Add predicate for bpf2bpf with tailcalls support in JIT

Uwe Kleine-König (1):
      wifi: wl12xx: Drop if with an always false condition

Veerendranath Jakkam (5):
      cfg80211: Indicate MLO connection info in connect and roam callbacks
      wifi: cfg80211: Increase akm_suites array size in cfg80211_crypto_settings
      wifi: nl80211: Fix reading NL80211_ATTR_MLO_LINK_ID in nl80211_pre_doit
      wifi: cfg80211: fix a comment in cfg80211_mlme_mgmt_tx()
      wifi: nl80211: fix sending link ID info of associated BSS

Vikas Gupta (1):
      devlink: introduce framework for selftests

Vincent Mailhol (50):
      can: Kconfig: rename config symbol CAN_DEV into CAN_NETLINK
      can: Kconfig: turn menu "CAN Device Drivers" into a menuconfig using CAN_DEV
      can: bittiming: move bittiming calculation functions to calc_bittiming.c
      can: Kconfig: add CONFIG_CAN_RX_OFFLOAD
      net: Kconfig: move the CAN device menu to the "Device Drivers" section
      can: skb: move can_dropped_invalid_skb() and can_skb_headroom_valid() to skb.c
      can: skb: drop tx skb if in listen only mode
      can: etas_es58x: replace es58x_device::rx_max_packet_size by usb_maxpacket()
      can: etas_es58x: fix signedness of USB RX and TX pipes
      can: pch_can: do not report txerr and rxerr during bus-off
      can: rcar_can: do not report txerr and rxerr during bus-off
      can: sja1000: do not report txerr and rxerr during bus-off
      can: slcan: do not report txerr and rxerr during bus-off
      can: hi311x: do not report txerr and rxerr during bus-off
      can: sun4i_can: do not report txerr and rxerr during bus-off
      can: kvaser_usb_hydra: do not report txerr and rxerr during bus-off
      can: kvaser_usb_leaf: do not report txerr and rxerr during bus-off
      can: usb_8dev: do not report txerr and rxerr during bus-off
      can: error: specify the values of data[5..7] of CAN error frames
      can: add CAN_ERR_CNT flag to notify availability of error counter
      can: error: add definitions for the different CAN error thresholds
      can: pch_can: pch_can_error(): initialize errc before using it
      can: can327: use KBUILD_MODNAME instead of hard coded names
      can: ems_usb: use KBUILD_MODNAME instead of hard coded names
      can: softing: use KBUILD_MODNAME instead of hard coded names
      can: esd_usb: use KBUILD_MODNAME instead of hard coded names
      can: gs_ubs: use KBUILD_MODNAME instead of hard coded names
      can: kvaser_usb: use KBUILD_MODNAME instead of hard coded names
      can: ubs_8dev: use KBUILD_MODNAME instead of hard coded names
      can: etas_es58x: replace ES58X_MODULE_NAME with KBUILD_MODNAME
      can: etas_es58x: remove DRV_VERSION
      can: slcan: export slcan_ethtool_ops and remove slcan_set_ethtool_ops()
      can: c_can: export c_can_ethtool_ops and remove c_can_set_ethtool_ops()
      can: flexcan: export flexcan_ethtool_ops and remove flexcan_set_ethtool_ops()
      can: slcan: use KBUILD_MODNAME and define pr_fmt to replace hardcoded names
      can: can327: add software tx timestamps
      can: janz-ican3: add software tx timestamp
      can: slcan: add software tx timestamps
      can: v(x)can: add software tx timestamps
      can: tree-wide: advertise software timestamping capabilities
      can: dev: add hardware TX timestamp
      can: dev: add generic function can_ethtool_op_get_ts_info_hwts()
      can: dev: add generic function can_eth_ioctl_hwts()
      can: mcp251xfd: advertise timestamping capabilities and add ioctl support
      can: etas_es58x: advertise timestamping capabilities and add ioctl support
      can: kvaser_pciefd: advertise timestamping capabilities and add ioctl support
      can: kvaser_usb: advertise timestamping capabilities and add ioctl support
      can: peak_canfd: advertise timestamping capabilities and add ioctl support
      can: peak_usb: advertise timestamping capabilities and add ioctl support
      can: etas_es58x: remove useless calls to usb_fill_bulk_urb()

Vlad Buslov (9):
      net/sched: act_ct: set 'net' pointer when creating new nf_flow_table
      netfilter: nf_flow_table: count pending offload workqueue tasks
      net/mlx5: Bridge, refactor groups sizes and indices
      net/mlx5: Bridge, rename filter fg to vlan_filter
      net/mlx5: Bridge, extract VLAN push/pop actions creation
      net/mlx5: Bridge, implement infrastructure for VLAN protocol change
      net/mlx5: Bridge, implement QinQ support
      net/mlx5e: Extend flower police validation
      net/mlx5e: Modify slow path rules to go to slow fdb

Vladimir Oltean (9):
      net: switchdev: add reminder near struct switchdev_notifier_fdb_info
      net: phylink: fix NULL pl->pcs dereference during phylink_pcs_poll_start
      net: gianfar: add support for software TX timestamping
      net: dsa: felix: keep reference on entire tc-taprio config
      net: dsa: felix: keep QSYS_TAG_CONFIG_INIT_GATE_STATE(0xFF) out of rmw
      net: dsa: felix: drop oversized frames with tc-taprio instead of hanging the port
      time64.h: consolidate uses of PSEC_PER_NSEC
      net: sched: provide shim definitions for taprio_offload_{get,free}
      net: dsa: felix: build as module when tc-taprio is module

Walter Heymans (1):
      nfp: flower: fix comment typos and formatting

Wang Yufen (1):
      bpf, sockmap: Fix sk->sk_forward_alloc warn_on in sk_stream_kill_queues

Wei Fang (1):
      dt-bindings: net: fsl,fec: Add i.MX8ULP FEC items

Wen Gong (1):
      ath10k: fix regdomain info of iw reg set/get

Wen Gu (4):
      net/smc: Introduce a sysctl for setting SMC-R buffer type
      net/smc: Use sysctl-specified types of buffers in new link group
      net/smc: Allow virtually contiguous sndbufs or RMBs for SMC-R
      net/smc: Extend SMC-R link group netlink attribute

William Dean (2):
      net: delete extra space and tab in blank line
      wifi: rtw88: check the return value of alloc_workqueue()

Wojciech Drewek (3):
      flow_dissector: Add PPPoE dissectors
      net/sched: flower: Add PPPoE filter
      flow_offload: Introduce flow_match_pppoe

Xiang wangx (7):
      WAN: Fix syntax errors in comments
      ppp: Fix typo in comment
      atm: iphase: Fix typo in comment
      net: emac: Fix typo in a comment
      sfc: Fix typo in comment
      sfc/siena: Fix typo in comment
      wcn36xx: Fix typo in comment

Xiaohui Zhang (1):
      Bluetooth: use memset avoid memory leaks

Xiaoliang Yang (1):
      net: dsa: felix: update base time of time-aware shaper when adjusting PTP time

Xie Shaowen (2):
      net: usb: delete extra space and tab in blank line
      net: dsa: Fix spelling mistakes and cleanup code

Xin Gao (1):
      wifi: b43: do not initialise static variable to 0

Xu Kuohai (6):
      bpf: Remove is_valid_bpf_tramp_flags()
      arm64: Add LDR (literal) instruction
      bpf, arm64: Implement bpf_arch_text_poke() for arm64
      bpf, arm64: Add bpf trampoline for arm64
      bpf, arm64: Fix compile error in dummy_tramp()
      bpf: Fix NULL pointer dereference when registering bpf trampoline

Xu Qiang (1):
      wifi: plfxlc: Use eth_zero_addr() to assign zero address

XueBing Chen (3):
      net: ipconfig: use strscpy to replace strlcpy
      net: ip_tunnel: use strscpy to replace strlcpy
      wifi: cfg80211: use strscpy to replace strlcpy

YN Chen (2):
      mt76: mt7921: add PATCH_FINISH_REQ cmd response handling
      mt76: mt7921s: fix firmware download random fail

Yafang Shao (3):
      bpftool: Show also the name of type BPF_OBJ_LINK
      bpf: Make non-preallocated allocation low priority
      bpf: Warn on non-preallocated case for BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE

Yajun Deng (1):
      net: make __sys_accept4_file() static

Yang Li (5):
      wifi: mwifiex: clean up one inconsistent indenting
      wifi: b43legacy: clean up one inconsistent indenting
      tls: rx: Fix unsigned comparison with less than zero
      mlxsw: core_linecards: Remove duplicated include in core_linecard_dev.c
      bpf: Remove unneeded semicolon

Yang Yingliang (4):
      net: pcs-rzn1-miic: fix return value check in miic_probe()
      net: dsa: rzn1-a5psw: add missing of_node_put() in a5psw_pcs_get()
      net: dsa: b53: remove unnecessary spi_set_drvdata()
      bcm63xx_enet: change the driver variables to static

Yevgeny Kliteynik (5):
      net/mlx5: Introduce header-modify-pattern ICM properties
      net/mlx5: Manage ICM of type modify-header pattern
      RDMA/mlx5: Support handling of modify-header pattern ICM area
      net/mlx5: DR, Fix SMFS steering info dump format
      net/mlx5: DR, Add support for flow metering ASO

Ying Hsu (1):
      Bluetooth: Add default wakeup callback for HCI UART driver

Yinjun Zhang (5):
      nfp: flower: support to offload pedit of IPv6 flowinto fields
      nfp: support 48-bit DMA addressing for NFP3800
      nfp: add support for .get_pauseparam()
      nfp: support vepa mode in HW bridge
      nfp: allow TSO packets with metadata prepended in NFDK path

Yishai Hadas (2):
      net/mlx5: Introduce ifc bits for using software vhca id
      net/mlx5: Use software VHCA id when it's supported

Yixun Lan (1):
      libbpf, riscv: Use a0 for RC register

Yonghong Song (20):
      bpf: Add btf enum64 support
      libbpf: Permit 64bit relocation value
      libbpf: Fix an error in 64bit relocation value computation
      libbpf: Refactor btf__add_enum() for future code sharing
      libbpf: Add enum64 parsing and new enum64 public API
      libbpf: Add enum64 deduplication support
      libbpf: Add enum64 support for btf_dump
      libbpf: Add enum64 sanitization
      libbpf: Add enum64 support for bpf linking
      libbpf: Add enum64 relocation support
      bpftool: Add btf enum64 support
      selftests/bpf: Fix selftests failure
      selftests/bpf: Test new enum kflag and enum64 API functions
      selftests/bpf: Add BTF_KIND_ENUM64 unit tests
      selftests/bpf: Test BTF_KIND_ENUM64 for deduplication
      selftests/bpf: Add a test for enum64 value relocations
      docs/bpf: Update documentation for BTF_KIND_ENUM64 support
      libbpf: Fix an unsigned < 0 bug
      selftests/bpf: Fix test_varlen verification failure with latest llvm
      selftests/bpf: Avoid skipping certain subtests

Yonglong Li (1):
      tcp: make retransmitted SKB fit into the send window

Yu Xiao (1):
      nfp: compose firmware file name with new hwinfo "nffw.partno"

Yu Zhe (2):
      amt: remove unnecessary (void*) conversions
      dn_route: replace "jiffies-now>0" with "jiffies!=now"

YueHaibing (1):
      bpf, arm: Remove unused function emit_a32_alu_r()

Yuntao Wang (1):
      selftests/bpf: Fix test_run logic in fexit_stress.c

Yuri D'Elia (1):
      Bluetooth: btusb: Set HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN for MTK

Yuwei Wang (2):
      sysctl: add proc_dointvec_ms_jiffies_minmax
      net, neigh: introduce interval_probe_time_ms for periodic probe

Yuze Chi (1):
      libbpf: Fix is_pow_of_2

Zhang Jiaming (5):
      esp6: Fix spelling mistake
      net: hns: Fix spelling mistakes in comments.
      ath11k: Fix typo in comments
      netfilter: nft_set_bitmap: Fix spelling mistake
      wifi: rtlwifi: Remove duplicate word and Fix typo

Zhengchao Shao (8):
      samples/bpf: Check detach prog exist or not in xdp_fwd
      xfrm: change the type of xfrm_register_km and xfrm_unregister_km
      net: asix: change the type of asix_set_sw/hw_mii to static
      net: change the type of ip_route_input_rcu to static
      net/sched: remove return value of unregister_tcf_proto_ops
      bpf: Don't redirect packets with invalid pkt_len
      net/sched: sch_cbq: change the type of cbq_set_lss to void
      net/af_packet: check len when min_header_len equals to 0

Zhengping Jiang (2):
      Bluetooth: mgmt: Fix refresh cached connection info
      Bluetooth: hci_sync: Fix resuming scan after suspend resume

Zheyu Ma (1):
      wifi: rtl8xxxu: Fix the error handling of the probe function

Zhuo Chen (1):
      ice: Remove pci_aer_clear_nonfatal_status() call

Zijun Hu (5):
      Bluetooth: hci_sync: Correct hci_set_event_mask_page_2_sync() event mask
      Bluetooth: hci_sync: Check LMP feature bit instead of quirk
      Bluetooth: btusb: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for QCA
      Bluetooth: btusb: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING for fake CSR
      Bluetooth: hci_sync: Remove HCI_QUIRK_BROKEN_ERR_DATA_REPORTING

Ziyang Xuan (1):
      ice: Remove unnecessary NULL check before dev_put

Zong-Zhe Yang (2):
      rtw89: sar: adjust and support SAR on 6GHz band
      wifi: rtw89: 8852a: adjust IMR for SER L1

liujing (1):
      tc-testing: gitignore, delete plugins directory

sewookseo (1):
      net: Find dst with sk's xfrm policy not ctl_sk

shaomin Deng (1):
      Bluetooth: btrtl: Fix typo in comment

vikas (1):
      bnxt_en: implement callbacks for devlink selftests

wangjianli (2):
      sfc/falcon: fix repeated words in comments
      sfc/siena: fix repeated words in comments

Łukasz Spintzyk (1):
      net/cdc_ncm: Increase NTB max RX/TX values to 64kb

 .../ABI/testing/sysfs-devices-platform-soc-ipa     |   62 +-
 Documentation/admin-guide/sysctl/net.rst           |   12 +
 Documentation/bpf/btf.rst                          |   49 +-
 Documentation/bpf/index.rst                        |    1 +
 Documentation/bpf/instruction-set.rst              |    4 +-
 Documentation/bpf/kfuncs.rst                       |  170 +
 .../bpf/libbpf/libbpf_naming_convention.rst        |   13 +-
 Documentation/bpf/map_hash.rst                     |  185 +
 .../bindings/net/broadcom-bluetooth.yaml           |   25 +
 .../bindings/net/can/microchip,mpfs-can.yaml       |   45 +
 .../devicetree/bindings/net/can/nxp,sja1000.yaml   |  132 +
 .../devicetree/bindings/net/can/sja1000.txt        |   58 -
 .../devicetree/bindings/net/cdns,macb.yaml         |   11 +-
 .../bindings/net/dsa/hirschmann,hellcreek.yaml     |    2 +-
 .../bindings/net/dsa/mediatek,mt7530.yaml          |  407 +
 .../bindings/net/dsa/microchip,lan937x.yaml        |  192 +
 .../devicetree/bindings/net/dsa/mt7530.txt         |  327 -
 .../bindings/net/dsa/renesas,rzn1-a5psw.yaml       |  157 +
 .../bindings/net/ethernet-controller.yaml          |   35 +-
 Documentation/devicetree/bindings/net/fsl,fec.yaml |   11 +-
 .../bindings/net/mediatek,star-emac.yaml           |   17 +
 Documentation/devicetree/bindings/net/micrel.txt   |    1 +
 .../devicetree/bindings/net/nfc/marvell,nci.yaml   |    4 +-
 .../devicetree/bindings/net/nfc/st,st-nci.yaml     |    5 +-
 .../devicetree/bindings/net/nfc/st,st95hf.yaml     |    7 +-
 .../devicetree/bindings/net/nfc/ti,trf7970a.yaml   |    7 +-
 .../bindings/net/pcs/renesas,rzn1-miic.yaml        |  171 +
 Documentation/devicetree/bindings/net/sff,sfp.txt  |   85 -
 Documentation/devicetree/bindings/net/sff,sfp.yaml |  142 +
 .../devicetree/bindings/net/snps,dwmac.yaml        |    5 +
 .../devicetree/bindings/net/ti,dp83867.yaml        |   18 +-
 .../bindings/net/wireless/brcm,bcm4329-fmac.yaml   |   10 +
 .../bindings/net/wireless/mediatek,mt76.yaml       |   13 +
 .../devicetree/bindings/net/xlnx,emaclite.yaml     |   63 +
 Documentation/networking/bonding.rst               |   11 +
 Documentation/networking/can.rst                   |    2 +-
 .../networking/device_drivers/can/can327.rst       |  331 +
 .../networking/device_drivers/can/index.rst        |    1 +
 .../networking/device_drivers/ethernet/index.rst   |    2 +-
 .../device_drivers/ethernet/intel/ice.rst          |    9 +
 .../device_drivers/ethernet/neterion/vxge.rst      |  115 -
 .../device_drivers/ethernet/wangxun/txgbe.rst      |   20 +
 .../networking/devlink/devlink-selftests.rst       |   38 +
 Documentation/networking/devlink/index.rst         |    1 +
 Documentation/networking/devlink/mlxsw.rst         |   24 +
 Documentation/networking/ip-sysctl.rst             |   68 +-
 Documentation/networking/sfp-phylink.rst           |    6 +-
 Documentation/networking/smc-sysctl.rst            |   13 +
 Documentation/networking/tls.rst                   |   47 +
 MAINTAINERS                                        |   49 +-
 arch/arm/net/bpf_jit_32.c                          |   16 -
 .../dts/freescale/fsl-lx2160a-clearfog-itx.dtsi    |    8 +-
 .../boot/dts/marvell/armada-3720-turris-mox.dts    |   10 +-
 arch/arm64/boot/dts/marvell/armada-3720-uDPU.dts   |   16 +-
 .../boot/dts/marvell/armada-7040-mochabin.dts      |   16 +-
 .../dts/marvell/armada-8040-clearfog-gt-8k.dts     |    4 +-
 arch/arm64/boot/dts/marvell/armada-8040-mcbin.dtsi |   24 +-
 .../boot/dts/marvell/armada-8040-puzzle-m801.dts   |   16 +-
 arch/arm64/boot/dts/marvell/cn9130-crb.dtsi        |    6 +-
 arch/arm64/boot/dts/marvell/cn9130-db.dtsi         |    8 +-
 arch/arm64/boot/dts/marvell/cn9131-db.dtsi         |    8 +-
 arch/arm64/boot/dts/marvell/cn9132-db.dtsi         |    8 +-
 arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts |   48 +
 arch/arm64/include/asm/insn.h                      |    3 +
 arch/arm64/lib/insn.c                              |   30 +-
 arch/arm64/net/bpf_jit.h                           |    7 +
 arch/arm64/net/bpf_jit_comp.c                      |  724 +-
 arch/riscv/boot/dts/microchip/mpfs.dtsi            |   18 +
 arch/riscv/net/bpf_jit.h                           |    1 +
 arch/riscv/net/bpf_jit_core.c                      |    8 +-
 arch/x86/net/bpf_jit_comp.c                        |   88 +-
 drivers/atm/he.c                                   |    9 +-
 drivers/atm/iphase.c                               |    2 +-
 drivers/bluetooth/btbcm.c                          |   33 +-
 drivers/bluetooth/btbcm.h                          |    8 +-
 drivers/bluetooth/btmtksdio.c                      |   15 +
 drivers/bluetooth/btrtl.c                          |    2 +-
 drivers/bluetooth/btusb.c                          |   45 +-
 drivers/bluetooth/hci_bcm.c                        |   35 +-
 drivers/bluetooth/hci_intel.c                      |    6 +-
 drivers/bluetooth/hci_qca.c                        |    2 +-
 drivers/bluetooth/hci_serdev.c                     |   11 +
 drivers/firewire/net.c                             |   14 +-
 drivers/infiniband/hw/mlx5/dm.c                    |   53 +-
 drivers/infiniband/hw/mlx5/mr.c                    |    1 +
 drivers/infiniband/ulp/ipoib/ipoib_ib.c            |    2 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c              |    2 +-
 drivers/net/Kconfig                                |    2 +
 drivers/net/amt.c                                  |   10 +-
 drivers/net/bonding/bond_main.c                    |   51 +-
 drivers/net/bonding/bond_netlink.c                 |  116 +-
 drivers/net/bonding/bond_options.c                 |   65 +-
 drivers/net/can/Kconfig                            |  111 +-
 drivers/net/can/Makefile                           |    3 +-
 drivers/net/can/at91_can.c                         |    6 +
 drivers/net/can/c_can/c_can.h                      |    2 +-
 drivers/net/can/c_can/c_can_ethtool.c              |    8 +-
 drivers/net/can/c_can/c_can_main.c                 |    9 +-
 drivers/net/can/can327.c                           | 1144 +++
 drivers/net/can/cc770/cc770.c                      |    7 +
 drivers/net/can/ctucanfd/ctucanfd_base.c           |   13 +-
 drivers/net/can/ctucanfd/ctucanfd_kregs.h          |   32 +-
 drivers/net/can/dev/Makefile                       |   17 +-
 drivers/net/can/dev/bittiming.c                    |  197 -
 drivers/net/can/dev/calc_bittiming.c               |  202 +
 drivers/net/can/dev/dev.c                          |   59 +-
 drivers/net/can/dev/netlink.c                      |    9 +-
 drivers/net/can/dev/skb.c                          |   78 +
 drivers/net/can/flexcan/flexcan-core.c             |    2 +-
 drivers/net/can/flexcan/flexcan-ethtool.c          |    8 +-
 drivers/net/can/flexcan/flexcan.h                  |    2 +-
 drivers/net/can/grcan.c                            |    7 +
 drivers/net/can/ifi_canfd/ifi_canfd.c              |   10 +-
 drivers/net/can/janz-ican3.c                       |   12 +-
 drivers/net/can/kvaser_pciefd.c                    |    9 +-
 drivers/net/can/m_can/Kconfig                      |    1 +
 drivers/net/can/m_can/m_can.c                      |   14 +-
 drivers/net/can/mscan/mscan.c                      |    5 +
 drivers/net/can/pch_can.c                          |   15 +-
 drivers/net/can/peak_canfd/peak_canfd.c            |   54 +-
 drivers/net/can/rcar/rcar_can.c                    |   15 +-
 drivers/net/can/rcar/rcar_canfd.c                  |   10 +-
 drivers/net/can/sja1000/sja1000.c                  |   22 +-
 drivers/net/can/sja1000/sja1000.h                  |    3 +-
 drivers/net/can/sja1000/sja1000_platform.c         |   20 +-
 drivers/net/can/slcan.c                            |  793 --
 drivers/net/can/slcan/Makefile                     |    7 +
 drivers/net/can/slcan/slcan-core.c                 |  939 +++
 drivers/net/can/slcan/slcan-ethtool.c              |   61 +
 drivers/net/can/slcan/slcan.h                      |   19 +
 drivers/net/can/softing/softing_main.c             |   10 +-
 drivers/net/can/spi/hi311x.c                       |   12 +-
 drivers/net/can/spi/mcp251x.c                      |    6 +
 drivers/net/can/spi/mcp251xfd/Kconfig              |    1 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |    2 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c     |    2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c  |    1 +
 drivers/net/can/sun4i_can.c                        |   16 +-
 drivers/net/can/ti_hecc.c                          |    7 +
 drivers/net/can/usb/Kconfig                        |   15 +-
 drivers/net/can/usb/Makefile                       |    2 +-
 drivers/net/can/usb/ems_usb.c                      |   10 +-
 drivers/net/can/usb/{esd_usb2.c => esd_usb.c}      |  259 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c        |   39 +-
 drivers/net/can/usb/etas_es58x/es58x_core.h        |    6 +-
 drivers/net/can/usb/gs_usb.c                       |    8 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h        |    1 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   29 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |   14 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |    7 +-
 drivers/net/can/usb/mcba_usb.c                     |    6 +
 drivers/net/can/usb/peak_usb/pcan_usb.c            |    2 +
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   43 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.h       |    3 +-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |   69 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |    3 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.h        |    2 +-
 drivers/net/can/usb/ucan.c                         |    6 +
 drivers/net/can/usb/usb_8dev.c                     |   18 +-
 drivers/net/can/vcan.c                             |    8 +
 drivers/net/can/vxcan.c                            |    8 +
 drivers/net/can/xilinx_can.c                       |   79 +-
 drivers/net/dsa/Kconfig                            |   17 +-
 drivers/net/dsa/Makefile                           |    2 +-
 drivers/net/dsa/b53/b53_spi.c                      |    2 -
 drivers/net/dsa/hirschmann/hellcreek.c             |    7 +-
 drivers/net/dsa/microchip/Kconfig                  |   42 +-
 drivers/net/dsa/microchip/Makefile                 |   11 +-
 drivers/net/dsa/microchip/ksz8.h                   |  105 +-
 drivers/net/dsa/microchip/ksz8795.c                |  623 +-
 drivers/net/dsa/microchip/ksz8795_reg.h            |   37 -
 drivers/net/dsa/microchip/ksz8863_smi.c            |   19 +-
 drivers/net/dsa/microchip/ksz9477.c                |  518 +-
 drivers/net/dsa/microchip/ksz9477.h                |   60 +
 drivers/net/dsa/microchip/ksz9477_i2c.c            |    6 +-
 drivers/net/dsa/microchip/ksz9477_reg.h            |   46 -
 drivers/net/dsa/microchip/ksz9477_spi.c            |  150 -
 drivers/net/dsa/microchip/ksz_common.c             | 1127 ++-
 drivers/net/dsa/microchip/ksz_common.h             |  251 +-
 .../net/dsa/microchip/{ksz8795_spi.c => ksz_spi.c} |  125 +-
 drivers/net/dsa/microchip/lan937x.h                |   21 +
 drivers/net/dsa/microchip/lan937x_main.c           |  443 ++
 drivers/net/dsa/microchip/lan937x_reg.h            |  184 +
 drivers/net/dsa/mt7530.c                           |   82 +-
 drivers/net/dsa/mt7530.h                           |    1 -
 drivers/net/dsa/mv88e6xxx/chip.c                   |   44 +-
 drivers/net/dsa/mv88e6xxx/chip.h                   |    3 +-
 drivers/net/dsa/mv88e6xxx/port.c                   |   36 -
 drivers/net/dsa/mv88e6xxx/port.h                   |    2 -
 drivers/net/dsa/ocelot/Kconfig                     |    1 +
 drivers/net/dsa/ocelot/felix.c                     |    9 +
 drivers/net/dsa/ocelot/felix.h                     |    1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c             |  289 +-
 drivers/net/dsa/qca/Kconfig                        |    8 +
 drivers/net/dsa/qca/Makefile                       |    2 +
 drivers/net/dsa/qca/ar9331.c                       |   34 +-
 drivers/net/dsa/{qca8k.c => qca/qca8k-8xxx.c}      | 1711 +---
 drivers/net/dsa/qca/qca8k-common.c                 | 1210 +++
 drivers/net/dsa/{ => qca}/qca8k.h                  |  100 +
 drivers/net/dsa/realtek/rtl8365mb.c                |  299 +-
 drivers/net/dsa/rzn1_a5psw.c                       | 1064 +++
 drivers/net/dsa/rzn1_a5psw.h                       |  259 +
 drivers/net/dsa/sja1105/sja1105_main.c             |    2 +-
 drivers/net/eql.c                                  |    4 +-
 drivers/net/ethernet/Kconfig                       |    1 +
 drivers/net/ethernet/Makefile                      |    1 +
 drivers/net/ethernet/agere/et131x.c                |    2 +-
 drivers/net/ethernet/altera/altera_utils.h         |    5 +-
 drivers/net/ethernet/amd/amd8111e.c                |    3 -
 drivers/net/ethernet/amd/xgbe/xgbe-dcb.c           |    2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |    6 +-
 drivers/net/ethernet/amd/xgbe/xgbe.h               |    2 +-
 .../aquantia/atlantic/macsec/macsec_struct.h       |    4 +-
 drivers/net/ethernet/atheros/ag71xx.c              |   12 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |   15 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |   10 +-
 drivers/net/ethernet/atheros/atlx/atl1.c           |    7 +-
 drivers/net/ethernet/broadcom/bcm63xx_enet.c       |   16 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |   17 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   15 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |   61 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   24 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h  |   12 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c    |    2 +-
 drivers/net/ethernet/broadcom/cnic.c               |    4 +-
 drivers/net/ethernet/broadcom/tg3.c                |    2 +-
 drivers/net/ethernet/brocade/bna/bnad.c            |    6 +-
 drivers/net/ethernet/cadence/macb.h                |    5 +-
 drivers/net/ethernet/cadence/macb_main.c           |  142 +-
 drivers/net/ethernet/cadence/macb_ptp.c            |    7 +-
 drivers/net/ethernet/cavium/thunder/nicvf_queues.c |    4 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_dcb.c     |    2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |    6 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c |    8 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   27 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |    2 +-
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |    2 +-
 drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c     |    2 +-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c      |    6 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |    5 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |    8 +-
 drivers/net/ethernet/freescale/fec_main.c          |    2 +-
 drivers/net/ethernet/freescale/fs_enet/fs_enet.h   |    2 +-
 drivers/net/ethernet/freescale/gianfar.c           |    1 +
 drivers/net/ethernet/freescale/gianfar_ethtool.c   |    6 +-
 drivers/net/ethernet/fungible/funcore/fun_hci.h    |   40 +
 .../net/ethernet/fungible/funeth/funeth_ethtool.c  |   36 +
 drivers/net/ethernet/fungible/funeth/funeth_main.c |    3 +-
 drivers/net/ethernet/fungible/funeth/funeth_tx.c   |  160 +-
 drivers/net/ethernet/fungible/funeth/funeth_txrx.h |    1 +
 drivers/net/ethernet/google/gve/gve_tx_dqo.c       |    6 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |    6 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |    4 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_trace.h   |    3 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |    2 +-
 drivers/net/ethernet/hisilicon/hns_mdio.c          |    4 +-
 drivers/net/ethernet/huawei/hinic/hinic_dev.h      |    3 -
 drivers/net/ethernet/huawei/hinic/hinic_main.c     |   68 +-
 drivers/net/ethernet/huawei/hinic/hinic_rx.c       |    2 -
 drivers/net/ethernet/huawei/hinic/hinic_sriov.c    |    6 -
 drivers/net/ethernet/huawei/hinic/hinic_tx.c       |    2 -
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |    2 +-
 drivers/net/ethernet/intel/e100.c                  |    1 -
 drivers/net/ethernet/intel/e1000/e1000_hw.c        |    6 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |    4 +-
 drivers/net/ethernet/intel/e1000/e1000_param.c     |    2 -
 drivers/net/ethernet/intel/e1000e/e1000.h          |    2 +-
 drivers/net/ethernet/intel/e1000e/mac.c            |    2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |    8 +-
 drivers/net/ethernet/intel/e1000e/param.c          |    2 -
 drivers/net/ethernet/intel/e1000e/ptp.c            |   18 +-
 drivers/net/ethernet/intel/fm10k/fm10k_mbx.c       |    4 +-
 drivers/net/ethernet/intel/fm10k/fm10k_tlv.c       |    4 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |   15 +
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |  103 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  159 +-
 drivers/net/ethernet/intel/i40e/i40e_ptp.c         |   36 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |  105 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |    8 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |   17 +-
 drivers/net/ethernet/intel/iavf/iavf.h             |   13 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |  230 +-
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |   65 +-
 drivers/net/ethernet/intel/ice/ice.h               |    8 +-
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h    |    7 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |   47 +-
 drivers/net/ethernet/intel/ice/ice_common.h        |    4 +
 drivers/net/ethernet/intel/ice/ice_eswitch.c       |    8 +-
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |    2 +-
 drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c  |    4 +-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c     |    7 +-
 drivers/net/ethernet/intel/ice/ice_gnss.c          |  253 +-
 drivers/net/ethernet/intel/ice/ice_gnss.h          |   30 +-
 drivers/net/ethernet/intel/ice/ice_lag.c           |    6 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |   73 +-
 drivers/net/ethernet/intel/ice/ice_lib.h           |   11 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   94 +-
 drivers/net/ethernet/intel/ice/ice_protocol_type.h |   20 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           |   34 +-
 drivers/net/ethernet/intel/ice/ice_sriov.c         |   10 -
 drivers/net/ethernet/intel/ice/ice_switch.c        |  687 +-
 drivers/net/ethernet/intel/ice/ice_switch.h        |    9 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.c        |  137 +-
 drivers/net/ethernet/intel/ice/ice_tc_lib.h        |   11 +
 drivers/net/ethernet/intel/ice/ice_type.h          |    4 -
 drivers/net/ethernet/intel/ice/ice_vf_lib.c        |   89 +-
 drivers/net/ethernet/intel/ice/ice_vf_lib.h        |    7 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl.c      |  172 +-
 drivers/net/ethernet/intel/ice/ice_vlan_mode.c     |    1 -
 drivers/net/ethernet/intel/igb/e1000_82575.c       |    2 +-
 drivers/net/ethernet/intel/igb/e1000_defines.h     |    3 -
 drivers/net/ethernet/intel/igb/e1000_mac.c         |    2 +-
 drivers/net/ethernet/intel/igb/e1000_regs.h        |    1 -
 drivers/net/ethernet/intel/igb/igb_main.c          |  123 +-
 drivers/net/ethernet/intel/igb/igb_ptp.c           |   15 +-
 drivers/net/ethernet/intel/igbvf/igbvf.h           |    2 +-
 drivers/net/ethernet/intel/igbvf/netdev.c          |    2 +-
 drivers/net/ethernet/intel/igc/igc_hw.h            |    2 -
 drivers/net/ethernet/intel/igc/igc_mac.c           |    2 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |   23 +-
 drivers/net/ethernet/intel/igc/igc_ptp.c           |    1 -
 drivers/net/ethernet/intel/igc/igc_regs.h          |    3 -
 drivers/net/ethernet/intel/ixgb/ixgb_hw.c          |    4 +-
 drivers/net/ethernet/intel/ixgb/ixgb_main.c        |    3 +-
 drivers/net/ethernet/intel/ixgb/ixgb_param.c       |    2 -
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |   34 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_82598.c     |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c    |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_dcb_nl.c    |    2 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |    2 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   88 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c       |   74 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h      |    7 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c      |    4 +-
 drivers/net/ethernet/intel/ixgbevf/ethtool.c       |    4 -
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |    2 +-
 drivers/net/ethernet/intel/ixgbevf/vf.c            |    2 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c         |    2 +-
 drivers/net/ethernet/marvell/mvneta.c              |    4 +-
 drivers/net/ethernet/marvell/octeontx2/af/Makefile |    2 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |   69 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |    2 +-
 .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  |    2 +
 .../ethernet/marvell/octeontx2/af/lmac_common.h    |    1 +
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   45 +-
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |   25 +
 .../ethernet/marvell/octeontx2/af/npc_profile.h    |    5 +-
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c    |   51 +-
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h    |    5 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   16 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   26 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |   57 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cpt.c    |    4 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  179 +
 .../ethernet/marvell/octeontx2/af/rvu_devlink.c    |   71 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   41 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |   53 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |  161 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h |   17 +
 .../ethernet/marvell/octeontx2/af/rvu_npc_hash.c   | 2009 +++++
 .../ethernet/marvell/octeontx2/af/rvu_npc_hash.h   |  233 +
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |   15 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   10 +-
 .../ethernet/marvell/octeontx2/nic/otx2_dmac_flt.c |   59 +-
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |   40 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |    2 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |    4 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |    2 +-
 drivers/net/ethernet/marvell/prestera/Kconfig      |    1 +
 drivers/net/ethernet/marvell/prestera/prestera.h   |   60 +-
 .../net/ethernet/marvell/prestera/prestera_acl.c   |   47 +-
 .../net/ethernet/marvell/prestera/prestera_acl.h   |    4 +-
 .../ethernet/marvell/prestera/prestera_ethtool.c   |   28 +-
 .../ethernet/marvell/prestera/prestera_ethtool.h   |    3 -
 .../net/ethernet/marvell/prestera/prestera_flow.c  |   52 +-
 .../net/ethernet/marvell/prestera/prestera_flow.h  |    1 +
 .../ethernet/marvell/prestera/prestera_flower.c    |   36 +-
 .../net/ethernet/marvell/prestera/prestera_hw.c    |  256 +-
 .../net/ethernet/marvell/prestera/prestera_hw.h    |   22 +-
 .../net/ethernet/marvell/prestera/prestera_main.c  |  547 +-
 .../ethernet/marvell/prestera/prestera_router.c    |    4 +-
 .../ethernet/marvell/prestera/prestera_switchdev.c |  706 +-
 drivers/net/ethernet/marvell/sky2.c                |    4 +-
 drivers/net/ethernet/mediatek/Kconfig              |    2 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  668 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |   34 +-
 drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |   30 +-
 drivers/net/ethernet/mediatek/mtk_star_emac.c      |  529 +-
 drivers/net/ethernet/mellanox/mlx4/catas.c         |    5 +
 drivers/net/ethernet/mellanox/mlx4/crdump.c        |   20 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |    4 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |   40 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   12 +-
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c  |   24 +
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |   18 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   55 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   46 +-
 .../net/ethernet/mellanox/mlx5/core/en/devlink.c   |   16 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |   44 +-
 .../mellanox/mlx5/core/en/fs_tt_redirect.c         |   72 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/htb.c   |  722 ++
 drivers/net/ethernet/mellanox/mlx5/core/en/htb.h   |   46 +
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |   12 +
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |   45 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h   |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.c   |  813 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/qos.h   |   37 +-
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |    6 +
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |  117 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/selq.c  |   51 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/selq.h  |    4 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.c    |    4 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/act.h    |   13 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/goto.c   |    2 +-
 .../ethernet/mellanox/mlx5/core/en/tc/act/police.c |  153 +
 .../ethernet/mellanox/mlx5/core/en/tc/act/trap.c   |    2 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc/meter.c  |  579 ++
 .../net/ethernet/mellanox/mlx5/core/en/tc/meter.h  |   74 +
 .../ethernet/mellanox/mlx5/core/en/tc/post_act.c   |    9 +-
 .../ethernet/mellanox/mlx5/core/en/tc/post_meter.c |  209 +
 .../ethernet/mellanox/mlx5/core/en/tc/post_meter.h |   29 +
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |    6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |   11 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_priv.h   |    9 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h    |   14 +
 .../mellanox/mlx5/core/en_accel/en_accel.h         |   10 +
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c  |   32 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |   10 +-
 .../mellanox/mlx5/core/en_accel/ipsec_fs.h         |   21 -
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    |    2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |   14 +
 .../mellanox/mlx5/core/en_accel/ktls_stats.c       |    2 +
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |  515 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |   58 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   16 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |  554 +-
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |   29 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  318 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   36 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |    3 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   14 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |    2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  208 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   12 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   14 +-
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   |  408 +-
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.h   |    6 +-
 .../net/ethernet/mellanox/mlx5/core/esw/debugfs.c  |  182 +
 .../ethernet/mellanox/mlx5/core/esw/devlink_port.c |   20 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  123 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   26 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  170 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |   33 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   18 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |    4 +
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |   10 +-
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |    4 +
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |    2 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   20 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c  |   10 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c  |  433 ++
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h  |   87 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/dm.c   |   53 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c |   11 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h |    1 -
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   99 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |    2 +
 .../net/ethernet/mellanox/mlx5/core/sf/devlink.c   |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |    9 +-
 .../mellanox/mlx5/core/steering/dr_action.c        |   99 +
 .../ethernet/mellanox/mlx5/core/steering/dr_dbg.c  |   13 +-
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        |   56 +
 .../mellanox/mlx5/core/steering/dr_types.h         |   17 +
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |   21 +
 .../mellanox/mlx5/core/steering/mlx5_ifc_dr.h      |   26 +
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |    8 +
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |   14 +-
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c |    4 +-
 drivers/net/ethernet/mellanox/mlxsw/Kconfig        |    1 +
 drivers/net/ethernet/mellanox/mlxsw/Makefile       |    6 +-
 drivers/net/ethernet/mellanox/mlxsw/cmd.h          |  106 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c         |  123 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h         |   63 +-
 .../mellanox/mlxsw/core_acl_flex_actions.c         |    2 +-
 drivers/net/ethernet/mellanox/mlxsw/core_env.c     |    2 +-
 .../ethernet/mellanox/mlxsw/core_linecard_dev.c    |  183 +
 .../net/ethernet/mellanox/mlxsw/core_linecards.c   |  405 +
 drivers/net/ethernet/mellanox/mlxsw/minimal.c      |    3 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c          |  138 +-
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h       |   81 +-
 drivers/net/ethernet/mellanox/mlxsw/port.h         |    2 -
 drivers/net/ethernet/mellanox/mlxsw/reg.h          | 1298 ++--
 drivers/net/ethernet/mellanox/mlxsw/resources.h    |    4 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  298 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |   69 +-
 .../net/ethernet/mellanox/mlxsw/spectrum1_kvdl.c   |   82 +-
 .../net/ethernet/mellanox/mlxsw/spectrum2_kvdl.c   |    2 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_buffers.c |   14 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_cnt.c |   62 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_dpipe.c   |   92 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c | 1072 ++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_pgt.c |  346 +
 .../net/ethernet/mellanox/mlxsw/spectrum_policer.c |   32 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c |  718 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h |   60 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  | 1052 +--
 .../net/ethernet/mellanox/mlxsw/spectrum_router.h  |   77 +-
 .../ethernet/mellanox/mlxsw/spectrum_router_xm.c   |  812 --
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c    |    6 +-
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c   |  842 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_trap.c    |   35 +-
 drivers/net/ethernet/mellanox/mlxsw/trap.h         |    4 +-
 drivers/net/ethernet/microchip/lan743x_ethtool.c   |   63 +-
 drivers/net/ethernet/microchip/lan743x_ethtool.h   |   26 +
 drivers/net/ethernet/microchip/lan743x_main.c      |  378 +-
 drivers/net/ethernet/microchip/lan743x_main.h      |  106 +
 .../ethernet/microchip/sparx5/sparx5_switchdev.c   |   55 +-
 drivers/net/ethernet/microsoft/mana/gdma.h         |   10 +
 drivers/net/ethernet/microsoft/mana/gdma_main.c    |   39 +-
 drivers/net/ethernet/microsoft/mana/hw_channel.c   |   18 +-
 drivers/net/ethernet/microsoft/mana/hw_channel.h   |    5 +
 drivers/net/ethernet/microsoft/mana/mana.h         |   70 +
 drivers/net/ethernet/microsoft/mana/mana_bpf.c     |   64 +
 drivers/net/ethernet/microsoft/mana/mana_en.c      |  148 +-
 drivers/net/ethernet/microsoft/mana/mana_ethtool.c |   12 +-
 drivers/net/ethernet/mscc/ocelot.c                 |    1 +
 drivers/net/ethernet/mscc/ocelot_ptp.c             |    8 +
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |    2 +-
 drivers/net/ethernet/natsemi/natsemi.c             |    2 +-
 drivers/net/ethernet/neterion/Kconfig              |   24 -
 drivers/net/ethernet/neterion/Makefile             |    1 -
 drivers/net/ethernet/neterion/s2io.c               |   10 +-
 drivers/net/ethernet/neterion/vxge/Makefile        |    8 -
 drivers/net/ethernet/neterion/vxge/vxge-config.c   | 5099 ------------
 drivers/net/ethernet/neterion/vxge/vxge-config.h   | 2086 -----
 drivers/net/ethernet/neterion/vxge/vxge-ethtool.c  | 1154 ---
 drivers/net/ethernet/neterion/vxge/vxge-ethtool.h  |   48 -
 drivers/net/ethernet/neterion/vxge/vxge-main.c     | 4808 ------------
 drivers/net/ethernet/neterion/vxge/vxge-main.h     |  516 --
 drivers/net/ethernet/neterion/vxge/vxge-reg.h      | 4636 -----------
 drivers/net/ethernet/neterion/vxge/vxge-traffic.c  | 2428 ------
 drivers/net/ethernet/neterion/vxge/vxge-traffic.h  | 2290 ------
 drivers/net/ethernet/neterion/vxge/vxge-version.h  |   49 -
 drivers/net/ethernet/netronome/nfp/flower/action.c |   23 +-
 drivers/net/ethernet/netronome/nfp/flower/cmsg.h   |    2 -
 .../net/ethernet/netronome/nfp/flower/conntrack.c  |   14 +-
 .../net/ethernet/netronome/nfp/flower/lag_conf.c   |    4 +-
 .../net/ethernet/netronome/nfp/flower/metadata.c   |    2 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |    4 +-
 .../net/ethernet/netronome/nfp/flower/qos_conf.c   |    6 +-
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    |    2 +-
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c       |   84 +-
 drivers/net/ethernet/netronome/nfp/nfd3/rings.c    |    4 +
 drivers/net/ethernet/netronome/nfp/nfd3/xsk.c      |   17 +-
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c       |  122 +-
 drivers/net/ethernet/netronome/nfp/nfdk/rings.c    |    5 +-
 drivers/net/ethernet/netronome/nfp/nfp_app.c       |    2 +-
 drivers/net/ethernet/netronome/nfp/nfp_main.c      |    6 +-
 drivers/net/ethernet/netronome/nfp/nfp_net.h       |   27 +-
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |  153 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h  |   18 +
 drivers/net/ethernet/netronome/nfp/nfp_net_dp.c    |   24 +
 drivers/net/ethernet/netronome/nfp/nfp_net_dp.h    |    4 +
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |  220 +
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c  |   12 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_xsk.c   |    8 +-
 drivers/net/ethernet/netronome/nfp/nfpcore/crc32.h |    1 -
 .../net/ethernet/netronome/nfp/nfpcore/nfp_cpp.h   |   26 +-
 .../net/ethernet/netronome/nfp/nfpcore/nfp_dev.c   |    4 +-
 .../net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h   |    2 +
 .../ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c   |   30 +
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |    2 +-
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |    5 +-
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |    2 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |    4 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c          |    2 +-
 drivers/net/ethernet/qlogic/qed/qed_rdma.c         |    7 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |    8 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c     |    2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c   |    6 +-
 drivers/net/ethernet/qualcomm/emac/emac-mac.c      |    6 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |    2 +-
 drivers/net/ethernet/sfc/Makefile                  |    3 +-
 drivers/net/ethernet/sfc/ef10.c                    |   30 +-
 drivers/net/ethernet/sfc/ef100.c                   |   70 +-
 drivers/net/ethernet/sfc/ef100_ethtool.c           |    2 +-
 drivers/net/ethernet/sfc/ef100_netdev.c            |  148 +-
 drivers/net/ethernet/sfc/ef100_netdev.h            |    9 +-
 drivers/net/ethernet/sfc/ef100_nic.c               |  510 +-
 drivers/net/ethernet/sfc/ef100_nic.h               |   13 +-
 drivers/net/ethernet/sfc/ef100_regs.h              |   83 +-
 drivers/net/ethernet/sfc/ef100_rep.c               |  435 ++
 drivers/net/ethernet/sfc/ef100_rep.h               |   69 +
 drivers/net/ethernet/sfc/ef100_rx.c                |   46 +-
 drivers/net/ethernet/sfc/ef100_sriov.c             |   32 +-
 drivers/net/ethernet/sfc/ef100_sriov.h             |    2 +-
 drivers/net/ethernet/sfc/ef100_tx.c                |   84 +-
 drivers/net/ethernet/sfc/ef100_tx.h                |    3 +
 drivers/net/ethernet/sfc/ef10_sriov.c              |   16 +-
 drivers/net/ethernet/sfc/efx.c                     |   73 +-
 drivers/net/ethernet/sfc/efx.h                     |    9 +-
 drivers/net/ethernet/sfc/efx_common.c              |  115 +-
 drivers/net/ethernet/sfc/efx_common.h              |   19 +-
 drivers/net/ethernet/sfc/ethtool.c                 |   22 +-
 drivers/net/ethernet/sfc/ethtool_common.c          |   51 +-
 drivers/net/ethernet/sfc/falcon/bitfield.h         |    2 +-
 drivers/net/ethernet/sfc/falcon/farch.c            |    6 +-
 drivers/net/ethernet/sfc/falcon/net_driver.h       |    2 +-
 drivers/net/ethernet/sfc/filter.h                  |   18 +
 drivers/net/ethernet/sfc/mae.c                     |  346 +
 drivers/net/ethernet/sfc/mae.h                     |   42 +
 drivers/net/ethernet/sfc/mcdi.c                    |   63 +-
 drivers/net/ethernet/sfc/mcdi.h                    |    5 +
 drivers/net/ethernet/sfc/mcdi_filters.c            |    6 +-
 drivers/net/ethernet/sfc/mcdi_filters.h            |    1 +
 drivers/net/ethernet/sfc/mcdi_pcol.h               | 8190 +++++++++++++++++++-
 drivers/net/ethernet/sfc/mcdi_pcol_mae.h           |   24 +
 drivers/net/ethernet/sfc/mcdi_port.c               |    4 +-
 drivers/net/ethernet/sfc/net_driver.h              |   79 +-
 drivers/net/ethernet/sfc/rx_common.c               |    8 +-
 drivers/net/ethernet/sfc/siena/farch.c             |    6 +-
 drivers/net/ethernet/sfc/siena/mcdi.c              |    2 +-
 drivers/net/ethernet/sfc/siena/mcdi_pcol.h         |   10 +-
 drivers/net/ethernet/sfc/siena/net_driver.h        |    2 +-
 drivers/net/ethernet/sfc/sriov.c                   |   10 +-
 drivers/net/ethernet/sfc/tc.c                      |  252 +
 drivers/net/ethernet/sfc/tc.h                      |   85 +
 drivers/net/ethernet/sfc/tx.c                      |   10 +-
 drivers/net/ethernet/sfc/tx_common.c               |   35 +-
 drivers/net/ethernet/sfc/tx_common.h               |    3 +-
 drivers/net/ethernet/stmicro/stmmac/Kconfig        |    3 +
 drivers/net/ethernet/stmicro/stmmac/chain_mode.c   |    6 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |   34 +-
 .../net/ethernet/stmicro/stmmac/dwmac-ipq806x.c    |  157 +-
 drivers/net/ethernet/stmicro/stmmac/mmc_core.c     |    2 +-
 drivers/net/ethernet/stmicro/stmmac/ring_mode.c    |    4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |   21 +-
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |    4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  737 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c  |   14 +
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |    8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |    6 +-
 drivers/net/ethernet/sun/cassini.c                 |    2 +-
 drivers/net/ethernet/sun/cassini.h                 |    2 +-
 drivers/net/ethernet/sun/ldmvsw.c                  |    2 +-
 drivers/net/ethernet/sun/sungem.c                  |    2 +-
 drivers/net/ethernet/sunplus/spl2sw_driver.c       |    2 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-net.c     |    2 +-
 drivers/net/ethernet/via/via-velocity.h            |    2 +-
 drivers/net/ethernet/wangxun/Kconfig               |   32 +
 drivers/net/ethernet/wangxun/Makefile              |    6 +
 drivers/net/ethernet/wangxun/txgbe/Makefile        |    9 +
 drivers/net/ethernet/wangxun/txgbe/txgbe.h         |   24 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c    |  166 +
 drivers/net/ethernet/wangxun/txgbe/txgbe_type.h    |   57 +
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c  |    2 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c           |   15 +-
 drivers/net/fddi/skfp/fplustm.c                    |    2 +-
 drivers/net/geneve.c                               |    1 +
 drivers/net/ipa/Makefile                           |   10 +-
 drivers/net/ipa/{ => data}/ipa_data-v3.1.c         |    8 +-
 drivers/net/ipa/{ => data}/ipa_data-v3.5.1.c       |    8 +-
 drivers/net/ipa/{ => data}/ipa_data-v4.11.c        |    8 +-
 drivers/net/ipa/{ => data}/ipa_data-v4.2.c         |    8 +-
 drivers/net/ipa/{ => data}/ipa_data-v4.5.c         |    8 +-
 drivers/net/ipa/{ => data}/ipa_data-v4.9.c         |    8 +-
 drivers/net/ipa/gsi.c                              |  252 +-
 drivers/net/ipa/gsi.h                              |   26 +-
 drivers/net/ipa/gsi_private.h                      |   24 +-
 drivers/net/ipa/gsi_trans.c                        |  197 +-
 drivers/net/ipa/gsi_trans.h                        |   15 +-
 drivers/net/ipa/ipa_cmd.c                          |    8 +-
 drivers/net/ipa/ipa_endpoint.c                     |   27 +-
 drivers/net/ipa/ipa_endpoint.h                     |    4 +-
 drivers/net/ipa/ipa_main.c                         |    3 +
 drivers/net/ipa/ipa_sysfs.c                        |   69 +-
 drivers/net/ipa/ipa_sysfs.h                        |    1 +
 drivers/net/ipvlan/ipvlan.h                        |   10 +-
 drivers/net/ipvlan/ipvlan_core.c                   |    6 +-
 drivers/net/ipvlan/ipvlan_main.c                   |   18 +-
 drivers/net/macsec.c                               |   12 +-
 drivers/net/macvlan.c                              |   22 +-
 drivers/net/netconsole.c                           |    2 +-
 drivers/net/netdevsim/bpf.c                        |    8 +-
 drivers/net/netdevsim/bus.c                        |   19 -
 drivers/net/netdevsim/dev.c                        |  128 +-
 drivers/net/netdevsim/fib.c                        |  103 +-
 drivers/net/netdevsim/netdevsim.h                  |    3 -
 drivers/net/pcs/Kconfig                            |   12 +-
 drivers/net/pcs/Makefile                           |    1 +
 drivers/net/pcs/pcs-lynx.c                         |   80 +-
 drivers/net/pcs/pcs-rzn1-miic.c                    |  531 ++
 drivers/net/pcs/pcs-xpcs.c                         |  168 +-
 drivers/net/pcs/pcs-xpcs.h                         |    1 -
 drivers/net/phy/Kconfig                            |    7 +
 drivers/net/phy/Makefile                           |    1 +
 drivers/net/phy/aquantia_main.c                    |   20 +
 drivers/net/phy/bcm-phy-lib.h                      |   19 +
 drivers/net/phy/bcm-phy-ptp.c                      |  944 +++
 drivers/net/phy/broadcom.c                         |   48 +-
 drivers/net/phy/dp83867.c                          |   55 +-
 drivers/net/phy/dp83td510.c                        |   49 +
 drivers/net/phy/fixed_phy.c                        |    1 +
 drivers/net/phy/marvell-88x2222.c                  |    2 +
 drivers/net/phy/marvell.c                          |   10 +-
 drivers/net/phy/micrel.c                           |   73 +-
 drivers/net/phy/mxl-gpy.c                          |  162 +-
 drivers/net/phy/nxp-tja11xx.c                      |   11 +-
 drivers/net/phy/phy_device.c                       |   18 +-
 drivers/net/phy/phylink.c                          |   74 +-
 drivers/net/phy/sfp.c                              |   10 +-
 drivers/net/phy/smsc.c                             |   13 +-
 drivers/net/ppp/ppp_generic.c                      |    2 +-
 drivers/net/team/team.c                            |   26 +-
 drivers/net/usb/Kconfig                            |    3 +-
 drivers/net/usb/asix.h                             |    3 -
 drivers/net/usb/asix_common.c                      |   40 +-
 drivers/net/usb/ax88179_178a.c                     |  345 +-
 drivers/net/usb/catc.c                             |   46 +-
 drivers/net/usb/cdc_eem.c                          |    2 +-
 drivers/net/usb/cdc_ncm.c                          |   25 +-
 drivers/net/usb/cdc_subset.c                       |   10 +-
 drivers/net/usb/kaweth.c                           |    2 +-
 drivers/net/usb/plusb.c                            |    2 +-
 drivers/net/usb/smsc95xx.c                         |  207 +-
 drivers/net/usb/usbnet.c                           |   21 +-
 drivers/net/vmxnet3/Makefile                       |    2 +-
 drivers/net/vmxnet3/upt1_defs.h                    |    2 +-
 drivers/net/vmxnet3/vmxnet3_defs.h                 |   80 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |  290 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c              |  151 +-
 drivers/net/vmxnet3/vmxnet3_int.h                  |   24 +-
 drivers/net/vrf.c                                  |   10 +-
 drivers/net/vxlan/vxlan_core.c                     |   19 +-
 drivers/net/wan/farsync.h                          |    2 +-
 drivers/net/wireguard/allowedips.c                 |    9 +-
 drivers/net/wireguard/receive.c                    |    9 +-
 drivers/net/wireguard/selftest/allowedips.c        |    6 +-
 drivers/net/wireguard/selftest/ratelimiter.c       |   25 +-
 drivers/net/wireless/admtek/adm8211.c              |    2 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |   12 +-
 drivers/net/wireless/ath/ath10k/core.c             |   11 +-
 drivers/net/wireless/ath/ath10k/core.h             |    1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c           |    8 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c           |   61 +-
 drivers/net/wireless/ath/ath10k/mac.c              |  118 +-
 drivers/net/wireless/ath/ath10k/qmi.c              |    4 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |    5 +-
 drivers/net/wireless/ath/ath10k/txrx.c             |   15 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |    2 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |    4 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |   56 +-
 drivers/net/wireless/ath/ath11k/core.c             |  103 +-
 drivers/net/wireless/ath/ath11k/core.h             |   10 +-
 drivers/net/wireless/ath/ath11k/debug.h            |    4 +-
 .../net/wireless/ath/ath11k/debugfs_htt_stats.c    |   88 +-
 .../net/wireless/ath/ath11k/debugfs_htt_stats.h    |   39 +
 drivers/net/wireless/ath/ath11k/dp_rx.c            |    8 +-
 drivers/net/wireless/ath/ath11k/hal.c              |    2 +-
 drivers/net/wireless/ath/ath11k/hal_rx.c           |    2 +-
 drivers/net/wireless/ath/ath11k/htc.c              |    4 +-
 drivers/net/wireless/ath/ath11k/hw.h               |    5 -
 drivers/net/wireless/ath/ath11k/mac.c              |  128 +-
 drivers/net/wireless/ath/ath11k/mac.h              |    2 -
 drivers/net/wireless/ath/ath11k/pci.c              |   72 +-
 drivers/net/wireless/ath/ath11k/pcic.c             |   57 +-
 drivers/net/wireless/ath/ath11k/pcic.h             |    2 +
 drivers/net/wireless/ath/ath11k/qmi.c              |    6 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |   47 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |   25 -
 drivers/net/wireless/ath/ath5k/base.c              |    4 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |   19 +-
 drivers/net/wireless/ath/ath5k/phy.c               |    2 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |    8 +-
 drivers/net/wireless/ath/ath6kl/hif.h              |    2 +-
 drivers/net/wireless/ath/ath6kl/sdio.c             |    2 +-
 drivers/net/wireless/ath/ath6kl/usb.c              |   16 +-
 drivers/net/wireless/ath/ath6kl/wmi.h              |    4 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.c        |    2 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |   15 +-
 drivers/net/wireless/ath/ath9k/dfs.c               |    2 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   26 +-
 drivers/net/wireless/ath/ath9k/htc.h               |   32 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |    4 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   21 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   10 +-
 drivers/net/wireless/ath/ath9k/main.c              |   15 +-
 drivers/net/wireless/ath/carl9170/main.c           |    7 +-
 drivers/net/wireless/ath/carl9170/tx.c             |    2 +-
 drivers/net/wireless/ath/hw.c                      |    2 +-
 drivers/net/wireless/ath/wcn36xx/Makefile          |    3 +-
 drivers/net/wireless/ath/wcn36xx/debug.c           |   39 +
 drivers/net/wireless/ath/wcn36xx/debug.h           |    1 +
 drivers/net/wireless/ath/wcn36xx/firmware.c        |  125 +
 drivers/net/wireless/ath/wcn36xx/firmware.h        |   84 +
 drivers/net/wireless/ath/wcn36xx/hal.h             |   74 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |  110 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |   59 +-
 drivers/net/wireless/ath/wcn36xx/smd.h             |    3 -
 drivers/net/wireless/ath/wil6210/cfg80211.c        |    9 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         |   18 +-
 drivers/net/wireless/ath/wil6210/txrx.c            |    4 +-
 drivers/net/wireless/ath/wil6210/txrx.h            |    2 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |    4 +-
 drivers/net/wireless/atmel/at76c50x-usb.c          |    2 +-
 drivers/net/wireless/atmel/atmel.c                 |    2 +-
 drivers/net/wireless/broadcom/b43/main.c           |   11 +-
 drivers/net/wireless/broadcom/b43/phy_common.h     |    2 +-
 drivers/net/wireless/broadcom/b43legacy/main.c     |    9 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |   49 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |    2 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   13 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.c  |   41 +-
 .../wireless/broadcom/brcm80211/brcmfmac/common.h  |    3 +
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |    8 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |   12 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   17 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |   16 -
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |   21 +-
 .../wireless/broadcom/brcm80211/brcmsmac/main.c    |    2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |    2 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |    6 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |    2 +-
 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |    5 +-
 drivers/net/wireless/intel/iwlegacy/4965.c         |    6 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |   23 +-
 drivers/net/wireless/intel/iwlegacy/common.h       |    5 +-
 drivers/net/wireless/intel/iwlwifi/dvm/agn.h       |    2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c       |    4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c  |    5 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |    4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rxon.c      |   26 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c      |   10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |    4 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |    2 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |   16 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-responder.c |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   24 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   91 +-
 .../net/wireless/intel/iwlwifi/mvm/offloading.c    |    6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |    8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/quota.c     |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sf.c        |    6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |    3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c      |    4 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   12 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |    2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |    6 +-
 drivers/net/wireless/intersil/p54/fwio.c           |    6 +-
 drivers/net/wireless/intersil/p54/main.c           |   15 +-
 drivers/net/wireless/intersil/p54/p54spi.c         |    3 +-
 drivers/net/wireless/mac80211_hwsim.c              |  523 +-
 drivers/net/wireless/mac80211_hwsim.h              |    5 +-
 drivers/net/wireless/marvell/libertas/if_usb.c     |    1 +
 drivers/net/wireless/marvell/libertas/mesh.c       |   10 +-
 drivers/net/wireless/marvell/libertas_tf/main.c    |    6 +-
 drivers/net/wireless/marvell/mwifiex/11h.c         |    2 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |   18 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c        |    2 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c        |    2 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |   20 +-
 drivers/net/wireless/marvell/mwl8k.c               |   21 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   19 +-
 drivers/net/wireless/mediatek/mt76/eeprom.c        |    5 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   65 +-
 drivers/net/wireless/mediatek/mt76/mcu.c           |   10 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   85 +-
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c |    8 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |    7 +-
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |    9 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |    5 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  121 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h    |   69 -
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   32 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |   83 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h    |    3 -
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |    4 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   10 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_mac.c    |  109 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_sdio.c   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |  116 +
 .../net/wireless/mediatek/mt76/mt76_connac2_mac.h  |  323 +
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |  920 +++
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  315 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |  156 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |    5 +-
 .../net/wireless/mediatek/mt76/mt76x02_beacon.c    |    8 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |   11 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |    3 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |    5 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |    5 +-
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    |   69 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   21 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  915 +--
 drivers/net/wireless/mediatek/mt76/mt7915/mac.h    |  333 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   27 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  415 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |   51 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mmio.c   |   19 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |   32 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |   24 +-
 .../net/wireless/mediatek/mt76/mt7915/testmode.c   |   11 +-
 drivers/net/wireless/mediatek/mt76/mt7921/Makefile |    1 +
 .../net/wireless/mediatek/mt76/mt7921/acpi_sar.c   |  279 +
 .../net/wireless/mediatek/mt76/mt7921/acpi_sar.h   |   93 +
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c    |   21 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |   13 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |  716 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.h    |  340 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  125 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  424 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h    |   88 -
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |   50 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |   34 +-
 .../net/wireless/mediatek/mt76/mt7921/pci_mac.c    |  106 +-
 .../net/wireless/mediatek/mt76/mt7921/pci_mcu.c    |   17 +-
 drivers/net/wireless/mediatek/mt76/mt7921/sdio.c   |    2 +-
 .../net/wireless/mediatek/mt76/mt7921/sdio_mcu.c   |   31 +-
 drivers/net/wireless/mediatek/mt76/mt7921/usb.c    |   14 +-
 .../net/wireless/mediatek/mt76/mt7921/usb_mac.c    |    4 +-
 drivers/net/wireless/mediatek/mt76/sdio.c          |    8 +-
 drivers/net/wireless/mediatek/mt76/testmode.c      |    9 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |   54 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |    7 +-
 drivers/net/wireless/mediatek/mt7601u/debugfs.c    |    2 +-
 drivers/net/wireless/mediatek/mt7601u/eeprom.c     |    2 +-
 drivers/net/wireless/mediatek/mt7601u/main.c       |    2 +-
 drivers/net/wireless/mediatek/mt7601u/mt7601u.h    |    3 +-
 drivers/net/wireless/mediatek/mt7601u/phy.c        |    9 +-
 drivers/net/wireless/mediatek/mt7601u/tx.c         |    3 +-
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |  252 +-
 drivers/net/wireless/microchip/wilc1000/fw.h       |   21 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      |  228 +-
 drivers/net/wireless/microchip/wilc1000/hif.h      |   15 +-
 drivers/net/wireless/microchip/wilc1000/netdev.c   |   20 +-
 drivers/net/wireless/microchip/wilc1000/netdev.h   |   15 +-
 drivers/net/wireless/microchip/wilc1000/sdio.c     |   13 +
 drivers/net/wireless/microchip/wilc1000/spi.c      |   14 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c     |   12 +-
 drivers/net/wireless/microchip/wilc1000/wlan.h     |    3 +
 drivers/net/wireless/microchip/wilc1000/wlan_cfg.c |    6 +-
 drivers/net/wireless/microchip/wilc1000/wlan_if.h  |   20 +-
 drivers/net/wireless/purelifi/plfxlc/mac.c         |    8 +-
 drivers/net/wireless/purelifi/plfxlc/usb.c         |    2 +-
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  |   14 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |   14 +-
 drivers/net/wireless/quantenna/qtnfmac/event.c     |   15 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     |    4 +-
 drivers/net/wireless/ralink/rt2x00/rt2400pci.c     |    5 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |    5 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h     |    3 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00.h        |    7 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00config.c  |    4 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c     |    9 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c   |    2 +-
 drivers/net/wireless/ralink/rt2x00/rt61pci.c       |    5 +-
 drivers/net/wireless/ralink/rt2x00/rt73usb.c       |    5 +-
 drivers/net/wireless/ray_cs.c                      |   20 +-
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |    7 +-
 drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |    7 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   36 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |   15 +-
 drivers/net/wireless/realtek/rtlwifi/debug.c       |    8 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |    2 +-
 drivers/net/wireless/realtek/rtlwifi/regd.c        |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.c    |    2 +-
 drivers/net/wireless/realtek/rtw88/bf.c            |    2 +-
 drivers/net/wireless/realtek/rtw88/debug.c         |    6 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |    2 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |   13 +-
 drivers/net/wireless/realtek/rtw88/main.c          |   26 +-
 drivers/net/wireless/realtek/rtw88/rtw8723d.c      |    2 +-
 drivers/net/wireless/realtek/rtw88/rtw8723d.h      |    2 +
 drivers/net/wireless/realtek/rtw88/rtw8723de.c     |    2 +-
 drivers/net/wireless/realtek/rtw88/rtw8723de.h     |   10 -
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |    2 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.h      |    2 +
 drivers/net/wireless/realtek/rtw88/rtw8821ce.c     |    2 +-
 drivers/net/wireless/realtek/rtw88/rtw8821ce.h     |   10 -
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |    2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.h      |    2 +
 drivers/net/wireless/realtek/rtw88/rtw8822be.c     |    2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822be.h     |   10 -
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |    2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.h      |    2 +
 drivers/net/wireless/realtek/rtw88/rtw8822ce.c     |    2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822ce.h     |   10 -
 drivers/net/wireless/realtek/rtw89/cam.c           |   38 +-
 drivers/net/wireless/realtek/rtw89/cam.h           |   17 +-
 drivers/net/wireless/realtek/rtw89/core.c          |  204 +-
 drivers/net/wireless/realtek/rtw89/core.h          |   80 +-
 drivers/net/wireless/realtek/rtw89/debug.c         |    6 +-
 drivers/net/wireless/realtek/rtw89/debug.h         |    3 +
 drivers/net/wireless/realtek/rtw89/fw.c            |   29 +-
 drivers/net/wireless/realtek/rtw89/fw.h            |    5 +-
 drivers/net/wireless/realtek/rtw89/mac.c           |   15 +-
 drivers/net/wireless/realtek/rtw89/mac.h           |    1 +
 drivers/net/wireless/realtek/rtw89/mac80211.c      |   18 +-
 drivers/net/wireless/realtek/rtw89/pci.c           |   27 +-
 drivers/net/wireless/realtek/rtw89/pci.h           |    1 +
 drivers/net/wireless/realtek/rtw89/phy.c           |   46 +-
 drivers/net/wireless/realtek/rtw89/phy.h           |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852a_rfk.c  |    4 +-
 .../net/wireless/realtek/rtw89/rtw8852a_table.c    |  896 ++-
 drivers/net/wireless/realtek/rtw89/rtw8852c.c      |    1 +
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.c  |   27 +
 drivers/net/wireless/realtek/rtw89/rtw8852c_rfk.h  |    1 +
 drivers/net/wireless/realtek/rtw89/sar.c           |  140 +-
 drivers/net/wireless/realtek/rtw89/ser.c           |   15 +-
 drivers/net/wireless/rndis_wlan.c                  |    5 +-
 drivers/net/wireless/rsi/rsi_91x_core.c            |    3 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |   11 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |   36 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |    3 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |    2 +-
 drivers/net/wireless/silabs/wfx/fwio.c             |    3 +-
 drivers/net/wireless/silabs/wfx/hif_tx.c           |   12 +-
 drivers/net/wireless/silabs/wfx/sta.c              |   45 +-
 drivers/net/wireless/silabs/wfx/sta.h              |   13 +-
 drivers/net/wireless/st/cw1200/bh.c                |   10 +-
 drivers/net/wireless/st/cw1200/sta.c               |   47 +-
 drivers/net/wireless/st/cw1200/sta.h               |    5 +-
 drivers/net/wireless/st/cw1200/txrx.c              |    4 +-
 drivers/net/wireless/ti/wl1251/acx.h               |    2 +-
 drivers/net/wireless/ti/wl1251/main.c              |   15 +-
 drivers/net/wireless/ti/wl12xx/main.c              |    3 -
 drivers/net/wireless/ti/wlcore/cmd.c               |    4 +-
 drivers/net/wireless/ti/wlcore/main.c              |   54 +-
 drivers/net/wireless/virt_wifi.c                   |    2 +-
 drivers/net/wireless/zydas/zd1211rw/zd_mac.c       |   13 +-
 drivers/net/xen-netback/common.h                   |   12 -
 drivers/net/xen-netback/interface.c                |   16 +-
 drivers/net/xen-netback/netback.c                  |    8 +-
 drivers/net/xen-netback/rx.c                       |    2 +-
 drivers/net/xen-netfront.c                         |   24 +-
 drivers/nfc/nxp-nci/core.c                         |   34 +
 drivers/ptp/ptp_ocp.c                              |   23 +-
 drivers/s390/net/ism_drv.c                         |   15 +-
 drivers/staging/qlge/qlge_main.c                   |    2 +-
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c  |    8 +-
 drivers/staging/vt6655/device_main.c               |    8 +-
 drivers/staging/vt6655/rxtx.c                      |    2 +-
 drivers/staging/vt6656/main_usb.c                  |    6 +-
 drivers/staging/vt6656/rxtx.c                      |    2 +-
 drivers/staging/wlan-ng/cfg80211.c                 |    2 +-
 include/dt-bindings/net/pcs-rzn1-miic.h            |   33 +
 include/linux/atm_tcp.h                            |    2 +
 include/linux/bpf-cgroup-defs.h                    |   13 +-
 include/linux/bpf-cgroup.h                         |    9 +-
 include/linux/bpf.h                                |  175 +-
 include/linux/bpf_lsm.h                            |    7 +
 include/linux/bpf_verifier.h                       |   14 +-
 include/linux/brcmphy.h                            |    1 +
 include/linux/btf.h                                |   93 +-
 include/linux/btf_ids.h                            |   71 +-
 include/linux/can/bittiming.h                      |    2 +
 include/linux/can/dev.h                            |    4 +
 include/linux/can/skb.h                            |   59 +-
 include/linux/dsa/tag_qca.h                        |    5 +
 include/linux/filter.h                             |   43 +-
 include/linux/ftrace.h                             |   43 +
 include/linux/hippidevice.h                        |    4 +
 include/linux/ieee80211.h                          |  380 +-
 include/linux/if_eql.h                             |    1 +
 include/linux/if_hsr.h                             |    4 +
 include/linux/if_macvlan.h                         |    6 +-
 include/linux/if_rmnet.h                           |    2 +
 include/linux/if_tap.h                             |   11 +-
 include/linux/if_team.h                            |   10 +-
 include/linux/if_vlan.h                            |   10 +-
 include/linux/inetdevice.h                         |    2 +-
 include/linux/lapb.h                               |    5 +
 include/linux/mdio/mdio-xgene.h                    |    4 +
 include/linux/mii.h                                |   35 +
 include/linux/mlx5/device.h                        |   36 +-
 include/linux/mlx5/driver.h                        |    6 +
 include/linux/mlx5/eswitch.h                       |    8 +-
 include/linux/mlx5/fs.h                            |   14 +
 include/linux/mlx5/mlx5_ifc.h                      |  180 +-
 include/linux/mroute_base.h                        |   15 +-
 include/linux/net.h                                |    4 +
 include/linux/netdevice.h                          |   40 +-
 include/linux/netfilter/nf_conntrack_h323.h        |  109 +-
 include/linux/netfilter/nf_conntrack_sip.h         |    2 +-
 include/linux/nl802154.h                           |    2 +
 include/linux/pcs-rzn1-miic.h                      |   18 +
 include/linux/pcs/pcs-xpcs.h                       |    3 +-
 include/linux/phy.h                                |    3 +
 include/linux/phy_fixed.h                          |    3 +
 include/linux/ppp-comp.h                           |    2 +-
 include/linux/ppp_channel.h                        |    2 +
 include/linux/ppp_defs.h                           |   14 +
 include/linux/ptp_kvm.h                            |    2 +
 include/linux/ptp_pch.h                            |    4 +
 include/linux/seq_file_net.h                       |    1 +
 include/linux/skbuff.h                             |  277 +-
 include/linux/skmsg.h                              |    1 +
 include/linux/socket.h                             |    9 +-
 include/linux/sockptr.h                            |    8 +
 include/linux/sungem_phy.h                         |    2 +
 include/linux/sysctl.h                             |    2 +
 include/linux/tcp.h                                |   30 +
 include/linux/time64.h                             |    3 +
 include/linux/usb/cdc_ncm.h                        |    4 +-
 include/linux/usb/usbnet.h                         |    6 +
 include/net/af_unix.h                              |    5 +-
 include/net/af_vsock.h                             |    1 +
 include/net/amt.h                                  |    3 +
 include/net/ax25.h                                 |    1 +
 include/net/ax88796.h                              |    2 +
 include/net/bluetooth/bluetooth.h                  |   71 +-
 include/net/bluetooth/hci.h                        |  203 +-
 include/net/bluetooth/hci_core.h                   |  234 +-
 include/net/bluetooth/hci_sock.h                   |    2 +
 include/net/bluetooth/hci_sync.h                   |   16 +
 include/net/bluetooth/iso.h                        |   32 +
 include/net/bond_options.h                         |   22 +-
 include/net/bonding.h                              |    1 +
 include/net/cfg80211.h                             |  587 +-
 include/net/codel_qdisc.h                          |    1 +
 include/net/datalink.h                             |    7 +
 include/net/dcbevent.h                             |    2 +
 include/net/dcbnl.h                                |    2 +
 include/net/devlink.h                              |  118 +-
 include/net/dn_dev.h                               |    1 +
 include/net/dn_fib.h                               |    2 +
 include/net/dn_neigh.h                             |    2 +
 include/net/dn_nsp.h                               |    6 +
 include/net/dn_route.h                             |    3 +
 include/net/dropreason.h                           |  256 +
 include/net/dsa.h                                  |    9 +
 include/net/erspan.h                               |    3 +
 include/net/esp.h                                  |    1 +
 include/net/ethoc.h                                |    3 +
 include/net/firewire.h                             |    5 +-
 include/net/flow_dissector.h                       |   29 +
 include/net/flow_offload.h                         |   12 +
 include/net/fq.h                                   |    4 +
 include/net/fq_impl.h                              |    5 +-
 include/net/garp.h                                 |    2 +
 include/net/gtp.h                                  |    4 +
 include/net/gue.h                                  |    3 +
 include/net/hwbm.h                                 |    2 +
 include/net/ila.h                                  |    2 +
 include/net/inet6_connection_sock.h                |    2 +
 include/net/inet6_hashtables.h                     |    7 +-
 include/net/inet_common.h                          |    6 +
 include/net/inet_frag.h                            |    3 +
 include/net/inet_hashtables.h                      |   19 +-
 include/net/inet_sock.h                            |   11 +
 include/net/ip6_route.h                            |   20 +-
 include/net/ip_tunnels.h                           |   17 +-
 include/net/ipcomp.h                               |    2 +
 include/net/ipconfig.h                             |    2 +
 include/net/llc_c_ac.h                             |    7 +
 include/net/llc_c_st.h                             |    4 +
 include/net/llc_s_ac.h                             |    4 +
 include/net/llc_s_ev.h                             |    1 +
 include/net/llc_s_st.h                             |    6 +
 include/net/mac80211.h                             |  336 +-
 include/net/mpls_iptunnel.h                        |    3 +
 include/net/mptcp.h                                |    3 +-
 include/net/mrp.h                                  |    4 +
 include/net/ncsi.h                                 |    2 +
 include/net/neighbour.h                            |    1 +
 include/net/net_namespace.h                        |    8 +
 include/net/netevent.h                             |    1 +
 include/net/netfilter/nf_conntrack_core.h          |   19 +
 include/net/netfilter/nf_conntrack_timeout.h       |    2 +-
 include/net/netfilter/nf_flow_table.h              |   21 +
 include/net/netfilter/nf_nat.h                     |    2 +-
 include/net/netfilter/nf_tables.h                  |   15 +
 include/net/netfilter/nf_tables_core.h             |   10 -
 include/net/netns/can.h                            |    1 +
 include/net/netns/core.h                           |    2 +
 include/net/netns/flow_table.h                     |   14 +
 include/net/netns/generic.h                        |    1 +
 include/net/netns/ipv4.h                           |    1 +
 include/net/netns/mctp.h                           |    1 +
 include/net/netns/mpls.h                           |    2 +
 include/net/netns/nexthop.h                        |    1 +
 include/net/netns/sctp.h                           |    3 +
 include/net/netns/smc.h                            |    1 +
 include/net/netns/unix.h                           |    8 +
 include/net/netrom.h                               |    1 +
 include/net/p8022.h                                |    5 +
 include/net/phonet/pep.h                           |    3 +
 include/net/phonet/phonet.h                        |    4 +
 include/net/phonet/pn_dev.h                        |    5 +
 include/net/pkt_cls.h                              |    2 +-
 include/net/pkt_sched.h                            |   17 +
 include/net/pptp.h                                 |    3 +
 include/net/psnap.h                                |    5 +
 include/net/raw.h                                  |   18 +-
 include/net/rawv6.h                                |    7 +-
 include/net/regulatory.h                           |    3 +
 include/net/rose.h                                 |    4 +-
 include/net/route.h                                |    7 +-
 include/net/sch_generic.h                          |   19 -
 include/net/secure_seq.h                           |    2 +
 include/net/smc.h                                  |   11 +-
 include/net/sock.h                                 |  114 +-
 include/net/stp.h                                  |    2 +
 include/net/strparser.h                            |   11 +-
 include/net/switchdev.h                            |    3 +
 include/net/tcp.h                                  |    6 +
 include/net/tls.h                                  |  304 +-
 include/net/transp_v6.h                            |    2 +
 include/net/tun_proto.h                            |    3 +-
 include/net/udp.h                                  |    4 +-
 include/net/udplite.h                              |    1 +
 include/net/xdp_priv.h                             |    1 +
 include/net/xdp_sock_drv.h                         |   25 +
 include/net/xfrm.h                                 |    8 +-
 include/soc/mscc/ocelot.h                          |    6 +
 include/trace/events/net.h                         |    2 +-
 include/trace/events/qdisc.h                       |    4 +-
 include/trace/events/skb.h                         |   89 +-
 include/uapi/linux/bpf.h                           |   96 +-
 include/uapi/linux/btf.h                           |   17 +-
 include/uapi/linux/can/error.h                     |   20 +-
 include/uapi/linux/devlink.h                       |   31 +
 include/uapi/linux/if_ether.h                      |    1 +
 include/uapi/linux/if_link.h                       |    1 +
 include/uapi/linux/neighbour.h                     |    1 +
 include/uapi/linux/nl80211.h                       |  107 +-
 include/uapi/linux/pkt_cls.h                       |    3 +
 include/uapi/linux/seg6_iptunnel.h                 |    2 +
 include/uapi/linux/smc.h                           |    1 +
 include/uapi/linux/snmp.h                          |    2 +
 include/uapi/linux/sysctl.h                        |   37 +-
 include/uapi/linux/tls.h                           |    2 +
 include/uapi/linux/xfrm.h                          |   12 +-
 include/uapi/rdma/mlx5_user_ioctl_verbs.h          |    1 +
 kernel/bpf/arraymap.c                              |   40 +-
 kernel/bpf/bpf_iter.c                              |    9 +-
 kernel/bpf/bpf_lsm.c                               |   85 +
 kernel/bpf/bpf_struct_ops.c                        |   10 +-
 kernel/bpf/btf.c                                   |  362 +-
 kernel/bpf/cgroup.c                                |  416 +-
 kernel/bpf/core.c                                  |  132 +-
 kernel/bpf/devmap.c                                |    6 +-
 kernel/bpf/hashtab.c                               |    6 +-
 kernel/bpf/helpers.c                               |   12 +-
 kernel/bpf/local_storage.c                         |    2 +-
 kernel/bpf/lpm_trie.c                              |    2 +-
 kernel/bpf/percpu_freelist.c                       |   20 +-
 kernel/bpf/preload/iterators/Makefile              |   10 +-
 kernel/bpf/syscall.c                               |   61 +-
 kernel/bpf/trampoline.c                            |  426 +-
 kernel/bpf/verifier.c                              |  374 +-
 kernel/events/core.c                               |   16 +-
 kernel/kallsyms.c                                  |   91 +
 kernel/sysctl.c                                    |   41 +
 kernel/time/hrtimer.c                              |    1 +
 kernel/trace/bpf_trace.c                           |    4 +-
 kernel/trace/ftrace.c                              |  328 +-
 kernel/trace/trace_uprobe.c                        |    7 +-
 lib/test_bpf.c                                     |    4 +-
 net/6lowpan/nhc.c                                  |  103 +-
 net/6lowpan/nhc.h                                  |   38 +-
 net/6lowpan/nhc_dest.c                             |    9 +-
 net/6lowpan/nhc_fragment.c                         |    9 +-
 net/6lowpan/nhc_ghc_ext_dest.c                     |    9 +-
 net/6lowpan/nhc_ghc_ext_frag.c                     |   11 +-
 net/6lowpan/nhc_ghc_ext_hop.c                      |    9 +-
 net/6lowpan/nhc_ghc_ext_route.c                    |    9 +-
 net/6lowpan/nhc_ghc_icmpv6.c                       |    9 +-
 net/6lowpan/nhc_ghc_udp.c                          |    9 +-
 net/6lowpan/nhc_hop.c                              |    9 +-
 net/6lowpan/nhc_ipv6.c                             |   11 +-
 net/6lowpan/nhc_mobility.c                         |    9 +-
 net/6lowpan/nhc_routing.c                          |    9 +-
 net/6lowpan/nhc_udp.c                              |    9 +-
 net/8021q/vlan_core.c                              |    6 +-
 net/8021q/vlan_dev.c                               |   22 +-
 net/ax25/af_ax25.c                                 |    7 +-
 net/ax25/ax25_dev.c                                |    9 +-
 net/bluetooth/Kconfig                              |    1 +
 net/bluetooth/Makefile                             |    1 +
 net/bluetooth/af_bluetooth.c                       |    4 +-
 net/bluetooth/eir.c                                |   62 +-
 net/bluetooth/eir.h                                |    1 +
 net/bluetooth/hci_conn.c                           |  900 ++-
 net/bluetooth/hci_core.c                           |  569 +-
 net/bluetooth/hci_event.c                          |  529 +-
 net/bluetooth/hci_request.c                        |  429 +-
 net/bluetooth/hci_request.h                        |   16 +-
 net/bluetooth/hci_sock.c                           |   11 +-
 net/bluetooth/hci_sync.c                           |  628 +-
 net/bluetooth/iso.c                                | 1824 +++++
 net/bluetooth/l2cap_core.c                         |    1 +
 net/bluetooth/lib.c                                |   71 +
 net/bluetooth/mgmt.c                               |  338 +-
 net/bluetooth/msft.c                               |  269 +-
 net/bluetooth/msft.h                               |    6 +-
 net/bpf/test_run.c                                 |   84 +-
 net/bridge/br_if.c                                 |   10 +-
 net/bridge/br_mdb.c                                |   15 +-
 net/bridge/br_netlink.c                            |    8 +-
 net/bridge/br_vlan.c                               |   36 +-
 net/bridge/netfilter/nft_meta_bridge.c             |    2 +-
 net/can/Kconfig                                    |    5 +-
 net/compat.c                                       |    1 +
 net/core/.gitignore                                |    1 +
 net/core/Makefile                                  |   23 +-
 net/core/datagram.c                                |   17 +-
 net/core/dev.c                                     |   49 +-
 net/core/dev_ioctl.c                               |    4 +-
 net/core/devlink.c                                 | 1651 ++--
 net/core/drop_monitor.c                            |   36 +-
 net/core/dst.c                                     |    8 +-
 net/core/failover.c                                |    4 +-
 net/core/filter.c                                  |  202 +-
 net/core/flow_dissector.c                          |   53 +-
 net/core/flow_offload.c                            |   14 +
 net/core/link_watch.c                              |    2 +-
 net/core/neighbour.c                               |   50 +-
 net/core/net-sysfs.c                               |    8 +-
 net/core/netpoll.c                                 |    2 +-
 net/core/page_pool.c                               |    3 +-
 net/core/pktgen.c                                  |    6 +-
 net/core/skbuff.c                                  |   68 +-
 net/core/skmsg.c                                   |   53 +-
 net/core/sock.c                                    |   34 +-
 net/core/sock_map.c                                |   23 +
 net/core/stream.c                                  |    6 +-
 net/dccp/proto.c                                   |   10 +-
 net/decnet/af_decnet.c                             |    4 +
 net/decnet/dn_neigh.c                              |    1 +
 net/decnet/dn_route.c                              |    2 +-
 net/dsa/Kconfig                                    |   11 +-
 net/dsa/Makefile                                   |    1 +
 net/dsa/slave.c                                    |   37 +-
 net/dsa/tag_brcm.c                                 |    4 +-
 net/dsa/tag_ksz.c                                  |   59 +
 net/dsa/tag_rzn1_a5psw.c                           |  113 +
 net/ethtool/cabletest.c                            |    2 +-
 net/ethtool/ioctl.c                                |   21 +-
 net/ethtool/netlink.c                              |    6 +-
 net/ethtool/netlink.h                              |    2 +-
 net/ipv4/af_inet.c                                 |   13 +-
 net/ipv4/arp.c                                     |   25 +-
 net/ipv4/bpf_tcp_ca.c                              |   57 +-
 net/ipv4/devinet.c                                 |    4 +-
 net/ipv4/esp4.c                                    |    4 +-
 net/ipv4/fib_semantics.c                           |   11 +-
 net/ipv4/ip_output.c                               |   60 +-
 net/ipv4/ip_tunnel.c                               |   21 +-
 net/ipv4/ipconfig.c                                |    8 +-
 net/ipv4/ipmr.c                                    |  217 +-
 net/ipv4/ipmr_base.c                               |   53 +-
 net/ipv4/netfilter/nf_nat_h323.c                   |   42 +-
 net/ipv4/ping.c                                    |   36 +-
 net/ipv4/raw.c                                     |  172 +-
 net/ipv4/raw_diag.c                                |   57 +-
 net/ipv4/route.c                                   |   65 +-
 net/ipv4/tcp.c                                     |  186 +-
 net/ipv4/tcp_bbr.c                                 |   24 +-
 net/ipv4/tcp_bpf.c                                 |    1 +
 net/ipv4/tcp_cubic.c                               |   20 +-
 net/ipv4/tcp_dctcp.c                               |   20 +-
 net/ipv4/tcp_input.c                               |    9 +-
 net/ipv4/tcp_ipv4.c                                |    5 +
 net/ipv4/tcp_output.c                              |   32 +-
 net/ipv4/tcp_timer.c                               |   19 +-
 net/ipv4/udp.c                                     |   33 +-
 net/ipv4/udplite.c                                 |    3 +
 net/ipv4/xfrm4_policy.c                            |    2 +-
 net/ipv6/addrconf.c                                |   70 +-
 net/ipv6/addrconf_core.c                           |    2 +-
 net/ipv6/af_inet6.c                                |    6 +-
 net/ipv6/esp6.c                                    |    4 +-
 net/ipv6/ip6_gre.c                                 |   51 +-
 net/ipv6/ip6_output.c                              |   49 +-
 net/ipv6/ip6_tunnel.c                              |   22 +-
 net/ipv6/ip6_vti.c                                 |    4 +-
 net/ipv6/ip6mr.c                                   |  301 +-
 net/ipv6/ndisc.c                                   |   30 +-
 net/ipv6/ping.c                                    |    6 +-
 net/ipv6/raw.c                                     |  120 +-
 net/ipv6/route.c                                   |   12 +-
 net/ipv6/seg6_iptunnel.c                           |  140 +-
 net/ipv6/sit.c                                     |   12 +-
 net/ipv6/tcp_ipv6.c                                |    8 +-
 net/ipv6/udp.c                                     |    3 +
 net/ipv6/udplite.c                                 |    3 +
 net/ipv6/xfrm6_policy.c                            |    4 +-
 net/iucv/af_iucv.c                                 |    2 -
 net/key/af_key.c                                   |    6 +-
 net/l2tp/l2tp_debugfs.c                            |    6 +-
 net/l2tp/l2tp_ppp.c                                |    2 +-
 net/llc/af_llc.c                                   |    2 +-
 net/mac80211/agg-rx.c                              |    6 +-
 net/mac80211/agg-tx.c                              |    6 +-
 net/mac80211/airtime.c                             |    4 +-
 net/mac80211/cfg.c                                 |  967 ++-
 net/mac80211/chan.c                                |  685 +-
 net/mac80211/debug.h                               |   33 +
 net/mac80211/debugfs.c                             |  104 +-
 net/mac80211/debugfs_key.c                         |   10 +-
 net/mac80211/debugfs_netdev.c                      |   52 +-
 net/mac80211/debugfs_sta.c                         |   24 +-
 net/mac80211/driver-ops.c                          |    8 +-
 net/mac80211/driver-ops.h                          |  120 +-
 net/mac80211/eht.c                                 |    9 +-
 net/mac80211/ethtool.c                             |   26 +-
 net/mac80211/he.c                                  |   17 +-
 net/mac80211/ht.c                                  |   57 +-
 net/mac80211/ibss.c                                |   99 +-
 net/mac80211/ieee80211_i.h                         |  702 +-
 net/mac80211/iface.c                               |  368 +-
 net/mac80211/key.c                                 |   78 +-
 net/mac80211/key.h                                 |    9 +-
 net/mac80211/main.c                                |  234 +-
 net/mac80211/mesh.c                                |   50 +-
 net/mac80211/mesh_hwmp.c                           |   15 +-
 net/mac80211/mesh_plink.c                          |   20 +-
 net/mac80211/mlme.c                                | 5885 ++++++++------
 net/mac80211/ocb.c                                 |   15 +-
 net/mac80211/offchannel.c                          |   88 +-
 net/mac80211/rate.c                                |   28 +-
 net/mac80211/rate.h                                |   10 +-
 net/mac80211/rx.c                                  |  251 +-
 net/mac80211/scan.c                                |   14 +-
 net/mac80211/spectmgmt.c                           |   16 +-
 net/mac80211/sta_info.c                            |  518 +-
 net/mac80211/sta_info.h                            |   58 +-
 net/mac80211/status.c                              |   84 +-
 net/mac80211/tdls.c                                |   44 +-
 net/mac80211/trace.h                               | 1175 +--
 net/mac80211/tx.c                                  |  952 ++-
 net/mac80211/util.c                                |  461 +-
 net/mac80211/vht.c                                 |  219 +-
 net/mac80211/wme.c                                 |    3 +-
 net/mac80211/wpa.c                                 |  133 +-
 net/mac80211/wpa.h                                 |    5 +-
 net/mptcp/pm_netlink.c                             |  131 +-
 net/mptcp/protocol.c                               |   60 +-
 net/mptcp/protocol.h                               |    3 +-
 net/mptcp/subflow.c                                |    2 +-
 net/netfilter/Kconfig                              |    9 +
 net/netfilter/Makefile                             |    1 +
 net/netfilter/ipvs/ip_vs_mh.c                      |    5 +-
 net/netfilter/nf_conntrack_bpf.c                   |  365 +-
 net/netfilter/nf_conntrack_broadcast.c             |    6 +-
 net/netfilter/nf_conntrack_core.c                  |   70 +-
 net/netfilter/nf_conntrack_h323_main.c             |  260 +-
 net/netfilter/nf_conntrack_helper.c                |    4 +-
 net/netfilter/nf_conntrack_netlink.c               |   63 +-
 net/netfilter/nf_conntrack_pptp.c                  |    2 +-
 net/netfilter/nf_conntrack_sip.c                   |    9 +-
 net/netfilter/nf_conntrack_timeout.c               |   18 +-
 net/netfilter/nf_flow_table_core.c                 |   73 +-
 net/netfilter/nf_flow_table_offload.c              |   17 +-
 net/netfilter/nf_flow_table_procfs.c               |   80 +
 net/netfilter/nfnetlink.c                          |    2 +-
 net/netfilter/nfnetlink_cthelper.c                 |   10 +-
 net/netfilter/nft_byteorder.c                      |    3 +-
 net/netfilter/nft_cmp.c                            |   18 +-
 net/netfilter/nft_ct.c                             |    4 +-
 net/netfilter/nft_exthdr.c                         |   10 +-
 net/netfilter/nft_osf.c                            |    2 +-
 net/netfilter/nft_set_bitmap.c                     |    4 +-
 net/netfilter/nft_socket.c                         |    8 +-
 net/netfilter/nft_tproxy.c                         |    6 +-
 net/netfilter/nft_tunnel.c                         |    3 +-
 net/netfilter/nft_xfrm.c                           |    8 +-
 net/netfilter/xt_CT.c                              |   23 +-
 net/netfilter/xt_DSCP.c                            |    8 +-
 net/netfilter/xt_TCPMSS.c                          |    4 +-
 net/netfilter/xt_TPROXY.c                          |   25 +-
 net/netfilter/xt_connlimit.c                       |    6 +-
 net/openvswitch/vport-netdev.c                     |    6 +-
 net/packet/af_packet.c                             |   16 +-
 net/rds/rdma.c                                     |    2 +-
 net/rose/af_rose.c                                 |   17 +-
 net/rose/rose_route.c                              |    2 +
 net/rxrpc/protocol.h                               |    2 +-
 net/rxrpc/rxkad.c                                  |    2 +-
 net/sched/act_ct.c                                 |    5 +-
 net/sched/act_mirred.c                             |    6 +-
 net/sched/cls_api.c                                |    5 +-
 net/sched/cls_flower.c                             |   72 +-
 net/sched/sch_api.c                                |    2 +-
 net/sched/sch_cbq.c                                |   82 +-
 net/sched/sch_generic.c                            |   11 +-
 net/sched/sch_taprio.c                             |    5 +-
 net/sctp/protocol.c                                |    4 +-
 net/sctp/sm_statefuns.c                            |    2 -
 net/sctp/socket.c                                  |   12 +-
 net/sctp/stream_interleave.c                       |    2 -
 net/sctp/ulpqueue.c                                |    4 -
 net/smc/af_smc.c                                   |   69 +-
 net/smc/smc_clc.c                                  |    8 +-
 net/smc/smc_clc.h                                  |    2 +-
 net/smc/smc_core.c                                 |  246 +-
 net/smc/smc_core.h                                 |   20 +-
 net/smc/smc_diag.c                                 |    1 +
 net/smc/smc_ib.c                                   |   44 +-
 net/smc/smc_ib.h                                   |    2 +
 net/smc/smc_ism.c                                  |   19 +-
 net/smc/smc_ism.h                                  |   20 +-
 net/smc/smc_llc.c                                  |   33 +-
 net/smc/smc_pnet.c                                 |    7 +-
 net/smc/smc_rx.c                                   |   92 +-
 net/smc/smc_sysctl.c                               |   11 +
 net/smc/smc_tx.c                                   |   20 +-
 net/socket.c                                       |   17 +-
 net/strparser/strparser.c                          |    3 +
 net/switchdev/switchdev.c                          |    4 +-
 net/tipc/bearer.c                                  |    4 +-
 net/tipc/name_table.c                              |   11 -
 net/tipc/name_table.h                              |    1 -
 net/tls/Makefile                                   |    2 +-
 net/tls/tls.h                                      |  321 +
 net/tls/tls_device.c                               |  113 +-
 net/tls/tls_device_fallback.c                      |    8 +-
 net/tls/tls_main.c                                 |  117 +-
 net/tls/tls_proc.c                                 |    4 +
 net/tls/tls_strp.c                                 |  494 ++
 net/tls/tls_sw.c                                   |  788 +-
 net/tls/tls_toe.c                                  |    2 +
 net/unix/af_unix.c                                 |  294 +-
 net/unix/diag.c                                    |   49 +-
 net/unix/sysctl_net_unix.c                         |   19 +-
 net/wireless/ap.c                                  |   46 +-
 net/wireless/chan.c                                |  206 +-
 net/wireless/core.c                                |   37 +-
 net/wireless/core.h                                |   31 +-
 net/wireless/ethtool.c                             |   12 +-
 net/wireless/ibss.c                                |   57 +-
 net/wireless/mesh.c                                |   31 +-
 net/wireless/mlme.c                                |  308 +-
 net/wireless/nl80211.c                             | 1550 +++-
 net/wireless/nl80211.h                             |    9 +-
 net/wireless/ocb.c                                 |    5 +-
 net/wireless/rdev-ops.h                            |  124 +-
 net/wireless/reg.c                                 |  139 +-
 net/wireless/scan.c                                |    8 +-
 net/wireless/sme.c                                 |  514 +-
 net/wireless/trace.h                               |  569 +-
 net/wireless/util.c                                |  101 +-
 net/wireless/wext-compat.c                         |   48 +-
 net/wireless/wext-sme.c                            |   29 +-
 net/xdp/xdp_umem.c                                 |    6 +-
 net/xdp/xsk.c                                      |    5 +-
 net/xfrm/xfrm_device.c                             |    2 +-
 net/xfrm/xfrm_state.c                              |    6 +-
 net/xfrm/xfrm_user.c                               |    6 +-
 samples/bpf/Makefile                               |   19 +-
 samples/bpf/fds_example.c                          |    3 +-
 samples/bpf/sock_example.c                         |    3 +-
 samples/bpf/test_cgrp2_attach.c                    |    3 +-
 samples/bpf/test_lru_dist.c                        |    2 +-
 samples/bpf/test_map_in_map_user.c                 |    4 +-
 samples/bpf/tracex5_user.c                         |    3 +-
 samples/bpf/xdp1_kern.c                            |   11 +-
 samples/bpf/xdp2_kern.c                            |   11 +-
 samples/bpf/xdp_fwd_user.c                         |   55 +-
 samples/bpf/xdp_redirect_map.bpf.c                 |    6 +-
 samples/bpf/xdp_redirect_map_user.c                |    9 +
 samples/bpf/xdp_router_ipv4.bpf.c                  |    9 +
 samples/bpf/xdp_tx_iptunnel_kern.c                 |    2 +-
 samples/bpf/xdpsock.h                              |   19 -
 samples/bpf/xdpsock_ctrl_proc.c                    |  190 -
 samples/bpf/xdpsock_kern.c                         |   24 -
 samples/bpf/xdpsock_user.c                         | 2019 -----
 samples/bpf/xsk_fwd.c                              | 1085 ---
 scripts/bpf_doc.py                                 |   26 +-
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |   16 +-
 .../bpf/bpftool/Documentation/bpftool-feature.rst  |   12 +
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |    5 +-
 tools/bpf/bpftool/Makefile                         |   13 +-
 tools/bpf/bpftool/bash-completion/bpftool          |   30 +-
 tools/bpf/bpftool/btf.c                            |   57 +-
 tools/bpf/bpftool/btf_dumper.c                     |   29 +
 tools/bpf/bpftool/cgroup.c                         |  162 +-
 tools/bpf/bpftool/common.c                         |  160 +-
 tools/bpf/bpftool/feature.c                        |  148 +-
 tools/bpf/bpftool/gen.c                            |  115 +-
 tools/bpf/bpftool/link.c                           |   61 +-
 tools/bpf/bpftool/main.c                           |    2 -
 tools/bpf/bpftool/main.h                           |   24 +-
 tools/bpf/bpftool/map.c                            |   84 +-
 tools/bpf/bpftool/pids.c                           |    1 +
 tools/bpf/bpftool/prog.c                           |   81 +-
 tools/bpf/bpftool/struct_ops.c                     |    2 +
 tools/bpf/resolve_btfids/main.c                    |   40 +-
 tools/bpf/runqslower/Makefile                      |    7 +-
 tools/include/linux/btf_ids.h                      |   35 +-
 tools/include/uapi/linux/bpf.h                     |   96 +-
 tools/include/uapi/linux/btf.h                     |   17 +-
 tools/include/uapi/linux/if_link.h                 |    1 +
 tools/lib/bpf/Build                                |    2 +-
 tools/lib/bpf/Makefile                             |    2 +-
 tools/lib/bpf/bpf.c                                |  209 +-
 tools/lib/bpf/bpf.h                                |  109 +-
 tools/lib/bpf/bpf_core_read.h                      |   11 +
 tools/lib/bpf/bpf_helpers.h                        |   13 +
 tools/lib/bpf/bpf_tracing.h                        |   60 +-
 tools/lib/bpf/btf.c                                |  412 +-
 tools/lib/bpf/btf.h                                |  118 +-
 tools/lib/bpf/btf_dump.c                           |  160 +-
 tools/lib/bpf/gen_loader.c                         |    2 +-
 tools/lib/bpf/libbpf.c                             | 2342 ++----
 tools/lib/bpf/libbpf.h                             |  569 +-
 tools/lib/bpf/libbpf.map                           |  123 +-
 tools/lib/bpf/libbpf_common.h                      |   16 +-
 tools/lib/bpf/libbpf_internal.h                    |   39 +-
 tools/lib/bpf/libbpf_legacy.h                      |   28 +-
 tools/lib/bpf/libbpf_probes.c                      |  125 +-
 tools/lib/bpf/linker.c                             |    7 +-
 tools/lib/bpf/netlink.c                            |   62 +-
 tools/lib/bpf/relo_core.c                          |  479 +-
 tools/lib/bpf/relo_core.h                          |   10 +-
 tools/lib/bpf/usdt.bpf.h                           |   16 +-
 tools/lib/bpf/usdt.c                               |  129 +-
 tools/perf/util/bpf-loader.c                       |  204 +-
 tools/testing/selftests/bpf/.gitignore             |    3 +-
 tools/testing/selftests/bpf/DENYLIST               |    6 +
 tools/testing/selftests/bpf/DENYLIST.s390x         |   67 +
 tools/testing/selftests/bpf/Makefile               |   34 +-
 tools/testing/selftests/bpf/bench.c                |   99 +
 tools/testing/selftests/bpf/bench.h                |   16 +
 .../bpf/benchs/bench_bpf_hashmap_full_update.c     |   96 +
 .../selftests/bpf/benchs/bench_local_storage.c     |  287 +
 .../benchs/bench_local_storage_rcu_tasks_trace.c   |  281 +
 .../benchs/run_bench_bpf_hashmap_full_update.sh    |   11 +
 .../bpf/benchs/run_bench_local_storage.sh          |   24 +
 .../run_bench_local_storage_rcu_tasks_trace.sh     |   11 +
 tools/testing/selftests/bpf/benchs/run_common.sh   |   17 +
 tools/testing/selftests/bpf/bpf_legacy.h           |    9 -
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        |   10 +-
 tools/testing/selftests/bpf/btf_helpers.c          |   25 +-
 tools/testing/selftests/bpf/config                 |   93 +-
 tools/testing/selftests/bpf/config.s390x           |  147 +
 tools/testing/selftests/bpf/config.x86_64          |  251 +
 tools/testing/selftests/bpf/network_helpers.c      |    2 +-
 .../selftests/bpf/prog_tests/attach_probe.c        |   49 +-
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |   16 +
 tools/testing/selftests/bpf/prog_tests/bpf_loop.c  |   62 +
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c    |   64 +-
 .../testing/selftests/bpf/prog_tests/bpf_tcp_ca.c  |   61 +
 tools/testing/selftests/bpf/prog_tests/btf.c       |  157 +-
 tools/testing/selftests/bpf/prog_tests/btf_write.c |  126 +-
 .../testing/selftests/bpf/prog_tests/core_extern.c |   17 +-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |  140 +-
 .../selftests/bpf/prog_tests/fexit_stress.c        |   32 +-
 .../selftests/bpf/prog_tests/kprobe_multi_test.c   |    6 +-
 .../testing/selftests/bpf/prog_tests/libbpf_str.c  |  207 +
 .../testing/selftests/bpf/prog_tests/lsm_cgroup.c  |  313 +
 .../testing/selftests/bpf/prog_tests/probe_user.c  |   35 +-
 .../selftests/bpf/prog_tests/resolve_btfids.c      |    2 +-
 .../selftests/bpf/prog_tests/ringbuf_multi.c       |   11 +
 .../testing/selftests/bpf/prog_tests/send_signal.c |    2 +-
 tools/testing/selftests/bpf/prog_tests/skeleton.c  |    2 +
 .../testing/selftests/bpf/prog_tests/sock_fields.c |    1 -
 .../testing/selftests/bpf/prog_tests/tc_redirect.c |    8 +-
 .../testing/selftests/bpf/prog_tests/test_tunnel.c |   17 +-
 tools/testing/selftests/bpf/prog_tests/usdt.c      |    2 +-
 .../selftests/bpf/prog_tests/xdp_synproxy.c        |  183 +
 .../bpf/progs/bpf_hashmap_full_update_bench.c      |   40 +
 tools/testing/selftests/bpf/progs/bpf_iter.h       |    7 +
 tools/testing/selftests/bpf/progs/bpf_iter_ksym.c  |   74 +
 tools/testing/selftests/bpf/progs/bpf_loop.c       |  114 +
 .../selftests/bpf/progs/bpf_syscall_macro.c        |    6 +-
 .../testing/selftests/bpf/progs/bpf_tracing_net.h  |    1 +
 .../bpf/progs/btf__core_reloc_enum64val.c          |    3 +
 .../bpf/progs/btf__core_reloc_enum64val___diff.c   |    3 +
 .../btf__core_reloc_enum64val___err_missing.c      |    3 +
 .../btf__core_reloc_enum64val___val3_missing.c     |    3 +
 .../bpf/progs/btf__core_reloc_type_based___diff.c  |    3 +
 .../testing/selftests/bpf/progs/core_reloc_types.h |  190 +-
 .../selftests/bpf/progs/local_storage_bench.c      |  104 +
 .../progs/local_storage_rcu_tasks_trace_bench.c    |   67 +
 tools/testing/selftests/bpf/progs/lsm_cgroup.c     |  180 +
 .../selftests/bpf/progs/lsm_cgroup_nonvoid.c       |   14 +
 .../selftests/bpf/progs/tcp_ca_incompl_cong_ops.c  |   35 +
 .../selftests/bpf/progs/tcp_ca_unsupp_cong_op.c    |   21 +
 .../selftests/bpf/progs/tcp_ca_write_sk_pacing.c   |   60 +
 .../selftests/bpf/progs/test_attach_probe.c        |   73 +-
 tools/testing/selftests/bpf/progs/test_bpf_nf.c    |   85 +-
 .../testing/selftests/bpf/progs/test_bpf_nf_fail.c |  134 +
 tools/testing/selftests/bpf/progs/test_btf_haskv.c |   51 -
 tools/testing/selftests/bpf/progs/test_btf_newkv.c |   18 -
 .../testing/selftests/bpf/progs/test_core_extern.c |    3 +
 .../bpf/progs/test_core_reloc_enum64val.c          |   70 +
 .../selftests/bpf/progs/test_core_reloc_kernel.c   |   19 +
 .../bpf/progs/test_core_reloc_type_based.c         |   49 +-
 .../testing/selftests/bpf/progs/test_probe_user.c  |   50 +-
 tools/testing/selftests/bpf/progs/test_skeleton.c  |    4 +
 tools/testing/selftests/bpf/progs/test_tc_dtime.c  |   53 +-
 .../testing/selftests/bpf/progs/test_tunnel_kern.c |   80 +-
 tools/testing/selftests/bpf/progs/test_varlen.c    |    8 +-
 .../selftests/bpf/progs/test_xdp_noinline.c        |   30 +-
 .../selftests/bpf/progs/xdp_synproxy_kern.c        |  843 ++
 .../selftests/bpf/test_bpftool_synctypes.py        |  182 +-
 tools/testing/selftests/bpf/test_btf.h             |    3 +
 tools/testing/selftests/bpf/test_progs.c           |    7 +-
 tools/testing/selftests/bpf/test_verifier.c        |  367 +-
 tools/testing/selftests/bpf/test_xdp_veth.sh       |    6 +-
 tools/testing/selftests/bpf/test_xdping.sh         |    4 +
 tools/testing/selftests/bpf/test_xsk.sh            |    6 +-
 .../selftests/bpf/verifier/bpf_loop_inline.c       |  264 +
 tools/testing/selftests/bpf/verifier/calls.c       |   53 +
 tools/testing/selftests/bpf/vmtest.sh              |   53 +-
 tools/testing/selftests/bpf/xdp_synproxy.c         |  466 ++
 tools/{lib => testing/selftests}/bpf/xsk.c         |   92 +-
 tools/{lib => testing/selftests}/bpf/xsk.h         |   30 +-
 tools/testing/selftests/bpf/xsk_prereqs.sh         |    4 +-
 .../selftests/bpf/{xdpxceiver.c => xskxceiver.c}   |   25 +-
 .../selftests/bpf/{xdpxceiver.h => xskxceiver.h}   |    6 +-
 tools/testing/selftests/drivers/net/dsa/Makefile   |   17 +
 .../drivers/net/mlxsw/devlink_linecard.sh          |   54 +
 .../drivers/net/mlxsw/rif_counter_scale.sh         |  107 +
 .../drivers/net/mlxsw/spectrum-2/resource_scale.sh |   31 +-
 .../net/mlxsw/spectrum-2/rif_counter_scale.sh      |    1 +
 .../net/mlxsw/spectrum-2/tc_flower_scale.sh        |   15 +-
 .../drivers/net/mlxsw/spectrum/resource_scale.sh   |   29 +-
 .../net/mlxsw/spectrum/rif_counter_scale.sh        |   34 +
 .../selftests/drivers/net/mlxsw/tc_flower_scale.sh |   17 +
 .../testing/selftests/drivers/net/netdevsim/fib.sh |   45 +
 tools/testing/selftests/net/.gitignore             |    1 +
 tools/testing/selftests/net/Makefile               |    3 +
 tools/testing/selftests/net/af_unix/Makefile       |    3 +-
 tools/testing/selftests/net/af_unix/unix_connect.c |  148 +
 .../selftests/net/arp_ndisc_untracked_subnets.sh   |  308 +
 tools/testing/selftests/net/cmsg_sender.c          |    2 +-
 tools/testing/selftests/net/fib_rule_tests.sh      |   23 +
 tools/testing/selftests/net/forwarding/Makefile    |    1 +
 .../net/forwarding/bridge_mdb_port_down.sh         |  118 +
 .../net/forwarding/ethtool_extended_state.sh       |   43 +-
 .../net/forwarding/mirror_gre_bridge_1q_lag.sh     |    7 +-
 .../selftests/net/forwarding/vxlan_asymmetric.sh   |    2 +-
 tools/testing/selftests/net/ioam6.sh               |   12 +-
 tools/testing/selftests/net/ipv6_flowlabel.c       |   75 +-
 tools/testing/selftests/net/ipv6_flowlabel.sh      |   16 +
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  116 +-
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c      |    2 +-
 tools/testing/selftests/net/mptcp/simult_flows.sh  |   14 +-
 tools/testing/selftests/net/mptcp/userspace_pm.sh  |   40 +-
 .../selftests/net/srv6_hencap_red_l3vpn_test.sh    |  879 +++
 .../selftests/net/srv6_hl2encap_red_l2vpn_test.sh  |  821 ++
 tools/testing/selftests/net/tls.c                  |  124 +-
 tools/testing/selftests/tc-testing/.gitignore      |    1 -
 tools/testing/selftests/wireguard/qemu/Makefile    |   17 +-
 .../selftests/wireguard/qemu/arch/um.config        |    3 +
 .../testing/selftests/wireguard/qemu/debug.config  |    5 -
 .../testing/selftests/wireguard/qemu/kernel.config |    1 -
 1757 files changed, 94089 insertions(+), 64718 deletions(-)
 create mode 100644 Documentation/bpf/kfuncs.rst
 create mode 100644 Documentation/bpf/map_hash.rst
 create mode 100644 Documentation/devicetree/bindings/net/can/microchip,mpfs-can.yaml
 create mode 100644 Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/sja1000.txt
 create mode 100644 Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
 create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/mt7530.txt
 create mode 100644 Documentation/devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml
 create mode 100644 Documentation/devicetree/bindings/net/pcs/renesas,rzn1-miic.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/sff,sfp.txt
 create mode 100644 Documentation/devicetree/bindings/net/sff,sfp.yaml
 create mode 100644 Documentation/devicetree/bindings/net/xlnx,emaclite.yaml
 create mode 100644 Documentation/networking/device_drivers/can/can327.rst
 delete mode 100644 Documentation/networking/device_drivers/ethernet/neterion/vxge.rst
 create mode 100644 Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
 create mode 100644 Documentation/networking/devlink/devlink-selftests.rst
 create mode 100644 drivers/net/can/can327.c
 create mode 100644 drivers/net/can/dev/calc_bittiming.c
 delete mode 100644 drivers/net/can/slcan.c
 create mode 100644 drivers/net/can/slcan/Makefile
 create mode 100644 drivers/net/can/slcan/slcan-core.c
 create mode 100644 drivers/net/can/slcan/slcan-ethtool.c
 create mode 100644 drivers/net/can/slcan/slcan.h
 rename drivers/net/can/usb/{esd_usb2.c => esd_usb.c} (80%)
 create mode 100644 drivers/net/dsa/microchip/ksz9477.h
 delete mode 100644 drivers/net/dsa/microchip/ksz9477_spi.c
 rename drivers/net/dsa/microchip/{ksz8795_spi.c => ksz_spi.c} (52%)
 create mode 100644 drivers/net/dsa/microchip/lan937x.h
 create mode 100644 drivers/net/dsa/microchip/lan937x_main.c
 create mode 100644 drivers/net/dsa/microchip/lan937x_reg.h
 rename drivers/net/dsa/{qca8k.c => qca/qca8k-8xxx.c} (63%)
 create mode 100644 drivers/net/dsa/qca/qca8k-common.c
 rename drivers/net/dsa/{ => qca}/qca8k.h (80%)
 create mode 100644 drivers/net/dsa/rzn1_a5psw.c
 create mode 100644 drivers/net/dsa/rzn1_a5psw.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/htb.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/htb.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/meter.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_meter.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/debugfs.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.h
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/core_linecard_dev.c
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_pgt.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
 delete mode 100644 drivers/net/ethernet/neterion/vxge/Makefile
 delete mode 100644 drivers/net/ethernet/neterion/vxge/vxge-config.c
 delete mode 100644 drivers/net/ethernet/neterion/vxge/vxge-config.h
 delete mode 100644 drivers/net/ethernet/neterion/vxge/vxge-ethtool.c
 delete mode 100644 drivers/net/ethernet/neterion/vxge/vxge-ethtool.h
 delete mode 100644 drivers/net/ethernet/neterion/vxge/vxge-main.c
 delete mode 100644 drivers/net/ethernet/neterion/vxge/vxge-main.h
 delete mode 100644 drivers/net/ethernet/neterion/vxge/vxge-reg.h
 delete mode 100644 drivers/net/ethernet/neterion/vxge/vxge-traffic.c
 delete mode 100644 drivers/net/ethernet/neterion/vxge/vxge-traffic.h
 delete mode 100644 drivers/net/ethernet/neterion/vxge/vxge-version.h
 create mode 100644 drivers/net/ethernet/sfc/ef100_rep.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_rep.h
 create mode 100644 drivers/net/ethernet/sfc/mae.c
 create mode 100644 drivers/net/ethernet/sfc/mae.h
 create mode 100644 drivers/net/ethernet/sfc/mcdi_pcol_mae.h
 create mode 100644 drivers/net/ethernet/sfc/tc.c
 create mode 100644 drivers/net/ethernet/sfc/tc.h
 create mode 100644 drivers/net/ethernet/wangxun/Kconfig
 create mode 100644 drivers/net/ethernet/wangxun/Makefile
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/Makefile
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe.h
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
 create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
 rename drivers/net/ipa/{ => data}/ipa_data-v3.1.c (99%)
 rename drivers/net/ipa/{ => data}/ipa_data-v3.5.1.c (99%)
 rename drivers/net/ipa/{ => data}/ipa_data-v4.11.c (98%)
 rename drivers/net/ipa/{ => data}/ipa_data-v4.2.c (98%)
 rename drivers/net/ipa/{ => data}/ipa_data-v4.5.c (99%)
 rename drivers/net/ipa/{ => data}/ipa_data-v4.9.c (99%)
 create mode 100644 drivers/net/pcs/pcs-rzn1-miic.c
 create mode 100644 drivers/net/phy/bcm-phy-ptp.c
 create mode 100644 drivers/net/wireless/ath/wcn36xx/firmware.c
 create mode 100644 drivers/net/wireless/ath/wcn36xx/firmware.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76_connac2_mac.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7921/acpi_sar.h
 delete mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723de.h
 delete mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821ce.h
 delete mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822be.h
 delete mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822ce.h
 create mode 100644 include/dt-bindings/net/pcs-rzn1-miic.h
 create mode 100644 include/linux/pcs-rzn1-miic.h
 create mode 100644 include/net/bluetooth/iso.h
 create mode 100644 include/net/dropreason.h
 create mode 100644 include/net/netns/flow_table.h
 create mode 100644 net/bluetooth/iso.c
 create mode 100644 net/core/.gitignore
 create mode 100644 net/dsa/tag_rzn1_a5psw.c
 create mode 100644 net/netfilter/nf_flow_table_procfs.c
 create mode 100644 net/tls/tls.h
 create mode 100644 net/tls/tls_strp.c
 delete mode 100644 samples/bpf/xdpsock.h
 delete mode 100644 samples/bpf/xdpsock_ctrl_proc.c
 delete mode 100644 samples/bpf/xdpsock_kern.c
 delete mode 100644 samples/bpf/xdpsock_user.c
 delete mode 100644 samples/bpf/xsk_fwd.c
 create mode 100644 tools/testing/selftests/bpf/DENYLIST
 create mode 100644 tools/testing/selftests/bpf/DENYLIST.s390x
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_bpf_hashmap_full_update.c
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_local_storage.c
 create mode 100644 tools/testing/selftests/bpf/benchs/bench_local_storage_rcu_tasks_trace.c
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_bpf_hashmap_full_update.sh
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_local_storage.sh
 create mode 100755 tools/testing/selftests/bpf/benchs/run_bench_local_storage_rcu_tasks_trace.sh
 create mode 100644 tools/testing/selftests/bpf/config.s390x
 create mode 100644 tools/testing/selftests/bpf/config.x86_64
 create mode 100644 tools/testing/selftests/bpf/prog_tests/libbpf_str.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/lsm_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_synproxy.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_hashmap_full_update_bench.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_ksym.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enum64val.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enum64val___diff.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enum64val___err_missing.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enum64val___val3_missing.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_based___diff.c
 create mode 100644 tools/testing/selftests/bpf/progs/local_storage_bench.c
 create mode 100644 tools/testing/selftests/bpf/progs/local_storage_rcu_tasks_trace_bench.c
 create mode 100644 tools/testing/selftests/bpf/progs/lsm_cgroup.c
 create mode 100644 tools/testing/selftests/bpf/progs/lsm_cgroup_nonvoid.c
 create mode 100644 tools/testing/selftests/bpf/progs/tcp_ca_incompl_cong_ops.c
 create mode 100644 tools/testing/selftests/bpf/progs/tcp_ca_unsupp_cong_op.c
 create mode 100644 tools/testing/selftests/bpf/progs/tcp_ca_write_sk_pacing.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_bpf_nf_fail.c
 delete mode 100644 tools/testing/selftests/bpf/progs/test_btf_haskv.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_enum64val.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
 create mode 100644 tools/testing/selftests/bpf/verifier/bpf_loop_inline.c
 create mode 100644 tools/testing/selftests/bpf/xdp_synproxy.c
 rename tools/{lib => testing/selftests}/bpf/xsk.c (94%)
 rename tools/{lib => testing/selftests}/bpf/xsk.h (84%)
 rename tools/testing/selftests/bpf/{xdpxceiver.c => xskxceiver.c} (98%)
 rename tools/testing/selftests/bpf/{xdpxceiver.h => xskxceiver.h} (98%)
 create mode 100644 tools/testing/selftests/drivers/net/dsa/Makefile
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/rif_counter_scale.sh
 create mode 120000 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/rif_counter_scale.sh
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/spectrum/rif_counter_scale.sh
 create mode 100644 tools/testing/selftests/net/af_unix/unix_connect.c
 create mode 100755 tools/testing/selftests/net/arp_ndisc_untracked_subnets.sh
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_mdb_port_down.sh
 create mode 100755 tools/testing/selftests/net/srv6_hencap_red_l3vpn_test.sh
 create mode 100755 tools/testing/selftests/net/srv6_hl2encap_red_l2vpn_test.sh
 create mode 100644 tools/testing/selftests/wireguard/qemu/arch/um.config

