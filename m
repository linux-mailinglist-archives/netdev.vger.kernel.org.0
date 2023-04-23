Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4666EBCC3
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 05:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjDWD7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 23:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjDWD7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 23:59:10 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630A12700;
        Sat, 22 Apr 2023 20:59:09 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id 98e67ed59e1d1-246f856d751so2414950a91.0;
        Sat, 22 Apr 2023 20:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682222349; x=1684814349;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hPEMTd9WXlysCXZK2t/qqQ1lVH5dDwOeLw64NJO2aIU=;
        b=Em1vcGkTtAnrVPzsbogzuE4k+BNEuncDWYhrIgu7P4UUSSrYCPlsi6IbFIk8LAELA/
         2iv1UElFN/qYYReTYxg21lbv3M+B1micusudFSTRx6Muy8FMzXp5FUZyakb76ac4A8oK
         FEm0dirwFYBKTusLVJP9DheXHwsK2hi2q3PCrELBWo9bDZvJyHHN132JlPU2eSZ8BqVL
         yolpi0uYYaDYoopBUG+xyfPOZ5X6sS0dABJzsJcRQqOiKKiJslFXPZDEjW71YDL7t/+S
         BLqUjRuRkFOs6bvoQ9QCnUqJ4LOl9JsBPzenjU1L526MJyb7fQHwOCLAr4oeCmd7/laQ
         pS0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682222349; x=1684814349;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hPEMTd9WXlysCXZK2t/qqQ1lVH5dDwOeLw64NJO2aIU=;
        b=d0E9yPkZOtXI3hNnqDePob0I3orvcEWXRmEHXhYimYweMtgpfIGMy1O7xKwVhnCSbL
         pjwYKCN6xGjVbTVQpypAkRlOzLbfdxHSHsTyRVVaZc7Pwqey+hUl7N06sEeVkCGe25Wj
         acnTKLyz9naUmbpaNfYcppq2ek2N4JwZRIGTfMaB6UlR/Px22Iv9LsAbfKAm10O5b0Gj
         GdQqJrWzzrdfEYDZVFlLTjbU6Y7kagv6t5zrcVDm9KG5pDqB0vzSZolDmnfzMi+9f92D
         WZ5oayldNU8ygNB9XLtMqfxAnsxk9ekY/dgS0FqcGYX+nWj+jlHN1KObrivMj89nWAzj
         lqFA==
X-Gm-Message-State: AAQBX9c3ZxlBpF1Sqfee+bF2u5CidyM64L1SIlo/zfisogWmbTue5JC/
        eU3uv65VlqM/CgE+IWMWBOk=
X-Google-Smtp-Source: AKy350YUwQlfBZAKod66+dBPkjDquoFgEgWnFAEUPeoaFr+HwMAtrBnzdwO9z9ulTFvwuY/Lb535iw==
X-Received: by 2002:a17:90a:a63:b0:247:1f35:3314 with SMTP id o90-20020a17090a0a6300b002471f353314mr8995127pjo.48.1682222348701;
        Sat, 22 Apr 2023 20:59:08 -0700 (PDT)
Received: from localhost.localdomain ([119.8.118.45])
        by smtp.gmail.com with ESMTPSA id t7-20020a1709028c8700b001a19bde435fsm4596033plo.65.2023.04.22.20.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 20:59:08 -0700 (PDT)
From:   sunichi <sunyiqixm@gmail.com>
To:     jmaloy@redhat.com
Cc:     ying.xue@windriver.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, sunichi <sunyiqixm@gmail.com>
Subject: [PATCH] tipc: fix a log bug
Date:   Sun, 23 Apr 2023 11:55:45 +0800
Message-Id: <20230423035545.3528996-1-sunyiqixm@gmail.com>
X-Mailer: git-send-email 2.25.1
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

When tipc stripe \x00 from string hex, it walks step by step
instead of two step.
It will cause a char which ascii low 4 bit is zero be striped.
So change one step iteration to two step to fix this bug.

Signed-off-by: sunichi <sunyiqixm@gmail.com>
---
 net/tipc/addr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/tipc/addr.c b/net/tipc/addr.c
index fd0796269..83eb91ca3 100644
--- a/net/tipc/addr.c
+++ b/net/tipc/addr.c
@@ -117,8 +117,10 @@ char *tipc_nodeid2string(char *str, u8 *id)
 		sprintf(&str[2 * i], "%02x", id[i]);
 
 	/* Strip off trailing zeroes */
-	for (i = NODE_ID_STR_LEN - 2; str[i] == '0'; i--)
+	for (i = NODE_ID_STR_LEN - 2; str[i] == '0' && str[i - 1] == '0'; i -= 2) {
 		str[i] = 0;
+		str[i - 1] = 0;
+	}
 
 	return str;
 }
-- 
2.25.1

