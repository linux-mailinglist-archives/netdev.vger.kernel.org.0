Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB2046D7C35
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 14:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237210AbjDEMI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 08:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237007AbjDEMI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 08:08:58 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2097.outbound.protection.outlook.com [40.107.237.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C3C2127
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 05:08:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oOcJ0RvCbQkbft0SmYpwIhIDOfB6LtY/dmK9O2SWFe9myWLUMWFykxazlLu+e9RzX7sTiOC74MHSbOhFUWrvY02Cl3pHv773SomWNi4EpDml9oEpl1MTDGFmiAhXgAOyjyA8EGFl4fg2LE4pitJKoeIVTrjwrgmWKWetsBFl60fY0gvD1PCRKEIBwupAmpv+CQZaSRCfB39FQdlXOm2LRyUfelMsiNaE1zypgztG3wO8jn82s3tonXrZ+rNVzcPJNlAkbsC04O9ffALHAES5hwiQXt28QbloUo9v+2GCvRUSAyICow4+ywMR7uVuEDEIjrVY+gKjlY7OL0g8vyASPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=liOSk97QyDoLPd9iqSz5U9xArBeml4cdEwikWySUpmg=;
 b=HNZCLsmXtMgRdQWd6Jf+WS954UZV/RxAtXtaPGYD3gxQIQ+sYCuRhsJnppFbLP14fR+DygPdoXG++ihU2mUhyL2WoBGxur2Wi7BmvavxVJyn/QCr4ZBkhGA1FyGo8+w6y391QDsiU0Rh38TS1lMuJdOAJMiQ/8/TZLfY4IvjsWiPZ1+7QLS+yVotqcRHmznXHW9FBuiCHfANj9s+PUUlAYKvfgqUSSCsrdFyEFyARV81832CxouVMpss+YsfVoCtgj6QksQAmlL1bCwjaEcN8Cd/GRVNHx7+w2z8H972IcVXLD284MMhozwRlilpq4wvxT7VtyxqinEbi3xrCHZtdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=liOSk97QyDoLPd9iqSz5U9xArBeml4cdEwikWySUpmg=;
 b=RRc/+Wmff9UW7/yu3N+03EnjTXFcVXGDKTqC2G5/54mbKLSN+ZbpaBMKDvMAx85vZBXxbCfMU52JxsrcZNCSn8RmcppiT4z8z/23ko6hrr8zWelaohf1TOkdKpmZggbC5N3IRyRhsr36JdnHWRRRs7bVNiwfvF/PznrlsgaIPRE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 PH7PR13MB6243.namprd13.prod.outlook.com (2603:10b6:510:246::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 12:08:52 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::80b4:733:367f:7e84]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::80b4:733:367f:7e84%7]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 12:08:52 +0000
