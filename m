Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705E51B1703
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 22:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgDTU07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 16:26:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728284AbgDTU04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 16:26:56 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8FC9C061A0C;
        Mon, 20 Apr 2020 13:26:56 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id u9so5490625pfm.10;
        Mon, 20 Apr 2020 13:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fu9Uhr2WUQ553mJsjojbg9oYJpUAQFW34/wi7Gm0amg=;
        b=Itehx/knDWwHPwVe6STk6VcC+aEK0W7ooUGEb791KaDO1o/vwOdA/JN9yFNuVtdy4+
         n0dN1Nkmzau/ARNpn+G/YI3Fjguagorp8ldTOIgQqQVPHPPh4/bmjoFvrh0J50vXjq8p
         URpW1BpKuPjhkIoxDFzspsPzM5KbiynyR3oBXa+wqtAXeFvlug5Sx+OTMQhCl6pKlGQj
         WjUzdRMAr97FopmwNN2FxRfR9yuqm9Vbzh4breKXDnoDuL4DiU5tolDk37r2OiDhHCa4
         oKvMWOql1K3zGjOSClA9u+ShXFYMFZL/TheBb6w4qnqdyslWRGwFUl3d4FwZ7eOkjrEb
         Gxvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Fu9Uhr2WUQ553mJsjojbg9oYJpUAQFW34/wi7Gm0amg=;
        b=jq5ruqMCxcNO1zhKXdA5R2P24YtX057eveL6V7IbekrOFr1Kkn9Lub0r5PEaIsIGRW
         3Vi39vwICsd6YiLQriG1pivUIAtPkHwRXyCX93XD54hGeGyfMe3Hjg97UWNiPo7P80xF
         aPv/gnJvwAmM8orn5gVZQkxz/+FIesH2frvZnShcx1zvmHk2ncqrOXw5HiGLDuZ/9Qm5
         4NifBy86XuaQlA0+xU0Q/pngfLxagVAB2xXHdrYx24HZ1iybt7WJy4p6e+kGr13zPpMB
         3IgmY4eZeZ2PyxALsKxtsWdNoDXHBGVLkEm4gxhzRxzV2qkDySrIPG3yNk11+j4rozCK
         3yoQ==
X-Gm-Message-State: AGi0PubrONvy8qL9m1Lav8ZCyYh06UmFv2FvlQMiGMkr5nBPkfJWGQhj
        uvr8XRwrVe3P4WZI5+JJt7c=
X-Google-Smtp-Source: APiQypJpug56tVoemXOW5dw56pzrYkEFCOENPtf7Pdhh01jNMlZXJtyzWZDH5fcD2MEZ9xpXjlcP3g==
X-Received: by 2002:a63:1820:: with SMTP id y32mr17486948pgl.182.1587414416044;
        Mon, 20 Apr 2020 13:26:56 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id 141sm338899pfz.171.2020.04.20.13.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 13:26:55 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH] net: bpf: add bpf_ktime_get_boot_ns()
Date:   Mon, 20 Apr 2020 13:26:43 -0700
Message-Id: <20200420202643.87198-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

On a device like a cellphone which is constantly suspending
and resuming CLOCK_MONOTONIC is not particularly useful for
keeping track of or reacting to external network events.
Instead you want to use CLOCK_BOOTTIME.

Hence add bpf_ktime_get_boot_ns() as a mirror of bpf_ktime_get_ns()
based around CLOCK_BOOTTIME instead of CLOCK_MONOTONIC.

Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 drivers/media/rc/bpf-lirc.c    |  2 ++
 include/linux/bpf.h            |  1 +
 include/uapi/linux/bpf.h       | 13 ++++++++++++-
 kernel/bpf/core.c              |  1 +
 kernel/bpf/helpers.c           | 12 ++++++++++++
 kernel/trace/bpf_trace.c       |  2 ++
 net/core/filter.c              |  2 ++
 tools/include/uapi/linux/bpf.h | 13 ++++++++++++-
 8 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/bpf-lirc.c b/drivers/media/rc/bpf-lirc.c
index 0f3417d161b8..069c42f22a8c 100644
--- a/drivers/media/rc/bpf-lirc.c
+++ b/drivers/media/rc/bpf-lirc.c
@@ -103,6 +103,8 @@ lirc_mode2_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_map_peek_elem_proto;
 	case BPF_FUNC_ktime_get_ns:
 		return &bpf_ktime_get_ns_proto;
+	case BPF_FUNC_ktime_get_boot_ns:
+		return &bpf_ktime_get_boot_ns_proto;
 	case BPF_FUNC_tail_call:
 		return &bpf_tail_call_proto;
 	case BPF_FUNC_get_prandom_u32:
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index fd2b2322412d..65217c52474d 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1502,6 +1502,7 @@ extern const struct bpf_func_proto bpf_get_smp_processor_id_proto;
 extern const struct bpf_func_proto bpf_get_numa_node_id_proto;
 extern const struct bpf_func_proto bpf_tail_call_proto;
 extern const struct bpf_func_proto bpf_ktime_get_ns_proto;
