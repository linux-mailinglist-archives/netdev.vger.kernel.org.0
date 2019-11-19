Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3FA3101BB3
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 09:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbfKSIQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 03:16:53 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18959 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfKSIQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 03:16:51 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dd3a4ec0000>; Tue, 19 Nov 2019 00:16:44 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 19 Nov 2019 00:16:47 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 19 Nov 2019 00:16:47 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 19 Nov
 2019 08:16:47 +0000
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 19 Nov
 2019 08:16:47 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 19 Nov 2019 08:16:46 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5dd3a4ec0001>; Tue, 19 Nov 2019 00:16:45 -0800
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
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Paul Mackerras" <paulus@samba.org>, Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, <bpf@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH v6 00/24] mm/gup: track dma-pinned pages: FOLL_PIN
Date:   Tue, 19 Nov 2019 00:16:19 -0800
Message-ID: <20191119081643.1866232-1-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574151405; bh=rMiBdWoeixyPDtWYzTmzRQpS8VKDQMxDBjO/y0DQMhU=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         MIME-Version:X-NVConfidentiality:Content-Type:
         Content-Transfer-Encoding;
        b=WLX/+p3SX4otno270GjMRoGK72bOSIdvw/i3D4g83XM0LS9h8y4XP2LhAzY4g76Gp
         kWZvFfADGiBf+iXPFQQkb7jBQqidxAypEusdJNt46S2ncCcywrHVsGhs6ARrhaMHVN
         b/X6Tnp8pz0yTqBp06pKl60uPMd1NxOX6l06H1gbhqltD9WZpIzjWxQXIkfeOeEHCM
         LATxCdD2NjDuG+kcZL4WTOj234T35BuFgUuBdLkdJzYN5iUSkBrqyoP3dnHiKd6e/o
         5NqK6NinfzY9hRS46/066kwfkiFA7131rcBE/yPFj8CLFasS8xB30iEBlX40MuiOty
         nBv2ZxwR1HFsg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Christoph Hellwig has a preference to do things a little differently,
