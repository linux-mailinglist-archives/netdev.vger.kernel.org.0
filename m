Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 157E966D755
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 08:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235789AbjAQHzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 02:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235843AbjAQHzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 02:55:35 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2091.outbound.protection.outlook.com [40.107.237.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34CB25E02;
        Mon, 16 Jan 2023 23:55:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M6IHMUTGrH7BdWsEXp4b4kNkys+QPoRw/GWpoPFX2/RlIA5XWaBWO3AsgMxKk/Dd443NSjABkPFF0bUBE92o4/AFF1UJqQt+sf05ya5dqAVeNTaYzxjWKHm9v6lUxScTkyscDF/8aT8G7NyEAmVnVhjD7Afsn5wBTcB7yWhFLaD9dHQZ3UX3Ek/T2163Zpk79SrxlxhVXxWKZplm7H3dXB0aiKww7hE83PBnqlDqRB+6w3oDVaussXI8j5UztL5i+IxKo5UyCWRGIPuZjllkDOcm95/1E/5H18JjwDZBGkjHgTtbcZvTcTcBsZlOhT3mxYspEDT0piK4NnbNZpk+qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=osxORDe3wTdR5iod6e2nx1FqPyWQS9Ul5MNybIHsd5M=;
 b=P28rjeD3jw4jxF60tjSXrOT0lauXkEcE7yNRWp3Vreu5TxqhVhQREPaoXrjpq+PWUrqUPFBnk2yvmG2BBAaSJ23FxgxTRhmvaGd3zMxG1yJL+S0BjdUZJlzpfvWkpmGwKH9DL9YHqGKDTZuduX4Kqw0cGOEvlriye9FBaF0O89VgMi9I1YhCfpObxgSodzBZK4U77qL7qBEdQdcWLiiB4x7lr9DtwEXzsZEuKhxuRXfi4776IfG32y7/sTnAdNU/EwNJ+IdoPYJ17emRGP6gcwsMdp3YXhaTINJ04lgewXF5wl5RDoYeCT6oEpLzc3/j9KjDWxcuMa4BVUS86gqHmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=osxORDe3wTdR5iod6e2nx1FqPyWQS9Ul5MNybIHsd5M=;
 b=QiIvzmfuwfePCoBde6qegYIVFqtuIXfkaJ9ZcklJjtvP41Ruc7ZsoxgjwkZXEg9FPZBeY1pQzLFrgOfu+UgAjWgteD45vNkJUL4LZLhYQ3vEbysBW4E9cOHWVf1GR0j4DOYhfJrYtCyIDlzVhfnVjXFk8OuwgHBJUZ7JdDPSQ/A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5004.namprd13.prod.outlook.com (2603:10b6:510:7b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Tue, 17 Jan
 2023 07:55:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%6]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 07:55:30 +0000
Date:   Tue, 17 Jan 2023 08:55:23 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, ozsh@nvidia.com,
        marcelo.leitner@gmail.com,
        Baowen Zheng <baowen.zheng@corigine.com>,
        oss-drivers@corigine.com
Subject: Re: [PATCH net-next v1 1/7] net: flow_offload: provision conntrack
 info in ct_metadata
Message-ID: <Y8ZUa+uiXWAklNem@corigine.com>
References: <20230110133023.2366381-1-vladbu@nvidia.com>
 <20230110133023.2366381-2-vladbu@nvidia.com>
 <Y8EghrLt1rtcYSv/@corigine.com>
 <875yda4dfc.fsf@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875yda4dfc.fsf@nvidia.com>
X-ClientProxiedBy: AM4P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5004:EE_
X-MS-Office365-Filtering-Correlation-Id: cda9bad5-6cdb-4029-3414-08daf86033f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kafVZqYs+QcF/ke3LQqv4d+5qMC1Oh8pHGOBTMrCISD4CMIElSoj/0/R0rTtWF5FOi1TL7uSS/jyQf2Cx6PxnOcTyVI50FnV6/2st4/2ZKOHeGJpCTEWfafrB5I2Ad7Yhq+1xJacLq8LEwelrqxSxf+tAPa8xH6GIlSaVk0ivaZWiEgSkuUchSLRK+qMx0L/yxJ9oKruPIDzKFUMs/9qEpjtsFkfAWAdTMH36coixJoes8ZyWWfm05deXosCsCl/iodnAv/Y4uGn3fi/YbwT6SZSic5PxG5H+qMQphyytzc3CwC4eXAjRHQT5qOSkG9dBLlcJ9EUFMc6bedbaeYIa/3cJrhlX1HUpJY1qMYuWE+7ze9GwSz3KFFyjQMvFnO0/lKXwR0EOj6xJ2uVfIR1ChWP4g060kBl3AxbkgseG2s1xjvZSaPBpRjvBbQPHw9Br0wpFV/KUmpl+V9MOIitG2/gzsxYYOsk3K5Q+lbtC1RqCOENLOdoJ93VTTHM8cfONiutba0tKh7PS49EloXCYJclq1wttivLsygopU3HgdVogH9M6vFdX/cjbPnCM82ssET6cO5LKShfmHC1rdMts2oWk6mZfaJvcAqhCpdyXan+xr/zpAmvVctiLL+oE0o/gYwavIxoia1dHUICJmi+QfycklFSAOxs4GH9NFDEf4dWF8d2lACDnGBQeeropcPMM3frwqwhw8l+eAFZ5E0O6IEckhINMITaXXmr+l3d8Ys=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(136003)(39830400003)(366004)(451199015)(2906002)(4326008)(6916009)(36756003)(66946007)(8676002)(66556008)(66476007)(41300700001)(186003)(6512007)(6666004)(107886003)(6506007)(2616005)(86362001)(316002)(38100700002)(6486002)(4744005)(8936002)(5660300002)(478600001)(44832011)(7416002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UcjnwrvdLOjCOBnRCj4u4X+ZIbsntBG+2qWiqssM1FFwzSM1OEq3qXjpy8il?=
 =?us-ascii?Q?cgfbDACsE8wYWcskZpRwdhsz9Iepv/A7UJhBy6/NcYu3T+qcdvjtr4RroJ2x?=
 =?us-ascii?Q?f8P/+7GI9s6oBzSb54c/Ol0cH1rraU6cx/MAJ6EiJSM9q7M2UkslH7rvh/o8?=
 =?us-ascii?Q?bmQM+VufuXeCJmxE77L9p5ODeQdsQ/D3OKVuQ2B48Exit3EttJ5CSuKkJcX0?=
 =?us-ascii?Q?kqML1esooLhgaDHNaO6q2361UH8cQh94VqVPnAbj6ai2KdYp+X0sGX2WisJN?=
 =?us-ascii?Q?ebWdmiCU2rdSGQLybpDkI2MAm0F9Oj+LY/JQ87e/hzbbfsK4zpB1tU3nbhMe?=
 =?us-ascii?Q?sqMqyJmQ8MHhiVngPI9t/XqXN+THSBGjpXL6l76kEVrAhQW/gM1k4CpEaWOh?=
 =?us-ascii?Q?XIP2VssHcyZVGjkxz6UhttPkpJsjP5/Op7xXF6KLAQgsAycrlbfyyw4Pzdor?=
 =?us-ascii?Q?wUEcQSf8CzhWy9LqlLZzTue0mm2ZDE9zvXBg2t30627g8nUhPTbjD/fwNhCa?=
 =?us-ascii?Q?1SvTrhaPAM9qSTQXd2bctxGK/Hn8hxsghce5Te6Wzi0ZQiCPgCDl7ZbBf+MJ?=
 =?us-ascii?Q?GxOrgISoA9LnBfE1BuFMpuTssRmOZPqjUzrqHWdBrbKm+DzIw9xzuHnOxbF9?=
 =?us-ascii?Q?xHJ4c86shEAx6bVCpO9PL8baSF10MgCIk277okoEUD1SSYr9P1hvu8i3+AAN?=
 =?us-ascii?Q?/lzJA+MJII4ybA0Lvx3NfRYBBjPeB+y8Zhfne0XFQ/RMd6GREzmIZulymVzx?=
 =?us-ascii?Q?MP6EgJnC2G07vxIHqNeLQR3tcE34EZlDBL/KAvyft3EoutXqhOlKXNJE4QQb?=
 =?us-ascii?Q?nGxWewXnTw7dI6+YoF0Sa4eA1+CQ3PX0sVVSrGxocBp7IOlBACXcM3S05dvs?=
 =?us-ascii?Q?1+aliSefMWNr/OLp0Hei5TXSbJJ6jNOEJRr4g7J0aiTF5KHnHiBu1DOSyiWx?=
 =?us-ascii?Q?4gfOOtaK68DYbJHhZisennix8Wtf4QabXEF4UgsiaZIrshogN16/u+efGdQZ?=
 =?us-ascii?Q?YOCE/Rp5EbzjXFzDVx6YSRNucchwXJvGfCJp9czGWEWC6+F3kCGs9zCoYkaq?=
 =?us-ascii?Q?cvcB/StG5aNfDg3NqUwPCCHZPnT4V67ghtj+dY9xOGw/Aig4Hs3UAXnE9Ym0?=
 =?us-ascii?Q?2FWcnGO25adoxOORaDOQFVleHEqX+89u15A3KPJMHzVYXVq5KVz3hTCQCVIb?=
 =?us-ascii?Q?kdKCjhqmcRlL0aGuLAeqdV1ArS0byBIuIIvrZgTSgWu013vLYiBxYLi8TkSb?=
 =?us-ascii?Q?ni5TshzFNAwsbe5yZ//mTA82memeVVVbkq9b9u8fn4rXUj9cF2tT7LI+UZ3w?=
 =?us-ascii?Q?/3aK9ynBt6CbsCikGYqr7aa3irI7wThsTeEvugPoTRIzmC1R6KR4yuZP4bm4?=
 =?us-ascii?Q?j0a1yRhnWF4KQ6LkjoeV2tbDr4epZs21Vabpm3MlV5+VWJvTlkytdx/qoIQx?=
 =?us-ascii?Q?ryx63X2GOb5zEQ/nUBu3wdrYXXd/9qEe6cipIm/oN/1LJO3pRRVA7Cy45+oW?=
 =?us-ascii?Q?GAySEKssJajTUlF2gXGF+8epGY63FcOTCg6GA7Txa1UaEYz7X2nrK2NRI5sP?=
 =?us-ascii?Q?oKe30+X2HvYfPYoCPeYHPmT2yGD5pCHt5vwgus+2yC3MidMPawRD/Ap38lB2?=
 =?us-ascii?Q?3gPosFV4T/UbPgaE9UiXqLlr42CTHdyKS1160qxRLkLKo3is79JKV9Y7VMrc?=
 =?us-ascii?Q?03x07A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cda9bad5-6cdb-4029-3414-08daf86033f3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 07:55:30.0815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uy8RAWfr5pXV10yszZgaP9jheU+dhzQ2DTkNnmGW62TwFfOZokFSo9mgHt74Ov+uMC/1u2CY293EH1K2GSUUeJdPOChWIKvjU9d/NY108bc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5004
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 06:15:55PM +0200, Vlad Buslov wrote:
> On Fri 13 Jan 2023 at 10:12, Simon Horman <simon.horman@corigine.com> wrote:
> > + Baowen Zheng, oss-drivers@corigine.com

...

> > Hi Vlad,
> >
> > Some feedback from Baowen Zheng, who asked me to pass it on here:
> >
> >   It is confusing that after FLOW_ACTION_CT_METADATA check, this functoin
> >   will return false, that is -EOPNOTSUPP.
> >
> >   Since this function is only used to check nft table, It seems better to
> >   change its name to nfp_fl_ct_offload_nft_supported(). This would make things
> >   clearer and may avoid it being used in the wrong way.
> 
> Thanks for the suggestions! I will change the naming and send V2.

Thanks Vlad, much appreciated.
