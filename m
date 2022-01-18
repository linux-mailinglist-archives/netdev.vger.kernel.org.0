Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBCB493010
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 22:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349073AbiARVmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 16:42:46 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:4287 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233335AbiARVmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 16:42:44 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20IBe3o5010515;
        Tue, 18 Jan 2022 16:42:24 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2053.outbound.protection.outlook.com [104.47.61.53])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dnbdu0rt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 16:42:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B2P6Xbh+WMFQH/bU0yjn1yo82/mmBQ0hgM7NLU1oovIkNSkFIEs/gvyyPrpqADQpdPHK6JrvFC+3Wjy6ysAgN07AZuIgXQu9Vs9sFQARtjqkKotfO05UHpkXNDSprLlyM+brnEkkB4KUz+svEqLqbWrbTojAjDAGOUkwCIBbX5keu8Na4eWhgJBSFkrCv/5HoxhrlQQa0rAawr3SsDvu8mXHyV20IHGxoka0KSkdVANNj1j2fm61JR5Ph32s5v941fhn14JwbujUMN8uTwEQ+nUKuR18TFaXlbfMAaMxtK5NIMARqZLXLFm7snDfmnZ8FEspnOT5JdRTmZQ3mvV4og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BA8OcEJN8jFwhObwJKNFgblAeWctBAxgqY+UFzsddok=;
 b=ipXyG7y2ymcNbeNfzhLkYRb8vubdz1NldKxIMOy0Dm0h2FyAHm5g4vGzRIlZzcnqJSw/OPQZN+FzuuKfCCu8RCVtMsuuIpWWatoLA54yq+Jpqi2UseuXeG8GEwyf4Mp/48qdPSF3k8beR51Ed7L+CP1efxJ25Pmjs8WtdHI1Udx6ZdmfAsGR0R5+RbR80yt55snzhlu83iuMHVi4AFWXfDuDLbdauZOnqCyP9flHjZOAlegejQmplIw6wC9PuTu4pBc+1qfLXu9kH4ALYjpr7khHwvsZV4OJxko3ldP0MYTFkYv7figE4h1X0e166NwwRFbr1RngHtGBo05wqKUPhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BA8OcEJN8jFwhObwJKNFgblAeWctBAxgqY+UFzsddok=;
 b=xVJWsCcDq8NsrdTpbp/eTn6+AU1mwI/fgJavCoCsCXjIlLoPBb/XblcDcrUT3k4CGUYIZoM5JLn6M9hxSVrO6L6GWIktmR5kPG8DxxwslIDanICxb5oKdeZxTwVN9k4Plc5DLqW4bvjdNVGtj5Lnp5AQe2ZUIolgvXBVpunfaiI=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT2PR01MB6579.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Tue, 18 Jan
 2022 21:42:22 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 21:42:22 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        michal.simek@xilinx.com, daniel@iogearbox.net, andrew@lunn.ch,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net v3 1/9] net: axienet: increase reset timeout
