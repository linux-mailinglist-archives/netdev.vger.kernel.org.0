Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B217289D5D
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 04:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730073AbgJJCHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 22:07:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36348 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729759AbgJJBvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 21:51:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602294661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AkDohCfK7nVkmvX90opUAZF6or9jerCZXTyJ6Vl8gSs=;
        b=CxDMOm3JrMJnedkWy/xk9QaQxjMgjo5WQADtQq/geUHWemAB4cESFWNrC7iB3Aw69yak2z
        7vJ+ulMYTGKMRHKZYujwWEdL1Z0+G/c3HslZ3kc+qj5kfEyMAnq7m6FHn1jO3Kbk+MwFX/
        oTmU/mdCNzcN6s0zD3N9Mjya17YF+qM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-mQYwk6YoMRq4w2A_ALxuOQ-1; Fri, 09 Oct 2020 21:48:52 -0400
X-MC-Unique: mQYwk6YoMRq4w2A_ALxuOQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB5E0427C8;
        Sat, 10 Oct 2020 01:48:50 +0000 (UTC)
Received: from [10.72.13.27] (ovpn-13-27.pek2.redhat.com [10.72.13.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37486614F5;
        Sat, 10 Oct 2020 01:48:43 +0000 (UTC)
Subject: Re: [PATCH v3 1/2] vhost-vdpa: fix vhost_vdpa_map() on error
 condition
To:     Si-Wei Liu <si-wei.liu@oracle.com>, mst@redhat.com,
        lingshan.zhu@intel.com
Cc:     joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <1601701330-16837-1-git-send-email-si-wei.liu@oracle.com>
 <1601701330-16837-2-git-send-email-si-wei.liu@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a780b2e2-d8ce-4c27-df6b-47523c356d02@redhat.com>
Date:   Sat, 10 Oct 2020 09:48:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1601701330-16837-2-git-send-email-si-wei.liu@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/10/3 下午1:02, Si-Wei Liu wrote:
> vhost_vdpa_map() should remove the iotlb entry just added
> if the corresponding mapping fails to set up properly.
>
> Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> Signed-off-by: Si-Wei Liu <si-wei.liu@oracle.com>
> ---
>   drivers/vhost/vdpa.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 796fe97..0f27919 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -565,6 +565,9 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
>   			      perm_to_iommu_flags(perm));
>   	}
>   
> +	if (r)
> +		vhost_iotlb_del_range(dev->iotlb, iova, iova + size - 1);
> +
>   	return r;
>   }
>   


Acked-by: Jason Wang <jasowang@redhat.com>


