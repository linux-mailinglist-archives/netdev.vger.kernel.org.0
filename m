Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C693365FD0
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 20:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbhDTSyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 14:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233693AbhDTSx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 14:53:57 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018C7C06174A
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 11:53:26 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id o9-20020a1c41090000b029012c8dac9d47so13788087wma.1
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 11:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=dXDESjlngEfW/cK207nlmCV2x7fMh0T+CNSuMzUTgCM=;
        b=PFTf1Ixc45NDuln8k8nEAUHEesk+H2jtVE1ojEyCI/dbLSZZltoTd/wga9PWWMOhFd
         fezj0V76DBgD1Y+HGmJ5e+BLw6nHwq8P0fftQEhgKgeA1Hw/jLudwu3/3s0o/W/X3/vq
         cZoZxWR9YPkEw+s37skYvDXJWitabDJclAP8bOnMgZloZ5mroTbcbXyMD5uhYT9Bb4LB
         6RsV6q5GP6jkGZrBfHrCGrlKGrME2Ic3e/rMC8VdmKeGC/+weWZWR5ZuhvdwkKlMRCXm
         EPl9wHZiqSGKts0lULFfh6lNJTjOh1bxbDksjkSYrWrqv8EIq40CsANGJG1apD5ljgf6
         rIRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=dXDESjlngEfW/cK207nlmCV2x7fMh0T+CNSuMzUTgCM=;
        b=H2AVR3ISB2RTp9KS0wbLtsxCzs7NbGNiFskHebOMWka23S3mJgh8VngJkCfql3HeQ2
         RhQEV2LCkDv7kmNY5BVw6ki6CROUii7P/NiZ7cuZ9SKMrI6hqwWlhiapDGDgFuMW7faX
         anbq+8XkvVzBIqGck43Xh0VfnvpFg45d+KhFn8J2Iiw8eOv2Ac1SZiHJyR6wH+xLj/DT
         CyykqRlFDt3/Tvr+fzmpv5FEuVuTXc+OE8vmz6Mf7MuXcZaZMyYLbwimzhfGc+QZl+Wp
         ZredE6uHdSxiv1UJ2VCZrxUZpF4MK54lkJTM65xNlfvZ6h6XXQFDLq1PL3qlS5LU6qvg
         vFKA==
X-Gm-Message-State: AOAM532D5zwGCXe4RQ5/Qn7qQvGqSQAPQdUfriOkwRdin8j3dsnV+XNT
        r7gL+cxMP1B9VFnQjqdwUwyBjEtoMEPFjg==
X-Google-Smtp-Source: ABdhPJweLlvibxZOtnyrjp1pQ0+w9K+KjayIQ6314W94gDqCnqaKcEuiHYUWKIKbjz2kAvzFBy1lXw==
X-Received: by 2002:a1c:4045:: with SMTP id n66mr5735434wma.94.1618944804741;
        Tue, 20 Apr 2021 11:53:24 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id f7sm25897402wrp.48.2021.04.20.11.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 11:53:24 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v3 net-next 4/5] net: dsa: Allow default tag protocol to be overridden from DT
