Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6D9CF2950
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 09:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733233AbfKGIj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 03:39:56 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:37651 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbfKGIjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 03:39:55 -0500
Received: from mwalle01.sab.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id B744A23E3F;
        Thu,  7 Nov 2019 09:39:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1573115994;
        bh=QuQhB8wdh0x1ZHWe+cSTPwQhfauMSRqdlq6VCg3+s9E=;
        h=From:To:Cc:Subject:Date:From;
        b=sPHgpqOjexeZ0JcU8wzRcdq/7XmBVgvpvXe8birl1x107C6pzWyLVWzo+UTVl/nOZ
         C28YjU6GGeAsp/LxudF3AcRO8iZMJsqmUhj8+Zs+nMwQrB55KKI7sRInln+xMFSKHy
         /Fh4rGIOQZZhhy0v3TjCPpNs85PRQSD+5c9o1fh8=
From:   Michael Walle <michael@walle.cc>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH] enetc: add ioctl() support for PHY-related ops
Date:   Thu,  7 Nov 2019 09:39:37 +0100
Message-Id: <20191107083937.18228-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is an attached PHY try to handle the requested ioctl with its
handler, which allows the userspace to access PHY registers, for
example. This will make mii-diag and similar tools work.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index b6ff89307409..25af207f1962 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1599,7 +1599,10 @@ int enetc_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
 	if (cmd == SIOCGHWTSTAMP)
 		return enetc_hwtstamp_get(ndev, rq);
 #endif
-	return -EINVAL;
+
+	if (!ndev->phydev)
+		return -EINVAL;
+	return phy_mii_ioctl(ndev->phydev, rq, cmd);
 }
 
 int enetc_alloc_msix(struct enetc_ndev_priv *priv)
-- 
2.20.1

