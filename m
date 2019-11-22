Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 173521060DD
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 06:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbfKVFw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 00:52:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:58178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727313AbfKVFw1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:52:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E9ED20717;
        Fri, 22 Nov 2019 05:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401946;
        bh=LCMRf+GTA8PLWlhhQyo1kvbeft7FZQoVSPIC2iobdPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UE8TSRUy73x9bFah/5w/neBBQ4vFB4BWQ4UXOrrP4zNCElKgOJGdwUHI4s4EJWw41
         UDLA/Lyt/3La3/78xhKTTTTqzH9bNsK9UFusnrjy8m4jD+uDlv3VmS8ZMMbMzjxFEs
         WpcYyqLJdsCNzSVbHUzmKmC2AOyqJ2kmEC+yCo4g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Ying Xue <ying.xue@windriver.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 170/219] tipc: fix memory leak in tipc_nl_compat_publ_dump
Date:   Fri, 22 Nov 2019 00:48:22 -0500
Message-Id: <20191122054911.1750-163-sashal@kernel.org>
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

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

[ Upstream commit f87d8ad9233f115db92c6c087d58403b0009ed36 ]

There is a memory leak in case genlmsg_put fails.

Fix this by freeing *args* before return.

Addresses-Coverity-ID: 1476406 ("Resource leak")
Fixes: 46273cf7e009 ("tipc: fix a missing check of genlmsg_put")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/netlink_compat.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index fab0384d2b4b3..b4860084a8f56 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -983,8 +983,10 @@ static int tipc_nl_compat_publ_dump(struct tipc_nl_compat_msg *msg, u32 sock)
 
 	hdr = genlmsg_put(args, 0, 0, &tipc_genl_family, NLM_F_MULTI,
 			  TIPC_NL_PUBL_GET);
-	if (!hdr)
+	if (!hdr) {
+		kfree_skb(args);
 		return -EMSGSIZE;
+	}
 
 	nest = nla_nest_start(args, TIPC_NLA_SOCK);
 	if (!nest) {
-- 
2.20.1

