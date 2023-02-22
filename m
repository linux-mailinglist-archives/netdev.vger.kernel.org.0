Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1565B69EFF2
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 09:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbjBVIO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 03:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjBVIOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 03:14:55 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2100.outbound.protection.outlook.com [40.107.93.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8147EE8;
        Wed, 22 Feb 2023 00:14:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cEE6m4l82FNS/Y6JQ6hEeSFZcP1fJatu296sUObuyioNAbq98ty2C3QfvwqQ2pfsRN2L0xFHQu0OhDIxsby1JfpObL4jOcwDBHxSHrWgki5bIzju5nTmJqY3aIB+ONLNYMAr9CWdEWA4KGXoo2UDgc1LP+GsHCQA52ku/mGhdt2YOeP+kqZfckTHzh0KSc9S06ShwTJmnhj4H8xLBk6kUJrPoaWk4wArAgzJoqqIRt5k33i71ld4RNgUkLVpXoVYCU9D+WpYTXvwTiUaCZ2c0PkznhtTGsNxxy8fVnAYpY/FfgfbMLzjdXowmcRnEtl9h/sQYtYd1/W+XeGnv8Cp7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5lip7O/U9LSfvIuQmg4/l2H/T5IaQFNHprBXNsp03v4=;
 b=VkIkHklFjp83YQyNN30/l8OwbE4G9UMhweXGfOK/bl2S9Cp+3GfEvb9zJkcdlRRGz2rwG0KtQgr6TDzThuzq7OUsXpML/6+zgBoIHaRncw1UuSO0UtkTSUzmIBmwKA9Lec/SJh1xhpXJGAlX6x6YrlN1iAmM5hSTNHv8qqltALIHC2bwFDM4qVUkqWpFzx0+iihymuEulZWRI+7+EBTLVdFl+FuV2TGKtDQvij62v74MtJQXkGR85+CmcBWe82yA1CRQT+2HxXy4kW4bxYlsN2gRWg09TO5POl7PQE7x/yhOAB+DiXVZrNxBYkN429cDLOND1kdwJKcb1o1bMYMjQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5lip7O/U9LSfvIuQmg4/l2H/T5IaQFNHprBXNsp03v4=;
 b=jg+/72fT4UWyfIaPgDoxvF9P2sirkzFgC24zqrkffQBaZw5BA22u0sIfU3FARZcUKOemcV+VDrDtW+NhtvHprMfvXCWBOPcfCg8xADR53USMeu4Hl4hKyOIjQEEUyYpXuRXWR1mXu/zgobpT+ZhuQjtNCNBoJCW9GLMADNnCQZc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4699.namprd13.prod.outlook.com (2603:10b6:610:d9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Wed, 22 Feb
 2023 08:14:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.019; Wed, 22 Feb 2023
 08:14:51 +0000
Date:   Wed, 22 Feb 2023 09:14:45 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Bo Liu <liubo03@inspur.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, linux@rempel-privat.de,
        bagasdotme@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ethtool: pse-pd: Fix double word in comments
Message-ID: <Y/XO9cxFOkChm3Je@corigine.com>
References: <20230221083036.2414-1-liubo03@inspur.com>
 <Y/TxxBYvHrv1mZfJ@corigine.com>
 <20230221090159.4fa9a548@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230221090159.4fa9a548@kernel.org>
X-ClientProxiedBy: AM8P251CA0028.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::33) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4699:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d8668a3-7d1f-4500-049e-08db14acdf33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bmD8mkxl6YqEPINaKeGzE9B6/oOQ5SedXDaubQEBm2xjv5k6m+lYzkRjLdMELt3UxTPxLJOlQhMznwc8KlKNneu6fUwKV0JoFqPaUWUFfmWqg5qMfyBkJHjcEfyvlDsyte4Si/Zc0zG40tPoKCuoHuNmjQg7TKj1BY+gP9LiFC/0Qb7t1NERtm1UTCzFL4yzE8gGO6K9SIpO9T7/yBlrTPk/nqSoTGkEHK/C0Q5PoalevQAYkHDypmK7KhtnMBOrLSd41cjKcM9hyZgDY6uNr8v/QIe2fWq99/Db89XA+7mGVlhE26GLKRNAAH7Ur+DOajitAUWaUMfo7xRkb/bNDxSZSUs/kfjwp390uB1X/qwdJLJxOu+p2hNFxO0+TktqOzGUioZL0L8Q/DaF3e11k5sVK6cw3GXPf7aU8k74VE28c7tDIVzick5+aO3o+2N8VxD05LGMdvg9l+9DT3igKqukXNjBeIv1GmOBE0Druo6i+ZWMYC/7fofUaaCCmlcTV42/GgpotK+wCBYnRxp+ZHslRXg+oTrIqr2Sz0HyC2TGSBKEjdXBg+dMA+5ruCAZdcr9SFUooOLU3XLorwuvdytsjsmCz9XGEcDXaJOI/n5Fj6oeL4Jq3JSH3YjuGW6u
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(39840400004)(396003)(346002)(366004)(451199018)(66476007)(8676002)(6916009)(66556008)(4326008)(83380400001)(86362001)(2616005)(38100700002)(36756003)(316002)(478600001)(6512007)(66946007)(6666004)(186003)(6506007)(966005)(6486002)(44832011)(7416002)(2906002)(5660300002)(41300700001)(4744005)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B42XUlhcOVnAUcpMEX8oGu/7Qy5mYUha/GInahiK77hdnx0k2C6fR95ktC9i?=
 =?us-ascii?Q?xK9xyDxgmhOsQplzDS6Q4rGhMz52ewbX2reZ5QbOJAUjqr1SqZ3vgROPofq4?=
 =?us-ascii?Q?RIcip+t/TMIplPG1j7KBpBi4sGBCCqw6j572Fpt8Yr9Bpot+6lpcYgG6J26T?=
 =?us-ascii?Q?hx+wrXvWqjKpiBztJJyAi6OAR4VX36B/8ImnPXtBY7bXdrjsJjTPhFQwphnw?=
 =?us-ascii?Q?Fz7LOQW/bjgBPVlMMX3q/b0pj9Kg1coy6O8vePoNWKY/zRSnM7ucxby5BrfP?=
 =?us-ascii?Q?SOiPnVFW0S4sQ+1IuAKVtwyQ9hMF9T9b+fe1UBYR3M9YOeScRLUkdw4WI/sr?=
 =?us-ascii?Q?7lGLlhmaRVo9Ax2EnMP1JMPi9xau6bYpuLDeJ5VyroMD5lHQlLH3/hZZ3LJX?=
 =?us-ascii?Q?1LczO4LZLers98Q09Fv9fIVb33kJti/shwvqbUlfHXQi15WZft416NkDlC9o?=
 =?us-ascii?Q?MVRvuvZeiVHmL4oyQb0jZGlRSYnB2uVKmb0On7ZKgwg6DXtCpunboqHdOCnf?=
 =?us-ascii?Q?dmQf46oQdpXzYsUTHvcqKKyrbwUKxRf42G+epAaEf6x2ybFWRA94LZNtj9Tw?=
 =?us-ascii?Q?jVb/KvkfLLJg1xLDSiqLboBc+N3J4ZZtQEsisGB2NjIU6NPaw1VwXYKEeWXq?=
 =?us-ascii?Q?4VgWV9z5WYyWgXT5DmVTNNFjsWhKkfGLk2j4QJkDlZ51DWSU/S7D1Btx3431?=
 =?us-ascii?Q?zQWx3WDuOkyPoOwwI2brI6KPtCWc6zXkKBT3w2VDTJ6KqqzTuhYoOhUYIX1f?=
 =?us-ascii?Q?cL8fgPIFjyefddNragLFg8hJPLPtD9Q6PWRWWlrMbZvVY9+L++8Q15llFFsu?=
 =?us-ascii?Q?9NXqnIsNMIpeHpCLap6fW79YYtfkeMmiG+qNWBk+HXyQNtNunJo6xYytzCGU?=
 =?us-ascii?Q?F0IohLZwQ/RD7XJJ+dq4RWnhc/6TfprIXn/fcUNrr5K8LKPyj4+oRtxiDh/z?=
 =?us-ascii?Q?4wjkYqIucTIXtfMHUZevfe5KYHFhWjQlZ3zOJSfiGS5Z5SsvZlo/hs6GYv7y?=
 =?us-ascii?Q?ykPKFtJ7JTv4SSbmOeJPGV6DAqwPhnMcDwA//JZLmg0G6fzJzfv5MCdE1nSL?=
 =?us-ascii?Q?EKzwxmIzAYy0gT2up90abgRaYhp8LjXQQzJmUJVjX8TZn5eLcsyQAgzlGHKn?=
 =?us-ascii?Q?YXk5m81Q+LbNYVZFT2slb/CRuxQp8fjFf/fTPN1n/oPLKBJ3y5HAlYztpEaD?=
 =?us-ascii?Q?lQfAcE+Eg5sOYq8PjNrvjQVEx6bZXkIiHdJ0iCkppNwzMEwH32Sm3qsM8daw?=
 =?us-ascii?Q?/pD5xKOHRdGtPO/7fIvIQXI411VFBmlBOfwH2PqmNZtdLIo9BTCPoJGF79OL?=
 =?us-ascii?Q?Nutzo4HSGFlnZvrQnNe49O5oO0HMqrVjwC75IU8CRN4apsee9y6L+Hnbfo5o?=
 =?us-ascii?Q?ULYDheDY0tm9LGsNMrPi2mzGtivnkGD45DrhbOP81W5BcpR/QDe/N0ijR5AL?=
 =?us-ascii?Q?tzGTdQp+UHPiaAP2YK3e64jZkzodObxOtK6Mb63vsGPYhyhPB3BiRBNc1zXr?=
 =?us-ascii?Q?DF/Vq7pbW/xbMyXNkYSyeWO02Qfr4X/uBs3JMQ9R2piGWRXDOmEc+tfPT08J?=
 =?us-ascii?Q?uM870ZjWhtW9KfVah8v3I7FciCTqGsrC3MU6Qn3BCCmBXO+AVI5b2p6zuGKY?=
 =?us-ascii?Q?wiE+LY5r8OZsFAec+iuzzN9a6apQZ9FO64ojI5Uifq0rZZ8LWgxQBOqVZhuV?=
 =?us-ascii?Q?5AqRPg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d8668a3-7d1f-4500-049e-08db14acdf33
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 08:14:51.6368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y3YoCT17fR8Vqae+854n6qzJYWMKJ8w6UAxqArsVvM95rz75ND2qAvXWnEZOMDpaBLhsUYqoz7gQpVE8/MSXZWGX+VM/qWx8p+SPEawvFuI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4699
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 09:01:59AM -0800, Jakub Kicinski wrote:
> On Tue, 21 Feb 2023 17:31:00 +0100 Simon Horman wrote:
> > On Tue, Feb 21, 2023 at 03:30:36AM -0500, Bo Liu wrote:
> > > Remove the repeated word "for" in comments.
> > > 
> > > Signed-off-by: Bo Liu <liubo03@inspur.com>  
> > 
> > net-next is closed.
> > 
> > You'll need to repost this patch after v6.3-rc1 has been tagged.
> > 
> > Also, when reposting please indicate that it is targeted
> > at net-next by including [PATCH net-next] in the subject.
> > 
> > Ref: https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html
> 
> I was planning on applying it, actually, it's just a comment change
> and PR is not yet out.

Sorry, my mistake.
