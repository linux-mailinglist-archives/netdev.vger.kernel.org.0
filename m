Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C702D1DDEB5
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 06:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgEVEYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 00:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbgEVEYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 00:24:40 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EB22C061A0E;
        Thu, 21 May 2020 21:24:40 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y198so4629806pfb.4;
        Thu, 21 May 2020 21:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=8be0dtX8Bx/Brc6sNGJ5yvfgieIe1YrD5dF5nmEn7pI=;
        b=cT1HgshI4I0n0b+SflxNfDkbf3zlrNCPRS4X8hXeDgqoYfdLwjOV3W1MWt1xlFmxrA
         m7iHWHlT+//ig2t27WQ7HdDP97+P5IdCjyMTNb9sXqx5q1O2KA40Q68cs3QbciM8BFXw
         TwOKaEDCQMxcDCr0SKpeEvRIEvB8J8mwyQrwix0/cHyewP721JR3UBUKdDt88u0QnRaO
         Y8FECRUQlDk8SNX+ybqNsrnpJYCy6+lqmX8h0RAX7sDC24Moj5K654ebrkMdkPQg/T+J
         r+xdypLY75GTTRGFZDwP7aUiFgjgAVyD87WG6v6+H5DaSbc+fwV+hhasrtZZoTVUYxlx
         3VaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=8be0dtX8Bx/Brc6sNGJ5yvfgieIe1YrD5dF5nmEn7pI=;
        b=CtrYaZ9g71ZiWv0EOR1eN/Tz6LDEM/SNnzJ6s9jt6LFhjbTxzihGsb4pgCgGE2wDE+
         WykvHsr4pqPiGJjTMJSr5/fap9ZfCFYuuhCqdSLfD11kDfx0Zct3rCmwmjpUAGTe6CZ4
         QRhgMTjE3vXPBH5ADMwoAG/udJM7u0TxtgobwiccAhyDTv+OnO1ZSG7662wL4elZcOFd
         YoFYaxhcmDUt5shHBPuTYdvZKQfsKMWQW5JfQ/RsjlDSvQLSfnvhQ6QOiqyiDXfJk1cl
         fhlVquX4Gs1IzEMnqYX/BdMgGRdA/P7QdBtwUe/CexBwlzY0Gtg+1mkZRjFLrYH7Irg1
         R99w==
X-Gm-Message-State: AOAM532MOgTcnNd47JtDuGZrJegqC9FNgInj/RYtrjohtDXfmUcuFTX4
        J/IOhmipbaPsXI4DiAG80Hk=
X-Google-Smtp-Source: ABdhPJx5ymzSVvKTn0gURA/z/0XsLCCNRlJiQtWV7lcVHXjPgQhzf8ET2yF2LpNvTBw17/HABs+gJQ==
X-Received: by 2002:a62:19d5:: with SMTP id 204mr2159724pfz.189.1590121479566;
        Thu, 21 May 2020 21:24:39 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z23sm4931236pga.86.2020.05.21.21.24.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 May 2020 21:24:38 -0700 (PDT)
Subject: [bpf-next PATCH v4 2/5] bpf: extend bpf_base_func_proto helpers
 with probe_* and *current_task*
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, andrii.nakryiko@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com, jakub@cloudflare.com, lmb@cloudflare.com
Date:   Thu, 21 May 2020 21:24:23 -0700
Message-ID: <159012146282.14791.7652481804905295417.stgit@john-Precision-5820-Tower>
In-Reply-To: <159012108670.14791.18091717338621259928.stgit@john-Precision-5820-Tower>
References: <159012108670.14791.18091717338621259928.stgit@john-Precision-5820-Tower>
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
 0 files changed

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

