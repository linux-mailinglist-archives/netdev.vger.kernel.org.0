Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01AF690E7C
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 17:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjBIQj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 11:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjBIQjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 11:39:55 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2128.outbound.protection.outlook.com [40.107.244.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD6F5D1C8
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 08:39:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T7M2zmjFD4tEhcIcdAoUTt0m4YFTCnMflVdsotfcuJxJrdwwVDzhER6CL4opU3WuGFAEAuZxXlfy1VbU1Y9y3zvJS/bVTDiTl+oDkDMF/FmS7hjP1ZDe7GFzo5fhjd3qLxJWWXVRcLd/VFwIlDMZp+x1YTUQIbYauWGpWPVtCGXThR837LVT+fTMDFHI0a4HOqBa3XnwL7GQhU7FjAmcTv2EKZP7PHqz7kf/w4UbnTx9p5RupfCts7K7PMZZRT5ZvgEST7FRdF5Vfn52//wQ48Cs5GRdoqr/6XRo+JGCwBhsTL4/vG8oLabq17R+aG41nnMUr5/Ap7PTLyoFBDffdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D2hUKKwVB2TSX9Ada7uGkqmEv81WVbLn9BzGwrhRnKc=;
 b=keqIpefSqDWY/GbgRAQXeyCyvnYlzab+my5rA9kWdZi8ai+L1J1A6bewPW+j6SpxfxpEMtZPu6IdVY90iMjZKnvM2WbX0ck1Nh3Vxyl+1r0dps4rJWl8fvFXoD+agZlwJcX+6YjhPHupr75lZrotf31XSNE4f/sVAaS5rwF8OfHRQTAFe80jhQQd804dROeTwOY+FTG9PeispO9kOXX5cuzdc58QGu0ZHOxsqjXuCvvyq1VF11Pw5r6M3HePPFxIYCCNuOY1hYADORL+wbZ2rA0lts8ZNpycS0pHe6BUPMODrZhtyALSdEasFfJRzQGLUbeQlL3PsjX6JNLgnIKxYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D2hUKKwVB2TSX9Ada7uGkqmEv81WVbLn9BzGwrhRnKc=;
 b=L+dLBOAsJ+AirpYdkyop/nROH2pmV7y0i3q74+RSXAreCSvIwc8Ro+1teEZsFSv7b8bor9JqL9x42PBtnCdeWWEaroy+K8Y8nY8A15L60KVAvMnoSs1SvQXuySYwcS97OWvLgWgnUL1/VvWQRu5JaRz0SnRXf5fpuY6jlzujvdI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB4909.namprd13.prod.outlook.com (2603:10b6:806:18b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Thu, 9 Feb
 2023 16:39:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 16:39:50 +0000
Date:   Thu, 9 Feb 2023 17:39:43 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, tariqt@nvidia.com,
        saeedm@nvidia.com, jacob.e.keller@intel.com, gal@nvidia.com,
        kim.phillips@amd.com, moshe@nvidia.com
Subject: Re: [patch net-next 1/7] devlink: don't use strcpy() to copy param
 value
Message-ID: <Y+Uhz/sKDfTb0XoY@corigine.com>
References: <20230209154308.2984602-1-jiri@resnulli.us>
 <20230209154308.2984602-2-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209154308.2984602-2-jiri@resnulli.us>
X-ClientProxiedBy: AM0PR10CA0101.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB4909:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fd4914e-54fc-4415-d37b-08db0abc4315
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lvBvHkzbfZOgzUkV4Lop1suvJ0uk3kkBuc8JUaPaTdy1jvjyEg90PxghyoL5H8PsRJyNvPj9wp/0FVQICeVbTayAdAQhadIRGtZwpAQ4YDogrCCCaUW0/gxViokbzW7XSgD/ivzU+ysMB830hGBCpWVEjhqvMnsVhniVAn3v6oWL/KSTNRz8HFfFxEySzIR9+zWinMKSmPAW5S3QfM9a8HpCLWsm+IaEJ/Whm4rKoPmmUE8HUls93aNNUO96WVukfNYpK/3xeQadO5/5DfNgjkD24rQqJbkhRkrTpO1oKG+ro1F1b2Du8aZTaXGIQOXZz7AOII36+SAYj60Oj3icu/PSm8iSzmhFDJdfVeOiPQcUSGzfs0Fa2PyU5r10pQgy8AlAwoPAFkZtaBdcj3RAlfglt9MPFFMe7n800Bu6wlgaZMLmtPXil1wxQpvaAlmoVyh84rAFDgVbAPZc7WJPuGBrST2xWwRDwTnH84f2OyvxJvE3VIens2gA16GRvE6qN/tpAbvtHPPE3Af1xHpvcI4S3577jnT8LFVmgOgKYPijNIBB6DcPXggbLr6uHN7SsN86TM1QkJK0XaDNVD9FvIRDHDz2Otr0uVecWsSTFt4E52kdq69ywuY2c0+cOEAOV4TwluuIRuW4VEqtTYtPdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39840400004)(346002)(376002)(366004)(396003)(451199018)(36756003)(4744005)(5660300002)(2906002)(7416002)(44832011)(186003)(6506007)(41300700001)(6512007)(8936002)(66556008)(6666004)(316002)(478600001)(6486002)(86362001)(38100700002)(2616005)(66476007)(6916009)(66946007)(8676002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dtC+vmsLoJk//2v7depkY2eAOGlk56B4sEiztlxRbW2oY9RHAuGXoj4RELPL?=
 =?us-ascii?Q?cw1IyE7iVr9Md42DneaoGSoh0+KHlq/VeVEvCubYxOnXbUheeELkXL3mBPeg?=
 =?us-ascii?Q?BCLpNdvF4AyEmTulhi8x61sFeI71ktP4TP7V2ltrHqyc/naYO/btDCzjr0VW?=
 =?us-ascii?Q?Gx2iCy15i5ja6Wxjs81halbCejrIF9kCPzNhXmUgvfVGj6R0uiFMmrD10Nki?=
 =?us-ascii?Q?Mon+FNHMA/4GcIgK5WpnT9lB0s9eRxFNHDWUERubqFl2fPqW3L6u8dWiOoUs?=
 =?us-ascii?Q?c8b0fV2m57hNbQZVC4JuNOrNi8QIXi4PFvJRV4KF7F0VIKPwS07Rv/T7Y2PG?=
 =?us-ascii?Q?U0SxrRnpv0avC8r/Kqij8SN9zw12HhSlDXEIbkOfueRPDHB2OGv/3z0+HW56?=
 =?us-ascii?Q?Htiab9lNTkMdfKucnFTnTPpRaIWRR6ACYQjy7rk2qonmRiNQuP35i4DD88Dl?=
 =?us-ascii?Q?p3EioRCxDc5jE9o1HH1/Ejoxuukkt4SiXPnMIc1sgAqtcxxrMgnLAfbW5fzC?=
 =?us-ascii?Q?hbGE6oWlylQ7FnxyoyfIDzzKFWx23a1jPkoRbsBzzk1v4eqEPOvFDgpheqXH?=
 =?us-ascii?Q?L+d5jhAUrpKesYcwC6rrSJHzuJunwo4KLNx9/EVuNPceZypLjOqfzzMj1KJU?=
 =?us-ascii?Q?VEZmr/ByQqqomTTMQTHMTda6YrOJ6Fr96fF71Hm8xQnL0+jjafSpvTGD+Mgd?=
 =?us-ascii?Q?TrLfIOUB5S0JrqnUd0/PORotTs8jo/DpUqo41yDQBXa4YIQ18+1QM0SUh/iT?=
 =?us-ascii?Q?27nrXYoKX/3qfWptnO51vXTLlGpLDI10nbPanzP22EXLhYTEFPgNK37gz1PG?=
 =?us-ascii?Q?Oe/pG9pfDU3ArjYu63hOMaXX7VNOC2vI/VDLupFRYoUzFx8MswYHX/L7dVCO?=
 =?us-ascii?Q?/tWTXcQxqCtrhnyJwcK6su/C6I4XAnaKc6i+/F21KMzsurYi4A2KUqHWg5lT?=
 =?us-ascii?Q?5o5clCsFLvD5n195OeWipUYpmtuMxDEM7e0v7cfmUVq7l8c4lSwZc3eVCiut?=
 =?us-ascii?Q?wA4AHq3Kq2UdTFIk02vMslkAdcL0r17HMNddJuzGOc2ZTi3Wy8zMYUl6CmGa?=
 =?us-ascii?Q?IHu21j0qwdr3qLjA8IfWuTGEOT0W3eKHqq7ObXL8oloJfF+bhYSf7o4WYKpT?=
 =?us-ascii?Q?FezIQluTWO0HQKIC2gN7feoCzEuywwyj0tIkXqOVom2AE1LwC1L64XO9Tt7g?=
 =?us-ascii?Q?j3rbBpqXKDzMlt1Rafwv1ogwQoouy+YDcXWRBCaXA9JBpeCv3JHeW0y9vR29?=
 =?us-ascii?Q?A6yHo7xmLujUpuf1QP89ummTw/LPKCfTIDFrFRVKX/8ivjPlbFnNzelEm3Jd?=
 =?us-ascii?Q?clZ01BAaVI+SNpK/p8YrAzuwL6PL51/lQRidShBwC/8l2riHuAiHSUXQQ9Or?=
 =?us-ascii?Q?Ag+2ukwXiCa/n14c4DZRAJU1jHuvEyLCTJmbPu3rh4ap/KocIEy7kpD5LQr1?=
 =?us-ascii?Q?U2AzfK9itcsKUz1c8wophDacdjRFZa9mRvnALibOVcYgbcHktM1GsIZbbTiq?=
 =?us-ascii?Q?FPkQoSdNLXbej3MWSHZ4r7CAPyMpUh0mVvEO52RxLurz1FeGHPio0ZcS2uWf?=
 =?us-ascii?Q?0Xp/2U4t8eBEmhcvmDxfpXBuzitGWwoAunoseKA+jzBBaxAjf54oxsUT093M?=
 =?us-ascii?Q?TBW6mlxxs7xl6Dz5SQzbGXlDElAasJw6iE0jrTHEPtZU2TTMq705Ruvs/tE8?=
 =?us-ascii?Q?6Kk3tQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fd4914e-54fc-4415-d37b-08db0abc4315
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 16:39:50.1814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0eTSNXCKcRT4xckazETvKu5apLg+l7FCTVBQmG6nYisiBvzL1kcsqK8UpKGV5GBS8svNqOZfW5Fl968uQ0Y41fvb80R0yDWWImIKce9iSr4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB4909
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 09, 2023 at 04:43:02PM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> No need to treat string params any different comparing to other types.
> Rely on the struct assign to copy the whole struct, including the
> string.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

