Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D284818A1
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234948AbhL3ChN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234954AbhL3ChM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:37:12 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C55CC06173E;
        Wed, 29 Dec 2021 18:37:12 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id jw3so20109132pjb.4;
        Wed, 29 Dec 2021 18:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WqchcWlbvaJiMCyDwxWQjOR0/GcpQ3iKuHlAIdehbYQ=;
        b=ZhqS59cd/XVl9GnV5N/8JeagABDkvptxLmpwPex+QglGo/Y5TEPAT29Kx9LvOVpM9M
         xbJ/89uF6C19+aGJ8A3aJIdEVO8Ydaeu/LznuWNpidyscqBuXa3fKHvC7kMp3ASFO2ea
         bcqy951ZgSKZUI14S3Is5WkgSJcDx4fsCPaEw3PsfkaV4g5FUgMNMRFETpsxzwS+AJnO
         c/k58sUGEIOo/gMTSRIOc+yyAaUD5MRKcYrmPWnuQxa4QCKfBJ5ijYvyNuvw4Ucofm1F
         k8VjS0XrpnVGB0VWAZ+Dxd9zvkHHi6Z2SJx4z2+6YoQTO22J34+Jhb0/shKUOrB3UNKF
         rNlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WqchcWlbvaJiMCyDwxWQjOR0/GcpQ3iKuHlAIdehbYQ=;
        b=Tlyi8gzDaYrjNwsO8rzBljV7YAe9X6HFQ/ANZt46guiYiENlYNyc8fOsHHqeLjDf+b
         /516QXJmBhPz1fxzjs7ctNs2jGsr03msTVaAJDRobYN+EJl7xxHoVqxquKcv7GxV9qgC
         YX2sDth8/YOT0N9NpKiJ+f3qcwT7mz9f29inhqr04cD4sd271xpmVlsx6K0l1yFc2Nic
         WQD9ZFzRy/f4H2vPPaQa6edaqFVzDzhMZa11rXRCB9T+Y5roCg31CBdtgsBKpp4Ce6VN
         BRYCzH0vnFc8MKcnnOT7hSfEBh3/A34UaiH0G8wNLTnFq31gnEL5HqZ2kPeNv60H7d14
         9wnw==
X-Gm-Message-State: AOAM5327WueF8gVRU3uVD+a7WTZa4TX9Qb0f5+1wwE8I/jwfAE5ml6SX
        yhRIqox+9UjmryS3v+uHZZRHUTNy8c4=
X-Google-Smtp-Source: ABdhPJyR+kYQYhQesQrf8KTpf6IoX5zRUqGjqiRQUyRVMQDhZ12bg0Ir0lSNhkLeUy6nY/PmACocfA==
X-Received: by 2002:a17:90a:f196:: with SMTP id bv22mr35404738pjb.155.1640831831761;
        Wed, 29 Dec 2021 18:37:11 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id m19sm16278628pfk.218.2021.12.29.18.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 18:37:11 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Luis Chamberlain <mcgrof@kernel.org>, Jessica Yu <jeyu@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v5 1/9] kernel: Add kallsyms_on_each_symbol variant for single module
Date:   Thu, 30 Dec 2021 08:06:57 +0530
Message-Id: <20211230023705.3860970-2-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211230023705.3860970-1-memxor@gmail.com>
References: <20211230023705.3860970-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7381; h=from:subject; bh=Z2gVj3CyJUSVCFv1Fr4au3IxZSNG7JGNTmJdS63wkeo=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhzRr9KlLOXO1ADXCH0Z4O5pMW2DOEa42+qTM6Q7Jb TWHTNpKJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYc0a/QAKCRBM4MiGSL8RygunD/ 9uqeoN09LpeS8F1gmlVBxtmMVKAciGbZyp0/U6J+QHFCxnn/6d6APNNaVosJgqqAu0SpqH7T64R5bU wYdHiVLi8Z2LX3u7X64SihP+IX3jglU1UOSCxgJay6vddrFYzhKhNHyzDZxtn+S6eqtDLyxqeSF1cC RP4KyX2Tmm1JWskLGpnBux8njaydMMJiHb2JtoGXkX4nSsf4NkAZVA4R8OvJbd9unQzmjibJCk3frD YhxhNY75iVzBPx7ooJEpgHom9oIb23LaWfgeUohHF0tZ37TgpxfsNLyOelhJUrDNzy4e18VWQeBMhV RNcieTnRo9aE8aDWXtQLZDdshKgQL3zEAZdvVEGiwGQ9QnJmcLksjGO5mosKXQcPc0yKqd1gOJTg8X 910T9+Y823JppEODjTZ3xmz6aa824oTyYWhAy7NGQWth8SrY6AHWSR1Sv6RRQYFICIVW1BDmpYxJkt Z8w7z6cx1irZaDL4Nw0o5gLU7V/ZWXryUqdbTObDkO2/FQ8Zw/fwm7NxGpP18rHux/uDaEN7RYfpDD v3YMAPY7c4hxk4TPtW3JU9Y8rw4BMZoyE5AjhONrFB3fXWIQdEPQXHx3fD2QQWgpgee+FAB6UJsIYJ IkeMReaMt6J6glMYmYg2jNUfPASg97Bmk7bAVd33REGrDAgFQ31gAVozn5HQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The module_kallsyms_on_each_symbol function iterates over symbols of all
modules. To implement BTF ID set processing in each module's BTF parsing
routine, we need a variant that can iterate over a single module's
symbols. To implement this, extract the single module functionality out
of module_kallsyms_on_each_symbol, and rename the old function to
module_kallsyms_on_each_symbol_all.

Then, the new module_kallsyms_on_each_symbol which iterates over a
single module's symbols uses this extracted helper with appropriate
locking.

Next commit will make use of it to implement BTF ID set concatentation
per hook and type.

Also, since we'll be using kallsyms_on_each_symbol for vmlinux BTF
parsing, remove its dependency on CONFIG_LIVEPATCH.

Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/kallsyms.h | 11 ++++++-
 include/linux/module.h   | 37 +++++++++++++++++++++++-
 kernel/kallsyms.c        |  4 +--
 kernel/livepatch/core.c  |  2 +-
 kernel/module.c          | 62 ++++++++++++++++++++++++++++++----------
 5 files changed, 95 insertions(+), 21 deletions(-)

diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
index 4176c7eca7b5..89ed3eb2e185 100644
--- a/include/linux/kallsyms.h
+++ b/include/linux/kallsyms.h
@@ -65,11 +65,12 @@ static inline void *dereference_symbol_descriptor(void *ptr)
 	return ptr;
 }
 
+#ifdef CONFIG_KALLSYMS
+
 int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 				      unsigned long),
 			    void *data);
 
-#ifdef CONFIG_KALLSYMS
 /* Lookup the address for a symbol. Returns 0 if not found. */
 unsigned long kallsyms_lookup_name(const char *name);
 
@@ -98,6 +99,14 @@ extern bool kallsyms_show_value(const struct cred *cred);
 
 #else /* !CONFIG_KALLSYMS */
 
+static inline int kallsyms_on_each_symbol(int (*fn)(void *, const char *,
+						    struct module *,
+						    unsigned long),
+					  void *data)
+{
+	return 0;
+}
+
 static inline unsigned long kallsyms_lookup_name(const char *name)
 {
 	return 0;
diff --git a/include/linux/module.h b/include/linux/module.h
index c9f1200b2312..e982aca57883 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -867,8 +867,43 @@ static inline bool module_sig_ok(struct module *module)
 }
 #endif	/* CONFIG_MODULE_SIG */
 
-int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
+#if defined(CONFIG_MODULES) && defined(CONFIG_KALLSYMS)
+
+#ifdef CONFIG_LIVEPATCH
+
+int module_kallsyms_on_each_symbol_all(int (*fn)(void *, const char *,
+						 struct module *,
+						 unsigned long),
+				       void *data);
+
+#else /* !CONFIG_LIVEPATCH */
+
+static inline int module_kallsyms_on_each_symbol_all(int (*fn)(void *, const char *,
+							   struct module *,
+							   unsigned long),
+						     void *data)
+{
+	return 0;
+}
+
+#endif /* CONFIG_LIVEPATCH */
+
+int module_kallsyms_on_each_symbol(struct module *mod,
+				   int (*fn)(void *, const char *,
 					     struct module *, unsigned long),
 				   void *data);
 
