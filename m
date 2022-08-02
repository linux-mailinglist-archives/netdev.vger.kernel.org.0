Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 418FE5879AF
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 11:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236360AbiHBJKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 05:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236265AbiHBJKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 05:10:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 05E4111814
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 02:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659431444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8SOINSRv0lSmbOTTZ6/R5mAtck6H0iUHXeANGpWfrm4=;
        b=Rwa+qECW3zrXydRZm3Y/fVzrMMK3GVaZBkDk1UiaRuQELqfNlFXLgLEEYbWYvT4Xca2sWC
        tPsEBVW2jXKnzdn0f+DdIyaeJJG7Jc0wO6TEYXDjynBCv4b7a9vlSd9APhMdCR5uPzMXb/
        nHYdxeTkdkc9wBY/RltIcOG+Zcrcl38=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-394-4WC0f5O5OXeUuFp1yppU3g-1; Tue, 02 Aug 2022 05:10:33 -0400
X-MC-Unique: 4WC0f5O5OXeUuFp1yppU3g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C82AF2801761;
        Tue,  2 Aug 2022 09:10:32 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 86E6C1121314;
        Tue,  2 Aug 2022 09:10:32 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id 81A8C1C0151; Tue,  2 Aug 2022 11:10:31 +0200 (CEST)
From:   Artem Savkov <asavkov@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>,
        Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>,
        Daniel Xu <dxu@dxuuu.xyz>, Artem Savkov <asavkov@redhat.com>
Subject: [PATCH bpf-next v2 1/3] bpf: add destructive kfunc flag
Date:   Tue,  2 Aug 2022 11:10:28 +0200
Message-Id: <20220802091030.3742334-2-asavkov@redhat.com>
In-Reply-To: <20220802091030.3742334-1-asavkov@redhat.com>
References: <20220802091030.3742334-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add KF_DESTRUCTIVE flag for destructive functions. Functions with this
flag set will require CAP_SYS_BOOT capabilities.

Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 include/linux/btf.h   | 1 +
 kernel/bpf/verifier.c | 5 +++++
 2 files changed, 6 insertions(+)

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
index 096fdac70165..e52ca1631d3f 100644
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
2.35.3

