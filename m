Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F24E127864
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 10:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfLTJkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 04:40:37 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:35857 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbfLTJkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 04:40:37 -0500
Received: by mail-ot1-f65.google.com with SMTP id w1so11171023otg.3;
        Fri, 20 Dec 2019 01:40:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B8W2+ltOfOy0ZB4DxGV/lU4B1XOok93p5EKVOLRu56c=;
        b=Jbkg7h8e4r7rZ+67wEgMPeJi6jK68ZPAVStnG+3NyVpda7Ujo+OxRBIclBxYNqwSTP
         sW3Ou3KIR5neH/MPXUbvRE2LzlsiqKXg9aLH2YE47QcjKgqUKNlN2Ms7rSjblY4EGHYd
         +3oCK6hu4A9p+gKk+68ofNtrXl3zDRBoVhAv1m2rQPJfJgCwZ04/S1nWC37UBEv/Zu+V
         KYcZ3AFx2diFPvqomzpqheNphT7+JsWfy/KIEcXrdmfb1O82eGsgmX351AnUFS3OKdWe
         dpXxg1m6ZuE3IcYooIKeH0AKA9/VTETKpDmEYBa6VXOwWguuhnJbtr67lkGb1GXTnk/f
         R/Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B8W2+ltOfOy0ZB4DxGV/lU4B1XOok93p5EKVOLRu56c=;
        b=TWeq+YvWpkvqJTiH+4dAEw6o5SeA+RjVQuVirxD4qrfBHdZ9sHGMie2gnzku5Q00U0
         jPZfR1Acz9XdG8LelSLSosLBke5Tn5Y/pkwI4I9EKKo3yYma9e43dw5i8WTlDEFsd5O7
         Rm0fzr7SFWYYyo8DFHLIT47y+ttK2apMoDUEQMk6mk74rU6043LzEo3nZOFN4puRnqnL
         owzlpo0Pin5uDRGzRskYRPbeia3pPeM4D9uO9ELXkhRhkFXNmUdf0VgfwwdDjO7U8zZn
         En9FcRZpD9dTa+amUS56ZExa4x7t2WuKOQAsZVFLuyRwMPfi2fmGyOqUo1g2w94Eif75
         iW6g==
X-Gm-Message-State: APjAAAXFW2/AopiPgxnkemEIBhjFMQQxIPPr43ZxmcMlS37pTTi2uUsX
        l9sgHIhMrjuzP0i5batSqcGAtyW+e5ayRyyVC4A=
X-Google-Smtp-Source: APXvYqwDmdLgM1T281shQSN/QsbY8xFEkYvnSM6b+A2fHctteT2NJqaJ5QkNFlGusQvzs2VFZsSwJNgXDeN51UJ2ujw=
X-Received: by 2002:a05:6830:2141:: with SMTP id r1mr13923523otd.39.1576834836200;
 Fri, 20 Dec 2019 01:40:36 -0800 (PST)
MIME-Version: 1.0
References: <CAKxSbF2XaqwLAby0BBbhT_8vBviMvkA_7fiK-ivAs2DHWqARxw@mail.gmail.com>
In-Reply-To: <CAKxSbF2XaqwLAby0BBbhT_8vBviMvkA_7fiK-ivAs2DHWqARxw@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 20 Dec 2019 10:40:25 +0100
Message-ID: <CAJ8uoz1wP0MGg6yODd31eoDL4i-4mgRP2jd9BF-F9eqF3P2t6w@mail.gmail.com>
Subject: Re: getsockopt(XDP_MMAP_OFFSETS) syscall ABI breakage?
To:     Alex Forster <aforster@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 10:47 PM Alex Forster <aforster@cloudflare.com> wrote:
>
> The getsockopt(XDP_MMAP_OFFSETS) socket option returns a struct
> xdp_mmap_offsets (from uapi/linux/if_xdp.h) which is defined as:
>
>     struct xdp_mmap_offsets {
>         struct xdp_ring_offset rx;
>         struct xdp_ring_offset tx;
>         struct xdp_ring_offset fr; /* Fill */
>         struct xdp_ring_offset cr; /* Completion */
>     };
>
> Prior to kernel 5.4, struct xdp_ring_offset (from the same header) was
> defined as:
>
>     struct xdp_ring_offset {
>         __u64 producer;
>         __u64 consumer;
>         __u64 desc;
>     };
>
> A few months ago, in 77cd0d7, it was changed to the following:
>
>     struct xdp_ring_offset {
>         __u64 producer;
>         __u64 consumer;
>         __u64 desc;
>         __u64 flags;
>     };
>
> I believe this constitutes a syscall ABI breakage, which I did not
> think was allowed. Have I misunderstood the current stability
> guarantees for AF_XDP?

Version 5.4 and above supports both the old definition and the new. If
you enter the size of the old struct xdp_mmap_offsets into the
getsockopt, you get the results in the form that was there before 5.4.
If you enter the size of the new struct, you get the results in the
new form introduced in commit 77cd0d7.

> Alex Forster
