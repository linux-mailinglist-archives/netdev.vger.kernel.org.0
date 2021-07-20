Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFF23CFD3A
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239498AbhGTOeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:34:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238651AbhGTONr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 10:13:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48FE361244;
        Tue, 20 Jul 2021 14:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626792423;
        bh=ae1hfH8QF/RCzo7dEv8MK0I6559MFhj95aqCe+aAmz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nDu06lJB8KNGIbyWt04e9g3YRNVrhASSjLgSgsyX+sesUAvB+ddVrjQwcfcdK72/f
         VBdMDWrfDmWmMerXb0+sAUxc90NFDcdvi3TIN/MhQ7iFVUOAyamjCLCh2/jgM6vqWI
         pD9HQbZBn3a0L41BFKcXh4mjVgxFW73ZjNC3iiltlr7N/SM0/B4RQ/qTh8An7lLyRy
         kDUHqw80/MKvIqyGEBy46AM93hIfZkFyfNLzrlcYB3nK0AtSgGkqF0uUQz9rMtv4LP
         9CX2az37NFsu0V3lixvNSlyb2aWGWI3NUjLNvhBubXjn+oBOSXXPjilTjPFWE+VGB+
         rVBOwjUTpswxw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v2 09/31] appletalk: use ndo_siocdevprivate
Date:   Tue, 20 Jul 2021 16:46:16 +0200
Message-Id: <20210720144638.2859828-10-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210720144638.2859828-1-arnd@kernel.org>
References: <20210720144638.2859828-1-arnd@kernel.org>
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

