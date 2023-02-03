Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34AA1689C05
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 15:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbjBCOio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 09:38:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbjBCOin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 09:38:43 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2094.outbound.protection.outlook.com [40.107.94.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFCC37B42
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 06:38:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=erKxhLoUJh9Pu+31YGCeieqk+QhzHL4guJ995E8UdviXFY9YJze40Yp42/TOxRt6aOMfNe0dWHoYkgi2WBwVL8qZOTqrlLg1J89RO/wr+bz0iWQ/0tw2G3guDnI1VQWiOijL5mDYeFbfH0m2n0iu8Tw+QwixFeurCewhCQtXvfmQV1hyhLVYe5VrVP3grTwXaajUJxGefCHQ6Tb6SzpiS0hjNTf9NJiShV48XfiIIyJZSAhPPxKU7wsaignOHbeYG2Bv/wHm9AmnxlZEcAaVzj1kqx7YXf6ZxYGjBfuvIN+lGly/tSzzDPj5sPlsH2U28etBEGiMcUsDmdseH37Gzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uSwHX35VdW2KSkCTsRnnXwLeUqCI9jxpLbeucoTFKOg=;
 b=NTzdJa36Pos5jWVgBAfq/nJ+JeXSLT/pD8wZzKbrcxAZbVgHBXit42jmKMDeL+FkWp8oEoVfFrluGBkOMAng6A6vOtjKcda/qmywfOuPJiLjBkrus9kB4ArQED9BH+FOXPyIyf1oxnWW3nd6OIVhqSQp3KFTMqePwBKw0F3JXxiT78sb73Mowih60cHsq+UFTNWgfcIwt6/Ve5T+dfNmckEXIrnfT3z3H4yUeJjkMeD2acXGvq8eDAWbcK6MdtajPqHLNhLLxPYMqMnauA8enlTKfU4G2ajYzRFGAkrJzxNEPgwxx59O49//nBfkgHPN3gwiiMj5uX0j1H7H19tltw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uSwHX35VdW2KSkCTsRnnXwLeUqCI9jxpLbeucoTFKOg=;
 b=OwHzOEcfmAgR832m3SyGZujckVhCsi0UR/9XqWcP0vusKw1Iu0xS6aLg9hQ/tgadRVFZjIDHBmfMn6cooV5JrbYMUfDVbJ3kXzxI52sOiXutfM9DuoI3XoWr7LluwuBLJO83hT66wAOcM191mefvrTbsLjHwrDpToDzOW7ZyAmI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5303.namprd13.prod.outlook.com (2603:10b6:a03:3d3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Fri, 3 Feb
 2023 14:38:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 14:38:36 +0000
Date:   Fri, 3 Feb 2023 15:38:30 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH  net-next 4/9] net/sched: introduce flow_offload action
 cookie
Message-ID: <Y90cZhEeLhCqY5Q6@corigine.com>
References: <20230201161039.20714-1-ozsh@nvidia.com>
 <20230201161039.20714-5-ozsh@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201161039.20714-5-ozsh@nvidia.com>
X-ClientProxiedBy: AS4P251CA0006.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d2::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5303:EE_
X-MS-Office365-Filtering-Correlation-Id: 18923178-900c-43cc-3cee-08db05f45507
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3L1tu4vAGsCxsPVAOEqhDJ4Qy8MnEbL3Tt7EuK7an0L7DTTLlkLIOKG7e5SRt3qwxBUEs34c4YQZop1cI0qj7uVLSy+wBe9EE6i33C8Z3F6guw1IbecrGex4Ax2jih6zgsxae0JIWFOtOncwnha5RanpaWaPjK4aAkdtlA4I+2qgyDymn7GcCZ2Be6YPHY6Aq9d0H5cDu9dlOs+EM5LfUDpdFNEY6nqKgcCx4JD1+49Exf2/ZfjOkHpyFwBR1tHHKbkyhYesjj2Ghgj4pkQ1vOXbkunKunm1wRtRwdLuECcafjxc9dHrFoqKWTGgm2raa5EZ3VwOCtSVz5xFfMH/yxCh8Xu3/ItP+f+EEYlLQYGTSRlEBjZ52MHzizvGt4FmSYo/dtet+lOw2fuA+1IjdsCaWVRExdozci6TTNELsoe1Xm2EdO8OhYKFFninx72mbGrjGUjzqvW41HV50NWBi9kZmThWninPOO+s7C4fcpk2zu9SzDk6YX4yqdONL69YdBZ7ckWa87gZOQr6V9bQ7nn+AcEZ/TtUihFCjM7pi0x/t+iN12P0MlB5TKSvK0V9bVA8WLPn10U60zJJp2zO7eEpNwt325KFGq0gXAvFNcGDc9JmvTaiaykZH1gRh4lhABn/A/86/R1VfAQ0xIg7nQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(396003)(136003)(376002)(366004)(346002)(451199018)(6486002)(4744005)(86362001)(6666004)(478600001)(6512007)(2616005)(44832011)(186003)(66476007)(66946007)(41300700001)(6916009)(4326008)(66556008)(6506007)(8936002)(36756003)(316002)(38100700002)(8676002)(2906002)(5660300002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nwSBJhhyUsWuPWH6w38iYOZXPQJTZtjJuhaXDk4Okt5JnicK/xGvpBTq3l4E?=
 =?us-ascii?Q?KL9U2IzQJsB/HJL6scq68/IkN7uz3PUYaHHkwjDOt5gFXetGZtpXpJjXici8?=
 =?us-ascii?Q?/bLf9zUe/4UfU+BCLtabepTRMHNu/tgF14pDe0HOCF3BtyICB4oQUqBJjDvW?=
 =?us-ascii?Q?kbF+hy/+4hQI5UU12HvVntYdvaSGyCw5IhTuD1VZN3Aie1cPXlgI9thljQwB?=
 =?us-ascii?Q?JTlS+A7Oz9BXmhwNMD5ZHhoXwzQ0pA2tPLaqPZA1wBYaA6Y0Nqznin64Mzrk?=
 =?us-ascii?Q?2WNvCZVNkqyQR/6u7zcj5gFIEEGhBAbT3EjtBznfnX2S5t8D0pJaw5W5RCq9?=
 =?us-ascii?Q?e8nFGUf4qUYCy2Z3ZKPTyyJoyxfbfu1OS2btrqfrNZz7RgH1D2ZJHlcxOWjx?=
 =?us-ascii?Q?q9e2N+QqKa8FTpPiV6zW2TZ17LCRuViOahAVDz05ToZDePQiPSw5AVYJ3VGt?=
 =?us-ascii?Q?rt7lmRniRtDGdESZOFz/KdIwWGTTCcW2nFIK5Pfb+P+6qTLASy8CAkgPgiL+?=
 =?us-ascii?Q?kWqFbkKMu1Gw4CTBBYKfGUcx2xeGhF6XFHYo0E389vmzc2exgeLlU8qSVNLa?=
 =?us-ascii?Q?GMIn1L0xdaQlazRKQXMw79gqubLfBM4d8JvsQjijwphOaR/JtSBGjiZ5NmbF?=
 =?us-ascii?Q?HvhMOnRB16bHXP3UjYZnikmJoAhcGR5OS5FyilDZmzjjtiDaOu0NTN54N9d1?=
 =?us-ascii?Q?EjsjTSr4kUbqWmhu//gAmPP/ta3BPCx5DisWjS296abKf6sGNIPBDvpHBJQx?=
 =?us-ascii?Q?66bQXqbIDrfhZpM25I73RK9X00HIIaoVoB3C2AdNcLiCL5p5jA1aAP0b0nLe?=
 =?us-ascii?Q?tozlHYMKXm3GV4jJ7Ul0KMIWof06W7+E1Ga0HGo4CPQf2Jyt/9Fy+0PA27aK?=
 =?us-ascii?Q?JeeznUsWI7Vqsz9Y96AF5Et9MXwObMWJXKTq7EEVxI68irGD7qUo3GJM1X02?=
 =?us-ascii?Q?Xkxjvh1hZ9j/Ld9V6pqecEF2nuT3+JhoI/MTVsnh2fO/NWrfGvHvAxY+eqJ+?=
 =?us-ascii?Q?JllDf3VdcjuRMEWAIkb+O4NbmluIy7CbteBA/lRG0YM6FvcPO//0wwgHUr/q?=
 =?us-ascii?Q?OO6iLPoxyLYn7bkK7knvG14Cx7thppbIQLlUPgcXAudJsO1l0Ptz9SajnyD+?=
 =?us-ascii?Q?uvGgtaryOh8ms+kV+vupMVU/C4W6He3zHJWPC4KUUdWWmb+2qZYiCrUf7eb9?=
 =?us-ascii?Q?CoeckKm5zD+l2A60bBHqp53BWiRJBQtF/8C1PZZTtPYuQaGijZOH/7F4/Scb?=
 =?us-ascii?Q?H4RPp2ulaJP9YriPltIwfl1XWuW68x1qL4TNcQZdCNql3c8uB2LoHOt19jOE?=
 =?us-ascii?Q?qkxNHdwRMQD5tsSj9LFHFlqKs92fwI05cen0gZQc9xR3ZjNRMezU5CqvXbAr?=
 =?us-ascii?Q?pnz/hehJ7U3KUCjfkPPnJYkX5Kcas/e1+G77iMs2CPA/jHAbbL3B0UdqALdP?=
 =?us-ascii?Q?KirVaDNzkSZtqYq9iQ7AdlNdkmfC8XEjA2NTN5kf/6hbVlOvNMuL02QZ6Tt8?=
 =?us-ascii?Q?JzO2SgB+ZHJ3AkgH1TPISBTN2jO7WYIwoh7ez625RMypF8sPSCvHo4XqNEHp?=
 =?us-ascii?Q?kChZN8IRwb4wcIuhP035YiyLGSjL67U9rSdHkEpRxog9v2gxVmysLjk2V73y?=
 =?us-ascii?Q?5lFyI+SG+P4r8Pn17n9Ps5n+TYJObaWPIPcOXV6kOjexJdzEmi/yIZ3pcoNZ?=
 =?us-ascii?Q?7RWZEg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18923178-900c-43cc-3cee-08db05f45507
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 14:38:36.1316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: euFz9p6dn7jRv3gXVvc7vMZ8q2gAVRp/1Y6KYkBd971oDLzjtSEAT2v8vM7DZST2h/Rd95B13Rt7nVtJFy5+D89GBIirhawKc2J4zMPMNqk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5303
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 01, 2023 at 06:10:33PM +0200, Oz Shlomo wrote:
> Currently a hardware action is uniquely identified by the <id, hw_index>
> tuple. However, the id is set by the flow_act_setup callback and tc core
> cannot enforce this, and it is possible that a future change could break
> this. In addition, <id, hw_index> are not unique across network namespaces.
> 
> Uniquely identify the action by setting an action cookie by the tc core.
> Use the unique action cookie to query the action's hardware stats.
> 
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

