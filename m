Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFFD554D6F5
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 03:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244771AbiFPBVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 21:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345137AbiFPBVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 21:21:20 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C2057166
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 18:21:19 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id s1so6798ilj.0
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 18:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K/IEp3+WcFKtUmIVxfawdKnimqQ8Um/PGbWV2acgES0=;
        b=mBMruH0/B9EAxM7gpQr7gxQzvo3D9N7tqsfa4fhMvWA6yNqN7asaMeQ1YSz7Q1TZcq
         s2d+jy+QefAiUhcBnnR4w5lO+a1GawEyPmWooAbQeVciahak2UIDPw7zhAWliwhHkY4p
         iLk1dd+IJtNlCpPtTf+cK7TqiEvO1043HCh8zvCq9fqWlCv4zsRKOPIjJVYHj86gbm9Z
         c/IXLYSYMF7LG912rGL2DAZU/6TkuCaYVC2ushIelvAsk+trM7qUv5bSmpU6s2CZqhuD
         zxvejcRAwZ3pnwoRGYofsU509hKHe3weH8ESkVrKqt/MikixaOyo7OtEQRMuooUmgm73
         1KzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K/IEp3+WcFKtUmIVxfawdKnimqQ8Um/PGbWV2acgES0=;
        b=70odPLCEiBZn1v9pNFjLeZhR46LtbOX2GOk6i8lgW4I5YY+3aZTT14Y/qDiKxF5rq6
         MEmD4Aof3MW840rxUysZ65IQZFBKmRcFhCQJY/YznHITo8o2x8aBqsuq1L+blhX4lBcA
         8VjnL1kpPfpyDGqxK6VL8jk4Tdgl6t/nvC0h3BCLsJLO85YWzs/AYPyFeg8EWR96UEfq
         +izRDZhfCKAMeHuVLq66qJVkSPDiQLr4+bntGRBfJJKUamPfotTaJ1Q+i7D1f1pJarh7
         5o0fO80SzBvaTY3jkRTKbumWEqiUtJpuy+aM7tEjghnMYWBdKvV7BYANCV7FZ49m0dhk
         PQnw==
X-Gm-Message-State: AJIora+0Vg1REUbuyfLXid2WP17R5uCWeWIrpNk8PL3DMmy6skDnGPBT
        EOtwhjNnCupSqeA+0PeRQDPKUd70qfnJIjMJ9K4XY4vPqyD76A==
X-Google-Smtp-Source: AGRyM1vgs4+PLaXYaWdAUxHFgH3y5audNQF2gCUjxbryvHQkv4zDmt6xQgDgf0m04Awy6lgIIIH1MjiQkgPzaOiHqSU=
X-Received: by 2002:a05:6e02:1607:b0:2d1:e622:3f0a with SMTP id
 t7-20020a056e02160700b002d1e6223f0amr1502128ilu.287.1655342478835; Wed, 15
 Jun 2022 18:21:18 -0700 (PDT)
MIME-Version: 1.0
References: <1655182915-12897-1-git-send-email-quic_subashab@quicinc.com>
 <1655182915-12897-2-git-send-email-quic_subashab@quicinc.com> <20220615173516.29c80c96@kernel.org>
In-Reply-To: <20220615173516.29c80c96@kernel.org>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Wed, 15 Jun 2022 18:21:07 -0700
Message-ID: <CANP3RGfGcr25cjnrUOdaH1rG9S9uY8uS80USXeycDBhbsX9CZw@mail.gmail.com>
Subject: Re: [PATCH net v2 1/2] ipv6: Honor route mtu if it is within limit of
 dev mtu
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Stefano Brivio <sbrivio@redhat.com>,
        Kaustubh Pandey <quic_kapandey@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 5:35 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 13 Jun 2022 23:01:54 -0600 Subash Abhinov Kasiviswanathan wrote:
> > When netdevice MTU is increased via sysfs, NETDEV_CHANGEMTU is raised.
> >
> > addrconf_notify -> rt6_mtu_change -> rt6_mtu_change_route ->
> > fib6_nh_mtu_change
> >
> > As part of handling NETDEV_CHANGEMTU notification we land up on a
> > condition where if route mtu is less than dev mtu and route mtu equals
> > ipv6_devconf mtu, route mtu gets updated.
> >
> > Due to this v6 traffic end up using wrong MTU then configured earlier.
> > This commit fixes this by removing comparison with ipv6_devconf
> > and updating route mtu only when it is greater than incoming dev mtu.
> >
> > This can be easily reproduced with below script:
> > pre-condition:
> > device up(mtu = 1500) and route mtu for both v4 and v6 is 1500
> >
> > test-script:
> > ip route change 192.168.0.0/24 dev eth0 src 192.168.0.1 mtu 1400
> > ip -6 route change 2001::/64 dev eth0 metric 256 mtu 1400
> > echo 1400 > /sys/class/net/eth0/mtu
> > ip route change 192.168.0.0/24 dev eth0 src 192.168.0.1 mtu 1500
> > echo 1500 > /sys/class/net/eth0/mtu
>
> CC maze, please add him if there is v3
>
> I feel like the problem is with the fact that link mtu resets protocol
> MTUs. Nothing we can do about that, so why not set link MTU to 9k (or
> whatever other quantification of infinity there is) so you don't have
> to touch it as you discover the MTU for v4 and v6?
>
> My worry is that the tweaking of the route MTU update heuristic will
> have no end.
>
> Stefano, does that makes sense or you think the change is good?

I vaguely recall that if you don't want device mtu changes to affect
ipv6 route mtu, then you should set 'mtu lock' on the routes.
(this meaning of 'lock' for v6 is different than for ipv4, where
'lock' means transmit IPv4/TCP with Don't Frag bit unset)
