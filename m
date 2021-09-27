Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1A44196F2
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 17:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234873AbhI0PBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 11:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234995AbhI0PBi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 11:01:38 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6209C061769;
        Mon, 27 Sep 2021 07:59:58 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id k23so12668708pji.0;
        Mon, 27 Sep 2021 07:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J0qwPwLHdv9Ry0hnhF4U+31mLrql64Mi3Dl7eMKHw3Q=;
        b=B6rVpfVLWdS7tGXJ1b2FjbSR4R1W7k8i6hfNfELR93xXd73/8liTFQSas09bmG+A1e
         yJVW9qss01ulEb9XzprpHbdEOr56H6klQhw2qOvTTX9mrp/B/R2+oAJ4EcjgRG9NmACf
         al6A1VM6fDPybJI4TZttZHkI9UpipGc/awzCjSAFMwrThaGV9zikHokk8R0H7RAubLui
         JqVVCyf9+ppx+40cQ1yRs94FQvzaN2tWtnl4+/9ifamdOVFYogZG11EmZj9nu82eucun
         q/9AuhXNJIlodbqiOA2QqtrGaWXN3ed+CGsgB6Mdhfq2LoWuiJ0J4x0Z+qhqQlEF1b9Y
         fAGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J0qwPwLHdv9Ry0hnhF4U+31mLrql64Mi3Dl7eMKHw3Q=;
        b=rTakyvj1uL7efzI8pEtiFxneUm8/03OYsviIoRb5+OXQNm/fo8owWGpwzs1IOme9r7
         iw8TZqrs+9Xvj1Fcd0MuwBvdmhNyPzTQoKrqWkDJ8yWUhOg7LMR+pVWeGPsjFy4v17a3
         +Nu942JcEIIBR7VYIBPS7I2PLU5y/XKqkRWksWgMeMI1rj6wqaAYc2y3uxjteQNbQJBz
         DoIEHldixnJNrqmBC+GfN7n2dFIniqzMS5UpHXxO3kAQucacND8cDBGouOpUGssWQuNF
         PYhjaA4ysfZ4IAwgdVuvJSFjcs1821l2S2P3QiNlhBoEPL/4RYDqJeQi9oaUxV1Jgugf
         qv0A==
X-Gm-Message-State: AOAM532SxUWkznJyJAS6hy60aFktb/i8lL43GZXUfdCI6Q7//v2daYt4
        IKvZTUfVWm46jyaPodVQpDaKAfjGL5w=
X-Google-Smtp-Source: ABdhPJxPeAxuJg+A8pMGqTHPjEakf+JbP0wqbz7NWgXV+VM3n0PDOLQdIAjUMyD/8WF96+S/XvjgtA==
X-Received: by 2002:a17:90a:19d2:: with SMTP id 18mr378179pjj.217.1632754798072;
        Mon, 27 Sep 2021 07:59:58 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id j24sm17450611pfh.65.2021.09.27.07.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 07:59:57 -0700 (PDT)
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
Subject: [PATCH bpf-next v5 04/12] tools: Allow specifying base BTF file in resolve_btfids
Date:   Mon, 27 Sep 2021 20:29:33 +0530
Message-Id: <20210927145941.1383001-5-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927145941.1383001-1-memxor@gmail.com>
References: <20210927145941.1383001-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3590; h=from:subject; bh=JQF5FTCXoiG0ws4sHCqjBu7XKk8EtlYkG/YdFjxrcpU=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhUdxOWhWKmXQXqjEOOQQo0Qvqm2W8oSyAf2VVF5+s gNtOhXOJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVHcTgAKCRBM4MiGSL8RyiB/D/ 4mCpUZFjf0BR5A161S4uBUOybLaEmmULoQ+Q0X0HYU5DVGZS1tWfoCsyiCRL1zwfPMtkPY0ix+yHy2 QHJyrWhJ+0xjWQrQ2pXvfAslvl4SET2xJ+jGWti/qv2Xb7XdkFac+JqhS9kBqfv2vO2RHZpvKbINd0 s2Slr2RrJ46ZgYPhfw7xI3oLfoaJX42bNL9Vji5FGmLbb2F09DhVrlDAQlNcMjFwLhRcC1jLKBHLQY siHu0HQDsCBiYhBOakOYX4ZhGvB+mAOZQCoU4p50ggwGPN+E0g02Fei0/3x4tlp8Z3Jt+C6mSsqwyl KPpCLWAkN411FormJnWApC+ukcAsg0eLC1u38wwXzQ3oNFPe9qooAJsCAzKCuEnSLvva9MvOkNqGM8 oD44HY2Q32l+XE1wN+4mbH/9ptXFHvHxejGYAOFgJ0SIpGOnoKBXIcNzB5Q3MtmcDl0bDTMAPo4zx4 osiY0qNvY9a63mm0cfar8ccrqwglbUP9bN4jOItpEzxYx56Hn9JWn3UMQLDAMvPoAlxma8eVSLIlrG kvd1bEbjp7gy2KN7aL024lAJ0UGYV325SdyeLS56aVxf+RnkPqDmMO5M5JCwlM5YaDIUScaXhK4BIG Q5tgaLGKKb3EaxtoHV8iEODeTfE+GIrkYTYQYG7Tv2liksm4E+2BIDAx6Y0A==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commits allows specifying the base BTF for resolving btf id
lists/sets during link time in the resolve_btfids tool. The base BTF is
set to NULL if no path is passed. This allows resolving BTF ids for
module kernel objects.

Also, drop the --no-fail option, as it is only used in case .BTF_ids
section is not present, instead make no-fail the default mode. The long
option name is same as that of pahole.

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

