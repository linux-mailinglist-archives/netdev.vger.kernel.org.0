Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B11DA83D
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 11:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405461AbfJQJ0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 05:26:47 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37348 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733031AbfJQJ0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 05:26:47 -0400
Received: by mail-pg1-f194.google.com with SMTP id p1so1005266pgi.4
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 02:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=281a7veJ+DulLeZQChfjoTTuZ6KmNJS1vFd2OvpkIkw=;
        b=AvdaF2GcCqiNAYUdI6BKRaNVE4Q4NQbVEIIsNcY7ZOcf8mDUToATq5EKGbzJxb1G6R
         6LELqMFB72ZCsAJniyFWw5UCCSExXCTiXAqzOfMMOZxs6lrQ+RABdRV38IGII+1DiXDF
         RNI3VZPEUqmyIAHxTGI49Bwd2cGyy8yKmtqnMWBFG8/5ye90YeHx21yA9eX2Ji01IcLD
         gTgtrF1OWzJdJ7X2aOtxqDXKWymrZ0Z+qFFKpeAN/kTtjgo++QTbE9G9Q8KsP3pGR07b
         GCNlSRV4l+3iPr+MFEbRv36McOsvxv2TF8KmKAlMPNyn0wFxPtojgU5NjOZlOGj/2WXp
         Kxpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=281a7veJ+DulLeZQChfjoTTuZ6KmNJS1vFd2OvpkIkw=;
        b=tQxm2ql6fOelobdmdFJieMdqrcNvXOH4tXq9PkOUdVAVmDQqbMuWW4qGKdLBSNXk8O
         vfLBNhcGHe9WIwP/+EauskqzNcEX0ZCJuPXnCk8OiD/XiCvE3RIKF6T9Egd5XLEaaiRm
         +Px6KEb/udDUpxFp60CZCVKClQUpSLruD2IUFdRlIMNX8pOrxE+yRvfRMlEGbPN9Moy9
         5IGlh/3ByLUzPPhdLDEsTK1WrAeK/qDtD0fxxP8nSAXu5wt2ARpuC4EJ7kUZOBzF9jys
         bi9UXCo1M4PL+7hARF+DOf224nSNUE7BIT0umU+9TvWlwDpzB4Tv4RovgAmMueACrTfG
         5W2w==
X-Gm-Message-State: APjAAAUzA9YPsnGfQor8pFG1frTqrhP04iSrVEjVmmORikFdC5j31YpS
        xOwSkH31QrAPYJZxWE9rV0NBsNCX
X-Google-Smtp-Source: APXvYqyDdGe0S74qSiHJW1hWY3/eSxokpDbtAU0aBEu+r3kzyy6a3rsqza89Z5zlszIGoaOH5rO3yw==
X-Received: by 2002:a17:90a:9f94:: with SMTP id o20mr3154127pjp.76.1571304406329;
        Thu, 17 Oct 2019 02:26:46 -0700 (PDT)
Received: from ubuntu-18.04-x8664 ([128.1.49.85])
        by smtp.gmail.com with ESMTPSA id f128sm1871506pfg.143.2019.10.17.02.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 02:26:45 -0700 (PDT)
From:   Zwb <ethercflow@gmail.com>
To:     netdev@vger.kernel.org
Cc:     yhs@fb.com, Zwb <ethercflow@gmail.com>
Subject: [PATCH bpf-next] bpf: add new helper fd2path for mapping a file descriptor to a pathname
Date:   Thu, 17 Oct 2019 05:26:31 -0400
Message-Id: <20191017092631.3739-1-ethercflow@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When people want to identify which file system files are being opened,
read, and written to, they can use this helper with file descriptor as
input to achieve this goal. Other pseudo filesystems are also supported.

