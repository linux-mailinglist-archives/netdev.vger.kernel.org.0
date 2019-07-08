Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B630762A31
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 22:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404891AbfGHULi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 16:11:38 -0400
Received: from mail-oi1-f171.google.com ([209.85.167.171]:40239 "EHLO
        mail-oi1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730045AbfGHULi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 16:11:38 -0400
Received: by mail-oi1-f171.google.com with SMTP id w196so13594861oie.7
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 13:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WFghjs0YXQNkbW/dKpc4Rcvk8JuzalmNZwHixfTxRwA=;
        b=lTP2Nk090WL8QMrioBkjXg6giQF+AiUlPy+lCiUYvSuxnyYds4QXk9UVEW2H+hRWzu
         oB81Xs+ZhAytKyP7+0Xe/Ry+65jBKDe6h6xv4Lhnjv7BJWHKmvPWthkhFVo8OMKxxp1J
         HGYCEhKCqqBkLoN8BlHy14os7v+7nlm2yXUxG15joEn4gpjDq0xYSajERtPPeDgAK2dz
         gBho2k6Xpn/Mddoc6muTHNkqPFFNP/jeMvFunfdcJTPfxsyyj9qTNrLZPnSbII++KWIa
         eFPpi3cLvkA7QWbVQOopJPjV6tThdDPos8PApVAI0/JS+hNdl2a5+gXzCKDMVKwXtnDe
         nkYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WFghjs0YXQNkbW/dKpc4Rcvk8JuzalmNZwHixfTxRwA=;
        b=tKfGAaIYioxyo90LGPJJM/2mzvY3X3+nQ9p++U+HDXOQgYOJ+mvJ8SOkZBRzUr51hy
         bfrSh6fDKrU0h3fctk+9yGX4OELHPSxmivxURAhGYT/onomz2td4xhGlj9y3O/kVVJuF
         U4bAD+KzwHRmZAcN96Hi2B7+B5OPS2jHnwcS+KonXaa5jesLGDpQLJo1EVtLDOGp1h5k
         11P/N8tddNlOJ5i1UcLVq7gLHRDGl+NS4biwfxr95Bn9ZdI766mc8y5j/eEq4FZznw1e
         OhHjgnaAynTEqi94ylbZmq5+FWhMMaWmeuF5EScIdsFl2287ZUbNJ6WLJUqIFViRYSR0
         zFxg==
X-Gm-Message-State: APjAAAWKpfScRQqeoLjMUzXwQYESz163FLIAAxKMiF4aLZoeGJogfJKQ
        KsrgxO5ujs3lyXXwj8QDJDUNAQac4pJjNcQRc/sl9Q/AkI6wSA==
X-Google-Smtp-Source: APXvYqzaTEYCFWJcI4ktDAgNstotgfzmUFdzwgPX73s0Eal+DT263LuHnVPN+pLvekQqVnPuu0m4bq34lQUghjXcBIU=
X-Received: by 2002:a05:6808:4d:: with SMTP id v13mr10227094oic.22.1562616697143;
 Mon, 08 Jul 2019 13:11:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190706034508.43aabff0@hikaru> <20190706181657.7ff57395@hikaru> <20190706201912.435a2198@hikaru>
In-Reply-To: <20190706201912.435a2198@hikaru>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 8 Jul 2019 16:11:20 -0400
Message-ID: <CADVnQynojNNJNszX5pV5EsOt+-pKnbH-Z4uEuJUyRX2aCPg8gQ@mail.gmail.com>
Subject: Re: Kernel BUG: epoll_wait() (and epoll_pwait) stall for 206 ms per
 call on sockets with a small-ish snd/rcv buffer.
To:     Carlo Wood <carlo@alinoe.com>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 6, 2019 at 2:19 PM Carlo Wood <carlo@alinoe.com> wrote:
>
> While investigating this further, I read on
> http://www.masterraghu.com/subjects/np/introduction/unix_network_programm=
ing_v1.3/ch07lev1sec5.html
> under "SO_RCVBUF and SO_SNDBUF Socket Options":
>
>     When setting the size of the TCP socket receive buffer, the
>     ordering of the function calls is important. This is because of
>     TCP's window scale option (Section 2.6), which is exchanged with
>     the peer on the SYN segments when the connection is established.
>     For a client, this means the SO_RCVBUF socket option must be set
>     before calling connect. For a server, this means the socket option
>     must be set for the listening socket before calling listen. Setting
>     this option for the connected socket will have no effect whatsoever
>     on the possible window scale option because accept does not return
>     with the connected socket until TCP's three-way handshake is
>     complete. That is why this option must be set for the listening
>     socket. (The sizes of the socket buffers are always inherited from
>     the listening socket by the newly created connected socket: pp.
>     462=E2=80=93463 of TCPv2.)
>
> As mentioned in a previous post, I had already discovered about
> needing to set the socket buffers before connect, but I didn't know
> about setting them before the call to listen() in order to get the
> buffer sizes inherited by the accepted sockets.
>
> After fixing this in my test program, all problems disappeared when
> keeping the send and receive buffers the same on both sides.
>
> However, when only setting the send and receive buffers on the client
> socket (not on the (accepted or) listen socket), epoll_wait() still
> stalls 43ms. When the SO_SNDBUF is smaller than 33182 bytes.
>
> Here is the latest version of my test program:
>
> https://github.com/CarloWood/ai-evio-testsuite/blob/master/src/epoll_bug.=
c
>
> I have to retract most of my "bug" report, it might even not really be
> a bug then... but nevertheless, what remains strange is the fact
> that setting the socket buffer sizes on the accepted sockets can lead
> to so much crippling effect, while the quoted website states:
>
>     Setting this option for the connected socket will have no effect
>     whatsoever on the possible window scale option because accept does
>     not return with the connected socket until TCP's three-way
>     handshake is complete.
>
> And when only setting the socket buffer sizes for the client socket
> (that I use to send back received data; so this is the sending
> side now) then why does epoll_wait() stall 43 ms per call when the
> receiving side is using the default (much larger) socket buffer sizes?
>
> That 43 ms is STILL crippling-- slowing down the transmission of the
> data to a trickling speed compared to what it should be.

Based on the magic numbers you cite, including the fact that this test
program seems to send traffic over a loopback device (presumably
MTU=3D65536), epoll_wait() stalling 43 ms (slightly longer than the
typical Linux delayed ACK timer), and the problem only happening if
SO_SNDBUF is smaller than 33182 bytes (half the MTU)... a guess would
be that when you artificially make the SO_SNDBUF that low, then you
are asking the kernel to only allow your sending sockets to buffer
less than a single MTU of data, which means that the packets the
sender sends are going to be less than the MTU, which means that the
receiver may tend to eventually (after the initial quick ACKs expire)
delay its ACKs in hopes of eventually receiving a full MSS of data
(see __tcp_ack_snd_check()). Since the SO_SNDBUF is so small in this
case, the sender then would not be able to write() or transmit
anything else until the receiver sends a delayed ACK for the data
~40ms later, allowing the sending socket to free the previously sent
data and trigger the sender's next EPOLLOUT and write().

You could try grabbing a packet capture of the traffic over your
loopback device during the test to see if it matches that theory:
  tcpdump  -i lo -s 100 -w /tmp/test.pcap

cheers,
neal
