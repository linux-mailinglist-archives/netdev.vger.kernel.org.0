Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E82D338F77
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 15:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbhCLOJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 09:09:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbhCLOIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 09:08:45 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D72FC061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 06:08:45 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id h10so8108768edt.13
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 06:08:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5+tXJVrMLWwYOqg6F3VnfGFM4+qLjaBUMSx7jGIJJFA=;
        b=b5NsyBXVjm3dgF+QcalL2RcVjvO1XQZGCCBIWuvvkmPSOBQhKfVzi63pja5VlAWDga
         AJzKGGJDdMTbGzue5h+Z+doRdx8cVdBAQKTeZnVDoo2+JcIAk6MCr2yShP72lH3+zcnJ
         /ixrZq2SiCnGcKHwcsRoTtkC8WiojMd+injvmZdV2gfLQgzmpfU8uLXE54pgH28hrzqr
         Sa5UsQIljZYcMkKg8eSspJFDW0OMJ+TnR+kM/bQzj/cSsKT91nKaUo28jmsnmOiJX44y
         o798fAHiUPr3cB8HmS6jhMLtDS1ty49E9GkYgvS1GqsB5Y9i+F9OYWHH8UnQbTACKl4/
         CQBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5+tXJVrMLWwYOqg6F3VnfGFM4+qLjaBUMSx7jGIJJFA=;
        b=W/2Z8SZms+hMunWHDFlk0b9W0BBu2icDS8fpdnI/6WwtFHm7neDTLrAhMkymBf9AtF
         wS/eETsUxOlF8/iZrpQcnLcdNFdZo2/R2lXY7o4tRpTEOF7Gno0Bf1UB4U3XZOWizFvD
         1In5evb0QLg2s42h8yFvv50OPX4hF3uICoERrmf8xhBxYifk0pqplzievpME37LuG912
         eyyymGjbujloW0738x58WSRZsgH7ZhMwDfueVJea6h2VttxLu1FeMeZLXEp+zW4cbZ/M
         oAKv8lqJMzrKm5fafjSw2HwIp5qu8t4WkFoP9cLGd43mGWzDH5fYb6ZqOBGIQewZHNh+
         imtA==
X-Gm-Message-State: AOAM532XFfdkZXd4CfQ5SCjMKEj1sRbuGzHZxtdFwLE7p5kg43Pq68we
        5JrMoW5kY+k9Ipqi9JM712eeKA==
X-Google-Smtp-Source: ABdhPJyyWnYz9JqMkAtD5TWqJTC9fr7zsL4Jaj9XpdM2vFwSPobJBUYJ3fMYfgZbauD+dou4mqbrcw==
X-Received: by 2002:a05:6402:3593:: with SMTP id y19mr14325482edc.317.1615558124332;
        Fri, 12 Mar 2021 06:08:44 -0800 (PST)
Received: from madeliefje.horms.nl ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id s11sm3031673edt.27.2021.03.12.06.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 06:08:43 -0800 (PST)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Xingfeng Hu <xingfeng.hu@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@netronome.com>,
        Simon Horman <simon.horman@netronome.com>
Subject: [PATCH v3 net-next 2/3] flow_offload: reject configuration of packet-per-second policing in offload drivers
Date:   Fri, 12 Mar 2021 15:08:30 +0100
Message-Id: <20210312140831.23346-3-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210312140831.23346-1-simon.horman@netronome.com>
References: <20210312140831.23346-1-simon.horman@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

A follow-up patch will allow users to configures packet-per-second policing
in the software datapath. In preparation for this, teach all drivers that
support offload of the policer action to reject such configuration as
currently none of them support it.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Louis Peens <louis.peens@netronome.com>
---
 drivers/net/dsa/sja1105/sja1105_flower.c              |  6 ++++++
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c    | 11 ++++++++++-
 drivers/net/ethernet/freescale/enetc/enetc_qos.c      |  5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c       |  4 ++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c |  5 +++++
 drivers/net/ethernet/mscc/ocelot_flower.c             |  5 +++++
 drivers/net/ethernet/mscc/ocelot_net.c                |  6 ++++++
 drivers/net/ethernet/netronome/nfp/flower/qos_conf.c  |  5 +++++
 8 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
