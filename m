Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951EF2E30E9
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 12:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgL0LYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Dec 2020 06:24:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57121 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726039AbgL0LYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Dec 2020 06:24:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609068198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Carv6zqFCxj0J5YQLwT4wyQy1B7lV2HXgXZ8v+ZCP0I=;
        b=OL/MhxivORzdsyx4BQbph6288QAB5ZRdLy7Od/eCMpD7sBIwjeS7O15EHHLUzWebZrDEnc
        CB/BHRnlLkdoZQLxG8XkpgF3EZVu67SkKVSUjQoKIImEwVlnqK5B7r5KQMdyBQaOAgFuyC
        /PhRQJztUyEThv7N8ESDlUG46wX7+v8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-HLlpbct9Nxy84wTDrj77Gg-1; Sun, 27 Dec 2020 06:23:16 -0500
X-MC-Unique: HLlpbct9Nxy84wTDrj77Gg-1
Received: by mail-wr1-f72.google.com with SMTP id q18so4959518wrc.20
        for <netdev@vger.kernel.org>; Sun, 27 Dec 2020 03:23:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Carv6zqFCxj0J5YQLwT4wyQy1B7lV2HXgXZ8v+ZCP0I=;
        b=Pi3gYw5/jBw7UKpid0g8MwtUD6oA+T+ULWNXeLut7F/7+OJnuBZ7SZI+GPk/YRyMEl
         uBrw2iOnbv3oU6pdzef8/AzPCeMIB4ticVnBa2pj0IN79G1NRcN73zUmUpZaRj9g4G2r
         mKKg388zvY9JQq8ss6HwfM7V8uLwPI6M564TqUvws3pfXHZPRBx0vo7kDb19+oTUJAqW
         9W8klVqeLHMIdOunaInh+TO0/i/x8VzYav4AKuyBHcpYC5kHkXg/QezxZeBuVPd/mOwG
         4nIIk+Fjgdkye9l7tknI+chN7SJPxO7h/h5a0/YsYW7UgYQl1XNKG/GDFgNiQ/rekrvi
         dIFQ==
X-Gm-Message-State: AOAM533R1tBaWfTMssP0Sscda9RGJ1BaXRljPykCbfmadZ3/8M6X8It8
        yRVZTr3lSm6R/BoCKpnjOYZ+cDUuxMkTAiEEwXGj968jyJOBAh+BdoA/683ReCtDrlwwCOmeRXs
        9RlSjWwdI8D5d94Zf
X-Received: by 2002:a5d:43c3:: with SMTP id v3mr45690451wrr.184.1609068195562;
        Sun, 27 Dec 2020 03:23:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxVsbhQmBiDdexctHvz3t2WDXdLYzGebQwsNHSMiEt3Oqou/yS9LHj6OLmpHQCoqKyVAkhaMQ==
X-Received: by 2002:a5d:43c3:: with SMTP id v3mr45690436wrr.184.1609068195387;
        Sun, 27 Dec 2020 03:23:15 -0800 (PST)
Received: from redhat.com (bzq-79-178-32-166.red.bezeqint.net. [79.178.32.166])
        by smtp.gmail.com with ESMTPSA id b13sm49362684wrt.31.2020.12.27.03.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Dec 2020 03:23:14 -0800 (PST)
Date:   Sun, 27 Dec 2020 06:23:11 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     netdev@vger.kernel.org, jasowang@redhat.com,
        willemdebruijn.kernel@gmail.com,
        virtualization@lists.linux-foundation.org,
        jerry.lilijun@huawei.com, chenchanghu@huawei.com,
        xudingke@huawei.com, brian.huangbin@huawei.com
Subject: Re: [PATCH net v5 1/2] vhost_net: fix ubuf refcount incorrectly when
 sendmsg fails
Message-ID: <20201227062220-mutt-send-email-mst@kernel.org>
References: <1608881065-7572-1-git-send-email-wangyunjian@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1608881065-7572-1-git-send-email-wangyunjian@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 25, 2020 at 03:24:25PM +0800, wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
> 
> Currently the vhost_zerocopy_callback() maybe be called to decrease
> the refcount when sendmsg fails in tun. The error handling in vhost
> handle_tx_zerocopy() will try to decrease the same refcount again.
> This is wrong. To fix this issue, we only call vhost_net_ubuf_put()
> when vq->heads[nvq->desc].len == VHOST_DMA_IN_PROGRESS.
> 
> Fixes: 0690899b4d45 ("tun: experimental zero copy tx support")

Are you sure about this tag? the patch in question only affects
tun, while the fix only affects vhost.

> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> Acked-by: Willem de Bruijn <willemb@google.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
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

