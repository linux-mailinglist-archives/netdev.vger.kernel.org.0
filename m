Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 059C411A202
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 03:54:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbfLKCyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 21:54:43 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:2219 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728009AbfLKCxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 21:53:39 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5df05a2b0000>; Tue, 10 Dec 2019 18:53:31 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 10 Dec 2019 18:53:37 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 10 Dec 2019 18:53:37 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 11 Dec
 2019 02:53:37 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 11 Dec 2019 02:53:36 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5df05a300000>; Tue, 10 Dec 2019 18:53:36 -0800
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
Subject: [PATCH v9 24/25] mm/gup_benchmark: support pin_user_pages() and related calls
Date:   Tue, 10 Dec 2019 18:53:17 -0800
Message-ID: <20191211025318.457113-25-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191211025318.457113-1-jhubbard@nvidia.com>
References: <20191211025318.457113-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576032811; bh=x7MvVbQRVwUCvgSjQ/8SlrbWelgqje2hefrKJsxWbbs=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=Ibw6DdhZdycZZBMLmtkubQjMfNd15L9IJ19dKUI6Dhz6vrT6luhJQfGdkq508jsaY
         wEOiOGkd86kV95Ro8XgWXv6Ygmv6FaCDtB1m5sjRw//kUEPo2csdS39+IrfS4xPG5I
         zgenXAokb2kdz1rHFp1NHqTmp3u5xMPh9a6vYGdb2lH/x37lRcToUMxKC2RXbuJ6XZ
         ehqG0x4sEj+5GBtsvwkbMDQW1VS1j5ru8zfymGLbE2geC2e2Gd7HEfR0vj3H96U6AS
         TzIvvVtulWHBubi2LFDHDlPGg3dkNs4T/wTgQnislHfw5R9efVod/9KQ4xIYtce7k3
         l9fb9F3xYFZYA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Up until now, gup_benchmark supported testing of the
following kernel functions:

* get_user_pages(): via the '-U' command line option
* get_user_pages_longterm(): via the '-L' command line option
* get_user_pages_fast(): as the default (no options required)

Add test coverage for the new corresponding pin_*() functions:

* pin_user_pages_fast(): via the '-a' command line option
* pin_user_pages():      via the '-b' command line option

Also, add an option for clarity: '-u' for what is now (still) the
default choice: get_user_pages_fast().

Also, for the commands that set FOLL_PIN, verify that the pages
really are dma-pinned, via the new is_dma_pinned() routine.
Those commands are:

    PIN_FAST_BENCHMARK     : calls pin_user_pages_fast()
    PIN_BENCHMARK          : calls pin_user_pages()

In between the calls to pin_*() and unpin_user_pages(),
check each page: if page_dma_pinned() returns false, then
WARN and return.

Do this outside of the benchmark timestamps, so that it doesn't
affect reported times.

Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 mm/gup_benchmark.c                         | 65 ++++++++++++++++++++--
 tools/testing/selftests/vm/gup_benchmark.c | 15 ++++-
 2 files changed, 74 insertions(+), 6 deletions(-)

diff --git a/mm/gup_benchmark.c b/mm/gup_benchmark.c
index 7fc44d25eca7..76d32db48af8 100644
--- a/mm/gup_benchmark.c
+++ b/mm/gup_benchmark.c
@@ -8,6 +8,8 @@
 #define GUP_FAST_BENCHMARK	_IOWR('g', 1, struct gup_benchmark)
 #define GUP_LONGTERM_BENCHMARK	_IOWR('g', 2, struct gup_benchmark)
 #define GUP_BENCHMARK		_IOWR('g', 3, struct gup_benchmark)
