Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6DC515FA7
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 19:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243934AbiD3RvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 13:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiD3RvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 13:51:09 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2095.outbound.protection.outlook.com [40.107.93.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C0E719EF;
        Sat, 30 Apr 2022 10:47:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hRQHS7GWz5gT5oB7ZipMLn4tmTI225gu+UZVfpNwJJlXbnXBLReiRt+fij5gIxTPOuR9xERnSVX1//jnAfVCSstZEO4vnM6BbJj6aiG6y40rAuubBReMhcqAVR4GfHP8/wXgGPOeEC53oHRGyfEpsND8p1lKd5nVnDIoNYC1Gzst5WdI88MwBUVPhDIVFKSJvNG9IhxNBAK1gzrXsazcjwfe7ja2FO98xEMK8lAQGZfWBP2YNAKyS2TiQe8sI75f/Vyt2377oQtaXqD1q80CqO0ScZvUWPoII9vUcij+97hcb7vNFsWoCjkzuaaAfuyf0lCG7JzqPKDBsOw+AyNfdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4NiXWoArPHIZJfCxwG1k3MfZvmoFAW8TR0HfIT1mSSo=;
 b=KeCFrRLXdCBiw70r153L+Z8U83Awtsz+d5W2xiV+qgoOwxa2fVsccP9pAlcWV7yOfol4/OAWXop+1OH0oTpIh8oT+mQLJCvzsnJmzRuRXHzO7X+mJqi3pXut+4kdKlJQoSzgIAQ3O94HSsQhT07VGX1MR/Gx/MOkNBFF1ERpWjvBVM/ENjUcOxQfCHmVLzuHxfDBjTp1vue3BhafmpIy8lxVxodo/YOEb2L5EvU5YBYRVza1hI6EJ9lgMeMVa0vX7n8lb5jOynB6OULjJmCIU29UElrVAoC5KXJic4jcVoPou6wk+9FmC2CeX7RFfs59qqmdbzMgj3vMM9/e1Ydmhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4NiXWoArPHIZJfCxwG1k3MfZvmoFAW8TR0HfIT1mSSo=;
 b=Aa9svFi6jyuZ+DVAfcQyS68ff4CIbwSVjNIxl6+gjLPNIINodV1kjPZ1qEDuMZ/1QoD6tKROm+RuEtBUkAJ6zXkGlIQr2jaHMUKxuj4vVxcWKxAf1leJD6T+q6h+/TCY3uJZFMinDTW3m5NflklpU0iH7D9Vf0f5zYabh9uA+Fc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BYAPR10MB3526.namprd10.prod.outlook.com
 (2603:10b6:a03:11c::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Sat, 30 Apr
 2022 17:47:39 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::4581:787c:1a7a:873e%3]) with mapi id 15.20.5186.028; Sat, 30 Apr 2022
 17:47:39 +0000
Date:   Sat, 30 Apr 2022 10:47:35 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        aolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v1 net-next 1/1] net: ethernet: ocelot: remove the need
 for num_stats initializer
Message-ID: <20220430174735.GD3846867@euler>
References: <20220429213036.3482333-1-colin.foster@in-advantage.com>
 <20220429213036.3482333-2-colin.foster@in-advantage.com>
 <20220430151530.zaf7hyagln5jqjyi@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220430151530.zaf7hyagln5jqjyi@skbuf>
