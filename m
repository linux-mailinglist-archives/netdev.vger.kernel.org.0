Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF75493016
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 22:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349562AbiARVnN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 16:43:13 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:7724 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349558AbiARVmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 16:42:49 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20ILYMws026521;
        Tue, 18 Jan 2022 16:42:31 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2057.outbound.protection.outlook.com [104.47.60.57])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dnapfs2m7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 16:42:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KvX93i8fQNMxilP/tTbGeRKGN3NP6XZTfvSJKZHULPIandp0NJMg6B+W5M0LFUaF5aSpch1sioQ24sGA1yTEbVnIcyzXVttAZOVgPQn9o6qNh4mqWCgdDhSY5OOxNUcQDOIdAo5whUUTqG+vbvdzjkCLwqOI1hv4MRZBEAqDLqV9mzV/0FraP+e85NXuaPh6O4CgpwDbT6G/M+jxLy/9T/YlUyNdWWCOqU423SBlSfLlMEPNdy1sN+S4DDW9TnYVFD/linElxuQbh9OF6P8nCzSj+lG/S5UZvgmbYhghSpYUmVvoMePbjhOCD13kools2zS6Fcd9sd8W63wNh+OZBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ym7UxiJL8GHTQIM+r/8L6/nXNXOWKMgJrxtKIjyV5eI=;
 b=P5v+5jXj5Vtj7IkBG23dmejriByLCQuh+xK1ZiS9cwxdk3vC9vC+MavUMlWdHN7RQ7mc7yAyfX3n2YiFNhgV3ppm8CP4v+Qj9OZTThtF7zxEyEe17w/6BPoJSZj3SDQ7CvaijtXnV7V8NfIi6l+lf4KLFhFiFSTtFbKLo+OenQdeNCWiR5vfe20kpS5iVkUnygIuFz/G5jRfL1BTHnQAlkHYDx8mJmlHL7U+eKxpIULOHVLaEB0b4sUNI1Ev7Mid2DCEoqn3V/X2H0/fs4/FPwzjGdXxUmu6cLx9n3TkB7MleORimFaqscsrh4gJcTTvUu/qe16bk/88R53tAkrYzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ym7UxiJL8GHTQIM+r/8L6/nXNXOWKMgJrxtKIjyV5eI=;
 b=rUxlftdMVA23ewSyelbIeYShIxqlPlPiKGsK0GdWobqOnKo+f8QUr30y7pAXpyBztC+4QfbrH0cG1GTkGSYTgUsINTmeBfZFlifefcTq35e9WLNmBhWxrEk1UKhLE0Jr0LGe5FRXxsmlpXPrTwpbNYNtzqle9yKnZHdP7NT2RPw=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT2PR01MB6579.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Tue, 18 Jan
 2022 21:42:30 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 21:42:30 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        michal.simek@xilinx.com, daniel@iogearbox.net, andrew@lunn.ch,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net v3 7/9] net: axienet: fix number of TX ring slots for available check
