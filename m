Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C76362D52
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 05:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235589AbhDQDeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 23:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235625AbhDQDdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 23:33:52 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BADC06138F;
        Fri, 16 Apr 2021 20:32:42 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d124so19546497pfa.13;
        Fri, 16 Apr 2021 20:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wxVfwTNvoUrkxrFUgiKMIayPbwYj2MJfbAckJnsV92o=;
        b=cPYCnoR0Iwz25EnFRmpQJfP/kStB1cWMRjKoWmYaodR6YlJXVqE65R+bTc8FdQZKHm
         EcMkvlhE0ugu/6aM7+jZ43aEz3p+piZsgrrQP1W8UyyQopCU8Sn7mzz8N2aMcZiDjZLe
         xRdql3s46UfYcxyvKk7l6eSkYtsVJLwBewqjb1ahnAGfQjqtzSKq30Ons14tUYqL9kQI
         Oy9vhWDmZu/bU9BahvZCJWyuF5VLGQagML8TmB5cSrzvucAVE7g151ttkQU4F3yMMaEk
         4saseaO5pgjXwmZGouWQb7SNaDAIqBzJVGO/Z6/gjaecOd1ClT9lMoaXaBtSv8xTDLIx
         CK1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wxVfwTNvoUrkxrFUgiKMIayPbwYj2MJfbAckJnsV92o=;
        b=XIfq3M7pIEQYaOsysCVjQ1Kaq2F8VFrgIdmweUJHLj3B7gBh1x3f8V+sL5y5pGdiqs
         mFJChzf3PbO8tWuAs2iBd7rn0ryQqzJ/nmjAyYF+T99KBkd/YhoqOzlCwAvgdqoz/DUv
         h+6vlTPYlWaRQp9OBtVyg0tN7Kvq/scKbyfDzD/SM1CxkgcM4o0s6cdNlWXemm0aB+xG
         Ihgo8m9zUVaMNf0egn1hFSaBSsq2x379cJ+EBssRv4+E6gfbnI8QJisUfkgLDJTsjs2T
         tmWP4DWFWkfgJDiUg3fQNlQdCAhwFhz7PdJwJpYLjoxBi3tO/kgxzSdT8q2GvdONrpq7
         LmQA==
X-Gm-Message-State: AOAM530jT/QXFuL5Ya4HPJFGkSD5mXNHnv3lbMo88hkUEQclTvQLMUB6
        mCW8Q0+eMtHr2KvT0iuXaYvl/EYFCfw=
X-Google-Smtp-Source: ABdhPJwYPLbTE5+pvBaXxunt3tvJCgPhwska/CjhQVWo4Q4jkhepZQmIIIFPZyswin9bVfkOqyj2Qg==
X-Received: by 2002:a63:1a47:: with SMTP id a7mr1840553pgm.437.1618630362337;
        Fri, 16 Apr 2021 20:32:42 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([163.114.132.7])
        by smtp.gmail.com with ESMTPSA id h1sm6069870pgv.88.2021.04.16.20.32.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Apr 2021 20:32:41 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 11/15] bpf: Add bpf_sys_close() helper.
Date:   Fri, 16 Apr 2021 20:32:20 -0700
Message-Id: <20210417033224.8063-12-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
References: <20210417033224.8063-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

Add bpf_sys_close() helper to be used by the syscall/loader program to close
intermediate FDs and other cleanup.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 include/uapi/linux/bpf.h       |  7 +++++++
 kernel/bpf/syscall.c           | 14 ++++++++++++++
 tools/include/uapi/linux/bpf.h |  7 +++++++
 3 files changed, 28 insertions(+)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 47c4b21a51b6..2251e7894799 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -4728,6 +4728,12 @@ union bpf_attr {
  * 		If btf_fd is zero look for the name in vmlinux BTF and kernel module BTFs.
  * 	Return
  * 		Return btf_id and store module's BTF FD into attach_btf_obj_fd.
+ *
+ * long bpf_sys_close(u32 fd)
+ * 	Description
+ * 		Execute close syscall for given FD.
+ * 	Return
+ * 		A syscall result.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -4897,6 +4903,7 @@ union bpf_attr {
 	FN(for_each_map_elem),		\
 	FN(sys_bpf),			\
 	FN(btf_find_by_name_kind),	\
+	FN(sys_close),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 6d4d9925c0ec..822b00908c58 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -4557,6 +4557,18 @@ const struct bpf_func_proto bpf_sys_bpf_proto = {
 	.arg3_type	= ARG_CONST_SIZE,
 };
 
+BPF_CALL_1(bpf_sys_close, u32, fd)
+{
+	return close_fd(fd);
+}
+
+const struct bpf_func_proto bpf_sys_close_proto = {
+	.func		= bpf_sys_close,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+	.arg1_type	= ARG_ANYTHING,
+};
+
 static const struct bpf_func_proto *
 syscall_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -4565,6 +4577,8 @@ syscall_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_sys_bpf_proto;
 	case BPF_FUNC_btf_find_by_name_kind:
 		return &bpf_btf_find_by_name_kind_proto;
+	case BPF_FUNC_sys_close:
+		return &bpf_sys_close_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 47c4b21a51b6..2251e7894799 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -4728,6 +4728,12 @@ union bpf_attr {
  * 		If btf_fd is zero look for the name in vmlinux BTF and kernel module BTFs.
  * 	Return
  * 		Return btf_id and store module's BTF FD into attach_btf_obj_fd.
+ *
+ * long bpf_sys_close(u32 fd)
+ * 	Description
+ * 		Execute close syscall for given FD.
+ * 	Return
+ * 		A syscall result.
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -4897,6 +4903,7 @@ union bpf_attr {
 	FN(for_each_map_elem),		\
 	FN(sys_bpf),			\
 	FN(btf_find_by_name_kind),	\
+	FN(sys_close),			\
 	/* */
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
-- 
2.30.2

