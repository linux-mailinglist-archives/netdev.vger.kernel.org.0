Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDC9597980
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 00:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238561AbiHQWH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 18:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235467AbiHQWHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 18:07:54 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2130.outbound.protection.outlook.com [40.107.95.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F7EA8CD7
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 15:07:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MsK6JJJYad+BAA3NU0txcNvyt3YjxmgWn+7jQR4+Pp978f4Rj1h4nrEXM07W6vhzAfJkbPE4IzBBHoRiZX0l/sN3cuDdzgrZFTcAFoXd4nTowhnBEiFBUKpKnmSdzo4SDD3mn08CyuT5l+bYwO0ZL1Xh/uQHA0nOcMn1/A5y8/l/WlWTS83vYP6mKi3FxdjM8UYk8xID4fUJIvh3P+sKpThnu7NXdP5h4rqhNioXQ/FailxMIXqQ/4GEDoBofIHwkji2frv8uiie4x2EDOqyQDLyVy4gAUxAwrvloFBeJqQAzoZqAJKQ488CEuP+E+bUb7y7Hn/Nh9Iw2X+ZstIVIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aYOnXGIs2euKYFaB+qugGJYYA8zQN44UaIeazkN83LY=;
 b=KDC/KHS3K6R0P4u+/wl7xT7ry+QKBI+aG7ebSvKT0tY9B7lzeS26yTy1409sMHchDHdmEqxaO3cd2sMGjU4rf6Zs+yuPzg3P8e6wR9WHzIGd2/4m3bLDGTvo69Ae6GrHm6r7CtHISd/gVxJgozXFbFNl1iGbHjsU4ghBjSX6u4A3wmoxA90IbXYEnYnVOtiI7QDga3yhfoYkpDvurfCycFjm65mv6Wd24pm2jUm965hF+KjpN4WcTTh+oKoKz9R0oBUqfLVc2nmQL5S2EwPrwF58LbwPNNlmMbaOb9U2gh8plet49HoLA6ydQmqST2A4y3JytRdscr3TA+KCVWKKbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aYOnXGIs2euKYFaB+qugGJYYA8zQN44UaIeazkN83LY=;
 b=sAqth5GQvScs/NQ4KDu4DP4R4wvONyEUDfUYLQVyiB1HTMkEjXQ7qKgxag+QH4Lsrw/2aJf4TWzN7PeKH7CdjrgQlCD1vpkAYclUseHkzyuzvYKdw1TA0CNlh3eVI9yQPp9mVkAX3JBiEEE6SlM4ExKsvEc4jqMZBKU+QoNmP5c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MN2PR10MB3199.namprd10.prod.outlook.com
 (2603:10b6:208:12c::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 17 Aug
 2022 22:07:50 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5504.027; Wed, 17 Aug 2022
 22:07:49 +0000
Date:   Wed, 17 Aug 2022 15:07:45 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: Re: [PATCH net 6/8] net: mscc: ocelot: make struct
 ocelot_stat_layout array indexable
Message-ID: <Yv1msZpA2BSJl6CH@colin-ia-desktop>
References: <20220816135352.1431497-1-vladimir.oltean@nxp.com>
 <20220816135352.1431497-7-vladimir.oltean@nxp.com>
 <YvyO1kjPKPQM0Zw8@euler>
 <20220817110644.bhvzl7fslq2l6g23@skbuf>
 <20220817130531.5zludhgmobkdjc32@skbuf>
 <Yv0FwVuroXgUsWNo@colin-ia-desktop>
 <20220817174226.ih5aikph6qyc2xtz@skbuf>
 <Yv1Tyy7mmHW1ltCP@colin-ia-desktop>
 <20220817220351.j6pzwufbdfqz3vat@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817220351.j6pzwufbdfqz3vat@skbuf>
X-ClientProxiedBy: MW4PR04CA0093.namprd04.prod.outlook.com
 (2603:10b6:303:83::8) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5544acd-e46a-4eef-f149-08da809cec3e
X-MS-TrafficTypeDiagnostic: MN2PR10MB3199:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Twscaf75TrSyf8KIC2xcuhmTcNDjW8RVaBFb7in/DUnV9SLc18VyVpmsKoJ3up+4Znhf7XPdMp7wm7ACwIzrHvEqenIlThAPq9Z1jXj9j4BTWWqtDEwtDW6UhY37SsoaW9EvC+nWAYBbF7vN0/RiUofmOc/q1UoU7Dnz8Cr21kGXraBc781qQRKjyMtpFnGofHM79xCUfXS5BiLI9b5DPe1hlXb4w/IWE0GqccCZKWY4aYX/enM2860wVd0++CjNvs+h6Ri5uBawHdvaTPCmlaOlWMH+1lNhP7UrsFePOHvxzu3sqBPOnoyGfwc9QSmJ66J94rlIJxmXBFzes/kvzavEqHt0GQUon6SZ7SC+2Yh0eNNdv2B1XIvw1Gs/zg8kSKVhCEHBa7y8OQUYNZa1eaXp4R+KS5qLvUph+h6ZIgXyJyW7kB5vVyDf3ggrLAGH6CntWUPkX5tvKXcU7Ix1/tT2lzZjfdp0FtnHqRm2FPpME4xLJMwIrWwZvkWV9vwcarFTzILWOsE32hnFgOvCENe92DKP7zvJVyAXViOBuuTKSDeFk4ABgNWf5IzhvbdeXzcISQMdRmcDtgezdEfLvSybErWl6CKxCpanbZn2Xvvy0wKGZQYvfOwIK5jZpKv5IQnBwrYTQ3q3jC+auQUid7ZL6JPXgnoqZyykxP2d7SbXtXjb0X9riOPL+gcLXsgXlwU3H34ii17pyqQJJsrXBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(39830400003)(396003)(136003)(376002)(346002)(316002)(38100700002)(6486002)(478600001)(5660300002)(7416002)(44832011)(86362001)(8936002)(6512007)(26005)(9686003)(6666004)(4326008)(8676002)(41300700001)(66946007)(6506007)(2906002)(66476007)(66556008)(6916009)(54906003)(186003)(83380400001)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yV+LDlFwvgmvQglNNSAXtQm1aGRo5TTFt+UeRkFvyFwgSMkIRzL3Dj6f2dWp?=
 =?us-ascii?Q?EsMnKypObeQiMdVBHcYHA+QI1wYRV/LSvgeYL2fwMG9L5id0Ab39h8LYg9kk?=
 =?us-ascii?Q?9vZjm/EGEErPdKLDUT3IQQoK5LiF4XmBiKHA+4rxpI0F9412KvCXqMsd3BSf?=
 =?us-ascii?Q?Sfn9tpPLi6s/0XeflgbIgntyOYAI3qnEjEYpmh4xtIoEFggnpWM10YmP7+s8?=
 =?us-ascii?Q?G+RNVWsnHGODHb5uuNVTy8SRih0oiJDxw7TXCQp4D7xtchmzK7id16xC953O?=
 =?us-ascii?Q?rHnnsa/aYtmgZT8kd9SmgqUqW1cBbitv5juu3EXhJ3YVZ4McXPuyCnkkxlSW?=
 =?us-ascii?Q?Js2QBT6K9unYa55Ct8YC2LOQCKPiwg4LVmsUeaTEzV+fqs1XTWEBJAqaaki1?=
 =?us-ascii?Q?+pB4NdD9MP2mKdSv4lBbvgYUDzsCuC5Cn3U3tAKlKzp7TrMWSm6oTv9Pf4TQ?=
 =?us-ascii?Q?NQ1l+LrVFGxUIMXACOVFGQFZNFvXGaV1giMMvytDpXhuXvN7JZc6hl229py0?=
 =?us-ascii?Q?r/JQbLZPg+j/k5einiS0vTUK948bJQBJJK32gn7Pu0bAmDXnvmumnxJalgSs?=
 =?us-ascii?Q?9BgZLSB3CMaMYKEnp9jU4NL1uLMuoXgQgh1PaAlLViKf3TatbBRrusQPp2Xw?=
 =?us-ascii?Q?tK84T1oG9OSyTryYH6FPmiDISH2grxObywR9cHMX29CZMmofNPctW3KFZHKQ?=
 =?us-ascii?Q?8uHzNtBEzZCYO6ylXSk3lBCvJHD7nh7UatjDI3PTcVXRtdG47uKbqZOGUhJw?=
 =?us-ascii?Q?OKtySbwWVztpFpUtF6Aa0J3Gl+imoKczyPM7PPX+HLFnR/Z/Kihb36FPLiwg?=
 =?us-ascii?Q?m/7c20BlzF5YyhwgkK5dDNq55Y0E/joiMsUDqvbSkYHj9t0GD3HIJNQiQbD3?=
 =?us-ascii?Q?iGMJEb+H3Sswt1niKwcbgUfP3sEC0OZg3EdGlbXx9Vlpur8XWer2hLpBl+99?=
 =?us-ascii?Q?YjrI14Tra4fhA8Wi8kdHz4eOhRTzS70CmgpOtTWnCsoGxrFizRgU8ucbe7us?=
 =?us-ascii?Q?8kf/zhHUZqMaZ/qSlkYAJ9/vY/HI/b5KBQ3kqgEid3mxFaG9HX1Yxh8M7Rdp?=
 =?us-ascii?Q?lXmmOin7t7mRVx/Y4MV3w/9JRVUIyasYy+QCasxrwfawJqirfcULEx1Gmh+U?=
 =?us-ascii?Q?61rTxqkqVHdHzgnkT4TSgVOpNAV3DohAMaaW3yuJXme6GvKsNXMEONwQeXq3?=
 =?us-ascii?Q?gqHQnoVHjjAuiQ38SHRaWojDJ+ucU7ByK49U/qmnKzcJkwmwv3VTUazL1f/5?=
 =?us-ascii?Q?9QFKBu1AGsWj3NI39aNhtGGK/Ilwtg1Ehw5Hd10VYpvkJJkOlSMit2K0eg9J?=
 =?us-ascii?Q?yzyV1ppdUhXh1JFEgBhE19+Ex5W8FE+fnzGzFVC6psHbxH4sPXTBzJ0sasNU?=
 =?us-ascii?Q?Qp515S4P9ctkwQ2PNVeeiufHBKfso826gFCs/Vq5JQx86GXQJOd6ZtGuRHM1?=
 =?us-ascii?Q?gSb91tT3DWBYWNQIYnRF/OxbwvWQhE+NG97A0YLMuzYfdCJfhCU9SQDIPd5E?=
 =?us-ascii?Q?pJvOLb/czXBssIX/zMCLxY6bLXJyVc60Y9vEM8CPEwSpfYHQ1qBIH2NBJTGc?=
 =?us-ascii?Q?/XTswsazsBxp7eGBgwbi9r72QNI3t/4nctLS9nVZy9iwcdXzC4k5XuW62R17?=
 =?us-ascii?Q?Ng=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5544acd-e46a-4eef-f149-08da809cec3e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 22:07:49.6116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d3ghOIPuecJm5OX4w6QsZD5dZTXVVqPvLKgVoRjkx5PHrmj0nPpLoGsWKJBtICS7NZKF/5xfavcyidLei2k5bLPRQhxn3N2dh89mn8UTGac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3199
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 10:03:51PM +0000, Vladimir Oltean wrote:
> On Wed, Aug 17, 2022 at 01:47:07PM -0700, Colin Foster wrote:
> > > How about we add this extra check?
> > > 
> > > diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
> > > index d39908c1c6c9..85259de86ec2 100644
> > > --- a/drivers/net/ethernet/mscc/ocelot_stats.c
> > > +++ b/drivers/net/ethernet/mscc/ocelot_stats.c
> > > @@ -385,7 +385,7 @@ EXPORT_SYMBOL(ocelot_port_get_stats64);
> > >  static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
> > >  {
> > >  	struct ocelot_stats_region *region = NULL;
> > > -	unsigned int last;
> > > +	unsigned int last = 0;
> > >  	int i;
> > >  
> > >  	INIT_LIST_HEAD(&ocelot->stats_regions);
> > > @@ -402,6 +402,12 @@ static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
> > >  			if (!region)
> > >  				return -ENOMEM;
> > >  
> > > +			/* enum ocelot_stat must be kept sorted in the same
> > > +			 * order as ocelot->stats_layout[i].reg in order to
> > > +			 * have efficient bulking.
> > > +			 */
> > > +			WARN_ON(last >= ocelot->stats_layout[i].reg);
> > > +
> > >  			region->base = ocelot->stats_layout[i].reg;
> > >  			region->count = 1;
> > >  			list_add_tail(&region->node, &ocelot->stats_regions);
> > > 
> > > If not, help me understand the concern better.
> > 
> > You get my concern. That's a good comment / addition. Gaps are welcome
> > in the register layout, but moving backwards will ensure (in the current
> > implementation) inefficiencies.
> 
> Ok. The WARN_ON() won't trigger with current code. Do you mind if I add
> it as a net-next change, and don't resend this series for net? I'm
> worried I'll miss this week's "net" pull request which means I'll have
> to wait some more for the other rework surrounding stats handling in the
> ocelot driver (which in turn is a dependency for frame preemption).

No objections here.

I'll respond in more detail to your other points in a separate email.
Might not be able to craft a response today.

