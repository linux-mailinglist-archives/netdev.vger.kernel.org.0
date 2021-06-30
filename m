Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0BA93B7CEE
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 07:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbhF3FV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 01:21:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230097AbhF3FVZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 01:21:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66ADB6127C;
        Wed, 30 Jun 2021 05:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625030337;
        bh=L014fAUS1cQYdVJzqF0+O1T1oOGrYfYQqLs50owf4cw=;
        h=From:To:Cc:Subject:Date:From;
        b=SOc0RkhtscEHJrVYF4t00ekcz99hpSpwWSvoc/5dvE2eJM9htMn6aMnCv/7mI1YLd
         mUMIZjFCRvGA2M2W6REQag29SdwPxiLGAfw6w33Ys9jxpnco8EzB1ojeIGKQbk103j
         CJBdu66Cr+HDskRY0pVaKhEuuHs3P4aEzOWZ++tta5uYw1/0+kMsgEKJTnsY0VSNzQ
         flEJtDkHtx566ZXsKhihjLUqQCBLb3dDN+xkkjIL1u4XcBBo9k7rxr1YGv0KZs5Hel
         60LhPkTESVie9JtdyqlCUBkumdDBy6P+VfwPP9bzxjxzofXCcqYsGPJtU0T6+/I1iu
         afpPmyNLD7BeQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] Networking for v5.14
Date:   Tue, 29 Jun 2021 22:18:55 -0700
Message-Id: <20210630051855.3380189-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus!

This is the networking PR for 5.14.

I see two conflicts right now.

In Documentation/networking/devlink/devlink-trap.rst between these two:

 8d4a0adc9cab ("docs: networking: devlink: avoid using ReST :doc:`foo` markup")
 01f1b6ed2b84 ("documentation: networking: devlink: fix prestera.rst formatting that causes build warnings")

It's pretty trivial, resolution is:

@@@ -495,8 -495,9 +495,9 @@@ help debug packet drops caused by thes
  links to the description of driver-specific traps registered by various device
  drivers:
  
 -  * :doc:`netdevsim`
 -  * :doc:`mlxsw`
 -  * :doc:`prestera`
 +  * Documentation/networking/devlink/netdevsim.rst
 +  * Documentation/networking/devlink/mlxsw.rst
++  * Documentation/networking/devlink/prestera.rst
  
  .. _Generic-Packet-Trap-Groups:
  
Then in net/sctp/input.c between these two commits:

 0572b37b27f4 ("sctp: Fix fall-through warnings for Clang")
 d83060759a65 ("sctp: extract sctp_v4_err_handle function from sctp_v4_err")

here keep only the incoming changes; if you're feeling generous
add a return statement in sctp_v4_err_handle() before 'default:'.

The following changes since commit 9ed13a17e38e0537e24d9b507645002bf8d0201f:

  Merge tag 'net-5.13-rc7' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-06-18 18:55:29 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-5.14

for you to fetch changes up to b6df00789e2831fff7a2c65aa7164b2a4dcbe599:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2021-06-29 15:45:27 -0700)

----------------------------------------------------------------
Networking changes for 5.14.

Core:

 - BPF:
   - add syscall program type and libbpf support for generating
     instructions and bindings for in-kernel BPF loaders (BPF loaders
     for BPF), this is a stepping stone for signed BPF programs
   - infrastructure to migrate TCP child sockets from one listener
     to another in the same reuseport group/map to improve flexibility
     of service hand-off/restart
   - add broadcast support to XDP redirect

 - allow bypass of the lockless qdisc to improving performance
   (for pktgen: +23% with one thread, +44% with 2 threads)

 - add a simpler version of "DO_ONCE()" which does not require
   jump labels, intended for slow-path usage

 - virtio/vsock: introduce SOCK_SEQPACKET support

 - add getsocketopt to retrieve netns cookie

 - ip: treat lowest address of a IPv4 subnet as ordinary unicast address
       allowing reclaiming of precious IPv4 addresses

 - ipv6: use prandom_u32() for ID generation

 - ip: add support for more flexible field selection for hashing
       across multi-path routes (w/ offload to mlxsw)

 - icmp: add support for extended RFC 8335 PROBE (ping)

 - seg6: add support for SRv6 End.DT46 behavior

 - mptcp:
    - DSS checksum support (RFC 8684) to detect middlebox meddling
    - support Connection-time 'C' flag
    - time stamping support

 - sctp: packetization Layer Path MTU Discovery (RFC 8899)

 - xfrm: speed up state addition with seq set

 - WiFi:
    - hidden AP discovery on 6 GHz and other HE 6 GHz improvements
    - aggregation handling improvements for some drivers
    - minstrel improvements for no-ack frames
    - deferred rate control for TXQs to improve reaction times
    - switch from round robin to virtual time-based airtime scheduler

 - add trace points:
    - tcp checksum errors
    - openvswitch - action execution, upcalls
    - socket errors via sk_error_report

Device APIs:

 - devlink: add rate API for hierarchical control of max egress rate
            of virtual devices (VFs, SFs etc.)

 - don't require RCU read lock to be held around BPF hooks
   in NAPI context

 - page_pool: generic buffer recycling

New hardware/drivers:

 - mobile:
    - iosm: PCIe Driver for Intel M.2 Modem
    - support for Qualcomm MSM8998 (ipa)

 - WiFi: Qualcomm QCN9074 and WCN6855 PCI devices

 - sparx5: Microchip SparX-5 family of Enterprise Ethernet switches

 - Mellanox BlueField Gigabit Ethernet (control NIC of the DPU)

 - NXP SJA1110 Automotive Ethernet 10-port switch

 - Qualcomm QCA8327 switch support (qca8k)

 - Mikrotik 10/25G NIC (atl1c)

Driver changes:

 - ACPI support for some MDIO, MAC and PHY devices from Marvell and NXP
   (our first foray into MAC/PHY description via ACPI)

 - HW timestamping (PTP) support: bnxt_en, ice, sja1105, hns3, tja11xx

 - Mellanox/Nvidia NIC (mlx5)
   - NIC VF offload of L2 bridging
   - support IRQ distribution to Sub-functions

 - Marvell (prestera):
    - add flower and match all
    - devlink trap
    - link aggregation

 - Netronome (nfp): connection tracking offload

 - Intel 1GE (igc): add AF_XDP support

 - Marvell DPU (octeontx2): ingress ratelimit offload

 - Google vNIC (gve): new ring/descriptor format support

 - Qualcomm mobile (rmnet & ipa): inline checksum offload support

 - MediaTek WiFi (mt76)
    - mt7915 MSI support
    - mt7915 Tx status reporting
    - mt7915 thermal sensors support
    - mt7921 decapsulation offload
    - mt7921 enable runtime pm and deep sleep

 - Realtek WiFi (rtw88)
    - beacon filter support
    - Tx antenna path diversity support
    - firmware crash information via devcoredump

 - Qualcomm 60GHz WiFi (wcn36xx)
    - Wake-on-WLAN support with magic packets and GTK rekeying

 - Micrel PHY (ksz886x/ksz8081): add cable test support

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Aaron Conole (1):
      openvswitch: add trace points

Abhishek Naik (1):
      iwlwifi: mvm: Read acpi dsm to get unii4 enable/disable bitmap.

Abinaya Kalaiselvan (1):
      mac80211: fix NULL ptr dereference during mesh peer connection for non HE devices

Aditya Srivastava (1):
      samples: bpf: Ix kernel-doc syntax in file header

Al Viro (8):
      af_unix: take address assignment/hash insertion into a new helper
      unix_bind(): allocate addr earlier
      unix_bind(): separate BSD and abstract cases
      unix_bind(): take BSD and abstract address cases into new helpers
      fold unix_mknod() into unix_bind_bsd()
      unix_bind_bsd(): move done_path_create() call after dealing with ->bindlock
      unix_bind_bsd(): unlink if we fail after successful mknod
      __unix_find_socket_byname(): don't pass hash and type separately

Alaa Hleihel (2):
      net/mlx5e: Disable TX MPWQE in kdump mode
      net/mlx5e: Disable TLS device offload in kdump mode

Alex Elder (47):
      net: ipa: add support for inline checksum offload
      Revert "net: ipa: disable checksum offload for IPA v4.5+"
      net: ipa: define IPA_MEM_END_MARKER
      net: ipa: store memory region id in descriptor
      net: ipa: validate memory regions unconditionally
      net: ipa: separate memory validation from initialization
      net: ipa: separate region range check from other validation
      net: ipa: validate memory regions at init time
      net: ipa: pass memory configuration data to ipa_mem_valid()
      net: ipa: introduce ipa_mem_id_optional()
      net: ipa: validate memory regions based on version
      net: ipa: flag duplicate memory regions
      net: ipa: use bitmap to check for missing regions
      net: ipa: don't assume mem array indexed by ID
      net: ipa: clean up header memory validation
      net: ipa: pass mem_id to ipa_filter_reset_table()
      net: ipa: pass mem ID to ipa_mem_zero_region_add()
      net: ipa: pass mem_id to ipa_table_reset_add()
      net: ipa: pass memory id to ipa_table_valid_one()
      net: ipa: introduce ipa_mem_find()
      net: ipa: don't index mem data array by ID
      net: qualcomm: rmnet: use ip_is_fragment()
      net: qualcomm: rmnet: eliminate some ifdefs
      net: qualcomm: rmnet: get rid of some local variables
      net: qualcomm: rmnet: simplify rmnet_map_get_csum_field()
      net: qualcomm: rmnet: IPv4 header has zero checksum
      net: qualcomm: rmnet: clarify a bit of code
      net: qualcomm: rmnet: avoid unnecessary byte-swapping
      net: qualcomm: rmnet: avoid unnecessary IPv6 byte-swapping
      net: ipa: make endpoint data validation unconditional
      net: ipa: introduce ipa_version_valid()
      net: ipa: introduce sysfs code
      net: qualcomm: rmnet: remove some local variables
      net: qualcomm: rmnet: rearrange some NOTs
      net: qualcomm: rmnet: show that an intermediate sum is zero
      net: qualcomm: rmnet: return earlier for bad checksum
      net: qualcomm: rmnet: remove unneeded code
      net: qualcomm: rmnet: trailer value is a checksum
      net: qualcomm: rmnet: drop some unary NOTs
      net: qualcomm: rmnet: IPv6 payload length is simple
      net: qualcomm: rmnet: always expose a few functions
      dt-bindings: net: qcom,ipa: add support for MSM8998
      net: ipa: inter-EE interrupts aren't always available
      net: ipa: disable misc clock gating for IPA v3.1
      net: ipa: FLAVOR_0 register doesn't exist until IPA v3.5
      net: ipa: introduce gsi_ring_setup()
      net: ipa: add IPA v3.1 configuration data

Alexander Aring (2):
      net: sock: introduce sk_error_report
      net: sock: add trace for socket errors

Alexandra Winter (1):
      s390/qeth: Consider dependency on SWITCHDEV module

Alexei Starovoitov (24):
      Merge branch 'Reduce kmalloc / kfree churn in the verifier'
      bpf: Introduce bpf_sys_bpf() helper and program type.
      bpf: Introduce bpfptr_t user/kernel pointer.
      bpf: Prepare bpf syscall to be used from kernel and user space.
      libbpf: Support for syscall program type
      selftests/bpf: Test for syscall program type
      bpf: Make btf_load command to be bpfptr_t compatible.
      selftests/bpf: Test for btf_load command.
      bpf: Introduce fd_idx
      bpf: Add bpf_btf_find_by_name_kind() helper.
      bpf: Add bpf_sys_close() helper.
      libbpf: Change the order of data and text relocations.
      libbpf: Add bpf_object pointer to kernel_supports().
      libbpf: Preliminary support for fd_idx
      libbpf: Generate loader program out of BPF ELF file.
      libbpf: Cleanup temp FDs when intermediate sys_bpf fails.
      libbpf: Introduce bpf_map__initial_value().
      bpftool: Use syscall/loader program in "prog load" and "gen skeleton" command.
      selftests/bpf: Convert few tests to light skeleton.
      selftests/bpf: Convert atomics test to light skeleton.
      selftests/bpf: Convert test printk to use rodata.
      selftests/bpf: Convert test trace_printk to lskel.
      bpf: Add cmd alias BPF_PROG_RUN
      Merge branch 'libbpf: error reporting changes for v1.0'

Alvin Šipraga (2):
      brcmfmac: fix setting of station info chains bitmask
      brcmfmac: correctly report average RSSI in station info

Amit Cohen (5):
      mlxsw: Remove Mellanox SwitchIB ASIC support
      mlxsw: Remove Mellanox SwitchX-2 ASIC support
      mlxsw: spectrum_router: Remove abort mechanism
      selftests: router_scale: Do not count failed routes
      selftests: Clean forgotten resources as part of cleanup()

Andre Guedes (9):
      igc: Move igc_xdp_is_enabled()
      igc: Refactor __igc_xdp_run_prog()
      igc: Refactor igc_clean_rx_ring()
      igc: Refactor XDP rxq info registration
      igc: Introduce TX/RX stats helpers
      igc: Introduce igc_unmap_tx_buffer() helper
      igc: Replace IGC_TX_FLAGS_XDP flag by an enum
      igc: Enable RX via AF_XDP zero-copy
      igc: Enable TX via AF_XDP zero-copy

Andrea Mayer (2):
      seg6: add support for SRv6 End.DT46 Behavior
      selftests: seg6: add selftest for SRv6 End.DT46 Behavior

Andrea Righi (1):
      selftests: icmp_redirect: support expected failures

Andreas Roeseler (2):
      icmp: fix lib conflict with trinity
      ipv6: ICMPV6: add response to ICMPV6 RFC 8335 PROBE messages

Andrii Nakryiko (21):
      bpftool: Strip const/volatile/restrict modifiers from .bss and .data vars
      libbpf: Add per-file linker opts
      selftests/bpf: Stop using static variables for passing data to/from user-space
      bpftool: Stop emitting static variables in BPF skeleton
      libbpf: Fix ELF symbol visibility update logic
      libbpf: Treat STV_INTERNAL same as STV_HIDDEN for functions
      selftests/bpf: Validate skeleton gen handles skipped fields
      libbpf: Reject static maps
      libbpf: Reject static entry-point BPF programs
      Merge branch 'Add lookup_and_delete_elem support to BPF hash map types'
      libbpf: Add libbpf_set_strict_mode() API to turn on libbpf 1.0 behaviors
      selftests/bpf: Turn on libbpf 1.0 mode and fix all IS_ERR checks
      libbpf: Streamline error reporting for low-level APIs
      libbpf: Streamline error reporting for high-level APIs
      bpftool: Set errno on skeleton failures and propagate errors
      libbpf: Move few APIs from 0.4 to 0.5 version
      libbpf: Refactor header installation portions of Makefile
      libbpf: Install skel_internal.h header used from light skeletons
      selftests/bpf: Add xdp_redirect_multi into .gitignore
      selftests/bpf: Fix selftests build with old system-wide headers
      selftests/bpf: Fix ringbuf test fetching map FD

Andy Shevchenko (10):
      net: mvpp2: Put fwnode in error case during ->probe()
      net: mvpp2: Use device_get_match_data() helper
      net: mvpp2: Use devm_clk_get_optional()
      net: mvpp2: Unshadow error code of device_property_read_u32()
      atm: Replace custom isprint() with generic analogue
      net: pch_gbe: Propagate error from devm_gpio_request_one()
      net: pch_gbe: Convert to use GPIO descriptors
      net: pch_gbe: use readx_poll_timeout_atomic() variant
      net: pch_gbe: Use proper accessors to BE data in pch_ptp_match()
      net: pch_gbe: remove unneeded MODULE_VERSION() call

Anilkumar Kolli (1):
      ath11k: Enable QCN9074 device

Anirudh Venkataramanan (2):
      ice: Detect and report unsupported module power levels
      ice: downgrade error print to debug print

Ansuel Smith (28):
      net: dsa: qca8k: change simple print to dev variant
      net: dsa: qca8k: use iopoll macro for qca8k_busy_wait
      net: dsa: qca8k: improve qca8k read/write/rmw bus access
      net: dsa: qca8k: handle qca8k_set_page errors
      net: dsa: qca8k: handle error with qca8k_read operation
      net: dsa: qca8k: handle error with qca8k_write operation
      net: dsa: qca8k: handle error with qca8k_rmw operation
      net: dsa: qca8k: handle error from qca8k_busy_wait
      net: dsa: qca8k: add support for qca8327 switch
      devicetree: net: dsa: qca8k: Document new compatible qca8327
      net: dsa: qca8k: add priority tweak to qca8337 switch
      net: dsa: qca8k: limit port5 delay to qca8337
      net: dsa: qca8k: add GLOBAL_FC settings needed for qca8327
      net: dsa: qca8k: add support for switch rev
      net: dsa: qca8k: add ethernet-ports fallback to setup_mdio_bus
      net: dsa: qca8k: make rgmii delay configurable
      net: dsa: qca8k: clear MASTER_EN after phy read/write
      net: dsa: qca8k: dsa: qca8k: protect MASTER busy_wait with mdio mutex
      net: dsa: qca8k: enlarge mdio delay and timeout
      net: dsa: qca8k: add support for internal phy and internal mdio
      devicetree: bindings: dsa: qca8k: Document internal mdio definition
      net: dsa: qca8k: improve internal mdio read/write bus access
      net: dsa: qca8k: pass switch_revision info to phy dev_flags
      net: phy: at803x: clean whitespace errors
      net: phy: add support for qca8k switch internal PHY in at803x
      net: mdio: ipq8064: clean whitespaces in define
      net: mdio: ipq8064: add regmap config to disable REGCACHE
      net: mdio: ipq8064: enlarge sleep after read/write operation

Antoine Tenart (4):
      vrf: do not push non-ND strict packets with a source LLA through packet taps again
      net: macsec: fix the length used to copy the key for offloading
      net: phy: mscc: fix macsec key length
      net: atlantic: fix the macsec key length

Antony Antony (1):
      xfrm: delete xfrm4_output_finish xfrm6_output_finish declarations

Archie Pusaka (9):
      Bluetooth: hci_h5: Add RTL8822CS capabilities
      Bluetooth: use inclusive language in hci_core.h
      Bluetooth: use inclusive language to describe CPB
      Bluetooth: use inclusive language in HCI LE features
      Bluetooth: use inclusive language in SMP
      Bluetooth: use inclusive language in comments
      Bluetooth: use inclusive language in HCI role comments
      Bluetooth: use inclusive language when tracking connections
      Bluetooth: use inclusive language when filtering devices

Arie Gershberg (2):
      nvme-tcp-offload: Add controller level implementation
      nvme-tcp-offload: Add controller level error recovery implementation

Ariel Levkovich (1):
      net/mlx5: Increase hairpin buffer size

Arseny Krasnov (18):
      af_vsock: update functions for connectible socket
      af_vsock: separate wait data loop
      af_vsock: separate receive data loop
      af_vsock: implement SEQPACKET receive loop
      af_vsock: implement send logic for SEQPACKET
      af_vsock: rest of SEQPACKET support
      af_vsock: update comments for stream sockets
      virtio/vsock: set packet's type in virtio_transport_send_pkt_info()
      virtio/vsock: simplify credit update function API
      virtio/vsock: defines and constants for SEQPACKET
      virtio/vsock: dequeue callback for SOCK_SEQPACKET
      virtio/vsock: add SEQPACKET receive logic
      virtio/vsock: rest of SOCK_SEQPACKET support
      virtio/vsock: enable SEQPACKET for transport
      vhost/vsock: support SEQPACKET for transport
      vsock/loopback: enable SEQPACKET for transport
      vsock_test: add SOCK_SEQPACKET tests
      virtio/vsock: update trace event for SEQPACKET

Avraham Stern (2):
      iwlwifi: mvm: support LMR feedback
      nl80211/cfg80211: add BSS color to NDP ranging parameters

Ayush Sawal (1):
      xfrm: Fix xfrm offload fallback fail case

Bailey Forrest (18):
      gve: Update GVE documentation to describe DQO
      gve: Move some static functions to a common file
      gve: gve_rx_copy: Move padding to an argument
      gve: Make gve_rx_slot_page_info.page_offset an absolute offset
      gve: Introduce a new model for device options
      gve: Introduce per netdev `enum gve_queue_format`
      gve: adminq: DQO specific device descriptor logic
      gve: Add support for DQO RX PTYPE map
      gve: Add dqo descriptors
      gve: Add DQO fields for core data structures
      gve: Update adminq commands to support DQO queues
      gve: DQO: Add core netdev features
      gve: DQO: Add ring allocation and initialization
      gve: DQO: Configure interrupts on device up
      gve: DQO: Add TX path
      gve: DQO: Add RX path
      gve: Fix warnings reported for DQO patchset
      gve: Fix swapped vars when fetching max queues

Baochen Qiang (7):
      ath11k: add hw reg support for WCN6855
      ath11k: add dp support for WCN6855
      ath11k: setup REO for WCN6855
      ath11k: setup WBM_IDLE_LINK ring once again
      ath11k: add support to get peer id for WCN6855
      ath11k: add support for WCN6855
      ath11k: don't call ath11k_pci_set_l1ss for WCN6855

Baokun Li (4):
      nfp: use list_move instead of list_del/list_add in nfp_cppcore.c
      net: hns3: use list_move_tail instead of list_del/list_add_tail in hclgevf_main.c
      net: hns3: use list_move_tail instead of list_del/list_add_tail in hclge_main.c
      dccp: tfrc: fix doc warnings in tfrc_equation.c

Bassem Dawood (1):
      mac80211: Enable power save after receiving NULL packet ACK

Bjorn Andersson (1):
      net: qualcomm: rmnet: Allow partial updates of IFLA_FLAGS

Boris Sukholitko (5):
      net/sched: act_vlan: Fix modify to allow 0
      net/sched: act_vlan: No dump for unset priority
      net/sched: act_vlan: Test priority 0 modification
      net/sched: cls_flower: Remove match on n_proto
      Revert "net/sched: cls_flower: Remove match on n_proto"

Brett Creeley (4):
      virtchnl: Use pad byte in virtchnl_ether_addr to specify MAC type
      ice: Manage VF's MAC address for both legacy and new cases
      ice: Save VF's MAC across reboot
      ice: Refactor VIRTCHNL_OP_CONFIG_VSI_QUEUES handling

Brian Norris (1):
      mwifiex: bring down link before deleting interface

Bryan O'Donoghue (13):
      wcn36xx: Return result of set_power_params in suspend
      wcn36xx: Run suspend for the first ieee80211_vif
      wcn36xx: Add ipv4 ARP offload support in suspend
      wcn36xx: Do not flush indication queue on suspend/resume
      wcn36xx: Add ipv6 address tracking
      wcn36xx: Add ipv6 namespace offload in suspend
      wcn36xx: Add set_rekey_data callback
      wcn36xx: Add GTK offload to WoWLAN path
      wcn36xx: Add GTK offload info to WoWLAN resume
      wcn36xx: Add Host suspend indication support
      wcn36xx: Add host resume request support
      wcn36xx: Enable WOWLAN flags
      wcn36xx: Move hal_buf allocation to devm_kmalloc in probe

Bui Quang Minh (1):
      bpf: Fix integer overflow in argument calculation for bpf_map_area_alloc

Caleb Connolly (1):
      ath10k: demote chan info without scan request warning

Calvin Johnson (15):
      Documentation: ACPI: DSD: Document MDIO PHY
      net: phy: Introduce fwnode_mdio_find_device()
      net: phy: Introduce phy related fwnode functions
      of: mdio: Refactor of_phy_find_device()
      net: phy: Introduce fwnode_get_phy_id()
      of: mdio: Refactor of_get_phy_id()
      net: mii_timestamper: check NULL in unregister_mii_timestamper()
      net: mdiobus: Introduce fwnode_mdiobus_register_phy()
      of: mdio: Refactor of_mdiobus_register_phy()
      ACPI: utils: Introduce acpi_get_local_address()
      net: mdio: Add ACPI support code for mdio
      net/fsl: Use [acpi|of]_mdiobus_register
      net: phylink: introduce phylink_fwnode_phy_connect()
      net: phylink: Refactor phylink_of_phy_connect()
      net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver

Chen Li (1):
      netlink: simplify NLMSG_DATA with NLMSG_HDRLEN

Chin-Yen Lee (2):
      rtw88: add rtw_fw_feature_check api
      rtw88: notify fw when driver in scan-period to avoid potential problem

Christophe JAILLET (6):
      brcmsmac: mac80211_if: Fix a resource leak in an error handling path
      ath11k: Fix an error handling path in ath11k_core_fetch_board_data_api_n()
      net: hns3: Fix a memory leak in an error handling path in 'hclge_handle_error_info_log()'
      net: mana: Fix a memory leak in an error handling path in 'mana_create_txq()'
      ieee80211: add the value for Category '6' in "rtw_ieee80211_category"
      ice: Fix a memory leak in an error handling path in 'ice_pf_dcb_cfg()'

Colin Ian King (29):
      net: qed: remove redundant initialization of variable rc
      net: hns3: Fix return of uninitialized variable ret
      ath10k/ath11k: fix spelling mistake "requed" -> "requeued"
      octeontx2-af: Fix spelling mistake "vesion" -> "version"
      b43legacy: Fix spelling mistake "overflew" -> "overflowed"
      bonding: remove redundant initialization of variable ret
      netdevsim: Fix unsigned being compared to less than zero
      netfilter: nfnetlink_hook: fix array index out-of-bounds error
      net: usb: asix: Fix less than zero comparison of a u16
      net: usb: asix: ax88772: Fix less than zero comparison of a u16
      net: stmmac: Fix missing { } around two statements in an if statement
      net: phy: realtek: net: Fix less than zero comparison of a u16
      mlxsw: thermal: Fix null dereference of NULL temperature parameter
      net: dsa: sja1105: Fix assigned yet unused return code rc
      net: phy: micrel: remove redundant assignment to pointer of_node
      ipv6: fib6: remove redundant initialization of variable err
      rtlwifi: rtl8723ae: remove redundant initialization of variable rtstatus
      net: dsa: b53: remove redundant null check on dev
      octeontx2-pf: Fix spelling mistake "morethan" -> "more than"
      mlxsw: spectrum_router: remove redundant continue statement
      ice: remove redundant continue statement in a for-loop
      net: pcs: xpcs: Fix a less than zero u16 comparison error
      net: neterion: vxge: remove redundant continue statement
      net: stmmac: remove redundant continue statement
      net: bridge: remove redundant continue statement
      qlcnic: remove redundant continue statement
      net/mlx5: Fix spelling mistake "enught" -> "enough"
      Bluetooth: virtio_bt: add missing null pointer check on alloc_skb call return
      Bluetooth: btmrvl: remove redundant continue statement

Cong Wang (10):
      rtnetlink: avoid RCU read lock when holding RTNL
      skmsg: Remove unused parameters of sk_msg_wait_data()
      skmsg: Improve udp_bpf_recvmsg() accuracy
      selftests/bpf: Retry for EAGAIN in udp_redir_to_connected()
      udp: Fix a memory leak in udp_read_sock()
      skmsg: Clear skb redirect pointer before dropping it
      skmsg: Fix a memory leak in sk_psock_verdict_apply()
      skmsg: Teach sk_psock_verdict_apply() to return errors
      skmsg: Pass source psock to sk_psock_skb_redirect()
      skmsg: Increase sk->sk_drops when dropping packets

Connor Abbott (1):
      Bluetooth: btqca: Don't modify firmware contents in-place

Cristobal Forno (1):
      ibmvnic: Allow device probe if the device is not ready at boot

DENG Qingfang (4):
      net: phy: add MediaTek Gigabit Ethernet PHY driver
      net: dsa: mt7530: add interrupt support
      dt-bindings: net: dsa: add MT7530 interrupt controller binding
      staging: mt7621-dts: enable MT7530 interrupt controller

Dan Carpenter (17):
      alx: fix a double unlock in alx_probe()
      net/mlx5: check for allocation failure in mlx5_ft_pool_init()
      net: dsa: qca8k: fix an endian bug in qca8k_get_ethtool_stats()
      net: dsa: qca8k: check the correct variable in qca8k_set_mac_eee()
      devlink: Fix error message in devlink_rate_set_ops_supported()
      netdevsim: delete unnecessary debugfs checking
      mt76: mt7915: fix a signedness bug in mt7915_mcu_apply_tx_dpd()
      net: hns3: fix different snprintf() limit
      net: hns3: fix a double shift bug
      net/smc: Fix ENODATA tests in smc_nl_get_fback_stats()
      net: iosm: remove an unnecessary NULL check
      net: qualcomm: rmnet: fix two pointer math bugs
      nfp: flower-ct: check for error in nfp_fl_ct_offload_nft_flow()
      netfilter: nfnetlink_hook: fix check for snprintf() overflow
      stmmac: dwmac-loongson: fix uninitialized variable in loongson_dwmac_probe()
      cfg80211: clean up variable use in cfg80211_parse_colocated_ap()
      gve: DQO: Fix off by one in gve_rx_dqo()

Daniel Borkmann (4):
      Merge branch 'bpf-loader-progs'
      Merge branch 'bpf-xdp-bcast'
      Merge branch 'bpf-sock-migration'
      bpf: Fix up register-based shifts in interpreter to silence KUBSAN

Daniel Lenski (1):
      Bluetooth: btusb: Add a new QCA_ROME device (0cf3:e500)

Daniel Xu (1):
      selftests/bpf: Whitelist test_progs.h from .gitignore

Danielle Ratson (3):
      selftests: mlxsw: Make the unsplit array global in port_scale test
      mlxsw: spectrum_buffers: Switch function arguments
      mlxsw: Verify the accessed index doesn't exceed the array length

Dany Madden (1):
      Revert "ibmvnic: remove duplicate napi_schedule call in open function"

Dario Binacchi (2):
      can: c_can: remove unused variable struct c_can_priv::rxmasked
      can: c_can: add ethtool support

Dave Ertman (4):
      iidc: Introduce iidc.h
      ice: Initialize RDMA support
      ice: Implement iidc operations
      ice: Register auxiliary device to provide RDMA

David Ahern (1):
      nexthops: Add selftests for cleanup of known bad route add

David Bauer (1):
      net: phy: at803x: mask 1000 Base-X link mode

