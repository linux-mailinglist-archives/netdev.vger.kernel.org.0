Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5998A3D8046
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbhG0VBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbhG0U7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 16:59:06 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8D4C061798
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:05 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so1035537pjh.3
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 13:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pj8bqnZek7DQGNCWLNQ0g1MGQCZIVVP0FzEBXBYiI7Y=;
        b=HGNcgmkgioh1CGhVV9MmNSHIIrZU3zyWU9FQ5VTwPn9W0umAdlgjeKjEauZRV7JvPz
         /xO8V7bI0qXeAL0brzQ/n76823kTps6Q+jg5Lqgw2S0FCPeBRaMRbbQJIg+2s9yZN23w
         YMWhNsoWAH6pujsciw3v5szvSdnTqVCKJT8K4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Pj8bqnZek7DQGNCWLNQ0g1MGQCZIVVP0FzEBXBYiI7Y=;
        b=qs/FOp5bYoW1WqhstMIBIfAZLEB+Dsh4vNZLDdsa55BW8N5rLE9wAP5jQ3OFmOyVvg
         HKxMapTqWALwkbEn3uc1kP5YkFvsnjCcxt4zVRxEBaYs+pBi4PJa68qvR3IB/dWmo5Xp
         e5d84zPoIFo/q12P5jEAFA5dzY5I6bRO0ZE0KATuj0+mQE17tTdLRNBQB+SwoNxLPd3R
         1Te/OD9O1YX//QrSeFrl8qL4oJLeyVOO3Bay3T8cPRh5HCVmyMuAEqTxlww6fIjCwBmP
         wfsEN+djgWilRt93phtj6SNkgtNNG0mWL7BALKgcEV8V/t0ok/bLATdUNUxeJrZP4awW
         Z1BA==
X-Gm-Message-State: AOAM5303nDK85KHOfjS1B/XPmk06m0OcrUmLvwqbH96pbVtYcblu9lTW
        qYAk5485D6/OPF5dziCVDd/eBQ==
X-Google-Smtp-Source: ABdhPJwQjtrpDZXCytTxeG9yF6HC6xTn6UlfN5aFtxlz0qj/DQHfEGxGJNxB1m8L8ACZ2Ym4GjhdUQ==
X-Received: by 2002:a17:90a:bd06:: with SMTP id y6mr24299379pjr.6.1627419545039;
        Tue, 27 Jul 2021 13:59:05 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b22sm3589308pjq.37.2021.07.27.13.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 13:59:02 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     linux-hardening@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH 00/64] Introduce strict memcpy() bounds checking
Date:   Tue, 27 Jul 2021 13:57:51 -0700
Message-Id: <20210727205855.411487-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=14542; h=from:subject; bh=3tzv74ZEYGmAd5y8uADc3iW7VORzfnMWeib6wFauI3E=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhAHOAailZMrySr8Hn5051y4jmV7pP1R0P8T0EYvJP PELScHiJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYQBzgAAKCRCJcvTf3G3AJuDsD/ 49eMPKhRTb8JW/0fu88Js34IrgzhJADjmGc/UumkwlOoDoPkpm1YlMabyJe2OYGVqkIrU6PyPcmKwG YVxEGJ73OfhUQSwuchPcRrV7nhD8bPMqaij8yvd/9p7RR0lekdDNFhdcQgmlrLiOXFP2mokQ4kOIAW zanWodV+4IjYS8aIK+1uMkvRK1kIlxFuMwl1i9ThUz7Wi9lyrz3TJFZZR+1151uW9wzNMZSvI2ba1k gbAu6TN8Qvqlyakd+WhGhH6Th6JcXfGkzkN7xXhLJzXfNE/duHabQB2IUEi2k8LAjXFBgJtr+odhU8 HKyA/Y92NIKc4lwIY3q8mXlMdPjdOaQxNWt+Sz76KxQQ14l7sdbypO4OWNdIc/wWzMcKvJAjqKMtNH kocl8xdR/eRtz9R52PCPSif7oDbeYBByDvIB+b4IxdfKIWV1pkn8dgJf81GmUN4wCiaAtMUtvIV/UQ 8hfFOJiP1AMiAzRLt1waXayNuZJ7mTdnbDyJnbj1DtpWJdRrTBjYmWVefNxuxjboVlPrPBo9s/nAvt WpUMeOoFJ/bdWexQFk0g85Kuljf0EHobF3GWuemhqaWEWjSY9Y/jAkzQh2B2OY+bBCFwt6iAk/3qGb G4nqBUEAEMRyidD1kH/Dpq1knG3U7nzJQBcWvNYItFJIl3BjyK80L24ZXZOw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch series (based on next-20210726) implements stricter (no struct
member overflows) bounds checking for memcpy(), memmove(), and memset()
under CONFIG_FORTIFY_SOURCE. To quote a later patch in the series:

    tl;dr: In order to eliminate a large class of common buffer overflow
    flaws that continue to persist in the kernel, have memcpy() (under
    CONFIG_FORTIFY_SOURCE) perform bounds checking of the destination struct
    member when they have a known size. This would have caught all of the
    memcpy()-related buffer write overflow flaws identified in at least the
    last three years.

