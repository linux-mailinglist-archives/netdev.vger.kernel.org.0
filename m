Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B00D03639B8
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 05:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237346AbhDSDSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 23:18:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30536 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232714AbhDSDSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 23:18:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618802298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kqu7b/R1y+iNn3LQCUv3CxvSNt0vkP4D2ZFqD/1uXRc=;
        b=RwzJ9sFBWZEFfHyi58T/z0UKcX6NyLHdI9Hhnr/1xny0QaLbxHliSykEyAsAjspxqFAgwI
        X7ull/Y4OaEIkhbDQ+UYqMeJQo8g5+8dDe7hWFtHYTzR30GpJcE2uEyt3E3ElF6LRcqQ5x
        1VXYCi5YwqGMBXVTj5mDN43vq49uIp0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-yl9jzV4EMmCooe1ydXK_hg-1; Sun, 18 Apr 2021 23:17:50 -0400
X-MC-Unique: yl9jzV4EMmCooe1ydXK_hg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 741A5100A605;
        Mon, 19 Apr 2021 03:17:49 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-157.pek2.redhat.com [10.72.12.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 13C0519C66;
        Mon, 19 Apr 2021 03:17:41 +0000 (UTC)
Subject: Re: [PATCH V3 3/3] vDPA/ifcvf: get_config_size should return dev
 specific config size
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, sgarzare@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210416071628.4984-1-lingshan.zhu@intel.com>
 <20210416071628.4984-4-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c1afa91f-b0a1-9ea8-8827-a0920a26f16e@redhat.com>
Date:   Mon, 19 Apr 2021 11:17:40 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210416071628.4984-4-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/16 ÏÂÎç3:16, Zhu Lingshan Ð´µÀ:
> get_config_size() should return the size based on the decected
> device type.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/ifcvf/ifcvf_main.c | 19 ++++++++++++++++++-
>   1 file changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 376b2014916a..3b6f7862dbb8 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -356,7 +356,24 @@ static u32 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
>   
>   static size_t ifcvf_vdpa_get_config_size(struct vdpa_device *vdpa_dev)
>   {
> -	return sizeof(struct virtio_net_config);
> +	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
> +	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
> +	struct pci_dev *pdev = adapter->pdev;
> +	size_t size;
> +
> +	switch (vf->dev_type) {
> +	case VIRTIO_ID_NET:
> +		size = sizeof(struct virtio_net_config);
> +		break;
> +	case VIRTIO_ID_BLOCK:
> +		size = sizeof(struct virtio_blk_config);
> +		break;
> +	default:
> +		size = 0;
> +		IFCVF_ERR(pdev, "VIRTIO ID %u not supported\n", vf->dev_type);
> +	}
> +
> +	return size;
>   }
>   
>   static void ifcvf_vdpa_get_config(struct vdpa_device *vdpa_dev,

