Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB397181F92
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 18:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730557AbgCKRej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 13:34:39 -0400
Received: from mail-eopbgr60070.outbound.protection.outlook.com ([40.107.6.70]:25761
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730522AbgCKRei (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 13:34:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DOcqc31AQN982LqzYnVryUhBReTiKSZ3c5IsaGNACgxbIZKEqTrNeYG6ulIHxmnZ8N+yKn1GIYSXPgGyNEw5iyzJEWUcTwrCVsStSc9Hm1Uhd2GI2nRFo2ZMQcgSEHdllcycXGCrM3eKMIo/PL9ngxYyFFYjuvqNzs9lgei7M5kedpRdkLH1gNHC75jyvU9UfBIjRF3snyKzTYtNeSN7Zul1voMkQGeV/Fhgc37d7YrzGkGXuGCFOsfAu4avyuwU4PA47unIP2fUXdsFACVN5t8niNO7jqIgreKna8oDuNleeIeEComW5iBB0rLlXNrmVhyC1CfEwIpEdI9Q368nLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H1Twu12jX7M/3foLcHNy8fMr8ryswpCVUrLsCpG6M8s=;
 b=NRw0WaBiGi7yuc5HHTPNnAfo6mCAaF5KLCm64XlW2tKVkvs6dN9MQD2Bv9Zcsr24Fb7RfV9P2Cv4EQ5PSxQ68il8oRhS5nGN87jkUHDdiFmMoiQcoYhMGVyW80gM4o+iWVOZw7U23HtZiMBCjuA/RAjg7SkD3twVNvPh1snYjWg467NJ8PCebgoP6kvrLZSidrbIU2qVjCcHVULTYm0draYi5l54m7OWqrNk+wA3e4UaZPy4wra6EdnuvvbJv3Ts2ClSkpZ/cHwCA1xvNEBUj4zAggdYyVhPjtqp3ziiDyoCrILR+0VzfdwjufldipMAbgrgWmxyo23e2ILWsGQRow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H1Twu12jX7M/3foLcHNy8fMr8ryswpCVUrLsCpG6M8s=;
 b=Sa/jYhHQASqZt55NQWeQzTtS6BaLGtvcQGkKZOCFI43NcbZ0tQnPhZWApOjmL2wf4IiO1DkWbmN4qZcsLeUcwkKVynJLO+Pp93Wj1P3Dd8i+XCRzhDsLz1XtCHUT4eR6c47SeolXEHTrivcM8vqIb2iPQs///VH4Ohgyr04QGh8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3449.eurprd05.prod.outlook.com (10.170.248.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Wed, 11 Mar 2020 17:34:33 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Wed, 11 Mar 2020
 17:34:33 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 4/6] mlxsw: spectrum_qdisc: Offload RED ECN tail-dropping mode
Date:   Wed, 11 Mar 2020 19:33:54 +0200
Message-Id: <20200311173356.38181-5-petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200311173356.38181-1-petrm@mellanox.com>
References: <20200311173356.38181-1-petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0197.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::17) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR0P264CA0197.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Wed, 11 Mar 2020 17:34:31 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f8ca3502-562c-4741-8c12-08d7c5e27629
X-MS-TrafficTypeDiagnostic: HE1PR05MB3449:|HE1PR05MB3449:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB34492F6A4F273DD423A180C8DBFC0@HE1PR05MB3449.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(199004)(6506007)(186003)(107886003)(6666004)(81156014)(4326008)(81166006)(26005)(16526019)(8936002)(8676002)(2616005)(2906002)(86362001)(956004)(36756003)(6512007)(66476007)(66556008)(6486002)(6916009)(316002)(478600001)(1076003)(54906003)(52116002)(5660300002)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3449;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V8Q4ORCvYwU4asmvIiy+0wpGVKoAW5Tw/nibBK0QY1+nuQkXj0FexSPJpZ3xvTg5bcJ5rLj380VUsD4hRQroSUEzDe4eeSjq/GUwubwmK1VoVmMrjYm9WVsXDzujSd4MvcjaPrSH65ddSRKq5hZIfXqOR2zQDQmortFMxKG1prLKgm7Z6KEJGesFwxSMCVY3kKkGDp6IbTYWepXGcQE9jVI+jSUBuudwL/JT6Oov79td0DfFkte6R/5TXQbK5xltwNMtaUgivJQcHAtxRyZ7V4UGEAGmp1tCyV6hxjl3DG3EmTB0gC21+x7m9GnBL6lKst1MKZmrzBnekIGRXnMQqFeX51NI+C0xaJf4/e6CE4PP8ws5N3YxeI+7sl7s7GwOGLmEXkJ/OECJJn6ym1I0yTcqC0J96OJl1HZZCR1oRY0CBu/RBPTSwwaz57Mtw3rQ
X-MS-Exchange-AntiSpam-MessageData: 0Z+6AuGLIqYFKXRYnAbT7o+RKx1CsnnRhl5YgpbOtn/DiD8AlZQib/qbmEjscR2VVCsDz2foP0NkrD6Hz0LRQWLtMm+lznmHKJ2M4U5RSCDA8qsA2xaHYk73SaodT7GC6zhCZboPIpaRlcbOnC1Srw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8ca3502-562c-4741-8c12-08d7c5e27629
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2020 17:34:33.3678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f4hIeQLdvk/twQ2jI90IbobALyCE/cJHEUOhZAE1t25Vul7OxGYKUXYVfYFznfdJVM0cYgdfo6sjLpZld5pyXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3449
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RED ECN tail-dropping mode means that non-ECT traffic should not be
early-dropped, but enqueued normally instead. In Spectrum systems, this is
achieved by disabling CWTPM.ew (enable WRED) for a given traffic class.

