Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CAE439EBD
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 20:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbhJYSzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 14:55:37 -0400
Received: from [52.101.62.16] ([52.101.62.16]:59663 "EHLO
        na01-obe.outbound.protection.outlook.com" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S232161AbhJYSzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 14:55:36 -0400
X-Greylist: delayed 913 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Oct 2021 14:55:35 EDT
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gSGpws88Pj9fAUtRpPEJSavalQhy04KCpcy2yULBFMsLygD7YBcP0owJuN+boZGhFO5OogVxCMisMLmzXWePBl58owrurMpbzmy6Y8FPMomlSmPqTwgPFsZfuHE0TR0+wJUZu08zmVaOeCcU2DsYlMT8TDTvuw2alhpsNGfxCI48VtmjXec1R5y3lyrgvLMV0dMnu86f2yiAC5AVTKPvmP6wGwoXXmc+maOLLxCKE60pulorSB1mqhljKYBXxjJcyCH7a+CXf7RF6LBoPxlnknr4eHUwdfiG7sQevh5BWLByioptwr/OCNxnp/hHOtOWL44819CqGC7lDTRJ3RtxVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VUgDEFeXXd84eJdjL2h15nY1v4T5WgEPMMsxFkmYf9g=;
 b=iGxeBLDHMrpL+bmIdH1S4cujpGCHx0xfv5JkvY8lKVO//E7KzZjC3moQwoLXPrM/0st5lqJ/TDe3/Mk8doEPyGpw/yFLE7vkJgAZHXynzPdDJYfjDp78ECMOcLPUiG+jhv1pm9/CreDpBHwA84E8yh0/SscBqJhrzlej68SpdflSpYzE+1yIqlyUxY6r2F3lo+qfv5f/6JaanUNhqOyVvMem50oJiJSXoO6GZB5EBXFxz+mUyjbLxrggfOQ+HVj5pwHBrlOQZXGT7mjt/9hPI/Vg4OW0IQZB2OiVuHo0yaGPAwRCDvunIGHhMBLB3200U2vVPWORJL+c95jY83wr6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VUgDEFeXXd84eJdjL2h15nY1v4T5WgEPMMsxFkmYf9g=;
 b=S24SqpcK4lXfAVyr9+peeEnPX9a5ksYOW3mzOp07LCtjn+CXrX+U4+Mots13jI56r+O+tvERXTiav03qah45mG8s2urjwFrK2QXU6mTA3dLDq/Q17QB0S6oKfLe4ZY9928Y0WPGqQ0sXm+jLjK9/6PuRcecKQLjWiJPexeI/saU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from DM6PR21MB1340.namprd21.prod.outlook.com (2603:10b6:5:175::19)
 by DM5PR21MB2105.namprd21.prod.outlook.com (2603:10b6:3:c9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.11; Mon, 25 Oct
 2021 18:37:57 +0000
Received: from DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::d91a:a177:b56b:5b2d]) by DM6PR21MB1340.namprd21.prod.outlook.com
 ([fe80::d91a:a177:b56b:5b2d%5]) with mapi id 15.20.4669.002; Mon, 25 Oct 2021
 18:37:57 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        paulros@microsoft.com, shacharr@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: mana: Allow setting the number of queues while the NIC is down
