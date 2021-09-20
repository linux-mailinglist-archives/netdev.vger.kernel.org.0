Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAFDD41169A
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 16:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237080AbhITORM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 10:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236770AbhITORI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 10:17:08 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94EDC061762;
        Mon, 20 Sep 2021 07:15:41 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id m26so16410412pff.3;
        Mon, 20 Sep 2021 07:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JQzJbmsNcTyJiM7wxqK/N5d0ieXGaf7vJrciuGA2fl4=;
        b=QCA+QVyrDpBByGTJltTbMn9R+X3N7Uq/Yo44UsMvGfbptJbdK1GSFreCIcqbekvN0n
         vuiHnPwUUp5k+atiV5ct4Z0QwZLLdHDSkihDEmG7IWvOv7pNnaV4V5veBJfk5XItHrbQ
         uWyXPk5TFrJuM4lwSXhNHN+/ntUknktHHan7b/W5Zv0klz+Snyp9qAqPw8xibWR0SNeO
         bUO3Wck3pmi+SzkuO4SsRxQWBis2ZJUc6z94fw2h4y2y7ls3lktXEQNcYs84XXgzOsFD
         rgLQcFOelGPgfbMg5mK9Rt149FwKOj9m2fMOkfy08zhkQWr2g4cqH/6HCIoaDt6983Rz
         dngw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JQzJbmsNcTyJiM7wxqK/N5d0ieXGaf7vJrciuGA2fl4=;
        b=Fy71rL3KukLSLixnCNfUoweseU+fawH4o/2NglcklISd8+OsK1oizRodmkFA3c3GDL
         MWGdLIunL5aWe0lBYyKS9cALTLroqRUU2C3g/xeDZ2c3M5NunK2qoMgc+APHeEY64lKG
         fLIFdSADhXiafq54OSN6p8oUCYQpaXVFK6Go1dGxtyHO/3wVIx/XRdWfiNtcQFlbqokF
         X6HJLOXNCW8Zyh0jQFR0YeawNlTYVY+vdWAaF2Piknc/2+OCLI+n68qgGumFjJAwWB5d
         URVSPlnrVNaUtfN7gGYR8Fe5hJOV6PRGK+1XQrEjJ6gmULaPUzaQ/66mVvF5w08AszGH
         Q4qg==
X-Gm-Message-State: AOAM530V4ISc0njRee2e36rGzy3UxnFnkwA1DrkAxc5xUSqOKV3Da4/B
        BW4HXQnn1RxzZY6LAIVwf92LHHK9P5BuJg==
X-Google-Smtp-Source: ABdhPJyi9GGX+6pvRGJFtnDHGljIQcWkjfUveZfEOZ9Dq7TDkT78nj9Iet7jq5Ufj7Q9spsrbon7tQ==
X-Received: by 2002:a63:6f82:: with SMTP id k124mr19176982pgc.218.1632147341090;
        Mon, 20 Sep 2021 07:15:41 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id y80sm9946310pfb.196.2021.09.20.07.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 07:15:40 -0700 (PDT)
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
Subject: [PATCH bpf-next v4 03/11] bpf: btf: Introduce helpers for dynamic BTF set registration
Date:   Mon, 20 Sep 2021 19:45:18 +0530
Message-Id: <20210920141526.3940002-4-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920141526.3940002-1-memxor@gmail.com>
References: <20210920141526.3940002-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4928; h=from:subject; bh=vv7OxTBJcY0m6TE2e5nTlXV2ed0AWIV5lzxY9L0vytY=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhSJaDMM+KYhyuQojuYIX8o5xbBorPLN8l61XoA6Fp vU0g7q6JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUiWgwAKCRBM4MiGSL8RymAxD/ kBFsQBrAoxKBiOKIBmETDTOz6YbOC+KOaq8ReKuSdz882gbIMmedbZRunxbH4KArKcV+AZXTzOEJfa s66hC58mOhx1Ii4Hykg/nM6v/h0lPWFM6sAr9ax+dNpWXMFLlMa6qLA5JQ8ciaPBadv71/1N/wqi++ pCi3k4WvWvMI+MGm8zAcGo+IWrsk8mQ/ZG3tcK6+HUjWaGBL8gEF+KzDT3ubonolFZcA3ED7kH/Xfk VsmU0QZQjbLZl06F7vNM5JixNs2KyWyO2Odgp84HkLaAvdRrNoV5OMA9VyWZPxpO520KqXAWpyeIer XSew5U7gKdLwhkTzG+7s9NZOAwNdmtazodpQWnyC4LzmRevNAc7mea88UADtSPIDXrXew4YhTxwGsp RQcR8abtbp8w2UkEFrpyCFJk/K2MCzcikif40p527brK4U13x7er2VjZBILCqt4Sr8Ni6PcHKYx6hF 7HZJqWKJ0EUi1WAFthgo2fBjcKR5g4k4Ntzf8U2nZ/06iWfulKkvRp3RENrS/e+H3IEWpmbnM59qQI /vUNIMFUm5FmRPdOxmDkj7tprKEArwa1f6uGceIDczxJmS75pPazayQ0ok5B/HenxvlHUv5K8pDdU1 sM3oQhU0z1LP7OB3ANaKc2GF6q1f2Lx2YCSNiNZA15zmhniaDf/j6WBUFVjw==
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
index 214fde93214b..7884983857d9 100644
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

