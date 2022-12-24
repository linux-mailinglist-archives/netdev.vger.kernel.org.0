Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77641655B03
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 19:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbiLXSxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Dec 2022 13:53:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiLXSxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Dec 2022 13:53:22 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2099.outbound.protection.outlook.com [40.107.100.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601B8B48E
        for <netdev@vger.kernel.org>; Sat, 24 Dec 2022 10:53:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jlkwih/E8RwFusytOcnxN45yZwrHe04CCkZLAKxRscMcX/BMv4GgLYOheqaiTQ5xlEoHhcXuV90PTHEHzlzLZ3GtOLGTqieFkqKbO+M3SNQsS0MVf3CwiUwxj7SRSlS6U4tPXRgrMggkc0/uybHwugFiU79LoqVAewki1gKF/1fOg6R7Q5qSCa4dKLcGerehLjB6oaiM3GAWjmxZPpNN8kKRpiCSHimTQtCmliFZ70qF2LvBVkKxsBDm3lPk/7CjhPMAUV3UXXCNpnwtb4xhPQtfibbGDMZfhZgK3BVMcsPKJo31O7KzgBrDEaSs3QYNcMlg/mHLFiJbqVGOZSLkiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EETQh1V2B0lLz6zmjuZhHlSxXGr1V1JkRzaUTLYYWv4=;
 b=W2zRqny4wzfdzi7JQz6Yr9zJGf7NxtBxcQGPobRtCxvZefeksLexuQjqFeOQ8UM533+T2J3EZVnskIQSU00pvnW7fGu5L4MTOyywPUsuW3FrSH1VU+Iwjgu+XGePesjWs++cUxgp45Zn3mxHE2MFaeMwyVXH06n89PZ6Q2ivt0hkljuaoyv+roKJCwyRPl9YtZC8BceM7gwDGnupA0bZG+gx4t+3RBHmmvIY53UkpxLkqvY5vDaUTCvVEdoOUGpvdqlIC2y6spxYLakAeMw9m5cYjgP3sbNAjDYR1CJojm6BmWJu29E9W+SSagl6X+lCuex9fRylLL/XjhuDJ4K96g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EETQh1V2B0lLz6zmjuZhHlSxXGr1V1JkRzaUTLYYWv4=;
 b=T4xMpmmTptKqBwFxuIxP68j5oiQLaTBD53ZaGNYl1m91iOtoVyTGxSQKGIpVgsUAC3FZ4oyKtyeBRxusJKsaiGhzb+c309tyEfY2Db8PLu9Da6bAKxw5531ovXbZY138vJy2fOegJxFKB5Cfl7oD90qgEN8V2ypI8rCv8i6q61c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH0PR10MB4937.namprd10.prod.outlook.com
 (2603:10b6:610:c5::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.15; Sat, 24 Dec
 2022 18:53:13 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5944.013; Sat, 24 Dec 2022
 18:53:13 +0000
Date:   Sat, 24 Dec 2022 10:53:10 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org
Subject: Re: Crosschip bridge functionality
Message-ID: <Y6dKlkg6ZueQ1E61@euler>
References: <Y6YDi0dtiKVezD8/@euler>
 <Y6YKBzDJfs8LP0ny@lunn.ch>
 <Y6YVhWSTg4zgQ6is@euler>
 <20221224005934.xndganbvzl6v5nc3@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221224005934.xndganbvzl6v5nc3@skbuf>
X-ClientProxiedBy: BY3PR03CA0004.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::9) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CH0PR10MB4937:EE_
X-MS-Office365-Filtering-Correlation-Id: e07a250a-7c84-4cee-97d5-08dae5e01c11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qk//Y+OfHYFr+qxRD7GYt6HELYIpWBTQIkrBVuTUE1XXvqM//FhScPhWyXf2Lcnr4Xt3savqVXwDuHkWhnfHyJZm3zuqYdmNsRQbKXOBDrpHtqyacRVjDGDzDmlKbDgHmwIcmQTwtIz1CoHdVJQYn82q+TfjvKbI+coW3Hjywu2QWnN4LLxwyHWd3+7PxiEPxPh2/achylAsKsRGhSlq6IUVfGnxCDf17bP1T1UrrTSqLbyDDwi3N8mHbPhXJJ+N58RM9nF1boP4wWqcAlUqoJ1oknOEUzbfCeff7E+wW4m+9YX5/Q5sbd6kQ5aEOqDIzB0xX/BJoDTaaG6EsPQ+q+U45zmLMWRNpz8GjPdAaEjf2sTKZzlWqO6qwhOEXGc+UVadMviQYsl/Yb+9dPxGiWGMhlrXXH60ofzgrqwZKB/y3XvxmkpETgTKNxFZHR8hj3vd3oKKr3eSM2SG0isH2Vp5Xy5vvX8CTaJ2BJdUYLSKD5CVTfKsX6qM9+mILGN1EMtDBSRM5zH744OVRo4/4w91jSYEyHi4BIlkesb0TEkrfr+vxcU4ox1QwkmQKhS4pBvEnsCUNvfZ9cyJCXT89isug60/Mw9q7t/tlZfgWXJgnXvRRS1h60ep+mOEv/BMVjNxzwd7OQVzh/NEqyK8+8aIvIuXsBj2b/7K0No/6vQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(376002)(396003)(136003)(39830400003)(346002)(366004)(451199015)(8676002)(4326008)(66556008)(66946007)(66476007)(41300700001)(6506007)(8936002)(5660300002)(7116003)(2906002)(6916009)(54906003)(316002)(44832011)(478600001)(86362001)(6512007)(6486002)(966005)(26005)(186003)(38100700002)(9686003)(3480700007)(33716001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5d+VT/jQ1KNoSQu6uAVRVl4kBbrRJmZ54qwqgBBEROn0i01hzwhLZMbXfAfA?=
 =?us-ascii?Q?1xSj71IswTY488oiJpkL0KuoYfSbeLxxsMDJtbDI0eYNMUHQworOKVgVyvbW?=
 =?us-ascii?Q?sUIxvhLZJNIB4WS2ymzQXq23QbA4JfTGzZZXok6V0Z+Nf3V8f8i3MEal/CMA?=
 =?us-ascii?Q?uFSv9Zz7YCXsz2BgfqgrhgUwn7Sq8FWGxIh2mimcKKJh8V+RLnxMRtnyszYt?=
 =?us-ascii?Q?4TyIuB+iNwhyw/fMV3OLecY0ZRtcYsV0GkKzNm5e8sV64NG7MrJUMFGmHVjy?=
 =?us-ascii?Q?To8/MUimhtw+j6TskLnA02MBE+zreyLp9JYkavJqGUezDNB5npEx99gGtsdV?=
 =?us-ascii?Q?3KT0PZ1jTNfjupe8DvA9HE/jOeV6eP58hHRGjPgU7AHsJd3lKVOtipuiJlw9?=
 =?us-ascii?Q?OnJzDy+buegsWDb68hM+M9zk4cpu3x8WNU6cgSu+I9ppcFJgxANhzhdkP2Si?=
 =?us-ascii?Q?SRSh5gsDusjVG/h8EiWGJGBTV6+vG57mE6pyedQ81gMPxVxx71VBn9mF+O0W?=
 =?us-ascii?Q?7bj62m+joBTQBz/IQIpIsCa8nLX66FKg52jPwFPRKEzzMogQyx7i46bTPCNu?=
 =?us-ascii?Q?IebTGljZr0QNo/OUOSA5rl11lETlqesLdRZ4tfLY9TmWIsTTmi02xpqWU3EB?=
 =?us-ascii?Q?NVjnqGW9kRsYVdrM78IlFXV3tqbjOAPCsqm3/cJmV3mPgdE6vMhLxbfyAiuv?=
 =?us-ascii?Q?zYFLSfdCdbqOqCXY+JbK3AX0ExvWQN3qJ1+CsxB+Hif/gUPwaFzKMWDgGn91?=
 =?us-ascii?Q?d3ADtqZ7WuANw//siA6e9T9KsZHmjYbysEVZluLyv6MhaOzZG9Ms/n112dHT?=
 =?us-ascii?Q?nKdNt6mP8owoi+/SV8g6xiSvxh8fMLmifbNuyV0k6DEBnZTJOZwj/R3dApa4?=
 =?us-ascii?Q?nY0i5M8A4tCoyFHeNt3hAhajJs37UEhABdJIsEyh1YecTjtpOmPAYbJSump4?=
 =?us-ascii?Q?DnaOmaMmx0jkSZVcCA0+oEWjGNI0Ee+Md9tgTI2JeGWpPEJvgJEnikmdbjmX?=
 =?us-ascii?Q?zwpoi3Q8YF4ySFtCP0kU0+it/ZaEBSI7krQyEhSLxPjftOiX6bIHwUQWdRVH?=
 =?us-ascii?Q?ihGy8flW36xurQmRtbpx8F7ZV9dbgmOZa5HgSd1ea85F9H9Lg8XbA3Ux/w4r?=
 =?us-ascii?Q?N0VR4w6sQGpkbqUSzywDGjJBraYWVIdIP3pa44af+PF8vshM/7+zrE6q0lxn?=
 =?us-ascii?Q?fypNe8dErQD7vmGt824lb+CR62BrXKaZvUGXQAFKSypl3za7OPhxTGr9gPjo?=
 =?us-ascii?Q?XxNQhAaI13XFeVQT0bgpp+LByF+06eKrZR4Xbri6uKyef1gJC6KsK1jmKWwe?=
 =?us-ascii?Q?00fObq1bwjp358M/mbaEGomx4ylhB1h4RgghzKN0BOFrdefTEc65+o4f6omc?=
 =?us-ascii?Q?A+XajMxIMhvUU4mcEcxrVLQrSlsV/YvVgcNGFlwA3iVE8NXVfrp9gHTE+dhN?=
 =?us-ascii?Q?oUqMYL9uETZd2Hjmb/l+IZsJoCqzvYaKkfZIOhRWpednhL3+9HeT2xuWpXND?=
 =?us-ascii?Q?klcXYOo/Tf4i+fWq+0iq0OVXLN/zlUMRUMb/3yNZeXgAmmNmGuNQckhBYvQ7?=
 =?us-ascii?Q?POu0YaHdusMyhHd2qoXK12npFD0M3j3jjkqKhiBcHCj32bDsASFrcM/WABvD?=
 =?us-ascii?Q?Qw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e07a250a-7c84-4cee-97d5-08dae5e01c11
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2022 18:53:13.5040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iBAivpMQSgl1lvaMUXvGrSmSp7lGUZDzEEAPXXmClRKYbLhicVRWia5P/KOf6rsInIfTxaMyccSUcVjnjG/QRW01JFaJFRg2tcu5O3L6HN8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4937
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 24, 2022 at 02:59:34AM +0200, Vladimir Oltean wrote:
> Hi Colin,
> 
> On Fri, Dec 23, 2022 at 12:54:29PM -0800, Colin Foster wrote:
> > On Fri, Dec 23, 2022 at 09:05:27PM +0100, Andrew Lunn wrote:
> > I'm starting to understand why there's only one user of
> > crosschip_bridge_* functions. So this sounds to me like a "don't go down
> > this path - you're in for trouble" scenario.
> 
> Trying to build on top of what Andrew has already replied.
> 
> Back when I was new to DSA and completely unqualified to be a DSA reviewer/
> maintainer (it's debatable whether now I am), I actually had some of the
> same questions about what's possible in terms of software support, given
> the Vitesse architectural limitations for cross-chip bridging a la Marvell,
> in this email thread:
> https://patchwork.kernel.org/project/linux-arm-kernel/patch/1561131532-14860-5-git-send-email-claudiu.manoil@nxp.com/

Thank you for this link. I'll look it over. As usual, I'll need some
time to absorb all this information :-)

> 
> That being said, you need to broaden your detection criteria for cross-chip
> bridging; sja1105 (and tag_8021q in general) supports this too, except
> it's a bit hidden from the ds->ops->crosschip_bridge_join() operation.
> It all relies on the concept of cross-chip notifier chain from switch.c.
> dsa_tag_8021q_bridge_join() will emit a DSA_NOTIFIER_TAG_8021Q_VLAN_ADD
> event, which the other tag_8021q capable switches in the system will see
> and react to.
> 
> Because felix and sja1105 each support a tagger based on tag_8021q for
> different needs, there is an important difference in their implementations.
> The comment in dsa_tag_8021q_bridge_join() - called by sja1105 but not
> by felix - summarizes the essence of the difference.

Hmm... So the Marvell and sja1105 both support "Distributed" but in
slightly different ways?

> 
> If Felix were to gain support for tag_8021q cross-chip bridging*, the
> driver would would need to look at the switch's position within the PCB topology.
> On the user ports, tag_8021q would have to be implemented using the VCAP
> TCAM rules, to retain support for VLAN-aware bridging and just push/pop the
> VLAN that serves as make-shift tag. On the DSA "cascade" ports, tag_8021q
> would have to be implemented using the VLAN table, in order to make the
> switch understand the tag that's already in the packet and route based
> on it, rather than push yet another one. The proper combination of VCAP
> rules and VLAN table entries needs much more consideration to cover all
> scenarios (CPU RX over a daisy chain; CPU TX over a daisy chain;
> autonomous forwarding over 2 switches; autonomous forwarding over 3
> switches; autonomous forwarding between sja1105 and felix; forwarding
> done by felix for traffic originated by one sja1105 and destined to
> another sja1105; forwarding done by felix for traffic originated by a
> sja1105 and destined to a felix user port with no other downstream switch).

^ This paragraph is what I need! Although I'm leaning very much torward
the "run away" solution (and buying some fun hardware in the process)
this is something I'll keep revisiting as I learn. If it isn't
fall-off-a-log easy for you, I probably don't stand a chance.

> 
> You might find some of my thoughts on this topic interesting, in the
> "Switch topology changes" chapter of this PDF:
> https://lpc.events/event/11/contributions/949/attachments/823/1555/paper.pdf

I'm well aware of this paper :-) I'll give it another re-read, as I
always find new things.

> 
> With that development summary in mind, you'll probably be prepared to
> use "git log" to better understand some of the stages that tag_8021q
> cross-chip bridging has been through.

Yes, a couple key terms and a little background can go a very long way!
Thanks.

> 
> In principle, when comparing tag_8021q cross-chip bridging to something
> proprietary like Marvell, I consider it to be somewhat analogous to
> Russian/SSSR engineering: it's placed on the "good" side of the diminishing
> returns curve, or i.o.w., it works stupidly well for how simplistic it is.
> I could be interested to help if you come up with a sound proposal that
> addresses your needs and is generic enough that pieces of it are useful
> to others too.

Great to know. I'm in a very early "theory only" stage of this. First
things first - I need to button up full switch functionality and add
another year to the Copyright notice.

> 
> *I seriously doubt that any hw manufacturer would be crazy enough to
> use Vitesse switches for an application for which they are essentially
> out of spec and out of their intended use. Yet that is more or less the
> one-sentence description of what we, at NXP, are doing with them, so I
> know what it's like and I don't necessarily discourage it ;) Generally
> I'd say they take a bit of pushing quite well (while failing at some
> arguably reasonable and basic use cases, like flow control on NPI port -
> go figure).