As this series introduces various helpers and performs several phases of
treewide cleanups, I'm expecting to carry this series in my tree, so I'd
love to get some Reviews and Acks. Given the size, I've mostly aimed this
series at various mailing lists, otherwise the CC size got really big. :)

Specifically, this series is logically split into several steps:

Clean up remaining simple compile-time memcpy() warnings:
  media: omap3isp: Extract struct group for memcpy() region
  mac80211: Use flex-array for radiotap header bitmap
  rpmsg: glink: Replace strncpy() with strscpy_pad()

Introduce struct_group() and apply it treewide to avoid compile-time
memcpy() warnings:
  stddef: Introduce struct_group() helper macro
  skbuff: Switch structure bounds to struct_group()
  bnxt_en: Use struct_group_attr() for memcpy() region
  staging: rtl8192e: Use struct_group() for memcpy() region
  staging: rtl8192u: Use struct_group() for memcpy() region
  staging: rtl8723bs: Avoid field-overflowing memcpy()
  lib80211: Use struct_group() for memcpy() region
  net/mlx5e: Avoid field-overflowing memcpy()
  mwl8k: Use struct_group() for memcpy() region
  libertas: Use struct_group() for memcpy() region
  libertas_tf: Use struct_group() for memcpy() region
  ipw2x00: Use struct_group() for memcpy() region
  thermal: intel: int340x_thermal: Use struct_group() for memcpy() region
  iommu/amd: Use struct_group() for memcpy() region
  cxgb3: Use struct_group() for memcpy() region
  ip: Use struct_group() for memcpy() regions
  intersil: Use struct_group() for memcpy() region
  cxgb4: Use struct_group() for memcpy() region
  bnx2x: Use struct_group() for memcpy() region
  drm/amd/pm: Use struct_group() for memcpy() region
  staging: wlan-ng: Use struct_group() for memcpy() region
  drm/mga/mga_ioc32: Use struct_group() for memcpy() region
  net/mlx5e: Use struct_group() for memcpy() region
  HID: cp2112: Use struct_group() for memcpy() region

Prepare fortify for additional hardening:
  compiler_types.h: Remove __compiletime_object_size()
  lib/string: Move helper functions out of string.c
  fortify: Move remaining fortify helpers into fortify-string.h
  fortify: Explicitly disable Clang support

Add compile-time and run-time tests:
  fortify: Add compile-time FORTIFY_SOURCE tests
  lib: Introduce CONFIG_TEST_MEMCPY

Enable new compile-time memcpy() and memmove() bounds checking:
  fortify: Detect struct member overflows in memcpy() at compile-time
  fortify: Detect struct member overflows in memmove() at compile-time

Clean up remaining simple compile-time memset() warnings:
  scsi: ibmvscsi: Avoid multi-field memset() overflow by aiming at srp

