Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2301F33FD5D
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 03:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhCRCpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 22:45:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36624 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230519AbhCRCou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 22:44:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616035490;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RYfa5a2DxRoWjWb7ZGXHEAtX1EgdbLByNOKHYZ6ZtLI=;
        b=U6uydGmacGdtudDrLJ9AV/7dlA9Y02Nh5gtYu3GkPqTv+Um55bepNxr2gnmRRmILmv53DA
        Men/WdBR3eXoat00ikmpIG5JK//Fx+xwyPRnSQcxvVkLB6cY8QjyqnTD0adbuWUmv+v5Ep
        UG3CD+bWERNzaWRUoSOX5bvDR7W5o/4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-573-lMa46TAUM-qfCQ9m7ytemQ-1; Wed, 17 Mar 2021 22:44:46 -0400
X-MC-Unique: lMa46TAUM-qfCQ9m7ytemQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6DA581744F;
        Thu, 18 Mar 2021 02:44:44 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-131.pek2.redhat.com [10.72.13.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C163E503EE;
        Thu, 18 Mar 2021 02:44:38 +0000 (UTC)
Subject: Re: [PATCH V5 7/7] vDPA/ifcvf: deduce VIRTIO device ID from pdev ids
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210317094933.16417-1-lingshan.zhu@intel.com>
 <20210317094933.16417-8-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <1ba4d913-b237-8faf-fec8-b844448c26f0@redhat.com>
Date:   Thu, 18 Mar 2021 10:44:37 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210317094933.16417-8-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/3/17 ÏÂÎç5:49, Zhu Lingshan Ð´µÀ:
> This commit deduces the VIRTIO device ID of a probed
> device from its pdev device ids.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vdpa/ifcvf/ifcvf_base.h |  1 +
>   drivers/vdpa/ifcvf/ifcvf_main.c | 14 +++++++++++++-
>   2 files changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index f77239fc1644..b2eeb16b9c2c 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -127,4 +127,5 @@ int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features);
>   u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid);
>   int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num);
>   struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
> +int ifcvf_probed_virtio_net(struct ifcvf_hw *hw);
>   #endif /* _IFCVF_H_ */
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index ea93ea7fd5df..9fade400b5a4 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -323,7 +323,19 @@ static u32 ifcvf_vdpa_get_generation(struct vdpa_device *vdpa_dev)
>   
>   static u32 ifcvf_vdpa_get_device_id(struct vdpa_device *vdpa_dev)
>   {
> -	return VIRTIO_ID_NET;
> +	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
> +	struct pci_dev *pdev = adapter->pdev;
> +	u32 ret = -ENODEV;
> +
> +	if (pdev->device < 0x1000 || pdev->device > 0x107f)
> +		return ret;
> +
> +	if (pdev->device < 0x1040)
> +		ret =  pdev->subsystem_device;
> +	else
> +		ret =  pdev->device - 0x1040;
> +
> +	return ret;
>   }


It would be better to keep the comment.

But anyway

Acked-by: Jason Wang <jasowang@redhat.com>



>   
>   static u32 ifcvf_vdpa_get_vendor_id(struct vdpa_device *vdpa_dev)

