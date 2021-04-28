Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F0336D411
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 10:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237208AbhD1Ikq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 04:40:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46606 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229643AbhD1Ikp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 04:40:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619599200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A4Dnz/Lf18H3ZKwSnBLQNLUl5d7cF3q99QAsHoXknb0=;
        b=Nfv3QIRNL0x4SNcRR/fBNGdTQuU4/tmuFlJBdU+QKirCzSXse8k/ZrnVq8xGUxnuqS6Uee
        e29WkbUE90ydDYbRu9JeWlSO8FaKpjcHkVZm/eS1G9cUhoW3VrPovff0RJRCfq4PMe2MyC
        /ycp6AEQRMCmBvzgrN2iAxTZHQ6jgOY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-443-uwjuNaFVNZq6ZBOFYppThQ-1; Wed, 28 Apr 2021 04:39:57 -0400
X-MC-Unique: uwjuNaFVNZq6ZBOFYppThQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 42C241008062;
        Wed, 28 Apr 2021 08:39:56 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-52.pek2.redhat.com [10.72.13.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64BC560CC6;
        Wed, 28 Apr 2021 08:39:49 +0000 (UTC)
Subject: Re: [PATCH 1/2] vDPA/ifcvf: record virtio notify base
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210428082133.6766-1-lingshan.zhu@intel.com>
 <20210428082133.6766-2-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <55217869-b456-f3bc-0b5a-6beaf34c19f8@redhat.com>
Date:   Wed, 28 Apr 2021 16:39:47 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210428082133.6766-2-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/4/28 ÏÂÎç4:21, Zhu Lingshan Ð´µÀ:
> This commit records virtio notify base addr to implemente
> doorbell mapping feature
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vdpa/ifcvf/ifcvf_base.c | 1 +
>   drivers/vdpa/ifcvf/ifcvf_base.h | 1 +
>   2 files changed, 2 insertions(+)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
> index 1a661ab45af5..cc61a5bfc5b1 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
> @@ -133,6 +133,7 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
>   					      &hw->notify_off_multiplier);
>   			hw->notify_bar = cap.bar;
>   			hw->notify_base = get_cap_addr(hw, &cap);
> +			hw->notify_pa = pci_resource_start(pdev, cap.bar) + cap.offset;


To be more generic and avoid future changes, let's use the math defined 
in the virtio spec.

You may refer how it is implemented in virtio_pci vdpa driver[1].

Thanks

[1] 
https://lore.kernel.org/virtualization/20210415073147.19331-5-jasowang@redhat.com/T/


>   			IFCVF_DBG(pdev, "hw->notify_base = %p\n",
>   				  hw->notify_base);
>   			break;
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index 0111bfdeb342..bcca7c1669dd 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -98,6 +98,7 @@ struct ifcvf_hw {
>   	char config_msix_name[256];
>   	struct vdpa_callback config_cb;
>   	unsigned int config_irq;
> +	phys_addr_t  notify_pa;
>   };
>   
>   struct ifcvf_adapter {

