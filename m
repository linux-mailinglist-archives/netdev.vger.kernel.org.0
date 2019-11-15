Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9A3FD518
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 06:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbfKOFzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 00:55:52 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5130 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727419AbfKOFyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 00:54:00 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dce3d6c0005>; Thu, 14 Nov 2019 21:53:49 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 14 Nov 2019 21:53:46 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 14 Nov 2019 21:53:46 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 15 Nov
 2019 05:53:44 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 15 Nov 2019 05:53:44 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5dce3d680003>; Thu, 14 Nov 2019 21:53:44 -0800
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
Subject: [PATCH v5 11/24] goldish_pipe: convert to pin_user_pages() and put_user_page()
Date:   Thu, 14 Nov 2019 21:53:27 -0800
Message-ID: <20191115055340.1825745-12-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115055340.1825745-1-jhubbard@nvidia.com>
References: <20191115055340.1825745-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573797229; bh=1bdN1LXqKv0ya/hHPLN7inRIruwmJpRdnobIHlrvKRo=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=FVo2yC8BV7ci1TanOWumK+Du2UthJ2Meaou+Hdu3qkoIK+6mysJvhCiPHfyJmIY3G
         IgTVPuwW2pA26coS8p5c0r9gIAON02XNFS8gL114pzcHBMSj4AtCpt/4wF6kxpi+o5
         MXDEbYzKfguDq86n7LLt3NDuHdm25uGr5V9BP7hZBibzXAdLFoYNtxD9aTmnEnGVwc
         uO+99IGIDssxpqXe++GsvN+b5XdIdyiNoWBMxBH+0rWewxOnlrTULENM+aUb7arYzF
         NjpB/7DvcGSC2n7tHdabDQLGL8xSciEJmvX2q6tQdVgIPq4RY9AnC8dmisFj64OktL
         ZsLaUU+n7Dwhg==
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

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
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
2.24.0

