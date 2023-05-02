Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77306F42CD
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 13:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbjEBL3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 07:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233644AbjEBL3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 07:29:19 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20719.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::719])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 531B95FF1;
        Tue,  2 May 2023 04:28:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LzMu8xtTVBWmEm6o8pCcfD3nxkHP9tnfqlOryj3UgPTyLOTILAV1COSQRsBqAfjyVAsHZn4v34EIninQ+PkIL3kAukxGJbCSpZDQZH/XskRDiJCRYM5fntSy6P2X3oMHwTbOgF0jzGHDExGwKtjy4KRZi4H+1zKPLSd74wm7R3dhR0dDICQComcrlRNnYvRUfrymFE+7A3EZkIg14W+NFvVXoydh1Ba15nVnDT0uUSerJhR0GSNkkvFsQ0KNCbvW6cw0ZmFyah251W9iQMc7VJ4omFzcCbz+jQNT2JCTecHkI8tm9Fe8FU4S+U9gPt6Q2WzUlKDnm+ISScC9sqMWcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VQ5IyvemDr+lZLT2sbnEZzDQXbEYBDd5MT6XIxpnKiU=;
 b=it2QJKzNGJMpbzGqbIRibVuzkWKU+R5WefsiGIaHZEy74JAZtI3zpnj+JJBLzrhpFH5Bk2OlG167VSlv5vtOL1HkIP+p3pHNUrjAmwCm1EOe+xiDtYtVttsUXY81WG6CNCYVKI4Rqd5O8GPuyRgplHm4Qorx9lxhAyGKINZ25pTFwmORBY5B+8G/cLw/6WaKi51BGWLqZypTXLSK86wHlOlgan8gBgCLT3dNINXMj80sS8+UBnRELt3qN5giGXR4HqN/SYbGwWPrnWZMsAmNrKFep98s3My/JFH1ajB6vzshm5pRSw5HNiL6zE+WXrN5c5H7IDDFkuF0zil0f9X4Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQ5IyvemDr+lZLT2sbnEZzDQXbEYBDd5MT6XIxpnKiU=;
 b=kqcNz002/yOzkILtVKETwdjqcLMKmGq3ynXMOsn2XWjys4smf2EgJwB/46LL1AKeZ7NhoglzJMc6QrVIFUMlEXc2zVfjsTqBP18Xp15m2eIAs9pvaxjyyRW+32zdKky81YDb28hjCJexG62CWvlthtdLb/bEF3V2l3dO//hLRzk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB4137.namprd13.prod.outlook.com (2603:10b6:303:5b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 11:28:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.031; Tue, 2 May 2023
 11:28:10 +0000
