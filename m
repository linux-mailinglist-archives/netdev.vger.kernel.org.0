Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 520CC130AA0
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 23:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgAEW7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 17:59:31 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:60639 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbgAEW7b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jan 2020 17:59:31 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id b4fa5bc8
        for <netdev@vger.kernel.org>;
        Sun, 5 Jan 2020 22:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=M/g4nKvIP90xJ38y+5F3RbYJTB0=; b=SBnaV7
        DVs829zthaxRM+QYoDL89x8KwDWTBQAqqm0e59dYd3STs+sGdSUvMHs2O3Fp1Jue
        mIs/xpUxe1D4IpZwh9tDt3WY7XZE6Qpl8AE9gNHdOFtX0Y4JlvfUJ+sr1L1XJTMj
        QOi/9r9aL6FoGK801Xa0FIGRjfD/EJ62J2sA/FRyZD37ylorm3u7U1LklUdjix75
        n4yHuvWk22pW88Y3FEIR8HNaf6F/RCjD3hZ/nUxnx9ms9Vsf6UyAKsviC3ppMmYR
        ze5z7/kqbwKbWxDNJQrLXC8rJMUr/wvnZjbUpd/P7393Sy3ONuK7MW1EuAfgAw9G
        tFaEMXIoZ+zQkqXQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c010a7b6 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Sun, 5 Jan 2020 22:00:33 +0000 (UTC)
Received: by mail-ot1-f44.google.com with SMTP id w21so61345559otj.7
        for <netdev@vger.kernel.org>; Sun, 05 Jan 2020 14:59:29 -0800 (PST)
X-Gm-Message-State: APjAAAUquyy/Sopxynt5TqIU3LYwP4dkB0suykVLxz0k756L0XcbM++D
        w50JWVXUGa26fXg7UvHpOvlhibi4cypMEdKvWRA=
X-Google-Smtp-Source: APXvYqwXcye/w3rqjPYgqUbmzCfDEilhbxTxOtjosTwImyEX2zx/01LklD3FbepSBa7gl5adOvQzN0y4cfj9Qm+IUsM=
X-Received: by 2002:a05:6830:1141:: with SMTP id x1mr38680783otq.120.1578265169043;
 Sun, 05 Jan 2020 14:59:29 -0800 (PST)
MIME-Version: 1.0
References: <20200102164751.416922-1-Jason@zx2c4.com> <20200105.141332.1037832872586677248.davem@davemloft.net>
In-Reply-To: <20200105.141332.1037832872586677248.davem@davemloft.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sun, 5 Jan 2020 17:59:18 -0500
X-Gmail-Original-Message-ID: <CAHmME9rJ2k6MJb3ZNf04iMphggofsQjo29eN+s_+OS7mbq5KdA@mail.gmail.com>
Message-ID: <CAHmME9rJ2k6MJb3ZNf04iMphggofsQjo29eN+s_+OS7mbq5KdA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] WireGuard bug fixes and cleanups
To:     David Miller <davem@davemloft.net>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 5, 2020 at 5:13 PM David Miller <davem@davemloft.net> wrote:
> Series applied.

Thanks!

>
> I wonder if, for patch #3, we should have a gro cells helper which just
> does that list thing and thus makes the situation self documenting.

I was thinking about something along those lines... If you recall from
the netdev presentation, wireguard encrypts/decrypts packets on
multiple cores and spreads packets out to whatever core is available.
In order to improve cache locality and fallout from scheduler latency,
the driver opts in to receive gso super packets, splits them up using
the function for that, and then encrypts that list as a unit, on a
single core. The result achieved is that alike packets are encrypted
together and not spread out. For the receive path, however, this is
not the case, since encap_recv gives us just one packet at a time. I
was thinking of reworking this to add an encap_recv_gro function, or
similar, which is passed entire lists.

Right now the implementation of udp_queue_rcv_skb is something along
the lines of:

if (!udp_unexpected_gso(skb))
    return encap_recv(skb);
else
    for_each_gso_seg(skb, seg)
        encap_recv(seg);

That bottom part could be split up into:

if (encap_recv_gro)
    encap_recv_gro(skb);
else
    for_each_gso_seg(skb, seg)
        encap_recv(seg);

I still need to look further into this (e.g. why it's "unexpected" as
in the "udp_unexpected_gso" function), and I vaguely recall Steffen
Klassart working on some similar ideas. But I may post an RFC
something to this effect in the coming weeks.

Jason
