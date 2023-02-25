Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7386A2BCB
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 22:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjBYVID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 16:08:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjBYVIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 16:08:01 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BEAD50D;
        Sat, 25 Feb 2023 13:07:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n82Qsw5KwDNZYHM5G23YL84qQ5Hf4whnkkwVZfrNstR+NpLqyVRbPVDSRjoOfnx5SiWNrc3P6BSirvXTOzby+RULQ8oyHeW30pme5MhMJ4SlqSr4LjEW8VsSdRsDF52BTOdj8GirDQQdQ3IRk/BJN/zK+ASj8KDpXt7ZjeM4A+wzzN/S39g8l/JoYWIQFwO3EIcjWvb+I6iYtd4mjxpN5q8jHxewnDA9n1PqAWB4ipzURBktfEQZ6bWpywtzZf4oxvylSUNIa9KzaWlg5AaFo7rEzqGWgebCjiI0FlSrud1QDB9+dx8D6M2S3JTwEapUecU3zQWqOZFTdM+ydzAyGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sqpA8nNCTpkEpjwhlaVpEM7CSivsTStIm0dqU7pj1/Q=;
 b=gWuAIjyJougJPUF7gAsS8pG9WFaV8sXi3yK3DKEe/zbaaQyurSeWbPdePyG60WcBSTI+JA4+a1lrNw1tSbTX5XciHPR6YvWRoufpXZq3yc895wDLLNrWW/8AeA+VioU4n+BPF0akTqj8PXQLhYx+7tthuw59gMFo2lk364EFkWDMtD3WkYZmkD9StQHwscMg+Cffvwo2Q1SIbCMhMIzspUy2olczOBZu0MFxJqFxvtdPovRFzyehngxbYeseOq+Dbnkf4mn5VbZuQOejwI9ModAWDOC9nkaSRLJprRkDTN33yPZ7I90C4MFm/JZv5is717X6JAnobujjCcX/6f4HGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sqpA8nNCTpkEpjwhlaVpEM7CSivsTStIm0dqU7pj1/Q=;
 b=cQ61cK3lRZOVs2XAejdutrMVfEdvHUIV2LlnxUGWm9RHYwIiT9mX4Fx8Z0ZtAGSg5k3kZJ1puwvm6uX7tQNuRMihP55IfuBuwHS6pVOjRkYg0BOuPKLqnIzYKCnNgr2UVYjvEOLd1QD1SrYJEMOV3C9J7Y3R1M4e68AsG1tiSNo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB4552.namprd13.prod.outlook.com (2603:10b6:a03:1dc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.25; Sat, 25 Feb
 2023 21:07:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6134.025; Sat, 25 Feb 2023
 21:07:54 +0000
Date:   Sat, 25 Feb 2023 22:07:46 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 4/7] net: sunhme: Alphabetize includes
Message-ID: <Y/p4oiP8cb+M4j9X@corigine.com>
References: <20230222210355.2741485-1-seanga2@gmail.com>
 <20230222210355.2741485-5-seanga2@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222210355.2741485-5-seanga2@gmail.com>
