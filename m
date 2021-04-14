Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329B435EB7B
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 05:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233314AbhDNDep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 23:34:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35440 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233286AbhDNDeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 23:34:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618371263;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CLfRM/TFiz4bH/Fuoa5M4fK7KllTM/752Rs7vsgn1IA=;
        b=DADUx0a7WsyGOwWzSxo6Qg+GJyLjN/uwfIKg8qLhjGRHrPsot3VJSzNmW8SCOgKhjQpPBt
        Y1uH0YagOaJm9CugwO0AEgH9zZpIY+ExfaBgNvTQThpILKRw5SKhjMDswUQfC/tk0yIB5i
        M/+NZCilcq+SSFm5ojd+Z9/IulCkai8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-483-UM4ytrdeP_6nttRSXdU59Q-1; Tue, 13 Apr 2021 23:34:19 -0400
X-MC-Unique: UM4ytrdeP_6nttRSXdU59Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C0A0192AB70;
        Wed, 14 Apr 2021 03:34:17 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-196.pek2.redhat.com [10.72.13.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 470F5710A6;
        Wed, 14 Apr 2021 03:34:09 +0000 (UTC)
Subject: Re: [PATCH net-next v4 07/10] virtio-net: virtnet_poll_tx support
 budget check
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        "dust . li" <dust.li@linux.alibaba.com>
References: <20210413031523.73507-1-xuanzhuo@linux.alibaba.com>
 <20210413031523.73507-8-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ad27f0b5-713f-f6f3-ba51-0468db9897ca@redhat.com>
Date:   Wed, 14 Apr 2021 11:34:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210413031523.73507-8-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/13 ÉÏÎç11:15, Xuan Zhuo Ð´µÀ:
> virtnet_poll_tx() check the work done like other network card drivers.
>
> When work < budget, napi_poll() in dev.c will exit directly. And
> virtqueue_napi_complete() will be called to close napi. If closing napi
> fails or there is still data to be processed, virtqueue_napi_complete()
> will make napi schedule again, and no conflicts with the logic of
> napi_poll().
>
> When work == budget, virtnet_poll_tx() will return the var 'work', and
> the napi_poll() in dev.c will re-add napi to the queue.
>
> The purpose of this patch is to support xsk xmit in virtio_poll_tx for
> subsequent patch.
>
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/net/virtio_net.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index f3752b254965..f52a25091322 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1529,6 +1529,7 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
>   	struct virtnet_info *vi = sq->vq->vdev->priv;
>   	unsigned int index = vq2txq(sq->vq);
>   	struct netdev_queue *txq;
> +	int work_done = 0;
>   
>   	if (unlikely(is_xdp_raw_buffer_queue(vi, index))) {
>   		/* We don't need to enable cb for XDP */
> @@ -1541,12 +1542,13 @@ static int virtnet_poll_tx(struct napi_struct *napi, int budget)
>   	free_old_xmit(sq, true);
>   	__netif_tx_unlock(txq);
>   
> -	virtqueue_napi_complete(napi, sq->vq, 0);
> +	if (work_done < budget)
> +		virtqueue_napi_complete(napi, sq->vq, 0);
>   
>   	if (sq->vq->num_free >= 2 + MAX_SKB_FRAGS)
>   		netif_tx_wake_queue(txq);
>   
> -	return 0;
> +	return work_done;
>   }
>   
>   static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)

