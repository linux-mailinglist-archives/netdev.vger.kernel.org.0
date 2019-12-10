Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79ED811998C
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbfLJVce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:32:34 -0500
Received: from mail-ed1-f47.google.com ([209.85.208.47]:37247 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728813AbfLJVce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 16:32:34 -0500
Received: by mail-ed1-f47.google.com with SMTP id cy15so17357733edb.4
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 13:32:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=4Ja+Cy4lz3d7/9D3E5SJdSwFwUmUfYYIZtw7SRnmxMQ=;
        b=xSLCrrxPejnE0kdt17030quLJkQSeBjnB1vQJo4e7EaofNY9vrZMLRjLWjTUAcCSCT
         yuxr7DHf+2HvLYOySwaOiOuJZYvB0oesOytWvM4DmGl/IhueidOi+nYm0/KXxlf2GwEa
         eXFXrese8dp5z5H0DwYhE+Ts7EObyeM8Pthks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=4Ja+Cy4lz3d7/9D3E5SJdSwFwUmUfYYIZtw7SRnmxMQ=;
        b=teaSzDoXbRBwqPbMTk1Oc03Ot2XDPWrkKiLNPQYe3Qu0gzNTQkYmWf9+tgnZBoF4wA
         PW5Opi5mILXmQF3zNCNshAJE7VSxijOwRwHmpq/a1gxs8rSFjQAwzZrMdCwahqyC+9xa
         6W0CD0UBT5E3lGTIyd6D+3Rs5hrG3R+B+KYCFnFxyGyakr0VJfHzRdol64NfR8ZFDlyk
         JsezY5wd+EuI99w6x+BnTGwVVRZBlw0GzH6a9atEa52EB13I2Eao/RPfW5Bg3BFehVqj
         dASNNi3wSTpyzoEoBxOWCIiAP3i5xlXcD/VkPZHj22iC2KYmkXDcnW4hiHV5q84FWawE
         J/7w==
X-Gm-Message-State: APjAAAWXyJwfSmujgRG6Qu2ygOAFIwPEtEOdRWk3crCTmmBUb+zhR0Fn
        4apK1opCkOnUvIbf7Ya1u47ft92wt8uQCovKHFdrbw==
X-Google-Smtp-Source: APXvYqy8VOTXuAbKw0j1c3O8zCSGmAQsSkjj1KkDXdHcwLguds5DtEdZJNT8Hy/+moiMk2YEf22e7OKRLAhqNqpl30A=
X-Received: by 2002:a17:906:2e47:: with SMTP id r7mr6151354eji.215.1576013552064;
 Tue, 10 Dec 2019 13:32:32 -0800 (PST)
MIME-Version: 1.0
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Tue, 10 Dec 2019 13:32:21 -0800
Message-ID: <CABWYdi2GG3qi6ucxtyk3=Bu1eXi0N9Dow42F4gzi9DUUc3XhLw@mail.gmail.com>
Subject: Lock contention around unix_gc_lock
To:     linux-kernel <linux-kernel@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, hare@suse.com,
        axboe@kernel.dk, allison@lohutok.net, tglx@linutronix.de,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

We're seeing very high contention on unix_gc_lock when a bug in an
application makes it stop reading incoming messages with inflight unix
sockets. In our system we churn through a lot of unix sockets and we
have 96 logical CPUs in the system, so spinlock gets very hot.

I was able to halve overall system throughput with 1024 inflight unix
sockets, which is the default RLIMIT_NOFILE. This doesn't sound too
good for isolation, one user should not be able to affect the system
as much. One might even consider this as DoS vector.

There's a lot of time is spent in _raw_spin_unlock_irqrestore, which
is triggered by wait_for_unix_gc, which in turn is unconditionally
called from unix_stream_sendmsg:

ffffffff9f64f3ea _raw_spin_unlock_irqrestore+0xa
ffffffff9eea6ab0 prepare_to_wait_event+0x70
ffffffff9f5a4ac6 wait_for_unix_gc+0x76
ffffffff9f5a182c unix_stream_sendmsg+0x3c
ffffffff9f4bb7f9 sock_sendmsg+0x39

* https://elixir.bootlin.com/linux/v4.19.80/source/net/unix/af_unix.c#L1849

Even more time is spent in waiting on spinlock because of call to
unix_gc from unix_release_sock, where condition is having any inflight
sockets whatsoever:

ffffffff9eeb1758 queued_spin_lock_slowpath+0x158
ffffffff9f5a4718 unix_gc+0x38
ffffffff9f5a28f3 unix_release_sock+0x2b3
ffffffff9f5a2929 unix_release+0x19
ffffffff9f4b902d __sock_release+0x3d
ffffffff9f4b90a1 sock_close+0x11

* https://elixir.bootlin.com/linux/v4.19.80/source/net/unix/af_unix.c#L586

Should this condition take the number of inflight sockets into
account, just like unix_stream_sendmsg does via wait_for_unix_gc?

Static number of inflight sockets that trigger a GC from
wait_for_unix_gc may also be something that is scaled with system
size, rather than be a hardcoded value.

I know that our case is a pathological one, but it sounds like
scalability of garbage collection can be better, especially on systems
with large number of CPUs.
