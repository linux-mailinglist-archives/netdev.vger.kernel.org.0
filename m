Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A99A49A065
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 00:29:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1843903AbiAXXGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 18:06:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355869AbiAXWzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 17:55:55 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D15C0680B9
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 13:10:04 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id b9so3520344lfq.6
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 13:10:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=18KJwP2b3bz21HNcarg1aueiUUVE21tAdU9ddUfz3qA=;
        b=OsU66u99/x9BMUkHF9xzX6B+3gW1+rFX/a5ajDSKkmI+Ml+RsGLwJcN7JhZK+OT7dm
         cU8aqIG3qqoDrU87ET/8ybgc7Jm5cqpBemP3uHyJGEKWFA0QY7LNJ1ESp3A3/qdm4Fip
         kC0V31Xmqgd4rJ+ELdHRdnexUMoExv+HeUz5qiMdyydSC36Qz5iyCMNDR7fLJZnzSAoE
         pI+YTJOUwp9lIRfNxLNe7FUgbuTropK2DhTsfHQfQG5bQIppNMU+kAwK6SjIBLDYlleD
         B00RxjzHjF7oDhMSanZlXxBIHPMI5+KwX4k4yfQlCe3FPPW4OJmwz7zsvNFhMu76XY2j
         8Q8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=18KJwP2b3bz21HNcarg1aueiUUVE21tAdU9ddUfz3qA=;
        b=42MR5wJrxG+zIHA7ekmNoF1d495Y9hJCbUmTg+XcbU15vdEacVYLPMy8ysFNk6v++L
         xIZg8+8qr0tlT3PYmwbsh+/XybfO9mW4Kw0MMSmIMXufsLIP8uv88RJPoAXLuGqtsX01
         Abbwsx/rf68BxBdKrfJ+7m3+G518H2qSLW7QG5Xl2RjFpagoKcdLxITTBiAcO3MfkD3o
         ztgmwPwuP0dNPz2g3gxi2sJZb/VtQuOiyLLCtLy38umZjE0UqPmncAzm2NUBCHoqXtNq
         PhVoidsge31OzLe42syp3vTD9lWfvMez86914SPttX5Jw7F8+KaPAza6xxgMEx18QYPO
         xuJw==
X-Gm-Message-State: AOAM533LHUDRRgB6jvXnp7Hj+jae3dYQ/mhQ35nEWgESM6v+Oz9zQYRr
        0XssZw5Lvrhn7tz8Cqpm7uPS7Q==
X-Google-Smtp-Source: ABdhPJx1pyioZV8vVJaZ/osAiGzQwUgAQxRhIch0itGT6l2sjz4Li/Ml+l5UapkdJMtwl+taHu1mOQ==
X-Received: by 2002:a05:6512:33d1:: with SMTP id d17mr6920429lfg.647.1643058602643;
        Mon, 24 Jan 2022 13:10:02 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id t12sm1009115ljj.118.2022.01.24.13.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 13:10:02 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 1/2] net: dsa: Move VLAN filtering syncing out of dsa_switch_bridge_leave
Date:   Mon, 24 Jan 2022 22:09:43 +0100
Message-Id: <20220124210944.3749235-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220124210944.3749235-1-tobias@waldekranz.com>
References: <20220124210944.3749235-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of dsa_switch_bridge_leave was, in fact, dealing with the syncing
of VLAN filtering for switches on which that is a global
setting. Separate the two phases to prepare for the cross-chip related
bugfix in the following commit.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 net/dsa/switch.c | 38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index e3c7d2627a61..9f9b70d6070a 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -113,26 +113,15 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 	return dsa_tag_8021q_bridge_join(ds, info);
 }
 
-static int dsa_switch_bridge_leave(struct dsa_switch *ds,
-				   struct dsa_notifier_bridge_info *info)
+static int dsa_switch_sync_vlan_filtering(struct dsa_switch *ds,
+					  struct dsa_notifier_bridge_info *info)
 {
-	struct dsa_switch_tree *dst = ds->dst;
 	struct netlink_ext_ack extack = {0};
 	bool change_vlan_filtering = false;
 	bool vlan_filtering;
 	struct dsa_port *dp;
 	int err;
 
-	if (dst->index == info->tree_index && ds->index == info->sw_index &&
-	    ds->ops->port_bridge_leave)
-		ds->ops->port_bridge_leave(ds, info->port, info->bridge);
-
-	if ((dst->index != info->tree_index || ds->index != info->sw_index) &&
-	    ds->ops->crosschip_bridge_leave)
-		ds->ops->crosschip_bridge_leave(ds, info->tree_index,
-						info->sw_index, info->port,
-						info->bridge);
-
 	if (ds->needs_standalone_vlan_filtering &&
 	    !br_vlan_enabled(info->bridge.dev)) {
 		change_vlan_filtering = true;
@@ -172,6 +161,29 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 			return err;
 	}
 
+	return 0;
+}
+
+static int dsa_switch_bridge_leave(struct dsa_switch *ds,
+				   struct dsa_notifier_bridge_info *info)
+{
+	struct dsa_switch_tree *dst = ds->dst;
+	int err;
+
+	if (dst->index == info->tree_index && ds->index == info->sw_index &&
+	    ds->ops->port_bridge_leave)
+		ds->ops->port_bridge_leave(ds, info->port, info->bridge);
+
+	if ((dst->index != info->tree_index || ds->index != info->sw_index) &&
+	    ds->ops->crosschip_bridge_leave)
+		ds->ops->crosschip_bridge_leave(ds, info->tree_index,
+						info->sw_index, info->port,
+						info->bridge);
+
+	err = dsa_switch_sync_vlan_filtering(ds, info);
+	if (err)
+		return err;
+
 	return dsa_tag_8021q_bridge_leave(ds, info);
 }
 
-- 
2.25.1

