Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A463E5B5D9A
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 17:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiILPr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 11:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiILPr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 11:47:57 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2101.outbound.protection.outlook.com [40.107.220.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19DF12F3A8;
        Mon, 12 Sep 2022 08:47:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a49m73gDECx7E1QaJ9usuZSpiDdPHhQtJQoEYKBGGJOf24/XguTRrZFZtgXJwYWe3bwgcuUAzLiFZOAxx8O6YRZ75QfvEUuKmc1NqdkZCkcGsflhV/5D4HSwZ0mCcmrPtUgotiiwIDKOY55b8Tpcj/Ghq66IuxdifUKG2miq2ubz4zaT2EuJ8t+MCtFJlLTQLu3CqUSzGjTm99eSje4+FmINsxPtNcjV2YUVadSWy1MXcfcX4cYZMVztAV8l8pmDWuffcpi+qfPGvZzOIjT9jDHT4RwXMjiq2+vI2N7DN/mrX+vYwOkI+FbGOwQ7gO8uiHYaHH+hK+Mxeqobw19LVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qvlZZH5mN3V8JPuGRpwif9a1jiT0DI1AJQREUXxlKRU=;
 b=O9LGeSVyPuN/ukkJcmvpQeOAf9IhYv7E7AH5btaRpSL07rov3OVucH+7Fq5xMOlAm1Iee3hwbSoBXbM5X7D89LJsRI6TbfedxuTWx1eVOgJjQ6Hz2KZweLMmSJ7KwZgwG4oiXld2pqnZlDTMrFI3MkVxQABprJmoLZivqraBiKgytIGb8u4nx3QA2velYrzz6ndj+eiV3fGM0ntbOM7sBw8XH8K0jJ1kTZEBLvRuzRq8B5nS/LQJVFmgtLKeycjPdoJqK/0xa8Q/ORJ0JeUTgaP9AHLockyM2lDb4TYWN86M+ce2Dy8LlR+EU69I2vxG+V5N3c/YPwikOQyCJQPZYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qvlZZH5mN3V8JPuGRpwif9a1jiT0DI1AJQREUXxlKRU=;
 b=rjx97/oW8rTWA0vJr91gFVaszuSOe5cGtZ0ofx72CZa+VjRpYa0pKuyGBdopmfiIsZSaIVIB2paZzRhylTZKSITDkpa5+WExyAeyYJZnGkw33lq94xkhFwGtQRigJ32DyvciaIWPACulNg9uWM9J5/Zq9NWitzeaKlpHWx81SO8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH3PR10MB6809.namprd10.prod.outlook.com
 (2603:10b6:610:141::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Mon, 12 Sep
 2022 15:47:53 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::38ee:4bfb:c7b8:72e1%7]) with mapi id 15.20.5588.020; Mon, 12 Sep 2022
 15:47:52 +0000
Date:   Mon, 12 Sep 2022 08:47:47 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [RFC v1 net-next 6/8] net: dsa: felix: populate mac_capabilities
 for all ports
Message-ID: <Yx9Uo9RiI7bRZvLC@colin-ia-desktop>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-7-colin.foster@in-advantage.com>
 <Yx7yZESuK6Jh0Q8X@shell.armlinux.org.uk>
 <20220912101621.ttnsxmjmaor2cd7d@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912101621.ttnsxmjmaor2cd7d@skbuf>
