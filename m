Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B696F0FE8
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 03:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344704AbjD1BKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 21:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344643AbjD1BKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 21:10:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 658CB359D
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 18:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682644167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vDlMjQQs9oNd1rM1Ie1hZYk7Gu1+pdqFqGgkpF/yxbI=;
        b=DZXSTqNJUsv5wdNWTswQJp8aSfoleaQ1eesrm+5RhO88YzlGH42G8Kp14HtdLvdlwYzbGH
        8z61Fy+1GcXpw/KVjBCg64rgRhMKypuT0No7DL/6GB0oUA7BLpMeQCpD5gVjv+0w0nnjQ8
        JZ45FkegG6wMxTCKWCAv8njwKrFK/i0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-18-a-9hBj-dPvaK3jNcn2w8-A-1; Thu, 27 Apr 2023 21:09:25 -0400
X-MC-Unique: a-9hBj-dPvaK3jNcn2w8-A-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-2f831f6e175so5174383f8f.2
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 18:09:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682644164; x=1685236164;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vDlMjQQs9oNd1rM1Ie1hZYk7Gu1+pdqFqGgkpF/yxbI=;
        b=a4WYM7Y7uHy+aL8ZZCeOWX91g9Nc8waK3RfOITfTpOHtjnKRFrS1seUXcF9XzOt79E
         s/4E+FarIrnEyvXMDNwndVQWUK+PpghTFCZJ0SC/hC8vRM5q1bWYTVaFIssJlAOeKhhD
         SVeJs7YrQyHGOl/CHzZSnKW20kKlYFVYiWVuokHKVHSa03NqW7rRieqn6MlPVWiuW1LH
         xZ2VsEZn+2oquTD5/jIzzOUd4Lh2Su2KQfUKBvDLgLqVImwyBspuf3GQ3xN46lMYYbi3
         KeJeWxNZI8ODumgNccF0SRQIxYtTzjI6Xpy+Sc+BEw+UOuT3uebH1vHXsOEas80giHon
         NF5Q==
X-Gm-Message-State: AC+VfDyo9wy4flI49LLRa+MRUtflxnIZPG/qrphMmb+LoJPK9Hzdbwb7
        6/InnT9pWsAOqCKfxFsuagzNf2Iu8eCl61Zv20xSqihFIYcevzKs7+ZJ3GaoTgfGGugK67PsecN
        1N0hy7n82m9CiO4my
X-Received: by 2002:adf:dd90:0:b0:304:b967:956f with SMTP id x16-20020adfdd90000000b00304b967956fmr706839wrl.8.1682644164582;
        Thu, 27 Apr 2023 18:09:24 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4fv40ETH5op2sNv7xlB+MUhzP96QeT1eiO1SHh4pfOCErUxvz9m5RaLdAL6HtipgJ+xEF8MA==
X-Received: by 2002:adf:dd90:0:b0:304:b967:956f with SMTP id x16-20020adfdd90000000b00304b967956fmr706834wrl.8.1682644164304;
        Thu, 27 Apr 2023 18:09:24 -0700 (PDT)
Received: from redhat.com ([2.52.19.183])
        by smtp.gmail.com with ESMTPSA id e22-20020a5d5956000000b003012030a0c6sm19719410wri.18.2023.04.27.18.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 18:09:23 -0700 (PDT)
Date:   Thu, 27 Apr 2023 21:09:20 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Wenliang Wang <wangwenliang.1995@bytedance.com>
Cc:     jasowang@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] virtio_net: suppress cpu stall when free_unused_bufs
Message-ID: <20230427210851-mutt-send-email-mst@kernel.org>
References: <1682585517.595783-3-xuanzhuo@linux.alibaba.com>
 <20230427104618.3297348-1-wangwenliang.1995@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427104618.3297348-1-wangwenliang.1995@bytedance.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 27, 2023 at 06:46:18PM +0800, Wenliang Wang wrote:
> For multi-queue and large ring-size use case, the following error
> occurred when free_unused_bufs:
> rcu: INFO: rcu_sched self-detected stall on CPU.
> 
> Signed-off-by: Wenliang Wang <wangwenliang.1995@bytedance.com>

pls send vN+1 as a new thread not as a reply in existing thread of vN.

> ---
> v2:
> -add need_resched check.
> -apply same logic to sq.
> ---
>  drivers/net/virtio_net.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index ea1bd4bb326d..573558b69a60 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3559,12 +3559,16 @@ static void free_unused_bufs(struct virtnet_info *vi)
>  		struct virtqueue *vq = vi->sq[i].vq;
>  		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
>  			virtnet_sq_free_unused_buf(vq, buf);
> +		if (need_resched())
> +			schedule();
>  	}
>  
>  	for (i = 0; i < vi->max_queue_pairs; i++) {
>  		struct virtqueue *vq = vi->rq[i].vq;
>  		while ((buf = virtqueue_detach_unused_buf(vq)) != NULL)
>  			virtnet_rq_free_unused_buf(vq, buf);
> +		if (need_resched())
> +			schedule();
>  	}
>  }
>  
> -- 
> 2.20.1

