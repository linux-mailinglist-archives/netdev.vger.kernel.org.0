Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B33E580DE1
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 09:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238560AbiGZHhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 03:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238581AbiGZHhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 03:37:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2080A2C12F
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 00:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658820973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I2X6PqCMeHc1eaWE4k5DTUECIGHthtw+h76LSBegAoc=;
        b=GizBc+2Lp1Z2dgVA8kY+6obkF3WbYVupqRDej2MN8tmEP2gFe9eyTsJjzhE5n0stUV1ZuO
        0fyZi2F0iDgBKT8lUDA1kZ2X+xMQyNczagnN9X5IxSTL2Sk2bfU1zExtUJYfQS/qmtzxHL
        B/BKRK7oLS7d6KRLrtnv3oppCrzYuuE=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-hFQNwUAuMeSqVHjxYjGitA-1; Tue, 26 Jul 2022 03:36:11 -0400
X-MC-Unique: hFQNwUAuMeSqVHjxYjGitA-1
Received: by mail-pl1-f200.google.com with SMTP id i17-20020a170902c95100b0016d437630f9so5758640pla.1
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 00:36:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=I2X6PqCMeHc1eaWE4k5DTUECIGHthtw+h76LSBegAoc=;
        b=X0HzsHIP6KGX04y3ALrhThKsdBW0i2XyAl5J3DfsVFE9qiRvsASx7taaHtcLxxk3tF
         rbn1iGegNrNQ0BJAiq6fgAZaBb92d7SwikO8RV46iOfNWUJYvjR+vSbZ/nECy6t39nCF
         xuUzmIIa4nQbgzhblFkM8QKNRsv504NyOFbrVHG+5kfl0awpRRpzfJzDbgymq5YSPXe5
         kNZB0tNVF41eakHLQI7FL4NfirvbdPU9CKlZrbNrFFPapy58LKPy6D2bYjUfKtiH8T7R
         sAxYCXd1EOHW+jrMRqN50rNmM15I660u0hjsY223gPaZ7tK6SnFoX7BznWYJd/dN8hhK
         FRpQ==
X-Gm-Message-State: AJIora93K3hh6v9+7qHsVSoeMGXdu2PIr++ABi3RJzX7n38dIOf96EKS
        lXERqlcib0X/8Z4vCmtxYbpuRAOuGmN01OREhTFuLqOQNjFc5eDQvcUAK6hq1OP6NE2Nc0ae64Z
        X6JPEpFwjsLA6Cs0Y
X-Received: by 2002:a17:902:cf4a:b0:16b:d4a8:b92e with SMTP id e10-20020a170902cf4a00b0016bd4a8b92emr7837094plg.16.1658820970474;
        Tue, 26 Jul 2022 00:36:10 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tdX+kz6MU69RxO0ipZjRMbzb/5fxM+oxpalwEkNhFemmJUH/+vCfJ8sm1F0bb0Jbjv0YZ/yg==
X-Received: by 2002:a17:902:cf4a:b0:16b:d4a8:b92e with SMTP id e10-20020a170902cf4a00b0016bd4a8b92emr7837079plg.16.1658820970172;
        Tue, 26 Jul 2022 00:36:10 -0700 (PDT)
Received: from [10.72.12.201] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x23-20020a1709027c1700b0016c57657977sm10604451pll.41.2022.07.26.00.36.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 00:36:09 -0700 (PDT)
Message-ID: <16a232ad-e0a1-fd4c-ae3e-27db168daacb@redhat.com>
Date:   Tue, 26 Jul 2022 15:36:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [RFC 1/5] vhost: reorder used descriptors in a batch
Content-Language: en-US
To:     Guo Zhi <qtxuning1999@sjtu.edu.cn>, eperezma@redhat.com,
        sgarzare@redhat.com, mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <20220721084341.24183-1-qtxuning1999@sjtu.edu.cn>
 <20220721084341.24183-2-qtxuning1999@sjtu.edu.cn>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220721084341.24183-2-qtxuning1999@sjtu.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/7/21 16:43, Guo Zhi 写道:
> Device may not use descriptors in order, for example, NIC and SCSI may
> not call __vhost_add_used_n with buffers in order.  It's the task of
> __vhost_add_used_n to order them.


I'm not sure this is ture. Having ooo descriptors is probably by design 
to have better performance.

This might be obvious for device that may have elevator or QOS stuffs.

