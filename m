Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59AB239E83
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 13:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbfFHLsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 07:48:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728327AbfFHLst (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 07:48:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F960216F4;
        Sat,  8 Jun 2019 11:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994528;
        bh=lXuN8mCNif31KVLHs3KQAUUmnbqQjRxC3MQxOOhxHJc=;
        h=From:To:Cc:Subject:Date:From;
        b=LWLJYUGIVNvw+qTynb8pEiSSGbUFq9bPWmxtoxj+en2kJTKpsPeejXI9qVMpO50cJ
         PCYGZLOJMLT9n6ZYrkqvodX+G5FASIpgvQcsx4zWiSBOeR5q6p+gg8oeEUWhCKnqRU
         7b4F1TRGZNnWYgv5LpPvBLsnbK0ydkvBr7Sk2VOY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 01/13] mISDN: make sure device name is NUL terminated
Date:   Sat,  8 Jun 2019 07:48:33 -0400
Message-Id: <20190608114847.9973-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit ccfb62f27beb295103e9392462b20a6ed807d0ea ]

The user can change the device_name with the IMSETDEVNAME ioctl, but we
need to ensure that the user's name is NUL terminated.  Otherwise it
could result in a buffer overflow when we copy the name back to the user
with IMGETDEVINFO ioctl.

I also changed two strcpy() calls which handle the name to strscpy().
Hopefully, there aren't any other ways to create a too long name, but
it's nice to do this as a kernel hardening measure.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/mISDN/socket.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/mISDN/socket.c b/drivers/isdn/mISDN/socket.c
index 0d29b5a6356d..8cbb75d09a1d 100644
--- a/drivers/isdn/mISDN/socket.c
+++ b/drivers/isdn/mISDN/socket.c
@@ -394,7 +394,7 @@ data_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 			memcpy(di.channelmap, dev->channelmap,
 			       sizeof(di.channelmap));
 			di.nrbchan = dev->nrbchan;
-			strcpy(di.name, dev_name(&dev->dev));
+			strscpy(di.name, dev_name(&dev->dev), sizeof(di.name));
 			if (copy_to_user((void __user *)arg, &di, sizeof(di)))
 				err = -EFAULT;
 		} else
@@ -678,7 +678,7 @@ base_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 			memcpy(di.channelmap, dev->channelmap,
 			       sizeof(di.channelmap));
 			di.nrbchan = dev->nrbchan;
-			strcpy(di.name, dev_name(&dev->dev));
+			strscpy(di.name, dev_name(&dev->dev), sizeof(di.name));
 			if (copy_to_user((void __user *)arg, &di, sizeof(di)))
 				err = -EFAULT;
 		} else
@@ -692,6 +692,7 @@ base_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 			err = -EFAULT;
 			break;
 		}
+		dn.name[sizeof(dn.name) - 1] = '\0';
 		dev = get_mdevice(dn.id);
 		if (dev)
 			err = device_rename(&dev->dev, dn.name);
-- 
2.20.1

