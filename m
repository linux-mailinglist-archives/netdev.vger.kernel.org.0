Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9907040BF2A
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 07:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236329AbhIOFLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 01:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236254AbhIOFLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 01:11:19 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F838C061766;
        Tue, 14 Sep 2021 22:10:01 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id c4so895575pls.6;
        Tue, 14 Sep 2021 22:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yU4+xx6iAwgsGxgz5Ht4AFD9WjITvbQsNdCqZ6ULtK4=;
        b=jh8HDcMPf45DhOLihCT5N8oTXqX9naadNMRTPWyO5FYGi5nK8PiHml2qJwGZtnMF8t
         4Fdetq2kCQiGP7EPbDycuGqCP+QBe1mXjckmYx9ri79zhRKrte+gNsSBZ8pMhFAlta7p
         s3fXXye/3m+/DpD7dxOzhi9C5AjzAFsq6aDAY248DZfFtRLt4bxlOh6rzcDI18D7iFjY
         oBX3Dtj9JZFV2CFSI5EmgKpMBme/z3YozhhAGNHR9BOOeUDF6mgUN2BF3upAsc0ciYRh
         Yw+lb67qc7GVz/xlhZYBojjP1u25uLPHXak+EfBh8im5fwMSXyOHPSGHp3yu82NyxCvp
         W5Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yU4+xx6iAwgsGxgz5Ht4AFD9WjITvbQsNdCqZ6ULtK4=;
        b=MIecdY+sa1ZZitVK+pNd0bDOT/Fig4caltol7I7DJokByyjakf7TD74Y7xFT1ahxxo
         7ndQydpKPKTt0uyINohNzbCOPjv7nD3NqgMFqRNUwoHXLw56Rc8nHHc3azfru6b7kPXo
         GsjEuThqBh6RsbCXepV8Q967GiDK9/+6zdad0K5kmRs1OTfpEkdCGyed1rGy/ZCcIOLi
         7YemkacIQLepNuDfaOeCkwPudl7IN63o3OBde5KNvr6kl7DfKI++yLLFQ41N5u/1qmV9
         vp5TQzl/OJoszfs4Hp2Sd1ACcQ3OMVU8EuHKUBR45kbptU7nCzyUYt7MKgfVpFq8jY3B
         9SEg==
X-Gm-Message-State: AOAM532RoCD4Yd7979IlyWPIfftVKmC3krVPMwgta7FfSXchzzX0PtSj
        Yc59gnJVSmTEstiZfgcisHLWiLXfXOoVzw==
X-Google-Smtp-Source: ABdhPJzit4XYMsAoo3nh2avld730FfRl6hDgwJaD0zlDa9cp7St2O48Xni4h0l5eFjaCrmt/ef3Z/g==
X-Received: by 2002:a17:90a:cc6:: with SMTP id 6mr6404623pjt.233.1631682600429;
        Tue, 14 Sep 2021 22:10:00 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id g16sm12621422pfj.19.2021.09.14.22.09.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 22:10:00 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 04/10] tools: Allow specifying base BTF file in resolve_btfids
Date:   Wed, 15 Sep 2021 10:39:37 +0530
Message-Id: <20210915050943.679062-5-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210915050943.679062-1-memxor@gmail.com>
References: <20210915050943.679062-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2098; h=from:subject; bh=kZhRM1Uo6vUje4gN/WsUjSsDNLJ5u0WuItuVyu5D9Zk=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhQX4bDhwehFEbRic2pkL2wCQ10r1eCg0KKIKoWVSG lKYtwOmJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUF+GwAKCRBM4MiGSL8Ryv8tEA CnaYUads2VlZfhSKM0CmWbw6XZzCmtgYawOKqLpcms/dV1JzT8Wumgzz7sM9vLePvBhEgmyatJwCJD gFkCU/UBII+cmQdzWGqJqOrL8dRFOOyKpdRoUk1RXxYcAtdVJ73SrI6F7L6GXMoYlJRcmPYz127Ns7 3XzEvwXOqjenkRBLS5e5DUogrtzTkdv1V5d0z4g1w4/XmySOBoC5hkP7Ug/gX6xhYNP2/IRmss1ZfA yE8G4qtOTb808JGfZftKthEoHFvJrFPuZco0/CcHu2X2v9PcgyQ1VStKr9PQOa72+HuWpb03O+H6k3 4mNiP+VOgDfR6wYKY/SOWi/zEoRSWoztW8HMmWyBv/gLPPluiCvCppCU89cMdipK4hXUbAZSBxwnYv VYEtSAf+wZgZp7iu7XxkzZivAb+nOg9OzJ/p2pu7TB8Qa+n0Ugn08ujbzhMCXwnBDE3UJPOp9Ysp1k MHeCvTCoFbtttEYDqlNvytcZyB41/lkmhbWcdpFcNiCTM3g9poKMyztjo09tBOQlqMul7si59o87az u+ZUL9EVpuwJ2PBcsMj3LYw6g3p7prkWU673QVT284JVIKTjgBZ8Vc4i20KGboFZzi3ZIRc126lb59 HlE7f6Vh1GWRP0wLR5ImsjHH5ZT96LvoOSib+jqBPwrVPTAB1A68E+L9eOTQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commits allows specifying the base BTF for resolving btf id
lists/sets during link time in the resolve_btfids tool. The base BTF is
set to NULL if no path is passed. This allows resolving BTF ids for
module kernel objects.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/bpf/resolve_btfids/main.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
index de6365b53c9c..206e1120082f 100644
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
@@ -697,6 +710,8 @@ int main(int argc, const char **argv)
 			   "BTF data"),
 		OPT_BOOLEAN(0, "no-fail", &no_fail,
 			   "do not fail if " BTF_IDS_SECTION " section is not found"),
+		OPT_STRING('s', "base-btf", &obj.base_btf_path, "file",
+			   "path of file providing base BTF data"),
 		OPT_END()
 	};
 	int err = -1;
-- 
2.33.0

