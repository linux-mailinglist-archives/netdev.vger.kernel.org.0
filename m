Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA0E2DA887
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 08:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgLOH3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 02:29:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:54298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726356AbgLOH3m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 02:29:42 -0500
From:   Jakub Kicinski <kuba@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     torvalds@linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk, sfrench@samba.org,
        ebiederm@xmission.com, akpm@linux-foundation.org
Subject: [GIT PULL] Networking updates for 5.11
Date:   Mon, 14 Dec 2020 23:28:50 -0800
Message-Id: <20201215072850.3171650-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

Here is the networking PR for 5.11.

There are no conflicts with your tree at the time of writing, but
we know from Stephen that there are at least two conflicts and two
build issues with other trees.

Here is the list of the ones I know about, including the file where
the issue occurs and a link to Stephen's resolution (I'm not including
the resolution inline because the first one is quite long).

user-namespace
  kernel/bpf/task_iter.c
  https://lore.kernel.org/linux-next/20201126162248.7e7963fe@canb.auug.org.au/

mm
  mm/memcontrol.c
  https://lore.kernel.org/linux-next/20201204202005.3fb1304f@canb.auug.org.au/

block (build failure only)
  fs/io_uring.c
  https://lore.kernel.org/linux-next/20201207140951.4c04f26f@canb.auug.org.au/

cifs (build failure only)
  fs/cifs/cifs_swn.c
  https://lore.kernel.org/linux-next/20201214131438.7c9b2f30@canb.auug.org.au/


The following changes since commit 7f376f1917d7461e05b648983e8d2aea9d0712b2:

  Merge tag 'mtd/fixes-for-5.10-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux (2020-12-11 14:29:46 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/net-next-5.11

for you to fetch changes up to efd5a1584537698220578227e6467638307c2a0b:

  net: hns3: fix expression that is currently always true (2020-12-14 19:42:49 -0800)

----------------------------------------------------------------
Networking updates for 5.11

Core:

 - support "prefer busy polling" NAPI operation mode, where we defer softirq
   for some time expecting applications to periodically busy poll

 - AF_XDP: improve efficiency by more batching and hindering
           the adjacency cache prefetcher

 - af_packet: make packet_fanout.arr size configurable up to 64K

 - tcp: optimize TCP zero copy receive in presence of partial or unaligned
        reads making zero copy a performance win for much smaller messages

 - XDP: add bulk APIs for returning / freeing frames

 - sched: support fragmenting IP packets as they come out of conntrack

 - net: allow virtual netdevs to forward UDP L4 and fraglist GSO skbs

BPF:

 - BPF switch from crude rlimit-based to memcg-based memory accounting

 - BPF type format information for kernel modules and related tracing
   enhancements

 - BPF implement task local storage for BPF LSM

 - allow the FENTRY/FEXIT/RAW_TP tracing programs to use bpf_sk_storage

Protocols:

 - mptcp: improve multiple xmit streams support, memory accounting and
          many smaller improvements

 - TLS: support CHACHA20-POLY1305 cipher

 - seg6: add support for SRv6 End.DT4/DT6 behavior

 - sctp: Implement RFC 6951: UDP Encapsulation of SCTP

 - ppp_generic: add ability to bridge channels directly

 - bridge: Connectivity Fault Management (CFM) support as is defined in
           IEEE 802.1Q section 12.14.

Drivers:

 - mlx5: make use of the new auxiliary bus to organize the driver internals

 - mlx5: more accurate port TX timestamping support

 - mlxsw:
   - improve the efficiency of offloaded next hop updates by using
     the new nexthop object API
   - support blackhole nexthops
   - support IEEE 802.1ad (Q-in-Q) bridging

 - rtw88: major bluetooth co-existance improvements

 - iwlwifi: support new 6 GHz frequency band

 - ath11k: Fast Initial Link Setup (FILS)

 - mt7915: dual band concurrent (DBDC) support

 - net: ipa: add basic support for IPA v4.5

Refactor:

 - a few pieces of in_interrupt() cleanup work from Sebastian Andrzej Siewior

 - phy: add support for shared interrupts; get rid of multiple driver
        APIs and have the drivers write a full IRQ handler, slight growth
	of driver code should be compensated by the simpler API which
	also allows shared IRQs

 - add common code for handling netdev per-cpu counters

 - move TX packet re-allocation from Ethernet switch tag drivers to
   a central place

 - improve efficiency and rename nla_strlcpy

 - number of W=1 warning cleanups as we now catch those in a patchwork
   build bot

Old code removal:

 - wan: delete the DLCI / SDLA drivers

 - wimax: move to staging

 - wifi: remove old WDS wifi bridging support

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Abhishek Kumar (1):
      ath10k: add option for chip-id based BDF selection

Abhishek Pandit-Subedi (2):
      Bluetooth: btqca: Add valid le states quirk
      Bluetooth: Set missing suspend task bits

Ahmad Fatoum (1):
      ptp: document struct ptp_clock_request members

Ajay Singh (6):
      wilc1000: added 'ndo_set_mac_address' callback support
      wilc1000: free resource in wilc_wlan_txq_add_net_pkt() for failure path
      wilc1000: free resource in wilc_wlan_txq_add_mgmt_pkt() for failure path
      wilc1000: call complete() for failure in wilc_wlan_txq_add_cfg_pkt()
      wilc1000: added queue support for WMM
      wilc1000: changes for SPI communication stall issue found with Iperf

Alan Maguire (1):
      libbpf: bpf__find_by_name[_kind] should use btf__get_nr_types()

Aleksandr Nogikh (3):
      kernel: make kcov_common_handle consider the current context
      net: add kcov handle to skb extensions
      mac80211: add KCOV remote annotations to incoming frame processing

Alex Dewar (2):
      ath10k: sdio: remove redundant check in for loop
      ath11k: Handle errors if peer creation fails

Alex Elder (69):
      net: ipa: assign proper packet context base
      net: ipa: fix resource group field mask definition
      net: ipa: assign endpoint to a resource group
      net: ipa: distinguish between resource group types
      net: ipa: avoid going past end of resource group array
      net: ipa: avoid a bogus warning
      net: ipa: restrict special reset to IPA v3.5.1
      net: ipa: expose IPA version to the GSI layer
      net: ipa: record IPA version in GSI structure
      net: ipa: use version in gsi_channel_init()
      net: ipa: use version in gsi_channel_reset()
      net: ipa: use version in gsi_channel_program()
      net: ipa: eliminate legacy arguments
      net: ipa: refer to IPA versions, not GSI
      net: ipa: request GSI IRQ later
      net: ipa: rename gsi->event_enable_bitmap
      net: ipa: define GSI interrupt types with an enum
      net: ipa: disable all GSI interrupt types initially
      net: ipa: cache last-saved GSI IRQ enabled type
      net: ipa: only enable GSI channel control IRQs when needed
      net: ipa: only enable GSI event control IRQs when needed
      net: ipa: only enable generic command completion IRQ when needed
      net: ipa: only enable GSI IEOB IRQs when needed
      net: ipa: explicitly disallow inter-EE interrupts
      net: ipa: only enable GSI general IRQs when needed
      net: ipa: pass a value to gsi_irq_type_update()
      net: ipa: don't break build on large transaction size
      net: ipa: get rid of a useless line of code
      net: ipa: change a warning to debug
      net: ipa: drop an error message
      net: ipa: define GSI interrupt types with enums
      net: ipa: use common value for channel type and protocol
      net: ipa: move channel type values into "gsi_reg.h"
      net: ipa: move GSI error values into "gsi_reg.h"
      net: ipa: move GSI command opcode values into "gsi_reg.h"
      net: ipa: use enumerated types for GSI field values
      net: ipa: fix source packet contexts limit
      net: ipa: ignore the microcontroller log event
      net: ipa: share field mask values for IPA hash registers
      net: ipa: make filter/routing hash enable register variable
      net: ipa: support more versions for HOLB timer
      net: ipa: fix two inconsistent IPA register names
      net: ipa: use _FMASK consistently
      net: ipa: fix BCR register field definitions
      net: ipa: define enumerated types consistently
      net: ipa: fix up IPA register comments
      net: ipa: rearrange a few IPA register definitions
      net: ipa: move definition of enum ipa_irq_id
      net: ipa: a few last IPA register cleanups
      net: ipa: define clock and interconnect data
      net: ipa: populate clock and interconnect data
      net: ipa: use config data for clocking
      net: ipa: print channel/event ring number on error
      net: ipa: don't reset an ALLOCATED channel
      net: ipa: ignore CHANNEL_NOT_RUNNING errors
      net: ipa: support retries on generic GSI commands
      net: ipa: retry modem stop if busy
      net: ipa: add driver shutdown callback
      net: ipa: reverse logic on escape buffer use
      net: ipa: update IPA registers for IPA v4.5
      net: ipa: add new most-significant bits to registers
      net: ipa: add support to code for IPA v4.5
      net: ipa: update gsi registers for IPA v4.5
      net: ipa: adjust GSI register addresses
      net: ipa: update IPA aggregation registers for IPA v4.5
      net: ipa: set up IPA v4.5 Qtime configuration
      net: ipa: use Qtime for IPA v4.5 aggregation time limit
      net: ipa: use Qtime for IPA v4.5 head-of-line time limit
      net: ipa: fix build-time bug in ipa_hardware_config_qsb()

Alex Shi (1):
      nfc: refined function nci_hci_resp_received

Alexander Duyck (6):
      selftests/bpf: Move test_tcppbf_user into test_progs
      selftests/bpf: Drop python client/server in favor of threads
      selftests/bpf: Replace EXPECT_EQ with ASSERT_EQ and refactor verify_results
      selftests/bpf: Migrate tcpbpf_user.c to use BPF skeleton
      selftest/bpf: Use global variables instead of maps for test_tcpbpf_kern
      tcp: Add logic to check for SYN w/ data in tcp_simple_retransmit

Alexander Lobakin (3):
      net: add GSO UDP L4 and GSO fraglists to the list of software-backed types
      net: bonding, dummy, ifb, team: advertise NETIF_F_GSO_SOFTWARE
      net: skb_vlan_untag(): don't reset transport offset if set by GRO layer

Alexandru Ardelean (2):
      net: phy: adin: disable diag clock & disable standby mode in config_aneg
      net: phy: adin: implement cable-test support

Alexei Starovoitov (16):
      Merge branch 'bpf: safeguard hashtab locking in NMI context'
      Merge branch 'selftests/bpf: Migrate test_tcpbpf_user to be a part of test_progs'
      Merge branch 'libbpf: split BTF support'
      selftests/bpf: Fix selftest build with old libc
      Merge branch 'Integrate kernel module BTF support'
      Merge branch 'Remove unused test_ipip.sh test and add missed'
      bpf: Support for pointers beyond pkt_end.
      selftests/bpf: Add skb_pkt_end test
      selftests/bpf: Add asm tests for pkt vs pkt_end comparison.
      Merge branch 'bpf: Enable bpf_sk_storage for FENTRY/FEXIT/RAW_TP'
      Merge branch 'bpf: expose bpf_{s,g}etsockopt helpers to bind{4,6} hooks'
      Merge branch 'switch to memcg-based memory accounting'
      Merge branch 'bpftool: improve split BTF support'
      Merge branch 'libbpf: add support for privileged/unprivileged control separation'
      Merge branch 'Add support to set window_clamp from bpf setsockops'
      Merge branch 'Support BTF-powered BPF tracing programs for kernel modules'

Allen Pais (10):
      ath11k: convert tasklets to use new tasklet_setup() API
      wireless: mt7601u: convert tasklets to use new tasklet_setup() API
      net: dccp: convert tasklets to use new tasklet_setup() API
      net: ipv4: convert tasklets to use new tasklet_setup() API
      net: mac80211: convert tasklets to use new tasklet_setup() API
      net: mac802154: convert tasklets to use new tasklet_setup() API
      net: sched: convert tasklets to use new tasklet_setup() API
      net: smc: convert tasklets to use new tasklet_setup() API
      net: xfrm: convert tasklets to use new tasklet_setup() API
      wireless: mt76: convert tasklets to use new tasklet_setup() API

Aloka Dixit (1):
      ath11k: FILS discovery and unsolicited broadcast probe response support

Amit Cohen (18):
      mlxsw: reg: Add Switch Port VLAN Classification Register
      mlxsw: reg: Add et_vlan field to SPVID register
      mlxsw: spectrum: Only treat 802.1q packets as tagged packets
      mlxsw: Make EtherType configurable when pushing VLAN at ingress
      mlxsw: spectrum_switchdev: Create common functions for VLAN-aware bridge
      mlxsw: spectrum_switchdev: Add support of QinQ traffic
      mlxsw: Use one enum for all registers that contain tunnel_port field
      mlxsw: reg: Add Switch Port VLAN Stacking Register
      mlxsw: reg: Add support for tunnel port in SPVID register
      mlxsw: spectrum_switchdev: Create common function for joining VxLAN to VLAN-aware bridge
      mlxsw: Save EtherType as part of mlxsw_sp_nve_params
      mlxsw: Save EtherType as part of mlxsw_sp_nve_config
      mlxsw: spectrum: Publish mlxsw_sp_ethtype_to_sver_type()
      mlxsw: spectrum_nve_vxlan: Add support for Q-in-VNI for Spectrum-2 ASIC
      mlxsw: spectrum_switchdev: Use ops->vxlan_join() when adding VLAN to VxLAN device
      mlxsw: Veto Q-in-VNI for Spectrum-1 ASIC
      mlxsw: spectrum_switchdev: Allow joining VxLAN to 802.1ad bridge
      selftests: mlxsw: Add Q-in-VNI veto tests

Anant Thazhemadam (3):
      Bluetooth: hci_h5: close serdev device and free hu in h5_close
      Bluetooth: hci_h5: fix memory leak in h5_close
      nl80211: validate key indexes for cfg80211_registered_device

Anders Roxell (1):
      dpaa_eth: fix build errorr in dpaa_fq_init

Andra Paraschiv (5):
      vm_sockets: Add flags field in the vsock address data structure
      vm_sockets: Add VMADDR_FLAG_TO_HOST vsock flag
      vsock_addr: Check for supported flag values
      af_vsock: Set VMADDR_FLAG_TO_HOST flag on the receive path
      af_vsock: Assign the vsock transport considering the vsock address flags

Andrea Mayer (9):
      vrf: add mac header for tunneled packets when sniffer is attached
      seg6: improve management of behavior attributes
      seg6: add support for optional attributes in SRv6 behaviors
      seg6: add callbacks for customizing the creation/destruction of a behavior
      seg6: add support for the SRv6 End.DT4 behavior
      seg6: add VRF support for SRv6 End.DT6 behavior
      selftests: add selftest for the SRv6 End.DT4 behavior
      selftests: add selftest for the SRv6 End.DT6 (VRF) behavior
      vrf: handle CONFIG_IPV6 not set for vrf_add_mac_header_if_unset()

Andrei Matei (4):
      selftest/bpf: Fix link in readme
      selftest/bpf: Fix rst formatting in readme
      bpf: Fix selftest compilation on clang 11
      libbpf: Fail early when loading programs with unspecified type

Andrew Delgadillo (1):
      selftests/bpf: Drop the need for LLVM's llc

Andrew Lunn (33):
      net: tipc: Fix parameter types passed to %s formater
      net: dccp: Add __printf() markup to fix -Wsuggest-attribute=format
      net: tipc: Add __printf() markup to fix -Wsuggest-attribute=format
      net: llc: Fix kerneldoc warnings
      net: openvswitch: Fix kerneldoc warnings
      net: l3mdev: Fix kerneldoc warning
      net: netlabel: Fix kerneldoc warnings
      net: appletalk: fix kerneldoc warnings
      net: nfc: Fix kerneldoc warnings
      net: dcb: Fix kerneldoc warnings
      net: dccp: Fix most of the kerneldoc warnings
      net: ipv4: Fix some kerneldoc warnings in TCP Low Priority
      net: ipv6: rpl*: Fix strange kerneldoc warnings due to bad header
      net: ipv6: calipso: Fix kerneldoc warnings
      netfilter: nftables: Add __printf() attribute
      net: 9p: Fix kerneldoc warnings of missing parameters etc
      drivers: net: tulip: Fix set but not used with W=1
      drivers: net: davicom: Fixed unused but set variable with W=1
      drivers: net: davicom Add COMPILE_TEST support
      drivers: net: xen-netfront: Fixed W=1 set but unused warnings
      drivers: net: wan: lmc: Fix W=1 set but used variable warnings
      net: driver: hamradio: Fix potential unterminated string
      drivers: net: sky2: Fix -Wstringop-truncation with W=1
      drivers: net: xilinx_emaclite: Add missing parameter kerneldoc
      drivers: net: xilinx_emaclite: Fix -Wpointer-to-int-cast warnings with W=1
      drivers: net: xilinx_emaclite: Add COMPILE_TEST support
      drivers: net: smc91x: Fix set but unused W=1 warning
      drivers: net: smc91x: Fix missing kerneldoc reported by W=1
      drivers: net: smc911x: Work around set but unused status
      drivers: net: smc911x: Fix set but unused status because of DBG macro
      drivers: net: smc911x: Fix passing wrong number of parameters to DBG() macro
      drivers: net: smc911x: Fix cast from pointer to integer of different size
      drivers: net: smsc: Add COMPILE_TEST support

Andrii Nakryiko (47):
      libbpf: Factor out common operations in BTF writing APIs
      selftest/bpf: Relax btf_dedup test checks
      libbpf: Unify and speed up BTF string deduplication
      libbpf: Implement basic split BTF support
      selftests/bpf: Add split BTF basic test
      selftests/bpf: Add checking of raw type dump in BTF writer APIs selftests
      libbpf: Fix BTF data layout checks and allow empty BTF
      libbpf: Support BTF dedup of split BTFs
      libbpf: Accomodate DWARF/compiler bug with duplicated identical arrays
      selftests/bpf: Add split BTF dedup selftests
      tools/bpftool: Add bpftool support for split BTF
      bpf: Add in-kernel split BTF support
      bpf: Assign ID to vmlinux BTF and return extra info for BTF in GET_OBJ_INFO
      kbuild: Build kernel module BTFs if BTF is enabled and pahole supports it
      bpf: Load and verify kernel module BTFs
      tools/bpftool: Add support for in-kernel and named BTF in `btf show`
      bpf: Compile out btf_parse_module() if module BTF is not enabled
      Merge branch 'tools/bpftool: Some build fixes'
      Merge branch 'RISC-V selftest/bpf fixes'
      kbuild: Skip module BTF generation for out-of-tree external modules
      bpf: Sanitize BTF data pointer after module is loaded
      Merge branch 'bpf: remove bpf_load loader completely'
      tools/bpftool: Emit name <anon> for anonymous BTFs
      libbpf: Add base BTF accessor
      tools/bpftool: Auto-detect split BTFs in common cases
      Merge branch 'Fixes for ima selftest'
      bpf: Fix bpf_put_raw_tracepoint()'s use of __module_address()
      bpf: Keep module's btf_data_size intact after load
      libbpf: Add internal helper to load BTF data by FD
      libbpf: Refactor CO-RE relocs to not assume a single BTF object
      libbpf: Add kernel module BTF support for CO-RE relocations
      selftests/bpf: Add bpf_testmod kernel module for testing
      selftests/bpf: Add support for marking sub-tests as skipped
      selftests/bpf: Add CO-RE relocs selftest relying on kernel module BTF
      bpf: Remove hard-coded btf_vmlinux assumption from BPF verifier
      bpf: Allow to specify kernel module BTFs when attaching BPF programs
      libbpf: Factor out low-level BPF program loading helper
      libbpf: Support attachment of BPF tracing programs to kernel modules
      selftests/bpf: Add tp_btf CO-RE reloc test for modules
      selftests/bpf: Add fentry/fexit/fmod_ret selftest for kernel module
      libbpf: Use memcpy instead of strncpy to please GCC
      selftests/bpf: Fix invalid use of strncat in test_sockmap
      Merge branch 'Improve error handling of verifier tests'
      bpf: Return -ENOTSUPP when attaching to non-kernel BTF
      selftests/bpf: fix bpf_testmod.ko recompilation logic
      libbpf: Support modules in bpf_program__set_attach_target() API
      selftests/bpf: Add set_attach_target() API selftest for module target

Andy Shevchenko (1):
      net: phy: leds: Deduplicate link LED trigger registration

Anilkumar Kolli (2):
      ath11k: add 64bit check before reading msi high addr
      ath11k: fix rmmod failure if qmi sequence fails

Anmol Karn (1):
      Bluetooth: Fix null pointer dereference in hci_event_packet()

Antonio Borneo (1):
      net: phy: realtek: read actual speed on rtl8211f to detect downshift

Antonio Cardace (6):
      ethtool: add ETHTOOL_COALESCE_ALL_PARAMS define
      netdevsim: move ethtool pause params in separate struct
      netdevsim: support ethtool ring and coalesce settings
      selftests: extract common functions in ethtool-common.sh
      selftests: refactor get_netdev_name function
      selftests: add ring and coalesce selftests

Antonio Quartulli (2):
      can: rx-offload: can_rx_offload_offload_one(): avoid double unlikely() notation when using IS_ERR()
      vxlan: avoid double unlikely() notation when using IS_ERR()

Antony Antony (1):
      xfrm: redact SA secret with lockdown confidentiality

Archie Pusaka (1):
      Bluetooth: Enforce key size of 16 bytes on FIPS level

Arjun Roy (9):
      net-zerocopy: Copy straggler unaligned data for TCP Rx. zerocopy.
      net-tcp: Introduce tcp_recvmsg_locked().
      net-zerocopy: Refactor skb frag fast-forward op.
      net-zerocopy: Refactor frag-is-remappable test.
      net-zerocopy: Fast return if inq < PAGE_SIZE
      net-zerocopy: Introduce short-circuit small reads.
      net-zerocopy: Set zerocopy hint when data is copied
      net-zerocopy: Defer vm zap unless actually needed.
      tcp: correctly handle increased zerocopy args struct size

Armin Wolf (1):
      ne2k: Fix Typo in RW-Bugfix

Arnd Bergmann (8):
      wimax: fix duplicate initializer warning
      wimax: move out to staging
      ath6kl: fix enum-conversion warning
      net: hostap: fix function cast warning
      rtlwifi: fix -Wpointer-sign warning
      rtw88: remove extraneous 'const' qualifier
      ath9k: work around false-positive gcc warning
      enetc: Fix unused var build warning for CONFIG_OF

Avraham Stern (4):
      iwlwifi: mvm: add size checks for range response notification
      nl80211: always accept scan request with the duration set
      ieee80211: update reduced neighbor report TBTT info length
      mac80211: support Rx timestamp calculation for all preamble types

Aya Levin (4):
      net/mlx5: Expose IP-in-IP TX and RX capability bits
      net/mlx5e: Allow CQ outside of channel context
      net/mlx5e: Allow RQ outside of channel context
      net/mlx5e: Split between RX/TX tunnel FW support indication

Ayala Beker (1):
      cfg80211: scan PSC channels in case of scan with wildcard SSID

Balakrishna Godavarthi (1):
      Bluetooth: hci_qca: Enhance retry logic in qca_setup

Ben Greear (1):
      ath10k: Don't iterate over not-sdata-in-driver interfaces.

Bhaskar Chowdhury (1):
      drivers: net: phy: Fix spelling in comment defalut to default

Bhaumik Bhatt (2):
      net: qrtr: Unprepare MHI channels during remove
      ath11k: use MHI provided APIs to allocate and free MHI controller

Björn Töpel (15):
      selftests/bpf: Fix broken riscv build
      selftests/bpf: Avoid running unprivileged tests with alignment requirements
      selftests/bpf: Mark tests that require unaligned memory access
      net: Introduce preferred busy-polling
      net: Add SO_BUSY_POLL_BUDGET socket option
      xsk: Add support for recvmsg()
      xsk: Check need wakeup flag in sendmsg()
      xsk: Add busy-poll support for {recv,send}msg()
      xsk: Propagate napi_id to XDP socket Rx path
      samples/bpf: Use recvfrom() in xdpsock/rxdrop
      samples/bpf: Use recvfrom() in xdpsock/l2fwd
      samples/bpf: Add busy-poll support to xdpsock
      samples/bpf: Add option to set the busy-poll budget
      xsk: Validate socket state in xsk_recvmsg, prior touching socket members
      ice, xsk: Move Rx allocation out of while-loop

Bongsu Jeon (12):
      nfc: s3fwrn5: Remove the max_payload
      nfc: s3fwrn5: Fix the misspelling in a comment
      nfc: s3fwrn5: Change the error code
      dt-bindings: net: nfc: s3fwrn5: Support a UART interface
      nfc: s3fwrn5: reduce the EN_WAIT_TIME
      nfc: s3fwrn5: extract the common phy blocks
      nfc: s3fwrn5: Support a UART interface
      nfc: s3fwrn5: skip the NFC bootloader mode
      net/nfc/nci: Support NCI 2.x initial sequence
      dt-bindings: net: nfc: s3fwrn5: Change I2C interrupt trigger type
      nfc: s3fwrn5: Remove hard coded interrupt trigger type from the i2c module
      nfc: s3fwrn5: Release the nfc firmware

Brendan Jackman (3):
      tools/resolve_btfids: Fix some error messages
      bpf: Fix cold build of test_progs-no_alu32
      libbpf: Expose libbpf ring_buffer epoll_fd

Brian Norris (1):
      rtw88: wow: print key type when failing

Bruce Allan (3):
      ice: cleanup stack hog
      ice: cleanup misleading comment
      ice: silence static analysis warning

Bryan O'Donoghue (4):
      wcn36xx: Set LINK_FAIL_TX_CNT to 1000 on all wcn36xx
      wcn36xx: Enable firmware link monitoring
      wcn36xx: Enable firmware offloaded keepalive
      wcn36xx: Send NULL data packet when exiting BMPS

Cadel Watson (1):
      Bluetooth: btusb: Support 0bda:c123 Realtek 8822CE device

Cambda Zhu (1):
      net: Limit logical shift left of TCP probe0 timeout

Camelia Groza (7):
      dpaa_eth: add struct for software backpointers
      dpaa_eth: add basic XDP support
      dpaa_eth: limit the possible MTU range when XDP is enabled
      dpaa_eth: add XDP_TX support
      dpaa_eth: add XDP_REDIRECT support
      dpaa_eth: rename current skb A050385 erratum workaround
      dpaa_eth: implement the A050385 erratum workaround for XDP

Carl Huang (16):
      ath11k: fix ZERO address in probe request
      nl80211: add common API to configure SAR power limitations
      mac80211: add ieee80211_set_sar_specs
      ath11k: put hw to DBS using WMI_PDEV_SET_HW_MODE_CMDID
      ath11k: pci: fix hot reset stability issues
      ath11k: pci: fix L1ss clock unstable problem
      ath11k: pci: disable VDD4BLOW
      ath11k: mhi: hook suspend and resume
      ath11k: hif: implement suspend and resume functions
      ath11k: pci: read select_window register to ensure write is finished
      ath11k: htc: implement suspend handling
      ath11k: dp: stop rx pktlog before suspend
      ath11k: set credit_update flag for flow controlled ep only
      ath11k: implement WoW enable and wakeup commands
      ath11k: hif: add ce irq enable and disable functions
      ath11k: implement suspend for QCA6390 PCI devices

Catherine Sullivan (3):
      gve: Add support for raw addressing device option
      gve: Add support for raw addressing to the rx path
      gve: Add support for raw addressing in the tx path

Chin-Yen Lee (5):
      rtw88: sync the power state between driver and firmware
      rtw88: store firmware feature in firmware header
      rtw88: add C2H response for checking firmware leave lps
      rtw88: decide lps deep mode from firmware feature.
      rtw88: reduce polling time of IQ calibration

Ching-Te Ku (33):
      rtw88: coex: separate BLE HID profile from BLE profile
      rtw88: coex: fixed some wrong register definition and setting
      rtw88: coex: update coex parameter to improve A2DP quality
      rtw88: coex: reduce magic number
      rtw88: coex: coding style adjustment
      rtw88: coex: Modify the timing of set_ant_path/set_rf_para
      rtw88: coex: add separate flag for manual control
      rtw88: coex: modified for BT info notify
      rtw88: coex: change the parameter for A2DP when WLAN connecting
      rtw88: coex: update WLAN 5G AFH parameter for 8822b
      rtw88: coex: add debug message
      rtw88: coex: simplify the setting and condition about WLAN TX limitation
      rtw88: coex: update TDMA settings for different beacon interval
      rtw88: coex: remove unnecessary feature/function
      rtw88: coex: add write scoreboard action when WLAN in critical procedure
      rtw88: coex: Add force flag for coexistence table function
      rtw88: coex: add the mechanism for RF4CE
      rtw88: coex: update the TDMA parameter when leave LPS
      rtw88: coex: Change antenna setting to enhance free-run performance
      rtw88: coex: fix BT performance drop during initial/power-on step
      rtw88: coex: remove write scan bit to scoreboard in scan and connect notify
      rtw88: coex: remove unnecessary WLAN slot extend
      rtw88: coex: change the decode method from firmware
      rtw88: coex: run coexistence when WLAN entering/leaving LPS
      rtw88: coex: add debug message
      rtw88: coex: update the mechanism for A2DP + PAN
      rtw88: coex: update AFH information while in free-run mode
      rtw88: coex: change the coexistence mechanism for HID
      rtw88: coex: change the coexistence mechanism for WLAN connected
      rtw88: coex: add function to avoid cck lock
      rtw88: coex: add action for coexistence in hardware initial
      rtw88: coex: upgrade coexistence A2DP mechanism
      rtw88: coex: add feature to enhance HID coexistence performance

Chris Chiu (1):
      Bluetooth: btusb: Add support for 13d3:3560 MediaTek MT7615E device

Chris Mi (2):
      net/mlx5: Add sample offload hardware bits and structures
      net/mlx5: Add sampler destination type

Chris Packham (5):
      net: dsa: mv88e6xxx: Don't force link when using in-band-status
      net: dsa: mv88e6xxx: Support serdes ports on MV88E6097/6095/6185
      net: dsa: mv88e6xxx: Add serdes interrupt support for MV88E6097
      net: dsa: mv88e6xxx: Handle error in serdes_get_regs
      net: freescale: ucc_geth: remove unused SKB_ALLOC_TIMEOUT

Christer Beskow (1):
      can: kvaser_usb: kvaser_usb_hydra: Add support for new device variant

Christian Eggers (13):
      net: dsa: tag_ksz: don't allocate additional memory for padding/tagging
      net: dsa: trailer: don't allocate additional memory for padding/tagging
      net: dsa: avoid potential use-after-free error
      net: ptp: introduce common defines for PTP message types
      dpaa2-eth: use new PTP_MSGTYPE_* define(s)
      ptp: ptp_ines: use new PTP_MSGTYPE_* define(s)
      net: phy: dp83640: use new PTP_MSGTYPE_SYNC define
      mlxsw: spectrum_ptp: use PTP wide message type definitions
      net: phy: mscc: use new PTP_MSGTYPE_* defines
      dt-bindings: net: dsa: convert ksz bindings document to yaml
      net: dsa: microchip: support for "ethernet-ports" node
      net: dsa: microchip: ksz9477: setup SPI mode
      net: dsa: microchip: ksz8795: setup SPI mode

Christophe JAILLET (7):
      net: pch_gbe: Use dma_set_mask_and_coherent to simplify code
      net: pch_gbe: Use 'dma_free_coherent()' to undo 'dma_alloc_coherent()'
      sctp: Fix some typo
      ath11k: Fix an error handling path
      ath10k: Fix an error handling path
      ath10k: Release some resources in an error handling path
      mwl8k: switch from 'pci_' to 'dma_' API

Chuanhong Guo (1):
      mt76: mt7615: retry if mt7615_mcu_init returns -EAGAIN

Claire Chang (1):
      Bluetooth: Move force_bredr_smp debugfs into hci_debugfs_create_bredr

Claudiu Beznea (8):
      net: macb: add userio bits as platform configuration
      net: macb: add capability to not set the clock rate
      net: macb: add function to disable all macb clocks
      net: macb: unprepare clocks in case of failure
      dt-bindings: add documentation for sama7g5 ethernet interface
      dt-bindings: add documentation for sama7g5 gigabit ethernet interface
      net: macb: add support for sama7g5 gem interface
      net: macb: add support for sama7g5 emac interface

Claudiu Manoil (3):
      enetc: Remove Tx checksumming offload code
      enetc: Fix endianness issues for enetc_ethtool
      enetc: Fix endianness issues for enetc_qos

