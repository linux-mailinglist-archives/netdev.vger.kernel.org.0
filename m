Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF5D168D6AE
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 13:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbjBGM24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 07:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBGM2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 07:28:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ABE5305CC
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 04:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675772886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/RnkO+dPA0w7/M71/Ly3fKFHUybkkW32brBa43F/Fvk=;
        b=WXdTt/zvKHAdIhyPHbPAk98YkVDeWIizpzetxa++T48vIwUYUx442rYPxLHEhyRreURmD0
        uR9nq9RQx6ogdrt/fyaEMZWgJhp3lNAK3y1h1qqhs3rfjhBf9KF3qumHpIx2vqzQYUMmaa
        lMYT6IEHlYBbiNE5FQu3+vYbsi7Lqlk=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-453-8-GjTbeEMkqSGFJf0wCJ9w-1; Tue, 07 Feb 2023 07:28:05 -0500
X-MC-Unique: 8-GjTbeEMkqSGFJf0wCJ9w-1
Received: by mail-qv1-f71.google.com with SMTP id lw11-20020a05621457cb00b005376b828c22so7461620qvb.6
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 04:28:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/RnkO+dPA0w7/M71/Ly3fKFHUybkkW32brBa43F/Fvk=;
        b=j7Zo7rEAHE4AEP5MzCKVIJ9+J0+M8T3Q0UoD1TaW13pb8wQF1qVv+iLS/+uIEOBlKW
         ct1mlAHA3+cc8eqxbakQ1A0vpEk0nfzl2Z935lA6TqVS0zSHGJVNjPqgEhP/kUC6N0o0
         wNs0tAqq6JUQpFqmY1jUTZJYDmrAbnFp9XwHgmyJglysxzDMwqE6KaAE11qTj9kc3Z2z
         iAyDYO27a+fwkaCGOJhch3GlxYoRgQeBKzTOS6GYZswwvPwO845v/Agh+yT515/0cX83
         vA2+LnDl9tJ0Uw89+qaHoo+FNxOvXFmTvUAYmRY1vorY5D98B+YeAWk+chh+I79nrKgl
         WKRw==
X-Gm-Message-State: AO0yUKXVSFbu2LnrbX6RFfzG1FH8a5jtPP8+C5r17Hu7Aan20J9OZTVT
        GR7HjWUYnywYBcStfAbFtzNcBFJZm364oNVthm4Kn2y+ybIVNjF7dWqjNVKQD1Wq0W6Eejzep0d
        I327Is6upwWxjfXfa
X-Received: by 2002:ac8:4e8d:0:b0:3b8:5f47:aac2 with SMTP id 13-20020ac84e8d000000b003b85f47aac2mr6276011qtp.1.1675772884869;
        Tue, 07 Feb 2023 04:28:04 -0800 (PST)
X-Google-Smtp-Source: AK7set8VnRCzqtHWA98pt4o+ZD18G9GZ7OpRO+gXLVl9dCjIKA18pdC0brh+4nZnm8WlJsLe1vlV/g==
X-Received: by 2002:ac8:4e8d:0:b0:3b8:5f47:aac2 with SMTP id 13-20020ac84e8d000000b003b85f47aac2mr6275968qtp.1.1675772884593;
        Tue, 07 Feb 2023 04:28:04 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id i8-20020a05620a248800b00727538eb831sm9556089qkn.86.2023.02.07.04.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 04:28:03 -0800 (PST)
Message-ID: <f5fd80ab32931e7367c3181635f40179536608b8.camel@redhat.com>
Subject: Re: [net-next PATCH V3 2/4] octeontx2-pf: qos send queues management
From:   Paolo Abeni <pabeni@redhat.com>
To:     Hariprasad Kelam <hkelam@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, sbhatta@marvell.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, saeedm@nvidia.com,
        richardcochran@gmail.com, tariqt@nvidia.com,
        linux-rdma@vger.kernel.org, maxtram95@gmail.com,
        naveenm@marvell.com, hariprasad.netdev@gmail.com
