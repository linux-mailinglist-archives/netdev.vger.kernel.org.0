Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C861C6196
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728954AbgEEUHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:07:07 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:59929 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728569AbgEEUHH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 16:07:07 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 318e206f;
        Tue, 5 May 2020 19:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=usExkLZzTo+s7Ni/6F6b27S3A0o=; b=RIT+d+
        kYZjKMjN0Oi4werOuJaG/Ue+FahbxZSd+K4iB6REfNMtbDULbKttGBkBUuj+8U/I
        CIaN3DzntxeTeBdx6e0kp58iK3T9tXRn8nwW+IosL25yvQPq2XpQModGLPAJ8zwa
        g5ivRfnGg30rWqlWM+xmdAB9zPzKZS8OzlmHyT6DtebfeNwiNVh05vpoWFwU6jYJ
        m1CTcjnFJbhux60b7r2qs566F53HRbAKzkLoBsyRxjx7A8qRI+1IIy0ugOS1kQRj
        v38yDj73vKsg4yg0qWCgwcuThCbxysy+D4ySjp0/yYnEMSLtaP2QVwxQ+si9Mx34
        2khr5pUpBgmtotzQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d7eb683e (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 5 May 2020 19:54:30 +0000 (UTC)
Received: by mail-il1-f169.google.com with SMTP id r2so2443877ilo.6;
        Tue, 05 May 2020 13:07:04 -0700 (PDT)
X-Gm-Message-State: AGi0PuazqeyWAA702UffdSDe7B5CaGvakxdsWmNpeiK0v6RCjx0rJfAt
        QLKv7/j/pp4RYjvNdFYPQTWnUrZ7WoBSaPHvebI=
X-Google-Smtp-Source: APiQypIbrq5BimrpgkqS3H4zSchqYRWQJ5afcQiOi4WgV4Z/1/duDp5O8TBtdE54uH7v86Gkyl7M0plAdTTyiC9H8Os=
X-Received: by 2002:a92:5c82:: with SMTP id d2mr5605707ilg.231.1588709223915;
 Tue, 05 May 2020 13:07:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200505141327.746184-1-arnd@arndb.de>
In-Reply-To: <20200505141327.746184-1-arnd@arndb.de>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 5 May 2020 14:06:52 -0600
X-Gmail-Original-Message-ID: <CAHmME9oTO7DiWCXoeCBjmPOBMoZQ2hUhHjZ4_oi-nVP_9pRpSg@mail.gmail.com>
Message-ID: <CAHmME9oTO7DiWCXoeCBjmPOBMoZQ2hUhHjZ4_oi-nVP_9pRpSg@mail.gmail.com>
Subject: Re: [PATCH] net: wireguard: avoid unused variable warning
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 8:13 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> clang points out a harmless use of uninitialized variables that
> get passed into a local function but are ignored there:
>
> In file included from drivers/net/wireguard/ratelimiter.c:223:
> drivers/net/wireguard/selftest/ratelimiter.c:173:34: error: variable 'skb6' is uninitialized when used here [-Werror,-Wuninitialized]
>                 ret = timings_test(skb4, hdr4, skb6, hdr6, &test_count);
>                                                ^~~~
> drivers/net/wireguard/selftest/ratelimiter.c:123:29: note: initialize the variable 'skb6' to silence this warning
>         struct sk_buff *skb4, *skb6;
>                                    ^
>                                     = NULL
> drivers/net/wireguard/selftest/ratelimiter.c:173:40: error: variable 'hdr6' is uninitialized when used here [-Werror,-Wuninitialized]
>                 ret = timings_test(skb4, hdr4, skb6, hdr6, &test_count);
>                                                      ^~~~
> drivers/net/wireguard/selftest/ratelimiter.c:125:22: note: initialize the variable 'hdr6' to silence this warning
>         struct ipv6hdr *hdr6;
>                             ^

Seems like the code is a bit easier to read and is more uniform
looking by just initializing those two variables to NULL, like the
warning suggests. If you don't mind, I'll queue something up in my
tree to this effect.

By the way, I'm having a bit of a hard time reproducing the warning
with either clang-10 or clang-9. Just for my own curiosity, would you
mind sending the .config that results in this?

Jason