Date:   Tue, 2 May 2023 13:28:02 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Tom Rix <trix@redhat.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] igb: Define igb_pm_ops conditionally on CONFIG_PM
Message-ID: <ZFDzwkvMH1LdVKuF@corigine.com>
References: <20230428200009.2224348-1-trix@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428200009.2224348-1-trix@redhat.com>
X-ClientProxiedBy: AM8P189CA0007.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB4137:EE_
X-MS-Office365-Filtering-Correlation-Id: d86dbb20-1627-4393-cac8-08db4b004efb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e74aq3rd2umd0757KPWBBfwdoVrumPnkz8DuUAPSUv8WaMdoPmnqZj6ddfhDeb3f02y79IGlDoZvTsQUUupcau9OpxttMnGv61BNJ4sWI1LFj/3Ad2D0EOzX3GLjnVovsp09/+RmcwLYMr/wbmqLAlLReOE9FLOMfp3UqvRSdPoSDK831TIpR5Ap7LfTjkzj7QEh9wH9w4u6H//W9ZjbEQMzzrAaQpHGs2hWe8nvcBPiADSaSR6oDgsQ8OH6AW4u5dNB+f6ABlNfn5OHlneAEex9r1WUYt4c+oam9VtrKzdVoDRw6Uwo2n3LjifblJELavZMzGA0en66ly1DVaPqM7v1AljbNSrkaMUZeFhTRPBXpz+ttJTyM2ARtiThSn4WToYBVRRrfLHZm7v5inAozgomEuhDw2W2olrOWSnSXw156AB038msFMWzI9HXg+XL7v8Ztf4m0jDU1Ci1Ie+wpm4amW5NDk3k+jI4uD1luLRrcZN3etqrFmKfo2erVz0z+AKVezZggI7WExfdJ08DLm1QEF9eBSp7Kq7Gw4dJc1/SD74NrAAj3bs/k9xBjL3FVPA6ZtFWM9hGdldqpVvHRng9WIDzZ1tstCx66m+Uh8w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39840400004)(136003)(376002)(396003)(346002)(451199021)(38100700002)(7416002)(86362001)(44832011)(8676002)(8936002)(5660300002)(4326008)(6916009)(66476007)(66556008)(66946007)(41300700001)(316002)(4744005)(2906002)(6512007)(6506007)(6666004)(6486002)(186003)(36756003)(2616005)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1QU/1KqJPkVwWSx2LMJ0bzVxNVtKvdlSkPcetPPZj0Bq3D0rNwEoJeYA8wZO?=
 =?us-ascii?Q?kZrJEAck7BKVX4XV+a7ClNLCPCed4XR6qBLpPd0u8fCYY0xbJOe/DenU2VxG?=
 =?us-ascii?Q?KVFEA8dq9UrLzF52f/kWZ8/qjLzDFWVlIUDhNu2uqOCVCbfFpwST2NqhMED3?=
 =?us-ascii?Q?AxKMGIO6L6qIl/qtKQRWeCnNfMVQ9v87+bH3LORCKvcwo/Ciufoh3rjYxics?=
 =?us-ascii?Q?5XOHGXEDoF+NeX0zzlcZaCO+lP6hVUNFFB7zHNvrBxtcopB2gLQ9RFgeSO+N?=
 =?us-ascii?Q?kMvr9JLzaZncUIKPS70o792zdTWEDIVIc9Thkgfmr81s4Vbqf96MiDYqaaLn?=
 =?us-ascii?Q?lhOdw5yzYyRpltd78RC7jX1GAL3PzhM9KoW4HyrI1PpiChuvC1R4mGGPxBLb?=
 =?us-ascii?Q?jvEBwz70GLD9pVAc83Q20LU8qQpS3hmOi+4ngIxa4zNusAxOErUIHvDatgJS?=
 =?us-ascii?Q?iVnSJlYdCl62HMQ9SDFjzEYgfPY64Ovkp8oNmMovmikaagFlMDYiYpW6b62K?=
 =?us-ascii?Q?B3NpY0UEX0yj0Ikjb/s6ZLD4Ao2GFMTcps8QLYG90EoIffF+G0xJh9L/d+oV?=
 =?us-ascii?Q?CJHKXNcuXcgchIEAXnTXtGG2JGsrhRFjGTwWbq040F47QeYu5/KgVOs53pAc?=
 =?us-ascii?Q?xa48DsBVRiu8UO8+B3qSGT+jjmNi+btuvKt0LPRcrDKQWc0QhKp7tS5PdujU?=
 =?us-ascii?Q?GM9qTiNnG3PbeodrqJZKtFtU2U65D4kLb7WCM5NvdVN91Mzc9CIBpFpJmVPv?=
 =?us-ascii?Q?g2yj+MZlvp/DgRG98BgO64NeLpOz8Y4mxLT/AcJAgGF+43n0D2VqskGId0j7?=
 =?us-ascii?Q?9wZhu2hqtHmUoSNaLRUzYfnGohqniA20u5jI0ja8wucR/rXfajvgoZM6Gy+R?=
 =?us-ascii?Q?ZEb3BNLLkT+7HYe6tWJBM47BTzBiJatqdGPzFEoi08q83M4QvttO8AM/LRqp?=
 =?us-ascii?Q?B3Pav1DtAWJzcZnfdGpeHJ0qEZ4m9MejKmIHyWsail5dlgtq7DiPtfMnCHrW?=
 =?us-ascii?Q?RoXTVAKCLqpnTlSg0CMDvf1Sy9P8o5lH4Eiqtu9jhRzXXLyAr/leH6AUHI4Z?=
 =?us-ascii?Q?AijTd/mAkaxBJv7aOZ9VfHvHewBt885/7PP+o5ygyrMARLBOBom62hyX/cWl?=
 =?us-ascii?Q?SYjKMRHbrSlUT7xrDORaumnBIpLAMJ8W+qroWqOqbpJIKZXQuxZAZC5Jq6mu?=
 =?us-ascii?Q?gouHn2mnMo63mQgNSqWgNm0pEKUkF1B4YQwM75dwSb3UeNM5NahpDauGAvur?=
 =?us-ascii?Q?4SDWUpJCvVMKjq9tMsJOqEc8la6dKPeaagN0LtvLEAh30NGrZu5RtGj5wrVi?=
 =?us-ascii?Q?LQmC2OWE6LM/BxpHPvx8VA4uuKxImRv1X04a7MbLS5lhQPK+Vx1rmYg3JaT+?=
 =?us-ascii?Q?VFaJPU9ccSK8N/nB6cs/q5sHMjNCw4luTXy/1z4R9QTIBYzyyPJbIBJEbFCx?=
 =?us-ascii?Q?OIzL+oGMwAg2FFoF5aMREHDj6sMATi3M40vsIuTZoApKFCiTRpE/5Ddy7Th4?=
 =?us-ascii?Q?EDdOxiG0l6f1MWFusEc8E3dbLEQ4FXvYsFHNCByChMkz5iDkHZoUq9F0CeQH?=
 =?us-ascii?Q?sK/HM1UcroPTghtiku3YdPpcn83R8kuMs/otCpvVwqFahNOZGO5C+FHHDPZ8?=
 =?us-ascii?Q?Iwnt1SDcg9qnFdhoYnZcR+4m3O7zY4OkiRukxxGFHa7GuPZcrmrtiSclExK7?=
 =?us-ascii?Q?W7cjQg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d86dbb20-1627-4393-cac8-08db4b004efb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 11:28:10.4180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MtPCO9R1msM0dbC+7ZPLwlRYRx7GPXp3H0nBGQNP3zEElCD4GbOB+Fd5Cx5LoJH/QN6VXoMPCe8sTccWiY0VjMmbCFQ2eNDY7IjRlqQU6NM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB4137
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 28, 2023 at 04:00:09PM -0400, Tom Rix wrote:
> For s390, gcc with W=1 reports
> drivers/net/ethernet/intel/igb/igb_main.c:186:32: error:
>   'igb_pm_ops' defined but not used [-Werror=unused-const-variable=]
>   186 | static const struct dev_pm_ops igb_pm_ops = {
>       |                                ^~~~~~~~~~
> 
> The only use of igb_pm_ops is conditional on CONFIG_PM.
> The definition of igb_pm_ops should also be conditional on CONFIG_PM
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

