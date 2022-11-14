Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43C3E627AE6
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 11:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236333AbiKNKrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 05:47:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236555AbiKNKrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 05:47:08 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2106.outbound.protection.outlook.com [40.107.94.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E386263CD;
        Mon, 14 Nov 2022 02:47:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RrSjh2kVBRJvNpHId4LAL54jqd9RnDeXFF1pVilXQUbQWZiniVVynGxd1LU5gd4jTlnAxCb5kmszrs9XVRKp7kboWokJns+LKzZ6fEqETMfYpxTYWffwm4qI6ssNuvprCV8WhInKcVvsi5hd4nYPEc/l+jfiTMvaw6XPnDH0fGylKZC0Cw+/RwtHAKaldauv2IRpMf0JawtwvsNTGnDPWDiKO0N4LZfqhSAc8tVr17bftVdbKg+iVbqrtl9U3YcazhaSgE1IzxQBKpVYLPtiVEuWsDS0gKiFhYaNJpja4Dl4vA5TIjqJW7WYGY+xbKO45TwE8GuorVWRwZL5wZ3DNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Cq6ZgLgbQMFWCMumov44/Pu8pi8t/noV+BLCUUgGyw=;
 b=EtS9HdkKnkvqsQADPF8JZCvJjWdreJlfpqm/pSvoadA3qdqVY2vZpUpazKt6Qo68Q4YwBNk0tAU5gMy0qHcfilMJlpZVGPRmwm2h/+ghwzSNXgIm22tkier0N6IiliXmdcbM6klf2IS11xDXwWr0p/JTRXO0VLP9pJQH6XJXni2OUm6W5m4jizw8XYoLg8NprWpuW/L8DoMAce2tXI1JemQ0NqxZ43FyNchf8FQIsd2x3gj2PYmTyke8Nv3GWU9+Sd2N1HOzA33IZOzKFbED7z7KIrCzGCNg4boGSw9F+mLlOFE//T/CtBmy1mi2HA+gDfgvXAQRBBxTS7Q/jzBYGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Cq6ZgLgbQMFWCMumov44/Pu8pi8t/noV+BLCUUgGyw=;
 b=fhQl90XZe9zhXGJEqT5ec2APhBhs5g/r0DyKwbMG9aApeD0bzEXUupscAMEOaXySZzvE6mPse/m90uBClv7vu5dN6rR8UVPPMc9BYm10QmomDica3nSax8lWk54iEHdf4BqpoTkXBMkFpQd0Bp/rPPTXe0dIcr0SparIdubUSf0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3707.namprd13.prod.outlook.com (2603:10b6:5:247::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 10:47:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%7]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 10:47:04 +0000
Date:   Mon, 14 Nov 2022 11:46:57 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, oss-drivers@corigine.com,
        netdev@vger.kernel.org
Subject: Re: [patch 07/10] net: nfp: Remove linux/msi.h includes
Message-ID: <Y3IcoZkLMTeJPvyt@corigine.com>
References: <20221113201935.776707081@linutronix.de>
 <20221113202428.697888905@linutronix.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221113202428.697888905@linutronix.de>
X-ClientProxiedBy: AM9P195CA0023.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3707:EE_
X-MS-Office365-Filtering-Correlation-Id: 54814a29-6872-4f45-d27c-08dac62d9139
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V3X6XsG1F6vXx5tB4oXZ8dqHiOI1f6Bb3V3E6L5GngNMiqhKMtkiQkRORik+7QK2IF5pwBVSG9P3VVwAAfLrZQxu3v9OhCm/m7E8I+46OXhehxB1SYA9q+yGPc/6Ao9My3V1bkmgM8+vhDgfVpMqw1SZ74VcZcA5ODz71gtWQs27ryU3i4k9oOmWJY7zf/rRQeGuxMs2mqc/HgZ7rtPCENCt8rYbOiZMa4oIOO6CicQwHCuODiY/8NQNpkYpykjQmquipAxlv9EOGspHxGJAqE43fvi0nrC39cewCQNJDakdPQPW1oyvYdsdcY6IyjyzDWGl6nRyrC6bp8Fb9CQKqEg1N41fcz0tHIljstiqGAwKvQ/phe42jbMVXbVcENJQWcDZOQCrnFlKUFdy9q/fxkRfOCX69hsgw5ECYc6h1GK5XDm63d7Zj4PTO5yxcHZ3EYGda9GBLr6gCuXIJXHfgTFs9etesFqo2gZpjKsigAx56PVtW6/NYRkDZeHuqd2vZ7TJzTjhohT9hP1jB6oN5AAPD3XZsHTYbRX+ZMJVEXgvXRRCnkCHRQXdSS28NeX5tYH8SqbLuGJA4gWYj3XP3L1zk+Ce/cz/bZigH6G/OXtZVV8bi284Vae65Fk0AnR4A7hBXaGfl0/G4I3AVuSAMBDbLJUDLeoBYR6TyBMRwRuAYL1uaX/xBcSE/cRqTERD5A23cefTS9Pq86WDC4XrhMTM+zo/y/1GBT2hRL0g0++hGz6Q0aS4CeKIWvXLxmzI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39830400003)(376002)(346002)(136003)(396003)(451199015)(6916009)(54906003)(6506007)(186003)(6666004)(36756003)(2906002)(86362001)(66556008)(966005)(6486002)(4326008)(8676002)(66946007)(66476007)(6512007)(478600001)(44832011)(2616005)(38100700002)(5660300002)(316002)(8936002)(83380400001)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3LIPOQ0eZNS+BCX4i6wr+AfZIy+5OrCy6GJKn3aKa8kgWh2DDtM1Ek++auzH?=
 =?us-ascii?Q?mFsHfRbTYekE3JpuBOmkqH2sEe6+u9Q5E6HtEK5R37eu4EeAoFnZH+cGBXYj?=
 =?us-ascii?Q?zRm5daozl5fQcj26XbIuHAlMS9vkMWLMZpk6DQsAJ11F2YBP6WK4chrfbC1E?=
 =?us-ascii?Q?C8t7RGy/TyZGMrfuYBTCmcb10dWWCQFH2lwq7vs8+WGVqO+TmAgYRE0AzcVS?=
 =?us-ascii?Q?NNIlju76kZZufoLU7siQvxRqSxkpuVLhIkl+/0DzaCzFs34BHW4freFpNFwI?=
 =?us-ascii?Q?gSVcAarOMXJZb8/2gNuhFvHBa6S3RhJzejzaN3M1qFL8dfLcdICQLdjO2VrN?=
 =?us-ascii?Q?wPeVsIt4btQvRf/ZxYKKKqcw/inctux+2JodFN+4Atp97F7JalAc60bRScsa?=
 =?us-ascii?Q?8YnpRAu6LTIXwpZGIFa+yV1GK3kBhEQdaK7TeZ/uWRDl/OVjT8lqVOcI7f1+?=
 =?us-ascii?Q?1zKYpX6umHGN9ZLSMsKl8SXL1oHlv8hZmAv+Q1rOToaQh0q9NpgTrjaYmHo8?=
 =?us-ascii?Q?W+Us+8VEitT4xzRfGadlB9YFZY+swAWg8RoNLDfe1fQTN4AZ8KVE76i9ChHv?=
 =?us-ascii?Q?juD8vc5l2xieVwtdhdomkuO7w8v00mFXGlPz5YIbpjig7M2UiBhaeFQW+Gn7?=
 =?us-ascii?Q?k1dfSiZWTLOmkLorDPYpT/c+J77J5YmnYkXHzcSOi6UNOrv7qqjUSZvwJxM2?=
 =?us-ascii?Q?DqWLTfXqJM7mleDow8LxatWNBonEIiGcm8IELU3zIqsxc0scPtceQ90dg12M?=
 =?us-ascii?Q?6eS+4FiF4/K7HvYKUMLezY0+ShPy9rUkZ0AFaJgnzIrZKcBMlncarCmEmgSp?=
 =?us-ascii?Q?sEjr+PPBOTgC4GwIiQd0BlYIuNavUB1/hO3AC2KhrBVEkkWOetaClpvVYWtl?=
 =?us-ascii?Q?CYJwzYxH/8VpGhBfXmmxcckcWtlvL9SwGv0Jg+F9CpCffFqSyF1Jg5cbtjU4?=
 =?us-ascii?Q?uUNbVX6fbNT3+cDhpHwAnK2h1+fg9TLzDjY+wjrC8jnnXPhZv2eAp2OBsspy?=
 =?us-ascii?Q?lO1MKcFesEs1tXi6eOIpMvO2dRG1afJyg7KeSeJY9SpHclTuhAKSbiUu+RfM?=
 =?us-ascii?Q?emvail2wJIEXmahGf6mjIBDUDalGCC4Qc3ksOKkLrn8J73p2xGCPTUTXNUVr?=
 =?us-ascii?Q?VHqr7mT659tOfwjnu22NQ3ZSW8oXoqy3j9pQSlrFcxL20HGY7HrSI9zrK5A6?=
 =?us-ascii?Q?ypP6GHA8fOgsuwEprq/QPxgU/1+wh0FjTQERyH1BrEgd9fK0/RXVY+QBklII?=
 =?us-ascii?Q?ULVJxkDggvM6lZzAWWHThJO82G20YvckbJBHYJXG6bL5SdrDhznYF4C1oip4?=
 =?us-ascii?Q?FzP++HyvXQ2S3IH34J7yzhVcmO2hmr1QLlYO+6Rl7kzJNy08T+hUfprsBJXH?=
 =?us-ascii?Q?Fphy4AaRldQ5tXZGfVINldc+0A5hPiCOMyQcFxQ5qnyDd0XXoDLpquVOdpeb?=
 =?us-ascii?Q?hQXSEgdSOsfJvgPzJ20sF3AWPH8KLvn0/CrXrR60mk4i5c7R28fb6SEebqlg?=
 =?us-ascii?Q?70gEp9sA783743F01bw0keZobtYaC01Won4uY19T2rP1QsWWqV6bI/1rJpuI?=
 =?us-ascii?Q?MxdC6zKi8UJgzBQatog/CnHmyB9cXyrD+DCV9H9QtnFYmzx4CkShXvUzWBAZ?=
 =?us-ascii?Q?RWdqexEs+mFnWJnhJoRjQsqLxfsOkKT0spThhaAHAY7JVCyH95kiHP3m3wz6?=
 =?us-ascii?Q?aO71rA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54814a29-6872-4f45-d27c-08dac62d9139
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 10:47:03.9441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l1MNvf0aZD4s3dkW4jZDtvFW1BDkoAnOiAIW/Yt7oz2wbXfvWukJwy9+GL5Ra/Pday08kA3Hids8dRaoMmmU4iWAMzQH3wPxVm47ggO2L9c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3707
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 13, 2022 at 09:34:05PM +0100, Thomas Gleixner wrote:
> [Some people who received this message don't often get email from tglx@linutronix.de. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> Nothing in these files needs anything from linux/msi.h
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Simon Horman <simon.horman@corigine.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: oss-drivers@corigine.com
> Cc: netdev@vger.kernel.org

Acked-by: Simon Horman <simon.horman@corigine.com>

> ---
>  drivers/net/ethernet/netronome/nfp/nfp_main.h       |    1 -
>  drivers/net/ethernet/netronome/nfp/nfp_net_common.c |    1 -
>  drivers/net/ethernet/netronome/nfp/nfp_net_main.c   |    1 -
>  3 files changed, 3 deletions(-)
> 
> --- a/drivers/net/ethernet/netronome/nfp/nfp_main.h
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_main.h
> @@ -12,7 +12,6 @@
>  #include <linux/ethtool.h>
>  #include <linux/list.h>
>  #include <linux/types.h>
> -#include <linux/msi.h>
>  #include <linux/pci.h>
>  #include <linux/workqueue.h>
>  #include <net/devlink.h>
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
> @@ -27,7 +27,6 @@
>  #include <linux/page_ref.h>
>  #include <linux/pci.h>
>  #include <linux/pci_regs.h>
> -#include <linux/msi.h>
>  #include <linux/ethtool.h>
>  #include <linux/log2.h>
>  #include <linux/if_vlan.h>
> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_main.c
> @@ -16,7 +16,6 @@
>  #include <linux/lockdep.h>
>  #include <linux/pci.h>
>  #include <linux/pci_regs.h>
> -#include <linux/msi.h>
>  #include <linux/random.h>
>  #include <linux/rtnetlink.h>
> 
> 
