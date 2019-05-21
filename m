Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3412584C
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 21:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbfEUTa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 15:30:57 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41740 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbfEUTa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 15:30:56 -0400
Received: by mail-qt1-f193.google.com with SMTP id y22so21893426qtn.8
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 12:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8cl4Uaj66U1zdfRgVeweMtLQ5TVlcJzkdmkSvFAetwE=;
        b=NCbEaIIZAKZp/zyBmEVngce+d8mIum89xjyimC6WrzYcNCMoDDicQyMq8Ch1NIr4Cm
         BaZ7urBtq2e4uW65xRMpHbk8ynCSsqmj/4pio4YVQfpHp8oUZIiZRMZGvP/YXu7AuCtB
         sGCJQc+qHkJR2Z9NGJB9wzVCBQnhYquYocIuStMGclORtXD02D4skDiYOn9oGuomDG/G
         8I0EbHtYlM90yWNEHBqh6Ke97LBKtNKfblYuh+Q2DAFD4tqBI/0K+p5yRmO6uZp1IQxX
         J85k4Dd4bgsWxxGGeNz5mX8WoD6t9cKhKT2liRkIGKNxCrIa8R16iv06rRla2Fvpl1l3
         J/SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8cl4Uaj66U1zdfRgVeweMtLQ5TVlcJzkdmkSvFAetwE=;
        b=jDbH86LMQ6N8EMrOnAizekphxpHXZInBrd2U50m56i6OGTWFPBnLa6lzuiOw8YBsE8
         AyuZwevmS15f6ek0i2wi8cfi/l1yiT0GL2SQSBQ3n3zFsQfkga4c0I1oeEs+B3vIag2X
         lM8Z3plNoLFublJo0wjJApUe61b01Fkoq5T+sinR7F1JxYKAM6a5mDGJXZr6kJG7ZW1C
         +5JQkOXoi2vitZP7Lf3wzNzYyeEdCnJtJ6dQQoXh89pQ91hZqgHk87YtqZ5lPxnCMPrM
         Y3UEALCFqQsJaaatq54sbqNw3B1C6NmqVN3iWT1LASHtft/yxRnGYbpFWgX+/phbVvEA
         OuqQ==
X-Gm-Message-State: APjAAAV0UuoS/yoUexCkfal8vHQb953dKXK9URsUT4bU8WXs8OqCzQtJ
        6+c2+73CFIEwHPsJ53JEP8tNMoLL
X-Google-Smtp-Source: APXvYqxFkLpG9A6yPP0MaQPNcEDfXQHNfQwm7ggiNcMlZdr0zG3LL4xUUMrZX/uP88ksXGdzvaHZaA==
X-Received: by 2002:ad4:5406:: with SMTP id f6mr67038306qvt.102.1558467054933;
        Tue, 21 May 2019 12:30:54 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id t3sm7883755qto.36.2019.05.21.12.30.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 May 2019 12:30:54 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     cphealy@gmail.com, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [RFC net-next 3/9] net: dsa: allow switches to transmit frames
Date:   Tue, 21 May 2019 15:29:58 -0400
Message-Id: <20190521193004.10767-4-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190521193004.10767-1-vivien.didelot@gmail.com>
References: <20190521193004.10767-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce an xmit and work queue to allow switches to send frames
on their own, which can be useful to implement control frames via
Ethernet for instance.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 include/net/dsa.h  |  5 +++++
 net/dsa/dsa2.c     |  6 ++++++
 net/dsa/dsa_priv.h |  2 ++
 net/dsa/switch.c   | 15 +++++++++++++++
 4 files changed, 28 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 027bb67ebaf7..7b10a067b06d 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -275,6 +275,9 @@ struct dsa_switch {
 	 */
 	bool			vlan_filtering;
 
+	struct work_struct	xmit_work;
+	struct sk_buff_head	xmit_queue;
+
 	unsigned long		*bitmap;
 	unsigned long		_bitmap;
 
@@ -283,6 +286,8 @@ struct dsa_switch {
 	struct dsa_port ports[];
 };
 
+void dsa_switch_xmit(struct dsa_switch *ds, struct sk_buff *skb);
+
 static inline const struct dsa_port *dsa_to_port(struct dsa_switch *ds, int p)
 {
 	return &ds->ports[p];
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 3b5f434cad3f..fb7318b20e0a 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -375,6 +375,9 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	if (err)
 		return err;
 
+	skb_queue_head_init(&ds->xmit_queue);
+	INIT_WORK(&ds->xmit_work, dsa_switch_xmit_work);
+
 	err = ds->ops->setup(ds);
 	if (err < 0)
 		return err;
@@ -399,6 +402,9 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 	if (ds->slave_mii_bus && ds->ops->phy_read)
 		mdiobus_unregister(ds->slave_mii_bus);
 
+	cancel_work_sync(&ds->xmit_work);
+	skb_queue_purge(&ds->xmit_queue);
+
 	dsa_switch_unregister_notifier(ds);
 
 	if (ds->devlink) {
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 2a8ee4c6adc5..0ccb0eab6295 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -201,4 +201,6 @@ dsa_slave_to_master(const struct net_device *dev)
 /* switch.c */
 int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
+void dsa_switch_xmit_work(struct work_struct *work);
+
 #endif
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 7d8cd9bc0ecc..b39d246f0d55 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -371,3 +371,18 @@ void dsa_switch_unregister_notifier(struct dsa_switch *ds)
 	if (err)
 		dev_err(ds->dev, "failed to unregister notifier (%d)\n", err);
 }
+
+void dsa_switch_xmit(struct dsa_switch *ds, struct sk_buff *skb)
+{
+	skb_queue_tail(&ds->xmit_queue, skb);
+	schedule_work(&ds->xmit_work);
+}
+
+void dsa_switch_xmit_work(struct work_struct *work)
+{
+	struct dsa_switch *ds = container_of(work, struct dsa_switch, xmit_work);
+	struct sk_buff *skb;
+
+	while ((skb = skb_dequeue(&ds->xmit_queue)) != NULL)
+		dev_queue_xmit(skb);
+}
-- 
2.21.0

