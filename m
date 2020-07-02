Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3857213005
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 01:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbgGBX0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 19:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726048AbgGBX0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 19:26:43 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B13C08C5DF
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 16:26:42 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id g17so11894979plq.12
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 16:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7HijGgI2TvbxAdbkLmn+7FOevHZZvQsb/QB5kNsfRm8=;
        b=kr+H74z6Y7mZaMt6BLkbJH6jXJe6j/Y78PHuFfeEaqhOFJUMX5pP2Bph8ILRWvLBrS
         mxeLTfc6KWtp+iboAOsMoRZPipJusoIglLHxeFArstHKAufpjMOJ3ui4CtrajZNAXs8W
         7hvDURyhFv/VldjQpo/vMbl4cN+Bhkk7rsjzM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7HijGgI2TvbxAdbkLmn+7FOevHZZvQsb/QB5kNsfRm8=;
        b=Gta8ZvtB1yp5vo51Du5jPk9zulXshX3tL67Iqd4g9zXRVaH4suWNc7d1D6lAPn+rO4
         NK7hkLQ3o8YKEM1DdVpcPG2XZWChycmZst4BJx2eKRCysdXgX+uXgqSbQxwmELBZJw72
         w5mSl+ztee5Ao4k2inJU+7cUUnYRtaR3DFB7DlDuevAz1H5xB4FIb+1s5Rf4gTsIAueZ
         V3dvhoYtJi+B3SZ3w4Kw6AsD4UpjNei/HLDvRI+STCeCxMxNB43TP0JcmgzScW4VcEnb
         ITgM45cLKzW/CaSVK3i8+mhGsMa0ioP3Q8Gt7IUojU6jAJaeIOcR+6rUorC7J5/K3S/k
         A9pg==
X-Gm-Message-State: AOAM532gCCf2X1/SV/IQX+Gp9P8+KJRc0KQRBpJLzqVNF4wOzdd5VxA7
        YipPefxJmQtA9xlYUt5kYhVSPQ==
X-Google-Smtp-Source: ABdhPJzz8CnYHL225os3PvEw+cnKOtwdUEdHKeI66rSfONm++PTuKjYFyWcIQK9h9E+K5n13kFzU8Q==
X-Received: by 2002:a17:902:b60c:: with SMTP id b12mr26535944pls.96.1593732402248;
        Thu, 02 Jul 2020 16:26:42 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id y8sm8858534pju.49.2020.07.02.16.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 16:26:41 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Dominik Czarnota <dominik.czarnota@trailofbits.com>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Jessica Yu <jeyu@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Will Deacon <will@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Matteo Croce <mcroce@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] module: Refactor section attr into bin attribute
Date:   Thu,  2 Jul 2020 16:26:35 -0700
Message-Id: <20200702232638.2946421-3-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702232638.2946421-1-keescook@chromium.org>
References: <20200702232638.2946421-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to gain access to the open file's f_cred for kallsym visibility
permission checks, refactor the module section attributes to use the
bin_attribute instead of attribute interface. Additionally removes the
redundant "name" struct member.

Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/module.c | 45 ++++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index a5022ae84e50..9e2954519259 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1510,8 +1510,7 @@ static inline bool sect_empty(const Elf_Shdr *sect)
 }
 
 struct module_sect_attr {
-	struct module_attribute mattr;
-	char *name;
+	struct bin_attribute battr;
 	unsigned long address;
 };
 
@@ -1521,11 +1520,16 @@ struct module_sect_attrs {
 	struct module_sect_attr attrs[];
 };
 
-static ssize_t module_sect_show(struct module_attribute *mattr,
-				struct module_kobject *mk, char *buf)
+static ssize_t module_sect_read(struct file *file, struct kobject *kobj,
+				struct bin_attribute *battr,
+				char *buf, loff_t pos, size_t count)
 {
 	struct module_sect_attr *sattr =
-		container_of(mattr, struct module_sect_attr, mattr);
+		container_of(battr, struct module_sect_attr, battr);
+
+	if (pos != 0)
+		return -EINVAL;
+
 	return sprintf(buf, "0x%px\n", kptr_restrict < 2 ?
 		       (void *)sattr->address : NULL);
 }