David S. Miller (177):
      Merge branch 'qca_spi-sync'
      Merge branch 'ytja1103-ptp'
      Merge branch 'pch_gbe-cleanups'
      Merge branch 'mvpp2-warnings'
      Merge branch 'bridge-split-ipv4-ipv6-mc-router-state'
      Merge branch 'hinic-cleanups'
      Merge branch 'atl1c-support-for-Mikrotik-10-25G-NIC-features'
      Merge branch 'virtio_net-fixes'
      Merge branch 'hns3-next'
      Merge branch 'hns-coding-style'
      Merge branch 'rk3308-gmac'
      Merge branch 'use-xdp-helpers'
      Merge branch 'qca8k-improvements'
      Merge branch 'ipv4-unicast'
      Merge branch 'func-names-comment'
      Merge branch 'mlxsw-next'
      Merge branch 'stmmac-RK3568'
      Merge branch 'stmmac-xpcs-eee'
      Merge branch 'custom-multipath-hash'
      Merge branch 'wan-cleanups'
      Merge branch 'net-dev-leading-spaces'
      Merge branch 'intel-cleanups'
      Merge branch 'mlxsw-mphash-policies'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge branch 'mt7530-interrupt-support'
      Merge branch 'hns3-debugfs'
      Merge branch 'net-leading-spaces'
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'bond-cleanups'
      Merge branch 'sja1105-spi'
      Merge branch 'wan-cleanups'
      Merge branch 'sja1105-stats'
      Merge branch 'dpaa2-eth-of_node'
      Merge branch 'r6040-cleanups'
      Merge branch 'hns3-promisc-updates'
      Merge branch 'sja1105-sja1110-prep'
      Merge branch 'wan-cleanups'
      Merge branch 'wan-cleanups'
      Merge branch 'marvell-prestera-firmware-3-0'
      Merge branch 'act_vlan-allow-modify-zero'
      Merge branch 'hdlc-cleanups'
      Merge branch 'iwl-next' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/linux
      Merge branch 'qualcomm-rmnet-mapv5'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next
      Merge branch 'nfp-ct-offload'
      Merge branch 'devlink-rate-objects'
      Merge branch 'hdlc_cisco-cleanups'
      Merge branch 'xpcs-phylink_pcs_ops'
      Merge branch 'smc-next'
      Merge branch 'QED-NVMeTCP-Offload'
      Merge branch 'tipc-cleanups'
      Merge branch 'NVMeTCP-Offload-ULP'
      Merge tag 'mlx5-updates-2021-06-03' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'ipa-inline-csum'
      Merge branch 'mptcp-timestamps'
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'hdlc_x25-cleanups'
      Merge branch 'sja1105-yaml'
      Merge branch 'hd6470-cleanups'
      Merge ra.kernel.org:/pub/scm/linux/kernel/git/netdev/net
      Merge branch 'ax88772-phylib'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'hns3-error-handling'
      Merge branch 'page_pool-recycling'
      Merge branch 'realtek-dt'
      Merge branch 'farsync-cleanups'
      Merge tag 'batadv-next-pullrequest-20210608' of git://git.open-mesh.org/linux-merge
      Merge branch 'stmmac-25gbps'
      Merge branch 'wwan-improvements'
      Merge branch 'dsa-sja1110'
      Merge branch 'mlxsw-various-updates'
      Merge branch 'ena-updates'
      Merge branch 'hns3-RAS'
      Merge branch 'lapbther-cleanups'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next
      Merge branch 'mvpp2-prefetch'
      Merge branch 'ipa-mem-1'
      Merge tag 'mlx5-updates-2021-06-09' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'ixp4xxx_hss-cleanups'
      Merge branch 'marvell-prestera-lag'
      Merge branch 'ipa-mem-2'
      Merge branch 'hns3-ptp'
      Merge branch 'sja1110-dsa-tagging'
      Merge branch 's390-qeyj-next'
      Merge branch 'pc300too'
      Merge branch 'dpaa2-ACPI'
      Merge branch 'octeontx2-trusted-vf'
      Merge branch 'virtio-vsock-seqpacket'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'rmnet-checksums-part-1'
      Merge branch 'sja1105-xpcs'
      Merge branch 'ipa-sysfs'
      Merge branch 's390-net-updates'
      Merge branch 'phy-25G-BASE-R'
      Merge branch 'stmmac-intel-cleanups'
      Merge branch 'wwan-link-creation'
      Merge branch 'rmnet-checksums-part-2'
      Merge branch 'iosm-driver'
      Merge branch 'ksz886x-cable-test'
      Merge branch 'marvell-prestera-devlink'
      Merge branch 'Ingenic-SOC-mac-support'
      Merge branch 'tja1103-improvewmentsa'
      Merge branch 'z85230-cleanups'
      Merge branch 'pci200syn-cleanups'
      Merge branch 'occteontx2-rate-limit-offload'
      Merge tag 'mlx5-updates-2021-06-14' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'hns3-next'
      Merge branch 'cosa-cleanups'
      Merge branch 'net-phy-cleanups'
      Merge branch 'nfp-ct-part-two'
      Merge branch 'net-smc-stats'
      Merge branch 'marvell-prestera-flower-match-all'
      Merge tag 'wireless-drivers-next-2021-06-16' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next
      Merge branch 'gianfar-64-bit-stats'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge branch 'mdio-nodes'
      Merge branch 'hdlc_ppp-cleanups'
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'seg6.end.dt6'
      Merge branch 'mptcp-dss-checksums'
      Merge branch 'hostess_sv11-cleanups'
      Merge branch 'csock-seqpoacket-small-fixes'
      Revert "net: add pf_family_names[] for protocol family"
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'RPMSG-WWAN-CTRL-driver'
      Merge branch 'ezchip-fixes'
      Merge tag 'wireless-drivers-2021-06-19' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers
      Merge tag 'linux-can-fixes-for-5.13-20210619' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can
      Merge branch 'ipa-v3.1'
      Merge branch 'mlxsw-eeprom-page-by-page'
      Merge branch 'dsa-cross-chip'
      Merge branch 'mptcp-sdeq-fixes'
      Merge branch 'fec-tx'
      Merge branch 'nnicstar-fixes'
      Merge branch 'ingenic-fixes'
      Merge branch 'marvell-mdio-ACPI'
      Merge branch 'mptcp-optimizations'
      Merge branch 'wwan-link-creation-improvements'
      Merge branch 'mptcp-fixes'
      Merge branch 'ethtool-eeprom'
      Merge branch 'tc-testing-dnat-tuple-collision'
      Merge branch 'sctp-packetization-path-MTU'
      Merge branch 'mptcp-C-flag-and-fixes'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf
      Merge branch 'lockless-qdisc-opts'
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec
      Merge tag 'mlx5-net-next-2021-06-22' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf
      Merge branch 'devlink-rate-limit-fixes'
      Merge branch 'ibmvnic-fixes'
      Merge tag 'linux-can-fixes-for-5.13-20210624' of git://git.kernel.org/ pub/scm/linux/kernel/git/mkl/linux-can
      Merge branch 'add-sparx5i-driver'
      Merge branch 'macsec-key-length'
      Merge branch 'gve-dqo'
      Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue
      Merge branch 'sja1110-doc'
      Merge branch 'sctp-pmtud-convergence'
      Merge tag 'ieee802154-for-davem-2021-06-24' of git://git.kernel.org/pub/scm/linux/kernel/git/sschmidt/wpan
      Merge tag 'wireless-drivers-next-2021-06-25' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next
      Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge branch 'reset-mac'
      Merge tag 'mac80211-next-for-net-next-2021-06-25' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next
      Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git /klassert/ipsec-next
      Merge branch 'tipc-next'
      Merge branch 'hns3-next'
      Merge branch 'bnxt_en-ptp'
      Merge branch 'bridge-replay-helpers'
      Merge tag 'mlx5-updates-2021-06-26' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next
      Merge branch 'sctp-size-validations'
      Merge tag 'for-net-next-2021-06-28' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next
      Merge branch 'do_once_lite'
      Merge branch 'dsa-rx-filtering'
      Merge branch 'inet-sk_error-tracers'
      Merge branch 'ndo_dflt_fdb-print'
      Merge branch 'stmmac-phy-wol'

David Thompson (1):
      Add Mellanox BlueField Gigabit Ethernet driver

David Wilder (1):
      ibmveth: Set CHECKSUM_PARTIAL if NULL TCP CSUM.

David Wu (2):
      net: stmmac: dwmac-rk: Check platform-specific ops
      net: stmmac: Add RK3566/RK3568 SoC support

Davide Caratti (1):
      net/sched: cls_api: increase max_reclassify_loop

Dean Balandin (3):
      nvme-tcp-offload: Add device scan implementation
      nvme-tcp-offload: Add queue level implementation
      nvme-tcp-offload: Add IO level implementation

Denis Salopek (3):
      bpf: Add lookup_and_delete_elem support to hashtab
      bpf: Extend libbpf with bpf_map_lookup_and_delete_elem_flags
      selftests/bpf: Add bpf_lookup_and_delete_elem tests

Deren Wu (5):
      mt76: connac: update BA win size in Rx direction
      mt76: mt7921: introduce mac tx done handling
      mt76: mt7921: update statistic in active mode only
      mt76: mt7921: enable random mac address during sched_scan
      mt76: mt7921: enable HE BFee capability

Di Zhu (2):
      bonding: avoid adding slave device with IFF_MASTER flag
      bonding: allow nesting of bonding device

Ding Senjie (1):
      rtlwifi: Fix spelling of 'download'

Dinghao Liu (1):
      i40e: Fix error handling in i40e_vsi_open

Dmitry Osipenko (2):
      cfg80211: Add wiphy_info_once()
      brcmfmac: Silence error messages about unsupported firmware features

Dmytro Linkin (21):
      netdevsim: Add max_vfs to bus_dev
      netdevsim: Disable VFs on nsim_dev_reload_destroy() call
      netdevsim: Implement port types and indexing
      netdevsim: Implement VFs
      netdevsim: Implement legacy/switchdev mode for VFs
      devlink: Introduce rate object
      netdevsim: Register devlink rate leaf objects per VF
      selftest: netdevsim: Add devlink rate test
      devlink: Allow setting tx rate for devlink rate leaf objects
      netdevsim: Implement devlink rate leafs tx rate support
      selftest: netdevsim: Add devlink port shared/max tx rate test
      devlink: Introduce rate nodes
      netdevsim: Implement support for devlink rate nodes
      selftest: netdevsim: Add devlink rate nodes test
      devlink: Allow setting parent node of rate objects
      netdevsim: Allow setting parent node of rate objects
      selftest: netdevsim: Add devlink rate grouping test
      Documentation: devlink rate objects
      devlink: Decrease refcnt of parent rate object on leaf destroy
      devlink: Remove eswitch mode check for mode set call
      devlink: Protect rate list with lock while switching modes

Dongliang Mu (3):
      ieee802154: hwsim: Fix possible memory leak in hwsim_subscribe_all_others
      net: caif: modify the label out_err to out
      ieee802154: hwsim: Fix memory leak in hwsim_add_one

Dongseok Yi (1):
      bpf: Check for BPF_F_ADJ_ROOM_FIXED_GSO when bpf_skb_change_proto

Eldar Gasanov (1):
      net: dsa: mv88e6xxx: Fix adding vlan 0

Eli Cohen (4):
      net/mlx5: Remove unnecessary spin lock protection
      net/mlx5: Use boolean arithmetic to evaluate roce_lag
      net/mlx5: Fix lag port remapping logic
      net/mlx5: SF, Improve performance in SF allocation

Emmanuel Grumbach (6):
      iwlwifi: mvm: support LONG_GROUP for WOWLAN_GET_STATUSES version
      iwlwifi: mvm: introduce iwl_proto_offload_cmd_v4
      iwlwifi: mvm: update iwl_wowlan_patterns_cmd
      iwlwifi: mvm: introduce iwl_wowlan_kek_kck_material_cmd_v4
      iwlwifi: mvm: introduce iwl_wowlan_get_status_cmd
      cfg80211: expose the rfkill device to the low level driver

Eric Dumazet (8):
      pkt_sched: sch_qfq: fix qfq_change_class() error path
      vxlan: add missing rcu_read_lock() in neigh_reduce()
      virtio/vsock: avoid NULL deref in virtio_transport_seqpacket_allow()
      ieee802154: hwsim: avoid possible crash in hwsim_del_edge_nl()
      ipv6: exthdrs: do not blindly use init_net
      ipv6: fix out-of-bound access in ip6_parse_tlv()
      tcp_yeah: check struct yeah size at compile time
      tcp: change ICSK_CA_PRIV_SIZE definition

Esben Haabendal (7):
      net: gianfar: Convert to ndo_get_stats64 interface
      net: gianfar: Extend statistics counters to 64-bit
      net: gianfar: Clear CAR registers
      net: gianfar: Avoid 16 bytes of memset
      net: gianfar: Add definitions for CAR1 and CAM1 register bits
      net: gianfar: Implement rx_missed_errors counter
      net: ll_temac: Remove left-over debug message

Evelyn Tsai (1):
      mt76: mt7915: fix tssi indication field of DBDC NICs

Ezequiel Garcia (2):
      net: stmmac: Don't set has_gmac if has_gmac4 is set
      dt-bindings: net: rockchip-dwmac: add rk3568 compatible string

Felix Fietkau (16):
      mt76: mt7915: add MSI support
      mt76: mt7915: disable ASPM
      mt76: mt7915: move mt7915_queue_rx_skb to mac.c
      mt76: mt7615: fix fixed-rate tx status reporting
      mt76: mt7615: avoid use of ieee80211_tx_info_clear_status
      mt76: mt7603: avoid use of ieee80211_tx_info_clear_status
      mt76: intialize tx queue entry wcid to 0xffff by default
      mt76: improve tx status codepath
      mt76: dma: use ieee80211_tx_status_ext to free packets when tx fails
      mt76: mt7915: rework tx rate reporting
      mt76: mt7915: add support for tx status reporting
      mt76: mt7915: improve error recovery reliability
      mt76: mt7921: enable VHT BFee capability
      mt76: mt7915: drop the use of repeater entries for station interfaces
      mac80211: move A-MPDU session check from minstrel_ht to mac80211
      mac80211: remove iwlwifi specific workaround that broke sta NDP tx

Florent Revest (1):
      libbpf: Move BPF_SEQ_PRINTF and BPF_SNPRINTF to bpf_helpers.h

Florian Fainelli (5):
      net: r6040: Use logical or for MDIO operations
      net: r6040: Use ETH_FCS_LEN
      net: r6040: Allow restarting auto-negotiation
      net: dsa: b53: Do not force CPU to be always tagged
      net: dsa: b53: Create default VLAN entry explicitly

Florian Westphal (34):
      netfilter: add and use nft_set_do_lookup helper
      netfilter: nf_tables: prefer direct calls for set lookups
      netfilter: x_tables: reduce xt_action_param by 8 byte
      netfilter: reduce size of nf_hook_state on 32bit platforms
      netfilter: nf_tables: add and use nft_sk helper
      netfilter: nf_tables: add and use nft_thoff helper
      netfilter: nf_tables: remove unused arg in nft_set_pktinfo_unspec()
      netfilter: nf_tables: remove xt_action_param from nft_pktinfo
      netfilter: nft_set_pipapo_avx2: fix up description warnings
      netfilter: fix clang-12 fmt string warnings
      sock: expose so_timestamp options for mptcp
      sock: expose so_timestamping options for mptcp
      mptcp: sockopt: propagate timestamp request to subflows
      mptcp: setsockopt: handle SOL_SOCKET in one place only
      tcp: export timestamp helpers for mptcp
      mptcp: receive path cmsg support
      selftests: mptcp_connect: add SO_TIMESTAMPNS cmsg support
      netfilter: annotate nf_tables base hook ops
      netfilter: add new hook nfnl subsystem
      xfrm: remove description from xfrm_type struct
      netfilter: nfnetlink_hook: add depends-on nftables
      netfilter: nf_tables: move base hook annotation to init helper
      xfrm: ipv6: add xfrm6_hdr_offset helper
      xfrm: ipv6: move mip6_destopt_offset into xfrm core
      xfrm: ipv6: move mip6_rthdr_offset into xfrm core
      xfrm: remove hdr_offset indirection
      xfrm: merge dstopt and routing hdroff functions
      xfrm: avoid compiler warning when ipv6 is disabled
      netfilter: conntrack: pass hook state to log functions
      xfrm: replay: avoid xfrm replay notify indirection
      xfrm: replay: remove advance indirection
      xfrm: replay: remove recheck indirection
      xfrm: replay: avoid replay indirection
      xfrm: replay: remove last replay indirection

Fugang Duan (1):
      net: fec: add ndo_select_queue to fix TX bandwidth fluctuations

Gary Lin (1):
      bpfilter: Specify the log level for the kmsg message

Gatis Peisenieks (9):
      atl1c: show correct link speed on Mikrotik 10/25G NIC
      atl1c: improve performance by avoiding unnecessary pcie writes on xmit
      atl1c: adjust max mtu according to Mikrotik 10/25G NIC ability
      atl1c: enable rx csum offload on Mikrotik 10/25G NIC
      atl1c: improve link detection reliability on Mikrotik 10/25G NIC
      atl1c: detect NIC type early
      atl1c: move tx napi into tpd_ring
      atl1c: prepare for multiple rx queues
      atl1c: add 4 RX/TX queue support for Mikrotik 10/25G NIC

Geert Uytterhoeven (3):
      dt-bindings: can: rcar_can: Convert to json-schema
      dt-bindings: can: rcar_canfd: Convert to json-schema
      nvme: NVME_TCP_OFFLOAD should not default to m

Geliang Tang (18):
      mptcp: add csum_enabled in mptcp_sock
      mptcp: generate the data checksum
      mptcp: add csum_reqd in mptcp_out_options
      mptcp: send out checksum for MP_CAPABLE with data
      mptcp: send out checksum for DSS
      mptcp: add sk parameter for mptcp_get_options
      mptcp: add csum_reqd in mptcp_options_received
      mptcp: receive checksum for MP_CAPABLE with data
      mptcp: receive checksum for DSS
      mptcp: add the mib for data checksum
      mptcp: add a new sysctl checksum_enabled
      mptcp: dump csum fields in mptcp_dump_mpext
      selftests: mptcp: enable checksum in mptcp_connect.sh
      selftests: mptcp: enable checksum in mptcp_join.sh
      mptcp: add sysctl allow_join_initial_addr_port
      mptcp: add allow_join_id0 in mptcp_out_options
      mptcp: add deny_join_id0 in mptcp_options_received
      selftests: mptcp: add deny_join_id0 testcases

George Cherian (1):
      octeontx2-af: Update the default KPU profile and fixes

George McCollister (3):
      net: dsa: xrs700x: allow HSR/PRP supervision dupes for node_table
      net: hsr: don't check sequence number if tag removal is offloaded
      net: dsa: xrs700x: forward HSR supervision frames

Grant Seltzer (1):
      bpf: Add documentation for libbpf including API autogen

Guangbin Huang (11):
      net: hinic: remove unnecessary blank line
      net: hinic: add blank line after function declaration
      net: hinic: remove unnecessary parentheses
      net: hinic: fix misspelled "acessing"
      net: hns3: refactor dump tm map of debugfs
      net: hns3: refactor dump tm of debugfs
      net: hns3: refactor dump tc of debugfs
      net: hns3: refactor dump qos pause cfg of debugfs
      net: hns3: refactor dump qos pri map of debugfs
      net: hns3: refactor dump qos buf cfg of debugfs
      net: hns3: refactor dump qs shaper of debugfs

Guenter Roeck (4):
      net/sched: taprio: Drop unnecessary NULL check after container_of
      net: caif: Drop unnecessary NULL check after container_of
      net: thunderx: Drop unnecessary NULL check after container_of
      brcmsmac: Drop unnecessary NULL check after container_of

Guillaume Nault (7):
      net: handle ARPHRD_IP6GRE in dev_is_mac_header_xmit()
      bareudp: allow redirecting bareudp packets to eth devices
      ipip: allow redirecting ipip and mplsip packets to eth devices
      sit: allow redirecting ip6ip, ipip and mplsip packets to eth devices
      gre: let mac_header point to outer header only when necessary
      ip6_tunnel: allow redirecting ip6gre and ipxip6 packets to eth devices
      gtp: reset mac_header after decap

Gustavo A. R. Silva (8):
      bpf: Use struct_size() in kzalloc()
      net: mana: Use struct_size() in kzalloc()
      i40e: Replace one-element array with flexible-array member
      ixgbe: Fix out-bounds warning in ixgbe_host_interface_command()
      r8169: Fix fall-through warning for Clang
      net: axienet: Fix fall-through warning for Clang
      octeontx2-pf: Fix fall-through warning for Clang
      wireless: wext-spy: Fix out-of-bounds warning

Guvenc Gulce (5):
      net/smc: Add SMC statistics support
      net/smc: Add netlink support for SMC statistics
      net/smc: Add netlink support for SMC fallback statistics
      net/smc: Make SMC statistics network namespace aware
      net/smc: Ensure correct state of the socket in send path

Hailong Liu (1):
      samples, bpf: Suppress compiler warning

Haiyang Zhang (1):
      hv_netvsc: Set needed_headroom according to VF

Hang Zhang (1):
      cw1200: Revert unnecessary patches that fix unreal use-after-free bugs

Hangbin Liu (4):
      xdp: Extend xdp_redirect_map with broadcast support
      sample/bpf: Add xdp_redirect_map_multi for redirect_map broadcast test
      selftests/bpf: Add xdp_redirect_multi test
      bpf, devmap: Remove drops variable from bq_xmit_all()

Hao Chen (8):
      net: e1000: remove repeated word "slot" for e1000_main.c
      net: e1000: remove repeated words for e1000_hw.c
      net: e1000e: remove repeated word "the" for ich8lan.c
      net: e1000e: remove repeated word "slot" for netdev.c
      net: e1000e: fix misspell word "retreived"
      net: hns3: refactor queue map of debugfs
      net: hns3: refactor queue info of debugfs
      net: hns3: refactor dump fd tcam of debugfs

Hariprasad Kelam (2):
      octeontx2-af: add new mailbox to configure VF trust mode
      octeontx2-pf: add support for ndo_set_vf_trust

Harish Mitty (1):
      iwlwifi: mvm: Call NMI instead of REPLY_ERROR

Harishankar Vishwanathan (1):
      bpf, tnums: Provably sound, faster, and more precise algorithm for tnum_mul

Harman Kalra (3):
      octeontx2-af: load NPC profile via firmware database
      octeontx2-af: adding new lt def registers support
      octeontx2-af: support for coalescing KPU profiles

Hayes Wang (2):
      r8152: support pauseparam of ethtool_ops
      r8152: store the information of the pipes

Heiko Carstens (1):
      s390/netiuvc: get rid of forward declarations

Heiner Kallweit (3):
      sfc: don't use netif_info et al before net_device is registered
      r8169: use KBUILD_MODNAME instead of own module name definition
      r8169: avoid link-up interrupt issue on RTL8106e if user enables ASPM

Hilda Wu (1):
      Bluetooth: btusb: Add support USB ALT 3 for WBS

Horatiu Vultur (2):
      net: bridge: mrp: Update ring transitions.
      net: bridge: mrp: Update the Test frames for MRA

Huazhong Tan (8):
      net: hns3: support RXD advanced layout
      net: hns3: refactor out RX completion checksum
      net: hns3: refactor dump bd info of debugfs
      net: hns3: refactor dump mac list of debugfs
      net: hns3: switch to dim algorithm for adaptive interrupt moderation
      net: hns3: add support for PTP
      net: hns3: add debugfs support for ptp info
      net: hns3: add support to query tx spare buffer size for pf

Hui Tang (32):
      net: 3com: remove leading spaces before tabs
      net: alteon: remove leading spaces before tabs
      net: amd: remove leading spaces before tabs
      net: apple: remove leading spaces before tabs
      net: broadcom: remove leading spaces before tabs
      net: chelsio: remove leading spaces before tabs
      net: dec: remove leading spaces before tabs
      net: dlink: remove leading spaces before tabs
      net: ibm: remove leading spaces before tabs
      net: marvell: remove leading spaces before tabs
      net: natsemi: remove leading spaces before tabs
      net: realtek: remove leading spaces before tabs
      net: seeq: remove leading spaces before tabs
      net: sis: remove leading spaces before tabs
      net: smsc: remove leading spaces before tabs
      net: sun: remove leading spaces before tabs
      net: fealnx: remove leading spaces before tabs
      net: xircom: remove leading spaces before tabs
      net: 8390: remove leading spaces before tabs
      net: fujitsu: remove leading spaces before tabs
      net: wan: remove leading spaces before tabs
      net: usb: remove leading spaces before tabs
      net: slip: remove leading spaces before tabs
      net: ppp: remove leading spaces before tabs
      net: hamradio: remove leading spaces before tabs
      net: fddi: skfp: remove leading spaces before tabs
      net: appletalk: remove leading spaces before tabs
      ifb: remove leading spaces before tabs
      mii: remove leading spaces before tabs
      libertas: remove leading spaces before tabs
      rt2x00: remove leading spaces before tabs
      wlcore: remove leading spaces before tabs

Huy Nguyen (5):
      net/mlx5e: TC: Reserved bit 31 of REG_C1 for IPsec offload
      net/mlx5e: IPsec/rep_tc: Fix rep_tc_update_skb drops IPsec packet
      net/mlx5: Optimize mlx5e_feature_checks for non IPsec packet
      net/xfrm: Add inner_ipproto into sec_path
      net/mlx5: Fix checksum issue of VXLAN and IPsec crypto offload

Ido Schimmel (31):
      selftests: mlxsw: Make sampling test more robust
      mlxsw: core: Avoid unnecessary EMAD buffer copy
      mlxsw: spectrum_router: Avoid missing error code warning
      ipv4: Calculate multipath hash inside switch statement
      ipv4: Add a sysctl to control multipath hash fields
      ipv4: Add custom multipath hash policy
      ipv6: Use a more suitable label name
      ipv6: Calculate multipath hash inside switch statement
      ipv6: Add a sysctl to control multipath hash fields
      ipv6: Add custom multipath hash policy
      selftests: forwarding: Add test for custom multipath hash
      selftests: forwarding: Add test for custom multipath hash with IPv4 GRE
      selftests: forwarding: Add test for custom multipath hash with IPv6 GRE
      net: Add notifications when multipath hash field change
      mlxsw: spectrum_router: Replace if statement with a switch statement
      mlxsw: spectrum_router: Move multipath hash configuration to a bitmap
      mlxsw: reg: Add inner packet fields to RECRv2 register
      mlxsw: spectrum_outer: Factor out helper for common outer fields
      mlxsw: spectrum_router: Add support for inner layer 3 multipath hash policy
      mlxsw: spectrum_router: Add support for custom multipath hash policy
      mlxsw: reg: Add bank number to MCIA register
      mlxsw: reg: Document possible MCIA status values
      mlxsw: core: Add support for module EEPROM read by page
      ethtool: Use correct command name in title
      ethtool: Document correct attribute type
      ethtool: Decrease size of module EEPROM get policy array
      ethtool: Document behavior when module EEPROM bank attribute is omitted
      ethtool: Use kernel data types for internal EEPROM struct
      ethtool: Validate module EEPROM length as part of policy
      ethtool: Validate module EEPROM offset as part of policy
      mlxsw: core_env: Avoid unnecessary memcpy()s

Ilan Peer (3):
      iwlwifi: mvm: Explicitly stop session protection before unbinding
      mac80211: Properly WARN on HW scan before restart
      cfg80211: Support hidden AP discovery over 6GHz band

Ilias Apalodimas (1):
      page_pool: Allow drivers to hint on SKB recycling

Ilya Maximets (1):
      docs, af_xdp: Consistent indentation in examples

Ioana Ciornei (7):
      dpaa2-eth: setup the of_node field of the device
      dpaa2-eth: name the debugfs directory after the DPNI object
      net: mdio: setup of_node for the MDIO device
      driver core: add a helper to setup both the of_node and fwnode of a device
      net: mdio: use device_set_node() to setup both fwnode and of
      Documentation: ACPI: DSD: include phy.rst in the toctree
      Documentation: ACPI: DSD: fix block code comments

Jacob Keller (15):
      ice: add extack when unable to read device caps
      ice: add error message when pldmfw_flash_image fails
      ice: wait for reset before reporting devlink info
      ice: (re)initialize NVM fields when rebuilding
      ice: add support for sideband messages
      ice: process 1588 PTP capabilities during initialization
      ice: add support for set/get of driver-stored firmware parameters
      ice: add low level PTP clock access functions
      ice: register 1588 PTP clock device object for E810 devices
      ice: report the PTP clock index in ethtool .get_ts_info
      ice: enable receive hardware timestamping
      ice: enable transmit timestamps for E810 devices
      ice: fix incorrect payload indicator on PTYPE
      ice: mark PTYPE 2 as reserved
      ice: remove unnecessary NULL checks before ptp_read_system_*

Jakub Kicinski (26):
      tcp: add tracepoint for checksum errors
      Merge branch '1GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      Merge tag 'linux-can-next-for-5.14-20210527' of git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next
      Merge branch 'mlx-devlink-dev-info-versions-adjustments'
      Merge branch 'add-4-rx-tx-queue-support-for-mikrotik-10-25g-nic'
      Merge tag 'mlx5-updates-2021-05-26' of git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux
      Merge branch 'mptcp-miscellaneous-cleanup'
      Merge branch 'net-hdlc_fr-clean-up-some-code-style-issues'
      Merge branch 'npc-kpu-updates'
      Merge branch 'net-dsa-qca8k-check-return-value-of-read-functions-correctly'
      Merge branch 'fixes-for-yt8511-phy-driver'
      Merge branch 'net-sealevel-clean-up-some-code-style-issues'
      Merge branch 'part-2-of-sja1105-dsa-driver-preparation-for-new-switch-introduction-sja1110'
      Merge branch 'net-hns3-add-vlan-filter-control-support'
      mlx5: count all link events
      ethtool: add a stricter length check
      net: vlan: pass thru all GSO_SOFTWARE in hw_enc_features
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
      selftests: tls: clean up uninitialized warnings
      selftests: tls: fix chacha+bidir tests
      tls: prevent oversized sendfile() hangs by ignoring MSG_MORE
      ip6_tunnel: fix GRE6 segmentation
      net: ip: avoid OOM kills with large UDP sends over loopback
      xdp: Move the rxq_info.mem clearing to unreg_mem_model()
      Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net

Jan Sokolowski (1):
      i40e: Fix missing rtnl locking when setting up pf switch

Jason Baron (1):
      netfilter: x_tables: improve limit_mt scalability

Jean-Philippe Brucker (1):
      tools/bpftool: Fix cross-build

Jesper Dangaard Brouer (1):
      bpf: Run devmap xdp_prog on flush instead of bulk enqueue

Jesse Brandeburg (17):
      e100: handle eeprom as little endian
      intel: remove checker warning
      fm10k: move error check
      igb/igc: use strongly typed pointer
      igb: handle vlan types with checker enabled
      igb: fix assignment on big endian machines
      igb: override two checker warnings
      intel: call csum functions with well formatted arguments
      igbvf: convert to strongly typed descriptors
      ixgbe: use checker safe conversions
      ixgbe: reduce checker warnings
      ice: use static inline for dummy functions
      ice: report hash type such as L2/L3/L4
      i40e: clean up packet type lookup table
      iavf: clean up packet type lookup table
      i40e: fix PTP on 5Gb links
      ice: add tracepoints

Jian Shen (13):
      net: hns3: configure promisc mode for VF asynchronously
      net: hns3: use HCLGE_VPORT_STATE_PROMISC_CHANGE to replace HCLGE_STATE_PROMISC_CHANGED
      net: hns3: add 'QoS' support for port based VLAN configuration
      net: hns3: refine for hclge_push_vf_port_base_vlan_info()
      net: hns3: remove unnecessary updating port based VLAN
      net: hns3: refine function hclge_set_vf_vlan_cfg()
      net: hns3: add support for modify VLAN filter state
      net: hns3: add query basic info support for VF
      net: hns3: add support for VF modify VLAN filter state
      net: hns3: add debugfs support for vlan configuration
      net: fix mistake path for netdev_features_strings
      net: hns3: add support for FD counter in debugfs
      net: hns3: add support for dumping MAC umv counter in debugfs

Jian-Hong Pan (2):
      net: bcmgenet: Fix attaching to PYH failed on RPi 4B
      net: bcmgenet: Add mdio-bcm-unimac soft dependency

Jianguo Wu (5):
      mptcp: fix pr_debug in mptcp_token_new_connect
      mptcp: using TOKEN_MAX_RETRIES instead of magic number
      mptcp: generate subflow hmac after mptcp_finish_join()
      mptcp: remove redundant initialization in pm_nl_init_net()
      mptcp: make sure flag signal is set when add addr with port

Jiapeng Chong (12):
      net/packet: Remove redundant assignment to ret
      net: phy: Fix inconsistent indenting
      net/hamradio/6pack: Fix inconsistent indenting
      net/appletalk: Fix inconsistent indenting
      can: softing: Remove redundant variable ptr
      net/mlx5: Fix duplicate included vhca_event.h
      qed: Fix duplicate included linux/kernel.h
      wcn36xx: Fix inconsistent indenting
      ath6kl: Fix inconsistent indenting
      net: mhi_net: make mhi_wwan_ops static
      net/mlx5: Fix missing error code in mlx5_init_fs()
      Bluetooth: 6lowpan: remove unused function

Jiaran Zhang (12):
      net: hns3: refactor dev capability and dev spec of debugfs
      net: hns3: refactor dump intr of debugfs
      net: hns3: refactor dump reset info of debugfs
      net: hns3: refactor dump m7 info of debugfs
      net: hns3: refactor dump ncl config of debugfs
      net: hns3: refactor dump mac tnl status of debugfs
      net: hns3: add a separate error handling task
      net: hns3: add scheduling logic for error handling task
      net: hns3: add the RAS compatibility adaptation solution
      net: hns3: add support for imp-handle ras capability
      net: hns3: update error recovery module and type
      net: hns3: add error handling compatibility during initialization

Jim Ma (1):
      tls splice: remove inappropriate flags checking for MSG_PEEK

Jimmy Assarsson (2):
      can: kvaser_usb: Rename define USB_HYBRID_{,PRO_}CANLIN_PRODUCT_ID
      can: kvaser_usb: Add new Kvaser hydra devices

Jiri Olsa (1):
      bpf, x86: Remove unused cnt increase from EMIT macro

Jiri Pirko (5):
      devlink: append split port number to the port name
      selftests: devlink_lib: add check for devlink device existence
      net/mlx5: Expose FW version over defined keyword
      mlxsw: core: Expose FW version over defined keyword
      mlxsw: core: use PSID string define in devlink info

Joakim Tjernlund (2):
      Bluetooth: btusb: Add 0x0b05:0x190e Realtek 8761BU (ASUS BT500) device.
      Bluetooth: btrtl: rename USB fw for RTL8761

Joakim Zhang (5):
      dt-bindings: net: add dt binding for realtek rtl82xx phy
      net: phy: realtek: add dt property to disable CLKOUT clock
      net: phy: realtek: add dt property to enable ALDPS mode
      net: phy: realtek: add delay to fix RXC generation issue
      net: fec: add FEC_QUIRK_HAS_MULTI_QUEUES represents i.MX6SX ENET IP

Joe Stringer (1):
      selftests, bpf: Make docs tests fail more reliably

Johannes Berg (46):
      alx: use fine-grained locking instead of RTNL
      rtnetlink: add alloc() method to rtnl_link_ops
      rtnetlink: add IFLA_PARENT_[DEV|DEV_BUS]_NAME
      wwan: add interface creation support
      wil6210: remove erroneous wiphy locking
      iwlwifi: mvm: don't change band on bound PHY contexts
      iwlwifi: pcie: handle pcim_iomap_table() failures better
      iwlwifi: pcie: print interrupt number, not index
      iwlwifi: pcie: remove CSR_HW_RF_ID_TYPE_CHIP_ID
      iwlwifi: remove duplicate iwl_ax201_cfg_qu_hr declaration
      iwlwifi: pcie: identify the RF module
      iwlwifi: mvm: don't request SMPS in AP mode
      iwlwifi: mvm: apply RX diversity per PHY context
      iwlwifi: mvm: honour firmware SMPS requests
      iwlwifi: correct HE capabilities
      iwlwifi: pcie: fix some kernel-doc comments
      iwlwifi: pcie: remove TR/CR tail allocations
      iwlwifi: pcie: free IML DMA memory allocation
      iwlwifi: pcie: fix context info freeing
      iwlwifi: mvm: fill phy_data.d1 for no-data RX
      iwlwifi: pcie: free some DMA memory earlier
      iwlwifi: move error dump to fw utils
      iwlwifi: fw: dump TCM error table if present
      cfg80211: remove CFG80211_MAX_NUM_DIFFERENT_CHANNELS
      mac80211: unify queueing SKB to iface
      mac80211: refactor SKB queue processing a bit
      mac80211: use sdata->skb_queue for TDLS
      mac80211: simplify ieee80211_add_station()
      mac80211: consider per-CPU statistics if present
      mac80211: don't open-code LED manipulations
      mac80211: allow SMPS requests only in client mode
      mac80211: free skb in WEP error case
      ieee80211: add defines for HE PHY cap byte 10
      mac80211: rearrange struct txq_info for fewer holes
      mac80211: improve AP disconnect message
      cfg80211: trace more information in assoc trace event
      mac80211: remove use of ieee80211_get_he_sta_cap()
      cfg80211: remove ieee80211_get_he_sta_cap()
      cfg80211: reg: improve bad regulatory warning
      cfg80211: add cfg80211_any_usable_channels()
      mac80211: conditionally advertise HE in probe requests
      cfg80211: allow advertising vendor-specific capabilities
      mac80211: add vendor-specific capabilities to assoc request
      mac80211: always include HE 6GHz capability in probe request
      mac80211: notify driver on mgd TX completion
      mac80211: add HE 6 GHz capability only if supported

