Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEFB28C045
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 21:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389934AbgJLTDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 15:03:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389111AbgJLTDE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 15:03:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 499DD20BED;
        Mon, 12 Oct 2020 19:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602529383;
        bh=VoG2Q+uPn83jjMZIAFrjMusN+OEJ9rV2uXrL2GMwtvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gmu1z8QPCXfG/V//yRJ+vxCqlYMLXkFmquYFoQ2t4bSAo9PLxMn1LBzii/XfXvlLu
         bJYoR+23wEuncmp8sUUO9uxyg0ivfpKd9DE9oAbUsPdlhoc/Jp2A8Jh4rR/VijWRYS
         ojQIdb9hU2rbOpiNsDxZQBdBusQkXiCr6J9SZFHk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        Petko Manolov <petkan@nucleusys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 18/24] net: usb: rtl8150: set random MAC address when set_ethernet_addr() fails
Date:   Mon, 12 Oct 2020 15:02:33 -0400
Message-Id: <20201012190239.3279198-18-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012190239.3279198-1-sashal@kernel.org>
References: <20201012190239.3279198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anant Thazhemadam <anant.thazhemadam@gmail.com>

[ Upstream commit f45a4248ea4cc13ed50618ff066849f9587226b2 ]

When get_registers() fails in set_ethernet_addr(),the uninitialized
value of node_id gets copied over as the address.
So, check the return value of get_registers().

If get_registers() executed successfully (i.e., it returns
sizeof(node_id)), copy over the MAC address using ether_addr_copy()
(instead of using memcpy()).

Else, if get_registers() failed instead, a randomly generated MAC
address is set as the MAC address instead.

Reported-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
Tested-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
Acked-by: Petko Manolov <petkan@nucleusys.com>
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/rtl8150.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index e7c630d375899..63a4da0b2d6dd 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -274,12 +274,20 @@ static int write_mii_word(rtl8150_t * dev, u8 phy, __u8 indx, u16 reg)
 		return 1;
 }
 
-static inline void set_ethernet_addr(rtl8150_t * dev)
+static void set_ethernet_addr(rtl8150_t *dev)
 {
-	u8 node_id[6];
+	u8 node_id[ETH_ALEN];
+	int ret;
+
+	ret = get_registers(dev, IDR, sizeof(node_id), node_id);
 
-	get_registers(dev, IDR, sizeof(node_id), node_id);
-	memcpy(dev->netdev->dev_addr, node_id, sizeof(node_id));
+	if (ret == sizeof(node_id)) {
+		ether_addr_copy(dev->netdev->dev_addr, node_id);
+	} else {
+		eth_hw_addr_random(dev->netdev);
+		netdev_notice(dev->netdev, "Assigned a random MAC address: %pM\n",
+			      dev->netdev->dev_addr);
+	}
 }
 
 static int rtl8150_set_mac_address(struct net_device *netdev, void *p)
-- 
2.25.1

