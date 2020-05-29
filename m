Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D85B1E8C3A
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 01:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgE2XnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 19:43:14 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:4263 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727876AbgE2XnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 19:43:12 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ed19db30000>; Fri, 29 May 2020 16:41:39 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 29 May 2020 16:43:11 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 29 May 2020 16:43:11 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 29 May
 2020 23:43:11 +0000
Received: from hqnvemgw03.nvidia.com (10.124.88.68) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Fri, 29 May 2020 23:43:11 +0000
Received: from sandstorm.nvidia.com (Not Verified[10.2.87.173]) by hqnvemgw03.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5ed19e0f0001>; Fri, 29 May 2020 16:43:11 -0700
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
Subject: [PATCH 1/2] docs: mm/gup: pin_user_pages.rst: add a "case 5"
Date:   Fri, 29 May 2020 16:43:08 -0700
Message-ID: <20200529234309.484480-2-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529234309.484480-1-jhubbard@nvidia.com>
References: <20200529234309.484480-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590795699; bh=/rPFi6UMeQqIwH0AXw3mk+tI0oUReiPuYz0u4gk+gB4=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding;
        b=aLSQsNOdMWIF0LkIlbgwkwE7Tydi/7c5/ubijb8BcaFTIZEmhASKRET9Pca2eBhxG
         dREVJpcO2ADpj3UkVt0jUxkcnrRTCw4rXg9IKomdo4dQTH1CfYYB8ffwCmWCd9HN3A
         JIWv3bqa+Gg3EHmOTKcmCEuIvUL/VqJY25SULLKbpwSQ6b1XwGVe3sAYTL/Qwlabih
         x607bsQ0F1z2uQFX8AL5YzbsWkdWeUT/F0Jb8Ib1qqB0Pn0XVtAfJaEZQDl8GkPKcN
         TFCHCxL5GeGK/stqfrP64DTXAMPgO0H6TJzbyusWRjhSQfHOqkJ1IE/IVGf3B5XjlI
         4QyQIJBypY8RA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are four cases listed in pin_user_pages.rst. These are
intended to help developers figure out whether to use
get_user_pages*(), or pin_user_pages*(). However, the four cases
do not cover all the situations. For example, drivers/vhost/vhost.c
has a "pin, write to page, set page dirty, unpin" case.

Add a fifth case, to help explain that there is a general pattern
that requires pin_user_pages*() API calls.

Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: J=C3=A9r=C3=B4me Glisse <jglisse@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 Documentation/core-api/pin_user_pages.rst | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/core-api/pin_user_pages.rst b/Documentation/core=
-api/pin_user_pages.rst
index 4675b04e8829..b9f2688a2c67 100644
--- a/Documentation/core-api/pin_user_pages.rst
+++ b/Documentation/core-api/pin_user_pages.rst
@@ -171,6 +171,26 @@ If only struct page data (as opposed to the actual mem=
ory contents that a page
 is tracking) is affected, then normal GUP calls are sufficient, and neithe=
r flag
 needs to be set.
=20
+CASE 5: Pinning in order to write to the data within the page
+-------------------------------------------------------------
+Even though neither DMA nor Direct IO is involved, just a simple case of "=
pin,
+access page's data, unpin" can cause a problem. Case 5 may be considered a
+superset of Case 1, plus Case 2, plus anything that invokes that pattern. =
In
+other words, if the code is neither Case 1 nor Case 2, it may still requir=
e
+FOLL_PIN, for patterns like this:
+
+Correct (uses FOLL_PIN calls):
+    pin_user_pages()
+    access the data within the pages
+    set_page_dirty_lock()
+    unpin_user_pages()
+
+INCORRECT (uses FOLL_GET calls):
+    get_user_pages()
+    access the data within the pages
+    set_page_dirty_lock()
+    put_page()
+
 page_maybe_dma_pinned(): the whole point of pinning
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
=20
--=20
2.26.2

