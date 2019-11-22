Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8287106297
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728221AbfKVGFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:05:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:41472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728903AbfKVGCm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 01:02:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C73A420659;
        Fri, 22 Nov 2019 06:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402561;
        bh=oqoXrjybaQcbpavSA2Ct70GdEPmxLqSSsipp5kfREaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Sn/gB1PtsODzNjFHv/aR0brefRinnpV9WDI1iZ4L2/O2iN55dFFQi0UnORvcBk4F
         JfJIj0kE3ElvCnDre5vKJdd+NEPjuZ0zhcpYzGsEPg9V1I55azflOuP3dvwBDWy1GM
         L2Lbr/WXiYASMcVcj6dlLvnodPLuLov9lSb2eqpE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kangjie Lu <kjlu@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.9 66/91] tipc: fix a missing check of genlmsg_put
Date:   Fri, 22 Nov 2019 01:01:04 -0500
Message-Id: <20191122060129.4239-65-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122060129.4239-1-sashal@kernel.org>
References: <20191122060129.4239-1-sashal@kernel.org>
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
index 63a913b238735..454ed8ea194c8 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -974,6 +974,8 @@ static int tipc_nl_compat_publ_dump(struct tipc_nl_compat_msg *msg, u32 sock)
 
 	hdr = genlmsg_put(args, 0, 0, &tipc_genl_family, NLM_F_MULTI,
 			  TIPC_NL_PUBL_GET);
+	if (!hdr)
+		return -EMSGSIZE;
 
 	nest = nla_nest_start(args, TIPC_NLA_SOCK);
 	if (!nest) {
-- 
2.20.1

