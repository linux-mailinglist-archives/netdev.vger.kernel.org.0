Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA4DF68EE1C
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 12:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjBHLiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 06:38:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjBHLit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 06:38:49 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2092.outbound.protection.outlook.com [40.107.94.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FA0458B7
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 03:38:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KdzaV1AX+XzOjlWGqWD9iKvXasxJsFFB+aq+bagwxN3L4eJ0W2yIcudcXTeD7s3KC0cku8NeXLruQ+rkRZp3VksGX4UqoyUGYVr1K7IMaurI//4/xuMKOiTp2ZzaVbh19LjzXln0/7hoUADyjpb5tazvKK2eu7xJuy7FH1RpJnttr8zKsHp6Nep2fusGkkiss2kE4DK4mOLA+WhknfCiSm07cmOKbZZHLpoABj+5e4MfY9I5opAgwDOajNouMzRbPG14fyN+zJEd90hNsFe8ub+auq0HLWf1WVceeU4WBZXUAemjGu2QQly9mq5N0qBGBQWPa6QNsC3rxSfrzA505Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EroJ3QKX1xBcWrgDISws0mbNJJ2TxsnPZeKq8o2hMt0=;
 b=YrcgdtIiuH5Vbf062BUKIE6auRR+SvnOWa3sYnxinIIyqaOMyG7KJlEa50m6a5/YlQNAx0ey+M0K3wUHSTMT0MOsnENyWcSdYe0zWUNQprEIoPHtQh0MfYD6zx1n3qHWm1cr1Wwdsk0mA7i8iK1b/cpZWbxCFyxyX5nzGMr3LdvB7B9K/XLBSZYTieIUB2HqIBd4+M9bFcHrt8or8ycNE8atflCkmVLFr28gNJcrwtXf2Ytm5QFn2Qrn5XIf4Q1tFB7RE44AQByoBwFtkFrhbq138YnfMqkUtCjwZsIz0GQcFgnJHt6pSUutcrFAbOYz7nth8JZS51eY8Bw8eG4amw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EroJ3QKX1xBcWrgDISws0mbNJJ2TxsnPZeKq8o2hMt0=;
 b=SRPuMBZBBcZwVtgMkDv2Bot6UqGTbu+VDPcNBZVZnHk4LA25da6ZsdP7VbaMLvCZJvlUvA+6fopnDDSSXVqeEpbWTdyWjPDMmhzsoECAgNM1yMZ7E6M5KaZ3rX3vlnrn0T6CxH0M/6gGqJxoMN7Vxu+Tv7oxw6WW0mP7gSkIYhE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6157.namprd13.prod.outlook.com (2603:10b6:806:350::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Wed, 8 Feb
 2023 11:38:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Wed, 8 Feb 2023
 11:38:47 +0000
Date:   Wed, 8 Feb 2023 12:38:40 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH v4 net-next 3/4] net: introduce default_rps_mask netns
 attribute
Message-ID: <Y+OJwPHOCbXIQmK8@corigine.com>
References: <cover.1675789134.git.pabeni@redhat.com>
 <174196670b96f53db4b16239ee4847575b4998e5.1675789134.git.pabeni@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174196670b96f53db4b16239ee4847575b4998e5.1675789134.git.pabeni@redhat.com>
X-ClientProxiedBy: AM3PR07CA0121.eurprd07.prod.outlook.com
 (2603:10a6:207:7::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6157:EE_
X-MS-Office365-Filtering-Correlation-Id: a2bbc096-6328-4337-5ee3-08db09c90a72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z/FOMBWVJ5YRg/VhR4Z36kIuylGTPpM1q9864KQWis3mJJK669g5DgChUSelNIlnJketvGCuzt1brtJATG3ZF/vh+tLHeL8yyY8yFTMzzLqhC/HBOAW1MBhqdPpcSKXAIn76H5rYksBoHWQkt7mAN92u1uvtyszB85Y4nIg+Lj+e7khLHxkXR1PD2HKsTzfsPShlcUSnFaoyj+gyuBPaPuO0DnwdrhpFoxBKSvAPXRGAawqQHJut1WeML3+ffign5Qj9RhHRwBgNOSMlD/DEqreYM+vNOxbTZOfhqLegzHI4STRaFFBKGo+xWPeXGJfbqeGkbWlSw3FhjrIV9skokAHW4dcF8MyZ1PUtQWRKBTeK5qiWlLGOoujmLv1UzA7rTo4PoUEng/GSXHKFZvM2g5AxlqGGpk3NPPkEaChuC0yPEWwo5z+EgQseGSE2FQ5vhqhMtFM1xm/5pFdCuATPXl3oLzxNmFfSv+RJ3Ar6mtinjXzjFIV2FcaNoWBJpnkgKXGoNE3JrL1gziocZhHZEpykkNYvP0BtJnFw9hUPfTYLHGbODZ4onNMGSDMTaSChANHlSwtRftCozg+96imnoLiwOnUrogAP0qao8Fdu9+ic75KlXbt9+P0/Ig7bPiNBG+SP6kGIb1xAfEyjTdMaTgVkrMAcf+xs50Jk4b2+NFL4bX21h0p36FxXemwetd/W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39840400004)(396003)(376002)(346002)(136003)(451199018)(38100700002)(6506007)(41300700001)(6512007)(186003)(8936002)(4326008)(6916009)(8676002)(66556008)(66476007)(66946007)(2616005)(5660300002)(44832011)(36756003)(4744005)(316002)(86362001)(54906003)(6666004)(478600001)(6486002)(83380400001)(2906002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dPo8mc/YgK9fC1U2GXJxbqZ1Bnvo0UVHr4TOJwYZaoLlnF2OEsL+Z2eEpqzr?=
 =?us-ascii?Q?0cYkR8qY5wJqwf2HolhWEvBFc3pn1nYHNlulVCg/bm/NSc+hixrkS0+2RCop?=
 =?us-ascii?Q?axQZm4sKWQmGVDdanWfZ8fmjjEUOr/YzsRYoPq3BtuxkwpsCGjqzDfUhHIZi?=
 =?us-ascii?Q?2qMs68K39OGhBZlese0L/ONIJOsqAkc6ioRxDJ7NAQZFRGfdCKT2v/L8ya70?=
 =?us-ascii?Q?yssO6X09E1A6fenp8NXrx4a2B8B9HXDl6M5ZpyqGpmz4Wp4ECNE4SF8ILcIa?=
 =?us-ascii?Q?o4UjI263nNCuRSTzAZM5VO5CXiV7dBw2a2BVDz5o2dWqXk2FElnNC8m4cgb+?=
 =?us-ascii?Q?WhyT16OxrEA2T81n+fiW17aCKIlwzDsTwX3pX/u7o8w36Md78ePjkFlrQ/Gk?=
 =?us-ascii?Q?eL3aYD9Z2Ct/HXCQryNF/CBAZy82YvbiDPkFpBS7NtTBTXg3+2W8aDw4m2hf?=
 =?us-ascii?Q?a1LWMHhRqpDxffXCyspXOc3Qs4/4gMirTN89xyG83eFoFNo9GLuX/v36BHjO?=
 =?us-ascii?Q?wC1NEHl5YSY/1R3Ji8qd/iKY/JwDDB4G42IUkJbgtmT3Utpfu08TXxVDt3cF?=
 =?us-ascii?Q?yNgcIZpc6Nb3FYCnkT5w1EX4+WQBeKTN1Q9rAX1aA32oS9MoIUlev3DtKcoE?=
 =?us-ascii?Q?5Ei1ctCZMt8POy3VdaZ5sBrcorPRWVFmEh5YmWNdMz/QbswkpgTh4hzZFRLB?=
 =?us-ascii?Q?QWqn2gBvCadmX+uMwOR/GrIcf7foa048C5ZLU/1LWtPYCPh9/l6o8U0Arg4j?=
 =?us-ascii?Q?w7+GJlt5B71poOCOgp4dPvsoaxu02JVZ5s8cG4w5hBR1GMbXC9QVhmnOZVfr?=
 =?us-ascii?Q?No+Y8FNx786AC+kPRbxIG/U730vKCeH0BhYq7gD0uNoC5s4zrT/1N3mtF1ak?=
 =?us-ascii?Q?YtaUfYdQjkyyZc16o3v/l3I4y6r+XmARGFH9RLB7wSdmOyza6sFoqVmeuJDc?=
 =?us-ascii?Q?2qL+A6l20cLsgLCAl86gyfViIEKsTHJKZKAZLFMk6+yqCyVsZyQYsHjYlHC1?=
 =?us-ascii?Q?/qLSEQMW48dY21XdT5jh1sresdd1FBNDOMfuAodXti+mBye38oQTwUqwYIEe?=
 =?us-ascii?Q?8xvVssEtoAWuErZAW8T2glCfDc9luiZGO8/XkFSHIDXuHe4OyFAZbH6vLlXd?=
 =?us-ascii?Q?j5h5Y8zAZaTQ+eh9FK2x5xgX99GR9IN+Bv3nOlxcGLS+DcohMCUaUvQrOIUd?=
 =?us-ascii?Q?+R/6rG8tmhMklZPzhC/iSlAF9s0P1kCzc0oLhIq6zdWBi0tnMArZxNF4ZA5D?=
 =?us-ascii?Q?65Bc1yJE/gVwZySbWnSIt9bBErg8vGqZPWQDuUCFWQIu9OypOpLNOeuH+3fF?=
 =?us-ascii?Q?seej+CMqnXzo3njBmGd6jkhaAGn8piK/3ygr0fLmCg88lCevHA8/1ny7gPM7?=
 =?us-ascii?Q?luymmgVfp+RVj9mN+QWPCBlQc2ibZ67fI4cZPaHJhnp6kQFguiar0qzV2omC?=
 =?us-ascii?Q?vNwmNQj9j8chAbhv2qT6TO1OcFPB8+ont4mH8NDD01N6HvpkvRhuAfFqyg0b?=
 =?us-ascii?Q?j9N00tIWOM8qI0CUnOdtI3gcnsuWNundFWoYu/ok7238dKU2c+qWd4MjuC6j?=
 =?us-ascii?Q?gcqol6gowtb5bL53swdjtDy+6QKStxCX94YbMGaDSV7BEKGzStSg7hanGsSd?=
 =?us-ascii?Q?J4RxOAfqsP4MDOwZbCYDhPGRja1EvO8ufaztDUaZ9u2iUCO+FNcBHQasI0yH?=
 =?us-ascii?Q?z+wYAw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2bbc096-6328-4337-5ee3-08db09c90a72
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 11:38:47.3132
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Og6JwUqYSgXhGyl3qiycbm19yCF9xvd0jUOC12aIOpL0mUvuUk1KCVtBUh99bR/WxMt4MuRo21KldXkR5WlQn6orXrq6ixbVWdCIaghtwNY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6157
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 07:44:57PM +0100, Paolo Abeni wrote:
> If RPS is enabled, this allows configuring a default rps
> mask, which is effective since receive queue creation time.
> 
> A default RPS mask allows the system admin to ensure proper
> isolation, avoiding races at network namespace or device
> creation time.
> 
> The default RPS mask is initially empty, and can be
> modified via a newly added sysctl entry.
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

