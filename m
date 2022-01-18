Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0127D49300F
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 22:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348597AbiARVmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 16:42:42 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:3881 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233335AbiARVmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 16:42:42 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20IBxQUB007528;
        Tue, 18 Jan 2022 16:42:23 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2050.outbound.protection.outlook.com [104.47.61.50])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dnbdu0rt5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 16:42:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hYkORbaJKCpOt78Klc/KbMGT3XolcbgyEKIiuIZMx9ijq/dEZlDuL9IURsYiFRKWQ71oiT7ou92dd64MlbRfIhnKfqQzlTdBYPdUokWmPQEJl4ygACKmRdwQDlTtxsWDcuVpvsLbLLBTvnNO4Za7KaBXWJqkZZfY1bPkuIKeenxrBSpHAtF4Uuo16mkmDDIJOfaybyaiSEJWgT5TtaJRv+2LNBPGngjOC3jowWnfoBd14T8u7wNz846gvbztr9qfhxAZkTL1DfAFh50lHI3gdNDqDua9miJUnJ7mP/U+0m8jHYdI7pdKS0OJIAgj70jylzmYhObRE/l8WiG/MtzBaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YG2F6sAFOOy25GtSoN4zxCyd0GmxtNHRogndS5BQuC8=;
 b=L/3O09+6dRy8pp12BDFpjwCIn+svZlLe0rcXrmMLWKNNlm2jgAx3bRJC+edRV8I57vkTCcIJT59Cwt+7s/8V6GYI9jF38azaMVcl1PDb+jdAVHwx6Uw7nvUoXsVIoAJZip0Lbw37VcmCmT4IdHq1YroAwo99gafQrVv4o5X7itAHuSTR0nOMngQrLn5T8LzM4fDUTsFJnLQ2n8n8JGUf+piCarVuPHM9cBlUIAPvxzNjgUUqXQcFAl/jjNqtLp+y5DDiRI+hlC5MCCqqiUVLKUDpuhW0JOZ7N0aT4XsIyLXw73Rr3VEXeSe7ZutMm6fnu3zS3Po8Da1HvECgiFMALg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YG2F6sAFOOy25GtSoN4zxCyd0GmxtNHRogndS5BQuC8=;
 b=h81a7YADGNDKLSGfBDkkgyNE4qVoTFyagDSHv5YYcf5ITefcWQwTQhSgIlVCAzLFCW7tqQNwJAOcOf+uMPyHfGzcfOa+56zvixJx2gu0Xioggy2+6QtqkkZ/wzcx9phAwqxwEB4jc3w7VU3wNe3HZIXg5QxtLavclJhE5D92Xdw=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT2PR01MB6579.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Tue, 18 Jan
 2022 21:42:21 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 21:42:21 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        michal.simek@xilinx.com, daniel@iogearbox.net, andrew@lunn.ch,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net v3 0/9] Xilinx axienet fixes
