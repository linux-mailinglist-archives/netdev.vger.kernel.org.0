Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E548021BF79
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgGJV5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:57:24 -0400
Received: from mail-db8eur05on2045.outbound.protection.outlook.com ([40.107.20.45]:6078
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726748AbgGJV5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 17:57:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H7702nhj2XLH4hY8k791hmWCe/v7a5eCBtpZrjMcRgfnh2sfFsd70HzYvKYwn8pYESFKSEX82x6oQrFsx0+uucF2YT1Nk7bRve8jzavwnl/W5FViyC8mLkHSHnnN2J68VbuviXnvPWjN3itj3SG3/uO5VMcm4J/RaHiIOwMS54+aTn2+FzBk2owLpFgJKa6fUIFCqMajqRfXclyBLKobxAHmJsf5b7SDCPHmXUYavSBScWVHysoFQWzh46/JYtKMqk4CVUve9Q2M6onBW9WsQsTUKdQB4fn8QBzNtIrvOXB8vGedjOWyrkOclSmms9BHQtYBsRWfQDLOhaij9HveDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=68Fq6nOn372ZmJxlgDmKSVfx800eD8pYf0PkSwWNFD4=;
 b=nti2eUxImoVHkGnS5Ro4urQfAFix8y21HXYHstP87Grutug7FXO7IY0Bn/8xu85Oc8DYrGlkjXa9iu4sN87X1LdAfgvFnI1gLUlI+eEUDXcPZRDOq8YxPizOm9x5OkGoSbq9AnqVBnsR9YUWNGVE1vuPcFXjfbex2oax0ICOZa+IvgevDAk4aeZoh1NQIc1+onr36A3gI7sBTdqSHMLtJRr+iLDi6NuIrZcjZbBmJ8Db/DwWkrpVw3IMIobxAV+rW37CWpc/xj/2n/YRedYViSJU9TAOwWt7fSubijmCeihqd72YE3mqToO+NSLRa/Lerm6dAlmHHkBvxAuxVV5uXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=68Fq6nOn372ZmJxlgDmKSVfx800eD8pYf0PkSwWNFD4=;
 b=M4Wr1DHcQANbPOFk5h51KKaVSkpSHi+ZkFTxkGQ6RK7KNxOhvG/IrpXBQuuQLDnKtx14oEpEZ7x51pyLMm68djcUDJcsLMhLRks445ywzGPmsitLGptwNFZ+Lrim3FUGuk4xjshV5e5YSNq8Bs2JUHq6dl2pUJbAv+YoriCzwAo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3354.eurprd05.prod.outlook.com (2603:10a6:7:35::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.20; Fri, 10 Jul 2020 21:57:08 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 21:57:08 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
        kuba@kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, michael.chan@broadcom.com, saeedm@mellanox.com,
        leon@kernel.org, kadlec@netfilter.org, fw@strlen.de,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 12/13] mlxsw: spectrum_qdisc: Offload mirroring on RED qevent early_drop
Date:   Sat, 11 Jul 2020 00:55:14 +0300
Message-Id: <b02c028e3a91aea8998b645ddd838331f38e6196.1594416408.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1594416408.git.petrm@mellanox.com>
References: <cover.1594416408.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0116.eurprd07.prod.outlook.com
 (2603:10a6:207:7::26) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM3PR07CA0116.eurprd07.prod.outlook.com (2603:10a6:207:7::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.8 via Frontend Transport; Fri, 10 Jul 2020 21:57:06 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9a475d9e-0b9d-40e5-f847-08d8251c30d4
X-MS-TrafficTypeDiagnostic: HE1PR05MB3354:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB335490763D765C7C3D99DA32DB650@HE1PR05MB3354.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ic2lwZ6VssgOdf9nVAElS4NgKhf4vg6B/9uEx+tH4ajGzj6e4k6ZZcVUVHQDsrgs238Yje6qjmrfA8gom3taQ0RSQsNpr1WhDEwkBOMc+l8OaWNLaH383zcilNWFpWdUBlV/8bgpLbp8I8eI4iENDSG1xyQkmAiOzgnkcE9DSer2hVPglo5vPN4vAkVX5c3/bYjpo6MDfpsibD+Xb6bdgdSrbro2w28dFsHiQPTLSsNueF98cH4hjLB9tnyaRhMdGM/8pGUKE95ZysC+JwlqMoPWDWaF1rCfjSTITUagDt9XG5B0XkHkzgo8lSbZusXaUtNg4GlNK4IkIfF8qcVLmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(956004)(86362001)(2906002)(6916009)(5660300002)(2616005)(83380400001)(54906003)(7416002)(6512007)(30864003)(8676002)(107886003)(26005)(52116002)(6506007)(36756003)(66556008)(66476007)(316002)(8936002)(4326008)(478600001)(16526019)(6486002)(6666004)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: gc/nuuYCnrNAHwttK93ZzYFPIDYA9Fg7tkfuCuFG4zgLWNJESmSgHJXxYOPwdlRTyZrjg+b8NucwVQuXUkQvAAvOe7WQiFjbiC1VHDcOIHOB29GD/Jy1PzXZlqbJSVVVjboCMycfyaJegmnlV+JfAZdDSpdfSa76DCHIaKKCAbDK0wnWpq1GSP2U5ei0T9Zw1r96ow3yQQZTvkvcHYrirOwhJA42wQGwOKa0xE+N2mgF6Po+WCvu6LEb0bKf9Rm42JOH6K1NpCS3fQeaNVr29xtV4nOdD6fRrHdlEnXzVWfT/H7UQPZ7Svf9nZRjWqCV9zyTTpQvRfgRVff20m2TPnpLT0Qj8dFUp/8ijoSs3z4NqNcj3E9KSbwtoOt7TRQxjNJ9lmCbajif/BnAWOTHNDqdgDJfgHtPu8eHK2KUSlA7hmiJRtSCeZZilZlG4uRjAFYuI+uqXxoCEhXfnj32rR3tPfFRnRpSDzlrG4BoCZk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a475d9e-0b9d-40e5-f847-08d8251c30d4
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 21:57:08.4279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ut43wh1Fb64q3fkYtc/V3TAtFX7PD7rHxGdAR/fSMxdEzNU9Q6n2njawmTeDdEJfCxLsdtePqE0NIGfUeNM97Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3354
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RED qevents early_drop and mark can be offloaded under the following
fairly strict conditions:

- At most one filter is configured at the qevent block
- The protocol is "any"
- The classifier is matchall
- The action is trap, sample, or mirror with the same conditions as
  with other SPAN offloads
- The hw_counters type is none

In this patchset, implement offload of mirror for early_drop qevent.
The ECN trigger is currently not implemented in the FW and therefore
the mark qevent is not supported.

The qevent notifications look exactly like regular block binding
notifications with a binder type that identifies them as qevents.
Therefore the details of processing this binding are fairly similar
to the matchall offload.

struct flow_block_offload.sch points at the qdisc in question. Use it to
figure out if the qdisc is offloaded at all and what TC it configures.
Bounce bindings on not-offloaded qdiscs.

Individual bindings are kept in a list so that several qevents can share
the same block and all binding points get configured as the configured
filters change.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |   2 +
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   2 +
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 472 ++++++++++++++++++
 3 files changed, 476 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 2235c4bf330d..4ac634bd3571 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1337,6 +1337,8 @@ static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 		return mlxsw_sp_setup_tc_block_clsact(mlxsw_sp_port, f, true);
 	case FLOW_BLOCK_BINDER_TYPE_CLSACT_EGRESS:
 		return mlxsw_sp_setup_tc_block_clsact(mlxsw_sp_port, f, false);
+	case FLOW_BLOCK_BINDER_TYPE_RED_EARLY_DROP:
+		return mlxsw_sp_setup_tc_block_qevent_early_drop(mlxsw_sp_port, f);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index ee9a19f28b97..c00811178637 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -1031,6 +1031,8 @@ int mlxsw_sp_setup_tc_tbf(struct mlxsw_sp_port *mlxsw_sp_port,
 			  struct tc_tbf_qopt_offload *p);
 int mlxsw_sp_setup_tc_fifo(struct mlxsw_sp_port *mlxsw_sp_port,
 			   struct tc_fifo_qopt_offload *p);
+int mlxsw_sp_setup_tc_block_qevent_early_drop(struct mlxsw_sp_port *mlxsw_sp_port,
+					      struct flow_block_offload *f);
 
 /* spectrum_fid.c */
 bool mlxsw_sp_fid_is_dummy(struct mlxsw_sp *mlxsw_sp, u16 fid_index);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 670a43fe2a00..901acd87353f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -8,6 +8,7 @@
 #include <net/red.h>
 
 #include "spectrum.h"
+#include "spectrum_span.h"
 #include "reg.h"
 
 #define MLXSW_SP_PRIO_BAND_TO_TCLASS(band) (IEEE_8021QAZ_MAX_TCS - band - 1)
@@ -1272,6 +1273,477 @@ int mlxsw_sp_setup_tc_ets(struct mlxsw_sp_port *mlxsw_sp_port,
 	}
 }
 
+struct mlxsw_sp_qevent_block {
+	struct list_head binding_list;
+	struct list_head mall_entry_list;
+	struct mlxsw_sp *mlxsw_sp;
+};
+
+struct mlxsw_sp_qevent_binding {
+	struct list_head list;
+	struct mlxsw_sp_port *mlxsw_sp_port;
+	u32 handle;
+	int tclass_num;
+	enum mlxsw_sp_span_trigger span_trigger;
+};
+
+static LIST_HEAD(mlxsw_sp_qevent_block_cb_list);
+
+static int mlxsw_sp_qevent_mirror_configure(struct mlxsw_sp *mlxsw_sp,
+					    struct mlxsw_sp_mall_entry *mall_entry,
+					    struct mlxsw_sp_qevent_binding *qevent_binding)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = qevent_binding->mlxsw_sp_port;
+	struct mlxsw_sp_span_trigger_parms trigger_parms = {};
+	int span_id;
+	int err;
+
+	err = mlxsw_sp_span_agent_get(mlxsw_sp, mall_entry->mirror.to_dev, &span_id);
+	if (err)
+		return err;
+
+	err = mlxsw_sp_span_analyzed_port_get(mlxsw_sp_port, true);
+	if (err)
+		goto err_analyzed_port_get;
+
+	trigger_parms.span_id = span_id;
+	err = mlxsw_sp_span_agent_bind(mlxsw_sp, qevent_binding->span_trigger, mlxsw_sp_port,
+				       &trigger_parms);
+	if (err)
+		goto err_agent_bind;
+
+	err = mlxsw_sp_span_trigger_enable(mlxsw_sp_port, qevent_binding->span_trigger,
+					   qevent_binding->tclass_num);
+	if (err)
+		goto err_trigger_enable;
+
+	mall_entry->mirror.span_id = span_id;
+	return 0;
+
+err_trigger_enable:
+	mlxsw_sp_span_agent_unbind(mlxsw_sp, qevent_binding->span_trigger, mlxsw_sp_port,
+				   &trigger_parms);
+err_agent_bind:
+	mlxsw_sp_span_analyzed_port_put(mlxsw_sp_port, true);
+err_analyzed_port_get:
+	mlxsw_sp_span_agent_put(mlxsw_sp, span_id);
+	return err;
+}
+
+static void mlxsw_sp_qevent_mirror_deconfigure(struct mlxsw_sp *mlxsw_sp,
+					       struct mlxsw_sp_mall_entry *mall_entry,
+					       struct mlxsw_sp_qevent_binding *qevent_binding)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = qevent_binding->mlxsw_sp_port;
+	struct mlxsw_sp_span_trigger_parms trigger_parms = {
+		.span_id = mall_entry->mirror.span_id,
+	};
+
+	mlxsw_sp_span_trigger_disable(mlxsw_sp_port, qevent_binding->span_trigger,
+				      qevent_binding->tclass_num);
+	mlxsw_sp_span_agent_unbind(mlxsw_sp, qevent_binding->span_trigger, mlxsw_sp_port,
+				   &trigger_parms);
+	mlxsw_sp_span_analyzed_port_put(mlxsw_sp_port, true);
+	mlxsw_sp_span_agent_put(mlxsw_sp, mall_entry->mirror.span_id);
+}
+
+static int mlxsw_sp_qevent_entry_configure(struct mlxsw_sp *mlxsw_sp,
+					   struct mlxsw_sp_mall_entry *mall_entry,
+					   struct mlxsw_sp_qevent_binding *qevent_binding)
+{
+	switch (mall_entry->type) {
+	case MLXSW_SP_MALL_ACTION_TYPE_MIRROR:
+		return mlxsw_sp_qevent_mirror_configure(mlxsw_sp, mall_entry, qevent_binding);
+	default:
+		/* This should have been validated away. */
+		WARN_ON(1);
+		return -EOPNOTSUPP;
+	}
+}
+
+static void mlxsw_sp_qevent_entry_deconfigure(struct mlxsw_sp *mlxsw_sp,
+					      struct mlxsw_sp_mall_entry *mall_entry,
+					      struct mlxsw_sp_qevent_binding *qevent_binding)
+{
+	switch (mall_entry->type) {
+	case MLXSW_SP_MALL_ACTION_TYPE_MIRROR:
+		return mlxsw_sp_qevent_mirror_deconfigure(mlxsw_sp, mall_entry, qevent_binding);
+	default:
+		WARN_ON(1);
+		return;
+	}
+}
+
+static int mlxsw_sp_qevent_binding_configure(struct mlxsw_sp_qevent_block *qevent_block,
+					     struct mlxsw_sp_qevent_binding *qevent_binding)
+{
+	struct mlxsw_sp_mall_entry *mall_entry;
+	int err;
+
+	list_for_each_entry(mall_entry, &qevent_block->mall_entry_list, list) {
+		err = mlxsw_sp_qevent_entry_configure(qevent_block->mlxsw_sp, mall_entry,
+						      qevent_binding);
+		if (err)
+			goto err_entry_configure;
+	}
+
+	return 0;
+
+err_entry_configure:
+	list_for_each_entry_continue_reverse(mall_entry, &qevent_block->mall_entry_list, list)
+		mlxsw_sp_qevent_entry_deconfigure(qevent_block->mlxsw_sp, mall_entry,
+						  qevent_binding);
+	return err;
+}
+
+static void mlxsw_sp_qevent_binding_deconfigure(struct mlxsw_sp_qevent_block *qevent_block,
+						struct mlxsw_sp_qevent_binding *qevent_binding)
+{
+	struct mlxsw_sp_mall_entry *mall_entry;
+
+	list_for_each_entry(mall_entry, &qevent_block->mall_entry_list, list)
+		mlxsw_sp_qevent_entry_deconfigure(qevent_block->mlxsw_sp, mall_entry,
+						  qevent_binding);
+}
+
+static int mlxsw_sp_qevent_block_configure(struct mlxsw_sp_qevent_block *qevent_block)
+{
+	struct mlxsw_sp_qevent_binding *qevent_binding;
+	int err;
+
+	list_for_each_entry(qevent_binding, &qevent_block->binding_list, list) {
+		err = mlxsw_sp_qevent_binding_configure(qevent_block, qevent_binding);
+		if (err)
+			goto err_binding_configure;
+	}
+
+	return 0;
+
+err_binding_configure:
+	list_for_each_entry_continue_reverse(qevent_binding, &qevent_block->binding_list, list)
+		mlxsw_sp_qevent_binding_deconfigure(qevent_block, qevent_binding);
+	return err;
+}
+
+static void mlxsw_sp_qevent_block_deconfigure(struct mlxsw_sp_qevent_block *qevent_block)
+{
+	struct mlxsw_sp_qevent_binding *qevent_binding;
+
+	list_for_each_entry(qevent_binding, &qevent_block->binding_list, list)
+		mlxsw_sp_qevent_binding_deconfigure(qevent_block, qevent_binding);
+}
+
+static struct mlxsw_sp_mall_entry *
+mlxsw_sp_qevent_mall_entry_find(struct mlxsw_sp_qevent_block *block, unsigned long cookie)
+{
+	struct mlxsw_sp_mall_entry *mall_entry;
+
+	list_for_each_entry(mall_entry, &block->mall_entry_list, list)
+		if (mall_entry->cookie == cookie)
+			return mall_entry;
+
+	return NULL;
+}
+
+static int mlxsw_sp_qevent_mall_replace(struct mlxsw_sp *mlxsw_sp,
+					struct mlxsw_sp_qevent_block *qevent_block,
+					struct tc_cls_matchall_offload *f)
+{
+	struct mlxsw_sp_mall_entry *mall_entry;
+	struct flow_action_entry *act;
+	int err;
+
+	/* It should not currently be possible to replace a matchall rule. So
+	 * this must be a new rule.
+	 */
+	if (!list_empty(&qevent_block->mall_entry_list)) {
+		NL_SET_ERR_MSG(f->common.extack, "At most one filter supported");
+		return -EOPNOTSUPP;
+	}
+	if (f->rule->action.num_entries != 1) {
+		NL_SET_ERR_MSG(f->common.extack, "Only singular actions supported");
+		return -EOPNOTSUPP;
+	}
+	if (f->common.chain_index) {
+		NL_SET_ERR_MSG(f->common.extack, "Only chain 0 is supported");
+		return -EOPNOTSUPP;
+	}
+	if (f->common.protocol != htons(ETH_P_ALL)) {
+		NL_SET_ERR_MSG(f->common.extack, "Protocol matching not supported");
+		return -EOPNOTSUPP;
+	}
+
+	act = &f->rule->action.entries[0];
+	if (!(act->hw_stats & FLOW_ACTION_HW_STATS_DISABLED)) {
+		NL_SET_ERR_MSG(f->common.extack, "HW counters not supported on qevents");
+		return -EOPNOTSUPP;
+	}
+
+	mall_entry = kzalloc(sizeof(*mall_entry), GFP_KERNEL);
+	if (!mall_entry)
+		return -ENOMEM;
+	mall_entry->cookie = f->cookie;
+
+	if (act->id == FLOW_ACTION_MIRRED) {
+		mall_entry->type = MLXSW_SP_MALL_ACTION_TYPE_MIRROR;
+		mall_entry->mirror.to_dev = act->dev;
+	} else {
+		NL_SET_ERR_MSG(f->common.extack, "Unsupported action");
+		err = -EOPNOTSUPP;
+		goto err_unsupported_action;
+	}
+
+	list_add_tail(&mall_entry->list, &qevent_block->mall_entry_list);
+
+	err = mlxsw_sp_qevent_block_configure(qevent_block);
+	if (err)
+		goto err_block_configure;
+
+	return 0;
+
+err_block_configure:
+	list_del(&mall_entry->list);
+err_unsupported_action:
+	kfree(mall_entry);
+	return err;
+}
+
+static void mlxsw_sp_qevent_mall_destroy(struct mlxsw_sp_qevent_block *qevent_block,
+					 struct tc_cls_matchall_offload *f)
+{
+	struct mlxsw_sp_mall_entry *mall_entry;
+
+	mall_entry = mlxsw_sp_qevent_mall_entry_find(qevent_block, f->cookie);
+	if (!mall_entry)
+		return;
+
+	mlxsw_sp_qevent_block_deconfigure(qevent_block);
+
+	list_del(&mall_entry->list);
+	kfree(mall_entry);
+}
+
+static int mlxsw_sp_qevent_block_mall_cb(struct mlxsw_sp_qevent_block *qevent_block,
+					 struct tc_cls_matchall_offload *f)
+{
+	struct mlxsw_sp *mlxsw_sp = qevent_block->mlxsw_sp;
+
+	switch (f->command) {
+	case TC_CLSMATCHALL_REPLACE:
+		return mlxsw_sp_qevent_mall_replace(mlxsw_sp, qevent_block, f);
+	case TC_CLSMATCHALL_DESTROY:
+		mlxsw_sp_qevent_mall_destroy(qevent_block, f);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int mlxsw_sp_qevent_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
+{
+	struct mlxsw_sp_qevent_block *qevent_block = cb_priv;
+
+	switch (type) {
+	case TC_SETUP_CLSMATCHALL:
+		return mlxsw_sp_qevent_block_mall_cb(qevent_block, type_data);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static struct mlxsw_sp_qevent_block *mlxsw_sp_qevent_block_create(struct mlxsw_sp *mlxsw_sp,
+								  struct net *net)
+{
+	struct mlxsw_sp_qevent_block *qevent_block;
+
+	qevent_block = kzalloc(sizeof(*qevent_block), GFP_KERNEL);
+	if (!qevent_block)
+		return NULL;
+
+	INIT_LIST_HEAD(&qevent_block->binding_list);
+	INIT_LIST_HEAD(&qevent_block->mall_entry_list);
+	qevent_block->mlxsw_sp = mlxsw_sp;
+	return qevent_block;
+}
+
+static void
+mlxsw_sp_qevent_block_destroy(struct mlxsw_sp_qevent_block *qevent_block)
+{
+	WARN_ON(!list_empty(&qevent_block->binding_list));
+	WARN_ON(!list_empty(&qevent_block->mall_entry_list));
+	kfree(qevent_block);
+}
+
+static void mlxsw_sp_qevent_block_release(void *cb_priv)
+{
+	struct mlxsw_sp_qevent_block *qevent_block = cb_priv;
+
+	mlxsw_sp_qevent_block_destroy(qevent_block);
+}
+
+static struct mlxsw_sp_qevent_binding *
+mlxsw_sp_qevent_binding_create(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle, int tclass_num,
+			       enum mlxsw_sp_span_trigger span_trigger)
+{
+	struct mlxsw_sp_qevent_binding *binding;
+
+	binding = kzalloc(sizeof(*binding), GFP_KERNEL);
+	if (!binding)
+		return ERR_PTR(-ENOMEM);
+
+	binding->mlxsw_sp_port = mlxsw_sp_port;
+	binding->handle = handle;
+	binding->tclass_num = tclass_num;
+	binding->span_trigger = span_trigger;
+	return binding;
+}
+
+static void
+mlxsw_sp_qevent_binding_destroy(struct mlxsw_sp_qevent_binding *binding)
+{
+	kfree(binding);
+}
+
+static struct mlxsw_sp_qevent_binding *
+mlxsw_sp_qevent_binding_lookup(struct mlxsw_sp_qevent_block *block,
+			       struct mlxsw_sp_port *mlxsw_sp_port,
+			       u32 handle,
+			       enum mlxsw_sp_span_trigger span_trigger)
+{
+	struct mlxsw_sp_qevent_binding *qevent_binding;
+
+	list_for_each_entry(qevent_binding, &block->binding_list, list)
+		if (qevent_binding->mlxsw_sp_port == mlxsw_sp_port &&
+		    qevent_binding->handle == handle &&
+		    qevent_binding->span_trigger == span_trigger)
+			return qevent_binding;
+	return NULL;
+}
+
+static int mlxsw_sp_setup_tc_block_qevent_bind(struct mlxsw_sp_port *mlxsw_sp_port,
+					       struct flow_block_offload *f,
+					       enum mlxsw_sp_span_trigger span_trigger)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	struct mlxsw_sp_qevent_binding *qevent_binding;
+	struct mlxsw_sp_qevent_block *qevent_block;
+	struct flow_block_cb *block_cb;
+	struct mlxsw_sp_qdisc *qdisc;
+	bool register_block = false;
+	int err;
+
+	block_cb = flow_block_cb_lookup(f->block, mlxsw_sp_qevent_block_cb, mlxsw_sp);
+	if (!block_cb) {
+		qevent_block = mlxsw_sp_qevent_block_create(mlxsw_sp, f->net);
+		if (!qevent_block)
+			return -ENOMEM;
+		block_cb = flow_block_cb_alloc(mlxsw_sp_qevent_block_cb, mlxsw_sp, qevent_block,
+					       mlxsw_sp_qevent_block_release);
+		if (IS_ERR(block_cb)) {
+			mlxsw_sp_qevent_block_destroy(qevent_block);
+			return PTR_ERR(block_cb);
+		}
+		register_block = true;
+	} else {
+		qevent_block = flow_block_cb_priv(block_cb);
+	}
+	flow_block_cb_incref(block_cb);
+
+	qdisc = mlxsw_sp_qdisc_find_by_handle(mlxsw_sp_port, f->sch->handle);
+	if (!qdisc) {
+		NL_SET_ERR_MSG(f->extack, "Qdisc not offloaded");
+		err = -ENOENT;
+		goto err_find_qdisc;
+	}
+
+	if (WARN_ON(mlxsw_sp_qevent_binding_lookup(qevent_block, mlxsw_sp_port, f->sch->handle,
+						   span_trigger))) {
+		err = -EEXIST;
+		goto err_binding_exists;
+	}
+
+	qevent_binding = mlxsw_sp_qevent_binding_create(mlxsw_sp_port, f->sch->handle,
+							qdisc->tclass_num, span_trigger);
+	if (IS_ERR(qevent_binding)) {
+		err = PTR_ERR(qevent_binding);
+		goto err_binding_create;
+	}
+
+	err = mlxsw_sp_qevent_binding_configure(qevent_block, qevent_binding);
+	if (err)
+		goto err_binding_configure;
+
+	list_add(&qevent_binding->list, &qevent_block->binding_list);
+
+	if (register_block) {
+		flow_block_cb_add(block_cb, f);
+		list_add_tail(&block_cb->driver_list, &mlxsw_sp_qevent_block_cb_list);
+	}
+
+	return 0;
+
+err_binding_configure:
+	mlxsw_sp_qevent_binding_destroy(qevent_binding);
+err_binding_create:
+err_binding_exists:
+err_find_qdisc:
+	if (!flow_block_cb_decref(block_cb))
+		flow_block_cb_free(block_cb);
+	return err;
+}
+
+static void mlxsw_sp_setup_tc_block_qevent_unbind(struct mlxsw_sp_port *mlxsw_sp_port,
+						  struct flow_block_offload *f,
+						  enum mlxsw_sp_span_trigger span_trigger)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	struct mlxsw_sp_qevent_binding *qevent_binding;
+	struct mlxsw_sp_qevent_block *qevent_block;
+	struct flow_block_cb *block_cb;
+
+	block_cb = flow_block_cb_lookup(f->block, mlxsw_sp_qevent_block_cb, mlxsw_sp);
+	if (!block_cb)
+		return;
+	qevent_block = flow_block_cb_priv(block_cb);
+
+	qevent_binding = mlxsw_sp_qevent_binding_lookup(qevent_block, mlxsw_sp_port, f->sch->handle,
+							span_trigger);
+	if (!qevent_binding)
+		return;
+
+	list_del(&qevent_binding->list);
+	mlxsw_sp_qevent_binding_deconfigure(qevent_block, qevent_binding);
+	mlxsw_sp_qevent_binding_destroy(qevent_binding);
+
+	if (!flow_block_cb_decref(block_cb)) {
+		flow_block_cb_remove(block_cb, f);
+		list_del(&block_cb->driver_list);
+	}
+}
+
+static int mlxsw_sp_setup_tc_block_qevent(struct mlxsw_sp_port *mlxsw_sp_port,
+					  struct flow_block_offload *f,
+					  enum mlxsw_sp_span_trigger span_trigger)
+{
+	f->driver_block_list = &mlxsw_sp_qevent_block_cb_list;
+
+	switch (f->command) {
+	case FLOW_BLOCK_BIND:
+		return mlxsw_sp_setup_tc_block_qevent_bind(mlxsw_sp_port, f, span_trigger);
+	case FLOW_BLOCK_UNBIND:
+		mlxsw_sp_setup_tc_block_qevent_unbind(mlxsw_sp_port, f, span_trigger);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+int mlxsw_sp_setup_tc_block_qevent_early_drop(struct mlxsw_sp_port *mlxsw_sp_port,
+					      struct flow_block_offload *f)
+{
+	return mlxsw_sp_setup_tc_block_qevent(mlxsw_sp_port, f, MLXSW_SP_SPAN_TRIGGER_EARLY_DROP);
+}
+
 int mlxsw_sp_tc_qdisc_init(struct mlxsw_sp_port *mlxsw_sp_port)
 {
 	struct mlxsw_sp_qdisc_state *qdisc_state;
-- 
2.20.1

