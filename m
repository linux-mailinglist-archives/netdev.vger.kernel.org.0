Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B581E8C3F
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 01:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbgE2XnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 19:43:15 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4272 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728396AbgE2XnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 19:43:12 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ed19db30001>; Fri, 29 May 2020 16:41:39 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 29 May 2020 16:43:11 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 29 May 2020 16:43:11 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 29 May
 2020 23:43:11 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 29 May 2020 23:43:11 +0000
Received: from sandstorm.nvidia.com (Not Verified[10.2.87.173]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5ed19e0f0002>; Fri, 29 May 2020 16:43:11 -0700
From:   John Hubbard <jhubbard@nvidia.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, <linux-doc@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH 2/2] vhost: convert get_user_pages() --> pin_user_pages()
Date:   Fri, 29 May 2020 16:43:09 -0700
Message-ID: <20200529234309.484480-3-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529234309.484480-1-jhubbard@nvidia.com>
References: <20200529234309.484480-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590795699; bh=w393fB7aMdfV2Mn/9DhXAANTn2k/9wVRvrXDZ4wAcPA=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=AIidyHaKCFf7Kb9AMouG61nHIQlapNE9AiLsib0QpCDzLvsTwwBRUeW/4GekCvb7F
         smypOSFVsFd+3nRh66RM2eztwXbwv34HZFIIxCxH6UUi9Vfk+SuxiFXQ65SN4/Oyec
         t0wmLYAFAUh8q/OQuepY8cNQQSVBaoRKNXM+2ZyKvm/br5zGAy7GAmhlyThqdzI8F4
         gGIm7rRrqWBXbXJDWLRUKD+2zTb2K76ePxs13DoVdpK+OGjEjrJpmQMXEgxYczFvxI
         h/SDh/NadxwC+Ci7m6OF9cb0f6gLx/1Rhdpx54yYTuyHd+F9BjdY3kDrKXOQg2JVnE
         /C86UeF1NcgJA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code was using get_user_pages*(), in approximately a "Case 5"
scenario (accessing the data within a page), using the categorization
from [1]. That means that it's time to convert the get_user_pages*() +
put_page() calls to pin_user_pages*() + unpin_user_pages() calls.

There is some helpful background in [2]: basically, this is a small
part of fixing a long-standing disconnect between pinning pages, and
file systems' use of those pages.

[1] Documentation/core-api/pin_user_pages.rst

[2] "Explicit pinning of user-space pages":
    https://lwn.net/Articles/807108/

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: kvm@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/vhost/vhost.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 21a59b598ed8..596132a96cd5 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1762,15 +1762,14 @@ static int set_bit_to_user(int nr, void __user *add=
r)
 	int bit =3D nr + (log % PAGE_SIZE) * 8;
 	int r;
=20
-	r =3D get_user_pages_fast(log, 1, FOLL_WRITE, &page);
+	r =3D pin_user_pages_fast(log, 1, FOLL_WRITE, &page);
 	if (r < 0)
 		return r;
 	BUG_ON(r !=3D 1);
 	base =3D kmap_atomic(page);
 	set_bit(bit, base);
 	kunmap_atomic(base);
-	set_page_dirty_lock(page);
-	put_page(page);
+	unpin_user_pages_dirty_lock(&page, 1, true);
 	return 0;
 }
=20
--=20
2.26.2

