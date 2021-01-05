Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40822EB355
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 20:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730836AbhAETIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 14:08:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:35690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730823AbhAETIO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 14:08:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 505DA22D6E;
        Tue,  5 Jan 2021 19:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609873653;
        bh=IALGxI08WzJXoFFd/12vBKzY/wDhWcY7vODGe/Z4c4g=;
        h=From:To:Cc:Subject:Date:From;
        b=fXrXHDDEeGMqOEkf62sqcZvdxGHAkfMfhMF1E2QHTJp6mOxykK/8okXDUaB2PuvO6
         nr7yHBIBhL+oH28CJc8eBow7LE/cWaVeS8QymTt6S2XIUdGrnrvwP79bkzpcpReTlr
         yn6NXCKMzpsREh7kS6HXwcM2ZL3338/2YEqWi7eNV9+fWWV3v12rgR/ufqWEduJxb+
         R6Jjk1QhD6DrePYFWPdRP3j/ZFPG67BRAVzMnMBdorZMMgnSH9O9ZvySJW6cS0iJxh
         ukzHPzjRKQkOFg73+aql4vdi1PoXeRogJ5EZQhD/XopCWBXFXKOPFKEB6aNnEp3HU5
         g69dAqTwAjdvw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, martin.varghese@nokia.com,
        willemb@google.com, xiyou.wangcong@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2] net: bareudp: add missing error handling for bareudp_link_config()
Date:   Tue,  5 Jan 2021 11:07:25 -0800
Message-Id: <20210105190725.1736246-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

.dellink does not get called after .newlink fails,
bareudp_newlink() must undo what bareudp_configure()
has done if bareudp_link_config() fails.

v2: call bareudp_dellink(), like bareudp_dev_create() does

Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/bareudp.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 708171c0d628..85de5f96c02b 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -645,11 +645,20 @@ static int bareudp_link_config(struct net_device *dev,
 	return 0;
 }
 
+static void bareudp_dellink(struct net_device *dev, struct list_head *head)
+{
+	struct bareudp_dev *bareudp = netdev_priv(dev);
+
+	list_del(&bareudp->next);
+	unregister_netdevice_queue(dev, head);
+}
+
 static int bareudp_newlink(struct net *net, struct net_device *dev,
 			   struct nlattr *tb[], struct nlattr *data[],
 			   struct netlink_ext_ack *extack)
 {
 	struct bareudp_conf conf;
+	LIST_HEAD(list_kill);
 	int err;
 
 	err = bareudp2info(data, &conf, extack);
@@ -662,17 +671,14 @@ static int bareudp_newlink(struct net *net, struct net_device *dev,
 
 	err = bareudp_link_config(dev, tb);
 	if (err)
-		return err;
+		goto err_unconfig;
 
 	return 0;
-}
-
-static void bareudp_dellink(struct net_device *dev, struct list_head *head)
-{
-	struct bareudp_dev *bareudp = netdev_priv(dev);
 
-	list_del(&bareudp->next);
-	unregister_netdevice_queue(dev, head);
+err_unconfig:
+	bareudp_dellink(dev, &list_kill);
+	unregister_netdevice_many(&list_kill);
+	return err;
 }
 
 static size_t bareudp_get_size(const struct net_device *dev)
-- 
2.26.2