From:   Louis Peens <louis.peens@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next v2] nfp: initialize netdev's dev_port with correct id
Date:   Wed,  5 Apr 2023 14:08:29 +0200
Message-Id: <20230405120829.28817-1-louis.peens@corigine.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0003.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::13) To DM6PR13MB4249.namprd13.prod.outlook.com
 (2603:10b6:5:7b::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB4249:EE_|PH7PR13MB6243:EE_
X-MS-Office365-Filtering-Correlation-Id: 494553a3-1b55-469d-8331-08db35ce8571
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WJFHhTxixqj2W8f8ludBp67wP2s9BAjrYCo0San9kTBroxYNEI0NeZrwxSYWgBv4bS73gViDEt9HWd/Emm+4A4+vJVvFwF3pVPEQQMm96nupxnBUTRg/dmAfwFiowr91pFGJHBM5AtSaEr6G6Z4jWdA4+bwCNVdWXD7G1uFX+F/4RsxkmHVFmMjfPxxpZbqDrRqfKSuHXevojaueZu2lgUEyinpgMelpexlu60IYDKAFkHb16OXoH5zXnZxnbTq00HEnWyRHP4pvp8BuaOR5NxDocRcfawTuO0oV1gDHAG2985GN1ti4FAI0TD4je+nophkouEXdWhZGqSCyb4Kl0WRtOGo42mDc8MhPQByftgCLgxBDGfLGdvQLTMgRBRtV8gyCHO7aP1BeXzVIGvofUgl4KJuve/1TSbCaCHw8kL2s0IoWi+h/QffVMmtYyyZ+7lOYyqFKp/VTPR9rmRUKNKtiP9Lis7Dv+6WndQe11Raa5TBHt2dpKmgXt5crgvtMQ6VHTASP3ney+fP95sz+Ri29+cWTxeqnZTSvGj6Ianvkmw3tmbc1uMDP5en65/WsrD8V7wiKJRjmqH8xRMWNkftiuH2Jmn4vp9sRke2LlbI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(136003)(366004)(39840400004)(451199021)(52116002)(38350700002)(4326008)(110136005)(66556008)(54906003)(66476007)(8676002)(66946007)(36756003)(478600001)(41300700001)(6512007)(38100700002)(6666004)(86362001)(316002)(6506007)(26005)(2616005)(83380400001)(186003)(107886003)(1076003)(966005)(6486002)(2906002)(5660300002)(8936002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qEXBrk3BvaNbKp3tsUdZS4Lr+hYP7b0nVQUdaPlBjOOpUQnve3gp4UXv5LdB?=
 =?us-ascii?Q?UN5A9Obb7FWa79+PDs/+6V0LdmEx0W8QHaQ9Hmv7r3vaF3xlcHn4rkxGHLis?=
 =?us-ascii?Q?drgZXzHVT14abByZegRmveo+CYgVzjf3CX9A/pWP5SbfOCFUlRDRUv5RSfui?=
 =?us-ascii?Q?IyWtNwshagBHYwxDfSJAFuzi57uWvORcZvIlDK+b9iG0WUAoucEYne5FjyNL?=
 =?us-ascii?Q?YdYmse+mDsGcbAKz40IXEkQZjnd4Vq+4Pmg/ddcOltt4vyj4yuh6yVFOGsUV?=
 =?us-ascii?Q?gyIYkzsMEDh7ymXHDq6F0w0+PHsMAJHU60R/5vFURWro0WMN8+eTI5J2eUJn?=
 =?us-ascii?Q?7T3PczrvqHFAxoJM7cSsOHasR1vU9SA58NSyCS2KJig5V347FkAcJoVcWHwh?=
 =?us-ascii?Q?5y3+9ugNpNp/Sdg5FvjhAztDyLr9B7drwLJtN8f9WCNl5arWbDMo8ghuo58f?=
 =?us-ascii?Q?xZ2J6vx8itQk8YvdUcF6WRDHmsQzmcNueb3uyz3aQKVrPIhv6zWX0c7OKxpe?=
 =?us-ascii?Q?0PD1PaboeIp2RFuo02lqZUVcZBLe2rJBvB4PvfwKtGnz2uObjHtiFibVjADE?=
 =?us-ascii?Q?i9nPiDESDyGu28J6lp1Smj5EFch6FUSzDaIcU2O7AgG44UhqWwHcukJCW6pj?=
 =?us-ascii?Q?X+bX9f2emfrSaczZb+CayM5oPqrEoGKE1KDQTIaXC+CJOy/sZuRq8ZXxUpwZ?=
 =?us-ascii?Q?LxvWQJNzmaLbsW+bGro3C6tmTciE0PjDvFnNOjIqB8YwcH3++fsJJrldrjf4?=
 =?us-ascii?Q?i2hvl+CWYjqqD6hL12BflBdh3Zolnytjq7CuO/3VnXFtZVb/ky9M/7YTqfeP?=
 =?us-ascii?Q?Kan8gbwdbMx2KeZlTmWDXRylpKboL2WELmRWFUpqlzsRDLNTB0+2JxM+Kmhs?=
 =?us-ascii?Q?7nmgJf1QOGDC+228DS4g+r4I1J+lyXH1VRArKVUkZYjsuKTug5xedpkbXwIs?=
 =?us-ascii?Q?ebqTy8eMC/e0SUseWzHpooz884v5XS58/pcP4C/y339QpWSNdyuT6s5vyY77?=
 =?us-ascii?Q?nldnRkfoobP02SdXkzSaQQ5rIect0ER2T2r+x3O7RW5MI+yKxVAt75y5ACVJ?=
 =?us-ascii?Q?eJVCgj5EDrGIJH+hRCci3VBoC6NShRWy1FTry0jiFCFPEF3P5y2ECTLHbRlV?=
 =?us-ascii?Q?3ICAPOpStaoNv3RYUnDVxSg8J/eo6umLVXRpVfnECy93P4D1BGMFmY4GC1RX?=
 =?us-ascii?Q?btFP8ESIkYaUCZiml7n3uGziOh7bEHfxH/mZzwTGXKey3sIFj0RmzFV+xB8L?=
 =?us-ascii?Q?uOzeAmYNu/BpEKdF/yVi83RYuh3Tf5nPBSfpx6tRISBZ7uUabDqoS+DEpUak?=
 =?us-ascii?Q?kCMN0EWlQyTfdhxSI3LFjm0bZ/4IVVj5cGjDCvVaUvnFpt6BkWKyTH+KtOND?=
 =?us-ascii?Q?NXH5GkPjqGJYa12qu1qQG0x/uQvOxe5u5jjd4oTpRxMeJIDL77owA6cK8HZ2?=
 =?us-ascii?Q?SQImFsqZxANm59eFFmzHSeYk4InmQDdtIi//csmSvXTXSSzykDpMbaOc025+?=
 =?us-ascii?Q?6YATjXCA+8SojKMSO0q/KyLHvapfc2MDKOReSguHh+GSKIHyl48T6Am5FZqj?=
 =?us-ascii?Q?fhXswmhgN2j0xw1rvFurafvcWDtMcllQN8NR1M2Q+EY+P0DAB0P7ugXl85PQ?=
 =?us-ascii?Q?rQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 494553a3-1b55-469d-8331-08db35ce8571
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 12:08:52.5122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yAfQLyV427PYZIJ7nKv5mzhDYG0BvXT6itWZJdbSJ0Cbyn3z53nd6rNS/T/yVietsq5pKlw8DarwkALL4B5QSu7EECfKBcLAaXSeQeHhpB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6243
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yinjun Zhang <yinjun.zhang@corigine.com>

`dev_port` is used to differentiate devices that instantiate from
the same function, which is the case in most of NFP NICs.

In some customized scenario, `dev_port` is used to rename netdev
instead of `phys_port_name`. Example rules using `dev_port`:

  SUBSYSTEM=="net", ACTION=="add", KERNELS=="0000:e1:00.0", ATTR{dev_port}=="0", NAME:="ens8np0"
  SUBSYSTEM=="net", ACTION=="add", KERNELS=="0000:e1:00.0", ATTR{dev_port}=="1", NAME:="ens8np1"

To take port split case into account, here we initialize `dev_port`
according to the port sequence in eth_table from management firmware
instead of using port label id directly. And management firmware
makes sure that port sequence matches its label id.

Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Acked-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
---
This is a resubmission of a patch which was previously part of a series in
[1]. Since the second patch in that series was rejected this is now a
single patch, and is therefore submitted as such.

Changes since V1 related to this patch:
- Updated the commit message to better explain the origin of the number which
  gets populated.

[1] https://lore.kernel.org/netdev/20230329144548.66708-1-louis.peens@corigine.com/T/

 drivers/net/ethernet/netronome/nfp/nfp_port.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_port.c b/drivers/net/ethernet/netronome/nfp/nfp_port.c
index 4f2308570dcf..54640bcb70fb 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_port.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_port.c
@@ -189,6 +189,7 @@ int nfp_port_init_phy_port(struct nfp_pf *pf, struct nfp_app *app,
 
 	port->eth_port = &pf->eth_tbl->ports[id];
 	port->eth_id = pf->eth_tbl->ports[id].index;
+	port->netdev->dev_port = id;
 	if (pf->mac_stats_mem)
 		port->eth_stats =
 			pf->mac_stats_mem + port->eth_id * NFP_MAC_STATS_SIZE;
-- 
2.34.1

