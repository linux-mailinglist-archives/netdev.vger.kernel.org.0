Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AADE934A600
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 11:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhCZK5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 06:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbhCZK5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 06:57:35 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAA9C0613B1
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 03:57:34 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id n138so7051168lfa.3
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 03:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=5evhuilpYPFWjGgd4BwFILGQEeMVkfeuaEaqgCac2ok=;
        b=dyxhA1oaAqXedp16ji5f6PoK2KmPSeQnWkYrg4ndJ+3l4SHedMSMGFYowEVyRiOlRy
         wCaA5O/5D5w8OqxYjtcZCTO17lCKE7sZ03oN8yIGpEExGjofDths48WIS/zEoZXX7krF
         r/q4AFs9R1LRp+op1jrDTahYOi6uC1JHckzd6dfTIhd52l3XMGoRO2hhpbzbTgJpuE+3
         EQAjbKshdgVoBRH9A4W16Rivpo/p1u7QbEnap241OHLSkV0xtdZEfmKuJBm/iDAJBRZS
         xXt82lgYJCklvqVrFKafTbtsmGPp43xegVZkoQwIfT2suy68UoaQTdySekKWGqvDppUJ
         UUSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=5evhuilpYPFWjGgd4BwFILGQEeMVkfeuaEaqgCac2ok=;
        b=KScP4t8H32V4H5c4mwd9pAt9UFwYzS4jq1iMShr6FmDL7H/Noxni2qhM2vV4jQ5cid
         qY8Q2yjJjL/N9424i8n4s2dPOXe4/LSF9xkMhtcarkFOSGaLn7PFiuDZsW0a6thDZ3as
         A558OxbxdH0IeJxj7+gxPf8P4W7v3G6j+nKaB08Fd52KMlkYisv8Ofy9YbF1NE2eyWTg
         hppDgHTsfTDvvW5BleMwio896ftTGBulz84KSUiL7pugnSNH/BXQ5Lc+NrZDlZvXCuk8
         +fl1aZkNgTbos+gC5UzOYh7NKZN8rQUBhJpLlHJ8IOrjPo7ssBNXvBrw2tQ6kWwIrTj8
         bgUg==
X-Gm-Message-State: AOAM5326ZhwkvG5W080cxsHK5mQQkee/JSlHPfOUkFQGf6AFuKTECZxe
        nBVPu3LAOAbVVt5QQo4BqkEl0Q==
X-Google-Smtp-Source: ABdhPJyDmgggpU6QDJ9BVrdVzxgfWrKrr5sUjqILw0YfgFfElqdiMYTk07HmbKQXukf/WFs/0UDhvA==
X-Received: by 2002:a19:e85:: with SMTP id 127mr8250385lfo.77.1616756253233;
        Fri, 26 Mar 2021 03:57:33 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id n23sm832629lfq.121.2021.03.26.03.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 03:57:32 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH net-next 2/3] net: dsa: Allow default tag protocol to be overridden from DT
Date:   Fri, 26 Mar 2021 11:56:47 +0100
Message-Id: <20210326105648.2492411-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210326105648.2492411-1-tobias@waldekranz.com>
References: <20210326105648.2492411-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some combinations of tag protocols and Ethernet controllers are
incompatible, and it is hard for the driver to keep track of these.

Therefore, allow the device tree author (typically the board vendor)
to inform the driver of this fact by selecting an alternate protocol
that is known to work.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---

This deviates from the advise given by Andrew in that we store the
switches' default protocol on the tree rather than the override
value. I chose this because you want to make sure that the tagger
(default or overwritten) is available at probe time, and since that
means we actually load it, it made more sense to keep it loaded.

Then we just check during setup if we are running a different tagger
than what the driver would expect.

