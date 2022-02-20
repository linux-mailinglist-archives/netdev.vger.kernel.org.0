Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8334BCEC2
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 14:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243897AbiBTNtQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 08:49:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243893AbiBTNtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 08:49:05 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BEA2D1EA;
        Sun, 20 Feb 2022 05:48:44 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id v8-20020a17090a634800b001bb78857ccdso14208793pjs.1;
        Sun, 20 Feb 2022 05:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tRgersc7+YiHsFoqjkDw4Ohre3w5vPK2wp9oy5KJBzI=;
        b=gmMjHzzthS+Pc8+pZwqt44EjB3kst7Y1OcDKz4vCjRs/4jNcP0oHae8quxqX+cEQOx
         Fw1T9wpe9qXc6KuK8FmuKfFy5nbzy0p1uQ4MMspodbiz6o9hmEBtGDaDAx7BiOHEWsz0
         HgAF14kep+RfALD8EewfXDs5InzNL7j1ewIaVm3isMo3tJkNx+CarcakDIeOouyq5/94
         bHYZh8ADNFJ2F/JP0gK5ZZVyAUachPhf4c+9W5J8jIRdfhusoHh8ikH0I/p2eRp1imkP
         tMW9OYTR/8tY6D+YFTb3h3Vr94lCbiboBDquHRtf5DPTjugsaZ2CnYkiOMFDsBMo4kII
         XFjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tRgersc7+YiHsFoqjkDw4Ohre3w5vPK2wp9oy5KJBzI=;
        b=HeQNSwoN96QobCzp+/hfx3G8PKg9zIyi78HLRwtDXjXw8Adp4nXyQPlM2gV8a/hJMF
         DwiCGbfLcKO5S4QorquqocUHFMnnMs5nFY+qFuA33vzd5aKWq7cwyRv4EBrzV6E/dSkq
         C4tlTY0a3ebBaCD2eNl5vSTnzYkp89XusQ7mGPkPNmqBQVqz91YRiKqhzjefUQ+arPyo
         Hw/hHZxKN3G5MCI1UjKqS/5XnKwgUjXuNY5zcM6eEMkCOG+Zv+ewX1Ix2aLRt0IrJ3Kf
         jC9ibPgavP+GOljIctG0WDBeUC9kLur/scB9g2P87L3axlVwqnKIN0RdEavSqReX43RN
         DZ0g==
X-Gm-Message-State: AOAM5335nwMfa49zv2a1B4oTMdU9ikS3b9jasydCFFSTMhz+4l8hF0/R
        4cnbFCKiMXHWjfp6c5unvJQJ3YC4iJo=
X-Google-Smtp-Source: ABdhPJyOETrW6jI5qRGlR7NC506DjIBk1zKstL63YLIIcRI89gS37xcbOIJ4hYWpCBzWjCoGkNp0hw==
X-Received: by 2002:a17:902:8497:b0:14f:919:9fdd with SMTP id c23-20020a170902849700b0014f09199fddmr15431878plo.52.1645364924085;
        Sun, 20 Feb 2022 05:48:44 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id q9sm9921393pfk.31.2022.02.20.05.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 05:48:43 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 09/15] bpf: Populate pairs of btf_id and destructor kfunc in btf
Date:   Sun, 20 Feb 2022 19:18:07 +0530
Message-Id: <20220220134813.3411982-10-memxor@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220134813.3411982-1-memxor@gmail.com>
References: <20220220134813.3411982-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6298; h=from:subject; bh=bEtsOEx3UKJJcW3J592imsq8QQaOzR84HSnwrs6Zyzo=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBiEkZY0debdctwSyfadfikEkSTZaceVwjMv9F6SfUe R4rLvMKJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYhJGWAAKCRBM4MiGSL8RymWLD/ 4kKQgF/G8Wx42sO4kS/V3jpxqvYE5QJIbwOrmxPXwqD5WuFUn1/Eq1cmaBdfwZ3bhxhTMxzuD923a9 ZLWRotwtCxo5BpyvVH0la4PckOrGvKqPISQbLNGzjt2ZQ7dHpi7QOcX4yrUggm+YN6G6NUBwi0Fj6W 5Eq9Fg6QdfVHep/V8Y6HdR7QfZ7ARw0isopS/3yGqvMrQjxciTinJveVqlXoe1dDAxcOG4kJ/B/qcG AI5KEt5hseY0ESGJU72iX2sEQouljLIOIowIyQkrGBBTq+qmXOHAlGc3L3eYFOmJ403zwE5nyMXQR4 OEvNqNqf9dCu/Hczet7DWBs6roQxPJ4UxUlJ1gsisUc2HHLc2PeIJOIQql7fLOUlEFBbFVGVx+wupt NIYzPruSd3DVj0SmSg8Jy0nVQte4Bt+aj68xlisWrGoRE1z2dzWI/kzqqjGD2m+kCAyx42wConwiV7 /c6rUZSOAZ4gxteVnkvoBuEmzOZlxcRdk/3UB7dqWtsWOg4eu1V3QrPJlnkxLfw2f9w76mIKFdTOIi s0mhmSJwKJe5uLq6eoDCnJePvktVbynmfJa+AyJlZEOJW/bIOmF9YQFedNJJHnM4wuAr7UOPbdX18m wdzwv2r6r1s29Bw5lrxdQxrqdRTqhkWWyicnNlzBAA6eDShpZXPbqcORQwbA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To support storing referenced PTR_TO_BTF_ID in maps, we require
associating a specific BTF ID with a 'destructor' kfunc. This is because
we need to release a live referenced pointer at a certain offset in map
value from the map destruction path, otherwise we end up leaking
resources.

