Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1134152CD16
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 09:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbiESH3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 03:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbiESH3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 03:29:50 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E6387A0C
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 00:29:49 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id oe17-20020a17090b395100b001df77d29587so8015405pjb.2
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 00:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KMBnUb1kBr5JyIyg89dR1sXybd4K5tc0en5kaQ0S1IE=;
        b=hBcgV9D2BNRKny/Ssi4wXAPjE4Tfzhc6cNHd6JHC44SV7xR/ClZzSD+64RQiq3wmIm
         PBBRjx3fCa2NzIfi5uJfnixDADocS73Ksp7bJGm7EAOkgKQbSaEKcgHfi4QvqCv5SCi/
         aN+mXQNCJOLNLUqP+NvJHFKTjdW1EyulF5TIWsR2y+8WzZ1QDq+x9jNRZqgl61uXEINM
         ejkGnzfByLli6NcqmyiizyH7AGHwgnu6RphNPmnwAPVpzwXW39ORT8jGJAQg7Xn97bL/
         a2Omqhyku3HAhJcsFZ6+RJ1LDuSS8BQPxAL0TNRvktvf9UW72FIKVURavwjCMoToHRGR
         /OEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KMBnUb1kBr5JyIyg89dR1sXybd4K5tc0en5kaQ0S1IE=;
        b=U36drjBl2i1rkl+fcINUWM1TMjbpsuY7iwQSA6HmQzXeSOHIF5tmnt+snQxPLbhZSe
         xdcHVnEHMh0+b/yZl4ZFS1OcIvBUV8yjTP3vhr6JjK3bW+bymV6U5UAryxtsYParaTY7
         PTQPVptUMwu/LA/NZptMAB1t4lowOTVanLe2cN16xAgO0ryTM8av4bRDTiDKQss4g0Nv
         jg3WOgDPpyuvx5W02VPwhjSk05MsKSz2FX0m1o1G++Sigk3QU7NRIciZlDOE+17JGzNq
         45aVqdTm+tthwJOKA52AZuan8Tb8Nz2yze4qOVWLs2FlZkukMe0artoOEoxJVjjM1WmX
         GVGQ==
X-Gm-Message-State: AOAM5336Dt8tDwr0QBxHgq3xjK/Ahqpkf05jAGDtsriGC7lenO2VhGp8
        rzcohj+B4fqKFzvY63XRK48+9MsctKwxXo9Mc714MA==
X-Google-Smtp-Source: ABdhPJyOu8zGQ1sj8z5GxUDBXNS9pWzxtvEh01j/oD4VhbUMv74+9EyCaC/0RB2gAKGEWCeBk3032HMmNRBpiWW5/EA=
X-Received: by 2002:a17:902:a583:b0:15d:197b:9259 with SMTP id
 az3-20020a170902a58300b0015d197b9259mr3387274plb.51.1652945388557; Thu, 19
 May 2022 00:29:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220519074351.829774-1-william.xuanziyang@huawei.com>
In-Reply-To: <20220519074351.829774-1-william.xuanziyang@huawei.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Thu, 19 May 2022 09:29:12 +0200
Message-ID: <CAMZdPi9z=OM0=yZbBu0eDvFd30efNpt3qmDHuCTj6LGJxdBTbw@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net: wwan: t7xx: fix GFP_KERNEL usage in
 spin_lock context
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        m.chetan.kumar@linux.intel.com, ricardo.martinez@linux.intel.com,
        ryazanov.s.a@gmail.com, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 May 2022 at 09:26, Ziyang Xuan <william.xuanziyang@huawei.com> wrote:
>
> t7xx_cldma_clear_rxq() call t7xx_cldma_alloc_and_map_skb() in spin_lock
> context, But __dev_alloc_skb() in t7xx_cldma_alloc_and_map_skb() uses
> GFP_KERNEL, that will introduce scheduling factor in spin_lock context.
>
> Because t7xx_cldma_clear_rxq() is called after stopping CLDMA, so we can
> remove the spin_lock from t7xx_cldma_clear_rxq().
>
> Fixes: 39d439047f1d ("net: wwan: t7xx: Add control DMA interface")
> Suggested-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>

> ---
>  drivers/net/wwan/t7xx/t7xx_hif_cldma.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> ---
> v3:
>   - Add Suggested-by and simplify comments
> v2:
>   - Remove spin_lock instead of using GFP_ATOMIC
>
> diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
> index 46066dcd2607..3a46a5bea24f 100644
> --- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
> +++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
> @@ -782,10 +782,11 @@ static int t7xx_cldma_clear_rxq(struct cldma_ctrl *md_ctrl, int qnum)
>         struct cldma_queue *rxq = &md_ctrl->rxq[qnum];
>         struct cldma_request *req;
>         struct cldma_gpd *gpd;
> -       unsigned long flags;
>         int ret = 0;
>
> -       spin_lock_irqsave(&rxq->ring_lock, flags);
> +       /* CLDMA has been stopped. There is not any CLDMA IRQ, holding
> +        * ring_lock is not needed.
> +        */
>         t7xx_cldma_q_reset(rxq);
>         list_for_each_entry(req, &rxq->tr_ring->gpd_ring, entry) {
>                 gpd = req->gpd;
> @@ -808,7 +809,6 @@ static int t7xx_cldma_clear_rxq(struct cldma_ctrl *md_ctrl, int qnum)
>
>                 t7xx_cldma_gpd_set_data_ptr(req->gpd, req->mapped_buff);
>         }
> -       spin_unlock_irqrestore(&rxq->ring_lock, flags);
>
>         return ret;
>  }
> --
> 2.25.1
>
