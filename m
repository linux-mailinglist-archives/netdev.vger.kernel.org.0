Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89FFE6EE241
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 14:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234121AbjDYMzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 08:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233800AbjDYMzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 08:55:20 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2044.outbound.protection.outlook.com [40.107.8.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8051FBB8D
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 05:55:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPtVROBCSp9NuaQapLJxyHhXjdwavzetwz62dmzPmX9KD1oT32EnAsDqetkJOImTf5TL73yaNguAG54ONXGOWrsnVbxLWne1AZ1hmahoBqN9c2+ywNu6iEoqa85hDrrsJMhW+pC8BcZ/Nhq6w/QUTBchotuFJsNZMQSQiLDj/81vkGYRmdoh4OGcM+sNNoO2Kc5iU6ePPr45HmJEQMtA8EHnE5D9BV+ZaZXVtypI3h94i7ekF9YZ7uzwFdoiuODMV8l7Q5YKABKmvzVEpYCtlbET4c55Fz6xW9oZw+9h/r+UXlmvEXklyjDrwyaxC1qKrKYpx57EPuJksu3tLQhRXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QNqiE0Rlj3JYcGYKKM5aE5aaR7H/D7vDCGjKczKUqhg=;
 b=MHmg8HfuMOLVMW9FACYSa0ej6xeeNpP25CASpOh53ew/9ZGzAcj0lpZohDTiiVcHfRhRkEsB5F2h6Grcq8s6vXniLXrg4KEoSZP93dwn7rsqa0yUTUtp94sTilr2BKD1pzirHPhzdxl0T0OdtadQMuYUBKnItvNeeXxPgImSPhsOFup0rPIn+d/tH+z7ns6xDiYCFTxHRbGAuykIqaNBHBRH5vTu88PaGq1shY1xSmpIJ7rU6iBChUE+6USJ/X9OqDq1qkSASQPgAPZdLyMYTN2D6uUEe5JieuvkdCoDvHjyTACr0bqxIWDViw9rdwwItUaBG5LIkvMz39foYonkEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNqiE0Rlj3JYcGYKKM5aE5aaR7H/D7vDCGjKczKUqhg=;
 b=NRNN6uBHVSbKsu/kPlrBFYM3uKQDMgPjjHl/yfkUuoQMFlc3tPLSNilxjdUPZQApn2CrxPz1PUJqsbAyKLAuJIpoNK+CV5KGA99aqGISEgIFRknfDyRc7wyXHZF9TN7B/vrXU6cJtEgAiRpYzchTc9XOUeI5L3FFHnPpdKlC9kE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AM7PR04MB6791.eurprd04.prod.outlook.com (2603:10a6:20b:103::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.34; Tue, 25 Apr
 2023 12:55:15 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::245a:9272:b30a:a21c%3]) with mapi id 15.20.6319.033; Tue, 25 Apr 2023
 12:55:15 +0000
Date:   Tue, 25 Apr 2023 15:55:11 +0300
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH v2 iproute2-next 00/10] Add tc-mqprio and tc-taprio
 support for preemptible traffic classes
Message-ID: <20230425125511.qro3vql5aivxnxlh@skbuf>
References: <20230418113953.818831-1-vladimir.oltean@nxp.com>
 <535c37f2-df90-ae4b-5b5a-8bf75916ad22@kernel.org>
 <20230422165945.7df2xbpeg3llgt7x@skbuf>
 <5575810d-ceee-7b7b-fba4-e14e5ca6e412@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5575810d-ceee-7b7b-fba4-e14e5ca6e412@kernel.org>
