Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E9D65553D
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 23:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbiLWWhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 17:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbiLWWhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 17:37:07 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2098.outbound.protection.outlook.com [40.107.94.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC42616E
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 14:37:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H7JUsgR2LpTKJeZcPmZvuH9jzUH7Nq5ji6DCjns7guZvhpgtzqO4kzeWA6yQ5gbzUYYYgSE87CUoGL2Fy2dgcC8UzfeBOPMeakNNiQHLkQtNMo3yIW4LT0AcPcNwkbA8KnSgih5qa5QgoKaOSPId6oN6tGcVL6ooLPWgD855NKkwlsX0CtbfTg/NSg2OwOxKb6Vu2RI/LbsHiog2Vb40eu3JKM2sqribB8Ix6921HHALTC0cJkGCYabELtw38dY6q65pCcKezMkksNq0nprTcuS5WUUQTsrqGZzzRPY/VMjh1wmfKdcol2jib1nfONPHOBWoS6xVZkdMurvXWNIPRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jlj3+9i9CVBfdwgxDPj7zHH17+DMnBTFbNJKmOAW7xg=;
 b=CPGDb3qWeXGJUiJU4/hCIckR9nMemQvuDHA3j+/Lu4eDfT541SjLs9+CdZdHNLM8/kDoUFq1RWqRRulwGmFcgWe0DWDPK/YnjcC1G4ZKo7m/hfIG1r0c1MwsftM7Hw0Vn/lmH8ym2fDwMA03WGKPoB8GalC518CFL6aZmujt9IOAhZtunOrE+FwVOzvZtcwS+b0Y2Vv8VUO/jtnP8xch1PjGA2NJRQnjSmkLr91dPhyaNCFvJiMbeNE1cJwDs2psO45++9LjNB8y1P0hd+ZffiOZN1Tk4JZ/HQ7pHd5nV9xBAsZQ8g3EzCrMI/B1FkRjPS4y07JROg2Wg4Kx5KGBgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jlj3+9i9CVBfdwgxDPj7zHH17+DMnBTFbNJKmOAW7xg=;
 b=qYPdMkWBW0TEPWhWNgKZ3NWC16JS073u2oW5hP5duPYAYK5LQiVHscov6XTgCdLpDlaW5YreEYcrZvdWByIb0mQClyMXxrgBIzBVQHZGtpIl+nz6HzDk3lMb4Zyz8rgzcIEfWQKqFxSfa6M1ooRnPfyz/cFjRewzYnjRtp/T8Ts=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH0PR10MB4550.namprd10.prod.outlook.com
 (2603:10b6:510:34::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.13; Fri, 23 Dec
 2022 22:37:02 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5944.013; Fri, 23 Dec 2022
 22:37:02 +0000
Date:   Fri, 23 Dec 2022 14:36:59 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org
Subject: Re: Crosschip bridge functionality
Message-ID: <Y6YtiwqJWyv3yW9r@euler>
References: <Y6YDi0dtiKVezD8/@euler>
 <Y6YKBzDJfs8LP0ny@lunn.ch>
 <Y6YVhWSTg4zgQ6is@euler>
 <Y6YbPiI+pRjOQcxZ@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6YbPiI+pRjOQcxZ@lunn.ch>
X-ClientProxiedBy: MW4PR04CA0270.namprd04.prod.outlook.com
 (2603:10b6:303:88::35) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH0PR10MB4550:EE_
X-MS-Office365-Filtering-Correlation-Id: 699e75ab-e317-4d11-716c-08dae53635cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tLNaQAHhX5RGgdcH3cK89nQWRprL1qwtXu6+G9uGRHfxSHFr3XMTWvN1utQbtknjByXqwioXQD+Ytih/MFZlz41h9l3ybDfBd4q6RYREk9od97IDPy7VJI43p2xw8qL8Plb39vxrG4tS2pVxax5idY+YQWpfCBjILNi6NVgB4dhSZ6olbDTKapsvfPds0wZ4t20tgEIlDHDJeS2ORZ3Bx3wweeiBhojjGDlrGBJtzPuEzUbzY8NyxlXBuLIlCBzOvJ0of7u1FBqEtLTaQO1k+eBOpJlClhCUt1n3buTbdz4d3ThXt5Hdt4983LX6PDrbFpbaqj1aRXkLTUzvogXPnx88f4JDOHYI3cRvIbd38t2/6XiL1JhypDQRmu0aKBjlui9l04QdGWCTwKnbxhAVGHOMJ94CJ2hWvkYGCXOYn+3/hs5uSCGHVRuBH76KQ5Zv9D2Wge1fjSnL77IQ6iiR2y5yelWVVpwmdPQbpLwrOao3yXNEc/qeyM01zczwFy8yshPNoLN2uXFRCkZgdZdVpYjNC2cS9mh6EviG2XSbwiebv1/dU3lqeIM4Cv3e8EPsdx4l9xq24tU6ZqnKqPnRagNNLLC23ittu2yqtrMq0XSCzfxcOPWHry8znjCy+UC1GTm2buqG/d8j14IsdtCaPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(396003)(346002)(136003)(39830400003)(366004)(451199015)(2906002)(66899015)(44832011)(5660300002)(66556008)(66476007)(8936002)(66946007)(7116003)(4326008)(8676002)(41300700001)(38100700002)(54906003)(6916009)(316002)(6486002)(478600001)(33716001)(6666004)(6506007)(86362001)(3480700007)(9686003)(6512007)(26005)(186003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f2s0BPMf+KIVrx24lkWsNPECdP9quguHv/zVDzjQrT+Et6NsjHPh1QmO/KJp?=
 =?us-ascii?Q?qpo1YDORmJH+u8AjKFuAidwHjzXzhQGMZQf1l7LRkQgfff2nSUyiuBGYXgBm?=
 =?us-ascii?Q?SAgbOmCyRAASx09fcsw7DwaaSQxMbGkT1C9SshJpmHtunJgRVOTAfY6v4Tke?=
 =?us-ascii?Q?yqj3lMKUQU5BHnrmHwpMIQ87VK9i9mA8CmgwVrpx1+gTJG0JnTq4VAYIAsnZ?=
 =?us-ascii?Q?j7FQSVtTgRT7aNDj3/NHP7w7qtNHKZjSKdRB2VY2jGMoOwHdNs2XnqStuttd?=
 =?us-ascii?Q?xiPoM4aYWdCPGslrmiTX428GBy7o3HFY/I469kk/zX+gEyuob3swE5AIVeq2?=
 =?us-ascii?Q?tf1hqfWX1jG6EFdvD2IqzRB3/9siLUZEIdBRWVwX8S5/0ZmkNY635uIzkYuf?=
 =?us-ascii?Q?AzYHhZFYw5ZacNJJ9pZaK0EBkElIGSH+JLm5aT8nFzVSYivLRxe6LngoFSmJ?=
 =?us-ascii?Q?CW/hoq9mlPP4XAoYWxdbu11ZZLAiudtzRCKKYzZCXZ268oUZ8m/SZq91zl81?=
 =?us-ascii?Q?uVpUAqIyPRAVZq7Zmss8TqN4ZULImukljVFmEEEFdtgn0tzpjMTWO2rfYOSK?=
 =?us-ascii?Q?3UJ6cKrt3hdWVOkeCSYbnM0vrQF4OBEMMyGqJKSEWQa1WeYwJsfX5ZbsxqC7?=
 =?us-ascii?Q?54Hsvs3p4/KnUa/glnG2uiaNGS3buYA6aeaHNuCvRQaGeOdjpR9F+0TGlVTn?=
 =?us-ascii?Q?x0tK42VNDWapMLcsus/9X8Oq7P+Dc7fOu0gIQf3nho+vCufI47uC5JigQtcC?=
 =?us-ascii?Q?soRZUR94Dnf6RLcNuw5ghlCe4gUt41NjSU72Om3uQ2hf2A0YWonNeY39Uwx8?=
 =?us-ascii?Q?K/zy7FcZlqRgkGk7aQ3X6WiXtUOmLh9An+bWCQztRt7sDKC961oDLWa3BpFV?=
 =?us-ascii?Q?s1cDhpgJ9rdU40etnaVPnHRcwP5dppFZKeqd3OJuOzXaZqGFsEaLawhgyXrx?=
 =?us-ascii?Q?WtmaPauceBmGOXh/RahMYcPVLZP/wcS2awsu9DHXEtygwTKCHu6yGV0v8wKF?=
 =?us-ascii?Q?Hs+Jbt8+vb2J9Tva5RhiAFKBzyQnq23UjMArzBLfaq+FgZ6viNCUXcz9JuDv?=
 =?us-ascii?Q?Je6w2UG2qULF/mlM6VS1IigmoLXx9DgBzW5Zl0HQs1SFX0jnZZorpgKc07Qw?=
 =?us-ascii?Q?47o6fe5PrYPoDhzru7WRkdSDJsKhGD+/QQNN2w72sIK6Et9SC5iyjM5j7gCK?=
 =?us-ascii?Q?Y+M1CSZZuiKCoJWQhWb/sDq3KHFt6Ds8zi68gzUqB0I+9ByojLsWPP1unsCI?=
 =?us-ascii?Q?LceJgZyp0ooem6IvWX+1qMVN1WiFBcDbVTXBUMLQs753K6tRy7/theITHmL3?=
 =?us-ascii?Q?1ls3bFKZqzzbybEp/R46UKz1Z7MwNFkPop9sxJXxSWlly6Wh1PInlBAXPW2P?=
 =?us-ascii?Q?iZ3Wxf4q+kR8jDUhIp9DNTHVpFwfpqm93HVrZezmSL9vxqRsLSHHYvKxJPH1?=
 =?us-ascii?Q?HdjIpZFa9nc03S345jkBr4JnRZE4jlvNXwdb7XvzevoXZG8Ww3Byo6vbeZdK?=
 =?us-ascii?Q?aTlM93S6PmAjVIJC1dTqjh9bl3NspyisfTnH9GRuFTSpdZlkHfAx6a4ASqXE?=
 =?us-ascii?Q?eveAbYUFw66rcnAnnK3pEreCOwA2/DiNq95NP5uHBaxK7U3KLdVYT1tSPKbA?=
 =?us-ascii?Q?Hw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 699e75ab-e317-4d11-716c-08dae53635cd
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2022 22:37:02.3591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J6VutHhMSWSDPPGlxU1rk7rs2xUuaVwTZAWpt9JCdp010XMT2s+Iji1sVEfpR1QHquTChpyya7jv+tPTOgBC3vBMx0ue8tW0uHCoUePc2P4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4550
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 23, 2022 at 10:18:54PM +0100, Andrew Lunn wrote:
> > > > What's the catch?
> > > 
> > > I actually think you need silicon support for this. Earlier versions
> > > of the Marvell Switches are missing some functionality, which results
> > > in VLANs leaking in distributed setups. I think the switches also
> > > share information between themselves, over the DSA ports, i.e. the
> > > ports between switches.
> > > 
> > > I've no idea if you can replicate the Marvell DSA concept with VLANs.
> > > The Marvell header has D in DSA as a core concept. The SoC can request
> > > a frame is sent out a specific port of a specific switch. And each
> > > switch has a routing table which indicates what egress port to use to
> > > go towards a specific switch. Frames received at the SoC indicate both
> > > the ingress port and the ingress switch, etc.
> > 
> > "It might not work at all" is definitely a catch :-)
> > 
> > I haven't looked into the Marvell documentation about this, so maybe
> > that's where I should go next. It seems Ocelot chips support
> > double-tagging, which would lend itself to the SoC being able to
> > determine which port and switch for ingress and egress... though that
> > might imply it could only work with DSA ports on the first chip, which
> > would be an understandable limitation.
> > 
> > > 
> > > > In the Marvell case, is there any gotcha where "under these scenarios,
> > > > the controlling CPU needs to process packets at line rate"?
> > > 
> > > None that i know of. But i'm sure Marvell put a reasonable amount of
> > > thought into how to make a distributed switch. There is at least one
> > > patent covering the concept. It could be that a VLAN based
> > > re-implemention could have such problems. 
> > 
> > I'm starting to understand why there's only one user of
> > crosschip_bridge_* functions. So this sounds to me like a "don't go down
> > this path - you're in for trouble" scenario.
> 
> What is your real use case here?

Fair question. We have a baseboard configuration with cards that offer
customization / expansion. An example might be a card that offers
additional fibre / copper ports, which would lend itself very nicely to
a DSA configuration... more cards == more ports.

We can see some interesting use of vlans for all sorts of things. I
haven't been the boots on the ground, so I don't know all the use-cases.
My main hope is to be able to offer as much configurability for the
system integrators as possible. Maybe sw2p2 is a tap of sw1p2, while
sw2p3, sw2p4, and sw1p3 are bridged, with the CPU doing IGMP snooping
and running RSTP.

> 
> I know people have stacked switches before, and just operated them as
> stacked switches. So you need to configure each switch independently.
> What Marvell DSA does is make it transparent, so to some extent it
> looks like one big switch, not a collection of switches.

That is definitely possible. It might make the people doing any system
integration have a lot more knowledge than a simple "add this port to
that bridge". My goal is to make their lives as easy as can be.

It sounds like that all exists with Marvell hardware...
