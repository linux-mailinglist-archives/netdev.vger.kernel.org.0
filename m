Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D16289240
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 21:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403805AbgJITut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 15:50:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:57507 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726357AbgJITup (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 15:50:45 -0400
IronPort-SDR: EgmAoyvHqLfUgUFSlazRhx1Cjp9MmVlenKbZYXMVRVRfgMzpJRftl57MJq2pMTa+nNfk+FbMHQ
 4ZNHJky2ihhA==
X-IronPort-AV: E=McAfee;i="6000,8403,9769"; a="152450718"
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="152450718"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:50:41 -0700
IronPort-SDR: wgvSBhlinBwJf2eRaqYm1d4mOPDeheaaBRmvXZpaWhx0BsPjq5MOqCRmfglsuVIrge+HvLIvQ5
 IT741lyNdN2Q==
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="419536654"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:50:41 -0700
From:   ira.weiny@intel.com
To:     Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Ira Weiny <ira.weiny@intel.com>, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kexec@lists.infradead.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, devel@driverdev.osuosl.org,
        linux-efi@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-aio@kvack.org,
        io-uring@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-um@lists.infradead.org, linux-ntfs-dev@lists.sourceforge.net,
        reiserfs-devel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, cluster-devel@redhat.com,
        ecryptfs@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-rdma@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-cachefs@redhat.com,
        samba-technical@lists.samba.org, intel-wired-lan@lists.osuosl.org
Subject: [PATCH RFC PKS/PMEM 00/58] PMEM: Introduce stray write protection for PMEM
Date:   Fri,  9 Oct 2020 12:49:35 -0700
Message-Id: <20201009195033.3208459-1-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

Should a stray write in the kernel occur persistent memory is affected more
than regular memory.  A write to the wrong area of memory could result in
latent data corruption which will will persist after a reboot.  PKS provides a
nice way to restrict access to persistent memory kernel mappings, while
providing fast access when needed.

Since the last RFC[1] this patch set has grown quite a bit.  It now depends on
the core patches submitted separately.

	https://lore.kernel.org/lkml/20201009194258.3207172-1-ira.weiny@intel.com/

And contained in the git tree here:

	https://github.com/weiny2/linux-kernel/tree/pks-rfc-v3

However, functionally there is only 1 major change from the last RFC.
Specifically, kmap() is most often used within a single thread in a 'map/do
something/unmap' pattern.  In fact this is the pattern used in ~90% of the
callers of kmap().  This pattern works very well for the pmem use case and the
testing which was done.  However, there were another ~20-30 kmap users which do
not follow this pattern.  Some of them seem to expect the mapping to be
'global' while others require a detailed audit to be sure.[2][3]

While we don't anticipate global mappings to pmem there is a danger in
changing the semantics of kmap().  Effectively, this would cause an unresolved
page fault with little to no information about why.

There were a number of options considered.

1) Attempt to change all the thread local kmap() calls to kmap_atomic()
2) Introduce a flags parameter to kmap() to indicate if the mapping should be
   global or not
3) Change ~20-30 call sites to 'kmap_global()' to indicate that they require a
   global mapping of the pages
4) Change ~209 call sites to 'kmap_thread()' to indicate that the mapping is to
   be used within that thread of execution only

Option 1 is simply not feasible kmap_atomic() is not the same semantic as
kmap() within a single tread.  Option 2 would require all of the call sites of
kmap() to change.  Option 3 seems like a good minimal change but there is a
danger that new code may miss the semantic change of kmap() and not get the
behavior intended for future users.  Therefore, option #4 was chosen.

To handle the global PKRS state in the most efficient manner possible.  We
lazily override the thread specific PKRS key value only when needed because we
anticipate PKS to not be needed will not be needed most of the time.  And even
when it is used 90% of the time it is a thread local call.


[1] https://lore.kernel.org/lkml/20200717072056.73134-1-ira.weiny@intel.com/

