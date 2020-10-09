Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F116288DD6
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 18:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389517AbgJIQMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 12:12:24 -0400
Received: from www62.your-server.de ([213.133.104.62]:50428 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389144AbgJIQMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 12:12:24 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kQv0H-0001kY-Sl; Fri, 09 Oct 2020 18:12:21 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kQv0H-000X1R-I6; Fri, 09 Oct 2020 18:12:21 +0200
Subject: Re: [PATCH bpf-next V3 1/6] bpf: Remove MTU check in
 __bpf_skb_max_len
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        willemdebruijn.kernel@gmail.com
References: <160216609656.882446.16642490462568561112.stgit@firesoul>
 <160216614239.882446.4447190431655011838.stgit@firesoul>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <20b1e1dc-7ce7-dc42-54cd-5c4040ccdb30@iogearbox.net>
Date:   Fri, 9 Oct 2020 18:12:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <160216614239.882446.4447190431655011838.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25952/Fri Oct  9 15:52:40 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/8/20 4:09 PM, Jesper Dangaard Brouer wrote:
> Multiple BPF-helpers that can manipulate/increase the size of the SKB uses
> __bpf_skb_max_len() as the max-length. This function limit size against
> the current net_device MTU (skb->dev->mtu).
> 
> When a BPF-prog grow the packet size, then it should not be limited to the
> MTU. The MTU is a transmit limitation, and software receiving this packet
> should be allowed to increase the size. Further more, current MTU check in
> __bpf_skb_max_len uses the MTU from ingress/current net_device, which in
> case of redirects uses the wrong net_device.
> 
> Keep a sanity max limit of IP6_MAX_MTU (under CONFIG_IPV6) which is 64KiB
> plus 40 bytes IPv6 header size. If compiled without IPv6 use IP_MAX_MTU.
> 
> V3: replace __bpf_skb_max_len() with define and use IPv6 max MTU size.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>   net/core/filter.c |   16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 05df73780dd3..ddc1f9ba89d1 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -3474,11 +3474,11 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
>   	return 0;
>   }
>   
> -static u32 __bpf_skb_max_len(const struct sk_buff *skb)
> -{
> -	return skb->dev ? skb->dev->mtu + skb->dev->hard_header_len :
> -			  SKB_MAX_ALLOC;
> -}
> +#ifdef IP6_MAX_MTU /* Depend on CONFIG_IPV6 */
> +#define BPF_SKB_MAX_LEN IP6_MAX_MTU
> +#else
> +#define BPF_SKB_MAX_LEN IP_MAX_MTU
> +#endif

Shouldn't that check on skb->protocol? The way I understand it is that a number of devices
including virtual ones use ETH_MAX_MTU as their dev->max_mtu, so the mtu must be in the range
of dev->min_mtu(=ETH_MIN_MTU), dev->max_mtu(=ETH_MAX_MTU). __dev_set_mtu() then sets the user
value to dev->mtu in the core if within this range. That means in your case skb->dev->hard_header_len
for example is left out, meaning if we go for some constant, that would need to be higher.

>   BPF_CALL_4(sk_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
>   	   u32, mode, u64, flags)
> @@ -3527,7 +3527,7 @@ BPF_CALL_4(bpf_skb_adjust_room, struct sk_buff *, skb, s32, len_diff,
>   {
>   	u32 len_cur, len_diff_abs = abs(len_diff);
>   	u32 len_min = bpf_skb_net_base_len(skb);
> -	u32 len_max = __bpf_skb_max_len(skb);
> +	u32 len_max = BPF_SKB_MAX_LEN;
>   	__be16 proto = skb->protocol;
>   	bool shrink = len_diff < 0;
>   	u32 off;
> @@ -3610,7 +3610,7 @@ static int bpf_skb_trim_rcsum(struct sk_buff *skb, unsigned int new_len)
>   static inline int __bpf_skb_change_tail(struct sk_buff *skb, u32 new_len,
>   					u64 flags)
>   {
> -	u32 max_len = __bpf_skb_max_len(skb);
> +	u32 max_len = BPF_SKB_MAX_LEN;
>   	u32 min_len = __bpf_skb_min_len(skb);
>   	int ret;
>   
> @@ -3686,7 +3686,7 @@ static const struct bpf_func_proto sk_skb_change_tail_proto = {
>   static inline int __bpf_skb_change_head(struct sk_buff *skb, u32 head_room,
>   					u64 flags)
>   {
> -	u32 max_len = __bpf_skb_max_len(skb);
> +	u32 max_len = BPF_SKB_MAX_LEN;
>   	u32 new_len = skb->len + head_room;
>   	int ret;
>   
> 
> 

