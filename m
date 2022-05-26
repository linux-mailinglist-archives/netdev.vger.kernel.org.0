Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 003F153558C
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 23:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349066AbiEZVfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 17:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348633AbiEZVfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 17:35:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FB1E2753;
        Thu, 26 May 2022 14:35:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8645D61BA6;
        Thu, 26 May 2022 21:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63927C34116;
        Thu, 26 May 2022 21:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653600934;
        bh=yFqC5FNkkoan3+RlpbjwRfZ5LsZZrBPUFxsJj6gGJFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZgzzLtEtaeApWDZuRnudTEdYA+EOElnvyV3HXqCxbmQCeRb1Qyp5nP5TKgaBs1bH8
         q6AVPfn2/YvIkjN5pGpTTT+tJfoy5BTm9TmYZyN9RfMcaT/OGBVWZzqbZN32qjZcHe
         SrxRKvKw14VrGGG3MeXazMAveSFs4XqFKai3gQ74nZ5cxZFOYmJ8PX7p3VB7XjQ1yS
         7itxqcGVkr79Ndnwlw+NtTFzTQ9jhBL31ql/VJDGNztBiEKnLbsQJ6QJeeqOIDI54c
         0pYOq2//OG8YI3Fcyu7anzUQHUnDzIyJ/YkURsMD0pX9h72vo45FTzYmxbqm9JKdon
         ugsXLyQRgjVGg==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, yhs@fb.com
Subject: [PATCH v4 bpf-next 02/14] bpf: Print multiple type flags in verifier log
Date:   Thu, 26 May 2022 23:34:50 +0200
Message-Id: <1dbc2df5bbfe0395ca9423cdce3fd8fc79f8e0ab.1653600578.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <cover.1653600577.git.lorenzo@kernel.org>
References: <cover.1653600577.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Since MEM_RDONLY and PTR_UNTRUSTED can be present together in register
type now, try to print multiple tags using the prefix buffer. Since
all 5 cannot be present together, 32 bytes is still enough room for
any possible combination. Instead of tracking the current position
into the buffer, simply rely on snprintf, which also ensures nul
termination.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 kernel/bpf/verifier.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index aedac2ac02b9..e0be76861736 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -564,16 +564,12 @@ static const char *reg_type_str(struct bpf_verifier_env *env,
 			strncpy(postfix, "_or_null", 16);
 	}
 
-	if (type & MEM_RDONLY)
-		strncpy(prefix, "rdonly_", 32);
-	if (type & MEM_ALLOC)
-		strncpy(prefix, "alloc_", 32);
-	if (type & MEM_USER)
-		strncpy(prefix, "user_", 32);
-	if (type & MEM_PERCPU)
-		strncpy(prefix, "percpu_", 32);
-	if (type & PTR_UNTRUSTED)
-		strncpy(prefix, "untrusted_", 32);
+	snprintf(prefix, sizeof(prefix), "%s%s%s%s%s",
+		 (type & MEM_RDONLY ? "rdonly_" : ""),
+		 (type & MEM_ALLOC ? "alloc_" : ""),
+		 (type & MEM_USER ? "user_" : ""),
+		 (type & MEM_PERCPU ? "percpu_" : ""),
+		 (type & PTR_UNTRUSTED ? "untrusted_" : ""));
 
 	snprintf(env->type_str_buf, TYPE_STR_BUF_LEN, "%s%s%s",
 		 prefix, str[base_type(type)], postfix);
-- 
2.35.3