Clayton Rayment (1):
      net: xilinx: axiethernet: Enable dynamic MDIO MDC

Colin Ian King (19):
      vsock: remove ratelimit unknown ioctl message
      vsock: fix the error return when an invalid ioctl command is used
      net: dev_ioctl: remove redundant initialization of variable err
      octeontx2-pf: Fix sizeof() mismatch
      nl80211/cfg80211: fix potential infinite loop
      net: dsa: fix unintended sign extension on a u16 left shift
      Bluetooth: btrtl: fix incorrect skb allocation failure check
      octeontx2-pf: Fix unintentional sign extension issue
      octeontx2-af: Fix return of uninitialized variable err
      octeontx2-af: Fix access of iter->entry after iter object has been kfree'd
      net: hns3: fix spelling mistake "memroy" -> "memory"
      samples/bpf: Fix spelling mistake "recieving" -> "receiving"
      net: fix spelling mistake "wil" -> "will" in Kconfig
      wilc1000: remove redundant assignment to pointer vif
      rtw88: coex: fix missing unitialization of variable 'interval'
      brcmfmac: remove redundant assignment to pointer 'entry'
      net: sched: fix spelling mistake in Kconfig "trys" -> "tries"
      net: wireless: make a const array static, makes object smaller
      net: hns3: fix expression that is currently always true

DENG Qingfang (3):
      net: dsa: mt7530: support setting MTU
      net: dsa: mt7530: support setting ageing time
      net: dsa: mt7530: enable MTU normalization

Dan Carpenter (2):
      octeontx2-af: debugfs: delete dead code
      ath11k: unlock on error path in ath11k_mac_op_add_interface()

Dan Murphy (1):
      can: tcan4x5x: rename parse_config() function

Daniel Borkmann (6):
      Merge branch 'bpf-ptrs-beyond-pkt-end'
      Merge branch 'xdp-redirect-bulk'
      Merge branch 'af-xdp-tx-batch'
      Merge branch 'xdp-preferred-busy-polling'
      net, xdp, xsk: fix __sk_mark_napi_id_once napi_id error
      Merge branch 'bpf-xsk-selftests'

Daniel T. Lee (7):
      samples: bpf: Refactor hbm program with libbpf
      samples: bpf: Refactor test_cgrp2_sock2 program with libbpf
      samples: bpf: Refactor task_fd_query program with libbpf
      samples: bpf: Refactor ibumad program with libbpf
      samples: bpf: Refactor test_overhead program with libbpf
      samples: bpf: Fix lwt_len_hist reusing previous BPF map
      samples: bpf: Remove bpf_load loader completely

Daniel Winkler (6):
      Bluetooth: Resume advertising after LE connection
      Bluetooth: Add helper to set adv data
      Bluetooth: Break add adv into two mgmt commands
      Bluetooth: Use intervals and tx power from mgmt cmds
      Bluetooth: Query LE tx power on startup
      Bluetooth: Change MGMT security info CMD to be more generic

Danielle Ratson (3):
      bridge: switchdev: Notify about VLAN protocol changes
      mlxsw: Add QinQ configuration vetoes
      selftests: forwarding: Add QinQ veto testing

Dany Madden (1):
      Revert ibmvnic merge do_change_param_reset into do_reset

Dave Ertman (1):
      Add auxiliary bus support

David Awogbemila (1):
      gve: Rx Buffer Recycling

David Bauer (1):
      mt76: mt7603: add additional EEPROM chip ID

David Howells (17):
      keys: Provide the original description to the key preparser
      rxrpc: Remove the rxk5 security class as it's now defunct
      rxrpc: List the held token types in the key description in /proc/keys
      rxrpc: Support keys with multiple authentication tokens
      rxrpc: Don't retain the server key in the connection
      rxrpc: Split the server key type (rxrpc_s) into its own file
      rxrpc: Hand server key parsing off to the security class
      rxrpc: Don't leak the service-side session key to userspace
      rxrpc: Allow security classes to give more info on server keys
      rxrpc: Make the parsing of xdr payloads more coherent
      rxrpc: Ignore unknown tokens in key payload unless no known tokens
      rxrpc: Fix example key name in a comment
      rxrpc: Merge prime_packet_security into init_connection_security
      rxrpc: Don't reserve security header in Tx DATA skbuff
      rxrpc: Organise connection security to use a union
      rxrpc: rxkad: Don't use pskb_pull() to advance through the response packet
      rxrpc: Ask the security class how much space to allow in a packet

David S. Miller (16):
      Merge branch 'r8169-improve-rtl_rx-and-NUM_RX_DESC-handling'
      Merge branch 'mlxsw-Misc-updates' Ido Schimmel says:
      Merge branch 's390-qeth-next'
      Merge tag 'mlx5-updates-2020-12-01' of git://git.kernel.org/.../saeed/linux
      Merge branch 'mlxsw-Add-support-for-Q-in-VNI'
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/bluetooth-next
      Merge branch 'GVE-Raw-Addressing'
      Merge branch 'macb-sama7g5'
      Merge branch 'nfc-s3fwrn5-Change-I2C-interrupt-trigger-to-EDGE_RISING'
      Merge branch '100GbE' of git://git.kernel.org/.../tnguy/next-queue
      Merge branch 'mptcp-Add-port-parameter-to-ADD_ADDR-option'
      Merge branch 'mptcp-fixes'
      Merge branch 'Add-support-for-VSOL-V2801F-CarlitoxxPro-CPGOS03-GPON-mo dule'
      Merge branch 'hns3-next'
      Merge tag 'linux-can-next-for-5.11-20201210' of git://git.kernel.org/.../mkl/linux-can-next
      Merge branch 'add-ppp_generic-ioctls-to-bridge-channels'

Devin Bayer (1):
      ath11k: pci: add MODULE_FIRMWARE macros

Dmitrii Banshchikov (1):
      bpf: Add bpf_ktime_get_coarse_ns helper

Dmitry Safonov (1):
      brcmsmac: ampdu: Check BA window size before checking block ack

Dwip N. Banerjee (5):
      ibmvnic: Ensure that device queue memory is cache-line aligned
      ibmvnic: Correctly re-enable interrupts in NAPI polling routine
      ibmvnic: Use netdev_alloc_skb instead of alloc_skb to replenish RX buffers
      ibmvnic: Do not replenish RX buffers after every polling loop
      ibmvnic: fix rx buffer tracking and index management in replenish_rx_pool partial success

Edward Cree (7):
      sfc: extend bitfield macros to 17 fields
      sfc: implement encap TSO on EF100
      sfc: only use fixed-id if the skb asks for it
      sfc: advertise our vlan features
      sfc: extend bitfield macros to 19 fields
      sfc: correctly support non-partial GSO_UDP_TUNNEL_CSUM on EF100
      sfc: support GRE TSO on EF100

Edward Vear (1):
      Bluetooth: Fix attempting to set RPA timeout when unsupported

Eelco Chaudron (1):
      net: openvswitch: fix TTL decrement exception action execution

Eli Cohen (1):
      net/mlx5: Export steering related functions

Emmanuel Grumbach (9):
      iwlwifi: mvm: remove the read_nvm from iwl_run_init_mvm_ucode
      iwlwifi: pcie: remove obsolete pre-release support code
      iwlwifi: mvm: remove the read_nvm from iwl_run_unified_mvm_ucode
      iwlwifi: follow the new inclusive terminology
      iwlwifi: sort out the NVM offsets
      iwlwifi: remove sw_csum_tx
      iwlwifi: mvm: purge the BSS table upon firmware load
      rfkill: add a reason to the HW rfkill state
      mac80211: don't filter out beacons once we start CSA

Eran Ben Elisha (7):
      net/mlx5: Add ts_cqe_to_dest_cqn related bits
      net/mlx5e: Allow SQ outside of channel context
      net/mlx5e: Change skb fifo push/pop API to be used without SQ
      net/mlx5e: Split SW group counters update function
      net/mlx5e: Move MLX5E_RX_ERR_CQE macro
      net/mlx5e: Add TX PTP port object support
      net/mlx5e: Add TX port timestamp support

Eric Dumazet (8):
      bpf: Fix error path in htab_map_alloc()
      inet: constify inet_sdif() argument
      inet: udp{4|6}_lib_lookup_skb() skb argument is const
      tcp: uninline tcp_stream_memory_free()
      tcp: avoid indirect call to tcp_stream_memory_free()
      inet: unexport udp{4|6}_lib_lookup_skb()
      mptcp: avoid potential infinite loop in mptcp_recvmsg()
      bpf: Avoid overflows involving hash elem_size

Fabio Estevam (1):
      can: flexcan: convert the driver to DT-only

Felix Fietkau (25):
      mt76: mt7915: add 802.11 encap offload support
      mt76: mt7915: add encap offload for 4-address mode stations
      mt76: use ieee80211_rx_list to pass frames to the network stack as a batch
      mt76: mt7615: add debugfs knob for setting extended local mac addresses
      mt76: do not set NEEDS_UNIQUE_STA_ADDR for 7615 and 7915
      mt76: mt7915: support 32 station interfaces
      mt76: mt7915: fix processing txfree events
      mt76: mt7915: use napi_consume_skb to bulk-free tx skbs
      mt76: mt7915: fix DRR sta bss group index
      mt76: mt7915: disable OFDMA/MU-MIMO UL
      mt76: rename __mt76_mcu_send_msg to mt76_mcu_send_msg
      mt76: rename __mt76_mcu_skb_send_msg to mt76_mcu_skb_send_msg
      mt76: implement .mcu_parse_response in struct mt76_mcu_ops
      mt76: move mcu timeout handling to .mcu_parse_response
      mt76: move waiting and locking out of mcu_ops->mcu_skb_send_msg
      mt76: make mcu_ops->mcu_send_msg optional
      mt76: mt7603: switch to .mcu_skb_send_msg
      mt76: implement functions to get the response skb for MCU calls
      mt76: mt7915: move eeprom parsing out of mt7915_mcu_parse_response
      mt76: mt7915: query station rx rate from firmware
      mt76: add back the SUPPORTS_REORDERING_BUFFER flag
      mt76: mt7915: fix endian issues
      mt76: improve tx queue stop/wake
      mt76: mt7915: stop queues when running out of tx tokens
      mt76: attempt to free up more room when filling the tx queue

Florent Revest (7):
      net: Remove the err argument from sock_from_file
      bpf: Add a bpf_sock_from_file helper
      bpf: Expose bpf_sk_storage_* to iterator programs
      selftests/bpf: Add an iterator selftest for bpf_sk_storage_delete
      selftests/bpf: Add an iterator selftest for bpf_sk_storage_get
      selftests/bpf: Test bpf_sk_storage_get in tcp iterators
      bpf: Only provide bpf_sock_from_file with CONFIG_NET

Florian Lehner (3):
      bpf: Lift hashtab key_size limit
      selftests/bpf: Print reason when a tester could not run a program
      selftests/bpf: Avoid errno clobbering

Florian Westphal (16):
      mptcp: adjust mptcp receive buffer limit if subflow has larger one
      mptcp: use _fast lock version in __mptcp_move_skbs
      mptcp: split mptcp_clean_una function
      mptcp: rework poll+nospace handling
      mptcp: keep track of advertised windows right edge
      mptcp: skip to next candidate if subflow has unacked data
      selftests: mptcp: add link failure test case
      mptcp: track window announced to peer
      mptcp: put reference in mptcp timeout timer
      security: add const qualifier to struct sock in various places
      tcp: merge 'init_req' and 'route_req' functions
      mptcp: emit tcp reset when a join request fails
      netfilter: ctnetlink: add timeout and protoinfo to destroy events
      mptcp: hold mptcp socket before calling tcp_done
      tcp: parse mptcp options contained in reset packets
      mptcp: parse and act on incoming FASTCLOSE option

Francis Laniel (3):
      Fix unefficient call to memset before memcpu in nla_strlcpy.
      Modify return value of nla_strlcpy to match that of strscpy.
      treewide: rename nla_strlcpy to nla_strscpy.

Frieder Schrempf (1):
      NFC: nxp-nci: Make firmware GPIO pin optional

Ganapathi Bhat (1):
      mwifiex: change license text of Makefile and README from MARVELL to NXP

Geliang Tang (20):
      mptcp: add a new sysctl add_addr_timeout
      selftests: mptcp: add ADD_ADDR timeout test case
      mptcp: fix static checker warnings in mptcp_pm_add_timer
      mptcp: change add_addr_signal type
      mptcp: send out dedicated ADD_ADDR packet
      selftests: mptcp: add ADD_ADDR IPv6 test cases
      mptcp: unify ADD_ADDR and echo suboptions writing
      mptcp: unify ADD_ADDR and ADD_ADDR6 suboptions writing
      mptcp: add port support for ADD_ADDR suboption writing
      mptcp: use adding up size to get ADD_ADDR length
      mptcp: add the outgoing ADD_ADDR port support
      mptcp: send out dedicated packet for ADD_ADDR using port
      mptcp: add port parameter for mptcp_pm_announce_addr
      mptcp: print out port and ahmac when receiving ADD_ADDR
      mptcp: drop rm_addr_signal flag
      mptcp: rename add_addr_signal and mptcp_add_addr_status
      mptcp: use the variable sk instead of open-coding
      mptcp: remove address when netlink flushes addrs
      selftests: mptcp: add the flush addrs testcase
      mptcp: use MPTCPOPT_HMAC_LEN macro

George Cherian (4):
      octeontx2-af: Add support for RSS hashing based on Transport protocol field
      octeontx2-af: Add devlink suppoort to af driver
      octeontx2-af: Add devlink health reporters for NPA
      docs: octeontx2: Add Documentation for NPA health reporters

Govind Singh (1):
      ath11k: Remove unused param from wmi_mgmt_params

Govindaraj Saminathan (1):
      ath11k: cold boot calibration support

Greg Kroah-Hartman (3):
      driver core: auxiliary bus: move slab.h from include file
      driver core: auxiliary bus: make remove function return void
      driver core: auxiliary bus: minor coding style tweaks

Grygorii Strashko (12):
      selftests/net: timestamping: add ptp v2 support
      net: ethernet: ti: am65-cpsw: move ale selection in pdata
      net: ethernet: ti: am65-cpsw: move free desc queue mode selection in pdata
      net: ethernet: ti: am65-cpsw: use cppi5_desc_is_tdcm()
      net: ethernet: ti: cpsw_ale: add cpsw_ale_vlan_del_modify()
      net: ethernet: ti: am65-cpsw: fix vlan offload for multi mac mode
      net: ethernet: ti: am65-cpsw: keep active if cpts enabled
      net: ethernet: ti: am65-cpsw: fix tx csum offload for multi mac mode
      net: ethernet: ti: am65-cpsw: prepare xmit/rx path for multi-port devices in mac-only mode
      net: ethernet: ti: am65-cpsw: add multi port support in mac-only mode
      net: ethernet: ti: am65-cpsw: handle deferred probe with dev_err_probe()
      mdio_bus: suppress err message for reset gpio EPROBE_DEFER

Guillaume Nault (5):
      selftests: add test script for bareudp tunnels
      mpls: drop skb's dst in mpls_forward()
      selftests: disable rp_filter when testing bareudp
      selftests: set conf.all.rp_filter=0 in bareudp.sh
      selftests: forwarding: Add MPLS L2VPN test

Guojia Liao (5):
      net: hns3: add support for extended promiscuous command
      net: hns3: refine the VLAN tag handle for port based VLAN
      net: hns3: add support for max 512 rss size
      net: hns3: adjust rss indirection table configure command
      net: hns3: adjust rss tc mode configure command

Gustavo A. R. Silva (19):
      ray_cs: Use fallthrough pseudo-keyword
      wlcore: Use fallthrough pseudo-keyword
      nfp: tls: Fix unreachable code issue
      mwifiex: Fix fall-through warnings for Clang
      can: pcan_usb_core: fix fall-through warnings for Clang
      mt76: mt7615: Fix fall-through warnings for Clang
      airo: Fix fall-through warnings for Clang
      rt2x00: Fix fall-through warnings for Clang
      rtw88: Fix fall-through warnings for Clang
      zd1201: Fix fall-through warnings for Clang
      ath5k: Fix fall-through warnings for Clang
      carl9170: Fix fall-through warnings for Clang
      wcn36xx: Fix fall-through warnings for Clang
      cfg80211: Fix fall-through warnings for Clang
      mac80211: Fix fall-through warnings for Clang
      nl80211: Fix fall-through warnings for Clang
      iwlwifi: mvm: Fix fall-through warnings for Clang
      iwlwifi: dvm: Fix fall-through warnings for Clang
      iwlwifi: iwl-drv: Fix fall-through warnings for Clang

Guvenc Gulce (13):
      net/smc: Use active link of the connection
      net/smc: Add connection counters for links
      net/smc: Add link counters for IB device ports
      net/smc: Add diagnostic information to smc ib-device
      net/smc: Add diagnostic information to link structure
      net/smc: Refactor smc ism v2 capability handling
      net/smc: Introduce generic netlink interface for diagnostic purposes
      net/smc: Add support for obtaining system information
      net/smc: Introduce SMCR get linkgroup command
      net/smc: Introduce SMCR get link command
      net/smc: Add SMC-D Linkgroup diagnostic support
      net/smc: Add support for obtaining SMCD device list
      net/smc: Add support for obtaining SMCR device list

Hangbin Liu (2):
      selftest/bpf: Add missed ip6ip6 test back
      samples/bpf: Remove unused test_ipip.sh

Hans de Goede (4):
      Bluetooth: revert: hci_h5: close serdev device and free hu in h5_close
      Bluetooth: hci_h5: Add OBDA0623 ACPI HID
      Bluetooth: btusb: Fix detection of some fake CSR controllers with a bcdDevice val of 0x0134
      Bluetooth: btusb: Add workaround for remote-wakeup issues with Barrot 8041a02 fake CSR controllers

Hariprasad Kelam (3):
      octeontx2-pf: Add support for unicast MAC address filtering
      octeontx2-pf: Implement ingress/egress VLAN offload
      octeontx2-af: Handle PF-VF mac address changes

Hayes Wang (2):
      net/usb/r8153_ecm: support ECM mode for RTL8153
      r8153_ecm: avoid to be prior to r8152 driver

Heiner Kallweit (37):
      net: core: add dev_sw_netstats_tx_add
      net: core: add devm_netdev_alloc_pcpu_stats
      r8169: use struct pcpu_sw_netstats for rx/tx packet/byte counters
      r8169: remove no longer needed private rx/tx packet/byte counters
      r8169: remove unneeded memory barrier in rtl_tx
      r8169: use pm_runtime_put_sync in rtl_open error path
      r8169: align number of tx descriptors with vendor driver
      r8169: set IRQF_NO_THREAD if MSI(X) is enabled
      net: core: add dev_get_tstats64 as a ndo_get_stats64 implementation
      net: dsa: use net core stats64 handling
      tun: switch to net core provided statistics counters
      ip6_tunnel: use ip_tunnel_get_stats64 as ndo_get_stats64 callback
      net: switch to dev_get_tstats64
      gtp: switch to dev_get_tstats64
      wireguard: switch to dev_get_tstats64
      vti: switch to dev_get_tstats64
      ipv4/ipv6: switch to dev_get_tstats64
      net: remove ip_tunnel_get_stats64
      IB/hfi1: switch to core handling of rx/tx byte/packet counters
      qmi_wwan: switch to core handling of rx/tx byte/packet counters
      qtnfmac: switch to core handling of rx/tx byte/packet counters
      usbnet: switch to core handling of rx/tx byte/packet counters
      net: usb: switch to dev_get_tstats64 and remove usbnet_get_stats64 alias
      r8169: use READ_ONCE in rtl_tx_slots_avail
      r8169: improve rtl_tx
      r8169: improve rtl8169_start_xmit
      r8169: remove nr_frags argument from rtl_tx_slots_avail
      net: phy: don't duplicate driver name in phy_attached_print
      net: bridge: replace struct br_vlan_stats with pcpu_sw_netstats
      r8169: remove not needed check in rtl8169_start_xmit
      r8169: reduce number of workaround doorbell rings
      r8169: use dev_err_probe in rtl_get_ether_clk
      net: bridge: switch to net core statistics counters handling
      net: warn if gso_type isn't set for a GSO SKB
      r8169: set tc_offset only if tally counter reset isn't supported
      r8169: improve rtl_rx
      r8169: make NUM_RX_DESC a signed int

Henrik Bjoernlund (10):
      net: bridge: extend the process of special frames
      bridge: cfm: Add BRIDGE_CFM to Kconfig.
      bridge: uapi: cfm: Added EtherType used by the CFM protocol.
      bridge: cfm: Kernel space implementation of CFM. MEP create/delete.
      bridge: cfm: Kernel space implementation of CFM. CCM frame TX added.
      bridge: cfm: Kernel space implementation of CFM. CCM frame RX added.
      bridge: cfm: Netlink SET configuration Interface.
      bridge: cfm: Netlink GET configuration Interface.
      bridge: cfm: Netlink GET status Interface.
      bridge: cfm: Netlink Notifications.

Hoang Huu Le (1):
      tipc: remove dead code in tipc_net and relatives

Hoang Le (1):
      tipc: support 128bit node identity for peer removing

Horatiu Vultur (2):
      bridge: mrp: Use hlist_head instead of list_head for mrp
      bridge: mrp: Implement LC mode for MRP

Howard Chung (6):
      Bluetooth: Replace BT_DBG with bt_dev_dbg in HCI request
      Bluetooth: Interleave with allowlist scan
      Bluetooth: Handle system suspend resume case
      Bluetooth: Handle active scan case
      Bluetooth: Refactor read default sys config for various types
      Bluetooth: Add toggle to switch off interleave scan

Huazhong Tan (11):
      net: hns3: add support for configuring interrupt quantity limiting
      net: hns3: add support for querying maximum value of GL
      net: hns3: add support for 1us unit GL configuration
      net: hns3: rename gl_adapt_enable in struct hns3_enet_coalesce
      net: hns3: add support for mapping device memory
      net: hns3: add support for RX completion checksum
      net: hns3: add support for TX hardware checksum offload
      net: hns3: remove unsupported NETIF_F_GSO_UDP_TUNNEL_CSUM
      net: hns3: add udp tunnel checksum segmentation support
      net: hns3: add more info to hns3_dbg_bd_info()
      net: hns3: add a check for devcie's verion in hns3_tunnel_csum_bug()

Ido Schimmel (72):
      vxlan: Use a per-namespace nexthop listener instead of a global one
      nexthop: Add nexthop notification data structures
      nexthop: Pass extack to nexthop notifier
      nexthop: Prepare new notification info
      nexthop: vxlan: Convert to new notification info
      rtnetlink: Add RTNH_F_TRAP flag
      nexthop: Allow setting "offload" and "trap" indications on nexthops
      nexthop: Emit a notification when a nexthop is added
      nexthop: Emit a notification when a nexthop group is replaced
      nexthop: Emit a notification when a single nexthop is replaced
      nexthop: Emit a notification when a nexthop group is modified
      nexthop: Emit a notification when a nexthop group is reduced
      nexthop: Pass extack to register_nexthop_notifier()
      nexthop: Replay nexthops when registering a notifier
      nexthop: Remove in-kernel route notifications when nexthop changes
      netdevsim: Add devlink resource for nexthops
      netdevsim: Add dummy implementation for nexthop offload
      netdevsim: Allow programming routes with nexthop objects
      selftests: netdevsim: Add test for nexthop offload API
      ipv4: Set nexthop flags in a more consistent way
      mlxsw: spectrum_router: Compare key with correct object type
      mlxsw: spectrum_router: Add nexthop group type field
      mlxsw: spectrum_router: Use nexthop group type in hash table key
      mlxsw: spectrum_router: Associate neighbour table with nexthop instead of group
      mlxsw: spectrum_router: Store FIB info in route
      mlxsw: spectrum_router: Remove unused field 'prio' from IPv4 FIB entry struct
      mlxsw: spectrum_router: Move IPv4 FIB info into a union in nexthop group struct
      mlxsw: spectrum_router: Split nexthop group configuration to a different struct
      mlxsw: spectrum_ipip: Remove overlay protocol from can_offload() callback
      mlxsw: spectrum_router: Pass nexthop netdev to mlxsw_sp_nexthop6_type_init()
      mlxsw: spectrum_router: Pass nexthop netdev to mlxsw_sp_nexthop4_type_init()
      mlxsw: spectrum_router: Remove unused argument from mlxsw_sp_nexthop6_type_init()
      mlxsw: spectrum_router: Consolidate mlxsw_sp_nexthop{4, 6}_type_init()
      mlxsw: spectrum_router: Consolidate mlxsw_sp_nexthop{4, 6}_type_fini()
      mlxsw: spectrum_router: Remove outdated comment
      mlxsw: spectrum_router: Fix wrong kfree() in error path
      mlxsw: spectrum_router: Set ifindex for IPv4 nexthops
      mlxsw: spectrum_router: Pass ifindex to mlxsw_sp_ipip_entry_find_by_decap()
      mlxsw: spectrum_router: Set FIB entry's type after creating nexthop group
      mlxsw: spectrum_router: Set FIB entry's type based on nexthop group
      mlxsw: spectrum_router: Re-order mlxsw_sp_nexthop6_group_get()
      mlxsw: spectrum_router: Only clear offload indication from valid IPv6 FIB info
      mlxsw: spectrum_router: Add an indication if a nexthop group can be destroyed
      mlxsw: spectrum_router: Allow returning errors from mlxsw_sp_nexthop_group_refresh()
      mlxsw: spectrum_router: Add support for nexthop objects
      mlxsw: spectrum_router: Enable resolution of nexthop groups from nexthop objects
      mlxsw: spectrum_router: Allow programming routes with nexthop objects
      selftests: mlxsw: Add nexthop objects configuration tests
      selftests: forwarding: Do not configure nexthop objects twice
      selftests: forwarding: Test IPv4 routes with IPv6 link-local nexthops
      selftests: forwarding: Add device-only nexthop test
      selftests: forwarding: Add multipath tunneling nexthop test
      mlxsw: spectrum_router: Create loopback RIF during initialization
      mlxsw: spectrum_router: Use different trap identifier for unresolved nexthops
      mlxsw: spectrum_router: Use loopback RIF for unresolved nexthops
      mlxsw: spectrum_router: Resolve RIF from nexthop struct instead of neighbour
      mlxsw: spectrum_router: Add support for blackhole nexthops
      selftests: mlxsw: Add blackhole nexthop configuration tests
      selftests: forwarding: Add blackhole nexthops tests
      devlink: Add blackhole_nexthop trap
      mlxsw: spectrum_trap: Add blackhole_nexthop trap
      selftests: mlxsw: Add blackhole_nexthop trap test
      mlxsw: spectrum_router: Fix error handling issue
      mlxsw: spectrum_router: Pass virtual router parameters directly instead of pointer
      mlxsw: spectrum_router: Rollback virtual router adjacency pointer update
      mlxsw: spectrum_router: Track nexthop group virtual router membership
      mlxsw: spectrum_router: Update adjacency index more efficiently
      mlxsw: spectrum: Apply RIF configuration when joining a LAG
      selftests: mlxsw: Test RIF's reference count when joining a LAG
      mlxsw: core: Trace EMAD events
      mlxsw: spectrum_mr: Use flexible-array member instead of zero-length array
      mlxsw: core_acl: Use an array instead of a struct with a zero-length array

Ilan Peer (6):
      cfg80211: Parse SAE H2E only membership selector
      mac80211: Skip entries with SAE H2E only membership selector
      cfg80211: Update TSF and TSF BSSID for multi BSS
      cfg80211: Save the regulatory domain when setting custom regulatory
      mac80211: Fix calculation of minimal channel width
      mac80211: Update rate control on channel change

Ioana Ciornei (53):
      net: phy: export phy_error and phy_trigger_machine
      net: phy: add a shutdown procedure
      net: phy: make .ack_interrupt() optional
      net: phy: at803x: implement generic .handle_interrupt() callback
      net: phy: at803x: remove the use of .ack_interrupt()
      net: phy: mscc: use phy_trigger_machine() to notify link change
      net: phy: mscc: implement generic .handle_interrupt() callback
      net: phy: mscc: remove the use of .ack_interrupt()
      net: phy: aquantia: implement generic .handle_interrupt() callback
      net: phy: aquantia: remove the use of .ack_interrupt()
      net: phy: broadcom: implement generic .handle_interrupt() callback
      net: phy: broadcom: remove use of ack_interrupt()
      net: phy: cicada: implement the generic .handle_interrupt() callback
      net: phy: cicada: remove the use of .ack_interrupt()
      net: phy: davicom: implement generic .handle_interrupt() calback
      net: phy: davicom: remove the use of .ack_interrupt()
      net: phy: add genphy_handle_interrupt_no_ack()
      net: phy: realtek: implement generic .handle_interrupt() callback
      net: phy: realtek: remove the use of .ack_interrupt()
      net: phy: aquantia: do not return an error on clearing pending IRQs
      net: phy: vitesse: implement generic .handle_interrupt() callback
      net: phy: vitesse: remove the use of .ack_interrupt()
      net: phy: microchip: implement generic .handle_interrupt() callback
      net: phy: microchip: remove the use of .ack_interrupt()
      net: phy: marvell: implement generic .handle_interrupt() callback
      net: phy: marvell: remove the use of .ack_interrupt()
      net: phy: lxt: implement generic .handle_interrupt() callback
      net: phy: lxt: remove the use of .ack_interrupt()
      net: phy: nxp-tja11xx: implement generic .handle_interrupt() callback
      net: phy: nxp-tja11xx: remove the use of .ack_interrupt()
      net: phy: amd: implement generic .handle_interrupt() callback
      net: phy: amd: remove the use of .ack_interrupt()
      net: phy: smsc: implement generic .handle_interrupt() callback
      net: phy: smsc: remove the use of .ack_interrupt()
      net: phy: ste10Xp: implement generic .handle_interrupt() callback
      net: phy: ste10Xp: remove the use of .ack_interrupt()
      net: phy: adin: implement generic .handle_interrupt() callback
      net: phy: adin: remove the use of the .ack_interrupt()
      net: phy: intel-xway: implement generic .handle_interrupt() callback
      net: phy: intel-xway: remove the use of .ack_interrupt()
      net: phy: icplus: implement generic .handle_interrupt() callback
      net: phy: icplus: remove the use .ack_interrupt()
      net: phy: meson-gxl: implement generic .handle_interrupt() callback
      net: phy: meson-gxl: remove the use of .ack_callback()
      net: phy: micrel: implement generic .handle_interrupt() callback
      net: phy: micrel: remove the use of .ack_interrupt()
      net: phy: national: implement generic .handle_interrupt() callback
      net: phy: national: remove the use of the .ack_interrupt()
      net: phy: ti: implement generic .handle_interrupt() callback
      net: phy: ti: remove the use of .ack_interrupt()
      net: phy: qsemi: implement generic .handle_interrupt() callback
      net: phy: qsemi: remove the use of .ack_interrupt()
      net: phy: remove the .did_interrupt() and .ack_interrupt() callback

Ivan Mikhaylov (3):
      net: ftgmac100: move phy connect out from ftgmac100_setup_mdio
      net: ftgmac100: add handling of mdio/phy nodes for ast2400/2500
      dt-bindings: net: ftgmac100: describe phy-handle and MDIO

Jacob Keller (3):
      devlink: move request_firmware out of driver
      devlink: move flash end and begin to core devlink
      ice: join format strings to same line as ice_debug

