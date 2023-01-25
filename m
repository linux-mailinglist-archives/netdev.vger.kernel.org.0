Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F5467AFDD
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 11:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235257AbjAYKlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 05:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234279AbjAYKlf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 05:41:35 -0500
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2252921A0D
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:41:32 -0800 (PST)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 30PAfVkl029033
        for netdev@vger.kernel.org; Wed, 25 Jan 2023 11:41:31 +0100
Date:   Wed, 25 Jan 2023 11:41:31 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     netdev@vger.kernel.org
Subject: Very strange EPOLLHUP during connect()
Message-ID: <20230125104131.GA28311@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

For a few months I've been analysing an anomaly that one of our haproxy
users reported and that to date I have only seen there and could never
reproduce.

To make a long story short, after a TCP connect() returning EINPROGRESS,
sometimes epoll_wait() reports EPOLLHUP (or just EPOLLRDHUP), which we
turn to an error, but if we mask it, the connection works perfectly!

Historically we've always been using a second connect() call to validate
odd flag combinations instead of getsockopt() as connect() won't flush
the socket error, and I could witness something quite odd, which is that
the second connect() then returns 0 instead of EISCONN, ECONREFUSED or
any other error. How can a second connect() return 0 on top of an existing
one is strange to me, I could never reproduce this either. However I
suspected it could have been the reason why the socket was usable after
that, but that's not even the case, as I've had it replaced with
getsockopt() showing the same, i.e. that getsockopt() reports no error,
and that the communication works normally on this socket after that if
we mask HUP.

I could get a very interesting pair of traces, one from strace and the
corresponding tcpdump. I could interleave them by date since taken on
the same machine, they show that everything looks normal at the network
level, but still the strange epoll_wait() response:

  16:30:57.798900 socket(AF_INET, SOCK_STREAM, IPPROTO_IP) = 26
  16:30:57.799007 fcntl(26, F_SETFL, O_RDONLY|O_NONBLOCK) = 0
  16:30:57.799106 setsockopt(26, SOL_TCP, TCP_NODELAY, [1], 4) = 0
  16:30:57.799239 setsockopt(26, SOL_SOCKET, SO_KEEPALIVE, [1], 4) = 0
  16:30:57.799423 setsockopt(26, SOL_TCP, TCP_QUICKACK, [0], 4) = 0
  16:30:57.799592 connect(26, {sa_family=AF_INET, sin_port=htons(55555), sin_addr=inet_addr("10.10.10.10")}, 16) = -1 EINPROGRESS (Operation now in progress)
  
  16:30:57.799686 IP (tos 0x0, ttl 64, id 64911, offset 0, flags [DF], proto TCP (6), length 60)    192.168.1.1.57802 > 10.10.10.10.55555: Flags [S], cksum 0xae33 (incorrect -> 0x3875), seq 1803354658, win 62727, options [mss 8961,sackOK,TS val 3288919451 ecr 0,nop,wscale 7], length 0
  16:30:57.799897 IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto TCP (6), length 60)    10.10.10.10.55555 > 192.168.1.1.57802: Flags [S.], cksum 0x0460 (correct), seq 4207353842, ack 1803354659, win 62643, options [mss 8961,sackOK,TS val 1010949468 ecr 3288919451,nop,wscale 7], length 0
  
  16:30:57.801122 epoll_ctl(5, EPOLL_CTL_ADD, 26, {EPOLLIN|EPOLLOUT|EPOLLRDHUP, {u32=26, u64=26}}) = 0
  16:30:57.801862 epoll_wait(5, [{EPOLLIN|EPOLLHUP|EPOLLRDHUP, {u32=26, u64=26}}, {EPOLLOUT, {u32=26, u64=26}}, ...], 200, 35) = 16
  ### this is the validation connect() for odd flags, should never return 0...
  16:30:57.820701 connect(26, {sa_family=AF_INET, sin_port=htons(55555), sin_addr=inet_addr("10.10.10.10")}, 16) = 0
  16:30:57.821926 recvfrom(26, 0x555a3c98ba90, 16320, 0, NULL, NULL) = -1 EAGAIN (Resource temporarily unavailable)
  16:30:57.828721 sendto(26, "GET /liveness HTTP/1.0\r\ncontent-"..., 45, MSG_DONTWAIT|MSG_NOSIGNAL, NULL, 0) = 45
  
  16:30:57.828796 IP (tos 0x0, ttl 64, id 64912, offset 0, flags [DF], proto TCP (6), length 97)    192.168.1.1.57802 > 10.10.10.10.55555: Flags [P.], cksum 0xae58 (incorrect -> 0x50a6), seq 1803354659:1803354704, ack 4207353843, win 491, options [nop,nop,TS val 3288919480 ecr 1010949468], length 45
  16:30:57.829073 IP (tos 0x0, ttl 64, id 21604, offset 0, flags [DF], proto TCP (6), length 52)    10.10.10.10.55555 > 192.168.1.1.57802: Flags [.], cksum 0x42dc (correct), seq 4207353843, ack 1803354704, win 490, options [nop,nop,TS val 1010949497 ecr 3288919480], length 0
  16:30:57.829558 IP (tos 0x0, ttl 64, id 21605, offset 0, flags [DF], proto TCP (6), length 152)    10.10.10.10.55555 > 192.168.1.1.57802: Flags [P.], cksum 0x077b (correct), seq 4207353843:4207353943, ack 1803354704, win 490, options [nop,nop,TS val 1010949498 ecr 3288919480], length 100
  16:30:57.829566 IP (tos 0x0, ttl 64, id 64913, offset 0, flags [DF], proto TCP (6), length 52)    192.168.1.1.57802 > 10.10.10.10.55555: Flags [.], cksum 0xae2b (incorrect -> 0x4275), seq 1803354704, ack 4207353943, win 491, options [nop,nop,TS val 3288919481 ecr 1010949498], length 0
  16:30:57.829911 IP (tos 0x0, ttl 64, id 21606, offset 0, flags [DF], proto TCP (6), length 52)    10.10.10.10.55555 > 192.168.1.1.57802: Flags [F.], cksum 0x4275 (correct), seq 4207353943, ack 1803354704, win 490, options [nop,nop,TS val 1010949498 ecr 3288919481], length 0
  
  16:30:57.855492 epoll_ctl(5, EPOLL_CTL_MOD, 26, {EPOLLIN|EPOLLRDHUP, {u32=26, u64=26}}) = 0
  16:30:57.861705 epoll_wait(5, [{EPOLLIN|EPOLLRDHUP, {u32=26, u64=26}}, ...], 200, 70) = 9
  16:30:57.863608 recvfrom(26, "HTTP/1.1 200 OK\r\nContent-Type: t"..., 16320, 0, NULL, NULL) = 100
  16:30:57.868067 close(26)               = 0
  
  16:30:57.868164 IP (tos 0x0, ttl 64, id 64914, offset 0, flags [DF], proto TCP (6), length 52)    192.168.1.1.57802 > 10.10.10.10.55555: Flags [F.], cksum 0xae2b (incorrect -> 0x424d), seq 1803354704, ack 4207353944, win 491, options [nop,nop,TS val 3288919519 ecr 1010949498], length 0
  16:30:57.868414 IP (tos 0x0, ttl 64, id 21607, offset 0, flags [DF], proto TCP (6), length 52)    10.10.10.10.55555 > 192.168.1.1.57802: Flags [.], cksum 0x4227 (correct), seq 4207353944, ack 1803354705, win 490, options [nop,nop,TS val 1010949537 ecr 3288919519], length 0
  
