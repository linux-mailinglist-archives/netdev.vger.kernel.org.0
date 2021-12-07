Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A30246BBE4
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 13:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbhLGM72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 07:59:28 -0500
Received: from mail-sgaapc01on2100.outbound.protection.outlook.com ([40.107.215.100]:51424
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231905AbhLGM70 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 07:59:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n3Dz4h/jhzD0IQ9xASe5Zbnul3tl3vAEdsnDSDZigtrqqT93xryTQAoaRtJvZK3Oq2NSllJ3itSpoNULoqAonPyz+Q0Ku+x/9uo33Snrm82YXp8gK91wOl6+QlZDx2zT2T82VZQ4O39aEx3OCVXg150W854ACe5ddKkb4fy5z3T4PhRPcWpL5dSFqLTPdKvpq+RvGmCOF46W+pM60SWyYCUPeAZHOhD0ovSyMvnoM0yCxoR5ys7nuwLrQJCFzierLHFPzPe6IU9u6XnfYSbg93vqP3ZhPp3zKuKh11is4Bb921joVLHly1O6DXjA/lFW7WpxBdpW79ISZt5G+PHF2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZPJjlQw6/H6quCPEGQYGkHGZkwyW9ciPb4aHOrcZ7lY=;
 b=fZOTGmWCBBwWu/wsAR+jKGEgGw3KYR2ju7cu8vXmyg2IFOgs6tKZuc39qjLKlMBGD4yH2nXxkCpqQfNUFFlvOM3ai9u6xkqZ99rIY5fzXAq8swasbbOfIwMbCsuvuQlP/9Aa2UTCOjkLsGVorWafJzFfYbDILXomADn3xwbi2pcPT2lTZI/gUMjEqKjP2aEyegsCNpTONVY6ko+qlfz5LgEaYgnMmOxrU88zDVfgdZHKI0AFMypr+zffInI+kcpnrHgSpuuMBaHdcDpjZHz4J73dRqQ93ShQE3g2yfZP0H9O0HgQ7zbXX3/EmzpOGgZZqgmJ/5YavpBNR2IQaludCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZPJjlQw6/H6quCPEGQYGkHGZkwyW9ciPb4aHOrcZ7lY=;
 b=Z/rRy/8H4Ci+mmfLgkhCL7nbwmxAqjQAa/V5ZkPbYS2d9fHPbya+6ryPOpgfKGNeyc9wUe++Wfj/qJGFGT3B680Ni8INebrvYxenblE6hr2tldlcJgBVUGB1s0TtUZv6BtJXu5Eb5F6sNsqADsXrhHkBT1OHpbIMcPg4zvUAqIk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by SL2PR06MB3388.apcprd06.prod.outlook.com (2603:1096:100:3c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 12:55:54 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::a0cf:a0e2:ee48:a396]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::a0cf:a0e2:ee48:a396%4]) with mapi id 15.20.4755.021; Tue, 7 Dec 2021
 12:55:54 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] ethernet: fman: add missing put_device() call in fman_port_probe()
Date:   Tue,  7 Dec 2021 04:55:46 -0800
Message-Id: <1638881746-3215-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HKAPR04CA0011.apcprd04.prod.outlook.com
 (2603:1096:203:d0::21) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
