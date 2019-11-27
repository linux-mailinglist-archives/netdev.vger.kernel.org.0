Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAB6410B0DA
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 15:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfK0OIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 09:08:07 -0500
Received: from mail-qk1-f172.google.com ([209.85.222.172]:33760 "EHLO
        mail-qk1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfK0OIH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 09:08:07 -0500
Received: by mail-qk1-f172.google.com with SMTP id c124so15162417qkg.0
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 06:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=AnPx87uBw4dMGRP7zgUS/hamVUVQllq4PAsVS71MslU=;
        b=aKonW0ATuixhUX8ToG1VmjVEG3jhfsHn9JjqKD9KFWhV7cAwmQK31SFiPnz0CabXO1
         I3VzuSy6pYnn70/EAaMCIvVnC4UpAh8XXG3ZtZH87FDXTlJayM0f2ZuLQqp58t9Pk6LY
         C7X8DmwAVadIDmHgljYnNJiowAsg9fvBIXkeA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=AnPx87uBw4dMGRP7zgUS/hamVUVQllq4PAsVS71MslU=;
        b=A4bOghKJ9wwBaf+fMty2qRZqmTXGr3SyrnHegmfjAkpK39v5anitFsYealiob65exi
         isYkq3fmpO8BLvoeG3ImDik0uPHEkJw1MTdowg1aWbpObXuhlQripFG5fX07J2s9+bfJ
         sE7D5BgTo5/Hj9twnkC6FXigV6p9VXn0Q0pCOHhObuIMefp/URiowAfMNEXUq4P7IvUR
         sVHSOdT6dNGiU3pvv/oJRwG92xvzEzgv9RjHMhm9MwaqL1vrBQIRrmjtCzxi0B6AZvWr
         7j8JYc/yFn+dWk4WO+TFux00bDMFwzWZPTilUhKWCJ02u5LSk2tnNyVeQApLBRF5RVfi
         4cCQ==
X-Gm-Message-State: APjAAAWLppwUwzUw7UdQs5SNPTCqLAI5RSYtW/Jt2Ikaw+uOtYodQL0P
        pNbHlpb36MlzBdA2vhPrGVVEpLhvaYIzsoyUtCIaOw==
X-Google-Smtp-Source: APXvYqx9+ORxUEff+Sn8h86bbY1qDbXflaHgWB60+0qeefL3OkPu9PpeKYostRz1En64riZ9gwTu56Nrat2QuSpx9iI=
X-Received: by 2002:a37:ae05:: with SMTP id x5mr4371052qke.243.1574863686206;
 Wed, 27 Nov 2019 06:08:06 -0800 (PST)
MIME-Version: 1.0
From:   Marek Majkowski <marek@cloudflare.com>
Date:   Wed, 27 Nov 2019 15:07:55 +0100
Message-ID: <CAJPywTJzpZAXGdgZLJ+y7G2JoQMyd_JG+G8kgG+xruVVmZD-OA@mail.gmail.com>
Subject: Delayed source port allocation for connected UDP sockets
To:     Eric Dumazet <edumazet@google.com>, ncardwell@google.com,
        maze@google.com, network dev <netdev@vger.kernel.org>
Cc:     kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Morning,

In my applications I need something like a connectx()[1] syscall. On
Linux I can get quite far with using bind-before-connect and
IP_BIND_ADDRESS_NO_PORT. One corner case is missing though.

For various UDP applications I'm establishing connected sockets from
specific 2-tuple. This is working fine with bind-before-connect, but
in UDP it creates a slight race condition. It's possible the socket
will receive packet from arbitrary source after bind():

s = socket(SOCK_DGRAM)
s.bind((192.0.2.1, 1703))
# here be dragons
s.connect((198.18.0.1, 58910))

For the short amount of time after bind() and before connect(), the
socket may receive packets from any peer. For situations when I don't
need to specify source port, IP_BIND_ADDRESS_NO_PORT flag solves the
issue. This code is fine:

s = socket(SOCK_DGRAM)
s.setsockopt(IP_BIND_ADDRESS_NO_PORT)
s.bind((192.0.2.1, 0))
s.connect((198.18.0.1, 58910))

But the IP_BIND_ADDRESS_NO_PORT doesn't work when the source port is
selected. It seems natural to expand the scope of
IP_BIND_ADDRESS_NO_PORT flag. Perhaps this could be made to work:

s = socket(SOCK_DGRAM)
s.setsockopt(IP_BIND_ADDRESS_NO_PORT)
s.bind((192.0.2.1, 1703))
s.connect((198.18.0.1, 58910))

I would like such code to delay the binding to port 1703 up until the
connect(). IP_BIND_ADDRESS_NO_PORT only makes sense for connected
sockets anyway. This raises a couple of questions though:

 - IP_BIND_ADDRESS_NO_PORT name is confusing - we specify the port
number in the bind!

 - Where to store the source port in __inet_bind. Neither
inet->inet_sport nor inet->inet_num seem like correct places to store
the user-passed source port hint. The alternative is to introduce
yet-another field onto inet_sock struct, but that is wasteful.

Suggestions?

Marek

[1] https://www.unix.com/man-page/mojave/2/connectx/
