Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30E92471B6F
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 16:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbhLLPo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 10:44:28 -0500
Received: from out162-62-57-49.mail.qq.com ([162.62.57.49]:46917 "EHLO
        out162-62-57-49.mail.qq.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229605AbhLLPo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 10:44:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1639323865;
        bh=ZoCYAvdIJXISSGluDzuYb73rcqJpbKY8EnluvL4aB2M=;
        h=From:To:Cc:Subject:Date;
        b=ibm5esSQi7tuvGiUr3vWN9HB2HLZ4136XjEsM3T+TRLTiDOL4YMmW1JONUCpxoVXP
         pESkoPINODMFq8PAluy2QmK8xUhmwqoVvKaKGnve8j4iGLgJI/tnYsKWgI13QaXU3I
         iyaVDz74147R3g9AZKghCD98UaoVUmyx7UVe3mQU=
Received: from localhost.localdomain ([218.197.153.188])
        by newxmesmtplogicsvrszb7.qq.com (NewEsmtp) with SMTP
        id 92D362B5; Sun, 12 Dec 2021 23:36:45 +0800
X-QQ-mid: xmsmtpt1639323405tewy6sfmw
Message-ID: <tencent_D76F400098C9729D38BA28ACC233944AFE09@qq.com>
X-QQ-XMAILINFO: M3ziZXKDk+iO/aMJEHNWM5YAUuCXF+3E3uYryP62x5isGC1hey5/HrzheEyJxd
         nvRohTO6XzS9Oi0/2yq9xTooCRiv8Q8xFWBG0RM70muHVwlhGir3AnA1PQW7BF/JkGrkdCPqj4Mu
         fffCSGW5jfbKq80QlYxd8gRXXyTFXU5BciPxJixC7y5ZjhMwdUVRuNP2J8fLWtNH/7GEDThowvXx
         v9A98swKgTujvetlaqLj331uiZ9dMP7Slor0TznJ6+wzD8B3NDF/HBpNPjdg7dfQ/c4MU0i2qMu8
         NWDHQ6sPldl67DlTzgYHUg8bh9tQSA9/8R7aznKGcNYHUp4S2Rr8gCA1d3RjP/Cy8oiaROy13u0O
         tISdNOa74W3WJBFUqvLWBAG2AoeHuX/F4ct2RfXfvqxZy1vLyDFHvL95nILv2tqQIzihs/E4W/k5
         YJkP38M86pq6Vh59R9gc/SxbC3gaOoCTcoBTJ2uwwMI9/C6l4EeLXeRjQ6fjRity/6dPdOceASkN
         mBU5UBlSxY9AoIPAixu01gZM/IldriTS1KyUNSPo5/CjB7dzv0zAx8esoILpV0hKYuWzmzl2FzDT
         KF7YcLIjs0SZoBqn2WeeSz4PgIEKWDkX0whzJBrIg6seXr8C6TWkeKPljyi6MxPKuiDklXmnIKqe
         VaHsc2yPx4VJKlSZlote52/+OB3OX9ap15SlbbdTyTQ+9zLi5runCIQHb+4d7IwC/OeIYgpVIf+t
         Lv/OKESRQObexoFa/l8Mj29vHqBa3k4dv7SvOetMKHtVCHA6cHGQb45ShxJ8i9pqYk1xqLIt8Eb2
         q6OtRkd27QNdsUW2JmA/5oGkH8BRR7nVKVXwbOvlD7a6a//1Gd1y7RV5sdYwC/qHHusfvkSQGXXN
         5D/wO0xh1p
From:   xkernel <xkernel.wang@foxmail.com>
To:     rostedt@goodmis.org, mingo@redhat.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, xkernel <xkernel.wang@foxmail.com>
Subject: [PATCH] tracing: check the return value of kstrdup()
Date:   Sun, 12 Dec 2021 23:36:20 +0800
X-OQ-MSGID: <20211212153620.2265-1-xkernel.wang@foxmail.com>
X-Mailer: git-send-email 2.33.0.windows.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kstrdup() returns NULL when some internal memory errors happen, it is
better to check the return value of it. The code is under Linux-5.15.

Signed-off-by: xkernel <xkernel.wang@foxmail.com>
---
 kernel/trace/trace_boot.c   | 4 ++++
 kernel/trace/trace_uprobe.c | 5 +++++
 2 files changed, 9 insertions(+)

diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index 8d252f6..0580287 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -430,6 +430,8 @@ trace_boot_init_histograms(struct trace_event_file *file,
 		/* All digit started node should be instances. */
 		if (trace_boot_compose_hist_cmd(node, buf, size) == 0) {
 			tmp = kstrdup(buf, GFP_KERNEL);
+			if (!tmp)
+				return;
 			if (trigger_process_regex(file, buf) < 0)
 				pr_err("Failed to apply hist trigger: %s\n", tmp);
 			kfree(tmp);
@@ -439,6 +441,8 @@ trace_boot_init_histograms(struct trace_event_file *file,
 	if (xbc_node_find_subkey(hnode, "keys")) {
 		if (trace_boot_compose_hist_cmd(hnode, buf, size) == 0) {
 			tmp = kstrdup(buf, GFP_KERNEL);
+			if (!tmp)
+				return;
 			if (trigger_process_regex(file, buf) < 0)
 				pr_err("Failed to apply hist trigger: %s\n", tmp);
 			kfree(tmp);
diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 225ce56..173ff0f 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -1618,6 +1618,11 @@ create_local_trace_uprobe(char *name, unsigned long offs,
 	tu->path = path;
 	tu->ref_ctr_offset = ref_ctr_offset;
 	tu->filename = kstrdup(name, GFP_KERNEL);
+	if (!tu->filename) {
+		ret = -ENOMEM;
+		goto error;
+	}
+
 	init_trace_event_call(tu);
 
 	ptype = is_ret_probe(tu) ? PROBE_PRINT_RETURN : PROBE_PRINT_NORMAL;
-- 
