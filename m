Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6BC0282041
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 03:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725764AbgJCB7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 21:59:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39631 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725536AbgJCB7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 21:59:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601690352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YeOAtvvMPwaNHz/wYRORgCGMK3Ts1ggRda1sMGxGQFA=;
        b=V8kRsPg73mY1aqPTpDBNpne+w39tFhduFJHfFgXNot4K0HeIbJMSkXzY9C7HASfBjATxky
        kd2zArMfpU0lxSwHWQHum36FgTWSW5HwA2O43dXoG63Qf5gpBiRTPiYui9WdztAHnK5lm2
        k3XKZ/sQ/JOVM6DqXUZHOu88pPmbGvc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-1nU4H7_uOzuVqsTeKAiepQ-1; Fri, 02 Oct 2020 21:59:08 -0400
X-MC-Unique: 1nU4H7_uOzuVqsTeKAiepQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B5F4E107464A;
        Sat,  3 Oct 2020 01:59:06 +0000 (UTC)
Received: from [10.72.12.21] (ovpn-12-21.pek2.redhat.com [10.72.12.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3FDA5577C;
        Sat,  3 Oct 2020 01:59:00 +0000 (UTC)
Subject: Re: [PATCH v2 2/2] vhost: Don't call log_access_ok() when using IOTLB
To:     Greg Kurz <groug@kaod.org>, "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, qemu-devel@nongnu.org,
        Laurent Vivier <laurent@vivier.eu>,
        David Gibson <david@gibson.dropbear.id.au>
References: <160139701999.162128.2399875915342200263.stgit@bahia.lan>
 <160139704424.162128.7839027287942194310.stgit@bahia.lan>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d9dae1ed-49a4-909a-6840-ae46a4ffdffc@redhat.com>
Date:   Sat, 3 Oct 2020 09:58:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <160139704424.162128.7839027287942194310.stgit@bahia.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/9/30 上午12:30, Greg Kurz wrote:
> When the IOTLB device is enabled, the log_guest_addr that is passed by
> userspace to the VHOST_SET_VRING_ADDR ioctl, and which is then written
> to vq->log_addr, is a GIOVA. All writes to this address are translated
> by log_user() to writes to an HVA, and then ultimately logged through
> the corresponding GPAs in log_write_hva(). No logging will ever occur
> with vq->log_addr in this case. It is thus wrong to pass vq->log_addr
> and log_guest_addr to log_access_vq() which assumes they are actual
> GPAs.
>
> Introduce a new vq_log_used_access_ok() helper that only checks accesses
> to the log for the used structure when there isn't an IOTLB device around.
>
> Signed-off-by: Greg Kurz <groug@kaod.org>
> ---
>   drivers/vhost/vhost.c |   23 +++++++++++++++++++----
>   1 file changed, 19 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index c3b49975dc28..5996e32fa818 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1370,6 +1370,20 @@ bool vhost_log_access_ok(struct vhost_dev *dev)
>   }
>   EXPORT_SYMBOL_GPL(vhost_log_access_ok);
>   
> +static bool vq_log_used_access_ok(struct vhost_virtqueue *vq,
> +				  void __user *log_base,
> +				  bool log_used,
> +				  u64 log_addr,
> +				  size_t log_size)
> +{
> +	/* If an IOTLB device is present, log_addr is a GIOVA that
> +	 * will never be logged by log_used(). */
> +	if (vq->iotlb)
> +		return true;
> +
> +	return !log_used || log_access_ok(log_base, log_addr, log_size);
> +}
> +
>   /* Verify access for write logging. */
>   /* Caller should have vq mutex and device mutex */
>   static bool vq_log_access_ok(struct vhost_virtqueue *vq,
> @@ -1377,8 +1391,8 @@ static bool vq_log_access_ok(struct vhost_virtqueue *vq,
>   {
>   	return vq_memory_access_ok(log_base, vq->umem,
>   				   vhost_has_feature(vq, VHOST_F_LOG_ALL)) &&
> -		(!vq->log_used || log_access_ok(log_base, vq->log_addr,
> -				  vhost_get_used_size(vq, vq->num)));
> +		vq_log_used_access_ok(vq, log_base, vq->log_used, vq->log_addr,
> +				      vhost_get_used_size(vq, vq->num));
>   }
>   
>   /* Can we start vq? */
> @@ -1517,8 +1531,9 @@ static long vhost_vring_set_addr(struct vhost_dev *d,
>   			return -EINVAL;
>   
>   		/* Also validate log access for used ring if enabled. */
> -		if ((a.flags & (0x1 << VHOST_VRING_F_LOG)) &&
> -			!log_access_ok(vq->log_base, a.log_guest_addr,
> +		if (!vq_log_used_access_ok(vq, vq->log_base,
> +				a.flags & (0x1 << VHOST_VRING_F_LOG),
> +				a.log_guest_addr,
>   				sizeof *vq->used +
>   				vq->num * sizeof *vq->used->ring))


It looks to me that we should use vhost_get_used_size() which takes 
event into account.

Any reason that we can't reuse vq_log_access_ok() here?

Thanks


>   			return -EINVAL;
>
>