Date:   Tue, 18 Jan 2022 15:41:30 -0600
Message-Id: <20220118214132.357349-8-robert.hancock@calian.com>
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
X-MS-Office365-Filtering-Correlation-Id: 15b87ab2-5c43-45ff-3017-08d9dacb6ded
X-MS-TrafficTypeDiagnostic: YT2PR01MB6579:EE_
X-Microsoft-Antispam-PRVS: <YT2PR01MB6579F58A6AE6DEEBCE039B0CEC589@YT2PR01MB6579.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NVkfihZqk5zjx7Rc+den7RNRpGufvN7rVzLTcrtK7/HnhzbtEL3BXfu8WRfXiHePP0eDiMsFp/qJOndTZ8TMY4qZNSHMUjxvOQj/Kn90AMUr+Lhg0EkTNVTCH2dYGabMe6/Lz4Rw2rtFgPJYsbdxMBJFJ0XSwePTXJV86rrlM7QUAha5WUvrSpzxCtqWn6LR20wSTcECjGJVJfB2VOWw3FL8Ry2/2ymNKYqMDmq1oOxKgkAwsjUdvJTExhsBM/76/ZZYEpyDScNTLpdxuaoQbyQVb6riWf+oXbB706/w/e0JPP7LshzVfmARwjV/LpmUX+fZLUd9La2qtLbPCc822d0ioU6nSyS3ZR8FXwvtgo18nG0re9FMPHh+pKM1g2uicKH/aAhd1jOkiRG/ffnA7PcfYz18oRErklJzjm0TDyGljv0JhQd4z1OciCMcIDKscXvE0PEH5M/elchCRWeRt1+CYQUEvER1mRQtKvKTt5QAT/S/YeepUgOEY0/oZ9Yp+J1lhGmYi1QZuPCY4KG2INz9LF5rWV1K1iCR21bZyZb6b4sA0beGjx9XAoMptRqVvphX8LnbSjifu0cMvV6T3dCdJM+2IrUDE3+VFoAWY+bfzYLOaP/Uyao/032Jhd3dGdO25aH6ZwDs79RlpzwMrNRa7IoNm7qK4MC++8JbB01FOd60NPeJ2zqhMP2swc96BX9j5JNk/Bp6UrXQDhJsMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(5660300002)(2906002)(66556008)(4326008)(66946007)(86362001)(6486002)(44832011)(316002)(52116002)(6512007)(1076003)(83380400001)(26005)(6506007)(107886003)(6916009)(508600001)(38350700002)(8936002)(186003)(2616005)(38100700002)(36756003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MODuPpuLeKRbydfI5hbOKTZ0JvS13nvCH9iIeBzG8mJ/j1rQGgJByfoOkXmV?=
 =?us-ascii?Q?yShQcdokUUSKAHm5KE2wqH72E757aaGbohBzfVbS3Y9GMsYJJWyoRrs3XJys?=
 =?us-ascii?Q?/13tO2dB5+v18x9Oj+anOSmIXwqfdXHOw34vTBGbz5n6okGIzKWR/71HXh6L?=
 =?us-ascii?Q?OD0Q3PEDDC2Wl6afWAjsWnLc7pXsNMzzhlA8426UC64/OnlWNTvy7AWiGqO7?=
 =?us-ascii?Q?TeQAV66HGxXf2cLSkAOJcRZmfuR7lxXXuYXalBZYEMB7um/KEyUFhYvdDCIS?=
 =?us-ascii?Q?2fFZfres4DL85HNIyqSrAFSP2Aqhjhci0OzDGf42DlGKB6jxK0dQ/A4XsC1o?=
 =?us-ascii?Q?rOEPHX+O62uimoSnPsj8CcZHakY/PxW2AreqmBc113QQ5MKdqkdaHFvANs8u?=
 =?us-ascii?Q?eC2z6+KY2FGtmRrYQtG+mWYck70E+bjmKpBtSfdhxH8xG4BZLd8sYn8eYutj?=
 =?us-ascii?Q?kEZ+CYJp7UDXLrfSVA8qFH9JVULz6EfzbgnxZd1VzG1vEXNGNzNF2v6vwjr4?=
 =?us-ascii?Q?DTFO8DugmhlZA1ZqBEuSmQZXdG7jOHQupPQSOcIimMPW4edQsxemMZdjHqtD?=
 =?us-ascii?Q?H5MBYPQJNypJKVVuk1nzo5wSsF32EmxE0wj/vTQ/SjaqgMwApqnHAOAUO7hr?=
 =?us-ascii?Q?Wd7UAzzGwWoUGMBpNI2Do7RcMMF4DQE+oJSNukDx8HmwDSzFNiQ11ho+lXdW?=
 =?us-ascii?Q?kCrQd0CNiUkM5TKSHZVnamVKzAB03CpZCjqtxL/CQhc4EaCJzvpDTqWCi7Lz?=
 =?us-ascii?Q?j38oRhUOd0pxLSzf1FK2ieO3ymFlJVIr5psO22c1cB8xNkS7wm3vD0LQaGla?=
 =?us-ascii?Q?Hd0Z+sEo7QRgyycTuwblIsva3Ro0g735ArWTxcGhMkIUL/YLr4lDnG/Yd0hc?=
 =?us-ascii?Q?DtBp6o5XlOm8xUAzkNQQFTX0rGicl+g4VEfl10FlGopiNebfXms89H3QRbRW?=
 =?us-ascii?Q?tRgXr9g8NNoH2e+Igtxc0ZitrLsr5JAhASU3XEQpqiwA7CmfovD7wJQHDUbb?=
 =?us-ascii?Q?DdF8KhMB1lPYzUqUSWpY1XryonxZCC6jZ39g+C6d/ak6EyhASlqLWZFwswpV?=
 =?us-ascii?Q?1gsmx4hh6kUZE8f9+uZ/2NBdqGFm8P3PCY/KLlrjcmVouldD/CZR6oOB6/Vo?=
 =?us-ascii?Q?8uUlWAsRLsK4tzkUFHc3/IjtwGV3t1TIIVmE5Zxd6AG46nnsMbQZnlD8pIMq?=
 =?us-ascii?Q?hRodCzKgARJ0AmHgNVAz0NMcgeSlolcWf0shOb3xkPpwb1ON8xLWLxOeLjQA?=
 =?us-ascii?Q?n8sF/Y4YCTtegxPaFSOdOtcrRcZBi2k+QL0rBk/uCwgEy+VOWVjKe/6l4KW1?=
 =?us-ascii?Q?0hCOammyftNl/HSprtFFfTVSYIqDJHMCSpjNKIWDk7YfsQT72drrVEHIgp0o?=
 =?us-ascii?Q?xOdHmcR9UCqzKYG/tfT5JTABE1s8x4Y+jei3QMMp5Jb+nH6xixlUsdDER5OQ?=
 =?us-ascii?Q?1mKu6R7PUre0plAi/2+3P2Q513M+jIzfsbp+yxxzfasdF+XF1uUeg7nNMLLy?=
 =?us-ascii?Q?cdTIUmMMFeH2qKAPbzo4o4LjlA/n8q8mqlZ0Bc4aOijIn8ZBg6/G4X5otHL3?=
 =?us-ascii?Q?X/H+M7lzVrgAUzHlw7VyxhMI1rfTzTL7TMTIDq1SFQUqw1CsjHlsh4n9+AY0?=
 =?us-ascii?Q?j3fRglnjWhz8vOTJF46hah/90/181hTTw+kUFx/QRaB83Q23d8z2QIokQX9s?=
 =?us-ascii?Q?BzNUwWYQtqOpwNePf2mOHAnsddI=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15b87ab2-5c43-45ff-3017-08d9dacb6ded
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 21:42:30.8050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c+1AD5fL8MaTdM0AYFohlzydb1R7i+5lQOl8nC9lpcGmGkt2wTKMtoFsuGXST3vIypU0491Nm74L8E+tWVckYsblrvGMF5hmEY/sqw9X0EA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB6579
X-Proofpoint-GUID: tfqPoFqcrTADtGw_yug-8OptVl6QHi76
X-Proofpoint-ORIG-GUID: tfqPoFqcrTADtGw_yug-8OptVl6QHi76
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_05,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxlogscore=914 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 spamscore=0 mlxscore=0 malwarescore=0 impostorscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180122
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The check for the number of available TX ring slots was off by 1 since a
slot is required for the skb header as well as each fragment. This could
result in overwriting a TX ring slot that was still in use.

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 85fe2b3bd37a..8dc9e92e05d2 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -747,7 +747,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	num_frag = skb_shinfo(skb)->nr_frags;
 	cur_p = &lp->tx_bd_v[lp->tx_bd_tail];
 
-	if (axienet_check_tx_bd_space(lp, num_frag)) {
+	if (axienet_check_tx_bd_space(lp, num_frag + 1)) {
 		if (netif_queue_stopped(ndev))
 			return NETDEV_TX_BUSY;
 
@@ -757,7 +757,7 @@ axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		smp_mb();
 
 		/* Space might have just been freed - check again */
-		if (axienet_check_tx_bd_space(lp, num_frag))
+		if (axienet_check_tx_bd_space(lp, num_frag + 1))
 			return NETDEV_TX_BUSY;
 
 		netif_wake_queue(ndev);
-- 
2.31.1

