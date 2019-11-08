Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C37A5F4A74
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390144AbfKHMJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 07:09:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:53134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388436AbfKHLkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:40:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98F99222C6;
        Fri,  8 Nov 2019 11:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213209;
        bh=1trDmOUYVi/h8TeA1Jy2TYemlFI7NDFW1aOIVk9jWwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CjpKEg3Vyw1y9ZsRn9sou3pmHUi595QPkjEd/YXlTg7OwXNQ+YjdXm8m7gt6F489A
         Tpr5Pj3KM7aWB0s1s7FKqQ3YlokGX1ZpLpHyVrAKEHN0ZyAVFujdnoN2mZqmTNawIA
         8pgKxjtNOF2E3Y5qZ+6AYhTUSWn+6cGf/l7rTBfQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Brauner <christian@brauner.io>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 090/205] rtnetlink: move type calculation out of loop
Date:   Fri,  8 Nov 2019 06:35:57 -0500
Message-Id: <20191108113752.12502-90-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Brauner <christian@brauner.io>

[ Upstream commit 87ccbb1f943625884b824c5560f635dcea8e4510 ]

I don't see how the type - which is one of
RTM_{GETADDR,GETROUTE,GETNETCONF} - can change. So do the message type
calculation once before entering the for loop.

Signed-off-by: Christian Brauner <christian@brauner.io>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 3932eed379a40..a199bd85085da 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3268,13 +3268,13 @@ static int rtnl_dump_all(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	int idx;
 	int s_idx = cb->family;
+	int type = cb->nlh->nlmsg_type - RTM_BASE;
 
 	if (s_idx == 0)
 		s_idx = 1;
 
 	for (idx = 1; idx <= RTNL_FAMILY_MAX; idx++) {
 		struct rtnl_link **tab;
-		int type = cb->nlh->nlmsg_type-RTM_BASE;
 		struct rtnl_link *link;
 		rtnl_dumpit_func dumpit;
 
-- 
2.20.1

