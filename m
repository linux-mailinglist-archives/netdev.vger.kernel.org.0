Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2599D41D362
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 08:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348368AbhI3Gbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 02:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348363AbhI3Gbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 02:31:41 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6C1C06176D;
        Wed, 29 Sep 2021 23:29:59 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id l6so3262928plh.9;
        Wed, 29 Sep 2021 23:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SmxgKFkRGgoEqMaY9cRCsw185bTTD612fO7JwVu7FH4=;
        b=mJvxVvapfsM5/TAyGI93gO+un+1vYLwzvBXd9xJgV495VSgvX7Y7rcFP8M5gcQ7xP1
         ikTuX9CeyJgor5vtxEYaVv/9UFD9rv1SEKk3bAUtoOoK7BPBLBxRoDOSIBisG54UOAMq
         DtIH5TpZJ4EId7IzcRGYVPsXbK8+HT7LPxjWtwDY0w/t8N2mTt4BIW9yHj2O+x5vf0cg
         E3s8TjYDoPwTM4+CLevjOWXYau6V8tMW0s6oOtWAh18dqi1K13lx3/Q7YPwmwwBgAfvM
         PT557FFwb/0QdUzNBaYgaRQV72qQHihW/otmJp6XA++WUwFpdZMokynjQmDho9hRwqUU
         swCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SmxgKFkRGgoEqMaY9cRCsw185bTTD612fO7JwVu7FH4=;
        b=Eo1OgB18NPi3WO4paw2Mmktk94GrAyd52ixXeV6J4OLSkdaiYsahH/LfPVJqky3iID
         NpArCWg3n1SVj4grFaE6G7icEenUcT+uBaGErnkEBygUy+O20DPPASbVzwnlAAV7izin
         RYGyHHqeyOBhMfPb55ABMw3V3nz59Lpts5wmMTEKhYqUqqCB/YFnwJltXagIeFS1A4LA
         dcL6Shiv1EUAHWpEk0zjoh0es8MbaxDNn5lLi9XfMp04qRY97PzCIqQklJf7alsBh9RX
         0w1e9M/aLhKAkpmS81Jg232yWZVKdT5gQe0Q3Qzotw9x7XjGrTDDMry+XPX3IojiW4di
         WJRQ==
X-Gm-Message-State: AOAM532N6IAVay+KaTk/Nc3E/GVIRIBEy2wagssMQ9eZMP9Mxl4r8E/8
        vfivSj+vNJzPY34oOYDQrSyhBW4EgRo=
X-Google-Smtp-Source: ABdhPJz7ih3w/IqZxUtxlFeJuXj8D53Eb5s/OK75YEML/JeYpOzOK+R+AqxTZjkblmLzzSUPQ3JUPQ==
X-Received: by 2002:a17:90a:1944:: with SMTP id 4mr10923078pjh.221.1632983399214;
        Wed, 29 Sep 2021 23:29:59 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id z9sm1445160pji.42.2021.09.29.23.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 23:29:58 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v6 3/9] bpf: btf: Introduce helpers for dynamic BTF set registration
Date:   Thu, 30 Sep 2021 11:59:42 +0530
Message-Id: <20210930062948.1843919-4-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210930062948.1843919-1-memxor@gmail.com>
References: <20210930062948.1843919-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4928; h=from:subject; bh=Z49+ZfOJfNIcBx7xGCBn4+PTlYIzy90X8Bk3C1i1vSo=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhVVlBfrZyWFi8bHU8zOBS4ia5K3qEpJqBiICjwsXY NqOXh4SJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVVZQQAKCRBM4MiGSL8RyiZOD/ 9q8VTFuTU9N0Pc80vMA1xpvif4bwk+yWi+BAm3gc0r+QVqjCa/9X5L22SM6SkqWFfh6E3sYuRFtAqE gvDDw/PCJqmYAGy9BwEQVblGbtMFyKwAllE3l07UEbuTPb6c+cFYwBNK1gnmGIpALiMr0e01TosXov dmw15gGKzPAikpjeEifakrqwMRw0YNi6/Z4dszSJxzdVc9qx62PS4a4yEwZSP0p0kXAB8I+cff8c/C 1fQvv9z4SxgOqCNsAvyIRF/YOfy+bmjPrNFOSOFas3cMqODTvHBNFcDzbvuY8f8Ksp8DzNh38nLJrF PRwuAOMMnQ8JFwKMDs9wTt4YWE/3ktD+SOMfktJrll4IQD1ZRN1Js2T0kRR/M3Zw/zrgLY9zgizdsv 1bQnvD1ZIXxtD/UcKcqy2ZtdtMz0wciRyW5lamMcfly+s3CW4xjluqNFDR0d1D9d51YQI7HtWfomrL 5o49YkNHlI8vJaCeHIqoBld7bt+XwQL0aHk29ZdnvV3oRxwrmgfAVMKrl492FpBwQtIJQHyM05m438 gnMxMNk49dgrp4CW2Yr8/gUU4fw5hTSgUgy2EZimJJD8rgTE3s5beKPVrcVHTtHSL3jvtjoGqsMbmq TfndmTXh8lsH2vKzmtDDrnzkFpjv9DTtF1V/jMcD+vtJw7PtzTJOGxxU75vQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds helpers for registering btf_id_set from modules and the
check_kfunc_call callback that can be used to look them up.