+extern const struct bpf_func_proto bpf_ktime_get_boot_ns_proto;
 extern const struct bpf_func_proto bpf_get_current_pid_tgid_proto;
 extern const struct bpf_func_proto bpf_get_current_uid_gid_proto;
 extern const struct bpf_func_proto bpf_get_current_comm_proto;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 2e29a671d67e..2e13b094438d 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -652,6 +652,16 @@ union bpf_attr {
  * u64 bpf_ktime_get_ns(void)
  * 	Description
  * 		Return the time elapsed since system boot, in nanoseconds.
+ * 		Does not include time the system was suspended.
+ * 		See: clock_gettime(CLOCK_MONOTONIC)
+ * 	Return
+ * 		Current *ktime*.
+ *
+ * u64 bpf_ktime_get_boot_ns(void)
+ * 	Description
+ * 		Return the time elapsed since system boot, in nanoseconds.
+ * 		Does include the time the system was suspended.
+ * 		See: clock_gettime(CLOCK_BOOTTIME)
  * 	Return
  * 		Current *ktime*.
  *
@@ -3151,7 +3161,8 @@ union bpf_attr {
 	FN(xdp_output),			\
 	FN(get_netns_cookie),		\
 	FN(get_current_ancestor_cgroup_id),	\
-	FN(sk_assign),
+	FN(sk_assign),			\
+	FN(ktime_get_boot_ns),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 916f5132a984..d87877cd99c1 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2151,6 +2151,7 @@ const struct bpf_func_proto bpf_get_prandom_u32_proto __weak;
 const struct bpf_func_proto bpf_get_smp_processor_id_proto __weak;
 const struct bpf_func_proto bpf_get_numa_node_id_proto __weak;
 const struct bpf_func_proto bpf_ktime_get_ns_proto __weak;
+const struct bpf_func_proto bpf_ktime_get_boot_ns_proto __weak;
 
 const struct bpf_func_proto bpf_get_current_pid_tgid_proto __weak;
 const struct bpf_func_proto bpf_get_current_uid_gid_proto __weak;
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index a5158a179e81..fb3ecc5dee7f 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -155,6 +155,18 @@ const struct bpf_func_proto bpf_ktime_get_ns_proto = {
 	.ret_type	= RET_INTEGER,
 };
 
+BPF_CALL_0(bpf_ktime_get_boot_ns)
+{
+	/* NMI safe access to clock boottime */
+	return ktime_get_boot_fast_ns();
+}
+
+const struct bpf_func_proto bpf_ktime_get_boot_ns_proto = {
+	.func		= bpf_ktime_get_boot_ns,
+	.gpl_only	= false,
+	.ret_type	= RET_INTEGER,
+};
+
 BPF_CALL_0(bpf_get_current_pid_tgid)
 {
 	struct task_struct *task = current;
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index ca1796747a77..e875c95d3ced 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -797,6 +797,8 @@ bpf_tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_map_peek_elem_proto;
 	case BPF_FUNC_ktime_get_ns:
 		return &bpf_ktime_get_ns_proto;
+	case BPF_FUNC_ktime_get_boot_ns:
+		return &bpf_ktime_get_boot_ns_proto;
 	case BPF_FUNC_tail_call:
 		return &bpf_tail_call_proto;
 	case BPF_FUNC_get_current_pid_tgid:
diff --git a/net/core/filter.c b/net/core/filter.c
index 755867867e57..ec567d1e6fb9 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6009,6 +6009,8 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return &bpf_tail_call_proto;
 	case BPF_FUNC_ktime_get_ns:
 		return &bpf_ktime_get_ns_proto;
+	case BPF_FUNC_ktime_get_boot_ns:
+		return &bpf_ktime_get_boot_ns_proto;
 	default:
 		break;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 2e29a671d67e..2e13b094438d 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -652,6 +652,16 @@ union bpf_attr {
  * u64 bpf_ktime_get_ns(void)
  * 	Description
  * 		Return the time elapsed since system boot, in nanoseconds.
+ * 		Does not include time the system was suspended.
+ * 		See: clock_gettime(CLOCK_MONOTONIC)
+ * 	Return
+ * 		Current *ktime*.
+ *
+ * u64 bpf_ktime_get_boot_ns(void)
+ * 	Description
+ * 		Return the time elapsed since system boot, in nanoseconds.
+ * 		Does include the time the system was suspended.
+ * 		See: clock_gettime(CLOCK_BOOTTIME)
  * 	Return
  * 		Current *ktime*.
  *
@@ -3151,7 +3161,8 @@ union bpf_attr {
 	FN(xdp_output),			\
 	FN(get_netns_cookie),		\
 	FN(get_current_ancestor_cgroup_id),	\
-	FN(sk_assign),
+	FN(sk_assign),			\
+	FN(ktime_get_boot_ns),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.26.1.301.g55bc3eb7cb9-goog

