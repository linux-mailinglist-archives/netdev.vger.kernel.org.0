Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91D59AFE1D
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 15:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbfIKNwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 09:52:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44924 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726952AbfIKNwb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 09:52:31 -0400
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 65F0E4DB1F
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 13:52:31 +0000 (UTC)
Received: by mail-qt1-f198.google.com with SMTP id y13so23763115qtn.6
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 06:52:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bTpTDYaW4L1Gk4pQTaJgOsQGofG8+keatPi5K+boUSM=;
        b=FoUGYHDfQQAP6Ejf7b1sx1FpCPBhx9LedHR0x+G+UJOGBmjZhBy72RV6FlesncEE1O
         YzJ5h6LmGLrc1o0fzk7tHaXOmYki8EmSWVwI2NGcQQDyO9xFxKDsjdw0TsERXiMMube2
         R7jwWkvVKZVXrQpp7B80hQE0GFvc500+mRV9qcy2iPI62ZXOgkjRC6rOuOOdRMNC/nC3
         16pDxvn+g2N0IG8l/nGsUURXZj8FOCoaoBHVpYozaApP5CjWVglNN17iHSuf7r86uN/e
         tuMXK8ob0Q5w/27mxYgRXh5041FI90tB98ZGVATASZmdmROLjfDGE9AB9AF5KpZeM6DK
         w+Lg==
X-Gm-Message-State: APjAAAXFIudtTr+1/ytP6F8eL8PKaG184W35cOfP8R/+9RA3eEYCSzZc
        x92MjKTPYW2qj2Vw1fa5Pc5nE4QmyyvK8CFj/o4Fi1X4wGxj6RofTK+U5Xp6Rs918pIB4KJ+8XU
        3yKKTn9nuzF7tysdx
X-Received: by 2002:a37:4651:: with SMTP id t78mr35308376qka.259.1568209950741;
        Wed, 11 Sep 2019 06:52:30 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzAArEKuceihQtc6r95FHhQta9AhTzn+LrxDRMztlrzqQf2WbTHO7axIccFjavXyHt6DHiEWw==
X-Received: by 2002:a37:4651:: with SMTP id t78mr35308358qka.259.1568209950581;
        Wed, 11 Sep 2019 06:52:30 -0700 (PDT)
Received: from redhat.com ([80.74.107.118])
        by smtp.gmail.com with ESMTPSA id n62sm9969475qkd.124.2019.09.11.06.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 06:52:29 -0700 (PDT)
Date:   Wed, 11 Sep 2019 09:52:25 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        security@kernel.org
Subject: Re: [PATCH v2] vhost: block speculation of translated descriptors
Message-ID: <20190911095147-mutt-send-email-mst@kernel.org>
References: <20190911120908.28410-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911120908.28410-1-mst@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 08:10:00AM -0400, Michael S. Tsirkin wrote:
> iovec addresses coming from vhost are assumed to be
> pre-validated, but in fact can be speculated to a value
> out of range.
> 
> Userspace address are later validated with array_index_nospec so we can
> be sure kernel info does not leak through these addresses, but vhost
> must also not leak userspace info outside the allowed memory table to
> guests.
> 
> Following the defence in depth principle, make sure
> the address is not validated out of node range.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Acked-by: Jason Wang <jasowang@redhat.com>
> Tested-by: Jason Wang <jasowang@redhat.com>
> ---

Cc: security@kernel.org

Pls advise on whether you'd like me to merge this directly,
Cc stable, or handle it in some other way.

> changes from v1: fix build on 32 bit
> 
>  drivers/vhost/vhost.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 5dc174ac8cac..34ea219936e3 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2071,8 +2071,10 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
>  		_iov = iov + ret;
>  		size = node->size - addr + node->start;
>  		_iov->iov_len = min((u64)len - s, size);
> -		_iov->iov_base = (void __user *)(unsigned long)
> -			(node->userspace_addr + addr - node->start);
> +		_iov->iov_base = (void __user *)
> +			((unsigned long)node->userspace_addr +
> +			 array_index_nospec((unsigned long)(addr - node->start),
> +					    node->size));
>  		s += size;
>  		addr += size;
>  		++ret;
> -- 
> MST