Date:   Mon, 25 Oct 2021 11:37:34 -0700
Message-Id: <1635187054-12995-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0219.namprd03.prod.outlook.com
 (2603:10b6:303:b9::14) To DM6PR21MB1340.namprd21.prod.outlook.com
 (2603:10b6:5:175::19)
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MW4PR03CA0219.namprd03.prod.outlook.com (2603:10b6:303:b9::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.20 via Frontend Transport; Mon, 25 Oct 2021 18:37:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c68b2dd3-cc06-4ce5-106e-08d997e69049
X-MS-TrafficTypeDiagnostic: DM5PR21MB2105:
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR21MB2105725A8A5FAFAF9B114045AC839@DM5PR21MB2105.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 54iKbcARDP39kbTSGPl/JjmmEsz0JmzihCjVtBPMx6Q7Qal0EF0wDf2ZjdKcnbkY0H5wTLNcmt+/AMQoaPORs9VfKbrkECoi3MqmNqfayjoLfOhn1GL6j0Og4qz/eWsXNF0oPfbOTtuxleQhm7RtOQtCp6eRfgPNo/yot2NQgkjMDxTWHBehfrRQXKUGdQpRyLeoEDHWInlXNNPAiMznGrD2/vvxoXee9hjDl8cLugt0Mx0vP9YQHbEN7MaGxfdnxeOw7lnrH5NxuvwKlSnOU4e6cDyvxO6ADUO2HbWj2UCwRgfDHNoUWXip6RDEx6US6vQoXL7IOiTVCuq5bobcGkIRQP4h+7o/2X1AH5Resl+c+KWEdYFzLwaFaqnCHPiDf/rGzcPWK0PbVMejLHRNGNLOdWiCHgwT00wlbsptfyHqv+Yaon5T6Hh+AAa9g8nKpuSh6z894dBdZpbOs33KDgWz3c7awD90s7ZAbgxxOfcJmCA5Ho5da9IWXKkAkyauMX+JY5sU5ln+xi0VjrubpdZscnkX9HXo8TtSDYAptg+iUzVWUVshJ4rfw+mFn1WB5itqS9pPQrxQwGov7lgZD/nneXiiax2V1cPLrklZmRwsNMfMLq+2Xq1r2sI7YDCFrinUsytwrUZZKqoDvrVpDkMkXEo+nOksd/3FDD9US0Ml70PYMwIOml6p0KnFPG803M/RHyR6qbHCljufijQ3zA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1340.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(38350700002)(38100700002)(508600001)(6486002)(7846003)(4326008)(2616005)(52116002)(26005)(2906002)(10290500003)(5660300002)(186003)(6512007)(8936002)(66476007)(8676002)(82950400001)(83380400001)(36756003)(66946007)(6506007)(82960400001)(956004)(316002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mC9gRt8ATYc4PbcXUz6D7p8Dx8zLQkJW6oKvA0On8nTbfnDQg0bqKIcWnmmn?=
 =?us-ascii?Q?khS4bb6uefG9i/v/51RMKu0p9Zs116pom/HagP1zfOZStafCJdZRHHZ5x0Y8?=
 =?us-ascii?Q?FzhCdX/i4w+WReBjA+M+FzrlV5hMW8iL9dyUX8mkq0P3D7skoLro15R70TYJ?=
 =?us-ascii?Q?VBHyNZqXqRs1pPrTW6CseGnWAMgZEXuHGPmW36uTslD7kByw6Pg+AOOecBlH?=
 =?us-ascii?Q?Hp8RQBTIFchsNpY+AjSEg+yefU2jzGBX5kyFfrgo2ByS5CPkmlSA3Ip9S0tK?=
 =?us-ascii?Q?xKoKV1/hgb9SIHiSJpq9IpAJECAmiZ/hq8Q2/Rk2Gl6KMBDZBLyiWwcyP1VM?=
 =?us-ascii?Q?tO6VAazJb4Zte50wL5nVUIo74QhGmguwNMMWREp0k15dfFOG1+9KNiNmtcic?=
 =?us-ascii?Q?NXMXhr8k6t61GHQ71VTVEx1BygkhGvCQJpVLxmfAEMFm8hm+9k/8lZ9EXtSF?=
 =?us-ascii?Q?NpNY/Cdzsts8uFB4BiQLwam7W3bQjRgW21JOPBuCMfUJK9U0x9aPToydQy6T?=
 =?us-ascii?Q?lfLlhOMF0V+M7+hUVgQKMKxX6ZcQMG3OO6h1u2GIbInGBs+mmNE71y7rtxTV?=
 =?us-ascii?Q?0xwMbIbmW65TmR2J6U4ni07LKMqWLvZ6sdOxha4qKYycHoxs489M4NkuwUWx?=
 =?us-ascii?Q?KucXCYO37FCL22pm2jN5oX30KLVfY4l6SAFSFQXMBJhvqWwHAvjhhiAPUdab?=
 =?us-ascii?Q?xThdIirs/IpbL9DljJ290jB9smc6yM6mFWiZBu79lrL9FllBoyfOMnBl97X2?=
 =?us-ascii?Q?+xqYCisXv5ZPnjztmIDzetGVeZ9J4zEZgxVOzwcKplGVPtTKTIo+RBAPrkGa?=
 =?us-ascii?Q?IpbwoCrp5DfHPb7Z61Gc6dzPjO4GD00YsJJGkLzeS7Woc67jKUbsAo3oS7zo?=
 =?us-ascii?Q?nlFRBG/NQf1TyCSQzjnsqoWTVzcoFpM9J5vf4hOb2mdIH4dvVPtj+mIf64G1?=
 =?us-ascii?Q?/pibRQC5WT6Nn4ipknFIkuljVEUHl3i5ZjpM/y8CheIUI/Vg/VNz6afE30SD?=
 =?us-ascii?Q?u2F6zQQNJnWLF3PqNpmUXT+97A1kFFRqsOYLvZNPR61RTNW1t4VMeiXvmK3B?=
 =?us-ascii?Q?6lK/MZs1TCIydO9mtazTiH7Saa7wruHKvgm/AdjBC0jqshL6EjreXjdy1AIV?=
 =?us-ascii?Q?dhX/Cl74LBf/kVfbekfUHodiYX8J8MSAQvz+P/MNKfQeisXovflyl6RSHmEs?=
 =?us-ascii?Q?JnO6bmYzL5LPlYRINL7F6nI/fWJMyg7rlvJ/3edBTXb9GKSQ0IuOHmsuqcuJ?=
 =?us-ascii?Q?9sTefb3ftGyfZS8yyOl7A14QCGbZRaSVhgQygfu6RWG+RLkuCLwodsETqLlN?=
 =?us-ascii?Q?SJkOhxn9/5Zx6BHbLMODk6Aqi3mVHUVpVzikB1vYQalP/udusFcQ2cpujqcU?=
 =?us-ascii?Q?x5wK0weVAyjY3DGh7BefQV7474ZGPO0KQjraaVybXSh7plR68NY8NBJvfRLB?=
 =?us-ascii?Q?epE8z54kySCXb8rJ2C+ytNHhrZC6pyZUJUBnrALUodxT9wPzKamcJg8ihkFc?=
 =?us-ascii?Q?5cjb5N4GOzIEDhaV2Y3OAz5/k9vDLCBxpo/UdzgBfuHYX0ZC5IpJ6Re1vi2m?=
 =?us-ascii?Q?YehWVr/0sCv4OSPuzMbwsh9B/x7jO1OWoRMKm3fMy1FiNOgg3332z/GhYc3W?=
 =?us-ascii?Q?F5/8fJB6KOCHdP0eHtZQsZA=3D?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c68b2dd3-cc06-4ce5-106e-08d997e69049
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1340.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 18:37:57.1144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5X3njgP7bzT/tgAlCUZmAUT5hb7hNv14EMoL+nPrxQFzMoofeOF2cO5lMJgusWGpBI9eIdNCQNxzUcmAiF5ZzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB2105
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The existing code doesn't allow setting the number of queues while the
NIC is down.

Update the ethtool handler functions to support setting the number of
queues while the NIC is at down state.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 19 +++++++++----------
 .../ethernet/microsoft/mana/mana_ethtool.c    |  3 ---
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index d65697c239c8..ef95f4017c6d 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1667,24 +1667,23 @@ int mana_attach(struct net_device *ndev)
 	if (err)
 		return err;
 
-	err = mana_alloc_queues(ndev);
-	if (err) {
-		kfree(apc->rxqs);
-		apc->rxqs = NULL;
-		return err;
+	if (apc->port_st_save) {
+		err = mana_alloc_queues(ndev);
+		if (err) {
+			mana_cleanup_port_context(apc);
+			return err;
+		}
 	}
 
-	netif_device_attach(ndev);
-
 	apc->port_is_up = apc->port_st_save;
 
 	/* Ensure port state updated before txq state */
 	smp_wmb();
 
-	if (apc->port_is_up) {
+	if (apc->port_is_up)
 		netif_carrier_on(ndev);
-		netif_tx_wake_all_queues(ndev);
-	}
+
+	netif_device_attach(ndev);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index 7e74339f39ae..c3c81ae3fafd 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -211,9 +211,6 @@ static int mana_set_channels(struct net_device *ndev,
 	unsigned int old_count = apc->num_queues;
 	int err, err2;
 
-	if (!apc->port_is_up)
-		return -EOPNOTSUPP;
-
 	err = mana_detach(ndev, false);
 	if (err) {
 		netdev_err(ndev, "mana_detach failed: %d\n", err);
-- 
2.25.1

