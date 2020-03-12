Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8C0183832
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgCLSGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:06:04 -0400
Received: from mail-vi1eur05on2065.outbound.protection.outlook.com ([40.107.21.65]:6068
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726420AbgCLSGE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 14:06:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JFzG5oHDxtz24ua8rNIRLOGKxS2mmRMsrDToj+yYHXDKjTpBdMjg1maE4rPmGtxCaRH0ss5PqJDC3wsMAENUPuzpLaiU3NBx1ySgy+gfeVCESPGS/qpnarLAjggfmJIMHIasy2ki/bNhCZ7DETDTRvLR3EXZo4sPqs9d9+ZN1akV9C/0we4nRbCkSqbld1OME8mvzZ58Rqoe39fIsSmMoA+8R0d5xIa+k4h/EbMLarTODmEtrR6Cnnu3o24zoxLZn8Ltcog6Dux7a59CUbSQN06e8EFMCjByywnh/SPK8flnyE+zrcidBMhvLaoGkJPpihmZQoCXFpgIuEHMKILSUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S8lnGBZqTfNuKdmW0q4BxNC48dI89Z542JQ6ITPx8Xc=;
 b=cZxCFiQCicfDuCckbBEhCZy6WiQ/nJ0hFUj13QH1MpfgUHJLzzPTFNNtMHIvGhbSYzyLPPFPy7rDsX6XY9hRrQhZtsQi5bFEpKDffCKwlt05yCFgzyaw1dFMGStaTV8p0SnjI35F4IHCdI1Ne3ZPq64irGk8xAN2x2Le8eQKIGYnVpRp/uJu4HLjyC6NlTUKrTugbhD6ldvEZi0zQvPIA7VMjFCeby9JoRy51J6zOBlnJhBPI4Yd/XODeeH/zeIGghqWyndD92yeWnXrSVUuxuiwEEl/OOb4UfVRi3a+kSSi7FXp29blU3l1x5B8HYM0NjsOHqUKSl+W958DED1mSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S8lnGBZqTfNuKdmW0q4BxNC48dI89Z542JQ6ITPx8Xc=;
 b=jbKwCX+g91lUoQ7sVnKrXXHNG1xVNo+0wCzEOi4e1OjI06YtFO3rOUAQmuvyM4KjLW4EuyJkArTCJSbLrGF0ABZmIoXXWCosQWslO37oNe50LHSKWrfFhj+7j0IrJa07ZKxxs/xbf90TH3I2Ug80ZeRSke5id2qChuc5OPfOJUE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3499.eurprd05.prod.outlook.com (10.170.243.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Thu, 12 Mar 2020 18:05:44 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 18:05:44 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [PATCH net-next v3 4/6] mlxsw: spectrum_qdisc: Offload RED ECN nodrop mode
Date:   Thu, 12 Mar 2020 20:05:05 +0200
Message-Id: <20200312180507.6763-5-petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200312180507.6763-1-petrm@mellanox.com>
References: <20200312180507.6763-1-petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P191CA0043.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:102:55::18) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR3P191CA0043.EURP191.PROD.OUTLOOK.COM (2603:10a6:102:55::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Thu, 12 Mar 2020 18:05:42 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e0754d16-889c-4ad0-49ff-08d7c6affba0
X-MS-TrafficTypeDiagnostic: HE1PR05MB3499:|HE1PR05MB3499:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3499AB9ADA9206A13850DA5CDBFD0@HE1PR05MB3499.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(199004)(6486002)(52116002)(81156014)(81166006)(956004)(8936002)(2616005)(86362001)(54906003)(4326008)(6916009)(316002)(107886003)(186003)(26005)(6512007)(6666004)(16526019)(1076003)(2906002)(8676002)(36756003)(478600001)(66946007)(6506007)(66476007)(66556008)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3499;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6mvYp+QvFbdQoWYnEcO9J7GxVMoi0hOznocVxjNJWzAjZEPRWcY5U320+ax2CdwsxEriJ/2msdQR4UqfQ6uXAIS8IoGbXNE0CcrrB6ok+2qCh9Oy2wSkLB3eCylUl4ae5lzGf01OuMaLOGTObx/iEfTWjPdTdOIl7uhsaqCcFqYMHtAKDkGNmzGRWCTHIDcfgt7+oSn2xTA1ulTQaXlDKyqI4j9ifWP8HItgh54OZjK+Gy2rKESMo9piph6rJjZNgVsO1oxvRteSkLBmGNipgyde0UsZd1gIB2u1R9ApoaAIegM1HUHHK13towvNqIodHz6QnvX0fDaqConMXLHAY+RQxoLK97eWHfYCocYUGHYfFX6BgI3+Dq7Zub8OQkhinaCAg1v2b4DbvtsLaHpP/JXf/K1TkQTlIoaPTKdBu6Kc9AX71gl//sNC5AVMEDM8
X-MS-Exchange-AntiSpam-MessageData: 4ehlHl2avvU2ae8PchdsLtzYEG4zSOkA30KnV2XDRifTmHzB4BLPHSUV8Q+06meyUSXPRjVk+bENDN4Odcw0/Sl4ejP0c2p0EVIbEFStnqY1l2kt8RJkRvRBH7stzCwkFXf/hIj6zZzh8apVc+76ig==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0754d16-889c-4ad0-49ff-08d7c6affba0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 18:05:44.3304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MLBBZfnK1KWtMTrd4KJ/0xoYBwgvGMOASSzqTNmxww5T+34F3yac3aBGttjl1LGanmKx5IGXfkkvFgVe7XkBig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3499
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RED ECN nodrop mode means that non-ECT traffic should not be early-dropped,
but enqueued normally instead. In Spectrum systems, this is achieved by
disabling CWTPM.ew (enable WRED) for a given traffic class.

So far CWTPM.ew was unconditionally enabled. Instead disable it when the
RED qdisc is in nodrop mode.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---

Notes:
    v3:
    - Adjust for the rename from is_taildrop to is_nodrop.

 drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index b9f429ec0db4..670a43fe2a00 100644
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
+						 !p->is_nodrop, p->is_ecn);
 }
 
 static void
-- 
2.20.1

