Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517C658E77F
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 08:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbiHJG7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 02:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiHJG7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 02:59:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7DD2D72EC2
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 23:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660114751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TuXxip5m/+uaodvEMxILggFHmrvIlLjtGXFaewxf3tM=;
        b=ZDX8PeEKYSeqiuRtPq2TP3C05uLNioY6nwmS1pwQFuTnLPgFPn09w2so18ZHcMMpUb9UnK
        TiWQYUm3EgHh2YIUy+CvpNEjagPee0nDqYlpVH5Vw9K0BLg0k2J/i2RYfziyBGn3PNnwOL
        WJ5TvUqVisg+qdzEOctR2rutxcsp69Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-412-WF0i6ggTMUClpl2sSH7BCg-1; Wed, 10 Aug 2022 02:59:08 -0400
X-MC-Unique: WF0i6ggTMUClpl2sSH7BCg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26C7F299E76B;
        Wed, 10 Aug 2022 06:59:08 +0000 (UTC)
Received: from shodan.usersys.redhat.com (unknown [10.43.17.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D6E9440CF8EB;
        Wed, 10 Aug 2022 06:59:07 +0000 (UTC)
Received: by shodan.usersys.redhat.com (Postfix, from userid 1000)
        id E1CAF1C02AD; Wed, 10 Aug 2022 08:59:06 +0200 (CEST)
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
Subject: [PATCH bpf-next v5 2/3] bpf: export crash_kexec() as destructive kfunc
Date:   Wed, 10 Aug 2022 08:59:04 +0200
Message-Id: <20220810065905.475418-3-asavkov@redhat.com>
In-Reply-To: <20220810065905.475418-1-asavkov@redhat.com>
References: <20220810065905.475418-1-asavkov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
 kernel/bpf/helpers.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index a95eb9fb01ff..3c1b9bbcf971 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -1725,3 +1725,21 @@ bpf_base_func_proto(enum bpf_func_id func_id)
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
+	return register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &tracing_kfunc_set);
+}
+
+late_initcall(kfunc_init);
-- 
2.37.1

