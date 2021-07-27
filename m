Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC223D7761
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236802AbhG0Nrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:47:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236952AbhG0Nqw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:46:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F23C061A8F;
        Tue, 27 Jul 2021 13:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393612;
        bh=XdpdqxAWvfs1sMjQ8g/1aRp2X1qZ6nWPW7SMBGblQsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ciQbIp1ySnXlTDvha/hZkwfIo+NzJZsGD3iWgAr0kQ6toD26AujtFqnwjKVfljGNz
         qKM+7Rsap65zRTM8rJdOh+g7v+MJZbyKYjcv8tvCKvET28y+B+B7U+tK9HCbCxvFUz
         UoFz8CrnxsGpJsMXjn6q4Hqym5c+syTAlUwn+KrEsj45A1F1FDJN/qmTx5iTPjKNDV
         7ZW4JQmjOoVH3R7cD5cc8Vzvn/xZLfCfH86TVgHaAUotxi8ENGykrW4hzlPgWV1JAz
         NUgUCqQiQPHG9Kj+3Agt/ZvO6yKtZ+vuLuEz/wD/XMGwDrrEfK/+KxaAFaetTliZxi
         bmfG6OzBL48sA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v3 29/31] net: socket: return changed ifreq from SIOCDEVPRIVATE
Date:   Tue, 27 Jul 2021 15:45:15 +0200
Message-Id: <20210727134517.1384504-30-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org>
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
index e0586bc4d6c6..70a379cee5fd 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -286,9 +286,7 @@ static int dev_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
 			return -ENODEV;
 	}
 
-	/* fall back to do_ioctl for drivers not yet converted */
-	ifr->ifr_data = data;
-	return dev_do_ioctl(dev, ifr, cmd);
+	return -EOPNOTSUPP;
 }
 
 static int dev_siocwandev(struct net_device *dev, struct if_settings *ifs)
diff --git a/net/socket.c b/net/socket.c
index ddce6327633e..48471a219c1d 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3234,7 +3234,7 @@ static int compat_sock_ioctl_trans(struct file *file, struct socket *sock,
 	struct net *net = sock_net(sk);
 
 	if (cmd >= SIOCDEVPRIVATE && cmd <= (SIOCDEVPRIVATE + 15))
-		return compat_ifr_data_ioctl(net, cmd, argp);
+		return sock_ioctl(file, cmd, (unsigned long)argp);
 
 	switch (cmd) {
 	case SIOCSIFBR:
-- 
2.29.2

