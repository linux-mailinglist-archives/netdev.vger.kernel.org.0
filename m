Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9CC1E8DCB
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 06:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgE3E1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 00:27:05 -0400
Received: from mail-eopbgr130058.outbound.protection.outlook.com ([40.107.13.58]:61765
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725889AbgE3E1D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 00:27:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YzRfggD/QvcIHnNAuD1ef6KHx6yHdgC70QAuN2P9NlAWBJhjXCafnxlzzBwyCeJakJVNKXOERVU7JPoGKWapJcyMNC70sAHgtOvv8OW45eTYCd0Ie6mHK5y3uFbZ5LBMR+znmhziDco5McHBKRIt0WGGrqKRK/c4fnSchWKdWG4ZVuaGLGAb4x5UEuNg9ph7vsxDQD3L/LaU1fG0GUF8nsX5EuLW2w32BPfOfQDWO6tPiaazJsdj31pWBgxIuzWZ2gDVaDjPmGlIIx69XwbcPsrFAALNLzaLyttqFiLo+gOOIxgaACSg17F6Ii6nbI8V10obYCqD3CScOqCnSL3Sig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ads9VMVEcu7tbt70RXyZzdRQliUlklhQOk7OEP1jV1g=;
 b=TZuWfGBE/er6bJ+zJYWBAL4p4veyskq6JnMAnIh0oiDgW2GjSp49gbaUHKtPLP5TBSaTNsVbqNukeynbKEcxCW0FxkkQa6Y5sa9c+ZPPJhDPOd1N2Sq+uKs+iwEWio/s37HRq3sCWvfQRJa6AyrEFmgF7IfJ3Atbp2EE54fZSVjIdpGey8siO3JvxInX82gVljTk5zaOXJnS2SRIohbb9jVkrs4olM2ZOHZA/FBTkPfyr88ZGYBOmTitGBDPGNFgsx4Z9tq12NWrLp6XFO4h8NseKWJ/dNWuLzXQErrPQpR90f+HtSGcSyZPAVwnBNJMSLJcKdE4t/Xf87/XzrV4Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ads9VMVEcu7tbt70RXyZzdRQliUlklhQOk7OEP1jV1g=;
 b=pgF+MLTfm7RtZnda1HweEtVRZQHzaUjxvKJJ7RvMzE+JaLwfW5trNBde/AV0kSpzesz19YbwUlJhsVrZ5J3eUbpoHALVuLk8gzr7XXuS2BaOFnBMZPstDp53OV4SawxNYet2BnJ8ZGlWUL8DnhslFtTAY6IykG9Ffya3fVtFnoo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3408.eurprd05.prod.outlook.com (2603:10a6:802:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18; Sat, 30 May
 2020 04:26:56 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Sat, 30 May 2020
 04:26:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/15] net/mlx5: reduce stack usage in qp_read_field
Date:   Fri, 29 May 2020 21:26:15 -0700
Message-Id: <20200530042626.15837-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200530042626.15837-1-saeedm@mellanox.com>
References: <20200530042626.15837-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0004.namprd05.prod.outlook.com (2603:10b6:a03:c0::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7 via Frontend Transport; Sat, 30 May 2020 04:26:54 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 609e21cc-254c-44cb-7885-08d80451af9e
X-MS-TrafficTypeDiagnostic: VI1PR05MB3408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB340802DB0B0E349B6813D314BE8C0@VI1PR05MB3408.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NUHYug+x3NbFm5j9etivbY8WCOTOL2h4OZ3tPZfmnX6fwdDko0GrSC0UON5DPTWKfmIq2oNwCEd0bG+RDnT3YMgoXTe0LTgwFKLQPfUYJE7hXbKCuhEcsnitA8sqmt7Bawfqi6zQ5e1A22vuWXQRgqj5doEPgTl5yXIq7qBfFvxL52koucxmjf4UF6BLth0G3w3BDs6PgqH+97yL4gqSNUhYXCzoaCNfaCc69yAhDNrTP5McTXo+n973mfSPgcl9XvpyJNhULu3c0c8JaA+54jiF/jWKps7cV+qlki96ZU/y0uHbP7B4r7RVg2H/pnWKyyBZP3m2kV2Hr7dPMpCSNfaWMjiaIsgq6CBcuv3/nw/GsRiteTeS9OeHz6QN8i3S
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(52116002)(5660300002)(6666004)(107886003)(186003)(66476007)(26005)(16526019)(66946007)(478600001)(1076003)(8676002)(4326008)(6486002)(66556008)(2906002)(956004)(86362001)(6512007)(83380400001)(316002)(6506007)(36756003)(2616005)(8936002)(54906003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 96kvuvrGWGijlB5OsJvmvZd/f6pdjU0oPxGgKvRmEQ82powGr7LdZVwRtCh/lTrcLHNQAMc2YiBD7J1b7FIfMazrAAeFk/R7sUDKNlh4WT1sJhz6qt+nEU6OR8MaByhaSo+/5e7TUBOCs1vireR5yoYnCPZUWOLbXmoWW4SlpEPPWsZs7nTJDOq2e9yIYTyqXLV0utBTG0I3N+4GhF28snxyrH6T7vBnajnuQS4T7feqGHq2NQkrzGWX09GQ5Y9NT+OFCFhw/3jWPe/YOTYTsFq0nXvplpNSURcZn96t6W7C+noEKUht8vrHlv/KrQD68Siv/7e7+6IYCE/fw8JisSMpXwL5he2ALNIf9GcoeuiqZyvU/u69VOO/HJvEWtDBUjPFHnrmFoV7XzNEU951Y2YcmfFTmqdSazYLzmzsfyFDVg459tMEN3csx3N3NSh1kaF52ryhwWAecNMkiCk4U4yINPDhRu/KFUAlXlg9LmE=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 609e21cc-254c-44cb-7885-08d80451af9e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 04:26:56.1773
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ew0v3ZC0GDiGlpTt3Gcwll25iuD5HriYFXgXS2TdYWW6xPZcxquRV6LSCHdLS7uTYH7y/siPWwGIEz7uppf7Og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Moving the mlx5_ifc_query_qp_out_bits structure on the stack was a bit
excessive and now causes the compiler to complain on 32-bit architectures:

drivers/net/ethernet/mellanox/mlx5/core/debugfs.c: In function 'qp_read_field':
drivers/net/ethernet/mellanox/mlx5/core/debugfs.c:274:1: error: the frame size of 1104 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

Revert the previous patch partially to use dynamically allocation as
the code did before. Unfortunately there is no good error handling
in case the allocation fails.

Fixes: 57a6c5e992f5 ("net/mlx5: Replace hand written QP context struct with automatic getters")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index 6409090b3ec52..d2d57213511be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -202,18 +202,23 @@ void mlx5_cq_debugfs_cleanup(struct mlx5_core_dev *dev)
 static u64 qp_read_field(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp,
 			 int index, int *is_str)
 {
-	u32 out[MLX5_ST_SZ_BYTES(query_qp_out)] = {};
+	int outlen = MLX5_ST_SZ_BYTES(query_qp_out);
 	u32 in[MLX5_ST_SZ_DW(query_qp_in)] = {};
 	u64 param = 0;
+	u32 *out;
 	int state;
 	u32 *qpc;
 	int err;
 
+	out = kzalloc(outlen, GFP_KERNEL);
+	if (!out)
+		return 0;
+
 	MLX5_SET(query_qp_in, in, opcode, MLX5_CMD_OP_QUERY_QP);
 	MLX5_SET(query_qp_in, in, qpn, qp->qpn);
 	err = mlx5_cmd_exec_inout(dev, query_qp, in, out);
 	if (err)
-		return 0;
+		goto out;
 
 	*is_str = 0;
 
@@ -269,7 +274,8 @@ static u64 qp_read_field(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp,
 		param = MLX5_GET(qpc, qpc, remote_qpn);
 		break;
 	}
-
+out:
+	kfree(out);
 	return param;
 }
 
-- 
2.26.2

