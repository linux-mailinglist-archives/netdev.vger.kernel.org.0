Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4080B699766
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 15:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjBPO26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 09:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjBPO25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 09:28:57 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2054.outbound.protection.outlook.com [40.107.21.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2C5474FD
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 06:28:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OcmCOmw4GQlMXQ8kvnua7TuHdM6YR850VayxEZuODMOqtaSS2nyGsjQYsrNWUNFBXzINW+7TFO14ufNFePzfogUMW4CpnWOjwVPgCVU0CH+z9noGDUNgNFQ5YX0oD/uZbm6lEnAxtfrPIBlql11aHV2gNQtcpKiLWNwZDZhUZMYXZVoM+iNfawdMwLBuFIglVaa8gkm/NpeoM3vLr6CIA/3DYEut+5hKgyq47YUdHYLDNDsz5kGsprvDkRU5+pmla2HoudPp+TpspqW0v+di11hIUsNnfYUTEkogKW9tzgje8vxmHTi42ZW7AXd43aZYfXhpdnD3obFfcoPy0OVdSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gZjA19oU+lm3DmvVmu/8XIZkBxY+cufS8XO+zhqc58E=;
 b=XBDcctkkWDpzyB/fVAj5M8tRbBw2+u6QTRne0jukURCBgGJqwc0so7WhwHK1pTS/1F6p3DESgT5GlzW2fQ6amFmSPi8THBA5A+fZc5OdVroF5tJQEwmiqHVUwC2LHR+9u87/K+iyBx9Zzpclv0O3ym8CqA5pcjl4xToH/6+VFFiPJQP8+1U2gbaDZXtZb/J6/HEWc0nXulmd1m9ShxlNdADfyxwvq8IFxiGypE4gbdCXEP21o5PO6+wbvtdQ004GclgnDfoSEzPmQ9TeXKBIo6W/t+sisurNcLhOn53O+/AL9hIPWUn536htXb4ZiP4/pASi9vVDwDl2aaphxYX6Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZjA19oU+lm3DmvVmu/8XIZkBxY+cufS8XO+zhqc58E=;
 b=MuBHtJxotOMYrt40kWWZeFtPN0VQil8O7PIytgZuOjQz1nLB5naHeyF5RLbJ/W94sFtLW3sPH64ldUw71olVUjNYwWlM7BP8yQ46Wj07d4AYEVZwKVAEHGMOoaJrk/e7qTZCOHQ/nTnMJgA8rfUWv33QIVrh/oApZqNFhw8psFM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7970.eurprd04.prod.outlook.com (2603:10a6:20b:24f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 14:28:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 14:28:50 +0000
Date:   Thu, 16 Feb 2023 16:28:46 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ferenc Fejes <fejes@inf.elte.hu>
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
        Jiri Pirko <jiri@resnulli.us>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH v6 net-next 02/13] net/sched: mqprio: refactor offloading
 and unoffloading to dedicated functions
Message-ID: <20230216142846.bjura4mf2f64tmcr@skbuf>
References: <20230204135307.1036988-1-vladimir.oltean@nxp.com>
 <20230204135307.1036988-3-vladimir.oltean@nxp.com>
 <ede5e9a2f27bf83bfb86d3e8c4ca7b34093b99e2.camel@inf.elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ede5e9a2f27bf83bfb86d3e8c4ca7b34093b99e2.camel@inf.elte.hu>
X-ClientProxiedBy: VI1P18901CA0020.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:801::30) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7970:EE_
X-MS-Office365-Filtering-Correlation-Id: 34ba4d93-1452-40c6-ae96-08db102a1f28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T/XBZvsXasuke4tCJACYM3MQdv9/eo4nkyDfrpq6k2jAqZbZcWArgVQ8pr1jWYjroND9TJ+TGHqJNvTyLMRyOHOCSgIEw/cEEAWvLewQImQhkz95qzezU/p2TStDWxdtvXHdqY3pcSPjpv0MPu0xam1GctlFBNDp7y2NUnOWiiwlnpmwpXlSJQxfYfwHSmLqfL5eJ0HFCOv0okwUhSd7CTh7F1c1y2FrHGtcDc4bgQIWL7McxJUPQiDtaTRJhlshzBic6M09Gq48FDHEUqynsjTAGlniIY9lDWxxm5yVaerl6QYFvaVgh9xxt8tcLJwOzd7m9cjUwsanzgzVUhTbGk4q47OUNdVnRMnJFu1afFB75/mpUVWVVePjDmz5VH23f+NPX2V6b5VdWqs2uP7OJ93XNA9dP8Vf+Dp4wYkR/FloQAJXrWRNTHN+yItxXWQgzccb4zrNx1gZ0QP6jjuep5zfC/myqVxNIXqgCHRLKiMLBassRyT1PfCqyPiiivZMazsyWu2DIhZXq+HXAOlCOenjPQJ5uHwXfFckciECrxpBx26FoWkLV2IJAuQEhInvAU0B4uqUOmmiLXKr8hOJHvxTQmE04C21f2X3V9yTk3vNbfCfE7eleUH2jbX/Rnrq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(451199018)(54906003)(966005)(8936002)(296002)(316002)(44832011)(478600001)(6486002)(83380400001)(66556008)(9686003)(66946007)(66476007)(8676002)(6512007)(6916009)(4326008)(7416002)(41300700001)(5660300002)(26005)(186003)(2906002)(38100700002)(6666004)(86362001)(1076003)(6506007)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+ioIn2w0ZeuR2w2xvV+MQD/u9VDdN7XOCYtAPzHgoP+9N7f3pybUNhgMaQzM?=
 =?us-ascii?Q?8fqu6CYQP1S8i2JjlubvtuwW/eBpXJtinhUS5Ipjo1Oig2CsLa56WAnbwiJz?=
 =?us-ascii?Q?1L8xxpp3lchK7PU0q8TqSR92+mDuofn7uKKtuDVz+QKOfJtP9dz7sIO38vRZ?=
 =?us-ascii?Q?pgP06U6QBps16VK/ahaxQs8P2swQRu68chKrJuzORdnUBmyJXVWAdZwYWpDG?=
 =?us-ascii?Q?NwplPb5dtgz4xGqaxHUux9RTnk6Aetc3nqDPp/bwFuRDwpXaxlnmlC9QWLpN?=
 =?us-ascii?Q?bvA4lsjYsa2q6jc1hTHww07I3aWYjc7E2TtWU7yIHX9taoFQbVBaRbXjr1hU?=
 =?us-ascii?Q?3cvIpmcDZNOUpv0Ee678sWuIulZzMAxpjTVk51Q+o1bx1m0p8bTeudr8p/xj?=
 =?us-ascii?Q?J6XJOEw2/WdQjgrA6BdE2C0GFqkP40XvwRB4Vyx0UGQ6Cs25Osh9s5yQy9iE?=
 =?us-ascii?Q?NnpnQLq2yz8mij4MfEvZMf3JNMXya7naZQJfkWepxTLBUhYp5LQQEPdhntkf?=
 =?us-ascii?Q?7nEJ/6DFkJoakafLSoeijrzfKBpY9FtwJgPFTsiE8kUf+iq2oUR7Y9n4AYVR?=
 =?us-ascii?Q?LOyXCbjpIqexbjY4syb5XIEAtWzi380Foh12XurG75LdKiqdyX9T3Oui9pWa?=
 =?us-ascii?Q?23Twom6q9kbGJ2gv+Qy127n4aonF+9mlBf3gMt95PhYoABLNyOfY2QlCqh0Q?=
 =?us-ascii?Q?/Exbdk8JlEvUk3E8zz5MLif0WHQDB0RecwzrKkgNfpTIqLWGRZJ9BfL6Hj00?=
 =?us-ascii?Q?SG4s4PJAd6t45j2TTxdvdBi/9wtM2na28CT0COuqLxiErwvOJ4Nfrm1Msnkz?=
 =?us-ascii?Q?fyByKCEyj3z/Dqj5FrqurnpVACgsyN5FHa2Z0rrskXQFJfRTy93VhHqpPSGk?=
 =?us-ascii?Q?WG7w6+h0Rck95OCt556h9NXj4p7Cw9TvpsHcYroKNcibRK/GmvH2gkAnil0J?=
 =?us-ascii?Q?4ePPr0u8x68MyhBQ1QoJgINzgMbV59uI89M/HA7f9gudEddfzWxf+nX9Jvid?=
 =?us-ascii?Q?i8jTBRrcrWrusmrjXwiEDspNFha9hiDRUNVqgXYie+K6CmYlzGdh9FXT/83R?=
 =?us-ascii?Q?f98SujVHuvm5wB/SypvHDzQK+ngZ5XbXFfkUe9zl0UGIYwwBqmjhzxXHaAAY?=
 =?us-ascii?Q?Y3ejPXioqC7WcgeRDkp4Y/3V7jk4OQOIyTC2qYh9mk5VUdt6++QC85NeGym7?=
 =?us-ascii?Q?HZbgqEUhWmffEAK2BG+TvydY4/xGr/Q0bH39BKxEDmF6fSLRsnudL40rN0le?=
 =?us-ascii?Q?5iI2sag6hhaAzdwct4yR0tALFccGkEPJ68fOf5hE/zCT6XyifeXH23l7nGWT?=
 =?us-ascii?Q?OHDsNeTyjsTOpS6g9NNxbXlasMrGLqfXCT/dFEThGgwkDx6KOYOtFJpFwhMq?=
 =?us-ascii?Q?nP8OQchzUH+aAAPD73DUFJLHDAPFBREnrW+yDR/RXdsh/WxV16jktFwXTHMa?=
 =?us-ascii?Q?EwHpkLc6JcqUyTmCvFXNiFPEyxjgSJ31zDo/N6u503O/psGHzjSgpBvSReV8?=
 =?us-ascii?Q?y5DyVtSWdw0xnvgBfVEGGX+vHnNC6EwnLU83bztwjc6iC5LpzSH+ZTc300nD?=
 =?us-ascii?Q?+wVa3DOXScQoEBq5qvzOYOxMlac+uGdVZTVm5SkHwSAUgyDshLVaKhObUH1N?=
 =?us-ascii?Q?WQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34ba4d93-1452-40c6-ae96-08db102a1f28
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 14:28:50.2675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AlzT1T9ROOp+qalE3mHAScQ28Q4RYgLTz75m9/bRk1X1pF8zFwI2+aex/ZQfKTC+Y7n28qC4tAP9hiirJPgP0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7970
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ferenc,

