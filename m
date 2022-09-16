Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44DE95BB15B
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 18:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiIPQ4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 12:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiIPQ4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 12:56:07 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2097.outbound.protection.outlook.com [40.107.244.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD87AAB4FB;
        Fri, 16 Sep 2022 09:56:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eQC/7kMLdpcLyj0LxKjOvjQQ6dQeDnj+v3KoKUB82T3ARwSd8/3oNPTpjJOEnmnIjDbOy8T1o4+5V5MQ14LsGF2AgMjf8QKz3aT4j/mP2C1asfh4FIpjdez1/CedezYSBpCM3M9eGNp9EC9jSDGXHYkdqJQWPkYT+D8G2IaiRKF32MjyDz0VKRhVCyfG6R2deuJO09Bk1i//8Vdo+RbYloqAOR9WRQwM4gVAz24hf2OtESBtMgjVQ1Vf13rMZghiu/diml71+HejZSOqMEtwGBUnGDuhwh6zTHbSKGf8953vlYlPRXmPHyIHIqMGnOxO5mUKf2/lwaPVe5xInxBIIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PH71J2d4VUE8i6wE1QJELT6TLfPv5mvfi6mejJsqw0Q=;
 b=mwBe11Jjm41/EyJoUzVCQlEa4A43yppjzU7thbBwkOWra6bYx+IQljqUtTNM+iAyspiGqnLcBYSrUOjYmiS5nvE3xU7VmSC6iafmPi9VFLR8id4HhBgfIruiPB8DDmV9wey3pp0zwGXxzVTW49aw1JtNVHUb4z4CxwklfomFJHw5inBpVox6lT4ZXqPnYhkj0iyIShDMjr/aLSHNzI0yhllClKGH+5L0fRBcM98mC33d4+9s3glKVyA9LpGfEkxsOJNPvqGo1B8ul2e+glnuocTUHR4550jIRobSYzZco0ZYfx2O2W6r3dpagcIjmgWxO19ZT/kcuZQqZtITiP5d/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PH71J2d4VUE8i6wE1QJELT6TLfPv5mvfi6mejJsqw0Q=;
 b=eqBAtSEcFo2pGJO/CElJPPDUdJe9DWEOeDbCrdtZrFgrdJ2xtb8pm6gpDqhSEm2eT+0bg/3qZgOxXIFgdFRd+MFPPU9DPc5Uii3sAps4gOqsEL1uLL/fDKrKZFPNTrP2DzC/jSYh/K0tSCcosabetTj/HvGUK9TPPhDHtnyI74k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH3PR10MB6692.namprd10.prod.outlook.com
 (2603:10b6:610:148::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15; Fri, 16 Sep
 2022 16:56:00 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::dcf2:ddbd:b18d:bb49]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::dcf2:ddbd:b18d:bb49%3]) with mapi id 15.20.5632.015; Fri, 16 Sep 2022
 16:56:00 +0000
Date:   Fri, 16 Sep 2022 09:55:55 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
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
Subject: Re: [RFC v1 net-next 8/8] net: dsa: ocelot: add external ocelot
 switch control
Message-ID: <YySqm8t0pbH4cqR/@euler>
References: <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-1-colin.foster@in-advantage.com>
 <20220911200244.549029-9-colin.foster@in-advantage.com>
 <20220911200244.549029-9-colin.foster@in-advantage.com>
 <20220912172109.ezilo6su5w6dihrk@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912172109.ezilo6su5w6dihrk@skbuf>
X-ClientProxiedBy: SJ0PR03CA0111.namprd03.prod.outlook.com
 (2603:10b6:a03:333::26) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CH3PR10MB6692:EE_
