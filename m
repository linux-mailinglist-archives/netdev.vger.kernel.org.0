Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31FF5EF0D4
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 10:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235153AbiI2Isf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 04:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234994AbiI2Isd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 04:48:33 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2127.outbound.protection.outlook.com [40.107.244.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2CD132FC5
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 01:48:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eO7GxQlhYVHp1lH+Fmntgaje3Uv2cs5fRrzlfq8bT4akd+N/939z5AOAVhyzoSen3oSu6iE8CqciTfGD2avXels1m71lXL/vVSCawWsyWouocrY7XCiIW/U+b8VpKeYj0HaydVzmCSVNRUz60jwp0KK8AatJXCfIASrTUVFJZ0vzJokLBSj94MPsc75dxcdFxPHPnzlHM2rZOlLJiq7GfuMDNurNN6SfxY6smnRC39k+bABV1AigMSVkBZveW6qsiDuPK80BMAkGKTAmXCIbKNTrwg/uU4YaKYRtv8ngmZqRwxtNCd55TqD0FU+gyN4mtW7bDRUY27ErEPRQzZ+kdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=99oIS2y02NjR1Jk7e0PMs2vM5Hkvllo28UGfeiDWYRo=;
 b=JBeQX7PVJlg/peQGQugPmcC4EQuZ2gcPHPTAtZFP9E/sWlOw4X9LQz232JB1+Q8+nI8Wje+32Iu0W4Z8cCm21B0m9RGFC8fDH5QRqW/PSS96jLt5LLnCOm/xrRgc374F2o1pton1fqeiDZXy+d51i0QQytOFbIECo0+WA9ZuWIk3f2vB8My0pjy3kcGxYJuPmzJubYMrUSVl45uZi9JlM477+AHyUXzZIthC8no66faaNFuCS8IrZw8DZBNkrecxIpuF7rB5mrOTsVVACnX9sYNAHMTQ8mIBU0kwVYGJrYtqYcJH3SFZwqxxVuVBm/MOblpUVX+GJ1+TS+4ib2U1Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=99oIS2y02NjR1Jk7e0PMs2vM5Hkvllo28UGfeiDWYRo=;
 b=jkR91qf7dn9maw35WnYgixxwLpbpbOrLMBnaYNVoRDFv+/tSTL7f8p1B0e4ZTEnnKFP6WMy6rIcvqfHn2YEmAScY+KNRwayEUlgtTzuxsiiaLk5RnD3uMvY0RNut+FOzebNlhLWE09IIvXg65zqWMfFWc/FIxMPJcgtaT41PyM4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3646.namprd13.prod.outlook.com (2603:10b6:208:1e3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Thu, 29 Sep
 2022 08:48:29 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::2cbf:e4b1:5bbf:3e54%5]) with mapi id 15.20.5676.011; Thu, 29 Sep 2022
 08:48:29 +0000
Date:   Thu, 29 Sep 2022 10:48:23 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Leon Romanovsky <leon@kernel.org>,
        Huanhuan Wang <huanhuan.wang@corigine.com>
Subject: Re: [PATCH net-next v2 0/3] nfp: IPsec offload support
Message-ID: <YzVb1yrDZ6jjdNp0@corigine.com>
References: <20220927102707.479199-1-simon.horman@corigine.com>
 <20220928194220.2e0b72d1@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220928194220.2e0b72d1@kernel.org>
