Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8961523ABE
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 16:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392009AbfETOpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 10:45:30 -0400
Received: from gateway23.websitewelcome.com ([192.185.50.164]:49185 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2392006AbfETOp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 10:45:29 -0400
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 2301410724
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 09:45:29 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id SjXdhDKMK2qH7SjXdhSp7R; Mon, 20 May 2019 09:45:29 -0500
X-Authority-Reason: nr=8
Received: from [189.250.71.100] (port=38926 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hSjX0-000dKs-JW; Mon, 20 May 2019 09:45:28 -0500
Date:   Mon, 20 May 2019 09:44:49 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH net-next] macvlan: Mark expected switch fall-through
Message-ID: <20190520144449.GA4843@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.250.71.100
X-Source-L: No
X-Exim-ID: 1hSjX0-000dKs-JW
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.71.100]:38926
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 13
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch
cases where we are expecting to fall through.

This patch fixes the following warning:

drivers/net/macvlan.c: In function ‘macvlan_do_ioctl’:
drivers/net/macvlan.c:839:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
   if (!net_eq(dev_net(dev), &init_net))
      ^
drivers/net/macvlan.c:841:2: note: here
  case SIOCGHWTSTAMP:
  ^~~~

Warning level 3 was used: -Wimplicit-fallthrough=3

This patch is part of the ongoing efforts to enable
-Wimplicit-fallthrough.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/macvlan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 92efa93649f0..61550122b563 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -838,6 +838,7 @@ static int macvlan_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	case SIOCSHWTSTAMP:
 		if (!net_eq(dev_net(dev), &init_net))
 			break;
+		/* fall through */
 	case SIOCGHWTSTAMP:
 		if (netif_device_present(real_dev) && ops->ndo_do_ioctl)
 			err = ops->ndo_do_ioctl(real_dev, &ifrr, cmd);
-- 
2.21.0

