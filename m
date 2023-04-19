Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63A796E81DE
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 21:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230488AbjDST0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 15:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbjDSTZ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 15:25:58 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2103.outbound.protection.outlook.com [40.107.94.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9AEF6EA7;
        Wed, 19 Apr 2023 12:25:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iokWZPZrSN+WFi38Seu4xjKEjAJkWxwgBMj83ms2mYfVgChRBKPtXbvlPhq8mWrVdUhFc8rpPT5NFNPUh1eyHjt5VT5xH10lApEnRxcJNbmU2PVqwOZCNl26sqMcSob/AliS0HV8SVcQZvFXkl9Cucp7ZUXR9MByq68pe0ZMoXhR4OsgVew9/3t5ie7Ybugq4JmDJeRxo0oSn1vTu2F5RJ1/DirlZooazSs9varTWMgy0xUfthtqWDl5pzzrq2/fy2Erd78Wf56CuDIPibVfdpf4dPrfxaDwXiVoxT2f83rWtQQ4z1LbUNTBljAfKDXXhUNrC/sLklqwJNBZYhE2cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f53QQ0GaY8O9nn5Ne6zaGgTPznW/39NUV3Ki2pcXd98=;
 b=A3SRpJJ59X4niL6paEOhzs1RMsLCh7CEPmo7rdsbGiQK57tseYE5gOxY7MM6OnPESU0REcXXIDuMQm4G7LN75qMDWGl84+utjZsGM7OWzu5aN21pAVnRDBdxgBV4SSvSm6cadCdAvcAQozxx/Zql87+X0UFlRumOYJqwy8OZXI+6mcH4SSyUUnMtyhz1+u8QCjQJB60cuYsrvfPqSX4lvPRkOz+K/20KaY7LtA/zJZpy6iTzydp40ElHGNqEoQeYmYx1ZjoM4VthNnHQ28Q+zbhiYG9WB3n5aDNhLlAGA2QlzcaJnWDyTDKZvbhFELjb4txe9T1rjiMvPVbqQPmOhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f53QQ0GaY8O9nn5Ne6zaGgTPznW/39NUV3Ki2pcXd98=;
 b=bOAA/NYj5CNt8unVStJy4yaZlogitezlEtau5zUu5ttZ0z0pv7ZZ+uGQP4a58eJDiW9zJ0utGnUeCo/v/xORVSHZ+9Y12LOzJRoN51lyHjHCrZBM1hhzogctARXDU8XeOalBz/v4Ua6rcEMoVULRqaLWkBnZ+4CDHR0BiYpiPvY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4682.namprd13.prod.outlook.com (2603:10b6:610:de::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 19:25:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%4]) with mapi id 15.20.6319.022; Wed, 19 Apr 2023
 19:25:49 +0000
