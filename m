Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F253B48B9B3
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 22:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245334AbiAKVeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 16:34:18 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:33144 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233586AbiAKVeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 16:34:17 -0500
X-Greylist: delayed 1174 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jan 2022 16:34:17 EST
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20BBWJUi022122;
        Tue, 11 Jan 2022 16:14:29 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2053.outbound.protection.outlook.com [104.47.61.53])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dgjrs97yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 16:14:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ULXc0hNXTf6wlHqmYKnIqw5oyyfLghNO8ZvaphFh1KFTVRBXPfxpTWYNahW6skm0DVGeLEJbtWCtp57sz3LpkQ6ATi6V9KDN1BwyZjsZihMiCROS3Z1sDAJp2+BiDQDHvnL6caZs+yi8IGYT6Yn3gz5muXD3B9X755Gq12yOHpD//F/3GON93TzlynHQlz5PJUsOn7BIFTGYQxqxGDbtdag6+z3UFwNIQHnjdnCA/sc7iodKP94oyWbpOt8gduIc49KrR2033SXy9gouznqjs5nBnUIUX2dnj2QrKLfnedKwPGDvfSh5OIdJLm0hc0MrazEuvMH3uOLBV0RUuUdH/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a+TIbAiyLyu03wHTsThj7tizrmgbmWb1hG0blISXHGM=;
 b=e88cN7usfp6RdwtfI0YxO3ic3kpD2tfVAjIgnkDXfphCLFleZVLOUmIclCL6QRML4KH1dYRxLNWaJAlJVT9o8kqaoWZQ3YH2tgCijGN2BVXD8qmXClpvUllHiuCAzkVysu93lOMhHYQ5EAx4jnti83zRsi/ttyFM4kxxHw4CGbMFf+5yrHlbWx/YMmG4PXuIr8RhzOxxFNGjujs/FO7RIaJmeQun4KP4jQjk/FYGz/7AsEil9oD76JxnnPbl8lxxsMzp7kmHJrYSr8NFmPVldRkQt/XV2vgsfLZLNWHW4wsqca+0tObEahuFJntFtgL/tIouZaM9Gby4mAHnyyIjLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a+TIbAiyLyu03wHTsThj7tizrmgbmWb1hG0blISXHGM=;
 b=o1SEftv6b/fReCqUloRP8iEABZ16p9YoELKPkxHaj07yyprVsp443OwKRlydhbRbXtfumXWpI1CtZ8p2GRoPWlg91W/kgVAL57YnFVqBFtVHZ+j2TxKL3OYJYW4L3aCbgAxyreXfmbJ5hkZe+LmzbeerRzHc2Ed4sCziSdXbXqs=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT3PR01MB9218.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:a0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.10; Tue, 11 Jan
 2022 21:14:27 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d1f6:d9e4:7cc7:af76]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::d1f6:d9e4:7cc7:af76%5]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 21:14:27 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net 0/7] Xilinx axienet fixes
Date:   Tue, 11 Jan 2022 15:13:51 -0600
Message-Id: <20220111211358.2699350-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR07CA0049.namprd07.prod.outlook.com
 (2603:10b6:610:5b::23) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51cf224d-7d21-4dbb-e999-08d9d5475967
