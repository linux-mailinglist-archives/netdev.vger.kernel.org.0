Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9262E5EDC65
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 14:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbiI1MSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 08:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiI1MSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 08:18:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E9A7E03D
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 05:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664367507;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9q51bLxm262eHLp+720Tq41cE09C48zOVN9jMN9Lyno=;
        b=BfAr2JUko5PPruEgdWDI3cuLmOwL8+9VLACawtqq8ZvYViDXdW8OkFhF/Cd8UmViB73zct
        I4HEnaVKtQyjIFLBcwvqp8My5bQavTp/BOTsyc/tKXltw1RiaOswvsg2uKka1TyTt7XUPS
        lg1s8X/6d+ktX9zrkX6MH83kOYgMEF4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-266-0RlXhjOaNS-yKONPk8BHfA-1; Wed, 28 Sep 2022 08:18:24 -0400
X-MC-Unique: 0RlXhjOaNS-yKONPk8BHfA-1
Received: by mail-wm1-f69.google.com with SMTP id 84-20020a1c0257000000b003b4be28d7e3so1129318wmc.0
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 05:18:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:to:from
         :x-gm-message-state:from:to:cc:subject:date;
        bh=9q51bLxm262eHLp+720Tq41cE09C48zOVN9jMN9Lyno=;
        b=IAbuHOcgNEGkpRvAj2zEusLBL+iYr4VSC1B0OHhM2Ru1xKtR/9mnC1omOfBwR27mOy
         rea4pPfNpqT1h+sI6ZtJpfjCyTa6ggBC8TBZNUKxkAOqXCDN+fjKYK4UdcFRcStkULKY
         8vE9tZFkg+SIoLACDYGLb9JazRtlwW9Bd73AVQHjsP9lQprMbLXGcDmZbbL+t5f3vr5S
         IZYMPAtXMM42fFqkoKq1VcGQkV5jx1IyXuAqJjtbG9I3kQS5tJuAG4QklnHZQWzYWEEq
         kXX5qq5SbrrK1zMEffq/EJJZPMLnhaAsmyL6CuDhugrlU8kbUxOl771FfaUzw2Pb5wXc
         eAFQ==
X-Gm-Message-State: ACrzQf2L0flE5m8dYKnM0d0JF8NcwOuqUZZhi/XEDFLTeoWLBq3uD8Yn
        ntts86v9Jdn4Ii8D0zu4XNPNHQsRY+kBBvW6i6GbHgaOu1qUuLTUPAoifwBUgrhw+cYoDTsRewJ
        YTVsIsuldBPEYjJhY
X-Received: by 2002:a5d:59c8:0:b0:22b:237c:3e1b with SMTP id v8-20020a5d59c8000000b0022b237c3e1bmr20184084wry.635.1664367502407;
        Wed, 28 Sep 2022 05:18:22 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5F21mxUsopIrv+BjQ0rBl7FMBJ+q8hvQ5AxqVNgdtgM5vgfCffsdEX02IpVWR/86LHrmwYaA==
X-Received: by 2002:a5d:59c8:0:b0:22b:237c:3e1b with SMTP id v8-20020a5d59c8000000b0022b237c3e1bmr20184068wry.635.1664367502149;
        Wed, 28 Sep 2022 05:18:22 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id bg33-20020a05600c3ca100b003a5f4fccd4asm1660707wmb.35.2022.09.28.05.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 05:18:21 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Yury Norov <yury.norov@gmail.com>
Subject: Re: [PATCH 1/7] cpumask: fix checking valid cpu range
In-Reply-To: <20220919210559.1509179-2-yury.norov@gmail.com>
References: <20220919210559.1509179-1-yury.norov@gmail.com>
 <20220919210559.1509179-2-yury.norov@gmail.com>
Date:   Wed, 28 Sep 2022 13:18:20 +0100
Message-ID: <xhsmhbkqz4rqr.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/09/22 14:05, Yury Norov wrote:
> The range of valid CPUs is [0, nr_cpu_ids). Some cpumask functions are
> passed with a shifted CPU index, and for them, the valid range is
> [-1, nr_cpu_ids-1). Currently for those functions, we check the index
> against [-1, nr_cpu_ids), which is wrong.
>
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> ---
>  include/linux/cpumask.h | 19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> index e4f9136a4a63..a1cd4eb1a3d6 100644
> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -174,9 +174,8 @@ static inline unsigned int cpumask_last(const struct cpumask *srcp)
>  static inline
>  unsigned int cpumask_next(int n, const struct cpumask *srcp)
>  {
> -	/* -1 is a legal arg here. */
> -	if (n != -1)
> -		cpumask_check(n);
> +	/* n is a prior cpu */
> +	cpumask_check(n + 1);
>       return find_next_bit(cpumask_bits(srcp), nr_cpumask_bits, n + 1);

I'm confused, this makes passing nr_cpu_ids-1 to cpumask_next*() trigger a
warning. The documentation does states:

* @n: the cpu prior to the place to search (ie. return will be > @n)

So n is a valid CPU number (with -1 being the exception for scan
initialization), this shouldn't exclude nr_cpu_ids-1.

IMO passing nr_cpu_ids-1 should be treated the same as passing the
last set bit in a bitmap: no warning, and returns the bitmap
size. Otherwise reaching nr_cpu_ids-1 has to be special-cased by the
calling code which seems like unnecessary boiler plate

For instance, I trigger the cpumask_check() warning there:

3d2dcab932d0:block/blk-mq.c @l2047
        if (--hctx->next_cpu_batch <= 0) {
select_cpu:
                next_cpu = cpumask_next_and(next_cpu, hctx->cpumask, <-----
                                cpu_online_mask);
                if (next_cpu >= nr_cpu_ids)
                        next_cpu = blk_mq_first_mapped_cpu(hctx);
                hctx->next_cpu_batch = BLK_MQ_CPU_WORK_BATCH;
        }

next_cpu is a valid CPU number, shifting it doesn't seem to make sense, and
we do want it to reach nr_cpu_ids-1.

