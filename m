Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96F2DDC2D4
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 12:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408235AbfJRKeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 06:34:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52858 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408220AbfJRKeH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 06:34:07 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1A91B18C4276;
        Fri, 18 Oct 2019 10:34:07 +0000 (UTC)
Received: from krava.brq.redhat.com (unknown [10.43.17.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C935600C1;
        Fri, 18 Oct 2019 10:34:05 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH] bpftool: Try to read btf as raw data if elf read fails
Date:   Fri, 18 Oct 2019 12:34:04 +0200
Message-Id: <20191018103404.12999-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Fri, 18 Oct 2019 10:34:07 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpftool interface stays the same, but now it's possible
to run it over BTF raw data, like:

  $ bpftool btf dump file /sys/kernel/btf/vmlinux
  libbpf: failed to get EHDR from /sys/kernel/btf/vmlinux
  [1] INT '(anon)' size=4 bits_offset=0 nr_bits=32 encoding=(none)
  [2] INT 'long unsigned int' size=8 bits_offset=0 nr_bits=64 encoding=(none)
  [3] CONST '(anon)' type_id=2

I'm also adding err init to 0 because I was getting uninitialized
warnings from gcc.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/bpf/bpftool/btf.c | 47 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 42 insertions(+), 5 deletions(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 9a9376d1d3df..100fb7e02329 100644
--- a/tools/bpf/bpftool/btf.c
+++ b/tools/bpf/bpftool/btf.c
@@ -12,6 +12,9 @@
 #include <libbpf.h>
 #include <linux/btf.h>
 #include <linux/hashtable.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
 
 #include "btf.h"
 #include "json_writer.h"
@@ -388,6 +391,35 @@ static int dump_btf_c(const struct btf *btf,
 	return err;
 }
 
+static struct btf *btf__parse_raw(const char *file)
+{
+	struct btf *btf = ERR_PTR(-EINVAL);
+	__u8 *buf = NULL;
+	struct stat st;
+	FILE *f;
+
+	if (stat(file, &st))
+		return btf;
+
+	f = fopen(file, "rb");
+	if (!f)
+		return btf;
+
+	buf = malloc(st.st_size);
+	if (!buf)
+		goto err;
+
+	if ((size_t) st.st_size != fread(buf, 1, st.st_size, f))
+		goto err;
+
+	btf = btf__new(buf, st.st_size);
+
+err:
+	free(buf);
+	fclose(f);
+	return btf;
+}
+
 static int do_dump(int argc, char **argv)
 {
 	struct btf *btf = NULL;
@@ -397,7 +429,7 @@ static int do_dump(int argc, char **argv)
 	__u32 btf_id = -1;
 	const char *src;
 	int fd = -1;
-	int err;
+	int err = 0;
 
 	if (!REQ_ARGS(2)) {
 		usage();
@@ -468,10 +500,15 @@ static int do_dump(int argc, char **argv)
 		btf = btf__parse_elf(*argv, NULL);
 		if (IS_ERR(btf)) {
 			err = PTR_ERR(btf);
-			btf = NULL;
-			p_err("failed to load BTF from %s: %s", 
-			      *argv, strerror(err));
-			goto done;
+			if (err == -LIBBPF_ERRNO__FORMAT)
+				btf = btf__parse_raw(*argv);
+			if (IS_ERR(btf)) {
+				btf = NULL;
+				/* Display the original error value. */
+				p_err("failed to load BTF from %s: %s",
+				      *argv, strerror(err));
+				goto done;
+			}
 		}
 		NEXT_ARG();
 	} else {
-- 
2.21.0

