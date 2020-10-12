Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE2128C0F4
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 21:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389802AbgJLTHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 15:07:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390878AbgJLTD2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 15:03:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 442E421BE5;
        Mon, 12 Oct 2020 19:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602529408;
        bh=oExfZzcB/cB/TLYZPs0rtpwRF71fcM4e3u1D5ml+csQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBwKfi81ZDRPwqx6PrWy3IAWm8ck9Yvu5zOf8z0H0xf6gLywMF1JIRQmsOwFGUkAf
         jzBp6ZuHAentjjkZhuBsMHaOn4YMLQVjNh5LRDbV+Wg9lDOCd6oPb4XI2MLfDSLtUZ
         8xfBYS9hvTHDy75fv7K/KeQalLyBscAcTsoXFtHo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petko Manolov <petko.manolov@konsulko.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 11/15] net: usb: pegasus: Proper error handing when setting pegasus' MAC address
Date:   Mon, 12 Oct 2020 15:03:08 -0400
Message-Id: <20201012190313.3279397-11-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012190313.3279397-1-sashal@kernel.org>
References: <20201012190313.3279397-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petko Manolov <petko.manolov@konsulko.com>

[ Upstream commit f30e25a9d1b25ac8d40071c4dc2679ad0fcdc55a ]

v2:

If reading the MAC address from eeprom fail don't throw an error, use randomly
generated MAC instead.  Either way the adapter will soldier on and the return
type of set_ethernet_addr() can be reverted to void.

v1:

Fix a bug in set_ethernet_addr() which does not take into account possible
errors (or partial reads) returned by its helpers.  This can potentially lead to
writing random data into device's MAC address registers.

Signed-off-by: Petko Manolov <petko.manolov@konsulko.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/pegasus.c | 35 +++++++++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index f7d117d80cfbb..ffa7f5adeea3f 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -359,28 +359,47 @@ fail:
 }
 #endif				/* PEGASUS_WRITE_EEPROM */
 
-static inline void get_node_id(pegasus_t *pegasus, __u8 *id)
+static inline int get_node_id(pegasus_t *pegasus, u8 *id)
 {
-	int i;
-	__u16 w16;
+	int i, ret;
+	u16 w16;
 
 	for (i = 0; i < 3; i++) {
-		read_eprom_word(pegasus, i, &w16);
+		ret = read_eprom_word(pegasus, i, &w16);
+		if (ret < 0)
+			return ret;
 		((__le16 *) id)[i] = cpu_to_le16(w16);
 	}
+
+	return 0;
 }
 
 static void set_ethernet_addr(pegasus_t *pegasus)
 {
-	__u8 node_id[6];
+	int ret;
+	u8 node_id[6];
 
 	if (pegasus->features & PEGASUS_II) {
-		get_registers(pegasus, 0x10, sizeof(node_id), node_id);
+		ret = get_registers(pegasus, 0x10, sizeof(node_id), node_id);
+		if (ret < 0)
+			goto err;
 	} else {
-		get_node_id(pegasus, node_id);
-		set_registers(pegasus, EthID, sizeof(node_id), node_id);
+		ret = get_node_id(pegasus, node_id);
+		if (ret < 0)
+			goto err;
+		ret = set_registers(pegasus, EthID, sizeof(node_id), node_id);
+		if (ret < 0)
+			goto err;
 	}
+
 	memcpy(pegasus->net->dev_addr, node_id, sizeof(node_id));
+
+	return;
+err:
+	eth_hw_addr_random(pegasus->net);
+	dev_info(&pegasus->intf->dev, "software assigned MAC address.\n");
+
+	return;
 }
 
 static inline int reset_mac(pegasus_t *pegasus)
-- 
2.25.1

