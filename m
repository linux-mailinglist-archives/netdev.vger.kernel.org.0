Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1909360083
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 05:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhDODbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 23:31:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60533 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229981AbhDODbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 23:31:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618457452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HlNNiI/3x3aTaVCgbYG1oVjUjq53goSd1bVD/8PXIMk=;
        b=DPmHjH8ZUaqi82xwbrgmIBAadc6LXmCcim/ey61+mwVGrPwChLW7UeJovF5qRwhhKMkiqf
        f3s/71PAzFNW54vzJ0sKyQfBgSQ8wXm3axSuziEWU/tEb+QPq7ME3JYtGNq+u/gfQtrJip
        qtsKnPkV167k6qev3bY64PMSjrsvjzQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-wQ4K-NJSPnOVQhvEvIBkPQ-1; Wed, 14 Apr 2021 23:30:49 -0400
X-MC-Unique: wQ4K-NJSPnOVQhvEvIBkPQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08E81107ACE4;
        Thu, 15 Apr 2021 03:30:48 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-220.pek2.redhat.com [10.72.13.220])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D418610A8;
        Thu, 15 Apr 2021 03:30:43 +0000 (UTC)
Subject: Re: [PATCH 1/3] vDPA/ifcvf: deduce VIRTIO device ID when probe
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210414091832.5132-1-lingshan.zhu@intel.com>
 <20210414091832.5132-2-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <85483ff1-cf98-ad05-0c53-74caa2464459@redhat.com>
Date:   Thu, 15 Apr 2021 11:30:41 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210414091832.5132-2-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/14 ÏÂÎç5:18, Zhu Lingshan Ð´µÀ:
> This commit deduces VIRTIO device ID as device type when probe,
> then ifcvf_vdpa_get_device_id() can simply return the ID.
> ifcvf_vdpa_get_features() and ifcvf_vdpa_get_config_size()
> can work properly based on the device ID.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vdpa/ifcvf/ifcvf_base.h |  1 +
>   drivers/vdpa/ifcvf/ifcvf_main.c | 22 ++++++++++------------
>   2 files changed, 11 insertions(+), 12 deletions(-)
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
> index 44d7586019da..99b0a6b4c227 100644
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
> @@ -466,6 +456,14 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   	pci_set_drvdata(pdev, adapter);
>   
>   	vf = &adapter->vf;
> +	if (pdev->device < 0x1000 || pdev->device > 0x107f)
> +		return -EOPNOTSUPP;
> +
> +	if (pdev->device < 0x1040)
> +		vf->dev_type =  pdev->subsystem_device;
> +	else
> +		vf->dev_type =  pdev->device - 0x1040;


So a question here, is the device a transtional device or modern one?

If it's a transitonal one, can it swtich endianess automatically or not?

Thanks


> +
>   	vf->base = pcim_iomap_table(pdev);
>   
>   	adapter->pdev = pdev;

