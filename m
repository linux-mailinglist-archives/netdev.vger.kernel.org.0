Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8498967F9A4
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 17:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbjA1QqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 11:46:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjA1QqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 11:46:14 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2107.outbound.protection.outlook.com [40.107.92.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378D72A981
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 08:46:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z70Pvl8+PK/Lh94UcoeVRDKzWjlCg+kZ+Z0dlhijPxKtwk7r2pFvZsTe8fA+JWQGxU7LaPgINNcQiYR2o4BmdXncGq53EcG0ZEJBD9VmeeA9EsRh58WcY3wl3N0F14bk0JNjhqbria37buxZDb02uWd9mAz9YWQfi9x04JtEGPA06q7928xaq0dWTC4lnYl5HsUv1SqErjJVPcmCy/NbFj34hF6YdLikLk/33gTIjpOW1zlXnh1WVysB5LxgPUcKrOVA1Qk346gdA0NIhuy0FaSb4QWZios9JqLQ1qp7YSPx/yybLEgUgraV8TAAgGa/ksiGZCEu9Hwwd5YGZtutug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=du1TMhxUOpFExQKs7SvSz+6qcFvatEvt+OJkL1W4RME=;
 b=n4v2fADdu3jUlQpS+bYceBSGJJYGeb5fGhntHuXjk6NHNbTQffz6XdfU6HZbq1zQ/Laj3ZA0RZjoo1wS4WfqDtaXBugmH36qjcN0uXzkhSIOYZ+xWJD+hOmdtKAWcYzvyFjYfWHQ3sgtX1JbwE4SucodcLrxmp2hAOVujjodPXENhrIuYPAogqFxKTka1OxwmfEZ+NvYbBcFXEy30PobPY6Bj574jrvJekXgtBvKo3eG0d89O0TIKssDlnysLh08wEueP1JUWFdbCZpPzrSAqBsuCjTs0bE5hMSvaXJiuXzqPZR8SljMZw0nvKzzMU/b/PFlNk3BNzLXf2rbCucHbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=du1TMhxUOpFExQKs7SvSz+6qcFvatEvt+OJkL1W4RME=;
 b=n+tJfUK4VVig6nteHmxhMwJG1RIsAK3wb6PPxDtduE/HI+KGgfMEtDQSDOtoDn+Vt75KaeRKrGtvTs7L2RFbuYwbcr6M/zof3HjneqOXMrFe3hVrN/vEb1bnsJaJ8HBpX9x6/XdmA+0k+vp8kKsCyHIqLg0HQGxP1jqTIqz4OtY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4922.namprd13.prod.outlook.com (2603:10b6:510:92::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.30; Sat, 28 Jan
 2023 16:46:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.6043.028; Sat, 28 Jan 2023
 16:46:08 +0000
Date:   Sat, 28 Jan 2023 17:45:54 +0100
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
Subject: Re: [PATCH net-next v5 3/6] net/sched: flower: Support hardware miss
 to tc action
Message-ID: <Y9VRQuwIyaTExh+h@corigine.com>
References: <20230125153218.7230-1-paulb@nvidia.com>
 <20230125153218.7230-4-paulb@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125153218.7230-4-paulb@nvidia.com>
X-ClientProxiedBy: AM0PR10CA0103.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4922:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bbfaf43-d442-420f-76dc-08db014f27d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8s+rGMbcPm2+yT8TDgOS+hhL1a4keFJm/2HjdPTIFzQPSoYSexhqRSCDrIkQne0crIaYkFZkQPZ0j3SQf08wJL6+mDPLF8DHPMg8P4DvHzZOHm9DuVq2k7aX/Y5uSFXodmvvm7TrNGPu2LgmIokdRk2UrhXh8dSA4rXdroS3SNH1FfNyiCnpITJkZlXyhQ5bArpgbbMBUaXsvIBkMehi+VGd+Spnmp0g1Twd+wyYX22AqrtxINqr9bHqkxiaOEwbGpPbpvB/UVA/RVLXsg/LRzLAcj+mAiN42kosQ0ZBgKsjXdpyBLDtzR+Ssf8klDxm15qjo9gekE/GrZcO9DofIbqMy8gLurSY0OYf+bT2Y5WjYVng4BCuDfIcPCgFZOLzI1fek7YygOIIZ4pj7gjZTnKsCeK9ctWTVDcxNlsV0DdBNr8Qy2ur4YnHnj5ySKt5HvbHkxR9xl5bOVh94daHp+wRX4ozoqOjnyJGC4OHw2vgHLBXmSqwtDKCZz+IQfJTVnLsuPICp6zkOTCClhkOfBrQmJmWvL4f95OyCfyySCunqNnikYnAgDkRI1vCYruSLqbkXhe+taZpqvdYHBa0wXPXeU1zfGLkgUF56PBciO+jTlQy1ESEVdFv3mLJXtIjMoWENScU+vEX4VE//n+OcdwaOWFfOMM8qa8yl+yqZtinRxJarYQBRiaAdWCdr3Vbgsu2OflcTgi5k/Jf8HQ7yzU9vdVpRKqNUnwWNz2hWNv6Hlv5PJOBSUpLwZX66RNx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(39830400003)(346002)(376002)(366004)(451199018)(4326008)(66946007)(66556008)(66476007)(6916009)(41300700001)(8936002)(8676002)(6506007)(36756003)(2616005)(7416002)(316002)(54906003)(5660300002)(44832011)(6512007)(6486002)(186003)(4744005)(86362001)(2906002)(38100700002)(478600001)(6666004)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C0jfMKyNdhVzFVeaXrVcym/6B47V1/1ebYk8rA16IGIDsF7tDJym9CzquNU3?=
 =?us-ascii?Q?I+/evRKRAOnq1Swc2lsOQiDFW3rWh1YjuJ/GmxK3YgRS2ggbl4JzQ03ey8Mk?=
 =?us-ascii?Q?XYSMoW4UrlDG++P4AUEJlGys9RnkXt+R/474elbxDTn+yPNaTxcNS/+qqecY?=
 =?us-ascii?Q?Y+2ANcQHxkOb1PVx0C/R/p2Xc5feR8tFwVlwS9He5tYyFxQygsMA3F6Qdl0/?=
 =?us-ascii?Q?LRrnEUDY/7YEnKgfIVhXrZbYzBfozhSm/1UvD9XcVG6f2fiZ3pqF7BZqEvPr?=
 =?us-ascii?Q?iktxB60vh+Rv3s1fzTTjo9S/1ABTr86N0IcZnrrtg5ALImnM1E3zaosnnJUq?=
 =?us-ascii?Q?BbmMxodzkFe2HW/LiXvK7Or0wrr75ItaO9LN4fcSojXs2F44jQ4CQWzFpqAR?=
 =?us-ascii?Q?DLJRi/u02JOWSbtlkvWSuNWaibtO1Bs6B0oQvtg+95SEbRpL56Q3RqLpf8rC?=
 =?us-ascii?Q?VTmBx0y6MLWpPu3omhbvR+CrRJgTFHpG/3e6Bgfj21aHPLUYtpqf8be5/vb7?=
 =?us-ascii?Q?QnRIVRTii/RbpySveUPqzNRq4g3offzxva7sbgIN5OVfcBnfWstIaXOVLaiF?=
 =?us-ascii?Q?cXgUTqjPxEJhZ+8ZpbSZK1aOI1CbN33vDJQsj1AQ+lcmjLuBuZRxkE6HI9UP?=
 =?us-ascii?Q?D3I47W1Nu1mvmYqBjQZK/ZgOfEjDZCPqNcRZEyvu2UTha/sPzGPXUA7t4gLE?=
 =?us-ascii?Q?prTY05dJY8f509nHn9QfEnp1czjb1F9yBmconIzhKdilMh3zwnBMLWjznDob?=
 =?us-ascii?Q?R0ohWqZ4U/aRssRorKAI0X7t3B7oyGjDHJB8VFD/TGy5y6oRGbV0wxLqR4Uu?=
 =?us-ascii?Q?vAf7A+0yZATbzejBeVaNgwSFrPht8eXcGElItJLgSvBrctPRRV+JTP4DQOCE?=
 =?us-ascii?Q?FhUMbWFvKczop8GcjUilwnPci/sXfXb4ZhuOb8G2rsAUWd0Ouf1Bf0/pY9sJ?=
 =?us-ascii?Q?chn4Hl+VEKS2+A/3X7/6J4Xv3DLW6AV9rwKsNUkNoZz+exFHspRzwNncfyOe?=
 =?us-ascii?Q?Un1vp9vPG9aA/LWzNjSW0BwH/gHVt3ZbpAV/qSLhXAoKNcrQGhHA6VSnVWzv?=
 =?us-ascii?Q?aOnMMhfjkIgBZtHPdPBruYmgGIk9xRaDgoIk+IMhCMHeySc3v4pKYXlpIOZ3?=
 =?us-ascii?Q?uJjGKcFLG/RxNuVE2SJcRShv6azNp2dRAuBy/X5IlEIZRdJkUwfdK3SqMEpa?=
 =?us-ascii?Q?xdzVqnL468WWkX4lpUSnnmyHmr8uM4WoYeDbq0gauiAdWTCZZmWa9fSWGPxI?=
 =?us-ascii?Q?pok6kCUdFbZtfIN1UIad+vsxCxNZY8btfJOQpXcSbzhwzKD7dLZM5/dspvTs?=
 =?us-ascii?Q?m93VKdvrGVGqhrHv/fYm6ZyIErVRb2R6WP7GGXNf1FJEsFfcnlrK9LuPkxaE?=
 =?us-ascii?Q?qDv/wUytbjafb3kuQD7xVexm56z/FCHlzj8e+YlwO4bXoGC3EJOKD4Gd5EQT?=
 =?us-ascii?Q?81W42mPFOI5/BivTe59AiWR0TEc9OsXvt3QDuFTCiMQMKYJy9lJ647/Po376?=
 =?us-ascii?Q?z4TCwepl9f1+8lZeC6eWAi805jW2bxfWLd1S60jAaRjUwFZxY7r+RFurxXiB?=
 =?us-ascii?Q?Kby26AnYvzRKGpmWD140f/YYlqyQl0IBftIKWj26UPEPlr/lUHCPWL565JXB?=
 =?us-ascii?Q?7gd8Dm2VdqbGnGa9/P0328kzmpNOuVfGzoUdknWoDgGNnPbryqdO0Ruw+f85?=
 =?us-ascii?Q?v39rxA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bbfaf43-d442-420f-76dc-08db014f27d8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 16:46:08.7316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iJ/OprBVZFmXMT80REuFwPbDJEdYp741h21Ae8H8x7R0SYVBWTzXLjaMSPm+kbphlKV6umzlUHl+IklEOsOYrn8Iq2Or1arZln7dqyQzvZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4922
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 05:32:15PM +0200, Paul Blakey wrote:
> To support hardware miss to tc action in actions on the flower
> classifier, implement the required getting of filter actions,
> and setup filter exts (actions) miss by giving it the filter's
> handle and actions.
> 
> Signed-off-by: Paul Blakey <paulb@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
