Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCCE2A9F87
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 12:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733192AbfIEKWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 06:22:18 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:57352 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730839AbfIEKWL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 06:22:11 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 7C8182053D;
        Thu,  5 Sep 2019 12:22:10 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id lUOMjMZrW_go; Thu,  5 Sep 2019 12:22:10 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8849020539;
        Thu,  5 Sep 2019 12:22:09 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 5 Sep 2019
 12:22:07 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id BBF3B31802BC;
 Thu,  5 Sep 2019 12:22:08 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/5] xfrm interface: avoid corruption on changelink
Date:   Thu, 5 Sep 2019 12:21:57 +0200
Message-ID: <20190905102201.1636-2-steffen.klassert@secunet.com>
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
index 74868f9d81fb..2310dc9e35c2 100644
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
2.17.1

