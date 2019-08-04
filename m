Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93AF680B61
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 17:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfHDPKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 11:10:35 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35535 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfHDPKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 11:10:33 -0400
Received: by mail-wm1-f67.google.com with SMTP id l2so70694272wmg.0
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 08:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Jg2wyoo3g25hCeZErv+8EFH5iIbv9sukQwz3mMdTMsg=;
        b=FQ0z6GMfVyam+INAAiuoI5obtMXqUDMEb59Jm03s0MQrHLQfqFz025YcAXMmBXCpSo
         h6PQfvCx3+lj38PwmP/ct7hB3xg2/3PE5OUZvyHvNQU8sLbWJDh3OZ8tu5nneqwCmwFd
         gJv4BKI+YrYvNkqeuLUBECsGhXsmB4W90eG7sBrZ9BT4P8w/Y+WxiE7X2ccLWCR3yH4R
         gvhY1jdyms8t4Bj49yhkcAqC7f9NrUobFTGgZTh778uuYtR96T0u3jkYr4tc6n/ZculE
         GVyhepwP3Vh9mpyTXGDAN0T7sA+r/7c+10iil+a+QTuHuJsBZzRii6dDHc1oe75FA7Vm
         LDYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Jg2wyoo3g25hCeZErv+8EFH5iIbv9sukQwz3mMdTMsg=;
        b=fBFMsNYktdlG9OcKa0A99tLEMHUHBbeEH8pE18tFIqqRWm3H8zLCQabSgWdbVezjfi
         6tnalqWZUMDd+OYP4YKH2mxdcnn92bh/PC5GwKVIf3gLELUz5WYmK3hOz111teo2NXcb
         gGEzlA1QhPS3g/G3t3thZMovDjCaWvmdM0IX7XTaRJOuaIFztkyFcKHKS2vxwxqn4LkB
         hJo1lmCrx6TpMBbukgcBqc23OGeK2cCYEcyfSZLRet4GWDBOOzjMWHpu5O5hcpiyBMy4
         MytUd26rCSnbu9Pd/aSw2E4Z4Zf+aAkJgimoMMGjOl1yBrf0ZGe2exPa5+pLJ5L2x1zt
         yUTg==
X-Gm-Message-State: APjAAAWEeCsxBDpnRBQJEtAPiAk9MkBzZFAI81ftrC9Y4pMDssOIPlfd
        XO2MuP4C7UGjgqRH/qDrjKyroefcek8=
X-Google-Smtp-Source: APXvYqz9ueY7TLvUShNkAQVjoRnwSD5fq0TTO7d7mQWeSy4Amg7k7AAFizslmKBxj86d4CLRpzLkgA==
X-Received: by 2002:a7b:c206:: with SMTP id x6mr14106741wmi.156.1564931431701;
        Sun, 04 Aug 2019 08:10:31 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id l9sm63769441wmh.36.2019.08.04.08.10.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 04 Aug 2019 08:10:31 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 08/10] nfp: flower: offload pre-tunnel rules
Date:   Sun,  4 Aug 2019 16:09:10 +0100
Message-Id: <1564931351-1036-9-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564931351-1036-1-git-send-email-john.hurley@netronome.com>
References: <1564931351-1036-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pre-tunnel rules are TC flower and OvS rules that forward a packet to the
tunnel end point where it can then pass through the network stack and be
decapsulated. These are required if the tunnel end point is, say, an OvS
internal port.

Currently, firmware determines that a packet is in a tunnel and decaps it
if it has a known destination IP and MAC address. However, this bypasses
the flower pre-tunnel rule and so does not update the stats. Further to
this it ignores VLANs that may exist outside of the tunnel header.

Offload pre-tunnel rules to the NFP. This embeds the pre-tunnel rule into
the tunnel decap process based on (firmware) mac index and VLAN. This
means that decap can be carried out correctly with VLANs and that stats
can be updated for all kernel rules correctly.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/cmsg.h   |  1 +
 drivers/net/ethernet/netronome/nfp/flower/main.c   |  1 +
 drivers/net/ethernet/netronome/nfp/flower/main.h   |  3 +
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    | 79 +++++++++++++++++++++-
 4 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
index caf3029..7eb2ec8 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/cmsg.h
@@ -484,6 +484,7 @@ enum nfp_flower_cmsg_type_port {
 	NFP_FLOWER_CMSG_TYPE_QOS_MOD =		18,
 	NFP_FLOWER_CMSG_TYPE_QOS_DEL =		19,
 	NFP_FLOWER_CMSG_TYPE_QOS_STATS =	20,
+	NFP_FLOWER_CMSG_TYPE_PRE_TUN_RULE =	21,
 	NFP_FLOWER_CMSG_TYPE_MAX =		32,
 };
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.c b/drivers/net/ethernet/netronome/nfp/flower/main.c
index eb84613..7a20447 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.c
@@ -781,6 +781,7 @@ static int nfp_flower_init(struct nfp_app *app)
 
 	INIT_LIST_HEAD(&app_priv->indr_block_cb_priv);
 	INIT_LIST_HEAD(&app_priv->non_repr_priv);
