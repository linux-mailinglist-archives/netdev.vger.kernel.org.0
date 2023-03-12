Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 228E36B6A61
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 20:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjCLTCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Mar 2023 15:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjCLTCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Mar 2023 15:02:31 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2098.outbound.protection.outlook.com [40.107.243.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 575C42ED4A;
        Sun, 12 Mar 2023 12:02:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JB2yQ4AeMjthHMMMpkuXE927AY+xXV6+myUNo/mNcmk+v/V7LVy6WDGxapF3nkh1a3hzhxZNSl+W0yWhkggrZCkyOQ5HKH8whznN/wKYv5o9j8AxHhMXPdvXKcCVzwFo4thLhwM+2xSBr16wlIxMF/HFOPyq6zr6sEye8U58ux8KPAzaxHof0jb5v0wV9Po2zaWptT3FWGP+NfIvjHu1SDe6eIdXIoMA41d7fnqcozbC41p6YU6MH4lPxhHlVefO8i5w8gH7eOxhgcm3UTX3UThgoqhn/yWA/CJ2TWP0WFx2AD+r+v2L7MJwLFx0ejW2AJylrooSuDKVKuvoJRoDWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z4I/VyERS/Hu+8nG0WelZcgGr/j7+KJ7m0IsT7AhSEE=;
 b=aZZ2RJ1vhSkAmS5lA7TkNMnjE3wbF207r6/vCNOE4xoAxertAl6ILsip5PnWhtHHWW2G/dwjWPg+0WVZruemDPmgQMdHn6YI67bgGQPqrfSsy+qazi0RqbEPzW4hFivLlSmsLiCYaXz3eLWpMHrlPx5lWb3Y3QkhO1l96DlcKPzo2v65YP5Cx9u0udh0JPuoqycTkMJFoFdfyfkOXEzT1qAA+xb35XvC5IIl9+96M3HeFBSq0cbNVSpJU858alj5dfy3yC/DSy9uwwrX+DFLVkGe4j7Ukea07/R9JTpcXTmpmwr9JqV7OJv9o2SsoyhRDhtQ2LNOnAeXohLLUKElYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4I/VyERS/Hu+8nG0WelZcgGr/j7+KJ7m0IsT7AhSEE=;
 b=fSOF2fDNxJALZuhZp4imfRf2WQ0svY+gXk+++vw4X47ZcUNyNwmhD9dYTU1J+IRbUewxYwVgPkZHRPz2UmmMfD0+gMK3eS82VBh1ktUBVznIpyIUGzUb7jQO7aXqa3BdyQWYA4Te+YLON3UGpSBeRHw24oSELOGuLi6OuKRS5D8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4419.namprd13.prod.outlook.com (2603:10b6:208:1c9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Sun, 12 Mar
 2023 19:02:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.024; Sun, 12 Mar 2023
 19:02:26 +0000
Date:   Sun, 12 Mar 2023 20:02:19 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH net-next] net-sysfs: display two backlog queue len
 separately
Message-ID: <ZA4huzYKK/tdT3Ep@corigine.com>
References: <20230311151756.83302-1-kerneljasonxing@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230311151756.83302-1-kerneljasonxing@gmail.com>
X-ClientProxiedBy: AS4P250CA0002.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5df::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4419:EE_
X-MS-Office365-Filtering-Correlation-Id: f01c4098-7aae-45fb-7db5-08db232c51b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1A0cZQPFTpGHCfOp2cwpAzgH/emSvJj2N34Oxet6EcudC0morIkgi3SZK0U2JCcqkg0b1aDKiv3HdfoLpHUvvR/6fn+DPhbZYz0Xt1EX4QqW6d+cA6Z6QMn3bQ6GGG4wBWDK7jP05HxpIgbTrTeqJzMglqDF+prAgZvGrT+FO1BtR99ZkmtvhOujpMNrJ88SS99ZBTpOplzUTWk3uoDPgYLjV9nhXtyEu4dhNOwQDgxQoYY/ZJYpQWPi9zq9KBX/hBJWIDeK2paZc1ipPnznjmYKvcP1ywSOT3/8VGhELba5/h69I070tYkq2oflf/ELzc6/drhc/0wEuWVUb/1JHG2GvD3u8qijJKTRHzkbBPw0jps5HpxOF5JYEcBksrpk2PVKMgiIrC3Cg7oIWy7ZuMdjxLJTBsLvjSLdkGsD7YADF896SRJAH8lsOyqRkK9hFK4AFFaqz48rqUiecC7RlzZknrJiP2CKTPywUxU8Mkvf/pLorgamisnoYlmZPAV5PHK6UZi8BQllhXcWCKgqWnNSc3xHUoR1x9mzAe94VCI3eSBVI0bIB+VGQdN9XTKQ2DaLBE7SQbIIMRG8foDLDP2xCt0gyInX2OzRqbmL+KIRMQkPWSMhvtwT02oa6vr2ZU/5uPpMbg8KYMZI8tyRsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39830400003)(396003)(136003)(366004)(376002)(451199018)(86362001)(36756003)(38100700002)(66556008)(66946007)(4326008)(6916009)(66476007)(8676002)(41300700001)(8936002)(478600001)(316002)(44832011)(2906002)(2616005)(83380400001)(186003)(6666004)(6512007)(6506007)(6486002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?60ktPShV2QQEzNOTX7QIb+MixjqiaX2t1ELBPtdEBeMu8Wl1j37iaMREeQUw?=
 =?us-ascii?Q?oOWuy42ZEUqYrr2LFXgwuOnWP0T1wO7K/M1nIqAT3FpUiKfzaiRONx0luNui?=
 =?us-ascii?Q?w16zKkTH46NXVVDqbVHa9VKQMq5T+a0B3iEejy7VC5aP1e/9BS+Oe5xLx111?=
 =?us-ascii?Q?cPrHgvcmLQVnFo8tXiG7bULpGe7M2P2RkAm7fus//WmJvm4qJ6c7Z2siQL1e?=
 =?us-ascii?Q?1U725zfw1ESCdHUXES5nWr0w2Hs3JaYbNFPhw+VI6YCU7j5VMwLrz5oKH6sP?=
 =?us-ascii?Q?F3/PFGVKTvJgTTAXIqKm1s8/9Xf1Oc763wJN0TPSZV17zsEVEGGDZ3AdbAtP?=
 =?us-ascii?Q?w8Lc0v0OrApI+aw0Tp5LWB0Q8GSS7HKd0HCkcFAeSTYUtuyvfaJ84wJ06C7S?=
 =?us-ascii?Q?hKvma+P1UXkVm4x5rih2ICxSnL3HNDxQ09s8Me6YV+vs88/HDMZ+6YYnbq0N?=
 =?us-ascii?Q?RRFs8Bc9Gi46DkdVCVCynJ1jg4/Nvb1yscV2DunTT35jAZ9uxSkEfsUAdZ6R?=
 =?us-ascii?Q?wZ569BmLsXGPwr5lKCPtjakk4ZSvLy1Q6zMEbvWeh6aPWpmP+S3wadK1kuLG?=
 =?us-ascii?Q?BdTH03COvB90tAh4RBEIMmOhZY7kOh2nBXPjCAFCwZ0bMTqx168PFVGD2+qu?=
 =?us-ascii?Q?bNHLFNfl0kt4B8MmWimH+KeKs0nGslM10E8NNJw5mBFL+2y/qH7kFDE5OYDr?=
 =?us-ascii?Q?roA/yRrBQV5YZyzBUkk5GjV14ZNTCg8QP0b213xSJzh52VDjhAosxwsOsrks?=
 =?us-ascii?Q?daDkPS+M9kil48EtAf1FnVFmjjqiOwwPUsPqM6dXAjvdxnSNXrRM7UbSGrcY?=
 =?us-ascii?Q?cRDnzYYLAI0FWYh/h1EfOG9SK3jfGtEMMgPrA5xLBMTdXeeGi5XvFbN7F+CW?=
 =?us-ascii?Q?/yrSiLTIO0jBmCUVppLHZrVL1+lFrmcItuD60UfgqxYk+VrPfbLUEz/jHWhk?=
 =?us-ascii?Q?sUv8p0jXXVgmS79L1XRgZD3dWwFuknXDejr+lO1P4xBCjc321SfMweDkl/Jx?=
 =?us-ascii?Q?r+ZTprbEP70nKMg82dbSNd0BdcpDKaxyoXctP3pZ/OUX4a2GXmRpetadxUqs?=
 =?us-ascii?Q?gvasHn10u15nZfbHN7I3qCtiiw6djMuhoQ+9a5vHzQuGQOQjiH6xhL6hAJ8X?=
 =?us-ascii?Q?rAGpvvOl487DfhGgXLu9w2w3RyK0lutLk9o/583vouRf9FPzj5om4bn9WC1j?=
 =?us-ascii?Q?GiMk9CkVYzzl+MsQ12YK4jwVmI6gsK4aa1bLnnHpqt76Qt/5EUGwjfTIbt/l?=
 =?us-ascii?Q?fnOjdJbcw1D961PqpMKORxGBz1i2O320bUh0SfYzfGN1xbEpNPBYCEc1COgO?=
 =?us-ascii?Q?6ck6m+MSD5eZnc3I/oab/8CxWkfOTXbbJOHmot9Ihvh5DacTzfXrCNf7w3Xk?=
 =?us-ascii?Q?jAHkgdvo652QTBm0HOAxQ8EE82HK4VJneE82W9cul4u1RCGCJ8z9viKTrSnw?=
 =?us-ascii?Q?WLSGsvOp6cJK4W2l4HLWqaFVOLTkn0IJhWmjfKb65OS1kHWuJnVgHev9e9iQ?=
 =?us-ascii?Q?UeEY+bCvoijlIBBx7Eshm+hw+ZhAvoJJkHNzbfKelFfZ4JzKaTpU1uQru1s4?=
 =?us-ascii?Q?f/UyiFLAnOSGOy4sMYT9M2S5TIsxkZVZCdpXcLzK2KX5cnPtPJ+LwlP4f/3D?=
 =?us-ascii?Q?FeVsQ0nAp0RN2N5j8RfBKdsCfFLU1PetEoOVaym1AzJ/DN8xo1Mx8+TrEB9h?=
 =?us-ascii?Q?cEUa2Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f01c4098-7aae-45fb-7db5-08db232c51b5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2023 19:02:26.1626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uJW9r2YaiFmudA0XH8PrbCGHK4eJAaqmSxPa6cen7R9w18mFa5MQ98mSo4YpxidkvmUQRI9fPuhULL0YI/2pkP/oRpCSriZ7v+K3KsnznHg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4419
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 11, 2023 at 11:17:56PM +0800, Jason Xing wrote:
> From: Jason Xing <kernelxing@tencent.com>
> 
> Sometimes we need to know which one of backlog queue can be exactly
> long enough to cause some latency when debugging this part is needed.
> Thus, we can then separate the display of both.
> 
> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> ---
>  net/core/net-procfs.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
> index 1ec23bf8b05c..97a304e1957a 100644
> --- a/net/core/net-procfs.c
> +++ b/net/core/net-procfs.c
> @@ -115,10 +115,14 @@ static int dev_seq_show(struct seq_file *seq, void *v)
>  	return 0;
>  }
>  
> -static u32 softnet_backlog_len(struct softnet_data *sd)
> +static u32 softnet_input_pkt_queue_len(struct softnet_data *sd)
>  {
> -	return skb_queue_len_lockless(&sd->input_pkt_queue) +
> -	       skb_queue_len_lockless(&sd->process_queue);
> +	return skb_queue_len_lockless(&sd->input_pkt_queue);
> +}
> +
> +static u32 softnet_process_queue_len(struct softnet_data *sd)
> +{
> +	return skb_queue_len_lockless(&sd->process_queue);
>  }
>  
>  static struct softnet_data *softnet_get_online(loff_t *pos)
> @@ -169,12 +173,15 @@ static int softnet_seq_show(struct seq_file *seq, void *v)
>  	 * mapping the data a specific CPU
>  	 */
>  	seq_printf(seq,
> -		   "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x\n",
> +		   "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x "
> +		   "%08x %08x\n",
>  		   sd->processed, sd->dropped, sd->time_squeeze, 0,
>  		   0, 0, 0, 0, /* was fastroute */
>  		   0,	/* was cpu_collision */
>  		   sd->received_rps, flow_limit_count,
> -		   softnet_backlog_len(sd), (int)seq->index);
> +		   0,	/* was len of two backlog queues */
> +		   (int)seq->index,

nit: I think you could avoid this cast by using %llx as the format specifier.

> +		   softnet_input_pkt_queue_len(sd), softnet_process_queue_len(sd));
>  	return 0;
>  }
>  
> -- 
> 2.37.3
> 
