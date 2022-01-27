Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13DFF49DD54
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234633AbiA0JIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:08:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49570 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiA0JIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 04:08:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A10EF61AF0
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 09:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F096C340E4;
        Thu, 27 Jan 2022 09:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643274526;
        bh=SCwAc00DwVNtRMoae2u6M46Q3mrZD38XuHdafoZlqf8=;
        h=From:To:Cc:Subject:Date:From;
        b=Yk6pQEVAIhfuun9wtEAjdZ7bx30c0KSBXDEDOXau6xygzzn7HjBUDBpiWOx3STFzi
         54FdFJ1FlTU8Gw8XrNeNH75KBFM+ho6WmQWwlepw5woVA906tEVOHsQbaI1crRX18w
         nf3noweFRtW16kB85L1/sv7OgfET8bxn2ogNgzpA65d0XqggRdfA9QEGZXqZujZmfs
         bkQ75n2d5WhoxSJClyyp+ISHGmwDxEtJdCHObkFcydnP0501VdZ4dBvRyU2AUGUdtC
         SUNCpkZlYsgfgHUWpEduTXTQ79QzZwk1PFxCa2/2IOGxswKbnTMtAbgPk2l5Z7Xxqu
         3EwyHilWJN6DA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        Shannon Nelson <shannon.nelson@oracle.com>
Subject: [PATCH ipsec-next] xfrm: delete duplicated functions that calls same xfrm_api_check()
Date:   Thu, 27 Jan 2022 11:08:40 +0200
Message-Id: <5f9d6820e0548cb3304cbb49bcb84bedb15d7403.1643274380.git.leonro@nvidia.com>
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

Fixes: 92a2320697f7 ("xfrm: check for xdo_dev_ops add and delete")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
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

