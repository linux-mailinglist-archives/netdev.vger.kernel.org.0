Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2118A25B1
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbfH2SOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:14:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:56290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728949AbfH2SOk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 14:14:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4F8E2339E;
        Thu, 29 Aug 2019 18:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102479;
        bh=baCRx9JVUqRa9cCGCXJT1DbEF8aU4ZfGASvfIub9WjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WoUOBfx2QKCTHcSfolNg+8xu2tWLk5CKoi4vDznXY2bihR/kJHfXjE60vPWEd2wtP
         EMLA6qs4RSaYCmDx+whhdngvc+e2cPkgtm3nAyf/zoxeTUgAcVvxeM+r7/FtjVqdT6
         YtltlZJ5vZWYQWUkZzODvsw2BBnNg6yNjg3jLMzA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 41/76] cx82310_eth: fix a memory leak bug
Date:   Thu, 29 Aug 2019 14:12:36 -0400
Message-Id: <20190829181311.7562-41-sashal@kernel.org>
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

[ Upstream commit 1eca92eef18719027d394bf1a2d276f43e7cf886 ]

In cx82310_bind(), 'dev->partial_data' is allocated through kmalloc().
Then, the execution waits for the firmware to become ready. If the firmware
is not ready in time, the execution is terminated. However, the allocated
'dev->partial_data' is not deallocated on this path, leading to a memory
leak bug. To fix this issue, free 'dev->partial_data' before returning the
error.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cx82310_eth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/cx82310_eth.c b/drivers/net/usb/cx82310_eth.c
index 5519248a791eb..32b08b18e1208 100644
--- a/drivers/net/usb/cx82310_eth.c
+++ b/drivers/net/usb/cx82310_eth.c
@@ -163,7 +163,8 @@ static int cx82310_bind(struct usbnet *dev, struct usb_interface *intf)
 	}
 	if (!timeout) {
 		dev_err(&udev->dev, "firmware not ready in time\n");
-		return -ETIMEDOUT;
+		ret = -ETIMEDOUT;
+		goto err;
 	}
 
 	/* enable ethernet mode (?) */
-- 
2.20.1

