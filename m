Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B30317B227
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 00:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgCEXSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 18:18:05 -0500
Received: from mail-am6eur05on2074.outbound.protection.outlook.com ([40.107.22.74]:62017
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726049AbgCEXSD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 18:18:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mG2XhC4kN/8yfQ1azhMR5q3LvUm3LTjUa/hOebF7d26sQ6ybDy6yz+T8b5QN+ndZ5uSYnIpZuF34cH3Dv5dkMaNRspM9yJSk3ZWzFdWAj9plc5Fnl+kuRsitduOay+NTJvsEjJeJVxckhdPxq5KXrkzuD5o4dd5BX1pzygCEXq8fGqZtxrQsXoLzrPdIesTpw2FOHws6ud2keXmgNXPh6kdC2iaxb6oMaobKcUuD9hM596h/bpuiFd2iYuuT62HK8TGQqkkGmDa4puWrNGQP0RI92u247ICDVME8hhej6LD2DpdcKkVRweKDeLqPDGM1v/EIdizFwrIh4T+wbiIPRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fKfPvw902Z9hbPsOLBJu4dA8HtTtdn9U6HnFWEBngFs=;
 b=UOK84dg8we6DOqUI2nd6dYBlxV1GETRcdYvVzal5b9aFvNvxn6eFT2UOHjnWKNTJJuZL33xB/Z+NV3HVV6bER3+3jfcSpf1KIucSO0pBsr+vTZ47n0SIjpJbDY6Umizt4WuKFaI+BXNTKSBptET0yUvmz6U1YQ+r6xFpJ4TFx4s7J3CGUnak8OPfDFwuEburF6HJxchVm9oeLoyuDSwT5GezKIojgihLyIhjbyXrSa/uGNKJ7mkC6DLjtsZiutWC+3BecVUt8OjDu/lrH+dHGlMreNUVvDc2Ej2O1VwTogKvzj/MDyLtx9d6juGtOk168UZ95GKMVAOzqJKtp9lc8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fKfPvw902Z9hbPsOLBJu4dA8HtTtdn9U6HnFWEBngFs=;
 b=AoH30y/6m23j298BlLKORM4sliRadfoQFzTS0uwd6dPXIFazRfn4D6SmG09A8UjEEO0FtVJjvSl5thDqjK8Xtmx5toQjO3eEDbVdK6wsHm/rE/2iBqWPxE8HuJxcWvVYQUhw+o2A3T39yCRm/MAOF0RFgegBAOzv/amjVa9V1SY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4189.eurprd05.prod.outlook.com (52.133.14.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.15; Thu, 5 Mar 2020 23:17:59 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2772.019; Thu, 5 Mar 2020
 23:17:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 2/5] net/mlx5e: kTLS, Fix TCP seq off-by-1 issue in TX resync flow
Date:   Thu,  5 Mar 2020 15:17:36 -0800
Message-Id: <20200305231739.227618-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305231739.227618-1-saeedm@mellanox.com>
References: <20200305231739.227618-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0042.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::19) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (209.116.155.178) by BYAPR06CA0042.namprd06.prod.outlook.com (2603:10b6:a03:14b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Thu, 5 Mar 2020 23:17:58 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 272af892-e152-40f3-bb88-08d7c15b71c5
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:|VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4189110642009E778ECC9003BEE20@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03333C607F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(366004)(346002)(376002)(189003)(199004)(2906002)(81166006)(6506007)(5660300002)(6512007)(4326008)(81156014)(6486002)(52116002)(8676002)(54906003)(36756003)(8936002)(66556008)(66476007)(66946007)(2616005)(316002)(1076003)(86362001)(6666004)(956004)(186003)(6916009)(26005)(16526019)(478600001)(107886003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4189;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7baKNf5RyLWHRozmMICaYXHogyEDWG77lR18snYuNfyE5VG8xuCF8AfEza9x5V7wxn+/sVpGD2c1pz7uUmU/z3FQuL0wrIfUdKtJvRdRt2L+kuqSnovxo+7mXfmSu4Uv/dVkW30u+/W+gJXNX19F43YRbA5jmRgLIc1Lkhv/c1MWEZEGkk1/7NpyImrDqFVqj/yebjluSulLzwz6G/aQSqzZykPChmyoTOPJ4lvA5/ALp8WqUHU6BDRu574OhhpM7I3ZtbkGCCrxkLGysMJU+R7wvaMXe39j6sD7i4IiCFIbvl/WQ5ATkRd5UdsU0IzFO44PViOQCmfrBdrfvS72lStbqxGAVC2BZ6cEpGihnlk76KgPBYSG+AvcvDtUmQf4oZ90lQTv15Yxd5EZ6pKPCdgJr6XnYLHm5eGzWuGuQxzkeFPRBwtl5jadnLhdEzy50dHQHpEAhNPKgda4GAjKPsGTMLeuWDffr5E45qvbuhvN0ikpXvFp/ntp9IZpej79aZgs/sICeJnvNX4LpQ2YnMeilnV9vTjp29HSW/sOyO4=
X-MS-Exchange-AntiSpam-MessageData: JmTw40vt8rGOt0ENOmjxHqlk+7JHjFjlpHNfgTUlvTmA/vOHLTZ/nNI4uLTdp/kY+g0m7bq7cerPPT+Bjjj0Ki2ECClMDLIETVlTiqX95l4NHkPVRyWQwZXrG3A81zDVfE6Jtrh2XfS7/C6VNardiQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 272af892-e152-40f3-bb88-08d7c15b71c5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2020 23:17:59.2362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TkCQ3u8ptluicDMVv0VhdJByppC6p/d42RqqZdkya8wQx+VBUfp25w056Oxst8vrUHvKbexsuFPuKVV6eDIlSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

We have an off-by-1 issue in the TCP seq comparison.
The last sequence number that belongs to the TCP packet's payload
is not "start_seq + len", but one byte before it.
Fix it so the 'ends_before' is evaluated properly.

This fixes a bug that results in error completions in the
kTLS HW offload flows.

Fixes: ffbd9ca94e2e ("net/mlx5e: kTLS, Fix corner-case checks in TX resync flow")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index f260dd96873b..52a56622034a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -218,7 +218,7 @@ tx_sync_info_get(struct mlx5e_ktls_offload_context_tx *priv_tx,
 	 *    this packet was already acknowledged and its record info
 	 *    was released.
 	 */
-	ends_before = before(tcp_seq + datalen, tls_record_start_seq(record));
+	ends_before = before(tcp_seq + datalen - 1, tls_record_start_seq(record));
 
 	if (unlikely(tls_record_is_start_marker(record))) {
 		ret = ends_before ? MLX5E_KTLS_SYNC_SKIP_NO_DATA : MLX5E_KTLS_SYNC_FAIL;
-- 
2.24.1

