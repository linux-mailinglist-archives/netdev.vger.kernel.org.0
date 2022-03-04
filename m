Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74F64CDAF6
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240432AbiCDRgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:36:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241373AbiCDRfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:35:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 13CC21D085E
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:34:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646415273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hyjhRPbC8PoyGPK2vPUfa6keKBWHXHhBVk1iPd78sYA=;
        b=LX1oO7JnuAxTbQf7aKL+MChL5E/cgTMlyiVCaBSrQAe309tUYjzLUVwRvIopSWsVyecunC
        XE4TiJkgi+INgqffNczfIf4ZZ9GFn7KfdsavU8uPrxwAN0po6i7gU5DPequQ7XHLGECHLn
        K38dO5TqJlkaKQwbp1W3TSAzbLxfvdM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-640-SBCJqgcINg6uDPA-vRyA7w-1; Fri, 04 Mar 2022 12:34:29 -0500
X-MC-Unique: SBCJqgcINg6uDPA-vRyA7w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 004E11006AAA;
        Fri,  4 Mar 2022 17:34:26 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9BCB286596;
        Fri,  4 Mar 2022 17:34:11 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v2 22/28] bpf/verifier: prevent non GPL programs to be loaded against HID
Date:   Fri,  4 Mar 2022 18:28:46 +0100
Message-Id: <20220304172852.274126-23-benjamin.tissoires@redhat.com>
In-Reply-To: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is just to hammer the obvious because I suspect you can not already
load a bpf HID program which is not GPL because all of the useful
functions are GPL only.

Anyway, this ensures that users are not tempted to bypass this requirement
and will allow us to ship tested BPF programs in the kernel without having
to aorry about the license.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

---

new in v2:
 - Note: I placed this statement in check_attach_btf_id() to be local to
   other similar checks (regarding LSM), however, I have no idea if this
   is the correct place. Please shout at me if it isn't.
---
 include/linux/bpf-hid.h |  8 ++++++++
 kernel/bpf/hid.c        | 12 ++++++++++++
 kernel/bpf/verifier.c   |  7 +++++++
 3 files changed, 27 insertions(+)

diff --git a/include/linux/bpf-hid.h b/include/linux/bpf-hid.h
index bd548f6a4a26..3da1d0ecb9be 100644
--- a/include/linux/bpf-hid.h
+++ b/include/linux/bpf-hid.h
@@ -2,6 +2,7 @@
 #ifndef _BPF_HID_H
 #define _BPF_HID_H
 
+#include <linux/bpf_verifier.h>
 #include <linux/mutex.h>
 #include <uapi/linux/bpf.h>
 #include <uapi/linux/bpf_hid.h>
@@ -71,6 +72,8 @@ int bpf_hid_prog_query(const union bpf_attr *attr,
 		       union bpf_attr __user *uattr);
 int bpf_hid_link_create(const union bpf_attr *attr,
 			struct bpf_prog *prog);
+int bpf_hid_verify_prog(struct bpf_verifier_log *vlog,
+			const struct bpf_prog *prog);
 #else
 static inline int bpf_hid_prog_query(const union bpf_attr *attr,
 				     union bpf_attr __user *uattr)
@@ -83,6 +86,11 @@ static inline int bpf_hid_link_create(const union bpf_attr *attr,
 {
 	return -EOPNOTSUPP;
 }
+static inline int bpf_hid_verify_prog(struct bpf_verifier_log *vlog,
+				      const struct bpf_prog *prog)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 static inline bool bpf_hid_link_empty(struct bpf_hid *bpf,
diff --git a/kernel/bpf/hid.c b/kernel/bpf/hid.c
index 653d10c0f4e6..b3dc1cd37a3e 100644
--- a/kernel/bpf/hid.c
+++ b/kernel/bpf/hid.c
@@ -37,6 +37,18 @@ void bpf_hid_set_hooks(struct bpf_hid_hooks *hooks)
 }
 EXPORT_SYMBOL_GPL(bpf_hid_set_hooks);
 
+int bpf_hid_verify_prog(struct bpf_verifier_log *vlog,
+			const struct bpf_prog *prog)
+{
+	if (!prog->gpl_compatible) {
+		bpf_log(vlog,
+			"HID programs must have a GPL compatible license\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 BPF_CALL_5(bpf_hid_get_data, void*, ctx, u64, offset, u32, n, void*, data, u64, size)
 {
 	struct hid_bpf_ctx *bpf_ctx = ctx;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index a57db4b2803c..afec8fa1d674 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -21,6 +21,7 @@
 #include <linux/perf_event.h>
 #include <linux/ctype.h>
 #include <linux/error-injection.h>
+#include <linux/bpf-hid.h>
 #include <linux/bpf_lsm.h>
 #include <linux/btf_ids.h>
 
@@ -14235,6 +14236,12 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	if (prog->type == BPF_PROG_TYPE_STRUCT_OPS)
 		return check_struct_ops_btf_id(env);
 
+	if (prog->type == BPF_PROG_TYPE_HID) {
+		ret = bpf_hid_verify_prog(&env->log, prog);
+		if (ret < 0)
+			return ret;
+	}
+
 	if (prog->type != BPF_PROG_TYPE_TRACING &&
 	    prog->type != BPF_PROG_TYPE_LSM &&
 	    prog->type != BPF_PROG_TYPE_EXT)
-- 
2.35.1

