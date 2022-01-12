Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912FF48C9EC
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244118AbiALRij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:38:39 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:25934 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240781AbiALRiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:38:24 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CE6ssi020480;
        Wed, 12 Jan 2022 12:38:01 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2053.outbound.protection.outlook.com [104.47.60.53])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj0fcg53m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 12:38:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AqtqD6rdchkvyyGWLAIluSmTB1sZ58Hs8JJ2Y5aSnanV9zoXvxEkTT6oMH1i34bIpjbqAckWsNMspBkk+QsFhm9WV1DYmAKrGi/wSojRfDjYT/0lkk+35F/LdmAWpmFS1R5ij/CdRMCQi7LGV/mEbdtfdn+lcXRQ2IjXdtDK2u0TFo+5AuNQJs54PBsnauBjSjWygxLuFZ2ZwoY1SMp9lMSWIjTjoZbOBd1BHQntyRDUDDonPzoCfIAlmQ8RHAKB+GyhW/k6rpNoGOvkSvoxfR8OIkTwqA4ZGBMWwWwkvVvhtmvzUEJng1HcxybkgzRYg4mJTFjcyEB2ip/E+UK5sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iSV1LcXhDE3eLySVJixtB5wpsPh+VDaIOsTT+RVzZ6Q=;
 b=JrJ+f0FUaqYutxZMlKvgd6GnjKaWeiITGLDqahachIVLjCVmglTeAXqrKMeMYHYXTuuwXlfvfNcLNVlKuQLproFKkmhGGjBIb4oMMXyXnFHT+E1cxQjBqA9O/NaIGgQmi+xBmHYctLnFUxPetnfb6dxTpTFUrV+iTslRo4+NWMZZW2tcstRmr7zTP8WzhIu/7tXYsvOmOqnD7i66qOK4gugfa3ls8ho6GLXhwuhQYaGcNG8+9ysKVhw5EpnFT9g+8xRjR9FFwJ1JIA5dajJ8uXYmKIinQds1xDno3tz1QkwvgHFPlvQFtj9ED/bw0iOFArdfvw4NUSu9Zr//MAv/Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iSV1LcXhDE3eLySVJixtB5wpsPh+VDaIOsTT+RVzZ6Q=;
 b=3NSXsFGnkr8MMm+YLb99FmEHKSwhjwmgKx9sHm3RT/1HaBEGoCnTcGsfsOHLnHirmwuIZhTWKT8IMUS+RHrdBS9s5uJwhavyspszGHBCBQ/pkInE3KBuj8wbnR0OpU6W81xDEcA3XG0i9M0rUOVkzAo9Md000zAEy3kgb9+5QhI=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT2PR01MB5789.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:55::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Wed, 12 Jan
 2022 17:38:00 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 17:38:00 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        michal.simek@xilinx.com, ariane.keller@tik.ee.ethz.ch,
        daniel@iogearbox.net, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net v2 5/9] net: axienet: limit minimum TX ring size
