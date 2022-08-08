Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E024558C5D4
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 11:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235484AbiHHJqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 05:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiHHJq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 05:46:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8EC501146F
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 02:46:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659951986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4t5AWs+u5EvUjx0b8iyElLx44EEba3jEMvid4zYihvo=;
        b=CgXB8xgIrnx8XrQGrhUmss7w3RGZKPzgcFbixdQYQztNjUwwhFRcAash4Vcs/ZM/QUgXFX
        SZU2Dgkev3rNNFyouPURb2SKz1Tf1wnYWKLn9QJN8eqHssFc/ptIREQ7wXXylltWKxPVLD
        yECgNS6tzI96Ly/YsnXEq97S+t8MgfM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-ZmMVrkOLOHu9aM0VHbZAKw-1; Mon, 08 Aug 2022 05:46:25 -0400
X-MC-Unique: ZmMVrkOLOHu9aM0VHbZAKw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2375738107F1;
        Mon,  8 Aug 2022 09:46:25 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D6D781121314;
        Mon,  8 Aug 2022 09:46:24 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id DDF261C0311; Mon,  8 Aug 2022 11:46:23 +0200 (CEST)
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
Subject: [PATCH bpf-next v3 2/3] bpf: export crash_kexec() as destructive kfunc
Date:   Mon,  8 Aug 2022 11:46:22 +0200
Message-Id: <20220808094623.387348-3-asavkov@redhat.com>
In-Reply-To: <20220808094623.387348-1-asavkov@redhat.com>
References: <20220808094623.387348-1-asavkov@redhat.com>
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

Allow properly marked bpf programs to call crash_kexec().

Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 kernel/bpf/helpers.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 1f961f9982d2..103dbddff41f 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1711,3 +1711,24 @@ bpf_base_func_proto(enum bpf_func_id func_id)
 		return NULL;
 	}
 }
+
+BTF_SET8_START(tracing_btf_ids)
+#ifdef CONFIG_KEXEC_CORE
+BTF_ID_FLAGS(func, crash_kexec, KF_DESTRUCTIVE)
+#endif
+BTF_SET8_END(tracing_btf_ids)
+
+static const struct btf_kfunc_id_set tracing_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set   = &tracing_btf_ids,
+};
+
+static int __init kfunc_init(void)
+{
+	if (register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &tracing_kfunc_set))
+		pr_warn("failed to register kfunc id set for BPF_PROG_TYPE_TRACING\n");
+
+	return 0;
+}
+
+late_initcall(kfunc_init);
-- 
2.37.1

