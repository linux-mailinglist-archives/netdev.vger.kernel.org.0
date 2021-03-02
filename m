Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C4632A35B
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382117AbhCBI4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:56:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24331 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1836206AbhCBGtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 01:49:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614667663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A33+VwIK3bf5osqIxTxxyG3hL3urzpweVkSG9X2C69k=;
        b=K3xxC4gPqYUvIEK8KykGCggaO1EPOwYW54s6sdRxPAUoBj05KJ1qjCe4IRdrtW14t22RYa
        /KP6PVLSRXCyMaUiqomxO25WZ8SH+/R9A/EbBpz0/6gXUNxZDX8SqdO4KPKpVjfH02zHK8
        B9hA0lTkvdTV4UjINoWupqZDSNmFl9o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578-GwLs2Ht7Ns6Ngsa4ODZhAQ-1; Tue, 02 Mar 2021 01:47:39 -0500
X-MC-Unique: GwLs2Ht7Ns6Ngsa4ODZhAQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF9E11005501;
        Tue,  2 Mar 2021 06:47:37 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-133.pek2.redhat.com [10.72.12.133])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 999FC5D766;
        Tue,  2 Mar 2021 06:47:23 +0000 (UTC)
Subject: Re: [RFC v4 02/11] vhost-vdpa: protect concurrent access to vhost
 device iotlb
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        bob.liu@oracle.com, hch@infradead.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210223115048.435-1-xieyongji@bytedance.com>
 <20210223115048.435-3-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a170e0ec-f0cf-e23f-0ca7-e8a5bfd1cf31@redhat.com>
Date:   Tue, 2 Mar 2021 14:47:21 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210223115048.435-3-xieyongji@bytedance.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/23 7:50 下午, Xie Yongji wrote:
> Use vhost_dev->mutex to protect vhost device iotlb from
> concurrent access.
>
> Fixes: 4c8cf318("vhost: introduce vDPA-based backend")
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> ---
>   drivers/vhost/vdpa.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index c50079dfb281..5500e3bf05c1 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -723,6 +723,7 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
>   	if (r)
>   		return r;
>   
> +	mutex_lock(&dev->mutex);


I think this should be done before the vhost_dev_check_owner() above.

Thanks


>   	switch (msg->type) {
>   	case VHOST_IOTLB_UPDATE:
>   		r = vhost_vdpa_process_iotlb_update(v, msg);
> @@ -742,6 +743,7 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
>   		r = -EINVAL;
>   		break;
>   	}
> +	mutex_unlock(&dev->mutex);
>   
>   	return r;
>   }

