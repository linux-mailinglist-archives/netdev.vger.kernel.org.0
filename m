Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380486C6C89
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 16:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbjCWPsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 11:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjCWPsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 11:48:37 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2121.outbound.protection.outlook.com [40.107.223.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D81590;
        Thu, 23 Mar 2023 08:48:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CZmUOfOsKqHMg4j9xF2aIknMsDIKLWYmTf1yYBsgVdRTHMevvKO+KD6Xe5t6zzTHGUXgbiUATGtV7jUZLCyvc1YV6FOKHSjihlSTbDrIVvobb4SNde0ZCzOhUk9R+L4kEpd8W/LiqeokePhpM3qk5ZLqvmDJ3gmo9AvgtxuklbwqhiS5yDce2ESQG4HKvBb6SI9/wILdYdN3JEW10wFs/9xAdE/mBGacbB9bKTCIteesFnifkkp76qE84ixYU18BdZBI4GEuHGbHhwEcPLyjvQDqZJVQAXWUW8wc9NvzmivBlGK3/KQR7IL9J+M+Z02LdSt0UaONi8H/zbbSi3vsvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q8FnoMTeLMXtYBa3/zdatvhWV36G6eOwWQGvpi+giG8=;
 b=C80qubEQzLF3Ekf4TjVPXqtA1dB98mS1lS1z640lcEJBY+40l91SUyQB93g/I87ku1nj5Nr5TTvWpmei6e1pur/zHOXTNPVWXdicW62KTQN4CXLOkgLkZ6yBrOdgEkZrD7j5zQO6MwHeltgaFi9JRc0/LxzGyzOXN+rE/Feamxj/zDacNgYm4Px4BfmDZNiIDA4BYpWcw41RDtk0+Y2JYkRvjRsHp5hI6gLzCoeUctw/rFzkXVXqc9sKo0Xuef+5kL4a1pADfwMNi0r8WIQIY2LRh0SUQdYKi+6jfrV4PfwXjriR83MknanzI5fSToO67QLO5rqR7UOG1larL/r5ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q8FnoMTeLMXtYBa3/zdatvhWV36G6eOwWQGvpi+giG8=;
 b=iL6jac8ydZpYbLeOzn58+zcSodTi1tM84/pGvU6l+2b8JNVkCDzsU7J2dfNcZIw6axiDQ362kiDREtCEpOLGijXDX1NuLp2gv2piWI3NoJVFDPjaC8jP0njGBWlNpJAKDetm/dMIKaeBg3TAYuAmxy5O8w+0PLnoJOIgteXnbZE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5612.namprd13.prod.outlook.com (2603:10b6:806:233::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Thu, 23 Mar
 2023 15:48:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.038; Thu, 23 Mar 2023
 15:48:31 +0000
Date:   Thu, 23 Mar 2023 16:48:24 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guolin Yang <gyang@vmware.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] vmxnet3: use gro callback when UPT is enabled
Message-ID: <ZBx0yD9FkEVwZ8oI@corigine.com>
References: <20230323054322.24938-1-doshir@vmware.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323054322.24938-1-doshir@vmware.com>
X-ClientProxiedBy: AS4P189CA0034.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dd::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5612:EE_
X-MS-Office365-Filtering-Correlation-Id: 1aa71165-a4be-48ae-693f-08db2bb60d6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0pB2a3CsdJAj96VnzkoINliOYsmPntN1DgIRSH21AmMt3OreVjHjZNZDShvsgnlwMjr5PZd0JGezlqUS6U7F9hzqEoqccIG4dxNHsChV4PB59BOO6YTJN5YyaNx3K+IaXmipmAmPVHwd3kPkHDVCiD9SxbgQyWB6N4XWTmBmnglwfFIF3+AZvM/FIrei2GfWfav1oaLRGpi+QSpKwFs9zACJhC2t1BGzIeHEJGiiSHI+/fVkyOyo5K+wID9MKTnovsSyWFg1Hzk2XeNELFgNacV+OfbqzoyDkwomAJfq7+K3nL7oHoAk34jMIjN5iz2Hxc1chy4TKhztHKcdhmifXy9TelDK7g3Gv1Ddop+Qy+2X5qUCsEwtRd60jly71uoOvBkRWahY1/z+itSgQjNdG6p3PL0SPXVBc9QoHnn+1WY4biltIWvEISYeFd/z1c8uZYc9JkegKEk544AaZeeoWwP71Jx3FyEclccbhwhEnyH3pRXPNsrvIYto7TqiBcKSYA3Wu+Z4tKKkC1TNw3F2F8koNvB0g+XDpZGf4iH9krLWlOO3w20HdrCyeeuaT2fKGvQz7QJDDl59aaJFVtcQDkbno9CPA19Ev0sfEZ1un9O7VjMCE6qssrWdwqpwMDq5suk9lkzVJiBfPtL7//d1SZw7s6C8UKcOBCNSrSDmjwjS04/6trRsFYFjOEKl0hRy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(39840400004)(136003)(346002)(376002)(451199018)(6512007)(6506007)(5660300002)(7416002)(6666004)(83380400001)(41300700001)(4326008)(2906002)(316002)(44832011)(2616005)(54906003)(38100700002)(66476007)(66556008)(66946007)(36756003)(8936002)(186003)(6486002)(6916009)(478600001)(8676002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3NPBCxuEeOCcn7v71VyPnabCpr/zcBtdFlo3Tp8O1bXm0y7xTmqCgz9xyt0v?=
 =?us-ascii?Q?rkjVkFTNGxKzYXlfLmXO+oS1bNHZanbAleSiWlKp7Pdy4joEkRFRQuJD2hXv?=
 =?us-ascii?Q?vHyBqmI2Axo2J28V84BndMwL5YRv/93C7Rc9r6U3ziM9RcFhNr/RtbirGhcp?=
 =?us-ascii?Q?evPoMuebEWEmlWpRnQzolEXmfVwFZHlYWb5Hci2QtX8jnkWKKpzHqQ2oPiZW?=
 =?us-ascii?Q?Otc9OUTGpTuA4NWJNRcZDSZssZ14zwyoETjtCJjdn1tU9ur8H0BJlr1TnWN1?=
 =?us-ascii?Q?eopCvWzsnS3loz2LTxfaMMunKizqD5JelvfGaVrOvrW4ot+kMRJh7wvpIbIv?=
 =?us-ascii?Q?EvtmGn8dedu4WsBnXHrwACNopB3mtlhTMzSqEGoT6UfE/IU4a0J2vgH82V4g?=
 =?us-ascii?Q?Ix+ItrU+4nxwoczxpK9a7FyFvKTxk6/YTVPaJeld2Eva0R9rHGoM2F2uvbz8?=
 =?us-ascii?Q?xpJ76+L/JXX7HU7hyeWZ7B947DhpU3bkAjxfCKnv72+fkRejzpZ2Fm6TyU36?=
 =?us-ascii?Q?UOgk1bdjH5yVeWyXqU1qejpcaWXRSkMQy478hgj5VCj6VnCO433xmWL98Hn+?=
 =?us-ascii?Q?J9J07u/xFazyekRRhJpV28PW9jhiSBi6EHVUns5I29i3p2r0FT35npXkqfoi?=
 =?us-ascii?Q?PbXUW4AjAw9Lmx/Gm94iKN67zI1grZJmqOrD5oo9zp2k070N7bgwZsPXsZwk?=
 =?us-ascii?Q?QRsH8JD+TC1kDis3uMVJqNPePd1IKaEU7+myd5wEVg0DRsyz3oniXxyTKhdy?=
 =?us-ascii?Q?xS8AbXyOfzBvRYA99Ujvgh9KtJnVcbfEU3s14o9hjGdBUF2mOvvsBfuI0DD6?=
 =?us-ascii?Q?l4qTFKZXwtNiVhLve754VjSTYF397v6b6bXYx/0BqWFQ5k0fH2OhWcp57O+u?=
 =?us-ascii?Q?xClwtXAt53qr1mLDFcmhWDNQryZSnEOhhzV7y8QB/fSzyR25r/lRfwa99PI9?=
 =?us-ascii?Q?PLksLyVeVHLRzyJNwuF+O7YPeutacbPLdua+FfTqFAua0ONlhLqo3sU1v7jJ?=
 =?us-ascii?Q?K79y4l0n9zi9J4uMzNp8Q65jFNplrpQSTRkG4/fPFDo6rl+kJGrVov0hDedq?=
 =?us-ascii?Q?F3OoD4XfGZv+ZSMXl0mloJXnTMHLXTypiAWoVtOlr07FGCkV7m7RecE6vVbV?=
 =?us-ascii?Q?c6rI71dbFthoSUdW607CHbhPpNUePkHK8GCN/FceDUNAOZ8ulAWRYxZsz5l8?=
 =?us-ascii?Q?+YWS+SwdLPTtvBANtZBrM8uQLSL+9lEHF+kUX/hUrFlMHvt1apPMll6ycv/z?=
 =?us-ascii?Q?+xsRtZR1yRRa/RC4CrGH1bo5PE4Ula8uFG9Uj2J1zD6LUiLwX2IY17ejJDap?=
 =?us-ascii?Q?mxaiUvEDmfCx9v+GAAhbLOF4ryI/DBnIHjW+g5+qDH361K6PaPL4aoAFxfP4?=
 =?us-ascii?Q?TWlGNXuL06BKXfn87C3DwCtr2/bUK+kVfqNKoqEi1vdYQ/cnbJ5IyQV6x+O6?=
 =?us-ascii?Q?sdk/IpxTKjzc9YOHOzCS1uDBmCaRgKogKY78VZT7qGUDIUDNafaskJEROvus?=
 =?us-ascii?Q?jkqWcSKHIoOFSzHdRY5BaU8DIf+H5hvfMRPESh1oBQtsByd//wKv769OOdmU?=
 =?us-ascii?Q?2k7Dk8lseVGG20RnpghJ9wcCxR4RpGQFUVyads+BeyqvT5A0Qwe75AHk/z7W?=
 =?us-ascii?Q?viQUasr7JRNMMFbaCi7G6aFdx+TiEa2CDP5e2m/w0BDFtfNTafpyJmLifrTO?=
 =?us-ascii?Q?39H2Cw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aa71165-a4be-48ae-693f-08db2bb60d6a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 15:48:31.4207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Ne8lKe3i21A/wVFUV+ywyyqUuc67mGyd20rIeOKWai6kyLc4dqagUhcPqXUt9xlHbDZX62VWt1/+jqrRgJKF8dhjDmx3+HfXpCgzRoHWJU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5612
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 10:43:19PM -0700, Ronak Doshi wrote:
> Currently, vmxnet3 uses GRO callback only if LRO is disabled. However,
> on smartNic based setups where UPT is supported, LRO can be enabled
> from guest VM but UPT devicve does not support LRO as of now. In such
> cases, there can be performance degradation as GRO is not being done.
> 
> This patch fixes this issue by calling GRO API when UPT is enabled. We
> use updateRxProd to determine if UPT mode is active or not.
> 
> To clarify few things discussed over the thread:
> The patch is not neglecting any feature bits nor disabling GRO. It uses
> GRO callback when UPT is active as LRO is not available in UPT.
> GRO callback cannot be used as default for all cases as it degrades
> performance for non-UPT cases or for cases when LRO is already done in
> ESXi.
> 
> Cc: stable@vger.kernel.org
> Fixes: 6f91f4ba046e ("vmxnet3: add support for capability registers")
> Signed-off-by: Ronak Doshi <doshir@vmware.com>
> Acked-by: Guolin Yang <gyang@vmware.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  drivers/net/vmxnet3/vmxnet3_drv.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
> index 682987040ea8..8f7ac7d85afc 100644
> --- a/drivers/net/vmxnet3/vmxnet3_drv.c
> +++ b/drivers/net/vmxnet3/vmxnet3_drv.c
> @@ -1688,7 +1688,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
>  			if (unlikely(rcd->ts))
>  				__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), rcd->tci);
>  
> -			if (adapter->netdev->features & NETIF_F_LRO)
> +			/* Use GRO callback if UPT is enabled */
> +			if ((adapter->netdev->features & NETIF_F_LRO) && !rq->shared->updateRxProd)

nit: this could be two lines, fitting into 80 columns

>  				netif_receive_skb(skb);
>  			else
>  				napi_gro_receive(&rq->napi, skb);
> -- 
> 2.11.0
> 
