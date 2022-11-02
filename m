Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5146163D8
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 14:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbiKBNay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 09:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbiKBNax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 09:30:53 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210402A956
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 06:30:53 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id n191so14968570iod.13
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 06:30:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=docker.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jzaJHFBthKI+N9jxIZGxCYyCJNLPmN4e+ahut/KLlwU=;
        b=Z1G3Uu9Lq7rVn008/R7qQNc36TD/itgKx7kUwlTZfUo5IN+FIIlbjt8ZQMasFfxQv/
         7ZcXjtTGfguGBZMZeloCNGhQZobrVDESsgnp74DwVEsgMpre+qssJTKu7jorrORpLVug
         vPsZJ3ucMyUTwOVQQIj5hVtyx8plTk1vOS82g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jzaJHFBthKI+N9jxIZGxCYyCJNLPmN4e+ahut/KLlwU=;
        b=yO7o+sUyZOguPJVsCfwqIiCAggxcrM/V8umOshttbfe0oX5TaUxA6ykG2g++V+DbYM
         EfpVsR0yMvhGvb8+2nQ60y8UF4Wy8dETCtWmIhoVAtzHWvNcALQl7+Q+G6a0gmPwlUqR
         tpxNLWaONkQYAG3BmVl0Nf6lBTgj0LJfgShedJhyIItXWjFa2a2u8Jn3LlA55RCwbAuh
         hBnBacYPZj4L6YqTaPWuO/R2iE4pfbkGMfx3ZZ5Z6CW87uGatJ3/32HT6LvZa0BJgRAP
         va5Ixe8EE7KA15eIgOMChuLAmbkQvR+EWoTGb2Hn36mvczFUgNBJvkpLpYcUWhl3o2ky
         NBkQ==
X-Gm-Message-State: ACrzQf1fjgJADt7nFUV5bXg5KxyirKbOlXINS1rAGpe5febX0COG5Kz9
        C2WJpzt8n9LUhlSMVfznVmh7AUlYwCwAJTRN65RgiA==
X-Google-Smtp-Source: AMsMyM4VY9g5n2ABc5ygSVSDsCFRasTDP+7DPN2cQU3wN0pNpeoFN4/+EvRJlj9i89lTtEQDqsiHOyx4b96d25H0VPQ=
X-Received: by 2002:a6b:ba83:0:b0:6d3:e190:5abd with SMTP id
 k125-20020a6bba83000000b006d3e1905abdmr4589591iof.188.1667395852513; Wed, 02
 Nov 2022 06:30:52 -0700 (PDT)
MIME-Version: 1.0
References: <20221101021706.26152-1-decui@microsoft.com> <20221101021706.26152-3-decui@microsoft.com>
 <20221102093137.2il5u7opfyddheis@sgarzare-redhat> <20221102094224.2n2p6cakjtd4n2yf@sgarzare-redhat>
In-Reply-To: <20221102094224.2n2p6cakjtd4n2yf@sgarzare-redhat>
From:   Frederic Dalleau <frederic.dalleau@docker.com>
Date:   Wed, 2 Nov 2022 14:30:41 +0100
Message-ID: <CANWeT6gCfXbGVVySyiG9oQi9EXS2U5aEdN38z9qz1u91vCetyg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] vsock: fix possible infinite sleep in vsock_connectible_wait_data()
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Dexuan Cui <decui@microsoft.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        arseny.krasnov@kaspersky.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        wei.liu@kernel.org, linux-hyperv@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dexuan, Stefano,

Tested-by: Fr=C3=A9d=C3=A9ric Dalleau <frederic.dalleau@docker.com>

Regards,
Fr=C3=A9d=C3=A9ric


On Wed, Nov 2, 2022 at 10:42 AM Stefano Garzarella <sgarzare@redhat.com> wr=
ote:
>
> On Wed, Nov 02, 2022 at 10:31:37AM +0100, Stefano Garzarella wrote:
> >On Mon, Oct 31, 2022 at 07:17:06PM -0700, Dexuan Cui wrote:
> >>Currently vsock_connectible_has_data() may miss a wakeup operation
> >>between vsock_connectible_has_data() =3D=3D 0 and the prepare_to_wait()=
.
> >>
> >>Fix the race by adding the process to the wait queue before checking
> >>vsock_connectible_has_data().
> >>
> >>Fixes: b3f7fd54881b ("af_vsock: separate wait data loop")
> >>Signed-off-by: Dexuan Cui <decui@microsoft.com>
> >>---
> >>
> >>Changes in v2 (Thanks Stefano!):
> >> Fixed a typo in the commit message.
> >> Removed the unnecessary finish_wait() at the end of the loop.
> >
> >LGTM:
> >
> >Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> >
>
> And I would add
>
> Reported-by: Fr=C3=A9d=C3=A9ric Dalleau <frederic.dalleau@docker.com>
>
> Since Fr=C3=A9d=C3=A9ric posted a similar patch some months ago (I lost i=
t because
> netdev and I were not in cc):
> https://lore.kernel.org/virtualization/20220824074251.2336997-2-frederic.=
dalleau@docker.com/
>
> Thanks,
> Stefano
>
