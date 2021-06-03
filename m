Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924EB39A739
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbhFCRKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:10:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231790AbhFCRKW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:10:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43FCC61407;
        Thu,  3 Jun 2021 17:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740118;
        bh=GuPFsSuib4mnjhLtL2ddfg1ENJrgqkvaZ4q0gRNk1Tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZ0fuWW7mh8a8MObZF+57g9XqgNRQq1vcmKTJ9R/7R6hCyC8Fc7su3mAhn7dRvi2Q
         e0c0pmwiY5Xg54COGIhAIUwLMqwOlbBi4m7x3dqtyBg+L9eweQr7uataGMD8AmVYa1
         gnqy53B2/gk91f5AOZLF1uKO7nixuX6QyCrf0a7QGTFBSsrWoVxx8ZaV+VyIYjkKCQ
         rSLLn904SB8kUYfIOqYchaBeZPix3N7vm9HoZPTNwxDbIQRxdR1fkNQJrLUyT/6vhX
         wnWQg+lDux/18qpOjliRWK4Wf5Lr9QYSt9URN1yCP+Bb//1PNS1Q2v+WGm3DcCHf4Q
         pl7XX0eBIsevg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeimon <jjjinmeng.zhou@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/39] net/nfc/rawsock.c: fix a permission check bug
Date:   Thu,  3 Jun 2021 13:07:56 -0400
Message-Id: <20210603170829.3168708-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170829.3168708-1-sashal@kernel.org>
References: <20210603170829.3168708-1-sashal@kernel.org>
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
index 9c7eb8455ba8..5f1d438a0a23 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -329,7 +329,7 @@ static int rawsock_create(struct net *net, struct socket *sock,
 		return -ESOCKTNOSUPPORT;
 
 	if (sock->type == SOCK_RAW) {
-		if (!capable(CAP_NET_RAW))
+		if (!ns_capable(net->user_ns, CAP_NET_RAW))
 			return -EPERM;
 		sock->ops = &rawsock_raw_ops;
 	} else {
-- 
2.30.2

