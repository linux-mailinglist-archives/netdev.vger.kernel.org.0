Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25744B7B38
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 00:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239698AbiBOXbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 18:31:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbiBOXbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 18:31:18 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9B7F94E9;
        Tue, 15 Feb 2022 15:31:04 -0800 (PST)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nK7Hg-000AQn-16; Wed, 16 Feb 2022 00:31:00 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nK7Hf-000R6q-N0; Wed, 16 Feb 2022 00:30:59 +0100
Subject: Re: [PATCH v4 net-next 5/8] bpf: Keep the (rcv) timestamp behavior
 for the existing tc-bpf@ingress
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Willem de Bruijn <willemb@google.com>
References: <20220211071232.885225-1-kafai@fb.com>
 <20220211071303.890169-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f0d76498-0bb1-36a6-0c8c-b334f6fb13c2@iogearbox.net>
Date:   Wed, 16 Feb 2022 00:30:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220211071303.890169-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26454/Tue Feb 15 10:32:17 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/22 8:13 AM, Martin KaFai Lau wrote:
> The current tc-bpf@ingress reads and writes the __sk_buff->tstamp
> as a (rcv) timestamp.  This patch is to backward compatible with the
> (rcv) timestamp expectation when the skb->tstamp has a mono delivery_time.
> 
> If needed, the patch first saves the mono delivery_time.  Depending on
> the static key "netstamp_needed_key", it then resets the skb->tstamp to
> either 0 or ktime_get_real() before running the tc-bpf@ingress.  After
> the tc-bpf prog returns, if the (rcv) timestamp in skb->tstamp has not
> been changed, it will restore the earlier saved mono delivery_time.
> 
> The current logic to run tc-bpf@ingress is refactored to a new
> bpf_prog_run_at_ingress() function and shared between cls_bpf and act_bpf.
> The above new delivery_time save/restore logic is also done together in
> this function.
> 
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>   include/linux/filter.h | 28 ++++++++++++++++++++++++++++
>   net/sched/act_bpf.c    |  5 +----
>   net/sched/cls_bpf.c    |  6 +-----
>   3 files changed, 30 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/filter.h b/include/linux/filter.h
> index d23e999dc032..e43e1701a80e 100644
> --- a/include/linux/filter.h
> +++ b/include/linux/filter.h
> @@ -699,6 +699,34 @@ static inline void bpf_compute_data_pointers(struct sk_buff *skb)
>   	cb->data_end  = skb->data + skb_headlen(skb);
>   }
>   
> +static __always_inline u32 bpf_prog_run_at_ingress(const struct bpf_prog *prog,
> +						   struct sk_buff *skb)
> +{
> +	ktime_t tstamp, saved_mono_dtime = 0;
> +	int filter_res;
> +
> +	if (unlikely(skb->mono_delivery_time)) {
> +		saved_mono_dtime = skb->tstamp;
> +		skb->mono_delivery_time = 0;
> +		if (static_branch_unlikely(&netstamp_needed_key))
> +			skb->tstamp = tstamp = ktime_get_real();
> +		else
> +			skb->tstamp = tstamp = 0;
> +	}
> +
> +	/* It is safe to push/pull even if skb_shared() */
> +	__skb_push(skb, skb->mac_len);
> +	bpf_compute_data_pointers(skb);
> +	filter_res = bpf_prog_run(prog, skb);
> +	__skb_pull(skb, skb->mac_len);
> +
> +	/* __sk_buff->tstamp was not changed, restore the delivery_time */
> +	if (unlikely(saved_mono_dtime) && skb_tstamp(skb) == tstamp)
> +		skb_set_delivery_time(skb, saved_mono_dtime, true);

So above detour is for skb->tstamp backwards compatibility so users will see real time.
I don't see why we special case {cls,act}_bpf-only, given this will also be the case
for other subsystems (e.g. netfilter) when they read access plain skb->tstamp and get
the egress one instead of ktime_get_real() upon deferred skb_clear_delivery_time().

If we would generally ignore it, then the above bpf_prog_run_at_ingress() save/restore
detour is not needed (so patch 5/6 should be dropped). (Meaning, if we need to special
case {cls,act}_bpf only, we could also have gone for simpler bpf-only solution..)

> +	return filter_res;
> +}
> +
>   /* Similar to bpf_compute_data_pointers(), except that save orginal
>    * data in cb->data and cb->meta_data for restore.
>    */
> diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
> index a77d8908e737..14c3bd0a5088 100644
> --- a/net/sched/act_bpf.c
> +++ b/net/sched/act_bpf.c
> @@ -45,10 +45,7 @@ static int tcf_bpf_act(struct sk_buff *skb, const struct tc_action *act,
>   
>   	filter = rcu_dereference(prog->filter);
>   	if (at_ingress) {
> -		__skb_push(skb, skb->mac_len);
> -		bpf_compute_data_pointers(skb);
> -		filter_res = bpf_prog_run(filter, skb);
> -		__skb_pull(skb, skb->mac_len);
> +		filter_res = bpf_prog_run_at_ingress(filter, skb);
>   	} else {
>   		bpf_compute_data_pointers(skb);
>   		filter_res = bpf_prog_run(filter, skb);
> diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
> index df19a847829e..036b2e1f74af 100644
> --- a/net/sched/cls_bpf.c
> +++ b/net/sched/cls_bpf.c
> @@ -93,11 +93,7 @@ static int cls_bpf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
>   		if (tc_skip_sw(prog->gen_flags)) {
>   			filter_res = prog->exts_integrated ? TC_ACT_UNSPEC : 0;
>   		} else if (at_ingress) {
> -			/* It is safe to push/pull even if skb_shared() */
> -			__skb_push(skb, skb->mac_len);
> -			bpf_compute_data_pointers(skb);
> -			filter_res = bpf_prog_run(prog->filter, skb);
> -			__skb_pull(skb, skb->mac_len);
> +			filter_res = bpf_prog_run_at_ingress(prog->filter, skb);
>   		} else {
>   			bpf_compute_data_pointers(skb);
>   			filter_res = bpf_prog_run(prog->filter, skb);
> 

