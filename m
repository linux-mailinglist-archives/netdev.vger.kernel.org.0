Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8EAF11C70F
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 09:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbfLLITa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 03:19:30 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:3854 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728361AbfLLIT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 03:19:26 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5df1f8030001>; Thu, 12 Dec 2019 00:19:15 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 12 Dec 2019 00:19:22 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 12 Dec 2019 00:19:22 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 12 Dec
 2019 08:19:20 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Thu, 12 Dec 2019 08:19:20 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5df1f8080000>; Thu, 12 Dec 2019 00:19:20 -0800
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
Subject: [PATCH v10 15/25] fs/io_uring: set FOLL_PIN via pin_user_pages()
Date:   Thu, 12 Dec 2019 00:19:07 -0800
Message-ID: <20191212081917.1264184-16-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191212081917.1264184-1-jhubbard@nvidia.com>
References: <20191212081917.1264184-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576138755; bh=XZAOBQ7h8B5KuSGqfEguVKa+axV7H4s2lXE+fnR+eEc=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=VCOadXbXPOL/PL0/kI4+HCQOJQmgT2/FTcU9G7VtsbCb38tBkQUrF3XOzMezitc5j
         2vA3tk/yLUt3EevxJLzt/XZI7TfvDsc2Hpsk84Mfvu7+naghg3agU/bjvUtshBzl3I
         vHvxzq7ektJ+Ku0h8OLZvnObzHkWuZSvPS1ffrOyaEjeykr5flI9hiexNSZRY8QiCK
         xNlcNTfww7uvEljwQGSOX3N1f7iALhqrz9G3WrTbwXu12OnB0E4s8+qanKrXZHAPuF
         d2C6pqg4ZNM/zGMeDDXsQOQ2u2L1f8fC2kta8A5uizU27vZNgBolA3W/QAjYfETd9s
         DhJc2qWS/vdqg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert fs/io_uring to use the new pin_user_pages() call, which sets
FOLL_PIN. Setting FOLL_PIN is now required for code that requires
tracking of pinned pages, and therefore for any code that calls
put_user_page().

In partial anticipation of this work, the io_uring code was already
calling put_user_page() instead of put_page(). Therefore, in order to
convert from the get_user_pages()/put_page() model, to the
pin_user_pages()/put_user_page() model, the only change required
here is to change get_user_pages() to pin_user_pages().

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 405be10da73d..9639ebc21e8a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4521,7 +4521,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx =
*ctx, void __user *arg,
=20
 		ret =3D 0;
 		down_read(&current->mm->mmap_sem);
-		pret =3D get_user_pages(ubuf, nr_pages,
+		pret =3D pin_user_pages(ubuf, nr_pages,
 				      FOLL_WRITE | FOLL_LONGTERM,
 				      pages, vmas);
 		if (pret =3D=3D nr_pages) {
--=20
2.24.0

