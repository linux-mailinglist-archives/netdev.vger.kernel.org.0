Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD4641D043
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 01:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347780AbhI3ABU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 20:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347414AbhI3ABQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 20:01:16 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6CD0C06161C;
        Wed, 29 Sep 2021 16:59:34 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id k24so4395600pgh.8;
        Wed, 29 Sep 2021 16:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9ZRKgDZ6XWRjC4EeejjjznOYs+6ni/tYALm2oo2Ed6I=;
        b=BZYB9SQ8xm1V0xIGJCvYafNhZ/21gINYPjJ9EfdLnnkNroz6Eg32DAwtFGb+OnzhAd
         aUY/2tgdL0r4pwCC8cNNOUdpimYn67f7azWOdbQdVRn2aQRqU6G46M2Yyk+KLAngxpyE
         8EzFHQbbSKoCZJet/cs/TvvxwmEEpFN4TfTCmdIclGddtA3wFDrXU7smbr2D4PK9JYfw
         IY7xGrq1BS/5il21dewqZAjFWXKvexngQ0kN4RZFsmmR/Olaj4RP8hEBSpQY7tCui/1d
         npNDzjlyPO1EnLF1+rtX00hhn447d/b/1kCErSegb2us6f7qTvytfK5dxTkA0ePzYv0q
         oXMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9ZRKgDZ6XWRjC4EeejjjznOYs+6ni/tYALm2oo2Ed6I=;
        b=s+YYaGZgyAkyMHzaLwzfazZUnBzucHyKKiVqGi9wZJzS9C5h+ZgaYIdspfbBLCeoTG
         fUhNnkTS4MGTtH7q3OsxeuvqjKxEqMnAFiAisejhQh+8uBSTIUsXEqNGeQgyelt/sY42
         ZjZRtEIsOkXhr2V/Y5/fK+Axv1eADcasw3OYjuKhA+h3vT1gNxAjJhOvWWg5vRNwGNhf
         B949Ow9DMliwIDPB8yGWYCsjr9A4ApxgHphT0XXhYp6YFjzpMAJRK/PBFpEQgIl/eH2V
         +ZwY0WEx2qg/r2eK5DEFl/GRLLxrHqarkgflJ2a7HAtA/c1tP0GBDVfp7pNAYdVnG5fD
         zgXw==
X-Gm-Message-State: AOAM53028KgefawjDJgSR6kpp1TcpL98F0PdlCMqSciQMeRDycAodDmx
        e+FRb+JpXuSEcGCtwr3mQumW7Kps/owj
X-Google-Smtp-Source: ABdhPJxxZQ6VAkPC2tOllW5FrCrHYgMBgvsR+zWk5PTEgevqI/mjLOSK4rhKVanyLEHxzs167olWdQ==
X-Received: by 2002:a63:4f:: with SMTP id 76mr2220691pga.457.1632959974264;
        Wed, 29 Sep 2021 16:59:34 -0700 (PDT)
Received: from jevburton2.c.googlers.com.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mr18sm681907pjb.17.2021.09.29.16.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 16:59:33 -0700 (PDT)
From:   Joe Burton <jevburton.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Joe Burton <jevburton@google.com>
Subject: [RFC PATCH v2 03/13] bpf: Add list of tracing programs to struct bpf_map
Date:   Wed, 29 Sep 2021 23:59:00 +0000
Message-Id: <20210929235910.1765396-4-jevburton.kernel@gmail.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
In-Reply-To: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
References: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Burton <jevburton@google.com>

Add array of programs to struct bpf_map. To minimize cost, this array
is allocated at the time that the first program is attached to a map.
It is installed using a cmpxchg() to avoid adding another mutex inside
bpf_map.

Signed-off-by: Joe Burton <jevburton@google.com>
---
 include/linux/bpf.h    | 18 +++++++++++++++++-
 kernel/bpf/map_trace.c | 21 +++++++++++++++++++++
 kernel/bpf/syscall.c   |  4 ++++
 3 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 272f0ac49285..3ae12ab97720 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -43,6 +43,7 @@ struct kobject;
 struct mem_cgroup;
 struct module;
 struct bpf_func_state;
