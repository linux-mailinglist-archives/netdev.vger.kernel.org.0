Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2852F1D1F08
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390631AbgEMTY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732218AbgEMTYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:24:54 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E17C061A0C;
        Wed, 13 May 2020 12:24:53 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id b18so887464ilf.2;
        Wed, 13 May 2020 12:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=mi/KO7g/LWcVX05cFdlNrLjoY2HGc40PsFiHws1E9sA=;
        b=DruQPF0JjEmVqFeVxupJk2RM5cSiJHZjGFxsd9/IJN5hrHNLu8Y6ngoPWPP91g039t
         JtcTuN/p/kdICzj1TS/pfNdmMhCREvmWEiFCADrf4wiQxDvHggwzG2RBylQiDjzsrca+
         6WB12K1yAJqHbVmJuWLMmr54yrrHWTK4iqQwczPDKv/G6qC0me9TUnz8qBj/OR8Yp/w+
         wSz1PddPGrslRlZv7P2On539RhQOZdHxUvrGySO4UC1CJB6GgvG60mWVbmRMOW9P8h2r
         pbj7fxCh/im/7irKf4SU+sEtMBYPCbLs7kRuv12ES7LIXXuSV5rUTIluzTrunK8A/gW1
         0CNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=mi/KO7g/LWcVX05cFdlNrLjoY2HGc40PsFiHws1E9sA=;
        b=KKfTRhgcKVowY5yKM7PTehNEm1iDYgDm4sNzwu0KRkIfNwZeWR3/+ikng/xUOVXGPM
         i2HFfmZm37+nsZb4/GYNpI9dB4wsUD8vkJyixRUbMPFar93rofi+e+SC2eqs0xIhP1Ln
         8CIbjbxmIGnyFcKVsLKpEhw2t/qXN3kzp163ZkYh1EFNf5JrYnCSygSgGEn6mq0Ynf0f
         6HOlslnIpfPtdizmb/3+VEnBPhxWYhNoEag/oPTojCX5EVE+tZSCmL5yfOdRuvCGTJIt
         VOrXZOXXfQ7B1WFNU5ms4lar0G9EEGmgMmda7CodUjLMW46IDnJSCX9eck41cbyPShn6
         gAjg==
X-Gm-Message-State: AOAM531UwRLPBkmD2hlLMZogkPWq+tAhVqM3w9iC576jpYW+g6nfK3Fv
        MWpY24CkJtXwCmsP22It9O0=
X-Google-Smtp-Source: ABdhPJwHyf9o7/17gnOs6i7g6564uiB3bwvw+ODvqEbV6/f1bKH9y64sY4AUThdzcc7mtBJcrzCoRw==
X-Received: by 2002:a92:d4c4:: with SMTP id o4mr1075683ilm.38.1589397892743;
        Wed, 13 May 2020 12:24:52 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id m17sm167114ilh.51.2020.05.13.12.24.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 May 2020 12:24:52 -0700 (PDT)
Subject: [bpf-next PATCH 2/3] bpf: sk_msg helpers for probe_* and
 *current_task*
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     lmb@cloudflare.com, bpf@vger.kernel.org, john.fastabend@gmail.com,
        jakub@cloudflare.com, netdev@vger.kernel.org
Date:   Wed, 13 May 2020 12:24:39 -0700
Message-ID: <158939787911.17281.887645911866087465.stgit@john-Precision-5820-Tower>
In-Reply-To: <158939776371.17281.8506900883049313932.stgit@john-Precision-5820-Tower>
References: <158939776371.17281.8506900883049313932.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Often it is useful when applying policy to know something about the
task. If the administrator has CAP_SYS_ADMIN rights then they can
use kprobe + sk_msg and link the two programs together to accomplish
this. However, this is a bit clunky and also means we have to call
sk_msg program and kprobe program when we could just use a single
program and avoid passing metadata through sk_msg/skb, socket, etc.

To accomplish this add probe_* helpers to sk_msg programs guarded
by a CAP_SYS_ADMIN check. New supported helpers are the following,

 BPF_FUNC_get_current_task
 BPF_FUNC_current_task_under_cgroup
 BPF_FUNC_probe_read_user
 BPF_FUNC_probe_read_kernel
 BPF_FUNC_probe_read
 BPF_FUNC_probe_read_user_str
 BPF_FUNC_probe_read_kernel_str
 BPF_FUNC_probe_read_str

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 kernel/trace/bpf_trace.c |   16 ++++++++--------
 net/core/filter.c        |   34 ++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index d961428..abe6721 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -147,7 +147,7 @@ BPF_CALL_3(bpf_probe_read_user, void *, dst, u32, size,
 	return ret;
 }
 
