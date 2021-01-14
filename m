Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF13E2F56A0
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 02:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728790AbhANBuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 20:50:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:38650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728770AbhANBuG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 20:50:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55D7F2310A;
        Thu, 14 Jan 2021 01:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610587789;
        bh=mo45egw9EobPzWEzb+Rc6Su03umx9Va6J5jOJTpwnY0=;
        h=From:To:Cc:Subject:Date:From;
        b=YTa8HT5Cbcgye87WTGLIWwP00/molGgxkWhxj+rpqzl62QkgZqSwt0PtsS1HP01LI
         WOh3HhUeO2+70uVs3QBG1u7SxOO3T02xa21Zuax0Fi57+7NxOND1gtBnyFPG1hy1/o
         dx0ujZAB5IJucETSMQVH0YanMXEQYfamV3L824iDvJTJWQt5SfuEx7iuo2nN9tfx7C
         Fp1ArcYrqSKLJ13Rivabm9WSh5kBTdHatM6HU907worWg29nqbesVwTsaAmb76ZMH0
         1gQV7ITS7nPEjAe2oxKU/RdQm/Dz2sDUuygbefaVJDZ3kbocSGEVf8m2Ft7KsEPohr
         cOtLlJ1shPRyg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, nicolas.dichtel@6wind.com,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot+2393580080a2da190f04@syzkaller.appspotmail.com
Subject: [PATCH net] net: sit: unregister_netdevice on newlink's error path
Date:   Wed, 13 Jan 2021 17:29:47 -0800
Message-Id: <20210114012947.2515313-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to unregister the netdevice if config failed.
.ndo_uninit takes care of most of the heavy lifting.

This was uncovered by recent commit c269a24ce057 ("net: make
free_netdev() more lenient with unregistering devices").
Previously the partially-initialized device would be left
in the system.

Reported-and-tested-by: syzbot+2393580080a2da190f04@syzkaller.appspotmail.com
Fixes: e2f1f072db8d ("sit: allow to configure 6rd tunnels via netlink")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv6/sit.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 2da0ee703779..440175bc2e89 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -1645,8 +1645,11 @@ static int ipip6_newlink(struct net *src_net, struct net_device *dev,
 	}
 
 #ifdef CONFIG_IPV6_SIT_6RD
-	if (ipip6_netlink_6rd_parms(data, &ip6rd))
+	if (ipip6_netlink_6rd_parms(data, &ip6rd)) {
 		err = ipip6_tunnel_update_6rd(nt, &ip6rd);
+		if (err)
+			unregister_netdevice_queue(dev, NULL);
+	}
 #endif
 
 	return err;
-- 
2.26.2