X-ClientProxiedBy: BY5PR04CA0002.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::12) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a246145b-ce36-49cf-f0eb-08da94d62723
X-MS-TrafficTypeDiagnostic: CH3PR10MB6809:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AkrTUPlP7ft91k9Ug0MAnEMqEMa275849YNVxuid9Yu7BFQvBJ0EYoQVaYaAvuVICtyT/ZGbTZyQcWbuqeCOL6s7SIwPZMI7HHF3msBnl+Fjr4VedJ8FgisTIv4rHIAtVh1brZvH3mNJSB1jqFlL2DCkSq9anSA5ZEFb/RGKpbfd3Y4kluqHjT9Ji73JCdO9SXXZ37gzE0YBnjFNqLkD/fpShn9G9N76CkSLTeDFQqNJRncjLNlKTlMbZzT6KMpmtaybPyaIwVhnHkRDcqKx9seb8JVRwWNpqf2habSbFNI9+eFVEjliE/5oiv8Mg9eyvm0vhEYQCKwbSvjFsYZG3KNrEucqFBMfFdfHQuICJqbZAbNZpQmB6V4qqlOI2t+wsu4rbvPXrPDhohtl7g30FTN1U3KyZvbKv5m4ov39hREMad/de4hH8LwqvwcVj0Emz1/H2bsK1twVE8b9T8lMytdZzMB2zAVlC/+Z8LEirSynbvh8aKzVyMxp/nCU/PyLB1xiR7BQc2ItoDZc15BaJF0WrFCwVZiXB8HM8tNUduBnVSLp/usJ/85jyAyGbJeCFo4iPZIVz5pQyjhMppXA6c6miAx/DPAO7dfEcYT4H3g5dTVIXNb8/9G9rr7aNOmnr9XIZ2wwb8bH5bmD4ed7k9plY85m4PE9dbe/oZaqS6bx917EU6ZSvh4hBnF6EFBhTLL6gjQ6w55paG7vymJMpCsTcMOfc43yuMosPyPq0aE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(136003)(346002)(366004)(396003)(39840400004)(376002)(83380400001)(38100700002)(7416002)(2906002)(44832011)(186003)(316002)(8936002)(5660300002)(33716001)(66946007)(4326008)(66476007)(66556008)(8676002)(54906003)(41300700001)(6916009)(86362001)(6506007)(6512007)(9686003)(6666004)(26005)(478600001)(6486002)(966005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PE4w4Ny4EhTKXXrSEXVuxWVt5XP7YIalaI5IrkfupXynLfP/szWhIWEkHMmQ?=
 =?us-ascii?Q?ZAEK1e6a0o26ojQcLARknRmr+YZrLnak7Uuny5cZuRlEo5Fe+fLve2zHP+qW?=
 =?us-ascii?Q?0TVnBGTYI7AbuOhCwvyDNYJW7Ljg8+IVf1LJYQU5kEUMsDSw1UFcIMR8t5g3?=
 =?us-ascii?Q?tM7ywSMGcdPxk+9atF4OzcccAbVmzVzV30CzI/IsRHr48HzCx8JhfKTKOeWO?=
 =?us-ascii?Q?CyfwPieM3BMg7/zTyGic7YuM9MbpLtKIGxh7dE+C3ZQyBE5PleoHY8SUhgHr?=
 =?us-ascii?Q?2o27lwFe9g3CfTeRHa7xaNoNf+0SxO0GGtt4v/lSHxeYMahmQPc1vu4AXjEy?=
 =?us-ascii?Q?eIb+ob3Z6Y1iYRXRtP6V7AKnQHUFzgsLvnFgjclcmQM5UbTp+2tCkKKyHC8H?=
 =?us-ascii?Q?XIZrYuH5B7UT/jJrh29DJjRqep2Bvi7e3ZISwNiEyiNvwIa9TK19lUEkNawQ?=
 =?us-ascii?Q?8OrC70PJfoppMVfTkGSOzMRzmr7Hv+uXnB6e2wbwfv9mmaqYFNaMaofwfKHW?=
 =?us-ascii?Q?SXm8TbVPiE5E00qztIC7CqcTbBd2sPCxVKIhBnhk1Mnbf9gC61XfMelhFYCc?=
 =?us-ascii?Q?TSqVnNH67R2LJomYY/EPIHqQb/MVCmho+ApPkyGq7yYATDE8wOAfVuEySMpC?=
 =?us-ascii?Q?fwLU7QW8nfWqrnJuBu0LyQd7oZLpHy2kiyR2YjTjO4aIRAytiSr66Oiehz23?=
 =?us-ascii?Q?+5ZgpdEJXmRFUUa61cSP9r9S8/xjwKkQMGxSE1O0MWTkYZfKYWcK8VpQh407?=
 =?us-ascii?Q?63J0hPV25/zdfJBYvcdnu05JlD5tzWYNDKI0eMrPDWmSsbOww8lnMS+ufPuP?=
 =?us-ascii?Q?Axa/kYlLRnUpuiQnXmi3H9rXRfHaOj61k8UsJYpwMah08Rsu/cdxDsuSkbdq?=
 =?us-ascii?Q?eJtOJp9o27K1Sx7PzYDxPb7jyzyKx1kfFkusPCHHUVvPgZOsa9TowRlqXXHI?=
 =?us-ascii?Q?CoG3YhY5Li6SL41M0y9wdEIERL1UUZOWDLsWZzHrXlOrjFh52VKAFGYkLWwE?=
 =?us-ascii?Q?V88VXLVTON7Afy/aM5gxzDbfrl7G6d4dunJ90fPbuDLfeep2iPp9EbLVtqMz?=
 =?us-ascii?Q?N9yZOE9KJIXHEMXPgDaYFcmOjX36/OCCejlZds+wJXmWm9u/xY3lpCACUV1Z?=
 =?us-ascii?Q?++vuIUk5L8Hb28Syzt4oFlCQI9fQjZCZk+yyaGYrD2hArB8zFyoBF/XAc/wH?=
 =?us-ascii?Q?v3PxaRkCmIyB+3kvDR2AUkphB05/Zmn7fNEr4yTJM8iNN3gdBCp7MFG8xVzx?=
 =?us-ascii?Q?cLNmkrfyzRh/N0NBTF3cA5si3zXVkD0Fo6iXKRqou/MDtf7a6Qod00XCddNk?=
 =?us-ascii?Q?zxSa/j/G7XoMN8zu+aq2N8WTHGGPPOpjprlXWWUIcRwhvUrU7DPK1zqmuhuf?=
 =?us-ascii?Q?hC5uwOjDoeGEfu3Czf1Sc+uEdLiIKA1TuaSl1+EEppoQd32F1SfY9sZuK/aL?=
 =?us-ascii?Q?8KXUiJOel7aEWXjCG8AJDAyRuaVVSgQSRaCrzzjYlHJYVToTxkzOhMwUtqJu?=
 =?us-ascii?Q?0BLkSkugoh1uPjs3Wk4Resl0d6loRc7ONKfY0cX+F0aWwUM9+ns3AivVm5OE?=
 =?us-ascii?Q?L9/LFqvDJxkLGIGl0goqpfBXD5IIkj2NysaTPiKNg22k7+KESltihBkSCIkB?=
 =?us-ascii?Q?TCqgvE1qTZR3B82TlNUKt34=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a246145b-ce36-49cf-f0eb-08da94d62723
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 15:47:52.8331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pvOYd3Yy2sSV3dA4nDN5lEMFebQefvUdYT0zAKRZ6L0paP+d4ri7QdBMWz91oGW1VAIeKoryIYeFhwmR9JTbJTi5iriS9VNnanEM59QtuKg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6809
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 10:16:21AM +0000, Vladimir Oltean wrote:
> On Mon, Sep 12, 2022 at 09:48:36AM +0100, Russell King (Oracle) wrote:
> > On Sun, Sep 11, 2022 at 01:02:42PM -0700, Colin Foster wrote:
> > > phylink_generic_validate() requires that mac_capabilities is correctly
> > > populated. While no existing drivers have used phylink_generic_validate(),
> > > the ocelot_ext.c driver will. Populate this element so the use of existing
> > > functions is possible.
> > 
> > Ocelot always fills in the .phylink_validate method in struct
> > dsa_switch_ops, mac_capabilities won't be used as
> > phylink_generic_validate() will not be called by
> > dsa_port_phylink_validate().
> 
> Correct, but felix_phylink_validate() _can_ still directly call
> phylink_validate(), right? Colin does not have the full support for
> ocelot_ext in this patch set, but this is what he intends to do.

As you mentioned, I do in fact call phylink_generic_validate() in 8/8.

> 
> > Also "no existing drivers have used phylink_generic_validate()" I
> > wonder which drivers you are referring to there. If you are referring
> > to DSA drivers, then it is extensively used. The following is from
> > Linus' tree as of today:
> 
> By "existing drivers", it is meant felix_vsc9959.c and seville_vsc9953.c,
> two drivers in their own right, which use the common felix.c to talk to
> (a) DSA and (b) the ocelot switch lib in drivers/net/ethernet/mscc/.
> It is true that these existing drivers do not use phylink_generic_validate().
> Furthermore, Colin's new ocelot_ext.c is on the same level as
> felix_vsc9959.c and seville_vsc9953.c, will use felix.c in the same way,
> and will want to use phylink_generic_validate().
> 
> > Secondly, I don't see a purpose for this patch in the following
> > patches, as Ocelot continues to always fill in .phylink_validate,
> > and as I mentioned above, as long as that member is filled in,
> > mac_capabilities won't be used unless you explicitly call
> > phylink_generic_validate() in your .phylink_validate() callback.
> 
> Yes, explicit calling is what Colin explained that he wants to do.
> 
> > Therefore, I think you can drop this patch from your series and
> > you won't see any functional change.
> 
> This is true. I am also a bit surprised at Colin's choices to
> (a) not ask the netdev maintainers to pull into net-next the immutable
>     branch that Lee provided here:
>     https://lore.kernel.org/lkml/YxrjyHcceLOFlT%2Fc@google.com/
>     and instead send some patches for review which are difficult to
>     apply directly to any tree

As mentioned in the cover letter, I don't expect this to necessarily be
ready by the next merge window. But seemingly I misjudged whether
merging the net-next and Lee's tree would be more tedious for the netdev
maintainers than looking at the RFC for reviewers. I'm trying to create
as little hassle for people as I can. Apologies.
