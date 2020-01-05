Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 127421309FD
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 22:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbgAEVRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 16:17:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:50100 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727149AbgAEVRO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jan 2020 16:17:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 463D2B1AB;
        Sun,  5 Jan 2020 21:17:12 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id EE930E048B; Sun,  5 Jan 2020 22:17:11 +0100 (CET)
Message-Id: <146ace9856b8576eea83a1a5dc6329315831c44e.1578257976.git.mkubecek@suse.cz>
In-Reply-To: <cover.1578257976.git.mkubecek@suse.cz>
References: <cover.1578257976.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 3/3] epic100: allow nesting of ethtool_ops begin()
 and complete()
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Francois Romieu <romieu@fr.zoreil.com>,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Sun,  5 Jan 2020 22:17:11 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike most networking drivers using begin() and complete() ethtool_ops
callbacks to resume a device which is down and suspend it again when done,
epic100 does not use standard refcounted infrastructure but sets device
sleep state directly.

With the introduction of netlink ethtool interface, we may have nested
begin-complete blocks so that inner complete() would put the device back to
sleep for the rest of the outer block.

To avoid rewriting an old and not very actively developed driver, just add
a nesting counter and only perform resume and suspend on the outermost
level.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 drivers/net/ethernet/smsc/epic100.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/smsc/epic100.c b/drivers/net/ethernet/smsc/epic100.c
index 912760e8514c..b9915645412c 100644
--- a/drivers/net/ethernet/smsc/epic100.c
+++ b/drivers/net/ethernet/smsc/epic100.c
@@ -280,6 +280,7 @@ struct epic_private {
 	signed char phys[4];				/* MII device addresses. */
 	u16 advertising;					/* NWay media advertisement */
 	int mii_phy_cnt;
+	u32 ethtool_ops_nesting;
 	struct mii_if_info mii;
 	unsigned int tx_full:1;				/* The Tx queue is full. */
 	unsigned int default_port:4;		/* Last dev->if_port value. */
@@ -1435,8 +1436,10 @@ static int ethtool_begin(struct net_device *dev)
 	struct epic_private *ep = netdev_priv(dev);
 	void __iomem *ioaddr = ep->ioaddr;
 
+	if (ep->ethtool_ops_nesting == U32_MAX)
+		return -EBUSY;
 	/* power-up, if interface is down */
-	if (!netif_running(dev)) {
+	if (ep->ethtool_ops_nesting++ && !netif_running(dev)) {
 		ew32(GENCTL, 0x0200);
 		ew32(NVCTL, (er32(NVCTL) & ~0x003c) | 0x4800);
 	}
@@ -1449,7 +1452,7 @@ static void ethtool_complete(struct net_device *dev)
 	void __iomem *ioaddr = ep->ioaddr;
 
 	/* power-down, if interface is down */
-	if (!netif_running(dev)) {
+	if (!--ep->ethtool_ops_nesting && !netif_running(dev)) {
 		ew32(GENCTL, 0x0008);
 		ew32(NVCTL, (er32(NVCTL) & ~0x483c) | 0x0000);
 	}
-- 
2.24.1

