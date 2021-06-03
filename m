Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6403639A6CA
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbhFCRJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:09:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230383AbhFCRJ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:09:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F831613F8;
        Thu,  3 Jun 2021 17:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740064;
        bh=GuPFsSuib4mnjhLtL2ddfg1ENJrgqkvaZ4q0gRNk1Tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jC5JCEd3uCZU0c2n+uL7IDqlq9lsnSqZC2rMRniL2uYDNjEfwg2ae0P2U42aC79Ua
         x+gMwq3UaplbCI8LOEYp/fRNAqWfppeBRfRQuTbyD2PsozenzRLE6mWg+wRkv6JFsX
         LuG9VxoxakhmCZGq12Fg1y1vcQZeWScO3VsVOANeyisJMPdzyKN2VmnUFKrj6Us8lQ
         o2BGYWudAj9kJ5VvhzMU0JBVUY4k57Jikihzx1z6RdRO/XC6+R7nRdu1CSDo4z9X2U
         3jB1HSvNYVOpnUP4TT9WcY7q29h12M0wfyMvbwk/aK0yeCdgxcRH0EeqsaGeV0xRp4
         8qqpbwE2HDBSA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeimon <jjjinmeng.zhou@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 08/43] net/nfc/rawsock.c: fix a permission check bug
Date:   Thu,  3 Jun 2021 13:06:58 -0400
Message-Id: <20210603170734.3168284-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170734.3168284-1-sashal@kernel.org>
References: <20210603170734.3168284-1-sashal@kernel.org>
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

