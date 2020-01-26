Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D120D1499F0
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 11:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbgAZKBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 05:01:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:49964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728292AbgAZKBa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jan 2020 05:01:30 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65B502071E;
        Sun, 26 Jan 2020 10:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580032890;
        bh=+V+hL8a+9g4gbfkotsr618QGRy9DM+1zuB2YmdPqSZU=;
        h=From:To:Cc:Subject:Date:From;
        b=rK+AI9RKtp1oetdk5Y5k4cylhmeejLZ/rgAfsvkE0NQXXUb+bdjGWnlm16yn//euI
         puEs2+RQqjzdL5Ck4b6nu35ray35sHoYGPPQK7FH4/oW8zyMZWEt6j95SooOf84Qgx
         K6dksUg/Aspf3FRXiGGq/VqLiOlbd9mT0bgemPL8=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH rdma-next v2] net/core: Replace driver version to be kernel version
Date:   Sun, 26 Jan 2020 12:01:24 +0200
Message-Id: <20200126100124.86014-1-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

In order to stop useless driver version bumps and unify output
presented by ethtool -i, let's overwrite the version string.

As Linus said in [1]: "Things are supposed to be backwards and
forwards compatible, because we don't accept breakage in user
space anyway. So versioning is pointless, and only causes
problems."

They cause problems when users start to see version changes
and expect specific set of features which will be different
for stable@, vanilla and distribution kernels.

Distribution kernels are based on some kernel version with extra
patches on top, for example, in RedHat world this "extra" is a lot
and for them the driver version say nothing. Users who run vanilla
kernels won't use driver version information too, because running
such kernels requires knowledge and understanding.

Another set of problems are related to difference in versioning scheme
and such doesn't allow to write meaningful automation which will work
sanely on all ethtool capable devices.

Before this change:
[leonro@erver ~]$ ethtool -i eth0
driver: virtio_net
version: 1.0.0
After this change:
[leonro@server ~]$ ethtool -i eth0
driver: virtio_net
version: 5.5.0-rc6+

Link: https://lore.kernel.org/ksummit-discuss/CA+55aFx9A=5cc0QZ7CySC4F2K7eYaEfzkdYEc9JaNgCcV25=rg@mail.gmail.com/
Link: https://lore.kernel.org/linux-rdma/20200122152627.14903-1-michal.kalderon@marvell.com/T/#md460ff8f976c532a89d6860411c3c50bb811038b
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 Changelog:
 v2: Updated commit message.
 v1: https://lore.kernel.org/linux-rdma/20200125161401.40683-1-leon@kernel.org
     Resend per-Dave's request
     https://lore.kernel.org/linux-rdma/20200125.101311.1924780619716720495.davem@davemloft.net
     No changes at all and applied cleanly on top of "3333e50b64fe Merge branch 'mlxsw-Offload-TBF'"
 v0: https://lore.kernel.org/linux-rdma/20200123130541.30473-1-leon@kernel.org
---
 net/ethtool/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 182bffbffa78..a403decacb6d 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -17,6 +17,7 @@
 #include <linux/phy.h>
 #include <linux/bitops.h>
 #include <linux/uaccess.h>
+#include <linux/vermagic.h>
 #include <linux/vmalloc.h>
 #include <linux/sfp.h>
 #include <linux/slab.h>
@@ -666,6 +667,8 @@ static noinline_for_stack int ethtool_get_drvinfo(struct net_device *dev,
 		return -EOPNOTSUPP;
 	}

+	strlcpy(info.version, UTS_RELEASE, sizeof(info.version));
+
 	/*
 	 * this method of obtaining string set info is deprecated;
 	 * Use ETHTOOL_GSSET_INFO instead.
--
2.24.1

