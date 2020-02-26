Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAC616F5E4
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 04:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbgBZDBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 22:01:04 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50987 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727880AbgBZDBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 22:01:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582686062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H+NUxlpQe3kCfFqOvCc8dB80unus81dtyuT82SlUBwQ=;
        b=P1BmYNvj8EJo0EFzczyLtvjMX7Wx08lfslIj3x2F6zmPxDNNnCngNvq2nyDPnC3vEC+KMw
        wvAPpZ1ewUDnRD75q5tqhDtNbOlJC0jfSfoHBnBzIJAsZRhTAaZ7XHIDTDESws/CKDDru7
        +RvyLMMidIWAKWhehwDtphEqKGr7GNU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-O4gEyti1MQ-CTj6ci_L3OA-1; Tue, 25 Feb 2020 22:00:58 -0500
X-MC-Unique: O4gEyti1MQ-CTj6ci_L3OA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B118C140F;
        Wed, 26 Feb 2020 03:00:56 +0000 (UTC)
Received: from [10.72.13.217] (ovpn-13-217.pek2.redhat.com [10.72.13.217])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E7665C102;
        Wed, 26 Feb 2020 03:00:42 +0000 (UTC)
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for
 using XDP
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        David Ahern <dahern@digitalocean.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
References: <20200226005744.1623-1-dsahern@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com>
Date:   Wed, 26 Feb 2020 11:00:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200226005744.1623-1-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/2/26 =E4=B8=8A=E5=8D=888:57, David Ahern wrote:
> From: David Ahern <dahern@digitalocean.com>
>
> virtio_net currently requires extra queues to install an XDP program,
> with the rule being twice as many queues as vcpus. From a host
> perspective this means the VM needs to have 2*vcpus vhost threads
> for each guest NIC for which XDP is to be allowed. For example, a
> 16 vcpu VM with 2 tap devices needs 64 vhost threads.
>
> The extra queues are only needed in case an XDP program wants to
> return XDP_TX. XDP_PASS, XDP_DROP and XDP_REDIRECT do not need
> additional queues. Relax the queue requirement and allow XDP
> functionality based on resources. If an XDP program is loaded and
> there are insufficient queues, then return a warning to the user
> and if a program returns XDP_TX just drop the packet. This allows
> the use of the rest of the XDP functionality to work without
> putting an unreasonable burden on the host.
>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: David Ahern <dahern@digitalocean.com>
> ---
>   drivers/net/virtio_net.c | 14 ++++++++++----
>   1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 2fe7a3188282..2f4c5b2e674d 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -190,6 +190,8 @@ struct virtnet_info {
>   	/* # of XDP queue pairs currently used by the driver */
>   	u16 xdp_queue_pairs;
>  =20
> +	bool can_do_xdp_tx;
> +
>   	/* I like... big packets and I cannot lie! */
>   	bool big_packets;
>  =20
> @@ -697,6 +699,8 @@ static struct sk_buff *receive_small(struct net_dev=
ice *dev,
>   			len =3D xdp.data_end - xdp.data;
>   			break;
>   		case XDP_TX:
> +			if (!vi->can_do_xdp_tx)
> +				goto err_xdp;


I wonder if using spinlock to synchronize XDP_TX is better than dropping=20
here?

Thanks


>   			stats->xdp_tx++;
>   			xdpf =3D convert_to_xdp_frame(&xdp);
>   			if (unlikely(!xdpf))
> @@ -870,6 +874,8 @@ static struct sk_buff *receive_mergeable(struct net=
_device *dev,
>   			}
>   			break;
>   		case XDP_TX:
> +			if (!vi->can_do_xdp_tx)
> +				goto err_xdp;
>   			stats->xdp_tx++;
>   			xdpf =3D convert_to_xdp_frame(&xdp);
>   			if (unlikely(!xdpf))
> @@ -2435,10 +2441,10 @@ static int virtnet_xdp_set(struct net_device *d=
ev, struct bpf_prog *prog,
>  =20
>   	/* XDP requires extra queues for XDP_TX */
>   	if (curr_qp + xdp_qp > vi->max_queue_pairs) {
> -		NL_SET_ERR_MSG_MOD(extack, "Too few free TX rings available");
> -		netdev_warn(dev, "request %i queues but max is %i\n",
> -			    curr_qp + xdp_qp, vi->max_queue_pairs);
> -		return -ENOMEM;
> +		NL_SET_ERR_MSG_MOD(extack, "Too few free TX rings available; XDP_TX =
will not be allowed");
> +		vi->can_do_xdp_tx =3D false;
> +	} else {
> +		vi->can_do_xdp_tx =3D true;
>   	}
>  =20
>   	old_prog =3D rtnl_dereference(vi->rq[0].xdp_prog);

