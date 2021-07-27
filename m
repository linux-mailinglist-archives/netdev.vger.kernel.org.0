Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052913D772C
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236998AbhG0Nqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:46:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236721AbhG0NqL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:46:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A9D1619F5;
        Tue, 27 Jul 2021 13:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393571;
        bh=+t9fgxzXlhR6aMB1NCCu4ndbySWH7P+Oqdf5Vmqkihs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s5hvaYII0JI/yTMojcAbHnRFPE3DsxQrcdUu6WAdNMCZ0AhHv08oHIVYp2knEXQZ8
         0KpnHD1dKUc0T88Eeb2IE5yQe2Met5WI4kuSnsArK6T0o1IgKjETUaa9TTzun9jQQ2
         dBZAhdfTwHko51YlM5kOH24yfRcpwa2/3FgEH36amqzfVmrhWgx2rJbbAtR1AKyNyn
         4oFb00PJwN3m0fL0klGd00jFyab5kvRU8cmUawzIqlGG4yzu3rPa3eiKTSv9YKoRDl
         fEKsSfWsXaBbnLJiF3MLNDR7m+P/vyC5ql5TAM3hxP9uUdTTx6K99PT/p5CQRMxK1L
         1dHI/7+jH9fdA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-parisc@vger.kernel.org
Subject: [PATCH net-next v3 07/31] tulip: use ndo_siocdevprivate
Date:   Tue, 27 Jul 2021 15:44:53 +0200
Message-Id: <20210727134517.1384504-8-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The tulip driver has a debugging method over ioctl built-in, but it
does not actually check the command type, which may end up leading
to random behavior when trying to run other ioctls on it.

Change the driver to use ndo_siocdevprivate and limit the execution
further to the first private command code. If anyone still has tools
to run these debugging commands, they might have to be patched for
it if they pass different ioctl command.

The function has existed in this form since the driver was merged in
Linux-1.1.86.

Cc: linux-parisc@vger.kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/dec/tulip/de4x5.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c b/drivers/net/ethernet/dec/tulip/de4x5.c
index b125d7faefdf..36ab4cbf2ad0 100644
--- a/drivers/net/ethernet/dec/tulip/de4x5.c
+++ b/drivers/net/ethernet/dec/tulip/de4x5.c
@@ -443,6 +443,7 @@
     =========================================================================
 */
 
+#include <linux/compat.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
@@ -902,7 +903,8 @@ static int     de4x5_close(struct net_device *dev);
 static struct  net_device_stats *de4x5_get_stats(struct net_device *dev);
 static void    de4x5_local_stats(struct net_device *dev, char *buf, int pkt_len);
 static void    set_multicast_list(struct net_device *dev);
-static int     de4x5_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
+static int     de4x5_siocdevprivate(struct net_device *dev, struct ifreq *rq,
+				    void __user *data, int cmd);
 
 /*
 ** Private functions
@@ -1084,7 +1086,7 @@ static const struct net_device_ops de4x5_netdev_ops = {
     .ndo_start_xmit	= de4x5_queue_pkt,
     .ndo_get_stats	= de4x5_get_stats,
     .ndo_set_rx_mode	= set_multicast_list,
-    .ndo_do_ioctl	= de4x5_ioctl,
+    .ndo_siocdevprivate	= de4x5_siocdevprivate,
     .ndo_set_mac_address= eth_mac_addr,
     .ndo_validate_addr	= eth_validate_addr,
 };
@@ -5357,7 +5359,7 @@ de4x5_dbg_rx(struct sk_buff *skb, int len)
 ** this function is only used for my testing.
 */
 static int
-de4x5_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
+de4x5_siocdevprivate(struct net_device *dev, struct ifreq *rq, void __user *data, int cmd)
 {
     struct de4x5_private *lp = netdev_priv(dev);
     struct de4x5_ioctl *ioc = (struct de4x5_ioctl *) &rq->ifr_ifru;
@@ -5371,6 +5373,9 @@ de4x5_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
     } tmp;
     u_long flags = 0;
 
+    if (cmd != SIOCDEVPRIVATE || in_compat_syscall())
+	return -EOPNOTSUPP;
+
     switch(ioc->cmd) {
     case DE4X5_GET_HWADDR:           /* Get the hardware address */
 	ioc->len = ETH_ALEN;
-- 
2.29.2