X-MS-TrafficTypeDiagnostic: YT3PR01MB9218:EE_
X-Microsoft-Antispam-PRVS: <YT3PR01MB9218B65A8A0D19B35E67D379EC519@YT3PR01MB9218.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 62PJJHUiWi9tklCvy6Z0N+cDc3ru/0iu6MpJ+N4aOwi6NdhyuTtjytWwWMmho6rzXFPLAwsXYCun6dZw+i2i5gsJ/2t7bsUCe4oLzuy/UwPcaVZFFkM6/jjL4nN1IkCwx4azWJG3CAMfEj4ONdOhHTHPL24Ywa9o3BblcgH9Zq086sABgNt6ADGcEKRlxH0vOjxL5LC7PmbYRvd9WgmsEaq2a8Z8fmIV9mBImhd+npNwKZrcLmGac/WLezSd4KLaZ2xMmBHswFHTs42IykBZCpWeXE7qPiEwIERRi29eR/X22F5xM1TMiRnKPjsvilqSyECxm0iEoinR21TYmOz/hSOaMNGLdYoqcjs7LN2gH+onzc+R567S4iT9Fj88jOYszjsaDLNI8sniUKDJGXDEqWtSoQ6TxzdzQU3TP1KSMuco4xlCLiBDO+wrl8OMtfZ3skjqcmZmgRZ9aHG4D3dhSpLEpQmEO937yCDc9jgLE1QD+CVz1vYX0OU5aI2FthU5fwIWfcsNfdmVPb+8IRTTKsRsYtuaOLEFlHADiBs+DTcqOKVdxuuIkX801jEKgvy33SPRyEMLI7wD2MmnkieSNe/5jbGj+8XagBNbY/xNNJnNCEVzwpeaIrGtzeFpljj79m41t5j24MMfdhFJVQym2twOSJ2nEFcZCe/ItX+uXp2GFDfBZwMUQZiMcnsVgQSwN2zlAS9R5PixFN/FRW3WhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(66476007)(66946007)(52116002)(6506007)(86362001)(38100700002)(26005)(186003)(44832011)(2616005)(8676002)(2906002)(1076003)(6512007)(38350700002)(4744005)(36756003)(316002)(8936002)(6666004)(4326008)(508600001)(5660300002)(6916009)(107886003)(6486002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jL+jKKg2DCeBYTSt+h1psjVPthXMQFucWN+xW+RV6vJrHgEPGEvKPxl2AO7E?=
 =?us-ascii?Q?PUCFTfztH3Uz71HQmxpCOSQEvcA0kja8vHOf9+JDQOO5SQ+6zJBSSKiG/3NJ?=
 =?us-ascii?Q?FpIcdQwf2/+rTR8QazPn+dK4z0AbOGIs7GONFZANGB9WcQhu+30soUMRgFXI?=
 =?us-ascii?Q?YjaleP/3aoStmuGgtZUspGKMD7yZo3vUWQAAE2u9vCHYpIUYjRMOLrCh3suv?=
 =?us-ascii?Q?kM9z8LfdgMtm4wy80Kona6y7erjpYgXsHe0Bsw31+Dfz0wyY4yGKdio/jYMB?=
 =?us-ascii?Q?UDzg7r/mci81LZX3FLkWHMF2nqmxNyGOV7Z+D/0kxVF12BHI9v1FXCB59/Wh?=
 =?us-ascii?Q?vml6y92NGGR3aB9iDcB0G2YrVD4sR6cpsWts3TzE77/Yp/MLnK/F5elvhUXx?=
 =?us-ascii?Q?pSIh31KixNleHMpnnvVix6aiZ0cYgtt25dibEa4miP+/YSZsI1uWVWR9qyE3?=
 =?us-ascii?Q?gUCllZnn3Q8M8J4pJWEfdepVvCrWK9o9P4SW7EU/Dss5/ORj/1YlWNx/D4Yd?=
 =?us-ascii?Q?uFX7fiV7nlHnM1CY85nVtwpUpB8HAwfMa1zzYF8o/5zvrZx3xJJCc8mIWC0J?=
 =?us-ascii?Q?0dHV0TkvRyd5XNJCnbIwL957/Nre1KMvb4S68EFtqWlrtPgVau6q8gA/nUM0?=
 =?us-ascii?Q?iLGnbofZVNO46zCKPWOf9vEk7/jeGnYKBLotbN2AHgZqzd6A1fJtgaNZ/K9F?=
 =?us-ascii?Q?u2K+5wxxrlsT+3GoD61Vn7Lr8huAY5RJnP6i76b+2fxQJvstYeVYonT9zmjd?=
 =?us-ascii?Q?mXZiFCidnSwFfur7ouXDzggp4eY/+sy3vc8+HhkNaTyee/cBKVKtJyPGjjOz?=
 =?us-ascii?Q?ccCuI2i/AL4ZFjOEHYkTX9/f+F8ppd5UncRSH6+uE+Xm4GfmojsVDFffQ33l?=
 =?us-ascii?Q?38CDTATU2xm3QemDr5VWVV6QCHSOGWLrT/l5G5QZT0eMHJLntGbFJpT1jOMa?=
 =?us-ascii?Q?K2oqfoLHvcXtTFY18weoLfZAl6Ba35HFW/7MDPay7vPFEq2rPcQv7pSO7vhM?=
 =?us-ascii?Q?cTzXVzY6Z/2FBBmji6YQclQGA17pidTGeSDNaUoCvL6SnajAVBOPgFffeIcd?=
 =?us-ascii?Q?b1yHIIP0A1Xl7tBtNDWUw4fA2gzqwwpun2APzvo+J0SyfPhuLUwypCjVuu48?=
 =?us-ascii?Q?H+Y/3Wqby8YtOHVDgdkN07BkkWsONYQLFaHtRvaoHofSGcNaDAZ8s1q+cgvH?=
 =?us-ascii?Q?vgsH7VVed437PbzIrHribVBVOGm4+r9Og/jm3THImxjO0PV9xdJH6p5wXcuh?=
 =?us-ascii?Q?+mtDDBqGMLZNdCmcIBDdiCk5kOti03fyp2WCQgrixTOpMPtv0dtlgQqc0RoN?=
 =?us-ascii?Q?GUPiH9oI3S+S4wr4DG1J6lm9LGO06Uer6qcAXTGwpYcXs7UexqNujZSYM4r0?=
 =?us-ascii?Q?AgKZ7wv7eP5DIYXlk0wBW8Jw/3gQAvyQe0H6UrcsP6DL7onAW6TV5jpCINni?=
 =?us-ascii?Q?NtovcNXYJ7k/lTvQ/xEXAfcmePW9ei2LTzNzOTrH59GgL8FpHmb/eRpxrcS2?=
 =?us-ascii?Q?MMApgxj+4MjYzLyO4IcDEDy7PHwTl7Q+bV8SFXplCusdblTMBcW03IFURGf+?=
 =?us-ascii?Q?0YvGyOtfpqIzf4/4k9rg8zhvHa8xUFpDP6Pl6ESS1QMy6uT0hTs75EYdX1Tq?=
 =?us-ascii?Q?WtGzWNpzj7joNU2OLz0wSnP8Vj0w4igQC+ooKLmnO+WND7IX7kmPr6/5DkT9?=
 =?us-ascii?Q?NBEcpQ=3D=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51cf224d-7d21-4dbb-e999-08d9d5475967
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 21:14:27.1199
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uGT7Fb73MdexHk6yMdthB1gI9hMdmz3UqYM5EEwE7A0QPII5FJc7mmfnIvrL1ldaAj7IE4GGRAF9JLbuGYriXztZ92nV+6c9fEogKd/bRyw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB9218
X-Proofpoint-ORIG-GUID: WT7rHv4rtemg69zpIHN5KVEjdjPE0Q8X
X-Proofpoint-GUID: WT7rHv4rtemg69zpIHN5KVEjdjPE0Q8X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 suspectscore=0 adultscore=0 clxscore=1011 phishscore=0
 mlxlogscore=659 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110110
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Various fixes for the Xilinx AXI Ethernet driver.

Robert Hancock (7):
  net: axienet: Reset core before accessing MAC and wait for core ready
  net: axienet: add missing memory barriers
  net: axienet: limit minimum TX ring size
  net: axienet: Fix TX ring slot available check
  net: axienet: fix number of TX ring slots for available check
  net: axienet: fix for TX busy handling
  net: axienet: increase default TX ring size to 128

 .../net/ethernet/xilinx/xilinx_axienet_main.c | 134 +++++++++++-------
 1 file changed, 83 insertions(+), 51 deletions(-)

-- 
2.31.1

