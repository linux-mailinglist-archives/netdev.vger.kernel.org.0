Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D554A7086
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 13:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236905AbiBBMNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 07:13:36 -0500
Received: from www62.your-server.de ([213.133.104.62]:53456 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231929AbiBBMNf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 07:13:35 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nFEVu-000EZ1-Vq; Wed, 02 Feb 2022 13:13:31 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nFEVu-000PyY-LD; Wed, 02 Feb 2022 13:13:30 +0100
Subject: Re: [PATCH net 1/2] net: do not keep the dst cache when uncloning an
 skb dst and its metadata
To:     Antoine Tenart <atenart@kernel.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, vladbu@nvidia.com, pabeni@redhat.com,
        pshelar@ovn.org
References: <20220202110137.470850-1-atenart@kernel.org>
 <20220202110137.470850-2-atenart@kernel.org>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8585630f-f68c-ecea-a6b5-9a2ca8323566@iogearbox.net>
Date:   Wed, 2 Feb 2022 13:13:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220202110137.470850-2-atenart@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26441/Wed Feb  2 10:43:13 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/22 12:01 PM, Antoine Tenart wrote:
> When uncloning an skb dst and its associated metadata a new dst+metadata
> is allocated and the tunnel information from the old metadata is copied
> over there.
> 
> The issue is the tunnel metadata has references to cached dst, which are
> copied along the way. When a dst+metadata refcount drops to 0 the
> metadata is freed including the cached dst entries. As they are also
> referenced in the initial dst+metadata, this ends up in UaFs.
> 
> In practice the above did not happen because of another issue, the
> dst+metadata was never freed because its refcount never dropped to 0
> (this will be fixed in a subsequent patch).
> 
> Fix this by initializing the dst cache after copying the tunnel
> information from the old metadata to also unshare the dst cache.
> 
> Fixes: d71785ffc7e7 ("net: add dst_cache to ovs vxlan lwtunnel")
> Cc: Paolo Abeni <pabeni@redhat.com>
> Reported-by: Vlad Buslov <vladbu@nvidia.com>
> Tested-by: Vlad Buslov <vladbu@nvidia.com>
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> ---
>   include/net/dst_metadata.h | 13 ++++++++++++-
>   1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
> index 14efa0ded75d..c8f8b7b56bba 100644
> --- a/include/net/dst_metadata.h
> +++ b/include/net/dst_metadata.h
> @@ -110,8 +110,8 @@ static inline struct metadata_dst *tun_rx_dst(int md_size)
>   static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
>   {
>   	struct metadata_dst *md_dst = skb_metadata_dst(skb);
> -	int md_size;
>   	struct metadata_dst *new_md;
> +	int md_size, ret;
>   
>   	if (!md_dst || md_dst->type != METADATA_IP_TUNNEL)
>   		return ERR_PTR(-EINVAL);
> @@ -123,6 +123,17 @@ static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
>   
>   	memcpy(&new_md->u.tun_info, &md_dst->u.tun_info,
>   	       sizeof(struct ip_tunnel_info) + md_size);
> +#ifdef CONFIG_DST_CACHE
> +	ret = dst_cache_init(&new_md->u.tun_info.dst_cache, GFP_ATOMIC);
> +	if (ret) {
> +		/* We can't call metadata_dst_free directly as the still shared
> +		 * dst cache would be released.
> +		 */
> +		kfree(new_md);
> +		return ERR_PTR(ret);
> +	}
> +#endif

Could you elaborate (e.g. also in commit message) how this interacts or whether it is
needed for TUNNEL_NOCACHE users? (Among others, latter is used by BPF, for example.)

>   	skb_dst_drop(skb);
>   	dst_hold(&new_md->dst);
>   	skb_dst_set(skb, &new_md->dst);
> 

