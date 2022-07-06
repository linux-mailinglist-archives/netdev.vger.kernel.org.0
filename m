Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C44FB568DAC
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 17:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234583AbiGFPid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 11:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234700AbiGFPhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 11:37:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42B329823;
        Wed,  6 Jul 2022 08:34:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 585ADB81D8E;
        Wed,  6 Jul 2022 15:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B870C385A9;
        Wed,  6 Jul 2022 15:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657121655;
        bh=X1HuKRt0LWoedxoY1R+Lv8GBU7vpc+yZbocg1ZBZ8JI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cIeIl08BAFjJxRP13qActLCmwqt5Uvis3WJQXK8uUYrqlsh1joFgg3ClyeDWJYwy/
         0Fl8ENgLbV40wxw7GjU4SlJe4Hogi+BmoFURvNrvp4awfmifTuwqu2PNOurSqXOZif
         hlO01HBJPqm+QaJ4OVp/1v0Nkownju1hxQg+S4/pC7+5BahEbrrfyGBVlQpTlTXbFI
         nx6S+LacSSaQSUkPwholvkrGY6RCn53tOUdPquQ/nWVKIVP+RW0/tvN1Wl5c/oTEyj
         BLsopF3FULnE9d8d9WUjYMEuslHk9CHSH19pcnDkAUMp0EQfihZwxutgLuN6pvmno3
         cLItvpdDhOoDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangyu Hua <hbh25y@gmail.com>,
        Tung Nguyen <tung.q.nguyen@dektech.com.au>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, jmaloy@redhat.com,
        ying.xue@windriver.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.9 4/5] net: tipc: fix possible refcount leak in tipc_sk_create()
Date:   Wed,  6 Jul 2022 11:34:06 -0400
Message-Id: <20220706153407.1598915-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220706153407.1598915-1-sashal@kernel.org>
References: <20220706153407.1598915-1-sashal@kernel.org>
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
index 9f39276e5d4e..1b3516368057 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -341,6 +341,7 @@ static int tipc_sk_create(struct net *net, struct socket *sock,
 	sock->state = state;
 	sock_init_data(sock, sk);
 	if (tipc_sk_insert(tsk)) {
+		sk_free(sk);
 		pr_warn("Socket create failed; port number exhausted\n");
 		return -EINVAL;
 	}
-- 
2.35.1

