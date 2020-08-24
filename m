Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410DD2505E0
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 19:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgHXRWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 13:22:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727937AbgHXQfs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 12:35:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C76022C9F;
        Mon, 24 Aug 2020 16:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598286948;
        bh=MCxPakGL9ABd29OvlEbGaratiOtRqPYeKeb2GiLmDas=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aiyy2/O8nlIvYRTnXuz3JB4k8JaR2i/IMtJIxYoUWcKqV2Kk88ksQZHku/zEpGJa6
         ARXFYneRGr9LLan5fsDpTy0Gsdg0MYZNGEdverShA++jpUDVywuVlfAthL3oUGGwLx
         c9JhX+q8/i9N5UV31IEQaThoEI5izwhuMfE3t8iE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Martin Schiller <ms@dev.tdt.de>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 32/63] drivers/net/wan/hdlc_x25: Added needed_headroom and a skb->len check
Date:   Mon, 24 Aug 2020 12:34:32 -0400
Message-Id: <20200824163504.605538-32-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163504.605538-1-sashal@kernel.org>
References: <20200824163504.605538-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

[ Upstream commit 77b981c82c1df7c7ad32a046f17f007450b46954 ]

1. Added a skb->len check

This driver expects upper layers to include a pseudo header of 1 byte
when passing down a skb for transmission. This driver will read this
1-byte header. This patch added a skb->len check before reading the
header to make sure the header exists.

2. Added needed_headroom and set hard_header_len to 0

When this driver transmits data,
  first this driver will remove a pseudo header of 1 byte,
  then the lapb module will prepend the LAPB header of 2 or 3 bytes.
So the value of needed_headroom in this driver should be 3 - 1.

Because this driver has no header_ops, according to the logic of
af_packet.c, the value of hard_header_len should be 0.

Reason of setting needed_headroom and hard_header_len at this place:

This driver is written using the API of the hdlc module, the hdlc
module enables this driver (the protocol driver) to run on any hardware
that has a driver (the hardware driver) written using the API of the
hdlc module.

Two other hdlc protocol drivers - hdlc_ppp and hdlc_raw_eth, also set
things like hard_header_len at this place. In hdlc_ppp, it sets
hard_header_len after attach_hdlc_protocol and before setting dev->type.
In hdlc_raw_eth, it sets hard_header_len by calling ether_setup after
attach_hdlc_protocol and after memcpy the settings.

3. Reset needed_headroom when detaching protocols (in hdlc.c)

When detaching a protocol from a hardware device, the hdlc module will
reset various parameters of the device (including hard_header_len) to
the default values. We add needed_headroom here so that needed_headroom
will also be reset.

Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Martin Schiller <ms@dev.tdt.de>
Cc: Andrew Hendry <andrew.hendry@gmail.com>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/hdlc.c     |  1 +
 drivers/net/wan/hdlc_x25.c | 17 ++++++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/hdlc.c b/drivers/net/wan/hdlc.c
index dfc16770458d8..386ed2aa31fd9 100644
--- a/drivers/net/wan/hdlc.c
+++ b/drivers/net/wan/hdlc.c
@@ -230,6 +230,7 @@ static void hdlc_setup_dev(struct net_device *dev)
 	dev->max_mtu		 = HDLC_MAX_MTU;
 	dev->type		 = ARPHRD_RAWHDLC;
 	dev->hard_header_len	 = 16;
+	dev->needed_headroom	 = 0;
 	dev->addr_len		 = 0;
 	dev->header_ops		 = &hdlc_null_ops;
 }
diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index f70336bb6f524..f52b9fed05931 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -107,8 +107,14 @@ static netdev_tx_t x25_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	int result;
 
+	/* There should be a pseudo header of 1 byte added by upper layers.
+	 * Check to make sure it is there before reading it.
+	 */
+	if (skb->len < 1) {
+		kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
 
-	/* X.25 to LAPB */
 	switch (skb->data[0]) {
 	case X25_IFACE_DATA:	/* Data to be transmitted */
 		skb_pull(skb, 1);
@@ -294,6 +300,15 @@ static int x25_ioctl(struct net_device *dev, struct ifreq *ifr)
 			return result;
 
 		memcpy(&state(hdlc)->settings, &new_settings, size);
+
+		/* There's no header_ops so hard_header_len should be 0. */
+		dev->hard_header_len = 0;
+		/* When transmitting data:
+		 * first we'll remove a pseudo header of 1 byte,
+		 * then we'll prepend an LAPB header of at most 3 bytes.
+		 */
+		dev->needed_headroom = 3 - 1;
+
 		dev->type = ARPHRD_X25;
 		call_netdevice_notifiers(NETDEV_POST_TYPE_CHANGE, dev);
 		netif_dormant_off(dev);
-- 
2.25.1

