Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D04F410E869
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 11:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbfLBKOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 05:14:44 -0500
Received: from mail-lf1-f51.google.com ([209.85.167.51]:47036 "EHLO
        mail-lf1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727544AbfLBKOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 05:14:42 -0500
Received: by mail-lf1-f51.google.com with SMTP id a17so27442350lfi.13
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 02:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=cWmiFNRxxXzmfkj7qnlZLYRNIZ7DEqO6dh6O3rWT0Ww=;
        b=kHRzwpv+UuvCOUQueDw7eH1T9OBi3MFnfQ7FDeiSujja/oJgnTL/Zm072EDRRXEMfy
         b00dxoHcA3i0LwAcA08qKALM0MUy0a/XppsETVeiSSjiOWtvsmLhV8x+o7kt2ElYf+Tu
         V9/vKnI7N3YWDYyto9JEGwbsSnNbuZBLA6aYM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=cWmiFNRxxXzmfkj7qnlZLYRNIZ7DEqO6dh6O3rWT0Ww=;
        b=bVo/Z8Znjs4SANlEQOeF5+XtrtAie9HEkI5gGP4kaqm+chjVzlssDBUm3HhAgilQQT
         9gGZggq3ZhwhlxJXCNghvKbS8wdCGdKjj3p9wVl4iI3jw0bhtUvJsDDFHFyhJIoaWMvm
         LcPF/SyeU3Bf+OUvG7RG8ZUNILEDkaeKxU6sObdKkdih2KTFhj0JVKQ0yB3tkcQ6Frc3
         88pd3mIAuFjHVvGelEAiWSiDf3auZ/szCqc3Izot9J1IPCe9et8VM846fHWoN/kWXsmU
         S604cKeyc3DLAMHRd6W7ZbysfIozrDcNM3ztp0fqAQUqUSsQxMi2K6vBMPW85g23KpTY
         yS8A==
X-Gm-Message-State: APjAAAWqcrR0ErPkKpZrTzechgOwVFjcpemMnth7Tab01gKZrUeqHoEO
        UHGcj0QoR0rFUkZy13SavzbeST2uvBad6A==
X-Google-Smtp-Source: APXvYqyEwZDs7nvHkC+8xa4fSI+oJuYKo0bXsXNLJMBQfOBBTBnimDoptkI4OP++XV0lVI0r1G2BvA==
X-Received: by 2002:a19:40d8:: with SMTP id n207mr13957335lfa.4.1575281680337;
        Mon, 02 Dec 2019 02:14:40 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id k24sm5928015ljj.27.2019.12.02.02.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:14:39 -0800 (PST)
References: <CAJPywTJzpZAXGdgZLJ+y7G2JoQMyd_JG+G8kgG+xruVVmZD-OA@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     kernel-team <kernel-team@cloudflare.com>,
        Marek Majkowski <marek@cloudflare.com>
Subject: Re: Delayed source port allocation for connected UDP sockets
In-reply-to: <CAJPywTJzpZAXGdgZLJ+y7G2JoQMyd_JG+G8kgG+xruVVmZD-OA@mail.gmail.com>
Date:   Mon, 02 Dec 2019 11:14:38 +0100
Message-ID: <877e3fniep.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 03:07 PM CET, Marek Majkowski wrote:
> In my applications I need something like a connectx()[1] syscall. On
> Linux I can get quite far with using bind-before-connect and
> IP_BIND_ADDRESS_NO_PORT. One corner case is missing though.
>
> For various UDP applications I'm establishing connected sockets from
> specific 2-tuple. This is working fine with bind-before-connect, but
> in UDP it creates a slight race condition. It's possible the socket
> will receive packet from arbitrary source after bind():
>
> s = socket(SOCK_DGRAM)
> s.bind((192.0.2.1, 1703))
> # here be dragons
> s.connect((198.18.0.1, 58910))
>
> For the short amount of time after bind() and before connect(), the
> socket may receive packets from any peer. For situations when I don't
> need to specify source port, IP_BIND_ADDRESS_NO_PORT flag solves the
> issue. This code is fine:
>
> s = socket(SOCK_DGRAM)
> s.setsockopt(IP_BIND_ADDRESS_NO_PORT)
> s.bind((192.0.2.1, 0))
> s.connect((198.18.0.1, 58910))
>
> But the IP_BIND_ADDRESS_NO_PORT doesn't work when the source port is
> selected. It seems natural to expand the scope of
> IP_BIND_ADDRESS_NO_PORT flag. Perhaps this could be made to work:
>
> s = socket(SOCK_DGRAM)
> s.setsockopt(IP_BIND_ADDRESS_NO_PORT)
> s.bind((192.0.2.1, 1703))
> s.connect((198.18.0.1, 58910))
>
> I would like such code to delay the binding to port 1703 up until the
> connect(). IP_BIND_ADDRESS_NO_PORT only makes sense for connected
> sockets anyway. This raises a couple of questions though:
>
>  - IP_BIND_ADDRESS_NO_PORT name is confusing - we specify the port
> number in the bind!
>
>  - Where to store the source port in __inet_bind. Neither
> inet->inet_sport nor inet->inet_num seem like correct places to store
> the user-passed source port hint. The alternative is to introduce
> yet-another field onto inet_sock struct, but that is wasteful.

We've been talking with Marek about it some more. I'll summarize for the
sake of keeping the discussion open.

1. inet->inet_sport as storage for port hint

   It seems inet->inet_sport could be used to hold the port passed to
   bind() when we're delaying port allocation with
   IP_BIND_ADDRESS_NO_PORT. As long as local port, inet->inet_num, is
   not set, connect() and sendmsg() will know the socket needs to be
   bound to a port first.

   We didn't do a detailed audit of all access sites to
   inet->inet_sport. Potentially we missed something.

2. Backward compatibility

   Changing the existing behavior to delay port allocation when
   IP_BIND_ADDRESS_NO_PORT is set but port number was passed to bind(),
   could break apps that set the sockopt but never connect() the socket
   for some reason.

3. Extend the sockopt? Add new one? Introduce connectx() syscall?

   Since IP_BIND_ADDRESS_NO_PORT cannot be reused as is, we need a way
   for the user-space to signal its desire to delay binding to a
   specific port.

   We could imagine an extended version of IP_BIND_ADDRESS_NO_PORT
   sockopt that takes an extra value apart from the int flag.

   Then there's the option of adding a new sockopt dedicated for this
   use-case. However, we fear two sockopts having a similar purpose will
   be confusing for the users [0].

   Finally, we could go for the hard-core solution and take a stab at
   adding connectx() syscall [1]. Were there any attempts or discussions
   about this before? Quick search didn't turn up anything but the name
   is kind of a nightmare to google for.

   Question to the maintainers - which approach would be most welcome?

4. Why connected UDP sockets?

   We know that it's better to stick to receiving UDP sockets and
   demultiplex the client requests/sessions in user-space. Being hashed
   just by local address & port, connected UDP sockets don't scale well.

   We think there is one useful application, though. Service draining
   during restarts.

   When a service is being restarted, we would like the dying process to
   handle the ongoing L7 sessions until they come to an end. New UDP
   flows should go to a fresh service instance.

   To achieve that, for each ongoing session we would open a connected
   UDP socket. This way socket lookup logic would deliver just the flows
   we care about to the old process.

5. reuseport BPF with SOCKARRAY to the rescue?

   Since we're talking about opening connected UDP sockets that share
   the local port with other receiving UDP sockets (owned by another
   process), we would need to opt for port sharing with REUSEPORT [3].

   If we don't want the connected UDP sockets to receive any traffic
   during the short window of opportunity when the socket is bound but
   not connected, we could exclude it from the reuseport group by
   controlling the socket set with BPF & SOCKARRAY.

Comments and thoughts more than welcome.

-Jakub

[0] Unless we call it IP_BIND_ADDRESS_NO_PORT_FOR_REAL... ;-)
[1] https://www.unix.com/man-page/mojave/2/connectx/
[2] Or REUSEADDR which semantics allow it for unicast UDP.
