Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68CC6B7E24
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 17:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbjCMQwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 12:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjCMQwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 12:52:23 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC963769D
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 09:51:51 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-541a05e4124so65759827b3.1
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 09:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678726311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KZ05Z67fmkeCIKN3rlGn8s6ITfRrSiu2jOUyiAMkfsI=;
        b=e0afJLHUAo9zc1qU6RM2W6pR23dnpzrc9FFdh3E34g+t7L1p9uzVurHddguodajSjO
         l1vYUOtKTd3VYkINB/h6ZMUUnMMW/Nnej42pSlpm+MNklBe09vIQKc3OwGVYOIv/pdl3
         XiWTFERJfgNUfWnSm6Zd50EpQY9Inf022Z0VDDdOFhfoykGxJhFfi6BZBqmuv9SrB/85
         q5rEPHKwm5DnWn19rKcTt1ayqNDWgnE7s+k6PKJjguKNxMIir7Bq9ZjWWbI+eogUwMwh
         d+qzpOw2bPuxvNjGkXR49W/qhva4SdiC4jmRxR0xc/DVb5feUzJwyxB8qz4HITGK7cU8
         lW+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678726311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KZ05Z67fmkeCIKN3rlGn8s6ITfRrSiu2jOUyiAMkfsI=;
        b=eVrw+K1iCDS04RB1XXFzzFDxDhd60w3NuU5n27/9leaJif3hw5T5PxlL/18iN6YZht
         bYSDFZj00/uXvsOyQ+z73Dvoe28X0bt+4s9SA6TUYSiFZQSg5R8aGDugt04xVsB9cCHK
         gvLLOINRG98p04zRSLfSwPl/AxkAiLtB4bASLibKa7AZR5qW5+NK0y91YGDJkrVLynOG
         s7C0J9qmNJjeCQAj+lHMJefftcoowsEV1tF4bI6vzHTkyKNpMw6wvaoe3ci6kbFRAQOc
         HeG7SfSqG1fCX3g1BU4GZq64D1BJdEN8p2Ya0I87o9NPa1mWJX2ipS7WMTWWGtkoz4Re
         5itg==
X-Gm-Message-State: AO0yUKUdCz1lIvkNq7P16tho5/QriBCemkpw5asml1WSGET9iw62R4PT
        Oc2WnSq09uQsHW3lKrOGISaK8r8D7IE9rhGJfcxDqw==
X-Google-Smtp-Source: AK7set+tp9t9wsLUMP6VoJYyrtoWRA0Md183jAXL9mKimO4GfbxxA8nQLNGIbkZnfWsdV5u5WHhul7aFx/n+hnSAz14=
X-Received: by 2002:a81:a9c8:0:b0:533:9c5b:7278 with SMTP id
 g191-20020a81a9c8000000b005339c5b7278mr22629557ywh.0.1678726310872; Mon, 13
 Mar 2023 09:51:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230313162520.GA17199@debian> <20230313164541.GA17394@debian>
In-Reply-To: <20230313164541.GA17394@debian>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 13 Mar 2023 09:51:39 -0700
Message-ID: <CANn89i+a-d6e3_6PpKckC149_O87GWeUAhe6ztOh62b1fcvBbw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] gro: optimise redundant parsing of packets
To:     Richard Gobert <richardbgobert@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        dsahern@kernel.org, alexanderduyck@fb.com, lucien.xin@gmail.com,
        lixiaoyan@google.com, iwienand@redhat.com, leon@kernel.org,
        ye.xingchen@zte.com.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 9:46=E2=80=AFAM Richard Gobert <richardbgobert@gmai=
l.com> wrote:
>
> Currently the IPv6 extension headers are parsed twice: first in
> ipv6_gro_receive, and then again in ipv6_gro_complete.
>
> By using the new ->transport_proto field, and also storing the size of th=
e
> network header, we can avoid parsing extension headers a second time in
> ipv6_gro_complete (which saves multiple memory dereferences and condition=
al
> checks inside ipv6_exthdrs_len for a varying amount of extension headers =
in
> IPv6 packets).
>
> The implementation had to handle both inner and outer layers in case of
> encapsulation (as they can't use the same field). I've applied a similar
> optimisation to Ethernet.
>
> Performance tests for TCP stream over IPv6 with a varying amount of
> extension headers demonstrate throughput improvement of ~0.7%.
>
> In addition, I fixed a potential future problem:

I would remove all this block.

We fix current problems, not future hypothetical ones.

>  - The call to skb_set_inner_network_header at the beginning of
>    ipv6_gro_complete calculates inner_network_header based on skb->data b=
y
>    calling skb_set_inner_network_header, and setting it to point to the
>    beginning of the ip header.
>  - If a packet is going to be handled by BIG TCP, the following code bloc=
k
>    is going to shift the packet header, and skb->data is going to be
>    changed as well.
>
> When the two flows are combined, inner_network_header will point to the
> wrong place - which might happen if encapsulation of BIG TCP will be
> supported in the future.
>
> The fix is to place the whole encapsulation branch after the BIG TCP code
> block. This way, if encapsulation of BIG TCP will be supported,
> inner_network_header will still be calculated with the correct value of
> skb->data.

We do not support encapsulated BIG TCP yet.
We will do this later, and whoever does it will make sure to also support G=
RO.

> Also, by arranging the code that way, the optimisation does not
> add an additional branch.
>
> Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
> ---
>

Can you give us a good explanation of why extension headers are used exactl=
y ?

I am not sure we want to add code to GRO for something that 99.99% of
us do not use.
