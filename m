Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F00D1568D6E
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 17:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbiGFPiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 11:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233634AbiGFPgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 11:36:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986E11CFC8;
        Wed,  6 Jul 2022 08:33:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A867B81D90;
        Wed,  6 Jul 2022 15:33:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96618C341CE;
        Wed,  6 Jul 2022 15:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657121625;
        bh=08xxHGUudMtdS1OarUIzc4kUHpP8gjuUZlzB8ABPe2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pDa1FuaXAGlKqKbX0bLgISs5lriSuLEY2hjvV6yuM14c39B4TtR30eibthTi+HbJf
         aAKpE4YMI8xqY0BGbDhrZVtH3UaYVejGrdMM/Dm2nYUQvUfY2gTcY0q6TNQr08tIFI
         pgN8fXBS00RozduhjOyhpHZuAr/aL37Xij+iH+NJMRWzMQa6366QqVuTxt6lPWlpIf
         PxwFQ5NSGCqgmNBEhhBehIEUtA4R3Ufyg4a1srxFpn2cusXas3KHx+5MYHVaNK6Y9r
         7UO2KmU2mar62VU/HSvV9vEb5Rlw8bQ1lURvr+PILVFzvJ1FLSFb9vFv/hyG6BQ22d
         RBud8Fpctz3og==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangyu Hua <hbh25y@gmail.com>,
        Tung Nguyen <tung.q.nguyen@dektech.com.au>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, jmaloy@redhat.com,
        ying.xue@windriver.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 6/8] net: tipc: fix possible refcount leak in tipc_sk_create()
Date:   Wed,  6 Jul 2022 11:33:33 -0400
Message-Id: <20220706153335.1598699-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220706153335.1598699-1-sashal@kernel.org>
References: <20220706153335.1598699-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit 00aff3590fc0a73bddd3b743863c14e76fd35c0c ]

Free sk in case tipc_sk_insert() fails.

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Reviewed-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/socket.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 6c18b4565ab5..8266452c143b 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -453,6 +453,7 @@ static int tipc_sk_create(struct net *net, struct socket *sock,
 	sock_init_data(sock, sk);
 	tipc_set_sk_state(sk, TIPC_OPEN);
 	if (tipc_sk_insert(tsk)) {
+		sk_free(sk);
 		pr_warn("Socket create failed; port number exhausted\n");
 		return -EINVAL;
 	}
-- 
2.35.1

