Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4535347D77D
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 20:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345120AbhLVTLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 14:11:09 -0500
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:39439 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345107AbhLVTLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 14:11:02 -0500
Received: (Authenticated sender: repk@triplefau.lt)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 0D4B91BF207;
        Wed, 22 Dec 2021 19:10:57 +0000 (UTC)
From:   Remi Pommarel <repk@triplefau.lt>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Remi Pommarel <repk@triplefau.lt>
Subject: [PATCH net] net: bridge: fix ioctl old_deviceless bridge argument
Date:   Wed, 22 Dec 2021 20:13:20 +0100
Message-Id: <20211222191320.17662-1-repk@triplefau.lt>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 561d8352818f ("bridge: use ndo_siocdevprivate") changed the
source and destination arguments of copy_{to,from}_user in bridge's
old_deviceless() from args[1] to uarg breaking SIOC{G,S}IFBR ioctls.

Commit cbd7ad29a507 ("net: bridge: fix ioctl old_deviceless bridge
argument") fixed only BRCTL_{ADD,DEL}_BRIDGES commands leaving
BRCTL_GET_BRIDGES one untouched.

The fixes BRCTL_GET_BRIDGES as well

Fixes: 561d8352818f ("bridge: use ndo_siocdevprivate")
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
---
 net/bridge/br_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_ioctl.c b/net/bridge/br_ioctl.c
index db4ab2c2ce18..891cfcf45644 100644
--- a/net/bridge/br_ioctl.c
+++ b/net/bridge/br_ioctl.c
@@ -337,7 +337,7 @@ static int old_deviceless(struct net *net, void __user *uarg)
 
 		args[2] = get_bridge_ifindices(net, indices, args[2]);
 
-		ret = copy_to_user(uarg, indices,
+		ret = copy_to_user((void __user *)args[1], indices,
 				   array_size(args[2], sizeof(int)))
 			? -EFAULT : args[2];
 
-- 
2.33.0

