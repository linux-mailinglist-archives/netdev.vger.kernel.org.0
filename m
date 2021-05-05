Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E7F3745ED
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238130AbhEERJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:09:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:32778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238024AbhEEREi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 13:04:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97F6561C29;
        Wed,  5 May 2021 16:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232926;
        bh=BRdGr/TlbkTLITp74Ajm2rEP1BuzEVJewHTKzHPom0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G93lFy05m2/HQ9/T42qKAnKdLlK5kPdAs9kLQek+zrn9S/xI+VmgzkK2Czj2DH85l
         hnqutjGiXC/tAJtU77lqywu79sbfnVr/JdlBAWRo1YV3ed9xx/bBau0hsrkd7Jl9VS
         sQ+QuiLxkpF5t9P3/zw/sQDZPpdOmb17BpDxo2xJi0F9QdXlAKuH/60ozkthj3mh66
         zd0uwekoAPgcJUOzzPQtdPaeXCIRxtd6BOAKNKtrH8ZKilhmF4EYa0gyYaumyJ46+x
         sm3opVaewAS5DySdopeXvKcecSQwTtj1iOnZ51yw+LGh8GMZG2ZKEJ0DEW5NzS9gY6
         g19b9sXLA5lQA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hoang Le <hoang.h.le@dektech.com.au>,
        Jon Maloy <jmaloy@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.4 02/19] tipc: convert dest node's address to network order
Date:   Wed,  5 May 2021 12:41:45 -0400
Message-Id: <20210505164203.3464510-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505164203.3464510-1-sashal@kernel.org>
References: <20210505164203.3464510-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>

[ Upstream commit 1980d37565061ab44bdc2f9e4da477d3b9752e81 ]

(struct tipc_link_info)->dest is in network order (__be32), so we must
convert the value to network order before assigning. The problem detected
by sparse:

net/tipc/netlink_compat.c:699:24: warning: incorrect type in assignment (different base types)
net/tipc/netlink_compat.c:699:24:    expected restricted __be32 [usertype] dest
net/tipc/netlink_compat.c:699:24:    got int

Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/netlink_compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 0975a28f8686..fb1b5dcf0142 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -632,7 +632,7 @@ static int tipc_nl_compat_link_dump(struct tipc_nl_compat_msg *msg,
 
 	nla_parse_nested(link, TIPC_NLA_LINK_MAX, attrs[TIPC_NLA_LINK], NULL);
 
-	link_info.dest = nla_get_flag(link[TIPC_NLA_LINK_DEST]);
+	link_info.dest = htonl(nla_get_flag(link[TIPC_NLA_LINK_DEST]));
 	link_info.up = htonl(nla_get_flag(link[TIPC_NLA_LINK_UP]));
 	nla_strlcpy(link_info.str, link[TIPC_NLA_LINK_NAME],
 		    TIPC_MAX_LINK_NAME);
-- 
2.30.2

