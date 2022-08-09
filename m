Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2706158D7A9
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 12:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241871AbiHIKx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 06:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233320AbiHIKxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 06:53:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AAB2B2DCE
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 03:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660042402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WaEXy7Gazz4beNS9Fpdj2dSn18vbZzjbZY+Q8mZr2QE=;
        b=BgCAgZ2aa1zwxEBnamupojxNIgO9S/veVDptZdoLDC9/n+hdANZstHiIFd4JrUXAQilbY8
        1wiTyR78LbMq5hQjms5ajuAWdX3fnUgkZaD/OmLd9aslI+iMoAEp6REe5ZwxUOSpnM+UwB
        kujXjDtsWKzAdL5xzCbh00JwDR4wKok=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-OIl218LZOsKVWjxw_wETlA-1; Tue, 09 Aug 2022 06:53:19 -0400
X-MC-Unique: OIl218LZOsKVWjxw_wETlA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F6693801168;
        Tue,  9 Aug 2022 10:53:19 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E77D3C15BA1;
        Tue,  9 Aug 2022 10:53:18 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id E67FE1C02A6; Tue,  9 Aug 2022 12:53:17 +0200 (CEST)
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
Subject: [PATCH bpf-next v4 1/3] bpf: add destructive kfunc flag
Date:   Tue,  9 Aug 2022 12:53:15 +0200
Message-Id: <20220809105317.436682-2-asavkov@redhat.com>
In-Reply-To: <20220809105317.436682-1-asavkov@redhat.com>
References: <20220809105317.436682-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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
 include/linux/btf.h          | 1 +
 kernel/bpf/verifier.c        | 5 +++++
 3 files changed, 15 insertions(+)

diff --git a/Documentation/bpf/kfuncs.rst b/Documentation/bpf/kfuncs.rst
index c0b7dae6dbf5..2e97e08be7de 100644
--- a/Documentation/bpf/kfuncs.rst
+++ b/Documentation/bpf/kfuncs.rst
@@ -146,6 +146,15 @@ that operate (change some property, perform some operation) on an object that
 was obtained using an acquire kfunc. Such kfuncs need an unchanged pointer to
 ensure the integrity of the operation being performed on the expected object.
 
+2.4.5 KF_DESTRUCTIVE flag
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
index cdb376d53238..51a0961c84e3 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -49,6 +49,7 @@
  * for this case.
  */
 #define KF_TRUSTED_ARGS (1 << 4) /* kfunc only takes trusted pointer arguments */
+#define KF_DESTRUCTIVE  (1 << 5) /* kfunc performs destructive actions */
 
 struct btf;
 struct btf_member;
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 843a966cd02b..163cc0a2dc5a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7598,6 +7598,11 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
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

