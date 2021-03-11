Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7D9E336A9F
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 04:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbhCKDXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 22:23:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54735 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230450AbhCKDXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 22:23:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615432993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ub6/EcBH4E/sCu55924OCkZmHzGxaR27DdB+w8cXwRQ=;
        b=TSYKOPjz3UC9/rUHfsruus39QHqJcov7wqcwJm6Jchu+WXaXW3SpAy46wuAYmFJsRVDFTX
        fKF4GIjhAjKhEtcLOAs1vpJHwSCb0WsiZwZOpVP4GkReNbLw3Of58zP1rByOHw+Ut1+YKf
        V46hliZ+4H48nbL8Hs3Klq4IvFs+G6Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-497-yd4R6GCRP2SgM5WkG-ef4g-1; Wed, 10 Mar 2021 22:23:10 -0500
X-MC-Unique: yd4R6GCRP2SgM5WkG-ef4g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1669C801817;
        Thu, 11 Mar 2021 03:23:09 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-9.pek2.redhat.com [10.72.13.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E96D10023AC;
        Thu, 11 Mar 2021 03:23:01 +0000 (UTC)
Subject: Re: [PATCH V3 1/6] vDPA/ifcvf: get_vendor_id returns a device
 specific vendor id
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        lulu@redhat.com, leonro@nvidia.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210310090052.4762-1-lingshan.zhu@intel.com>
 <20210310090052.4762-2-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ff5fc8f9-f886-bd2a-60cc-771c628c6c4b@redhat.com>
Date:   Thu, 11 Mar 2021 11:23:00 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210310090052.4762-2-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/10 5:00 下午, Zhu Lingshan wrote:
> In this commit, ifcvf_get_vendor_id() will return
> a device specific vendor id of the probed pci device
> than a hard code.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>   drivers/vdpa/ifcvf/ifcvf_main.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index fa1af301cf55..e501ee07de17 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -324,7 +324,10 @@ static u32 ifcvf_vdpa_get_device_id(struct vdpa_device *vdpa_dev)
>   
>   static u32 ifcvf_vdpa_get_vendor_id(struct vdpa_device *vdpa_dev)
>   {
> -	return IFCVF_SUBSYS_VENDOR_ID;
> +	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
> +	struct pci_dev *pdev = adapter->pdev;
> +
> +	return pdev->subsystem_vendor;
>   }


While at this, I wonder if we can do something similar in 
get_device_id() if it could be simple deduced from some simple math from 
the pci device id?

Thanks


>   
>   static u32 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)

