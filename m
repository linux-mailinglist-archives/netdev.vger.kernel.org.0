Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 869B984B31
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 14:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbfHGMHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 08:07:40 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33076 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727171AbfHGMHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 08:07:40 -0400
Received: by mail-qt1-f193.google.com with SMTP id r6so83771418qtt.0
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 05:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=v26ljGQm8kb1b/B+MgY9iqkRnu2IlPlITotoyjOaRLE=;
        b=FwqxEndrrseDTfa7IA+ahMyXJcw275sq/ogyK1cE9Brfp/+cA5dthaNKeo43mipwCW
         6M3TrldZWv7JXH9KLIINp0G6YhemLDU3zOb98Y6ixjqND8Edt4vtD4dtABJZtPFOlNWQ
         7o+i/B+d4dsypsLc9FAuuiUZqdV3+cuQPd1u7fGeYNEYgtw4WFPR67fjUunxQzqjk+D+
         m/Hrc+kRzSQLc/Y4MNwDwO+mVI0ImT4tvNWKY8DSYiKFsYOn0c9EH2FZcaFik8oOhgro
         wCckNCtxQRpeA/pGd5OtN/Hmf4FSEtEBQR4gGNGlbagAyW+no63yQWaSBO4AtHGy6HOL
         lRNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=v26ljGQm8kb1b/B+MgY9iqkRnu2IlPlITotoyjOaRLE=;
        b=M+0XAasWvNqD/yvbMIQJAH2+VpvouHqKlEv3atzlLu996tKWnvHITUwy37287/9sRV
         NKl459L9IoyqF3PXCClk682FFp+/4dsK4yQPXle/IXkF0pqPzyzb4NiKsLT4+aohpOXp
         Nh4k1Z9Rw8EAX1z9yjstHLW3J3q1A1m84c3Mv+D03SYqrTmLfVYjiqS+RpMUTi0tmwML
         hXhMRaK8ESk56/TtXPpwf+LqQDAlO63tLUkopCx65pTwSnIJU2GOElWcTxFspPQ2yB9O
         jfcMGXbiNhm2UrU7uJhfZFDNWK6RAXFTna3TgOr1b/URth+deFniPSdaL2FYIKnihLf3
         QYRg==
X-Gm-Message-State: APjAAAXoAqmcM5O77qZkgd4rwvqhJH2oIhEXNHo1Yka5nIEepkEWwRAM
        VCuvDL+B+GIklyFAqMgvHCIHMQ==
X-Google-Smtp-Source: APXvYqwdlTEXDfbCbN8MO6nqW9FtHXr3xg/qpTMHDicPu2B1XqjJOXbR74uxCwKcBjwiEflnXc1c9w==
X-Received: by 2002:a0c:e790:: with SMTP id x16mr7775534qvn.120.1565179659437;
        Wed, 07 Aug 2019 05:07:39 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id p32sm45431550qtb.67.2019.08.07.05.07.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 07 Aug 2019 05:07:38 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hvKjC-0000z1-4M; Wed, 07 Aug 2019 09:07:38 -0300
Date:   Wed, 7 Aug 2019 09:07:38 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V4 7/9] vhost: do not use RCU to synchronize MMU notifier
 with worker
Message-ID: <20190807120738.GB1557@ziepe.ca>
References: <20190807070617.23716-1-jasowang@redhat.com>
 <20190807070617.23716-8-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807070617.23716-8-jasowang@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 07, 2019 at 03:06:15AM -0400, Jason Wang wrote:
> We used to use RCU to synchronize MMU notifier with worker. This leads
> calling synchronize_rcu() in invalidate_range_start(). But on a busy
> system, there would be many factors that may slow down the
> synchronize_rcu() which makes it unsuitable to be called in MMU
> notifier.
> 
> So this patch switches use seqlock counter to track whether or not the
> map was used. The counter was increased when vq try to start or finish
> uses the map. This means, when it was even, we're sure there's no
> readers and MMU notifier is synchronized. When it was odd, it means
> there's a reader we need to wait it to be even again then we are
> synchronized. Consider the read critical section is pretty small the
> synchronization should be done very fast.
> 
> Reported-by: Michael S. Tsirkin <mst@redhat.com>
> Fixes: 7f466032dc9e ("vhost: access vq metadata through kernel virtual address")
> Signed-off-by: Jason Wang <jasowang@redhat.com>
>  drivers/vhost/vhost.c | 141 ++++++++++++++++++++++++++----------------
>  drivers/vhost/vhost.h |   7 ++-
>  2 files changed, 90 insertions(+), 58 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index cfc11f9ed9c9..57bfbb60d960 100644
> +++ b/drivers/vhost/vhost.c
> @@ -324,17 +324,16 @@ static void vhost_uninit_vq_maps(struct vhost_virtqueue *vq)
>  
>  	spin_lock(&vq->mmu_lock);
>  	for (i = 0; i < VHOST_NUM_ADDRS; i++) {
> -		map[i] = rcu_dereference_protected(vq->maps[i],
> -				  lockdep_is_held(&vq->mmu_lock));
> +		map[i] = vq->maps[i];
>  		if (map[i]) {
>  			vhost_set_map_dirty(vq, map[i], i);
> -			rcu_assign_pointer(vq->maps[i], NULL);
> +			vq->maps[i] = NULL;
>  		}
>  	}
>  	spin_unlock(&vq->mmu_lock);
>  
> -	/* No need for synchronize_rcu() or kfree_rcu() since we are
> -	 * serialized with memory accessors (e.g vq mutex held).
> +	/* No need for synchronization since we are serialized with
> +	 * memory accessors (e.g vq mutex held).
>  	 */
>  
>  	for (i = 0; i < VHOST_NUM_ADDRS; i++)
> @@ -362,6 +361,40 @@ static bool vhost_map_range_overlap(struct vhost_uaddr *uaddr,
>  	return !(end < uaddr->uaddr || start > uaddr->uaddr - 1 + uaddr->size);
>  }
>  
> +static void inline vhost_vq_access_map_begin(struct vhost_virtqueue *vq)
> +{
> +	write_seqcount_begin(&vq->seq);
> +}
> +
> +static void inline vhost_vq_access_map_end(struct vhost_virtqueue *vq)
> +{
> +	write_seqcount_end(&vq->seq);
> +}

The write side of a seqlock only provides write barriers. Access to

	map = vq->maps[VHOST_ADDR_USED];

Still needs a read side barrier, and then I think this will be no
better than a normal spinlock.

It also doesn't seem like this algorithm even needs a seqlock, as this
is just a one bit flag

atomic_set_bit(using map)
smp_mb__after_atomic()
.. maps [...]
atomic_clear_bit(using map)


map = NULL;
smp_mb__before_atomic();
while (atomic_read_bit(using map))
   relax()

Again, not clear this could be faster than a spinlock when the
barriers are correct...

Jason
