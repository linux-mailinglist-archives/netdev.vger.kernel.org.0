Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1761B1855
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgDTVXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:23:20 -0400
Received: from mail-vi1eur05on2042.outbound.protection.outlook.com ([40.107.21.42]:29847
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726457AbgDTVXU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 17:23:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ncrJUEmipH0/Fntr21cdsD71wJGpTfrMzkwEqiDNiM7u8brW15z1DLiNtEITBcKrtBCjSF2Mml0hXh7gQOkg9XQwlx7UeeDhDwt5GYktzf6hcorJYKaqLptvKjJkVmqfeOFPBgQ2W+JQz9vlCJZ5D+WqUiDI40xHtVD0sRf6gGv0UOYO1wgooFZZ0imVcc3xRlgH2VbOCE5sFI8BkcH9bsRG8LqO7peRwoct8M7QkglMIwlRTbmRzg7zpQPs++CJT6YYZBsieF/Bi/LPTgI/xg0oLKuyxYz27Pot+QppSojO/mMKPxjbvT4VBXwWsVIMrq5hjOfhctKmnq31dn/jDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HyGwYGwCRTjPtIEQ82Spsc3NYfL+kmVx6TcNy/V2L7M=;
 b=N9bfSJfKOQ8Oj9hlutl27WLRr5LlRxbjawjOVzSQfNYTsNv2hTd5jPPwSCQUfUag1ZVEk1VU47mm3hErh5GgJIYeUDObQT5hzdWzFIhbvzJf/WRcmQIgVRDEAVjvzALO5bf6dN8CjIFuQ6SzQEMnyWPLJ0bH264uPq0kyhlO305IhMNxZ0HrO/XavA1c55kwb5vdQsRVmS6g8QXTf8GkOeRIBqIG+xgbye9LZl/3YWR65l0TcMctLPFLSbeJhZfs/3nJ5Qm1LQ+DfoS1EsXuDgLXyXq62ZFib7qX42gjdhdCmFfFtkv2qWw79o04/03u00Addt0kQbJuYiWNbioNbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HyGwYGwCRTjPtIEQ82Spsc3NYfL+kmVx6TcNy/V2L7M=;
 b=SzvdWS6eYRcEuN4g2jZScEnnlPDd9E9sZ1lx8aw3zTuGbeiFxxsI00Qzby3rP95guLobvvlUXdJx5Q9cJ5eXJ5ztacMhX9YKFC4wtrXiNN3VJZ3daLB3rcKN0V7SA94+xeOoLJU2RzptueiiTuxF3g4fOdy/8enDXr0SeOtiM10=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6382.eurprd05.prod.outlook.com (2603:10a6:803:ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.28; Mon, 20 Apr
 2020 21:23:17 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 21:23:17 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Bodong Wang <bodong@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/10] net/mlx5: Read embedded cpu bit only once
Date:   Mon, 20 Apr 2020 14:22:22 -0700
Message-Id: <20200420212223.41574-10-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420212223.41574-1-saeedm@mellanox.com>
References: <20200420212223.41574-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:a03:40::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR04CA0032.namprd04.prod.outlook.com (2603:10b6:a03:40::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27 via Frontend Transport; Mon, 20 Apr 2020 21:23:15 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 93969138-ae47-47df-e595-08d7e5710ada
X-MS-TrafficTypeDiagnostic: VI1PR05MB6382:|VI1PR05MB6382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6382EF62903BD7DA4FBB3445BED40@VI1PR05MB6382.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:343;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(396003)(376002)(136003)(39860400002)(366004)(6486002)(54906003)(956004)(186003)(8936002)(16526019)(52116002)(26005)(6512007)(2616005)(81156014)(6506007)(8676002)(478600001)(1076003)(2906002)(36756003)(316002)(4326008)(66476007)(66946007)(66556008)(107886003)(6666004)(86362001)(5660300002)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wBSrTq64AoPfgFdPqQyVcHUjUfxmpvEE9o61D6JsYVHvmagHntNew4ALXrWMqMOxeAgqlrcZc33efhexKsli6BjX4IQtxe3G1JWLf3B/D6vyjohOWb69fKyZolyyasu0/5/I0qoo5dN9dPi4fs3gxZbR4DvSHEqO0wjdlF6SNEtnB1kiKEzIgveiaCEc0Y4KP+EF3J+kcvEFff2EqlwAKmsLCAgn/sY3+5HDPJ67ftOM44UHoYU6fc7g884HrJAcakFUmBIIyQu1iibDaCeEJs6dUyLyK4paZNEOnE4l05jDnPY7oZPFRLnAVRFzlXi34kHRN06mmSSg/Ry05XpHH7aVZ4/erxe0rncTzHLfyEVrRnIFNwYga87uIRr6TzZcUV0fYVpuWos4wnpmBExWnV+NXHG3eFyUWDNlkE4Dfl3P3nSFQL8GiYqNd0l/Ib9R+Pu19KBIWicxLkz/DnplrgEUm6MiFQyjcJJOJ11K2UtWyjmH3MVs1BhjAo/1QsZR
X-MS-Exchange-AntiSpam-MessageData: TX3E/txXUXoP8N64JJEM3PCfGPAM/3Jgnxwmgq5PwvUu0Z9/PF8wlBGp59c/g1/glXdmwScJdLV1evncpsq0cUQY4YLpb6D8Jyz+3AVjG9A7+eEzIWSL7HJQl4UcL3ta5Zg6UymrFz52XKiUfQmocQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93969138-ae47-47df-e595-08d7e5710ada
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 21:23:17.6784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CXK1vWdFgi6C9jpB4i8tKfH6LKxWQ9+grQPfoI4me29CA1SWILoWMzouwPrK+NKzGGZ07LEDwQPTAAiyf3ykgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6382
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Embedded CPU bit doesn't change with PCI resume/suspend.
Hence read it only once while probing the PCI device.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Bodong Wang <bodong@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 7af4210c1b96..5a97e98e937c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -782,7 +782,7 @@ static int mlx5_pci_init(struct mlx5_core_dev *dev, struct pci_dev *pdev,
 	}
 
 	mlx5_pci_vsc_init(dev);
-
+	dev->caps.embedded_cpu = mlx5_read_embedded_cpu(dev);
 	return 0;
 
 err_clr_master:
@@ -1180,7 +1180,6 @@ int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 {
 	int err = 0;
 
-	dev->caps.embedded_cpu = mlx5_read_embedded_cpu(dev);
 	mutex_lock(&dev->intf_state_mutex);
 	if (test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
 		mlx5_core_warn(dev, "interface is up, NOP\n");
-- 
2.25.3

