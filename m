Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3CE33AD7C
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 09:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhCOIb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 04:31:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34497 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229562AbhCOIbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 04:31:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615797082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZKg5OJ0Wle9GUUJPspxr/sYEl3Le9qh1nxrGMT+1Rf8=;
        b=Ci1LqmUhOUZF0T9U/PowjRonA7I9orlrLIvqGHyCmVyHYoAmw/xuOld9AM87hCexdZoYSx
        8ulK/0A1W6JuAP+BO4yiaLzz7dlb1Zc7reTexQBSKWpRPs5vNzL8bdwznPpoFMpRjuGl98
        sX6csTpcqIq74tbsHSjdAE8EzjTNmcc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-aFVIdB69NjiChjbvg0Tg4g-1; Mon, 15 Mar 2021 04:31:20 -0400
X-MC-Unique: aFVIdB69NjiChjbvg0Tg4g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79845100C665;
        Mon, 15 Mar 2021 08:31:19 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-245.pek2.redhat.com [10.72.12.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 77A355D745;
        Mon, 15 Mar 2021 08:31:13 +0000 (UTC)
Subject: Re: [PATCH] vhost: Fix vhost_vq_reset()
To:     Laurent Vivier <lvivier@redhat.com>, linux-kernel@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
References: <20210312140913.788592-1-lvivier@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7bb4ee1a-d204-eb94-792f-ca250dacacea@redhat.com>
Date:   Mon, 15 Mar 2021 16:31:11 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210312140913.788592-1-lvivier@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/3/12 ÏÂÎç10:09, Laurent Vivier Ð´µÀ:
> vhost_reset_is_le() is vhost_init_is_le(), and in the case of
> cross-endian legacy, vhost_init_is_le() depends on vq->user_be.
>
> vq->user_be is set by vhost_disable_cross_endian().
>
> But in vhost_vq_reset(), we have:
>
>      vhost_reset_is_le(vq);
>      vhost_disable_cross_endian(vq);
>
> And so user_be is used before being set.
>
> To fix that, reverse the lines order as there is no other dependency
> between them.
>
> Signed-off-by: Laurent Vivier <lvivier@redhat.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vhost/vhost.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index a262e12c6dc2..5ccb0705beae 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -332,8 +332,8 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>   	vq->error_ctx = NULL;
>   	vq->kick = NULL;
>   	vq->log_ctx = NULL;
> -	vhost_reset_is_le(vq);
>   	vhost_disable_cross_endian(vq);
> +	vhost_reset_is_le(vq);
>   	vq->busyloop_timeout = 0;
>   	vq->umem = NULL;
>   	vq->iotlb = NULL;

