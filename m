Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C355E53357C
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 04:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243705AbiEYCwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 22:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243699AbiEYCwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 22:52:18 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940D334B9F
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 19:52:17 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id 14so10320140qkl.6
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 19:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UP/VYgEFC7/NG5lOowYSDeCzE3G0VZTx41Klfsp8O4o=;
        b=gdB6Dai3QurMDAdCN1N3fj1hUMOG5d/Ssxa7S4ZA7PNaS7mDY92BvC1L6M2c1Fdjaa
         MKOtM7c8tvemJG+PFA5bQ2CtI7FDkCGp8VzG74YBalyKJbVKxLLyJUSMMtjkKI4GtAMG
         gZ5TOHlH3ZlQmBhqdtwwcDIS6CyJnG3IQC4petVgc0QFt+TWUNAJ/7jqEFxSzpCK0H8j
         +16HqG7Jaa3DwfKBRA6gayofhIwtOBGYuqWgxFmNw5no2CXPRBvasRvEaPRAAkbx8bBi
         MCGtjzjmWGug7h5/Ou8v2JzcsrgVPiSfWnTF4SO8OSe2eQXsJJP17MiPTzcASQP4ux82
         HEDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UP/VYgEFC7/NG5lOowYSDeCzE3G0VZTx41Klfsp8O4o=;
        b=78Tt05g+tP9SR/zxKnHm9tiBlwb7GIwkWviCuIib54XixG/KLnVRXXlN/9W0SiRSII
         8tqoMunXQmN9H6cctp4RteWQSi7Wwhj2VBtIVClHC3jfTvNXVpCqUTyR+EcfOPABvKZP
         kx3/zoBmlRhbDBbXZA1F3YnncT2LErx8V9a+TA8Jf049TdI+adS/bMZELB7VYHcBelTV
         H1/iLrM25je57MLAtXL2Xp547UaKoHo1p7m4kh6s7Ie43Y6L4K8ZfQdfhV+NWTEoCsuk
         gV40UeD7CpJ9c5+ZhCr3vveCB7weDqvgwAc7Sc9+GnTh84ec1VX9JecuE1nptI8HoF0Z
         wWKA==
X-Gm-Message-State: AOAM533dGFsavXKm1TbpG3JcTBPYUSEABK2sguMc4+2nbuOw5FHQJt8P
        Silv7pmTJ5IGIqD/hU9iG3BBKQfG1w==
X-Google-Smtp-Source: ABdhPJwo6icl+YL6EvmO9ra8Y2bqJrqvXykooEeh6Si+ke4zal+73I5YSwW5p1IiUy02jmurFi6vZw==
X-Received: by 2002:a05:620a:2807:b0:67d:6349:2577 with SMTP id f7-20020a05620a280700b0067d63492577mr18996186qkp.785.1653447136760;
        Tue, 24 May 2022 19:52:16 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-3-231-65-244.compute-1.amazonaws.com. [3.231.65.244])
        by smtp.gmail.com with ESMTPSA id v1-20020ac85781000000b002f3d23cf87esm758835qta.27.2022.05.24.19.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 19:52:16 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH iproute2-next 2/7] ss: Remove unnecessary stack variable 'p' in user_ent_hash_build()
Date:   Tue, 24 May 2022 19:52:09 -0700
Message-Id: <b5cb2ea504c1c4d24743448f71fb4897ea0122d2.1653446538.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1653446538.git.peilin.ye@bytedance.com>
References: <cover.1653446538.git.peilin.ye@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Commit 116ac9270b6d ("ss: Add support for retrieving SELinux contexts")
added an unnecessary stack variable, 'char *p', in
user_ent_hash_build().  Delete it for readability.

Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 misc/ss.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/misc/ss.c b/misc/ss.c
index aa9da7e45e53..bccf01bb5efa 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -618,7 +618,6 @@ static void user_ent_hash_build(void)
 	while ((d = readdir(dir)) != NULL) {
 		struct dirent *d1;
 		char process[16];
-		char *p;
 		int pid, pos;
 		DIR *dir1;
 
@@ -636,7 +635,6 @@ static void user_ent_hash_build(void)
 		}
 
 		process[0] = '\0';
-		p = process;
 
 		while ((d1 = readdir(dir1)) != NULL) {
 			const char *pattern = "socket:[";
@@ -667,18 +665,18 @@ static void user_ent_hash_build(void)
 			if (getfilecon(tmp, &sock_context) <= 0)
 				sock_context = strdup(no_ctx);
 
-			if (*p == '\0') {
+			if (process[0] == '\0') {
 				FILE *fp;
 
 				snprintf(tmp, sizeof(tmp), "%s/%d/stat",
 					root, pid);
 				if ((fp = fopen(tmp, "r")) != NULL) {
-					if (fscanf(fp, "%*d (%[^)])", p) < 1)
+					if (fscanf(fp, "%*d (%[^)])", process) < 1)
 						; /* ignore */
 					fclose(fp);
 				}
 			}
-			user_ent_add(ino, p, pid, fd,
+			user_ent_add(ino, process, pid, fd,
 					pid_context, sock_context);
 			freecon(sock_context);
 		}
-- 
2.20.1