Jakub Kicinski (136):
      Merge git://git.kernel.org/.../netdev/net
      Merge branch 'vsock-minor-clean-up-of-ioctl-error-handling'
      Merge branch 'net-bridge-cfm-add-support-for-connectivity-fault-management-cfm'
      Merge tag 'wimax-staging' of git://git.kernel.org:/.../arnd/playground
      Merge branch 'selftests-net-bridge-add-tests-for-igmpv3'
      Merge branch 'markup-some-printk-like-functions'
      Merge branch 'sctp-implement-rfc6951-udp-encapsulation-of-sctp'
      Merge branch 'net-ipa-minor-bug-fixes'
      Merge branch 'sfc-ef100-tso-enhancements'
      Merge branch 'l2-multicast-forwarding-for-ocelot-switch'
      Merge branch 'in_interrupt-cleanup-part-2'
      Merge branch 'net-add-functionality-to-net-core-byte-packet-counters-and-use-it-in-r8169'
      Merge branch 'support-for-octeontx2-98xx-silcion'
      Merge branch 'add-ast2400-2500-phy-handle-support'
      Merge branch 'davicom-w-1-fixes'
      Merge branch 'net-ethernet-ti-am65-cpsw-add-multi-port-support-in-mac-only-mode'
      Merge branch 'vlan-improvements-for-ocelot-switch'
      Merge branch 'generic-tx-reallocation-for-dsa'
      Merge branch 'net-mac80211-kernel-enable-kcov-remote-coverage-collection-for-802-11-frame-handling'
      Merge branch 'net-hdlc_fr-improve-fr_rx-and-add-support-for-any-ethertype'
      Merge branch 'net-allow-virtual-netdevs-to-forward-udp-l4-and-fraglist-gso-skbs'
      Merge branch 'mlxsw-spectrum-prepare-for-xm-implementation-lpm-trees'
      Merge branch 'fsl-qbman-in_interrupt-cleanup'
      Merge branch 'net-ipa-tell-gsi-the-ipa-version'
      Merge branch 'selftests-net-bridge-add-tests-for-mldv2'
      Merge branch 'mptcp-miscellaneous-mptcp-fixes'
      Merge git://git.kernel.org/.../pablo/nf-next
      Merge branch 'hirschmann-hellcreek-dsa-driver'
      Merge branch 'net-phy-add-support-for-shared-interrupts-part-1'
      Merge tag 'mlx5-updates-2020-11-03' of git://git.kernel.org/.../saeed/linux
      Merge branch 'nexthop-add-support-for-nexthop-objects-offload'
      Merge git://git.kernel.org/.../netdev/net
      Merge branch 'net-convert-tasklets-to-use-new-tasklet_setup-api'
      Merge branch 'net-axienet-dynamically-enable-mdio-interface'
      Merge branch 'net-ipa-constrain-gsi-interrupts'
      Merge branch 'net-packet-make-packet_fanout-arr-size-configurable-up-to-64k'
      Merge branch 'net-add-and-use-dev_get_tstats64'
      Merge branch 'inet-prevent-skb-changes-in-udp-4-6-_lib_lookup_skb'
      Merge branch 'net-ipa-little-fixes'
      Merge branch 'net-qrtr-add-distant-node-support'
      Merge branch 'net-evaluate-net-ipvX-conf-all-sysctls'
      Merge branch 'selftests-pmtu-sh-improve-the-test-result-processing'
      Merge branch 'xilinx_emaclite-w-1-fixes'
      Merge branch 'smsc-w-1-warning-fixes'
      Merge branch 'net-switch-further-drivers-to-core-functionality-for-handling-per-cpu-byte-packet-counters'
      Merge branch 'mlxsw-spectrum-prepare-for-xm-implementation-prefix-insertion-and-removal'
      Merge https://git.kernel.org/.../netdev/net
      Merge tag 'mac80211-next-for-net-next-2020-11-13' of git://git.kernel.org/.../jberg/mac80211-next
      Merge branch 'net-ipa-gsi-register-consolidation'
      Merge branch 'sfc-further-ef100-encap-tso-features'
      Merge branch 'net-ipa-two-fixes'
      Merge git://git.kernel.org/.../bpf/bpf-next
      Merge branch 'ionic-updates'
      Merge branch 'tcp-avoid-indirect-call-in-__sk_stream_memory_free'
      Merge branch 'mlxsw-preparations-for-nexthop-objects-support-part-1-2'
      Merge branch 'fix-inefficiences-and-rename-nla_strlcpy'
      Merge branch 'mptcp-improve-multiple-xmit-streams-support'
      Merge branch 'net-dsa-tag_dsa-unify-regular-and-ethertype-dsa-taggers'
      Merge branch 'net-phy-add-support-for-shared-interrupts-part-2'
      Merge branch 'net-hns3-updates-for-next'
      Merge branch 'add-ethtool-ntuple-filters-support'
      Merge branch 'fix-several-bad-kernel-doc-markups'
      Merge branch 'mlxsw-preparations-for-nexthop-objects-support-part-2-2'
      Merge branch 'net-ipa-ipa-register-cleanup'
      Merge branch 'atm-replace-in_interrupt-usage'
      Merge branch 's390-qeth-updates-2020-11-17'
      Merge https://git.kernel.org/.../netdev/net
      Merge branch 'devlink-move-common-flash_update-calls-to-core'
      Merge branch 'enetc-clean-endianness-warnings-up'
      Merge branch 'add-support-for-marvell-octeontx2-cryptographic'
      Merge branch 'netdevsim-add-ethtool-coalesce-and-ring-settings'
      Merge branch 'mlxsw-add-support-for-nexthop-objects'
      Merge branch 'mptcp-more-miscellaneous-mptcp-fixes'
      Merge branch 'net-ipa-platform-specific-clock-and-interconnect-rates'
      Merge branch 'net-ipa-add-a-driver-shutdown-callback'
      Merge branch 'ibmvnic-performance-improvements-and-other-updates'
      Merge branch 'net-hns3-misc-updates-for-next'
      Merge tag 'linux-can-next-for-5.11-20201120' of git://git.kernel.org/.../mkl/linux-can-next
      compat: always include linux/compat.h from net/compat.h
      Merge branch 'net-ptp-introduce-common-defines-for-ptp-message-types'
      Merge branch 'net-dsa-hellcreek-minor-cleanups'
      net: don't include ethtool.h from netdevice.h
      Merge tag 'rxrpc-next-20201123' of git://git.kernel.org/.../dhowells/linux-fs
      Merge branch 'mlxsw-add-support-for-blackhole-nexthops'
      Merge branch 'mvneta-access-skb_shared_info-only-on-last-frag'
      Merge branch 'net-phy-add-support-for-shared-interrupts-part-3'
      Merge branch 'net-ptp-use-common-defines-for-ptp-message-types-in-further-drivers'
      Merge branch 'add-an-assert-in-napi_consume_skb'
      Merge branch 'dt-bindings-net-dsa-microchip-convert-ksz-bindings-to-yaml'
      Merge branch 'net-dsa-mv88e6xxx-serdes-link-without-phy'
      Merge branch '40GbE' of git://git.kernel.org/.../tnguy/next-queue
      Merge branch 'add-chacha20-poly1305-cipher-to-kernel-tls'
      Merge branch 'net-sched-fix-over-mtu-packet-of-defrag-in'
      Merge branch 'mlxsw-update-adjacency-index-more-efficiently'
      Merge branch 'net-x25-netdev-event-handling'
      Merge branch 'tipc-some-minor-improvements'
      Merge git://git.kernel.org/.../netdev/net
      Merge branch 'net-ipa-start-adding-ipa-v4-5-support'
      Merge branch 'dpaa_eth-add-xdp-support'
      Merge branch 'mptcp-avoid-workqueue-usage-for-data'
      Merge tag 'linux-can-next-for-5.11-20201130' of git://git.kernel.org/.../mkl/linux-can-next
      Merge branch 'net-hns3-updates-for-next'
      Merge branch 'mlxsw-add-support-for-802-1ad-bridging'
      Merge branch 'net-tipc-fix-all-kernel-doc-and-add-tipc-networking-chapter'
      Merge branch 's390-ctcm-updates-2020-11-30'
      Merge branch 'ionic-updates'
      Merge branch 'net-smc-add-support-for-generic-netlink-api'
      Merge branch 'net-ipa-ipa-v4-5-aggregation-and-qtime'
      Merge branch 'net-dsa-microchip-make-ksz8795-driver-more-versatile'
      Merge tag 'mlx5-next-2020-12-02' of git://git.kernel.org/.../mellanox/linux
      Merge branch 'nfc-s3fwrn5-support-a-uart-interface'
      Merge branch 'mptcp-reject-invalid-mp_join-requests-right-away'
      Merge git://git.kernel.org/.../netdev/net
      Merge https://git.kernel.org/.../bpf/bpf-next
      Merge tag 'wireless-drivers-next-2020-12-03' of git://git.kernel.org/.../kvalo/wireless-drivers-next
      Merge branch 'seg6-add-support-for-srv6-end-dt4-dt6-behavior'
      Merge branch 'perf-optimizations-for-tcp-recv-zerocopy'
      Merge tag 'batadv-next-pullrequest-20201204' of git://git.open-mesh.org/linux-merge
      Merge branch 'mlx5-next' of git://git.kernel.org/.../mellanox/linux
      Merge branch 'net-hns3-updates-for-next'
      Merge branch 'xdp-redirect-implementation-for-ena-driver'
      nfp: silence set but not used warning with IPV6=n
      rtnetlink: RCU-annotate both dimensions of rtnl_msg_handlers
      Merge git://git.kernel.org/.../netdev/net
      Merge tag 'mac80211-next-for-net-next-2020-12-11' of git://git.kernel.org/.../jberg/mac80211-next
      Merge tag 'wireless-drivers-next-2020-12-12' of git://git.kernel.org/.../kvalo/wireless-drivers-next
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec-next
      Merge https://git.kernel.org/.../bpf/bpf-next
      Merge git://git.kernel.org/.../pablo/nf-next
      Merge branch 'mptcp-another-set-of-miscellaneous-mptcp-fixes'
      Merge branch 'add-devlink-and-devlink-health-reporters-to'
      Merge branch 'bnxt_en-improve-firmware-flashing'
      Merge branch 'mlxsw-introduce-initial-xm-router-support'
      Merge tag 'linux-can-next-for-5.11-20201214' of git://git.kernel.org/.../mkl/linux-can-next
      net: vxget: clean up sparse warnings
      Merge branch 'vsock-add-flags-field-in-the-vsock-address'

Jan Engelhardt (1):
      netfilter: use actual socket sk for REJECT action

Janie Tu (1):
      iwlwifi: mvm: fix sar profile printing issue

Jarkko Nikula (1):
      can: m_can: add PCI glue driver for Intel Elkhart Lake

Jarod Wilson (1):
      bonding: set xfrm feature flags more sanely

Jean-Philippe Brucker (9):
      tools: Factor HOSTCC, HOSTLD, HOSTAR definitions
      tools/bpftool: Force clean of out-of-tree build
      tools/bpftool: Fix cross-build
      tools/runqslower: Use Makefile.include
      tools/runqslower: Enable out-of-tree build
      tools/runqslower: Build bpftool using HOSTCC
      tools/bpftool: Fix build slowdown
      tools/bpf: Add bootstrap/ to .gitignore
      tools/bpf: Always run the *-clean recipes

Jeb Cramer (2):
      ice: Enable Support for FW Override (E82X)
      ice: Remove gate to OROM init

Jia-Ju Bai (4):
      rtlwifi: rtl8188ee: avoid accessing the data mapped to streaming DMA
      rtlwifi: rtl8192ce: avoid accessing the data mapped to streaming DMA
      rtlwifi: rtl8192de: avoid accessing the data mapped to streaming DMA
      rtlwifi: rtl8723ae: avoid accessing the data mapped to streaming DMA

Jian Shen (5):
      net: hns3: add priv flags support to switch limit promisc mode
      net: hns3: refine the struct hane3_tc_info
      net: hns3: add support for tc mqprio offload
      net: hns3: add support for forwarding packet to queues of specified TC when flow director rule hit
      net: hns3: add support for hw tc offload of tc flower

Jimmy Assarsson (3):
      can: kvaser_usb: Add USB_{LEAF,HYDRA}_PRODUCT_ID_END defines
      can: kvaser_usb: Add new Kvaser Leaf v2 devices
      can: kvaser_usb: Add new Kvaser hydra devices

Jimmy Wahlberg (1):
      Bluetooth: Fix for Bluetooth SIG test L2CAP/COS/CFD/BV-14-C

Jing Xiangfeng (2):
      Bluetooth: btusb: Add the missed release_firmware() in btusb_mtk_setup_firmware()
      Bluetooth: btmtksdio: Add the missed release_firmware() in mtk_setup_firmware()

Jiri Olsa (1):
      selftests/bpf: Make selftest compilation work on clang 11

Jiri Pirko (33):
      mlxsw: reg: Add XRALXX Registers
      mlxsw: spectrum_router: Introduce low-level ops and implement them for RALXX regs
      mlxsw: spectrum_router: Pass non-register proto enum to __mlxsw_sp_router_set_abort_trap()
      mlxsw: spectrum_router: Use RALUE-independent op arg
      mlxsw: spectrum_router: Introduce FIB event queue instead of separate works
      mlxsw: spectrum: Propagate context from work handler containing RALUE payload
      mlxsw: spectrum_router: Push out RALUE pack into separate helper
      mlxsw: spectrum: Export RALUE pack helper and use it from IPIP
      mlxsw: spectrum_router: Pass destination IP as a pointer to mlxsw_reg_ralue_pack4()
      mlxsw: reg: Allow to pass NULL pointer to mlxsw_reg_ralue_pack4/6()
      mlxsw: spectrum_router: Use RALUE pack helper from abort function
      mlxsw: spectrum: Push RALUE packing and writing into low-level router ops
      mlxsw: spectrum_router: Prepare work context for possible bulking
      mlxsw: spectrum_router: Have FIB entry op context allocated for the instance
      mlxsw: spectrum_router: Introduce fib_entry priv for low-level ops
      mlxsw: spectrum_router: Track FIB entry committed state and skip uncommitted on delete
      mlxsw: spectrum_router: Introduce FIB entry update op
      mlxsw: spectrum_router: Reduce mlxsw_sp_ipip_fib_entry_op_gre4()
      mlxsw: reg: Add XM Direct Register
      mlxsw: reg: Add Router XLT Enable Register
      mlxsw: spectrum_router: Introduce XM implementation of router low-level ops
      mlxsw: pci: Obtain info about ports used by eXtended mezanine
      mlxsw: Ignore ports that are connected to eXtended mezanine
      mlxsw: reg: Add Router XLT M select Register
      mlxsw: reg: Add XM Lookup Table Query Register
      mlxsw: spectrum_router: Introduce per-ASIC XM initialization
      mlxsw: reg: Add XM Router M Table Register
      mlxsw: spectrum_router_xm: Implement L-value tracking for M-index
      mlxsw: reg: Add Router LPM Cache ML Delete Register
      mlxsw: reg: Add Router LPM Cache Enable Register
      mlxsw: spectrum_router_xm: Introduce basic XM cache flushing
      mlxsw: spectrum: Set KVH XLT cache mode for Spectrum2/3
      mlxsw: spectrum_router: Use eXtended mezzanine to offload IPv4 router

Jisheng Zhang (4):
      net: phy: microchip_t1: Don't set .config_aneg
      net: stmmac: dwc-qos: Change the dwc_eth_dwmac_data's .probe prototype
      net: stmmac: platform: use optional clk/reset get APIs
      mwifiex: Remove duplicated REG_PORT definition

Joakim Zhang (3):
      dt-bindings: can: fsl,flexcan: fix fsl,clk-source property
      dt-bindings: firmware: add IMX_SC_R_CAN(x) macro for CAN
      can: flexcan: rename macro FLEXCAN_QUIRK_SETUP_STOP_MODE -> FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR

Johannes Berg (42):
      wireless: remove CONFIG_WIRELESS_WDS
      ath9k: remove WDS code
      carl9170: remove WDS code
      b43: remove WDS code
      b43legacy: remove WDS code
      rt2x00: remove WDS code
      mac80211: remove WDS-related code
      cfg80211: remove WDS code
      nl80211: fix kernel-doc warning in the new SAE attribute
      iwlwifi: copy iwl_he_capa for modifications
      iwlwifi: validate MPDU length against notification length
      iwlwifi: pcie: validate RX descriptor length
      iwlwifi: mvm: clear up iwl_mvm_notify_rx_queue() argument type
      iwlwifi: mvm: move iwl_mvm_stop_device() out of line
      iwlwifi: pcie: change 12k A-MSDU config to use 16k buffers
      iwlwifi: mvm: fix 22000 series driver NMI
      iwlwifi: mvm: do more useful queue sync accounting
      iwlwifi: mvm: clean up scan state on failure
      iwlwifi: pcie: remove MSIX_HW_INT_CAUSES_REG_IML handling
      iwlwifi: fw: file: fix documentation for SAR flag
      iwlwifi: pcie: remove unnecessary setting of inta_mask
      iwlwifi: trans: consider firmware dead after errors
      iwlwifi: dbg-tlv: fix old length in is_trig_data_contained()
      iwlwifi: use SPDX tags
      iwlwifi: pcie: clean up some rx code
      iwlwifi: mvm: validate firmware sync response size
      iwlwifi: add an extra firmware state in the transport
      iwlwifi: support firmware reset handshake
      iwlwifi: mvm: disconnect if channel switch delay is too long
      iwlwifi: tighten RX MPDU bounds checks
      iwlwifi: mvm: hook up missing RX handlers
      iwlwifi: mvm: validate notification size when waiting
      mac80211: support MIC error/replay detected counters driver update
      mac80211: disallow band-switch during CSA
      cfg80211: include block-tx flag in channel switch started event
      cfg80211: remove struct ieee80211_he_bss_color
      mac80211: use struct assignment for he_obss_pd
      cfg80211: support immediate reconnect request hint
      mac80211: support driver-based disconnect with reconnect hint
      mac80211: don't set set TDLS STA bandwidth wider than possible
      mac80211: use bitfield helpers for BA session action frames
      mac80211: ignore country element TX power on 6 GHz

Jon Maloy (4):
      tipc: add stricter control of reserved service types
      tipc: refactor tipc_sk_bind() function
      tipc: make node number calculation reproducible
      tipc: update address terminology in code

Jonas Bonn (1):
      bareudp: constify device_type declaration

Jonathan Lemon (1):
      ptp: Add clock driver for the OpenCompute TimeCard.

Jose M. Guisado Gomez (3):
      netfilter: nf_reject: add reject skbuff creation helpers
      netfilter: nft_reject: unify reject init and dump into nft_reject
      netfilter: nft_reject: add reject verdict support for netdev

Jozsef Kadlecsik (3):
      netfilter: ipset: Support the -exist flag with the destroy command
      netfilter: ipset: Add bucketsize parameter to all hash types
      netfilter: ipset: Expose the initval hash parameter to userspace

Julia Lawall (1):
      mac80211: use semicolons rather than commas to separate statements

Julian Pidancet (1):
      Bluetooth: btusb: Add support for 1358:c123 Realtek 8822CE device

Julian Wiedmann (14):
      s390/qeth: reduce rtnl locking for switchdev events
      s390/qeth: tolerate error when querying card info
      s390/qeth: improve QUERY CARD INFO processing
      s390/qeth: set static link info during initialization
      s390/qeth: clean up default cases for ethtool link mode
      s390/qeth: use QUERY OAT for initial link info
      s390/qeth: improve selection of ethtool link modes
      s390/qeth: don't call INIT_LIST_HEAD() on iob's list entry
      s390/ccwgroup: use bus->dev_groups for bus-based sysfs attributes
      s390/qeth: use dev->groups for common sysfs attributes
      s390/qeth: don't replace a fully completed async TX buffer
      s390/qeth: remove QETH_QDIO_BUF_HANDLED_DELAYED state
      s390/qeth: make qeth_qdio_handle_aob() more robust
      net/af_iucv: use DECLARE_SOCKADDR to cast from sockaddr

KP Singh (22):
      bpf: Allow LSM programs to use bpf spin locks
      bpf: Implement task local storage
      libbpf: Add support for task local storage
      bpftool: Add support for task local storage
      bpf: Implement get_current_task_btf and RET_PTR_TO_BTF_ID
      bpf: Fix tests for local_storage
      bpf: Update selftests for local_storage to use vmlinux.h
      bpf: Add tests for task_local_storage
      bpf: Exercise syscall operations for inode and sk storage
      bpf: Augment the set of sleepable LSM hooks
      bpf: Expose bpf_d_path helper to sleepable LSM hooks
      bpf: Add bpf_bprm_opts_set helper
      bpf: Add tests for bpf_bprm_opts_set helper
      ima: Implement ima_inode_hash
      bpf: Add a BPF helper for getting the IMA hash of an inode
      bpf: Add a selftest for bpf_ima_inode_hash
      selftests/bpf: Fix flavored variants of test_ima
      selftests/bpf: Update ima_setup.sh for busybox
      selftests/bpf: Ensure securityfs mount before writing ima policy
      selftests/bpf: Add config dependency on BLK_DEV_LOOP
      selftests/bpf: Indent ima_setup.sh with tabs.
      selftests/bpf: Silence ima_setup.sh when not running in verbose mode.

Kai-Heng Feng (1):
      Bluetooth: btrtl: Ask 8821C to drop old firmware

Kaixu Xia (8):
      cxgb4: Fix the -Wmisleading-indentation warning
      net/mlx4: Assign boolean values to a bool variable
      net: atlantic: Remove unnecessary conversion to bool
      net: pch_gbe: remove unneeded variable retval in __pch_gbe_suspend
      s390/qeth: remove useless if/else
      can: mcp251xfd: remove useless code in mcp251xfd_chip_softreset
      rtlwifi: rtl8192de: remove the useless value assignment
      netfilter: Remove unnecessary conversion to bool

Kalle Valo (11):
      ath10k: remove repeated words in comments
      ath10k: ath10k_pci_init_irq(): workaround for checkpatch fallthrough warning
      ath11k: remove repeated words in comments and warnings
      Merge mhi-ath11k-immutable into ath-next
      ath11k: dp_rx: fix monitor status dma unmap direction
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      Merge tag 'mt76-for-kvalo-2020-12-04' of https://github.com/nbd168/wireless
      Merge tag 'iwlwifi-next-for-kalle-2020-12-09' of git://git.kernel.org/.../iwlwifi/iwlwifi-next
      ath11k: mhi: print a warning if firmware crashed
      ath11k: htc: remove unused struct ath11k_htc_ops
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git

Kamil Alkhouri (2):
      net: dsa: hellcreek: Add PTP clock support
      net: dsa: hellcreek: Add support for hardware timestamping

Karen Sornek (1):
      igbvf: Refactor traces

Karsten Graul (2):
      net/smc: improve return codes for SMC-Dv2
      net/smc: use helper smc_conn_abort() in listen processing

Karthikeyan Periyasamy (3):
      ath11k: Fix single phy hw mode
      ath11k: Fix the hal descriptor mask
      ath11k: fix wmi init configuration

Kiran K (5):
      Bluetooth: btintel: Fix endianness issue for TLV version information
      Bluetooth: btusb: Add *setup* function for new generation Intel controllers
      Bluetooth: btusb: Define a function to construct firmware filename
      Bluetooth: btusb: Helper function to download firmware to Intel adapters
      Bluetooth: btusb: Map Typhoon peak controller to BTUSB_INTEL_NEWGEN

Krzysztof Kozlowski (1):
      nfc: s3fwrn5: let core configure the interrupt trigger

Kurt Kanzenbach (8):
      net: dsa: Add tag handling for Hirschmann Hellcreek switches
      net: dsa: Add DSA driver for Hirschmann Hellcreek switches
      net: dsa: hellcreek: Add PTP status LEDs
      dt-bindings: Add vendor prefix for Hirschmann
      dt-bindings: net: dsa: Add documentation for Hellcreek switches
      MAINTAINERS: Add entry for Hirschmann Hellcreek Switch Driver
      net: dsa: tag_hellcreek: Cleanup includes
      net: dsa: hellcreek: Don't print error message on defer

Kurt Lee (1):
      ieee80211: Add definition for WFA DPP

Lavanya Suresh (1):
      ath11k: Add new dfs region name for JP

Lee Jones (61):
      net: fddi: skfp: ecm: Protect 'if' when AIX_EVENT is not defined
      net: fddi: skfp: ecm: Remove seemingly unused variable 'ID_sccs'
      net: fddi: skfp: pcmplc: Remove defined but not used variable 'ID_sccs'
      net: fddi: skfp: pmf: Remove defined but unused variable 'ID_sccs'
      net: fddi: skfp: queue: Remove defined but unused variable 'ID_sccs'
      net: fddi: skfp: rmt: Remove defined but unused variable 'ID_sccs'
      net: fddi: skfp: smtdef: Remove defined but unused variable 'ID_sccs'
      net: fddi: skfp: smtinit: Remove defined but unused variable 'ID_sccs'
      net: fddi: skfp: smttimer: Remove defined but unused variable 'ID_sccs'
      net: fddi: skfp: hwt: Remove defined but unused variable 'ID_sccs'
      net: fddi: skfp: srf: Remove defined but unused variable 'ID_sccs'
      net: fddi: skfp: drvfbi: Remove defined but unused variable 'ID_sccs'
      net: fddi: skfp: ess: Remove defined but unused variable 'ID_sccs'
      net: ieee802154: ca8210: Fix a bunch of kernel-doc issues
      net: usb: r8152: Provide missing documentation for some struct members
      net: ieee802154: ca8210: Fix incorrectly named function param doc
      net: usb: lan78xx: Remove lots of set but unused 'ret' variables
      net: macsec: Add missing documentation for 'gro_cells'
      net: macvlan: Demote nonconformant function header
      net: usb: r8152: Fix a couple of spelling errors in fw_phy_nc's docs
      net: netconsole: Add description for 'netconsole_target's extended attribute
      net: net_failover: Correct parameter name 'standby_dev'
      ath: regd: Provide description for ath_reg_apply_ir_flags's 'reg' param
      ath: dfs_pattern_detector: Fix some function kernel-doc headers
      ath: dfs_pri_detector: Demote zero/half completed kernel-doc headers
      ath9k: ar9330_1p1_initvals: Remove unused const variable 'ar9331_common_tx_gain_offset1_1'
      ath9k: ar9340_initvals: Remove unused const variable 'ar9340Modes_ub124_tx_gain_table_1p0'
      ath9k: ar9485_initvals: Remove unused const variable 'ar9485_fast_clock_1_1_baseband_postamble'
      ath9k: ar9003_2p2_initvals: Remove unused const variables
      ath9k: ar5008_phy: Demote half completed function headers
      ath9k: dynack: Demote non-compliant function header
      wil6210: wmi: Correct misnamed function parameter 'ptr_'
      rsi: rsi_91x_usb: Fix some basic kernel-doc issues
      rsi: rsi_91x_usb_ops: Source file headers are not good candidates for kernel-doc
      brcmfmac: bcmsdh: Fix description for function parameter 'pktlist'
      brcmfmac: pcie: Provide description for missing function parameter 'devinfo'
      brcmfmac: fweh: Add missing description for 'gfp'
      wl1251: cmd: Rename 'len' to 'buf_len' in the documentation
      prism54: isl_ioctl: Fix one function header and demote another
      wl3501_cs: Fix misspelling and provide missing documentation
      mwifiex: pcie: Remove a couple of unchecked 'ret's
      wlcore: spi: Demote a non-compliant function header, fix another
      rtw88: rtw8822c: Remove unused variable 'corr_val'
      rtlwifi: rtl8192cu: mac: Fix some missing/ill-documented function parameters
      rtlwifi: rtl8192cu: trx: Demote clear abuse of kernel-doc format
      rtlwifi: halbtc8723b2ant: Remove a bunch of set but unused variables
      rtlwifi: phy: Remove set but unused variable 'bbvalue'
      rtlwifi: halbtc8821a1ant: Remove set but unused variable 'wifi_rssi_state'
      rtlwifi: rtl8723be: Remove set but unused variable 'lc_cal'
      rtlwifi: rtl8188ee: Remove set but unused variable 'reg_ea4'
      rtlwifi: halbtc8821a2ant: Remove a bunch of unused variables
      rtlwifi: rtl8723be: Remove set but unused variable 'cck_highpwr'
      rtlwifi: rtl8821ae: phy: Remove a couple of unused variables
      rtlwifi: rtl8821ae: Place braces around empty if() body
      rtw88: pci: Add prototypes for .probe, .remove and .shutdown
      iwlwifi: mvm: rs: Demote non-conformant function documentation headers
      iwlwifi: iwl-eeprom-read: Demote one nonconformant function header
      iwlwifi: iwl-eeprom-parse: Fix 'struct iwl_eeprom_enhanced_txpwr's header
      iwlwifi: iwl-phy-db: Add missing struct member description for 'trans'
      iwlwifi: fw: dbg: Fix misspelling of 'reg_data' in function header
      iwlwifi: fw: acpi: Demote non-conformant function headers

Leon Romanovsky (11):
      Merge tag 'auxbus-5.11-rc1' of https://git.kernel.org/.../gregkh/driver-core into mlx5-next
      net/mlx5: Properly convey driver version to firmware
      net/mlx5_core: Clean driver version and name
      vdpa/mlx5: Make hardware definitions visible to all mlx5 devices
      net/mlx5: Register mlx5 devices to auxiliary virtual bus
      vdpa/mlx5: Connect mlx5_vdpa to auxiliary bus
      net/mlx5e: Connect ethernet part to auxiliary bus
      RDMA/mlx5: Convert mlx5_ib to use auxiliary bus
      net/mlx5: Delete custom device management logic
      net/mlx5: Simplify eswitch mode check
      RDMA/mlx5: Remove IB representors dead code

Lev Stipakov (3):
      net: openvswitch: use core API to update/provide stats
      net: xfrm: use core API for updating/providing stats
      net: mac80211: use core API for updating TX/RX stats

Li RongQing (1):
      libbpf: Add support for canceling cached_cons advance

Lijun Pan (1):
      ibmvnic: merge do_change_param_reset into do_reset

Loic Poulain (10):
      bus: mhi: Add mhi_queue_is_full function
      net: Add mhi-net driver
      net: qrtr: Fix port ID for control messages
      net: qrtr: Allow forwarded services
      net: qrtr: Allow non-immediate node routing
      net: qrtr: Add GFP flags parameter to qrtr_alloc_ctrl_packet
      net: qrtr: Release distant nodes along the bridge node
      bus: mhi: Remove auto-start option
      net: qrtr: Start MHI channels during init
      net: mhi: Fix unexpected queue wake

Lorenzo Bianconi (47):
      net: xdp: Introduce bulking for xdp tx return path
      net: page_pool: Add bulk support for ptr_ring
      net: mvneta: Add xdp tx return bulking support
      net: mvpp2: Add xdp tx return bulking support
      net: mlx5: Add xdp tx return bulking support
      net: netsec: add xdp tx return bulking support
      net: page_pool: Add page_pool_put_page_bulk() to page_pool.rst
      net: mvneta: avoid unnecessary xdp_buff initialization
      net: mvneta: move skb_shared_info in mvneta_xdp_put_buff caller
      net: mvneta: alloc skb_shared_info on the mvneta_rx_swbm stack
      mt76: mt7663s: move tx/rx processing in the same txrx workqueue
      mt76: mt7663s: convert txrx_work to mt76_worker
      mt76: mt7663s: disable interrupt during txrx_worker processing
      mt76: sdio: convert {status/net}_work to mt76_worker
      mt76: mt7615: enable beacon filtering by default for offload fw
      mt76: mt7615: introduce quota debugfs node for mt7663s
      mt76: mt7663s: get rid of mt7663s_sta_add
      mt76: mt7663s: fix a possible ple quota underflow
      mt76: sdio: get rid of sched.lock
      mt76: dma: fix possible deadlock running mt76_dma_cleanup
      mt76: fix memory leak if device probing fails
      mt76: move mt76_mcu_send_firmware in common module
      mt76: switch to wep sw crypto for mt7615/mt7915
      mt76: fix tkip configuration for mt7615/7663 devices
      mt76: mt7615: run key configuration in mt7615_set_key for usb/sdio devices
      mt76: mt76u: rely on woker APIs for rx work
      mt76: mt76u: use dedicated thread for status work
      mt76: mt7915: make mt7915_eeprom_read static
      mt76: mt7615: refactor usb/sdio rate code
      mt76: mt7915: rely on eeprom definitions
      mt76: move mt76_init_tx_queue in common code
      mt76: sdio: introduce mt76s_alloc_tx_queue
      mt76: sdio: rely on mt76_queue in mt76s_process_tx_queue signature
      mt76: mt7663s: rely on mt76_queue in mt7663s_tx_run_queue signature
      mt76: dma: rely on mt76_queue in mt76_dma_tx_cleanup signature
      mt76: rely on mt76_queue in tx_queue_skb signature
      mt76: introduce mt76_init_mcu_queue utility routine
      mt76: rely on mt76_queue in tx_queue_skb_raw signature
      mt76: move mcu queues to mt76_dev q_mcu array
      mt76: move tx hw data queues in mt76_phy
      mt76: move band capabilities in mt76_phy
      mt76: rely on mt76_phy in mt76_init_sband_2g and mt76_init_sband_5g
      mt76: move band allocation in mt76_register_phy
      mt76: move hw mac_addr in mt76_phy
      mt76: mt7915: introduce dbdc support
      mt76: mt7915: get rid of dbdc debugfs knob
      mt76: mt7615: fix rdd mcu cmd endianness

