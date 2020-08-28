Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58EFF2562CB
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 00:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgH1WFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 18:05:45 -0400
Received: from www62.your-server.de ([213.133.104.62]:53140 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbgH1WFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 18:05:44 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kBmVC-0006ID-Tv; Sat, 29 Aug 2020 00:05:42 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kBmVC-000T43-Lv; Sat, 29 Aug 2020 00:05:42 +0200
Subject: Re: [PATCHv9 bpf-next 2/5] xdp: add a new helper for dev map
 multicast support
To:     Hangbin Liu <liuhangbin@gmail.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko B <andrii.nakryiko@gmail.com>
References: <20200715130816.2124232-1-liuhangbin@gmail.com>
 <20200826132002.2808380-1-liuhangbin@gmail.com>
 <20200826132002.2808380-3-liuhangbin@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <800c88e5-c3a8-65f8-bc8c-c7d18b667157@iogearbox.net>
Date:   Sat, 29 Aug 2020 00:05:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200826132002.2808380-3-liuhangbin@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25913/Fri Aug 28 15:19:15 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/20 3:19 PM, Hangbin Liu wrote:
[...]
> +BPF_CALL_3(bpf_xdp_redirect_map_multi, struct bpf_map *, map,
> +	   struct bpf_map *, ex_map, u64, flags)
> +{
> +	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
> +
> +	/* Limit ex_map type to DEVMAP_HASH to get better performance */
> +	if (unlikely(!map ||

Why is test on !map needed when arg1_type is ARG_CONST_MAP_PTR? Verifier must
guarantee that it's a valid map ptr .. are you saying this is not the case for
this helper?

> +		     (ex_map && ex_map->map_type != BPF_MAP_TYPE_DEVMAP_HASH) ||
> +		     flags & ~BPF_F_EXCLUDE_INGRESS))
> +		return XDP_ABORTED;
> +
> +	ri->tgt_index = 0;
> +	/* Set the tgt_value to NULL to distinguish with bpf_xdp_redirect_map */
> +	ri->tgt_value = NULL;
> +	ri->flags = flags;
> +	ri->ex_map = ex_map;
> +
> +	WRITE_ONCE(ri->map, map);
> +
> +	return XDP_REDIRECT;
> +}
> +
> +static const struct bpf_func_proto bpf_xdp_redirect_map_multi_proto = {
> +	.func           = bpf_xdp_redirect_map_multi,
> +	.gpl_only       = false,
> +	.ret_type       = RET_INTEGER,
> +	.arg1_type      = ARG_CONST_MAP_PTR,
> +	.arg2_type      = ARG_CONST_MAP_PTR_OR_NULL,
> +	.arg3_type      = ARG_ANYTHING,
> +};
> +
>   static unsigned long bpf_skb_copy(void *dst_buff, const void *skb,
>   				  unsigned long off, unsigned long len)
>   {
> @@ -6833,6 +6933,8 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>   		return &bpf_xdp_redirect_proto;
>   	case BPF_FUNC_redirect_map:
>   		return &bpf_xdp_redirect_map_proto;
> +	case BPF_FUNC_redirect_map_multi:
> +		return &bpf_xdp_redirect_map_multi_proto;
>   	case BPF_FUNC_xdp_adjust_tail:
>   		return &bpf_xdp_adjust_tail_proto;
>   	case BPF_FUNC_fib_lookup:
