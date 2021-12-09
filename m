Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0044B46F100
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242485AbhLIRNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242452AbhLIRNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 12:13:09 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2399BC061353;
        Thu,  9 Dec 2021 09:09:36 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id h24so4933847pjq.2;
        Thu, 09 Dec 2021 09:09:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XjCp/9mGE7NnbH9+QWAp4rX+GvWW6hfQPcpe4QS9vWQ=;
        b=EBBwZ1P31ixGYJWIjJ0NlpP7qSJlZ0gMNgv2kprM8Q+jcscidSN+3pjVncWcCg9jCX
         0HolvXJ72zvTo79vAqxExevtHLXybyKs87qO6KMLgrkljF4brHea/R85OgcsDgTcwFJ0
         C6kAR/kAeMP+CPWZHmG1wCGIj31KAFjqzHG69fmWneoGv6Ia2uahFJgw5b2G9w3hzb9J
         n6RcKCUFdkKkuuznL3Q1cmQraAK7ylIxt7kCIzjEcEJB9mFUq44kNuggblyVP33degoL
         oRXztqndNq1cOYqSTkW59uFWbhtLpwO3ycg0PKJ6mIMS03xv8rMs1uY/6asOvzOsdt6o
         EREg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XjCp/9mGE7NnbH9+QWAp4rX+GvWW6hfQPcpe4QS9vWQ=;
        b=konF+Cd6skBhZwWTYVOm6JTF2+6iQBObVcPkt0ZK2jMiN7L7Y9dc8EEWowihm/uYuX
         W223AZsHkj4WBvocsqCSlQuPIl6O2IOTvNKUMMaK/oiZWOOJMDdrBziwhh9uWG9w2XoS
         geIRq24GXCLwxLvECDraj0KamTHi2Lf1BoyuCtm4GTDjkLuw43OJu7EGmENnywcDV54/
         10obuyPHux/D0WBP8f4yU2sGpw0y3L2AQCc8DWX5uc/EXrYKEISq0JrQMsAgPB2J79IC
         ijgbVEK6AgekHZ7y4eBqNvyZaZep0xs89kuldg9NF4x1wXOctCMCaX3cyWLvihaSQHwR
         C+0g==
X-Gm-Message-State: AOAM531zK6SkG/BrFYYkTgC2REj8n8YJatS5juNSbLAjrgL9b4eeC3Uu
        2qdipkDo14Glf20j+tpK+1l5l0F48Kw=
X-Google-Smtp-Source: ABdhPJzg5SyX6HB4rKbL2rd2AZt3Wm8fBgJ0pbXJc074EBGVvfGw280CT/8vG4hX5isDpGLwXK0kZA==
X-Received: by 2002:a17:902:d505:b0:141:f5f7:848e with SMTP id b5-20020a170902d50500b00141f5f7848emr69251562plg.72.1639069775470;
        Thu, 09 Dec 2021 09:09:35 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id o124sm257558pfb.177.2021.12.09.09.09.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 09:09:35 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH bpf-next v2 1/9] bpf: Refactor bpf_check_mod_kfunc_call
Date:   Thu,  9 Dec 2021 22:39:21 +0530
Message-Id: <20211209170929.3485242-2-memxor@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211209170929.3485242-1-memxor@gmail.com>
References: <20211209170929.3485242-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3292; h=from:subject; bh=lfnlsQxs8QHwFpLmgk9MSBfbBxejBvXGJQ9rpCKsj0Y=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhsjgHqdeXuiKrxVFha/GPI2q2IB/PgvRzzVNOZDfn erFhxfmJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYbI4BwAKCRBM4MiGSL8RyjUTD/ 9RvGZLyBhuUidss4fpzJZC2SN9yBLbD5DNn50PsI01CbpXcsScHMJ+LweLBfTZNeijCG0cKLDEzI5c eTYKkq5OWFNJxCMihfzAuLHDW0MM2SZb9dQ1ntdvs8xTdp4WDFyUE7c3LuwZs5DWy9dBU/1PRQt0XC pK6w0tlukCTy1T29PXJNJUuYpV1vfNuv1Q/jpt+6UhNeai84BgHZqDgcl1a+z59OrgElH0j2Z8j9ev VJmh2igubhurP0vHy0uiYsNt/MlWtcyrbzbzITkvoJhA0GkSn9P5AU7E/GuiLIU5YsO/dWQ+qwa8qa yCVKGyKOLNsPIGNlZzSt82LOk0RWqVOjhl7zTriXBQq+9udNpCN56xeqfJzJ36IQma2IMivKZURiOR naFWt1ictm9gFjn3ePtrlhTBhCM+dHMcNfyWqzK/53BekMfdPUXKdC+y+y/vBiuKRyLo7NOF1lZSL+ 0rNftFbpWAGvC952rb3y2nQzYYcP/GAwmqyNPw/6kZ9MGoD2u8m389hVRnD1C8jYrZz+rLLWVDdmfG ZN4ZBgF357w7MVfe1IRfw1lbAYDlSrzJJayBV5epL+WZ2dkcfMmAh0bEd8iDDhIyXDm3SakGp9Qltr KJH2+t7OmViCVltDarFTfJS3TIfjx6DlLSUOqETmufh2OZ3KcOwxAUiPPPOw==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Future commits adding more callbacks will implement the same pattern of
matching module owner of kfunc_btf_id_set, and then operating on more
sets inside the struct.

While the btf_id_set for check_kfunc_call wouldn't have been NULL so
far, future commits introduce sets that are optional, hence the common
code also checks whether the pointer is valid.

Note that we must continue search on owner match and btf_id_set_contains
returning false, since more entries may have same owner (which can be
NULL for built-in modules). To clarify this case, a comment is added, so
that future commits don't regress the search.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 include/linux/btf.h | 16 +++++++++++++---
 kernel/bpf/btf.c    | 27 +++++++++++++++++++--------
 2 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index acef6ef28768..d3014493f6fb 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -320,9 +320,19 @@ static inline const char *btf_name_by_offset(const struct btf *btf,
 }
 #endif
 
+enum kfunc_btf_id_set_types {
+	BTF_SET_CHECK,
+	__BTF_SET_MAX,
+};
+
 struct kfunc_btf_id_set {
 	struct list_head list;
-	struct btf_id_set *set;
+	union {
+		struct btf_id_set *sets[__BTF_SET_MAX];
+		struct {
+			struct btf_id_set *set;
+		};
+	};
 	struct module *owner;
 };
 
@@ -344,8 +354,8 @@ static inline void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
 					       struct kfunc_btf_id_set *s)
 {
 }
-static inline bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist,
-					    u32 kfunc_id, struct module *owner)
+bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			      struct module *owner)
 {
 	return false;
 }
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 27b7de538697..c9413d13ca91 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6390,22 +6390,33 @@ void unregister_kfunc_btf_id_set(struct kfunc_btf_id_list *l,
 }
 EXPORT_SYMBOL_GPL(unregister_kfunc_btf_id_set);
 
-bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
-			      struct module *owner)
+/* Caller must hold reference to module 'owner' */
+static bool kfunc_btf_id_set_contains(struct kfunc_btf_id_list *klist,
+				      u32 kfunc_id, struct module *owner,
+				      enum kfunc_btf_id_set_types type)
 {
-	struct kfunc_btf_id_set *s;
+	struct kfunc_btf_id_set *s = NULL;
+	bool ret = false;
 
-	if (!owner)
+	if (type >= __BTF_SET_MAX)
 		return false;
 	mutex_lock(&klist->mutex);
 	list_for_each_entry(s, &klist->list, list) {
-		if (s->owner == owner && btf_id_set_contains(s->set, kfunc_id)) {
-			mutex_unlock(&klist->mutex);
-			return true;
+		if (s->owner == owner && s->sets[type] &&
+		    btf_id_set_contains(s->sets[type], kfunc_id)) {
+			ret = true;
+			break;
 		}
+		/* continue search, since multiple sets may have same owner */
 	}
 	mutex_unlock(&klist->mutex);
-	return false;
+	return ret;
+}
+
+bool bpf_check_mod_kfunc_call(struct kfunc_btf_id_list *klist, u32 kfunc_id,
+			      struct module *owner)
+{
+	return kfunc_btf_id_set_contains(klist, kfunc_id, owner, BTF_SET_CHECK);
 }
 
 #endif
-- 
2.34.1

