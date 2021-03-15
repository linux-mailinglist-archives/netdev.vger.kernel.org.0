Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6789B33BCB1
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 15:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhCOO2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 10:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239060AbhCOO1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 10:27:40 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FCBC06175F;
        Mon, 15 Mar 2021 07:27:40 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id z2so5809152wrl.5;
        Mon, 15 Mar 2021 07:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/ALCNutqJwH4BX6SZfm+JJcI35tRbYIODlTeLhYbFF8=;
        b=fCLxxxpS/MG6ROPfGQOGBDpPbpLnFxO4QYd3t0f9wXvaSgkqnCxRq0jFHhO/cJUEPV
         MzIuyuulvUXgWWAbC4O4/jFYSl8qoL41QbFBNbKdi7OumhBg0uMvp7sj5dTQIh8VzfT3
         BTGf3ym+8ak+qgAGC11GkufAokW4p9hGNLbIMxn1WhX1Q5I/gtZoDPlW6JKdOVghycc1
         fDcaRAEbOsvmsUyYlaUU9ulWtnLWAbXtKZPiOTzWe/JisUL4SI6iRfuH4yPpWJ4kPerV
         oP26VOiuEkBCKO011uM0uYTdiwIbhm/X+gxtx1udM0WukPIufaMGFy14o/qge9TfWd1d
         ESJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/ALCNutqJwH4BX6SZfm+JJcI35tRbYIODlTeLhYbFF8=;
        b=pdCzqpQjzkiDD2mUkxs8HpbfsdsJu/s/+0WA4m0P1ensHGHCIFLgaXkzoHNIRhP24r
         Er3CpODCqQbNO06aeFTkqnDDifa2kbzxRVVioPvXVsaXda3KnN4diY+T2THLjo7jJyoR
         1ClUOYh8IB+2KONIL/87/QHI//XDdrUJ2KvG//bwtfLaNJmF1O6K3kfvZLKRBuDbAFgX
         BGTFDol7KWI84iz9IZooTnImsHwM4Zg66Em2Bhd8OBqamzUuSku/aGHFz9+dSlzcczhL
         F9vIhLrrZ2+955+QO5jsohDRfRxTqd2j3oeDtwkspbcrYp+7gEP996H5GcLtlkq+9oih
         4yxg==
X-Gm-Message-State: AOAM532Z+SeAF59YE0fI87biCtJBsQY9tufG74cyV523VYHqYSw/rc6T
        wkvh4LtwETFudlEX+unFWLI=
X-Google-Smtp-Source: ABdhPJxlW6u+fRd8i2ueOi121B3fFLXXEVLxmH33yijcD6d4KmJAM9lcKtdYcNscKqYyrEAGofiKyw==
X-Received: by 2002:a5d:4ec5:: with SMTP id s5mr28097086wrv.168.1615818459170;
        Mon, 15 Mar 2021 07:27:39 -0700 (PDT)
Received: from skynet.lan ([80.31.204.166])
        by smtp.gmail.com with ESMTPSA id 21sm12856606wme.6.2021.03.15.07.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 07:27:38 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     jonas.gorski@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH net-next 1/2] net: dsa: tag_brcm: add support for legacy tags
Date:   Mon, 15 Mar 2021 15:27:35 +0100
Message-Id: <20210315142736.7232-2-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210315142736.7232-1-noltari@gmail.com>
References: <20210315142736.7232-1-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for legacy Broadcom tags, which are similar to DSA_TAG_PROTO_BRCM.
These tags are used on BCM5325, BCM5365 and BCM63xx switches.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 include/net/dsa.h  |  2 +
 net/dsa/Kconfig    |  7 ++++
 net/dsa/tag_brcm.c | 96 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 105 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 83a933e563fe..dac303edd33d 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -49,10 +49,12 @@ struct phylink_link_state;
 #define DSA_TAG_PROTO_XRS700X_VALUE		19
 #define DSA_TAG_PROTO_OCELOT_8021Q_VALUE	20
 #define DSA_TAG_PROTO_SEVILLE_VALUE		21
