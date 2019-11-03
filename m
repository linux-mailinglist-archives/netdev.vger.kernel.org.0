Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3AB5ED5BF
	for <lists+netdev@lfdr.de>; Sun,  3 Nov 2019 22:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbfKCVVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Nov 2019 16:21:13 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:6783 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728288AbfKCVSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Nov 2019 16:18:18 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dbf441e0001>; Sun, 03 Nov 2019 13:18:23 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Sun, 03 Nov 2019 13:18:16 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Sun, 03 Nov 2019 13:18:16 -0800
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 3 Nov
 2019 21:18:16 +0000
Received: from hqnvemgw01.nvidia.com (172.20.150.20) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Sun, 3 Nov 2019 21:18:16 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by hqnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5dbf44170003>; Sun, 03 Nov 2019 13:18:15 -0800
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
Subject: [PATCH v2 06/18] goldish_pipe: convert to pin_user_pages() and put_user_page()
Date:   Sun, 3 Nov 2019 13:18:01 -0800
Message-ID: <20191103211813.213227-7-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191103211813.213227-1-jhubbard@nvidia.com>
References: <20191103211813.213227-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572815903; bh=w1mGkll55W/F61ikcVy7cICFWorcB7JiCtRQJEe0514=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=dBt3EhGVVGWu/CtXZd9PhiIf59cy/AAxklpU3prp/1hv4VK4LUYB1jVlHnvQ722Me
         uv4czLu8g+hWeT6hyZUvE/uDvOLLclgnVoDrPamQfeqLqt8EharEV2tBAfpncaJRPC
         o249Qj+jUGTqA9nkw7OwXlkKA5gMi1wCwAopqmYTT5TA6T+FM03BH0ZBpToOCGf3Vs
         hCYsoNMWoloJHLXiDpVfqteNTAXegm6FmUM4NW3bNg59rAfx5XLfeov21b325VbvK2
         mTrpyZPfkV8bh2gKA+PgIespYs0TlYW2Sa4ZeLEj57VSRGhRW5LtZjjKQlFKACnAIu
         MufoE4Mvfn3Yg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1. Call the new global pin_user_pages_fast(), from pin_goldfish_pages().

2. As required by pin_user_pages(), release these pages via
put_user_page(). In this case, do so via put_user_pages_dirty_lock().

That has the side effect of calling set_page_dirty_lock(), instead
of set_page_dirty(). This is probably more accurate.

As Christoph Hellwig put it, "set_page_dirty() is only safe if we are
dealing with a file backed page where we have reference on the inode it
hangs off." [1]

Another side effect is that the release code is simplified because
the page[] loop is now in gup.c instead of here, so just delete the
local release_user_pages() entirely, and call
put_user_pages_dirty_lock() directly, instead.

[1] https://lore.kernel.org/r/20190723153640.GB720@lst.de

Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/platform/goldfish/goldfish_pipe.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/platform/goldfish/goldfish_pipe.c b/drivers/platform/g=
oldfish/goldfish_pipe.c
index 7ed2a21a0bac..635a8bc1b480 100644
--- a/drivers/platform/goldfish/goldfish_pipe.c
+++ b/drivers/platform/goldfish/goldfish_pipe.c
@@ -274,7 +274,7 @@ static int pin_goldfish_pages(unsigned long first_page,
 		*iter_last_page_size =3D last_page_size;
 	}
=20
-	ret =3D get_user_pages_fast(first_page, requested_pages,
+	ret =3D pin_user_pages_fast(first_page, requested_pages,
 				  !is_write ? FOLL_WRITE : 0,
 				  pages);
 	if (ret <=3D 0)
@@ -285,18 +285,6 @@ static int pin_goldfish_pages(unsigned long first_page=
,
 	return ret;
 }
=20
-static void release_user_pages(struct page **pages, int pages_count,
-			       int is_write, s32 consumed_size)
-{
-	int i;
-
-	for (i =3D 0; i < pages_count; i++) {
-		if (!is_write && consumed_size > 0)
-			set_page_dirty(pages[i]);
-		put_page(pages[i]);
-	}
-}
-
 /* Populate the call parameters, merging adjacent pages together */
 static void populate_rw_params(struct page **pages,
 			       int pages_count,
@@ -372,7 +360,8 @@ static int transfer_max_buffers(struct goldfish_pipe *p=
ipe,
=20
 	*consumed_size =3D pipe->command_buffer->rw_params.consumed_size;
=20
-	release_user_pages(pipe->pages, pages_count, is_write, *consumed_size);
+	put_user_pages_dirty_lock(pipe->pages, pages_count,
+				  !is_write && *consumed_size > 0);
=20
 	mutex_unlock(&pipe->lock);
 	return 0;
--=20
2.23.0

