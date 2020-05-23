Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900711DF396
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 02:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387501AbgEWAlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 20:41:42 -0400
Received: from mail-eopbgr40071.outbound.protection.outlook.com ([40.107.4.71]:51206
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387463AbgEWAll (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 20:41:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nD75zP6cMynHL6YlSsLMYqVWeGwFgz42DsarLL8uXYL0a1D85MDWLoaOL9vW1WxChm+NSJWO6oXYW7ZAYtbJ4d5ywt/DH+PI6I58/xfrplytjeE8MYKpKQQw55BVMQZ0AM9C6dlBqNQK9ScVYE7lZEfVqZTYYLpRX+tyxKD8hxHY58p58b3ZDO/ivM7R3AajDyaBqiz8K4h9674I1l/YOwNoeIsT6hXc/RKGy+PD2670RxpmVxWV9BuI0PiaWXt1rUB1gyt5z5kqYpJhCvDZlrXfRAk2tqu0Q2i999VUBda4UpFzIY2SgIQdgWdVhTTI9EB8WAknNXaJqpHLgqRrCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d2sa5VWp+IfretuqkGR3hatVbGu6VFNtas5GnKvZdmQ=;
 b=CVvogx5yZdC01/TXaeL0fiN7u09JAFERd0oRhB/NlYKyyLvFhabrRoheca8GW13UvSeD5XT6CsLhg+CoXdbapd0Z5rzYWUIN36YcnXRFtABWiCKfkh7W+7Vx+hnscZ35djERR0sY6Ir+i1oz4jsx5VUpEA7EkS9Ti1WGLTTEQKFB53KaBgREqHJb0hQRQg6aOv5+8tIUPD5j1WhqgAFAGm5K1ACPkvyBWZje5BQw+wMLfMDorVkLaDHV2x3KL2Lp5imejslD8YMJ98bOAs3bN2nqXIbzGsgRwlHCAbVLTCkm6tqMUxeu5KgFZyaaM+1/0n76d1aQ+3HHd65qqD7vXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d2sa5VWp+IfretuqkGR3hatVbGu6VFNtas5GnKvZdmQ=;
 b=ggKOAaZIj/Y6XBJDLQz6z56OHoAtPPWh2G8fznWdlsW6cvT7CohLyhE1CxIdHyeaNpT7iyptvOe52k8r2L+1BwLJ5C352oLGcEb+ZwQDrdimE4106SCa0py+2CrbwAnDAT8EUll/oTB6auJ12hBKHdmYEF43U1jHf0MGECnAfPA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5391.eurprd05.prod.outlook.com (2603:10a6:803:95::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24; Sat, 23 May
 2020 00:41:25 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Sat, 23 May 2020
 00:41:25 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 07/13] net/mlx5: Fix memory leak in mlx5_events_init
Date:   Fri, 22 May 2020 17:40:43 -0700
Message-Id: <20200523004049.34832-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200523004049.34832-1-saeedm@mellanox.com>
References: <20200523004049.34832-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0042.namprd08.prod.outlook.com
 (2603:10b6:a03:117::19) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0042.namprd08.prod.outlook.com (2603:10b6:a03:117::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Sat, 23 May 2020 00:41:24 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6529b7e0-bfc6-4d1f-d9a7-08d7feb205f9
X-MS-TrafficTypeDiagnostic: VI1PR05MB5391:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB53916C68B413337516B185FFBEB50@VI1PR05MB5391.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 0412A98A59
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CYm5F4tXh5APUSqGY85QjTKK1sT/6ueOczNMaTz62F0jJOq0pidYwykeBCyKh4erkew6KSOzxywqHILsMbxzoh/2h4HbXgrpnC3WinP+BDNNraJibi+87ZZeO6xDWNra5AR5BKJWoW4CILLH3hHSvmZI8Kuxk8i+JMTlEw7P3wA8MyCXmMU1ApPF0pDCP9ifVSyVuI5WxEEXgTxDHNHoHwfXBJea/xt+t2gZ7+aKOgtTkji3k/yotJNVdPI+UHLt/yD7Kb+DwbvioU0TAKlqU1OEC270b3s745r6CIaBM6cn0WGWJZJPfDnpP6zTmokhI6XlZlMvCyq24GHkRLvolD6Tul0BEKRS+LyZ3WKUM9DkYEUSpFogPkqmAX74fV+l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(396003)(39860400002)(136003)(1076003)(8676002)(2616005)(956004)(4326008)(52116002)(186003)(26005)(16526019)(478600001)(6666004)(86362001)(6506007)(6512007)(107886003)(36756003)(316002)(5660300002)(8936002)(6486002)(66946007)(54906003)(66476007)(2906002)(66556008)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 7KMVKOptzMRXDrMewbpSnJgAEFrrQtsUccPHRMDHXZ2BeUBlgFr8hxCiYGqp+NSep1MZ/7vNX0Zj7oUJcufxKE0ow7ICkterg520+++RnDTRkvIUm72d8Qrnc0OYEoookGybYDNMwt2F/C6vs6YBzI6MURWA6QSLzwpntZ3DjYFtoiZdKoomJXEVuQWBUR8IZiATlvE3TdJEhFp6wVi94kjFc0SW1kVjhMcSMGQ5SOH/Zu66a0we8sGU22DyjB3nAgxkZ4jjTqpTauFh9RapEuJFbg10qnYQwfr2RH13BzwnPpTbDwKzx0HvAhK0uzxtTuY+CLZXsGUTVwWxZLIDZom7AM46bec8jS7mYGgUDO/S8PRmDjGL4mNF0XkGe1w6JfSg0Lo2PNYAVqhWoa0+QpaDINfAz+N7mVUyQf8gDVX+UM95kz/IIEnsAqqP/30hBHQf+sBvyzkq1VKEWZwCv7TkrseLvFEzO9hkpd18DFw=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6529b7e0-bfc6-4d1f-d9a7-08d7feb205f9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2020 00:41:25.8176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xFjSOMFqr6bA8DfbHedi6sqBBJu6Bz0llHhfoAY6jksykq5iM3XPked0Rnl9pLEsfpn/if0wKl5Sc0YL6g4CUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5391
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

Fix memory leak in mlx5_events_init(), in case
create_single_thread_workqueue() fails, events
struct should be freed.

Fixes: 5d3c537f9070 ("net/mlx5: Handle event of power detection in the PCIE slot")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/events.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/events.c b/drivers/net/ethernet/mellanox/mlx5/core/events.c
index 8bcf3426b9c6..3ce17c3d7a00 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/events.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/events.c
@@ -346,8 +346,10 @@ int mlx5_events_init(struct mlx5_core_dev *dev)
 	events->dev = dev;
 	dev->priv.events = events;
 	events->wq = create_singlethread_workqueue("mlx5_events");
-	if (!events->wq)
+	if (!events->wq) {
+		kfree(events);
 		return -ENOMEM;
+	}
 	INIT_WORK(&events->pcie_core_work, mlx5_pcie_event);
 
 	return 0;
-- 
2.25.4

