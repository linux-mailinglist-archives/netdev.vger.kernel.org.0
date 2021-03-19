Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EFA03425A9
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 20:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbhCSTD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 15:03:56 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:56506 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230285AbhCSTD0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 15:03:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1616180598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IN+ydESw6o8X7Wr71+3xLjavHCnYCjO5YtnEjXc2xqc=;
        b=ANsFEebuT8UujDMuec9I0+F4pS5K8XVJzeccGIydKKQh8IDTI8NowQpzfMvTMfDpYaaWMG
        JOeUL2LE4xtQk7fxfcBmggIA+Y650zht+YZzj8+afJeJ8WHs06lbSqV28OyLOwaHqgDlN+
        Te0EniVtdpkMaeqhCxqckzmW8mOSyV0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d9c0995b (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 19 Mar 2021 19:03:18 +0000 (UTC)
Received: by mail-yb1-f171.google.com with SMTP id c131so7339479ybf.7;
        Fri, 19 Mar 2021 12:03:18 -0700 (PDT)
X-Gm-Message-State: AOAM531u4ELDgeTKUfOEhYajbput+cxCXYnnTIkO8zZQdOcYh3ZMv8tV
        LU2iIcWLCeOoJzP00+QyAm6aPurpLN0DipdKdlI=
X-Google-Smtp-Source: ABdhPJyVtqiB1Ie45L3iLGrKcIwbe2e4TLDHlPmROylBQSw3Eog83JKjNPeCDeaQa5hvIoxSGuhCfJ9QgpnWl5tITiE=
X-Received: by 2002:a25:38c5:: with SMTP id f188mr8383964yba.178.1616180597073;
 Fri, 19 Mar 2021 12:03:17 -0700 (PDT)
MIME-Version: 1.0
References: <1615603667-22568-1-git-send-email-linyunsheng@huawei.com>
 <1615777818-13969-1-git-send-email-linyunsheng@huawei.com>
 <20210315115332.1647e92b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAM_iQpXvVZxBRHF6PBDOYSOSCj08nPyfcY0adKuuTg=cqffV+w@mail.gmail.com>
 <87eegddhsj.fsf@toke.dk> <CAHmME9qDU7VRmBV+v0tzLiUpMJykjswSDwqc9P43ZwG1UD7mzw@mail.gmail.com>
 <3bae7b26-9d7f-15b8-d466-ff5c26d08b35@huawei.com>
In-Reply-To: <3bae7b26-9d7f-15b8-d466-ff5c26d08b35@huawei.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 19 Mar 2021 13:03:06 -0600
X-Gmail-Original-Message-ID: <CAHmME9qS-_H7Z5Gjw7SbZS0fO84vzpx4ZNHu0Ay=2krZpJQy3A@mail.gmail.com>
Message-ID: <CAHmME9qS-_H7Z5Gjw7SbZS0fO84vzpx4ZNHu0Ay=2krZpJQy3A@mail.gmail.com>
Subject: Re: [Linuxarm] Re: [RFC v2] net: sched: implement TCQ_F_CAN_BYPASS
 for lockless qdisc
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@openeuler.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, Thomas Gschwantner <tharre3@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 18, 2021 at 1:33 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> > That offer definitely still stands. Generalization sounds like a lot of fun.
> >
> > Keep in mind though that it's an eventually consistent queue, not an
> > immediately consistent one, so that might not match all use cases. It
> > works with wg because we always trigger the reader thread anew when it
> > finishes, but that doesn't apply to everyone's queueing setup.
>
> Thanks for mentioning this.
>
> "multi-producer, single-consumer" seems to match the lockless qdisc's
> paradigm too, for now concurrent enqueuing/dequeuing to the pfifo_fast's
> queues() is not allowed, it is protected by producer_lock or consumer_lock.

The other thing is that if you've got memory for a ring buffer rather
than a list queue, we worked on an MPMC ring structure for WireGuard a
few years ago that we didn't wind up using in the end, but it lives
here:
https://git.zx2c4.com/wireguard-monolithic-historical/tree/src/mpmc_ptr_ring.h?h=tg/mpmc-benchmark
