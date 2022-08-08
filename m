Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAEBB58C5DF
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 11:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242555AbiHHJrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 05:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242158AbiHHJqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 05:46:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 392E213D76
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 02:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659951998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7SC9sX1VIexkzEyJYdxGiKKWDAqjX7RUeviVfsqmj24=;
        b=UnZn9p9zmnyxVFxl/sdlU75zOa+5RBLq5gFWsrvzG7EiM//ygfB6rRXgzbvY4jA9hnjDzU
        zknQho2wnc5FOhLVbSHDCa/o1y9ZE7HD/QUPDA8tcI8uxwHUDKp+xOWyPkk07M+I0o4m5s
        Q7uGowcbg4G7XENZrP4SEQ2P0Y3FcD4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-298-7RqlEHIBNyuL_dnjWu5pVA-1; Mon, 08 Aug 2022 05:46:25 -0400
X-MC-Unique: 7RqlEHIBNyuL_dnjWu5pVA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 21488811E81;
        Mon,  8 Aug 2022 09:46:25 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D6CC41415116;
        Mon,  8 Aug 2022 09:46:24 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id CFDED1C0286; Mon,  8 Aug 2022 11:46:23 +0200 (CEST)
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
Subject: [PATCH bpf-next v3 1/3] bpf: add destructive kfunc flag
Date:   Mon,  8 Aug 2022 11:46:21 +0200
Message-Id: <20220808094623.387348-2-asavkov@redhat.com>
In-Reply-To: <20220808094623.387348-1-asavkov@redhat.com>
References: <20220808094623.387348-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
2.37.1