+#define DSA_TAG_PROTO_BRCM_LEGACY_VALUE		22
 
 enum dsa_tag_protocol {
 	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
 	DSA_TAG_PROTO_BRCM		= DSA_TAG_PROTO_BRCM_VALUE,
+	DSA_TAG_PROTO_BRCM_LEGACY	= DSA_TAG_PROTO_BRCM_LEGACY_VALUE,
 	DSA_TAG_PROTO_BRCM_PREPEND	= DSA_TAG_PROTO_BRCM_PREPEND_VALUE,
 	DSA_TAG_PROTO_DSA		= DSA_TAG_PROTO_DSA_VALUE,
 	DSA_TAG_PROTO_EDSA		= DSA_TAG_PROTO_EDSA_VALUE,
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 58b8fc82cd3c..aaf8a452fd5b 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -48,6 +48,13 @@ config NET_DSA_TAG_BRCM
 	  Say Y if you want to enable support for tagging frames for the
 	  Broadcom switches which place the tag after the MAC source address.
 
+config NET_DSA_TAG_BRCM_LEGACY
+	tristate "Tag driver for Broadcom legacy switches using in-frame headers"
+	select NET_DSA_TAG_BRCM_COMMON
+	help
+	  Say Y if you want to enable support for tagging frames for the
+	  Broadcom legacy switches which place the tag after the MAC source
+	  address.
 
 config NET_DSA_TAG_BRCM_PREPEND
 	tristate "Tag driver for Broadcom switches using prepended headers"
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index e2577a7dcbca..9dbff771c9b3 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -9,9 +9,23 @@
 #include <linux/etherdevice.h>
 #include <linux/list.h>
 #include <linux/slab.h>
+#include <linux/types.h>
 
 #include "dsa_priv.h"
 
+struct bcm_legacy_tag {
+	uint16_t type;
+#define BRCM_LEG_TYPE	0x8874
+
+	uint32_t tag;
+#define BRCM_LEG_TAG_PORT_ID	(0xf)
+#define BRCM_LEG_TAG_MULTICAST	(1 << 29)
+#define BRCM_LEG_TAG_EGRESS	(2 << 29)
+#define BRCM_LEG_TAG_INGRESS	(3 << 29)
+} __attribute__((packed));
+
+#define BRCM_LEG_TAG_LEN	sizeof(struct bcm_legacy_tag)
+
 /* This tag length is 4 bytes, older ones were 6 bytes, we do not
  * handle them
  */
@@ -195,6 +209,85 @@ DSA_TAG_DRIVER(brcm_netdev_ops);
 MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_BRCM);
 #endif
 
+#if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_LEGACY)
+static struct sk_buff *brcm_leg_tag_xmit(struct sk_buff *skb,
+					 struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
+	struct bcm_legacy_tag *brcm_tag;
+
+	if (skb_cow_head(skb, BRCM_LEG_TAG_LEN) < 0)
+		return NULL;
+
+	/* The Ethernet switch we are interfaced with needs packets to be at
+	 * least 64 bytes (including FCS) otherwise they will be discarded when
+	 * they enter the switch port logic. When Broadcom tags are enabled, we
+	 * need to make sure that packets are at least 70 bytes
+	 * (including FCS and tag) because the length verification is done after
+	 * the Broadcom tag is stripped off the ingress packet.
+	 *
+	 * Let dsa_slave_xmit() free the SKB
+	 */
+	if (__skb_put_padto(skb, ETH_ZLEN + BRCM_LEG_TAG_LEN, false))
+		return NULL;
+
+	skb_push(skb, BRCM_LEG_TAG_LEN);
+
+	memmove(skb->data, skb->data + BRCM_LEG_TAG_LEN, 2 * ETH_ALEN);
+
+	brcm_tag = (struct bcm_legacy_tag *) (skb->data + 2 * ETH_ALEN);
+
+	brcm_tag->type = BRCM_LEG_TYPE;
+	brcm_tag->tag = BRCM_LEG_TAG_EGRESS;
+	brcm_tag->tag |= dp->index & BRCM_LEG_TAG_PORT_ID;
+
+	return skb;
+}
+
+
+static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
+					struct net_device *dev,
+					struct packet_type *pt)
+{
+	int source_port;
+	struct bcm_legacy_tag *brcm_tag;
+
+	if (unlikely(!pskb_may_pull(skb, BRCM_LEG_TAG_LEN)))
+		return NULL;
+
+	brcm_tag = (struct bcm_legacy_tag *) (skb->data - 2);
+
+	source_port = brcm_tag->tag & BRCM_LEG_TAG_PORT_ID;
+
+	skb->dev = dsa_master_find_slave(dev, 0, source_port);
+	if (!skb->dev)
+		return NULL;
+
+	/* Remove Broadcom tag and update checksum */
+	skb_pull_rcsum(skb, BRCM_LEG_TAG_LEN);
+
+	skb->offload_fwd_mark = 1;
+
+	/* Move the Ethernet DA and SA */
+	memmove(skb->data - ETH_HLEN,
+		skb->data - ETH_HLEN - BRCM_LEG_TAG_LEN,
+		2 * ETH_ALEN);
+
+	return skb;
+}
+
+static const struct dsa_device_ops brcm_legacy_netdev_ops = {
+	.name	= "brcm-legacy",
+	.proto	= DSA_TAG_PROTO_BRCM_LEGACY,
+	.xmit	= brcm_leg_tag_xmit,
+	.rcv	= brcm_leg_tag_rcv,
+	.overhead = BRCM_LEG_TAG_LEN,
+};
+
+DSA_TAG_DRIVER(brcm_legacy_netdev_ops);
+MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_BRCM_LEGACY);
+#endif /* CONFIG_NET_DSA_TAG_BRCM_LEGACY */
+
 #if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_PREPEND)
 static struct sk_buff *brcm_tag_xmit_prepend(struct sk_buff *skb,
 					     struct net_device *dev)
@@ -227,6 +320,9 @@ static struct dsa_tag_driver *dsa_tag_driver_array[] =	{
 #if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM)
 	&DSA_TAG_DRIVER_NAME(brcm_netdev_ops),
 #endif
+#if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_LEGACY)
+	&DSA_TAG_DRIVER_NAME(brcm_legacy_netdev_ops),
+#endif
 #if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_PREPEND)
 	&DSA_TAG_DRIVER_NAME(brcm_prepend_netdev_ops),
 #endif
-- 
2.20.1

