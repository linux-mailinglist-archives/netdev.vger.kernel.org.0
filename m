Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1F53F84AD
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 01:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbfKLAHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 19:07:15 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:10605 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbfKLAHN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 19:07:13 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dc9f7aa0001>; Mon, 11 Nov 2019 16:07:06 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 11 Nov 2019 16:07:04 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 11 Nov 2019 16:07:04 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 Nov
 2019 00:07:03 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 12 Nov 2019 00:07:02 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5dc9f7a50005>; Mon, 11 Nov 2019 16:07:02 -0800
From:   John Hubbard <jhubbard@nvidia.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, <bpf@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH v3 00/23] mm/gup: track dma-pinned pages: FOLL_PIN, FOLL_LONGTERM
Date:   Mon, 11 Nov 2019 16:06:37 -0800
Message-ID: <20191112000700.3455038-1-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573517227; bh=JNzo7F9Uhd78yzMBde3KTfKR6QFKvOysu7c55VwbHak=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         MIME-Version:X-NVConfidentiality:Content-Type:
         Content-Transfer-Encoding;
        b=o9SF4xl64HRgEPHvkHoWRVd6NPoz/55me3p6LoD2kIji1LweghyUDktb6XSAQ3iJ3
         cfhFxMryHc9DJrJcCIFZ3iGqYwt2ssscfuhFFw/XpSbJT58EIt8L9y6LerhnrPSHE3
         EdEpFQ6NH4d8IOKai6LAR4Axw5mIKHuTnBygTtUlZdZPySg+d0A3Oy0fKaInMWyT9J
         SvANrkrJ9clhDPNVmeNO+XuHM5bjvqzzMZ/NiVknqIu7c9yXMCGlTlzlbPMzqDPBT5
         jrQ55E6H2Wxm3RXAN8Ep0kb7yVwABixc+8zsJQbE9QB8LK08Q0+uUWO2trTbA96gmB
         /2JmtFtig54FQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The cover letter is long, so the more important stuff is first:

* Jason, if you or someone could look at the the VFIO cleanup (patch 8)
  and conversion to FOLL_PIN (patch 18), to make sure it's use of
  remote and longterm gup matches what we discussed during the review
  of v2, I'd appreciate it.

* Also for Jason and IB: as noted below, in patch 11, I am (too?) boldly
  converting from put_user_pages() to release_pages().

* Jerome, I am going to take a look at doing your FOLL_GET change idea
  (some callers should set FOLL_GET) separately, because it blew up "a
  little bit" in my face. It's definitely a separate--tiny, but risky--proj=
ect.
  It also looks more reasonable when applied on top of this series here
  (and it conflicts a lot), so I'm going to send it as a follow-up.

Changes since v2:

* Added a patch to convert IB/umem from normal gup, to gup_fast(). This
  is also posted separately, in order to hopefully get some runtime
  testing.

* Changed the page devmap code to be a little clearer,
  thanks to Jerome for that.

