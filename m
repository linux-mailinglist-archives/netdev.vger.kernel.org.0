Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A25C91100B0
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 15:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbfLCO73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 09:59:29 -0500
Received: from mail-qt1-f182.google.com ([209.85.160.182]:34801 "EHLO
        mail-qt1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfLCO73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 09:59:29 -0500
Received: by mail-qt1-f182.google.com with SMTP id 5so1507310qtz.1
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 06:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fSktq7xXrMMPbtfdmJkCSEx7/pG3avc0U41GKa6dgGI=;
        b=kWtSYQWD7mmZ+ogHAb68LTRAgAiK8jV0A6ybhdz/5CqpuJgqyfli1jtP8eUuygfR6w
         crs4Y+KLZmkWMd8UAGG3w3a64QzoOsUrn0eSRN8SuiufAjmvmec22cDixtwBLOVyGrDu
         hWI44PSExU92K0+6Xj4RKT3E0Ddk6DVD52pUg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fSktq7xXrMMPbtfdmJkCSEx7/pG3avc0U41GKa6dgGI=;
        b=gfd+43WfJqEedQMgIUIKi1oqs2KOcRun15brGEolf+EmUkak1mswSZW4kMR6Tp5Mup
         oefY23Z/vNo5b7g+FRHIEHnq9gOGShDOFFHL1dY9GN9j1R0iafYH0zMGT4loQVa0w0yi
         Ku+b6AEgTsqLj0P78WjsfziAGiK5hq0brR6gjxLCZz3b4wb9zz5o/r+kI7csMq8fIzFg
         7a67hyAgQ3ViPxwuebZZOidi4Adxu2gF94FXuz7h8YMkQQBYILAjVnAjUbfFY6OWjexM
         elItOfLWFEhgrV0Oz5GxQcPkqCfraBv3eajxs4dTRkmfQsb4//+dp+23yHv9uzmQODDs
         aXVg==
X-Gm-Message-State: APjAAAVLsMON03yUCp8SyHGd/DsWjWPXCooWKv6sDIKIbSkhg1WwerSF
        g6mXPPe8NEgyRo7UKP14cYLCAcp5v5b1EYr3NTFg/A==
X-Google-Smtp-Source: APXvYqxbgcJcwbgGJsiVoC/LCGrl9wUJfmmppwtG4xe3gsCYbaivBoouW+HNUJYYhd5rRzePVGeeTgOju//zfqKhqtM=
X-Received: by 2002:ac8:b81:: with SMTP id h1mr5344721qti.139.1575385167924;
 Tue, 03 Dec 2019 06:59:27 -0800 (PST)
MIME-Version: 1.0
References: <CAJPywTJzpZAXGdgZLJ+y7G2JoQMyd_JG+G8kgG+xruVVmZD-OA@mail.gmail.com>
 <877e3fniep.fsf@cloudflare.com> <CA+FuTSfA9o=yQk5EjR2hMuhwRDLXCAwYQ+eGqx2YSh=hx03c8g@mail.gmail.com>
In-Reply-To: <CA+FuTSfA9o=yQk5EjR2hMuhwRDLXCAwYQ+eGqx2YSh=hx03c8g@mail.gmail.com>
From:   Marek Majkowski <marek@cloudflare.com>
Date:   Tue, 3 Dec 2019 15:59:15 +0100
Message-ID: <CAJPywTLPzBz50LW7awNMAEOUdjLt4spz3vQ6i3BRKOp2qzBq4g@mail.gmail.com>
Subject: Re: Delayed source port allocation for connected UDP sockets
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 2, 2019 at 5:03 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
> So bind might succeed, but connect fail later if the port is already
> bound by another socket inbetween?

Yes, I'm proposing to delay the bind() up till connect(). The
semantics should remain the same, just the actual bind work will be
done atomically in the context of connect.

As mentioned - this is basically what connectx syscall does on some BSD's.

> Related, I have toyed with unhashed sockets with inet_sport set in the
> past for a different use-case: transmit-only sockets. If all receive
> processing happens on a small set (say, per cpu) of unconnected
> listening sockets. Then have unhashed transmit-only connected sockets
> to transmit without route lookup. But the route caching did not
> warrant the cost of maintaining a socket per connection at scale.

This is interesting. We have another use case for that - with TPROXY, we need
to _source_ packets from arbitrary port number. Port number on udp socket
can't be set with usual IP_PKTINFO. Therefore, to source packets from
arbitrary port number we are planning either:

 - use raw sockets
 - open a port on useless ip but specific sport, like 127.0.0.99:1234,
and call sendto() on it with arbitrary target.

Having proper unhashed sockets would make it slightly less hacky.

[...]
> If CAP_NET_RAW is no issue, Maciej's suggestion of temporarily binding
> to a dummy device (or even lo) might be the simplest approach?

Oh boy. I thought I know enough UDP hacks in Linux, but this brings it
to the next level. Indeed, it works:

sd = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sd.setsockopt(socket.SOL_SOCKET, socket.SO_BINDTODEVICE, b"dummy0")
sd.bind(('0.0.0.0', 1234))
sd.connect(("1.1.1.1", 53))
sd.setsockopt(socket.SOL_SOCKET, socket.SO_BINDTODEVICE, b"")

With the caveat, that dummy0 must be up. But this successfully
eliminates the race.

Thanks for suggestions,
    Marek
