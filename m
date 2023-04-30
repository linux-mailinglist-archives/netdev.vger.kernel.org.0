Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A08996F2B75
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 00:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbjD3Wvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 18:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbjD3Wvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 18:51:45 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A0E1BF
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 15:51:44 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id 6a1803df08f44-61a35fdf61dso3775796d6.2
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 15:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682895103; x=1685487103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CsTYM8noGKYfSDpU+r1jNaut7LFpqio43/mQlqqfaGU=;
        b=P1KQ65lqb0MX+hIg4LD4BbWvUB0NT5ap6x2AE2ZpjJ0OzgRgVn0Ahula3PEUU0/ljS
         3b4oocZZeqW0K1HKhyzRi+c8befj6BLobrrqdv5IbBcchFs6Cy7Se95wYnk3Q7kWejen
         cQUKgkIpoFgNJC7lLkKSXfEv+a6kTy6SXFmRYE7v8EmKY93ZlSf7o1DAIua4STNwR3be
         sSVtVSTZlZJR+xVA1xeneEWTFj3v0T+8S84MrY/PgQC4vH3hcbn/TjQ2XTqqEzglYvkB
         A3mlNHWx+Hs7MEpC/xeqUvvyK0UGkAECTTKBI6TyYrXfgvY6JcCC7dDh9qzkcbNoRRbQ
         P1hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682895103; x=1685487103;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CsTYM8noGKYfSDpU+r1jNaut7LFpqio43/mQlqqfaGU=;
        b=D5eUG4paRFMD7+XpuRP9b4tMPk+FOMRRcNBXF/9ouXqvFo8rjl8R8wUrkRhsQCLYIw
         0A/0HJIxn80ZytsJi0UfQbkL/Tc2CNZFDc2nMXdsUwyT0oP/aUaMhfomnA7pc9+OaHRQ
         i6MU6ui8JSC9UdsHLUZJgJ5YHz6D6CylelXtURrRVnQTK5MfmQKJj/4AL1sVLSpVPaIj
         jIArHGzCVq9NciA/tlV8CMgVqQiEI69g8dnQPaQVj0r6krEjIxofzXMzqY8bQADg6hW4
         Vd/n6DQrOpXEPUXAlR/JmyyUnPrdyGLhNUDrxgTMQgpbv1nXnrQh0t9HpOFlWMESo6Fe
         Exhg==
X-Gm-Message-State: AC+VfDyFQopkdebiJOxqokPFmH7iIEVTFoeNvLxkiFk119SPdMtTQ7+5
        3tq8hR63zhV0dszJrytw6MKq8mcQ8TE=
X-Google-Smtp-Source: ACHHUZ5CtitsQBSghCIhTc6oztv69nh0hpQy6AlphT81EOimh+8FpZkNImqwiaTmBsfx0jSBEdtgMw==
X-Received: by 2002:a05:6214:1c48:b0:5a3:79cd:8ef7 with SMTP id if8-20020a0562141c4800b005a379cd8ef7mr20671336qvb.23.1682895103435;
        Sun, 30 Apr 2023 15:51:43 -0700 (PDT)
Received: from localhost.localdomain ([2602:47:d92c:4400:e747:e271:3de5:4c78])
        by smtp.googlemail.com with ESMTPSA id i5-20020a0cf105000000b0061b5a3d1d54sm189310qvl.87.2023.04.30.15.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 15:51:42 -0700 (PDT)
From:   Nicholas Vinson <nvinson234@gmail.com>
To:     mkubecek@suse.cz
Cc:     Nicholas Vinson <nvinson234@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH ethtool 3/3] Fix potentinal null-pointer derference issues.
Date:   Sun, 30 Apr 2023 18:50:52 -0400
Message-Id: <105e614b4c8ab46aa6b70c75111848d8e57aff0c.1682894692.git.nvinson234@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1682894692.git.nvinson234@gmail.com>
References: <cover.1682894692.git.nvinson234@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Found via gcc -fanalyzer. Analyzer claims that it's possible certain
functions may receive a NULL pointer when handling CLI arguments. Adding
NULL pointer checks to correct the issues.

Signed-off-by: Nicholas Vinson <nvinson234@gmail.com>
---
 ethtool.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 98690df..4ec1e23 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -6182,16 +6182,18 @@ static int find_option(char *arg)
 	size_t len;
 	int k;
 
-	for (k = 1; args[k].opts; k++) {
-		opt = args[k].opts;
-		for (;;) {
-			len = strcspn(opt, "|");
-			if (strncmp(arg, opt, len) == 0 && arg[len] == 0)
-				return k;
-
-			if (opt[len] == 0)
-				break;
-			opt += len + 1;
+	if (arg) {
+		for (k = 1; args[k].opts; k++) {
+			opt = args[k].opts;
+			for (;;) {
+				len = strcspn(opt, "|");
+				if (strncmp(arg, opt, len) == 0 && arg[len] == 0)
+					return k;
+
+				if (opt[len] == 0)
+					break;
+				opt += len + 1;
+			}
 		}
 	}
 
@@ -6457,7 +6459,7 @@ int main(int argc, char **argp)
 		argp++;
 		argc--;
 	} else {
-		if ((*argp)[0] == '-')
+		if (!*argp || (*argp)[0] == '-')
 			exit_bad_args();
 		k = 0;
 	}
-- 
2.40.1

