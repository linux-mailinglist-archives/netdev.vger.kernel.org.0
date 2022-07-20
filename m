Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C6657B5D0
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 13:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240810AbiGTLrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 07:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240573AbiGTLrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 07:47:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 632C672ED1
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 04:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658317619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ps3HbKw+ZKHP03+QBxxOuT2PvyOYzR9awecLsiV/Aw0=;
        b=eoE3TkjngPAjqtdRVk7+cwqpmqp24KJQXB4PrTGJMr4jCxTQpgQn7fRGcU8v/JNGeqiq/z
        ShAolHHCIcPYa8uyi2S4V3aiSGTlcvgzt++iZW0Pd9hDFSLLqeIeutFOvtlXN8yMiuMq8E
        kteVcGeB7Zm+QM7kdHRBSjSkgdBd5wM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-yLGXJffjNHS7mIBDvdxJKQ-1; Wed, 20 Jul 2022 07:46:56 -0400
X-MC-Unique: yLGXJffjNHS7mIBDvdxJKQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6711F811E75;
        Wed, 20 Jul 2022 11:46:55 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EF4E51121314;
        Wed, 20 Jul 2022 11:46:54 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id ED36F1C022D; Wed, 20 Jul 2022 13:46:53 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>,
        Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>,
        Artem Savkov <asavkov@redhat.com>
Subject: [PATCH bpf-next 1/4] bpf: add BPF_F_DESTRUCTIVE flag for BPF_PROG_LOAD
Date:   Wed, 20 Jul 2022 13:46:49 +0200
Message-Id: <20220720114652.3020467-2-asavkov@redhat.com>
In-Reply-To: <20220720114652.3020467-1-asavkov@redhat.com>
References: <20220720114652.3020467-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a BPF_F_DESTRUCTIVE flag which will be required to be supplied
during BPF_PROG_LOAD for programs to be able to call destructive kfuncs.

Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 include/linux/bpf.h            | 1 +
 include/uapi/linux/bpf.h       | 6 ++++++
 kernel/bpf/syscall.c           | 4 +++-
 tools/include/uapi/linux/bpf.h | 6 ++++++
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a5bf00649995e..7b404d0b80aef 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1044,6 +1044,7 @@ struct bpf_prog_aux {
 	bool sleepable;
 	bool tail_call_reachable;
 	bool xdp_has_frags;
+	bool destructive;
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
 	const struct btf_type *attach_func_proto;
 	/* function name for valid attach_btf_id */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 379e68fb866fc..ae81ad2e658dd 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1122,6 +1122,12 @@ enum bpf_link_type {
  */
 #define BPF_F_XDP_HAS_FRAGS	(1U << 5)
 
+/* If BPF_F_DESTRUCTIVE is used in BPF_PROG_LOAD command, the loaded program
+ * will be able to perform destructive operations such as calling bpf_panic()
+ * helper.
+ */
+#define BPF_F_DESTRUCTIVE	(1U << 6)
+
 /* link_create.kprobe_multi.flags used in LINK_CREATE command for
  * BPF_TRACE_KPROBE_MULTI attach type to create return probe.
  */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 83c7136c5788d..86927521d0ea2 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2467,7 +2467,8 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 				 BPF_F_TEST_STATE_FREQ |
 				 BPF_F_SLEEPABLE |
 				 BPF_F_TEST_RND_HI32 |
-				 BPF_F_XDP_HAS_FRAGS))
+				 BPF_F_XDP_HAS_FRAGS |
+				 BPF_F_DESTRUCTIVE))
 		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
@@ -2554,6 +2555,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	prog->aux->offload_requested = !!attr->prog_ifindex;
 	prog->aux->sleepable = attr->prog_flags & BPF_F_SLEEPABLE;
 	prog->aux->xdp_has_frags = attr->prog_flags & BPF_F_XDP_HAS_FRAGS;
+	prog->aux->destructive = attr->prog_flags & BPF_F_DESTRUCTIVE;
 
 	err = security_bpf_prog_alloc(prog->aux);
 	if (err)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 379e68fb866fc..ae81ad2e658dd 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1122,6 +1122,12 @@ enum bpf_link_type {
  */
 #define BPF_F_XDP_HAS_FRAGS	(1U << 5)
 
+/* If BPF_F_DESTRUCTIVE is used in BPF_PROG_LOAD command, the loaded program
+ * will be able to perform destructive operations such as calling bpf_panic()
+ * helper.
+ */
+#define BPF_F_DESTRUCTIVE	(1U << 6)
+
 /* link_create.kprobe_multi.flags used in LINK_CREATE command for
  * BPF_TRACE_KPROBE_MULTI attach type to create return probe.
  */
-- 
2.35.3

