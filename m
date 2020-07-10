Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 137D221BF71
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgGJV5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:57:03 -0400
Received: from mail-db8eur05on2045.outbound.protection.outlook.com ([40.107.20.45]:6078
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726339AbgGJV5C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 17:57:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GKLIE0py4JaGieUaB3YFGtoEJRVrwF2ybRuGbkkrwv8KCoC3WU1bGpFng9njj/UbESmrxvSlKnS5pyehRy0u4tuAX2vqi/LnNnxNBoxn3vwwvs/WdnuO81oyKZyAT+th5X2jSe3muvpw24hjn6LrOP+TRv4HO4zcS3jW7pUJQUUeBMr6LUr2jHuyQoCny0+1+jbShAINuYEi2OmNFho/1ctE+1gfviwlTTxUndbRqnwp5+FxvOTN3DwjReQyiHaqsxA9cnXRxnFbj0xuxxUJDY96K9tyY+EY2kJaf41FhhA478GugMS8HnDE2nwoeAdTRz+rn3fHZ0IYIZdW1xhv7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I2BhjJIAC/HFjd3CTApJA92z1u6IJxMi2Ma9We54dCo=;
 b=QM7fCl8uZhzKVXJKglD+o0a/svJeqWGINIJz4cwMoMkDSDtnLg2Wcx5YTJArsvNaq5LLiLwceIY+SEoSuyJLVrU37/QXlMHhdKdBje5dNIM+GqOXD5H6OtDxij6uQVwH3FwMP/M4TNgF/ilSPmqUfh8EdM8bgIaxZ7SY9S4oNR6/NWgufLj8YwfdukoyYjUtJ3mjaGbcRwuiRLPjq5e4kjut0WmhPKZkTyQbSLeXLun6P3LUrSOz0bHpUWXNlxFHrn+j4r1hC6jI1ke6v32YmKjReWvG91KVgl0o3aokgq3pV6ipvRAKZGxCxfSptKVsrMxRsdFjB2QeY8YES9EpJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I2BhjJIAC/HFjd3CTApJA92z1u6IJxMi2Ma9We54dCo=;
 b=btlMTAR8T4tHFJClKENmzRXLquFukz3ULP6MvfCdXy6BhTiqYqGuDwVoy61YLuCrqoos7umi+20jnhFyH3LU7XItPyr8uyzJ+AaNBCqB0Dh12c+oDAu6Z0dpgrtIRVHShOxaFxJPM5+dlDFwJeB2PVamAqYTkgcFkn0Vws3BeTU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3354.eurprd05.prod.outlook.com (2603:10a6:7:35::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.20; Fri, 10 Jul 2020 21:56:51 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 21:56:51 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
        kuba@kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, michael.chan@broadcom.com, saeedm@mellanox.com,
        leon@kernel.org, kadlec@netfilter.org, fw@strlen.de,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 05/13] mlxsw: spectrum_span: Prepare for global mirroring triggers
Date:   Sat, 11 Jul 2020 00:55:07 +0300
Message-Id: <f0e0f23cdb1ce195b68201a2dfaad27fbd80fd3f.1594416408.git.petrm@mellanox.com>
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
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM3PR07CA0116.eurprd07.prod.outlook.com (2603:10a6:207:7::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.8 via Frontend Transport; Fri, 10 Jul 2020 21:56:49 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9a2451b8-b3d4-44f5-cea8-08d8251c26cb
X-MS-TrafficTypeDiagnostic: HE1PR05MB3354:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB335420992599D705B5492D0CDB650@HE1PR05MB3354.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jH6g3AV+JFqZMZVmYVASnKu1RytduOXJhG7KT8VtvKp7r1dQTJSVXmgg9+z2KrsUmEfP0zfAMjk3igB3RDAcyV4QNf8Xl+CI9hCPHc+iw/tqSGbmX0a7cCDWZTZbVgkqIzSJK6SFe9k9wJ0uQHBGJ0gJCgy+ucFy4vu3kVcQhoKAQNO4VM5REnQdQEK1OQlwuaI4Sb4UjxLkt2D+Om2HuI1Eg3aqPXyObGC34jsIZuMf+6rGsmZEMcSoee2ysZ1o/YEpVqcKLeMJMWCj4I8aTgVq/YHpm/QxnFPfjE0MyST6MMQlxGHuHOZp+stqXgtqLFFApPL9asi7Sh/3/jVQkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(956004)(86362001)(2906002)(6916009)(5660300002)(2616005)(83380400001)(54906003)(7416002)(6512007)(8676002)(107886003)(26005)(52116002)(6506007)(36756003)(66556008)(66476007)(316002)(8936002)(4326008)(478600001)(16526019)(6486002)(6666004)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LWgt5zznsJ0Q1x1yiuw6cDUx6okpKbEFNfHR4DROnY0AbhA7M4ql+51Le3qtUPxTTuXwMFzmZZKTloduxnVhTTd6VwpZTuytxlp/iOuQ0pW/IEcM1DIYpvG19uyrNsj5v6I2SOutSi8CNlX3PpUCBGCjRzzmAQ4N9fkCr4NSRkeSiRifutoaNeOY3TP4HKzvjLi9Iq/jP/OOy7J45GCa8eT4lrjxHPc07X0zcvVXoC0n4bq2qcz3C5m8BweHV2yOHgYJHcFaVCTYxbWzw3Y1g3LsBjwRfnWyHU9wbTOUzwodZIUR7PxCBx9vS6wypZV8QjSCeVKSQanx5OmVEjEDFxKp5v6bh5g+gPlBxmS3GBiOA7Exh7NfPhpRLVgQ6tDeBZ3mSOjVKgaRuvzvCzjbOTIZTv2jf2OMo71HlclFQIYJak6e4WKMZXWOSnI7D4E/OPpFzaVoCltRnGyN+8vCnaJDkTxFxMmzAlxFWL6Dp9iaqxHV++1i3Wrbw/sLUYUj
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a2451b8-b3d4-44f5-cea8-08d8251c26cb
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 21:56:51.5286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zkaCKfDeV/D5cW9XQSyygJ3adkzyqpMr0MDxgEbsZTQSIstNy72uH+SLztnHpXsHP00dnNzZCG5s5rC1dsdwuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3354
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Currently, a SPAN agent can only be bound to a per-port trigger where
the trigger is either an incoming packet (INGRESS) or an outgoing packet
(EGRESS) to / from the port.

The subsequent patch will introduce the concept of global mirroring
triggers. The binding / unbinding of global triggers is different than
that of per-port triggers. Such triggers also need to be enabled /
disabled on a per-{port, TC} basis and are only supported from
Spectrum-2 onwards.

Add trigger operations that allow us to abstract these differences. Only
implement the operations for per-port triggers. Next patch will
implement the operations for global triggers.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 119 +++++++++++++++---
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |   1 +
 2 files changed, 103 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 49e2a417ec0e..b20422dde147 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -21,6 +21,7 @@
 struct mlxsw_sp_span {
 	struct work_struct work;
 	struct mlxsw_sp *mlxsw_sp;
+	const struct mlxsw_sp_span_trigger_ops **span_trigger_ops_arr;
 	struct list_head analyzed_ports_list;
 	struct mutex analyzed_ports_lock; /* Protects analyzed_ports_list */
 	struct list_head trigger_entries_list;
@@ -38,12 +39,26 @@ struct mlxsw_sp_span_analyzed_port {
 
 struct mlxsw_sp_span_trigger_entry {
 	struct list_head list; /* Member of trigger_entries_list */
+	struct mlxsw_sp_span *span;
+	const struct mlxsw_sp_span_trigger_ops *ops;
 	refcount_t ref_count;
 	u8 local_port;
 	enum mlxsw_sp_span_trigger trigger;
 	struct mlxsw_sp_span_trigger_parms parms;
 };
 
+enum mlxsw_sp_span_trigger_type {
+	MLXSW_SP_SPAN_TRIGGER_TYPE_PORT,
+};
+
+struct mlxsw_sp_span_trigger_ops {
+	int (*bind)(struct mlxsw_sp_span_trigger_entry *trigger_entry);
+	void (*unbind)(struct mlxsw_sp_span_trigger_entry *trigger_entry);
+	bool (*matches)(struct mlxsw_sp_span_trigger_entry *trigger_entry,
+			enum mlxsw_sp_span_trigger trigger,
+			struct mlxsw_sp_port *mlxsw_sp_port);
+};
+
 static void mlxsw_sp_span_respin_work(struct work_struct *work);
 
 static u64 mlxsw_sp_span_occ_get(void *priv)
@@ -57,7 +72,7 @@ int mlxsw_sp_span_init(struct mlxsw_sp *mlxsw_sp)
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	struct mlxsw_sp_span *span;
-	int i, entries_count;
+	int i, entries_count, err;
 
 	if (!MLXSW_CORE_RES_VALID(mlxsw_sp->core, MAX_SPAN))
 		return -EIO;
@@ -77,11 +92,20 @@ int mlxsw_sp_span_init(struct mlxsw_sp *mlxsw_sp)
 	for (i = 0; i < mlxsw_sp->span->entries_count; i++)
 		mlxsw_sp->span->entries[i].id = i;
 
+	err = mlxsw_sp->span_ops->init(mlxsw_sp);
+	if (err)
+		goto err_init;
+
 	devlink_resource_occ_get_register(devlink, MLXSW_SP_RESOURCE_SPAN,
 					  mlxsw_sp_span_occ_get, mlxsw_sp);
 	INIT_WORK(&span->work, mlxsw_sp_span_respin_work);
 
 	return 0;
+
+err_init:
+	mutex_destroy(&mlxsw_sp->span->analyzed_ports_lock);
+	kfree(mlxsw_sp->span);
+	return err;
 }
 
 void mlxsw_sp_span_fini(struct mlxsw_sp *mlxsw_sp)
@@ -1059,9 +1083,9 @@ void mlxsw_sp_span_analyzed_port_put(struct mlxsw_sp_port *mlxsw_sp_port,
 }
 
 static int
-__mlxsw_sp_span_trigger_entry_bind(struct mlxsw_sp_span *span,
-				   struct mlxsw_sp_span_trigger_entry *
-				   trigger_entry, bool enable)
+__mlxsw_sp_span_trigger_port_bind(struct mlxsw_sp_span *span,
+				  struct mlxsw_sp_span_trigger_entry *
+				  trigger_entry, bool enable)
 {
 	char mpar_pl[MLXSW_REG_MPAR_LEN];
 	enum mlxsw_reg_mpar_i_e i_e;
@@ -1084,19 +1108,60 @@ __mlxsw_sp_span_trigger_entry_bind(struct mlxsw_sp_span *span,
 }
 
 static int
-mlxsw_sp_span_trigger_entry_bind(struct mlxsw_sp_span *span,
-				 struct mlxsw_sp_span_trigger_entry *
-				 trigger_entry)
+mlxsw_sp_span_trigger_port_bind(struct mlxsw_sp_span_trigger_entry *
+				trigger_entry)
 {
-	return __mlxsw_sp_span_trigger_entry_bind(span, trigger_entry, true);
+	return __mlxsw_sp_span_trigger_port_bind(trigger_entry->span,
+						 trigger_entry, true);
 }
 
 static void
-mlxsw_sp_span_trigger_entry_unbind(struct mlxsw_sp_span *span,
-				   struct mlxsw_sp_span_trigger_entry *
-				   trigger_entry)
+mlxsw_sp_span_trigger_port_unbind(struct mlxsw_sp_span_trigger_entry *
+				  trigger_entry)
 {
-	__mlxsw_sp_span_trigger_entry_bind(span, trigger_entry, false);
+	__mlxsw_sp_span_trigger_port_bind(trigger_entry->span, trigger_entry,
+					  false);
+}
+
+static bool
+mlxsw_sp_span_trigger_port_matches(struct mlxsw_sp_span_trigger_entry *
+				   trigger_entry,
+				   enum mlxsw_sp_span_trigger trigger,
+				   struct mlxsw_sp_port *mlxsw_sp_port)
+{
+	return trigger_entry->trigger == trigger &&
+	       trigger_entry->local_port == mlxsw_sp_port->local_port;
+}
+
+static const struct mlxsw_sp_span_trigger_ops
+mlxsw_sp_span_trigger_port_ops = {
+	.bind = mlxsw_sp_span_trigger_port_bind,
+	.unbind = mlxsw_sp_span_trigger_port_unbind,
+	.matches = mlxsw_sp_span_trigger_port_matches,
+};
+
+static const struct mlxsw_sp_span_trigger_ops *
+mlxsw_sp_span_trigger_ops_arr[] = {
+	[MLXSW_SP_SPAN_TRIGGER_TYPE_PORT] = &mlxsw_sp_span_trigger_port_ops,
+};
+
+static void
+mlxsw_sp_span_trigger_ops_set(struct mlxsw_sp_span_trigger_entry *trigger_entry)
+{
+	struct mlxsw_sp_span *span = trigger_entry->span;
+	enum mlxsw_sp_span_trigger_type type;
+
+	switch (trigger_entry->trigger) {
+	case MLXSW_SP_SPAN_TRIGGER_INGRESS: /* fall-through */
+	case MLXSW_SP_SPAN_TRIGGER_EGRESS:
+		type = MLXSW_SP_SPAN_TRIGGER_TYPE_PORT;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return;
+	}
+
+	trigger_entry->ops = span->span_trigger_ops_arr[type];
 }
 
 static struct mlxsw_sp_span_trigger_entry *
@@ -1114,12 +1179,15 @@ mlxsw_sp_span_trigger_entry_create(struct mlxsw_sp_span *span,
 		return ERR_PTR(-ENOMEM);
 
 	refcount_set(&trigger_entry->ref_count, 1);
-	trigger_entry->local_port = mlxsw_sp_port->local_port;
+	trigger_entry->local_port = mlxsw_sp_port ? mlxsw_sp_port->local_port :
+						    0;
 	trigger_entry->trigger = trigger;
 	memcpy(&trigger_entry->parms, parms, sizeof(trigger_entry->parms));
+	trigger_entry->span = span;
+	mlxsw_sp_span_trigger_ops_set(trigger_entry);
 	list_add_tail(&trigger_entry->list, &span->trigger_entries_list);
 
-	err = mlxsw_sp_span_trigger_entry_bind(span, trigger_entry);
+	err = trigger_entry->ops->bind(trigger_entry);
 	if (err)
 		goto err_trigger_entry_bind;
 
@@ -1136,7 +1204,7 @@ mlxsw_sp_span_trigger_entry_destroy(struct mlxsw_sp_span *span,
 				    struct mlxsw_sp_span_trigger_entry *
 				    trigger_entry)
 {
-	mlxsw_sp_span_trigger_entry_unbind(span, trigger_entry);
+	trigger_entry->ops->unbind(trigger_entry);
 	list_del(&trigger_entry->list);
 	kfree(trigger_entry);
 }
@@ -1149,8 +1217,8 @@ mlxsw_sp_span_trigger_entry_find(struct mlxsw_sp_span *span,
 	struct mlxsw_sp_span_trigger_entry *trigger_entry;
 
 	list_for_each_entry(trigger_entry, &span->trigger_entries_list, list) {
-		if (trigger_entry->trigger == trigger &&
-		    trigger_entry->local_port == mlxsw_sp_port->local_port)
+		if (trigger_entry->ops->matches(trigger_entry, trigger,
+						mlxsw_sp_port))
 			return trigger_entry;
 	}
 
@@ -1216,15 +1284,30 @@ void mlxsw_sp_span_agent_unbind(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_span_trigger_entry_destroy(mlxsw_sp->span, trigger_entry);
 }
 
+static int mlxsw_sp1_span_init(struct mlxsw_sp *mlxsw_sp)
+{
+	mlxsw_sp->span->span_trigger_ops_arr = mlxsw_sp_span_trigger_ops_arr;
+
+	return 0;
+}
+
 static u32 mlxsw_sp1_span_buffsize_get(int mtu, u32 speed)
 {
 	return mtu * 5 / 2;
 }
 
 const struct mlxsw_sp_span_ops mlxsw_sp1_span_ops = {
+	.init = mlxsw_sp1_span_init,
 	.buffsize_get = mlxsw_sp1_span_buffsize_get,
 };
 
+static int mlxsw_sp2_span_init(struct mlxsw_sp *mlxsw_sp)
+{
+	mlxsw_sp->span->span_trigger_ops_arr = mlxsw_sp_span_trigger_ops_arr;
+
+	return 0;
+}
+
 #define MLXSW_SP2_SPAN_EG_MIRROR_BUFFER_FACTOR 38
 #define MLXSW_SP3_SPAN_EG_MIRROR_BUFFER_FACTOR 50
 
@@ -1241,6 +1324,7 @@ static u32 mlxsw_sp2_span_buffsize_get(int mtu, u32 speed)
 }
 
 const struct mlxsw_sp_span_ops mlxsw_sp2_span_ops = {
+	.init = mlxsw_sp2_span_init,
 	.buffsize_get = mlxsw_sp2_span_buffsize_get,
 };
 
@@ -1252,5 +1336,6 @@ static u32 mlxsw_sp3_span_buffsize_get(int mtu, u32 speed)
 }
 
 const struct mlxsw_sp_span_ops mlxsw_sp3_span_ops = {
+	.init = mlxsw_sp2_span_init,
 	.buffsize_get = mlxsw_sp3_span_buffsize_get,
 };
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
index 440551ec0dba..b9acecaf6ee2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -35,6 +35,7 @@ struct mlxsw_sp_span_trigger_parms {
 struct mlxsw_sp_span_entry_ops;
 
 struct mlxsw_sp_span_ops {
+	int (*init)(struct mlxsw_sp *mlxsw_sp);
 	u32 (*buffsize_get)(int mtu, u32 speed);
 };
 
-- 
2.20.1