Date:   Tue, 18 Jan 2022 15:41:23 -0600
Message-Id: <20220118214132.357349-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:300:117::19) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43051d41-756d-4913-f742-08d9dacb684f
X-MS-TrafficTypeDiagnostic: YT2PR01MB6579:EE_
X-Microsoft-Antispam-PRVS: <YT2PR01MB657977BABF50CBA1C8057900EC589@YT2PR01MB6579.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qYiyhPyPOeRzfhqElHAk6ZDIy+4L+4UO+s5x7UE+yI7IlO4f0fDXuWb28Vvpk8pmQQl0DrWIK51KwjoKBpEKivJV8GHSjGnMRF1GQqR6J32iyYkvnNaRimgGKs6zRl2mNbUbU0GDOu0HNt0IlxSp+mE6LvGZ0JANCQ9X+1wDB2IVnU6qWkINT/yhhieEEN8d7Aonm4hjVW3VcgF2vig1KFYHa2thYjNZ3zO/JI/+nzAguXEmK3ZPcW/seWOH+o0qSP7bCIGVdnsHp2KYaewrU1A4Dnn/3wn3nVKCWycQmZPEuPqS6H9TUL3wALF4v9K3M29AcbUIau2xlaIHHRiehm1WJOFZb47cxmqA2noAhJlVWyEkgKNZp8vOAI5haN0DN7KvP7JpnZZXW8GjrFyU2ks9N2YCaMDcyJFTDcMe9rJz7esOEHT9PhMJqY9N1aLKGFIVE3tc4HdRS90bwJDowv0N19gIUUzOE6oN7RFzEDHWfk5yTnft4RTwpeWk1TGLf7Q9x1ZbIIWVvLUl/96AQYv3tCq1OEBtH4TkA06RQikTem4Pny2Vx+NNgF2StJqDzAjOni8Avu5OPNSTocsdiIQiEh13bCFtw75W0s5YyEkSUaFg0ajHxJE0SUYvCj/2WdFpYIG+0HMkH+90D+O4X5RrCV3ZTATRj/vB3R816VvCdtg5OUh5sc+3RiTI/YIKA4bB91SBoqnaBvHLAplY/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(5660300002)(2906002)(66556008)(4326008)(66946007)(86362001)(6486002)(44832011)(4744005)(316002)(52116002)(6512007)(1076003)(83380400001)(26005)(6506007)(107886003)(6916009)(508600001)(38350700002)(8936002)(186003)(2616005)(38100700002)(36756003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M3xLVAkd/vK24ciOypOwioLvzb0ImTEyC8JVxn0B1BKxqcyu4r6qUrNM82O4?=
 =?us-ascii?Q?zlAEF6a3fGAd+mCw2rnkZsjixaj3SlvrqlQNrzcjvOYjGIhkeb2bRwUoNVVB?=
 =?us-ascii?Q?JCY7pOh+wmO/WUAwHqjIonPpkcRKLkwWx4URgaB72GRDkT+loGwnDso/wl16?=
 =?us-ascii?Q?HVNZGMt+1HWEUgcDEh9kwCqrqxfDRkpfqXppudW67HjAZfhJauKsLaP0nS+F?=
 =?us-ascii?Q?TXTm6mxoI4AohVyMeD+pZLuV3xGsFuh7b+a31vUas4ueh/szrPCwdHl4hFT2?=
 =?us-ascii?Q?z2nUxD2ZIup9Q241gOynRo7B9iMCg/Hskb6i6llKtCwe4/X02H8UF3aJkx95?=
 =?us-ascii?Q?Ntm8flgHS+nGFExzATCgmlSFg9yyLroNHwDcV2b6BUubaNS1zWAYH0eHzb/H?=
 =?us-ascii?Q?Ujz3BRH99nLZ9mTfPBoZMxXobE12MnsCsPeMyQxLKAORrvs2nAIaqcjoyEJr?=
 =?us-ascii?Q?yYExgCSjFh1ZZAMdZrT0BytnwTzFocUJsKrIVC1fpeLNmTwTQofrqDqTbB96?=
 =?us-ascii?Q?FLBc9pOgeUMcBZMA6S2X6dCmBZJBY+OA+NPAneHPFB6KR9/B78ezZywRSS4K?=
 =?us-ascii?Q?+sEFytlpX0KIQmXCwBN7ykdySLZGg8OvI/yILkkXKVgg3jeQp//NSSK7S4JE?=
 =?us-ascii?Q?BoDxKhPF4uum9b6eUXcVYb+NoZdcO77W8Nqs6aY3kRC/JLsSVQJ7qzjzHBD5?=
 =?us-ascii?Q?NPvQVVl+8HgAXVgP7sF3qVJUZPIFgczBi25lfLF6jM1ofGcw7h86r3Cgbc4W?=
 =?us-ascii?Q?ReteGFRixxO34sqRWVFwl4lsnaa4r4fGF7PcKtdC2qEcLbwCjoJexJgU7Kg1?=
 =?us-ascii?Q?fAIStOmUSnbnv7TSCdaCEyL9lNcnBHspia0yN8O6eZpqsTrGzj2ovD1hA0Y3?=
 =?us-ascii?Q?ams6dRp34YtBV8b2RCYIZriv5XqdoMkC8UKUA7uvXLhXmg09VH2cAYGeQMd/?=
 =?us-ascii?Q?OUrIt/odqdCoOWnGdK9fwc1FtzwH6LraUyiRdfHVX0AipRYZV+KffUChnrnr?=
 =?us-ascii?Q?WSbHzy2OM1mDiVJOYv5Gstr8ghUvU/Fm4Qr5zjL+uEkju6iHBNrJVj3pGsiZ?=
 =?us-ascii?Q?kfmowLT5xheLlT9pXkqdP0l/Vkl/d6jufcNMVeKUn1xqn6zr0zTnBCPaeIvD?=
 =?us-ascii?Q?d3x1C4QQRA9sXnK/CFZtmPXJxCba7c8mP0uUYIm50pqUfJ2V0UENtL1pWQzD?=
 =?us-ascii?Q?hfPw0CM6qu045nD4VQIublOJq0REGtk76lTIS5pBTNQi0ozQd6nVMsUG4jGJ?=
 =?us-ascii?Q?JLZWBYObmKSKhBqZ7fS2THImihMkZTtNlzhbSA3iSjZTaDLAgObC9r0KlmAj?=
 =?us-ascii?Q?/zxTgplNCU1zySXsqU4l9C2+1dsi0TQLxpp428FuZoK6VbpbIYxE6hDUzEsh?=
 =?us-ascii?Q?hSdDIo9nTuTFG8iPoMSW8d83GAfwSNhjZz0Qjym69IoL/CrLklNc7MFodr1/?=
 =?us-ascii?Q?xgKVZa7X9jB5dO2Se/WHFTJ4OL14ST4klufLdxx2CPv8lDCNzkHS8f2c9IDf?=
 =?us-ascii?Q?44xhhYvtFaRtvhwub4vD4UxzKQt/v17xCGkp4gir+29E3dskPByVM3KOza4M?=
 =?us-ascii?Q?T0F0rovM3GxN1/oZhA3vcmlzgsPEVuu30YILIKHx75AL3BmXJAbFcDrPVIdx?=
 =?us-ascii?Q?1XisYwYuIcx+luJbeR1HPWEBXbzb0VYsEniruoV5XiOQBIzcuwUsr6FmPktB?=
 =?us-ascii?Q?x+Bvjg=3D=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43051d41-756d-4913-f742-08d9dacb684f
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 21:42:21.5110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hGLIDq6UCe7jDPlacqmXGN1fTp49HN4aAH2gtGWConb5WLTbQK1H1KsIJm+KMxpiRlxk7Zk6L/zo7mrl3h4VHxE4bVxrRk9VSfITIDKhRXQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB6579
X-Proofpoint-ORIG-GUID: wlJ-teWZFWo2PHfzI_-XjKWznnefPer_
X-Proofpoint-GUID: wlJ-teWZFWo2PHfzI_-XjKWznnefPer_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_05,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 suspectscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=921
 clxscore=1015 priorityscore=1501 malwarescore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180122
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Various fixes for the Xilinx AXI Ethernet driver.

Changed since v2:
-added Reviewed-by tags, added some explanation to commit
messages, no code changes

Changed since v1:
-corrected a Fixes tag to point to mainline commit
-split up reset changes into 3 patches
-added ratelimit on netdev_warn in TX busy case

Robert Hancock (9):
  net: axienet: increase reset timeout
  net: axienet: Wait for PhyRstCmplt after core reset
  net: axienet: reset core on initialization prior to MDIO access
  net: axienet: add missing memory barriers
  net: axienet: limit minimum TX ring size
  net: axienet: Fix TX ring slot available check
  net: axienet: fix number of TX ring slots for available check
  net: axienet: fix for TX busy handling
  net: axienet: increase default TX ring size to 128

 .../net/ethernet/xilinx/xilinx_axienet_main.c | 135 +++++++++++-------
 1 file changed, 84 insertions(+), 51 deletions(-)

-- 
2.31.1

