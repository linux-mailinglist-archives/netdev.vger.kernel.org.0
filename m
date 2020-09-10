Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314A6263B0E
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730190AbgIJCyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:54:14 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28801 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730179AbgIJB4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 21:56:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599702991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0C1QtHwLo5ZP+Ar8+ErpMK60qaWJInbsQRohKM7A1QA=;
        b=LUsjB9UuYzodxp7abyYPX8m1Ef4ICHzWnSxzJ1OU3GLt5qjUYDWcAPMZobiRzKkWeCFjkU
        4eClBQlpQW7j3h+z7+b/lPifRkge7XCRTwWav2cukFDwEqqp6zcFrRWiaVapbS5z7Q15Z/
        VZQmNwAfFUsUQ+0nVB9k7AcH2gjNC1k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-ZMZwJTTFNGOE9gvdtSDulw-1; Wed, 09 Sep 2020 21:56:28 -0400
X-MC-Unique: ZMZwJTTFNGOE9gvdtSDulw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A9D6F593B2;
        Thu, 10 Sep 2020 01:56:24 +0000 (UTC)
Received: from [10.72.13.124] (ovpn-13-124.pek2.redhat.com [10.72.13.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E0B3B60BF1;
        Thu, 10 Sep 2020 01:56:06 +0000 (UTC)
Subject: Re: [PATCH] vhost-vdpa: fix memory leak in error path
To:     Li Qiang <liq3ea@163.com>, mst@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liq3ea@gmail.com
References: <20200909154120.363209-1-liq3ea@163.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <bfae5c35-355a-8d8a-5057-a970db24ee41@redhat.com>
Date:   Thu, 10 Sep 2020 09:56:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200909154120.363209-1-liq3ea@163.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/9/9 下午11:41, Li Qiang wrote:
> Free the 'page_list' when the 'npages' is zero.
>
> Signed-off-by: Li Qiang <liq3ea@163.com>
> ---
>   drivers/vhost/vdpa.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 3fab94f88894..6a9fcaf1831d 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -609,8 +609,10 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>   		gup_flags |= FOLL_WRITE;
>   
>   	npages = PAGE_ALIGN(msg->size + (iova & ~PAGE_MASK)) >> PAGE_SHIFT;
> -	if (!npages)
> -		return -EINVAL;
> +	if (!npages) {
> +		ret = -EINVAL;
> +		goto free_page;
> +	}
>   
>   	mmap_read_lock(dev->mm);
>   
> @@ -666,6 +668,8 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
>   		atomic64_sub(npages, &dev->mm->pinned_vm);
>   	}
>   	mmap_read_unlock(dev->mm);
> +
> +free_page:
>   	free_page((unsigned long)page_list);
>   	return ret;
>   }


Cc: stable@vger.kernel.org

Acked-by: Jason Wang <jasowang@redhat.com>



