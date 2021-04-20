Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1CCE36509D
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 04:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbhDTC5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 22:57:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42199 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229707AbhDTC5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 22:57:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618887408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EE7LME23WUWVeXeRfQveamynPNr8MvEiH4grzJIaWTk=;
        b=NS4Ag9OZbhZoT2WB17G1ig1Qh5RkKvIWGm39nM37TzpOfYgk4b7gY3aZAgjuXp7lGAlAbu
        TD0OtvfSx/3AGyliyyb1FS7u93ZOurUrfUV/Ah5fJUlOZrAph9zELtjyMerxWdrkQxXH7M
        4YI3nL9E76UHvl4odPQQckUgucfTdlc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-iQ2M1oXpPD2yq6tNf7YBHQ-1; Mon, 19 Apr 2021 22:56:44 -0400
X-MC-Unique: iQ2M1oXpPD2yq6tNf7YBHQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D44683DD21;
        Tue, 20 Apr 2021 02:56:43 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-125.pek2.redhat.com [10.72.13.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA494610F1;
        Tue, 20 Apr 2021 02:56:38 +0000 (UTC)
Subject: Re: [PATCH V4 1/3] vDPA/ifcvf: deduce VIRTIO device ID when probe
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, sgarzare@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210419063326.3748-1-lingshan.zhu@intel.com>
 <20210419063326.3748-2-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <295dc8a9-3159-78bc-f90f-9c8abeedf1cb@redhat.com>
Date:   Tue, 20 Apr 2021 10:56:37 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210419063326.3748-2-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/19 ÏÂÎç2:33, Zhu Lingshan Ð´µÀ:
> This commit deduces VIRTIO device ID as device type when probe,
> then ifcvf_vdpa_get_device_id() can simply return the ID.
> ifcvf_vdpa_get_features() and ifcvf_vdpa_get_config_size()
> can work properly based on the device ID.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vdpa/ifcvf/ifcvf_base.h |  1 +
>   drivers/vdpa/ifcvf/ifcvf_main.c | 27 +++++++++++++++------------
>   2 files changed, 16 insertions(+), 12 deletions(-)
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
> index 44d7586019da..66927ec81fa5 100644
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
> @@ -466,6 +456,19 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
> +	if (pdev->device < 0x1040)
> +		vf->dev_type =  pdev->subsystem_device;
> +	else
> +		vf->dev_type =  pdev->device - 0x1040;
> +
>   	vf->base = pcim_iomap_table(pdev);
>   
>   	adapter->pdev = pdev;

