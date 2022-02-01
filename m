Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F844A57D8
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 08:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235037AbiBAHfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 02:35:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40700 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234605AbiBAHfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 02:35:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8A40B829FF
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 07:35:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BACAFC340EB;
        Tue,  1 Feb 2022 07:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643700934;
        bh=zDY2Fm0X1sisLi3mk2AuiIN2Nd24pzj6qquJdy5App0=;
        h=From:To:Cc:Subject:Date:From;
        b=HOwNrTH3I9PTRwX664fTf/1Bjprw9bWvhImpp3rqZEfZxp1kTNXyBJiBfwKLaG71c
         vBegzcGnR593nbYWKcraOnLnS13noGAeUUMnoHiglgDb0sGmvzKaZRCPHXqQCDBYlG
         fRC3YSd06CaT8enfQbcS1DOXzwhIrQbevm7mFgHQzQpL6q8QWrgotG1kkXEBt7xno4
         cAExO09LjeeIk9Is88MgKNwxWZEoF2V1WPp91lDbtiSnxHZc6+nO/Dap6R6nfkss4g
         HpNcocfMf1oVFEpKAU5avlJCxZI+4CL9nUQDoVoj82jS/TCppBTL/7e2B+nvZ5Q1pz
         5UWkuJNIxicyg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        Shannon Nelson <shannon.nelson@oracle.com>
Subject: [PATCH ipsec-next v1] xfrm: delete duplicated functions that calls same xfrm_api_check()
Date:   Tue,  1 Feb 2022 09:35:28 +0200
Message-Id: <386b408e7a1b26b2c40719fe7c48902cd0000947.1643700764.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The xfrm_dev_register() and xfrm_dev_feat_change() have same
implementation of one call to xfrm_api_check(). Instead of doing such
indirection, call to xfrm_api_check() directly and delete duplicated
functions.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Changelog
v1: 
 * Removed Fixes line
v0: https://lore.kernel.org/all/5f9d6820e0548cb3304cbb49bcb84bedb15d7403.1643274380.git.leonro@nvidia.com
---
 net/xfrm/xfrm_device.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 3fa066419d37..36d6c1835844 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -380,16 +380,6 @@ static int xfrm_api_check(struct net_device *dev)
 	return NOTIFY_DONE;
 }
 
-static int xfrm_dev_register(struct net_device *dev)
-{
-	return xfrm_api_check(dev);
-}
-
-static int xfrm_dev_feat_change(struct net_device *dev)
-{
-	return xfrm_api_check(dev);
-}
-
 static int xfrm_dev_down(struct net_device *dev)
 {
 	if (dev->features & NETIF_F_HW_ESP)
@@ -404,10 +394,10 @@ static int xfrm_dev_event(struct notifier_block *this, unsigned long event, void
 
 	switch (event) {
 	case NETDEV_REGISTER:
-		return xfrm_dev_register(dev);
+		return xfrm_api_check(dev);
 
 	case NETDEV_FEAT_CHANGE:
-		return xfrm_dev_feat_change(dev);
+		return xfrm_api_check(dev);
 
 	case NETDEV_DOWN:
 	case NETDEV_UNREGISTER:
-- 
2.34.1

