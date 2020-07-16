Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481E7222E0A
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgGPVd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:33:58 -0400
Received: from mail-eopbgr150042.outbound.protection.outlook.com ([40.107.15.42]:23206
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726198AbgGPVd4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 17:33:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b5rDD2LzhJuQsoUJKqT9HstSXY7E6ap628UTx+lp036OdXOwrUMRt+A7U34df08F6xl9gAMtNV9JpZ7lrVaU0KakESN7AW+vZRaXxHtGYXgAVsoy1mSJftYQVfLD3d90kq7OC5xPzSylKi4j6XTz36vPDAC/qCDFEjslWhdBseqcVKJWZ3o7AZKz8rCF2NMUbV6W39bnAPIhLkb3/5sXTTCZL5gI27GkXyZWwiP9fD7AAtdwpb1+/9eTqiTjo4voxDl8LMMKEPJy9WxADCwsRpXB4Hj82LnL42V1O8RweeOHOw/6NwQyitcb+FT5g2lhiohZ8vazds2n/Qm2OyxcbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCRR7XF87RQ+LPjlTyB5I0hbVpFB8TvaO8mUv1M3c/M=;
 b=hlYSZYMtDSnuO6AaScQYyAiSm3ECvb3tugACNUT2FOw9FbK1UeYbcZbp2Bg8vZ4EZe5ZphiaxbwREWszClj2tdWaTLEIhoYGgPbEIjAbvZM3k48tAutbJvKfX0+pkFqUGZ761J5m/gecC0CxLVlPsHAvwoKggAUkQQVWETEXaEOj3VZwzmJuyU0/K5IAHoZtA1FAHFqEB9yKsB+2Yup2NXEA4jGuy6ypsuku57S0XwXJG3GcrGxsI+cBCFee8OfJlqZyK9+/5r0k2+bwnZINSUB8qzNEGVEaiqGgjGu0s/wbqfaGjL1uFRIpOYIixzBuIN2Fi+Z3KjW1FkAjRLV8LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCRR7XF87RQ+LPjlTyB5I0hbVpFB8TvaO8mUv1M3c/M=;
 b=JAnfyFIpNMz05k4KLur6cXx/jt6A84zlMu+olgcCX/ZV8zkFzsaJVMX1/f+MtPudW5XH6HgAKVAFAlTpHwRTooaKFVrCFwEO8kN/tlm+HbCs749XDCiNTLdqV5crMWz9OBG6XNpDQzO9O5uVrqbdA+gKKOaH7qCGpk1/5yxqsfI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB2992.eurprd05.prod.outlook.com (2603:10a6:800:b0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Thu, 16 Jul
 2020 21:33:50 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Thu, 16 Jul 2020
 21:33:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/15] net/mlx5: E-switch, Avoid function change handler for non ECPF
Date:   Thu, 16 Jul 2020 14:33:10 -0700
Message-Id: <20200716213321.29468-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716213321.29468-1-saeedm@mellanox.com>
References: <20200716213321.29468-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0028.namprd21.prod.outlook.com
 (2603:10b6:a03:114::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0028.namprd21.prod.outlook.com (2603:10b6:a03:114::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.7 via Frontend Transport; Thu, 16 Jul 2020 21:33:48 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4d956009-1f14-49f0-df63-08d829cfedf7
X-MS-TrafficTypeDiagnostic: VI1PR0502MB2992:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB2992864505744D6C16612E09BE7F0@VI1PR0502MB2992.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H7LkZRWjc/kRLtzvhcExQSGg3QUxeYHOJ4GwDxWjyNYk++54OqHClwOjMoAAC1Mc/nB8SpbO1DBThBDtrD2AbnSROpS9S1chfC6a4gEAqtnsOBzfzDgqzVvmIfoGn3GvfWhChM6RweRKst176PMCzsREa74ZBoDOsRGEl4Ec494jEwJJIox+Kn+l40LW2CgMXFhrXJn/Xyj7xEM9WBOBU5mmETvUE81DLAbNZazAuWykQvU1PMOtJv2uAZvxtVmZeF16s5EsjipeL0VGb9ZJE+5arWgKskfzYsSDeDnDchYR93BxGiRYPLRbkY1WMvHY+QEeRMgLTuXV5gH7gVyOIMp3yO2C72JnHCQEWsvSxvPx5VPe+Ond5xSHtOliE0bt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(86362001)(66556008)(66946007)(66476007)(478600001)(8936002)(107886003)(186003)(6512007)(16526019)(956004)(52116002)(2616005)(4326008)(8676002)(6486002)(6666004)(36756003)(1076003)(6506007)(26005)(5660300002)(54906003)(316002)(83380400001)(110136005)(2906002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: W6trBMudTRgVe2Ef6Vb9FKXpEiJD/7s2zZ7oTnGC3TUZA8siGRXB7h+qibQrQ8u3tWWCyE301vD+US5gGYi5aonhdG2xNnwngSBTu3mKsZhelAbKNjKM5EHwwKYORtDSZwCsI/7XU7lxYHAGh3D4EOHJxHTSDbeoGnUUQgBpobHQgPbXI+ntT0e6Ri8Qgt10FNXny2xVbgmxg9il9R1gdk7w86zG3G4+PvMoDwsbRHEZSiL3PxJ5M18pzliwBwRJtkSscFoYyGgQlKZIizV3xkbB1rgxV+SdH0yVGb/VSX18sbMgP7wlmUjcaZYMPRSEDxS6+lepR2s9Zffm7Z6dEwjY5n5J6N8mUOLKQtCblTLO3MxYjqSG7fiF8VqGUXAe8zTiKVz83sI9AbBtk4OkHFJlacgIZMj2YM9vbq/q+4dHx9Zp6tt8JTap+JtuFIRrPmqotwFx75wbOrNlgSE7JqjbDpD/XYqFkgB216jxQ7I=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d956009-1f14-49f0-df63-08d829cfedf7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 21:33:50.2377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nzJJruJe3yz+Jh+nnGOGLXxjG+dgCrU4ssuv1LLGRpvJeDrgER6BN6OgLOqfLZ8xWfCcGYpKvw8mLXHwVmzTNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB2992
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

for non ECPF eswitch manager function, vports are already
enabled/disabled when eswitch is enabled/disabled respectively.
Simplify function change handler for such eswitch manager function.

Therefore, ECPF is the only one which remains PF/VF function change
handler.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 522cadc09149a..b68e02ad65e26 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -513,16 +513,9 @@ static inline u16 mlx5_eswitch_first_host_vport_num(struct mlx5_core_dev *dev)
 		MLX5_VPORT_PF : MLX5_VPORT_FIRST_VF;
 }
 
-static inline bool mlx5_eswitch_is_funcs_handler(struct mlx5_core_dev *dev)
+static inline bool mlx5_eswitch_is_funcs_handler(const struct mlx5_core_dev *dev)
 {
-	/* Ideally device should have the functions changed supported
-	 * capability regardless of it being ECPF or PF wherever such
-	 * event should be processed such as on eswitch manager device.
-	 * However, some ECPF based device might not have this capability
-	 * set. Hence OR for ECPF check to cover such device.
-	 */
-	return MLX5_CAP_ESW(dev, esw_functions_changed) ||
-	       mlx5_core_is_ecpf_esw_manager(dev);
+	return mlx5_core_is_ecpf_esw_manager(dev);
 }
 
 static inline int mlx5_eswitch_uplink_idx(struct mlx5_eswitch *esw)
-- 
2.26.2

