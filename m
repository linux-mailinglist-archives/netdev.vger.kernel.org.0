Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC02D3743F2
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234773AbhEEQxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:53:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236710AbhEEQuc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:50:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5795B6196E;
        Wed,  5 May 2021 16:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232654;
        bh=ZKOYUMEs6clDsyPD7uJBUlTb4y69TTSqDeVdFnrADlk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JAPIJr7NCBrL1URBrAX3WZS9PIlIWqHbf+oD3SgdeCydHNk1zmR1IybiSjsvwDjQu
         QALbVbr1loPpRa5QKBuRpNh6huZEWrujrARktNIuFNq4pw/jxUD14avUH6D2Cx8wbX
         MFo4r0C0QNesMGxpyf+pZSgGHn3q2fu42j88sgbWmJV+QRR1nBIQYkSpqKXVoV2cqT
         r0bIrwWFJDT8xaGhFK/S7Vii3mxH6eyabV108KGhdq+Pbe5ZwB8qjy27VJ7UP+OFt5
         4ZK1VrcvnQkzS0ExRabtO7V3IpdIHd1Wm9o7c1+7ajtLXfTC0hOUjSzsb8e2XhStZo
         Xcx0+6c+uFmlw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Phillip Potter <phil@philpotter.co.uk>,
        syzbot+4993e4a0e237f1b53747@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 31/85] net: usb: ax88179_178a: initialize local variables before use
Date:   Wed,  5 May 2021 12:35:54 -0400
Message-Id: <20210505163648.3462507-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Phillip Potter <phil@philpotter.co.uk>

[ Upstream commit bd78980be1a68d14524c51c4b4170782fada622b ]

Use memset to initialize local array in drivers/net/usb/ax88179_178a.c, and
also set a local u16 and u32 variable to 0. Fixes a KMSAN found uninit-value bug
reported by syzbot at:
https://syzkaller.appspot.com/bug?id=00371c73c72f72487c1d0bfe0cc9d00de339d5aa

Reported-by: syzbot+4993e4a0e237f1b53747@syzkaller.appspotmail.com
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/ax88179_178a.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 5541f3faedbc..b77b0a33d697 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -296,12 +296,12 @@ static int ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 	int ret;
 
 	if (2 == size) {
-		u16 buf;
+		u16 buf = 0;
 		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf, 0);
 		le16_to_cpus(&buf);
 		*((u16 *)data) = buf;
 	} else if (4 == size) {
-		u32 buf;
+		u32 buf = 0;
 		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf, 0);
 		le32_to_cpus(&buf);
 		*((u32 *)data) = buf;
@@ -1296,6 +1296,8 @@ static void ax88179_get_mac_addr(struct usbnet *dev)
 {
 	u8 mac[ETH_ALEN];
 
+	memset(mac, 0, sizeof(mac));
+
 	/* Maybe the boot loader passed the MAC address via device tree */
 	if (!eth_platform_get_mac_address(&dev->udev->dev, mac)) {
 		netif_dbg(dev, ifup, dev->net,
-- 
2.30.2

