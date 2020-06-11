Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57EB1F7091
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgFKWrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:47:48 -0400
Received: from mail-vi1eur05on2064.outbound.protection.outlook.com ([40.107.21.64]:6125
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726254AbgFKWrq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 18:47:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WqGIafdk2pZgj+62LlrQ87fPeGUn0gZdASLEXD5Ujsl2yhmANDQMSgfjHl6eEAKHkgJ8JDD1YEG2miB7ANWsIKB+SJoWjXrpeb8kPqrcBB7l0cbk1c5jvMzjzwqGMByQrVzfffelOlSP+QRPAU64ZvmfQnb4caRQ+gtXwobuIbmvICGZYUHi7+J+S2pqKwY1qeN7l/6iTHvhfwWzkeTrco2bxNGGvQGP2xgiU3SleUW2MuYIhew0JrolJdT1ATyM9v3WAAKfl2Wut0KrZUOj1v3IF/3QhBBSCvT1IaglmXs/CcJwJ0CgyffrovN60NTgyrvpUQVEGBc3nnmQ7chWIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bG/knJJBn1O2FRj5oJL6lPWNtROrhpHUb3vnY70hdtc=;
 b=eqiA+V4JXsLDsMYW5tjfuFPYt9sTF9i57HM9ea9Fjp2qLLFyDn3j5Wr1/CDvSbSGooiNAXatZruGhFIIb6cHgIsaSG80+k5SHxRsq6jkN8zpJQCUi1KiN19e/H1KoIERZJU93KgJp8k9ZQiP6AbbboSkbDuNeNqMs0oRC5W/Cou1JTZn5A1XY/rKK6Ni2cVR6B/v53puhZaIlYezCtBzX1wdlvU8i4OFMy6RIuOaoyvNhDn50MjehRhLA9Emrf/4+Y5dAuhZfrvwbnwe9rV5tQVxkJ+uOETqk3K9zi2z3PuqKKvyGPDcyChrF9SP5iwj0Ah5tOM8V2mB5UVEnydpkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bG/knJJBn1O2FRj5oJL6lPWNtROrhpHUb3vnY70hdtc=;
 b=Hrq5CBGRgeRRjuMZymW+2mlSK0VAUII9Hq+kfPO5JqEVUKXc6oGkZdG2hWonLIRRb0Z5PvL6ItFYw84gcyDB5XCiBqmYPBDk0WXUhiXJ16d1piUqBJjSCxPsUWKASOQOF2Pncn0OGTVDyihlr9ce4zNYhHrnyfWzh/r+aZ9lFIg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4464.eurprd05.prod.outlook.com (2603:10a6:803:44::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.22; Thu, 11 Jun
 2020 22:47:41 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3088.021; Thu, 11 Jun 2020
 22:47:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 02/10] net/mlx5: Fix fatal error handling during device load
Date:   Thu, 11 Jun 2020 15:47:00 -0700
Message-Id: <20200611224708.235014-3-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0066.namprd06.prod.outlook.com (2603:10b6:a03:14b::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.20 via Frontend Transport; Thu, 11 Jun 2020 22:47:39 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bd7ec66c-72be-4636-b026-08d80e5972d0
X-MS-TrafficTypeDiagnostic: VI1PR05MB4464:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4464549F8315D86AA58A32DCBE800@VI1PR05MB4464.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0431F981D8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yBiqRc5e1qXWbI8+xjWuk+4RjDTsBxgWIJRB8QZ4aqNK+g0V//r1HxcGxdmJyZNBzNu9xPVhRe/ur7w0j6heMdXt2vdypsLOseEm6rO70nP/gOzom5mDVS0EaGlnz2Hxq185QVTpC9irmceB/NOvuVpIE0AQ4JFiEnxAB6KrVnwaQsuiK+JDo/prGbhd9xuL2ZKV6btgBmzpfgaojTXHcJPmdEmATYJEZuA6l5rbe3LNiO8ii9UKg4Wxk+MkmEpFcNo9F40QXhG4ho/jwDqE+fKp3ylWpZfNyn0nqHmcpzViny58nhFci57+L+WsAueH1a+eN6y/JE3y5HQK1ge6nBsuE9GDcT1iRtdHlO2PXlAAyJjhoBqZkAi7WiJuRaw3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(8936002)(16526019)(186003)(4326008)(316002)(8676002)(107886003)(5660300002)(478600001)(26005)(956004)(2616005)(6666004)(66556008)(86362001)(6512007)(6486002)(66946007)(54906003)(1076003)(6506007)(36756003)(66476007)(83380400001)(2906002)(52116002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3PXYgU77dFz04JXuTdoon2WNk1J/1bC/Od1S+UcNDIFL2yysmX7BNSA30twxdsNRHrGoEVt2hw62mG6vxHxaCkv1dFYdfoDA67sFEcJDvKYmNS6XKfHKQzle0plnpMwebiLaLYsIXTH1yGpOPPUgxUKFK/hrta6Z4H7pINBsGdf5wL0XalbGGP5Akmmw4TgdTb9oAUMt7W7mlxBqwT88uGOv8RIdzkZeYKC/zFw5ly2RfiCWqysWq/rkx08wAwRXOewsK6K5KzwyAQYJe1Cn+VhHxgfiUcwIZOvwdWwpSAi0RORAfGgT1fEB7CdDTIqSvIt5cI4et/A5mV6ic+lOKLMTV97fVhRzy+A2+sFMyCIsafo7iqa6lePWe3Ysye5iDABhc9cE1mLn9KA7eS+7SsrpWiro673kcuxXvChRwNeHVas+v2tdBE5qaxYl4fIhzP95qhYw/gi51u+5dbhY/rJDOkCNeI7hw8Lphc1GZCY=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd7ec66c-72be-4636-b026-08d80e5972d0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2020 22:47:41.7440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NXkqoVhZULfnR5mXm/jT2DY0kf2F263TJnOIRI7o2+4Uku2g8vZ6RahSXXE3juLTgcblEID5DqwjGtJadAnGCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4464
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@mellanox.com>

Currently, in case of fatal error during mlx5_load_one(), we cannot
enter error state until mlx5_load_one() is finished, what can take
several minutes until commands will get timeouts, because these commands
can't be processed due to the fatal error.
Fix it by setting dev->state as MLX5_DEVICE_STATE_INTERNAL_ERROR before
requesting the lock.

Fixes: c1d4d2e92ad6 ("net/mlx5: Avoid calling sleeping function by the health poll thread")
Signed-off-by: Shay Drory <shayd@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index c0cfbab15fe9d..b31f769d2df94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -192,15 +192,23 @@ static bool reset_fw_if_needed(struct mlx5_core_dev *dev)
 
 void mlx5_enter_error_state(struct mlx5_core_dev *dev, bool force)
 {
+	bool err_detected = false;
+
+	/* Mark the device as fatal in order to abort FW commands */
+	if ((check_fatal_sensors(dev) || force) &&
+	    dev->state == MLX5_DEVICE_STATE_UP) {
+		dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
+		err_detected = true;
+	}
 	mutex_lock(&dev->intf_state_mutex);
-	if (dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
-		goto unlock;
+	if (!err_detected && dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
+		goto unlock;/* a previous error is still being handled */
 	if (dev->state == MLX5_DEVICE_STATE_UNINITIALIZED) {
 		dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
 		goto unlock;
 	}
 
-	if (check_fatal_sensors(dev) || force) {
+	if (check_fatal_sensors(dev) || force) { /* protected state setting */
 		dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
 		mlx5_cmd_flush(dev);
 	}
-- 
2.26.2

