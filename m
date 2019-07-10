Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2D7646D6
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 15:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfGJNLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 09:11:40 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:45744 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfGJNLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 09:11:40 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id 9E14B2E4624;
        Wed, 10 Jul 2019 15:11:38 +0200 (CEST)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.89)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1hlCNm-0001GU-HP; Wed, 10 Jul 2019 15:11:38 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     steffen.klassert@secunet.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Julien Floret <julien.floret@6wind.com>
Subject: [PATCH ipsec] xfrm interface: fix list corruption for x-netns
Date:   Wed, 10 Jul 2019 15:11:37 +0200
Message-Id: <20190710131137.4787-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev_net(dev) is the netns of the device and xi->net is the link netns,
where the device has been linked.
changelink() must operate in the link netns to avoid a corruption of
the xfrm lists.

Note that xi->net and dev_net(xi->physdev) are always the same.

Before the patch, the xfrmi lists may be corrupted and can later trigger a
kernel panic.

Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Reported-by: Julien Floret <julien.floret@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Tested-by: Julien Floret <julien.floret@6wind.com>
---
 net/xfrm/xfrm_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index a60d391f7ebe..9c5bc8dcf608 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -503,7 +503,7 @@ static int xfrmi_change(struct xfrm_if *xi, const struct xfrm_if_parms *p)
 
 static int xfrmi_update(struct xfrm_if *xi, struct xfrm_if_parms *p)
 {
-	struct net *net = dev_net(xi->dev);
+	struct net *net = xi->net;
 	struct xfrmi_net *xfrmn = net_generic(net, xfrmi_net_id);
 	int err;
 
@@ -663,9 +663,9 @@ static int xfrmi_changelink(struct net_device *dev, struct nlattr *tb[],
 			   struct nlattr *data[],
 			   struct netlink_ext_ack *extack)
 {
-	struct net *net = dev_net(dev);
+	struct xfrm_if *xi = netdev_priv(dev);
+	struct net *net = xi->net;
 	struct xfrm_if_parms p;
-	struct xfrm_if *xi;
 
 	xfrmi_netlink_parms(data, &p);
 	xi = xfrmi_locate(net, &p);
@@ -707,7 +707,7 @@ static struct net *xfrmi_get_link_net(const struct net_device *dev)
 {
 	struct xfrm_if *xi = netdev_priv(dev);
 
-	return dev_net(xi->phydev);
+	return xi->net;
 }
 
 static const struct nla_policy xfrmi_policy[IFLA_XFRM_MAX + 1] = {
-- 
2.21.0

