Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB926338A6
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:37:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbiKVJhV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 22 Nov 2022 04:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbiKVJhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:37:15 -0500
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D64B4E435
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 01:37:14 -0800 (PST)
Received: by mail-qv1-f53.google.com with SMTP id c8so9715156qvn.10
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 01:37:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0qbQIDMT0mVQK2fDYDatBMKVgp9C8v9nTt52ud61lvU=;
        b=Wb29EbGHurHbp526JmmjF+sFhrMoTCVi7aUkYF5Wj78Ud/cPxIWCN00s1J6BCOTHfv
         Co01XiDIDplvQAxWUmhvQTqLD9LKp33deR8RFpYYIMSTtCMb3LFsBcizDKiav2eBdS+c
         aqgfrOzmUiiHDC+35obksXCWgQPe0a/yOXr/S/s4+gJlIIesxMKofsPvg478qAPVJIFT
         QW67rnpbvlM4qNJCneqY9zu4XhnRXPjzeX1G6i7Kc+peKGrjY4fD6B0vcWxBB0rCEr52
         YX5D85G2bY1BcHqTn8dIkyPK8WdBD6wBmK51nsyjTuzDqAOU23b32JDPTUltkjdn29Hm
         cVQA==
X-Gm-Message-State: ANoB5plaO1poHLqMSwjn35Pgv1WkLMkdK5ybB/cSz9PLEoQFv+qfFsd3
        kvQ6rv7NvC3e5bVuUDfkWwJHQrkGPU+M5w==
X-Google-Smtp-Source: AA0mqf6iRTuaeADgwb5wac/r7lwdGqvLe5g4+Hm05kGenuLlvn3qo835bTTzlb6Cs858EuE8KND4HA==
X-Received: by 2002:a05:6214:590e:b0:4c6:aaeb:6384 with SMTP id lp14-20020a056214590e00b004c6aaeb6384mr2911783qvb.41.1669109833445;
        Tue, 22 Nov 2022 01:37:13 -0800 (PST)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com. [209.85.219.175])
        by smtp.gmail.com with ESMTPSA id j12-20020a05620a410c00b006eef13ef4c8sm10129804qko.94.2022.11.22.01.37.11
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 01:37:12 -0800 (PST)
Received: by mail-yb1-f175.google.com with SMTP id 7so16643831ybp.13
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 01:37:11 -0800 (PST)
X-Received: by 2002:a25:bcc6:0:b0:6dd:1c5c:5602 with SMTP id
 l6-20020a25bcc6000000b006dd1c5c5602mr21891954ybm.36.1669109831615; Tue, 22
 Nov 2022 01:37:11 -0800 (PST)
MIME-Version: 1.0
References: <20221122093131.161499-1-saeed@kernel.org>
In-Reply-To: <20221122093131.161499-1-saeed@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 22 Nov 2022 10:37:00 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVQAkPhtEdq=-kwQE8v2sgyCx_bD-f2yk95Fc7t4Fz56w@mail.gmail.com>
Message-ID: <CAMuHMdVQAkPhtEdq=-kwQE8v2sgyCx_bD-f2yk95Fc7t4Fz56w@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: Fix build break when CONFIG_IPV6=n
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jamie Bainbridge <jamie.bainbridge@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saeed,

On Tue, Nov 22, 2022 at 10:31 AM Saeed Mahameed <saeed@kernel.org> wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
>
> The cited commit caused the following build break when CONFIG_IPV6 was
> disabled
>
> net/ipv4/tcp_input.c: In function ‘tcp_syn_flood_action’:
> include/net/sock.h:387:37: error: ‘const struct sock_common’ has no member named ‘skc_v6_rcv_saddr’; did you mean ‘skc_rcv_saddr’?
>
> Fix by using inet6_rcv_saddr() macro which handles this situation
> nicely.
>
> Fixes: d9282e48c608 ("tcp: Add listening address to SYN flood message")
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

Thanks for your patch!

> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -6843,9 +6843,9 @@ static bool tcp_syn_flood_action(const struct sock *sk, const char *proto)
>
>         if (!READ_ONCE(queue->synflood_warned) && syncookies != 2 &&
>             xchg(&queue->synflood_warned, 1) == 0) {
> -               if (IS_ENABLED(CONFIG_IPV6) && sk->sk_family == AF_INET6) {
> +               if (sk->sk_family == AF_INET6) {

I think the IS_ENABLED() should stay, to make sure the IPV6-only
code is optimized away when IPv6-support is disabled.

>                         net_info_ratelimited("%s: Possible SYN flooding on port [%pI6c]:%u. %s.\n",
> -                                       proto, &sk->sk_v6_rcv_saddr,
> +                                       proto, inet6_rcv_saddr(sk),
>                                         sk->sk_num, msg);
>                 } else {
>                         net_info_ratelimited("%s: Possible SYN flooding on port %pI4:%u. %s.\n",

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
