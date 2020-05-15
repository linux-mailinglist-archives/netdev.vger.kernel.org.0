Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157341D5C0F
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbgEOWGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726179AbgEOWGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 18:06:33 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1132DC061A0C;
        Fri, 15 May 2020 15:06:33 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id c20so1925608ilk.6;
        Fri, 15 May 2020 15:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=tERCCKiIKjEOnssno9mpcVZCO2wmElRDazrTiC4NWhc=;
        b=SxzT6nzH53RfnGEZPsqknVJuHoICyb9rZPzQ7437b1+CiLKdVFzjPL8ecKFhHW/7Y0
         hHeki8WSCL9l3GnzlwVYDCLkDKD4M8OTwBAlGt89JFRykzRSn5OFt9VXRO3PfBma+Qje
         Yexk2vdHU/qBxStUMigyYUKQyDbim7QJ0fyaf7MopdrDN4ZL5w+NuRfyzTB/skcq2KuP
         nmRz3zDU68HZVsgUCSnq79741d3t+1aE2zkuIo+tLXPjz171+nwNH6k6hMdyCQQwWOKo
         w3bzGx8xW3YY+b6CmzoN2Du8rQpmn3JxZTzJoVya8uy0qgiKWMJEmhmtYlqD9YANXQci
         CZuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=tERCCKiIKjEOnssno9mpcVZCO2wmElRDazrTiC4NWhc=;
        b=V1wlLaEkzM7AuSz7Lhp85AOXH7xlMNgNt1nkXspcu22flP85F3004Cs17QljYRmd1O
         KX9wmmp+JbKkwf3qnjSccupw728BoqGjkzRIOHW0qXsxmbW/0supG6HtdcvJQQn/tza/
         Z5ALhjCdghAjYOx4u+QVajJM9u/ZrystLuPAQm5w+B4KlnwOYUGmstDo7I77xU8RtoXT
         +RbksAk6mHURAbvvDVDvwaEBwJpUOA/IR1hbwSguFNCxojA68bQBZ0pfua1nJBT/Dh4l
         rKBL1t06VniKjkwc2+FuVI5gQimQbYikiYWyldzMeaFg8tYX8r0vnET0JB+BKztxgAan
         FHHw==
X-Gm-Message-State: AOAM531MUO4d7WYgvFWqo/yGO8+O6H+f+/3VNljM2vNzBbFSiuennwUb
        v3HqRMjbuUB/oCr0ttQQ+fw=
X-Google-Smtp-Source: ABdhPJx1zhZSh7bwpqkECWQRvF3kqTYnQ7hkWZA+FrFoOXcDOz5FAIoBQlEOaFNkeWztXGHYV8BhoA==
X-Received: by 2002:a92:bb55:: with SMTP id w82mr5558479ili.211.1589580392500;
        Fri, 15 May 2020 15:06:32 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l7sm1402407ilh.54.2020.05.15.15.06.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 May 2020 15:06:31 -0700 (PDT)
Subject: [bpf-next PATCH v2 2/5] bpf: extend bpf_base_func_proto helpers
 with probe_* and *current_task*
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, ast@kernel.org, daniel@iogearbox.net
Cc:     lmb@cloudflare.com, bpf@vger.kernel.org, john.fastabend@gmail.com,
        jakub@cloudflare.com, netdev@vger.kernel.org
Date:   Fri, 15 May 2020 15:06:17 -0700
Message-ID: <158958037715.12532.12473092995203096801.stgit@john-Precision-5820-Tower>
In-Reply-To: <158958022865.12532.5430684453474460041.stgit@john-Precision-5820-Tower>
References: <158958022865.12532.5430684453474460041.stgit@john-Precision-5820-Tower>
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
index 9a84d7f..60e54be 100644
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
@@ -877,7 +877,7 @@ BPF_CALL_0(bpf_get_current_task)
 	return (long) current;
 }
 
-static const struct bpf_func_proto bpf_get_current_task_proto = {
+const struct bpf_func_proto bpf_get_current_task_proto = {
 	.func		= bpf_get_current_task,
 	.gpl_only	= true,
 	.ret_type	= RET_INTEGER,
@@ -898,7 +898,7 @@ BPF_CALL_2(bpf_current_task_under_cgroup, struct bpf_map *, map, u32, idx)
 	return task_under_cgroup_hierarchy(current, cgrp);
 }
 
-static const struct bpf_func_proto bpf_current_task_under_cgroup_proto = {
+const struct bpf_func_proto bpf_current_task_under_cgroup_proto = {
 	.func           = bpf_current_task_under_cgroup,
 	.gpl_only       = false,
 	.ret_type       = RET_INTEGER,