Date:   Wed, 19 Apr 2023 21:25:41 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saurabh Sengar <ssengar@linux.microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: hyperv: select CONFIG_NLS for mac address setting
Message-ID: <ZEBANRDxW+yod7yA@corigine.com>
References: <20230417205553.1910749-1-arnd@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230417205553.1910749-1-arnd@kernel.org>
X-ClientProxiedBy: AM0PR06CA0127.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4682:EE_
X-MS-Office365-Filtering-Correlation-Id: 11b874f4-5286-4df8-5a37-08db410be1e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5EhNkA2TElgnpkoRTEpcEg0I47x99hTjdHpVlXKPXBLHsxciztUDAH5caUdZKJQ4Aorw5Wj1k8V+KLAQS96BS8mYdqvtHRlzveNGAsAKOymrct1q+raGYMRtVmPQ61uMK8IOMGkpfC9gyb/sHopKinULVmf8y7uTDLS7Hhz+Clc/HT6VlFDPz7/QOE2QA3Z8p2tDSNz3A84LkQ3ZWpx1ON2zxhPMoMH3Zz3mZzwm/wKbcNFzGYcrOITTMsGIj5JpZehfPQkXWiCYs80D/9rS9JOzmRB/e5bIOQo5jsal4a70yZ6IpdLomhoaqJtsPnI/PXVYhSAtXGdLxsWZzlWJHzyC9YDVHL5Dufp3QHOG1LR3pU5xbC/WCDDFzDaXIXJIsDybB95NMTQDX89T5IiUwzeXE/aE9czTsiwtEUiQQUKeWdzaOFXGDU8octwChgZRVaHLRJyaI/wM7j0+D69gEffUec/3SsOm1hX/Kh7yqmeEBKZk4rylfUSwevn98ixnFJHqNqKT4SpCbcoolIfUFU7yQ1J3L2IPpk+ioOzVaaADOVpTjHKZoS2/LQgHem5J6TWIW/nuQkQqEutMltD+6lcTrzL2s6nKnskqjBNvsJc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(376002)(39840400004)(346002)(366004)(451199021)(6506007)(6512007)(478600001)(86362001)(2616005)(186003)(6666004)(6486002)(4326008)(66946007)(8676002)(6916009)(5660300002)(7416002)(66556008)(8936002)(66476007)(4744005)(2906002)(44832011)(38100700002)(316002)(41300700001)(36756003)(54906003)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZdQrVrwjknTteEEYoiTSONlYUse9de0sBryeL4TdnUdF+kuspWNgzlVW+CMx?=
 =?us-ascii?Q?aonOTe71rji6rq8W6vW9q5Uyj3ZEMrsWRHtGmKftZEHyAtgrUGZVxHTWUd3Q?=
 =?us-ascii?Q?BzqY8I5TvA9IWndHm1EiP1haTmJNcdPERUs8Tuk8Tm2qmbUwO/1dLi34Su4s?=
 =?us-ascii?Q?mUn78a4e3SIYnFExV9EPd5M3DLp3StWCjb5+MMDxuckFLzxmmHmsZW9uabtD?=
 =?us-ascii?Q?ElxgAY5SSo5Cknkx4QlyCcalGn0jsAvlz5uKrP0iCvNz1fmNtB4WxvkTVD8F?=
 =?us-ascii?Q?X9yJDpSOhGEUjhHw3SXhDNTkcfEM+yXvGu8udXaJhbn3Mhao76swA9yxzLkZ?=
 =?us-ascii?Q?bf0jqaVUYeMpCSzfZxRYaZ0NNF2JTwxOIGYuU8ndzXls+RFKFZVH0rEtI2uc?=
 =?us-ascii?Q?E/AfGMpR26Pjv1fuXB3xx5BY/TP8XGMJ7uO97YDbD8pULwj+4AVsQNzSj+wr?=
 =?us-ascii?Q?V17/ry3JNQzH/gNYx0sCtjr5owfpEVOLb1rx6FFLXMTGE1L05ub5V/WfwNoI?=
 =?us-ascii?Q?+S1IzS1Fo+v45p/AaOsjrnsnicO754GacJLKouzOegjT6tlh/1HPCu/sdLcj?=
 =?us-ascii?Q?mhhuj3wj8bm27aqZnZb4mwcnBFit4yzKY4mCaUUcZP2w/rPosHT2fIEnW/RA?=
 =?us-ascii?Q?JjaGCJhQ66NNWWqgJh73W3xBb6IqdaT3QwmECHsurzPScm+RYxn+obk34Zy4?=
 =?us-ascii?Q?/u3TvVlk87rfaW+k77fYJx9Ei1AmR1KbBSeOpa0gM+oFNjt5abEIQFdYADfG?=
 =?us-ascii?Q?tbzzsqA5g2ynhB+zPedUgYga/tSE2NvmDb+nEdjXhVQj2OZMBqSGYFJHlcw+?=
 =?us-ascii?Q?N3xecYacx2MfPvLSig8oemYkuYSXP0EQWoH99jPPuUC12lQESiHgkqEnC0Bb?=
 =?us-ascii?Q?jUEpazMTyx4Djnqz5efWLqeWmtipeepi9bW8IaUiHAEAJDJ9C63lbu64KuOU?=
 =?us-ascii?Q?7STiUi9o00sXJu3RSCilMv7rDoiRCs7RPGyfEfj+6/NB081RnFUWWas15nPq?=
 =?us-ascii?Q?m6qn2zp+v6bMkJheJjzNzMJ0z4ekwEkCQwy2GpFEFZjWSfr50BnuCp+NKTk8?=
 =?us-ascii?Q?C90He7WckTbXI9SYd0Fr9TWYEpIOirnSXvN/aFQsmNU0YxjVyyjBp3QW9KDs?=
 =?us-ascii?Q?5KfRnwocV7aqdT9zkbufnkUReKUQkhpsQHy11+AHeBbqA1WFoAp4Co4ahJyk?=
 =?us-ascii?Q?t8k3aSYhLGVAQbhlNK2OvUTu9oggfbX8EvJMAmQT+rKj8QNoKeOrheNlyxef?=
 =?us-ascii?Q?lZHgZ/lcGfGDOUeL+XxrfIG+3eUTIbcYoIeusovMLzMpZ8DOg2fR3+1nkBSm?=
 =?us-ascii?Q?KY+C28353g7KPwbSXdS5dCajOz0xZ62K3Wk8JOPHKCUT+kNu6Z3S8dJbBxup?=
 =?us-ascii?Q?mj82KsN744oDoD0UaBY2/Vjie9vIaE7z+nXk866iWTEIOyxyx1JFSI3UyhpP?=
 =?us-ascii?Q?yJNVH6wUyFvLENL6NoHD+1+YriSBcqZExBHOjd3bHmMZe5ovf/jNvqOIiw37?=
 =?us-ascii?Q?qTarhqcXL28yMzc93MvwVi5Ff+Jy2ny+qe/ef3QzglpFYjFrbW4XWnQtw9Ra?=
 =?us-ascii?Q?YBh6QPvcmx6Q6R3oK87+dbgK8h9a0jtmDBKKyZpws6v6g1EzLwm6cUmOBFtk?=
 =?us-ascii?Q?fz3ciowCbDGfi3PCZn1ZwOMGxM1k+prEHEPwylvObBZ9MCzqFQCKjp5I/5Wl?=
 =?us-ascii?Q?D0hapw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11b874f4-5286-4df8-5a37-08db410be1e1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 19:25:49.6610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1LpBZTATXmmUE7rs40gDS2hvqnqL1OSYy84QotF3XcAvhow+6GJKqSyyrVIShbwDnkBi6tFOnNxd76vb8xvH6Xjeb2f7MwG7arH2w3ZBGnk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4682
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 10:55:48PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> A rare randconfig build error happens when this driver is
> enabled, but nothing else enables NLS support:
> 
> x86_64-linux-ld: drivers/net/hyperv/rndis_filter.o: in function `rndis_filter_set_device_mac':
> rndis_filter.c:(.text+0x1536): undefined reference to `utf8s_to_utf16s'
> 
> This is normally selected by PCI, USB, ACPI, or common file systems.
> Since the dependency on ACPI is now gone, NLS has to be selected
> here directly.
> 
> Fixes: 38299f300c12 ("Driver: VMBus: Add Devicetree support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

