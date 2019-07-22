Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC836FA83
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 09:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbfGVHlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 03:41:53 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46799 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725888AbfGVHlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 03:41:53 -0400
Received: by mail-pf1-f194.google.com with SMTP id c73so16957778pfb.13;
        Mon, 22 Jul 2019 00:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bgk59hNZZxqJ+wHkif44Odgi7FpW/CEYdnQcMyiPlt4=;
        b=D2mcfnGkowNh48/IuGfMW8WPzrt6h9BmpFV+lBdSjOWegSjyooyEPn91oei1VIOdI4
         pu8uZsIXIPSdCS2VJQVzuGO3d1LlPdNYay78ln2JYX1r+6gOvA9BP34Vtjur+xLeFugc
         B+r9Id9870AgDuSik6U+JFQ1AG7lf88DIb/HHlnsOqvYtM6MO2LEk3XAuqDPakv+FGNz
         okRGhZAy+l4wKrekxWO5vEh/b3I+ySVhT6w6IVbPwtYcPg3n4m0/e3mrJSGxIdHDac6t
         43pG9L5hQnsh+zeLJG0nX4qBP0J3D38Et4Tj0fUNUBycaAvS53RE4ON/mhxHHBOOILx4
         yZSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bgk59hNZZxqJ+wHkif44Odgi7FpW/CEYdnQcMyiPlt4=;
        b=rdDHhe2sVeyKnpOZkjWnCaTvmaIbW3pJ9onVg8Pi5rUPZqASRInqrLoXAHl1gNm5X/
         n7R4x4vxYDJG60MPJ6M+pyCd4v9+y3ziCKeasE3W0hP7xdFwKKBaXsGD+hxe+svQVDUc
         87AsdyA17Efc1rUoJu62fz6WjcCzqU0GTWKe/WGYDNM9aevwddrSCQ+R15wNULc6Exe5
         SeuZDTsUDV4ZXYaf4bg7DOGoDexSDrvJhMpa46TzlkHsT3eG+H4g/TpLOH9fUU+5qTrF
         /tdOa8bv4vwXsrrMTYkj6Dg00kLzc4Fg97el9PRtS+CxEakhoXj2tuvXCOt/eXo47Bih
         +N9g==
X-Gm-Message-State: APjAAAWSAM4GXGQUmktT5T/nYHupVExxIX90vRFEuTf4oQN8xmC7Tp/U
        aVdE4HceIcRX0aNeZUj+EOQ=
X-Google-Smtp-Source: APXvYqwSl/uh7SK95eO77VgmSxhQzE+J0u32oeQkDxloK2R4qZUtuWy4yljaXZQdizuxy7TXCmPd6w==
X-Received: by 2002:a17:90b:8e:: with SMTP id bb14mr75943756pjb.19.1563781312423;
        Mon, 22 Jul 2019 00:41:52 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([89.31.126.54])
        by smtp.gmail.com with ESMTPSA id c130sm36877577pfc.184.2019.07.22.00.41.49
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 00:41:51 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] net: usb: Merge cpu_to_le32s + memcpy to put_unaligned_le32
Date:   Mon, 22 Jul 2019 15:41:34 +0800
Message-Id: <20190722074133.17777-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Merge the combo uses of cpu_to_le32s and memcpy.
Use put_unaligned_le32 instead.
This simplifies the code.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/net/usb/asix_common.c  |  9 ++++-----
 drivers/net/usb/ax88179_178a.c | 11 ++++-------
 drivers/net/usb/lan78xx.c      | 11 ++++-------
 drivers/net/usb/smsc75xx.c     | 11 ++++-------
 drivers/net/usb/sr9800.c       |  9 ++++-----
 5 files changed, 20 insertions(+), 31 deletions(-)

diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
index b39ee714fb01..e39f41efda3e 100644
--- a/drivers/net/usb/asix_common.c
+++ b/drivers/net/usb/asix_common.c
@@ -221,6 +221,7 @@ struct sk_buff *asix_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 	int tailroom = skb_tailroom(skb);
 	u32 packet_len;
 	u32 padbytes = 0xffff0000;
+	void *ptr;
 
 	padlen = ((skb->len + 4) & (dev->maxpacket - 1)) ? 0 : 4;
 
@@ -256,13 +257,11 @@ struct sk_buff *asix_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 	}
 
 	packet_len = ((skb->len ^ 0x0000ffff) << 16) + skb->len;
-	skb_push(skb, 4);
-	cpu_to_le32s(&packet_len);
-	skb_copy_to_linear_data(skb, &packet_len, sizeof(packet_len));
+	ptr = skb_push(skb, 4);
+	put_unaligned_le32(packet_len, ptr);
 
 	if (padlen) {
-		cpu_to_le32s(&padbytes);
-		memcpy(skb_tail_pointer(skb), &padbytes, sizeof(padbytes));
+		put_unaligned_le32(padbytes, skb_tail_pointer(skb));
 		skb_put(skb, sizeof(padbytes));
 	}
 
diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 72d165114b67..daa54486ab09 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1421,6 +1421,7 @@ ax88179_tx_fixup(struct usbnet *dev, struct sk_buff *skb, gfp_t flags)
 	int frame_size = dev->maxpacket;
 	int mss = skb_shinfo(skb)->gso_size;
 	int headroom;
+	void *ptr;
 
 	tx_hdr1 = skb->len;
 	tx_hdr2 = mss;
@@ -1435,13 +1436,9 @@ ax88179_tx_fixup(struct usbnet *dev, struct sk_buff *skb, gfp_t flags)
 		return NULL;
 	}
 
-	skb_push(skb, 4);
-	cpu_to_le32s(&tx_hdr2);
-	skb_copy_to_linear_data(skb, &tx_hdr2, 4);
-
-	skb_push(skb, 4);
-	cpu_to_le32s(&tx_hdr1);
-	skb_copy_to_linear_data(skb, &tx_hdr1, 4);
+	ptr = skb_push(skb, 8);
+	put_unaligned_le32(tx_hdr1, ptr);
+	put_unaligned_le32(tx_hdr2, ptr + 4);
 
 	return skb;
 }
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 9c33b35bd155..769bb262fbec 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2729,6 +2729,7 @@ static struct sk_buff *lan78xx_tx_prep(struct lan78xx_net *dev,
 				       struct sk_buff *skb, gfp_t flags)
 {
 	u32 tx_cmd_a, tx_cmd_b;
+	void *ptr;
 
 	if (skb_cow_head(skb, TX_OVERHEAD)) {
 		dev_kfree_skb_any(skb);
@@ -2757,13 +2758,9 @@ static struct sk_buff *lan78xx_tx_prep(struct lan78xx_net *dev,
 		tx_cmd_b |= skb_vlan_tag_get(skb) & TX_CMD_B_VTAG_MASK_;
 	}
 
-	skb_push(skb, 4);
-	cpu_to_le32s(&tx_cmd_b);
-	memcpy(skb->data, &tx_cmd_b, 4);
-
-	skb_push(skb, 4);
-	cpu_to_le32s(&tx_cmd_a);
-	memcpy(skb->data, &tx_cmd_a, 4);
+	ptr = skb_push(skb, 8);
+	put_unaligned_le32(tx_cmd_a, ptr);
+	put_unaligned_le32(tx_cmd_b, ptr + 4);
 
 	return skb;
 }
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 7fac9db5380d..9556d431885f 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -2255,6 +2255,7 @@ static struct sk_buff *smsc75xx_tx_fixup(struct usbnet *dev,
 					 struct sk_buff *skb, gfp_t flags)
 {
 	u32 tx_cmd_a, tx_cmd_b;
+	void *ptr;
 
 	if (skb_cow_head(skb, SMSC75XX_TX_OVERHEAD)) {
 		dev_kfree_skb_any(skb);
@@ -2275,13 +2276,9 @@ static struct sk_buff *smsc75xx_tx_fixup(struct usbnet *dev,
 		tx_cmd_b = 0;
 	}
 
-	skb_push(skb, 4);
-	cpu_to_le32s(&tx_cmd_b);
-	memcpy(skb->data, &tx_cmd_b, 4);
-
-	skb_push(skb, 4);
-	cpu_to_le32s(&tx_cmd_a);
-	memcpy(skb->data, &tx_cmd_a, 4);
+	ptr = skb_push(skb, 8);
+	put_unaligned_le32(tx_cmd_a, ptr);
+	put_unaligned_le32(tx_cmd_b, ptr + 4);
 
 	return skb;
 }
diff --git a/drivers/net/usb/sr9800.c b/drivers/net/usb/sr9800.c
index 35f39f23d881..c5d4a0060124 100644
--- a/drivers/net/usb/sr9800.c
+++ b/drivers/net/usb/sr9800.c
@@ -115,6 +115,7 @@ static struct sk_buff *sr_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 	u32 padbytes = 0xffff0000;
 	u32 packet_len;
 	int padlen;
+	void *ptr;
 
 	padlen = ((skb->len + 4) % (dev->maxpacket - 1)) ? 0 : 4;
 
@@ -133,14 +134,12 @@ static struct sk_buff *sr_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 			return NULL;
 	}
 
-	skb_push(skb, 4);
+	ptr = skb_push(skb, 4);
 	packet_len = (((skb->len - 4) ^ 0x0000ffff) << 16) + (skb->len - 4);
-	cpu_to_le32s(&packet_len);
-	skb_copy_to_linear_data(skb, &packet_len, sizeof(packet_len));
+	put_unaligned_le32(packet_len, ptr);
 
 	if (padlen) {
-		cpu_to_le32s(&padbytes);
-		memcpy(skb_tail_pointer(skb), &padbytes, sizeof(padbytes));
+		put_unaligned_le32(padbytes, skb_tail_pointer(skb));
 		skb_put(skb, sizeof(padbytes));
 	}
 
-- 
2.20.1

