Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECA43714D8
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 11:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388904AbfGWJRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 05:17:34 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36201 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731634AbfGWJRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 05:17:34 -0400
Received: by mail-qk1-f194.google.com with SMTP id g18so30563620qkl.3
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 02:17:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zIMuDv+zk7S1NCvH0qhLppn9YRoVaxQzRUcA6IGuXcs=;
        b=B3Ti7iIZDQHXP/EZlqnzPlsvpgVHGBo99Gc1INBdmWGQjPDGXoalQjlMwa7wRT7WyV
         ZdE6QUABZb5YMwHkEn1scFJIYCYd0vh+yIDCodCfv51YU3W7tjZIm4+/bmgMvPEaItCY
         BzaVat+N/mFFfUtFVBUFIGede68ZUY/fBiZ2JlsmuePZ008NQuc4Ky8JKmOw4EsUxt7r
         W6wb7cLm47dqHhr7AvMqAjnON3xf816emTT18e402nj/fnqkIjqGF3v0bGQxW5f+PJnl
         c1ioatDDY/HdI69it9AZplWuM91iTbrYqn983YlT47TrJsPgFV6y/U8NpKqFktVEyN3y
         T//Q==
X-Gm-Message-State: APjAAAVvCx+lLrqHtFxPaEjA0D75Pt/TPbYrV/nkvTMPARfHoppV+k+C
        ifNgBhj52TMaxHd7mqnWDMMgPQ==
X-Google-Smtp-Source: APXvYqxCxrHJb2/RQUMnbweSxs5Cq2YkuyrJJ0kQghMt/IAIFI53AquzBnAmUMtJGKkqG286t9N46w==
X-Received: by 2002:a37:646:: with SMTP id 67mr47571333qkg.287.1563873453656;
        Tue, 23 Jul 2019 02:17:33 -0700 (PDT)
Received: from redhat.com (bzq-79-181-91-42.red.bezeqint.net. [79.181.91.42])
        by smtp.gmail.com with ESMTPSA id g54sm25451794qtc.61.2019.07.23.02.17.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 02:17:32 -0700 (PDT)
Date:   Tue, 23 Jul 2019 05:17:28 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] vhost: reset invalidate_count in
 vhost_set_vring_num_addr()
Message-ID: <20190723042143-mutt-send-email-mst@kernel.org>
References: <20190723075718.6275-1-jasowang@redhat.com>
 <20190723075718.6275-5-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723075718.6275-5-jasowang@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 03:57:16AM -0400, Jason Wang wrote:
> The vhost_set_vring_num_addr() could be called in the middle of
> invalidate_range_start() and invalidate_range_end(). If we don't reset
> invalidate_count after the un-registering of MMU notifier, the
> invalidate_cont will run out of sync (e.g never reach zero). This will
> in fact disable the fast accessor path. Fixing by reset the count to
> zero.
> 
> Reported-by: Michael S. Tsirkin <mst@redhat.com>
> Fixes: 7f466032dc9e ("vhost: access vq metadata through kernel virtual address")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/vhost.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 03666b702498..89c9f08b5146 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2074,6 +2074,10 @@ static long vhost_vring_set_num_addr(struct vhost_dev *d,
>  		d->has_notifier = false;
>  	}
>  
> +	/* reset invalidate_count in case we are in the middle of
> +	 * invalidate_start() and invalidate_end().
> +	 */
> +	vq->invalidate_count = 0;

I think that the code is ok but the comments are not very clear:
- we are never in the middle since we just removed the notifier
- the result is not just disabling optimization:
  if notifier becomes negative, then later we
  can think it's ok to map when it isn't since
  notifier is active.

>  	vhost_uninit_vq_maps(vq);
>  #endif
>  
> -- 
> 2.18.1
