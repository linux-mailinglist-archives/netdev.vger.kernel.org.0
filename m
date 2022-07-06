Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A49A568D71
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 17:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234439AbiGFPgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 11:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234037AbiGFPfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 11:35:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8881C18398;
        Wed,  6 Jul 2022 08:33:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EC6BB81D97;
        Wed,  6 Jul 2022 15:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0CEC341CE;
        Wed,  6 Jul 2022 15:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657121607;
        bh=+Tc7B7eHJsJlCG5mleBaegds+TrWSgEsBX0tpPnlfSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ITVEQKuODceghsLOC997As1VWj+LEfPIhh8gajBOwK1mkv9+qzALO2QQtZf/RMop/
         43I8TcFc/n2fBf3x177WkUc6lHC+85QlWRYlHC2g+p2jvD7BytQs+LlfG0Ai+kkHEb
         iI2vf/pt59zFBs8I+JgOz+ZJT7mWvhr2zC98e3hWt8wNQh3VMMa+ItcGBEF3mPDhCQ
         qLDuRxvbm8QAISd8LaKc+/dIwpnPXwMD4SuRJ1vSKdVikSkNW2/CvEYuJiePihg+1A
         NQaVU8f++K1/PDC5dx8M6XnMR3y5zFryl7NxkJRJ9fMCmG8EB5g+4JXrHjOUzSlfKe
         qsICR9UFrfrLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangyu Hua <hbh25y@gmail.com>,
        Tung Nguyen <tung.q.nguyen@dektech.com.au>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, jmaloy@redhat.com,
        ying.xue@windriver.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 6/9] net: tipc: fix possible refcount leak in tipc_sk_create()
Date:   Wed,  6 Jul 2022 11:33:12 -0400
Message-Id: <20220706153316.1598554-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220706153316.1598554-1-sashal@kernel.org>
References: <20220706153316.1598554-1-sashal@kernel.org>
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
index d543c4556df2..58c4d61d603f 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -455,6 +455,7 @@ static int tipc_sk_create(struct net *net, struct socket *sock,
 	sock_init_data(sock, sk);
 	tipc_set_sk_state(sk, TIPC_OPEN);
 	if (tipc_sk_insert(tsk)) {
+		sk_free(sk);
 		pr_warn("Socket create failed; port number exhausted\n");
 		return -EINVAL;
 	}
-- 
2.35.1

