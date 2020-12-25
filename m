Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61BAE2E2A0A
	for <lists+netdev@lfdr.de>; Fri, 25 Dec 2020 07:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbgLYGmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Dec 2020 01:42:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47587 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725779AbgLYGmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Dec 2020 01:42:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608878466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xM6ipW2bJRZDLWmIx8iPsoeWBN30KOgJ6lEUY6brlAg=;
        b=AOafFr3VcqUT4Z45o44xJ+FubXha+A8GOZ9QqwPIwsWeSGibuuVRgUBykQem7DiTfzIZeh
        JKj19hSYtQyuYB2gN4qLTf3xHafa0CteDnJgB9AeWGP3U1pM3n60bXb6aJ2Mk1EmrfLR5y
        +d7N0HXELlI39Ka7BRYdmvM8ddzb4Qk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-yWBZZCZlPKKvzQZvE8evBQ-1; Fri, 25 Dec 2020 01:38:33 -0500
X-MC-Unique: yWBZZCZlPKKvzQZvE8evBQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BBDB15720;
        Fri, 25 Dec 2020 06:38:32 +0000 (UTC)
Received: from [10.72.12.97] (ovpn-12-97.pek2.redhat.com [10.72.12.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9ABB26F816;
        Fri, 25 Dec 2020 06:38:25 +0000 (UTC)
Subject: Re: [PATCH net v4 1/2] vhost_net: fix ubuf refcount incorrectly when
 sendmsg fails
To:     wangyunjian <wangyunjian@huawei.com>, netdev@vger.kernel.org,
        mst@redhat.com, willemdebruijn.kernel@gmail.com
Cc:     virtualization@lists.linux-foundation.org,
        jerry.lilijun@huawei.com, chenchanghu@huawei.com,
        xudingke@huawei.com, brian.huangbin@huawei.com
References: <1608776738-21868-1-git-send-email-wangyunjian@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ab017214-9090-bff0-93db-a00f022c07e9@redhat.com>
Date:   Fri, 25 Dec 2020 14:38:23 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1608776738-21868-1-git-send-email-wangyunjian@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/24 上午10:25, wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
>
> Currently the vhost_zerocopy_callback() maybe be called to decrease
> the refcount when sendmsg fails in tun. The error handling in vhost
> handle_tx_zerocopy() will try to decrease the same refcount again.
> This is wrong. To fix this issue, we only call vhost_net_ubuf_put()
> when vq->heads[nvq->desc].len == VHOST_DMA_IN_PROGRESS.
>
> Fixes: 0690899b4d45 ("tun: experimental zero copy tx support")
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> Acked-by: Willem de Bruijn <willemb@google.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vhost/net.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 531a00d703cd..c8784dfafdd7 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -863,6 +863,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>   	size_t len, total_len = 0;
>   	int err;
>   	struct vhost_net_ubuf_ref *ubufs;
> +	struct ubuf_info *ubuf;
>   	bool zcopy_used;
>   	int sent_pkts = 0;
>   
> @@ -895,9 +896,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>   
>   		/* use msg_control to pass vhost zerocopy ubuf info to skb */
>   		if (zcopy_used) {
> -			struct ubuf_info *ubuf;
>   			ubuf = nvq->ubuf_info + nvq->upend_idx;
> -
>   			vq->heads[nvq->upend_idx].id = cpu_to_vhost32(vq, head);
>   			vq->heads[nvq->upend_idx].len = VHOST_DMA_IN_PROGRESS;
>   			ubuf->callback = vhost_zerocopy_callback;
> @@ -927,7 +926,8 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>   		err = sock->ops->sendmsg(sock, &msg, len);
>   		if (unlikely(err < 0)) {
>   			if (zcopy_used) {
> -				vhost_net_ubuf_put(ubufs);
> +				if (vq->heads[ubuf->desc].len == VHOST_DMA_IN_PROGRESS)
> +					vhost_net_ubuf_put(ubufs);
>   				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
>   					% UIO_MAXIOV;
>   			}

