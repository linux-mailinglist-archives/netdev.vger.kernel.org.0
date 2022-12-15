Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A788364D642
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 06:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiLOFtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 00:49:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLOFtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 00:49:43 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE22D36D71
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 21:49:42 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id 3B5ED20240; Thu, 15 Dec 2022 13:49:41 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeconstruct.com.au; s=2022a; t=1671083381;
        bh=PgzW3IvaH66DDAJp2H5pGnJEh+JC/DwoDS7M6YO7VJk=;
        h=From:To:Cc:Subject:Date;
        b=FLyFatFyt4py6g1VV09b/uPpkLxuigME02x4q44wwYHW49tPwGfR+dxgrubxFZVf8
         4guXfMLx2KmtR+/CWrzBLeDyGEp7oI2qTRpSwe7y/+a2YCknPQkA0in5XeS4hi0dbO
         0tNhhOO9RwzHlUsSdNkAWBg62rDRsvvTGHkTHBeSpLqUsfifYiRUXwibt/WrKftGXQ
         O5uiitL9R2GZ07tH36NHa6x5b5NL98XhAXRryCbrJNmD9aP2VhXzKIbdSa7/nHSDMA
         yICgSGs5RnGjSYJ3XWrS3Bj7olM0MFX3SDWh2Eou5cuX+mduWUaC8T7iVXiRnEP2k3
         GRlmrPHm7iPLw==
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        alexander.duyck@gmail.com
Subject: [PATCH net v2] mctp: Remove device type check at unregister
Date:   Thu, 15 Dec 2022 13:49:33 +0800
Message-Id: <20221215054933.2403401-1-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The unregister check could be incorrectly triggered if a netdev
changes its type after register. That is possible for a tun device
using TUNSETLINK ioctl, resulting in mctp unregister failing
and the netdev unregister waiting forever.

This was encountered by https://github.com/openthread/openthread/issues/8523

Neither check at register or unregister is required. They were added in
an attempt to track down mctp_ptr being set unexpectedly, which should
not happen in normal operation.

Fixes: 7b1871af75f3 ("mctp: Warn if pointer is set for a wrong dev type")
Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
---

v2: Also remove the check from register

 net/mctp/device.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/net/mctp/device.c b/net/mctp/device.c
index 99a3bda8852f..acb97b257428 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -429,12 +429,6 @@ static void mctp_unregister(struct net_device *dev)
 	struct mctp_dev *mdev;
 
 	mdev = mctp_dev_get_rtnl(dev);
-	if (mdev && !mctp_known(dev)) {
-		// Sanity check, should match what was set in mctp_register
-		netdev_warn(dev, "%s: BUG mctp_ptr set for unknown type %d",
-			    __func__, dev->type);
-		return;
-	}
 	if (!mdev)
 		return;
 
@@ -451,14 +445,8 @@ static int mctp_register(struct net_device *dev)
 	struct mctp_dev *mdev;
 
 	/* Already registered? */
-	mdev = rtnl_dereference(dev->mctp_ptr);
-
-	if (mdev) {
-		if (!mctp_known(dev))
-			netdev_warn(dev, "%s: BUG mctp_ptr set for unknown type %d",
-				    __func__, dev->type);
+	if (rtnl_dereference(dev->mctp_ptr))
 		return 0;
-	}
 
 	/* only register specific types */
 	if (!mctp_known(dev))
-- 
2.37.2