* Split out the page devmap changes into a separate patch (and moved
  Ira's Signed-off-by to that patch).

* Fixed my bug in IB: ODP code does not require pin_user_pages()
  semantics. Therefore, revert the put_user_page() calls to put_page(),
  and leave the get_user_pages() call as-is.

      * As part of the revert, I am proposing here a change directly
        from put_user_pages(), to release_pages(). I'd feel better if
        someone agrees that this is the best way. It uses the more
        efficient release_pages(), instead of put_page() in a loop,
        and keep the change to just a few character on one line,
        but OTOH it is not a pure revert.

* Loosened the FOLL_LONGTERM restrictions in the
  __get_user_pages_locked() implementation, and used that in order
  to fix up a VFIO bug. Thanks to Jason for that idea.

    * Note the use of release_pages() in IB: is that OK?

* Added a few more WARN's and clarifying comments nearby.

* Many documentation improvements in various comments.

* Moved the new pin_user_pages.rst from Documentation/vm/ to
  Documentation/core-api/ .

* Commit descriptions: added clarifying notes to the three patches
  (drm/via, fs/io_uring, net/xdp) that already had put_user_page()
  calls in place.

* Collected all pending Reviewed-by and Acked-by tags, from v1 and v2
  email threads.

* Lot of churn from v2 --> v3, so it's possible that new bugs
  sneaked in.

NOT DONE: separate patchset is required:

* __get_user_pages_locked(): stop compensating for
  buggy callers who failed to set FOLL_GET. Instead, assert
  that FOLL_GET is set (and fail if it's not).

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Original cover letter (edited to fix up the patch description numbers)

This applies cleanly to linux-next and mmotm, and also to linux.git if
linux-next's commit 20cac10710c9 ("mm/gup_benchmark: fix MAP_HUGETLB
case") is first applied there.

This provides tracking of dma-pinned pages. This is a prerequisite to
solving the larger problem of proper interactions between file-backed
pages, and [R]DMA activities, as discussed in [1], [2], [3], and in
a remarkable number of email threads since about 2017. :)

A new internal gup flag, FOLL_PIN is introduced, and thoroughly
documented in the last patch's Documentation/vm/pin_user_pages.rst.

I believe that this will provide a good starting point for doing the
layout lease work that Ira Weiny has been working on. That's because
these new wrapper functions provide a clean, constrained, systematically
named set of functionality that, again, is required in order to even
know if a page is "dma-pinned".

In contrast to earlier approaches, the page tracking can be
incrementally applied to the kernel call sites that, until now, have
been simply calling get_user_pages() ("gup"). In other words, opt-in by
changing from this:

    get_user_pages() (sets FOLL_GET)
    put_page()

to this:
    pin_user_pages() (sets FOLL_PIN)
    put_user_page()

Because there are interdependencies with FOLL_LONGTERM, a similar
conversion as for FOLL_PIN, was applied. The change was from this:

    get_user_pages(FOLL_LONGTERM) (also sets FOLL_GET)
    put_page()

to this:
    pin_longterm_pages() (sets FOLL_PIN | FOLL_LONGTERM)
    put_user_page()

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Patch summary:

* Patches 1-8: refactoring and preparatory cleanup, independent fixes

* Patch 9: introduce pin_user_pages(), FOLL_PIN, but no functional
           changes yet
* Patches 10-15: Convert existing put_user_page() callers, to use the
                new pin*()
* Patch 16: Activate tracking of FOLL_PIN pages.
* Patches 17-19: convert FOLL_LONGTERM callers
* Patches: 20-22: gup_benchmark and run_vmtests support
* Patch 23: enforce FOLL_LONGTERM as a gup-internal (only) flag

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Testing:

* I've done some overall kernel testing (LTP, and a few other goodies),
  and some directed testing to exercise some of the changes. And as you
  can see, gup_benchmark is enhanced to exercise this. Basically, I've been
  able to runtime test the core get_user_pages() and pin_user_pages() and
  related routines, but not so much on several of the call sites--but those
  are generally just a couple of lines changed, each.

  Not much of the kernel is actually using this, which on one hand
  reduces risk quite a lot. But on the other hand, testing coverage
  is low. So I'd love it if, in particular, the Infiniband and PowerPC
  folks could do a smoke test of this series for me.

  Also, my runtime testing for the call sites so far is very weak:

    * io_uring: Some directed tests from liburing exercise this, and they p=
ass.
    * process_vm_access.c: A small directed test passes.
    * gup_benchmark: the enhanced version hits the new gup.c code, and pass=
es.
    * infiniband (still only have crude "IB pingpong" working, on a
                  good day: it's not exercising my conversions at runtime..=
.)
    * VFIO: compiles (I'm vowing to set up a run time test soon, but it's
                      not ready just yet)
    * powerpc: it compiles...
    * drm/via: compiles...
    * goldfish: compiles...
    * net/xdp: compiles...
    * media/v4l2: compiles...

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Next:

* Get the block/bio_vec sites converted to use pin_user_pages().

* Work with Ira and Dave Chinner to weave this together with the
  layout lease stuff.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

[1] Some slow progress on get_user_pages() (Apr 2, 2019): https://lwn.net/A=
rticles/784574/
[2] DMA and get_user_pages() (LPC: Dec 12, 2018): https://lwn.net/Articles/=
774411/
[3] The trouble with get_user_pages() (Apr 30, 2018): https://lwn.net/Artic=
les/753027/

John Hubbard (23):
  mm/gup: pass flags arg to __gup_device_* functions
  mm/gup: factor out duplicate code from four routines
  mm/gup: move try_get_compound_head() to top, fix minor issues
  mm: devmap: refactor 1-based refcounting for ZONE_DEVICE pages
  goldish_pipe: rename local pin_user_pages() routine
  IB/umem: use get_user_pages_fast() to pin DMA pages
  media/v4l2-core: set pages dirty upon releasing DMA buffers
  vfio, mm: fix get_user_pages_remote() and FOLL_LONGTERM
  mm/gup: introduce pin_user_pages*() and FOLL_PIN
  goldish_pipe: convert to pin_user_pages() and put_user_page()
  IB/{core,hw,umem}: set FOLL_PIN, FOLL_LONGTERM via
    pin_longterm_pages*()
  mm/process_vm_access: set FOLL_PIN via pin_user_pages_remote()
  drm/via: set FOLL_PIN via pin_user_pages_fast()
  fs/io_uring: set FOLL_PIN via pin_user_pages()
  net/xdp: set FOLL_PIN via pin_user_pages()
  mm/gup: track FOLL_PIN pages
  media/v4l2-core: pin_longterm_pages (FOLL_PIN) and put_user_page()
    conversion
  vfio, mm: pin_longterm_pages (FOLL_PIN) and put_user_page() conversion
  powerpc: book3s64: convert to pin_longterm_pages() and put_user_page()
  mm/gup_benchmark: use proper FOLL_WRITE flags instead of hard-coding
    "1"
  mm/gup_benchmark: support pin_user_pages() and related calls
  selftests/vm: run_vmtests: invoke gup_benchmark with basic FOLL_PIN
    coverage
  mm/gup: remove support for gup(FOLL_LONGTERM)

 Documentation/core-api/index.rst            |   1 +
 Documentation/core-api/pin_user_pages.rst   | 218 +++++++
 arch/powerpc/mm/book3s64/iommu_api.c        |  15 +-
 drivers/gpu/drm/via/via_dmablit.c           |   2 +-
 drivers/infiniband/core/umem.c              |  17 +-
 drivers/infiniband/core/umem_odp.c          |  24 +-
 drivers/infiniband/hw/hfi1/user_pages.c     |   4 +-
 drivers/infiniband/hw/mthca/mthca_memfree.c |   3 +-
 drivers/infiniband/hw/qib/qib_user_pages.c  |   8 +-
 drivers/infiniband/hw/qib/qib_user_sdma.c   |   2 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c    |   9 +-
 drivers/infiniband/sw/siw/siw_mem.c         |   5 +-
 drivers/media/v4l2-core/videobuf-dma-sg.c   |  10 +-
 drivers/platform/goldfish/goldfish_pipe.c   |  35 +-
 drivers/vfio/vfio_iommu_type1.c             |  35 +-
 fs/io_uring.c                               |   5 +-
 include/linux/mm.h                          | 164 +++++-
 include/linux/mmzone.h                      |   2 +
 include/linux/page_ref.h                    |  10 +
 mm/gup.c                                    | 608 ++++++++++++++++----
 mm/gup_benchmark.c                          |  87 ++-
 mm/huge_memory.c                            |  54 +-
 mm/hugetlb.c                                |  39 +-
 mm/memremap.c                               |  67 +--
 mm/process_vm_access.c                      |  28 +-
 mm/vmstat.c                                 |   2 +
 net/xdp/xdp_umem.c                          |   4 +-
 tools/testing/selftests/vm/gup_benchmark.c  |  34 +-
 tools/testing/selftests/vm/run_vmtests      |  22 +
 29 files changed, 1180 insertions(+), 334 deletions(-)
 create mode 100644 Documentation/core-api/pin_user_pages.rst

--=20
2.24.0

