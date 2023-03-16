Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 972926BCC13
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 11:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbjCPKJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 06:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjCPKJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 06:09:05 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2115.outbound.protection.outlook.com [40.107.92.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A1072B4;
        Thu, 16 Mar 2023 03:08:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XqSt2ThYvd04wqsetoTptghodDnoe93NTQNGMrBwSFTkYV9ggn9tT4Sv1E3qZ4VQXtaYlCE4Dj1WnyYxPknAIK4Y42Q2+WpoBCPEke0Q77JK0ba0u75io7NxYTV66mrUXFpNaJ/NWFXSW70YKB8fRqp8VW3juAZ+E4gv/yuRAkIy4svl/HKyOCfzcmGisPKVxbWEJ86uU8lZhmCkcYXfEsKQAvx3wksWGIjvuBbifHucc2D7FRHXSZ3fTXh/U+1Rs6NYgsq/d42zGQvh2msyFWxgimcu6i3AsLV/sjLhiZlB7gQ29Zd0FQRSckcdnJm37YebE9lZfQXemOTmNsFRBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BY59rcoXkppz9yB8X517EVdmw6hBCUiwlntA6yYNJBI=;
 b=QcNNMCOqQaGGV2XQWY5Zrl2nIFS5tX6PAlCvfVPuapMwbrVJodfFxnYqCPyFKp3zkmZNEuC4ZKNVMNpMpPlo0TXPc8YDMbLwzyAcFFTo1DnhHVr2nBKF/Ddz5gqKBc5zdAIbK+VtUc6UBXDmv5x9p1I9h7PA9ZaykKlcUoXMQJkF3u8uY7SZRoPMSnHdrc6zxaTr+ZUKY6unPoWansO5xq0JCUmr+OKfXCT+2X/r7OCY6fAGWY8YS7jAVbY5R+VEQL/ziKTE0rV9S7zVpyMHkoAHK/Bq+SGsSbDkWMRK3aF6Nmdp19Vqv0fz/uB/jSTTTU5auqkFnJBWdTFAGZEd1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BY59rcoXkppz9yB8X517EVdmw6hBCUiwlntA6yYNJBI=;
 b=S08IPBmWBvRdxwXzoZReQMS+Jr19nEL5LMbs8g2GjlG+3kp9J9rbXUCKengNX94k3aWFiNyuWe+LBWhxecWk6fuZQ+P9K2ym650aKaZCUCzuCfdZyjATBBIJ2Ztihh/YXbaae/QI00gGcQs56r4SEKDQL9SsnjUG/ndd6pjvZrA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SN7PR13MB6279.namprd13.prod.outlook.com (2603:10b6:806:2e8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Thu, 16 Mar
 2023 10:08:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.033; Thu, 16 Mar 2023
 10:08:46 +0000
Date:   Thu, 16 Mar 2023 11:08:39 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Markus Schneider-Pargmann <msp@baylibre.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 11/16] can: m_can: Cache tx putidx
Message-ID: <ZBLqp5rV48l1I+E+@corigine.com>
References: <20230315110546.2518305-1-msp@baylibre.com>
 <20230315110546.2518305-12-msp@baylibre.com>
 <ZBLndFdGKYApfBv4@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBLndFdGKYApfBv4@corigine.com>
X-ClientProxiedBy: AM0PR02CA0123.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SN7PR13MB6279:EE_
X-MS-Office365-Filtering-Correlation-Id: 97c35db6-a17f-4593-feb1-08db26066dfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cmMLQcMEjYkWn3qez+WdT4xfUjkPo46wwPuZAIy5Oq+Wk1185IcMDZ7msFe6elCVs/Dgszv3E+NByz082wVW0kglSqAHKjLaWbKbAtUKQy8Z/2nBCBowc9xdDToUtSc9Vnn5nBb35HabaFbJSaWTtAVul2QHa97eIogsTmYeJis5PldoZvOcKtfvwc0uMZ41hr0tTkEB4p9k3TzGpzR/IA7I1WNnBacflKeZnXFRo+V8SzIa0/KoJ+fxrjBwVDwS9kALGvRdl81eKP2rtbiOeG4K9mKjG0qwlqSg3YsiZfg/GE9/6O9fR+WtcV0DMYQucSsPeS+2ggpRfl9Un8VVRhhNIuBrvM4FMUaIqAwBJCYTxR8yDB5vX9SvtP3pc5UvuBPQprAzL5CI7ImpSLZnrn/eMWUjtUphjMRColEp1FHtoQBLO15oYKBmFJvw88Y0CzA1LGECQCsSynNGIjGM2XVOH+pemNNQu61Kkc3Q8GB3f51JSXgy3+/UJTFvPWtMA8xem5Jss/A+mQwbyLS3mhQQHVa0//Ac1K+0vCMe2KuiTmypfTf8BsgUijTeTRyUr0WgUXCoWaoU8p5TdGWs4gYvkcbT/QP9+tHGSwdK5sWTWxACf3OpX0cgBupv3cBpzMLhH1ftF7m6qndmFQiPtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(346002)(366004)(39840400004)(136003)(451199018)(54906003)(316002)(478600001)(38100700002)(86362001)(2616005)(6666004)(186003)(6506007)(6512007)(6486002)(36756003)(5660300002)(6916009)(66946007)(8676002)(66476007)(66556008)(44832011)(41300700001)(8936002)(2906002)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VUlg7fDUUOIxWRYZSUwpYhxrKw6RtLd0OHkntQabWjMwNPmaIs3R1tCOjlDh?=
 =?us-ascii?Q?Dwcx4BIMTqy1KugkBgPsvzDC42YJufVkFFN2pNX5uiQOP8CzkionBAYYdIxY?=
 =?us-ascii?Q?DDMPVUPS337uFCqvQwV2ZvgXq7IMHofqlqb0VfZMG3UBQmY/CH4ZQ0/qoILA?=
 =?us-ascii?Q?PZTkYX0BXkLmNVPuTis7jpJB+A+EXuf9No0zaQ/ZSgaTdlvx2SZC7cYn56PX?=
 =?us-ascii?Q?kvc6/fEMYFLO/kcUbQWhAyegdH/wnLJITU+YZWrfjNNzLkKJ77009dD9uOMS?=
 =?us-ascii?Q?fc7gm9cvC0pEywZDuKL/jRHeBS8qQVTkuBzB64LrkZxVdqV4tAcLt7pQv4MT?=
 =?us-ascii?Q?1qzxZiW0QLpads6Zd0+QHwiCWYs0m/KIGydzvxJMSzYI1q27u9cYqSEmfIao?=
 =?us-ascii?Q?2TVkOgJynGVY1SEvum/QB/hMURMed/j/6s6QnuELSz/M/sy8IU7HM4zGskNP?=
 =?us-ascii?Q?W7vqHV7IwD6/ZniMFwNJEen3IJvp4+vsLJH9kNrGBoW0fRwZjWc0/zPtqCnt?=
 =?us-ascii?Q?PtsoAOxYyDkj1O3qYx3RXgezHQyZnPFZiep8VGkG0fs/XKMbARmJdimufVzT?=
 =?us-ascii?Q?gp+LI/KnCRgdrBZy6uo4UCDcEdQIBKfxb2m8btvcjCtUB56J7qnO8wKpbuwV?=
 =?us-ascii?Q?T4i9ni7pIFs6B2CIcPIQGMYViu7Za1+XOCx1youfonr3MVv8tX9foVezoRYJ?=
 =?us-ascii?Q?03mKFKM+MzwF70jNu8Aj7o2F7HYJgWUMGQX1DKrMIe9w333uzIlw6QaBCw1/?=
 =?us-ascii?Q?EwN3+u7M0EZ5sOJ1Ehhbufz7a+pMZqxhHbAGqlrN1hszBdhH3FZSlrj9ENN1?=
 =?us-ascii?Q?yY01jeZjIoeK8bTOswNjcBJp1z6XigdZXNxF3FNPe+TVIshYo4qI6ycZ3VV3?=
 =?us-ascii?Q?m94KMx4ovx4XRVVlFG8AbeS1zdJf/Y3afjekxmKDe3+4FVY/MCeyZkcSAeMS?=
 =?us-ascii?Q?rlDbWEtnZTuy0gCLq2P96c5zhk1nCcNCqRz6Xeh7WgV89a0q3FgMd1TCsrI3?=
 =?us-ascii?Q?eOSwZU84FOIUk5v/uZVNspz6ocYfQD7Y9E8YOlMZj7xfghiJeWmDGbwEy5vp?=
 =?us-ascii?Q?GAhYg87VRd2PLTEVFiBX70R1m4Ri21xwoIJNpSS6+mYMnx38NlwlATN6EPhX?=
 =?us-ascii?Q?4odLGY3NrYUKP19WkvqFCvP21bcZeeiPSlQEzhBSHLVNYhYBhJsdnwJkQekR?=
 =?us-ascii?Q?PUtzuWLWLXLQnJ+OE8nqq10/aBe6fTIWtOwWowZ4ZnwHDKQrRkdVFop1M94i?=
 =?us-ascii?Q?s/aL09Vdzqbj6qOiYRV+9iWyjPluPcrRlil3EE3OoTQDrw2spz1kJ5n4kOY6?=
 =?us-ascii?Q?PJykw6Av2P7aWbyWdVXt4Al0yAYB6l2c+YxJqi9fsm2kMLZgK8TypuXuDLox?=
 =?us-ascii?Q?zY97JqCnmxS7bdIde+0zqCOLSnn6bFDFC7qXuCO6hDG6mpTHDETiJyRv4Cj/?=
 =?us-ascii?Q?pIzdU6uLck4F6wRMDLGfAXvHVRkbXmZ6Z5Hn5rP4ZtL5iocS9tHaBPdGlYMS?=
 =?us-ascii?Q?LfT4k1KjQB+E4+QOC4bTpiOxDLE80Tdi7/BKOFPJLcLnQe7Rx3iRlLEqIBGP?=
 =?us-ascii?Q?uaCyD6w+x8tFWgia3Jzj2pmmjnEks3c8SHc+jr5UDbQgaAm90PFHPeR86eYT?=
 =?us-ascii?Q?MHJ0HK1J/ZKafhIQokYEJz20ZINqdq+x3l1YtOFz75AFMgMiiXHkHGZysBjI?=
 =?us-ascii?Q?OG2iLg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97c35db6-a17f-4593-feb1-08db26066dfb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 10:08:46.2447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KVgGga/l0KpDFiuhfUp5hVjHdaMlWS28qBodTN6ex8XqZmswifOwpEq5O6VY/N4vGt/a7DaHlL2CYofvGq2SGOBR0aPUDKABdUQ4HYen1QM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR13MB6279
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 10:55:00AM +0100, Simon Horman wrote:
> On Wed, Mar 15, 2023 at 12:05:41PM +0100, Markus Schneider-Pargmann wrote:
> > m_can_tx_handler is the only place where data is written to the tx fifo.
> > We can calculate the putidx in the driver code here to avoid the
> > dependency on the txfqs register.
> > 
> > Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>

Nit in my previous email (which I hit send on a little too soon)
not withstanding,

Signed-off-by: Simon Horman <simon.horman@corigine.com>

FWIIW, I am taking a pause in my review now.

...

> > diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
> > index d0c21eddb6ec..548ae908ac4e 100644
> > --- a/drivers/net/can/m_can/m_can.h
> > +++ b/drivers/net/can/m_can/m_can.h
> > @@ -102,6 +102,9 @@ struct m_can_classdev {
> >  	u32 tx_max_coalesced_frames_irq;
> >  	u32 tx_coalesce_usecs_irq;
> >  
> > +	// Store this internally to avoid fetch delays on peripheral chips
> > +	int tx_fifo_putidx;
> 
> nit: it might be slightly nicer to do a pass over the code
>      and make putidx unsigned - assuming it is an unsigned value.
> 
> > +
> >  	struct mram_cfg mcfg[MRAM_CFG_NUM];
> >  };
> >  
> > -- 
> > 2.39.2
> > 