Introduce memset_after() helper and apply it (and struct_group())
treewide to avoid compile-time memset() warnings:
  string.h: Introduce memset_after() for wiping trailing members/padding
  xfrm: Use memset_after() to clear padding
  mac80211: Use memset_after() to clear tx status
  net: 802: Use memset_after() to clear struct fields
  net: dccp: Use memset_after() for TP zeroing
  net: qede: Use memset_after() for counters
  ath11k: Use memset_after() for clearing queue descriptors
  iw_cxgb4: Use memset_after() for cpl_t5_pass_accept_rpl
  intel_th: msu: Use memset_after() for clearing hw header
  IB/mthca: Use memset_after() for clearing mpt_entry
  btrfs: Use memset_after() to clear end of struct
  drbd: Use struct_group() to zero algs
  cm4000_cs: Use struct_group() to zero struct cm4000_dev region
  KVM: x86: Use struct_group() to zero decode cache
  tracing: Use struct_group() to zero struct trace_iterator
  dm integrity: Use struct_group() to zero struct journal_sector
  HID: roccat: Use struct_group() to zero kone_mouse_event
  ipv6: Use struct_group() to zero rt6_info
  RDMA/mlx5: Use struct_group() to zero struct mlx5_ib_mr
  ethtool: stats: Use struct_group() to clear all stats at once
  netfilter: conntrack: Use struct_group() to zero struct nf_conn
  powerpc: Split memset() to avoid multi-field overflow

Enable new compile-time memset() bounds checking:
  fortify: Detect struct member overflows in memset() at compile-time

Enable Clang support and global array-bounds checking:
  fortify: Work around Clang inlining bugs
  Makefile: Enable -Warray-bounds

Avoid run-time memcpy() bounds check warnings:
  netlink: Avoid false-positive memcpy() warning
  iwlwifi: dbg_ini: Split memcpy() to avoid multi-field write

Enable run-time memcpy() bounds checking:
  fortify: Add run-time WARN for cross-field memcpy()

A future series will clean up for and add run-time memset() bounds
checking.

Thanks!

