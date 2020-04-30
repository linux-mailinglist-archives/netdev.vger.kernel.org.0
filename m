Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1321C026B
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgD3Q0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:26:23 -0400
Received: from mail-eopbgr60079.outbound.protection.outlook.com ([40.107.6.79]:10070
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726515AbgD3Q0W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:26:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UkYg+HzTz2ohxMVzN7IOJxlkwfnN2rh5V6hnZM0j0L7HFP4ONCgvnC9ESSBuD2uF7jBpBFlfUwLf/vGvn7AXGT9MCtxxXiHF5abQFrpAy5wMwK/jN+9IG9wMaUZczZN0w5Yr9iWTJvWPMLu0cJwqWBeaNA0+gAcVRbe7WbhsEqKzk3GuPibX0moTohMHF0DsdGFDAKfU/t7aFYIDOb6N6FcTRfoFr7Hdnem768iOJe2tIkifQzr2UIeOt8gpXk2viFX5fph50h6X00wF9nAhq+RQtsTyd1R5CBB/pGP9Ohv3FgszUQY4+yrhT+2Xue329sNP/QUIJH1e2m8n/XtcGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvHeERn0eXqOMzXM7akpVNlcZYNngzJx4qJAga6mxKA=;
 b=M6f+QNy5BjYY0l76EHU9oNUM19Rej6/DJ4BlL/Ads7B7rfzCgma1APSZM3uiMB2xcDSZb4m7I5huMdK39rZi8GGvCVoQI0ASp9//s6V6PckqS47ElEFuFtDobbJyIpvRhYht8VnguY1nFIA6SEVJeoSBX+2m8ubei572S8077SZWveVlu4f84zWJkOfe6Vae8uwLYo0BLT5eH6gci1EmoH12wzniCoxRURV9QJ+go9PGAc0+Elw8fJZNpnceranfKXBmuEih/ZaT7ht1XmpLSKaBYE/IiLFJqMt4vyO2DHaa0YJ8IXbc6bpSG6AKt/CMu8RENvVTTCQGApbuRcfsPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvHeERn0eXqOMzXM7akpVNlcZYNngzJx4qJAga6mxKA=;
 b=F2scbxDdS6DNd9B8o2A355fJvE6F5dedegioLKIs/QsO1Zkxam2g7tyB0ypqxF706F4yO+2Q0Uv/F1xqyDiFoxfv5S/cRW/tD2qBa9XJfdA7LWq2FMSWKlQZRc9tXdemY8BTiFFXGSFUSNMSSwiDy1TlT6lOt5hRA1q/NuC877w=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5376.eurprd05.prod.outlook.com (2603:10a6:803:a4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Thu, 30 Apr
 2020 16:26:18 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 16:26:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 1/7] net/mlx5: E-switch, Fix error unwinding flow for steering init failure
Date:   Thu, 30 Apr 2020 09:25:45 -0700
Message-Id: <20200430162551.14997-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430162551.14997-1-saeedm@mellanox.com>
References: <20200430162551.14997-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0070.namprd02.prod.outlook.com
 (2603:10b6:a03:54::47) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0070.namprd02.prod.outlook.com (2603:10b6:a03:54::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Thu, 30 Apr 2020 16:26:16 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0d05b1dc-0f01-4f19-5c3c-08d7ed2335b6
X-MS-TrafficTypeDiagnostic: VI1PR05MB5376:|VI1PR05MB5376:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB537698C6C0F2DA6E2538AC14BEAA0@VI1PR05MB5376.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:304;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xq4Nh7hQVHCaA0/vjX8ytJ7M1l80jbx0u+Fofj0TcLvdkeDTduUZTh3fu7dQwoGTCitDPUckTU2h9PJalc8hxXRlmuGmeBXFbi1BVQJF85Z4nl07hsHZdxwWtoBU5TWt4gHoVOIA3KJSI9liB/eYfqgV4ws4YH66NWU5uoGWKRxz6h6ZNhqXm2cH0HsCnqA1OQyccZ8eqK0n/FrYOBfeQyjuU57P8ASQ53RjgJW4Y0cR++TpP9PUjSFXydqfXjAiR8HBCjgi3hLnfYiUfhLy30/t1Ya48G38yug9/KdO0JbnAaxtGWZbbXU8akf80fKhYPPB/yvU/YbleQ3g6L6GhPcWUyaEkYMOagGElXh/+v46PPOswmUISRh6kWVN3RAD0T2TJc8WQ/ABLO9j0mpzr4lr2AdD3UQi95xBsgh8wpSjceeUWoSocm6G5pqCRxS2MF+k6bNHeuTdJeXxw+4FJlAS1TVtok7n0K/zjY+ynlJRWJLVVg1Us6sSFzOVyYSI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(8936002)(6916009)(107886003)(36756003)(4326008)(66476007)(6486002)(54906003)(8676002)(66556008)(66946007)(2906002)(26005)(6512007)(1076003)(316002)(956004)(6506007)(86362001)(6666004)(52116002)(2616005)(5660300002)(186003)(16526019)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: YXRGlvPz/XXrACLVAxbTnH9HYoMZ3+MeJeAIu5yFzh7n+59OXoQYqwo1s53rHkNABgOUNGRIHZFTqi/m6KbnCacau5uY3yn6dukfZFw1MHtoNlXpBYggHPgsVCnNcakTrYxeIYqsBKmAdEVuecECUxMEGgsPoXjajns/KkPVh5T26otLVN44H10Sul7nyIjbZOhptwOH+eZLeexri3cT9tdBMQHdNpiocgGiefJsb0aoC/iWTI39z45DRlqv1CuejHRQhaOZ8WO4hqNIPz/VJd+hI/Ov34OD6WOQUCdACr9+453szWuZImc1ZoDCAyJfyiSDZMcWCVucYtz+2p6xV1IbrYILbzZTKcjNZAPE+leN+IsEB7F16h9DIG6HGM7w0aWtgiJPadr16p+TksGJjYXZz1rTW4gtqUeX4bn5mBmOYa80r1CXkcFoZpDexpCzuSSj28mXI9d+8DbTUQx4r2+gjrHmTM67WqaerydjjbpVcrATZ3gnogIbgpX4iMDI70ad9CEbgEn2xExjtijaHwgf+ooz58YuTT8Rva6oB/RvhSeROdyv5I4dTahFqKE7F8bPR9pZHiosKPKb8IRM6bB1epLOj+fWtjhNp1lV0kPGlTv48mF9dssVyaYpujH9KeHPdUVv0nsM3/qlcjkJTPnpL5T8/D241ttS0+ufSHAgfOqTiF6E8wTo7mT+AseqSYdjK9aQkwLtNBL67q+yatXOthzRA8c7+FE3pknaw5Loh25KZoX0ndJAYnARMWuYyEz4vxBnbafcMgVSnK1Tl1orgo+45mzufm95PBvtfkA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d05b1dc-0f01-4f19-5c3c-08d7ed2335b6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 16:26:17.8935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fui/o/6KWNvdIqEjz8UjedWzSHZtVonlcXiYl2e2AMjpyVm8KrSEZUufLDP/OSQMSuRT22Ry1CMaDAUb0/QhCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5376
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

