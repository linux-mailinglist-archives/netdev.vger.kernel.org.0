Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A8F4DDE72
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238722AbiCRQRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238705AbiCRQRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:17:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 808A4100E23
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 09:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647620186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OQUDhoqS/TjN6VMPOB7LXHwoVdY1tkFbLh8p1nVVoZ4=;
        b=MUTGL2kHI18uRwnMZw6w8uXofzGa3PA6e6D0qgyJT0cr/O2d0Me/G934zVfZI9wS+lFZHO
        kCx1pejN65Tgs9xKNOgLVuxnJoQHdpVSd8/MbMbcUveIwaGNYt/z96Ncvmz3r2zoPyvmpX
        TU49Aqj4sZg3e8KH2djs3/clIn61q9E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-MtPvz53eNkyP14MEJMP5fg-1; Fri, 18 Mar 2022 12:16:23 -0400
X-MC-Unique: MtPvz53eNkyP14MEJMP5fg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 58852296A624;
        Fri, 18 Mar 2022 16:16:22 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 39658421C3;
        Fri, 18 Mar 2022 16:16:19 +0000 (UTC)
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
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v3 03/17] bpf/verifier: prevent non GPL programs to be loaded against HID
Date:   Fri, 18 Mar 2022 17:15:14 +0100
Message-Id: <20220318161528.1531164-4-benjamin.tissoires@redhat.com>
In-Reply-To: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

no changes in v3

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
index 9c8dbd389995..7f596554fe8c 100644
--- a/include/linux/bpf-hid.h
+++ b/include/linux/bpf-hid.h
@@ -2,6 +2,7 @@
 #ifndef _BPF_HID_H
 #define _BPF_HID_H
 
+#include <linux/bpf_verifier.h>
 #include <linux/mutex.h>
 #include <uapi/linux/bpf.h>
 #include <uapi/linux/bpf_hid.h>
@@ -69,6 +70,8 @@ int bpf_hid_prog_query(const union bpf_attr *attr,
 		       union bpf_attr __user *uattr);
 int bpf_hid_link_create(const union bpf_attr *attr,
 			struct bpf_prog *prog);
+int bpf_hid_verify_prog(struct bpf_verifier_log *vlog,
+			const struct bpf_prog *prog);
 #else
 static inline int bpf_hid_prog_query(const union bpf_attr *attr,
 				     union bpf_attr __user *uattr)
@@ -81,6 +84,11 @@ static inline int bpf_hid_link_create(const union bpf_attr *attr,
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
index c21dc05f6207..2dfeaaa8a83f 100644
--- a/kernel/bpf/hid.c
+++ b/kernel/bpf/hid.c
@@ -34,6 +34,18 @@ void bpf_hid_set_hooks(struct bpf_hid_hooks *hooks)
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
 BPF_CALL_3(bpf_hid_get_data, struct hid_bpf_ctx_kern*, ctx, u64, offset, u64, size)
 {
 	if (!size)
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index cf92f9c01556..da06d633fb8d 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -21,6 +21,7 @@
 #include <linux/perf_event.h>
 #include <linux/ctype.h>
 #include <linux/error-injection.h>
+#include <linux/bpf-hid.h>
 #include <linux/bpf_lsm.h>
 #include <linux/btf_ids.h>
 
@@ -14272,6 +14273,12 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
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

