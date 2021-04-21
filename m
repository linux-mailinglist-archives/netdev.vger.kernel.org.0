Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C359C366399
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 04:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234642AbhDUCTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 22:19:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51871 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234641AbhDUCT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 22:19:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618971537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9yVWRiTHEeiJqibXK+e+btFkthskENsxGNffKLisiss=;
        b=cdElWFCe467FXfLw114D55njFCKCMRkvU7SolYzuz5WHiuBEVfo7hHfsVsQtlDeKjO+7IB
        pnV5dLxsz1eXASrBRL/NiDWafmeG9/RQyXxehudOPky60mE3eacdm/vWvu0MYPKM9Gw1gY
        NH6gdr1yKUTdInkXaBSQMeagqjudIVk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-mztFxCmlM0KYyf41_JgvWQ-1; Tue, 20 Apr 2021 22:18:53 -0400
X-MC-Unique: mztFxCmlM0KYyf41_JgvWQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D86D8189CE;
        Wed, 21 Apr 2021 02:18:51 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-189.pek2.redhat.com [10.72.13.189])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8EDDE5032C;
        Wed, 21 Apr 2021 02:18:45 +0000 (UTC)
Subject: Re: [PATCH net-next] virtio-net: restrict build_skb() use to some
 arches
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
References: <20210420200144.4189597-1-eric.dumazet@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <179b050d-52b0-7201-9b1c-702d0978d496@redhat.com>
Date:   Wed, 21 Apr 2021 10:18:43 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210420200144.4189597-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/21 ÉÏÎç4:01, Eric Dumazet Ð´µÀ:
> From: Eric Dumazet <edumazet@google.com>
>
> build_skb() is supposed to be followed by
> skb_reserve(skb, NET_IP_ALIGN), so that IP headers are word-aligned.
> (Best practice is to reserve NET_IP_ALIGN+NET_SKB_PAD, but the NET_SKB_PAD
> part is only a performance optimization if tunnel encaps are added.)
>
> Unfortunately virtio_net has not provisioned this reserve.
> We can only use build_skb() for arches where NET_IP_ALIGN == 0
>
> We might refine this later, with enough testing.
>
> Fixes: fb32856b16ad ("virtio-net: page_to_skb() use build_skb when there's sufficient tailroom")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: virtualization@lists.linux-foundation.org


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/net/virtio_net.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 2e28c04aa6351d2b4016f7d277ce104c4970069d..74d2d49264f3f3b7039be70331d4a44c53b8cc28 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -416,7 +416,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
>   
>   	shinfo_size = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
>   
> -	if (len > GOOD_COPY_LEN && tailroom >= shinfo_size) {
> +	if (!NET_IP_ALIGN && len > GOOD_COPY_LEN && tailroom >= shinfo_size) {
>   		skb = build_skb(p, truesize);
>   		if (unlikely(!skb))
>   			return NULL;

