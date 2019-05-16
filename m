Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0214620DA1
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 19:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbfEPRCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 13:02:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:44898 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727412AbfEPRCW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 13:02:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7FCA7AD17;
        Thu, 16 May 2019 17:02:20 +0000 (UTC)
From:   Michal Rostecki <mrostecki@opensuse.org>
Cc:     Michal Rostecki <mrostecki@opensuse.org>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-newbies@vger.kernel.org
Subject: [PATCH bpf-next v2 1/2] selftests: bpf: Move bpf_printk to bpf_helpers.h
Date:   Thu, 16 May 2019 19:01:52 +0200
Message-Id: <20190516170152.24542-2-mrostecki@opensuse.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190516170152.24542-1-mrostecki@opensuse.org>
References: <20190516170152.24542-1-mrostecki@opensuse.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_printk is a macro which is commonly used to print out debug messages
in BPF programs and it was copied in many selftests and samples. Since
all of them include bpf_helpers.h, this change moves the macro there.

Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
---
 tools/testing/selftests/bpf/bpf_helpers.h                | 8 ++++++++
 tools/testing/selftests/bpf/progs/sockmap_parse_prog.c   | 7 -------
 tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c | 7 -------
 tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c | 7 -------
 tools/testing/selftests/bpf/progs/test_lwt_seg6local.c   | 7 -------
 tools/testing/selftests/bpf/progs/test_xdp_noinline.c    | 7 -------
 tools/testing/selftests/bpf/test_sockmap_kern.h          | 7 -------
 7 files changed, 8 insertions(+), 42 deletions(-)

diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 6e80b66d7fb1..f1c23fc05bce 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -8,6 +8,14 @@
  */
 #define SEC(NAME) __attribute__((section(NAME), used))
 
+/* helper macro to print out debug messages */
+#define bpf_printk(fmt, ...)				\
+({							\
+	char ____fmt[] = fmt;				\
+	bpf_trace_printk(____fmt, sizeof(____fmt),	\
+			 ##__VA_ARGS__);		\
+})
+
 /* helper functions called from eBPF programs written in C */
 static void *(*bpf_map_lookup_elem)(void *map, const void *key) =
 	(void *) BPF_FUNC_map_lookup_elem;
diff --git a/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c b/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
index 0f92858f6226..ed3e4a551c57 100644
--- a/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
+++ b/tools/testing/selftests/bpf/progs/sockmap_parse_prog.c
@@ -5,13 +5,6 @@
 
 int _version SEC("version") = 1;
 
-#define bpf_printk(fmt, ...)					\
-({								\
-	       char ____fmt[] = fmt;				\
-	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
-				##__VA_ARGS__);			\
-})
-
 SEC("sk_skb1")
 int bpf_prog1(struct __sk_buff *skb)
 {
diff --git a/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c b/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c
index 12a7b5c82ed6..65fbfdb6cd3a 100644
--- a/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c
+++ b/tools/testing/selftests/bpf/progs/sockmap_tcp_msg_prog.c
@@ -5,13 +5,6 @@
 
 int _version SEC("version") = 1;
 
-#define bpf_printk(fmt, ...)					\
-({								\
-	       char ____fmt[] = fmt;				\
-	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
-				##__VA_ARGS__);			\
-})
-
 SEC("sk_msg1")
 int bpf_prog1(struct sk_msg_md *msg)
 {
diff --git a/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c b/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c
index 2ce7634a4012..bdc22be46f2e 100644
--- a/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c
+++ b/tools/testing/selftests/bpf/progs/sockmap_verdict_prog.c
@@ -5,13 +5,6 @@
 
 int _version SEC("version") = 1;
 
-#define bpf_printk(fmt, ...)					\
-({								\
-	       char ____fmt[] = fmt;				\
-	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
-				##__VA_ARGS__);			\
-})
-
 struct bpf_map_def SEC("maps") sock_map_rx = {
 	.type = BPF_MAP_TYPE_SOCKMAP,
 	.key_size = sizeof(int),
diff --git a/tools/testing/selftests/bpf/progs/test_lwt_seg6local.c b/tools/testing/selftests/bpf/progs/test_lwt_seg6local.c
index 0575751bc1bc..7c7cb3177463 100644
--- a/tools/testing/selftests/bpf/progs/test_lwt_seg6local.c
+++ b/tools/testing/selftests/bpf/progs/test_lwt_seg6local.c
@@ -6,13 +6,6 @@
 #include "bpf_helpers.h"
 #include "bpf_endian.h"
 
-#define bpf_printk(fmt, ...)				\
-({							\
-	char ____fmt[] = fmt;				\
-	bpf_trace_printk(____fmt, sizeof(____fmt),	\
-			##__VA_ARGS__);			\
-})
-
 /* Packet parsing state machine helpers. */
 #define cursor_advance(_cursor, _len) \
 	({ void *_tmp = _cursor; _cursor += _len; _tmp; })
diff --git a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
index 5e4aac74f9d0..4fe6aaad22a4 100644
--- a/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
+++ b/tools/testing/selftests/bpf/progs/test_xdp_noinline.c
@@ -15,13 +15,6 @@
 #include <linux/udp.h>
 #include "bpf_helpers.h"
 
-#define bpf_printk(fmt, ...)				\
-({							\
-	char ____fmt[] = fmt;				\
-	bpf_trace_printk(____fmt, sizeof(____fmt),	\
-			##__VA_ARGS__);			\
-})
-
 static __u32 rol32(__u32 word, unsigned int shift)
 {
 	return (word << shift) | (word >> ((-shift) & 31));
diff --git a/tools/testing/selftests/bpf/test_sockmap_kern.h b/tools/testing/selftests/bpf/test_sockmap_kern.h
index e7639f66a941..4e7d3da21357 100644
--- a/tools/testing/selftests/bpf/test_sockmap_kern.h
+++ b/tools/testing/selftests/bpf/test_sockmap_kern.h
@@ -28,13 +28,6 @@
  * are established and verdicts are decided.
  */
 
-#define bpf_printk(fmt, ...)					\
-({								\
-	       char ____fmt[] = fmt;				\
-	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
-				##__VA_ARGS__);			\
-})
-
 struct bpf_map_def SEC("maps") sock_map = {
 	.type = TEST_MAP_TYPE,
 	.key_size = sizeof(int),
-- 
2.21.0