Signed-off-by: Zwb <ethercflow@gmail.com>
---
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       |  1 +
 kernel/bpf/core.c              |  1 +
 kernel/bpf/helpers.c           | 39 ++++++++++++++++++++++++++++++++++
 kernel/trace/bpf_trace.c       |  2 ++
 tools/include/uapi/linux/bpf.h |  1 +
 6 files changed, 45 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 282e28bf41ec..c0a710cf2c88 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1055,6 +1055,7 @@ extern const struct bpf_func_proto bpf_get_local_storage_proto;
 extern const struct bpf_func_proto bpf_strtol_proto;
 extern const struct bpf_func_proto bpf_strtoul_proto;
 extern const struct bpf_func_proto bpf_tcp_sock_proto;
+extern const struct bpf_func_proto bpf_fd2path_proto;
 
 /* Shared helpers among cBPF and eBPF. */
 void bpf_user_rnd_init_once(void);
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index a65c3b0c6935..a4a5d432e572 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2769,6 +2769,7 @@ union bpf_attr {
 	FN(get_current_pid_tgid),	\
 	FN(get_current_uid_gid),	\
 	FN(get_current_comm),		\
+	FN(fd2path),			\
 	FN(get_cgroup_classid),		\
 	FN(skb_vlan_push),		\
 	FN(skb_vlan_pop),		\
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 66088a9e9b9e..349a8b1be232 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2042,6 +2042,7 @@ const struct bpf_func_proto bpf_get_current_uid_gid_proto __weak;
 const struct bpf_func_proto bpf_get_current_comm_proto __weak;
 const struct bpf_func_proto bpf_get_current_cgroup_id_proto __weak;
 const struct bpf_func_proto bpf_get_local_storage_proto __weak;
+const struct bpf_func_proto bpf_fd2path_proto __weak;
 
 const struct bpf_func_proto * __weak bpf_get_trace_printk_proto(void)
 {
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 5e28718928ca..0832536c7ddb 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -487,3 +487,42 @@ const struct bpf_func_proto bpf_strtoul_proto = {
 	.arg4_type	= ARG_PTR_TO_LONG,
 };
 #endif
+
+BPF_CALL_3(bpf_fd2path, char *, dst, u32, size, int, fd)
+{
+	struct fd f;
+	int ret;
+	char *p;
+
+	ret = security_locked_down(LOCKDOWN_BPF_READ);
+	if (ret < 0)
+		goto out;
+
+	f = fdget_raw(fd);
+	if (!f.file)
+		goto out;
+
+	p = d_path(&f.file->f_path, dst, size);
+	if (IS_ERR_OR_NULL(p))
+		ret = PTR_ERR(p);
+	else {
+		ret = strlen(p);
+		memmove(dst, p, ret);
+		dst[ret] = 0;
+	}
+
+	if (unlikely(ret < 0))
+out:
+		memset(dst, '0', size);
+
+	return ret;
+}
+
+const struct bpf_func_proto bpf_fd2path_proto = {
+	.func       = bpf_fd2path,
+	.gpl_only   = true,
+	.ret_type   = RET_INTEGER,
+	.arg1_type  = ARG_PTR_TO_UNINIT_MEM,
+	.arg2_type  = ARG_CONST_SIZE,
+	.arg3_type  = ARG_ANYTHING,
+};
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 44bd08f2443b..0ca7fdefb8e5 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -735,6 +735,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 #endif
 	case BPF_FUNC_send_signal:
 		return &bpf_send_signal_proto;
+	case BPF_FUNC_fd2path:
+		return &bpf_fd2path_proto;
 	default:
 		return NULL;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a65c3b0c6935..a4a5d432e572 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2769,6 +2769,7 @@ union bpf_attr {
 	FN(get_current_pid_tgid),	\
 	FN(get_current_uid_gid),	\
 	FN(get_current_comm),		\
+	FN(fd2path),			\
 	FN(get_cgroup_classid),		\
 	FN(skb_vlan_push),		\
 	FN(skb_vlan_pop),		\
-- 
2.17.1

