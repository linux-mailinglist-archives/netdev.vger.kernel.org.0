Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 577B76F328D
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 17:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbjEAPJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 11:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbjEAPJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 11:09:44 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2119.outbound.protection.outlook.com [40.107.95.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E6E91BEF
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 08:09:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B0ji79GdXEr+O9d2vXeOhpmKDiNYlI2ssM7wB9moDolylZcM/rniBKbiG7UXfmlJ4SrYII3mXRqZIWbZEV16OYnNMfY0sguVbFZVrdxnFuZaS6T1ygmx5NYlS+GSx8kPfy6KkELUpj0JU18zRzKgHmyutg0BTjlLnM2qKYiBwmTEg/JuoZlvPPcBh9bYVyNd3RWtwlbQydK1HGBbGSVZjlJTq2zmFKRLaT7ZY1zKgxOFg2x75H/PLrBepNIWPijH4s8l6JRwRQedVBjHeEHQbJq2fGA2050ZFngALPsp3yJvqUDbad+NYm+XyT0RbteM4leeWl9EZzh12OzabgEGsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8YD+PO+kwMb7jTuEZa/cX6uffo+uANGTb6j5dgwdTqc=;
 b=DV/Pz1yjVU7R0HSKH+9vYSaLundxFlj1ZqRcOzVVdpW780ws7hNN4BpK1I7WY5FzJeA7yn+szuZCVru/a4LdaLAs9AyLkkELJp7TQsH7mJkmraxCvY5cuWTS/Beuw7iPf+0jUo5yzRQydhHDjGgyjsrYz3QA7vGqCXqtURFxMwRDuUZ4LA8QlAuDTcgeZKbzwoEyWDCFn9iNw5jvL7q53UfMt2Rm/HMvv4oGId7Ba6RciXmaRhEt7LrP0eMT+SbALQFPX+JNjDHfpF+kWP8s69Kc8VuXLkkor00UuSaaoz+qwdtXUYoAtNqrd2924q2UBErkFF1J/tM2B/iv77Cxbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8YD+PO+kwMb7jTuEZa/cX6uffo+uANGTb6j5dgwdTqc=;
 b=UFU9AmC4vaCVT1S3/JiHqWw9ndhB3gR60iH6U1mQgilFWDTLBd/jbpEbmXX7vNv+7Jq+Se0K0JpVzF6O7nRjYdPfzEj+YZMXg6XrHDg+GVi3JY0ote4KrnUCjXxisF3si9MCfArIlMzpy7E6dY66cJM+mKAeZFTbQQICkon6ETU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB5059.namprd13.prod.outlook.com (2603:10b6:a03:36e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Mon, 1 May
 2023 15:09:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 15:09:19 +0000
Date:   Mon, 1 May 2023 17:09:13 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     jasowang@redhat.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org, brett.creeley@amd.com,
        netdev@vger.kernel.org, drivers@pensando.io
Subject: Re: [PATCH v4 virtio 10/10] pds_vdpa: pds_vdps.rst and Kconfig
Message-ID: <ZE/WGcjsX5gCagWJ@corigine.com>
References: <20230425212602.1157-1-shannon.nelson@amd.com>
 <20230425212602.1157-11-shannon.nelson@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425212602.1157-11-shannon.nelson@amd.com>
X-ClientProxiedBy: AM0PR04CA0135.eurprd04.prod.outlook.com
 (2603:10a6:208:55::40) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB5059:EE_
X-MS-Office365-Filtering-Correlation-Id: 02a74270-6234-43fe-6f38-08db4a5609b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sdX55ujgG8xDnNoBz17mdYsDxmqwJVgKWrKNzbqLzMFaTBZicgFp6rVBictJ7qoPfQO1zbHJwcptv36XOB3fsoZcc9bwWjyAKb/YsvGa/f0et3GI3/zjk1yS3C8os0130yQS385THQ++XU8SzXUG9RIkpfv729dP+KPYf47NL7ZbF44KqeXpJV3/7YOFsW3HRIyS8GP+FM/B8+7izQwiekxMpasgQ1A5Bl3Mty4sWOy+QsIwtWFbFa+HF86Ltj6G/A5DzxY2+V/qNy17JrzZgpihxpPiaeRFNtUz/A8Krv2PlivhJ5/CTizBm3M6sIeU6MPCVSXMnxMQ0CxFspZU0KcejXQoApCbXX+VcvXW/9+6TYLLrYZIW2hv7Upx14xw8T/th4FGvpFWufOx+buNFf7uAGOJv1W98qctB9WScUHYE6kfekYJeLG/Tcr0TPTa08KzXkHv5iV4M5Eb25suwlArn/hQWF4Aqn/LhMmYRnuQ7E3+4fcdaaQ+3P3a2CXGHSAnICeOo9EMPm7t1KZZs4nn0+h+QT+T1HlNmZS02/S4nVbwrtzGVwgVdGtQ3wFx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(136003)(366004)(396003)(376002)(346002)(451199021)(86362001)(6486002)(6666004)(2616005)(6506007)(6512007)(186003)(44832011)(2906002)(558084003)(36756003)(5660300002)(38100700002)(66476007)(66556008)(4326008)(66946007)(6916009)(41300700001)(8676002)(8936002)(316002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6GsvcKj4MABjQoptbxBtYyBoLobHDr4i4zlzH+Tg18baZb+AQSaIARACZ1s0?=
 =?us-ascii?Q?b4RB5pK32lezOTP27XY+/Y+QJyK0Q1sw7dv6M3R72I2cFu+6t1ml9TUhVCSv?=
 =?us-ascii?Q?x0WudjzTjZAKASCg2JuhHdQMS1iNnDs1e12T7xH7qsX5lVZ/607fXTKnxnOY?=
 =?us-ascii?Q?vDCHdlz0InMU2pOKcmB1zB5n5SerOnNIwQv52pnEQGK2/ryak1gwRZNKxS+R?=
 =?us-ascii?Q?i9pEnEyCa/BTht4IEsDPYydJWgRqPtxgCAxjatyevG0ZCRN6MPbR4nOz97K4?=
 =?us-ascii?Q?H/x2AzffRu9/GNaCGc/JRSjXUS07tz/AczslzmD4NUQs8ij206DpDKs9zVov?=
 =?us-ascii?Q?Ol6o815IZ/1qo+DlPmziFR8Pys1dFYfWt/0kuYZDZnIvpiBXDLTGkU7wLD1c?=
 =?us-ascii?Q?3ztvRJbgUJH0r+qw/8t3cLY7Vaml5snRqWIsmHSKa31uvjGyE3X+fu5CddgH?=
 =?us-ascii?Q?FALVmgDSg2bLjCVIHSZjOxyuA1BgWBLVRgfqqLjppo5X9BJo8mebq5XsAO/6?=
 =?us-ascii?Q?BTuq0RzMIEFW8pDAWUdp+zhv7VTE3gT3giRTanh8XCMTJVcNVNntTxiWXEWZ?=
 =?us-ascii?Q?e1vjlGGqBpJjTI+MPGSakZ2pK6zffgLO0xVmuoDPQRlYEAn/sB0OabiuJPQU?=
 =?us-ascii?Q?42e7XwT9H6PzAKk4QrjJ/UPDoXjwWtTQdaJ80HxtJCg7Q+jWFrVF7GGDRlSq?=
 =?us-ascii?Q?sLiKQa/R+70/rHA/8bLRl5Vd0I7gSdwnlfnM6l31tNkCl3VKgkKS9Kt5Ebh0?=
 =?us-ascii?Q?1hAMSZNdFz1EMUckmT3Ho0rQmXd/XHhlt5cUXZouC95kFe3xD1QD0cNijpy5?=
 =?us-ascii?Q?Zfqx8TF0Q9DNUgJsq5PtTvtBRMvLojUTY4n7GE1E8DxI5H2TvyVCD3qLwarT?=
 =?us-ascii?Q?qM08CNTiUjJn9k3wPIt8bLQw+4Tts8rUmC+loqjgyqJUoKWORUeZuej8gnXg?=
 =?us-ascii?Q?EilQHMqHo334q0Oq+8yrTM0clLytJKNY/CyT4r2CUwIE5RWrXOHJgJusQPST?=
 =?us-ascii?Q?2qf0muJhwRWzgd5srtin2zH/HvRYYPrKiQYTfu28jaZwxcbseLpjcoRHPgbG?=
 =?us-ascii?Q?KZd5wuW2bBf1936UjfFlZEronb89bO9F/L6bpGtlwIufEHlnWhaB5sz+TS4y?=
 =?us-ascii?Q?h8rJiXGHyFnpTzScllB3NwUlnihTKctfS2uN9TyXSQmqyoE5Tq4nkkxB8eup?=
 =?us-ascii?Q?H1mq9fO2/uyuPiMklZSdin2gaZA2wSNnnIYqHslVYKF9xo3CpbTVHPxJtfh/?=
 =?us-ascii?Q?ALYkjex9dDaUrWBykZHfXsxzzJ4Od4WCXDWvBBu+u96zBO9wBIFhRMvpKTmZ?=
 =?us-ascii?Q?dQ9Po6j/mdy/VkwmxHF0iLvnKqC9XWZ1jOqb1d6fwW+VYckabcVCS5feepJd?=
 =?us-ascii?Q?6ZeRYj3wwfARzUEWX7gsJBA0d6a7mZP2I9uge91vT3ryJdVs80l66Yg0wdHY?=
 =?us-ascii?Q?eqztRK2Wpz+eNC7lJ/K4qHh1vl4DyenWHkqe9pHBhRZ8Rcd+Ge1GGFJMXpQR?=
 =?us-ascii?Q?ndM3j27rd9UWOP2s/4umPmOej6syOgdwRI/xUEDJJopFDV0Of0kwz9aSB9y0?=
 =?us-ascii?Q?seMHLSKmtaXrrWXKyAsNWfcYWDvGTbqO7hqvkXjo6ejx740xddpxfLjSB2UP?=
 =?us-ascii?Q?T2z5d0QOPJr6eqe5Yg9WTs+dzn+1enBBkU3O6vol/z7+nMSiiXQzYWj1j5RO?=
 =?us-ascii?Q?7XaRdQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02a74270-6234-43fe-6f38-08db4a5609b8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2023 15:09:19.5404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0DYuemOcAlIpkarfLxHbxrvJrX0iy1fnCCsx4ODcmWEq8oAX+5mW5n2907pWjGWto4PkRvgUAY4ZETEMiuLiDvjuUhgPPufliKFnKnWV9qw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB5059
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 02:26:02PM -0700, Shannon Nelson wrote:
> Add the documentation and Kconfig entry for pds_vdpa driver.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

