Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2622C487971
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 16:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347969AbiAGPBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 10:01:53 -0500
Received: from mail-am6eur05on2056.outbound.protection.outlook.com ([40.107.22.56]:26369
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347996AbiAGPBe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 10:01:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4GrYcSrC0MCkN0zwEeSBAi1bXTbWpKhspaw/RSN095pgJsMtFPRkt3RXrg6xr63YgyxhH0HQI+yBUyoEHWUxvimbJ38W29G8GkQQUi2UCAqzudvKJfPG/NNH67GP4wdX4oaTTC70NfyB7kc+DtMWNt1mJ+zqYzRHpFpkTFxV9zYAXByeny4bGSKlO1b42Qu536Hkg1xbAEHIENASrkcisgCq7oLV1Xt2zZYrsIyh4HFz5QUjsV/uRN4h24RcfCx5YSsPkKzmSe6t8iBfMjniGpMaEv65zr37Yh4BmXg4PEy0gEkxT6hHMIeqg8sOJlXi2p4Nmnyc629PJIzn9VqPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rxXLAC10twlbXfzp+Z2Dwge10sPKtvK1xZqtxx9XcfY=;
 b=XHiPXa6auiL6zqBEgGOlyIf7oVQPORgoJVhqRYKLDB10RKxXSB1ChCxyrFZtlOQe4GvkPe3FUu3kxx8MC/2m8u6UzdfRsAllnZzNloF4xWx7XmcJgDNGhOcGalrbevGZwXAez+X13aUvrLvf1Z8FIqkDdrfDKKiyTyeHSaX4D3PBQOErDQuDdzZsB5IjoN4JU6Mw5hW39mgdypeBaOVeakynnZIfEURPU4Tn3A8+zvgqeJ7fi9M0OvHrlYBFe4Ypp/l9Zj3FOqdHXQQE7GJdSte8I/j47Qt5DHKpj8d6yHXANPPPpMhYsYa0r3nXoJqCAD6Svg4kc1uuZops1Jhfww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rxXLAC10twlbXfzp+Z2Dwge10sPKtvK1xZqtxx9XcfY=;
 b=FaCRWDvZLmVpy1t2hoIew33QqhjMeQy4t0a4iYjuFw4I0P0ft6QDjBp3q+e++n9qdKTGs8Y1+o5SEcNGiSxUqulW2s5cvsJcUFcIT1iIHRD0bKqcBWgptPS/Ut9XpaPAwX4MVlzVPUple7jM0ev68xD2VWMgr1JBrVzz/gosP18=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Fri, 7 Jan
 2022 15:01:13 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.017; Fri, 7 Jan 2022
 15:01:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [RFC PATCH net-next 07/12] net: switchdev: export switchdev_lower_dev_find
Date:   Fri,  7 Jan 2022 17:00:51 +0200
Message-Id: <20220107150056.250437-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220107150056.250437-1-vladimir.oltean@nxp.com>
References: <20220107150056.250437-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0059.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::7) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d079de5d-b316-4c23-5d1c-08d9d1ee8bee
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB34088F21A0D12A58E95E929BE04D9@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cXbPZT0Sj3mNYUqzK1oSmvrIH1mTMiZfCpcK42Vgmkgcy52XUnbKD7oH2YimUSmUzCJfpI8SJiCDerA2uhZ3sGYs1xposbeyO8a+XW/S3bwG9bqBJeJ6/ngFlBwloZ+tLj/MUszFcdo1lEF+rhMNjJA3DDY+mHeQQnPhlnpOtsEc/NNzvP481/2WtQJeOAdpz8+6drvxwEYiewVHecs+SbYlLFsUvRDkEwufQ2jrwLzRvhMAOZ7/QKRp9mPs86iknS7J82LZNEpXPHqzlMdPmp9v2dnedUB1okZAihj6vGePTHcenm07SYk9CStzQ9qNHIrIJ/Tgd5QC+PUCu9XFg1qr775Qj1vzZM9wMypSv/MHdofNqWAmnYKGJ6Cb7rU4o/VY/5T+EcjjmCR9Vve2n6dlu2AXzo1cPigrUq8FuFGQoL+7MTto3xJoZ92JKCL4X2GqHLC+ratzsmPsAdV3R63tyCHiB2+tCoVzbYYGJrBuSuvyyZKeNz6mM6DtpS/6CkfAtJyQ8tTbt9uHwN424SeoLaIjg+ZvqxfJnc+9bDJhqtj+tTA7TaSmBLG3UfClZY2F3CG7so/90ArkwMFrabDIDysbpCwZHqLlupY18zlwpmJwVA9Axg+KECk9I1xar3bu2C7zhMpQjGGytb5a5rPDf7RD8bIFgEXaleJhfbZpoaWtjclg8yB0pwKC5DKCb7gnb/VZCJbDDGFQcYlDyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(5660300002)(1076003)(8936002)(6512007)(8676002)(2906002)(44832011)(4326008)(86362001)(38100700002)(316002)(2616005)(36756003)(6916009)(6666004)(83380400001)(54906003)(508600001)(6486002)(186003)(6506007)(52116002)(66556008)(66476007)(66946007)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J5/dceu5YlnHJQx+8Lg0MA2SgVGO7YnujUqbAycFb+50QS8yh5rzWVUcOJAU?=
 =?us-ascii?Q?UIOEOqvNEfur7XjBDK/OGKLQfIh3FRkqA31F4Zt4ETBOZJ1xLfsfvHwNFazT?=
 =?us-ascii?Q?13s2V/d33cJQt1b7soHBDonhMlofDEdc0tuCoppSAAqqXQ6whE9dkfkaRjQu?=
 =?us-ascii?Q?GTYIvhMQRxnpG3Mgql2B5vGHT8+TjEixFM8xPqHX1zYWfQHK+531N+hdTDpt?=
 =?us-ascii?Q?N0OiY0KAvOKXg8eY/ne+Wg50g1JOArUd6aX0gIRJvLj1hMuxlGLcnBylIRTg?=
 =?us-ascii?Q?ZTaKaia5KozuR2EpfAXtnE6GXf8oZa1H6PjANtyCP9vMNdbXHqkzZXDN+v4A?=
 =?us-ascii?Q?LfjQtGPofCumxZ9x5QkrOpXQeiyv/6jYW9jiEmpRKbmzkp6uv1kAvLybGStD?=
 =?us-ascii?Q?+DaD0Lk9E540f5fyf6DBwMMirMneY0nEbjctRBxTvKEiLsYehPL2tEa9r4UD?=
 =?us-ascii?Q?LHE5iqMYIoEUD/syKBV1qtWmbAG/B19rgxhrWnoe4Vu054tiRq8mrE5jh+A9?=
 =?us-ascii?Q?NdygTxUF0gDju5kjgKWoeovJRMzfib7x9H4T7tNkYNK3k2tW1JYFgKiJDMTF?=
 =?us-ascii?Q?IwCLBvDHNHhgJo5lW29K6LeYqsXw19FG57zmVvoy7LNpLJs2yLhUQTBseBMz?=
 =?us-ascii?Q?jjUrmNIYd6ElTHl4R6te5plYLW/q3A2MdszRf7ZHeOTTv/v2RgD38/JL76BU?=
 =?us-ascii?Q?La+6xHsxYpo8no4183OUQsIQqRuKGcRtD5CW+JkyivCENVBKU0nEMvxoGcNz?=
 =?us-ascii?Q?zRYGp+fTTaOIP7xnnBy5VLi6FMc6LvXvcWDhA6krxsnrkpuiAyAi1Xsry7VL?=
 =?us-ascii?Q?o3KfIjblt8ZMzh4IkCHIHI222vlLws78p+sdvjgM+glnKJKpsBUSRwZZzjRq?=
 =?us-ascii?Q?04ppq2uSfUkT7ItyhVIetQiNX05HrdcAVt4MYLa0dZVQuMHR8V+YqxohPyog?=
 =?us-ascii?Q?vTdoOfmScBLGbBRLk0QJOpUAWGflg84yGJMLX0AxKtGnjTqSwWV68DlBg4k/?=
 =?us-ascii?Q?ATfkltv/FKTRYqeL4oATimm8eccFSnoX3olilKljolVzgdcJwzg823G31Hra?=
 =?us-ascii?Q?8JrqFq2OjLxGhmDWe6U/wFJ03x+1wHLTW48QBPdXLBsImcov6/bwH7lq8GrW?=
 =?us-ascii?Q?CdVjDxi5Q4CawlU3duurZpaPGSH+GbOzx83k8vBoPxWY+P1H/wdBVWjNtDjP?=
 =?us-ascii?Q?cUXU/yYZT85sHy2jS/VZ494t3G/NyOV2P4COcVH1UV4siY150H5y9pRYcfhy?=
 =?us-ascii?Q?yvNY7+RF21qhDWO2N3qHbSNLE2Up8+FFlLGA8PlrTqrWDmKNfnXAt/4Ymp2v?=
 =?us-ascii?Q?SR5R14T5oiqEcSrP845EGjs6vl1p0P/OhGEpkbOelXepBor/0m5rhvgmt8xP?=
 =?us-ascii?Q?rSFmjZMN2M9u5u8rgmKsx1rc3WlltFZq6x9p71MOxFno12IXwt9hfRZ1nSfM?=
 =?us-ascii?Q?srYBhdWd/Dpuhqyb/pWNsGiLl71dYVBnkBGHAfC2KHlQf2y4mNdRnX5Jnupr?=
 =?us-ascii?Q?zjcRzr1JXV5ALLrtylmFEvYTl8aQDm/WoQPvuZwALDCH7v4jvJSL7QZHQqjY?=
 =?us-ascii?Q?wfOLKFETnjmVo8wlzsMV2dFLq8bqRPtYYXCp7C56E83N5zpom1wGZEnOwD/p?=
 =?us-ascii?Q?tsI1Fmi+drC81TZ/xqkGui4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d079de5d-b316-4c23-5d1c-08d9d1ee8bee
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2022 15:01:13.1118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6z9FVz5yFnPaD+gL88Shj85Xo4h6pHid4T7aJDoKfcIzsnq6lcoOrqzK2elnhKpXvibO47EfM38BW5ilgmdKOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This little function that retrieves the first lower interface of @dev
that passes the @check_cb and @foreign_dev_check_cb criteria is useful
outside of the switchdev core, too. For example, drivers may use it to
retrieve a pointer to one of their own netdevices beneath a LAG.

