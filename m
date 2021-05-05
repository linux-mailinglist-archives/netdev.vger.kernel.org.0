Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9966237457B
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238498AbhEERGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:06:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237912AbhEERBk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 13:01:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8F2461A46;
        Wed,  5 May 2021 16:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232855;
        bh=3Ec7oHhQ5JY1adY4PY5OOnAqLf6BRopmE2HlCmNmsGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pvBxbmqwcokcRpPslK4H5e6DxHxpjodLwuDgmtdJ0heJLwsP7rYHhFkwubbAMO/oi
         g0siZxdJcsPCNfIM6DRoAz02eKjXu3D90SpfDaXSNqgFpWp/H10eD/R49trAd6g68e
         VZzldqvET17+qldK5UdHW0T6MRoemcUlsVJg6kgKDfe+0V3lOyOAdpNqheHY2PhaCD
         sCnmYGv7VGAfSNqGlwVml3ywGRuXWY3AMqWtXoy6J5t7v2HIro26Z4tYUnzIBF71+o
         zs32f76eYZL28Fjeg57lkRI/SUIOuGy+kUexv56fL6u2123jIMkeuJo7PcG5coQUae
         hjrybPyGuHHnw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hoang Le <hoang.h.le@dektech.com.au>,
        Jon Maloy <jmaloy@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.14 02/25] tipc: convert dest node's address to network order
Date:   Wed,  5 May 2021 12:40:28 -0400
Message-Id: <20210505164051.3464020-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505164051.3464020-1-sashal@kernel.org>
References: <20210505164051.3464020-1-sashal@kernel.org>
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
index 99c69489bb44..9aa0d789d25e 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -662,7 +662,7 @@ static int tipc_nl_compat_link_dump(struct tipc_nl_compat_msg *msg,
 	if (err)
 		return err;
 
-	link_info.dest = nla_get_flag(link[TIPC_NLA_LINK_DEST]);
+	link_info.dest = htonl(nla_get_flag(link[TIPC_NLA_LINK_DEST]));
 	link_info.up = htonl(nla_get_flag(link[TIPC_NLA_LINK_UP]));
 	nla_strlcpy(link_info.str, link[TIPC_NLA_LINK_NAME],
 		    TIPC_MAX_LINK_NAME);
-- 
2.30.2

