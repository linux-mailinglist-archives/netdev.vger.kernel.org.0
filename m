Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78611CE547
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 22:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731633AbgEKUVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 16:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbgEKUVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 16:21:02 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2ADAC061A0E
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 13:21:01 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id k12so19379720wmj.3
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 13:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+MKgp8F0LtryssIIEGMOF9/rasbpUssUPsEUVeF83Uo=;
        b=XnR31j1F0awvX+FbnhoXCESouDAINmbWiEq5kjc2/62klw1TJ0rK9/lkv38y8aE1w6
         90CrBoPNDVoWzJgXooKs+fNe53Va6RmBikY3Y/8QYgNAyo6JqmkxZZmzIMaqDHkIiVrd
         J58fAVG+JDDUijwVzTDjzleu2YcTWur2aSGNPV8mcdiVjjIy5/KbXugAlXFLLPJo3xZF
         cwv2Pbq1su2K5dW+hMvtxl8oH8JsrFy2myMmRKpkBu4UR+Ar7hoNh+r7TzIZ9eDJSJ1L
         T1Q90WWC1AZCIQyW+2yMBienxCXmmdSQr1ky1WRayTbKJBKe0ZGJTi2R+T45z0vFtn0a
         I4fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+MKgp8F0LtryssIIEGMOF9/rasbpUssUPsEUVeF83Uo=;
        b=L4kNvB2PpNGAT8MBTlBICklEfTMUfBZf1r7/GmtLWVvLFnJaOH+BRWTwhZbwSlK6Hj
         xTQKkoKZkKWim8TikQHSQk7mLV3hQzYtfGxlZSo4Xi9IXqZTY5kQlgp4y4HJesGll8Ve
         CKxT0KY1i3WWhpBLe+K8j0Yry8FyKe0c0qhb24Mw71DBthFVkCPSKdrNwM+pUBO2PY5z
         R7H+OR3Ei3DH/AVHsEtyUF4PsvCVG99xIu8rgG/v5R9iZQMkCFtS8nX2G9KhhkZcF31+
         icUHc0Ld0sLP7gpxw6SFM8jyACXbltHqH8wv1g/k839nnw8MCpt5fzIqlXnx9hxGVSOC
         7fog==
X-Gm-Message-State: AGi0Pua0rEefUmNwQ2LpnS44Awh2XrNXxYZXF8BzqHzuOknUWswJLSN5
        /s2JX3VkZFcp1Ui6D20k14s=
X-Google-Smtp-Source: APiQypLcXtFbk3rLSZC0DO0P2TZNA2UYSfMFTqgTUWV0vhe6U2MKu73ZG56rJZMh+T64IT1kmGZ0RQ==
X-Received: by 2002:a1c:208a:: with SMTP id g132mr11693433wmg.78.1589228460546;
        Mon, 11 May 2020 13:21:00 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id 77sm19811305wrc.6.2020.05.11.13.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 13:21:00 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 1/4] net: dsa: allow drivers to request promiscuous mode on master
Date:   Mon, 11 May 2020 23:20:43 +0300
Message-Id: <20200511202046.20515-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200511202046.20515-1-olteanv@gmail.com>
References: <20200511202046.20515-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Currently DSA assumes that taggers don't mess with the destination MAC
address of the frames on RX. That is not always the case. Some DSA
headers are placed before the Ethernet header (ocelot), and others
simply mangle random bytes from the destination MAC address (sja1105
with its incl_srcpt option).

Currently the DSA master goes to promiscuous mode automatically when the
slave devices go too (such as when enslaved to a bridge), but in
standalone mode this is a problem that needs to be dealt with.

So give drivers the possibility to signal that their tagging protocol
will get randomly dropped otherwise, and let DSA deal with fixing that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h | 13 +++++++++++++
 net/dsa/master.c  | 39 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 312c2f067e65..ddc970430a63 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -217,6 +217,12 @@ struct dsa_port {
 	 */
 	const struct net_device_ops *orig_ndo_ops;
 
+	/*
+	 * Original master netdev flags in case we need to put it in
+	 * promiscuous mode
+	 */
+	unsigned int orig_master_flags;
+
 	bool setup;
 };
 
@@ -298,6 +304,13 @@ struct dsa_switch {
 	 */
 	bool			mtu_enforcement_ingress;
 
+	/* Some tagging protocols either mangle or shift the destination MAC
+	 * address, in which case the DSA master would drop packets on ingress
+	 * if what it understands out of the destination MAC address is not in
+	 * its RX filter.
+	 */
+	bool promisc_on_master;
+
 	size_t num_ports;
 };
 
diff --git a/net/dsa/master.c b/net/dsa/master.c
index a621367c6e8c..5d1873026612 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -294,6 +294,37 @@ static void dsa_master_ndo_teardown(struct net_device *dev)
 	cpu_dp->orig_ndo_ops = NULL;
 }
 
+static void dsa_master_set_promisc(struct net_device *dev)
+{
+	struct dsa_port *cpu_dp = dev->dsa_ptr;
+	struct dsa_switch *ds = cpu_dp->ds;
+	unsigned int flags;
+
+	if (!ds->promisc_on_master)
+		return;
+
+	flags = dev_get_flags(dev);
+
+	cpu_dp->orig_master_flags = flags;
+
+	rtnl_lock();
+	dev_change_flags(dev, flags | IFF_PROMISC, NULL);
+	rtnl_unlock();
+}
+
+static void dsa_master_reset_promisc(struct net_device *dev)
+{
+	struct dsa_port *cpu_dp = dev->dsa_ptr;
+	struct dsa_switch *ds = cpu_dp->ds;
+
+	if (!ds->promisc_on_master)
+		return;
+
+	rtnl_lock();
+	dev_change_flags(dev, cpu_dp->orig_master_flags, NULL);
+	rtnl_unlock();
+}
+
 static ssize_t tagging_show(struct device *d, struct device_attribute *attr,
 			    char *buf)
 {
@@ -345,9 +376,12 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 	wmb();
 
 	dev->dsa_ptr = cpu_dp;
+
+	dsa_master_set_promisc(dev);
+
 	ret = dsa_master_ethtool_setup(dev);
 	if (ret)
-		return ret;
+		goto out_err_reset_promisc;
 
 	ret = dsa_master_ndo_setup(dev);
 	if (ret)
@@ -363,6 +397,8 @@ int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 	dsa_master_ndo_teardown(dev);
 out_err_ethtool_teardown:
 	dsa_master_ethtool_teardown(dev);
+out_err_reset_promisc:
+	dsa_master_reset_promisc(dev);
 	return ret;
 }
 
@@ -372,6 +408,7 @@ void dsa_master_teardown(struct net_device *dev)
 	dsa_master_ndo_teardown(dev);
 	dsa_master_ethtool_teardown(dev);
 	dsa_master_reset_mtu(dev);
+	dsa_master_reset_promisc(dev);
 
 	dev->dsa_ptr = NULL;
 
-- 
2.17.1

