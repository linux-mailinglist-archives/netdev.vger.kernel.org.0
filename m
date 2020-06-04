Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A469B1EE2B9
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 12:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgFDKpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 06:45:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbgFDKpx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jun 2020 06:45:53 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0ADEF206A2;
        Thu,  4 Jun 2020 10:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591267552;
        bh=7HIqpsm0tm+2XExfq0AzdkL8CefjTuY4JD+t1WaHJ4Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nXIxctdaDUfVJdM+aVx4FqqdFME3BCC7lIl7cnNWHBv+Ri7byDCS4FFYYUN6Ee9x6
         Z1bV+VEf2rZESvfw5OOW4VO+j4l7ZmhyfBLlgMR7rWLCtPVrCC1bEr6rIYpehp+eNL
         h2ZQ25FifK80ZDfBN33Btek9OiE549FI31YqnKcA=
Date:   Thu, 4 Jun 2020 13:45:49 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>, x86@kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mm@kvack.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH 09/10] treewide: Remove uninitialized_var() usage
Message-ID: <20200604104549.GC8834@unreal>
References: <20200603233203.1695403-1-keescook@chromium.org>
 <20200603233203.1695403-10-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603233203.1695403-10-keescook@chromium.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 04:32:02PM -0700, Kees Cook wrote:
> Using uninitialized_var() is dangerous as it papers over real bugs[1]
> (or can in the future), and suppresses unrelated compiler warnings
> (e.g. "unused variable"). If the compiler thinks it is uninitialized,
> either simply initialize the variable or make compiler changes.
>
> I preparation for removing[2] the[3] macro[4], remove all remaining
> needless uses with the following script:
>
> git grep '\buninitialized_var\b' | cut -d: -f1 | sort -u | \
> 	xargs perl -pi -e \
> 		's/\buninitialized_var\(([^\)]+)\)/\1/g;
> 		 s:\s*/\* (GCC be quiet|to make compiler happy) \*/$::g;'
>
> drivers/video/fbdev/riva/riva_hw.c was manually tweaked to avoid
> pathological white-space.
>
> No outstanding warnings were found building allmodconfig with GCC 9.3.0
> for x86_64, i386, arm64, arm, powerpc, powerpc64le, s390x, mips, sparc64,
> alpha, and m68k.
>
> [1] https://lore.kernel.org/lkml/20200603174714.192027-1-glider@google.com/
> [2] https://lore.kernel.org/lkml/CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com/
> [3] https://lore.kernel.org/lkml/CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz9knmPuXhOeg@mail.gmail.com/
> [4] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/arm/mach-sa1100/assabet.c                   |  2 +-
>  arch/arm/mm/alignment.c                          |  2 +-
>  arch/ia64/kernel/process.c                       |  2 +-
>  arch/ia64/mm/discontig.c                         |  2 +-
>  arch/ia64/mm/tlb.c                               |  2 +-
>  arch/mips/lib/dump_tlb.c                         |  2 +-
>  arch/mips/mm/init.c                              |  2 +-
>  arch/mips/mm/tlb-r4k.c                           |  6 +++---
>  arch/powerpc/kvm/book3s_64_mmu_radix.c           |  2 +-
>  arch/powerpc/kvm/book3s_pr.c                     |  2 +-
>  arch/powerpc/kvm/powerpc.c                       |  2 +-
>  arch/powerpc/platforms/52xx/mpc52xx_pic.c        |  2 +-
>  arch/s390/kernel/smp.c                           |  2 +-
>  arch/x86/kernel/quirks.c                         | 10 +++++-----
>  arch/x86/kvm/mmu/mmu.c                           |  2 +-
>  arch/x86/kvm/mmu/paging_tmpl.h                   |  2 +-
>  arch/x86/kvm/x86.c                               |  2 +-
>  block/blk-merge.c                                |  2 +-
>  drivers/acpi/acpi_pad.c                          |  2 +-
>  drivers/ata/libata-scsi.c                        |  2 +-
>  drivers/atm/zatm.c                               |  2 +-
>  drivers/block/drbd/drbd_nl.c                     |  6 +++---
>  drivers/block/rbd.c                              |  2 +-
>  drivers/clk/clk-gate.c                           |  2 +-
>  drivers/clk/spear/clk-vco-pll.c                  |  2 +-
>  drivers/crypto/nx/nx-842-powernv.c               |  2 +-
>  drivers/firewire/ohci.c                          | 14 +++++++-------
>  drivers/gpu/drm/bridge/sil-sii8620.c             |  2 +-
>  drivers/gpu/drm/drm_edid.c                       |  2 +-
>  drivers/gpu/drm/exynos/exynos_drm_dsi.c          |  6 +++---
>  drivers/gpu/drm/i915/display/intel_fbc.c         |  2 +-
>  drivers/gpu/drm/i915/gt/intel_lrc.c              |  2 +-
>  drivers/gpu/drm/i915/intel_uncore.c              |  2 +-
>  drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c  |  4 ++--
>  drivers/i2c/busses/i2c-rk3x.c                    |  2 +-
>  drivers/ide/ide-acpi.c                           |  2 +-
>  drivers/ide/ide-atapi.c                          |  2 +-
>  drivers/ide/ide-io-std.c                         |  4 ++--
>  drivers/ide/ide-io.c                             |  8 ++++----
>  drivers/ide/ide-sysfs.c                          |  2 +-
>  drivers/ide/umc8672.c                            |  2 +-
>  drivers/idle/intel_idle.c                        |  2 +-
>  drivers/infiniband/core/uverbs_cmd.c             |  4 ++--
>  drivers/infiniband/hw/cxgb4/cm.c                 |  2 +-
>  drivers/infiniband/hw/cxgb4/cq.c                 |  2 +-
>  drivers/infiniband/hw/mlx4/qp.c                  |  6 +++---
>  drivers/infiniband/hw/mlx5/cq.c                  |  6 +++---
>  drivers/infiniband/hw/mlx5/devx.c                |  2 +-
>  drivers/infiniband/hw/mlx5/qp.c                  |  2 +-
>  drivers/infiniband/hw/mthca/mthca_qp.c           | 10 +++++-----
>  drivers/infiniband/sw/siw/siw_qp_rx.c            |  2 +-
>  drivers/input/serio/serio_raw.c                  |  2 +-
>  drivers/input/touchscreen/sur40.c                |  2 +-
>  drivers/iommu/intel-iommu.c                      |  2 +-
>  drivers/md/dm-io.c                               |  2 +-
>  drivers/md/dm-ioctl.c                            |  2 +-
>  drivers/md/dm-snap-persistent.c                  |  2 +-
>  drivers/md/dm-table.c                            |  2 +-
>  drivers/md/dm-writecache.c                       |  2 +-
>  drivers/md/raid5.c                               |  2 +-
>  drivers/media/dvb-frontends/rtl2832.c            |  2 +-
>  drivers/media/tuners/qt1010.c                    |  4 ++--
>  drivers/media/usb/gspca/vicam.c                  |  2 +-
>  drivers/media/usb/uvc/uvc_video.c                |  8 ++++----
>  drivers/memstick/host/jmb38x_ms.c                |  2 +-
>  drivers/memstick/host/tifm_ms.c                  |  2 +-
>  drivers/mmc/host/sdhci.c                         |  2 +-
>  drivers/mtd/nand/raw/nand_ecc.c                  |  2 +-
>  drivers/mtd/nand/raw/s3c2410.c                   |  2 +-
>  drivers/mtd/parsers/afs.c                        |  4 ++--
>  drivers/mtd/ubi/eba.c                            |  2 +-
>  drivers/net/can/janz-ican3.c                     |  2 +-
>  drivers/net/ethernet/broadcom/bnx2.c             |  4 ++--
>  .../net/ethernet/mellanox/mlx5/core/pagealloc.c  |  4 ++--
>  drivers/net/ethernet/neterion/s2io.c             |  2 +-
>  drivers/net/ethernet/qlogic/qla3xxx.c            |  2 +-
>  drivers/net/ethernet/sun/cassini.c               |  2 +-
>  drivers/net/ethernet/sun/niu.c                   |  6 +++---
>  drivers/net/wan/z85230.c                         |  2 +-
>  drivers/net/wireless/ath/ath10k/core.c           |  2 +-
>  drivers/net/wireless/ath/ath6kl/init.c           |  2 +-
>  drivers/net/wireless/ath/ath9k/init.c            |  2 +-
>  drivers/net/wireless/broadcom/b43/debugfs.c      |  2 +-
>  drivers/net/wireless/broadcom/b43/dma.c          |  2 +-
>  drivers/net/wireless/broadcom/b43/lo.c           |  2 +-
>  drivers/net/wireless/broadcom/b43/phy_n.c        |  2 +-
>  drivers/net/wireless/broadcom/b43/xmit.c         | 12 ++++++------
>  .../net/wireless/broadcom/b43legacy/debugfs.c    |  2 +-
>  drivers/net/wireless/broadcom/b43legacy/main.c   |  2 +-
>  drivers/net/wireless/intel/iwlegacy/3945.c       |  2 +-
>  drivers/net/wireless/intel/iwlegacy/4965-mac.c   |  2 +-
>  .../net/wireless/realtek/rtlwifi/rtl8192cu/hw.c  |  4 ++--
>  drivers/pci/pcie/aer.c                           |  2 +-
>  drivers/platform/x86/hdaps.c                     |  4 ++--
>  drivers/scsi/dc395x.c                            |  2 +-
>  drivers/scsi/pm8001/pm8001_hwi.c                 |  2 +-
>  drivers/scsi/pm8001/pm80xx_hwi.c                 |  2 +-
>  drivers/ssb/driver_chipcommon.c                  |  4 ++--
>  drivers/tty/cyclades.c                           |  2 +-
>  drivers/tty/isicom.c                             |  2 +-
>  drivers/usb/musb/cppi_dma.c                      |  2 +-
>  drivers/usb/storage/sddr55.c                     |  4 ++--
>  drivers/vhost/net.c                              |  6 +++---
>  drivers/video/fbdev/matrox/matroxfb_maven.c      |  6 +++---
>  drivers/video/fbdev/pm3fb.c                      |  6 +++---
>  drivers/video/fbdev/riva/riva_hw.c               |  3 +--
>  drivers/virtio/virtio_ring.c                     |  6 +++---
>  fs/afs/dir.c                                     |  2 +-
>  fs/afs/security.c                                |  2 +-
>  fs/dlm/netlink.c                                 |  2 +-
>  fs/erofs/data.c                                  |  4 ++--
>  fs/erofs/zdata.c                                 |  2 +-
>  fs/f2fs/data.c                                   |  2 +-
>  fs/fat/dir.c                                     |  2 +-
>  fs/fuse/control.c                                |  4 ++--
>  fs/fuse/cuse.c                                   |  2 +-
>  fs/fuse/file.c                                   |  2 +-
>  fs/gfs2/aops.c                                   |  2 +-
>  fs/gfs2/bmap.c                                   |  2 +-
>  fs/gfs2/lops.c                                   |  2 +-
>  fs/hfsplus/unicode.c                             |  2 +-
>  fs/isofs/namei.c                                 |  4 ++--
>  fs/jffs2/erase.c                                 |  2 +-
>  fs/nfsd/nfsctl.c                                 |  2 +-
>  fs/ocfs2/alloc.c                                 |  4 ++--
>  fs/ocfs2/dir.c                                   | 14 +++++++-------
>  fs/ocfs2/extent_map.c                            |  4 ++--
>  fs/ocfs2/namei.c                                 |  2 +-
>  fs/ocfs2/refcounttree.c                          |  2 +-
>  fs/ocfs2/xattr.c                                 |  2 +-
>  fs/omfs/file.c                                   |  2 +-
>  fs/overlayfs/copy_up.c                           |  4 ++--
>  fs/ubifs/commit.c                                |  6 +++---
>  fs/ubifs/dir.c                                   |  2 +-
>  fs/ubifs/file.c                                  |  4 ++--
>  fs/ubifs/journal.c                               |  4 ++--
>  fs/ubifs/lpt.c                                   |  2 +-
>  fs/ubifs/tnc.c                                   |  6 +++---
>  fs/ubifs/tnc_misc.c                              |  4 ++--
>  fs/udf/balloc.c                                  |  2 +-
>  fs/xfs/xfs_bmap_util.c                           |  2 +-
>  include/net/flow_offload.h                       |  2 +-
>  kernel/async.c                                   |  4 ++--
>  kernel/audit.c                                   |  2 +-
>  kernel/debug/kdb/kdb_io.c                        |  2 +-
>  kernel/dma/debug.c                               |  2 +-
>  kernel/events/core.c                             |  2 +-
>  kernel/events/uprobes.c                          |  2 +-
>  kernel/exit.c                                    |  2 +-
>  kernel/futex.c                                   | 14 +++++++-------
>  kernel/locking/lockdep.c                         | 16 ++++++++--------
>  kernel/trace/ring_buffer.c                       |  2 +-
>  lib/radix-tree.c                                 |  2 +-
>  lib/test_lockup.c                                |  2 +-
>  mm/frontswap.c                                   |  2 +-
>  mm/ksm.c                                         |  2 +-
>  mm/memcontrol.c                                  |  2 +-
>  mm/memory.c                                      |  2 +-
>  mm/mempolicy.c                                   |  4 ++--
>  mm/page_alloc.c                                  |  2 +-
>  mm/percpu.c                                      |  2 +-
>  mm/slub.c                                        |  4 ++--
>  mm/swap.c                                        |  4 ++--
>  net/dccp/options.c                               |  2 +-
>  net/ipv4/netfilter/nf_socket_ipv4.c              |  6 +++---
>  net/ipv6/ip6_flowlabel.c                         |  2 +-
>  net/ipv6/netfilter/nf_socket_ipv6.c              |  2 +-
>  net/netfilter/nf_conntrack_ftp.c                 |  2 +-
>  net/netfilter/nfnetlink_log.c                    |  2 +-
>  net/netfilter/nfnetlink_queue.c                  |  4 ++--
>  net/sched/cls_flow.c                             |  2 +-
>  net/sched/sch_cake.c                             |  2 +-
>  net/sched/sch_cbq.c                              |  2 +-
>  net/sched/sch_fq_codel.c                         |  2 +-
>  net/sched/sch_fq_pie.c                           |  2 +-
>  net/sched/sch_hfsc.c                             |  2 +-
>  net/sched/sch_htb.c                              |  2 +-
>  net/sched/sch_sfq.c                              |  2 +-
>  net/sunrpc/svcsock.c                             |  4 ++--
>  net/sunrpc/xprtsock.c                            | 10 +++++-----
>  net/tls/tls_sw.c                                 |  2 +-
>  sound/core/control_compat.c                      |  2 +-
>  sound/isa/sb/sb16_csp.c                          |  2 +-
>  sound/usb/endpoint.c                             |  2 +-
>  184 files changed, 284 insertions(+), 285 deletions(-)

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com> # drivers/infiniband and mlx4/mlx5