@@ -1535,7 +1539,7 @@ static void free_sect_attrs(struct module_sect_attrs *sect_attrs)
 	unsigned int section;
 
 	for (section = 0; section < sect_attrs->nsections; section++)
-		kfree(sect_attrs->attrs[section].name);
+		kfree(sect_attrs->attrs[section].battr.attr.name);
 	kfree(sect_attrs);
 }
 
@@ -1544,42 +1548,41 @@ static void add_sect_attrs(struct module *mod, const struct load_info *info)
 	unsigned int nloaded = 0, i, size[2];
 	struct module_sect_attrs *sect_attrs;
 	struct module_sect_attr *sattr;
-	struct attribute **gattr;
+	struct bin_attribute **gattr;
 
 	/* Count loaded sections and allocate structures */
 	for (i = 0; i < info->hdr->e_shnum; i++)
 		if (!sect_empty(&info->sechdrs[i]))
 			nloaded++;
 	size[0] = ALIGN(struct_size(sect_attrs, attrs, nloaded),
-			sizeof(sect_attrs->grp.attrs[0]));
-	size[1] = (nloaded + 1) * sizeof(sect_attrs->grp.attrs[0]);
+			sizeof(sect_attrs->grp.bin_attrs[0]));
+	size[1] = (nloaded + 1) * sizeof(sect_attrs->grp.bin_attrs[0]);
 	sect_attrs = kzalloc(size[0] + size[1], GFP_KERNEL);
 	if (sect_attrs == NULL)
 		return;
 
 	/* Setup section attributes. */
 	sect_attrs->grp.name = "sections";
-	sect_attrs->grp.attrs = (void *)sect_attrs + size[0];
+	sect_attrs->grp.bin_attrs = (void *)sect_attrs + size[0];
 
 	sect_attrs->nsections = 0;
 	sattr = &sect_attrs->attrs[0];
-	gattr = &sect_attrs->grp.attrs[0];
+	gattr = &sect_attrs->grp.bin_attrs[0];
 	for (i = 0; i < info->hdr->e_shnum; i++) {
 		Elf_Shdr *sec = &info->sechdrs[i];
 		if (sect_empty(sec))
 			continue;
+		sysfs_bin_attr_init(&sattr->battr);
 		sattr->address = sec->sh_addr;
-		sattr->name = kstrdup(info->secstrings + sec->sh_name,
-					GFP_KERNEL);
-		if (sattr->name == NULL)
+		sattr->battr.attr.name =
+			kstrdup(info->secstrings + sec->sh_name, GFP_KERNEL);
+		if (sattr->battr.attr.name == NULL)
 			goto out;
 		sect_attrs->nsections++;
-		sysfs_attr_init(&sattr->mattr.attr);
-		sattr->mattr.show = module_sect_show;
-		sattr->mattr.store = NULL;
-		sattr->mattr.attr.name = sattr->name;
-		sattr->mattr.attr.mode = S_IRUSR;
-		*(gattr++) = &(sattr++)->mattr.attr;
+		sattr->battr.read = module_sect_read;
+		sattr->battr.size = 3 /* "0x", "\n" */ + (BITS_PER_LONG / 4);
+		sattr->battr.attr.mode = 0400;
+		*(gattr++) = &(sattr++)->battr;
 	}
 	*gattr = NULL;
 
@@ -1669,7 +1672,7 @@ static void add_notes_attrs(struct module *mod, const struct load_info *info)
 			continue;
 		if (info->sechdrs[i].sh_type == SHT_NOTE) {
 			sysfs_bin_attr_init(nattr);
-			nattr->attr.name = mod->sect_attrs->attrs[loaded].name;
+			nattr->attr.name = mod->sect_attrs->attrs[loaded].battr.attr.name;
 			nattr->attr.mode = S_IRUGO;
 			nattr->size = info->sechdrs[i].sh_size;
 			nattr->private = (void *) info->sechdrs[i].sh_addr;
-- 
2.25.1

