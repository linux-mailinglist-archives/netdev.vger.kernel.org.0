Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2E714968B
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 17:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgAYQOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 11:14:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:33020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725843AbgAYQOR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 11:14:17 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E99D32071A;
        Sat, 25 Jan 2020 16:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579968856;
        bh=tG1jztXvIuyrhcdmu+h109XhVd+uN6XSXS+OCTvPijg=;
        h=From:To:Cc:Subject:Date:From;
        b=IE1Pf0FIQxoeX/IEZ9c7E5mnfQvAoADungW9c0V5sdvfR3soZFnLXwj32eBVCiA1I
         E97T+yfsfo8hcimZRTN+uLNESSL0UAx4KU5GjqnmryZKzpMg41ydCf3dGlXhfR56KE
         alS0bFOmQgUkchIZoslzJlStE6FiPSAvFp5RZJzo=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Michal Kalderon <michal.kalderon@marvell.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH net-next v1] net/core: Replace driver version to be kernel version
Date:   Sat, 25 Jan 2020 18:14:01 +0200
Message-Id: <20200125161401.40683-1-leon@kernel.org>
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

Before this change:
[leonro@erver ~]$ ethtool -i eth0
driver: virtio_net
version: 1.0.0
After this change:
[leonro@server ~]$ ethtool -i eth0
driver: virtio_net
version: 5.5.0-rc6+

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 Changelog:
 v1: Resend per-Dave's request
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