Date:   Tue, 18 Jan 2022 15:41:24 -0600
Message-Id: <20220118214132.357349-2-robert.hancock@calian.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1d37f456-6f18-4d3a-191d-08d9dacb6929
X-MS-TrafficTypeDiagnostic: YT2PR01MB6579:EE_
X-Microsoft-Antispam-PRVS: <YT2PR01MB6579C56D49A37A4883BB9C58EC589@YT2PR01MB6579.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:644;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cHmfhxTk9SLAOEfmjMJFu/L1+DLpRWeAJJVXGiMNEtFzM81vALRaW2Lc6MpxRRLvWBgDDRJCpydRmr8e+8U89keshQUJh4hhVj+6sq6VI7mmNPEH2jVIDbcIgGq19fNzDiZhnyingwSOd1WoRHV6YkKzUaZIN+JAD808WFKbZmzCKHLeSkoVj7p4vqR0ST2oTaEUyUY+qSLscnUUiA67y3e1UrYlq4nI3AV43fd7H3TtOqiX20356qQ2jqXjN87AzLNSuX7nLVlFTsOQSTVgibwHa3MP/YoH47zTRo7NjbTVe32VebKMMgnjXjbuVrqNMVpUH4ob8HQaB9wKLqoARpRpi98qnPw19NWUQraYBlHNJAPR1KfPuRSb6TqbSi6gNu17JkEn30GThJKbaRv7uZ+7na18ENB5OmOREXl/ZLvdGkYaNIvDFo0LsGcLmP5ycedK7fkZQB41WnuDE7CkdLVcEidWKCTHRimqOqrNlNSwl1ncBCOP05iwZHf/WEEMbQxVn2EzRcAefOEOwa/CPc2BeMuYzWZ02OkBQld7huU9N0SMmoxq5R3kcIt57C5efCg46IYJe5tejh8DUQ8CjElFGUlN0tJxk6TO68ZVILPZgPm9g6Sj6n4XP7AUYG2P+gGrWpA5pYrwPXaT07NwYYOL9iy7MjqWe3PEunO1wowUk4ce7lkqbtYygyS0n9ZpGxnhp72D+cPujfNIeJtluw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(5660300002)(2906002)(66556008)(4326008)(66946007)(86362001)(6486002)(44832011)(316002)(52116002)(6512007)(1076003)(83380400001)(26005)(6506007)(107886003)(6916009)(508600001)(38350700002)(8936002)(186003)(2616005)(38100700002)(36756003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FXaj+BG60RUSkQxvmDLyHErkKGUZUa7eFQ5JHRWcBfsUG+VNdvDbRw27+WBF?=
 =?us-ascii?Q?zvrXYzp9tvkN/WCGju8m6rpEYLkwZ0vLcEXIUCRiCSUEnQBtTVSAIEs4/u63?=
 =?us-ascii?Q?y6SvX8p/ds6J6KRVb4zzqflgxWG5alm9x4S0LBACf427PXikIbkJ4aHRuiuD?=
 =?us-ascii?Q?wcA7ECh1xfrTuhtASgAC9hO/p4F5VC9xaI8lwFR1bBrAXvCggdvlRk5j+RIm?=
 =?us-ascii?Q?CnfEZA4T8jswGkGto0DMznPnz2TC9IShs41Xx52Ev1TYYdLJyscwjNtvU+fG?=
 =?us-ascii?Q?FchmEPLFQgSvtoWXJxki0dJvn5j2DSMsp/GJYy2rn4h1R9L3LwFXZf7mdOPa?=
 =?us-ascii?Q?PTXt97aHPkuCA7HBEpf4tBr2ZWGLPaVBsBqN+HD0eZ6dqvSM3qwfvAzVsfeW?=
 =?us-ascii?Q?fw4hqYc6pqYIm/NrUj3NnvS5TeimliRGLQLrQhb9M9WGoVgNJjZCguuf/PXC?=
 =?us-ascii?Q?DilbyHy5PJdlbfyGHlbiM0qgZMkE/unoUaCCB2SCXAsdL1pyzQPi+40Fv4eU?=
 =?us-ascii?Q?2Oyl7gQb+mET59xQUuWy7hgfXMm+ID1mkIuOsb/o/duR8sUHw19LGBWmOdmH?=
 =?us-ascii?Q?S1Kc/k8ZHzeqWDcHPknyGT5n7LtNVrioQgzpcW3CbWn2wkWUrClpNdiJU/9Z?=
 =?us-ascii?Q?MJ2ZWoxhFPYGKAyqbSvMyo03luN1Kkk4h+ZbIea1fbJXyGwAonFumIRGohAw?=
 =?us-ascii?Q?Qmn4dXDAXLhemRAYE4GRjnosRfmpEB7L8Med2g/mWuFBUpjgEwYbCR8C6wy7?=
 =?us-ascii?Q?7Mr2YELjuw3aZ2jRJ2W4b0efKuPWMd1Kaw0UIHJDlUXX0Uhsk+fB4CyTPReU?=
 =?us-ascii?Q?GqhPQzOQAaW6xvg93N1+h0JqpYJ8ziPF6Blpul0Bpls74vvoyssIfBRiGKQZ?=
 =?us-ascii?Q?IFTXNEGv2KoJg1WAh9uslpABQTyaVkrWIp1zc9mgWV4ZCq0E01KjCxKpk1R4?=
 =?us-ascii?Q?ofFx3QIEvgpZLn7IqAdkjn6BnCJ3Wv3X8e6y+x3bq7B+5IevMuFabE17AFvv?=
 =?us-ascii?Q?B92Bff528+DKPQI5Nn6370PNFmSIyHmhSNEnVpedP4/OEngleHNARKP//T1H?=
 =?us-ascii?Q?2rkKlElEPyXWrw0R9D7Ut9ZhLt0PrSbLLeBe6GvXju4Q30dAXwE2MfFzFhWo?=
 =?us-ascii?Q?ONCHpV43leo9bfS1RKpRHRgW9f/9eyAx78+2/3nQlUAhdDQyD7I/gioo25ND?=
 =?us-ascii?Q?SI0xel8ggGuqCcMaZ4oJ7AH3upGc7HJ2RWKv8Jh2gkzjz3rXIqaVlxpJOHeW?=
 =?us-ascii?Q?KBiG1ZsM3HEimoGLGZvdMqNK4b88gSi41VYj3jSMhwy+QUtYb0fEDv3I8Gwy?=
 =?us-ascii?Q?TM9rzTnnyaVNgZYoyQRApN9ddhYPqSl2H8/nKJ4lZI8xWaY5bvzqZSMjhslV?=
 =?us-ascii?Q?cyqv4LlibiB70GU2v/J4ITi34mg/P9XslBPrr8qMFkKMj9JCz68C5F7ttCo3?=
 =?us-ascii?Q?oFKn7D6E7YXiht6qKO7Qii4/c3BQlFV23eX1Vr+yuKFYuwTTIMm7D9LaJFU0?=
 =?us-ascii?Q?mQFrq6ReV/ODQCl9B68AE0aGDX2rRdJEx8dYZPxFJLUBQayo0ebteDstHzAt?=
 =?us-ascii?Q?Hbh5I/c2+NpxkSnl6E/yf9sd6im5czq/CSWxLlSW7XGCBUoJw8tSuD58iqO4?=
 =?us-ascii?Q?a15aUaEF257CIth9RkhEZUQytNJ0Bko8y19JK4sNd9fgLqygm0aBLOQrr1Yg?=
 =?us-ascii?Q?qpjwMcCgQZTwWsrMIZLSPnPmMNU=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d37f456-6f18-4d3a-191d-08d9dacb6929
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 21:42:22.8090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lARNA7mKDOvMMDL4JeV05HCSS43XExfbnts3BFaFaxyP1vwxNe89jxreArd23RMDIn4H4GN967GTw+846vVuQGCp/Rbvl8MsfkE+aDQMIiA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB6579
X-Proofpoint-ORIG-GUID: S8XxrynGn2aK-szesXZLjeEgFaFaIh91
X-Proofpoint-GUID: S8XxrynGn2aK-szesXZLjeEgFaFaIh91
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

The previous timeout of 1ms was too short to handle some cases where the
core is reset just after the input clocks were started, which will
be introduced in an upcoming patch. Increase the timeout to 50ms. Also
simplify the reset timeout checking to use read_poll_timeout.

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 23ac353b35fe..9c5b24af61fa 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -496,7 +496,8 @@ static void axienet_setoptions(struct net_device *ndev, u32 options)
 
 static int __axienet_device_reset(struct axienet_local *lp)
 {
-	u32 timeout;
+	u32 value;
+	int ret;
 
 	/* Reset Axi DMA. This would reset Axi Ethernet core as well. The reset
 	 * process of Axi DMA takes a while to complete as all pending
@@ -506,15 +507,13 @@ static int __axienet_device_reset(struct axienet_local *lp)
 	 * they both reset the entire DMA core, so only one needs to be used.
 	 */
 	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, XAXIDMA_CR_RESET_MASK);
-	timeout = DELAY_OF_ONE_MILLISEC;
-	while (axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET) &
-				XAXIDMA_CR_RESET_MASK) {
-		udelay(1);
-		if (--timeout == 0) {
-			netdev_err(lp->ndev, "%s: DMA reset timeout!\n",
-				   __func__);
-			return -ETIMEDOUT;
-		}
+	ret = read_poll_timeout(axienet_dma_in32, value,
+				!(value & XAXIDMA_CR_RESET_MASK),
+				DELAY_OF_ONE_MILLISEC, 50000, false, lp,
+				XAXIDMA_TX_CR_OFFSET);
+	if (ret) {
+		dev_err(lp->dev, "%s: DMA reset timeout!\n", __func__);
+		return ret;
 	}
 
 	return 0;
-- 
2.31.1

