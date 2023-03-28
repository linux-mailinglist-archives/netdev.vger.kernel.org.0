Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAFE46CC253
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 16:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbjC1One (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 10:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjC1Ond (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 10:43:33 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2094.outbound.protection.outlook.com [40.107.92.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115F7BBA3;
        Tue, 28 Mar 2023 07:43:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dcyM58igvtmpLKCMMrbE9AatsNrZktU6NbflqT9JPeLE5F8L+I6HAJ0+UHxUuDQnAkvEkjS8rvSY59S93IEBFexsj93+LxctFFPOO8gmYN6ldLN4DbpA0jolhs9kb87aWIulGUwFOX41Qe+bt2BvxdA/OmJACfw+stIqG5dEficl98QQ9VbS86IYVUUMjEBgNQv0P9/lrdCpTQcg7KFrtmFf32+PPhT7vCRgIgCxCf1UaF8lSLtecONF+yCgRmymSQ5GiCs+IXznhigowP5Xa2eHDZKj/yR/+yxcm0dikQgjeDr3/l/zWwfCBUQ2vSGGq2Lu5mNEPi8vwbL+WSBvEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jSDD6hVrsATBVfbkCICnS16rA0s/wmGo91zP4oWg83k=;
 b=K2+ZO9i1WDgRXJNOQ0c9wKuFCVJKYUXEGJC/Tt6eJ3qvQSAHHQE7gGwGSauXfUo8qbCbss6k2GZl7wGdm1jf8NfnsdzT4TLJzK/Hi2l7oEtCBGCUM8WGNeX37SxAh6aC8EclJEx2fs6+LTWvoAllHo97u508urv2OoJrMmf6YdR4zRGn3V8zlC+EnvZyNeiUiY+DrZTmlpzSzCCAWkYX3Jr5b8rcQePIjhvaSl31+YyW5iNaSFrOdYInOxGYA2oZgr2rrUglAIvs3mB8jD9F6wPoa6T01IneiAHL1LSr+KTtV6nn3+HINN39/JaAfuFTYkGzIRZWthq1S7NrlYkvdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jSDD6hVrsATBVfbkCICnS16rA0s/wmGo91zP4oWg83k=;
 b=Dz6XJuzVWaj5Ssm9L16JXFjZXosOvTIyA6YrbX+BkDtYU0RlCAcw5oZqOaM8A9DqqZnUdm6kUxY4mbPQyE1pO+kgxqg1mqeoPYdASUEc2NOojhttlU1yDMwGmtwjokpkuwcbEFFhVKi7lYKWfC8YhrRZAOk8AilM4xFnT1udkls=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB3667.namprd13.prod.outlook.com (2603:10b6:a03:227::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.29; Tue, 28 Mar
 2023 14:43:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Tue, 28 Mar 2023
 14:43:28 +0000
Date:   Tue, 28 Mar 2023 16:43:21 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net,
        willemdebruijn.kernel@gmail.com, andrew@lunn.ch,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, sbhatta@marvell.com, naveenm@marvel.com,
        edumazet@google.com, pabeni@redhat.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, maxtram95@gmail.com
Subject: Re: [net-next Patch v5 3/6] octeontx2-pf: qos send queues management
Message-ID: <ZCL9CbpBuH0M3OJU@corigine.com>
References: <20230326181245.29149-1-hkelam@marvell.com>
 <20230326181245.29149-4-hkelam@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230326181245.29149-4-hkelam@marvell.com>
X-ClientProxiedBy: AS4PR09CA0015.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB3667:EE_
X-MS-Office365-Filtering-Correlation-Id: e53c10c6-7a50-4036-a68e-08db2f9acb12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y8pzup/JTB1ayQkQvEWQVzWpD6GL4/1274dW9MiT1DDFunGfiCdpWOSBhFZFX1xeisfJfNXeIYwLYZEy5RD+UbCRl+aeDkI9zdI/2lJyisS3ZIQWzdd74kR2z0romT8Sd4VH6sKJqweovroEIS3Qn8PGqMjfWbWFiihVTKkEVt8gQ7k3rpRl5zfLwim6s3Yntsx3VrP+8+dW7udnhDi+Au0j3zQaqDC7c4z/5g+lVG1Fvmt6Mq1h63SH3kUgTd+5OuooS3R7lNS3uFtOcygfcOtOxT9VHEDDmioM6mpSpbgva6m1GrtxPnszR5QXtiFSFM1nHOJDF2KXLCKFxRMiXN8tHm6XCy924Zf33DetqPqPCTbuh1WmspjVq8/lHoOdopkXyKp4XCcy8CwleEc1pmL3w0E1gPXg/CnaV8pII3JFJtW9e7WZI5KCIDJfWMlA1SK7FDqdg+ulB1WmG5PYx7wFR3Q00cc+nn9bx2YF8KbnVsJ6jzNPIg+TgDr9BFOP/JT5W1DWalPcE9PGwv2nJ1wtbIKPy6wtyJYqdsBikqa9QAQbS2IW1SgHbp2N4APJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(376002)(136003)(366004)(396003)(346002)(451199021)(2616005)(83380400001)(2906002)(8676002)(6916009)(66946007)(66556008)(4326008)(66476007)(6512007)(478600001)(316002)(7416002)(186003)(6506007)(6666004)(44832011)(36756003)(86362001)(41300700001)(6486002)(38100700002)(5660300002)(66899021)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aUMddOWto980XJP48KFBMPOe7tdNSHR/47jTSB1Q4U5uZZ5o74w1U56PRHut?=
 =?us-ascii?Q?9Q75n9X7y+SpFMJdC4RvWnPdpxXNB0p4brAz5FaANJTdcWRE/ln4dDrMULuL?=
 =?us-ascii?Q?3Rbnk6e+dU3qB5Tag3cUc7qxy7UqFi3TWdINc1AQbBciWJpzQ7XKroNARlbs?=
 =?us-ascii?Q?XrSz4/ty6v3hWiGfqIjHOYW4MFlfURUF/DEoFwb7M7CpO92e7pRktNPOru/y?=
 =?us-ascii?Q?4pAaCsjX/Aq6jn/4UxXuwj2ibNYSl35qEPtnWdGt0VcXndM/ZKc7xWZ1HVjV?=
 =?us-ascii?Q?MwOOXpN7LomFmuWlyPDGa9e6qTyFcEN95CefEWt5U6Fyv82rb1mEUUMyWfRY?=
 =?us-ascii?Q?mSYL2jO7TKyiA8NwYc+8t4TCI+3EbWa7RO0WyAh/1ZPy55d103L7s3GpvS1m?=
 =?us-ascii?Q?vScDhiiScak0oKuUIHaghmSoEAb7fdRVRPYLRmjHCo9WJONwtUnSMjTav9WN?=
 =?us-ascii?Q?0xRgaW4TGFyGacR7AEExx4ToV6xAfJc/+n9hZiLwU3+0hJABYr/ZAIhCsaPd?=
 =?us-ascii?Q?Z4rEqRDmIrOTa2tjFd/RHLuS21uZkTrXcwt8m0LvxAev0k8p4T/mlKoqWX1C?=
 =?us-ascii?Q?fmfOF8v11ze3p+U8OrEAw9IhrKmmIksUF4HtDGLTq/ntS8Imjb4z2S9MzOVv?=
 =?us-ascii?Q?s8Y42qvPTAuMxjXT3DSaXYc8ygM2uzRWdwYei0kQ7XxGYyawtHyU5gzYAzKE?=
 =?us-ascii?Q?AQsnOgNt3104/031ZmCOC7E0wcSMZutjeX7IU/q/spsN4U6GJS4JRo4pNM+A?=
 =?us-ascii?Q?VNe7tsCy7g0vuAXO3EmYaUuI73se3ePvKase6P+yz1GU4wLTueKjzTZCdO2Q?=
 =?us-ascii?Q?GD018FL3UcpAPc/AaFp5Yc7xMRXqrbIq1/ekCJBpCXFBux8c6WkyMrbBN22l?=
 =?us-ascii?Q?TNVaWOyUHT2UnjldCje4On0uslHu1RlWfQaok4Ohz9ymXw70IogpzUpXsY99?=
 =?us-ascii?Q?NrCEQTvTOaO5sskN3ZHD0z1+1eGDJyNQ+IBDn3DIZHfsKO5TFMOuRSnyQ2ZA?=
 =?us-ascii?Q?hxmiG2BxCnfg9emf+aOiHucgpMfoFhObxZxe12LxPUzups2FPrmLDsKSFi8D?=
 =?us-ascii?Q?Q9vJToa3bwsvfIAk0YNNLQjlrGRM76eBGrTsrl/iQIqqTAY6NMXzLF5OEnuu?=
 =?us-ascii?Q?uiViFZdlLLBIFUjtoMt44IKfrFTYs6qBqgVZxjB4B8uf68DXQCrhUyck9iFP?=
 =?us-ascii?Q?3C6mo6PgWBob+nNRWnW1deXP4XcQ/aAcf7zBP+GqEkYw6T080yPT7wDK5Tey?=
 =?us-ascii?Q?lLyE0l7U8D/M/dh8JodihAjT/Z6BTMf/UoVI5BNoh8aJ2gm0tPLCmBb/CCOz?=
 =?us-ascii?Q?dMmnHU5vddS8FWmkRa5F75EMzBAGwOK2wK7/pHu0HDGt/Q3enlnu3Du3IdNu?=
 =?us-ascii?Q?xtRb6/r74hQBWMaWz66YhKQrpfD+bOCUkq1EsbyQgUCCFFGY6VEoYpfWoROm?=
 =?us-ascii?Q?fYQmZ8Gc+E4zxCMFMlNdclG/rQPtmxyzrbGCJwHjuEeswTjD5SjphBrp5fjt?=
 =?us-ascii?Q?yOje84AXPY5KmKHsT50sKOqc85dbWvJW2G84j+2sKnfyUrsqIkAa4vkys6Uw?=
 =?us-ascii?Q?S/q/lzAZNzABpEoZX6e4omhxPmZ21mmy0WO9Fh9szJZUoViQdFL1jFsTcP0e?=
 =?us-ascii?Q?4UMSUzA4+oA2+pXNc+0IfJB/n9rTUFom9UI7yLFeEY1NQCsGSGdm3hX6ZCB9?=
 =?us-ascii?Q?Idn1kw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e53c10c6-7a50-4036-a68e-08db2f9acb12
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 14:43:28.3485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EH7uGga8fuQ0rY1LMEMZs0a1EosaSsDKHKWGhi0004C6y7cz6yH52437smrcZ+t9/NkwM2gctePkX0XqVdcRQ9DLYRxqFzHiM0UgmG89FJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3667
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 11:42:42PM +0530, Hariprasad Kelam wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> Current implementation is such that the number of Send queues (SQs)
> are decided on the device probe which is equal to the number of online
> cpus. These SQs are allocated and deallocated in interface open and c
> lose calls respectively.
> 
> This patch defines new APIs for initializing and deinitializing Send
> queues dynamically and allocates more number of transmit queues for
> QOS feature.
> 
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c

...

> @@ -1938,6 +1952,12 @@ static netdev_tx_t otx2_xmit(struct sk_buff *skb, struct net_device *netdev)
>  	int qidx = skb_get_queue_mapping(skb);
>  	struct otx2_snd_queue *sq;
>  	struct netdev_queue *txq;
> +	int sq_idx;
> +
> +	/* XDP SQs are not mapped with TXQs
> +	 * advance qid to derive correct sq maped with QOS

nit: s/maped/mapped/

...