Luca Coelho (1):
      iwlwifi: mvm: add support for 6GHz

Luiz Augusto von Dentz (2):
      Bluetooth: Fix not sending Set Extended Scan Response
      Bluetooth: Rename get_adv_instance_scan_rsp

Lukas Bulwahn (5):
      ipv6: mcast: make annotations for ip6_mc_msfget() consistent
      net: cls_api: remove unneeded local variable in tc_dump_chain()
      ipv6: remove unused function ipv6_skb_idev()
      net/ipv6: propagate user pointer annotation
      bpf: Propagate __user annotations properly

Magnus Karlsson (7):
      samples/bpf: Increment Tx stats at sending
      i40e: Remove unnecessary sw_ring access from xsk Tx
      xsk: Introduce padding between more ring pointers
      xsk: Introduce batched Tx descriptor interfaces
      i40e: Use batched xsk Tx interfaces to increase performance
      libbpf: Replace size_t with __u32 in xsk interfaces
      samples/bpf: Fix possible hang in xdpsock with multiple threads

Maharaja Kennadyrajan (1):
      ath11k: Fix the rx_filter flag setting for peer rssi stats

Manivannan Sadhasivam (1):
      can: mcp251xfd: Add support for internal loopback mode

Marc Kleine-Budde (23):
      dt-bindings: can: fsl,flexcan: add uint32 reference to clock-frequency property
      can: flexcan: factor out enabling and disabling of interrupts into separate function
      can: flexcan: move enabling/disabling of interrupts from flexcan_chip_{start,stop}() to callers
      can: flexcan: flexcan_rx_offload_setup(): factor out mailbox and rx-offload setup into separate function
      can: flexcan: flexcan_open(): completely initialize controller before requesting IRQ
      can: flexcan: flexcan_close(): change order if commands to properly shut down the controller
      can: mcp251xfd: mcp25xxfd_ring_alloc(): add define instead open coding the maximum number of RX objects
      can: mcp251xfd: struct mcp251xfd_priv::tef to array of length 1
      can: mcp251xfd: move struct mcp251xfd_tef_ring definition
      can: mcp251xfd: tef-path: reduce number of SPI core requests to set UINC bit
      can: tcan4x5x: remove mram_start and reg_offset from struct tcan4x5x_priv
      can: tcan4x5x: tcan4x5x_can_probe(): remove probe failed error message
      can: m_can: Kconfig: convert the into menu
      can: m_can: remove not used variable struct m_can_classdev::freq
      can: m_can: m_can_plat_remove(): remove unneeded platform_set_drvdata()
      can: m_can: m_can_class_unregister(): move right after m_can_class_register()
      can: m_can: update link to M_CAN user manual
      can: m_can: convert indention to kernel coding style
      can: m_can: use cdev as name for struct m_can_classdev uniformly
      can: m_can: m_can_config_endisable(): mark as static
      can: m_can: m_can_clk_start(): make use of pm_runtime_resume_and_get()
      can: m_can: let m_can_class_allocate_dev() allocate driver specific private data
      can: m_can: use struct m_can_classdev as drvdata

Marcel Holtmann (2):
      Bluetooth: Increment management interface revision
      MAINTAINERS: Update Bluetooth entries

Marcelo Ricardo Leitner (1):
      net/sched: act_ct: enable stats for HW offloaded entries

Marcin Wojtas (1):
      MAINTAINERS: add mvpp2 driver entry

Marco Elver (1):
      net: switch to storing KCOV handle directly in sk_buff

Marek Majtyka (1):
      i40e: remove redundant assignment

Marek Vasut (3):
      rsi: Fix TX EAPOL packet handling against iwlwifi AP
      rsi: Move card interrupt handling to RX thread
      rsi: Clean up loop in the interrupt handler

Mariusz Dudek (2):
      libbpf: Separate XDP program load with xsk socket creation
      samples/bpf: Sample application for eBPF load and socket creation split

Markov Mikhail (1):
      rt2x00: save survey for every channel visited

Martin KaFai Lau (7):
      bpf: selftest: Use static globals in tcp_hdr_options and btf_skc_cls_ingress
      bpf: Fix NULL dereference in bpf_task_storage
      bpf: Folding omem_charge() into sk_storage_charge()
      bpf: Rename some functions in bpf_sk_storage
      bpf: Allow using bpf_sk_storage in FENTRY/FEXIT/RAW_TP
      bpf: selftest: Use bpf_sk_storage in FENTRY/FEXIT/RAW_TP
      bpf: Fix the irq and nmi check in bpf_sk_storage for tracing usage

Martin Schiller (6):
      net/tun: Call type change netdev notifiers
      net/x25: handle additional netdev events
      net/lapb: support netdev events
      net/lapb: fix t1 timer handling for LAPB_STATE_0
      net/x25: fix restart request/confirm handling
      net/x25: remove x25_kill_by_device()

Mat Martineau (1):
      docs: networking: mptcp: Add MPTCP sysctl entries

Mathy Vanhoef (5):
      mac80211: add radiotap flag to assure frames are not reordered
      mac80211: adhere to Tx control flag that prevents frame reordering
      mac80211: don't overwrite QoS TID of injected frames
      mac80211: assure that certain drivers adhere to DONT_REORDER flag
      ath9k_htc: adhere to the DONT_REORDER transmit flag

Matthias Brugger (1):
      brcmfmac: expose firmware config files through modinfo

Matti Gottlieb (1):
      iwlwifi: Add a new card for MA family

Mauro Carvalho Chehab (3):
      net: phy: fix kernel-doc markups
      net: datagram: fix some kernel-doc markups
      net: core: fix some kernel-doc markups

Max Chou (3):
      Bluetooth: btusb: Add the more support IDs for Realtek RTL8822CE
      Bluetooth: btrtl: Refine the ic_id_table for clearer and more regular
      Bluetooth: btusb: btrtl: Add support for RTL8852A

Maxim Mikityanskiy (1):
      net/mlx5e: Fill mlx5e_create_cq_param in a function

Meir Lichtinger (1):
      net/mlx5: Update the list of the PCI supported devices

Menglong Dong (8):
      net: macvlan: remove redundant initialization in macvlan_dev_netpoll_setup
      samples/bpf: Remove duplicate include in hbm
      net: udp: introduce UDP_MIB_MEMERRORS for udp_mem
      net: udp: remove redundant initialization in udp_send_skb
      net: udp: remove redundant initialization in udp_dump_one
      net: ipv4: remove redundant initialization in inet_rtm_deladdr
      net: sched: fix misspellings using misspell-fixer tool
      net: udp: remove redundant initialization in udp_gro_complete

Michael Chan (2):
      bnxt_en: Rearrange the logic in bnxt_flash_package_from_fw_obj().
      bnxt_en: Enable batch mode when using HWRM_NVM_MODIFY to flash packages.

Michael Grzeschik (11):
      net: dsa: microchip: ksz8795: remove unused last_port variable
      net: dsa: microchip: ksz8795: remove superfluous port_cnt assignment
      net: dsa: microchip: ksz8795: move variable assignments from detect to init
      net: dsa: microchip: ksz8795: use reg_mib_cnt where possible
      net: dsa: microchip: ksz8795: use mib_cnt where possible
      net: dsa: microchip: ksz8795: use phy_port_cnt where possible
      net: dsa: microchip: remove superfluous num_ports assignment
      net: dsa: microchip: ksz8795: align port_cnt usage with other microchip drivers
      net: dsa: microchip: remove usage of mib_port_count
      net: dsa: microchip: ksz8795: use port_cnt instead of TOTOAL_PORT_NUM
      net: dsa: microchip: ksz8795: use num_vlans where possible

Min Li (7):
      ptp: idt82p33: add adjphase support
      ptp: idt82p33: use i2c_master_send for bus write
      ptp: idt82p33: optimize _idt82p33_adjfine
      ptp: clockmatrix: reset device and check BOOT_STATUS
      ptp: clockmatrix: remove 5 second delay before entering write phase mode
      ptp: clockmatrix: Fix non-zero phase_adj is lost after snap
      ptp: clockmatrix: deprecate firmware older than 4.8.7

Mordechay Goodstein (9):
      iwlwifi: remove all queue resources before free
      iwlwifi: yoyo: add the ability to dump phy periphery
      iwlwifi: move reclaim flows to the queue file
      iwlwifi: mvm: Init error table memory to zero
      iwlwifi: enable sending/setting debug host event
      iwlwifi: avoid endless HW errors at assert time
      iwlwifi: fix typo in comment
      iwlwifi: mvm: iterate active stations when updating statistics
      iwlwifi: mvm: check that statistics TLV version match struct version

Moritz Fischer (1):
      net: dec: tulip: de2104x: Add shutdown handler to stop NIC

Muhammad Sammar (2):
      net/mlx5: Check dr mask size against mlx5_match_param size
      net/mlx5: Add misc4 to mlx5_ifc_fte_match_param_bits

Naftali Goldstein (1):
      iwlwifi: d3: do not send the WOWLAN_CONFIGURATION command for netdetect

Naveen Mamindlapalli (2):
      octeontx2-pf: Add support for SR-IOV management functions
      octeontx2-af: Add new mbox messages to retrieve MCAM entries

Nick Nunley (1):
      ice: Remove vlan_ena from vsi structure

Nicolas Rybowski (1):
      mptcp: attach subflow socket to parent cgroup

Nigel Christian (1):
      Bluetooth: hci_qca: resolve various warnings

Nikolay Aleksandrov (33):
      selftests: net: bridge: rename current igmp tests to igmpv2
      selftests: net: bridge: igmp: add support for packet source address
      selftests: net: bridge: igmp: check for specific udp ip protocol
      selftests: net: bridge: igmp: add IGMPv3 entries' state helpers
      selftests: net: bridge: add tests for igmpv3 is_include and inc -> allow reports
      selftests: net: bridge: add test for igmpv3 inc -> is_include report
      selftests: net: bridge: add test for igmpv3 inc -> is_exclude report
      selftests: net: bridge: add test for igmpv3 inc -> to_exclude report
      selftests: net: bridge: add test for igmpv3 exc -> allow report
      selftests: net: bridge: add test for igmpv3 exc -> is_include report
      selftests: net: bridge: add test for igmpv3 exc -> is_exclude report
      selftests: net: bridge: add test for igmpv3 exc -> to_exclude report
      selftests: net: bridge: add test for igmpv3 inc -> block report
      selftests: net: bridge: add test for igmpv3 exc -> block report
      selftests: net: bridge: add test for igmpv3 exclude timeout
      selftests: net: bridge: add test for igmpv3 *,g auto-add
      net: bridge: mcast: add support for raw L2 multicast groups
      selftests: net: bridge: factor out mcast_packet_test
      selftests: net: lib: add support for IPv6 mcast packet test
      selftests: net: bridge: factor out and rename sg state functions
      selftests: net: bridge: add initial MLDv2 include test
      selftests: net: bridge: add test for mldv2 inc -> allow report
      selftests: net: bridge: add test for mldv2 inc -> is_include report
      selftests: net: bridge: add test for mldv2 inc -> is_exclude report
      selftests: net: bridge: add test for mldv2 inc -> to_exclude report
      selftests: net: bridge: add test for mldv2 exc -> allow report
      selftests: net: bridge: add test for mldv2 exc -> is_include report
      selftests: net: bridge: add test for mldv2 exc -> is_exclude report
      selftests: net: bridge: add test for mldv2 exc -> to_exclude report
      selftests: net: bridge: add test for mldv2 inc -> block report
      selftests: net: bridge: add test for mldv2 exc -> block report
      selftests: net: bridge: add test for mldv2 exclude timeout
      selftests: net: bridge: add test for mldv2 *,g auto-add

Numan Siddique (1):
      net: openvswitch: Be liberal in tcp conntrack.

Ole Bjørn Midtbø (1):
      Bluetooth: hidp: use correct wait queue when removing ctrl_wait

Oleksij Rempel (1):
      net: phy: micrel: fix interrupt handling

Oliver Hartkopp (10):
      can: add optional DLC element to Classical CAN frame structure
      can: rename get_can_dlc() macro with can_cc_dlc2len()
      can: remove obsolete get_canfd_dlc() macro
      can: replace can_dlc as variable/element for payload length
      can: rename CAN FD related can_len2dlc and can_dlc2len helpers
      can: update documentation for DLC usage in Classical CAN
      can: drivers: introduce helpers to access Classical CAN DLC values
      can: drivers: add len8_dlc support for various CAN adapters
      can: gw: support modification of Classical CAN DLCs
      can: isotp: add SF_BROADCAST support for functional addressing

Oliver Herms (2):
      IPv4: RTM_GETROUTE: Add RTA_ENCAP to result
      IPv6: RTM_GETROUTE: Add RTA_ENCAP to result

P Praneesh (1):
      ath11k: add processor_id based ring_selector logic

Pablo Neira Ayuso (6):
      netfilter: nft_reject_inet: allow to use reject from inet ingress
      net: sched: incorrect Kconfig dependencies on Netfilter modules
      netfilter: nftables: generalize set expressions support
      netfilter: nftables: move nft_expr before nft_set
      netfilter: nftables: generalize set extension to support for several expressions
      netfilter: nftables: netlink support for several set element expressions

Paolo Abeni (30):
      tcp: propagate MPTCP skb extensions on xmit splits
      tcp: factor out tcp_build_frag()
      mptcp: use tcp_build_frag()
      tcp: factor out __tcp_close() helper
      mptcp: introduce mptcp_schedule_work
      mptcp: reduce the arguments of mptcp_sendmsg_frag
      mptcp: add accounting for pending data
      mptcp: introduce MPTCP snd_nxt
      mptcp: refactor shutdown and close
      mptcp: move page frag allocation in mptcp_sendmsg()
      mptcp: try to push pending data on snd una updates
      mptcp: send explicit ack on delayed ack_seq incr
      mptcp: update rtx timeout only if required.
      net: add annotation for sock_{lock,unlock}_fast
      mptcp: drop WORKER_RUNNING status bit
      mptcp: fix state tracking for fallback socket
      mptcp: keep unaccepted MPC subflow into join list
      mptcp: refine MPTCP-level ack scheduling
      mptcp: be careful on MPTCP-level ack.
      mptcp: open code mptcp variant for lock_sock
      mptcp: implement wmem reservation
      mptcp: protect the rx path with the msk socket spinlock
      mptcp: allocate TX skbs in msk context
      mptcp: avoid a few atomic ops in the rx path
      mptcp: use mptcp release_cb for delayed tasks
      mptcp: link MPC subflow into msk only after accept
      mptcp: plug subflow context memory leak
      mptcp: be careful on subflows shutdown
      mptcp: pm: simplify select_local_address()
      mptcp: let MPTCP create max size skbs

Parav Pandit (6):
      net/mlx5: Avoid exposing driver internal command helpers
      net/mlx5: Update the hardware interface definition for vhca state
      net/mlx5: Make API mlx5_core_is_ecpf accept const pointer
      net/mlx5: Rename peer_pf to host_pf
      net/mlx5: Enable host PF HCA after eswitch is initialized
      net/mlx5: Treat host PF vport as other (non eswitch manager) vport

Parshuram Thombare (2):
      net: macb: add support for high speed interface
      net: macb: fix NULL dereference due to no pcs_config method

Patrik Flykt (1):
      can: m_can: move runtime PM enable/disable to m_can_platform

Paul M Stillwell Jr (1):
      ice: don't always return an error for Get PHY Abilities AQ command

Pavan Chebbi (3):
      bnxt_en: Refactor bnxt_flash_nvram.
      bnxt_en: Restructure bnxt_flash_package_from_fw_obj() to execute in a loop.
      bnxt_en: Retry installing FW package under NO_SPACE error condition.

Peilin Ye (1):
      Bluetooth: Fix slab-out-of-bounds read in hci_le_direct_adv_report_evt()

Petr Machata (2):
      mlxsw: spectrum: Bump minimum FW version to xx.2008.2018
      selftests: forwarding: Add Q-in-VNI test

Ping-Ke Shih (4):
      rtw88: 8723d: add cck pd seetings
      rtw88: add CCK_PD debug log
      rtw88: fix multiple definition of rtw_pm_ops
      rtlwifi: rtl8192de: fix ofdm power compensation

Po-Hsu Lin (3):
      selftests: pmtu.sh: use $ksft_skip for skipped return code
      selftests: pmtu.sh: improve the test result processing
      selftests: test_vxlan_under_vrf: mute unnecessary error message

Pradeep Kumar Chitrapu (5):
      mac80211: save HE oper info in BSS config for mesh
      ath11k: fix incorrect wmi param for configuring HE operation
      ath11k: support TXOP duration based RTS threshold
      ath11k: mesh: add support for 256 bitmap in blockack frames in 11ax
      ath11k: Fix incorrect tlvs in scan start command

Prankur gupta (2):
      bpf: Adds support for setting window clamp
      selftests/bpf: Add Userspace tests for TCP_WINDOW_CLAMP

Qinglang Miao (1):
      cw1200: fix missing destroy_workqueue() on error in cw1200_init_common

Radhey Shyam Pandey (1):
      net: xilinx: axiethernet: Introduce helper functions for MDC enable/disable

Rajkumar Manoharan (2):
      nl80211: fix beacon tx rate mask validation
      cfg80211: add support to configure HE MCS for beacon rate

Rakesh Babu (4):
      octeontx2-af: Manage new blocks in 98xx
      octeontx2-af: Initialize NIX1 block
      octeontx2-af: Display NIX1 also in debugfs
      octeontx2-af: Display CGX, NIX and PF map in debugfs.

Rakesh Pillai (1):
      ath10k: Fix the parsing error in service available event

Ramya Gnanasekar (1):
      ath11k: Fix beamformee STS in HE cap

Randy Dunlap (14):
      net: kcov: don't select SKB_EXTENSIONS when there is no NET
      net: linux/skbuff.h: combine SKB_EXTENSIONS + KCOV handling
      net: stream: fix TCP references when INET is not enabled
      netfilter: nft_reject_bridge: fix build errors due to code movement
      net/tipc: fix tipc header files for kernel-doc
      net/tipc: fix various kernel-doc warnings
      net/tipc: fix bearer.c for kernel-doc
      net/tipc: fix link.c kernel-doc
      net/tipc: fix name_distr.c kernel-doc
      net/tipc: fix name_table.c kernel-doc
      net/tipc: fix node.c kernel-doc
      net/tipc: fix socket.c kernel-doc
      net/tipc: fix all function Return: notation
      net/tipc: add TIPC chapter to networking Documentation

Rasmus Villemoes (2):
      net: dsa: print the MTU value that could not be set
      net: dsa: mv88e6xxx: don't set non-existing learn2all bit for 6220/6250

Remi Depommier (2):
      brcmfmac: fix SDIO access for big-endian host
      brcmfmac: Fix incorrect type in assignment

Reo Shiseki (1):
      Bluetooth: fix typo in struct name

Rikard Falkeborn (2):
      soc: qcom: ipa: Constify static qmi structs
      ath10k: Constify static qmi structs

Ritesh Singh (3):
      ath11k: vdev delete synchronization with firmware
      ath11k: peer delete synchronization with firmware
      ath11k: remove "ath11k_mac_get_ar_vdev_stop_status" references

Robert Hancock (3):
      net: phylink: disable BMCR_ISOLATE in phylink_mii_c22_pcs_config
      net: phy: marvell: add special handling of Finisar modules with 88E1111
      net: axienet: Properly handle PCS/PMA PHY for 1000BaseX mode

Rohan Dutta (1):
      cfg80211: Add support to configure SAE PWE value to drivers

Rohit Maheshwari (1):
      net/tls: make sure tls offload sets salt_size

Roman Gushchin (34):
      mm: memcontrol: Use helpers to read page's memcg data
      mm: memcontrol/slab: Use helpers to access slab page's memcg_data
      mm: Introduce page memcg flags
      mm: Convert page kmemcg type to a page memcg flag
      bpf: Memcg-based memory accounting for bpf progs
      bpf: Prepare for memcg-based memory accounting for bpf maps
      bpf: Memcg-based memory accounting for bpf maps
      bpf: Refine memcg-based memory accounting for arraymap maps
      bpf: Refine memcg-based memory accounting for cpumap maps
      bpf: Memcg-based memory accounting for cgroup storage maps
      bpf: Refine memcg-based memory accounting for devmap maps
      bpf: Refine memcg-based memory accounting for hashtab maps
      bpf: Memcg-based memory accounting for lpm_trie maps
      bpf: Memcg-based memory accounting for bpf ringbuffer
      bpf: Memcg-based memory accounting for bpf local storage maps
      bpf: Refine memcg-based memory accounting for sockmap and sockhash maps
      bpf: Refine memcg-based memory accounting for xskmap maps
      bpf: Eliminate rlimit-based memory accounting for arraymap maps
      bpf: Eliminate rlimit-based memory accounting for bpf_struct_ops maps
      bpf: Eliminate rlimit-based memory accounting for cpumap maps
      bpf: Eliminate rlimit-based memory accounting for cgroup storage maps
      bpf: Eliminate rlimit-based memory accounting for devmap maps
      bpf: Eliminate rlimit-based memory accounting for hashtab maps
      bpf: Eliminate rlimit-based memory accounting for lpm_trie maps
      bpf: Eliminate rlimit-based memory accounting for queue_stack_maps maps
      bpf: Eliminate rlimit-based memory accounting for reuseport_array maps
      bpf: Eliminate rlimit-based memory accounting for bpf ringbuffer
      bpf: Eliminate rlimit-based memory accounting for sockmap and sockhash maps
      bpf: Eliminate rlimit-based memory accounting for stackmap maps
      bpf: Eliminate rlimit-based memory accounting for xskmap maps
      bpf: Eliminate rlimit-based memory accounting for bpf local storage maps
      bpf: Eliminate rlimit-based memory accounting infra for bpf maps
      bpf: Eliminate rlimit-based memory accounting for bpf progs
      bpf: samples: Do not touch RLIMIT_MEMLOCK

Rotem Saado (1):
      iwlwifi: yoyo: align the write pointer to DWs

Russell King (3):
      net: dsa: mv88e6xxx: fix vlan setup
      net: sfp: VSOL V2801F / CarlitoxxPro CPGOS03-0490 v2.0 workaround
      net: sfp: relax bitrate-derived mode check

Ryder Lee (8):
      mt76: mt7915: measure channel noise and report it via survey
      mt76: mt7915: fix VHT LDPC capability
      mt76: mt7915: update ppe threshold
      mt76: mt7915: rename mt7915_mcu_get_rate_info to mt7915_mcu_get_tx_rate
      mt76: mt7915: fix sparse warning cast from restricted __le16
      mt76: mt7915: use BIT_ULL for omac_idx
      mt76: mt7915: remove unused mt7915_mcu_bss_sync_tlv()
      mt76: mt7615: support 16 interfaces

Saeed Mahameed (2):
      net/mlx4: Cleanup kernel-doc warnings
      net/mlx5: Cleanup kernel-doc warnings

Sami Tolvanen (1):
      cfg80211: fix callback type mismatches in wext-compat

Santucci Pierpaolo (1):
      selftest/bpf: Fix IPV6FR handling in flow dissector

Sara Sharon (1):
      iwlwifi: mvm: fix a race in CSA that caused assert 0x3420

Sasha Neftin (1):
      igc: Add new device ID

Sathish Narasimman (1):
      Bluetooth: Fix: LL PRivacy BLE device fails to connect

Sean Nyekjaer (2):
      can: tcan4x5x: tcan4x5x_clear_interrupts(): remove redundant return statement
      can: m_can: m_can_config_endisable(): remove double clearing of clock stop request bit

Sean Wang (1):
      mt76: mt7663s: introduce WoW support via GPIO

Sebastian Andrzej Siewior (33):
      net: neterion: s2io: Replace in_interrupt() for context detection
      net: forcedeth: Replace context and lock check with a lockdep_assert()
      net: tlan: Replace in_irq() usage
      soc/fsl/qbman: Add an argument to signal if NAPI processing is required.
      net: dpaa: Replace in_irq() usage.
      crypto: caam: Replace in_irq() usage.
      net: mlx5: Replace in_irq() usage
      orinoco: Remove BUG_ON(in_interrupt/irq())
      airo: Invoke airo_read_wireless_stats() directly
      airo: Always use JOB_STATS and JOB_EVENT
      airo: Replace in_atomic() usage.
      hostap: Remove in_atomic() check.
      zd1211rw: Remove in_atomic() usage.
      rtlwifi: Remove in_interrupt() usage in is_any_client_connect_to_ap().
      rtlwifi: Remove in_interrupt() usage in halbtc_send_bt_mp_operation()
      atm: nicstar: Replace in_interrupt() usage
      atm: lanai: Remove in_interrupt() usage
      orinoco: Move context allocation after processing the skb
      orinoco: Prepare stubs for in_interrupt() removal
      orinoco: Annotate ezusb_xmit()
      orinoco: Annotate ezusb_init()
      orinoco: Annotate firmware loading
      orinoco: Annotate ezusb_read_pda()
      orinoco: Annotate ezusb_write_ltv()
      orinoco: Remove ezusb_doicmd_wait()
      orinoco: Annotate ezusb_docmd_wait()
      orinoco: Annotate ezusb_read_ltv()
      s390/ctcm: Avoid temporary allocation of struct th_header and th_sweep.
      s390/ctcm: Avoid temporary allocation of struct qllc.
      s390/ctcm: Avoid temporary allocation of struct pdu.
      s390/ctcm: Use explicit allocation mask in ctcmpc_unpack_skb().
      s390/ctcm: Use GFP_KERNEL in add_channel().
      s390/ctcm: Use GFP_ATOMIC in ctcmpc_tx().

Seevalamuthu Mariappan (1):
      ath11k: Ignore resetting peer auth flag in peer assoc cmd

SeongJae Park (1):
      inet: frags: batch fqdir destroy works

Sergej Bauer (1):
      lan743x: fix for potential NULL pointer dereference with bare card

Sergey Shtylyov (1):
      Bluetooth: consolidate error paths in hci_phy_link_complete_evt()

Seung-Woo Kim (1):
      brcmfmac: Fix memory leak for unpaired brcmf_{alloc/free}

Shannon Nelson (10):
      ionic: start queues before announcing link up
      ionic: check for link after netdev registration
      ionic: add lif quiesce
      ionic: batch rx buffer refilling
      ionic: use mc sync for multicast filters
      ionic: flatten calls to ionic_lif_rx_mode
      ionic: change set_rx_mode from_ndo to can_sleep
      ionic: useful names for booleans
      ionic: remove some unnecessary oom messages
      ionic: change mtu after queues are stopped

Shaul Triebitz (1):
      mac80211: he: remove non-bss-conf fields from bss_conf

Shay Agroskin (9):
      net: ena: use constant value for net_device allocation
      net: ena: add device distinct log prefix to files
      net: ena: store values in their appropriate variables types
      net: ena: fix coding style nits
      net: ena: aggregate stats increase into a function
      net: ena: use xdp_frame in XDP TX flow
      net: ena: introduce XDP redirect implementation
      net: ena: use xdp_return_frame() to free xdp frames
      net: ena: introduce ndo_xdp_xmit() function for XDP_REDIRECT

Shay Drory (1):
      net/mlx5: Arm only EQs with EQEs

Shayne Chen (12):
      mt76: testmode: switch ib and wb rssi to array type for per-antenna report
      mt76: testmode: add snr attribute in rx statistics
      mt76: testmode: add tx_rate_stbc parameter
      mt76: testmode: add support for LTF and GI combinations for HE mode
      mt76: mt7915: fix tx rate related fields in tx descriptor
      mt76: testmode: add support for HE rate modes
      mt76: mt7915: implement testmode tx support
      mt76: mt7915: implement testmode rx support
      mt76: mt7915: add support to set txpower in testmode
      mt76: mt7915: add support to set tx frequency offset in testmode
      mt76: mt7915: fix memory leak in mt7915_mcu_get_rx_rate()
      mt76: mt7915: fix ht mcs in mt7915_mcu_get_rx_rate()

Simon Horman (1):
      nfp: Replace zero-length array with flexible-array member

Simon Perron Caissy (1):
      ice: Add space to unknown speed

Simon Wunderlich (2):
      batman-adv: Start new development cycle
      batman-adv: Drop unused soft-interface.h include in fragmentation.c

Song Liu (3):
      bpf: Use separate lockdep class for each hashtab
      bpf: Avoid hashtab deadlock with map_locked
      bpf: Simplify task_file_seq_get_next()

Souptick Joarder (1):
      mt76: remove unused variable q

Srujana Challa (3):
      octeontx2-pf: move lmt flush to include/linux/soc
      octeontx2-af: add mailbox interface for CPT
      octeontx2-af: add debugfs entries for CPT block

Stanislav Fomichev (5):
      selftests/bpf: Rewrite test_sock_addr bind bpf into C
      bpf: Allow bpf_{s,g}etsockopt from cgroup bind{4,6} hooks
      selftests/bpf: Extend bind{4,6} programs with a call to bpf_setsockopt
      selftests/bpf: Copy file using read/write in local storage test
      libbpf: Cap retries in sys_bpf_prog_load

Stanislaw Kardach (1):
      octeontx2-af: Modify default KEX profile to extract TX packet fields

Steen Hegelund (1):
      net: phy: mscc: Add PTP support for 2 more VSC PHYs

Stefan Assmann (1):
      i40e: report correct VF link speed when link state is set to enable

Stefan Chulski (1):
      net: mvpp2: divide fifo for dts-active ports only

Stefan Mätje (1):
      can: drivers: add len8_dlc support for esd_usb2 CAN adapter

Subash Abhinov Kasiviswanathan (1):
      net: qualcomm: rmnet: Update rmnet device MTU based on real device

Subbaraya Sundeep (12):
      octeontx2-af: Update get/set resource count functions
      octeontx2-af: Map NIX block from CGX connection
      octeontx2-af: Setup MCE context for assigned NIX
      octeontx2-af: Add NIX1 interfaces to NPC
      octeontx2-af: Mbox changes for 98xx
      octeontx2-pf: Calculate LBK link instead of hardcoding
      octeontx2-af: Verify MCAM entry channel and PF_FUNC
      octeontx2-af: Generate key field bit mask from KEX profile
      octeontx2-af: Add mbox messages to install and delete MCAM rules
      octeontx2-pf: Add support for ethtool ntuple filters
      octeontx2-af: Add debugfs entry to dump the MCAM rules
      octeontx2-af: Delete NIX_RXVLAN_ALLOC mailbox message

Sukadev Bhattiprolu (1):
      ibmvnic: add some debugs

Sven Eckelmann (13):
      dt: bindings: add new dt entry for ath11k calibration variant
      ath11k: search DT for qcom,ath11k-calibration-variant
      ath11k: Initialize complete alpha2 for regulatory change
      ath11k: Fix number of rules in filtered ETSI regdomain
      ath11k: Don't cast ath11k_skb_cb to ieee80211_tx_info.control
      ath11k: Reset ath11k_skb_cb before setting new flags
      ath11k: Build check size of ath11k_skb_cb
      batman-adv: Add new include for min/max helpers
      batman-adv: Prepare infrastructure for newlink settings
      batman-adv: Allow selection of routing algorithm over rtnetlink
      batman-adv: Drop deprecated sysfs support
      batman-adv: Drop deprecated debugfs support
      batman-adv: Drop legacy code for auto deleting mesh interfaces

Sven Van Asbroeck (3):
      lan743x: replace devicetree phy parse code with library function
      lan743x: clean up software_isr function
      lan743x: replace polling loop by wait_event_timeout()

Taehee Yoo (2):
      mt76: mt7915: set fops_sta_stats.owner to THIS_MODULE
      mt76: set fops_tx_stats.owner to THIS_MODULE

Tamizh Chelvam (1):
      ath10k: fix compilation warning

Tanner Love (2):
      net/packet: make packet_fanout.arr size configurable up to 64K
      selftests/net: test max_num_members, fanout_args in psock_fanout

Tariq Toukan (4):
      net/mlx4_en: Remove unused performance counters
      net/mlx4: Remove unused #define MAX_MSIX_P_PORT
      net/mlx5e: Free drop RQ in a dedicated function
      net: Disable NETIF_F_HW_TLS_TX when HW_CSUM is disabled

Thierry Reding (1):
      net: ipconfig: Avoid spurious blank lines in boot log

