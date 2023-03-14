Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4886B92A6
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 13:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbjCNMGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 08:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231782AbjCNMGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 08:06:02 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2109.outbound.protection.outlook.com [40.107.96.109])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AFC9A0F21;
        Tue, 14 Mar 2023 05:05:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mOITzPUNq6/36u/b4/HomS6j+Mdj+XjAQBqKy6fd3DbNFNu6mz46vQQYHvDBzAfgy3+adEb25n15dfpdUCEnVADg1vz4NcLS/Kl8wbn4vCe3qNN1nCCirDBvy3h+hGtSydg30IIpMis+uHi55az/X3kpLDipwcEBFXGcuDumt5FpqBV6AR3WuFujYWXr5IgE3WdbSB4aR8HeH4LfXS633Qu3m7Pxlr8DYIiZjEdkUqcMsLaIRKos8/USLJ0J+SmcmDz3wLp0SZa8xRBFy5iGtDCsMumCEGcsSfGVY475tvygH09r2vNbUQl5qTUysUc9eBHbBSzDtlUEkt9KDXMOPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M0d4J5seEdmso+FAC9E+LZAoKw+aiVCGoVOeiSX7o1A=;
 b=Qm1DTQ2pznZ5P0KzUmGwtD7rZcBaIY9w2GAze750qGFiqpfzJKzAHdNlQbXgefSNheq0iiZq/+bpZN+g6bXIbhNL0B8ULOx7p9+tz5Onc5NlScWWFKNTiwqy6pPP1FItRravolND+wGK4B4ZDBIX6Q4fSgI+zvLJUN8q0bUP31lqE1EG5PhtcaNhrrOWCbeb/RRSKRhY7rKYDpJHKjHmn2ZB19RvMGxFrkUg3DTOHIca5iMi7PnTILUd1GrC91BkozsgPMX2I53F0gShZE6HkcIMHR2bCq82UGlZvFuuhPZwG7q9MbbDu/8fPzzb5LgcjaWXiRpAYwmhMxdbYGucwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M0d4J5seEdmso+FAC9E+LZAoKw+aiVCGoVOeiSX7o1A=;
 b=pSpK15YpGSM2J5LyjWFWRqz/SDmShk4NKqmOHOatSYG2AHF2tGvi2JBASKgobL5FMT6S9l07cBajyzciKjqPj1CIs07nbbWGmDUWrtqy+vGH+muk0y+x/38icUWgqWoNfYTf11mR02YNeLjF3Okw4MwnPzyF0f8TkZAmy05WMys=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4743.namprd13.prod.outlook.com (2603:10b6:408:12e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 12:04:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 12:04:06 +0000
Date:   Tue, 14 Mar 2023 13:03:59 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, sinquersw@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH v2 net-next 2/2] net: introduce budget_squeeze to help us
 tune rx behavior
Message-ID: <ZBBir/hjHRJz6Laf@corigine.com>
References: <20230314030532.9238-1-kerneljasonxing@gmail.com>
 <20230314030532.9238-3-kerneljasonxing@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314030532.9238-3-kerneljasonxing@gmail.com>
