Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF013455E5
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 04:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhCWDCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 23:02:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56471 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229673AbhCWDCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 23:02:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616468553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qqPb4TLeg/4W4bHsX4Gzo6cnsaw2oDqjTlzBaVJEzig=;
        b=Zn+dkoWP1W35XrKxz+BK1BLRWHgWNEpswF3xgKafsPFR0zgW5CQyg0fkUVv7pJPGSYbbUA
        dqEIpr1HXmx7yc7/FsxO2uIILgiWW9xnyvi1gG9Z96pWO8F9MHExM3VgwcTVYfwIljyv7C
        mbJHaDUXuuYOZIiIAotYQ1WaRNZ93zI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-428-Bm8Un-RYP9C2dwbPJU6f5g-1; Mon, 22 Mar 2021 23:02:29 -0400
X-MC-Unique: Bm8Un-RYP9C2dwbPJU6f5g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B014881276;
        Tue, 23 Mar 2021 03:02:27 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-238.pek2.redhat.com [10.72.12.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 187771F05A;
        Tue, 23 Mar 2021 03:02:10 +0000 (UTC)
Subject: Re: [PATCH v5 03/11] vhost-vdpa: protect concurrent access to vhost
 device iotlb
To:     Xie Yongji <xieyongji@bytedance.com>, mst@redhat.com,
        stefanha@redhat.com, sgarzare@redhat.com, parav@nvidia.com,
        bob.liu@oracle.com, hch@infradead.org, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20210315053721.189-1-xieyongji@bytedance.com>
 <20210315053721.189-4-xieyongji@bytedance.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <38a2ae38-ebf7-3e3b-3439-d95a6f49b48b@redhat.com>
Date:   Tue, 23 Mar 2021 11:02:09 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315053721.189-4-xieyongji@bytedance.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/3/15 ÏÂÎç1:37, Xie Yongji Ð´µÀ:
> Use vhost_dev->mutex to protect vhost device iotlb from
> concurrent access.
>
> Fixes: 4c8cf318("vhost: introduce vDPA-based backend")
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>


Acked-by: Jason Wang <jasowang@redhat.com>

Please cc stable for next version.

Thanks


> ---
>   drivers/vhost/vdpa.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index cb14c66eb2ec..3f7175c2ac24 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -719,9 +719,11 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
>   	const struct vdpa_config_ops *ops = vdpa->config;
>   	int r = 0;
>   
> +	mutex_lock(&dev->mutex);
> +
>   	r = vhost_dev_check_owner(dev);
>   	if (r)
> -		return r;
> +		goto unlock;
>   
>   	switch (msg->type) {
>   	case VHOST_IOTLB_UPDATE:
> @@ -742,6 +744,8 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
>   		r = -EINVAL;
>   		break;
>   	}
> +unlock:
> +	mutex_unlock(&dev->mutex);
>   
>   	return r;
>   }

