Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F14F282039
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 03:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725648AbgJCBvq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 21:51:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23113 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725536AbgJCBvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 21:51:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601689904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Okln2Ce1dgJBE2STQ2+G5bbJ8bSdiX6gXYLv/23VM+w=;
        b=RVY87Tvsb7beg0zMgfU8MaRVDN5Medj/3CSnlbeBbCsgA61JTevfJMmfxBbYBsSkpwjQKA
        JSDIaG+ovBXHNkW1boGJq48QvROKCs5LtgsgcJjcz2igwcRJczKhX/7iaT4CJy+yWfdY+d
        4YKvQvGrbhCXQEZr7R06X9HqT/6iSTY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-zBLUNamSNNWStPKaKi7Jtg-1; Fri, 02 Oct 2020 21:51:42 -0400
X-MC-Unique: zBLUNamSNNWStPKaKi7Jtg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56E64803F5C;
        Sat,  3 Oct 2020 01:51:41 +0000 (UTC)
Received: from [10.72.12.21] (ovpn-12-21.pek2.redhat.com [10.72.12.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44D7F5D9D3;
        Sat,  3 Oct 2020 01:51:34 +0000 (UTC)
Subject: Re: [PATCH v2 1/2] vhost: Don't call access_ok() when using IOTLB
To:     Greg Kurz <groug@kaod.org>, "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, qemu-devel@nongnu.org,
        Laurent Vivier <laurent@vivier.eu>,
        David Gibson <david@gibson.dropbear.id.au>
References: <160139701999.162128.2399875915342200263.stgit@bahia.lan>
 <160139703153.162128.16860679176471296230.stgit@bahia.lan>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <21349052-fefc-4437-4233-f803caceeb38@redhat.com>
Date:   Sat, 3 Oct 2020 09:51:33 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <160139703153.162128.16860679176471296230.stgit@bahia.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/9/30 上午12:30, Greg Kurz wrote:
> When the IOTLB device is enabled, the vring addresses we get
> from userspace are GIOVAs. It is thus wrong to pass them down
> to access_ok() which only takes HVAs.
>
> Access validation is done at prefetch time with IOTLB. Teach
> vq_access_ok() about that by moving the (vq->iotlb) check
> from vhost_vq_access_ok() to vq_access_ok(). This prevents
> vhost_vring_set_addr() to fail when verifying the accesses.
> No behavior change for vhost_vq_access_ok().
>
> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1883084
> Fixes: 6b1e6cc7855b ("vhost: new device IOTLB API")
> Cc: jasowang@redhat.com
> CC: stable@vger.kernel.org # 4.14+
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>   drivers/vhost/vhost.c |    9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index b45519ca66a7..c3b49975dc28 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1290,6 +1290,11 @@ static bool vq_access_ok(struct vhost_virtqueue *vq, unsigned int num,
>   			 vring_used_t __user *used)
>   
>   {
> +	/* If an IOTLB device is present, the vring addresses are
> +	 * GIOVAs. Access validation occurs at prefetch time. */
> +	if (vq->iotlb)
> +		return true;
> +
>   	return access_ok(desc, vhost_get_desc_size(vq, num)) &&
>   	       access_ok(avail, vhost_get_avail_size(vq, num)) &&
>   	       access_ok(used, vhost_get_used_size(vq, num));
> @@ -1383,10 +1388,6 @@ bool vhost_vq_access_ok(struct vhost_virtqueue *vq)
>   	if (!vq_log_access_ok(vq, vq->log_base))
>   		return false;
>   
> -	/* Access validation occurs at prefetch time with IOTLB */
> -	if (vq->iotlb)
> -		return true;
> -
>   	return vq_access_ok(vq, vq->num, vq->desc, vq->avail, vq->used);
>   }
>   EXPORT_SYMBOL_GPL(vhost_vq_access_ok);
>

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks


