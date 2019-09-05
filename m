Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6C7A9F83
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 12:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733120AbfIEKWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 06:22:11 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:57326 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730485AbfIEKWL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 06:22:11 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 9A4272057A;
        Thu,  5 Sep 2019 12:22:09 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id xWO0rDDjKDiu; Thu,  5 Sep 2019 12:22:09 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2E3D320080;
        Thu,  5 Sep 2019 12:22:09 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 5 Sep 2019
 12:22:07 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id C5CE5318270B;
 Thu,  5 Sep 2019 12:22:08 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 3/5] xfrm interface: fix list corruption for x-netns
Date:   Thu, 5 Sep 2019 12:21:59 +0200
Message-ID: <20190905102201.1636-4-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190905102201.1636-1-steffen.klassert@secunet.com>
References: <20190905102201.1636-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

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
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_interface.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 68336ee00d72..53e5e47b2c55 100644
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
2.17.1

