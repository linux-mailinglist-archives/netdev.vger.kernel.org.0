Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01DEA4CBBAD
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 11:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbiCCKtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 05:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232484AbiCCKtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 05:49:12 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B56B177768;
        Thu,  3 Mar 2022 02:48:24 -0800 (PST)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nPj0O-0006IH-16; Thu, 03 Mar 2022 11:48:20 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nPj0N-000UgS-ON; Thu, 03 Mar 2022 11:48:19 +0100
Subject: Re: [PATCH v6 net-next 03/13] net: Handle delivery_time in
 skb->tstamp during network tapping with af_packet
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Willem de Bruijn <willemb@google.com>
References: <20220302195519.3479274-1-kafai@fb.com>
 <20220302195538.3480753-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <63e625fe-067d-bcc3-d28a-6e23402b1ff2@iogearbox.net>
Date:   Thu, 3 Mar 2022 11:48:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220302195538.3480753-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26470/Thu Mar  3 10:49:16 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/2/22 8:55 PM, Martin KaFai Lau wrote:
[...]
> When tapping at ingress, it currently expects the skb->tstamp is either 0
> or the (rcv) timestamp.  Meaning, the tapping at ingress path
> has already expected the skb->tstamp could be 0 and it will get
> the (rcv) timestamp by ktime_get_real() when needed.
> 
> There are two cases for tapping at ingress:
> 
> One case is af_packet queues the skb to its sk_receive_queue.
> The skb is either not shared or new clone created.  The newly
> added skb_clear_delivery_time() is called to clear the
> delivery_time (if any) and set the (rcv) timestamp if
> needed before the skb is queued to the sk_receive_queue.
[...]
>   
> +DECLARE_STATIC_KEY_FALSE(netstamp_needed_key);
> +
> +/* It is used in the ingress path to clear the delivery_time.
> + * If needed, set the skb->tstamp to the (rcv) timestamp.
> + */
> +static inline void skb_clear_delivery_time(struct sk_buff *skb)
> +{
> +	if (skb->mono_delivery_time) {
> +		skb->mono_delivery_time = 0;
> +		if (static_branch_unlikely(&netstamp_needed_key))
> +			skb->tstamp = ktime_get_real();
> +		else
> +			skb->tstamp = 0;
> +	}
> +}
> +
>   static inline void skb_clear_tstamp(struct sk_buff *skb)
[...]
> @@ -2199,6 +2199,7 @@ static int packet_rcv(struct sk_buff *skb, struct net_device *dev,
>   	spin_lock(&sk->sk_receive_queue.lock);
>   	po->stats.stats1.tp_packets++;
>   	sock_skb_set_dropcount(sk, skb);
> +	skb_clear_delivery_time(skb);

Maybe not fully clear from your description, but for ingress taps, we are allowed
to mangle timestamp here because main recv loop enters taps via deliver_skb(), which
bumps skb->users refcount and {t,}packet_rcv() always hits the skb_shared(skb) case
which then clones skb.. (and for egress we are covered anyway given dev_queue_xmit_nit()
will skb_clone() once anyway for tx tstamp)?

>   	__skb_queue_tail(&sk->sk_receive_queue, skb);
>   	spin_unlock(&sk->sk_receive_queue.lock);
>   	sk->sk_data_ready(sk);
> @@ -2377,6 +2378,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
>   	po->stats.stats1.tp_packets++;
>   	if (copy_skb) {
>   		status |= TP_STATUS_COPY;
> +		skb_clear_delivery_time(copy_skb);
>   		__skb_queue_tail(&sk->sk_receive_queue, copy_skb);
>   	}
>   	spin_unlock(&sk->sk_receive_queue.lock);
> 

Thanks,
Daniel
