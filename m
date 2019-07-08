Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F80B61F21
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 14:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731133AbfGHM6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 08:58:06 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:37735 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731040AbfGHM6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 08:58:06 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1Mum6l-1iaeG21g8p-00rq0e; Mon, 08 Jul 2019 14:57:37 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Andrii Nakryiko <andriin@fb.com>,
        Martin Lau <kafai@fb.com>, Stanislav Fomichev <sdf@google.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Mauricio Vasquez B <mauricio.vasquez@polito.it>,
        Roman Gushchin <guro@fb.com>, Matt Mullins <mmullins@fb.com>,
        Willem de Bruijn <willemb@google.com>,
        Andrey Ignatov <rdna@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] bpf: skip sockopt hooks without CONFIG_NET
Date:   Mon,  8 Jul 2019 14:57:20 +0200
Message-Id: <20190708125733.3944836-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:VrGP90r317E+s+6oz2WhDCGWJPQqPhdlxp6EpqxIk9C3kEmwIzs
 nLRM3xVjN7Zuqn+sBWKdmizbsrCbzbKwwOqlaljyycaUGCNzy9rV6hV9Bx+j37Iwt/XN27b
 Bw/44BXMzSEKz7UopYgpb8dNFsSi8O4W/NnTshCXfLeVLG/Y6KvaxAh7yKH+S6kXkt31Tl3
 Dxlpi23Syxtz7fBjE4xXQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:bL4qJrT3mgk=:RQAROGmY0HunZUona7GTgx
 uLRbBC8O2LoUaRweQqa28Eh5usWoDfAPA1c5eorEgkv+b/Z38FjfdbqJvaxr9UPzvvAiiAwRi
 yn8wzn9w0vzTTjW5QvTNORYJ4TvC/neGLWMzLr5C/VV74iPsyn5r7vtBdfsZ/YqhnFusxhE4Y
 qjFgEykkP7QY9l7mp77MbTE+fwS3o3Lf//wraNloFVvsbvUsVB+lGcBgNUcBjBa0beSAKxZEu
 TS8g75zsKJ6OyECzrxHY83bgw02K9CaaRKoeqSFWiV5nr/RlMx1rdZgdvkghd2NSUhp1iW741
 SrmL9fZTS0XJhVBn4DiHCr6PpNIXVNpR26ZIbn4i3Ou00ATjKEkHBRSOj85JY+7+j7FALf4Fq
 jHPpyLsQCpChXIpo7RLfO4FROIGHtsjhl5UJgCHixdIhpA4yNG8T5kSY4lxqQNdMaJWXYc820
 8YjopQY6IuZ3M5su8Pw8mBfOyRjyetWRr5F5aJ/cuZtkMMHAnRwl+d4kEOnKcA7xGlSQ6z8QG
 xfnFSKzbhPTAV2B4f4hH0TDWNjKybnpwDFUQa9fmTRhCxx1EHz/r5pOmXpAMz8aibDC1R1ZNQ
 rBGRhCip+M+DUFqolTaI3cuuZtnyf5oTsJZ3V3e3q4RpqLJ+VBkQdWw00XqVmQcU2ypaZQoir
 /5btpBE1w4cgnfiJzodR7bv5DaDkxu2BzxZWeLXzceapDBdG0zRPE4Ic/oDkrKv9+pNLv3W/l
 s5CXgjbL8gOk7o1S3a3McrEEQtDaWdjqRtJyfQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_NET is disabled, we get a link error:

kernel/bpf/cgroup.o: In function `__cgroup_bpf_run_filter_setsockopt':
cgroup.c:(.text+0x3010): undefined reference to `lock_sock_nested'
cgroup.c:(.text+0x3258): undefined reference to `release_sock'
kernel/bpf/cgroup.o: In function `__cgroup_bpf_run_filter_getsockopt':
cgroup.c:(.text+0x3568): undefined reference to `lock_sock_nested'
cgroup.c:(.text+0x3870): undefined reference to `release_sock'
kernel/bpf/cgroup.o: In function `cg_sockopt_func_proto':
cgroup.c:(.text+0x41d8): undefined reference to `bpf_sk_storage_delete_proto'

None of this code is useful in this configuration anyway, so we can
simply hide it in an appropriate #ifdef.

Fixes: 0d01da6afc54 ("bpf: implement getsockopt and setsockopt hooks")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/bpf_types.h | 2 ++
 kernel/bpf/cgroup.c       | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index eec5aeeeaf92..3c7222b2db96 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -30,8 +30,10 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE, raw_tracepoint_writable)
 #ifdef CONFIG_CGROUP_BPF
 BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_DEVICE, cg_dev)
 BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SYSCTL, cg_sysctl)
+#ifdef CONFIG_NET
 BPF_PROG_TYPE(BPF_PROG_TYPE_CGROUP_SOCKOPT, cg_sockopt)
 #endif
+#endif
 #ifdef CONFIG_BPF_LIRC_MODE2
 BPF_PROG_TYPE(BPF_PROG_TYPE_LIRC_MODE2, lirc_mode2)
 #endif
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 76fa0076f20d..7be44460bd93 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -590,6 +590,7 @@ int cgroup_bpf_prog_query(const union bpf_attr *attr,
 	return ret;
 }
 
+#ifdef CONFIG_NET
 /**
  * __cgroup_bpf_run_filter_skb() - Run a program for packet filtering
  * @sk: The socket sending or receiving traffic
@@ -750,6 +751,7 @@ int __cgroup_bpf_run_filter_sock_ops(struct sock *sk,
 	return ret == 1 ? 0 : -EPERM;
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_sock_ops);
+#endif
 
 int __cgroup_bpf_check_dev_permission(short dev_type, u32 major, u32 minor,
 				      short access, enum bpf_attach_type type)
@@ -939,6 +941,7 @@ int __cgroup_bpf_run_filter_sysctl(struct ctl_table_header *head,
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_sysctl);
 
+#ifdef CONFIG_NET
 static bool __cgroup_bpf_prog_array_is_empty(struct cgroup *cgrp,
 					     enum bpf_attach_type attach_type)
 {
@@ -1120,6 +1123,7 @@ int __cgroup_bpf_run_filter_getsockopt(struct sock *sk, int level,
 	return ret;
 }
 EXPORT_SYMBOL(__cgroup_bpf_run_filter_getsockopt);
+#endif
 
 static ssize_t sysctl_cpy_dir(const struct ctl_dir *dir, char **bufp,
 			      size_t *lenp)
@@ -1382,6 +1386,7 @@ const struct bpf_verifier_ops cg_sysctl_verifier_ops = {
 const struct bpf_prog_ops cg_sysctl_prog_ops = {
 };
 
+#ifdef CONFIG_NET
 static const struct bpf_func_proto *
 cg_sockopt_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -1531,3 +1536,4 @@ const struct bpf_verifier_ops cg_sockopt_verifier_ops = {
 
 const struct bpf_prog_ops cg_sockopt_prog_ops = {
 };
+#endif
-- 
2.20.0

