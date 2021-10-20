Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52F0434F6E
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 17:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhJTP6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 11:58:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230511AbhJTP6k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 11:58:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 712446139F;
        Wed, 20 Oct 2021 15:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634745385;
        bh=GfGrwf4kjaLxVyd4skAbUqGtwx7PUtoQDFPKORH4wo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FVBQhmIuIwNsCL2mhhSC7WhgYc8zn5VIp5+iUkiDBOgOm6pICJFAZchO4Zpu7SPYa
         xKEu8CrwznVNHOG8mtCNQ2383DV7JaI+bxnA30YU6Ozu5Czrjd/D5+fxjgWVbwL9XS
         aUU57Itd4gl80YQTJc0ODul/0U2mbjBsXDmzymyovHsm+cgSTABSTq2FHxmTBAtGiw
         HK8lcpuiRnQ5/2ELMG1/idezDABFtLiO4FaDGq1YrGWPO6IO0Icqt5YCzj2ilN1pN6
         38uFa1olvh+xQdCXKas4pF9b2b+JWiF2hKuo7ugyGJnicOr36lnnYylzht/IuzVIMZ
         56gp54Y60iEVA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        bjorn@mork.no, linux-usb@vger.kernel.org
Subject: [PATCH net-next 03/12] net: qmi_wwan: use dev_addr_mod()
Date:   Wed, 20 Oct 2021 08:56:08 -0700
Message-Id: <20211020155617.1721694-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211020155617.1721694-1-kuba@kernel.org>
References: <20211020155617.1721694-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: bjorn@mork.no
CC: linux-usb@vger.kernel.org
---
 drivers/net/usb/qmi_wwan.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 33ada2c59952..86b814e99224 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -835,8 +835,11 @@ static int qmi_wwan_bind(struct usbnet *dev, struct usb_interface *intf)
 
 	/* make MAC addr easily distinguishable from an IP header */
 	if (possibly_iphdr(dev->net->dev_addr)) {
-		dev->net->dev_addr[0] |= 0x02;	/* set local assignment bit */
-		dev->net->dev_addr[0] &= 0xbf;	/* clear "IP" bit */
+		u8 addr = dev->net->dev_addr[0];
+
+		addr |= 0x02;	/* set local assignment bit */
+		addr &= 0xbf;	/* clear "IP" bit */
+		dev_addr_mod(dev->net, 0, &addr, 1);
 	}
 	dev->net->netdev_ops = &qmi_wwan_netdev_ops;
 	dev->net->sysfs_groups[0] = &qmi_wwan_sysfs_attr_group;
-- 
2.31.1

