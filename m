Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3CA35DA64
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 10:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244144AbhDMIyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 04:54:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28156 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243801AbhDMIyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 04:54:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618304023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LDhoSh21yQrWIxiZzfscdfh5hO+ef3/ijfa5Lxrgzu8=;
        b=XB5HkVSSHWQNQMaC/tpKSf8a1MxLABiOnXWQhojNYC7axifl5gc0JUtipNGJ9JNT7ELvs2
        lS55ua1NGBfDnYTgmWs8sQxK86jIqmNtrK4I+l3tcfsVxUKvxBWLv5iSm5+scDeV7KE7LF
        eq4032hZkgLHJbieyDxpiPWAgVGG6UE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-ucyBEUMsMZS0xJSAi2JD3Q-1; Tue, 13 Apr 2021 04:53:41 -0400
X-MC-Unique: ucyBEUMsMZS0xJSAi2JD3Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D7B010054F6;
        Tue, 13 Apr 2021 08:53:40 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-128.pek2.redhat.com [10.72.13.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37A2D1C952;
        Tue, 13 Apr 2021 08:53:33 +0000 (UTC)
Subject: Re: [PATCH RFC v2 2/4] virtio_net: disable cb aggressively
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org
References: <20210413054733.36363-1-mst@redhat.com>
 <20210413054733.36363-3-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <43db5c1e-9908-55bb-6d1a-c6c8d71e2315@redhat.com>
Date:   Tue, 13 Apr 2021 16:53:32 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210413054733.36363-3-mst@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/13 ÏÂÎç1:47, Michael S. Tsirkin Ð´µÀ:
> There are currently two cases where we poll TX vq not in response to a
> callback: start xmit and rx napi.  We currently do this with callbacks
> enabled which can cause extra interrupts from the card.  Used not to be
> a big issue as we run with interrupts disabled but that is no longer the
> case, and in some cases the rate of spurious interrupts is so high
> linux detects this and actually kills the interrupt.
>
> Fix up by disabling the callbacks before polling the tx vq.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   drivers/net/virtio_net.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 82e520d2cb12..16d5abed582c 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1429,6 +1429,7 @@ static void virtnet_poll_cleantx(struct receive_queue *rq)
>   		return;
>   
>   	if (__netif_tx_trylock(txq)) {
> +		virtqueue_disable_cb(sq->vq);
>   		free_old_xmit_skbs(sq, true);
>   		__netif_tx_unlock(txq);


Any reason that we don't need to enable the cb here?

And as we discussed in the past, it's probably the time to have a single 
NAPI for both tx and rx?

Thanks


>   	}
> @@ -1582,6 +1583,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
>   	bool use_napi = sq->napi.weight;
>   
>   	/* Free up any pending old buffers before queueing new ones. */
> +	virtqueue_disable_cb(sq->vq);
>   	free_old_xmit_skbs(sq, false);
>   
>   	if (use_napi && kick)

