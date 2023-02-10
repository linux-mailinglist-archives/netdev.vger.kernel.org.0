Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D53269208F
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 15:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbjBJOM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 09:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbjBJOM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 09:12:28 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F536A6D
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 06:12:26 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id hn2-20020a05600ca38200b003dc5cb96d46so6364486wmb.4
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 06:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T0jFRB5FORMclI7B1g75aEhivXY3sIefLYAB2LmkOwQ=;
        b=beY4ky4AdP0FKQJ4uaQdDpFn/sgEUngxk4wRfLfjCfEkT7tdHEFx0gik0HhZdHzzPd
         02sm+IZ06KJ1+96Hq6Cex4D7xRvBcCasO+1ldPpDJVPcopD5dhiTfS/5XEUB8cvgHezj
         P0+j17pwXhpLazcprNaAIsPdB7YlGfEqIapmPdMXMmEMTUVR0GEYKKm19aXHOmBmDrHT
         bSJU9VOBsII5dOgtDeqYtO16LULqtV9vQOpzq06ha30RO1iYrviq9NnSo+x9WpGOR+hy
         Vr7Py1qsRJ4HKkzELCNYKqyYocFyX9oxB7kWAtzp3bdU+Qg6LqTbPXK4DEMKIb8O/yEn
         IIjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T0jFRB5FORMclI7B1g75aEhivXY3sIefLYAB2LmkOwQ=;
        b=nvulg1Rw1EsQd1lZOHHhYLkA81n+nPn3MyLZN+hz0KHqYqvG7jKaRq3h1bWzmPvy91
         K6IbGZxHBl/2SCRNXdfWySCNQIQOZMNPUP4DfJPmY8iV0jastWxePH5dOSVjkP/7enhq
         hps89sm0UjFlOV3sXPQWtaH0nh5rPkMSVEsM3JIfqxOxUtMOOaUcLBNy2spbH6fMsY/T
         ZXdx4r+o1SrDe35pVrdJ3vHuIItyGwGVFUl74Qt15NA0Gu3tTgW9hK2x6GtQ3rTES8bc
         X9x2AB/7TjkfWzQ5l55KmOXQVLxk6ZNZ83H4v/zqubuKxoB+QcRffTXZ9FAuyp5BP5I2
         RRZA==
X-Gm-Message-State: AO0yUKUp2/Ec8bQKovk42ovovHHv1aB31XJgTLtosppx+6Ft8/RZnwY/
        sVPvvq0dGN5uvZN2lonOUhNocYx+LuvksdwElL8fhlIU1oUiZKEU
X-Google-Smtp-Source: AK7set//dvyVj6HcCQhtXTagYmZik6z7uqXA3Wt/EvJF2hTc3e0WhyfBhCDPTFIlCyuPLxA45K7nc9uAj5q6Zmevs3Y=
X-Received: by 2002:a1c:7501:0:b0:3da:ed8:43ba with SMTP id
 o1-20020a1c7501000000b003da0ed843bamr974190wmc.145.1676038345356; Fri, 10 Feb
 2023 06:12:25 -0800 (PST)
MIME-Version: 1.0
References: <20230210002202.81442-1-kuniyu@amazon.com> <20230210002202.81442-2-kuniyu@amazon.com>
In-Reply-To: <20230210002202.81442-2-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 10 Feb 2023 15:12:13 +0100
Message-ID: <CANn89iLYARLgLrwAMFEHr7g9M1GE7JUfi8OR0yowfwGBqZXtKg@mail.gmail.com>
Subject: Re: [PATCH v3 net 1/2] dccp/tcp: Avoid negative sk_forward_alloc by ipv6_pinfo.pktoptions.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        Andrii <tulup@mail.ru>,
        Arnaldo Carvalho de Melo <acme@mandriva.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 10, 2023 at 1:22 AM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> Eric Dumazet pointed out [0] that when we call skb_set_owner_r()
> for ipv6_pinfo.pktoptions, sk_rmem_schedule() has not been called,
> resulting in a negative sk_forward_alloc.
>
> We add a new helper which clones a skb and sets its owner only
> when sk_rmem_schedule() succeeds.
>
> Note that we move skb_set_owner_r() forward in (dccp|tcp)_v6_do_rcv()
> because tcp_send_synack() can make sk_forward_alloc negative before
> ipv6_opt_accepted() in the crossed SYN-ACK or self-connect() cases.
>
> [0]: https://lore.kernel.org/netdev/CANn89iK9oc20Jdi_41jb9URdF210r7d1Y-+uypbMSbOfY6jqrg@mail.gmail.com/
>
> Fixes: 323fbd0edf3f ("net: dccp: Add handling of IPV6_PKTOPTIONS to dccp_v6_do_rcv()")
> Fixes: 3df80d9320bc ("[DCCP]: Introduce DCCPv6")
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>


Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !
