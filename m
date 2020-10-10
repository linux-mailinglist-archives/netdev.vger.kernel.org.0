Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E55D289DEB
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 05:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730781AbgJJDUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 23:20:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37483 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730300AbgJJDBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 23:01:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602298869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=coiDnr2j0+5r/bVcK9iEriuCq6hzJi0eXfVrwQbFAj4=;
        b=RehQvm7DtKb3YjMSSVsvsMJsvUdwEDDF7vO4WASRWO5N283VJNatcHlrpd2cs+3k1//6w9
        EJWPkZxzOQ/qK+guGHU08+0VaidE364HiWpmhj1zhxU6IHCZGaE+Z9zCEBEZQSdyLdCALc
        Q9bKXoAVYvqaMoQo7H3+eZzkTSlz5As=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-PEzBcXldPL-FrrO4e73PHQ-1; Fri, 09 Oct 2020 23:01:05 -0400
X-MC-Unique: PEzBcXldPL-FrrO4e73PHQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7599805F05;
        Sat, 10 Oct 2020 03:01:03 +0000 (UTC)
Received: from [10.72.13.27] (ovpn-13-27.pek2.redhat.com [10.72.13.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92E425D9FC;
        Sat, 10 Oct 2020 03:00:56 +0000 (UTC)
Subject: Re: [PATCH v3 3/3] vhost: Don't call log_access_ok() when using IOTLB
To:     Greg Kurz <groug@kaod.org>, "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org, Laurent Vivier <laurent@vivier.eu>,
        David Gibson <david@gibson.dropbear.id.au>
References: <160171888144.284610.4628526949393013039.stgit@bahia.lan>
 <160171933385.284610.10189082586063280867.stgit@bahia.lan>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7c512087-639f-0b08-5d8d-6942528d2e06@redhat.com>
Date:   Sat, 10 Oct 2020 11:00:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <160171933385.284610.10189082586063280867.stgit@bahia.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/10/3 下午6:02, Greg Kurz wrote:
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


Acked-by: Jason Wang <jasowang@redhat.com>

In the future, we may consider to deprecate log_guest_addr since in any 
case regardless of IOTLB ennoblement we can get GPA from either IOTLB or 
MEM table.

Thanks


> ---
>   drivers/vhost/vhost.c |   23 ++++++++++++++++++-----
>   1 file changed, 18 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 9d2c225fb518..9ad45e1d27f0 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1370,6 +1370,20 @@ bool vhost_log_access_ok(struct vhost_dev *dev)
>   }
>   EXPORT_SYMBOL_GPL(vhost_log_access_ok);
>   
> +static bool vq_log_used_access_ok(struct vhost_virtqueue *vq,
> +				  void __user *log_base,
> +				  bool log_used,
> +				  u64 log_addr)
> +{
> +	/* If an IOTLB device is present, log_addr is a GIOVA that
> +	 * will never be logged by log_used(). */
> +	if (vq->iotlb)
> +		return true;
> +
> +	return !log_used || log_access_ok(log_base, log_addr,
> +					  vhost_get_used_size(vq, vq->num));
> +}
> +
>   /* Verify access for write logging. */
>   /* Caller should have vq mutex and device mutex */
>   static bool vq_log_access_ok(struct vhost_virtqueue *vq,
> @@ -1377,8 +1391,7 @@ static bool vq_log_access_ok(struct vhost_virtqueue *vq,
>   {
>   	return vq_memory_access_ok(log_base, vq->umem,
>   				   vhost_has_feature(vq, VHOST_F_LOG_ALL)) &&
> -		(!vq->log_used || log_access_ok(log_base, vq->log_addr,
> -				  vhost_get_used_size(vq, vq->num)));
> +		vq_log_used_access_ok(vq, log_base, vq->log_used, vq->log_addr);
>   }
>   
>   /* Can we start vq? */
> @@ -1517,9 +1530,9 @@ static long vhost_vring_set_addr(struct vhost_dev *d,
>   			return -EINVAL;
>   
>   		/* Also validate log access for used ring if enabled. */
> -		if ((a.flags & (0x1 << VHOST_VRING_F_LOG)) &&
> -			!log_access_ok(vq->log_base, a.log_guest_addr,
> -				       vhost_get_used_size(vq, vq->num)))
> +		if (!vq_log_used_access_ok(vq, vq->log_base,
> +				a.flags & (0x1 << VHOST_VRING_F_LOG),
> +				a.log_guest_addr))
>   			return -EINVAL;
>   	}
>   
>
>

