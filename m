Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA9E7FD56B
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 06:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727907AbfKOF4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 00:56:53 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5062 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbfKOFx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 00:53:56 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dce3d6b0005>; Thu, 14 Nov 2019 21:53:48 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 14 Nov 2019 21:53:45 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 14 Nov 2019 21:53:45 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 15 Nov
 2019 05:53:43 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 15 Nov 2019 05:53:43 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5dce3d670006>; Thu, 14 Nov 2019 21:53:43 -0800
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
Subject: [PATCH v5 04/24] mm: Cleanup __put_devmap_managed_page() vs ->page_free()
Date:   Thu, 14 Nov 2019 21:53:20 -0800
Message-ID: <20191115055340.1825745-5-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115055340.1825745-1-jhubbard@nvidia.com>
References: <20191115055340.1825745-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573797228; bh=AC3B+bSuSOhCIQMFfknGmFthqUy5L4DGDhYzXP1+5TU=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding;
        b=PnkyV7KPHnjlGKmKWZlCFBIb1BJayyY14T5CX6AKWcue93fl6RXlYobT5kG6PNAoZ
         xX/dHoqtl6AT1snPw8oFVYduWl58LLXqEj4vuL65LqWkmqD8Q0z4MMvp+Wg3QjoKN3
         /MVxiftg36Hh6jtV7H4mo+uF+79+TDwbhzW9bJKIgEKjWa1wid9lG1a1ddB/sBFDoM
         plpy/aI2XXxXb9oyFNBaHloX/lHtB5rHjIHVCRSEhHofMEO3fJl5OBK1ASoRtUgUp2
         YYyzrDQz46r7g/KOd1DXEZsHmuu177IG6ZXGrhxxUJoZIZx/TcDZf1kWXK5mOprcJw
         TIdm9+ED5DSzQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

After the removal of the device-public infrastructure there are only 2
->page_free() call backs in the kernel. One of those is a device-private
callback in the nouveau driver, the other is a generic wakeup needed in
the DAX case. In the hopes that all ->page_free() callbacks can be
migrated to common core kernel functionality, move the device-private
specific actions in __put_devmap_managed_page() under the
is_device_private_page() conditional, including the ->page_free()
callback. For the other page types just open-code the generic wakeup.

Yes, the wakeup is only needed in the MEMORY_DEVICE_FSDAX case, but it
does no harm in the MEMORY_DEVICE_DEVDAX and MEMORY_DEVICE_PCI_P2PDMA
case.

Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/nvdimm/pmem.c |  6 ----
 mm/memremap.c         | 80 ++++++++++++++++++++++++-------------------
 2 files changed, 44 insertions(+), 42 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index f9f76f6ba07b..21db1ce8c0ae 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -338,13 +338,7 @@ static void pmem_release_disk(void *__pmem)
 	put_disk(pmem->disk);
 }
=20
-static void pmem_pagemap_page_free(struct page *page)
-{
-	wake_up_var(&page->_refcount);
-}
-
 static const struct dev_pagemap_ops fsdax_pagemap_ops =3D {
-	.page_free		=3D pmem_pagemap_page_free,
 	.kill			=3D pmem_pagemap_kill,
 	.cleanup		=3D pmem_pagemap_cleanup,
 };
diff --git a/mm/memremap.c b/mm/memremap.c
index 03ccbdfeb697..e899fa876a62 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -27,7 +27,8 @@ static void devmap_managed_enable_put(void)
=20
 static int devmap_managed_enable_get(struct dev_pagemap *pgmap)
 {
-	if (!pgmap->ops || !pgmap->ops->page_free) {
+	if (pgmap->type =3D=3D MEMORY_DEVICE_PRIVATE &&
+	    (!pgmap->ops || !pgmap->ops->page_free)) {
 		WARN(1, "Missing page_free method\n");
 		return -EINVAL;
 	}
@@ -414,44 +415,51 @@ void __put_devmap_managed_page(struct page *page)
 {
 	int count =3D page_ref_dec_return(page);
=20
-	/*
-	 * If refcount is 1 then page is freed and refcount is stable as nobody
-	 * holds a reference on the page.
-	 */
-	if (count =3D=3D 1) {
-		/* Clear Active bit in case of parallel mark_page_accessed */
-		__ClearPageActive(page);
-		__ClearPageWaiters(page);
+	/* still busy */
+	if (count > 1)
+		return;
=20
-		mem_cgroup_uncharge(page);
+	/* only triggered by the dev_pagemap shutdown path */
+	if (count =3D=3D 0) {
+		__put_page(page);
+		return;
+	}
=20
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
+	/* notify page idle for dax */
+	if (!is_device_private_page(page)) {
+		wake_up_var(&page->_refcount);
+		return;
+	}
=20
-		page->pgmap->ops->page_free(page);
-	} else if (!count)
-		__put_page(page);
+	/* Clear Active bit in case of parallel mark_page_accessed */
+	__ClearPageActive(page);
+	__ClearPageWaiters(page);
+
+	mem_cgroup_uncharge(page);
+
+	/*
+	 * When a device_private page is freed, the page->mapping field
+	 * may still contain a (stale) mapping value. For example, the
+	 * lower bits of page->mapping may still identify the page as an
+	 * anonymous page. Ultimately, this entire field is just stale
+	 * and wrong, and it will cause errors if not cleared.  One
+	 * example is:
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
+	 */
+	page->mapping =3D NULL;
+	page->pgmap->ops->page_free(page);
 }
 EXPORT_SYMBOL(__put_devmap_managed_page);
 #endif /* CONFIG_DEV_PAGEMAP_OPS */
--=20
2.24.0