[2] The following list of callers continue calling kmap() (utilizing the global
PKRS).  It would be nice if more of them could be converted to kmap_thread()

	drivers/firewire/net.c:         ptr = kmap(dev->broadcast_rcv_buffer.pages[u]);
	drivers/gpu/drm/i915/gem/i915_gem_pages.c:              return kmap(sg_page(sgt->sgl));
	drivers/gpu/drm/ttm/ttm_bo_util.c:              map->virtual = kmap(map->page);
	drivers/infiniband/hw/qib/qib_user_sdma.c:      mpage = kmap(page);
	drivers/misc/vmw_vmci/vmci_host.c:      context->notify = kmap(context->notify_page) + (uva & (PAGE_SIZE - 1));
	drivers/misc/xilinx_sdfec.c:            addr = kmap(pages[i]);
	drivers/mmc/host/usdhi6rol0.c:  host->pg.mapped         = kmap(host->pg.page);
	drivers/mmc/host/usdhi6rol0.c:  host->pg.mapped = kmap(host->pg.page);
	drivers/mmc/host/usdhi6rol0.c:  host->pg.mapped = kmap(host->pg.page);
	drivers/nvme/target/tcp.c:              iov->iov_base = kmap(sg_page(sg)) + sg->offset + sg_offset;
	drivers/scsi/libiscsi_tcp.c:            segment->sg_mapped = kmap(sg_page(sg));
	drivers/target/iscsi/iscsi_target.c:            iov[i].iov_base = kmap(sg_page(sg)) + sg->offset + page_off;
	drivers/target/target_core_transport.c:         return kmap(sg_page(sg)) + sg->offset;
	fs/btrfs/check-integrity.c:             block_ctx->datav[i] = kmap(block_ctx->pagev[i]);
	fs/ceph/dir.c:          cache_ctl->dentries = kmap(cache_ctl->page);
	fs/ceph/inode.c:                ctl->dentries = kmap(ctl->page);
	fs/erofs/zpvec.h:               kmap_atomic(ctor->curr) : kmap(ctor->curr);
	lib/scatterlist.c:              miter->addr = kmap(miter->page) + miter->__offset;
	net/ceph/pagelist.c:    pl->mapped_tail = kmap(page);
	net/ceph/pagelist.c:            pl->mapped_tail = kmap(page);
	virt/kvm/kvm_main.c:                    hva = kmap(page);

[3] The following appear to follow the same pattern as ext2 which was converted
after some code audit.  So I _think_ they too could be converted to
k[un]map_thread().

	fs/freevxfs/vxfs_subr.c|75| kmap(pp);
	fs/jfs/jfs_metapage.c|102| kmap(page);
	fs/jfs/jfs_metapage.c|156| kmap(page);
	fs/minix/dir.c|72| kmap(page);
	fs/nilfs2/dir.c|195| kmap(page);
	fs/nilfs2/ifile.h|24| void *kaddr = kmap(ibh->b_page);
	fs/ntfs/aops.h|78| kmap(page);
	fs/ntfs/compress.c|574| kmap(page);
	fs/qnx6/dir.c|32| kmap(page);
	fs/qnx6/dir.c|58| kmap(*p = page);
	fs/qnx6/inode.c|190| kmap(page);
	fs/qnx6/inode.c|557| kmap(page);
	fs/reiserfs/inode.c|2397| kmap(bh_result->b_page);
	fs/reiserfs/xattr.c|444| kmap(page);
	fs/sysv/dir.c|60| kmap(page);
	fs/sysv/dir.c|262| kmap(page);
	fs/ufs/dir.c|194| kmap(page);
	fs/ufs/dir.c|562| kmap(page);


