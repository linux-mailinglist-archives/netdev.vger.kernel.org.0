Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7CB26FDC2
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgIRNDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:03:51 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:43361 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726301AbgIRNDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 09:03:50 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0U9JntaJ_1600434225;
Received: from B-455UMD6M-2027.local(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0U9JntaJ_1600434225)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 18 Sep 2020 21:03:46 +0800
Subject: Re: [PATCH] vhost-vdpa: fix memory leak in error path
To:     Li Qiang <liq3ea@163.com>, mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liq3ea@gmail.com
References: <20200909154120.363209-1-liq3ea@163.com>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <1104febd-1f2d-5edd-52e9-ca992e6d5340@linux.alibaba.com>
Date:   Fri, 18 Sep 2020 21:03:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200909154120.363209-1-liq3ea@163.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LGTM.

Reviewed-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

Thanks.

On 9/9/20 11:41 PM, Li Qiang wrote:
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
> 
