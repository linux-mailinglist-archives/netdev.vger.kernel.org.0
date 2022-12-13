Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 714ED64AC7B
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 01:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbiLMAcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 19:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234119AbiLMAbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 19:31:39 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2078.outbound.protection.outlook.com [40.107.6.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC880BBE
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 16:30:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hkywDVvBg5Q6IOkM37toG3G1Z//+El9NP+WXN17HeD6wdl3GPAOKIltwQjfmg47WFW5duCAAPauwEZGPYbl4+ZOoTyi2V/tNLHnbUVVfLdrxUN/0YqpPJzlsnvJ+QWRnfZVFA3JsNbwTN2jNbI52kWkB8uze3ITDhevGTeL5kDYiEQUkREFM5u1vNZGftyB4US0rDTBG+RycD5ZqVhYTXaegrm1dSC4kA0Lk7aaaF3gPFFw1jsI0jb8DAUmXdLqjqiSMeehwQFxpP94VVrtuCqHXqbM+fHVKAj7TDx76Ifr9KJZxfB3Abz93V89/FqWlqDQ+kZJJ3bN7qO9UkYXw7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vDGRHalM/ba89usxIlolch4mt3buyoyP3pgfGvX6mgA=;
 b=CQRZyr7dhbwYykDPp5iDlYp+JMeQ4fb+S/BfchR2QWJr/NgaoR17CCj5QXmp1SGHdzv/4mBAUxONG1zfzltxJtDFDSYoHdyeNTv3Q35Hd+Avd/TJqTU9YPj+FD1bNx8XzgTAAoXH+dFM3He/wgW+wEtIJgm4RSnt2uQNaqpPLRhIH/k8V50igoCbvgdJyfIk6dUo7/beK0QpT+wtgW+N8NcuuofmVcFlhbeUOTNbHGAkddqwtCd4poCwGHC6Ozsd4cLuigV5tFNb6mB/jwkVRsiu8gwajB3v3Rv5zt9qnjdOMEBZeDl+847YK88k80BSNB1MJjo04pB4NxF2gDv6OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vDGRHalM/ba89usxIlolch4mt3buyoyP3pgfGvX6mgA=;
 b=PrQEFfhhAqMA8eMHpsT++AIJwPA4pKIaIs+8lMEOCkXBnNM5VecNF3UjzLPmYBN8wy3OVxBnqjgpWgGO00S052jCPw8P0H81sg7BvMhnYhd9KjdROdhS2F1eR2NvHX4z3/vaLSpFqRNZ84Or5cx6vJeQbq+k2pwEKski64wPaPE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM8PR04MB7379.eurprd04.prod.outlook.com (2603:10a6:20b:1c4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Tue, 13 Dec
 2022 00:30:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 00:30:45 +0000
Date:   Tue, 13 Dec 2022 02:30:41 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        claudiu.manoil@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v3 net-next 0/2] enetc: unlock XDP_REDIRECT for XDP
 non-linear
Message-ID: <20221213003041.jgdotdqbodec2toz@skbuf>
References: <cover.1670680119.git.lorenzo@kernel.org>
 <20221212195130.w2f5ykiwek4jrvqu@skbuf>
 <Y5eZ87w4EKnmWFuW@lore-desk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5eZ87w4EKnmWFuW@lore-desk>
X-ClientProxiedBy: AS4P250CA0012.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM8PR04MB7379:EE_
X-MS-Office365-Filtering-Correlation-Id: a696b995-b731-47be-e5fd-08dadca14676
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xjIfQkgoqMhk6C+q2VP/OhTbzNpij6BvwfZB/Tg3rpbtA6FHYgSJGoG+EbPw3yWLl0YYjxmI9AGHkYD6Mf00t9E+cGwGhE+bzO8I3iYE+y4HWkU82XQnZ3G6dFPsKof3/GdXD1QIZ2QlJSXq1VHYIU4S7PzaPKjaUr6mbc2ePZMMWEjK78pRC6WhMoQGfj2M4SyeZXqWsVsWjIoCNuxD7Fn8/X8Q3aMhe3sdPE/gcHLT6GwTSag04r3CLNbW/2zgN9k/J7yq/OE2nRmjTjHCE1tTfZxBgKv+nEpYT9U0pdfFlueH7gyeC5v6rCNNEA/u3iDl5smqoJFQBv4QveZ4WPlxSIAMi7ablo8nYDT/JIO/pjjOiFRa/n7f+iA9gjVWRZ/fFESkw2+R0uiBksuql0FliYwaFccoGydOaOtLH7L8jYf5AhnH17RiHRfyfpxR36I8fjm7vI1+rkSeiiAW+X+P5XuhQ27/vc0YcTtAM5C+eUWNo+v9n5DmzzBaXl9flwhCMSnXEXoR7JHr6lDmAAFyzbopud0J5MJ81Wu+wBuWmxt8k8Y1laNhHaOdmj/yyDppx/AHrllud84tSM0LUvQIa5Y8UqbaNA9KaxhGNgp47NYcmIzsSuDn3EF+ISoqjM2GUtziurf68yyYJaBIwqE5SsD6B7nurxTuRETcDYI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(376002)(136003)(39860400002)(366004)(346002)(396003)(451199015)(6666004)(6506007)(316002)(6512007)(9686003)(6916009)(478600001)(6486002)(966005)(1076003)(2906002)(41300700001)(66476007)(66556008)(8676002)(66946007)(4326008)(5660300002)(83380400001)(44832011)(8936002)(33716001)(26005)(186003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cbThEo83paEVd1WP0y5pruHGxtp/0FA889r+YefqkOEMJc5I+soAPFv7J1xu?=
 =?us-ascii?Q?/HZEG4OzNVaIahXnBGhHlqSxqv50F6gZlTkh6d7kXb8b0YdyaBk1Hw7ZUscC?=
 =?us-ascii?Q?kCMaMwTyTerI6W0/gLIxjNy9UvDF01I2kwpeq0fSmJfbHE5TpiGsdAzhBcGz?=
 =?us-ascii?Q?y0sBdyfLsT+nsbMN4sKLmpFjOr3Rr2sSt6t5nqwpzxCr6OvkteQbUj8Uj5cy?=
 =?us-ascii?Q?YEB/3DJlj94LGH/lhwWZvLgRRUGQZJLBJ+znIqcHMG1zr5M9XY2fbBYspLyM?=
 =?us-ascii?Q?cfX9E65MlB0lKyCGJqE1Zo/rCugE682Ncnc16VeLY6OxF21P4awlrZT4zmU7?=
 =?us-ascii?Q?RBcNuAqDM3R6aInaRYlo9HDqUggC+lx/UghDy42nGuKdW/FsO6TO6558qUIZ?=
 =?us-ascii?Q?noLjygEZoZGU/tFMYv+bCN+axr9hE4orZXGiq2jWIXt2aj4LGSh4a6bLYfEY?=
 =?us-ascii?Q?S8EiNjnMAQn3fsX7wMLoWI4QC5OF/rHWeF5UMHk87L+PKWkIT/eeVUc8/tMI?=
 =?us-ascii?Q?inPm3IyNzfxISO5NwWUP3EvrEEYb5iiby6bwZcIDhY2o3YkP15VwlzwFjHj2?=
 =?us-ascii?Q?7TXfq12iQPUY5lvnkeQSXBhR1R2mULVLoMmonQzEmpz5HPvTRmNR3bjjfqcX?=
 =?us-ascii?Q?MO86+rImSDF4EEnLBQULrWdW0P+nLSb0w17cV6jNfZM8A1aKaOFlrXOStBFW?=
 =?us-ascii?Q?aX9QNhT9uGhhHdeNhBA6in7g/FVVbcMWZgN5NIe8DWnwQfY1Z+JF97Pyp4oW?=
 =?us-ascii?Q?r0mtJAb0ovGt8QbfsjC8Evm2BHtMy4P6Kg6NViK7YLaa5ScQWALPxjuGpioj?=
 =?us-ascii?Q?RR1XZ1WC+tmyyvvOpY3FLQdrPD+OV+XdPWjrGh4jX55bRN4p+HF/+hZ2Ovv2?=
 =?us-ascii?Q?u8i8baoO8EynIE988AVNQINq6gUGSKcTgz781sikHwpRJ+adBJ51SPMjmBYC?=
 =?us-ascii?Q?fzTLr4kgE2CRya2u8jdkDp96P1cGi+hy5IXCj+l75Bi58su8eJUBYQUurhOP?=
 =?us-ascii?Q?G1HmQKObUO8zo60M8dYpMKaqWobUaNGEh4HJyKgU/uWuNdKYjFQ366ipirUl?=
 =?us-ascii?Q?tH7DdwD4orIl4xHlSHycyDUQ+K6N4LEAQecWn+FUosXmZ2lA6utDcDYNxMMo?=
 =?us-ascii?Q?uMxozLnqmd4aq5FiVjuKLxqszKTCFnG7ipxrHt0nTIGx6duIntwCYUxCwkez?=
 =?us-ascii?Q?uBNed3UBNiW63JvlNw3Xk5MTivDTubfFjPf/I3VlvSm7BDoDsZP9krdxC63R?=
 =?us-ascii?Q?wU4sEv7+3VeVnYQZGz4QboGnETuPdib2AGwuLOSPBvyMglUPst+VuztCakBU?=
 =?us-ascii?Q?hCAgKR0zffvXJySfVs4ORTHJnPvB8hJQxo/tL/7/RZaeftWNH50CTMnSOK19?=
 =?us-ascii?Q?AYBumbHj6ohqW3KZu3ZtfESMIAY0x2pm7RaxrNuH+aY0qAhKXRzvF2Eyk18o?=
 =?us-ascii?Q?6Dtt6jvQnJnkNVnOUxDZtJ6Wi0lgqG587AqvRC36066QygEi8hWk9QKza3Mf?=
 =?us-ascii?Q?NelN4RXdv1aQyPyMngjB2Rz6QxTuGoh3FwcbIgswyESxJNQbLEkTRa1+w86F?=
 =?us-ascii?Q?BnIVvdWMnp5c71Oqw+njB7tbcIONNTINtUDZmw9upNeJ5W0cVeSsmGhfTVU9?=
 =?us-ascii?Q?pQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a696b995-b731-47be-e5fd-08dadca14676
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 00:30:45.8420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2xZoMyDP/rpnv5FAgY39mV4F1VLSI+pCltXqZeh6fiEWJaEwLtsrBuNzLQ9OeCwY/KoeI0uuxD9pY0SsgeUOmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7379
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 12, 2022 at 10:15:31PM +0100, Lorenzo Bianconi wrote:
> Hi Vladimir,
> 
> thx for testing. If we perform XDP_REDIRECT with SG XDP frames, the devmap
> code will always return an error and the driver is responsible to free the
> pending pages. Looking at the code, can the issue be the following?
> 
> - enetc_flip_rx_buff() will unmap the page and set rx_swbd->page = NULL if
>   the page is not reusable.
> - enetc_xdp_free() will not be able to free the page since rx_swbd->page is
>   NULL.
> 
> What do you think? I am wondering if we have a similar issue for 'linear' XDP
> buffer as well when xdp_do_redirect() returns an error. What do you think?

A bit more complicated, but that's the gist, yes. Thanks for the hint.
I was quite sure that this situation does not lead to a leak, because
even though rx_swbd->page becomes NULL, the reference to it is not lost.
But wrong I was. Not sure if you pointed out the condition where the
page is not reusable because that's the only part that's problematic,
or because you simply didn't notice that enetc_put_rx_buff() makes
rx_swbd->page = NULL too. In any case, it's normally quite rare for a
page to not be reusable, yet in this case, the way in which the page
becomes non reusable is the key to the bug.

Anyway, I've tested your patch set again with that fixed, and also
submitted the fix here:
https://patchwork.kernel.org/project/netdevbpf/patch/20221213001908.2347046-1-vladimir.oltean@nxp.com/

It works as it should now. And yes, the issue should also be
reproducible with single buffer XDP, if we redirect to a devmap which
doesn't implement ndo_xdp_xmit or is down, for example.