+#else /* !(CONFIG_MODULES && CONFIG_KALLSYMS) */
+
+static inline int module_kallsyms_on_each_symbol(struct module *mod,
+						 int (*fn)(void *, const char *,
+							   struct module *,
+							   unsigned long),
+						 void *data)
+{
+	return 0;
+}
+
+#endif /* CONFIG_MODULES && CONFIG_KALLSYMS */
+
 #endif /* _LINUX_MODULE_H */
diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 3011bc33a5ba..da40f48f071e 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -224,10 +224,9 @@ unsigned long kallsyms_lookup_name(const char *name)
 	return module_kallsyms_lookup_name(name);
 }
 
-#ifdef CONFIG_LIVEPATCH
 /*
  * Iterate over all symbols in vmlinux.  For symbols from modules use
- * module_kallsyms_on_each_symbol instead.
+ * module_kallsyms_on_each_symbol_all instead.
  */
 int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 				      unsigned long),
@@ -246,7 +245,6 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 	}
 	return 0;
 }
-#endif /* CONFIG_LIVEPATCH */
 
 static unsigned long get_symbol_pos(unsigned long addr,
 				    unsigned long *symbolsize,
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 335d988bd811..3756071658fd 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -165,7 +165,7 @@ static int klp_find_object_symbol(const char *objname, const char *name,
 	};
 
 	if (objname)
-		module_kallsyms_on_each_symbol(klp_find_callback, &args);
+		module_kallsyms_on_each_symbol_all(klp_find_callback, &args);
 	else
 		kallsyms_on_each_symbol(klp_find_callback, &args);
 
diff --git a/kernel/module.c b/kernel/module.c
index 84a9141a5e15..88a24dd8f4bd 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -4473,13 +4473,54 @@ unsigned long module_kallsyms_lookup_name(const char *name)
 	return ret;
 }
 
-#ifdef CONFIG_LIVEPATCH
-int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
+static int __module_kallsyms_on_each_symbol(struct mod_kallsyms *kallsyms,
+					    struct module *mod,
+					    int (*fn)(void *, const char *,
+						      struct module *, unsigned long),
+					    void *data)
+{
+	unsigned long i;
+	int ret = 0;
+
+	for (i = 0; i < kallsyms->num_symtab; i++) {
+		const Elf_Sym *sym = &kallsyms->symtab[i];
+
+		if (sym->st_shndx == SHN_UNDEF)
+			continue;
+
+		ret = fn(data, kallsyms_symbol_name(kallsyms, i),
+			 mod, kallsyms_symbol_value(sym));
+		if (ret != 0)
+			break;
+	}
+
+	return ret;
+}
+
+int module_kallsyms_on_each_symbol(struct module *mod,
+				   int (*fn)(void *, const char *,
 					     struct module *, unsigned long),
 				   void *data)
+{
+	struct mod_kallsyms *kallsyms;
+	int ret = 0;
+
+	mutex_lock(&module_mutex);
+	/* We hold module_mutex: no need for rcu_dereference_sched */
+	kallsyms = mod->kallsyms;
+	if (mod->state != MODULE_STATE_UNFORMED)
+		ret = __module_kallsyms_on_each_symbol(kallsyms, mod, fn, data);
+	mutex_unlock(&module_mutex);
+
+	return ret;
+}
+
+#ifdef CONFIG_LIVEPATCH
+int module_kallsyms_on_each_symbol_all(int (*fn)(void *, const char *,
+						 struct module *, unsigned long),
+				       void *data)
 {
 	struct module *mod;
-	unsigned int i;
 	int ret = 0;
 
 	mutex_lock(&module_mutex);
@@ -4489,19 +4530,10 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 
 		if (mod->state == MODULE_STATE_UNFORMED)
 			continue;
-		for (i = 0; i < kallsyms->num_symtab; i++) {
-			const Elf_Sym *sym = &kallsyms->symtab[i];
-
-			if (sym->st_shndx == SHN_UNDEF)
-				continue;
-
-			ret = fn(data, kallsyms_symbol_name(kallsyms, i),
-				 mod, kallsyms_symbol_value(sym));
-			if (ret != 0)
-				goto out;
-		}
+		ret = __module_kallsyms_on_each_symbol(kallsyms, mod, fn, data);
+		if (ret != 0)
+			break;
 	}
-out:
 	mutex_unlock(&module_mutex);
 	return ret;
 }
-- 
2.34.1

