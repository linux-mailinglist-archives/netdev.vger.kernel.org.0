Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F056848C9EA
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241684AbiALRi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:38:29 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:6309 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240545AbiALRiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:38:23 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CGTfCs011851;
        Wed, 12 Jan 2022 12:37:57 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2058.outbound.protection.outlook.com [104.47.61.58])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj2j2g1au-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 12:37:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=noKYD8pso7qyK7ODS03EVwyoCLwxwvB/ufuVQojvD46sT44sB3ujuMUo/68ssNB3lcd3aSmf2P6mnySmUxWPqwfQrP7dU5R6FdnUu5Y8OBS1gXGSKD1fuQQP028b1RKUpGR53Ze/AbcgIFcl7HA8wvV350Dtmfn7Q0CHjaSBxvxDXQKC5cx7xm5jFHROKqpKQfBwj9Y67ZZ2+jnmZnZ5h+BI+lUvhvuVsYd2xyfAld1Y97r76UxEmyGWx5QmckcpzV15g9qdYgsItO6s5w8eR+53/MnuER2Agv1HT9SwQutcZmkEeE+j06tfDdYLEayPN7JKCB/QBA+sYei8fZyKDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UvvdgNfndhGbQgF/mjpBGV6NrF31vEvz+1qAA7Mq0aU=;
 b=hxVfdqZ791ykMkrSnrAhB1CbMTJM+KTCSLjBVhxbBubv4UUVhcQ3GPO1i2Br6+2uk5gqlJ4Z7mm3lcsmCa5N4JduICztdocX8L/NT8le2UjVQo5xMGx3Kll73BOhhliF5nnJ3kQ13ZQdM1vfkPKP0oo6Ugnw4aVh7uILADgCC/3vBt0aycLJT9+EfiCw0dVgfejsmtxHj6sv4zi4TqZ+ZN/e/mXmMuqVToIPfHZite242gWctzsLIKgvWtN6fLDvWRZn/0o4S3cPN0fpNlEdsv9UCT7kDzpVgOhCX50p6CwFzXFVeK33N6gTx5GhxWsQlyWh7C1+QFhP4l+J4a9B6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UvvdgNfndhGbQgF/mjpBGV6NrF31vEvz+1qAA7Mq0aU=;
 b=XTfeSEUN0di1bP2fQvrPflUy2yogjp4pyz/CJnziOaP/riJXsvZY5xA8qKnPyO+kGjaQ9mxVUDVEEYhm+Dj2zCasBKfGvTi2bNcEgNaotYsNc2jNJfVODqVuf56wBoGW3rUvd7CN9WpJAdGYQZy+ziyqms5qAWPLacZqr/joYq4=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT2PR01MB5789.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:55::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Wed, 12 Jan
 2022 17:37:56 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 17:37:56 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        michal.simek@xilinx.com, ariane.keller@tik.ee.ethz.ch,
        daniel@iogearbox.net, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net v2 2/9] net: axienet: Wait for PhyRstCmplt after core reset
Date:   Wed, 12 Jan 2022 11:36:53 -0600
Message-Id: <20220112173700.873002-3-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220112173700.873002-1-robert.hancock@calian.com>
References: <20220112173700.873002-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO2PR05CA0061.namprd05.prod.outlook.com
 (2603:10b6:102:2::29) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f76000e5-47c4-4efc-368f-08d9d5f244a7
