Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88B4F2ED593
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729101AbhAGR2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:28:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729088AbhAGR2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 12:28:21 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB0A1C0612F8
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 09:27:40 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id t16so10675335ejf.13
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 09:27:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sahUZlwUfWQXJzrqTTFDyC7Swnw2ADlixMJbzXh5Z4w=;
        b=ftu2d0qYwmbuGpxISCNh8j60U9L41Csc0GQQt1LEX6DYtJOdXzA3aKB9ln485hyHzC
         nAwff3L8s+S+q4mVofvNdL6S6MTVKnfD3izzTapyoKRt7hd83eg0ydrjyyroSru5V/Kf
         BSCzurymUmz2iaMuRQmo4Y3GsyF2TFr1n8CNQCIcdCHP3rheXK7pFn/jynyfa+6wUhQ1
         GJvyUM+Zf8KFtGfT3OdEL/R5P7wkB65PKZZdkM/Ovd+goUzR9+ocE+50ZVI3DG9d1Bmt
         BNcRGY/lzGHskK+CB1mx4+kuLq4uGOBEkMLaXCAeklUcsB8purtsSDXMbbrNF5XCGD00
         py5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sahUZlwUfWQXJzrqTTFDyC7Swnw2ADlixMJbzXh5Z4w=;
        b=JnUsGdxEjO5qDCFrvNERwVHgSc9abu5xdnrp+C5Nv+dpwkQ3WwfA7/PjL7J/emdukp
         VCYB2xB2yXbljAD9QVxpaAHfPCqcRtoP70LYQk4rqGFOMQgfWGqVi8Dw6q+3F5TY130k
         q6kD0KwLEv8BkFht1NOXIWW8udzCFUICsoiK1/HMzjd04DoB+xBLh5LrZ4cboVNc0M+L
         +R2W6jSelzM8i+YYzzgOLuiSuszVW28jtnyubkdKT3doJLOnn6uxDbhmxWBMGCSwt8QT
         84UOvnjaDAMd/YXQjSKqeEMNBsvG0Y/tNzbAYydf0LuN0VPZuQkLDnKRUufKJIWHKeth
         0xbQ==
X-Gm-Message-State: AOAM532BAWtHZ4EEkCUYfa3OOcLh87HW/KhM07imJefOgRJKXEoM8+79
        3+h+UjpnFsQMG7vxyCtHXYQgsUighgU=
X-Google-Smtp-Source: ABdhPJw7BEz4EVWU8UCswTPmnaUG48E+ePlVQsSUPocmRpcJc+LxEBtoqKo/eoHXhrXSbDzfG0jwHw==
X-Received: by 2002:a17:906:1719:: with SMTP id c25mr7293164eje.251.1610040459368;
        Thu, 07 Jan 2021 09:27:39 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id y14sm2643351eju.115.2021.01.07.09.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 09:27:38 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net-next 03/10] net: dsa: add ops for devlink-sb
