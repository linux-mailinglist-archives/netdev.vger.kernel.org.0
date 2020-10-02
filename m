Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0645A280F41
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 10:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgJBIvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 04:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgJBIvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 04:51:20 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA8CC0613D0;
        Fri,  2 Oct 2020 01:51:20 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id b19so550603lji.11;
        Fri, 02 Oct 2020 01:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=i9UuqBprgLgN+56WyW7bVdQAfR56QqIoXp2EYG3DzI8=;
        b=RTxIg94Qhj4nu/2O9OLnchT6Zp4Au+NXTqkr1j9MF1E4SIWvA8P4Vwqle3kHLif9BG
         ZB7YmXD6O/NPxZuQKjDdNO/IVP8bPNxpx4VpN27f5geWxUDlovYeL4VVyV7qPne11V8l
         rbpFJD+Jmy3e6BREPy6SZkVkjcz+P94BtyWT7jYw6M7DCzugNrNia8cv4TchVKh2mWt8
         4lKUH8em1NoJDrYOs7GnjkowgJu9IuA2wvyOW/NhaZOIY3jZ/G6uMljdmNwdXt4RpWpq
         fRKknXxGwU9AePsGwQ4gabniJLlW2Hx7Dy6fSC0ysbuZl/MjwXjuIV3YqbAeKlbtyBsY
         XNgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=i9UuqBprgLgN+56WyW7bVdQAfR56QqIoXp2EYG3DzI8=;
        b=KAt01vqH0aHrqwiyqPZSL3IY8jCnE+SmAKHZdvfH/X1m8Mr/hYfUOby7GZQIX2vnrp
         jJlQ+zrOXyCcf5pR0eSeGeXjGx6wOQCX2Wn7+JPwfDs/Mu7oUatgiipZ6tmytkfAZpLC
         KSf85ClEvpcV7+KwGnFpIwfdeYDshzY/THvUfs+qtvM33R65NH5WkPcu2L6w2AXpGA66
         pAbt6xoxR8FQJDtE+wHMeDLfWMWvwxB+wPN2X9vBtHp3zZjEAFfx6frL7crRJ9QN1YeX
         mkXtqty3fT/BiocAC6pu5tndf/uaZj4XqwmOQSRKtf774UGWAj1DfEgCCn/zq9beWBof
         9QXg==
X-Gm-Message-State: AOAM532BE1mc/G01Ol4mJ059Q+AgIRROFxTUxQFzua46jkHjUxfxRgED
        1EHqszoCz1D0NYVuTZ6gNabJLmXjfaDjbdEEIZGmOJgpuDE=
X-Google-Smtp-Source: ABdhPJzTTOib4aoP23sqvPAGEo1rJYMk0OD+MFvQRWzwDvKzB8l88C9pOE7f/U41j9KtJuhf7AyWtHpyBlRVg4CjEYA=
X-Received: by 2002:a2e:7014:: with SMTP id l20mr431835ljc.91.1601628678212;
 Fri, 02 Oct 2020 01:51:18 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?5Y+25bCP6b6Z?= <muryo.ye@gmail.com>
Date:   Fri, 2 Oct 2020 16:51:07 +0800
Message-ID: <CAP0D=1X946M=yy=hMBvXuT11paPqxMi_xens-R4m7vyCnkUQzw@mail.gmail.com>
Subject: Why ping latency is smaller with shorter send interval?
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, net experts,

Hope this is the right place to ask the question :)

Recently I've tried to measure the network latency between two
machines by using ping, one interesting observation I found is that
ping latency will be smaller if I use a shorter interval with -i
option. For example,

when I use default ping (interval is 1s), then the ping result is as
below with avg latency 0.062ms

# ping 9.9.9.2 -c 10
PING 9.9.9.2 (9.9.9.2) 56(84) bytes of data.
64 bytes from 9.9.9.2: icmp_seq=1 ttl=64 time=0.059 ms
64 bytes from 9.9.9.2: icmp_seq=2 ttl=64 time=0.079 ms
64 bytes from 9.9.9.2: icmp_seq=3 ttl=64 time=0.060 ms
64 bytes from 9.9.9.2: icmp_seq=4 ttl=64 time=0.072 ms
64 bytes from 9.9.9.2: icmp_seq=5 ttl=64 time=0.048 ms
64 bytes from 9.9.9.2: icmp_seq=6 ttl=64 time=0.069 ms
64 bytes from 9.9.9.2: icmp_seq=7 ttl=64 time=0.067 ms
64 bytes from 9.9.9.2: icmp_seq=8 ttl=64 time=0.055 ms
64 bytes from 9.9.9.2: icmp_seq=9 ttl=64 time=0.058 ms
64 bytes from 9.9.9.2: icmp_seq=10 ttl=64 time=0.055 ms

