Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD553F9D39
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 23:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfKLWm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 17:42:57 -0500
Received: from mail-lf1-f54.google.com ([209.85.167.54]:44166 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbfKLWm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 17:42:56 -0500
Received: by mail-lf1-f54.google.com with SMTP id z188so192940lfa.11;
        Tue, 12 Nov 2019 14:42:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=6rfwUBIlHszDeeP+FOVqAKDe8gfyDPoAQ0ZCP7b8JzU=;
        b=UAX4FVzh0ZrZ0Ahqrn7zURBp/B3kYzEK2di+1KEcgosF71dpMMXb7O1iNxJK13TI06
         qemGPrXL5Bk5wxCJcE30T0v3gxEi84EF/ofDincC/apyj/7WuT4TSGG0xS5THjFSejCW
         l1Xm2v71KqCksi6P4G7vHs8sy0+90m9/QI0ARpMhtud/NWYR5OapLkrXF+8Tlnbt6Jd6
         NlqJXZOXRo24HTTimxhTPRZeaCsg32PAFOPCQjyJtX6GLm+WjRUBhJVT7v9yWFtuoGnH
         5yEbAcxF950YczVvuICv7C7Vk/QPH8Dj2+juuGAGIb6BoIZYJVKaf+IsSre//1TmSiHh
         JsZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=6rfwUBIlHszDeeP+FOVqAKDe8gfyDPoAQ0ZCP7b8JzU=;
        b=n17xX2jS5aE0JmYBdIOojz3SQ903nPARnXZT3oF/KMkR1PkvmH2E5EszyzNgE2TT+2
         8IaKyTj48ulNaIP5j3i2JoaT8yqvxg0aWsT5prJnCjaKFT0bI8rR7Jg8C3koJzDyp+zi
         rgC0b13FhwsBTFXMJAtuyR9gxCOXY41j/dNCETpjGDHEEj4fMM4xUVMN1vukpUeSCeYL
         J8VoaOXhYdifM0mKDgX3nevrwlKitQMZjrNd3cCo6oN75CZmmj6MN3jssxiyqFKMN0Uh
         /im0T4tdW+gQXSK13MrTpPrjnNzQi+ipv37KWuRiNOe8QlXAPPhhnQFn26VF2byEWIhd
         LBIA==
X-Gm-Message-State: APjAAAVmUECLS21Fuo+boMmKPlXUxgePm0pekX9NI9Tg/tOP+oX6y1sL
        GhcyiSsiaQq19muWNgUc9WibxIV071kbKgwR1mU=
X-Google-Smtp-Source: APXvYqzOvuG/QGq8EED+9U1Hh5IV7qzHK2CHNNAM6wpVOVyj/EPbKTR5v+ClNd9MtV0LHetMwnxeh2Lc5FbOWIVIS0I=
X-Received: by 2002:ac2:5a11:: with SMTP id q17mr183667lfn.41.1573598573829;
 Tue, 12 Nov 2019 14:42:53 -0800 (PST)
MIME-Version: 1.0
From:   Paul Thomas <pthomas8589@gmail.com>
Date:   Tue, 12 Nov 2019 17:42:42 -0500
Message-ID: <CAD56B7dwKDKnrCjpGmrnxz2P0QpNWU3CGBvOtqg3RBx3ejPh9g@mail.gmail.com>
Subject: xdpsock poll with 5.2.21rt kernel
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I'm doing some testing with AF_XDP, and I'm seeing some behavior I
don't quite understand. It seems I can get into a situation where
xdpsock (from samples/bpf/scpsocke_user.c) is using most of the cpu
even though I'm trying to use poll().

To start with I run xdpsock with --rxdrop and --poll. At first this
behaves nicely, the cpu usage is very low:
# ps -AL -o pid,lwp,cmd,comm,rtprio,cpuid,pcpu | grep [x]dpsock
 1932  1932 ./xdpsock -r -p -i eth1     xdpsock              -     3  0.0
 1932  1933 ./xdpsock -r -p -i eth1     xdpsock              -     2  0.0

And strace shows nice orderly ppoll timeouts every second.
# strace -p 1932
strace: Process 1932 attached
ppoll([{fd=3, events=POLLIN}], 1, {tv_sec=0, tv_nsec=510616211}, NULL,
0) = 0 (Timeout)
ppoll([{fd=3, events=POLLIN}], 1, {tv_sec=1, tv_nsec=0}, NULL, 0) = 0 (Timeout)
ppoll([{fd=3, events=POLLIN}], 1, {tv_sec=1, tv_nsec=0}, NULL, 0) = 0 (Timeout)
...

Then I generate some traffic and ppoll() is not timing out anymore:
ppoll([{fd=3, events=POLLIN}], 1, {tv_sec=1, tv_nsec=0}, NULL, 0) = 1
([{fd=3, revents=POLLIN}], left {tv_sec=0, tv_nsec=999996790})
ppoll([{fd=3, events=POLLIN}], 1, {tv_sec=1, tv_nsec=0}, NULL, 0) = 1
([{fd=3, revents=POLLIN}], left {tv_sec=0, tv_nsec=999997260})
ppoll([{fd=3, events=POLLIN}], 1, {tv_sec=1, tv_nsec=0}, NULL, 0) = 1
([{fd=3, revents=POLLIN}], left {tv_sec=0, tv_nsec=999997100})

This is where it get's strange, if I stop the traffic, then strace no
longer generates any activity but the xdpsock cpu usage is way up:
# ps -AL -o pid,lwp,cmd,comm,rtprio,cpuid,pcpu | grep [x]dpsock
 1932  1932 ./xdpsock -r -p -i eth1     xdpsock              -     3 61.0
 1932  1933 ./xdpsock -r -p -i eth1     xdpsock              -     2  0.0

So is it getting stuck at while (ret != rcvd) in rx_drop()?

Is it a normal case to get past the poll() and then have
xsk_ring_cons__peek() not equal xsk_ring_prod__reserve()?

I see the added xsk_ring_prod__needs_wakeup() with the extra poll() in
the latest 5.4 kernels, but I don't think any of the needs_wakeup
stuff is in the 5.2 kernel. Is that needed for this case?

This is with a 5.2.21 preempt-rt kernel on arm64 using the macb driver
(so XDP_SKB and not XDP_DRV).

Any thoughts would be appreciated.

thanks,
Paul
