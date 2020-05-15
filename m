Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394601D5C85
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 00:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgEOWtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 18:49:32 -0400
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:33656
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726183AbgEOWtb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 18:49:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OjQt5NyNGuihcw7zfYLbaz5NGct2IEPFYowecvi7vREyZZufZvi60Ac7cXed01xdGHYYR3C8Ju0KQKPOwLya35nJHJAvIWBGtmjqwExZj7qoxzmE0tTPzqxDbikVngwnELI5Fs3ljaYx8MgAILemL0tLXW5+OwDy0+msyy4IbYsQfgoQHqd6DgA6qzpFrEhsUI+2fhbaFR+OY28UoMjuGVPiOfMlrvQF35bfYDgH0ZRRwiJeoF7lr/dW5Ma1VGonDKQycZLqGeuadxqp0c+c26zpRLO2ohalvkp/XbNvEJ4kp4txfoEd2NxiixvF7EqbnnUcRrezVbG73ZhUDXHecg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WdMHpNN0l7QCeLQsPQpmnLVGqORUyKw6tlEnymXSuDk=;
 b=Yu6Xz7/8SZBaGOsZ6ZzMY0gIkgezUjq1eFac+i6HjffXU37pf+LAXd/SXBaUsygROKOyCYWurYmkpakAkRJejJdXoaM/FJ8He4prAnCGitgw0pFhvpi8iuhKqO+vS5bX1nQ/OTgwF7OxhFlfSDcqtwyAJ97eTQeeaMaXTM9HDg3vYDzqerearSNiZvGzxUWfSgmVRs46jcDe8hXSvU76H6RbDKleGRnkVj6coTSxCneeLBmdd+nFRVFSkG+5S3DE4gYD+7EK+ZCCUeMtKszfTlH5D147+Y/xbItkCWFNUhcWPVp6GZwjKX6B0AoLyZo+DpDAv8PgOMPiBJHOXh5ixg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WdMHpNN0l7QCeLQsPQpmnLVGqORUyKw6tlEnymXSuDk=;
 b=GW/pK85L4XbTSaZw6Douh+W0WrODNX/VuApRS1i/0m+r8gGsoAOMd3vM573bZo7xLWaEoa09LD7UQEQ97imJpU4atDnA4H6aJYWYiHxW0zTsTm1At5igE/B/h4IzpBTlBz0abUi2NOa5w79XxzsYjzQHmjYNPk1xCfu1KGA3V1A=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3200.eurprd05.prod.outlook.com (2603:10a6:802:1b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24; Fri, 15 May
 2020 22:49:25 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 22:49:25 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/11] net/mlx5: Drain wq first during PCI device removal
Date:   Fri, 15 May 2020 15:48:47 -0700
Message-Id: <20200515224854.20390-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200515224854.20390-1-saeedm@mellanox.com>
References: <20200515224854.20390-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0053.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0053.namprd06.prod.outlook.com (2603:10b6:a03:14b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Fri, 15 May 2020 22:49:23 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 48c82b68-701d-46a5-94da-08d7f9223797
X-MS-TrafficTypeDiagnostic: VI1PR05MB3200:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB320074692456248A08649E68BEBD0@VI1PR05MB3200.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:369;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eutCK+zdb2HrCjFXoo9pLLBCFIviruX/d+lY/epdPaVX9gYtib0MK2Q/IiUtW7v+quN5jKiA+3WQj/VLFfScnYrMiNJK2ZSeXgSyvjMf/pbJCSG5a0JSog6/k+fu9/u+u2wiZ1DqClNod4l0iFlw0HLteEYKPMbj60dUlhzPqJ7kjOCC1U4d83cBtpaLJTI5jkh35Hj1+zC6dSof3b/Qi9erdO0YeRJS4sNSGbIF6Q24fVqbs/2U0Eblhpc3H5T7LHe0Q/Tzp+0fFHNgF3SyfvKi8TlGR3RoGDiGQPC4OWadw+R64MwWLYeablO9sH/KqbjG5Np7x/E/NF+YRf1GBdaXsfS42QxUJc8qPpm+m/LzV6U8REpl+vku3W/qhXxzHs+QnoEsrQEiP2Ag7W/yDBaDWPhuM1Flp6TO1EBKdt1UoFhKlJVnaGQKAYwMMR90tvxV7JUiLxa9L0EvH00UbBSORnW7XRzMHE8/7kFNPOwIhFVbaTs4wihdTqswnPcy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(39860400002)(346002)(396003)(136003)(16526019)(26005)(107886003)(4326008)(6512007)(6486002)(6666004)(478600001)(66476007)(2616005)(66946007)(66556008)(54906003)(956004)(52116002)(316002)(6506007)(186003)(1076003)(86362001)(5660300002)(8936002)(8676002)(2906002)(36756003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZcuQpHc5CQYmGw8YoVH9X5CBQHPg795OJm87bDGj4sX44YPauTxa5sunvTmww/k6r+pIcmsCBZHHalDr7H2tBCHVL5Zi6Fp47gRDsmkIqRVWhAyf4rNLgiTPb+nlYow11Po6mL6PtyJXT2lp4uWnSnUq85euQ2yC4UOSLWjn+jjQfZ3PtDPhcxHnDe3r2Cq9C3kA1yLn2UoE1eDevbq5UwdZXvW7CEy3zOF+S+I2lzEVvAQbylvT55HqynJYpw8GWIxmajFncRFyGmqodQwEAhgYiP5wMN7gd+DIotX4JInf8VPbrJslApu2ELd5fGZvBhLSoJkxVHEfEC8g2wudok/ZbPY5X7SzKkS9/ovfJisqC83IP/LShqS6wYUczQo5VIcWnWD4QkeyGttO+aSgPsrl8sPT6r5AdG3MOejRCZ7S9vWNcGxL3WseMiUJgP3k69wJy51BoH2DibU76s4vBBxmG47nOVmeSUU98mEZldo=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48c82b68-701d-46a5-94da-08d7f9223797
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 22:49:25.6717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CxUkEXJW+tFMxADTZz29O+TuEKVAI4QINP3jzOCWDxqRCwzZuQQA6vwrE3NBsv3Rpr3dINeJrf01t3XLtzRuLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

mlx5_unload_one() is done with cleanup = true only once.

So instead of doing health wq drain inside the if(), directly do
during PCI device removal.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 2e128068a48c..d6a8128f667a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1236,10 +1236,8 @@ int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 
 void mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup)
 {
-	if (cleanup) {
+	if (cleanup)
 		mlx5_unregister_device(dev);
-		mlx5_drain_health_wq(dev);
-	}
 
 	mutex_lock(&dev->intf_state_mutex);
 	if (!test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
@@ -1382,6 +1380,7 @@ static void remove_one(struct pci_dev *pdev)
 	mlx5_crdump_disable(dev);
 	mlx5_devlink_unregister(devlink);
 
+	mlx5_drain_health_wq(dev);
 	mlx5_unload_one(dev, true);
 	mlx5_pci_close(dev);
 	mlx5_mdev_uninit(dev);
-- 
2.25.4

