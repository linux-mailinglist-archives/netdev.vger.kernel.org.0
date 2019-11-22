Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9EF910652B
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbfKVGWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:22:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:57336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728364AbfKVFv7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:51:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86A8820726;
        Fri, 22 Nov 2019 05:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401919;
        bh=pkcgl8GLrGanjEtXFJT5zlPNjUrk/9i/0wS56xwsYuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o0GwlbDWFA0i6ykjPYkGxPjt4CSh6SRn0vtIzhMou14jMP+sceUrogP9ttqpuLIPc
         Y1qrw/FjssGJx/OqUL1O6ih+ViIS6f6u3AlyrjR+bn9wBteCvuMwsQMhdsj9+xUzSL
         hkzJ6tlY6AHMSh3LTvYMND+29yTYs9vUfPLs0PA8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kangjie Lu <kjlu@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 149/219] tipc: fix a missing check of genlmsg_put
Date:   Fri, 22 Nov 2019 00:48:01 -0500
Message-Id: <20191122054911.1750-142-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kangjie Lu <kjlu@umn.edu>

[ Upstream commit 46273cf7e009231d2b6bc10a926e82b8928a9fb2 ]

genlmsg_put could fail. The fix inserts a check of its return value, and
if it fails, returns -EMSGSIZE.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/netlink_compat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 6494d6b5e1b24..fab0384d2b4b3 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -983,6 +983,8 @@ static int tipc_nl_compat_publ_dump(struct tipc_nl_compat_msg *msg, u32 sock)
 
 	hdr = genlmsg_put(args, 0, 0, &tipc_genl_family, NLM_F_MULTI,
 			  TIPC_NL_PUBL_GET);
+	if (!hdr)
+		return -EMSGSIZE;
 
 	nest = nla_nest_start(args, TIPC_NLA_SOCK);
 	if (!nest) {
-- 
2.20.1

