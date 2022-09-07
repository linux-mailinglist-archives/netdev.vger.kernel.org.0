Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A6F5B0904
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiIGPqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiIGPp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:45:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170706F268
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 08:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662565551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e8qzYn67mc0YUjcpq2BNfwdPV/CrkwgKNBPhMy5km50=;
        b=PaWyiTfVzOc9mYAiiJpuwWU6LM8eCbLSFcEv9myzFe/alAB77gII39wt0UGq7uc0tDcGMn
        qG3L4FxV97BtzzkBckmLQwDp4dq+i4twU1IyL7LVk9uRB5yqj04Cx2TAf3FuASKiGOvUIq
        EM7wgwyTL2LeHRPJFh0iAcRBGfeJio4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-412-P7_TQDObNXik3CSFnSY3QQ-1; Wed, 07 Sep 2022 11:45:48 -0400
X-MC-Unique: P7_TQDObNXik3CSFnSY3QQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1BE0D811E90;
        Wed,  7 Sep 2022 15:45:47 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D37234C816;
        Wed,  7 Sep 2022 15:45:46 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 27C7C30721A6C;
        Wed,  7 Sep 2022 17:45:46 +0200 (CEST)
Subject: [PATCH RFCv2 bpf-next 09/18] bpf: export btf functions for modules
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Date:   Wed, 07 Sep 2022 17:45:46 +0200
Message-ID: <166256554611.1434226.15342391322311314838.stgit@firesoul>
In-Reply-To: <166256538687.1434226.15760041133601409770.stgit@firesoul>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows modules to lookup their own module BTF info.

These are get and set operations that bump the refcount.
Thus, modules can use this to control the lifetime.

Suggested-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/linux/btf.h |    2 ++
 kernel/bpf/btf.c    |   13 ++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index ad93c2d9cc1c..a66266c00c04 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -148,6 +148,8 @@ u32 btf_obj_id(const struct btf *btf);
 bool btf_is_kernel(const struct btf *btf);
 bool btf_is_module(const struct btf *btf);
 struct module *btf_try_get_module(const struct btf *btf);
+struct btf *btf_get_module_btf(const struct module *module);
+void btf_put_module_btf(struct btf *btf);
 u32 btf_nr_types(const struct btf *btf);
 bool btf_member_is_reg_int(const struct btf *btf, const struct btf_type *s,
 			   const struct btf_member *m,
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 903719b89238..1e95391e0ca1 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -534,6 +534,7 @@ s32 btf_find_by_name_kind(const struct btf *btf, const char *name, u8 kind)
 
 	return -ENOENT;
 }
+EXPORT_SYMBOL_GPL(btf_find_by_name_kind);
 
 static s32 bpf_find_btf_id(const char *name, u32 kind, struct btf **btf_p)
 {
@@ -1673,6 +1674,15 @@ void btf_put(struct btf *btf)
 	}
 }
 
+void btf_put_module_btf(struct btf *btf)
+{
+	if (!btf_is_module(btf))
+		return;
+
+	btf_put(btf);
+}
+EXPORT_SYMBOL_GPL(btf_put_module_btf);
+
 static int env_resolve_init(struct btf_verifier_env *env)
 {
 	struct btf *btf = env->btf;
@@ -7051,7 +7061,7 @@ struct module *btf_try_get_module(const struct btf *btf)
 /* Returns struct btf corresponding to the struct module.
  * This function can return NULL or ERR_PTR.
  */
-static struct btf *btf_get_module_btf(const struct module *module)
+struct btf *btf_get_module_btf(const struct module *module)
 {
 #ifdef CONFIG_DEBUG_INFO_BTF_MODULES
 	struct btf_module *btf_mod, *tmp;
@@ -7080,6 +7090,7 @@ static struct btf *btf_get_module_btf(const struct module *module)
 
 	return btf;
 }
+EXPORT_SYMBOL_GPL(btf_get_module_btf);
 
 BPF_CALL_4(bpf_btf_find_by_name_kind, char *, name, int, name_sz, u32, kind, int, flags)
 {


