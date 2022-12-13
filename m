Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2E3D64BF7C
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 23:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236335AbiLMWm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 17:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235536AbiLMWm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 17:42:57 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EFDF21264;
        Tue, 13 Dec 2022 14:42:56 -0800 (PST)
Received: from sslproxy04.your-server.de ([78.46.152.42])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1p5Dyv-000IMB-Gg; Tue, 13 Dec 2022 23:42:37 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1p5Dyu-000C9T-SX; Tue, 13 Dec 2022 23:42:36 +0100
Subject: Re: [PATCH net] filter: Account for tail adjustment during pull
 operations
To:     Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        ast@kernel.org, andrii@kernel.org, martin.lau@linux.dev,
        john.fastabend@gmail.com, song@kernel.org, yhs@fb.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Sean Tranchetti <quic_stranche@quicinc.com>
References: <1670906381-25161-1-git-send-email-quic_subashab@quicinc.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4d598e55-0366-5a27-2dd5-d7b59758b5fc@iogearbox.net>
Date:   Tue, 13 Dec 2022 23:42:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1670906381-25161-1-git-send-email-quic_subashab@quicinc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26749/Tue Dec 13 09:27:51 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/13/22 5:39 AM, Subash Abhinov Kasiviswanathan wrote:
> Extending the tail can have some unexpected side effects if a program is
> reading the content beyond the head skb headlen and all the skbs in the
> gso frag_list are linear with no head_frag -
> 
>    kernel BUG at net/core/skbuff.c:4219!
>    pc : skb_segment+0xcf4/0xd2c
>    lr : skb_segment+0x63c/0xd2c
>    Call trace:
>     skb_segment+0xcf4/0xd2c
>     __udp_gso_segment+0xa4/0x544
>     udp4_ufo_fragment+0x184/0x1c0
>     inet_gso_segment+0x16c/0x3a4
>     skb_mac_gso_segment+0xd4/0x1b0
>     __skb_gso_segment+0xcc/0x12c
>     udp_rcv_segment+0x54/0x16c
>     udp_queue_rcv_skb+0x78/0x144
>     udp_unicast_rcv_skb+0x8c/0xa4
>     __udp4_lib_rcv+0x490/0x68c
>     udp_rcv+0x20/0x30
>     ip_protocol_deliver_rcu+0x1b0/0x33c
>     ip_local_deliver+0xd8/0x1f0
>     ip_rcv+0x98/0x1a4
>     deliver_ptype_list_skb+0x98/0x1ec
>     __netif_receive_skb_core+0x978/0xc60
> 
> Fix this by marking these skbs as GSO_DODGY so segmentation can handle
> the tail updates accordingly.
> 
> Fixes: 5293efe62df8 ("bpf: add bpf_skb_change_tail helper")
> Signed-off-by: Sean Tranchetti <quic_stranche@quicinc.com>
> Signed-off-by: Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
> ---
>   net/core/filter.c | 14 ++++++++++++++
>   1 file changed, 14 insertions(+)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index bb0136e..d5f7f79 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -1654,6 +1654,20 @@ static DEFINE_PER_CPU(struct bpf_scratchpad, bpf_sp);
>   static inline int __bpf_try_make_writable(struct sk_buff *skb,
>   					  unsigned int write_len)
>   {
> +	struct sk_buff *list_skb = skb_shinfo(skb)->frag_list;
> +
> +	if (skb_is_gso(skb) && list_skb && !list_skb->head_frag &&
> +	    skb_headlen(list_skb)) {
> +		int headlen = skb_headlen(skb);
> +		int err = skb_ensure_writable(skb, write_len);
> +
> +		/* pskb_pull_tail() has occurred */
> +		if (!err && headlen != skb_headlen(skb))
> +			skb_shinfo(skb)->gso_type |= SKB_GSO_DODGY;
> +
> +		return err;
> +	}

__bpf_try_make_writable() does not look like the right location to me
given this is called also from various other places. bpf_skb_change_tail
has skb_gso_reset in there, potentially that or pskb_pull_tail itself
should mark it?

>   	return skb_ensure_writable(skb, write_len);
>   }
>   
> 

