Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8A7178242
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbgCCSRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 13:17:10 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:43554 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728955AbgCCSRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 13:17:10 -0500
Received: by mail-yw1-f67.google.com with SMTP id p69so4226158ywh.10
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 10:17:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W7d2FkKiOSuxYiOBYuSdri+rDqfHaRowkWVRadHJ2nI=;
        b=ldB4Koi9+5Mb6IuKZ7Duajjk4s9dQMM+g2OlLP4/a0M6w8ieYdZoeZxDbk8LMJbOv3
         JvgLLvVjm4OkvsbURtLgqJ3Cmv5iOWQIiJqafLWiOoZ79rqeCWvmmZCE1JcjYkQLiKvF
         Q8RieqXXLG7QBzwOnM+RbU74O6hGwkUbIKnHY3bpajuZwiwII4hQbF3O7L5IjZ0xwZ7V
         S3ifuTzrT9H1ds7hgIDBm91BsTO3y0KVz7j0ODceZAxOHIcwzhLfP3xg5HHF6/kSHwE1
         7M5p7uDECPx/L5FCEsS4L0d4HlnVoTXnhfWRo2WfMvyeAXz59vrxWRRlJ5D3O29JAHyP
         /Zgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W7d2FkKiOSuxYiOBYuSdri+rDqfHaRowkWVRadHJ2nI=;
        b=LgApY7lQQp3KgemZqg3+Si9wfPR2wbSHZNxoCzZgOUasRqL6uTq5uZr8cbSuWsqyxG
         cVoDkBY0v1L5sitdZLXNzl9a/4NQQFz1N2LpT02qphsrUq4RCLRBFLKIujdcUaV4NoG4
         DaRtM1jJEGVdbnn165wKGADyS22tf08Q2Fi1rPIDry/DiIGZm2ajUNnHBarjDJef0tf4
         LlOna+4ccpT7zobAMicfMRmZ+nXMdhzrFNS57I9bhybOJ9VJc9HUFslt4Ku9R5GGqBUJ
         UOGl/VI5HJDhRkv/ZbpM3LEiWOYYfoGW+FQNhC/qxBDvdCi/7qdtyrEwR0pZRa/rQtKB
         L9KQ==
X-Gm-Message-State: ANhLgQ0YHxzvs3Z1B7zL3Q9jXF0lsC2BW+PMjgaSOFidP5H4sgfJ+yvc
        cWVk7IBDN3B0gy4Fcm7Cmaiqe2dAgebaiUp6D2XaiA==
X-Google-Smtp-Source: ADFU+vvmkGtK3uRkRrWODfXEm8SX2wWgPo0kgi3UwJkEg2QLnXnJLTkHfzIFpyutY8IifxjJeURiFlUmRCuMNp0dYSs=
X-Received: by 2002:a25:4f09:: with SMTP id d9mr5265832ybb.408.1583259428530;
 Tue, 03 Mar 2020 10:17:08 -0800 (PST)
MIME-Version: 1.0
References: <74eacd0e-5519-3e39-50f3-1add05983ba3@gmail.com> <20200303175325.36937-1-kuniyu@amazon.co.jp>
In-Reply-To: <20200303175325.36937-1-kuniyu@amazon.co.jp>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 3 Mar 2020 10:16:56 -0800
Message-ID: <CANn89iJeTzzO_Z81yaWYg+8TAqWe75Y=A4u5aN6xMYMxQ1ME-w@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 2/4] tcp: bind(addr, 0) remove the
 SO_REUSEADDR restriction when ephemeral ports are exhausted.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>, kuni1840@gmail.com,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        netdev <netdev@vger.kernel.org>, osa-contribution-log@amazon.com,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 3, 2020 at 9:53 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
