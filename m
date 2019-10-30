Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 750F7EA6B1
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 23:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbfJ3WuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 18:50:02 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10933 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727695AbfJ3Wt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 18:49:59 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dba13990000>; Wed, 30 Oct 2019 15:50:02 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 30 Oct 2019 15:49:56 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 30 Oct 2019 15:49:56 -0700
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 30 Oct
 2019 22:49:56 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Wed, 30 Oct 2019 22:49:55 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5dba13910000>; Wed, 30 Oct 2019 15:49:54 -0700
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
Subject: [PATCH 17/19] selftests/vm: run_vmtests: invoke gup_benchmark with basic FOLL_PIN coverage
Date:   Wed, 30 Oct 2019 15:49:28 -0700
Message-ID: <20191030224930.3990755-18-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191030224930.3990755-1-jhubbard@nvidia.com>
References: <20191030224930.3990755-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572475802; bh=rwvy5scTy5JLg+SKsytZrhoxXGIN7QSORs5+YcV8QqY=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=XMlwzmlsux1x0Db3R9XtBtpzjYXCTvq1+eH82SOkL7qTi9NIeyo2RiVOugrlMnjXp
         j/blE4LbMu++iqb3TbjZXJt1U/KnPH2iz7i2Q4sFaLCCgAdF8PND1X7rBXqioEEq8Y
         1vN8JSqiWFPRV1/5KAyyd/2JtkDJdFak6VIckw/yDbNnHJznIDf2Pm0gLd3fIW5SAo
         LDRD4oRm1cX1XHRjUB/PWhseuEDhqDXyBVYbFPmMpNl97r8d3/wKZ6uLHzaoEe1wjo
         ZPUzAHtbjU4zpX5BEyECGbg9F/hknFZvXkKdhvHrRgQVy6Gi0jX5prZZqD/X8QGmxF
         dREPidPh4E87g==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's good to have basic unit test coverage of the new FOLL_PIN
behavior. Fortunately, the gup_benchmark unit test is extremely
fast (a few milliseconds), so adding it the the run_vmtests suite
is going to cause no noticeable change in running time.

So, add two new invocations to run_vmtests:

1) Run gup_benchmark with normal get_user_pages().

2) Run gup_benchmark with pin_user_pages(). This is much like
the first call, except that it sets FOLL_PIN.

Running these two in quick succession also provide a visual
comparison of the running times, which is convenient.

The new invocations are fairly early in the run_vmtests script,
because with test suites, it's usually preferable to put the
shorter, faster tests first, all other things being equal.

Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 tools/testing/selftests/vm/run_vmtests | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/testing/selftests/vm/run_vmtests b/tools/testing/selftes=
ts/vm/run_vmtests
index 951c507a27f7..93e8dc9a7cad 100755
--- a/tools/testing/selftests/vm/run_vmtests
+++ b/tools/testing/selftests/vm/run_vmtests
@@ -104,6 +104,28 @@ echo "NOTE: The above hugetlb tests provide minimal co=
verage.  Use"
 echo "      https://github.com/libhugetlbfs/libhugetlbfs.git for"
 echo "      hugetlb regression testing."
=20
+echo "--------------------------------------------"
+echo "running 'gup_benchmark -U' (normal/slow gup)"
+echo "--------------------------------------------"
+./gup_benchmark -U
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=3D1
+else
+	echo "[PASS]"
+fi
+
+echo "------------------------------------------"
+echo "running gup_benchmark -c (pin_user_pages)"
+echo "------------------------------------------"
+./gup_benchmark -c
+if [ $? -ne 0 ]; then
+	echo "[FAIL]"
+	exitcode=3D1
+else
+	echo "[PASS]"
+fi
+
 echo "-------------------"
 echo "running userfaultfd"
 echo "-------------------"
--=20
2.23.0

