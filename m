Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 641B114CFED
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 18:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbgA2Rw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 12:52:57 -0500
Received: from mail-yb1-f174.google.com ([209.85.219.174]:34289 "EHLO
        mail-yb1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbgA2Rw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 12:52:57 -0500
Received: by mail-yb1-f174.google.com with SMTP id w17so283835ybm.1
        for <netdev@vger.kernel.org>; Wed, 29 Jan 2020 09:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BHlGoQhMR5/4/IcCx7jBU5bWHRB5pq6/0bSZNap7+Ak=;
        b=wFlmNbktDERh/VQbmx/FLSvUpjyy1Gj9Yuld9nNBJR8/8LZO/La3RL6xwHAnIN06pd
         HHiOyZDJpZxDkaknzciFxc0E/lzxi5eCe1To14Pr/PYvJr3K1aVNhKBcIkye5YpbRmSX
         tukHJrsQAT/NvdQe6Zjxo6MRxXf292dOLQHx/duDuo6iEg3Q5OMsdzcnKyiu2G9LeyEG
         5+zHaQHReARpWOdc7DOT3uAVbrhxi1fd6CNniF4Obo8osIsj6Iv6qmCkAyGSxdSY8iYj
         VsWYoaVn5/ZKhhypYwotqPKng/UtI+tR2knssA5Ui2GQ+oRqlnkd7wkhbkwYSl/lZGiI
         FyPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BHlGoQhMR5/4/IcCx7jBU5bWHRB5pq6/0bSZNap7+Ak=;
        b=WQ0sSrZswWsnbXdRhbNy0ltuGMJ3K+JEYl+UenAxvT70bx/gccM+RiyBPLhyBhYbNr
         lHFGfFmdWJoMop1O43oWTuYndIl0Bn2IWnyzX6GP9PxfL67vpjYOLgdWwzgVNrWOo0uX
         4Bvm6yFnCkpS9nKpM9Z/CRMysDPyekcx00rwpzwQ9M184DN3PWGjmiRQ2nSzFSmMjORi
         xcj1K8w3hq0yFu/zvPaNVy0Gb85OJphOXamu+2qk1oLHfZVgb6AqhDHSHIwyAPBf93Xw
         9ze1PqvEnFQh9zFmenVtdjbebZfOlGNTqhYhNe8JncdmjjkGJKfaFr4GwbyNp9hXgOuq
         ASXg==
X-Gm-Message-State: APjAAAW/UyPO9cjy42h13gX3nx9pMkFdrN8LHerslHSVVS/u8BDGG92F
        NnL7OIHadWb83uQQpELTc75Zw/oRpa+/iRU5dVTclg==
X-Google-Smtp-Source: APXvYqxyxuILkd/y+3D4kwDSy+68nk4AFO4p5OVBLvCJjWuhRVZXLUZqDqdPzQ7aG/RJPOJvxpdnlHkbdaEpVS5S8jM=
X-Received: by 2002:a25:d112:: with SMTP id i18mr531374ybg.364.1580320374836;
 Wed, 29 Jan 2020 09:52:54 -0800 (PST)
MIME-Version: 1.0
References: <20200129171403.3926-1-sjpark@amazon.com>
In-Reply-To: <20200129171403.3926-1-sjpark@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 29 Jan 2020 09:52:43 -0800
Message-ID: <CANn89iJOK9UMQspgikPWb-NA6vmo+wQPB5q7hnWpHDSxYrUSnA@mail.gmail.com>
Subject: Re: Latency spikes occurs from frequent socket connections
To:     sjpark@amazon.com
Cc:     David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        andriin@fb.com, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        aams@amazon.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        dola@amazon.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 29, 2020 at 9:14 AM <sjpark@amazon.com> wrote:
>
> Hello,
>
>
> We found races in the kernel code that incur latency spikes.  We thus would
> like to share our investigations and hear your opinions.
>
>
> Problem Reproduce
> =================
>
> You can reproduce the problem by compiling and running source code of
> 'server.c' and 'client.c', which I pasted at the end of this mail, as below:
>
>     $ gcc -o client client.c
>     $ gcc -o server server.c
>     $ ./server &
>     $ ./client
>     ...
>     port: 45150, lat: 1005320, avg: 229, nr: 1070811
>     ...
>

Thanks for the repro !

> The reproduce program works as follow.  The server creates and binds a socket
> to port 4242, listen on it, and start a infinite loop.  Inside the loop, it
> accepts connection, read 4 bytes from the socket, and close.
> The client is constructed as an infinite loop.  Inside the loop, it creates a
> socket with LINGER and NODELAY option, connect to the server, send 4 bytes
> data, try read some data from server.  After the read() returns, it measure the
> latency from the beginning of this loop to here and if the latency is larger
> than 1 second (spike), print a message.
>
> The 6th line of above example is the message client prints for the latency
> spike.  It shows what port currently client used, the latency (in
> microseconds), averaged latency (in microseconds, again), and total number of
> connections client has made since beginning of this execution.  During our 10
> minute execution of the reproduce program, we could see 397 times of latency
> spikes among 2,744,124 connections.
>
>
> Packet Trace
> ============
>
> For investigation of this issue, we used tcpdump as below:
>
>     # tcpdump -nnn -i lo port 4242
>
> Below is a part of the trace that related with this spike.
>
> ```
> 11:57:13.188107 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [S], seq 2541101293, win 65495, options [mss 65495,sackOK,TS val 953759375 ecr 0,nop,wscale 7], length 0
> 11:57:13.188109 IP 127.0.0.1.4242 > 127.0.0.1.45150: Flags [S.], seq 2413948679, ack 2541101294, win 65483, options [mss 65495,sackOK,TS val 953759375 ecr 953759375,nop,wscale 7], length 0
> 11:57:13.188116 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [.], ack 1, win 512, options [nop,nop,TS val 953759375 ecr 953759375], length 0
> 11:57:13.188231 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [P.], seq 1:5, ack 1, win 512, options [nop,nop,TS val 953759375 ecr 953759375], length 4
> 11:57:13.188235 IP 127.0.0.1.4242 > 127.0.0.1.45150: Flags [.], ack 5, win 512, options [nop,nop,TS val 953759375 ecr 953759375], length 0
> 11:57:13.188248 IP 127.0.0.1.4242 > 127.0.0.1.45150: Flags [F.], seq 1, ack 5, win 512, options [nop,nop,TS val 953759375 ecr 953759375], length 0
> 11:57:13.188347 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [.], ack 2, win 512, options [nop,nop,TS val 953759375 ecr 953759375], length 0
> 11:57:13.188355 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [R.], seq 5, ack 2, win 512, options [nop,nop,TS val 953759375 ecr 953759375], length 0
>
>
> 11:57:14.436259 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [S], seq 2560603644, win 65495, options [mss 65495,sackOK,TS val 953760623 ecr 0,nop,wscale 7], length 0
> 11:57:14.436266 IP 127.0.0.1.4242 > 127.0.0.1.45150: Flags [.], ack 5, win 512, options [nop,nop,TS val 953760623 ecr 953759375], length 0
> 11:57:14.436271 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [R], seq 2541101298, win 0, length 0
> 11:57:15.464613 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [S], seq 2560603644, win 65495, options [mss 65495,sackOK,TS val 953761652 ecr 0,nop,wscale 7], length 0
> 11:57:15.464633 IP 127.0.0.1.4242 > 127.0.0.1.45150: Flags [S.], seq 2449519317, ack 2560603645, win 65483, options [mss 65495,sackOK,TS val 953761652 ecr 953761652,nop,wscale 7], length 0
> 11:57:15.464644 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [.], ack 1, win 512, options [nop,nop,TS val 953761652 ecr 953761652], length 0
> 11:57:15.464677 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [P.], seq 1:5, ack 1, win 512, options [nop,nop,TS val 953761652 ecr 953761652], length 4
> 11:57:15.464680 IP 127.0.0.1.4242 > 127.0.0.1.45150: Flags [.], ack 5, win 512, options [nop,nop,TS val 953761652 ecr 953761652], length 0
> 11:57:15.464730 IP 127.0.0.1.4242 > 127.0.0.1.45150: Flags [F.], seq 1, ack 5, win 512, options [nop,nop,TS val 953761652 ecr 953761652], length 0
> 11:57:15.464865 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [R.], seq 5, ack 2, win 512, options [nop,nop,TS val 953761652 ecr 953761652], length 0
> ```
>
> The lower 10 lines of trace are for the latency spike made connection. You can
> see that it spend more than 1 second.  The client sent SYN packet with seq
> number 2560603644, but server respond with ACK with seq number 5.  This means
> the connection was not properly closed.
>
> The upper 8 lines of trace shows the last connection using the 45150 port.  The
> client sent RST/ACK properly.
>
>
> What Happend Inside
> ===================
>
> So, according to the TCP state protocol[1], expected behavior is as below:
>
>          00 server                              clinet
>          01 ESTABLISHED                         ESTABLISHED
>          02 close()
>          03 FIN_WAIT_1
>          04             ---FIN-->
>          05                                     CLOSE_WAIT
>          06             <--ACK---
>          07 FIN_WAIT_2
>          08             <--RST/ACK---
>          09 TIME_WAIT
>          10             ---ACK-->
>          11                                     LAST_ACK
>          12 CLOSED                              CLOSED
>
> As server closes socket, server socket changes its state to FIN_WAIT_1 and send
> FIN packet to client (lines 1-4).  The client changes its socket state to
> CLOSE_WAIT and send ACK (lines 5 and 6).  By receiving this ACK, server socket
> becomes FIN_WAIT_2 state (line 7).  The client also send RST/ACK (line 8).  By
> receiving the RST/ACK, the server moves to TIME_WAIT state and send ACK to the
> client.  The client now receive the ACK and move to LAST_ACK state, and now
> both the server and the client goes to CLOSED.
>
> However, due to the parallel structure of the TCP packet handling, below
> reordering could happen.
>
>          00 server                              clinet
>          01 ESTABLISHED                         ESTABLISHED
>          02 close()
>          03 FIN_WAIT_1
>          04             ---FIN-->
>          05                                     CLOSE_WAIT
>          06                             (<--ACK---)
>          07                             (<--RST/ACK---)
>          08                             (fired in right order)
>          09             <--RST/ACK---
>          10             <--ACK---
>          11             (arrived in wrong order)
>          12 FIN_WAIT_2
>
> Lines 1 to 5 is same with above.  The client now send the ACK first, and then
> RST/ACK.  However, these two packets are handled in parallel and thus RST/ACK
> is processed before ACK.  The RST/ACK is just ignored as it is unexpected
> packet.  The ACK arrives eventually and changes the server's state to
> FIN_WAIT_2.  Now the server waits for RST/ACK from the client but it has
> already arrived before and ignored.  Therefore, the server cannot move to
> TIME_WAIT, and no ACK to the client is sent.  As a result, the client will stay
> in the CLOSE_WAIT state.  Later, the port is reused and thus the previously
> described situation happens.
>
> [1] https://en.wikipedia.org/wiki/File:Tcp_state_diagram.png
>
>
> Into The Kernel Code
> ====================
>
> By diving into the kernel code, one of us found where most of this races comes
> out.  It's in the 'tcp_v4_rcv()' function.  Roughly speaking, it does error
> condition check, lookup, process, and few more works in sequence.  I'm calling
> the small steps as lookup and process step as those are labeled as in the
> code.  And, a few of the process step is protected by 'bh_lock_sock_nested()'.
>
> However, the process of the RST/ACK is done outside of the critical section.
> In more detail, the first 'if' statement of the process step checks current
> state and go to 'do_time_wait' step, which will change the state to FIN_WAIT_2
> and send the final ACK that will make the client to LAST_ACK state:
>
>     process:
>         if (sk->sk_state == TCP_TIME_WAIT)
>                 godo do_time_wait;
>
> This is before the critical section.  Thus in some case, RST/ACK packet passes
> this check while the ACK which the client has sent before RST/ACK is being
> processed inside the critical section.
>
>
> Experimental Fix
> ----------------
>
> We confirmed this is the case by logging and some experiments.  Further,
> because the process of RST/ACK packet would stuck in front of the critical
> section while the ACK is being processed inside the critical section in most
> case, we add one more check of the RST/ACK inside the critical section.  In
> detail, it's as below:
>
>     --- a/net/ipv4/tcp_ipv4.c
>     +++ b/net/ipv4/tcp_ipv4.c
>     @@ -1912,6 +1912,29 @@ int tcp_v4_rcv(struct sk_buff *skb)
>             tcp_segs_in(tcp_sk(sk), skb);
>             ret = 0;
>             if (!sock_owned_by_user(sk)) {
>     +               // While waiting for the socket lock, the sk may have
>     +               // transitioned to FIN_WAIT2/TIME_WAIT so lookup the
>     +               // twsk and if one is found reprocess the skb
>     +               if (unlikely(sk->sk_state == TCP_CLOSE && !th->syn
>     +                       && (th->fin || th->rst))) {
>     +                       struct sock *sk2 = __inet_lookup_established(
>     +                               net, &tcp_hashinfo,
>     +                               iph->saddr, th->source,
>     +                               iph->daddr, ntohs(th->dest),
>     +                               inet_iif(skb), sdif);
>     +                       if (sk2) {
>     +                               if (sk2 == sk) {
>     +                                       sock_put(sk2);
>     +                               } else {
>     +                                       bh_unlock_sock(sk);
>     +                                       tcp_v4_restore_cb(skb);
>     +                                       if (refcounted) sock_put(sk);
>     +                                       sk = sk2;
>     +                                       refcounted = true;
>     +                                       goto process;
>     +                               }
>     +                       }
>     +               }


Here are my comments


1) This fixes IPv4 side only, so it can not be a proper fix.

2) TCP is best effort. You can retry the lookup in ehash tables as
many times you want, a race can always happen after your last lookup.

  Normal TCP flows going through a real NIC wont hit this race, since
