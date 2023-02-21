Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7CDA69DCF2
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 10:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233314AbjBUJbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 04:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjBUJbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 04:31:10 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2119.outbound.protection.outlook.com [40.107.220.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E07F22A14;
        Tue, 21 Feb 2023 01:31:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F7dLOVUNc4LNW2ecykt2e4aUvdl0SPwr/GpxKEOJic6q6dluAXRZmGyX1PPxYa+7rSWeDYAYcumqqhdyRskp18Nu1qfo2PrtenFibidoCIyWsCp5P2KQd+FbVDzm3sH9mtV4d1D8HImbmN8S9TL445QZfaMbrrgSh1t+21dMcoHMezb/p93US08tvdiO3gVMIGlLQ7K9tBVKX6im8+SQKRFxzRUzeEQHb6Qo1k8NIqZRm59Gqfy/2MPdt5pU/0nZwbZnW3yik5ryDMw+/tV03Cfu/w9yOr3wm5NGE+TFXMLLAjdOmLF3y5gyMqWo3aG/3L977DHQn5qfLknc3WEu/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7777na7DP6C1cj+eF0GATKY7dCKFOesbug3nQ9OO4Fc=;
 b=hJTA9K9pcWh9lfJ1gmY2fQVZIdYI9oK166GodVis9pA7QAXyKY3vvORKfYE3r7CjTMPGIF7J82tojEzzNfB0HqkDJUvByj+aXM6DCXPnO2L3y27cqlGttGHBIXQ7XrOrBwOgv6OfdH0lw6Et6buncA+EM6C8/O480O/Ea5zVRZzBa8qraPdmrxLDeKtteTt+Y8pSK33Obwqcq1kW2SJWWpY1KHBhn445rBvNHbSYuRuN+rk5d5p+bVi9fExPUWBMWaI+6p12GJT7HjwdUQoDs4rJtziMQ9nx2I60AmZb1bOMwG9KVilZ19Sj1yyYTnsqUZVa/DT77bstr2IX0gZAuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7777na7DP6C1cj+eF0GATKY7dCKFOesbug3nQ9OO4Fc=;
 b=jv+q3gElcHreJOod/aVi/MOWaQmBn0lQagASVNfYxFyNUjVSnNmRpcFBPaz5nlNCdKRqNsSYtPe+9EMZCJAsvS5cybcTfBC5/YsBYjTGVRsZLafX72Cacp1AeMCcuUp91g8HM/DDMMuQ9Pf6+7HAZllHJVtVRAAAk3sm909Kdc0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4526.namprd13.prod.outlook.com (2603:10b6:5:1b9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Tue, 21 Feb
 2023 09:31:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6111.021; Tue, 21 Feb 2023
 09:31:01 +0000
Date:   Tue, 21 Feb 2023 10:30:55 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Gavin Li <gavinl@nvidia.com>,
        davem@davemloft.net, edumazet@google.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gavi@nvidia.com, roid@nvidia.com, maord@nvidia.com,
        saeedm@nvidia.com
Subject: Re: [PATCH net-next v3 2/5] vxlan: Expose helper vxlan_build_gbp_hdr
Message-ID: <Y/SPT79KUOdz7JO6@corigine.com>
References: <20230217033925.160195-1-gavinl@nvidia.com>
 <20230217033925.160195-3-gavinl@nvidia.com>
 <Y/KHWxQWqyFbmi9Y@corigine.com>
 <b0f07723-893a-5158-2a95-6570d3a0481c@nvidia.com>
 <Y/MV1JFn4NuptO9q@corigine.com>
 <c8fcebb5-4eba-71c8-e20c-cd7afd7e0d98@nvidia.com>
 <Y/NMH2QRKoUpdNef@corigine.com>
 <20230220123021.448dc1a0@kernel.org>
 <05e7f7bb8573a32d81e09fbb5744d77d01292d51.camel@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05e7f7bb8573a32d81e09fbb5744d77d01292d51.camel@redhat.com>
X-ClientProxiedBy: AS4P251CA0017.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4526:EE_
X-MS-Office365-Filtering-Correlation-Id: 318c1b9d-856f-496f-74f2-08db13ee58ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7aPkSZCR7p2Npl2YZekKrVsmSvaMBJiZxAm4P33yUhm19HnG/AkC+mWiBflCNlwzLYxdLHkMyNqFNpBLlp4k/Rji9KFtNbmh/ZDQ4LmmDfsH2geUe1mBhBR/IHlgAc2nkYNr3h3e3Pb5DUETGOIaplCgxDrZc0FiP6xx0YYLuHjiNpvEvhtvVusgQmzSRZtwO0STFuOJG3c73C81Ll84QYGahaH7hxsW6q5QpKwPRQ+YoBF7iySWfYiOfWsCUA2rRJlwogx6727Ic83Bj5eazpmCbSo8BtR5cPI5l1xvuzX+lLD2A6jlxLcSvqweu7yXPjPJu1bLIjXw2c2FMFJX7snMwkiZJjg1tXuAflFDyJe++/1rscffL0ALBHPukWUgPQwoj4cvegCbZgOfYad85V+DUSThboC1679L7EEB8S22ugiiVYm25dkM+KPYE+GxHbVA7JTy44WVSXRPNV1rgCUlVPdQrE1DvmsiRJHT8RojioJIrlM7RgFL7s+HoZ4Oz28PvWz52XUAQBlZMModlRvYxIABUknKibKkLDbncIPv7+ED0e8l6Gv1+SYE+aND30t1xi5Q90wMlvRT1ABMuQqeeNAqnmfg/E6qpc0Z0RUaHRiIsHQRzOodAUPxAyPRjimXo5+NBs2xk1TnuiZZ0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(136003)(376002)(39830400003)(396003)(451199018)(2906002)(38100700002)(6512007)(186003)(41300700001)(6666004)(44832011)(6506007)(2616005)(5660300002)(7416002)(8936002)(86362001)(316002)(6486002)(8676002)(66556008)(66476007)(66946007)(4326008)(478600001)(6916009)(54906003)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8oO+1bOQEnGQyGch7wMU2NAX7Y7Q3rw02DZzlim7dkd9hPyNjjyKXKDk/don?=
 =?us-ascii?Q?6RHpRUdj/fjjfk/l4p3xhww8OVInqZOrZ8VfaZ+Nrq/H4F2D8oa9wM8yppti?=
 =?us-ascii?Q?qk0QOtgTSPFREISIA44+AarU3pw8hYIk+T2P5t5lBrRzHwDLOycog6iXz96J?=
 =?us-ascii?Q?pCQwOsCIYO4wZvtsWg2OQeIPO5MtBaNBNs5vh3QgYKQS8PxmMqh4o9QljeN+?=
 =?us-ascii?Q?/SBIux1KxLDfMj3i2AFoSGSwlWOVSRD9zWZbJk41T5dlLjBZ0PKqSH6vsgRG?=
 =?us-ascii?Q?gh/4U7B7kDZTRqMooQMdCvdkkoi44OInQJUM4hJP1OanA61GiVGWcojAh5SG?=
 =?us-ascii?Q?83vvmbJvSOI/T3Cw4lm755FlijWrRF+dQbU/bUW2fRuGKMy6a8jyW8louVuV?=
 =?us-ascii?Q?Wgky2V0eIB96fAhOO2JvDCDG/mcUFY6a9WyYEal2Y1DB1dfr2Ukr9wCe1uly?=
 =?us-ascii?Q?XkXueDiQYEc1FeEyo+MSH4/TxWZ8dybbD1PAPc0xrEmlozKt1tmzaVV0FHlU?=
 =?us-ascii?Q?JSQkJp1uIH77fdBcyJjQgD/rV6qUth9luJuyRFOiwOBYOVhSZZrprfVUitVr?=
 =?us-ascii?Q?XuI0rTB6O28hK7Mbv6MGbg76Xau70J8BvbHvulvqgW3/fjEgefFxIKVdwboE?=
 =?us-ascii?Q?3ml94xuwV5+UM1GRlVrbyNtEIa9weUehfEpFvWgEHGabDjtS8zYWBwQaYF4x?=
 =?us-ascii?Q?CDkZ4kTHhzBi403xCS4+wpIL0aH9kru8dDzHuh84A04P6oZLpK3uUgE9ciJT?=
 =?us-ascii?Q?SPdhJlSfPsyaXHbmiGJ8zjZPmkMKDIgY14e5f7YOJASoItILXySkddkvBR6y?=
 =?us-ascii?Q?iKXu2IVnWpJFwy51RtV3Q6rowgLOX9ZSdbLXXM3f1umwLbvSP+yFpHVRMeMo?=
 =?us-ascii?Q?gfE8bNkmrvFn2XxXAKT5RmWPjLiOqa4zqrAYT9UtyYjWC06+CRDuLsf489+8?=
 =?us-ascii?Q?nUTJ7gwxS6jzOCjGy89EzgcehFDTJeBj5j75WYN2d97cXRhDQmD9Gg4KniKe?=
 =?us-ascii?Q?1uWLIZkr3fXsIXY9EEDx5zMZJx1cAkacU9ol+MDloTZmXzOcesmpsEpLSSpd?=
 =?us-ascii?Q?hy/LzjFeM2xn8hcO9z4c+TozabvyFapARUfAiUea1uwwEkW3UYfH2K5kdceQ?=
 =?us-ascii?Q?vTXby+detc15pZv+CFP5eBUGZjiNmrONeXHNUwI7H0SimslcOr/T+ko+x3Lp?=
 =?us-ascii?Q?7HMrbkDzKwp5Xispv9j8WAG0jFVh4h70RI4qIYIlNUGxGAekHkwnroTQK2r1?=
 =?us-ascii?Q?fbGj3ziYDDmPZvnvjXxLYJuGeSqe1OQNyavVfeZJYw2r2pttqbH1rTTx57dA?=
 =?us-ascii?Q?DqNpPXG+f5koXS3HgxfilchtF1TpoGieUBagkbViPc2PyOGev7pQ3/mLpEYp?=
 =?us-ascii?Q?uXv/o781ZEOaYvqJvzgOsYdwSgke0ZkuiGBebetZvj8CMht1dqQVhjDMjqfC?=
 =?us-ascii?Q?9LhNrG2cxtxtGpBs4OVB90YP4ULZxacEN7opc8GHy20cxx08+Ds+h9iMHEtt?=
 =?us-ascii?Q?0+73G4mDle8EJK6hYqepIbR1/p9KyqmBbUPcRy/4vy000WiNfzCv2Z4H4K8k?=
 =?us-ascii?Q?IOL1tBLSFx52P3dW4Yr1dET0i7WLCrAGHLJ36oFJ//8UQpKknXmv12PbO4ul?=
 =?us-ascii?Q?mdRkBEaY10WUs45ULYjGDWpp2qKtKAoR/q8ZovamStKEnhgv7ukozYL7Lesh?=
 =?us-ascii?Q?liq/Fg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 318c1b9d-856f-496f-74f2-08db13ee58ad
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 09:31:01.5663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q7+EHqJ1/0t8JWCjFOljPWL9JdsfmtfvB3OtigIwg5Y6xtLxADPeNmepxlY+bIxYfKq+uZaLHZpyy65yNbOA0yyka9onYbEPH2b4fbnU2Jc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4526
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 21, 2023 at 08:38:17AM +0100, Paolo Abeni wrote:
> On Mon, 2023-02-20 at 12:30 -0800, Jakub Kicinski wrote:
> > On Mon, 20 Feb 2023 11:31:59 +0100 Simon Horman wrote:
> > > On Mon, Feb 20, 2023 at 03:15:20PM +0800, Gavin Li wrote:
> > > > > Right. But what I was really wondering is if the definition
> > > > > of the function could stay in drivers/net/vxlan/vxlan_core.c,
> > > > > without being static. And have a declaration in include/net/vxlan.h  
> > > > 
> > > > Tried that the first time the function was called by driver code. It would
> > > > introduce dependency in linking between the driver and the kernel module.
> > > > 
> > > > Do you think it's OK to have such dependency?  
> > > 
> > > IMHO, yes. But others may feel differently.
> > > 
> > > I do wonder if any performance overhead of a non-inline function
> > > also needs to be considered.
> > 
> > Do you recall any details of why Hannes broke the dependency in the
> > first place?
> 
> IIRC it was that was a cleanup thing, so that setup not using vxlan
> does not load the module (and the related deps chain) for no reasons.
> 
> Cheers,
> 
> Paolo
> 
> > Commit b7aade15485a ("vxlan: break dependency with netdev drivers")
> > Maybe we should stick to the static inline, it doesn't look too
> > large/terrible?
> 
> IMHO static inline is good enough here.

Thanks Paolo and Jakub,

I do not recall the background to the change.
But your reasoning sounds good to me.

Let's stick with static inline.
