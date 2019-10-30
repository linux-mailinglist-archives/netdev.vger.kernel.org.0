Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2596DEA53F
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 22:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727231AbfJ3VND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 17:13:03 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:60360 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfJ3VNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 17:13:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=o8QfUcMnS8gUqdR9fcwA2U7OZTwxBYhfTAbhIYY+zu4=; b=Oqch6uLD557DcBUZjgvWwwMX4l
        Xe8fOdomS+HhHcCbKcIdk1C6JWUJeEoAiTL47GZFFbWIeTAOS+NrbZql1Vy1VRYb1a0UTHq7hDS40
        VPga50HTic0DuL3sDepHWITdnLB8Ln0qe/Z/rIuWvQGSa/a8htWX8Ow1bpobltTesY8+yDeV7FJFJ
        jzvU7sMRNXByvRbd4qM91DxiIMj3uQ4fRezQvwflh31XX82UJCaXaiDjlTgGSrZPmieLP1Tbnchiz
        9Bl0+0lTQoHDSfVYMMorsOJjW4duVTdpL+jN1dUJI9UTEHA6tr7v3FJI5tt3C7m/MfdAxi4FYKDFm
        8mthse8A==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPvH3-0007gs-Pf; Wed, 30 Oct 2019 21:13:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] net: sgi: ioc3-eth: fix setting NETIF_F_HIGHDMA
Date:   Wed, 30 Oct 2019 14:12:33 -0700
Message-Id: <20191030211233.30157-5-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030211233.30157-1-hch@lst.de>
References: <20191030211233.30157-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set NETIF_F_HIGHDMA together with the NETIF_F_IP_CSUM flag insted of
letting the second assignment overwrite it.  Probably doesn't matter
in practice as none of the systems a IOC3 is usually found in has
highmem to start with.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/net/ethernet/sgi/ioc3-eth.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index dc2e22652b55..1af68826810a 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -1192,8 +1192,6 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_disable;
 	}
 
-	dev->features |= NETIF_F_HIGHDMA;
-
 	err = pci_request_regions(pdev, "ioc3");
 	if (err)
 		goto out_free;
@@ -1274,7 +1272,7 @@ static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->netdev_ops		= &ioc3_netdev_ops;
 	dev->ethtool_ops	= &ioc3_ethtool_ops;
 	dev->hw_features	= NETIF_F_IP_CSUM | NETIF_F_RXCSUM;
-	dev->features		= NETIF_F_IP_CSUM;
+	dev->features		= NETIF_F_IP_CSUM | NETIF_F_HIGHDMA;
 
 	sw_physid1 = ioc3_mdio_read(dev, ip->mii.phy_id, MII_PHYSID1);
 	sw_physid2 = ioc3_mdio_read(dev, ip->mii.phy_id, MII_PHYSID2);
-- 
2.20.1

