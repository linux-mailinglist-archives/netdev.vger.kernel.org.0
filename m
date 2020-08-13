Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DAA12431A8
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 02:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgHMAJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 20:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbgHMAJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 20:09:50 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CECFC061383
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 17:09:50 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id c6so3876675ilo.13
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 17:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iH03kseAAEDCWh8J5sJG9IXy7Q3pVPuUf7i8h+pHbeU=;
        b=E2uB/slDc4TrqRiDkPUNx/HMtLkhHZRvWfJcljzYGtZXc9SsoseTmhoC6DwW3wPRhl
         R94RKvG88l5RHXdo5Uk4SGEAoch9Ev3OfRU2EBrZTvaw25c9oEhqLwcSXzynrN8AG0x4
         x5vZUVTy84f3lYd5vrXKmF6wnst2oniY0vOgeXa5PODcCCQBkUUtzS9YUOQEdQ1VwAXN
         CcloSvx/FyoDac2ATewgUrW55pq32tUvaKGxpwXUJdvfs/krCfcuY2ByI+fGr4IcfEG1
         vwOLgns+ANgOyxJPwJdiHVTySZnvUB7rXuNZgQcuUsEnhy+Q2izQjCBWyZf+Irx05tWH
         UMuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iH03kseAAEDCWh8J5sJG9IXy7Q3pVPuUf7i8h+pHbeU=;
        b=pIymcmsHoxWeCE/Bm1QVfzPNBQjyPGhIKHQInyyTQq5V1b7boafTYlIZ5EwmP8LmH0
         N916yX6Q15EnZkoEA2Oa1tMGkJWqOSmgt4+jmV1LRdN9aOcVYmQFhLHptCXBnGvLzcMX
         YgdEqx2iUL4D2ohos3D3gBLVkBixvvDsteZWf33HFSx2VnyotIfht/KmYI2RaLg0gMYn
         t9C62RAwoMkkqZYisEWwK9fjndLJ6jQuU2MowIBDImSw/AdD4MVLFrYyrMjipOZkOBVz
         UvRe/phnsttJBOq4ozGgQJfFAHLCQDvMgXUo0Xqo/u4LEzcCtSen8fLwtTZ67xMCrF63
         AIZQ==
X-Gm-Message-State: AOAM533yetOkoa3iDJj3yW6aWEJowGqYAn4c/Y4CKGftSq0/SK9gxPTK
        ddorwT8EM790Dl6BxUTrQCbVUJTf7MDLPWnNy4Dlyw==
X-Google-Smtp-Source: ABdhPJyImtRniGZuz8JcN8GURLbFjgCCg1YWLtWKuLmeoxXLgm2uPcNFLqdgmCRpGPZq21KaUo2qXuVj7ph33cwGZ9k=
X-Received: by 2002:a92:4001:: with SMTP id n1mr2161060ila.69.1597277389152;
 Wed, 12 Aug 2020 17:09:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200728015505.37830-1-decui@microsoft.com> <KL1P15301MB0279A6C3BB3ACADE410F8144BF490@KL1P15301MB0279.APCP153.PROD.OUTLOOK.COM>
 <20200813000650.GL2975990@sasha-vm>
In-Reply-To: <20200813000650.GL2975990@sasha-vm>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 12 Aug 2020 17:09:37 -0700
Message-ID: <CANn89iJmJdCdhn3pJYs4sh4YJsStqOQgGnvTyNKf=iPrN8Av5g@mail.gmail.com>
Subject: Re: [PATCH][for v4.4 only] udp: drop corrupt packets earlier to avoid
 data corruption
To:     Sasha Levin <sashal@kernel.org>
Cc:     Dexuan Cui <decui@microsoft.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sasha Levin <Alexander.Levin@microsoft.com>,
        "w@1wt.eu" <w@1wt.eu>,
        Joseph Salisbury <Joseph.Salisbury@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ohering@suse.com" <ohering@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 12, 2020 at 5:06 PM Sasha Levin <sashal@kernel.org> wrote:
>
> On Fri, Aug 07, 2020 at 06:03:00PM +0000, Dexuan Cui wrote:
> >> From: Dexuan Cui <decui@microsoft.com>
> >> Sent: Monday, July 27, 2020 6:55 PM
> >> To: gregkh@linuxfoundation.org; edumazet@google.com;
> >> stable@vger.kernel.org
> >> Cc: w@1wt.eu; Dexuan Cui <decui@microsoft.com>; Joseph Salisbury
> >> <Joseph.Salisbury@microsoft.com>; Michael Kelley <mikelley@microsoft.com>;
> >> viro@zeniv.linux.org.uk; netdev@vger.kernel.org; davem@davemloft.net;
> >> ohering@suse.com
> >> Subject: [PATCH][for v4.4 only] udp: drop corrupt packets earlier to avoid data
> >> corruption
> >>
> >> The v4.4 stable kernel lacks this bugfix:
> >> commit 327868212381 ("make skb_copy_datagram_msg() et.al. preserve
> >> ->msg_iter on error").
> >> As a result, the v4.4 kernel can deliver corrupt data to the application
> >> when a corrupt UDP packet is closely followed by a valid UDP packet: the
> >> same invocation of the recvmsg() syscall can deliver the corrupt packet's
> >> UDP payload to the application with the UDP payload length and the
> >> "from IP/Port" of the valid packet.
> >>
> >> Details:
> >>
> >> For a UDP packet longer than 76 bytes (see the v5.8-rc6 kernel's
> >> include/linux/skbuff.h:3951), Linux delays the UDP checksum verification
> >> until the application invokes the syscall recvmsg().
> >>
> >> In the recvmsg() syscall handler, while Linux is copying the UDP payload
> >> to the application's memory, it calculates the UDP checksum. If the
> >> calculated checksum doesn't match the received checksum, Linux drops the
> >> corrupt UDP packet, and then starts to process the next packet (if any),
> >> and if the next packet is valid (i.e. the checksum is correct), Linux
> >> will copy the valid UDP packet's payload to the application's receiver
> >> buffer.
> >>
> >> The bug is: before Linux starts to copy the valid UDP packet, the data
> >> structure used to track how many more bytes should be copied to the
> >> application memory is not reset to what it was when the application just
> >> entered the kernel by the syscall! Consequently, only a small portion or
> >> none of the valid packet's payload is copied to the application's
> >> receive buffer, and later when the application exits from the kernel,
> >> actually most of the application's receive buffer contains the payload
> >> of the corrupt packet while recvmsg() returns the length of the UDP
> >> payload of the valid packet.
> >>
> >> For the mainline kernel, the bug was fixed in commit 327868212381,
> >> but unluckily the bugfix is only backported to v4.9+. It turns out
> >> backporting 327868212381 to v4.4 means that some supporting patches
> >> must be backported first, so the overall changes seem too big, so the
> >> alternative is performs the csum validation earlier and drops the
> >> corrupt packets earlier.
> >>
> >> Signed-off-by: Eric Dumazet <edumazet@google.com>
> >> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> >> ---
> >>  net/ipv4/udp.c | 3 +--
> >>  net/ipv6/udp.c | 6 ++----
> >>  2 files changed, 3 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> >> index bb30699..49ab587 100644
> >> --- a/net/ipv4/udp.c
> >> +++ b/net/ipv4/udp.c
> >> @@ -1589,8 +1589,7 @@ int udp_queue_rcv_skb(struct sock *sk, struct
> >> sk_buff *skb)
> >>              }
> >>      }
> >>
> >> -    if (rcu_access_pointer(sk->sk_filter) &&
> >> -        udp_lib_checksum_complete(skb))
> >> +    if (udp_lib_checksum_complete(skb))
> >>              goto csum_error;
> >>
> >>      if (sk_rcvqueues_full(sk, sk->sk_rcvbuf)) {
> >> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> >> index 73f1112..2d6703d 100644
> >> --- a/net/ipv6/udp.c
> >> +++ b/net/ipv6/udp.c
> >> @@ -686,10 +686,8 @@ int udpv6_queue_rcv_skb(struct sock *sk, struct
> >> sk_buff *skb)
> >>              }
> >>      }
> >>
> >> -    if (rcu_access_pointer(sk->sk_filter)) {
> >> -            if (udp_lib_checksum_complete(skb))
> >> -                    goto csum_error;
> >> -    }
> >> +    if (udp_lib_checksum_complete(skb))
> >> +            goto csum_error;
> >>
> >>      if (sk_rcvqueues_full(sk, sk->sk_rcvbuf)) {
> >>              UDP6_INC_STATS_BH(sock_net(sk),
> >> --
> >> 1.8.3.1
> >
> >+Sasha
> >
> >This patch is targeted to the linux-4.4.y branch of the stable tree.
>
> Eric, will you ack this (or have a missed a previous ack)?

Sure, although I have already a Signed-off-by: tag on this one, since
I wrote this simpler fix for stable.

If needed :
Acked-by: Eric Dumazet <edumazet@google.com>

Thanks.
