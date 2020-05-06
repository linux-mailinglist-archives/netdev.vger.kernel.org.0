Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 253C41C6A2A
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 09:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbgEFHhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 03:37:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44542 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727937AbgEFHhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 03:37:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588750670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1DqHn9dPlmj80heFjYayVPfLacQlouJrbO3+dn30g+Y=;
        b=TDIF5bvSFfFpFL3rq8t+byvc5g8iygQIexU+QzKpUn3qhgtSzdDURuRgb9q1pLFyL0iP7t
        3z+NdJujp964fNZVH+nB68kUUSnWGMDMk/3H+Kp6oPRoMBOE/ZtBobHlPx/c6sOLv2qQUm
        mFyAs2nuFkoMeCggcFgDfLA3Lj4vfRk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-TDei1Oj_O8mibj3FE3kfEw-1; Wed, 06 May 2020 03:37:47 -0400
X-MC-Unique: TDei1Oj_O8mibj3FE3kfEw-1
Received: by mail-wr1-f72.google.com with SMTP id q13so868527wrn.14
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 00:37:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1DqHn9dPlmj80heFjYayVPfLacQlouJrbO3+dn30g+Y=;
        b=fDQM+dcPzvX+I1VxBZPQfGKdU6zJ81ixN0dZwJDkXHN4LX4vYGjiPG0H/yMzyGPAmC
         ZZifkbALNLk6ZfB+aDEsfpkT8c//guQ3RngcxFbI9wFVqkhOO1h95tGul2Nsvr2zHdMf
         PEgCLSxWAnV6JkctGd6Eg05k8tuM39PHWt8vKz/U9eCj7qz+heB0Gq69GkaqyyfyEfvr
         ooJ4R50M9rmYGfQyqiWNtKTeQoVSNMAfcUyaKsTly7QSxwB/YkbobJmymdDeCXAHg1UI
         OcHAAb0ezKEXD0rkOFu9I+4KCySlUg+DFqwL7+fpDAjr8W1BCjw5hM7p8rHxAY1wD8+A
         Pz5A==
X-Gm-Message-State: AGi0PuZBDFl1dxeXw/cOtGQ5NTF0VCYxXnlV6JhcF4dcsyFLwuHyMZsO
        8/JKvIsz6oJxGLMBN07ks99SRPZ5Xt6+ZAO8fBSbygCv6PB8zMIRDz+5fUro6NbNmxtHDccBKnc
        qBryFGKaM5+PXMGp6
X-Received: by 2002:adf:ce10:: with SMTP id p16mr7691542wrn.144.1588750665670;
        Wed, 06 May 2020 00:37:45 -0700 (PDT)
X-Google-Smtp-Source: APiQypLylGfrIQvy8pwm2otNVLPO1o3cMHW4JbPm3GLxsqO+x+n/Q0pR35QnHj4F0DC4IEX6mTgYDA==
X-Received: by 2002:adf:ce10:: with SMTP id p16mr7691526wrn.144.1588750665498;
        Wed, 06 May 2020 00:37:45 -0700 (PDT)
Received: from redhat.com (bzq-109-66-7-121.red.bezeqint.net. [109.66.7.121])
        by smtp.gmail.com with ESMTPSA id 19sm1655337wmo.3.2020.05.06.00.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 00:37:45 -0700 (PDT)
Date:   Wed, 6 May 2020 03:37:42 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH net-next 2/2] virtio-net: fix the XDP truesize
 calculation for mergeable buffers
Message-ID: <20200506033259-mutt-send-email-mst@kernel.org>
References: <20200506061633.16327-1-jasowang@redhat.com>
 <20200506061633.16327-2-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506061633.16327-2-jasowang@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 02:16:33PM +0800, Jason Wang wrote:
> We should not exclude headroom and tailroom when XDP is set. So this
> patch fixes this by initializing the truesize from PAGE_SIZE when XDP
> is set.
> 
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Seems too aggressive, we do not use up the whole page for the size.



> ---
>  drivers/net/virtio_net.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 98dd75b665a5..3f3aa8308918 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1184,7 +1184,7 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
>  	char *buf;
>  	void *ctx;
>  	int err;
> -	unsigned int len, hole;
> +	unsigned int len, hole, truesize;
>  
>  	/* Extra tailroom is needed to satisfy XDP's assumption. This
>  	 * means rx frags coalescing won't work, but consider we've
> @@ -1194,6 +1194,7 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
>  	if (unlikely(!skb_page_frag_refill(len + room, alloc_frag, gfp)))
>  		return -ENOMEM;
>  
> +	truesize = headroom ? PAGE_SIZE : len;
>  	buf = (char *)page_address(alloc_frag->page) + alloc_frag->offset;
>  	buf += headroom; /* advance address leaving hole at front of pkt */
>  	get_page(alloc_frag->page);

Is this really just on the XDP path? Looks like a confusing way to
detect that.


> @@ -1205,11 +1206,12 @@ static int add_recvbuf_mergeable(struct virtnet_info *vi,
>  		 * the current buffer.
>  		 */
>  		len += hole;
> +		truesize += hole;
>  		alloc_frag->offset += hole;
>  	}
>  
>  	sg_init_one(rq->sg, buf, len);
> -	ctx = mergeable_len_to_ctx(len, headroom);
> +	ctx = mergeable_len_to_ctx(truesize, headroom);
>  	err = virtqueue_add_inbuf_ctx(rq->vq, rq->sg, 1, buf, ctx, gfp);
>  	if (err < 0)
>  		put_page(virt_to_head_page(buf));
> -- 
> 2.20.1

