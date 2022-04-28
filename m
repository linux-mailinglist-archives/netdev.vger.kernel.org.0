Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01EB5134FD
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 15:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235715AbiD1NZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 09:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235677AbiD1NZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 09:25:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7B32FAC90C
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 06:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651152130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1cpZ1xgascUOYLsGfspUdEEjFzPcacJad6qU8kZAaSk=;
        b=brGjntIC47r1V/XHG/aVvgms2bhLVyFKPPi9dTCazEo4K92om6js6mD0iNlyGa2nyvEjFc
        dpk2JBImwUMlnA/CLwQm6p9JJCCXRF3TriUr7YBjsQ1k2/SkV2eCi3/J+D45pstNfP3ve9
        n5gD/zRF4KpJwmcPKowd5C3wOipyIQY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-SAy2ACDkPN6gODH8Bmechg-1; Thu, 28 Apr 2022 09:22:09 -0400
X-MC-Unique: SAy2ACDkPN6gODH8Bmechg-1
Received: by mail-ej1-f72.google.com with SMTP id dp12-20020a170906c14c00b006e7e8234ae2so3005937ejc.2
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 06:22:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=1cpZ1xgascUOYLsGfspUdEEjFzPcacJad6qU8kZAaSk=;
        b=3Lw3tHNDn8ZsylWwodpAGsROm59KytEM9C7plL5N6ppo8NorAHXl6Egw/8kGqccvi8
         /joCowq4HIM/P8xDJ/NbJ51R3IWGetRLSLlH5s4FwWPvRdJqp6W3HHZw+RMMBa5XElqW
         C97lRhubXXQ5ef78Y6q6fFdREiFbFAmyZPkT01YIH4dqxcwRx5Q3UAVuJRR03gunmq94
         F3lzZodKYxztu4KuspKNbG/xjc7fB6H+ELRuIkLYPEul2GGhThI3kRoLfIyX5K6A5e3g
         lKkcU0eicF+OhH5TBZmOK634uOTYLLnF8A3c7V0jb93e12f0X/2T7S7YgPf7RZZeXFoD
         WKzA==
X-Gm-Message-State: AOAM532XeRPZHgnjW26niELZxgQB0e3nxwWcKTdVySVqradbiugeZqXh
        vGq0JnUwU5perSfzWLSg9cYGq/+c/95Pm8HhJ1rPvLNfZhQCtbFNpotclh2yLqacCN8wG0rvpEe
        1fAK6XNpPPouQAcy0
X-Received: by 2002:a17:907:7287:b0:6f3:8414:74f1 with SMTP id dt7-20020a170907728700b006f3841474f1mr23685455ejc.123.1651152127088;
        Thu, 28 Apr 2022 06:22:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGk1cJw5aGoIsTO0w7oT+T4JksqnriBA4J7QNSfj97lfUvKKiqr6njoNbuZoBq+Nes7aHiKw==
X-Received: by 2002:a17:907:7287:b0:6f3:8414:74f1 with SMTP id dt7-20020a170907728700b006f3841474f1mr23685372ejc.123.1651152126157;
        Thu, 28 Apr 2022 06:22:06 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id lz12-20020a170906fb0c00b006f3a36a9807sm5210784ejb.19.2022.04.28.06.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 06:22:05 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C131D2F596C; Thu, 28 Apr 2022 15:22:04 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     menglong8.dong@gmail.com, edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, benbjiang@tencent.com, flyingpeng@tencent.com,
        imagedong@tencent.com, kafai@fb.com, talalahmad@google.com,
        keescook@chromium.org, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] net: tcp: add skb drop reasons to
 route_req()
In-Reply-To: <20220428073340.224391-3-imagedong@tencent.com>
References: <20220428073340.224391-1-imagedong@tencent.com>
 <20220428073340.224391-3-imagedong@tencent.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 28 Apr 2022 15:22:04 +0200
Message-ID: <87fslxgx6r.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

menglong8.dong@gmail.com writes:

> From: Menglong Dong <imagedong@tencent.com>
>
> Add skb drop reasons to the route_req() in struct tcp_request_sock_ops.
> Following functions are involved:
>
>   tcp_v4_route_req()
>   tcp_v6_route_req()
>   subflow_v4_route_req()
>   subflow_v6_route_req()
>
> And the new reason SKB_DROP_REASON_SECURITY is added, which is used when
> skb is dropped by LSM.

Could we maybe pick a slightly less generic name? If I saw
"SKB_DROP_REASON_SECURITY" my first thought would be something related
to *network* security, like a firewall. Maybe just SKB_DROP_REASON_LSM?

-Toke