Somewhat related: since we know the default now, users could easily
revert to it via sysfs: `echo >/sys/class/eth0/dsa/tagging`. Not sure
if that would be useful.

 include/net/dsa.h |  5 +++
 net/dsa/dsa2.c    | 95 +++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 84 insertions(+), 16 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 57b2c49f72f4..2385ba317888 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -149,6 +149,11 @@ struct dsa_switch_tree {
 	/* Tagging protocol operations */
 	const struct dsa_device_ops *tag_ops;
 
+	/* Default tagging protocol preferred by the switches in this
+	 * tree.
+	 */
+	enum dsa_tag_protocol default_proto;
+
 	/*
 	 * Configuration data for the platform device that owns
 	 * this dsa switch tree instance.
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 4d4956ed303b..52afe70f75af 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -668,6 +668,35 @@ static const struct devlink_ops dsa_devlink_ops = {
 	.sb_occ_tc_port_bind_get	= dsa_devlink_sb_occ_tc_port_bind_get,
 };
 
+static int dsa_switch_setup_tag_protocol(struct dsa_switch *ds)
+{
+	const struct dsa_device_ops *tag_ops = ds->dst->tag_ops;
+	struct dsa_switch_tree *dst = ds->dst;
+	int port, err;
+
+	if (tag_ops->proto == dst->default_proto)
+		return 0;
+
+	if (!ds->ops->change_tag_protocol) {
+		dev_err(ds->dev, "Tag protocol cannot be modified\n");
+		return -EINVAL;
+	}
+
+	for (port = 0; port < ds->num_ports; port++) {
+		if (!(dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port)))
+			continue;
+
+		err = ds->ops->change_tag_protocol(ds, port, tag_ops->proto);
+		if (err) {
+			dev_err(ds->dev, "Tag protocol \"%s\" is not supported\n",
+				tag_ops->name);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
 static int dsa_switch_setup(struct dsa_switch *ds)
 {
 	struct dsa_devlink_priv *dl_priv;
@@ -718,6 +747,10 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	if (err < 0)
 		goto unregister_notifier;
 
+	err = dsa_switch_setup_tag_protocol(ds);
+	if (err)
+		goto teardown;
+
 	devlink_params_publish(ds->devlink);
 
 	if (!ds->slave_mii_bus && ds->ops->phy_read) {
@@ -1062,32 +1095,60 @@ static enum dsa_tag_protocol dsa_get_tag_protocol(struct dsa_port *dp,
 	return ds->ops->get_tag_protocol(ds, dp->index, tag_protocol);
 }
 
-static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master)
+static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
+			      const char *user_protocol)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_switch_tree *dst = ds->dst;
-	enum dsa_tag_protocol tag_protocol;
+	const struct dsa_device_ops *tag_ops;
+	enum dsa_tag_protocol default_proto;
+
+	/* Find out which protocol the switch would prefer. */
+	default_proto = dsa_get_tag_protocol(dp, master);
+	if (dst->default_proto) {
+		if (dst->default_proto != default_proto) {
+			dev_err(ds->dev,
+				"A DSA switch tree can have only one tagging protovol\n");
+			return -EINVAL;
+		}
+	} else {
+		dst->default_proto = default_proto;
+	}
+
+	/* See if the user wants to override that preference. */
+	if (user_protocol && ds->ops->change_tag_protocol) {
+		tag_ops = dsa_find_tagger_by_name(user_protocol);
+	} else {
+		if (user_protocol)
+			dev_warn(ds->dev,
+				 "Tag protocol cannot be modified, using default\n");
+
+		tag_ops = dsa_tag_driver_get(default_proto);
+	}
+
+	if (IS_ERR(tag_ops)) {
+		if (PTR_ERR(tag_ops) == -ENOPROTOOPT)
+			return -EPROBE_DEFER;
+
+		dev_warn(ds->dev, "No tagger for this switch\n");
+		return PTR_ERR(tag_ops);
+	}
 
-	tag_protocol = dsa_get_tag_protocol(dp, master);
 	if (dst->tag_ops) {
-		if (dst->tag_ops->proto != tag_protocol) {
+		if (dst->tag_ops != tag_ops) {
 			dev_err(ds->dev,
 				"A DSA switch tree can have only one tagging protocol\n");
+
+			dsa_tag_driver_put(tag_ops);
 			return -EINVAL;
 		}
+
 		/* In the case of multiple CPU ports per switch, the tagging
-		 * protocol is still reference-counted only per switch tree, so
-		 * nothing to do here.
+		 * protocol is still reference-counted only per switch tree.
 		 */
+		dsa_tag_driver_put(tag_ops);
 	} else {
-		dst->tag_ops = dsa_tag_driver_get(tag_protocol);
-		if (IS_ERR(dst->tag_ops)) {
-			if (PTR_ERR(dst->tag_ops) == -ENOPROTOOPT)
-				return -EPROBE_DEFER;
-			dev_warn(ds->dev, "No tagger for this switch\n");
-			dp->master = NULL;
-			return PTR_ERR(dst->tag_ops);
-		}
+		dst->tag_ops = tag_ops;
 	}
 
 	dp->master = master;
@@ -1108,12 +1169,14 @@ static int dsa_port_parse_of(struct dsa_port *dp, struct device_node *dn)
 
 	if (ethernet) {
 		struct net_device *master;
+		const char *user_protocol;
 
 		master = of_find_net_device_by_node(ethernet);
 		if (!master)
 			return -EPROBE_DEFER;
 
-		return dsa_port_parse_cpu(dp, master);
+		user_protocol = of_get_property(dn, "dsa,tag-protocol", NULL);
+		return dsa_port_parse_cpu(dp, master, user_protocol);
 	}
 
 	if (link)
@@ -1225,7 +1288,7 @@ static int dsa_port_parse(struct dsa_port *dp, const char *name,
 
 		dev_put(master);
 
-		return dsa_port_parse_cpu(dp, master);
+		return dsa_port_parse_cpu(dp, master, NULL);
 	}
 
 	if (!strcmp(name, "dsa"))
-- 
2.25.1

