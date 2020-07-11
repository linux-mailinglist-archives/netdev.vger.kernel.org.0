Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCEA21C4E7
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 17:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbgGKPxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 11:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728390AbgGKPxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 11:53:38 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0B8C08C5DD
        for <netdev@vger.kernel.org>; Sat, 11 Jul 2020 08:53:38 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id e13so8289709qkg.5
        for <netdev@vger.kernel.org>; Sat, 11 Jul 2020 08:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Vxsv99WlZ5LulTTgQhIQ3IrcOEfFeudcZ7xM4E8EheA=;
        b=K1bNiPrqymGq8XIFvoCUWqa0xkdXNJEaGD1/ftNfQ3jvtHfG5nrr8ZO4Pgop0s5EA+
         vHE62OWwqYITiyM7tXwCGeWlBubNAj8XVl3yvxMxezLXjbf+ZTckEMNr7AY/OgPmYQ9+
         KxcrnGi7x6nXYlFBaOeEV3xUPBacNkTuCIGSi3YS40IzH/LYHFuXO4rydl0jZdUUTmb/
         cky85gl9A2gIQ6RKCPe0qYNH3rHv3s6juJCPrJgtl0hLEwHmshMf44U0KHHleMdTFx22
         hmP25hpukgQWnma7o1QMw4BW6c0TtqENEuRbKBsUfyRqC4XLxJ3SPLGmsmQscjyClSZh
         dDFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Vxsv99WlZ5LulTTgQhIQ3IrcOEfFeudcZ7xM4E8EheA=;
        b=UyIrfNv6SzxO6M+rT7g7v0OkNv3QUOlWmfV4N7rDff5AALdUA/jYJ7WeaSgeIfhd2d
         JNLKi7p4gl/CpnuNePBkVk3jdRVrEv2Y0Q21K0Ief85T7OFKaQLfv02t+ArMbBYaMR2M
         4e/mys8kTQ2yJIXLZ/3RPjgDv4d2G5YRxBG8dpxa6gmnHOrjGOS7i+yG6qJOMMAfPR+g
         4dd2IhYP0gfhUG0YoS0gddgyZiZqyaBscDiLQAff9fB+oMdmZHA8N0bv7meDaapNv19Y
         U1d13Of7IuVBQIOacssmLrRrswO/tJuCrwK+Ojhf7c8UL+uxevnx/DHPK5dh47fa1UFm
         CgOQ==
X-Gm-Message-State: AOAM533HZSClaBgqnaZCR5lklG0JDyUt40tWpTZ1b7fTGR6uG12g6qFC
        G5p6Qx4pXkap8vzais75wok6Pu697SgvZSVquXYJlEbk
X-Google-Smtp-Source: ABdhPJzOfZhallAeT8xdnABIIp7VbOpm8F2VeFMmPNWKnLXvfVKffS7GY97hbmpIQVMO5Doty5vky6o1P/jhtBug+eI=
X-Received: by 2002:a37:8283:: with SMTP id e125mr71192009qkd.175.1594482816897;
 Sat, 11 Jul 2020 08:53:36 -0700 (PDT)
