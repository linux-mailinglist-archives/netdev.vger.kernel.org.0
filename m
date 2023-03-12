Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D576B6730
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 15:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjCLOfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 10:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbjCLOfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 10:35:38 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2116.outbound.protection.outlook.com [40.107.96.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E54E3524D
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 07:35:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uy5QOlaKJ5j83jKvZdYzXOkbPcpYhm9ag3j77UJrB9w5AMqzE1JEE4uyAgZpnOMIXUi5C8CyYp9dp/dlMB2M+n95yKgXc436Xkmg1rZqQwwXjv828jseKjXwHkZq5MZIKO1y8MbkZMTwq/xcaClNI/KggcqK6UAFvvDfA6vfKudWcqpVU04wgKgkT2Op06pYKiBhL5zuqbFKsoSPrdyJ2jDPbA9W/8RoQajPcNSCj7GYz2KnCzKnkaMbFNpiulqiZCvVgSirJLwxj7F6nRrU98Cv7pgCqMINSS5HFW8lfxbFf4Bd3jxq0J/JopFTly6e0FjBeVlBjIFQxvCLM919kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uV3Q+ZIULNbByLfa1TB1i0OTE6RiTJ4cv/B6WhEOmpk=;
 b=gOhHnBgD3FNk7BIN3tkd1W4z27LhWWAJeFZswgILql8Bm3D/ILPgKVs2qfzAZn+b4iLyjljb6y+JRLpqprr3EXaSSoWd2FnoV9kPiJbLnatGAjw4kVM0cue/pWDGY57KwaeOYJ2TOV6p8Iy69H6YMm126/IbuA/JXzYQNcgWa1dI3TuQp5tDLMMUtEtl+verjfMeU0qFxLqzfVe2K7zBjrY506tM/Cv7R7tKi8KVZl3HNSJS09/v0iPJm/h/m0bYRezWp8Z4jZKGlkMgyYCi41lEwIYN6AcdlmAC7yKFYnCqgcJDrhrwmJG4lr8IP4/58ogIJCZJbhtAbHetZ6CSOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uV3Q+ZIULNbByLfa1TB1i0OTE6RiTJ4cv/B6WhEOmpk=;
 b=t4RiduGwu8ap7/OsBQni/lyqbYy93l/rfvHY5lec27hRftF1e71z02i+U8p5bpOFqqiAcjNTPGxWqYD5JeEr1lCl+kIxhZ6qFEZlBmxUEYDBiBxNWqJ0AapyPWADdJTqdfryQtCd+cRaDe0IuiRv4GHp7yJ7MXh9PYUmYp8DTCA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB4058.namprd13.prod.outlook.com (2603:10b6:303:59::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.23; Sun, 12 Mar
 2023 14:35:29 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.024; Sun, 12 Mar 2023
 14:35:29 +0000
Date:   Sun, 12 Mar 2023 15:35:22 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     jasowang@redhat.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org, brett.creeley@amd.com,
        davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io
Subject: Re: [PATCH RFC v2 virtio 1/7] pds_vdpa: Add new vDPA driver for
 AMD/Pensando DSC
Message-ID: <ZA3jKuMlr/kBQNml@corigine.com>
References: <20230309013046.23523-1-shannon.nelson@amd.com>
 <20230309013046.23523-2-shannon.nelson@amd.com>
 <ZA3cYPoWQCjYoB3g@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZA3cYPoWQCjYoB3g@corigine.com>
X-ClientProxiedBy: AM3PR07CA0122.eurprd07.prod.outlook.com
 (2603:10a6:207:7::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB4058:EE_
X-MS-Office365-Filtering-Correlation-Id: 84fb27f6-6c9f-480d-bd3c-08db23070708
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SgCxc0MJ31IX2wjmJzJa42En/w8V5/0pQSUfaS81WKONmwdNNUwMVO1+Qh6zW0Wel3sumo5PBbCYasEXbXvZErrOztlwj95hREYxRk2hyMUXOU6IoWNyWj8444ljTQpYs1LgSrh1flYjHu16/tDiht9UX/10CMUoKznS3bfYqM0oGr3WIiwPEtordnhXrAC3s+X//3tBRYzDD999P4djZJIgQqNuUQ27Qsi56oako2P6HZ4y3dy3crEOnc/FAlMQwygPISt8m0pzL3bF/KdFIO7GIXQJ9Fqkqo5iFvYHqa1GLXlbyzW8uXABgkKOmje107bs3rOzn1mYpkAUECdC5RmfpKJRCQXz6ss3IyRGFQiKQ78VB/NT7dXjCwuXvx5RYGFC9DpAeNFzwaxw2U0LwyqBj5Nnba9dzNncZxqcAFHzvfO3lx84TaGnqoeNLHFIXigFK618oHtaalxESytpI56uRThHg/EYfkEPDn+c5R4XPWp0cuecEPVTUMoZh1QA8aSOyzIPVBGv59Rt09Yth1tyBSkYr0t6P0HvDY3nNd1Ker1CGU0fS6J/FPu99Nmme64w8YH2pVHx8e3rXXfmBTkUjYh29sLU0PLL6hjwbEA8vnbXstOSJubCtSZzoJodOX0qHIGZesMOhQQUj9Q5LUMQwKQtUcP2F3sb7I6afOFvcm3uGCsy57S8DaM01iun
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(39830400003)(366004)(396003)(451199018)(86362001)(5660300002)(8936002)(4326008)(6916009)(66556008)(66476007)(8676002)(66946007)(44832011)(2906002)(38100700002)(36756003)(41300700001)(6512007)(6506007)(6666004)(6486002)(478600001)(316002)(83380400001)(2616005)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IoP5tHlX0W3HxAZ6/VNx16/j9kGv0ONyqj+nWAxjxciQKwX5VC/Ids3gDWYA?=
 =?us-ascii?Q?QLiEZ2GU01FnmAW4kR2uVvq+XV73N6CMz/CDuJaCpZb/a2miW1u/y2wW5FI7?=
 =?us-ascii?Q?nCLSDUo4SkaVd9nZe5ejYwqMxgDqq+5I6kylmkLvHYp5PfrH0TqnBFUgKqQB?=
 =?us-ascii?Q?AStBr2bsL7ZiaUbX8sPc3sI/CGImNwT8m9hg+3NEz6fZmu9U+blShlW8xeZv?=
 =?us-ascii?Q?GaeTLJY2+2PgT+5RhzbebWosSGZi8zPhBBEe52N3ZX0dombFQ11YaxyF2LGb?=
 =?us-ascii?Q?+J0pHk0Ak79XaVuyT6hTSaKG8lFLKYSKIbGPchkOnHECdTmJZQzfPDXfPH+K?=
 =?us-ascii?Q?OkYXXmx3F21w23tO/+NuxfSuDiuju8kasM5AOA4pD2k9Qxl8p0CeJiSibNwJ?=
 =?us-ascii?Q?mTQKK249sO1keKOYFlVOPfQhXpK9+PbBa3aW7otwqN1J4uGsfEH/5KUZyO15?=
 =?us-ascii?Q?mO/qlNYJE+Ux3gBbZoEcxH+OcPzGTHc/HGv8bmVEd1WMVHPECPSoKGEKJKRX?=
 =?us-ascii?Q?a26hfVojA2xnJOkRU7DnkH/KFcsXBmdrHaojk6orSzcH/MzjL/NoxK+xckIR?=
 =?us-ascii?Q?+bnxO6wsoJdmD4J5NM6PO7EfEzMkbNClApAxAl4iw3RGD2IJ8IgKRrXXVZNE?=
 =?us-ascii?Q?O7W4QOTpXPR3YLXeB9vQ+mZMIXRgbFZKMAzMKVOiEtgws8uC535zK7RuV02x?=
 =?us-ascii?Q?zxCgkNUWQwsgmEoFtCPcg57YWuiTButPR3vXUlLURYfwnitzHjDPBr5dXapi?=
 =?us-ascii?Q?raF5jwhzEuY2i9PMo75BcvlXomKvoZ8o9LowmEsInrG+Uz/MssfdIleq4eL4?=
 =?us-ascii?Q?tEWVLSKmqhm1iY08Pm5UDDUJSC/T3dgLNOIuF8kTzWDMO3TM73+y/q+ARUQ6?=
 =?us-ascii?Q?GZo84649zgEZjS/jXL45H4EVqgMEm/0NzJcE4gjZsDTxjbzG2OfK+n1RSzvT?=
 =?us-ascii?Q?BUsqhgVj1vvwFZaUp5TPxH/6i8NE9p/MgfpYVDFi3W51KCQCHWC3PK2N51WX?=
 =?us-ascii?Q?ix3KnOi9c7yUAMoFiYCVUFLQtGdx5uJWlIibckavTY9o9xH2GU90sQa4l1UR?=
 =?us-ascii?Q?/iZyDq7V6lB36U78RJ9A318TCzyrFw8US3rNph7fZnHn4Sw6f2hKqDLvhf6c?=
 =?us-ascii?Q?4iVBZKq8x1FRkrZF58OGVenXdl7TIm4ClyUVcCNmrah4YywA4OEltVWn3Rbb?=
 =?us-ascii?Q?/it67iy63ZIgiEDXSVoWaaNN0ElSdyGMmSNm0rSBqZQxnHqfLY2YjYA0M0/9?=
 =?us-ascii?Q?ket0wJ/B4z2V1Xlik1h79txu/9WQy7zJJk0RV2Tr3MKk84umYHU/zXYWkrw0?=
 =?us-ascii?Q?xBfrB7iGMmgm2AvPSGfzjNmcI1WO2kOI9w8oMq2QqhXGFenO8r1PRbRBUnQj?=
 =?us-ascii?Q?npfZrs3xGrjU7Gy8QwAuPtCKGOJv1PdvVq41l0FzyRopiTGobRAg/NO09CQn?=
 =?us-ascii?Q?A9fluF8GMyLtxuVyKJrXoup2roKPwB+JjRMYCGFkea3TM+NgS3OigFRWFD9k?=
 =?us-ascii?Q?WvQAVRkjHLBqwQNjZcmtHwAvuMjkU7Zno8RXr7w/wjE+28pfmYv1egjPD34r?=
 =?us-ascii?Q?lLcjRRJOHxBsLDNeqAeugKWIHm5/zY6YQltQ90Ry8TNinLOJno+ggBJ2jfPk?=
 =?us-ascii?Q?+XE6rslkNvIp8Xpd+61+e1MKUHGOoe5rHsn5TBtDPxTnR0BeMf0OKic7IC+e?=
 =?us-ascii?Q?9/vhmw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84fb27f6-6c9f-480d-bd3c-08db23070708
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2023 14:35:29.3907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tB07nCqHVK3g13wCxRX3d5VSlXZfW3us9o6/uv1VP8DWHgC2T2bXiuphbvqlj+QSJJeAHAXb9+pO92ictmUuHZmKokNOhn9SZOIov5peqXU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB4058
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 12, 2023 at 03:06:39PM +0100, Simon Horman wrote:
> On Wed, Mar 08, 2023 at 05:30:40PM -0800, Shannon Nelson wrote:
> > This is the initial auxiliary driver framework for a new vDPA
> > device driver, an auxiliary_bus client of the pds_core driver.
> > The pds_core driver supplies the PCI services for the VF device
> > and for accessing the adminq in the PF device.
> > 
> > This patch adds the very basics of registering for the auxiliary
> > device, setting up debugfs entries, and registering with devlink.
> > 
> > Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> 
> ...
> 
> > diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
> > new file mode 100644
> > index 000000000000..a9cd2f450ae1
> > --- /dev/null
> > +++ b/drivers/vdpa/pds/Makefile
> > @@ -0,0 +1,8 @@
> > +# SPDX-License-Identifier: GPL-2.0-only
> > +# Copyright(c) 2023 Advanced Micro Devices, Inc
> > +
> > +obj-$(CONFIG_PDS_VDPA) := pds_vdpa.o
> > +
> > +pds_vdpa-y := aux_drv.o
> > +
> > +pds_vdpa-$(CONFIG_DEBUG_FS) += debugfs.o
> > diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
> > new file mode 100644
> > index 000000000000..b3f36170253c
> > --- /dev/null
> > +++ b/drivers/vdpa/pds/aux_drv.c
> > @@ -0,0 +1,99 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> > +
> > +#include <linux/auxiliary_bus.h>
> > +
> > +#include <linux/pds/pds_core.h>
> 
> Perhaps I'm missing something obvious, but
> pds_core.h doesn't exist (yet).

The obvious thing that I was missing is that it is added by

* [PATCH RFC v4 net-next 00/13] pds_core driver
