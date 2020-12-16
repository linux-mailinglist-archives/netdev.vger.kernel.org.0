Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3E52DC809
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 21:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbgLPU6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 15:58:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59278 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727034AbgLPU6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 15:58:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608152212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2AkrCNpZXe4Sp+a6ZR/50L3fZGo/5s0uMtMrwkWOaLw=;
        b=FlGygC7pc72z+snfRL7adDCtUewaqlnrguGlb3RQiX8oG6P0qH+VK8NIONYtRT/KUc3nLE
        lz/0fw1y38OwkcH94gEEqRvlYnSJ73dmtCoXYFinrdC7FhD1Zt23vv2aYNFDofvnKj/Pp1
        RwzamO8Mdn97yG39K7xd1t90el8VQWk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-CzQ9Fu_OONuOOzgjgwq8uw-1; Wed, 16 Dec 2020 15:56:50 -0500
X-MC-Unique: CzQ9Fu_OONuOOzgjgwq8uw-1
Received: by mail-wr1-f69.google.com with SMTP id g16so8683472wrv.1
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 12:56:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2AkrCNpZXe4Sp+a6ZR/50L3fZGo/5s0uMtMrwkWOaLw=;
        b=pdJ7thX9g7IjDkhvPUu43d4n1FSlWqgzHK4uGRF5oKGkFHreIBGUHMjHyqhx3JIBtL
         Iy2RuxawzNrZhqKjgib5lmVg4wGBIooTRB70q06VBzqdJihFMjNuce9ChWiWsucUHkq6
         Vozsj67xblReQkhOCZ/dSUZpdwS88Lvr9sSe4/UkKJ06pF2Rd0SbfEPuADdURus9ApkI
         oRdSpe1iokQQC9SwiDqqw4Mq2ArzcTq+TZcYynUFF9bXPSEi2DMr5pv3MHHjUHUL67E0
         VhwEeMrXYy5XYbEtA/X1bp4R4Df2x/xShEP74f3r+x96Cb9biCftbjmg9KaraOPND8/A
         mxTA==
X-Gm-Message-State: AOAM533xTruerXP+I/XgsQGUrXK98o64VcyQO5wBRcdhgs/k4JnsmHjH
        TF/englJhbrKAi1YTIxZDLOYGJxy7af6nXyXcH7NJHGRqOJr9CYA3dLX8oR/RLT2pI6HBCQ8e5g
        t6aNH5mQ+BDUo2Pza
X-Received: by 2002:a05:600c:242:: with SMTP id 2mr5223301wmj.144.1608152209296;
        Wed, 16 Dec 2020 12:56:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxuOrbflTOE4VJXzLJkCUB2ptnIdthXN1ODGiPBIoluhRZebmLZsZznPpZ8UMh6Pb4Df5ucMA==
X-Received: by 2002:a05:600c:242:: with SMTP id 2mr5223287wmj.144.1608152209125;
        Wed, 16 Dec 2020 12:56:49 -0800 (PST)
Received: from redhat.com (bzq-109-67-15-113.red.bezeqint.net. [109.67.15.113])
        by smtp.gmail.com with ESMTPSA id o13sm4139491wmc.44.2020.12.16.12.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 12:56:48 -0800 (PST)
Date:   Wed, 16 Dec 2020 15:56:45 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     netdev@vger.kernel.org, jasowang@redhat.com,
        willemdebruijn.kernel@gmail.com,
        virtualization@lists.linux-foundation.org,
        jerry.lilijun@huawei.com, chenchanghu@huawei.com,
        xudingke@huawei.com, brian.huangbin@huawei.com
Subject: Re: [PATCH net v2 1/2] vhost_net: fix ubuf refcount incorrectly when
 sendmsg fails
Message-ID: <20201216155633-mutt-send-email-mst@kernel.org>
References: <cover.1608065644.git.wangyunjian@huawei.com>
 <62db7d3d2af50f379ec28452921b3261af33db0b.1608065644.git.wangyunjian@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62db7d3d2af50f379ec28452921b3261af33db0b.1608065644.git.wangyunjian@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 04:20:20PM +0800, wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> Currently the vhost_zerocopy_callback() maybe be called to decrease
> the refcount when sendmsg fails in tun. The error handling in vhost
> handle_tx_zerocopy() will try to decrease the same refcount again.
> This is wrong. To fix this issue, we only call vhost_net_ubuf_put()
> when vq->heads[nvq->desc].len == VHOST_DMA_IN_PROGRESS.
> 
> Fixes: 0690899b4d45 ("tun: experimental zero copy tx support")
> 
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/vhost/net.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 531a00d703cd..c8784dfafdd7 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -863,6 +863,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>  	size_t len, total_len = 0;
>  	int err;
>  	struct vhost_net_ubuf_ref *ubufs;
> +	struct ubuf_info *ubuf;
>  	bool zcopy_used;
>  	int sent_pkts = 0;
>  
> @@ -895,9 +896,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>  
>  		/* use msg_control to pass vhost zerocopy ubuf info to skb */
>  		if (zcopy_used) {
> -			struct ubuf_info *ubuf;
>  			ubuf = nvq->ubuf_info + nvq->upend_idx;
> -
>  			vq->heads[nvq->upend_idx].id = cpu_to_vhost32(vq, head);
>  			vq->heads[nvq->upend_idx].len = VHOST_DMA_IN_PROGRESS;
>  			ubuf->callback = vhost_zerocopy_callback;
> @@ -927,7 +926,8 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>  		err = sock->ops->sendmsg(sock, &msg, len);
>  		if (unlikely(err < 0)) {
>  			if (zcopy_used) {
> -				vhost_net_ubuf_put(ubufs);
> +				if (vq->heads[ubuf->desc].len == VHOST_DMA_IN_PROGRESS)
> +					vhost_net_ubuf_put(ubufs);
>  				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
>  					% UIO_MAXIOV;
>  			}
> -- 
> 2.23.0