+#define PIN_FAST_BENCHMARK	_IOWR('g', 4, struct gup_benchmark)
+#define PIN_BENCHMARK		_IOWR('g', 5, struct gup_benchmark)
=20
 struct gup_benchmark {
 	__u64 get_delta_usec;
@@ -19,6 +21,42 @@ struct gup_benchmark {
 	__u64 expansion[10];	/* For future use */
 };
=20
+static void put_back_pages(int cmd, struct page **pages, unsigned long nr_=
pages)
+{
+	int i;
+
+	switch (cmd) {
+	case GUP_FAST_BENCHMARK:
+	case GUP_LONGTERM_BENCHMARK:
+	case GUP_BENCHMARK:
+		for (i =3D 0; i < nr_pages; i++)
+			put_page(pages[i]);
+		break;
+
+	case PIN_FAST_BENCHMARK:
+	case PIN_BENCHMARK:
+		unpin_user_pages(pages, nr_pages);
+		break;
+	}
+}
+
+static void verify_dma_pinned(int cmd, struct page **pages,
+			      unsigned long nr_pages)
+{
+	int i;
+
+	switch (cmd) {
+	case PIN_FAST_BENCHMARK:
+	case PIN_BENCHMARK:
+		for (i =3D 0; i < nr_pages; i++) {
+			if (WARN(!page_dma_pinned(pages[i]),
+				 "pages[%d] is NOT dma-pinned\n", i))
+				break;
+		}
+		break;
+	}
+}
+
 static int __gup_benchmark_ioctl(unsigned int cmd,
 		struct gup_benchmark *gup)
 {
@@ -65,6 +103,14 @@ static int __gup_benchmark_ioctl(unsigned int cmd,
 			nr =3D get_user_pages(addr, nr, gup->flags, pages + i,
 					    NULL);
 			break;
+		case PIN_FAST_BENCHMARK:
+			nr =3D pin_user_pages_fast(addr, nr, gup->flags,
+						 pages + i);
+			break;
+		case PIN_BENCHMARK:
+			nr =3D pin_user_pages(addr, nr, gup->flags, pages + i,
+					    NULL);
+			break;
 		default:
 			return -1;
 		}
@@ -75,15 +121,22 @@ static int __gup_benchmark_ioctl(unsigned int cmd,
 	}
 	end_time =3D ktime_get();
=20
+	/* Shifting the meaning of nr_pages: now it is actual number pinned: */
+	nr_pages =3D i;
+
 	gup->get_delta_usec =3D ktime_us_delta(end_time, start_time);
 	gup->size =3D addr - gup->addr;
=20
+	/*
+	 * Take an un-benchmark-timed moment to verify DMA pinned
+	 * state: print a warning if any non-dma-pinned pages are found:
+	 */
+	verify_dma_pinned(cmd, pages, nr_pages);
+
 	start_time =3D ktime_get();
-	for (i =3D 0; i < nr_pages; i++) {
-		if (!pages[i])
-			break;
-		put_page(pages[i]);
-	}
+
+	put_back_pages(cmd, pages, nr_pages);
+
 	end_time =3D ktime_get();
 	gup->put_delta_usec =3D ktime_us_delta(end_time, start_time);
=20
@@ -101,6 +154,8 @@ static long gup_benchmark_ioctl(struct file *filep, uns=
igned int cmd,
 	case GUP_FAST_BENCHMARK:
 	case GUP_LONGTERM_BENCHMARK:
 	case GUP_BENCHMARK:
+	case PIN_FAST_BENCHMARK:
+	case PIN_BENCHMARK:
 		break;
 	default:
 		return -EINVAL;
diff --git a/tools/testing/selftests/vm/gup_benchmark.c b/tools/testing/sel=
ftests/vm/gup_benchmark.c
index 389327e9b30a..43b4dfe161a2 100644
--- a/tools/testing/selftests/vm/gup_benchmark.c
+++ b/tools/testing/selftests/vm/gup_benchmark.c
@@ -18,6 +18,10 @@
 #define GUP_LONGTERM_BENCHMARK	_IOWR('g', 2, struct gup_benchmark)
 #define GUP_BENCHMARK		_IOWR('g', 3, struct gup_benchmark)
=20
+/* Similar to above, but use FOLL_PIN instead of FOLL_GET. */
+#define PIN_FAST_BENCHMARK	_IOWR('g', 4, struct gup_benchmark)
+#define PIN_BENCHMARK		_IOWR('g', 5, struct gup_benchmark)
+
 /* Just the flags we need, copied from mm.h: */
 #define FOLL_WRITE	0x01	/* check pte is writable */
=20
@@ -40,8 +44,14 @@ int main(int argc, char **argv)
 	char *file =3D "/dev/zero";
 	char *p;
=20
-	while ((opt =3D getopt(argc, argv, "m:r:n:f:tTLUwSH")) !=3D -1) {
+	while ((opt =3D getopt(argc, argv, "m:r:n:f:abtTLUuwSH")) !=3D -1) {
 		switch (opt) {
+		case 'a':
+			cmd =3D PIN_FAST_BENCHMARK;
+			break;
+		case 'b':
+			cmd =3D PIN_BENCHMARK;
+			break;
 		case 'm':
 			size =3D atoi(optarg) * MB;
 			break;
@@ -63,6 +73,9 @@ int main(int argc, char **argv)
 		case 'U':
 			cmd =3D GUP_BENCHMARK;
 			break;
+		case 'u':
+			cmd =3D GUP_FAST_BENCHMARK;
+			break;
 		case 'w':
 			write =3D 1;
 			break;
--=20
2.24.0

