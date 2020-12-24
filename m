Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A122E23F5
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 04:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728758AbgLXDMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 22:12:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42065 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728357AbgLXDMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 22:12:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608779439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d5ECQoERo7ozEZ7ZyUdd7rpKW0sc1bjVRvw6JsEPNx0=;
        b=eSVK/7HHm8IeuYJEdjfXouoH8eMlJg+7kGSlOmMHHQvAeKdYbJrLUnPz7eTuDkuIFudC/y
        fGKEjuG5FMe3xS5iktVjR2eU6cACkzakSOwmXQTPlwqNvg25Heu649htzE5w9+nw92HR9k
        Q3TtH7fL+bNA9MSNQchvKnnguWWuQSw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-d9-m4xBwMgqmP6KrJLO4rA-1; Wed, 23 Dec 2020 22:10:35 -0500
X-MC-Unique: d9-m4xBwMgqmP6KrJLO4rA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3F7A5107ACE6;
        Thu, 24 Dec 2020 03:10:33 +0000 (UTC)
Received: from [10.72.13.109] (ovpn-13-109.pek2.redhat.com [10.72.13.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 054165D9CD;
        Thu, 24 Dec 2020 03:10:26 +0000 (UTC)
Subject: Re: [PATCH net v4 2/2] vhost_net: fix tx queue stuck when sendmsg
 fails
To:     wangyunjian <wangyunjian@huawei.com>, netdev@vger.kernel.org,
        mst@redhat.com, willemdebruijn.kernel@gmail.com
Cc:     virtualization@lists.linux-foundation.org,
        jerry.lilijun@huawei.com, chenchanghu@huawei.com,
        xudingke@huawei.com, brian.huangbin@huawei.com
References: <1608776746-4040-1-git-send-email-wangyunjian@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c854850b-43ab-c98d-a4d8-36ad7cd6364c@redhat.com>
Date:   Thu, 24 Dec 2020 11:10:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1608776746-4040-1-git-send-email-wangyunjian@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/24 上午10:25, wangyunjian wrote:
> From: Yunjian Wang <wangyunjian@huawei.com>
>
> Currently the driver doesn't drop a packet which can't be sent by tun
> (e.g bad packet). In this case, the driver will always process the
> same packet lead to the tx queue stuck.
>
> To fix this issue:
> 1. in the case of persistent failure (e.g bad packet), the driver
> can skip this descriptor by ignoring the error.
> 2. in the case of transient failure (e.g -EAGAIN and -ENOMEM), the
> driver schedules the worker to try again.


I might be wrong but looking at alloc_skb_with_frags(), it returns 
-ENOBUFS actually:

     *errcode = -ENOBUFS;
     skb = alloc_skb(header_len, gfp_mask);
     if (!skb)
         return NULL;

Thanks


>
> Fixes: 3a4d5c94e959 ("vhost_net: a kernel-level virtio server")
> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
> ---
>   drivers/vhost/net.c | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index c8784dfafdd7..e76245daa7f6 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -827,14 +827,13 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>   				msg.msg_flags &= ~MSG_MORE;
>   		}
>   
> -		/* TODO: Check specific error and bomb out unless ENOBUFS? */
>   		err = sock->ops->sendmsg(sock, &msg, len);
> -		if (unlikely(err < 0)) {
> +		if (unlikely(err == -EAGAIN || err == -ENOMEM)) {
>   			vhost_discard_vq_desc(vq, 1);
>   			vhost_net_enable_vq(net, vq);
>   			break;
>   		}
> -		if (err != len)
> +		if (err >= 0 && err != len)
>   			pr_debug("Truncated TX packet: len %d != %zd\n",
>   				 err, len);
>   done:
> @@ -922,7 +921,6 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>   			msg.msg_flags &= ~MSG_MORE;
>   		}
>   
> -		/* TODO: Check specific error and bomb out unless ENOBUFS? */
>   		err = sock->ops->sendmsg(sock, &msg, len);
>   		if (unlikely(err < 0)) {
>   			if (zcopy_used) {
> @@ -931,11 +929,13 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
>   				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
>   					% UIO_MAXIOV;
>   			}
> -			vhost_discard_vq_desc(vq, 1);
> -			vhost_net_enable_vq(net, vq);
> -			break;
> +			if (err == -EAGAIN || err == -ENOMEM) {
> +				vhost_discard_vq_desc(vq, 1);
> +				vhost_net_enable_vq(net, vq);
> +				break;
> +			}
>   		}
> -		if (err != len)
> +		if (err >= 0 && err != len)
>   			pr_debug("Truncated TX packet: "
>   				 " len %d != %zd\n", err, len);
>   		if (!zcopy_used)

