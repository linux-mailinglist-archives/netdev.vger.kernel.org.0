Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0D7C39A7E1
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbhFCRM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:12:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232251AbhFCRMF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:12:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B42FD6142B;
        Thu,  3 Jun 2021 17:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740202;
        bh=sYYFiaSa6jR7mtASzMjv1fOrQuqDdaSGCKubgqmYfKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DiQxp9wUQbs+GkGCsB/x81qPcJEzg3PP48n0djf77rsFEStQ9enoN238y3Vj7a75M
         2AcLEQMKK1EaPpm7Gidnx7ageqqc3maNQwwkBvrF84MgpJgv94aTOWjSaMOy9jDs2i
         uiyfVhMH0DZ5ANoBSLNa4NPjdH0jx99XBFgaKaJAX8Ko96QBxqVrwUI74QTqR2lHGP
         Q3zmiL0qzoexOWlQDqVEuzQzr8M3lafri0o7dPdE0s1YYp2z16tx2dSLS7qs3A/pPd
         Vkia/1sczKKW8t3hF8aRVQUm1Ie2gmV+nB89W+/pZgNu6en5eDzmQFS2xFdu0szRXa
         d4s3bTWW1tQBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeimon <jjjinmeng.zhou@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/23] net/nfc/rawsock.c: fix a permission check bug
Date:   Thu,  3 Jun 2021 13:09:38 -0400
Message-Id: <20210603170959.3169420-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170959.3169420-1-sashal@kernel.org>
References: <20210603170959.3169420-1-sashal@kernel.org>
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
index 57a07ab80d92..bdc72737fe24 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -345,7 +345,7 @@ static int rawsock_create(struct net *net, struct socket *sock,
 		return -ESOCKTNOSUPPORT;
 
 	if (sock->type == SOCK_RAW) {
-		if (!capable(CAP_NET_RAW))
+		if (!ns_capable(net->user_ns, CAP_NET_RAW))
 			return -EPERM;
 		sock->ops = &rawsock_raw_ops;
 	} else {
-- 
2.30.2