+struct bpf_map_trace_progs;
 
 extern struct idr btf_idr;
 extern spinlock_t btf_idr_lock;
@@ -180,10 +181,11 @@ struct bpf_map {
 	struct mem_cgroup *memcg;
 #endif
 	char name[BPF_OBJ_NAME_LEN];
+	struct bpf_map_trace_progs *trace_progs;
 	u32 btf_vmlinux_value_type_id;
 	bool bypass_spec_v1;
 	bool frozen; /* write-once; write-protected by freeze_mutex */
-	/* 22 bytes hole */
+	/* 14 bytes hole */
 
 	/* The 3rd and 4th cacheline with misc members to avoid false sharing
 	 * particularly with refcounting.
@@ -1510,12 +1512,26 @@ struct bpf_iter_reg {
 	const struct bpf_iter_seq_info *seq_info;
 };
 
+/* Maximum number of tracing programs that may be attached to one map */
+#define BPF_MAP_TRACE_MAX_PROGS 16
 #define BPF_MAP_TRACE_FUNC_SYM(trace_type) bpf_map_trace__ ## trace_type
 #define DEFINE_BPF_MAP_TRACE_FUNC(trace_type, args...)	\
 	extern int BPF_MAP_TRACE_FUNC_SYM(trace_type)(args);	\
 	int __init BPF_MAP_TRACE_FUNC_SYM(trace_type)(args)	\
 	{ return 0; }
 
+struct bpf_map_trace_prog {
+	struct list_head list;
+	struct bpf_prog *prog;
+	struct rcu_head rcu;
+};
+
+struct bpf_map_trace_progs {
+	struct bpf_map_trace_prog __rcu progs[MAX_BPF_MAP_TRACE_TYPE];
+	u32 length[MAX_BPF_MAP_TRACE_TYPE];
+	struct mutex mutex; /* protects writes to progs, length */
+};
+
 struct bpf_map_trace_reg {
 	const char *target;
 	enum bpf_map_trace_type trace_type;
diff --git a/kernel/bpf/map_trace.c b/kernel/bpf/map_trace.c
index d2c6df20f55c..7776b8ccfe88 100644
--- a/kernel/bpf/map_trace.c
+++ b/kernel/bpf/map_trace.c
@@ -3,6 +3,7 @@
 
 #include <linux/filter.h>
 #include <linux/bpf.h>
+#include <linux/rcupdate.h>
 
 struct bpf_map_trace_target_info {
 	struct list_head list;
@@ -56,3 +57,23 @@ bool bpf_map_trace_prog_supported(struct bpf_prog *prog)
 	return supported;
 }
 
+int bpf_map_initialize_trace_progs(struct bpf_map *map)
+{
+	struct bpf_map_trace_progs *new_trace_progs;
+	int i;
+
+	if (!READ_ONCE(map->trace_progs)) {
+		new_trace_progs = kzalloc(sizeof(struct bpf_map_trace_progs),
+					  GFP_KERNEL);
+		if (!new_trace_progs)
+			return -ENOMEM;
+		mutex_init(&new_trace_progs->mutex);
+		for (i = 0; i < MAX_BPF_MAP_TRACE_TYPE; i++)
+			INIT_LIST_HEAD(&new_trace_progs->progs[i].list);
+		if (cmpxchg(&map->trace_progs, NULL, new_trace_progs))
+			kfree(new_trace_progs);
+	}
+
+	return 0;
+}
+
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4e50c0bfdb7d..e6179755fd3b 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -460,6 +460,7 @@ static void bpf_map_free_deferred(struct work_struct *work)
 
 	security_bpf_map_free(map);
 	bpf_map_release_memcg(map);
+	kfree(map->trace_progs);
 	/* implementation dependent freeing */
 	map->ops->map_free(map);
 }
@@ -913,6 +914,9 @@ static int map_create(union bpf_attr *attr)
 		return err;
 	}
 
+	/* tracing programs lists are allocated when attached */
+	map->trace_progs = NULL;
+
 	return err;
 
 free_map_sec:
-- 
2.33.0.685.g46640cef36-goog