Date:   Thu,  7 Jan 2021 19:27:19 +0200
Message-Id: <20210107172726.2420292-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107172726.2420292-1-olteanv@gmail.com>
References: <20210107172726.2420292-1-olteanv@gmail.com>
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
---
Changes in v2:
None.

 include/net/dsa.h |  34 +++++++++
 net/dsa/dsa2.c    | 174 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 207 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 4e60d2610f20..79e67c22a267 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -645,6 +645,40 @@ struct dsa_switch_ops {
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
index 01f21b0b379a..4e3da5ce3cc3 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -400,8 +400,180 @@ static int dsa_devlink_info_get(struct devlink *dl,
 	return -EOPNOTSUPP;
 }
 
+static struct dsa_port *devlink_to_dsa_port(struct devlink_port *dlp)
+{
+	return container_of(dlp, struct dsa_port, devlink_port);
+}
+
+static int dsa_devlink_sb_pool_get(struct devlink *dl,
+				   unsigned int sb_index, u16 pool_index,
+				   struct devlink_sb_pool_info *pool_info)
+{
+	struct dsa_devlink_priv *dl_priv = devlink_priv(dl);
+	struct dsa_switch *ds = dl_priv->ds;
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
+	struct dsa_devlink_priv *dl_priv = devlink_priv(dl);
+	struct dsa_switch *ds = dl_priv->ds;
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
+	struct dsa_devlink_priv *dl_priv = devlink_priv(dlp->devlink);
+	struct dsa_port *dp = devlink_to_dsa_port(dlp);
+	struct dsa_switch *ds = dl_priv->ds;
+
+	if (!ds->ops->devlink_sb_port_pool_get)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_port_pool_get(ds, dp->index, sb_index,
+						 pool_index, p_threshold);
+}
+
+static int dsa_devlink_sb_port_pool_set(struct devlink_port *dlp,
+					unsigned int sb_index, u16 pool_index,
+					u32 threshold,
+					struct netlink_ext_ack *extack)
+{
+	struct dsa_devlink_priv *dl_priv = devlink_priv(dlp->devlink);
+	struct dsa_port *dp = devlink_to_dsa_port(dlp);
+	struct dsa_switch *ds = dl_priv->ds;
+
+	if (!ds->ops->devlink_sb_port_pool_set)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_port_pool_set(ds, dp->index, sb_index,
+						 pool_index, threshold, extack);
+}
+
+static int
+dsa_devlink_sb_tc_pool_bind_get(struct devlink_port *dlp,
+				unsigned int sb_index, u16 tc_index,
+				enum devlink_sb_pool_type pool_type,
+				u16 *p_pool_index, u32 *p_threshold)
+{
+	struct dsa_devlink_priv *dl_priv = devlink_priv(dlp->devlink);
+	struct dsa_port *dp = devlink_to_dsa_port(dlp);
+	struct dsa_switch *ds = dl_priv->ds;
+
+	if (!ds->ops->devlink_sb_tc_pool_bind_get)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_tc_pool_bind_get(ds, dp->index, sb_index,
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
+	struct dsa_devlink_priv *dl_priv = devlink_priv(dlp->devlink);
+	struct dsa_port *dp = devlink_to_dsa_port(dlp);
+	struct dsa_switch *ds = dl_priv->ds;
+
+	if (!ds->ops->devlink_sb_tc_pool_bind_set)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_tc_pool_bind_set(ds, dp->index, sb_index,
+						    tc_index, pool_type,
+						    pool_index, threshold,
+						    extack);
+}
+
+static int dsa_devlink_sb_occ_snapshot(struct devlink *dl,
+				       unsigned int sb_index)
+{
+	struct dsa_devlink_priv *dl_priv = devlink_priv(dl);
+	struct dsa_switch *ds = dl_priv->ds;
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
+	struct dsa_devlink_priv *dl_priv = devlink_priv(dl);
+	struct dsa_switch *ds = dl_priv->ds;
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
+	struct dsa_devlink_priv *dl_priv = devlink_priv(dlp->devlink);
+	struct dsa_port *dp = devlink_to_dsa_port(dlp);
+	struct dsa_switch *ds = dl_priv->ds;
+
+	if (!ds->ops->devlink_sb_occ_port_pool_get)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_occ_port_pool_get(ds, dp->index, sb_index,
+						     pool_index, p_cur, p_max);
+}
+
+static int
+dsa_devlink_sb_occ_tc_port_bind_get(struct devlink_port *dlp,
+				    unsigned int sb_index, u16 tc_index,
+				    enum devlink_sb_pool_type pool_type,
+				    u32 *p_cur, u32 *p_max)
+{
+	struct dsa_devlink_priv *dl_priv = devlink_priv(dlp->devlink);
+	struct dsa_port *dp = devlink_to_dsa_port(dlp);
+	struct dsa_switch *ds = dl_priv->ds;
+
+	if (!ds->ops->devlink_sb_occ_tc_port_bind_get)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_sb_occ_tc_port_bind_get(ds, dp->index,
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

