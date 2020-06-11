Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281851F7092
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgFKWrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:47:51 -0400
Received: from mail-vi1eur05on2064.outbound.protection.outlook.com ([40.107.21.64]:6125
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726277AbgFKWrt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 18:47:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YqMLMALgVXtJSD6k3s69N/i+MFphRLVC/nP4l990LeJDXujzIQ6hQEsh5wGdNb/lr/lvYlQV9wYZ4kG3VEFQJP9AreHCynD5j94/xs5HRd0sRT8rlAJ/tAvdLFozHUhThVapn6FLywmodNN3k6QjE+7TKayOzxdQGfQzaXpg0Cz0PEsXqTI+d1RvH9wfEBjK0arWM7Qa1J3FZpZj8vxCohHVYklsG9hDpBn4b7Md+DS6ox7fOksdcE8jZH0uq69gWg0RMk4taVPpJD/9EQn6FkUfpWC0Ysvihm6ANAjGZIjA1Rc0PlplHvFVZ+RpOtTnmA/q760F0g0mQlmkFn9XXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kxghqcy2viv3QgrcMeqn8RFqL5l26UySWUpfn20RJFs=;
 b=D0GxBXktBOqTkRhdL8gCgI10AXCQoYIPH3nmA3NxEwu0gHcWCQHm1SU3MpjRmrrjeXYOlAvfbXousfI0eph8Ws4si8NvMV2WSb7xiJrJQ76R/9XNsermD3fwGVRyY7/QqYsfhKgIrepGnfPmgzKzjXrvHyT+mS8jMDI9Qt+NQiIn0hkZym8tyIwSxR4HuyqrcQU5vDtm7u22QKCEu6mk08qrMYzbrBrMRK87kEZSDZG056WRtINEfGHvroTH3xRng9YGrXsCkxlJCnSIQFcOUWFevZi3uvqLu9TdgMtn9hCykWs6P9ZUPJ8tDaG15LTdBdmDNoGUda6gaeuaL+F31g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kxghqcy2viv3QgrcMeqn8RFqL5l26UySWUpfn20RJFs=;
 b=aRI0EuC3fMAlXb4diACxpIw74J2Fuzm5arka3FjHaBA9o/+7Fltpf03uvY3eCiq2GdJyzH382KV4KclldhzJyzJj8Jv2lSAoNWmDweghYiyoNQF0n+Bc+/vlOoV7bYOzZFHMRn6HXz93Km5hPpCMjXqtzAJYRB7j+zUMhStWgDs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4464.eurprd05.prod.outlook.com (2603:10a6:803:44::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.22; Thu, 11 Jun
 2020 22:47:44 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3088.021; Thu, 11 Jun 2020
 22:47:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Denis Efremov <efremov@linux.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 03/10] net/mlx5: DR, Fix freeing in dr_create_rc_qp()
Date:   Thu, 11 Jun 2020 15:47:01 -0700
Message-Id: <20200611224708.235014-4-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611224708.235014-1-saeedm@mellanox.com>
References: <20200611224708.235014-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0066.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::43) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0066.namprd06.prod.outlook.com (2603:10b6:a03:14b::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.20 via Frontend Transport; Thu, 11 Jun 2020 22:47:42 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 07a685a8-e14e-49cc-28c4-08d80e597412
X-MS-TrafficTypeDiagnostic: VI1PR05MB4464:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB44645502BCF03281997BB9F7BE800@VI1PR05MB4464.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-Forefront-PRVS: 0431F981D8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kaCLvYCRCSohr+nRqh2Z+f5KMEkGtQiDZ7b+2v7l2p6qpA8wNv/qrjGKD1H173PYtu5zNsM7rXeGobmlO8BukGDimcgFLbtLmmyiRh1JfmT6D3piQ2EPPe9fVJJ+u2uweBHXNZE2bCBHHwD2ZaImUg7bVwrWnli7opV5lJTnkQYck0d4EytZ7QvTksQtg9pQlwFSztsLAvckfLUY667PkUioy8IkGOnkRypS60EsUjQeBCwMl+5S2HWOFbPfRrfEanOLwzzeDfsBQXgPm5dwxf5GWZYDexnjvU6fFQVKhtjjdHgZKHvzroo9W6pRyDR0EKj36BK5BisToYKFTbDNC/EuDxziB6crkclqut8zMojEWeImUBzS1o/ogCDG2dHq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(8936002)(16526019)(186003)(4326008)(316002)(8676002)(107886003)(5660300002)(478600001)(26005)(956004)(2616005)(6666004)(66556008)(86362001)(6512007)(6486002)(66946007)(54906003)(1076003)(6506007)(36756003)(66476007)(83380400001)(2906002)(52116002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Br9LneT3KXTNTaiw3+EFsScXy+bUbb/sg6QtssnhlhyklJ/7VN6hnN/kGTWBIvVswbDzJDxwM+BzTxEfn+d6AJgv2BHFKhBp2BeYmZiSBDLXurS9C9poKnM0aKnWKUOM8NHn94tNj1Rfdw8usS8ACj6oKnqyG28eciyDA12p9gdVHZUSRQ4weNZon82n3YyspTOxXPooTyX9TWxSGBhIHPX+OZseAcwG9dbVK4dVL9XoaUJrTj4H91aNnYwVJjjA/IOnwjHG9ahtQopBHpV5FYTu2c1IPbCxDh39pTTAiC2jcS1lQOOf6I7o80nW83TFbUEhYt3e6PWXlXxcRTZ2vbpMI6Jdtm8cvLGoP06wpBJFZFKUEfzdcj7nrt+zgmSWpWDK5dOR9fjH8O9tcmF5sj5m9ovGwi9dEDvGoBX9vC4BNP7W6AzOQsw7xoiB6wSLynOPUWN1AdVIBKYmcwCmEptiVGT4ArlUIiX8vvIW/DA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07a685a8-e14e-49cc-28c4-08d80e597412
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2020 22:47:44.2906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0n2pVdas0mT2qyX/H6V8HzzQn+iEWuk/2/uNRjfUFA18xvvdx46Jpx/mWzNECByjvoJDm/ngMH9ld7kQgD7KEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4464
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

Variable "in" in dr_create_rc_qp() is allocated with kvzalloc() and
should be freed with kvfree().

Fixes: 297cccebdc5a ("net/mlx5: DR, Expose an internal API to issue RDMA operations")
Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index f421013b0b542..2ca79b9bde1f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -179,7 +179,7 @@ static struct mlx5dr_qp *dr_create_rc_qp(struct mlx5_core_dev *mdev,
 	MLX5_SET(create_qp_in, in, opcode, MLX5_CMD_OP_CREATE_QP);
 	err = mlx5_cmd_exec(mdev, in, inlen, out, sizeof(out));
 	dr_qp->qpn = MLX5_GET(create_qp_out, out, qpn);
-	kfree(in);
+	kvfree(in);
 	if (err)
 		goto err_in;
 	dr_qp->uar = attr->uar;
-- 
2.26.2

