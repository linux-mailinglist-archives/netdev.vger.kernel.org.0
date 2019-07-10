Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1F4964304
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 09:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfGJHpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 03:45:43 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:44450 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbfGJHpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 03:45:42 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id 51D5A2E41CE;
        Wed, 10 Jul 2019 09:45:40 +0200 (CEST)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.89)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1hl7IK-0001yS-7D; Wed, 10 Jul 2019 09:45:40 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH ipsec 1/2] xfrm interface: avoid corruption on changelink
Date:   Wed, 10 Jul 2019 09:45:35 +0200
Message-Id: <20190710074536.7505-2-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190710074536.7505-1-nicolas.dichtel@6wind.com>
References: <20190710074536.7505-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new parameters must not be stored in the netdev_priv() before
validation, it may corrupt the interface. Note also that if data is NULL,
only a memset() is done.

$ ip link add xfrm1 type xfrm dev lo if_id 1
$ ip link add xfrm2 type xfrm dev lo if_id 2
$ ip link set xfrm1 type xfrm dev lo if_id 2
RTNETLINK answers: File exists
$ ip -d link list dev xfrm1
5: xfrm1@lo: <NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/none 00:00:00:00:00:00 brd 00:00:00:00:00:00 promiscuity 0 minmtu 68 maxmtu 1500
    xfrm if_id 0x2 addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535

=> "if_id 0x2"

Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/xfrm/xfrm_interface.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 7dbe0c608df5..dfa5aebdec57 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -671,12 +671,12 @@ static int xfrmi_changelink(struct net_device *dev, struct nlattr *tb[],
 			   struct nlattr *data[],
 			   struct netlink_ext_ack *extack)
 {
-	struct xfrm_if *xi = netdev_priv(dev);
 	struct net *net = dev_net(dev);
+	struct xfrm_if_parms p;
+	struct xfrm_if *xi;
 
-	xfrmi_netlink_parms(data, &xi->p);
-
-	xi = xfrmi_locate(net, &xi->p);
+	xfrmi_netlink_parms(data, &p);
+	xi = xfrmi_locate(net, &p);
 	if (!xi) {
 		xi = netdev_priv(dev);
 	} else {
@@ -684,7 +684,7 @@ static int xfrmi_changelink(struct net_device *dev, struct nlattr *tb[],
 			return -EEXIST;
 	}
 
-	return xfrmi_update(xi, &xi->p);
+	return xfrmi_update(xi, &p);
 }
 
 static size_t xfrmi_get_size(const struct net_device *dev)
-- 
2.21.0

