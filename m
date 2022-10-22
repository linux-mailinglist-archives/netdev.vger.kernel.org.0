Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45990608359
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 03:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiJVBoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 21:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiJVBod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 21:44:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192895F4A;
        Fri, 21 Oct 2022 18:44:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F4F7B82DBA;
        Sat, 22 Oct 2022 01:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0EE0C433D6;
        Sat, 22 Oct 2022 01:44:21 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="RKXib5Vl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1666403058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=MoqRTfm9IB8FgPaOUAJRCt6whwpoPY6P6DzU4oQAino=;
        b=RKXib5Vl1apeqvXSkeHuSjzGVJcpdoYt/8OAwj7E4ekShqhA/prDPzbcZ3L8EURFJsnCT+
        VCpgWDuEXVi4KUAlPXmdTapzdA6cjXUVNdUGqKO0UKQGAT4o94LRapJolzjCdwBIIXx41V
        8R1b7nFrQ3AUcsbIp6ZnzrkcuAw5BG0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 42623445 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 22 Oct 2022 01:44:17 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Heiko Carstens <hca@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        "Darrick J . Wong" <djwong@kernel.org>,
        SeongJae Park <sj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Helge Deller <deller@gmx.de>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mmc@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: [PATCH v1 0/5] convert tree to get_random_u32_{below,above,between}()
Date:   Fri, 21 Oct 2022 21:43:58 -0400
Message-Id: <20221022014403.3881893-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey everyone,

Here's the second and final tranche of tree-wide conversions to get
random integer handling a bit tamer. It's predominantly another
Coccinelle-based patchset.

First we s/prandom_u32_max/get_random_u32_below/, since the former is
just a deprecated alias for the latter. Then in the next commit we can
remove prandom_u32_max all together. I'm quite happy about finally being
able to do that. It means that prandom.h is now only for deterministic and 
repeatable randomness, not non-deterministic/cryptographic randomness.
That line is no longer blurred.

Then, in order to clean up a bunch of inefficient patterns, we introduce
two trivial static inline helper functions built on top of
get_random_u32_below: get_random_u32_above and get_random_u32_between.
These are pretty straight forward to use and understand. Then the final
two patches convert some gnarly open-coded number juggling to use these
helpers.

I've used Coccinelle for all the treewide patches, so hopefully review
is rather uneventful. I didn't accept all of the changes that Coccinelle
proposed, though, as these tend to be somewhat context-specific. I erred
on the side of just going with the most obvious cases, at least this
time through. And then we can address more complicated cases through
actual maintainer trees.

Since get_random_u32_below() sits in my random.git tree, these patches
too will flow through that same tree.

Regards,
Jason

Cc: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Helge Deller <deller@gmx.de>
Cc: netdev@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-block@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: loongarch@lists.linux.dev
Cc: linux-mips@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-mmc@vger.kernel.org
Cc: linux-parisc@vger.kernel.org