On Thu, Feb 16, 2023 at 02:05:22PM +0100, Ferenc Fejes wrote:
> This patch just code refactoring or it modifies the default behavior of
> the offloading too? I'm asking it in regards of the veth interface.
> When you configure mqprio, the "hw" parameter is mandatory. By default,
> it tries to configure it with "hw 1". However as a result, veth spit
> back "Invalid argument" error (before your patches). Same happens after
> this patch too, right?

Yup. iproute2 has a default queue configuration built in, if nothing
else is specified, and this has "hw 1":
https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/tree/tc/q_mqprio.c#n36

> For veth hardware offloading makes no sense, but giving the "hw 0"
> argument explicitly as mqprio parameter might counterintuitive.

Agree that giving the right nlattrs to mqprio and trying to slalom
through their validation is a frustrating minesweeper game. I have some
patches which add some netlink EXT_ACK messages to make this a bit less
sour. I'm regression-testing those, together with some other mqprio
changes and I hope to send them soon.

OTOH, "hw 1" is mandatory with the "mode", "shaper", "min_rate" and
"max_rate" options. This is logical when you think about it (driver has
to act upon them), but indeed it makes mqprio difficult to configure.

With veth, you need to use multi-queue to make use of mqprio/taprio,
have you done that?

ip link add veth0 numtxqueues 8 numrxqueues 8 type veth peer name veth1
