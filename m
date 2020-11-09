Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588E02AC240
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 18:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731794AbgKIR3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 12:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730927AbgKIR3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 12:29:06 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020A8C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 09:29:06 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id j12so10640859iow.0
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 09:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iS7wGl9RDeoaCYAmtEhoMmhifB7Bkd936j4hSXda9EQ=;
        b=qORLalHDW7LGVeTLFECbEXBBMT8mS1jyJOQ7Axna9Vlw0y963SK1p2R0JlsGhmfOK9
         8bgUaLFJYUNfcAvFyKnHovCj641LwmTqB6fCfJjil+/qDFOyBb6wlVRxGTwwew8ypGoR
         LMQFpHhxF5dwrr2ILH6vh1eQOjBomAkSxcUu/wjuB48B6SnZ/VAVB18n90Sl1IFZ8tEF
         YJK4Zxl435cMVsAjv/26doLLb6IH82kTuey6+N0STwu49m5fkh0CmibRmqKuc5lVOoBf
         tdhbaoNvTRJQlNWJMkRjjjr+pFroHaJTv7f4NamaIfBe247GhYhVMxqPiQjCiQ2TEOvF
         Qr8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iS7wGl9RDeoaCYAmtEhoMmhifB7Bkd936j4hSXda9EQ=;
        b=LctmhXTm07oTs+g3Mlfw2/YO9aCTGXtDSMhpvpmg/aaxodENaKaTB3RW4BEEsZzxyc
         mHq51s0vkOLAekhjiGbZspFanW0itPxcIAKgWwDSWHgATSE3eTQ/weZCzCXxM2XsRVcM
         +rETyXmUm6Pml0cOAbSYCPeWcjzjfyu9ZkXNAyg6wFrOJKUdVISXIk4qGqRAiPJpEsJU
         hTlYk/Jdvb4rwYa5X4VkvJilUHxyVL7lHa7BAsykSQQNxpFvjOQHRU3BPOkwnghddnqI
         g7ocOWxa0dkbO14Vwmn1Zd/tMdQwOx+mxcOi3CscL0j8eos81tXIKTWTXaoEPVHDUrwd
         aaaQ==
X-Gm-Message-State: AOAM5327B+NrLxCh2vpFVw3b8pRQ1vCzuBnxKk3Um5Wb3MrSWxeQ14Wx
        QiRuK62y0ROwxeX5F8A+CkpaZyEh06OrSWjfqIkyNqAKwgO1/A==
X-Google-Smtp-Source: ABdhPJzXzmeKVEDjebEji3sdG67yPKV/Yns17/N7tod+wD7i2Lnmtm0ujUnV4ku62ZygmGN4tp4NIgrhEXqlnypKKCM=
X-Received: by 2002:a02:7112:: with SMTP id n18mr11937162jac.34.1604942945017;
 Mon, 09 Nov 2020 09:29:05 -0800 (PST)
MIME-Version: 1.0
References: <CANn89iLVWFgDvkUygK8Sh_H7=qFmuZKo1h=aoq+F57J28r4EUA@mail.gmail.com>
 <1604942276-92635-1-git-send-email-wenan.mao@linux.alibaba.com>
In-Reply-To: <1604942276-92635-1-git-send-email-wenan.mao@linux.alibaba.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 Nov 2020 18:28:53 +0100
Message-ID: <CANn89i+ABLMJTEKat=9=qujNwe0BFavphzqYc1CQGtrdkwUnXg@mail.gmail.com>
Subject: Re: [PATCH net v4] net: Update window_clamp if SOCK_RCVBUF is set
To:     Mao Wenan <wenan.mao@linux.alibaba.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 6:18 PM Mao Wenan <wenan.mao@linux.alibaba.com> wrote:
>
> When net.ipv4.tcp_syncookies=1 and syn flood is happened,
> cookie_v4_check or cookie_v6_check tries to redo what
> tcp_v4_send_synack or tcp_v6_send_synack did,
> rsk_window_clamp will be changed if SOCK_RCVBUF is set,
> which will make rcv_wscale is different, the client
> still operates with initial window scale and can overshot
> granted window, the client use the initial scale but local
> server use new scale to advertise window value, and session
> work abnormally.
>
> Fixes: e88c64f0a425 ("tcp: allow effective reduction of TCP's rcv-buffer via setsockopt")
> Signed-off-by: Mao Wenan <wenan.mao@linux.alibaba.com>
> ---
>  v4: change fixes tag format, and delay the actual call to
>  tcp_full_space().
>  v3: add local variable full_space, add fixes tag.
>  v2: fix for ipv6.
>  net/ipv4/syncookies.c | 8 +++++++-
>  net/ipv6/syncookies.c | 9 ++++++++-
>  2 files changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
> index 6ac473b..8784e1f 100644
> --- a/net/ipv4/syncookies.c
> +++ b/net/ipv4/syncookies.c
> @@ -327,6 +327,7 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
>         struct inet_request_sock *ireq;
>         struct tcp_request_sock *treq;
>         struct tcp_sock *tp = tcp_sk(sk);
> +       int full_space;

SGTM. although you could have avoided adding a variable breaking the almost
correct reverse Christmas tree that some of us prefer.

Something like this would look better :

diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 6ac473b47f30d4d5e5e9455424b1a91d84e649ee..78af720f3e2c6dcdc7298178c5d2f02f0e425e04
100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -331,7 +331,7 @@ struct sock *cookie_v4_check(struct sock *sk,
struct sk_buff *skb)
        __u32 cookie = ntohl(th->ack_seq) - 1;
        struct sock *ret = sk;
        struct request_sock *req;
-       int mss;
+       int full_space, mss;
        struct rtable *rt;
        __u8 rcv_wscale;
        struct flowi4 fl4;
