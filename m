Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1434C3CFD7E
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241230AbhGTOpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:45:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239528AbhGTOUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 10:20:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1EE26128C;
        Tue, 20 Jul 2021 14:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626792446;
        bh=7G0msoVM5bFZAgFgW5o6/U+H/ybwHmjNnggqvgAQVxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eeesKY3uVzlk2Ap5Nt0gFxZ8XrCpsxxcP5b3/NxVX1bFagnnkoFp8PhSlmHWH2CWe
         tbgd190adn0vrT23u7W1FjF7Us4jl1YNlfH+oZXnDag78N7NUbZmcjLNn5jJRq9xzv
         O32I/uHsRssZHsDhEqCFgMY/G+WVJd7h99YBZ3aBMZMCB6onQNDyHk2L0qoWzrNmzy
         aX6yDippdcOA1MNMq//gyDYW5VY92ZiNzzUYVSKH2B71lWNwQWOQ03QrLqtAx7d55q
         hWzfrAe3jBkp7NpM5RVoQQs2Wa18sx3ZrH2SaaLfaoXOIgv07iaB1UDcW8Y0OMe5wp
         JhVRYfsB2VUnQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v2 29/31] net: socket: return changed ifreq from SIOCDEVPRIVATE
Date:   Tue, 20 Jul 2021 16:46:36 +0200
Message-Id: <20210720144638.2859828-30-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210720144638.2859828-1-arnd@kernel.org>
References: <20210720144638.2859828-1-arnd@kernel.org>
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
index 4da176507006..2f58afbaf87a 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -285,9 +285,7 @@ static int dev_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
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