+	app_priv->pre_tun_rule_cnt = 0;
 
 	return 0;
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index c3aa415..5d302d7 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -163,6 +163,7 @@ struct nfp_fl_internal_ports {
  * @qos_stats_work:	Workqueue for qos stats processing
  * @qos_rate_limiters:	Current active qos rate limiters
  * @qos_stats_lock:	Lock on qos stats updates
+ * @pre_tun_rule_cnt:	Number of pre-tunnel rules offloaded
  */
 struct nfp_flower_priv {
 	struct nfp_app *app;
@@ -194,6 +195,7 @@ struct nfp_flower_priv {
 	struct delayed_work qos_stats_work;
 	unsigned int qos_rate_limiters;
 	spinlock_t qos_stats_lock; /* Protect the qos stats */
+	int pre_tun_rule_cnt;
 };
 
 /**
@@ -284,6 +286,7 @@ struct nfp_fl_payload {
 	struct {
 		struct net_device *dev;
 		__be16 vlan_tci;
+		__be16 port_idx;
 	} pre_tun_rule;
 };
 
diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index ef59481..b9dbfb7 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -15,6 +15,23 @@
 
 #define NFP_FL_MAX_ROUTES               32
 
+#define NFP_TUN_PRE_TUN_RULE_LIMIT	32
+#define NFP_TUN_PRE_TUN_RULE_DEL	0x1
+
+/**
+ * struct nfp_tun_pre_run_rule - rule matched before decap
+ * @flags:		options for the rule offset
+ * @port_idx:		index of destination MAC address for the rule
+ * @vlan_tci:		VLAN info associated with MAC
+ * @host_ctx_id:	stats context of rule to update
+ */
+struct nfp_tun_pre_tun_rule {
+	__be32 flags;
+	__be16 port_idx;
+	__be16 vlan_tci;
+	__be32 host_ctx_id;
+};
+
 /**
  * struct nfp_tun_active_tuns - periodic message of active tunnels
  * @seq:		sequence number of the message
@@ -835,13 +852,71 @@ int nfp_tunnel_mac_event_handler(struct nfp_app *app,
 int nfp_flower_xmit_pre_tun_flow(struct nfp_app *app,
 				 struct nfp_fl_payload *flow)
 {
-	return -EOPNOTSUPP;
+	struct nfp_flower_priv *app_priv = app->priv;
+	struct nfp_tun_offloaded_mac *mac_entry;
+	struct nfp_tun_pre_tun_rule payload;
+	struct net_device *internal_dev;
+	int err;
+
+	if (app_priv->pre_tun_rule_cnt == NFP_TUN_PRE_TUN_RULE_LIMIT)
+		return -ENOSPC;
+
+	memset(&payload, 0, sizeof(struct nfp_tun_pre_tun_rule));
+
+	internal_dev = flow->pre_tun_rule.dev;
+	payload.vlan_tci = flow->pre_tun_rule.vlan_tci;
+	payload.host_ctx_id = flow->meta.host_ctx_id;
+
+	/* Lookup MAC index for the pre-tunnel rule egress device.
+	 * Note that because the device is always an internal port, it will
+	 * have a constant global index so does not need to be tracked.
+	 */
+	mac_entry = nfp_tunnel_lookup_offloaded_macs(app,
+						     internal_dev->dev_addr);
+	if (!mac_entry)
+		return -ENOENT;
+
+	payload.port_idx = cpu_to_be16(mac_entry->index);
+
+	/* Copy mac id and vlan to flow - dev may not exist at delete time. */
+	flow->pre_tun_rule.vlan_tci = payload.vlan_tci;
+	flow->pre_tun_rule.port_idx = payload.port_idx;
+
+	err = nfp_flower_xmit_tun_conf(app, NFP_FLOWER_CMSG_TYPE_PRE_TUN_RULE,
+				       sizeof(struct nfp_tun_pre_tun_rule),
+				       (unsigned char *)&payload, GFP_KERNEL);
+	if (err)
+		return err;
+
+	app_priv->pre_tun_rule_cnt++;
+
+	return 0;
 }
 
 int nfp_flower_xmit_pre_tun_del_flow(struct nfp_app *app,
 				     struct nfp_fl_payload *flow)
 {
-	return -EOPNOTSUPP;
+	struct nfp_flower_priv *app_priv = app->priv;
+	struct nfp_tun_pre_tun_rule payload;
+	u32 tmp_flags = 0;
+	int err;
+
+	memset(&payload, 0, sizeof(struct nfp_tun_pre_tun_rule));
+
+	tmp_flags |= NFP_TUN_PRE_TUN_RULE_DEL;
+	payload.flags = cpu_to_be32(tmp_flags);
+	payload.vlan_tci = flow->pre_tun_rule.vlan_tci;
+	payload.port_idx = flow->pre_tun_rule.port_idx;
+
+	err = nfp_flower_xmit_tun_conf(app, NFP_FLOWER_CMSG_TYPE_PRE_TUN_RULE,
+				       sizeof(struct nfp_tun_pre_tun_rule),
+				       (unsigned char *)&payload, GFP_KERNEL);
+	if (err)
+		return err;
+
+	app_priv->pre_tun_rule_cnt--;
+
+	return 0;
 }
 
 int nfp_tunnel_config_start(struct nfp_app *app)
-- 
2.7.4

