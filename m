Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73BF45F107C
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 19:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbiI3RER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 13:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbiI3REP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 13:04:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390481D8F16
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 10:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664557453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ny2EpTwmm6OpyVscwyDUmXkQRsvf+JVWempUoGoc+j8=;
        b=LV6WqlsPEhZ5oDtnrS0xint9yvJLSQWyJtaO0EQDLpimwl9GUQl8b7tOyMrt3mhAeanHzu
        fORgENfbbQnu7nDhVIhLVyC39GDmwZdXMi46IigYGQrYOXucLkTX3r4oPHOU5BgLwf50N0
        M7JidqASslnAPfwVMVhiR4KUF02C9KE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-92-xsttJPLdOG-loA6ziAiHFg-1; Fri, 30 Sep 2022 13:04:11 -0400
X-MC-Unique: xsttJPLdOG-loA6ziAiHFg-1
Received: by mail-wr1-f71.google.com with SMTP id s4-20020adfbc04000000b0022e03fc10a9so581745wrg.15
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 10:04:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=Ny2EpTwmm6OpyVscwyDUmXkQRsvf+JVWempUoGoc+j8=;
        b=Lxd5bDluJqz0lolAFeq45VK7IIoj36/RisLzD6vZ1C3/uP/YA6V28B2/WG/YJ9Tqwp
         KQQN8QiXeu6oNheB+7HOUKcALipJiwZ63ye16G+t9y53+E51GBww69DFq8vj7TX5YFZO
         OslVW1FqH+eqAeQFS3VKC4kV/iA4QFC5Ig7nXFuGof4OYHcMiiRMfNQ18GYAr7Ubx7FQ
         uAnETA+H32JOaPhRgOeJ6j8GJMhBddIluUY6BLXXrhWoB4NDVTooe4HUmZaIRuRyWCMu
         d+whxgDtcMDh4ez3whXB1hR0OBgv66vZAQqOy3m8XXkACRRZH5imZ4DG6DJe9abhZENY
         J9ng==
X-Gm-Message-State: ACrzQf3zG/OyIynEQetMv0UertF1DGPK5EVA8OOIPsjo107d3jIIwWJT
        kae2D3i1p5JKs09b6fgDfBE0ZUlE/CALqM10qVa3iUqAVu51LnuHz46V47h8oIovq/BcDxJEgeo
        GsUmAjJG6YzhsNFZ5
X-Received: by 2002:a05:600c:4e0f:b0:3b4:88bb:19cb with SMTP id b15-20020a05600c4e0f00b003b488bb19cbmr14761900wmq.195.1664557450707;
        Fri, 30 Sep 2022 10:04:10 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7gGRckRIiUvZGUZw0pcRhk6aX8kWTYgjbAqZSHh9BXBslGqQQJqSP9YYh36qEDgzhksOEVIg==
X-Received: by 2002:a05:600c:4e0f:b0:3b4:88bb:19cb with SMTP id b15-20020a05600c4e0f00b003b488bb19cbmr14761889wmq.195.1664557450404;
        Fri, 30 Sep 2022 10:04:10 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id c3-20020a05600c0a4300b003b4fdbb6319sm8694093wmq.21.2022.09.30.10.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 10:04:09 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH 1/7] cpumask: fix checking valid cpu range
In-Reply-To: <YzRfD2aAID8DuHL1@yury-laptop>
References: <20220919210559.1509179-1-yury.norov@gmail.com>
 <20220919210559.1509179-2-yury.norov@gmail.com>
 <xhsmhbkqz4rqr.mognet@vschneid.remote.csb> <YzRfD2aAID8DuHL1@yury-laptop>