X-ClientProxiedBy: AM8P191CA0026.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB4552:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e6e2f6f-880b-4ce2-a081-08db17745c18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HswaPms9fmH4sl0ucnFdVlSC+lqhkdKXwktzi3TEH0VKlkM21eNhlcWRZEWa561LJhy7F0Ed/+KilZATBOqh7PwGcvwYvvbHBQ9Kz6arCzDtKT1uJjKMgRLTzopGbzea3UMkTkhghKBV+0rtnWcCpEn50NyPn4KZdgxrPsh448hGMA67F/lUQL+7p756KkeeAR1j3gtbmcPYYERcBSjfBD5armCBhKMA9WdKDs9KdoblFOP27wUHlvx57GUR7InR4+IWK44mLb54lT2rsdsUOertdN073GmIa74X/WoQev7vYC5WnceQnIaEIXIQBCRKfxPDSSrauy1h/VS7vSxOXr5KtW/o5VtSLbsXe7lAvRH4/2zJWTqVdxUz3QqPqjQaT1XGXt4YTh/hyGrKgijwHK8595EUjXcpiMbGD1A82U9Wdt1VcOgrmvi6M5PHia4HBJizDXmLmUcnSc2cqSL0uA4ZPAIcckK9CTyEthMT4SCHtgztGNHCAXqZP3KR7ctPy8zWz3ZdbnUow4sSATdiMRRcmC+RY6vlI6bgdlH7J+IDKFXs/mS0SwGWKnxfK54Ov6nAi88uT7ECd0ub9UWPtByJD4sC9l875t1ksf0S7A/XJN+0j6sWwcertrtPHOZ+pwajnJZR5z2al+aQnYgHdMo3+Tcj1sZpAfMM/PBgCLtDwR/ebsCRg2pMRX3M8feP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(136003)(376002)(346002)(39830400003)(451199018)(6512007)(38100700002)(6916009)(8936002)(66946007)(66556008)(4326008)(41300700001)(8676002)(44832011)(2906002)(5660300002)(66476007)(478600001)(6506007)(6666004)(186003)(2616005)(6486002)(316002)(83380400001)(36756003)(86362001)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W6L+Ea068w3kiaie6M4S/T9uD1IYVRZ8WVHM/6xXZqO+DpMnY+DL/5WSoeNn?=
 =?us-ascii?Q?WpYZxqVlc314snZxYNTtbs30Tk1vFrRFLtAUGJZ7w3/7/PS2vMwUFKodQfqZ?=
 =?us-ascii?Q?6FGl+oKdNhd8YYB10i3KSHtDlGsnl0HVwKC97XGIFQBT6rUYpyUaQxoeXk3+?=
 =?us-ascii?Q?L04YpBT2gjHzuVyoTi5ZfjBQbl09cNfQ/4GrKWdkrik0+QS9D6GncGztUC/Z?=
 =?us-ascii?Q?VEVZLa79mwVMQlaF8NNJXV9aPlRedK0I8JesMJPObG8wHRthWEBpLgysCPLO?=
 =?us-ascii?Q?lnUCA7JsjY0SuUFGEUypjLMrpEsijrp5w+wX6+fm4hgWnyzX4bom4G6ivO+P?=
 =?us-ascii?Q?0jOD4XpDWL59d01JUgQsAvnpnHeBf1EADV7d/WktY0ydB6qrnAZbMxlYUiQX?=
 =?us-ascii?Q?T7WBMQp0mgy4m5M+rjI9rTWyMVDoG/+0Qyks5BnU5e+gJeWfkm31Q8e/SgMR?=
 =?us-ascii?Q?GaHZ+oPYkcT2LvLmehzMcH4o3JJvFhMMJ6mzJHae2oEwEbhfHucEebhZto5x?=
 =?us-ascii?Q?JqFnO6BkY5bUI3BYcdDl13QCM1Fcbzn/89H/YvVJQKEnhcMDhkRBlAKgNsKb?=
 =?us-ascii?Q?PVcSYdlQRXiATNB/DlKShokvOW13trJYjhOLRlwoxDLxisK/ZSQGoCN8fosj?=
 =?us-ascii?Q?GFdsnVniie5tDyMJmp5eV1I3zauEzytP+VJf7h/1BvfT8AdNU0rrNp0lw9uw?=
 =?us-ascii?Q?dzh8RJZjv7AxbqD6gHA8rE0XpO0Cax/QG2VvtpCwQATPbeOS5qnCvIJ65gHE?=
 =?us-ascii?Q?VCcRmed7L8hDdGVb9unJHZHzK5esnuI5aQBPWMxyZlB6UBdT+Eu6U3prr985?=
 =?us-ascii?Q?zttBu/zMiLsHi9O7yJjYpMu0ULQNi4Cnk9k6YDY92ZOpJoANXpHxw7gHXa1F?=
 =?us-ascii?Q?OzeiGj8OneLGu8XO3M1Lo/lceTK5NXj+Fk+DwA5o6auhcJiAmDhnVkLPzCkG?=
 =?us-ascii?Q?mJwSuWd7Wk3aAsz0qGA08getVi6pLAeuVh6v1YUmMru4+ghv48N6EwJARmZe?=
 =?us-ascii?Q?DS1QoKiivNzBgNV2fJ6Gh2+V1Usr4xasck8Sk6q+I7X8LSOEsBEdpCRPDtLZ?=
 =?us-ascii?Q?b6MKXO3EjDN2fq3HH7mCZbyqw7kPyeWsuse+MPpzeSD7Wwq8Af0fQhkf7+ap?=
 =?us-ascii?Q?ElwU8MTaPmeDSInLRbP0dsNxsowVyQYbOoyi8b7sMVGHqbf5xg9spddDdHPQ?=
 =?us-ascii?Q?5cVEy4w/nNw0CkYyS9qvVMNT5ILSI56qN62Esz6ORwP2LOOWM/GF7tz+avB+?=
 =?us-ascii?Q?GjqReVTz2ob2byv7R1egXr0kIgb0Zl1T4oB7tXpD5C3GFE6y4TGEfEzt/oRl?=
 =?us-ascii?Q?BId/H9VlXXqa2CrI9ysnv1Y3wkNO972VZ+GInFZGuKxlWLmfR8alO+m+IWDT?=
 =?us-ascii?Q?i+DgYLajO5dePlDRDzReJ6wKN3zSyudaPMZTqUsr3jG4UJQXcnyavGCSB7/a?=
 =?us-ascii?Q?3THBVdKCbORpYr+6fzivbgvzKiYA1TMeyBg5ykdqJU7eNDSaiuUcOcqQNBxb?=
 =?us-ascii?Q?GqbtYXTReYVEUr3iAbvel2a1NkMzOQwVX93XceItC8RTVamDT/gOZ8dAaJu+?=
 =?us-ascii?Q?86p3IfGzNq/mIIU64JdqUBLjBxYr7hdaOTQgzcevd04jSVUe35WzLtuXvLBE?=
 =?us-ascii?Q?vtND9+Tx6/zFscXgXtsAg3879q8jhzJcbKSPOUA+jX+ibtGRpsbsyW/fA3cR?=
 =?us-ascii?Q?bwbc3w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e6e2f6f-880b-4ce2-a081-08db17745c18
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2023 21:07:53.5725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: luWsIAPcHRV82nhm0PwVcdraksGhzCfINchEZLmK2MPuK5ZCSoKF92So08SmWx2HdqBjyiH68oj7HS6H0KiIxENpSBYOvYO0Hmn4CMCrGWs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB4552
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 04:03:52PM -0500, Sean Anderson wrote:
> Alphabetize includes to make it clearer where to add new ones.
> 
> Signed-off-by: Sean Anderson <seanga2@gmail.com>
> ---
> 
>  drivers/net/ethernet/sun/sunhme.c | 45 +++++++++++++++----------------
>  1 file changed, 22 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> index 127253c67c59..ab39b555d9f7 100644
> --- a/drivers/net/ethernet/sun/sunhme.c
> +++ b/drivers/net/ethernet/sun/sunhme.c
> @@ -14,41 +14,40 @@
>   *     argument : macaddr=0x00,0x10,0x20,0x30,0x40,0x50
>   */
>  
> -#include <linux/module.h>
> -#include <linux/kernel.h>
> -#include <linux/types.h>
> +#include <asm/byteorder.h>
> +#include <asm/dma.h>
> +#include <linux/bitops.h>
> +#include <linux/crc32.h>
> +#include <linux/delay.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/errno.h>
> +#include <linux/etherdevice.h>
> +#include <linux/ethtool.h>
>  #include <linux/fcntl.h>
> -#include <linux/interrupt.h>
> -#include <linux/ioport.h>
>  #include <linux/in.h>
> -#include <linux/slab.h>
> -#include <linux/string.h>
> -#include <linux/delay.h>
>  #include <linux/init.h>
> -#include <linux/ethtool.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/ioport.h>
> +#include <linux/kernel.h>
>  #include <linux/mii.h>
> -#include <linux/crc32.h>
> -#include <linux/random.h>
> -#include <linux/errno.h>
> +#include <linux/mm.h>
> +#include <linux/module.h>
>  #include <linux/netdevice.h>
> -#include <linux/etherdevice.h>
> +#include <linux/random.h>
>  #include <linux/skbuff.h>
> -#include <linux/mm.h>
> -#include <linux/bitops.h>
> -#include <linux/dma-mapping.h>
> -
> -#include <asm/io.h>
> -#include <asm/dma.h>
> -#include <asm/byteorder.h>
> +#include <linux/slab.h>
> +#include <linux/string.h>
> +#include <linux/types.h>
>  
>  #ifdef CONFIG_SPARC
> -#include <linux/of.h>
> -#include <linux/of_device.h>
> +#include <asm/auxio.h>
>  #include <asm/idprom.h>
>  #include <asm/openprom.h>
>  #include <asm/oplib.h>
>  #include <asm/prom.h>
> -#include <asm/auxio.h>
> +#include <linux/of_device.h>
> +#include <linux/of.h>

A nice cleanup, IMHO.
But can  linux/ includes also moved out of the ifdefs.

>  #endif
>  #include <linux/uaccess.h>

And, perhaps it would be nice to further move things around so there are
three groups of includes:

* <asm/*.h>
  - non #ifdef CONFIG_SPARC; and
  - #ifdef CONFIG_SPARC
* <linux/*>
* "*.h"