Thomas Falcon (5):
      ibmvnic: Introduce indirect subordinate Command Response Queue buffer
      ibmvnic: Introduce batched RX buffer descriptor transmission
      ibmvnic: Introduce xmit_more support using batched subCRQ hcalls
      ibmvnic: Clean up TX code and TX buffer data structure
      ibmvnic: Remove send_subcrq function

Thomas Karlsson (1):
      macvlan: Support for high multicast packet rate

Tian Tao (1):
      wlcore: Switch to using the new API kobj_to_dev()

Tim Jiang (1):
      Bluetooth: btusb: support download nvm with different board id for wcn6855

Tobias Waldekranz (5):
      net: dsa: mv88e6xxx: Export VTU as devlink region
      net: dsa: mv88e6xxx: Add helper to get a chip's max_vid
      net: dsa: tag_dsa: Allow forwarding of redirected IGMP traffic
      net: dsa: tag_dsa: Unify regular and ethertype DSA taggers
      net: dsa: tag_dsa: Use a consistent comment style

Toke Høiland-Jørgensen (2):
      libbpf: Sanitise map names before pinning
      inet_ecn: Use csum16_add() helper for IP_ECN_set_* helpers

Tokunori Ikegami (2):
      rtl8xxxu: Add Buffalo WI-U3-866D to list of supported devices
      Revert "rtl8xxxu: Add Buffalo WI-U3-866D to list of supported devices"

Tom Parkin (2):
      ppp: add PPPIOCBRIDGECHAN and PPPIOCUNBRIDGECHAN ioctls
      docs: update ppp_generic.rst to document new ioctls

Tom Rix (15):
      tipc: remove unneeded semicolon
      ethtool: remove unneeded semicolon
      net: core: remove unneeded semicolon
      net: stmmac: dwmac-meson8b: remove unneeded semicolon
      net/mlx4_core : remove unneeded semicolon
      net: dsa: mt7530: remove unneeded semicolon
      wireless: remove unneeded break
      net: wan: remove trailing semicolon in macro definition
      airo: remove trailing semicolon in macro definition
      wl1251: remove trailing semicolon in macro definition
      bpf: Remove trailing semicolon in macro definition
      net: bna: remove trailing semicolon in macro definition
      ath9k: remove trailing semicolon in macro definition
      carl9170: remove trailing semicolon in macro definition
      mac80211: remove trailing semicolon in macro definitions

Tsuchiya Yuto (3):
      mwifiex: fix mwifiex_shutdown_sw() causing sw reset failure
      mwifiex: update comment for shutdown_sw()/reinit_sw() to reflect current state
      mwifiex: pcie: skip cancel_work_sync() on reset failure path

Ursula Maplehurst (1):
      can: mcp25xxfd: rx-path: reduce number of SPI core requests to set UINC bit

Vadim Fedorenko (5):
      net/tls: make inline helpers protocol-aware
      net/tls: add CHACHA20-POLY1305 specific defines and structures
      net/tls: add CHACHA20-POLY1305 specific behavior
      net/tls: add CHACHA20-POLY1305 configuration
      selftests/tls: add CHACHA20-POLY1305 to tls selftests

Vamsi Attunuru (1):
      octeontx2-af: Modify nix_vtag_cfg mailbox to support TX VTAG entries

Vamsi Krishna (1):
      cfg80211: Add support to calculate and report 4096-QAM HE rates

Vasanthakumar Thiagarajan (1):
      ath11k: Remove unnecessary data sync to cpu on monitor buffer

Vasily Averin (1):
      net: drop bogus skb with CHECKSUM_PARTIAL and offset beyond end of trimmed packet

Venkata Lakshmi Narayana Gubba (2):
      Bluetooth: hci_qca: Wait for timeout during suspend
      Bluetooth: btqca: Use NVM files based on SoC ID for WCN3991

Venkateswara Naralasetty (1):
      ath10k: add target IRAM recovery feature support

Veronika Kabatova (1):
      selftests/bpf: Drop tcp-{client,server}.py from Makefile

Vinay Kumar Yadav (1):
      chelsio/chtls: Utilizing multiple rxq/txq to process requests

Vincent Bernat (3):
      net: evaluate net.ipvX.conf.all.ignore_routes_with_linkdown
      net: evaluate net.ipv4.conf.all.proxy_arp_pvlan
      net: evaluate net.ipvX.conf.all.disable_policy and disable_xfrm

Vincent Whitchurch (1):
      net: stmmac: Use hrtimer for TX coalescing

Vineetha G. Jaya Kumaran (1):
      net: stmmac: Enable EEE HW LPI timer with auto SW/HW switching

Vlad Buslov (3):
      net: sched: implement action-specific terse dump
      net: sched: alias action flags with TCA_ACT_ prefix
      net: sched: remove redundant 'rtnl_held' argument

Vladimir Oltean (27):
      net: bridge: explicitly convert between mdb entry state and port group flags
      net: mscc: ocelot: classify L2 mdb entries as LOCKED
      net: mscc: ocelot: use ether_addr_copy
      net: mscc: ocelot: remove the "new" variable in ocelot_port_mdb_add
      net: mscc: ocelot: make entry_type a member of struct ocelot_multicast
      net: mscc: ocelot: support L2 multicast entries
      net: bridge: mcast: fix stub definition of br_multicast_querier_exists
      net: mscc: ocelot: use the pvid of zero when bridged with vlan_filtering=0
      net: mscc: ocelot: don't reset the pvid to 0 when deleting it
      net: mscc: ocelot: transform the pvid and native vlan values into a structure
      net: mscc: ocelot: add a "valid" boolean to struct ocelot_vlan
      net: mscc: ocelot: move the logic to drop 802.1p traffic to the pvid deletion
      net: mscc: ocelot: deny changing the native VLAN from the prepare phase
      net: dsa: felix: improve the workaround for multiple native VLANs on NPI port
      net: dsa: implement a central TX reallocation procedure
      net: dsa: tag_qca: let DSA core deal with TX reallocation
      net: dsa: tag_ocelot: let DSA core deal with TX reallocation
      net: dsa: tag_mtk: let DSA core deal with TX reallocation
      net: dsa: tag_lan9303: let DSA core deal with TX reallocation
      net: dsa: tag_edsa: let DSA core deal with TX reallocation
      net: dsa: tag_brcm: let DSA core deal with TX reallocation
      net: dsa: tag_dsa: let DSA core deal with TX reallocation
      net: dsa: tag_gswip: let DSA core deal with TX reallocation
      net: dsa: tag_ar9331: let DSA core deal with TX reallocation
      net: dsa: Give drivers the chance to veto certain upper devices
      net: delete __dev_getfirstbyhwtype
      net: mscc: ocelot: install MAC addresses in .ndo_set_rx_mode from process context

Vladyslav Tarasiuk (1):
      net/mlx5e: Validate stop_room size upon user input

Voon Weifeng (1):
      stmmac: intel: change all EHL/TGL to auto detect phy addr

Wang Hai (2):
      qtnfmac: fix error return code in qtnf_pcie_probe()
      net: bridge: Fix a warning when del bridge sysfs

Wang Qing (4):
      net: core: fix spelling typo in flow_dissector.c
      net: usb: fix spelling typo in cdc_ncm.c
      bpf, btf: Remove the duplicate btf_ids.h include
      rtlwifi: fix spelling typo of workaround

Wang Shanker (1):
      netfilter: nfnl_acct: remove data from struct net

Wedson Almeida Filho (1):
      bpf: Refactor check_cfg to use a structured loop.

Wei Yongjun (1):
      Bluetooth: sco: Fix crash when using BT_SNDMTU/BT_RCVMTU option

WeitaoWangoc (1):
      rtlwifi: Fix non-canonical address access issues

Wen Gong (5):
      ath10k: cancel rx worker in hif_stop for SDIO
      ath10k: fix a check patch warning returnNonBoolInBooleanFunction of sdio.c
      mac80211: mlme: save ssid info to ieee80211_bss_conf while assoc
      mac80211: fix a mistake check for rx_stats update
      ath10k: add atomic protection for device recovery

Wenlin Kang (1):
      tipc: fix -Wstringop-truncation warnings

Weqaar Janjua (6):
      selftests/bpf: Xsk selftests framework
      selftests/bpf: Xsk selftests - SKB POLL, NOPOLL
      selftests/bpf: Xsk selftests - DRV POLL, NOPOLL
      selftests/bpf: Xsk selftests - Socket Teardown - SKB, DRV
      selftests/bpf: Xsk selftests - Bi-directional Sockets - SKB, DRV
      selftests/bpf: Xsk selftests - adding xdpxceiver to .gitignore

Willy Liu (1):
      net: phy: realtek: Add support for RTL8221B-CG series

Willy Tarreau (1):
      Revert "macb: support the two tx descriptors on at91rm9200"

Wong Vee Khee (1):
      net: stmmac: allow stmmac to probe for C45 PHY devices

Xiaolei Wang (1):
      Bluetooth: hci_ll: add a small delay for wl1271 enable bt_en

Xie He (12):
      net: hdlc_fr: Simpify fr_rx by using "goto rx_drop" to drop frames
      net: hdlc_fr: Change the use of "dev" in fr_rx to make the code cleaner
      net: hdlc_fr: Do skb_reset_mac_header for skbs received on normal PVC devices
      net: hdlc_fr: Improve the initial checks when we receive an skb
      net: hdlc_fr: Add support for any Ethertype
      net: x25_asy: Delete the x25_asy driver
      net: wan: Delete the DLCI / SDLA drivers
      Documentation: Remove the deleted "framerelay" document from the index
      net: hdlc_x25: Remove unnecessary skb_reset_network_header calls
      net: x25: Fix handling of Restart Request and Restart Confirmation
      net: lapbether: Consider it successful if (dis)connecting when already (dis)connected
      net: x25: Remove unimplemented X.25-over-LLC code stubs

Xin Long (18):
      udp: check udp sock encap_type in __udp_lib_err
      udp6: move the mss check after udp gso tunnel processing
      udp: support sctp over udp in skb_udp_tunnel_segment
      sctp: create udp4 sock and add its encap_rcv
      sctp: create udp6 sock and set its encap_rcv
      sctp: add encap_err_lookup for udp encap socks
      sctp: add encap_port for netns sock asoc and transport
      sctp: add SCTP_REMOTE_UDP_ENCAPS_PORT sockopt
      sctp: allow changing transport encap_port by peer packets
      sctp: add udphdr to overhead when udp_port is set
      sctp: call sk_setup_caps in sctp_packet_transmit instead
      sctp: support for sending packet over udp4 sock
      sctp: support for sending packet over udp6 sock
      sctp: add the error cause for new encapsulation port restart
      sctp: handle the init chunk matching an existing asoc
      sctp: enable udp tunneling socks
      net: ipv6: For kerneldoc warnings with W=1
      sctp: bring inet(6)_skb_parm back to sctp_input_cb

Xu Wang (2):
      vxge: remove unnecessary cast in kfree()
      net: microchip: Remove unneeded variable ret

Yegor Yefremov (1):
      can: j1939: add tables for the CAN identifier and its fields

Yejune Deng (3):
      ipvs: replace atomic_add_return()
      cw1200: replace a set of atomic_add()
      net: phy: marvell: replace phy_modify()

Yevgeny Kliteynik (8):
      net/mlx5: DR, Remove unused member of action struct
      net/mlx5: DR, Rename builders HW specific names
      net/mlx5: DR, Rename matcher functions to be more HW agnostic
      net/mlx5: DR, Add buddy allocator utilities
      net/mlx5: DR, Handle ICM memory via buddy allocation instead of buckets
      net/mlx5: DR, Sync chunks only during free
      net/mlx5: DR, ICM memory pools sync optimization
      net/mlx5: DR, Free unused buddy ICM memory

Yi Li (1):
      net: core: Use skb_is_gso() in skb_checksum_help()

Yishai Hadas (1):
      net/mlx5: Expose other function ifc bits

Yonatan Linik (1):
      net: fix proc_fs init handling in af_packet and tls

Yonghong Song (4):
      bpf: Permit cond_resched for some iterators
      bpftool: Add {i,d}tlb_misses support for bpftool profile
      bpf: Permits pointers on stack for helper calls
      selftests/bpf: Add a test for ptr_to_map_value on stack for helper access

Yonglong Liu (4):
      net: hns3: add support for 1280 queues
      net: hns3: add support to utilize the firmware calculated shaping parameters
      net: hns3: adds debugfs to dump more info of shaping parameters
      net: hns3: keep MAC pause mode when multiple TCs are enabled

Yuchung Cheng (1):
      tcp: avoid slow start during fast recovery on new losses

YueHaibing (7):
      liquidio: cn68xx: Remove duplicated include
      net: hns3: Remove duplicated include
      openvswitch: Use IS_ERR instead of IS_ERR_OR_NULL
      nfp: Fix passing zero to 'PTR_ERR'
      net: macb: Fix passing zero to 'PTR_ERR'
      net/mlx5e: Remove duplicated include
      net/mlx5: Fix passing zero to 'PTR_ERR'

Yufeng Mo (1):
      net: hns3: add support for pf querying new interrupt resources

Yunsheng Lin (2):
      lockdep: Introduce in_softirq lockdep assert
      net: Use lockdep_assert_in_softirq() in napi_consume_skb()

Zhang Changzhong (3):
      brcmfmac: fix error return code in brcmf_cfg80211_connect()
      rsi: fix error return code in rsi_reset_card()
      adm8211: fix error return code in adm8211_probe()

Zhang Qilong (1):
      net/mac8390: discard unnecessary breaks

Zhang Xiaohui (1):
      mwifiex: Fix possible buffer overflows in mwifiex_cmd_802_11_ad_hoc_start

Zheng Yongjun (34):
      net/sched: cls_u32: simplify the return expression of u32_reoffload_knode()
      net: ipv6: rpl_iptunnel: simplify the return expression of rpl_do_srh()
      net: core: devlink: simplify the return expression of devlink_nl_cmd_trap_set_doit()
      net: openvswitch: conntrack: simplify the return expression of ovs_ct_limit_get_default_limit()
      drivers: net: ionic: simplify the return expression of ionic_set_rxfh()
      drivers: net: qlcnic: simplify the return expression of qlcnic_sriov_vf_shutdown()
      net: atheros: simplify the return expression of atl2_phy_setup_autoneg_adv()
      net: rxrpc: convert comma to semicolon
      net: micrel: convert comma to semicolon
      net: mlx5: convert comma to semicolon
      hisilicon/hns: convert comma to semicolon
      hisilicon/hns3: convert comma to semicolon
      net: ethernet: ti: convert comma to semicolon
      net: freescale: convert comma to semicolon
      net: usb: convert comma to semicolon
      net: thunderbolt: convert comma to semicolon
      net: mv88e6xxx: convert comma to semicolon
      net: ipa: convert comma to semicolon
      net: marvell: prestera: simplify the return expression of prestera_port_close()
      net: marvell: octeontx2: simplify the return expression of rvu_npa_init()
      net: emulex: benet: simplify the return expression of be_if_create()
      net: cisco: enic: simplify the return vnic_cq_alloc()
      net: freescale: dpaa: simplify the return dpaa_eth_refill_bpools()
      net: hinic: simplify the return hinic_configure_max_qnum()
      net: stmmac: simplify the return dwmac5_rxp_disable()
      net: dsa: simplify the return rtl8366_vlan_prepare()
      net: marvell: octeontx2: simplify the otx2_ptp_adjfine()
      net/mlx4: simplify the return expression of mlx4_init_cq_table()
      cw1200: txrx: convert comma to semicolon
      net: stmmac: simplify the return tc_delete_knode()
      net/mlx4: simplify the return expression of mlx4_init_srq_table()
      net: mediatek: simplify the return expression of mtk_gmac_sgmii_path_setup()
      net: mtk_eth: simplify the mediatek code return expression
      nfc: pn533: convert comma to semicolon

Zhu Yanjun (2):
      xdp: Remove the functions xsk_map_inc and xsk_map_put
      net/mlx5e: remove unnecessary memset

Zong-Zhe Yang (1):
      rtw88: declare hw supports ch 144

Zou Wei (1):
      dpaa_eth: use false and true for bool variables

kernel test robot (2):
      forcedeth: fix excluded_middle.cocci warnings
      net: phy: mscc: fix excluded_middle.cocci warnings

wenxu (3):
      net/sched: fix miss init the mru in qdisc_skb_cb
      net/sched: act_mirred: refactor the handle of xmit
      net/sched: sch_frag: add generic packet fragment support.

