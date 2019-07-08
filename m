Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F125261FC5
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 15:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731445AbfGHNrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 09:47:36 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:18056 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728461AbfGHNre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 09:47:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1562593654; x=1594129654;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=8rBFJB8HIcpTjcsHbBXFV53kwcbzuXnP7q+tigJQQ98=;
  b=b0Sy/VRqd2Y+sXCrRls33VGd8Z5Fl602gYAd3SbOl9Eardn8nNh3Z9Rn
   CEwnProHBY+9mPU0IQMpmGdXj5Fks900duBmroOg9uMjadrrxlnlTsfiO
   X2dnwxJWB2roz4HIkLfn+UrTLs49qXsYKm5QGpsVL22+JWLQM3ZMAHVsU
   M=;
X-IronPort-AV: E=Sophos;i="5.62,466,1554768000"; 
   d="scan'208";a="814935336"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-1d-98acfc19.us-east-1.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 08 Jul 2019 13:47:23 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1d-98acfc19.us-east-1.amazon.com (Postfix) with ESMTPS id 0344DA1E28;
        Mon,  8 Jul 2019 13:47:20 +0000 (UTC)
Received: from EX13D19EUB003.ant.amazon.com (10.43.166.69) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 8 Jul 2019 13:47:20 +0000
Received: from 8c85908914bf.ant.amazon.com (10.43.162.144) by
 EX13D19EUB003.ant.amazon.com (10.43.166.69) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 8 Jul 2019 13:47:16 +0000
Subject: Re: [PATCH v5 rdma-next 1/6] RDMA/core: Create mmap database and
 cookie helper functions
To:     Michal Kalderon <michal.kalderon@marvell.com>,
        <ariel.elior@marvell.com>, <jgg@ziepe.ca>, <dledford@redhat.com>
CC:     <linux-rdma@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
References: <20190708091503.14723-1-michal.kalderon@marvell.com>
 <20190708091503.14723-2-michal.kalderon@marvell.com>
From:   Gal Pressman <galpress@amazon.com>
Message-ID: <da67a821-1b26-c795-ff43-af17324f07e5@amazon.com>
Date:   Mon, 8 Jul 2019 16:47:11 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190708091503.14723-2-michal.kalderon@marvell.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.162.144]
X-ClientProxiedBy: EX13D08UWB003.ant.amazon.com (10.43.161.186) To
 EX13D19EUB003.ant.amazon.com (10.43.166.69)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/07/2019 12:14, Michal Kalderon wrote:
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index 8a6ccb936dfe..a830c2c5d691 100644
> --- a/drivers/infiniband/core/device.c
> +++ b/drivers/infiniband/core/device.c
> @@ -2521,6 +2521,7 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
>  	SET_DEVICE_OP(dev_ops, map_mr_sg_pi);
>  	SET_DEVICE_OP(dev_ops, map_phys_fmr);
>  	SET_DEVICE_OP(dev_ops, mmap);
> +	SET_DEVICE_OP(dev_ops, mmap_free);
>  	SET_DEVICE_OP(dev_ops, modify_ah);
>  	SET_DEVICE_OP(dev_ops, modify_cq);
>  	SET_DEVICE_OP(dev_ops, modify_device);
> diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
> index ccf4d069c25c..7166741834c8 100644
> --- a/drivers/infiniband/core/rdma_core.c
> +++ b/drivers/infiniband/core/rdma_core.c
> @@ -817,6 +817,7 @@ static void ufile_destroy_ucontext(struct ib_uverbs_file *ufile,
>  	rdma_restrack_del(&ucontext->res);
>  
>  	ib_dev->ops.dealloc_ucontext(ucontext);
> +	rdma_user_mmap_entries_remove_free(ucontext);

This should happen before dealloc_ucontext.

> +struct rdma_user_mmap_entry *
> +rdma_user_mmap_entry_get(struct ib_ucontext *ucontext, u64 key, u64 len)
> +{
> +	struct rdma_user_mmap_entry *entry;
> +	u64 mmap_page;
> +
> +	mmap_page = key >> PAGE_SHIFT;
> +	if (mmap_page > U32_MAX)
> +		return NULL;
> +
> +	entry = xa_load(&ucontext->mmap_xa, mmap_page);
> +	if (!entry || rdma_user_mmap_get_key(entry) != key ||

I wonder if the 'rdma_user_mmap_get_key(entry) != key' check is still needed.

> +/*
> + * This is only called when the ucontext is destroyed and there can be no
> + * concurrent query via mmap or allocate on the xarray, thus we can be sure no
> + * other thread is using the entry pointer. We also know that all the BAR
> + * pages have either been zap'd or munmaped at this point.  Normal pages are
> + * refcounted and will be freed at the proper time.
> + */
> +void rdma_user_mmap_entries_remove_free(struct ib_ucontext *ucontext)
> +{
> +	struct rdma_user_mmap_entry *entry;
> +	unsigned long mmap_page;
> +
> +	xa_for_each(&ucontext->mmap_xa, mmap_page, entry) {
> +		xa_erase(&ucontext->mmap_xa, mmap_page);
> +
> +		ibdev_dbg(ucontext->device,
> +			  "mmap: obj[0x%p] key[%#llx] addr[%#llx] len[%#llx] removed\n",
> +			  entry->obj, rdma_user_mmap_get_key(entry),
> +			  entry->address, entry->length);
> +		if (ucontext->device->ops.mmap_free)
> +			ucontext->device->ops.mmap_free(entry->address,
> +							entry->length,
> +							entry->mmap_flag);

Pass entry instead?

> +		kfree(entry);
> +	}
> +}
> +
>  void uverbs_user_mmap_disassociate(struct ib_uverbs_file *ufile)
>  {
>  	struct rdma_umap_priv *priv, *next_priv;
> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index 26e9c2594913..54ce3fdae180 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -1425,6 +1425,8 @@ struct ib_ucontext {
>  	 * Implementation details of the RDMA core, don't use in drivers:
>  	 */
>  	struct rdma_restrack_entry res;
> +	struct xarray mmap_xa;
> +	u32 mmap_xa_page;
>  };
>  
>  struct ib_uobject {
> @@ -2311,6 +2313,7 @@ struct ib_device_ops {
>  			      struct ib_udata *udata);
>  	void (*dealloc_ucontext)(struct ib_ucontext *context);
>  	int (*mmap)(struct ib_ucontext *context, struct vm_area_struct *vma);
> +	void (*mmap_free)(u64 address, u64 length, u8 mmap_flag);

I feel like this callback needs some documentation.

>  	void (*disassociate_ucontext)(struct ib_ucontext *ibcontext);
>  	int (*alloc_pd)(struct ib_pd *pd, struct ib_udata *udata);
>  	void (*dealloc_pd)(struct ib_pd *pd, struct ib_udata *udata);
> @@ -2706,9 +2709,23 @@ void  ib_set_client_data(struct ib_device *device, struct ib_client *client,
>  void ib_set_device_ops(struct ib_device *device,
>  		       const struct ib_device_ops *ops);
>  
> +#define RDMA_USER_MMAP_INVALID U64_MAX
> +struct rdma_user_mmap_entry {
> +	void  *obj;

I know EFA is the culprit here, but please remove the extra space :).

> +	u64 address;
> +	u64 length;
> +	u32 mmap_page;
> +	u8 mmap_flag;
> +};
> +