X-ClientProxiedBy: AS4P190CA0005.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3646:EE_
X-MS-Office365-Filtering-Correlation-Id: 1604c6df-23ad-42f1-71c6-08daa1f7614b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7KDOZwLjndsiRr6SXNHg9k6N+1oG17Ek8DJ/Ga+bY1JVQnM0dmvI1ZK6xwFxPbeCixZYv+k0QV5HqZW8tKB/gdYQRQUNgsYmTyzhEQsYFw4arcbTGyzy+IVdyKs3ag/4tSnzVxixiG97X9fVXGNL9dHu71ltVBBZsJ11ZAPitPP7xW4KWWhDZjlNI3fad2HZOn2zB1Mvc6+seh9DUc5hdAjiENOn4Gxaqp9NZKF+3n+7GXy2K68Q12lnpGyXD6IVerWJZS+iUbH5GOXg66+AVr1qfDmrt4/2ZUxiHWFvEZ2tYIjmxtuJbmI5m2pc0TDoac4hfLmBxw3SgacX0Hscf2GUmjC1sQRwAEN70rRBrqaNZAniyMQkTMykMstsv3HJiNrP5sP51koCnk4vtcFxC69P0Fd9CqrdH5h0UtJygp8SWmdIcYvZXn7+PiFkk6rS7iZOacOnZR9GexF/2iPDJCPsHuLPtThZyJICYhDqqHhyKFSRZJbAzupdUx6Hj8pAnaqbwbjtkvQwtK7MU1ZMI2aU+gaF/BuamNLQCzzRb3KUVXpPDFT3x3oW2vmZh0yvGK0lA4Bc0rfQ58Qac8OkxbTGxJ8jlibrZWdbLCmBOKur1ZpEy9acwLcMacE3KnWqBLFSVM4jfBacO6DPLGlwrYoopORaNOVAIqQqPXAj5Ba8SP+vjLOCeE38OYh+tTBwy6JbCFVm3hGkDjs92onVUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39840400004)(396003)(366004)(136003)(376002)(451199015)(107886003)(6666004)(4326008)(2616005)(6512007)(66556008)(66476007)(6506007)(52116002)(66946007)(316002)(8676002)(6916009)(54906003)(36756003)(6486002)(478600001)(86362001)(38100700002)(186003)(2906002)(5660300002)(41300700001)(8936002)(4744005)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DUuK7yrdzkUlz3wTnL2YFM3tO8TkmuBOLRVlbcdPYN+erA3rRnBHlNTWilKQ?=
 =?us-ascii?Q?UAV6tJKN5aWRutte8vbOvKghbCLF2ZaAg8t0ECAo4uCNZIHJfS1hrVGhSgyg?=
 =?us-ascii?Q?MgTB3Vq2FSawZf8Kpy/5I5OURxOcko4qeCg3yexA0mvF8pQ3Ib3UPzF2MBmt?=
 =?us-ascii?Q?kmllJbFFrwC6h0uLo+9BnSFxI4lmYqvPTDquvjBpiy2LkiPWiCSEzR3Zg0zV?=
 =?us-ascii?Q?k7pS+Gwqo2Kno+Y2gjlvTmKUe8MB6wCgTeuNpAOco376rflA1ljvtWlHzhB4?=
 =?us-ascii?Q?KwXxqbuGFKBrTK2yjQevX9n6q8y5vc/LcVX3tKoi4jOazqqOV7NBZbwaEJSH?=
 =?us-ascii?Q?TmwXRB5X6TXvvuUqWaKYYDsQHR432XZxZ1M1ehZ75qO5arxV/zUEzqNT1VuQ?=
 =?us-ascii?Q?FdmAXPNuu82mzmodEvzGBMqSaCfiPQYiQR6L6P2toAhMOAMvkvOJPNgJ/1p2?=
 =?us-ascii?Q?WP7KrNN/wJdP+PqCerxHAGeQoo/HMCbtNule0qWRZJUVb7lvlK/+8SKnOYNh?=
 =?us-ascii?Q?uW4LDnmfELae1J27HB0UFKmERYgR7UXo1IUqZcT6Qe5T0NY0LlVDDXxo5qmZ?=
 =?us-ascii?Q?xvyRTUqWHXZ4ea42tpwPef0Zagbl4ioTYm5uRW/1MtEuA8s0j93HY0t5hEKD?=
 =?us-ascii?Q?62ZKfIuwG/oW0YRfprjDCzi3wWvK4K99b2UTXJ/QQ6HGwaea27Jfo0asEuxV?=
 =?us-ascii?Q?sStUgjuOxrf71XN9OkkksCfiuTRuLAMTQ6wQtce+9vMRFequoiWmt4w39wor?=
 =?us-ascii?Q?MfCtM1qpPdHQsa45sQMZefOHFDj83nOZFuRi9aNByhxmSrSCIL3zNrgSuBwp?=
 =?us-ascii?Q?ltI/DSmg9KJrDDmcuG9X1l39WiKffxqBopBzRYWrG+evwasiCVWTZATzeSJY?=
 =?us-ascii?Q?bARE8ZZuXSc3k0KzBZ6CGps46qkIyU4lASP1GiQNU7D/WKdhI97daXKj+43O?=
 =?us-ascii?Q?4dl0Ouw9unuLqnpBzrPPjuC7CxOTnupGBwHU8dN2r5DJB8KD/W1d9dWcHqSL?=
 =?us-ascii?Q?LfWe06L/tQasT5ZY/H6x+QvLGeVHM4ns8pdwhnUjIE9f6/GkuXlaI2S0dC5A?=
 =?us-ascii?Q?b6vzlRYWLAUtuqUL8R/RJA3wdxpAlMXkhMH25wYTZH3EEl7EHPBa0/G9nodq?=
 =?us-ascii?Q?UpOyG5YFMtX0rv+VuppNKSjesOlpjMYw8ait/AClCxlOe+yPZghp1zPNzm1k?=
 =?us-ascii?Q?cQ/XGSa9DNw4LN2Gb1h8pHoNUdUcP70Sk7KNGGH1nGquuJ4t23XIlMaOAIBP?=
 =?us-ascii?Q?NC83ymvRD+cfU4Iho8mLbb1iE32UrMrR+IzvDPQxKtcMljb2D0OBq6pp5+np?=
 =?us-ascii?Q?e3gTQFgWKn/LiplgMDgPhUVuID7wSqoaVFdAL8EyQXRTBPyrEFIiMJyxReuW?=
 =?us-ascii?Q?Hpr9pBdUbT1MGB7M8KTmBQnFR6T2hMAh9+iqAUww1ogugcMfkBIomVB9eCSj?=
 =?us-ascii?Q?HZBTsA321zYmy+DKmjjHaWp922l2No1IakeHTqBIzJpbMAFCCuHAee726jhh?=
 =?us-ascii?Q?oCfVgSovZgQWOPPATzQsIEiAIVsFY2tIQVki35cEV/5NzBS0jGqLyzDknG/+?=
 =?us-ascii?Q?FWhBtJABA4WyD1/jbTVwNXWytZn08W8Oreea78anP5cXN9F+DJyTGGTMhXvN?=
 =?us-ascii?Q?UsK67dZzthdqm8mBEtBmStB0oobocTwy5BF/eF4TeaXS23t1OUP54xtHVf3L?=
 =?us-ascii?Q?k561+w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1604c6df-23ad-42f1-71c6-08daa1f7614b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 08:48:28.9549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HY7/tzUPOsZYvaNt7HBPWHZuAFiTKBbxDblZUO4L+6eeLycLDNd8rakKUyh40IlKreIT0AhYZGvj+98w+UsRzPCY9LkPQKAUszEZpMyWta0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3646
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 28, 2022 at 07:42:20PM -0700, Jakub Kicinski wrote:
> On Tue, 27 Sep 2022 12:27:04 +0200 Simon Horman wrote:
> > this short series is support IPsec offload for the NFP driver.
> > 
> > It covers three enhancements:
> > 
> > 1. Patches 1/3:
> >    - Extend the capability word and control word to to support
> >      new features.
> > 
> > 2. Patch 2/3:
> >    - Add framework to support IPsec offloading for NFP driver,
> >      but IPsec offload control plane interface xfrm callbacks which
> >      interact with upper layer are not implemented in this patch.
> > 
> > 3. Patch 3/3:
> >    - IPsec control plane interface xfrm callbacks are implemented
> >      in this patch.
> 
> Should this not CC Steffen?

Thanks Jakub,

in light of this and Leon's review, we'll plan to post a v3.
