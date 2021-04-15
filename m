Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 539BF360086
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 05:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhDODfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 23:35:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57194 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229475AbhDODfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 23:35:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618457688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5RUei5yo3a+NRHkJr+JjC5QOk4NX0VQ98MyFYxpFYQQ=;
        b=fn0ATztC8nSWmLEPOSlV7p3FVovFrYL6Y1RDb1w3Dq3f+MLCTBQNWmQiEUnjC2NVPICJqP
        GL35qUnlL5gRZ3j92QQW0K3zcA+Yn7g6pjEXvNrRkOU6rgRDKLdceeIkHuVBNe1mmHOirr
        Ep07AtHj/RBbgZgBQQDGl2Hpwj9rXXY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-yheEFGkTNwWNrW0mXdH1EA-1; Wed, 14 Apr 2021 23:34:45 -0400
X-MC-Unique: yheEFGkTNwWNrW0mXdH1EA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9135A189C448;
        Thu, 15 Apr 2021 03:34:43 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-220.pek2.redhat.com [10.72.13.220])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AE57A5D71F;
        Thu, 15 Apr 2021 03:34:36 +0000 (UTC)
Subject: Re: [PATCH 2/3] vDPA/ifcvf: enable Intel C5000X-PL virtio-block for
 vDPA
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210414091832.5132-1-lingshan.zhu@intel.com>
 <20210414091832.5132-3-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <54839b05-78d2-8edf-317c-372f0ecda024@redhat.com>
Date:   Thu, 15 Apr 2021 11:34:34 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210414091832.5132-3-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/14 ÏÂÎç5:18, Zhu Lingshan Ð´µÀ:
> This commit enabled Intel FPGA SmartNIC C5000X-PL virtio-block
> for vDPA.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vdpa/ifcvf/ifcvf_base.h | 17 ++++++++++++++++-
>   drivers/vdpa/ifcvf/ifcvf_main.c | 10 +++++++++-
>   2 files changed, 25 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index 1c04cd256fa7..8b403522bf06 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -15,6 +15,7 @@
>   #include <linux/pci_regs.h>
>   #include <linux/vdpa.h>
>   #include <uapi/linux/virtio_net.h>
> +#include <uapi/linux/virtio_blk.h>
>   #include <uapi/linux/virtio_config.h>
>   #include <uapi/linux/virtio_pci.h>
>   
> @@ -28,7 +29,12 @@
>   #define C5000X_PL_SUBSYS_VENDOR_ID	0x8086
>   #define C5000X_PL_SUBSYS_DEVICE_ID	0x0001
>   
> -#define IFCVF_SUPPORTED_FEATURES \
> +#define C5000X_PL_BLK_VENDOR_ID		0x1AF4
> +#define C5000X_PL_BLK_DEVICE_ID		0x1001
> +#define C5000X_PL_BLK_SUBSYS_VENDOR_ID	0x8086
> +#define C5000X_PL_BLK_SUBSYS_DEVICE_ID	0x0002
> +
> +#define IFCVF_NET_SUPPORTED_FEATURES \
>   		((1ULL << VIRTIO_NET_F_MAC)			| \
>   		 (1ULL << VIRTIO_F_ANY_LAYOUT)			| \
>   		 (1ULL << VIRTIO_F_VERSION_1)			| \
> @@ -37,6 +43,15 @@
>   		 (1ULL << VIRTIO_F_ACCESS_PLATFORM)		| \
>   		 (1ULL << VIRTIO_NET_F_MRG_RXBUF))
>   
> +#define IFCVF_BLK_SUPPORTED_FEATURES \
> +		((1ULL << VIRTIO_BLK_F_SIZE_MAX)		| \
> +		 (1ULL << VIRTIO_BLK_F_SEG_MAX)			| \
> +		 (1ULL << VIRTIO_BLK_F_BLK_SIZE)		| \
> +		 (1ULL << VIRTIO_BLK_F_TOPOLOGY)		| \
> +		 (1ULL << VIRTIO_BLK_F_MQ)			| \
> +		 (1ULL << VIRTIO_F_VERSION_1)			| \
> +		 (1ULL << VIRTIO_F_ACCESS_PLATFORM))


I think we've discussed this sometime in the past but what's the reason 
for such whitelist consider there's already a get_features() implemention?

E.g Any reason to block VIRTIO_BLK_F_WRITE_ZEROS or VIRTIO_F_RING_PACKED?

Thanks


> +
>   /* Only one queue pair for now. */
>   #define IFCVF_MAX_QUEUE_PAIRS	1
>   
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 99b0a6b4c227..9b6a38b798fa 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -171,7 +171,11 @@ static u64 ifcvf_vdpa_get_features(struct vdpa_device *vdpa_dev)
>   	struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>   	u64 features;
>   
> -	features = ifcvf_get_features(vf) & IFCVF_SUPPORTED_FEATURES;
> +	if (vf->dev_type == VIRTIO_ID_NET)
> +		features = ifcvf_get_features(vf) & IFCVF_NET_SUPPORTED_FEATURES;
> +
> +	if (vf->dev_type == VIRTIO_ID_BLOCK)
> +		features = ifcvf_get_features(vf) & IFCVF_BLK_SUPPORTED_FEATURES;
>   
>   	return features;
>   }
> @@ -509,6 +513,10 @@ static struct pci_device_id ifcvf_pci_ids[] = {
>   			 C5000X_PL_DEVICE_ID,
>   			 C5000X_PL_SUBSYS_VENDOR_ID,
>   			 C5000X_PL_SUBSYS_DEVICE_ID) },
> +	{ PCI_DEVICE_SUB(C5000X_PL_BLK_VENDOR_ID,
> +			 C5000X_PL_BLK_DEVICE_ID,
> +			 C5000X_PL_BLK_SUBSYS_VENDOR_ID,
> +			 C5000X_PL_BLK_SUBSYS_DEVICE_ID) },
>   
>   	{ 0 },
>   };

