Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892564010D1
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 18:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238004AbhIEQTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 12:19:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38679 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229566AbhIEQTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 12:19:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630858682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hW1sN5QGx3Kx2EPNmaIE4CRt6Il/ANBqcp567eWWlqk=;
        b=NzkRj9Titj7saPXnb7z70ke5gZiqAyAknju4Az/6KZCzKUsLsU+WO2UodfHunzETTk4bFe
        OPI5/+0u66svGhm2/qnhTZ/YOnnR+e29aZBEKDsgjdGraHm0kYIOf6wwAJLoDEVNhEt0Zo
        l9jS6VRAJN4wAQDlGER5CecQxyyQPe8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-iX1VjNePMnG7LdESiby1ZQ-1; Sun, 05 Sep 2021 12:18:01 -0400
X-MC-Unique: iX1VjNePMnG7LdESiby1ZQ-1
Received: by mail-wm1-f72.google.com with SMTP id p5-20020a7bcc85000000b002e7563efc4cso2189364wma.4
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 09:18:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hW1sN5QGx3Kx2EPNmaIE4CRt6Il/ANBqcp567eWWlqk=;
        b=J7FRySHtRS+hd4hEW//FY6IFFJYubjmhiSgwDO1FrWABlBIgZ058utKKOk1Cs5Xzpk
         g9ZKN3FvgZ5/n9LA0HdFrQzoQAek3L0z7UAD6ZQMw4XQ7z9UQaYR888Ekmp5CyOe1rje
         LMRJlhN1jzEaUX+l7GJ0RyWOR4wpgGnfN1aiMQexJB8q7vTpYdp1i1QLLcN1dO1KEmAR
         SVuSZj5H8TgRwc1rzVrOwwQJK21xFZhfNQathA3ZQhSpfJSqiI1fDU9mny5NER/Go6fG
         fqNt1DEN1TrbwS/39prsbjKhcVNIb5MZ5Mn7Q2f7Jq94Fwwd2Zb/aTeUNecSGt7uElj7
         1ChQ==
X-Gm-Message-State: AOAM531inneoSYhMGZat0aOiVwaixTirc9EP5yBq8Vj5FF5GGofDrxQy
        wATvSqsKdFY/k75qG0sg4Dm1n2pF4uRLg5Xzwm3iuZ/fHhLhf4Sq61VOpD47VB2M1742xn3JGjt
        D9Fz0lTOhbex9xG3G
X-Received: by 2002:adf:e6c5:: with SMTP id y5mr9020250wrm.198.1630858680246;
        Sun, 05 Sep 2021 09:18:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCY+j+7T+nDz0P50mK89ZiTPM8ct/jZZ3HWCX3r0RyVKusgkTEzB0PV/xPQQ6NTWshHSYVWg==
X-Received: by 2002:adf:e6c5:: with SMTP id y5mr9020227wrm.198.1630858679962;
        Sun, 05 Sep 2021 09:17:59 -0700 (PDT)
Received: from redhat.com ([2.55.131.183])
        by smtp.gmail.com with ESMTPSA id n18sm4795503wmc.22.2021.09.05.09.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 09:17:58 -0700 (PDT)
Date:   Sun, 5 Sep 2021 12:17:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuanxzhang@fudan.edu.cn,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: Re: [PATCH] vhost_net: Convert from atomic_t to refcount_t on
 vhost_net_ubuf_ref->refcount
Message-ID: <20210905121737-mutt-send-email-mst@kernel.org>
References: <1626517230-42920-1-git-send-email-xiyuyang19@fudan.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1626517230-42920-1-git-send-email-xiyuyang19@fudan.edu.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 17, 2021 at 06:20:30PM +0800, Xiyu Yang wrote:
> refcount_t type and corresponding API can protect refcounters from
> accidental underflow and overflow and further use-after-free situations.
> 
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>

Pls resubmit after addressing the build bot comments.
Thanks!

> ---
>  drivers/vhost/net.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 6414bd5741b8..e23150ca7d4c 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -5,6 +5,7 @@
>   * virtio-net server in host kernel.
>   */
>  
> +#include <linux/refcount.h>
>  #include <linux/compat.h>
>  #include <linux/eventfd.h>
>  #include <linux/vhost.h>
> @@ -92,7 +93,7 @@ struct vhost_net_ubuf_ref {
>  	 *  1: no outstanding ubufs
>  	 * >1: outstanding ubufs
>  	 */
> -	atomic_t refcount;
> +	refcount_t refcount;
>  	wait_queue_head_t wait;
>  	struct vhost_virtqueue *vq;
>  };
> @@ -240,7 +241,7 @@ vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
>  	ubufs = kmalloc(sizeof(*ubufs), GFP_KERNEL);
>  	if (!ubufs)
>  		return ERR_PTR(-ENOMEM);
> -	atomic_set(&ubufs->refcount, 1);
> +	refcount_set(&ubufs->refcount, 1);
>  	init_waitqueue_head(&ubufs->wait);
>  	ubufs->vq = vq;
>  	return ubufs;
> @@ -248,7 +249,8 @@ vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
>  
>  static int vhost_net_ubuf_put(struct vhost_net_ubuf_ref *ubufs)
>  {
> -	int r = atomic_sub_return(1, &ubufs->refcount);
> +	refcount_dec(&ubufs->refcount);
> +	int r = refcount_read(&ubufs->refcount);
>  	if (unlikely(!r))
>  		wake_up(&ubufs->wait);
>  	return r;
> @@ -257,7 +259,7 @@ static int vhost_net_ubuf_put(struct vhost_net_ubuf_ref *ubufs)
>  static void vhost_net_ubuf_put_and_wait(struct vhost_net_ubuf_ref *ubufs)
>  {
>  	vhost_net_ubuf_put(ubufs);
> -	wait_event(ubufs->wait, !atomic_read(&ubufs->refcount));
> +	wait_event(ubufs->wait, !refcount_read(&ubufs->refcount));
>  }
>  
>  static void vhost_net_ubuf_put_wait_and_free(struct vhost_net_ubuf_ref *ubufs)
> @@ -909,7 +911,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>  			ctl.ptr = ubuf;
>  			msg.msg_controllen = sizeof(ctl);
>  			ubufs = nvq->ubufs;
> -			atomic_inc(&ubufs->refcount);
> +			refcount_inc(&ubufs->refcount);
>  			nvq->upend_idx = (nvq->upend_idx + 1) % UIO_MAXIOV;
>  		} else {
>  			msg.msg_control = NULL;
> @@ -1384,7 +1386,7 @@ static void vhost_net_flush(struct vhost_net *n)
>  		vhost_net_ubuf_put_and_wait(n->vqs[VHOST_NET_VQ_TX].ubufs);
>  		mutex_lock(&n->vqs[VHOST_NET_VQ_TX].vq.mutex);
>  		n->tx_flush = false;
> -		atomic_set(&n->vqs[VHOST_NET_VQ_TX].ubufs->refcount, 1);
> +		refcount_set(&n->vqs[VHOST_NET_VQ_TX].ubufs->refcount, 1);
>  		mutex_unlock(&n->vqs[VHOST_NET_VQ_TX].vq.mutex);
>  	}
>  }
> -- 
> 2.7.4

