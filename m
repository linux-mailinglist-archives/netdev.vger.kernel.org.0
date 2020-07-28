Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915B5230631
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbgG1JLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:11:10 -0400
Received: from mail-eopbgr10065.outbound.protection.outlook.com ([40.107.1.65]:60054
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727970AbgG1JLJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:11:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nX0n6nMVfC1rpBciB/8DQgxbFXHM+WOngcrs7ySfXgM74b69m7D0Mb+5TFoqeRc8zPKjxq7EKcjypy31u52q1OeK9HEM1L6q0rmTee+JLfKGrymV01FVjLiN9QpRGpPuTPgi/eC7/YMUniPCMr3ipdjnriPbuiT+Z6jSVDBTbljJ2vN64at8UbKrvL+MYQj8qMSGAfk/Wx4btav/LMr6aUxOI5xr8tVB8YhC9YK1tb6B8zQ558ilmi+wz1Fd2EZlYBksJEApfTYy24+eSkgPxKqX7iHVMIwi4BkrRdYNJghI12zyn86MxyrhFHZo/YqllklnTGtpVjVjbDVil57z8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7/1yDK+ivw9ePtT0Eql+6kkxMnJzsGiQRVpRr7tOCM=;
 b=lH9GA/UJO0k1P+v7PXP7nG3yKKwVgGjcczaHoCP/zH2/dBKh1KVw0I/MnnvhAvdblGdOce6xZeWTuWgpOrSfHyytM+oAIVon9hd8hNRKSnux/Lyvad26YMA5OeaPYGba/sAAcsc2gteyCYQGcV4BI0IEMb2qMRr/m4yNG6/memMaBNmr9xLLuqPgdKBLX8nLnYY5frjkMqt84RdEyPTHID22kGJLRLx7mmIsLbU+Po9XwMZux1idneGsDhw/QHIOHXH12JdsvQnSZK4RiTaHFpGmNJoxJPmGrmJB4WinXpiyscnoE0eqi6+5COhufIyzgvOtXJBAAeClEQ9xvO/oRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7/1yDK+ivw9ePtT0Eql+6kkxMnJzsGiQRVpRr7tOCM=;
 b=MvKjP6XLFOGrTkiqUKXnuJ/KXHeh5RApygatAV2CaM/z31AEqsKFJBnmiIlBgwyRxW1JJeRX6qk+GDdgoVl4Uo7zKQmsg4Df9rHwkg6gazY7Kiogdy5dEoRHD6awAWGjEYNunyMtWBMejHpGUfAk3fyJcd4h1Bpn4IiLD7keyc4=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4879.eurprd05.prod.outlook.com (2603:10a6:803:5c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Tue, 28 Jul
 2020 09:11:03 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:11:03 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 02/12] net/mlx5: E-switch, Destroy TSAR when fail to enable the mode
Date:   Tue, 28 Jul 2020 02:10:25 -0700
Message-Id: <20200728091035.112067-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728091035.112067-1-saeedm@mellanox.com>
References: <20200728091035.112067-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:a03:254::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR05CA0022.namprd05.prod.outlook.com (2603:10b6:a03:254::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9 via Frontend Transport; Tue, 28 Jul 2020 09:11:00 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9b78e00f-3a3f-4041-f2d3-08d832d626b6
X-MS-TrafficTypeDiagnostic: VI1PR05MB4879:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB48790095EC186565C9858E36BE730@VI1PR05MB4879.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:576;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8nS+jhAcLLHe2Zd8urOa5xVfL9ULIOjyCw32tKH+EO54cyYt312B6koK0tEzBsPNiEDIw6bwN2YgG7gWPeRgGCrsULfx3XPzP5HfsTzKZ/2vsr0sSLliB6FbpVMurRGc3lK+wpTtivVZqWBpBbSMNOo4+tr/QIcH+9kO5M55g98lmNV5J3lJdFM1D2WECJu5cxlaQYLkT/4pUphfK0BAZQ/urgjhbweo8gyW3RJzs3wws39yXCYBJQDjOfvk3wG/UR1kPbUY+DBK78/Lkwic94T3m65YnatEi4VbtxqRen0GEH2+Ta8/Kv5ydKN9LPb5J+fa+0IxGVtTCCNwN7j9oMt0y3BIri5zK0QhinIYedXb6eM5bBGtDNt9x/t4mcH0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(6512007)(1076003)(8676002)(86362001)(8936002)(2906002)(66946007)(66556008)(66476007)(107886003)(16526019)(2616005)(26005)(83380400001)(186003)(36756003)(6666004)(478600001)(956004)(52116002)(6506007)(54906003)(316002)(5660300002)(4326008)(110136005)(6486002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2fPJocj2idmpdSE6a6edZQqy1bVxIAkB6bgI8V4z7f/Eu9H7HspWqqn57+vvaKS2DbHIQklmoPX+JU0FYs23eVcUpR/6nK9MLboOu7EbZFgeW8eRRELBaCWQiZgRKHSYn/cgUu5TeqxBUpHDl7PSeEAtIcA0arZgQkGgTCdlH2lzO/GSk1vATZHpyAqSUD0rG+fgmx9F5aPjUJdPMcZe+Wnx9QKYhhPWtkaUF9VZd7crJNIFvHHM9Hnfs0PzXzsPDNV91oxKhc2pykJdN8ptIC5kB+bO3a1fqCpZl/0xhRFOZfXxd7F1/vmBySZNZwqOJJNZr+vGQjvsW1+mOSfSTuZ33YIeG2bu11GsRrqE3eEPai8KoXoCwzDYup1YXBHqUpxm2ZCraBECNwghtGXaWLkZu/U6M0rTprMWWayG6ly/TaQzNeQT0yJUNNd036OplcmXsKL/q6jG59Lv+luJO1mQWwVPVK9zCDJVvD823mw=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b78e00f-3a3f-4041-f2d3-08d832d626b6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:11:03.3921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e+4MVYy28p6eTJF5OPibT8noN9jAIMSsZxolUVY6DqAXBpITJUlnWjWZbb1MmU7jQt8Kq4GOPtshyy6h8o33bQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4879
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

When either esw_legacy_enable() or esw_offloads_enable() fails,
code missed to destroy the created TSAR.

Hence, add the missing call to destroy the TSAR.

Fixes: 610090ebce92 ("net/mlx5: E-switch, Initialize TSAR Qos hardware block before its user vports")
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 1116ab9bea6c5..9701f0f8be50b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1608,7 +1608,7 @@ int mlx5_eswitch_enable_locked(struct mlx5_eswitch *esw, int mode, int num_vfs)
 		mlx5_reload_interface(esw->dev, MLX5_INTERFACE_PROTOCOL_IB);
 		mlx5_reload_interface(esw->dev, MLX5_INTERFACE_PROTOCOL_ETH);
 	}
-
+	esw_destroy_tsar(esw);
 	return err;
 }
 
-- 
2.26.2

