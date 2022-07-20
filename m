Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3CAE57B5D8
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 13:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbiGTLrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 07:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240078AbiGTLrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 07:47:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5084072EE4
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 04:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658317621;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g06cmQhxtWongT74HQrJI3RxqUKnTwuU+objD2w+8DQ=;
        b=BQkw4d5eGu0N5XrxwUa3KDTqBb8EYDdmpju05qTq+m3VR0Cukl3VSkZKsMp2YPBA8bmSVP
        oohHKq9a8Cym/J2RyVDA2ln3CqGUYohgiv/N4jmBxkoaWjpdBwti3B8tkSpT/GWLCs4qWN
        hpCd9kqYzRUzXl87izY34fLfsWKoaRQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-qSZi_rb2NOq7SdRI1IytoQ-1; Wed, 20 Jul 2022 07:46:56 -0400
X-MC-Unique: qSZi_rb2NOq7SdRI1IytoQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69139185A7B2;
        Wed, 20 Jul 2022 11:46:55 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F0518C04482;
        Wed, 20 Jul 2022 11:46:54 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id 038241C02AA; Wed, 20 Jul 2022 13:46:53 +0200 (CEST)
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
Subject: [PATCH bpf-next 2/4] bpf: add destructive kfunc set
Date:   Wed, 20 Jul 2022 13:46:50 +0200
Message-Id: <20220720114652.3020467-3-asavkov@redhat.com>
In-Reply-To: <20220720114652.3020467-1-asavkov@redhat.com>
References: <20220720114652.3020467-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add BTF_KFUNC_TYPE_DESTRUCTIVE and a new destructive_set in struct
btf_kfunc_id_set. Functions in this set will require CAP_SYS_BOOT
capabilities and BPF_F_DESTRUCTIVE flag.

Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 include/linux/btf.h   |  2 ++
 kernel/bpf/verifier.c | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 1bfed7fa04287..6c58aa70e8125 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -18,6 +18,7 @@ enum btf_kfunc_type {
 	BTF_KFUNC_TYPE_RELEASE,
 	BTF_KFUNC_TYPE_RET_NULL,
 	BTF_KFUNC_TYPE_KPTR_ACQUIRE,
+	BTF_KFUNC_TYPE_DESTRUCTIVE,
 	BTF_KFUNC_TYPE_MAX,
 };
 
@@ -37,6 +38,7 @@ struct btf_kfunc_id_set {
 			struct btf_id_set *release_set;
 			struct btf_id_set *ret_null_set;
 			struct btf_id_set *kptr_acquire_set;
+			struct btf_id_set *destructive_set;
 		};
 		struct btf_id_set *sets[BTF_KFUNC_TYPE_MAX];
 	};
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c59c3df0fea61..064035e70deac 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7582,6 +7582,18 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 		return -EACCES;
 	}
 
+	if (btf_kfunc_id_set_contains(desc_btf, resolve_prog_type(env->prog),
+				      BTF_KFUNC_TYPE_DESTRUCTIVE, func_id)) {
+		if (!env->prog->aux->destructive) {
+			verbose(env, "destructive kfunc calls require BPF_F_DESTRUCTIVE flag\n");
+			return -EACCES;
+		}
+		if (!capable(CAP_SYS_BOOT)) {
+			verbose(env, "destructive kfunc calls require CAP_SYS_BOOT capabilities\n");
+			return -EACCES;
+		}
+	}
+
 	acq = btf_kfunc_id_set_contains(desc_btf, resolve_prog_type(env->prog),
 					BTF_KFUNC_TYPE_ACQUIRE, func_id);
 
-- 
2.35.3