X-MS-Office365-Filtering-Correlation-Id: 049b1b1c-aa43-4d02-6fe4-08da98045500
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rzce5XYviZOtHqTrA3A18Y4KGBqQA9FdhIcUoNdqPPxrgFCHQkfwRlMIP4ilhyFpxS+l7EB9yya7Nor8jXcJnZ/v8ddHnhlbuBBVrnwNNkirAnGSoywx28IukVqPXBylh2DTsw3s7YVnlDJjAB+xHI1lVUFTMT+GpA/fApTiYBq/dKDaxhZ4v2Lk1V2/jUFeoj538f04XE1TgZfstndEAgB8h8/em4c0zN56o6xHPwykqm/hb/yn2t1cpbcDvUoxNChfBu4bvQZhfneQRUFT8x6YwZAxjROUkxX8AIBrrfdjpiOYzI1OY1OXq6Ot0dIYT7YAt/IiC+r9p2PzcEzaCVcEijeuvPAss5k0V9QZ7WZIfsPfMOVAYlxCHFKtmOFqtdACwltP+w+MR0N9iUhlr9fvHgYkzIThnXlCJ1GMo10gk1yH8myI5EXTUtFuwzJp9Dl4Xx1MiyN5XylDa+BTA57SWPWfw/a4jFNomTv8cDXLEt+WadOtsFYvLeEgalOgoTYkDhw8DfANtJPmDTXN4E6s8ik+pFoQBlwDP0kcdpAhWwPs4o0z63CSfcpNGE9ebEsLe35IkFZ/38v5KR4t+q09iSDaLIHQ6wywPEvlNuzc2Qi0cLE7S2Ma7pT1qKu/KKpNvCwBjgNb2HQXwbv00kdFZ0e1rF2FzL+TN5ikjpBl3FtTeF3f47U/ueiCn4u0R9okySBVm/FzOAZBEnXhFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39830400003)(376002)(396003)(136003)(366004)(346002)(451199015)(86362001)(7416002)(44832011)(5660300002)(8676002)(6512007)(26005)(33716001)(66946007)(66476007)(54906003)(2906002)(66556008)(4326008)(8936002)(6916009)(41300700001)(316002)(478600001)(6506007)(6666004)(9686003)(38100700002)(186003)(6486002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M7MQLM++3Vgg5PwKJVw5369hUH7+8MuCgc7ZDybYkdJ0TqKHmWaRbbUAWHtv?=
 =?us-ascii?Q?8MhLux4NCZ4rFMj2mPrNGVusINKnibqZC9wTYvMA79VQNwyHMYVlTuiLINmf?=
 =?us-ascii?Q?xFKZK65g8jF9K0Eu9/J6T8OryOSWmmgUqPAAM0b8ugrOlffRSJohrNkTJMqM?=
 =?us-ascii?Q?AwXB9cbtt0YD9HC5aNWhhYdWY+y7oCmzq4fDJFOsMfihAhYeZrdcu2F6nktB?=
 =?us-ascii?Q?WDypsKdITk8tdEsc4Zjg4mqFiQSAjvr+Z+tt4q0s8BYneAs4nDk6iVUoxfOK?=
 =?us-ascii?Q?3xT7wdEakAGgtoKYjAD0PpGcN6nw+sKMhYgBEMOUvXvDNwN3BJgSEXM6xp33?=
 =?us-ascii?Q?32sV2XfbILBgygx+YM8IimF3P2WI7cRjKrhFPppainrEU1Xtaj9Df9e/wXaB?=
 =?us-ascii?Q?6M+mym0Zf9x3+mTO4obiuOInGIkgqSAJrepvzOQTez3r5/y+l2Ocd1FnAfFg?=
 =?us-ascii?Q?gwHyK0S8+JlYrqMERUKLRh0cw5J7Rz+7SNBaIOSYPCuJtHKiQrRr72JPT1Xo?=
 =?us-ascii?Q?vj3wIp6tn0toJxh/8NGeSKntDOxdu4jqPbfj/XG8E5tzs6GWKzdPbJe3EfGZ?=
 =?us-ascii?Q?Egqv4t1gbnwm4FQnRzEZy4Cg62sC8BrB59xZ6DYiEv6chk43+sGjcOKYhWhX?=
 =?us-ascii?Q?BYgO0KcTcp/G9gMNN5I1ir2UOohe1s25w27S8BwrW6apG5i68tk0cumET4F4?=
 =?us-ascii?Q?ymR5bKPZs7fa81FPAR5wUfn1062XemHMLB14sz3op3qMYM1RohvaSIDIVF33?=
 =?us-ascii?Q?hPwzH7unTKKMiO53hW+X2q+ZTDH3VFpqwbRzCfV+GcYLmn0SoYVr0S0QU0ct?=
 =?us-ascii?Q?cL92zOJ1VfGxjJq+XNMxsD4YWC3vFXzs9aVNIWesD+Cwk6qpvIdWFgMGDGfd?=
 =?us-ascii?Q?20aqd7Xz7fO8NMrgqn9DDiHAIpXocbp9CmPJlSoe5EU6jwdUi0iNig0tjCay?=
 =?us-ascii?Q?ok+aZXCSw2pGpzxM0GymOXsQi1iTZF1DOBaO1fFXrIJtOaqDKxiLTExW8aPf?=
 =?us-ascii?Q?Fon8FVa3qtkUrCybBmabqLIFYt62H1kA1w32O3PTQN/NopADyniaFckNFpqk?=
 =?us-ascii?Q?NQPygsJFYw/ZZxCbobpyNFGxzVBCiF7zvNNy2qMIXmVFGcffNxLugfiVm1QC?=
 =?us-ascii?Q?A/0Ebg4fd6twshP49SxMMZl9HP02GOC2E3UsckQ8KCj0+IE0y4TrqC8WCDK5?=
 =?us-ascii?Q?38me9A3YZXQnemh7yTJc2Jd55Y+ecBkOO+nXAEGFBwkGYq1kJFo1UAn+Yfww?=
 =?us-ascii?Q?FZzjbLfXh9Kz5EbDA2opwCKqWlKTRNBiOyrFxzTkY1xg2/fHzD53+5Pd0k1N?=
 =?us-ascii?Q?YsQC+5nyUUXr8oJPP86WDa/FoY/meODNtxm+2hjyRcORzaU+MUXJRyE67syD?=
 =?us-ascii?Q?K7FIhK/GnfWybMpA3NR0OBJMbZ4rINYp+HYHiR1mN7ED4ewqlWo8rNWhG+p9?=
 =?us-ascii?Q?i6ImS5j64DOVlNFwzh6ylmW8q5UCFh9c6D28iydBw6XxWrVA3M2NwzhpnZ6Y?=
 =?us-ascii?Q?+X5YiZAvTA5E4VsCKaEMvStTIueOGklk9CPLPkaCpDYmfTgfXrokfdnK/t4Z?=
 =?us-ascii?Q?+XatpWCSr2vUtjZw/mHrK9YOGsvbwtfovpeU2e1i/HiaGtQoTleWtwijoRnq?=
 =?us-ascii?Q?9w=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 049b1b1c-aa43-4d02-6fe4-08da98045500
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2022 16:56:00.2229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zNS5AoA3QeMj14bBgn60LhjQ31cptn9DQ94rl11vSF3FnMRTT25phMJjpHVdtwWfXWRh57LF318ZHPdI6U7dUFmTk4a9yi+f/LQ4nm0sPNg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6692
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 12, 2022 at 05:21:10PM +0000, Vladimir Oltean wrote:
> On Sun, Sep 11, 2022 at 01:02:44PM -0700, Colin Foster wrote:
> > +
> > +#define OCELOT_EXT_MEM_INIT_SLEEP_US	1000
> > +#define OCELOT_EXT_MEM_INIT_TIMEOUT_US	100000
> > +
> > +#define OCELOT_EXT_PORT_MODE_SERDES	(OCELOT_PORT_MODE_SGMII | \
> > +					 OCELOT_PORT_MODE_QSGMII)
> 
> There are places where OCELOT_EXT doesn't make too much sense, like here.
> The capabilities of the SERDES ports do not change depending on whether
> the switch is controlled externally or not. Same for the memory init
> delays. Maybe OCELOT_MEM_INIT_*, OCELOT_PORT_MODE_SERDES etc?
> 
> There are more places as well below in function names, I'll let you be
> the judge if whether ocelot is controlled externally is relevant to what
> they do in any way.
> 
> > +static int ocelot_ext_reset(struct ocelot *ocelot)

I'm looking into these changes now. I was using "ocelot_ext_" not
necessarily as an indication as "this only matters when it is controlled
externally" but rather "this is a function within ocelot_ext.c"

So there's a weird line between what constitutes "external control" vs
"generic"

There are only two things that really matter for external control:
1. The regmaps are set up in a specific way by ocelot-mfd
2. The existence of a DSA CPU port

Going by 1 only - there's basically nothing in
drivers/net/dsa/ocelot/ocelot_ext.c that is inherently "external only".
And that's kindof the point. The only thing that can be done externally
that isn't done internally would be a whole chip reset.

Going by 2 only - the simple fact that it is in drivers/net/dsa/ means
that there is a CPU port, and therefore everything in the file requires
that it is externally controlled.



Unless you're going another way, and you're not actually talking about
"function names" but instead "should this actually live in ocelot_lib"

While I don't think that's what you were directly suggesting - I like
this! ocelot_ext_reset() shouldn't exist - I should move, update, and
utilize ocelot_reset() from drivers/net/ethernet/mscc/ocelot_vsc7514.c.

The ocelot_ext function list will dwindle down to:
*_probe
*_remove
*_shutdown
*_regmap_init
*_phylink_validate