Ira Weiny (58):
  x86/pks: Add a global pkrs option
  x86/pks/test: Add testing for global option
  memremap: Add zone device access protection
  kmap: Add stray access protection for device pages
  kmap: Introduce k[un]map_thread
  kmap: Introduce k[un]map_thread debugging
  drivers/drbd: Utilize new kmap_thread()
  drivers/firmware_loader: Utilize new kmap_thread()
  drivers/gpu: Utilize new kmap_thread()
  drivers/rdma: Utilize new kmap_thread()
  drivers/net: Utilize new kmap_thread()
  fs/afs: Utilize new kmap_thread()
  fs/btrfs: Utilize new kmap_thread()
  fs/cifs: Utilize new kmap_thread()
  fs/ecryptfs: Utilize new kmap_thread()
  fs/gfs2: Utilize new kmap_thread()
  fs/nilfs2: Utilize new kmap_thread()
  fs/hfs: Utilize new kmap_thread()
  fs/hfsplus: Utilize new kmap_thread()
  fs/jffs2: Utilize new kmap_thread()
  fs/nfs: Utilize new kmap_thread()
  fs/f2fs: Utilize new kmap_thread()
  fs/fuse: Utilize new kmap_thread()
  fs/freevxfs: Utilize new kmap_thread()
  fs/reiserfs: Utilize new kmap_thread()
  fs/zonefs: Utilize new kmap_thread()
  fs/ubifs: Utilize new kmap_thread()
  fs/cachefiles: Utilize new kmap_thread()
  fs/ntfs: Utilize new kmap_thread()
  fs/romfs: Utilize new kmap_thread()
  fs/vboxsf: Utilize new kmap_thread()
  fs/hostfs: Utilize new kmap_thread()
  fs/cramfs: Utilize new kmap_thread()
  fs/erofs: Utilize new kmap_thread()
  fs: Utilize new kmap_thread()
  fs/ext2: Use ext2_put_page
  fs/ext2: Utilize new kmap_thread()
  fs/isofs: Utilize new kmap_thread()
  fs/jffs2: Utilize new kmap_thread()
  net: Utilize new kmap_thread()
  drivers/target: Utilize new kmap_thread()
  drivers/scsi: Utilize new kmap_thread()
  drivers/mmc: Utilize new kmap_thread()
  drivers/xen: Utilize new kmap_thread()
  drivers/firmware: Utilize new kmap_thread()
  drives/staging: Utilize new kmap_thread()
  drivers/mtd: Utilize new kmap_thread()
  drivers/md: Utilize new kmap_thread()
  drivers/misc: Utilize new kmap_thread()
  drivers/android: Utilize new kmap_thread()
  kernel: Utilize new kmap_thread()
  mm: Utilize new kmap_thread()
  lib: Utilize new kmap_thread()
  powerpc: Utilize new kmap_thread()
  samples: Utilize new kmap_thread()
  dax: Stray access protection for dax_direct_access()
  nvdimm/pmem: Stray access protection for pmem->virt_addr
  [dax|pmem]: Enable stray access protection

 Documentation/core-api/protection-keys.rst    |  11 +-
 arch/powerpc/mm/mem.c                         |   4 +-
 arch/x86/entry/common.c                       |  28 +++
 arch/x86/include/asm/pkeys.h                  |   6 +-
 arch/x86/include/asm/pkeys_common.h           |   8 +-
 arch/x86/kernel/process.c                     |  74 ++++++-
 arch/x86/mm/fault.c                           | 193 ++++++++++++++----
 arch/x86/mm/pkeys.c                           |  88 ++++++--
 drivers/android/binder_alloc.c                |   4 +-
 drivers/base/firmware_loader/fallback.c       |   4 +-
 drivers/base/firmware_loader/main.c           |   4 +-
 drivers/block/drbd/drbd_main.c                |   4 +-
 drivers/block/drbd/drbd_receiver.c            |  12 +-
 drivers/dax/device.c                          |   2 +
 drivers/dax/super.c                           |   2 +
 drivers/firmware/efi/capsule-loader.c         |   6 +-
 drivers/firmware/efi/capsule.c                |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c       |  12 +-
 drivers/gpu/drm/gma500/gma_display.c          |   4 +-
 drivers/gpu/drm/gma500/mmu.c                  |  10 +-
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c     |   4 +-
 .../drm/i915/gem/selftests/i915_gem_context.c |   4 +-
 .../drm/i915/gem/selftests/i915_gem_mman.c    |   8 +-
 drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c  |   4 +-
 drivers/gpu/drm/i915/gt/intel_gtt.c           |   4 +-
 drivers/gpu/drm/i915/gt/shmem_utils.c         |   4 +-
 drivers/gpu/drm/i915/i915_gem.c               |   8 +-
 drivers/gpu/drm/i915/i915_gpu_error.c         |   4 +-
 drivers/gpu/drm/i915/selftests/i915_perf.c    |   4 +-
 drivers/gpu/drm/radeon/radeon_ttm.c           |   4 +-
 drivers/infiniband/hw/hfi1/sdma.c             |   4 +-
 drivers/infiniband/hw/i40iw/i40iw_cm.c        |  10 +-
 drivers/infiniband/sw/siw/siw_qp_tx.c         |  14 +-
 drivers/md/bcache/request.c                   |   4 +-
 drivers/misc/vmw_vmci/vmci_queue_pair.c       |  12 +-
 drivers/mmc/host/mmc_spi.c                    |   4 +-
 drivers/mmc/host/sdricoh_cs.c                 |   4 +-
 drivers/mtd/mtd_blkdevs.c                     |  12 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c  |   4 +-
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |   4 +-
 drivers/nvdimm/pmem.c                         |   6 +
 drivers/scsi/ipr.c                            |   8 +-
 drivers/scsi/pmcraid.c                        |   8 +-
 drivers/staging/rts5208/rtsx_transport.c      |   4 +-
 drivers/target/target_core_iblock.c           |   4 +-
 drivers/target/target_core_rd.c               |   4 +-
 drivers/target/target_core_transport.c        |   4 +-
 drivers/xen/gntalloc.c                        |   4 +-
 fs/afs/dir.c                                  |  16 +-
 fs/afs/dir_edit.c                             |  16 +-
 fs/afs/mntpt.c                                |   4 +-
 fs/afs/write.c                                |   4 +-
 fs/aio.c                                      |   4 +-
 fs/binfmt_elf.c                               |   4 +-
 fs/binfmt_elf_fdpic.c                         |   4 +-
 fs/btrfs/check-integrity.c                    |   4 +-
 fs/btrfs/compression.c                        |   4 +-
 fs/btrfs/inode.c                              |  16 +-
 fs/btrfs/lzo.c                                |  24 +--
 fs/btrfs/raid56.c                             |  34 +--
 fs/btrfs/reflink.c                            |   8 +-
 fs/btrfs/send.c                               |   4 +-
 fs/btrfs/zlib.c                               |  32 +--
 fs/btrfs/zstd.c                               |  20 +-
 fs/cachefiles/rdwr.c                          |   4 +-
 fs/cifs/cifsencrypt.c                         |   6 +-
 fs/cifs/file.c                                |  16 +-
 fs/cifs/smb2ops.c                             |   8 +-
 fs/cramfs/inode.c                             |  10 +-
 fs/ecryptfs/crypto.c                          |   8 +-
 fs/ecryptfs/read_write.c                      |   8 +-
 fs/erofs/super.c                              |   4 +-
 fs/erofs/xattr.c                              |   4 +-
 fs/exec.c                                     |  10 +-
 fs/ext2/dir.c                                 |   8 +-
 fs/ext2/ext2.h                                |   8 +
 fs/ext2/namei.c                               |  15 +-
 fs/f2fs/f2fs.h                                |   8 +-
 fs/freevxfs/vxfs_immed.c                      |   4 +-
 fs/fuse/readdir.c                             |   4 +-
 fs/gfs2/bmap.c                                |   4 +-
 fs/gfs2/ops_fstype.c                          |   4 +-
 fs/hfs/bnode.c                                |  14 +-
 fs/hfs/btree.c                                |  20 +-
 fs/hfsplus/bitmap.c                           |  20 +-
 fs/hfsplus/bnode.c                            | 102 ++++-----
 fs/hfsplus/btree.c                            |  18 +-
 fs/hostfs/hostfs_kern.c                       |  12 +-
 fs/io_uring.c                                 |   4 +-
 fs/isofs/compress.c                           |   4 +-
 fs/jffs2/file.c                               |   8 +-
 fs/jffs2/gc.c                                 |   4 +-
 fs/nfs/dir.c                                  |  20 +-
 fs/nilfs2/alloc.c                             |  34 +--
 fs/nilfs2/cpfile.c                            |   4 +-
 fs/ntfs/aops.c                                |   4 +-
 fs/reiserfs/journal.c                         |   4 +-
 fs/romfs/super.c                              |   4 +-
 fs/splice.c                                   |   4 +-
 fs/ubifs/file.c                               |  16 +-
 fs/vboxsf/file.c                              |  12 +-
 fs/zonefs/super.c                             |   4 +-
 include/linux/entry-common.h                  |   3 +
 include/linux/highmem.h                       |  63 +++++-
 include/linux/memremap.h                      |   1 +
 include/linux/mm.h                            |  43 ++++
 include/linux/pkeys.h                         |   6 +-
 include/linux/sched.h                         |   8 +
 include/trace/events/kmap_thread.h            |  56 +++++
 init/init_task.c                              |   6 +
 kernel/fork.c                                 |  18 ++
 kernel/kexec_core.c                           |   8 +-
 lib/Kconfig.debug                             |   8 +
 lib/iov_iter.c                                |  12 +-
 lib/pks/pks_test.c                            | 138 +++++++++++--
 lib/test_bpf.c                                |   4 +-
 lib/test_hmm.c                                |   8 +-
 mm/Kconfig                                    |  13 ++
 mm/debug.c                                    |  23 +++
 mm/memory.c                                   |   8 +-
 mm/memremap.c                                 |  90 ++++++++
 mm/swapfile.c                                 |   4 +-
 mm/userfaultfd.c                              |   4 +-
 net/ceph/messenger.c                          |   4 +-
 net/core/datagram.c                           |   4 +-
 net/core/sock.c                               |   8 +-
 net/ipv4/ip_output.c                          |   4 +-
 net/sunrpc/cache.c                            |   4 +-
 net/sunrpc/xdr.c                              |   8 +-
 net/tls/tls_device.c                          |   4 +-
 samples/vfio-mdev/mbochs.c                    |   4 +-
 131 files changed, 1284 insertions(+), 565 deletions(-)
 create mode 100644 include/trace/events/kmap_thread.h

-- 
2.28.0.rc0.12.gb6a658bd00c9

