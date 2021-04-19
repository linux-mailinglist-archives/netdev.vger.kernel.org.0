Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70AEA3639A7
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 05:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237337AbhDSDQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 23:16:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35924 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229845AbhDSDQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 23:16:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618802165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X38rk25z+aIlpe2jmK4mElIAnvBj6ZGYmC3xOZNprfM=;
        b=aZDbs70fw4OwEdcX0AwPpYx8kAJs+oNXG0M7VX5zBlV3ligNjWSqadwQU8iLPQNmcbjpej
        xP7jreVhA69rywAgfmz0bz0YkHXZ7IAaEz52sc6Y/tuHZ0zBZeeFQ/nhRUSsllkqi+BDgJ
        MuvL0p1qNNY5Ylf5ykSHDo23W474AA8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-LAHvgotZOaaLtkGjzgkmAA-1; Sun, 18 Apr 2021 23:16:01 -0400
X-MC-Unique: LAHvgotZOaaLtkGjzgkmAA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 263D38030C4;
        Mon, 19 Apr 2021 03:16:00 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-157.pek2.redhat.com [10.72.12.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BE3260936;
        Mon, 19 Apr 2021 03:15:53 +0000 (UTC)
Subject: Re: [PATCH V3 1/3] vDPA/ifcvf: deduce VIRTIO device ID when probe
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, sgarzare@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210416071628.4984-1-lingshan.zhu@intel.com>
 <20210416071628.4984-2-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <efc73829-0209-8144-0426-935b8384b6ad@redhat.com>
Date:   Mon, 19 Apr 2021 11:15:51 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210416071628.4984-2-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/4/16 下午3:16, Zhu Lingshan 写道:
> This commit deduces VIRTIO device ID as device type when probe,
> then ifcvf_vdpa_get_device_id() can simply return the ID.
> ifcvf_vdpa_get_features() and ifcvf_vdpa_get_config_size()
> can work properly based on the device ID.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vdpa/ifcvf/ifcvf_base.h |  1 +
>   drivers/vdpa/ifcvf/ifcvf_main.c | 30 ++++++++++++++++++------------
>   2 files changed, 19 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index b2eeb16b9c2c..1c04cd256fa7 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -84,6 +84,7 @@ struct ifcvf_hw {
>   	u32 notify_off_multiplier;
>   	u64 req_features;
>   	u64 hw_features;
> +	u32 dev_type;
>   	struct virtio_pci_common_cfg __iomem *common_cfg;
>   	void __iomem *net_cfg;
>   	struct vring_info vring[IFCVF_MAX_QUEUE_PAIRS * 2];
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 44d7586019da..469a9b5737b7 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -323,19 +323,9 @@ static u32 ifcvf_vdpa_get_generation(struct vdpa_device *vdpa_dev)
>   
>   static u32 ifcvf_vdpa_get_device_id(struct vdpa_device *vdpa_dev)
>   {
> -	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
> -	struct pci_dev *pdev = adapter->pdev;
> -	u32 ret = -ENODEV;
> -
> -	if (pdev->device < 0x1000 || pdev->device > 0x107f)
> -		return ret;
> -
> -	if (pdev->device < 0x1040)
> -		ret =  pdev->subsystem_device;
> -	else
> -		ret =  pdev->device - 0x1040;
> +	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>   
> -	return ret;
> +	return vf->dev_type;
>   }
>   
>   static u32 ifcvf_vdpa_get_vendor_id(struct vdpa_device *vdpa_dev)
> @@ -466,6 +456,22 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   	pci_set_drvdata(pdev, adapter);
>   
>   	vf = &adapter->vf;
> +
> +	/* This drirver drives both modern virtio devices and transitional
> +	 * devices in modern mode.
> +	 * vDPA requires feature bit VIRTIO_F_ACCESS_PLATFORM,
> +	 * so legacy devices and transitional devices in legacy
> +	 * mode will not work for vDPA, this driver will not
> +	 * drive devices with legacy interface.
> +	 */
> +	if (pdev->device < 0x1000 || pdev->device > 0x107f)
> +		return -EOPNOTSUPP;


So this seems useless, id_table has already did that for us:

The driver supports:

#define IFCVF_DEVICE_ID         0x1041

and

#define C5000X_PL_BLK_DEVICE_ID        0x1001

I think we can never reach the condition above.

Thanks


> +
> +	if (pdev->device < 0x1040)
> +		vf->dev_type =  pdev->subsystem_device;
> +	else
> +		vf->dev_type =  pdev->device - 0x1040;
> +
>   	vf->base = pcim_iomap_table(pdev);
>   
>   	adapter->pdev = pdev;