Export it for driver use, to reduce code duplication.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/switchdev.h   | 6 ++++++
 net/switchdev/switchdev.c | 3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index d353793dfeb5..40b348f9898c 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -299,6 +299,12 @@ void switchdev_port_fwd_mark_set(struct net_device *dev,
 				 struct net_device *group_dev,
 				 bool joining);
 
+struct net_device *
+switchdev_lower_dev_find(struct net_device *dev,
+			 bool (*check_cb)(const struct net_device *dev),
+			 bool (*foreign_dev_check_cb)(const struct net_device *dev,
+						      const struct net_device *foreign_dev));
+
 int switchdev_handle_fdb_event_to_device(struct net_device *dev, unsigned long event,
 		const struct switchdev_notifier_fdb_info *fdb_info,
 		bool (*check_cb)(const struct net_device *dev),
diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index b62565278fac..85a84fe6eff3 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -408,7 +408,7 @@ static int switchdev_lower_dev_walk(struct net_device *lower_dev,
 	return 0;
 }
 
-static struct net_device *
+struct net_device *
 switchdev_lower_dev_find(struct net_device *dev,
 			 bool (*check_cb)(const struct net_device *dev),
 			 bool (*foreign_dev_check_cb)(const struct net_device *dev,
@@ -428,6 +428,7 @@ switchdev_lower_dev_find(struct net_device *dev,
 
 	return switchdev_priv.lower_dev;
 }
+EXPORT_SYMBOL_GPL(switchdev_lower_dev_find);
 
 static int __switchdev_handle_fdb_event_to_device(struct net_device *dev,
 		struct net_device *orig_dev, unsigned long event,
-- 
2.25.1

