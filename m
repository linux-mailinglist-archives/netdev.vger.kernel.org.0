Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2E63CFD68
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241130AbhGTOk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:40:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239525AbhGTOUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 10:20:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F31B06128A;
        Tue, 20 Jul 2021 14:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626792441;
        bh=kpHbOB2ACnJvk6XXUBuWOthVbzfT+czPTSvWCHQbRf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IWgFpSCzJathPKg+Zu+eEuyhFMrz/yk1TDuPeyVmH+KfQoAMbUlpmKU5B0XlaKY2h
         LAF2ZEDyxBqtD/sAPMbNdD4kBbUDcVCYA9ZFm2Lq4DMsdl0Dfe9sUta+ZKHOgX5xGc
         RP1Ea+63Y5hP2Afkgsa1wvuEDYuXZ+X/+P2KmcH9cfl5FjfR6bbSxQp5p3SGaRNZ8x
         C9RKWqzjKYUyJTa07uErBE58PTNn1MEGFCdR63A3cw4h6X57Nzmwm1+IYmG1/Fgds6
         XKFaj0IumIz7gdft5+/euU2vc3WPbsyaqZ88U8b7XSjw9amCAqe0AJaZK9KsTTwsN5
         ZRn+2p7bD/+Dw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v2 25/31] wan: cosa: remove dead cosa_net_ioctl() function
Date:   Tue, 20 Jul 2021 16:46:32 +0200
Message-Id: <20210720144638.2859828-26-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210720144638.2859828-1-arnd@kernel.org>
References: <20210720144638.2859828-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The ndo_do_ioctl callback is never called with the COSAIO* commands,
so this is never used. Call the hdlc_ioctl function directly instead.

Any user space code that relied on this function working as intended
has never worked in a mainline kernel since before linux-1.0.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wan/cosa.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index 43caab0b7dee..4c0e9cf02217 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -267,7 +267,6 @@ static netdev_tx_t cosa_net_tx(struct sk_buff *skb, struct net_device *d);
 static char *cosa_net_setup_rx(struct channel_data *channel, int size);
 static int cosa_net_rx_done(struct channel_data *channel);
 static int cosa_net_tx_done(struct channel_data *channel, int size);
-static int cosa_net_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
 
 /* Character device */
 static char *chrdev_setup_rx(struct channel_data *channel, int size);
@@ -415,7 +414,7 @@ static const struct net_device_ops cosa_ops = {
 	.ndo_open       = cosa_net_open,
 	.ndo_stop       = cosa_net_close,
 	.ndo_start_xmit = hdlc_start_xmit,
-	.ndo_do_ioctl   = cosa_net_ioctl,
+	.ndo_do_ioctl   = hdlc_ioctl,
 	.ndo_tx_timeout = cosa_net_timeout,
 };
 
@@ -1169,18 +1168,6 @@ static int cosa_ioctl_common(struct cosa_data *cosa,
 	return -ENOIOCTLCMD;
 }
 
-static int cosa_net_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
-{
-	int rv;
-	struct channel_data *chan = dev_to_chan(dev);
-
-	rv = cosa_ioctl_common(chan->cosa, chan, cmd,
-			       (unsigned long)ifr->ifr_data);
-	if (rv != -ENOIOCTLCMD)
-		return rv;
-	return hdlc_ioctl(dev, ifr, cmd);
-}
-
 static long cosa_chardev_ioctl(struct file *file, unsigned int cmd,
 			       unsigned long arg)
 {
-- 
2.29.2

