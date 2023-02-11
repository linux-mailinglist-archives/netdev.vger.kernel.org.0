Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E9D692C88
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 02:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjBKB2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 20:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBKB2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 20:28:06 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2073.outbound.protection.outlook.com [40.107.7.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A95D7CC92;
        Fri, 10 Feb 2023 17:28:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mh0WNVbFmovMWm6p4jyC5N3Jo49yEjv9u4oxkBkSi35DL9RHWRnGB/XAzxd2F1YJ6ytlHY7IvU6ZkV/kWAaQEmdwTylDx9M5cPWFagcFCLxSiiExs+kThg7EHUPoC2AV/Il8Qxe5fffqVItzWfj76Vdq61OauxsX0fbEZH+n5LEFchwAQWdZ2iz52hJWEfhUkBOVwoLr7VGontXBo+DYW+fzAcK9EuRgoCA/w98a8mhr9LIwYYrGHVJ+hz8kkrtsXbrvhXNEKoPQwflM2A/2hRbNfpop990fo4fqCh+CBc8VU3SUQ7SW1kQIC0PubUlE8ZytqV3ZflQ4gko3D/PUcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ArgoDRCoCJchH7ID4J+wY77TJxOeq34PVaJEQ9xFesU=;
 b=QEkb+QrbniRMoIQmqxl3IYl/3RA/0T5qlcqFmDi5Oi5R8sWYgTghECmdtgn05DVU8EN0fqbtYEgYgkkKUKUXMQ8LopZOstaWXhIvQXvEdSfKCn6ZKJxw08AIqDQMTpiaOp25JDSRjTsYW93Xvv3gMgCSrPJpwIIu93+xtLYi5OEtGY3niR1QYOQ7oHYzjRpa3KgGt4k5VGfwMV4wie/aYe4Wb2amX7zKbz+t8vRUD+lswYZSh+2zvCSpjJqcaQ/8+Ib0Zsv3Q/HbJ8tYVyxA7Aw7MK6A/CUw/VFgWjYJc5gPE+vbXmeZFR7+iXc78cpy68oOaS7BklDhSZB/uTPBvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ArgoDRCoCJchH7ID4J+wY77TJxOeq34PVaJEQ9xFesU=;
 b=qK2g++zldBAnw1593bOyrLBzy+lpxWkZv/Poy0PGzAcSItLGrHy3ir40gecpiTPLkosy+awqT9Uwvm/jJCJjyKsVVuZxsjdZy3H6QHMKGBCktbqiwR1w9c1xMZ7kuNfCZL5kXtbYukNkWTSAGKREYID070B233GB041+9I3kflw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB9646.eurprd04.prod.outlook.com (2603:10a6:10:30a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Sat, 11 Feb
 2023 01:28:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6086.019; Sat, 11 Feb 2023
 01:27:59 +0000
Date:   Sat, 11 Feb 2023 03:27:55 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lee Jones <lee@kernel.org>,
        Colin Foster <colin.foster@in-advantage.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: Advice on MFD-style probing of DSA switch SoCs
Message-ID: <20230211012755.wh4unmkzibdyo4ln@skbuf>
References: <20221222134844.lbzyx5hz7z5n763n@skbuf>
 <4263dc33-0344-16b6-df22-1db9718721b1@linaro.org>
 <20221223134459.6bmiidn4mp6mnggx@skbuf>
 <CAGETcx8De_qm9hVtK5CznfWke9nmOfV8OcvAW6kmwyeb7APr=g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx8De_qm9hVtK5CznfWke9nmOfV8OcvAW6kmwyeb7APr=g@mail.gmail.com>
X-ClientProxiedBy: VI1PR08CA0184.eurprd08.prod.outlook.com
 (2603:10a6:800:d2::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB9PR04MB9646:EE_
X-MS-Office365-Filtering-Correlation-Id: aa5477ef-01fa-4cb1-777d-08db0bcf3586
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jrP1imGyAPLuFTIJxzYiAZcUBvYsT0Pf8K4vkR+gcLDMtsXANfrY6htcCrbsvZYs55DuLr4djkjgBcuzHfhAG/nfWWp0J3QWBFm9sbQzvE/Hnv3E7FSPGXOO2UTDkRnl2v507CexNeN6lkdFhA0iGkQEKShbHWUi8bUSNdXjyHsLUicuRhgKCry14uSO4Qu3m5nomLiZ9gRMmDng680nSx51aVA3729KZ3j7p/DO/sAGJetwE97Lhs1G8PpgGVu9UdlgyNGVuxkcGJjGZvF8COdarfH61YgMZ6vnk5YeMJud6/YcDrelom9/PtDMUyrPMmgbNloDwxyeEE0FxqMQo+sUvWGuIobw58WjRLKpCf4ygqMBZbg97bpOCDIG390snWplpx9k99DE/rFWwNznd7/t6+98/QcklNgqLrcjKEgIuUVKQei4KKL3vk18GV4F9tnHAEN8MVZEGwiGAHB7MLi4zKSgBR2sBlnr+pbJGn6c8YIrwhllzdBl+fn2O8yCsuxikx1S5W/irQzdUxawZ1uQdKjiRVSOi67WxFdFbL1tGNtSdW/52PVIK9kBDm0vFiRiDx6JxuCozltcDFLbJ+6Ig0YsIAgGR15kFn96l0poTYeWMvCtEwK3nn2RGwaG5rTzHRN07X63htKmWiv3wg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(6029001)(7916004)(4636009)(39860400002)(346002)(136003)(396003)(376002)(366004)(451199018)(54906003)(478600001)(316002)(2906002)(6512007)(86362001)(7416002)(26005)(4326008)(8936002)(66556008)(44832011)(33716001)(8676002)(41300700001)(5660300002)(1076003)(6916009)(66946007)(66476007)(9686003)(6506007)(186003)(6666004)(38100700002)(6486002)(66899018)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fyKfZbD0jq5HAFunwKJte/MfiV4a7L/9U3NyllChAMbLqPxx7khfarx53OhA?=
 =?us-ascii?Q?bq7cayj053ibGAWLkRvikY5+Fd52SZXeD1HEesHMnh0ZKH2okrjb+lMdiJpN?=
 =?us-ascii?Q?lbGz4OzE4dzwEIE5rIkgXrqoHQ0OaTVwSdaNYLfHKWOI3MoTKH6SpttyyAzG?=
 =?us-ascii?Q?iSN9bOOc6e1y2FxC8cOQ1h7JdqeVpU5SE2Ouqn8/e6F0I15ySK1ObSMFPBUM?=
 =?us-ascii?Q?gCCjvK0IX2dAwRnb59hiNnc2q6262jpD7+9mulXBZyGnWdqfc4X9wJYhkk+j?=
 =?us-ascii?Q?mFhXxNoZUjH/O32zf3gN8kwkVpQDE781kVNcGKXM/Tv5Q5j7CD4jPl3i0fh5?=
 =?us-ascii?Q?sDrYetvgiSt4doVWHr5IPtuzm6yf9UcXFKtuctudo3yVK/mIOIglUtkzq8is?=
 =?us-ascii?Q?lzDGIZGZeIlV1beQDaYjipaJuynWXT4t/i9iUsHpgp8tMFdnre+hGStsAbT/?=
 =?us-ascii?Q?d6JNQuNo/Za8lbWrxbCmOTA08l5oDJkkcy+CJr+pICCcKp0aYMGPA62EjbZG?=
 =?us-ascii?Q?lq7cfOwLTBUYDgxqq8J0LgmQyvpmhx3i2Kih4quxswBKV/OkNlLIb55QWvfI?=
 =?us-ascii?Q?i2M7VQNog+jn7W4J4OSnjI6jTODXEnoM4dLIOCuc2dzyEIMaqUc2ECrE5hW+?=
 =?us-ascii?Q?3LdmX1l5dQzZtzeGgsjVTS0j5fk/zx47fzmSd5mk6euOeA5oNTVCQV76UgEM?=
 =?us-ascii?Q?PInDzued6V1x3YXu7anwPyHYe2EXp+e18GcG6w6dVX9p8ld4kJT1KMbKPlIn?=
 =?us-ascii?Q?8eonZ18T4WjALIuQn7ii+Qi55nXwSeEKESwP7Y6GaN8PGfZRXNSX8Cwg8B1h?=
 =?us-ascii?Q?BT0hijA1jS96Jh+Mz3kt8JFo0KbQ+Ieh+DCiJS0hVoJ7NmvlDvnbGKMWOpaX?=
 =?us-ascii?Q?JOUUHFpCDKBN9wi3mycY54cv1d0CRW9eMIW7Z1IyOy2RtFXnKQwyWqP2dqiw?=
 =?us-ascii?Q?Z04Y6ySx69xJbOfUdNgRgMfbqu7444BXSWtqx4OLtVKhMOUG8SzY+QwoaaYC?=
 =?us-ascii?Q?AQlgqs5mA5wzcrGHGgXLu0xN3EzK8GCMOu6klqRctBZr6QhaJJZSQOU8UbeJ?=
 =?us-ascii?Q?NcbKQFx6js+Uu2wNna8zVwRgOSIy26jzKLVaDBg2mdRt6Phvm6a7tm+HRwDW?=
 =?us-ascii?Q?4X7jT5lB1wuptNFiPQN4i1ZQlDBvGi+7BXW3dt9w/wQ10S0FJJ3bTfv3DlMG?=
 =?us-ascii?Q?XkkiT2P3JXWd1nD54G1JRH7AMzy5E5WdKZUIakJ8A+AJQIl5toc/7YdCrP11?=
 =?us-ascii?Q?wajb5ucP5IKSrLeFQP5F/DMunbBUL+Z073LjJYccqsTTTp6LUeeJPakII04n?=
 =?us-ascii?Q?gw3b2tA2OzMbUt7RIxCbX11IXGdGMg9e3tJIVTcgj2hpyakCTJgFz3cT4BhR?=
 =?us-ascii?Q?O4vGzV1+2GuoRVUFh7I856+wVNGHmRIAorhb+nU0IMTkfn2/Jy1C4tE0Qa/m?=
 =?us-ascii?Q?+v9ZHFwO+Xbyijhfs5uwbG8h0UWE+qG3wxTVDHyNj5g2OWjH6hK2DdM3P/HS?=
 =?us-ascii?Q?dwr3dZVE94EDSrFsQRbz9r1STErjQB2CKGYLv1/ouuNjet+60hZyAnUZ3tBm?=
 =?us-ascii?Q?YXBQBDW1nYlrRggbWz0HrQ742ZskBI17NE1Qdh61d6o/7OqD70U7ARZhrtAJ?=
 =?us-ascii?Q?Nw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa5477ef-01fa-4cb1-777d-08db0bcf3586
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2023 01:27:59.3291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: et2ZLf6/ShNLqQGnRqbyMo5ie5CUGzQhq4mwEcoBtlVhJvI5JAmhPR/fj2f0qCTNMrOxXUP9I1XqQmYqr+oEjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9646
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,THIS_AD autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saravana,

This has nothing to do with the topic of the thread, right? (probing a
DSA switch SoC as a MFD parent for its sub-blocks).

On Mon, Feb 06, 2023 at 10:49:03PM -0800, Saravana Kannan wrote:
> IMHO, the DSA is a logical device that's made up of many different
> pieces of real hardware IP. IMHO an ideal solution would be something
> like a dsa_bus type where we add a dsa_device.

So in DSA terminology, what you call a dsa_device would be a DSA switch tree
(a group of interconnected DSA chips forming an Ethernet switching fabric),
and what you call the dsa_bus would be the bus on which the switch trees live?

> The dsa_device will list all the necessary devices (IRQ, PHY, MDIO,
> etc -- they can be wherever they want in DT) as its suppliers and when
> the dsa_device is probed, it can assume all its suppliers are present
> and then do the DSA initialization.

How would the dsa_device (the DSA switch tree) know what are its suppliers?
DSA is library code used by multiple drivers from multiple vendors.
It's just that this library code has a built-in mechanism for serializing
probing, in case those switches form a tree. The dependencies are not fixed.
Would fw_devlink be involved in determining these? Up to what degree can
the dependencies be "wherever they want in DT"?

> This would also solve the PHYs problem you stated earlier.

How would it solve it?

> So, basically you'd move some of the dsa initialization code into the
> dsa_probe() function of the dsa_bus.

Not clear what makes this solution better than what currently exists.

> Hope I'm making some sense. Let me know if you want to discuss this
> further and I can try and provide more context and details.
> 
> Also, there's already a driver core feature that does just this --
> component devices -- but the implementation is old and not so great
> IMHO. Component device model can be done better using device links. I
> want to refactor the component device framework to use device links,
> but that's a problem for another time.

Ok, in my mind the problem is the way in which each individual DSA
switch driver, written by $vendor, organizes the resources/peripherals
pertaining to a single chip. Not the way in which the DSA framework
coordinates the probing of multiple chips in an arbitrarily-defined
topology, and defers some initialization to a dsa_switch_ops :: setup()
function. The latter part doesn't have a good justification to be
changed IMO; it doesn't do any harm. I.o.w., I never gave an example
of cross-chip fw_devlink dependencies that would need to be satisfied,
only ones local to a chip.

But since your email seems to be about cross-chip, let me try to
entertain the idea and ask you to explain what you're proposing.

Let's take an absolutely extreme (and hypothetical) example:

    +--------------------------------+
    |                                |
    |     Host SoC running Linux     |
    |                                |
    |  +----------+   +----------+   |
    |  |   MDIO   |   |   ETH    |   |
    |  |controller|   |controller|   |
    |  |          |   |  (DSA    |   |
    |  |          |   | master)  |   |
    +--+----------+---+----------+---+
            |              |
            |              |
       MDIO |              | ETH
            |              |
            v              v
    +--------------------------------+
    |                    CPU port    |-------
    |                                |-------
    |               MDIO-controller  |-------
    |  +----------+  DSA switch #1   |------- External
    |  |   MDIO   |                  |------- ETH
    |  |controller|                  |------- ports
    |  |          |                  |-------
    |  |          |   cascade port   |-------
    +--+----------+------------------+
            |       ^      |
            |       |      |
       MDIO |   CLK |      | ETH
            |       |      |
            v       |      v
    +--------------------------------+
    |                 cascade port   |-------
    |                                |-------
    |                                |-------
    |         MDIO-controlled        |------- External
    |            switch #2           |------- ETH
    |                                |------- ports
    |                                |-------
    |                                |-------
    +--------------------------------+

where we have a DSA switch tree with 2 chips, both have their registers
accessible over MDIO. But chip #1 is accessed through the host's MDIO
controller, and chip #2 through chip #1's MDIO controller.

These chips are also going to be used with PTP, and the PTP timers of
the 2 switches don't feed off of individual oscillators as would be
usual, but instead, there is a single oscillator feeding into one
switch, and that switch forwards this as a clock to the other switch
(because board designers heard it's more trendy this way). So switch #2
provides a clock to switch #1.


With the current mainline DSA code structure, assuming a monolithically
written $vendor driver (as basically N-1 of them are), the above would
not work under any circumstance.


In the alternative in which we implement what you hinted at and nothing
more (a dsa_device composed of switches 1 and 2), how would this ever
come any closer to the conclusion that the 2 monolithic blocks above are
able to probe linearly, and finally bind the aggregate device?


In the alternative in which we implement what I proposed in this email
thread and nothing more, the drivers for the chips would have to not be
monolithically written. First to probe would be the SoC driver for switch
chip #1. That would probe its children: the MDIO controller, the PTP timer,
the Ethernet switching IP with its ports (the DSA driver proper).
Perhaps the DSA driver has some unmet dependencies, so it defers probe.
Doesn't affect the rest.

After chip #1 probes its MDIO controller, that MDIO bus probes its own
children. On that bus is the switch chip #2, which can probe its own SoC
driver. Same story: PTP timer, MDIO bus, Ethernet switching IP (DSA proper).
Let's say that this DSA driver had no dependencies and can probe
straight away. It enters dsa_tree_setup_routing_table(), the infamous
function which determines "hey, you have a cascade port towards another
DSA switching IP which hasn't probed yet, I can't fully initialize you
either" and basically finishes probing "early".

Then finally, the dependency for the DSA switching IP of chip #1 gets
resolved and it retries probing. It enters dsa_tree_setup_routing_table(),
and this figures out "ah, you're the last switch, the tree is complete,
we've been waiting for you!" and initializes the entire Ethernet fabric
from the probing context of this switch. So this ad-hoc mechanism only
affects the probing of the switching fabric and Ethernet ports, the rest
can go on with its business.


So I gave you an example in which I don't really understand what would
an aggregate device representing the entire switching fabric bring new
to the table.

Also, PCBs with more than 1 switch on them are relatively rare. Usually,
when you need more Ethernet ports, you just buy a larger switching chip.
DSA has no problem working with a single chip, and many chip vendors
don't actually support cascading. I think that for the volume of users
of the multi-chip feature, it actually works very well and with very
little code. I think that the problems of multi-chip setups are the same
as the problem of single-chip setups.