>
> From:   Eric Dumazet <eric.dumazet@gmail.com>
> Date:   Sun, 1 Mar 2020 20:49:49 -0800
> > On 3/1/20 8:31 PM, Kuniyuki Iwashima wrote:
> >> From:   Eric Dumazet <eric.dumazet@gmail.com>
> >> Date:   Sun, 1 Mar 2020 19:42:25 -0800
> >>> On 2/29/20 3:35 AM, Kuniyuki Iwashima wrote:
> >>>> Commit aacd9289af8b82f5fb01bcdd53d0e3406d1333c7 ("tcp: bind() use stronger
> >>>> condition for bind_conflict") introduced a restriction to forbid to bind
> >>>> SO_REUSEADDR enabled sockets to the same (addr, port) tuple in order to
> >>>> assign ports dispersedly so that we can connect to the same remote host.
> >>>>
> >>>> The change results in accelerating port depletion so that we fail to bind
> >>>> sockets to the same local port even if we want to connect to the different
> >>>> remote hosts.
> >>>>
> >>>> You can reproduce this issue by following instructions below.
> >>>>   1. # sysctl -w net.ipv4.ip_local_port_range="32768 32768"
> >>>>   2. set SO_REUSEADDR to two sockets.
> >>>>   3. bind two sockets to (address, 0) and the latter fails.
> >>>>
> >>>> Therefore, when ephemeral ports are exhausted, bind(addr, 0) should
> >>>> fallback to the legacy behaviour to enable the SO_REUSEADDR option and make
> >>>> it possible to connect to different remote (addr, port) tuples.
> >>>>
> >>>> This patch allows us to bind SO_REUSEADDR enabled sockets to the same
> >>>> (addr, port) only when all ephemeral ports are exhausted.
> >>>>
> >>>> The only notable thing is that if all sockets bound to the same port have
> >>>> both SO_REUSEADDR and SO_REUSEPORT enabled, we can bind sockets to an
> >>>> ephemeral port and also do listen().
> >>>>
> >>>> Fixes: aacd9289af8b ("tcp: bind() use stronger condition for bind_conflict")
> >>>>
> >>>> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> >>>
> >>> I am unsure about this, since this could double the time taken by this
> >>> function, which is already very time consuming.
> >>
> >> This patch doubles the time on choosing a port only when all ephemeral ports
> >> are exhausted, and this fallback behaviour can eventually decreases the time
> >> on waiting for ports to be released. We cannot know when the ports are
> >> released, so we may not be able to reuse ports without this patch. This
> >> patch gives more chace and raises the probability to succeed to bind().
> >>
> >>> We added years ago IP_BIND_ADDRESS_NO_PORT socket option, so that the kernel
> >>> has more choices at connect() time (instead of bind()) time to choose a source port.
> >>>
> >>> This considerably lowers time taken to find an optimal source port, since
> >>> the kernel has full information (source address, destination address & port)
> >>
> >> I also think this option is usefull, but it does not allow us to reuse
> >> ports that is reserved by bind(). This is because connect() can reuse ports
> >> only when their tb->fastresue and tb->fastreuseport is -1. So we still
> >> cannot fully utilize 4-tuples.
> >
> > The thing is : We do not want to allow active connections to use a source port
> > that is used for passive connections.
>
> When calling bind(addr, 0) without these patches, this problem does not
> occur. Certainly these patches could make it possible to do bind(addr, 0)
> and listen() on the port which is already reserved by connect(). However,
> whether these patches are applied or not, this problem can be occurred by
> calling bind with specifying the port.
>
>
> > Many supervisions use dump commands like "ss -t src :40000" to list all connections
> > for a 'server' listening on port 40000,
> > or use ethtool to direct all traffic for this port on a particular RSS queue.
> >
> > Some firewall setups also would need to be changed, since suddenly the port could
> > be used by unrelated applications.
>
> I think these are on promise that the server application specifies the port
> and we know which port is used in advance. Moreover the port nerver be used
> by unrelated application suddenly. When connect() and listen() share the
> port, listen() is always called after connect().
>
>
> I would like to think about two sockets (sk1 and sk2) in three cases.
>
> 1st case: sk1 is in TCP_LISTEN.
> In this case, sk2 cannot get the port and my patches does not change the behaviour.

Before being in TCP_LISTEN, it had to bind() on a sport.

Then _after_ reserving an exclusive sport, it can install whatever tc
/ iptables rule to implement additional security.

Before calling listen(), you do not want another socket being able to
use the same sport.

There is no atomic bind()+listen()  or bind()+install_firewalling_rules+listen()

This is why after bind(), the kernel has to guarantee the chosen sport
wont be used by other sockets.

Breaking this rule has a lot of implications.

>
> 2nd case: sk1 is in TCP_ESTABLISHED and call bind(addr, 40000) for sk2.
> In this case, sk2 can get the port by specifying the port, so listen() of
> sk2 can share the port with connect() of sk1. This is because reuseport_ok
> is true, but my patches add changes only for when reuseport_ok is false.
> Therefore, whether my patches are applied or not, this problem can happen.
>
> 3rd case: sk1 is in TCP_ESTABLISHED and call bind(addr, 0) for sk2.
> In this case, sk2 come to be able to get the port with my patches if both
> sockets have SO_REUSEADDR enabled.
> So, listen() also can share the port with connect().
>
> However, I do not think this can be problem for two reasons:
>   - the same problem already can happen in 2nd case, and the possibility of
>     this case is lower than 2nd case because 3rd case is when the ports are exhausted.
>   - I am unsure that there is supervisions that monitor the server
>     applications which randomly select the ephemeral ports to listen on.
>
> Although this may be a stupid question, is there famous server software
> that do bind(addr, 0) and listen() ?

I do not know, there are thousands of solutions using TCP, I can not
make sure they won't break.
It would take years to verify this.

>
>
> Hence, I think these patches are safe.

They are not.
