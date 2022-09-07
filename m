Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2525B0907
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiIGPqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIGPqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:46:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C037F6E8A9
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 08:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662565558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nj5BlWEjHAbOxvMpguL3MAZX7qC3A5IN2hGEHZzAY40=;
        b=PpknVjmzvIYfRRsl3rWcJ7UItHyr3prjnzASkcwDS9hOT/xFgQqM8xJEkXtc9qdU2HLP3A
        3KVxwNgpUko6bK5dKqpqdcYrfERjMQJyaqathsV34h+6LeubPgEm7crYVRDpFGjXJ8PWXr
        TzZCZNenQKnZ+260Vp2b6iPq/WfKhhI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-436-z2XTngRQPGGugyPz_uhMmg-1; Wed, 07 Sep 2022 11:45:53 -0400
X-MC-Unique: z2XTngRQPGGugyPz_uhMmg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7425D80A0B9;
        Wed,  7 Sep 2022 15:45:52 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A29790A04;
        Wed,  7 Sep 2022 15:45:52 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 35B0330721A6C;
        Wed,  7 Sep 2022 17:45:51 +0200 (CEST)
Subject: [PATCH RFCv2 bpf-next 10/18] btf: Add helper for kernel modules to
 lookup full BTF ID
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
Date:   Wed, 07 Sep 2022 17:45:51 +0200
Message-ID: <166256555117.1434226.17491394872817800182.stgit@firesoul>
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

NIC driver modules need to store the full BTF ID as the last member in
metadata area usually written as xdp_hints_common->btf_full_id.
This full BTF ID is a 64-bit value, encoding the modules own BTF object
ID as the high 32-bit and specific struct BTF type ID as lower 32-bit.

Drivers should invoke this once at init time and cache this BTF ID for
runtime usage.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/linux/btf.h |    1 +
 kernel/bpf/btf.c    |   23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index a66266c00c04..b8f7c92b6767 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -150,6 +150,7 @@ bool btf_is_module(const struct btf *btf);
 struct module *btf_try_get_module(const struct btf *btf);
 struct btf *btf_get_module_btf(const struct module *module);
 void btf_put_module_btf(struct btf *btf);
+u64 btf_get_module_btf_full_id(struct btf *btf, const char *name);
 u32 btf_nr_types(const struct btf *btf);
 bool btf_member_is_reg_int(const struct btf *btf, const struct btf_type *s,
 			   const struct btf_member *m,
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 1e95391e0ca1..10a859943a49 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -7092,6 +7092,29 @@ struct btf *btf_get_module_btf(const struct module *module)
 }
 EXPORT_SYMBOL_GPL(btf_get_module_btf);
 
+u64 btf_get_module_btf_full_id(struct btf *btf, const char *name)
+{
+	s32 type_id;
+	u64 obj_id;
+
+	if (IS_ERR_OR_NULL(btf))
+		return 0;
+
+	obj_id  = btf_obj_id(btf);
+	type_id = btf_find_by_name_kind(btf, name, BTF_KIND_STRUCT);
+	if (type_id < 0) {
+		pr_warn("Module %s(ID:%d): BTF cannot find struct %s",
+			btf->name, (u32)obj_id, name);
+		return 0;
+	}
+
+	pr_info("Module %s(ID:%d): BTF type id %d for struct %s",
+		btf->name, (u32)obj_id, type_id, name);
+
+	return type_id | (obj_id << 32);
+}
+EXPORT_SYMBOL_GPL(btf_get_module_btf_full_id);
+
 BPF_CALL_4(bpf_btf_find_by_name_kind, char *, name, int, name_sz, u32, kind, int, flags)
 {
 	struct btf *btf = NULL;


