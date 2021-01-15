Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62CB2F7065
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 03:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731959AbhAOCMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 21:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725833AbhAOCMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 21:12:32 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B49FC0613CF
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 18:11:51 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id jx16so11126011ejb.10
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 18:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a/vNDnL0asBweqdbMls6hQ9Cg224lZdZsBecsc1kqlw=;
        b=Q3FfE8kU3nmfz2FyTAvwvDaEwfK/sTcPiOxeL7jH8aYo8yVi0ySQZleMUsXAIDa2KN
         yUJk4jzZTYaWp5omM4jWlRA5UNFABKqMTpMI8gNruord/9X2rHqX0hxQlXdnN0qzV+n1
         mXCLIResGCgtQuTfXc7Z/xvBUHUeSaRuUWv3krkcQ9ED96j82FloBb1RUMOJnoBtBwEZ
         I98Px5oMbaXH3mVodTEIsWN66+8eXQsQr2b0kcoCcU/2asujJZlm3LyO4Jovd7ejVok4
         ZMuhf0diI4csU4ix+oTRmOBviRju6TWmKcT3Q3XV61qurrV7iquyxKrvlJFVfzRh5YAP
         CCYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a/vNDnL0asBweqdbMls6hQ9Cg224lZdZsBecsc1kqlw=;
        b=otHEoTuWRCOXgWSSeMMD6S8bwSS0IBGu1QPqGwIOyJGIrzKO+x/m6vC9dRvxnNANUv
         TfcZek45o35FbZ+MgZXEIe3M3ZD+kFAFk2ODtoFjSnGNi6HYzfkaofmIQQ59NXoJgTLR
         EFzU3lGERUJKHOQ8dSaWl/0GWyLQE+5oNg1cXaf0etJ1hFyLcIdGsSPw9DgbYjDXdbOn
         WR/LHWTQhhZUaufnd3j2SfVdA7Wu/ZST4MeS3uKssmbwPz45ViQL9X79NhJGxMSKQmOX
         WKoxl+R6B1x+64rU6QGATAzUIpwRGSqQJHDcN19pnhVmljMJrJKS7RJ7jslhfks2ItEX
         1y0w==
X-Gm-Message-State: AOAM5311J6wDQGJdii4R92KDnGMvY+hZK5Nt+s8OqT6qxrQxtjHS/tZF
        i1rAYzBy6rbdZ3I/utX8OaSypz9jpVg=
X-Google-Smtp-Source: ABdhPJxoBQdyUT7W6Bvih1M7ZYBZpVfYNTSDMlSNAtiYopF5D3IICKG8WP3SsTB9iOkwed8S09nmVQ==
X-Received: by 2002:a17:906:6053:: with SMTP id p19mr7337550ejj.93.1610676710115;
        Thu, 14 Jan 2021 18:11:50 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id oq27sm2596494ejb.108.2021.01.14.18.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 18:11:49 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v6 net-next 03/10] net: dsa: add ops for devlink-sb
Date:   Fri, 15 Jan 2021 04:11:13 +0200
Message-Id: <20210115021120.3055988-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115021120.3055988-1-olteanv@gmail.com>
References: <20210115021120.3055988-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Switches that care about QoS might have hardware support for reserving
buffer pools for individual ports or traffic classes, and configuring
their sizes and thresholds. Through devlink-sb (shared buffers), this is
all configurable, as well as their occupancy being viewable.

Add the plumbing in DSA for these operations.

Individual drivers still need to call devlink_sb_register() with the
shared buffers they want to expose. A helper was not created in DSA for
this purpose (unlike, say, dsa_devlink_params_register), since in my
opinion it does not bring any benefit over plainly calling
devlink_sb_register() directly.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v6:
None.

Changes in v5:
None.

Changes in v4:
None.

Changes in v3:
Use the helpers added by Andrew to convert from devlink and devlink_port
to DSA structures rather than open-coding them.

