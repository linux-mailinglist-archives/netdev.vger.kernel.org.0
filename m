Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21CB5EB738
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 03:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiI0Bwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 21:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiI0Bwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 21:52:37 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2129.outbound.protection.outlook.com [40.107.243.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6D273336
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 18:52:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEgsqzcF6F+sI5W068rZ3q/IZUFd45h/VYCFj6bm+kKa0plxtLvYiiqErdhAjrMH1J3Yf/xqwhleixbEw/GqZl1NZRBXyA1sn5p63rf13AxDb7lS5mVgKhW36tZjvBjyxIxeUfJ0Hf5iBssELkmuB/Y16VOjbjbkA/FOvYfdN//blDIAX0H+JII/mmI3QYydJhYK6SGEQ/TtTHlfV6FmDqeGPuqfsqw/dhAmMWrSxkocLJnbnsCjN570rnoLfBgq3qwElkyS473x1viMTeAx/5mBI32c+3JmEk8t1BfHLldpNWz0YN7VjqjugnCHE4a/abxnbKXp+cDaPAa0/3xSjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kJvdQP6jNGAHb7XEUv65gXeRK1tKGl+pdQLL6PZ1O8E=;
 b=kWx7H8X3iLxjUKqKUBb2ooEZmmAOHXYK0aJFAhUReMma+81VW6ckaMQS/1kNeeZdpFOaihTnM6XCQePAFP4fI7M468eJpHeext1boadU6QVwuxHxNKIkj7i8kzLh9vAMskRFAALfodFY4S5Rceh9bze6MuscOgbFnyXBcu0ZUdaPdVsLKViwnSOQIS3cJ9OVIOFx71Ytm7W+5FAcp3fTG52kRHR/QxpPDPtUnIO6023BhhwmcUunfzV4XjVQdsMUoS6xWKFrmPi4kWpuW28R5nTlO0HIvimTw5PnJRoB+kxx8d9EGFI/EH3BV9Pvxz7Yqh/VSAf6rardIASjDM7iAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJvdQP6jNGAHb7XEUv65gXeRK1tKGl+pdQLL6PZ1O8E=;
 b=LkoB+bpe0TZi0jfjnivGiuqeAWw28EPGNTZPV+pC7BV9SrGFD5xAHs3dmbZNS7o5Q2/opYJA0FsLfkD/y0EeH+VbyNUPBGGcdjwVWe9M8GIijqimuXLAfgRtN1uLwqV851pun3XFkwUv16XFVyLcbraA9z3xAvLp1q0BtK4H5+c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB3705.namprd13.prod.outlook.com (2603:10b6:5:24c::16)
 by BY5PR13MB3761.namprd13.prod.outlook.com (2603:10b6:a03:22b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.15; Tue, 27 Sep
 2022 01:52:35 +0000
Received: from DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::c008:3ade:54e7:d3be]) by DM6PR13MB3705.namprd13.prod.outlook.com
 ([fe80::c008:3ade:54e7:d3be%6]) with mapi id 15.20.5676.014; Tue, 27 Sep 2022
 01:52:34 +0000