-static const struct bpf_func_proto bpf_probe_read_user_proto = {
+const struct bpf_func_proto bpf_probe_read_user_proto = {
 	.func		= bpf_probe_read_user,
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
@@ -167,7 +167,7 @@ BPF_CALL_3(bpf_probe_read_user_str, void *, dst, u32, size,
 	return ret;
 }
 
-static const struct bpf_func_proto bpf_probe_read_user_str_proto = {
+const struct bpf_func_proto bpf_probe_read_user_str_proto = {
 	.func		= bpf_probe_read_user_str,
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
@@ -198,7 +198,7 @@ BPF_CALL_3(bpf_probe_read_kernel, void *, dst, u32, size,
 	return bpf_probe_read_kernel_common(dst, size, unsafe_ptr, false);
 }
 
-static const struct bpf_func_proto bpf_probe_read_kernel_proto = {
+const struct bpf_func_proto bpf_probe_read_kernel_proto = {
 	.func		= bpf_probe_read_kernel,
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
@@ -213,7 +213,7 @@ BPF_CALL_3(bpf_probe_read_compat, void *, dst, u32, size,
 	return bpf_probe_read_kernel_common(dst, size, unsafe_ptr, true);
 }
 
-static const struct bpf_func_proto bpf_probe_read_compat_proto = {
+const struct bpf_func_proto bpf_probe_read_compat_proto = {
 	.func		= bpf_probe_read_compat,
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
@@ -253,7 +253,7 @@ BPF_CALL_3(bpf_probe_read_kernel_str, void *, dst, u32, size,
 	return bpf_probe_read_kernel_str_common(dst, size, unsafe_ptr, false);
 }
 
-static const struct bpf_func_proto bpf_probe_read_kernel_str_proto = {
+const struct bpf_func_proto bpf_probe_read_kernel_str_proto = {
 	.func		= bpf_probe_read_kernel_str,
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
@@ -268,7 +268,7 @@ BPF_CALL_3(bpf_probe_read_compat_str, void *, dst, u32, size,
 	return bpf_probe_read_kernel_str_common(dst, size, unsafe_ptr, true);
 }
 
-static const struct bpf_func_proto bpf_probe_read_compat_str_proto = {
+const struct bpf_func_proto bpf_probe_read_compat_str_proto = {
 	.func		= bpf_probe_read_compat_str,
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
@@ -874,7 +874,7 @@ BPF_CALL_0(bpf_get_current_task)
 	return (long) current;
 }
 
-static const struct bpf_func_proto bpf_get_current_task_proto = {
+const struct bpf_func_proto bpf_get_current_task_proto = {
 	.func		= bpf_get_current_task,
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
@@ -895,7 +895,7 @@ BPF_CALL_2(bpf_current_task_under_cgroup, struct bpf_map *, map, u32, idx)
 	return task_under_cgroup_hierarchy(current, cgrp);
 }
 
-static const struct bpf_func_proto bpf_current_task_under_cgroup_proto = {
+const struct bpf_func_proto bpf_current_task_under_cgroup_proto = {
 	.func           = bpf_current_task_under_cgroup,
 	.gpl_only       = false,
 	.ret_type       = RET_INTEGER,
diff --git a/net/core/filter.c b/net/core/filter.c
index 45b4a16..d1c4739 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6362,6 +6362,15 @@ sock_ops_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 const struct bpf_func_proto bpf_msg_redirect_map_proto __weak;
 const struct bpf_func_proto bpf_msg_redirect_hash_proto __weak;
 
+const struct bpf_func_proto bpf_current_task_under_cgroup_proto __weak;
+const struct bpf_func_proto bpf_get_current_task_proto __weak;
+const struct bpf_func_proto bpf_probe_read_user_proto __weak;
+const struct bpf_func_proto bpf_probe_read_user_str_proto __weak;
+const struct bpf_func_proto bpf_probe_read_kernel_proto __weak;
+const struct bpf_func_proto bpf_probe_read_kernel_str_proto __weak;
+const struct bpf_func_proto bpf_probe_read_compat_proto __weak;
+const struct bpf_func_proto bpf_probe_read_compat_str_proto __weak;
+
 static const struct bpf_func_proto *
 sk_msg_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 {
@@ -6397,6 +6406,31 @@ sk_msg_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_get_cgroup_classid_curr_proto;
 #endif
 	default:
+		break;
+	}
+
+	if (!capable(CAP_SYS_ADMIN))
+		return bpf_base_func_proto(func_id);
+
+	/* All helpers below are for CAP_SYS_ADMIN only */
+	switch (func_id) {
+	case BPF_FUNC_get_current_task:
+		return &bpf_get_current_task_proto;
+	case BPF_FUNC_current_task_under_cgroup:
+		return &bpf_current_task_under_cgroup_proto;
+	case BPF_FUNC_probe_read_user:
+		return &bpf_probe_read_user_proto;
+	case BPF_FUNC_probe_read_kernel:
+		return &bpf_probe_read_kernel_proto;
+	case BPF_FUNC_probe_read:
+		return &bpf_probe_read_compat_proto;
+	case BPF_FUNC_probe_read_user_str:
+		return &bpf_probe_read_user_str_proto;
+	case BPF_FUNC_probe_read_kernel_str:
+		return &bpf_probe_read_kernel_str_proto;
+	case BPF_FUNC_probe_read_str:
+		return &bpf_probe_read_compat_str_proto;
+	default:
 		return bpf_base_func_proto(func_id);
 	}
 }

