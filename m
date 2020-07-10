Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07CE221BF72
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgGJV5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:57:07 -0400
Received: from mail-db8eur05on2045.outbound.protection.outlook.com ([40.107.20.45]:6078
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726582AbgGJV5G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 17:57:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PqpX99cX75yuwh9bDzfB9Z25USxNnfGXn4sVPWq4DSePE2AibFRsnd+AQreIfv3XSTZokz6D0u+Jl/v9NaHu4d4MFtczq9Sbb2wRUuXOgK2BPPXhjv0pAXb9y8FWhZFVp+w0qEzIneaUVJv8JfYsAldfHXZsWVto+HsZBP4qMFs0gTdPV1ht2waU4oIJ2sugND9dRpg9e/DBiViwG34bee51gqQKPIO2ApzPT8Ebk6Bfh6vPLhOxHaGjm4ebfTrop4hAjOBq6OVG3eKUBH8GnT9DFJ9VjHKlJC39rZgQAuNV2zaMs6Kt8JrhDdJ/6sWSQidKPHFGaCDbHl5U7wFA4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aPfIauCvOAlqbeSU/O2ToksBrrvB9PetHPKxP9lAV1c=;
 b=ZLyN/VwE1cPbNXOOuSn+6M/oE8I7RlZKRi9RtYXz2/NyNymr10MKOCQoCvq8LrRXBIi5QBUQrslQqUB6+Wi0V+fUofXmHyWD/OTUhhnMMrL4EM4ECsOryE+slPJI+mIol+j5B/TgJpCTK8EsgvNBLlX4B8m+f6Ve58fDnkSenHP5ybCKVnY5Anm+7A3zNYrhY98cIRRlFMo86/gMZLI1y79Twk5W/XA9BNbv+rNVPjEgEqnRW6x1N6auiJcWKu9jtR/IhhHC4D3qDblcwtE+UZPP6j7qT30RNKcfEWvotQB/1Nc/USnrbjdJS6KmNWV+kEfW1hzjLTXzAC0ey8g0jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aPfIauCvOAlqbeSU/O2ToksBrrvB9PetHPKxP9lAV1c=;
 b=btZu/JT5kYZO9rV08NVyTHOA1PNIwFixqALhHYSvfluta0p6NopX+Dyx6bRaCB0/r6JXm4+B2KYGFMoIvvw1iLP+Ja+v5qJ3hQom4cuXwJtV72hSg8B7XHM2gLt3tWqLzUQ5Zr3v5gNERxdBNf2tE71qc6L/eC/0vIt5+/PO6V0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3354.eurprd05.prod.outlook.com (2603:10a6:7:35::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.20; Fri, 10 Jul 2020 21:56:53 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 21:56:53 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
        kuba@kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, michael.chan@broadcom.com, saeedm@mellanox.com,
        leon@kernel.org, kadlec@netfilter.org, fw@strlen.de,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 06/13] mlxsw: spectrum_span: Add support for global mirroring triggers
Date:   Sat, 11 Jul 2020 00:55:08 +0300
Message-Id: <5690ebe81f87edd070feceee15da306b4e24b8b2.1594416408.git.petrm@mellanox.com>
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
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM3PR07CA0116.eurprd07.prod.outlook.com (2603:10a6:207:7::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.8 via Frontend Transport; Fri, 10 Jul 2020 21:56:51 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e445b4cd-729a-4cbf-7d30-08d8251c2829
X-MS-TrafficTypeDiagnostic: HE1PR05MB3354:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3354521C7D1676529DDD8502DB650@HE1PR05MB3354.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BzoS2j/h8OVatTHhusfU/Ne8JtqmyoGQgZlLm/Bb+F2A5UUm4NRT4pn3EUIjVaBOM7/FXN68W6YrPdlo9owTEkdRTm/ztobhEWwo4KjUU8ez0AxfqxaD4ox/z6iA1iwMC+yoUth3BStt6ScY7SA+j6fwmwaSUf0P5yy1xJ9ffsJGe0lDV+Zp+yGu6J9MblCkmQ9bKkvBIImW+kiVlgAd8TpVvNa4HyGu3JYapHR4P+ySEOO5YXxZv4nLtF2QBQ4omHn/VXxRNyJOVaKX+6w/eq1zOzQ/jyaa9sAYgiRv2k6L3i4lMVgj121RTeUAYoswkWHeRiZH0UA5cnO7pUqQlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(956004)(86362001)(2906002)(6916009)(5660300002)(2616005)(83380400001)(54906003)(7416002)(6512007)(8676002)(107886003)(26005)(52116002)(6506007)(36756003)(66556008)(66476007)(316002)(8936002)(4326008)(478600001)(16526019)(6486002)(6666004)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: hGV6Hs5gIF6frvEmmUeMvmKYkLJmONFTS+K9SiyaHukizU+63PN0GlPIn3REUUbABspqLBuwfB81Jk7XgKP/3aqfoeK8qurR1kr9eZq7RlcTHTDzM/cKd4GpYLIcHmAmLY6iRQkYJV4ZIJG1Rlsuf80pLRZrXC4IUhOhNeWxTgd2Pujo9a7wFXYj5E3KI0UhNVLLqi8EdUCjWnijr4ZdnIQDUuN3M9WRcl7UBsHSfWK1/Zw8l1zR83iutCHgIDR+Six1rnYGyprTc/UP/XWc16pJUn4BdaJwLqGcrX7rUpBduzttoMmQw3lLKJBtgXwYuXF8cRfUJBkOcl7RZwVazb392rKxOELP+zmSrVasi5X3NjtoS446x9oydMh2OM/BEvjdSDzkUrZnVJNZpHYDjgIVOHuNy44B69zeF7idNrsRYTJT5VlQeTv7SdPQjzQqh0HaGEBDe9d5dbpFs4lBBp2cV/8mwNzO/q0vZJEtKdnDbYjX3nOaBQO2SO+bMcny
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e445b4cd-729a-4cbf-7d30-08d8251c2829
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 21:56:53.8963
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xryeozffiSL+Jt43YqxYMY19DC6MBfSja2t3PoUtrYcjEY2uJGAZ3TZVihdUFyAGWmmLd6budngQMKCVstmNuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3354
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Global mirroring triggers are triggers that are only keyed by their
trigger, as opposed to per-port triggers, which are keyed by their
trigger and port.

Such triggers allow mirroring packets that were tail/early dropped or
ECN marked to a SPAN agent.

Implement the previously added trigger operations for these global
triggers. Since such triggers are only supported from Spectrum-2
onwards, have the Spectrum-1 operations return an error.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 104 +++++++++++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |   3 +
 2 files changed, 104 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index b20422dde147..fa223c1351b4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -49,6 +49,7 @@ struct mlxsw_sp_span_trigger_entry {
 
 enum mlxsw_sp_span_trigger_type {
 	MLXSW_SP_SPAN_TRIGGER_TYPE_PORT,
+	MLXSW_SP_SPAN_TRIGGER_TYPE_GLOBAL,
 };
 
 struct mlxsw_sp_span_trigger_ops {
@@ -1140,9 +1141,101 @@ mlxsw_sp_span_trigger_port_ops = {
 	.matches = mlxsw_sp_span_trigger_port_matches,
 };
 
+static int
+mlxsw_sp1_span_trigger_global_bind(struct mlxsw_sp_span_trigger_entry *
+				   trigger_entry)
+{
+	return -EOPNOTSUPP;
+}
+
+static void
+mlxsw_sp1_span_trigger_global_unbind(struct mlxsw_sp_span_trigger_entry *
+				     trigger_entry)
+{
+}
+
+static bool
+mlxsw_sp1_span_trigger_global_matches(struct mlxsw_sp_span_trigger_entry *
+				      trigger_entry,
+				      enum mlxsw_sp_span_trigger trigger,
+				      struct mlxsw_sp_port *mlxsw_sp_port)
+{
+	WARN_ON_ONCE(1);
+	return false;
+}
+
+static const struct mlxsw_sp_span_trigger_ops
+mlxsw_sp1_span_trigger_global_ops = {
+	.bind = mlxsw_sp1_span_trigger_global_bind,
+	.unbind = mlxsw_sp1_span_trigger_global_unbind,
+	.matches = mlxsw_sp1_span_trigger_global_matches,
+};
+
 static const struct mlxsw_sp_span_trigger_ops *
-mlxsw_sp_span_trigger_ops_arr[] = {
+mlxsw_sp1_span_trigger_ops_arr[] = {
 	[MLXSW_SP_SPAN_TRIGGER_TYPE_PORT] = &mlxsw_sp_span_trigger_port_ops,
+	[MLXSW_SP_SPAN_TRIGGER_TYPE_GLOBAL] =
+		&mlxsw_sp1_span_trigger_global_ops,
+};
+
+static int
+mlxsw_sp2_span_trigger_global_bind(struct mlxsw_sp_span_trigger_entry *
+				   trigger_entry)
+{
+	struct mlxsw_sp *mlxsw_sp = trigger_entry->span->mlxsw_sp;
+	enum mlxsw_reg_mpagr_trigger trigger;
+	char mpagr_pl[MLXSW_REG_MPAGR_LEN];
+
+	switch (trigger_entry->trigger) {
+	case MLXSW_SP_SPAN_TRIGGER_TAIL_DROP:
+		trigger = MLXSW_REG_MPAGR_TRIGGER_INGRESS_SHARED_BUFFER;
+		break;
+	case MLXSW_SP_SPAN_TRIGGER_EARLY_DROP:
+		trigger = MLXSW_REG_MPAGR_TRIGGER_INGRESS_WRED;
+		break;
+	case MLXSW_SP_SPAN_TRIGGER_ECN:
+		trigger = MLXSW_REG_MPAGR_TRIGGER_EGRESS_ECN;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+
+	mlxsw_reg_mpagr_pack(mpagr_pl, trigger, trigger_entry->parms.span_id,
+			     1);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mpagr), mpagr_pl);
+}
+
+static void
+mlxsw_sp2_span_trigger_global_unbind(struct mlxsw_sp_span_trigger_entry *
+				     trigger_entry)
+{
+	/* There is no unbinding for global triggers. The trigger should be
+	 * disabled on all ports by now.
+	 */
+}
+
+static bool
+mlxsw_sp2_span_trigger_global_matches(struct mlxsw_sp_span_trigger_entry *
+				      trigger_entry,
+				      enum mlxsw_sp_span_trigger trigger,
+				      struct mlxsw_sp_port *mlxsw_sp_port)
+{
+	return trigger_entry->trigger == trigger;
+}
+
+static const struct mlxsw_sp_span_trigger_ops
+mlxsw_sp2_span_trigger_global_ops = {
+	.bind = mlxsw_sp2_span_trigger_global_bind,
+	.unbind = mlxsw_sp2_span_trigger_global_unbind,
+	.matches = mlxsw_sp2_span_trigger_global_matches,
+};
+
+static const struct mlxsw_sp_span_trigger_ops *
+mlxsw_sp2_span_trigger_ops_arr[] = {
+	[MLXSW_SP_SPAN_TRIGGER_TYPE_PORT] = &mlxsw_sp_span_trigger_port_ops,
+	[MLXSW_SP_SPAN_TRIGGER_TYPE_GLOBAL] =
+		&mlxsw_sp2_span_trigger_global_ops,
 };
 
 static void
@@ -1156,6 +1249,11 @@ mlxsw_sp_span_trigger_ops_set(struct mlxsw_sp_span_trigger_entry *trigger_entry)
 	case MLXSW_SP_SPAN_TRIGGER_EGRESS:
 		type = MLXSW_SP_SPAN_TRIGGER_TYPE_PORT;
 		break;
+	case MLXSW_SP_SPAN_TRIGGER_TAIL_DROP: /* fall-through */
+	case MLXSW_SP_SPAN_TRIGGER_EARLY_DROP: /* fall-through */
+	case MLXSW_SP_SPAN_TRIGGER_ECN:
+		type = MLXSW_SP_SPAN_TRIGGER_TYPE_GLOBAL;
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		return;
@@ -1286,7 +1384,7 @@ void mlxsw_sp_span_agent_unbind(struct mlxsw_sp *mlxsw_sp,
 
 static int mlxsw_sp1_span_init(struct mlxsw_sp *mlxsw_sp)
 {
-	mlxsw_sp->span->span_trigger_ops_arr = mlxsw_sp_span_trigger_ops_arr;
+	mlxsw_sp->span->span_trigger_ops_arr = mlxsw_sp1_span_trigger_ops_arr;
 
 	return 0;
 }
@@ -1303,7 +1401,7 @@ const struct mlxsw_sp_span_ops mlxsw_sp1_span_ops = {
 
 static int mlxsw_sp2_span_init(struct mlxsw_sp *mlxsw_sp)
 {
-	mlxsw_sp->span->span_trigger_ops_arr = mlxsw_sp_span_trigger_ops_arr;
+	mlxsw_sp->span->span_trigger_ops_arr = mlxsw_sp2_span_trigger_ops_arr;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
index b9acecaf6ee2..bb7939b3f09c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -26,6 +26,9 @@ struct mlxsw_sp_span_parms {
 enum mlxsw_sp_span_trigger {
 	MLXSW_SP_SPAN_TRIGGER_INGRESS,
 	MLXSW_SP_SPAN_TRIGGER_EGRESS,
+	MLXSW_SP_SPAN_TRIGGER_TAIL_DROP,
+	MLXSW_SP_SPAN_TRIGGER_EARLY_DROP,
+	MLXSW_SP_SPAN_TRIGGER_ECN,
 };
 
 struct mlxsw_sp_span_trigger_parms {
-- 
2.20.1

