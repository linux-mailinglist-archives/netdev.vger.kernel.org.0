Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0490FA8E1
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 05:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbfKME1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 23:27:17 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13623 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbfKME1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 23:27:15 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcb86200000>; Tue, 12 Nov 2019 20:27:12 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 12 Nov 2019 20:27:12 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 12 Nov 2019 20:27:12 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 Nov
 2019 04:27:12 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 13 Nov 2019 04:27:12 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5dcb86200000>; Tue, 12 Nov 2019 20:27:12 -0800
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
Subject: [PATCH v4 04/23] mm: devmap: refactor 1-based refcounting for ZONE_DEVICE pages
Date:   Tue, 12 Nov 2019 20:26:51 -0800
Message-ID: <20191113042710.3997854-5-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191113042710.3997854-1-jhubbard@nvidia.com>
References: <20191113042710.3997854-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573619232; bh=eh5PKTqFnv3H2C1oWk46Hm4jlzYBaiSiPR2xbAo8/Xk=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding;
        b=pj6M3Paz4Jb8s/zkr4xbcn7V9rw85SFVXQf2t/30nSh5HeFhZtiu6L2TDkY9LXdBk
         qmFAmsMXW8K9aqONmx5rzpgcKrp7KyoDoxEcKWWeF72f2hFzO1rgnvWA62qGpVpJpw
         Fji+h0aQkFAXAMnKj3pPlPYU48JG4GZyXfD/6m7PagtSohgBgvIQp6tKddm+C3WJk9
         XcFpVY0yWtBnkeMgSj0/b7hydd7pek7qPo7vhnlFkZz0SUdf+MdspBaUtaMwS2wKLd
         hFWYy6ySeXIEnL5hOSCfBW1tz3UyYdy4KyiOziT+U/tvErynTern5gpDgfTipG7fZf
         A69nwyNvr8ktQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An upcoming patch changes and complicates the refcounting and
especially the "put page" aspects of it. In order to keep
everything clean, refactor the devmap page release routines:

* Rename put_devmap_managed_page() to page_is_devmap_managed(),
  and limit the functionality to "read only": return a bool,
  with no side effects.

* Add a new routine, put_devmap_managed_page(), to handle checking
  what kind of page it is, and what kind of refcount handling it
  requires.

* Rename __put_devmap_managed_page() to free_devmap_managed_page(),
  and limit the functionality to unconditionally freeing a devmap
  page.

This is originally based on a separate patch by Ira Weiny, which
applied to an early version of the put_user_page() experiments.
Since then, J=C3=A9r=C3=B4me Glisse suggested the refactoring described abo=
ve.

Suggested-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 include/linux/mm.h | 27 ++++++++++++++++---
 mm/memremap.c      | 67 ++++++++++++++++++++--------------------------
 2 files changed, 53 insertions(+), 41 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index a2adf95b3f9c..96228376139c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -967,9 +967,10 @@ static inline bool is_zone_device_page(const struct pa=
ge *page)
 #endif
=20
 #ifdef CONFIG_DEV_PAGEMAP_OPS
-void __put_devmap_managed_page(struct page *page);
+void free_devmap_managed_page(struct page *page);
 DECLARE_STATIC_KEY_FALSE(devmap_managed_key);
