Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC38C686753
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 14:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbjBANpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 08:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbjBANpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 08:45:44 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2115.outbound.protection.outlook.com [40.107.220.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D3B4FAD4
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 05:45:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j/0Ha9evIOkdMXEJLcO7Gvf+BgO5exlk3gMLvQFEUZ7VKzERMKhmlG7Rf9EsbJ8z9a8L/UzPUtc5ALt9ysoBiIOHLIChf+v1esAuxWKMwPiXmbeUacEKfza6VCKbs81Aq/6VkpZvao9wBBrie8Ef1vvSwB5d/5T+kFAyx8KV5IJZKNVFnLIhk/lHjkAraLMQNFedvEPsJFZiPS+5u/bJHjxgUvGiJIi6+LQAG76gAJ7gfTS8ssTFPYIxH4g/YHwRg4CC4i/Fls7wKo2ezRG+1pyWO1qmEmBvAeaF/UWNxzgr4ySeEZxuiQJ8TIlqM+jHo6VLLSg7MmXFmRD41BjYGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yROe4vdW8WJFowVJBJw5xeapBNHc4+EIEC9dtCh7lkI=;
 b=IBkse7e+it9VKlczN8kValF+mf9LhU27UftYxjvnLnrK+VboQ0ex+L/Ngs+S84A8gpJfOZMCsqDS3NSAKxW/Qk6mW12qslXVou20F4cTKN+UTe58fRnCaHGgJKS3CuzhCDNdI87BlVj1JGRd5Epd700Vvgl7Px6bBxKVmABYDWDUHCLqrc82J0SvWgF6SbevW9QkoIP5RKJfX/rOF/d9dddhXsCawfbYefA8j+gY7g2w0oRo01o2IkilH7BUcFDkI+uCSCTBix1Kxcb0FhUrbqdfjKt3R/FDq84mCf0tctWR+cYiFwYfa5PTGghetkXkr0nwNYiQy/L5pM2tm5m/FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yROe4vdW8WJFowVJBJw5xeapBNHc4+EIEC9dtCh7lkI=;
 b=OrsSsTHHK4oHHGb9egyYNU7VcBga0iPi8HKo/QwXWuPb9cJX1TEWq9L1GOLB4Brnzm/40SkcZvXllZnMZsD3w32HCALvsC/seKqueSkmbT1B4iraL3bAvJW+bYkIaGaeCTEewZ0Ls5RL8d4x5PxawhkA8yXNJUOMEIN7El/+Bk4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5541.namprd13.prod.outlook.com (2603:10b6:510:142::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 13:45:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.025; Wed, 1 Feb 2023
 13:45:38 +0000
Date:   Wed, 1 Feb 2023 14:45:31 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH v4 net-next 02/15] net: enetc: allow the
 enetc_reconfigure() callback to fail
Message-ID: <Y9ps++OpYNNJY3TO@corigine.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
 <20230130173145.475943-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130173145.475943-3-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM0PR04CA0105.eurprd04.prod.outlook.com
 (2603:10a6:208:be::46) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5541:EE_
X-MS-Office365-Filtering-Correlation-Id: 078512f0-4dee-4026-34b9-08db045a9a1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BpBs2pdfSQvz3vBFTUrDe2+A6wam8JOKOCcOeEBQG4aTdZaDxQ9nlEvr4NsgBfNglnuhUWLiNC97DHefeakH4IuCPIOgsL5qNTU2pPh2B2miM2UgtIFSGNtN3QeeGs2Om8QkV4rGovxwILhIYltG9U1bLbwa81MXKc0uYKXYW7F3Z+dr/QDACkFsvVUHt0HtWKnA4PfggSsZunAq6tO53JxIBBMJO1t1G31QUwOUD0o0Ch84bCeeGz542v2A+rg5hCMruRU9SJVqyhmrv2XNqB2IbP8wE0AVT3EWqCn1CIdcw6yyPjuY60HP/46OH8J5JJDuTe5eYUeTKF6xkh3TvpbdMJRb1TNPeEAKkI3vbzQ541vnYMxsbyoS8+J0ONU98AUFGHP1Bv0i+FVoxFy99SbSS8xIOXFZCFgPgOcTvMdAhxcli6OWP/GJKHVew2wkJ1BdFpwWOor6Ts4/6Xjfby38iMiEI4lFTz67B4GctWgVTK4Y7cnH3F8TzsMcE9OViFi/pwO4VlMt3o+X8maXaPq52wNf6t0egzLmipNzAKMiwRrGu4qyUIuQSxojsq0MAkvzp3Bn6EB5ckwqqwRAmdRuCzTO4NErSR0tWQ5LppS+HDKBMQX5nBWmU0Ie2I0pSal4QQb13+tnv0/K1uxzJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(376002)(346002)(136003)(396003)(366004)(451199018)(66946007)(66556008)(66476007)(8676002)(316002)(2616005)(86362001)(38100700002)(54906003)(36756003)(6916009)(186003)(6512007)(6486002)(6666004)(478600001)(6506007)(5660300002)(8936002)(4744005)(4326008)(44832011)(7416002)(41300700001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+Q3yi811IOHp46dUl2nhDMG2U7tINL4ro4kPweXruBMfdD5iUdA8b9IREH1m?=
 =?us-ascii?Q?MyLwcuY8jSJAE+IQsAYNI7RhEI8pnk+Oq6nBbHPS1tnjIz6/OhC8Ifs/J3Ag?=
 =?us-ascii?Q?8BjEq80CkLJltK9C7rU/utmrhwvccGhRkweqr4uBPJomLJgMa1tXB2u9OMHX?=
 =?us-ascii?Q?p0ACWdqsMgLn6cNIFzVzctrU/6s8DgfaVHPjsJx6HHdo8R6MVj+hJSKaTmaI?=
 =?us-ascii?Q?Ph088mvGzvegPAXZksfF+e2m/B3e0jRSbBCPUh/HpuGtIjCigoVGK6AeZrS8?=
 =?us-ascii?Q?6lbDRsk6ElS8yT1wjDpfJ8S3Db7g9nehge2ipBW5XlB7ywgzpYNdGidibaq9?=
 =?us-ascii?Q?qPRn2PAyZYjCnae2NnrSpcjiYBoO+e7y57GfXGXg7lpAIUooc+fX/ncwc85K?=
 =?us-ascii?Q?upNEnNxU5KSLbdi5+1Zc+bJw8srFDUelBkotH5cBimK3tIr0/BpQC7pTC+kJ?=
 =?us-ascii?Q?AfSpl2cpK7cqm9LG0o6br/9Y2Un5Z4bzKO63/AwyK7D04cvRGlOZo/0Ra0sx?=
 =?us-ascii?Q?qjIxozX3I7fJgTeUajBBYMW9G/SmIUUmB6qRq3YULkpbwTNdOm5o+k5zc8/+?=
 =?us-ascii?Q?BRgRJfAKH4nDuTMhkIAkWOFiIoeW/Ky0niiBH4LIQVpA6MsHb1g1ps1a9yRm?=
 =?us-ascii?Q?w2s5DQA5nLuqCehbjOQlNYLg2RiQtUWuFtOhntgciWxEnQ3OYdAFOiNi/ayv?=
 =?us-ascii?Q?B+ICpR68lh0ojH6bTZgLozeIJN4ELcbbCTSv97qR88mrS5SeELQfKZ1AV972?=
 =?us-ascii?Q?ugmAf4SF3Rzt4jnrULJZ7C/v7uFbDV6dyEkyWHTwpFRNNr0sURF4c6ZE0E19?=
 =?us-ascii?Q?b9YFj92yQ6cXQ6v+/GWXuHnfo9cKtAOfhCbChNy+XhxfAA6i+GhiQTy5eOSs?=
 =?us-ascii?Q?99VtE0GPwJxbkQ97pZBut/OgM47fXdjLpEagqvnzo0FvrPb/OrmYavSzWekg?=
 =?us-ascii?Q?T9sFEQUFGYtFQIdXei+zzdcMbIVRRvOc1xVN401AKSoPW7vb8P/7Zj4rdt7y?=
 =?us-ascii?Q?umNRUkJ88aTyEGWNwYBu0ckE6lgmctsEFbnVHbq4hvs3CteY/JfZNhD4BEYM?=
 =?us-ascii?Q?LsERqpy/sISGyGQGiN7/rd05xujqv1luLw2JMBmouEhzHOomYot94WLOTLS9?=
 =?us-ascii?Q?IfnbhxMYcU4ljiJU71YU84o354GyBqxvgETcrljj697VP3330TIIKrhGbGAM?=
 =?us-ascii?Q?k8TbWY+82Pn/0T3vUM1UByMBW3H5eDMLy1UkcZTiaKko+5pIvuS4FAPjs5CX?=
 =?us-ascii?Q?ZYsLhHjWj8IysyWEgORHGeER4o0U1Dx+Ajm4+dLB1zJISkjmG49EYlq8+jZ6?=
 =?us-ascii?Q?dc2mAjgpagrr/L5WzHk4aLasPuRpqHcLzAWe2buQfC/8Ftx2nywPQ9JZurLJ?=
 =?us-ascii?Q?5cLViS+xHYFd3J7UeSnoQJmgJRRW7rE+5xUjQtZTt7ocRDwxycu9ip4qi8o3?=
 =?us-ascii?Q?vm0TCVwpY/l8Y4VHHs1EyKUeLfV3huEcMxq16h9dfD+atsQBFOUOHVCCzL/T?=
 =?us-ascii?Q?EPnYtuEVN7ChkAQeRd09WNhotQ2OjwFoGc9eGPZpFjt0EHHZDsqx07ZXjYLG?=
 =?us-ascii?Q?LmmOY908RdALcNCTZUr2gfniUIWrPAagxELoPyyiaxdpaa1FkWrfhQL7KFky?=
 =?us-ascii?Q?X0NMJrATjwZsuQF5WVBMl2fm8M3ujkm0iaKCH7541UPWxMDed2EVkF7cjyuH?=
 =?us-ascii?Q?zGQkiQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 078512f0-4dee-4026-34b9-08db045a9a1b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 13:45:38.5379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5YKh2AMLiqDfIcge4MUlABTvyjP5zKLO7N8I9AF5bImjhQ8r0iiYf5R/YNRMw/DOADyJZh4VuErZey5aAqqN5oVolINNcoogiyc6Gb4LMII=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5541
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 07:31:32PM +0200, Vladimir Oltean wrote:
> enetc_reconfigure() was modified in commit c33bfaf91c4c ("net: enetc:
> set up XDP program under enetc_reconfigure()") to take an optional
> callback that runs while the netdev is down, but this callback currently
> cannot fail.
> 
> Code up the error handling so that the interface is restarted with the
> old resources if the callback fails.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

