Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE8755F35B
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 04:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiF2CY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 22:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiF2CY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 22:24:28 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7141B19032;
        Tue, 28 Jun 2022 19:24:27 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d5so12710445plo.12;
        Tue, 28 Jun 2022 19:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XronN2ttC9hE2J8XSodjjpTCowak0GAjvewu6UouE5Q=;
        b=opww4e0yGVRW3kT67WPEhJPT+egMpmLsqVmdKkNPaGKNVMFMyZeFNfv71MTzRIMtmG
         lEMikol2A1f46bm5tKHzKHZuEKUa/5TxheOX4V0g+MUJB838hqS+Q5CeQE2qoFBRkIs/
         MR0OTsbLArBg5T93sjP82iUrjdusbF+lcfw4En7Of/248Eq6vlDA7Fn0aTVbLQ+HWIEt
         q9gTMm7hY1/lc6aHiOLzVGSTQp1JbRURHUwENu6HPvVNJg1FskmAVNYkX8r8oRkKHeff
         rr/4JdRa7AV4iXt0EWlB2wcKejGjNAEKbYFC9DXSF8AASAdwbV/cVX21bPb7QjRLC+24
         r6WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XronN2ttC9hE2J8XSodjjpTCowak0GAjvewu6UouE5Q=;
        b=q30vC2IqXy3K3OFenf6LhDmxoWi5A2t061BCXh3m6NBCRYV8sXDhxyPNzxZNb04fNO
         Q/QoYEd9lOjzvVKUCo6AbRSrg6QxC/5G1KvE5Vq3gbfMeFCMewXER0E1nftla8ryGJkw
         xN/Y6GZO0JsziY3eQYEXKSDdm2uD2f3t+uV1l61OcwkmIZOPzWkz5U3mv72WZnBkFKnC
         bS3aMf3aZi1w5VhdxhuF5X4MDn2JBLhOFxry5hzuCCuEKTkDsXTuUNxvkoslcC/ZuQjh
         4pfHBZdsaZLwdVn8n4cCnYyFBf1Purmy6rhNlYOVNxXcmyURxl6Utffu5pUvwqSRoAk+
         VsCA==
X-Gm-Message-State: AJIora8cOGhMpIg9hoA7lxFUJcXmjekE4Tr3i46smVpOQpe/XwsqVXPS
        hk+EePhLwxKYxXfl/RQwJOE=
X-Google-Smtp-Source: AGRyM1ubzs/qg25uzX1LqVU4AnLG8ovqES0gsw7/dOT1GKpiQ6VvrupmLv75XqHK8Ox5Uyo01QLDiw==
X-Received: by 2002:a17:902:9f97:b0:16a:9b9:fb63 with SMTP id g23-20020a1709029f9700b0016a09b9fb63mr6923905plq.7.1656469467027;
        Tue, 28 Jun 2022 19:24:27 -0700 (PDT)
Received: from localhost.localdomain ([103.84.139.165])
        by smtp.gmail.com with ESMTPSA id l189-20020a6225c6000000b005255263a864sm10180598pfl.169.2022.06.28.19.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 19:24:26 -0700 (PDT)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        erik.hugne@ericsson.com, tgraf@suug.ch
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] net: tipc: fix possible refcount leak in tipc_sk_create()
Date:   Wed, 29 Jun 2022 10:24:02 +0800
Message-Id: <20220629022402.10841-1-hbh25y@gmail.com>
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

sk need to be free when tipc_sk_insert fails. While tipc_sk_insert is hard
to fail, it's better to fix this.

Fixes: 07f6c4bc048a ("tipc: convert tipc reference table to use generic rhashtable")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
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

