Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26514DAFB0
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 13:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355771AbiCPM1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 08:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355756AbiCPM1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 08:27:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1751E66633;
        Wed, 16 Mar 2022 05:25:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 915CD6173F;
        Wed, 16 Mar 2022 12:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C49C340E9;
        Wed, 16 Mar 2022 12:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647433546;
        bh=jUnqoYHudVwYZJL+AKojaD86W24+0ez+MxKqi9a9/xM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mw/40aUAx2oO6hoaHNmNtv6vx+1kV2+0UDOFSBuwghNKW288jmO0tjMQ7jHK3PdDL
         5hNSDcOZedDLTf/W9adYm48yx7+hpOSICS7NKLhpnBFOBE3ePqJ70Sj68ihoCOw/J8
         ZCaGTrk65y7w5YIAbAZPQt3pawG2lHhi5Fh2LzTglSNAmuQI4O3v4eZXzb0QThXm3+
         +NIcA/UVmyy+mwP6Ar/xalxa4KCCRLSHwy9cWBRAmoIpHelrCl8Fp5Ipa2UgOf0ka8
         gVm4nDDWtLuk2Oz/dOCrZ9hDpbI5JxH6EyoN8saCM7zoblu3lgmY3OrsrCfJYKk1j/
         SJCUe6+YS6GyA==
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCHv3 bpf-next 07/13] libbpf: Add libbpf_kallsyms_parse function
Date:   Wed, 16 Mar 2022 13:24:13 +0100
Message-Id: <20220316122419.933957-8-jolsa@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220316122419.933957-1-jolsa@kernel.org>
References: <20220316122419.933957-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the kallsyms parsing in internal libbpf_kallsyms_parse
function, so it can be used from other places.

It will be used in following changes.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/lib/bpf/libbpf.c          | 62 ++++++++++++++++++++-------------
 tools/lib/bpf/libbpf_internal.h |  5 +++
 2 files changed, 43 insertions(+), 24 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 43161fdd44bb..1ca520a29fdb 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7171,12 +7171,10 @@ static int bpf_object__sanitize_maps(struct bpf_object *obj)
 	return 0;
 }
 
-static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
+int libbpf_kallsyms_parse(kallsyms_cb_t cb, void *ctx)
 {
 	char sym_type, sym_name[500];
 	unsigned long long sym_addr;
-	const struct btf_type *t;
-	struct extern_desc *ext;
 	int ret, err = 0;
 	FILE *f;
 
@@ -7195,35 +7193,51 @@ static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
 		if (ret != 3) {
 			pr_warn("failed to read kallsyms entry: %d\n", ret);
 			err = -EINVAL;
-			goto out;
+			break;
 		}
 
-		ext = find_extern_by_name(obj, sym_name);
-		if (!ext || ext->type != EXT_KSYM)
-			continue;
-
-		t = btf__type_by_id(obj->btf, ext->btf_id);
-		if (!btf_is_var(t))
-			continue;
-
-		if (ext->is_set && ext->ksym.addr != sym_addr) {
-			pr_warn("extern (ksym) '%s' resolution is ambiguous: 0x%llx or 0x%llx\n",
-				sym_name, ext->ksym.addr, sym_addr);
-			err = -EINVAL;
-			goto out;
-		}
-		if (!ext->is_set) {
-			ext->is_set = true;
-			ext->ksym.addr = sym_addr;
-			pr_debug("extern (ksym) %s=0x%llx\n", sym_name, sym_addr);
-		}
+		err = cb(sym_addr, sym_type, sym_name, ctx);
+		if (err)
+			break;
 	}
 
-out:
 	fclose(f);
 	return err;
 }
 
+static int kallsyms_cb(unsigned long long sym_addr, char sym_type,
+		       const char *sym_name, void *ctx)
+{
+	struct bpf_object *obj = ctx;
+	const struct btf_type *t;
+	struct extern_desc *ext;
+
+	ext = find_extern_by_name(obj, sym_name);
+	if (!ext || ext->type != EXT_KSYM)
+		return 0;
+
+	t = btf__type_by_id(obj->btf, ext->btf_id);
+	if (!btf_is_var(t))
+		return 0;
+
+	if (ext->is_set && ext->ksym.addr != sym_addr) {
+		pr_warn("extern (ksym) '%s' resolution is ambiguous: 0x%llx or 0x%llx\n",
+			sym_name, ext->ksym.addr, sym_addr);
+		return -EINVAL;
+	}
+	if (!ext->is_set) {
+		ext->is_set = true;
+		ext->ksym.addr = sym_addr;
+		pr_debug("extern (ksym) %s=0x%llx\n", sym_name, sym_addr);
+	}
+	return 0;
+}
+
+static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
+{
+	return libbpf_kallsyms_parse(kallsyms_cb, obj);
+}
+
 static int find_ksym_btf_id(struct bpf_object *obj, const char *ksym_name,
 			    __u16 kind, struct btf **res_btf,
 			    struct module_btf **res_mod_btf)
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 4fda8bdf0a0d..b6247dc7f8eb 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -449,6 +449,11 @@ __s32 btf__find_by_name_kind_own(const struct btf *btf, const char *type_name,
 
 extern enum libbpf_strict_mode libbpf_mode;
 
+typedef int (*kallsyms_cb_t)(unsigned long long sym_addr, char sym_type,
+			     const char *sym_name, void *ctx);
+
+int libbpf_kallsyms_parse(kallsyms_cb_t cb, void *arg);
+
 /* handle direct returned errors */
 static inline int libbpf_err(int ret)
 {
-- 
2.35.1

