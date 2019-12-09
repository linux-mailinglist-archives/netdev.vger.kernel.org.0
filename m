Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0121116832
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 09:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbfLIIbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 03:31:11 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:36992 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727230AbfLIIbD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 03:31:03 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 754272026E;
        Mon,  9 Dec 2019 09:31:02 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gd-bggfExD9m; Mon,  9 Dec 2019 09:31:02 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id CE38D2008D;
        Mon,  9 Dec 2019 09:31:01 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Mon, 9 Dec 2019
 09:31:00 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 9B4D03180AED;
 Mon,  9 Dec 2019 09:31:00 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Greg KH <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: [PATCH stable v4.19 2/4] xfrm interface: avoid corruption on changelink
Date:   Mon, 9 Dec 2019 09:30:43 +0100
Message-ID: <20191209083045.20657-3-steffen.klassert@secunet.com>
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

commit e9e7e85d75f3731079ffd77c1a66f037aef04fe7 upstream

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
Tested-by: Julien Floret <julien.floret@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_interface.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index e1265fda3035..c811158b9f1c 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -674,12 +674,12 @@ static int xfrmi_changelink(struct net_device *dev, struct nlattr *tb[],
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
@@ -687,7 +687,7 @@ static int xfrmi_changelink(struct net_device *dev, struct nlattr *tb[],
 			return -EEXIST;
 	}
 
-	return xfrmi_update(xi, &xi->p);
+	return xfrmi_update(xi, &p);
 }
 
 static size_t xfrmi_get_size(const struct net_device *dev)
-- 
2.17.1