index 12e76020bea3..f78b767f86ee 100644
--- a/drivers/net/dsa/sja1105/sja1105_flower.c
+++ b/drivers/net/dsa/sja1105/sja1105_flower.c
@@ -322,6 +322,12 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 	flow_action_for_each(i, act, &rule->action) {
 		switch (act->id) {
 		case FLOW_ACTION_POLICE:
+			if (act->police.rate_pkt_ps) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "QoS offload not support packets per second");
+				goto out;
+			}
+
 			rc = sja1105_flower_policer(priv, port, extack, cookie,
 						    &key,
 						    act->police.rate_bytes_ps,
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
index 2e309f6673f7..28fd2de9e4cf 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
@@ -48,6 +48,11 @@ static int cxgb4_matchall_egress_validate(struct net_device *dev,
 	flow_action_for_each(i, entry, actions) {
 		switch (entry->id) {
 		case FLOW_ACTION_POLICE:
+			if (entry->police.rate_pkt_ps) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "QoS offload not support packets per second");
+				return -EOPNOTSUPP;
+			}
 			/* Convert bytes per second to bits per second */
 			if (entry->police.rate_bytes_ps * 8 > max_link_rate) {
 				NL_SET_ERR_MSG_MOD(extack,
@@ -145,7 +150,11 @@ static int cxgb4_matchall_alloc_tc(struct net_device *dev,
 	flow_action_for_each(i, entry, &cls->rule->action)
 		if (entry->id == FLOW_ACTION_POLICE)
 			break;
-
+	if (entry->police.rate_pkt_ps) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "QoS offload not support packets per second");
+		return -EOPNOTSUPP;
+	}
 	/* Convert from bytes per second to Kbps */
 	p.u.params.maxrate = div_u64(entry->police.rate_bytes_ps * 8, 1000);
 	p.u.params.channel = pi->tx_chan;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index a9aee219fb58..cb7fa4bceaf2 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -1221,6 +1221,11 @@ static int enetc_psfp_parse_clsflower(struct enetc_ndev_priv *priv,
 
 	/* Flow meter and max frame size */
 	if (entryp) {
+		if (entryp->police.rate_pkt_ps) {
+			NL_SET_ERR_MSG_MOD(extack, "QoS offload not support packets per second");
+			err = -EOPNOTSUPP;
+			goto free_sfi;
+		}
 		if (entryp->police.burst) {
 			fmi = kzalloc(sizeof(*fmi), GFP_KERNEL);
 			if (!fmi) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index dc126389291d..1fe745653a53 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4480,6 +4480,10 @@ static int scan_tc_matchall_fdb_actions(struct mlx5e_priv *priv,
 	flow_action_for_each(i, act, flow_action) {
 		switch (act->id) {
 		case FLOW_ACTION_POLICE:
+			if (act->police.rate_pkt_ps) {
+				NL_SET_ERR_MSG_MOD(extack, "QoS offload not support packets per second");
+				return -EOPNOTSUPP;
+			}
 			err = apply_police_params(priv, act->police.rate_bytes_ps, extack);
 			if (err)
 				return err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index 41855e58564b..ea637fa552f5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -190,6 +190,11 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
 				return -EOPNOTSUPP;
 			}
 
+			if (act->police.rate_pkt_ps) {
+				NL_SET_ERR_MSG_MOD(extack, "QoS offload not support packets per second");
+				return -EOPNOTSUPP;
+			}
+
 			/* The kernel might adjust the requested burst size so
 			 * that it is not exactly a power of two. Re-adjust it
 			 * here since the hardware only supports burst sizes
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index a41b458b1b3e..8b843d3c9189 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -220,6 +220,11 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 						   "Last action must be GOTO");
 				return -EOPNOTSUPP;
 			}
+			if (a->police.rate_pkt_ps) {
+				NL_SET_ERR_MSG_MOD(extack,
+						   "QoS offload not support packets per second");
+				return -EOPNOTSUPP;
+			}
 			filter->action.police_ena = true;
 			rate = a->police.rate_bytes_ps;
 			filter->action.pol.rate = div_u64(rate, 1000) * 8;
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 12cb6867a2d0..c08164cd88f4 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -251,6 +251,12 @@ static int ocelot_setup_tc_cls_matchall(struct ocelot_port_private *priv,
 			return -EEXIST;
 		}
 
+		if (action->police.rate_pkt_ps) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "QoS offload not support packets per second");
+			return -EOPNOTSUPP;
+		}
+
 		pol.rate = (u32)div_u64(action->police.rate_bytes_ps, 1000) * 8;
 		pol.burst = action->police.burst;
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index d4ce8f9ef3cc..88bea6ad59bc 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -104,6 +104,11 @@ nfp_flower_install_rate_limiter(struct nfp_app *app, struct net_device *netdev,
 		return -EOPNOTSUPP;
 	}
 
+	if (action->police.rate_pkt_ps) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: qos rate limit offload not support packets per second");
+		return -EOPNOTSUPP;
+	}
+
 	rate = action->police.rate_bytes_ps;
 	burst = action->police.burst;
 	netdev_port_id = nfp_repr_get_port_id(netdev);
-- 
2.20.1

