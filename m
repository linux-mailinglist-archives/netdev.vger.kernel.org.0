Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1B4493012
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 22:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349578AbiARVmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 16:42:50 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:5760 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349530AbiARVmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 16:42:45 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20IBseYZ030788;
        Tue, 18 Jan 2022 16:42:26 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2057.outbound.protection.outlook.com [104.47.61.57])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dnbdu0rt8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 16:42:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PUOzlbtYhF58+Qab+aLUqlGgn0un1ghNIzcNeEKOdwrMQLMPFrtgr/qEUyIMAn3nvvuhHpemFoN+awZWE1ARLVcx2nqt3SXMmj96jKkU3ZyXfElSa7GiBUCyFMnXQtnzSgcWtBuG8HbjYy1Fq67WdAwGmPjNJHhG3fNhCtkeYhvTl9vfoMbuqt/El0vafPlOHNLbTm6CfDC8MFB7vViV7DTA0vXVe7dedVImyp+XrKP0sSEaH5coORhOYFce0qzKP9O/SuFEChd9qi998LH38OMFJ9kQG4a9VCm8ArLGGJPmbKX7G64i75pMQ35baJSsng4CL7pLEZ+5JUIdW7hWyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jGNGhhklyLWuaoKYoISaXFGAD4aNu9GeM5yAZfXBTFU=;
 b=K+lJdpsM5JYCR+7hR3hv50W1ArugGfVV2G183E8qqMGsYR06Z9yquhU441crKJR7diPgUjL17bzGxJi9kTuqDNja+IDzrE7NQOJbYxBkq2CdNrou/iMX/Mod/kpTNs8gnL0/PyKYYr5Zue7N0o4Z+KAb7+PPO9hp5zT81ETkz1QeOXKzOx3URyq5rvVdMGv6cG8Zme59N/zR2wQahE4gaRHDiVP4v1x7FrCD1AtwxcODKoyL9x1uMAFOsgDVvWZR2xHo0hnry5b5u/wR72nTO3zeth8laEXNJ/KSVnR2effnPsO4cqXTmPtYcymk3YnPca1JN8jz7eFmDi0KsMs0Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jGNGhhklyLWuaoKYoISaXFGAD4aNu9GeM5yAZfXBTFU=;
 b=y47JOmoklVCkMHzVMP1lq5kphvLbNoDPMYs1ZFk/l6IBfcXsPdpTLPouBozUol+KNmp/W5ChbipgW6JPDkPDrPKPAI0yDVSQA4pZ5r6h8HhY5hgOzArQVafQuQCmiZjpNXYMQ12379ZNFU5rNVMeyNTlnu4gVW4ajxX03kV/56g=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT3PR01MB6003.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:68::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Tue, 18 Jan
 2022 21:42:24 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 21:42:24 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        michal.simek@xilinx.com, daniel@iogearbox.net, andrew@lunn.ch,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net v3 2/9] net: axienet: Wait for PhyRstCmplt after core reset
