Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E468F8434
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 01:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbfKLAIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 19:08:22 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3406 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727615AbfKLAH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 19:07:29 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dc9f7870000>; Mon, 11 Nov 2019 16:06:31 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 11 Nov 2019 16:07:27 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 11 Nov 2019 16:07:27 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 12 Nov
 2019 00:07:27 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Tue, 12 Nov 2019 00:07:25 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5dc9f7bc0004>; Mon, 11 Nov 2019 16:07:25 -0800
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
Subject: [PATCH v3 20/23] mm/gup_benchmark: use proper FOLL_WRITE flags instead of hard-coding "1"
Date:   Mon, 11 Nov 2019 16:06:57 -0800
Message-ID: <20191112000700.3455038-21-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191112000700.3455038-1-jhubbard@nvidia.com>
References: <20191112000700.3455038-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573517191; bh=7Vmsb+9KRgkgzRB+pY1tHWrSRQ+BM3AUrdVPH7GeYFc=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=IfvI1TWtyCjO8OKOwI3I6WbabrJYVA+N4Jz98QsvLpsrZ643xabZCJXPOx4MydE4D
         MuardO1IggwR2l+GAUtDMBIuT2QOyTWvgpRG4ViJuMFVzCUX53ZdppPYW1H/Wspg8t
         VCIWUAprOaL0MyjTiTLKKRdu4OipTnaSfDsI/FFYPSSeRnJkVWnzsv3+cCFITtYgbj
         CFdOqvnxVkrMp6RVFgPSm7x9J7q51Uzf0X0TPdZs+ckD9YPS/mFkdt/Kq0llzdav8t
         oMqra+Yu2pIf6BBwyRsPl4kqozyu6pF5TLHPmoUp9DxVy7iKslb3X7AuObyLgJltZO
         R+CroqZ5r/Shg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the gup benchmark flags to use the symbolic FOLL_WRITE,
instead of a hard-coded "1" value.

Also, clean up the filtering of gup flags a little, by just doing
it once before issuing any of the get_user_pages*() calls. This
makes it harder to overlook, instead of having little "gup_flags & 1"
phrases in the function calls.

Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 mm/gup_benchmark.c                         | 9 ++++++---
 tools/testing/selftests/vm/gup_benchmark.c | 6 +++++-
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/gup_benchmark.c b/mm/gup_benchmark.c
index 7dd602d7f8db..7fc44d25eca7 100644
--- a/mm/gup_benchmark.c
+++ b/mm/gup_benchmark.c
@@ -48,18 +48,21 @@ static int __gup_benchmark_ioctl(unsigned int cmd,
 			nr =3D (next - addr) / PAGE_SIZE;
 		}
=20
+		/* Filter out most gup flags: only allow a tiny subset here: */
+		gup->flags &=3D FOLL_WRITE;
+
 		switch (cmd) {
 		case GUP_FAST_BENCHMARK:
-			nr =3D get_user_pages_fast(addr, nr, gup->flags & 1,
+			nr =3D get_user_pages_fast(addr, nr, gup->flags,
 						 pages + i);
 			break;
 		case GUP_LONGTERM_BENCHMARK:
 			nr =3D get_user_pages(addr, nr,
-					    (gup->flags & 1) | FOLL_LONGTERM,
+					    gup->flags | FOLL_LONGTERM,
 					    pages + i, NULL);
 			break;
 		case GUP_BENCHMARK:
-			nr =3D get_user_pages(addr, nr, gup->flags & 1, pages + i,
+			nr =3D get_user_pages(addr, nr, gup->flags, pages + i,
 					    NULL);
 			break;
 		default:
diff --git a/tools/testing/selftests/vm/gup_benchmark.c b/tools/testing/sel=
ftests/vm/gup_benchmark.c
index 485cf06ef013..389327e9b30a 100644
--- a/tools/testing/selftests/vm/gup_benchmark.c
+++ b/tools/testing/selftests/vm/gup_benchmark.c
@@ -18,6 +18,9 @@
 #define GUP_LONGTERM_BENCHMARK	_IOWR('g', 2, struct gup_benchmark)
 #define GUP_BENCHMARK		_IOWR('g', 3, struct gup_benchmark)
=20
+/* Just the flags we need, copied from mm.h: */
+#define FOLL_WRITE	0x01	/* check pte is writable */
+
 struct gup_benchmark {
 	__u64 get_delta_usec;
 	__u64 put_delta_usec;
@@ -85,7 +88,8 @@ int main(int argc, char **argv)
 	}
=20
 	gup.nr_pages_per_call =3D nr_pages;
-	gup.flags =3D write;
+	if (write)
+		gup.flags |=3D FOLL_WRITE;
=20
 	fd =3D open("/sys/kernel/debug/gup_benchmark", O_RDWR);
 	if (fd =3D=3D -1)
--=20
2.24.0