Łukasz Stelmach (1):
      net: mii: Report advertised link capabilities when autonegotiation is off

 CREDITS                                            |    9 -
 .../ABI/obsolete/sysfs-class-net-batman-adv        |   32 -
 Documentation/ABI/obsolete/sysfs-class-net-mesh    |  110 -
 Documentation/ABI/testing/sysfs-kernel-btf         |    8 +
 Documentation/admin-guide/index.rst                |    1 -
 .../devicetree/bindings/net/can/fsl,flexcan.yaml   |    5 +-
 .../bindings/net/dsa/hirschmann,hellcreek.yaml     |  127 +
 Documentation/devicetree/bindings/net/dsa/ksz.txt  |  125 -
 .../devicetree/bindings/net/dsa/microchip,ksz.yaml |  148 ++
 .../devicetree/bindings/net/ftgmac100.txt          |   25 +
 Documentation/devicetree/bindings/net/macb.txt     |    2 +
 .../devicetree/bindings/net/nfc/nxp-nci.txt        |    2 +-
 .../bindings/net/nfc/samsung,s3fwrn5.yaml          |   33 +-
 .../bindings/net/wireless/qcom,ath11k.yaml         |    6 +
 .../devicetree/bindings/vendor-prefixes.yaml       |    2 +
 Documentation/driver-api/auxiliary_bus.rst         |  234 ++
 Documentation/driver-api/index.rst                 |    1 +
 Documentation/networking/can.rst                   |   70 +-
 .../device_drivers/ethernet/marvell/octeontx2.rst  |   50 +
 Documentation/networking/devlink/devlink-trap.rst  |    4 +
 Documentation/networking/devlink/netdevsim.rst     |    3 +-
 Documentation/networking/framerelay.rst            |   44 -
 Documentation/networking/index.rst                 |    3 +-
 Documentation/networking/ip-sysctl.rst             |   34 +
 Documentation/networking/j1939.rst                 |   46 +-
 Documentation/networking/kapi.rst                  |   21 -
 Documentation/networking/mptcp-sysctl.rst          |   26 +
 Documentation/networking/page_pool.rst             |    8 +
 Documentation/networking/ppp_generic.rst           |   16 +
 Documentation/networking/tipc.rst                  |  100 +
 Documentation/networking/tls-offload.rst           |    8 +-
 Documentation/networking/x25.rst                   |   12 +-
 Documentation/process/magic-number.rst             |    1 -
 .../translations/it_IT/process/magic-number.rst    |    1 -
 .../translations/zh_CN/admin-guide/index.rst       |    1 -
 .../translations/zh_CN/process/magic-number.rst    |    1 -
 MAINTAINERS                                        |   58 +-
 arch/alpha/include/uapi/asm/socket.h               |    3 +
 arch/arm/configs/ixp4xx_defconfig                  |    1 -
 arch/mips/configs/gpr_defconfig                    |    2 -
 arch/mips/configs/mtx1_defconfig                   |    2 -
 arch/mips/include/uapi/asm/socket.h                |    3 +
 arch/parisc/include/uapi/asm/socket.h              |    3 +
 arch/sparc/include/uapi/asm/socket.h               |    3 +
 drivers/atm/lanai.c                                |    3 +-
 drivers/atm/nicstar.c                              |   24 +-
 drivers/base/Kconfig                               |    3 +
 drivers/base/Makefile                              |    1 +
 drivers/base/auxiliary.c                           |  274 +++
 drivers/bluetooth/btintel.c                        |   21 +-
 drivers/bluetooth/btintel.h                        |    6 +
 drivers/bluetooth/btmtksdio.c                      |    2 +-
 drivers/bluetooth/btqca.c                          |   36 +-
 drivers/bluetooth/btqca.h                          |   22 +-
 drivers/bluetooth/btrtl.c                          |  123 +-
 drivers/bluetooth/btusb.c                          |  421 +++-
 drivers/bluetooth/hci_h5.c                         |    4 +
 drivers/bluetooth/hci_ll.c                         |    1 +
 drivers/bluetooth/hci_qca.c                        |  118 +-
 drivers/bus/mhi/core/init.c                        |    9 -
 drivers/bus/mhi/core/internal.h                    |    1 -
 drivers/bus/mhi/core/main.c                        |   11 +
 drivers/crypto/caam/qi.c                           |   15 +-
 drivers/infiniband/core/nldev.c                    |   10 +-
 drivers/infiniband/hw/hfi1/driver.c                |    4 +-
 drivers/infiniband/hw/hfi1/ipoib.h                 |   27 -
 drivers/infiniband/hw/hfi1/ipoib_main.c            |   15 +-
 drivers/infiniband/hw/hfi1/ipoib_tx.c              |    2 +-
 drivers/infiniband/hw/mlx5/counters.c              |    7 -
 drivers/infiniband/hw/mlx5/ib_rep.c                |  112 +-
 drivers/infiniband/hw/mlx5/ib_rep.h                |   45 +-
 drivers/infiniband/hw/mlx5/main.c                  |  153 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               |    4 +-
 drivers/isdn/capi/capi.c                           |    1 +
 drivers/media/pci/ttpci/av7110_av.c                |    1 +
 drivers/net/Kconfig                                |   11 +-
 drivers/net/Makefile                               |    2 +-
 drivers/net/bareudp.c                              |    4 +-
 drivers/net/bonding/bond_main.c                    |   21 +-
 drivers/net/bonding/bond_procfs.c                  |    1 +
 drivers/net/can/at91_can.c                         |   14 +-
 drivers/net/can/c_can/c_can.c                      |   20 +-
 drivers/net/can/cc770/cc770.c                      |   14 +-
 drivers/net/can/dev.c                              |   16 +-
 drivers/net/can/flexcan.c                          |  179 +-
 drivers/net/can/grcan.c                            |   10 +-
 drivers/net/can/ifi_canfd/ifi_canfd.c              |   10 +-
 drivers/net/can/janz-ican3.c                       |   20 +-
 drivers/net/can/kvaser_pciefd.c                    |   10 +-
 drivers/net/can/m_can/Kconfig                      |   15 +-
 drivers/net/can/m_can/Makefile                     |    1 +
 drivers/net/can/m_can/m_can.c                      |  240 +-
 drivers/net/can/m_can/m_can.h                      |    6 +-
 drivers/net/can/m_can/m_can_pci.c                  |  190 ++
 drivers/net/can/m_can/m_can_platform.c             |   51 +-
 drivers/net/can/m_can/tcan4x5x.c                   |   72 +-
 drivers/net/can/mscan/mscan.c                      |   20 +-
 drivers/net/can/pch_can.c                          |   14 +-
 drivers/net/can/peak_canfd/peak_canfd.c            |   16 +-
 drivers/net/can/rcar/rcar_can.c                    |   14 +-
 drivers/net/can/rcar/rcar_canfd.c                  |   12 +-
 drivers/net/can/rx-offload.c                       |    4 +-
 drivers/net/can/sja1000/sja1000.c                  |   16 +-
 drivers/net/can/slcan.c                            |   32 +-
 drivers/net/can/softing/softing_fw.c               |    2 +-
 drivers/net/can/softing/softing_main.c             |   14 +-
 drivers/net/can/spi/hi311x.c                       |   20 +-
 drivers/net/can/spi/mcp251x.c                      |   20 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |  162 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h          |   30 +-
 drivers/net/can/sun4i_can.c                        |   10 +-
 drivers/net/can/ti_hecc.c                          |    8 +-
 drivers/net/can/usb/Kconfig                        |    5 +
 drivers/net/can/usb/ems_usb.c                      |   16 +-
 drivers/net/can/usb/esd_usb2.c                     |   24 +-
 drivers/net/can/usb/gs_usb.c                       |   12 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   22 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |   61 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |   22 +-
 drivers/net/can/usb/mcba_usb.c                     |   10 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c            |   18 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |    9 +-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |   29 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |   14 +-
 drivers/net/can/usb/ucan.c                         |   20 +-
 drivers/net/can/usb/usb_8dev.c                     |   17 +-
 drivers/net/can/vxcan.c                            |    4 +-
 drivers/net/can/xilinx_can.c                       |   16 +-
 drivers/net/dsa/Kconfig                            |    2 +
 drivers/net/dsa/Makefile                           |    1 +
 drivers/net/dsa/hirschmann/Kconfig                 |    9 +
 drivers/net/dsa/hirschmann/Makefile                |    5 +
 drivers/net/dsa/hirschmann/hellcreek.c             | 1339 +++++++++++
 drivers/net/dsa/hirschmann/hellcreek.h             |  286 +++
 drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c    |  479 ++++
 drivers/net/dsa/hirschmann/hellcreek_hwtstamp.h    |   58 +
 drivers/net/dsa/hirschmann/hellcreek_ptp.c         |  452 ++++
 drivers/net/dsa/hirschmann/hellcreek_ptp.h         |   76 +
 drivers/net/dsa/microchip/ksz8795.c                |   71 +-
 drivers/net/dsa/microchip/ksz8795_reg.h            |   10 -
 drivers/net/dsa/microchip/ksz8795_spi.c            |    6 +
 drivers/net/dsa/microchip/ksz9477.c                |   14 +-
 drivers/net/dsa/microchip/ksz9477_spi.c            |    6 +
 drivers/net/dsa/microchip/ksz_common.c             |    8 +-
 drivers/net/dsa/microchip/ksz_common.h             |    2 -
 drivers/net/dsa/mt7530.c                           |   94 +-
 drivers/net/dsa/mt7530.h                           |   25 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |   79 +-
 drivers/net/dsa/mv88e6xxx/chip.h                   |   10 +
 drivers/net/dsa/mv88e6xxx/devlink.c                |  105 +-
 drivers/net/dsa/mv88e6xxx/global1.h                |    2 +
 drivers/net/dsa/mv88e6xxx/global1_atu.c            |    2 +-
 drivers/net/dsa/mv88e6xxx/global1_vtu.c            |    4 +-
 drivers/net/dsa/mv88e6xxx/port.c                   |   36 +
 drivers/net/dsa/mv88e6xxx/port.h                   |    3 +
 drivers/net/dsa/mv88e6xxx/serdes.c                 |  123 +-
 drivers/net/dsa/mv88e6xxx/serdes.h                 |    9 +
 drivers/net/dsa/ocelot/felix.c                     |   27 +-
 drivers/net/dsa/rtl8366.c                          |    7 +-
 drivers/net/dummy.c                                |    2 +-
 drivers/net/ethernet/8390/mac8390.c                |    7 -
 drivers/net/ethernet/8390/ne.c                     |    2 +-
 drivers/net/ethernet/8390/ne2k-pci.c               |    2 +-
 drivers/net/ethernet/amazon/ena/ena_com.c          |  391 ++--
 drivers/net/ethernet/amazon/ena/ena_com.h          |   23 +-
 drivers/net/ethernet/amazon/ena/ena_eth_com.c      |   71 +-
 drivers/net/ethernet/amazon/ena/ena_eth_com.h      |   23 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |    4 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  405 ++--
 drivers/net/ethernet/amazon/ena/ena_netdev.h       |   12 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |    2 +-
 drivers/net/ethernet/aquantia/atlantic/aq_nic.h    |    2 +
 drivers/net/ethernet/atheros/atlx/atl2.c           |    8 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |    2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |    1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |    4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  245 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h  |    4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c    |    1 +
 drivers/net/ethernet/brocade/bna/bna_hw_defs.h     |   18 +-
 drivers/net/ethernet/cadence/macb.h                |   57 +-
 drivers/net/ethernet/cadence/macb_main.c           |  331 ++-
 .../net/ethernet/cavium/liquidio/cn68xx_device.c   |    1 -
 drivers/net/ethernet/cavium/liquidio/lio_ethtool.c |    1 +
 .../net/ethernet/cavium/thunder/nicvf_ethtool.c    |    1 +
 drivers/net/ethernet/cavium/thunder/nicvf_queues.c |    2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h         |    1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |    2 +-
 drivers/net/ethernet/chelsio/cxgb4vf/t4vf_hw.c     |    1 +
 .../ethernet/chelsio/inline_crypto/chtls/chtls.h   |    1 +
 .../chelsio/inline_crypto/chtls/chtls_cm.c         |    3 +-
 drivers/net/ethernet/cisco/enic/vnic_cq.c          |    8 +-
 drivers/net/ethernet/davicom/Kconfig               |    2 +-
 drivers/net/ethernet/davicom/dm9000.c              |    9 +-
 drivers/net/ethernet/dec/tulip/de2104x.c           |   10 +
 drivers/net/ethernet/dec/tulip/tulip_core.c        |    4 +
 drivers/net/ethernet/emulex/benet/be_main.c        |    8 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |  122 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |  499 +++-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.h     |   13 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |    6 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |   51 +-
 drivers/net/ethernet/freescale/enetc/enetc.h       |    5 +-
 drivers/net/ethernet/freescale/enetc/enetc_hw.h    |   55 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |   31 +-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |   84 +-
 drivers/net/ethernet/freescale/enetc/enetc_vf.c    |   10 +-
 drivers/net/ethernet/freescale/fsl_pq_mdio.c       |    2 +-
 drivers/net/ethernet/freescale/ucc_geth.h          |    1 -
 drivers/net/ethernet/google/gve/gve.h              |   39 +-
 drivers/net/ethernet/google/gve/gve_adminq.c       |   89 +-
 drivers/net/ethernet/google/gve/gve_adminq.h       |   15 +-
 drivers/net/ethernet/google/gve/gve_desc.h         |   19 +-
 drivers/net/ethernet/google/gve/gve_ethtool.c      |    3 +
 drivers/net/ethernet/google/gve/gve_main.c         |   11 +-
 drivers/net/ethernet/google/gve/gve_rx.c           |  364 ++-
 drivers/net/ethernet/google/gve/gve_tx.c           |  197 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c |   12 +-
 drivers/net/ethernet/hisilicon/hns3/hclge_mbx.h    |    1 +
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   52 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   66 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  356 ++-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   38 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  158 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |    6 +
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   84 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |  127 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |   50 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  746 ++++--
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |   45 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   20 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  201 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |   26 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |    4 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |   14 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |   84 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |    1 +
 drivers/net/ethernet/huawei/hinic/hinic_devlink.c  |   12 +-
 drivers/net/ethernet/huawei/hinic/hinic_main.c     |    8 +-
 drivers/net/ethernet/huawei/hinic/hinic_port.h     |    1 +
 drivers/net/ethernet/ibm/ibmvnic.c                 |  424 ++--
 drivers/net/ethernet/ibm/ibmvnic.h                 |   27 +-
 drivers/net/ethernet/intel/fm10k/fm10k_ethtool.c   |    1 +
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   13 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h        |    1 +
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |    5 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |  124 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.h         |   16 +
 drivers/net/ethernet/intel/ice/ice.h               |    1 -
 drivers/net/ethernet/intel/ice/ice_base.c          |    4 +-
 drivers/net/ethernet/intel/ice/ice_common.c        |  109 +-
 drivers/net/ethernet/intel/ice/ice_controlq.c      |   42 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c       |   17 +-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c     |   24 +-
 drivers/net/ethernet/intel/ice/ice_flow.c          |   53 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |   13 +-
 drivers/net/ethernet/intel/ice/ice_nvm.c           |   61 +-
 drivers/net/ethernet/intel/ice/ice_sched.c         |   21 +-
 drivers/net/ethernet/intel/ice/ice_switch.c        |   15 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |    2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |    9 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |    2 +-
 drivers/net/ethernet/intel/igbvf/netdev.c          |    4 +-
 drivers/net/ethernet/intel/igc/igc_base.c          |    1 +
 drivers/net/ethernet/intel/igc/igc_hw.h            |    1 +
 drivers/net/ethernet/intel/igc/igc_main.c          |    1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |    2 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |    2 +-
 drivers/net/ethernet/marvell/mvneta.c              |   67 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h         |   23 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  143 +-
 drivers/net/ethernet/marvell/octeontx2/Kconfig     |    1 +
 drivers/net/ethernet/marvell/octeontx2/af/Makefile |    3 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |   13 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |    5 +
 drivers/net/ethernet/marvell/octeontx2/af/common.h |   12 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  223 +-
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |  137 +-
 .../ethernet/marvell/octeontx2/af/npc_profile.h    |  101 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  386 +++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  102 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |   15 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cpt.c    |  233 ++
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |  775 +++++--
 .../ethernet/marvell/octeontx2/af/rvu_devlink.c    |  770 +++++++
 .../ethernet/marvell/octeontx2/af/rvu_devlink.h    |   55 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  507 +++-
 .../net/ethernet/marvell/octeontx2/af/rvu_npa.c    |    8 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  785 +++++--
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c | 1336 +++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.c    |    2 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |  150 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |   40 +-
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |    2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   21 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   75 +-
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |   58 +-
 .../ethernet/marvell/octeontx2/nic/otx2_flows.c    |  820 +++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  307 ++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  |    7 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |   16 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |    5 +
 .../net/ethernet/marvell/prestera/prestera_main.c  |    7 +-
 drivers/net/ethernet/marvell/sky2.c                |    2 +-
 drivers/net/ethernet/mediatek/mtk_eth_path.c       |   24 +-
 drivers/net/ethernet/mellanox/mlx4/cq.c            |    9 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |    1 -
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |    7 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   13 -
 drivers/net/ethernet/mellanox/mlx4/fw_qos.h        |    2 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h       |   23 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_stats.h    |   18 +-
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |    2 +-
 drivers/net/ethernet/mellanox/mlx4/srq.c           |    9 +-
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |    3 -
 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |  567 +++--
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   15 +-
 .../mellanox/mlx5/core/diag/fs_tracepoint.c        |    3 +
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c     |   76 +-
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.h     |    3 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   63 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |    3 +-
 .../net/ethernet/mellanox/mlx5/core/en/health.c    |   16 +-
 .../net/ethernet/mellanox/mlx5/core/en/health.h    |    7 +-
 .../net/ethernet/mellanox/mlx5/core/en/params.c    |   34 +
 .../net/ethernet/mellanox/mlx5/core/en/params.h    |   14 +
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c   |  529 +++++
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h   |   63 +
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   |   52 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |  215 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |   19 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   22 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |    9 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |    8 +-
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h        |    2 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |    8 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.h         |    4 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   42 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |   20 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  417 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   41 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |    6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   29 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |  403 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |   11 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |    8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |   84 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |    5 +-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |   24 +-
 .../mellanox/mlx5/core/esw/acl/egress_lgcy.c       |    2 +-
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c       |    2 +-
 .../ethernet/mellanox/mlx5/core/esw/acl/helper.c   |    5 +-
 .../mellanox/mlx5/core/esw/acl/ingress_lgcy.c      |    2 +-
 .../mellanox/mlx5/core/esw/acl/ingress_ofld.c      |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   50 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |    3 +-
 drivers/net/ethernet/mellanox/mlx5/core/fpga/sdk.h |    8 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |   57 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   17 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.h  |    2 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ethtool.c    |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |   58 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   68 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   37 +-
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |   12 +-
 .../mellanox/mlx5/core/steering/dr_buddy.c         |  170 ++
 .../ethernet/mellanox/mlx5/core/steering/dr_cmd.c  |    4 +-
 .../mellanox/mlx5/core/steering/dr_icm_pool.c      |  501 ++--
 .../mellanox/mlx5/core/steering/dr_matcher.c       |  109 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |    3 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |   42 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |   80 +-
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |   32 +
 drivers/net/ethernet/mellanox/mlxfw/mlxfw_fsm.c    |    3 -
 drivers/net/ethernet/mellanox/mlxsw/Makefile       |    1 +
 drivers/net/ethernet/mellanox/mlxsw/cmd.h          |   30 +
 drivers/net/ethernet/mellanox/mlxsw/core.c         |   30 +-
 drivers/net/ethernet/mellanox/mlxsw/core.h         |   12 +-
 .../ethernet/mellanox/mlxsw/core_acl_flex_keys.c   |   26 +-
 drivers/net/ethernet/mellanox/mlxsw/core_env.h     |    3 +
 drivers/net/ethernet/mellanox/mlxsw/minimal.c      |    3 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c          |   33 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h          |  930 +++++++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  139 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |   14 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_dpipe.c   |    9 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_ipip.c    |   46 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_ipip.h    |    6 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c  |    2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c |    6 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h |    5 +-
 .../ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c   |   67 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c |    8 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.h |    7 -
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  | 2416 +++++++++++++++-----
 .../net/ethernet/mellanox/mlxsw/spectrum_router.h  |   79 +
 .../ethernet/mellanox/mlxsw/spectrum_router_xm.c   |  812 +++++++
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c   |  151 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_trap.c    |    8 +-
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c     |    1 +
 drivers/net/ethernet/mellanox/mlxsw/trap.h         |    1 +
 drivers/net/ethernet/micrel/ks8851_common.c        |    2 +-
 drivers/net/ethernet/microchip/lan743x_ethtool.c   |    9 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |   77 +-
 drivers/net/ethernet/microchip/lan743x_main.h      |    4 +-
 drivers/net/ethernet/mscc/ocelot.c                 |  301 ++-
 drivers/net/ethernet/mscc/ocelot.h                 |   31 +-
 drivers/net/ethernet/mscc/ocelot_net.c             |  112 +-
 drivers/net/ethernet/neterion/s2io.c               |   41 +-
 drivers/net/ethernet/neterion/s2io.h               |    4 +-
 drivers/net/ethernet/neterion/vxge/vxge-config.c   |   20 +-
 drivers/net/ethernet/netronome/nfp/crypto/fw.h     |    2 +-
 drivers/net/ethernet/netronome/nfp/crypto/tls.c    |    4 +-
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c   |    2 +-
 drivers/net/ethernet/netronome/nfp/nfp_main.c      |   21 +-
 drivers/net/ethernet/netronome/nfp/nfp_main.h      |    2 +-
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |    2 +-
 .../net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c   |    2 +-
 drivers/net/ethernet/nvidia/forcedeth.c            |    9 +-
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |   27 +-
 drivers/net/ethernet/pensando/ionic/ionic_dev.c    |    4 +-
 drivers/net/ethernet/pensando/ionic/ionic_dev.h    |    4 +-
 .../net/ethernet/pensando/ionic/ionic_devlink.c    |    2 +-
 .../net/ethernet/pensando/ionic/ionic_devlink.h    |    2 +-
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    |    7 +-
 drivers/net/ethernet/pensando/ionic/ionic_fw.c     |   14 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    |  122 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.h    |    6 +
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |    4 +-
 drivers/net/ethernet/pensando/ionic/ionic_stats.c  |    1 +
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |   18 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |    2 +-
 .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |    7 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c |   15 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h |    2 +
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c    |   74 +-
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.h    |    3 +
 drivers/net/ethernet/realtek/r8169_main.c          |  164 +-
 drivers/net/ethernet/sfc/bitfield.h                |   58 +-
 drivers/net/ethernet/sfc/ef100_nic.c               |   21 +-
 drivers/net/ethernet/sfc/ef100_tx.c                |   66 +-
 drivers/net/ethernet/sfc/rx_common.c               |    2 +-
 drivers/net/ethernet/smsc/Kconfig                  |    6 +-
 drivers/net/ethernet/smsc/smc911x.c                |   17 +-
 drivers/net/ethernet/smsc/smc91x.c                 |    9 +-
 drivers/net/ethernet/socionext/netsec.c            |   14 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |    1 +
 .../ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c    |   46 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |    6 +-
 .../net/ethernet/stmicro/stmmac/dwmac-meson8b.c    |    2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h       |    2 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   24 +
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c       |    6 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |    3 +
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |    4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   54 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c  |    3 +
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   22 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c    |   10 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  355 +--
 drivers/net/ethernet/ti/am65-cpsw-nuss.h           |    5 +
 drivers/net/ethernet/ti/cpsw_ale.c                 |   41 +-
 drivers/net/ethernet/ti/cpsw_ale.h                 |    1 +
 drivers/net/ethernet/ti/cpsw_priv.c                |    2 +-
 drivers/net/ethernet/ti/cpsw_switchdev.c           |    2 +-
 drivers/net/ethernet/ti/davinci_mdio.c             |    6 +-
 drivers/net/ethernet/ti/tlan.c                     |   98 +-
 drivers/net/ethernet/xilinx/Kconfig                |    2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet.h       |    5 +
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  115 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c  |   56 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |   14 +-
 drivers/net/fddi/skfp/drvfbi.c                     |    4 -
 drivers/net/fddi/skfp/ecm.c                        |    7 +-
 drivers/net/fddi/skfp/ess.c                        |    1 -
 drivers/net/fddi/skfp/hwt.c                        |    4 -
 drivers/net/fddi/skfp/pcmplc.c                     |    4 -
 drivers/net/fddi/skfp/pmf.c                        |    4 -
 drivers/net/fddi/skfp/queue.c                      |    4 -
 drivers/net/fddi/skfp/rmt.c                        |    4 -
 drivers/net/fddi/skfp/smtdef.c                     |    4 -
 drivers/net/fddi/skfp/smtinit.c                    |    4 -
 drivers/net/fddi/skfp/smttimer.c                   |    4 -
 drivers/net/fddi/skfp/srf.c                        |    5 -
 drivers/net/geneve.c                               |    3 +-
 drivers/net/gtp.c                                  |    2 +-
 drivers/net/hamradio/hdlcdrv.c                     |    2 +-
 drivers/net/hyperv/netvsc.c                        |    2 +-
 drivers/net/hyperv/netvsc_drv.c                    |    1 +
 drivers/net/hyperv/rndis_filter.c                  |    1 +
 drivers/net/ieee802154/ca8210.c                    |   22 +-
 drivers/net/ifb.c                                  |    3 +-
 drivers/net/ipa/gsi.c                              |  499 ++--
 drivers/net/ipa/gsi.h                              |   52 +-
 drivers/net/ipa/gsi_reg.h                          |  159 +-
 drivers/net/ipa/ipa_clock.c                        |   47 +-
 drivers/net/ipa/ipa_clock.h                        |    5 +-
 drivers/net/ipa/ipa_cmd.c                          |    6 +-
 drivers/net/ipa/ipa_cmd.h                          |   21 +-
 drivers/net/ipa/ipa_data-sc7180.c                  |   25 +
 drivers/net/ipa/ipa_data-sdm845.c                  |   29 +-
 drivers/net/ipa/ipa_data.h                         |   43 +-
 drivers/net/ipa/ipa_endpoint.c                     |  258 ++-
 drivers/net/ipa/ipa_endpoint.h                     |    2 +-
 drivers/net/ipa/ipa_interrupt.c                    |    6 +-
 drivers/net/ipa/ipa_interrupt.h                    |   16 -
 drivers/net/ipa/ipa_main.c                         |  333 ++-
 drivers/net/ipa/ipa_mem.c                          |   10 +-
 drivers/net/ipa/ipa_qmi.c                          |   10 +-
 drivers/net/ipa/ipa_qmi_msg.h                      |   12 +-
 drivers/net/ipa/ipa_reg.h                          |  486 ++--
 drivers/net/ipa/ipa_table.c                        |    4 +-
 drivers/net/ipa/ipa_uc.c                           |   46 +-
 drivers/net/ipa/ipa_version.h                      |    1 +
 drivers/net/ipvlan/ipvlan_main.c                   |    2 +
 drivers/net/macsec.c                               |    1 +
 drivers/net/macvlan.c                              |   44 +-
 drivers/net/mhi_net.c                              |  317 +++
 drivers/net/mii.c                                  |   20 +-
 drivers/net/net_failover.c                         |    2 +-
 drivers/net/netconsole.c                           |    1 +
 drivers/net/netdevsim/dev.c                        |    8 +-
 drivers/net/netdevsim/ethtool.c                    |   82 +-
 drivers/net/netdevsim/fib.c                        |  265 ++-
 drivers/net/netdevsim/netdevsim.h                  |   10 +-
 drivers/net/nlmon.c                                |    1 +
 drivers/net/phy/adin.c                             |  195 +-
 drivers/net/phy/amd.c                              |   37 +-
 drivers/net/phy/aquantia_main.c                    |   59 +-
 drivers/net/phy/at803x.c                           |   50 +-
 drivers/net/phy/bcm-cygnus.c                       |    2 +-
 drivers/net/phy/bcm-phy-lib.c                      |   49 +-
 drivers/net/phy/bcm-phy-lib.h                      |    1 +
 drivers/net/phy/bcm54140.c                         |   46 +-
 drivers/net/phy/bcm63xx.c                          |   20 +-
 drivers/net/phy/bcm87xx.c                          |   50 +-
 drivers/net/phy/broadcom.c                         |   70 +-
 drivers/net/phy/cicada.c                           |   35 +-
 drivers/net/phy/davicom.c                          |   63 +-
 drivers/net/phy/dp83640.c                          |   43 +-
 drivers/net/phy/dp83822.c                          |   54 +-
 drivers/net/phy/dp83848.c                          |   47 +-
 drivers/net/phy/dp83867.c                          |   44 +-
 drivers/net/phy/dp83869.c                          |   42 +-
 drivers/net/phy/dp83tc811.c                        |   53 +-
 drivers/net/phy/icplus.c                           |   58 +-
 drivers/net/phy/intel-xway.c                       |   71 +-
 drivers/net/phy/lxt.c                              |   94 +-
 drivers/net/phy/marvell.c                          |  204 +-
 drivers/net/phy/mdio_bus.c                         |    9 +-
 drivers/net/phy/meson-gxl.c                        |   37 +-
 drivers/net/phy/micrel.c                           |   65 +-
 drivers/net/phy/microchip.c                        |   24 +-
 drivers/net/phy/microchip_t1.c                     |   29 +-
 drivers/net/phy/mscc/mscc_main.c                   |   70 +-
 drivers/net/phy/mscc/mscc_ptp.c                    |   18 +-
 drivers/net/phy/mscc/mscc_ptp.h                    |    5 -
 drivers/net/phy/national.c                         |   58 +-
 drivers/net/phy/nxp-tja11xx.c                      |   42 +-
 drivers/net/phy/phy-c45.c                          |    2 +-
 drivers/net/phy/phy.c                              |   56 +-
 drivers/net/phy/phy_device.c                       |   39 +-
 drivers/net/phy/phy_led_triggers.c                 |   16 +-
 drivers/net/phy/phylink.c                          |    5 +-
 drivers/net/phy/qsemi.c                            |   42 +-
 drivers/net/phy/realtek.c                          |  181 +-
 drivers/net/phy/sfp-bus.c                          |   11 +-
 drivers/net/phy/sfp.c                              |   63 +-
 drivers/net/phy/smsc.c                             |   55 +-
 drivers/net/phy/ste10Xp.c                          |   53 +-
 drivers/net/phy/vitesse.c                          |   61 +-
 drivers/net/ppp/ppp_generic.c                      |  152 +-
 drivers/net/team/team.c                            |   10 +-
 drivers/net/thunderbolt.c                          |    2 +-
 drivers/net/tun.c                                  |  134 +-
 drivers/net/usb/Kconfig                            |    9 +
 drivers/net/usb/Makefile                           |    1 +
 drivers/net/usb/aqc111.c                           |    2 +-
 drivers/net/usb/asix_devices.c                     |    6 +-
 drivers/net/usb/ax88172a.c                         |    2 +-
 drivers/net/usb/ax88179_178a.c                     |    2 +-
 drivers/net/usb/cdc-phonet.c                       |    2 +-
 drivers/net/usb/cdc_mbim.c                         |    2 +-
 drivers/net/usb/cdc_ncm.c                          |    4 +-
 drivers/net/usb/dm9601.c                           |    2 +-
 drivers/net/usb/int51x1.c                          |    2 +-
 drivers/net/usb/lan78xx.c                          |  168 +-
 drivers/net/usb/mcs7830.c                          |    2 +-
 drivers/net/usb/qmi_wwan.c                         |   41 +-
 drivers/net/usb/r8152.c                            |   40 +-
 drivers/net/usb/r8153_ecm.c                        |  162 ++
 drivers/net/usb/rndis_host.c                       |    2 +-
 drivers/net/usb/sierra_net.c                       |    2 +-
 drivers/net/usb/smsc75xx.c                         |    2 +-
 drivers/net/usb/smsc95xx.c                         |    2 +-
 drivers/net/usb/sr9700.c                           |    2 +-
 drivers/net/usb/sr9800.c                           |    2 +-
 drivers/net/usb/usbnet.c                           |   23 +-
 drivers/net/veth.c                                 |   16 +-
 drivers/net/virtio_net.c                           |    2 +-
 drivers/net/vrf.c                                  |   79 +-
 drivers/net/vsockmon.c                             |    1 +
 drivers/net/vxlan.c                                |   31 +-
 drivers/net/wan/Kconfig                            |   60 -
 drivers/net/wan/Makefile                           |    3 -
 drivers/net/wan/dlci.c                             |  541 -----
 drivers/net/wan/hdlc_fr.c                          |  118 +-
 drivers/net/wan/hdlc_x25.c                         |    2 -
 drivers/net/wan/lapbether.c                        |   13 +-
 drivers/net/wan/lmc/lmc_main.c                     |    9 +-
 drivers/net/wan/pci200syn.c                        |    2 +-
 drivers/net/wan/sdla.c                             | 1655 --------------
 drivers/net/wan/x25_asy.c                          |  836 -------
 drivers/net/wan/x25_asy.h                          |   46 -
 drivers/net/wimax/Kconfig                          |   18 -
 drivers/net/wimax/Makefile                         |    2 -
 drivers/net/wireguard/device.c                     |    2 +-
 drivers/net/wireless/Kconfig                       |   13 -
 drivers/net/wireless/admtek/adm8211.c              |    6 +-
 drivers/net/wireless/ath/ath10k/core.c             |  139 +-
 drivers/net/wireless/ath/ath10k/core.h             |   12 +
 drivers/net/wireless/ath/ath10k/debug.c            |    8 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c           |    1 -
 drivers/net/wireless/ath/ath10k/mac.c              |   22 +-
 drivers/net/wireless/ath/ath10k/p2p.c              |    2 +-
 drivers/net/wireless/ath/ath10k/pci.c              |    4 +-
 drivers/net/wireless/ath/ath10k/qmi.c              |    4 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h          |    2 +-
 drivers/net/wireless/ath/ath10k/sdio.c             |   28 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |    2 +-
 drivers/net/wireless/ath/ath10k/usb.c              |    7 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |    4 +-
 drivers/net/wireless/ath/ath10k/wmi.c              |   13 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |    7 +-
 drivers/net/wireless/ath/ath11k/Makefile           |    3 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |   36 +-
 drivers/net/wireless/ath/ath11k/ce.c               |    2 +-
 drivers/net/wireless/ath/ath11k/ce.h               |    2 +
 drivers/net/wireless/ath/ath11k/core.c             |  141 +-
 drivers/net/wireless/ath/ath11k/core.h             |   34 +-
 drivers/net/wireless/ath/ath11k/debugfs.c          |    1 +
 drivers/net/wireless/ath/ath11k/dp.c               |    4 +-
 drivers/net/wireless/ath/ath11k/dp.h               |    4 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |   66 +-
 drivers/net/wireless/ath/ath11k/dp_rx.h            |    3 +
 drivers/net/wireless/ath/ath11k/dp_tx.c            |   13 +-
 drivers/net/wireless/ath/ath11k/hal_desc.h         |    8 +-
 drivers/net/wireless/ath/ath11k/hif.h              |   32 +
 drivers/net/wireless/ath/ath11k/htc.c              |   31 +-
 drivers/net/wireless/ath/ath11k/htc.h              |   10 +-
 drivers/net/wireless/ath/ath11k/hw.c               |    4 +-
 drivers/net/wireless/ath/ath11k/hw.h               |    8 +-
 drivers/net/wireless/ath/ath11k/mac.c              |  242 +-
 drivers/net/wireless/ath/ath11k/mac.h              |    2 -
 drivers/net/wireless/ath/ath11k/mhi.c              |   31 +-
 drivers/net/wireless/ath/ath11k/mhi.h              |    3 +
 drivers/net/wireless/ath/ath11k/pci.c              |  234 +-
 drivers/net/wireless/ath/ath11k/pci.h              |   25 +
 drivers/net/wireless/ath/ath11k/peer.c             |   44 +-
 drivers/net/wireless/ath/ath11k/peer.h             |    2 +
 drivers/net/wireless/ath/ath11k/qmi.c              |  119 +-
 drivers/net/wireless/ath/ath11k/qmi.h              |    5 +
 drivers/net/wireless/ath/ath11k/reg.c              |    7 +-
 drivers/net/wireless/ath/ath11k/reg.h              |    1 +
 drivers/net/wireless/ath/ath11k/rx_desc.h          |    2 +-
 drivers/net/wireless/ath/ath11k/testmode.c         |    4 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |  468 +++-
 drivers/net/wireless/ath/ath11k/wmi.h              |  222 +-
 drivers/net/wireless/ath/ath11k/wow.c              |   73 +
 drivers/net/wireless/ath/ath11k/wow.h              |   10 +
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |    1 +
 drivers/net/wireless/ath/ath6kl/testmode.c         |    1 -
 drivers/net/wireless/ath/ath6kl/wmi.c              |    4 +-
 drivers/net/wireless/ath/ath9k/ar5008_phy.c        |   15 +-
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |   14 -
 .../net/wireless/ath/ath9k/ar9330_1p1_initvals.h   |    7 -
 drivers/net/wireless/ath/ath9k/ar9340_initvals.h   |  101 -
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h   |    7 -
 drivers/net/wireless/ath/ath9k/ath9k.h             |    1 -
 drivers/net/wireless/ath/ath9k/common-debug.c      |    2 +-
 drivers/net/wireless/ath/ath9k/debug.c             |    4 +-
 drivers/net/wireless/ath/ath9k/dfs_debug.c         |    2 +-
 drivers/net/wireless/ath/ath9k/dynack.c            |   11 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |    7 +-
 drivers/net/wireless/ath/ath9k/hw.c                |    1 -
 drivers/net/wireless/ath/ath9k/init.c              |   19 -
 drivers/net/wireless/ath/ath9k/main.c              |    5 -
 drivers/net/wireless/ath/carl9170/debug.c          |    4 +-
 drivers/net/wireless/ath/carl9170/mac.c            |    4 -
 drivers/net/wireless/ath/carl9170/main.c           |    1 -
 drivers/net/wireless/ath/carl9170/tx.c             |    1 +
 drivers/net/wireless/ath/dfs_pattern_detector.c    |   14 +-
 drivers/net/wireless/ath/dfs_pri_detector.c        |    9 +-
 drivers/net/wireless/ath/regd.c                    |    1 +
 drivers/net/wireless/ath/wcn36xx/main.c            |    2 +
 drivers/net/wireless/ath/wcn36xx/smd.c             |    6 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |    2 +-
 drivers/net/wireless/broadcom/b43/main.c           |    6 +-
 drivers/net/wireless/broadcom/b43legacy/main.c     |    6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |    2 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |    3 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |    1 +
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |    7 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   26 +-
 .../wireless/broadcom/brcm80211/brcmsmac/ampdu.c   |   11 +-
 drivers/net/wireless/cisco/airo.c                  |  127 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   70 +-
 drivers/net/wireless/intel/iwlwifi/cfg/7000.c      |   70 +-
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c      |   69 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |   58 +-
 drivers/net/wireless/intel/iwlwifi/dvm/agn.h       |   61 +-
 drivers/net/wireless/intel/iwlwifi/dvm/calib.c     |   61 +-
 drivers/net/wireless/intel/iwlwifi/dvm/calib.h     |   60 +-
 drivers/net/wireless/intel/iwlwifi/dvm/commands.h  |   61 +-
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c  |    2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c        |   22 +-
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c      |    2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c        |    2 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |   97 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |   74 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/alive.h  |   69 +-
 .../net/wireless/intel/iwlwifi/fw/api/binding.h    |   67 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/cmdhdr.h |   67 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/coex.h   |   69 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |   70 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/config.h |   70 +-
 .../net/wireless/intel/iwlwifi/fw/api/context.h    |   68 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h     |   69 +-
 .../net/wireless/intel/iwlwifi/fw/api/datapath.h   |   70 +-
 .../net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h    |   61 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/debug.h  |   81 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/filter.h |   68 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/led.h    |   62 +-
 .../net/wireless/intel/iwlwifi/fw/api/location.h   |   64 +-
 .../net/wireless/intel/iwlwifi/fw/api/mac-cfg.h    |   70 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h    |   64 +-
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |   78 +-
 .../net/wireless/intel/iwlwifi/fw/api/offload.h    |   68 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/paging.h |   67 +-
 .../net/wireless/intel/iwlwifi/fw/api/phy-ctxt.h   |   69 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/phy.h    |   70 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h  |   70 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     |   66 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |   68 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/scan.h   |   83 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/sf.h     |   68 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/soc.h    |   68 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/sta.h    |   67 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/stats.h  |   69 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tdls.h   |   70 +-
 .../net/wireless/intel/iwlwifi/fw/api/time-event.h |   70 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |   64 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/txq.h    |   69 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |  153 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |   70 +-
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.c    |   96 +-
 drivers/net/wireless/intel/iwlwifi/fw/debugfs.h    |   68 +-
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |   69 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   79 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |   68 +-
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |   64 +-
 drivers/net/wireless/intel/iwlwifi/fw/notif-wait.c |   64 +-
 drivers/net/wireless/intel/iwlwifi/fw/notif-wait.h |   63 +-
 drivers/net/wireless/intel/iwlwifi/fw/paging.c     |   69 +-
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |   62 +-
 drivers/net/wireless/intel/iwlwifi/fw/smem.c       |   67 +-
 drivers/net/wireless/intel/iwlwifi/iwl-agn-hw.h    |   61 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   68 +-
 .../wireless/intel/iwlwifi/iwl-context-info-gen3.h |   56 +-
 .../net/wireless/intel/iwlwifi/iwl-context-info.h  |   58 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   71 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |   67 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.h   |   64 +-
 drivers/net/wireless/intel/iwlwifi/iwl-debug.c     |   62 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   71 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h       |   64 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.c  |   77 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-parse.h  |   76 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-read.c   |   64 +-
 .../net/wireless/intel/iwlwifi/iwl-eeprom-read.h   |   61 +-
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h        |   66 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.c        |   68 +-
 drivers/net/wireless/intel/iwlwifi/iwl-io.h        |   61 +-
 drivers/net/wireless/intel/iwlwifi/iwl-modparams.h |   61 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  176 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h |   65 +-
 drivers/net/wireless/intel/iwlwifi/iwl-op-mode.h   |   69 +-
 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c    |   80 +-
 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.h    |   62 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |   93 +-
 drivers/net/wireless/intel/iwlwifi/iwl-scd.h       |   62 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c     |   67 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   99 +-
 drivers/net/wireless/intel/iwlwifi/mvm/binding.c   |   65 +-
 drivers/net/wireless/intel/iwlwifi/mvm/coex.c      |   65 +-
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |   71 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |   82 +-
 .../net/wireless/intel/iwlwifi/mvm/debugfs-vif.c   |   67 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |   71 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.h   |   65 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |  112 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-responder.c |   64 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    |   70 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  108 +-
 drivers/net/wireless/intel/iwlwifi/mvm/led.c       |   69 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   99 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  131 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   88 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |   69 +-
 .../net/wireless/intel/iwlwifi/mvm/offloading.c    |   67 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  103 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |   71 +-
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |   70 +-
 drivers/net/wireless/intel/iwlwifi/mvm/quota.c     |   68 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |   76 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |   10 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |  122 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  148 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  423 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/sf.c        |   66 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   86 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |   70 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c      |   68 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   68 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.h    |   67 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        |   70 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   80 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   71 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |   57 +-
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |   60 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   90 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |   80 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  113 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |   83 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  155 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |   57 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  351 +--
 drivers/net/wireless/intel/iwlwifi/queue/tx.c      |  308 ++-
 drivers/net/wireless/intel/iwlwifi/queue/tx.h      |   68 +-
 drivers/net/wireless/intersil/hostap/hostap_hw.c   |   17 +-
 .../net/wireless/intersil/hostap/hostap_ioctl.c    |   15 +-
 drivers/net/wireless/intersil/orinoco/hermes.c     |    1 +
 drivers/net/wireless/intersil/orinoco/hermes.h     |   15 +
 drivers/net/wireless/intersil/orinoco/hw.c         |   32 +-
 .../net/wireless/intersil/orinoco/orinoco_usb.c    |  168 +-
 drivers/net/wireless/intersil/prism54/isl_ioctl.c  |    5 +-
 drivers/net/wireless/marvell/mwifiex/Makefile      |    6 +-
 drivers/net/wireless/marvell/mwifiex/README        |    7 +-
 drivers/net/wireless/marvell/mwifiex/join.c        |    2 +
 drivers/net/wireless/marvell/mwifiex/main.c        |    6 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c        |   24 +-
 drivers/net/wireless/marvell/mwifiex/pcie.h        |    2 +
 drivers/net/wireless/marvell/mwifiex/sdio.h        |    2 -
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |    2 +
 drivers/net/wireless/marvell/mwifiex/sta_event.c   |    1 +
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c     |    1 +
 drivers/net/wireless/marvell/mwifiex/wmm.c         |    1 +
 drivers/net/wireless/marvell/mwl8k.c               |   72 +-
 drivers/net/wireless/mediatek/mt76/debugfs.c       |    4 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |   37 +-
 drivers/net/wireless/mediatek/mt76/eeprom.c        |   12 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |  149 +-
 drivers/net/wireless/mediatek/mt76/mcu.c           |   80 +
 drivers/net/wireless/mediatek/mt76/mt76.h          |  121 +-
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c |   30 +-
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |   61 +-
 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c |    7 +-
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |    4 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |    9 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |   12 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c    |  131 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/pci.c    |    3 +-
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |  139 +-
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |   55 +-
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |   22 +-
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |   23 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  199 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |  122 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |  544 ++---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h    |   17 +
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |    9 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   92 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_init.c   |    9 +-
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |   11 +
 drivers/net/wireless/mediatek/mt76/mt7615/sdio.c   |   71 +-
 .../net/wireless/mediatek/mt76/mt7615/sdio_mcu.c   |   42 +-
 .../net/wireless/mediatek/mt76/mt7615/sdio_txrx.c  |  142 +-
 .../net/wireless/mediatek/mt76/mt7615/testmode.c   |   28 +-
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c    |    9 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_mcu.c    |   16 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_sdio.c   |   89 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c |   12 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |    4 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |    3 +-
 .../net/wireless/mediatek/mt76/mt76x0/pci_mcu.c    |    1 +
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    |    4 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |    1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c   |   10 +-
 .../net/wireless/mediatek/mt76/mt76x02_eeprom.c    |    8 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |   16 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c   |   55 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h   |    2 +
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |   76 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  |    2 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   |    1 +
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/eeprom.c |    6 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c    |   18 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c    |    3 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_init.c   |    2 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_mcu.c    |    1 +
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |    1 +
 drivers/net/wireless/mediatek/mt76/mt7915/Makefile |    2 +
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |   47 +-
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    |   76 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c |   64 +-
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.h |    1 +
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |  435 ++--
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  539 ++++-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.h    |   16 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |  133 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  734 +++---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |   54 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |   64 +-
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |   24 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |   52 +-
 .../net/wireless/mediatek/mt76/mt7915/testmode.c   |  377 +++
 .../net/wireless/mediatek/mt76/mt7915/testmode.h   |   40 +
 drivers/net/wireless/mediatek/mt76/sdio.c          |  196 +-
 drivers/net/wireless/mediatek/mt76/testmode.c      |   41 +-
 drivers/net/wireless/mediatek/mt76/testmode.h      |   18 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |   60 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |   89 +-
 drivers/net/wireless/mediatek/mt7601u/dma.c        |   12 +-
 drivers/net/wireless/microchip/wilc1000/cfg80211.c |    7 +-
 drivers/net/wireless/microchip/wilc1000/hif.c      |   17 +
 drivers/net/wireless/microchip/wilc1000/hif.h      |    1 +
 drivers/net/wireless/microchip/wilc1000/netdev.c   |   38 +
 drivers/net/wireless/microchip/wilc1000/netdev.h   |   11 +-
 drivers/net/wireless/microchip/wilc1000/spi.c      |   23 +-
 drivers/net/wireless/microchip/wilc1000/wlan.c     |  334 ++-
 drivers/net/wireless/microchip/wilc1000/wlan.h     |   30 +
 drivers/net/wireless/quantenna/qtnfmac/core.c      |   78 +-
 drivers/net/wireless/quantenna/qtnfmac/core.h      |    4 -
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c |    6 +-
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   |    4 +-
 .../wireless/quantenna/qtnfmac/pcie/topaz_pcie.c   |    4 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |   62 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00.h        |   10 +
 drivers/net/wireless/ralink/rt2x00/rt2x00config.c  |    1 -
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c     |    6 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c     |    3 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c   |    1 +
 drivers/net/wireless/ray_cs.c                      |    6 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    |   48 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    |    4 +-
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    |   27 +-
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |   28 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |    1 -
 .../net/wireless/realtek/rtlwifi/rtl8188ee/phy.c   |    4 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.c   |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/trx.c   |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/mac.c   |    7 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/trx.c   |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/dm.c    |   13 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   |    2 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.c   |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    |    1 -
 .../net/wireless/realtek/rtlwifi/rtl8723ae/phy.c   |    4 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/trx.c   |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/phy.c   |    4 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.c   |    4 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   |   96 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/table.c |    4 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/table.h |    4 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |    1 -
 drivers/net/wireless/realtek/rtw88/coex.c          | 1538 ++++++++++---
 drivers/net/wireless/realtek/rtw88/coex.h          |   47 +-
 drivers/net/wireless/realtek/rtw88/debug.c         |   27 +-
 drivers/net/wireless/realtek/rtw88/debug.h         |    1 +
 drivers/net/wireless/realtek/rtw88/fw.c            |    8 +-
 drivers/net/wireless/realtek/rtw88/fw.h            |   11 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |    9 +-
 drivers/net/wireless/realtek/rtw88/main.c          |   60 +-
 drivers/net/wireless/realtek/rtw88/main.h          |   41 +-
 drivers/net/wireless/realtek/rtw88/pci.h           |    8 +
 drivers/net/wireless/realtek/rtw88/phy.c           |    6 +
 drivers/net/wireless/realtek/rtw88/ps.c            |  135 +-
 drivers/net/wireless/realtek/rtw88/ps.h            |    3 +-
 drivers/net/wireless/realtek/rtw88/reg.h           |   17 +-
 drivers/net/wireless/realtek/rtw88/rtw8723d.c      |   96 +-
 drivers/net/wireless/realtek/rtw88/rtw8723d.h      |    3 +
 drivers/net/wireless/realtek/rtw88/rtw8723de.c     |    1 +
 drivers/net/wireless/realtek/rtw88/rtw8723de.h     |    4 -
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |   16 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.h      |    2 -
 drivers/net/wireless/realtek/rtw88/rtw8821ce.c     |    1 +
 drivers/net/wireless/realtek/rtw88/rtw8821ce.h     |    4 -
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |   55 +-
 drivers/net/wireless/realtek/rtw88/rtw8822be.c     |    1 +
 drivers/net/wireless/realtek/rtw88/rtw8822be.h     |    4 -
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |  136 +-
 drivers/net/wireless/realtek/rtw88/rtw8822ce.c     |    1 +
 drivers/net/wireless/realtek/rtw88/rtw8822ce.h     |    4 -
 drivers/net/wireless/realtek/rtw88/wow.c           |    8 +-
 drivers/net/wireless/rndis_wlan.c                  |    2 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |    3 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |    6 +-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c        |  173 +-
 drivers/net/wireless/rsi/rsi_91x_usb.c             |   36 +-
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c         |    2 +-
 drivers/net/wireless/rsi/rsi_sdio.h                |    8 +-
 drivers/net/wireless/st/cw1200/bh.c                |   10 +-
 drivers/net/wireless/st/cw1200/main.c              |    2 +
 drivers/net/wireless/st/cw1200/txrx.c              |    2 +-
 drivers/net/wireless/st/cw1200/wsm.c               |    8 +-
 drivers/net/wireless/ti/wl1251/cmd.c               |    2 +-
 drivers/net/wireless/ti/wl1251/debugfs.c           |    2 +-
 drivers/net/wireless/ti/wlcore/main.c              |    4 +-
 drivers/net/wireless/ti/wlcore/spi.c               |    3 +-
 drivers/net/wireless/ti/wlcore/sysfs.c             |    2 +-
 drivers/net/wireless/wl3501_cs.c                   |    8 +-
 drivers/net/wireless/zydas/zd1201.c                |    2 +-
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c       |   15 -
 drivers/net/xen-netfront.c                         |    5 +-
 drivers/nfc/nxp-nci/i2c.c                          |    2 +-
 drivers/nfc/pn533/usb.c                            |    2 +-
 drivers/nfc/s3fwrn5/Kconfig                        |   12 +
 drivers/nfc/s3fwrn5/Makefile                       |    4 +-
 drivers/nfc/s3fwrn5/core.c                         |   26 +-
 drivers/nfc/s3fwrn5/firmware.c                     |   17 +-
 drivers/nfc/s3fwrn5/firmware.h                     |    1 +
 drivers/nfc/s3fwrn5/i2c.c                          |  121 +-
 drivers/nfc/s3fwrn5/phy_common.c                   |   75 +
 drivers/nfc/s3fwrn5/phy_common.h                   |   37 +
 drivers/nfc/s3fwrn5/s3fwrn5.h                      |   11 +-
 drivers/nfc/s3fwrn5/uart.c                         |  196 ++
 drivers/ptp/Kconfig                                |   14 +
 drivers/ptp/Makefile                               |    1 +
 drivers/ptp/idt8a340_reg.h                         |    1 +
 drivers/ptp/ptp_clockmatrix.c                      |  330 ++-
 drivers/ptp/ptp_clockmatrix.h                      |   24 +-
 drivers/ptp/ptp_idt82p33.c                         |  274 ++-
 drivers/ptp/ptp_idt82p33.h                         |    3 +
 drivers/ptp/ptp_ines.c                             |   19 +-
 drivers/ptp/ptp_ocp.c                              |  398 ++++
 drivers/s390/cio/ccwgroup.c                        |   12 +-
 drivers/s390/net/ctcm_fsms.c                       |   15 +-
 drivers/s390/net/ctcm_main.c                       |   68 +-
 drivers/s390/net/ctcm_main.h                       |    5 -
 drivers/s390/net/ctcm_mpc.c                        |   39 +-
 drivers/s390/net/qeth_core.h                       |   32 +-
 drivers/s390/net/qeth_core_main.c                  |  334 ++-
 drivers/s390/net/qeth_core_mpc.h                   |   40 +-
 drivers/s390/net/qeth_core_sys.c                   |   41 +-
 drivers/s390/net/qeth_ethtool.c                    |  243 +-
 drivers/s390/net/qeth_l2.h                         |    2 -
 drivers/s390/net/qeth_l2_main.c                    |   37 +-
 drivers/s390/net/qeth_l2_sys.c                     |   19 -
 drivers/s390/net/qeth_l3.h                         |    2 -
 drivers/s390/net/qeth_l3_main.c                    |    9 +-
 drivers/s390/net/qeth_l3_sys.c                     |   21 -
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c                  |    2 +
 drivers/scsi/fcoe/fcoe_transport.c                 |    1 +
 drivers/soc/fsl/qbman/qman.c                       |   12 +-
 drivers/soc/fsl/qbman/qman_test_api.c              |    6 +-
 drivers/soc/fsl/qbman/qman_test_stash.c            |    6 +-
 drivers/staging/Kconfig                            |    2 +
 drivers/staging/Makefile                           |    1 +
 drivers/staging/fsl-dpaa2/ethsw/ethsw-ethtool.c    |    2 +
 .../staging/wimax/Documentation}/i2400m.rst        |    0
 .../staging/wimax/Documentation}/index.rst         |    0
 .../staging/wimax/Documentation}/wimax.rst         |    0
 {net => drivers/staging}/wimax/Kconfig             |    6 +
 {net => drivers/staging}/wimax/Makefile            |    2 +
 drivers/staging/wimax/TODO                         |   18 +
 {net => drivers/staging}/wimax/debug-levels.h      |    2 +-
 {net => drivers/staging}/wimax/debugfs.c           |    2 +-
 drivers/{net => staging}/wimax/i2400m/Kconfig      |    0
 drivers/{net => staging}/wimax/i2400m/Makefile     |    0
 drivers/{net => staging}/wimax/i2400m/control.c    |    2 +-
 .../{net => staging}/wimax/i2400m/debug-levels.h   |    2 +-
 drivers/{net => staging}/wimax/i2400m/debugfs.c    |    0
 drivers/{net => staging}/wimax/i2400m/driver.c     |    2 +-
 drivers/{net => staging}/wimax/i2400m/fw.c         |    0
 drivers/{net => staging}/wimax/i2400m/i2400m-usb.h |    0
 drivers/{net => staging}/wimax/i2400m/i2400m.h     |    4 +-
 .../staging/wimax/i2400m/linux-wimax-i2400m.h      |    0
 drivers/{net => staging}/wimax/i2400m/netdev.c     |    0
 drivers/{net => staging}/wimax/i2400m/op-rfkill.c  |    2 +-
 drivers/{net => staging}/wimax/i2400m/rx.c         |    0
 drivers/{net => staging}/wimax/i2400m/sysfs.c      |    0
 drivers/{net => staging}/wimax/i2400m/tx.c         |    0
 .../wimax/i2400m/usb-debug-levels.h                |    2 +-
 drivers/{net => staging}/wimax/i2400m/usb-fw.c     |    0
 drivers/{net => staging}/wimax/i2400m/usb-notif.c  |    0
 drivers/{net => staging}/wimax/i2400m/usb-rx.c     |    0
 drivers/{net => staging}/wimax/i2400m/usb-tx.c     |    0
 drivers/{net => staging}/wimax/i2400m/usb.c        |    3 +-
 {net => drivers/staging}/wimax/id-table.c          |    2 +-
 .../staging/wimax/linux-wimax-debug.h              |    2 +-
 .../wimax.h => drivers/staging/wimax/linux-wimax.h |    0
 .../wimax.h => drivers/staging/wimax/net-wimax.h   |    2 +-
 {net => drivers/staging}/wimax/op-msg.c            |    2 +-
 {net => drivers/staging}/wimax/op-reset.c          |    4 +-
 {net => drivers/staging}/wimax/op-rfkill.c         |    4 +-
 {net => drivers/staging}/wimax/op-state-get.c      |    4 +-
 {net => drivers/staging}/wimax/stack.c             |   29 +-
 {net => drivers/staging}/wimax/wimax-internal.h    |    2 +-
 drivers/vdpa/mlx5/Makefile                         |    2 +-
 drivers/vdpa/mlx5/net/main.c                       |   76 -
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |   53 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.h                  |   24 -
 fs/buffer.c                                        |    2 +-
 fs/eventpoll.c                                     |    6 +-
 fs/io_uring.c                                      |   16 +-
 fs/iomap/buffered-io.c                             |    2 +-
 include/dt-bindings/firmware/imx/rsrc.h            |    1 +
 include/keys/rxrpc-type.h                          |   56 +-
 include/linux/atmdev.h                             |    1 +
 include/linux/auxiliary_bus.h                      |   77 +
 include/linux/bpf-cgroup.h                         |   12 +-
 include/linux/bpf.h                                |   80 +-
 include/linux/bpf_lsm.h                            |   30 +
 include/linux/bpf_types.h                          |    1 +
 include/linux/bpf_verifier.h                       |   30 +-
 include/linux/btf.h                                |    6 +-
 include/linux/can/dev.h                            |   38 +-
 include/linux/can/dev/peak_canfd.h                 |    2 +-
 include/linux/ethtool.h                            |    1 +
 include/linux/genl_magic_struct.h                  |    2 +-
 include/linux/ieee80211.h                          |   12 +-
 include/linux/if_bridge.h                          |    1 +
 include/linux/if_frad.h                            |   92 -
 include/linux/if_macvlan.h                         |    1 +
 include/linux/ima.h                                |    6 +
 include/linux/inetdevice.h                         |    4 +-
 include/linux/key-type.h                           |    1 +
 include/linux/lockdep.h                            |   11 +
 include/linux/lsm_audit.h                          |    2 +-
 include/linux/lsm_hook_defs.h                      |    2 +-
 include/linux/marvell_phy.h                        |    3 +
 include/linux/memcontrol.h                         |  215 +-
 include/linux/mhi.h                                |    9 +-
 include/linux/mlx4/device.h                        |    1 -
 include/linux/mlx5/device.h                        |    8 +
 include/linux/mlx5/driver.h                        |   42 +-
 include/linux/mlx5/eswitch.h                       |    8 +-
 include/linux/mlx5/fs.h                            |    6 +-
 include/linux/mlx5/mlx5_ifc.h                      |   94 +-
 .../linux/mlx5/mlx5_ifc_vdpa.h                     |    8 +-
 include/linux/mm.h                                 |   22 -
 include/linux/mm_types.h                           |    5 +-
 include/linux/mod_devicetable.h                    |    8 +
 include/linux/module.h                             |    4 +
 include/linux/net.h                                |    2 +-
 include/linux/netdev_features.h                    |    4 +-
 include/linux/netdevice.h                          |   76 +-
 include/linux/netfilter/ipset/ip_set.h             |    5 +
 include/linux/page-flags.h                         |   11 +-
 include/linux/phy.h                                |   22 +-
 include/linux/platform_data/hirschmann-hellcreek.h |   23 +
 include/linux/ptp_classify.h                       |    7 +-
 include/linux/ptp_clock_kernel.h                   |   13 +
 include/linux/qed/qed_if.h                         |    1 +
 include/linux/rfkill.h                             |   24 +-
 include/linux/sctp.h                               |   20 +
 include/linux/sdla.h                               |  240 --
 include/linux/security.h                           |    5 +-
 include/linux/skbuff.h                             |   22 +
 include/linux/soc/marvell/octeontx2/asm.h          |   29 +
 include/linux/usb/r8152.h                          |   37 +
 include/linux/usb/usbnet.h                         |    4 -
 include/net/act_api.h                              |    6 +
 include/net/bluetooth/hci.h                        |    7 +
 include/net/bluetooth/hci_core.h                   |   23 +-
 include/net/bluetooth/mgmt.h                       |   53 +-
 include/net/bpf_sk_storage.h                       |    2 +
 include/net/busy_poll.h                            |   27 +-
 include/net/cfg80211.h                             |   97 +-
 include/net/compat.h                               |   10 -
 include/net/devlink.h                              |   13 +-
 include/net/dsa.h                                  |    8 +
 include/net/dst.h                                  |   12 +-
 include/net/ieee80211_radiotap.h                   |    1 +
 include/net/inet_ecn.h                             |   14 +-
 include/net/inet_frag.h                            |    1 +
 include/net/ip.h                                   |    2 +-
 include/net/ip_tunnels.h                           |    2 -
 include/net/mac80211.h                             |   42 +-
 include/net/mptcp.h                                |   25 +-
 include/net/net_namespace.h                        |    3 -
 include/net/netfilter/ipv4/nf_reject.h             |   14 +-
 include/net/netfilter/ipv6/nf_reject.h             |   14 +-
 include/net/netfilter/nf_conntrack_l4proto.h       |   16 +-
 include/net/netfilter/nf_tables.h                  |   95 +-
 include/net/netlink.h                              |    4 +-
 include/net/netns/sctp.h                           |    8 +
 include/net/nexthop.h                              |   42 +-
 include/net/nfc/nci.h                              |   34 +
 include/net/page_pool.h                            |   26 +
 include/net/pkt_cls.h                              |    4 +-
 include/net/pkt_sched.h                            |    5 +
 include/net/sch_generic.h                          |    5 +-
 include/net/sctp/constants.h                       |    2 +
 include/net/sctp/sctp.h                            |    9 +-
 include/net/sctp/sm.h                              |    4 +
 include/net/sctp/structs.h                         |   12 +-
 include/net/sock.h                                 |   28 +-
 include/net/switchdev.h                            |    2 +
 include/net/tcp.h                                  |   35 +-
 include/net/tls.h                                  |   32 +-
 include/net/udp.h                                  |    6 +-
 include/net/xdp.h                                  |   20 +-
 include/net/xdp_sock_drv.h                         |    7 +
 include/rdma/ib_addr.h                             |    1 +
 include/rdma/ib_verbs.h                            |    1 +
 include/soc/fsl/qman.h                             |    3 +-
 include/soc/mscc/ocelot.h                          |   20 +-
 include/trace/events/writeback.h                   |    2 +-
 include/trace/events/xdp.h                         |   12 +-
 include/uapi/asm-generic/socket.h                  |    3 +
 include/uapi/linux/batman_adv.h                    |   26 +
 include/uapi/linux/bpf.h                           |  105 +-
 include/uapi/linux/can.h                           |   38 +-
 include/uapi/linux/can/gw.h                        |    4 +-
 include/uapi/linux/can/isotp.h                     |    2 +-
 include/uapi/linux/can/netlink.h                   |    1 +
 include/uapi/linux/cfm_bridge.h                    |   64 +
 include/uapi/linux/if_bridge.h                     |  126 +
 include/uapi/linux/if_ether.h                      |    1 +
 include/uapi/linux/if_frad.h                       |  123 -
 include/uapi/linux/if_link.h                       |    2 +
 include/uapi/linux/if_packet.h                     |   12 +
 include/uapi/linux/mrp_bridge.h                    |    1 +
 include/uapi/linux/netfilter/ipset/ip_set.h        |    6 +-
 include/uapi/linux/netfilter/nf_tables.h           |    6 +
 include/uapi/linux/nl80211.h                       |  152 +-
 include/uapi/linux/ppp-ioctl.h                     |    2 +
 include/uapi/linux/rfkill.h                        |   16 +-
 include/uapi/linux/rtnetlink.h                     |   20 +-
 include/uapi/linux/sctp.h                          |    7 +
 include/uapi/linux/sdla.h                          |  117 -
 include/uapi/linux/seg6_local.h                    |    1 +
 include/uapi/linux/smc.h                           |  126 +
 include/uapi/linux/snmp.h                          |    1 +
 include/uapi/linux/tcp.h                           |    4 +
 include/uapi/linux/tls.h                           |   15 +
 include/uapi/linux/vm_sockets.h                    |   26 +-
 include/uapi/rdma/mlx5_user_ioctl_cmds.h           |    2 +-
 kernel/bpf/Makefile                                |    1 +
 kernel/bpf/arraymap.c                              |   30 +-
 kernel/bpf/bpf_iter.c                              |   14 +
 kernel/bpf/bpf_local_storage.c                     |   20 +-
 kernel/bpf/bpf_lsm.c                               |  140 ++
 kernel/bpf/bpf_struct_ops.c                        |   19 +-
 kernel/bpf/bpf_task_storage.c                      |  315 +++
 kernel/bpf/btf.c                                   |  481 +++-
 kernel/bpf/core.c                                  |   23 +-
 kernel/bpf/cpumap.c                                |   37 +-
 kernel/bpf/devmap.c                                |   25 +-
 kernel/bpf/hashtab.c                               |  189 +-
 kernel/bpf/helpers.c                               |   13 +
 kernel/bpf/local_storage.c                         |   44 +-
 kernel/bpf/lpm_trie.c                              |   19 +-
 kernel/bpf/queue_stack_maps.c                      |   16 +-
 kernel/bpf/reuseport_array.c                       |   12 +-
 kernel/bpf/ringbuf.c                               |   35 +-
 kernel/bpf/stackmap.c                              |   16 +-
 kernel/bpf/syscall.c                               |  316 ++-
 kernel/bpf/sysfs_btf.c                             |    2 +-
 kernel/bpf/task_iter.c                             |   56 +-
 kernel/bpf/verifier.c                              |  441 ++--
 kernel/fork.c                                      |    7 +-
 kernel/kcov.c                                      |    2 +
 kernel/module.c                                    |   36 +
 kernel/taskstats.c                                 |    2 +-
 kernel/trace/bpf_trace.c                           |   41 +-
 lib/Kconfig.debug                                  |    9 +
 lib/nlattr.c                                       |   42 +-
 mm/debug.c                                         |    4 +-
 mm/huge_memory.c                                   |    4 +-
 mm/memcontrol.c                                    |  139 +-
 mm/page_alloc.c                                    |    8 +-
 mm/page_io.c                                       |    6 +-
 mm/slab.h                                          |   38 +-
 mm/workingset.c                                    |    2 +-
 net/9p/client.c                                    |    6 +-
 net/9p/trans_common.c                              |    4 +-
 net/9p/trans_fd.c                                  |    4 +-
 net/9p/trans_rdma.c                                |    2 +
 net/9p/trans_virtio.c                              |    9 +-
 net/Kconfig                                        |    2 -
 net/Makefile                                       |    1 -
 net/appletalk/aarp.c                               |   18 +-
 net/appletalk/ddp.c                                |    7 +-
 net/atm/raw.c                                      |   12 +-
 net/batman-adv/Kconfig                             |   27 +-
 net/batman-adv/Makefile                            |    3 -
 net/batman-adv/bat_algo.c                          |   34 +-
 net/batman-adv/bat_algo.h                          |    5 +-
 net/batman-adv/bat_iv_ogm.c                        |  229 --
 net/batman-adv/bat_v.c                             |  247 +-
 net/batman-adv/bat_v_elp.c                         |    1 +
 net/batman-adv/bat_v_ogm.c                         |    1 +
 net/batman-adv/bridge_loop_avoidance.c             |  130 --
 net/batman-adv/bridge_loop_avoidance.h             |   16 -
 net/batman-adv/debugfs.c                           |  442 ----
 net/batman-adv/debugfs.h                           |   73 -
 net/batman-adv/distributed-arp-table.c             |   55 -
 net/batman-adv/distributed-arp-table.h             |    2 -
 net/batman-adv/fragmentation.c                     |    3 +-
 net/batman-adv/gateway_client.c                    |   39 -
 net/batman-adv/gateway_client.h                    |    2 -
 net/batman-adv/hard-interface.c                    |   35 +-
 net/batman-adv/hard-interface.h                    |   25 +-
 net/batman-adv/icmp_socket.c                       |  392 ----
 net/batman-adv/icmp_socket.h                       |   38 -
 net/batman-adv/log.c                               |  209 --
 net/batman-adv/main.c                              |   46 +-
 net/batman-adv/main.h                              |    5 +-
 net/batman-adv/multicast.c                         |  111 -
 net/batman-adv/multicast.h                         |    3 -
 net/batman-adv/netlink.c                           |    1 +
 net/batman-adv/network-coding.c                    |   87 -
 net/batman-adv/network-coding.h                    |   13 -
 net/batman-adv/originator.c                        |  121 -
 net/batman-adv/originator.h                        |    4 -
 net/batman-adv/routing.c                           |   10 -
 net/batman-adv/soft-interface.c                    |  137 +-
 net/batman-adv/soft-interface.h                    |    1 -
 net/batman-adv/sysfs.c                             | 1272 -----------
 net/batman-adv/sysfs.h                             |   93 -
 net/batman-adv/tp_meter.c                          |    1 +
 net/batman-adv/translation-table.c                 |  212 --
 net/batman-adv/translation-table.h                 |    3 -
 net/batman-adv/types.h                             |   66 -
 net/bluetooth/hci_conn.c                           |   12 +-
 net/bluetooth/hci_core.c                           |   53 +-
 net/bluetooth/hci_debugfs.c                        |   50 +
 net/bluetooth/hci_event.c                          |   44 +-
 net/bluetooth/hci_request.c                        |  303 ++-
 net/bluetooth/hci_request.h                        |    2 +
 net/bluetooth/hidp/core.c                          |    2 +-
 net/bluetooth/l2cap_core.c                         |   10 +-
 net/bluetooth/mgmt.c                               |  436 +++-
 net/bluetooth/mgmt_config.c                        |  187 +-
 net/bluetooth/sco.c                                |    5 +
 net/bluetooth/smp.c                                |   44 +-
 net/bluetooth/smp.h                                |    2 +
 net/bridge/Kconfig                                 |   11 +
 net/bridge/Makefile                                |    2 +
 net/bridge/br.c                                    |    5 +-
 net/bridge/br_cfm.c                                |  867 +++++++
 net/bridge/br_cfm_netlink.c                        |  726 ++++++
 net/bridge/br_device.c                             |   39 +-
 net/bridge/br_if.c                                 |    1 +
 net/bridge/br_input.c                              |   41 +-
 net/bridge/br_mdb.c                                |   30 +-
 net/bridge/br_mrp.c                                |   59 +-
 net/bridge/br_mrp_netlink.c                        |    2 +-
 net/bridge/br_multicast.c                          |   13 +-
 net/bridge/br_netlink.c                            |  117 +-
 net/bridge/br_private.h                            |  107 +-
 net/bridge/br_private_cfm.h                        |  147 ++
 net/bridge/br_private_mrp.h                        |    2 +-
 net/bridge/br_vlan.c                               |   31 +-
 net/bridge/netfilter/Kconfig                       |    4 +-
 net/bridge/netfilter/nft_reject_bridge.c           |  255 +--
 net/can/af_can.c                                   |    2 +-
 net/can/gw.c                                       |   80 +-
 net/can/isotp.c                                    |   42 +-
 net/can/j1939/main.c                               |    4 +-
 net/core/bpf_sk_storage.c                          |  136 +-
 net/core/datagram.c                                |    2 +-
 net/core/dev.c                                     |  137 +-
 net/core/dev_ioctl.c                               |    2 +-
 net/core/devlink.c                                 |   44 +-
 net/core/fib_rules.c                               |    4 +-
 net/core/filter.c                                  |   25 +
 net/core/flow_dissector.c                          |    2 +-
 net/core/netclassid_cgroup.c                       |    3 +-
 net/core/netprio_cgroup.c                          |    3 +-
 net/core/page_pool.c                               |   70 +-
 net/core/rtnetlink.c                               |   36 +-
 net/core/skbuff.c                                  |   18 +-
 net/core/sock.c                                    |   32 +-
 net/core/sock_map.c                                |   42 +-
 net/core/xdp.c                                     |   57 +-
 net/dcb/dcbnl.c                                    |   16 +-
 net/dccp/ackvec.c                                  |    5 +
 net/dccp/ccid.c                                    |    2 +-
 net/dccp/ccids/ccid2.c                             |    5 +
 net/dccp/ccids/ccid3.c                             |    6 +
 net/dccp/ccids/lib/loss_interval.c                 |    3 +
 net/dccp/ccids/lib/packet_history.c                |    3 +
 net/dccp/feat.c                                    |    6 +
 net/dccp/output.c                                  |    9 +
 net/dccp/qpolicy.c                                 |    6 +-
 net/dccp/timer.c                                   |   12 +-
 net/decnet/dn_dev.c                                |    2 +-
 net/dsa/Kconfig                                    |   11 +
 net/dsa/Makefile                                   |    4 +-
 net/dsa/dsa.c                                      |    7 +-
 net/dsa/dsa_priv.h                                 |    2 -
 net/dsa/master.c                                   |    7 +-
 net/dsa/slave.c                                    |   96 +-
 net/dsa/tag_ar9331.c                               |    3 -
 net/dsa/tag_brcm.c                                 |    3 -
 net/dsa/tag_dsa.c                                  |  332 ++-
 net/dsa/tag_edsa.c                                 |  206 --
 net/dsa/tag_gswip.c                                |    5 -
 net/dsa/tag_hellcreek.c                            |   64 +
 net/dsa/tag_ksz.c                                  |   73 +-
 net/dsa/tag_lan9303.c                              |    9 -
 net/dsa/tag_mtk.c                                  |    3 -
 net/dsa/tag_ocelot.c                               |    7 -
 net/dsa/tag_qca.c                                  |    3 -
 net/dsa/tag_trailer.c                              |   31 +-
 net/ethernet/eth.c                                 |    6 +-
 net/ethtool/ioctl.c                                |    2 +-
 net/ieee802154/nl-mac.c                            |    2 +-
 net/ipv4/af_inet.c                                 |    2 +-
 net/ipv4/bpf_tcp_ca.c                              |    3 +-
 net/ipv4/devinet.c                                 |    5 +-
 net/ipv4/fib_semantics.c                           |    7 +-
 net/ipv4/fib_trie.c                                |    9 -
 net/ipv4/inet_fragment.c                           |   47 +-
 net/ipv4/ip_gre.c                                  |    6 +-
 net/ipv4/ip_tunnel_core.c                          |    9 -
 net/ipv4/ip_vti.c                                  |    2 +-
 net/ipv4/ipconfig.c                                |   14 +-
 net/ipv4/ipip.c                                    |    2 +-
 net/ipv4/metrics.c                                 |    2 +-
 net/ipv4/netfilter/ipt_REJECT.c                    |    3 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |  134 +-
 net/ipv4/netfilter/nft_reject_ipv4.c               |    3 +-
 net/ipv4/nexthop.c                                 |  255 ++-
 net/ipv4/proc.c                                    |    1 +
 net/ipv4/route.c                                   |   15 +-
 net/ipv4/tcp.c                                     |  603 +++--
 net/ipv4/tcp_input.c                               |   48 +-
 net/ipv4/tcp_ipv4.c                                |   23 +-
 net/ipv4/tcp_lp.c                                  |    7 +
 net/ipv4/tcp_minisocks.c                           |    2 +-
 net/ipv4/tcp_output.c                              |   22 +-
 net/ipv4/tcp_recovery.c                            |    3 +-
 net/ipv4/udp.c                                     |   10 +-
 net/ipv4/udp_diag.c                                |    2 +-
 net/ipv4/udp_offload.c                             |    5 +-
 net/ipv6/addrconf.c                                |    1 +
 net/ipv6/af_inet6.c                                |    2 +-
 net/ipv6/calipso.c                                 |    4 +-
 net/ipv6/exthdrs.c                                 |    5 -
 net/ipv6/ip6_gre.c                                 |    6 +-
 net/ipv6/ip6_tunnel.c                              |   47 +-
 net/ipv6/ip6_vti.c                                 |    3 +-
 net/ipv6/ipv6_sockglue.c                           |    2 +-
 net/ipv6/mcast.c                                   |    2 +-
 net/ipv6/netfilter/ip6t_REJECT.c                   |    2 +-
 net/ipv6/netfilter/nf_reject_ipv6.c                |  144 +-
 net/ipv6/netfilter/nft_reject_ipv6.c               |    3 +-
 net/ipv6/proc.c                                    |    2 +
 net/ipv6/route.c                                   |    9 +-
 net/ipv6/rpl.c                                     |    2 +-
 net/ipv6/rpl_iptunnel.c                            |    9 +-
 net/ipv6/seg6_local.c                              |  590 ++++-
 net/ipv6/sit.c                                     |    2 +-
 net/ipv6/tcp_ipv6.c                                |    9 +-
 net/ipv6/udp.c                                     |    8 +-
 net/ipv6/udp_offload.c                             |    8 +-
 net/iucv/af_iucv.c                                 |    8 +-
 net/l3mdev/l3mdev.c                                |    1 +
 net/lapb/lapb_iface.c                              |   82 +-
 net/lapb/lapb_timer.c                              |   11 +-
 net/llc/llc_conn.c                                 |    2 +
 net/mac80211/agg-rx.c                              |    8 +-
 net/mac80211/agg-tx.c                              |   12 +-
 net/mac80211/cfg.c                                 |   33 +-
 net/mac80211/chan.c                                |   74 +-
 net/mac80211/debugfs.c                             |    2 +-
 net/mac80211/debugfs_key.c                         |    2 +-
 net/mac80211/debugfs_netdev.c                      |   17 +-
 net/mac80211/debugfs_sta.c                         |    4 +-
 net/mac80211/ieee80211_i.h                         |   24 +-
 net/mac80211/iface.c                               |   54 +-
 net/mac80211/key.c                                 |   49 +
 net/mac80211/main.c                                |   22 +-
 net/mac80211/mesh.c                                |   30 +
 net/mac80211/mlme.c                                |  123 +-
 net/mac80211/pm.c                                  |   15 -
 net/mac80211/rx.c                                  |   41 +-
 net/mac80211/trace.h                               |   23 +-
 net/mac80211/tx.c                                  |   60 +-
 net/mac80211/util.c                                |   73 +-
 net/mac80211/vht.c                                 |   14 +-
 net/mac80211/wme.c                                 |   18 +-
 net/mac802154/main.c                               |    8 +-
 net/mpls/af_mpls.c                                 |    2 +
 net/mptcp/ctrl.c                                   |   14 +
 net/mptcp/mptcp_diag.c                             |    2 +-
 net/mptcp/options.c                                |  218 +-
 net/mptcp/pm.c                                     |   72 +-
 net/mptcp/pm_netlink.c                             |   84 +-
 net/mptcp/protocol.c                               | 1813 ++++++++++-----
 net/mptcp/protocol.h                               |  192 +-
 net/mptcp/subflow.c                                |  165 +-
 net/netfilter/Kconfig                              |   10 +
 net/netfilter/Makefile                             |    1 +
 net/netfilter/ipset/ip_set_core.c                  |    6 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |   45 +-
 net/netfilter/ipset/ip_set_hash_ip.c               |    7 +-
 net/netfilter/ipset/ip_set_hash_ipmac.c            |    6 +-
 net/netfilter/ipset/ip_set_hash_ipmark.c           |    7 +-
 net/netfilter/ipset/ip_set_hash_ipport.c           |    7 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c         |    7 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c        |    7 +-
 net/netfilter/ipset/ip_set_hash_mac.c              |    6 +-
 net/netfilter/ipset/ip_set_hash_net.c              |    7 +-
 net/netfilter/ipset/ip_set_hash_netiface.c         |   11 +-
 net/netfilter/ipset/ip_set_hash_netnet.c           |    7 +-
 net/netfilter/ipset/ip_set_hash_netport.c          |    7 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c       |    7 +-
 net/netfilter/ipvs/ip_vs_core.c                    |    2 +-
 net/netfilter/ipvs/ip_vs_sync.c                    |    4 +-
 net/netfilter/nf_conntrack_netlink.c               |   31 +-
 net/netfilter/nf_conntrack_proto_dccp.c            |   13 +-
 net/netfilter/nf_conntrack_proto_sctp.c            |   13 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |   19 +-
 net/netfilter/nf_tables_api.c                      |  259 ++-
 net/netfilter/nfnetlink_acct.c                     |   40 +-
 net/netfilter/nfnetlink_cthelper.c                 |    4 +-
 net/netfilter/nft_ct.c                             |    2 +-
 net/netfilter/nft_dynset.c                         |  156 +-
 net/netfilter/nft_log.c                            |    2 +-
 net/netfilter/nft_reject.c                         |   12 +-
 net/netfilter/nft_reject_inet.c                    |   74 +-
 net/netfilter/nft_reject_netdev.c                  |  189 ++
 net/netfilter/nft_set_hash.c                       |   27 +-
 net/netfilter/xt_nfacct.c                          |    2 +-
 net/netlabel/netlabel_calipso.c                    |    1 +
 net/netlabel/netlabel_mgmt.c                       |    2 +-
 net/nfc/Kconfig                                    |    2 +-
 net/nfc/core.c                                     |   10 +-
 net/nfc/digital_core.c                             |    3 +
 net/nfc/nci/core.c                                 |   20 +-
 net/nfc/nci/hci.c                                  |    9 +-
 net/nfc/nci/ntf.c                                  |   21 +
 net/nfc/nci/rsp.c                                  |   81 +-
 net/nfc/netlink.c                                  |    2 +-
 net/openvswitch/actions.c                          |   15 +-
 net/openvswitch/conntrack.c                        |   14 +-
 net/openvswitch/flow.c                             |    4 +
 net/openvswitch/meter.c                            |    2 +-
 net/openvswitch/vport-internal_dev.c               |   29 +-
 net/openvswitch/vport.c                            |    4 +-
 net/packet/af_packet.c                             |   40 +-
 net/packet/internal.h                              |    5 +-
 net/qrtr/mhi.c                                     |    6 +
 net/qrtr/ns.c                                      |    8 -
 net/qrtr/qrtr.c                                    |   49 +-
 net/rfkill/core.c                                  |   41 +-
 net/rxrpc/Makefile                                 |    1 +
 net/rxrpc/ar-internal.h                            |   63 +-
 net/rxrpc/call_accept.c                            |   14 +-
 net/rxrpc/conn_client.c                            |    6 -
 net/rxrpc/conn_event.c                             |    8 +-
 net/rxrpc/conn_object.c                            |    2 -
 net/rxrpc/conn_service.c                           |    2 -
 net/rxrpc/insecure.c                               |   19 +-
 net/rxrpc/key.c                                    |  658 +-----
 net/rxrpc/recvmsg.c                                |    2 +-
 net/rxrpc/rxkad.c                                  |  256 ++-
 net/rxrpc/security.c                               |   98 +-
 net/rxrpc/sendmsg.c                                |   45 +-
 net/rxrpc/server_key.c                             |  143 ++
 net/sched/Kconfig                                  |    8 +-
 net/sched/Makefile                                 |    1 +
 net/sched/act_api.c                                |   93 +-
 net/sched/act_bpf.c                                |    2 +-
 net/sched/act_ct.c                                 |    9 +-
 net/sched/act_ipt.c                                |    2 +-
 net/sched/act_mirred.c                             |   21 +-
 net/sched/act_simple.c                             |    4 +-
 net/sched/cls_api.c                                |   36 +-
 net/sched/cls_rsvp.h                               |    2 +-
 net/sched/cls_u32.c                                |   11 +-
 net/sched/em_cmp.c                                 |    2 +-
 net/sched/sch_api.c                                |    6 +-
 net/sched/sch_atm.c                                |    8 +-
 net/sched/sch_cbs.c                                |    1 +
 net/sched/sch_frag.c                               |  150 ++
 net/sched/sch_pie.c                                |    2 +-
 net/sched/sch_taprio.c                             |    1 +
 net/sctp/Kconfig                                   |    1 +
 net/sctp/associola.c                               |    4 +
 net/sctp/ipv6.c                                    |   44 +-
 net/sctp/offload.c                                 |    6 +-
 net/sctp/output.c                                  |   22 +-
 net/sctp/protocol.c                                |  142 +-
 net/sctp/sm_make_chunk.c                           |   21 +
 net/sctp/sm_statefuns.c                            |   52 +
 net/sctp/socket.c                                  |  116 +
 net/sctp/sysctl.c                                  |   62 +
 net/sctp/transport.c                               |    4 +-
 net/smc/Makefile                                   |    2 +-
 net/smc/af_smc.c                                   |  100 +-
 net/smc/smc_cdc.c                                  |    6 +-
 net/smc/smc_clc.c                                  |    5 +
 net/smc/smc_clc.h                                  |    6 +
 net/smc/smc_core.c                                 |  399 +++-
 net/smc/smc_core.h                                 |   50 +
 net/smc/smc_diag.c                                 |   23 +-
 net/smc/smc_ib.c                                   |  200 ++
 net/smc/smc_ib.h                                   |    6 +
 net/smc/smc_ism.c                                  |   99 +-
 net/smc/smc_ism.h                                  |    6 +-
 net/smc/smc_netlink.c                              |   85 +
 net/smc/smc_netlink.h                              |   32 +
 net/smc/smc_pnet.c                                 |    2 +
 net/smc/smc_wr.c                                   |   14 +-
 net/socket.c                                       |   53 +-
 net/sunrpc/rpc_pipe.c                              |    3 +-
 net/tipc/addr.c                                    |    7 +-
 net/tipc/addr.h                                    |    1 +
 net/tipc/bearer.c                                  |   27 +-
 net/tipc/bearer.h                                  |   10 +-
 net/tipc/core.c                                    |    2 -
 net/tipc/core.h                                    |   15 +-
 net/tipc/crypto.c                                  |   55 +-
 net/tipc/crypto.h                                  |    6 +-
 net/tipc/discover.c                                |    5 +-
 net/tipc/group.c                                   |    3 +-
 net/tipc/group.h                                   |    3 +-
 net/tipc/link.c                                    |   48 +-
 net/tipc/msg.c                                     |   29 +-
 net/tipc/name_distr.c                              |   48 +-
 net/tipc/name_distr.h                              |    2 +-
 net/tipc/name_table.c                              |   57 +-
 net/tipc/name_table.h                              |    9 +-
 net/tipc/net.c                                     |    2 +-
 net/tipc/netlink_compat.c                          |    7 +-
 net/tipc/node.c                                    |   60 +-
 net/tipc/socket.c                                  |  221 +-
 net/tipc/socket.h                                  |    2 +-
 net/tipc/subscr.c                                  |   13 +-
 net/tipc/subscr.h                                  |   16 +-
 net/tipc/topsrv.c                                  |    6 +-
 net/tipc/trace.c                                   |    2 +-
 net/tipc/udp_media.c                               |    8 +-
 net/tls/tls_device.c                               |    6 +-
 net/tls/tls_device_fallback.c                      |   13 +-
 net/tls/tls_main.c                                 |    3 +
 net/tls/tls_proc.c                                 |    3 +
 net/tls/tls_sw.c                                   |   34 +-
 net/vmw_vsock/af_vsock.c                           |   24 +-
 net/vmw_vsock/vsock_addr.c                         |    4 +-
 net/wireless/chan.c                                |    6 +-
 net/wireless/core.c                                |    8 +-
 net/wireless/core.h                                |    2 +
 net/wireless/mlme.c                                |   26 +-
 net/wireless/nl80211.c                             |  324 ++-
 net/wireless/nl80211.h                             |    8 +-
 net/wireless/rdev-ops.h                            |   22 +-
 net/wireless/reg.c                                 |   10 +-
 net/wireless/scan.c                                |   23 +-
 net/wireless/trace.h                               |   36 +-
 net/wireless/util.c                                |   89 +-
 net/wireless/wext-compat.c                         |  154 +-
 net/x25/af_x25.c                                   |   44 +-
 net/x25/x25_dev.c                                  |   13 -
 net/x25/x25_link.c                                 |   52 +-
 net/x25/x25_route.c                                |   10 +-
 net/xdp/xsk.c                                      |  114 +-
 net/xdp/xsk.h                                      |    2 -
 net/xdp/xsk_buff_pool.c                            |   13 +-
 net/xdp/xsk_queue.h                                |   93 +-
 net/xdp/xskmap.c                                   |   35 +-
 net/xfrm/xfrm_input.c                              |    7 +-
 net/xfrm/xfrm_interface.c                          |   19 +-
 net/xfrm/xfrm_user.c                               |   74 +-
 samples/bpf/.gitignore                             |    3 +
 samples/bpf/Makefile                               |   24 +-
 samples/bpf/bpf_load.c                             |  667 ------
 samples/bpf/bpf_load.h                             |   57 -
 samples/bpf/do_hbm_test.sh                         |   32 +-
 samples/bpf/hbm.c                                  |  112 +-
 samples/bpf/hbm_kern.h                             |    2 +-
 samples/bpf/ibumad_kern.c                          |   26 +-
 samples/bpf/ibumad_user.c                          |   71 +-
 samples/bpf/lwt_len_hist.sh                        |    2 +
 samples/bpf/map_perf_test_user.c                   |    6 -
 samples/bpf/offwaketime_user.c                     |    6 -
 samples/bpf/sockex2_user.c                         |    2 -
 samples/bpf/sockex3_user.c                         |    2 -
 samples/bpf/spintest_user.c                        |    6 -
 samples/bpf/syscall_tp_user.c                      |    2 -
 samples/bpf/task_fd_query_user.c                   |  103 +-
 samples/bpf/test_cgrp2_sock2.c                     |   61 +-
 samples/bpf/test_cgrp2_sock2.sh                    |   21 +-
 samples/bpf/test_ipip.sh                           |  179 --
 samples/bpf/test_lru_dist.c                        |    3 -
 samples/bpf/test_lwt_bpf.sh                        |    0
 samples/bpf/test_map_in_map_user.c                 |    6 -
 samples/bpf/test_overhead_user.c                   |   84 +-
 samples/bpf/trace_event_user.c                     |    2 -
 samples/bpf/tracex2_user.c                         |    6 -
 samples/bpf/tracex3_user.c                         |    6 -
 samples/bpf/tracex4_user.c                         |    6 -
 samples/bpf/tracex5_user.c                         |    3 -
 samples/bpf/tracex6_user.c                         |    3 -
 samples/bpf/xdp1_user.c                            |    6 -
 samples/bpf/xdp2skb_meta_kern.c                    |    2 +-
 samples/bpf/xdp_adjust_tail_user.c                 |    6 -
 samples/bpf/xdp_monitor_user.c                     |    5 -
 samples/bpf/xdp_redirect_cpu_user.c                |    6 -
 samples/bpf/xdp_redirect_map_user.c                |    6 -
 samples/bpf/xdp_redirect_user.c                    |    6 -
 samples/bpf/xdp_router_ipv4_user.c                 |    6 -
 samples/bpf/xdp_rxq_info_user.c                    |    6 -
 samples/bpf/xdp_sample_pkts_user.c                 |    6 -
 samples/bpf/xdp_tx_iptunnel_user.c                 |    6 -
 samples/bpf/xdpsock.h                              |    8 +
 samples/bpf/xdpsock_ctrl_proc.c                    |  187 ++
 samples/bpf/xdpsock_user.c                         |  232 +-
 scripts/Makefile.modfinal                          |   25 +-
 scripts/bpf_helpers_doc.py                         |    8 +
 scripts/mod/devicetable-offsets.c                  |    3 +
 scripts/mod/file2alias.c                           |    8 +
 security/apparmor/include/net.h                    |    2 +-
 security/apparmor/lsm.c                            |    2 +-
 security/apparmor/net.c                            |    6 +-
 security/bpf/hooks.c                               |    2 +
 security/integrity/ima/ima_main.c                  |   78 +-
 security/keys/key.c                                |    2 +
 security/lsm_audit.c                               |    4 +-
 security/security.c                                |    3 +-
 security/selinux/hooks.c                           |    2 +-
 security/smack/smack_lsm.c                         |    4 +-
 tools/bpf/bpftool/.gitignore                       |    2 +-
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |    3 +-
 tools/bpf/bpftool/Makefile                         |   44 +-
 tools/bpf/bpftool/bash-completion/bpftool          |    2 +-
 tools/bpf/bpftool/btf.c                            |   58 +-
 tools/bpf/bpftool/main.c                           |   15 +-
 tools/bpf/bpftool/main.h                           |    1 +
 tools/bpf/bpftool/map.c                            |    4 +-
 tools/bpf/bpftool/prog.c                           |   30 +-
 tools/bpf/resolve_btfids/Makefile                  |    9 -
 tools/bpf/resolve_btfids/main.c                    |    6 +-
 tools/bpf/runqslower/Makefile                      |   55 +-
 tools/build/Makefile                               |    4 -
 tools/include/uapi/linux/bpf.h                     |  105 +-
 tools/include/uapi/linux/if_link.h                 |    2 +
 tools/lib/bpf/bpf.c                                |  104 +-
 tools/lib/bpf/btf.c                                |  881 ++++---
 tools/lib/bpf/btf.h                                |    9 +
 tools/lib/bpf/libbpf.c                             |  589 +++--
 tools/lib/bpf/libbpf.h                             |    1 +
 tools/lib/bpf/libbpf.map                           |   13 +
 tools/lib/bpf/libbpf_internal.h                    |   31 +
 tools/lib/bpf/libbpf_probes.c                      |    1 +
 tools/lib/bpf/ringbuf.c                            |    6 +
 tools/lib/bpf/xsk.c                                |   92 +-
 tools/lib/bpf/xsk.h                                |   22 +-
 tools/objtool/Makefile                             |    9 -
 tools/perf/Makefile.perf                           |    4 -
 tools/power/acpi/Makefile.config                   |    1 -
 tools/scripts/Makefile.include                     |   10 +
 tools/testing/selftests/bpf/.gitignore             |    3 +-
 tools/testing/selftests/bpf/Makefile               |   73 +-
 tools/testing/selftests/bpf/README.rst             |   33 +-
 tools/testing/selftests/bpf/bpf_tcp_helpers.h      |    1 +
 tools/testing/selftests/bpf/bpf_testmod/.gitignore |    6 +
 tools/testing/selftests/bpf/bpf_testmod/Makefile   |   20 +
 .../selftests/bpf/bpf_testmod/bpf_testmod-events.h |   36 +
 .../selftests/bpf/bpf_testmod/bpf_testmod.c        |   52 +
 .../selftests/bpf/bpf_testmod/bpf_testmod.h        |   14 +
 tools/testing/selftests/bpf/btf_helpers.c          |  259 +++
 tools/testing/selftests/bpf/btf_helpers.h          |   19 +
 tools/testing/selftests/bpf/config                 |    5 +
 tools/testing/selftests/bpf/ima_setup.sh           |  123 +
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |  118 +
 tools/testing/selftests/bpf/prog_tests/btf.c       |   40 +-
 .../selftests/bpf/prog_tests/btf_dedup_split.c     |  325 +++
 .../selftests/bpf/prog_tests/btf_skc_cls_ingress.c |    2 +-
 tools/testing/selftests/bpf/prog_tests/btf_split.c |   99 +
 tools/testing/selftests/bpf/prog_tests/btf_write.c |   43 +
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |   80 +-
 .../selftests/bpf/prog_tests/hash_large_key.c      |   43 +
 .../selftests/bpf/prog_tests/module_attach.c       |   62 +
 .../selftests/bpf/prog_tests/sk_storage_tracing.c  |  135 ++
 .../selftests/bpf/prog_tests/tcp_hdr_options.c     |   12 +-
 .../testing/selftests/bpf/prog_tests/tcpbpf_user.c |  145 ++
 .../selftests/bpf/prog_tests/test_bprm_opts.c      |  116 +
 tools/testing/selftests/bpf/prog_tests/test_ima.c  |   74 +
 .../selftests/bpf/prog_tests/test_local_storage.c  |  212 +-
 .../selftests/bpf/prog_tests/test_skb_pkt_end.c    |   41 +
 tools/testing/selftests/bpf/progs/bind4_prog.c     |  102 +
 tools/testing/selftests/bpf/progs/bind6_prog.c     |  119 +
 tools/testing/selftests/bpf/progs/bpf_flow.c       |    2 +
 .../testing/selftests/bpf/progs/bpf_iter_bpf_map.c |    2 +-
 .../bpf/progs/bpf_iter_bpf_sk_storage_helpers.c    |   65 +
 tools/testing/selftests/bpf/progs/bpf_iter_task.c  |    3 +-
 tools/testing/selftests/bpf/progs/bprm_opts.c      |   34 +
 .../testing/selftests/bpf/progs/core_reloc_types.h |   17 +
 tools/testing/selftests/bpf/progs/ima.c            |   28 +
 tools/testing/selftests/bpf/progs/local_storage.c  |  103 +-
 tools/testing/selftests/bpf/progs/map_ptr_kern.c   |    7 -
 tools/testing/selftests/bpf/progs/profiler.inc.h   |    2 +
 tools/testing/selftests/bpf/progs/skb_pkt_end.c    |   54 +
 .../selftests/bpf/progs/test_core_reloc_module.c   |  104 +
 .../selftests/bpf/progs/test_hash_large_key.c      |   44 +
 .../selftests/bpf/progs/test_module_attach.c       |   77 +
 .../bpf/progs/test_sk_storage_trace_itself.c       |   29 +
 .../selftests/bpf/progs/test_sk_storage_tracing.c  |   95 +
 .../testing/selftests/bpf/progs/test_tcpbpf_kern.c |  117 +-
 .../testing/selftests/bpf/progs/test_tunnel_kern.c |   42 +-
 tools/testing/selftests/bpf/tcp_client.py          |   50 -
 tools/testing/selftests/bpf/tcp_server.py          |   80 -
 tools/testing/selftests/bpf/test_maps.c            |    3 +-
 tools/testing/selftests/bpf/test_progs.c           |   75 +-
 tools/testing/selftests/bpf/test_progs.h           |   12 +
 tools/testing/selftests/bpf/test_sock_addr.c       |  196 +-
 tools/testing/selftests/bpf/test_sockmap.c         |   36 +-
 tools/testing/selftests/bpf/test_tcpbpf.h          |    4 +
 tools/testing/selftests/bpf/test_tcpbpf_user.c     |  165 --
 tools/testing/selftests/bpf/test_tunnel.sh         |   43 +-
 tools/testing/selftests/bpf/test_verifier.c        |   44 +-
 tools/testing/selftests/bpf/test_xsk.sh            |  259 +++
 .../testing/selftests/bpf/verifier/ctx_sk_lookup.c |    7 +
 tools/testing/selftests/bpf/verifier/ctx_skb.c     |   42 +
 .../selftests/bpf/verifier/direct_value_access.c   |    3 +
 tools/testing/selftests/bpf/verifier/map_ptr.c     |    1 +
 .../selftests/bpf/verifier/raw_tp_writable.c       |    1 +
 .../testing/selftests/bpf/verifier/ref_tracking.c  |    4 +
 tools/testing/selftests/bpf/verifier/regalloc.c    |    8 +
 tools/testing/selftests/bpf/verifier/unpriv.c      |    5 +-
 tools/testing/selftests/bpf/verifier/wide_access.c |   46 +-
 tools/testing/selftests/bpf/xdpxceiver.c           | 1074 +++++++++
 tools/testing/selftests/bpf/xdpxceiver.h           |  160 ++
 tools/testing/selftests/bpf/xsk_prereqs.sh         |  135 ++
 .../drivers/net/mlxsw/devlink_trap_l3_drops.sh     |   36 +
 .../selftests/drivers/net/mlxsw/q_in_q_veto.sh     |  296 +++
 .../selftests/drivers/net/mlxsw/rtnetlink.sh       |  251 ++
 .../drivers/net/mlxsw/spectrum-2/q_in_vni_veto.sh  |   77 +
 .../drivers/net/mlxsw/spectrum/q_in_vni_veto.sh    |   66 +
 .../drivers/net/netdevsim/ethtool-coalesce.sh      |  132 ++
 .../drivers/net/netdevsim/ethtool-common.sh        |   53 +
 .../drivers/net/netdevsim/ethtool-pause.sh         |   63 +-
 .../drivers/net/netdevsim/ethtool-ring.sh          |   85 +
 .../selftests/drivers/net/netdevsim/nexthop.sh     |  436 ++++
 tools/testing/selftests/net/Makefile               |    1 +
 tools/testing/selftests/net/bareudp.sh             |  546 +++++
 tools/testing/selftests/net/config                 |    7 +
 tools/testing/selftests/net/forwarding/Makefile    |    1 +
 .../selftests/net/forwarding/bridge_igmp.sh        |  485 +++-
 .../testing/selftests/net/forwarding/bridge_mld.sh |  558 +++++
 tools/testing/selftests/net/forwarding/config      |    3 +
 .../selftests/net/forwarding/gre_multipath_nh.sh   |  356 +++
 tools/testing/selftests/net/forwarding/lib.sh      |  107 +
 tools/testing/selftests/net/forwarding/q_in_vni.sh |  347 +++
 .../selftests/net/forwarding/router_mpath_nh.sh    |   70 +-
 .../testing/selftests/net/forwarding/router_nh.sh  |  160 ++
 .../selftests/net/forwarding/tc_mpls_l2vpn.sh      |  192 ++
 tools/testing/selftests/net/mptcp/config           |   10 +
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  292 ++-
 tools/testing/selftests/net/pmtu.sh                |   79 +-
 tools/testing/selftests/net/psock_fanout.c         |   72 +-
 .../selftests/net/srv6_end_dt4_l3vpn_test.sh       |  494 ++++
 .../selftests/net/srv6_end_dt6_l3vpn_test.sh       |  502 ++++
 .../testing/selftests/net/test_vxlan_under_vrf.sh  |    2 +-
 tools/testing/selftests/net/timestamping.c         |   47 +-
 tools/testing/selftests/net/tls.c                  |   40 +-
 1879 files changed, 71931 insertions(+), 38770 deletions(-)
 delete mode 100644 Documentation/ABI/obsolete/sysfs-class-net-batman-adv
 delete mode 100644 Documentation/ABI/obsolete/sysfs-class-net-mesh
 create mode 100644 Documentation/devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/ksz.txt
 create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
 create mode 100644 Documentation/driver-api/auxiliary_bus.rst
 delete mode 100644 Documentation/networking/framerelay.rst
 create mode 100644 Documentation/networking/mptcp-sysctl.rst
 create mode 100644 Documentation/networking/tipc.rst
 create mode 100644 drivers/base/auxiliary.c
 create mode 100644 drivers/net/can/m_can/m_can_pci.c
 create mode 100644 drivers/net/dsa/hirschmann/Kconfig
 create mode 100644 drivers/net/dsa/hirschmann/Makefile
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek.c
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek.h
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek_hwtstamp.c
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek_hwtstamp.h
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek_ptp.c
 create mode 100644 drivers/net/dsa/hirschmann/hellcreek_ptp.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_buddy.c
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_router_xm.c
 create mode 100644 drivers/net/mhi_net.c
 create mode 100644 drivers/net/usb/r8153_ecm.c
 delete mode 100644 drivers/net/wan/dlci.c
 delete mode 100644 drivers/net/wan/sdla.c
 delete mode 100644 drivers/net/wan/x25_asy.c
 delete mode 100644 drivers/net/wan/x25_asy.h
 delete mode 100644 drivers/net/wimax/Kconfig
 delete mode 100644 drivers/net/wimax/Makefile
 create mode 100644 drivers/net/wireless/ath/ath11k/wow.c
 create mode 100644 drivers/net/wireless/ath/ath11k/wow.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/testmode.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7915/testmode.h
 create mode 100644 drivers/nfc/s3fwrn5/phy_common.c
 create mode 100644 drivers/nfc/s3fwrn5/phy_common.h
 create mode 100644 drivers/nfc/s3fwrn5/uart.c
 create mode 100644 drivers/ptp/ptp_ocp.c
 rename {Documentation/admin-guide/wimax => drivers/staging/wimax/Documentation}/i2400m.rst (100%)
 rename {Documentation/admin-guide/wimax => drivers/staging/wimax/Documentation}/index.rst (100%)
 rename {Documentation/admin-guide/wimax => drivers/staging/wimax/Documentation}/wimax.rst (100%)
 rename {net => drivers/staging}/wimax/Kconfig (94%)
 rename {net => drivers/staging}/wimax/Makefile (83%)
 create mode 100644 drivers/staging/wimax/TODO
 rename {net => drivers/staging}/wimax/debug-levels.h (96%)
 rename {net => drivers/staging}/wimax/debugfs.c (97%)
 rename drivers/{net => staging}/wimax/i2400m/Kconfig (100%)
 rename drivers/{net => staging}/wimax/i2400m/Makefile (100%)
 rename drivers/{net => staging}/wimax/i2400m/control.c (99%)
 rename drivers/{net => staging}/wimax/i2400m/debug-levels.h (96%)
 rename drivers/{net => staging}/wimax/i2400m/debugfs.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/driver.c (99%)
 rename drivers/{net => staging}/wimax/i2400m/fw.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/i2400m-usb.h (100%)
 rename drivers/{net => staging}/wimax/i2400m/i2400m.h (99%)
 rename include/uapi/linux/wimax/i2400m.h => drivers/staging/wimax/i2400m/linux-wimax-i2400m.h (100%)
 rename drivers/{net => staging}/wimax/i2400m/netdev.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/op-rfkill.c (99%)
 rename drivers/{net => staging}/wimax/i2400m/rx.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/sysfs.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/tx.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/usb-debug-levels.h (95%)
 rename drivers/{net => staging}/wimax/i2400m/usb-fw.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/usb-notif.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/usb-rx.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/usb-tx.c (100%)
 rename drivers/{net => staging}/wimax/i2400m/usb.c (99%)
 rename {net => drivers/staging}/wimax/id-table.c (99%)
 rename include/linux/wimax/debug.h => drivers/staging/wimax/linux-wimax-debug.h (99%)
 rename include/uapi/linux/wimax.h => drivers/staging/wimax/linux-wimax.h (100%)
 rename include/net/wimax.h => drivers/staging/wimax/net-wimax.h (99%)
 rename {net => drivers/staging}/wimax/op-msg.c (99%)
 rename {net => drivers/staging}/wimax/op-reset.c (98%)
 rename {net => drivers/staging}/wimax/op-rfkill.c (99%)
 rename {net => drivers/staging}/wimax/op-state-get.c (96%)
 rename {net => drivers/staging}/wimax/stack.c (97%)
 rename {net => drivers/staging}/wimax/wimax-internal.h (99%)
 delete mode 100644 drivers/vdpa/mlx5/net/main.c
 delete mode 100644 drivers/vdpa/mlx5/net/mlx5_vnet.h
 create mode 100644 include/linux/auxiliary_bus.h
 delete mode 100644 include/linux/if_frad.h
 rename drivers/vdpa/mlx5/core/mlx5_vdpa_ifc.h => include/linux/mlx5/mlx5_ifc_vdpa.h (96%)
 create mode 100644 include/linux/platform_data/hirschmann-hellcreek.h
 delete mode 100644 include/linux/sdla.h
 create mode 100644 include/linux/soc/marvell/octeontx2/asm.h
 create mode 100644 include/linux/usb/r8152.h
 create mode 100644 include/uapi/linux/cfm_bridge.h
 delete mode 100644 include/uapi/linux/if_frad.h
 delete mode 100644 include/uapi/linux/sdla.h
 create mode 100644 kernel/bpf/bpf_task_storage.c
 delete mode 100644 net/batman-adv/debugfs.c
 delete mode 100644 net/batman-adv/debugfs.h
 delete mode 100644 net/batman-adv/icmp_socket.c
 delete mode 100644 net/batman-adv/icmp_socket.h
 delete mode 100644 net/batman-adv/sysfs.c
 delete mode 100644 net/batman-adv/sysfs.h
 create mode 100644 net/bridge/br_cfm.c
 create mode 100644 net/bridge/br_cfm_netlink.c
 create mode 100644 net/bridge/br_private_cfm.h
 delete mode 100644 net/dsa/tag_edsa.c
 create mode 100644 net/dsa/tag_hellcreek.c
 create mode 100644 net/netfilter/nft_reject_netdev.c
 create mode 100644 net/rxrpc/server_key.c
 create mode 100644 net/sched/sch_frag.c
 create mode 100644 net/smc/smc_netlink.c
 create mode 100644 net/smc/smc_netlink.h
 delete mode 100644 samples/bpf/bpf_load.c
 delete mode 100644 samples/bpf/bpf_load.h
 mode change 100644 => 100755 samples/bpf/lwt_len_hist.sh
 delete mode 100755 samples/bpf/test_ipip.sh
 mode change 100644 => 100755 samples/bpf/test_lwt_bpf.sh
 create mode 100644 samples/bpf/xdpsock_ctrl_proc.c
 create mode 100644 tools/testing/selftests/bpf/bpf_testmod/.gitignore
 create mode 100644 tools/testing/selftests/bpf/bpf_testmod/Makefile
 create mode 100644 tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
 create mode 100644 tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
 create mode 100644 tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.h
 create mode 100644 tools/testing/selftests/bpf/btf_helpers.c
 create mode 100644 tools/testing/selftests/bpf/btf_helpers.h
 create mode 100755 tools/testing/selftests/bpf/ima_setup.sh
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_dedup_split.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_split.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/hash_large_key.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/module_attach.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_storage_tracing.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tcpbpf_user.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_bprm_opts.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_ima.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_skb_pkt_end.c
 create mode 100644 tools/testing/selftests/bpf/progs/bind4_prog.c
 create mode 100644 tools/testing/selftests/bpf/progs/bind6_prog.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_helpers.c
 create mode 100644 tools/testing/selftests/bpf/progs/bprm_opts.c
 create mode 100644 tools/testing/selftests/bpf/progs/ima.c
 create mode 100644 tools/testing/selftests/bpf/progs/skb_pkt_end.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_module.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_hash_large_key.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_module_attach.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sk_storage_trace_itself.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sk_storage_tracing.c
 delete mode 100755 tools/testing/selftests/bpf/tcp_client.py
 delete mode 100755 tools/testing/selftests/bpf/tcp_server.py
 delete mode 100644 tools/testing/selftests/bpf/test_tcpbpf_user.c
 create mode 100755 tools/testing/selftests/bpf/test_xsk.sh
 create mode 100644 tools/testing/selftests/bpf/xdpxceiver.c
 create mode 100644 tools/testing/selftests/bpf/xdpxceiver.h
 create mode 100755 tools/testing/selftests/bpf/xsk_prereqs.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/q_in_q_veto.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/q_in_vni_veto.sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/spectrum/q_in_vni_veto.sh
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/ethtool-coalesce.sh
 create mode 100644 tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/ethtool-ring.sh
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/nexthop.sh
 create mode 100755 tools/testing/selftests/net/bareudp.sh
 create mode 100755 tools/testing/selftests/net/forwarding/bridge_mld.sh
 create mode 100755 tools/testing/selftests/net/forwarding/gre_multipath_nh.sh
 create mode 100755 tools/testing/selftests/net/forwarding/q_in_vni.sh
 create mode 100755 tools/testing/selftests/net/forwarding/router_nh.sh
 create mode 100755 tools/testing/selftests/net/forwarding/tc_mpls_l2vpn.sh
 create mode 100755 tools/testing/selftests/net/srv6_end_dt4_l3vpn_test.sh
 create mode 100755 tools/testing/selftests/net/srv6_end_dt6_l3vpn_test.sh
