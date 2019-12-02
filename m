Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04A6910EABA
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 14:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbfLBNTf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 2 Dec 2019 08:19:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53935 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727600AbfLBNT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 08:19:29 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77-Df7Z5Rv0PtOJKGMFN-1dpg-1; Mon, 02 Dec 2019 08:19:25 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E750E1005502;
        Mon,  2 Dec 2019 13:19:22 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B063600C8;
        Mon,  2 Dec 2019 13:19:19 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH 6/6] selftests, bpftool: Add build test for libbpf dynamic linking
Date:   Mon,  2 Dec 2019 14:18:46 +0100
Message-Id: <20191202131847.30837-7-jolsa@kernel.org>
In-Reply-To: <20191202131847.30837-1-jolsa@kernel.org>
References: <20191202131847.30837-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: Df7Z5Rv0PtOJKGMFN-1dpg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding new test to test_bpftool_build.sh script to
test the dynamic linkage of libbpf for bpftool:

  $ ./test_bpftool_build.sh
  [SNIP]

  ... with dynamic libbpf

  $PWD:    /home/jolsa/kernel/linux-perf/tools/bpf/bpftool
  command: make -s -C ../../build/feature clean >/dev/null
  command: make -s -C ../../lib/bpf clean >/dev/null
  command: make -s -C ../../lib/bpf prefix=/tmp/tmp.fG8O2Ps8ER install_lib install_headers >/dev/null
  Parsed description of 117 helper function(s)
  command: make -s clean >/dev/null
  command: make -s LIBBPF_DYNAMIC=1 LIBBPF_DIR=/tmp/tmp.fG8O2Ps8ER >/dev/null
  binary:  /home/jolsa/kernel/linux-perf/tools/bpf/bpftool/bpftool
  binary:  linked with libbpf

The test installs libbpf into temp directory
and links bpftool dynamically with it.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 .../selftests/bpf/test_bpftool_build.sh       | 53 +++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_bpftool_build.sh b/tools/testing/selftests/bpf/test_bpftool_build.sh
index ac349a5cea7e..e4a6a0520f8e 100755
--- a/tools/testing/selftests/bpf/test_bpftool_build.sh
+++ b/tools/testing/selftests/bpf/test_bpftool_build.sh
@@ -85,6 +85,55 @@ make_with_tmpdir() {
 	echo
 }
 
+# Assumes current directory is tools/bpf/bpftool
+make_with_dynamic_libbpf() {
+	TMPDIR=$(mktemp -d)
+	echo -e "\$PWD:    $PWD"
+
+	# It might be needed to clean build tree first because features
+	# framework does not detect the change properly
+	echo -e "command: make -s -C ../../build/feature clean >/dev/null"
+	make $J -s -C ../../build/feature clean >/dev/null
+	if [ $? -ne 0 ] ; then
+		ERROR=1
+	fi
+	echo -e "command: make -s -C ../../lib/bpf clean >/dev/null"
+	make $J -s -C ../../lib/bpf clean >/dev/null
+	if [ $? -ne 0 ] ; then
+		ERROR=1
+	fi
+
+	# Now install libbpf into TMPDIR
+	echo -e "command: make -s -C ../../lib/bpf prefix=$TMPDIR install_lib install_headers >/dev/null"
+	make $J -s -C ../../lib/bpf prefix=$TMPDIR install_lib install_headers >/dev/null
+	if [ $? -ne 0 ] ; then
+		ERROR=1
+	fi
+
+	# And final bpftool build (with clean first) with libbpf dynamic link
+	echo -e "command: make -s clean >/dev/null"
+	if [ $? -ne 0 ] ; then
+		ERROR=1
+	fi
+	echo -e "command: make -s LIBBPF_DYNAMIC=1 LIBBPF_DIR=$TMPDIR >/dev/null"
+	make $J -s LIBBPF_DYNAMIC=1 LIBBPF_DIR=$TMPDIR >/dev/null
+	if [ $? -ne 0 ] ; then
+		ERROR=1
+	fi
+
+	check .
+	ldd bpftool | grep -q libbpf.so
+	if [ $? -ne 0 ] ; then
+		printf "FAILURE: Did not find libbpf linked\n"
+	else
+		echo "binary:  linked with libbpf"
+	fi
+	make -s -C ../../lib/bpf clean
+	make -s clean
+	rm -rf -- $TMPDIR
+	echo
+}
+
 echo "Trying to build bpftool"
 echo -e "... through kbuild\n"
 
@@ -145,3 +194,7 @@ make_and_clean
 make_with_tmpdir OUTPUT
 
 make_with_tmpdir O
+
+echo -e "... with dynamic libbpf\n"
+
+make_with_dynamic_libbpf
-- 
2.21.0

