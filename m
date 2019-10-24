Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D68FE3433
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 15:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393592AbfJXNad convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 24 Oct 2019 09:30:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36019 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727333AbfJXNad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 09:30:33 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-vdhGql6oMSejvRr_1-7dqg-1; Thu, 24 Oct 2019 09:30:29 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE543107AD31;
        Thu, 24 Oct 2019 13:30:27 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.43.17.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC8D85D9CA;
        Thu, 24 Oct 2019 13:30:25 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH] bpftool: Allow to read btf as raw data
Date:   Thu, 24 Oct 2019 15:30:25 +0200
Message-Id: <20191024133025.10691-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: vdhGql6oMSejvRr_1-7dqg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpftool interface stays the same, but now it's possible
to run it over BTF raw data, like:

  $ bpftool btf dump file /sys/kernel/btf/vmlinux
  [1] INT '(anon)' size=4 bits_offset=0 nr_bits=32 encoding=(none)
  [2] INT 'long unsigned int' size=8 bits_offset=0 nr_bits=64 encoding=(none)
  [3] CONST '(anon)' type_id=2

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
v3 changes:
 - fix title

v2 changes:
 - added is_btf_raw to find out which btf__parse_* function to call
 - changed labels and error propagation in btf__parse_raw
 - drop the err initialization, which is not needed under this change

 tools/bpf/bpftool/btf.c | 57 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
index 9a9376d1d3df..a7b8bf233cf5 100644
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
@@ -388,6 +391,54 @@ static int dump_btf_c(const struct btf *btf,
 	return err;
 }
 
+static struct btf *btf__parse_raw(const char *file)
+{
+	struct btf *btf;
+	struct stat st;
+	__u8 *buf;
+	FILE *f;
+
+	if (stat(file, &st))
+		return NULL;
+
+	f = fopen(file, "rb");
+	if (!f)
+		return NULL;
+
+	buf = malloc(st.st_size);
+	if (!buf) {
+		btf = ERR_PTR(-ENOMEM);
+		goto exit_close;
+	}
+
+	if ((size_t) st.st_size != fread(buf, 1, st.st_size, f)) {
+		btf = ERR_PTR(-EINVAL);
+		goto exit_free;
+	}
+
+	btf = btf__new(buf, st.st_size);
+
+exit_free:
+	free(buf);
+exit_close:
+	fclose(f);
+	return btf;
+}
+
+static bool is_btf_raw(const char *file)
+{
+	__u16 magic = 0;
+	int fd;
+
+	fd = open(file, O_RDONLY);
+	if (fd < 0)
+		return false;
+
+	read(fd, &magic, sizeof(magic));
+	close(fd);
+	return magic == BTF_MAGIC;
+}
+
 static int do_dump(int argc, char **argv)
 {
 	struct btf *btf = NULL;
@@ -465,7 +516,11 @@ static int do_dump(int argc, char **argv)
 		}
 		NEXT_ARG();
 	} else if (is_prefix(src, "file")) {
-		btf = btf__parse_elf(*argv, NULL);
+		if (is_btf_raw(*argv))
+			btf = btf__parse_raw(*argv);
+		else
+			btf = btf__parse_elf(*argv, NULL);
+
 		if (IS_ERR(btf)) {
 			err = PTR_ERR(btf);
 			btf = NULL;
-- 
2.21.0