In all of my tests, I could never make epoll_wait() return EPOLLHUP after a
connect() without EPOLLERR. Looking at the code, the only way TCP can set
EPOLLHUP is when both sides are shut or the socket is in the closed state.

What we've noticed as well is that from time to time there's only EPOLLRDHUP
and not EPOLLHUP, like below (getsockopt() was used there by the way):

  socket(AF_INET, SOCK_STREAM, IPPROTO_IP) = 33
  fcntl(33, F_SETFL, O_RDONLY|O_NONBLOCK) = 0
  setsockopt(33, SOL_TCP, TCP_NODELAY, [1], 4) = 0
  setsockopt(33, SOL_SOCKET, SO_KEEPALIVE, [1], 4) = 0
  setsockopt(33, SOL_TCP, TCP_QUICKACK, [0], 4) = 0
  connect(33, {sa_family=AF_INET, sin_port=htons(55555), sin_addr=inet_addr("10.10.10.10")}, 16) = -1 EINPROGRESS (Operation now in progress)
  epoll_ctl(5, EPOLL_CTL_ADD, 33, {EPOLLIN|EPOLLOUT|EPOLLRDHUP, {u32=33, u64=33}}) = 0
  epoll_wait(5, [{EPOLLIN|EPOLLRDHUP, {u32=33, u64=33}}, {EPOLLOUT, {u32=33, u64=33}}, ...], 200, 165) = 21
  getsockopt(33, SOL_SOCKET, SO_ERROR, [0], [4]) = 0
  sendto(33, "GET /liveness HTTP/1.0\r\ncontent-"..., 45, MSG_DONTWAIT|MSG_NOSIGNAL, NULL, 0) = 45
  close(33)                               = 0
  # here we closed due to RDHUP that was considered as a close condition
  # before waiting for a response.

The kernel was a 5.4 from Ubuntu 18.04, I noticed two of their internal
versions (5.4.0-122 and 5.4.0-132), and I based my analysis on what we
have, mainline and official 5.4 (I already checked that nothing between
5.4 and 5.4.229 changed in this area).

The user also indicated that this runs inside a VM and that the remote
host is in another VM, possibly on a different hardware, he doesn't know,
as it runs in AWS but he says he could reproduce it in Azure's cloud as
well.

If the user switches to poll() instead of epoll, the problem disappears,
no POLLHUP is ever reported! This makes me think that it seriously smells
like a race condition somewhere. By the way our sockets are pinned to a
given thread, and we have one epoll instance per thread, so a trace like
above necessarily happens on the same thread from the beginning to the
end.

I could manage to implement a workaround for this by masking HUP/RDHUP
after epoll_wait(), but that's ugly, particularly since I don't really
know what I'm trying to work around. I would prefer to only enable it
when absolutely necessary if at all, and I still have no idea what to
look for to decide whether or not to do that.

My main problem is that in the code I'm not seeing any possibility for
this to happen (both send()+recv() working after this report indicating
a close, and the missing EPOLLERR). And this tends to be supported by
the hundreds of thousands of other deployments on various OSes which
never reported this either. I would be fine with an external factor
caused at the VM level for example, but I can't see anything in the
code that could provoke this. I have thought about the fact that we
disable TCP_QUICKACK during this phase (so that we can perform a
SYN/SYN-ACK/RST for a health checks without waking up an application),
but in the mixed trace above we clearly see the anomaly revealed before
the system even sends an ACK to the server so I don't think it would
have anything to do with it either.

As such, if anyone has any idea about something I could have overlooked,
or a way to force such flag combinations to happen, even if very unlikely,
I'm very interested! I'd rather fix an odd bug than implement a workaround
for something bizarre. For example I even tried iptables + reject rules,
dropping ARP entries or cable during a connect(), etc, without success.

Thanks in advance,
Willy
