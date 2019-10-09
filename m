Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20BC5D1614
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 19:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732774AbfJIR1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 13:27:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732347AbfJIRYa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 13:24:30 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9AE021929;
        Wed,  9 Oct 2019 17:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641870;
        bh=Ay+h74khH/1fU1y9XJ3IOYOYoc+ZH4aIsf7L+V39wB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hbWkVaLPRh2yoLGYrRgbwb8eAZ64Jg6clV5OJ4L+uwQY64F4QH1IwgUVgKIY9BBJk
         v2B0Dk2AmMz3DuMJ5Llhl0Lzk4gRePabUK2whKnBaJ2Z8S+qFrIIXfRK1tAwtoEgJh
         hXp7n+QVybWsOJLH1OOIHljzoTYYy4g95LmMN12k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Miaoqing Pan <miaoqing@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 14/21] nl80211: fix null pointer dereference
Date:   Wed,  9 Oct 2019 13:06:07 -0400
Message-Id: <20191009170615.32750-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170615.32750-1-sashal@kernel.org>
References: <20191009170615.32750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaoqing Pan <miaoqing@codeaurora.org>

[ Upstream commit b501426cf86e70649c983c52f4c823b3c40d72a3 ]

If the interface is not in MESH mode, the command 'iw wlanx mpath del'
will cause kernel panic.

The root cause is null pointer access in mpp_flush_by_proxy(), as the
pointer 'sdata->u.mesh.mpp_paths' is NULL for non MESH interface.

Unable to handle kernel NULL pointer dereference at virtual address 00000068
[...]
PC is at _raw_spin_lock_bh+0x20/0x5c
LR is at mesh_path_del+0x1c/0x17c [mac80211]
[...]
Process iw (pid: 4537, stack limit = 0xd83e0238)
[...]
[<c021211c>] (_raw_spin_lock_bh) from [<bf8c7648>] (mesh_path_del+0x1c/0x17c [mac80211])
[<bf8c7648>] (mesh_path_del [mac80211]) from [<bf6cdb7c>] (extack_doit+0x20/0x68 [compat])
[<bf6cdb7c>] (extack_doit [compat]) from [<c05c309c>] (genl_rcv_msg+0x274/0x30c)
[<c05c309c>] (genl_rcv_msg) from [<c05c25d8>] (netlink_rcv_skb+0x58/0xac)
[<c05c25d8>] (netlink_rcv_skb) from [<c05c2e14>] (genl_rcv+0x20/0x34)
[<c05c2e14>] (genl_rcv) from [<c05c1f90>] (netlink_unicast+0x11c/0x204)
[<c05c1f90>] (netlink_unicast) from [<c05c2420>] (netlink_sendmsg+0x30c/0x370)
[<c05c2420>] (netlink_sendmsg) from [<c05886d0>] (sock_sendmsg+0x70/0x84)
[<c05886d0>] (sock_sendmsg) from [<c0589f4c>] (___sys_sendmsg.part.3+0x188/0x228)
[<c0589f4c>] (___sys_sendmsg.part.3) from [<c058add4>] (__sys_sendmsg+0x4c/0x70)
[<c058add4>] (__sys_sendmsg) from [<c0208c80>] (ret_fast_syscall+0x0/0x44)
Code: e2822c02 e2822001 e5832004 f590f000 (e1902f9f)
---[ end trace bbd717600f8f884d ]---

Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
Link: https://lore.kernel.org/r/1569485810-761-1-git-send-email-miaoqing@codeaurora.org
[trim useless data from commit message]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f19d5a55f09ef..8477209906aba 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5464,6 +5464,9 @@ static int nl80211_del_mpath(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->del_mpath)
 		return -EOPNOTSUPP;
 
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT)
+		return -EOPNOTSUPP;
+
 	return rdev_del_mpath(rdev, dev, dst);
 }
 
-- 
2.20.1

