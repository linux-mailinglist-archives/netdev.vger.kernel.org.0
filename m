Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3384E41D365
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 08:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348058AbhI3Gb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 02:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348358AbhI3Gbq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 02:31:46 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD035C061771;
        Wed, 29 Sep 2021 23:30:02 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id r2so5181327pgl.10;
        Wed, 29 Sep 2021 23:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J0qwPwLHdv9Ry0hnhF4U+31mLrql64Mi3Dl7eMKHw3Q=;
        b=OaLzCUg7sR0pMW0AkwuxhG8gUCWYemwG+D676ExawgKDKBpbCN1NeHZ4thy7cNUxJH
         QttfzrHWALG1Zjs6svQkBjVdsOrLYa29nruPsxXl96zm/GklLbthetA2IbrLOtpNFqZ3
         2vDWl1TexCtDgWWQDPEZxTKyvnCSinB1fyls9GrCFlhfExXAc/7BW7CU8RSigUx7NcWs
         sN91MPcZ2toJfCXwmQYxeET6SOeXkx/csVNOUxeScfSaEAgmGtdjxdXmlhXZkJdd8aQ+
         0K+5bi8AwCR8kA9hJkxixtQIpBhr27mBKvHUnp44hfO6ewckRar9vzSxWbybysYAa7hO
         RMJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J0qwPwLHdv9Ry0hnhF4U+31mLrql64Mi3Dl7eMKHw3Q=;
        b=v+/uP6ZFxr3WJhIt8gw2ru3TYBp9EoGIYsr5Ygsge9dph2I051e+gd0eE8miD9Rgp5
         yJgC0lvFcVGcwrYQ51vSgVHFFhdT5PfWyoXAoS48uDPMNd75/CFsTTcQsoFZZ5NgHohJ
         lTIhWtvo4slvyEeyAVQZqtmn/sipIAfCRwPfdxrJhImf0kLKywpomG+lwabE9baEfuUZ
         j6J7thpNinR8liYGH6IGUMIw9Sdmdv/+92NWarm+5MM0cgdYYbvOpYDtsnCvF4v0cA/Q
         bQCFsMWHucoz5GGt06FK/OdOo5inWrmDIeQj0cKq/NbD9DKuPv7sQAiR1JaysawnUUi9
         hYyA==
X-Gm-Message-State: AOAM533g2FEXYUvVZ00C2wLtf8tIsXOZBmQcDu326rMmQCVju6Sci+wu
        kR/BBM5oArgR+fButYRs2nHGL9hDRBs=
X-Google-Smtp-Source: ABdhPJxkftWHLxsuDd8493jnDVyJN7VQCjG4JbnnujjFHpcOGgBduKwJiykWEYMZAb9+2cnzO9xl0w==
X-Received: by 2002:a63:5f0d:: with SMTP id t13mr3543425pgb.22.1632983402055;
        Wed, 29 Sep 2021 23:30:02 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id mr18sm1482217pjb.17.2021.09.29.23.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 23:30:01 -0700 (PDT)
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
Subject: [PATCH bpf-next v6 4/9] tools: Allow specifying base BTF file in resolve_btfids
Date:   Thu, 30 Sep 2021 11:59:43 +0530
Message-Id: <20210930062948.1843919-5-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210930062948.1843919-1-memxor@gmail.com>
References: <20210930062948.1843919-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3590; h=from:subject; bh=JQF5FTCXoiG0ws4sHCqjBu7XKk8EtlYkG/YdFjxrcpU=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhVVlBWhWKmXQXqjEOOQQo0Qvqm2W8oSyAf2VVF5+s gNtOhXOJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVVZQQAKCRBM4MiGSL8Ryoh0D/ 90FhUevnwvYsVWY0w0VIj/PilH3T3blsAcCrXujGLQpWBGeLFzKFR2Y4vuhH13AJeKP80G9jRmIIEu N07BtdJXh83+DeyL5cG4gLu9uoRfEitvdUxGfaR1ofRwQSfCKH9ndRl5BBVNPKGZCPhsLt/v5oEnJK ru7Ndz+O8d8h5raZtePwGJZx+FeaXMJSYrx6N6mKceAt002c5kuLBZIr4fcUpsKGfcznIfaX3Ovdmr JY4JvAO9xqiBwSq1P2MHxLYyyMQpHrmn5iM8F/iFCe7/U44d8fBweFV0BDb/H2o5qt2piwRJ8HuV5u SACwyK2UxAnWal4tVvkMt0gZ6L7DHooPmJVEFV/ZZT5xOAbd4EhooECL90/ALNPNhL2yCIcmntTWzn 8qQF6kGsD+p7NkdgW7Zoo/OdnS6tq+HU3IRzrH5MsGknepZc15FafLXsmqei9sYZs1z6zaHzIBfe6U bvgocBp5hqrbeETTuZT6jsNw5tmorYGALuLU4Mbv0NILZa/UiaVog0EGwxDbsXNqxLkOH4rcNQ9l8N vb39FEOZRcLTwa6wu/rO2cQDP3r79Cn9lRLhbVjqjT4DQiP9/7t1MfYM0/N5YDuQihyTZR6MmxJGQW pNsp8DXD2EU4nKWZqP3DTe+hMuxiaXAsxhv78UaoM7rGNyskygxj3S7aV8Lg==
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

