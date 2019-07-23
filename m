Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADE1714CD
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 11:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388867AbfGWJQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 05:16:53 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38631 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388859AbfGWJQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 05:16:52 -0400
Received: by mail-qk1-f196.google.com with SMTP id a27so30585144qkk.5
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 02:16:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p1+gYIBWMowLYRybQ6oWxpq5UdgeV2arIpG6bdXu/8w=;
        b=pnTv9YRts4ATmZ5rt3KLL74IcnLyToABc2ip6DqQGjLExTf9+dTBPFgVtaZtFDd+Xv
         ZiOXoCKip1EogxGLr+QYT4Kq1GiXrU92ShE4WB4fXikT/PhC3qLY9bUjGencwIExpvLQ
         DVIDetqt7M6TogPpKih0SO6E19CnaTfBm/Bsu0Uwn1JNlifTK7F2TuYW38tkI8++wkxF
         tp4LXNFGn4KiTBzjby2W5gs1tBzzD7UU+I034OsUqg5ZmyRDte3xGfiXMZ5UqbRKlyvg
         ceXUdvmoMWQRej1Bjk6CUj9NqehMW60HKgkzacw6nm2A2Tj+zPApBn7KxsQqHU/84j7P
         2gww==
X-Gm-Message-State: APjAAAWZjJ5SPaceTRtzOnVkBvlulMnbff+GXAN84P/Adjs6aGbZgsmB
        eNK0zUoSKTIQUOR/jLuuoSKc9w==
X-Google-Smtp-Source: APXvYqyu6jNlikk+iK+Qd5rby5/UX6t/lEzykZfn5ns4rVGJkT29eU29dnU+XKBwjNMXoWgetKh15w==
X-Received: by 2002:a37:6508:: with SMTP id z8mr48471820qkb.492.1563873411371;
        Tue, 23 Jul 2019 02:16:51 -0700 (PDT)
Received: from redhat.com (bzq-79-181-91-42.red.bezeqint.net. [79.181.91.42])
        by smtp.gmail.com with ESMTPSA id t12sm18734095qtr.49.2019.07.23.02.16.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 02:16:50 -0700 (PDT)
Date:   Tue, 23 Jul 2019 05:16:45 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] vhost: don't do synchronize_rcu() in
 vhost_uninit_vq_maps()
Message-ID: <20190723041144-mutt-send-email-mst@kernel.org>
References: <20190723075718.6275-1-jasowang@redhat.com>
 <20190723075718.6275-7-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723075718.6275-7-jasowang@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 03:57:18AM -0400, Jason Wang wrote:
> There's no need for RCU synchronization in vhost_uninit_vq_maps()
> since we've already serialized with readers (memory accessors). This
> also avoid the possible userspace DOS through ioctl() because of the
> possible high latency caused by synchronize_rcu().
> 
> Reported-by: Michael S. Tsirkin <mst@redhat.com>
> Fixes: 7f466032dc9e ("vhost: access vq metadata through kernel virtual address")
> Signed-off-by: Jason Wang <jasowang@redhat.com>

I agree synchronize_rcu in both mmu notifiers and ioctl
is a problem we must fix.

> ---
>  drivers/vhost/vhost.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 5b8821d00fe4..a17df1f4069a 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -334,7 +334,9 @@ static void vhost_uninit_vq_maps(struct vhost_virtqueue *vq)
>  	}
>  	spin_unlock(&vq->mmu_lock);
>  
> -	synchronize_rcu();
> +	/* No need for synchronize_rcu() or kfree_rcu() since we are
> +	 * serialized with memory accessors (e.g vq mutex held).
> +	 */
>  
>  	for (i = 0; i < VHOST_NUM_ADDRS; i++)
>  		if (map[i])
> -- 
> 2.18.1

.. however we can not RCU with no synchronization in sight.
Sometimes there are hacks like using a lock/unlock
pair instead of sync, but here no one bothers.

specifically notifiers call reset vq maps which calls
uninit vq maps which is not under any lock.

You will get use after free when map is then accessed.

If you always have a lock then just take that lock
and no need for RCU.

-- 
MST
