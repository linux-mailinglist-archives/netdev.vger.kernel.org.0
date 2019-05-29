Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA582E252
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 18:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbfE2QfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 12:35:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:34316 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726140AbfE2QfK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 12:35:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 44FF8ACC5;
        Wed, 29 May 2019 16:35:08 +0000 (UTC)
From:   Michal Rostecki <mrostecki@opensuse.org>
Cc:     Michal Rostecki <mrostecki@opensuse.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        bpf@vger.kernel.org (open list:BPF (Safe dynamic programs and tools)),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH bpf v3] libbpf: Return btf_fd for load_sk_storage_btf
Date:   Wed, 29 May 2019 18:36:16 +0200
Message-Id: <20190529163616.8418-1-mrostecki@opensuse.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before this change, function load_sk_storage_btf expected that
libbpf__probe_raw_btf was returning a BTF descriptor, but in fact it was
returning an information about whether the probe was successful (0 or
1). load_sk_storage_btf was using that value as an argument of the close
function, which was resulting in closing stdout and thus terminating the
process which called that function.

That bug was visible in bpftool. `bpftool feature` subcommand was always
exiting too early (because of closed stdout) and it didn't display all
requested probes. `bpftool -j feature` or `bpftool -p feature` were not
returning a valid json object.

This change remnames the libbpf__probe_raw_btf function to
libbpf__load_raw_btf, which now returns a BTF descriptor, as expected in
load_sk_storage_btf.

v2:
- Fix typo in the commit message.

v3:
- Simplify BTF descriptor handling in bpf_object__probe_btf_* functions.
- Rename libbpf__probe_raw_btf function to libbpf__load_raw_btf and
return a BTF descriptor.

Fixes: d7c4b3980c18 ("libbpf: detect supported kernel BTF features and sanitize BTF")
Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
---
 tools/lib/bpf/libbpf.c          | 28 ++++++++++++++++------------
 tools/lib/bpf/libbpf_internal.h |  4 ++--
 tools/lib/bpf/libbpf_probes.c   | 13 ++++---------
 3 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 197b574406b3..5d046cc7b207 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1645,14 +1645,16 @@ static int bpf_object__probe_btf_func(struct bpf_object *obj)
 		/* FUNC x */                                    /* [3] */
 		BTF_TYPE_ENC(5, BTF_INFO_ENC(BTF_KIND_FUNC, 0, 0), 2),
 	};
-	int res;
+	int btf_fd;
 
-	res = libbpf__probe_raw_btf((char *)types, sizeof(types),
-				    strs, sizeof(strs));
-	if (res < 0)
-		return res;
-	if (res > 0)
+	btf_fd = libbpf__load_raw_btf((char *)types, sizeof(types),
+				      strs, sizeof(strs));
+	if (btf_fd >= 0) {
 		obj->caps.btf_func = 1;
+		close(btf_fd);
+		return 1;
+	}
+
 	return 0;
 }
 
@@ -1670,14 +1672,16 @@ static int bpf_object__probe_btf_datasec(struct bpf_object *obj)
 		BTF_TYPE_ENC(3, BTF_INFO_ENC(BTF_KIND_DATASEC, 0, 1), 4),
 		BTF_VAR_SECINFO_ENC(2, 0, 4),
 	};
-	int res;
+	int btf_fd;
 
-	res = libbpf__probe_raw_btf((char *)types, sizeof(types),
-				    strs, sizeof(strs));
-	if (res < 0)
-		return res;
-	if (res > 0)
+	btf_fd = libbpf__load_raw_btf((char *)types, sizeof(types),
+				      strs, sizeof(strs));
+	if (btf_fd >= 0) {
 		obj->caps.btf_datasec = 1;
+		close(btf_fd);
+		return 1;
+	}
+
 	return 0;
 }
 
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index f3025b4d90e1..dfab8012185c 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -34,7 +34,7 @@ do {				\
 #define pr_info(fmt, ...)	__pr(LIBBPF_INFO, fmt, ##__VA_ARGS__)
 #define pr_debug(fmt, ...)	__pr(LIBBPF_DEBUG, fmt, ##__VA_ARGS__)
 
-int libbpf__probe_raw_btf(const char *raw_types, size_t types_len,
-			  const char *str_sec, size_t str_len);
+int libbpf__load_raw_btf(const char *raw_types, size_t types_len,
+			 const char *str_sec, size_t str_len);
 
 #endif /* __LIBBPF_LIBBPF_INTERNAL_H */
diff --git a/tools/lib/bpf/libbpf_probes.c b/tools/lib/bpf/libbpf_probes.c
index 5e2aa83f637a..6635a31a7a16 100644
--- a/tools/lib/bpf/libbpf_probes.c
+++ b/tools/lib/bpf/libbpf_probes.c
@@ -133,8 +133,8 @@ bool bpf_probe_prog_type(enum bpf_prog_type prog_type, __u32 ifindex)
 	return errno != EINVAL && errno != EOPNOTSUPP;
 }
 
-int libbpf__probe_raw_btf(const char *raw_types, size_t types_len,
-			  const char *str_sec, size_t str_len)
+int libbpf__load_raw_btf(const char *raw_types, size_t types_len,
+			 const char *str_sec, size_t str_len)
 {
 	struct btf_header hdr = {
 		.magic = BTF_MAGIC,
@@ -157,14 +157,9 @@ int libbpf__probe_raw_btf(const char *raw_types, size_t types_len,
 	memcpy(raw_btf + hdr.hdr_len + hdr.type_len, str_sec, hdr.str_len);
 
 	btf_fd = bpf_load_btf(raw_btf, btf_len, NULL, 0, false);
-	if (btf_fd < 0) {
-		free(raw_btf);
-		return 0;
-	}
 
-	close(btf_fd);
 	free(raw_btf);
-	return 1;
+	return btf_fd;
 }
 
 static int load_sk_storage_btf(void)
@@ -190,7 +185,7 @@ static int load_sk_storage_btf(void)
 		BTF_MEMBER_ENC(23, 2, 32),/* struct bpf_spin_lock l; */
 	};
 
-	return libbpf__probe_raw_btf((char *)types, sizeof(types),
+	return libbpf__load_raw_btf((char *)types, sizeof(types),
 				     strs, sizeof(strs));
 }
 
-- 
2.21.0

