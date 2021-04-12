Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBA3735CE19
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244156AbhDLQmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:42:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344030AbhDLQge (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:36:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A92A8613E7;
        Mon, 12 Apr 2021 16:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244866;
        bh=3BsJZPvidZptNSMKyAvAy70rJ969almak4Ru9bdTfgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PqJ1uDXxpkfmR5uB1Ub3CszcBN0/Y7dXrF5Y5Zc6TDHQ1Ej+vtIhU+SOxzQDH022A
         +hGaiJAACOwVs2iH3vQ5j5Z+A2YM0tPsTvZ5dufUWVkrtwkbukqO4ooYxWXVtoiGjR
         O9qLmt1O/ET+x7XF5jJ3Q6Iys7a3sxazDZmiuxMc+TIQoBfIuCdKVPTO+ZrtmKS7F9
         HACqVLYNwGK+VocAQiHHy7dd2uwt2kOCPLs3WdG6PG2kTa/GwvC7xwf27QMTrSP9Lg
         y1lksCh0XY//0GOflEnrAV0DgVnZUTHSf/T4b7JoXx3en06zjy9r/2KC6ml/GuUOsN
         MIdHpMRQ0W1aA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+91adee8d9ebb9193d22d@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 07/23] drivers: net: fix memory leak in peak_usb_create_dev
Date:   Mon, 12 Apr 2021 12:27:20 -0400
Message-Id: <20210412162736.316026-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162736.316026-1-sashal@kernel.org>
References: <20210412162736.316026-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit a0b96b4a62745397aee662670cfc2157bac03f55 ]

syzbot reported memory leak in peak_usb.
The problem was in case of failure after calling
->dev_init()[2] in peak_usb_create_dev()[1]. The data
allocated int dev_init() wasn't freed, so simple
->dev_free() call fix this problem.

backtrace:
    [<0000000079d6542a>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000079d6542a>] kzalloc include/linux/slab.h:682 [inline]
    [<0000000079d6542a>] pcan_usb_fd_init+0x156/0x210 drivers/net/can/usb/peak_usb/pcan_usb_fd.c:868   [2]
    [<00000000c09f9057>] peak_usb_create_dev drivers/net/can/usb/peak_usb/pcan_usb_core.c:851 [inline] [1]
    [<00000000c09f9057>] peak_usb_probe+0x389/0x490 drivers/net/can/usb/peak_usb/pcan_usb_core.c:949

Reported-by: syzbot+91adee8d9ebb9193d22d@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
index 7b148174eb76..620db93ab9a3 100644
--- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
+++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
@@ -882,7 +882,7 @@ static int peak_usb_create_dev(const struct peak_usb_adapter *peak_usb_adapter,
 	if (dev->adapter->dev_set_bus) {
 		err = dev->adapter->dev_set_bus(dev, 0);
 		if (err)
-			goto lbl_unregister_candev;
+			goto adap_dev_free;
 	}
 
 	/* get device number early */
@@ -894,6 +894,10 @@ static int peak_usb_create_dev(const struct peak_usb_adapter *peak_usb_adapter,
 
 	return 0;
 
+adap_dev_free:
+	if (dev->adapter->dev_free)
+		dev->adapter->dev_free(dev);
+
 lbl_unregister_candev:
 	unregister_candev(netdev);
 
-- 
2.30.2

