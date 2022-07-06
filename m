Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6789D568D32
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 17:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbiGFPcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 11:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233986AbiGFPcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 11:32:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D8527CE5;
        Wed,  6 Jul 2022 08:31:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34C64B81D98;
        Wed,  6 Jul 2022 15:31:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7313C385A2;
        Wed,  6 Jul 2022 15:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657121503;
        bh=tHbmYTk29C+tyConO9otde+kD25xesrNCWFelZW3mIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UaGd+zWZNfFqB6GUHXMeFdyHBwPgNAIs9jcrLWe+z/Bxa2gN3K0sJ8SQUaob5uReh
         2dFDSqVH2Is2m7vtzkm8mS/OVaU8laKXz6VVsTQp5ZTxQOgL1crdbD2BmyjrPx6Gv+
         8r66ICFiWnT2pB9F1JZijRsDtYI7ksS/jy87xnCeV8z9doFphVB3KgBN8nzI+dFLDh
         m0D8U4gigr4Bx13+RDzy0E2Xec1BoRir4oXrZgnoKGijFsMMrI1hdcbmkKJA/y43dz
         UwfrTvQ/93p2GDeJNEafGC9I/7wK8QXoH7NVzug6NA4z+U8HWRaOdUcQ4uy2Sfk4En
         SQBuHgiyWUgJg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangyu Hua <hbh25y@gmail.com>,
        Tung Nguyen <tung.q.nguyen@dektech.com.au>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, jmaloy@redhat.com,
        ying.xue@windriver.com, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.18 18/22] net: tipc: fix possible refcount leak in tipc_sk_create()
Date:   Wed,  6 Jul 2022 11:30:36 -0400
Message-Id: <20220706153041.1597639-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220706153041.1597639-1-sashal@kernel.org>
References: <20220706153041.1597639-1-sashal@kernel.org>
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
2.35.1

