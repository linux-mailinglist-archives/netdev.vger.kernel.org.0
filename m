Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2202F3D7758
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237161AbhG0NrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:47:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237154AbhG0Nqt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:46:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B0A961AAA;
        Tue, 27 Jul 2021 13:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393603;
        bh=igl5sTn80aTfHONV/lSrGXvxVew4hUjDcxxzAbMcnto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hH20wxAClyBMroZmsggUj+6wwGbc/kR7k35MOdKq5wy2AzRM6A3P9meC/N3LywSFn
         je1mi2yIJBot5cOehH3Ya4oRU1KRbrBwQ242nddWbPSIao9bKlc5Wa867tuSwxrvuy
         S2cnNR33xBMqUtTUjs3BjdGvT8xUB2Qibjq92NfvLGxBoPCzlmH1ZY2V0bOSAJt0Sk
         GRny1Xz5+cFi3klGxE+QBHIGKxsK4nfMpBWvxiiQVe9Bh/Jj1368bv+tQPAYvhXG0P
         Li0C7KyVkabMGSWpZZ8LULVHuwD5DpGkixlExxTPpowz1dZ76D3rnB/faXwrf+jLdG
         G3mHjfcQegaLg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v3 25/31] wan: cosa: remove dead cosa_net_ioctl() function
Date:   Tue, 27 Jul 2021 15:45:11 +0200
Message-Id: <20210727134517.1384504-26-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org>
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

Cc: "Jan \"Yenya\" Kasprzak" <kas@fi.muni.cz>
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

