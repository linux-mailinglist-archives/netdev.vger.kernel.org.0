Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA1C39A782
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbhFCRLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:11:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232359AbhFCRLI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:11:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D404F6140B;
        Thu,  3 Jun 2021 17:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740163;
        bh=+BrbsSpcV0YHKhcT8tRvGzL/1htIb260PmyXA1JnjVk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jdu7nEKHMBNkYIc8wMpmE9J/DmcHy8go3jf1ru3QyfSRDPPFGC3ixNgEWc6hS4fMG
         JVfTrHxGkqy5i7LI9iUcA6gfJ85LNdCPtc44/QfUS+whrsioXwoGt72RNtFHv+89Q3
         cwA8J00cdZb2kFBx/w+BwMcJ1LvCBCOxJ0/BIHwvW8bXyzH49wSlLHcO3nSyEByTZC
         Nc5QkBdkTKQdgp5Y6ewc3jDd3BFQF+54S5n2pIP8FAl1fu3Bg9auzbIp0JdfYeIgnv
         y9T9AglUudAboUsiTwhHCPIPjjsBoEbKwN7U/1cpc/foqzJAQ85BxUIPME1NeCrxOk
         MDaGfo/7LnrhA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeimon <jjjinmeng.zhou@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 03/31] net/nfc/rawsock.c: fix a permission check bug
Date:   Thu,  3 Jun 2021 13:08:51 -0400
Message-Id: <20210603170919.3169112-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170919.3169112-1-sashal@kernel.org>
References: <20210603170919.3169112-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeimon <jjjinmeng.zhou@gmail.com>

[ Upstream commit 8ab78863e9eff11910e1ac8bcf478060c29b379e ]

The function rawsock_create() calls a privileged function sk_alloc(), which requires a ns-aware check to check net->user_ns, i.e., ns_capable(). However, the original code checks the init_user_ns using capable(). So we replace the capable() with ns_capable().

Signed-off-by: Jeimon <jjjinmeng.zhou@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/rawsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index 23d5e56306a4..8d649f4aee79 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -333,7 +333,7 @@ static int rawsock_create(struct net *net, struct socket *sock,
 		return -ESOCKTNOSUPPORT;
 
 	if (sock->type == SOCK_RAW) {
-		if (!capable(CAP_NET_RAW))
+		if (!ns_capable(net->user_ns, CAP_NET_RAW))
 			return -EPERM;
 		sock->ops = &rawsock_raw_ops;
 	} else {
-- 
2.30.2

