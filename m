Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6394B21BF74
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgGJV5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:57:13 -0400
Received: from mail-db8eur05on2045.outbound.protection.outlook.com ([40.107.20.45]:6078
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726582AbgGJV5K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 17:57:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NxwU2bBiCTxi5k7jc9ufCTvg5TIytIhqGlaB9a/FbjA7UD6enJG+QN/lBf9UuPExbbDkhJKlS+dEXFbb927hUZ7OaKxD+hYiZwQPBLqp44oIVBH476Z5oDIUEOkqNiwKA0dEm7h07vkWotDF0lvZRYJRze+DWFz9gDBMcfuYS/oCyov58aevH1aeFK6OfbE3BFmaMtgZvr7hd4/y+XFsoRMPbvdQp8Mp0wFyN0HOXwsECOziG2YxjmyquJP/rXJCdG6YrlGb/iXEdZY6Y66b/li0wVi6uaCyjG2ZRN/LCdhrQCh6L/mbJvIMRPexPFgSVaauKE0ZL9qF6X/rWIOPcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KqX4U4LGFvuH8cgEaucNAaBafY6/D3Zbi71ipgmwcHI=;
 b=ogH+al65rDYZ65R+4LQHjsIPULLW3NAd5SN2zATgmPg83JHazWEoZFY+6nli08ae7xnJot7m20/8FGZqWZhw9PGca7doPSA9CVJjJWXTUug+GElOcp6vWL3VHruMAqiSOqTDfT16dGmmiZxxGRkGvCAuyAOISTNgD96mSfGGxl9jhbhfYyJ7ZaRQE9y3YuWN/mzhS2qfrRbQO4DvmKsw30dHzjKd+pH2lcCqxOo2MbCXT6RcJWh8I+pHfNR+8X3yQ4jMvq4ZivSbERucTzQPEwc5SbxbiQVfzXuY6sxOKv25ZXPWGSixMi6eDz+ZzdJUB0WyIZeCvccmS0vYYll9jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KqX4U4LGFvuH8cgEaucNAaBafY6/D3Zbi71ipgmwcHI=;
 b=e01mftYO0fsNjQgienNLY+nBmWhAmS+3ZrdUehuskLPjrdsuM1gbjDE2F5trjWc1WKv0Yf2PWpioCnQuoGJEMce7c62TJC/5K5rDmyLl/OTD9cUyzuLDJon84++RxnMaeLKRTdfOkpDPjj/JGmJWMzvg2Oh9eMY3jRxrcmmCi4M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3354.eurprd05.prod.outlook.com (2603:10a6:7:35::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.20; Fri, 10 Jul 2020 21:56:56 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 21:56:56 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
        kuba@kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, michael.chan@broadcom.com, saeedm@mellanox.com,
        leon@kernel.org, kadlec@netfilter.org, fw@strlen.de,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 07/13] mlxsw: spectrum_span: Add APIs to enable / disable global mirroring triggers
Date:   Sat, 11 Jul 2020 00:55:09 +0300
Message-Id: <962ab9d4866df4fde802a8ed1050c153f4728230.1594416408.git.petrm@mellanox.com>
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
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM3PR07CA0116.eurprd07.prod.outlook.com (2603:10a6:207:7::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.8 via Frontend Transport; Fri, 10 Jul 2020 21:56:54 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1b9cf119-f07e-4599-e9d5-08d8251c2992
X-MS-TrafficTypeDiagnostic: HE1PR05MB3354:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB335464121EAF58DD605EDCD4DB650@HE1PR05MB3354.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8VoN2cC6GWmVS+tL6vMw3prvljoYPtKAUbS+cIcRdpNtQrA7Wevc24BoIw1RTjC+zV62V62o/TkSytLZZS6XxngcgXSrsQ3B3wChTlLcS3yZL4pifX3dG0BgS2D/5L7KGSB6zdtx/LLvI/9CKthTO5Xf7Jyq3YtyNUKRWcx/36ceXlMy/jW/cq8cMn/vdqhug2vqPBZhfWKEvxh12/h7NjC+2RlHRZV+hGUeMySGkWrAn0vfKed4M8VWExeu4OhQwFxkNYPlB/YT7Y+rLTgcox+LGSCssgSB368Fw4TqnlsRTFJYMZEwR50wDkgcdBVY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(956004)(86362001)(2906002)(6916009)(5660300002)(2616005)(83380400001)(54906003)(7416002)(6512007)(8676002)(107886003)(26005)(52116002)(6506007)(36756003)(66556008)(66476007)(316002)(8936002)(4326008)(478600001)(16526019)(6486002)(6666004)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: JR4OyKfqrULmW7do8A5hLJTDM9G05juWJiM4v2cj0UUrqVa4QYhWlHOeoaor9LsE2EUNv51eC4O51OrWZ3DE+KGrMKOBZUsYaJUgOyVtN1yckx1MTWvR+G4PAS2HQxBGKQkzYPJ/U+QtU4o22ptyPC6Hmy9uA3CYYa52ijc0PMRf2Cax6D3NBZ0TZIt+CLzw4sWYt9YtpBYRIz2wkXsgps0zxP3LwDDiauBheenL4rOo6Y5t6FvKpWZhbL5nm2NSKa6xdM7IS4TUT2iTk0NhaXWaoNyLSnRDu6kUloWZzSZ1rQlfTJFJvb+4M8KUOh0vEim+uf6cK9xGprcX8rpMzpOqAlgzVLMQpQr18xtursgteh0KOaZs62HZ2yWxqrvoAfu3uEeex5iIuMhOM47O16BGxRaw7o1qjSnfKThliwlqgkTIHmUGHON5vt8HQlaYPxxI4Qgh0rkbxQfcUqqzT+7fbJqRU9nwzoCjOy3Y0lU=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b9cf119-f07e-4599-e9d5-08d8251c2992
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 21:56:56.2669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UBwG04pDuB+cemw5kPI+2RmmmRMfiPiHHAN6TNgzU+qtGFFuJIsj2q0FBLH2LOXQz/NphO6lWQqTzIGljSf45Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3354
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

While the binding of global mirroring triggers to a SPAN agent is
global, packets are only mirrored if they belong to a port and TC on
which the trigger was enabled. This allows, for example, to mirror
packets that were tail-dropped on a specific netdev.

Implement the operations that allow to enable / disable a global
mirroring trigger on a specific port and TC.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 135 ++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |   4 +
 2 files changed, 139 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index fa223c1351b4..6374765a112d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -58,6 +58,10 @@ struct mlxsw_sp_span_trigger_ops {
 	bool (*matches)(struct mlxsw_sp_span_trigger_entry *trigger_entry,
 			enum mlxsw_sp_span_trigger trigger,
 			struct mlxsw_sp_port *mlxsw_sp_port);
+	int (*enable)(struct mlxsw_sp_span_trigger_entry *trigger_entry,
+		      struct mlxsw_sp_port *mlxsw_sp_port, u8 tc);
+	void (*disable)(struct mlxsw_sp_span_trigger_entry *trigger_entry,
+			struct mlxsw_sp_port *mlxsw_sp_port, u8 tc);
 };
 
 static void mlxsw_sp_span_respin_work(struct work_struct *work);
@@ -1134,11 +1138,29 @@ mlxsw_sp_span_trigger_port_matches(struct mlxsw_sp_span_trigger_entry *
 	       trigger_entry->local_port == mlxsw_sp_port->local_port;
 }
 
+static int
+mlxsw_sp_span_trigger_port_enable(struct mlxsw_sp_span_trigger_entry *
+				  trigger_entry,
+				  struct mlxsw_sp_port *mlxsw_sp_port, u8 tc)
+{
+	/* Port trigger are enabled during binding. */
+	return 0;
+}
+
+static void
+mlxsw_sp_span_trigger_port_disable(struct mlxsw_sp_span_trigger_entry *
+				   trigger_entry,
+				   struct mlxsw_sp_port *mlxsw_sp_port, u8 tc)
+{
+}
+
 static const struct mlxsw_sp_span_trigger_ops
 mlxsw_sp_span_trigger_port_ops = {
 	.bind = mlxsw_sp_span_trigger_port_bind,
 	.unbind = mlxsw_sp_span_trigger_port_unbind,
 	.matches = mlxsw_sp_span_trigger_port_matches,
+	.enable = mlxsw_sp_span_trigger_port_enable,
+	.disable = mlxsw_sp_span_trigger_port_disable,
 };
 
 static int
@@ -1164,11 +1186,30 @@ mlxsw_sp1_span_trigger_global_matches(struct mlxsw_sp_span_trigger_entry *
 	return false;
 }
 
+static int
+mlxsw_sp1_span_trigger_global_enable(struct mlxsw_sp_span_trigger_entry *
+				     trigger_entry,
+				     struct mlxsw_sp_port *mlxsw_sp_port,
+				     u8 tc)
+{
+	return -EOPNOTSUPP;
+}
+
+static void
+mlxsw_sp1_span_trigger_global_disable(struct mlxsw_sp_span_trigger_entry *
+				      trigger_entry,
+				      struct mlxsw_sp_port *mlxsw_sp_port,
+				      u8 tc)
+{
+}
+
 static const struct mlxsw_sp_span_trigger_ops
 mlxsw_sp1_span_trigger_global_ops = {
 	.bind = mlxsw_sp1_span_trigger_global_bind,
 	.unbind = mlxsw_sp1_span_trigger_global_unbind,
 	.matches = mlxsw_sp1_span_trigger_global_matches,
+	.enable = mlxsw_sp1_span_trigger_global_enable,
+	.disable = mlxsw_sp1_span_trigger_global_disable,
 };
 
 static const struct mlxsw_sp_span_trigger_ops *
@@ -1224,11 +1265,71 @@ mlxsw_sp2_span_trigger_global_matches(struct mlxsw_sp_span_trigger_entry *
 	return trigger_entry->trigger == trigger;
 }
 
+static int
+__mlxsw_sp2_span_trigger_global_enable(struct mlxsw_sp_span_trigger_entry *
+				       trigger_entry,
+				       struct mlxsw_sp_port *mlxsw_sp_port,
+				       u8 tc, bool enable)
+{
+	struct mlxsw_sp *mlxsw_sp = trigger_entry->span->mlxsw_sp;
+	char momte_pl[MLXSW_REG_MOMTE_LEN];
+	enum mlxsw_reg_momte_type type;
+	int err;
+
+	switch (trigger_entry->trigger) {
+	case MLXSW_SP_SPAN_TRIGGER_TAIL_DROP:
+		type = MLXSW_REG_MOMTE_TYPE_SHARED_BUFFER_TCLASS;
+		break;
+	case MLXSW_SP_SPAN_TRIGGER_EARLY_DROP:
+		type = MLXSW_REG_MOMTE_TYPE_WRED;
+		break;
+	case MLXSW_SP_SPAN_TRIGGER_ECN:
+		type = MLXSW_REG_MOMTE_TYPE_ECN;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+
+	/* Query existing configuration in order to only change the state of
+	 * the specified traffic class.
+	 */
+	mlxsw_reg_momte_pack(momte_pl, mlxsw_sp_port->local_port, type);
+	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(momte), momte_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_momte_tclass_en_set(momte_pl, tc, enable);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(momte), momte_pl);
+}
+
+static int
+mlxsw_sp2_span_trigger_global_enable(struct mlxsw_sp_span_trigger_entry *
+				     trigger_entry,
+				     struct mlxsw_sp_port *mlxsw_sp_port,
+				     u8 tc)
+{
+	return __mlxsw_sp2_span_trigger_global_enable(trigger_entry,
+						      mlxsw_sp_port, tc, true);
+}
+
+static void
+mlxsw_sp2_span_trigger_global_disable(struct mlxsw_sp_span_trigger_entry *
+				      trigger_entry,
+				      struct mlxsw_sp_port *mlxsw_sp_port,
+				      u8 tc)
+{
+	__mlxsw_sp2_span_trigger_global_enable(trigger_entry, mlxsw_sp_port, tc,
+					       false);
+}
+
 static const struct mlxsw_sp_span_trigger_ops
 mlxsw_sp2_span_trigger_global_ops = {
 	.bind = mlxsw_sp2_span_trigger_global_bind,
 	.unbind = mlxsw_sp2_span_trigger_global_unbind,
 	.matches = mlxsw_sp2_span_trigger_global_matches,
+	.enable = mlxsw_sp2_span_trigger_global_enable,
+	.disable = mlxsw_sp2_span_trigger_global_disable,
 };
 
 static const struct mlxsw_sp_span_trigger_ops *
@@ -1382,6 +1483,40 @@ void mlxsw_sp_span_agent_unbind(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_span_trigger_entry_destroy(mlxsw_sp->span, trigger_entry);
 }
 
+int mlxsw_sp_span_trigger_enable(struct mlxsw_sp_port *mlxsw_sp_port,
+				 enum mlxsw_sp_span_trigger trigger, u8 tc)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	struct mlxsw_sp_span_trigger_entry *trigger_entry;
+
+	ASSERT_RTNL();
+
+	trigger_entry = mlxsw_sp_span_trigger_entry_find(mlxsw_sp->span,
+							 trigger,
+							 mlxsw_sp_port);
+	if (WARN_ON_ONCE(!trigger_entry))
+		return -EINVAL;
+
+	return trigger_entry->ops->enable(trigger_entry, mlxsw_sp_port, tc);
+}
+
+void mlxsw_sp_span_trigger_disable(struct mlxsw_sp_port *mlxsw_sp_port,
+				   enum mlxsw_sp_span_trigger trigger, u8 tc)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	struct mlxsw_sp_span_trigger_entry *trigger_entry;
+
+	ASSERT_RTNL();
+
+	trigger_entry = mlxsw_sp_span_trigger_entry_find(mlxsw_sp->span,
+							 trigger,
+							 mlxsw_sp_port);
+	if (WARN_ON_ONCE(!trigger_entry))
+		return;
+
+	return trigger_entry->ops->disable(trigger_entry, mlxsw_sp_port, tc);
+}
+
 static int mlxsw_sp1_span_init(struct mlxsw_sp *mlxsw_sp)
 {
 	mlxsw_sp->span->span_trigger_ops_arr = mlxsw_sp1_span_trigger_ops_arr;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
index bb7939b3f09c..29b96b222e25 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -89,6 +89,10 @@ mlxsw_sp_span_agent_unbind(struct mlxsw_sp *mlxsw_sp,
 			   enum mlxsw_sp_span_trigger trigger,
 			   struct mlxsw_sp_port *mlxsw_sp_port,
 			   const struct mlxsw_sp_span_trigger_parms *parms);
+int mlxsw_sp_span_trigger_enable(struct mlxsw_sp_port *mlxsw_sp_port,
+				 enum mlxsw_sp_span_trigger trigger, u8 tc);
+void mlxsw_sp_span_trigger_disable(struct mlxsw_sp_port *mlxsw_sp_port,
+				   enum mlxsw_sp_span_trigger trigger, u8 tc);
 
 extern const struct mlxsw_sp_span_ops mlxsw_sp1_span_ops;
 extern const struct mlxsw_sp_span_ops mlxsw_sp2_span_ops;
-- 
2.20.1

