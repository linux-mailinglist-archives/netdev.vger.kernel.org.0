Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5900F58EAA5
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 12:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbiHJKrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 06:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiHJKrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 06:47:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2475585FAF
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 03:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660128433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9Ud5THdRZx+DzHutMKaoYIXEZbuC6w4neUVkJCUZaOE=;
        b=P+cos2TuIcC+eLN9yR4D9C7AEYuf+WyJYj3eukrS2JN4xSOxTENm2+HCkXc9DCbZgbT2lx
        bkUq8Vab1b2MpzTQp62hRZ8zihYdZ9gULroAhtjWBoAR1XZhyumto/EcUbsA159j2D23cv
        9/7NXlJ8NzzkEUyTgW7XLuJM8Vrzmes=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-57-mjzFZjSqO9akRKnJYx1XSA-1; Wed, 10 Aug 2022 06:47:13 -0400
X-MC-Unique: mjzFZjSqO9akRKnJYx1XSA-1
Received: by mail-wm1-f69.google.com with SMTP id i65-20020a1c3b44000000b003a537031613so923236wma.2
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 03:47:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc;
        bh=9Ud5THdRZx+DzHutMKaoYIXEZbuC6w4neUVkJCUZaOE=;
        b=iwvE9xI9uxyBs7AtRW8ovi4T8sYbfrC6JPN+HHgipd3LIYkvEpwQBqGNbkLzcsV7C8
         AREqou93R0la8RQf544hKR6DZmvK7FhuITQuXm8n2c71cf1PIutLTpORVuuSXJ2Rt+f2
         7agYYpSsS7ccgjCzHA3YL4yzWNkwge6IBo5ud0EIr7aSLkWn4TkluIhUwoFZr6ecjOAi
         /WyaJNrGyXGyxBN6+L52ahZeeRn9ZcKAiIVLZdgoQtZZNio2UYzf8eswmej6AwDkMFzh
         Be0U92qD/t+9KNBCasqMbIcMGv2futy7meNywrx+NzYnsaJ6VTUgSAI9W+J8h1RvdNGS
         F8sA==
X-Gm-Message-State: ACgBeo2kmR93cpuEg7jblxZPYbacnY1ZxQwuKffFm16Son9ZQG5IUN2k
        Jja7LO0tjuXCYg+xBkKnF7r2npR0925psJ5ZuuFCBdCrSeX5qlPKAeRF3HhF5CbMe2Q4lqSQRXI
        3M0vlfjdP+GsBF7hN
X-Received: by 2002:a05:600c:1c28:b0:3a5:3e18:3e with SMTP id j40-20020a05600c1c2800b003a53e18003emr1926994wms.203.1660128421602;
        Wed, 10 Aug 2022 03:47:01 -0700 (PDT)
X-Google-Smtp-Source: AA6agR62z423Q+I+006MlzeOahUfxefXQfCzkJwgUC6gw8/s7Y3h0/dCRmZjcUjU/NrOUYHczCYeHw==
X-Received: by 2002:a05:600c:1c28:b0:3a5:3e18:3e with SMTP id j40-20020a05600c1c2800b003a53e18003emr1926981wms.203.1660128421342;
        Wed, 10 Aug 2022 03:47:01 -0700 (PDT)
Received: from vschneid.remote.csb ([185.11.37.247])
        by smtp.gmail.com with ESMTPSA id i1-20020a5d4381000000b0021e9396b135sm15686904wrq.37.2022.08.10.03.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 03:47:00 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Gal Pressman <gal@nvidia.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next V4 1/3] sched/topology: Add NUMA-based CPUs
 spread API
In-Reply-To: <xhsmhwnbhb9ok.mognet@vschneid.remote.csb>
References: <20220728191203.4055-1-tariqt@nvidia.com>
 <20220728191203.4055-2-tariqt@nvidia.com>
 <xhsmhedxvdikz.mognet@vschneid.remote.csb>
 <df8b684d-ede6-7412-423d-51d57365e065@gmail.com>
 <xhsmh35e5d9b4.mognet@vschneid.remote.csb>
 <12fd25f9-96fb-d0e0-14ec-3f08c01a5a4b@gmail.com>
 <xhsmhzggdbmv6.mognet@vschneid.remote.csb>
 <69829c71-d51c-b25f-2d74-5fdd231ed9e4@gmail.com>
 <xhsmhwnbhb9ok.mognet@vschneid.remote.csb>
Date:   Wed, 10 Aug 2022 11:46:59 +0100
Message-ID: <xhsmhtu6kbckc.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/08/22 18:36, Valentin Schneider wrote:
> On 09/08/22 17:04, Tariq Toukan wrote:
>> LGTM.
>> How do you suggest to proceed?
>> You want to formalize it? Or should I take it from here?
>>
>
> I need to have a think (feel free to ponder and share your thoughts as
> well) - I'm happy to push something if I get a brain-wave, but don't let
> that hold you back either.

This is the form that I hate the least, what do you think?

