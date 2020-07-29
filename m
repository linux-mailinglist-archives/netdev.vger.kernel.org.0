Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888142316C6
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730788AbgG2AbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730609AbgG2AbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:31:07 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E79C0619D2
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 17:31:07 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id t7so27393539ybk.2
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 17:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Z07j8LTcaioG0qCkJk70fNDVB7GWknR8AKhYdzK6Syw=;
        b=ANjIMCDYYRjGWoOZ9Y+SZbw2ZtJMkx1qg3zG3ScssDaPUO8rC5xdMGbfGWLZqtkJcf
         JlxhfVvu5+XSfM+/18wPHjDc19xe7NcQJV7zCZZ3foyqHgRRlisT7u1ugjIwkyuJKx0U
         +TqCHdJRMKT2+pk7oxNF5wS1ykn9RtqNJeeXiVrBqLRTSdlVK5cZ7VdGAgdjHmOa+cAu
         5l99lxDxNUfqciKUJMQ1QDq7T1AKIxNvOEDIaD844ixIK4HLjhNGalUgqmbu0KCYSBs2
         hCpNgRmIUiWRT3e7RRDYSOmS5dP7PEeMa9v9mtiWfamoCrMFGGoExY99Rq+cwakfroe2
         BC4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Z07j8LTcaioG0qCkJk70fNDVB7GWknR8AKhYdzK6Syw=;
        b=Ez9goxlK6EkoHer+sds1wPYPCGtgnOgnt4a2SHmoqdoFHdZXFYvkCw3mD85wx+gb3B
         aJNlyO3vcT+GPCaypcIdDi8/sxXZ4jDKsph3SLbvsRvFVBMPpe9g0yFjFaHK4fiXNz/7
         O6FyWUvZebudWxIQrtWINTflACY66z8MM8KGtzGd0jWzoQbv7NX+mkuQIsGcv5FepV+B
         ruG79psKba1R41PxBjEZOpTubnwlD/aQEQ2nBRA30qQ7DNU/wK/gNCByl6MLPFHE5PBA
         JqBWwuPIP1VbdeEvTwwU70Pc3ka7pox1IpZYcTjlViBZPt3Adv5VXDYYXn+cbbvgQYUG
         PcbA==
X-Gm-Message-State: AOAM530UwVLHSAZT8FX3vYVDEFBrDigMU6r6cK9tjdN5pUNXKv7wTuXQ
        N1h3jV12z6gfAarKAFJi/P/3BfvbhkApSoyUHywBVCoTC0adOpLla1+KFOGEZZUvUUEHuKL/Gc0
        st0oSU/hXD8YE+oHj8opYi2YsMkU+kbSgK6k7DMxOt9ZHOrJIVrnnPg==
X-Google-Smtp-Source: ABdhPJyZfPHk34oocJNE5G3TAGLIFR03/Mby83zy7tckMohqxJ0NmL4uIXP80JNbfb6+sUuf6HXUFkQ=
X-Received: by 2002:a25:c615:: with SMTP id k21mr43792524ybf.379.1595982666554;
 Tue, 28 Jul 2020 17:31:06 -0700 (PDT)
Date:   Tue, 28 Jul 2020 17:31:03 -0700
Message-Id: <20200729003104.1280813-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.163.g6104cc2f0b6-goog
Subject: [PATCH bpf-next 1/2] bpf: expose socket storage to BPF_PROG_TYPE_CGROUP_SOCK
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This lets us use socket storage from the following hooks:
* BPF_CGROUP_INET_SOCK_CREATE
* BPF_CGROUP_INET_SOCK_RELEASE
* BPF_CGROUP_INET4_POST_BIND
* BPF_CGROUP_INET6_POST_BIND

Using existing 'bpf_sk_storage_get_proto' doesn't work because
second argument is ARG_PTR_TO_SOCKET. Even though
BPF_PROG_TYPE_CGROUP_SOCK hooks operate on 'struct bpf_sock',
the verifier still considers it as a PTR_TO_CTX.
That's why I'm adding another 'bpf_sk_storage_get_cg_sock_proto'
definition strictly for BPF_PROG_TYPE_CGROUP_SOCK which accepts
ARG_PTR_TO_CTX which is really 'struct sock' for this program type.

Cc: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 net/core/bpf_sk_storage.c | 10 ++++++++++
 net/core/filter.c         |  3 +++
 2 files changed, 13 insertions(+)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index eafcd15e7dfd..d3377c90a291 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -944,6 +944,16 @@ const struct bpf_func_proto bpf_sk_storage_get_proto = {
 	.arg4_type	= ARG_ANYTHING,
 };
 
+const struct bpf_func_proto bpf_sk_storage_get_cg_sock_proto = {
+	.func		= bpf_sk_storage_get,
+	.gpl_only	= false,
+	.ret_type	= RET_PTR_TO_MAP_VALUE_OR_NULL,
+	.arg1_type	= ARG_CONST_MAP_PTR,
+	.arg2_type	= ARG_PTR_TO_CTX, /* context is 'struct sock' */
+	.arg3_type	= ARG_PTR_TO_MAP_VALUE_OR_NULL,
+	.arg4_type	= ARG_ANYTHING,
+};
+
 const struct bpf_func_proto bpf_sk_storage_delete_proto = {
 	.func		= bpf_sk_storage_delete,
 	.gpl_only	= false,
diff --git a/net/core/filter.c b/net/core/filter.c
index 29e3455122f7..7124f0fe6974 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6187,6 +6187,7 @@ bool bpf_helper_changes_pkt_data(void *func)
 }
 
 const struct bpf_func_proto bpf_event_output_data_proto __weak;
+const struct bpf_func_proto bpf_sk_storage_get_cg_sock_proto __weak;
 
 static const struct bpf_func_proto *
 sock_filter_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
@@ -6219,6 +6220,8 @@ sock_filter_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_get_cgroup_classid:
 		return &bpf_get_cgroup_classid_curr_proto;
 #endif
+	case BPF_FUNC_sk_storage_get:
+		return &bpf_sk_storage_get_cg_sock_proto;
 	default:
 		return bpf_base_func_proto(func_id);
 	}
-- 
2.28.0.163.g6104cc2f0b6-goog