X-ClientProxiedBy: AM0PR02CA0010.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::23) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AM7PR04MB6791:EE_
X-MS-Office365-Filtering-Correlation-Id: 79d6e91f-5f95-4499-413d-08db458c505c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QFWbEqOvHPbhAS9xSWIBApxe0ClaiOMBIhe64pBjDRKGBJo9Y4Yr4t9SnODExHwXDWpizghrDTRHdhoIQ/cdJVs0Rm9GDBdRKHsnTnUgjeWCcbddX2Q2S7rT8XBUqd1D7pi9ZHZtkG815ZSuOYLHvKj/0d5td/GLQX1ArVvX69aivjDG7vUJ5YwuyuGzUQw4TziefhxhmR7w0ozEQGgFaK7wyq0id40pDkOHSFTdSl4N4N2oaraH8Yb6Yu6uJRyHSW9te4WKjCd5x35A0Yljd9HrT3lbLjUllRvUCpCgO+JKFejRoAOENQ43WijvIOlcWh/PlsqF76mW1ZVBPM4QGEij+KTg7Kev1gvvow8jo2UZvvMSrTj1yePb/tmh41vqVYRfPUTyCtkWtw9AWR0I4f8kUgdUkwAX/qXk+4W5kc9si4ddwcEZ2s6zRXEnU4hAByvpkMyr1AOr3BSGV35bueBgIruT2MeB7O+v328u9rK+7A/NvU8fllKZy7uIGvioCYSOdb4LwDHka3KEvp1Tig9t3rRPqTOvMUjjwpD7K/GbIswe6gEMPpmFlkE+J3rq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(39860400002)(346002)(136003)(396003)(376002)(366004)(451199021)(66556008)(86362001)(83380400001)(26005)(186003)(1076003)(6506007)(6512007)(9686003)(53546011)(38100700002)(44832011)(4326008)(6916009)(5660300002)(316002)(8936002)(41300700001)(8676002)(6486002)(6666004)(66476007)(66946007)(478600001)(33716001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M1OhsgsKPHNTovLzqWHAP+OpUsVREkl7Okx/pV/TtHd7hyFIV0UCO7Sn+U8P?=
 =?us-ascii?Q?xz1tGiLD648cOy7Zxi6Hd1TWiPMSCapl6aiLCcxLgOzAZxWsCDkUFa4nhEIR?=
 =?us-ascii?Q?8xXRQf+vfKv2KBLBrMecK7nRSVL+QTcSFsj6RY+d9Ga5TsahYCz0/pr2SkE4?=
 =?us-ascii?Q?3rdxY/7EbWJlu8wzGtyPdXu+2q/tEFvJ1OfDlx6Iq7kx7EJAhpkmoEithmL6?=
 =?us-ascii?Q?J554a9vdYRhBWQkA0BdZXXRx2ZaHu3gTvfeWVElOzttM9pbI94PgP+swBQ46?=
 =?us-ascii?Q?SdC2swvKnOMF3xASbZztE9/xBrdmrFpJ2m79Vt8ZomcNB1xvGZXrVcq/4np+?=
 =?us-ascii?Q?iAneouXncifT0e155CUjliWp8T0ZgQtkX8s2NpWGxy9ovBfTzEJZEAiEAB/F?=
 =?us-ascii?Q?YGgZVoshmTL0XWxcGzpdo21WKzvhp0lyjxOzmVP9D25jWTWvkgYBpG6IY+vS?=
 =?us-ascii?Q?7eY5lTVu1jtuv/aesYPU26dImmWR8WN9g/MB+SPk/5wEC8fPZCFDKj/SmwDN?=
 =?us-ascii?Q?FAbyG0224DlskXinUTDvm4cApdGso5C+YpoJmjEf/KbstJBf8yoblx2hRLl7?=
 =?us-ascii?Q?a2Fbztg1j+Cg9oRtxCUw4FsR/RmSLzOFWl5sR3fKatJ6tRVZTlfCKN+Fm8Nm?=
 =?us-ascii?Q?TCIl1vRtWWJU6ctO4ovYcgZ2gCXbIy4sJ9mwt9YFgmDSAndQKuO0gmfh6yNL?=
 =?us-ascii?Q?g9r0LmtNspbdcoTyy232mhAoH8JRIdtpDvgBIq6lsovrsEDV13aSlh1cayhZ?=
 =?us-ascii?Q?YlX+5PllTxb8c2Rnov8gXTqET6+q1ZJpYSuxWHJIVLPIeA+x1nnUpwaNUrxq?=
 =?us-ascii?Q?buthN20DvP3GtUk+/2wYRo8jeg/QMxXFcnIhZAVDUID+dqgVxSGo0HfBeYdw?=
 =?us-ascii?Q?XsSliVu+1pLCLnn1YqigbGBA8hWjtb7IG2LAO6hJRcj6ymbGec918G6jRPme?=
 =?us-ascii?Q?dKNTcAnVJUs8DDUt9TT59dgDFHXVoPe1nmJ3QvjBGH1j2UgeUxJPxDp2FqY/?=
 =?us-ascii?Q?X4ZRIUBN5Jw3SA9UlTYUk58f3jd99/ewyseuJsPX1JbJhALjwfVbFu1GJto4?=
 =?us-ascii?Q?tlJ00utqzxD5eFviSUAD6EW9sPE72tObwJ879slQCi6qEjYPLiOT13MbqtSV?=
 =?us-ascii?Q?5bWvGqurtylr3o4JlYc0vgMSJX5XUe+wOVvy4+fsq8LedgG8EKZq2n+eEbKH?=
 =?us-ascii?Q?DuS65Q3JJ6up13dcSWEmThf/9iesikwNqE3H/6wNJmHPffxZdtpcyMig1JkS?=
 =?us-ascii?Q?PvMCExhL+Bn8tYUfBIh09wwENSsb1VDfwgzQaiFYdzj2Vb3BqSuXTDhO1mcF?=
 =?us-ascii?Q?HMtKK96INu8YtAfS1/Ge2et9F3eQVjRP4ctJaPaqEDwmJ8JzVNEz41XXrUxf?=
 =?us-ascii?Q?pCkDX0t6nXXdkX7/IQ5/24E7/DZ10XogPzpAHEgWBn0TyI817UCM0QvlNjWT?=
 =?us-ascii?Q?qC5fF85vpx8QPQCG03aLRBkaIzh0yWgNH9+Ft0jYT2vhvrLYKvqQ9a0Zpn6l?=
 =?us-ascii?Q?twLegdMZv7qZ1WoxkifXfP7uqqjIUsJm5Z4nKr5s82ZP5lyjQcfZdA0a2gcw?=
 =?us-ascii?Q?XFpDIVoLpesYaf5l438DY8sbfKNaTLv0NytCjrWuozgLXalkvIIrK6w/eJLk?=
 =?us-ascii?Q?HQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79d6e91f-5f95-4499-413d-08db458c505c
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2023 12:55:15.0696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nskSbaKGIq+Il3F4sasQnp/QlUbkTBzOUOGyJHu2LxLIbTcyRpnsMmyOow8NMu6YbVYo3mTvs40+PDXQUFz1SA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6791
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 07:47:31PM -0600, David Ahern wrote:
> On 4/22/23 10:59 AM, Vladimir Oltean wrote:
> > Unless there are changes I need to make to the contents of the patches,
> > could you take these from the lists, or is that a no-no?
> 
> iproute2 follows the netdev dev model with a main tree for bug fixes and
> -next tree for features. In the future please separate out the patches
> and send with proper targets. If a merge is needed you can state that in
> the cover letter of the set for -next.

I know that the trees are split and it is no coincidence that my patches
were sorted in the correct order. I've been working for 10 months on
this small feature and I was impatient to get it over with, so I wanted
to eliminate one round-trip time if possible (send to "iproute2", ask
for merge, send to "iproute2-next"). I requested this honestly thinking
that there would be no difference to the end result, only less pretentious
in terms of the process. If there is any automation (I didn't see any in
Patchwork at least) or any other reason that would justify the more
pretentious process, then again, my excuses, I plead ignorance and I
will follow it more strictly next time, but I'd also like to know it :)
