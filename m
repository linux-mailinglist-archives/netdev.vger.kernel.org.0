Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6273BAD50
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 16:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhGDOGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 10:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhGDOGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 10:06:01 -0400
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF95DC061574
        for <netdev@vger.kernel.org>; Sun,  4 Jul 2021 07:03:25 -0700 (PDT)
Received: by mail-vk1-xa2c.google.com with SMTP id p134so333016vke.8
        for <netdev@vger.kernel.org>; Sun, 04 Jul 2021 07:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gBspm/BlVrYCvD2/PgUixtAdfPPqsF72ctK925L56Wc=;
        b=lc1LmfjctBzKJNjKLR7QVzRXzvkDICIDyMrYxrN6y5PwKmmAy6WJMPG5oIp+mrsbE3
         XQ2/F31H5tEilzpFWH+jZPPxkOLpsutS/DpuKwoUzY9qDxb2ipYStnabEPwNTNSwEVHz
         Ko9YLgIXfMIRjbRF4uOgoFZ7hZ+bJdcZMJ0urItEc619PEEx1ZAO0l3c+Bzdj0S1/SnM
         Qt98R3v/DaEi0/MPNkDbAWkmam24FQHrhUBsY9goYzCPST14diqxaFcm3b2yvRykULGZ
         oxFwXcxsoXIz+ia5Lk3MsPVxAGSquH9myTASmYxsdSEkGsa+1kalucIIT2GGU+swgI5A
         N99w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gBspm/BlVrYCvD2/PgUixtAdfPPqsF72ctK925L56Wc=;
        b=tl8EnJ7nhBBqKETmuSKK2+dYVbY/Qr3y9zhDrjcWrpiUn4PZIXvfkh+NQUwJZRf7H6
         CipCmF7kh7Y8fJgxWQy6by2xxskNO8jrKfMnFCGausVWGKXSJyf5lBxFpx6tBKpkohWg
         NGQhZy9x3v9b9I+fsBKtXhq+2JPSYtz+td53WjNJxXAsr+MYchOLvJBx5i04KBvxG+ew
         9bte7vdy3KHLMWaYsrrNky1PaieG/Jm8usiAXQOFZG5bj5Smfwenvj/ProV4QgdKmJtd
         gjQdMh1NCgjFLoZHYxY9j4j14ZP/CX7loFGssXih4Z8EDvT4EKMsovb+oEm5w+/YJr0Q
         YA9Q==
X-Gm-Message-State: AOAM531aQurE0ikJIl9lglL00Mvt1lHEbWL93cj9YS7+2DMXqvvg8kzv
        Tt6yTW8sP26r2adYTW/2815m+uAHJBKt5nP1DYjc9A==
X-Google-Smtp-Source: ABdhPJytYsHbTrFOlrsisLYRSoTTuDDGUpSkgbxQLUklvl9NvDcJPMoaAHHy6mtBNB9vJmqcpiJooThRYrXLq62DZ+o=
X-Received: by 2002:a1f:dfc1:: with SMTP id w184mr5658047vkg.17.1625407404796;
 Sun, 04 Jul 2021 07:03:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210703093417.1569943-1-phind.uet@gmail.com> <20210703.144945.1327654903412498334.davem@davemloft.net>
In-Reply-To: <20210703.144945.1327654903412498334.davem@davemloft.net>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Sun, 4 Jul 2021 10:03:08 -0400
Message-ID: <CADVnQykHuUTw82Fu6XNXJaX-vmep3UN0kvxdwvqcE--2+xAs5A@mail.gmail.com>
Subject: Re: [PATCH v4] tcp: fix tcp_init_transfer() to not reset icsk_ca_initialized
To:     David Miller <davem@davemloft.net>
Cc:     phind.uet@gmail.com, yhs@fb.com, edumazet@google.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, ycheng@google.com, yyd@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+f1e24a0594d4e3a895d3@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 3, 2021 at 5:49 PM David Miller <davem@davemloft.net> wrote:
>
> From: Nguyen Dinh Phi <phind.uet@gmail.com>
> Date: Sat,  3 Jul 2021 17:34:17 +0800
>
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index 7d5e59f688de..855ada2be25e 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -5922,7 +5922,6 @@ void tcp_init_transfer(struct sock *sk, int bpf_op, struct sk_buff *skb)
> >               tp->snd_cwnd = tcp_init_cwnd(tp, __sk_dst_get(sk));
> >       tp->snd_cwnd_stamp = tcp_jiffies32;
> >
> > -     icsk->icsk_ca_initialized = 0;
> >       bpf_skops_established(sk, bpf_op, skb);
> >       if (!icsk->icsk_ca_initialized)
> >               tcp_init_congestion_control(sk);
>
> Don't you have to make the tcp_init_congestion_control() call unconditional now?

I think we want to keep it conditional, to avoid double-initialization
if the BPF code sets the congestion control algorithm and initializes
it. But that's relatively new and subtle, so it might be nice for this
patch to add a comment about that, since it's touching this part of
the code anyway:

-       icsk->icsk_ca_initialized = 0;
        bpf_skops_established(sk, bpf_op, skb);
+       /* Initialize congestion control unless BPF initialized it already: */
        if (!icsk->icsk_ca_initialized)
                tcp_init_congestion_control(sk);

neal
