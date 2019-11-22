Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91B5B10641E
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbfKVGOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:14:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:51484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728749AbfKVGN6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 01:13:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 773A02068F;
        Fri, 22 Nov 2019 06:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574403238;
        bh=uVmrMTReuiw8qke0Vz4udyQimZmWzBpfxFe56+DKeUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cJdbDakrhSAxyjZ6SxEv7snewkEFWRcsZQUAyNsy3iXEIInpz1IKxjf1ydW8XU8zO
         8oHlfBr58gHmNE0RdbJmMGRQKCJ5SnJwVDCBc04gD8QwX8VxwKwhsgNs/ewmLUO5mj
         82xuiEZ7gsbLK1bxZbZqQDy4g2MNIaWkwLzC6tOU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kangjie Lu <kjlu@umn.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.4 50/68] tipc: fix a missing check of genlmsg_put
Date:   Fri, 22 Nov 2019 01:12:43 -0500
Message-Id: <20191122061301.4947-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122061301.4947-1-sashal@kernel.org>
References: <20191122061301.4947-1-sashal@kernel.org>
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
index d2bf92e711505..4f6fbd2f29add 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -926,6 +926,8 @@ static int tipc_nl_compat_publ_dump(struct tipc_nl_compat_msg *msg, u32 sock)
 
 	hdr = genlmsg_put(args, 0, 0, &tipc_genl_family, NLM_F_MULTI,
 			  TIPC_NL_PUBL_GET);
+	if (!hdr)
+		return -EMSGSIZE;
 
 	nest = nla_nest_start(args, TIPC_NLA_SOCK);
 	if (!nest) {
-- 
2.20.1

