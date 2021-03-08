Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1735033062A
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 03:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbhCHCxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 21:53:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38717 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233890AbhCHCxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 21:53:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615172015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VWTExvkpL3xvnU71XBjAtEuJZDgLR8SWFyWHBwfA6EQ=;
        b=VkkWw5YKE0uMMMWKMBP5iclf7yKHesVLyE4uD+9J9OR1usNzKUgoZysMDeV4VVDvArx1wb
        U3lBvLoxyRLVnd6EE+1rBgR+ck+BkZQczPCo0/0/B5wqbFDS9biG5Zrti1AlMPCZUA7aYH
        /o5RRsSFQv5/9fzhjiT7y2E3KVCDX5c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-lX5C2eSqOmOk0EQ0k1P4LQ-1; Sun, 07 Mar 2021 21:53:33 -0500
X-MC-Unique: lX5C2eSqOmOk0EQ0k1P4LQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56770100CF64;
        Mon,  8 Mar 2021 02:53:32 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A45766F988;
        Mon,  8 Mar 2021 02:53:26 +0000 (UTC)
Subject: Re: [PATCH 2/3] vDPA/ifcvf: enable Intel C5000X-PL virtio-net for
 vDPA
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210305142000.18521-1-lingshan.zhu@intel.com>
 <20210305142000.18521-3-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e36ac9d6-2fd9-44fe-3477-ef6ddf22429a@redhat.com>
Date:   Mon, 8 Mar 2021 10:53:25 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210305142000.18521-3-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/5 10:19 下午, Zhu Lingshan wrote:
> This commit enabled Intel FPGA SmartNIC C5000X-PL virtio-net
> for vDPA.
> C5000X-PL vendor id 0x1AF4, device id 0x1000,
> subvendor id 0x8086, sub device id 0x0001
>
> To distinguish C5000X-PL from other ifcvf driven devices,
> the original ifcvf device is named "N3000".
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vdpa/ifcvf/ifcvf_base.h | 13 +++++++++----
>   drivers/vdpa/ifcvf/ifcvf_main.c | 13 +++++++++----
>   2 files changed, 18 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index 64696d63fe07..794d1505d857 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -18,10 +18,15 @@
>   #include <uapi/linux/virtio_config.h>
>   #include <uapi/linux/virtio_pci.h>
>   
> -#define IFCVF_VENDOR_ID		0x1AF4
> -#define IFCVF_DEVICE_ID		0x1041
> -#define IFCVF_SUBSYS_VENDOR_ID	0x8086
> -#define IFCVF_SUBSYS_DEVICE_ID	0x001A
> +#define N3000_VENDOR_ID		0x1AF4
> +#define N3000_DEVICE_ID		0x1041
> +#define N3000_SUBSYS_VENDOR_ID	0x8086
> +#define N3000_SUBSYS_DEVICE_ID	0x001A


Patch looks good, I wonder if it's better to do the rename separately.

Thanks


> +
> +#define C5000X_PL_VENDOR_ID		0x1AF4
> +#define C5000X_PL_DEVICE_ID		0x1000
> +#define C5000X_PL_SUBSYS_VENDOR_ID	0x8086
> +#define C5000X_PL_SUBSYS_DEVICE_ID	0x0001
>   
>   #define IFCVF_SUPPORTED_FEATURES \
>   		((1ULL << VIRTIO_NET_F_MAC)			| \
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index e501ee07de17..fd5befc5cbcc 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -480,10 +480,15 @@ static void ifcvf_remove(struct pci_dev *pdev)
>   }
>   
>   static struct pci_device_id ifcvf_pci_ids[] = {
> -	{ PCI_DEVICE_SUB(IFCVF_VENDOR_ID,
> -		IFCVF_DEVICE_ID,
> -		IFCVF_SUBSYS_VENDOR_ID,
> -		IFCVF_SUBSYS_DEVICE_ID) },
> +	{ PCI_DEVICE_SUB(N3000_VENDOR_ID,
> +			 N3000_DEVICE_ID,
> +			 N3000_SUBSYS_VENDOR_ID,
> +			 N3000_SUBSYS_DEVICE_ID) },
> +	{ PCI_DEVICE_SUB(C5000X_PL_VENDOR_ID,
> +			 C5000X_PL_DEVICE_ID,
> +			 C5000X_PL_SUBSYS_VENDOR_ID,
> +			 C5000X_PL_SUBSYS_DEVICE_ID) },
> +
>   	{ 0 },
>   };
>   MODULE_DEVICE_TABLE(pci, ifcvf_pci_ids);

