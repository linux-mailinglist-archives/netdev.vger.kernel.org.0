Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1B158E77D
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 08:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbiHJG7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 02:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiHJG7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 02:59:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CBEF872EC3
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 23:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660114750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s/g1jGP9DmVuf1qGmI16BGeQdTRGm51fgmAVNuH3Cg8=;
        b=LvZxvP/+kyLscaE/F02YPn8zWMT2bT669Jr4yYn/GnRfMGYIXGEzbBLjV0AQrbL8kVEOiK
        Yq0MVUHoCK3T26hWm9Yte+LfwKFuqqYSsN4O/zeWyT+RbcmCQC2+wVMk4+z6o4KdHrFACJ
        x0e8HyTXxuUVes9dtiraanJ8jUOox2E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-fIfyWb7CPO-V6M-yVKGyoQ-1; Wed, 10 Aug 2022 02:59:09 -0400
X-MC-Unique: fIfyWb7CPO-V6M-yVKGyoQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25D513C0F394;
        Wed, 10 Aug 2022 06:59:08 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D6DC1C15BA1;
        Wed, 10 Aug 2022 06:59:07 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id D768D1C00A9; Wed, 10 Aug 2022 08:59:06 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>,
        Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>,
        Daniel Xu <dxu@dxuuu.xyz>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Artem Savkov <asavkov@redhat.com>
Subject: [PATCH bpf-next v5 1/3] bpf: add destructive kfunc flag
Date:   Wed, 10 Aug 2022 08:59:03 +0200
Message-Id: <20220810065905.475418-2-asavkov@redhat.com>
In-Reply-To: <20220810065905.475418-1-asavkov@redhat.com>
References: <20220810065905.475418-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add KF_DESTRUCTIVE flag for destructive functions. Functions with this
flag set will require CAP_SYS_BOOT capabilities.

Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 Documentation/bpf/kfuncs.rst | 9 +++++++++
 include/linux/btf.h          | 3 ++-
 kernel/bpf/verifier.c        | 5 +++++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
index c8b21de1c772..781731749e55 100644
--- a/Documentation/bpf/kfuncs.rst
+++ b/Documentation/bpf/kfuncs.rst
@@ -152,6 +152,15 @@ ensure the integrity of the operation being performed on the expected object.
 The KF_SLEEPABLE flag is used for kfuncs that may sleep. Such kfuncs can only
 be called by sleepable BPF programs (BPF_F_SLEEPABLE).
 
+2.4.7 KF_DESTRUCTIVE flag
+--------------------------
+
+The KF_DESTRUCTIVE flag is used to indicate functions calling which is
+destructive to the system. For example such a call can result in system
+rebooting or panicking. Due to this additional restrictions apply to these
+calls. At the moment they only require CAP_SYS_BOOT capability, but more can be
+added later.
+
 2.5 Registering the kfuncs
 --------------------------
 
diff --git a/include/linux/btf.h b/include/linux/btf.h
index 976cbdd2981f..ad93c2d9cc1c 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -49,7 +49,8 @@
  * for this case.
  */
 #define KF_TRUSTED_ARGS (1 << 4) /* kfunc only takes trusted pointer arguments */
-#define KF_SLEEPABLE   (1 << 5) /* kfunc may sleep */
+#define KF_SLEEPABLE    (1 << 5) /* kfunc may sleep */
+#define KF_DESTRUCTIVE  (1 << 6) /* kfunc performs destructive actions */
 
 struct btf;
 struct btf_member;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 28b02dc67a2a..2c1f8069f7b7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7584,6 +7584,11 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 			func_name);
 		return -EACCES;
 	}
+	if (*kfunc_flags & KF_DESTRUCTIVE && !capable(CAP_SYS_BOOT)) {
+		verbose(env, "destructive kfunc calls require CAP_SYS_BOOT capabilities\n");
+		return -EACCES;
+	}
+
 	acq = *kfunc_flags & KF_ACQUIRE;
 
 	/* Check the arguments */
-- 
2.37.1