Date:   Wed, 12 Jan 2022 11:36:56 -0600
Message-Id: <20220112173700.873002-6-robert.hancock@calian.com>
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
X-MS-Office365-Filtering-Correlation-Id: 1eb429c6-a7f1-4b1a-ae17-08d9d5f246ed
X-MS-TrafficTypeDiagnostic: YT2PR01MB5789:EE_
X-Microsoft-Antispam-PRVS: <YT2PR01MB578976AA6EC034835C67AB17EC529@YT2PR01MB5789.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IjPLOV9pQpAYv+l83jIuz/6ODiHZKFkGkX/ZnQD8Bp1XNEk8A7QPfzn949P1qJEMGse8RhhKIhHWUwtcte7SKFHVBc2i34q+FtfEpLwn5oFQSx2u+ZRK2SZsKzMUyeTDi2O9eHDFswutrw/M6I9hlFQD0JHmvQnh6N2Ncn6ymPaG6yLUj4ep0T+efE8j18avp1owvyMKADwkfUZVTiRIAqM+HdRk3FqRWSNa9IbOlH+3hVzLIxUiQoMcHf3Yu3l9jgPAxdNTZSS6pI8LFm508SGVnt3BWCUvENulJq5DREw4vNJggogwaksyu1U7PZWM0OQYWfDhpZkkyMvZCwCArw77fekTGY9bczBpPyxvayEt480LzZsaMuj9WTBzvTkQXlYh0vFPOfyQKKvh33roqyLKjVqvBxoGk/X2WmzZzD5Qunxs5Eccw6++p+IsPcn6xcBoFLcES4HqcBbq2TVt5fRReR9BGON9aOyvzoKbsP9DYsGqgGEYv6BzG6O3HZcqnetUttqfcosSPgbadXUsJxZ+kfhu5E0aaX9na4ZBEz9OYYEfkPZSrN/XXaY3P7xiES3Y1QyrNgXAQf/Wj+Cshs88eW7EIqW1Ln32PQpqm3FqPXIu6LU/iMWyr6w8soECsP6OPm9hnVaIaLGOlWUCct0YIBu/GF4WApU5BfOqmMcp8nhahanVlWJ0f2Dyol5BlSWpUHJYyqDH4wMUpnJ1XA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(38100700002)(66556008)(66476007)(5660300002)(38350700002)(44832011)(86362001)(316002)(83380400001)(36756003)(6666004)(2906002)(2616005)(6506007)(8676002)(186003)(6512007)(1076003)(6916009)(4326008)(508600001)(107886003)(8936002)(52116002)(26005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u3+oywEhh4enXqh7jxED1jiaEu3CVqjzTgevJ4+ZAu0H88lzOd7YKbZYJBiH?=
 =?us-ascii?Q?k5dyyZANyjsFudPu/NIowNzM31fDvNqWa3EZozIH8TDVjYBj5LssmzkCbFsW?=
 =?us-ascii?Q?1G6IH0wr0xLn345XJq9ecxRGGoUNk/oUEwFCboplzXNlxBDOSaQFXmyHvhRf?=
 =?us-ascii?Q?gKklRrJUXGbXz2fXjMiSOVsqsfM5Be0s5lgw6pX25qodQBWiOk6sgfpuswDl?=
 =?us-ascii?Q?r+OTzmqdEP9ovIa9JJRP3ARg7dBiy/yaARFKebIh7ZhhksE+ID/xKp5HLO6Z?=
 =?us-ascii?Q?DRK7u+cOTxymR1+NDjYIPcJ1kFGiHtSGPCDiYG7QxOB6b2/PRB/mzpw7m5IN?=
 =?us-ascii?Q?VhXiBmOipA42Fu72IsMku9Cs7iQ4foMomt1xR9fqA4DmdyD9f3rjX3Jt9+6F?=
 =?us-ascii?Q?3nqjgwBFJbozmfYVoE/Pq3EAULkuDsjSZ9FSPS2dHo2Ewwta+OzG3rg6Mqjx?=
 =?us-ascii?Q?3emK9wU69hK2T9zJXjSKRqdV2NtYlIo9h28KOCtJyVySoohPYwUwrcmuM/eW?=
 =?us-ascii?Q?mpXvwOW/xog0S2rQd6UzofNtTFbueao1cYvERlEVVHXgjHwZP1HLxCuLEHWG?=
 =?us-ascii?Q?kwulpurMkiTKl6Ol9m6QaW+9DA/cOyHhLjpfomqoKSevGwGh3q56l/nZ/1B6?=
 =?us-ascii?Q?dMwy3Zr8vWCFPnGOWjHsKrNHCGjKUMLGKLTOEuC+67rE3o3onpjGSgMOeEmq?=
 =?us-ascii?Q?lksXxEuzFqeC2vPxgUiNkyjD5QMbBcx/hkw+Hs/t3zJvTMZzvX6a2DSlEuNF?=
 =?us-ascii?Q?KG4gdj8XDe4SsAudv+7qO2oW5jtW2Crw5sgf+zo/wT8WdJctrW8eYbQa7UFc?=
 =?us-ascii?Q?07wQhpWNEeUYFqy+OhFCMOKq7DybGSuKkl87Ode2jCsUkjFl+dzcCPzgzaKQ?=
 =?us-ascii?Q?fxdyI8OZPQbJVX/toGxx1JiCHxX4ht91igaIRdOgX56fIgUMg62eRr32kXtV?=
 =?us-ascii?Q?mU+Va1EIB6tGbbgSX08CuIgXim9TfR0uXPNxxP2KVA6sQSTWINK74YM3kawQ?=
 =?us-ascii?Q?uAPrKeUsreDMjYx3EvpanPcdY1UldizxESc3UtYsqOnlpPhgVG3zyT6MAUhN?=
 =?us-ascii?Q?/pHo5FsjnP9lIrUmJ6qO4mtQjJ5ttnq3qAug/BAFWIVud96gviFiNrpLC5e/?=
 =?us-ascii?Q?/Yf/D/ss0oZtLLuYUFVFAfMGvsqCgO7yN3Fj7bb9FZQ1efGILCZ4y3LNruQW?=
 =?us-ascii?Q?hmbKcFTnEf0Dn7h1p92QGWaLeuJKxiKdbDWONDEgq2rzFiD9u4XCD+n0hR0J?=
 =?us-ascii?Q?Yvf5u3w3PW+kAYz2wKiIRndKS82VPCojqxoUgR01+oEHp2GhIZsfzSHJtBX1?=
 =?us-ascii?Q?ZRtTug95ID9pk8f/G1PwHWduQdD3kvAprjFc5LWS/9fN13vj02mn98v5DwJw?=
 =?us-ascii?Q?7GvS/Qc/xyo04a8F0R+mAYZhVsZczxWdfegWdcW2OQ3QIZIof2aMOJxbKO4a?=
 =?us-ascii?Q?HmCJpe1DA4QdfOQ60ADnkfwnB9GME8T0zSTFfonzzdaqsqDcEhk728i5WuKB?=
 =?us-ascii?Q?Sr++haydi63puN0PyO3PC/fySWdfgQv5angliBk+jsf2aGqPgumsiiOD8hV5?=
 =?us-ascii?Q?3tA2jN0QcAlMQlqozPoL7NeAI/l8D/rpoyUNBm9FAvBKmANr8IDWz9dmdFtk?=
 =?us-ascii?Q?H1FgUfCXABMGr1AryuYJ/JUgPF0WO2GiEcEtZvBkmJCXEkkkYc83gzBLAyGA?=
 =?us-ascii?Q?Y3T5s17s3yGfZ7q23p/KyZwNReM=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eb429c6-a7f1-4b1a-ae17-08d9d5f246ed
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 17:38:00.0137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ai8KChlMMmgy8VFLLt4OPr9wl8DM+9VPM7KKjnooFP+Vx+VKqbXXRej6ypLi97bL7fr6x1cUdy6duV4+VOwoFXNjUi3Q8gCYk+f8vCYmFPc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB5789
X-Proofpoint-GUID: cNb9QlBRLFrv3rxQFqWWIIgPnG_1HJWr
X-Proofpoint-ORIG-GUID: cNb9QlBRLFrv3rxQFqWWIIgPnG_1HJWr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=710 spamscore=0
 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120107
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver will not work properly if the TX ring size is set to below
MAX_SKB_FRAGS + 1 since it needs to hold at least one full maximally
fragmented packet in the TX ring. Limit setting the ring size to below
this value.

Fixes: 8b09ca823ffb4 ("net: axienet: Make RX/TX ring sizes configurable")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index de8f85175a6c..8a60219d3bfb 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -43,6 +43,7 @@
 /* Descriptors defines for Tx and Rx DMA */
 #define TX_BD_NUM_DEFAULT		64
 #define RX_BD_NUM_DEFAULT		1024
+#define TX_BD_NUM_MIN			(MAX_SKB_FRAGS + 1)
 #define TX_BD_NUM_MAX			4096
 #define RX_BD_NUM_MAX			4096
 
@@ -1389,7 +1390,8 @@ axienet_ethtools_set_ringparam(struct net_device *ndev,
 	if (ering->rx_pending > RX_BD_NUM_MAX ||
 	    ering->rx_mini_pending ||
 	    ering->rx_jumbo_pending ||
-	    ering->rx_pending > TX_BD_NUM_MAX)
+	    ering->tx_pending < TX_BD_NUM_MIN ||
+	    ering->tx_pending > TX_BD_NUM_MAX)
 		return -EINVAL;
 
 	if (netif_running(ndev))
-- 
2.31.1

