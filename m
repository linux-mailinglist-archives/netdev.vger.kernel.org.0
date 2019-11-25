Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3531108738
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 05:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbfKYEVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 23:21:03 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9272 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727354AbfKYEUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 23:20:25 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ddb567c0001>; Sun, 24 Nov 2019 20:20:12 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Sun, 24 Nov 2019 20:20:18 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Sun, 24 Nov 2019 20:20:18 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Nov
 2019 04:20:17 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Nov
 2019 04:20:13 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 25 Nov 2019 04:20:13 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5ddb567d0006>; Sun, 24 Nov 2019 20:20:13 -0800
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
        John Hubbard <jhubbard@nvidia.com>,
        "Jason Gunthorpe" <jgg@mellanox.com>
Subject: [PATCH 05/19] mm: fix get_user_pages_remote()'s handling of FOLL_LONGTERM
Date:   Sun, 24 Nov 2019 20:19:57 -0800
Message-ID: <20191125042011.3002372-6-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191125042011.3002372-1-jhubbard@nvidia.com>
References: <20191125042011.3002372-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574655612; bh=l4ZzqtVW71Fwvoz1qyCbd1xWWEz8EY4C2cUJdAbaFHs=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=PuFsLnuGu1KfB/ZC9izxEq0bMZSKw8FTNCw9beyt6bkUSDvoRbbiuS99SR7As24lu
         RGbHmieWvPTXU5e+mq74L8miXctdPbS0ioC326V6mLcvZoRfydtyo4rIwM2R6Jm6Y6
         23VRYgCcNYQIW4DAuRBJaAfOxnfr8ibm/Si4ea/2FO0GHPZEt26wKzvbdKSJFb3SoI
         OQDgSp3ubf0/3+PrrJl2Ax3wUIMAX6Tzpjfxed19Rt0JuaQHyvhUbCzkCSmjSgb7lq
         2blCTd3N7xpKdUogXl+J6b4iDitiVq0ZaMwEly1saing+z2ZeMaF4JaRAtrZQeE9F4
         nJz2PdoULdpQA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As it says in the updated comment in gup.c: current FOLL_LONGTERM
behavior is incompatible with FAULT_FLAG_ALLOW_RETRY because of the
FS DAX check requirement on vmas.

However, the corresponding restriction in get_user_pages_remote() was
slightly stricter than is actually required: it forbade all
FOLL_LONGTERM callers, but we can actually allow FOLL_LONGTERM callers
that do not set the "locked" arg.

Update the code and comments to loosen the restriction, allowing
FOLL_LONGTERM in some cases.

Also, copy the DAX check ("if a VMA is DAX, don't allow long term
pinning") from the VFIO call site, all the way into the internals
of get_user_pages_remote() and __gup_longterm_locked(). That is:
get_user_pages_remote() calls __gup_longterm_locked(), which in turn
calls check_dax_vmas(). This check will then be removed from the VFIO
call site in a subsequent patch.

Thanks to Jason Gunthorpe for pointing out a clean way to fix this,
and to Dan Williams for helping clarify the DAX refactoring.

Tested-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: Alex Williamson <alex.williamson@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 mm/gup.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 3ecce297a47f..c0c56888e7cc 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -29,6 +29,13 @@ struct follow_page_context {
 	unsigned int page_mask;
 };
=20
+static __always_inline long __gup_longterm_locked(struct task_struct *tsk,
+						  struct mm_struct *mm,
+						  unsigned long start,
+						  unsigned long nr_pages,
+						  struct page **pages,
+						  struct vm_area_struct **vmas,
+						  unsigned int flags);
 /*
  * Return the compound head page with ref appropriately incremented,
  * or NULL if that failed.
@@ -1179,13 +1186,23 @@ long get_user_pages_remote(struct task_struct *tsk,=
 struct mm_struct *mm,
 		struct vm_area_struct **vmas, int *locked)
 {
 	/*
-	 * FIXME: Current FOLL_LONGTERM behavior is incompatible with
+	 * Parts of FOLL_LONGTERM behavior are incompatible with
 	 * FAULT_FLAG_ALLOW_RETRY because of the FS DAX check requirement on
-	 * vmas.  As there are no users of this flag in this call we simply
-	 * disallow this option for now.
+	 * vmas. However, this only comes up if locked is set, and there are
+	 * callers that do request FOLL_LONGTERM, but do not set locked. So,
+	 * allow what we can.
 	 */
-	if (WARN_ON_ONCE(gup_flags & FOLL_LONGTERM))
-		return -EINVAL;
+	if (gup_flags & FOLL_LONGTERM) {
+		if (WARN_ON_ONCE(locked))
+			return -EINVAL;
+		/*
+		 * This will check the vmas (even if our vmas arg is NULL)
+		 * and return -ENOTSUPP if DAX isn't allowed in this case:
+		 */
+		return __gup_longterm_locked(tsk, mm, start, nr_pages, pages,
+					     vmas, gup_flags | FOLL_TOUCH |
+					     FOLL_REMOTE);
+	}
=20
 	return __get_user_pages_locked(tsk, mm, start, nr_pages, pages, vmas,
 				       locked,
--=20
2.24.0

