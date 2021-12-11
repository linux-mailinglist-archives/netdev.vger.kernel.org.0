Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE29A4715E1
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 20:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbhLKT6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 14:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbhLKT6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 14:58:18 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50E61C061714;
        Sat, 11 Dec 2021 11:58:18 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id r25so39577627edq.7;
        Sat, 11 Dec 2021 11:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6VYf84s46pYHk14Zd0Id645e0E3gaY9WmXyIhkduppg=;
        b=dmWOxysxlYjbYbBCA0f7rGo2R2I3STjUr0Pri5B7fTiDq9q4WkV6SrNSy/p845NOSs
         JSVwfJMZCyywE8tzk696xz0VSHO2b153cR9rjAV/U0gUnQ9LdgmL+7Ig++up6GbXXlKZ
         XNcBqFbbpnYPlcIPndw2ceCkKmQAEyX61/7jv7Pzqt5t5tMiyaJiJjbg8ZsyavYdnQcH
         hcxElfcqLtPmszC/zscgsFGaxrkGRGvYcRJ7cCi1WP8Zoj9wpLQrTbB/WUkjEkEI8rk8
         ETszfA2w9cvEE8z9LYxpddHUa0AK70ZlGKf9SbyoemyOT3/3nwlZo4gtBAq5BniXummD
         JRLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6VYf84s46pYHk14Zd0Id645e0E3gaY9WmXyIhkduppg=;
        b=FTH2CUFDjUPQtJlHiSmi0D/6MhgDkY7EtxyyY0jBJG/GZI5OUZ/xNYnI56ACiHDd6D
         szn7aLtJiwg/LUb4ymlstjAL7aXDFigoGf48ZWgDTtqjhZDU2hZQl3BSNVUPJMJ8HHPp
         TNRxKa7xdvpN4FUjUo+mYVv6oaASNFP5leA5ahcrKyHGAhWsRGQvXQt7e06h6XeD8QuB
         iIJqZiZNdZGbLzz6tevGZdPwYeYfCDJxsTIGKikm8N2B0IAmbnpjmp8Y2s9IfPC7bmJF
         R34KRXfiil4QBHakn7jYmX9igekipEp2GKdE+c8xq8sfnKhjcPH1cf9vuR1WKcEhkA2S
         Dcmg==
X-Gm-Message-State: AOAM532goJTgR4PVJe/jZVa+IfNFD4A6QFOaDj1mTa0+FVZSqJcoCi9Z
        hamOchDTrq8uxlI5QM46WM4=
X-Google-Smtp-Source: ABdhPJx4uwRSmhw3l4aBOGTipoIqIvqVxnfLwoZENUgabNB9OjaqGoxmRrFWI0SXRFv32exJQ3dL9Q==
X-Received: by 2002:a17:907:9847:: with SMTP id jj7mr31957971ejc.508.1639252696726;
        Sat, 11 Dec 2021 11:58:16 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id e15sm3581479edq.46.2021.12.11.11.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 11:58:16 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [net-next RFC PATCH v4 02/15] net: dsa: stop updating master MTU from master.c
Date:   Sat, 11 Dec 2021 20:57:45 +0100
Message-Id: <20211211195758.28962-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211211195758.28962-1-ansuelsmth@gmail.com>
References: <20211211195758.28962-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The dev_set_mtu() call from dsa_master_setup() has been effectively
superseded by the dsa_slave_change_mtu(slave_dev, ETH_DATA_LEN) that is
done from dsa_slave_create() for each user port. This function also
updates the master MTU according to the largest user port MTU from the
tree. Therefore, updating the master MTU through a separate code path
isn't needed.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/master.c | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/net/dsa/master.c b/net/dsa/master.c
index e8e19857621b..f4efb244f91d 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -330,28 +330,13 @@ static const struct attribute_group dsa_group = {
 	.attrs	= dsa_slave_attrs,
 };
 
-static void dsa_master_reset_mtu(struct net_device *dev)
-{
-	int err;
-
-	rtnl_lock();
-	err = dev_set_mtu(dev, ETH_DATA_LEN);
-	if (err)
-		netdev_dbg(dev,
-			   "Unable to reset MTU to exclude DSA overheads\n");
-	rtnl_unlock();
-}
-
 static struct lock_class_key dsa_master_addr_list_lock_key;
 
 int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 {
-	const struct dsa_device_ops *tag_ops = cpu_dp->tag_ops;
 	struct dsa_switch *ds = cpu_dp->ds;
 	struct device_link *consumer_link;
-	int mtu, ret;
-
-	mtu = ETH_DATA_LEN + dsa_tag_protocol_overhead(tag_ops);
+	int ret;
 
 	/* The DSA master must use SET_NETDEV_DEV for this to work. */
 	consumer_link = device_link_add(ds->dev, dev->dev.parent,
@@ -361,13 +346,6 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 			   "Failed to create a device link to DSA switch %s\n",
 			   dev_name(ds->dev));
 
-	rtnl_lock();
-	ret = dev_set_mtu(dev, mtu);
-	rtnl_unlock();
-	if (ret)
-		netdev_warn(dev, "error %d setting MTU to %d to include DSA overhead\n",
-			    ret, mtu);
-
 	/* If we use a tagging format that doesn't have an ethertype
 	 * field, make sure that all packets from this point on get
 	 * sent to the tag format's receive function.
@@ -405,7 +383,6 @@ void dsa_master_teardown(struct net_device *dev)
 	sysfs_remove_group(&dev->dev.kobj, &dsa_group);
 	dsa_netdev_ops_set(dev, NULL);
 	dsa_master_ethtool_teardown(dev);
-	dsa_master_reset_mtu(dev);
 	dsa_master_set_promiscuity(dev, -1);
 
 	dev->dsa_ptr = NULL;
-- 
2.32.0