Date:   Tue, 18 Jan 2022 15:41:25 -0600
Message-Id: <20220118214132.357349-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220118214132.357349-1-robert.hancock@calian.com>
References: <20220118214132.357349-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:300:117::19) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c8574f3-1eff-408d-a373-08d9dacb69e7
X-MS-TrafficTypeDiagnostic: YT3PR01MB6003:EE_
X-Microsoft-Antispam-PRVS: <YT3PR01MB6003ABF619C031E00CE7D18FEC589@YT3PR01MB6003.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xUqS16caE0mW4WSBawJdKpX48lCNHpaOQ+UZrkTcqbpGsqWU9qb+kzqYlNiT9Vkg3OTvr33XRSrs0+Uue9RX9AYeJQN/HXHRnha/OV/B4BwKsl8cBvlLEYDc56GpzSFh56XcJVgLW3PaIdZk5HvDoNwT+qMOQtdTvuYX0p7U3vV97f/jy0dDjqeaJR/cSX6OU5onhspQVyLyAteSouKeRiSn1g+zTUf8x9zxWvt+Wqur/uOdpED5OIf7njIRwSVR1z0pbC3qmxWuQcmErycSgmG1yLa2+F6LZUbrnF6EAIMdW8/fyX6VbjGZXDdsEJ5LHBPUrR8zg1vTKGxJl8vrhnDkVAPUcIDUNvq+YDPNb4IYuWqxRyNCpt1ioOTRSpsCHXUMwoMOk0cL8T5P5icf6BbYj8ufpgxi1kZ8CWinZavDgDgSRFpSsSsKTiRlL9Xkq2/Wgx37BI97x9q/R7DixCMS9EtJOopkDK3Tf/GT+g7jycJ4aYN2obC6ocJ1PBJPR4okILyHusqnNp+jbnbMTTGepRT8fOxS3/Avbgs0Fsu/cY0/NOF+nCQikGP6eD2ohjYOtpSKofo8/WJ/ENHcmm+pClZfCkRt67L6HywSomASckfz309iyiCwdJJ3djQUm36k8vOnVjX8MSZA6fqW3x5xVp/QY8nuHcazn3sO/09kDEvKK7sppY1lOIx+/Q4j/6sy6VC5deAwh0N5IZNXcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(1076003)(66556008)(6486002)(86362001)(66476007)(8676002)(38350700002)(83380400001)(186003)(66946007)(6916009)(26005)(2616005)(4326008)(36756003)(508600001)(2906002)(8936002)(38100700002)(52116002)(107886003)(44832011)(6512007)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O3wpY1lQD2oBlcymMHgZIvuPnQ0EwcYwK05BNfuLrKJO0yUtLYL/RilowJIM?=
 =?us-ascii?Q?QyZuh+xyymgms5aQW0WrEJfgwq/nttrm39X0WPcvavTbFJfFwBqCteTn5IG9?=
 =?us-ascii?Q?Amc+4AzU908SUaNuZoetinQmVVGjeuqb8xcv8sdSEeIt/UHv7XtsrUkG7dRS?=
 =?us-ascii?Q?trBvFrbcfBwFVlxGCSHJrRtAODatKt/LbwUY6WAlkW+hbFRalEuifsMw4TSD?=
 =?us-ascii?Q?3Vtp4f/83NqVj2fyOfqPZPLyZfs0MbwnwRqjsj+dwABuixu6K5geLyjRnjO7?=
 =?us-ascii?Q?fayzL0jsrMOQw1dAUcB+y+CHdhzPI6UH1r8hBsYbTb51Fv3ARf9weon5vb/R?=
 =?us-ascii?Q?UdRhN2Ad4KIrsy/kHYzCdYa2MbBP8Q2Xw28Htf9gAv7lVQOeoWUwKm4MJtmv?=
 =?us-ascii?Q?iqIU1fH8doKVp8QIFJIOn5pKJ5GS5xySFpEKBuZj9MMcR5CxvlvnwwJdUYpq?=
 =?us-ascii?Q?DHxMVM+uGWkbTBqRf9Q2kKL2CmbglBmTe3hIPNq5pkFWkvxLgd14Cb7As3KS?=
 =?us-ascii?Q?5CxgzJu7AkgD+Sm8UP7EW/u+8sa58rqQcGWGStZ5hGjWiyWL3lxfx86KUuI7?=
 =?us-ascii?Q?LslpRBk3jGWWOpWm4KsdKb46sU5bgdUTgEkgZQqDrW9Hya9ENeKIzzYY/hAM?=
 =?us-ascii?Q?5I9Bi+ywdbIvSAFsfw2NZXGXrTmYoPeuqmOXpkXHaB2dSGdaGeXV/KGGbgLd?=
 =?us-ascii?Q?aqyrXJDNfjvelMaMFtmWYARVyOUYltoeqQNGPa9Bw5Q3xHbepKOBv89z9TN4?=
 =?us-ascii?Q?YK063nXOobpRcDB4aEbNCIt/ZOayub1UQM+mxrH4eJjakOjHx7G/CfghM5Ab?=
 =?us-ascii?Q?LLRIdqYjf4CHtzQKYdaw8TqU1jHTAre/z3yxNJE9zPTZgJ96xKaO+2Va1vNJ?=
 =?us-ascii?Q?BM79Lx/EJVKDTCA0ndwjAMttT18pjxxBu43H+qzqXW9QQJkEAXGcZ6rVX1xt?=
 =?us-ascii?Q?KGLPJxOeG+3kUsXFHmmuy3t9OXRR/Af0qRIv1Y6XUtB9wgmLgSyETyShcAoc?=
 =?us-ascii?Q?Tp6sVuisGpC8cn3bjXJoPRMdcoUjnUVO0JdOIhvBS/Mq8HrB9y3b8xkIu7M4?=
 =?us-ascii?Q?QBjSCJLM442wfF21uBDCVgM016L3Xo249gTclp0riaLqdKDErc9gRbsJCyTE?=
 =?us-ascii?Q?lXd/yyId4YVYXZNWYD5KeD6nsuWsawEcxcg2mwY2MMGWjdXZjOIjoQT8QIyi?=
 =?us-ascii?Q?7+eB/3hNITZ9Ff7JGdco6GxvyxutgT7rwYTxj1wmkm2mhgELYoICmUVauy78?=
 =?us-ascii?Q?4abtpeptAB0qWiIttL/yaJLMXMSEXIwAtYekDgR/2xgIv4ZhEy+CaeOAcyOE?=
 =?us-ascii?Q?/PKmG3hFQZiDWeGd4+LMM5AP95IJImnrVcV/DJYDzKUjJUVBBJxCldbw8Exw?=
 =?us-ascii?Q?ElbULSv5iGzxWNruxGw8WxFmJ+txibR12rvFfN2U+gd+kIqHgQWdLXqOAKcG?=
 =?us-ascii?Q?KiGTgT3UiUHb5NhIIGnjf3VZD8diEc51gWjL0C503O/llZFZlqb1FOkysO0B?=
 =?us-ascii?Q?j33djlnGltp+ciG6BJ3HyqibWcno1+uUy5/BceBi+yBJQKMxf+XtSnvHIklt?=
 =?us-ascii?Q?YZsfOCI/eTzxLAbqGHOtEmXXBDbqK/lwC5vzNWVOCfYz3ICXyc3dFeJINlfm?=
 =?us-ascii?Q?IUxmsq1Pxn5umKfJsf8LUgIfzQhQafdKeoavIOxbZrhgcaUy2WTlGg/h4+Co?=
 =?us-ascii?Q?D13Uzv0VTF72WtPEjGE2onM62sY=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c8574f3-1eff-408d-a373-08d9dacb69e7
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 21:42:24.1215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uvb7O6asPJUiIt/L0ZDIFBAR2R64ldwPgpN1UxGn67AJCLAu7+h4Hi+/Chjbr9deAS31kP+ChGVYHip5DQSbKbeqL0jZXNUBTjZGDgXTeYw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB6003
X-Proofpoint-ORIG-GUID: HzflXGKrRp9y3xfHpVU2-72JDXdQYPp4
X-Proofpoint-GUID: HzflXGKrRp9y3xfHpVU2-72JDXdQYPp4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_05,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 suspectscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 clxscore=1015 priorityscore=1501 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180122
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When resetting the device, wait for the PhyRstCmplt bit to be set
in the interrupt status register before continuing initialization, to
ensure that the core is actually ready. When using an external PHY, this
also ensures we do not start trying to access the PHY while it is still
in reset. The PHY reset is initiated by the core reset which is
triggered just above, but remains asserted for 5ms after the core is
reset according to the documentation.

The MgtRdy bit could also be waited for, but unfortunately when using
7-series devices, the bit does not appear to work as documented (it
seems to behave as some sort of link state indication and not just an
indication the transceiver is ready) so it can't really be relied on for
this purpose.

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 9c5b24af61fa..3a2d7e8c3f66 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -516,6 +516,16 @@ static int __axienet_device_reset(struct axienet_local *lp)
 		return ret;
 	}
 
+	/* Wait for PhyRstCmplt bit to be set, indicating the PHY reset has finished */
+	ret = read_poll_timeout(axienet_ior, value,
+				value & XAE_INT_PHYRSTCMPLT_MASK,
+				DELAY_OF_ONE_MILLISEC, 50000, false, lp,
+				XAE_IS_OFFSET);
+	if (ret) {
+		dev_err(lp->dev, "%s: timeout waiting for PhyRstCmplt\n", __func__);
+		return ret;
+	}
+
 	return 0;
 }
 
-- 
2.31.1