Received: from ubuntu.localdomain (103.220.76.181) by HKAPR04CA0011.apcprd04.prod.outlook.com (2603:1096:203:d0::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4755.14 via Frontend Transport; Tue, 7 Dec 2021 12:55:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 320a334e-8880-4dee-c2d7-08d9b980e773
X-MS-TrafficTypeDiagnostic: SL2PR06MB3388:EE_
X-Microsoft-Antispam-PRVS: <SL2PR06MB3388F82171D2B6D2585BFB3FBD6E9@SL2PR06MB3388.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:849;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LOC7+AkrpZuhRzFp2yLty5CO1tG+aGCkNL9trkA48p+ljP9XLcOMHldkRyXn8il0saNp60Hnaw1XAcspgVtpHkdH6eyJ7YdGRbWA8o7tMahYz+rh8n4W0FFns0K1zKbgb71CzPEDzV9Eh7It87irg4feKkaHori97QAdZwOtQDOE6LWMTR472N1Z615BFRMKYnp0AwKC8nCt0Sa14FfxwD0mYfJ9iTB1YgajjtEODrZLk0q53UMvhGVJs+uMhzePa27CF9zBv18GF4AH8/ajzXqYT2PS9iAiySnbs+k9ScbcUiDS6kDTin7EXbOwDt5ZcJjx3Wa8S7YNcZUBbdtOxHuRIbeodhj4dMDjKA80Mk3o8Yb08lKINlq1g74rBkZzs+mS6z3tzPO2RQcXYTx86OyK8+hy6hP+e8qU5eY72t57jVfhy4gBGxLBjm2YGVu4iV2il/4UBJfWgWuBzDeiF/jyywEYyc5CbLqgk79Tn7BS++sOMlG92g7147w6RsrafcfsHtWHD/kizfLVmzLu4nJiISQvhVPAVI7TRviKE7T2kaENs+N/RGhO2NZJ7u98+q1o8S2lUwv6CZNNtfJviw5jJYa+2CyCTJzwXXw25Y9aNFfO0FEEEAxZOxoK9jFymUxfNXBGZYXIrYKOY36Yu7cAxWOk5scYJFEInbjR7ur4b06lfJFFnfZWCdgrDB7UjR1AV5zQfbYs5cCPSkozcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(186003)(956004)(36756003)(5660300002)(38350700002)(83380400001)(107886003)(8676002)(26005)(2616005)(4326008)(6666004)(316002)(6512007)(6506007)(66946007)(6486002)(508600001)(110136005)(66556008)(66476007)(52116002)(86362001)(2906002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RNJFxv3bb4tcRslYux8cUFk2SIGTrX8VoySkAeSLBHX+3ARl6tZVmWIHShVj?=
 =?us-ascii?Q?bzpBdzyykyXbpFfIpH5ih6IvFx1OouwHSrJUZfs3hg2BIizX6fQ382aIH9xC?=
 =?us-ascii?Q?ZI5g0w5vGf3tTnxbDt7EuNlEy1y9hk9XcCw85Xwt/0MkV0yQvr+xoh+jL2lt?=
 =?us-ascii?Q?Nz1iIekVXaD5LMvnrSW59kVMLLD31ryjaEo2/AWcdvrbgRUyaW1umR1O/9V4?=
 =?us-ascii?Q?zl0UdJ0Lv0f2QP5IqbKYEgopX08yf/TnrC2xNS1BlAgbhLFxMRJrMz39ICms?=
 =?us-ascii?Q?lQpttqq78r79I5X5kEKLRzpkVd7V3kc1aIlRZABXavRTmfHPE94ipf45vjJe?=
 =?us-ascii?Q?6fDThSXRQE+JbRJ0rwpsMUvv45Z8VmElhPZg7jclKZDooM1aUYN9FLmSX4LB?=
 =?us-ascii?Q?xlhfmSfGowYH4VL8pHmaHi3lf8BXXtTy/NVow3Gi0AKNcrslW6dEXNfLLR7/?=
 =?us-ascii?Q?K3rttAjjNOa5bxyHmhQUK3jxoltbs4SmtK4FDZsm9PkdfSAGImbK7LJvvxDt?=
 =?us-ascii?Q?QJ0VVXdOGGN/DktWfDmc7jSpg4o1IJk9E+vk2fnVXp7wwhqglg+mbSPThlc8?=
 =?us-ascii?Q?fUcmI/cVILDwFoqDRO5zoN8EIkKMZ9RtLzuyd2TNgdkVnVmUEvf1usc3ayxB?=
 =?us-ascii?Q?o2i7Mc3Ke+hryPQ6UhdvmElMLi45V1wIGIHcHtyQUweStOD9IE1z4VsiCsS7?=
 =?us-ascii?Q?tPfpHN7T59mMSmkuWYuPKUI1KL35NGa/1anECQjChO6fUx4z1nDORSlJlb7a?=
 =?us-ascii?Q?e/RV4CdF9Q1DYNoqk0xOxhVgiXgMBtYIZ7fu6ki/EDw+Jl1oPfrgsMTVzQGt?=
 =?us-ascii?Q?D4Gg67yhKWMQ5biVIrmPMmgxPeknixaiEXvANosDXSK/FA6EP7i0ma3k+tBo?=
 =?us-ascii?Q?WR9CqK+pJerc94RPgUjA2JXOTPs+cg0j/iG5AM0iaQmT82rE+pt1t/XH204f?=
 =?us-ascii?Q?qjGNUQc66teUtpuaNm+M2ZOzsYdksCo9J5oa8o4TScXzX+pCSOzSxgpgV8tX?=
 =?us-ascii?Q?0Q/4uOszXMZsylwbqgeXUoABKBHyNbzbOPFxnpfEjvpl4i6pT4s8QY5ZFxQ/?=
 =?us-ascii?Q?+TWfFdT3ih+Wgszj17TXhcN3/Sf2pdkb13nbzakV13pqwuWVxMHg8s0s4gdx?=
 =?us-ascii?Q?ifRUeJa8ElpeQya3XEY3GrMT0eLYnooU72x6nj9j0yPCW8xkXuK+5POnByJj?=
 =?us-ascii?Q?yVs4/v9J7KRIpVBVfxKFp84m6ipodRmAet/EwhprHUnFHUoUVjyLN47kKSm2?=
 =?us-ascii?Q?/ZQjIL875rwrODAEwydWTl3qbJ9DT3O2uQDQlEfBaSaYDshZVR7sUf91ICbp?=
 =?us-ascii?Q?c9+69PzK0CEXmTJFdlrrEsMvY9RPz2df2m9JXat4ujuOfP9hsZHi00fu46T0?=
 =?us-ascii?Q?XBj0Aa7z7JGZpqyv42hH5ka39PH47lEXJhgl+G7kPUjPSy19ncf1K9Uuvj+M?=
 =?us-ascii?Q?K4rvOnXWn6SGbgprwgk4YpXAGFf/LS59+iJgw76AWCQnNGzA7ytltKYpbmVu?=
 =?us-ascii?Q?2Ev7aIhUKspRfA/Spwy1gtzZLyLpHAbam8AsVd+toWF/5kvl+NFbJlg6c1fN?=
 =?us-ascii?Q?oeLRIUPZ005sLO923q7nhbqAaF4EbrklugJ5Vdfi7XReihSQdbY3ajmN6uPz?=
 =?us-ascii?Q?/XWe3PYiiQBzcHYEyRHSqJ4=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 320a334e-8880-4dee-c2d7-08d9b980e773
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 12:55:54.0909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XmebEItCDjNdcw6MQ69n+XhyhAWv//xjdpBK3ztvytbnfRvnZUoqHl/BXzZJHQZmGXlhCvS4iQ7Ic15i6hyXHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SL2PR06MB3388
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>

of_find_device_by_node() takes a reference to the embedded struct device 
which needs to be dropped when error return.

Add a jump target to fix the exception handling for this 
function implementation.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/net/ethernet/freescale/fman/fman_port.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_port.c b/drivers/net/ethernet/freescale/fman/fman_port.c
index d9baac0..7643c5c
--- a/drivers/net/ethernet/freescale/fman/fman_port.c
+++ b/drivers/net/ethernet/freescale/fman/fman_port.c
@@ -1792,20 +1792,20 @@ static int fman_port_probe(struct platform_device *of_dev)
 	if (!fm_node) {
 		dev_err(port->dev, "%s: of_get_parent() failed\n", __func__);
 		err = -ENODEV;
-		goto return_err;
+		goto return_of_node_put;
 	}
 
 	fm_pdev = of_find_device_by_node(fm_node);
 	of_node_put(fm_node);
 	if (!fm_pdev) {
 		err = -EINVAL;
-		goto return_err;
+		goto return_of_node_put;
 	}
 
 	fman = dev_get_drvdata(&fm_pdev->dev);
 	if (!fman) {
 		err = -EINVAL;
-		goto return_err;
+		goto return_of_put_device;
 	}
 
 	err = of_property_read_u32(port_node, "cell-index", &val);
@@ -1813,7 +1813,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 		dev_err(port->dev, "%s: reading cell-index for %pOF failed\n",
 			__func__, port_node);
 		err = -EINVAL;
-		goto return_err;
+		goto return_of_put_device;
 	}
 	port_id = (u8)val;
 	port->dts_params.id = port_id;
@@ -1847,7 +1847,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 	}  else {
 		dev_err(port->dev, "%s: Illegal port type\n", __func__);
 		err = -EINVAL;
-		goto return_err;
+		goto return_of_put_device;
 	}
 
 	port->dts_params.type = port_type;
