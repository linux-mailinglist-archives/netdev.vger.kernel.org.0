Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0355B6F3D2A
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 08:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbjEBGAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 02:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjEBGAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 02:00:14 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2090.outbound.protection.outlook.com [40.107.94.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 622BB40E8;
        Mon,  1 May 2023 23:00:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m5BltMh+53cojTiXvSR4MW2lgeOCi/4AJdzruUnXmIyfhjNeb194MAkOGATruLP5O1+zYHGlaCt10hlh7WJ3zYv0JqOWHiDzh/qmVp5vploUHzCfZOxmDLUaaPVw+djgo6RGSG6oQAGfMpVvWLqNi37EDdzAFOlE4f/JXFt3QJOAmHIhKf0WH5O/kBm3LSkvZIP+47TtfhmlrNmkkF8EKLrDyQsUNTIXOmFwyHiIMJCQu6uigfNRKDCejp37W7g4f9MMEU59yc1pRR0ek627YLdNpYNTDW4WmtmTQ6i0kQdFpYhgvHForznGlpmFrzkjoH5dyo+ms9lCj5FPYhR8tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=727TtGUvBY0EJ5rfkavGQDOToWqxiPy/wsPwoQW7zro=;
 b=CvgSJizLdfzKhtdBJtbizxxdOG7MzDRPXWaJVpmhSC0ajW6pyj1qztcNKdz6HYGXQGwLBERpYRsUTjiNSjAeTs+QU8c+3H3lGiVJz5ZuBYIsCXkR63bpP8H65hWNmPY4ZKxwUDKU7gYXVn5G2J17hcbuD4NhIJivFdXIne6sEjQjjL6iZ85ud7XzpPqNU4duXQETU2CTvv3ggY2s4WI5BbqVv+u5wSJ+sv2VdZc/BiL1ObRhFXWIBDU78xEd6AUTSQAeAay/BVPp4eShpLqYMBkaDDjgYD6JJNwObQQHhhJ5oEYxaTLdUFTMnwWbaZz1mGYEmoqhTv0nz75gs7BNmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=727TtGUvBY0EJ5rfkavGQDOToWqxiPy/wsPwoQW7zro=;
 b=RXUJKZ3CNt58RHLuqUvdpAIBjEUoqljwaAQk2+3XBcBcpU68B4osWweZHBzCjjHgtMf7yrdkv2OHV5O/JHcmOetxY93qpeyA5hLRmDNigbIhYcMPvKVInjhRh1ZaGWSP+VTeawf3HTObOii/zGaN/xlpY0n/SJvygV9zFTKMgzI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4606.namprd13.prod.outlook.com (2603:10b6:5:3a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Tue, 2 May
 2023 06:00:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.031; Tue, 2 May 2023
 06:00:09 +0000
Date:   Tue, 2 May 2023 08:00:01 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Feng Liu <feliu@nvidia.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        William Tu <witu@nvidia.com>, Parav Pandit <parav@nvidia.com>
Subject: Re: [PATCH net v1 2/2] virtio_net: Close queue pairs using helper
 function
Message-ID: <ZFCm4ajSNCMxRN29@corigine.com>
References: <20230428224346.68211-1-feliu@nvidia.com>
 <ZE+0RsBYDTgnauOX@corigine.com>
 <9dba94bb-3e40-6809-3f5a-cbb0ae19c5b7@nvidia.com>
 <20230501101231-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230501101231-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: AM0PR04CA0077.eurprd04.prod.outlook.com
 (2603:10a6:208:be::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4606:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cbe19e1-b4e6-4d0a-d493-08db4ad27bef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZdGObVqSCWIA7hHCDvGBD6cpBhqi3TEVI+qPP9TWHlMSGKm1vORQboKjx5FCR/wc9nTmw+4UApAXDFw8yxq/M+mQJpU6ONvAhF1tJZ957xaTZDGxcODQZlaHj6Y7IscfmNsKLhd8UqU9YwR/1keNvOoZAovqOds2OlXXNPJJAtpvBIcV2xTaCti/TQR2cbvcgi9MMKLW2tLXKbWctGMh1dW16vx4CEcaH0UGUBlMbGok+2gMz3n4i1XztmQ3c0eMV8CCiZxjAaDqv8dGGHgJZMzotzltxTDFeBXJ+F5kl3NsJ8gDv/UWbU/YnThGwbT8SXgieEws5NGeLE9U7JLFIOt9UVmmzK/Px3jd1H+bG/y0e+noNCeuyyVf1bd5F8kbZFCX6wdwYkhBjh8ydF/epQAn/2CHpkvJXF8ztyktXFpIo/55lldCtpBljmhvoJ+dpJihDw1i/lQNijPjDGn1+B9AJNjp0e73u7+9qONlbkc2+A6aq1wd21uYQK5jGrtRwkdL5h2NkyeUmsuB6DJo0+2lyqvtbkjoYzaPOGSyndOimnIMj0Gqa6YBh1HBP4jb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(136003)(39830400003)(346002)(396003)(451199021)(2616005)(6666004)(6486002)(6512007)(6506007)(186003)(36756003)(86362001)(5660300002)(44832011)(7416002)(8676002)(8936002)(38100700002)(2906002)(478600001)(66946007)(66476007)(66556008)(41300700001)(6916009)(54906003)(4326008)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U/uCtVCU1Gi3798/wnDg+wbFmSD4NV9iA1v3ZPCBRJN1i/Pk0+VbUMotcRzD?=
 =?us-ascii?Q?vyP4KCjkUqXrw1IRrrLGlUMJv5AVJW2YyVDQJ/29OehbvKSAVA+giJEVyDjM?=
 =?us-ascii?Q?qcX8fkMEHYH0TWA3GC7SwJIEnKQPncM/bmOx6cD4+1yzjtouppQWBMFoUd+3?=
 =?us-ascii?Q?L7zNbqrstQCA9EkyxVyB77WWg5u09IzchAIZlsf0BytQeVPO+KyPGP+G2e3j?=
 =?us-ascii?Q?/Ptmu2DyQoR26kyCcfSkITOpk1m7Tpn9jggkgN5uXeZ4UMvRwCdwfyQIAsZG?=
 =?us-ascii?Q?v31Kdsj8QM6LQmDYyI6Iikk+299WT8vWOqsnVjT9jlHqJdW7aoigkWkhrfQN?=
 =?us-ascii?Q?RNour2pJF7ciYT8/T2m81CRb1dZUCZTG1av5pOgWn6nOqCmpI0BfZ8khs6qK?=
 =?us-ascii?Q?via3x5IKJDXlVhRdAJVjkBRzQt2SMnF8mtqcXVFs4OieFWZHydYAhFesue+E?=
 =?us-ascii?Q?gkgDjAYWTknCmIfOGpTSsdcIzaVbKjfwmMA0qhGw3F7kTtPk9XnrrU05vH96?=
 =?us-ascii?Q?sspJ4QDlEHVthR1AjT6OLyCdBzLov6m1p4IBWYxMFlwPoukYAqx7JutDoKwu?=
 =?us-ascii?Q?T9ulUpIetMcee3QjBH+BZSbXSTaEFrWUpKQsKQhQC9XWDYuQNtBxbZUAL2No?=
 =?us-ascii?Q?5yyZeKYiIod9HxM5SSvw0LDelZPOwaT3Yj+VbKWL+r7u8tNyCoXRKdT/W1NH?=
 =?us-ascii?Q?rhiCk4U8bg+7LB2kLCzvqJh3sYrpg3rE/3gv44dQVIK/3SjzTu4+lnqF/aJf?=
 =?us-ascii?Q?CwNkjv7G9V5kahK29LtTThQd+0NkkPFQcUr/cppGKX31HlblMjRqlBvXOtS+?=
 =?us-ascii?Q?hCXZjmB26LEOWKquiVW7GrSk7BQbExgZkECEGQDiChKEhV5lI2qH9DQBYaKy?=
 =?us-ascii?Q?Jb7b5WbX8j0wCac9o/C91U1SiVQQeBXaWGDAxRJih/vyPL00buuSQBdhp3qP?=
 =?us-ascii?Q?/pUrnQSmYGpRKfDsC+QsY0j1elvHFKimJ1IXhxQJ6N9bDyMxrXsKXAdMDZBb?=
 =?us-ascii?Q?wSBpg5kjLQ05fZ7UUL09FhY30/EYwIwkxat6uVeUUZpHjjZIkxCHEGYwNSHi?=
 =?us-ascii?Q?AwAbyzulzBRtO5rgMm4SxEXh9fFvXng/2kNUdbD4JV6LfQE43ky6OecWkcWm?=
 =?us-ascii?Q?Lc28GxsBe9rJrU+HQrDJaGdyMG8A+Gh88RGg2yhLUCfxzNC9nEdMMgqjrvBi?=
 =?us-ascii?Q?Bkf4VMJEt7K5iM0PGxpvr3OJ1GTOJ9/5dgNMPwykZwbj9gEEFCwfOSx0UiEn?=
 =?us-ascii?Q?Fi/eIvrZruy8fgjmcEgKWplvtN6Cv8qEJciOFe/b87JW0rs+F8RQuMWpjwz8?=
 =?us-ascii?Q?X2SMRlWBN/sTnlXpdcycjUTWiP8bRk+0R99s0rWHmxvUyat3PeAiq5WFTW5s?=
 =?us-ascii?Q?kii73UIeGkKXBWOSwDfBwkKbVi+dm3Z4DGSbVfoq5CtnqGK/Kj8zz2q1NNhu?=
 =?us-ascii?Q?lSzQk7nECxYQAWMc6ZKSKfMvVxQqXRQxIfMzRxAvfBoEwKFvBxKq9QUG1/my?=
 =?us-ascii?Q?dGfGnzCFoSv2QoAf994HAXDsDD5te0tYYVsEtFK9b2S814uhtGsDj9qf/q8U?=
 =?us-ascii?Q?AVZk1wWN0zbg9rLWZzvTVYanfpfjDoN+hhmHBSkqCsGE1qmwOK5IGY+6lz+8?=
 =?us-ascii?Q?QxfkcHMo+qIrglA21WstlSVrieQ3giA8wbO5U7eWNOlXtc6hwczoO3qL2G3v?=
 =?us-ascii?Q?qvLvcg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cbe19e1-b4e6-4d0a-d493-08db4ad27bef
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 06:00:08.7995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tKOYVa5NjgZBQEwnxxKT01qMGOk89exDE3SutVNUsUtk9iuUkcnXO2TO3TTjqMG7iaUWSVrln7Lh1mxF/RCr42JraJHwXkW+Gd9kO2RccTU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4606
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 01, 2023 at 10:14:00AM -0400, Michael S. Tsirkin wrote:
> On Mon, May 01, 2023 at 09:58:18AM -0400, Feng Liu wrote:
> > 
> > 
> > On 2023-05-01 a.m.8:44, Simon Horman wrote:
> > > External email: Use caution opening links or attachments
> > > 
> > > 
> > > On Fri, Apr 28, 2023 at 06:43:46PM -0400, Feng Liu wrote:
> > > > Use newly introduced helper function that exactly does the same of
> > > > closing the queue pairs.
> > > > 
> > > > Signed-off-by: Feng Liu <feliu@nvidia.com>
> > > > Reviewed-by: William Tu <witu@nvidia.com>
> > > > Reviewed-by: Parav Pandit <parav@nvidia.com>
> > > 
> > > I guess this was put in a separate patch to 1/2, as it's more
> > > net-next material, as opposed to 1/2 which seems to be net material.
> > > FWIIW, I'd lean to putting 1/2 in net. And holding this one for net-next.
> > > 
> > > That aside, this looks good to me.
> > > 
> > > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> > 
> > Will do, thanks Simon
> 
> Nah, I think you should just squash these two patches together.
> It's early in the merge window.

Ack, sorry for the noise.