Hence, introduce support for passing an array of btf_id, kfunc_btf_id
pairs that denote a BTF ID and its associated release function. Then,
add an accessor 'btf_find_dtor_kfunc' which can be used to look up the
destructor kfunc of a certain BTF ID. If found, we can use it to free
the object from the map free path.

The registration of these pairs also serve as a whitelist of structures
which are allowed as referenced PTR_TO_BTF_ID in a BPF map, because
without finding the destructor kfunc, we will bail and return an error.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/btf.h |  17 +++++++
 kernel/bpf/btf.c    | 109 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 126 insertions(+)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 6592183aeb23..a304a1ea39d9 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -41,6 +41,11 @@ struct btf_kfunc_id_set {
 	};
 };
 
+struct btf_id_dtor_kfunc {
+	u32 btf_id;
+	u32 kfunc_btf_id;
+};
+
 extern const struct file_operations btf_fops;
 
 void btf_get(struct btf *btf);
@@ -347,6 +352,9 @@ bool btf_kfunc_id_set_contains(const struct btf *btf,
 			       enum btf_kfunc_type type, u32 kfunc_btf_id);
 int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
 			      const struct btf_kfunc_id_set *s);
+s32 btf_find_dtor_kfunc(struct btf *btf, u32 btf_id);
+int register_btf_id_dtor_kfuncs(const struct btf_id_dtor_kfunc *dtors, u32 add_cnt,
+				struct module *owner);
 #else
 static inline const struct btf_type *btf_type_by_id(const struct btf *btf,
 						    u32 type_id)
@@ -370,6 +378,15 @@ static inline int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
 {
 	return 0;
 }