Date:   Tue, 27 Sep 2022 09:52:26 +0800
From:   Yinjun Zhang <yinjun.zhang@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Fei Qin <fei.qin@corigine.com>
Subject: Re: [PATCH net-next 2/3] nfp: add support for link auto negotiation
Message-ID: <20220927015226.GA22642@nj-rack01-04.nji.corigine.com>
References: <20220921121235.169761-3-simon.horman@corigine.com>
 <20220922180040.50dd1af0@kernel.org>
 <DM6PR13MB3705B174455A7E5225CAF996FC519@DM6PR13MB3705.namprd13.prod.outlook.com>
 <20220923062114.7db02bce@kernel.org>
 <20220923154157.GA13912@nj-rack01-04.nji.corigine.com>
 <20220923172410.5af0cc9f@kernel.org>
 <20220924024530.GA8804@nj-rack01-04.nji.corigine.com>
 <20220926092547.4f2a484e@kernel.org>
 <20220927011353.GA20766@nj-rack01-04.nji.corigine.com>
 <20220926183840.12b96ca7@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926183840.12b96ca7@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: SI1PR02CA0016.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::17) To DM6PR13MB3705.namprd13.prod.outlook.com
 (2603:10b6:5:24c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB3705:EE_|BY5PR13MB3761:EE_
X-MS-Office365-Filtering-Correlation-Id: a23fd2bf-a677-4a87-7160-08daa02af2ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RFzZe6Ui6Xa8jZM79SRNEhGlL0w0dvr4wtB3SOfEhVbeOcRahRZHzejaGfESHHG/8nbWYRiudV9e0NQVahfDyujsAYSLRleBLMT6U9U8q8tY5mctcYq5AKnoGvZkgJNRPqZWZiye8b3m9lIZfKlZHZ9b6rEsSIN8KFk22036GWjFr2Gl8c9q4yO3ApWFQy6U7WP13f38NOQXpz5NwnFgOaJyHwRsBS8XpPZAyjJE80OTqSP7Fy82yQAylICg0DKaMlGpnEFOxXvmseDSafEjvE1vo7BGkBczMQG7KA+URb4zXbrs23245b+g3Gik3Z5W60u1u7/pVnqyS6nrD/6WOMgedL6AiLfw6f0r64Vbao9on/+dOkl/hN6VhKkgjXByx6mQe/MKVdiX9N1F3LgX85eGgY2AVYMhZ9pmMhYJMIXD3dGqpm7c72Q5p8SwTX1QfsclF9bu+oURrLYv/2iCW7yc5xjg1jfMXw8PcFRhpUQ3pFTW6LqxJpqez/S4WpywkxgwCksBYwvnZYcq/H9zHarDNY3Ig7KO/CaEhDLZUGMYmyk5LHzPna4dSCdwJzeNcPsG/qt9YvkUlhMEcMKXriGvDaRFTCrCcS0SdjvO9rVJf4rdnxrEU6R1tx/dlL9XWMuX5VG6LMNc+GQcHMskeC4z4hO5YYKor8FIvCy5KQiyt3JMJWjcY9r2Hn255o04FZcNCah3bQ+3rwu909J96toALGMjiMB/U57ETk8wdTt2XSR9SsZqZBDtstcRSEthHMcQRQNFTxTxaGdxCuZqPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB3705.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(39830400003)(136003)(346002)(396003)(451199015)(478600001)(6486002)(6916009)(52116002)(107886003)(6506007)(6512007)(6666004)(26005)(2906002)(44832011)(5660300002)(41300700001)(8936002)(33656002)(86362001)(54906003)(316002)(4326008)(66556008)(66946007)(8676002)(66476007)(1076003)(38350700002)(186003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VZs1VJ9VFfNFBvyIyiSiwqKxKAHeZL7AYV6OaJeIujbmpOv22B4+/5mCAm1e?=
 =?us-ascii?Q?Lo5CltyXod791zwqpYNWMy31dY0O6/piTx9SiZwNTRCrRLVFZayDWl0NTGhO?=
 =?us-ascii?Q?K0TMdIshYX1PoeapNN/EBnm29Tg4k+tSOF/2k80R764f7AVm08mOAKIi/Inv?=
 =?us-ascii?Q?oCZlVbPciTU1N6TDDi3pJ0hPnutmtrY/AMAKOewBW3nad2FKiV061JmILeYh?=
 =?us-ascii?Q?vMsBGM9csrBR7N/NeNLCDTKbFm9MYjoejRsQ6DHDaNTL9MkmkypPZSXURrR4?=
 =?us-ascii?Q?qS8De7EZz2D0gUozKtK7GpvhslZ6xqVzkweWNpjrOAKTa59vZKbC9LlMo3Xc?=
 =?us-ascii?Q?sJCEWHAy1aMC9K/7JwHmW+uzmXMasHgkKEzueaA5ywoZieNgr1brI9buv3UH?=
 =?us-ascii?Q?KHyK2i84laaeL1x9tgOQl4SNqDI322tzEHIWQTFtlJKWyknRUfRa9GSVt9by?=
 =?us-ascii?Q?M2rqA3fyaQwCO6Y0tx8DrSZl5wZTBIAsvhqYVd4zP22a58NmU7X0VUwNl+38?=
 =?us-ascii?Q?MVMH6gREKPkvakSlC/EGCmixgBZzb8YvFdXRszJ0HOKCQjO2ooB6RkCSIymi?=
 =?us-ascii?Q?MTghMVlhTH3cgUV2vCpM0tgN2HJuJ8Ljc/H7VrqWX74R4HYrllB7j/n9dCBb?=
 =?us-ascii?Q?TqwHc4oAOuQlkcVdupi8f4Xc7bEF0NhaXJwO4BThvgFdzdCbHGLTrtyWTz6M?=
 =?us-ascii?Q?3mXGr/h1JjVg8EgxWaWA3hTEWj3C04AAndRs3F0KmcBRlGtw+xfCXC+60r89?=
 =?us-ascii?Q?/xR3bpVENvEMJxcYRQGnDGJ0viL24qXZfHzSWfSo/2vD2rCqwVW5q1VB78oG?=
 =?us-ascii?Q?jIM2D+Nc3PTPutYB1uGOc7PltBHS/r42W9bOHw8P/pw0Ibrq5C6JDm2mVcsz?=
 =?us-ascii?Q?IFkUXQfzk/7Mz3/k5kfPnNT6l4BlgS46bL8p97XB30ybttf9g3smRuPqlWU8?=
 =?us-ascii?Q?FSiI52oGATmZCJyM85cM4QDbcF0jHUS25Y1v62k2AGL5NpwKLqFY+VnihpbW?=
 =?us-ascii?Q?fG3WefFwUOpI+hS29wNomYohgH0YRSqV0ogN2t1yGDYQVFNt5tSPiVwmSow1?=
 =?us-ascii?Q?g5hVWmhjBRR9ZhB9xDb7rMQMIzPYPMRFvtNnacWLUBSWskKNcVxwqQNCJwN8?=
 =?us-ascii?Q?wGYBgnruPbm8G5++PinULBFwelvsdlWXYZWXtmL0AxuH0AGUsKCVSAD/qmeS?=
 =?us-ascii?Q?QuzqSuTlFUsMYa9oPi8Tb9RYi72oxqMdYRWodDnSDMosWM8XIt0M1+IvFMGc?=
 =?us-ascii?Q?tSo0WB1iZyGkibq2vLSIo4qiPiDZQCixIpyzFOXbNPK9KsFL61tuAnNIwaAy?=
 =?us-ascii?Q?sdSoVSVg05yLPvG4WmWDq+BEhZwBm1yFfaoUHYIT7U/AqpL8ZFEjH8349qXp?=
 =?us-ascii?Q?BdyKVWG/PnaiMaMbEHBR+cjIoF/wUuC1p7YJhGIZYIiXiGqdwRCR2UMHBojz?=
 =?us-ascii?Q?x04+ewBVH6YGHDGzEjMC9+J69H15mjGjHzmQu5qvCIn/N/Y2bKpb3H6s6M4q?=
 =?us-ascii?Q?+NoLz1+S+/AY3yo5OCAof9f8LLYWYtZIl6AjbvjAvfRG26HtgeOUCVKi6D2e?=
 =?us-ascii?Q?ELcZhAD+mbXl+tTAUxsxa9TXU57WqRkGw4eoJ8Yk5jqS6KZ47IyKztCyk//Y?=
 =?us-ascii?Q?zA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a23fd2bf-a677-4a87-7160-08daa02af2ba
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB3705.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 01:52:34.8815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zfZsdP12cLNpy3GVyZa7+x5Z1SO0dqnaCZ4SiiOIPdJQBbZNmWG6OHhebPEjsVdLDf2u3Sh/g2NoKx303/vUlL/4m26t7dXHHWDxbzyx05k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3761
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 06:38:40PM -0700, Jakub Kicinski wrote:
> On Tue, 27 Sep 2022 09:13:53 +0800 Yinjun Zhang wrote:
> > On Mon, Sep 26, 2022 at 09:25:47AM -0700, Jakub Kicinski wrote:
> > > On Sat, 24 Sep 2022 10:45:30 +0800 Yinjun Zhang wrote:  
> > > > Not only check if it's flower, but also check if it's sp_indiff when
> > > > it's not flower by parsing the tlv caps.  
> > > 
> > > Seems bogus. The speed independence is a property of the whole FW image,
> > > you record it in the pf structure.  
> > 
> > It's indeed a per-fw property, but we don't have existing way to expose
> > per-fw capabilities to driver currently, so use per-vnic tlv caps here.
> > Maybe define a new fw symbol is a choice, but my concern is it's not
> > visible to netvf driver.
> > Any suggestion is welcomed.
> 
> Why not put an rtsym with the value in the FW? That'd be my first
> go-to way of communicating information about the FW as a whole.

Like I said, the VF driver cannot read the rtsym, so it's not a perfect
way as exposing a per-FW property. But for this case, it's OK since VF
doesn't need this info. I'll try this way. Thanks.
