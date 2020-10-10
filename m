Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61619289DA9
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 04:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730265AbgJJCtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 22:49:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29392 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730430AbgJJCc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 22:32:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602297148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z0+yMqB5qWuc0BoeYtvqmNWdzEX4ZInq9BnlDhYqt00=;
        b=iVkUnxlRq4YnQwMXU6gysjZAk1SyGpefN3GTQksDL3/q4iu6OPcyXItSPjPfHxU5JSCf3Z
        xSwgih/lpGVOuoMplTH1DWJTU5vHikybYFxFvoyJDtO2txARXkaQcO19xU9qvDP+D9I8Ea
        7lvyv/4hbvtTVm0U3cMT480DQth34Tk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-55hpNga7MaCPTcKGrULuZw-1; Fri, 09 Oct 2020 22:32:24 -0400
X-MC-Unique: 55hpNga7MaCPTcKGrULuZw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71949879514;
        Sat, 10 Oct 2020 02:32:22 +0000 (UTC)
Received: from [10.72.13.27] (ovpn-13-27.pek2.redhat.com [10.72.13.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D59260BE2;
        Sat, 10 Oct 2020 02:32:15 +0000 (UTC)
Subject: Re: [PATCH v3 2/3] vhost: Use vhost_get_used_size() in
 vhost_vring_set_addr()
To:     Greg Kurz <groug@kaod.org>, "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org, Laurent Vivier <laurent@vivier.eu>,
        David Gibson <david@gibson.dropbear.id.au>
References: <160171888144.284610.4628526949393013039.stgit@bahia.lan>
 <160171932300.284610.11846106312938909461.stgit@bahia.lan>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5fc896c6-e60d-db0b-f7b0-5b6806d70b8e@redhat.com>
Date:   Sat, 10 Oct 2020 10:32:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <160171932300.284610.11846106312938909461.stgit@bahia.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/10/3 下午6:02, Greg Kurz wrote:
> The open-coded computation of the used size doesn't take the event
> into account when the VIRTIO_RING_F_EVENT_IDX feature is present.
> Fix that by using vhost_get_used_size().
>
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>   drivers/vhost/vhost.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index c3b49975dc28..9d2c225fb518 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1519,8 +1519,7 @@ static long vhost_vring_set_addr(struct vhost_dev *d,
>   		/* Also validate log access for used ring if enabled. */
>   		if ((a.flags & (0x1 << VHOST_VRING_F_LOG)) &&
>   			!log_access_ok(vq->log_base, a.log_guest_addr,
> -				sizeof *vq->used +
> -				vq->num * sizeof *vq->used->ring))
> +				       vhost_get_used_size(vq, vq->num)))
>   			return -EINVAL;
>   	}
>   
>
>

Acked-by: Jason Wang <jasowang@redhat.com>


