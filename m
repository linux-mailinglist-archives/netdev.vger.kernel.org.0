Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F7D295A0E
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 10:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895227AbgJVIWM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 22 Oct 2020 04:22:12 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:34514 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2895214AbgJVIWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 04:22:11 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-dGRBVbSkNiSXPOmlsQg_8w-1; Thu, 22 Oct 2020 04:22:05 -0400
X-MC-Unique: dGRBVbSkNiSXPOmlsQg_8w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DC25B1006C9F;
        Thu, 22 Oct 2020 08:22:03 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7837760BFA;
        Thu, 22 Oct 2020 08:21:56 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: [RFC bpf-next 04/16] ftrace: Add ftrace_set_filter_ips function
Date:   Thu, 22 Oct 2020 10:21:26 +0200
Message-Id: <20201022082138.2322434-5-jolsa@kernel.org>
In-Reply-To: <20201022082138.2322434-1-jolsa@kernel.org>
References: <20201022082138.2322434-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding ftrace_set_filter_ips function that allows to set
filter on multiple ip addresses. These are provided as
array of unsigned longs together with the array count:

  int ftrace_set_filter_ips(struct ftrace_ops *ops,
                            unsigned long *ips,
                            int count, int remove);

The function copies logic of ftrace_set_filter_ip but
over multiple ip addresses.

It will be used in following patches for faster direct
ip/addr trampolines update.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/ftrace.h |  3 +++
 kernel/trace/ftrace.c  | 56 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 1bd3a0356ae4..d71d88d10517 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -463,6 +463,8 @@ struct dyn_ftrace {
 int ftrace_force_update(void);
 int ftrace_set_filter_ip(struct ftrace_ops *ops, unsigned long ip,
 			 int remove, int reset);
+int ftrace_set_filter_ips(struct ftrace_ops *ops, unsigned long *ips,
+			 int count, int remove);
 int ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
 		       int len, int reset);
 int ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
@@ -738,6 +740,7 @@ static inline unsigned long ftrace_location(unsigned long ip)
 #define ftrace_regex_open(ops, flag, inod, file) ({ -ENODEV; })
 #define ftrace_set_early_filter(ops, buf, enable) do { } while (0)
 #define ftrace_set_filter_ip(ops, ip, remove, reset) ({ -ENODEV; })
+#define ftrace_set_filter_ips(ops, ip, remove) ({ -ENODEV; })
 #define ftrace_set_filter(ops, buf, len, reset) ({ -ENODEV; })
 #define ftrace_set_notrace(ops, buf, len, reset) ({ -ENODEV; })
 #define ftrace_free_filter(ops) do { } while (0)
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 95ef7e2a6a57..44c2d21b8c19 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -4977,6 +4977,47 @@ ftrace_set_hash(struct ftrace_ops *ops, unsigned char *buf, int len,
 	return ret;
 }
 
+static int
+ftrace_set_hash_ips(struct ftrace_ops *ops, unsigned long *ips,
+		    int count, int remove, int enable)
+{
+	struct ftrace_hash **orig_hash;
+	struct ftrace_hash *hash;
+	int ret, i;
+
+	if (unlikely(ftrace_disabled))
+		return -ENODEV;
+
+	mutex_lock(&ops->func_hash->regex_lock);
+
+	if (enable)
+		orig_hash = &ops->func_hash->filter_hash;
+	else
+		orig_hash = &ops->func_hash->notrace_hash;
+
+	hash = alloc_and_copy_ftrace_hash(FTRACE_HASH_DEFAULT_BITS, *orig_hash);
+	if (!hash) {
+		ret = -ENOMEM;
+		goto out_regex_unlock;
+	}
+
+	for (i = 0; i < count; i++) {
+		ret = ftrace_match_addr(hash, ips[i], remove);
+		if (ret < 0)
+			goto out_regex_unlock;
+	}
+
+	mutex_lock(&ftrace_lock);
+	ret = ftrace_hash_move_and_update_ops(ops, orig_hash, hash, enable);
+	mutex_unlock(&ftrace_lock);
+
+ out_regex_unlock:
+	mutex_unlock(&ops->func_hash->regex_lock);
+
+	free_ftrace_hash(hash);
+	return ret;
+}
+
 static int
 ftrace_set_addr(struct ftrace_ops *ops, unsigned long ip, int remove,
 		int reset, int enable)
@@ -4984,6 +5025,13 @@ ftrace_set_addr(struct ftrace_ops *ops, unsigned long ip, int remove,
 	return ftrace_set_hash(ops, NULL, 0, ip, remove, reset, enable);
 }
 
+static int
+ftrace_set_addrs(struct ftrace_ops *ops, unsigned long *ips,
+		 int count, int remove, int enable)
+{
+	return ftrace_set_hash_ips(ops, ips, count, remove, enable);
+}
+
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS
 
 struct ftrace_direct_func {
@@ -5395,6 +5443,14 @@ int ftrace_set_filter_ip(struct ftrace_ops *ops, unsigned long ip,
 }
 EXPORT_SYMBOL_GPL(ftrace_set_filter_ip);
 
+int ftrace_set_filter_ips(struct ftrace_ops *ops, unsigned long *ips,
+			 int count, int remove)
+{
+	ftrace_ops_init(ops);
+	return ftrace_set_addrs(ops, ips, count, remove, 1);
+}
+EXPORT_SYMBOL_GPL(ftrace_set_filter_ips);
+
 /**
  * ftrace_ops_set_global_filter - setup ops to use global filters
  * @ops - the ops which will use the global filters
-- 
2.26.2

