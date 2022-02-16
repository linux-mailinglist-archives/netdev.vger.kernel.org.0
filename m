Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 613974B9011
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 19:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236854AbiBPSU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 13:20:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235354AbiBPSUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 13:20:55 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36E71C559E
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 10:20:42 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id g1so2826171pfv.1
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 10:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HJPpBWHN9ruCt5P5owCQXX6H2P2rYhAdBKOvFjoOJnA=;
        b=cWTis0IYx+SmEZAh9cnuhIk0AujPthDlWC5z8YsLyj7LIjoxuOmjAr8xNw7lW+kZ7g
         W32iPzmHSVEE9VxXlDgDoOzifMnLOnLhJ/Uha8nsPeLq9PVAOGdRgJ9i3Tzq1VSyDnX9
         g6XW+psZLIchujHo6qS1ujHPD6FHpDiwKMpzBA6Ost6YnzyGxYNtKwHEL+1cS/mp1eCy
         X+jchYqodCA/ujoj1/kmNDuGxdrLVB+z5TatSWlLmkBnf/h/hqdY7fA4rHHswOShGVSk
         Eo19Bjqu0Y6JAK7IqbsdCjkVUTRMDQx4EawnWGusMS8P3sfNfO4Fqo0Go+yywDaKZoKk
         bdFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HJPpBWHN9ruCt5P5owCQXX6H2P2rYhAdBKOvFjoOJnA=;
        b=DswSM9H2WgvPVEncQA1e9LLkeVUF7LG8sJaBW5ETQ1XGD2uSnebch3OMc0yWnqjxsO
         L1ei4qV2vc6A7jHsyCYfTVpeUIc929ux+MifaVo3HqzXi2CDWUm0agSmXTKCJLx9LFy5
         yHGpt2R7CvK8hBakrXN+n9sPOcCHsQUIqnwJTzDq1jMwXtkm5llMORVN2dLyL5IVQvSB
         5SQDroe387pZ40izvTWxzsUbm0I+3oudIAd5RM+2v7ERaVpFXLIFyMHxhhlB3ecFayhs
         RBdc9rG2ZfefcZraIUDfKjJChCSZJYg79SSG2u8m4MZvrkMPsvWT5k/Kqitm9zleA4Mg
         A2vg==
X-Gm-Message-State: AOAM532db5Uim+aBKZjsEMxuuAN2TaAehcYRPUK6vx+ZQVGbeoyH+F1H
        aTt7LiN5jn2YtQTuHt0RWG4=
X-Google-Smtp-Source: ABdhPJydTEvMnNzvL9gJL9+usckfZLE5JFO8ELJelEdY5swXuJw2l6mrWAQemFeKpJVJl20tjRSxpQ==
X-Received: by 2002:a63:2a95:0:b0:372:c588:dbb5 with SMTP id q143-20020a632a95000000b00372c588dbb5mr3298789pgq.605.1645035642266;
        Wed, 16 Feb 2022 10:20:42 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:b2d6:3f21:5f47:8e5a])
        by smtp.gmail.com with ESMTPSA id s9sm8933684pjk.1.2022.02.16.10.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 10:20:41 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net-next] ipv6/addrconf: ensure addrconf_verify_rtnl() has completed
Date:   Wed, 16 Feb 2022 10:20:37 -0800
Message-Id: <20220216182037.3742-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
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

From: Eric Dumazet <edumazet@google.com>

Before freeing the hash table in addrconf_exit_net(),
we need to make sure the work queue has completed,
or risk NULL dereference or UAF.

Thus, use cancel_delayed_work_sync() to enforce this.
We do not hold RTNL in addrconf_exit_net(), making this safe.

Fixes: 8805d13ff1b2 ("ipv6/addrconf: use one delayed work per netns")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/ipv6/addrconf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 57fbd6f03ff8d118e50d8aa6ea0ab938a1bb3cbc..44e164706340959b85f8f2d5d562caf8e37aea67 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7187,7 +7187,7 @@ static void __net_exit addrconf_exit_net(struct net *net)
 	kfree(net->ipv6.devconf_all);
 	net->ipv6.devconf_all = NULL;
 
-	cancel_delayed_work(&net->ipv6.addr_chk_work);
+	cancel_delayed_work_sync(&net->ipv6.addr_chk_work);
 	/*
 	 *	Check hash table, then free it.
 	 */
-- 
2.35.1.265.g69c8d7142f-goog

