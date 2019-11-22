Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3429A106218
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbfKVGB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:01:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:35550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727602AbfKVF5Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:57:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99F9C2072E;
        Fri, 22 Nov 2019 05:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402236;
        bh=1P+JhWcNEDUHQp8AcPsVmL+tkyIZYHZtGb1E3NhEtE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1tp8NOVGNwezmRdzYQFJ6+xBYrpkyzgzbS4Mt4qzdfAnDmSpK4KedwkwYg4FNcUkw
         enVhPmg5lXPnEq6Aw3hu33gGFDB9ciGHYCSfs4So/DUDovuxGYBar2fA5S2HGgkDrK
         twYTQ8CCCvB3QldiF05NoatNEyUSpkCgMYGhaFug=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aditya Pakki <pakki001@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.14 081/127] net/netlink_compat: Fix a missing check of nla_parse_nested
Date:   Fri, 22 Nov 2019 00:54:59 -0500
Message-Id: <20191122055544.3299-80-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit 89dfd0083751d00d5d7ead36f6d8b045bf89c5e1 ]

In tipc_nl_compat_sk_dump(), if nla_parse_nested() fails, it could return
an error. To be consistent with other invocations of the function call,
on error, the fix passes the return value upstream.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/netlink_compat.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index ad4dcc663c6de..1c8ac0c11008c 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -1021,8 +1021,11 @@ static int tipc_nl_compat_sk_dump(struct tipc_nl_compat_msg *msg,
 		u32 node;
 		struct nlattr *con[TIPC_NLA_CON_MAX + 1];
 
-		nla_parse_nested(con, TIPC_NLA_CON_MAX,
-				 sock[TIPC_NLA_SOCK_CON], NULL, NULL);
+		err = nla_parse_nested(con, TIPC_NLA_CON_MAX,
+				       sock[TIPC_NLA_SOCK_CON], NULL, NULL);
+
+		if (err)
+			return err;
 
 		node = nla_get_u32(con[TIPC_NLA_CON_NODE]);
 		tipc_tlv_sprintf(msg->rep, "  connected to <%u.%u.%u:%u>",
-- 
2.20.1

