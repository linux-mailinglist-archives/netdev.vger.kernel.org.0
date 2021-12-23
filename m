Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A2047E572
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 16:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241751AbhLWP1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 10:27:15 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:46463 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236550AbhLWP1O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 10:27:14 -0500
X-Greylist: delayed 16291 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Dec 2021 10:27:13 EST
Received: (Authenticated sender: repk@triplefau.lt)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id EEBA5C0007;
        Thu, 23 Dec 2021 15:27:10 +0000 (UTC)
From:   Remi Pommarel <repk@triplefau.lt>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Remi Pommarel <repk@triplefau.lt>
Subject: [PATCH net 1/2] net: bridge: fix ioctl old_deviceless bridge argument
Date:   Thu, 23 Dec 2021 16:31:38 +0100
Message-Id: <20211223153139.7661-2-repk@triplefau.lt>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211223153139.7661-1-repk@triplefau.lt>
References: <20211223153139.7661-1-repk@triplefau.lt>
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

The fixes BRCTL_GET_BRIDGES as well and has been tested with busybox's
brctl.

Example of broken brctl:
$ brctl show
bridge name     bridge id               STP enabled     interfaces
brctl: can't get bridge name for index 0: No such device or address

Example of fixed brctl:
$ brctl show
bridge name     bridge id               STP enabled     interfaces
br0             8000.000000000000       no

Fixes: 561d8352818f ("bridge: use ndo_siocdevprivate")
Signed-off-by: Remi Pommarel <repk@triplefau.lt>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
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

