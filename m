Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635E841F910
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 03:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232284AbhJBBUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 21:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232282AbhJBBT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 21:19:58 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56017C0613E6;
        Fri,  1 Oct 2021 18:18:13 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id y8so9397056pfa.7;
        Fri, 01 Oct 2021 18:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kFwKUcKVGZRg+1reGxJWhVh2pFNib4BSqxe4I7uwK7c=;
        b=UEmk82HaR6koPJ85NAzHkU14s7CbC81crH+9SCXntNZTbJUyKQe0J2IIh4gqC+ws1/
         9E6BBK8bvvoSUb3t1Bozd7RkVUW7s/Nro3UoWImPirpP5175qNGqrgqYvSxTBDl3R5Y6
         BP3ZYBISgrKkpEH0oWw0SkavmQuxFXpsnRLf/J14K47Y3i2xvnpLIl3Oz8yNykED58w4
         mV2pG4UzVzoJYThfeZtogvhXdCsfWWjYwmtTSQ/5NnktDYsiSjR0dP6Yv/jNLZt5lFUr
         V64XVjwZLS44slIRHfh1S6EhXZ4nBXCX+/nEBkj4jpsyaZY+xJubTvj+vrNM9XvTBU1s
         hnQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kFwKUcKVGZRg+1reGxJWhVh2pFNib4BSqxe4I7uwK7c=;
        b=04z/qQzFiObzcJMXY6MK0MCAi9nJeY0Wwvv1tmxa5NdvauE9yY7AGoqQxOAEKQmXUK
         SiK1xJpxUCskE1wyIvs8CYSryDKke2WRkwqclWQvRr4uVLDaUyX/ZAfyvUE8o5TY2r9D
         UQTVfUwbfOTGUYM2iQK8+O4RKU+7TMglsu5OBzDgUDzY7DI3UgE5val3fmJjxOZgyLEV
         HKgdHptW1WxkM3IiYYlimZnRh0hFANT165WmbeVOxNv1rEAMaMxkidFcNqrBmv7VtEVS
         RLmHFhB5EIBGrXzrGPK9qnYMMldnapL0FLtMvCRSKvCHzwwj647bgseZ7wXnHx6e7Xis
         FkTQ==
X-Gm-Message-State: AOAM530Lxyca5rY21BG68mxE7HriTX/apXVcciyZj/rJ1w7gu/A6iot3
        NlhvYcL7ENbrFV4I/W89cY7kdAPTfzg=
X-Google-Smtp-Source: ABdhPJyHnGDyEAJGacUooIR1CsPmcFXzJxti389mkMrm6Wu4S9fmD1pohyB1oraxgZ6eRhNV6RvE0A==
X-Received: by 2002:a63:a54e:: with SMTP id r14mr906314pgu.352.1633137492677;
        Fri, 01 Oct 2021 18:18:12 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id j6sm7017979pgh.17.2021.10.01.18.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 18:18:12 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v7 4/9] tools: Allow specifying base BTF file in resolve_btfids
Date:   Sat,  2 Oct 2021 06:47:52 +0530
Message-Id: <20211002011757.311265-5-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211002011757.311265-1-memxor@gmail.com>
References: <20211002011757.311265-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3636; h=from:subject; bh=BmIYoF7Fm+p/jd6My83FL7cXsrH710TQQGldPP1clQs=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhV7MRRsKhDm1Uy+xnNCBJkLeKPhHlrw7r9zlxF4dM oN6uMqmJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVezEQAKCRBM4MiGSL8RygEbD/ 9ZELRhQYGhszLp4VPhakEvEBQFDJ4CF9A1ZbYs0Px4bcx9C7LDjPEkapa4KcuugryK0Pxoofa9AACE SX1ufnh1VwNdP4mWNLt3vqHqqCOHjnc2dFPQiK9p2WbeUDHKNb4dIu+EyDIjOlFqDxpaFcsbwIgPm6 /1CK5ovKz0aKWcf07rLxg4ERRxKbPVIY05d0rrwnteYyuciUr0PJ7bsIfbW1BYFiQ2D6+WV3s5C9EM lsX5lXFN5+Aty+fZ0ZoOAYm4txSp8pjMfVWBeKZDgeAL03QguU+tuenKv51iWEsm3svNX9ryTMHRf2 tQSHuLwBLm75Z94bZhVhSa8Do92c3wPOU3M2kPb6oWDaApuxSXXxvGTsLeOV5DIyF/Eg/GTyjoWSze 3ZzFdxq4dRzFDl6Ut8BJ8dq50JIT7KfC0K3Hrm5oJ6nZcQQ6W8cS7QZQhlgQQB/QKPYSxhz4e3t+hv uLx1+4Wexd3W9jbHvVBHC6TF/Mb6wmhbA3iDCXDjw70wxwiRVthYV6HnkNUa/6ViXQdtPcFxa1Zwsv zyH+C1MclWh7X7WpzC+r6oLi1q1rRlD7mZT8a2yDy77BEemH1LnrIuoh7itjJIdyD/79J98KM05FQ7 2udpEEiuh4GFGWKnQPmseOI9JbqHqp0Yu/Bt36SPCj0SckKnqTUyjaqx+Rqg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit allows specifying the base BTF for resolving btf id
lists/sets during link time in the resolve_btfids tool. The base BTF is
set to NULL if no path is passed. This allows resolving BTF ids for
module kernel objects.

