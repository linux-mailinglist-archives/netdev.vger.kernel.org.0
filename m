Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7C940BF28
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 07:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236217AbhIOFLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 01:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235806AbhIOFLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 01:11:16 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1605AC061764;
        Tue, 14 Sep 2021 22:09:58 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id t20so1300732pju.5;
        Tue, 14 Sep 2021 22:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hFzji/ML/N9X7kNxTQiBpHNfDWFkWIIw8KLpiz32rk8=;
        b=e34w/aHHbi2jcnvwKIFDFkA6Ex/XypyClH99JcK8DgI7HS5BlWqN2JGSp9oezqGZls
         UCHvZ2KkHzhg4CXX9ixT6zJbUeheKsQ+koESe/ImujzG0SvTerJ3BfmyvUwMOB4GSTbx
         RYXtRkkhDvZczZoNIVaZkd7e187PttTXBTljB/+ox/3lDJ7GT78oQkaUgbIB+dnbcCKg
         JZMAPhIGynbWGMjYa+8FPutBvmVevzgJ4+LXI2wMKjGa7Cnjbst2KUGIXrFqePB0rT7k
         qtKmqT/bbvZC2VpldEKc4j8uwGyrfimCGSWD5GiIEza9izn1oniNJZKnerD2gWbOaTee
         PncQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hFzji/ML/N9X7kNxTQiBpHNfDWFkWIIw8KLpiz32rk8=;
        b=cu1BzTcctAAgv4hJUwl5EfSuQGmJX0FudGBEI5Ol1gQYoFJCC5vcBmaphRUZm67KNk
         YG1B4K1DEwOMsfXPI+lRCclIESu1oJ+762QxmSVjePKZ6+kOkPFHgwcHXp7XK9qq/oWq
         Hnm4T8GzYe+2km1SJJ2RqVO7ve3g6QoxPHHvQP6jiVDnh84pYzykxvptZ7Y1U/3OFMKx
         jkKm1IWrZaf6nXC6kylfQuC2NwKX/mhABjsHXzpbubecajjNSURX3SyxmIGe09r/3pOc
         TRuuJ4rD/xY6tKErnhCZZH/Wc7BnxOnNEd1+ytcbcpr8MxHv7XnunAESC3TPTu/WR23q
         qd3A==
X-Gm-Message-State: AOAM530muYjgJV8BvE2k+rhBjzJmtHZ71PxV4PK1hClut7IqZ8A+zvEv
        ivXA7r86t0sRmOxqkGIx6oCfbWzFw8y4nw==
X-Google-Smtp-Source: ABdhPJzw0xYjPBfNApyZ2eL4wGAU9wSKeHhjLUviaFwr2CX6tlN94m2HzLg3nv3CdCIkG4PxwBFVuw==
X-Received: by 2002:a17:90b:383:: with SMTP id ga3mr6294477pjb.72.1631682597479;
        Tue, 14 Sep 2021 22:09:57 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id b20sm7572292pfp.26.2021.09.14.22.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 22:09:57 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 03/10] bpf: btf: Introduce helpers for dynamic BTF set registration
Date:   Wed, 15 Sep 2021 10:39:36 +0530
Message-Id: <20210915050943.679062-4-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210915050943.679062-1-memxor@gmail.com>
References: <20210915050943.679062-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5061; h=from:subject; bh=m8fXSGEm0/XSIbkC12+3PP6uKRh1g+Ip6wRNtdVKH7g=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhQX4bKtLF9C/vBW3tp+ns5ExsjPWzaQ06bPFUtoxh r1W8J3aJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUF+GwAKCRBM4MiGSL8Ryg27D/ 9PcJ+gtbxuCZcjVgqQqCzVfS20iicP+Omr7PIbePMWq1kPFBUGvfgY2EHqGommShDTQwmgYdWv8qoZ W0b5UplycSu2D2qV/0e3JaH/8hZzBpWpbok2GSBId82RbzJwAD/m+F6hyU5Lpz5Ehv5hac5djtalXm kNyUwrd80eMkLxRoaKVy1upAYFYR4kT184YVkzUM9gKCkeNdO496Fa+ULDnqBvkSuGfkNBx3EnFoPI dKXSF77+A/OrHU3xbnqOJjRiAXvX4OUAS0S/amlLIUa0qxll3+tXe80vgfKftSCBLad37quutVpoW6 H8iIxFrhhhVhLr7sad14NFLfmoJyAayusMMD2HrulqaDvldhzAXVs6o4lHEy6dO3oh7rwJyFhoWgVh DKWLB5uOc4lfAV+KTEf5hmTu0dbwaaFAqTbz+TIc8/YPkci7ajw/aSfcxfvFJKBTL17QM2p+XfravN 91q29umf0GBMFMbKj5+/gkLzRkO2MQOPfAmM3jseKJ640edZXnTH17KtarThEyedzdDtxla4/Eq2Hl Pw8aEvAoCZgax7Bxx5ZBrnUaSj5DLSW3xs38KxaEJuWcEqfojvu+FpQnJQx8NpQMA5uSIOnkon8tBX craTGG/PWbN/aM5wboRhqMtknoS6XgrTerSXvmvZZQsP7txuPr5Aw50rLkGw==
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
 include/linux/btf.h    | 32 ++++++++++++++++++++++++++
 kernel/bpf/btf.c       | 51 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 84 insertions(+)

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
index 214fde93214b..e29a486d09d4 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -5,8 +5,10 @@
 #define _LINUX_BTF_H 1
 
 #include <linux/types.h>
+#include <linux/bpfptr.h>
 #include <uapi/linux/btf.h>
 #include <uapi/linux/bpf.h>
+#include <linux/mutex.h>
 
 #define BTF_TYPE_EMIT(type) ((void)(type *)0)
 #define BTF_TYPE_EMIT_ENUM(enum_val) ((void)enum_val)
@@ -238,4 +240,34 @@ static inline const char *btf_name_by_offset(const struct btf *btf,
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
+	bool __bpf_check_##type##_kfunc_call(u32 kfunc_id, struct module *owner)
+#define DEFINE_KFUNC_BTF_ID_SET(set, name)                                     \
+	struct kfunc_btf_id_set name = { LIST_HEAD_INIT(name.list), (set),     \
+					 THIS_MODULE }
+
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index c3d605b22473..d17f45b163f5 100644
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
+	bool __bpf_check_##type##_kfunc_call(u32 kfunc_id,                     \
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

