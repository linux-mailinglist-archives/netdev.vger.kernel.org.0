Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20D32F62E1
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 15:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbhANOQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 09:16:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbhANOQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 09:16:36 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14C2C0613D3
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 06:15:45 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id n26so8363141eju.6
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 06:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L4GJvDSQBUrI92/SC8RFllHg49RO8IXTDGNfnp31Ei8=;
        b=ZELt1SB0BWdXB4u5MuCTWN0OI/PP55Ktidtlg8HRg3gJllGFJJrzXQN2z8i0a4WJeO
         7CD0PdpMBHEmLsSqrE48W8tFu0aPCVEXwW04TILTApzuUWhw+/CgkDMPNFWrZWdyReX8
         IsP9nYKr+gkuc/pG3ShxyQMqD1yck/u6ojJnctrFXk6HJc3/52T0UbIOZnzIcan8iX4c
         r1weuEKgt2TPOjhTYLhP0OSQC4rWbkXk+Q73Wr/2AO8eaQFqH34uT5NvKKVvTMd/Nswa
         owublMTSZf/d1CjWDJNCP16MjMf/wuTpoKs+vnzhG4WCBAtB4p5jUkBFdHTZfDFP/b3T
         0VUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L4GJvDSQBUrI92/SC8RFllHg49RO8IXTDGNfnp31Ei8=;
        b=Y4OYXlv6zDfMPgql3ejs92MpOvosIeXwZj98RC915lqnvQ3MdSXTy8dxLqmdaaP8pI
         dN27F+7kaUsfQjnqCn/597Kz6Mq4jiStSfRC16u05k+h8cv+x91lNtEm88iGD4AfZjRu
         T9ECrvfAik0zyJmtYVhV1iOlgR6gAs9vNK0M74TAaSU1tRMX/mglg1AdrTC01ALmRwMd
         17YvLVq+NVsjECTqPjRVB0kJTEeLf17j36zUnhP86lrJUCRtN/PxcKOemGubCwlxuYcW
         6STxFIfm2OHeZwwqEwoQAh5oDvkQcAyX9svZf8Esp5v3k657NKWt3BfLMkuTg0yG0SnM
         Fgdg==
X-Gm-Message-State: AOAM532u1qb3e+G30uETSkTPzEvkAoFiAql2mifARhOCLS1NRnVgopV/
        Ezt7Wb2c0h9chPF5QaQLWuThks50780=
X-Google-Smtp-Source: ABdhPJzhPcAQ8SR7dO1hIUZs1ea5ClTtboct+l+bRosXGSThgFmx1F1vIKAziTIUl6fLw4EO/ChNPA==
X-Received: by 2002:a17:906:edd1:: with SMTP id sb17mr5310130ejb.118.1610633744344;
        Thu, 14 Jan 2021 06:15:44 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id hr3sm773535ejc.41.2021.01.14.06.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 06:15:43 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v5 net-next 03/10] net: dsa: add ops for devlink-sb
Date:   Thu, 14 Jan 2021 16:15:15 +0200
Message-Id: <20210114141522.2478059-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210114141522.2478059-1-olteanv@gmail.com>
References: <20210114141522.2478059-1-olteanv@gmail.com>
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
index c3485ba6c312..7bf8b0432971 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -647,6 +647,40 @@ struct dsa_switch_ops {
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
index 01f21b0b379a..c05b1b54c4f7 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -400,8 +400,165 @@ static int dsa_devlink_info_get(struct devlink *dl,
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