Date:   Fri, 30 Sep 2022 18:04:08 +0100
Message-ID: <xhsmhwn9k3ibb.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/09/22 07:49, Yury Norov wrote:
> On Wed, Sep 28, 2022 at 01:18:20PM +0100, Valentin Schneider wrote:
>> On 19/09/22 14:05, Yury Norov wrote:
>> > @@ -174,9 +174,8 @@ static inline unsigned int cpumask_last(const struct cpumask *srcp)
>> >  static inline
>> >  unsigned int cpumask_next(int n, const struct cpumask *srcp)
>> >  {
>> > -	/* -1 is a legal arg here. */
>> > -	if (n != -1)
>> > -		cpumask_check(n);
>> > +	/* n is a prior cpu */
>> > +	cpumask_check(n + 1);
>> >       return find_next_bit(cpumask_bits(srcp), nr_cpumask_bits, n + 1);
>>
>> I'm confused, this makes passing nr_cpu_ids-1 to cpumask_next*() trigger a
>> warning. The documentation does states:
>>
>> * @n: the cpu prior to the place to search (ie. return will be > @n)
>>
>> So n is a valid CPU number (with -1 being the exception for scan
>> initialization), this shouldn't exclude nr_cpu_ids-1.
>
> For a regular cpumask function, like cpumask_any_but(), the valid range is
> [0, nr_cpu_ids).
>
> 'Special' functions shift by 1 when call underlying find API:
>
>   static inline
>   unsigned int cpumask_next(int n, const struct cpumask *srcp)
>   {
>           /* n is a prior cpu */
>           cpumask_check(n + 1);
>           return find_next_bit(cpumask_bits(srcp), nr_cpumask_bits, n + 1);
>   }
>
> So, for them the valid range [0, nr_cpu_ids) must be shifted in other
> direction: [-1, nr_cpu_ids-1).
>

The way I've been seeing this is that the [0, nr_cpu_ids) range is extended
to [-1, nr_cpu_ids) to accommodate for iteration starts.

>> IMO passing nr_cpu_ids-1 should be treated the same as passing the
>> last set bit in a bitmap: no warning, and returns the bitmap
>> size.
>
> This is how cpumask_check() works for normal functions. For
> cpumask_next() passing nr_cpu_ids-1 is the same as passing nr_cpu_ids
> for cpumask_any_but(), and it should trigger warning in both cases.
> (Or should not, but it's a different story.)
>
>> calling code which seems like unnecessary boiler plate
>>
>> For instance, I trigger the cpumask_check() warning there:
>>
>> 3d2dcab932d0:block/blk-mq.c @l2047
>>         if (--hctx->next_cpu_batch <= 0) {
>> select_cpu:
>>                 next_cpu = cpumask_next_and(next_cpu, hctx->cpumask, <-----
>>                                 cpu_online_mask);
>>                 if (next_cpu >= nr_cpu_ids)
>>                         next_cpu = blk_mq_first_mapped_cpu(hctx);
>>                 hctx->next_cpu_batch = BLK_MQ_CPU_WORK_BATCH;
>>         }
>>
>> next_cpu is a valid CPU number, shifting it doesn't seem to make sense, and
>> we do want it to reach nr_cpu_ids-1.
>
> next_cpu is a valid CPU number for all, but not for cpumask_next().
> The warning is valid. If we are at the very last cpu, what for we look
> for next?
>

Consider:

  nr_cpu_ids=4

  A)
  cpumask: 0.1.1.0
  CPU      0 1 2 3
  n            ^
  result: nr_cpu_ids

  B)
  cpumask: 0.0.1.1
  CPU      0 1 2 3
  n              ^
  result: nr_cpu_ids + WARN

Both scenarios are identical from a user perspective: a valid CPU number
was passed in (either from smp_processor_id() or from a previous call to
cpumask_next*()), but there are no more bits set in the cpumask. There's no
more CPUs to search for in both scenarios, but only one produces as WARN.

> The snippet above should be fixed like this:
>
>           if (--hctx->next_cpu_batch <= 0) {
>   select_cpu:
>                   if (next_cpu == nr_cpu_ids - 1)
>                           next_cpu = nr_cpu_ids;
>                   else
>                           next_cpu = cpumask_next_and(next_cpu,
>                                                       hctx->cpumask,
>                                                       cpu_online_mask);
>                   if (next_cpu >= nr_cpu_ids)
>                           next_cpu = blk_mq_first_mapped_cpu(hctx);
>                   hctx->next_cpu_batch = BLK_MQ_CPU_WORK_BATCH;
>           }
>
> The original motivation for this special shifted semantics was to
> avoid passing '+1' in cpumask_next() everywhere where it's used to
> iterate over cpumask. This is especially ugly because it brings negative
> semantics in such a simple thing like an index, and makes people confused.
> It was a bad decision, but now it's so broadly used that we have to live
> with it.
>
> The strategy to mitigate this is to minimize using of that 'special'
> functions. They all are cpumask_next()-like. In this series I reworked
> for_each_cpu() to not use cpumask_next().
>
> Often, cpumask_next() is a part of opencoded for_each_cpu(), and this
> is relatively easy to fix. In case of blk_mq_hctx_next_cpu() that you
> mentioned above, cpumask_next_and() usage looks unavoidable, and
> there's nothing to do with that, except that being careful.
>
> It didn't trigger the warning in my test setup, so I didn't fix it.
> Feel free to submit a patch, if you observe the warning for yourself.
>
> Maybe we should consider nr_cpu_ids as a special valid index for
> cpumask_check(), a sign of the end of an array. This would help to
> silence many warnings, like this one. For now I'm leaning towards that
> it's more a hack than a meaningful change.
>

I agree, we definitely want to warn for e.g.

  cpumask_set_cpu(nr_cpu_ids, ...);

Could we instead make cpumask_next*() immediately return nr_cpu_ids when
passed n=nr_cpu_ids-1?

Also, what about cpumask_next_wrap()? That uses cpumask_next() under the
hood and is bound to warn when wrapping after n=nr_cpu_ids-1, I think.


> Thanks,
> Yury

