Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 529BD4A72EF
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 15:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239002AbiBBOY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 09:24:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34846 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233378AbiBBOYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 09:24:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643811895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7uylblb82InBFDp/e8DQDF/GeB1IY/6jX58mSWYwwp4=;
        b=XGko8xo5f309BeTWwaP++PVpsQuusv+/bA4Kd4kQO/7XdTIGn9InB9EXWWc8HJ89rb2F2h
        cp+Fzf/Vlv18O89h4+h5c+gioXojx9Rp6I9GgqSm6rFNDK0nxSqPypkhyfg13loBH7CElQ
        pSDUOrrmzMY7XZz23NZwFN9mMbcUoe4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-dAZOOO_zNluTPQdbnuhUxQ-1; Wed, 02 Feb 2022 09:24:54 -0500
X-MC-Unique: dAZOOO_zNluTPQdbnuhUxQ-1
Received: by mail-wm1-f70.google.com with SMTP id m189-20020a1c26c6000000b003508ba87dfbso4586883wmm.7
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 06:24:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=7uylblb82InBFDp/e8DQDF/GeB1IY/6jX58mSWYwwp4=;
        b=LeKfxm19Xc6Sz3vxl+MFYotDiFOKLj2wtj+503saYTt+mFc5qpsJKQ2yZ1aCn9V2ha
         jKvv14VS3tnxb8kk4jja2qLtAZPM7vtMfruNpMsJ+Ht29JQCm6Ci+8tJe2bG97xnL0fb
         073TdR5T/ItgYCSnTvMnXu98j5mzcp599i8rcnNScb62mLMe+vQ4ytX1K5UiluEB/Oem
         8wvgSAcD5/NRmuBcuM0EEmnokVnO1q5d5GC0Zo4BXF69TCpucnJAjOWniA94Ar/P/Wwg
         F1bB/aEIn1uJpqacrgKCbhdcPLViL58RxF2jfPYe3BP5uJ7LaK7XYZlLpBCIQJD3gNdJ
         bCzw==
X-Gm-Message-State: AOAM531920qDkDN5zyaz8ZEEQDuxqbVN/TH62VcWTkwB8uOX1lDD6aV3
        HzSXyMOzdfD+P7naxxxt5pbpibPQ1Zc2JWjNLHZFsWH9gldEOD8nmGNmjEyswLDko/zLfQYfRAT
        f6dAUu81iGPtSugIa
X-Received: by 2002:a5d:488f:: with SMTP id g15mr3054298wrq.564.1643811892910;
        Wed, 02 Feb 2022 06:24:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzb4MtRDqpvSdfU0926o+5w+J6kf5ldnoVMkx1yuJBVafMRiMWWprtdifH/ANCeMp2nTzoddw==
X-Received: by 2002:a5d:488f:: with SMTP id g15mr3054282wrq.564.1643811892616;
        Wed, 02 Feb 2022 06:24:52 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-96-254.dyn.eolo.it. [146.241.96.254])
        by smtp.gmail.com with ESMTPSA id i17sm6795421wru.107.2022.02.02.06.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 06:24:52 -0800 (PST)
Message-ID: <c699ed79feb4f86f02e882597bffd8c91782d573.camel@redhat.com>
Subject: Re: [PATCH net 1/2] net: do not keep the dst cache when uncloning
 an skb dst and its metadata
From:   Paolo Abeni <pabeni@redhat.com>
To:     Antoine Tenart <atenart@kernel.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, vladbu@nvidia.com, pshelar@ovn.org
Date:   Wed, 02 Feb 2022 15:24:51 +0100
In-Reply-To: <20220202110137.470850-2-atenart@kernel.org>
References: <20220202110137.470850-1-atenart@kernel.org>
         <20220202110137.470850-2-atenart@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-02-02 at 12:01 +0100, Antoine Tenart wrote:
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
>  include/net/dst_metadata.h | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/dst_metadata.h b/include/net/dst_metadata.h
> index 14efa0ded75d..c8f8b7b56bba 100644
> --- a/include/net/dst_metadata.h
> +++ b/include/net/dst_metadata.h
> @@ -110,8 +110,8 @@ static inline struct metadata_dst *tun_rx_dst(int md_size)
>  static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
>  {
>  	struct metadata_dst *md_dst = skb_metadata_dst(skb);
> -	int md_size;
>  	struct metadata_dst *new_md;
> +	int md_size, ret;
>  
>  	if (!md_dst || md_dst->type != METADATA_IP_TUNNEL)
>  		return ERR_PTR(-EINVAL);
> @@ -123,6 +123,17 @@ static inline struct metadata_dst *tun_dst_unclone(struct sk_buff *skb)
>  
>  	memcpy(&new_md->u.tun_info, &md_dst->u.tun_info,
>  	       sizeof(struct ip_tunnel_info) + md_size);
> +#ifdef CONFIG_DST_CACHE
> +	ret = dst_cache_init(&new_md->u.tun_info.dst_cache, GFP_ATOMIC);
> +	if (ret) {
> +		/* We can't call metadata_dst_free directly as the still shared
> +		 * dst cache would be released.
> +		 */
> +		kfree(new_md);

I think here you can use metadata_dst_free(): if dst_cache_init fails,
the dst_cache will be zeroed.

> +		return ERR_PTR(ret);
> +	}
> +#endif
> +
>  	skb_dst_drop(skb);
>  	dst_hold(&new_md->dst);
>  	skb_dst_set(skb, &new_md->dst);

Other than that LGTM, thanks!

/P

