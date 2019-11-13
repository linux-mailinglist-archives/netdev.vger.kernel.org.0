Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D287FA830
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 05:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbfKME1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 23:27:25 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13731 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbfKME1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 23:27:20 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcb86210000>; Tue, 12 Nov 2019 20:27:13 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 12 Nov 2019 20:27:13 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 12 Nov 2019 20:27:13 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 Nov
 2019 04:27:13 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 13 Nov 2019 04:27:13 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5dcb86200008>; Tue, 12 Nov 2019 20:27:12 -0800
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
Subject: [PATCH v4 12/23] mm/process_vm_access: set FOLL_PIN via pin_user_pages_remote()
Date:   Tue, 12 Nov 2019 20:26:59 -0800
Message-ID: <20191113042710.3997854-13-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191113042710.3997854-1-jhubbard@nvidia.com>
References: <20191113042710.3997854-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573619233; bh=3Py2O4K3WxT2/yPBKlFkEQrJEl3zr7dYM5uV5CiR5XQ=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding;
        b=BLOodrtSGggVw0pQ/YHp8xJEbGAPfFn8EAlZOEw59+YLHCYLyoJc0Z1emaZUx1ywP
         GZ/nsSho2/iDC4TP+q/IXPOFgCK2BKr/S4vTlUaywQ7wfotqpfwPnkNHFCRewCQOBC
         q+xcDpCXns+CgMQeVAhJTU0klTgx8SGt0hlCf1mz27rjb87XXrgyUwvdrBLAlNMB1/
         iJn+YU+aPd1TB9jhc7gbgu6WAG4avjNXNhs5n5COuB0agbHR1tD7AGyhVpJnI1CO+2
         qyq7jiWJ5vbYEI5rWTMAIlW1rfKPK2xUWZ9NYhci1RlwYexSm5EQ0t3keg8JHHVjZr
         5Qr/nBntljK/w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert process_vm_access to use the new pin_user_pages_remote()
call, which sets FOLL_PIN. Setting FOLL_PIN is now required for
code that requires tracking of pinned pages.

Also, release the pages via put_user_page*().

Also, rename "pages" to "pinned_pages", as this makes for
easier reading of process_vm_rw_single_vec().

Reviewed-by: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 mm/process_vm_access.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index 357aa7bef6c0..fd20ab675b85 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -42,12 +42,11 @@ static int process_vm_rw_pages(struct page **pages,
 		if (copy > len)
 			copy =3D len;
=20
-		if (vm_write) {
+		if (vm_write)
 			copied =3D copy_page_from_iter(page, offset, copy, iter);
-			set_page_dirty_lock(page);
-		} else {
+		else
 			copied =3D copy_page_to_iter(page, offset, copy, iter);
-		}
+
 		len -=3D copied;
 		if (copied < copy && iov_iter_count(iter))
 			return -EFAULT;
@@ -96,7 +95,7 @@ static int process_vm_rw_single_vec(unsigned long addr,
 		flags |=3D FOLL_WRITE;
=20
 	while (!rc && nr_pages && iov_iter_count(iter)) {
-		int pages =3D min(nr_pages, max_pages_per_loop);
+		int pinned_pages =3D min(nr_pages, max_pages_per_loop);
 		int locked =3D 1;
 		size_t bytes;
=20
@@ -106,14 +105,15 @@ static int process_vm_rw_single_vec(unsigned long add=
r,
 		 * current/current->mm
 		 */
 		down_read(&mm->mmap_sem);
-		pages =3D get_user_pages_remote(task, mm, pa, pages, flags,
-					      process_pages, NULL, &locked);
+		pinned_pages =3D pin_user_pages_remote(task, mm, pa, pinned_pages,
+						     flags, process_pages,
+						     NULL, &locked);
 		if (locked)
 			up_read(&mm->mmap_sem);
-		if (pages <=3D 0)
+		if (pinned_pages <=3D 0)
 			return -EFAULT;
=20
-		bytes =3D pages * PAGE_SIZE - start_offset;
+		bytes =3D pinned_pages * PAGE_SIZE - start_offset;
 		if (bytes > len)
 			bytes =3D len;
=20
@@ -122,10 +122,12 @@ static int process_vm_rw_single_vec(unsigned long add=
r,
 					 vm_write);
 		len -=3D bytes;
 		start_offset =3D 0;
-		nr_pages -=3D pages;
-		pa +=3D pages * PAGE_SIZE;
-		while (pages)
-			put_page(process_pages[--pages]);
+		nr_pages -=3D pinned_pages;
+		pa +=3D pinned_pages * PAGE_SIZE;
+
+		/* If vm_write is set, the pages need to be made dirty: */
+		put_user_pages_dirty_lock(process_pages, pinned_pages,
+					  vm_write);
 	}
=20
 	return rc;
--=20
2.24.0