-static inline bool put_devmap_managed_page(struct page *page)
+
+static inline bool page_is_devmap_managed(struct page *page)
 {
 	if (!static_branch_unlikely(&devmap_managed_key))
 		return false;
@@ -978,7 +979,6 @@ static inline bool put_devmap_managed_page(struct page =
*page)
 	switch (page->pgmap->type) {
 	case MEMORY_DEVICE_PRIVATE:
 	case MEMORY_DEVICE_FS_DAX:
-		__put_devmap_managed_page(page);
 		return true;
 	default:
 		break;
@@ -986,6 +986,27 @@ static inline bool put_devmap_managed_page(struct page=
 *page)
 	return false;
 }
=20
+static inline bool put_devmap_managed_page(struct page *page)
+{
+	bool is_devmap =3D page_is_devmap_managed(page);
+
+	if (is_devmap) {
+		int count =3D page_ref_dec_return(page);
+
+		/*
+		 * devmap page refcounts are 1-based, rather than 0-based: if
+		 * refcount is 1, then the page is free and the refcount is
+		 * stable because nobody holds a reference on the page.
+		 */
+		if (count =3D=3D 1)
+			free_devmap_managed_page(page);
+		else if (!count)
+			__put_page(page);
+	}
+
+	return is_devmap;
+}
+
 #else /* CONFIG_DEV_PAGEMAP_OPS */
 static inline bool put_devmap_managed_page(struct page *page)
 {
diff --git a/mm/memremap.c b/mm/memremap.c
index 03ccbdfeb697..bc7e2a27d025 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -410,48 +410,39 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn=
,
 EXPORT_SYMBOL_GPL(get_dev_pagemap);
=20
 #ifdef CONFIG_DEV_PAGEMAP_OPS
-void __put_devmap_managed_page(struct page *page)
+void free_devmap_managed_page(struct page *page)
 {
-	int count =3D page_ref_dec_return(page);
+	/* Clear Active bit in case of parallel mark_page_accessed */
+	__ClearPageActive(page);
+	__ClearPageWaiters(page);
+
+	mem_cgroup_uncharge(page);
=20
 	/*
-	 * If refcount is 1 then page is freed and refcount is stable as nobody
-	 * holds a reference on the page.
+	 * When a device_private page is freed, the page->mapping field
+	 * may still contain a (stale) mapping value. For example, the
+	 * lower bits of page->mapping may still identify the page as
+	 * an anonymous page. Ultimately, this entire field is just
+	 * stale and wrong, and it will cause errors if not cleared.
+	 * One example is:
+	 *
+	 *  migrate_vma_pages()
+	 *    migrate_vma_insert_page()
+	 *      page_add_new_anon_rmap()
+	 *        __page_set_anon_rmap()
+	 *          ...checks page->mapping, via PageAnon(page) call,
+	 *            and incorrectly concludes that the page is an
+	 *            anonymous page. Therefore, it incorrectly,
+	 *            silently fails to set up the new anon rmap.
+	 *
+	 * For other types of ZONE_DEVICE pages, migration is either
+	 * handled differently or not done at all, so there is no need
+	 * to clear page->mapping.
 	 */
-	if (count =3D=3D 1) {
-		/* Clear Active bit in case of parallel mark_page_accessed */
-		__ClearPageActive(page);
-		__ClearPageWaiters(page);
-
-		mem_cgroup_uncharge(page);
-
-		/*
-		 * When a device_private page is freed, the page->mapping field
-		 * may still contain a (stale) mapping value. For example, the
-		 * lower bits of page->mapping may still identify the page as
-		 * an anonymous page. Ultimately, this entire field is just
-		 * stale and wrong, and it will cause errors if not cleared.
-		 * One example is:
-		 *
-		 *  migrate_vma_pages()
-		 *    migrate_vma_insert_page()
-		 *      page_add_new_anon_rmap()
-		 *        __page_set_anon_rmap()
-		 *          ...checks page->mapping, via PageAnon(page) call,
-		 *            and incorrectly concludes that the page is an
-		 *            anonymous page. Therefore, it incorrectly,
-		 *            silently fails to set up the new anon rmap.
-		 *
-		 * For other types of ZONE_DEVICE pages, migration is either
-		 * handled differently or not done at all, so there is no need
-		 * to clear page->mapping.
-		 */
-		if (is_device_private_page(page))
-			page->mapping =3D NULL;
+	if (is_device_private_page(page))
+		page->mapping =3D NULL;
=20
-		page->pgmap->ops->page_free(page);
-	} else if (!count)
-		__put_page(page);
+	page->pgmap->ops->page_free(page);
 }
-EXPORT_SYMBOL(__put_devmap_managed_page);
+EXPORT_SYMBOL(free_devmap_managed_page);
 #endif /* CONFIG_DEV_PAGEMAP_OPS */
--=20
2.24.0

