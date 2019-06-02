Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17F2832509
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 23:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfFBVk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 17:40:26 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41996 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbfFBVkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 17:40:25 -0400
Received: by mail-wr1-f66.google.com with SMTP id o12so2874543wrj.9;
        Sun, 02 Jun 2019 14:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6iia0ebLkPkesm2VmpiPqBGCkPxmZJLnZuiO8KcZ2LE=;
        b=B2helQF9RjdI1dWq2XRXV/s+ddJUsza73OdneMLgvhXH9oXASiVoUWs/MTN08axbsa
         MJOjXDA4U1Hcq9zhs7XupVM8GgJal8vaz0F808G+BCAs5QRQHH+GUq6UkxxxIaWoQFPl
         FXFlinZf2rJjG0WKYVF4ScHzWflik1RGWN6aLwa0w+FI0LaRCpneaKxbMmnfdmoyW/ga
         3eegru2cDzMMiBZou5V+2ZszzmWiF67k2ISChVEzmF+9TxJXCaLhRd0hQiordkTwUULX
         EMhTv+8W1OEu2IM+H5MVgjo1URvaTOSPD/+XMgPljyVdGRhfCAjfCNxgoIzoPH8MwtnJ
         KAAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6iia0ebLkPkesm2VmpiPqBGCkPxmZJLnZuiO8KcZ2LE=;
        b=QpZbe1Im39yMmY1lYNOyvELAYWcpFbJb81jLSoYkkw82nE6OqJDHFffieKdtdQiv8h
         4CL69/dWKozTJ1pQa/d8r0ObzPJzQxGBmQmIZ0Z7hXEvKEySfoGPyfmdCFAnkJCarMm5
         Y5NaglVt2eER0/1T9HS55HquXS4FK9PD7iErQM4r0/Vc6vlmIr11xsUrf/THramBD727
         OB4HSDXXkTd44INNJMQMc/x+1USj1xqdSl+5p6e6L9bSXRuQoqEturSV22pDAQDYLG6+
         BJAxhD43EtMsSEWjZIoDakAJnnU5zhOXqaZapNG99UWI9Ejit9DGZPK0zJN1vZy9vRfh
         THnw==
X-Gm-Message-State: APjAAAWxW8lFGe3sz0/v5vSpp5rxLcNRydTMLVHTNxXwBecPC4J9GS8x
        Dsl66oWvYXgV1LJeHv5tag4=
X-Google-Smtp-Source: APXvYqyWaQ+B+c43MSFxOeiWjlmgvgcmoNJ01EDlp5SA9AMa+kxW83IoTmjaUTERJMZk09KqXvfIWg==
X-Received: by 2002:adf:e344:: with SMTP id n4mr13851021wrj.192.1559511624215;
        Sun, 02 Jun 2019 14:40:24 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id 65sm26486793wro.85.2019.06.02.14.40.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 14:40:04 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 03/10] net: dsa: tag_8021q: Create helper function for removing VLAN header
Date:   Mon,  3 Jun 2019 00:39:19 +0300
Message-Id: <20190602213926.2290-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190602213926.2290-1-olteanv@gmail.com>
References: <20190602213926.2290-1-olteanv@gmail.com>
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

