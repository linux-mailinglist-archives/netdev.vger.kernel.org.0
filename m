Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B763723CE2D
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 20:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgHESTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 14:19:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22260 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729077AbgHESSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 14:18:25 -0400
X-Greylist: delayed 3613 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Aug 2020 14:18:24 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596651499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u6BgoSObisAMVxaJpQKxat6BIIq50UZiECX71HIFPB8=;
        b=NjoiJtuvvtcmbV3maRQ9BJsNgWQFuLt9ACQuaJ2FwZTrrfkHjMk/ZZDEvQDrNVhgAvBY22
        CU1HbtnLl3up0ejlz6Xst4Lr3I7V2h4w4K3+53Hh/bOiI6VtkdTzK2+HlBCr9xJRneJcGO
        pyKgKnPm8Na+D7qS76ure5MDbjTc6E4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-EMfVmt2BMeOPnRR1pJUjkQ-1; Wed, 05 Aug 2020 09:59:56 -0400
X-MC-Unique: EMfVmt2BMeOPnRR1pJUjkQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D27D80183C;
        Wed,  5 Aug 2020 13:59:55 +0000 (UTC)
Received: from gondolin (ovpn-113-4.ams2.redhat.com [10.36.113.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 943062B6D9;
        Wed,  5 Aug 2020 13:59:50 +0000 (UTC)
Date:   Wed, 5 Aug 2020 15:59:48 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 38/38] virtio_net: use LE accessors for speed/duplex
Message-ID: <20200805155948.4869b0cc.cohuck@redhat.com>
In-Reply-To: <20200805134226.1106164-39-mst@redhat.com>
References: <20200805134226.1106164-1-mst@redhat.com>
        <20200805134226.1106164-39-mst@redhat.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Aug 2020 09:45:00 -0400
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Speed and duplex config fields depend on VIRTIO_NET_F_SPEED_DUPLEX
> which being 63>31 depends on VIRTIO_F_VERSION_1.
> 
> Accordingly, use LE accessors for these fields.
> 
> Reported-by: Cornelia Huck <cohuck@redhat.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/net/virtio_net.c        | 9 +++++----
>  include/uapi/linux/virtio_net.h | 2 +-
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index ba38765dc490..0934b1ec5320 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2264,12 +2264,13 @@ static void virtnet_update_settings(struct virtnet_info *vi)
>  	if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_SPEED_DUPLEX))
>  		return;
>  
> -	speed = virtio_cread32(vi->vdev, offsetof(struct virtio_net_config,
> -						  speed));
> +	virtio_cread_le(vi->vdev, struct virtio_net_config, speed, &speed);
> +
>  	if (ethtool_validate_speed(speed))
>  		vi->speed = speed;
> -	duplex = virtio_cread8(vi->vdev, offsetof(struct virtio_net_config,
> -						  duplex));
> +
> +	virtio_cread_le(vi->vdev, struct virtio_net_config, duplex, &duplex);

Looks a bit odd for an u8, but does not really hurt.

> +
>  	if (ethtool_validate_duplex(duplex))
>  		vi->duplex = duplex;
>  }
> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> index 27d996f29dd1..3f55a4215f11 100644
> --- a/include/uapi/linux/virtio_net.h
> +++ b/include/uapi/linux/virtio_net.h
> @@ -99,7 +99,7 @@ struct virtio_net_config {
>  	 * speed, in units of 1Mb. All values 0 to INT_MAX are legal.
>  	 * Any other value stands for unknown.
>  	 */
> -	__virtio32 speed;
> +	__le32 speed;
>  	/*
>  	 * 0x00 - half duplex
>  	 * 0x01 - full duplex

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