X-MS-TrafficTypeDiagnostic: YT2PR01MB5789:EE_
X-Microsoft-Antispam-PRVS: <YT2PR01MB578940720C18EA9518BB3347EC529@YT2PR01MB5789.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gtpRKDn3eybnjNIu9MWJrLxqIHOxHomDdRI3GEomrZauoZuhgge9qnl7eFeiOSnrZntKzqR+M/jTLuPOapsmDGvDpwnu/40KRVjlbxPQLTxgAPGl+Hb1CmsijyRa8bv6YSKEfTjt/WcbneWR5KDedGRd4FAZZ+Xm4NS3Thh4skvhQlwCrfPA/rTvBrEJeCbuR/GP4XO+D0gqiEIFBnGrjuIyOQGbf1Gh2zxK6gJOqJ22dGbnhgU93JI+cdbA+1UDF+Y7r/266bu6F2GHFy2lh9xjJLPW5BmhpBtK14bBa4gN3ZlbslKnMfjVUvcUuBQ0GqNioVBcM/+0liF9+fgTfu4RGpkdcF3lN9Hs3O8+8z3rcV/Z5uHD0n7CtLbz9DaUFklRk5pVZCnsWiUZL0qd/xZ/nUPGDRopmkmaUNvAfAhSKRFWsdgHuacguVu4ifT1MjxQu4+x6fAHjlhRlV7x4o17lB3A0bmYrBs4kESfqT4k+LpeH7nc5pCxm/Xj2adiUg+A4uG367iQ1NNemHQDbPTqemODCf3b/0GRIN3ZTTpDD1EsaPBzLHM546X4dh1hYBE0/xJrxAY/J0Pf9qtItdGEfj1P4yxUgdFpdMIkMETBkBik9R+VjTITonEdVMKFDjJtrEzbIGqvmc+SYrY7aiItRmUVU4MwJA48d2ToClFdbqcDV8RMJ3wrFBWsTqs/FiyDUYZnX4sMdpjaR5lzVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(38100700002)(66556008)(66476007)(5660300002)(38350700002)(44832011)(86362001)(316002)(36756003)(6666004)(2906002)(2616005)(6506007)(8676002)(186003)(6512007)(1076003)(6916009)(4326008)(508600001)(107886003)(8936002)(52116002)(26005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qT1Z82QWrE0VyuSnC7Fhj1H2yGgOhlNl8+mGQUeA8EzyBWLLpdBLTupTAR1M?=
 =?us-ascii?Q?hIlgTeEjeo6g3qN6x0UdKuDaqdV6EZfq3SNkD2abQ7xTL76PyzTcFCi0A+z5?=
 =?us-ascii?Q?rG9S4wslX3c9Qr5P+osu2yLaMXs719r7wZzWCrSaLoZ+pTkhhbUV+5qeEO8L?=
 =?us-ascii?Q?3WkH94WanF8z19YBAnxKnUTl21ZLXjrFhfR1W0nunJ6nX9FZWGnlNsMHgbXh?=
 =?us-ascii?Q?wudFoKbJ58Mj3OJ+QTyHXnI7S0/fmcFdTR5yFpxha5RdrlVzqD+RKvR/Fvm2?=
 =?us-ascii?Q?kKxAzqWuP+ly78cyV+8+aMYXz1/KVB8Mq8TSYh8n47KWuWEZKhet3cDXbtcK?=
 =?us-ascii?Q?54hRZpb/1zXpjWOx1NGfwxx1sdkg5aTX/XK8+lNlqdVPhnUtpQPSv02ccCDz?=
 =?us-ascii?Q?HiX0UksuqhsDZwBlWB7zt5FmgO4iV6lRl197LqJpgfYyfBB5rpRz5SUxaLeA?=
 =?us-ascii?Q?X8muvvptfZm/Y5tfr8xOjulJaxq1/yJ0bFHz34Ymo2gLspeFJqQd1couVGMr?=
 =?us-ascii?Q?m3j/ihsYOFDDlXQnecY1quC85Sx2K4rrsJLfWTuWcPKJbYY7VVFBySxO9/P+?=
 =?us-ascii?Q?BL+s1CfuI1e2AvezR/xdjTXXSF1ap0bs7cDOY0CNERklTJEgKudoVJH6a5h0?=
 =?us-ascii?Q?bsXI84WPqA4krFbiC/e1jzWnL+Yqeo63OHL+kaIS1q/ej8JsxLR/d0mmCH4C?=
 =?us-ascii?Q?nPW+sJU/D9n98o/5WyVdQeA/i8g7kFMJcIMTuYfZPhF9EVbALG71tlWYk1uF?=
 =?us-ascii?Q?7X2OD6kly4SAnkv/g061Udzt1qAbZiDrS3u+TotLVrv+G5xP0PqdPghESGCG?=
 =?us-ascii?Q?6loewStf8lDpciwZTTF8R7W26HWmGPghPSmK/myDcntU0cPsIb7Jq6ORpIV1?=
 =?us-ascii?Q?o4WbG+grxLdnZDobrdErh62Iw2BhkwuxAwVwLNXtg9USXtK3uY1uWW0GNk6D?=
 =?us-ascii?Q?MVxfmJcMNQunQjpM2WlxKsSn05YFpKuWp7mfOklLMsEl3GFgwxQX044KlN2A?=
 =?us-ascii?Q?6UFQEXzuFBotWD7efwXa6bqA5DDLvCXQI3n1OTyQDjNMqebMRcDrYuGDr3mL?=
 =?us-ascii?Q?vNE3Ql/jayUBbMJhFF8PxUxzyicFgNUsMsyCnDWhr2iYcgfCscRmAykEazeK?=
 =?us-ascii?Q?85C+VqpUXKXrklt3j9+VD670yBrSKYZMwtJXYhR/1/ZAy5p02eW/sDfCmK9H?=
 =?us-ascii?Q?vpehGGcuM5dM3Ftr1HaNHF9KBC7G04TuHmaSpZNW23CHyiGEGeFnvoa5IT3s?=
 =?us-ascii?Q?m5IFgLsX6HdYzvncRfWoBEpNzRoykjXN6TNI6amVBRacrxsVV11IflfQbyeO?=
 =?us-ascii?Q?H5GtycN6qiQLNyOU/aG7ySV6dNc0NEuWWfwaFGVjk3kq0TApBkMsnPIoqxAi?=
 =?us-ascii?Q?nmNg1v+ZbrEntVu2ZDt7Q7kikjuJDmKWRpb8al/4syk5a6TyQZ8oWgnICU6j?=
 =?us-ascii?Q?0nT1bqjou0XntODfHjDpWnMOUeFKeBcsZ0XpLDksbDIIaVImTllBSdewaCeM?=
 =?us-ascii?Q?FYcCw/8XV0K+xJzbKQTRea/Ba2SOxBcCRpJ4E4RSOBvtmAOp9L6ocJGNlR3m?=
 =?us-ascii?Q?uCiGnI79dJq2oz9o8GNDqghSHoWAQ9XtuY9wW8HkX7qAiMwt8VisffeW5k3J?=
 =?us-ascii?Q?BzSCXY2MN55TL1xMbrG0kUnpDhnvyruVYQ6HLnp9nemdX9Jpa9/eWj4pYufn?=
 =?us-ascii?Q?ru3buBv/a/cIin7r00xcZLosliQ=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f76000e5-47c4-4efc-368f-08d9d5f244a7
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 17:37:56.1184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RTQ9sIUO8WygmPVSzOtMXaCyzF+fJzdKPFsiOJhwiFxy6nbtXIhMLmLXif3ZHZh/SL5W1L+OXgWj+wqWItjLIUEjnJpTjYphrTBcvy7l8eI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB5789
X-Proofpoint-GUID: DpA0gRcPSQStpIy5ZMkT7b2yrG6OhOJ7
X-Proofpoint-ORIG-GUID: DpA0gRcPSQStpIy5ZMkT7b2yrG6OhOJ7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120107
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When resetting the device, wait for the PhyRstCmplt bit to be set
in the interrupt status register before continuing initialization, to
ensure that the core is actually ready. The MgtRdy bit could also be
waited for, but unfortunately when using 7-series devices, the bit does
not appear to work as documented (it seems to behave as some sort of
link state indication and not just an indication the transceiver is
ready) so it can't really be relied on.

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index f950342f6467..f425a8404a9b 100644
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

