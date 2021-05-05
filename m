Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010F637422B
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234800AbhEEQpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:45:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235297AbhEEQnq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:43:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB0BD6191D;
        Wed,  5 May 2021 16:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232506;
        bh=7WpViuqZ6EgOhriC7BEQo/u8K3kpLSs86q0I2EDQRYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ivHwb4oHSABKMoZ+4PtBBbFUlMMvBi0LSXqK8AGMXUNgr6/DLRauf6bh4yGD1Bque
         QiiV7fm4WUdxIBrmTFyV9YgCID3B3MFhuhbaP0U/Hd+jeNrfHx9MRLEDaSRxDyrT9d
         7YoORNWo7qBLGkstawtAt1ftnLcsSAQHde94blpGXBKQpTMBZ+54eLjagC9yBPqTO7
         RPuMftZ5+5CVG+BMmmyBS6K6kypMtLdkCWOn7pQpPCYFRHy/OEsNHDmbpl0Tt05ozq
         vDL8CWZexuos9Hkr0Q+wg1mIRgsy3Ihb5sW6c0kni3zLGKlzJUasBIblHhxiJkcjc5
         XUxTsl7OX+Z+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Phillip Potter <phil@philpotter.co.uk>,
        syzbot+4993e4a0e237f1b53747@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 037/104] net: usb: ax88179_178a: initialize local variables before use
Date:   Wed,  5 May 2021 12:33:06 -0400
Message-Id: <20210505163413.3461611-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
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
index d650b39b6e5d..c1316718304d 100644
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

