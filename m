Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD9836008F
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 05:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhDODhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 23:37:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26000 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229619AbhDODhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 23:37:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618457798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=czJHMaI3E97Ji0Ap43HwtLZnd4lX6ZvCcTZR3x3oep8=;
        b=dFTGNs7w+171BiO7uPN+OgWhdWjFnMrHa1psX1DmzusM6GI4ang7AbLbZJHaavWWj1yay9
        q9okA5CQSOS/LUIOLKvZzoT7mmCdLR3pbr2k8t5TJfTKSQ/Byjyfhnkl87AxjR+OPJjKA5
        1Q8sh5mWeVN9u45oX4jjYWXvEo4rMS8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-xKvgv2EXP12NRNw8PZi2Hg-1; Wed, 14 Apr 2021 23:36:37 -0400
X-MC-Unique: xKvgv2EXP12NRNw8PZi2Hg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9FD38189C8;
        Thu, 15 Apr 2021 03:36:35 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-220.pek2.redhat.com [10.72.13.220])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3CDC5D9DC;
        Thu, 15 Apr 2021 03:36:29 +0000 (UTC)
Subject: Re: [PATCH 3/3] vDPA/ifcvf: get_config_size should return dev
 specific config size
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210414091832.5132-1-lingshan.zhu@intel.com>
 <20210414091832.5132-4-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <cc72edee-cbc1-89e6-f901-3f044f738693@redhat.com>
Date:   Thu, 15 Apr 2021 11:36:28 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210414091832.5132-4-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/14 ÏÂÎç5:18, Zhu Lingshan Ð´µÀ:
> get_config_size() should return the size based on the decected
> device type.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/ifcvf/ifcvf_main.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 9b6a38b798fa..b48b9789b69e 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -347,7 +347,16 @@ static u32 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
>   
>   static size_t ifcvf_vdpa_get_config_size(struct vdpa_device *vdpa_dev)
>   {
> -	return sizeof(struct virtio_net_config);
> +	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
> +	size_t size;
> +
> +	if (vf->dev_type == VIRTIO_ID_NET)
> +		size = sizeof(struct virtio_net_config);
> +
> +	if (vf->dev_type == VIRTIO_ID_BLOCK)
> +		size = sizeof(struct virtio_blk_config);
> +
> +	return size;
>   }
>   
>   static void ifcvf_vdpa_get_config(struct vdpa_device *vdpa_dev,

