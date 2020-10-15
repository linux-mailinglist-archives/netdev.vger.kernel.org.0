Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF0928FA7C
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 23:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389195AbgJOVN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 17:13:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405072AbgJOVN0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 17:13:26 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7D8420789;
        Thu, 15 Oct 2020 21:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602796388;
        bh=uUutYVxwYR9MJXX2leuZRCErb6r8G2BrySO0VbAuV/U=;
        h=Date:From:To:Cc:Subject:From;
        b=2QGXFAroGrL6lE31f9MsXDsGxgTfQGj4osfZHDmAEVnXlI4UL74hr6uqs0ufGBp3j
         as6+asJ8q5/vtzmoA1R/LhL4gbMZJQkJxRAf5M9EwARv//YMGByXWvefU0JAi5GX8B
         Xy8Shu+3NcHLzLUrjBPQDfLUw+Np05hLBcltHMd4=
Date:   Thu, 15 Oct 2020 14:13:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     torvalds@linux-foundation.org
Cc:     akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: [GIT PULL] Networking
Message-ID: <20201015141302.4e82985e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

The following changes since commit 3fdd47c3b40ac48e6e6e5904cf24d12e6e073a96:

  Merge tag 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ms=
t/vhost (2020-10-08 14:25:46 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git tags/ne=
t-next-5.10

for you to fetch changes up to 105faa8742437c28815b2a3eb8314ebc5fd9288c:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next (2020-10=
-15 12:45:00 -0700)

----------------------------------------------------------------
networking changes for the 5.10 merge window

Add redirect_neigh() BPF packet redirect helper, allowing to limit stack
traversal in common container configs and improving TCP back-pressure.
Daniel reports ~10Gbps =3D> ~15Gbps single stream TCP performance gain.

Expand netlink policy support and improve policy export to user space.
(Ge)netlink core performs request validation according to declared
policies. Expand the expressiveness of those policies (min/max length
and bitmasks). Allow dumping policies for particular commands.
This is used for feature discovery by user space (instead of kernel
version parsing or trial and error).

Support IGMPv3/MLDv2 multicast listener discovery protocols in bridge.

Allow more than 255 IPv4 multicast interfaces.

Add support for Type of Service (ToS) reflection in SYN/SYN-ACK
packets of TCPv6.

In Multi-patch TCP (MPTCP) support concurrent transmission of data
on multiple subflows in a load balancing scenario. Enhance advertising
addresses via the RM_ADDR/ADD_ADDR options.

Support SMC-Dv2 version of SMC, which enables multi-subnet deployments.

Allow more calls to same peer in RxRPC.

Support two new Controller Area Network (CAN) protocols -
CAN-FD and ISO 15765-2:2016.

Add xfrm/IPsec compat layer, solving the 32bit user space on 64bit
kernel problem.

Add TC actions for implementing MPLS L2 VPNs.

Improve nexthop code - e.g. handle various corner cases when nexthop
objects are removed from groups better, skip unnecessary notifications
and make it easier to offload nexthops into HW by converting
to a blocking notifier.

Support adding and consuming TCP header options by BPF programs,
opening the doors for easy experimental and deployment-specific
TCP option use.

Reorganize TCP congestion control (CC) initialization to simplify life
of TCP CC implemented in BPF.

Add support for shipping BPF programs with the kernel and loading them
early on boot via the User Mode Driver mechanism, hence reusing all the
user space infra we have.

Support sleepable BPF programs, initially targeting LSM and tracing.

Add bpf_d_path() helper for returning full path for given 'struct path'.

Make bpf_tail_call compatible with bpf-to-bpf calls.

Allow BPF programs to call map_update_elem on sockmaps.

Add BPF Type Format (BTF) support for type and enum discovery, as
well as support for using BTF within the kernel itself (current use
is for pretty printing structures).

Support listing and getting information about bpf_links via the bpf
syscall.

Enhance kernel interfaces around NIC firmware update. Allow specifying
overwrite mask to control if settings etc. are reset during update;
report expected max time operation may take to users; support firmware
activation without machine reboot incl. limits of how much impact
reset may have (e.g. dropping link or not).

Extend ethtool configuration interface to report IEEE-standard
counters, to limit the need for per-vendor logic in user space.

Adopt or extend devlink use for debug, monitoring, fw update
in many drivers (dsa loop, ice, ionic, sja1105, qed, mlxsw,
mv88e6xxx, dpaa2-eth).

In mlxsw expose critical and emergency SFP module temperature alarms.
Refactor port buffer handling to make the defaults more suitable and
support setting these values explicitly via the DCBNL interface.

Add XDP support for Intel's igb driver.

Support offloading TC flower classification and filtering rules to
mscc_ocelot switches.

Add PTP support for Marvell Octeontx2 and PP2.2 hardware, as well as
fixed interval period pulse generator and one-step timestamping in
dpaa-eth.

Add support for various auth offloads in WiFi APs, e.g. SAE (WPA3)
offload.

Add Lynx PHY/PCS MDIO module, and convert various drivers which have
this HW to use it. Convert mvpp2 to split PCS.

Support Marvell Prestera 98DX3255 24-port switch ASICs, as well as
7-port Mediatek MT7531 IP.

Add initial support for QCA6390 and IPQ6018 in ath11k WiFi driver,
and wcn3680 support in wcn36xx.

Improve performance for packets which don't require much offloads
on recent Mellanox NICs by 20% by making multiple packets share
a descriptor entry.

Move chelsio inline crypto drivers (for TLS and IPsec) from the crypto
subtree to drivers/net. Move MDIO drivers out of the phy directory.

Clean up a lot of W=3D1 warnings, reportedly the actively developed
subsections of networking drivers should now build W=3D1 warning free.

Make sure drivers don't use in_interrupt() to dynamically adapt their
code. Convert tasklets to use new tasklet_setup API (sadly this
conversion is not yet complete).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>

----------------------------------------------------------------
Aashish Verma (1):
      net: stmmac: Fix incorrect location to set real_num_rx|tx_queues

Abhijit Ayarekar (1):
      octeontx2-af: optimize parsing of IPv6 fragments

Abhishek Pandit-Subedi (7):
      Bluetooth: Clear suspend tasks on unregister
      Bluetooth: Re-order clearing suspend tasks
      Bluetooth: Only mark socket zapped after unlocking
      Bluetooth: Set ext scan response only when it exists
      Bluetooth: Add mgmt suspend and resume events
      Bluetooth: Add suspend reason for device disconnect
      Bluetooth: Emit controller suspend and resume events

Alan Maguire (10):
      bpf: Provide function to get vmlinux BTF information
      bpf: Move to generic BTF show support, apply it to seq files/strings
      bpf: Add bpf_snprintf_btf helper
      selftests/bpf: Add bpf_snprintf_btf helper tests
      bpf: Bump iter seq size to support BTF representation of large data s=
tructures
      selftests/bpf: Fix overflow tests to reflect iter size increase
      bpf: Add bpf_seq_printf_btf helper
      selftests/bpf: Add test for bpf_seq_printf_btf helper
      selftests/bpf: Fix unused-result warning in snprintf_btf.c
      selftests/bpf: Ensure snprintf_btf/bpf_iter tests compatibility with =
old vmlinux.h

Aleksey Makarov (2):
      octeontx2-af: Add support for Marvell PTP coprocessor
      octeontx2-pf: Add support for PTP clock

Alex Dewar (12):
      ethernet: cirrus: Remove unused macros
      net: qed: Remove unnecessary cast
      nfc: st-nci: Remove unnecessary cast
      nfc: st21nfca: Remove unnecessary cast
      ath11k: return error if firmware request fails
      netlabel: remove unused param from audit_log_format()
      net: mvpp2: ptp: Fix unused variables
      net: dsa: mt7530: Add some return-value checks
      wl3501_cs: Remove unnecessary NULL check
      ath11k: Correctly check errors for calls to debugfs_create_dir()
      ath11k: Fix memory leak on error path
      net, sockmap: Don't call bpf_prog_put() on NULL pointer

Alex Elder (18):
      net: ipa: use refcount_t for IPA clock reference count
      net: ipa: replace ipa->suspend_ref with a flag bit
      net: ipa: manage endpoints separate from clock
      net: ipa: use device_init_wakeup()
      net: ipa: repurpose CLOCK_HELD flag
      net: ipa: enable wakeup on IPA interrupt
      net: ipa: do not enable GSI interrupt for wakeup
      net: ipa: kill definition of TRE_FLAGS_IEOB_FMASK
      net: ipa: kill unused status opcodes
      net: ipa: kill unused status exceptions
      net: ipa: remove unused status structure field masks
      net: ipa: share field mask values for GSI interrupt type
      net: ipa: share field mask values for GSI global interrupt
      net: ipa: share field mask values for GSI general interrupt
      net: ipa: fix two mild warnings
      net: ipa: rename a phandle variable
      net: ipa: fix two comments
      net: ipa: skip suspend/resume activities if not set up

Alex Gartrell (1):
      libbpf: Fix unintentional success return code in bpf_object__load

Alexander A. Klimov (2):
      ath9k: Replace HTTP links with HTTPS ones
      ath5k: Replace HTTP links with HTTPS ones

Alexander Wetzel (1):
      ath9k: add NL80211_EXT_FEATURE_CAN_REPLACE_PTK0 support

Alexandra Winter (8):
      s390/cio: Add new Operation Code OC3 to PNSO
      s390/cio: Helper functions to read CSSID, IID, and CHID
      s390/qeth: Detect PNSO OC3 capability
      s390/qeth: Translate address events into switchdev notifiers
      bridge: Add SWITCHDEV_FDB_FLUSH_TO_BRIDGE notifier
      s390/qeth: Reset address notification in case of buffer overflow
      s390/qeth: implement ndo_bridge_getlink for learning_sync
      s390/qeth: implement ndo_bridge_setlink for learning_sync

Alexandre Belloni (2):
      can: flexcan: fix spelling mistake "reserverd" -> "reserved"
      net: macb: move pdata to private header

Alexei Starovoitov (51):
      Merge branch 'libbpf-probing-improvements'
      Merge branch 'libbpf-minimize-feature-detection'
      Merge branch 'type-and-enum-value-relos'
      bpf: Factor out bpf_link_by_id() helper.
      bpf: Add BPF program and map iterators as built-in BPF programs.
      bpf: Add kernel module with user mode driver that populates bpffs.
      selftests/bpf: Add bpffs preload test.
      Merge branch 'link_query-bpf_iter'
      Merge branch 'update-sockmap-from-prog'
      Merge branch 'bpf-tcp-header-opts'
      bpf: Disallow BPF_PRELOAD in allmodconfig builds
      Merge branch 'resolve_prog_type'
      mm/error_inject: Fix allow_error_inject function signatures.
      bpf: Introduce sleepable BPF programs
      bpf: Add bpf_copy_from_user() helper.
      libbpf: Support sleepable progs
      selftests/bpf: Add sleepable tests
      bpf: Fix build without BPF_SYSCALL, but with BPF_JIT.
      bpf: Fix build without BPF_LSM.
      bpf: Remove bpf_lsm_file_mprotect from sleepable list.
      Merge branch 'libbpf-support-bpf-to-bpf-calls'
      Merge branch 'improve-bpf-tcp-cc-init'
      Merge branch 'bpf_metadata'
      bpf: Add abnormal return checks.
      Merge branch 'refactor-check_func_arg'
      Revert "bpf: Fix potential call bpf_link_free() in atomic context"
      Merge branch 'rtt-speedup.2020.09.16a' of git://git.kernel.org/.../pa=
ulmck/linux-rcu into bpf-next
      Merge branch 'enable-bpf_skc-cast-for-networking-progs'
      Merge branch 'Sockmap copying'
      Merge branch 'bpf: add helpers to support BTF-based kernel'
      Merge branch 'libbpf: BTF writer APIs'
      Merge branch 'selftests/bpf: BTF-based kernel data display'
      Merge branch 'libbpf: support loading/storing any BTF'
      Merge branch 'bpf: Support multi-attach for freplace'
      Merge branch 'bpf, x64: optimize JIT's pro/epilogue'
      Merge branch 'Various BPF helper improvements'
      Merge branch 'introduce BPF_F_PRESERVE_ELEMS'
      Merge branch 'Do not limit cb_flags when creating child sk'
      Merge branch 'bpf: BTF support for ksyms'
      Merge branch 'Add skb_adjust_room() for SK_SKB'
      Merge branch 'Fix pining maps after reuse map fd'
      Merge branch 'libbpf: auto-resize relocatable LOAD/STORE instructions'
      bpf: Propagate scalar ranges through register assignments.
      selftests/bpf: Add profiler test
      selftests/bpf: Asm tests for the verifier regalloc tracking.
      Merge branch 'Follow-up BPF helper improvements'
      Merge branch 'samples: bpf: Refactor XDP programs with libbpf'
      bpf: Migrate from patchwork.ozlabs.org to patchwork.kernel.org.
      Merge branch 'sockmap/sk_skb program memory acct fixes'
      Merge branch 'bpf, sockmap: allow verdict only sk_skb progs'
      bpf: Fix register equivalence tracking.

Allen Pais (38):
      ath5k: convert tasklets to use new tasklet_setup() API
      ath9k: convert tasklets to use new tasklet_setup() API
      carl9170: convert tasklets to use new tasklet_setup() API
      atmel: convert tasklets to use new tasklet_setup() API
      b43legacy: convert tasklets to use new tasklet_setup() API
      brcmsmac: convert tasklets to use new tasklet_setup() API
      ipw2x00: convert tasklets to use new tasklet_setup() API
      iwlegacy: convert tasklets to use new tasklet_setup() API
      intersil: convert tasklets to use new tasklet_setup() API
      mwl8k: convert tasklets to use new tasklet_setup() API
      qtnfmac: convert tasklets to use new tasklet_setup() API
      rt2x00: convert tasklets to use new tasklet_setup() API
      rtlwifi/rtw88: convert tasklets to use new tasklet_setup() API
      zd1211rw: convert tasklets to use new tasklet_setup() API
      ath11k: convert tasklets to use new tasklet_setup() API
      zd1211rw: fix build warning
      rtlwifi: fix build warning
      net: alteon: convert tasklets to use new tasklet_setup() API
      net: amd-xgbe: convert tasklets to use new tasklet_setup() API
      cnic: convert tasklets to use new tasklet_setup() API
      net: macb: convert tasklets to use new tasklet_setup() API
      liquidio: convert tasklets to use new tasklet_setup() API
      chelsio: convert tasklets to use new tasklet_setup() API
      net: sundance: convert tasklets to use new tasklet_setup() API
      net: hinic: convert tasklets to use new tasklet_setup() API
      net: ehea: convert tasklets to use new tasklet_setup() API
      ibmvnic: convert tasklets to use new tasklet_setup() API
      net: jme: convert tasklets to use new tasklet_setup() API
      net: skge: convert tasklets to use new tasklet_setup() API
      net: mlx: convert tasklets to use new tasklet_setup() API
      net: micrel: convert tasklets to use new tasklet_setup() API
      net: natsemi: convert tasklets to use new tasklet_setup() API
      nfp: convert tasklets to use new tasklet_setup() API
      net: nixge: convert tasklets to use new tasklet_setup() API
      qed: convert tasklets to use new tasklet_setup() API
      net: silan: convert tasklets to use new tasklet_setup() API
      net: smc91x: convert tasklets to use new tasklet_setup() API
      cxgb4: convert tasklets to use new tasklet_setup() API

Aloka Dixit (4):
      nl80211: Add FILS discovery support
      mac80211: Add FILS discovery support
      nl80211: Unsolicited broadcast probe response support
      mac80211: Unsolicited broadcast probe response support

Amit Cohen (13):
      mlxsw: core_hwmon: Split temperature querying from show functions
      mlxsw: core_hwmon: Calculate MLXSW_HWMON_ATTR_COUNT more accurately
      mlxsw: core_hwmon: Extend hwmon interface with critical and emergency=
 alarms
      mlxsw: reg: Add Management Temperature Warning Event Register
      mlxsw: reg: Add Port Module Plug/Unplug Event Register
      mlxsw: reg: Add Ports Module Administrative and Operational Status Re=
gister
      mlxsw: core_hwmon: Query MTMP before writing to set only relevant fie=
lds
      mlxsw: core: Add an infrastructure to track transceiver overheat coun=
ter
      mlxsw: Update transceiver_overheat counter according to MTWE
      mlxsw: Enable temperature event for all supported port module sensors
      mlxsw: spectrum: Initialize netdev's module overheat counter
      mlxsw: Update module's settings when module is plugged in
      mlxsw: spectrum_ethtool: Expose transceiver_overheat counter

Andre Edich (3):
      smsc95xx: remove redundant function arguments
      smsc95xx: use usbnet->driver_priv
      smsc95xx: add phylib support

Andre Guedes (4):
      igc: Rename IGC_TSYNCTXCTL_VALID macro
      igc: Don't reschedule ptp_tx work
      igc: Remove timeout check from ptp_tx work
      igc: Clean RX descriptor error flags

Andreas F=C3=A4rber (2):
      rtw88: Fix probe error handling race with firmware loading
      rtw88: Fix potential probe error handling race with wow firmware load=
ing

Andrei Otcheretianski (2):
      iwlwifi: mvm: Don't install CMAC/GMAC key in AP mode
      iwlwifi: use correct group for alive notification

Andrew Lunn (26):
      net: pcs: Move XPCS into new PCS subdirectory
      net/phy/mdio-i2c: Move header file to include/linux/mdio
      net: xgene: Move shared header file into include/linux
      net: mdio: Move MDIO drivers into a new subdirectory
      net: phy: Sort Kconfig and Makefile
      net: dsa: mv88e6xxx: Fix W=3D1 warning with !CONFIG_OF
      net: mdio: octeon: Select MDIO_DEVRES
      net: devlink: regions: Add a priv member to the regions ops struct
      net: devlink: region: Pass the region ops to the snapshot function
      net: dsa: Add helper to convert from devlink to ds
      net: dsa: Add devlink regions support to DSA
      net: dsa: mv88e6xxx: Move devlink code into its own file
      net: dsa: mv88e6xxx: Create helper for FIDs in use
      net: dsa: mv88e6xxx: Add devlink regions
      net: dsa: wire up devlink info get
      net: dsa: mv88e6xxx: Implement devlink info get callback
      net: phy: Fixup kernel doc
      net: phy: Document core PHY structures
      net: marvell: mvpp2: Fix W=3D1 warning with !CONFIG_ACPI
      net: devlink: Add unused port flavour
      net: dsa: Make use of devlink port flavour unused
      net: dsa: Register devlink ports before calling DSA driver setup()
      net: devlink: Add support for port regions
      net: dsa: Add devlink port regions support to DSA
      net: dsa: Add helper for converting devlink port to ds and port
      net: dsa: mv88e6xxx: Add per port devlink regions

Andrii Nakryiko (73):
      libbpf: Disable -Wswitch-enum compiler warning
      libbpf: Make kernel feature probing lazy
      libbpf: Factor out common logic of testing and closing FD
      libbpf: Sanitize BPF program code for bpf_probe_read_{kernel, user}[_=
str]
      selftests/bpf: Fix test_vmlinux test to use bpf_probe_read_user()
      libbpf: Switch tracing and CO-RE helper macros to bpf_probe_read_kern=
el()
      libbpf: Detect minimal BTF support and skip BTF loading, if missing
      libbpf: Improve error logging for mismatched BTF kind cases
      libbpf: Clean up and improve CO-RE reloc logging
      libbpf: Improve relocation ambiguity detection
      selftests/bpf: Add test validating failure on ambiguous relocation va=
lue
      libbpf: Remove any use of reallocarray() in libbpf
      tools/bpftool: Remove libbpf_internal.h usage in bpftool
      libbpf: Centralize poisoning and poison reallocarray()
      tools: Remove feature-libelf-mmap feature detection
      libbpf: Implement type-based CO-RE relocations support
      selftests/bpf: Test TYPE_EXISTS and TYPE_SIZE CO-RE relocations
      selftests/bpf: Add CO-RE relo test for TYPE_ID_LOCAL/TYPE_ID_TARGET
      libbpf: Implement enum value-based CO-RE relocations
      selftests/bpf: Add tests for ENUMVAL_EXISTS/ENUMVAL_VALUE relocations
      libbpf: Fix detection of BPF helper call instruction
      libbpf: Fix libbpf build on compilers missing __builtin_mul_overflow
      selftests/bpf: Fix two minor compilation warnings reported by GCC 4.9
      selftests/bpf: List newest Clang built-ins needed for some CO-RE self=
tests
      libbpf: Add perf_buffer APIs for better integration with outside epol=
l loop
      selftests/bpf: BPF object files should depend only on libbpf headers
      libbpf: Factor out common ELF operations and improve logging
      libbpf: Add __noinline macro to bpf_helpers.h
      libbpf: Skip well-known ELF sections when iterating ELF
      libbpf: Normalize and improve logging across few functions
      libbpf: Avoid false unuinitialized variable warning in bpf_core_apply=
_relo
      libbpf: Fix type compatibility check copy-paste error
      libbpf: Fix compilation warnings for 64-bit printf args
      libbpf: Ensure ELF symbols table is found before further ELF processi=
ng
      libbpf: Parse multi-function sections into multiple BPF programs
      libbpf: Support CO-RE relocations for multi-prog sections
      libbpf: Make RELO_CALL work for multi-prog sections and sub-program c=
alls
      libbpf: Implement generalized .BTF.ext func/line info adjustment
      libbpf: Add multi-prog section support for struct_ops
      selftests/bpf: Add selftest for multi-prog sections and bpf-to-bpf ca=
lls
      tools/bpftool: Replace bpf_program__title() with bpf_program__section=
_name()
      selftests/bpf: Don't use deprecated libbpf APIs
      libbpf: Deprecate notion of BPF program "title" in favor of "section =
name"
      selftests/bpf: Turn fexit_bpf2bpf into test with subtests
      selftests/bpf: Add subprogs to pyperf, strobemeta, and l4lb_noinline =
tests
      selftests/bpf: Modernize xdp_noinline test w/ skeleton and __noinline
      selftests/bpf: Add __noinline variant of cls_redirect selftest
      libbpf: Fix another __u64 cast in printf
      libbpf: Fix potential multiplication overflow
      perf: Stop using deprecated bpf_program__title()
      selftests/bpf: Merge most of test_btf into test_progs
      libbpf: Refactor internals of BTF type index
      libbpf: Remove assumption of single contiguous memory for BTF data
      libbpf: Generalize common logic for managing dynamically-sized arrays
      libbpf: Extract generic string hashing function for reuse
      libbpf: Allow modification of BTF and add btf__add_str API
      libbpf: Add btf__new_empty() to create an empty BTF object
      libbpf: Add BTF writing APIs
      libbpf: Add btf__str_by_offset() as a more generic variant of name_by=
_offset
      selftests/bpf: Test BTF writing APIs
      selftests/bpf: Move and extend ASSERT_xxx() testing macros
      libbpf: Support BTF loading and raw data output in both endianness
      selftests/bpf: Test BTF's handling of endianness
      libbpf: Fix uninitialized variable in btf_parse_type_sec
      libbpf: Compile libbpf under -O2 level by default and catch extra war=
nings
      libbpf: Compile in PIC mode only for shared library case
      libbpf: Make btf_dump work with modifiable BTF
      selftests/bpf: Test "incremental" btf_dump in C format
      bpf, doc: Update Andrii's email in MAINTAINERS
      libbpf: Skip CO-RE relocations for not loaded BPF programs
      libbpf: Support safe subset of load/store instruction resizing with C=
O-RE
      libbpf: Allow specifying both ELF and raw BTF for CO-RE BTF override
      selftests/bpf: Validate libbpf's auto-sizing of LD/ST/STX instructions

Andy Shevchenko (6):
      brcmfmac: use %*ph to print small buffer
      Bluetooth: hci_intel: drop strange le16_to_cpu() against u8 values
      Bluetooth: hci_intel: switch to list_for_each_entry()
      Bluetooth: hci_intel: enable on new platform
      can: mcp251x: Use readx_poll_timeout() helper
      ice: devlink: use %*phD to print small buffer

Anilkumar Kolli (11):
      ath11k: update firmware files read path
      ath11k: rename default board file
      ath11k: ahb: call ath11k_core_init() before irq configuration
      ath11k: convert ath11k_hw_params to an array
      ath11k: define max_radios in hw_params
      ath11k: add hw_ops for pdev id to hw_mac mapping
      ath11k: Add bdf-addr in hw_params
      dt: bindings: net: update compatible for ath11k
      ath11k: move target ce configs to hw_params
      ath11k: add ipq6018 support
      ath11k: remove calling ath11k_init_hw_params() second time

Anirudh Venkataramanan (1):
      ice: Change ice_info_get_dsn to be void

Ariel Levkovich (10):
      net/mlx5: Refactor multi chains and prios support
      net/mlx5: Allow ft level ignore for nic rx tables
      net/mlx5e: Tc nic flows to use mlx5_chains flow tables
      net/mlx5e: Split nic tc flow allocation and creation
      net/mlx5: Refactor tc flow attributes structure
      net/mlx5e: Add tc chains offload support for nic flows
      net/mlx5e: rework ct offload init messages
      net/mlx5e: Support CT offload for tc nic flows
      net/mlx5e: Keep direct reference to mlx5_core_dev in tc ct
      net/mlx5: Fix dereference on pointer attr after null check

Armin Wolf (2):
      lib8390: Replace panic() call with BUILD_BUG_ON
      lib8390: Use netif_msg_init to initialize msg_enable bits

Avraham Stern (8):
      iwlwifi: mvm: add an option to add PASN station
      iwlwifi: mvm: add support for range request command ver 11
      iwlwifi: mvm: add support for responder dynamic config command versio=
n 3
      iwlwifi: mvm: location: set the HLTK when PASN station is added
      iwlwifi: mvm: responder: allow to set only the HLTK for an associated=
 station
      iwlwifi: mvm: initiator: add option for adding a PASN responder
      iwlwifi: mvm: ignore the scan duration parameter
      iwlwifi: mvm: avoid possible NULL pointer dereference

Ayala Beker (1):
      iwlwifi: mvm: clear all scan UIDs

Ayush Sawal (2):
      cxgb4/ch_ipsec: Registering xfrmdev_ops with cxgb4
      cxgb4/ch_ipsec: Replace the module name to ch_ipsec from chcr

Balazs Scheidler (1):
      netfilter: nft_socket: add wildcard support

Barry Song (2):
      net: hns: use IRQ_NOAUTOEN to avoid irq is enabled due to request_irq
      net: allwinner: remove redundant irqsave and irqrestore in hardIRQ

Ben Greear (2):
      mac80211: Support not iterating over not-sdata-in-driver ifaces
      ath11k: support loading ELF board files

Bixuan Cui (1):
      ice: Fix pointer cast warnings

Bj=C3=B6rn T=C3=B6pel (5):
      bpf: {cpu,dev}map: Change various functions return type from int to v=
oid
      i40e, xsk: remove HW descriptor prefetch in AF_XDP path
      i40e: use 16B HW descriptors instead of 32B
      i40e, xsk: move buffer allocation out of the Rx processing loop
      xsk: Remove internal DMA headers

Bo YU (1):
      ath11k: Add checked value for ath11k_ahb_remove

Bolarinwa Olayemi Saheed (1):
      ath9k: Check the return value of pcie_capability_read_*()

Brian Norris (2):
      rtw88: don't treat NULL pointer as an array
      rtw88: use read_poll_timeout_atomic() for poll loop

Brooke Basile (1):
      ath9k: hif_usb: fix race condition between usb_get_urb() and usb_kill=
_anchored_urbs()

Bruce Allan (1):
      ice: remove repeated words

Bryan O'Donoghue (40):
      wcn36xx: Fix reported 802.11n rx_highest rate wcn3660/wcn3680
      wcn36xx: Add a chip identifier for WCN3680
      wcn36xx: Hook and identify RF_IRIS_WCN3680
      wcn36xx: Add 802.11ac MCS rates
      wcn36xx: Specify ieee80211_rx_status.nss
      wcn36xx: Add 802.11ac HAL param bitfields
      wcn36xx: Add Supported rates V1 structure
      wcn36xx: Use existing pointers in wcn36xx_smd_config_bss_v1
      wcn36xx: Set feature DOT11AC for wcn3680
      wcn36xx: Add VHT fields to parameter data structures
      wcn36xx: Use V1 data structure to store supported rates
      wcn36xx: Add wcn36xx_set_default_rates_v1
      wcn36xx: Add wcn36xx_smd_set_sta_default_vht_params()
      wcn36xx: Add wcn36xx_smd_set_sta_default_ht_ldpc_params()
      wcn36xx: Add wcn36xx_smd_set_sta_vht_params()
      wcn36xx: Add wcn36xx_smd_set_sta_ht_ldpc_params()
      wcn36xx: Add wcn36xx_smd_set_bss_vht_params()
      wcn36xx: Add wrapper function wcn36xx_smd_set_sta_params_v1()
      wcn36xx: Functionally decompose wcn36xx_smd_config_sta()
      wcn36xx: Move wcn36xx_smd_set_sta_params() inside wcn36xx_smd_config_=
bss()
      wcn36xx: Move BSS parameter setup to wcn36xx_smd_set_bss_params()
      wcn36xx: Update wcn36xx_smd_config_bss_v1() to operate internally
      wcn36xx: Add wcn36xx_smd_config_bss_v0
      wcn36xx: Convert to using wcn36xx_smd_config_bss_v0()
      wcn36xx: Remove dead code in wcn36xx_smd_config_bss()
      wcn36xx: Add accessor macro HW_VALUE_CHANNEL for hardware channels
      wcn36xx: Use HW_VALUE_CHANNEL macro to get channel number
      wcn36xx: Add accessor macro HW_VALUE_PHY for PHY settings
      wcn36xx: Encode PHY mode for 80MHz channel in hw_value
      wcn36xx: Set PHY into correct mode for 80MHz channel width
      wcn36xx: Extend HAL param config list
      wcn36xx: Define wcn3680 specific firmware parameters
      wcn36xx: Add ability to download wcn3680 specific firmware parameters
      wcn36xx: Latch VHT specific BSS parameters to firmware
      wcn36xx: Define INIT_HAL_MSG_V1()
      wcn36xx: Convert to VHT parameter structure on wcn3680
      wcn36xx: Add VHT rates to wcn36xx_update_allowed_rates()
      wcn36xx: Advertise ieee802.11 VHT flags
      wcn36xx: Mark internal smd functions static
      wcn36xx: Ensure spaces between functions

Calvin Johnson (1):
      net: phy: Move of_mdio from drivers/of to drivers/net/mdio

Carl Huang (36):
      ath11k: do not depend on ARCH_QCOM for ath11k
      ath11k: add hw_params entry for QCA6390
      ath11k: allocate smaller chunks of memory for firmware
      ath11k: fix memory OOB access in qmi_decode
      ath11k: fix KASAN warning of ath11k_qmi_wlanfw_wlan_cfg_send
      ath11k: enable internal sleep clock
      ath11k: hal: create register values dynamically
      ath11k: ce: support different CE configurations
      ath11k: hal: assign msi_addr and msi_data to srng
      ath11k: ce: get msi_addr and msi_data before srng setup
      ath11k: disable CE interrupt before hif start
      ath11k: force single pdev only for QCA6390
      ath11k: initialize wmi config based on hw_params
      ath11k: wmi: put hardware to DBS mode
      ath11k: dp: redefine peer_map and peer_unmap
      ath11k: enable DP interrupt setup for QCA6390
      ath11k: don't initialize rxdma1 related ring
      ath11k: setup QCA6390 rings for both rxdmas
      ath11k: refine the phy_id check in ath11k_reg_chan_list_event
      ath11k: delay vdev_start for QCA6390
      ath11k: assign correct search flag and type for QCA6390
      ath11k: process both lmac rings for QCA6390
      ath11k: use TCL_DATA_RING_0 for QCA6390
      ath11k: reset MHI during power down and power up
      ath11k: fix AP mode for QCA6390
      ath11k: add packet log support for QCA6390
      ath11k: pci: fix rmmod crash
      ath11k: fix warning caused by lockdep_assert_held
      ath11k: debugfs: fix crash during rmmod
      ath11k: read and write registers below unwindowed address
      ath11k: enable shadow register configuration and access
      ath11k: set WMI pipe credit to 1 for QCA6390
      ath11k: start a timer to update TCL HP
      ath11k: start a timer to update REO cmd ring
      ath11k: start a timer to update HP for CE pipe 4
      ath11k: enable idle power save mode

Catherine Sullivan (1):
      gve: Use dev_info/err instead of netif_info/err.

Chen Zhou (1):
      bpf: Remove duplicate headers

Chih-Min Chen (1):
      mt76: mt7915: fix unexpected firmware mode

Chris Chiu (2):
      rtl8xxxu: prevent potential memory leak
      rtlwifi: rtl8192se: remove duplicated legacy_httxpowerdiff

Christian Eggers (4):
      net: dsa: microchip: add ksz9563 to ksz9477 I2C driver
      net: dsa: microchip: fix race condition
      socket: fix option SO_TIMESTAMPING_NEW
      socket: don't clear SOCK_TSTAMP_NEW when SO_TIMESTAMPNS is disabled

Christoph Paasch (1):
      selftests/mptcp: Better delay & reordering configuration

Christophe JAILLET (30):
      ath10k: Fix the size used in a 'dma_free_coherent()' call in an error=
 handling path
      adm8211: switch from 'pci_' to 'dma_' API
      mwifiex: Do not use GFP_KERNEL in atomic context
      typhoon: switch from 'pci_' to 'dma_' API
      starfire: switch from 'pci_' to 'dma_' API
      net: atheros: switch from 'pci_' to 'dma_' API
      chelsio: switch from 'pci_' to 'dma_' API
      mwifiex: switch from 'pci_' to 'dma_' API
      mwifiex: Clean up some err and dbg messages
      rtw88: switch from 'pci_' to 'dma_' API
      rtl818x_pci: switch from 'pci_' to 'dma_' API
      epic100: switch from 'pci_' to 'dma_' API
      smsc9420: switch from 'pci_' to 'dma_' API
      enic: switch from 'pci_' to 'dma_' API
      hippi: switch from 'pci_' to 'dma_' API
      net: tc35815: switch from 'pci_' to 'dma_' API
      rtlwifi: switch from 'pci_' to 'dma_' API
      tlan: switch from 'pci_' to 'dma_' API
      sc92031: switch from 'pci_' to 'dma_' API
      rocker: switch from 'pci_' to 'dma_' API
      net: tehuti: switch from 'pci_' to 'dma_' API
      natsemi: switch from 'pci_' to 'dma_' API
      net: dl2k: switch from 'pci_' to 'dma_' API
      tulip: windbond-840: switch from 'pci_' to 'dma_' API
      tulip: windbond-840: Fix a debug message
      tulip: uli526x: switch from 'pci_' to 'dma_' API
      tulip: dmfe: switch from 'pci_' to 'dma_' API
      tulip: de2104x: switch from 'pci_' to 'dma_' API
      tulip: switch from 'pci_' to 'dma_' API
      airo: switch from 'pci_' to 'dma_' API

Chuah, Kim Tatt (1):
      net: stmmac: Add option for VLAN filter fail queue enable

Chung-Hsien Hsu (3):
      nl80211: support SAE authentication offload in AP mode
      brcmfmac: support 4-way handshake offloading for WPA/WPA2-PSK in AP m=
ode
      brcmfmac: support SAE authentication offload in AP mode

Ciara Loftus (4):
      xsk: Fix a documentation mistake in xsk_queue.h
      samples: bpf: Split xdpsock stats into new struct
      samples: bpf: Count syscalls in xdpsock
      samples: bpf: Driver interrupt statistics in xdpsock

Claudiu Manoil (4):
      enetc: Clean up MAC and link configuration
      enetc: Clean up serdes configuration
      arm64: dts: fsl-ls1028a-rdb: Specify in-band mode for ENETC port 0
      enetc: Migrate to PHYLINK and PCS_LYNX

Colin Ian King (12):
      ath6kl: fix spelling mistake "initilisation" -> "initialization"
      wl1251, wlcore: fix spelling mistake "buld" -> "build"
      rtw88: fix spelling mistake: "unsupport" -> "unsupported"
      selftests/bpf: Fix spelling mistake "scoket" -> "socket"
      ath11k: fix spelling mistake "moniter" -> "monitor"
      ath11k: fix missing error check on call to ath11k_pci_get_user_msi_as=
signment
      ipv6: remove redundant assignment to variable err
      can: grcan: fix spelling mistake "buss" -> "bus"
      can: mcba_usb: remove redundant initialization of variable err
      qtnfmac: fix resource leaks on unsupported iftype error return path
      net: phy: dp83869: fix unsigned comparisons against less than zero va=
lues
      net/mlx5: Fix uininitialized pointer read on pointer attr

Cong Wang (3):
      can: j1935: j1939_tp_tx_dat_new(): fix missing initialization of skbc=
nt
      tipc: fix the skb_unshare() in tipc_buf_append()
      ip_gre: set dev->hard_header_len and dev->needed_headroom properly

Cristian Dumitrescu (1):
      samples/bpf: Add new sample xsk_fwd.c

Cristobal Forno (1):
      ibmvnic: store RX and TX subCRQ handle array in ibmvnic_adapter struct

Dan Carpenter (10):
      ath6kl: prevent potential array overflow in ath6kl_add_new_sta()
      ath9k: Fix potential out of bounds in ath9k_htc_txcompletion_cb()
      ath11k: return -ENOMEM on allocation failure
      ath11k: fix uninitialized return in ath11k_spectral_process_data()
      rtlwifi: rtl8723ae: Delete a stray tab
      net/mlx5: remove erroneous fallthrough
      ath6kl: wmi: prevent a shift wrapping bug in ath6kl_wmi_delete_pstrea=
m_cmd()
      cfg80211: regulatory: remove a bogus initialization
      can: mcp25xxfd: mcp25xxfd_ring_free(): fix memory leak during cleanup
      net/mlx5e: Fix a use after free on error in mlx5_tc_ct_shared_counter=
_get()

Dan Halperin (2):
      iwlwifi: mvm: add support for new version of WOWLAN_TKIP_SETTING_API_S
      iwlwifi: mvm: add support for new WOWLAN_TSC_RSC_PARAM version

Dan Murphy (8):
      dt-bindings: net: dp83822: Add TI dp83822 phy
      net: phy: DP83822: Add ability to advertise Fiber connection
      net: phy: dp83867: Fix various styling and space issues
      ethtool: Add 100base-FX link mode entries
      net: dp83869: Add ability to advertise Fiber connection
      net: phy: dp83822: Update the fiber advertisement for speed
      net: phy: dp83869: support Wake on LAN
      net: phy: dp83869: Add speed optimization feature

Dan Nowlin (1):
      ice: fix adding IP4 IP6 Flow Director rules

Daniel Borkmann (15):
      Merge branch 'bpf-umd-debug'
      Merge branch 'bpf-sleepable'
      bpf: Add classid helper only based on skb->sk
      bpf, net: Rework cookie generator as per-cpu one
      bpf: Add redirect_neigh helper as redirect drop-in
      bpf, libbpf: Add bpf_tail_call_static helper for bpf programs
      bpf, selftests: Use bpf_tail_call_static where appropriate
      bpf, selftests: Add redirect_neigh selftest
      Merge branch 'bpf-llvm-reg-alloc-patterns'
      bpf: Improve bpf_redirect_neigh helper description
      bpf: Add redirect_peer helper
      bpf: Allow for map-in-map with dynamic inner array map entries
      bpf, selftests: Add test for different array inner map size
      bpf, selftests: Make redirect_neigh test more extensible
      bpf, selftests: Add redirect_peer selftest

Daniel T. Lee (9):
      samples: bpf: Fix broken bpf programs due to removed symbol
      samples: bpf: Cleanup bpf_load.o from Makefile
      samples: bpf: Refactor kprobe tracing programs with libbpf
      samples: bpf: Refactor tracepoint tracing programs with libbpf
      samples, bpf: Replace bpf_program__title() with bpf_program__section_=
name()
      samples, bpf: Add xsk_fwd test file to .gitignore
      samples: bpf: Refactor xdp_monitor with libbpf
      samples: bpf: Replace attach_tracepoint() to attach() in xdp_redirect=
_cpu
      samples: bpf: Refactor XDP kern program maps with BTF-defined map

Daniel Winkler (3):
      Bluetooth: Report num supported adv instances for hw offloading
      Bluetooth: Add MGMT capability flags for tx power and ext advertising
      Bluetooth: pause/resume advertising around suspend

Danielle Ratson (2):
      selftests: forwarding: Fix mausezahn delay parameter in mirror_test()
      mlxsw: spectrum_ethtool: Remove internal speeds from PTYS register

David Ahern (2):
      selftests: Set default protocol for raw sockets in nettest
      ipv4: Restore flowi4_oif update before call to xfrm_lookup_route

David Awogbemila (2):
      gve: NIC stats for report-stats and for ethtool
      gve: Enable Link Speed Reporting in the driver.

David Howells (10):
      rxrpc: Impose a maximum number of client calls
      rxrpc: Rewrite the client connection manager
      rxrpc: Allow multiple client connections to the same peer
      rxrpc: Fix an error goto in rxrpc_connect_call()
      rxrpc: Fix a missing NULL-pointer check in a trace
      rxrpc: Fix rxrpc_bundle::alloc_error to be signed
      rxrpc: Fix conn bundle leak in net-namespace exit
      rxrpc: Fix an overget of the conn bundle when setting up a client conn
      rxrpc: Fix bundle counting for exclusive connections
      rxrpc: Fix loss of final ack on shutdown

David S. Miller (162):
      Merge branch 'netlink-allow-NLA_BINARY-length-range-validation'
      Merge branch 'net-dsa-loop-Expose-VLAN-table-through-devlink'
      Merge branch 'r8169-use-napi_complete_done-return-value'
      Merge branch 'ptp-Add-generic-helper-functions'
      Merge branch 'nfp-flower-add-support-for-QinQ-matching'
      Merge branch 'tcp_mmap-optmizations'
      Merge branch 'crypto-chelsio-Restructure-chelsio-s-inline-crypto-driv=
ers'
      Merge branch 'l2tp-replace-custom-logging-code-with-tracepoints'
      Merge git://git.kernel.org/.../netdev/net
      Merge branch 'devlink-fixes-for-port-and-reporter-field-access'
      Merge branch 'net-sctp-delete-duplicated-words-plus-other-fixes'
      Merge branch 'mlxsw-Misc-updates'
      Merge branch 'qed-introduce-devlink-health-support'
      Merge branch 'Add-PTP-support-for-Octeontx2'
      Merge tag 'batadv-next-for-davem-20200824' of git://git.open-mesh.org=
/linux-merge
      Merge branch 'Add-Ethernet-support-for-Intel-Keem-Bay-SoC'
      Merge branch 'net_prefetch-API'
      Merge branch 'ipv4-nexthop-Various-improvements'
      Merge branch 'refactoring-of-ibmvnic-code'
      Merge branch 'drivers-net-constify-static-ops-variables'
      Merge branch 'Move-MDIO-drivers-into-their-own-directory'
      Merge branch 's390-qeth-next'
      Merge tag 'mac80211-next-for-davem-2020-08-28' of git://git.kernel.or=
g/.../jberg/mac80211-next
      Merge branch 'Add-phylib-support-to-smsc95xx'
      Merge branch 'Enable-Fiber-on-DP83822-PHY'
      Merge branch 'ionic-memory-usage-rework'
      Merge branch 'hinic-add-debugfs-support'
      Merge branch 'gtp-minor-enhancements'
      Merge branch 'Add-ip6_fragment-in-ipv6_stub'
      Merge branch 'sfc-clean-up-some-W-1-build-warnings'
      Merge branch 'net-phy-add-Lynx-PCS-MDIO-module'
      Merge branch 'net-openvswitch-improve-the-codes'
      Merge git://git.kernel.org/.../bpf/bpf-next
      Merge branch 'dpaa2-eth-add-a-dpaa2_eth_-prefix-to-all-functions'
      Merge branch 'RTL8366-stabilization'
      Merge branch 'ionic-struct-cleanups'
      Merge branch 'Minor-improvements-to-b53-dmesg-output'
      Merge branch 'mlxsw-Expose-critical-and-emergency-module-alarms'
      Merge branch 'l2tp-miscellaneous-cleanups'
      Merge branch 'Convert-mvpp2-to-split-PCS-support'
      Merge branch 'net-systemport-Clock-support'
      Merge branch 'net-dsa-bcm_sf2-Clock-support'
      Merge branch 'net-hns3-misc-updates'
      Merge tag 'rxrpc-next-20200908' of git://git.kernel.org/.../dhowells/=
linux-fs
      Merge git://git.kernel.org/.../pablo/nf-next
      Merge branch 'ksz9477-dsa-switch-driver-improvements'
      Merge branch 'SMSC-Cleanups-and-clock-setup'
      Merge branch 'devlink-show-controller-number'
      Merge branch 'Marvell-PP2-2-PTP-support'
      Merge branch 'Allow-more-than-255-IPv4-multicast-interfaces'
      Merge branch 'mlx4-avoid-devlink-port-type-not-set-warnings'
      Merge branch 'netpoll-make-sure-napi_list-is-safe-for-RCU-traversal'
      Merge branch 'tcp-add-tos-reflection-feature'
      Merge branch 'Enhance-current-features-in-ena-driver'
      Merge branch 'hns-kdoc'
      Merge branch 'nfc-s3fwrn5-Few-cleanups'
      Merge branch 'smc-next'
      Merge tag 'wireless-drivers-next-2020-09-11' of git://git.kernel.org/=
.../kvalo/wireless-drivers-next
      Merge branch 'Add-GVE-Features'
      Merge branch 'ag71xx-add-ethtool-and-flow-control-support'
      Merge branch 'sfc-misc-cleanups'
      Merge branch 'sfc-encap-offloads-on-EF10'
      Merge branch 'DSA-tag_8021q-cleanup'
      Merge branch 'net-ethernet-ti-ale-add-static-configuration'
      Merge branch 'ethernet-convert-tasklets-to-use-new-tasklet_setup-API'
      Merge branch 'mptcp-introduce-support-for-real-multipath-xmit'
      Merge tag 'rxrpc-next-20200914' of git://git.kernel.org/.../dhowells/=
linux-fs
      Merge branch '40GbE' of git://git.kernel.org/.../jkirsher/next-queue
      Merge branch 'mlxsw-Derive-SBIB-from-maximum-port-speed-and-MTU'
      Merge branch 'net-next-dsa-mt7530-add-support-for-MT7531'
      Merge branch 's390-qeth-next'
      Merge branch 'ethtool-add-pause-frame-stats'
      Merge branch 'net-stmmac-Add-ethtool-support-for-get-set-channels'
      Merge branch 'mlxsw-Introduce-fw_fatal-health-reporter-and-test-cmd-t=
o -trigger-test-event'
      Merge branch 'nexthop-Small-changes'
      Merge tag 'mlx5-updates-2020-09-15' of git://git.kernel.org/.../saeed=
/linux
      Merge branch 'mlxsw-Refactor-headroom-management'
      Merge branch 'net-hns3-updates-for-next'
      Merge branch 'net-marvell-prestera-Add-Switchdev-driver-for-Prestera-=
family-ASIC-device-98DX3255-AC3x'
      Merge branch 'mlxsw-Support-dcbnl_setbuffer-dcbnl_getbuffer'
      Merge branch 'ionic-add-devlink-dev-flash-support'
      Merge branch 'tipc-add-more-features-to-TIPC-encryption'
      Merge branch 'net-various-delete-duplicated-words'
      Merge branch 'dpaa2_eth-support-1588-one-step-timestamping'
      Merge branch 'net-ipa-wake-up-system-on-RX-available'
      Merge branch 'ptp_qoriq-support-FIPER3'
      Merge branch 'Felix-DSA-driver-cleanup-build-Seville-separately'
      Merge branch 'mv88e6xxx-Add-devlink-regions-support'
      Merge branch '100base-Fx-link-modes'
      Merge branch 'DSA-with-VLAN-filtering-and-offloading-masters'
      Merge branch 'Update-license-and-polish-ENA-driver-code'
      Merge tag 'mac80211-next-for-net-next-2020-09-21' of git://git.kernel=
.org/.../jberg/mac80211-next
      Merge tag 'linux-can-next-for-5.10-20200921' of git://git.kernel.org/=
.../mkl/linux-can-next
      Merge git://git.kernel.org/.../netdev/net
      Merge branch 'devlink-Use-nla_policy-to-validate-range'
      Merge tag 'mlx5-updates-2020-09-21' of git://git.kernel.org/.../saeed=
/linux
      Merge branch 's390-qeth-next'
      Merge tag 'linux-can-next-for-5.10-20200923' of git://git.kernel.org/=
.../mkl/linux-can-next
      Merge git://git.kernel.org/.../bpf/bpf-next
      Merge branch 'net-bridge-mcast-IGMPv3-MLDv2-fast-path-part-2'
      Merge branch 'Introduce-mbox-tracepoints-for-Octeontx2'
      Merge branch 'net-mdio-ipq4019-add-Clause-45-support'
      Merge branch 'octeontx2-Add-support-for-VLAN-based-flow-distribution'
      Merge branch 'net-dsa-bcm_sf2-Additional-DT-changes'
      Merge branch 'PHY-subsystem-kernel-doc'
      Merge branch 'net-dsa-b53-Configure-VLANs-while-not-filtering'
      Merge branch 'dpaa2-mac-add-PCS-support-through-the-Lynx-module'
      Merge tag 'mlx5-updates-2020-09-22' of git://git.kernel.org/.../saeed=
/linux
      Merge branch 'mptcp-RM_ADDR-ADD_ADDR-enhancements'
      Merge branch 'hns3-next'
      Merge tag 'wireless-drivers-next-2020-09-25' of git://git.kernel.org/=
.../kvalo/wireless-drivers-next
      Merge branch 'drivers-net-warning-clean'
      Merge branch 'Devlink-regions-for-SJA1105-DSA-driver'
      Merge branch 'vxlan-clean-up'
      Merge branch 'dpaa2-eth-small-updates'
      Merge branch 'simplify-TCP-loss-marking-code'
      Merge branch 'devlink-flash-update-overwrite-mask'
      Merge branch 'Generic-adjustment-for-flow-dissector-in-DSA'
      Merge branch 'hns3-next'
      Merge branch 'mlxsw-Expose-transceiver-overheat-counter'
      Merge branch 'bnxt_en-Update-for-net-next'
      Merge branch 'DP83869-WoL-and-Speed-optimization'
      Merge branch 'udp_tunnel-convert-Intel-drivers-with-shared-tables'
      Merge branch '1GbE' of https://github.com/anguy11/next-queue
      Merge branch 'net-smc-introduce-SMC-Dv2-support'
      Merge branch 'ibmvnic-refactor-some-send-handle-functions'
      Merge branch 'net-ipa-miscellaneous-cleanups'
      Merge branch 'octeontx2-af-cleanup-and-extend-parser-config'
      Merge branch 'hns3-next'
      Merge branch 'for-upstream' of git://git.kernel.org/.../bluetooth/blu=
etooth-next
      Merge branch 'cxgb4-ch_ktls-updates-in-net-next'
      Merge branch 'net-in_interrupt-cleanup-and-fixes'
      Merge branch 'HW-support-for-VCAP-IS1-and-ES0-in-mscc_ocelot'
      Merge branch 'mlxsw-PFC-and-headroom-selftests'
      Merge branch 'tcp-exponential-backoff-in-tcp_send_ack'
      Merge branch 'ionic-watchdog-training'
      Merge tag 'linux-can-next-for-5.10-20200930' of git://git.kernel.org/=
.../mkl/linux-can-next
      Merge branch 'drop_monitor-Convert-to-use-devlink-tracepoint'
      Merge tag 'mlx5-updates-2020-09-30' of git://git.kernel.org/.../saeed=
/linux
      Merge branch 'net-ravb-Add-support-for-explicit-internal-clock-delay-=
c onfiguration'
      Merge git://git.kernel.org/.../bpf/bpf-next
      Merge branch 'master' of git://git.kernel.org/.../klassert/ipsec-next
      Merge branch 'net-dsa-Improve-dsa_untag_bridge_pvid'
      Merge tag 'mac80211-next-for-net-next-2020-10-02' of git://git.kernel=
.org/.../jberg/mac80211-next
      Merge branch 'Offload-tc-flower-to-mscc_ocelot-switch-using-VCAP-chai=
ns'
      Merge tag 'wireless-drivers-next-2020-10-02' of git://git.kernel.org/=
.../kvalo/wireless-drivers-next
      Merge branch 's390-net-next'
      Merge branch 'ionic-error-recovery'
      Merge branch 'dpaa2-eth-add-devlink-parser-error-drop-trap-support'
      Merge branch 'genetlink-support-per-command-policy-dump'
      Merge branch 'genetlink-per-op-policy-export'
      Merge branch 'net-iucv-next'
      Merge branch 'Add-Seville-Ethernet-switch-to-T1040RDB'
      Merge branch 'net-sched-Add-actions-for-MPLS-L2-VPNs'
      Merge git://git.kernel.org/.../pablo/nf-next
      Merge branch 'mv88e6xxx-Add-per-port-devlink-regions'
      Merge branch 'bnxt_en-net-next-updates'
      Merge branch 'net-Constify-struct-genl_small_ops'
      Merge git://git.kernel.org/.../netdev/net
      Merge branch 'net-atlantic-phy-tunables-from-mac-driver'
      Merge branch 'drivers-net-add-sw_netstats_rx_add-helper'
      Merge branch 'ethtool-allow-dumping-policies-to-user-space'

David Wilder (2):
      ibmveth: Switch order of ibmveth_helper calls.
      ibmveth: Identify ingress large send packets.

Davide Caratti (4):
      selftests: mptcp: fix typo in mptcp_connect usage
      ip6gre: avoid tx_error when sending MLD/DAD on external tunnels
      net: mptcp: make DACK4/DACK8 usage consistent among all subflows
      netfilter: nftables: allow re-computing sctp CRC-32C in 'payload' sta=
tements

Dejin Zheng (1):
      can: ti_hecc: convert to devm_platform_ioremap_resource_byname()

Denis Efremov (2):
      net/mlx5e: IPsec: Use kvfree() for memory allocated with kvzalloc()
      net/mlx5e: Use kfree() to free fd->g in accel_fs_tcp_create_groups()

Diego Elio Petten=C3=B2 (2):
      can: slcan: update dead link
      can: softing: update dead link

Dinghao Liu (3):
      wilc1000: Fix memleak in wilc_sdio_probe
      wilc1000: Fix memleak in wilc_bus_probe
      Bluetooth: btusb: Fix memleak in btusb_mtk_submit_wmt_recv_urb

Divya Koppera (1):
      net: phy: mchp: Add support for LAN8814 QUAD PHY

Dmitry Osipenko (3):
      brcmfmac: increase F2 watermark for BCM4329
      brcmfmac: drop chip id from debug messages
      brcmfmac: set F2 SDIO block size to 128 bytes for BCM4329

Dmitry Safonov (7):
      xfrm: Provide API to register translator module
      xfrm/compat: Add 64=3D>32-bit messages translator
      xfrm/compat: Attach xfrm dumps to 64=3D>32 bit translator
      netlink/compat: Append NLMSG_DONE/extack to frag_list
      xfrm/compat: Add 32=3D>64-bit messages translator
      xfrm/compat: Translate 32-bit user_policy from sockptr
      selftest/net/xfrm: Add test for ipsec tunnel

Douglas Anderson (3):
      ath10k: Wait until copy complete is actually done before completing
      ath10k: Keep track of which interrupts fired, don't poll them
      ath10k: Get rid of "per_ce_irq" hw param

Edward Cree (29):
      sfc: fix W=3D1 warnings in efx_farch_handle_rx_not_ok
      sfc: fix unused-but-set-variable warning in efx_farch_filter_remove_s=
afe
      sfc: fix kernel-doc on struct efx_loopback_state
      sfc: return errors from efx_mcdi_set_id_led, and de-indirect
      ethtool: fix error handling in ethtool_phys_id
      sfc: add and use efx_tx_send_pending in tx.c
      sfc: make ef100 xmit_more handling look more like ef10's
      sfc: use tx_queue->old_read_count in EF100 TX path
      sfc: use efx_channel_tx_[old_]fill_level() in Siena/EF10 TX datapath
      sfc: rewrite efx_tx_may_pio
      sfc: remove efx_tx_queue_partner
      sfc: don't double-down() filters in ef100_reset()
      sfc: remove phy_op indirection
      sfc: add ethtool ops and miscellaneous ndos to EF100
      sfc: handle limited FEC support
      sfc: remove EFX_DRIVER_VERSION
      sfc: simplify DMA mask setting
      sfc: coding style cleanups in mcdi_port_common.c
      sfc: remove duplicate call to efx_init_channels from EF100 probe
      sfc: remove spurious unreachable return statement
      sfc: cleanups around efx_alloc_channel
      sfc: decouple TXQ type from label
      sfc: define inner/outer csum offload TXQ types
      sfc: create inner-csum queues on EF10 if supported
      sfc: select inner-csum-offload TX queues for skbs that need it
      sfc: de-indirect TSO handling
      sfc: implement encapsulated TSO on EF10
      sfc: advertise encapsulated offloads on EF10
      net: sfc: Replace in_interrupt() usage

Edwin Peer (8):
      bnxt_en: refactor code to limit speed advertising
      bnxt_en: refactor bnxt_get_fw_speed()
      bnxt_en: add basic infrastructure to support PAM4 link speeds
      bnxt_en: ethtool: support PAM4 link speeds up to 200G
      bnxt_en: avoid link reset if speed is not changed
      bnxt_en: refactor bnxt_alloc_fw_health()
      bnxt_en: log firmware status on firmware init failure
      bnxt_en: perform no master recovery during startup

Eelco Chaudron (1):
      net: openvswitch: fixes crash if nf_conncount_init() fails

Eli Cohen (1):
      net/mlx5e: Add support for tc trap

Emmanuel Grumbach (2):
      iwlwifi: mvm: split a print to avoid a WARNING in ROC
      iwlwifi: mvm: don't send a CSA command the firmware doesn't know

Eran Ben Elisha (4):
      net/mlx5: Always use container_of to find mdev pointer from clock str=
uct
      net/mlx5: Rename ptp clock info
      net/mlx5: Release clock lock before scheduling a PPS work
      net/mlx5: Don't call timecounter cyc2time directly from 1PPS flow

Eric Dumazet (9):
      net: zerocopy: combine pages in zerocopy_sg_from_iter()
      selftests: net: tcp_mmap: use madvise(MADV_DONTNEED)
      selftests: net: tcp_mmap: Use huge pages in send path
      selftests: net: tcp_mmap: Use huge pages in receive path
      inet: remove inet_sk_copy_descendant()
      tcp: remove SOCK_QUEUE_SHRUNK
      inet: remove icsk_ack.blocked
      tcp: add exponential backoff in __tcp_send_ack()
      net/sched: get rid of qdisc->padded

Fabian Frederick (19):
      selftests/net: replace obsolete NFT_CHAIN configuration
      selftests: netfilter: add cpu counter check
      selftests: netfilter: fix nft_meta.sh error reporting
      selftests: netfilter: remove unused cnt and simplify command testing
      vxlan: don't collect metadata if remote checksum is wrong
      vxlan: add unlikely to vxlan_remcsum check
      vxlan: move encapsulation warning
      vxlan: check rtnl_configure_link return code correctly
      vxlan: fix vxlan_find_sock() documentation for l3mdev
      selftests: netfilter: add time counter check
      net: netdevice.h: sw_netstats_rx_add helper
      vxlan: use dev_sw_netstats_rx_add()
      geneve: use dev_sw_netstats_rx_add()
      bareudp: use dev_sw_netstats_rx_add()
      gtp: use dev_sw_netstats_rx_add()
      ipv6: use dev_sw_netstats_rx_add()
      xfrm: use dev_sw_netstats_rx_add()
      net: openvswitch: use dev_sw_netstats_rx_add()
      ipv4: use dev_sw_netstats_rx_add()

Felix Fietkau (60):
      mac80211: add missing queue/hash initialization to 802.3 xmit
      mac80211: check and refresh aggregation session in encap offload tx
      mac80211: skip encap offload for tx multicast/control packets
      mac80211: set info->control.hw_key for encap offload packets
      mac80211: rework tx encapsulation offload API
      mac80211: reduce duplication in tx status functions
      mac80211: remove tx status call to ieee80211_sta_register_airtime
      mac80211: swap NEED_TXPROCESSING and HW_80211_ENCAP tx flags
      mac80211: notify the driver when a sta uses 4-address mode
      mac80211: optimize station connection monitor
      mac80211: unify 802.3 (offload) and 802.11 tx status codepath
      mac80211: support using ieee80211_tx_status_ext to free skbs without =
status info
      mac80211: extend ieee80211_tx_status_ext to support bulk free
      mac80211: reorganize code to remove a forward declaration
      mac80211: allow bigger A-MSDU sizes in VHT, even if HT is limited
      mt76: mt7915: fix crash on tx rate report for invalid stations
      mt76: fix double DMA unmap of the first buffer on 7615/7915
      mt76: set interrupt mask register to 0 before requesting irq
      mt76: mt7915: clean up and fix interrupt masking in the irq handler
      mt76: mt7615: only clear unmasked interrupts in irq tasklet
      mt76: mt76x02: clean up and fix interrupt masking in the irq handler
      mt76: mt7615: do not do any work in napi poll after calling napi_comp=
lete_done()
      mt76: mt7915: do not do any work in napi poll after calling napi_comp=
lete_done()
      mt76: mt7915: clean up station stats polling and rate control update
      mt76: mt7915: increase tx retry count
      mt76: mt7915: enable offloading of sequence number assignment
      mt76: move mt76_check_agg_ssn to driver tx_prepare calls
      mt76: mt7615: remove mtxq->agg_ssn assignment
      mt76: mt7915: simplify aggregation session check
      mt76: mt7915: add missing flags in WMM parameter settings
      mt76: mt7615: fix reading airtime statistics
      mt76: mt7915: optimize mt7915_mac_sta_poll
      mt76: dma: update q->queued immediately on cleanup
      mt76: mt7915: schedule tx tasklet in mt7915_mac_tx_free
      mt76: mt7915: significantly reduce interrupt load
      mt76: mt7615: significantly reduce interrupt load
      mt76: mt7915: add support for accessing mapped registers via bus ops
      mt76: add memory barrier to DMA queue kick
      mt76: mt7603: check for single-stream EEPROM configuration
      mt76: usb: fix use of q->head and q->tail
      mt76: sdio: fix use of q->head and q->tail
      mt76: unify queue tx cleanup code
      mt76: remove qid argument to drv->tx_complete_skb
      mt76: remove swq from struct mt76_sw_queue
      mt76: rely on AQL for burst size limits on tx queueing
      mt76: remove struct mt76_sw_queue
      mt76: mt7603: tune tx ring size
      mt76: mt76x02: tune tx ring size
      mt76: mt7615: fix MT_ANT_SWITCH_CON register definition
      mt76: mt7615: fix antenna selection for testmode tx_frames
      mt76: testmode: add a limit for queued tx_frames packets
      mt76: add utility functions for deferring work to a kernel thread
      mt76: convert from tx tasklet to tx worker thread
      mt76: mt7915: fix HE BSS info
      mt76: dma: cache dma map address/len in struct mt76_queue_entry
      mt76: mt7915: simplify mt7915_lmac_mapping
      mt76: mt7915: fix queue/tid mapping for airtime reporting
      mt76: move txwi handling code to dma.c, since it is mmio specific
      mt76: remove retry_q from struct mt76_txq and related code
      mac80211: fix regression in sta connection monitor

Florian Fainelli (22):
      net: dsa: loop: Configure VLANs while not filtering
      net: dsa: loop: Return VLAN table size through devlink
      dt-bindings: net: Document Broadcom SYSTEMPORT clocks
      net: systemport: fetch and use clock resources
      net: systemport: Manage Wake-on-LAN clock
      dt-bindings: net: Document Broadcom SF2 switch clocks
      net: dsa: bcm_sf2: request and handle clocks
      net: dsa: bcm_sf2: recalculate switch clock rate based on ports
      of: Export of_remove_property() to modules
      net: dsa: bcm_sf2: Ensure that MDIO diversion is used
      net: dsa: b53: Report VLAN table occupancy via devlink
      net: phy: bcm7xxx: request and manage GPHY clock
      net: phy: bcm7xxx: Add an entry for BCM72113
      net: dsa: bcm_sf2: Disallow port 5 to be a DSA CPU port
      net: dsa: bcm_sf2: Include address 0 for MDIO diversion
      net: dsa: b53: Configure VLANs while not filtering
      net: vlan: Avoid using BUG() in vlan_proto_idx()
      net: vlan: Fixed signedness in vlan_group_prealloc_vid()
      net: dsa: Call dsa_untag_bridge_pvid() from dsa_switch_rcv()
      net: dsa: b53: Set untag_bridge_pvid
      net: dsa: Obtain VLAN protocol from skb->protocol
      net: dsa: Utilize __vlan_find_dev_deep_rcu()

Florian Westphal (8):
      netfilter: conntrack: do not increment two error counters at same time
      netfilter: conntrack: remove ignore stats
      netfilter: conntrack: add clash resolution stat counter
      netfilter: conntrack: remove unneeded nf_ct_put
      netfilter: conntrack: proc: rename stat column
      net: tcp: drop unused function argument from mptcp_incoming_options
      netfilter: nfnetlink: place subsys mutexes in distinct lockdep classes
      selftests: netfilter: extend nfqueue test case

Francesco Ruggeri (1):
      net: use exponential backoff in netdev_wait_allrefs

Gal Hammer (1):
      igb: read PBA number from flash

Geert Uytterhoeven (7):
      chelsio/chtls: CHELSIO_INLINE_CRYPTO should depend on CHELSIO_T4
      chelsio/chtls: Re-add dependencies on CHELSIO_T4 to fix modular CHELS=
IO_T4
      dt-bindings: net: ethernet-controller: Add internal delay properties
      dt-bindings: net: renesas,ravb: Document internal clock delay propert=
ies
      dt-bindings: net: renesas,etheravb: Convert to json-schema
      ravb: Split delay handling in parsing and applying
      ravb: Add support for explicit internal clock delay configuration

Geliang Tang (16):
      mptcp: rename addr_signal and the related functions
      mptcp: add the outgoing RM_ADDR support
      mptcp: add the incoming RM_ADDR support
      mptcp: send out ADD_ADDR with echo flag
      mptcp: add ADD_ADDR related mibs
      selftests: mptcp: add ADD_ADDR mibs check function
      mptcp: add accept_subflow re-check
      mptcp: remove addr and subflow in PM netlink
      mptcp: implement mptcp_pm_remove_subflow
      mptcp: add RM_ADDR related mibs
      mptcp: add mptcp_destroy_common helper
      selftests: mptcp: add remove cfg in mptcp_connect
      selftests: mptcp: add remove addr and subflow test cases
      mptcp: add struct mptcp_pm_add_entry
      mptcp: add sk_stop_timer_sync helper
      mptcp: retransmit ADD_ADDR when timeout

Georg Kohmann (1):
      net: ipv6: Discard next-hop MTU less than minimum link MTU

George Cherian (2):
      octeontx2-af: Add support for VLAN based RSS hashing
      octeontx2-pf: Support to change VLAN based RSS hash options via ethto=
ol

Gil Adam (4):
      iwlwifi: acpi: evaluate dsm to disable 5.8GHz channels
      iwlwifi: acpi: support ppag table command v2
      iwlwifi: regulatory: regulatory capabilities api change
      iwlwifi: thermal: support new temperature measurement API

Golan Ben Ami (2):
      iwlwifi: enable twt by default
      iwlwifi: support an additional Qu subsystem id

Govind Singh (15):
      ath11k: add simple PCI client driver for QCA6390 chipset
      ath11k: pci: setup resources
      ath11k: pci: add MSI config initialisation
      ath11k: register MHI controller device for QCA6390
      ath11k: pci: add HAL, CE and core initialisation
      ath11k: use remoteproc only with AHB devices
      ath11k: add support for m3 firmware
      ath11k: add board file support for PCI devices
      ath11k: fill appropriate QMI service instance id for QCA6390
      ath11k: pci: add read32() and write32() hif operations
      ath11k: configure copy engine msi address in CE srng
      ath11k: setup ce tasklet for control path
      ath11k: Remove rproc references from common core layer
      ath11k: Move non-fatal warn logs to dbg level
      ath11k: Use GFP_ATOMIC instead of GFP_KERNEL in idr_alloc

Grygorii Strashko (10):
      net: ethernet: ti: am65-cpts: fix i2083 genf (and estf) Reconfigurati=
on Issue
      net: ethernet: ti: ale: add cpsw_ale_get_num_entries api
      net: ethernet: ti: ale: add static configuration
      net: ethernet: ti: cpsw: use dev_id for ale configuration
      net: netcp: ethss: use dev_id for ale configuration
      net: ethernet: ti: am65-cpsw: use dev_id for ale configuration
      net: ethernet: ti: ale: make usage of ale dev_id mandatory
      net: ethernet: ti: am65-cpsw: enable hw auto ageing
      net: ethernet: ti: ale: switch to use tables for vlan entry descripti=
on
      net: ethernet: ti: ale: add support for multi port k3 cpsw versions

Guangbin Huang (15):
      net: hns3: skip periodic service task if reset failed
      net: hns3: fix a typo in struct hclge_mac
      net: hns3: add support for 200G device
      net: hns3: rename macro of pci device id of vf
      net: hns3: add device version to replace pci revision
      net: hns3: delete redundant PCI revision judgement
      net: hns3: add support to query device capability
      net: hns3: use capability flag to indicate FEC
      net: hns3: use capabilities queried from firmware
      net: hns3: add debugfs to dump device capabilities
      net: hns3: add support to query device specifications
      net: hns3: replace the macro of max tm rate with the queried specific=
ation
      net: hns3: add a check for device specifications queried from firmware
      net: hns3: debugfs add new command to query device specifications
      net: hns3: dump tqp enable status in debugfs

Guillaume Nault (2):
      net/sched: act_vlan: Add {POP,PUSH}_ETH actions
      net/sched: act_mpls: Add action to push MPLS LSE before Ethernet head=
er

Guojia Liao (2):
      net: hns3: remove some unused function hns3_update_promisc_mode()
      net: hns3: remove unused code in hns3_self_test()

Gustavo A. R. Silva (32):
      ath9k: Use fallthrough pseudo-keyword
      ath5k: Use fallthrough pseudo-keyword
      ath6kl: Use fallthrough pseudo-keyword
      ath10k: Use fallthrough pseudo-keyword
      ath11k: Use fallthrough pseudo-keyword
      mwifiex: Use fallthrough pseudo-keyword
      rtw88: Use fallthrough pseudo-keyword
      carl9170: Use fallthrough pseudo-keyword
      rt2x00: Use fallthrough pseudo-keyword
      prism54: Use fallthrough pseudo-keyword
      orinoco: Use fallthrough pseudo-keyword
      brcmfmac: Use fallthrough pseudo-keyword
      iwlegacy: Use fallthrough pseudo-keyword
      b43: Use fallthrough pseudo-keyword
      b43legacy: Use fallthrough pseudo-keyword
      atmel: Use fallthrough pseudo-keyword
      ath10k: wmi: Use struct_size() helper in ath10k_wmi_alloc_skb()
      rtlwifi: Use fallthrough pseudo-keyword
      xsk: Fix null check on error return path
      mt7601u: Use fallthrough pseudo-keyword
      mt76: Use fallthrough pseudo-keyword
      dpaa2-mac: Fix potential null pointer dereference
      qed/qed_ll2: Replace one-element array with flexible-array member
      net/sched: cls_u32: Replace one-element array with flexible-array mem=
ber
      fddi/skfp: Avoid the use of one-element array
      net/mlx5e: Fix potential null pointer dereference
      usbnet: Use fallthrough pseudo-keyword
      net: bna: Use fallthrough pseudo-keyword
      net: ksz884x: Use fallthrough pseudo-keyword
      bnx2x: Use fallthrough pseudo-keyword
      bpf, verifier: Use fallthrough pseudo-keyword
      net: thunderx: Use struct_size() helper in kmalloc()

Guvenc Gulce (2):
      s390/net: add SMC config as one of the defaults of CCWGROUP
      net/smc: use the retry mechanism for netlink messages

Hamdan Igbaria (2):
      net/mlx5: DR, Add support for rule creation with flow source hint
      net/mlx5: E-Switch, Support flow source for local vport

Hangbin Liu (3):
      libbpf: Close map fd if init map slots failed
      libbpf: Check if pin_path was set even map fd exist
      selftest/bpf: Test pinning map with reused map fd

Hao Luo (8):
      selftests/bpf: Fix check in global_data_init.
      bpf: Introduce pseudo_btf_id
      bpf/libbpf: BTF support for typed ksyms
      selftests/bpf: Ksyms_btf to test typed ksyms
      bpf: Introduce bpf_per_cpu_ptr()
      bpf: Introducte bpf_this_cpu_ptr()
      bpf/selftests: Test for bpf_per_cpu_ptr() and bpf_this_cpu_ptr()
      selftests/bpf: Fix test_verifier after introducing resolve_pseudo_ldi=
mm64

Hariprasad Kelam (1):
      octeontx2-af: add parser support for Forward DSA

Heiner Kallweit (16):
      r8169: use napi_complete_done return value
      r8169: remove member irq_enabled from struct rtl8169_private
      net: usbnet: remove driver version
      r8169: factor out handling rtl8169_stats
      net: add function dev_fetch_sw_netstats for fetching pcpu_sw_netstats
      IB/hfi1: use new function dev_fetch_sw_netstats
      net: macsec: use new function dev_fetch_sw_netstats
      net: usb: qmi_wwan: use new function dev_fetch_sw_netstats
      net: usbnet: use new function dev_fetch_sw_netstats
      qtnfmac: use new function dev_fetch_sw_netstats
      net: bridge: use new function dev_fetch_sw_netstats
      net: dsa: use new function dev_fetch_sw_netstats
      iptunnel: use new function dev_fetch_sw_netstats
      mac80211: use new function dev_fetch_sw_netstats
      net: openvswitch: use new function dev_fetch_sw_netstats
      xfrm: use new function dev_fetch_sw_netstats

Herat Ramani (1):
      cxgb4: handle 4-tuple PEDIT to NAT mode translation

Hoang Huu Le (3):
      tipc: fix use-after-free in tipc_bcast_get_mode
      tipc: fix a deadlock when flushing scheduled work
      tipc: fix NULL pointer dereference in tipc_named_rcv

Howard Chung (1):
      Bluetooth: Set scan parameters for ADV Monitor

Huang Guobin (1):
      net: wilc1000: clean up resource in error path of init mon interface

Huazhong Tan (9):
      net: hns3: narrow two local variable range in hclgevf_reset_prepare_w=
ait()
      net: hns3: remove unused field 'io_base' in struct hns3_enet_ring
      net: hns3: remove unused field 'tc_num_last_time' in struct hclge_dev
      net: hns3: remove some unused macros related to queue
      net: hns3: add a structure for IR shaper's parameter in hclge_shaper_=
para_calc()
      net: hns3: replace macro HNS3_MAX_NON_TSO_BD_NUM
      net: hns3: rename trace event hns3_over_8bd
      net: hns3: add UDP segmentation offload support
      net: hns3: Add RoCE VF reset support

Huy Nguyen (2):
      net/mlx5: Add NIC TX domain namespace
      net/mlx5e: IPsec: Add TX steering rule per IPsec state

Ido Schimmel (25):
      mlxsw: spectrum_trap: Adjust default policer burst size for Spectrum-=
{2, 3}
      selftests: mlxsw: Decrease required rate accuracy
      selftests: mlxsw: Increase burst size for rate test
      selftests: mlxsw: Increase burst size for burst test
      selftests: mlxsw: Reduce runtime of tc-police scale test
      ipv4: nexthop: Reduce allocation size of 'struct nh_group'
      ipv4: nexthop: Use nla_put_be32() for NHA_GATEWAY
      ipv4: nexthop: Remove unnecessary rtnl_dereference()
      ipv4: nexthop: Correctly update nexthop group when removing a nexthop
      selftests: fib_nexthops: Test IPv6 route with group after removing IP=
v4 nexthops
      ipv4: nexthop: Correctly update nexthop group when replacing a nexthop
      selftests: fib_nexthops: Test IPv6 route with group after replacing I=
Pv4 nexthops
      bridge: mcast: Fix incomplete MDB dump
      nexthop: Remove unused function declaration from header file
      nexthop: Remove NEXTHOP_EVENT_ADD
      nexthop: Convert to blocking notification chain
      nexthop: Only emit a notification when nexthop is actually deleted
      selftests: fib_nexthops: Test cleanup of FDB entries following nextho=
p deletion
      devlink: Add a tracepoint for trap reports
      drop_monitor: Prepare probe functions for devlink tracepoint
      drop_monitor: Convert to using devlink tracepoint
      drop_monitor: Remove no longer used functions
      drop_monitor: Remove duplicate struct
      drop_monitor: Filter control packets in drop monitor
      selftests: net: Add drop monitor test

Igor Russkikh (13):
      qed: move out devlink logic into a new file
      qed/qede: make devlink survive recovery
      qed: fix kconfig help entries
      qed: implement devlink info request
      qed: health reporter init deinit seq
      qed: use devlink logic to report errors
      qed*: make use of devlink recovery infrastructure
      qed: implement devlink dump
      qed: align adjacent indent
      qede: make driver reliable on unload after failures
      ethtool: allow netdev driver to define phy tunables
      net: atlantic: implement phy downshift feature
      net: atlantic: implement media detect feature via phy tunables

Ihab Zhaika (2):
      iwlwifi: add new cards for AX201 family
      iwlwifi: add new cards for MA family

Ilan Peer (1):
      iwlwifi: mvm: Add FTM initiator RTT smoothing logic

Ilya Leoshkevich (6):
      selftests/bpf: Fix test_ksyms on non-SMP kernels
      s390/bpf: Fix multiple tail calls
      selftests/bpf: Fix endianness issue in sk_assign
      selftests/bpf: Fix endianness issue in test_sockopt_sk
      samples/bpf: Fix test_map_in_map on s390
      selftests/bpf: Fix endianness issues in sk_lookup/ctx_narrow_access

Ioana Ciornei (16):
      net: phylink: add helper function to decode USXGMII word
      net: phylink: consider QSGMII interface mode in phylink_mii_c22_pcs_g=
et_state
      net: mdiobus: add clause 45 mdiobus write accessor
      net: phy: add Lynx PCS module
      net: dsa: ocelot: use the Lynx PCS helpers in Felix and Seville
      dpaa2-eth: add a dpaa2_eth_ prefix to all functions in dpaa2-ethtool.c
      dpaa2-eth: add a dpaa2_eth_ prefix to all functions in dpaa2-eth.c
      dpaa2-eth: add a dpaa2_eth_ prefix to all functions in dpaa2-eth-dcb.c
      net: pcs-lynx: add support for 10GBASER
      dpaa2-mac: add PCS support through the Lynx module
      dpaa2-mac: do not check for both child and parent DTS nodes
      dpaa2-eth: no need to check link state right after ndo_open
      devlink: add parser error drop packet traps
      devlink: add .trap_group_action_set() callback
      dpaa2-eth: add basic devlink support
      dpaa2-eth: add support for devlink parser error drop traps

Ionut-robert Aron (1):
      dpaa2-eth: install a single steering rule when SHARED_FS is enabled

Ivan Safonov (1):
      rtw88: rtw8822c: eliminate code duplication, use native swap() functi=
on

Jacob Keller (9):
      devlink: check flash_update parameter support in net core
      devlink: convert flash_update to use params structure
      devlink: introduce flash update overwrite mask
      netdevsim: add support for flash_update overwrite mask
      ice: add support for flash update overwrite mask
      devlink: include <linux/const.h> for _BITUL
      ice: add the DDP Track ID to devlink info
      ice: refactor devlink_port to be per-VSI
      ice: add additional debug logging for firmware update

Jakub Kicinski (78):
      Merge git://git.kernel.org/.../netdev/net
      Merge branch 'sfc-TXQ-refactor'
      Merge branch 'net-dsa-bcm_sf2-Ensure-MDIO-diversion-is-used'
      Merge branch 'net-bridge-mcast-initial-IGMPv3-MLDv2-support-part-1'
      Merge branch 'sfc-ethtool-for-EF100-and-related-improvements'
      net: tighten the definition of interface statistics
      devlink: don't crash if netdev is NULL
      mlx4: make sure to always set the port type
      net: remove napi_hash_del() from driver-facing API
      net: manage napi add/del idempotence explicitly
      net: make sure napi_list is safe for RCU traversal
      ethtool: add standard pause stats
      docs: net: include the new ethtool pause stats in the stats doc
      netdevsim: add pause frame stats
      selftests: add a test for ethtool pause stats
      bnxt: add pause frame stats
      ixgbe: add pause frame stats
      mlx5: add pause frame stats
      mlx4: add pause frame stats
      net: remove comments on struct rtnl_link_stats
      Revert "vxlan: move encapsulation warning"
      netdevsim: fix duplicated debugfs directory
      udp_tunnel: add the ability to share port tables
      netdevsim: add warnings on unexpected UDP tunnel port errors
      netdevsim: shared UDP tunnel port table support
      selftests: net: add a test for shared UDP tunnel info tables
      i40e: convert to new udp_tunnel infrastructure
      ice: remove unused args from ice_get_open_tunnel_port()
      ice: convert to new udp_tunnel infrastructure
      netdevsim: support the static IANA VXLAN port flag
      selftests: net: add a test for static UDP tunnel ports
      docs: vxlan: add info about device features
      genetlink: reorg struct genl_family
      genetlink: add small version of ops
      genetlink: move to smaller ops wherever possible
      genetlink: add a structure for dump state
      genetlink: use .start callback for dumppolicy
      genetlink: bring back per op policy
      taskstats: move specifying netlink policy back to ops
      genetlink: use parsed attrs in dumppolicy
      genetlink: switch control commands to per-op policies
      genetlink: allow dumping command-specific policy
      ethtool: wire up get policies to ops
      ethtool: wire up set policies to ops
      ethtool: trim policy tables
      ethtool: link up ethnl_header_policy as a nested policy
      netlink: create helpers for checking type is an int
      netlink: add mask validation
      ethtool: specify which header flags are supported per command
      Merge git://git.kernel.org/.../netdev/net
      Merge branch 'devlink-add-reload-action-and-limit-options'
      Merge git://git.kernel.org/.../pablo/nf
      Merge branch '100GbE-Intel-Wired-LAN-Driver-Updates-2020-10-07'
      Merge tag 'linux-can-next-for-5.10-20201007' of git://git.kernel.org/=
.../mkl/linux-can-next
      Merge branch 'net-smc-updates-2020-10-07'
      Merge branch 'netlink-export-policy-on-validation-failures'
      Merge tag 'mac80211-next-for-net-next-2020-10-08' of git://git.kernel=
.org/.../jberg/mac80211-next
      Merge tag 'wireless-drivers-next-2020-10-09' of git://git.kernel.org/=
.../kvalo/wireless-drivers-next
      Merge tag 'linux-can-fixes-for-5.9-20201008' of git://git.kernel.org/=
.../mkl/linux-can
      Merge branch 'mptcp-some-fallback-fixes'
      Merge branch 'enetc-Migrate-to-PHYLINK-and-PCS_LYNX'
      Merge branch 'Offload-tc-vlan-mangle-to-mscc_ocelot-switch'
      Merge tag 'linux-can-next-for-5.10-20201012' of git://git.kernel.org/=
.../mkl/linux-can-next
      Merge branch 'bnxt_en-Updates-for-net-next'
      Merge git://git.kernel.org/.../pablo/nf-next
      Merge git://git.kernel.org/.../bpf/bpf-next
      Merge branch 'macb-support-the-2-deep-Tx-queue-on-at91'
      Merge branch 'net-add-and-use-function-dev_fetch_sw_netstats-for-fetc=
hing-pcpu_sw_netstats'
      Merge branch '40GbE-Intel-Wired-LAN-Driver-Updates-2020-10-12'
      Merge tag 'mlx5-updates-2020-10-12' of git://git.kernel.org/.../saeed=
/linux
      Merge git://git.kernel.org/.../pablo/nf
      Merge branch 'l3mdev-icmp-error-route-lookup-fixes'
      Merge branch 'ibmveth-gso-fix'
      Merge branch 'net-smc-fixes-2020-10-14'
      Merge tag 'rxrpc-next-20201015' of git://git.kernel.org/.../dhowells/=
linux-fs
      Revert "bpfilter: Fix build error with CONFIG_BPFILTER_UMH"
      Merge git://git.kernel.org/.../netdev/net
      Merge git://git.kernel.org/.../bpf/bpf-next

Jakub Sitnicki (1):
      bpf: sk_lookup: Add user documentation

Jakub Wilk (1):
      bpf: Fix typo in uapi/linux/bpf.h

James Chapman (1):
      Documentation/networking: update l2tp docs

James Prestwood (1):
      nl80211: fix PORT_AUTHORIZED wording to reflect behavior

Jaroslaw Gawin (1):
      i40e: Allow changing FEC settings on X722 if supported by FW

Jason Yan (9):
      brcmsmac: main: Eliminate empty brcms_c_down_del_timer()
      net: b44: use true,false for bool variables
      net: qed: use true,false for bool variables
      bnx2x: use true,false for bool variables
      8139too: use true,false for bool variables
      net: ethernet: ti: cpsw: use true,false for bool variables
      rtlwifi: rtl8192ee: use true,false for bool variable large_cfo_hit
      rtlwifi: rtl8821ae: use true,false for bool variable large_cfo_hit
      rtlwifi: rtl8723be: use true,false for bool variable large_cfo_hit

Jean-Philippe Brucker (1):
      selftests/bpf: Fix alignment of .BTF_ids

Jesper Dangaard Brouer (1):
      tools, bpf/build: Cleanup feature files on make clean

Jesse Brandeburg (10):
      intel-ethernet: clean up W=3D1 warnings in kdoc
      intel: handle unused assignments
      drivers/net/ethernet: clean up unused assignments
      drivers/net/ethernet: rid ethernet of no-prototype warnings
      drivers/net/ethernet: handle one warning explicitly
      drivers/net/ethernet: add some basic kdoc tags
      drivers/net/ethernet: remove incorrectly formatted doc
      sfc: fix kdoc warning
      drivers/net/ethernet: clean up mis-targeted comments
      e1000: remove unused and incorrect code

Jia-Ju Bai (1):
      p54: avoid accessing the data mapped to streaming DMA

Jianbo Liu (3):
      net/mlx5e: Return a valid errno if can't get lag device index
      net/mlx5e: Add LAG warning for unsupported tx type
      net/mlx5e: Add LAG warning if bond slave is not lag master

Jianlin Lv (1):
      docs: Correct subject prefix and update LLVM info

Jing Xiangfeng (3):
      ssb: Remove meaningless jump label to simplify the code
      net: unix: remove redundant assignment to variable 'err'
      caif_virtio: Remove redundant initialization of variable err

Jiri Olsa (19):
      tools resolve_btfids: Add size check to get_id function
      tools resolve_btfids: Add support for set symbols
      bpf: Move btf_resolve_size into __btf_resolve_size
      bpf: Add elem_id pointer as argument to __btf_resolve_size
      bpf: Add type_id pointer as argument to __btf_resolve_size
      bpf: Remove recursion call in btf_struct_access
      bpf: Factor btf_struct_access function
      bpf: Add btf_struct_ids_match function
      bpf: Add BTF_SET_START/END macros
      bpf: Add d_path helper
      bpf: Update .BTF_ids section in btf.rst with sets info
      selftests/bpf: Add verifier test for d_path helper
      selftests/bpf: Add test for d_path helper
      selftests/bpf: Add set test to resolve_btfids
      selftests/bpf: Fix open call in trigger_fstat_events
      selftests/bpf: Fix stat probe in d_path test
      bpf: Check CONFIG_BPF option for resolve_btfids
      tools resolve_btfids: Always force HOSTARCH
      selftests/bpf: Adding test for arg dereference in extension trace

Jiri Pirko (8):
      mlxsw: Bump firmware version to XX.2008.1310
      mlxsw: Move fw flashing code into core.c
      mlxsw: core: Push code doing params register/unregister into separate=
 helpers
      mlxsw: Move fw_load_policy devlink param into core.c
      mlxsw: reg: Add Monitoring FW Debug Register
      mlxsw: reg: Add Monitoring FW General Debug Register
      devlink: introduce the health reporter test command
      mlxsw: core: Introduce fw_fatal health reporter

Jisheng Zhang (2):
      net: phy: realtek: enable ALDPS to save power for RTL8211F
      net: phy: marvell: Use phy_read_paged() instead of open coding it

Joakim Zhang (16):
      can: flexcan: Ack wakeup interrupt separately
      can: flexcan: Add check for transceiver maximum bitrate limitation
      can: flexcan: add correctable errors correction when HW supports ECC
      can: flexcan: flexcan_chip_stop(): add error handling and propagate e=
rror value
      can: flexcan: disable clocks during stop mode
      can: flexcan: add LPSR mode support
      can: flexcan: use struct canfd_frame for CAN classic frame
      can: flexcan: add CAN-FD mode support
      can: flexcan: add ISO CAN FD feature support
      can: flexcan: add CAN FD BRS support
      can: flexcan: add Transceiver Delay Compensation support
      can: flexcan: add imx8qm support
      can: flexcan: add lx2160ar1 support
      can: flexcan: initialize all flexcan memory for ECC function
      can: flexcan: add flexcan driver for i.MX8MP
      can: flexcan: disable runtime PM if register flexcandev failed

Joe Perches (6):
      8390: Avoid comma separated statements
      fs_enet: Avoid comma separated statements
      wan: sbni: Avoid comma separated statements
      ipv6: fib6: Avoid comma separated statements
      sunrpc: Avoid comma separated statements
      rtlwifi: Use ffs in <foo>_phy_calculate_bit_shift

Johannes Berg (30):
      netlink: consistently use NLA_POLICY_EXACT_LEN()
      netlink: consistently use NLA_POLICY_MIN_LEN()
      netlink: make NLA_BINARY validation more flexible
      nl80211: clean up code/policy a bit
      nl80211: use NLA_POLICY_RANGE(NLA_BINARY, ...) for a few attributes
      netlink: policy: correct validation type check
      cfg80211: add missing kernel-doc for S1G band capabilities
      mac80211: fix some encapsulation offload kernel-doc
      mac80211_hwsim: fix typo in kernel-doc
      mac80211: fix some missing kernel-doc
      wireless: radiotap: fix some kernel-doc
      mac80211: fix some more kernel-doc in mesh
      iwlwifi: mvm: rs-fw: handle VHT extended NSS capability
      iwlwifi: mvm: use CHECKSUM_COMPLETE
      iwlwifi: mvm: d3: support GCMP ciphers
      iwlwifi: align RX status flags with firmware
      iwlwifi: mvm: d3: parse wowlan status version 11
      iwlwifi: api: fix u32 -> __le32
      nl80211: reduce non-split wiphy dump size
      nl80211: fix non-split wiphy information
      netlink: fix policy dump leak
      netlink: compare policy more accurately
      netlink: rework policy dump to support multiple policies
      genetlink: factor skb preparation out of ctrl_dumppolicy()
      genetlink: properly support per-op policy dumping
      iwlwifi: mvm: stop claiming NL80211_EXT_FEATURE_SET_SCAN_DWELL
      ethtool: strset: allow ETHTOOL_A_STRSET_COUNTS_ONLY attr
      ethtool: correct policy for ETHTOOL_MSG_CHANNELS_SET
      netlink: policy: refactor per-attr policy writing
      netlink: export policy in extended ACK

John Crispin (2):
      nl80211: rename csa counter attributes countdown counters
      mac80211: rename csa counters to countdown counters

John Fastabend (17):
      bpf, verifier: Remove redundant var_off.value ops in scalar known reg=
 cases
      bpf: Add AND verifier test case where 32bit and 64bit bounds differ
      bpf: Add comment to document BTF type PTR_TO_BTF_ID_OR_NULL
      bpf, selftests: Fix cast to smaller integer type 'int' warning in raw=
_tp
      bpf, selftests: Fix warning in snprintf_btf where system() call unche=
cked
      bpf, sockmap: Add skb_adjust_room to pop bytes off ingress payload
      bpf, sockmap: Update selftests to use skb_adjust_room
      bpf, sockmap: Skb verdict SK_PASS to self already checked rmem limits
      bpf, sockmap: On receive programs try to fast track SK_PASS ingress
      bpf, sockmap: Remove skb_set_owner_w wmem will be taken later from se=
ndpage
      bpf, sockmap: Remove dropped data on errors in redirect case
      bpf, sockmap: Remove skb_orphan and let normal skb_kfree do cleanup
      bpf, sockmap: Add memory accounting so skbs on ingress lists are visi=
ble
      bpf, sockmap: Check skb_verdict and skb_parser programs explicitly
      bpf, sockmap: Allow skipping sk_skb parser program
      bpf, selftests: Add option to test_sockmap to omit adding parser prog=
ram
      bpf, selftests: Add three new sockmap tests for verdict only programs

Jonathan Lemon (1):
      mlx4: handle non-napi callers to napi_poll

Jonathan Neusch=C3=A4fer (1):
      net: Add a missing word

Jose M. Guisado Gomez (5):
      netfilter: nf_tables: add userdata attributes to nft_table
      netfilter: nf_tables: add userdata support for nft_object
      netfilter: nf_tables: fix userdata memleak
      netfilter: nf_tables: use nla_memdup to copy udata
      netfilter: nf_tables: add userdata attributes to nft_chain

Joseph Hwang (1):
      Bluetooth: sco: new getsockopt options BT_SNDMTU/BT_RCVMTU

Julia Lawall (7):
      ath: drop unnecessary list_empty
      dpaa2-eth: drop double zeroing
      RDS: drop double zeroing
      bcma: use semicolons rather than commas to separate statements
      tcp: use semicolons rather than commas to separate statements
      net/ipv6: use semicolons rather than commas to separate statements
      net/tls: use semicolons rather than commas to separate statements

Julian Anastasov (1):
      ipvs: clear skb->tstamp in forwarding path

Julian Wiedmann (25):
      s390/qeth: clean up qeth_l3_send_setdelmc()'s declaration
      s390/qeth: use to_delayed_work()
      s390/qeth: make queue lock a proper spinlock
      s390/qeth: don't disable address events during initialization
      s390/qeth: don't let HW override the configured port role
      s390/qeth: copy less data from bridge state events
      s390/qeth: unify structs for bridge port state
      s390/qeth: strictly order bridge address events
      s390/qeth: don't init refcount twice for mcast IPs
      s390/qeth: relax locking for ipato config data
      s390/qeth: clean up string ops in qeth_l3_parse_ipatoe()
      s390/qeth: replace deprecated simple_stroul()
      s390/qeth: tighten ucast IP locking
      s390/qeth: cancel cmds earlier during teardown
      s390/qeth: consolidate online code
      s390/qeth: consolidate teardown code
      s390/qeth: remove forward declarations in L2 code
      s390/qeth: keep track of wanted TX queues
      s390/qeth: de-magic the QIB parm area
      s390/qeth: allow configuration of TX queues for OSA devices
      s390/qeth: constify the disciplines
      s390/qeth: use netdev_name()
      s390/qeth: static checker cleanups
      net/af_iucv: right-size the uid variable in iucv_sock_bind()
      net/iucv: fix indentation in __iucv_message_receive()

KP Singh (7):
      bpf: Renames in preparation for bpf_local_storage
      bpf: Generalize caching for sk_storage.
      bpf: Generalize bpf_sk_storage
      bpf: Split bpf_local_storage to bpf_sk_storage
      bpf: Implement bpf_local_storage for inodes
      bpf: Allow local storage to be used from LSM programs
      bpf: Add selftests for local_storage

Kai-Heng Feng (1):
      rtw88: pci: Power cycle device during shutdown

Kalle Valo (33):
      ath11k: create a common function to request all firmware files
      ath11k: don't use defines for hw specific firmware directories
      ath11k: change ath11k_core_fetch_board_data_api_n() to use ath11k_cor=
e_create_firmware_path()
      ath11k: remove useless info messages
      ath11k: qmi: cleanup info messages
      ath11k: don't use defines in hw_params
      ath11k: remove define ATH11K_QMI_DEFAULT_CAL_FILE_NAME
      ath11k: move ring mask definitions to hw_params
      ath11k: implement ath11k_core_pre_init()
      ath11k: hal: create hw_srng_config dynamically
      ath10k: move enable_pll_clk call to ath10k_core_start()
      ath11k: hal: cleanup dynamic register macros
      ath11k: ce: remove host_ce_config_wlan macro
      ath11k: ce: remove CE_COUNT() macro
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      ath11k: fix link error when CONFIG_REMOTEPROC is disabled
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      ath11k: refactor debugfs code into debugfs.c
      ath11k: debugfs: use ath11k_debugfs_ prefix
      ath11k: rename debug_htt_stats.[c|h] to debugfs_htt_stats.[c|h]
      ath11k: debugfs: move some function declarations to correct header fi=
les
      ath11k: wmi: remove redundant configuration values from init
      ath11k: remove redundant num_keep_alive_pattern assignment
      Merge tag 'mt76-for-kvalo-2020-09-23' of https://github.com/nbd168/wi=
reless
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git
      ath11k: fix undefined reference to 'ath11k_debugfs_htt_ext_stats_hand=
ler'
      Merge tag 'iwlwifi-next-for-kalle-2020-09-30-2' of git://git.kernel.o=
rg/.../iwlwifi/iwlwifi-next
      ath11k: mac: fix parenthesis alignment
      ath11k: add interface_modes to hw_params
      ath11k: pci: check TCSR_SOC_HW_VERSION
      ath11k: disable monitor mode on QCA6390
      ath11k: remove unnecessary casts to u32
      Merge ath-next from git://git.kernel.org/.../kvalo/ath.git

Karsten Graul (11):
      net/smc: use separate work queues for different worker types
      net/smc: check variable before dereferencing in smc_close.c
      net/smc: remove constant and introduce helper to check for a pnet id
      net/smc: send ISM devices with unique chid in CLC proposal
      net/smc: use an array to check fields in system EID
      net/smc: consolidate unlocking in same function
      net/smc: cleanup buffer usage in smc_listen_work()
      net/smc: restore smcd_version when all ISM V2 devices failed to init
      net/smc: fix use-after-free of delayed events
      net/smc: fix valid DMBE buffer sizes
      net/smc: fix invalid return code in smcd_new_buf_create()

Karthikeyan Periyasamy (1):
      ath11k: Add support spectral scan for IPQ6018

Keita Suzuki (1):
      brcmsmac: fix memory leak in wlc_phy_attach_lcnphy

Kiran K (4):
      Bluetooth: btusb: Update boot parameter specific to SKU
      Bluetooth: btintel: Refactor firmware download function
      Bluetooth: btintel: Add infrastructure to read controller information
      Bluetooth: btintel: Functions to send firmware header / payload

Kiran Kumar K (1):
      octeontx2-af: add parser support for NAT-T-ESP

Krzysztof Kozlowski (10):
      ath9k_htc: Do not select MAC80211_LEDS by default
      ath9k: Do not select MAC80211_LEDS by default
      dt-bindings: net: nfc: s3fwrn5: Convert to dtschema
      dt-bindings: net: nfc: s3fwrn5: Remove wrong vendor prefix from GPIOs
      nfc: s3fwrn5: Remove wrong vendor prefix from GPIOs
      nfc: s3fwrn5: Remove unneeded 'ret' variable
      nfc: s3fwrn5: Add missing CRYPTO_HASH dependency
      nfc: s3fwrn5: Constify s3fwrn5_fw_info when not modified
      MAINTAINERS: Add Krzysztof Kozlowski to Samsung S3FWRN5 and remove Ro=
bert
      arm64: dts: exynos: Use newer S3FWRN5 GPIO properties in Exynos5433 T=
M2

Kunihiko Hayashi (1):
      net: ethernet: ave: Replace alloc_etherdev() with devm_alloc_etherdev=
()

Kuo Zhao (3):
      gve: Get and set Rx copybreak via ethtool
      gve: Add stats for gve.
      gve: Add Gvnic stats AQ command and ethtool show/set-priv-flags.

Kurt Kanzenbach (12):
      ptp: Add generic ptp v2 header parsing function
      ptp: Add generic ptp message type function
      net: dsa: mv88e6xxx: Use generic helper function
      mlxsw: spectrum_ptp: Use generic helper function
      ethernet: ti: am65-cpts: Use generic helper function
      ethernet: ti: cpts: Use generic helper function
      net: phy: dp83640: Use generic helper function
      ptp: ptp_ines: Use generic helper function
      ptp: Remove unused macro
      dt-bindings: net: dsa: b53: Add missing reg property to example
      dt-bindings: net: dsa: b53: Specify unit address in hex
      dt-bindings: net: dsa: b53: Fix full duplex in example

Kurt Van Dijck (1):
      can: mcp25xxfd: add listen-only mode

Lad Prabhakar (3):
      dt-bindings: can: rcar_can: Add r8a7742 support
      dt-bindings: can: rcar_canfd: Document r8a774e1 support
      dt-bindings: can: rcar_can: Document r8a774e1 support

Landen Chao (6):
      net: dsa: mt7530: Refine message in Kconfig
      net: dsa: mt7530: Extend device data ready for adding a new hardware
      dt-bindings: net: dsa: add new MT7531 binding to support MT7531
      net: dsa: mt7530: Add the support of MT7531 switch
      arm64: dts: mt7622: add mt7531 dsa to mt7622-rfb1 board
      arm64: dts: mt7622: add mt7531 dsa to bananapi-bpi-r64 board

Larry Finger (15):
      rtlwifi: Start changing RT_TRACE into rtl_dbg
      rtlwifi: Replace RT_TRACE with rtl_dbg
      rtlwifi: btcoexist: Replace RT_TRACE with rtl_dbg
      rtlwifi: rtl8188ee: Rename RT_TRACE to rtl_dbg
      rtlwifi: rtl8192-common: Rename RT_TRACE to rtl_dbg
      rtlwifi: rtl8192ce: Rename RT_TRACE to rtl_dbg
      rtlwifi: rtl8192cu: Rename RT_TRACE to rtl_dbg
      rtlwifi: rtl8192de: Rename RT_TRACE to rtl_dbg
      rtlwifi: rtl8192ee: Rename RT_TRACE to rtl_dbg
      rtlwifi: rtl8192se Rename RT_TRACE to rtl_dbg
      rtlwifi: rtl8723ae Rename RT_TRACE to rtl_dbg
      rtlwifi: rtl8723be Rename RT_TRACE to rtl_dbg
      rtlwifi: rtl8723-common: Rename RT_TRACE to rtl_dbg
      rtlwifi: rtl8821ae: Rename RT_TRACE to rtl_dbg
      rtlwifi: Remove temporary definition of RT_TRACE

Lee Jones (106):
      ath5k: pcu: Add a description for 'band' remove one for 'mode'
      wil6210: Demote non-kerneldoc headers to standard comment blocks
      ath5k: Fix kerneldoc formatting issue
      ath6kl: wmi: Remove unused variable 'rate'
      ath9k: ar9002_initvals: Remove unused array 'ar9280PciePhy_clkreq_off=
_L1_9280'
      ath9k: ar9001_initvals: Remove unused array 'ar5416Bank6_9100'
      ath9k: ar5008_initvals: Remove unused table entirely
      ath9k: ar5008_initvals: Move ar5416Bank{0,1,2,3,7} to where they are =
used
      wil6210: debugfs: Fix a couple of formatting issues in 'wil6210_debug=
fs_init'
      atmel: Demote non-kerneldoc header to standard comment block
      b43: main: Add braces around empty statements
      airo: Place brackets around empty statement
      airo: Fix a myriad of coding style issues
      iwlegacy: common: Remove set but not used variable 'len'
      iwlegacy: common: Demote kerneldoc headers to standard comment blocks
      ipw2200: Remove set but unused variables 'rc' and 'w'
      b43legacy: main: Provide braces around empty 'if' body
      brcmfmac: fweh: Remove set but unused variable 'err'
      brcmfmac: fweh: Fix docrot related function documentation issues
      brcmsmac: mac80211_if: Demote a few non-conformant kerneldoc headers
      ipw2200: Demote lots of nonconformant kerneldoc comments
      b43: phy_common: Demote non-conformant kerneldoc header
      b43: phy_n: Add empty braces around empty statements
      wil6210: wmi: Fix formatting and demote non-conforming function heade=
rs
      wil6210: interrupt: Demote comment header which is clearly not kernel=
-doc
      wil6210: txrx: Demote obvious abuse of kernel-doc
      wil6210: txrx_edma: Demote comments which are clearly not kernel-doc
      wil6210: pmc: Demote a few nonconformant kernel-doc function headers
      wil6210: wil_platform: Demote kernel-doc header to standard comment b=
lock
      carl9170: Convert 'ar9170_qmap' to inline function
      hostap: Mark 'freq_list' as __maybe_unused
      rsi: Fix some kernel-doc issues
      rsi: File header should not be kernel-doc
      libertas_tf: Demote non-conformant kernel-doc headers
      wlcore: cmd: Fix some parameter description disparities
      libertas_tf: Fix a bunch of function doc formatting issues
      iwlegacy: debug: Demote seemingly unintentional kerneldoc header
      hostap: hostap_ap: Mark 'txt' as __always_unused
      cw1200: wsm: Remove 'dummy' variables
      libertas: Fix 'timer_list' stored private data related dot-rot
      mt7601u: phy: Fix misnaming when documented function parameter 'dac'
      rsi: Fix misnamed function parameter 'rx_pkt'
      rsi: Fix a few kerneldoc misdemeanours
      rsi: Fix a myriad of documentation issues
      rsi: File header comments should not be kernel-doc
      iwlegacy: 4965: Demote a bunch of nonconformant kernel-doc headers
      brcmfmac: p2p: Deal with set but unused variables
      libertas: Fix misnaming for function param 'device'
      libertas_tf: Fix function documentation formatting errors
      hostap: Remove set but unused variable 'hostscan'
      rsi: Add description for function param 'sta'
      brcmsmac: ampdu: Remove a bunch of unused variables
      brcmfmac: p2p: Fix a bunch of function docs
      rsi: Add descriptions for rsi_set_vap_capabilities()'s parameters
      brcmsmac: main: Remove a bunch of unused variables
      rsi: Source file headers do not make good kernel-doc candidates
      brcmfmac: firmware: Demote seemingly unintentional kernel-doc header
      rsi: File headers are not suitable for kernel-doc
      iwlegacy: 4965-mac: Convert function headers to standard comment bloc=
ks
      brcmfmac: btcoex: Update 'brcmf_btcoex_state' and demote others
      b43: phy_ht: Remove 9 year old TODO
      rsi: Source file headers are not suitable for kernel-doc
      iwlegacy: 4965-rs: Demote non kernel-doc headers to standard comment =
blocks
      iwlegacy: 4965-calib: Demote seemingly accidental kernel-doc header
      brcmfmac: fwsignal: Remove unused variable 'brcmf_fws_prio2fifo'
      rtlwifi: rtl8192c: phy_common: Remove unused variable 'bbvalue'
      mwifiex: pcie: Move tables to the only place they're used
      brcmsmac: ampdu: Remove a couple set but unused variables
      iwlegacy: 3945-mac: Remove all non-conformant kernel-doc headers
      iwlegacy: 3945-rs: Remove all non-conformant kernel-doc headers
      iwlegacy: 3945: Remove all non-conformant kernel-doc headers
      brcmfmac: p2p: Fix a couple of function headers
      orinoco_usb: Downgrade non-conforming kernel-doc headers
      brcmsmac: phy_cmn: Remove a unused variables 'vbat' and 'temp'
      zd1211rw: zd_chip: Fix formatting
      zd1211rw: zd_mac: Add missing or incorrect function documentation
      zd1211rw: zd_chip: Correct misspelled function argument
      brcmfmac: fwsignal: Finish documenting 'brcmf_fws_mac_descriptor'
      wlcore: debugfs: Remove unused variable 'res'
      rsi: rsi_91x_sdio: Fix a few kernel-doc related issues
      hostap: Remove unused variable 'fc'
      wl3501_cs: Fix a bunch of formatting issues related to function docs
      rtw88: debug: Remove unused variables 'val'
      rsi: rsi_91x_sdio_ops: File headers are not good kernel-doc candidates
      prism54: isl_ioctl: Remove unused variable 'j'
      brcmsmac: phy_lcn: Remove a bunch of unused variables
      brcmsmac: phy_n: Remove a bunch of unused variables
      brcmsmac: phytbl_lcn: Remove unused array 'dot11lcnphytbl_rx_gain_inf=
o_rev1'
      brcmsmac: phytbl_n: Remove a few unused arrays
      brcmsmac: phytbl_lcn: Remove unused array 'dot11lcn_gain_tbl_rev1'
      brcmsmac: phy_lcn: Remove unused variable 'lcnphy_rx_iqcomp_table_rev=
0'
      mt76: mt76x0: Move tables used only by init.c to their own header file
      iwlwifi: dvm: Demote non-compliant kernel-doc headers
      iwlwifi: rs: Demote non-compliant kernel-doc headers
      iwlwifi: dvm: tx: Demote non-compliant kernel-doc headers
      iwlwifi: dvm: lib: Demote non-compliant kernel-doc headers
      iwlwifi: calib: Demote seemingly unintentional kerneldoc header
      iwlwifi: dvm: sta: Demote a bunch of nonconformant kernel-doc headers
      iwlwifi: mvm: ops: Remove unused static struct 'iwl_mvm_debug_names'
      iwlwifi: dvm: Demote a couple of nonconformant kernel-doc headers
      iwlwifi: mvm: utils: Fix some doc-rot
      iwlwifi: dvm: scan: Demote a few nonconformant kernel-doc headers
      iwlwifi: dvm: rxon: Demote non-conformant kernel-doc headers
      iwlwifi: mvm: tx: Demote misuse of kernel-doc headers
      iwlwifi: dvm: devices: Fix function documentation formatting issues
      iwlwifi: iwl-drv: Provide descriptions debugfs dentries

Leon Romanovsky (1):
      net: sched: Fix suspicious RCU usage while accessing tcf_tunnel_info

Li Heng (1):
      ath9k: Remove set but not used variable

Li RongQing (2):
      i40e: not compute affinity_mask for IRQ
      i40e: optimise prefetch page refcount

Lijun Pan (11):
      ibmvnic: compare adapter->init_done_rc with more readable ibmvnic_rc_=
codes
      ibmvnic: improve ibmvnic_init and ibmvnic_reset_init
      ibmvnic: remove never executed if statement
      ibmvnic: merge ibmvnic_reset_init and ibmvnic_init
      Revert "ibmvnic: remove never executed if statement"
      ibmvnic: set up 200GBPS speed
      ibmvnic: rename send_cap_queries to send_query_cap
      ibmvnic: rename ibmvnic_send_req_caps to send_request_cap
      ibmvnic: rename send_map_query to send_query_map
      ibmvnic: create send_query_ip_offload
      ibmvnic: create send_control_ip_offload

Linus Walleij (8):
      net: dsa: rtl8366: Check validity of passed VLANs
      net: dsa: rtl8366: Refactor VLAN/PVID init
      net: dsa: rtl8366rb: Support setting MTU
      net: gemini: Clean up phy registration
      net: dsa: rtl8366rb: Switch to phylink
      net: dsa: rtl8366: Skip PVID setting if not requested
      net: dsa: rtl8366rb: Support all 4096 VLANs
      net: dsa: rtl8366rb: Roof MTU for switch

Liu Shixin (4):
      cxgb4vf: convert to use DEFINE_SEQ_ATTRIBUTE macro
      can: peak_usb: convert to use le32_add_cpu()
      ath5k: convert to use DEFINE_SEQ_ATTRIBUTE macro
      mt76: mt7915: convert to use le16_add_cpu()

Loic Poulain (12):
      wcn36xx: Add ieee80211 rx status rate information
      wcn36xx: Fix multiple AMPDU sessions support
      wcn36xx: Add TX ack support
      wcn36xx: Increase number of TX retries
      wcn36xx: Fix TX data path
      wcn36xx: Use sequence number allocated by mac80211
      wcn36xx: Fix software-driven scan
      wcn36xx: Setup starting bitrate to MCS-5
      wcn36xx: Disable bmps when encryption is disabled
      wcn36xx: Fix warning due to bad rate_idx
      mac80211: Inform AP when returning operating channel
      wcn36xx: Advertise beacon filtering support in bmps

Lorenz Bauer (28):
      net: sk_msg: Simplify sk_psock initialization
      bpf: sockmap: Merge sockmap and sockhash update functions
      bpf: sockmap: Call sock_map_update_elem directly
      bpf: Override the meaning of ARG_PTR_TO_MAP_VALUE for sockmap and soc=
khash
      bpf: sockmap: Allow update from BPF
      selftests: bpf: Test sockmap update from BPF
      selftests: bpf: Fix sockmap update nits
      net: sockmap: Remove unnecessary sk_fullsock checks
      net: Allow iterating sockmap and sockhash
      selftests: bpf: Test iterating a sockmap
      bpf: Plug hole in struct bpf_sk_lookup_kern
      btf: Make btf_set_contains take a const pointer
      bpf: Check scalar or invalid register in check_helper_mem_access
      btf: Add BTF_ID_LIST_SINGLE macro
      bpf: Allow specifying a BTF ID per argument in function protos
      bpf: Make BTF pointer type checking generic
      bpf: Make reference tracking generic
      bpf: Make context access check generic
      bpf: Set meta->raw_mode for pointers close to use
      bpf: Check ARG_PTR_TO_SPINLOCK register type in check_func_arg
      bpf: Hoist type checking for nullable arg types
      bpf: Use a table to drive helper arg type checks
      bpf: Explicitly size compatible_reg_types
      bpf: sockmap: Enable map_update_elem from bpf_iter
      selftests: bpf: Add helper to compare socket cookies
      selftests: bpf: Remove shared header from sockmap iter test
      selftest: bpf: Test copying a sockmap and sockhash
      bpf, sockmap: Add locking annotations to iterator

Lorenzo Bianconi (34):
      net: mvneta: rely on MVNETA_MAX_RX_BUF_SIZE for pkt split in mvneta_s=
wbm_rx_frame()
      net: mventa: drop mvneta_stats from mvneta_swbm_rx_frame signature
      net: mvneta: avoid copying shared_info frags in mvneta_swbm_build_skb
      mt76: mt7615: move drv_own/fw_own in mt7615_mcu_ops
      mt76: mt7663s: move drv_own/fw_own in mt7615_mcu_ops
      mt76: mt7615: hold mt76 lock queueing wd in mt7615_queue_key_update
      mt76: do not inject packets if MT76_STATE_PM is set
      mt76: mt7615: reschedule runtime-pm receiving a tx interrupt
      mt76: mt76s: fix oom in mt76s_tx_queue_skb_raw
      mt76: mt76s: move tx processing in a dedicated wq
      mt76: mt7663s: move rx processing in txrx wq
      mt76: mt76s: move status processing in txrx wq
      mt76: mt76s: move tx/rx processing in 2 separate works
      mt76: mt76s: get rid of unused variable
      mt76: mt7615: release mutex in mt7615_reset_test_set
      mt76: mt7663s: use NULL instead of 0 in sdio code
      mt76: mt7615: fix possible memory leak in mt7615_tm_set_tx_power
      mt76: mt7615: fix a possible NULL pointer dereference in mt7615_pm_wa=
ke_work
      mt76: fix a possible NULL pointer dereference in mt76_testmode_dump
      mt76: mt7663u: fix dma header initialization
      mt76: mt7622: fix fw hang on mt7622
      mt76: mt7663s: do not use altx for ctl/mgmt traffic
      mt76: mt7663s: split mt7663s_tx_update_sched in mt7663s_tx_{pick,upda=
te}_quota
      mt76: mt7663s: introduce __mt7663s_xmit_queue routine
      mt76: move pad estimation out of mt76_skb_adjust_pad
      mt76: mt7663s: fix possible quota leak in mt7663s_refill_sched_quota
      mt76: mt7663s: introduce sdio tx aggregation
      mt76: mt7663: check isr read return value in mt7663s_rx_work
      mt76: mt7615: unlock dfs bands
      mt76: mt7915: fix possible memory leak in mt7915_mcu_add_beacon
      mt76: mt7663s: remove max_tx_fragments limitation
      bpf, cpumap: Remove rcpu pointer from cpu_map_build_skb signature
      net: mvneta: try to use in-irq pp cache in mvneta_txq_bufs_free
      net: mvneta: avoid possible cache misses in mvneta_rx_swbm

Louis Peens (2):
      nfp: flower: check that we don't exceed the FW key size
      nfp: flower: add support to offload QinQ match

Luca Coelho (25):
      iwlwifi: dbg: remove IWL_FW_INI_TIME_POINT_WDG_TIMEOUT
      iwlwifi: don't export acpi functions unnecessarily
      iwlwifi: remove iwl_validate_sar_geo_profile() export
      iwlwifi: acpi: remove dummy definition of iwl_sar_set_profile()
      iwlwifi: add a common struct for all iwl_tx_power_cmd versions
      iwlwifi: acpi: prepare SAR profile selection code for multiple sizes
      iwlwifi: support REDUCE_TX_POWER_CMD version 6
      iwlwifi: acpi: rename geo structs to contain versioning
      iwlwifi: support version 3 of GEO_TX_POWER_LIMIT
      iwlwifi: mvm: remove redundant log in iwl_mvm_tvqm_enable_txq()
      iwlwifi: support version 5 of the alive notification
      iwlwifi: bump FW API to 57 for AX devices
      iwlwifi: mvm: read and parse SKU ID if available
      iwlwifi: update prph scratch structure to include PNVM data
      iwlwifi: mvm: ring the doorbell and wait for PNVM load completion
      iwlwifi: mvm: don't send RFH_QUEUE_CONFIG_CMD with no queues
      iwlwifi: pcie: fix 0x271B and 0x271C trans cfg struct
      iwlwifi: pcie: fix xtal latency for 9560 devices
      iwlwifi: pcie: fix the xtal latency value for a few qu devices
      iwlwifi: move PNVM implementation to common code
      iwlwifi: add trans op to set PNVM
      iwlwifi: pcie: implement set_pnvm op
      iwlwifi: read and parse PNVM file
      iwlwifi: bump FW API to 59 for AX devices
      Revert "iwlwifi: remove wide_cmd_header field"

Lucas Stach (1):
      can: m_can_platform: don't call m_can_class_suspend in runtime suspend

Luigi Rizzo (1):
      bpf, libbpf: Use valid btf in bpf_program__set_attach_target

Luiz Augusto von Dentz (4):
      Bluetooth: A2MP: Fix not initializing all members
      Bluetooth: L2CAP: Fix calling sk_filter on non-socket based channel
      Bluetooth: Disable High Speed by default
      Bluetooth: MGMT: Fix not checking if BT_HS is enabled

Lukas Bulwahn (2):
      MAINTAINERS: repair reference in LYNX PCS MODULE
      MAINTAINERS: adjust to mcp251xfd file renaming

Luke Hsiao (2):
      io_uring: allow tcp ancillary data for __sys_recvmsg_sock()
      io_uring: ignore POLLIN for recvmsg on MSG_ERRQUEUE

Luo Jiaxing (3):
      net: smc91x: Remove set but not used variable 'status' in smc_phy_con=
figure()
      net: stmmac: set get_rx_header_len() as void for it didn't have any e=
rror code to return
      net: ethernet: mlx4: Avoid assigning a value to ring_cons but not use=
d it anymore in mlx4_en_xmit()

Luo bin (6):
      hinic: add support to query sq info
      hinic: add support to query rq info
      hinic: add support to query function table
      hinic: add vxlan segmentation and cs offload support
      hinic: modify irq name
      hinic: improve the comments of function header

Maciej Fijalkowski (9):
      bpf, x64: use %rcx instead of %rax for tail call retpolines
      bpf: propagate poke descriptors to subprograms
      bpf: rename poke descriptor's 'ip' member to 'tailcall_target'
      bpf: Limit caller's stack depth 256 for subprogs with tailcalls
      bpf, x64: rework pro/epilogue and tailcall handling in JIT
      bpf: allow for tailcalls in BPF subprograms for x64 JIT
      selftests/bpf: Add tailcall_bpf2bpf tests
      bpf, x64: Drop "pop %rcx" instruction on BPF JIT epilogue
      bpf: x64: Do not emit sub/add 0, %rsp when !stack_depth

Maciej =C5=BBenczykowski (3):
      net-tun: Add type safety to tun_xdp_to_ptr() and tun_ptr_to_xdp()
      net-tun: Eliminate two tun/xdp related function calls from vhost-net
      net-veth: Add type safety to veth_xdp_to_ptr() and veth_ptr_to_xdp()

Magnus Karlsson (25):
      xsk: i40e: ice: ixgbe: mlx5: Pass buffer pool to driver instead of um=
em
      xsk: i40e: ice: ixgbe: mlx5: Rename xsk zero-copy driver interfaces
      xsk: Create and free buffer pool independently from umem
      xsk: Move fill and completion rings to buffer pool
      xsk: Move queue_id, dev and need_wakeup to buffer pool
      xsk: Move xsk_tx_list and its lock to buffer pool
      xsk: Move addrs from buffer pool to umem
      xsk: Enable sharing of dma mappings
      xsk: Rearrange internal structs for better performance
      xsk: i40e: ice: ixgbe: mlx5: Test for dma_need_sync earlier for bette=
r performance
      xsk: Add shared umem support between queue ids
      xsk: Add shared umem support between devices
      libbpf: Support shared umems between queues and devices
      xsk: Documentation for XDP_SHARED_UMEM between queues and netdevs
      samples/bpf: Optimize l2fwd performance in xdpsock
      xsk: Fix possible segfault in xsk umem diagnostics
      xsk: Fix possible segfault at xskmap entry insertion
      xsk: Fix use-after-free in failed shared_umem bind
      samples/bpf: Fix one packet sending in xdpsock
      samples/bpf: Fix possible deadlock in xdpsock
      samples/bpf: Add quiet option to xdpsock
      xsk: Fix refcount warning in xp_dma_map
      xsk: Fix possible crash in socket_release when out-of-memory
      libbpf: Fix compatibility problem in xsk_socket__create
      xsk: Introduce padding between ring pointers

Mahesh Bandewar (2):
      net: add option to not create fall-back tunnels in root-ns as well
      net: fix build without CONFIG_SYSCTL definition

Manivannan Sadhasivam (1):
      MAINTAINERS: Add entry for Microchip MCP25XXFD SPI-CAN network driver

Manjunath Patil (1):
      net/rds: suppress page allocation failure error in recv buffer refill

Maor Dickman (1):
      net/mlx5e: Add IPv6 traffic class (DSCP) header rewrite support

Marc Kleine-Budde (33):
      can: include: fix spelling mistakes
      can: net: fix spelling mistakes
      can: drivers: fix spelling mistakes
      can: raw: fix indention
      can: dev: can_put_echo_skb(): print number of echo_skb that is occupi=
ed
      can: dev: can_put_echo_skb(): propagate error in case of errors
      can: dev: can_change_state(): print human readable state change messa=
ges
      can: dev: can_bus_off(): print scheduling of restart if activated
      can: mscan: mark expected switch fall-through
      can: spi: Kconfig: remove unneeded dependencies form Kconfig symbols
      dt-bindings: can: mcp251x: change example interrupt type to IRQ_TYPE_=
LEVEL_LOW
      dt-bindings: can: mcp251x: document GPIO support
      can: mcp251x: sort include files alphabetically
      can: rx-offload: can_rx_offload_add_manual(): add new initialization =
function
      can: mcp25xxfd: add regmap infrastructure
      can: mcp25xxfd: add driver for Microchip MCP25xxFD SPI CAN
      can: flexcan: sort include files alphabetically
      can: flexcan: flexcan_exit_stop_mode(): remove stray empty line
      can: flexcan: more register names
      can: flexcan: struct flexcan_regs: document registers not affected by=
 soft reset
      can: flexcan: quirks: get rid of long lines
      can: flexcan: flexcan_probe(): make regulator xceiver optional
      can: flexcan: flexcan_set_bittiming(): move setup of CAN-2.0 bitiming=
 into separate function
      can: mcp25xxfd: mcp25xxfd_irq(): add missing initialization of variab=
le set_normal mode
      can: mcp251xfd: rename driver files and subdir to mcp251xfd
      can: mcp251xfd: rename all user facing strings to mcp251xfd
      can: mcp251xfd: rename all remaining occurrence to mcp251xfd
      can: af_can: can_rcv_list_find(): fix kernel doc after variable renam=
ing
      can: softing: softing_card_shutdown(): add  braces around empty body =
in an 'if' statement
      can: c_can: reg_map_{c,d}_can: mark as __maybe_unused
      dt-bindings: can: flexcan: remove ack_grp and ack_bit from fsl,stop-m=
ode
      can: flexcan: remove ack_grp and ack_bit handling from driver
      net: j1939: j1939_session_fresh_new(): fix missing initialization of =
skbcnt

Marco Felsch (5):
      net: phy: smsc: skip ENERGYON interrupt if disabled
      net: phy: smsc: simplify config_init callback
      dt-bindings: net: phy: smsc: document reference clock
      net: phy: smsc: LAN8710/20: add phy refclk in support
      net: phy: smsc: LAN8710/20: remove PHY_RST_AFTER_CLK_EN flag

Marek Vasut (2):
      net: fec: Fix PHY init after phy_reset_after_clk_enable()
      net: fec: Fix phy_device lookup for phy_reset_after_clk_enable()

Markus Theil (2):
      cfg80211: add helper fn for single rule channels
      cfg80211: add helper fn for adjacent rule channels

Martin KaFai Lau (32):
      tcp: Use a struct to represent a saved_syn
      tcp: bpf: Add TCP_BPF_DELACK_MAX setsockopt
      tcp: bpf: Add TCP_BPF_RTO_MIN for bpf_setsockopt
      tcp: Add saw_unknown to struct tcp_options_received
      bpf: tcp: Add bpf_skops_established()
      bpf: tcp: Add bpf_skops_parse_hdr()
      bpf: tcp: Add bpf_skops_hdr_opt_len() and bpf_skops_write_hdr_opt()
      bpf: sock_ops: Change some members of sock_ops_kern from u32 to u8
      bpf: tcp: Allow bpf prog to write and parse TCP header option
      bpf: selftests: Add fastopen_connect to network_helpers
      bpf: selftests: Tcp header options
      tcp: bpf: Optionally store mac header in TCP_SAVE_SYN
      bpf: Add map_meta_equal map ops
      bpf: Relax max_entries check for most of the inner map types
      bpf: selftests: Add test for different inner map size
      bpf: Use hlist_add_head_rcu when linking to local_storage
      bpf: Move the PTR_TO_BTF_ID check to check_reg_type()
      bpf: Enable bpf_skc_to_* sock casting helper to networking prog type
      bpf: Change bpf_sk_release and bpf_sk_*cgroup_id to accept ARG_PTR_TO=
_BTF_ID_SOCK_COMMON
      bpf: Change bpf_sk_storage_*() to accept ARG_PTR_TO_BTF_ID_SOCK_COMMON
      bpf: Change bpf_tcp_*_syncookie to accept ARG_PTR_TO_BTF_ID_SOCK_COMM=
ON
      bpf: Change bpf_sk_assign to accept ARG_PTR_TO_BTF_ID_SOCK_COMMON
      bpf: selftest: Add ref_tracking verifier test for bpf_skc casting
      bpf: selftest: Move sock_fields test into test_progs
      bpf: selftest: Adapt sock_fields test to use skel and global variables
      bpf: selftest: Use network_helpers in the sock_fields test
      bpf: selftest: Use bpf_skc_to_tcp_sock() in the sock_fields test
      bpf: selftest: Remove enum tcp_ca_state from bpf_tcp_helpers.h
      bpf: selftest: Add test_btf_skc_cls_ingress
      bpf: tcp: Do not limit cb_flags when creating child sk from listen sk
      bpf: selftest: Ensure the child sk inherited all bpf_sock_ops_cb_flags
      bpf, selftest: Fix flaky tcp_hdr_options test when adding addr to lo

Masahiro Yamada (1):
      can: remove "WITH Linux-syscall-note" from SPDX tag of C files

Masashi Honma (1):
      ath9k_htc: Use appropriate rs_datalen type

Mathieu Desnoyers (2):
      ipv4/icmp: l3mdev: Perform icmp error route lookup on source device r=
outing table (v2)
      ipv6/icmp: l3mdev: Perform icmp error route lookup on source device r=
outing table (v2)

Matthieu Baerts (3):
      selftests: mptcp: interpret \n as a new line
      mptcp: ADD_ADDRs with echo bit are smaller
      selftests: mptcp: interpret \n as a new line

Mauro Carvalho Chehab (2):
      net: fix a new kernel-doc warning at dev.c
      docs: net: 80211: reduce docs build time

Maxim Kochetkov (1):
      dpaa_eth: enable NETIF_MSG_HW by default

Maxim Mikityanskiy (12):
      net/mlx5e: Refactor inline header size calculation in the TX path
      net/mlx5e: Use struct assignment to initialize mlx5e_tx_wqe_info
      net/mlx5e: Move mlx5e_tx_wqe_inline_mode to en_tx.c
      net/mlx5e: Refactor xmit functions
      net/mlx5e: Small improvements for XDP TX MPWQE logic
      net/mlx5e: Unify constants for WQE_EMPTY_DS_COUNT
      net/mlx5e: Move the TLS resync check out of the function
      net/mlx5e: Support multiple SKBs in a TX WQE
      net/mlx5e: Generalize TX MPWQE checks for full session
      net/mlx5e: Rename xmit-related structs to generalize them
      net/mlx5e: Move TX code into functions to be used by MPWQE
      net/mlx5e: Enhanced TX MPWQE for SKBs

Miao-chen Chou (1):
      Bluetooth: Update Adv monitor count upon removal

Miaohe Lin (17):
      net: tipc: Convert to use the preferred fallthrough macro
      net: eliminate meaningless memcpy to data in pskb_carve_inside_nonlin=
ear()
      net: Stop warning about SO_BSDCOMPAT usage
      net: dccp: Convert to use the preferred fallthrough macro
      net: Avoid access icmp_err_convert when icmp code is ICMP_FRAG_NEEDED
      net: Use helper macro RT_TOS() in __icmp_send()
      net: gain ipv4 mtu when mtu is not locked
      netlink: remove duplicated nla_need_padding_for_64bit() check
      net: Set ping saddr after we successfully get the ping port
      net: Avoid unnecessary inet_addr_type() call when addr is INADDR_ANY
      net: Remove duplicated midx check against 0
      net: clean up codestyle for net/ipv4
      net: wireless: Convert to use the preferred fallthrough macro
      net: Use helper macro IP_MAX_MTU in __ip_append_data()
      net: clean up codestyle
      net: ipv6: remove unused arg exact_dif in compute_score
      net: ipv4: remove unused arg exact_dif in compute_score

Michael Chan (17):
      bnxt_en: Update firmware interface spec to 1.10.1.65.
      bnxt_en: Handle ethernet link being disabled by firmware.
      bnxt_en: Report FEC settings to ethtool.
      bnxt_en: Report Active FEC encoding during link up.
      bnxt_en: Implement ethtool set_fec_param() method.
      bnxt_en: Improve preset max value for ethtool -l.
      bnxt_en: Log FW health status info, if reset is aborted.
      bnxt_en: Refactor bnxt_free_rx_skbs().
      bnxt_en: Refactor bnxt_init_one_rx_ring().
      bnxt_en: Implement RX ring reset in response to buffer errors.
      bnxt_en: Add a software counter for RX ring reset.
      bnxt_en: Reduce unnecessary message log during RX errors.
      bnxt_en: Eliminate unnecessary RX resets.
      bnxt_en: Set driver default message level.
      bnxt_en: Simplify bnxt_async_event_process().
      bnxt_en: Log event_data1 and event_data2 when handling RESET_NOTIFY e=
vent.
      bnxt_en: Log unknown link speed appropriately.

Michael Jeanson (1):
      selftests: Add VRF route leaking tests

Michael Walle (1):
      dt-bindings: can: flexcan: list supported processors

Michael Zhou (1):
      netfilter: ip6t_NPT: rewrite addresses in ICMPv6 original packet

Miles Hu (1):
      nl80211: add support for setting fixed HE rate/gi/ltf

Mordechay Goodstein (24):
      iwlwifi: sta: defer ADDBA transmit in case reclaimed SN !=3D next SN
      iwlwifi: msix: limit max RX queues for 9000 family
      iwlwifi: wowlan: adapt to wowlan status API version 10
      iwlwifi: fw: move assert descriptor parser to common code
      iwlwifi: iwl-trans: move all txcmd init to trans alloc
      iwlwifi: move bc_pool to a common trans header
      iwlwifi: iwl-trans: move tfd to trans layer
      iwlwifi: move bc_table_dword to a common trans header
      iwlwifi: dbg: add dumping special device memory
      iwl-trans: move dev_cmd_offs, page_offs to a common trans header
      iwlwifi: mvm: remove redundant support_umac_log field
      iwlwifi: rs: set RTS protection for all non legacy rates
      iwlwifi: acpi: in non acpi compilations remove iwl_sar_geo_init
      iwlwifi: fw: add default value for iwl_fw_lookup_cmd_ver
      iwlwifi: remove wide_cmd_header field
      iwlwifi: move all bus-independent TX functions to common code
      iwlwifi: dbg: remove no filter condition
      iwlwifi: dbg: run init_cfg function once per driver load
      iwlwifi: phy-ctxt: add new API VER 3 for phy context cmd
      iwlwifi: pcie: make iwl_pcie_txq_update_byte_cnt_tbl bus independent
      iwlwifi: dbg: add debug host notification (DHN) time point
      iwlwifi: yoyo: add support for internal buffer allocation in D3
      iwlwifi: stats: add new api fields for statistics cmd/ntfy
      iwlwifi: rs: align to new TLC config command API

Moshe Shemesh (16):
      devlink: Change devlink_reload_supported() param type
      devlink: Add reload action option to devlink reload command
      devlink: Add devlink reload limit option
      devlink: Add reload stats
      devlink: Add remote reload stats
      net/mlx5: Add functions to set/query MFRL register
      net/mlx5: Set cap for pci sync for fw update event
      net/mlx5: Handle sync reset request event
      net/mlx5: Handle sync reset now event
      net/mlx5: Handle sync reset abort event
      net/mlx5: Add support for devlink reload action fw activate
      devlink: Add enable_remote_dev_reset generic parameter
      net/mlx5: Add devlink param enable_remote_dev_reset support
      net/mlx5: Add support for fw live patch event
      net/mlx5: Add support for devlink reload limit no reset
      devlink: Add Documentation/networking/devlink/devlink-reload.rst

Moshe Tal (1):
      net/mlx5: Fix uninitialized variable warning

Muchun Song (1):
      bpf: Fix potential call bpf_link_free() in atomic context

Naftali Goldstein (2):
      iwlwifi: mvm: process ba-notifications also when sta rcu is invalid
      iwlwifi: fix sar geo table initialization

Naoki Hayama (1):
      net: tlan: Fix typo abitrary

Nathan Chancellor (1):
      mwifiex: Remove unnecessary braces from HostCmd_SET_SEQ_NO_BSS_INFO

Nathan Errera (6):
      iwlwifi: mvm: support new KEK KCK api
      iwlwifi: mvm: support more GTK rekeying algorithms
      iwlwifi: mvm: get number of stations from TLV
      iwlwifi: mvm: prepare roc_done_wk to work sync
      iwlwifi: mvm: add a get lmac id function
      iwlwifi: mvm: support ADD_STA_CMD_API_S ver 12

Neal Cardwell (5):
      tcp: Only init congestion control if not initialized already
      tcp: Simplify EBPF TCP_CONGESTION to always init CC
      tcp: simplify tcp_set_congestion_control(): Always reinitialize
      tcp: simplify _bpf_setsockopt(): Remove flags argument
      tcp: Simplify tcp_set_congestion_control() load=3Dfalse case

Nicolas Dichtel (3):
      gtp: add notification mechanism
      gtp: remove useless rcu_read_lock()
      gtp: relax alloc constraint when adding a pdp

Nikita V. Shirokov (1):
      bpf: Add tcp_notsent_lowat bpf setsockopt

Nikolay Aleksandrov (34):
      net: bridge: mdb: arrange internal structs so fast-path fields are cl=
ose
      net: bridge: mcast: factor out port group del
      net: bridge: mcast: add support for group source list
      net: bridge: mcast: add support for src list and filter mode dumping
      net: bridge: mcast: add support for group-and-source specific queries
      net: bridge: mcast: add support for group query retransmit
      net: bridge: mdb: push notifications in __br_mdb_add/del
      net: bridge: mdb: use mdb and port entries in notifications
      net: bridge: mcast: delete expired port groups without srcs
      net: bridge: mcast: support for IGMPv3/MLDv2 ALLOW_NEW_SOURCES report
      net: bridge: mcast: support for IGMPV3/MLDv2 MODE_IS_INCLUDE/EXCLUDE =
report
      net: bridge: mcast: support for IGMPV3/MLDv2 CHANGE_TO_INCLUDE/EXCLUD=
E report
      net: bridge: mcast: support for IGMPV3/MLDv2 BLOCK_OLD_SOURCES report
      net: bridge: mcast: improve IGMPv3/MLDv2 query processing
      net: bridge: mcast: destroy all entries via gc
      net: bridge: mcast: fix unused br var when lockdep isn't defined
      net: bridge: mcast: don't ignore return value of __grp_src_toex_excl
      net: bridge: mdb: use extack in br_mdb_parse()
      net: bridge: mdb: move all port and bridge checks to br_mdb_add
      net: bridge: mdb: use extack in br_mdb_add() and br_mdb_add_group()
      net: bridge: add src field to br_ip
      net: bridge: mcast: use br_ip's src for src groups and querier address
      net: bridge: mcast: rename br_ip's u member to dst
      net: bridge: mdb: add support to extend add/del commands
      net: bridge: mdb: add support for add/del/dump of entries with source
      net: bridge: mcast: when igmpv3/mldv2 are enabled lookup (S,G) first,=
 then (*,G)
      net: bridge: mcast: add rt_protocol field to the port group struct
      net: bridge: mcast: add sg_port rhashtable
      net: bridge: mcast: install S,G entries automatically based on reports
      net: bridge: mcast: handle port group filter modes
      net: bridge: mcast: add support for blocked port groups
      net: bridge: mcast: handle host state
      net: bridge: mcast: when forwarding handle filter mode and blocked fl=
ag
      net: bridge: mcast: remove only S,G port groups from sg_port hash

Ofer Levi (1):
      net/mlx5e: Add CQE compression support for multi-strides packets

Oleksij Rempel (4):
      net: ag71xx: add ethtool support
      net: ag71xx: add flow control support
      dt-binding: can: mcp25xxfd: document device tree bindings
      dt-binding: can: mcp25xxfd: documentation fixes

Oliver Hartkopp (3):
      can: add ISO 15765-2:2016 transport protocol
      can: isotp: implement cleanups / improvements from review
      can: remove obsolete version strings

Ondrej Zary (2):
      cx82310_eth: re-enable ethernet mode after router reboot
      cx82310_eth: use netdev_err instead of dev_err

Ong Boon Leong (2):
      net: stmmac: add ethtool support for get/set channels
      net: stmmac: use netif_tx_start|stop_all_queues() function

Or Cohen (1):
      net/af_unix: Remove unused old_pid variable

Oz Shlomo (1):
      net/mlx5e: CT: Use the same counter for both directions

Pablo Neira Ayuso (8):
      netfilter: add nf_static_key_{inc,dec}
      netfilter: add nf_ingress_hook() helper function
      netfilter: add inet ingress support
      netfilter: nf_tables: add inet ingress support
      netfilter: flowtable: reduce calls to pskb_may_pull()
      netfilter: nftables: extend error reporting for chain updates
      netfilter: nf_log: missing vlan offload tag and proto
      netfilter: restore NF_INET_NUMHOOKS

Paolo Abeni (20):
      mptcp: rethink 'is writable' conditional
      mptcp: set data_ready status bit in subflow_check_data_avail()
      mptcp: trigger msk processing even for OoO data
      mptcp: basic sndbuf autotuning
      mptcp: introduce and use mptcp_try_coalesce()
      mptcp: move ooo skbs into msk out of order queue.
      mptcp: cleanup mptcp_subflow_discard_data()
      mptcp: add OoO related mibs
      mptcp: move address attribute into mptcp_addr_info
      mptcp: allow creating non-backup subflows
      mptcp: allow picking different xmit subflows
      mptcp: call tcp_cleanup_rbuf on subflows
      mptcp: simult flow self-tests
      net: try to avoid unneeded backlog flush
      mptcp: fix integer overflow in mptcp_subflow_discard_data()
      net-sysfs: add backlog len and CPU id to softnet data
      mptcp: don't skip needed ack
      mptcp: fix infinite loop on recvmsg()/worker() race.
      mptcp: fix fallback for MP_JOIN subflows
      mptcp: subflows garbage collection

Parav Pandit (14):
      devlink: Fix per port reporter fields initialization
      devlink: Protect devlink port list traversal
      net/mlx5: E-switch, Read controller number from device
      devlink: Add comment block for missing port attributes
      devlink: Move structure comments outside of structure
      devlink: Introduce external controller flag
      devlink: Introduce controller number
      devlink: Use controller while building phys_port_name
      devlink: Enhance policy to validate eswitch mode value
      devlink: Enhance policy to validate port type input value
      net/mlx5: E-switch, Add helper to check egress ACL need
      net/mlx5: E-switch, Use helper function to load unload representor
      net/mlx5: E-switch, Move devlink eswitch ports closer to eswitch
      net/mlx5: Use dma device access helper

Patricio Noyola (1):
      gve: Use link status register to report link status

Paul Barker (6):
      net: dsa: b53: Use dev_{err,info} instead of pr_*
      net: dsa: b53: Print err message on SW_RST timeout
      net: dsa: microchip: Make switch detection more informative
      net: dsa: microchip: Improve phy mode message
      net: dsa: microchip: Disable RGMII in-band status on KSZ9893
      net: dsa: microchip: Implement recommended reset timing

Paul Davey (3):
      ipmr: Add route table ID to netlink cache reports
      ipmr: Add high byte of VIF ID to igmpmsg
      ipmr: Use full VIF ID in netlink cache reports

Paul E. McKenney (7):
      rcu-tasks: Mark variables static
      rcu-tasks: Use more aggressive polling for RCU Tasks Trace
      rcu-tasks: Selectively enable more RCU Tasks Trace IPIs
      rcu-tasks: Shorten per-grace-period sleep for RCU Tasks Trace
      rcu-tasks: Fix grace-period/unlock race in RCU Tasks Trace
      rcu-tasks: Fix low-probability task_struct leak
      rcu-tasks: Enclose task-list scan in rcu_read_lock()

Pavel Machek (1):
      ath9k: Fix typo in function name

Pavel Machek (CIP) (1):
      net/mlx5: remove unreachable return

Peilin Ye (2):
      ipvs: Fix uninit-value in do_ip_vs_set_ctl()
      Bluetooth: Fix memory leak in read_adv_mon_features()

Petr Machata (29):
      mlxsw: spectrum_ethtool: Extract a helper to get Ethernet attributes
      mlxsw: spectrum_ethtool: Introduce ptys_max_speed callback
      mlxsw: spectrum: Keep maximum MTU around
      mlxsw: spectrum: Keep maximum speed around
      mlxsw: spectrum_span: Derive SBIB from maximum port speed & MTU
      mlxsw: spectrum_buffers: Add struct mlxsw_sp_hdroom
      mlxsw: spectrum: Unify delay handling between PFC and pause
      mlxsw: spectrum: Track MTU in struct mlxsw_sp_hdroom
      mlxsw: spectrum: Track priorities in struct mlxsw_sp_hdroom
      mlxsw: spectrum: Track lossiness in struct mlxsw_sp_hdroom
      mlxsw: spectrum: Track buffer sizes in struct mlxsw_sp_hdroom
      mlxsw: spectrum: Split headroom autoresize out of buffer configuration
      mlxsw: spectrum_dcb: Convert ETS handler fully to mlxsw_sp_hdroom_con=
figure()
      mlxsw: spectrum_dcb: Convert mlxsw_sp_port_pg_prio_map() to hdroom co=
de
      mlxsw: spectrum: Move here the three-step headroom configuration from=
 DCB
      mlxsw: spectrum_buffers: Move here the new headroom code
      mlxsw: spectrum_buffers: Inline mlxsw_sp_sb_max_headroom_cells()
      mlxsw: spectrum_buffers: Convert mlxsw_sp_port_headroom_init()
      mlxsw: spectrum_buffers: Introduce shared buffer ops
      mlxsw: spectrum_buffers: Manage internal buffer in the hdroom code
      mlxsw: spectrum_buffers: Support two headroom modes
      mlxsw: spectrum_dcb: Implement dcbnl_setbuffer / getbuffer
      mlxsw: spectrum_qdisc: Disable port buffer autoresize with qdiscs
      selftests: forwarding: devlink_lib: Split devlink_..._set() into save=
 & set
      selftests: forwarding: devlink_lib: Add devlink_cell_size_get()
      selftests: forwarding: devlink_lib: Support port-less topologies
      selftests: mlxsw: qos_lib: Add a wrapper for running mlnx_qos
      selftests: mlxsw: Add headroom handling test
      selftests: mlxsw: Add a PFC test

Phil Sutter (2):
      netfilter: nf_tables: Enable fast nft_cmp for inverted matches
      netfilter: nf_tables: Implement fast bitwise expression

Po-Hsu Lin (1):
      selftests/net: improve descriptions for XFAIL cases in psock_snd.sh

Pujin Shi (2):
      net: smc: fix missing brace warning for old compilers
      net: smc: fix missing brace warning for old compilers

Qinglang Miao (13):
      net: hsr: Convert to DEFINE_SHOW_ATTRIBUTE
      dpaa2-eth: Convert to DEFINE_SHOW_ATTRIBUTE
      net: qlcnic: simplify the return expression of qlcnic_83xx_shutdown
      net: hns3: simplify the return expression of hclgevf_client_start()
      mlxsw: spectrum_router: simplify the return expression of __mlxsw_sp_=
router_init()
      ice: simplify the return expression of ice_finalize_update()
      enetc: simplify the return expression of enetc_vf_set_mac_addr()
      connector: simplify the return expression of cn_add_callback()
      chelsio: simplify the return expression of t3_ael2020_phy_prep()
      mt7601u: Convert to DEFINE_SHOW_ATTRIBUTE
      net/mlx5: simplify the return expression of mlx5_ec_init()
      zd1201: simplify the return expression of zd1201_set_maxassoc()
      mt76: Convert to DEFINE_SHOW_ATTRIBUTE

Quentin Monnet (11):
      tools: bpftool: Fix formatting in bpftool-link documentation
      bpf: Fix formatting in documentation for BPF helpers
      tools, bpf: Synchronise BPF UAPI header with tools
      tools: bpftool: Log info-level messages when building bpftool man pag=
es
      selftests, bpftool: Add bpftool (and eBPF helpers) documentation build
      tools: bpftool: Print optional built-in features along with version
      tools: bpftool: Include common options from separate file
      tools: bpftool: Clean up function to dump map entry
      tools: bpftool: Keep errors for map-of-map dumps if distinct from ENO=
ENT
      tools: bpftool: Add "inner_map" to "bpftool map create" outer maps
      tools: bpftool: Automate generation for "SEE ALSO" sections in man pa=
ges

Raed Salem (1):
      net/mlx5e: IPsec: Add Connect-X IPsec Tx data path offload

Rahul Kundu (1):
      cxgb4: insert IPv6 filter rules in next free region

Rajkumar Manoharan (3):
      nl80211: fix OBSS PD min and max offset validation
      nl80211: extend support to config spatial reuse parameter set
      mac80211: copy configured beacon tx rate to driver

Raju Rangoju (1):
      cxgb4: add error handlers to LE intr_handler

Rakesh Pillai (5):
      ath10k: Register shutdown handler
      ath10k: Add interrupt summary based CE processing
      dt: bindings: Add new regulator as optional property for WCN3990
      ath10k: Add support for chain1 regulator supply voting
      ath10k: Use bdf calibration variant for snoc targets

Randy Dunlap (29):
      batman-adv: types.h: delete duplicated words
      net: sctp: associola.c: delete duplicated words
      net: sctp: auth.c: delete duplicated words
      net: sctp: bind_addr.c: delete duplicated word
      net: sctp: chunk.c: delete duplicated word
      net: sctp: protocol.c: delete duplicated words + punctuation
      net: sctp: sm_make_chunk.c: delete duplicated words + fix typo
      net: sctp: ulpqueue.c: delete duplicated word
      net: ipv4: delete repeated words
      net: netlink: delete repeated words
      net: dccp: delete repeated words
      net: mac80211: agg-rx.c: fix duplicated words
      net: mac80211: mesh.h: delete duplicated word
      net: wireless: delete duplicated word + fix grammar
      net: wireless: reg.c: delete duplicated words + fix punctuation
      net: wireless: scan.c: delete or fix duplicated words
      net: wireless: sme.c: delete duplicated word
      net: wireless: wext_compat.c: delete duplicated word
      nfc: pn533/usb.c: fix spelling of "functions"
      net: ethernet/neterion/vxge: fix spelling of "functionality"
      net: core: delete duplicated words
      net: rds: delete duplicated words
      net: ipv6: delete duplicated words
      net: bluetooth: delete duplicated words
      net: tipc: delete duplicated words
      net: atm: delete duplicated words
      net: bridge: delete duplicated words
      kernel/bpf/verifier: Fix build when NET is not enabled
      net/tls: remove a duplicate function prototype

Rikard Falkeborn (11):
      net: ethernet: qualcomm: constify qca_serdev_ops
      net: ethernet: ravb: constify bb_ops
      net: renesas: sh_eth: constify bb_ops
      net: phy: at803x: constify static regulator_ops
      net: phy: mscc: macsec: constify vsc8584_macsec_ops
      net: ath11k: constify ath11k_thermal_ops
      octeontx2-af: Constify npc_kpu_profile_{action,cam}
      net: hns3: Constify static structs
      atm: atmtcp: Constify atmtcp_v_dev_ops
      mptcp: Constify mptcp_pm_ops
      net: openvswitch: Constify static struct genl_small_ops

Robert Marko (2):
      net: mdio-ipq4019: change defines to upper case
      net: mdio-ipq4019: add Clause 45 support

Rocky Liao (2):
      Bluetooth: btusb: Enable wide band speech support for BTUSB_QCA_ROME
      Bluetooth: btusb: Add Qualcomm Bluetooth SoC WCN6855 support

Roee Goldfiner (1):
      iwlwifi: add new card for MA family

Rohit Maheshwari (5):
      crypto/chcr: move nic TLS functionality to drivers/net
      ch_ktls: Issue if connection offload fails
      cxgb4: Avoid log flood
      cxgb4/ch_ktls: ktls stats are added at port level
      net/tls: sendfile fails with ktls offload

Rusaimi Amira Ruslan (2):
      net: stmmac: Add dwmac-intel-plat for GBE driver
      stmmac: intel: Adding ref clock 1us tic for LPI cntr

Russell King (15):
      net: phylink: avoid oops during initialisation
      net: mvpp2: tidy up ACPI hack
      net: mvpp2: convert to use mac_prepare()/mac_finish()
      net: mvpp2: ensure the port is forced down while changing modes
      net: mvpp2: move GMAC reset handling into mac_prepare()/mac_finish()
      net: mvpp2: convert to phylink pcs operations
      net: mvpp2: split xlg and gmac pcs
      net: mvpp2: restructure "link status" interrupt handling
      net: mvpp2: rename mis-named "link status" interrupt
      net: mvpp2: check first level interrupt status registers
      net: mvpp2: ptp: add TAI support
      net: mvpp2: ptp: add support for receive timestamping
      net: mvpp2: ptp: add support for transmit timestamping
      net: mvpp2: set SKBTX_IN_PROGRESS
      of: add of_mdio_find_device() api

Ryder Lee (3):
      mt76: mt7915: enable U-APSD on AP side
      mt76: mt7915: add Tx A-MSDU offloading support
      mt76: mt7615: fix VHT LDPC capability

Saeed Mahameed (1):
      net/mlx5e: TC: Remove unused parameter from mlx5_tc_ct_add_no_trk_mat=
ch()

Sagi Shahar (1):
      gve: Batch AQ commands for creating and destroying queues.

Sameeh Jubran (4):
      net: ena: ethtool: convert stat_offset to 64 bit resolution
      net: ena: ethtool: Add new device statistics
      net: ena: ethtool: add stats printing to XDP queues
      net: ena: xdp: add queue counters for xdp actions

Samuel Holland (2):
      Bluetooth: hci_h5: Remove ignored flag HCI_UART_RESET_ON_INIT
      Bluetooth: hci_uart: Cancel init work before unregistering

Sara Sharon (4):
      iwlwifi: mvm: add d3 prints
      iwlwifi: mvm: re-enable TX after channel switch
      iwlwifi: mvm: remove memset of kek_kck command
      iwlwifi: mvm: fix suspicious rcu usage warnings

Sasha Neftin (5):
      igc: Add new device ID's
      igc: Expose LPI counters
      igc: Remove reset disable flag
      igc: Clean up nvm_info structure
      e1000e: Add support for Meteor Lake

Satha Rao (1):
      octeontx2-af: fix Extended DSA and eDSA parsing

Sathish Narasimman (1):
      Bluetooth: Fix update of own_addr_type if ll_privacy supported

Sathishkumar Muruganandam (1):
      ath10k: fix VHT NSS calculation when STBC is enabled

Sean Wang (2):
      mt76: mt7663s: fix resume failure
      mt76: mt7663s: fix unable to handle kernel paging request

Sebastian Andrzej Siewior (28):
      net: Add netif_rx_any_context()
      net: caif: Use netif_rx_any_context()
      net: e100: Remove in_interrupt() usage and pointless GFP_ATOMIC alloc=
ation
      net: fec_mpc52xx: Replace in_interrupt() usage
      net: intel: Remove in_interrupt() warnings
      net: ionic: Replace in_interrupt() usage.
      net: ionic: Remove WARN_ON(in_interrupt()).
      net: mdiobus: Remove WARN_ON_ONCE(in_interrupt())
      net: sfc: Use GFP_KERNEL in efx_ef10_try_update_nic_stats()
      net: sunbmac: Replace in_interrupt() usage
      net: sun3lance: Remove redundant checks in interrupt handler
      net: vxge: Remove in_interrupt() conditionals
      net: zd1211rw: Remove ZD_ASSERT(in_interrupt())
      net: usb: kaweth: Replace kaweth_control() with usb_control_msg()
      net: usb: kaweth: Remove last user of kaweth_control()
      net: usb: net1080: Remove in_interrupt() comment
      net: wan/lmc: Remove lmc_trace()
      net: brcmfmac: Replace in_interrupt()
      net: brcmfmac: Convey allocation mode as argument
      net: ipw2x00,iwlegacy,iwlwifi: Remove in_interrupt() from debug macros
      net: iwlwifi: Remove in_interrupt() from tracing macro.
      net: hostap: Remove in_interrupt() usage
      net: mwifiex: Use netif_rx_any_context().
      net: libertas libertas_tf: Remove in_interrupt() from debug macro.
      net: libertas: Use netif_rx_any_context()
      net: rtlwifi: Remove void* casts related to delayed work
      net: rtlwifi: Remove in_interrupt() from debug macro
      net: rtlwifi: Replace in_interrupt() for context detection

Shannon Nelson (36):
      ionic: set MTU floor at ETH_MIN_MTU
      ionic: fix up a couple of debug strings
      ionic: use kcalloc for new arrays
      ionic: remove lif list concept
      ionic: rework and simplify handling of the queue stats block
      ionic: clean up unnecessary non-static functions
      ionic: reduce contiguous memory allocation requirement
      ionic: use index not pointer for queue tracking
      ionic: change mtu without full queue rebuild
      ionic: change the descriptor ring length without full reset
      ionic: change queue count with no reset
      ionic: pull reset_queues into tx_timeout handler
      ionic: clean up page handling code
      ionic: struct reorder for faster access
      ionic: clean up desc_info and cq_info structs
      ionic: clean adminq service routine
      ionic: remove unused variable
      ionic: clarify boolean precedence
      ionic: fix up debugfs after queue swap
      ionic: dynamic interrupt moderation
      ionic: add DIMLIB to Kconfig
      devlink: add timeout information to status_notify
      devlink: collect flash notify params into a struct
      netdevsim: devlink flash timeout message
      ionic: update the fw update api
      ionic: add devlink firmware update
      ionic: stop watchdog timer earlier on remove
      ionic: prevent early watchdog check
      ionic: contiguous memory for notifyq
      ionic: drain the work queue
      ionic: clear linkcheck bit on alloc fail
      ionic: check qcq ptr in ionic_qcq_disable
      ionic: disable all queue napi contexts on timeout
      ionic: refill lif identity after fw_up
      ionic: use lif ident for filter count
      ionic: add new bad firmware error code

Shaul Triebitz (3):
      iwlwifi: mvm: add PROTECTED_TWT firmware API
      iwlwifi: mvm: set PROTECTED_TWT in MAC data policy
      iwlwifi: mvm: set PROTECTED_TWT feature if supported by firmware

Shay Agroskin (7):
      net: ena: Change license into format to SPDX in all files
      net: ena: Change log message to netif/dev function
      net: ena: Capitalize all log strings and improve code readability
      net: ena: Remove redundant print of placement policy
      net: ena: Change RSS related macros and variables names
      net: ena: Fix all static chekers' warnings
      net: ena: update ena documentation

Shayne Chen (2):
      mt76: mt7615: register ext_phy if DBDC is detected
      mt76: mt7915: add offchannel condition in switch channel command

Simon Wunderlich (1):
      batman-adv: Start new development cycle

Soheil Hassas Yeganeh (2):
      tcp: return EPOLLOUT from tcp_poll only when notsent_bytes is half th=
e limit
      tcp: schedule EPOLLOUT after a partial sendmsg

Song Liu (8):
      bpf: Fix comment for helper bpf_current_task_under_cgroup()
      bpf: Enable BPF_PROG_TEST_RUN for raw_tracepoint
      libbpf: Support test run of raw tracepoint programs
      selftests/bpf: Add raw_tp_test_run
      bpf: fix raw_tp test run in preempt kernel
      bpf: Introduce BPF_F_PRESERVE_ELEMS for perf event array
      selftests/bpf: Add tests for BPF_F_PRESERVE_ELEMS
      bpf: Use raw_spin_trylock() for pcpu_freelist_push/pop in NMI

Song, Yoong Siang (1):
      net: stmmac: Add support to Ethtool get/set ring parameters

Sonny Sasaka (1):
      Bluetooth: Fix auto-creation of hci_conn at Conn Complete event

Srinivas Neeli (3):
      can: xilinx_can: Limit CANFD brp to 2
      can: xilinx_can: Check return value of set_reset_mode
      can: xilinx_can: Fix incorrect variable and initialize with a default=
 value

Stanislav Fomichev (3):
      selftests/bpf: Initialize duration in xdp_noinline.c
      selftests/bpf: Properly initialize linfo in sockmap_basic
      bpf: Deref map in BPF_PROG_BIND_MAP when it's already used

Stanislaw Kardach (2):
      octeontx2-af: fix LD CUSTOM LTYPE aliasing
      octeontx2-af: cleanup KPU config data

Steffen Klassert (1):
      Merge 'xfrm: Add compat layer'

Stephane Grosjean (2):
      can: pcan_usb: Document the commands sent to the device
      can: pcan_usb: add support of rxerr/txerr counters

Subbaraya Sundeep (2):
      octeontx2-af: Introduce tracepoints for mailbox
      octeontx2-pf: Add tracepoints for PF/VF mailbox

Sunil Goutham (1):
      octeontx2-pf: Add UDP segmentation offload support

Sven Auhagen (1):
      igb: add XDP support

Sven Eckelmann (3):
      batman-adv: Drop unused function batadv_hardif_remove_interfaces()
      batman-adv: Drop repeated words in comments
      batman-adv: Migrate to linux/prandom.h

Taehee Yoo (2):
      ipvlan: advertise link netns via netlink
      net: remove NETDEV_HW_ADDR_T_SLAVE

Tamizh Chelvam (5):
      ath10k: Add wmi command support for station specific TID config
      ath10k: Move rate mask validation function up in the file
      ath10k: Add new api to support TID specific configuration
      ath10k: Add new api to support reset TID config
      ath11k: Add peer max mpdu parameter in peer assoc command

Tam=C3=A1s Sz=C5=B1cs (1):
      Bluetooth: btmrvl: eliminate duplicates introducing btmrvl_reg_89xx

Tariq Toukan (3):
      net: Take common prefetch code structure into a function
      net/mlx5e: RX, Add a prefetch command for small L1_CACHE_BYTES
      net/mlx4_en: RX, Add a prefetch command for small L1_CACHE_BYTES

Tetsuo Handa (1):
      mwifiex: don't call del_timer_sync() on uninitialized timer

Thomas Falcon (2):
      ibmvnic: Fix use-after-free of VNIC login response buffer
      ibmvnic: Harden device Command Response Queue handshake

Thomas Gleixner (7):
      net: enic: Cure the enic api locking trainwreck
      net: caif: Remove unused caif SPI driver
      net: atheros: Remove WARN_ON(in_interrupt())
      net: cxgb3: Cleanup in_interrupt() usage
      net: cxbg4: Remove pointless in_interrupt() check
      net: natsemi: Replace in_interrupt() usage.
      net: brcmfmac: Convey execution context via argument to brcmf_netif_r=
x()

Thomas Kopp (5):
      MAINTAINERS: Add reviewer entry for microchip mcp25xxfd SPI-CAN netwo=
rk driver
      can: mcp25xxfd: mcp25xxfd_handle_eccif(): add ECC related errata and =
update log messages
      can: mcp25xxfd: mcp25xxfd_probe(): add SPI clk limit related errata i=
nformation
      dt-binding: can: mcp251xfd: narrow down wildcards in device tree bind=
ings to "microchip,mcp251xfd"
      can: mcp25xxfd: narrow down wildcards in device tree bindings to "mic=
rochip,mcp251xfd"

Thomas Pedersen (26):
      ieee80211: redefine S1G bits with GENMASK
      nl80211: advertise supported channel width in S1G
      cfg80211: regulatory: handle S1G channels
      nl80211: correctly validate S1G beacon head
      nl80211: support setting S1G channels
      mac80211: get correct default channel width for S1G
      mac80211: s1g: choose scanning width based on frequency
      nl80211: support S1G capability overrides in assoc
      mac80211: support S1G STA capabilities
      cfg80211: convert S1G beacon to scan results
      cfg80211: parse S1G Operation element for BSS channel
      mac80211: convert S1G beacon to scan results
      cfg80211: handle Association Response from S1G STA
      mac80211: encode listen interval for S1G
      mac80211: don't calculate duration for S1G
      mac80211: handle S1G low rates
      mac80211: avoid rate init for S1G band
      mac80211: receive and process S1G beacons
      mac80211: support S1G association
      nl80211: include frequency offset in survey info
      mac80211_hwsim: write TSF timestamp correctly to S1G beacon
      mac80211_hwsim: indicate support for S1G
      mac80211: avoid processing non-S1G elements on S1G band
      mac80211: handle lack of sband->bitrates in rates
      mac80211: initialize last_rate for S1G STAs
      cfg80211: only allow S1G channels on S1G band

Tim Harvey (1):
      can: mcp251x: add support for half duplex controllers

Timo Schl=C3=BC=C3=9Fler (1):
      can: mcp251x: add GPIO support

Toke H=C3=B8iland-J=C3=B8rgensen (14):
      bpf: disallow attaching modify_return tracing functions to other BPF =
programs
      bpf: change logging calls from verbose() to bpf_log() and use log poi=
nter
      bpf: verifier: refactor check_attach_btf_id()
      selftests: Remove fmod_ret from test_overhead
      bpf/preload: Make sure Makefile cleans up after itself, and add .giti=
gnore
      selftests/bpf_iter: Don't fail test due to missing __builtin_btf_type=
_id
      selftests: Make sure all 'skel' variables are declared static
      bpf: Move prog->aux->linked_prog and trampoline into bpf_link on atta=
ch
      bpf: Support attaching freplace programs to multiple attach points
      bpf: Fix context type resolving for extension programs
      libbpf: Add support for freplace attachment in bpf_link_create
      selftests: Add test for multiple attachments of freplace program
      selftests: Add selftest for disallowing modify_return attachment to f=
replace
      bpf: Always return target ifindex in bpf_fib_lookup

Tom Parkin (17):
      l2tp: don't log data frames
      l2tp: remove noisy logging, use appropriate log levels
      l2tp: use standard API for warning log messages
      l2tp: add tracepoint infrastructure to core
      l2tp: add tracepoint definitions in trace.h
      l2tp: add tracepoints to l2tp_core.c
      l2tp: remove custom logging macros
      l2tp: remove tunnel and session debug flags field
      docs: networking: add tracepoint info to l2tp.rst
      l2tp: remove header length param from l2tp_xmit_skb
      l2tp: drop data_len argument from l2tp_xmit_core
      l2tp: drop net argument from l2tp_tunnel_create
      l2tp: capture more tx errors in data plane stats
      l2tp: make magic feather checks more useful
      l2tp: avoid duplicated code in l2tp_tunnel_closeall
      l2tp: fix up inconsistent rx/tx statistics
      l2tp: report rx cookie discards in netlink get

Tom Rix (6):
      brcmfmac: check ndev pointer
      rndis_wlan: tighten check of rndis_query_oid return
      ath11k: fix a double free and a memory leak
      net: sched: skip an unnecessay check
      mwifiex: remove function pointer check
      mwifiex: fix double free

Tonghao Zhang (4):
      net: openvswitch: improve the coding style
      net: openvswitch: refactor flow free function
      net: openvswitch: remove unused keep_flows
      virtio-net: ethtool configurable RXCSUM

Tova Mussai (1):
      nl80211/cfg80211: support 6 GHz scanning

Tuong Lien (4):
      tipc: optimize key switching time and logic
      tipc: introduce encryption master key
      tipc: add automatic session key exchange
      tipc: add automatic rekeying for encryption key

Tzu-En Huang (6):
      rtw88: fix compile warning: [-Wignored-qualifiers]
      rtw88: increse the size of rx buffer size
      rtw88: handle and recover when firmware crash
      rtw88: add dump firmware fifo support
      rtw88: add dump fw crash log
      rtw88: show current regulatory in tx power table

Udip Pant (4):
      bpf: verifier: Use target program's type for access verifications
      selftests/bpf: Add test for freplace program with write access
      selftests/bpf: Test for checking return code for the extended prog
      selftests/bpf: Test for map update access from within EXT programs

Ursula Braun (21):
      net/smc: reduce active tcp_listen workers
      net/smc: introduce better field names
      net/smc: dynamic allocation of CLC proposal buffer
      net/smc: common routine for CLC accept and confirm
      net/smc: improve server ISM device determination
      net/smc: reduce smc_listen_decline() calls
      net/smc: immediate freeing in smc_lgr_cleanup_early()
      net/smc: fix double kfree in smc_listen_work()
      net/smc: CLC header fields renaming
      net/smc: separate find device functions
      net/smc: split CLC confirm/accept data to be sent
      net/smc: prepare for more proposed ISM devices
      net/smc: introduce System Enterprise ID (SEID)
      net/smc: introduce CHID callback for ISM devices
      net/smc: introduce list of pnetids for Ethernet devices
      net/smc: determine proposed ISM devices
      net/smc: build and send V2 CLC proposal
      net/smc: determine accepted ISM devices
      net/smc: CLC accept / confirm V2
      net/smc: introduce CLC first contact extension
      net/smc: CLC decline - V2 enhancements

Vadym Kochan (6):
      net: marvell: prestera: Add driver for Prestera family ASIC devices
      net: marvell: prestera: Add PCI interface support
      net: marvell: prestera: Add basic devlink support
      net: marvell: prestera: Add ethtool interface support
      net: marvell: prestera: Add Switchdev driver implementation
      dt-bindings: marvell,prestera: Add description for device-tree bindin=
gs

Vaibhav Gupta (1):
      can: pch_can: use generic power management

Valentin Vidic (1):
      net: korina: fix kfree of rx/tx descriptor array

Vasily Averin (1):
      netfilter: ipset: enable memory accounting for ipset allocations

Vasily Gorbik (1):
      s390/ctcm: remove orphaned function declarations

Vasundhara Volam (6):
      bnxt_en: Update firmware interface spec to 1.10.1.68.
      bnxt_en: Return -EROFS to user space, if NVM writes are not permitted.
      bnxt_en: Enable online self tests for multi-host/NPAR mode.
      bnxt_en: Add bnxt_hwrm_nvm_get_dev_info() to query NVM info.
      bnxt_en: Refactor bnxt_dl_info_get().
      bnxt_en: Add stored FW version info to devlink info_get cb.

Venkata Lakshmi Narayana Gubba (2):
      Bluetooth: hci_serdev: Close UART port if NON_PERSISTENT_SETUP is set
      Bluetooth: hci_qca: Remove duplicate power off in proto close

Venkateswara Naralasetty (3):
      ath10k: fix retry packets update in station dump
      ath10k: provide survey info as accumulated data
      ath11k: add raw mode and software crypto support

Vidhya Vidhyaraman (1):
      octeontx2-af: Add IPv6 fields to default MKEX

Vinay Kumar Yadav (2):
      chelsio/chtls: separate chelsio tls driver from crypto driver
      crypto/chcr: Moving chelsio's inline ipsec functionality to /drivers/=
net

Vincent Mailhol (3):
      can: raw: add missing error queue support
      can: dev: fix type of get_can_dlc() and get_canfd_dlc() macros
      can: dev: add a helper function to calculate the duration of one bit

Vineetha G. Jaya Kumaran (1):
      dt-bindings: net: Add bindings for Intel Keem Bay

Vinicius Costa Gomes (4):
      igc: Remove references to SYSTIMR register
      igc: Save PTP time before a reset
      igc: Export a way to read the PTP timer
      igc: Reject schedules with a base_time in the future

Vishal Kulkarni (1):
      ethtool: allow flow-type ether without IP protocol field

Vladimir Oltean (75):
      net: dsa: change PHY error message again
      net: dsa: don't print non-fatal MTU error if not supported
      net: dsa: tag_8021q: include missing refcount.h
      net: dsa: tag_8021q: setup tagging via a single function call
      net: dsa: tag_8021q: add a context structure
      Revert "net: dsa: Add more convenient functions for installing port V=
LANs"
      __netif_receive_skb_core: don't untag vlan from skb on DSA master
      net: dsa: felix: use ocelot_field_{read,write} helpers consistently
      net: dsa: seville: don't write to MEM_ENA twice
      net: dsa: seville: first enable memories, then initialize them
      net: dsa: ocelot: document why reset procedure is different for felix=
/seville
      net: dsa: seville: remove unused defines for the mdio controller
      net: dsa: seville: reindent defines for MDIO controller
      net: dsa: felix: replace tabs with spaces
      net: dsa: seville: duplicate vsc9959_mdio_bus_free
      net: mscc: ocelot: make ocelot_init_timestamp take a const struct ptp=
_clock_info
      net: dsa: felix: move the PTP clock structure to felix_vsc9959.c
      net: dsa: seville: build as separate module
      net: dsa: deny enslaving 802.1Q upper to VLAN-aware bridge from PRECH=
ANGEUPPER
      net: dsa: rename dsa_slave_upper_vlan_check to something more suggest=
ive
      net: dsa: convert check for 802.1Q upper when bridged into PRECHANGEU=
PPER
      net: dsa: convert denying bridge VLAN with existing 8021q upper to PR=
ECHANGEUPPER
      net: dsa: refuse configuration in prepare phase of dsa_port_vlan_filt=
ering()
      net: dsa: allow 8021q uppers while the bridge has vlan_filtering=3D0
      net: dsa: install VLANs into the master's RX filter too
      net: dsa: tag_8021q: add VLANs to the master interface too
      net: dsa: tag_sja1105: add compatibility with hwaccel VLAN tags
      net: dsa: untag the bridge pvid from rx skbs
      net: mscc: ocelot: always pass skb clone to ocelot_port_add_txtstamp_=
skb
      net: dsa: sja1105: move devlink param code to sja1105_devlink.c
      net: dsa: sja1105: expose static config as devlink region
      net: dsa: sja1105: implement .devlink_info_get
      net: mscc: ocelot: move NPI port configuration to DSA
      net: dsa: allow drivers to request promiscuous mode on master
      net: dsa: tag_sja1105: request promiscuous mode for master
      net: dsa: tag_ocelot: use a short prefix on both ingress and egress
      net: dsa: make the .flow_dissect tagger callback return void
      net: dsa: add a generic procedure for the flow dissector
      net: dsa: point out the tail taggers
      net: flow_dissector: avoid indirect call to DSA .flow_dissect for gen=
eric case
      net: dsa: tag_brcm: use generic flow dissector procedure
      net: dsa: tag_dsa: use the generic flow dissector procedure
      net: dsa: tag_edsa: use the generic flow dissector procedure
      net: dsa: tag_mtk: use the generic flow dissector procedure
      net: dsa: tag_qca: use the generic flow dissector procedure
      net: dsa: tag_sja1105: use a custom flow dissector procedure
      net: dsa: tag_rtl4_a: use the generic flow dissector procedure
      net: mscc: ocelot: introduce a new ocelot_target_{read,write} API
      net: mscc: ocelot: generalize existing code for VCAP
      net: mscc: ocelot: add definitions for VCAP IS1 keys, actions and tar=
get
      net: mscc: ocelot: add definitions for VCAP ES0 keys, actions and tar=
get
      net: mscc: ocelot: automatically detect VCAP constants
      net: mscc: ocelot: remove unneeded VCAP parameters for IS2
      net: mscc: ocelot: parse flower action before key
      net: mscc: ocelot: rename variable 'count' in vcap_data_offset_get()
      net: mscc: ocelot: rename variable 'cnt' in vcap_data_offset_get()
      net: mscc: ocelot: add a new ocelot_vcap_block_find_filter_by_id func=
tion
      net: mscc: ocelot: look up the filters in flower_stats() and flower_d=
estroy()
      net: mscc: ocelot: offload multiple tc-flower actions in same rule
      net: mscc: ocelot: introduce conversion helpers between port and netd=
ev
      net: mscc: ocelot: create TCAM skeleton from tc filter chains
      net: mscc: ocelot: only install TCAM entries into a specific lookup a=
nd PAG
      net: mscc: ocelot: relax ocelot_exclusive_mac_etype_filter_rules()
      net: mscc: ocelot: offload redirect action to VCAP IS2
      selftests: ocelot: add some example VCAP IS1, IS2 and ES0 tc offloads
      powerpc: dts: t1040: add bindings for Seville Ethernet switch
      powerpc: dts: t1040rdb: add ports for Seville Ethernet switch
      net: dsa: sja1105: remove duplicate prefix for VL Lookup dynamic conf=
ig
      net: dsa: propagate switchdev vlan_filtering prepare phase to drivers
      net: always dump full packets with skb_dump
      net: mscc: ocelot: add missing VCAP ES0 and IS1 regmaps for VSC7514
      net: mscc: ocelot: offload VLAN mangle action to VCAP IS1
      net: dsa: tag_ocelot: use VLAN information from tagging header when a=
vailable
      selftests: net: mscc: ocelot: add test for VLAN modify action
      net: mscc: ocelot: remove duplicate ocelot_port_dev_check

Vu Pham (4):
      net/mlx5: E-Switch, Check and enable metadata support flag before usi=
ng
      net/mlx5: E-Switch, Dedicated metadata for uplink vport
      net/mlx5: E-Switch, Setup all vports' metadata to support peer miss r=
ule
      net/mlx5: E-Switch, Use vport metadata matching by default

Wang Hai (25):
      net: ipa: remove duplicate include
      caif: Remove duplicate macro SRVL_CTRL_PKT_SIZE
      NFC: digital: Remove two unused macroes
      net/packet: Remove unused macro BLOCK_PRIV
      net: ethernet: dnet: Remove set but unused variable 'len'
      rxrpc: Remove unused macro rxrpc_min_rtt_wlen
      netfilter: ebt_stp: Remove unused macro BPDU_TYPE_TCN
      cipso: fix 'audit_secid' kernel-doc warning in cipso_ipv4.c
      bnx2x: Fix some kernel-doc warnings
      net: wimax: i2400m: fix 'msg_skb' kernel-doc warning in i2400m_msg_to=
_dev()
      netlabel: Fix some kernel-doc warnings
      net: cavium: Fix a bunch of kerneldoc parameter issues
      net: cxgb3: Fix some kernel-doc warnings
      hinic: Fix some kernel-doc warnings in hinic_hw_io.c
      net: hns: fix 'cdev' kernel-doc warning in hnae_ae_unregister()
      net: hns: Fix some kernel-doc warnings in hns_dsaf_xgmac.c
      net: hns: Fix some kernel-doc warnings in hns_enet.c
      net: hns: Fix a kernel-doc warning in hinic_hw_api_cmd.c
      net: hns: Fix a kernel-doc warning in hinic_hw_eqs.c
      liquidio: Fix -Wmissing-prototypes warnings for liquidio
      net/appletalk: Supply missing net/Space.h include file
      net: hns3: Supply missing hclge_dcb.h include file
      net: tipc: Supply missing udp_media.h include file
      can: peak_canfd: Remove unused macros
      mt76: mt7615: Remove set but unused variable 'index'

Wang Qing (2):
      net: Use kobj_to_dev() API
      wl1251/wl12xx: fix a typo in comments

Wang Yufen (2):
      ath11k: Fix possible memleak in ath11k_qmi_init_service
      brcm80211: fix possible memleak in brcmf_proto_msgbuf_attach

Wei Wang (5):
      ip: expose inet sockopts through inet_diag
      ipv6: add tos reflection in TCP reset and ack
      tcp: record received TOS value in the request socket
      ip: pass tos into ip_build_and_send_pkt()
      tcp: reflect tos value received in SYN to the socket

Wei Xu (1):
      net: smsc911x: Remove unused variables

Wen Gong (10):
      ath10k: start recovery process when payload length exceeds max htc le=
ngth for sdio
      ath10k: add wmi service peer stat info for wmi tlv
      ath10k: remove return for NL80211_STA_INFO_TX_BITRATE
      ath10k: enable supports_peer_stats_info for QCA6174 PCI devices
      ath10k: correct the array index from mcs index for HT mode for QCA6174
      ath10k: add bus type for each layout of coredump
      ath10k: sdio: add firmware coredump support
      ath11k: change to disable softirqs for ath11k_regd_update to solve de=
adlock
      ath11k: Use GFP_ATOMIC instead of GFP_KERNEL in ath11k_dp_htt_get_ppd=
u_desc
      ath11k: mac: remove unused conf_mutex to solve a deadlock

Weqaar Janjua (1):
      samples/bpf: Fix to xdpsock to avoid recycling frames

Willem de Bruijn (1):
      docs: networking: update XPS to account for netif_set_xps_queue

Willy Liu (1):
      net: phy: realtek: Modify 2.5G PHY name to RTL8226

Willy Tarreau (3):
      macb: add RM9200's interrupt flag TBRE
      macb: prepare at91 to use a 2-frame TX queue
      macb: support the two tx descriptors on at91rm9200

Wolfram Sang (1):
      can: mscan: mpc5xxx_can: update contact email

Wright Feng (3):
      cfg80211: add more comments for ap_isolate in bss_parameters
      brcmfmac: Fix warning when hitting FW crash with flow control feature
      brcmfmac: Fix warning message after dongle setup failed

Xiaoliang Yang (4):
      net: mscc: ocelot: return error if VCAP filter is not found
      net: mscc: ocelot: calculate vcap offsets correctly for full and quar=
ter entries
      net: mscc: ocelot: offload ingress skbedit and vlan actions to VCAP I=
S1
      net: mscc: ocelot: offload egress VLAN rewriting to VCAP ES0

Xie He (8):
      drivers/net/wan/x25_asy: Remove an unused flag "SLF_OUTWAIT"
      net/packet: Fix a comment about hard_header_len and headroom allocati=
on
      drivers/net/wan/x25_asy: Remove an unnecessary x25_type_trans call
      net/packet: Fix a comment about mac_header
      net/packet: Fix a comment about network_header
      drivers/net/wan/hdlc_fr: Correctly handle special skb->protocol values
      drivers/net/wan/hdlc_fr: Improvements to the code of pvc_xmit
      drivers/net/wan/hdlc_fr: Move the skb_headroom check out of fr_hard_h=
eader

Xu Wang (4):
      libbpf: Convert comma to semicolon
      libbpf: Simplify the return expression of build_map_pin_path()
      ptp: ptp_ines: Remove redundant null check
      Bluetooth: hci_qca: remove redundant null check

Yang Yingliang (1):
      netlink: add spaces around '&' in netlink_recv/sendmsg()

Yangbo Lu (8):
      dpaa2-eth: add APIs of 1588 single step timestamping
      dpaa2-eth: define a global ptp_qoriq structure pointer
      dpaa2-eth: invoke dpaa2_eth_enable_tx_tstamp() once in code
      dpaa2-eth: utilize skb->cb[0] for hardware timestamping
      dpaa2-eth: support PTP Sync packet one-step timestamping
      dt-binding: ptp_qoriq: support fsl,tmr-fiper3 property
      ptp_qoriq: support FIPER3
      ptp: add stub function for ptp_get_msgtype()

Yaroslav Bolyukin (1):
      ipvs: remove dependency on ip6_tables

Ye Bin (4):
      mptcp: Fix unsigned 'max_seq' compared with zero in mptcp_data_queue_=
ofo
      mt76: Fix unsigned expressions compared with zero
      pktgen: Fix inconsistent of format with argument type in pktgen.c
      net-sysfs: Fix inconsistent of format with argument type in net-sysfs=
.c

Yevgeny Kliteynik (5):
      net/mlx5: DR, Replace the check for valid STE entry
      net/mlx5: DR, Remove unneeded check from source port builder
      net/mlx5: DR, Remove unneeded vlan check from L2 builder
      net/mlx5: DR, Remove unneeded local variable
      net/mlx5: DR, Call ste_builder directly with tag pointer

YiFei Zhu (5):
      bpf: Mutex protect used_maps array and count
      bpf: Add BPF_PROG_BIND_MAP syscall
      libbpf: Add BPF_PROG_BIND_MAP syscall and use it on .rodata section
      bpftool: Support dumping metadata
      selftests/bpf: Test load and dump metadata with btftool and skel

Yonghong Song (21):
      bpf: Implement link_query for bpf iterators
      bpf: Implement link_query callbacks in map element iterators
      bpftool: Implement link_query for bpf iterators
      selftests/bpf: Enable tc verbose mode for test_sk_assign
      bpf: Fix a verifier failure with xor
      selftests/bpf: Add verifier tests for xor operation
      bpf: Make bpf_link_info.iter similar to bpf_iter_link_info
      bpf: Avoid iterating duplicated files for task_file iterator
      selftests/bpf: Test task_file iterator without visiting pthreads
      bpf: Permit map_ptr arithmetic with opcode add and offset 0
      selftests/bpf: Add test for map_ptr arithmetic
      selftests/bpf: Fix test_sysctl_loop{1, 2} failure due to clang change
      selftests/bpf: Define string const as global for test_sysctl_prog.c
      bpftool: Fix build failure
      libbpf: Fix a compilation error with xsk.c for ubuntu 16.04
      bpf: Using rcu_read_lock for bpf_sk_storage_map iterator
      samples/bpf: Change Makefile to cope with latest llvm
      samples/bpf: Fix a compilation error with fallthrough marking
      bpf: Fix build failure for kernel/trace/bpf_trace.c with CONFIG_NET=
=3Dn
      bpf: Track spill/fill of bounded scalars.
      net: fix pos incrementment in ipv6_route_seq_next

Yuchung Cheng (5):
      tcp: consistently check retransmit hint
      tcp: move tcp_mark_skb_lost
      tcp: simplify tcp_mark_skb_lost
      tcp: consolidate tcp_mark_skb_lost and tcp_skb_mark_lost
      tcp: account total lost packets properly

YueHaibing (30):
      netfilter: xt_HMARK: Use ip_is_fragment() helper
      mptcp: Remove unused macro MPTCP_SAME_STATE
      tipc: Remove unused macro TIPC_FWD_MSG
      tipc: Remove unused macro TIPC_NACK_INTV
      net: wan: slic_ds26522: Remove unused macro DRV_NAME
      net: dl2k: Remove unused macro DRV_NAME
      net: hns: Remove unused macro AE_NAME_PORT_ID_IDX
      net/wan/fsl_ucc_hdlc: Add MODULE_DESCRIPTION
      libertas_tf: Remove unused macro QOS_CONTROL_LEN
      net: sungem: Remove unneeded cast from memory allocation
      liquidio: Remove unneeded cast from memory allocation
      mwifiex: wmm: Fix -Wunused-const-variable warnings
      mwifiex: sdio: Fix -Wunused-const-variable warnings
      Bluetooth: btmtksdio: use NULL instead of zero
      ath11k: Remove unused inline function htt_htt_stats_debug_dump()
      ath10k: Remove unused macro ATH10K_ROC_TIMEOUT_HZ
      wlcore: Remove unused macro WL1271_SUSPEND_SLEEP
      qtnfmac: Remove unused macro QTNF_DMP_MAX_LEN
      net/sched: Remove unused function qdisc_queue_drop_head()
      genetlink: Remove unused function genl_err_attr()
      netdev: Remove unused functions
      lib80211: Remove unused macro DRV_NAME
      tipc: Remove unused macro CF_SERVER
      can: c_can: Remove unused inline function
      netfilter: nf_tables: Remove ununsed function nft_data_debug
      ipvs: Remove unused macros
      wlcore: Remove unused function no_write_handler()
      ath11k: Remove unused function ath11k_htc_restore_tx_skb()
      netfilter: nf_tables_offload: Remove unused macro FLOW_SETUP_BLOCK
      bpfilter: Fix build error with CONFIG_BPFILTER_UMH

Yufeng Mo (4):
      net: hns3: refactor the function for dumping tc information in debugfs
      net: hns3: remove unnecessary variable initialization
      net: hns3: add a hardware error detect type
      net: hns3: add debugfs of dumping pf interrupt resources

Yunsheng Lin (7):
      net: hns3: batch the page reference count updates
      net: hns3: batch tx doorbell operation
      net: hns3: optimize the tx clean process
      net: hns3: optimize the rx clean process
      net: hns3: use writel() to optimize the barrier operation
      net: hns3: use napi_consume_skb() when cleaning tx desc
      net: remove unnecessary NULL checking in napi_consume_skb()

Yutaro Hayakawa (1):
      net/tls: Implement getsockopt SOL_TLS TLS_RX

Zekun Shen (2):
      ath10k: pci: fix memcpy size of bmi response
      ath10k: check idx validity in __ath10k_htt_rx_ring_fill_n()

Zeng Tao (1):
      net: openswitch: reuse the helper variable to improve the code readab=
lity

Zhang Changzhong (13):
      net: xilinx: remove redundant null check before clk_disable_unprepare=
()
      net: stmmac: remove redundant null check before clk_disable_unprepare=
()
      net: ethernet: fec: remove redundant null check before clk_disable_un=
prepare()
      net: ethernet: dwmac: remove redundant null check before clk_disable_=
unprepare()
      net: pxa168_eth: remove redundant null check before clk_disable_unpre=
pare()
      net: stmmac: dwmac-intel-plat: remove redundant null check before clk=
_disable_unprepare()
      net: dnet: remove unused variable 'tx_status 'in dnet_start_xmit()
      net: fec: ptp: remove unused variable 'ns' in fec_time_keep()
      net: pxa168_eth: remove unused variable 'retval' int pxa168_eth_chang=
e_mtu()
      net: qlcnic: remove unused variable 'val' in qlcnic_83xx_cam_unlock()
      net: mventa: remove unused variable 'dummy' in mvneta_mib_counters_cl=
ear()
      can: mscan: simplify clock enable/disable
      brcmfmac: check return value of driver_for_each_device()

Zheng Bin (15):
      rtlwifi: rtl8188ee: fix comparison pointer to bool warning in phy.c
      rtlwifi: rtl8188ee: fix comparison pointer to bool warning in trx.c
      rtlwifi: rtl8188ee: fix comparison pointer to bool warning in hw.c
      rtlwifi: rtl8723ae: fix comparison pointer to bool warning in rf.c
      rtlwifi: rtl8723ae: fix comparison pointer to bool warning in trx.c
      rtlwifi: rtl8723ae: fix comparison pointer to bool warning in phy.c
      rtlwifi: rtl8192ee: fix comparison to bool warning in hw.c
      rtlwifi: rtl8192c: fix comparison to bool warning in phy_common.c
      rtlwifi: rtl8192cu: fix comparison to bool warning in mac.c
      rtlwifi: rtl8821ae: fix comparison to bool warning in hw.c
      rtlwifi: rtl8821ae: fix comparison to bool warning in phy.c
      rtlwifi: rtl8192cu: fix comparison to bool warning in hw.c
      rtlwifi: rtl8192ce: fix comparison to bool warning in hw.c
      rtlwifi: rtl8192de: fix comparison to bool warning in hw.c
      rtlwifi: rtl8723be: fix comparison to bool warning in hw.c

Zheng Yongjun (7):
      net: cortina: Remove set but not used variable
      net: liquidio: Remove set but not used variable
      net: e1000: Remove set but not used variable
      net: micrel: Remove set but not used variable
      net: natsemi: Remove set but not used variable
      net: microchip: Make `lan743x_pm_suspend` function return right value
      net: realtek: Remove set but not used variable

Zong-Zhe Yang (1):
      rtw88: 8822c: update tx power limit tables to RF v20.1

Zyta Szpak (1):
      octeontx2-af: Support to enable/disable HW timestamping

longguang.yue (1):
      ipvs: inspect reply packets from DR/TUN real servers

sunils (1):
      net/mlx5: E-switch, Use PF num in metadata reg c0

wenxu (2):
      ipv6: add ipv6_fragment hook in ipv6_stub
      openvswitch: using ip6_fragment in ipv6_stub

=C5=81ukasz Stelmach (1):
      net/smscx5xx: change to of_get_mac_address() eth_platform_get_mac_add=
ress()

 CREDITS                                            |    4 +
 Documentation/admin-guide/kernel-parameters.txt    |    5 +
 Documentation/admin-guide/sysctl/net.rst           |   20 +-
 Documentation/bpf/bpf_devel_QA.rst                 |   23 +-
 Documentation/bpf/btf.rst                          |   25 +
 Documentation/bpf/index.rst                        |    1 +
 Documentation/bpf/prog_sk_lookup.rst               |   98 +
 .../bindings/net/brcm,bcm7445-switch-v4.0.txt      |    7 +
 .../devicetree/bindings/net/brcm,systemport.txt    |    5 +
 .../devicetree/bindings/net/can/fsl-flexcan.txt    |   10 +-
 .../bindings/net/can/microchip,mcp251x.txt         |    7 +-
 .../bindings/net/can/microchip,mcp251xfd.yaml      |   79 +
 .../devicetree/bindings/net/can/rcar_can.txt       |    8 +-
 .../devicetree/bindings/net/can/rcar_canfd.txt     |    5 +-
 Documentation/devicetree/bindings/net/dsa/b53.txt  |    9 +-
 .../devicetree/bindings/net/dsa/mt7530.txt         |   13 +-
 .../bindings/net/ethernet-controller.yaml          |   14 +
 .../devicetree/bindings/net/intel,dwmac-plat.yaml  |  130 +
 .../devicetree/bindings/net/marvell,prestera.txt   |   34 +
 .../devicetree/bindings/net/nfc/s3fwrn5.txt        |   25 -
 .../bindings/net/nfc/samsung,s3fwrn5.yaml          |   73 +
 .../devicetree/bindings/net/renesas,etheravb.yaml  |  262 ++
 .../devicetree/bindings/net/renesas,ravb.txt       |  135 -
 .../devicetree/bindings/net/smsc-lan87xx.txt       |    4 +
 .../devicetree/bindings/net/ti,dp83822.yaml        |   80 +
 .../bindings/net/wireless/qcom,ath10k.txt          |    4 +-
 .../bindings/net/wireless/qcom,ath11k.yaml         |    4 +-
 .../devicetree/bindings/ptp/ptp-qoriq.txt          |    2 +
 Documentation/driver-api/80211/cfg80211.rst        |  392 +--
 .../driver-api/80211/mac80211-advanced.rst         |  151 +-
 Documentation/driver-api/80211/mac80211.rst        |  148 +-
 Documentation/networking/af_xdp.rst                |   68 +-
 Documentation/networking/caif/index.rst            |    1 -
 Documentation/networking/caif/spi_porting.rst      |  229 --
 .../device_drivers/ethernet/amazon/ena.rst         |   25 +-
 Documentation/networking/devlink/devlink-flash.rst |   28 +
 .../networking/devlink/devlink-params.rst          |    6 +
 .../networking/devlink/devlink-reload.rst          |   81 +
 Documentation/networking/devlink/devlink-trap.rst  |   70 +
 Documentation/networking/devlink/ice.rst           |   36 +
 Documentation/networking/devlink/index.rst         |    1 +
 Documentation/networking/ethtool-netlink.rst       |   11 +
 Documentation/networking/index.rst                 |    1 +
 Documentation/networking/kapi.rst                  |    9 +
 Documentation/networking/l2tp.rst                  |  939 ++++--
 Documentation/networking/scaling.rst               |    6 +-
 Documentation/networking/statistics.rst            |  179 +
 Documentation/networking/vxlan.rst                 |   28 +
 MAINTAINERS                                        |   50 +-
 Makefile                                           |    4 +-
 .../boot/dts/exynos/exynos5433-tm2-common.dtsi     |    4 +-
 arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts  |    1 +
 .../boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts  |   50 +
 arch/arm64/boot/dts/mediatek/mt7622-rfb1.dts       |   63 +-
 arch/mips/boot/dts/mscc/ocelot.dtsi                |    4 +-
 arch/powerpc/boot/dts/fsl/t1040rdb.dts             |  107 +
 arch/powerpc/boot/dts/fsl/t1040si-post.dtsi        |   78 +
 arch/s390/include/asm/ccwdev.h                     |    9 +-
 arch/s390/include/asm/chsc.h                       |    7 +
 arch/s390/include/asm/css_chars.h                  |    4 +-
 arch/s390/net/bpf_jit_comp.c                       |   61 +-
 arch/x86/include/asm/nospec-branch.h               |   16 +-
 arch/x86/net/bpf_jit_comp.c                        |  310 +-
 drivers/atm/atmtcp.c                               |    2 +-
 drivers/bcma/driver_pci_host.c                     |    4 +-
 drivers/block/nbd.c                                |    6 +-
 drivers/bluetooth/btintel.c                        |  291 +-
 drivers/bluetooth/btintel.h                        |   91 +
 drivers/bluetooth/btmrvl_sdio.c                    |   54 +-
 drivers/bluetooth/btmtksdio.c                      |    4 +-
 drivers/bluetooth/btusb.c                          |  129 +-
 drivers/bluetooth/hci_h5.c                         |    2 -
 drivers/bluetooth/hci_intel.c                      |   54 +-
 drivers/bluetooth/hci_ldisc.c                      |    1 +
 drivers/bluetooth/hci_qca.c                        |    8 +-
 drivers/bluetooth/hci_serdev.c                     |   36 +-
 drivers/connector/connector.c                      |    7 +-
 drivers/crypto/chelsio/Kconfig                     |   32 -
 drivers/crypto/chelsio/Makefile                    |    5 -
 drivers/crypto/chelsio/chcr_algo.h                 |   33 -
 drivers/crypto/chelsio/chcr_core.c                 |   62 -
 drivers/crypto/chelsio/chcr_core.h                 |   98 -
 drivers/infiniband/hw/hfi1/ipoib_main.c            |   34 +-
 drivers/net/Kconfig                                |    4 +
 drivers/net/Makefile                               |    2 +
 drivers/net/appletalk/cops.c                       |    2 +
 drivers/net/appletalk/ltpc.c                       |    2 +
 drivers/net/bareudp.c                              |   11 +-
 drivers/net/caif/Kconfig                           |   19 -
 drivers/net/caif/Makefile                          |    4 -
 drivers/net/caif/caif_hsi.c                        |   19 +-
 drivers/net/caif/caif_spi.c                        |  874 -----
 drivers/net/caif/caif_spi_slave.c                  |  254 --
 drivers/net/caif/caif_virtio.c                     |    2 +-
 drivers/net/can/Kconfig                            |    4 +-
 drivers/net/can/at91_can.c                         |    8 +-
 drivers/net/can/c_can/c_can.c                      |    9 -
 drivers/net/can/c_can/c_can.h                      |    4 +-
 drivers/net/can/cc770/cc770.c                      |    2 +-
 drivers/net/can/cc770/cc770.h                      |    2 +-
 drivers/net/can/dev.c                              |   58 +-
 drivers/net/can/flexcan.c                          |  610 +++-
 drivers/net/can/grcan.c                            |    4 +-
 drivers/net/can/m_can/Kconfig                      |    2 +-
 drivers/net/can/m_can/m_can_platform.c             |    2 -
 drivers/net/can/mscan/mpc5xxx_can.c                |    2 +-
 drivers/net/can/mscan/mscan.c                      |   29 +-
 drivers/net/can/pch_can.c                          |   67 +-
 drivers/net/can/peak_canfd/peak_pciefd_main.c      |    2 -
 drivers/net/can/rx-offload.c                       |   11 +
 drivers/net/can/sja1000/peak_pci.c                 |    2 +-
 drivers/net/can/sja1000/peak_pcmcia.c              |    2 +-
 drivers/net/can/softing/Kconfig                    |    6 +-
 drivers/net/can/softing/softing_fw.c               |    8 +-
 drivers/net/can/softing/softing_main.c             |   11 +-
 drivers/net/can/softing/softing_platform.h         |    2 +-
 drivers/net/can/spi/Kconfig                        |    4 +-
 drivers/net/can/spi/Makefile                       |    1 +
 drivers/net/can/spi/mcp251x.c                      |  345 +-
 drivers/net/can/spi/mcp251xfd/Kconfig              |   17 +
 drivers/net/can/spi/mcp251xfd/Makefile             |    8 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     | 2927 ++++++++++++++++
 drivers/net/can/spi/mcp251xfd/mcp251xfd-crc16.c    |   89 +
 drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c   |  556 +++
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h          |  835 +++++
 drivers/net/can/ti_hecc.c                          |   29 +-
 drivers/net/can/usb/Kconfig                        |    2 +-
 drivers/net/can/usb/gs_usb.c                       |    4 +-
 drivers/net/can/usb/mcba_usb.c                     |    4 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c            |  166 +-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |    4 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |    4 +-
 drivers/net/can/usb/ucan.c                         |    4 +-
 drivers/net/can/usb/usb_8dev.c                     |    4 +-
 drivers/net/can/xilinx_can.c                       |   16 +-
 drivers/net/dsa/Kconfig                            |    6 +-
 drivers/net/dsa/b53/b53_common.c                   |   99 +-
 drivers/net/dsa/b53/b53_priv.h                     |    5 +-
 drivers/net/dsa/bcm_sf2.c                          |  136 +-
 drivers/net/dsa/bcm_sf2.h                          |    4 +
 drivers/net/dsa/dsa_loop.c                         |   59 +-
 drivers/net/dsa/lantiq_gswip.c                     |   26 +-
 drivers/net/dsa/microchip/ksz8795.c                |    6 +-
 drivers/net/dsa/microchip/ksz9477.c                |   32 +-
 drivers/net/dsa/microchip/ksz9477_i2c.c            |    1 +
 drivers/net/dsa/microchip/ksz_common.c             |   19 +-
 drivers/net/dsa/mt7530.c                           | 1271 ++++++-
 drivers/net/dsa/mt7530.h                           |  259 +-
 drivers/net/dsa/mv88e6xxx/Makefile                 |    1 +
 drivers/net/dsa/mv88e6xxx/chip.c                   |  308 +-
 drivers/net/dsa/mv88e6xxx/chip.h                   |   18 +
 drivers/net/dsa/mv88e6xxx/devlink.c                |  633 ++++
 drivers/net/dsa/mv88e6xxx/devlink.h                |   21 +
 drivers/net/dsa/mv88e6xxx/hwtstamp.c               |   59 +-
 drivers/net/dsa/ocelot/Kconfig                     |   23 +-
 drivers/net/dsa/ocelot/Makefile                    |    6 +-
 drivers/net/dsa/ocelot/felix.c                     |  124 +-
 drivers/net/dsa/ocelot/felix.h                     |   32 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             |  639 ++--
 drivers/net/dsa/ocelot/seville_vsc9953.c           |  284 +-
 drivers/net/dsa/qca8k.c                            |    6 +-
 drivers/net/dsa/realtek-smi-core.c                 |    3 +-
 drivers/net/dsa/realtek-smi-core.h                 |    9 +-
 drivers/net/dsa/rtl8366.c                          |  291 +-
 drivers/net/dsa/rtl8366rb.c                        |  115 +-
 drivers/net/dsa/sja1105/Makefile                   |    1 +
 drivers/net/dsa/sja1105/sja1105.h                  |   20 +-
 drivers/net/dsa/sja1105/sja1105_devlink.c          |  262 ++
 drivers/net/dsa/sja1105/sja1105_dynamic_config.c   |   10 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |  326 +-
 drivers/net/dsa/sja1105/sja1105_spi.c              |    5 +-
 drivers/net/ethernet/3com/typhoon.c                |   61 +-
 drivers/net/ethernet/8390/axnet_cs.c               |   17 +-
 drivers/net/ethernet/8390/lib8390.c                |   32 +-
 drivers/net/ethernet/8390/pcnet_cs.c               |    6 +-
 drivers/net/ethernet/adaptec/starfire.c            |   77 +-
 drivers/net/ethernet/allwinner/sun4i-emac.c        |    6 +-
 drivers/net/ethernet/alteon/acenic.c               |    9 +-
 drivers/net/ethernet/alteon/acenic.h               |    3 +-
 drivers/net/ethernet/amazon/ena/ena_admin_defs.h   |  128 +-
 drivers/net/ethernet/amazon/ena/ena_com.c          |  247 +-
 drivers/net/ethernet/amazon/ena/ena_com.h          |   42 +-
 drivers/net/ethernet/amazon/ena/ena_common_defs.h  |   31 +-
 drivers/net/ethernet/amazon/ena/ena_eth_com.c      |   84 +-
 drivers/net/ethernet/amazon/ena/ena_eth_com.h      |   37 +-
 drivers/net/ethernet/amazon/ena/ena_eth_io_defs.h  |   31 +-
 drivers/net/ethernet/amazon/ena/ena_ethtool.c      |  203 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |  178 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.h       |   40 +-
 drivers/net/ethernet/amazon/ena/ena_pci_id_tbl.h   |   31 +-
 drivers/net/ethernet/amazon/ena/ena_regs_defs.h    |   31 +-
 drivers/net/ethernet/amd/sun3lance.c               |   11 -
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |   19 +-
 drivers/net/ethernet/amd/xgbe/xgbe-i2c.c           |   11 +-
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |   11 +-
 drivers/net/ethernet/apm/xgene/xgene_enet_main.h   |    2 +-
 .../net/ethernet/aquantia/atlantic/aq_ethtool.c    |   53 +
 drivers/net/ethernet/aquantia/atlantic/aq_hw.h     |    6 +
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |   50 +
 drivers/net/ethernet/aquantia/atlantic/aq_nic.h    |    4 +
 .../ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c  |    2 +-
 .../aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c   |   37 +
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c   |   13 +
 drivers/net/ethernet/arc/emac_arc.c                |    2 +-
 drivers/net/ethernet/atheros/ag71xx.c              |  160 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |   55 +-
 drivers/net/ethernet/atheros/atl1e/atl1e_main.c    |   66 +-
 drivers/net/ethernet/atheros/atlx/atl1.c           |   50 +-
 drivers/net/ethernet/atheros/atlx/atl2.c           |   19 +-
 drivers/net/ethernet/broadcom/b44.c                |    8 +-
 drivers/net/ethernet/broadcom/bcmsysport.c         |   40 +-
 drivers/net/ethernet/broadcom/bcmsysport.h         |    2 +
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c    |    6 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h    |    8 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c    |    6 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c   |   22 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c     |   98 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  735 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  162 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |  173 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h  |    6 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  |  336 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h  |    2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_hsi.h      |  397 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c    |    2 +-
 drivers/net/ethernet/broadcom/cnic.c               |   18 +-
 drivers/net/ethernet/brocade/bna/bfa_cee.c         |   20 +-
 drivers/net/ethernet/brocade/bna/bfa_ioc.c         |   13 +-
 drivers/net/ethernet/brocade/bna/bnad.c            |    7 +-
 drivers/net/ethernet/cadence/macb.h                |   21 +-
 drivers/net/ethernet/cadence/macb_main.c           |   80 +-
 drivers/net/ethernet/cadence/macb_pci.c            |    3 +-
 drivers/net/ethernet/calxeda/xgmac.c               |    2 +
 drivers/net/ethernet/cavium/common/cavium_ptp.c    |   10 +-
 .../net/ethernet/cavium/liquidio/cn68xx_device.c   |    2 +
 drivers/net/ethernet/cavium/liquidio/lio_core.c    |   92 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |  363 +-
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c |  158 +-
 .../net/ethernet/cavium/liquidio/octeon_console.c  |   12 +-
 .../net/ethernet/cavium/liquidio/octeon_device.c   |   13 +-
 drivers/net/ethernet/cavium/liquidio/octeon_droq.c |   11 +-
 .../net/ethernet/cavium/liquidio/octeon_mailbox.c  |    5 +-
 drivers/net/ethernet/cavium/liquidio/octeon_main.h |    1 +
 .../net/ethernet/cavium/liquidio/octeon_mem_ops.c  |    1 +
 drivers/net/ethernet/cavium/octeon/octeon_mgmt.c   |    8 +-
 drivers/net/ethernet/cavium/thunder/nicvf_main.c   |   14 +-
 drivers/net/ethernet/cavium/thunder/nicvf_queues.c |    4 +-
 drivers/net/ethernet/cavium/thunder/nicvf_queues.h |    2 +-
 drivers/net/ethernet/chelsio/Kconfig               |    2 +
 drivers/net/ethernet/chelsio/Makefile              |    1 +
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c          |   10 +-
 drivers/net/ethernet/chelsio/cxgb/sge.c            |   76 +-
 drivers/net/ethernet/chelsio/cxgb3/adapter.h       |    1 +
 drivers/net/ethernet/chelsio/cxgb3/ael1002.c       |    7 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c    |   10 +-
 drivers/net/ethernet/chelsio/cxgb3/sge.c           |   91 +-
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c         |    9 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h         |   15 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |   57 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c |   54 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |   17 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |  204 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c   |  175 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h   |   15 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c   |    3 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c     |   10 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h     |   58 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |   32 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |    2 +
 drivers/net/ethernet/chelsio/cxgb4/t4_regs.h       |    8 +
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c    |   92 +-
 drivers/net/ethernet/chelsio/inline_crypto/Kconfig |   52 +
 .../net/ethernet/chelsio/inline_crypto/Makefile    |    4 +
 .../chelsio/inline_crypto/ch_ipsec/Makefile        |    8 +
 .../chelsio/inline_crypto/ch_ipsec}/chcr_ipsec.c   |  225 +-
 .../chelsio/inline_crypto/ch_ipsec/chcr_ipsec.h    |   58 +
 .../chelsio/inline_crypto/ch_ktls/Makefile         |    5 +
 .../chelsio/inline_crypto/ch_ktls}/chcr_common.h   |   24 -
 .../chelsio/inline_crypto/ch_ktls}/chcr_ktls.c     |  471 ++-
 .../chelsio/inline_crypto/ch_ktls}/chcr_ktls.h     |   43 +-
 .../ethernet/chelsio/inline_crypto}/chtls/Makefile |    0
 .../ethernet/chelsio/inline_crypto}/chtls/chtls.h  |   88 +
 .../chelsio/inline_crypto}/chtls/chtls_cm.c        |    0
 .../chelsio/inline_crypto}/chtls/chtls_cm.h        |    0
 .../chelsio/inline_crypto}/chtls/chtls_hw.c        |    0
 .../chelsio/inline_crypto}/chtls/chtls_io.c        |    0
 .../chelsio/inline_crypto}/chtls/chtls_main.c      |    2 +-
 drivers/net/ethernet/cirrus/cs89x0.h               |    4 -
 drivers/net/ethernet/cisco/enic/enic.h             |    1 +
 drivers/net/ethernet/cisco/enic/enic_api.c         |    8 +-
 drivers/net/ethernet/cisco/enic/enic_ethtool.c     |    2 +-
 drivers/net/ethernet/cisco/enic/enic_main.c        |  115 +-
 drivers/net/ethernet/cisco/enic/vnic_dev.c         |   66 +-
 drivers/net/ethernet/cortina/gemini.c              |   40 +-
 drivers/net/ethernet/dec/tulip/de2104x.c           |   62 +-
 drivers/net/ethernet/dec/tulip/de4x5.c             |    4 +-
 drivers/net/ethernet/dec/tulip/dmfe.c              |   44 +-
 drivers/net/ethernet/dec/tulip/interrupt.c         |   56 +-
 drivers/net/ethernet/dec/tulip/media.c             |    5 -
 drivers/net/ethernet/dec/tulip/tulip_core.c        |   65 +-
 drivers/net/ethernet/dec/tulip/uli526x.c           |   44 +-
 drivers/net/ethernet/dec/tulip/winbond-840.c       |   80 +-
 drivers/net/ethernet/dlink/dl2k.c                  |   81 +-
 drivers/net/ethernet/dlink/sundance.c              |   21 +-
 drivers/net/ethernet/dnet.c                        |   13 +-
 drivers/net/ethernet/ethoc.c                       |    6 +-
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c     |    2 +-
 drivers/net/ethernet/freescale/dpaa2/Kconfig       |    1 +
 drivers/net/ethernet/freescale/dpaa2/Makefile      |    2 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth-dcb.c   |    8 +-
 .../ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c   |   63 +-
 .../ethernet/freescale/dpaa2/dpaa2-eth-devlink.c   |  309 ++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |  746 +++--
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h   |  125 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-ethtool.c   |   98 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c   |   88 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h   |    2 +
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c   |    3 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.h   |    4 +
 drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h    |   21 +
 drivers/net/ethernet/freescale/dpaa2/dpni.c        |   79 +
 drivers/net/ethernet/freescale/dpaa2/dpni.h        |   35 +
 drivers/net/ethernet/freescale/enetc/Kconfig       |    5 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |   53 +-
 drivers/net/ethernet/freescale/enetc/enetc.h       |    9 +-
 .../net/ethernet/freescale/enetc/enetc_ethtool.c   |   26 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.c    |  335 +-
 drivers/net/ethernet/freescale/enetc/enetc_pf.h    |    8 +-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c   |    9 +-
 drivers/net/ethernet/freescale/enetc/enetc_vf.c    |    7 +-
 drivers/net/ethernet/freescale/fec_main.c          |   38 +-
 drivers/net/ethernet/freescale/fec_mpc52xx.c       |   10 +-
 drivers/net/ethernet/freescale/fec_ptp.c           |    8 +-
 drivers/net/ethernet/freescale/fman/fman.c         |   14 +-
 drivers/net/ethernet/freescale/fman/fman_muram.c   |    6 +-
 drivers/net/ethernet/freescale/fman/fman_port.c    |   23 +-
 drivers/net/ethernet/freescale/fman/mac.c          |    4 +-
 .../net/ethernet/freescale/fs_enet/fs_enet-main.c  |   11 +-
 drivers/net/ethernet/google/gve/gve.h              |  106 +-
 drivers/net/ethernet/google/gve/gve_adminq.c       |  315 +-
 drivers/net/ethernet/google/gve/gve_adminq.h       |   62 +-
 drivers/net/ethernet/google/gve/gve_ethtool.c      |  365 +-
 drivers/net/ethernet/google/gve/gve_main.c         |  301 +-
 drivers/net/ethernet/google/gve/gve_register.h     |    1 +
 drivers/net/ethernet/google/gve/gve_rx.c           |   37 +-
 drivers/net/ethernet/hisilicon/hns/hnae.c          |    4 +-
 drivers/net/ethernet/hisilicon/hns/hns_ae_adapt.c  |    2 -
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c  |   34 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_main.c |  148 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c |    9 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_ppe.c  |   17 +-
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_rcb.c  |    7 +-
 .../net/ethernet/hisilicon/hns/hns_dsaf_xgmac.c    |    6 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c      |   15 +-
 drivers/net/ethernet/hisilicon/hns/hns_ethtool.c   |    8 +-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   90 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c |   77 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  352 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   35 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   45 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_trace.h   |    2 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c |   67 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h |   38 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c |    2 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c |   37 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h |   26 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_err.c |   16 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  180 +-
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |    9 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c  |  103 +-
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h  |    8 +
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c   |   62 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h   |   34 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  |  174 +-
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h  |    1 +
 drivers/net/ethernet/hisilicon/hns_mdio.c          |    3 +-
 drivers/net/ethernet/huawei/hinic/Makefile         |    3 +-
 drivers/net/ethernet/huawei/hinic/hinic_debugfs.c  |  318 ++
 drivers/net/ethernet/huawei/hinic/hinic_debugfs.h  |  114 +
 drivers/net/ethernet/huawei/hinic/hinic_dev.h      |   20 +
 drivers/net/ethernet/huawei/hinic/hinic_devlink.c  |    8 +-
 .../net/ethernet/huawei/hinic/hinic_hw_api_cmd.c   |    2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c  |    2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c   |    7 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h   |    2 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c   |   27 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.h   |    1 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.c    |    1 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_io.c    |    6 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_io.h    |    1 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c  |    1 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_qp.h    |    6 +
 drivers/net/ethernet/huawei/hinic/hinic_main.c     |   92 +-
 drivers/net/ethernet/huawei/hinic/hinic_rx.c       |    2 +-
 drivers/net/ethernet/huawei/hinic/hinic_tx.c       |   55 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |    7 +-
 drivers/net/ethernet/ibm/ibmveth.c                 |   19 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |  415 +--
 drivers/net/ethernet/ibm/ibmvnic.h                 |    4 +-
 drivers/net/ethernet/intel/e100.c                  |   12 +-
 drivers/net/ethernet/intel/e1000/e1000_hw.c        |  159 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |   40 +-
 drivers/net/ethernet/intel/e1000e/80003es2lan.c    |    1 -
 drivers/net/ethernet/intel/e1000e/ethtool.c        |    2 +
 drivers/net/ethernet/intel/e1000e/hw.h             |    5 +
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |   23 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |   56 +-
 drivers/net/ethernet/intel/e1000e/phy.c            |    3 +
 drivers/net/ethernet/intel/e1000e/ptp.c            |    3 +-
 drivers/net/ethernet/intel/fm10k/fm10k_main.c      |    5 +-
 drivers/net/ethernet/intel/fm10k/fm10k_pci.c       |    2 -
 drivers/net/ethernet/intel/i40e/i40e.h             |    8 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq.c      |    6 +
 drivers/net/ethernet/intel/i40e/i40e_adminq.h      |    4 +-
 drivers/net/ethernet/intel/i40e/i40e_adminq_cmd.h  |    2 +
 drivers/net/ethernet/intel/i40e/i40e_client.c      |    2 -
 drivers/net/ethernet/intel/i40e/i40e_common.c      |    4 +-
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c     |   10 +-
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c     |   35 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  349 +-
 drivers/net/ethernet/intel/i40e/i40e_ptp.c         |    1 -
 drivers/net/ethernet/intel/i40e/i40e_trace.h       |    8 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   50 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx.h        |    5 +-
 drivers/net/ethernet/intel/i40e/i40e_txrx_common.h |   19 +-
 drivers/net/ethernet/intel/i40e/i40e_type.h        |    6 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |    9 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.c         |  105 +-
 drivers/net/ethernet/intel/i40e/i40e_xsk.h         |    4 +-
 drivers/net/ethernet/intel/iavf/iavf_adminq.h      |    4 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   20 +-
 drivers/net/ethernet/intel/iavf/iavf_trace.h       |    2 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c        |   11 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.h        |    2 +-
 drivers/net/ethernet/intel/ice/ice.h               |   27 +-
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h    |    6 +-
 drivers/net/ethernet/intel/ice/ice_base.c          |   16 +-
 drivers/net/ethernet/intel/ice/ice_devlink.c       |  116 +-
 drivers/net/ethernet/intel/ice/ice_devlink.h       |    4 +-
 drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c  |    6 +-
 drivers/net/ethernet/intel/ice/ice_fdir.c          |    2 +-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c     |  233 +-
 drivers/net/ethernet/intel/ice/ice_flex_pipe.h     |   11 +-
 drivers/net/ethernet/intel/ice/ice_flex_type.h     |    5 +-
 drivers/net/ethernet/intel/ice/ice_flow.c          |   66 +-
 drivers/net/ethernet/intel/ice/ice_flow.h          |    4 +-
 drivers/net/ethernet/intel/ice/ice_fw_update.c     |   51 +-
 drivers/net/ethernet/intel/ice/ice_fw_update.h     |    2 +-
 drivers/net/ethernet/intel/ice/ice_lib.c           |    7 +-
 drivers/net/ethernet/intel/ice/ice_main.c          |  127 +-
 drivers/net/ethernet/intel/ice/ice_txrx.c          |   18 +-
 drivers/net/ethernet/intel/ice/ice_txrx.h          |    4 +-
 drivers/net/ethernet/intel/ice/ice_type.h          |    3 +
 drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |    2 +-
 drivers/net/ethernet/intel/ice/ice_xsk.c           |  138 +-
 drivers/net/ethernet/intel/ice/ice_xsk.h           |    7 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c       |    6 +-
 drivers/net/ethernet/intel/igb/e1000_i210.c        |    5 +-
 drivers/net/ethernet/intel/igb/e1000_mac.c         |    1 +
 drivers/net/ethernet/intel/igb/e1000_mbx.c         |    1 +
 drivers/net/ethernet/intel/igb/igb.h               |   80 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |    4 +
 drivers/net/ethernet/intel/igb/igb_main.c          |  472 ++-
 drivers/net/ethernet/intel/igb/igb_ptp.c           |    8 +-
 drivers/net/ethernet/intel/igbvf/netdev.c          |   17 +-
 drivers/net/ethernet/intel/igc/igc.h               |    3 +
 drivers/net/ethernet/intel/igc/igc_base.c          |    5 +
 drivers/net/ethernet/intel/igc/igc_defines.h       |   16 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c       |    3 +
 drivers/net/ethernet/intel/igc/igc_hw.h            |   11 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |   52 +-
 drivers/net/ethernet/intel/igc/igc_ptp.c           |   62 +-
 drivers/net/ethernet/intel/ixgb/ixgb_hw.c          |  135 +-
 drivers/net/ethernet/intel/ixgb/ixgb_main.c        |   17 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |    2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c   |   11 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c       |    4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   49 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c       |    8 +-
 .../net/ethernet/intel/ixgbe/ixgbe_txrx_common.h   |    7 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c       |   63 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |   16 +-
 drivers/net/ethernet/jme.c                         |   40 +-
 drivers/net/ethernet/korina.c                      |    3 +-
 drivers/net/ethernet/marvell/Kconfig               |    7 +
 drivers/net/ethernet/marvell/Makefile              |    1 +
 drivers/net/ethernet/marvell/mvneta.c              |   47 +-
 drivers/net/ethernet/marvell/mvpp2/Makefile        |    3 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h         |  203 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  878 +++--
 drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c     |  457 +++
 drivers/net/ethernet/marvell/octeontx2/af/Makefile |    5 +-
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |   29 +
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |    4 +
 drivers/net/ethernet/marvell/octeontx2/af/mbox.c   |   11 +-
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |   22 +
 drivers/net/ethernet/marvell/octeontx2/af/npc.h    |   47 +-
 .../ethernet/marvell/octeontx2/af/npc_profile.h    |  541 ++-
 drivers/net/ethernet/marvell/octeontx2/af/ptp.c    |  275 ++
 drivers/net/ethernet/marvell/octeontx2/af/ptp.h    |   25 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   36 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   22 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |   41 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   87 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_npc.c    |  239 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_trace.c  |   12 +
 .../net/ethernet/marvell/octeontx2/af/rvu_trace.h  |  103 +
 .../net/ethernet/marvell/octeontx2/nic/Makefile    |    3 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   98 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   26 +-
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |   35 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |  180 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.c  |  212 ++
 .../net/ethernet/marvell/octeontx2/nic/otx2_ptp.h  |   13 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  112 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.h |    1 +
 .../net/ethernet/marvell/octeontx2/nic/otx2_vf.c   |    5 +-
 drivers/net/ethernet/marvell/prestera/Kconfig      |   25 +
 drivers/net/ethernet/marvell/prestera/Makefile     |    7 +
 drivers/net/ethernet/marvell/prestera/prestera.h   |  206 ++
 .../ethernet/marvell/prestera/prestera_devlink.c   |  112 +
 .../ethernet/marvell/prestera/prestera_devlink.h   |   23 +
 .../net/ethernet/marvell/prestera/prestera_dsa.c   |  104 +
 .../net/ethernet/marvell/prestera/prestera_dsa.h   |   35 +
 .../ethernet/marvell/prestera/prestera_ethtool.c   |  780 +++++
 .../ethernet/marvell/prestera/prestera_ethtool.h   |   11 +
 .../net/ethernet/marvell/prestera/prestera_hw.c    | 1253 +++++++
 .../net/ethernet/marvell/prestera/prestera_hw.h    |  182 +
 .../net/ethernet/marvell/prestera/prestera_main.c  |  667 ++++
 .../net/ethernet/marvell/prestera/prestera_pci.c   |  769 +++++
 .../net/ethernet/marvell/prestera/prestera_rxtx.c  |  820 +++++
 .../net/ethernet/marvell/prestera/prestera_rxtx.h  |   19 +
 .../ethernet/marvell/prestera/prestera_switchdev.c | 1277 +++++++
 .../ethernet/marvell/prestera/prestera_switchdev.h |   13 +
 drivers/net/ethernet/marvell/pxa168_eth.c          |    7 +-
 drivers/net/ethernet/marvell/skge.c                |    6 +-
 drivers/net/ethernet/mellanox/mlx4/cq.c            |    4 +-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |   19 +
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |    5 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |    5 +-
 drivers/net/ethernet/mellanox/mlx4/eq.c            |    3 +-
 drivers/net/ethernet/mellanox/mlx4/main.c          |   18 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |    2 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4_stats.h    |   12 +
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |    9 +-
 drivers/net/ethernet/mellanox/mlx5/core/alloc.c    |   12 +-
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c      |   14 +-
 drivers/net/ethernet/mellanox/mlx5/core/cq.c       |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  116 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |   58 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.h   |    1 +
 .../ethernet/mellanox/mlx5/core/diag/rsc_dump.c    |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/ecpf.c     |    8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   50 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h    |    8 +-
 .../net/ethernet/mellanox/mlx5/core/en/health.c    |    2 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |   22 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  527 +--
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.h |   75 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |   83 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   42 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h   |   60 +-
 .../mellanox/mlx5/core/en/xsk/{umem.c =3D> pool.c}   |  112 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/pool.h  |   27 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    |    8 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/rx.h    |   10 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   12 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.h |    2 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |   16 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.h    |    6 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/umem.h  |   29 -
 .../mellanox/mlx5/core/en_accel/en_accel.h         |   66 +-
 .../ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c  |    2 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |    3 +
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   |    2 +
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         |  182 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       |  110 +-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       |   29 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |    4 +-
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |    3 -
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h        |   20 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c         |    8 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   27 +-
 .../ethernet/mellanox/mlx5/core/en_fs_ethtool.c    |    2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   91 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  106 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |    1 -
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   50 +-
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c  |    3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   35 +
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |    7 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  881 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |   97 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  663 +++-
 drivers/net/ethernet/mellanox/mlx5/core/eq.c       |    3 +-
 .../mellanox/mlx5/core/esw/acl/egress_ofld.c       |    8 +
 .../net/ethernet/mellanox/mlx5/core/esw/chains.c   |  944 ------
 .../net/ethernet/mellanox/mlx5/core/esw/chains.h   |   68 -
 .../ethernet/mellanox/mlx5/core/esw/devlink_port.c |  124 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   44 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  505 ++-
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |    8 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/conn.c    |   11 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |    3 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   24 +-
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c |  463 +++
 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h |   21 +
 drivers/net/ethernet/mellanox/mlx5/core/health.c   |   35 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.c      |   66 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag.h      |    7 +
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   |    9 +-
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    |   63 +-
 drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h   |    2 +-
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    |  911 +++++
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.h    |   93 +
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |   18 +-
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |    7 +
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    |    4 +-
 .../mellanox/mlx5/core/steering/dr_matcher.c       |   22 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |   47 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |    8 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |  183 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |   24 +-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |    3 +-
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |    3 +-
 drivers/net/ethernet/mellanox/mlxsw/core.c         |  642 +++-
 drivers/net/ethernet/mellanox/mlxsw/core.h         |   14 +-
 drivers/net/ethernet/mellanox/mlxsw/core_env.c     |  368 ++
 drivers/net/ethernet/mellanox/mlxsw/core_env.h     |    6 +
 drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c   |  173 +-
 drivers/net/ethernet/mellanox/mlxsw/pci.c          |   12 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h          |  239 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  594 +---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h     |   91 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_buffers.c |  377 ++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c |  163 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_ethtool.c |  204 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ptp.c |   32 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_qdisc.c   |   34 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |    6 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c    |  120 +-
 .../net/ethernet/mellanox/mlxsw/spectrum_span.h    |    1 -
 .../net/ethernet/mellanox/mlxsw/spectrum_trap.c    |   22 +-
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c     |   25 +-
 drivers/net/ethernet/mellanox/mlxsw/trap.h         |    6 +
 drivers/net/ethernet/micrel/ks8842.c               |   17 +-
 drivers/net/ethernet/micrel/ksz884x.c              |   76 +-
 drivers/net/ethernet/microchip/encx24j600-regmap.c |    2 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |   11 +-
 drivers/net/ethernet/mscc/ocelot.c                 |  114 +-
 drivers/net/ethernet/mscc/ocelot.h                 |    2 +
 drivers/net/ethernet/mscc/ocelot_flower.c          |  565 +++-
 drivers/net/ethernet/mscc/ocelot_io.c              |   17 +
 drivers/net/ethernet/mscc/ocelot_net.c             |   61 +-
 drivers/net/ethernet/mscc/ocelot_ptp.c             |    3 +-
 drivers/net/ethernet/mscc/ocelot_s2.h              |   64 -
 drivers/net/ethernet/mscc/ocelot_vcap.c            |  856 +++--
 drivers/net/ethernet/mscc/ocelot_vcap.h            |   99 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c         |  195 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |    5 +-
 drivers/net/ethernet/natsemi/natsemi.c             |   63 +-
 drivers/net/ethernet/natsemi/ns83820.c             |   77 +-
 drivers/net/ethernet/natsemi/sonic.c               |   24 +-
 drivers/net/ethernet/natsemi/sonic.h               |    2 +-
 drivers/net/ethernet/neterion/s2io.c               |   91 +-
 drivers/net/ethernet/neterion/vxge/vxge-config.c   |   14 +-
 drivers/net/ethernet/neterion/vxge/vxge-config.h   |    7 +-
 drivers/net/ethernet/neterion/vxge/vxge-ethtool.c  |    2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.c     |   12 +-
 drivers/net/ethernet/neterion/vxge/vxge-traffic.c  |   72 +-
 drivers/net/ethernet/netronome/nfp/bpf/offload.c   |   18 +-
 drivers/net/ethernet/netronome/nfp/flower/cmsg.h   |   17 +
 drivers/net/ethernet/netronome/nfp/flower/main.h   |    6 +-
 drivers/net/ethernet/netronome/nfp/flower/match.c  |   73 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |   85 +-
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c   |    9 +-
 .../net/ethernet/netronome/nfp/nfp_net_common.c    |    7 +-
 drivers/net/ethernet/ni/nixge.c                    |    7 +-
 .../ethernet/oki-semi/pch_gbe/pch_gbe_ethtool.c    |    4 +-
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c   |    5 +-
 .../net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c  |   14 +-
 drivers/net/ethernet/packetengines/yellowfin.c     |    2 +-
 drivers/net/ethernet/pensando/Kconfig              |    1 +
 drivers/net/ethernet/pensando/ionic/Makefile       |    2 +-
 drivers/net/ethernet/pensando/ionic/ionic.h        |    7 +-
 .../net/ethernet/pensando/ionic/ionic_bus_pci.c    |   47 +-
 .../net/ethernet/pensando/ionic/ionic_debugfs.c    |   31 +-
 drivers/net/ethernet/pensando/ionic/ionic_dev.c    |   87 +-
 drivers/net/ethernet/pensando/ionic/ionic_dev.h    |   73 +-
 .../net/ethernet/pensando/ionic/ionic_devlink.c    |   12 +-
 .../net/ethernet/pensando/ionic/ionic_devlink.h    |    3 +
 .../net/ethernet/pensando/ionic/ionic_ethtool.c    |  198 +-
 drivers/net/ethernet/pensando/ionic/ionic_fw.c     |  206 ++
 drivers/net/ethernet/pensando/ionic/ionic_if.h     |   34 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c    | 1076 +++---
 drivers/net/ethernet/pensando/ionic/ionic_lif.h    |  115 +-
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |  101 +-
 drivers/net/ethernet/pensando/ionic/ionic_stats.c  |   48 +-
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c   |  182 +-
 drivers/net/ethernet/qlogic/Kconfig                |    5 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic.h    |    3 -
 .../ethernet/qlogic/netxen/netxen_nic_ethtool.c    |    3 +
 drivers/net/ethernet/qlogic/qed/Makefile           |    1 +
 drivers/net/ethernet/qlogic/qed/qed.h              |    5 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |    9 +
 drivers/net/ethernet/qlogic/qed/qed_devlink.c      |  259 ++
 drivers/net/ethernet/qlogic/qed/qed_devlink.h      |   20 +
 drivers/net/ethernet/qlogic/qed/qed_int.c          |   27 +-
 drivers/net/ethernet/qlogic/qed/qed_int.h          |    2 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c          |   18 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.h          |    8 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c         |  130 +-
 drivers/net/ethernet/qlogic/qed/qed_rdma.c         |    9 +-
 drivers/net/ethernet/qlogic/qede/qede.h            |    2 +
 drivers/net/ethernet/qlogic/qede/qede_main.c       |   38 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |   10 +-
 drivers/net/ethernet/qualcomm/emac/emac.c          |    1 +
 drivers/net/ethernet/qualcomm/qca_uart.c           |    2 +-
 drivers/net/ethernet/realtek/8139cp.c              |    4 +-
 drivers/net/ethernet/realtek/8139too.c             |    2 +-
 drivers/net/ethernet/realtek/r8169_main.c          |   56 +-
 drivers/net/ethernet/renesas/ravb.h                |    5 +-
 drivers/net/ethernet/renesas/ravb_main.c           |   55 +-
 drivers/net/ethernet/renesas/sh_eth.c              |   12 +-
 drivers/net/ethernet/rocker/rocker_main.c          |   83 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c    |   17 +-
 drivers/net/ethernet/sfc/ef10.c                    |  152 +-
 drivers/net/ethernet/sfc/ef100_ethtool.c           |   41 +
 drivers/net/ethernet/sfc/ef100_netdev.c            |    4 +
 drivers/net/ethernet/sfc/ef100_nic.c               |   23 +-
 drivers/net/ethernet/sfc/ef100_tx.c                |   44 +-
 drivers/net/ethernet/sfc/ef100_tx.h                |    1 -
 drivers/net/ethernet/sfc/efx.c                     |   21 +-
 drivers/net/ethernet/sfc/efx_channels.c            |   15 +-
 drivers/net/ethernet/sfc/efx_channels.h            |    2 -
 drivers/net/ethernet/sfc/efx_common.c              |  124 +-
 drivers/net/ethernet/sfc/efx_common.h              |    3 +
 drivers/net/ethernet/sfc/ethtool.c                 |    3 +-
 drivers/net/ethernet/sfc/ethtool_common.c          |   47 +-
 drivers/net/ethernet/sfc/falcon/farch.c            |   29 +-
 drivers/net/ethernet/sfc/falcon/rx.c               |    2 +
 drivers/net/ethernet/sfc/falcon/selftest.c         |    2 +-
 drivers/net/ethernet/sfc/farch.c                   |   33 +-
 drivers/net/ethernet/sfc/mcdi.c                    |    6 +-
 drivers/net/ethernet/sfc/mcdi.h                    |    4 +-
 drivers/net/ethernet/sfc/mcdi_functions.c          |   24 +-
 drivers/net/ethernet/sfc/mcdi_functions.h          |    2 +-
 drivers/net/ethernet/sfc/mcdi_port.c               |  593 +---
 drivers/net/ethernet/sfc/mcdi_port_common.c        |  605 +++-
 drivers/net/ethernet/sfc/mcdi_port_common.h        |   15 +-
 drivers/net/ethernet/sfc/net_driver.h              |  131 +-
 drivers/net/ethernet/sfc/nic.h                     |    4 +
 drivers/net/ethernet/sfc/nic_common.h              |   47 +-
 drivers/net/ethernet/sfc/ptp.c                     |   12 +-
 drivers/net/ethernet/sfc/selftest.c                |   18 +-
 drivers/net/ethernet/sfc/selftest.h                |    4 +-
 drivers/net/ethernet/sfc/siena.c                   |    1 -
 drivers/net/ethernet/sfc/tx.c                      |  136 +-
 drivers/net/ethernet/sfc/tx.h                      |   26 +
 drivers/net/ethernet/sfc/tx_common.c               |   19 +-
 drivers/net/ethernet/silan/sc92031.c               |   40 +-
 drivers/net/ethernet/sis/sis900.c                  |    8 +-
 drivers/net/ethernet/smsc/epic100.c                |   71 +-
 drivers/net/ethernet/smsc/smc91x.c                 |   13 +-
 drivers/net/ethernet/smsc/smsc911x.c               |    6 +-
 drivers/net/ethernet/smsc/smsc9420.c               |   51 +-
 drivers/net/ethernet/socionext/sni_ave.c           |   32 +-
 drivers/net/ethernet/stmicro/stmmac/Kconfig        |   12 +-
 drivers/net/ethernet/stmicro/stmmac/Makefile       |    1 +
 drivers/net/ethernet/stmicro/stmmac/chain_mode.c   |    7 +-
 drivers/net/ethernet/stmicro/stmmac/common.h       |   17 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c    |    3 +-
 .../net/ethernet/stmicro/stmmac/dwmac-intel-plat.c |  196 ++
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c  |   14 +
 drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c     |    2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h       |    1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   15 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c |    3 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac5.h       |    6 +
 .../net/ethernet/stmicro/stmmac/dwxgmac2_descs.c   |    3 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h         |    4 +-
 drivers/net/ethernet/stmicro/stmmac/ring_mode.c    |    2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac.h       |    4 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |   55 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  297 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |    3 +-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |    2 +-
 drivers/net/ethernet/sun/cassini.c                 |    4 +-
 drivers/net/ethernet/sun/sunbmac.c                 |   18 +-
 drivers/net/ethernet/sun/sungem.c                  |    5 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-common.c  |    2 +-
 drivers/net/ethernet/tehuti/tehuti.c               |   70 +-
 drivers/net/ethernet/ti/am65-cpsw-ethtool.c        |   10 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |   16 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h           |    1 +
 drivers/net/ethernet/ti/am65-cpts.c                |   43 +-
 drivers/net/ethernet/ti/cpsw.c                     |   10 +-
 drivers/net/ethernet/ti/cpsw_ale.c                 |  421 ++-
 drivers/net/ethernet/ti/cpsw_ale.h                 |    7 +
 drivers/net/ethernet/ti/cpsw_ethtool.c             |    3 +-
 drivers/net/ethernet/ti/cpsw_new.c                 |    3 -
 drivers/net/ethernet/ti/cpsw_priv.c                |    2 +-
 drivers/net/ethernet/ti/cpsw_priv.h                |    2 -
 drivers/net/ethernet/ti/cpts.c                     |   42 +-
 drivers/net/ethernet/ti/davinci_cpdma.c            |    2 +-
 drivers/net/ethernet/ti/davinci_emac.c             |   10 +-
 drivers/net/ethernet/ti/netcp_ethss.c              |   18 +-
 drivers/net/ethernet/ti/tlan.c                     |   67 +-
 drivers/net/ethernet/toshiba/tc35815.c             |   48 +-
 drivers/net/ethernet/via/via-rhine.c               |    2 +-
 drivers/net/ethernet/via/via-velocity.c            |   40 +-
 drivers/net/ethernet/xilinx/ll_temac_main.c        |   26 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |    3 +-
 drivers/net/fddi/skfp/h/smc.h                      |    2 +-
 drivers/net/geneve.c                               |   11 +-
 drivers/net/gtp.c                                  |   74 +-
 drivers/net/hippi/rrunner.c                        |  117 +-
 drivers/net/ieee802154/mac802154_hwsim.c           |    6 +-
 drivers/net/ipa/gsi.c                              |   32 +-
 drivers/net/ipa/gsi.h                              |    1 -
 drivers/net/ipa/gsi_reg.h                          |   59 +-
 drivers/net/ipa/gsi_trans.c                        |    1 -
 drivers/net/ipa/ipa.h                              |   17 +-
 drivers/net/ipa/ipa_clock.c                        |   28 +-
 drivers/net/ipa/ipa_endpoint.c                     |   53 +-
 drivers/net/ipa/ipa_interrupt.c                    |   14 +
 drivers/net/ipa/ipa_main.c                         |   72 +-
 drivers/net/ipa/ipa_reg.h                          |    2 +-
 drivers/net/ipa/ipa_uc.c                           |    2 +-
 drivers/net/ipvlan/ipvlan_main.c                   |    8 +
 drivers/net/macsec.c                               |   30 +-
 drivers/net/mdio/Kconfig                           |  251 ++
 drivers/net/mdio/Makefile                          |   29 +
 drivers/net/{phy =3D> mdio}/mdio-aspeed.c            |    0
 drivers/net/{phy =3D> mdio}/mdio-bcm-iproc.c         |    0
 drivers/net/{phy =3D> mdio}/mdio-bcm-unimac.c        |    0
 drivers/net/{phy =3D> mdio}/mdio-bitbang.c           |    0
 drivers/net/{phy =3D> mdio}/mdio-cavium.c            |    0
 drivers/net/{phy =3D> mdio}/mdio-cavium.h            |    0
 drivers/net/{phy =3D> mdio}/mdio-gpio.c              |    0
 drivers/net/{phy =3D> mdio}/mdio-hisi-femac.c        |    0
 drivers/net/{phy =3D> mdio}/mdio-i2c.c               |    3 +-
 drivers/net/{phy =3D> mdio}/mdio-ipq4019.c           |  109 +-
 drivers/net/{phy =3D> mdio}/mdio-ipq8064.c           |    0
 drivers/net/{phy =3D> mdio}/mdio-moxart.c            |    0
 drivers/net/{phy =3D> mdio}/mdio-mscc-miim.c         |    0
 drivers/net/{phy =3D> mdio}/mdio-mux-bcm-iproc.c     |    0
 drivers/net/{phy =3D> mdio}/mdio-mux-gpio.c          |    0
 drivers/net/{phy =3D> mdio}/mdio-mux-meson-g12a.c    |    0
 drivers/net/{phy =3D> mdio}/mdio-mux-mmioreg.c       |    0
 drivers/net/{phy =3D> mdio}/mdio-mux-multiplexer.c   |    0
 drivers/net/{phy =3D> mdio}/mdio-mux.c               |    0
 drivers/net/{phy =3D> mdio}/mdio-mvusb.c             |    0
 drivers/net/{phy =3D> mdio}/mdio-octeon.c            |    0
 drivers/net/{phy =3D> mdio}/mdio-sun4i.c             |    0
 drivers/net/{phy =3D> mdio}/mdio-thunder.c           |    0
 drivers/net/{phy =3D> mdio}/mdio-xgene.c             |    2 +-
 drivers/{of =3D> net/mdio}/of_mdio.c                 |   38 +-
 drivers/net/netdevsim/Makefile                     |    2 +-
 drivers/net/netdevsim/dev.c                        |   35 +-
 drivers/net/netdevsim/ethtool.c                    |   64 +
 drivers/net/netdevsim/netdev.c                     |    1 +
 drivers/net/netdevsim/netdevsim.h                  |   20 +-
 drivers/net/netdevsim/udp_tunnels.c                |   34 +-
 drivers/net/pcs/Kconfig                            |   22 +
 drivers/net/pcs/Makefile                           |    5 +
 drivers/net/pcs/pcs-lynx.c                         |  318 ++
 drivers/net/{phy/mdio-xpcs.c =3D> pcs/pcs-xpcs.c}    |    2 +-
 drivers/net/phy/Kconfig                            |  405 +--
 drivers/net/phy/Makefile                           |   37 +-
 drivers/net/phy/at803x.c                           |    4 +-
 drivers/net/phy/bcm7xxx.c                          |   32 +-
 drivers/net/phy/dp83640.c                          |   70 +-
 drivers/net/phy/dp83822.c                          |  232 +-
 drivers/net/phy/dp83867.c                          |   45 +-
 drivers/net/phy/dp83869.c                          |  365 ++
 drivers/net/phy/marvell.c                          |   14 +-
 drivers/net/phy/mdio_bus.c                         |   15 -
 drivers/net/phy/micrel.c                           |   14 +
 drivers/net/phy/mscc/mscc_macsec.c                 |    2 +-
 drivers/net/phy/phy-core.c                         |   36 +-
 drivers/net/phy/phy.c                              |   69 +-
 drivers/net/phy/phylink.c                          |   48 +-
 drivers/net/phy/realtek.c                          |   47 +-
 drivers/net/phy/sfp.c                              |    2 +-
 drivers/net/phy/smsc.c                             |  126 +-
 drivers/net/phy/spi_ks8995.c                       |    4 +-
 drivers/net/team/team.c                            |    6 +-
 drivers/net/tun.c                                  |   18 -
 drivers/net/usb/Kconfig                            |    2 +
 drivers/net/usb/cx82310_eth.c                      |   78 +-
 drivers/net/usb/kaweth.c                           |  261 +-
 drivers/net/usb/net1080.c                          |    1 -
 drivers/net/usb/qmi_wwan.c                         |   24 +-
 drivers/net/usb/smsc75xx.c                         |   13 +-
 drivers/net/usb/smsc95xx.c                         |  488 +--
 drivers/net/usb/usbnet.c                           |   30 +-
 drivers/net/veth.c                                 |   18 +-
 drivers/net/virtio_net.c                           |   55 +-
 drivers/net/vxlan.c                                |   22 +-
 drivers/net/wan/fsl_ucc_hdlc.c                     |    1 +
 drivers/net/wan/hdlc_fr.c                          |  172 +-
 drivers/net/wan/lmc/lmc_debug.c                    |   18 -
 drivers/net/wan/lmc/lmc_debug.h                    |    1 -
 drivers/net/wan/lmc/lmc_main.c                     |  105 +-
 drivers/net/wan/lmc/lmc_media.c                    |    4 -
 drivers/net/wan/lmc/lmc_proto.c                    |   16 -
 drivers/net/wan/sbni.c                             |  101 +-
 drivers/net/wan/slic_ds26522.c                     |    2 -
 drivers/net/wan/x25_asy.c                          |    5 +-
 drivers/net/wan/x25_asy.h                          |    1 -
 drivers/net/wimax/i2400m/control.c                 |    2 -
 drivers/net/wireguard/netlink.c                    |   14 +-
 drivers/net/wireless/admtek/adm8211.c              |   83 +-
 drivers/net/wireless/ath/ath10k/bmi.c              |   10 +-
 drivers/net/wireless/ath/ath10k/ce.c               |   81 +-
 drivers/net/wireless/ath/ath10k/ce.h               |   15 +-
 drivers/net/wireless/ath/ath10k/core.c             |   55 +-
 drivers/net/wireless/ath/ath10k/core.h             |   22 +
 drivers/net/wireless/ath/ath10k/coredump.c         |  349 +-
 drivers/net/wireless/ath/ath10k/coredump.h         |    1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c           |   26 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c           |    6 +-
 drivers/net/wireless/ath/ath10k/hw.h               |    3 -
 drivers/net/wireless/ath/ath10k/mac.c              |  929 ++++-
 drivers/net/wireless/ath/ath10k/pci.c              |    2 +-
 drivers/net/wireless/ath/ath10k/qmi.c              |    8 +
 drivers/net/wireless/ath/ath10k/sdio.c             |  331 +-
 drivers/net/wireless/ath/ath10k/snoc.c             |   29 +-
 drivers/net/wireless/ath/ath10k/snoc.h             |    1 +
 drivers/net/wireless/ath/ath10k/targaddrs.h        |   11 +
 drivers/net/wireless/ath/ath10k/txrx.c             |   11 +-
 drivers/net/wireless/ath/ath10k/wmi-ops.h          |   19 +
 drivers/net/wireless/ath/ath10k/wmi-tlv.h          |    2 +
 drivers/net/wireless/ath/ath10k/wmi.c              |   73 +-
 drivers/net/wireless/ath/ath10k/wmi.h              |   76 +
 drivers/net/wireless/ath/ath10k/wow.c              |    2 +-
 drivers/net/wireless/ath/ath11k/Kconfig            |   18 +-
 drivers/net/wireless/ath/ath11k/Makefile           |   12 +-
 drivers/net/wireless/ath/ath11k/ahb.c              |  455 +--
 drivers/net/wireless/ath/ath11k/ahb.h              |    8 +
 drivers/net/wireless/ath/ath11k/ce.c               |  224 +-
 drivers/net/wireless/ath/ath11k/ce.h               |   15 +-
 drivers/net/wireless/ath/ath11k/core.c             |  291 +-
 drivers/net/wireless/ath/ath11k/core.h             |   79 +-
 drivers/net/wireless/ath/ath11k/dbring.c           |    2 +-
 drivers/net/wireless/ath/ath11k/debug.c            | 1104 +-----
 drivers/net/wireless/ath/ath11k/debug.h            |  247 +-
 drivers/net/wireless/ath/ath11k/debugfs.c          | 1097 ++++++
 drivers/net/wireless/ath/ath11k/debugfs.h          |  217 ++
 .../{debug_htt_stats.c =3D> debugfs_htt_stats.c}     |   56 +-
 .../{debug_htt_stats.h =3D> debugfs_htt_stats.h}     |   27 +-
 drivers/net/wireless/ath/ath11k/debugfs_sta.c      |   29 +-
 drivers/net/wireless/ath/ath11k/debugfs_sta.h      |   44 +
 drivers/net/wireless/ath/ath11k/dp.c               |  316 +-
 drivers/net/wireless/ath/ath11k/dp.h               |   40 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  375 ++-
 drivers/net/wireless/ath/ath11k/dp_rx.h            |    6 +-
 drivers/net/wireless/ath/ath11k/dp_tx.c            |  200 +-
 drivers/net/wireless/ath/ath11k/hal.c              |  306 +-
 drivers/net/wireless/ath/ath11k/hal.h              |  198 +-
 drivers/net/wireless/ath/ath11k/hal_rx.c           |   16 +-
 drivers/net/wireless/ath/ath11k/hal_rx.h           |    2 +-
 drivers/net/wireless/ath/ath11k/hal_tx.c           |    2 +-
 drivers/net/wireless/ath/ath11k/hif.h              |   30 +
 drivers/net/wireless/ath/ath11k/htc.c              |   19 +-
 drivers/net/wireless/ath/ath11k/hw.c               |  894 +++++
 drivers/net/wireless/ath/ath11k/hw.h               |  152 +-
 drivers/net/wireless/ath/ath11k/mac.c              |  412 ++-
 drivers/net/wireless/ath/ath11k/mhi.c              |  467 +++
 drivers/net/wireless/ath/ath11k/mhi.h              |   39 +
 drivers/net/wireless/ath/ath11k/pci.c              | 1062 ++++++
 drivers/net/wireless/ath/ath11k/pci.h              |   72 +
 drivers/net/wireless/ath/ath11k/peer.c             |    3 -
 drivers/net/wireless/ath/ath11k/qmi.c              |  357 +-
 drivers/net/wireless/ath/ath11k/qmi.h              |   29 +-
 drivers/net/wireless/ath/ath11k/reg.c              |    8 +-
 drivers/net/wireless/ath/ath11k/spectral.c         |   36 +-
 drivers/net/wireless/ath/ath11k/thermal.c          |    2 +-
 drivers/net/wireless/ath/ath11k/wmi.c              |  154 +-
 drivers/net/wireless/ath/ath5k/ath5k.h             |    2 +-
 drivers/net/wireless/ath/ath5k/base.c              |   26 +-
 drivers/net/wireless/ath/ath5k/debug.c             |   25 +-
 drivers/net/wireless/ath/ath5k/eeprom.c            |    4 +-
 drivers/net/wireless/ath/ath5k/pcu.c               |    6 +-
 drivers/net/wireless/ath/ath5k/phy.c               |    6 +-
 drivers/net/wireless/ath/ath5k/reset.c             |    2 +-
 drivers/net/wireless/ath/ath5k/rfbuffer.h          |    2 +-
 drivers/net/wireless/ath/ath5k/rfkill.c            |    7 +-
 drivers/net/wireless/ath/ath6kl/cfg80211.c         |    6 +-
 drivers/net/wireless/ath/ath6kl/init.c             |    2 +-
 drivers/net/wireless/ath/ath6kl/main.c             |    5 +-
 drivers/net/wireless/ath/ath6kl/wmi.c              |   15 +-
 drivers/net/wireless/ath/ath9k/Kconfig             |   12 +-
 drivers/net/wireless/ath/ath9k/ani.c               |    2 +-
 drivers/net/wireless/ath/ath9k/ar5008_initvals.h   |   68 -
 drivers/net/wireless/ath/ath9k/ar5008_phy.c        |   35 +-
 drivers/net/wireless/ath/ath9k/ar9001_initvals.h   |   37 -
 drivers/net/wireless/ath/ath9k/ar9002_initvals.h   |   14 -
 drivers/net/wireless/ath/ath9k/ar9002_mac.c        |    2 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.c        |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_mac.c        |    2 +-
 .../net/wireless/ath/ath9k/ar9580_1p0_initvals.h   |   21 -
 drivers/net/wireless/ath/ath9k/ath9k.h             |    4 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |    6 +-
 drivers/net/wireless/ath/ath9k/channel.c           |    4 +-
 drivers/net/wireless/ath/ath9k/eeprom_def.c        |    2 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   21 +-
 drivers/net/wireless/ath/ath9k/htc.h               |    4 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c    |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |    8 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   10 +-
 drivers/net/wireless/ath/ath9k/htc_hst.c           |    2 +
 drivers/net/wireless/ath/ath9k/hw.c                |    6 +-
 drivers/net/wireless/ath/ath9k/init.c              |    6 +-
 drivers/net/wireless/ath/ath9k/main.c              |   18 +-
 drivers/net/wireless/ath/ath9k/pci.c               |    5 +-
 drivers/net/wireless/ath/ath9k/wmi.c               |    9 +-
 drivers/net/wireless/ath/ath9k/wmi.h               |    4 +-
 drivers/net/wireless/ath/carl9170/carl9170.h       |    5 +-
 drivers/net/wireless/ath/carl9170/main.c           |    2 +-
 drivers/net/wireless/ath/carl9170/rx.c             |    2 +-
 drivers/net/wireless/ath/carl9170/tx.c             |   12 +-
 drivers/net/wireless/ath/carl9170/usb.c            |    7 +-
 drivers/net/wireless/ath/dfs_pattern_detector.c    |   15 +-
 drivers/net/wireless/ath/wcn36xx/dxe.c             |   57 +-
 drivers/net/wireless/ath/wcn36xx/hal.h             |  222 +-
 drivers/net/wireless/ath/wcn36xx/main.c            |  288 +-
 drivers/net/wireless/ath/wcn36xx/pmc.c             |    7 +-
 drivers/net/wireless/ath/wcn36xx/smd.c             |  757 +++--
 drivers/net/wireless/ath/wcn36xx/smd.h             |   12 +-
 drivers/net/wireless/ath/wcn36xx/txrx.c            |  279 +-
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h         |   18 +-
 drivers/net/wireless/ath/wil6210/cfg80211.c        |    4 +-
 drivers/net/wireless/ath/wil6210/debugfs.c         |    8 +-
 drivers/net/wireless/ath/wil6210/interrupt.c       |    4 +-
 drivers/net/wireless/ath/wil6210/pmc.c             |   12 +-
 drivers/net/wireless/ath/wil6210/txrx.c            |   30 +-
 drivers/net/wireless/ath/wil6210/txrx_edma.c       |   10 +-
 drivers/net/wireless/ath/wil6210/wil_platform.c    |    3 +-
 drivers/net/wireless/ath/wil6210/wmi.c             |   36 +-
 drivers/net/wireless/atmel/at76c50x-usb.c          |   11 +-
 drivers/net/wireless/atmel/atmel.c                 |    4 +-
 drivers/net/wireless/broadcom/b43/dma.c            |    2 +-
 drivers/net/wireless/broadcom/b43/main.c           |   14 +-
 drivers/net/wireless/broadcom/b43/phy_common.c     |    2 +-
 drivers/net/wireless/broadcom/b43/phy_ht.c         |    3 -
 drivers/net/wireless/broadcom/b43/phy_n.c          |   21 +-
 drivers/net/wireless/broadcom/b43/pio.c            |    2 +-
 drivers/net/wireless/broadcom/b43/tables_nphy.c    |    2 +-
 drivers/net/wireless/broadcom/b43legacy/dma.c      |    2 +-
 drivers/net/wireless/broadcom/b43legacy/main.c     |   15 +-
 drivers/net/wireless/broadcom/b43legacy/pio.c      |    7 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    |    4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |   10 +-
 .../wireless/broadcom/brcm80211/brcmfmac/btcoex.c  |   12 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |    3 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   62 +-
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |   14 +
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   39 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |    1 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |    4 +-
 .../broadcom/brcm80211/brcmfmac/firmware.c         |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |   31 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.h    |    7 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.c         |   30 +-
 .../broadcom/brcm80211/brcmfmac/fwsignal.h         |    2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |    9 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/p2p.c |   31 +-
 .../wireless/broadcom/brcm80211/brcmfmac/proto.h   |    6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   15 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |    2 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |    5 +-
 .../wireless/broadcom/brcm80211/brcmsmac/ampdu.c   |   35 +-
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c      |   17 +-
 .../broadcom/brcm80211/brcmsmac/mac80211_if.h      |    2 +-
 .../wireless/broadcom/brcm80211/brcmsmac/main.c    |   47 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_cmn.c      |    6 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_lcn.c      |   99 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_n.c        |   47 +-
 .../broadcom/brcm80211/brcmsmac/phy/phytbl_lcn.c   |  112 -
 .../broadcom/brcm80211/brcmsmac/phy/phytbl_n.c     |  268 --
 drivers/net/wireless/cisco/airo.c                  |  913 ++---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |   12 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c       |   52 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.h       |    6 +-
 drivers/net/wireless/intel/ipw2x00/libipw.h        |    3 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c     |   34 +-
 drivers/net/wireless/intel/iwlegacy/3945-rs.c      |    8 +-
 drivers/net/wireless/intel/iwlegacy/3945.c         |   46 +-
 drivers/net/wireless/intel/iwlegacy/4965-calib.c   |    2 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |   67 +-
 drivers/net/wireless/intel/iwlegacy/4965-rs.c      |   10 +-
 drivers/net/wireless/intel/iwlegacy/4965.c         |   25 +-
 drivers/net/wireless/intel/iwlegacy/common.c       |   76 +-
 drivers/net/wireless/intel/iwlegacy/common.h       |    4 +-
 drivers/net/wireless/intel/iwlegacy/debug.c        |    3 +-
 drivers/net/wireless/intel/iwlwifi/Makefile        |    3 +-
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     |   70 +-
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c      |   17 +-
 drivers/net/wireless/intel/iwlwifi/dvm/calib.c     |    2 +-
 drivers/net/wireless/intel/iwlwifi/dvm/devices.c   |    8 +-
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c       |    4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/main.c      |   11 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c        |   12 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c        |    4 +-
 drivers/net/wireless/intel/iwlwifi/dvm/rxon.c      |    6 +-
 drivers/net/wireless/intel/iwlwifi/dvm/scan.c      |    8 +-
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c       |   22 +-
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c        |    4 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.c       |   92 +-
 drivers/net/wireless/intel/iwlwifi/fw/acpi.h       |   59 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/alive.h  |   25 +-
 .../net/wireless/intel/iwlwifi/fw/api/binding.h    |   16 +-
 .../net/wireless/intel/iwlwifi/fw/api/commands.h   |   16 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/d3.h     |   82 +-
 .../net/wireless/intel/iwlwifi/fw/api/dbg-tlv.h    |   32 +-
 .../net/wireless/intel/iwlwifi/fw/api/location.h   |  231 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/mac.h    |   18 +-
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    |   13 +
 .../net/wireless/intel/iwlwifi/fw/api/phy-ctxt.h   |   32 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/phy.h    |   13 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h  |  133 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rs.h     |   18 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/rx.h     |   29 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/sta.h    |    2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/stats.h  |  471 ++-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h     |    7 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |   56 +
 drivers/net/wireless/intel/iwlwifi/fw/error-dump.h |   14 +
 drivers/net/wireless/intel/iwlwifi/fw/file.h       |   12 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.c        |   55 +-
 drivers/net/wireless/intel/iwlwifi/fw/img.h        |    9 +-
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |    3 +-
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c       |  274 ++
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.h       |   18 +
 drivers/net/wireless/intel/iwlwifi/fw/runtime.h    |    3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   14 +-
 .../wireless/intel/iwlwifi/iwl-context-info-gen3.h |   21 +-
 .../net/wireless/intel/iwlwifi/iwl-context-info.h  |    7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |   26 +-
 drivers/net/wireless/intel/iwlwifi/iwl-debug.c     |    5 +-
 drivers/net/wireless/intel/iwlwifi/iwl-debug.h     |    6 +-
 .../net/wireless/intel/iwlwifi/iwl-devtrace-msg.h  |    6 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |   20 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |   98 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h |    2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h      |    1 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c     |   76 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |   53 +-
 drivers/net/wireless/intel/iwlwifi/mvm/binding.c   |   11 +-
 drivers/net/wireless/intel/iwlwifi/mvm/constants.h |    8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c        |  294 +-
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c   |    4 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-initiator.c |  363 +-
 .../net/wireless/intel/iwlwifi/mvm/ftm-responder.c |  203 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  459 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |   24 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  118 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   59 +-
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   33 +-
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c  |  123 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |   32 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c        |    6 +
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |  197 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   87 +-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      |  107 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |   84 +-
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |    8 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tdls.c      |   12 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.c    |   51 +-
 .../net/wireless/intel/iwlwifi/mvm/time-event.h    |    7 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tt.c        |   82 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   99 +-
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c     |   53 +-
 .../wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   |   27 +
 .../net/wireless/intel/iwlwifi/pcie/ctxt-info.c    |   23 +-
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   41 +-
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  161 +-
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |    2 +-
 .../net/wireless/intel/iwlwifi/pcie/trans-gen2.c   |    4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |  137 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  | 1089 +-----
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  530 +--
 drivers/net/wireless/intel/iwlwifi/queue/tx.c      | 1529 +++++++++
 drivers/net/wireless/intel/iwlwifi/queue/tx.h      |  230 ++
 drivers/net/wireless/intersil/hostap/hostap.h      |    6 +-
 drivers/net/wireless/intersil/hostap/hostap_ap.c   |    2 +-
 drivers/net/wireless/intersil/hostap/hostap_hw.c   |   33 +-
 .../net/wireless/intersil/hostap/hostap_ioctl.c    |    3 +-
 drivers/net/wireless/intersil/orinoco/main.c       |   11 +-
 .../net/wireless/intersil/orinoco/orinoco_usb.c    |   14 +-
 drivers/net/wireless/intersil/p54/p54pci.c         |   12 +-
 drivers/net/wireless/intersil/prism54/isl_38xx.c   |    2 +-
 drivers/net/wireless/intersil/prism54/isl_ioctl.c  |    5 +-
 drivers/net/wireless/intersil/prism54/islpci_dev.c |    2 +-
 drivers/net/wireless/mac80211_hwsim.c              |  108 +-
 drivers/net/wireless/marvell/libertas/defs.h       |    3 +-
 drivers/net/wireless/marvell/libertas/firmware.c   |    4 +-
 drivers/net/wireless/marvell/libertas/main.c       |    6 +-
 drivers/net/wireless/marvell/libertas/rx.c         |   11 +-
 drivers/net/wireless/marvell/libertas_tf/cmd.c     |   22 +-
 .../net/wireless/marvell/libertas_tf/deb_defs.h    |    3 +-
 drivers/net/wireless/marvell/libertas_tf/if_usb.c  |   37 +-
 drivers/net/wireless/marvell/libertas_tf/main.c    |    7 +-
 drivers/net/wireless/marvell/mwifiex/cfg80211.c    |    8 +-
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |    4 +-
 drivers/net/wireless/marvell/mwifiex/fw.h          |    8 +-
 drivers/net/wireless/marvell/mwifiex/ie.c          |    2 +-
 drivers/net/wireless/marvell/mwifiex/init.c        |   14 +-
 drivers/net/wireless/marvell/mwifiex/main.c        |    2 +
 drivers/net/wireless/marvell/mwifiex/pcie.c        |  323 +-
 drivers/net/wireless/marvell/mwifiex/pcie.h        |  149 -
 drivers/net/wireless/marvell/mwifiex/scan.c        |    4 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c        |  429 +++
 drivers/net/wireless/marvell/mwifiex/sdio.h        |  427 ---
 drivers/net/wireless/marvell/mwifiex/uap_txrx.c    |    6 +-
 drivers/net/wireless/marvell/mwifiex/usb.c         |    3 +-
 drivers/net/wireless/marvell/mwifiex/util.c        |    6 +-
 drivers/net/wireless/marvell/mwifiex/wmm.c         |   15 +
 drivers/net/wireless/marvell/mwifiex/wmm.h         |   18 +-
 drivers/net/wireless/marvell/mwl8k.c               |   16 +-
 drivers/net/wireless/mediatek/mt76/debugfs.c       |    9 +-
 drivers/net/wireless/mediatek/mt76/dma.c           |  162 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   47 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   61 +-
 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c |    8 +-
 .../net/wireless/mediatek/mt76/mt7603/debugfs.c    |   18 +-
 drivers/net/wireless/mediatek/mt76/mt7603/dma.c    |   26 +-
 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c |   17 +-
 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.h |    3 +
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |    5 -
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    |   25 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |    4 +-
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |    5 +-
 drivers/net/wireless/mediatek/mt76/mt7603/pci.c    |    2 +
 drivers/net/wireless/mediatek/mt76/mt7603/soc.c    |    2 +
 .../net/wireless/mediatek/mt76/mt7615/debugfs.c    |   30 +-
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |   55 +-
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |    3 +
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |   25 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |   42 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   11 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |  200 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mmio.c   |   25 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |   21 +-
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c    |    7 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_init.c   |    3 +
 .../net/wireless/mediatek/mt76/mt7615/pci_mac.c    |    6 +-
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |    2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/sdio.c   |   38 +-
 .../net/wireless/mediatek/mt76/mt7615/sdio_mcu.c   |   22 +-
 .../net/wireless/mediatek/mt76/mt7615/sdio_txrx.c  |  282 +-
 .../net/wireless/mediatek/mt76/mt7615/testmode.c   |   11 +-
 drivers/net/wireless/mediatek/mt76/mt7615/usb.c    |    2 -
 .../net/wireless/mediatek/mt76/mt7615/usb_mcu.c    |    8 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_sdio.c   |   29 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |    1 +
 .../net/wireless/mediatek/mt76/mt76x0/initvals.h   |  145 -
 .../wireless/mediatek/mt76/mt76x0/initvals_init.h  |  159 +
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |    4 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |    2 +
 .../net/wireless/mediatek/mt76/mt76x02_debugfs.c   |   34 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_dfs.c   |    6 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_dma.h   |    1 -
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   |   13 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   |    3 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  |   70 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_usb.h   |    3 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  |   12 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |    5 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/pci.c    |    5 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_init.c   |    2 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |   11 +-
 drivers/net/wireless/mediatek/mt76/mt7915/dma.c    |  146 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   10 +
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  257 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   39 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  140 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.h    |   33 +
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |   48 +-
 drivers/net/wireless/mediatek/mt76/mt7915/pci.c    |   30 +-
 drivers/net/wireless/mediatek/mt76/mt7915/regs.h   |   17 +-
 drivers/net/wireless/mediatek/mt76/sdio.c          |  160 +-
 drivers/net/wireless/mediatek/mt76/testmode.c      |   19 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |  330 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |   86 +-
 drivers/net/wireless/mediatek/mt76/util.c          |   28 +
 drivers/net/wireless/mediatek/mt76/util.h          |   76 +
 drivers/net/wireless/mediatek/mt7601u/debugfs.c    |   34 +-
 drivers/net/wireless/mediatek/mt7601u/dma.c        |    4 +-
 drivers/net/wireless/mediatek/mt7601u/mac.c        |    4 +-
 drivers/net/wireless/mediatek/mt7601u/phy.c        |    4 +-
 drivers/net/wireless/microchip/wilc1000/mon.c      |    3 +-
 drivers/net/wireless/microchip/wilc1000/sdio.c     |    5 +-
 drivers/net/wireless/microchip/wilc1000/spi.c      |    5 +-
 drivers/net/wireless/quantenna/qtnfmac/commands.c  |    2 +
 drivers/net/wireless/quantenna/qtnfmac/core.c      |   24 +-
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   |    7 +-
 .../wireless/quantenna/qtnfmac/pcie/topaz_pcie.c   |    7 +-
 drivers/net/wireless/ralink/rt2x00/rt2400pci.c     |   16 +-
 drivers/net/wireless/ralink/rt2x00/rt2500pci.c     |   16 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c     |   42 +-
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.c    |   25 +-
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.h    |   10 +-
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c     |    1 -
 drivers/net/wireless/ralink/rt2x00/rt2x00.h        |   10 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c     |    5 +-
 drivers/net/wireless/ralink/rt2x00/rt61pci.c       |   23 +-
 drivers/net/wireless/ralink/rt2x00/rt73usb.c       |    1 -
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |   70 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   10 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        |  193 +-
 drivers/net/wireless/realtek/rtlwifi/base.h        |    3 -
 .../realtek/rtlwifi/btcoexist/halbtc8192e2ant.c    |  712 ++--
 .../realtek/rtlwifi/btcoexist/halbtc8723b1ant.c    |  354 +-
 .../realtek/rtlwifi/btcoexist/halbtc8723b2ant.c    |  720 ++--
 .../realtek/rtlwifi/btcoexist/halbtc8821a1ant.c    |  668 ++--
 .../realtek/rtlwifi/btcoexist/halbtc8821a2ant.c    |  756 ++---
 .../realtek/rtlwifi/btcoexist/halbtcoutsrc.c       |   40 +-
 .../wireless/realtek/rtlwifi/btcoexist/rtl_btc.c   |    6 +-
 drivers/net/wireless/realtek/rtlwifi/cam.c         |   82 +-
 drivers/net/wireless/realtek/rtlwifi/core.c        |  269 +-
 drivers/net/wireless/realtek/rtlwifi/debug.c       |   24 +-
 drivers/net/wireless/realtek/rtlwifi/debug.h       |   14 +-
 drivers/net/wireless/realtek/rtlwifi/efuse.c       |   72 +-
 drivers/net/wireless/realtek/rtlwifi/pci.c         |  423 ++-
 drivers/net/wireless/realtek/rtlwifi/ps.c          |  125 +-
 drivers/net/wireless/realtek/rtlwifi/ps.h          |   10 +-
 drivers/net/wireless/realtek/rtlwifi/regd.c        |   18 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/dm.c    |  192 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/fw.c    |   90 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/hw.c    |  215 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/led.c   |   20 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/phy.c   |  405 ++-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/rf.c    |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8188ee/trx.c   |   41 +-
 .../wireless/realtek/rtlwifi/rtl8192c/dm_common.c  |  224 +-
 .../wireless/realtek/rtlwifi/rtl8192c/fw_common.c  |   88 +-
 .../wireless/realtek/rtlwifi/rtl8192c/phy_common.c |  271 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/dm.c    |   40 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/hw.c    |  184 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/led.c   |   12 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/phy.c   |  121 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/rf.c    |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ce/trx.c   |   28 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/dm.c    |   38 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c    |  154 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/led.c   |   10 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/mac.c   |   72 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/phy.c   |  134 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/rf.c    |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8192cu/trx.c   |   58 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/dm.c    |  312 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/fw.c    |  116 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/hw.c    |  214 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/led.c   |   10 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   |  423 ++-
 .../net/wireless/realtek/rtlwifi/rtl8192de/rf.c    |   30 +-
 .../net/wireless/realtek/rtlwifi/rtl8192de/trx.c   |   32 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/dm.c    |   72 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/fw.c    |  102 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.c    |  210 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/led.c   |   18 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/phy.c   |  366 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/rf.c    |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8192ee/trx.c   |   45 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/dm.c    |   42 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/fw.c    |   40 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/hw.c    |  159 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/led.c   |   10 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/phy.c   |  220 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/rf.c    |   72 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/sw.c    |    4 +-
 .../net/wireless/realtek/rtlwifi/rtl8192se/trx.c   |   22 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/dm.c    |  162 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/fw.c    |   64 +-
 .../realtek/rtlwifi/rtl8723ae/hal_bt_coexist.c     |  150 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c   |  647 ++--
 .../net/wireless/realtek/rtlwifi/rtl8723ae/hw.c    |  232 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/led.c   |   12 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/phy.c   |  365 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/rf.c    |   10 +-
 .../net/wireless/realtek/rtlwifi/rtl8723ae/trx.c   |   32 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/dm.c    |  124 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/fw.c    |   66 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/hw.c    |  213 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/led.c   |   10 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/phy.c   |  310 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/rf.c    |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8723be/trx.c   |   37 +-
 .../realtek/rtlwifi/rtl8723com/fw_common.c         |   22 +-
 .../realtek/rtlwifi/rtl8723com/phy_common.c        |   44 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/dm.c    |  827 +++--
 .../net/wireless/realtek/rtlwifi/rtl8821ae/fw.c    |  134 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    |  467 ++-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/led.c   |   32 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   |  553 ++-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/rf.c    |    6 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/trx.c   |   72 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   28 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |    4 -
 drivers/net/wireless/realtek/rtw88/debug.c         |   32 +-
 drivers/net/wireless/realtek/rtw88/fw.c            |   86 +-
 drivers/net/wireless/realtek/rtw88/fw.h            |   18 +-
 drivers/net/wireless/realtek/rtw88/mac.c           |   13 +-
 drivers/net/wireless/realtek/rtw88/mac80211.c      |   81 +-
 drivers/net/wireless/realtek/rtw88/main.c          |  205 +-
 drivers/net/wireless/realtek/rtw88/main.h          |   32 +
 drivers/net/wireless/realtek/rtw88/pci.c           |   38 +-
 drivers/net/wireless/realtek/rtw88/pci.h           |    4 +-
 drivers/net/wireless/realtek/rtw88/phy.c           |   11 +-
 drivers/net/wireless/realtek/rtw88/reg.h           |    5 +
 drivers/net/wireless/realtek/rtw88/rtw8821c.c      |    2 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c      |    7 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c      |   22 +-
 .../net/wireless/realtek/rtw88/rtw8822c_table.c    |   32 +-
 drivers/net/wireless/realtek/rtw88/tx.c            |    4 +-
 drivers/net/wireless/realtek/rtw88/tx.h            |    2 +-
 drivers/net/wireless/realtek/rtw88/util.h          |    2 +
 drivers/net/wireless/rndis_wlan.c                  |    4 +-
 drivers/net/wireless/rsi/rsi_91x_coex.c            |    2 +-
 drivers/net/wireless/rsi/rsi_91x_core.c            |    2 +-
 drivers/net/wireless/rsi/rsi_91x_debugfs.c         |    2 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |    2 +-
 drivers/net/wireless/rsi/rsi_91x_mac80211.c        |    8 +-
 drivers/net/wireless/rsi/rsi_91x_main.c            |    5 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c            |   33 +-
 drivers/net/wireless/rsi/rsi_91x_ps.c              |    2 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |    7 +-
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c        |    2 +-
 drivers/net/wireless/st/cw1200/wsm.c               |    6 +-
 drivers/net/wireless/ti/wl1251/main.c              |    2 +-
 drivers/net/wireless/ti/wl1251/reg.h               |    2 +-
 drivers/net/wireless/ti/wl12xx/reg.h               |    2 +-
 drivers/net/wireless/ti/wlcore/cmd.c               |    7 +-
 drivers/net/wireless/ti/wlcore/debugfs.c           |    7 -
 drivers/net/wireless/ti/wlcore/debugfs.h           |    6 +-
 drivers/net/wireless/ti/wlcore/main.c              |    1 -
 drivers/net/wireless/wl3501_cs.c                   |   26 +-
 drivers/net/wireless/zydas/zd1201.c                |    6 +-
 drivers/net/wireless/zydas/zd1211rw/zd_chip.c      |    4 +-
 drivers/net/wireless/zydas/zd1211rw/zd_mac.c       |   15 +-
 drivers/net/wireless/zydas/zd1211rw/zd_usb.c       |   10 +-
 drivers/nfc/pn533/usb.c                            |    2 +-
 drivers/nfc/s3fwrn5/Kconfig                        |    1 +
 drivers/nfc/s3fwrn5/firmware.c                     |    4 +-
 drivers/nfc/s3fwrn5/firmware.h                     |    2 +-
 drivers/nfc/s3fwrn5/i2c.c                          |   24 +-
 drivers/nfc/st-nci/se.c                            |    3 +-
 drivers/nfc/st21nfca/se.c                          |    3 +-
 drivers/of/Kconfig                                 |    7 -
 drivers/of/Makefile                                |    1 -
 drivers/of/base.c                                  |    1 +
 drivers/ptp/ptp_ines.c                             |   91 +-
 drivers/ptp/ptp_qoriq.c                            |   20 +-
 drivers/s390/cio/chsc.c                            |   22 +-
 drivers/s390/cio/chsc.h                            |    8 +-
 drivers/s390/cio/css.c                             |   11 +-
 drivers/s390/cio/css.h                             |    4 +-
 drivers/s390/cio/device_ops.c                      |   93 +-
 drivers/s390/net/Kconfig                           |    2 +-
 drivers/s390/net/ctcm_fsms.h                       |    1 -
 drivers/s390/net/ctcm_mpc.h                        |    1 -
 drivers/s390/net/ism.h                             |    7 +
 drivers/s390/net/ism_drv.c                         |   47 +
 drivers/s390/net/qeth_core.h                       |  102 +-
 drivers/s390/net/qeth_core_main.c                  |  359 +-
 drivers/s390/net/qeth_core_mpc.h                   |   14 +-
 drivers/s390/net/qeth_core_sys.c                   |   71 +-
 drivers/s390/net/qeth_ethtool.c                    |   16 +-
 drivers/s390/net/qeth_l2.h                         |    9 +-
 drivers/s390/net/qeth_l2_main.c                    |  888 +++--
 drivers/s390/net/qeth_l2_sys.c                     |   17 +-
 drivers/s390/net/qeth_l3.h                         |    4 +-
 drivers/s390/net/qeth_l3_main.c                    |  176 +-
 drivers/s390/net/qeth_l3_sys.c                     |   72 +-
 drivers/ssb/pci.c                                  |    7 +-
 drivers/target/target_core_user.c                  |    6 +-
 drivers/thermal/thermal_netlink.c                  |    8 +-
 fs/dlm/netlink.c                                   |    6 +-
 fs/io_uring.c                                      |    6 +
 include/linux/bpf-cgroup.h                         |   25 +
 include/linux/bpf.h                                |  149 +-
 include/linux/bpf_local_storage.h                  |  163 +
 include/linux/bpf_lsm.h                            |   29 +
 include/linux/bpf_types.h                          |    3 +
 include/linux/bpf_verifier.h                       |   28 +-
 include/linux/brcmphy.h                            |    1 +
 include/linux/btf.h                                |   68 +-
 include/linux/btf_ids.h                            |   59 +-
 include/linux/can/core.h                           |    9 +-
 include/linux/can/dev.h                            |   27 +-
 include/linux/can/rx-offload.h                     |    3 +
 include/linux/cookie.h                             |   51 +
 include/linux/dsa/8021q.h                          |   51 +-
 include/linux/ethtool.h                            |   30 +
 include/linux/filter.h                             |   12 +-
 include/linux/fsl/ptp_qoriq.h                      |    3 +
 include/linux/ieee80211.h                          |  230 +-
 include/linux/if_bridge.h                          |    8 +-
 include/linux/if_tun.h                             |   19 +-
 include/linux/inet_diag.h                          |    2 +
 include/linux/ipv6.h                               |   22 -
 include/linux/mdio.h                               |    9 +-
 {drivers/net/phy =3D> include/linux/mdio}/mdio-i2c.h |    0
 .../net/phy =3D> include/linux/mdio}/mdio-xgene.h    |    0
 include/linux/micrel_phy.h                         |    1 +
 include/linux/mlx5/device.h                        |    4 +-
 include/linux/mlx5/driver.h                        |    3 +-
 include/linux/mlx5/eswitch.h                       |   15 +-
 include/linux/mlx5/fs.h                            |    1 +
 include/linux/mlx5/qp.h                            |    6 +-
 include/linux/net.h                                |    3 +
 include/linux/netdevice.h                          |  105 +-
 include/linux/netfilter/nf_conntrack_common.h      |    2 +-
 include/linux/netlink.h                            |   30 +-
 include/linux/of.h                                 |    5 +
 include/linux/of_mdio.h                            |    6 +
 include/linux/pcs-lynx.h                           |   21 +
 include/linux/{mdio-xpcs.h =3D> pcs/pcs-xpcs.h}      |    8 +-
 include/linux/phy.h                                |  426 ++-
 include/linux/phylink.h                            |    3 +
 include/linux/platform_data/macb.h                 |   20 -
 include/linux/prefetch.h                           |    8 +
 include/linux/ptp_classify.h                       |   78 +-
 include/linux/qed/qed_if.h                         |   82 +-
 include/linux/rcupdate_trace.h                     |   13 +-
 include/linux/skbuff.h                             |    8 +
 include/linux/skmsg.h                              |   19 +-
 include/linux/sock_diag.h                          |   14 +-
 include/linux/stmmac.h                             |    3 +
 include/linux/tcp.h                                |   21 +-
 include/net/bluetooth/hci_core.h                   |    6 +
 include/net/bluetooth/l2cap.h                      |    2 +
 include/net/bluetooth/mgmt.h                       |   18 +
 include/net/bpf_sk_storage.h                       |   12 +
 include/net/caif/caif_spi.h                        |  155 -
 include/net/cfg80211.h                             |  112 +-
 include/net/devlink.h                              |  228 +-
 include/net/drop_monitor.h                         |   36 -
 include/net/dsa.h                                  |   86 +-
 include/net/dst.h                                  |    2 +-
 include/net/genetlink.h                            |   75 +-
 include/net/inet_connection_sock.h                 |   10 +-
 include/net/inet_sock.h                            |    7 -
 include/net/ip.h                                   |    2 +-
 include/net/ip_vs.h                                |    3 -
 include/net/ipv6_stubs.h                           |    3 +
 include/net/mac80211.h                             |  149 +-
 include/net/mptcp.h                                |    6 +-
 include/net/net_namespace.h                        |    2 +-
 include/net/netfilter/nf_log.h                     |    1 +
 include/net/netfilter/nf_tables.h                  |   23 +-
 include/net/netfilter/nf_tables_core.h             |   11 +
 include/net/netfilter/nf_tables_ipv4.h             |   33 +
 include/net/netfilter/nf_tables_ipv6.h             |   46 +
 include/net/netlink.h                              |  105 +-
 include/net/netns/can.h                            |    1 -
 include/net/netns/ipv4.h                           |    1 +
 include/net/netns/nexthop.h                        |    2 +-
 include/net/nexthop.h                              |    4 -
 include/net/pkt_sched.h                            |    5 +-
 include/net/request_sock.h                         |    9 +-
 include/net/sch_generic.h                          |   11 +-
 include/net/smc.h                                  |    4 +
 include/net/sock.h                                 |   10 +-
 include/net/switchdev.h                            |    1 +
 include/net/tc_act/tc_tunnel_key.h                 |    5 +-
 include/net/tc_act/tc_vlan.h                       |    2 +
 include/net/tcp.h                                  |   40 +-
 include/net/tls.h                                  |    4 -
 include/net/udp_tunnel.h                           |   24 +
 include/net/xdp_sock.h                             |   30 +-
 include/net/xdp_sock_drv.h                         |  122 +-
 include/net/xfrm.h                                 |   33 +
 include/net/xsk_buff_pool.h                        |   53 +-
 include/soc/mscc/ocelot.h                          |   76 +-
 include/soc/mscc/ocelot_ptp.h                      |    3 +-
 include/soc/mscc/ocelot_vcap.h                     |  202 +-
 include/trace/events/devlink.h                     |   37 +
 include/trace/events/rxrpc.h                       |   35 +-
 include/uapi/linux/bpf.h                           |  655 +++-
 include/uapi/linux/can/isotp.h                     |  165 +
 include/uapi/linux/can/raw.h                       |    3 +
 include/uapi/linux/devlink.h                       |   69 +
 include/uapi/linux/ethtool.h                       |    2 +
 include/uapi/linux/ethtool_netlink.h               |   18 +-
 include/uapi/linux/genetlink.h                     |   11 +
 include/uapi/linux/gtp.h                           |    2 +
 include/uapi/linux/if_bridge.h                     |   38 +
 include/uapi/linux/if_link.h                       |  235 +-
 include/uapi/linux/if_pppol2tp.h                   |    2 +-
 include/uapi/linux/inet_diag.h                     |   18 +
 include/uapi/linux/l2tp.h                          |    7 +-
 include/uapi/linux/mroute.h                        |    5 +-
 include/uapi/linux/netfilter.h                     |    3 +-
 include/uapi/linux/netfilter/nf_tables.h           |   10 +
 include/uapi/linux/netfilter/nfnetlink_conntrack.h |    3 +-
 include/uapi/linux/netlink.h                       |    4 +
 include/uapi/linux/nl80211.h                       |  196 +-
 include/uapi/linux/tc_act/tc_mpls.h                |    1 +
 include/uapi/linux/tc_act/tc_vlan.h                |    4 +
 include/uapi/linux/tipc.h                          |    2 +
 include/uapi/linux/tipc_netlink.h                  |    2 +
 init/Kconfig                                       |    3 +
 kernel/Makefile                                    |    2 +-
 kernel/bpf/Makefile                                |    3 +
 kernel/bpf/arraymap.c                              |  102 +-
 kernel/bpf/bpf_inode_storage.c                     |  272 ++
 kernel/bpf/bpf_iter.c                              |   62 +-
 kernel/bpf/bpf_local_storage.c                     |  600 ++++
 kernel/bpf/bpf_lsm.c                               |   21 +-
 kernel/bpf/bpf_struct_ops.c                        |    6 +-
 kernel/bpf/btf.c                                   | 1221 ++++++-
 kernel/bpf/core.c                                  |   29 +-
 kernel/bpf/cpumap.c                                |   17 +-
 kernel/bpf/devmap.c                                |   17 +-
 kernel/bpf/hashtab.c                               |   22 +-
 kernel/bpf/helpers.c                               |   58 +
 kernel/bpf/inode.c                                 |  116 +-
 kernel/bpf/lpm_trie.c                              |    1 +
 kernel/bpf/map_in_map.c                            |   24 +-
 kernel/bpf/map_in_map.h                            |    2 -
 kernel/bpf/map_iter.c                              |   15 +
 kernel/bpf/percpu_freelist.c                       |  101 +-
 kernel/bpf/percpu_freelist.h                       |    1 +
 kernel/bpf/preload/.gitignore                      |    4 +
 kernel/bpf/preload/Kconfig                         |   26 +
 kernel/bpf/preload/Makefile                        |   25 +
 kernel/bpf/preload/bpf_preload.h                   |   16 +
 kernel/bpf/preload/bpf_preload_kern.c              |   91 +
 kernel/bpf/preload/bpf_preload_umd_blob.S          |    7 +
 kernel/bpf/preload/iterators/.gitignore            |    2 +
 kernel/bpf/preload/iterators/Makefile              |   57 +
 kernel/bpf/preload/iterators/README                |    4 +
 kernel/bpf/preload/iterators/bpf_preload_common.h  |   13 +
 kernel/bpf/preload/iterators/iterators.bpf.c       |  114 +
 kernel/bpf/preload/iterators/iterators.c           |   94 +
 kernel/bpf/preload/iterators/iterators.skel.h      |  412 +++
 kernel/bpf/queue_stack_maps.c                      |    2 +
 kernel/bpf/reuseport_array.c                       |    3 +-
 kernel/bpf/ringbuf.c                               |    1 +
 kernel/bpf/stackmap.c                              |    6 +-
 kernel/bpf/syscall.c                               |  331 +-
 kernel/bpf/task_iter.c                             |   15 +-
 kernel/bpf/trampoline.c                            |   63 +-
 kernel/bpf/verifier.c                              | 1388 ++++++--
 kernel/rcu/tasks.h                                 |   53 +-
 kernel/taskstats.c                                 |   40 +-
 kernel/trace/bpf_trace.c                           |  172 +-
 lib/nlattr.c                                       |  122 +-
 mm/filemap.c                                       |    8 +-
 mm/page_alloc.c                                    |    2 +-
 net/8021q/vlan.c                                   |    6 +-
 net/8021q/vlan.h                                   |   19 +-
 net/Kconfig                                        |    1 -
 net/atm/lec.c                                      |    2 +-
 net/atm/signaling.c                                |    2 +-
 net/batman-adv/bat_iv_ogm.c                        |    1 +
 net/batman-adv/bat_v_elp.c                         |    1 +
 net/batman-adv/bat_v_ogm.c                         |    1 +
 net/batman-adv/bridge_loop_avoidance.c             |    2 +-
 net/batman-adv/fragmentation.c                     |    2 +-
 net/batman-adv/hard-interface.c                    |   19 +-
 net/batman-adv/hard-interface.h                    |    1 -
 net/batman-adv/main.c                              |    1 -
 net/batman-adv/main.h                              |    2 +-
 net/batman-adv/multicast.c                         |   16 +-
 net/batman-adv/netlink.c                           |    6 +-
 net/batman-adv/network-coding.c                    |    4 +-
 net/batman-adv/send.c                              |    2 +-
 net/batman-adv/soft-interface.c                    |    4 +-
 net/batman-adv/types.h                             |    4 +-
 net/bluetooth/Kconfig                              |    1 -
 net/bluetooth/a2mp.c                               |   22 +-
 net/bluetooth/hci_conn.c                           |    2 +-
 net/bluetooth/hci_core.c                           |   43 +-
 net/bluetooth/hci_event.c                          |   89 +-
 net/bluetooth/hci_request.c                        |   85 +-
 net/bluetooth/l2cap_core.c                         |    7 +-
 net/bluetooth/l2cap_sock.c                         |   21 +-
 net/bluetooth/mgmt.c                               |   57 +-
 net/bluetooth/sco.c                                |    6 +
 net/bpf/test_run.c                                 |   88 +
 net/bpfilter/Kconfig                               |    1 +
 net/bridge/br.c                                    |    5 +
 net/bridge/br_device.c                             |   21 +-
 net/bridge/br_forward.c                            |   17 +-
 net/bridge/br_ioctl.c                              |    2 +-
 net/bridge/br_mdb.c                                |  573 +++-
 net/bridge/br_multicast.c                          | 1863 +++++++++--
 net/bridge/br_netlink.c                            |    4 +-
 net/bridge/br_private.h                            |  117 +-
 net/bridge/br_vlan.c                               |    6 +-
 net/bridge/netfilter/ebt_stp.c                     |    1 -
 net/caif/cfsrvl.c                                  |    1 -
 net/can/Kconfig                                    |   14 +
 net/can/Makefile                                   |    3 +
 net/can/af_can.c                                   |    8 +-
 net/can/bcm.c                                      |    6 +-
 net/can/gw.c                                       |    6 +-
 net/can/isotp.c                                    | 1424 ++++++++
 net/can/j1939/transport.c                          |    2 +
 net/can/proc.c                                     |   14 +-
 net/can/raw.c                                      |   34 +-
 net/core/bpf_sk_storage.c                          |  836 +----
 net/core/datagram.c                                |   33 +-
 net/core/dev.c                                     |  179 +-
 net/core/devlink.c                                 |  896 ++++-
 net/core/drop_monitor.c                            |  139 +-
 net/core/filter.c                                  |  962 +++++-
 net/core/flow_dissector.c                          |   10 +-
 net/core/net-procfs.c                              |   15 +-
 net/core/net-sysfs.c                               |    4 +-
 net/core/net_namespace.c                           |   12 +-
 net/core/netpoll.c                                 |    2 +-
 net/core/pktgen.c                                  |   10 +-
 net/core/ptp_classifier.c                          |   30 +
 net/core/skbuff.c                                  |   79 +-
 net/core/skmsg.c                                   |  195 +-
 net/core/sock.c                                    |   32 +-
 net/core/sock_diag.c                               |    9 +-
 net/core/sock_map.c                                |  441 ++-
 net/core/sysctl_net_core.c                         |   17 +-
 net/dccp/ackvec.c                                  |    2 +-
 net/dccp/ipv4.c                                    |    8 +-
 net/dccp/timer.c                                   |    3 +-
 net/dsa/dsa.c                                      |   51 +-
 net/dsa/dsa2.c                                     |  134 +-
 net/dsa/dsa_priv.h                                 |   62 +-
 net/dsa/master.c                                   |   20 +-
 net/dsa/port.c                                     |  104 +-
 net/dsa/slave.c                                    |  212 +-
 net/dsa/switch.c                                   |   50 +-
 net/dsa/tag_8021q.c                                |  158 +-
 net/dsa/tag_brcm.c                                 |   35 +-
 net/dsa/tag_dsa.c                                  |    9 -
 net/dsa/tag_edsa.c                                 |    9 -
 net/dsa/tag_ksz.c                                  |    1 +
 net/dsa/tag_mtk.c                                  |   10 -
 net/dsa/tag_ocelot.c                               |   60 +-
 net/dsa/tag_qca.c                                  |   10 -
 net/dsa/tag_rtl4_a.c                               |   11 -
 net/dsa/tag_sja1105.c                              |   33 +-
 net/dsa/tag_trailer.c                              |    1 +
 net/ethtool/bitset.c                               |   26 +-
 net/ethtool/cabletest.c                            |   41 +-
 net/ethtool/channels.c                             |   37 +-
 net/ethtool/coalesce.c                             |   45 +-
 net/ethtool/common.c                               |    2 +
 net/ethtool/debug.c                                |   24 +-
 net/ethtool/eee.c                                  |   32 +-
 net/ethtool/features.c                             |   30 +-
 net/ethtool/ioctl.c                                |   67 +-
 net/ethtool/linkinfo.c                             |   30 +-
 net/ethtool/linkmodes.c                            |   34 +-
 net/ethtool/linkstate.c                            |   14 +-
 net/ethtool/netlink.c                              |  124 +-
 net/ethtool/netlink.h                              |   35 +-
 net/ethtool/pause.c                                |   86 +-
 net/ethtool/privflags.c                            |   24 +-
 net/ethtool/rings.c                                |   35 +-
 net/ethtool/strset.c                               |   26 +-
 net/ethtool/tsinfo.c                               |   13 +-
 net/ethtool/tunnels.c                              |   42 +-
 net/ethtool/wol.c                                  |   24 +-
 net/hsr/hsr_debugfs.c                              |   21 +-
 net/hsr/hsr_netlink.c                              |    6 +-
 net/ieee802154/netlink.c                           |    6 +-
 net/ipv4/af_inet.c                                 |    1 +
 net/ipv4/bpf_tcp_ca.c                              |   34 +-
 net/ipv4/cipso_ipv4.c                              |    2 +-
 net/ipv4/fou.c                                     |   10 +-
 net/ipv4/icmp.c                                    |   29 +-
 net/ipv4/inet_connection_sock.c                    |    2 +-
 net/ipv4/inet_diag.c                               |   17 +
 net/ipv4/inet_hashtables.c                         |    6 +-
 net/ipv4/ip_gre.c                                  |   15 +-
 net/ipv4/ip_options.c                              |   35 +-
 net/ipv4/ip_output.c                               |   11 +-
 net/ipv4/ip_sockglue.c                             |    5 +-
 net/ipv4/ip_tunnel.c                               |    8 +-
 net/ipv4/ip_tunnel_core.c                          |   23 +-
 net/ipv4/ip_vti.c                                  |    9 +-
 net/ipv4/ipmr.c                                    |   14 +-
 net/ipv4/netfilter/nf_log_arp.c                    |   19 +-
 net/ipv4/netfilter/nf_log_ipv4.c                   |    6 +-
 net/ipv4/nexthop.c                                 |   66 +-
 net/ipv4/ping.c                                    |   29 +-
 net/ipv4/raw.c                                     |    5 +-
 net/ipv4/route.c                                   |   23 +-
 net/ipv4/syncookies.c                              |    6 +-
 net/ipv4/sysctl_net_ipv4.c                         |    9 +
 net/ipv4/tcp.c                                     |   51 +-
 net/ipv4/tcp_bpf.c                                 |   13 +-
 net/ipv4/tcp_cong.c                                |   27 +-
 net/ipv4/tcp_fastopen.c                            |    2 +-
 net/ipv4/tcp_input.c                               |  226 +-
 net/ipv4/tcp_ipv4.c                                |   18 +-
 net/ipv4/tcp_metrics.c                             |    6 +-
 net/ipv4/tcp_output.c                              |  212 +-
 net/ipv4/tcp_recovery.c                            |   16 +-
 net/ipv4/tcp_scalable.c                            |    2 +-
 net/ipv4/tcp_timer.c                               |    1 -
 net/ipv4/tcp_vegas.c                               |    8 +-
 net/ipv4/udp.c                                     |    2 +-
 net/ipv4/udp_bpf.c                                 |    9 +-
 net/ipv4/udp_tunnel_nic.c                          |   96 +-
 net/ipv6/addrconf_core.c                           |    8 +
 net/ipv6/af_inet6.c                                |    2 +
 net/ipv6/calipso.c                                 |    2 +-
 net/ipv6/icmp.c                                    |    7 +-
 net/ipv6/inet6_hashtables.c                        |    6 +-
 net/ipv6/ip6_fib.c                                 |   16 +-
 net/ipv6/ip6_gre.c                                 |   33 +-
 net/ipv6/ip6_output.c                              |    4 +-
 net/ipv6/ip6_vti.c                                 |    8 +-
 net/ipv6/netfilter/ip6t_NPT.c                      |   39 +
 net/ipv6/netfilter/nf_log_ipv6.c                   |    8 +-
 net/ipv6/route.c                                   |    6 +-
 net/ipv6/tcp_ipv6.c                                |   27 +-
 net/iucv/af_iucv.c                                 |    2 +-
 net/iucv/iucv.c                                    |    8 +-
 net/l2tp/Makefile                                  |    2 +
 net/l2tp/l2tp_core.c                               |  329 +-
 net/l2tp/l2tp_core.h                               |   33 +-
 net/l2tp/l2tp_debugfs.c                            |    4 +-
 net/l2tp/l2tp_eth.c                                |   13 +-
 net/l2tp/l2tp_ip.c                                 |   17 +-
 net/l2tp/l2tp_ip6.c                                |   17 +-
 net/l2tp/l2tp_netlink.c                            |   30 +-
 net/l2tp/l2tp_ppp.c                                |   70 +-
 net/l2tp/trace.h                                   |  211 ++
 net/mac80211/Makefile                              |    1 +
 net/mac80211/agg-rx.c                              |    2 +-
 net/mac80211/cfg.c                                 |  118 +-
 net/mac80211/chan.c                                |    9 +-
 net/mac80211/debugfs.c                             |    1 +
 net/mac80211/driver-ops.h                          |   29 +
 net/mac80211/ibss.c                                |    7 +-
 net/mac80211/ieee80211_i.h                         |   47 +-
 net/mac80211/iface.c                               | 1561 ++++-----
 net/mac80211/key.c                                 |   15 -
 net/mac80211/main.c                                |    2 +-
 net/mac80211/mesh.c                                |    6 +-
 net/mac80211/mesh_hwmp.c                           |    4 +-
 net/mac80211/mesh_plink.c                          |    1 +
 net/mac80211/mesh_ps.c                             |    6 +-
 net/mac80211/mlme.c                                |  233 +-
 net/mac80211/offchannel.c                          |   40 +-
 net/mac80211/rate.c                                |   40 +-
 net/mac80211/rx.c                                  |   98 +-
 net/mac80211/s1g.c                                 |   16 +
 net/mac80211/scan.c                                |   43 +-
 net/mac80211/sta_info.c                            |    4 +
 net/mac80211/sta_info.h                            |    3 +-
 net/mac80211/status.c                              |  229 +-
 net/mac80211/trace.h                               |   33 +
 net/mac80211/tx.c                                  |  249 +-
 net/mac80211/util.c                                |  193 ++
 net/mac80211/vht.c                                 |    4 -
 net/mptcp/mib.c                                    |    9 +
 net/mptcp/mib.h                                    |    9 +
 net/mptcp/options.c                                |  120 +-
 net/mptcp/pm.c                                     |   94 +-
 net/mptcp/pm_netlink.c                             |  325 +-
 net/mptcp/protocol.c                               |  570 +++-
 net/mptcp/protocol.h                               |   71 +-
 net/mptcp/subflow.c                                |  119 +-
 net/ncsi/ncsi-netlink.c                            |    6 +-
 net/netfilter/Kconfig                              |    1 +
 net/netfilter/core.c                               |  129 +-
 net/netfilter/ipset/ip_set_core.c                  |   17 +-
 net/netfilter/ipvs/Kconfig                         |    1 -
 net/netfilter/ipvs/ip_vs_conn.c                    |   18 +-
 net/netfilter/ipvs/ip_vs_core.c                    |   19 +-
 net/netfilter/ipvs/ip_vs_ctl.c                     |   13 +-
 net/netfilter/ipvs/ip_vs_sync.c                    |    3 -
 net/netfilter/ipvs/ip_vs_xmit.c                    |    6 +
 net/netfilter/nf_conntrack_core.c                  |   25 +-
 net/netfilter/nf_conntrack_netlink.c               |    5 +-
 net/netfilter/nf_conntrack_standalone.c            |    6 +-
 net/netfilter/nf_flow_table_core.c                 |   12 +-
 net/netfilter/nf_flow_table_ip.c                   |   45 +-
 net/netfilter/nf_log_common.c                      |   12 +
 net/netfilter/nf_tables_api.c                      |  121 +-
 net/netfilter/nf_tables_core.c                     |   15 +-
 net/netfilter/nf_tables_offload.c                  |    2 -
 net/netfilter/nfnetlink.c                          |   19 +-
 net/netfilter/nft_bitwise.c                        |  141 +-
 net/netfilter/nft_chain_filter.c                   |   35 +-
 net/netfilter/nft_cmp.c                            |   13 +-
 net/netfilter/nft_payload.c                        |   28 +
 net/netfilter/nft_socket.c                         |   27 +
 net/netfilter/xt_HMARK.c                           |    2 +-
 net/netlabel/netlabel_calipso.c                    |   10 +-
 net/netlabel/netlabel_cipso_v4.c                   |    6 +-
 net/netlabel/netlabel_domainhash.c                 |    5 +-
 net/netlabel/netlabel_mgmt.c                       |    6 +-
 net/netlabel/netlabel_unlabeled.c                  |    6 +-
 net/netlink/af_netlink.c                           |   68 +-
 net/netlink/genetlink.c                            |  377 ++-
 net/netlink/policy.c                               |  288 +-
 net/nfc/digital_dep.c                              |    3 -
 net/openvswitch/actions.c                          |   40 +-
 net/openvswitch/conntrack.c                        |   10 +-
 net/openvswitch/datapath.c                         |   70 +-
 net/openvswitch/flow_table.c                       |   70 +-
 net/openvswitch/flow_table.h                       |    1 -
 net/openvswitch/meter.c                            |    6 +-
 net/openvswitch/vport-internal_dev.c               |   28 +-
 net/openvswitch/vport.c                            |    7 +-
 net/packet/af_packet.c                             |   41 +-
 net/psample/psample.c                              |    6 +-
 net/rds/cong.c                                     |    2 +-
 net/rds/ib_cm.c                                    |    2 +-
 net/rds/ib_recv.c                                  |    6 +-
 net/rds/rdma.c                                     |    2 +-
 net/rxrpc/af_rxrpc.c                               |    7 +-
 net/rxrpc/ar-internal.h                            |   71 +-
 net/rxrpc/call_object.c                            |   43 +
 net/rxrpc/conn_client.c                            | 1092 +++---
 net/rxrpc/conn_event.c                             |   20 +-
 net/rxrpc/conn_object.c                            |   12 +-
 net/rxrpc/conn_service.c                           |    7 +
 net/rxrpc/local_object.c                           |    4 +-
 net/rxrpc/net_ns.c                                 |    5 +-
 net/rxrpc/output.c                                 |    6 +
 net/rxrpc/proc.c                                   |    2 +-
 net/rxrpc/rtt.c                                    |    1 -
 net/rxrpc/rxkad.c                                  |    8 +-
 net/rxrpc/sysctl.c                                 |   10 +-
 net/sched/act_api.c                                |    5 +-
 net/sched/act_ct.c                                 |    8 +-
 net/sched/act_ctinfo.c                             |    5 +-
 net/sched/act_gate.c                               |    4 +-
 net/sched/act_mpls.c                               |   18 +
 net/sched/act_vlan.c                               |   40 +
 net/sched/cls_u32.c                                |    8 +-
 net/sched/sch_generic.c                            |   23 +-
 net/sctp/associola.c                               |    4 +-
 net/sctp/auth.c                                    |    4 +-
 net/sctp/bind_addr.c                               |    2 +-
 net/sctp/chunk.c                                   |    2 +-
 net/sctp/protocol.c                                |    8 +-
 net/sctp/sm_make_chunk.c                           |    6 +-
 net/sctp/ulpqueue.c                                |    2 +-
 net/smc/af_smc.c                                   |  881 +++--
 net/smc/smc.h                                      |   19 +
 net/smc/smc_cdc.c                                  |    4 +-
 net/smc/smc_clc.c                                  |  500 ++-
 net/smc/smc_clc.h                                  |  250 +-
 net/smc/smc_close.c                                |    4 +-
 net/smc/smc_core.c                                 |   82 +-
 net/smc/smc_core.h                                 |   24 +-
 net/smc/smc_diag.c                                 |   30 +-
 net/smc/smc_ism.c                                  |   32 +-
 net/smc/smc_ism.h                                  |    8 +-
 net/smc/smc_llc.c                                  |   21 +-
 net/smc/smc_netns.h                                |    1 +
 net/smc/smc_pnet.c                                 |  174 +-
 net/smc/smc_pnet.h                                 |   15 +
 net/smc/smc_tx.c                                   |   10 +-
 net/socket.c                                       |    8 +-
 net/sunrpc/sysctl.c                                |    6 +-
 net/tipc/core.c                                    |    6 +
 net/tipc/core.h                                    |    8 +
 net/tipc/crypto.c                                  |  981 ++++--
 net/tipc/crypto.h                                  |   43 +-
 net/tipc/link.c                                    |   10 +-
 net/tipc/msg.c                                     |    5 +-
 net/tipc/msg.h                                     |    8 +-
 net/tipc/name_distr.c                              |   10 +-
 net/tipc/net.c                                     |   20 +-
 net/tipc/net.h                                     |    1 +
 net/tipc/netlink.c                                 |    2 +
 net/tipc/netlink_compat.c                          |    6 +-
 net/tipc/node.c                                    |   96 +-
 net/tipc/node.h                                    |    2 +
 net/tipc/socket.c                                  |    3 +-
 net/tipc/sysctl.c                                  |    9 +
 net/tipc/topsrv.c                                  |    1 -
 net/tipc/udp_media.c                               |    1 +
 net/tls/tls_device.c                               |   11 +-
 net/tls/tls_main.c                                 |   27 +-
 net/unix/af_unix.c                                 |    3 -
 net/wimax/stack.c                                  |    6 +-
 net/wireless/chan.c                                |  135 +-
 net/wireless/core.c                                |    8 +-
 net/wireless/core.h                                |    9 +-
 net/wireless/lib80211.c                            |    2 -
 net/wireless/mlme.c                                |   14 +-
 net/wireless/nl80211.c                             |  517 ++-
 net/wireless/radiotap.c                            |    1 +
 net/wireless/reg.c                                 |  329 +-
 net/wireless/scan.c                                |  585 +++-
 net/wireless/sme.c                                 |    2 +-
 net/wireless/util.c                                |   32 +
 net/wireless/wext-compat.c                         |    2 +-
 net/xdp/xdp_umem.c                                 |  225 +-
 net/xdp/xdp_umem.h                                 |    6 -
 net/xdp/xsk.c                                      |  219 +-
 net/xdp/xsk.h                                      |   11 +-
 net/xdp/xsk_buff_pool.c                            |  377 ++-
 net/xdp/xsk_diag.c                                 |   20 +-
 net/xdp/xsk_queue.h                                |   18 +-
 net/xdp/xskmap.c                                   |   15 +-
 net/xfrm/Kconfig                                   |   11 +
 net/xfrm/Makefile                                  |    1 +
 net/xfrm/xfrm_compat.c                             |  625 ++++
 net/xfrm/xfrm_interface.c                          |   31 +-
 net/xfrm/xfrm_state.c                              |   77 +-
 net/xfrm/xfrm_user.c                               |  110 +-
 samples/bpf/.gitignore                             |    1 +
 samples/bpf/Makefile                               |   36 +-
 samples/bpf/cpustat_kern.c                         |   36 +-
 samples/bpf/cpustat_user.c                         |   47 +-
 samples/bpf/hbm.c                                  |    3 +-
 samples/bpf/lathist_kern.c                         |   24 +-
 samples/bpf/lathist_user.c                         |   42 +-
 samples/bpf/offwaketime_kern.c                     |   52 +-
 samples/bpf/offwaketime_user.c                     |   66 +-
 samples/bpf/sockex3_kern.c                         |   20 +-
 samples/bpf/sockex3_user.c                         |    6 +-
 samples/bpf/spintest_kern.c                        |   36 +-
 samples/bpf/spintest_user.c                        |   68 +-
 samples/bpf/syscall_tp_kern.c                      |   24 +-
 samples/bpf/syscall_tp_user.c                      |   54 +-
 samples/bpf/task_fd_query_kern.c                   |    2 +-
 samples/bpf/task_fd_query_user.c                   |    2 +-
 samples/bpf/test_current_task_under_cgroup_kern.c  |   27 +-
 samples/bpf/test_current_task_under_cgroup_user.c  |   52 +-
 samples/bpf/test_map_in_map_kern.c                 |    7 +-
 samples/bpf/test_probe_write_user_kern.c           |   12 +-
 samples/bpf/test_probe_write_user_user.c           |   49 +-
 samples/bpf/trace_output_kern.c                    |   15 +-
 samples/bpf/trace_output_user.c                    |   55 +-
 samples/bpf/tracex3_kern.c                         |    2 +-
 samples/bpf/tracex5_user.c                         |    6 +-
 samples/bpf/xdp_monitor_kern.c                     |   60 +-
 samples/bpf/xdp_monitor_user.c                     |  159 +-
 samples/bpf/xdp_redirect_cpu_user.c                |  155 +-
 samples/bpf/xdp_sample_pkts_kern.c                 |   14 +-
 samples/bpf/xdp_sample_pkts_user.c                 |    1 -
 samples/bpf/xdpsock_user.c                         |  406 ++-
 samples/bpf/xsk_fwd.c                              | 1085 ++++++
 scripts/bpf_helpers_doc.py                         |    4 +
 scripts/link-vmlinux.sh                            |    6 +-
 security/bpf/hooks.c                               |    6 +
 tools/bpf/bpftool/Documentation/Makefile           |   15 +-
 tools/bpf/bpftool/Documentation/bpftool-btf.rst    |   37 +-
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |   33 +-
 .../bpf/bpftool/Documentation/bpftool-feature.rst  |   33 +-
 tools/bpf/bpftool/Documentation/bpftool-gen.rst    |   37 +-
 tools/bpf/bpftool/Documentation/bpftool-iter.rst   |   27 +-
 tools/bpf/bpftool/Documentation/bpftool-link.rst   |   36 +-
 tools/bpf/bpftool/Documentation/bpftool-map.rst    |   48 +-
 tools/bpf/bpftool/Documentation/bpftool-net.rst    |   34 +-
 tools/bpf/bpftool/Documentation/bpftool-perf.rst   |   34 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |   34 +-
 .../bpftool/Documentation/bpftool-struct_ops.rst   |   35 +-
 tools/bpf/bpftool/Documentation/bpftool.rst        |   34 +-
 tools/bpf/bpftool/Documentation/common_options.rst |   22 +
 tools/bpf/bpftool/Makefile                         |    6 +-
 tools/bpf/bpftool/bash-completion/bpftool          |   25 +-
 tools/bpf/bpftool/gen.c                            |    2 -
 tools/bpf/bpftool/json_writer.c                    |    6 +
 tools/bpf/bpftool/json_writer.h                    |    3 +
 tools/bpf/bpftool/link.c                           |   44 +-
 tools/bpf/bpftool/main.c                           |   33 +-
 tools/bpf/bpftool/map.c                            |  152 +-
 tools/bpf/bpftool/net.c                            |  299 +-
 tools/bpf/bpftool/prog.c                           |  203 +-
 tools/bpf/resolve_btfids/Makefile                  |    2 +
 tools/bpf/resolve_btfids/main.c                    |   29 +-
 tools/build/Makefile                               |    2 +
 tools/build/Makefile.feature                       |    1 -
 tools/build/feature/Makefile                       |    4 -
 tools/build/feature/test-all.c                     |    4 -
 tools/build/feature/test-libelf-mmap.c             |    9 -
 tools/include/linux/btf_ids.h                      |   59 +-
 tools/include/uapi/linux/bpf.h                     |  655 +++-
 tools/lib/bpf/Makefile                             |   28 +-
 tools/lib/bpf/bpf.c                                |   70 +-
 tools/lib/bpf/bpf.h                                |   39 +-
 tools/lib/bpf/bpf_core_read.h                      |  120 +-
 tools/lib/bpf/bpf_helpers.h                        |   49 +
 tools/lib/bpf/bpf_prog_linfo.c                     |    3 -
 tools/lib/bpf/bpf_tracing.h                        |    4 +-
 tools/lib/bpf/btf.c                                | 1899 +++++++++--
 tools/lib/bpf/btf.h                                |  103 +-
 tools/lib/bpf/btf_dump.c                           |   87 +-
 tools/lib/bpf/hashmap.c                            |    3 +
 tools/lib/bpf/hashmap.h                            |   12 +
 tools/lib/bpf/libbpf.c                             | 3539 ++++++++++++++--=
----
 tools/lib/bpf/libbpf.h                             |   12 +-
 tools/lib/bpf/libbpf.map                           |   38 +
 tools/lib/bpf/libbpf_common.h                      |    2 +
 tools/lib/bpf/libbpf_internal.h                    |  147 +-
 tools/lib/bpf/libbpf_probes.c                      |    8 +-
 tools/lib/bpf/netlink.c                            |  128 +-
 tools/lib/bpf/nlattr.c                             |    9 +-
 tools/lib/bpf/ringbuf.c                            |    8 +-
 tools/lib/bpf/xsk.c                                |  383 ++-
 tools/lib/bpf/xsk.h                                |    9 +
 tools/perf/Makefile.config                         |    4 -
 tools/perf/util/bpf-loader.c                       |   12 +-
 tools/perf/util/symbol.h                           |    2 +-
 tools/testing/selftests/bpf/.gitignore             |    2 -
 tools/testing/selftests/bpf/Makefile               |   14 +-
 tools/testing/selftests/bpf/README.rst             |   59 +
 tools/testing/selftests/bpf/bench.c                |    5 +-
 tools/testing/selftests/bpf/benchs/bench_rename.c  |   17 -
 tools/testing/selftests/bpf/benchs/bench_trigger.c |   17 +
 tools/testing/selftests/bpf/bpf_tcp_helpers.h      |   13 +-
 tools/testing/selftests/bpf/flow_dissector_load.h  |    8 +-
 tools/testing/selftests/bpf/network_helpers.c      |   37 +
 tools/testing/selftests/bpf/network_helpers.h      |    2 +
 tools/testing/selftests/bpf/prog_tests/align.c     |   16 +-
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  |  115 +-
 .../selftests/bpf/prog_tests/bpf_verif_scale.c     |    4 +
 .../selftests/bpf/{test_btf.c =3D> prog_tests/btf.c} |  410 +--
 tools/testing/selftests/bpf/prog_tests/btf_dump.c  |  105 +
 .../testing/selftests/bpf/prog_tests/btf_endian.c  |  101 +
 .../selftests/bpf/prog_tests/btf_map_in_map.c      |   74 +-
 .../selftests/bpf/prog_tests/btf_skc_cls_ingress.c |  234 ++
 tools/testing/selftests/bpf/prog_tests/btf_write.c |  244 ++
 .../selftests/bpf/prog_tests/cls_redirect.c        |   72 +-
 .../selftests/bpf/prog_tests/core_autosize.c       |  225 ++
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |  350 +-
 tools/testing/selftests/bpf/prog_tests/d_path.c    |  157 +
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |  293 +-
 .../selftests/bpf/prog_tests/global_data_init.c    |    3 +-
 tools/testing/selftests/bpf/prog_tests/ksyms.c     |   42 +-
 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c |   88 +
 tools/testing/selftests/bpf/prog_tests/l4lb_all.c  |    9 +-
 tools/testing/selftests/bpf/prog_tests/metadata.c  |  141 +
 .../selftests/bpf/prog_tests/pe_preserve_elems.c   |   66 +
 .../testing/selftests/bpf/prog_tests/perf_buffer.c |   65 +-
 tools/testing/selftests/bpf/prog_tests/pinning.c   |   49 +-
 .../selftests/bpf/prog_tests/raw_tp_test_run.c     |   96 +
 .../selftests/bpf/prog_tests/reference_tracking.c  |    2 +-
 .../selftests/bpf/prog_tests/resolve_btfids.c      |   45 +-
 tools/testing/selftests/bpf/prog_tests/sk_assign.c |    7 +-
 .../selftests/bpf/prog_tests/snprintf_btf.c        |   62 +
 .../testing/selftests/bpf/prog_tests/sock_fields.c |  382 +++
 .../selftests/bpf/prog_tests/sockmap_basic.c       |  189 ++
 .../testing/selftests/bpf/prog_tests/sockopt_sk.c  |    4 +-
 tools/testing/selftests/bpf/prog_tests/subprogs.c  |   31 +
 tools/testing/selftests/bpf/prog_tests/tailcalls.c |  332 ++
 .../selftests/bpf/prog_tests/tcp_hdr_options.c     |  610 ++++
 .../testing/selftests/bpf/prog_tests/test_bpffs.c  |   94 +
 .../selftests/bpf/prog_tests/test_local_storage.c  |   60 +
 tools/testing/selftests/bpf/prog_tests/test_lsm.c  |    9 +
 .../selftests/bpf/prog_tests/test_overhead.c       |   14 +-
 .../selftests/bpf/prog_tests/test_profiler.c       |   72 +
 tools/testing/selftests/bpf/prog_tests/trace_ext.c |  111 +
 .../selftests/bpf/prog_tests/xdp_noinline.c        |   51 +-
 tools/testing/selftests/bpf/progs/bpf_cubic.c      |    2 +
 tools/testing/selftests/bpf/progs/bpf_dctcp.c      |    2 +
 tools/testing/selftests/bpf/progs/bpf_flow.c       |   12 +-
 tools/testing/selftests/bpf/progs/bpf_iter.h       |   32 +
 .../testing/selftests/bpf/progs/bpf_iter_sockmap.c |   59 +
 .../selftests/bpf/progs/bpf_iter_task_btf.c        |   50 +
 .../selftests/bpf/progs/bpf_iter_task_file.c       |   10 +-
 .../selftests/bpf/progs/btf__core_reloc_enumval.c  |    3 +
 .../bpf/progs/btf__core_reloc_enumval___diff.c     |    3 +
 .../progs/btf__core_reloc_enumval___err_missing.c  |    3 +
 .../progs/btf__core_reloc_enumval___val3_missing.c |    3 +
 .../progs/btf__core_reloc_size___err_ambiguous.c   |    4 +
 .../bpf/progs/btf__core_reloc_type_based.c         |    3 +
 .../btf__core_reloc_type_based___all_missing.c     |    3 +
 .../progs/btf__core_reloc_type_based___diff_sz.c   |    3 +
 .../btf__core_reloc_type_based___fn_wrong_args.c   |    3 +
 .../progs/btf__core_reloc_type_based___incompat.c  |    3 +
 .../selftests/bpf/progs/btf__core_reloc_type_id.c  |    3 +
 .../btf__core_reloc_type_id___missing_targets.c    |    3 +
 tools/testing/selftests/bpf/progs/btf_ptr.h        |   27 +
 tools/testing/selftests/bpf/progs/connect4_prog.c  |   19 +
 .../testing/selftests/bpf/progs/core_reloc_types.h |  352 +-
 tools/testing/selftests/bpf/progs/fexit_bpf2bpf.c  |   27 +
 .../selftests/bpf/progs/fmod_ret_freplace.c        |   14 +
 .../selftests/bpf/progs/freplace_attach_probe.c    |   40 +
 .../selftests/bpf/progs/freplace_cls_redirect.c    |   34 +
 .../selftests/bpf/progs/freplace_connect_v4_prog.c |   19 +
 .../selftests/bpf/progs/freplace_get_constant.c    |   15 +
 tools/testing/selftests/bpf/progs/local_storage.c  |  140 +
 tools/testing/selftests/bpf/progs/lsm.c            |   64 +-
 tools/testing/selftests/bpf/progs/map_ptr_kern.c   |   16 +-
 .../testing/selftests/bpf/progs/metadata_unused.c  |   15 +
 tools/testing/selftests/bpf/progs/metadata_used.c  |   15 +
 .../selftests/bpf/progs/netif_receive_skb.c        |  249 ++
 tools/testing/selftests/bpf/progs/profiler.h       |  177 +
 tools/testing/selftests/bpf/progs/profiler.inc.h   |  969 ++++++
 tools/testing/selftests/bpf/progs/profiler1.c      |    6 +
 tools/testing/selftests/bpf/progs/profiler2.c      |    6 +
 tools/testing/selftests/bpf/progs/profiler3.c      |    6 +
 tools/testing/selftests/bpf/progs/pyperf.h         |   11 +-
 .../testing/selftests/bpf/progs/pyperf_subprogs.c  |    5 +
 tools/testing/selftests/bpf/progs/strobemeta.h     |   30 +-
 .../selftests/bpf/progs/strobemeta_subprogs.c      |   10 +
 tools/testing/selftests/bpf/progs/tailcall1.c      |   28 +-
 tools/testing/selftests/bpf/progs/tailcall2.c      |   14 +-
 tools/testing/selftests/bpf/progs/tailcall3.c      |    4 +-
 .../selftests/bpf/progs/tailcall_bpf2bpf1.c        |   38 +
 .../selftests/bpf/progs/tailcall_bpf2bpf2.c        |   41 +
 .../selftests/bpf/progs/tailcall_bpf2bpf3.c        |   61 +
 .../selftests/bpf/progs/tailcall_bpf2bpf4.c        |   61 +
 .../selftests/bpf/progs/test_btf_map_in_map.c      |   74 +
 .../selftests/bpf/progs/test_btf_skc_cls_ingress.c |  174 +
 .../selftests/bpf/progs/test_cls_redirect.c        |  105 +-
 .../bpf/progs/test_cls_redirect_subprogs.c         |    2 +
 .../selftests/bpf/progs/test_core_autosize.c       |  172 +
 .../selftests/bpf/progs/test_core_reloc_enumval.c  |   72 +
 .../selftests/bpf/progs/test_core_reloc_kernel.c   |    2 +
 .../bpf/progs/test_core_reloc_type_based.c         |  110 +
 .../selftests/bpf/progs/test_core_reloc_type_id.c  |  115 +
 tools/testing/selftests/bpf/progs/test_d_path.c    |   65 +
 tools/testing/selftests/bpf/progs/test_ksyms_btf.c |   55 +
 .../selftests/bpf/progs/test_l4lb_noinline.c       |   41 +-
 .../bpf/progs/test_misc_tcp_hdr_options.c          |  325 ++
 tools/testing/selftests/bpf/progs/test_overhead.c  |    6 -
 .../selftests/bpf/progs/test_pe_preserve_elems.c   |   38 +
 .../testing/selftests/bpf/progs/test_pkt_access.c  |   20 +
 .../selftests/bpf/progs/test_raw_tp_test_run.c     |   24 +
 tools/testing/selftests/bpf/progs/test_sk_lookup.c |  216 +-
 ...{test_sock_fields_kern.c =3D> test_sock_fields.c} |  176 +-
 .../bpf/progs/test_sockmap_invalid_update.c        |   23 +
 .../selftests/bpf/progs/test_sockmap_kern.h        |   34 +-
 .../selftests/bpf/progs/test_sockmap_update.c      |   48 +
 tools/testing/selftests/bpf/progs/test_subprogs.c  |  103 +
 .../selftests/bpf/progs/test_sysctl_loop1.c        |    4 +-
 .../selftests/bpf/progs/test_sysctl_loop2.c        |    4 +-
 .../testing/selftests/bpf/progs/test_sysctl_prog.c |    4 +-
 tools/testing/selftests/bpf/progs/test_tc_neigh.c  |  148 +
 tools/testing/selftests/bpf/progs/test_tc_peer.c   |   45 +
 .../selftests/bpf/progs/test_tcp_hdr_options.c     |  626 ++++
 tools/testing/selftests/bpf/progs/test_trace_ext.c |   18 +
 .../selftests/bpf/progs/test_trace_ext_tracing.c   |   25 +
 tools/testing/selftests/bpf/progs/test_vmlinux.c   |   12 +-
 .../selftests/bpf/progs/test_xdp_noinline.c        |   36 +-
 tools/testing/selftests/bpf/progs/trigger_bench.c  |    7 +
 tools/testing/selftests/bpf/test_bpftool_build.sh  |   21 +
 .../testing/selftests/bpf/test_bpftool_metadata.sh |   82 +
 .../selftests/bpf/test_current_pid_tgid_new_ns.c   |    1 +
 tools/testing/selftests/bpf/test_progs.h           |   63 +
 tools/testing/selftests/bpf/test_sock_fields.c     |  482 ---
 tools/testing/selftests/bpf/test_socket_cookie.c   |    2 +-
 tools/testing/selftests/bpf/test_sockmap.c         |   81 +-
 tools/testing/selftests/bpf/test_tc_redirect.sh    |  204 ++
 tools/testing/selftests/bpf/test_tcp_hdr_options.h |  152 +
 tools/testing/selftests/bpf/test_verifier.c        |   19 +-
 tools/testing/selftests/bpf/trace_helpers.c        |   27 +
 tools/testing/selftests/bpf/trace_helpers.h        |    4 +
 tools/testing/selftests/bpf/verifier/and.c         |   16 +
 tools/testing/selftests/bpf/verifier/basic.c       |    2 +-
 tools/testing/selftests/bpf/verifier/bounds.c      |  146 +
 tools/testing/selftests/bpf/verifier/calls.c       |    6 +-
 tools/testing/selftests/bpf/verifier/d_path.c      |   37 +
 .../selftests/bpf/verifier/direct_packet_access.c  |    2 +-
 tools/testing/selftests/bpf/verifier/ld_imm64.c    |    8 -
 tools/testing/selftests/bpf/verifier/map_ptr.c     |   32 +
 .../testing/selftests/bpf/verifier/ref_tracking.c  |   47 +
 tools/testing/selftests/bpf/verifier/regalloc.c    |  269 ++
 .../drivers/net/mlxsw/devlink_trap_policer.sh      |   33 +-
 .../selftests/drivers/net/mlxsw/qos_ets_strict.sh  |    9 +
 .../selftests/drivers/net/mlxsw/qos_headroom.sh    |  379 +++
 .../testing/selftests/drivers/net/mlxsw/qos_lib.sh |   14 +
 .../selftests/drivers/net/mlxsw/qos_mc_aware.sh    |    5 +
 .../testing/selftests/drivers/net/mlxsw/qos_pfc.sh |  403 +++
 .../testing/selftests/drivers/net/mlxsw/sch_ets.sh |    6 +
 .../selftests/drivers/net/mlxsw/sch_red_core.sh    |    1 +
 .../selftests/drivers/net/mlxsw/tc_police_scale.sh |   12 +-
 .../selftests/drivers/net/netdevsim/devlink.sh     |   21 +
 .../drivers/net/netdevsim/ethtool-pause.sh         |  108 +
 .../drivers/net/netdevsim/udp_tunnel_nic.sh        |  167 +
 .../drivers/net/ocelot/tc_flower_chains.sh         |  316 ++
 tools/testing/selftests/net/.gitignore             |    1 +
 tools/testing/selftests/net/Makefile               |    3 +
 tools/testing/selftests/net/config                 |    6 +-
 tools/testing/selftests/net/drop_monitor_tests.sh  |  215 ++
 tools/testing/selftests/net/fib_nexthops.sh        |   44 +
 .../selftests/net/forwarding/devlink_lib.sh        |   70 +-
 tools/testing/selftests/net/forwarding/lib.sh      |   43 +
 .../testing/selftests/net/forwarding/mirror_lib.sh |    2 +-
 tools/testing/selftests/net/ipsec.c                | 2195 ++++++++++++
 tools/testing/selftests/net/mptcp/Makefile         |    3 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.c  |   22 +-
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |   21 +-
 tools/testing/selftests/net/mptcp/mptcp_join.sh    |  193 +-
 tools/testing/selftests/net/mptcp/simult_flows.sh  |  293 ++
 tools/testing/selftests/net/nettest.c              |    2 +
 tools/testing/selftests/net/psock_snd.sh           |   16 +-
 tools/testing/selftests/net/tcp_mmap.c             |   42 +-
 tools/testing/selftests/net/vrf_route_leaking.sh   |  626 ++++
 tools/testing/selftests/netfilter/nf-queue.c       |   61 +-
 tools/testing/selftests/netfilter/nft_meta.sh      |   32 +-
 tools/testing/selftests/netfilter/nft_queue.sh     |   70 +-
 2302 files changed, 130478 insertions(+), 51398 deletions(-)
 create mode 100644 Documentation/bpf/prog_sk_lookup.rst
 create mode 100644 Documentation/devicetree/bindings/net/can/microchip,mcp=
251xfd.yaml
 create mode 100644 Documentation/devicetree/bindings/net/intel,dwmac-plat.=
yaml
 delete mode 100644 Documentation/devicetree/bindings/net/nfc/s3fwrn5.txt
 create mode 100644 Documentation/devicetree/bindings/net/nfc/samsung,s3fwr=
n5.yaml
 create mode 100644 Documentation/devicetree/bindings/net/renesas,etheravb.=
yaml
 delete mode 100644 Documentation/devicetree/bindings/net/renesas,ravb.txt
 create mode 100644 Documentation/devicetree/bindings/net/ti,dp83822.yaml
 delete mode 100644 Documentation/networking/caif/spi_porting.rst
 create mode 100644 Documentation/networking/devlink/devlink-reload.rst
 create mode 100644 Documentation/networking/statistics.rst
 delete mode 100644 drivers/net/caif/caif_spi.c
 delete mode 100644 drivers/net/caif/caif_spi_slave.c
 create mode 100644 drivers/net/can/spi/mcp251xfd/Kconfig
 create mode 100644 drivers/net/can/spi/mcp251xfd/Makefile
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-crc16.c
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd.h
 create mode 100644 drivers/net/dsa/mv88e6xxx/devlink.c
 create mode 100644 drivers/net/dsa/mv88e6xxx/devlink.h
 create mode 100644 drivers/net/dsa/sja1105/sja1105_devlink.c
 create mode 100644 drivers/net/ethernet/chelsio/inline_crypto/Kconfig
 create mode 100644 drivers/net/ethernet/chelsio/inline_crypto/Makefile
 create mode 100644 drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/Mak=
efile
 rename drivers/{crypto/chelsio =3D> net/ethernet/chelsio/inline_crypto/ch_=
ipsec}/chcr_ipsec.c (76%)
 create mode 100644 drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chc=
r_ipsec.h
 create mode 100644 drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/Make=
file
 rename drivers/{crypto/chelsio =3D> net/ethernet/chelsio/inline_crypto/ch_=
ktls}/chcr_common.h (87%)
 rename drivers/{crypto/chelsio =3D> net/ethernet/chelsio/inline_crypto/ch_=
ktls}/chcr_ktls.c (86%)
 rename drivers/{crypto/chelsio =3D> net/ethernet/chelsio/inline_crypto/ch_=
ktls}/chcr_ktls.h (65%)
 rename drivers/{crypto/chelsio =3D> net/ethernet/chelsio/inline_crypto}/ch=
tls/Makefile (100%)
 rename drivers/{crypto/chelsio =3D> net/ethernet/chelsio/inline_crypto}/ch=
tls/chtls.h (81%)
 rename drivers/{crypto/chelsio =3D> net/ethernet/chelsio/inline_crypto}/ch=
tls/chtls_cm.c (100%)
 rename drivers/{crypto/chelsio =3D> net/ethernet/chelsio/inline_crypto}/ch=
tls/chtls_cm.h (100%)
 rename drivers/{crypto/chelsio =3D> net/ethernet/chelsio/inline_crypto}/ch=
tls/chtls_hw.c (100%)
 rename drivers/{crypto/chelsio =3D> net/ethernet/chelsio/inline_crypto}/ch=
tls/chtls_io.c (100%)
 rename drivers/{crypto/chelsio =3D> net/ethernet/chelsio/inline_crypto}/ch=
tls/chtls_main.c (99%)
 create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_debugfs.c
 create mode 100644 drivers/net/ethernet/huawei/hinic/hinic_debugfs.h
 create mode 100644 drivers/net/ethernet/marvell/mvpp2/mvpp2_tai.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/ptp.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/ptp.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.c
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ptp.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/Kconfig
 create mode 100644 drivers/net/ethernet/marvell/prestera/Makefile
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_devlink.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_devlink.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_dsa.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_dsa.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_ethtool.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_ethtool.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_main.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_pci.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_rxtx.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_switchde=
v.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_switchde=
v.h
 rename drivers/net/ethernet/mellanox/mlx5/core/en/xsk/{umem.c =3D> pool.c}=
 (50%)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/umem.h
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/chains.c
 delete mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/chains.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_por=
t.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.h
 delete mode 100644 drivers/net/ethernet/mscc/ocelot_s2.h
 create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_fw.c
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_devlink.c
 create mode 100644 drivers/net/ethernet/qlogic/qed/qed_devlink.h
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-intel-plat.c
 create mode 100644 drivers/net/mdio/Kconfig
 create mode 100644 drivers/net/mdio/Makefile
 rename drivers/net/{phy =3D> mdio}/mdio-aspeed.c (100%)
 rename drivers/net/{phy =3D> mdio}/mdio-bcm-iproc.c (100%)
 rename drivers/net/{phy =3D> mdio}/mdio-bcm-unimac.c (100%)
 rename drivers/net/{phy =3D> mdio}/mdio-bitbang.c (100%)
 rename drivers/net/{phy =3D> mdio}/mdio-cavium.c (100%)
 rename drivers/net/{phy =3D> mdio}/mdio-cavium.h (100%)
 rename drivers/net/{phy =3D> mdio}/mdio-gpio.c (100%)
 rename drivers/net/{phy =3D> mdio}/mdio-hisi-femac.c (100%)
 rename drivers/net/{phy =3D> mdio}/mdio-i2c.c (98%)
 rename drivers/net/{phy =3D> mdio}/mdio-ipq4019.c (57%)
 rename drivers/net/{phy =3D> mdio}/mdio-ipq8064.c (100%)
 rename drivers/net/{phy =3D> mdio}/mdio-moxart.c (100%)
 rename drivers/net/{phy =3D> mdio}/mdio-mscc-miim.c (100%)
 rename drivers/net/{phy =3D> mdio}/mdio-mux-bcm-iproc.c (100%)
 rename drivers/net/{phy =3D> mdio}/mdio-mux-gpio.c (100%)
 rename drivers/net/{phy =3D> mdio}/mdio-mux-meson-g12a.c (100%)
 rename drivers/net/{phy =3D> mdio}/mdio-mux-mmioreg.c (100%)
 rename drivers/net/{phy =3D> mdio}/mdio-mux-multiplexer.c (100%)
 rename drivers/net/{phy =3D> mdio}/mdio-mux.c (100%)
 rename drivers/net/{phy =3D> mdio}/mdio-mvusb.c (100%)
 rename drivers/net/{phy =3D> mdio}/mdio-octeon.c (100%)
 rename drivers/net/{phy =3D> mdio}/mdio-sun4i.c (100%)
 rename drivers/net/{phy =3D> mdio}/mdio-thunder.c (100%)
 rename drivers/net/{phy =3D> mdio}/mdio-xgene.c (99%)
 rename drivers/{of =3D> net/mdio}/of_mdio.c (95%)
 create mode 100644 drivers/net/netdevsim/ethtool.c
 create mode 100644 drivers/net/pcs/Kconfig
 create mode 100644 drivers/net/pcs/Makefile
 create mode 100644 drivers/net/pcs/pcs-lynx.c
 rename drivers/net/{phy/mdio-xpcs.c =3D> pcs/pcs-xpcs.c} (99%)
 create mode 100644 drivers/net/wireless/ath/ath11k/debugfs.c
 create mode 100644 drivers/net/wireless/ath/ath11k/debugfs.h
 rename drivers/net/wireless/ath/ath11k/{debug_htt_stats.c =3D> debugfs_htt=
_stats.c} (99%)
 rename drivers/net/wireless/ath/ath11k/{debug_htt_stats.h =3D> debugfs_htt=
_stats.h} (98%)
 create mode 100644 drivers/net/wireless/ath/ath11k/debugfs_sta.h
 create mode 100644 drivers/net/wireless/ath/ath11k/hw.c
 create mode 100644 drivers/net/wireless/ath/ath11k/mhi.c
 create mode 100644 drivers/net/wireless/ath/ath11k/mhi.h
 create mode 100644 drivers/net/wireless/ath/ath11k/pci.c
 create mode 100644 drivers/net/wireless/ath/ath11k/pci.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/fw/pnvm.h
 create mode 100644 drivers/net/wireless/intel/iwlwifi/queue/tx.c
 create mode 100644 drivers/net/wireless/intel/iwlwifi/queue/tx.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/initvals_init=
.h
 create mode 100644 include/linux/bpf_local_storage.h
 create mode 100644 include/linux/cookie.h
 rename {drivers/net/phy =3D> include/linux/mdio}/mdio-i2c.h (100%)
 rename {drivers/net/phy =3D> include/linux/mdio}/mdio-xgene.h (100%)
 create mode 100644 include/linux/pcs-lynx.h
 rename include/linux/{mdio-xpcs.h =3D> pcs/pcs-xpcs.h} (88%)
 delete mode 100644 include/linux/platform_data/macb.h
 delete mode 100644 include/net/caif/caif_spi.h
 delete mode 100644 include/net/drop_monitor.h
 create mode 100644 include/uapi/linux/can/isotp.h
 create mode 100644 kernel/bpf/bpf_inode_storage.c
 create mode 100644 kernel/bpf/bpf_local_storage.c
 create mode 100644 kernel/bpf/preload/.gitignore
 create mode 100644 kernel/bpf/preload/Kconfig
 create mode 100644 kernel/bpf/preload/Makefile
 create mode 100644 kernel/bpf/preload/bpf_preload.h
 create mode 100644 kernel/bpf/preload/bpf_preload_kern.c
 create mode 100644 kernel/bpf/preload/bpf_preload_umd_blob.S
 create mode 100644 kernel/bpf/preload/iterators/.gitignore
 create mode 100644 kernel/bpf/preload/iterators/Makefile
 create mode 100644 kernel/bpf/preload/iterators/README
 create mode 100644 kernel/bpf/preload/iterators/bpf_preload_common.h
 create mode 100644 kernel/bpf/preload/iterators/iterators.bpf.c
 create mode 100644 kernel/bpf/preload/iterators/iterators.c
 create mode 100644 kernel/bpf/preload/iterators/iterators.skel.h
 create mode 100644 net/can/isotp.c
 create mode 100644 net/l2tp/trace.h
 create mode 100644 net/mac80211/s1g.c
 create mode 100644 net/xfrm/xfrm_compat.c
 create mode 100644 samples/bpf/xsk_fwd.c
 create mode 100644 tools/bpf/bpftool/Documentation/common_options.rst
 delete mode 100644 tools/build/feature/test-libelf-mmap.c
 rename tools/testing/selftests/bpf/{test_btf.c =3D> prog_tests/btf.c} (96%)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_endian.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_skc_cls_ingr=
ess.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_write.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/core_autosize.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/d_path.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/metadata.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/pe_preserve_elem=
s.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/raw_tp_test_run.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/snprintf_btf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sock_fields.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/subprogs.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tcp_hdr_options.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_bpffs.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_local_stora=
ge.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_profiler.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_ext.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_sockmap.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_task_btf.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enumv=
al.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enumv=
al___diff.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enumv=
al___err_missing.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_enumv=
al___val3_missing.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_size_=
__err_ambiguous.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_=
based.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_=
based___all_missing.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_=
based___diff_sz.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_=
based___fn_wrong_args.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_=
based___incompat.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_=
id.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_type_=
id___missing_targets.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf_ptr.h
 create mode 100644 tools/testing/selftests/bpf/progs/fmod_ret_freplace.c
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_attach_probe=
.c
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_cls_redirect=
.c
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_connect_v4_p=
rog.c
 create mode 100644 tools/testing/selftests/bpf/progs/freplace_get_constant=
.c
 create mode 100644 tools/testing/selftests/bpf/progs/local_storage.c
 create mode 100644 tools/testing/selftests/bpf/progs/metadata_unused.c
 create mode 100644 tools/testing/selftests/bpf/progs/metadata_used.c
 create mode 100644 tools/testing/selftests/bpf/progs/netif_receive_skb.c
 create mode 100644 tools/testing/selftests/bpf/progs/profiler.h
 create mode 100644 tools/testing/selftests/bpf/progs/profiler.inc.h
 create mode 100644 tools/testing/selftests/bpf/progs/profiler1.c
 create mode 100644 tools/testing/selftests/bpf/progs/profiler2.c
 create mode 100644 tools/testing/selftests/bpf/progs/profiler3.c
 create mode 100644 tools/testing/selftests/bpf/progs/pyperf_subprogs.c
 create mode 100644 tools/testing/selftests/bpf/progs/strobemeta_subprogs.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall_bpf2bpf1.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall_bpf2bpf2.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall_bpf2bpf3.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall_bpf2bpf4.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_btf_skc_cls_ingr=
ess.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_cls_redirect_sub=
progs.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_autosize.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_enumv=
al.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_type_=
based.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_type_=
id.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_d_path.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_btf.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_misc_tcp_hdr_opt=
ions.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_pe_preserve_elem=
s.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_raw_tp_test_run.c
 rename tools/testing/selftests/bpf/progs/{test_sock_fields_kern.c =3D> tes=
t_sock_fields.c} (61%)
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_invalid_=
update.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_update.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_subprogs.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_neigh.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_peer.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tcp_hdr_options.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trace_ext.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_trace_ext_tracin=
g.c
 create mode 100755 tools/testing/selftests/bpf/test_bpftool_metadata.sh
 delete mode 100644 tools/testing/selftests/bpf/test_sock_fields.c
 create mode 100755 tools/testing/selftests/bpf/test_tc_redirect.sh
 create mode 100644 tools/testing/selftests/bpf/test_tcp_hdr_options.h
 create mode 100644 tools/testing/selftests/bpf/verifier/d_path.c
 create mode 100644 tools/testing/selftests/bpf/verifier/regalloc.c
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/qos_headroom.=
sh
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/qos_pfc.sh
 create mode 100755 tools/testing/selftests/drivers/net/netdevsim/ethtool-p=
ause.sh
 mode change 100644 =3D> 100755 tools/testing/selftests/drivers/net/netdevs=
im/udp_tunnel_nic.sh
 create mode 100755 tools/testing/selftests/drivers/net/ocelot/tc_flower_ch=
ains.sh
 create mode 100755 tools/testing/selftests/net/drop_monitor_tests.sh
 create mode 100644 tools/testing/selftests/net/ipsec.c
 create mode 100755 tools/testing/selftests/net/mptcp/simult_flows.sh
 create mode 100755 tools/testing/selftests/net/vrf_route_leaking.sh