John Fastabend (1):
      bpf: Fix null ptr deref with mixed tail calls and subprogs

Jon Maloy (3):
      tipc: eliminate redundant fields in struct tipc_sock
      tipc: refactor function tipc_sk_anc_data_recv()
      tipc: simplify handling of lookup scope during multicast message reception

Jonathan Edwards (1):
      libbpf: Add extra BPF_PROG_TYPE check to bpf_object__probe_loading

Jonathan Lemon (1):
      ptp: Set lookup cookie when creating a PTP PPS source.

Juerg Haefliger (2):
      drivers/net: Remove leading spaces in Kconfig
      netfilter: Remove leading spaces in Kconfig

Julian Wiedmann (10):
      net/smc: no need to flush smcd_dev's event_wq before destroying it
      s390/qeth: count TX completion interrupts
      s390/qeth: also use TX NAPI for non-IQD devices
      s390/qeth: unify the tracking of active cmds on ccw device
      s390/qeth: use ethtool_sprintf()
      s390/qeth: consolidate completion of pending TX buffers
      s390/qeth: remove QAOB's pointer to its TX buffer
      s390/qeth: remove TX buffer's pointer to its queue
      s390/qeth: shrink TX buffer struct
      net/af_iucv: clean up some forward declarations

Jussi Maki (1):
      net: bonding: Use per-cpu rr_tx_counter

Kai Ye (11):
      Bluetooth: 6lowpan: delete unneeded variable initialization
      Bluetooth: bnep: Use the correct print format
      Bluetooth: cmtp: Use the correct print format
      Bluetooth: hidp: Use the correct print format
      Bluetooth: 6lowpan: Use the correct print format
      Bluetooth: a2mp: Use the correct print format
      Bluetooth: amp: Use the correct print format
      Bluetooth: mgmt: Use the correct print format
      Bluetooth: msft: Use the correct print format
      Bluetooth: sco: Use the correct print format
      Bluetooth: smp: Use the correct print format

Kai-Heng Feng (1):
      Bluetooth: Shutdown controller after workqueues are flushed or cancelled

Kalle Valo (6):
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge tag 'mt76-for-kvalo-2021-06-18' of https://github.com/nbd168/wireless into pending
      Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git
      Merge tag 'iwlwifi-next-for-kalle-2021-06-22' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      iwlwifi: acpi: remove unused function iwl_acpi_eval_dsm_func()

Karsten Graul (1):
      net/smc: avoid possible duplicate dmb unregistration

Kees Cook (11):
      net: vlan: Avoid using strncpy()
      net: bonding: Use strscpy_pad() instead of manually-truncated strncpy()
      ibmvnic: Use strscpy() instead of strncpy()
      orinoco: Avoid field-overflowing memcpy()
      mwl8k: Avoid memcpy() over-reading of mcs.rx_mask
      rtlwifi: rtl8192de: Fully initialize curvecount_val
      mwifiex: Avoid memset() over-write of WEP key_material
      ath11k: Avoid memcpy() over-reading of he_cap
      wcn36xx: Avoid memset() beyond end of struct field
      octeontx2-af: Avoid field-overflowing memcpy()
      hv_netvsc: Avoid field-overflowing memcpy()

Kiran K (1):
      Bluetooth: Fix alt settings for incoming SCO with transparent coding format

Krishnanand Prabhu (1):
      ieee80211: define timing measurement in extended capabilities IE

Kristian Evensen (1):
      net: ethernet: rmnet: Always subtract MAP header

Krzysztof Kazimierczak (1):
      ice: Refactor ice_setup_rx_ctx

Krzysztof Kozlowski (25):
      nfc: fdp: correct kerneldoc for structure
      nfc: fdp: drop ACPI_PTR from device ID table
      nfc: port100: correct kerneldoc for structure
      nfc: pn533: drop of_match_ptr from device ID table
      nfc: mrvl: mark OF device ID tables as maybe unused
      nfc: mrvl: skip impossible NCI_MAX_PAYLOAD_SIZE check
      nfc: pn533: mark OF device ID tables as maybe unused
      nfc: s3fwrn5: mark OF device ID tables as maybe unused
      nfc: pn544: mark ACPI and OF device ID tables as maybe unused
      nfc: st-nci: mark ACPI and OF device ID tables as maybe unused
      nfc: st21nfca: mark ACPI and OF device ID tables as maybe unused
      nfc: st95hf: mark ACPI and OF device ID tables as maybe unused
      nfc: fdp: drop ftrace-like debugging messages
      nfc: mei_phy: drop ftrace-like debugging messages
      nfc: mrvl: use SPDX-License-Identifier
      nfc: mrvl: correct minor coding style violations
      nfc: mrvl: simplify with module_driver
      nfc: pn533: drop ftrace-like debugging messages
      nfc: pn533: drop unneeded braces {} in if
      nfc: pn544: drop ftrace-like debugging messages
      nfc: st21nfca: drop ftrace-like debugging messages
      nfc: st-nci: drop ftrace-like debugging messages
      nfc: st95hf: fix indentation to tabs
      nfc: mrvl: remove useless "continue" at end of loop
      nfc: mrvl: reduce the scope of local variables

Kumar Kartikeya Dwivedi (7):
      libbpf: Add various netlink helpers
      libbpf: Add low level TC-BPF management API
      libbpf: Add selftests for TC-BPF management API
      libbpf: Remove unneeded check for flags during tc detach
      libbpf: Set NLM_F_EXCL when creating qdisc
      libbpf: Add request buffer type for netlink messages
      libbpf: Switch to void * casting in netlink helpers

Kuniyuki Iwashima (13):
      net: Introduce net.ipv4.tcp_migrate_req.
      tcp: Add num_closed_socks to struct sock_reuseport.
      tcp: Keep TCP_CLOSE sockets in the reuseport group.
      tcp: Add reuseport_migrate_sock() to select a new listener.
      tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
      tcp: Migrate TCP_NEW_SYN_RECV requests at retransmitting SYN+ACKs.
      tcp: Migrate TCP_NEW_SYN_RECV requests at receiving the final ACK.
      bpf: Support BPF_FUNC_get_socket_cookie() for BPF_PROG_TYPE_SK_REUSEPORT.
      bpf: Support socket migration by eBPF.
      libbpf: Set expected_attach_type for BPF_PROG_TYPE_SK_REUSEPORT.
      bpf: Test BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.
      tcp: Add stats for socket migration.
      net/tls: Remove the __TLS_DEC_STATS() macro.

Lama Kayal (1):
      net/mlx5e: Zero-init DIM structures

Lee Gibson (1):
      wl1251: Fix possible buffer overflow in wl1251_cmd_scan

Leon Romanovsky (3):
      net/mlx5: Delay IRQ destruction till all users are gone
      net/mlx5: Provide cpumask at EQ creation phase
      net/mlx5: Clean license text in eq.[c|h] files

Lijun Pan (4):
      ibmvnic: fix kernel build warning in strncpy
      ibmvnic: fix kernel build warning
      ibmvnic: fix kernel build warnings in build_hdr_descs_arr
      ibmvnic: fix send_request_map incompatible argument

Ling Pei Lee (2):
      net: stmmac: option to enable PHY WOL with PMT enabled
      stmmac: intel: Enable PHY WOL option in EHL

Linus Lüssing (14):
      net: bridge: mcast: rename multicast router lists and timers
      net: bridge: mcast: add wrappers for router node retrieval
      net: bridge: mcast: prepare mdb netlink for mcast router split
      net: bridge: mcast: prepare query reception for mcast router split
      net: bridge: mcast: prepare is-router function for mcast router split
      net: bridge: mcast: prepare expiry functions for mcast router split
      net: bridge: mcast: prepare add-router function for mcast router split
      net: bridge: mcast: split router port del+notify for mcast router split
      net: bridge: mcast: split multicast router state for IPv4 and IPv6
      net: bridge: mcast: add ip4+ip6 mcast router timers to mdb netlink
      net: bridge: mcast: export multicast router presence adjacent to a port
      batman-adv: bcast: queue per interface, if needed
      batman-adv: bcast: avoid skb-copy for (re)queued broadcasts
      batman-adv: mcast: add MRD + routable IPv4 multicast with bridges support

Liu Shixin (1):
      netlabel: Fix memory leak in netlbl_mgmt_add_common

Liwei Song (1):
      ice: set the value of global config lock timeout longer

Loic Poulain (8):
      net: wwan: Add unknown port type
      usb: class: cdc-wdm: WWAN framework integration
      net: wwan: Add WWAN port type attribute
      net: wwan: core: Add WWAN device index sysfs attribute
      net: mhi_net: Register wwan_ops for link creation
      net: wwan: iosm: Remove DEBUG flag
      net: wwan: Fix WWAN config symbols
      MAINTAINERS: network: add entry for WWAN

Longpeng(Mike) (1):
      vsock: notify server to shutdown when client has pending signal

Lorenz Bauer (5):
      bpf: verifier: Improve function state reallocation
      bpf: verifier: Use copy_array for jmp_history
      bpf: verifier: Allocate idmap scratch in verifier env
      libbpf: Fail compilation if target arch is missing
      tools/testing: add a selftest for SO_NETNS_COOKIE

Lorenzo Bianconi (44):
      samples: pktgen: add UDP tx checksum support
      net: ti: add pp skb recycling support
      net: ice: ptp: fix compilation warning if PTP_1588_CLOCK is disabled
      mt76: move mt76_rates in mt76 module
      mt76: mt7921: enable rx hw de-amsdu
      mt76: connac: add missing configuration in mt76_connac_mcu_wtbl_hdr_trans_tlv
      mt76: mt7921: enable rx header traslation offload
      mt76: mt7921: enable rx csum offload
      mt76: fix possible NULL pointer dereference in mt76_tx
      mt76: mt7615: fix NULL pointer dereference in tx_prepare_skb()
      mt76: mt76x0: use dev_debug instead of dev_err for hw_rf_ctrl
      mt76: mt7615: free irq if mt7615_mmio_probe fails
      mt76: mt7663: enable hw rx header translation
      mt76: mt7921: enable runtime pm by default
      mt76: mt7921: return proper error value in mt7921_mac_init
      mt76: mt7921: do not schedule hw reset if the device is not running
      mt76: mt7921: reset wfsys during hw probe
      mt76: mt7615: remove useless if condition in mt7615_add_interface()
      mt76: testmode: fix memory leak in mt76_testmode_alloc_skb
      mt76: testmode: remove unnecessary function calls in mt76_testmode_free_skb
      mt76: testmode: remove undefined behaviour in mt76_testmode_alloc_skb
      mt76: allow hw driver code to overwrite wiphy interface_modes
      mt76: mt7921: set MT76_RESET during mac reset
      mt76: mt7921: enable hw offloading for wep keys
      mt76: mt7921: remove mt7921_get_wtbl_info routine
      mt76: connac: fix UC entry is being overwritten
      mt76: connac: add mt76_connac_power_save_sched in mt76_connac_pm_unref
      mt76: mt7921: wake the device before dumping power table
      mt76: mt7921: make mt7921_set_channel static
      mt76: connac: add mt76_connac_mcu_get_nic_capability utility routine
      mt76: reduce rx buffer size to 2048
      mt76: move mt76_get_next_pkt_id in mt76.h
      mt76: connac: check band caps in mt76_connac_mcu_set_rate_txpower
      mt76: mt7921: improve code readability for mt7921_update_txs
      mt76: mt7921: limit txpower according to userlevel power
      mt76: mt7921: introduce dedicated control for deep_sleep
      mt76: disable TWT capabilities for the moment
      mt76: sdio: do not run mt76_txq_schedule directly
      mt76: mt7663s: rely on pm reference counting
      mt76: mt7663s: rely on mt76_connac_pm_ref/mt76_connac_pm_unref in tx path
      mt76: mt7663s: enable runtime-pm
      mt76: mt7615: set macwork timeout according to runtime-pm
      mt76: mt7921: allow chip reset during device restart
      net: marvell: return csum computation result from mvneta_rx_csum/mvpp2_rx_csum

Louis Peens (16):
      nfp: flower: move non-zero chain check
      nfp: flower-ct: add pre and post ct checks
      nfp: flower-ct: add ct zone table
      nfp: flower-ct: add zone table entry when handling pre/post_ct flows
      nfp: flower-ct: add nfp_fl_ct_flow_entries
      nfp: flower-ct: add a table to map flow cookies to ct flows
      nfp: flower-ct: add tc_merge_tb
      nfp: flower-ct: add tc merge functionality
      nfp: flower-ct: add delete flow handling for ct
      nfp: flower-ct: add nft callback stubs
      nfp: flower-ct: add nft flows to nft list
      nfp: flower-ct: add nft_merge table
      nfp: flower-ct: implement code to save merge of tc and nft flows
      nfp: flower-ct: fill in ct merge check function
      nfp: flower-ct: fill ct metadata check function
      nfp: flower-ct: implement action_merge check

Luca Coelho (8):
      iwlwifi: mvm: pass the clock type to iwl_mvm_get_sync_time()
      iwlwifi: mvm: fix indentation in some scan functions
      iwlwifi: remove unused REMOTE_WAKE_CONFIG_CMD definitions
      iwlwifi: increase PNVM load timeout
      iwlwifi: fix NUM_IWL_UCODE_TLV_* definitions to avoid sparse errors
      iwlwifi: move UEFI code to a separate file
      iwlwifi: support loading the reduced power table from UEFI
      iwlwifi: bump FW API to 64 for AX devices

Luiz Augusto von Dentz (5):
      Bluetooth: L2CAP: Fix invalid access if ECRED Reconfigure fails
      Bluetooth: L2CAP: Fix invalid access on ECRED Connection response
      Bluetooth: mgmt: Fix slab-out-of-bounds in tlv_data_is_valid
      Bluetooth: Fix Set Extended (Scan Response) Data
      Bluetooth: Fix handling of HCI_LE_Advertising_Set_Terminated event

M Chetan Kumar (17):
      net: iosm: entry point
      net: iosm: irq handling
      net: iosm: mmio scratchpad
      net: iosm: shared memory IPC interface
      net: iosm: shared memory I/O operations
      net: iosm: channel configuration
      net: iosm: wwan port control device
      net: iosm: bottom half
      net: iosm: multiplex IP sessions
      net: iosm: encode or decode datagram
      net: iosm: power management
      net: iosm: shared memory protocol
      net: iosm: protocol operations
      net: iosm: uevent support
      net: iosm: net driver
      net: iosm: infrastructure
      net: wwan: iosm: Fix htmldocs warnings

Maciej Machnikowski (1):
      ice: add support for auxiliary input/output pins

Maciej Żenczykowski (5):
      inet_diag: add support for tw_mark
      bpf: Fix regression on BPF_OBJ_GET with non-O_RDWR flags
      Revert "bpf: Check for BPF_F_ADJ_ROOM_FIXED_GSO when bpf_skb_change_proto"
      bpf: Do not change gso_size during bpf_skb_change_proto()
      bpf: Support all gso types in bpf_skb_change_proto()

Magnus Karlsson (3):
      xsk: Use kvcalloc to support large umems
      xsk: Fix missing validation for skb and unaligned mode
      xsk: Fix broken Tx ring validation

Manish Mandlik (1):
      Bluetooth: Add ncmd=0 recovery handling

Marc Kleine-Budde (5):
      can: uapi: update CAN-FD frame description
      can: hi311x: hi3110_can_probe(): silence clang warning
      can: mcp251x: mcp251x_can_probe(): silence clang warning
      can: mcp251xfd: silence clang warning
      can: at91_can: silence clang warning

Marcel Holtmann (1):
      Bluetooth: Increment management interface revision

Marcelo Ricardo Leitner (7):
      tc-testing: fix list handling
      tc-testing: add support for sending various scapy packets
      tc-testing: add test for ct DNAT tuple collision
      sctp: validate from_addr_param return
      sctp: add size validation when walking chunks
      sctp: validate chunk size in __rcv_asconf_lookup
      sctp: add param size validation for SCTP_PARAM_SET_PRIMARY

Marcin Wojtas (8):
      Documentation: ACPI: DSD: describe additional MAC configuration
      net: mdiobus: Introduce fwnode_mdbiobus_register()
      net/fsl: switch to fwnode_mdiobus_register
      net: mvmdio: add ACPI support
      net: mvpp2: enable using phylink with ACPI
      net: mvpp2: remove unused 'has_phy' field
      net: mdiobus: fix fwnode_mdbiobus_register() fallback case
      net: mdiobus: withdraw fwnode_mdbiobus_register

Marek Behún (1):
      net: Kconfig: indent with tabs instead of spaces

Marek Vasut (2):
      rsi: Assign beacon rate settings to the correct rate_info descriptor field
      rsi: Add support for changing beacon interval

Mark Bloch (3):
      net/mlx5: Lag, refactor disable flow
      net/mlx5: Lag, Don't rescan if the device is going down
      net/mlx5: Change ownership model for lag

Martin Fuzzey (1):
      rsi: fix AP mode with WPA failure due to encrypted EAPOL

Martynas Pumputis (1):
      net: retrieve netns cookie via getsocketopt

Mateusz Palczewski (1):
      i40e: Fix autoneg disabling for non-10GBaseT links

Matteo Croce (14):
      mvpp2: remove unused parameter
      mvpp2: suppress warning
      net: bridge: fix build when IPv6 is disabled
      stmmac: use XDP helpers
      igc: use XDP helpers
      vhost_net: use XDP helpers
      mm: add a signature in struct page
      skbuff: add a parameter to __skb_frag_unref
      mvpp2: recycle buffers
      mvneta: recycle buffers
      mvpp2: prefetch right address
      mvpp2: prefetch page
      stmmac: prefetch right address
      stmmac: align RX buffers

Matthew Hagan (1):
      net: stmmac: explicitly deassert GMAC_AHB_RESET

Matthias Brugger (2):
      brcmfmac: Delete second brcm folder hierarchy
      brcmfmac: Add clm_blob firmware files to modinfo

Matthieu Baerts (4):
      mptcp: support SYSCTL only if enabled
      mptcp: restrict values of 'enabled' sysctl
      selftests: mptcp: display proper reason to abort tests
      mptcp: fix 'masking a bool' warning

Matti Gottlieb (1):
      iwlwifi: pcie: Add support for AX231 radio module with Ma devices

Meir Lichtinger (1):
      net/mlx5e: IPoIB, Add support for NDR speed

Menglong Dong (2):
      net: tipc: fix FB_MTU eat two pages
      net: tipc: replace align() with ALIGN in msg.c

Miao Wang (1):
      net/ipv4: swap flow ports when validating source

Michael Buesch (1):
      ssb: sdio: Don't overwrite const buffer if block_write fails

Michael Chan (4):
      bnxt_en: Update firmware interface to 1.10.2.47
      bnxt_en: Get PTP hardware capability from firmware
      bnxt_en: Add PTP clock APIs, ioctls, and ethtool methods
      bnxt_en: Enable hardware PTP support

Michael Grzeschik (2):
      net: phy: micrel: move phy reg offsets to common header
      net: dsa: microchip: ksz8795: add phylink support

Michael Sit Wei Hong (2):
      net: pcs: Introducing support for DWC xpcs Energy Efficient Ethernet
      net: stmmac: Add callbacks for DWC xpcs Energy Efficient Ethernet

Michael Walle (1):
      net: enetc: use get/put_unaligned helpers for MAC address handling

Michal Suchanek (2):
      ibmvnic: remove default label from to_string switch
      libbpf: Fix pr_warn type warnings on 32bit

Mikhail Rudenko (1):
      Bluetooth: btbcm: Add entry for BCM43430B0 UART Bluetooth

Miri Korenblit (2):
      iwlwifi: mvm: support BIOS enable/disable for 11ax in Russia
      cfg80211: set custom regdomain after wiphy registration

Mordechay Goodstein (1):
      mac80211: handle rate control (RC) racing with chanctx definition

Muhammad Husaini Zulkifli (1):
      igc: Enable HW VLAN Insertion and HW VLAN Stripping

Muhammad Usama Anjum (1):
      Bluetooth: btusb: fix memory leak

Mukesh Sisodiya (1):
      iwlwifi: yoyo: support region TLV version 2

Mykola Kostenok (4):
      mlxsw: reg: Extend MTMP register with new threshold field
      mlxsw: core_env: Read module temperature thresholds using MTMP register
      mlxsw: thermal: Add function for reading module temperature and thresholds
      mlxsw: thermal: Read module temperature thresholds using MTMP register

Naftali Goldstein (2):
      iwlwifi: mvm: don't request mac80211 to disable/enable sta's queues
      iwlwifi: support ver 6 of WOWLAN_CONFIGURATION and ver 10 of WOWLAN_GET_STATUSES

Namhyung Kim (1):
      bpf: Allow bpf_get_current_ancestor_cgroup_id for tracing

Nathan Chancellor (4):
      net: ks8851: Make ks8851_read_selftest() return void
      net: ethernet: rmnet: Restructure if checks to avoid uninitialized warning
      net/mlx5: Use cpumask_available() in mlx5_eq_create_generic()
      net: sparx5: Do not use mac_addr uninitialized in mchp_sparx5_probe()

Naveen Mamindlapalli (2):
      octeontx2-af: add support for multicast/promisc packet replication feature
      octeontx2-nicvf: add ndo_set_rx_mode support for multicast & promisc

Nguyen Dinh Phi (1):
      mac80211_hwsim: record stats in non-netlink path

Nicolas Dichtel (2):
      MAINTAINERS: netfilter: add irc channel
      dev_forward_skb: do not scrub skb mark within the same name space

Nigel Christian (3):
      net: bridge: remove redundant assignment
      NFC: microread: Remove redundant assignment to variable err
      Bluetooth: hci_uart: Remove redundant assignment to fw_ptr

Nikolay Aleksandrov (1):
      net: bridge: fix br_multicast_is_router stub when igmp is disabled

Nikolay Assa (1):
      qed: Add IP services APIs support

Norbert Slusarek (1):
      can: j1939: j1939_sk_setsockopt(): prevent allocation of j1939 filter for optlen == 0

Oleksandr Mazur (9):
      net: core: devlink: add dropped stats traps field
      testing: selftests: net: forwarding: add devlink-required functionality to test (hard) dropped stats field
      drivers: net: netdevsim: add devlink trap_drop_counter_get implementation
      testing: selftests: drivers: net: netdevsim: devlink: add test case for hard drop statistics
      net: marvell: prestera: devlink: add traps/groups implementation
      net: marvell: prestera: devlink: add traps with DROP action
      documentation: networking: devlink: add prestera switched driver Documentation
      documentation: networking: devlink: fix prestera.rst formatting that causes build warnings
      drivers: net: netdevsim: fix devlink_trap selftests failing

Oleksij Rempel (16):
      net: usb: asix: ax88772_bind: use devm_kzalloc() instead of kzalloc()
      net: usb: asix: refactor asix_read_phy_addr() and handle errors on return
      net: usb/phy: asix: add support for ax88772A/C PHYs
      net: usb: asix: ax88772: add phylib support
      net: usb: asix: ax88772: add generic selftest support
      net: usb: asix: add error handling for asix_mdio_* functions
      net: phy: do not print dump stack if device was removed
      usbnet: run unbind() before unregister_netdev()
      net: usb: asix: ax88772: manage PHY PM from MAC
      net: phy: micrel: use consistent alignments
      net: phy/dsa micrel/ksz886x add MDI-X support
      net: phy: micrel: ksz8081 add MDI-X support
      net: dsa: microchip: ksz8795: add LINK_MD register support
      net: dsa: dsa_slave_phy_connect(): extend phy's flags with port specific phy flags
      net: phy: micrel: ksz886x/ksz8081: add cabletest support
      can: j1939: j1939_sk_init(): set SOCK_RCU_FREE to call sk_destruct() after RCU is done

Oliver Hartkopp (3):
      can: uapi: introduce CANFD_FDF flag for mixed content in struct canfd_frame
      can: gw: synchronize rcu operations before removing gw job entry
      can: isotp: isotp_release(): omit unintended hrtimer restart on socket release

Omkar Kulkarni (1):
      qed: Add TCP_ULP FW resource layout

Oz Shlomo (4):
      netfilter: conntrack: Introduce tcp offload timeout configuration
      netfilter: conntrack: Introduce udp offload timeout configuration
      netfilter: flowtable: Set offload timeouts according to proto values
      docs: networking: Update connection tracking offload sysctl parameters

Pablo Neira Ayuso (13):
      netfilter: use nfnetlink_unicast()
      netfilter: nfnetlink: add struct nfgenmsg to struct nfnl_info and use it
      netfilter: nf_tables: remove nft_ctx_init_from_elemattr()
      netfilter: nf_tables: remove nft_ctx_init_from_setattr()
      netfilter: nftables: add nf_ct_pernet() helper function
      netfilter: nft_exthdr: check for IPv6 packet before further processing
      netfilter: nft_osf: check for TCP packet before further processing
      netfilter: nft_tproxy: restrict support to TCP and UDP transport protocols
      netfilter: nf_tables: add last expression
      netfilter: nf_tables: memleak in hw offload abort path
      netfilter: nf_tables_offload: check FLOW_DISSECTOR_KEY_BASIC in VLAN transfer logic
      netfilter: nf_tables: skip netlink portID validation if zero
      netfilter: nf_tables: do not allow to delete table with owner by handle

Pali Rohár (1):
      ath9k: Fix kernel NULL pointer dereference during ath_reset_internal()

Paolo Abeni (12):
      mptcp: validate the data checksum
      mptcp: tune re-injections for csum enabled mode
      mptcp: fix bad handling of 32 bit ack wrap-around
      mptcp: fix 32 bit DSN expansion
      mptcp: drop tx skb cache
      mptcp: use fast lock for subflows when possible
      mptcp: don't clear MPTCP_DATA_READY in sk_wait_event()
      mptcp: drop redundant test in move_skbs_to_msk()
      mptcp: add MIB counter for invalid mapping
      mptcp: avoid race on msk state changes
      mptcp: drop duplicate mptcp_setsockopt() declaration
      mptcp: refine mptcp_cleanup_rbuf

Paolo Pisati (1):
      selftests: net: devlink_port_split: check devlink returned an element before dereferencing it

Pascal Terjan (1):
      rtl8xxxu: Fix device info for RTL8192EU devices

Patrick Menschel (3):
      can: isotp: change error format from decimal to symbolic error names
      can: isotp: add symbolic error message to isotp_module_init()
      can: isotp: Add error message if txqueuelen is too small

Paul Blakey (7):
      net/mlx5: CT: Avoid reusing modify header context for natted entries
      net/mlx5e: TC: Use bit counts for register mapping
      net/mlx5: Add case for FS_FT_NIC_TX FT in MLX5_CAP_FLOWTABLE_TYPE
      net/mlx5: Move table size calculation to steering cmd layer
      net/mlx5: Move chains ft pool to be used by all firmware steering
      net/mlx5: DR, Set max table size to 2G entries
      net/mlx5: Cap the maximum flow group size to 16M entries

Paul E. McKenney (2):
      rcu: Create an unrcu_pointer() to remove __rcu from a pointer
      doc: Clarify and expand RCU updaters and corresponding readers

Paul M Stillwell Jr (3):
      ice: fix clang warning regarding deadcode.DeadStores
      ice: reduce scope of variables
      ice: remove local variable

Pavan Chebbi (3):
      bnxt_en: Get the full 48-bit hardware timestamp periodically
      bnxt_en: Get the RX packet timestamp
      bnxt_en: Transmit and retrieve packet timestamps

Pavel Machek (1):
      net: pxa168_eth: Fix a potential data race in pxa168_eth_remove

Pavel Skripkin (7):
      net: ethernet: aeroflex: fix UAF in greth_of_remove
      net: ethernet: ezchip: fix UAF in nps_enet_remove
      net: ethernet: ezchip: remove redundant check
      net: ethernet: ezchip: fix error handling
      net: can: ems_usb: fix use-after-free in ems_usb_disconnect()
      Bluetooth: hci_qca: fix potential GPF
      net: sched: fix warning in tcindex_alloc_perfect_hash

