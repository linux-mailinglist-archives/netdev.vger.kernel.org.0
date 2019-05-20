Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 580E423BCD
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 17:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732343AbfETPPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 11:15:47 -0400
Received: from gateway20.websitewelcome.com ([192.185.65.13]:16538 "EHLO
        gateway20.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730475AbfETPPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 11:15:47 -0400
X-Greylist: delayed 1479 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 May 2019 11:15:46 EDT
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway20.websitewelcome.com (Postfix) with ESMTP id 1E54C400C44D8
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 09:51:07 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id Sjd5hBfjy90onSjd5hGRWA; Mon, 20 May 2019 09:51:07 -0500
X-Authority-Reason: nr=8
Received: from [189.250.71.100] (port=39276 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hSjd4-000gNU-6v; Mon, 20 May 2019 09:51:06 -0500
Date:   Mon, 20 May 2019 09:51:05 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH net-next] vlan: Mark expected switch fall-through
Message-ID: <20190520145105.GA6549@embeddedor>
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
X-Exim-ID: 1hSjd4-000gNU-6v
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.71.100]:39276
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 17
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch
cases where we are expecting to fall through.

This patch fixes the following warning:

net/8021q/vlan_dev.c: In function ‘vlan_dev_ioctl’:
net/8021q/vlan_dev.c:374:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
   if (!net_eq(dev_net(dev), &init_net))
      ^
net/8021q/vlan_dev.c:376:2: note: here
  case SIOCGMIIPHY:
  ^~~~

Warning level 3 was used: -Wimplicit-fallthrough=3

This patch is part of the ongoing efforts to enable
-Wimplicit-fallthrough.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 net/8021q/vlan_dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 2a9a60733594..c546c4228075 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -373,6 +373,7 @@ static int vlan_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	case SIOCSHWTSTAMP:
 		if (!net_eq(dev_net(dev), &init_net))
 			break;
+		/* fall through */
 	case SIOCGMIIPHY:
 	case SIOCGMIIREG:
 	case SIOCSMIIREG:
-- 
2.21.0