all packets for a given 4-tuple are handled by one cpu (RSS affinity)

Basically, the race here is that 2 packets for the same flow are
handled by two cpus.
Who wins the race is random, we can not enforce a particular order.

I would rather try to fix the issue more generically, without adding
extra lookups as you did, since they might appear
to reduce the race, but not completely fix it.

For example, the fact that the client side ignores the RST and
retransmits a SYN after one second might be something that should be
fixed.



11:57:14.436259 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [S], seq
2560603644, win 65495, options [mss 65495,sackOK,TS val 953760623 ecr
0,nop,wscale 7], length 0
11:57:14.436266 IP 127.0.0.1.4242 > 127.0.0.1.45150: Flags [.], ack 5,
win 512, options [nop,nop,TS val 953760623 ecr 953759375], length 0
11:57:14.436271 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [R], seq
2541101298, win 0, length 0
11:57:15.464613 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [S], seq
2560603644, win 65495, options [mss 65495,sackOK,TS val 953761652 ecr
0,nop,wscale 7], length 0



                    skb_to_free = sk->sk_rx_skb_cache;
>                     sk->sk_rx_skb_cache = NULL;
>                     ret = tcp_v4_do_rcv(sk, skb);
>
> We applied this change to the kernel and confirmed that the latency spikes
> disappeared with the reproduce program.
>
>
> More Races
> ----------
>
> Further, the man who found the code path and made the fix found another race
> resulted from the commit ec94c2696f0b ("tcp/dccp: avoid one atomic operation
> for timewait hashdance").  He believes the 'refcount_set()' should be done
> before the 'spin_lock()', as it allows others to see the packet in the list but
> ignore as the reference count is zero.  This race seems much rare than the
> above one and thus we have no reproducible test for this, yet.

Again, TCP is best effort, seeing the refcount being 0 or not is
absolutely fine.

The cpu reading the refcnt can always be faster than the cpu setting
the refcount to non zero value, no matter how hard you try.

The rules are more like : we need to ensure all fields have
stable/updated values before allowing other cpus to get the object.
Therefore, writing a non zero refcount should happen last.

Thanks.

>
>
> Request for Comments
> ====================
>
> So, may I ask your comments about this issue and our experimental solution?
> Below is the source code of the reproducible program.
>
>
> Thanks,
> SeongJae Park
>
>
>
> ============================== 8< ============================================
> ========================     client.c     ====================================
> ============================== 8< ============================================
> /*
>  * This code is a modification of the code at
>  * https://www.geeksforgeeks.org/socket-programming-cc/
>  */
> #include <arpa/inet.h>
> #include <error.h>
> #include <netinet/tcp.h>
> #include <stdio.h>
> #include <sys/socket.h>
> #include <sys/time.h>
> #include <unistd.h>
>
> #define timediff(s, e) ((e.tv_sec - s.tv_sec) * 1000000 + e.tv_usec - s.tv_usec)
>
> int main(int argc, char const *argv[])
> {
>         int sock = 0;
>         struct sockaddr_in addr, laddr;
>         socklen_t len = sizeof(laddr);
>         struct linger sl;
>         int flag = 1;
>         int buffer;
>         int rc;
>         struct timeval start, end;
>         unsigned long lat, sum_lat = 0, nr_lat = 0;
>
>         while (1) {
>                 gettimeofday(&start, NULL);
>
>                 sock = socket(AF_INET, SOCK_STREAM, 0);
>                 if (sock < 0)
>                         error(-1, -1, "socket creation");
>
>                 sl.l_onoff = 1;
>                 sl.l_linger = 0;
>                 if (setsockopt(sock, SOL_SOCKET, SO_LINGER, &sl, sizeof(sl)))
>                         error(-1, -1, "setsockopt(linger)");
>
>                 if (setsockopt(sock, IPPROTO_TCP, TCP_NODELAY,
>                                         &flag, sizeof(flag)))
>                         error(-1, -1, "setsockopt(nodelay)");
>
>                 addr.sin_family = AF_INET;
>                 addr.sin_port = htons(4242);
>
>                 rc = inet_pton(AF_INET, "127.0.0.1", &addr.sin_addr);
>                 if (rc <= 0)
>                         error(-1, -1, "inet_pton");
>
>                 rc = connect(sock, (struct sockaddr *)&addr, sizeof(addr));
>                 if (rc < 0)
>                         error(-1, -1, "connect");
>
>                 send(sock, &buffer, sizeof(buffer), 0);
>
>                 read(sock, &buffer, sizeof(buffer));
>                 read(sock, &buffer, sizeof(buffer));
>
>                 gettimeofday(&end, NULL);
>                 lat = timediff(start, end);
>                 sum_lat += lat;
>                 nr_lat++;
>                 if (lat > 100000) {
>                         rc = getsockname(sock, (struct sockaddr *)&laddr, &len);
>                         if (rc == -1)
>                                 error(-1, -1, "getsockname");
>                         printf("port: %d, lat: %lu, avg: %lu, nr: %lu\n",
>                                         ntohs(laddr.sin_port), lat,
>                                         sum_lat / nr_lat, nr_lat);
>                 }
>
>                 if (nr_lat % 1000 == 0)
>                         fflush(stdout);
>
>
>                 close(sock);
>         }
>         return 0;
> }
> ============================== 8< ============================================
> ========================     server.c     ====================================
> ============================== 8< ============================================
> /*
>  * This code is a modification of the code at
>  * https://www.geeksforgeeks.org/socket-programming-cc/
>  */
> #include <error.h>
> #include <netinet/in.h>
> #include <stdio.h>
> #include <sys/socket.h>
> #include <unistd.h>
>
> int main(int argc, char const *argv[])
> {
>         int sock, new_sock;
>         int opt = 1;
>         struct sockaddr_in address;
>         int addrlen = sizeof(address);
>         int buffer;
>         int rc;
>
>         sock = socket(AF_INET, SOCK_STREAM, 0);
>         if (!sock)
>                 error(-1, -1, "socket");
>
>         rc = setsockopt(sock, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT,
>                         &opt, sizeof(opt));
>         if (rc == -1)
>                 error(-1, -1, "setsockopt");
>
>         address.sin_family = AF_INET;
>         address.sin_addr.s_addr = INADDR_ANY;
>         address.sin_port = htons(4242);
>
>         rc = bind(sock, (struct sockaddr *)&address, sizeof(address));
>         if (rc < 0)
>                 error(-1, -1, "bind");
>
>         rc = listen(sock, 3);
>         if (rc < 0)
>                 error(-1, -1, "listen");
>
>         while (1) {
>                 new_sock = accept(sock, (struct sockaddr *)&address,
>                                 (socklen_t *)&addrlen);
>                 if (new_sock < 0)
>                         error(-1, -1, "accept");
>
>                 rc = read(new_sock, &buffer, sizeof(buffer));
>                 close(new_sock);
>         }
>         return 0;
> }
