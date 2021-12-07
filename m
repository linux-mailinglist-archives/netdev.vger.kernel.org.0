Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6751F46BBE7
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 13:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbhLGM7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 07:59:41 -0500
Received: from mail-sgaapc01on2115.outbound.protection.outlook.com ([40.107.215.115]:34273
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232073AbhLGM7k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 07:59:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EsOaAW/uI3R9AyMV+GVoi3riZd+a6H85GisQdwJHirxm3j4Fqww9iitjUTiLxQ77DDAYBrzIVDlAPZSseV9hazsknxv1KN2un96hw2g1H+f3BAIehmn+6HcVr4djrnD4FEaZ4iF48kkWZhr7Qc3iNLGs1UmWwjOCDYfg0JTq+Kv65XEmXjDWpdP8N0Tzp1K5vEpICRMMZl3y7UX6zby/EdgWCH6purNSq5DvpBkjQOcBBqI4Adp1GmJ1Tz8z9/rThWUlDLxzNujBJYRDv6Lu6kvhvO4pn/h0Iff8KLS/bzR1+lNX/IXaKywJCqpgIQK/CAVbENLvwN2jCEYZ7Wb/iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dg8/Op/AE5/9cHuQjxRJrJu5QeUV/5fk4Pg8X4+WtFM=;
 b=Uqy5D+CYFn+BMiY8qOLvrmApxzmWYFmKBmrMQXZ0Oq5CUuZNp7QLtWDDQoRKj3izu72Tyc13Z2RatHWFviUapuREma5HfLVm0uyRlun/BCXA1DBDH6y0beBiNfiNe3g78p+Vojd14bs6inWfRechOHwU7cnMZMAAmy2zD51lioCCGOq5tWbEncPoU8qZM8nkqWW6Ww0uZeoZ/w7nrvcMF0+GRQnZIQCRYxBOeC+iMzkvN/FzBuyiLJzK9BoOUihol1BeLF+omjRmUevYxXHtUYaKdcM7yQaV+K18XSQARJGncUL7CG4QQyrG3mDaCaUkN/6SvttzyiBcXiY8fjzCBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dg8/Op/AE5/9cHuQjxRJrJu5QeUV/5fk4Pg8X4+WtFM=;
 b=ThnlCVWNUj5GkNU3t1W0Bm+S90LQIv10AS9mzPIRCqaGOEvaZFHqSHDGCWDOcFWP9Ps7uya0a/+EZMG5BkNSINjBP8kyuZYBK4jXZ8NeT13GWLVeSimunuYNG5EEEYNmavBAtxf68pQksk5gVN+OJ/BFwcrBvkkmtch8Ef+vnug=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com (2603:1096:100:37::17)
 by SL2PR06MB3388.apcprd06.prod.outlook.com (2603:1096:100:3c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 12:56:08 +0000
Received: from SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::a0cf:a0e2:ee48:a396]) by SL2PR06MB3082.apcprd06.prod.outlook.com
 ([fe80::a0cf:a0e2:ee48:a396%4]) with mapi id 15.20.4755.021; Tue, 7 Dec 2021
 12:56:08 +0000
From:   Qing Wang <wangqing@vivo.com>
To:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] ethernet: fman: add missing put_device() call in mac_probe()
Date:   Tue,  7 Dec 2021 04:56:00 -0800
Message-Id: <1638881761-3262-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: HKAPR04CA0014.apcprd04.prod.outlook.com
 (2603:1096:203:d0::24) To SL2PR06MB3082.apcprd06.prod.outlook.com
 (2603:1096:100:37::17)
