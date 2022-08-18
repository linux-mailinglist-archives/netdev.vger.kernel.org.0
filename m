Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA4F5597E58
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 08:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243483AbiHRGCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 02:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238407AbiHRGCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 02:02:03 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2091.outbound.protection.outlook.com [40.107.237.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A057CAA7
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 23:01:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JBcuiAG6biWTfqu92w9rEfXaLO+05SvMaMC/QnRuzeJUJ1t26KTFJRqbxFNtlKT7j5hUNsg+sloJ3UA87K6280pSg7FRS38c0kVgSRrOlBOEy2w3KBdTNwhFqVJNezOacknRzN2RaWyKVIezVikm0bivrWOW68B+hBifUpKlE0mLFXYQU9MqbxAu5F1/XRyIej+Q09178BlqkMegVXOGyxtZowoEiAAXDvtekbjBjJC5ujy8idH5kK8GpiACpdYbRfTC+yY27V1GtZOEF4ZStDIDG2NL4TQsvXRaWPmo6zMua5HENgyWGUD953ckhBNhOX8VpKkJvT1nQN3llyS66w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pkf6Y3J2nuuUz2srwVw5mBFFwfPBwtUhh5fNbx2Ewjg=;
 b=bs0OZlqEqLyqJ71qGAvAh64jwqfFOEaCDMKu1X0IsaxgWtXX+IXxlS9nmZpHQa/NcSpID5LxvXsA9UePSFHv9yrsQq3pQRbdIWMyhu1MwfHe/HcQocsqKbFTPB8ZOBvTYWUEc2qdx9DgXnc57xX1bXoIpe7vesCbM0+FcDTrbQ7FQjlfdJaRYw6Ktg9fVM5qQ9QYEYRvAlnDtF31Ecy64nTpW5zxOLrcHPHvs8xPSbK2Q1hasJ5KuuqMYoZ8RlI12WQJEFvO46cVFEytgkdphV44QuYPocoh3pXxFfEMtArPD69/3mE8qEM+BMFUrAwR3DMUQDKDJW0Mdd2VSO30xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pkf6Y3J2nuuUz2srwVw5mBFFwfPBwtUhh5fNbx2Ewjg=;
 b=NTeaJ/1oKjyRS5ZnFDASYrP7Q2u6htlQlJj2KTOZe9t7WLsbl68GOyKlizJLtWzWe03beMxeAWsBYaSgrBW0za7StthBz7AK7zcf9DHDby36UqpXG3zYhbDjF4y1uU+rzY+ad3kcJEXq3+tv7fYdVpfcak3E/My0mlYZKrBKLrM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1389.namprd10.prod.outlook.com
 (2603:10b6:300:21::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Thu, 18 Aug
 2022 06:01:55 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5504.027; Thu, 18 Aug 2022
 06:01:55 +0000
Date:   Wed, 17 Aug 2022 23:01:51 -0700
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
Message-ID: <Yv3VzwXNdGMRAYfc@euler>
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
X-ClientProxiedBy: SJ0PR05CA0190.namprd05.prod.outlook.com
 (2603:10b6:a03:330::15) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1417f5fc-46b4-43a9-8362-08da80df2744
X-MS-TrafficTypeDiagnostic: MWHPR10MB1389:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e2mTMSWA1nt8sfXMjnF9BUE0/+yg3UyMSmKzj7rBmLfxk5oALpPOJudF9LVKcPO3me6K9bShHqQ7c/z5O8LslLjf1/SEnxa9yBO9uWo8qaxTSkzYKWYxyTXS9LWgF+f9VWmcuidB6JeqytJtq8bQgOOxJZ2MdmlWSqgwexMrmNuEqW5UG9Wbdo3XWgypaBhc52HMFo8uLd47VmIoEKpKxQkRlV4lBQVNM7IeFDjhxilRXnQSPAHnw8FO6f6B4Ud4AgcZhDxu7WoloBODiy1BsweXmm77JIj/cl9E7YwaszABxSxkvJVbFjZkcLwreHZbu0sz6LZKhYEhekI17QGkxUDpRTU5/dQQ0iHIhMboJs4DJB5oExm5hbtQHyFlxxYJZ9wBq+DG7UgzH7YCjh3un3zQIm/fnpxxwv/MAj/tpUvUOguc58pEKYP19d4R9psYb5qaiTUqFWKKEMBDWTZ3+BVQKmYbGMpVjpiiLuiLniEYndjUZ38CH45aYlpaib9vkJfaDWwhdYcbvKZrqHfyy+tEIQiKyH2pwCIOBBLIwWJyVGsMLtfq14toDMrgiL5BDWxaSI4PSwr9Jp5CNn2fDx3WwdXmIDGTQ6e/MujmGxFfsOTicbbmZhN5B//JfsJqBLxw34zVAC19iC6/WCf6FKB8uH5jh07KT/cEPxjzz4WKP97/7ouFnxypYFlq3Sk9IT7KAp7SrHGJfZ5kXi2kWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(136003)(376002)(396003)(366004)(39830400003)(346002)(83380400001)(186003)(38100700002)(5660300002)(7416002)(44832011)(8936002)(66946007)(66476007)(4326008)(8676002)(478600001)(6512007)(2906002)(41300700001)(9686003)(6486002)(6506007)(6666004)(26005)(316002)(54906003)(66556008)(6916009)(86362001)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z/CHLJ9hXrV7JpJJ9sqdEhr1pvUE+mGttINoDLpzfRusiPmITGOnpJBRq+Is?=
 =?us-ascii?Q?DRRUctFpQL4bfAbVllA541aKQRE6TEkAq28AgrsHDFA3O3V8K0mCWK51lzvZ?=
 =?us-ascii?Q?pFlj/QDmVJmSsfUw3MuPtwdO9k0BEi57UGJVzIEsHN+4uXy6Ipp5GfBBLz+u?=
 =?us-ascii?Q?nkJc6+AZez+lW9HcyBkGC6Z3dbI8x1HHHUGRJxcuvA6KFT6oyCJ6PZOKOb3S?=
 =?us-ascii?Q?+tXwg1TDTsegzSkGDLpRVwzu8UobCoJdktxWSV3lOLy+BZCwSG/Ixtv4yvKu?=
 =?us-ascii?Q?HnHwCOUjARcPX31Q25QB+8bs751nXYI0xP37CmVuN3YB8Sml/jZpX3f+nD/P?=
 =?us-ascii?Q?x35fYLg4tVrpGJf5L/5yecQMg2Yd+OOL9XaNYBUPXKImd7dBHKlLG5WG+LZa?=
 =?us-ascii?Q?1FFMaBmmkBJUAWCDAvU/Wa0yXhoKWDyREZpBXTwX4NQ9jw6hhy6R21PjnAYc?=
 =?us-ascii?Q?3C9kGDQq5YvPAwEp2nD32i0P5RqVDgC6r54N9JzzEIkoSyWNg6WTVyS5Ms8W?=
 =?us-ascii?Q?VOeH5TNhyjNixviSG9beVcr20sJmDvflUtQFjlN28rBzm9HmUx08x8O/3WF9?=
 =?us-ascii?Q?f/xRW13fWPykcF53VMANFhEHxR3/V8YpWhxDbQ+xaS2YASZBnJPS84hfE5Mg?=
 =?us-ascii?Q?KsdAF2Ha/ei1XdwCZrPyYiojEsKzosCFsbtb09FThlevb4Yc8I+gov8Z9NcC?=
 =?us-ascii?Q?qgqcgqwDhkchV/fSvWwFICBpM/7FErK7HKIM63GZPLoWUWSxzXJf9NF6+lSu?=
 =?us-ascii?Q?HhC7FjiEMkATSbqn2mfrKY8yr8KZYBWAOyUeIGJD53PjO8QrOx2RbIVl7mev?=
 =?us-ascii?Q?CidJJnOaHhbRf+Dsy+xTEWtol37t2OxVdzOo9nY/5i5ymRzXBm9pCBN1ltEO?=
 =?us-ascii?Q?unRMfNk78kro1vJIGO69/+6gbhGeJElHb3asDzttXf6v3DyrDwPVmjIPQWSG?=
 =?us-ascii?Q?423iKOIjtkPHnMyt3QMhCw3+IPMq84YQx9UbGKYfYWgobeltg4qLxY/5qqQe?=
 =?us-ascii?Q?QtaweugdRyV5NBkoH1You6fhWvYVsD8tVymWmyshi0BhmaleFS5VL7lBHzo9?=
 =?us-ascii?Q?woLMw8SABSI0/9MA66ZauYUQRaBw6khfo9llC1bCJRkIARD0nlKB4vxi5nfJ?=
 =?us-ascii?Q?WfSW25T07vKjEziAdYYK4RIo1l32pWVAWtwnqrntVfqihjjKQpiC+CfA/Na7?=
 =?us-ascii?Q?a92is2aO6uUwRRzVb53BiNx+S41kr/7q02V5I6S6SVQDoFJLtZbHaGxQW4FO?=
 =?us-ascii?Q?1AP27gYh6OlwygIcLuDGBNPwtoTXV/0axoi4Ov/S5mm2WlGPJ6guL4K5LEZe?=
 =?us-ascii?Q?ca5Bfq9zMEiPYakRo/uVEYXeXPgCiUa1uMsI32brvNko3gJr9H5JBwiJqgia?=
 =?us-ascii?Q?B52s3M381bq/l4LcQVaWaHXWyO8Y1WuNAwgw8Rf5BTeyjZbqvUtVEvO7auh7?=
 =?us-ascii?Q?Jy84eSFjoK0zJRhZ+ZiCN/YbWhib4rZ7q5oTFYsTEn8bbc6JDi+xI34riUOE?=
 =?us-ascii?Q?zq4GhKt1ruZhuvDBf993LL8ig7o+UBojp6JxfOS+x0h1bRBgmdrk39Pf7iwe?=
 =?us-ascii?Q?IVYjtelQcl9ASZJY3/ZAReu8asEP9dHn7siSwKIleH7tzoDD9+XsS6Fuw7EQ?=
 =?us-ascii?Q?vA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1417f5fc-46b4-43a9-8362-08da80df2744
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 06:01:55.3085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q2asMmpgTuiRZfgnY1ujhA+9Cd40okeXA3D3jtq/7nQ5MnRiOEDJ4EJNd6Is7SBqm/LgdhSFvQcStXjqJpNNOR+hm3QtR4gJA/tEY2/0bnk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1389
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
> > > > Tangentially related: I'm having a heck of a time getting the QSGMII
> > > > connection to the VSC8514 working correctly. I plan to write a tool to
> > > > print out human-readable register names. Am I right to assume this is
> > > > the job of a userspace application, translating the output of
> > > > /sys/kernel/debug/regmap/ reads to their datasheet-friendly names, and
> > > > not something that belongs in some sort of sysfs interface? I took a
> > > > peek at mv88e6xxx_dump but it didn't seem to be what I was looking for.
> > > 
> > > Why is the mv88e6xxx_dump kind of program (using devlink regions) not
> > > what you're looking for?
> > 
> > I suspect the issue I'm seeing is that there's something wrong with the
> > HSIO registers that control the QSGMII interface between the 7512 and
> > the 8514. Possibly something with PLL configuration / calibration? I
> > don't really know yet, and bouncing between the source
> > (ocelot_vsc7514.c, {felix,ocelot-ext}.c, phy-ocelot-serdes.c), the
> > reference design software, and the datasheet is slowing me down quite a
> > bit. Unless I am mistaken, it feels like the problems I'm chasing down
> > are at the register <> datasheet interface and not something exposed
> > through any existing interfaces.
> 
> So you mean you suspect that the HSIO register definitions are somehow
> wrong? You mean the phy-ocelot-serdes.c driver seems to behave strangely
> in a way that could possibly indicate it's accessing the wrong stuff?
> Do you have any indication that this is the case? I'm not familiar at
> all with blocks that weren't instantiated on NXP hardware (we have our
> own SERDES), and I see you're already monitoring the right source files,
> so I'm afraid there isn't much that I can help you with.

So I was crafting my response with an explanation of how I'd gotten to
where I was (starting in the footsteps of ocelot_vsc7512.c). Of course,
while trying to explain that, a couple things jumped out at me to try.

Long story short, phylink_ops wasn't getting invoked by anything. In
ocelot_vsc7512.c they get invoked by the net_device (I think) but in
ocelot-ext, while they were registered to the phylink, only the
felix pcs_config (and other phylink_pcs_ops). I had all the pieces,
but just didn't tie them all together.

So my current status is there's at least some full communication between
the 7512 and the 8514 to the external ports. I'll do some more thorough
testing as well. Now that I have more than 3 ports, I should be able to
run more of the elaborate kernel test scenarios. But also I'll have to
do a lot more validation and testing.


Thanks for the hints Vladimir! And for being helpful in this rubber-duck
debugging session :-)

> 
> > I plan to get some internal support on that front that can hopefully
> > point me in the right direction, or find what I have set up incorrectly.
> > Otherwise it probably doesn't even make sense to send out anything for
> > review until the MFD set gets accepted. Though maybe I'm wrong there.
> 
> IDK, if you have a concrete description of the problem, I suppose the
> contributors to the SERDES driver may be able to come up with a
> suggestion or two?
> 
> I suggest you try to cover all bases; is the HSIO PLL locked and at the
> right frequency for QSGMII? Does the lane acquire CDR lock? Are in-band
> autoneg settings in sync between the PCS and the PHY? Does the PCS
> report link up?
> 
> > I'd also like to try to keep my patch version count down to one nibble
> > next time, so I'm planning on keeping ports 0-3 and ports 4-7+ in
> > separate patch sets :D