X-ClientProxiedBy: AM4PR05CA0018.eurprd05.prod.outlook.com (2603:10a6:205::31)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4743:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fc8c662-6fab-42de-60fa-08db2484363a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 19piSwpt48sc8YEdvfeE6lXziLmqowC+vEJ2VtVcDCZ6G1I49ui/EeNXGsS6QsRour27wxXRZy3KeR+jscUVuDldkJaIkT7x2p8MkAjLQMou1ZXHSQzJ0GnCiw5evdesFHvmOxxM7jxYDK7HBJ6lyHGGSW4W+84M8Xq9fD+l+PV6GF+9pLWo2nZiHsZXnke5G+R4Ode2x2RXub0nxoMHb37VwvZ8VFvLfTvPUqUBS9VAhf/DvCDtNh+FkR6pXWbOdganeJWmDMC4VrTA75kQSUMcpGX4VrXT8qU8D6SIBKpTlD+4+PbhDctmeB8jPKATRDMoGmL75POk4OR141rqQE3k55lfQjZ/NQuFge2WHjPegfgeJZkgs/2c1F1qBNy9h9Jp3WIVUlkrcv4cHZHUsw5O+b1+INPfK5uTO9lyBpMKHbPLDLLoidBGbmtclXi8zdRpsS3Rom9ttFWcE09K4YRi9ZB47V5IqDyRIZGWj4oGu/mjUPDW2tISzr0VHDNoMiTuOR9JpHbszFkaRtLM42BrwZ6AqyohWLWRFu6ffv5kKLZHs+5154VtuOALgkjpVQ5E06tMPr1w3R9hctkQxFUysMra2kt+s12RL91EknezjiA9+00K5fYDx3e0P4Dj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(366004)(376002)(39840400004)(451199018)(8676002)(36756003)(478600001)(316002)(66556008)(4326008)(66476007)(66946007)(7416002)(8936002)(44832011)(5660300002)(2906002)(41300700001)(86362001)(6916009)(6486002)(966005)(6506007)(6512007)(6666004)(2616005)(186003)(38100700002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dSIXKf8Gh39yIrp9oTQP2V2wRCGqJ4MWlOXNtThw81rImREMahuho8cAevMO?=
 =?us-ascii?Q?lEuQo8rcPHilMM8tBUGHUJV7Xk24UvBoIecvZMz1wqcRm7HHYSg6724YEnYK?=
 =?us-ascii?Q?zsztFiRVHErVQz9cvNkcFDRnLsY1yA5MqTHeKC5V7TDIm6D4xOKeOHHQN5qH?=
 =?us-ascii?Q?FX0JtX3dqIyPq0LL7XoLGEWcRHOWOOWQp2/aexElneH+GcjHLjKA9Mm0RT9A?=
 =?us-ascii?Q?EVVx3Fjz8QFZw7ba0oYx+eM3Qv0/XtJObEKCIy4hYBdl2Gs2eUYQ7wbnas4w?=
 =?us-ascii?Q?Zz/IqJ31H5olcf2WILFJQvJvSvByENsLBf1uQaw9mRo6W4q2Io0yJi3Um3AR?=
 =?us-ascii?Q?01wcGzf5KCQPzOWCSF2TcOhwr6cDlb6Jw1GY+oLnRB7+gRtPSqkpfNHD12Xr?=
 =?us-ascii?Q?Gs1IEnC6i18m3WVU9q265KbcDC80PU6Y9sIrOuQo7NpKck/pXC7fQtjsxF0H?=
 =?us-ascii?Q?Sm0SXoIKendqglm7Nm7qJAXMpMJ9htPe4nyKnpUQtf2LMk9bqByb0xoWqU/N?=
 =?us-ascii?Q?cmWEPRabHna5EFVPObVHnByKfyDVrjrdd7wkeo9lywfPlzjrX7xGXUwB68xW?=
 =?us-ascii?Q?ePGmQaJhqqeyaU/33vR1vV9m8jd7T+eAZRN8KOVRzoCnsXLBUyQmbdd5bQW2?=
 =?us-ascii?Q?TOamfEymKGNt2Jx39fLJJFcLLW9VYBNSAr9eeBPhlcJf3YmGgwsKGXjSeVl5?=
 =?us-ascii?Q?uHcOX4mZf2T1aUsnsKelwWc0YMrY6CWLf1ItqY9nlied9E2kCIOwJlXNb/WQ?=
 =?us-ascii?Q?2749GwJymuL/84VsyB09+vq/+sepAnoy1F9nCsrHc0OQHiUX31+h+cG5PH2b?=
 =?us-ascii?Q?ra1V18S8mH5gmJF0yHwXISvAtxxIbAe2sWfobxtZgG7zLsqOXd+totOVXJ9F?=
 =?us-ascii?Q?xiwScOWtga2VG3gPJd00DeqiZaTXmXONqlOfCckx4asuSGdn21x6Pq99Cwny?=
 =?us-ascii?Q?M2voMyHaA57H/59HjtyvoQALCpFnVNH/Vl4ugNlrTQI7DKHw12XUeX5N9CAZ?=
 =?us-ascii?Q?JFXrGuXBq4ahVa2QjYeTfGhgFIPSKCphiFkP2l2awbQhZK98OdLzqzVSqx0G?=
 =?us-ascii?Q?JvnAnbSn+ts7aHundqNqaEg9jfmCwLj7DKT/ucX3F1nww/FF7d2JJgn4vK0u?=
 =?us-ascii?Q?genv0SACZ0ieueZyemf00maIiOMaahQEfMkEhroHybBYAEpmibQG1UlhDk93?=
 =?us-ascii?Q?lcmskpix0RinVu1xNBBMObIjJDVBlwQAyBRBp7kLqwHmT0kloUbeghqW3klx?=
 =?us-ascii?Q?1awx+0TQ7zRlbEyBBww66AwN2WNUumxGf009nlV6Obnz7WgQoqmd70Z9FVyk?=
 =?us-ascii?Q?aHRNWIk3fGzpM8FaBSZJOn9Z/r5QPoVfz0FzIH7jHOFfhM1oD/neqmDUQi+X?=
 =?us-ascii?Q?zZ1qTS/7xHb4eRzM75SzyIU6QWsLNT9hUVNzuP7Sgy+NH5Jclu3Iy5y+9uP0?=
 =?us-ascii?Q?4gRU+yVOnyTqrvaiWSeYCRjc49tBlNes9kC7hdORIA3hFHfqFIu+noYiSBPZ?=
 =?us-ascii?Q?/kG3YsnQuqoLdnZlNB/8+YQjSj5ps3Kq4aqVtCKD4F5U7Qy9608ngkx/dmdm?=
 =?us-ascii?Q?R0WL20IaxZqNUffjy+vg3JxUCCCBiK/Sx4ID6XUK5uCtoifKPprJ8FgC022t?=
 =?us-ascii?Q?oF37InDHzR3BDh+1u+OMrgQlHSGUeWBE1eWF2kqaZj9q+3fMDw9UlTjJTFNK?=
 =?us-ascii?Q?BMNgJA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fc8c662-6fab-42de-60fa-08db2484363a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 12:04:06.8854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rQJJBYH/vzWFELcoaE8Q07J4LyooMSgtHRwIbbZ7jONOtHjXwBlLjx7edIeydCKthlw69r4ovTEWRbb90TG3gDNvOSFUr60r7oaRVlM6F4c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4743
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 11:05:32AM +0800, Jason Xing wrote:
> From: Jason Xing <kernelxing@tencent.com>
> 
> When we encounter some performance issue and then get lost on how
> to tune the budget limit and time limit in net_rx_action() function,
> we can separately counting both of them to avoid the confusion.
> 
> Signed-off-by: Jason Xing <kernelxing@tencent.com>

As per my comment on patch 1/2, I'd drop the "/* keep it untouched */"
comment.

That notwithstanding:

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
> v2:
> 1) change the coding style suggested by Stephen and Simon
> 2) Keep the display of the old data (time_squeeze) untouched suggested
> by Kui-Feng
> Link: https://lore.kernel.org/lkml/20230311163614.92296-1-kerneljasonxing@gmail.com/
> ---
>  include/linux/netdevice.h |  1 +
>  net/core/dev.c            | 12 ++++++++----
>  net/core/net-procfs.c     |  9 ++++++---
>  3 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 6a14b7b11766..5736311a2133 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3157,6 +3157,7 @@ struct softnet_data {
>  	/* stats */
>  	unsigned int		processed;
>  	unsigned int		time_squeeze;
> +	unsigned int		budget_squeeze;
>  #ifdef CONFIG_RPS
>  	struct softnet_data	*rps_ipi_list;
>  #endif
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 253584777101..1518a366783b 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6637,6 +6637,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
>  	unsigned long time_limit = jiffies +
>  		usecs_to_jiffies(READ_ONCE(netdev_budget_usecs));
>  	int budget = READ_ONCE(netdev_budget);
> +	bool done = false;
>  	LIST_HEAD(list);
>  	LIST_HEAD(repoll);
>  
> @@ -6644,7 +6645,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
>  	list_splice_init(&sd->poll_list, &list);
>  	local_irq_enable();
>  
> -	for (;;) {
> +	while (!done) {
>  		struct napi_struct *n;
>  
>  		skb_defer_free_flush(sd);
> @@ -6662,10 +6663,13 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
>  		 * Allow this to run for 2 jiffies since which will allow
>  		 * an average latency of 1.5/HZ.
>  		 */
> -		if (unlikely(budget <= 0 ||
> -			     time_after_eq(jiffies, time_limit))) {
> +		if (unlikely(budget <= 0)) {
> +			sd->budget_squeeze++;
> +			done = true;
> +		}
> +		if (unlikely(time_after_eq(jiffies, time_limit))) {
>  			sd->time_squeeze++;
> -			break;
> +			done = true;
>  		}
>  	}
>  
> diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
> index 2809b663e78d..25810ee46a04 100644
> --- a/net/core/net-procfs.c
> +++ b/net/core/net-procfs.c
> @@ -179,14 +179,17 @@ static int softnet_seq_show(struct seq_file *seq, void *v)
>  	 */
>  	seq_printf(seq,
>  		   "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x "
> -		   "%08x %08x\n",
> -		   sd->processed, sd->dropped, sd->time_squeeze, 0,
> +		   "%08x %08x %08x %08x\n",
> +		   sd->processed, sd->dropped,
> +		   sd->time_squeeze + sd->budget_squeeze, /* keep it untouched */
> +		   0,
>  		   0, 0, 0, 0, /* was fastroute */
>  		   0,	/* was cpu_collision */
>  		   sd->received_rps, flow_limit_count,
>  		   softnet_backlog_len(sd),	/* keep it untouched */
>  		   (int)seq->index,
> -		   softnet_input_pkt_queue_len(sd), softnet_process_queue_len(sd));
> +		   softnet_input_pkt_queue_len(sd), softnet_process_queue_len(sd),
> +		   sd->time_squeeze, sd->budget_squeeze);
>  	return 0;
>  }
>  
> -- 
> 2.37.3
> 
