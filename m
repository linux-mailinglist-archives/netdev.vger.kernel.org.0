Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0A2127383
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 03:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbfLTCaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 21:30:14 -0500
Received: from mail-eopbgr760115.outbound.protection.outlook.com ([40.107.76.115]:20490
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726964AbfLTCaO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 21:30:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HpORmJzJL1SkrI9b7aDlejhsq6/LoOCPwzxHLCKMkAcP7NIVkPkMdhKl4z+3HRoMldhnjQ9f2pDdl1qqTS5+H1NZVH8+1PhaV3MTsxUvf1dN9Auw35M/85kOYjKlsk2xIiu0jZVWG2sPvp/xxre9JGUDa8s+lZLjereQpvhhJCYmh4EXy6zVBneCD0HyMY9IO/ov3WyRem32wLeI7cT/jY0W3SZ8/YBH8ZVMdTgGSFdW43aygmcpAmWn9lnN0ALmhr5/dqreAaPV0jeXbSzA1FoWV1YzNAGhIXSrhX1fv4ovPGIn3ADfFo7D8MUtAobxdO87Ze4rQre8Mao53r3z3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YUErxkwJxf/TDdpi8gYXLJBEg+vu3u25t/g3+9uL53g=;
 b=Ib5hUwJ79dnKCwSY2UKIhsT33kGmnATz+dUDmDI+A/TWDFBfV5YauWvjmJW+P9zcc6nyZ8hukb9BC3DIc7qg/0kF99CPTnMC9LjlEH9CR3f7w1q0DCFocXQx9R4LSBzMzrJoCFEIBJENFm4styqrxig6ml21p/nwePlKl+phyc1nOS9zUZxbtXhTctiTli8RwJVhjC7lPcTJx0yp3FRaxU2yyxGKo+pT8TTb25fb4cslenqpGXB2TrAn1AxQ9+PtSXYXdCdmZP7MY+o6cD4rTU58CdPOs+xwZYg6QGCroXJ3wzKi9kOYNsVzxWv0r2DxBNpxOLT0QUdby1Qi+n/U7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YUErxkwJxf/TDdpi8gYXLJBEg+vu3u25t/g3+9uL53g=;
 b=MkGqRIE4kJBMgFErSzOIdoIkfSHdWH3T42FqdbUsl9K4IyLVPKKSYE2t/ZDC1LZ8tll+OxkRN+FrWhNxcLeOkiWF/9KJ6XewvLiM084mEYbIljHGDQ9Tl76D0IdlS5mJfzfAhPmbYu5jFwptcIT5cyfSjFqjK8kIpxcw4nCBavc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com (52.132.132.158) by
 DM5PR2101MB1064.namprd21.prod.outlook.com (52.132.130.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.3; Fri, 20 Dec 2019 02:30:11 +0000
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6099:4461:d0ca:f3f6]) by DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6099:4461:d0ca:f3f6%9]) with mapi id 15.20.2581.005; Fri, 20 Dec 2019
 02:30:10 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] hv_netvsc: Fix unwanted rx_table reset
