Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2993374011
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbhEEQck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:32:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234155AbhEEQcg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:32:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19D82613F5;
        Wed,  5 May 2021 16:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232300;
        bh=tYasmsVH0Piz6byNcOMr5ONyvpW8tVB6xO4yCUZpBes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mQBzMhQG4k7hHUEhHQpOM2Myt2B1XQ64lMJot9rkCamFY1fjBS9b60ooe8nGMzlXl
         eSkhJXaTe57DX47BLH5Ib6CPDGa92rLD1rOTKku+2wk/FHIDOQO1bdWGkFjT8FCTxT
         +p3jVqMLjcfx1MQfQudwiuRG5fUrrI5o8BpJq0yBTbg/eEwV0M42AmG9x0HTAmphSJ
         hSriNwobpLNorLZdAcX+GNL81ZNEOAtFnitR/iwDbYIaeoxFKbgpcvzdSNVDCjmgSP
         QMF1l/USz6sXLptFdGLDJiXKLnSygUvlQTM7ApsM5cgVnhrPCA9ULkL/4r+Vcxpuq6
         qQee2fgynZdcA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hoang Le <hoang.h.le@dektech.com.au>,
        Jon Maloy <jmaloy@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.12 011/116] tipc: convert dest node's address to network order
Date:   Wed,  5 May 2021 12:29:39 -0400
Message-Id: <20210505163125.3460440-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
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
index 5a1ce64039f7..0749df80454d 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -696,7 +696,7 @@ static int tipc_nl_compat_link_dump(struct tipc_nl_compat_msg *msg,
 	if (err)
 		return err;
 
-	link_info.dest = nla_get_flag(link[TIPC_NLA_LINK_DEST]);
+	link_info.dest = htonl(nla_get_flag(link[TIPC_NLA_LINK_DEST]));
 	link_info.up = htonl(nla_get_flag(link[TIPC_NLA_LINK_UP]));
 	nla_strscpy(link_info.str, link[TIPC_NLA_LINK_NAME],
 		    TIPC_MAX_LINK_NAME);
-- 
2.30.2

