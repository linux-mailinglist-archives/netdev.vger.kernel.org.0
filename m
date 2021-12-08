Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B800946CBA2
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 04:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243976AbhLHDo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 22:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243958AbhLHDoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 22:44:24 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1CD5C061574;
        Tue,  7 Dec 2021 19:40:52 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id d24so1752731wra.0;
        Tue, 07 Dec 2021 19:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b8cn7oQwZOY1NLkt25YqaD0FKEKyzuARcsLHWsRjgEo=;
        b=MmDMDZMsqdLewA86WPcz1XxzZJW1lP3wOKUziduIDxy2kqrJEw76FlrpE/lVxP8jHS
         ocuDVvquEw2x78cWkMNOQQ3uxosvk7nN0VtRnf+2JFMPYN29LDN661Rc7bxnXWPPtVj7
         BHhYzMWbFx+MigBd9AyQ37gDP8MLKWmvY1vBFrrandoQTjuv+SV4DWnVVp2JdIBSqQEV
         Ls6nrdfR4RvAkKPFGGzEhUyQZ/D7E42GiPr7ooTJKC7EuKV/G8XxRGcWIaVfv07fIb2Y
         wwijI6GEJlUYEeuPv9Xgd7HJXauPaNS6Gru9gGZT/KKIO54DfZaIT5BwdNf9Q3nsNyMB
         IqGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b8cn7oQwZOY1NLkt25YqaD0FKEKyzuARcsLHWsRjgEo=;
        b=ROnMPg/F6K1Jq8IARBd5J+xutQlS3gZQNJoIR5jYCHojoI6aAqJ8wBm5YZCDRl9IAY
         rLVveJoJbaM1mXURXv/w1OQikz24vYgQv0X9OrtSC7lM6lNRqfv48mr8GDw8pKwPWWl6
         z2pigyA+e3KTMR7ZkJRdSPqKEK0LZgH+7wvwJyUaCZtqC7qTEcwHh5epcqFSKT9Hm50I
         txEU2gAP1yD4jld8RpSppxsRhkLfrYawVn1b9sfOd2pDkxxkkrDpTi/z5VEr7yG9X75x
         1EpvchWtnzhhmQ0pUjGotPVYXZozcoozDKT56ZqQhabanHZtX6ry5v4XOXq6DEFxzN5u
         YIRg==
X-Gm-Message-State: AOAM533q46AUZe6K8rKrzrzDDy+4Pgef1U+OJdIUmOWubaJSm+fzZXKZ
        DesdOq8g/9q1i3UoLg5CLMU=
X-Google-Smtp-Source: ABdhPJyddnvaX3XjQm113X/2y4yE2khZIiCfsCx+WQB0lCJP9Bic6W16tNRsH1Pen0lGxzf1cCo/cw==
X-Received: by 2002:adf:dd0d:: with SMTP id a13mr57377871wrm.259.1638934851243;
        Tue, 07 Dec 2021 19:40:51 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id v6sm4488944wmh.8.2021.12.07.19.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 19:40:51 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next RFC PATCH v2 2/8] net: dsa: Permit dsa driver to configure additional tagger data
Date:   Wed,  8 Dec 2021 04:40:34 +0100
Message-Id: <20211208034040.14457-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211208034040.14457-1-ansuelsmth@gmail.com>
References: <20211208034040.14457-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Permit a dsa driver to configure additional tagger data for the current
active tagger. A new ops is introduced tag_proto_connect() that will be
called on every tagger bind event using the
DSA_NOTIFIER_TAG_PROTO_CONNECT event.

This is used if the driver require to set additional driver or some
handler that the tagger should use to handle special packet.

The dsa driver require to provide explicit support for the current
tagger and to understand the current private data set in the dsa ports.

tag_proto_connect() should parse the tagger proto, check if it does
support it and do the required task to each ports.

An example of this is a dsa driver that supports Ethernet mdio and
require to provide to the tagger a handler function to parse these
packets.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 include/net/dsa.h  |  8 ++++++++
 net/dsa/dsa2.c     | 11 +++++++++++
 net/dsa/dsa_priv.h |  1 +
 net/dsa/switch.c   | 14 ++++++++++++++
 4 files changed, 34 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 33391d74be5c..3af8720e0caf 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -946,6 +946,14 @@ struct dsa_switch_ops {
 	int	(*tag_8021q_vlan_add)(struct dsa_switch *ds, int port, u16 vid,
 				      u16 flags);
 	int	(*tag_8021q_vlan_del)(struct dsa_switch *ds, int port, u16 vid);
+
+	/*
+	 * Tagger connect operations. Use this to set special data/handler
+	 * for the current tagger set. The function require to provide explicit
+	 * support for the current tagger.
+	 */
+	int	(*tag_proto_connect)(struct dsa_switch *ds,
+				     const struct dsa_device_ops *tag_ops);
 };
 
 #define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 15566c5ae8ae..15d6c52dbf53 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1046,6 +1046,7 @@ static void dsa_tree_teardown_lags(struct dsa_switch_tree *dst)
 static int dsa_tree_bind_tag_proto(struct dsa_switch_tree *dst)
 {
 	const struct dsa_device_ops *tag_ops = dst->tag_ops;
+	struct dsa_notifier_tag_proto_info info;
 	int err;
 
 	if (tag_ops->connect) {
@@ -1054,6 +1055,16 @@ static int dsa_tree_bind_tag_proto(struct dsa_switch_tree *dst)
 			return err;
 	}
 
+	info.tag_ops = tag_ops;
+	err = dsa_tree_notify(dst, DSA_NOTIFIER_TAG_PROTO_CONNECT, &info);
+	if (err && err != -EOPNOTSUPP)
+		goto out_disconnect;
+
+	return 0;
+out_disconnect:
+	if (tag_ops->disconnect)
+		tag_ops->disconnect(dst);
+
 	return 0;
 }
 
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 3fb2c37c9b88..e69843c4aa6d 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -37,6 +37,7 @@ enum {
 	DSA_NOTIFIER_VLAN_DEL,
 	DSA_NOTIFIER_MTU,
 	DSA_NOTIFIER_TAG_PROTO,
+	DSA_NOTIFIER_TAG_PROTO_CONNECT,
 	DSA_NOTIFIER_MRP_ADD,
 	DSA_NOTIFIER_MRP_DEL,
 	DSA_NOTIFIER_MRP_ADD_RING_ROLE,
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index bb155a16d454..4b7434d709fb 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -647,6 +647,17 @@ static int dsa_switch_change_tag_proto(struct dsa_switch *ds,
 	return 0;
 }
 
+static int dsa_switch_connect_tag_proto(struct dsa_switch *ds,
+					struct dsa_notifier_tag_proto_info *info)
+{
+	const struct dsa_device_ops *tag_ops = info->tag_ops;
+
+	if (!ds->ops->tag_proto_connect)
+		return -EOPNOTSUPP;
+
+	return ds->ops->tag_proto_connect(ds, tag_ops);
+}
+
 static int dsa_switch_mrp_add(struct dsa_switch *ds,
 			      struct dsa_notifier_mrp_info *info)
 {
@@ -766,6 +777,9 @@ static int dsa_switch_event(struct notifier_block *nb,
 	case DSA_NOTIFIER_TAG_PROTO:
 		err = dsa_switch_change_tag_proto(ds, info);
 		break;
+	case DSA_NOTIFIER_TAG_PROTO_CONNECT:
+		err = dsa_switch_connect_tag_proto(ds, info);
+		break;
 	case DSA_NOTIFIER_MRP_ADD:
 		err = dsa_switch_mrp_add(ds, info);
 		break;
-- 
2.32.0