--- 9.9.9.2 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9001ms
rtt min/avg/max/mdev = 0.048/0.062/0.079/0.010 ms

Then I use "-i 0.001", the lateny (0.038) is way better than defaut ping

# ping 9.9.9.2 -i 0.001 -c 10
PING 9.9.9.2 (9.9.9.2) 56(84) bytes of data.
64 bytes from 9.9.9.2: icmp_seq=1 ttl=64 time=0.069 ms
64 bytes from 9.9.9.2: icmp_seq=2 ttl=64 time=0.039 ms
64 bytes from 9.9.9.2: icmp_seq=3 ttl=64 time=0.034 ms
64 bytes from 9.9.9.2: icmp_seq=4 ttl=64 time=0.033 ms
64 bytes from 9.9.9.2: icmp_seq=5 ttl=64 time=0.033 ms
64 bytes from 9.9.9.2: icmp_seq=6 ttl=64 time=0.033 ms
64 bytes from 9.9.9.2: icmp_seq=7 ttl=64 time=0.034 ms
64 bytes from 9.9.9.2: icmp_seq=8 ttl=64 time=0.036 ms
64 bytes from 9.9.9.2: icmp_seq=9 ttl=64 time=0.037 ms
64 bytes from 9.9.9.2: icmp_seq=10 ttl=64 time=0.038 ms

--- 9.9.9.2 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9ms
rtt min/avg/max/mdev = 0.033/0.038/0.069/0.012 ms


ping loopback shows the similar result.

Default ping avg latency is 0.049ms

# ping 127.0.0.1 -c 10
PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.032 ms
64 bytes from 127.0.0.1: icmp_seq=2 ttl=64 time=0.049 ms
64 bytes from 127.0.0.1: icmp_seq=3 ttl=64 time=0.054 ms
64 bytes from 127.0.0.1: icmp_seq=4 ttl=64 time=0.058 ms
64 bytes from 127.0.0.1: icmp_seq=5 ttl=64 time=0.049 ms
64 bytes from 127.0.0.1: icmp_seq=6 ttl=64 time=0.042 ms
64 bytes from 127.0.0.1: icmp_seq=7 ttl=64 time=0.052 ms
64 bytes from 127.0.0.1: icmp_seq=8 ttl=64 time=0.052 ms
64 bytes from 127.0.0.1: icmp_seq=9 ttl=64 time=0.053 ms
64 bytes from 127.0.0.1: icmp_seq=10 ttl=64 time=0.055 ms

--- 127.0.0.1 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9001ms
rtt min/avg/max/mdev = 0.032/0.049/0.058/0.010 ms

ping with "-i 0.001" shows 0.014ms avg latency.

# ping 127.0.0.1 -i 0.001 -c 10
PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.040 ms
64 bytes from 127.0.0.1: icmp_seq=2 ttl=64 time=0.014 ms
64 bytes from 127.0.0.1: icmp_seq=3 ttl=64 time=0.012 ms
64 bytes from 127.0.0.1: icmp_seq=4 ttl=64 time=0.011 ms
64 bytes from 127.0.0.1: icmp_seq=5 ttl=64 time=0.011 ms
64 bytes from 127.0.0.1: icmp_seq=6 ttl=64 time=0.011 ms
64 bytes from 127.0.0.1: icmp_seq=7 ttl=64 time=0.011 ms
64 bytes from 127.0.0.1: icmp_seq=8 ttl=64 time=0.010 ms
64 bytes from 127.0.0.1: icmp_seq=9 ttl=64 time=0.010 ms
64 bytes from 127.0.0.1: icmp_seq=10 ttl=64 time=0.011 ms

--- 127.0.0.1 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9ms
rtt min/avg/max/mdev = 0.010/0.014/0.040/0.008 ms

I'm using centos 7.2 with kernel 3.10.

I am very confused about the result. As I understand it, it doesn't
matter how frequently I send packets, each packet's latency should be
the same. So How can I understand it from network stack point of view?

Any thoughts or suggestions would be highly appreciated.


Thanks,
Xiaolong
