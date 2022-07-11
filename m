Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708E956D81F
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 10:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiGKIdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 04:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbiGKIcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 04:32:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ADAD61FCC0
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 01:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657528352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YEy+JbF4/MHQmoWPD6TNS3XHUSO00yIucme0xMgXZWk=;
        b=CJLpXYhHCJWmCVJL6n+rVaFQ/Vo0kBYIn8YpGRhXn4SYi3Z9dgiB2dlHlfQYncDJGAE9eg
        Rnk0/UHKYWNm/iuPwq7+g1T1MYmZzvELCeZdslX1P2zTlg7EXAUmovgP6+oHGxhMFrbjsA
        FtQwW7scJ4my2jX8VH3bVmd4hG2/Jaw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-C_R0PKqGPtiBMFNB8fnwxA-1; Mon, 11 Jul 2022 04:32:23 -0400
X-MC-Unique: C_R0PKqGPtiBMFNB8fnwxA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3097C80029D;
        Mon, 11 Jul 2022 08:32:23 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 097E01121314;
        Mon, 11 Jul 2022 08:32:22 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id F1F241C0258; Mon, 11 Jul 2022 10:32:21 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Artem Savkov <asavkov@redhat.com>
Subject: [RFC PATCH bpf-next 2/4] bpf: add BPF_F_DESTRUCTIVE flag for BPF_PROG_LOAD
Date:   Mon, 11 Jul 2022 10:32:18 +0200
Message-Id: <20220711083220.2175036-3-asavkov@redhat.com>
In-Reply-To: <20220711083220.2175036-1-asavkov@redhat.com>
References: <20220711083220.2175036-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a BPF_F_DESTRUCTIVE will be required to be supplied to
BPF_PROG_LOAD for programs to utilize destructive helpers such as
bpf_panic().

Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 include/linux/bpf.h            | 1 +
 include/uapi/linux/bpf.h       | 6 ++++++
 kernel/bpf/syscall.c           | 4 +++-
 tools/include/uapi/linux/bpf.h | 6 ++++++
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 77972724bed7..43c008e3587a 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1041,6 +1041,7 @@ struct bpf_prog_aux {
 	bool sleepable;
 	bool tail_call_reachable;
 	bool xdp_has_frags;
+	bool destructive;
 	bool use_bpf_prog_pack;
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
 	const struct btf_type *attach_func_proto;
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index e81362891596..4423874b5da4 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1121,6 +1121,12 @@ enum bpf_link_type {
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
index 1ce6541d90e1..779feac2dc7d 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2449,7 +2449,8 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 				 BPF_F_TEST_STATE_FREQ |
 				 BPF_F_SLEEPABLE |
 				 BPF_F_TEST_RND_HI32 |
-				 BPF_F_XDP_HAS_FRAGS))
+				 BPF_F_XDP_HAS_FRAGS |
+				 BPF_F_DESTRUCTIVE))
 		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
@@ -2536,6 +2537,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
 	prog->aux->offload_requested = !!attr->prog_ifindex;
 	prog->aux->sleepable = attr->prog_flags & BPF_F_SLEEPABLE;
 	prog->aux->xdp_has_frags = attr->prog_flags & BPF_F_XDP_HAS_FRAGS;
+	prog->aux->destructive = attr->prog_flags & BPF_F_DESTRUCTIVE;
 
 	err = security_bpf_prog_alloc(prog->aux);
 	if (err)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index e81362891596..4423874b5da4 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -1121,6 +1121,12 @@ enum bpf_link_type {
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

