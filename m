Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307D85A1D00
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 01:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243854AbiHYXRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 19:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236827AbiHYXR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 19:17:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFC8B442E
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 16:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661469447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K6IqYdtlgkGTFXh/CrtZFmNhEM6cVjYadyTzynsMreE=;
        b=P3Z1uV/kXxO9dAn+59R0n+ShXIS5tK6PNsHxF/f2zHRwntAJeH5fClLZJOrxpIK+zWv46/
        cuDRH1L5I1MXzlZlSJkfwrqm0ykXxyT/YdiA3alMXx3LXXMRSvtmTbZuBxFUKgMINyVF8/
        oyQEXLMwTDL8HuMCXpMGACnYNQQhT64=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-152-Awb_4zvWOxCXAmRG3LtWMg-1; Thu, 25 Aug 2022 19:17:22 -0400
X-MC-Unique: Awb_4zvWOxCXAmRG3LtWMg-1
Received: by mail-wm1-f72.google.com with SMTP id c64-20020a1c3543000000b003a61987ffb3so20500wma.6
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 16:17:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=K6IqYdtlgkGTFXh/CrtZFmNhEM6cVjYadyTzynsMreE=;
        b=zusE3DzYblHP7SG3oFHy2naMMHpBkCkTVkjhIesRnxSS989NFawLSHCA01l7yekgG7
         y30o+InCxWFWM7fjcv24zJsHlOP/sOF5XwHivW+sQB00GmrybGmzJ9fzccc46dW5ySnk
         h8nbEynnoAAx2IBWQL/YumaM0+exxc7KfSroo3zojcfuFbovyLFJsqCMtM3zGIfg2s8B
         0JziQsWy5x0EBkltVHu1k2Gf59yJyeMvMX5JSpRW0gYrgMt0xD31Vuru7cBS4FhckrpH
         ALTdWnOMx7C1MvN3W1DRoFh1XNKG1oIw+Z9RmefvMTomlXSbYOnV3VwfPRqg2k/qertc
         +GmA==
X-Gm-Message-State: ACgBeo3d6qRwKlNGAqOO9bITMll2eMXGAD5kNK8DBCdMpJaBKSx56Z3R
        0af4VW6E7p5wYFzGcf6ltKqvW3kGN4b6BhisIRUqGtN5GVlxtVzAEdEy8zT65f8xmLqInow1GfD
        xl9hRtVNrywPOzcQT
X-Received: by 2002:a5d:5985:0:b0:222:c5dd:b7c8 with SMTP id n5-20020a5d5985000000b00222c5ddb7c8mr3504030wri.511.1661469441463;
        Thu, 25 Aug 2022 16:17:21 -0700 (PDT)
X-Google-Smtp-Source: AA6agR69aRJWSvroO1rYxs4Q8ah8RPjKum/nyjTtNH7rEv6bS/g//UO1WyhZxD9GFFORywOnXyXxYw==
X-Received: by 2002:a5d:5985:0:b0:222:c5dd:b7c8 with SMTP id n5-20020a5d5985000000b00222c5ddb7c8mr3503998wri.511.1661469441183;
        Thu, 25 Aug 2022 16:17:21 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id m5-20020a05600c4f4500b003a64f684704sm7526156wmq.40.2022.08.25.16.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 16:17:20 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v3 3/9] bitops: Introduce find_next_andnot_bit()
In-Reply-To: <YwfkDBl6DD+9Zjmk@yury-laptop>
References: <20220825181210.284283-1-vschneid@redhat.com>
 <20220825181210.284283-4-vschneid@redhat.com>
 <YwfkDBl6DD+9Zjmk@yury-laptop>
Date:   Fri, 26 Aug 2022 00:17:19 +0100
Message-ID: <xhsmhpmgngbgg.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/08/22 14:05, Yury Norov wrote:
> On Thu, Aug 25, 2022 at 07:12:04PM +0100, Valentin Schneider wrote:
>> In preparation of introducing for_each_cpu_andnot(), add a variant of
>> find_next_bit() that negate the bits in @addr2 when ANDing them with the
>> bits in @addr1.
>>
>> Note that the _find_next_bit() @invert argument now gets split into two:
>> @invert1 for words in @addr1, @invert2 for words in @addr2. The only
>> current users of _find_next_bit() with @invert set are:
>>   o find_next_zero_bit()
>>   o find_next_zero_bit_le()
>> and neither of these pass an @addr2, so the conversion is straightforward.
>>
>> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
>
> Have you seen this series?
> https://lore.kernel.org/lkml/YwaXvphVpy5A7fSs@yury-laptop/t/
>
> It will significantly simplify your work for adding the
> find_next_andnot_bit(). If you wait a week or so, you'll most likely
> find it in -next.
>

I hadn't seen it, it does look promising. I'm about to disappear for a
week, so I'll have a look once I'm back.

> Thanks,
> Yury

