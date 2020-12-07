Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D072D14A6
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 16:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbgLGP0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 10:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgLGP0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 10:26:10 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C327C061793
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 07:25:30 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id r17so12469398ilo.11
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 07:25:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Uet7jOSWGSMmrkCLu1M1tIB1UFY2TuovlvGBTfJXDos=;
        b=bXcPFPj7b/p9PTgaxnfklSaCtv5D3FXr72XlilxCgoH7Te/G8fvRzkps5xq3jTygKs
         opwQZ2WxxEGGf4k58wF6Wu/xIfv6cZLBpeb6ESpHNstDcNN2atlqhrKjMgj51TsUUgRe
         emMjGHc/GbQFLJMdsJgDkPjYKoNC033DRHtJEGoCcNioebRlKta55Z6VPTXbCPLfCVvb
         kdweR6OSjziRs6CF3ezTWYBJCix21XaWPf04SkxxXXdTxOlmX6Qtbykp38423ggEa6Qa
         I4HrQe85AZ6EjF0x2cVGQN2Z2tniU2F2/9cvcU1Ith70ER8LDyW/L6CCZrYYCXR+zpBQ
         ZB/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Uet7jOSWGSMmrkCLu1M1tIB1UFY2TuovlvGBTfJXDos=;
        b=h2Ug+8NPMJTVlI9LtRteeiONfCkFiDKARS94KN71MUqXqEa7wv7cM+4BAlBqL4XYJI
         GnNi8CzDafD9eU1pw0BSlYwo3eFssR/xUEGRc3056tS1rzHje/VMOs/1xCAQ9wzUQEL3
         rgQ0tSd1wVfmTA/2ak6T3QOrdNYfgmGoMd3J+SMSryjok9F0AlhsVqLAZLxJ+gbqV7JJ
         DKF5eKCrxCvcMxygWQj5B7IfE9Q+Gnc9ihw+/Ctm7VlJNNOejTanzQ+yxC6VeFWnJngD
         xKj5UylEuneWq9XSkNrmIbYO7YDYHn50lhjNhqQfF9a5LKG9UWqupOELh12WHVqmq0jl
         Ecxw==
X-Gm-Message-State: AOAM531kIe5guVe4P8/KkMh39T9tUxOlT+C2MRVp3bi6S/RDSVkW3qvL
        lVbpVn/TNyCNgYsdhhVKw/gZLSWYWQLFGiWtaLS1zg==
X-Google-Smtp-Source: ABdhPJwUyBnHZ0e8dS+madvprroq9nMIZZ/fa0+cNzOgpCjMXZ64sb7bWyd1XqnAk7TkvsgPDmLX8vLpTqHE2TGSz2I=
X-Received: by 2002:a92:d0ca:: with SMTP id y10mr13211293ila.68.1607354729664;
 Mon, 07 Dec 2020 07:25:29 -0800 (PST)
MIME-Version: 1.0
References: <20201204180622.14285-1-abuehaze@amazon.com> <44E3AA29-F033-4B8E-A1BC-E38824B5B1E3@amazon.com>
 <CANn89iJgJQfOeNr9aZHb+_Vozgd9v4S87Kf4iV=mKhuPDGLkEg@mail.gmail.com> <3F02FF08-EDA6-4DFD-8D93-479A5B05E25A@amazon.com>
In-Reply-To: <3F02FF08-EDA6-4DFD-8D93-479A5B05E25A@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 7 Dec 2020 16:25:17 +0100
Message-ID: <CANn89iL_5QFGQLzxxLyqfNMGiV2wF4CbkY==x5Sh5vqKOTgFtw@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: optimise receiver buffer autotuning
 initialisation for high latency connections
To:     "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "ycheng@google.com" <ycheng@google.com>,
        "ncardwell@google.com" <ncardwell@google.com>,
        "weiwan@google.com" <weiwan@google.com>,
        "Strohman, Andy" <astroh@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 5, 2020 at 1:03 PM Mohamed Abuelfotoh, Hazem
<abuehaze@amazon.com> wrote:
>
> Unfortunately few things are missing in this report.
>
>     What is the RTT between hosts in your test ?
>      >>>>>RTT in my test is 162 msec, but I am able to reproduce it with =
lower RTTs for example I could see the issue downloading from google   endp=
oint with RTT of 16.7 msec, as mentioned in my previous e-mail the issue is=
 reproducible whenever RTT exceeded 12msec given that    the sender is usin=
g bbr.
>
>         RTT between hosts where I run the iperf test.
>         # ping 54.199.163.187
>         PING 54.199.163.187 (54.199.163.187) 56(84) bytes of data.
>         64 bytes from 54.199.163.187: icmp_seq=3D1 ttl=3D33 time=3D162 ms
>         64 bytes from 54.199.163.187: icmp_seq=3D2 ttl=3D33 time=3D162 ms
>         64 bytes from 54.199.163.187: icmp_seq=3D3 ttl=3D33 time=3D162 ms
>         64 bytes from 54.199.163.187: icmp_seq=3D4 ttl=3D33 time=3D162 ms
>
>         RTT between my EC2 instances and google endpoint.
>         # ping 172.217.4.240
>         PING 172.217.4.240 (172.217.4.240) 56(84) bytes of data.
>         64 bytes from 172.217.4.240: icmp_seq=3D1 ttl=3D101 time=3D16.7 m=
s
>         64 bytes from 172.217.4.240: icmp_seq=3D2 ttl=3D101 time=3D16.7 m=
s
>         64 bytes from 172.217.4.240: icmp_seq=3D3 ttl=3D101 time=3D16.7 m=
s
>         64 bytes from 172.217.4.240: icmp_seq=3D4 ttl=3D101 time=3D16.7 m=
s
>
>     What driver is used at the receiving side ?
>       >>>>>>I am using ENA driver version version: 2.2.10g on the receive=
r with scatter gathering enabled.
>
>         # ethtool -k eth0 | grep scatter-gather
>         scatter-gather: on
>                 tx-scatter-gather: on
>                 tx-scatter-gather-fraglist: off [fixed]

This ethtool output refers to TX scatter gather, which is not relevant
for this bug.

I see ENA driver might use 16 KB per incoming packet (if ENA_PAGE_SIZE is 1=
6 KB)

Since I can not reproduce this problem with another NIC on x86, I
really wonder if this is not an issue with ENA driver on PowerPC
perhaps ?
