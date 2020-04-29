Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A991BEC35
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 00:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgD2WzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 18:55:20 -0400
Received: from mail-eopbgr10044.outbound.protection.outlook.com ([40.107.1.44]:62734
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726921AbgD2WzT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 18:55:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TV66nJ6ieitJXLrjqWOl+uaBthEhdKpbgzDbg10s9tK8HKonqcokbr+uTKGhlCge4fErbIrG5DIiX55tDota2i/Y596D4XlP0bQqH+l0LlcC5IsJ4VXJIMtGy2vXqooTB22O0U+Ja2RlUqaQCOYJjc8fkaO4OCaQQI53Se8H/LfvYUy7swEK4ekg28+jKhJqcvJOyg/Hs3H7mZLOSbJyVfJn3kwKltytI+YHC1PsmzS0fTpGV/AKd5M7pfo29JEidixJCejbdSk+b1cWssWwzxjidPG73X20kd+jHK4iz93oiYGr4C2uW9CXN3o0fTUFGcd/b0N9dclTIHLmR0DExQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvHeERn0eXqOMzXM7akpVNlcZYNngzJx4qJAga6mxKA=;
 b=lfocPlP9Y7NWl13mVWXKOSOgLNcDk3gnTfcZVN13s0CTzb77P9kHrPELie3yRtx/qrS7oeDuh7I8hF/gtyQOrLqOuQXRpT9ggBTwqDalWg8hBIS3oY1VHFxCYI6ksOkap70gzGS5TzQzakWMycy9rdiw299ggi98QOHPeRccQOJ+A5njToZNNfthEZqGh2rkcPFZdq1SVqzY+9pwdgti2QiQLNBSFaDUnorn1hLUKHNObdUErA8BQQveti22bHrNiL7Gbv46X14JEmNMGsDvenG338lSkPxlOXNh2X8gcQawASgOqKt08QI6Zs8Pr2jykUQLt8c971xelhLzepTlDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvHeERn0eXqOMzXM7akpVNlcZYNngzJx4qJAga6mxKA=;
 b=q1I9D04+MmBFE4nrjly0yOKJrlpWFF/xAwzktGJmCNqtRB36/O7WZgd+HByXbv6lQwY79wG2iMIsydz9yWsXfJPTakOswTkePpEUI5+jjWgAG3jSQd/OJbO2FQ1vbW9HYQnRfCsXQ3qbcnJs4UPlquHgOJZXIuqiIM6o+4z/Af0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5247.eurprd05.prod.outlook.com (2603:10a6:803:ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 22:55:12 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Wed, 29 Apr 2020
 22:55:12 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 1/8] net/mlx5: E-switch, Fix error unwinding flow for steering init failure
Date:   Wed, 29 Apr 2020 15:54:42 -0700
Message-Id: <20200429225449.60664-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200429225449.60664-1-saeedm@mellanox.com>
References: <20200429225449.60664-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0022.namprd04.prod.outlook.com (2603:10b6:a03:1d0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Wed, 29 Apr 2020 22:55:11 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d766c940-b92d-4193-a0cd-08d7ec905ff6
X-MS-TrafficTypeDiagnostic: VI1PR05MB5247:|VI1PR05MB5247:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5247CD51B9FCDB6E879D1F3DBEAD0@VI1PR05MB5247.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:304;
X-Forefront-PRVS: 03883BD916
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(54906003)(478600001)(6512007)(2906002)(66556008)(6916009)(66476007)(316002)(107886003)(6486002)(52116002)(6506007)(66946007)(6666004)(2616005)(186003)(8676002)(16526019)(26005)(86362001)(8936002)(36756003)(1076003)(5660300002)(4326008)(956004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: owkiFY35RLEuj+QrTOXuk9mpb4g0l/ATgWJgQs1kLEo+t9cQgulJWlbwdecuJdji5sFWWQ8sGCuR9Dq20bU9xHeFQxTBNV4ob5OL9ns/NVktZQbaplyijkxGQPv5wNtcEdeM9JFNRa2dliy82Oex4DZ0I4+xyyV8Js+UR3zWR616cy1x++KtocEYjRn9dDGMaqGmIlB/5fydP2wOM3tHauiZX7O5SIzsM3wTAlVJ8IjBq96UHayMFFljH9gapsDdm7XFq2WK0mEivfybwvwIjrfgd48KnkvlLDbtE4SuitbyXzgnG2plBInpAiFFQau1QSGgjqX793lZC69pMS62CTS4ULZ0k5yqkgLX3u1mONCylDARe62RAo3rBdhetsjVd1o83yCDNaClTNFTyk2GFS2vZjQWVEkBp+AD57umCBS6gGMAY1HwBwJM67OXbj3BreOYH3EfLbJ1f6eccXxMNmDOvCLP/W0V9d1skIQ5XYbyEhDG/FvrXMR6VUXINGbe
X-MS-Exchange-AntiSpam-MessageData: G4KfxygI/3A2+l6+G4/O+ar+kLOK/MiXLlhX0pQppbNmAR+NIB8sSCooUf27OoTwcjWU6/XC0jh1/WAbEpccicEu1+VRKyf0bEcEQr/3BGntFSa60prQFW8cjRWtKYiUcui/GUNQBnbsoVaNVPPBdkBRHINgcH79NiAWXF1/LWqcXZgPKoimqcjBx+jCwYJZCF7VRhl+WfL6e0pAf7KKRuSUIvHr5/fZ4M1xBU0sN5zMRXqZ2En8IvA2skHCFStvvz9/yiM+LBq/dimCj8mP3HqSC349grEHB4q9ELoHZ0QnqiAEkxTmb8378pl9nEVxKdrBQtEzZgym9d6Ay9w/1h9LTgtWw+qWYjtrwGJAAVuqGApXx1jDnkDABxG6xybRXN1GU1Rze7dFS77/yPHvXsY6FhDYMa7Nun0ESZw6wCjGXdv/YGXvcsGrPLVvE0GXaYE/m8RO6iDJfOTBKfEm6gQtMVS1dLFDie5ix7gwhRDgIWjdW2dUP5311oykqaXVy/EcxPT8GFAqiXFhtZUGgBFnv3PUwNzW89IfuwAVTxeUUVG4523X8m5EHenEneyyeSVnHakhQ/CCR9/sHcnFvtV60Hhn9DYudtT2NKC+Pw2cy3O743T6Bk6BKI2nfe7Q5IM+cd18IkObrki++NRNjXIJIKvzta3ffrF4VdKNfoJWLcw0VNIUW0WsmLvVz64Enz1SrKZAEK52Df7c0cCuGNJgjQY2pyndQUI4QYuryog0gXqDKLOkBS2KSwF18D/6x7m3Rz4s8bmLf/n+yvwYeJIPmgNADFrZq9gkdlDmXOQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d766c940-b92d-4193-a0cd-08d7ec905ff6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2020 22:55:12.7987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yPfSIj+4UDUMxkQdh+QCV09Z6Fkz719Zc5eJohl668cTqp7wUvBxS/FSUHflqwfw9bcdjmx7vG1At64YGlVBhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5247
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Error unwinding is done incorrectly in the cited commit.
When steering init fails, there is no need to perform steering cleanup.
When vport error exists, error cleanup should be mirror of the setup
routine, i.e. to perform steering cleanup before metadata cleanup.

This avoids the call trace in accessing uninitialized objects which are
skipped during steering_init() due to failure in steering_init().

Call trace:
mlx5_cmd_modify_header_alloc:805:(pid 21128): too many modify header
actions 1, max supported 0
E-Switch: Failed to create restore mod header

BUG: kernel NULL pointer dereference, address: 00000000000000d0
[  677.263079]  mlx5_destroy_flow_group+0x13/0x80 [mlx5_core]
[  677.268921]  esw_offloads_steering_cleanup+0x51/0xf0 [mlx5_core]
[  677.275281]  esw_offloads_enable+0x1a5/0x800 [mlx5_core]
[  677.280949]  mlx5_eswitch_enable_locked+0x155/0x860 [mlx5_core]
[  677.287227]  mlx5_devlink_eswitch_mode_set+0x1af/0x320
[  677.293741]  devlink_nl_cmd_eswitch_set_doit+0x41/0xb0
[  677.299217]  genl_rcv_msg+0x1eb/0x430

Fixes: 7983a675ba65 ("net/mlx5: E-Switch, Enable chains only if regs loopback is enabled")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index b2e38e0cde97..94d6c91a8612 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2377,9 +2377,9 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 err_vports:
 	esw_offloads_unload_rep(esw, MLX5_VPORT_UPLINK);
 err_uplink:
-	esw_set_passing_vport_metadata(esw, false);
-err_steering_init:
 	esw_offloads_steering_cleanup(esw);
+err_steering_init:
+	esw_set_passing_vport_metadata(esw, false);
 err_vport_metadata:
 	mlx5_rdma_disable_roce(esw->dev);
 	mutex_destroy(&esw->offloads.termtbl_mutex);
-- 
2.25.4

