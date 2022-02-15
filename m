Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6E64B79D0
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 22:50:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244273AbiBOVE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 16:04:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244268AbiBOVEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 16:04:23 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4062028983;
        Tue, 15 Feb 2022 13:04:13 -0800 (PST)
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nK4zb-0007XX-2z; Tue, 15 Feb 2022 22:04:11 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nK4za-0006aU-C9; Tue, 15 Feb 2022 22:04:10 +0100
Subject: Re: [PATCH v4 net-next 3/8] net: Set skb->mono_delivery_time and
 clear it after sch_handle_ingress()
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Willem de Bruijn <willemb@google.com>
References: <20220211071232.885225-1-kafai@fb.com>
 <20220211071251.887078-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ea27aeb8-e983-c22c-1217-0a38dceaec1c@iogearbox.net>
Date:   Tue, 15 Feb 2022 22:04:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220211071251.887078-1-kafai@fb.com>
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

On 2/11/22 8:12 AM, Martin KaFai Lau wrote:
[...]
> +
> +DECLARE_STATIC_KEY_FALSE(netstamp_needed_key);
> +
> +/* It is used in the ingress path to clear the delivery_time.
> + * If needed, set the skb->tstamp to the (rcv) timestamp.
> + */
> +static inline void skb_clear_delivery_time(struct sk_buff *skb)
> +{
> +	if (unlikely(skb->mono_delivery_time)) {
> +		skb->mono_delivery_time = 0;
> +		if (static_branch_unlikely(&netstamp_needed_key))
> +			skb->tstamp = ktime_get_real();
> +		else
> +			skb->tstamp = 0;
> +	}
>   }
>   
>   static inline void skb_clear_tstamp(struct sk_buff *skb)
> @@ -3946,6 +3961,14 @@ static inline void skb_clear_tstamp(struct sk_buff *skb)
>   	skb->tstamp = 0;
>   }
>   
> +static inline ktime_t skb_tstamp(const struct sk_buff *skb)
> +{
> +	if (unlikely(skb->mono_delivery_time))
> +		return 0;
> +
> +	return skb->tstamp;
> +}
> +
>   static inline u8 skb_metadata_len(const struct sk_buff *skb)
>   {

Just small nit, but I don't think here and in other patches as well the conditional
for skb->mono_delivery_time should be marked unlikely(). For container workloads
this is very likely.
