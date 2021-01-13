Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFCA2F4F18
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 16:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbhAMPqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 10:46:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31829 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725773AbhAMPqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 10:46:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610552698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XFDWpBt23ab/a+GLPKINLXPOKztfWYhyd/38BHS6Ncs=;
        b=FlUjIGlMXTNMNnE5xufvhrBHJyWtPZl6TfWsJTxaAvEhFy+nK0L1lbCRDzDlKzh80a3d1T
        YrFsxH0FyK5whm9funs+NG9dktswDYzOWl3SCBrUGPxGCR1jexXmIDjAOx4hbuP/WjKMHq
        5QoQQzWfJsg+a6SwKH2i1IB6lxt6Yo8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-378-2L_XHVpXMn6aBTerjPaQKg-1; Wed, 13 Jan 2021 10:44:54 -0500
X-MC-Unique: 2L_XHVpXMn6aBTerjPaQKg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8219215723;
        Wed, 13 Jan 2021 15:44:53 +0000 (UTC)
Received: from ovpn-115-228.ams2.redhat.com (ovpn-115-228.ams2.redhat.com [10.36.115.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5ED3713470;
        Wed, 13 Jan 2021 15:44:47 +0000 (UTC)
Message-ID: <2135e96c89ce3dced96c77702f2539ae3ce9d8bb.camel@redhat.com>
Subject: Re: [PATCH net] Revert "virtio_net: replace
 netdev_alloc_skb_ip_align() with napi_alloc_skb()"
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Greg Thelen <gthelen@google.com>
Date:   Wed, 13 Jan 2021 16:44:46 +0100
In-Reply-To: <20210113051207.142711-1-eric.dumazet@gmail.com>
References: <20210113051207.142711-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-01-12 at 21:12 -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This reverts commit c67f5db82027ba6d2ea4ac9176bc45996a03ae6a.
> 
> While using page fragments instead of a kmalloc backed skb->head might give
> a small performance improvement in some cases, there is a huge risk of
> memory use under estimation.
> 
> GOOD_COPY_LEN is 128 bytes. This means that we need a small amount
> of memory to hold the headers and struct skb_shared_info
> 
> Yet, napi_alloc_skb() might use a whole 32KB page (or 64KB on PowerPc)
> for long lived incoming TCP packets.
> 
> We have been tracking OOM issues on GKE hosts hitting tcp_mem limits
> but consuming far more memory for TCP buffers than instructed in tcp_mem[2]
> 
> Even if we force napi_alloc_skb() to only use order-0 pages, the issue
> would still be there on arches with PAGE_SIZE >= 32768
> 
> Using alloc_skb() and thus standard kmallloc() for skb->head allocations
> will get the benefit of letting other objects in each page being independently
> used by other skbs, regardless of the lifetime.
> 
> Note that a similar problem exists for skbs allocated from napi_get_frags(),
> this is handled in a separate patch.
> 
> I would like to thank Greg Thelen for his precious help on this matter,
> analysing crash dumps is always a time consuming task.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Greg Thelen <gthelen@google.com>
> ---
>  drivers/net/virtio_net.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 508408fbe78fbd8658dc226834b5b1b334b8b011..5886504c1acacf3f6148127b5c1cc7f6a906b827 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -386,7 +386,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>  	p = page_address(page) + offset;
>  
>  	/* copy small packet so we can reuse these pages for small data */
> -	skb = napi_alloc_skb(&rq->napi, GOOD_COPY_LEN);
> +	skb = netdev_alloc_skb_ip_align(vi->dev, GOOD_COPY_LEN);
>  	if (unlikely(!skb))
>  		return NULL;

I'm ok with the revert. The gain given by the original change in my
tests was measurable, but small.

Acked-by: Paolo Abeni <pabeni@redhat.com>

