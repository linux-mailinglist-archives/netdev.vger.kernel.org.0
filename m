Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C118434E70
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728381AbfFDRJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:09:41 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45363 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728021AbfFDRII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:08:08 -0400
Received: by mail-wr1-f65.google.com with SMTP id f9so1917754wre.12;
        Tue, 04 Jun 2019 10:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EwNKLdhvHIZWuc2AMTf/Nh+UlcpRZAbzNWQ1cMFMEHc=;
        b=D8SAKmcMepeCU71WMObGfrZhdbyauHSxKeduE7juWpihIWzSd6OA85eGA9K/DQ/Pd0
         Npe8PVsQyuLR5d8mCbQkXJdLo7aT24ZIZfk0NoUOOQeRehO2YHTlq6HULDqV2fLilghq
         BrYIiJW2UDpUr+V8B5vNPqNr0FJzsHMOAq1UqnHfTZKHWHYQGw1P7ZIx9o7q+mZZtv2v
         /ADQhaCn74/YJ2cseCFUN0WXXszb7tmUEhVGCNIBBHDBYA/2vXrLGtjh5JVXBwpDxaMF
         7KE1LGBM7xIkOVT24rk6GXP5ZaUJSSgp9cP8FbzgEZSrf090Zld1+2JFS+H3MzsdzBgG
         yDEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EwNKLdhvHIZWuc2AMTf/Nh+UlcpRZAbzNWQ1cMFMEHc=;
        b=Gwe6+dtGvCvjtm7kFNAByddPDxbKUvTj2P3FvM9hHu3X7tLG14CagrDDEsw4JAWJEQ
         u+yWVWX1toVHDHn6rVLY7NSoP6jxMRuUPAwAaHuS9A9wHGFajdA3dWvFT4ZiCsPu1jVV
         4ndUF2gl+DwEEa0x/RwYDp2lBZu6zvufZLSg8jD0ZSMAQFCskh7Da8WuQf4oxp+Mcib/
         R/H+M2UniBqLKuaYzx1ilk+w7ZPNF4Q4278Oy15okE5aPx4kiq0mMrpP9fg1ZBzexsZQ
         zIctKuZXstFYHUgbiIngqj6RyLZZ9sb9DhtwhmwAYF6mOSECpe+4rQChca83vPy8oF83
         U+ig==
X-Gm-Message-State: APjAAAWikVEFdpi6TFrQEcCCMD3PZ0wYe1OgWAthcIqCefBXGYQgNeDt
        c56NYXZORCuNzdZaCtuJJpQ=
X-Google-Smtp-Source: APXvYqxQSPgeN5YppLz1uZK+S/fEyGTT26eYimJpLpaVw9f3fC98pvFz0tlfMXa0nKTBJ7UpBHzNaQ==
X-Received: by 2002:a5d:5186:: with SMTP id k6mr4630818wrv.30.1559668086642;
        Tue, 04 Jun 2019 10:08:06 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id f2sm19692218wme.12.2019.06.04.10.08.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:08:06 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 03/17] net: dsa: tag_8021q: Create helper function for removing VLAN header
Date:   Tue,  4 Jun 2019 20:07:42 +0300
Message-Id: <20190604170756.14338-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190604170756.14338-1-olteanv@gmail.com>
References: <20190604170756.14338-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This removes the existing implementation from tag_sja1105, which was
partially incorrect (it was not changing the MAC header offset, thereby
leaving it to point 4 bytes earlier than it should have).

This overwrites the VLAN tag by moving the Ethernet source and
destination MACs 4 bytes to the right. Then skb->data (assumed to be
pointing immediately after the EtherType) is temporarily pushed to the
beginning of the new Ethernet header, the new Ethernet header offset and
length are recorded, then skb->data is moved back to where it was.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v3:

None.

Changes in v2:

Patch is new.

 include/linux/dsa/8021q.h |  7 +++++++
 net/dsa/tag_8021q.c       | 15 +++++++++++++++
 net/dsa/tag_sja1105.c     |  3 +--
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 3911e0586478..463378812f18 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -31,6 +31,8 @@ int dsa_8021q_rx_switch_id(u16 vid);
 
 int dsa_8021q_rx_source_port(u16 vid);
 
+struct sk_buff *dsa_8021q_remove_header(struct sk_buff *skb);
+
 #else
 
 int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int index,
@@ -71,6 +73,11 @@ int dsa_8021q_rx_source_port(u16 vid)
 	return 0;
 }
 
+struct sk_buff *dsa_8021q_remove_header(struct sk_buff *skb)
+{
+	return NULL;
+}
+
 #endif /* IS_ENABLED(CONFIG_NET_DSA_TAG_8021Q) */
 
 #endif /* _NET_DSA_8021Q_H */
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 65a35e976d7b..0ce680ef8e83 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -261,6 +261,21 @@ struct sk_buff *dsa_8021q_rcv(struct sk_buff *skb, struct net_device *netdev,
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_rcv);
 
+struct sk_buff *dsa_8021q_remove_header(struct sk_buff *skb)
+{
+	u8 *from = skb_mac_header(skb);
+	u8 *dest = from + VLAN_HLEN;
+
+	memmove(dest, from, ETH_HLEN - VLAN_HLEN);
+	skb_push(skb, ETH_HLEN);
+	skb_reset_mac_header(skb);
+	skb_reset_mac_len(skb);
+	skb_pull(skb, ETH_HLEN);
+
+	return skb;
+}
+EXPORT_SYMBOL_GPL(dsa_8021q_remove_header);
+
 static const struct dsa_device_ops dsa_8021q_netdev_ops = {
 	.name		= "8021q",
 	.proto		= DSA_TAG_PROTO_8021Q,
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index d43737e6c3fb..535d8a1aabe1 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -106,8 +106,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 	 * it there, see dsa_switch_rcv: skb_push(skb, ETH_HLEN).
 	 */
 	if (is_tagged)
-		memmove(skb->data - ETH_HLEN, skb->data - ETH_HLEN - VLAN_HLEN,
-			ETH_HLEN - VLAN_HLEN);
+		skb = dsa_8021q_remove_header(skb);
 
 	return skb;
 }
-- 
2.17.1

