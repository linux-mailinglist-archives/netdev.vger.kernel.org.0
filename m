Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9822F16558E
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 04:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbgBTDU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 22:20:56 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:45780 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727208AbgBTDU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 22:20:56 -0500
Received: by mail-oi1-f194.google.com with SMTP id v19so26112868oic.12
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 19:20:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3g9ny8qShoh6dwLQH1tGwzn6YqLZGE9IA++ZzhHFydM=;
        b=N39NhlLaG4tTN2vDL1leXjxuiKyn612ufQcufzBhlNv5Yq8sn+7XKCwlYRI4HPSiVL
         LhhtFRb0TxMatMVJ+EwkPu7rMyVhpnERrwLbSR6cRBry8fvjVVxHaI8hA1EXGFwaTPiB
         CsfjZ9C0B61l8Rn8CsUv7FNOX08M5kmSb8A6QLTpDUpmmOhP6Oaux3IjROKiSLlARq1H
         5KjH0aYgJ+BsJkAKKwumm4ESN/pBNDQIkQEmPAymI2oAfZkkkcaDPOtPRFEewMcj6EkG
         oO5qwSsRkHJhk7GCmJVMCk0IIzom4JzPtsSJSVssE+9xiR266vTP9p3kjKDDSdVoDs25
         no7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3g9ny8qShoh6dwLQH1tGwzn6YqLZGE9IA++ZzhHFydM=;
        b=rbPrxwcbGlsnj/Gn3Dt08IleQi9GfZf7th8ktzGUZAROD7hyuSD8Oa+PRDS7ZE9F3h
         rcRgmrRXtUjliA8+cUhI88QJ/jsEh0l2uP1JTWlroFC42nJ+o9bkp9aOQSMR79gpJvFH
         p/SRG+EAumGMVYRcAtaIv38eJebPUCvu1VHGoska8JXlRdspQj37K/a5R/NRRrRWAk9d
         OCUlCXK76+oa08lkhBpsXesPcsyaqqOaVnQNh3g3JcHUf4bg+KHqPfdtBmQ15GOTUbES
         9nq2DLkPbAApjoYqp31jtAqNzgEENfqW5FUfkCgWBjnAOD4of9tS6tau/nD9yUBp8XCO
         yvjQ==
X-Gm-Message-State: APjAAAU6ZznRpj2vEbwoVszQcmX3Resr2in+gSQequeflYlBQuOnEMn5
        B2E7v4WdGX90XzEGtx0rHGA+THQxPXeB8+12w8o=
X-Google-Smtp-Source: APXvYqyOQJopJxdlyHgA5IUQzc3a87712Y0D17BySh96grA8+SBEAgCH6lI9Io46pRdBGze5mlCkJWzkJccgZF25Zp4=
X-Received: by 2002:aca:fc0c:: with SMTP id a12mr614803oii.118.1582168855493;
 Wed, 19 Feb 2020 19:20:55 -0800 (PST)
MIME-Version: 1.0
References: <20200212014107.110066-1-bpoirier@cumulusnetworks.com>
 <46537e63-1ba9-5e76-fad3-03cae4d0d60f@gmail.com> <20200217031223.GA35587@f3>
In-Reply-To: <20200217031223.GA35587@f3>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 19 Feb 2020 19:20:42 -0800
Message-ID: <CAM_iQpXY0L-ghJaHbLwAupMCiQzyEVe9XLJcWd4umm7sxBbftw@mail.gmail.com>
Subject: Re: [PATCH net 1/2] ipv6: Fix route replacement with dev-only route
To:     Benjamin Poirier <bpoirier@cumulusnetworks.com>
Cc:     David Ahern <dsahern@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        =?UTF-8?Q?Michal_Kube=C4=8Dek?= <mkubecek@suse.cz>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Ido Schimmel <idosch@idosch.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 16, 2020 at 7:12 PM Benjamin Poirier
<bpoirier@cumulusnetworks.com> wrote:
>
> On 2020/02/15 11:00 -0700, David Ahern wrote:
> [...]
> >
> > Thanks for adding a test case. I take this to mean that all existing
> > tests pass with this change. We have found this code to be extremely
> > sensitive to seemingly obvious changes.
>
> I saw two failures from that test suite, regardless of this change:
>
> IPv4 rp_filter tests
>     TEST: rp_filter passes local packets                                [FAIL]
>     TEST: rp_filter passes loopback packets                             [FAIL]
>
> The other tests, including the ipv6_rt group of tests, are OK.
>
>
> The rp_filter tests fail for me even if I build a kernel from commit
> adb701d6cfa4 ("selftests: add a test case for rp_filter")
>
> Running the first ping manually, tcpdump shows:
> root@vsid:~# tcpdump -nepi lo
> tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
> listening on lo, link-type EN10MB (Ethernet), capture size 262144 bytes
> 12:01:12.618623 52:54:00:6a:c7:5e > 52:54:00:6a:c7:5e, ethertype IPv4 (0x0800), length 98: 198.51.100.1 > 198.51.100.1: ICMP echo request, id 616, seq 435, length 64
> 12:01:12.618650 52:54:00:6a:c7:5e > 52:54:00:6a:c7:5e, ethertype IPv4 (0x0800), length 98: 198.51.100.1 > 198.51.100.1: ICMP echo reply, id 616, seq 435, length 64
>
> `ping` doesn't show any replies (since it's bound to dummy1...?).

I suspect this is related to the version of ping, as it works perfectly
for me on an old Fedora:

IPv4 rp_filter tests
ping: Warning: source address might be selected on device other than dummy1.
PING 198.51.100.1 (198.51.100.1) from 198.51.100.1 dummy1: 56(84) bytes of data.
64 bytes from 198.51.100.1: icmp_seq=1 ttl=64 time=0.452 ms
64 bytes from 198.51.100.1: icmp_seq=2 ttl=64 time=0.418 ms
64 bytes from 198.51.100.1: icmp_seq=3 ttl=64 time=0.485 ms
64 bytes from 198.51.100.1: icmp_seq=4 ttl=64 time=0.446 ms
64 bytes from 198.51.100.1: icmp_seq=5 ttl=64 time=0.388 ms
64 bytes from 198.51.100.1: icmp_seq=6 ttl=64 time=0.362 ms
64 bytes from 198.51.100.1: icmp_seq=7 ttl=64 time=0.373 ms
64 bytes from 198.51.100.1: icmp_seq=8 ttl=64 time=0.515 ms
64 bytes from 198.51.100.1: icmp_seq=9 ttl=64 time=0.641 ms

--- 198.51.100.1 ping statistics ---
9 packets transmitted, 9 received, 0% packet loss, time 8012ms
rtt min/avg/max/mdev = 0.362/0.453/0.641/0.083 ms
    TEST: rp_filter passes local packets                                [ OK ]


I do see the same failure on a new Fedora. So, I will take a look
at this tomorrow.

Thanks!