Date:   Tue, 20 Apr 2021 20:53:10 +0200
Message-Id: <20210420185311.899183-5-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210420185311.899183-1-tobias@waldekranz.com>
References: <20210420185311.899183-1-tobias@waldekranz.com>
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
 include/net/dsa.h |   5 +++
 net/dsa/dsa2.c    | 103 ++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 91 insertions(+), 17 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 1259b0f40684..2b25fe1ad5b7 100644
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
index d7c22e3a1fbf..b71e87909f0e 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -668,6 +668,30 @@ static const struct devlink_ops dsa_devlink_ops = {
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
+	for (port = 0; port < ds->num_ports; port++) {
+		if (!dsa_is_cpu_port(ds, port))
+			continue;
+
+		err = ds->ops->change_tag_protocol(ds, port, tag_ops->proto);
+		if (err) {
+			dev_err(ds->dev, "Unable to use tag protocol \"%s\": %pe\n",
+				tag_ops->name, ERR_PTR(err));
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
@@ -718,6 +742,10 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	if (err < 0)
 		goto unregister_notifier;
 
+	err = dsa_switch_setup_tag_protocol(ds);
+	if (err)
+		goto teardown;
+
 	devlink_params_publish(ds->devlink);
 
 	if (!ds->slave_mii_bus && ds->ops->phy_read) {
@@ -1068,34 +1096,60 @@ static enum dsa_tag_protocol dsa_get_tag_protocol(struct dsa_port *dp,
 	return ds->ops->get_tag_protocol(ds, dp->index, tag_protocol);
 }
 
-static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master)
+static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
+			      const char *user_protocol)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_switch_tree *dst = ds->dst;
 	const struct dsa_device_ops *tag_ops;
-	enum dsa_tag_protocol tag_protocol;
+	enum dsa_tag_protocol default_proto;
+
+	/* Find out which protocol the switch would prefer. */
+	default_proto = dsa_get_tag_protocol(dp, master);
+	if (dst->default_proto) {
+		if (dst->default_proto != default_proto) {
+			dev_err(ds->dev,
+				"A DSA switch tree can have only one tagging protocol\n");
+			return -EINVAL;
+		}
+	} else {
+		dst->default_proto = default_proto;
+	}
+
+	/* See if the user wants to override that preference. */
+	if (user_protocol) {
+		if (!ds->ops->change_tag_protocol) {
+			dev_err(ds->dev, "Tag protocol cannot be modified\n");
+			return -EINVAL;
+		}
+
+		tag_ops = dsa_find_tagger_by_name(user_protocol);
+	} else {
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
-		tag_ops = dsa_tag_driver_get(tag_protocol);
-		if (IS_ERR(tag_ops)) {
-			if (PTR_ERR(tag_ops) == -ENOPROTOOPT)
-				return -EPROBE_DEFER;
-			dev_warn(ds->dev, "No tagger for this switch\n");
-			dp->master = NULL;
-			return PTR_ERR(tag_ops);
-		}
-
 		dst->tag_ops = tag_ops;
 	}
 
@@ -1104,6 +1158,19 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master)
 	dsa_port_set_tag_protocol(dp, dst->tag_ops);
 	dp->dst = dst;
 
+	/* At this point, the tree may be configured to use a different
+	 * tagger than the one chosen by the switch driver during
+	 * .setup, in the case when a user selects a custom protocol
+	 * through the DT.
+	 *
+	 * This is resolved by syncing the driver with the tree in
+	 * dsa_switch_setup_tag_protocol once .setup has run and the
+	 * driver is ready to accept calls to .change_tag_protocol. If
+	 * the driver does not support the custom protocol at that
+	 * point, the tree is wholly rejected, thereby ensuring that the
+	 * tree and driver are always in agreement on the protocol to
+	 * use.
+	 */
 	return 0;
 }
 
@@ -1117,12 +1184,14 @@ static int dsa_port_parse_of(struct dsa_port *dp, struct device_node *dn)
 
 	if (ethernet) {
 		struct net_device *master;
+		const char *user_protocol;
 
 		master = of_find_net_device_by_node(ethernet);
 		if (!master)
 			return -EPROBE_DEFER;
 
-		return dsa_port_parse_cpu(dp, master);
+		user_protocol = of_get_property(dn, "dsa-tag-protocol", NULL);
+		return dsa_port_parse_cpu(dp, master, user_protocol);
 	}
 
 	if (link)
@@ -1234,7 +1303,7 @@ static int dsa_port_parse(struct dsa_port *dp, const char *name,
 
 		dev_put(master);
 
-		return dsa_port_parse_cpu(dp, master);
+		return dsa_port_parse_cpu(dp, master, NULL);
 	}
 
 	if (!strcmp(name, "dsa"))
-- 
2.25.1

