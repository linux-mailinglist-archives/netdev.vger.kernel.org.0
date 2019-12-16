Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57F0D121D19
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 23:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbfLPWZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 17:25:59 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:11980 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbfLPWZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 17:25:58 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5df8045b0002>; Mon, 16 Dec 2019 14:25:31 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 16 Dec 2019 14:25:40 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 16 Dec 2019 14:25:40 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 16 Dec
 2019 22:25:39 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 16 Dec 2019 22:25:39 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5df804630005>; Mon, 16 Dec 2019 14:25:39 -0800
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
        John Hubbard <jhubbard@nvidia.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v11 04/25] mm: devmap: refactor 1-based refcounting for ZONE_DEVICE pages
Date:   Mon, 16 Dec 2019 14:25:16 -0800
Message-ID: <20191216222537.491123-5-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216222537.491123-1-jhubbard@nvidia.com>
References: <20191216222537.491123-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576535131; bh=nSaKGePGStF9C3ZQr6nzxOSALkvlbj6EZdgW6MYIJiE=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding;
        b=eMTKxTCpkkek4H9i8wEGy/GiFSYBR+onVYB9kKAFeedEwaga8NiRqIBa+WPLvIOQl
         WHrhWL/0lC/NaMLi6+E7DcWTB86whWfdFAvDS7EYvtUFm3HrqGMsb8wWoMHnMbl+Vw
         QwjJVJE0wqcnDX6qfNJ89iokoUZ0MBDvHWkTK3aVMDFsO8i/tqcn4hrL/wBFiJ/mJ7
         PMnFtqYZ7mvFXmWTH+Dx9kZjdlbi1HYptQU3AmdKFvE7rBosNA0tP/b9AYA0aE+JEU
         S3/xSjZf+byRB6NHpQcvI2SP0rKxVKUosPe7sxh0BWv02epXDJ96T/NrbcuesfjxLa
         WozKtw0V/w01Q==
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

Cc: Christoph Hellwig <hch@lst.de>
Suggested-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 include/linux/mm.h | 17 +++++++++++++----
 mm/memremap.c      | 16 ++--------------
 mm/swap.c          | 24 ++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 18 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index c97ea3b694e6..77a4df06c8a7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -952,9 +952,10 @@ static inline bool is_zone_device_page(const struct pa=
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
@@ -963,7 +964,6 @@ static inline bool put_devmap_managed_page(struct page =
*page)
 	switch (page->pgmap->type) {
 	case MEMORY_DEVICE_PRIVATE:
 	case MEMORY_DEVICE_FS_DAX:
-		__put_devmap_managed_page(page);
 		return true;
 	default:
 		break;
@@ -971,7 +971,14 @@ static inline bool put_devmap_managed_page(struct page=
 *page)
 	return false;
 }
=20
+bool put_devmap_managed_page(struct page *page);
+
 #else /* CONFIG_DEV_PAGEMAP_OPS */
+static inline bool page_is_devmap_managed(struct page *page)
+{
+	return false;
+}
+
 static inline bool put_devmap_managed_page(struct page *page)
 {
 	return false;
@@ -1028,8 +1035,10 @@ static inline void put_page(struct page *page)
 	 * need to inform the device driver through callback. See
 	 * include/linux/memremap.h and HMM for details.
 	 */
-	if (put_devmap_managed_page(page))
+	if (page_is_devmap_managed(page)) {
+		put_devmap_managed_page(page);
 		return;
+	}
=20
 	if (put_page_testzero(page))
 		__put_page(page);
diff --git a/mm/memremap.c b/mm/memremap.c
index e899fa876a62..2ba773859031 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -411,20 +411,8 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn,
 EXPORT_SYMBOL_GPL(get_dev_pagemap);
=20
 #ifdef CONFIG_DEV_PAGEMAP_OPS
-void __put_devmap_managed_page(struct page *page)
+void free_devmap_managed_page(struct page *page)
 {
-	int count =3D page_ref_dec_return(page);
-
-	/* still busy */
-	if (count > 1)
-		return;
-
-	/* only triggered by the dev_pagemap shutdown path */
-	if (count =3D=3D 0) {
-		__put_page(page);
-		return;
-	}
-
 	/* notify page idle for dax */
 	if (!is_device_private_page(page)) {
 		wake_up_var(&page->_refcount);
@@ -461,5 +449,5 @@ void __put_devmap_managed_page(struct page *page)
 	page->mapping =3D NULL;
 	page->pgmap->ops->page_free(page);
 }
-EXPORT_SYMBOL(__put_devmap_managed_page);
+EXPORT_SYMBOL(free_devmap_managed_page);
 #endif /* CONFIG_DEV_PAGEMAP_OPS */
diff --git a/mm/swap.c b/mm/swap.c
index 5341ae93861f..49f7c2eea0ba 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -1102,3 +1102,27 @@ void __init swap_setup(void)
 	 * _really_ don't want to cluster much more
 	 */
 }
+
+#ifdef CONFIG_DEV_PAGEMAP_OPS
+bool put_devmap_managed_page(struct page *page)
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
+EXPORT_SYMBOL(put_devmap_managed_page);
+#endif
--=20
2.24.1

