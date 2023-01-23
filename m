Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2FA9677B52
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 13:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbjAWMoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 07:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjAWMoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 07:44:18 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2138.outbound.protection.outlook.com [40.107.92.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCC816AD0
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 04:44:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cU4uL1sr/jIkgeiuT2LFpr+xArBPWI3HZZaOetk/4JA9O2coVPXwNSjRpTnWcdBps4BTrv1CWsoiNGPUkhKTuBKsEt5hAAatZws+iHYNZry0Zw5Upt2mC9teqhoEjAAxqHBl7Ec63bEO8lRZZgyiBMMRUBH1fYxm/CrhWUfI8Wg8kEg14gpKq+q8dEl7egHekK/TDNSB1BijHL8jzqNaKUlcAy/0vrx5THLQcvjPjZsUVMrkTtzSIBquspd4BudUNG3T08+xt8WnIgBfwf2xwW5lPJntjgkp6b5LkOAhI3kZ0lr9cUhPUVs058WpteCrbwBNNYnUidPRPygeEspSnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Wyh7HCksb47S4Adujk7IaHAWq0PnjuP/5XlpwOX/j4=;
 b=LIzpZ2DzHJRY4dO6mCKjU8AoAsW3PKbaG7i9+IHXZ2EgAHviWNK9Nqz1W+Ka3MYfGmtltw9MbpglJSC5gAYH2KNHw6jX3Y6HALS0wuiTs0UlkirPg9GV4h0DLoAY9L3xU28pYw+IWrUIPKAllEa4JrzT3rhBjtlkruXOy7iN7eSP5GYtfpISHCCPUohfWN8WH6q+kVBTali6NHoQnaRaovB/D/hV0fhdFHzuF9bcLlDBVJGLE/2gegMuoTMM15M1P1Py+7fCyxfYKkl4F3A5JeZty+Tep9/kpfEcnxvVkEWcP8Ja64O1iQldy04wQ9Bs8v4hyEyT7apaqlpoomLVVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Wyh7HCksb47S4Adujk7IaHAWq0PnjuP/5XlpwOX/j4=;
 b=UN79BIz+axUJzWJ3VYCkYnmorZhIM5HPvsV9bz6jCCJ0NjzNY4b70v2cNQ3z5oMhCw+RmxwEe0/Dpl/Ghbg0263bCQr2OgDavmy4r7swluk94Xrj1mQr4/0DoMh8l4wB3kumruJ7TMFXTD032IcmxeVys/th7xXC6DIwWDdj5UI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4129.namprd13.prod.outlook.com (2603:10b6:5:2a4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 12:44:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 12:44:13 +0000
Date:   Mon, 23 Jan 2023 13:44:07 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Subject: Re: [PATCH net-next 3/6] net: enetc: add definition for offset
 between eMAC and pMAC regs
Message-ID: <Y86BFyhhh1SA97dw@corigine.com>
References: <20230119160431.295833-1-vladimir.oltean@nxp.com>
 <20230119160431.295833-4-vladimir.oltean@nxp.com>
 <Y81kbbO+X21uVFMb@corigine.com>
 <20230123112411.ofw6cx3qv6uh4txi@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123112411.ofw6cx3qv6uh4txi@skbuf>
X-ClientProxiedBy: AS4P250CA0019.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4129:EE_
X-MS-Office365-Filtering-Correlation-Id: 86ebe6fc-1594-42b1-fbba-08dafd3f8804
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M6IlxBoqz/tQeHDin7ESEEvCGoDWe1NnFVvqlngGdTTwkjffFuWy95DcJo06WjkEDEVUi6Q6c3P8tfXRIChlgu71f2TkwU6CPAtcNuCrvhqI3NUAsOP1vPBHf1cpuJULjM+MZ0grY0FaOD1P8OeKdmsar1QWSc07E1lctfCjiKOM68dsyNpOBJkFUg6Pmh2QMH/7gsRT+0ICoI5g7xmZ7lgT2uH+jyUz+2AeD7uNB1P3le8Pv814PiDeA10V3AT8htZtdXfkDpE5ewqZSz6Dmwb5O5C/7RmnFn8HXpUciBBouWMKz7tzKxY1EsbDe+jYhWVV0rD7GHU7vB7k6o37X+/yrL4VmsG/x0KAMC/Bpvv9cNf6G0tMHd+27hs5QRixPaoZIFxizYz4pJdyyOTg0yQJw9q16rz3reDWru9i3CC8uDUEhfzACLyvk8vI6JTsLdY5iZmxS1owOR9855IlBP/JfelHO7LYxFKPDBuIC7vQ1B78HDl9u0fgiNvQwGjAOq3G4TPxaadh3RNMmhZxCtfuPHML4i8jvIWvLxF/cdBqRKEWu21ihxD3QT6S3jdiboNwa8Mrerd/NHU0v3z6rDXRFBOwjJKxXRtNLrR2cf2nYkJ+LhpImHyGSSLqzd42Us4XurIKd8WuRZH66qD/nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(366004)(39830400003)(396003)(451199015)(36756003)(41300700001)(86362001)(5660300002)(8936002)(4326008)(2906002)(44832011)(38100700002)(6486002)(478600001)(6916009)(8676002)(186003)(6512007)(6506007)(316002)(66556008)(66946007)(2616005)(54906003)(6666004)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ua4h6AN5PFb1YlXKCluJKW9icJoW7nvrzqe0mxEOVAit9KRmNWxJkAKd3gXi?=
 =?us-ascii?Q?DqGT4ulKFUE3xWRHF6nBvRZjSH7vXHXEmtmK7p4At7NVbjFIxXC/ZHmxd4NL?=
 =?us-ascii?Q?XwKODs60kv5fhwJzDLTwqw8nKt550gJfF+yznllDdPo7jYbd5pjCj3YGcg0T?=
 =?us-ascii?Q?bQJPQd8Q1fXxs4z8ym5cWcOtd+eBek5ELq5TtIUBEr2AIDjAvn6ITW3vICpK?=
 =?us-ascii?Q?CpFdWqEESBEYI0qlA0azG6wld02SzRmIXwZOEbfVWcQ/c+MlEcxX0ESUyNut?=
 =?us-ascii?Q?zvHb6ytnpkwt/bWoA/kkTYRTKk6H55kNy9e6CqRMnXdo9qVovoZgHYogXwoZ?=
 =?us-ascii?Q?j9+Fhuu1+RVSzcEotAiS+0dnEGL3As9wLYMcklHQU0oJzi2ch6pbskYwZgpP?=
 =?us-ascii?Q?/xJGKPmiOaVY+A2oqinWOwElE/Zl+fYrhzM2HWwbmRhs5g7YPy6Kw6hbmFQ6?=
 =?us-ascii?Q?zEbJWJ5/Fl6NLJhBu2AsW1O+9JaY9vP+AwAtXW03VpRujQnwT82JQdOG+sDz?=
 =?us-ascii?Q?jrHCnm+19GoWg17BTJJx0NIDa01YY+z/iiXUW64JqFZ/gqDXvomVo0EKrFdR?=
 =?us-ascii?Q?ipAWZ0Z43TZun9EoFrErFNqFXKSKq5A+bZPSi1aybfw3qRlyRjTmW2TH48M3?=
 =?us-ascii?Q?zGYua1hUKmAjvXV+rvPWzCsCi3aGVURRw5tfkbAFdEqH75PgG+N5FHzAcWH0?=
 =?us-ascii?Q?IaprNBs1+wOw4dSYZGn+0Uygnusxqa3ig5fVu6GWZT+TVHCtAnHaiMZ84Xgu?=
 =?us-ascii?Q?xr+yNoX81+8Ws7WHIWOkz9GRsO9Pm7omEl4Zfae/M5kNziRiVW+9eb0HHc8I?=
 =?us-ascii?Q?2OoasEp8ZW5GfdmSo2N1wz7VwjjfGhZm+ObgCkRkOuRQuYhe/5K/aw2I2Zxb?=
 =?us-ascii?Q?nS4HVNBxPflIXoCMeegdArPEnyWabDOvK7lf4OIteSzJvY8ymTjWMEKXbqHs?=
 =?us-ascii?Q?3AzuQkzn/KcmoHIgSYJmb5T82CBku9e6Y34Kq/v3fhB8w68ZPTuXU31HGBDf?=
 =?us-ascii?Q?sKflO+ld193FOkhXdm1eMSyzF5CUx+2amUCXq2xgSMEgfgPB/U3ezsVXtLE/?=
 =?us-ascii?Q?G+t2HDk1+OBcWL8RG7ErV9Vr6GZ9hEioNyms6xm9iF1OAg96JlgUdsKwv5Ce?=
 =?us-ascii?Q?DTXgg2eV1F+1eIY0i8htPUFy/R5FRRP8/JYNGOerkkqZfmlt9anasRjVKJiM?=
 =?us-ascii?Q?ROcdgx0qD6vmkuFwnb/NeO5G7NRVA9f2sjJI5YOn0Cr+iegYJAN1SuVvYl1g?=
 =?us-ascii?Q?cYBLKVditvEoqR9WNd1nSXYn9FyV0+rLILR2IfNsWLifFHsQuxnze0bHCamB?=
 =?us-ascii?Q?B73UrD9fKS9stZykKsnN97rq3nh3Jk+wVsGi3Uduu5uybYTUx3sSNFK961UZ?=
 =?us-ascii?Q?f2bKeltfKVP/W5tEF8JalDUNB+wn5cwtYktm+u92P5T4kzFbIM+Odg5hmOlJ?=
 =?us-ascii?Q?HQAYlCyaBgmS3R4SqIYrDvHmrcvCa0BI+5yH/m3lKrNDDjv4Lm+PfMnkOteZ?=
 =?us-ascii?Q?Y3Dw73fBL+3XLbJDmGvdAw/brgCIqw91XA9WB8KCaV4WL7Ha8ucBwqjzo4il?=
 =?us-ascii?Q?EI4emU+eh0LE8/dcJJhWVlxqQMFF4NWABFLu5P70ajT9RfMQutqZptlSpaaJ?=
 =?us-ascii?Q?7BjFA0v6484JeYOb+pDBNYMBgDMj0ZDhMPomi3bUSKZwDn5rsWiDZH7QLt0i?=
 =?us-ascii?Q?nm0wgQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86ebe6fc-1594-42b1-fbba-08dafd3f8804
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 12:44:13.5171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PPtWODE3kHeoT/b2//jEZBqfEcEZXbZcNKMGCwzzfnUuEFnSFPz9Bw9JBsHrf5LKvsQ8eS32t4nW/IbjhTyS9mV9SUGHK0woMq59vxx4FiU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4129
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 01:24:11PM +0200, Vladimir Oltean wrote:
> On Sun, Jan 22, 2023 at 05:29:33PM +0100, Simon Horman wrote:
> > > +#define ENETC_PMAC_OFFSET	0x1000
> > > +
> > >  #define ENETC_PM0_CMD_CFG	0x8008
> > >  #define ENETC_PM1_CMD_CFG	0x9008
> > >  #define ENETC_PM0_TX_EN		BIT(0)
> > > @@ -280,57 +282,57 @@ enum enetc_bdr_type {TX, RX};
> > >  /* Port MAC counters: Port MAC 0 corresponds to the eMAC and
> > >   * Port MAC 1 to the pMAC.
> > >   */
> > > -#define ENETC_PM_REOCT(mac)	(0x8100 + 0x1000 * (mac))
> > > -#define ENETC_PM_RALN(mac)	(0x8110 + 0x1000 * (mac))
> > 
> > ...
> > 
> > > +#define ENETC_PM_REOCT(mac)	(0x8100 + ENETC_PMAC_OFFSET * (mac))
> > > +#define ENETC_PM_RALN(mac)	(0x8110 + ENETC_PMAC_OFFSET * (mac))
> > 
> > I'm not sure if it is an improvement, but did you consider something
> > like this? *completely untested*
> > 
> > #define ENETC_PM(mac, reg)	((reg) + ENETC_PMAC_OFFSET * (mac))
> > #define ENETC_PM_REOCT(mac)	ENETC_PM(mac, 0x8100)
> > #define ENETC_PM_RALN(mac)	ENETC_PM(mac, 0x8110)
> 
> Hmm, I appreciate you looking at the patch, but in the end, I just
> consider your proposed alternative to be a variation on the same theme,
> and not necessarily a better way of expressing the definitions.
> This means I wouldn't consider resending the patch set just to make this
> change.

Thanks for considering my idea. I've no objections to you not acting on it.
