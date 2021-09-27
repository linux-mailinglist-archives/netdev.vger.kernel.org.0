Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131004196EC
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 17:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234993AbhI0PBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 11:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234946AbhI0PBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 11:01:33 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2660C061575;
        Mon, 27 Sep 2021 07:59:55 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id n2so11938776plk.12;
        Mon, 27 Sep 2021 07:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SmxgKFkRGgoEqMaY9cRCsw185bTTD612fO7JwVu7FH4=;
        b=VA9pGzY0DZzQWDCEaO9RV3nzCNCQmqT4UeUMb5vwXtUYFzwe/K9EoWaV7NaUkJBcR1
         qcS3Ql1Xhk7+wxc2BixmM2THku/82RwqJpNO9Df99/YsNy3BRrLufO113RssGXnccd8l
         s6rBYGiRIoilQyMT2/LIrCXfdsq2CXkX+8rvJPVR0IABaatpayEB9E3TRF4XoFMs9UaB
         UlfkLqVnmZ+4sTa/5/vNmlkMNeZIUU+cyCxTTMTJGC8BOblWoqDOZFf4F7s6NNb0cn4j
         gbKnhuoEujkfdJX+CMCJPXU+QwHxrKEWETvGdP4BpoENZ6cC0KQB3MKX0LTNkqXMs5lF
         hmDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SmxgKFkRGgoEqMaY9cRCsw185bTTD612fO7JwVu7FH4=;
        b=DSCPmNHUwaL1MGAHn+Na+QDA43ng2t6qk9TG1rZ0PCaaZpmYT5RqnMcxUQ9Hu161Gy
         qnLbnzo7Hw4lkXLn3Mu9LJVzd6sN32VjWbEclpbe91/LHdPUu70ec3Ubvi204KOu2rhz
         sh3C3wfLW2oDoJ4sx96WaIHQspPJDR7nZNMH9FH1vSwo1SFwgfTcvPecWtELoRuP6pTS
         HPZEJb8OZPCpAdxQSG53UkpFTquyLtwltjdWNZBPrTLdK2U7YQwhrszcqRJtDfvayrnP
         /UlZktWhJOGbrqNFbq6wejR+4YvFiHAtTnZcTSBz6U8eZ1Wfb7trfAjvITQ1rRl/NEhF
         1wZw==
X-Gm-Message-State: AOAM5316dGuZCAO56geHgu8ArOPSMdhTqoDZqw87aR6GdGumARSLPZsI
        TklQhcDVbCQAC77/unsOCWwDA1LwZGE=
X-Google-Smtp-Source: ABdhPJzDVdiEcWtO5KkQjafkHz6RzL2hqGNX61ORC3ZPJZ0/uRuZN0cAh2BY+/yKrfbsNu0KS9OqRQ==
X-Received: by 2002:a17:90a:6708:: with SMTP id n8mr20185101pjj.219.1632754795121;
        Mon, 27 Sep 2021 07:59:55 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id 77sm17224443pfu.219.2021.09.27.07.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 07:59:54 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v5 03/12] bpf: btf: Introduce helpers for dynamic BTF set registration
Date:   Mon, 27 Sep 2021 20:29:32 +0530
Message-Id: <20210927145941.1383001-4-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927145941.1383001-1-memxor@gmail.com>
References: <20210927145941.1383001-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4928; h=from:subject; bh=Z49+ZfOJfNIcBx7xGCBn4+PTlYIzy90X8Bk3C1i1vSo=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhUdxOfrZyWFi8bHU8zOBS4ia5K3qEpJqBiICjwsXY NqOXh4SJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVHcTgAKCRBM4MiGSL8RygSYD/ oCcHLqCOnw9Jn0rR+yajvlJiOXz09bELbVSG6cPjUykyJCh+ats9huCNKk2tqr6GB4BTBuz6tskaj0 I7233A+iWV1aTwYt8xCA1Ynpj25Ywf8yo+PCWp2XlaZevGWScX3XoUj7BFvRBkH6TbDnAoOOoYTUdt otHuJhplVbmy/37YirzCo3rZyVa2YokxehDvWzgTrN6O5TexJkAxRGBza9yDfIqGUJIx0oOTMAMTj+ Zmx9LeU6UNgcg4fjV18nRf36Bu/xdppJwrsuGVEpLH8bVmQM06KqGm2AIKDLh0jH7eb2Uhb4KQ4h0J J5e+Ep2ZmedAfA13QN/jkNVh/TNZb94sVNahRfYkOUiFVY6doKKHACpH4Ntfy1eKe2pwxgXgjqgpVy KJWdN3B9h6RtvknScOFgI1gHoO/vjTJviv/H6ZrdPZsq/anqf+6WQ9Y2eN6YI1+/d46L0iHUp5G/WK qavbkdGqIZGoz0vvohNevNnjvsM11GjUHS4ZmPKyGQ8qc29J9muJZt6sl6A2a6q05ephHtjvrKoVQk BIjV32qpMa9hNzujgakAC1y0VWUZIzKn1q7EGTIWtz8aNCsO5VUXha0q5VpgnAGmxRLG+hqTpLzK3q pf+oDRWZO6JOA5WLGBe67iTMDBSnZX+iqqEB9h+iOGINuEGku4e0VrBUsmCw==
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