Also, drop the --no-fail option, as it is only used in case .BTF_ids
section is not present, instead make no-fail the default mode. The long
option name is same as that of pahole.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/bpf/resolve_btfids/main.c      | 28 +++++++++++++++++++---------
 tools/testing/selftests/bpf/Makefile |  2 +-
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
index de6365b53c9c..c6c3e613858a 100644
--- a/tools/bpf/resolve_btfids/main.c
+++ b/tools/bpf/resolve_btfids/main.c
@@ -89,6 +89,7 @@ struct btf_id {
 struct object {
 	const char *path;
 	const char *btf;
+	const char *base_btf_path;
 
 	struct {
 		int		 fd;
@@ -477,16 +478,27 @@ static int symbols_resolve(struct object *obj)
 	int nr_structs  = obj->nr_structs;
 	int nr_unions   = obj->nr_unions;
 	int nr_funcs    = obj->nr_funcs;
+	struct btf *base_btf = NULL;
 	int err, type_id;
 	struct btf *btf;
 	__u32 nr_types;
 
-	btf = btf__parse(obj->btf ?: obj->path, NULL);
+	if (obj->base_btf_path) {
+		base_btf = btf__parse(obj->base_btf_path, NULL);
+		err = libbpf_get_error(base_btf);
+		if (err) {
+			pr_err("FAILED: load base BTF from %s: %s\n",
+			       obj->base_btf_path, strerror(-err));
+			return -1;
+		}
+	}
+
+	btf = btf__parse_split(obj->btf ?: obj->path, base_btf);
 	err = libbpf_get_error(btf);
 	if (err) {
 		pr_err("FAILED: load BTF from %s: %s\n",
 			obj->btf ?: obj->path, strerror(-err));
-		return -1;
+		goto out;
 	}
 
 	err = -1;
@@ -545,6 +557,7 @@ static int symbols_resolve(struct object *obj)
 
 	err = 0;
 out:
+	btf__free(base_btf);
 	btf__free(btf);
 	return err;
 }
@@ -678,7 +691,6 @@ static const char * const resolve_btfids_usage[] = {
 
 int main(int argc, const char **argv)
 {
-	bool no_fail = false;
 	struct object obj = {
 		.efile = {
 			.idlist_shndx  = -1,
@@ -695,8 +707,8 @@ int main(int argc, const char **argv)
 			 "be more verbose (show errors, etc)"),
 		OPT_STRING(0, "btf", &obj.btf, "BTF data",
 			   "BTF data"),
-		OPT_BOOLEAN(0, "no-fail", &no_fail,
-			   "do not fail if " BTF_IDS_SECTION " section is not found"),
+		OPT_STRING('b', "btf_base", &obj.base_btf_path, "file",
+			   "path of file providing base BTF"),
 		OPT_END()
 	};
 	int err = -1;
@@ -717,10 +729,8 @@ int main(int argc, const char **argv)
 	 */
 	if (obj.efile.idlist_shndx == -1 ||
 	    obj.efile.symbols_shndx == -1) {
-		if (no_fail)
-			return 0;
-		pr_err("FAILED to find needed sections\n");
-		return -1;
+		pr_debug("Cannot find .BTF_ids or symbols sections, nothing to do\n");
+		return 0;
 	}
 
 	if (symbols_collect(&obj))
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 326ea75ce99e..e1ce73be7a5b 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -453,7 +453,7 @@ $(OUTPUT)/$(TRUNNER_BINARY): $(TRUNNER_TEST_OBJS)			\
 			     | $(TRUNNER_BINARY)-extras
 	$$(call msg,BINARY,,$$@)
 	$(Q)$$(CC) $$(CFLAGS) $$(filter %.a %.o,$$^) $$(LDLIBS) -o $$@
-	$(Q)$(RESOLVE_BTFIDS) --no-fail --btf $(TRUNNER_OUTPUT)/btf_data.o $$@
+	$(Q)$(RESOLVE_BTFIDS) --btf $(TRUNNER_OUTPUT)/btf_data.o $$@
 
 endef
 
-- 
2.33.0

