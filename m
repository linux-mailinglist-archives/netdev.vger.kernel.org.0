Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B343F4ABFF0
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 14:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388027AbiBGNqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 08:46:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449008AbiBGNPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 08:15:05 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023B5C0401C1
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 05:15:05 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id z4so11974098lfg.5
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 05:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GUprroLdbtzVOCQhX6EufnSsfv67k+YQ0AYLj0nUTaU=;
        b=BXsyvCntwia15OtieSs5kCjCAnxe8GnsTppEPvZR5/UhigjPiwqJh4Fy6ZI2XOq6Vg
         +yogT5D6SEupuAq+y6AXQBOaTEN1C/0WfI6bBVTtyo6kDFgjQ3oR9yi4O5aCQXZfOpC5
         PCd376q251xcmcAm3AoUzfuhevfooGBGpkx5A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GUprroLdbtzVOCQhX6EufnSsfv67k+YQ0AYLj0nUTaU=;
        b=ehf+p7K9uBBM4IM2fWpTmnnuwsSWfLXQ1OkK7tMpN2eYTxyrmW30pz7wf+W61I02QC
         VWdXU3/yMLpJYVtzCTqZ3Z36H10wiyYZC+3EqTNOtZIYlc7XlhusLEsz3MZ7wgB4/ZMe
         kzCG219uWU+dlYOBQL30gamK4wX0BoEXDi+gUq8u/YcgrVt+QqyoAzHS0Ka8JJHIdKOz
         3mk+7W59LcKoASrLTNkjhdEAmDyetIZJyi6lL8ZxNPWwXmxy9cIzlogvug4nPkFHpskb
         bobmlMVJuY8OlfokK2uCBJ0sjEXXW/FfktGZgtO/cUAP6tlBS1BFHG8b0v8Xt957yRh/
         IZBw==
X-Gm-Message-State: AOAM533cpgHmAmjEOEwQtmjm4Y48BXWtFWmXMIQ0Xvg9txhN5jeTm/yi
        HoFfgR7tn6DCW7vO5VuW6fIA6w==
X-Google-Smtp-Source: ABdhPJzPHrRpl4oFrtus3QjBVVhCwoMfUqDR7tcEjdh7+nWrFXzFqQJl4puEwen0NEL0WHBwqW7GSA==
X-Received: by 2002:a05:6512:c04:: with SMTP id z4mr8545235lfu.229.1644239703353;
        Mon, 07 Feb 2022 05:15:03 -0800 (PST)
Received: from cloudflare.com (user-5-173-137-68.play-internet.pl. [5.173.137.68])
        by smtp.gmail.com with ESMTPSA id k16sm1607355ljg.111.2022.02.07.05.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 05:15:03 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, kernel-team@cloudflare.com
Subject: [PATCH bpf-next 2/2] selftests/bpf: Cover 4-byte load from remote_port in bpf_sk_lookup
Date:   Mon,  7 Feb 2022 14:14:59 +0100
Message-Id: <20220207131459.504292-3-jakub@cloudflare.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220207131459.504292-1-jakub@cloudflare.com>
References: <20220207131459.504292-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the context access tests for sk_lookup prog to cover the surprising
case of a 4-byte load from the remote_port field, where the expected value
is actually shifted by 16 bits.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 tools/include/uapi/linux/bpf.h                     | 3 ++-
 tools/testing/selftests/bpf/progs/test_sk_lookup.c | 6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index a7f0ddedac1f..afe3d0d7f5f2 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -6453,7 +6453,8 @@ struct bpf_sk_lookup {
 	__u32 protocol;		/* IP protocol (IPPROTO_TCP, IPPROTO_UDP) */
 	__u32 remote_ip4;	/* Network byte order */
 	__u32 remote_ip6[4];	/* Network byte order */
-	__u32 remote_port;	/* Network byte order */
+	__be16 remote_port;	/* Network byte order */
+	__u16 :16;		/* Zero padding */
 	__u32 local_ip4;	/* Network byte order */
 	__u32 local_ip6[4];	/* Network byte order */
 	__u32 local_port;	/* Host byte order */
diff --git a/tools/testing/selftests/bpf/progs/test_sk_lookup.c b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
index 83b0aaa52ef7..bf5b7caefdd0 100644
--- a/tools/testing/selftests/bpf/progs/test_sk_lookup.c
+++ b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
@@ -392,6 +392,7 @@ int ctx_narrow_access(struct bpf_sk_lookup *ctx)
 {
 	struct bpf_sock *sk;
 	int err, family;
+	__u32 val_u32;
 	bool v4;
 
 	v4 = (ctx->family == AF_INET);
@@ -418,6 +419,11 @@ int ctx_narrow_access(struct bpf_sk_lookup *ctx)
 	if (LSW(ctx->remote_port, 0) != SRC_PORT)
 		return SK_DROP;
 
+	/* Load from remote_port field with zero padding (backward compatibility) */
+	val_u32 = *(__u32 *)&ctx->remote_port;
+	if (val_u32 != bpf_htonl(bpf_ntohs(SRC_PORT) << 16))
+		return SK_DROP;
+
 	/* Narrow loads from local_port field. Expect DST_PORT. */
 	if (LSB(ctx->local_port, 0) != ((DST_PORT >> 0) & 0xff) ||
 	    LSB(ctx->local_port, 1) != ((DST_PORT >> 8) & 0xff) ||
-- 
2.31.1