Peng Li (166):
      net: hns: fix the comments style issue
      net: hns: fix some code style issue about space
      net: hns: space required before the open brace '{'
      net: hns: remove redundant return int void function
      net: wan: remove redundant blank lines
      net: wan: add some required spaces
      net: wan: remove redundant braces {}
      net: wan: remove redundant space
      net: wan: fix variable definition style
      net: wan: fix an code style issue about "foo* bar"
      net: wan: add some required spaces
      net: wan: fix the code style issue about trailing statements
      net: wan: remove redundant blank lines
      net: wan: add braces {} to all arms of the statement
      net: wan: add necessary () to macro argument
      net: wan: remove redundant blank lines
      net: wan: fix an code style issue about "foo* bar"
      net: wan: add blank line after declarations
      net: wan: code indent use tabs where possible
      net: wan: fix the code style issue about trailing statements
      net: wan: add some required spaces
      net: wan: move out assignment in if condition
      net: wan: replace comparison to NULL with "!card"
      net: wan: fix the comments style issue
      net: wan: add braces {} to all arms of the statement
      net: wan: remove redundant blank lines
      net: wan: add blank line after declarations
      net: wan: fix an code style issue about "foo* bar
      net: wan: add some required spaces
      net: wan: replace comparison to NULL with "!card"
      net: wan: add spaces required around that ':' and '+'
      net: hdlc_fr: remove redundant blank lines
      net: hdlc_fr: add blank line after declarations
      net: hdlc_fr: fix an code style issue about "foo* bar"
      net: hdlc_fr: add some required spaces
      net: hdlc_fr: move out assignment in if condition
      net: hdlc_fr: code indent use tabs where possible
      net: hdlc_fr: remove space after '!'
      net: hdlc_fr: add braces {} to all arms of the statement
      net: hdlc_fr: remove redundant braces {}
      net: hdlc_fr: remove unnecessary out of memory message
      net: sealevel: remove redundant blank lines
      net: sealevel: add blank line after declarations
      net: sealevel: fix the code style issue about "foo* bar"
      net: sealevel: open brace '{' following struct go on the same line
      net: sealevel: add some required spaces
      net: sealevel: remove redundant initialization for statics
      net: sealevel: fix a code style issue about switch and case
      net: sealevel: remove meaningless comments
      net: sealevel: fix the comments style issue
      net: sealevel: fix the alignment issue
      net: hdlc: remove redundant blank lines
      net: hdlc: add blank line after declarations
      net: hdlc: fix an code style issue about "foo* bar"
      net: hdlc: fix an code style issue about EXPORT_SYMBOL(foo)
      net: hdlc: replace comparison to NULL with "!param"
      net: hdlc: move out assignment in if condition
      net: hdlc: add braces {} to all arms of the statement
      net: hdlc_cisco: remove redundant blank lines
      net: hdlc_cisco: fix the code style issue about "foo* bar"
      net: hdlc_cisco: add some required spaces
      net: hdlc_cisco: remove unnecessary out of memory message
      net: hdlc_cisco: add blank line after declaration
      net: hdlc_cisco: remove redundant space
      net: hdlc_x25: remove redundant blank lines
      net: hdlc_x25: remove unnecessary out of memory message
      net: hdlc_x25: move out assignment in if condition
      net: hdlc_x25: add some required spaces
      net: hdlc_x25: fix the code issue about "if..else.."
      net: hdlc_x25: fix the alignment issue
      net: hd64570: remove redundant blank lines
      net: hd64570: add blank line after declarations
      net: hd64570: fix the code style issue about "foo* bar"
      net: hd64570: fix the code style issue about trailing statements
      net: hd64570: add braces {} to all arms of the statement
      net: hd64570: fix the comments style issue
      net: hd64570: remove redundant parentheses
      net: hd64570: add some required spaces
      net: farsync: remove redundant blank lines
      net: farsync: add blank line after declarations
      net: farsync: fix the code style issue about "foo* bar"
      net: farsync: move out assignment in if condition
      net: farsync: remove redundant initialization for statics
      net: farsync: fix the comments style issue
      net: farsync: remove trailing whitespaces
      net: farsync: code indent use tabs where possible
      net: farsync: fix the code style issue about macros
      net: farsync: add some required spaces
      net: farsync: remove redundant braces {}
      net: farsync: remove redundant spaces
      net: farsync: remove redundant parentheses
      net: farsync: fix the alignment issue
      net: farsync: remove redundant return
      net: farsync: replace comparison to NULL with "fst_card_array[i]"
      net: lapbether: remove redundant blank line
      net: lapbether: add blank line after declarations
      net: lapbether: move out assignment in if condition
      net: lapbether: remove trailing whitespaces
      net: lapbether: remove unnecessary out of memory message
      net: lapbether: fix the comments style issue
      net: lapbether: replace comparison to NULL with "lapbeth_get_x25_dev"
      net: lapbether: fix the alignment issue
      net: lapbether: fix the code style issue about line length
      net: ixp4xx_hss: remove redundant blank lines
      net: ixp4xx_hss: add blank line after declarations
      net: ixp4xx_hss: fix the code style issue about "foo* bar"
      net: ixp4xx_hss: move out assignment in if condition
      net: ixp4xx_hss: add some required spaces
      net: ixp4xx_hss: remove redundant spaces
      net: ixp4xx_hss: fix the comments style issue
      net: ixp4xx_hss: add braces {} to all arms of the statement
      net: pc300too: remove redundant blank lines
      net: pc300too: add blank line after declarations
      net: pc300too: fix the code style issue about "foo * bar"
      net: pc300too: move out assignment in if condition
      net: pc300too: remove redundant initialization for statics
      net: pc300too: replace comparison to NULL with "!card->plxbase"
      net: pc300too: add some required spaces
      net: pc300too: fix the comments style issue
      net: z85230: remove redundant blank lines
      net: z85230: add blank line after declarations
      net: z85230: fix the code style issue about EXPORT_SYMBOL(foo)
      net: z85230: replace comparison to NULL with "!skb"
      net: z85230: fix the comments style issue
      net: z85230: fix the code style issue about "if..else.."
      net: z85230: remove trailing whitespaces
      net: z85230: add some required spaces
      net: z85230: fix the code style issue about open brace {
      net: z85230: remove unnecessary out of memory message
      net: pci200syn: remove redundant blank lines
      net: pci200syn: add blank line after declarations
      net: pci200syn: replace comparison to NULL with "!card"
      net: pci200syn: add some required spaces
      net: pci200syn: add necessary () to macro argument
      net: pci200syn: fix the comments style issue
      net: cosa: remove redundant blank lines
      net: cosa: add blank line after declarations
      net: cosa: fix the code style issue about "foo* bar"
      net: cosa: replace comparison to NULL with "!chan->rx_skb"
      net: cosa: move out assignment in if condition
      net: cosa: fix the comments style issue
      net: cosa: add braces {} to all arms of the statement
      net: cosa: remove redundant braces {}
      net: cosa: add necessary () to macro argument
      net: cosa: use BIT macro
      net: cosa: fix the alignment issue
      net: cosa: fix the code style issue about trailing statements
      net: cosa: add some required spaces
      net: cosa: remove trailing whitespaces
      net: cosa: remove redundant spaces
      net: hdlc_ppp: remove redundant blank lines
      net: hdlc_ppp: add blank line after declarations
      net: hdlc_ppp: fix the code style issue about "foo* bar"
      net: hdlc_ppp: move out assignment in if condition
      net: hdlc_ppp: remove unnecessary out of memory message
      net: hdlc_ppp: add required space
      net: hostess_sv11: fix the code style issue about "foo* bar"
      net: hostess_sv11: move out assignment in if condition
      net: hostess_sv11: remove trailing whitespace
      net: hostess_sv11: fix the code style issue about switch and case
      net: hostess_sv11: remove dead code
      net: hostess_sv11: fix the comments style issue
      net: hostess_sv11: fix the alignment issue
      net: c101: add blank line after declarations
      net: c101: replace comparison to NULL with "!card"
      net: c101: remove redundant spaces

Peter Geis (3):
      net: phy: add driver for Motorcomm yt8511 phy
      net: phy: fix yt8511 clang uninitialized variable warning
      net: phy: abort loading yt8511 driver in unsupported modes

Petr Machata (4):
      selftests: mlxsw: qos_headroom: Convert to iproute2 dcb
      selftests: mlxsw: qos_pfc: Convert to iproute2 dcb
      selftests: mlxsw: qos_lib: Drop __mlnx_qos
      selftests: devlink_lib: Fix bouncing of netdevsim DEVLINK_DEV

Petr Oros (1):
      Revert "be2net: disable bh with spin_lock in be_process_mcc"

Phil Sutter (4):
      netfilter: nft_exthdr: Support SCTP chunks
      netfilter: nft_exthdr: Fix for unsafe packet data read
      netfilter: nft_exthdr: Search chunks in SCTP packets only
      netfilter: nft_extdhr: Drop pointless check of tprot_set

Philipp Borgers (5):
      ath9k: ar9003_mac: read STBC indicator from rx descriptor
      mac80211: minstrel_ht: ignore frame that was sent with noAck flag
      mac80211: add ieee80211_is_tx_data helper function
      mac80211: do not use low data rates for data frames with no ack flag
      mac80211: refactor rc_no_data_or_no_ack_use_min function

Ping-Ke Shih (5):
      rtlwifi: 8821a: btcoexist: add comments to explain why if-else branches are identical
      rtw88: add quirks to disable pci capabilities
      cfg80211: fix default HE tx bitrate mask in 2G band
      mac80211: remove iwlwifi specific workaround NDPs of null_response
      Revert "mac80211: HE STA disassoc due to QOS NULL not sent"

Po-Hao Huang (6):
      rtw88: add beacon filter support
      rtw88: add path diversity
      rtw88: 8822c: fix lc calibration timing
      rtw88: 8822c: update RF parameter tables to v62
      rtw88: refine unwanted h2c command
      rtw88: fix c2h memory leak

Po-Hsu Lin (1):
      selftests: net: devlink_port_split.py: skip the test if no devlink device

Prabhakar Kushwaha (3):
      qed: Add support of HW filter block
      nvme-fabrics: Move NVMF_ALLOWED_OPTS and NVMF_REQUIRED_OPTS definitions
      nvme-fabrics: Expose nvmf_check_required_opts() globally

Pu Lehui (2):
      alx: fix missing unlock on error in alx_set_pauseparam()
      bpf: Make some symbols static

Qiheng Lin (1):
      Bluetooth: use flexible-array member instead of zero-length array

Qing Zhang (4):
      stmmac: pci: Add dwmac support for Loongson
      MIPS: Loongson64: Add GMAC support for Loongson-2K1000
      MIPS: Loongson64: DTS: Add GMAC support for LS7A PCH
      dt-bindings: dwmac: Add bindings for new Loongson SoC and bridge chip

Radu Pirea (NXP OSS) (2):
      ptp: ptp_clock: make scaled_ppm_to_ppb static inline
      phy: nxp-c45-tja11xx: add timestamping support

Raed Salem (1):
      net/mlx5e: Add IPsec support to uplink representor

Rafał Miłecki (2):
      dt-bindings: net: brcm,iproc-mdio: convert to the json-schema
      net: broadcom: bcm4908_enet: reset DMA rings sw indexes properly

Randy Dunlap (1):
      wireless: carl9170: fix LEDS build errors & warnings

Ravi Bangoria (1):
      bpf, x86: Fix extable offset calculation

Rocco Yue (1):
      ipv6: align code with context

Roi Dayan (1):
      net/mlx5e: CT, Remove newline from ct_dbg call

Russell King (5):
      net: phy: marvell: use phy_modify_changed() for marvell_set_polarity()
      wlcore: tidy up use of fw_log.actual_buff_size
      wlcore: make some of the fwlog calculations more obvious
      wlcore: fix bug reading fwlog
      wlcore: fix read pointer update

Rustam Kovhaev (1):
      bpf: Fix false positive kmemleak report in bpf_ringbuf_area_alloc()

Ryder Lee (20):
      mt76: mt7915: cleanup mt7915_mcu_sta_rate_ctrl_tlv()
      mt76: mt7915: add .set_bitrate_mask() callback
      mt76: mt7915: add thermal sensor device support
      mt76: mt7915: add thermal cooling device support
      mt76: mt7615: add thermal sensor device support
      mt76: mt7915: add .offset_tsf callback
      mt76: mt7615: add .offset_tsf callback
      mt76: mt7615: fix potential overflow on large shift
      mt76: mt7915: use mt7915_mcu_get_mib_info() to get survey data
      mt76: mt7915: setup drr group for peers
      mt76: mt7615: update radar parameters
      mt76: mt7915: fix MT_EE_CAL_GROUP_SIZE
      mt76: make mt76_update_survey() per phy
      mt76: mt7915: introduce mt7915_mcu_set_txbf()
      mt76: mt7915: improve MU stability
      mt76: mt7915: fix IEEE80211_HE_PHY_CAP7_MAX_NC for station mode
      mt76: fix iv and CCMP header insertion
      mac80211: call ieee80211_tx_h_rate_ctrl() when dequeue
      mac80211: add rate control support for encap offload
      mac80211: check per vif offload_flags in Tx path

Sabrina Dubroca (2):
      xfrm: xfrm_state_mtu should return at least 1280 for ipv6
      xfrm: add state hashtable keyed by seq

Salil Mehta (1):
      ice: Re-organizes reqstd/avail {R, T}XQ check/code for efficiency

Sasha Neftin (5):
      igc: Update driver to use ethtool_sprintf
      igc: Remove unused asymmetric pause bit from igc defines
      igc: Remove unused MDICNFG register
      igc: Indentation fixes
      e1000e: Check the PCIm state

Sathish Narasimman (1):
      Bluetooth: Translate additional address type during le_conn_comp

Saurav Girepunje (1):
      zd1211rw: Prefer pr_err over printk error msg

Sean Wang (14):
      mt76: mt7921: fix mt7921_wfsys_reset sequence
      mt76: mt7921: Don't alter Rx path classifier
      mt76: connac: fw_own rely on all packet memory all being free
      mt76: mt7921: fix reset under the deep sleep is enabled
      mt76: mt7921: consider the invalid value for to_rssi
      mt76: mt7921: add back connection monitor support
      mt76: mt7921: avoid unnecessary consecutive WiFi resets
      mt76: mt7921: fix invalid register access in wake_work
      mt76: mt7921: fix OMAC idx usage
      mt76: connac: fix the maximum interval schedule scan can support
      mt76: mt7921: enable deep sleep at runtime
      mt76: mt7921: add deep sleep control to runtime-pm knob
      mt76: mt7921: fix kernel warning when reset on vif is not sta
      mt76: mt7921: fix the coredump is being truncated

Sean Young (1):
      media, bpf: Do not copy more entries than user space requested

Sebastian Andrzej Siewior (2):
      net: Treat __napi_schedule_irqoff() as __napi_schedule() on PREEMPT_RT
      net/netif_receive_skb_core: Use migrate_disable()

Seevalamuthu Mariappan (1):
      ath11k: send beacon template after vdev_start/restart during csa

Sergey Ryazanov (20):
      wwan_hwsim: WWAN device simulator
      wwan_hwsim: add debugfs management interface
      net: wwan: make WWAN_PORT_MAX meaning less surprised
      net: wwan: core: init port type string array using enum values
      net: wwan: core: spell port device name in lowercase
      net: wwan: core: make port names more user-friendly
      net: wwan: core: expand ports number limit
      net: wwan: core: implement TIOCINQ ioctl
      net: wwan: core: implement terminal ioctls for AT port
      net: wwan: core: purge rx queue on port close
      wwan_hwsim: support network interface creation
      wwan: core: relocate ops registering code
      wwan: core: require WWAN netdev setup callback existence
      wwan: core: multiple netdevs deletion support
      wwan: core: remove all netdevs on ops unregistering
      net: iosm: drop custom netdev(s) removing
      wwan: core: no more hold netdev ops owning module
      wwan: core: support default netdev creation
      net: iosm: create default link via WWAN core
      wwan: core: add WWAN common private data for netdev

Serhiy Boiko (3):
      net: marvell: prestera: add LAG support
      net: marvell: Implement TC flower offload
      net: marvell: prestera: Add matchall support

Seth David Schoen (2):
      ip: Treat IPv4 segment's lowest address as unicast
      selftests: Lowest IPv4 address in a subnet is valid

Shai Malin (6):
      qed: Add NVMeTCP Offload PF Level FW and HW HSI
      qed: Add NVMeTCP Offload Connection Level FW and HW HSI
      qed: Add NVMeTCP Offload IO Level FW and HW HSI
      qed: Add NVMeTCP Offload IO Level FW Initializations
      nvme-tcp-offload: Add nvme-tcp-offload - NVMeTCP HW offload ULP
      Revert "nvme-tcp-offload: ULP Series"

Shaokun Zhang (11):
      batman-adv: Remove the repeated declaration
      bnx2x: Remove the repeated declaration
      xfrm: Remove the repeated declaration
      qlcnic: Remove the repeated declaration
      net/mlx5e: Remove the repeated declaration
      net: tulip: Remove the repeated declaration
      brcmsmac: Remove the repeated declaration
      ath10k: remove the repeated declaration
      net: iosm: remove the repeated declaration and comment
      ice: Remove the repeated declaration
      mac80211: remove the repeated declaration

Sharath Chandra Vurukala (3):
      docs: networking: Add documentation for MAPv5
      net: ethernet: rmnet: Support for ingress MAPv5 checksum offload
      net: ethernet: rmnet: Add support for MAPv5 egress packets

Shaul Triebitz (4):
      iwlwifi: mvm: fix error print when session protection ends
      iwlwifi: advertise broadcast TWT support
      mac80211: move SMPS mode setting after ieee80211_prep_connection
      mac80211: add to bss_conf if broadcast TWT is supported

Shawn Guo (2):
      brcmfmac: use ISO3166 country code and 0 rev as fallback
      brcmfmac: support parse country code map from DT

Shay Agroskin (10):
      net: ena: optimize data access in fast-path code
      net: ena: Remove unused code
      net: ena: Improve error logging in driver
      net: ena: use build_skb() in RX path
      net: ena: add jiffies of last napi call to stats
      net: ena: Remove module param and change message severity
      net: ena: fix RST format in ENA documentation file
      net: ena: aggregate doorbell common operations into a function
      net: ena: Use dev_alloc() in RX buffer allocation
      net: ena: re-organize code to improve readability

Shay Drory (9):
      net/mlx5: Introduce API for request and release IRQs
      net/mlx5: Removing rmap per IRQ
      net/mlx5: Extend mlx5_irq_request to request IRQ from the kernel
      net/mlx5: Moving rmap logic to EQs
      net/mlx5: Change IRQ storage logic from static to dynamic
      net/mlx5: Allocating a pool of MSI-X vectors for SFs
      net/mlx5: Enlarge interrupt field in CREATE_EQ
      net/mlx5: Separate between public and private API of sf.h
      net/mlx5: Round-Robin EQs over IRQs

Shayne Chen (4):
      mt76: mt7915: use mt7915_mcu_get_txpower_sku() to get per-rate txpower
      mt76: mt7915: read all eeprom fields from fw in efuse mode
      mt76: testmode: move chip-specific stats dump before common stats
      mt76: mt7915: fix rx fcs error count in testmode

Shiraz Saleem (2):
      i40e: Prep i40e header for aux bus conversion
      i40e: Register auxiliary devices to provide RDMA

Shubhankar Kuranagatti (3):
      ssb: gpio: Fix alignment of comment
      ssb: pcicore: Fix indentation of comment
      ssb: Fix indentation of comment

Shuyi Cheng (1):
      bpf: Fix typo in kernel/bpf/bpf_lsm.c

Simon Wunderlich (1):
      batman-adv: Start new development cycle

Sosthène Guédon (1):
      nl80211: Fix typo pmsr->pmsr

Souptick Joarder (1):
      ipw2x00: Minor documentation update

Stanislav Fomichev (1):
      libbpf: Skip bpf_object__probe_loading for light skeleton

Stanislaw Gruszka (1):
      rt2x00: do not set timestamp for injected frames

Stanislaw Kardach (1):
      octeontx2-af: add support for custom KPU entries

Steen Hegelund (14):
      dt-bindings: net: Add 25G BASE-R phy interface
      net: phy: Add 25G BASE-R interface mode
      net: sfp: add support for 25G BASE-R SFPs
      net: phylink: Add 25G BASE-R support
      dt-bindings: net: sparx5: Add sparx5-switch bindings
      net: sparx5: add the basic sparx5 driver
      net: sparx5: add hostmode with phylink support
      net: sparx5: add port module support
      net: sparx5: add mactable support
      net: sparx5: add vlan support
      net: sparx5: add switching support
      net: sparx5: add calendar bandwidth allocation support
      net: sparx5: add ethtool configuration and statistics support
      arm64: dts: sparx5: Add the Sparx5 switch node

Stefan Wahren (3):
      net: qca_spi: Avoid reading signature three times in a row
      net: qca_spi: Avoid re-sync for single signature error
      net: qca_spi: Introduce stat about bad signature

Stefano Brivio (1):
      netfilter: nft_set_pipapo_avx2: Skip LDMXCSR, we don't need a valid MXCSR state

Stefano Garzarella (3):
      vsock: rename vsock_has_data()
      vsock: rename vsock_wait_data()
      vsock/virtio: remove redundant `copy_failed` variable

Steffen Klassert (1):
      xfrm: Fix error reporting in xfrm_state_construct.

Stephan Gerhold (5):
      dt-bindings: net: nfc: s3fwrn5: Add optional clock
      nfc: s3fwrn5: i2c: Enable optional clock from device tree
      rpmsg: core: Add driver_data for rpmsg_device_id
      net: wwan: Add RPMSG WWAN CTRL driver
      net: wwan: Allow WWAN drivers to provide blocking tx and poll function

Stephane Grosjean (1):
      can: peak_pciefd: pucan_handle_status(): fix a potential starvation issue in TX path

Subash Abhinov Kasiviswanathan (1):
      net: qualcomm: rmnet: Remove some unneeded casts

Subbaraya Sundeep (2):
      octeontx2-pf: Use NL_SET_ERR_MSG_MOD for TC
      octeontx2-pf: Add police action for TC flower

Sukadev Bhattiprolu (6):
      Revert "ibmvnic: simplify reset_long_term_buff function"
      ibmvnic: clean pending indirect buffs during reset
      ibmvnic: account for bufs already saved in indir_buf
      ibmvnic: set ltb->buff to NULL after freeing
      ibmvnic: free tx_pool if tso_pool alloc fails
      ibmvnic: parenthesize a check

Sunil Goutham (4):
      octeontx2-pf: Cleanup flow rule management
      octeontx2-af: cn10k: Bandwidth profiles config support
      octeontx2-af: cn10k: Debugfs support for bandwidth profiles
      octeontx2-pf: TC_MATCHALL ingress ratelimiting offload

Sven Eckelmann (5):
      batman-adv: Always send iface index+name in genlmsg
      batman-adv: Drop implicit creation of batadv net_devices
      batman-adv: Avoid name based attaching of hard interfaces
      batman-adv: Don't manually reattach hard-interface
      batman-adv: Drop reduntant batadv interface check

Szymon Janc (1):
      Bluetooth: Remove spurious error message

Taehee Yoo (1):
      mld: avoid unnecessary high order page allocation in mld_newpack()

Tan Zhongjun (1):
      soc: qcom: ipa: Remove superfluous error message around platform_get_irq()

Tanner Love (2):
      once: implement DO_ONCE_LITE for non-fast-path "do once" functionality
      net: update netdev_rx_csum_fault() print dump only once

Tariq Toukan (3):
      net/mlx5e: RX, Remove unnecessary check in RX CQE compression handling
      net/mlx5e: RX, Re-place page pool numa node change logic
      net/mlx5e: kTLS, Add stats for number of deleted kTLS TX offloaded connections

Tedd Ho-Jeong An (1):
      Bluetooth: mgmt: Fix the command returns garbage parameter value

Thadeu Lima de Souza Cascardo (2):
      can: bcm: delay release of struct bcm_op after synchronize_rcu()
      Bluetooth: cmtp: fix file refcount when cmtp_attach_device fails

Tian Tao (1):
      ssb: remove unreachable code

Tiezhu Yang (2):
      bpf, arm64: Replace STACK_ALIGN() with round_up() to align stack size
      bpf, arm64: Remove redundant switch case about BPF_DIV and BPF_MOD

Tim Jiang (2):
      Bluetooth: btusb: use default nvm if boardID is 0 for wcn6855.
      Bluetooth: btusb: fix bt fiwmare downloading failure issue for qca btsoc.

Tobias Schramm (3):
      dt-bindings: net: rockchip-dwmac: add rk3308 gmac compatible
      net: stmmac: dwmac-rk: add support for rk3308 gmac
      arm64: dts: rockchip: add gmac to rk3308 dts

Tobias Waldekranz (2):
      net: bridge: switchdev: send FDB notifications for host addresses
      net: dsa: include bridge addresses which are local in the host fdb list

Toke Høiland-Jørgensen (18):
      mac80211: Switch to a virtual time-based airtime scheduler
      doc: Give XDP as example of non-obvious RCU reader/updater pairing
      bpf: Allow RCU-protected lookups to happen from bh context
      xdp: Add proper __rcu annotations to redirect map entries
      bpf, sched: Remove unneeded rcu_read_lock() around BPF program invocation
      ena: Remove rcu_read_lock() around XDP program invocation
      bnxt: Remove rcu_read_lock() around XDP program invocation
      thunderx: Remove rcu_read_lock() around XDP program invocation
      freescale: Remove rcu_read_lock() around XDP program invocation
      intel: Remove rcu_read_lock() around XDP program invocation
      marvell: Remove rcu_read_lock() around XDP program invocation
      mlx4: Remove rcu_read_lock() around XDP program invocation
      nfp: Remove rcu_read_lock() around XDP program invocation
      qede: Remove rcu_read_lock() around XDP program invocation
      sfc: Remove rcu_read_lock() around XDP program invocation
      netsec: Remove rcu_read_lock() around XDP program invocation
      stmmac: Remove rcu_read_lock() around XDP program invocation
      ti: Remove rcu_read_lock() around XDP program invocation

Tom Rix (2):
      mt76: add a space between comment char and SPDX tag
      mt76: use SPDX header file comment style

Tong Tiangen (1):
      brcmfmac: Fix a double-free in brcmf_sdio_bus_reset

Tony Ambardar (1):
      bpf: Fix libelf endian handling in resolv_btfids

Tony Lindgren (1):
      wlcore/wl12xx: Fix wl12xx get_mac error if device is in ELP

Tony Nguyen (1):
      ice: remove unnecessary VSI assignment

Torin Cooper-Bennun (4):
      can: m_can: use bits.h macros for all regmasks
      can: m_can: clean up CCCR reg defs, order by revs
      can: m_can: make TXESC, RXESC config more explicit
      can: m_can: fix whitespace in a few comments

Tudor Ambarus (1):
      wilc1000: Fix clock name binding

Vadim Fedorenko (1):
      net: lwtunnel: handle MTU calculation in forwading

Vadym Kochan (6):
      net: marvell: prestera: disable events interrupt while handling
      net: marvell: prestera: align flood setting according to latest firmware version
      net: marvell: prestera: bump supported firmware version to 3.0
      net: marvell: prestera: try to load previous fw version
      net: marvell: prestera: move netdev topology validation to prestera_main
      net: marvell: prestera: do not propagate netdev events to prestera_switchdev.c

Varad Gautam (1):
      xfrm: policy: Read seqcount outside of rcu-read side in xfrm_policy_lookup_bytype

Venkata Lakshmi Narayana Gubba (5):
      Bluetooth: hci_qca: Add support for QTI Bluetooth chip wcn6750
      Bluetooth: btqca: Add support for firmware image with mbn type for WCN6750
      Bluetooth: btqca: Moved extracting rom version info to common place
      dt-bindings: net: bluetooth: Convert Qualcomm BT binding to DT schema
      dt-bindings: net: bluetooth: Add device tree bindings for QTI chip wcn6750

Victor Raj (1):
      ice: remove the VSI info from previous agg

Vignesh Raghavendra (1):
      net: ti: am65-cpsw-nuss: Fix crash when changing number of TX queues

Vlad Buslov (10):
      net/mlx5: Create TC-miss priority and table
      net/mlx5e: Refactor mlx5e_eswitch_{*}rep() helpers
      net/mlx5: Bridge, add offload infrastructure
      net/mlx5: Bridge, handle FDB events
      net/mlx5: Bridge, dynamic entry ageing
      net/mlx5: Bridge, implement infrastructure for vlans
      net/mlx5: Bridge, match FDB entry vlan tag
      net/mlx5: Bridge, support pvid and untagged vlan configurations
      net/mlx5: Bridge, filter tagged packets that didn't match tagged fg
      net/mlx5: Bridge, add tracepoints

Vladimir Oltean (109):
      net: mdio: provide shim implementation of devm_of_mdiobus_register
      net: dsa: sja1105: send multiple spi_messages instead of using cs_change
      net: dsa: sja1105: adapt to a SPI controller with a limited max transfer size
      net: dsa: sja1105: stop reporting the queue levels in ethtool port counters
      net: dsa: sja1105: don't use burst SPI reads for port statistics
      dpaa2-eth: don't print error from dpaa2_mac_connect if that's EPROBE_DEFER
      net: dsa: sja1105: parameterize the number of ports
      net: dsa: sja1105: avoid some work for unused ports
      net: dsa: sja1105: dimension the data structures for a larger port count
      net: dsa: sja1105: don't assign the host port using dsa_upstream_port()
      net: dsa: sja1105: skip CGU configuration if it's unnecessary
      net: dsa: sja1105: dynamically choose the number of static config table entries
      net: dsa: sja1105: use sja1105_xfer_u32 for the reset procedure
      net: dsa: sja1105: configure the multicast policers, if present
      net: dsa: sja1105: allow the frame buffer size to be customized
      net: stmmac: the XPCS obscures a potential "PHY not found" error
      net: dsa: sja1105: be compatible with "ethernet-ports" OF node name
      net: dsa: sja1105: allow SGMII PCS configuration to be per port
      net: dsa: sja1105: the 0x1F0000 SGMII "base address" is actually MDIO_MMD_VEND2
      net: dsa: sja1105: cache the phy-mode port property
      net: dsa: sja1105: add a PHY interface type compatibility matrix
      net: dsa: sja1105: add a translation table for port speeds
      net: dsa: sja1105: always keep RGMII ports in the MAC role
      net: dsa: sja1105: some table entries are always present when read dynamically
      net: enetc: catch negative return code from enetc_pf_to_port()
      net: pcs: xpcs: delete shim definition for mdio_xpcs_get_ops()
      net: pcs: xpcs: there is only one PHY ID
      net: pcs: xpcs: make the checks related to the PHY interface mode stateless
      net: pcs: xpcs: export xpcs_validate
      net: pcs: xpcs: export xpcs_config_eee
      net: pcs: xpcs: export xpcs_probe
      net: pcs: xpcs: use mdiobus_c45_addr in xpcs_{read,write}
      net: pcs: xpcs: convert to mdio_device
      net: pcs: xpcs: convert to phylink_pcs_ops
      net: phy: introduce PHY_INTERFACE_MODE_REVRMII
      net: dsa: sja1105: apply RGMII delays based on the fixed-link property
      net: dsa: sja1105: determine PHY/MAC role from PHY interface type
      dt-bindings: net: dsa: sja1105: convert to YAML schema
      dt-bindings: net: dsa: sja1105: add SJA1110 bindings
      net: dsa: sja1105: add support for the SJA1110 switch family
      net: dsa: sja1105: make sure the retagging port is enabled for SJA1110
      net: dsa: sja1105: register the MDIO buses for 100base-T1 and 100base-TX
      net: stmmac: fix NPD with phylink_set_pcs if there is no MDIO bus
      net: dsa: felix: set TX flow control according to the phylink_mac_link_up resolution
      net: dsa: sja1105: enable the TTEthernet engine on SJA1110
      net: dsa: sja1105: allow RX timestamps to be taken on all ports for SJA1110
      net: dsa: generalize overhead for taggers that use both headers and trailers
      net: dsa: tag_sja1105: stop resetting network and transport headers
      net: dsa: tag_8021q: remove shim declarations
      net: dsa: tag_8021q: refactor RX VLAN parsing into a dedicated function
      net: dsa: sja1105: make SJA1105_SKB_CB fit a full timestamp
      net: dsa: add support for the SJA1110 native tagging protocol
      net: dsa: sja1105: add the RX timestamping procedure for SJA1110
      net: dsa: sja1105: implement TX timestamping for SJA1110
      net: pcs: xpcs: rename mdio_xpcs_args to dw_xpcs
      net: stmmac: reverse Christmas tree notation in stmmac_xpcs_setup
      net: stmmac: reduce indentation when calling stmmac_xpcs_setup
      net: pcs: xpcs: move register bit descriptions to a header file
      net: pcs: xpcs: add support for sgmii with no inband AN
      net: pcs: xpcs: also ignore phy id if it's all ones
      net: pcs: xpcs: add support for NXP SJA1105
      net: pcs: xpcs: add support for NXP SJA1110
      net: pcs: xpcs: export xpcs_do_config and xpcs_link_up
      net: dsa: sja1105: migrate to xpcs for SGMII
      net: dsa: sja1105: register the PCS MDIO bus for SJA1110
      net: dsa: sja1105: SGMII and 2500base-x on the SJA1110 are 'special'
      net: dsa: sja1105: plug in support for 2500base-x
      net: phy: nxp-c45-tja11xx: demote the "no PTP support" message to debug
      net: phy: nxp-c45-tja11xx: express timestamp wraparound interval in terms of TS_SEC_MASK
      net: phy: nxp-c45-tja11xx: fix potential RX timestamp wraparound
      net: phy: nxp-c45-tja11xx: enable MDIO write access to the master/slave registers
      net: dsa: sja1105: constify the sja1105_regs structures
      net: flow_dissector: fix RPS on DSA masters
      net: dsa: sja1105: properly power down the microcontroller clock for SJA1110
      net: dsa: sja1105: allow the TTEthernet configuration in the static config for SJA1110
      net: dsa: sja1105: completely error out in sja1105_static_config_reload if something fails
      net: dsa: assert uniqueness of dsa,member properties
      net: dsa: export the dsa_port_is_{user,cpu,dsa} helpers
      net: dsa: execute dsa_switch_mdb_add only for routing port in cross-chip topologies
      net: dsa: calculate the largest_mtu across all ports in the tree
      net: dsa: targeted MTU notifiers should only match on one port
      net: dsa: remove cross-chip support from the MRP notifiers
      Documentation: net: dsa: add details about SJA1110
      net: dsa: sja1105: document the SJA1110 in the Kconfig
      net: dsa: sja1105: fix NULL pointer dereference in sja1105_reload_cbs()
      net: bridge: include the is_local bit in br_fdb_replay
      net: ocelot: delete call to br_fdb_replay
      net: switchdev: add a context void pointer to struct switchdev_notifier_info
      net: bridge: ignore switchdev events for LAG ports which didn't request replay
      net: bridge: constify variables in the replay helpers
      net: bridge: allow the switchdev replay functions to be called for deletion
      net: dsa: refactor the prechangeupper sanity checks into a dedicated function
      net: dsa: replay a deletion of switchdev objects for ports leaving a bridged LAG
      net: dsa: sja1105: fix dynamic access to L2 Address Lookup table for SJA1110
      net: bridge: use READ_ONCE() and WRITE_ONCE() compiler barriers for fdb->dst
      net: bridge: allow br_fdb_replay to be called for the bridge device
      net: dsa: delete dsa_legacy_fdb_add and dsa_legacy_fdb_del
      net: dsa: introduce dsa_is_upstream_port and dsa_switch_is_upstream_of
      net: dsa: introduce a separate cross-chip notifier type for host MDBs
      net: dsa: reference count the MDB entries at the cross-chip notifier level
      net: dsa: introduce a separate cross-chip notifier type for host FDBs
      net: dsa: reference count the FDB addresses at the cross-chip notifier level
      net: dsa: install the host MDB and FDB entries in the master's RX filter
      net: dsa: sync static FDB entries on foreign interfaces to hardware
      net: dsa: include fdb entries pointing to bridge in the host fdb list
      net: dsa: ensure during dsa_fdb_offload_notify that dev_hold and dev_put are on the same dev
      net: dsa: replay the local bridge FDB entries pointing to the bridge dev too
      net: use netdev_info in ndo_dflt_fdb_{add,del}
      net: say "local" instead of "static" addresses in ndo_dflt_fdb_{add,del}

Vladyslav Tarasiuk (1):
      net/mlx5e: Remove unreachable code in mlx5e_xmit()

Voon Weifeng (4):
      net: stmmac: split xPCS setup from mdio register
      net: pcs: add 2500BASEX support for Intel mGbE controller
      net: stmmac: enable Intel mGbE 2.5Gbps link speed
      stmmac: intel: set PCI_D3hot in suspend

Wan Jiabing (1):
      rtw88: Remove duplicate include of coex.h

Wander Lairson Costa (1):
      netpoll: don't require irqs disabled in rt kernels

Wang Hai (16):
      caif_virtio: Fix some typos in caif_virtio.c
      net: bonding: bond_alb: Fix some typos in bond_alb.c
      net: qede: Use list_for_each_entry() to simplify code
      net: x25: Use list_for_each_entry() to simplify code in x25_link.c
      net: lapb: Use list_for_each_entry() to simplify code in lapb_iface.c
      ethernet/qlogic: Use list_for_each_entry() to simplify code in qlcnic_hw.c
      net: x25: Use list_for_each_entry() to simplify code in x25_forward.c
      net: x25: Use list_for_each_entry() to simplify code in x25_route.c
      ibmvnic: Use list_for_each_entry() to simplify code in ibmvnic.c
      atm: Use list_for_each_entry() to simplify code in resources.c
      libbpf: Simplify the return expression of bpf_object__init_maps function
      qlcnic: Use list_for_each_entry() to simplify code in qlcnic_main.c
      samples/bpf: Add missing option to xdp_fwd usage
      samples/bpf: Add missing option to xdp_sample_pkts usage
      samples/bpf: Fix Segmentation fault for xdp_redirect command
      samples/bpf: Fix the error return code of xdp_redirect's main()

Wei Mingzhi (1):
      mt7601u: add USB device ID for some versions of XiaoDu WiFi Dongle.

Wei Yongjun (5):
      net: dsa: qca8k: fix missing unlock on error in qca8k_vlan_(add|del)
      net: ethernet: ixp4xx: Fix return value check in ixp4xx_eth_probe()
      net: qrtr: ns: Fix error return code in qrtr_ns_init()
      net: ena: make symbol 'ena_alloc_map_page' static
      net: stmmac: Fix error return code in ingenic_mac_probe()

Weihang Li (1):
      net: phy: replace if-else statements with switch

Weilun Du (1):
      mac80211_hwsim: add concurrent channels scanning support over virtio

Wen Gong (1):
      wireless: add check of field VHT Extended NSS BW Capable for 160/80+80 MHz setting

Wenpeng Liang (7):
      net: phy: change format of some declarations
      net: phy: correct format of block comments
      net: phy: delete repeated words of comments
      net: phy: fix space alignment issues
      net: phy: fix formatting issues with braces
      net: phy: print the function name by __func__ instead of an fixed string
      net: phy: remove unnecessary line continuation

Willy Tarreau (1):
      ipv6: use prandom_u32() for ID generation

Wong Vee Khee (7):
      net: stmmac: enable platform specific safety features
      net: phy: probe for C45 PHYs that return PHY ID of zero in C22 space
      net: stmmac: Fix mixed enum type warning
      net: stmmac: Fix unused values warnings
      net: stmmac: Fix potential integer overflow
      stmmac: intel: move definitions to dwmac-intel header file
      stmmac: intel: fix wrong kernel-doc

Xianting Tian (2):
      virtio_net: Remove BUG() to avoid machine dead
      virtio_net: Use virtio_find_vqs_ctx() helper

Xie Yongji (1):
      virtio-net: Add validation for used length

Xin Long (17):
      xfrm: remove the fragment check for ipv6 beet mode
      sctp: add pad chunk and its make function and event table
      sctp: add probe_interval in sysctl and sock/asoc/transport
      sctp: add SCTP_PLPMTUD_PROBE_INTERVAL sockopt for sock/asoc/transport
      sctp: add the constants/variables and states and some APIs for transport
      sctp: add the probe timer in transport for PLPMTUD
      sctp: do the basic send and recv for PLPMTUD probe
      sctp: do state transition when PROBE_COUNT == MAX_PROBES on HB send path
      sctp: do state transition when a probe succeeds on HB ACK recv path
      sctp: do state transition when receiving an icmp TOOBIG packet
      sctp: enable PLPMTUD when the transport is ready
      sctp: remove the unessessary hold for idev in sctp_v6_err
      sctp: extract sctp_v6_err_handle function from sctp_v6_err
      sctp: extract sctp_v4_err_handle function from sctp_v4_err
      sctp: process sctp over udp icmp err on sctp side
      sctp: do black hole detection in search complete state
      sctp: send the next probe immediately once the last one is acked

Xuan Zhuo (2):
      virtio-net: fix for unable to handle page fault for address
      virtio-net: get build_skb() buf by data ptr

YN Chen (2):
      mt76: connac: fix WoW with disconnetion and bitmap pattern
      mt76: connac: add bss color support for sta mode

Yajun Deng (1):
      usbnet: add usbnet_event_names[] for kevent

Yang Li (9):
      neighbour: Remove redundant initialization of 'bucket'
      esp: drop unneeded assignment in esp4_gro_receive()
      netfilter: xt_CT: Remove redundant assignment to ret
      NFC: nci: Remove redundant assignment to len
      ssb: Remove redundant assignment to err
      rtlwifi: Remove redundant assignments to ul_enc_algo
      ath10k: Fix an error code in ath10k_add_interface()
      net: wireless: wext_compat.c: Remove redundant assignment to ps
      mac80211: Remove redundant assignment to ret

Yang Shen (33):
      net: arc: Demote non-compliant kernel-doc headers
      net: atheros: atl1c: Fix wrong function name in comments
      net: atheros: atl1e: Fix wrong function name in comments
      net: atheros: atl1x: Fix wrong function name in comments
      net: broadcom: bnx2x: Fix wrong function name in comments
      net: brocade: bna: Fix wrong function name in comments
      net: cadence: Demote non-compliant kernel-doc headers
      net: calxeda: Fix wrong function name in comments
      net: chelsio: cxgb3: Fix wrong function name in comments
      net: chelsio: cxgb4: Fix wrong function name in comments
      net: chelsio: cxgb4vf: Fix wrong function name in comments
      net: huawei: hinic: Fix wrong function name in comments
      net: micrel: Fix wrong function name in comments
      net: microchip: Demote non-compliant kernel-doc headers
      net: neterion: Fix wrong function name in comments
      net: neterion: vxge: Fix wrong function name in comments
      net: netronome: nfp: Fix wrong function name in comments
      net: calxeda: Fix wrong function name in comments
      net: samsung: sxgbe: Fix wrong function name in comments
      net: socionext: Demote non-compliant kernel-doc headers
      net: ti: Fix wrong struct name in comments
      net: via: Fix wrong function name in comments
      net: phy: Demote non-compliant kernel-doc headers
      net: hisilicon: hns: Fix wrong function name in comments
      brcmfmac: Demote non-compliant kernel-doc headers
      libertas_tf: Fix wrong function name in comments
      rtlwifi: Fix wrong function name in comments
      rsi: Fix missing function name in comments
      wlcore: Fix missing function name in comments
      wl1251: Fix missing function name in comments
      ath5k: Fix wrong function name in comments
      ath: Fix wrong function name in comments
      wil6210: Fix wrong function name in comments

Yang Yingliang (43):
      cxgb4: clip_tbl: use list_del_init instead of list_del/INIT_LIST_HEAD
      net: dcb: Remove unnecessary INIT_LIST_HEAD()
      sfc: farch: fix compile warning in efx_farch_dimension_resources()
      net: ftgmac100: add missing error return code in ftgmac100_probe()
      net: dsa: qca8k: check return value of read functions correctly
      net: dsa: qca8k: add missing check return value in qca8k_phylink_mac_config()
      net: neterion: fix doc warnings in s2io.c
      net: lantiq: Use devm_platform_get_and_ioremap_resource()
      net: ethernet: ixp4xx_eth: Use devm_platform_get_and_ioremap_resource()
      net: gemini: Use devm_platform_get_and_ioremap_resource()
      net: mscc: ocelot: check return value after calling platform_get_resource()
      net: bcmgenet: check return value after calling platform_get_resource()
      net: macb: Use devm_platform_get_and_ioremap_resource()
      net: enetc: Use devm_platform_get_and_ioremap_resource()
      net: ethernet: bgmac: Use devm_platform_ioremap_resource_byname
      net: mvpp2: check return value after calling platform_get_resource()
      net: micrel: check return value after calling platform_get_resource()
      net: moxa: Use devm_platform_get_and_ioremap_resource()
      net: nixge: simplify code with devm platform functions
      sh_eth: Use devm_platform_get_and_ioremap_resource()
      net: ethernet: ravb: Use devm_platform_get_and_ioremap_resource()
      net: sgi: ioc3-eth: check return value after calling platform_get_resource()
      net: stmmac: Use devm_platform_ioremap_resource_byname()
      net: ethernet: ti: am65-cpts: Use devm_platform_ioremap_resource_byname()
      net: ethernet: ti: cpsw-phy-sel: Use devm_platform_ioremap_resource_byname()
      net: ethernet: ti: cpsw: Use devm_platform_get_and_ioremap_resource()
      net: davinci_emac: Use devm_platform_get_and_ioremap_resource()
      net: w5100: Use devm_platform_get_and_ioremap_resource()
      net: axienet: Use devm_platform_get_and_ioremap_resource()
      fjes: check return value after calling platform_get_resource()
      net: mido: mdio-mux-bcm-iproc: Use devm_platform_get_and_ioremap_resource()
      mt76: mt7615: Use devm_platform_get_and_ioremap_resource()
      net: mdio: mscc-miim: Use devm_platform_get_and_ioremap_resource()
      ath10k: go to path err_unsupported when chip id is not supported
      ath10k: add missing error return code in ath10k_pci_probe()
      ath10k: remove unused more_frags variable
      ath10k: Use devm_platform_get_and_ioremap_resource()
      net: chelsio: cxgb4: use eth_zero_addr() to assign zero address
      net: ipa: Add missing of_node_put() in ipa_firmware_load()
      net: sched: fix error return code in tcf_del_walker()
      net: sparx5: check return value after calling platform_get_resource()
      net: sparx5: fix return value check in sparx5_create_targets()
      net: sparx5: fix error return code in sparx5_register_notifier_blocks()

Yannick Vignon (1):
      net: taprio offload: enforce qdisc to netdev queue mapping

Yejune Deng (5):
      net: openvswitch: Remove unnecessary skb_nfct()
      net: Remove the member netns_ok
      pktgen: add pktgen_handle_all_threads() for the same code
      net: add pf_family_names[] for protocol family
      net: add pf_family_names[] for protocol family

Yevgeny Kliteynik (9):
      net/mlx5: DR, Remove unused field of send_ring struct
      net/mlx5: mlx5_ifc support for header insert/remove
      net/mlx5: DR, Split reformat state to Encap and Decap
      net/mlx5: DR, Allow encap action for RX for supporting devices
      net/mlx5: Added new parameters to reformat context
      net/mlx5: DR, Added support for INSERT_HEADER reformat type
      net/mlx5: DR, Support EMD tag in modify header for STEv1
      net/mlx5: Compare sampler flow destination ID in fs_core
      net/mlx5: DR, Add support for flow sampler offload

Yinjun Zhang (1):
      nfp: flower-ct: make a full copy of the rule when it is a NFT flow

Yonghong Song (2):
      libbpf: Add support for new llvm bpf relocations
      bpf, docs: Add llvm_reloc.rst to explain llvm bpf relocations

Yonglong Li (1):
      selftests: mptcp: turn rp_filter off on each NIC

Yu Kuai (14):
      sch_htb: fix doc warning in htb_add_to_id_tree()
      sch_htb: fix doc warning in htb_add_to_wait_tree()
      sch_htb: fix doc warning in htb_next_rb_node()
      sch_htb: fix doc warning in htb_add_class_to_row()
      sch_htb: fix doc warning in htb_remove_class_from_row()
      sch_htb: fix doc warning in htb_activate_prios()
      sch_htb: fix doc warning in htb_deactivate_prios()
      sch_htb: fix doc warning in htb_class_mode()
      sch_htb: fix doc warning in htb_change_class_mode()
      sch_htb: fix doc warning in htb_activate()
      sch_htb: fix doc warning in htb_deactivate()
      sch_htb: fix doc warning in htb_charge_class()
      sch_htb: fix doc warning in htb_do_events()
      sch_htb: fix doc warning in htb_lookup_leaf()

Yu Liu (2):
      Bluetooth: Return whether a connection is outbound
      Bluetooth: Fix the HCI to MGMT status conversion table

Yuchung Cheng (1):
      net: tcp better handling of reordering then loss cases

YueHaibing (17):
      ibmveth: fix kobj_to_dev.cocci warnings
      tun: use DEVICE_ATTR_RO macro
      net: atm: use DEVICE_ATTR_RO macro
      net: usb: hso: use DEVICE_ATTR_RO macro
      net: cdc_ncm: use DEVICE_ATTR_RW macro
      net: xilinx_emaclite: Do not print real IOMEM pointer
      sfc: use DEVICE_ATTR_*() macro
      sfc: falcon: use DEVICE_ATTR_*() macro
      ehea: Use DEVICE_ATTR_*() macro
      ethernet: ucc_geth: Use kmemdup() rather than kmalloc+memcpy
      hamradio: bpqether: Fix -Wunused-const-variable warning
      cxgb4: Fix -Wunused-const-variable warning
      igb: Fix -Wunused-const-variable warning
      b43legacy: Remove unused inline function txring_to_priority()
      wlcore: use DEVICE_ATTR_<RW|RO> macro
      libertas: use DEVICE_ATTR_RW macro
      Bluetooth: RFCOMM: Use DEVICE_ATTR_RO macro

Yufeng Mo (13):
      net: hns3: refactor the debugfs process
      net: hns3: refactor dump mng tbl of debugfs
      net: hns3: refactor dump loopback of debugfs
      net: hns3: refactor dump reg of debugfs
      net: hns3: refactor dump reg dcb info of debugfs
      net: hns3: refactor dump serv info of debugfs
      net: hns3: remove the useless debugfs file node cmd
      net: bonding: add some required blank lines
      net: bonding: fix code indent for conditional statements
      net: bonding: remove unnecessary braces
      net: bonding: use tabs instead of space for code indent
      net: hns3: remove now redundant logic related to HNAE3_UNKNOWN_RESET
      net: hns3: add support for handling all errors through MSI-X

Yun-Hao Chung (1):
      Bluetooth: disable filter dup when scan for adv monitor

Yunsheng Lin (11):
      net: hns3: minor refactor related to desc_cb handling
      net: hns3: refactor for hns3_fill_desc() function
      net: hns3: use tx bounce buffer for small packets
      net: hns3: support dma_map_sg() for multi frags skb
      net: hns3: optimize the rx page reuse handling process
      net: hns3: use bounce buffer when rx page can not be reused
      net: hns3: fix reuse conflict of the rx page
      net: sched: add barrier to ensure correct ordering for lockless qdisc
      net: sched: avoid unnecessary seqcount operation for lockless qdisc
      net: sched: implement TCQ_F_CAN_BYPASS for lockless qdisc
      net: sched: remove qdisc->empty for lockless qdisc

Zhang Qilong (1):
      Bluetooth: btmtkuart: using pm_runtime_resume_and_get instead of pm_runtime_get_sync

Zhen Lei (9):
      net: stmmac: platform: Delete a redundant condition branch
      mISDN: Remove obsolete PIPELINE_DEBUG debugging information
      bpf: Fix spelling mistakes
      ehea: fix error return code in ehea_restart_qps()
      fjes: Use DEFINE_RES_MEM() and DEFINE_RES_IRQ() to simplify code
      b43: phy_n: Delete some useless TODO code
      ssb: Fix error return code in ssb_bus_scan()
      ssb: use DEVICE_ATTR_ADMIN_RW() helper macro
      rtlwifi: btcoex: 21a 2ant: Delete several duplicate condition branch codes

Zheng Yejian (2):
      cipso: correct comments of cipso_v4_cache_invalidate()
      netlabel: remove unused parameter in netlbl_netlink_auditinfo()

Zheng Yongjun (26):
      nfc: hci: Fix spelling mistakes
      net: sched: Fix spelling mistakes
      rds: Fix spelling mistakes
      sctp: sm_statefuns: Fix spelling mistakes
      net: vxge: Declare the function vxge_reset_all_vpaths as void
      net: dcb: Return the correct errno code
      net: Return the correct errno code
      macvlan: Fix a typo
      gtp: Fix a typo
      vrf: Fix a typo
      net: usb: Fix spelling mistakes
      net: mdio: Fix spelling mistakes
      batman-adv: Fix spelling mistakes
      ethtool: Fix a typo
      9p/trans_virtio: Fix spelling mistakes
      Bluetooth: Fix spelling mistakes
      rxrpc: Fix a typo
      decnet: Fix spelling mistakes
      rtnetlink: Fix spelling mistakes
      libceph: Fix spelling mistakes
      tipc: Return the correct errno code
      netlabel: Fix spelling mistakes
      ipv4: Fix spelling mistakes
      net/ncsi: Fix spelling mistakes
      l2tp: Fix spelling mistakes
      mac80211: fix some spelling mistakes

Zheyu Ma (2):
      atm: nicstar: use 'dma_free_coherent' instead of 'kfree'
      atm: nicstar: register the interrupt handler in the right place

Zhihao Cheng (1):
      tools/bpftool: Fix error return code in do_batch()

Zong-Zhe Yang (1):
      rtw88: dump FW crash via devcoredump

Zou Wei (6):
      atm: iphase: fix possible use-after-free in ia_module_exit()
      mISDN: fix possible use-after-free in HFC_cleanup()
      atm: nicstar: Fix possible use-after-free in nicstar_cleanup()
      net: dsa: hellcreek: Use is_zero_ether_addr() instead of memcmp()
      cw1200: add missing MODULE_DEVICE_TABLE
      net: iosm: add missing MODULE_DEVICE_TABLE

caihuoqing (1):
      net/mlx5: remove "default n" from Kconfig

dingsenjie (1):
      ethernet: marvell/octeontx2: Simplify the return expression of npc_is_same

gushengxian (12):
      atm: [br2864] fix spelling mistakes
      net: appletalk: fix some mistakes in grammar
      net/x25: fix a mistake in grammar
      vsock/vmci: remove the repeated word "be"
      af_unix: remove the repeated word "and"
      node.c: fix the use of indefinite article
      tipc: socket.c: fix the use of copular verb
      tipc:subscr.c: fix a spelling mistake
      xfrm: policy: fix a spelling mistake
      net: devres: Correct a grammatical error
      bridge: cfm: remove redundant return
      flow_offload: action should not be NULL when it is referenced

mark-yw.chen (2):
      Bluetooth: btusb: Fixed too many in-token issue for Mediatek Chip.
      Bluetooth: btusb: Add support for Lite-On Mediatek Chip

wengjianfeng (8):
      NFC: st21nfca: remove unnecessary variable and labels
      nfc: st-nci: remove unnecessary assignment and label
      nfc: st95hf: remove unnecessary assignment and label
      nfc: st-nci: remove unnecessary labels
      nfc: fdp: remove unnecessary labels
      NFC: nxp-nci: remove unnecessary labels
      NFC: nxp-nci: remove unnecessary label
      rtw88: coex: remove unnecessary variable and label

ybaruch (1):
      iwlwifi: add 9560 killer device

zhang kai (2):
      sit: replace 68 with micro IPV4_MIN_MTU
      ipv6: delete useless dst check in ip6_dst_lookup_tail

zuoqilin (4):
      atm: Fix typo
      net: Remove unnecessary variables
      can: proc: remove unnecessary variables
      rndis_wlan: simplify is_associated()

Íñigo Huguet (9):
      net:cxgb3: replace tasklets with works
      net:cxgb3: fix code style issues
      net:cxgb3: fix incorrect work cancellation
      brcmsmac: improve readability on addresses copy
      rtl8xxxu: avoid parsing short RX packet
      sfc: avoid double pci_remove of VFs
      sfc: error code if SRIOV cannot be disabled
      sfc: explain that "attached" VFs only refer to Xen
      sfc: avoid duplicated code in ef10_sriov

周琰杰 (Zhou Yanjie) (3):
      dt-bindings: dwmac: Add bindings for new Ingenic SoCs.
      net: stmmac: Add Ingenic SoCs MAC support.
      dt-bindings: dwmac: Remove unexpected item.

 .../ABI/testing/sysfs-devices-platform-soc-ipa     |   78 +
 Documentation/RCU/checklist.rst                    |   55 +-
 Documentation/bpf/index.rst                        |   14 +
 Documentation/bpf/libbpf/libbpf.rst                |   14 +
 Documentation/bpf/libbpf/libbpf_api.rst            |   27 +
 Documentation/bpf/libbpf/libbpf_build.rst          |   37 +
 .../bpf/libbpf/libbpf_naming_convention.rst        |   30 +-
 Documentation/bpf/llvm_reloc.rst                   |  240 +
 .../devicetree/bindings/net/brcm,iproc-mdio.txt    |   23 -
 .../devicetree/bindings/net/brcm,iproc-mdio.yaml   |   38 +
 .../devicetree/bindings/net/can/rcar_can.txt       |   80 -
 .../devicetree/bindings/net/can/rcar_canfd.txt     |  107 -
 .../bindings/net/can/renesas,rcar-can.yaml         |  139 +
 .../bindings/net/can/renesas,rcar-canfd.yaml       |  122 +
 .../devicetree/bindings/net/dsa/mt7530.txt         |    6 +
 .../devicetree/bindings/net/dsa/nxp,sja1105.yaml   |  132 +
 .../devicetree/bindings/net/dsa/qca8k.txt          |   40 +
 .../devicetree/bindings/net/dsa/sja1105.txt        |  156 -
 .../bindings/net/ethernet-controller.yaml          |    2 +
 .../devicetree/bindings/net/ingenic,mac.yaml       |   76 +
 .../bindings/net/microchip,sparx5-switch.yaml      |  226 +
 .../bindings/net/nfc/samsung,s3fwrn5.yaml          |    5 +
 .../devicetree/bindings/net/qcom,ipa.yaml          |    1 +
 .../devicetree/bindings/net/qualcomm-bluetooth.txt |   69 -
 .../bindings/net/qualcomm-bluetooth.yaml           |  183 +
 .../devicetree/bindings/net/realtek,rtl82xx.yaml   |   45 +
 .../devicetree/bindings/net/rockchip-dwmac.yaml    |   30 +-
 .../devicetree/bindings/net/snps,dwmac.yaml        |   21 +
 Documentation/firmware-guide/acpi/dsd/phy.rst      |  199 +
 Documentation/firmware-guide/acpi/index.rst        |    1 +
 Documentation/networking/af_xdp.rst                |   32 +-
 .../device_drivers/cellular/qualcomm/rmnet.rst     |  126 +-
 .../device_drivers/ethernet/amazon/ena.rst         |  164 +-
 .../device_drivers/ethernet/google/gve.rst         |   53 +-
 .../device_drivers/ethernet/mellanox/mlx5.rst      |   88 +
 Documentation/networking/device_drivers/index.rst  |    1 +
 .../networking/device_drivers/wwan/index.rst       |   18 +
 .../networking/device_drivers/wwan/iosm.rst        |   96 +
 Documentation/networking/devlink/devlink-port.rst  |   35 +
 Documentation/networking/devlink/devlink-trap.rst  |    1 +
 Documentation/networking/devlink/index.rst         |    1 +
 Documentation/networking/devlink/netdevsim.rst     |   26 +
 Documentation/networking/devlink/prestera.rst      |  141 +
 Documentation/networking/dsa/configuration.rst     |   68 +
 Documentation/networking/dsa/dsa.rst               |   21 +-
 Documentation/networking/dsa/sja1105.rst           |   61 +-
 Documentation/networking/ethtool-netlink.rst       |    8 +-
 Documentation/networking/ip-sysctl.rst             |   95 +
 Documentation/networking/mptcp-sysctl.rst          |   29 +-
 Documentation/networking/nf_conntrack-sysctl.rst   |   24 +
 Documentation/networking/phy.rst                   |    6 +
 MAINTAINERS                                        |   36 +
 arch/alpha/include/uapi/asm/socket.h               |    2 +
 arch/arm64/boot/dts/microchip/sparx5.dtsi          |   94 +-
 .../boot/dts/microchip/sparx5_pcb134_board.dtsi    |  481 +-
 .../boot/dts/microchip/sparx5_pcb135_board.dtsi    |  621 +-
 arch/arm64/boot/dts/rockchip/rk3308.dtsi           |   22 +
 arch/arm64/net/bpf_jit_comp.c                      |   19 +-
 arch/mips/boot/dts/loongson/loongson64-2k1000.dtsi |   46 +
 arch/mips/boot/dts/loongson/ls7a-pch.dtsi          |    6 +-
 arch/mips/include/uapi/asm/socket.h                |    2 +
 arch/parisc/include/uapi/asm/socket.h              |    2 +
 arch/s390/include/asm/qdio.h                       |    4 +-
 arch/sparc/include/uapi/asm/socket.h               |    2 +
 arch/x86/net/bpf_jit_comp.c                        |   46 +-
 drivers/acpi/utils.c                               |   14 +
 drivers/atm/iphase.c                               |   13 +-
 drivers/atm/iphase.h                               |    1 -
 drivers/atm/nicstar.c                              |   26 +-
 drivers/atm/zeprom.h                               |    2 +-
 drivers/base/core.c                                |    7 +
 drivers/bluetooth/btbcm.c                          |    1 +
 drivers/bluetooth/btmrvl_sdio.c                    |    4 +-
 drivers/bluetooth/btmtkuart.c                      |    6 +-
 drivers/bluetooth/btqca.c                          |  113 +-
 drivers/bluetooth/btqca.h                          |   14 +-
 drivers/bluetooth/btrtl.c                          |   35 +-
 drivers/bluetooth/btrtl.h                          |    7 +
 drivers/bluetooth/btusb.c                          |   45 +-
 drivers/bluetooth/hci_ag6xx.c                      |    1 -
 drivers/bluetooth/hci_h5.c                         |    5 +-
 drivers/bluetooth/hci_qca.c                        |  118 +-
 drivers/bluetooth/virtio_bt.c                      |    3 +
 drivers/infiniband/hw/i40iw/i40iw_main.c           |    5 +-
 drivers/infiniband/hw/mlx5/fs.c                    |    9 +-
 drivers/infiniband/hw/mlx5/odp.c                   |    8 +-
 drivers/isdn/hardware/mISDN/hfcpci.c               |    2 +-
 drivers/isdn/mISDN/dsp_pipeline.c                  |   46 +-
 drivers/media/rc/bpf-lirc.c                        |    3 +-
 drivers/net/Kconfig                                |   23 +-
 drivers/net/appletalk/cops.c                       |   30 +-
 drivers/net/appletalk/ltpc.c                       |   16 +-
 drivers/net/bareudp.c                              |    1 +
 drivers/net/bonding/bond_alb.c                     |   13 +-
 drivers/net/bonding/bond_debugfs.c                 |    3 +-
 drivers/net/bonding/bond_main.c                    |   39 +-
 drivers/net/bonding/bond_netlink.c                 |    2 +-
 drivers/net/bonding/bond_options.c                 |    5 +-
 drivers/net/bonding/bond_procfs.c                  |    1 +
 drivers/net/bonding/bond_sysfs.c                   |    7 +
 drivers/net/caif/caif_virtio.c                     |    6 +-
 drivers/net/can/at91_can.c                         |    2 +-
 drivers/net/can/c_can/Makefile                     |    5 +
 drivers/net/can/c_can/c_can.h                      |    3 +-
 drivers/net/can/c_can/c_can_ethtool.c              |   43 +
 drivers/net/can/c_can/{c_can.c => c_can_main.c}    |    2 +-
 drivers/net/can/m_can/m_can.c                      |  244 +-
 drivers/net/can/peak_canfd/peak_canfd.c            |    4 +-
 drivers/net/can/softing/softing_main.c             |    2 -
 drivers/net/can/spi/hi311x.c                       |    2 +-
 drivers/net/can/spi/mcp251x.c                      |    2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |    2 +-
 drivers/net/can/usb/Kconfig                        |    2 +
 drivers/net/can/usb/ems_usb.c                      |    3 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   14 +-
 drivers/net/dsa/b53/b53_common.c                   |   30 +-
 drivers/net/dsa/b53/b53_srab.c                     |    3 +-
 drivers/net/dsa/hirschmann/hellcreek.c             |    3 +-
 drivers/net/dsa/microchip/ksz8795.c                |  214 +-
 drivers/net/dsa/microchip/ksz8795_reg.h            |   67 +-
 drivers/net/dsa/mt7530.c                           |  264 +-
 drivers/net/dsa/mt7530.h                           |   20 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |    6 +-
 drivers/net/dsa/ocelot/felix.c                     |    2 +
 drivers/net/dsa/ocelot/seville_vsc9953.c           |    5 +
 drivers/net/dsa/qca8k.c                            |  803 +-
 drivers/net/dsa/qca8k.h                            |   58 +-
 drivers/net/dsa/sja1105/Kconfig                    |    9 +-
 drivers/net/dsa/sja1105/Makefile                   |    1 +
 drivers/net/dsa/sja1105/sja1105.h                  |  128 +-
 drivers/net/dsa/sja1105/sja1105_clocking.c         |  170 +-
 drivers/net/dsa/sja1105/sja1105_dynamic_config.c   |  360 +-
 drivers/net/dsa/sja1105/sja1105_dynamic_config.h   |    1 +
 drivers/net/dsa/sja1105/sja1105_ethtool.c          | 1089 +--
 drivers/net/dsa/sja1105/sja1105_flower.c           |   13 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |  769 +-
 drivers/net/dsa/sja1105/sja1105_mdio.c             |  543 ++
 drivers/net/dsa/sja1105/sja1105_ptp.c              |   97 +-
 drivers/net/dsa/sja1105/sja1105_ptp.h              |   13 +
 drivers/net/dsa/sja1105/sja1105_sgmii.h            |   53 -
 drivers/net/dsa/sja1105/sja1105_spi.c              |  518 +-
 drivers/net/dsa/sja1105/sja1105_static_config.c    |  500 +-
 drivers/net/dsa/sja1105/sja1105_static_config.h    |  109 +-
 drivers/net/dsa/sja1105/sja1105_tas.c              |   14 +-
 drivers/net/dsa/sja1105/sja1105_tas.h              |    2 +-
 drivers/net/dsa/sja1105/sja1105_vl.c               |    2 +-
 drivers/net/dsa/xrs700x/xrs700x.c                  |   78 +
 drivers/net/ethernet/3com/3c59x.c                  |    2 +-
 drivers/net/ethernet/8390/axnet_cs.c               |   14 +-
 drivers/net/ethernet/8390/pcnet_cs.c               |    2 +-
 drivers/net/ethernet/8390/smc-ultra.c              |    6 +-
 drivers/net/ethernet/8390/stnic.c                  |    2 +-
 drivers/net/ethernet/aeroflex/greth.c              |    3 +-
 drivers/net/ethernet/alteon/acenic.c               |   26 +-
 drivers/net/ethernet/amazon/ena/ena_admin_defs.h   |    2 -
 drivers/net/ethernet/amazon/ena/ena_com.c          |    3 +-
 drivers/net/ethernet/amazon/ena/ena_eth_com.c      |   30 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |   18 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  220 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.h       |   23 +-
 drivers/net/ethernet/amd/amd8111e.c                |    4 +-
 drivers/net/ethernet/amd/amd8111e.h                |    6 +-
 drivers/net/ethernet/amd/atarilance.c              |    2 +-
 drivers/net/ethernet/amd/declance.c                |    2 +-
 drivers/net/ethernet/amd/lance.c                   |    4 +-
 drivers/net/ethernet/amd/ni65.c                    |   12 +-
 drivers/net/ethernet/amd/nmclan_cs.c               |   12 +-
 drivers/net/ethernet/amd/sun3lance.c               |   12 +-
 drivers/net/ethernet/apple/bmac.c                  |   30 +-
 drivers/net/ethernet/apple/mace.c                  |    8 +-
 drivers/net/ethernet/aquantia/atlantic/aq_macsec.h |    4 +-
 drivers/net/ethernet/arc/emac_rockchip.c           |    2 +-
 drivers/net/ethernet/atheros/alx/alx.h             |    2 +
 drivers/net/ethernet/atheros/alx/ethtool.c         |   21 +-
 drivers/net/ethernet/atheros/alx/main.c            |   84 +-
 drivers/net/ethernet/atheros/atl1c/atl1c.h         |   28 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.c      |   35 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.h      |   42 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |  587 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |    4 +-
 drivers/net/ethernet/atheros/atlx/atl1.c           |    2 +-
 drivers/net/ethernet/broadcom/Kconfig              |    1 +
 drivers/net/ethernet/broadcom/b44.c                |   20 +-
 drivers/net/ethernet/broadcom/bcm4908_enet.c       |    6 +-
 drivers/net/ethernet/broadcom/bgmac-platform.c     |   21 +-
 drivers/net/ethernet/broadcom/bnx2.c               |    6 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c     |    4 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.h  |    1 -
 drivers/net/ethernet/broadcom/bnxt/Makefile        |    2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  134 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   10 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |   34 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h      |  667 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |  473 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h      |   81 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c    |    4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c      |    2 -
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |    1 +
 drivers/net/ethernet/broadcom/genet/bcmmii.c       |    4 +
 drivers/net/ethernet/brocade/bna/bfa_cee.c         |    2 +-
 drivers/net/ethernet/cadence/macb_main.c           |    3 +-
 drivers/net/ethernet/cadence/macb_pci.c            |    2 +-
 drivers/net/ethernet/cadence/macb_ptp.c            |    2 +-
 drivers/net/ethernet/calxeda/xgmac.c               |    8 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |    2 -
 drivers/net/ethernet/cavium/thunder/thunder_bgx.c  |    3 -
 drivers/net/ethernet/chelsio/cxgb3/adapter.h       |    2 +-
 drivers/net/ethernet/chelsio/cxgb3/common.h        |    2 +
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |   19 +-
 drivers/net/ethernet/chelsio/cxgb3/sge.c           |   44 +-
 drivers/net/ethernet/chelsio/cxgb4/clip_tbl.c      |    6 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |    2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c     |    2 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |    7 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c         |    2 +-
 .../chelsio/inline_crypto/chtls/chtls_cm.c         |    2 +-
 drivers/net/ethernet/cortina/gemini.c              |   34 +-
 drivers/net/ethernet/dec/tulip/de2104x.c           |    4 +-
 drivers/net/ethernet/dec/tulip/de4x5.c             |    6 +-
 drivers/net/ethernet/dec/tulip/dmfe.c              |   18 +-
 drivers/net/ethernet/dec/tulip/pnic2.c             |    4 +-
 drivers/net/ethernet/dec/tulip/tulip.h             |    1 -
 drivers/net/ethernet/dec/tulip/uli526x.c           |   10 +-
 drivers/net/ethernet/dec/tulip/winbond-840.c       |    4 +-
 drivers/net/ethernet/dlink/sundance.c              |   12 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c        |    6 +-
 drivers/net/ethernet/emulex/benet/be_main.c        |    2 +
 drivers/net/ethernet/ezchip/nps_enet.c             |    7 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |    6 +-
 drivers/net/ethernet/fealnx.c                      |    2 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |    8 +-
 .../ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c   |    6 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   10 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c   |  103 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h   |    1 +
 .../net/ethernet/freescale/dpaa2/dpaa2-switch.c    |    2 +-
 drivers/net/ethernet/freescale/enetc/enetc_ierb.c  |    4 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |    9 +-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |   31 +-
 drivers/net/ethernet/freescale/fec.h               |    5 +
 drivers/net/ethernet/freescale/fec_main.c          |   43 +-
 drivers/net/ethernet/freescale/gianfar.c           |   76 +-
 drivers/net/ethernet/freescale/gianfar.h           |   74 +-
 drivers/net/ethernet/freescale/ucc_geth.c          |    3 +-
 drivers/net/ethernet/freescale/xgmac_mdio.c        |   30 +-
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c          |    6 +-
 drivers/net/ethernet/google/Kconfig                |    2 +-
 drivers/net/ethernet/google/gve/Makefile           |    2 +-
 drivers/net/ethernet/google/gve/gve.h              |  332 +-
 drivers/net/ethernet/google/gve/gve_adminq.c       |  334 +-
 drivers/net/ethernet/google/gve/gve_adminq.h       |  112 +-
 drivers/net/ethernet/google/gve/gve_desc_dqo.h     |  256 +
 drivers/net/ethernet/google/gve/gve_dqo.h          |   81 +
 drivers/net/ethernet/google/gve/gve_ethtool.c      |   21 +-
 drivers/net/ethernet/google/gve/gve_main.c         |  295 +-
 drivers/net/ethernet/google/gve/gve_rx.c           |   54 +-
 drivers/net/ethernet/google/gve/gve_rx_dqo.c       |  763 ++
 drivers/net/ethernet/google/gve/gve_tx.c           |   25 +-
 drivers/net/ethernet/google/gve/gve_tx_dqo.c       | 1030 +++
 drivers/net/ethernet/google/gve/gve_utils.c        |   81 +
 drivers/net/ethernet/google/gve/gve_utils.h        |   28 +
 drivers/net/ethernet/hisilicon/Kconfig             |    2 +
 drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c  |    2 -
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c  |    9 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c |   16 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c |   76 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c  |    8 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c  |    2 +-
 .../net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c    |    4 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |    2 +-
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |   10 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   90 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c | 1471 +++-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h |   64 +
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 1225 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   99 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   86 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/Makefile    |    2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |   13 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   41 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 2604 +++---
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h |   47 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |  414 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.h |   89 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  621 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   60 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |  115 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c |  542 ++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h |  134 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  215 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |   19 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |    2 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |    1 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   76 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |    2 +
 drivers/net/ethernet/huawei/hinic/hinic_ethtool.c  |    1 -
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c  |    4 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c   |   18 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c   |    6 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.c    |    4 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_io.c    |    4 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c  |    4 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_qp.c    |    2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_wq.c    |    1 +
 drivers/net/ethernet/huawei/hinic/hinic_main.c     |    5 +-
 drivers/net/ethernet/huawei/hinic/hinic_port.c     |   10 +-
 drivers/net/ethernet/huawei/hinic/hinic_rx.c       |    1 +
 drivers/net/ethernet/huawei/hinic/hinic_tx.c       |    4 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |   27 +-
 drivers/net/ethernet/ibm/emac/emac.h               |    2 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |   54 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  280 +-
 drivers/net/ethernet/ibm/ibmvnic.h                 |    6 +-
 drivers/net/ethernet/intel/Kconfig                 |    3 +
 drivers/net/ethernet/intel/e100.c                  |   12 +-
 drivers/net/ethernet/intel/e1000/e1000_ethtool.c   |    2 +-
 drivers/net/ethernet/intel/e1000/e1000_hw.c        |    4 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |    2 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |    2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |   26 +-
 drivers/net/ethernet/intel/e1000e/phy.c            |    2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c       |   10 +-
 drivers/net/ethernet/intel/i40e/i40e.h             |    2 +
 drivers/net/ethernet/intel/i40e/i40e_client.c      |  132 +-
 drivers/net/ethernet/intel/i40e/i40e_common.c      |  124 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |    3 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   18 +-
 drivers/net/ethernet/intel/i40e/i40e_ptp.c         |    8 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |    2 -
 drivers/net/ethernet/intel/i40e/i40e_type.h        |    1 -
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |    3 -
 drivers/net/ethernet/intel/iavf/iavf_common.c      |  124 +-
 drivers/net/ethernet/intel/iavf/iavf_type.h        |    1 -
 drivers/net/ethernet/intel/ice/Makefile            |    2 +
 drivers/net/ethernet/intel/ice/ice.h               |   55 +-
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h    |   80 +-
 drivers/net/ethernet/intel/ice/ice_arfs.h          |   12 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |  134 +-
 drivers/net/ethernet/intel/ice/ice_base.h          |    2 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |  465 +-
 drivers/net/ethernet/intel/ice/ice_common.h        |   19 +
 drivers/net/ethernet/intel/ice/ice_controlq.c      |   62 +
 drivers/net/ethernet/intel/ice/ice_controlq.h      |    2 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.c       |   21 +
 drivers/net/ethernet/intel/ice/ice_dcb_lib.h       |   15 +-
 drivers/net/ethernet/intel/ice/ice_dcb_nl.h        |    9 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c       |    9 +
 drivers/net/ethernet/intel/ice/ice_ethtool.c       |   33 +-
 drivers/net/ethernet/intel/ice/ice_fw_update.c     |   10 +
 drivers/net/ethernet/intel/ice/ice_hw_autogen.h    |   90 +-
 drivers/net/ethernet/intel/ice/ice_idc.c           |  334 +
 drivers/net/ethernet/intel/ice/ice_idc_int.h       |   14 +
 drivers/net/ethernet/intel/ice/ice_lag.c           |    2 +
 drivers/net/ethernet/intel/ice/ice_lan_tx_rx.h     |  151 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |  120 +-
 drivers/net/ethernet/intel/ice/ice_lib.h           |   10 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  315 +-
 drivers/net/ethernet/intel/ice/ice_ptp.c           | 1558 ++++
 drivers/net/ethernet/intel/ice/ice_ptp.h           |  204 +
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c        |  651 ++
 drivers/net/ethernet/intel/ice/ice_ptp_hw.h        |   79 +
 drivers/net/ethernet/intel/ice/ice_sbq_cmd.h       |   92 +
 drivers/net/ethernet/intel/ice/ice_sched.c         |   93 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        |   28 +
 drivers/net/ethernet/intel/ice/ice_switch.h        |    5 +-
 drivers/net/ethernet/intel/ice/ice_trace.h         |  232 +
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   54 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h          |    5 +
 drivers/net/ethernet/intel/ice/ice_txrx_lib.c      |   26 +-
 drivers/net/ethernet/intel/ice/ice_txrx_lib.h      |    2 +-
 drivers/net/ethernet/intel/ice/ice_type.h          |   69 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |  227 +-
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.h   |   31 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |    7 +-
 drivers/net/ethernet/intel/ice/ice_xsk.h           |    4 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c       |    2 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |    2 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   13 +-
 drivers/net/ethernet/intel/igb/igb_ptp.c           |    4 +-
 drivers/net/ethernet/intel/igbvf/netdev.c          |    6 +-
 drivers/net/ethernet/intel/igbvf/vf.h              |   42 +-
 drivers/net/ethernet/intel/igc/igc.h               |   34 +-
 drivers/net/ethernet/intel/igc/igc_base.h          |    2 +
 drivers/net/ethernet/intel/igc/igc_defines.h       |    9 +-
 drivers/net/ethernet/intel/igc/igc_dump.c          |    2 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c       |   41 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |  731 +-
 drivers/net/ethernet/intel/igc/igc_regs.h          |    2 +-
 drivers/net/ethernet/intel/igc/igc_xdp.c           |  109 +-
 drivers/net/ethernet/intel/igc/igc_xdp.h           |    8 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c     |    9 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c    |   16 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c     |    8 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |    2 -
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |    3 -
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |    4 +-
 drivers/net/ethernet/lantiq_xrx200.c               |    9 +-
 drivers/net/ethernet/marvell/mvmdio.c              |   20 +-
 drivers/net/ethernet/marvell/mvneta.c              |   32 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h         |    3 -
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  123 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_prs.c     |    3 -
 drivers/net/ethernet/marvell/octeontx2/af/common.h |    5 +
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   54 +-
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |  107 +-
 .../ethernet/marvell/octeontx2/af/npc_profile.h    | 8675 ++++++++++++--------
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   56 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   76 +-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  168 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  923 ++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  617 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |   33 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |   12 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |   85 +-
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.c |  323 +
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k.h |   11 +
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   39 +-
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |    6 +
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |  192 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  143 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_tc.c   |  303 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |   58 +-
 drivers/net/ethernet/marvell/prestera/Makefile     |    3 +-
 drivers/net/ethernet/marvell/prestera/prestera.h   |   39 +-
 .../net/ethernet/marvell/prestera/prestera_acl.c   |  376 +
 .../net/ethernet/marvell/prestera/prestera_acl.h   |  124 +
 .../ethernet/marvell/prestera/prestera_devlink.c   |  530 +-
 .../ethernet/marvell/prestera/prestera_devlink.h   |    3 +
 .../net/ethernet/marvell/prestera/prestera_dsa.c   |    3 +
 .../net/ethernet/marvell/prestera/prestera_dsa.h   |    1 +
 .../net/ethernet/marvell/prestera/prestera_flow.c  |  194 +
 .../net/ethernet/marvell/prestera/prestera_flow.h  |   14 +
 .../ethernet/marvell/prestera/prestera_flower.c    |  359 +
 .../ethernet/marvell/prestera/prestera_flower.h    |   18 +
 .../net/ethernet/marvell/prestera/prestera_hw.c    |  661 +-
 .../net/ethernet/marvell/prestera/prestera_hw.h    |   51 +-
 .../net/ethernet/marvell/prestera/prestera_main.c  |  301 +-
 .../net/ethernet/marvell/prestera/prestera_pci.c   |  104 +-
 .../net/ethernet/marvell/prestera/prestera_rxtx.c  |    7 +-
 .../net/ethernet/marvell/prestera/prestera_span.c  |  239 +
 .../net/ethernet/marvell/prestera/prestera_span.h  |   20 +
 .../ethernet/marvell/prestera/prestera_switchdev.c |  186 +-
 .../ethernet/marvell/prestera/prestera_switchdev.h |    7 +-
 drivers/net/ethernet/marvell/pxa168_eth.c          |    2 +-
 drivers/net/ethernet/marvell/skge.h                |    2 +-
 drivers/net/ethernet/marvell/sky2.c                |   32 +-
 drivers/net/ethernet/marvell/sky2.h                |    8 +-
 drivers/net/ethernet/mellanox/Kconfig              |    1 +
 drivers/net/ethernet/mellanox/Makefile             |    1 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |   10 +-
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |   19 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |    3 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   10 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |    8 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |    8 +-
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.c    |  427 +
 .../ethernet/mellanox/mlx5/core/en/rep/bridge.h    |   21 +
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |   58 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |   23 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |   38 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |   17 +-
 .../mellanox/mlx5/core/en_accel/en_accel.h         |    4 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |    2 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       |   65 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       |   37 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.c    |   11 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |   24 +
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |    6 +-
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h        |    2 +-
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.c |    6 +-
 .../net/ethernet/mellanox/mlx5/core/en_accel/tls.h |   11 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |    8 +-
 .../mellanox/mlx5/core/en_accel/tls_stats.c        |    5 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   26 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   18 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |    6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   17 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   88 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |    8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   17 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |  179 +-
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.c   | 1299 +++
 .../net/ethernet/mellanox/mlx5/core/esw/bridge.h   |   53 +
 .../ethernet/mellanox/mlx5/core/esw/bridge_priv.h  |   53 +
 .../mlx5/core/esw/diag/bridge_tracepoint.h         |  113 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |    7 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   19 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |   58 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h   |    6 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   70 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |    1 +
 .../net/ethernet/mellanox/mlx5/core/fs_ft_pool.c   |   85 +
 .../net/ethernet/mellanox/mlx5/core/fs_ft_pool.h   |   21 +
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       |    6 +
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |    2 +
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |  295 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.h      |    3 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h   |    3 +-
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |   94 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/sf.h   |   45 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |    3 +
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   25 +-
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h |   35 +
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c  |  608 +-
 .../net/ethernet/mellanox/mlx5/core/sf/hw_table.c  |   24 +-
 drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h    |   37 +-
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |    1 +
 .../mellanox/mlx5/core/steering/dr_action.c        |  242 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |   40 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.h  |    1 +
 .../mellanox/mlx5/core/steering/dr_ste_v0.c        |    5 +-
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        |  120 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |   37 +-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |   43 +-
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |    6 +
 drivers/net/ethernet/mellanox/mlxbf_gige/Kconfig   |   13 +
 drivers/net/ethernet/mellanox/mlxbf_gige/Makefile  |   11 +
 .../net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h  |  190 +
 .../mellanox/mlxbf_gige/mlxbf_gige_ethtool.c       |  137 +
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_gpio.c |  212 +
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_intr.c |  142 +
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c |  452 +
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c |  187 +
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h |   78 +
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c   |  320 +
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_tx.c   |  284 +
 drivers/net/ethernet/mellanox/mlxsw/Kconfig        |   22 -
 drivers/net/ethernet/mellanox/mlxsw/Makefile       |    4 -
 drivers/net/ethernet/mellanox/mlxsw/core.c         |   10 +-
 drivers/net/ethernet/mellanox/mlxsw/core_env.c     |   99 +-
 drivers/net/ethernet/mellanox/mlxsw/core_env.h     |    7 +
 drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c   |    6 +-
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c |   97 +-
 drivers/net/ethernet/mellanox/mlxsw/ib.h           |    9 -
 drivers/net/ethernet/mellanox/mlxsw/minimal.c      |   17 +
 drivers/net/ethernet/mellanox/mlxsw/pci.c          |    5 -
 drivers/net/ethernet/mellanox/mlxsw/pci.h          |    3 -
 drivers/net/ethernet/mellanox/mlxsw/reg.h          |  124 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |    5 +
 .../net/ethernet/mellanox/mlxsw/spectrum_buffers.c |    6 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_ethtool.c |   14 +
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c |    3 +
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  378 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.h  |    1 -
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c   |   10 +-
 drivers/net/ethernet/mellanox/mlxsw/switchib.c     |  595 --
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c     | 1691 ----
 drivers/net/ethernet/micrel/ks8842.c               |    4 +
 drivers/net/ethernet/micrel/ks8851_common.c        |   15 +-
 drivers/net/ethernet/micrel/ksz884x.c              |  111 +-
 drivers/net/ethernet/microchip/Kconfig             |    2 +
 drivers/net/ethernet/microchip/Makefile            |    2 +
 drivers/net/ethernet/microchip/sparx5/Kconfig      |    9 +
 drivers/net/ethernet/microchip/sparx5/Makefile     |   10 +
 .../ethernet/microchip/sparx5/sparx5_calendar.c    |  596 ++
 .../net/ethernet/microchip/sparx5/sparx5_ethtool.c | 1227 +++
 .../ethernet/microchip/sparx5/sparx5_mactable.c    |  500 ++
 .../net/ethernet/microchip/sparx5/sparx5_main.c    |  853 ++
 .../net/ethernet/microchip/sparx5/sparx5_main.h    |  375 +
 .../ethernet/microchip/sparx5/sparx5_main_regs.h   | 4642 +++++++++++
 .../net/ethernet/microchip/sparx5/sparx5_netdev.c  |  264 +
 .../net/ethernet/microchip/sparx5/sparx5_packet.c  |  320 +
 .../net/ethernet/microchip/sparx5/sparx5_phylink.c |  210 +
 .../net/ethernet/microchip/sparx5/sparx5_port.c    | 1146 +++
 .../net/ethernet/microchip/sparx5/sparx5_port.h    |   93 +
 .../ethernet/microchip/sparx5/sparx5_switchdev.c   |  510 ++
 .../net/ethernet/microchip/sparx5/sparx5_vlan.c    |  224 +
 drivers/net/ethernet/microsoft/mana/mana_en.c      |    9 +-
 drivers/net/ethernet/moxa/moxart_ether.c           |    5 +-
 drivers/net/ethernet/mscc/ocelot_net.c             |   29 +-
 drivers/net/ethernet/natsemi/natsemi.c             |    6 +-
 drivers/net/ethernet/neterion/s2io.c               |   10 +-
 drivers/net/ethernet/neterion/vxge/vxge-config.c   |    2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c     |   36 +-
 drivers/net/ethernet/netronome/nfp/Makefile        |    3 +-
 drivers/net/ethernet/netronome/nfp/ccm_mbox.c      |    2 +-
 .../net/ethernet/netronome/nfp/flower/conntrack.c  | 1180 +++
 .../net/ethernet/netronome/nfp/flower/conntrack.h  |  231 +
 drivers/net/ethernet/netronome/nfp/flower/main.h   |    6 +
 .../net/ethernet/netronome/nfp/flower/metadata.c   |  129 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |   40 +-
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    |    2 +-
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |    2 -
 .../ethernet/netronome/nfp/nfpcore/nfp_cppcore.c   |    3 +-
 .../net/ethernet/netronome/nfp/nfpcore/nfp_nffw.c  |    2 +-
 drivers/net/ethernet/ni/nixge.c                    |    8 +-
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe.h    |    2 -
 .../ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c    |    2 +
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |  102 +-
 drivers/net/ethernet/qlogic/Kconfig                |    3 +
 drivers/net/ethernet/qlogic/qed/Makefile           |    5 +
 drivers/net/ethernet/qlogic/qed/qed.h              |   14 +
 drivers/net/ethernet/qlogic/qed/qed_cxt.c          |   45 +-
 drivers/net/ethernet/qlogic/qed/qed_cxt.h          |    2 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |  140 +-
 drivers/net/ethernet/qlogic/qed/qed_hsi.h          |    6 +-
 drivers/net/ethernet/qlogic/qed/qed_iscsi.c        |   22 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c          |   40 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c          |    3 +
 drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c      |    3 +-
 drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c      |  829 ++
 drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h      |  103 +
 .../net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.c |  376 +
 .../net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.h |   39 +
 .../ethernet/qlogic/qed/qed_nvmetcp_ip_services.c  |  238 +
 drivers/net/ethernet/qlogic/qed/qed_ooo.c          |    5 +-
 drivers/net/ethernet/qlogic/qed/qed_sp.h           |    5 +
 drivers/net/ethernet/qlogic/qed/qed_sp_commands.c  |    3 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c         |    6 -
 drivers/net/ethernet/qlogic/qede/qede_rdma.c       |    6 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  |    2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_vnic.c  |    2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c     |    8 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.h     |    1 -
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |    7 +-
 drivers/net/ethernet/qualcomm/qca_debug.c          |    1 +
 drivers/net/ethernet/qualcomm/qca_spi.c            |   10 +-
 drivers/net/ethernet/qualcomm/qca_spi.h            |    1 +
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c |    6 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h |    5 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   |   43 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h    |   11 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   |  434 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c    |    2 +
 drivers/net/ethernet/rdc/r6040.c                   |    9 +-
 drivers/net/ethernet/realtek/8139cp.c              |    6 +-
 drivers/net/ethernet/realtek/8139too.c             |    6 +-
 drivers/net/ethernet/realtek/atp.c                 |    4 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   10 +-
 drivers/net/ethernet/renesas/ravb_main.c           |   15 +-
 drivers/net/ethernet/renesas/sh_eth.c              |    5 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |    4 +-
 drivers/net/ethernet/seeq/ether3.c                 |   10 +-
 drivers/net/ethernet/sfc/ef10.c                    |   20 +-
 drivers/net/ethernet/sfc/ef10_sriov.c              |   36 +-
 drivers/net/ethernet/sfc/efx.c                     |   19 +-
 drivers/net/ethernet/sfc/efx_common.c              |   12 +-
 drivers/net/ethernet/sfc/falcon/efx.c              |    4 +-
 drivers/net/ethernet/sfc/falcon/falcon_boards.c    |   10 +-
 drivers/net/ethernet/sfc/farch.c                   |   13 +-
 drivers/net/ethernet/sfc/rx.c                      |    9 +-
 drivers/net/ethernet/sgi/ioc3-eth.c                |    4 +
 drivers/net/ethernet/sis/sis900.c                  |   22 +-
 drivers/net/ethernet/smsc/smc9194.c                |   42 +-
 drivers/net/ethernet/smsc/smc91x.c                 |   14 +-
 drivers/net/ethernet/socionext/netsec.c            |    3 -
 drivers/net/ethernet/socionext/sni_ave.c           |    2 +-
 drivers/net/ethernet/stmicro/stmmac/Kconfig        |   21 +
 drivers/net/ethernet/stmicro/stmmac/Makefile       |    2 +
 drivers/net/ethernet/stmicro/stmmac/common.h       |    3 +-
 .../net/ethernet/stmicro/stmmac/dwmac-ingenic.c    |  398 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |  105 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.h  |   29 +
 .../net/ethernet/stmicro/stmmac/dwmac-loongson.c   |  219 +
 .../ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c    |    4 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |  207 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |    1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c       |   30 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac5.h       |    3 +-
 .../net/ethernet/stmicro/stmmac/dwxgmac2_core.c    |    4 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |   15 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |    7 +-
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |    8 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   95 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c  |   74 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c   |   16 +
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |    9 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |    4 +-
 drivers/net/ethernet/sun/cassini.c                 |    2 +-
 drivers/net/ethernet/sun/sungem.c                  |   20 +-
 drivers/net/ethernet/sun/sunhme.c                  |    6 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   18 +-
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c      |    6 +-
 drivers/net/ethernet/ti/am65-cpts.c                |    4 +-
 drivers/net/ethernet/ti/cpsw-phy-sel.c             |    4 +-
 drivers/net/ethernet/ti/cpsw.c                     |    7 +-
 drivers/net/ethernet/ti/cpsw_ale.c                 |    2 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |    7 +-
 drivers/net/ethernet/ti/cpsw_priv.c                |   10 +-
 drivers/net/ethernet/ti/cpsw_switchdev.c           |    6 +-
 drivers/net/ethernet/ti/davinci_emac.c             |    5 +-
 drivers/net/ethernet/via/via-velocity.c            |    6 +-
 drivers/net/ethernet/wiznet/w5100.c                |    7 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c        |    4 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |    8 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |    5 +-
 drivers/net/ethernet/xircom/xirc2ps_cs.c           |    2 +-
 drivers/net/ethernet/xscale/ixp4xx_eth.c           |   10 +-
 drivers/net/fddi/skfp/ess.c                        |    6 +-
 drivers/net/fddi/skfp/h/supern_2.h                 |    2 +-
 drivers/net/fjes/fjes_main.c                       |   16 +-
 drivers/net/gtp.c                                  |    3 +-
 drivers/net/hamradio/6pack.c                       |   10 +-
 drivers/net/hamradio/baycom_epp.c                  |    4 +-
 drivers/net/hamradio/bpqether.c                    |    4 +-
 drivers/net/hamradio/hdlcdrv.c                     |    2 +-
 drivers/net/hamradio/mkiss.c                       |    6 +-
 drivers/net/hamradio/scc.c                         |   20 +-
 drivers/net/hamradio/yam.c                         |    2 +-
 drivers/net/hyperv/hyperv_net.h                    |    1 +
 drivers/net/hyperv/netvsc_drv.c                    |    5 +
 drivers/net/hyperv/rndis_filter.c                  |    6 +-
 drivers/net/ieee802154/mac802154_hwsim.c           |   11 +-
 drivers/net/ifb.c                                  |    4 +-
 drivers/net/ipa/Makefile                           |    9 +-
 drivers/net/ipa/gsi.c                              |   90 +-
 drivers/net/ipa/gsi.h                              |    2 +-
 drivers/net/ipa/gsi_reg.h                          |    3 +-
 drivers/net/ipa/ipa_cmd.c                          |   40 +-
 drivers/net/ipa/ipa_data-v3.1.c                    |  533 ++
 drivers/net/ipa/ipa_data-v3.5.1.c                  |   45 +-
 drivers/net/ipa/ipa_data-v4.11.c                   |   66 +-
 drivers/net/ipa/ipa_data-v4.2.c                    |   54 +-
 drivers/net/ipa/ipa_data-v4.5.c                    |   69 +-
 drivers/net/ipa/ipa_data-v4.9.c                    |   70 +-
 drivers/net/ipa/ipa_data.h                         |    1 +
 drivers/net/ipa/ipa_endpoint.c                     |   90 +-
 drivers/net/ipa/ipa_main.c                         |   55 +-
 drivers/net/ipa/ipa_mem.c                          |  264 +-
 drivers/net/ipa/ipa_mem.h                          |   26 +-
 drivers/net/ipa/ipa_qmi.c                          |   32 +-
 drivers/net/ipa/ipa_reg.h                          |    1 +
 drivers/net/ipa/ipa_smp2p.c                        |    5 +-
 drivers/net/ipa/ipa_sysfs.c                        |  136 +
 drivers/net/ipa/ipa_sysfs.h                        |   15 +
 drivers/net/ipa/ipa_table.c                        |   94 +-
 drivers/net/ipa/ipa_uc.c                           |    3 +-
 drivers/net/ipa/ipa_version.h                      |    2 +
 drivers/net/macsec.c                               |    4 +-
 drivers/net/macvlan.c                              |    2 +-
 drivers/net/mdio/Kconfig                           |   14 +
 drivers/net/mdio/Makefile                          |    4 +-
 drivers/net/mdio/acpi_mdio.c                       |   58 +
 drivers/net/mdio/fwnode_mdio.c                     |  144 +
 drivers/net/mdio/mdio-bcm-unimac.c                 |    2 +-
 drivers/net/mdio/mdio-ipq8064.c                    |   70 +-
 drivers/net/mdio/mdio-mscc-miim.c                  |    6 +-
 drivers/net/mdio/mdio-mux-bcm-iproc.c              |    9 +-
 drivers/net/mdio/mdio-mux-meson-g12a.c             |    2 +-
 drivers/net/mdio/of_mdio.c                         |  149 +-
 drivers/net/mhi/net.c                              |  133 +-
 drivers/net/mhi/proto_mbim.c                       |    5 +-
 drivers/net/mii.c                                  |    2 +-
 drivers/net/netdevsim/bus.c                        |  129 +-
 drivers/net/netdevsim/dev.c                        |  404 +-
 drivers/net/netdevsim/netdev.c                     |   95 +-
 drivers/net/netdevsim/netdevsim.h                  |   49 +
 drivers/net/pcs/Makefile                           |    4 +-
 drivers/net/pcs/pcs-xpcs-nxp.c                     |  185 +
 drivers/net/pcs/pcs-xpcs.c                         |  659 +-
 drivers/net/pcs/pcs-xpcs.h                         |  115 +
 drivers/net/phy/Kconfig                            |   16 +-
 drivers/net/phy/Makefile                           |    2 +
 drivers/net/phy/adin.c                             |    2 +-
 drivers/net/phy/at803x.c                           |  192 +-
 drivers/net/phy/ax88796b.c                         |   74 +-
 drivers/net/phy/bcm87xx.c                          |    4 +-
 drivers/net/phy/davicom.c                          |    6 +-
 drivers/net/phy/dp83640.c                          |    5 +-
 drivers/net/phy/et1011c.c                          |   15 +-
 drivers/net/phy/fixed_phy.c                        |    4 +-
 drivers/net/phy/lxt.c                              |    4 +-
 drivers/net/phy/marvell.c                          |   40 +-
 drivers/net/phy/mdio_bus.c                         |    4 +-
 drivers/net/phy/mdio_device.c                      |    4 +-
 drivers/net/phy/mediatek-ge.c                      |  112 +
 drivers/net/phy/micrel.c                           |  410 +-
 drivers/net/phy/mii_timestamper.c                  |    3 +
 drivers/net/phy/motorcomm.c                        |  137 +
 drivers/net/phy/mscc/mscc_macsec.c                 |    2 +-
 drivers/net/phy/mscc/mscc_macsec.h                 |    2 +-
 drivers/net/phy/national.c                         |    6 +-
 drivers/net/phy/nxp-c45-tja11xx.c                  |  537 +-
 drivers/net/phy/phy-c45.c                          |    2 +-
 drivers/net/phy/phy-core.c                         |    3 +-
 drivers/net/phy/phy.c                              |    6 +-
 drivers/net/phy/phy_device.c                       |  132 +-
 drivers/net/phy/phylink.c                          |   60 +-
 drivers/net/phy/qsemi.c                            |    1 +
 drivers/net/phy/realtek.c                          |   76 +-
 drivers/net/phy/rockchip.c                         |    2 +-
 drivers/net/phy/sfp-bus.c                          |   33 +-
 drivers/net/phy/sfp.c                              |    2 +-
 drivers/net/phy/spi_ks8995.c                       |   10 +-
 drivers/net/phy/ste10Xp.c                          |    6 +-
 drivers/net/phy/vitesse.c                          |    3 +-
 drivers/net/ppp/bsd_comp.c                         |    2 +-
 drivers/net/slip/slhc.c                            |    2 +-
 drivers/net/tun.c                                  |   16 +-
 drivers/net/usb/Kconfig                            |   12 +-
 drivers/net/usb/asix.h                             |   13 +-
 drivers/net/usb/asix_common.c                      |  106 +-
 drivers/net/usb/asix_devices.c                     |  202 +-
 drivers/net/usb/ax88172a.c                         |   21 +-
 drivers/net/usb/cdc_ether.c                        |    2 +-
 drivers/net/usb/cdc_mbim.c                         |    7 +-
 drivers/net/usb/cdc_ncm.c                          |   40 +-
 drivers/net/usb/hso.c                              |    7 +-
 drivers/net/usb/huawei_cdc_ncm.c                   |    1 +
 drivers/net/usb/int51x1.c                          |    2 +-
 drivers/net/usb/lan78xx.c                          |    2 +-
 drivers/net/usb/lg-vl600.c                         |    4 +-
 drivers/net/usb/mcs7830.c                          |    2 +-
 drivers/net/usb/qmi_wwan.c                         |    3 +-
 drivers/net/usb/r8152.c                            |   97 +-
 drivers/net/usb/rndis_host.c                       |    2 +-
 drivers/net/usb/usbnet.c                           |   27 +-
 drivers/net/virtio_net.c                           |   53 +-
 drivers/net/vrf.c                                  |   16 +-
 drivers/net/vxlan.c                                |    2 +
 drivers/net/wan/Kconfig                            |    4 +-
 drivers/net/wan/c101.c                             |   46 +-
 drivers/net/wan/cosa.c                             |  493 +-
 drivers/net/wan/farsync.c                          |  487 +-
 drivers/net/wan/fsl_ucc_hdlc.c                     |    3 +-
 drivers/net/wan/hd64570.c                          |  124 +-
 drivers/net/wan/hd64572.c                          |   95 +-
 drivers/net/wan/hdlc.c                             |   63 +-
 drivers/net/wan/hdlc_cisco.c                       |   49 +-
 drivers/net/wan/hdlc_fr.c                          |  101 +-
 drivers/net/wan/hdlc_ppp.c                         |   38 +-
 drivers/net/wan/hdlc_x25.c                         |   77 +-
 drivers/net/wan/hostess_sv11.c                     |  113 +-
 drivers/net/wan/ixp4xx_hss.c                       |  144 +-
 drivers/net/wan/lapbether.c                        |   65 +-
 drivers/net/wan/lmc/lmc.h                          |    2 +-
 drivers/net/wan/n2.c                               |   56 +-
 drivers/net/wan/pc300too.c                         |   52 +-
 drivers/net/wan/pci200syn.c                        |   51 +-
 drivers/net/wan/sealevel.c                         |  126 +-
 drivers/net/wan/wanxl.c                            |  190 +-
 drivers/net/wan/z85230.c                           |  995 +--
 drivers/net/wireless/ath/ath10k/ahb.c              |    9 +-
 drivers/net/wireless/ath/ath10k/core.h             |    2 +-
 drivers/net/wireless/ath/ath10k/debug.c            |    4 +-
 drivers/net/wireless/ath/ath10k/htt.h              |    4 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |    2 -
 drivers/net/wireless/ath/ath10k/mac.c              |    1 +
 drivers/net/wireless/ath/ath10k/pci.c              |   14 +-
 drivers/net/wireless/ath/ath10k/pci.h              |    1 -
 drivers/net/wireless/ath/ath10k/wmi.c              |    8 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |    9 +-
 drivers/net/wireless/ath/ath11k/core.c             |   47 +-
 drivers/net/wireless/ath/ath11k/core.h             |    5 +-
 .../net/wireless/ath/ath11k/debugfs_htt_stats.c    |    2 +-
 .../net/wireless/ath/ath11k/debugfs_htt_stats.h    |    2 +-
 drivers/net/wireless/ath/ath11k/dp.c               |   16 +-
 drivers/net/wireless/ath/ath11k/hal.c              |   10 +
 drivers/net/wireless/ath/ath11k/hal.h              |    3 +-
 drivers/net/wireless/ath/ath11k/hal_rx.c           |   42 +-
 drivers/net/wireless/ath/ath11k/hal_rx.h           |    8 +
 drivers/net/wireless/ath/ath11k/hw.c               |  391 +
 drivers/net/wireless/ath/ath11k/hw.h               |    5 +
 drivers/net/wireless/ath/ath11k/mac.c              |   24 +-
 drivers/net/wireless/ath/ath11k/mhi.c              |    1 +
 drivers/net/wireless/ath/ath11k/pci.c              |   49 +-
 drivers/net/wireless/ath/ath11k/rx_desc.h          |   87 +
 drivers/net/wireless/ath/ath11k/wmi.c              |    4 +-
 drivers/net/wireless/ath/ath11k/wmi.h              |    4 +-
 drivers/net/wireless/ath/ath5k/pcu.c               |    2 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |    4 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |    2 +
 drivers/net/wireless/ath/ath9k/main.c              |    7 +-
 drivers/net/wireless/ath/carl9170/Kconfig          |    8 +-
 drivers/net/wireless/ath/hw.c                      |    2 +-
 drivers/net/wireless/ath/wcn36xx/dxe.c             |    2 +-
 drivers/net/wireless/ath/wcn36xx/hal.h             |   20 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |  131 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |  288 +-
 drivers/net/wireless/ath/wcn36xx/smd.h             |   17 +
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h         |   14 +
 drivers/net/wireless/ath/wil6210/cfg80211.c        |    2 -
 drivers/net/wireless/ath/wil6210/interrupt.c       |    2 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |    6 +-
 drivers/net/wireless/broadcom/b43/phy_n.c          |   47 -
 drivers/net/wireless/broadcom/b43legacy/dma.c      |   13 -
 drivers/net/wireless/broadcom/b43legacy/main.c     |    2 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   70 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   11 +-
 .../wireless/broadcom/brcm80211/brcmfmac/debug.h   |    4 +
 .../broadcom/brcm80211/brcmfmac/firmware.h         |    7 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/of.c  |   57 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |    4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   19 +-
 .../wireless/broadcom/brcm80211/brcmsmac/aiutils.c |    3 -
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |    8 +-
 .../wireless/broadcom/brcm80211/brcmsmac/main.c    |    3 +-
 .../net/wireless/broadcom/brcm80211/brcmsmac/stf.h |    1 -
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/Makefile        |    3 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   16 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |    6 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |   86 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |   10 +
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |    5 -
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h     |  110 +-
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   |   26 +
 .../net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h    |    3 +-
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |   19 +
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   47 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |    4 +-
 drivers/net/wireless/intel/iwlwifi/fw/dump.c       |  418 +
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   25 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |  120 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.h       |    4 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.c       |  262 +
 drivers/net/wireless/intel/iwlwifi/fw/uefi.h       |   42 +
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |    6 +-
 .../wireless/intel/iwlwifi/iwl-context-info-gen3.h |   20 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |    5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |   13 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   11 +
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  138 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |    4 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   20 +
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  118 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |    4 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |    4 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |    9 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |   44 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   31 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   20 +-
 .../net/wireless/intel/iwlwifi/mvm/offloading.c    |   26 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   40 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |   26 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |   14 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |    8 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   45 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |    3 +
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |  357 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |   90 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   19 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   24 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |   34 -
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |   78 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   39 +-
 drivers/net/wireless/intersil/orinoco/hw.c         |   18 +-
 drivers/net/wireless/intersil/orinoco/hw.h         |    5 +-
 drivers/net/wireless/intersil/orinoco/wext.c       |    2 +-
 drivers/net/wireless/mac80211_hwsim.c              |   55 +-
 drivers/net/wireless/marvell/libertas/main.c       |    2 +-
 drivers/net/wireless/marvell/libertas/mesh.c       |  149 +-
 drivers/net/wireless/marvell/libertas_tf/if_usb.c  |    2 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |    6 +
 drivers/net/wireless/marvell/mwifiex/main.c        |   13 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |   11 +-
 drivers/net/wireless/marvell/mwl8k.c               |    4 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   19 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   64 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   56 +-
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |   32 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |   43 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/regs.h   |   12 -
 drivers/net/wireless/mediatek/mt76/mt7615/Makefile |    2 +-
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |   22 +-
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |   13 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |   85 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  156 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h    |   42 -
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   60 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |   99 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |   11 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   19 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_init.c   |   10 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_mac.c    |   12 +-
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |    2 +
 drivers/net/wireless/mediatek/mt76/mt7615/sdio.h   |    2 +-
 .../net/wireless/mediatek/mt76/mt7615/sdio_mcu.c   |   39 +-
 .../net/wireless/mediatek/mt76/mt7615/sdio_txrx.c  |   16 +-
 drivers/net/wireless/mediatek/mt76/mt7615/soc.c    |    3 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_sdio.c   |   11 +-
 drivers/net/wireless/mediatek/mt76/mt76_connac.h   |   19 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mac.c   |   10 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |  228 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.h   |   72 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |   36 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_regs.h  |   18 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |   16 +-
 drivers/net/wireless/mediatek/mt76/mt7915/Makefile |    2 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |   78 +-
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    |   45 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |   44 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h |   13 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |  179 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  384 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.h    |   56 +
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |  103 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  673 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |   80 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |   39 +-
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |   41 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |   32 +-
 .../net/wireless/mediatek/mt76/mt7915/testmode.c   |   21 +-
 .../net/wireless/mediatek/mt76/mt7915/testmode.h   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/Makefile |    2 +-
 .../net/wireless/mediatek/mt76/mt7921/debugfs.c    |   37 +
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c    |   22 +-
 drivers/net/wireless/mediatek/mt76/mt7921/init.c   |   99 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |  248 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.h    |   14 +
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  172 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  203 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.h    |  166 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |   20 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |   34 +-
 drivers/net/wireless/mediatek/mt76/sdio.c          |   17 +-
 drivers/net/wireless/mediatek/mt76/testmode.c      |   35 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |   82 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |    1 +
 drivers/net/wireless/mediatek/mt7601u/usb.c        |    1 +
 drivers/net/wireless/microchip/wilc1000/spi.c      |    2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |    2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c   |    5 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |   11 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c |   59 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   11 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    |   20 +-
 drivers/net/wireless/realtek/rtlwifi/cam.c         |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/mac.c   |    4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/trx.c   |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    |    2 +-
 drivers/net/wireless/realtek/rtw88/coex.c          |   45 +-
 drivers/net/wireless/realtek/rtw88/debug.c         |    7 +
 drivers/net/wireless/realtek/rtw88/debug.h         |    1 +
 drivers/net/wireless/realtek/rtw88/fw.c            |  114 +
 drivers/net/wireless/realtek/rtw88/fw.h            |   55 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |   11 +-
 drivers/net/wireless/realtek/rtw88/main.c          |  196 +-
 drivers/net/wireless/realtek/rtw88/main.h          |   57 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |   32 +
 drivers/net/wireless/realtek/rtw88/phy.c           |   81 +
 drivers/net/wireless/realtek/rtw88/phy.h           |    1 +
 drivers/net/wireless/realtek/rtw88/ps.c            |    4 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |  113 +-
 .../net/wireless/realtek/rtw88/rtw8822c_table.c    | 1008 +--
 drivers/net/wireless/rndis_wlan.c                  |    5 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |    6 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |   20 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |    7 +-
 drivers/net/wireless/rsi/rsi_main.h                |    1 -
 drivers/net/wireless/st/cw1200/cw1200_sdio.c       |    1 +
 drivers/net/wireless/st/cw1200/scan.c              |   17 +-
 drivers/net/wireless/ti/wl1251/cmd.c               |   17 +-
 drivers/net/wireless/ti/wl12xx/main.c              |    7 +
 drivers/net/wireless/ti/wlcore/cmd.c               |    6 +-
 drivers/net/wireless/ti/wlcore/event.c             |   67 +-
 drivers/net/wireless/ti/wlcore/main.c              |    4 +-
 drivers/net/wireless/ti/wlcore/sysfs.c             |   24 +-
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c       |    4 +-
 drivers/net/wwan/Kconfig                           |   53 +-
 drivers/net/wwan/Makefile                          |    6 +-
 drivers/net/wwan/iosm/Makefile                     |   23 +
 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c          |   88 +
 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.h          |   59 +
 drivers/net/wwan/iosm/iosm_ipc_imem.c              | 1363 +++
 drivers/net/wwan/iosm/iosm_ipc_imem.h              |  579 ++
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c          |  346 +
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h          |  101 +
 drivers/net/wwan/iosm/iosm_ipc_irq.c               |   90 +
 drivers/net/wwan/iosm/iosm_ipc_irq.h               |   33 +
 drivers/net/wwan/iosm/iosm_ipc_mmio.c              |  223 +
 drivers/net/wwan/iosm/iosm_ipc_mmio.h              |  183 +
 drivers/net/wwan/iosm/iosm_ipc_mux.c               |  455 +
 drivers/net/wwan/iosm/iosm_ipc_mux.h               |  343 +
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c         |  910 ++
 drivers/net/wwan/iosm/iosm_ipc_mux_codec.h         |  193 +
 drivers/net/wwan/iosm/iosm_ipc_pcie.c              |  580 ++
 drivers/net/wwan/iosm/iosm_ipc_pcie.h              |  209 +
 drivers/net/wwan/iosm/iosm_ipc_pm.c                |  333 +
 drivers/net/wwan/iosm/iosm_ipc_pm.h                |  207 +
 drivers/net/wwan/iosm/iosm_ipc_port.c              |   85 +
 drivers/net/wwan/iosm/iosm_ipc_port.h              |   50 +
 drivers/net/wwan/iosm/iosm_ipc_protocol.c          |  283 +
 drivers/net/wwan/iosm/iosm_ipc_protocol.h          |  237 +
 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c      |  552 ++
 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.h      |  444 +
 drivers/net/wwan/iosm/iosm_ipc_task_queue.c        |  202 +
 drivers/net/wwan/iosm/iosm_ipc_task_queue.h        |   97 +
 drivers/net/wwan/iosm/iosm_ipc_uevent.c            |   44 +
 drivers/net/wwan/iosm/iosm_ipc_uevent.h            |   41 +
 drivers/net/wwan/iosm/iosm_ipc_wwan.c              |  340 +
 drivers/net/wwan/iosm/iosm_ipc_wwan.h              |   55 +
 drivers/net/wwan/rpmsg_wwan_ctrl.c                 |  166 +
 drivers/net/wwan/wwan_core.c                       |  638 +-
 drivers/net/wwan/wwan_hwsim.c                      |  547 ++
 drivers/nfc/fdp/fdp.c                              |   42 +-
 drivers/nfc/fdp/fdp.h                              |    1 -
 drivers/nfc/fdp/i2c.c                              |   14 +-
 drivers/nfc/mei_phy.c                              |    8 -
 drivers/nfc/microread/microread.c                  |    1 -
 drivers/nfc/nfcmrvl/fw_dnld.c                      |   25 +-
 drivers/nfc/nfcmrvl/fw_dnld.h                      |   15 +-
 drivers/nfc/nfcmrvl/i2c.c                          |   22 +-
 drivers/nfc/nfcmrvl/main.c                         |   13 +-
 drivers/nfc/nfcmrvl/nfcmrvl.h                      |   27 +-
 drivers/nfc/nfcmrvl/spi.c                          |   17 +-
 drivers/nfc/nfcmrvl/uart.c                         |   47 +-
 drivers/nfc/nfcmrvl/usb.c                          |   29 +-
 drivers/nfc/nxp-nci/core.c                         |   39 +-
 drivers/nfc/nxp-nci/firmware.c                     |    7 +-
 drivers/nfc/pn533/i2c.c                            |   10 +-
 drivers/nfc/pn533/pn533.c                          |   46 -
 drivers/nfc/pn533/uart.c                           |    2 +-
 drivers/nfc/pn533/usb.c                            |    4 -
 drivers/nfc/pn544/i2c.c                            |   11 +-
 drivers/nfc/port100.c                              |    4 +-
 drivers/nfc/s3fwrn5/i2c.c                          |   32 +-
 drivers/nfc/st-nci/i2c.c                           |    9 +-
 drivers/nfc/st-nci/se.c                            |   14 +-
 drivers/nfc/st-nci/spi.c                           |    9 +-
 drivers/nfc/st-nci/vendor_cmds.c                   |   15 +-
 drivers/nfc/st21nfca/dep.c                         |   59 +-
 drivers/nfc/st21nfca/i2c.c                         |    9 +-
 drivers/nfc/st95hf/core.c                          |   13 +-
 drivers/ptp/ptp_clock.c                            |   22 +-
 drivers/rpmsg/rpmsg_core.c                         |    4 +-
 drivers/s390/net/netiucv.c                         |   28 +-
 drivers/s390/net/qeth_core.h                       |   42 +-
 drivers/s390/net/qeth_core_main.c                  |  349 +-
 drivers/s390/net/qeth_ethtool.c                    |    7 +-
 drivers/s390/net/qeth_l2_main.c                    |   12 +-
 drivers/ssb/driver_gpio.c                          |    6 +-
 drivers/ssb/driver_pcicore.c                       |   18 +-
 drivers/ssb/main.c                                 |   36 +-
 drivers/ssb/pci.c                                  |   16 +-
 drivers/ssb/pcmcia.c                               |   16 +-
 drivers/ssb/scan.c                                 |    1 +
 drivers/ssb/sdio.c                                 |    1 -
 drivers/staging/mt7621-dts/mt7621.dtsi             |    4 +
 drivers/usb/class/cdc-wdm.c                        |  181 +-
 drivers/vhost/net.c                                |    6 +-
 drivers/vhost/vsock.c                              |   58 +-
 fs/xfs/xfs_message.h                               |   13 +-
 include/asm-generic/bug.h                          |   37 +-
 include/linux/acpi.h                               |    7 +
 include/linux/acpi_mdio.h                          |   26 +
 include/linux/avf/virtchnl.h                       |   29 +-
 include/linux/bpf.h                                |   42 +-
 include/linux/bpf_local_storage.h                  |    4 +-
 include/linux/bpf_types.h                          |    2 +
 include/linux/bpf_verifier.h                       |    9 +
 include/linux/bpfptr.h                             |   75 +
 include/linux/btf.h                                |    2 +-
 include/linux/device.h                             |    1 +
 include/linux/dsa/8021q.h                          |   79 +-
 include/linux/dsa/sja1105.h                        |   26 +-
 include/linux/ethtool.h                            |   12 +-
 include/linux/filter.h                             |   29 +-
 include/linux/fwnode_mdio.h                        |   35 +
 include/linux/ieee80211.h                          |   10 +-
 include/linux/if_arp.h                             |    1 +
 include/linux/if_bridge.h                          |   38 +-
 include/linux/if_rmnet.h                           |   32 +-
 include/linux/kernel.h                             |   12 +
 include/linux/micrel_phy.h                         |   16 +
 include/linux/mlx5/device.h                        |   10 +
 include/linux/mlx5/driver.h                        |    2 +
 include/linux/mlx5/eq.h                            |    1 +
 include/linux/mlx5/eswitch.h                       |   17 +-
 include/linux/mlx5/fs.h                            |   14 +-
 include/linux/mlx5/mlx5_ifc.h                      |   49 +-
 include/linux/mm.h                                 |   11 +-
 include/linux/mm_types.h                           |    7 +
 include/linux/mod_devicetable.h                    |    1 +
 include/linux/net/intel/i40e_client.h              |   12 +-
 include/linux/net/intel/iidc.h                     |  100 +
 include/linux/netdev_features.h                    |    2 +-
 include/linux/netdevice.h                          |    4 +-
 include/linux/netfilter.h                          |   12 +-
 include/linux/netfilter/nfnetlink.h                |    1 +
 include/linux/netfilter/x_tables.h                 |    2 +-
 include/linux/of_mdio.h                            |    7 +
 include/linux/once_lite.h                          |   24 +
 include/linux/pcs/pcs-xpcs.h                       |   46 +-
 include/linux/phy.h                                |   40 +
 include/linux/phylink.h                            |    3 +
 include/linux/poison.h                             |    3 +
 include/linux/printk.h                             |   23 +-
 include/linux/ptp_clock_kernel.h                   |   34 +-
 include/linux/qed/common_hsi.h                     |    2 +-
 include/linux/qed/nvmetcp_common.h                 |  531 ++
 include/linux/qed/qed_if.h                         |   18 +
 include/linux/qed/qed_ll2_if.h                     |    2 +-
 include/linux/qed/qed_nvmetcp_if.h                 |  240 +
 include/linux/qed/qed_nvmetcp_ip_services_if.h     |   29 +
 include/linux/rcupdate.h                           |   14 +
 include/linux/sctp.h                               |    7 +
 include/linux/skbuff.h                             |   39 +-
 include/linux/skmsg.h                              |    4 +-
 include/linux/stmmac.h                             |   17 +
 include/linux/usb/cdc-wdm.h                        |    3 +-
 include/linux/virtio_vsock.h                       |   10 +
 include/linux/wwan.h                               |   71 +-
 include/net/af_vsock.h                             |    8 +
 include/net/bluetooth/hci.h                        |   99 +-
 include/net/bluetooth/hci_core.h                   |   29 +-
 include/net/bluetooth/mgmt.h                       |    3 +-
 include/net/bonding.h                              |    2 +-
 include/net/cfg80211.h                             |   51 +-
 include/net/devlink.h                              |   58 +
 include/net/dsa.h                                  |   62 +-
 include/net/flow_offload.h                         |   12 +-
 include/net/icmp.h                                 |    1 +
 include/net/inet_connection_sock.h                 |    2 +-
 include/net/ip.h                                   |   12 +-
 include/net/ip6_route.h                            |   16 +-
 include/net/ip_fib.h                               |   43 +
 include/net/ipv6.h                                 |    8 +
 include/net/mac80211.h                             |   72 +-
 include/net/macsec.h                               |    2 +-
 include/net/mptcp.h                                |   10 +-
 include/net/net_namespace.h                        |    4 +
 include/net/netfilter/nf_conntrack.h               |    7 +
 include/net/netfilter/nf_conntrack_l4proto.h       |   20 +-
 include/net/netfilter/nf_flow_table.h              |    2 +
 include/net/netfilter/nf_tables.h                  |   34 +-
 include/net/netfilter/nf_tables_core.h             |   32 +
 include/net/netfilter/nf_tables_ipv4.h             |   40 +-
 include/net/netfilter/nf_tables_ipv6.h             |   42 +-
 include/net/netns/conntrack.h                      |    8 +
 include/net/netns/ipv4.h                           |    2 +
 include/net/netns/ipv6.h                           |    3 +-
 include/net/netns/sctp.h                           |    3 +
 include/net/netns/smc.h                            |   16 +
 include/net/netns/xfrm.h                           |    1 +
 include/net/page_pool.h                            |    9 +
 include/net/protocol.h                             |    1 -
 include/net/rtnetlink.h                            |    8 +
 include/net/sch_generic.h                          |   43 +-
 include/net/sctp/command.h                         |    1 +
 include/net/sctp/constants.h                       |   20 +
 include/net/sctp/sctp.h                            |   57 +-
 include/net/sctp/sm.h                              |    6 +-
 include/net/sctp/structs.h                         |   22 +-
 include/net/sock.h                                 |    5 +
 include/net/sock_reuseport.h                       |    9 +-
 include/net/switchdev.h                            |   13 +-
 include/net/tc_act/tc_vlan.h                       |    1 +
 include/net/tcp.h                                  |    4 +
 include/net/tls.h                                  |    4 +-
 include/net/xdp.h                                  |    1 +
 include/net/xdp_sock.h                             |    2 +-
 include/net/xfrm.h                                 |   40 +-
 include/net/xsk_buff_pool.h                        |    9 +-
 include/trace/events/mptcp.h                       |   17 +-
 include/trace/events/sock.h                        |   60 +
 include/trace/events/tcp.h                         |   76 +
 .../trace/events/vsock_virtio_transport_common.h   |    5 +-
 include/trace/events/xdp.h                         |    6 +-
 include/uapi/asm-generic/socket.h                  |    2 +
 include/uapi/linux/bpf.h                           |   82 +-
 include/uapi/linux/can.h                           |   13 +-
 include/uapi/linux/devlink.h                       |   17 +
 include/uapi/linux/ethtool.h                       |    4 +-
 include/uapi/linux/ethtool_netlink.h               |    2 +-
 include/uapi/linux/icmp.h                          |    3 +-
 include/uapi/linux/if_bridge.h                     |    2 +
 include/uapi/linux/if_link.h                       |    9 +
 include/uapi/linux/mptcp.h                         |    1 +
 include/uapi/linux/netfilter/nf_tables.h           |   17 +
 include/uapi/linux/netfilter/nfnetlink.h           |    3 +-
 include/uapi/linux/netfilter/nfnetlink_hook.h      |   55 +
 include/uapi/linux/netlink.h                       |    5 +-
 include/uapi/linux/nl80211.h                       |    9 +-
 include/uapi/linux/sctp.h                          |    8 +
 include/uapi/linux/seg6_local.h                    |    2 +
 include/uapi/linux/smc.h                           |   83 +
 include/uapi/linux/snmp.h                          |    2 +
 include/uapi/linux/virtio_vsock.h                  |    9 +
 include/uapi/linux/wwan.h                          |   16 +
 kernel/bpf/bpf_inode_storage.c                     |    2 +-
 kernel/bpf/bpf_iter.c                              |   13 +-
 kernel/bpf/bpf_lsm.c                               |    2 +-
 kernel/bpf/btf.c                                   |   76 +-
 kernel/bpf/core.c                                  |   61 +-
 kernel/bpf/cpumap.c                                |   16 +-
 kernel/bpf/devmap.c                                |  358 +-
 kernel/bpf/hashtab.c                               |  123 +-
 kernel/bpf/helpers.c                               |    6 +-
 kernel/bpf/inode.c                                 |    2 +-
 kernel/bpf/lpm_trie.c                              |    6 +-
 kernel/bpf/preload/iterators/iterators.bpf.c       |    1 -
 kernel/bpf/reuseport_array.c                       |    2 +-
 kernel/bpf/ringbuf.c                               |    2 +
 kernel/bpf/syscall.c                               |  241 +-
 kernel/bpf/tnum.c                                  |   41 +-
 kernel/bpf/trampoline.c                            |    2 +-
 kernel/bpf/verifier.c                              |  363 +-
 kernel/trace/bpf_trace.c                           |    2 +
 kernel/trace/trace.h                               |   13 +-
 net/8021q/vlan.c                                   |    3 +-
 net/8021q/vlan.h                                   |    6 +-
 net/8021q/vlan_dev.c                               |    6 +-
 net/9p/trans_virtio.c                              |    6 +-
 net/appletalk/ddp.c                                |    6 +-
 net/atm/atm_sysfs.c                                |   24 +-
 net/atm/br2684.c                                   |    4 +-
 net/atm/resources.c                                |    7 +-
 net/batman-adv/bat_iv_ogm.c                        |    6 +
 net/batman-adv/bat_v.c                             |   10 +
 net/batman-adv/bridge_loop_avoidance.c             |    4 +-
 net/batman-adv/bridge_loop_avoidance.h             |    1 -
 net/batman-adv/hard-interface.c                    |   65 +-
 net/batman-adv/hard-interface.h                    |    3 +-
 net/batman-adv/hash.h                              |    2 +-
 net/batman-adv/main.h                              |    3 +-
 net/batman-adv/multicast.c                         |   41 +-
 net/batman-adv/netlink.c                           |    8 +
 net/batman-adv/routing.c                           |    9 +-
 net/batman-adv/send.c                              |  374 +-
 net/batman-adv/send.h                              |   12 +-
 net/batman-adv/soft-interface.c                    |   49 +-
 net/batman-adv/soft-interface.h                    |    2 -
 net/bluetooth/6lowpan.c                            |   54 +-
 net/bluetooth/a2mp.c                               |   24 +-
 net/bluetooth/amp.c                                |    6 +-
 net/bluetooth/bnep/core.c                          |    8 +-
 net/bluetooth/cmtp/capi.c                          |   22 +-
 net/bluetooth/cmtp/core.c                          |    5 +
 net/bluetooth/hci_conn.c                           |   12 +-
 net/bluetooth/hci_core.c                           |   86 +-
 net/bluetooth/hci_debugfs.c                        |    8 +-
 net/bluetooth/hci_event.c                          |  189 +-
 net/bluetooth/hci_request.c                        |  203 +-
 net/bluetooth/hci_sock.c                           |   18 +-
 net/bluetooth/hidp/core.c                          |    8 +-
 net/bluetooth/l2cap_core.c                         |   16 +-
 net/bluetooth/mgmt.c                               |   60 +-
 net/bluetooth/mgmt_config.c                        |    4 +-
 net/bluetooth/msft.c                               |    8 +-
 net/bluetooth/rfcomm/tty.c                         |   10 +-
 net/bluetooth/sco.c                                |    8 +-
 net/bluetooth/smp.c                                |   84 +-
 net/bluetooth/smp.h                                |    6 +-
 net/bpf/test_run.c                                 |   45 +-
 net/bpfilter/main.c                                |    2 +-
 net/bridge/br_cfm.c                                |    2 +-
 net/bridge/br_fdb.c                                |   60 +-
 net/bridge/br_forward.c                            |    5 +-
 net/bridge/br_input.c                              |    2 +-
 net/bridge/br_mdb.c                                |   80 +-
 net/bridge/br_mrp.c                                |   33 +-
 net/bridge/br_multicast.c                          |  445 +-
 net/bridge/br_netlink.c                            |    1 -
 net/bridge/br_private.h                            |   77 +-
 net/bridge/br_private_mrp.h                        |   11 +
 net/bridge/br_stp.c                                |    4 +-
 net/bridge/br_switchdev.c                          |   12 +-
 net/bridge/br_vlan.c                               |   19 +-
 net/caif/caif_socket.c                             |    2 +-
 net/caif/cfcnfg.c                                  |    2 +-
 net/caif/chnl_net.c                                |    2 -
 net/can/bcm.c                                      |   11 +-
 net/can/gw.c                                       |    3 +
 net/can/isotp.c                                    |   47 +-
 net/can/j1939/main.c                               |    4 +
 net/can/j1939/socket.c                             |    9 +-
 net/can/proc.c                                     |    6 +-
 net/can/raw.c                                      |    6 +-
 net/ceph/auth_x_protocol.h                         |    2 +-
 net/ceph/mon_client.c                              |    2 +-
 net/ceph/osdmap.c                                  |    4 +-
 net/core/bpf_sk_storage.c                          |    3 +-
 net/core/dev.c                                     |   56 +-
 net/core/devlink.c                                 |  716 +-
 net/core/filter.c                                  |  114 +-
 net/core/flow_dissector.c                          |    4 +-
 net/core/neighbour.c                               |    2 +-
 net/core/net-traces.c                              |    1 +
 net/core/netpoll.c                                 |    4 +-
 net/core/page_pool.c                               |   28 +
 net/core/pktgen.c                                  |   38 +-
 net/core/rtnetlink.c                               |   70 +-
 net/core/skbuff.c                                  |   26 +-
 net/core/skmsg.c                                   |   82 +-
 net/core/sock.c                                    |  120 +-
 net/core/sock_map.c                                |    2 +-
 net/core/sock_reuseport.c                          |  366 +-
 net/core/xdp.c                                     |   39 +-
 net/dcb/dcbnl.c                                    |    6 +-
 net/dccp/ccids/lib/tfrc_equation.c                 |    1 +
 net/dccp/ipv4.c                                    |    5 +-
 net/dccp/ipv6.c                                    |    4 +-
 net/dccp/proto.c                                   |    2 +-
 net/dccp/timer.c                                   |    2 +-
 net/decnet/dn_nsp_in.c                             |    2 +-
 net/decnet/dn_nsp_out.c                            |    2 +-
 net/decnet/dn_route.c                              |    2 +-
 net/devres.c                                       |    2 +-
 net/dsa/dsa2.c                                     |   36 +-
 net/dsa/dsa_priv.h                                 |   27 +-
 net/dsa/master.c                                   |    6 +-
 net/dsa/port.c                                     |  148 +-
 net/dsa/slave.c                                    |  251 +-
 net/dsa/switch.c                                   |  338 +-
 net/dsa/tag_8021q.c                                |   23 +
 net/dsa/tag_ar9331.c                               |    2 +-
 net/dsa/tag_brcm.c                                 |    6 +-
 net/dsa/tag_dsa.c                                  |    4 +-
 net/dsa/tag_gswip.c                                |    2 +-
 net/dsa/tag_hellcreek.c                            |    3 +-
 net/dsa/tag_ksz.c                                  |    9 +-
 net/dsa/tag_lan9303.c                              |    2 +-
 net/dsa/tag_mtk.c                                  |    2 +-
 net/dsa/tag_ocelot.c                               |    4 +-
 net/dsa/tag_ocelot_8021q.c                         |   20 +-
 net/dsa/tag_qca.c                                  |    2 +-
 net/dsa/tag_rtl4_a.c                               |    2 +-
 net/dsa/tag_sja1105.c                              |  312 +-
 net/dsa/tag_trailer.c                              |    3 +-
 net/dsa/tag_xrs700x.c                              |    3 +-
 net/ethtool/eeprom.c                               |   13 +-
 net/ethtool/netlink.c                              |   11 +-
 net/ethtool/netlink.h                              |    4 +-
 net/hsr/hsr_framereg.c                             |    3 +-
 net/ipv4/af_inet.c                                 |    6 +-
 net/ipv4/ah4.c                                     |    1 -
 net/ipv4/cipso_ipv4.c                              |    3 +-
 net/ipv4/devinet.c                                 |    4 +-
 net/ipv4/esp4.c                                    |    3 +-
 net/ipv4/esp4_offload.c                            |    4 +-
 net/ipv4/fib_frontend.c                            |   12 +-
 net/ipv4/fib_lookup.h                              |    2 +-
 net/ipv4/gre_demux.c                               |    1 -
 net/ipv4/icmp.c                                    |   65 +-
 net/ipv4/inet_connection_sock.c                    |  202 +-
 net/ipv4/inet_diag.c                               |   12 +-
 net/ipv4/inet_hashtables.c                         |    2 +-
 net/ipv4/ip_gre.c                                  |    7 +-
 net/ipv4/ip_output.c                               |   32 +-
 net/ipv4/ipcomp.c                                  |    1 -
 net/ipv4/ipip.c                                    |    2 +
 net/ipv4/ipmr.c                                    |    5 +-
 net/ipv4/netfilter/nft_reject_ipv4.c               |    2 +-
 net/ipv4/ping.c                                    |    2 +-
 net/ipv4/proc.c                                    |    2 +
 net/ipv4/protocol.c                                |    6 -
 net/ipv4/raw.c                                     |    4 +-
 net/ipv4/route.c                                   |  130 +-
 net/ipv4/sysctl_net_ipv4.c                         |   40 +-
 net/ipv4/tcp.c                                     |   14 +-
 net/ipv4/tcp_bpf.c                                 |   31 +-
 net/ipv4/tcp_fastopen.c                            |    2 +-
 net/ipv4/tcp_input.c                               |   48 +-
 net/ipv4/tcp_ipv4.c                                |   27 +-
 net/ipv4/tcp_minisocks.c                           |    7 +-
 net/ipv4/tcp_timer.c                               |    6 +-
 net/ipv4/tcp_yeah.c                                |    2 +-
 net/ipv4/tunnel4.c                                 |    3 -
 net/ipv4/udp.c                                     |    6 +-
 net/ipv4/udp_bpf.c                                 |   53 +-
 net/ipv4/udplite.c                                 |    1 -
 net/ipv4/xfrm4_protocol.c                          |    3 -
 net/ipv4/xfrm4_tunnel.c                            |    1 -
 net/ipv6/addrconf.c                                |    8 +-
 net/ipv6/ah6.c                                     |    2 -
 net/ipv6/esp6.c                                    |    4 +-
 net/ipv6/esp6_offload.c                            |    1 -
 net/ipv6/exthdrs.c                                 |   31 +-
 net/ipv6/fib6_rules.c                              |    2 +-
 net/ipv6/icmp.c                                    |   21 +-
 net/ipv6/ip6_fib.c                                 |    9 +-
 net/ipv6/ip6_output.c                              |   40 +-
 net/ipv6/ip6_tunnel.c                              |    5 +-
 net/ipv6/ipcomp6.c                                 |    2 -
 net/ipv6/mcast.c                                   |   25 +-
 net/ipv6/mip6.c                                    |   99 -
 net/ipv6/netfilter/ip6_tables.c                    |    2 +-
 net/ipv6/netfilter/nft_reject_ipv6.c               |    2 +-
 net/ipv6/output_core.c                             |   28 +-
 net/ipv6/raw.c                                     |    2 +-
 net/ipv6/route.c                                   |  131 +-
 net/ipv6/seg6_local.c                              |   94 +-
 net/ipv6/sit.c                                     |    6 +-
 net/ipv6/sysctl_net_ipv6.c                         |   31 +-
 net/ipv6/tcp_ipv6.c                                |   20 +-
 net/ipv6/udp.c                                     |    2 +-
 net/ipv6/xfrm6_output.c                            |    7 -
 net/ipv6/xfrm6_tunnel.c                            |    1 -
 net/iucv/af_iucv.c                                 |   27 +-
 net/kcm/kcmsock.c                                  |    2 +-
 net/key/af_key.c                                   |    6 +-
 net/l2tp/l2tp_ip.c                                 |    3 +-
 net/l2tp/l2tp_ppp.c                                |    2 +-
 net/lapb/lapb_iface.c                              |    4 +-
 net/mac80211/cfg.c                                 |   45 +-
 net/mac80211/chan.c                                |  108 +-
 net/mac80211/debugfs.c                             |   70 +-
 net/mac80211/debugfs_netdev.c                      |   33 +-
 net/mac80211/debugfs_sta.c                         |   24 +-
 net/mac80211/driver-ops.h                          |   26 +-
 net/mac80211/he.c                                  |    8 +-
 net/mac80211/ht.c                                  |   18 +-
 net/mac80211/ieee80211_i.h                         |  194 +-
 net/mac80211/iface.c                               |  234 +-
 net/mac80211/led.c                                 |   12 +-
 net/mac80211/main.c                                |   32 +-
 net/mac80211/mesh.h                                |    2 +-
 net/mac80211/mesh_hwmp.c                           |    2 +-
 net/mac80211/mesh_pathtbl.c                        |    2 +-
 net/mac80211/mesh_plink.c                          |    2 +-
 net/mac80211/mlme.c                                |  248 +-
 net/mac80211/rate.c                                |   13 +-
 net/mac80211/rc80211_minstrel_ht.c                 |   34 +-
 net/mac80211/rx.c                                  |   54 +-
 net/mac80211/sta_info.c                            |   83 +-
 net/mac80211/sta_info.h                            |   11 +-
 net/mac80211/status.c                              |   26 +-
 net/mac80211/tdls.c                                |   28 +-
 net/mac80211/trace.h                               |   33 +-
 net/mac80211/tx.c                                  |  466 +-
 net/mac80211/util.c                                |   35 +-
 net/mptcp/ctrl.c                                   |   68 +-
 net/mptcp/mib.c                                    |    2 +
 net/mptcp/mib.h                                    |    2 +
 net/mptcp/mptcp_diag.c                             |    1 +
 net/mptcp/options.c                                |  196 +-
 net/mptcp/pm.c                                     |    1 +
 net/mptcp/pm_netlink.c                             |   28 +-
 net/mptcp/protocol.c                               |  231 +-
 net/mptcp/protocol.h                               |   50 +-
 net/mptcp/sockopt.c                                |  149 +-
 net/mptcp/subflow.c                                |  184 +-
 net/mptcp/token.c                                  |    9 +-
 net/ncsi/internal.h                                |    4 +-
 net/ncsi/ncsi-manage.c                             |    2 +-
 net/netfilter/Kconfig                              |   12 +-
 net/netfilter/Makefile                             |    3 +-
 net/netfilter/ipset/ip_set_core.c                  |   50 +-
 net/netfilter/ipvs/Kconfig                         |    2 +-
 net/netfilter/nf_conntrack_core.c                  |   22 +-
 net/netfilter/nf_conntrack_ecache.c                |    8 +-
 net/netfilter/nf_conntrack_expect.c                |   12 +-
 net/netfilter/nf_conntrack_h323_main.c             |    2 +-
 net/netfilter/nf_conntrack_helper.c                |    6 +-
 net/netfilter/nf_conntrack_netlink.c               |   88 +-
 net/netfilter/nf_conntrack_proto.c                 |   22 +-
 net/netfilter/nf_conntrack_proto_dccp.c            |   14 +-
 net/netfilter/nf_conntrack_proto_icmp.c            |    7 +-
 net/netfilter/nf_conntrack_proto_icmpv6.c          |    3 +-
 net/netfilter/nf_conntrack_proto_sctp.c            |    2 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |   28 +-
 net/netfilter/nf_conntrack_proto_udp.c             |   11 +-
 net/netfilter/nf_conntrack_standalone.c            |   54 +-
 net/netfilter/nf_flow_table_core.c                 |   47 +-
 net/netfilter/nf_flow_table_offload.c              |    4 +-
 net/netfilter/nf_tables_api.c                      |  267 +-
 net/netfilter/nf_tables_core.c                     |    3 +-
 net/netfilter/nf_tables_offload.c                  |   34 +-
 net/netfilter/nf_tables_trace.c                    |    6 +-
 net/netfilter/nfnetlink.c                          |    3 +
 net/netfilter/nfnetlink_acct.c                     |    9 +-
 net/netfilter/nfnetlink_cthelper.c                 |   10 +-
 net/netfilter/nfnetlink_cttimeout.c                |   34 +-
 net/netfilter/nfnetlink_hook.c                     |  377 +
 net/netfilter/nfnetlink_log.c                      |    5 +-
 net/netfilter/nfnetlink_queue.c                    |    9 +-
 net/netfilter/nft_chain_filter.c                   |   26 +-
 net/netfilter/nft_chain_nat.c                      |    4 +-
 net/netfilter/nft_chain_route.c                    |    4 +-
 net/netfilter/nft_compat.c                         |   45 +-
 net/netfilter/nft_exthdr.c                         |   67 +-
 net/netfilter/nft_flow_offload.c                   |    2 +-
 net/netfilter/nft_last.c                           |   87 +
 net/netfilter/nft_lookup.c                         |   35 +-
 net/netfilter/nft_objref.c                         |    4 +-
 net/netfilter/nft_osf.c                            |    5 +
 net/netfilter/nft_payload.c                        |   10 +-
 net/netfilter/nft_reject_inet.c                    |    4 +-
 net/netfilter/nft_set_bitmap.c                     |    5 +-
 net/netfilter/nft_set_hash.c                       |   17 +-
 net/netfilter/nft_set_pipapo.h                     |    2 -
 net/netfilter/nft_set_pipapo_avx2.c                |   12 +-
 net/netfilter/nft_set_pipapo_avx2.h                |    2 -
 net/netfilter/nft_set_rbtree.c                     |    5 +-
 net/netfilter/nft_synproxy.c                       |    4 +-
 net/netfilter/nft_tproxy.c                         |   13 +-
 net/netfilter/xt_AUDIT.c                           |    2 +-
 net/netfilter/xt_CT.c                              |    1 -
 net/netfilter/xt_limit.c                           |   46 +-
 net/netlabel/netlabel_calipso.c                    |    4 +-
 net/netlabel/netlabel_cipso_v4.c                   |    4 +-
 net/netlabel/netlabel_domainhash.c                 |    2 +-
 net/netlabel/netlabel_kapi.c                       |    2 +-
 net/netlabel/netlabel_mgmt.c                       |   27 +-
 net/netlabel/netlabel_unlabeled.c                  |   10 +-
 net/netlabel/netlabel_user.h                       |    4 +-
 net/netlink/af_netlink.c                           |    8 +-
 net/nfc/hci/command.c                              |    2 +-
 net/nfc/hci/core.c                                 |    2 +-
 net/nfc/hci/llc_shdlc.c                            |    2 +-
 net/nfc/nci/hci.c                                  |    2 -
 net/nfc/rawsock.c                                  |    2 +-
 net/openvswitch/Makefile                           |    3 +
 net/openvswitch/actions.c                          |    4 +
 net/openvswitch/conntrack.c                        |   11 +-
 net/openvswitch/datapath.c                         |    4 +
 net/openvswitch/openvswitch_trace.c                |   10 +
 net/openvswitch/openvswitch_trace.h                |  158 +
 net/packet/af_packet.c                             |   11 +-
 net/qrtr/ns.c                                      |    4 +-
 net/qrtr/qrtr.c                                    |    2 +-
 net/rds/ib_ring.c                                  |    2 +-
 net/rds/tcp_recv.c                                 |    2 +-
 net/rxrpc/local_event.c                            |    2 +-
 net/sched/act_api.c                                |    3 +-
 net/sched/act_bpf.c                                |    2 -
 net/sched/act_vlan.c                               |   11 +-
 net/sched/cls_api.c                                |    2 +-
 net/sched/cls_bpf.c                                |    3 -
 net/sched/cls_rsvp.h                               |    2 +-
 net/sched/cls_tcindex.c                            |    2 +-
 net/sched/ematch.c                                 |    2 +-
 net/sched/sch_generic.c                            |   41 +-
 net/sched/sch_gred.c                               |    2 +-
 net/sched/sch_htb.c                                |   39 +-
 net/sched/sch_qfq.c                                |    8 +-
 net/sched/sch_taprio.c                             |   88 +-
 net/sctp/associola.c                               |    6 +
 net/sctp/bind_addr.c                               |   19 +-
 net/sctp/debug.c                                   |    1 +
 net/sctp/input.c                                   |  143 +-
 net/sctp/ipv6.c                                    |  121 +-
 net/sctp/output.c                                  |   33 +-
 net/sctp/outqueue.c                                |   13 +-
 net/sctp/protocol.c                                |   29 +-
 net/sctp/sm_make_chunk.c                           |   73 +-
 net/sctp/sm_sideeffect.c                           |   37 +
 net/sctp/sm_statefuns.c                            |   70 +-
 net/sctp/sm_statetable.c                           |   43 +
 net/sctp/socket.c                                  |  123 +
 net/sctp/sysctl.c                                  |   35 +
 net/sctp/transport.c                               |  150 +-
 net/smc/Makefile                                   |    2 +-
 net/smc/af_smc.c                                   |  104 +-
 net/smc/smc_core.c                                 |   28 +-
 net/smc/smc_ism.c                                  |    1 -
 net/smc/smc_netlink.c                              |   11 +
 net/smc/smc_netlink.h                              |    2 +-
 net/smc/smc_rx.c                                   |    8 +
 net/smc/smc_stats.c                                |  413 +
 net/smc/smc_stats.h                                |  266 +
 net/smc/smc_tx.c                                   |   23 +-
 net/socket.c                                       |   52 +-
 net/strparser/strparser.c                          |    2 +-
 net/switchdev/switchdev.c                          |   25 +-
 net/tipc/bcast.c                                   |    2 +-
 net/tipc/link.c                                    |    6 +-
 net/tipc/msg.c                                     |   27 +-
 net/tipc/msg.h                                     |    3 +-
 net/tipc/name_table.c                              |    6 +-
 net/tipc/name_table.h                              |    4 +-
 net/tipc/node.c                                    |    2 +-
 net/tipc/socket.c                                  |  158 +-
 net/tipc/subscr.c                                  |    2 +-
 net/tls/tls_device.c                               |    2 +-
 net/tls/tls_sw.c                                   |    5 +-
 net/unix/af_unix.c                                 |  192 +-
 net/vmw_vsock/af_vsock.c                           |  470 +-
 net/vmw_vsock/virtio_transport.c                   |   30 +-
 net/vmw_vsock/virtio_transport_common.c            |  178 +-
 net/vmw_vsock/vmci_transport.c                     |    6 +-
 net/vmw_vsock/vsock_loopback.c                     |   12 +
 net/wireless/chan.c                                |   43 +-
 net/wireless/core.c                                |   50 +-
 net/wireless/core.h                                |    3 +-
 net/wireless/nl80211.c                             |   22 +-
 net/wireless/pmsr.c                                |   12 +
 net/wireless/rdev-ops.h                            |   12 +-
 net/wireless/reg.c                                 |    5 +-
 net/wireless/scan.c                                |   22 +-
 net/wireless/trace.h                               |   36 +-
 net/wireless/wext-compat.c                         |    8 +-
 net/wireless/wext-spy.c                            |   14 +-
 net/x25/af_x25.c                                   |    2 +-
 net/x25/x25_forward.c                              |    8 +-
 net/x25/x25_link.c                                 |    5 +-
 net/x25/x25_route.c                                |   15 +-
 net/xdp/xdp_umem.c                                 |    7 +-
 net/xdp/xsk.c                                      |    6 +-
 net/xdp/xsk.h                                      |    4 +-
 net/xdp/xsk_queue.h                                |   11 +-
 net/xdp/xskmap.c                                   |   32 +-
 net/xfrm/xfrm_device.c                             |    1 +
 net/xfrm/xfrm_hash.h                               |    7 +
 net/xfrm/xfrm_input.c                              |    6 +-
 net/xfrm/xfrm_output.c                             |  131 +-
 net/xfrm/xfrm_policy.c                             |   23 +-
 net/xfrm/xfrm_replay.c                             |  171 +-
 net/xfrm/xfrm_state.c                              |   81 +-
 net/xfrm/xfrm_user.c                               |   28 +-
 samples/bpf/Makefile                               |    3 +
 samples/bpf/ibumad_kern.c                          |    2 +-
 samples/bpf/ibumad_user.c                          |    2 +-
 samples/bpf/task_fd_query_user.c                   |    2 +-
 samples/bpf/xdp_fwd_user.c                         |    2 +
 samples/bpf/xdp_redirect_map_multi_kern.c          |   88 +
 samples/bpf/xdp_redirect_map_multi_user.c          |  302 +
 samples/bpf/xdp_redirect_user.c                    |    4 +-
 samples/bpf/xdp_sample_pkts_user.c                 |    3 +-
 samples/pktgen/parameters.sh                       |    7 +-
 samples/pktgen/pktgen_sample01_simple.sh           |    2 +
 samples/pktgen/pktgen_sample02_multiqueue.sh       |    2 +
 .../pktgen/pktgen_sample03_burst_single_flow.sh    |    2 +
 samples/pktgen/pktgen_sample04_many_flows.sh       |    2 +
 samples/pktgen/pktgen_sample05_flow_per_thread.sh  |    2 +
 ...tgen_sample06_numa_awared_queue_irq_affinity.sh |    2 +
 tools/bpf/bpftool/Makefile                         |    5 +-
 tools/bpf/bpftool/gen.c                            |  421 +-
 tools/bpf/bpftool/main.c                           |   11 +-
 tools/bpf/bpftool/main.h                           |    1 +
 tools/bpf/bpftool/prog.c                           |  107 +-
 tools/bpf/bpftool/xlated_dumper.c                  |    3 +
 tools/bpf/resolve_btfids/main.c                    |    3 +
 tools/include/uapi/linux/bpf.h                     |   82 +-
 tools/lib/bpf/Build                                |    2 +-
 tools/lib/bpf/Makefile                             |   18 +-
 tools/lib/bpf/bpf.c                                |  179 +-
 tools/lib/bpf/bpf.h                                |    2 +
 tools/lib/bpf/bpf_gen_internal.h                   |   41 +
 tools/lib/bpf/bpf_helpers.h                        |   66 +
 tools/lib/bpf/bpf_prog_linfo.c                     |   18 +-
 tools/lib/bpf/bpf_tracing.h                        |  108 +-
 tools/lib/bpf/btf.c                                |  302 +-
 tools/lib/bpf/btf_dump.c                           |   14 +-
 tools/lib/bpf/gen_loader.c                         |  729 ++
 tools/lib/bpf/libbpf.c                             |  962 ++-
 tools/lib/bpf/libbpf.h                             |   68 +-
 tools/lib/bpf/libbpf.map                           |   13 +
 tools/lib/bpf/libbpf_errno.c                       |    7 +-
 tools/lib/bpf/libbpf_internal.h                    |   61 +
 tools/lib/bpf/libbpf_legacy.h                      |   59 +
 tools/lib/bpf/linker.c                             |   41 +-
 tools/lib/bpf/netlink.c                            |  572 +-
 tools/lib/bpf/nlattr.c                             |    2 +-
 tools/lib/bpf/nlattr.h                             |   60 +-
 tools/lib/bpf/ringbuf.c                            |   26 +-
 tools/lib/bpf/skel_internal.h                      |  123 +
 tools/testing/selftests/bpf/.gitignore             |    4 +
 tools/testing/selftests/bpf/Makefile               |   19 +-
 tools/testing/selftests/bpf/Makefile.docs          |    3 +-
 tools/testing/selftests/bpf/README.rst             |   19 +
 tools/testing/selftests/bpf/bench.c                |    1 +
 tools/testing/selftests/bpf/benchs/bench_rename.c  |    2 +-
 .../testing/selftests/bpf/benchs/bench_ringbufs.c  |    6 +-
 tools/testing/selftests/bpf/benchs/bench_trigger.c |    2 +-
 tools/testing/selftests/bpf/prog_tests/atomics.c   |   72 +-
 .../selftests/bpf/prog_tests/attach_probe.c        |   12 +-
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |   31 +-
 .../testing/selftests/bpf/prog_tests/bpf_tcp_ca.c  |    8 +-
 tools/testing/selftests/bpf/prog_tests/btf.c       |   93 +-
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  |    8 +-
 tools/testing/selftests/bpf/prog_tests/btf_write.c |    4 +-
 .../selftests/bpf/prog_tests/cg_storage_multi.c    |   84 +-
 .../selftests/bpf/prog_tests/cgroup_attach_multi.c |    2 +-
 .../testing/selftests/bpf/prog_tests/cgroup_link.c |   14 +-
 .../bpf/prog_tests/cgroup_skb_sk_lookup.c          |    2 +-
 tools/testing/selftests/bpf/prog_tests/check_mtu.c |    2 +-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |   15 +-
 .../selftests/bpf/prog_tests/fentry_fexit.c        |    6 +-
 .../testing/selftests/bpf/prog_tests/fentry_test.c |   10 +-
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |   25 +-
 .../testing/selftests/bpf/prog_tests/fexit_sleep.c |    6 +-
 .../testing/selftests/bpf/prog_tests/fexit_test.c  |   10 +-
 .../selftests/bpf/prog_tests/flow_dissector.c      |    2 +-
 .../bpf/prog_tests/flow_dissector_reattach.c       |   10 +-
 .../selftests/bpf/prog_tests/get_stack_raw_tp.c    |   10 +-
 .../bpf/prog_tests/get_stackid_cannot_attach.c     |    9 +-
 tools/testing/selftests/bpf/prog_tests/hashmap.c   |    9 +-
 tools/testing/selftests/bpf/prog_tests/kfree_skb.c |   19 +-
 .../testing/selftests/bpf/prog_tests/kfunc_call.c  |    6 +-
 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c |    3 +-
 .../selftests/bpf/prog_tests/ksyms_module.c        |    2 +-
 .../selftests/bpf/prog_tests/link_pinning.c        |    7 +-
 .../selftests/bpf/prog_tests/lookup_and_delete.c   |  288 +
 .../selftests/bpf/prog_tests/migrate_reuseport.c   |  559 ++
 tools/testing/selftests/bpf/prog_tests/obj_name.c  |    8 +-
 .../selftests/bpf/prog_tests/perf_branches.c       |    4 +-
 .../testing/selftests/bpf/prog_tests/perf_buffer.c |    2 +-
 .../selftests/bpf/prog_tests/perf_event_stackmap.c |    3 +-
 .../testing/selftests/bpf/prog_tests/probe_user.c  |    7 +-
 .../selftests/bpf/prog_tests/prog_run_xattr.c      |    4 +-
 .../selftests/bpf/prog_tests/raw_tp_test_run.c     |    4 +-
 .../testing/selftests/bpf/prog_tests/rdonly_maps.c |    7 +-
 .../selftests/bpf/prog_tests/reference_tracking.c  |    2 +-
 .../selftests/bpf/prog_tests/resolve_btfids.c      |    2 +-
 tools/testing/selftests/bpf/prog_tests/ringbuf.c   |   10 +-
 .../selftests/bpf/prog_tests/ringbuf_multi.c       |    2 +-
 .../selftests/bpf/prog_tests/select_reuseport.c    |   53 +-
 .../testing/selftests/bpf/prog_tests/send_signal.c |    5 +-
 tools/testing/selftests/bpf/prog_tests/sk_lookup.c |    2 +-
 tools/testing/selftests/bpf/prog_tests/skeleton.c  |    6 +-
 .../testing/selftests/bpf/prog_tests/sock_fields.c |   14 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c       |    8 +-
 .../selftests/bpf/prog_tests/sockmap_ktls.c        |    2 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c      |   17 +-
 .../bpf/prog_tests/stacktrace_build_id_nmi.c       |    3 +-
 .../selftests/bpf/prog_tests/stacktrace_map.c      |    2 +-
 .../bpf/prog_tests/stacktrace_map_raw_tp.c         |    5 +-
 .../selftests/bpf/prog_tests/static_linked.c       |    9 +-
 tools/testing/selftests/bpf/prog_tests/syscall.c   |   55 +
 tools/testing/selftests/bpf/prog_tests/tc_bpf.c    |  395 +
 .../selftests/bpf/prog_tests/tcp_hdr_options.c     |   15 +-
 .../selftests/bpf/prog_tests/test_overhead.c       |   12 +-
 .../selftests/bpf/prog_tests/trace_printk.c        |    5 +-
 .../selftests/bpf/prog_tests/trampoline_count.c    |   14 +-
 tools/testing/selftests/bpf/prog_tests/udp_limit.c |    7 +-
 .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |    2 +-
 tools/testing/selftests/bpf/prog_tests/xdp_link.c  |    8 +-
 .../selftests/bpf/progs/bpf_iter_bpf_hash_map.c    |    1 -
 .../testing/selftests/bpf/progs/bpf_iter_bpf_map.c |    1 -
 .../selftests/bpf/progs/bpf_iter_ipv6_route.c      |    1 -
 .../testing/selftests/bpf/progs/bpf_iter_netlink.c |    1 -
 tools/testing/selftests/bpf/progs/bpf_iter_task.c  |    1 -
 .../selftests/bpf/progs/bpf_iter_task_btf.c        |    1 -
 .../selftests/bpf/progs/bpf_iter_task_file.c       |    1 -
 .../selftests/bpf/progs/bpf_iter_task_stack.c      |    1 -
 .../selftests/bpf/progs/bpf_iter_task_vma.c        |    1 -
 tools/testing/selftests/bpf/progs/bpf_iter_tcp4.c  |    1 -
 tools/testing/selftests/bpf/progs/bpf_iter_tcp6.c  |    1 -
 .../selftests/bpf/progs/bpf_iter_test_kern4.c      |    4 +-
 tools/testing/selftests/bpf/progs/bpf_iter_udp4.c  |    1 -
 tools/testing/selftests/bpf/progs/bpf_iter_udp6.c  |    1 -
 tools/testing/selftests/bpf/progs/kfree_skb.c      |    4 +-
 tools/testing/selftests/bpf/progs/linked_maps1.c   |    2 +-
 tools/testing/selftests/bpf/progs/syscall.c        |  121 +
 tools/testing/selftests/bpf/progs/tailcall3.c      |    2 +-
 tools/testing/selftests/bpf/progs/tailcall4.c      |    2 +-
 tools/testing/selftests/bpf/progs/tailcall5.c      |    2 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf2.c        |    2 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf4.c        |    2 +-
 tools/testing/selftests/bpf/progs/test_check_mtu.c |    4 +-
 .../selftests/bpf/progs/test_cls_redirect.c        |    4 +-
 .../selftests/bpf/progs/test_global_func_args.c    |    2 +-
 .../selftests/bpf/progs/test_lookup_and_delete.c   |   26 +
 .../selftests/bpf/progs/test_migrate_reuseport.c   |  135 +
 .../testing/selftests/bpf/progs/test_rdonly_maps.c |    6 +-
 tools/testing/selftests/bpf/progs/test_ringbuf.c   |    4 +-
 tools/testing/selftests/bpf/progs/test_skeleton.c  |    4 +-
 tools/testing/selftests/bpf/progs/test_snprintf.c  |    1 -
 .../selftests/bpf/progs/test_snprintf_single.c     |    2 +-
 .../selftests/bpf/progs/test_sockmap_listen.c      |    4 +-
 .../selftests/bpf/progs/test_static_linked1.c      |   10 +-
 .../selftests/bpf/progs/test_static_linked2.c      |   10 +-
 tools/testing/selftests/bpf/progs/test_subprogs.c  |   13 +
 tools/testing/selftests/bpf/progs/test_tc_bpf.c    |   12 +
 tools/testing/selftests/bpf/progs/trace_printk.c   |    6 +-
 .../selftests/bpf/progs/xdp_redirect_multi_kern.c  |   94 +
 tools/testing/selftests/bpf/test_doc_build.sh      |    1 +
 tools/testing/selftests/bpf/test_lru_map.c         |    8 +
 tools/testing/selftests/bpf/test_maps.c            |  185 +-
 tools/testing/selftests/bpf/test_progs.c           |    3 +
 tools/testing/selftests/bpf/test_progs.h           |    9 +-
 tools/testing/selftests/bpf/test_tcpnotify_user.c  |    7 +-
 .../selftests/bpf/test_xdp_redirect_multi.sh       |  204 +
 tools/testing/selftests/bpf/xdp_redirect_multi.c   |  226 +
 .../drivers/net/mlxsw/devlink_trap_l3_drops.sh     |    3 +
 .../net/mlxsw/devlink_trap_l3_exceptions.sh        |    3 +
 .../selftests/drivers/net/mlxsw/port_scale.sh      |    4 +-
 .../selftests/drivers/net/mlxsw/qos_dscp_bridge.sh |    2 +
 .../selftests/drivers/net/mlxsw/qos_headroom.sh    |   69 +-
 .../testing/selftests/drivers/net/mlxsw/qos_lib.sh |   14 -
 .../testing/selftests/drivers/net/mlxsw/qos_pfc.sh |   24 +-
 .../selftests/drivers/net/mlxsw/router_scale.sh    |    2 +-
 .../selftests/drivers/net/mlxsw/tc_sample.sh       |   12 +-
 .../selftests/drivers/net/netdevsim/devlink.sh     |  167 +-
 .../drivers/net/netdevsim/devlink_trap.sh          |   14 +-
 .../testing/selftests/drivers/net/netdevsim/fib.sh |    6 +-
 .../selftests/drivers/net/netdevsim/nexthop.sh     |    4 +-
 .../selftests/drivers/net/netdevsim/psample.sh     |    4 +-
 tools/testing/selftests/net/.gitignore             |    1 +
 tools/testing/selftests/net/Makefile               |    2 +-
 tools/testing/selftests/net/config                 |    1 +
 tools/testing/selftests/net/devlink_port_split.py  |    8 +-
 tools/testing/selftests/net/fib_nexthops.sh        |   12 +
 .../net/forwarding/custom_multipath_hash.sh        |  364 +
 .../selftests/net/forwarding/devlink_lib.sh        |   32 +
 .../net/forwarding/gre_custom_multipath_hash.sh    |  456 +
 .../net/forwarding/ip6gre_custom_multipath_hash.sh |  458 ++
 .../selftests/net/forwarding/pedit_dsfield.sh      |    2 +
 .../selftests/net/forwarding/pedit_l4port.sh       |    2 +
 .../selftests/net/forwarding/skbedit_priority.sh   |    2 +
 tools/testing/selftests/net/icmp_redirect.sh       |    8 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |  125 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |   65 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  180 +-
 tools/testing/selftests/net/mptcp/mptcp_sockopt.sh |    4 +-
 tools/testing/selftests/net/mptcp/simult_flows.sh  |    3 +-
 tools/testing/selftests/net/so_netns_cookie.c      |   61 +
 .../selftests/net/srv6_end_dt46_l3vpn_test.sh      |  573 ++
 tools/testing/selftests/net/tls.c                  |   87 +-
 tools/testing/selftests/net/unicast_extensions.sh  |   17 +-
 .../selftests/tc-testing/plugin-lib/scapyPlugin.py |   42 +-
 .../selftests/tc-testing/tc-tests/actions/ct.json  |   45 +
 .../tc-testing/tc-tests/actions/vlan.json          |   28 +-
 tools/testing/vsock/util.c                         |   32 +-
 tools/testing/vsock/util.h                         |    3 +
 tools/testing/vsock/vsock_test.c                   |  116 +
 1908 files changed, 109790 insertions(+), 28910 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-platform-soc-ipa
 create mode 100644 Documentation/bpf/libbpf/libbpf.rst
 create mode 100644 Documentation/bpf/libbpf/libbpf_api.rst
 create mode 100644 Documentation/bpf/libbpf/libbpf_build.rst
 rename tools/lib/bpf/README.rst => Documentation/bpf/libbpf/libbpf_naming_convention.rst (90%)
 create mode 100644 Documentation/bpf/llvm_reloc.rst
 delete mode 100644 Documentation/devicetree/bindings/net/brcm,iproc-mdio.txt
 create mode 100644 Documentation/devicetree/bindings/net/brcm,iproc-mdio.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/rcar_can.txt
 delete mode 100644 Documentation/devicetree/bindings/net/can/rcar_canfd.txt
 create mode 100644 Documentation/devicetree/bindings/net/can/renesas,rcar-can.yaml
 create mode 100644 Documentation/devicetree/bindings/net/can/renesas,rcar-canfd.yaml
 create mode 100644 Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/sja1105.txt
 create mode 100644 Documentation/devicetree/bindings/net/ingenic,mac.yaml
 create mode 100644 Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
 create mode 100644 Documentation/devicetree/bindings/net/qualcomm-bluetooth.yaml
 create mode 100644 Documentation/devicetree/bindings/net/realtek,rtl82xx.yaml
 create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
 create mode 100644 Documentation/networking/device_drivers/wwan/index.rst
 create mode 100644 Documentation/networking/device_drivers/wwan/iosm.rst
 create mode 100644 Documentation/networking/devlink/prestera.rst
 create mode 100644 drivers/net/can/c_can/c_can_ethtool.c
 rename drivers/net/can/c_can/{c_can.c => c_can_main.c} (99%)
 create mode 100644 drivers/net/dsa/sja1105/sja1105_mdio.c
 delete mode 100644 drivers/net/dsa/sja1105/sja1105_sgmii.h
 create mode 100644 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
 create mode 100644 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
 create mode 100644 drivers/net/ethernet/google/gve/gve_desc_dqo.h
 create mode 100644 drivers/net/ethernet/google/gve/gve_dqo.h
 create mode 100644 drivers/net/ethernet/google/gve/gve_rx_dqo.c
 create mode 100644 drivers/net/ethernet/google/gve/gve_tx_dqo.c
 create mode 100644 drivers/net/ethernet/google/gve/gve_utils.c
 create mode 100644 drivers/net/ethernet/google/gve/gve_utils.h
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.h
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
 create mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_idc_int.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_ptp.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_ptp.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_ptp_hw.c
 create mode 100644 drivers/net/ethernet/intel/ice/ice_ptp_hw.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_sbq_cmd.h
 create mode 100644 drivers/net/ethernet/intel/ice/ice_trace.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_acl.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_acl.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_flow.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_flow.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_flower.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_flower.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_span.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_span.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bridge.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/bridge_priv.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/diag/bridge_tracepoint.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/sf.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/mlx5_irq.h
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/Kconfig
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/Makefile
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige.h
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_ethtool.c
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_gpio.c
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_intr.c
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_regs.h
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c
 create mode 100644 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_tx.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlxsw/ib.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlxsw/switchib.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlxsw/switchx2.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/Kconfig
 create mode 100644 drivers/net/ethernet/microchip/sparx5/Makefile
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_calendar.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_main.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_main.h
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_port.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_port.h
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/flower/conntrack.c
 create mode 100644 drivers/net/ethernet/netronome/nfp/flower/conntrack.h
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp.c
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp.h
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.c
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.h
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_nvmetcp_ip_services.c
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-loongson.c
 create mode 100644 drivers/net/ipa/ipa_data-v3.1.c
 create mode 100644 drivers/net/ipa/ipa_sysfs.c
 create mode 100644 drivers/net/ipa/ipa_sysfs.h
 create mode 100644 drivers/net/mdio/acpi_mdio.c
 create mode 100644 drivers/net/mdio/fwnode_mdio.c
 create mode 100644 drivers/net/pcs/pcs-xpcs-nxp.c
 create mode 100644 drivers/net/pcs/pcs-xpcs.h
 create mode 100644 drivers/net/phy/mediatek-ge.c
 create mode 100644 drivers/net/phy/motorcomm.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/dump.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/uefi.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/uefi.h
 create mode 100644 drivers/net/wwan/iosm/Makefile
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_imem.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_imem.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_irq.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_irq.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_mmio.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_mmio.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_mux.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_mux.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_mux_codec.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_mux_codec.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_pcie.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_pcie.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_pm.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_pm.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_port.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_port.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_protocol.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_protocol.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_protocol_ops.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_task_queue.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_task_queue.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_uevent.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_uevent.h
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_wwan.c
 create mode 100644 drivers/net/wwan/iosm/iosm_ipc_wwan.h
 create mode 100644 drivers/net/wwan/rpmsg_wwan_ctrl.c
 create mode 100644 drivers/net/wwan/wwan_hwsim.c
 create mode 100644 include/linux/acpi_mdio.h
 create mode 100644 include/linux/bpfptr.h
 create mode 100644 include/linux/fwnode_mdio.h
 create mode 100644 include/linux/net/intel/iidc.h
 create mode 100644 include/linux/once_lite.h
 create mode 100644 include/linux/qed/nvmetcp_common.h
 create mode 100644 include/linux/qed/qed_nvmetcp_if.h
 create mode 100644 include/linux/qed/qed_nvmetcp_ip_services_if.h
 create mode 100644 include/net/netns/smc.h
 create mode 100644 include/uapi/linux/netfilter/nfnetlink_hook.h
 create mode 100644 include/uapi/linux/wwan.h
 create mode 100644 net/netfilter/nfnetlink_hook.c
 create mode 100644 net/netfilter/nft_last.c
 create mode 100644 net/openvswitch/openvswitch_trace.c
 create mode 100644 net/openvswitch/openvswitch_trace.h
 create mode 100644 net/smc/smc_stats.c
 create mode 100644 net/smc/smc_stats.h
 create mode 100644 samples/bpf/xdp_redirect_map_multi_kern.c
 create mode 100644 samples/bpf/xdp_redirect_map_multi_user.c
 create mode 100644 tools/lib/bpf/bpf_gen_internal.h
 create mode 100644 tools/lib/bpf/gen_loader.c
 create mode 100644 tools/lib/bpf/libbpf_legacy.h
 create mode 100644 tools/lib/bpf/skel_internal.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/lookup_and_delete.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/syscall.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_bpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/syscall.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_lookup_and_delete.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_migrate_reuseport.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_redirect_multi.c
 create mode 100755 tools/testing/selftests/net/forwarding/custom_multipath_hash.sh
 create mode 100755 tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh
 create mode 100644 tools/testing/selftests/net/so_netns_cookie.c
 create mode 100755 tools/testing/selftests/net/srv6_end_dt46_l3vpn_test.sh