I suspect the right thing to do here is, for the device that can't 
perform better in the case of IN_ORDER, let's simply not offer IN_ORDER 
(zerocopy or scsi). And for the device we know it can perform better, 
non-zercopy ethernet device we can do that.


>   This commit reorder the buffers using
> vq->heads, only the batch is begin from the expected start point and is
> continuous can the batch be exposed to driver.  And only writing out a
> single used ring for a batch of descriptors, according to VIRTIO 1.1
> spec.


So this sounds more like a "workaround" of the device that can't consume 
buffer in order, I suspect it can help in performance.

More below.


>
> Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
> ---
>   drivers/vhost/vhost.c | 44 +++++++++++++++++++++++++++++++++++++++++--
>   drivers/vhost/vhost.h |  3 +++
>   2 files changed, 45 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 40097826c..e2e77e29f 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -317,6 +317,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
>   	vq->used_flags = 0;
>   	vq->log_used = false;
>   	vq->log_addr = -1ull;
> +	vq->next_used_head_idx = 0;
>   	vq->private_data = NULL;
>   	vq->acked_features = 0;
>   	vq->acked_backend_features = 0;
> @@ -398,6 +399,8 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
>   					  GFP_KERNEL);
>   		if (!vq->indirect || !vq->log || !vq->heads)
>   			goto err_nomem;
> +
> +		memset(vq->heads, 0, sizeof(*vq->heads) * dev->iov_limit);
>   	}
>   	return 0;
>   
> @@ -2374,12 +2377,49 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
>   			    unsigned count)
>   {
>   	vring_used_elem_t __user *used;
> +	struct vring_desc desc;
>   	u16 old, new;
>   	int start;
> +	int begin, end, i;
> +	int copy_n = count;
> +
> +	if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {


How do you guarantee that ids of heads are contiguous?


> +		/* calculate descriptor chain length for each used buffer */


I'm a little bit confused about this comment, we have heads[i].len for this?


> +		for (i = 0; i < count; i++) {
> +			begin = heads[i].id;
> +			end = begin;
> +			vq->heads[begin].len = 0;


Does this work for e.g RX virtqueue?


> +			do {
> +				vq->heads[begin].len += 1;
> +				if (unlikely(vhost_get_desc(vq, &desc, end))) {


Let's try hard to avoid more userspace copy here, it's the source of 
performance regression.

Thanks


> +					vq_err(vq, "Failed to get descriptor: idx %d addr %p\n",
> +					       end, vq->desc + end);
> +					return -EFAULT;
> +				}
> +			} while ((end = next_desc(vq, &desc)) != -1);
> +		}
> +
> +		count = 0;
> +		/* sort and batch continuous used ring entry */
> +		while (vq->heads[vq->next_used_head_idx].len != 0) {
> +			count++;
> +			i = vq->next_used_head_idx;
> +			vq->next_used_head_idx = (vq->next_used_head_idx +
> +						  vq->heads[vq->next_used_head_idx].len)
> +						  % vq->num;
> +			vq->heads[i].len = 0;
> +		}
> +		/* only write out a single used ring entry with the id corresponding
> +		 * to the head entry of the descriptor chain describing the last buffer
> +		 * in the batch.
> +		 */
> +		heads[0].id = i;
> +		copy_n = 1;
> +	}
>   
>   	start = vq->last_used_idx & (vq->num - 1);
>   	used = vq->used->ring + start;
> -	if (vhost_put_used(vq, heads, start, count)) {
> +	if (vhost_put_used(vq, heads, start, copy_n)) {
>   		vq_err(vq, "Failed to write used");
>   		return -EFAULT;
>   	}
> @@ -2410,7 +2450,7 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
>   
>   	start = vq->last_used_idx & (vq->num - 1);
>   	n = vq->num - start;
> -	if (n < count) {
> +	if (n < count && !vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
>   		r = __vhost_add_used_n(vq, heads, n);
>   		if (r < 0)
>   			return r;
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index d9109107a..7b2c0fbb5 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -107,6 +107,9 @@ struct vhost_virtqueue {
>   	bool log_used;
>   	u64 log_addr;
>   
> +	/* Sort heads in order */
> +	u16 next_used_head_idx;
> +
>   	struct iovec iov[UIO_MAXIOV];
>   	struct iovec iotlb_iov[64];
>   	struct iovec *indirect;