Date:   Tue, 07 Feb 2023 13:27:58 +0100
In-Reply-To: <20230206054640.5854-3-hkelam@marvell.com>
References: <20230206054640.5854-1-hkelam@marvell.com>
         <20230206054640.5854-3-hkelam@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-02-06 at 11:16 +0530, Hariprasad Kelam wrote:
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/d=
rivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> index 8a41ad8ca04f..f3ad4491ffb8 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> @@ -758,11 +758,16 @@ int otx2_txschq_stop(struct otx2_nic *pfvf)
>  void otx2_sqb_flush(struct otx2_nic *pfvf)
>  {
>  	int qidx, sqe_tail, sqe_head;
> +	struct otx2_snd_queue *sq;
>  	u64 incr, *ptr, val;
>  	int timeout =3D 1000;
> =20
>  	ptr =3D (u64 *)otx2_get_regaddr(pfvf, NIX_LF_SQ_OP_STATUS);
> -	for (qidx =3D 0; qidx < pfvf->hw.tot_tx_queues; qidx++) {
> +	for (qidx =3D 0; qidx < otx2_get_total_tx_queues(pfvf);
> +	     qidx++) {

The above can and should fit a single line.

> @@ -189,7 +190,8 @@ struct otx2_hw {
>  	u16                     rx_queues;
>  	u16                     tx_queues;
>  	u16                     xdp_queues;
> -	u16                     tot_tx_queues;
> +	u16			tc_tx_queues;
> +	u16                     non_qos_queues; //tx_queues and xdp_tx_queues

Please, avoid c++ style comments. Use plain /* */ instead.

>  	u16			max_queues;
>  	u16			pool_cnt;
>  	u16			rqpool_cnt;

[...]

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c b/driver=
s/net/ethernet/marvell/octeontx2/nic/qos_sq.c
> new file mode 100644
> index 000000000000..13a8cc53eb19

[...]

> +static void otx2_qos_sq_free_sqbs(struct otx2_nic *pfvf, int qidx)
> +{
> +	struct otx2_qset *qset =3D &pfvf->qset;
> +	struct otx2_hw *hw =3D &pfvf->hw;
> +	struct otx2_snd_queue *sq;
> +	u64 iova, pa;
> +	int sqb;
> +
> +	sq =3D &qset->sq[qidx];
> +	if (!sq->sqb_ptrs)
> +		return;
> +	for (sqb =3D 0; sqb < sq->sqb_count; sqb++) {
> +		if (!sq->sqb_ptrs[sqb])
> +			continue;
> +		iova =3D sq->sqb_ptrs[sqb];
> +		pa =3D otx2_iova_to_phys(pfvf->iommu_domain, iova);
> +		dma_unmap_page_attrs(pfvf->dev, iova, hw->sqb_size,
> +				     DMA_FROM_DEVICE,
> +				     DMA_ATTR_SKIP_CPU_SYNC);
> +		put_page(virt_to_page(phys_to_virt(pa)));
> +	}
> +
> +	sq->sqb_count =3D 0;
> +
> +	sq =3D &qset->sq[qidx];
> +	qmem_free(pfvf->dev, sq->sqe);
> +	qmem_free(pfvf->dev, sq->tso_hdrs);
> +	kfree(sq->sg);
> +	kfree(sq->sqb_ptrs);
> +	qmem_free(pfvf->dev, sq->timestamps);
> +
> +	memset((void *)sq, 0, sizeof(*sq));
> +}
> +
> +/* send queue id */
> +static void otx2_qos_sqb_flush(struct otx2_nic *pfvf, int qidx)
> +{
> +	int sqe_tail, sqe_head;
> +	u64 incr, *ptr, val;
> +
> +	ptr =3D (u64 *)otx2_get_regaddr(pfvf, NIX_LF_SQ_OP_STATUS);

This introduces a sparse warning:

drivers/net/ethernet/marvell/octeontx2/nic/qos_sq.c:164:16: warning: cast r=
emoves address space '__iomem' of expression

...
	=09
> +	incr =3D (u64)qidx << 32;
> +	val =3D otx2_atomic64_add(incr, ptr);

... which means the above is likely broken on some arches.

Thanks,

Paolo


