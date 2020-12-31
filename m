Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E986F2E7DE4
	for <lists+netdev@lfdr.de>; Thu, 31 Dec 2020 04:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgLaDpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 22:45:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:35386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726322AbgLaDpA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 22:45:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2937420773;
        Thu, 31 Dec 2020 03:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609386260;
        bh=0ahKSndBRgVhdsF+mmKf7GX8wpzYRADeu1E3J5YCPYI=;
        h=From:To:Cc:Subject:Date:From;
        b=JnWsbm2kh0eEezer9hrNvYNnIvKH4jpvs4DhlmGsHgjo5i2J9aLR7fVCzqH05SEiG
         f7cA7AowGjB50JI+SBLZ4MJJ121eD/lYqVOBi+fbq25st1jUuC5sI/nQR4u8f/ZGpr
         BnugXsasFEnDAGNvmn+WTzVaQYf4y9gpMVIUtrnuOtkXT/Jr14dAuYPyBRkl+jPRyt
         HBm7Lc1cen/0n+HrhD8zzzGgcWvLDSSZkOsqh9HTbbzvav3zhfA491VDzxBeQaxQdu
         fkJGJ748gfABHwD7OtVr2jnOoOmuNVf8QnrG3diarwJbqYJVLaOgT51le1vpz3BXz1
         N4Ye24/Tw+XkA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, martin.varghese@nokia.com,
        willemb@google.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] net: bareudp: add missing error handling for bareudp_link_config()
Date:   Wed, 30 Dec 2020 19:44:17 -0800
Message-Id: <20201231034417.1570553-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

.dellink does not get called after .newlink fails,
bareudp_newlink() must undo what bareudp_configure()
has done if bareudp_link_config() fails.

Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
Found by code inspection and compile-tested only.

 drivers/net/bareudp.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 85ebd2b7e446..7a03a9059ccc 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -648,6 +648,7 @@ static int bareudp_newlink(struct net *net, struct net_device *dev,
 			   struct nlattr *tb[], struct nlattr *data[],
 			   struct netlink_ext_ack *extack)
 {
+	struct bareudp_dev *bareudp = netdev_priv(dev);
 	struct bareudp_conf conf;
 	int err;
 
@@ -661,9 +662,14 @@ static int bareudp_newlink(struct net *net, struct net_device *dev,
 
 	err = bareudp_link_config(dev, tb);
 	if (err)
-		return err;
+		goto err_unconfig;
 
 	return 0;
+
+err_unconfig:
+	list_del(&bareudp->next);
+	unregister_netdevice(dev);
+	return err;
 }
 
 static void bareudp_dellink(struct net_device *dev, struct list_head *head)
-- 
2.26.2