for the devmap cleanup in patch 5 ("mm: devmap: refactor 1-based
refcounting for ZONE_DEVICE pages"). That came up in a different
review thread, because the patch is out for review in two locations.
Here's that review thread:

    https://lore.kernel.org/r/20191118070826.GB3099@infradead.org

...and I'm hoping that we can defer that request, because otherwise
it derails this series, which is starting to otherwise look like
it could be ready for 5.5.

There is a git repo and branch, for convenience:

    git@github.com:johnhubbard/linux.git pin_user_pages_tracking_v6

Changes since v5:

* Fixed the refcounting for huge pages: in most cases, it was
  only taking one GUP_PIN_COUNTING_BIAS's worth of refs, when it
  should have been taking one GUP_PIN_COUNTING_BIAS for each subpage.

  (Much thanks to Jan Kara for spotting that one!)

* Renamed user_page_ref_inc() to try_pin_page(), and added a new
  try_pin_compound_head(). This definitely improves readability.

* Factored out some more duplication in the FOLL_PIN and FOLL_GET
  cases, in gup.c.

* Fixed up some straggling "get_" --> "pin_" references in the comments.

* Added reviewed-by tags.

Changes since v4:

* Renamed put_user_page*() --> unpin_user_page().

* Removed all pin_longterm_pages*() calls. We will use FOLL_LONGTERM
  at the call sites. (FOLL_PIN, however, remains an internal gup flag).

  This is very nice: many patches just change three characters now:
  get_user_pages --> pin_user_pages. I think we've found the right
  balance of wrapper calls and gup flags, for the call sites.

* Updated a lot of documentation and commit logs to match the above
  two large changes.

* Changed gup_benchmark tests and run_vmtests, to adapt to one less
  use case: there is no pin_longterm_pages() call anymore.

* This includes a new devmap cleanup patch from Dan Williams, along
  with a rebased follow-up: patches 4 and 5, already mentioned above.

* Fixed patch 10 ("mm/gup: introduce pin_user_pages*() and FOLL_PIN"),
  so as to make pin_user_pages*() calls act as placeholders for the
  corresponding get_user_pages*() calls, until a later patch fully
  implements the DMA-pinning functionality.

  Thanks to Jan Kara for noticing that.

* Fixed the implementation of pin_user_pages_remote().

* Further tweaked patch 2 ("mm/gup: factor out duplicate code from four
  routines"), in response to Jan Kara's feedback.

* Dropped a few reviewed-by tags  due to changes that invalidated
  them.


Changes since v3:

* VFIO fix (patch 8): applied further cleanup: removed a pre-existing,
  unnecessary release and reacquire of mmap_sem. Moved the DAX vma
  checks from the vfio call site, to gup internals, and added comments
  (and commit log) to clarify.

* Due to the above, made a corresponding fix to the
  pin_longterm_pages_remote(), which was actually calling the wrong
  gup internal function.

* Changed put_user_page() comments, to refer to pin*() APIs, rather than
  get_user_pages*() APIs.

* Reverted an accidental whitespace-only change in the IB ODP code.

* Added a few more reviewed-by tags.


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

* Patches 1-9: refactoring and preparatory cleanup, independent fixes

* Patch 10: introduce pin_user_pages(), FOLL_PIN, but no functional
           changes yet
* Patches 11-16: Convert existing put_user_page() callers, to use the
                 new pin*()
* Patch 17: Activate tracking of FOLL_PIN pages.
* Patches 18-20: convert various callers
* Patches: 21-23: gup_benchmark and run_vmtests support
* Patch 24: rename put_user_page*() --> unpin_user_page*()

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


Dan Williams (1):
  mm: Cleanup __put_devmap_managed_page() vs ->page_free()

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
  IB/{core,hw,umem}: set FOLL_PIN via pin_user_pages*(), fix up ODP
  mm/process_vm_access: set FOLL_PIN via pin_user_pages_remote()
  drm/via: set FOLL_PIN via pin_user_pages_fast()
  fs/io_uring: set FOLL_PIN via pin_user_pages()
  net/xdp: set FOLL_PIN via pin_user_pages()
  mm/gup: track FOLL_PIN pages
  media/v4l2-core: pin_user_pages (FOLL_PIN) and put_user_page()
    conversion
  vfio, mm: pin_user_pages (FOLL_PIN) and put_user_page() conversion
  powerpc: book3s64: convert to pin_user_pages() and put_user_page()
  mm/gup_benchmark: use proper FOLL_WRITE flags instead of hard-coding
    "1"
  mm/gup_benchmark: support pin_user_pages() and related calls
  selftests/vm: run_vmtests: invoke gup_benchmark with basic FOLL_PIN
    coverage
  mm, tree-wide: rename put_user_page*() to unpin_user_page*()

 Documentation/core-api/index.rst            |   1 +
 Documentation/core-api/pin_user_pages.rst   | 233 +++++++++
 arch/powerpc/mm/book3s64/iommu_api.c        |  12 +-
 drivers/gpu/drm/via/via_dmablit.c           |   6 +-
 drivers/infiniband/core/umem.c              |  19 +-
 drivers/infiniband/core/umem_odp.c          |  13 +-
 drivers/infiniband/hw/hfi1/user_pages.c     |   4 +-
 drivers/infiniband/hw/mthca/mthca_memfree.c |   8 +-
 drivers/infiniband/hw/qib/qib_user_pages.c  |   4 +-
 drivers/infiniband/hw/qib/qib_user_sdma.c   |   8 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c    |   4 +-
 drivers/infiniband/sw/siw/siw_mem.c         |   4 +-
 drivers/media/v4l2-core/videobuf-dma-sg.c   |   8 +-
 drivers/nvdimm/pmem.c                       |   6 -
 drivers/platform/goldfish/goldfish_pipe.c   |  35 +-
 drivers/vfio/vfio_iommu_type1.c             |  35 +-
 fs/io_uring.c                               |   6 +-
 include/linux/mm.h                          | 168 +++++-
 include/linux/mmzone.h                      |   2 +
 include/linux/page_ref.h                    |  10 +
 mm/gup.c                                    | 548 +++++++++++++++-----
 mm/gup_benchmark.c                          |  74 ++-
 mm/huge_memory.c                            |  54 +-
 mm/hugetlb.c                                |  39 +-
 mm/memremap.c                               |  76 ++-
 mm/process_vm_access.c                      |  28 +-
 mm/vmstat.c                                 |   2 +
 net/xdp/xdp_umem.c                          |   4 +-
 tools/testing/selftests/vm/gup_benchmark.c  |  21 +-
 tools/testing/selftests/vm/run_vmtests      |  22 +
 30 files changed, 1104 insertions(+), 350 deletions(-)
 create mode 100644 Documentation/core-api/pin_user_pages.rst

--=20
2.24.0

