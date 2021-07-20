Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2CD3CFDA5
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241753AbhGTOxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:53:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240179AbhGTO2q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 10:28:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2A7C61241;
        Tue, 20 Jul 2021 14:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626792420;
        bh=ffq2EmnnSYIsOdt3jn+/z20QSrWUCvGK3mFM0XQX+ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3MlPRu0cBLxae/emXsjtVmPa2V7fgym1jZ2J2NIVCMcnAIYfWtPdrxd4pgG7yGTd
         7uSmh2A4ieQP8aNQBCvuWKzvk2krgXTYLDKLXccdpIbrsFdglyi6v8fC+UW+GoBS5z
         Dk9Mnr04u+/oOnZVPe1xXcDpXwTA4x5A9R1IrXECPL78HhKMHrLG91pufcWaltOb8P
         iikJuPk7msHTB93VHjL07wjVOE0czindc/1rNU4n12GKuBSQpucCrW2Oq01MmoO0vm
         NlI0GHMdHk+BU3v7d4brszwv5wVe8mPYQEMRaj4+6HfwkPKJZH9aS+7rVh/5XjwSfX
         KNO7jFFaLLgrg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v2 07/31] tulip: use ndo_siocdevprivate
Date:   Tue, 20 Jul 2021 16:46:14 +0200
Message-Id: <20210720144638.2859828-8-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210720144638.2859828-1-arnd@kernel.org>
References: <20210720144638.2859828-1-arnd@kernel.org>
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

