Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16871DCFFD
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 16:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbgEUOfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 10:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgEUOfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 10:35:30 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0831C061A0E;
        Thu, 21 May 2020 07:35:29 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z26so3390695pfk.12;
        Thu, 21 May 2020 07:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=7oEuv98mMfSNLDaRRN50X589R2qbSMXWVUMi+Xmu3Jg=;
        b=svX7SXpBaKgTzPQPO1PMchWTPPrei2ImIKYKyDZi3D1qZ2aGOdwMGftAlJCa7wU1zN
         6F31W9DnQAbrb7cxtpm+DWXC1i+eAm61B9EtsBBC22rnBQhnf71zQfNDSTRLWcl7gQ9c
         XN3LB6/mdZDi3YdoOJmUOuXUb++6W1dDPzIAhjTCZqmU8UhPxEQ3E98mTK8L2zdvy87g
         JmA5BlzdKz5AgKUJ0QpEwttZLnQ8nEApVZN9crrbLMfk/b+MVBscEplFVNX/S72PBFi8
         iUvDj8q8US1bSEnS6G4wAU3E0DpKml6Zpx5N6TGsWZKi3NG8UdbFIV6v1/Q/uKNH0nwE
         DhTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=7oEuv98mMfSNLDaRRN50X589R2qbSMXWVUMi+Xmu3Jg=;
        b=UgVphP9PS/pOTFc/mVR4aD3Dt1b1clbAfKYaATKEhNjIDxBSn3XieO3swXcb00KpQv
         HjdV0lRfNnL5l+bioB7RFyGy8ccK7CN9IQ7VYm0X3a4JJ0Ky4YgQ+JUhAFnD5nZqHVBz
         5lXEw7yYaQF9RCUTbTrFviKtsrIOZJlCr3++y/Xar1+V/iZQg4jRjkMYrgHxwA90ScEW
         TB0QtPQ47O9PIyQMN0v0LhMm4FUF507dBBHsuoD4+nNdL7+hTWOVz3PMGABNw1trFhLC
         kKgaQlIBYbCiLLyzzO8pDsfHnlhFw0Rxh0nr3CJUG1m9USzZXVTiWqTIvhn4HOGgASUc
         DhSg==
X-Gm-Message-State: AOAM5314f4c+t27N4SpT9EcyN1Ll8LcIuOWR+m6E+V6bvK5F/uyElNCL
        6ldmLUp2wS1Yu/mZzls2dkQ=
X-Google-Smtp-Source: ABdhPJw4eS0oefPKlBWOUqNF92seoagKOlGeubKMjGIDaNWcgBNaCZxO4/nb1RU2+7PTP/9uBW4Lzw==
X-Received: by 2002:a62:2ad2:: with SMTP id q201mr9622540pfq.323.1590071729385;
        Thu, 21 May 2020 07:35:29 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z21sm4752920pfr.77.2020.05.21.07.35.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 May 2020 07:35:28 -0700 (PDT)
Subject: [bpf-next PATCH v3 2/5] bpf: extend bpf_base_func_proto helpers
 with probe_* and *current_task*
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, ast@kernel.org, daniel@iogearbox.net
Cc:     lmb@cloudflare.com, bpf@vger.kernel.org, john.fastabend@gmail.com,
        jakub@cloudflare.com, netdev@vger.kernel.org
Date:   Thu, 21 May 2020 07:35:14 -0700
Message-ID: <159007171379.10695.9196150566049925996.stgit@john-Precision-5820-Tower>
In-Reply-To: <159007153289.10695.12380087259405383510.stgit@john-Precision-5820-Tower>
References: <159007153289.10695.12380087259405383510.stgit@john-Precision-5820-Tower>
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
use kprobe + networking hook and link the two programs together to
accomplish this. However, this is a bit clunky and also means we have
to call both the network program and kprobe program when we could just
use a single program and avoid passing metadata through sk_msg/skb->cb,
socket, maps, etc.

To accomplish this add probe_* helpers to bpf_base_func_proto programs
guarded by a perfmon_capable() check. New supported helpers are the
following,

 BPF_FUNC_get_current_task
 BPF_FUNC_current_task_under_cgroup
 BPF_FUNC_probe_read_user
 BPF_FUNC_probe_read_kernel
 BPF_FUNC_probe_read_user_str
 BPF_FUNC_probe_read_kernel_str

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/helpers.c     |   27 +++++++++++++++++++++++++++
 kernel/trace/bpf_trace.c |   16 ++++++++--------
 2 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 886949f..ee992dd 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -601,6 +601,13 @@ const struct bpf_func_proto bpf_event_output_data_proto =  {
 	.arg5_type      = ARG_CONST_SIZE_OR_ZERO,
 };
 
+const struct bpf_func_proto bpf_current_task_under_cgroup_proto __weak;
+const struct bpf_func_proto bpf_get_current_task_proto __weak;
+const struct bpf_func_proto bpf_probe_read_user_proto __weak;
+const struct bpf_func_proto bpf_probe_read_user_str_proto __weak;
+const struct bpf_func_proto bpf_probe_read_kernel_proto __weak;
+const struct bpf_func_proto bpf_probe_read_kernel_str_proto __weak;
+
 const struct bpf_func_proto *
 bpf_base_func_proto(enum bpf_func_id func_id)
 {
@@ -648,6 +655,26 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 	case BPF_FUNC_jiffies64:
 		return &bpf_jiffies64_proto;
 	default:
+		break;
+	}
+
+	if (!perfmon_capable())
+		return NULL;
+
+	switch (func_id) {
+	case BPF_FUNC_get_current_task:
+		return &bpf_get_current_task_proto;
+	case BPF_FUNC_current_task_under_cgroup:
+		return &bpf_current_task_under_cgroup_proto;
+	case BPF_FUNC_probe_read_user:
+		return &bpf_probe_read_user_proto;
+	case BPF_FUNC_probe_read_kernel:
+		return &bpf_probe_read_kernel_proto;
+	case BPF_FUNC_probe_read_user_str:
+		return &bpf_probe_read_user_str_proto;
+	case BPF_FUNC_probe_read_kernel_str:
+		return &bpf_probe_read_kernel_str_proto;
+	default:
 		return NULL;
 	}
 }
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 9531f54..6fabbc4 100644
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
@@ -907,7 +907,7 @@ BPF_CALL_0(bpf_get_current_task)
 	return (long) current;
 }
 
-static const struct bpf_func_proto bpf_get_current_task_proto = {
+const struct bpf_func_proto bpf_get_current_task_proto = {
 	.func		= bpf_get_current_task,
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
@@ -928,7 +928,7 @@ BPF_CALL_2(bpf_current_task_under_cgroup, struct bpf_map *, map, u32, idx)
 	return task_under_cgroup_hierarchy(current, cgrp);
 }
 
-static const struct bpf_func_proto bpf_current_task_under_cgroup_proto = {
+const struct bpf_func_proto bpf_current_task_under_cgroup_proto = {
 	.func           = bpf_current_task_under_cgroup,
 	.gpl_only       = false,
 	.ret_type       = RET_INTEGER,

