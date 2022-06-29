Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD12755F692
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 08:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbiF2G3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 02:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbiF2G3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 02:29:37 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 883DEA464;
        Tue, 28 Jun 2022 23:29:36 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id d129so14369732pgc.9;
        Tue, 28 Jun 2022 23:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hCkVZrfBdJMxphgyydQPbFuiNpNH3pg2QzvaiMz3gyo=;
        b=qbMcg9AqBhhvRlVfbwWu9N+EwuB45P7ZjGthagm+n3mS4FdntuyRGM+NygLfaYxjQN
         HeO5t6BP9QLjIHb3C185MiaWf2nNOsVaoyLTbjIBcHagX09539/jobsvpqT4u6sadBVX
         lw+X4/dw8iuoVwwStvJkHG5nUVzn5lxE4El1w0ew89uHwI95imilWdL20t6jacubLZzI
         DgG8+U3pdQlsbAOGlfnUbYrvKqSBKFAGlESCqUoFoEb3x740JsIjWNVpiAGmYArEtBTE
         4mQ11oLf5ljrSeY1cfvtbge6MVF1tMId4b5qzH8hfi2XcmfWg7RP/KmxQ/ntoJ3kt0Vq
         mVKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hCkVZrfBdJMxphgyydQPbFuiNpNH3pg2QzvaiMz3gyo=;
        b=GU96sTgKycRIDcXgjRH+t/msS/w0ugytgsUe4kSa9xVLUy+C+X83EnHppJOoYIbW5I
         EE6Dsrc+ObZf+CnKsOVAAO5akMJhx91ls/eIRC0mUYegEzOgHNxTcz0PcNDf/A4KtuCe
         JrAoK3zNfJdHfwH9ob5jBq6lIPtoSjHKSWfDG2CnBgyQQuFshVjF99nzJdM7wXZOXhCi
         mMLbcmGe99l3CSLW6lRya8mJoPYs3etazDernBcLkOL2HMrZ5KfKZdAHbUspSrvXcuIl
         kmajYLRlITgp1oc8JDdQCRRR2e2t6yExXXB15bjrkiKTOwpZjGyZPwcZz4exdtMuSevg
         71lA==
X-Gm-Message-State: AJIora8CB1qrbiY4a0/IiHP8Bct22jG3HiuI00m8t3eOTEu5L8wLdWmB
        ahXYmaV6gmhiEvTLmNAJWvo=
X-Google-Smtp-Source: AGRyM1uV4mkAYYvLkmdQaOLIBYRWNg4dT3SKlPU2Lo0yXuJ95NxGyrC1vKI91clx/JHTnqgts0sAfg==
X-Received: by 2002:aa7:8426:0:b0:525:23bf:1b78 with SMTP id q6-20020aa78426000000b0052523bf1b78mr7538211pfn.26.1656484176123;
        Tue, 28 Jun 2022 23:29:36 -0700 (PDT)
Received: from localhost.localdomain ([103.84.139.165])
        by smtp.gmail.com with ESMTPSA id q6-20020a170902a3c600b0016196bcf743sm10391558plb.275.2022.06.28.23.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 23:29:35 -0700 (PDT)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        tung.q.nguyen@dektech.com.au
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] net: tipc: fix possible refcount leak in tipc_sk_create()
Date:   Wed, 29 Jun 2022 14:29:23 +0800
Message-Id: <20220629062923.21126-1-hbh25y@gmail.com>
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

Free sk in case tipc_sk_insert() fails.

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---

v2: use a succinct commit log.

 net/tipc/socket.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 17f8c523e33b..43509c7e90fc 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -502,6 +502,7 @@ static int tipc_sk_create(struct net *net, struct socket *sock,
 	sock_init_data(sock, sk);
 	tipc_set_sk_state(sk, TIPC_OPEN);
 	if (tipc_sk_insert(tsk)) {
+		sk_free(sk);
 		pr_warn("Socket create failed; port number exhausted\n");
 		return -EINVAL;
 	}
-- 
2.25.1

