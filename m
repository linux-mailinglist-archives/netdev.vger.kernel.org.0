Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23C4B11682C
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 09:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbfLIIbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 03:31:05 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:36968 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727228AbfLIIbD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 03:31:03 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 053D320582;
        Mon,  9 Dec 2019 09:31:02 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MihHp7eT6vhv; Mon,  9 Dec 2019 09:31:01 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 6E2E420185;
        Mon,  9 Dec 2019 09:31:01 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Mon, 9 Dec 2019
 09:31:00 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id A22DA3180AF2;
 Mon,  9 Dec 2019 09:31:00 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Greg KH <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: [PATCH stable v4.19 3/4] xfrm interface: fix list corruption for x-netns
Date:   Mon, 9 Dec 2019 09:30:44 +0100
Message-ID: <20191209083045.20657-4-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191209083045.20657-1-steffen.klassert@secunet.com>
References: <20191209083045.20657-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit c5d1030f23002430c2a336b2b629b9d6f72b3564 upstream

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
index c811158b9f1c..2ed779db8769 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -505,7 +505,7 @@ static int xfrmi_change(struct xfrm_if *xi, const struct xfrm_if_parms *p)
 
 static int xfrmi_update(struct xfrm_if *xi, struct xfrm_if_parms *p)
 {
-	struct net *net = dev_net(xi->dev);
+	struct net *net = xi->net;
 	struct xfrmi_net *xfrmn = net_generic(net, xfrmi_net_id);
 	int err;
 
@@ -674,9 +674,9 @@ static int xfrmi_changelink(struct net_device *dev, struct nlattr *tb[],
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
@@ -718,7 +718,7 @@ struct net *xfrmi_get_link_net(const struct net_device *dev)
 {
 	struct xfrm_if *xi = netdev_priv(dev);
 
-	return dev_net(xi->phydev);
+	return xi->net;
 }
 
 static const struct nla_policy xfrmi_policy[IFLA_XFRM_MAX + 1] = {
-- 
2.17.1

