Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D3B599D32
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 15:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349511AbiHSN6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 09:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349328AbiHSN56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 09:57:58 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2094.outbound.protection.outlook.com [40.107.92.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DECC100976
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 06:57:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lofnmd1BL3Y11tw1bbURwBUzreABFkRiItcKfPi+pOm3OVRXVIMeCCn8W5zlFeJ56NBlErOxw5eEFRQxOFlDfj+pD6vbuTHUJn2bdrbPP9bFZo2kSrq//8zAA7lxNE2hkjL6Cb1wjk822JEbRDhOMDoKUIENG/J/EpsSEQbMgLtOgQWJZEokF77hgpZzcwxY5RokLcVqdgJ7nzpQ6tIwMe6vkphbnIM66wCeRAz/2X7JX91GEg66SMtT+lbdL/0uIkGoWHpYCmW0C44EyLV34DXrrN/+s0sPMqk76WywNht9KkT/f8f7aeKK2skoK8qS+Fsn1Q9Hofs0jQ9kvQbaGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+2kxMDZrfdmskxhJA/uMRyKAY1OjA7E5Nf3I3dDi8uc=;
 b=kURUBRx92sA9aFVnAW5TmHxO7KFLbHblrokFEVsTH1E45u9BJjg/TBl61YahQ5OIWGYz0LvzdxbNKg+BnmdlAgIXF7ZMEn/k7tM89qvJJ2McdRTX5R6DSHyYdAooxxJMRJoSl4O+VXJrjViUf+DSw9wP5+n2nJj7uO77lDRiv6H6rVWFILndo3ku89YkZ9SiwHgEI2/deITWX/6Lv6bj+fbub1AIILKOxpQ/b7J2fyEhpIz28HmavzPYRwTaj7kOR3OwZDLm/xeEshUOFH6nf+SEjRIBr/GUODR0WBa0z2EDpcrc/EFkptUXXEYz8UUi9IdFH9z0wITz/MRSWVPHAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+2kxMDZrfdmskxhJA/uMRyKAY1OjA7E5Nf3I3dDi8uc=;
 b=C434Yhbg+B9B4rfLLJJyH6V1+/40QLRu4ZSSUsbijJOqsYXlsfo/ZpCArLmeruo6BDvbX/5YspAjF5YK2nPWrY4naO0kIcO1+FVc+cerBQwMMpFc3IgIkJV06EFnHK2bpf7oxBVxaLCVdtSmB1RjAWTeMdCzcTdyb7FWN3m3zhc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB4217.namprd10.prod.outlook.com
 (2603:10b6:5:218::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 19 Aug
 2022 13:57:55 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5504.027; Fri, 19 Aug 2022
 13:57:55 +0000
Date:   Fri, 19 Aug 2022 06:57:48 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH v2 net-next 8/9] net: mscc: ocelot: set up tag_8021q CPU
 ports independent of user port affinity
Message-ID: <Yv+W3IhA0d/0mzEq@euler>
References: <20220818135256.2763602-1-vladimir.oltean@nxp.com>
 <20220818135256.2763602-9-vladimir.oltean@nxp.com>
 <20220818205856.1ab7f5d1@kernel.org>
 <20220819110623.aivnyw7wunfdndav@skbuf>
 <Yv+SNHDXrl3KyaRA@euler>
 <20220819133859.7qzpo7kn3eviymzo@skbuf>
 <Yv+UDHgfZ0krm9X+@euler>
 <20220819134800.icr3qju7fdfdm5oo@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819134800.icr3qju7fdfdm5oo@skbuf>
X-ClientProxiedBy: BYAPR02CA0045.namprd02.prod.outlook.com
 (2603:10b6:a03:54::22) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f798f02-82d4-490d-2c4d-08da81ead094
X-MS-TrafficTypeDiagnostic: DM6PR10MB4217:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U7Wa67NziIxoRDt8LbNcC3pG9JwxRkFLK9ZPCOZe/qDPHhFZ0OLKfIsIjHQ1soRslUzTKfev0z0aBRrkpVeqtJmZNnsvxY23R1jqZuFpxoXNDVcHt6wF0nriqimNfmDGW9u3mIbpN61d5NH6Pw+L+lxYEZwWf3ZhsKY34jc7QdyJqlI52kya89P0mrLbvohP/Rz6GV4dtFjgTgOziAGrG6s7+tTBIbJToPANzc9j4XCuVgyGyOCMIpi5T0Yjhm17o3ITD0jaWidfXIYYLeF31OMjjaK/uhtInGATwBGpyDqHPsVTB9NNkrPtSrjIoxbOeu6Y7zTIqngaSl1t0RLsNhZExnC1/3FuQQYhzZ/UL7PTs3QWAf/7WALa7c40YeAEX80WNf22wgfr1cx9TN2dcm3KSJT2ooeJltbMx2dwKtGdEwDq2ApgCcy3P1a8E5Fq7G5764QlEqaYk3NSJgXVf+lQW0H2knDdmiXl4FKcKC8ajUakfgsqy/vsHoSQ4qXVtGXUDLmEwMHAIPuxoQoE+bPdtayYUSTPd+Jj+yq9Cjxb7eEWOIg+qT0fexoVE7Miw+Jtd8f5E7ydskoIIJIX14i4A49btoSN1BFF9PilWtXLEXPBvP48QeKFnj9oZB1edJ7jVyxatvYji1tHzTt5lNelR1Tj0vgh61DH47SzA5WQG8+r1RmlsLf+ovD5y6zF8GyeUWfD3MWctCEKSlkfiZqsJS5mLXYioVtUZzf2Is4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(136003)(366004)(39830400003)(396003)(346002)(38100700002)(186003)(8676002)(5660300002)(4326008)(66946007)(8936002)(66476007)(7416002)(66556008)(316002)(54906003)(6916009)(2906002)(478600001)(6486002)(26005)(6512007)(86362001)(9686003)(966005)(83380400001)(33716001)(6506007)(6666004)(44832011)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xRjztKYvG0Qe5sfbLP3rqgi/SZBlPdqSAdWoWetNfal6XE5gO1ujc4i24DaB?=
 =?us-ascii?Q?stGf6SVNDwhWNfyOM3QBf7ebETr2K8m41lyHZOB6ziXXOHZO+z42txm+wWHy?=
 =?us-ascii?Q?4RQh/GEu/JoSEQ8mY4h5OJDixDv/fbHmWXfEf26y1NXDcxmnOUBFGh6fcSbu?=
 =?us-ascii?Q?l9f0166D864WhkgdRRZqfTszfwBPM/F7uWsVZJik9z5rXjhLt7AuYcY4jPjH?=
 =?us-ascii?Q?dwbiIWQ8lSbyqpMc9FasW0m8lE2pP5z9WcPvYRRionRRIIE5BGV/iRo8nYt2?=
 =?us-ascii?Q?pUrs2P7YAsrMHY6O3+r1YpkyfOdGWqv8Gkn3iKH/PEerliU5UuNWNtUmL179?=
 =?us-ascii?Q?nR4p9PP+21SYdAji0R+V/DUfa/kiOjUxYU+4xFlgeNaIrqQidLhmOdPjSPss?=
 =?us-ascii?Q?ym+Z8aUPt7QE4Mfv5l2GPRAMOK59+KMKVaEyKz/dNTjJD9i1Z1pUBmZg6mPk?=
 =?us-ascii?Q?+15I5wty/1SwAMX0ShvGfdmYzZS3Z5AwhwgD9N7+hnNeNcvgdfocILaErKay?=
 =?us-ascii?Q?a5P+PaLBNzWERVgMs9WqKDNsJlbaNWTVZX2J/FBB3vULm/OpsYIaIDYykzDg?=
 =?us-ascii?Q?gZqpu35rLjq9cDJaWfScwUIL/LTsNOf+mszigCcjYtWT0NEoY/sme4/B1C+S?=
 =?us-ascii?Q?UiboAlVYqs+efOaq7eMsEquXvQV1jzWvz9YmmCVQU+gSobspDdDRHU66mL4V?=
 =?us-ascii?Q?sDrU8BFQhMS3eD8QE0oH2DMfhQV2XcqYn0NToVr58S04DhhI5FjbsNAUVv2P?=
 =?us-ascii?Q?0NyHaYw0v74KIkCmgCVeiOtxWlh26p2Vr1XjUlAxKEn/VzHZiVPZN567iWE/?=
 =?us-ascii?Q?NsVHadkkv6mgSJdl+cTNNG+gakpi8+5d5okzAc6qgTtjHW5/3EbJVRchOpse?=
 =?us-ascii?Q?lBMLYv2EPwioasUCRzjdjPiDIqYjEknEn51a3LhkwSJrexL9mWXlKjHalNA5?=
 =?us-ascii?Q?NHLnDs3GWPHYBzZT+chmvwwIVY0WiL07e09dnqG89gZtJH4U+xuCNvKjd5va?=
 =?us-ascii?Q?wfMsVzcIFa95ACBBcEXzKZ4c43RKy0yYkr4WCc4lNMUbzcCbS0Fytn8azB8v?=
 =?us-ascii?Q?vCFedj4wcz7+YXhMBL5ST7LN4Qpnv0F6e5CTcW8CK15VEsKewfF0h5WYPauB?=
 =?us-ascii?Q?XMjZ1mizldWAv2HZcH9SWIa/vOaGn7a+jQVx8alsCUq85vB9w1qYFZVb/sXb?=
 =?us-ascii?Q?XR+Qun4hx99E2Cu/KCpG2auMCbsXZFtcRe1lCGVsreeVb0/w2sSezRSZfPH9?=
 =?us-ascii?Q?T6EeLhhC9ElKvHY8gsSkWJofUv6Mm+U+6FCSeZsLYAVLlR/o02Zj000sVb/8?=
 =?us-ascii?Q?xHCBig4M3PrqDQgxDYhH1XQs824xMKJR9ttQqgj67/Hb0HVJ6v2lKs8oCfkr?=
 =?us-ascii?Q?MXoglq3jhknfGJbWQye2bVscotYWN24GLkBiF+oZfT8mWQLFCAZsWnA5BQmj?=
 =?us-ascii?Q?Qww4sCMgAbuaRGyf8mzk1sgVJSLd/Y9Co1v12DGWLUhdESEYILGN8U5Ogl02?=
 =?us-ascii?Q?04sCRVEuAY/eB+uI7tb3G5A7YvgMR++bgrijsMCuGXmC+Kutzm2F/egcS0QW?=
 =?us-ascii?Q?R9+jeeEZ3WFiXnMKRCy8ugKIzb2gmsW7GK17iE+J9qZj89Ih49RhBi+p/jCi?=
 =?us-ascii?Q?dNUMgqJcJ/AeS47OtCAjBUY=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f798f02-82d4-490d-2c4d-08da81ead094
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 13:57:55.0079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fcWT9raZ88n23hvMrVHcUtfcYax0CiB5q6WoIB/FC4Ljq19xvfyQHsjOmM11qkzMA+ASl+du2beykGEdl9CraOkXkQEHbytV+RjKsFeJ4H0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4217
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 01:48:00PM +0000, Vladimir Oltean wrote:
> On Fri, Aug 19, 2022 at 06:45:48AM -0700, Colin Foster wrote:
> > On Fri, Aug 19, 2022 at 01:39:00PM +0000, Vladimir Oltean wrote:
> > > On Fri, Aug 19, 2022 at 06:37:56AM -0700, Colin Foster wrote:
> > > > On Fri, Aug 19, 2022 at 11:06:23AM +0000, Vladimir Oltean wrote:
> > > > > On Thu, Aug 18, 2022 at 08:58:56PM -0700, Jakub Kicinski wrote:
> > > > > > ERROR: modpost: "ocelot_port_teardown_dsa_8021q_cpu" [drivers/net/dsa/ocelot/mscc_felix.ko] undefined!
> > > > > > ERROR: modpost: "ocelot_port_teardown_dsa_8021q_cpu" [drivers/net/dsa/ocelot/mscc_seville.ko] undefined!
> > > > > 
> > > > > Damn, I forgot EXPORT_SYMBOL_GPL()....
> > > > > Since I see you've marked the patches as changes requested already, I'll
> > > > > go ahead and resubmit.
> > > > 
> > > > Any reason not to use the _NS() variants?
> > > 
> > > What's _NS() and why would I use it?
> > 
> > include/linux/export.h.
> > 
> > I don't know when to use one over the other. I just know it was
> > requested in my MFD set for drivers/mfd/ocelot*. Partitioning of the
> > symtab, from what I best understand.
> 
> Odd. No reason given? I would understand symbol namespacing when there
> is a risk of name collision, but I fail to see such a thing when talking
> about ocelot_port_teardown_dsa_8021q_cpu().

https://patchwork.kernel.org/project/netdevbpf/patch/20220508185313.2222956-9-colin.foster@in-advantage.com/#24849610

From there:

> +EXPORT_SYMBOL(ocelot_chip_reset);

Please, switch to the namespace (_NS) variant of the exported-imported
symbols for these drivers.


I'm not sure the full motivation. But I agree, I can't imagine anyone
else randomly naming and exporting another function of that name.

Just thought I'd ask.
