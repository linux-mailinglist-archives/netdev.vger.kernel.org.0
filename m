Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF6C183D19
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 00:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgCLXMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 19:12:52 -0400
Received: from mail-eopbgr10083.outbound.protection.outlook.com ([40.107.1.83]:26253
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726710AbgCLXMv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 19:12:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kgqz3dbJaTJP8Gnfo0/fT+snZewfXFIkvIFXKfnHIFFcstZfp7WonJxNbwBx6PMq68Ul3S9ZKjzMEaNEgtySm4Yfc7dZXKBl6n5rh73KXx2OIhoCMxy9lUjY9q9akbV/eicolwz/xvm78Gd9sKL4jBVUjFN1U+imaZcaUw7WATICNmRhS+zqQLIV3vsIMH0W9GWBx9xgtH6j1jr4dls08kzFdflDqcGYxFmjWCyrtr35Tu5OxB7fXNtStrE22ETnd+Tk6u3P8eecCFX02dliBYgtGza0kIjbUi2bxIICxM73VPtfy8I9f0sBqcQ08CmpZLhD1oPal/0ti3s1/JZISA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S8lnGBZqTfNuKdmW0q4BxNC48dI89Z542JQ6ITPx8Xc=;
 b=P4drBck2K3u19Hts6fE1lVtWg6u8ASpiCrsQxldd5Ggb/GRAnJS8m4C/aZOssxme+cCqWvAoTdoG3rNV4x5dOjFWy3ULOnb+buolptuQ8Snbwy5DCYDfMY8MrTM6MFuy9YNT39F5ahijJRY123k6yl7ZBrhELUxJ//nRgN+QAlYFyGm1IgB0yTz+D3lHBdHQGBt19JPbt0QjLJO20hVPLoZUDmFd4sXFw8/QoVcGCv1KRY1qfLtlclxDcCEHpPjFrrbLylv+ZtRpjge4B1jaDoclN5dDsxPShA4S7qcJERCvDNrvO/aJuw9HvOEx1PYY7HvfyXt3UmQMjHuRmBg1UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S8lnGBZqTfNuKdmW0q4BxNC48dI89Z542JQ6ITPx8Xc=;
 b=J6l8rQRH/uyxPa1reBXJw3U2vmZtKczya02XZFox5xXkgsim/iQbncIK4xlhK26AWJzyh4yUbeVlSgOejFGg9qlwWeULZoIZK9NZzbvY+22tR4Qn4yf08406IBedJ0xPS/2eL5FN9dYZrnccprSHUJ6wXQewuZlOIN9NBR/jhYo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3194.eurprd05.prod.outlook.com (10.170.241.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Thu, 12 Mar 2020 23:12:42 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 23:12:42 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: [PATCH net-next v4 4/6] mlxsw: spectrum_qdisc: Offload RED ECN nodrop mode
Date:   Fri, 13 Mar 2020 01:10:58 +0200
Message-Id: <20200312231100.37180-5-petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200312231100.37180-1-petrm@mellanox.com>
References: <20200312231100.37180-1-petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR2P264CA0002.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::14)
 To HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR2P264CA0002.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.20 via Frontend Transport; Thu, 12 Mar 2020 23:12:40 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fccefa7c-b218-40df-1547-08d7c6daddc7
X-MS-TrafficTypeDiagnostic: HE1PR05MB3194:|HE1PR05MB3194:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3194D3554585286C889BE00CDBFD0@HE1PR05MB3194.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(199004)(316002)(2906002)(66556008)(8676002)(66476007)(66946007)(4326008)(54906003)(81156014)(81166006)(6666004)(36756003)(1076003)(5660300002)(6512007)(6506007)(6486002)(52116002)(478600001)(16526019)(107886003)(26005)(8936002)(6916009)(956004)(86362001)(186003)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3194;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FEgay71cnWI2zvOzLeL/oUvg2zyapPvnmIRBTDmmpirvwsguhH7GIsb+m+VYut8kwrVm76EDUs/yLrduQxCxXb2yGsmSZ2/wEZNw67foDlfNaEh5vsfUghnX1qn6uBi7+nlQu1/uRhOo82a/EKI63Ca2O1xFVBMTC/z9G41Rpo8ct+5qUZEVnLbVcD4oyhteXkEK4sp3QnQWDARCZoZo47/PS9VDBzGEf7/59JP1ruCz7mHFCETeWtqjSnTAZ9AGzI9M0qGNN604tp9oAPKDqpQGTEtouFhz/vtmBEuD8C0Lkkmus4LX8fmd1RMbUFd+EP5up+BKgscH/3lgJelBqdOZZm2UlAKA1Sox4OiI/AvHNnkgJhqtUGd+Ri4bY4rpdGfML8FXuiTTMu/FaIxHuyQGRBjvE4sWfkqyHwxP0cSIu+ilQu7zs9l46xjYCW18
X-MS-Exchange-AntiSpam-MessageData: EybT/6e2Jy+0ovwy+1pryvoggvQkHFyHrq3yTAWvO1kqhE1GmBS/R+lfdQ2TlrZOsX64oksNPxsj6IHVGEKXnATWwoV9i2BUR8QmBamiYbtyT4MH9pC9K0yfIFGLOCXorGZ8mKoBK5es375Q4O9Xtg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fccefa7c-b218-40df-1547-08d7c6daddc7
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 23:12:42.4585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cFzL/F9ZVj2DG2Kw6axoYn0RsZlFgqFGaXlNeh1KTbjHoqmNtaRbgW22A3k0AsqVQnVcWjGo1aNYBQd0mFJzVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3194
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

