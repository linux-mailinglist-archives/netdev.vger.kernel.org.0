Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D29B2EF6E4
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbhAHSDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 13:03:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728505AbhAHSDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 13:03:16 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE93DC0612FD
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 10:02:35 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id i24so12036300edj.8
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 10:02:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wYb466xgD2XK0n7/TGo5doWD9P4goiLTKDL7CbyCG98=;
        b=ionIBHsaN5zETYBAXBvCwCQowvbuwGA9jYYxKPlO4gBRyONhmoXEzvB2XnLfnGhcmp
         /d09KcR5ogUTM8wlln+lPAUx4sJT4TXIYyHcnhqB16b1o4vcXQmM7YceTOJDyFNtIpJ0
         pApOYiYjOn3BoEkvR7d5iYc14XSLGs46XBKN1VX3zUdOYXXSmWY/WF7rlTWuL772A9+d
         Ba6Uy3lyb60Z705CW98AorPBTewvK6EIEsjR5cT0MIQ8hCCgxh3utt1YkBqf8MWU16+I
         HW6hxUtTa6yrHO3KtXAkvIE9kQIa+9WRJ7R+axXavvRhlC0Sfvgj9OiN1tt46TB6HBQS
         4Lrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wYb466xgD2XK0n7/TGo5doWD9P4goiLTKDL7CbyCG98=;
        b=MhPdMi+azCpEwj3kBbu0I6PIx0sHG8UIzWU7OB2u65P5tZe0B0lq/E6CWCldZyIM3e
         5wmZ2t3OXhOKc3BAQYzx2vPC/tCMLnDFkr5/HqgDyuhf4vySX1rxVkSdvxGA9ukG0WYH
         qwnbnomsulCIpnVBG266EGGkaqqiO3fgOk93kGvAuDZ/XWW9Q8r6Lk3uKnLIO7Hbl7ay
         iRYRMvpuJqOOENjhDezrC85tkCnvtio+/RUja2e6T2ndLTHDDqTN+M1T/9RxAPmDOTW9
         G40eni7PNOZnRovAOiMaCsSIBcKxKtq4YvpiCQyjxdQGiuCvSg8HwL/P1M7H6RKOBiny
         d/AA==
X-Gm-Message-State: AOAM532MgAIhWcJj7FIvQ2kjTyIXW+0Sm4mPxqh+Q2lXkTkrtXq9dBTU
        SrP+9jjmmwVo5MFmt+Gp3YXlUWD/q3A=
X-Google-Smtp-Source: ABdhPJwGNinSLlC94HjujkhgWay9uOr3zMHnf2lxuo9fsZp0LG0xECBZWS8CWogwfs5EneBPZPZ4RQ==
X-Received: by 2002:a50:e719:: with SMTP id a25mr6089548edn.12.1610128954345;
        Fri, 08 Jan 2021 10:02:34 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id b19sm4059713edx.47.2021.01.08.10.02.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 10:02:33 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [PATCH v3 net-next 03/10] net: dsa: add ops for devlink-sb
Date:   Fri,  8 Jan 2021 19:59:43 +0200
Message-Id: <20210108175950.484854-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108175950.484854-1-olteanv@gmail.com>
References: <20210108175950.484854-1-olteanv@gmail.com>
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
Changes in v3:
Use the helpers added by Andrew to convert from devlink and devlink_port
to DSA structures rather than open-coding them.

Changes in v2:
None.

 include/net/dsa.h |  34 ++++++++++
 net/dsa/dsa2.c    | 159 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 192 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 9a0cab5fb7c4..b64fd53d7fce 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -650,6 +650,40 @@ struct dsa_switch_ops {
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