MIME-Version: 1.0
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Sat, 11 Jul 2020 17:53:25 +0200
Message-ID: <CAA85sZvKNXCo5bB5a6kKmsOUAiw+_daAVaSYqNW6QbSBJ0TcyQ@mail.gmail.com>
Subject: NAT performance issue 944mbit -> ~40mbit
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I first detected this with 5.7.6 but it seems to apply as far back as 5.6.1...
(so, 5.7.8 client -> nat (5.6.1 -> 5.8-rc4 -> server 5.7.7)

It seems to me that the window size doesn't advance, so i did revert
the tcp: grow window for OOO packets only for SACK flows [1]
but it did no difference...

I have a 384 MB tcpdump of a iperf3 session that starts low and then
actually starts to get the bandwidth...
I do use BBR - I have tried with cubic... it didn't help  - the NAT
machine does use fq but changing it doesn't seem to yield any other
results.

Doing -P10 gives you the bandwith and can sometimes break the
stalemate but you'll end up back with the lower transfer speed again.
(it only seems to apply to NAT - the machine is a: A2SDi-12C-HLN4F and
has handled this without problems in the past...)


[1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.7.8&id=bf780119617797b5690e999e59a64ad79a572374

First iperf3 as a reference:
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec   113 MBytes   945 Mbits/sec    0    814 KBytes
[  5]   1.00-2.00   sec   109 MBytes   912 Mbits/sec    0    806 KBytes
[  5]   2.00-3.00   sec   112 MBytes   944 Mbits/sec   31    792 KBytes
[  5]   3.00-4.00   sec   101 MBytes   849 Mbits/sec   31   1.18 MBytes
[  5]   4.00-5.00   sec   108 MBytes   902 Mbits/sec    0    783 KBytes
[  5]   5.00-6.00   sec   111 MBytes   933 Mbits/sec   31    778 KBytes
[  5]   6.00-7.00   sec   111 MBytes   933 Mbits/sec   93    772 KBytes
[  5]   7.00-8.00   sec   112 MBytes   944 Mbits/sec    0    778 KBytes
[  5]   8.00-9.00   sec   111 MBytes   933 Mbits/sec   60    778 KBytes
[  5]   9.00-10.00  sec   111 MBytes   933 Mbits/sec   92    814 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  1.07 GBytes   923 Mbits/sec  338             sender
[  5]   0.00-10.01  sec  1.07 GBytes   919 Mbits/sec                  receiver

After that:
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  4.77 MBytes  40.0 Mbits/sec    0   42.4 KBytes
[  5]   1.00-2.00   sec  4.10 MBytes  34.4 Mbits/sec    0   84.8 KBytes
[  5]   2.00-3.00   sec  4.60 MBytes  38.6 Mbits/sec    0   87.7 KBytes
[  5]   3.00-4.00   sec  4.23 MBytes  35.4 Mbits/sec    0   42.4 KBytes
[  5]   4.00-5.00   sec  4.23 MBytes  35.4 Mbits/sec    0   42.4 KBytes
[  5]   5.00-6.00   sec  4.47 MBytes  37.5 Mbits/sec    0   76.4 KBytes
[  5]   6.00-7.00   sec  5.47 MBytes  45.9 Mbits/sec    0   67.9 KBytes
[  5]   7.00-8.00   sec  4.66 MBytes  39.1 Mbits/sec    0   67.9 KBytes
[  5]   8.00-9.00   sec  4.35 MBytes  36.5 Mbits/sec    0   82.0 KBytes
[  5]   9.00-10.00  sec  4.66 MBytes  39.1 Mbits/sec    0    139 KBytes
- - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec  45.5 MBytes  38.2 Mbits/sec    0             sender
[  5]   0.00-10.00  sec  45.0 MBytes  37.8 Mbits/sec                  receiver

You even get some:
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.00   sec  5.38 MBytes  45.2 Mbits/sec    0   42.4 KBytes
[  5]   1.00-2.00   sec  7.08 MBytes  59.4 Mbits/sec    0    535 KBytes
[  5]   2.00-3.00   sec   108 MBytes   907 Mbits/sec    0    778 KBytes
[  5]   3.00-4.00   sec   111 MBytes   933 Mbits/sec    0    814 KBytes
[  5]   4.00-5.00   sec  91.2 MBytes   765 Mbits/sec    0    829 KBytes
[  5]   5.00-6.00   sec   111 MBytes   933 Mbits/sec    0    783 KBytes
[  5]   6.00-7.00   sec   111 MBytes   933 Mbits/sec    0    769 KBytes
[  5]   7.00-8.00   sec   111 MBytes   933 Mbits/sec    0    778 KBytes
[  5]   8.00-9.00   sec   112 MBytes   944 Mbits/sec    0    809 KBytes
[  5]   9.00-10.00  sec   110 MBytes   923 Mbits/sec    0    823 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bitrate         Retr
[  5]   0.00-10.00  sec   879 MBytes   738 Mbits/sec    0             sender
[  5]   0.00-10.00  sec   875 MBytes   734 Mbits/sec                  receiver
