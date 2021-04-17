Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E442B362D4A
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 05:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235797AbhDQDeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 23:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235543AbhDQDdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 23:33:52 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67E1C06138A;
        Fri, 16 Apr 2021 20:32:35 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id o123so19584841pfb.4;
        Fri, 16 Apr 2021 20:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=R/Xxqz4DrDDwWe5a+uGPlzP6Ift6vUEOzuovFiQHbNg=;
        b=YIxQ9p+8p+mvtSPfTI+DwPk8FWwaTtHaxvV7IZnblSvZBJLDmYRb3UkTN22tKvjb8u
         psejbAiy7hhECPnhkJWS4QPo5ls9dQTcODED99UXy67rNiMVEAi7U90AkcivM6sFN+89
         A2zSjghaJKszVtdWmNcjj4SDxiJcsisLRrDG/qW09PdwU2VI4Sc0S3+1xfTcerRwXGpi
         D7RwTW4EeRXxt3HJeb6/TlZTQhcANbcDeRsDISzpQmYfo+Tu4PFbT0VwxQZrS1iQmBS+
         gYoDKBVeHJ5iZgq4G0JfDCj618VkhPIcsSlADdIs9+jCn/gGe42XQ6VcA1inYOcZfsL9
         2tqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=R/Xxqz4DrDDwWe5a+uGPlzP6Ift6vUEOzuovFiQHbNg=;
        b=DbYbfMbfVJbBFlgxlQkJ7bNaTjPzjlw32IEH0p3EGauE0DblWwuFCeAqamdgqgxOIU
         /sKgQNYLZc5echCCjRTnvqWy5SxiEO5AKl+r2fsIEcJbCnhKLcuWVUtwVausqrsuGO+x
         ZPIHXZ8sSeVDmTCdp0oJtNGG9+VdLrNz4CcN702i/TLBsobU5gG+tGN2LdSN0ZCez7qe
         TICkmCrOAyJtSu9gNrol8Vn3vEsZV/SO07j/X8NgvXstPn+JPmbDl1PXJcfriSWH56xz
         ZKaZAbkciOD7sddUyidsnxVk1Cdv+lT3ASuSa8KnGP4KD/m23km9pwYRz4id90Pg2KVe
         KelQ==
X-Gm-Message-State: AOAM532wTvROpHirSjCzR4OVAhy/ck6t2NKw78m9BrBI6ip0ALAMSIa8
        4gPT/zv9OuIeyFDR6JdbcP8=
X-Google-Smtp-Source: ABdhPJyl0jyprupWjpy2thIYB6avazZc+RbdFufm4h/Dawlx56OXdSLBajRkwDJU89EB5cAUlti9Gg==
X-Received: by 2002:a62:3086:0:b029:248:16e0:7c6 with SMTP id w128-20020a6230860000b029024816e007c6mr10720018pfw.19.1618630355391;
        Fri, 16 Apr 2021 20:32:35 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id h1sm6069870pgv.88.2021.04.16.20.32.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Apr 2021 20:32:34 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 06/15] bpf: Make btf_load command to be bpfptr_t compatible.
Date:   Fri, 16 Apr 2021 20:32:15 -0700
Message-Id: <20210417033224.8063-7-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
References: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Similar to prog_load make btf_load command to be availble to
bpf_prog_type_syscall program.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/linux/btf.h  | 2 +-
 kernel/bpf/btf.c     | 8 ++++----
 kernel/bpf/syscall.c | 7 ++++---
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 3bac66e0183a..94a0c976c90f 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -21,7 +21,7 @@ extern const struct file_operations btf_fops;
 
 void btf_get(struct btf *btf);
 void btf_put(struct btf *btf);
-int btf_new_fd(const union bpf_attr *attr);
+int btf_new_fd(const union bpf_attr *attr, bpfptr_t uattr);
 struct btf *btf_get_by_fd(int fd);
 int btf_get_info_by_fd(const struct btf *btf,
 		       const union bpf_attr *attr,
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 0600ed325fa0..fbf6c06a9d62 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4257,7 +4257,7 @@ static int btf_parse_hdr(struct btf_verifier_env *env)
 	return 0;
 }
 
-static struct btf *btf_parse(void __user *btf_data, u32 btf_data_size,
+static struct btf *btf_parse(bpfptr_t btf_data, u32 btf_data_size,
 			     u32 log_level, char __user *log_ubuf, u32 log_size)
 {
 	struct btf_verifier_env *env = NULL;
@@ -4306,7 +4306,7 @@ static struct btf *btf_parse(void __user *btf_data, u32 btf_data_size,
 	btf->data = data;
 	btf->data_size = btf_data_size;
 
-	if (copy_from_user(data, btf_data, btf_data_size)) {
+	if (copy_from_bpfptr(data, btf_data, btf_data_size)) {
 		err = -EFAULT;
 		goto errout;
 	}
@@ -5780,12 +5780,12 @@ static int __btf_new_fd(struct btf *btf)
 	return anon_inode_getfd("btf", &btf_fops, btf, O_RDONLY | O_CLOEXEC);
 }
 
-int btf_new_fd(const union bpf_attr *attr)
+int btf_new_fd(const union bpf_attr *attr, bpfptr_t uattr)
 {
 	struct btf *btf;
 	int ret;
 
-	btf = btf_parse(u64_to_user_ptr(attr->btf),
+	btf = btf_parse(make_bpfptr(attr->btf, uattr.is_kernel),
 			attr->btf_size, attr->btf_log_level,
 			u64_to_user_ptr(attr->btf_log_buf),
 			attr->btf_log_size);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e918839b76fd..f5e2511c504e 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3830,7 +3830,7 @@ static int bpf_obj_get_info_by_fd(const union bpf_attr *attr,
 
 #define BPF_BTF_LOAD_LAST_FIELD btf_log_level
 
-static int bpf_btf_load(const union bpf_attr *attr)
+static int bpf_btf_load(const union bpf_attr *attr, bpfptr_t uattr)
 {
 	if (CHECK_ATTR(BPF_BTF_LOAD))
 		return -EINVAL;
@@ -3838,7 +3838,7 @@ static int bpf_btf_load(const union bpf_attr *attr)
 	if (!bpf_capable())
 		return -EPERM;
 
-	return btf_new_fd(attr);
+	return btf_new_fd(attr, uattr);
 }
 
 #define BPF_BTF_GET_FD_BY_ID_LAST_FIELD btf_id
@@ -4459,7 +4459,7 @@ static int __sys_bpf(int cmd, bpfptr_t uattr, unsigned int size)
 		err = bpf_raw_tracepoint_open(&attr);
 		break;
 	case BPF_BTF_LOAD:
-		err = bpf_btf_load(&attr);
+		err = bpf_btf_load(&attr, uattr);
 		break;
 	case BPF_BTF_GET_FD_BY_ID:
 		err = bpf_btf_get_fd_by_id(&attr);
@@ -4540,6 +4540,7 @@ BPF_CALL_3(bpf_sys_bpf, int, cmd, void *, attr, u32, attr_size)
 	case BPF_MAP_UPDATE_ELEM:
 	case BPF_MAP_FREEZE:
 	case BPF_PROG_LOAD:
+	case BPF_BTF_LOAD:
 		break;
 	default:
 		return -EINVAL;
-- 
2.30.2

