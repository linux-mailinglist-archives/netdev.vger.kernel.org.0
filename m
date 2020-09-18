Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1294526FB7F
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 13:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgIRLba convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 18 Sep 2020 07:31:30 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:57618 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726241AbgIRLad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 07:30:33 -0400
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 07:30:32 EDT
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-CM1PxpJcOxmNqaadFh7ddg-1; Fri, 18 Sep 2020 07:23:43 -0400
X-MC-Unique: CM1PxpJcOxmNqaadFh7ddg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A446510BBEE1;
        Fri, 18 Sep 2020 11:23:41 +0000 (UTC)
Received: from krava.redhat.com (ovpn-114-24.ams2.redhat.com [10.36.114.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1837D78818;
        Fri, 18 Sep 2020 11:23:38 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCHv2 bpf-next] selftests/bpf: Fix stat probe in d_path test
Date:   Fri, 18 Sep 2020 13:23:38 +0200
Message-Id: <20200918112338.2618444-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some kernels builds might inline vfs_getattr call within fstat
syscall code path, so fentry/vfs_getattr trampoline is not called.

Alexei suggested [1] we should use security_inode_getattr instead,
because it's less likely to get inlined. Using this idea also for
vfs_truncate (replaced with security_path_truncate) and vfs_fallocate
(replaced with security_file_permission).

Keeping dentry_open and filp_close, because they are in their own
files, so unlikely to be inlined, but in case they are, adding
security_file_open.

Switching the d_path test stat trampoline to security_inode_getattr.

Adding flags that indicate trampolines were called and failing
the test if any of them got missed, so it's easier to identify
the issue next time.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
[1] https://lore.kernel.org/bpf/CAADnVQJ0FchoPqNWm+dEppyij-MOvvEG_trEfyrHdabtcEuZGg@mail.gmail.com/
Fixes: e4d1af4b16f8 ("selftests/bpf: Add test for d_path helper")
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
v2 changes:
  - replaced vfs_* function with security_* in d_path allow list
    vfs_truncate  -> security_path_truncate
    vfs_fallocate -> security_file_permission
    vfs_getattr   -> security_inode_getattr
  - added security_file_open to d_path allow list
  - split verbose output for trampoline flags

 kernel/trace/bpf_trace.c                        |  7 ++++---
 tools/testing/selftests/bpf/prog_tests/d_path.c | 10 ++++++++++
 tools/testing/selftests/bpf/progs/test_d_path.c |  9 ++++++++-
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index b2a5380eb187..e24323d72cac 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1118,10 +1118,11 @@ BPF_CALL_3(bpf_d_path, struct path *, path, char *, buf, u32, sz)
 }
 
 BTF_SET_START(btf_allowlist_d_path)
-BTF_ID(func, vfs_truncate)
-BTF_ID(func, vfs_fallocate)
+BTF_ID(func, security_path_truncate)
+BTF_ID(func, security_file_permission)
+BTF_ID(func, security_inode_getattr)
+BTF_ID(func, security_file_open)
 BTF_ID(func, dentry_open)
-BTF_ID(func, vfs_getattr)
 BTF_ID(func, filp_close)
 BTF_SET_END(btf_allowlist_d_path)
 
diff --git a/tools/testing/selftests/bpf/prog_tests/d_path.c b/tools/testing/selftests/bpf/prog_tests/d_path.c
index fc12e0d445ff..0a577a248d34 100644
--- a/tools/testing/selftests/bpf/prog_tests/d_path.c
+++ b/tools/testing/selftests/bpf/prog_tests/d_path.c
@@ -120,6 +120,16 @@ void test_d_path(void)
 	if (err < 0)
 		goto cleanup;
 
+	if (CHECK(!bss->called_stat,
+		  "stat",
+		  "trampoline for security_inode_getattr was not called\n"))
+		goto cleanup;
+
+	if (CHECK(!bss->called_close,
+		  "close",
+		  "trampoline for filp_close was not called\n"))
+		goto cleanup;
+
 	for (int i = 0; i < MAX_FILES; i++) {
 		CHECK(strncmp(src.paths[i], bss->paths_stat[i], MAX_PATH_LEN),
 		      "check",
diff --git a/tools/testing/selftests/bpf/progs/test_d_path.c b/tools/testing/selftests/bpf/progs/test_d_path.c
index 61f007855649..84e1f883f97b 100644
--- a/tools/testing/selftests/bpf/progs/test_d_path.c
+++ b/tools/testing/selftests/bpf/progs/test_d_path.c
@@ -15,7 +15,10 @@ char paths_close[MAX_FILES][MAX_PATH_LEN] = {};
 int rets_stat[MAX_FILES] = {};
 int rets_close[MAX_FILES] = {};
 
-SEC("fentry/vfs_getattr")
+int called_stat = 0;
+int called_close = 0;
+
+SEC("fentry/security_inode_getattr")
 int BPF_PROG(prog_stat, struct path *path, struct kstat *stat,
 	     __u32 request_mask, unsigned int query_flags)
 {
@@ -23,6 +26,8 @@ int BPF_PROG(prog_stat, struct path *path, struct kstat *stat,
 	__u32 cnt = cnt_stat;
 	int ret;
 
+	called_stat = 1;
+
 	if (pid != my_pid)
 		return 0;
 
@@ -42,6 +47,8 @@ int BPF_PROG(prog_close, struct file *file, void *id)
 	__u32 cnt = cnt_close;
 	int ret;
 
+	called_close = 1;
+
 	if (pid != my_pid)
 		return 0;
 
-- 
2.26.2