Date:   Thu, 19 Dec 2019 18:28:10 -0800
Message-Id: <1576808890-71212-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: CO1PR15CA0065.namprd15.prod.outlook.com
 (2603:10b6:101:1f::33) To DM5PR2101MB0901.namprd21.prod.outlook.com
 (2603:10b6:4:a7::30)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by CO1PR15CA0065.namprd15.prod.outlook.com (2603:10b6:101:1f::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2559.14 via Frontend Transport; Fri, 20 Dec 2019 02:30:09 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7690528f-bd74-4c67-d873-08d784f488d1
X-MS-TrafficTypeDiagnostic: DM5PR2101MB1064:|DM5PR2101MB1064:|DM5PR2101MB1064:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR2101MB1064A258119424AAE9456F09AC2D0@DM5PR2101MB1064.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 025796F161
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(136003)(366004)(396003)(39860400002)(376002)(346002)(199004)(189003)(6486002)(81156014)(81166006)(10290500003)(2616005)(8936002)(2906002)(478600001)(6512007)(6666004)(956004)(66476007)(66556008)(5660300002)(6506007)(186003)(8676002)(26005)(66946007)(52116002)(16526019)(316002)(4326008)(36756003)(26123001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB1064;H:DM5PR2101MB0901.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p1zFQWt69BIqaZy4L3SBvDRBjJgUHdRC9bLWG2REwYfnLyw9tSsF92VNS/98lDZoAqvrOdLhjwNvtq7vPrWk0iMMrw6sfumRqZYbSYHrZ7nsBRmpMUzoSooHkFmNtT33N54O0XpniTUefTlXZnWwgjwIr9QKo4p/pBiVe/eNAoBTX2h/yK/l8UxuJ1kDj2Mgly4vS2UlqoodonGvM0PbkwhZQev95ltmHnmJgElhQ7HRWrV1dNvpuycmQ7u/KUoL/7rsefg5Dz8Zap7IypLn/DefTqJ9LHRNP/Tc1MTme3YK5iMX6cA6DUZWJfVYiJfn7g4jRCscpan+2CPoNC13xpAUHJDrvl+mJ/mK6hsVi5Wv9y93NPnNGo+oaQp0eTdjpjJZsSXSfkk65t8bt5pkuffAsqlLo2i/2v5kg0iN5vS4arMLSs/DFiHAbKm2IVIo9EltMWfySIQ5OwSlucqYLI0/OoUmw0gK/6cw5h/+0RRp6vhBvtFPoyQ1BhhdMJsh
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7690528f-bd74-4c67-d873-08d784f488d1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2019 02:30:10.8919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZN15GyaE1c9pzYVZcIj06tOghLQ1XUnLmkcu+cj96fRMsn7pQQgm2d3DD2Z6xCgftW67fcR0a7QSX7qEN0nykg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB1064
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In existing code, the receive indirection table, rx_table, is in
struct rndis_device, which will be reset when changing MTU, ringparam,
etc. User configured receive indirection table values will be lost.

To fix this, move rx_table to struct net_device_context, and check
netif_is_rxfh_configured(), so rx_table will be set to default only
if no user configured value.

Fixes: ff4a44199012 ("netvsc: allow get/set of RSS indirection table")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/hyperv_net.h   |  3 ++-
 drivers/net/hyperv/netvsc_drv.c   |  4 ++--
 drivers/net/hyperv/rndis_filter.c | 10 +++++++---
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 9caa876..dc44819 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -169,7 +169,6 @@ struct rndis_device {
 
 	u8 hw_mac_adr[ETH_ALEN];
 	u8 rss_key[NETVSC_HASH_KEYLEN];
-	u16 rx_table[ITAB_NUM];
 };
 
 
@@ -940,6 +939,8 @@ struct net_device_context {
 
 	u32 tx_table[VRSS_SEND_TAB_SIZE];
 
+	u16 rx_table[ITAB_NUM];
+
 	/* Ethtool settings */
 	u8 duplex;
 	u32 speed;
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index eff8fef..68bf671 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1662,7 +1662,7 @@ static int netvsc_get_rxfh(struct net_device *dev, u32 *indir, u8 *key,
 	rndis_dev = ndev->extension;
 	if (indir) {
 		for (i = 0; i < ITAB_NUM; i++)
-			indir[i] = rndis_dev->rx_table[i];
+			indir[i] = ndc->rx_table[i];
 	}
 
 	if (key)
@@ -1692,7 +1692,7 @@ static int netvsc_set_rxfh(struct net_device *dev, const u32 *indir,
 				return -EINVAL;
 
 		for (i = 0; i < ITAB_NUM; i++)
-			rndis_dev->rx_table[i] = indir[i];
+			ndc->rx_table[i] = indir[i];
 	}
 
 	if (!key) {
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 05bc5ec8..857c4be 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -773,6 +773,7 @@ static int rndis_set_rss_param_msg(struct rndis_device *rdev,
 				   const u8 *rss_key, u16 flag)
 {
 	struct net_device *ndev = rdev->ndev;
+	struct net_device_context *ndc = netdev_priv(ndev);
 	struct rndis_request *request;
 	struct rndis_set_request *set;
 	struct rndis_set_complete *set_complete;
@@ -812,7 +813,7 @@ static int rndis_set_rss_param_msg(struct rndis_device *rdev,
 	/* Set indirection table entries */
 	itab = (u32 *)(rssp + 1);
 	for (i = 0; i < ITAB_NUM; i++)
-		itab[i] = rdev->rx_table[i];
+		itab[i] = ndc->rx_table[i];
 
 	/* Set hask key values */
 	keyp = (u8 *)((unsigned long)rssp + rssp->hashkey_offset);
@@ -1312,6 +1313,7 @@ struct netvsc_device *rndis_filter_device_add(struct hv_device *dev,
 				      struct netvsc_device_info *device_info)
 {
 	struct net_device *net = hv_get_drvdata(dev);
+	struct net_device_context *ndc = netdev_priv(net);
 	struct netvsc_device *net_device;
 	struct rndis_device *rndis_device;
 	struct ndis_recv_scale_cap rsscap;
@@ -1398,9 +1400,11 @@ struct netvsc_device *rndis_filter_device_add(struct hv_device *dev,
 	/* We will use the given number of channels if available. */
 	net_device->num_chn = min(net_device->max_chn, device_info->num_chn);
 
-	for (i = 0; i < ITAB_NUM; i++)
-		rndis_device->rx_table[i] = ethtool_rxfh_indir_default(
+	if (!netif_is_rxfh_configured(net)) {
+		for (i = 0; i < ITAB_NUM; i++)
+			ndc->rx_table[i] = ethtool_rxfh_indir_default(
 						i, net_device->num_chn);
+	}
 
 	atomic_set(&net_device->open_chn, 1);
 	vmbus_set_sc_create_callback(dev->channel, netvsc_sc_open);
-- 
1.8.3.1