-Kees


 Makefile                                      |   1 -
 arch/s390/lib/string.c                        |   3 +
 arch/x86/boot/compressed/misc.c               |   3 +-
 arch/x86/kvm/emulate.c                        |   3 +-
 arch/x86/kvm/kvm_emulate.h                    |  19 +-
 arch/x86/lib/memcpy_32.c                      |   1 +
 arch/x86/lib/string_32.c                      |   1 +
 drivers/block/drbd/drbd_main.c                |   3 +-
 drivers/block/drbd/drbd_protocol.h            |   6 +-
 drivers/block/drbd/drbd_receiver.c            |   3 +-
 drivers/char/pcmcia/cm4000_cs.c               |   9 +-
 drivers/gpu/drm/amd/include/atomfirmware.h    |   9 +-
 .../drm/amd/pm/inc/smu11_driver_if_arcturus.h |   3 +-
 .../drm/amd/pm/inc/smu11_driver_if_navi10.h   |   3 +-
 .../amd/pm/inc/smu13_driver_if_aldebaran.h    |   3 +-
 .../gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c |   6 +-
 .../gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c   |  12 +-
 .../drm/amd/pm/swsmu/smu13/aldebaran_ppt.c    |   6 +-
 drivers/gpu/drm/mga/mga_ioc32.c               |  30 +-
 drivers/hid/hid-cp2112.c                      |  14 +-
 drivers/hid/hid-roccat-kone.c                 |   2 +-
 drivers/hid/hid-roccat-kone.h                 |  12 +-
 drivers/hwtracing/intel_th/msu.c              |   4 +-
 drivers/infiniband/hw/cxgb4/cm.c              |   5 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h          |   4 +-
 drivers/infiniband/hw/mthca/mthca_mr.c        |   3 +-
 drivers/iommu/amd/init.c                      |   9 +-
 drivers/macintosh/smu.c                       |   3 +-
 drivers/md/dm-integrity.c                     |   9 +-
 drivers/media/platform/omap3isp/ispstat.c     |   5 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_stats.c |   7 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_stats.h |  14 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.h |  14 +-
 drivers/net/ethernet/chelsio/cxgb3/sge.c      |   9 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c      |   8 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h   |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h |  10 +-
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c    |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |   2 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c  |   2 +-
 drivers/net/wireguard/queueing.h              |   4 +-
 drivers/net/wireless/ath/ath11k/hal_rx.c      |  13 +-
 drivers/net/wireless/ath/carl9170/tx.c        |   4 +-
 drivers/net/wireless/intel/ipw2x00/libipw.h   |  12 +-
 .../net/wireless/intel/ipw2x00/libipw_rx.c    |   8 +-
 drivers/net/wireless/intel/iwlwifi/fw/file.h  |   2 +-
 .../net/wireless/intel/iwlwifi/iwl-dbg-tlv.c  |   3 +-
 .../net/wireless/intersil/hostap/hostap_hw.c  |   5 +-
 .../wireless/intersil/hostap/hostap_wlan.h    |  14 +-
 drivers/net/wireless/intersil/p54/txrx.c      |   4 +-
 drivers/net/wireless/marvell/libertas/host.h  |  10 +-
 drivers/net/wireless/marvell/libertas/tx.c    |   5 +-
 .../marvell/libertas_tf/libertas_tf.h         |  10 +-
 .../net/wireless/marvell/libertas_tf/main.c   |   3 +-
 drivers/net/wireless/marvell/mwl8k.c          |  10 +-
 drivers/rpmsg/qcom_glink_native.c             |   2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c              |   2 +-
 drivers/staging/rtl8192e/rtllib.h             |  20 +-
 drivers/staging/rtl8192e/rtllib_crypt_ccmp.c  |   3 +-
 drivers/staging/rtl8192e/rtllib_rx.c          |   8 +-
 .../staging/rtl8192u/ieee80211/ieee80211.h    |  24 +-
 .../rtl8192u/ieee80211/ieee80211_crypt_ccmp.c |   3 +-
 .../staging/rtl8192u/ieee80211/ieee80211_rx.c |   8 +-
 drivers/staging/rtl8723bs/core/rtw_mlme.c     |   2 +-
 drivers/staging/rtl8723bs/core/rtw_security.c |   5 +-
 drivers/staging/rtl8723bs/core/rtw_xmit.c     |   5 +-
 drivers/staging/wlan-ng/hfa384x.h             |  16 +-
 drivers/staging/wlan-ng/hfa384x_usb.c         |   4 +-
 .../intel/int340x_thermal/acpi_thermal_rel.c  |   5 +-
 .../intel/int340x_thermal/acpi_thermal_rel.h  |  48 +--
 fs/btrfs/root-tree.c                          |   5 +-
 include/linux/compiler-gcc.h                  |   2 -
 include/linux/compiler_types.h                |   4 -
 include/linux/fortify-string.h                | 234 +++++++++++---
 include/linux/ieee80211.h                     |   8 +-
 include/linux/if_vlan.h                       |   6 +-
 include/linux/skbuff.h                        |   9 +-
 include/linux/stddef.h                        |  34 ++
 include/linux/string.h                        |  26 +-
 include/linux/thread_info.h                   |   2 +-
 include/linux/trace_events.h                  |  26 +-
 include/net/flow.h                            |   6 +-
 include/net/ieee80211_radiotap.h              |  24 +-
 include/net/ip6_fib.h                         |  30 +-
 include/net/mac80211.h                        |   4 +-
 include/net/netfilter/nf_conntrack.h          |  20 +-
 include/uapi/drm/mga_drm.h                    |  37 ++-
 include/uapi/linux/if_ether.h                 |  12 +-
 include/uapi/linux/ip.h                       |  12 +-
 include/uapi/linux/ipv6.h                     |  12 +-
 include/uapi/linux/netlink.h                  |   1 +
 include/uapi/linux/omap3isp.h                 |  44 ++-
 kernel/trace/trace.c                          |   4 +-
 lib/.gitignore                                |   2 +
 lib/Kconfig.debug                             |   3 +
 lib/Makefile                                  |  32 ++
 lib/string.c                                  | 210 +------------
 lib/string_helpers.c                          | 201 ++++++++++++
 lib/test_fortify/read_overflow-memchr.c       |   5 +
 lib/test_fortify/read_overflow-memchr_inv.c   |   5 +
 lib/test_fortify/read_overflow-memcmp.c       |   5 +
 lib/test_fortify/read_overflow-memscan.c      |   5 +
 lib/test_fortify/read_overflow2-memcmp.c      |   5 +
 lib/test_fortify/read_overflow2-memcpy.c      |   5 +
 lib/test_fortify/read_overflow2-memmove.c     |   5 +
 .../read_overflow2_field-memcpy.c             |   5 +
 .../read_overflow2_field-memmove.c            |   5 +
 lib/test_fortify/test_fortify.h               |  31 ++
 lib/test_fortify/write_overflow-memcpy.c      |   5 +
 lib/test_fortify/write_overflow-memmove.c     |   5 +
 lib/test_fortify/write_overflow-memset.c      |   5 +
 lib/test_fortify/write_overflow-strlcpy.c     |   5 +
 lib/test_fortify/write_overflow-strncpy.c     |   5 +
 lib/test_fortify/write_overflow-strscpy.c     |   5 +
 .../write_overflow_field-memcpy.c             |   5 +
 .../write_overflow_field-memmove.c            |   5 +
 .../write_overflow_field-memset.c             |   5 +
 lib/test_memcpy.c                             | 297 ++++++++++++++++++
 net/802/hippi.c                               |   2 +-
 net/core/flow_dissector.c                     |  10 +-
 net/core/skbuff.c                             |  14 +-
 net/dccp/trace.h                              |   4 +-
 net/ethtool/stats.c                           |  15 +-
 net/ipv4/ip_output.c                          |   6 +-
 net/ipv6/route.c                              |   4 +-
 net/mac80211/rx.c                             |   2 +-
 net/netfilter/nf_conntrack_core.c             |   4 +-
 net/netlink/af_netlink.c                      |   4 +-
 net/wireless/lib80211_crypt_ccmp.c            |   3 +-
 net/wireless/radiotap.c                       |   5 +-
 net/xfrm/xfrm_policy.c                        |   4 +-
 net/xfrm/xfrm_user.c                          |   2 +-
 scripts/test_fortify.sh                       |  64 ++++
 security/Kconfig                              |   3 +
 137 files changed, 1484 insertions(+), 633 deletions(-)
 create mode 100644 lib/test_fortify/read_overflow-memchr.c
 create mode 100644 lib/test_fortify/read_overflow-memchr_inv.c
 create mode 100644 lib/test_fortify/read_overflow-memcmp.c
 create mode 100644 lib/test_fortify/read_overflow-memscan.c
 create mode 100644 lib/test_fortify/read_overflow2-memcmp.c
 create mode 100644 lib/test_fortify/read_overflow2-memcpy.c
 create mode 100644 lib/test_fortify/read_overflow2-memmove.c
 create mode 100644 lib/test_fortify/read_overflow2_field-memcpy.c
 create mode 100644 lib/test_fortify/read_overflow2_field-memmove.c
 create mode 100644 lib/test_fortify/test_fortify.h
 create mode 100644 lib/test_fortify/write_overflow-memcpy.c
 create mode 100644 lib/test_fortify/write_overflow-memmove.c
 create mode 100644 lib/test_fortify/write_overflow-memset.c
 create mode 100644 lib/test_fortify/write_overflow-strlcpy.c
 create mode 100644 lib/test_fortify/write_overflow-strncpy.c
 create mode 100644 lib/test_fortify/write_overflow-strscpy.c
 create mode 100644 lib/test_fortify/write_overflow_field-memcpy.c
 create mode 100644 lib/test_fortify/write_overflow_field-memmove.c
 create mode 100644 lib/test_fortify/write_overflow_field-memset.c
 create mode 100644 lib/test_memcpy.c
 create mode 100644 scripts/test_fortify.sh

-- 
2.30.2

