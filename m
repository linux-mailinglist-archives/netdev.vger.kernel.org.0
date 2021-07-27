Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9EC3D772A
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236836AbhG0Nq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:46:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236828AbhG0NqP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:46:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1481161A54;
        Tue, 27 Jul 2021 13:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393575;
        bh=ae1hfH8QF/RCzo7dEv8MK0I6559MFhj95aqCe+aAmz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MstiQWuzJx8TGB9tI9V9t0NnuYyHtNmfD/5gEPaiqYsxSJTS3w28VPtR5wJtO+hVa
         XEDCm8+oYSkcG/TOZY1vbMuHYTWGSZ1WbTr2qNbfkkJFhCp+SvNvw6+9pqydAlqxUG
         5UwLIXM9xdAtLsq2LugkwdE+P46pkOx92UMOJey4cVS9+a6wSj6YyeyUkvJdR8ZuKE
         68aRj3pdvRNTMNXVX5oNClxKqMJS8UrQkf/FZQBUk2j++H8HzrCFQUnZYX9ojpdkNG
         GkKDjMcEpdT2jDIvU3hmsUiCVjZR1bKaRoiiwxyb+uO3x5O+7ytlujO76sh6xFnb9Z
         hNeRQGybvXhUA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v3 09/31] appletalk: use ndo_siocdevprivate
Date:   Tue, 27 Jul 2021 15:44:55 +0200
Message-Id: <20210727134517.1384504-10-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

appletalk has three SIOCDEVPRIVATE ioctl commands that are
broken in compat mode because the passed structure contains
a pointer.

Change it over to ndo_siocdevprivate for consistency and
make it return an error when called in compat mode. This
could be fixed if there are still users.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/appletalk/ipddp.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/appletalk/ipddp.c b/drivers/net/appletalk/ipddp.c
index 51cf5eca9c7f..5566daefbff4 100644
--- a/drivers/net/appletalk/ipddp.c
+++ b/drivers/net/appletalk/ipddp.c
@@ -54,11 +54,12 @@ static netdev_tx_t ipddp_xmit(struct sk_buff *skb,
 static int ipddp_create(struct ipddp_route *new_rt);
 static int ipddp_delete(struct ipddp_route *rt);
 static struct ipddp_route* __ipddp_find_route(struct ipddp_route *rt);
-static int ipddp_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
+static int ipddp_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+				void __user *data, int cmd);
 
 static const struct net_device_ops ipddp_netdev_ops = {
 	.ndo_start_xmit		= ipddp_xmit,
-	.ndo_do_ioctl   	= ipddp_ioctl,
+	.ndo_siocdevprivate	= ipddp_siocdevprivate,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 };
@@ -268,15 +269,18 @@ static struct ipddp_route* __ipddp_find_route(struct ipddp_route *rt)
         return NULL;
 }
 
-static int ipddp_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int ipddp_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+				void __user *data, int cmd)
 {
-        struct ipddp_route __user *rt = ifr->ifr_data;
         struct ipddp_route rcp, rcp2, *rp;
 
+	if (in_compat_syscall())
+		return -EOPNOTSUPP;
+
         if(!capable(CAP_NET_ADMIN))
                 return -EPERM;
 
-	if(copy_from_user(&rcp, rt, sizeof(rcp)))
+	if (copy_from_user(&rcp, data, sizeof(rcp)))
 		return -EFAULT;
 
         switch(cmd)
@@ -296,7 +300,7 @@ static int ipddp_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			spin_unlock_bh(&ipddp_route_lock);
 
 			if (rp) {
-				if (copy_to_user(rt, &rcp2,
+				if (copy_to_user(data, &rcp2,
 						 sizeof(struct ipddp_route)))
 					return -EFAULT;
 				return 0;
-- 
2.29.2

