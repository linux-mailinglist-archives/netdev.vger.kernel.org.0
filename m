Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFA58A24AE
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729836AbfH2SY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:24:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729537AbfH2SQQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 14:16:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECEAC23403;
        Thu, 29 Aug 2019 18:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102575;
        bh=SiranW8BmD8p0xcVsmm5TH1u4jivQdyNf4ld76TzPxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kID1kuwT//hUlSB1mkSlkFhoCdYGVSf68OlRnqHRlCLZScVehw+ay8H1/XeCBRrNi
         xmRj6DzFjqvOFOhtQtgh3RcMRyn253IT75zW3rRrnBBHrj2DcUMvq+/oJrCtvak3JX
         4EqSbQK7FvWZXTNjgpLLramWbedhl5OE/bmO3xHc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 21/45] lan78xx: Fix memory leaks
Date:   Thu, 29 Aug 2019 14:15:21 -0400
Message-Id: <20190829181547.8280-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181547.8280-1-sashal@kernel.org>
References: <20190829181547.8280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

[ Upstream commit b9cbf8a64865b50fd0f4a3915fa00ac7365cdf8f ]

In lan78xx_probe(), a new urb is allocated through usb_alloc_urb() and
saved to 'dev->urb_intr'. However, in the following execution, if an error
occurs, 'dev->urb_intr' is not deallocated, leading to memory leaks. To fix
this issue, invoke usb_free_urb() to free the allocated urb before
returning from the function.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 8d140495da79d..e20266bd209e2 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3799,7 +3799,7 @@ static int lan78xx_probe(struct usb_interface *intf,
 	ret = register_netdev(netdev);
 	if (ret != 0) {
 		netif_err(dev, probe, netdev, "couldn't register the device\n");
-		goto out3;
+		goto out4;
 	}
 
 	usb_set_intfdata(intf, dev);
@@ -3814,12 +3814,14 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	ret = lan78xx_phy_init(dev);
 	if (ret < 0)
-		goto out4;
+		goto out5;
 
 	return 0;
 
-out4:
+out5:
 	unregister_netdev(netdev);
+out4:
+	usb_free_urb(dev->urb_intr);
 out3:
 	lan78xx_unbind(dev, intf);
 out2:
-- 
2.20.1

