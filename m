Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925721E00BC
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 18:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387677AbgEXQvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 12:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728375AbgEXQvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 12:51:11 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5E7C061A0E;
        Sun, 24 May 2020 09:51:10 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id s69so7563296pjb.4;
        Sun, 24 May 2020 09:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=6SKBe6xQJXBNFACnU6xjW3B0HnZH7Fada6vWqTlhWS4=;
        b=uWRILoHSTUjptzPYr/bMScb2eycrw1HplGZOhrl4v/0v8VjolR1vo8lVdTFj/9ga2G
         VnQmrmdM2p2AN9A0P8WseshA9KzeYfnmkQOqa3EOS28snhRshtGV/GcDqnkSIVMB5lK4
         APss7NVTOi+mbWSU+VtLPHhl1Kc7XDN3/eMYhHgLvnJp2fjhcSynB/3RwKDtL46I0pRu
         +a+O6P4O2z9e2Xx2JFXrwXDW0lFtIfO0ZbhXGaDKZ4iHKJG4uI87KK9S1jHR6dEt5nvS
         bzIsjR4TW7A4JMXdCnkz0OKjaHTSiAigGVj3X/fzhtOBvv1MucG9WusyNukVwAV7T+QN
         2SXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=6SKBe6xQJXBNFACnU6xjW3B0HnZH7Fada6vWqTlhWS4=;
        b=Mp+1BUnF/kq/S0p0k5kslXUuWOtAdCizS61rpvoqF0ZmuX6idjfwGdkjGOPZ6NV2z0
         QPLZnw2qMq332b45lfCvdwAo3m3Lov1pNEOqbEQrhoup1Mt7Lq2XfcM02Nqi69a9IKBf
         YGNdcZtffHUP1MFO9Er2WJp753WjtwXTLnX/WxsYbJZ1R2MLhfvxaESoxmqjtT8hQGY5
         +L08ZT8XqfRfZvy+IR4EIFNZoEG/ZviPP58mC0PvPKxkF5bufPJLScgvPl/H78FnYShq
         58zpx2I2ExbKBJ38CuZFrWwAgDnO72VWzbNB/Hn9uGpDNtK7ojPlvFgLnk0gBEvjUtUf
         xJqA==
X-Gm-Message-State: AOAM533E/cxXVdslx7JbT7ymRXnudHNhAWlcg4JdvpFDASEagZG2vbWU
        yuFFa3Qth0/t1ioNp0HNzxM=
X-Google-Smtp-Source: ABdhPJxb9NsIphjiXioSr3YjOz/11c2E54lvrwvOSZHJS6UKTMkYYPKi/AZGR5d2RV2kMa8ZgVOuqw==
X-Received: by 2002:a17:902:fe06:: with SMTP id g6mr23666938plj.118.1590339069680;
        Sun, 24 May 2020 09:51:09 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id p190sm11275070pfp.207.2020.05.24.09.51.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 May 2020 09:51:09 -0700 (PDT)
Subject: [bpf-next PATCH v5 2/5] bpf: extend bpf_base_func_proto helpers
 with probe_* and *current_task*
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, andrii.nakryiko@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Sun, 24 May 2020 09:50:55 -0700
Message-ID: <159033905529.12355.4368381069655254932.stgit@john-Precision-5820-Tower>
In-Reply-To: <159033879471.12355.1236562159278890735.stgit@john-Precision-5820-Tower>
References: <159033879471.12355.1236562159278890735.stgit@john-Precision-5820-Tower>
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
 kernel/bpf/helpers.c     |   24 ++++++++++++++++++++++++
 kernel/trace/bpf_trace.c |   10 +++++-----
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 886949f..bb4fb63 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -601,6 +601,12 @@ const struct bpf_func_proto bpf_event_output_data_proto =  {
 	.arg5_type      = ARG_CONST_SIZE_OR_ZERO,
 };
 
+const struct bpf_func_proto bpf_get_current_task_proto __weak;
+const struct bpf_func_proto bpf_probe_read_user_proto __weak;
+const struct bpf_func_proto bpf_probe_read_user_str_proto __weak;
+const struct bpf_func_proto bpf_probe_read_kernel_proto __weak;
+const struct bpf_func_proto bpf_probe_read_kernel_str_proto __weak;
+
 const struct bpf_func_proto *
 bpf_base_func_proto(enum bpf_func_id func_id)
 {
@@ -648,6 +654,24 @@ bpf_base_func_proto(enum bpf_func_id func_id)
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
index 9531f54..187cd69 100644
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
@@ -253,7 +253,7 @@ BPF_CALL_3(bpf_probe_read_kernel_str, void *, dst, u32, size,
 	return bpf_probe_read_kernel_str_common(dst, size, unsafe_ptr, false);
 }
 
-static const struct bpf_func_proto bpf_probe_read_kernel_str_proto = {
+const struct bpf_func_proto bpf_probe_read_kernel_str_proto = {
 	.func		= bpf_probe_read_kernel_str,
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

