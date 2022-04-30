Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D798515F9D
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 19:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237406AbiD3Rjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 13:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235494AbiD3Rjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 13:39:45 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2117.outbound.protection.outlook.com [40.107.237.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C15964736;
        Sat, 30 Apr 2022 10:36:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Le2HOqQQNi/Zxy/wsoV1+lXsnQeNCI9uUFH9a+EU0WfpBKoyuLuswSzHxzSx7C7eKaxsHU73WPAacplBGrHetZFsmV+U6v74WCV0fVrQe7u06mD4v2DKJ+FONSVCERG5Yz2sLgKSFaHBXVWnX/mVFPfgE4f6YngrqXrFHmobKu9WmpeAmK8nuJj34Z7YCAQ3TrbkvCuRo8MgsFDrIP4AGZXzLSKQ1o+a6jH4t/7iuLb4ZA0qiVi9ESci/jgZ+6OutTSIznh7i53CSV5O+/YeZWJbYorZfR7iZPZ4j8pxif0IIH4SiICjBDQYE8i/g5vD2gUnxFzcQRrzSlGd7qoBoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8aqIOuVU4tKljik0b6mH2zFbYVpDfghZ62TZGXilZWY=;
 b=WrZ9nG6bb0K+Nkg6W29Amay7WnS4iaxJBs468CsAiq8NlWazP1OOyVmGavqsDpCLy0vyQgBXRRNKrEtSAcHvy1rlMlio1671JHwX1rjUGetXCYoJQFOMl1lqyjGgK/SKl9ibhr6fi2F7KioczgYusCTNey+N5UvzGoDAuUhaUryUtv4uVDT4qSD8Dqc4K0yGjbEsu4y2eejJLnJU9Xd5KZTIRHKFqHOnxO0Qj3ZTqDEgHm+7oeuZ55m7jnDdXJYQ5IRQ1P8wJivlaRS8mLGVjUBn0SjNMvPPML7YUHYEbCwS2pZ30PDydyHxkxwvX8RWZVb49+FxOiIhKRHQ2cxb0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8aqIOuVU4tKljik0b6mH2zFbYVpDfghZ62TZGXilZWY=;
 b=mw2MfcQ9sMVG76jusK6csKA3a3T2mXYvek6SpWlS5tRAjVt5+jGfmjWETksfdIeEEMJ40CZT/VJ+kB1AZ5156J/EJhEvMHk/b+lH5NeVLt1m3BfSY+XGAWumeSA4BEoaVrevyskSu7jbPhh6j5VXFaPEreROIyd4YuDM4WA7I68=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM5PR10MB1818.namprd10.prod.outlook.com
 (2603:10b6:3:110::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.19; Sat, 30 Apr
 2022 17:36:19 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5186.028; Sat, 30 Apr 2022
 17:36:19 +0000
Date:   Sat, 30 Apr 2022 10:36:15 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v1 net 1/2] net: ethernet: ocelot: rename vcap_props to
 clearly be an ocelot member
Message-ID: <20220430173615.GC3846867@euler>
References: <20220429233049.3726791-1-colin.foster@in-advantage.com>
 <20220429233049.3726791-2-colin.foster@in-advantage.com>
 <20220429190752.36a8f4dd@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220429190752.36a8f4dd@kernel.org>
X-ClientProxiedBy: BYAPR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::26) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8aa0f0e-9a15-4600-541d-08da2acfef72
X-MS-TrafficTypeDiagnostic: DM5PR10MB1818:EE_
X-Microsoft-Antispam-PRVS: <DM5PR10MB181880CEAD0FBC000E5E270BA4FF9@DM5PR10MB1818.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RFI5BT05go65q+7P032aCLFlRcfYoSEX8YBu1eE2h8iSTc/BKnA+dr8jXpN5re6ht+hrxzDiUCBP/cLW8m5UwJEZhvxr/3lHYGDiP+dDyvwHHl3J0x5oinD9TY2ZKxs+acTDX+zDFNpXU9PC2UYcSXs3AYqbD6v18dasFVfhOT7u7ZcbU0G8lRna7NTieME4HFPDinA4RJW0rrGf88a7zgMXIkGFDea9XswFPn+QsyQqkd6SvbUUFXvCSxrVizQFvuh+XbXszThLiDo1JdwSXYSI9bMVQ5EqLBPC1LyvLpgFmqNCr0By/LejB00mnHN+7gRY4bmxhnFZxWDGsPNHVL0m1cucURY1KZi5hEyRzP/UkHex2IvIyXuEdXLk2mavrwxgr044fgf94YZWSMb8v4OmilKnhQ1E3MtVVggmTBY+7GFwABHGMh9BOyksEzPivPRAx9Rfr2GZtx/wXS7C98bQznlvhYb4eeBI44j0evW3yjg/uvE4FJ/5QupUsoWOx4tVMAHoMR4WTAAQozsXr3VtTxSQlRcTnvkLc+dbhr6MPbSmvGuRBT978dlD/YQxxQYZ1DgoOW1Tx+4CjGJzKybPXBgFLDsWGFPqhIgAoClnHh+V94Z2eoEC8RuNHFGRngcjo7OXM5GoCsp9tcGMC2DA8/1Ts8yVVlAiJagm5nJdu7lgoNmI8I0e7I3qY7sVaE3WnyZc7vJW+xwAdE68Zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(136003)(346002)(396003)(376002)(39830400003)(52116002)(6506007)(6666004)(6916009)(186003)(54906003)(1076003)(86362001)(44832011)(26005)(316002)(508600001)(33656002)(9686003)(6486002)(8936002)(4326008)(66946007)(8676002)(66556008)(66476007)(2906002)(6512007)(5660300002)(38350700002)(4744005)(7416002)(38100700002)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ibVvBMFMf6jYUzzN8FzoxMia4+GEijoayj4dgVEYuWWU6P9OOjulwA0b3yka?=
 =?us-ascii?Q?fBhZBTYzWMyA+uwWPK/8BQkQyXGRBHZLjpmJs4V04dFnXxLUxSCBRoqRqaD7?=
 =?us-ascii?Q?ZW3Fx3CCLlUh2zkqOfpw4PqRsP66irZtXh22xoTYJzMoaLgwep00iLzOWOu6?=
 =?us-ascii?Q?f26koOshpqpinqzLx/eYvOOpEw23my9rbJHCkC1xy8Jcp+7+tFWkTozaHDHy?=
 =?us-ascii?Q?tp2vR0OFG/Bdf3mg9fKUJc+U7JYqRwO036a8rFv4jPmEOWey+PFqW+XLTqmX?=
 =?us-ascii?Q?cQ5pgpl+YFY/9Y4rx3Rzx5BGjVbun168nFbi0dFuWW61AuQCFD7lOm17m7kn?=
 =?us-ascii?Q?zRyia+BonkY1b2HyxR60WoBLgIUrMMge8Cr+k1PU3NpaBm3AALtmoW7Zcj0n?=
 =?us-ascii?Q?FEaJ8gLBfJ/o0FFjBgbtY4HqTtQ4XPaXRteXp/HtGxmGf7Oq5eL9QvfHHCgi?=
 =?us-ascii?Q?ii4Tp/LWCIFQVvssgZNd8Kv5S+oaxQcAeDE0AQrz1AYjh+QGBVWrR5vatFwQ?=
 =?us-ascii?Q?Euq3h52wBuafqfzmkSvj+KB6elkPrg4jV7qKdwFAdDwY7HKXe10Kesu13oCB?=
 =?us-ascii?Q?2X6869ainuo/ukFCWP404Ulc9PbLrUEkvBEtBtfu/0bXIwZfq3lEPdGDm7MQ?=
 =?us-ascii?Q?0IrIaZMEQmsyo6N6YXfnwP4xN3/3F+PBkputWQBTZHF+Fq5oZgkmmR5HGY+R?=
 =?us-ascii?Q?Tt3b2LLjCdNhKHJKzOOtrC/fhFvitc6H3GJ9YcSqaIEyqGZUY0OpC84/aDQc?=
 =?us-ascii?Q?FFl6YthGNxrfy2VceXWN18SN9AQN6KDay+PTukGqRejAbflw/Deb+VVbAG3W?=
 =?us-ascii?Q?lGesNN6YyIOAxEBc4ov0FmcnWInZzWoxLINinOUda+bKndqMrv/2pfQMokvF?=
 =?us-ascii?Q?iGT36+YIsGBXH7CSgoKoZsdJQ58hTq5DwJtn1Q1T8VkO1Qmqvnb3GFVSW2r2?=
 =?us-ascii?Q?OGzRVoiR7LfXpBWltBpcd/cpiyjjVceBHqy2ljz096aRgu8FdAeb3n6Z9TFX?=
 =?us-ascii?Q?aszanz+q6RIfTQqEr4ijB/sjF1yctoIdjmVfmrRMbE/c2RcSmt/8VOTtBbov?=
 =?us-ascii?Q?yHVhS7gWUTTSqS+8SU+gs2a1BhuI87D6D3lEeG3wIshOqvWqT/dQZT+5Q8H8?=
 =?us-ascii?Q?cZozBmsY6oLWJs+wI9oDGJxvoEDM0x2tzVnZ+D9UX+q3+gfOBBHJV4NXFI4i?=
 =?us-ascii?Q?cCE+V+qFt9cD00NzIDYqmW2xWLQfpKjYlSZPaUNmEfYGQtHvW7JVwrn/2bLL?=
 =?us-ascii?Q?vw6JWVbAHwNnQ11MqycDM/lAH9hokAfZPWg26v0YBHuMGBZ/8e7tVIjjPloX?=
 =?us-ascii?Q?Vzx1op+bNyo7OJ9tj7CsAry0qV7+BPrVq/s8HG4BndJG6k7hx0pBEAzawQIl?=
 =?us-ascii?Q?YZgcgRr1YPxZWwPvBE/GibufT52X73ErV0EekofcugSm8mpvnEU9rYQ0Axu5?=
 =?us-ascii?Q?sAEzUTf8pThKSLVi5dw9rHzyqQ/wrzrOj4ktfnf7wa48J8ANAk+vwHsuhrjy?=
 =?us-ascii?Q?uA4hsoQriM3ByXej9DKrM3T9e+4bvYmXo1CLiuVKbeC/tzLmFVBlIKbv4Fzx?=
 =?us-ascii?Q?kRUrGQ5mLNbqzvlYjI3/UkNLkPjjfrJ9jju2xOAO5s60y2JOvVIlZOv8xtqL?=
 =?us-ascii?Q?5bEEaUHO+TsnApYK44xyMApLfgl1Uj9oLJdllucSXR/x8ZPAdBWMu8FQKz2s?=
 =?us-ascii?Q?mQYjZ6AGyFcbTi1sieTHDGNCjA8PgPxyuDvIhBAVuTMNXDzgemLceUz794et?=
 =?us-ascii?Q?1mqeu927uJ57DVWR/ScGx/9ChhNyzhdyv4p7SzgKCi7SGQM+KIIM?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8aa0f0e-9a15-4600-541d-08da2acfef72
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2022 17:36:19.2221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LeuV3Wv4OcE31sO+aUHY8435nqHZmnPE1pHbjlLQ5JlKCK0M1N0F4KBgD0xxXYM/E/YqOePeAKzRfYKiOWz+XB0YJ0YFv32diKU+OYDsHug=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1818
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Fri, Apr 29, 2022 at 07:07:52PM -0700, Jakub Kicinski wrote:
> On Fri, 29 Apr 2022 16:30:48 -0700 Colin Foster wrote:
> > The vcap_props structure is part of the ocelot driver. It is in the process
> > of being exported to a wider scope, so renaming it to match other structure
> > definitions in the include/soc/mscc/ocelot.h makes sense.
> > 
> > I'm splitting the rename operation into this separate commit, since it
> > should make the actual bug fix (next commit) easier to review.
> 
> Sure, but is it really necessary to do it now, or can we do it later 
> in net-next? There's only one struct vcap_props in the tree AFAICT.

I see your point. There wouldn't be a name collision, so the change
isn't absolutely necessary - just a nice convention. So I could have
patched the "bug" in net, then done the rename in net-next. I hadn't
considered this.

It seems like this patch set is bound for net-next in some way, shape,
or form, so it might be a non-issue.

Thanks for the feedback!