Jason A. Donenfeld (5):
  treewide: use get_random_u32_below() instead of deprecated function
  prandom: remove prandom_u32_max()
  random: add helpers for random numbers with given floor or range
  treewide: use get_random_u32_{above,below}() instead of manual loop
  treewide: use get_random_u32_between() when possible

 arch/arm/kernel/process.c                     |  2 +-
 arch/arm64/kernel/process.c                   |  2 +-
 arch/loongarch/kernel/process.c               |  2 +-
 arch/loongarch/kernel/vdso.c                  |  2 +-
 arch/mips/kernel/process.c                    |  2 +-
 arch/mips/kernel/vdso.c                       |  2 +-
 arch/parisc/kernel/vdso.c                     |  2 +-
 arch/powerpc/crypto/crc-vpmsum_test.c         |  4 +-
 arch/powerpc/kernel/process.c                 |  2 +-
 arch/s390/kernel/process.c                    |  2 +-
 arch/s390/kernel/vdso.c                       |  2 +-
 arch/sparc/vdso/vma.c                         |  2 +-
 arch/um/kernel/process.c                      |  2 +-
 arch/x86/entry/vdso/vma.c                     |  2 +-
 arch/x86/kernel/module.c                      |  2 +-
 arch/x86/kernel/process.c                     |  2 +-
 arch/x86/mm/pat/cpa-test.c                    |  4 +-
 crypto/rsa-pkcs1pad.c                         |  2 +-
 crypto/testmgr.c                              | 86 +++++++++----------
 drivers/block/drbd/drbd_receiver.c            |  4 +-
 drivers/bus/mhi/host/internal.h               |  2 +-
 drivers/dma-buf/st-dma-fence-chain.c          |  6 +-
 .../gpu/drm/i915/gem/i915_gem_execbuffer.c    |  2 +-
 .../drm/i915/gt/intel_execlists_submission.c  |  2 +-
 drivers/gpu/drm/i915/intel_memory_region.c    |  4 +-
 drivers/infiniband/core/cma.c                 |  2 +-
 drivers/infiniband/hw/cxgb4/id_table.c        |  4 +-
 drivers/infiniband/hw/hns/hns_roce_ah.c       |  5 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c        |  2 +-
 drivers/md/bcache/request.c                   |  2 +-
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c |  8 +-
 .../media/test-drivers/vidtv/vidtv_demod.c    |  8 +-
 .../test-drivers/vivid/vivid-kthread-cap.c    |  2 +-
 .../test-drivers/vivid/vivid-kthread-out.c    |  2 +-
 .../media/test-drivers/vivid/vivid-radio-rx.c |  4 +-
 .../media/test-drivers/vivid/vivid-sdr-cap.c  |  2 +-
 .../test-drivers/vivid/vivid-touch-cap.c      |  2 +-
 drivers/mmc/core/core.c                       |  4 +-
 drivers/mmc/host/dw_mmc.c                     |  2 +-
 drivers/mtd/nand/raw/nandsim.c                |  4 +-
 drivers/mtd/tests/mtd_nandecctest.c           | 10 +--
 drivers/mtd/tests/stresstest.c                |  8 +-
 drivers/mtd/ubi/debug.c                       |  2 +-
 drivers/mtd/ubi/debug.h                       |  6 +-
 drivers/net/ethernet/broadcom/cnic.c          |  2 +-
 .../chelsio/inline_crypto/chtls/chtls_io.c    |  4 +-
 drivers/net/phy/at803x.c                      |  2 +-
 drivers/net/team/team_mode_random.c           |  2 +-
 drivers/net/wireguard/selftest/allowedips.c   | 20 ++---
 drivers/net/wireguard/timers.c                |  4 +-
 .../broadcom/brcm80211/brcmfmac/p2p.c         |  2 +-
 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  2 +-
 drivers/pci/p2pdma.c                          |  2 +-
 drivers/s390/scsi/zfcp_fc.c                   |  2 +-
 drivers/scsi/fcoe/fcoe_ctlr.c                 |  4 +-
 drivers/scsi/qedi/qedi_main.c                 |  2 +-
 drivers/scsi/scsi_debug.c                     |  6 +-
 fs/ceph/inode.c                               |  2 +-
 fs/ceph/mdsmap.c                              |  2 +-
 fs/ext2/ialloc.c                              |  2 +-
 fs/ext4/ialloc.c                              |  2 +-
 fs/ext4/mmp.c                                 |  8 +-
 fs/ext4/super.c                               |  5 +-
 fs/f2fs/gc.c                                  |  2 +-
 fs/f2fs/segment.c                             |  8 +-
 fs/ubifs/debug.c                              |  8 +-
 fs/ubifs/lpt_commit.c                         | 14 +--
 fs/ubifs/tnc_commit.c                         |  2 +-
 fs/xfs/libxfs/xfs_alloc.c                     |  2 +-
 fs/xfs/libxfs/xfs_ialloc.c                    |  2 +-
 fs/xfs/xfs_error.c                            |  2 +-
 include/linux/damon.h                         |  2 +-
 include/linux/nodemask.h                      |  2 +-
 include/linux/prandom.h                       |  6 --
 include/linux/random.h                        | 24 ++++++
 kernel/bpf/core.c                             |  4 +-
 kernel/kcsan/selftest.c                       |  4 +-
 kernel/locking/test-ww_mutex.c                |  4 +-
 kernel/time/clocksource.c                     |  2 +-
 lib/fault-inject.c                            |  2 +-
 lib/find_bit_benchmark.c                      |  4 +-
 lib/kobject.c                                 |  2 +-
 lib/reed_solomon/test_rslib.c                 |  6 +-
 lib/sbitmap.c                                 |  4 +-
 lib/test-string_helpers.c                     |  2 +-
 lib/test_fprobe.c                             |  5 +-
 lib/test_hexdump.c                            | 10 +--
 lib/test_kprobes.c                            |  5 +-
 lib/test_list_sort.c                          |  2 +-
 lib/test_printf.c                             |  2 +-
 lib/test_rhashtable.c                         |  4 +-
 lib/test_vmalloc.c                            |  8 +-
 mm/kasan/kasan_test.c                         |  6 +-
 mm/kfence/core.c                              |  4 +-
 mm/kfence/kfence_test.c                       |  4 +-
 mm/slub.c                                     |  2 +-
 mm/swapfile.c                                 |  5 +-
 net/802/garp.c                                |  2 +-
 net/802/mrp.c                                 |  2 +-
 net/batman-adv/bat_iv_ogm.c                   |  4 +-
 net/batman-adv/bat_v_elp.c                    |  2 +-
 net/batman-adv/bat_v_ogm.c                    |  4 +-
 net/batman-adv/network-coding.c               |  2 +-
 net/bluetooth/mgmt.c                          |  5 +-
 net/can/j1939/socket.c                        |  2 +-
 net/can/j1939/transport.c                     |  2 +-
 net/ceph/mon_client.c                         |  2 +-
 net/ceph/osd_client.c                         |  2 +-
 net/core/neighbour.c                          |  4 +-
 net/core/pktgen.c                             | 37 ++++----
 net/core/stream.c                             |  2 +-
 net/ipv4/icmp.c                               |  2 +-
 net/ipv4/igmp.c                               |  6 +-
 net/ipv4/inet_connection_sock.c               |  2 +-
 net/ipv4/inet_hashtables.c                    |  2 +-
 net/ipv4/route.c                              |  4 +-
 net/ipv4/tcp_bbr.c                            |  2 +-
 net/ipv4/tcp_input.c                          |  3 +-
 net/ipv6/addrconf.c                           |  8 +-
 net/ipv6/mcast.c                              | 10 +--
 net/ipv6/output_core.c                        |  8 +-
 net/ipv6/route.c                              |  2 +-
 net/netfilter/ipvs/ip_vs_twos.c               |  4 +-
 net/netfilter/nf_conntrack_core.c             |  4 +-
 net/netfilter/nf_nat_helper.c                 |  2 +-
 net/netlink/af_netlink.c                      |  2 +-
 net/packet/af_packet.c                        |  4 +-
 net/sched/act_gact.c                          |  2 +-
 net/sched/act_sample.c                        |  2 +-
 net/sched/sch_choke.c                         |  2 +-
 net/sched/sch_netem.c                         |  4 +-
 net/sctp/socket.c                             |  2 +-
 net/sctp/transport.c                          |  2 +-
 net/sunrpc/cache.c                            |  2 +-
 net/sunrpc/xprtsock.c                         |  2 +-
 net/tipc/socket.c                             |  2 +-
 net/vmw_vsock/af_vsock.c                      |  3 +-
 net/xfrm/xfrm_state.c                         |  2 +-
 138 files changed, 309 insertions(+), 318 deletions(-)

-- 
2.38.1
