Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 998ED2E29F7
	for <lists+netdev@lfdr.de>; Fri, 25 Dec 2020 07:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgLYGTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Dec 2020 01:19:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50731 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725781AbgLYGTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Dec 2020 01:19:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608877097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TpqVkUDXq+c4toXVZRgWMvwCiy7iTphoDiBdMjsrs6k=;
        b=LOkm3u6PsKWTZtzPJMDG7eM8uxPJ04ZcCJFkwjBHKw+0iqUFtnnnrHsUG+1gAdMEysINNJ
        29Dta6bZ+oTHGa6pWsehX+MKzZhDuERCY+DRaMevFxEeE3tnUKtoR7GgXhv5+g804y/fJH
        FBo3NIHC4qMJTPkHkOdU3fNzKOysvwc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-xPtuXUzFMiK4Elmmw801lQ-1; Fri, 25 Dec 2020 01:18:13 -0500
X-MC-Unique: xPtuXUzFMiK4Elmmw801lQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B22B107ACF5;
        Fri, 25 Dec 2020 06:18:11 +0000 (UTC)
Received: from [10.72.12.166] (ovpn-12-166.pek2.redhat.com [10.72.12.166])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B987B10023B9;
        Fri, 25 Dec 2020 06:18:04 +0000 (UTC)
Subject: Re: [PATCH net v2] tun: fix return value when the number of iovs
 exceeds MAX_SKB_FRAGS
To:     wangyunjian <wangyunjian@huawei.com>, netdev@vger.kernel.org,
        mst@redhat.com, willemdebruijn.kernel@gmail.com
Cc:     virtualization@lists.linux-foundation.org,
        jerry.lilijun@huawei.com, chenchanghu@huawei.com,
        xudingke@huawei.com, brian.huangbin@huawei.com
References: <1608864736-24332-1-git-send-email-wangyunjian@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b9de1be1-159f-455d-445a-c37edae32574@redhat.com>
Date:   Fri, 25 Dec 2020 14:18:03 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1608864736-24332-1-git-send-email-wangyunjian@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/25 上午10:52, wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
>
> Currently the tun_napi_alloc_frags() function returns -ENOMEM when the
> number of iovs exceeds MAX_SKB_FRAGS + 1. However this is inappropriate,
> we should use -EMSGSIZE instead of -ENOMEM.
>
> The following distinctions are matters:
> 1. the caller need to drop the bad packet when -EMSGSIZE is returned,
>     which means meeting a persistent failure.
> 2. the caller can try again when -ENOMEM is returned, which means
>     meeting a transient failure.
>
> Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP driver")
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> Acked-by: Willem de Bruijn <willemb@google.com>
> ---
> v2:
>    * update commit log suggested by Willem de Bruijn
> ---
>   drivers/net/tun.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 2dc1988a8973..15c6dd7fb04c 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1365,7 +1365,7 @@ static struct sk_buff *tun_napi_alloc_frags(struct tun_file *tfile,
>   	int i;
>   
>   	if (it->nr_segs > MAX_SKB_FRAGS + 1)
> -		return ERR_PTR(-ENOMEM);
> +		return ERR_PTR(-EMSGSIZE);
>   
>   	local_bh_disable();
>   	skb = napi_get_frags(&tfile->napi);


Acked-by: Jason Wang <jasowang@redhat.com>


