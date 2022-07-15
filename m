Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D69E57657D
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 19:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbiGOQ5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 12:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235004AbiGOQ5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 12:57:33 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C647A519;
        Fri, 15 Jul 2022 09:57:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mC/I1TGVynLxX6gCwbhhhvIs9Ywe5U9HmzmxGzHJ5FyvqRi16qIAOZ/KsCyCNk11bP9NlHLKlTPQcE4LFmYc8yDOR8PSYRab5IancpRzi0m76J2f01QWxBncLdnYTKASnHC3hv6WATLffqxf3fYODmNPXWpaKU/M95N5dm50pyvu+kURHNMp+Mv2c2V82KnoWq+u8JiFN4q6fkW6y3YejlukOYK/QiuUVPcUVOCmecOmnEatVja6Fsvv2AZk3a6ukHY6sP8ZOVWMmpamPyZ36dcCWSFr1agZe1+bNDXgOBL0MxgKVGUBzvflI9y1kGTAtskjmqlqsKBvaxXltwE6Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gD4gazgNu9PW3lMT1FhAM8irxci+wgDlQnavQZouMhM=;
 b=fxnbBMcnel6J7qniEiR2Ci9PW7ACKtL2+V8IxmSJQKa6uEVaYc1RVyIQq4+StfwW6Ohi6gfQ7n7Y1DCLK/sN+xP/07PL5rX+LY1KiiysrcgpahhXy32wPpA2uuQrRfb4u5SSllosFJmbc1qwMg39QOFL2DE7inMLn9GBiwhBaWaOxsaXaUukiXTyTxHMNT8xa9O+pHnrmpiro4plr2jOmjO9FQa/GWkZU0k/TzBdwYoPLeqLUPTyTLDbCtvaegC/Vq1t88K8lNo8I7kEymfhMY03U0hp2ADGS5ulH7cYr+b5MrZZyxzl7Zui94l5wu6gbnY5Okfw1/fwkHrE/nleFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gD4gazgNu9PW3lMT1FhAM8irxci+wgDlQnavQZouMhM=;
 b=v4/pd4ZkEw0/lwWwd1+y5VR9yWf/4/dJ6NkaEx7KkuAwc2/+b3JY07qndl5YC3hpbEKvmyIBS3y5qUA71uN6z04+eE0MqsgRT3sXWAUwFJLeuI0JCiBF4sQyIhNtrGcjKA9nYPHCqfP4hQrZackn3Xl5VGVvuwPaVSwGeiLC5i0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BLAPR10MB4867.namprd10.prod.outlook.com
 (2603:10b6:208:321::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Fri, 15 Jul
 2022 16:57:29 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5395.020; Fri, 15 Jul 2022
 16:57:28 +0000
Date:   Fri, 15 Jul 2022 09:57:24 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        "katie.morris@in-advantage.com" <katie.morris@in-advantage.com>
Subject: Re: [PATCH v13 net-next 0/9] add support for VSC7512 control over SPI
Message-ID: <YtGcdGj6yi546oWk@euler>
References: <20220705204743.3224692-1-colin.foster@in-advantage.com>
 <20220708200918.131c0950@kernel.org>
 <YsvWh8YJGeJNbQFB@google.com>
 <20220711112116.2f931390@kernel.org>
 <YszYKLxNyuLdH35Q@COLIN-DESKTOP1.localdomain>
 <20220712220856.qbfyhll5o7ygloka@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712220856.qbfyhll5o7ygloka@skbuf>
X-ClientProxiedBy: SJ0PR13CA0135.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::20) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bb47ac58-5e83-47b8-7dcc-08da668319be
X-MS-TrafficTypeDiagnostic: BLAPR10MB4867:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ipFxhs8LyiZcL5MZNzwFNhYA2NTNUQrzV1zhGOczaENQ8cxr3Sra9uLRniJfPiSpFngUMcEaxWdZIIXKJ3Y+dBreKnt8MCMGyXDbYer5gZY6XkAnr+QByVbNJGP9QoBq7/UtuQ+DUPvciyfYh8+VLZ5Ly1Hdh9NxtQy+N7brcdkCqq4vHSZV6FobwcBvvNIOfBHQsefKOTjjjE0oeOy/5Blr3RPw4O1KCdPGfwc6WMZLGG+E34JaTdAeZlDTg3FRhn3q+ge2qcul9GG8FK8oBEvNnIhA9BhQnZmi/X6NjRjPBJwqz9j4hRSDB+FH+dsQRVlNySOXY9bgV6liDj0GnGlG3ZOpB/kirgn9D9wE3cp/artfU5ZKB/CCm3LOjDIWIJbwdmUiAsn3T2tSFVL/uTKn2SvUkZjAZiiImhaTv+926Q6TL/7Yok8mZkA1U2Wieb7F3Y3eJuz15G91w48qvPtB6wZE1hrqN3TTVJXLoJB/ONyhWA4WpzcDNdtvo8P3Z6ehVG/XU4Oq/G2pWBcCUqF+ukV572SZiIg3OhJ4i7PoDeLVbwLIMUh3wxYto8MGgcG/Irrd4IR3uNsD8TfRsXb8yYpOSyGoT4auyYluwQ95+Hso9YgYbubP7OwW1j2Ou3AXIO8eFYxKduo+sPTXXdMowy3pwqocTy8kG2bCgs6CvW8ZJOmPHSFUbtJ9euqSqtoH8oGYc7SACe4+aQUM2laVm3Fss0j6ZVeGOy0iObYc4C3s04nhnbWVbaZMWRod
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(396003)(346002)(136003)(39830400003)(366004)(41300700001)(6486002)(6506007)(86362001)(478600001)(107886003)(6666004)(186003)(6512007)(9686003)(83380400001)(38100700002)(26005)(2906002)(8936002)(5660300002)(7416002)(8676002)(6916009)(33716001)(66476007)(66556008)(66946007)(44832011)(54906003)(316002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MbtvOdWfDMM4fGYIXkmzg4WE1jAEe9C0zxiWfXAkrSCOeiKpBS1oqrgjkfBC?=
 =?us-ascii?Q?uUZUKrVXadu4a2cH+90eSNXFfWBZPNDnZVbSsmNv3Ll+dvSH1bcskPjfdcTq?=
 =?us-ascii?Q?SQ8y5qrmC24J2qamh0etppzoU3dvsRVlQP/CTEwhjAnQQWDLKiVWP82Ts58R?=
 =?us-ascii?Q?kSc3eUtVzHMKLVPf+hS0c3WpepuNw7tTQhlN1gFej1WwYsoPizQY/sfWrv17?=
 =?us-ascii?Q?5llz76k0c6jKs5937C8mqLoyi5RixHKV0UEPFNCTq3XLb3FPHBlSDC67HHsh?=
 =?us-ascii?Q?u/JbDlwQYE4hOjoVtnSYVZphX4XtjpjW6op7u6l4dE7VovoagHdC+MMGAqIq?=
 =?us-ascii?Q?ySrQfnJPuU2ZQOVrG+Qy66XqRTcfiHb2D4x9939oAHe6BaIQT4LPAXpI6n66?=
 =?us-ascii?Q?Ilf8WOA2NtszqFbrkYNMN3zJwn44M3oQB+P1M5Die4YEQ+nDxUTarSIsARAU?=
 =?us-ascii?Q?C5cEeAnwFXmGzmhOeAxHwxe8mgWD9slmegzVl60k8WcMGtnTPFWelwg/ivOs?=
 =?us-ascii?Q?xurEYzqF4znb1jFpg1OEPiLVy250k0LBRJkCR2vXLMUB/xg8GjcltfpjXF0X?=
 =?us-ascii?Q?lqEFa4XUY02NNi0IKm/502Lbr8y7lZRZXeAWofOouru1hzUBGiMUxEBYMjdA?=
 =?us-ascii?Q?0l7rQZKml7SeejyEeW7jrbxpAcq+6t8UZIbKb/rKX2EW9DmsGbKTI7QuSv8V?=
 =?us-ascii?Q?9u5Enk5ynWSTDTvtQPXKK+XZhDV+8ltXv/sK++3OUDigP7FRjyM/zps8yn6O?=
 =?us-ascii?Q?EUUmADlodvH4Icjnk8yiSGc74L9FVcgqA4hMqgMNaHf8FvHNACqWtTRTQ7n7?=
 =?us-ascii?Q?v0AHupaRmuq7BjDVDm92JMjdZEaEXCocp3CZccohUKM3UxsEPKAILpMr/UFh?=
 =?us-ascii?Q?31RHHOu5b4yNdgnuxKZQJ264QFDonV8mqlJjw0AJRopciDcM6B//otULCPMJ?=
 =?us-ascii?Q?fp8b20Dj0PAjyIB3ZsaWmp9Ssb6EjTVg6Bi9R5n9cKH0yOoi6445MW/GtQR5?=
 =?us-ascii?Q?fA+2HX06roYfRQWq+wC4owhiKob/LpAO5WTqkhDkB+bC58A7DNJvHpdDXDIN?=
 =?us-ascii?Q?mL/Ox7UDlBz+EHmy8F3GsRg0C7/+krO1SuQAbWaHwT9qDWuHDSmo+ATFdJtS?=
 =?us-ascii?Q?GaHZHGLf2ONpGKdtj7OK7uZd23qrdUYE395PIsSIOHl0wTbeb801WYQ7Uqni?=
 =?us-ascii?Q?f1hFUOSMbPxqiS0M49LlbgUFSWaaMkbgs92T4rRxJSZQ5QmirG3LewYX5n0Z?=
 =?us-ascii?Q?BmoVOwkTMtpj/z/pEkQ7PnL69wUJI3Wq8oYmFt2x2+1vjRzmyiTNmsbDzuGq?=
 =?us-ascii?Q?5vhfT7bOZknygwLLtAFOZmut/HmUnxcSlRBjVG7lHYEDZh2f/uF7j49FfKGg?=
 =?us-ascii?Q?AnaBb+NOxOFPxRtd3Mk53FQOZj4p9Sz+21BH45NkjiSGxoaXEVR9pDC9QHbF?=
 =?us-ascii?Q?EieBjQbSYaMtqDlSXUBKqAZ4JZyKs8Nk+TKCqQZ65KemigWz9ItkN2tTePuP?=
 =?us-ascii?Q?aSzf3rhVXjHgPVRQGqm3ljY3gI524XTFJ52fG69QNYM4QiAE8kElYrAIqdlN?=
 =?us-ascii?Q?7EtNFv7KSF2ivroGYvP/P/9wYFB3CRv8gczj6LdRCU7No9Y06hyMDXZel/pU?=
 =?us-ascii?Q?Kg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb47ac58-5e83-47b8-7dcc-08da668319be
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 16:57:28.7822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zlSEVrMS7saN3oZpjz4w6kbF99DYYWgQN1BPCv56Sp2MH4UhQiEltvuXK1xE9i8FHlxwjikmHhHmgVeeUVidu9muFJ8VmqkoRh8gS08QeSY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4867
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 10:08:57PM +0000, Vladimir Oltean wrote:
> On Mon, Jul 11, 2022 at 07:10:48PM -0700, Colin Foster wrote:
> > On Mon, Jul 11, 2022 at 11:21:16AM -0700, Jakub Kicinski wrote:
> > > On Mon, 11 Jul 2022 08:51:35 +0100 Lee Jones wrote:
> > > > > Can this go into net-next if there are no more complains over the
> > > > > weekend? Anyone still planning to review?  
> > > > 
> > > > As the subsystem with the fewest changes, I'm not sure why it would.
> > > 
> > > Yeah, just going by the tag in the subject. I have no preference,
> > > looks like it applies cleanly to Linus'.
> > > 
> > > > I'd planed to route this in via MFD and send out a pull-request for
> > > > other sub-system maintainers to pull from.
> > > > 
> > > > If you would like to co-ordinate it instead, you'd be welcome to.
> > > > However, I (and probably Linus) would need a succinct immutable branch
> > > > to pull from.
> > > 
> > > Oh, that'd be perfect, sorry, I didn't realize there was already a plan.
> > > If you're willing to carry on as intended, please do.
> > > 
> > > Colin if there is another version please make a note of the above
> > > merging plan in the cover letter and drop the net-next tag. 
> > > Just in  case my goldfish brain forgets.
> > 
> > I wasn't sure of the plan, but this makes sense to bring it through MFD.
> > Fortunately there's enough work for me on the DSA front that there's no
> > way that'll land before this merge window - so I have no objection to it
> > going any non-net-next path.
> > 
> > I'll look to Lee as to whether there should be a v14 with the header
> > guard addition per Vladimir's review, or whether that should be in a
> > future patch set. I'm happy to go either way.
> 
> From my side, the changes to this patch set can be incremental, I'd be
> happy if Lee would take them as is.

Just making sure this hasn't slipped through the cracks. Should I resend
this next week (Monday / Tuesday?) with the Reviewed-by tags and switch
it to MFD instead of net-next?
