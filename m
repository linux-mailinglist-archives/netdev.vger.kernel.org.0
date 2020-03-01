Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7821174DD3
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 15:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgCAOqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 09:46:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:52912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726954AbgCAOqG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Mar 2020 09:46:06 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 636E724672;
        Sun,  1 Mar 2020 14:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583073966;
        bh=f+r8PymUviXgd8UvlOkP3P9v481IK/pllWMkZgxGV2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGXFmilUh6RK7jsSgNrGTF7/RGGxMXmF6d50W5Kr3HeC18Smasm17Cxj9YfE5GrCh
         g5ivcFJepafqo3sA4INZrvwUV6fGcIdOWBn8P9cfP6/YYj9HpUqIz3dXU3BJ/JmWWv
         goLTf9xjt8AEf6WH69p+dRAP9kdZ4Fm9WjakG75g=
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Subject: [PATCH net-next 21/23] net/freescale: Don't set zero if FW not-available in dpaa
Date:   Sun,  1 Mar 2020 16:44:54 +0200
Message-Id: <20200301144457.119795-22-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200301144457.119795-1-leon@kernel.org>
References: <20200301144457.119795-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Rely on ethtool to properly present the fact that FW is not
available for the dpaa driver.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
index 13ab669ca8b3..6aa1fa22cd04 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_ethtool.c
@@ -106,17 +106,8 @@ static int dpaa_set_link_ksettings(struct net_device *net_dev,
 static void dpaa_get_drvinfo(struct net_device *net_dev,
 			     struct ethtool_drvinfo *drvinfo)
 {
-	int len;
-
 	strlcpy(drvinfo->driver, KBUILD_MODNAME,
 		sizeof(drvinfo->driver));
-	len = snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
-		       "%X", 0);
-
-	if (len >= sizeof(drvinfo->fw_version)) {
-		/* Truncated output */
-		netdev_notice(net_dev, "snprintf() = %d\n", len);
-	}
 	strlcpy(drvinfo->bus_info, dev_name(net_dev->dev.parent->parent),
 		sizeof(drvinfo->bus_info));
 }
-- 
2.24.1

