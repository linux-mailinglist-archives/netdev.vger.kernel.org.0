Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0052867F9AD
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 17:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234077AbjA1Qwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 11:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232929AbjA1Qwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 11:52:35 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2117.outbound.protection.outlook.com [40.107.237.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DA52B0A0
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 08:52:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a3etOkObWbpuLQWYwOvo0VFu7jELDJDTtH5rXRPXZa+2Mluk38qB41+4eRKmETIDM2DLlemEr7HQnvpz9K6dJO9wdDh4MuBlPfN4IwinuH967zy6k9cdntis4NzSuziGXhVPnB14VdsUBc4/c3aFj/ffIXoPTbZavMe5i9ziciZcGleHh5Yk39sAyt8yiWcTpAxlqxp5DhErrZC2Ne7Ik9CDEGbzDlRdFDz/IdiN7vS/SVF91cWV6uqG+EwUDYtZ+3KXU2YsmOF6eNklDKIOxOKQXwQ2Kk4WQSWiNhGZSHrGWp+slJ35au/c6E5UA+OiSfBZSiL5yxCK5sIsAvpQeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6bzDeSBFIz8PZ36C2zbIZZTBK+odvElXSk4tGbMvkxs=;
 b=iRowLyu+4riftfYho57whpvF5Y1Lh67YGtI33ig5gG3pG2sBlkJIHoZZTNVeEcF0909Cr97TimgiUB/5CwELVT5TofqREzphicLJ2n8Fr//TCG9bDqUGmpu2EUDRlgdZ9kK6uL91eT5W24jenj60dEdh71imYd8aaEDoWZTP256KXTURLZd6Tp9k+IKzxJFNiBpIVNxFGnyLXtCyE+0Hlt8O00sJFmw++ILlEUDcemfkWKNc5yayopclwCPSIGxZd6E92siqCCrC9cQUIrWxc5BmFCfrHwExGsKuPys/ktDlF7kasksClmT4jrk6dj9xALkcDGYeKhGsFJwaYp/Vrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6bzDeSBFIz8PZ36C2zbIZZTBK+odvElXSk4tGbMvkxs=;
 b=MDbvTFEosZdr/NPUKOlOX8zMo1sl3+droHniVxqSxcS5qTzc8z3G5dP7kYNu7bFIhFyzP4I1PK4zMcVCyOSpM2AEcswJRcz8X5nd6QBavFTwgCmk7PCBLT/yQ9QBEm3FsphO40OETbU9ytDdlHQcZ5YleXWDMi1RtZjyeJ/e5Fk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4922.namprd13.prod.outlook.com (2603:10b6:510:92::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.30; Sat, 28 Jan
 2023 16:52:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6043.028; Sat, 28 Jan 2023
 16:52:32 +0000
Date:   Sat, 28 Jan 2023 17:52:23 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH net-next v5 1/6] net/sched: cls_api: Support hardware
 miss to tc action
Message-ID: <Y9VSx/TgS466Hyxg@corigine.com>
References: <20230125153218.7230-1-paulb@nvidia.com>
 <20230125153218.7230-2-paulb@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125153218.7230-2-paulb@nvidia.com>
X-ClientProxiedBy: AM8P189CA0016.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4922:EE_
X-MS-Office365-Filtering-Correlation-Id: 200604b6-2883-4a9e-4b16-08db01500c97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: csde/HgcmcWZkVrStG+k+kiEtSmScsmj/JHk11XTYnrDBN62frk98nOEWOBq9W/x1VCMyvlbWIdyU0daWKR5gv9VfbNwhvi38dCzrsKw4RfRT+dOPN9uD4ub3bNOOWtslh3iSSauNw/5ovhQic9cRtZtsOS+rUEsbrpYIHg95zpdg5E91c2cxD0I1Gburtmr8MEtOGt4YXiuO1f1yQMk0dLpolUt5pFJqNlb5/JuUX/PeMpSQx1vu1fpi4Cg/6NJHfdSJFev/sMAhf573L7slUQCGdAURgG01RETmSEV8CA4LiZvFfac0U79ZrS2Li8c+jPAH9k2xiD8nt40eY9Wh5qnoRe51e360/iYXmSyXeleUHvkHAUuPSqMD7s00peKjwZSijcRfjOyDQGFewUOS8zS6we4xZDOSi19JQ/4GrNBNFhoWmHhVGnX7djAo/J90tDSg24TlA1y1OA+THpHCyPC4jMHdgU4XKpjbI25qraAWE2xIYPedO/1O0r+IChbsQKLC4NIrne90RckX2mOV0oYqPS/Dw1rqxebA6Rxi1euVlpC3aOkQlOZPXpZUL2XeeLV7PciUtv4pzOVdKrPZKoWd6mLn6nKOogtOmv0IoxS4XIeA+RBe97l4buhEgz6Fj7bOr9ejq6y962t5mTAvrgoE4SX4WpBJyC67n9iBRAlw6CVRBvbE029ntJdk7I1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(39830400003)(346002)(376002)(366004)(451199018)(4326008)(66946007)(66556008)(66476007)(6916009)(41300700001)(8936002)(83380400001)(8676002)(6506007)(36756003)(2616005)(7416002)(316002)(54906003)(5660300002)(44832011)(6512007)(6486002)(186003)(4744005)(86362001)(2906002)(38100700002)(478600001)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mPKPWbx19bINIVjFVtoj/t4zlypUqNB6stqjNYCK5uJRfLtC/6t4QedxlZix?=
 =?us-ascii?Q?FIkDFW1za/opnAd2pwPlsOaIHvHw/Rj7pIFgyGyEwt9gVVEtkrc2oD2Ah+kJ?=
 =?us-ascii?Q?IxfG6XzVYgJKKEaib8Eem5rv4RHXOUoiY1as9bhAkUKCXWFjnDqTQp0XHNYF?=
 =?us-ascii?Q?qBLhLihjsspeqD3nhJo52vjDRD5UjATJ9tV8jyEpjXj9kgjvKkYAQVDKOFP8?=
 =?us-ascii?Q?+DBSiPwysR+XXnjiFM5UoWxDq+AKDqXMh6wIgm1YU1uIrPYG+ajF3Yje8BP9?=
 =?us-ascii?Q?OWba+x9p0C0+rKyqX++zB/yNAk47CV8Ktvw+F1UptZ8sUs/Dnvvj6aEeWjmN?=
 =?us-ascii?Q?2Vc1BSSF5ldSQZOty6tGLc/KkiJyADe6Dh07j0AB+VKkua5Sj3c346XOeS/y?=
 =?us-ascii?Q?fXHALAPqgV09y4SL+H9v0AvTLlV30UGwfwp2q64F1t70ktBy1Y94NsWsewb1?=
 =?us-ascii?Q?05zsr5+vzdK1GImRMaCJsboztLGgSnqYrs7LluD7jlubMer2WAMiZymmAKYX?=
 =?us-ascii?Q?I3nJTlYDNscGmAaXR6bhN2zB02/57eRPlWl/mrguGogB6aBYuRsf2NNhJXIt?=
 =?us-ascii?Q?XQwxq3s6rl5tAGsiGkM9vdv6nDfkkCRn7EX0HrHTaypyIfYBLk841gDYGkNQ?=
 =?us-ascii?Q?r78Hd4uIFb8Ek+wUveeYtvhtpSsNnkrKbVHXYZGC96P+K4XjXKKGSvPjfct0?=
 =?us-ascii?Q?Atdc6SPC+r9xsM4JyGuhRXWZxMN17n1gBTYzD0oeomr6qkY4QLJQFGmdFv14?=
 =?us-ascii?Q?FnrDb1gldvqWuff56Z2TWDmW0p8kdz6TaG/Z6YXC5KGkOV/vx7iQlK9vkzLg?=
 =?us-ascii?Q?3Fk5uxEhZzweNwfv3x6PsE/YwgHq172SwDm1oRMX4v93m0KH86Ei+FkACvB1?=
 =?us-ascii?Q?ZHBHfiYl0TUhv0e08ZDukfO16Z165z46oDyfEcQD4YRHeuIwDwnSiQi5uays?=
 =?us-ascii?Q?7kIe8lDxdkPpEiMB6ssooL8gV8X6MttL5BlaxZ7TQZ+wJaWszTt0OIHNSSeR?=
 =?us-ascii?Q?tieQUHyw+DshTa7/ywhyniXoArng1CRzRdWpTIiVi28XclfM7PCuOxlrdn1C?=
 =?us-ascii?Q?igIPw/e6ahp5OR9jekMfMnv2iiHJTn7Dec2SQeLG7sLXLSgSTMb4kNErkNil?=
 =?us-ascii?Q?3qF65aYB64u/+nlTCEMqU2vAXzUKZAhm413x2btIwOFprX1wrZxJpX9Oo4tb?=
 =?us-ascii?Q?fD+S3AbEg02H/NAVqekna3ckLW2BKMonT3AhjC1Se/hXCa4vDJDzuOQuwzF7?=
 =?us-ascii?Q?tnBTexGYOP9O/TFRaiKvCtwM7JO3i8Lx5piiByw6XrETC851ci+EJKq21roo?=
 =?us-ascii?Q?FyRCPOeyzA1Ydi0Lc07DAS8Gd9waJ0TftlI2EYSK7bKmmoOT8Ohhlcsj1S6H?=
 =?us-ascii?Q?rC9C9JX3TWvxBtERp4+ohX73/e0SGPUAEE/SpFARvVW4k6Q0xSeDEAQG0VBe?=
 =?us-ascii?Q?ONlvUorcaZipyu4WnOTug9n7olXraMsUru2FOd07MjVIFaD5dRpmgwbODyHY?=
 =?us-ascii?Q?bkbWS3z2mRLZanpotNwTb0g1l8NGVTsbayZNaXIFPFQjpRIwpPfOLY2H0kVd?=
 =?us-ascii?Q?QXPeGqrLZtVxq+/6Zy/W80w2QkuTVVQ1YWPW3RvzmY0MQKkl1DNI17rFdryV?=
 =?us-ascii?Q?HWGZWxYVuKsatuO4oTXz41ONPbTqcE+fkrrRVxfoUBmN8PS98JfqDEKZXUL2?=
 =?us-ascii?Q?m/7deQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 200604b6-2883-4a9e-4b16-08db01500c97
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 16:52:32.5496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y7jim57AGNlMFqsR4IorRpR5ChoofzcvwZ4W65mNBEDk0Bb2gOtYoQlqm0BQco0J2aJO98F18hFlo/VFqGteBaA+TRC1aB+nimXlFVGsQ3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4922
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 05:32:13PM +0200, Paul Blakey wrote:
> For drivers to support partial offload of a filter's action list,
> add support for action miss to specify an action instance to
> continue from in sw.
> 
> CT action in particular can't be fully offloaded, as new connections
> need to be handled in software. This imposes other limitations on
> the actions that can be offloaded together with the CT action, such
> as packet modifications.
> 
> Assign each action on a filter's action list a unique miss_cookie
> which drivers can then use to fill action_miss part of the tc skb
> extension. On getting back this miss_cookie, find the action
> instance with relevant cookie and continue classifying from there.
> 
> Signed-off-by: Paul Blakey <paulb@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Signed-off-by: Simon Horman <simon.horman@corigine.com>

Sorry if this is a duplicate; I did something weird the first time around.

