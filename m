Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03D0A4A9965
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 13:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346145AbiBDMd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 07:33:27 -0500
Received: from www62.your-server.de ([213.133.104.62]:43104 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbiBDMd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 07:33:27 -0500
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nFxmD-000GCl-1o; Fri, 04 Feb 2022 13:33:21 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nFxmC-000DVa-Os; Fri, 04 Feb 2022 13:33:20 +0100
Subject: Re: [PATCH net 1/2] net: do not keep the dst cache when uncloning an
 skb dst and its metadata
To:     Antoine Tenart <atenart@kernel.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, vladbu@nvidia.com, pabeni@redhat.com,
        pshelar@ovn.org, wenxu@ucloud.cn
References: <20220202110137.470850-1-atenart@kernel.org>
 <20220202110137.470850-2-atenart@kernel.org>
 <8585630f-f68c-ecea-a6b5-9a2ca8323566@iogearbox.net>
 <164380949615.380114.13546587453907068231@kwain>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fc060e49-6ddf-0d18-f10d-958425876370@iogearbox.net>
Date:   Fri, 4 Feb 2022 13:33:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <164380949615.380114.13546587453907068231@kwain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26443/Fri Feb  4 10:22:38 2022)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/22 2:44 PM, Antoine Tenart wrote:
> Quoting Daniel Borkmann (2022-02-02 13:13:30)
>> On 2/2/22 12:01 PM, Antoine Tenart wrote:
>>> When uncloning an skb dst and its associated metadata a new dst+metadata
>>> is allocated and the tunnel information from the old metadata is copied
>>> over there.
>>>
>>> The issue is the tunnel metadata has references to cached dst, which are
>>> copied along the way. When a dst+metadata refcount drops to 0 the
>>> metadata is freed including the cached dst entries. As they are also
>>> referenced in the initial dst+metadata, this ends up in UaFs.
>>>
>>> In practice the above did not happen because of another issue, the
>>> dst+metadata was never freed because its refcount never dropped to 0
>>> (this will be fixed in a subsequent patch).
>>>
>>> Fix this by initializing the dst cache after copying the tunnel
>>> information from the old metadata to also unshare the dst cache.
>>>
>>> Fixes: d71785ffc7e7 ("net: add dst_cache to ovs vxlan lwtunnel")
>>> Cc: Paolo Abeni <pabeni@redhat.com>
>>> Reported-by: Vlad Buslov <vladbu@nvidia.com>
>>> Tested-by: Vlad Buslov <vladbu@nvidia.com>
>>> Signed-off-by: Antoine Tenart <atenart@kernel.org>
>>> ---
>>>    include/net/dst_metadata.h | 13 ++++++++++++-
>>>    1 file changed, 12 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
>>> index 14efa0ded75d..c8f8b7b56bba 100644
>>> --- a/include/net/dst_metadata.h
>>> +++ b/include/net/dst_metadata.h
>>> @@ -110,8 +110,8 @@ static inline struct metadata_dst *tun_rx_dst(int md_size)
>>>    static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
>>>    {
>>>        struct metadata_dst *md_dst = skb_metadata_dst(skb);
>>> -     int md_size;
>>>        struct metadata_dst *new_md;
>>> +     int md_size, ret;
>>>    
>>>        if (!md_dst || md_dst->type != METADATA_IP_TUNNEL)
>>>                return ERR_PTR(-EINVAL);
>>> @@ -123,6 +123,17 @@ static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
>>>    
>>>        memcpy(&new_md->u.tun_info, &md_dst->u.tun_info,
>>>               sizeof(struct ip_tunnel_info) + md_size);
>>> +#ifdef CONFIG_DST_CACHE
>>> +     ret = dst_cache_init(&new_md->u.tun_info.dst_cache, GFP_ATOMIC);
>>> +     if (ret) {
>>> +             /* We can't call metadata_dst_free directly as the still shared
>>> +              * dst cache would be released.
>>> +              */
>>> +             kfree(new_md);
>>> +             return ERR_PTR(ret);
>>> +     }
>>> +#endif
>>
>> Could you elaborate (e.g. also in commit message) how this interacts
>> or whether it is needed for TUNNEL_NOCACHE users? (Among others,
>> latter is used by BPF, for example.)
> 
> My understanding is that TUNNEL_NOCACHE is used to decide whether or not
> to use a dst cache, that might or might not come from the tunnel info
> attached to an skb. The dst cache being allocated in a tunnel info is
> orthogonal to the use of TUNNEL_NOCACHE. While looking around I actually
> found a code path explicitly setting both, in nft_tunnel_obj_init (that
> might need to be investigated though but it is another topic).

Good point, this is coming from 3e511d5652ce ("netfilter: nft_tunnel: Add dst_cache
support") and was added only after af308b94a2a4 ("netfilter: nf_tables: add tunnel
support") which initially indicated TUNNEL_NOCACHE. This is indeed contradictory.
wenxu (+Cc), ptal.

> It doesn't look like initializing the dst cache would break
> TUNNEL_NOCACHE users as ip_tunnel_dst_cache_usable would return false
> anyway. Having said that, we probably want to unshare the dst cache only
> if there is one already, checking for
> 'md_dst->u.tun_info.dst_cache.cache != NULL' first.

Meaning, if that is the case, we wouldn't require the dst_cache_init() and thus
extra alloc, right? Would make sense afaics. db3c6139e6ea ("bpf, vxlan, geneve,
gre: fix usage of dst_cache on xmit") had some details related to BPF use.

Thanks again!
Daniel
