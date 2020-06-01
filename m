Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9CF1E9D49
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 07:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgFAF0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 01:26:42 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:13033 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgFAF0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 01:26:40 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ed491390000>; Sun, 31 May 2020 22:25:13 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Sun, 31 May 2020 22:26:39 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Sun, 31 May 2020 22:26:39 -0700
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Jun
 2020 05:26:39 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 1 Jun 2020 05:26:38 +0000
Received: from sandstorm.nvidia.com (Not Verified[10.2.56.10]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5ed4918d0001>; Sun, 31 May 2020 22:26:38 -0700
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
Subject: [PATCH v2 1/2] docs: mm/gup: pin_user_pages.rst: add a "case 5"
Date:   Sun, 31 May 2020 22:26:32 -0700
Message-ID: <20200601052633.853874-2-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601052633.853874-1-jhubbard@nvidia.com>
References: <20200601052633.853874-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590989113; bh=t7FWcHHh76dL2ntq5uEZcJXrRdIPUbkPCP1hpf5ZyJs=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Type:Content-Transfer-Encoding;
        b=qK1j9GFqbfQmVpQy1H0RYKNlXRO1BkoJ29m7kmpMnNPQuUtvQfBwg2vMMsSvFveYZ
         B4RJF6yYzDWJPbA+0xaMNCl5pIiwE9zxqS3DmytXMMVogrqpR6QR5ifPBK/4OdqkAx
         5sQJ9sxAAQ3GrAOxexuMi6vvC13lWsy/ISJCnIhPlJoIMi/2csU1MFDnTggQ4T94oK
         Tod2zq/E8lTiWlfYGrPfl+Wiu7+lAkY4xGFHT6UWkLNH8s/BwSkflVnW/N7ALhfKyH
         hwASUzab4eDY3/262l16OFARt1OWnabnYoH3Ab53hs03ClSVHIf+sK0Fj9TGdPcb8l
         GptD7xNG4tqcw==
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
 Documentation/core-api/pin_user_pages.rst | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/core-api/pin_user_pages.rst b/Documentation/core=
-api/pin_user_pages.rst
index 4675b04e8829..6068266dd303 100644
--- a/Documentation/core-api/pin_user_pages.rst
+++ b/Documentation/core-api/pin_user_pages.rst
@@ -171,6 +171,24 @@ If only struct page data (as opposed to the actual mem=
ory contents that a page
 is tracking) is affected, then normal GUP calls are sufficient, and neithe=
r flag
 needs to be set.
=20
+CASE 5: Pinning in order to write to the data within the page
+-------------------------------------------------------------
+Even though neither DMA nor Direct IO is involved, just a simple case of "=
pin,
+write to a page's data, unpin" can cause a problem. Case 5 may be consider=
ed a
+superset of Case 1, plus Case 2, plus anything that invokes that pattern. =
In
+other words, if the code is neither Case 1 nor Case 2, it may still requir=
e
+FOLL_PIN, for patterns like this:
+
+Correct (uses FOLL_PIN calls):
+    pin_user_pages()
+    write to the data within the pages
+    unpin_user_pages()
+
+INCORRECT (uses FOLL_GET calls):
+    get_user_pages()
+    write to the data within the pages
+    put_page()
+
 page_maybe_dma_pinned(): the whole point of pinning
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
=20
--=20
2.26.2