With in kernel sets, the way this is supposed to work is, in kernel
callback looks up within the in-kernel kfunc whitelist, and then defers
to the dynamic BTF set lookup if it doesn't find the BTF id. If there is
no in-kernel BTF id set, this callback can be used directly.

Also fix includes for btf.h and bpfptr.h so that they can included in
isolation. This is in preparation for their usage in tcp_bbr, tcp_cubic
and tcp_dctcp modules in the next patch.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/bpfptr.h |  1 +
 include/linux/btf.h    | 31 +++++++++++++++++++++++++
 kernel/bpf/btf.c       | 51 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 83 insertions(+)

diff --git a/include/linux/bpfptr.h b/include/linux/bpfptr.h
index 546e27fc6d46..46e1757d06a3 100644
--- a/include/linux/bpfptr.h
+++ b/include/linux/bpfptr.h
@@ -3,6 +3,7 @@
 #ifndef _LINUX_BPFPTR_H
 #define _LINUX_BPFPTR_H
 
+#include <linux/mm.h>
 #include <linux/sockptr.h>
 
 typedef sockptr_t bpfptr_t;
diff --git a/include/linux/btf.h b/include/linux/btf.h
index 214fde93214b..382c00d5cede 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -5,6 +5,7 @@
 #define _LINUX_BTF_H 1
 
 #include <linux/types.h>
+#include <linux/bpfptr.h>
 #include <uapi/linux/btf.h>
 #include <uapi/linux/bpf.h>
 
@@ -238,4 +239,34 @@ static inline const char *btf_name_by_offset(const struct btf *btf,
 }
 #endif
 
+struct kfunc_btf_id_set {
+	struct list_head list;
+	struct btf_id_set *set;
+	struct module *owner;
+};
+
+struct kfunc_btf_id_list;
+
+#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
+void register_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
+			       struct kfunc_btf_id_set *s);
+void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
+				 struct kfunc_btf_id_set *s);
+#else
+static inline void register_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
+					     struct kfunc_btf_id_set *s)
+{
+}
+static inline void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
+					       struct kfunc_btf_id_set *s)
+{
+}
+#endif
+
+#define DECLARE_CHECK_KFUNC_CALLBACK(type)                                     \
+	bool __bpf_##type##_check_kfunc_call(u32 kfunc_id, struct module *owner)
+#define DEFINE_KFUNC_BTF_ID_SET(set, name)                                     \
+	struct kfunc_btf_id_set name = { LIST_HEAD_INIT(name.list), (set),     \
+					 THIS_MODULE }
+
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index c3d605b22473..5a8806cfecd0 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6343,3 +6343,54 @@ const struct bpf_func_proto bpf_btf_find_by_name_kind_proto = {
 };
 
 BTF_ID_LIST_GLOBAL_SINGLE(btf_task_struct_ids, struct, task_struct)
+
+struct kfunc_btf_id_list {
+	struct list_head list;
+	struct mutex mutex;
+};
+
+#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
+
+void register_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
+			       struct kfunc_btf_id_set *s)
+{
+	mutex_lock(&l->mutex);
+	list_add(&s->list, &l->list);
+	mutex_unlock(&l->mutex);
+}
+EXPORT_SYMBOL_GPL(register_kfunc_btf_id_set);
+
+void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
+				 struct kfunc_btf_id_set *s)
+{
+	mutex_lock(&l->mutex);
+	list_del_init(&s->list);
+	mutex_unlock(&l->mutex);
+}
+EXPORT_SYMBOL_GPL(unregister_kfunc_btf_id_set);
+
+#endif
+
+#define DEFINE_KFUNC_BTF_ID_LIST(name)                                         \
+	struct kfunc_btf_id_list name = { LIST_HEAD_INIT(name.list),           \
+					  __MUTEX_INITIALIZER(name.mutex) }; \
+	EXPORT_SYMBOL_GPL(name)
+
+#define DEFINE_CHECK_KFUNC_CALLBACK(type, list_name)                           \
+	bool __bpf_##type##_check_kfunc_call(u32 kfunc_id,                     \
+					     struct module *owner)             \
+	{                                                                      \
+		struct kfunc_btf_id_set *s;                                    \
+		if (!owner || !IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES))      \
+			return false;                                          \
+		mutex_lock(&list_name.mutex);                                  \
+		list_for_each_entry(s, &list_name.list, list) {                \
+			if (s->owner == owner &&                               \
+			    btf_id_set_contains(s->set, kfunc_id)) {           \
+				mutex_unlock(&list_name.mutex);                \
+				return true;                                   \
+			}                                                      \
+		}                                                              \
+		mutex_unlock(&list_name.mutex);                                \
+		return false;                                                  \
+	}
-- 
2.33.0

