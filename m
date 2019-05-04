Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38A8C13988
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 13:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfEDLrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 07:47:08 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40119 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbfEDLrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 07:47:07 -0400
Received: by mail-qt1-f195.google.com with SMTP id k24so5926259qtq.7
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 04:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=htvnaS06xbftCu3yHwylvyFfY6mdCin7xvQCu5UunLU=;
        b=reQriCjpeh0bECAOCqSC92W62u2o2U4yXnN9lreUyOcOD+kIQEBP1suYZviGOgN924
         89GCVQLnIIU/6ID8nJ2BU5Gv35pEUKZdiN9xTjO9N//0eif3CmvccAowFaHHhGXwZpXS
         t3xw575vsbfRE3quXQLAwKfWQqE7qd4DiZnN0IBIsPpZ+lqTzcg0c3zzY2TFBG7QcAQ2
         K5ZQIhvNIDZXvnPvX8gt9g1GQTFsFNtM+OXEhmCQkX8GnzExYGH439TMlcqmvcV0sy4l
         /kzPa0Y2mdXBv59si503tvTOyJgvobvk/1wGI0Le6Rb2m3AcVzLiryRojZqDrzhWKfvz
         wBhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=htvnaS06xbftCu3yHwylvyFfY6mdCin7xvQCu5UunLU=;
        b=JLH4jFlHkYuVZaJ23LXVJZ5UdXdHbayundRRrPbuL3NMIdaLZjfFmYtf6n2GFEYK1/
         zqRZeLlvSKgd/1heD4t86rCNFV0glVHaHq25EBLVGR35RKYnLAwKpFb+unymgC3zWqyV
         LLDVKm9G05XaupsvR3e09PtZFib3BWtq3CrRIIXBRPs72K9O7l6iD2PNhM5GnxiI4bj2
         cFGmstN1hrjVA2Wnv+uA10ukil64WtlNDwaFPcjHzEePKsW2m3QtIgnfcHVdprfPpaMR
         9xpsFewDebHDTH7yKXQdLtS2PKIa6t4AgWSYNgeEQGNwiU9ikXA7SUPBqdTLSeRLmN1N
         +IWg==
X-Gm-Message-State: APjAAAVaZFouLQXhG/5aKOk9YH4y+dVx4rHDB4ZQyhcfuMkpnqGSulKf
        KxlhtJolG5YoaTRo0p1muesG+g==
X-Google-Smtp-Source: APXvYqzoWb2v3SQmMTTUt+hsnpy9hGRF2R0KSLRfZrmMTDoaR5k0oezp7tITwdqZ7gVtuqsFvKWGOQ==
X-Received: by 2002:aed:22ec:: with SMTP id q41mr6615993qtc.17.1556970426196;
        Sat, 04 May 2019 04:47:06 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g19sm2847276qkk.17.2019.05.04.04.47.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 04:47:05 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        gerlitz.or@gmail.com, simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 03/13] mlxsw: use intermediate representation for matchall offload
Date:   Sat,  4 May 2019 04:46:18 -0700
Message-Id: <20190504114628.14755-4-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504114628.14755-1-jakub.kicinski@netronome.com>
References: <20190504114628.14755-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>

