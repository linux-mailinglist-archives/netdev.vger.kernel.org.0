Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5682AA006
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbgKFWTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:19:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:42816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729232AbgKFWTP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:19:15 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CC6420882;
        Fri,  6 Nov 2020 22:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701154;
        bh=OjKky2mcuT3PPhvnL2N1n9WJjuGKW1fEUioqpsDSDNw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=piTqh36/Ayd8rKuc3zcxxLUXwu8coawnGzadmDxmNVwyht5LsFJxbKKpvbei6ZwB5
         i4Xivr2LHHwHyaH25bXiALK3Cu/8c5VDnYA8drwte5C9rzrbOpBOhdg19zecSP7Ss6
         iishXpi6LYmi5ZVVAqz5r5CZz+uIbP+0EafwU9MI=
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-hams@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [RFC net-next 28/28] net: socket: return changed ifreq from SIOCDEVPRIVATE
Date:   Fri,  6 Nov 2020 23:17:43 +0100
Message-Id: <20201106221743.3271965-29-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201106221743.3271965-1-arnd@kernel.org>
References: <20201106221743.3271965-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Some drivers that use SIOCDEVPRIVATE ioctl commands modify
the ifreq structure and expect it to be passed back to user
space, which has never really happened for compat mode
because the calling these drivers through ndo_do_ioctl
requires overwriting the ifr_data pointer.

Now that all drivers are converted to ndo_siocdevprivate,
change it to handle this correctly in both compat and
native mode.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/core/dev_ioctl.c | 4 +---
 net/socket.c         | 2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 99efe8e2e0ce..0c058c3dc89a 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -296,9 +296,7 @@ static int dev_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
 			return -ENODEV;
 	}
 
-	/* fall back to do_ioctl for drivers not yet converted */
-	ifr->ifr_data = data;
-	return dev_do_ioctl(dev, ifr, cmd);
+	return -EOPNOTSUPP;
 }
 
 /*
diff --git a/net/socket.c b/net/socket.c
index 1e077182d0fd..6edf3f4d9dca 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3206,7 +3206,7 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 	struct net *net = sock_net(sk);
 
 	if (cmd >= SIOCDEVPRIVATE && cmd <= (SIOCDEVPRIVATE + 15))
-		return compat_ifr_data_ioctl(net, cmd, argp);
+		return sock_ioctl(file, cmd, (unsigned long)argp);
 
 	switch (cmd) {
 	case SIOCSIFBR:
-- 
2.27.0

