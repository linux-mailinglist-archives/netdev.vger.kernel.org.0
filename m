Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77A29A25B6
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbfH2SOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728017AbfH2SOg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 14:14:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF2D82339E;
        Thu, 29 Aug 2019 18:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102475;
        bh=tHvS5YS1DOGqMguSYYPBSc/FLkd8zsZcv5hHnimAuus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K0hTxa0YiKfnDK10Xz0YXCZqS9jfqFZHU5Aigzc9R+2G1ngBQuXqpHLduQSuDfiJe
         /P7qjvrmZ7BVQwwnhna2Sh5jDU9s4z58PK91V4loDzdNbZHKQ93WiVM4KImBnUn6Y7
         ftbD6L1HkWj6Z2RR3diWipBCsWLbvLT2wtCsJH48=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 39/76] lan78xx: Fix memory leaks
Date:   Thu, 29 Aug 2019 14:12:34 -0400
Message-Id: <20190829181311.7562-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
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
index 3d92ea6fcc02b..f033fee225a11 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3792,7 +3792,7 @@ static int lan78xx_probe(struct usb_interface *intf,
 	ret = register_netdev(netdev);
 	if (ret != 0) {
 		netif_err(dev, probe, netdev, "couldn't register the device\n");
-		goto out3;
+		goto out4;
 	}
 
 	usb_set_intfdata(intf, dev);
@@ -3807,12 +3807,14 @@ static int lan78xx_probe(struct usb_interface *intf,
 
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

