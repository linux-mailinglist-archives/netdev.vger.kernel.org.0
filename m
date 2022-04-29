Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 922985141D5
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 07:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353978AbiD2FoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 01:44:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351285AbiD2Fnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 01:43:55 -0400
Received: from nksmu.kylinos.cn (mailgw.kylinos.cn [123.150.8.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B202443C5;
        Thu, 28 Apr 2022 22:40:35 -0700 (PDT)
X-UUID: c3c02fb9c0414ba5a3ce218f4eeae102-20220429
X-UUID: c3c02fb9c0414ba5a3ce218f4eeae102-20220429
Received: from cs2c.com.cn [(172.17.111.24)] by nksmu.kylinos.cn
        (envelope-from <jianghaoran@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 1245802876; Fri, 29 Apr 2022 13:38:55 +0800
X-ns-mid: postfix-626B7A4A-1199754140
Received: from localhost.localdomain (unknown [172.30.60.211])
        by cs2c.com.cn (NSMail) with ESMTPSA id 13F013844000;
        Fri, 29 Apr 2022 05:40:26 +0000 (UTC)
From:   jianghaoran <jianghaoran@kylinos.cn>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ipv6: Don't send rs packets to the interface of ARPHRD_TUNNEL
Date:   Fri, 29 Apr 2022 13:38:02 +0800
Message-Id: <20220429053802.246681-1-jianghaoran@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,T_SPF_PERMERROR,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ARPHRD_TUNNEL interface can't process rs packets
and will generate TX errors

ex:
ip tunnel add ethn mode ipip local 192.168.1.1 remote 192.168.1.2
ifconfig ethn x.x.x.x

ethn: flags=209<UP,POINTOPOINT,RUNNING,NOARP>  mtu 1480
	inet x.x.x.x  netmask 255.255.255.255  destination x.x.x.x
	inet6 fe80::5efe:ac1e:3cdb  prefixlen 64  scopeid 0x20<link>
	tunnel   txqueuelen 1000  (IPIP Tunnel)
	RX packets 0  bytes 0 (0.0 B)
	RX errors 0  dropped 0  overruns 0  frame 0
	TX packets 0  bytes 0 (0.0 B)
	TX errors 3  dropped 0 overruns 0  carrier 0  collisions 0

Signed-off-by: jianghaoran <jianghaoran@kylinos.cn>
---
 net/ipv6/addrconf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index b22504176588..c1039346a5de 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4201,7 +4201,8 @@ static void addrconf_dad_completed(struct inet6_ifaddr *ifp, bool bump_id,
 	send_rs = send_mld &&
 		  ipv6_accept_ra(ifp->idev) &&
 		  ifp->idev->cnf.rtr_solicits != 0 &&
-		  (dev->flags&IFF_LOOPBACK) == 0;
+		  (dev->flags & IFF_LOOPBACK) == 0 &&
+		  (dev->type != ARPHRD_TUNNEL);
 	read_unlock_bh(&ifp->idev->lock);
 
 	/* While dad is in progress mld report's source address is in6_addrany.
-- 
2.25.1

