Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485E46A187B
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 10:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjBXJHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 04:07:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjBXJHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 04:07:36 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2102.outbound.protection.outlook.com [40.107.96.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B4F1499F;
        Fri, 24 Feb 2023 01:07:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SU+Bz1dSi+AfhNnaXaaWQfCiiLjBCvLawBmNfoYE+IGbIPc9zCeOp+A+0FEqB90p8DxcCynPY00svPyFZdoOo/T2DysPIFjvZdlh5L+hMb6z9FCgRbXsvf7miYRUdCwcNiqtKn1doI5+Uzgl4/1Je9qi0AKATFGqZDPDUxp0Cdw2/2ERDl+DM2Bo1NtpS/3rCph1MZq2cNO+QLbyWG9wzUxQMcJnOJJ44UsQrQCTb4k5IBZgIq77K5rYoiBl9j6NPdYo/Rf9SqapUBUo1MIR0iAdON1jw3yxaJz4Z4u1FSpPmNZ7woUPgnxzataCaZkso+WYwqzH3tB8uejCk9d0jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6yqcFNEPFeY5nqxDCvwNkFK7ESiXQ3ahFty2grtiU/0=;
 b=chNA+SmVZXNHx0keOMLoRKNVNFoQIPOHFqkNmi9JxfEIAtFsnDasbpPLfKr83Fk5G+PHC+murTdspt9TDs3nFQtN8SvAXE/9fd6B4qEGMTefpnhXLSFv+SF4KfpFGn06iPUoFtVTUwkbIACWzLyxNW4s0FhY6KVc2qd/J+B7wszuzm33m5MYyx2kY/EKBNh/ecx0v2vQ0PC22RozTC9CAp97NUs1A5/XPtzzf7kyhdTV1K2IwNNZUUIsoAH8Sdr0TZESgpzNvtwOv5RUY7WZAoeXWpfFVxoyCWxK1VWeqHdW/LSophhHbXyFLG/fW3xn2uv4N1ZHGn5Ep/W7Kor6oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6yqcFNEPFeY5nqxDCvwNkFK7ESiXQ3ahFty2grtiU/0=;
 b=P9TuUMKPNpdvfYvGsMTVmcbtJjtvEDXooAJT5NP+kEDCccQs21xjbH7ssbCMCLRPvz9+THoQnNktMMMiu5xHekshYI7XwUQ2XlBkIFvmc7in4OB9aoRHdI7+XUFa3Y0NDWEED+6h6bFaksK7BvLCYq6ov6laBr6Sx0W4zTWvOTY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3717.namprd13.prod.outlook.com (2603:10b6:610:9d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Fri, 24 Feb
 2023 09:07:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.024; Fri, 24 Feb 2023
 09:07:31 +0000
Date:   Fri, 24 Feb 2023 10:07:24 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sai Krishna Gajula <saikrishnag@marvell.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Suman Ghosh <sumang@marvell.com>
Subject: Re: [net PATCH v2] octeontx2-af: Unlock contexts in the queue
 context cache in case of fault detection
Message-ID: <Y/h+TH9WTWOVaSHj@corigine.com>
References: <20230223110125.2172509-1-saikrishnag@marvell.com>
 <Y/dnNRD4Gpl0n2GQ@corigine.com>
 <BY3PR18MB470774ABED5E4E22DAA4535EA0A89@BY3PR18MB4707.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BY3PR18MB470774ABED5E4E22DAA4535EA0A89@BY3PR18MB4707.namprd18.prod.outlook.com>
X-ClientProxiedBy: AM0PR04CA0002.eurprd04.prod.outlook.com
 (2603:10a6:208:122::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3717:EE_
X-MS-Office365-Filtering-Correlation-Id: 507b284d-5af1-4b27-64bb-08db16468f18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: byRa6iV/5R39QzEa6fyTHrWuA9XUcOKKAlMVHtD/Z+d22MgHAvYXenYoGBpxVV48txVbx4C00o7sCYbo1s1I2G/qjMU8YX7Tp3kCqhtn5j8sNbLFdNK7uPFjbnFv8vxq/b6ytWVwMuHGaNjCug0ii6ZNH3EV5pzMAhKbZ/qaoXhKAZepsq4K9+uZP5pt5CmGCYyo1+4TwR/KkNmw8Mbza57VxXMqHYC7Y7pSBJAz5KrSTiwkv9U7oB1uxGgFTZ1OTacfpJ5AJp5n/H+1dRjaydD7dmk2ku36dkw/E5uQgkWFninUUKQympliaAeboXO78F7CoaFiKifmBqjJpf5GsA9JcMUPf2SUZZYi55xY7D9QvP1Q45K4lWYK728ZESH+kVjcAMOblL/RdPZSIF+eiSVDcfc5elDfv98WIV5+wwq9+L6igDJcP5yJIH6lRxe1Y9UpNcc/kAsZQSfDgXgsHzPFf+We5/oSaH6ejQWacm+dX27YllGqcKYEZrlCpXnZJDxJ3CMJvFRDc07IKPmq0o0BumlASpfx3hMd1o/NY5or3lX63HkE2CdR/8U22F4HRwmb1LJSSw04ROQW2QTUarS9q8dmIXacJivubgSPc31ZQHzdu9r01qeoy2Wb92Y8RLbUvWQkdgYcBE0L4bAXd8PZtoj3+4ZPYjv1MdwqgbSkrBz1Lo9ROKbe/zIWLKYP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(376002)(396003)(39840400004)(346002)(451199018)(2906002)(36756003)(38100700002)(316002)(54906003)(8676002)(6916009)(66556008)(4326008)(66946007)(66476007)(83380400001)(6666004)(6512007)(6506007)(53546011)(186003)(2616005)(478600001)(86362001)(6486002)(5660300002)(44832011)(8936002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4Ey7Kddp6tSESfr7NxPawKSYDJoosOcCoBcJKa3GGpcFfkc2M7jiOuAom0+C?=
 =?us-ascii?Q?hDVdMgHN7aNZwqzefoYrx5AuhVwjOAXFAmzfK4GdT5gogjD7gIYUzjjw9+4m?=
 =?us-ascii?Q?+35LSKcO+iN24m79GHrVTE1psq9Oi3MPCmWCrUSE2TDo60vfNqKU+nfG47Kx?=
 =?us-ascii?Q?RlmxoUEyLZR7RjNuVsc3IuVbrbNw5P/o6LtRFKDWJsGH4tRUsFbJDHG653UY?=
 =?us-ascii?Q?OxWSTb2QPNTYBQ5NK1bMIEkhHLLBCVieqgl0YqA2yd7PRELTABtq6S7/4Z6D?=
 =?us-ascii?Q?ShW9ay/7NHnyj5M+qUu3JL9yLSAmDKCYDmP3lo+y3Om/E0ZexklNGBpE5t95?=
 =?us-ascii?Q?5MXXiCOKKacgiCqqDn/5ydBng5+RXrjqD82wepXR6o4aY5RP+U6ZSXXqGoLZ?=
 =?us-ascii?Q?JtyRtaSpcM5wnbOYXM23cbn7z+7RlmXiz9I/DyXgxTL1xKxINBG2GPLUwutY?=
 =?us-ascii?Q?hyTMaHkUtqTFL4K1IN22FCXXuvtXjp3cddg64b8EkfOI+9Q0xKz29tCQ3ULk?=
 =?us-ascii?Q?4FjkLPq9xzLGSQn6rodOGu8bDr0vqyCeRQQYLRTAs7R2j21NTPMgm1DZ3tLZ?=
 =?us-ascii?Q?psMYV1TrDfflds2mOiY6lbqpgris8JdTv32U1g52Ig8dRXlyIzMHivupIQyw?=
 =?us-ascii?Q?OTnJ9YvFzVk2xKrybCgv5JIakoLGaNG/VRO7KbYZIsP33U6Muhil5KKc5M2T?=
 =?us-ascii?Q?twJpiFCLpwU5jo6Tu4aGP99afYWD0+9fA7ZfuX48f1XzFB0kIHiOWuQEMbvD?=
 =?us-ascii?Q?Y+sqAr1KALc8J3qw5mgldKhTDwkGgzW7MEvuqvi1+LWuD94RhW05c9o9l8UD?=
 =?us-ascii?Q?6qiOvaEOZ73WkPSMRFT2BSksnpPuFg3bM96vy9IgGNZRV++QDgLY1tC395jj?=
 =?us-ascii?Q?4OB2QG9aCBbvMNmM802WcYIVolygLmgLn2ua/64VOoXwiwLGLIvieQ3wsX5o?=
 =?us-ascii?Q?xZjDjQC4bNjNrJ42HIHZRjWocUb9V969MoilAfqoT7tC/HVCVFc1Lu2zqs3Z?=
 =?us-ascii?Q?G4RMAEMSNXYqa8HxndC2kRCOb/QpX87txmdxq4qFIFCo6BXXzv0GtNukO1Lx?=
 =?us-ascii?Q?tWZQbpreX9X4XrfGxQ6v3/LMAZNG49yIJFAKOynqey+LszWewxHgPm/EI1PC?=
 =?us-ascii?Q?dyPBhBxptAfbqJcWa/JrQOYSYHFYIJaJ3Jy0TU+wOEJsyySF/dLcwwFlaERU?=
 =?us-ascii?Q?jmzE9aEhufM4wUCu7aHv1A97OrFwckUpbt2dxsZizIcPfcHaLmqqhnJyU1l3?=
 =?us-ascii?Q?E5C3XX+s/Gvv9GRd7PQuUQoCkDEx5YL9usBIZ5FgW/fUx7Pt0mIJLjDH0XIB?=
 =?us-ascii?Q?tQ8RS8vpNOpoF5DMnGCoDYrYamOtv2mZs6pBzsHJA07u0CHNGn8OCaM4HuAn?=
 =?us-ascii?Q?06iRYGc2tXxoy+Kerr/Oi0X9klc/W9C5qaQGcMBR/AkT3TEPcepVZbyM5jZi?=
 =?us-ascii?Q?0ecW/8vzeBob7v5oDE8Q63acAmaeArvr3IX4RozWB9bx+MmZSMEj6J2hqhk4?=
 =?us-ascii?Q?JaU8U/Ndk3wOfNl4LUOaB0eIT3kvkllugYcXOpMGwfCHuc7pFOaNwVrsVJiM?=
 =?us-ascii?Q?251np4G1Uu36YSnIl3kdJNeKXlEhwREKAtmhWM++XDeTiO285GSEWzIo2E+K?=
 =?us-ascii?Q?wS0R3/niT9Wm0aMpMed86lBsLsX4EKJ7FABW7HVzYLRA/yDPIWo4OpibdpvF?=
 =?us-ascii?Q?G0/A7A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 507b284d-5af1-4b27-64bb-08db16468f18
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 09:07:30.9194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KBSya8vgZ2147TY4lCuN/PHmalNYSUKj+MXsSsmWmNU8ZhoOWIT+CSyJms35RlbuxTUygbNyc+Mz/BsoEjm8DcMQ6chiv9L/chq28tmYO08=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3717
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 08:39:20AM +0000, Sai Krishna Gajula wrote:
> Hi Simon,
> 
> > -----Original Message-----
> > From: Simon Horman <simon.horman@corigine.com>
> > Sent: Thursday, February 23, 2023 6:47 PM
> > To: Sai Krishna Gajula <saikrishnag@marvell.com>
> > Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> > pabeni@redhat.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> > Sunil Kovvuri Goutham <sgoutham@marvell.com>; Suman Ghosh
> > <sumang@marvell.com>
> > Subject: Re: [net PATCH v2] octeontx2-af: Unlock contexts in the queue
> > context cache in case of fault detection
> > 
> > 
> > ----------------------------------------------------------------------
> > On Thu, Feb 23, 2023 at 04:31:25PM +0530, Sai Krishna wrote:
> > > From: Suman Ghosh <sumang@marvell.com>
> > >
> > > NDC caches contexts of frequently used queue's (Rx and Tx queues)
> > > contexts. Due to a HW errata when NDC detects fault/poision while
> > > accessing contexts it could go into an illegal state where a cache
> > > line could get locked forever. To makesure all cache lines in NDC are
> > > available for optimum performance upon fault/lockerror/posion errors
> > > scan through all cache lines in NDC and clear the lock bit.
> > >
> > > Fixes: 4a3581cd5995 ("octeontx2-af: NPA AQ instruction enqueue
> > > support")
> > > Signed-off-by: Suman Ghosh <sumang@marvell.com>
> > > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> > > Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
> > 
> > ...
> > 
> > > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> > > b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> > > index 389663a13d1d..6508f25b2b37 100644
> > > --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> > > +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
> > > @@ -884,6 +884,12 @@ int rvu_cpt_lf_teardown(struct rvu *rvu, u16
> > > pcifunc, int blkaddr, int lf,  int rvu_cpt_ctx_flush(struct rvu *rvu,
> > > u16 pcifunc);  int rvu_cpt_init(struct rvu *rvu);
> > >
> > > +/* NDC APIs */
> > > +#define NDC_MAX_BANK(rvu, blk_addr) (rvu_read64(rvu, \
> > > +					blk_addr, NDC_AF_CONST) & 0xFF)
> > > +#define NDC_MAX_LINE_PER_BANK(rvu, blk_addr) ((rvu_read64(rvu, \
> > > +					blk_addr, NDC_AF_CONST) &
> > 0xFFFF0000) >> 16)
> > 
> > Perhaps not appropriate to include as part of a fix, as NDC_MAX_BANK is
> > being moved from elsewhere, but I wonder if this might be more cleanly
> > implemented using FIELD_GET().
> 
> We will modify and send a separate patch for all the possible macros that can be replaced by FIELD_GET(). 

Thanks, much appreciated.

> > ...
> > 
> > > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> > > b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> > > index 1729b22580ce..bc6ca5ccc1ff 100644
> > > --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> > > +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
> > > @@ -694,6 +694,7 @@
> > >  #define NDC_AF_INTR_ENA_W1S		(0x00068)
> > >  #define NDC_AF_INTR_ENA_W1C		(0x00070)
> > >  #define NDC_AF_ACTIVE_PC		(0x00078)
> > > +#define NDC_AF_CAMS_RD_INTERVAL		(0x00080)
> > >  #define NDC_AF_BP_TEST_ENABLE		(0x001F8)
> > >  #define NDC_AF_BP_TEST(a)		(0x00200 | (a) << 3)
> > >  #define NDC_AF_BLK_RST			(0x002F0)
> > > @@ -709,6 +710,8 @@
> > >  		(0x00F00 | (a) << 5 | (b) << 4)
> > >  #define NDC_AF_BANKX_HIT_PC(a)		(0x01000 | (a) << 3)
> > >  #define NDC_AF_BANKX_MISS_PC(a)		(0x01100 | (a) << 3)
> > > +#define NDC_AF_BANKX_LINEX_METADATA(a, b) \
> > > +		(0x10000 | (a) << 3 | (b) << 3)
> > 
> > It looks a little odd that both a and b are shifted by 3 bits.
> > If it's intended then perhaps it would be clearer to write this as:
> > 
> > #define NDC_AF_BANKX_LINEX_METADATA(a, b) \
> > 		(0x10000 | ((a) | (b)) << 3)
> 
> will send v3 patch.

Likewise, thanks.
