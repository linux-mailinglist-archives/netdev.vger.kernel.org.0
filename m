Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFA51096B0
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 00:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbfKYXKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 18:10:50 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11207 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbfKYXKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 18:10:48 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ddc5f710000>; Mon, 25 Nov 2019 15:10:41 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 25 Nov 2019 15:10:39 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 25 Nov 2019 15:10:39 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Nov
 2019 23:10:39 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 25 Nov 2019 23:10:38 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5ddc5f6c0003>; Mon, 25 Nov 2019 15:10:37 -0800
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
Subject: [PATCH v2 00/19] pin_user_pages(): reduced-risk series for Linux 5.5
Date:   Mon, 25 Nov 2019 15:10:16 -0800
Message-ID: <20191125231035.1539120-1-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574723442; bh=+fKR9i8A1AVbpAkGEFz1AM9ETJRVeSf0J2MygF32l5w=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         MIME-Version:X-NVConfidentiality:Content-Type:
         Content-Transfer-Encoding;
        b=ndO1kyYw+Aj7PJ1b4CON5Q8+SrIcwXlb45V4tj+JVPm5a7tM/5raJmkf+oA8o+7Gn
         q+DZKnhL8HDAd4gc+VTmeQE/lO9R3WtF6DClR/Ox8lkKenA2hi3RkIsDbZBRb7/N9I
         u7vqu7OPX0uJIMsnOGPaXiQsQ3livkjU+Uydd8H70Bkagfvsff/O1UWDvtASk/ZD/5
         j3u+3hA9MXsiO5zM+Fvjg+mWEqNbbdrTimvMMM1CyULJLiNKjbxsllY9FZaTQHKnou
         7YD0HiYvc6l3EAutS7qMBed3ruw+5cxaPaf8mdXNhpDMt5CU2G9r209+vuG622feZ3
         9j/62y8q4ASVw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Changes since v1:

* Fixed up ppc in response to Jan Kara's review comments (thanks for
  those!).

* Fixed a kbuilt robot-detected build failure: added a stub function for
  the !CONFIG_MMU case.

* Cover letter: now refers to "unpin_user_page()", reflecting the name
  change in the last patch (instead of put_user_page() ).

* Rebased onto today's linux-next: c165016bac27 ("Add linux-next
  specific files for 20191125")

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Here is a set of well-reviewed (expect for one patch), lower-risk  items
that can go into Linux 5.5. (Update: the powerpc conversion patch has
had some initial review now, since v1 was posted.)

This is essentially a cut-down v8 of "mm/gup: track dma-pinned pages:
FOLL_PIN" [1], and with one of the VFIO patches split into two patches.
The idea here is to get this long list of "noise" checked into 5.5, so
that the actual, higher-risk "track FOLL_PIN pages" (which is deferred:
not part of this series) will be a much shorter patchset to review.

For the v4l2-core changes, I've left those here (instead of sending
them separately to the -media tree), in order to get the name change
done now (put_user_page --> unpin_user_page). However, I've added a Cc
stable, as recommended during the last round of reviews.

Here are the relevant notes from the original cover letter, edited to
match the current situation:

This is a prerequisite to tracking dma-pinned pages. That in turn is a
prerequisite to solving the larger problem of proper interactions
between file-backed pages, and [R]DMA activities, as discussed in [1],
[2], [3], and in a remarkable number of email threads since about
2017. :)

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
    unpin_user_page()

Because there are interdependencies with FOLL_LONGTERM, a similar
conversion as for FOLL_PIN, was applied. The change was from this:

    get_user_pages(FOLL_LONGTERM) (also sets FOLL_GET)
    put_page()

to this:
    pin_longterm_pages() (sets FOLL_PIN | FOLL_LONGTERM)
    unpin_user_page()

[1] https://lore.kernel.org/r/20191121071354.456618-1-jhubbard@nvidia.com

thanks,
John Hubbard
NVIDIA


Dan Williams (1):
  mm: Cleanup __put_devmap_managed_page() vs ->page_free()

John Hubbard (18):
  mm/gup: factor out duplicate code from four routines
  mm/gup: move try_get_compound_head() to top, fix minor issues
  goldish_pipe: rename local pin_user_pages() routine
  mm: fix get_user_pages_remote()'s handling of FOLL_LONGTERM
  vfio: fix FOLL_LONGTERM use, simplify get_user_pages_remote() call
  mm/gup: introduce pin_user_pages*() and FOLL_PIN
  goldish_pipe: convert to pin_user_pages() and put_user_page()
  IB/{core,hw,umem}: set FOLL_PIN via pin_user_pages*(), fix up ODP
  mm/process_vm_access: set FOLL_PIN via pin_user_pages_remote()
  drm/via: set FOLL_PIN via pin_user_pages_fast()
  fs/io_uring: set FOLL_PIN via pin_user_pages()
  net/xdp: set FOLL_PIN via pin_user_pages()
  media/v4l2-core: set pages dirty upon releasing DMA buffers
  media/v4l2-core: pin_user_pages (FOLL_PIN) and put_user_page()
    conversion
  vfio, mm: pin_user_pages (FOLL_PIN) and put_user_page() conversion
  powerpc: book3s64: convert to pin_user_pages() and put_user_page()
  mm/gup_benchmark: use proper FOLL_WRITE flags instead of hard-coding
    "1"
  mm, tree-wide: rename put_user_page*() to unpin_user_page*()

 Documentation/core-api/index.rst            |   1 +
 Documentation/core-api/pin_user_pages.rst   | 233 ++++++++++++++
 arch/powerpc/mm/book3s64/iommu_api.c        |  12 +-
 drivers/gpu/drm/via/via_dmablit.c           |   6 +-
 drivers/infiniband/core/umem.c              |   4 +-
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
 include/linux/mm.h                          |  77 +++--
 mm/gup.c                                    | 340 +++++++++++++-------
 mm/gup_benchmark.c                          |   9 +-
 mm/memremap.c                               |  80 ++---
 mm/process_vm_access.c                      |  28 +-
 net/xdp/xdp_umem.c                          |   4 +-
 tools/testing/selftests/vm/gup_benchmark.c  |   6 +-
 24 files changed, 650 insertions(+), 285 deletions(-)
 create mode 100644 Documentation/core-api/pin_user_pages.rst

--=20
2.24.0

