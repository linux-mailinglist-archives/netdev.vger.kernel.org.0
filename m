Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9385160C2
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 00:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237778AbiD3WaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 18:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiD3WaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 18:30:16 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2100.outbound.protection.outlook.com [40.107.244.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4E839169;
        Sat, 30 Apr 2022 15:26:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CH/zScOd0JVfhmAwIErOF5fFYwl7QpZotnCI8Vly9yEOS1eHZwSeuMR74NhUQz3j9K4W6H0mzWajH6TqDSJCkqN2l7mBTwL7BlMSRQfYIsGhRyw6iZXcB9hoIEZqk6TCCDpNPlhJvi44isKlvhTCC/oLuxgP6d2DYaM+RwX6Ii1irKre34mA4+299Lvw1BzzQxBcRxw9qPHQLlc8PT6xXTApU8mGfHZ9k5snldz1RNhEWMZvfuvWmCDdR7HqhM8Exx2bzTllEmQQJTOm/iZzq/wcAtuvZyEJF7EQSPuvhpM8DozhnMp2YNA8PnsorHEppZTJZLxn+aXPav8kjexy7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jYDbVF8FCKw8H5MQl+rajNSKvul/l0QQ1SLQkqmQhaM=;
 b=FmWChBB9ZV8j55QuqS/5yBkEW6c4Pzae9ldeYwXq3kduEl/DAMfz8ouS0L7GhFExlAPJ3XsUWsuTQifYvJQuUzPL0l3k/FywJQqqwMVcbl+e0wGRqDYg4TpnyhHIrG+547neD6HqSfjJLKDcNhFYZ5CPqoCNJkNeJjKjeFYWneitAtTdlRH4EKDjYIcZrtVhaekRtwUwD58+b6nG5tyreZu+0BxRAY4l+qeGHBiMCFwcTVuA5NLUTC5Bc4D5WeFLUPK6HEQfuJUSCQuYFK7JkkqxTmAYmS3IHb8dKqg/+st1vdyzUwjy93EfN9EkkJZx0wbYBhla1FeEd17SU/viPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jYDbVF8FCKw8H5MQl+rajNSKvul/l0QQ1SLQkqmQhaM=;
 b=XemXciXHmmVOiH5z7i6soQ7uScnbjbqXm7DLHxAp1A8AwtDOIzxXZHcaXWo2DK5vXECDQ0miUxsFVW2ruhkVoyvX8nsdi32pp7C+rPnA8YYopw2GtXQKgEiwuvoPgrWSN3sRdo0EOcvuQ7aw0yV2qNTNNxEeIYi7J6tMLKhaORo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY4PR1001MB2407.namprd10.prod.outlook.com
 (2603:10b6:910:47::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Sat, 30 Apr
 2022 22:26:50 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5186.028; Sat, 30 Apr 2022
 22:26:50 +0000
Date:   Sat, 30 Apr 2022 15:26:43 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v1 net 2/2] net: mscc: ocelot: fix possible memory
 conflict for vcap_props
Message-ID: <20220430222643.GA3871052@euler>
References: <20220429233049.3726791-1-colin.foster@in-advantage.com>
 <20220429233049.3726791-3-colin.foster@in-advantage.com>
 <20220430142457.7l2towhbptdvrfje@skbuf>
 <20220430172400.GA3846867@euler>
 <20220430215651.4lk66lwnzslqtgtb@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220430215651.4lk66lwnzslqtgtb@skbuf>
X-ClientProxiedBy: BYAPR07CA0039.namprd07.prod.outlook.com
 (2603:10b6:a03:60::16) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 989c1a01-8a34-4d1a-6c8f-08da2af88501
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2407:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1001MB2407B642C1839FEB2BE896A2A4FF9@CY4PR1001MB2407.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kvoHgzMIK/Xn98DlkAkgVJWJyZ3GLyjr3dAsdsjmVQtXscBSySrfZHpXihlKBcNzFhJxwZo2ghItgi4MQy3aCqaqQLYLCCVyec37yRRjFieWs6T6bwfmcUCxFvJHKZ3Tk6mZtGAanCIT1dKLDnoZeeZLGtEO+W9KCio5PXxteuZEF8VSccw8+LERtJk9pPgLtOmlUH6abPSQG/4ZbVeqx3n4bD3TdfNROXeu1BGG0ORpLsXULp+7VpeGz1v9f7rleM6dhSobxKKBKnzy8DWBX7Mjfzh+nLtA0WDNlDE26ol9CuISnuH3d2VoDqE1L9kkpyQVoi0EGwzb3R1pyAsrZg9EfyNZJGZwkIcvMjwbUJyvXwSkBPtXwcYCTdtiKuuimXESLBKfnv3Adl8mB1lFFUfx9bi7orguP4UQVT5YbJGMZBVmsH13OsyQJyMTuXLz0dAV2eiOsgtiFQCkI5RK8ND4Y+qtFXxzLNsIrGbcWFo/Iva//OEaAFS1Vp7KvYAwOgVJ2r78AuthMyzzKoe+HqeiJErBMmyIewmkjchhSzSJujjURMwVeQxgpPoeCOetCtZnveRFP2BzCrCIEPNldoDNpIen1Djz5uFz8Uu+yR9ErUoWEZqkwz3RqBT42zTp2NGB0A5Y6P1LtXtmhUkqOGJT0gWT3pS0AJsVjejfjH1fdG8xydCY9ImZPgKq+SQ3vbUT1MPq7wLG4L9xQXpTtjwTXiVhGvxI+KvR+W+0T9Ij4atp+0bIFfOuI5fczAp5gAASXG1vItcNtDsBQyD+zTgvAixO/ckNjQlugRyqAes=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(376002)(136003)(396003)(366004)(346002)(39830400003)(38100700002)(38350700002)(7416002)(33716001)(4326008)(66556008)(66476007)(8676002)(66946007)(2906002)(6506007)(5660300002)(44832011)(8936002)(6666004)(966005)(83380400001)(26005)(1076003)(9686003)(6512007)(86362001)(52116002)(186003)(6916009)(316002)(54906003)(6486002)(508600001)(33656002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dIQsmMazY5Na5fUZfejdgpEq9WugdB534wYDBC9vRLvth4ljP6pKn8wH15tS?=
 =?us-ascii?Q?eDLo6kJInWTzmyf0iR865QK+VSfZut/owFX4UftmNbI6eHt2mQYfiCm6ttMJ?=
 =?us-ascii?Q?kFPMR/h+LlmathxjY4pgjLJCnzF7DKLlOrDxLwv4y+dqF6g2ufH+6+5JgSKT?=
 =?us-ascii?Q?VGKvhUcsStY9b/1DCLA/hIQfXg9MlUS1KUc4fVUjGm+x82E1Re8yBQpUQxso?=
 =?us-ascii?Q?g3i4qL1q1Ro6vUla8l/dbcH+hm9AFoyjjS9AbJEOgpzYSrhaQ2Hrdv4Hk+/8?=
 =?us-ascii?Q?4r0afAURoB3LlwvMOYV3SgZV/MecvhU5bPMFu373Z2cOsau8tiPc0VkemU1n?=
 =?us-ascii?Q?4teGJu37okZAaW7s8gdSYktgl/sECRPLmrlwHcLflQEbDuWkIAR35ysdBhNG?=
 =?us-ascii?Q?B260NAHcXOFu7RCjW7HfEn5B2KIXEgYtSp5Or5lT5M0uvgnm1iwOofmdSGAS?=
 =?us-ascii?Q?N82j8aDY0xAcWwmN8f4dpiINj7MQFvVpdBwFm83Ou8h+lgZ7sioFoGFbEayN?=
 =?us-ascii?Q?NuQgXyjsJJi43ysk4qDiRB+Lig47iFdn2fxlXh4/cneomXypxGet35ukjAMe?=
 =?us-ascii?Q?CdvlkAfoldquCxqCITN6bzhQYVyECR/fNEYVnD/VjgfW/q9clLJthhhPok1j?=
 =?us-ascii?Q?flCqKYu/7G10xSJmG4X5nXZGTlrFNHdry4vVx6u6e3s2OvvC8Twv+4jFTZJG?=
 =?us-ascii?Q?HyGcMxCuly8bR2v9piv3t62+2ECnbFz0Ih61k9hBFuP5q4hHS/gPt7l9IeaJ?=
 =?us-ascii?Q?zQwDyZs1TXVEn76GlzhRseBzuJNaf4qsEJvfsRaeSuTzAw+Im/P3qpHMw0al?=
 =?us-ascii?Q?HR7q4QakWMIInF4GiAkyslgl404/xNwXEWiXtm8bE1VQDoZV39/ih6xzqIlh?=
 =?us-ascii?Q?19cZ2m0G4mgylcdkhrJ+0rpXGt5seRAK2w6bPRvRAPw5ezZzxFifBBEs0WS8?=
 =?us-ascii?Q?EAq2toIsbna9OZy7blGEvK6XO7VFuxPU4qwVnF7YEFOWE1ih+D0EBd2oTx27?=
 =?us-ascii?Q?HcO8k2Edneza4SKjSCx3L/8f2azERpTQGAUu3YqkjmW1wsed5AI3C+0GlEQP?=
 =?us-ascii?Q?licK7mVAb/ycJZMpntQ6S8xOLVgwOgki9h9t/rPSrB4z5GuEo8++9BYONW19?=
 =?us-ascii?Q?Owkm28REJihjNFk3qmviiBFQnkrNKQf9SAM3UFLh0cqDGZBAnqsvA24h+KRY?=
 =?us-ascii?Q?658glDfx379RcPHmEHqvzySsbTOcFMuawjBiICUl39Lk34muyhsFoXrFX/8Z?=
 =?us-ascii?Q?Fen4FEbvQSMRxgDwso6heozffD1pKRECTsOWz41e0wb/SvlC7sa4mWqvJRsc?=
 =?us-ascii?Q?SQS6EJ3ELGkXF5vixbADH4pqUu7Fd/Ob9MHlf+AuNPhlhhwsNPFsKyVLpHo0?=
 =?us-ascii?Q?RabluNNpWC47ZBiC4iMs/XgTtanaWElFoeqfo1z/F9npzfbH+ybXYYcbpaRT?=
 =?us-ascii?Q?DA3YB2SYr8w8rWMIyJVvO+w4WKZz0kW3R8x/xo5yPqFnpvobMJROAkER5thX?=
 =?us-ascii?Q?q/7kqh6vF2kSRRAZo7GKQraDlLcj6diq1QD+ktEgUaF9TnSPpLA5nMKd/sHg?=
 =?us-ascii?Q?btPvTeuwuTx6FaJqoFuKNsBCa0ZD1ZIJ7l4I00/8/C3z8UrQjq1wpyjQ6m4D?=
 =?us-ascii?Q?2IcxOiXc3C9UsI24wGizVl4LSw+KsRnwAHe7XeMNTtdcgSYDcZ/fQORFy6O1?=
 =?us-ascii?Q?CXGGcibQXWV2w1wN1cVaxynt8Y07EeF1a1ZPJounOA47iGGcDyTvjPv/PxTI?=
 =?us-ascii?Q?kGLnvwajZrlwf4tvO00zpZrDQCRVnQ0YlCFiZH/S2rVJaW9zdFXp?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 989c1a01-8a34-4d1a-6c8f-08da2af88501
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2022 22:26:50.1502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cXfIA/XN9C0YeCd7lia08K712pb4ecMSsMALsGsJ/mCOXFE3TKbfekecCPD4RfBx2s67Jn9YX/tyvxYyKkMJoilnDadulQa0CDubAdLy5Mc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2407
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 30, 2022 at 09:56:52PM +0000, Vladimir Oltean wrote:
> On Sat, Apr 30, 2022 at 10:24:00AM -0700, Colin Foster wrote:
> > Hi Vladimir,
> > 
> > On Sat, Apr 30, 2022 at 02:24:57PM +0000, Vladimir Oltean wrote:
> > > Hi Colin,
> > > 
> > > On Fri, Apr 29, 2022 at 04:30:49PM -0700, Colin Foster wrote:
> > > > Each instance of an ocelot struct has the ocelot_vcap_props structure being
> > > > referenced. During initialization (ocelot_init), these vcap_props are
> > > > detected and the structure contents are modified.
> > > > 
> > > > In the case of the standard ocelot driver, there will probably only be one
> > > > instance of struct ocelot, since it is part of the chip.
> > > > 
> > > > For the Felix driver, there could be multiple instances of struct ocelot.
> > > > In that scenario, the second time ocelot_init would get called, it would
> > > > corrupt what had been done in the first call because they both reference
> > > > *ocelot->vcap. Both of these instances were assigned the same memory
> > > > location.
> > > > 
> > > > Move this vcap_props memory to within struct ocelot, so that each instance
> > > > can modify the structure to their heart's content without corrupting other
> > > > instances.
> > > > 
> > > > Fixes: 2096805497e2b ("net: mscc: ocelot: automatically detect VCAP
> > > > constants")
> > > > 
> > > > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > > > ---
> > > 
> > > To prove an issue, you must come with an example of two switches which
> > > share the same struct vcap_props, but contain different VCAP constants
> > > in the hardware registers. Otherwise, what you call "corruption" is just
> > > "overwriting with the same values".
> > > 
> > > I would say that by definition, if two such switches have different VCAP
> > > constants, they have different vcap_props structures, and if they have
> > > the same vcap_props structure, they have the same VCAP constants.
> > > 
> > > Therefore, even in a multi-switch environment, a second call to
> > > ocelot_vcap_detect_constants() would overwrite the vcap->entry_width,
> > > vcap->tg_width, vcap->sw_count, vcap->entry_count, vcap->action_count,
> > > vcap->action_width, vcap->counter_words, vcap->counter_width with the
> > > exact same values.
> > > 
> > > I do not see the point in duplicating struct vcap_props per ocelot
> > > instance.
> > > 
> > > I assume you are noticing some problems with VSC7512? What are they?
> > 
> > I'm not seeing issues, no. I was looking to implement the shared
> > ocelot_vcap struct between the 7514 and (in-development 7512. In doing
> > so I came across this realization that these per-file structures could
> > be referenced multiple times, which was the point of this patch. If the
> > structure were simply a const configuration there would be no issue, but
> > since it is half const and half runtime populated it got more complicated.
> > 
> > (that is likely why I didn't make it shared initially... which feels
> > like ages ago at this point)
> > 
> > Whether or not hardware exists that could be affected by this corner
> > case I don't know.
> 
> VSC7512 documentation at the following link, VCAP constants are laid out
> in tables 72-74 starting with page 112:
> https://ww1.microchip.com/downloads/en/DeviceDoc/VMDS-10489.pdf
> 
> VSC7514 documentation at the following link, VCAP constants are laid out
> in tables 71-73 starting with page 111:
> https://ww1.microchip.com/downloads/en/DeviceDoc/VMDS-10491.pdf
> 
> As you can see, they are identical. Coincidence? I think not. After all,
> they are from the same generation and have the same port count.
> So even if the new vsc7512 driver reuses the vsc7514 structure for VCAP
> properties, and is instantiated in a system where a vsc7514 switch is
> also instantiated, I claim that nothing bad will happen. Are you
> claiming otherwise? What is that bad thing, exactly?

I see your point - I misinterpreted the severity here. I agree at the
end of the day we'll possibly write the same values into a memory
location multiple times, and since there's no supported hardware that
differs there won't be a risk. If, at some point in the future, a
chip comes along with slightly different parameters it could become a
problem, but there's no need to solve a problem now that might never
exist.

Thanks for the feedback. I'll drop this patch, as it isn't necessary.

> 
> > 
> > > Note that since VSC7512 isn't currently supported by the kernel, even a
> > > theoretical corruption issue doesn't qualify as a bug, since there is no
> > > way to reproduce it. All the Microchip switches supported by the kernel
> > > are internal to an SoC, are single switches, and they have different
> > > vcap_props structures.
> > 
> > I see. So I do have a misunderstanding in the process.
> > 
> > I shouldn't have submitted this to net, because it isn't an actual "bug"
> > I observed. Instead it was a potential issue with existing code, and
> > could have affected certain hardware configurations. How should I have
> > sent this out? (RFC? net-next? separate conversation discussing the
> > validity?)
> 
> I can't answer how you should have sent out this patch, since I don't
> yet understand what is gained by making the change.
> 
> > Back to this patch in particular:
> > 
> > You're saying there's no need to duplicate the vcap_props structure
> > array per ocelot instance. Understood. Would it be an improvement to
> > split up vcap into a const configuration section (one per hardware
> > layout) and a detected set? Or would you have any other suggestion?
> 
> Maybe, although I assume the only reason why you're proposing that is
> that you want to then proceed and make the detected properties unique
> per switch, which again would increase the memory footprint of the
> driver for a reason I am not following.
> 
> I suppose there's also the option of leaving code that isn't broken
> alone?
> 
> > And, of course, I can drag this along with my 7512 patch set for now,
> 
> Why?
> 
> > or try to get this in now. This one feels like it is worth keeping
> > separate...
> > 
> > And thanks as always for your feedback!
