Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF06655499
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 21:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbiLWUyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 15:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiLWUyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 15:54:37 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2129.outbound.protection.outlook.com [40.107.237.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F0F1DF03
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 12:54:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ADpqrJr6UciejQgJAU93sWt4k0kj6Z6PAFChLHNm0w55xCHMwzyVY3ILk4oWr+DZlb/u24e4YWJEWzEDfO4/AK2dS5NS0Im6KriY7ZBGahECdWD31gD7alY0pcUZBD17H4ERPf34r+lcATDTBHSO6TgK9Dgl4pwmdKc21Yn4JpZojqTlZmhCwHq5T1vWUM2cQUHV82IezvKnL3aklviXu2yVM2b3InqGKx85eS6/THkE60M4akRwPfEM30krZFtjawMTrhxx+58UkaZD/HyS5St/RC2wR+eazxoLP0Di9i8dJRkGzF/4TEZ1pVZ9WFmwtI7T4TBpr9oytgIcc8fzlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6aXX8VooXbg1Ni9HbXf3YkygrRrfZhlOCgm9d/iyu28=;
 b=RDroVIKeoZWAOyzZ3USIzfOCcWceLUMIktojhxhqtkPHWjPR7LLtUcUvzVe0tjvvtqWflwJMN7z8jnghREWVQrmcF4P4R+CbBCqg4bJGxvbgwtkLJzV9/nX7KopECMB7sV+wuihi0pjJzn6Vw1rU8th4ZKygfHVOPyKhnFR0GtOS4wei/SAO8Uq9nuYItIzuLVUJ0S5HzdESPYNcS26Ow/vMUVaieoKc/2ptxGnIpNhfA1y0o7sRiuNbyqlcpgr3F0NVSAEVW+3GjH87nYOc0n3oN0UUQ/fPXVDS+ivm6iIhLsQL9++gH8U17tfaIjVHqOnSGLBQ3Qw0zYz+QD27kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6aXX8VooXbg1Ni9HbXf3YkygrRrfZhlOCgm9d/iyu28=;
 b=cuJI8Hxju8LUvvofAZXH9Obb/+6WVkZj4fz+JCAyjdIN6x5Tm9GPvNb3nhgj1l+YpE4dj9vWz3pjkfUAUrjZDYzp3zxFbrsF2ybKlShT1oD8cfAdLit3HIEsWieuVBRlRBdYB+5/4kYYBnq4EWwXGTfZA2A5jzWGx73n6ICb8Z0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB4156.namprd10.prod.outlook.com
 (2603:10b6:5:217::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Fri, 23 Dec
 2022 20:54:33 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5944.013; Fri, 23 Dec 2022
 20:54:33 +0000
Date:   Fri, 23 Dec 2022 12:54:29 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org
Subject: Re: Crosschip bridge functionality
Message-ID: <Y6YVhWSTg4zgQ6is@euler>
References: <Y6YDi0dtiKVezD8/@euler>
 <Y6YKBzDJfs8LP0ny@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6YKBzDJfs8LP0ny@lunn.ch>
X-ClientProxiedBy: BYAPR05CA0102.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::43) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DM6PR10MB4156:EE_
X-MS-Office365-Filtering-Correlation-Id: 95948c99-f9e8-41e4-6334-08dae527e49b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WacMzieDgpkWCi4BXoh7fIupMSTdBAzlOJ3cU1ICrDnHdNXh2xF1oBLuyJQd6YV6A0+3ofVSyCZf+PiF47bRLBQzSIskogYfUEiviiXuHKlyWxM+l+4Mo+/Q6r3GpnGykqIIuDpfCjrchVillpNlzLKum0wt9dwzXNmI/QdgdEM/DJiagEaMO+NKMwFcMGFzDkJO41XjSwAwXkXiqnEBOUfYvFCi3y+sdJ4YbHQbkPRVAeks9IxBKbCaMGhG+xF0+GhxC4r2bL6bpCx8KxUqQ8F5YDD9nQ+d4QQUl0wprC4trvw13y7ZKmH5iBVyGn7K5HHFyLp6TQgwwUH7U233xGKc3lNRMknf+HMFZAXuoZLlyS0X/S0I4b9VTaLgh1x6EpZaTgOZmFujt1CiM6VgrNJ+RArLaOD4UrQJh4MCato4V7RyFPOGAg8DrQSp78ZCbYimlWWDo1TRCpNzsRvUrlvA9sUm+P7luVjbYRwbkxXEQ6TIirvT8fRQTrAa6BaadV3iKj8emzWc1tyy0jC9/mLiRs0zqs/IPBVV+j28MikUCyvMCrxUl5HpMNXSulmHo/LRcjQwLsuz1+kmz/MuPgrTlAXJKRMkA+4o9kFPv1XpJ8lFBLrundKdJmDVINp0Hd+JEwo+8sncM4Ljuwfl/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(346002)(366004)(136003)(376002)(39830400003)(451199015)(38100700002)(7116003)(83380400001)(8936002)(33716001)(6506007)(44832011)(2906002)(54906003)(41300700001)(6486002)(316002)(26005)(86362001)(6666004)(5660300002)(6512007)(478600001)(8676002)(6916009)(4326008)(9686003)(66556008)(66946007)(186003)(3480700007)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K3OdZ4RXj/h3tfgf2dLyfCZJGC3eziUNmrkstTeofKkjU4JtKzizDReRsOUQ?=
 =?us-ascii?Q?Hf3jMGrY5RAltsb/tthuwWOq7/oNSLW7ETPH452NzUrs/HFgoKR08xLkJIYT?=
 =?us-ascii?Q?jXWaSJC3PX5VfabZGDxPGrT9eM/efCfE76JAA3XtBL6wzmFRoRmpqm+fRL+Q?=
 =?us-ascii?Q?skOXuScBHhAK8LgvpLGzdbpOrFwjgfsk3qJkETqDBe6Sag68oBLANkGogJ+H?=
 =?us-ascii?Q?vgRRILiGhIwZExlQ6B20Psq1DopcgopWF8g8JWMji5BLzMTG2zvxUxahybl/?=
 =?us-ascii?Q?qUr26SnZyCum6BbCazftPhZRKSBlWXoIVioKQT5qBPH+QwdUoaPlbpWKgNXe?=
 =?us-ascii?Q?v3Q9Li1+ut8sY+UHTJZhZGnbHLHrgp60kSsLRX7KoP6eEFUbMYMIwpig19go?=
 =?us-ascii?Q?5fvsB3EoPHiHj/fJxTQ1VPrQWBefNpunV4EGMa8MLcv8gPLFLIAMBaovCiCc?=
 =?us-ascii?Q?ZaetlzavNoA29FdhtgzfWxvbhJTD1DyB/LomjMW+bTPIQEW9HeCAb2FPA8am?=
 =?us-ascii?Q?zxJ+OdK/Ryxlnrr4b8GMht1MBdrHPVFoDyoBrMY4KG8RJaivVl1MZ8ux4YI6?=
 =?us-ascii?Q?Y3t8z226kz+AkGTqYF5NRHBo6EpZWmy/u6Te+vIdNQ0jgtmeWmCmF0AHen5O?=
 =?us-ascii?Q?r5gdJd/MLkneel/Sn9ulD/p9axkFp0DNtD+BPxSNieKd3zXLrSqjm4jPRL+I?=
 =?us-ascii?Q?HcH1sV48SBwu8qU7iE2/Ao0lhPjp3c3ojEtozsuu5dht/8O08MOeI9fH/xSj?=
 =?us-ascii?Q?yzBJ6MClUzRZXPLwnA9dvViRwwaLEfx0v2Nd3DlL6T73bU9JlUkfxRLOLMvD?=
 =?us-ascii?Q?F0sOvh9V9XK1bgjproBC6GFf1MFbMNUcEZplD2m6gqhZxora9Ykl/tPOdkXy?=
 =?us-ascii?Q?JptPlPDPk1euI5Acsw2nTqMfrdPHewE4nSodzKNeo9sQzaPPQq7tj8RWEmoO?=
 =?us-ascii?Q?XwynHGG77bqNlQglK7Cxf7Lpgcc2iY9ae+tAuyyGUhv8KSEUfoKjP00Ng5we?=
 =?us-ascii?Q?bjzVyKK/94+AqOqGQ5sooEg15ZN815lDbDMUoDHK5525FVrUdCSQ2GSex9cw?=
 =?us-ascii?Q?lE39JDUGhMbJAz1nn/GCMju5dslebuN2L6peDEMgZeYY5SqU6CIsATFK53Cx?=
 =?us-ascii?Q?1JtCws9UkQd1Juqk8PG+uiqY72IIqmuinbcSJS55eyodzNExh2qlzYefOZs+?=
 =?us-ascii?Q?Cqaom4RkQq1AhWOUZ0EuolzDERyCHkxjKPSIQdddj6lGlyM1g8ycUuULhFhr?=
 =?us-ascii?Q?ys06BN5OtiN+wwBGcHjJ1LpGzreZFiyJ9UXiaeU1H5ojYJQC4Ga20JyCwj1e?=
 =?us-ascii?Q?YKIcVvY/KRva0CYoMjQ6y1TCdF0soxvN1hPcw2ggSCHkHSNseDuUVgTBRk77?=
 =?us-ascii?Q?FhDylxlWz8PTHAh+16jtqz1otgWq1gU68oITnKY6CGJhC/RaWJebK16kf7D+?=
 =?us-ascii?Q?bSs5La3AgNxBC8WAT13rnskXB7/sHJXzEBw0nsvlZF1s6eVKKYQ/2FBHRJot?=
 =?us-ascii?Q?4xZd/vSWPVnZiq9BWT2S5mqtb9Em6gnvUQi5qWqEiaiykK7PCHcuE6FwHSQF?=
 =?us-ascii?Q?p1yaJdlU1mEsOLTSUPGNjLmtbStnfA59liJodJ0CPc23HvdwAfTuV2Y/EQPH?=
 =?us-ascii?Q?Vg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95948c99-f9e8-41e4-6334-08dae527e49b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2022 20:54:33.0407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GkKEfLXlx4Vu0zY1z+Q1KhooPwyWUjSfxBfLA2XzATVxrdrXKV5x42pVSwEh1lLa2sgL8l9h5nKrJJEEk4aAURYvLzNlKzdjo8ff5HTYqYY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4156
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 23, 2022 at 09:05:27PM +0100, Andrew Lunn wrote:
> On Fri, Dec 23, 2022 at 11:37:47AM -0800, Colin Foster wrote:
> > Hello,
> > 
> > I've been looking into what it would take to add the Distributed aspect
> > to the Felix driver, and I have some general questions about the theory
> > of operation and if there are any limitations I don't foresee. It might
> > be a fair bit of work for me to get hardware to even test, so avoiding
> > dead ends early would be really nice!
> > 
> > Also it seems like all the existing Felix-like hardware is all
> > integrated into a SOC, so there's really no other potential users at
> > this time.
> > 
> > For a distributed setup, it looks like I'd just need to create
> > felix_crosschip_bridge_{join,leave} routines, and use the mv88e6xxx as a
> > template. These routines would create internal VLANs where, assuming
> > they use a tagging protocol that the switch can offload (your
> > documentation specifically mentions Marvell-tagged frames for this
> > reason, seemingly) everything should be fully offloaded to the switches.
> > 
> > What's the catch?
> 
> I actually think you need silicon support for this. Earlier versions
> of the Marvell Switches are missing some functionality, which results
> in VLANs leaking in distributed setups. I think the switches also
> share information between themselves, over the DSA ports, i.e. the
> ports between switches.
> 
> I've no idea if you can replicate the Marvell DSA concept with VLANs.
> The Marvell header has D in DSA as a core concept. The SoC can request
> a frame is sent out a specific port of a specific switch. And each
> switch has a routing table which indicates what egress port to use to
> go towards a specific switch. Frames received at the SoC indicate both
> the ingress port and the ingress switch, etc.

"It might not work at all" is definitely a catch :-)

I haven't looked into the Marvell documentation about this, so maybe
that's where I should go next. It seems Ocelot chips support
double-tagging, which would lend itself to the SoC being able to
determine which port and switch for ingress and egress... though that
might imply it could only work with DSA ports on the first chip, which
would be an understandable limitation.

> 
> > In the Marvell case, is there any gotcha where "under these scenarios,
> > the controlling CPU needs to process packets at line rate"?
> 
> None that i know of. But i'm sure Marvell put a reasonable amount of
> thought into how to make a distributed switch. There is at least one
> patent covering the concept. It could be that a VLAN based
> re-implemention could have such problems. 

I'm starting to understand why there's only one user of
crosschip_bridge_* functions. So this sounds to me like a "don't go down
this path - you're in for trouble" scenario.


Thanks for the info!

> 
> 	Andrew