MIME-Version: 1.0
Received: from ubuntu.localdomain (103.220.76.181) by HKAPR04CA0014.apcprd04.prod.outlook.com (2603:1096:203:d0::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4755.16 via Frontend Transport; Tue, 7 Dec 2021 12:56:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62b618fc-2e7b-4ee1-360d-08d9b980efc0
X-MS-TrafficTypeDiagnostic: SL2PR06MB3388:EE_
X-Microsoft-Antispam-PRVS: <SL2PR06MB3388079EE261364377016986BD6E9@SL2PR06MB3388.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5yOaMHiEYJes4qhn86uV+2BYFDFXprZdydMPIR+MqB3IjRF1ZFlvP2GTCI1brFst5BR/aS28SrczBL57RjOW62wdoLYeyPgJsBFIsrewhycFmkeNjVwCe+8OQYU/WV8Zx+761QIscWMnD+DXogmlv2JNtYX9dXGfqTRbc6rje2h4AxnJeQ+QqyTiyJi+CeuhdMyhKuQr3shxSH7zpyt8VZu2fSg+ShRKiB5XTF72xR9wUeOZfBAyZ47q1IjVAuW3ZpzdYy+EtDWUtJvWfKsH03HfD+8kYOPNSFswhx0qgzkH+aigfQYjH3j03heSkspvrEmCOCWwP4SIH62lkWnvxIwG++p9THG56nHXG5Bv1K5phfiTFXLiiT0yet69pxlowbikBIt7zJJ6D62NWAWEUaL+2qfHTzX+wmG8Aq5pPocxJbAaQlnlOihjwnMogYH68DqcRQg/7NIYXIC6F/TqlKlJMXVES0QKTLTCC3feIOjbmAAHO2EUnpwnuD0hEK/240b0uxEyrIirmte7H7Ix0ylVPVtAb1vUqJMeZpzgTGmOQWjeL/IEsqcZ+1432b3P6dC2sY/mCKmYg1JrlvdJBZ+vitObeU/jqrOoJ0hx5lQrioXRTr7Dx4elCDb2W8KwvhnfCsq3fHRLK5j9D5Fgi2O7CBe1j3Mql7hLaPIoJNyyAgrq9sc00uOaKtiCMecKJRafgBMkj9gJHwh5vmgI4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SL2PR06MB3082.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(186003)(956004)(36756003)(5660300002)(38350700002)(83380400001)(107886003)(8676002)(26005)(2616005)(4326008)(6666004)(316002)(6512007)(6506007)(66946007)(6486002)(508600001)(110136005)(66556008)(66476007)(52116002)(86362001)(2906002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BA8nF7isINYaPBztOhfzOJBlPXx3YZ/HnR4DeNhh6DsXGSvoIU378u2IBkeN?=
 =?us-ascii?Q?duixNfVPbOOCky+DJEYnySlz1lKT6vtQdaLWYj/lsyeHtAsjiBxQTTqfNBmp?=
 =?us-ascii?Q?nrw+FXZ7ZZ1IsMM1m37OJ6z1xSnweHHL7P1f9LaNzR5Hy9/eaFmYEc2iXH57?=
 =?us-ascii?Q?wY4FVe3QxL8ftusBr9iUPoxE/XPvzM1DbVKfxt0W4AsDI9jO/ShDMBIQttth?=
 =?us-ascii?Q?GfVCQ0cElsJW68t35DCkpfZB40dyOGBCBPnTC9oBVQbH0aQ9CVeP/a7gXQDW?=
 =?us-ascii?Q?MC8WlNLS2Vz7lDszWTWXj406Pvh2M6Iy7ywObZ1+rYK3SLYioZH5QAi7YGkG?=
 =?us-ascii?Q?1N7H6ZYMKZoPMr9XJwbIq/oK8UW8SYXYm+c9/NfaqCNlvHiC09Wqx4Z/jQw1?=
 =?us-ascii?Q?Aua7J1OUq0GadaJeqPDdrXlI77dfXu9GechuJWbkahDLU7OkDOEJSP7svkV8?=
 =?us-ascii?Q?FLwDsy0Ozk3SCsFWDFlAXxWSJAOZVQSV4VeXyDFGWahDJWJSeyJDFpS4zo2f?=
 =?us-ascii?Q?l9GFazr2dyZyIKpBUZA2TdTruaYR/okwmRUVvYEEhsrR3MPEU4uPOIz503fx?=
 =?us-ascii?Q?ore7vqOcHb3AZiXtg7TT5UeCJxNb+0Ee+gq/+4I+9xy/oz0lI2UCX+15D6g5?=
 =?us-ascii?Q?qd8ub51cdh9WXdMZbAe3guM0pSt06nCSAHuLvqsrBRiBmccDQkg0ZnSkVYbz?=
 =?us-ascii?Q?myEBFaZ+8DYBtHid9d5f9yKeGriY58pXbB9xE6l3Bedpo7k9LVh5QvlEzHTo?=
 =?us-ascii?Q?LB69u3aoHe4dTQfsPjnYe/1AikiM0O0lZNbrdyTIwnakZeJve0fsihFrj6Ph?=
 =?us-ascii?Q?fB9PkQNwtmVhnBlARcSqhIUtTeTLimn6iPx/glqaPzJTAtavVLQQswuvpb9y?=
 =?us-ascii?Q?SYQLTLbIhhxG6SK2amKMqEE5F1M5+4IZLDQfr7KLwwvGAyG8jW0WTZJEGVsc?=
 =?us-ascii?Q?yhkTGZf6Lmw5EMFd7dPAOBDVpdLfQEpzV+iV73SJIbaxi0mH3N5letz6roWz?=
 =?us-ascii?Q?0Wx8OXJ8D5eg30XHSrJw9AmNQD7cGmwh83KaeQHLr2ysGQajEy5S8ZlYJNOU?=
 =?us-ascii?Q?alRtVEm/MOuo3QTvJ6HCjUqXwd2Zpvi0TytT8vh1dUdofVDYJurXmsQRg/eE?=
 =?us-ascii?Q?F5gY5weexpwULck27YtGLuJJY6c8xE5NhZCtNG/WeoeMR7hJvglQ2oRjqeSD?=
 =?us-ascii?Q?J4WXqdDnPSmX5j9X5NLkYDOV/rwjzGKvFCiZDT0211mq9Rf8RYIjs8v44UHl?=
 =?us-ascii?Q?ZxBGDdGFq1CPg45X87XL/rN7QM5FBHbxCRgyM7PIyVC24Kh3+Sr8E2MlWcmD?=
 =?us-ascii?Q?B6Fj2VDO7AOLUzQpPL4jaSONae2ppeJrKkW6e+JIjjtcXuIlc0fZE/ytUAlT?=
 =?us-ascii?Q?I26DjJQpuS2B7hmVyI+oOhgPLOMwESt+dvNOGEzeMTW65OEN48lx3Gf94bAu?=
 =?us-ascii?Q?m8EXVhNd/212adBZmMJ/AV7Q8EB7ecRj/TC4OllGSpfYZUiSZr96xszc6bUS?=
 =?us-ascii?Q?UVWnw7Ztsa5IJZpZFvtAcdO+9m9xBk4mfVIqqBD4//vEmOlA1SMiX26o81E+?=
 =?us-ascii?Q?Gusb8c6KSaLLhSeftw5Rrl9fmpQxGhZGAhKesvKF+8cXyr7BP9078KeiegWW?=
 =?us-ascii?Q?vJuRNEwyiLE8q6E8tYoLdSY=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62b618fc-2e7b-4ee1-360d-08d9b980efc0
X-MS-Exchange-CrossTenant-AuthSource: SL2PR06MB3082.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 12:56:08.0242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vrG5IOmYE7p/JPZh8djQx6Dmo4wvYcClhfMIMS5YmewUjAZi1NACUwziYu0bdTiuGCmX2OI4d2qJFEC6SltN3w==
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
 drivers/net/ethernet/freescale/fman/mac.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index d9fc5c4..5180121
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -668,7 +668,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (err) {
 		dev_err(dev, "failed to read cell-index for %pOF\n", dev_node);
 		err = -EINVAL;
-		goto _return_of_node_put;
+		goto _return_of_put_device;
 	}
 	/* cell-index 0 => FMan id 1 */
 	fman_id = (u8)(val + 1);
@@ -677,7 +677,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (!priv->fman) {
 		dev_err(dev, "fman_bind(%pOF) failed\n", dev_node);
 		err = -ENODEV;
-		goto _return_of_node_put;
+		goto _return_of_put_device;
 	}
 
 	of_node_put(dev_node);
@@ -758,7 +758,7 @@ static int mac_probe(struct platform_device *_of_dev)
 			dev_err(dev, "of_find_device_by_node(%pOF) failed\n",
 				dev_node);
 			err = -EINVAL;
-			goto _return_of_node_put;
+			goto _return_of_put_device;
 		}
 
 		mac_dev->port[i] = fman_port_bind(&of_dev->dev);
@@ -766,7 +766,7 @@ static int mac_probe(struct platform_device *_of_dev)
 			dev_err(dev, "dev_get_drvdata(%pOF) failed\n",
 				dev_node);
 			err = -EINVAL;
-			goto _return_of_node_put;
+			goto _return_of_put_device;
 		}
 		of_node_put(dev_node);
 	}
@@ -863,6 +863,8 @@ static int mac_probe(struct platform_device *_of_dev)
 
 	goto _return;
 
+_return_of_put_device:
+	put_device(&of_dev->dev);
 _return_of_node_put:
 	of_node_put(dev_node);
 _return_of_get_parent:
-- 
2.7.4