+static inline s32 btf_find_dtor_kfunc(struct btf *btf, u32 btf_id)
+{
+	return -ENOENT;
+}
+static inline int register_btf_id_dtor_kfuncs(const struct btf_id_dtor_kfunc *dtors,
+					      u32 add_cnt, struct module *owner)
+{
+	return 0;
+}
 #endif
 
 #endif
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index bafceae90c32..8a6ec1847f17 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -207,12 +207,18 @@ enum btf_kfunc_hook {
 
 enum {
 	BTF_KFUNC_SET_MAX_CNT = 32,
+	BTF_DTOR_KFUNC_MAX_CNT = 256,
 };
 
 struct btf_kfunc_set_tab {
 	struct btf_id_set *sets[BTF_KFUNC_HOOK_MAX][BTF_KFUNC_TYPE_MAX];
 };
 
+struct btf_id_dtor_kfunc_tab {
+	u32 cnt;
+	struct btf_id_dtor_kfunc dtors[];
+};
+
 struct btf {
 	void *data;
 	struct btf_type **types;
@@ -228,6 +234,7 @@ struct btf {
 	u32 id;
 	struct rcu_head rcu;
 	struct btf_kfunc_set_tab *kfunc_set_tab;
+	struct btf_id_dtor_kfunc_tab *dtor_kfunc_tab;
 
 	/* split BTF support */
 	struct btf *base_btf;
@@ -1572,8 +1579,19 @@ static void btf_free_kfunc_set_tab(struct btf *btf)
 	btf->kfunc_set_tab = NULL;
 }
 
+static void btf_free_dtor_kfunc_tab(struct btf *btf)
+{
+	struct btf_id_dtor_kfunc_tab *tab = btf->dtor_kfunc_tab;
+
+	if (!tab)
+		return;
+	kfree(tab);
+	btf->dtor_kfunc_tab = NULL;
+}
+
 static void btf_free(struct btf *btf)
 {
+	btf_free_dtor_kfunc_tab(btf);
 	btf_free_kfunc_set_tab(btf);
 	kvfree(btf->types);
 	kvfree(btf->resolved_sizes);
@@ -7037,6 +7055,97 @@ int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
 }
 EXPORT_SYMBOL_GPL(register_btf_kfunc_id_set);
 
+s32 btf_find_dtor_kfunc(struct btf *btf, u32 btf_id)
+{
+	struct btf_id_dtor_kfunc_tab *tab = btf->dtor_kfunc_tab;
+	struct btf_id_dtor_kfunc *dtor;
+
+	if (!tab)
+		return -ENOENT;
+	/* Even though the size of tab->dtors[0] is > sizeof(u32), we only need
+	 * to compare the first u32 with btf_id, so we can reuse btf_id_cmp_func.
+	 */
+	BUILD_BUG_ON(offsetof(struct btf_id_dtor_kfunc, btf_id) != 0);
+	dtor = bsearch(&btf_id, tab->dtors, tab->cnt, sizeof(tab->dtors[0]), btf_id_cmp_func);
+	if (!dtor)
+		return -ENOENT;
+	return dtor->kfunc_btf_id;
+}
+
+/* This function must be invoked only from initcalls/module init functions */
+int register_btf_id_dtor_kfuncs(const struct btf_id_dtor_kfunc *dtors, u32 add_cnt,
+				struct module *owner)
+{
+	struct btf_id_dtor_kfunc_tab *tab;
+	struct btf *btf;
+	u32 tab_cnt;
+	int ret;
+
+	btf = btf_get_module_btf(owner);
+	if (!btf) {
+		if (!owner && IS_ENABLED(CONFIG_DEBUG_INFO_BTF)) {
+			pr_err("missing vmlinux BTF, cannot register dtor kfuncs\n");
+			return -ENOENT;
+		}
+		if (owner && IS_ENABLED(CONFIG_DEBUG_INFO_BTF_MODULES)) {
+			pr_err("missing module BTF, cannot register dtor kfuncs\n");
+			return -ENOENT;
+		}
+		return 0;
+	}
+	if (IS_ERR(btf))
+		return PTR_ERR(btf);
+
+	if (add_cnt >= BTF_DTOR_KFUNC_MAX_CNT) {
+		pr_err("cannot register more than %d kfunc destructors\n", BTF_DTOR_KFUNC_MAX_CNT);
+		ret = -E2BIG;
+		goto end;
+	}
+
+	tab = btf->dtor_kfunc_tab;
+	/* Only one call allowed for modules */
+	if (WARN_ON_ONCE(tab && btf_is_module(btf))) {
+		ret = -EINVAL;
+		goto end;
+	}
+
+	tab_cnt = tab ? tab->cnt : 0;
+	if (tab_cnt > U32_MAX - add_cnt) {
+		ret = -EOVERFLOW;
+		goto end;
+	}
+	if (tab_cnt + add_cnt >= BTF_DTOR_KFUNC_MAX_CNT) {
+		pr_err("cannot register more than %d kfunc destructors\n", BTF_DTOR_KFUNC_MAX_CNT);
+		ret = -E2BIG;
+		goto end;
+	}
+
+	tab = krealloc(btf->dtor_kfunc_tab,
+		       offsetof(struct btf_id_dtor_kfunc_tab, dtors[tab_cnt + add_cnt]),
+		       GFP_KERNEL | __GFP_NOWARN);
+	if (!tab) {
+		ret = -ENOMEM;
+		goto end;
+	}
+
+	if (!btf->dtor_kfunc_tab)
+		tab->cnt = 0;
+	btf->dtor_kfunc_tab = tab;
+
+	memcpy(tab->dtors + tab->cnt, dtors, add_cnt * sizeof(tab->dtors[0]));
+	tab->cnt += add_cnt;
+
+	sort(tab->dtors, tab->cnt, sizeof(tab->dtors[0]), btf_id_cmp_func, NULL);
+
+	return 0;
+end:
+	btf_free_dtor_kfunc_tab(btf);
+	if (btf_is_module(btf))
+		btf_put(btf);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(register_btf_id_dtor_kfuncs);
+
 #define MAX_TYPES_ARE_COMPAT_DEPTH 2
 
 static
-- 
2.35.1