Changes in v2:
None.

 include/net/dsa.h |  34 ++++++++++
 net/dsa/dsa2.c    | 159 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 192 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 06e3784ec55c..8d0166dde993 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -697,6 +697,40 @@ struct dsa_switch_ops {
 	int	(*devlink_info_get)(struct dsa_switch *ds,
 				    struct devlink_info_req *req,
 				    struct netlink_ext_ack *extack);
+	int	(*devlink_sb_pool_get)(struct dsa_switch *ds,
+				       unsigned int sb_index, u16 pool_index,
+				       struct devlink_sb_pool_info *pool_info);
+	int	(*devlink_sb_pool_set)(struct dsa_switch *ds, unsigned int sb_index,
+				       u16 pool_index, u32 size,
+				       enum devlink_sb_threshold_type threshold_type,
+				       struct netlink_ext_ack *extack);
+	int	(*devlink_sb_port_pool_get)(struct dsa_switch *ds, int port,
+					    unsigned int sb_index, u16 pool_index,
+					    u32 *p_threshold);
+	int	(*devlink_sb_port_pool_set)(struct dsa_switch *ds, int port,
+					    unsigned int sb_index, u16 pool_index,
+					    u32 threshold,
+					    struct netlink_ext_ack *extack);
+	int	(*devlink_sb_tc_pool_bind_get)(struct dsa_switch *ds, int port,
+					       unsigned int sb_index, u16 tc_index,
+					       enum devlink_sb_pool_type pool_type,
+					       u16 *p_pool_index, u32 *p_threshold);
+	int	(*devlink_sb_tc_pool_bind_set)(struct dsa_switch *ds, int port,
+					       unsigned int sb_index, u16 tc_index,
+					       enum devlink_sb_pool_type pool_type,
+					       u16 pool_index, u32 threshold,
+					       struct netlink_ext_ack *extack);
+	int	(*devlink_sb_occ_snapshot)(struct dsa_switch *ds,
+					   unsigned int sb_index);
+	int	(*devlink_sb_occ_max_clear)(struct dsa_switch *ds,
+					    unsigned int sb_index);
+	int	(*devlink_sb_occ_port_pool_get)(struct dsa_switch *ds, int port,
+						unsigned int sb_index, u16 pool_index,
+						u32 *p_cur, u32 *p_max);
+	int	(*devlink_sb_occ_tc_port_bind_get)(struct dsa_switch *ds, int port,
+						   unsigned int sb_index, u16 tc_index,
+						   enum devlink_sb_pool_type pool_type,
+						   u32 *p_cur, u32 *p_max);
 
 	/*
 	 * MTU change functionality. Switches can also adjust their MRU through
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index fd343466df27..9b84f9ef089a 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -459,8 +459,165 @@ static int dsa_devlink_info_get(struct devlink *dl,
 	return -EOPNOTSUPP;
 }
 
+static int dsa_devlink_sb_pool_get(struct devlink *dl,
+				   unsigned int sb_index, u16 pool_index,
+				   struct devlink_sb_pool_info *pool_info)
+{
+	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
+
+	if (!ds->ops->devlink_sb_pool_get)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_pool_get(ds, sb_index, pool_index,
+					    pool_info);
+}
+
+static int dsa_devlink_sb_pool_set(struct devlink *dl, unsigned int sb_index,
+				   u16 pool_index, u32 size,
+				   enum devlink_sb_threshold_type threshold_type,
+				   struct netlink_ext_ack *extack)
+{
+	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
+
+	if (!ds->ops->devlink_sb_pool_set)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_pool_set(ds, sb_index, pool_index, size,
+					    threshold_type, extack);
+}
+
+static int dsa_devlink_sb_port_pool_get(struct devlink_port *dlp,
+					unsigned int sb_index, u16 pool_index,
+					u32 *p_threshold)
+{
+	struct dsa_switch *ds = dsa_devlink_port_to_ds(dlp);
+	int port = dsa_devlink_port_to_port(dlp);
+
+	if (!ds->ops->devlink_sb_port_pool_get)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_port_pool_get(ds, port, sb_index,
+						 pool_index, p_threshold);
+}
+
+static int dsa_devlink_sb_port_pool_set(struct devlink_port *dlp,
+					unsigned int sb_index, u16 pool_index,
+					u32 threshold,
+					struct netlink_ext_ack *extack)
+{
+	struct dsa_switch *ds = dsa_devlink_port_to_ds(dlp);
+	int port = dsa_devlink_port_to_port(dlp);
+
+	if (!ds->ops->devlink_sb_port_pool_set)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_port_pool_set(ds, port, sb_index,
+						 pool_index, threshold, extack);
+}
+
+static int
+dsa_devlink_sb_tc_pool_bind_get(struct devlink_port *dlp,
+				unsigned int sb_index, u16 tc_index,
+				enum devlink_sb_pool_type pool_type,
+				u16 *p_pool_index, u32 *p_threshold)
+{
+	struct dsa_switch *ds = dsa_devlink_port_to_ds(dlp);
+	int port = dsa_devlink_port_to_port(dlp);
+
+	if (!ds->ops->devlink_sb_tc_pool_bind_get)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_tc_pool_bind_get(ds, port, sb_index,
+						    tc_index, pool_type,
+						    p_pool_index, p_threshold);
+}
+
+static int
+dsa_devlink_sb_tc_pool_bind_set(struct devlink_port *dlp,
+				unsigned int sb_index, u16 tc_index,
+				enum devlink_sb_pool_type pool_type,
+				u16 pool_index, u32 threshold,
+				struct netlink_ext_ack *extack)
+{
+	struct dsa_switch *ds = dsa_devlink_port_to_ds(dlp);
+	int port = dsa_devlink_port_to_port(dlp);
+
+	if (!ds->ops->devlink_sb_tc_pool_bind_set)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_tc_pool_bind_set(ds, port, sb_index,
+						    tc_index, pool_type,
+						    pool_index, threshold,
+						    extack);
+}
+
+static int dsa_devlink_sb_occ_snapshot(struct devlink *dl,
+				       unsigned int sb_index)
+{
+	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
+
+	if (!ds->ops->devlink_sb_occ_snapshot)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_occ_snapshot(ds, sb_index);
+}
+
+static int dsa_devlink_sb_occ_max_clear(struct devlink *dl,
+					unsigned int sb_index)
+{
+	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
+
+	if (!ds->ops->devlink_sb_occ_max_clear)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_occ_max_clear(ds, sb_index);
+}
+
+static int dsa_devlink_sb_occ_port_pool_get(struct devlink_port *dlp,
+					    unsigned int sb_index,
+					    u16 pool_index, u32 *p_cur,
+					    u32 *p_max)
+{
+	struct dsa_switch *ds = dsa_devlink_port_to_ds(dlp);
+	int port = dsa_devlink_port_to_port(dlp);
+
+	if (!ds->ops->devlink_sb_occ_port_pool_get)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_occ_port_pool_get(ds, port, sb_index,
+						     pool_index, p_cur, p_max);
+}
+
+static int
+dsa_devlink_sb_occ_tc_port_bind_get(struct devlink_port *dlp,
+				    unsigned int sb_index, u16 tc_index,
+				    enum devlink_sb_pool_type pool_type,
+				    u32 *p_cur, u32 *p_max)
+{
+	struct dsa_switch *ds = dsa_devlink_port_to_ds(dlp);
+	int port = dsa_devlink_port_to_port(dlp);
+
+	if (!ds->ops->devlink_sb_occ_tc_port_bind_get)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_occ_tc_port_bind_get(ds, port,
+							sb_index, tc_index,
+							pool_type, p_cur,
+							p_max);
+}
+
 static const struct devlink_ops dsa_devlink_ops = {
-	.info_get = dsa_devlink_info_get,
+	.info_get			= dsa_devlink_info_get,
+	.sb_pool_get			= dsa_devlink_sb_pool_get,
+	.sb_pool_set			= dsa_devlink_sb_pool_set,
+	.sb_port_pool_get		= dsa_devlink_sb_port_pool_get,
+	.sb_port_pool_set		= dsa_devlink_sb_port_pool_set,
+	.sb_tc_pool_bind_get		= dsa_devlink_sb_tc_pool_bind_get,
+	.sb_tc_pool_bind_set		= dsa_devlink_sb_tc_pool_bind_set,
+	.sb_occ_snapshot		= dsa_devlink_sb_occ_snapshot,
+	.sb_occ_max_clear		= dsa_devlink_sb_occ_max_clear,
+	.sb_occ_port_pool_get		= dsa_devlink_sb_occ_port_pool_get,
+	.sb_occ_tc_port_bind_get	= dsa_devlink_sb_occ_tc_port_bind_get,
 };
 
 static int dsa_switch_setup(struct dsa_switch *ds)
-- 
2.25.1