So far CWTPM.ew was unconditionally enabled. Instead disable it when the
RED qdisc is in taildrop mode.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index b9f429ec0db4..dee89298122c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -323,7 +323,7 @@ mlxsw_sp_qdisc_get_tc_stats(struct mlxsw_sp_port *mlxsw_sp_port,
 static int
 mlxsw_sp_tclass_congestion_enable(struct mlxsw_sp_port *mlxsw_sp_port,
 				  int tclass_num, u32 min, u32 max,
-				  u32 probability, bool is_ecn)
+				  u32 probability, bool is_wred, bool is_ecn)
 {
 	char cwtpm_cmd[MLXSW_REG_CWTPM_LEN];
 	char cwtp_cmd[MLXSW_REG_CWTP_LEN];
@@ -341,7 +341,7 @@ mlxsw_sp_tclass_congestion_enable(struct mlxsw_sp_port *mlxsw_sp_port,
 		return err;
 
 	mlxsw_reg_cwtpm_pack(cwtpm_cmd, mlxsw_sp_port->local_port, tclass_num,
-			     MLXSW_REG_CWTP_DEFAULT_PROFILE, true, is_ecn);
+			     MLXSW_REG_CWTP_DEFAULT_PROFILE, is_wred, is_ecn);
 
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(cwtpm), cwtpm_cmd);
 }
@@ -445,8 +445,9 @@ mlxsw_sp_qdisc_red_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 	prob = DIV_ROUND_UP(prob, 1 << 16);
 	min = mlxsw_sp_bytes_cells(mlxsw_sp, p->min);
 	max = mlxsw_sp_bytes_cells(mlxsw_sp, p->max);
-	return mlxsw_sp_tclass_congestion_enable(mlxsw_sp_port, tclass_num, min,
-						 max, prob, p->is_ecn);
+	return mlxsw_sp_tclass_congestion_enable(mlxsw_sp_port, tclass_num,
+						 min, max, prob,
+						 !p->is_taildrop, p->is_ecn);
 }
 
 static void
-- 
2.20.1

