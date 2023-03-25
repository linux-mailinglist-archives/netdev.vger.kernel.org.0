Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C596C8DD2
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 13:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbjCYMHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 08:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjCYMHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 08:07:21 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2131.outbound.protection.outlook.com [40.107.220.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6BC61B7
        for <netdev@vger.kernel.org>; Sat, 25 Mar 2023 05:07:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1Q938tbcvbPDvjjFC18/x80GLPZNKKhuMnjYKH5b7FJFiX3w1DIhlm6yuyt+A1poIpQ7BR1KS5cvBHEN6Hw/J/Jq+uMsnyVSW1ktv1adwxtXHjQDaCyGYbpstLMzXbXDcE5I1kNiBitaCIGhcbiG0I3NK7RfcLpRpeLezNcO1u+rgX33fTsgryfFoB3+FRmA6ShKQXbpsplR9+YAg1KguiThjMt7gaHSYXnYXiuycigd+WhUfH6FXbcf68v8yADpuGaevoWvJDKQPNE88RlIiiBXGH+Zp0NcW4w+hdZxU6tnTFu3Ckqtir6fg15CgTcYXx/mF/+nPPwqzEQ/VLVnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ImoVOXonsKZkCAUdjl8O4IV2lH5cfqLpx6QtbKpVCVk=;
 b=gjuO2+tGck4E0tTW1abylCsfX4jtXx9XVOVsHya4b4XikRdf2aaefNW4K4AQNs21bP/pMJuHwppc6UOSoCet0EZS4VIe4TDsMScblMsKI+fASofMaHrhwENMbrQRTVcHNSUID7txWFcpeSxUZwdiWKSPMrySJXgtL8ogPSG2vZbpa3/xSU+VOPC0D4Q38N4Ckg8bdTTKJeUk9FaScpxMGYiFwvz4dbxwNUjX4AxBhLD382adl/eEk5F5zxlmiqkWS1pm2o9ZQJrTs5+flr7GIETaB65yNBknTYIRVW9YEFbrQDhs45B5V6zKqe8ZzQld/AVlGdMm0AlCV35aE8i64w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ImoVOXonsKZkCAUdjl8O4IV2lH5cfqLpx6QtbKpVCVk=;
 b=nLIhov2QoLWEonp5Qq4LYJDyErIOb5RxbL6hcILeGCSim2rUh90KxAwPqovW5BoowuJO+w/s31MUgwBO5ZLJoaf8yfRM9Nz9x/ydpVbSy2taDUTjFNQEsEep7OcuddrgrWhmsRVgSEqABG/XyG7Vt++SMzy4PzaqSh6JV2HGPr8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3938.namprd13.prod.outlook.com (2603:10b6:5:2af::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Sat, 25 Mar
 2023 12:07:16 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.041; Sat, 25 Mar 2023
 12:07:15 +0000
Date:   Sat, 25 Mar 2023 13:07:09 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, michal.swiatkowski@linux.intel.com
Subject: Re: [PATCH net-next v2 3/6] sfc: handle enc keys in
 efx_tc_flower_parse_match()
Message-ID: <ZB7j7XgjVXsacPnp@corigine.com>
References: <cover.1679603051.git.ecree.xilinx@gmail.com>
 <a90ca2a5723ce95724286847082655f01e2e7997.1679603051.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a90ca2a5723ce95724286847082655f01e2e7997.1679603051.git.ecree.xilinx@gmail.com>
X-ClientProxiedBy: AS4P192CA0020.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e1::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3938:EE_
X-MS-Office365-Filtering-Correlation-Id: b9e72bbb-2075-4499-006c-08db2d297964
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uH+8k7CQpdp91rFvP/MnPF5EfCsKDC0JOIHALSwXPg1rc1jQ+fz9CPOslGiUtlZaVRsWwL3IpeWrEbw9vkGw6tOY08M867aUqm89bAUf2Tcg14D+1ewq3OTMy/SmaLEtLRJv+A3JIJ+UEn4L8NXbYJmBfLg3VNNnc3dJChWXb6mvSmntsyf+OpLCqgt2OOw1v1ial3s9DQMvzTyHosSyy0pCT27KcKOwHWofIWuD7K6mJ+kg9mMt0CkGQ8LeUwKicAjmkjJRGth1wRbIDUWXs+qGKLwdAG7ZvhH8QUaSIKKIHNDyd9CN7R373WN4aRp5GZtXUmXcYGUDbVXnv8wmAIKkF5MJbkT9Y0+GHkn1/aHmFK8NeRS1j2z5DOLhW/kK1kAQeLGySTDMrUQehw6w6mA2B1u+WbO68EqxMFYnjblW6JFcPdjQF4uVZGtclhYM0xFACjkO6p6MsfgLxf7iaLAmq5FPFBDKMRyg5mRJXnLJH/U5niCnUk2nggoQioTLW4s+oCfqLWF3HNpnu+GESr1PD/Ev239u27a2YzJrWseSqCTXawn1vTYMD8btyYWL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39830400003)(136003)(366004)(396003)(451199021)(186003)(6666004)(36756003)(7416002)(2906002)(38100700002)(66556008)(8676002)(6512007)(4326008)(6486002)(6916009)(6506007)(66946007)(478600001)(316002)(66476007)(8936002)(5660300002)(41300700001)(86362001)(4744005)(44832011)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jci4o/F3lqhHxqRD4sQNW6f6urj8wtTEAl5MG11Pw4iNzpPsApfA0yO2dZYn?=
 =?us-ascii?Q?zLFYDAn2Xn/SBjvApJPCQkfEIV4eiheyevOQdtzRMocldhhXabhk3ujqxK4g?=
 =?us-ascii?Q?VJp9P+cqLBGQCHN7N6IJGyaQsE3FD7D2Pvxced77RF9vWY38XqN9KQ7AF/wK?=
 =?us-ascii?Q?nfY+VTEmn1O4wkh4KrUhhJd5lfksBhfltxKT2XVpGeNyiUBQl0gueHXIbVez?=
 =?us-ascii?Q?YlVVC72aHSkB+dqQb8XEHSt1Zp6Nprce6CQoE43vNEavxe0fA1PUCzQeyTOE?=
 =?us-ascii?Q?MHgfygtA7IjJLzd3oeDzEi1F8ZXQHqqu0A8dGRpFA2p+QTRKVr+pk68ldsld?=
 =?us-ascii?Q?FBN19jnZQ8yVK/co74NNZ0WWiOs8R5iqno+IbTa/lLYrZ0KEuPFhkv91k76q?=
 =?us-ascii?Q?mDZu1jed5EgQG/q1m7FdUaev6poNaIbqFEknlmSaxAbRJ3AiYwKeemusz7ca?=
 =?us-ascii?Q?Hnx7efKFUwSImsYjVnJ0iOxQ1zn1EQiYeNUP6mIxLByPpTw0BW6qbZvVDYdF?=
 =?us-ascii?Q?Kyi1oL98VDwtcUQABSaLM9R6/n2kOiE5Ivjo1sM8BSGjfXnPJrLKDyu/igWm?=
 =?us-ascii?Q?h3A2FwwQad6fvg5GBmnR3ND6FwcrkUY0FosShmhWmtH7QKfDlsSbB16WHErZ?=
 =?us-ascii?Q?/5wc944+vqcPz7/La+2c8msem6jOnaNFPQaaz+MWNxiBI2qGjkpYPnOga4im?=
 =?us-ascii?Q?MebI8RTUZle5t8273Ms8FlIQKU7Z7QaG2xtMWm0rOEbRclPt8yait/H2EDPd?=
 =?us-ascii?Q?vAj+9poHH5dZOJWfSs14Kga73O1w7v9tvle8GR7oANy37SUr09YnQLqtuSkA?=
 =?us-ascii?Q?AFNyteASxrT9J6TTrrOYW0AbdRu1m+IikHQYL/z2W+uC9n8ysBs6RmHUrefO?=
 =?us-ascii?Q?rWLGic2gWJ5gB/S8Uaxr7zYrNR78hy65iRvxDt4kqfNJq9BTw54ZorHy30P9?=
 =?us-ascii?Q?CSGaqH6PQgTZYk9iLWGZw1imK+4H2EM1tiSXuFHGB/BCKw3af+QkBKCRtFIW?=
 =?us-ascii?Q?TNzY0wDNz4qWgtboXz2AK17fpLL0TXiOgQdIMbfOiEhsh86LSxhruHODc4wv?=
 =?us-ascii?Q?aEJF2M1s3u6IBM1FZu7RP6w7dBHdI5Wzt+zFgS8pmRqHTDr08Hyk+NKxMmfC?=
 =?us-ascii?Q?zMTGTQ3m4SmkgT3jFVIHxTP7HPqK0wCCZwD4692ePh6FNeocH3ABXiMNPVuT?=
 =?us-ascii?Q?8mYpevI1nqsU6lb7i8GRj9eZJRPLVrp0KYmwcE+tiF1hFS3wadH8D2SwAuT8?=
 =?us-ascii?Q?AMf4xxt0wGYEoHPOtSUWVnroP5EFvl3GNQqa92FdOWLth7ZuscIvfSFvMn7k?=
 =?us-ascii?Q?0/KSU5zc3cw5TymXJjmJZaRH4Rbsnk+5YOL5S3wFoHsP5s9tL9cS6u9B+Pzf?=
 =?us-ascii?Q?0R2mjug+riDtN4Sxj9SQ5UKJRAYnt/Jfl1pKxWqJdmM+QVbxhBqYIGNOvK3T?=
 =?us-ascii?Q?ztr8Ge0cH5U6ajGaoToyyU+m1QcvPEI9F3YDaeg4DMMDbXIcuGaubeJZEZcR?=
 =?us-ascii?Q?9EJBdpVgyV4CDuYJkMGMVOu0ddL1h+vkcWMMi4DIyVqxCikEayjqcI+Hns6E?=
 =?us-ascii?Q?ZdRLR5RNqrk54FzRbxywQdwRmYWAWSrysS5BCQurH06UTT0+cEmyhAiNNsO6?=
 =?us-ascii?Q?Qwo1uzGxl7zl6Hlo1Givxcnbxegy0iouT76vQjuAsHsg7GBYkebiq/yxeR0W?=
 =?us-ascii?Q?YJ4vJA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9e72bbb-2075-4499-006c-08db2d297964
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2023 12:07:15.8437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8NsOO9qOzX4XiKnhO81SlCvHIWly9ze372SsEaJKF+Ky2x3Vmeb0UNbc+CssjvniDa/6vuGCDyljdUj46T3+Kh41Yk8QPC2kRQ9OurSwXjE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3938
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 08:45:11PM +0000, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Translate the fields from flow dissector into struct efx_tc_match.
> In efx_tc_flower_replace(), reject filters that match on them, because
>  only 'foreign' filters (i.e. those for which the ingress dev is not
>  the sfc netdev or any of its representors, e.g. a tunnel netdev) can
>  use them.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

