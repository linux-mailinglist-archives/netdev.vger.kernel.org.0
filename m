Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACCD2F0C88
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 06:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbhAKFaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 00:30:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:59926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727318AbhAKFaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 00:30:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 792FE205CA;
        Mon, 11 Jan 2021 05:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610342965;
        bh=lT0mE6zUP2JCRzk7Tbif9MVc+fQ7Vwc8qCFUsdeDwIE=;
        h=From:To:Cc:Subject:Date:From;
        b=aI0+1G16rCp+Qr92kf+fTguGKwzCnAZfNF2p4pHcxeDLhNXMS2Euvq9sVeSI3rPlQ
         sMlh5Up95udcFntI6EZFi0KjqnBTryvzjatEU0O4tBYF+5kRhGEsWuHldvtrzpt34K
         txZ4cnnrHZIV5ecDWzZuQ6fxqn31iPhPitYrwGIQxbDrxLWRuF1AJHoEu74F2WsUcM
         cCvC5KTi8zX4yAxaUr3dK/A3ZHWoE/i2QDiLosIujMbP5aRb8xw0d/3jqAPDJpfuIy
         m9VMZpUg6hgE8ik5+VN3zkbePdw/uy7W4vR3T3s7CBStv/cTJqJaUtg5IhIuRxuQYv
         7oGsjVb8R2eZw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH net-next] net: bareudp: simplify error paths calling dellink
Date:   Sun, 10 Jan 2021 21:29:22 -0800
Message-Id: <20210111052922.2145003-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bareudp_dellink() only needs the device list to hand it to
unregister_netdevice_queue(). We can pass NULL in, and
unregister_netdevice_queue() will do the unregistering.
There is no chance for batching on the error path, anyway.

Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/bareudp.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 85de5f96c02b..0965d136def3 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -658,7 +658,6 @@ static int bareudp_newlink(struct net *net, struct net_device *dev,
 			   struct netlink_ext_ack *extack)
 {
 	struct bareudp_conf conf;
-	LIST_HEAD(list_kill);
 	int err;
 
 	err = bareudp2info(data, &conf, extack);
@@ -676,8 +675,7 @@ static int bareudp_newlink(struct net *net, struct net_device *dev,
 	return 0;
 
 err_unconfig:
-	bareudp_dellink(dev, &list_kill);
-	unregister_netdevice_many(&list_kill);
+	bareudp_dellink(dev, NULL);
 	return err;
 }
 
@@ -729,7 +727,6 @@ struct net_device *bareudp_dev_create(struct net *net, const char *name,
 {
 	struct nlattr *tb[IFLA_MAX + 1];
 	struct net_device *dev;
-	LIST_HEAD(list_kill);
 	int err;
 
 	memset(tb, 0, sizeof(tb));
@@ -753,8 +750,7 @@ struct net_device *bareudp_dev_create(struct net *net, const char *name,
 
 	return dev;
 err:
-	bareudp_dellink(dev, &list_kill);
-	unregister_netdevice_many(&list_kill);
+	bareudp_dellink(dev, NULL);
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(bareudp_dev_create);
-- 
2.26.2

