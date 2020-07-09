Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD8F21A828
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 21:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgGITuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 15:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726311AbgGITt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 15:49:59 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD4AC08C5CE
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 12:49:56 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id e4so3791048ljn.4
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 12:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=habets.se; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=qyfJ7rlKHi80QWYEFhgDft7oO+HZpsE5iYNVH2coXhQ=;
        b=InA6IVrxLFGXi7UVTQsyDgaX3CnOOp5A1Pi3JP+12k3vNC60qAVxkQnGWId573sUg8
         K64RMlnVft7qwFE7S8w4FawgTzz2aEpeewR3w2BIgVSWOgKphWFc7nq+ElZlkorKKAA0
         bXL38rs3qJfPHIplPOx+EHEJrzSMBlwjsr8TU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=qyfJ7rlKHi80QWYEFhgDft7oO+HZpsE5iYNVH2coXhQ=;
        b=C8FNaElOHtL0E8VUTkoV0WnipuysH5GtN8x3w9NTqRV4NpRVbhmbFq0ydaoBRSX4mz
         wOG9ioSlagAN/AQ0lsa9LW1CsjWSG4snXu+iDLEaI2RPetLjU8FWAxBrXQrXaXduN52V
         M6zAdt4Quh3jrvkgAQwHqWDu52+58PI/KyVUxf6COWW7xXCOL29JD1orJPYHqjdhEAaR
         3yUlbxj81NB2zBQ2xu/4x5h5quqk+rw8VxFlu/sZ+a1xpudG5jb7Ddqq6nHY1iZ4Z6eu
         yLvrOwwADS+hrr7YmLxxRDKo5YhOHcsjlJXhlMUzMqqfmWCnKtm77o8uugybMePx4WNj
         GTHA==
X-Gm-Message-State: AOAM533MnCNrZksung+pxqx3p9LPfKMSP5pJsSuKrx0oZj1ys40IIKT8
        y/klYs0qLd3dJ26s5p7qDvK8BI0ppw9YG4w+UA3snKco5n5fVw==
X-Google-Smtp-Source: ABdhPJzbRoiNc2D1S/fDTwY4DPthZSWZ6EO3Bf9NfutFTlFxMw9J33xsxs+GK6RYpJWOVPtc1jzMrIBDh3CRno+OAN8=
X-Received: by 2002:a2e:b0ef:: with SMTP id h15mr2695464ljl.43.1594324194111;
 Thu, 09 Jul 2020 12:49:54 -0700 (PDT)
MIME-Version: 1.0
References: <CA+kHd+cdzU2qxvHxUNcPtEZiwrDHFCgraOd=BdksMs-snZRUXQ@mail.gmail.com>
 <CA+kHd+ejR-WcVj_PGz9OHXOvSH51R2hQA+NQiLUnqoxE6QQd+g@mail.gmail.com> <CA+kHd+cTpqDa+-42Mg1FfNTD9rK7UXR7qjjQUwxta8EO2ahxjg@mail.gmail.com>
In-Reply-To: <CA+kHd+cTpqDa+-42Mg1FfNTD9rK7UXR7qjjQUwxta8EO2ahxjg@mail.gmail.com>
From:   Thomas Habets <thomas@habets.se>
Date:   Thu, 9 Jul 2020 20:49:41 +0100
Message-ID: <CA+kHd+fh2UW4FvxL4v_rd8mQ=avuzHxb=n_ogpVwCMSXVTCeAg@mail.gmail.com>
Subject: PATCH ax25: Don't hold skb lock while doing blocking read
To:     netdev@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here's a test program that illustrates the problem:
https://github.com/ThomasHabets/radiostuff/blob/master/ax25/axftp/examples/client_lockcheck.cc

Before this patch, this hangs, because the read(2) blocks the
write(2).

I see that calling skb_recv_datagram without this lock is done in
pep_sock_accept() and atalk_recvmsg() and others, which is what makes
me think it's safe to do here too. But I'm far from an expert on skb
lock semantics.

I see some other socket types are also locking during
read. E.g. qrtr_recvmsg. Maybe they need to be fixed too.

Before:
strace -f -eread,write ./examples/client_lockcheck M0THC-9 M0THC-0 M0THC-2
strace: Process 3888 attached
[pid  3888] read(3,  <unfinished ...>
[pid  3887] write(3, "hello world", 11
[hang]

After:
strace -f -eread,write ./examples/client_lockcheck M0THC-9 M0THC-0 M0THC-2
strace: Process 2433 attached
[pid  2433] read(3,  <unfinished ...>
[pid  2432] write(3, "hello world", 11) = 11
[pid  2433] <... read resumed> "yo", 1000) = 2
[pid  2433] write(1, "yo\n", 3yo
)         = 3
[successful exit]


diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index fd91cd34f25e..378ee132e4d0 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1617,22 +1617,22 @@ static int ax25_recvmsg(struct socket *sock,
struct msghdr *msg, size_t size,
        int copied;
        int err = 0;

-       lock_sock(sk);
        /*
         *      This works for seqpacket too. The receiver has ordered the
         *      queue for us! We do one quick check first though
         */
        if (sk->sk_type == SOCK_SEQPACKET && sk->sk_state != TCP_ESTABLISHED) {
                err =  -ENOTCONN;
-               goto out;
+               goto out_nolock;
        }

        /* Now we can treat all alike */
        skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
                                flags & MSG_DONTWAIT, &err);
        if (skb == NULL)
-               goto out;
+               goto out_nolock;

+       lock_sock(sk);
        if (!sk_to_ax25(sk)->pidincl)
                skb_pull(skb, 1);               /* Remove PID */

@@ -1677,6 +1677,7 @@ static int ax25_recvmsg(struct socket *sock,
struct msghdr *msg, size_t size,

 out:
        release_sock(sk);
+out_nolock:

        return err;
 }