X-ClientProxiedBy: BYAPR06CA0012.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7194feff-85ae-46dc-96b5-08da2ad184ea
X-MS-TrafficTypeDiagnostic: BYAPR10MB3526:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB3526E9C2214F642CD64D311AA4FF9@BYAPR10MB3526.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: njgCteH7/rgqQUuSb8/tfZmJr8PHkndpZZkW9rU97gma7Lql/yaL8J1JdyQHfVttvamONprD7pKlOPiUSmab8D1D+qSqNGH5aqrzukSUpfiaZ9NfxRXcAjs1uQcvWqJITP67E1p6NDQuIid3pEeNIsr+AkK7lBL+1x9zexcYOKqCC95GZ01iYR64oA37gyytjTQICX6FZimExBGLz8ais4nZNB+64S3w6UY4W+3IR6X1GDBQF7dO+U8bDEXzV8sAAGuXsNF098prEykNwT7w0BqpmSEvFeJnjjes5Jo8NWeOg7YH/XAQB5PONC9O5LlvvKqlM346lsYosFiso+XozDuv331hpt0151HKB72mCyu7hlw/5qIpNMBjrDyhCVD+j6v3nunSUkDA1fBBOkFm3z8N+pQJ15fzMnPPhSoslPaLE4XHV2RxI0UMXZpcL1/hs742/5YHkPWj2EcQoTRf2pTtHyvVMO9coDr+jwFtH4zzA9d0CtH+UoZfd4TxZ5HsWCAdQ83P3ZO7V6NKiaAzoJ01h7PFjkwPWtIiDaGBFTuLe2xr0MkLt49E3oPuS/idXfpKHX7lbYIJGe12BverzdTWKMYp+lQg95Ao/yp1OkC7vINj1LD2yFH6x4fQrt+IArK7ykQUUxiOdLuB6/DCeN7kvFiF7+BO2xzbQWw3PeHB0T0QznsZ+USc0tXjSCGl2DAGI9b1BhuirJNHBK7DLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(346002)(39830400003)(136003)(396003)(376002)(86362001)(6486002)(508600001)(9686003)(6512007)(26005)(1076003)(6506007)(52116002)(38350700002)(38100700002)(6666004)(66476007)(316002)(2906002)(186003)(66946007)(33716001)(66556008)(7416002)(33656002)(44832011)(5660300002)(8936002)(54906003)(4326008)(6916009)(83380400001)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pRONsMIQX3Imgxqce7zQWnu+UA8p0Qi+xXNUxZDChrSlvTBpmM6oHBuljEi6?=
 =?us-ascii?Q?HZVxR9iP3VelTDhw5JL+TS7PjbErNErmxDgQbR3Mz+KjB+pM+OoquB/+Bn5Y?=
 =?us-ascii?Q?0A9Ugt/EI8DYr169VBeR43eA33KMrBlqM65zi5TPlfNGpNsULwPT3zFlr3FK?=
 =?us-ascii?Q?n5AVVcMkSg1vWw8TlkFEa5SQ8gLgibLOsejb8IuoWdTFqgMeknJdoyFvgf94?=
 =?us-ascii?Q?ChK2Lvrq8gO1p44IzgqiD4xVLzuT9P/aPsdHNJJhTSscTxp8HOOTMzyxGqW2?=
 =?us-ascii?Q?250hwhbMH54dLsfIUAOxbEExWSeDHdmsntbzDHKXkbxlCkBYnIvrAfkkMFMl?=
 =?us-ascii?Q?i4yxqX7b0nNpKg6SjzGDJLE2Ss+FUAfbD7VNjXrr2bFsn5Y2o+vR1lVhXxBC?=
 =?us-ascii?Q?HyZm8tUyeRJMpzSSaAVNyBSBTP2bv/+CG7bwgME+l9X9qAsZJhWb1wZilrKy?=
 =?us-ascii?Q?MQ4lCuvO4SS+LXyVAFvjxfu1SGqTxZp6lU6Tl3lBIjQWRsxionWDMS7oazA6?=
 =?us-ascii?Q?g0FOHhewcGoesEIAu6XQSSRCPUAyYwMT4PQz0A42lcIfeGWxgUTeNYGZEx2n?=
 =?us-ascii?Q?wCafaSnsYMFDqNlvJtoQ+t7t4QtfMvlGBr2xWsiNParAK+W5Z0mMY+5urpEc?=
 =?us-ascii?Q?dDAHD3vD+Y2uTIiRIw4juSqy2S0YIaYJ3hwAX1so4g3pQmhWrlL/jQlNvdv6?=
 =?us-ascii?Q?zPZpE6U+/uep2pNgFXY9B0jye9KCF3McEhyhNaYCJWFuORy/B9EiZMCmHHZl?=
 =?us-ascii?Q?tQQeZvMHSuBy9WKs2HS38Dn+1tsNtCPywhS3BQE2FqFdJ1J/+J1H+PRCBEZC?=
 =?us-ascii?Q?FwWXYy9u26tPSqAfV2iTLe05mdUzxgjyqp45thy38MZXeoKQHIlmKamZcjUQ?=
 =?us-ascii?Q?BAOCvHMlwT1slSjrF/yMgwjOj1ulsgaLhq2MGzJ8dAjYDqkh8jMmLfvMsjEC?=
 =?us-ascii?Q?cRPgOJwYZUFYEGy/aCkcpq0HXYsrv2h4DJEF946LjaA/xypNlkT++f1aWnM5?=
 =?us-ascii?Q?gOjDUoETOSRtkOxjfil+Nd41fi7MCTeuof7y0onVqQtWDUZSHrM5iWVQCZ0Z?=
 =?us-ascii?Q?AJi1Q9phs/1EE7t6DN5ZLVAmmAL8R+4hv9os6qikztC3dwWzfD2o0w1T6STH?=
 =?us-ascii?Q?2yPWvIifo0QO1Xjm6AvzZUBu+JX98jwDD2OBlcQhD/1gWHhpdkGJzR1XtVYK?=
 =?us-ascii?Q?dTa6SfPjkMuLFwAuiB8VN5o+FtNsYi37XN6Ttu8swGN8hb/MZfODCpQyYrQ6?=
 =?us-ascii?Q?dwACCBSuw21ZvE1CjXnuKnT6Bq5kdeucJL6sraPLg93RzgEEAKV/ihFsemon?=
 =?us-ascii?Q?JxptQhL2+EN8ofTUT3JCMpJDpYkWJhWbwziu+zc3JAaiUMnEjQorABb5PYyO?=
 =?us-ascii?Q?5QVjFJ0dQfQbrG1IzCn18qwfl6X3O63O8NtxC3EVWyXO3N35stb3xAlYkx2J?=
 =?us-ascii?Q?XxODgF32/NLpLQV4/bCFe7p6sctzZX7DxLoKbp4dkKIyfWRXe4/LVG6R4N6G?=
 =?us-ascii?Q?mpX15/bqAmwiYuWKUDQiqCC4CEoqUIGpp6Cb/HHW6E1nLPhYEysrsV53w6gQ?=
 =?us-ascii?Q?7v2/3KfSFbQqyexRd4rKf53p1iydEg4m1uJoS+HX6/1t12ZbiZbGIXXuSGfi?=
 =?us-ascii?Q?+ttCXa6AsochvMlg4eA/VYODStF7vVy3pmx7phXvy3zjJavCBVeqCG7I/KAQ?=
 =?us-ascii?Q?6tUa9hi6RTVBZehRH2HmcpMULrTmcfSbg1StaInWVW7f5Y5vyIb0sSxwzdqK?=
 =?us-ascii?Q?IpMsM33ksSPDDXWhWUNRjYgNUYLemfMj3uiOTEqPVGU7JSoEHMBr?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7194feff-85ae-46dc-96b5-08da2ad184ea
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2022 17:47:39.4406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eqHCaOYKIDb7iRtLFv1VItC0Rw/I2hCbYyl5YVmnzFiG2NNHPhR/AApW33pqxV7ypyXyYXCxpBoN5uKjupq03tfsyZ4AcBtb21d04up1JKg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3526
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Sat, Apr 30, 2022 at 03:15:31PM +0000, Vladimir Oltean wrote:
> On Fri, Apr 29, 2022 at 02:30:36PM -0700, Colin Foster wrote:
> > There is a desire to share the oclot_stats_layout struct outside of the
> > current vsc7514 driver. In order to do so, the length of the array needs to
> > be known at compile time, and defined in the struct ocelot and struct
> > felix_info.
> > 
> > Since the array is defined in a .c file and would be declared in the header
> > file via:
> > extern struct ocelot_stat_layout[];
> > the size of the array will not be known at compile time to outside modules.
> > 
> > To fix this, remove the need for defining the number of stats at compile
> > time and allow this number to be determined at initialization.
> > 
> > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > ---
> > diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> > index 9b4e6c78d0f4..5c4f57cfa785 100644
> > --- a/include/soc/mscc/ocelot.h
> > +++ b/include/soc/mscc/ocelot.h
> > @@ -105,6 +105,13 @@
> >  #define REG_RESERVED_ADDR		0xffffffff
> >  #define REG_RESERVED(reg)		REG(reg, REG_RESERVED_ADDR)
> >  
> > +#define OCELOT_STAT_FLAG_END		BIT(0)
> > +
> > +#define for_each_stat(ocelot, stat)				\
> > +	for ((stat) = ocelot->stats_layout;			\
> > +	     !((stat)->flags & OCELOT_STAT_FLAG_END);		\
> > +	     (stat)++)
> > +
> >  enum ocelot_target {
> >  	ANA = 1,
> >  	QS,
> > @@ -535,9 +542,12 @@ enum ocelot_ptp_pins {
> >  
> >  struct ocelot_stat_layout {
> >  	u32 offset;
> > +	u32 flags;
> 
> Was it really necessary to add an extra u32 to struct ocelot_stat_layout?
> Couldn't you check for the end of stats by looking at stat->name[0] and
> comparing against the null terminator, for an empty string?

I considered this as well. I could either have explicitly added the
flags field, as I did, or implicitly looked for .name == NULL (or
name[0] == '\0' as you suggest).

I figured it might be better to make this an explicit relationship by
way of flags - but I'm happy to change OCELOT_STAT_END and for_each_stat
to rely on .name if you prefer.

> 
> >  	char name[ETH_GSTRING_LEN];
> >  };
> >  
> > +#define OCELOT_STAT_END { .flags = OCELOT_STAT_FLAG_END }
> > +
> >  struct ocelot_stats_region {
> >  	struct list_head node;
> >  	u32 offset;
> > -- 
> > 2.25.1
> >