@@ -1861,7 +1861,7 @@ static int fman_port_probe(struct platform_device *of_dev)
 			dev_err(port->dev, "%s: incorrect qman-channel-id\n",
 				__func__);
 			err = -EINVAL;
-			goto return_err;
+			goto return_of_put_device;
 		}
 		port->dts_params.qman_channel_id = qman_channel_id;
 	}
@@ -1871,20 +1871,18 @@ static int fman_port_probe(struct platform_device *of_dev)
 		dev_err(port->dev, "%s: of_address_to_resource() failed\n",
 			__func__);
 		err = -ENOMEM;
-		goto return_err;
+		goto return_of_put_device;
 	}
 
 	port->dts_params.fman = fman;
 
-	of_node_put(port_node);
-
 	dev_res = __devm_request_region(port->dev, &res, res.start,
 					resource_size(&res), "fman-port");
 	if (!dev_res) {
 		dev_err(port->dev, "%s: __devm_request_region() failed\n",
 			__func__);
 		err = -EINVAL;
-		goto free_port;
+		goto return_of_put_device;
 	}
 
 	port->dts_params.base_addr = devm_ioremap(port->dev, res.start,
@@ -1892,11 +1890,15 @@ static int fman_port_probe(struct platform_device *of_dev)
 	if (!port->dts_params.base_addr)
 		dev_err(port->dev, "%s: devm_ioremap() failed\n", __func__);
 
+	of_node_put(port_node);
+
 	dev_set_drvdata(&of_dev->dev, port);
 
 	return 0;
 
-return_err:
+return_of_put_device:
+	put_device(&fm_pdev->dev);
+return_of_node_put:
 	of_node_put(port_node);
 free_port:
 	kfree(port);
-- 
2.7.4