Updates the Mellanox spectrum driver to use the newer intermediate
representation for flow actions in matchall offloads.

Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 38 +++++++++----------
 include/net/flow_offload.h                    | 11 ++++++
 2 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index a6c6d5ee9ead..f594c6a913ec 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1269,21 +1269,19 @@ mlxsw_sp_port_mall_tc_entry_find(struct mlxsw_sp_port *port,
 static int
 mlxsw_sp_port_add_cls_matchall_mirror(struct mlxsw_sp_port *mlxsw_sp_port,
 				      struct mlxsw_sp_port_mall_mirror_tc_entry *mirror,
-				      const struct tc_action *a,
+				      const struct flow_action_entry *act,
 				      bool ingress)
 {
 	enum mlxsw_sp_span_type span_type;
-	struct net_device *to_dev;
 
-	to_dev = tcf_mirred_dev(a);
-	if (!to_dev) {
+	if (!act->dev) {
 		netdev_err(mlxsw_sp_port->dev, "Could not find requested device\n");
 		return -EINVAL;
 	}
 
 	mirror->ingress = ingress;
 	span_type = ingress ? MLXSW_SP_SPAN_INGRESS : MLXSW_SP_SPAN_EGRESS;
-	return mlxsw_sp_span_mirror_add(mlxsw_sp_port, to_dev, span_type,
+	return mlxsw_sp_span_mirror_add(mlxsw_sp_port, act->dev, span_type,
 					true, &mirror->span_id);
 }
 
@@ -1302,7 +1300,7 @@ mlxsw_sp_port_del_cls_matchall_mirror(struct mlxsw_sp_port *mlxsw_sp_port,
 static int
 mlxsw_sp_port_add_cls_matchall_sample(struct mlxsw_sp_port *mlxsw_sp_port,
 				      struct tc_cls_matchall_offload *cls,
-				      const struct tc_action *a,
+				      const struct flow_action_entry *act,
 				      bool ingress)
 {
 	int err;
@@ -1313,18 +1311,18 @@ mlxsw_sp_port_add_cls_matchall_sample(struct mlxsw_sp_port *mlxsw_sp_port,
 		netdev_err(mlxsw_sp_port->dev, "sample already active\n");
 		return -EEXIST;
 	}
-	if (tcf_sample_rate(a) > MLXSW_REG_MPSC_RATE_MAX) {
+	if (act->sample.rate > MLXSW_REG_MPSC_RATE_MAX) {
 		netdev_err(mlxsw_sp_port->dev, "sample rate not supported\n");
 		return -EOPNOTSUPP;
 	}
 
 	rcu_assign_pointer(mlxsw_sp_port->sample->psample_group,
-			   tcf_sample_psample_group(a));
-	mlxsw_sp_port->sample->truncate = tcf_sample_truncate(a);
-	mlxsw_sp_port->sample->trunc_size = tcf_sample_trunc_size(a);
-	mlxsw_sp_port->sample->rate = tcf_sample_rate(a);
+			   act->sample.psample_group);
+	mlxsw_sp_port->sample->truncate = act->sample.truncate;
+	mlxsw_sp_port->sample->trunc_size = act->sample.trunc_size;
+	mlxsw_sp_port->sample->rate = act->sample.rate;
 
-	err = mlxsw_sp_port_sample_set(mlxsw_sp_port, true, tcf_sample_rate(a));
+	err = mlxsw_sp_port_sample_set(mlxsw_sp_port, true, act->sample.rate);
 	if (err)
 		goto err_port_sample_set;
 	return 0;
@@ -1350,10 +1348,10 @@ static int mlxsw_sp_port_add_cls_matchall(struct mlxsw_sp_port *mlxsw_sp_port,
 {
 	struct mlxsw_sp_port_mall_tc_entry *mall_tc_entry;
 	__be16 protocol = f->common.protocol;
-	const struct tc_action *a;
+	struct flow_action_entry *act;
 	int err;
 
-	if (!tcf_exts_has_one_action(f->exts)) {
+	if (!flow_offload_has_one_action(&f->rule->action)) {
 		netdev_err(mlxsw_sp_port->dev, "only singular actions are supported\n");
 		return -EOPNOTSUPP;
 	}
@@ -1363,19 +1361,21 @@ static int mlxsw_sp_port_add_cls_matchall(struct mlxsw_sp_port *mlxsw_sp_port,
 		return -ENOMEM;
 	mall_tc_entry->cookie = f->cookie;
 
-	a = tcf_exts_first_action(f->exts);
+	act = &f->rule->action.entries[0];
 
-	if (is_tcf_mirred_egress_mirror(a) && protocol == htons(ETH_P_ALL)) {
+	if (act->id == FLOW_ACTION_MIRRED && protocol == htons(ETH_P_ALL)) {
 		struct mlxsw_sp_port_mall_mirror_tc_entry *mirror;
 
 		mall_tc_entry->type = MLXSW_SP_PORT_MALL_MIRROR;
 		mirror = &mall_tc_entry->mirror;
 		err = mlxsw_sp_port_add_cls_matchall_mirror(mlxsw_sp_port,
-							    mirror, a, ingress);
-	} else if (is_tcf_sample(a) && protocol == htons(ETH_P_ALL)) {
+							    mirror, act,
+							    ingress);
+	} else if (act->id == FLOW_ACTION_SAMPLE &&
+		   protocol == htons(ETH_P_ALL)) {
 		mall_tc_entry->type = MLXSW_SP_PORT_MALL_SAMPLE;
 		err = mlxsw_sp_port_add_cls_matchall_sample(mlxsw_sp_port, f,
-							    a, ingress);
+							    act, ingress);
 	} else {
 		err = -EOPNOTSUPP;
 	}
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 9a6c89b2c2bb..3bf67dd64be5 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -177,6 +177,17 @@ static inline bool flow_action_has_entries(const struct flow_action *action)
 	return action->num_entries;
 }
 
+/**
+ * flow_action_has_one_action() - check if exactly one action is present
+ * @action: tc filter flow offload action
+ *
+ * Returns true if exactly one action is present.
+ */
+static inline bool flow_offload_has_one_action(const struct flow_action *action)
+{
+	return action->num_entries == 1;
+}
+
 #define flow_action_for_each(__i, __act, __actions)			\
         for (__i = 0, __act = &(__actions)->entries[0]; __i < (__actions)->num_entries; __act = &(__actions)->entries[++__i])
 
-- 
2.21.0

