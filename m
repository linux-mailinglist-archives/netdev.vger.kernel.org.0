Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34AB313369F
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 23:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgAGWsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 17:48:30 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11356 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727516AbgAGWqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 17:46:05 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e1509f80000>; Tue, 07 Jan 2020 14:45:12 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 07 Jan 2020 14:46:00 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 07 Jan 2020 14:46:00 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 7 Jan
 2020 22:46:00 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 7 Jan 2020 22:45:59 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5e150a270007>; Tue, 07 Jan 2020 14:45:59 -0800
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
        "Kirill A . Shutemov" <kirill@shutemov.name>,
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
        John Hubbard <jhubbard@nvidia.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v12 02/22] mm/gup: move try_get_compound_head() to top, fix minor issues
Date:   Tue, 7 Jan 2020 14:45:38 -0800
Message-ID: <20200107224558.2362728-3-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107224558.2362728-1-jhubbard@nvidia.com>
References: <20200107224558.2362728-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1578437112; bh=uSjV+mwkCOfibPnWZ3pQitrla4sOmdd6PeFdhIMcY2M=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=B8hjeLMa/fiWv8EG9EqwPRV6thWAJ9N8XplrMGpqx+1LvpZ57elO+hDrHykIvnghb
         6LzJjmusFmlRJwLEmEyrmwMuIOVj7SxOEtx/xEQSW7olnU0+yYRGKtroR8TIgMiLP3
         ytPPrUV6AnPUjvSC7aJ8Ho5QYD2Qqs1FMRC8xgPftDgyeOGX9Ni+1Gkosk6uXtXR5u
         B2F1wIpt5xW9hv/xP0w/Xl6KPQhnyixA6f9c8CFrfKm2br76YVRUwGbmLyJJavd8ZD
         X4nJdQtd40M3daeU1oN+rtWwLreH8JQw39L95QZqdEACrE4EmszB7oxtelG7ZrQ+e1
         MOCTmH+dswWug==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An upcoming patch uses try_get_compound_head() more widely,
so move it to the top of gup.c.

Also fix a tiny spelling error and a checkpatch.pl warning.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 mm/gup.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index d56c6d6b85d3..5938e29a5a8b 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -29,6 +29,21 @@ struct follow_page_context {
 	unsigned int page_mask;
 };
=20
+/*
+ * Return the compound head page with ref appropriately incremented,
+ * or NULL if that failed.
+ */
+static inline struct page *try_get_compound_head(struct page *page, int re=
fs)
+{
+	struct page *head =3D compound_head(page);
+
+	if (WARN_ON_ONCE(page_ref_count(head) < 0))
+		return NULL;
+	if (unlikely(!page_cache_add_speculative(head, refs)))
+		return NULL;
+	return head;
+}
+
 /**
  * put_user_pages_dirty_lock() - release and optionally dirty gup-pinned p=
ages
  * @pages:  array of pages to be maybe marked dirty, and definitely releas=
ed.
@@ -1807,20 +1822,6 @@ static void __maybe_unused undo_dev_pagemap(int *nr,=
 int nr_start,
 	}
 }
=20
-/*
- * Return the compund head page with ref appropriately incremented,
- * or NULL if that failed.
- */
-static inline struct page *try_get_compound_head(struct page *page, int re=
fs)
-{
-	struct page *head =3D compound_head(page);
-	if (WARN_ON_ONCE(page_ref_count(head) < 0))
-		return NULL;
-	if (unlikely(!page_cache_add_speculative(head, refs)))
-		return NULL;
-	return head;
-}
-
 #ifdef CONFIG_ARCH_HAS_PTE_SPECIAL
 static int gup_pte_range(pmd_t pmd, unsigned long addr, unsigned long end,
 			 unsigned int flags, struct page **pages, int *nr)
--=20
2.24.1

