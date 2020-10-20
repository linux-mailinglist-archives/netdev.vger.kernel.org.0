Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBFF6293F46
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 17:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408528AbgJTPIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 11:08:47 -0400
Received: from www62.your-server.de ([213.133.104.62]:57264 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731500AbgJTPIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 11:08:46 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kUtFi-0001ad-Hn; Tue, 20 Oct 2020 17:08:42 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kUtFi-00011m-DE; Tue, 20 Oct 2020 17:08:42 +0200
Subject: Re: [PATCH bpf v2 1/3] bpf_redirect_neigh: Support supplying the
 nexthop as a helper parameter
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <160319106111.15822.18417665895694986295.stgit@toke.dk>
 <160319106221.15822.2629789706666194966.stgit@toke.dk>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d6967cfe-fd0e-268a-5526-dd03f0e476e6@iogearbox.net>
Date:   Tue, 20 Oct 2020 17:08:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <160319106221.15822.2629789706666194966.stgit@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25963/Tue Oct 20 16:00:29 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/20 12:51 PM, Toke Høiland-Jørgensen wrote:
> From: Toke Høiland-Jørgensen <toke@redhat.com>
[...]
>   BPF_CALL_3(bpf_clone_redirect, struct sk_buff *, skb, u32, ifindex, u64, flags)
> @@ -2455,8 +2487,8 @@ int skb_do_redirect(struct sk_buff *skb)
>   		return -EAGAIN;
>   	}
>   	return flags & BPF_F_NEIGH ?
> -	       __bpf_redirect_neigh(skb, dev) :
> -	       __bpf_redirect(skb, dev, flags);
> +		__bpf_redirect_neigh(skb, dev, flags & BPF_F_NEXTHOP ? &ri->nh : NULL) :
> +		__bpf_redirect(skb, dev, flags);
>   out_drop:
>   	kfree_skb(skb);
>   	return -EINVAL;
> @@ -2504,16 +2536,25 @@ static const struct bpf_func_proto bpf_redirect_peer_proto = {
>   	.arg2_type      = ARG_ANYTHING,
>   };
>   
> -BPF_CALL_2(bpf_redirect_neigh, u32, ifindex, u64, flags)
> +BPF_CALL_4(bpf_redirect_neigh, u32, ifindex, struct bpf_redir_neigh *, params,
> +	   int, plen, u64, flags)
>   {
>   	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
>   
> -	if (unlikely(flags))
> +	if (unlikely((plen && plen < sizeof(*params)) || flags))
> +		return TC_ACT_SHOT;
> +
> +	if (unlikely(plen && (params->unused[0] || params->unused[1] ||
> +			      params->unused[2])))

small nit: maybe fold this into the prior check that already tests non-zero plen

if (unlikely((plen && (plen < sizeof(*params) ||
                        (params->unused[0] | params->unused[1] |
                         params->unused[2]))) || flags))
         return TC_ACT_SHOT;

>   		return TC_ACT_SHOT;
>   
> -	ri->flags = BPF_F_NEIGH;
> +	ri->flags = BPF_F_NEIGH | (plen ? BPF_F_NEXTHOP : 0);
>   	ri->tgt_index = ifindex;
>   
> +	BUILD_BUG_ON(sizeof(struct bpf_redir_neigh) != sizeof(struct bpf_nh_params));
> +	if (plen)
> +		memcpy(&ri->nh, params, sizeof(ri->nh));
> +
>   	return TC_ACT_REDIRECT;
>   }
>   
