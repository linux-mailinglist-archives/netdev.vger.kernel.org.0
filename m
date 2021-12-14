Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70443474E0E
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 23:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234905AbhLNWoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 17:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234409AbhLNWo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 17:44:26 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A515C06173E;
        Tue, 14 Dec 2021 14:44:25 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id g14so67336935edb.8;
        Tue, 14 Dec 2021 14:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z3KHK1Qz252qPTPlwp2DQrEAnJLSvMy6tiK8HNT5asM=;
        b=GAVepJe227LxLM5oXIuIRLfwXlPVdThaJ7TcsAPQ/QwkIgWkB5Fs1jtJH13c1J4NpV
         pk4LnEOg2s4/5jXWnu9PkOx/NOgQMcjTDMhRFhwyOal+4EcYV2pAW7glX/JCOletmLhK
         LtANwxZ4dnm4TwdiViRlJa8g+xuKBbN5e4VYCHY3AgL59+pyoyLJLXREIgPWkjLJWRWf
         yePEfKORopq4r+nghLsQZCmPedHI4hSHlV1iezVJv8bmrshUUsLy2xFdCOA6VRiGRLdF
         pgjLq6XFnwZnZc+BCuxhpoxmihVhWZAOAJqSdiYDjx/Vsnhr0StfDnutb2pB1J5WMkyk
         jkOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z3KHK1Qz252qPTPlwp2DQrEAnJLSvMy6tiK8HNT5asM=;
        b=MNkZD7m2ZrUjHtomu7y9ik2xBptoUanL8GF+ypSXmZDFVfUZeyWP4w9LXPRiMYusHt
         +1r7NKIbT1ZPcke25aJEgPJjy+ue1kPNBHEJ//tXu5SRMXbze8kbPdzMA8EvVmpKBZZm
         3IH9ejER6xabyohKsVe3oDuWFcw1WEvAUpZ0eh1Rkm6gGIyWakAmoCoVvluNtvbd6bKQ
         rimLB7f066nfelGfqDurgTCP0fx6W2bbYlxr1y4i9hZOSHDMxf0m19f1ohIy/EkDK6nm
         UXjCHDmDN2270Hpb/lpwBRfw7oirnsOPdFzqeWCbfkqITSpNYdlDrxSKdcViOjFpHmp8
         T+WQ==
X-Gm-Message-State: AOAM531DqSTTKTzGaSMKICXKbLp0SYq9MoSlSO4DDHZJCaciExZI1KzL
        7DL/B7onT4xbrGr864OtuIk=
X-Google-Smtp-Source: ABdhPJzS4rFHI7ssECUdms17TgUsjNbk/86eOoVLlAK5clQBp+kgchFZIJMq/nE77kDmkrzKW7zEkA==
X-Received: by 2002:a05:6402:27cd:: with SMTP id c13mr11767451ede.236.1639521863944;
        Tue, 14 Dec 2021 14:44:23 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id b19sm39008ejl.152.2021.12.14.14.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 14:44:23 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [net-next PATCH RFC v6 02/16] net: dsa: stop updating master MTU from master.c
Date:   Tue, 14 Dec 2021 23:43:55 +0100
Message-Id: <20211214224409.5770-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211214224409.5770-1-ansuelsmth@gmail.com>
References: <20211214224409.5770-1-ansuelsmth@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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
2.33.1

