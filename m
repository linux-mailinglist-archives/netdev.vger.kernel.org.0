Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44A4F14CF63
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 18:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbgA2ROc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 12:14:32 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:42015 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbgA2ROb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 12:14:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1580318071; x=1611854071;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=Y4qkdH4PnKR8rhbINAimoZdjk7NwzUHSP5Ch9Wm1NKg=;
  b=b71EdtqVvhj6KmOBJamjG6zb+55ITPLa4RV3BEEXtWTSDtge4vsYlUUT
   kAqMOyRqAlRlFVQPixdwYfi/ojx2cE0ZmnFaQXZbT+qRGYMIxzBD1BGFo
   Q6mR2vzZQF7MxS+I/UjmpKjPogF3uZxskq5Z6mCe4t14+AlX8drWSzFT1
   I=;
IronPort-SDR: ApPNeuqW/T97xN9up+4Fm2MFy+coHUUyl36FvdiNFU/AvPUtitFp92uZC1RQiHpT0Vw7jmI+62
 Z7nVj0OBzAWw==
X-IronPort-AV: E=Sophos;i="5.70,378,1574121600"; 
   d="scan'208";a="14793931"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 29 Jan 2020 17:14:27 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id B0A10C5D18;
        Wed, 29 Jan 2020 17:14:25 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Wed, 29 Jan 2020 17:14:25 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.161.74) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Wed, 29 Jan 2020 17:14:18 +0000
From:   <sjpark@amazon.com>
To:     <davem@davemloft.net>
CC:     <edumazet@google.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <andriin@fb.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <aams@amazon.com>, <benh@kernel.crashing.org>, <dola@amazon.com>
Subject: Latency spikes occurs from frequent socket connections
Date:   Wed, 29 Jan 2020 18:14:03 +0100
Message-ID: <20200129171403.3926-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.74]
X-ClientProxiedBy: EX13D35UWB003.ant.amazon.com (10.43.161.65) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,


We found races in the kernel code that incur latency spikes.  We thus would
like to share our investigations and hear your opinions.


Problem Reproduce
=================

You can reproduce the problem by compiling and running source code of
'server.c' and 'client.c', which I pasted at the end of this mail, as below:

    $ gcc -o client client.c
    $ gcc -o server server.c
    $ ./server &
    $ ./client
    ...
    port: 45150, lat: 1005320, avg: 229, nr: 1070811
    ...

The reproduce program works as follow.  The server creates and binds a socket
to port 4242, listen on it, and start a infinite loop.  Inside the loop, it
accepts connection, read 4 bytes from the socket, and close.
The client is constructed as an infinite loop.  Inside the loop, it creates a
socket with LINGER and NODELAY option, connect to the server, send 4 bytes
data, try read some data from server.  After the read() returns, it measure the
latency from the beginning of this loop to here and if the latency is larger
than 1 second (spike), print a message.

The 6th line of above example is the message client prints for the latency
spike.  It shows what port currently client used, the latency (in
microseconds), averaged latency (in microseconds, again), and total number of
connections client has made since beginning of this execution.  During our 10
minute execution of the reproduce program, we could see 397 times of latency
spikes among 2,744,124 connections.


Packet Trace
============

For investigation of this issue, we used tcpdump as below:

    # tcpdump -nnn -i lo port 4242

Below is a part of the trace that related with this spike.

```
11:57:13.188107 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [S], seq 2541101293, win 65495, options [mss 65495,sackOK,TS val 953759375 ecr 0,nop,wscale 7], length 0
11:57:13.188109 IP 127.0.0.1.4242 > 127.0.0.1.45150: Flags [S.], seq 2413948679, ack 2541101294, win 65483, options [mss 65495,sackOK,TS val 953759375 ecr 953759375,nop,wscale 7], length 0
11:57:13.188116 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [.], ack 1, win 512, options [nop,nop,TS val 953759375 ecr 953759375], length 0
11:57:13.188231 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [P.], seq 1:5, ack 1, win 512, options [nop,nop,TS val 953759375 ecr 953759375], length 4
11:57:13.188235 IP 127.0.0.1.4242 > 127.0.0.1.45150: Flags [.], ack 5, win 512, options [nop,nop,TS val 953759375 ecr 953759375], length 0
11:57:13.188248 IP 127.0.0.1.4242 > 127.0.0.1.45150: Flags [F.], seq 1, ack 5, win 512, options [nop,nop,TS val 953759375 ecr 953759375], length 0
11:57:13.188347 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [.], ack 2, win 512, options [nop,nop,TS val 953759375 ecr 953759375], length 0
11:57:13.188355 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [R.], seq 5, ack 2, win 512, options [nop,nop,TS val 953759375 ecr 953759375], length 0


11:57:14.436259 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [S], seq 2560603644, win 65495, options [mss 65495,sackOK,TS val 953760623 ecr 0,nop,wscale 7], length 0
11:57:14.436266 IP 127.0.0.1.4242 > 127.0.0.1.45150: Flags [.], ack 5, win 512, options [nop,nop,TS val 953760623 ecr 953759375], length 0
11:57:14.436271 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [R], seq 2541101298, win 0, length 0
11:57:15.464613 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [S], seq 2560603644, win 65495, options [mss 65495,sackOK,TS val 953761652 ecr 0,nop,wscale 7], length 0
11:57:15.464633 IP 127.0.0.1.4242 > 127.0.0.1.45150: Flags [S.], seq 2449519317, ack 2560603645, win 65483, options [mss 65495,sackOK,TS val 953761652 ecr 953761652,nop,wscale 7], length 0
11:57:15.464644 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [.], ack 1, win 512, options [nop,nop,TS val 953761652 ecr 953761652], length 0
11:57:15.464677 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [P.], seq 1:5, ack 1, win 512, options [nop,nop,TS val 953761652 ecr 953761652], length 4
11:57:15.464680 IP 127.0.0.1.4242 > 127.0.0.1.45150: Flags [.], ack 5, win 512, options [nop,nop,TS val 953761652 ecr 953761652], length 0
11:57:15.464730 IP 127.0.0.1.4242 > 127.0.0.1.45150: Flags [F.], seq 1, ack 5, win 512, options [nop,nop,TS val 953761652 ecr 953761652], length 0
11:57:15.464865 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [R.], seq 5, ack 2, win 512, options [nop,nop,TS val 953761652 ecr 953761652], length 0
```

The lower 10 lines of trace are for the latency spike made connection. You can
see that it spend more than 1 second.  The client sent SYN packet with seq
number 2560603644, but server respond with ACK with seq number 5.  This means
the connection was not properly closed.

The upper 8 lines of trace shows the last connection using the 45150 port.  The
client sent RST/ACK properly.


What Happend Inside
===================

So, according to the TCP state protocol[1], expected behavior is as below:

	 00 server				clinet
	 01 ESTABLISHED				ESTABLISHED
	 02 close()
	 03 FIN_WAIT_1
	 04 		---FIN-->
	 05 					CLOSE_WAIT
	 06 		<--ACK---
	 07 FIN_WAIT_2
	 08 		<--RST/ACK---
	 09 TIME_WAIT
	 10 		---ACK-->
	 11 					LAST_ACK
	 12 CLOSED				CLOSED

As server closes socket, server socket changes its state to FIN_WAIT_1 and send
FIN packet to client (lines 1-4).  The client changes its socket state to
CLOSE_WAIT and send ACK (lines 5 and 6).  By receiving this ACK, server socket
becomes FIN_WAIT_2 state (line 7).  The client also send RST/ACK (line 8).  By
receiving the RST/ACK, the server moves to TIME_WAIT state and send ACK to the
client.  The client now receive the ACK and move to LAST_ACK state, and now
both the server and the client goes to CLOSED.

However, due to the parallel structure of the TCP packet handling, below
reordering could happen.

	 00 server				clinet
	 01 ESTABLISHED				ESTABLISHED
	 02 close()
	 03 FIN_WAIT_1
	 04 		---FIN-->
	 05 					CLOSE_WAIT
	 06 				(<--ACK---)
	 07	  			(<--RST/ACK---)
	 08 				(fired in right order)
	 09 		<--RST/ACK---
	 10 		<--ACK---
	 11 		(arrived in wrong order)
	 12 FIN_WAIT_2

Lines 1 to 5 is same with above.  The client now send the ACK first, and then
RST/ACK.  However, these two packets are handled in parallel and thus RST/ACK
is processed before ACK.  The RST/ACK is just ignored as it is unexpected
packet.  The ACK arrives eventually and changes the server's state to
FIN_WAIT_2.  Now the server waits for RST/ACK from the client but it has
already arrived before and ignored.  Therefore, the server cannot move to
TIME_WAIT, and no ACK to the client is sent.  As a result, the client will stay
in the CLOSE_WAIT state.  Later, the port is reused and thus the previously
described situation happens.

[1] https://en.wikipedia.org/wiki/File:Tcp_state_diagram.png


Into The Kernel Code
====================

By diving into the kernel code, one of us found where most of this races comes
out.  It's in the 'tcp_v4_rcv()' function.  Roughly speaking, it does error
condition check, lookup, process, and few more works in sequence.  I'm calling
the small steps as lookup and process step as those are labeled as in the
code.  And, a few of the process step is protected by 'bh_lock_sock_nested()'.

However, the process of the RST/ACK is done outside of the critical section.
In more detail, the first 'if' statement of the process step checks current
state and go to 'do_time_wait' step, which will change the state to FIN_WAIT_2
and send the final ACK that will make the client to LAST_ACK state:

    process:
    	if (sk->sk_state == TCP_TIME_WAIT)
    		godo do_time_wait;

This is before the critical section.  Thus in some case, RST/ACK packet passes
this check while the ACK which the client has sent before RST/ACK is being
processed inside the critical section.


Experimental Fix
----------------

We confirmed this is the case by logging and some experiments.  Further,
because the process of RST/ACK packet would stuck in front of the critical
section while the ACK is being processed inside the critical section in most
case, we add one more check of the RST/ACK inside the critical section.  In
detail, it's as below:

    --- a/net/ipv4/tcp_ipv4.c
    +++ b/net/ipv4/tcp_ipv4.c
    @@ -1912,6 +1912,29 @@ int tcp_v4_rcv(struct sk_buff *skb)
            tcp_segs_in(tcp_sk(sk), skb);
            ret = 0;
            if (!sock_owned_by_user(sk)) {
    +               // While waiting for the socket lock, the sk may have
    +               // transitioned to FIN_WAIT2/TIME_WAIT so lookup the
    +               // twsk and if one is found reprocess the skb
    +               if (unlikely(sk->sk_state == TCP_CLOSE && !th->syn
    +                       && (th->fin || th->rst))) {
    +                       struct sock *sk2 = __inet_lookup_established(
    +                               net, &tcp_hashinfo,
    +                               iph->saddr, th->source,
    +                               iph->daddr, ntohs(th->dest),
    +                               inet_iif(skb), sdif);
    +                       if (sk2) {
    +                               if (sk2 == sk) {
    +                                       sock_put(sk2);
    +                               } else {
    +                                       bh_unlock_sock(sk);
    +                                       tcp_v4_restore_cb(skb);
    +                                       if (refcounted) sock_put(sk);
    +                                       sk = sk2;
    +                                       refcounted = true;
    +                                       goto process;
    +                               }
    +                       }
    +               }
                    skb_to_free = sk->sk_rx_skb_cache;
                    sk->sk_rx_skb_cache = NULL;
                    ret = tcp_v4_do_rcv(sk, skb);

We applied this change to the kernel and confirmed that the latency spikes
disappeared with the reproduce program.


More Races
----------

Further, the man who found the code path and made the fix found another race
resulted from the commit ec94c2696f0b ("tcp/dccp: avoid one atomic operation
for timewait hashdance").  He believes the 'refcount_set()' should be done
before the 'spin_lock()', as it allows others to see the packet in the list but
ignore as the reference count is zero.  This race seems much rare than the
above one and thus we have no reproducible test for this, yet.


Request for Comments
====================

So, may I ask your comments about this issue and our experimental solution?
Below is the source code of the reproducible program.


Thanks,
SeongJae Park



============================== 8< ============================================
========================     client.c     ====================================
============================== 8< ============================================
/*
 * This code is a modification of the code at
 * https://www.geeksforgeeks.org/socket-programming-cc/
 */
#include <arpa/inet.h>
#include <error.h>
#include <netinet/tcp.h>
#include <stdio.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <unistd.h>

#define timediff(s, e) ((e.tv_sec - s.tv_sec) * 1000000 + e.tv_usec - s.tv_usec)

int main(int argc, char const *argv[])
{
	int sock = 0;
	struct sockaddr_in addr, laddr;
	socklen_t len = sizeof(laddr);
	struct linger sl;
	int flag = 1;
	int buffer;
	int rc;
	struct timeval start, end;
	unsigned long lat, sum_lat = 0, nr_lat = 0;

	while (1) {
		gettimeofday(&start, NULL);

		sock = socket(AF_INET, SOCK_STREAM, 0);
		if (sock < 0)
			error(-1, -1, "socket creation");

		sl.l_onoff = 1;
		sl.l_linger = 0;
		if (setsockopt(sock, SOL_SOCKET, SO_LINGER, &sl, sizeof(sl)))
			error(-1, -1, "setsockopt(linger)");

		if (setsockopt(sock, IPPROTO_TCP, TCP_NODELAY,
					&flag, sizeof(flag)))
			error(-1, -1, "setsockopt(nodelay)");

		addr.sin_family = AF_INET;
		addr.sin_port = htons(4242);

		rc = inet_pton(AF_INET, "127.0.0.1", &addr.sin_addr);
		if (rc <= 0)
			error(-1, -1, "inet_pton");

		rc = connect(sock, (struct sockaddr *)&addr, sizeof(addr));
		if (rc < 0)
			error(-1, -1, "connect");

		send(sock, &buffer, sizeof(buffer), 0);

		read(sock, &buffer, sizeof(buffer));
		read(sock, &buffer, sizeof(buffer));

		gettimeofday(&end, NULL);
		lat = timediff(start, end);
		sum_lat += lat;
		nr_lat++;
		if (lat > 100000) {
			rc = getsockname(sock, (struct sockaddr *)&laddr, &len);
			if (rc == -1)
				error(-1, -1, "getsockname");
			printf("port: %d, lat: %lu, avg: %lu, nr: %lu\n",
					ntohs(laddr.sin_port), lat,
					sum_lat / nr_lat, nr_lat);
		}

		if (nr_lat % 1000 == 0)
			fflush(stdout);


		close(sock);
	}
	return 0;
}
============================== 8< ============================================
========================     server.c     ====================================
============================== 8< ============================================
/*
 * This code is a modification of the code at
 * https://www.geeksforgeeks.org/socket-programming-cc/
 */
#include <error.h>
#include <netinet/in.h>
#include <stdio.h>
#include <sys/socket.h>
#include <unistd.h>

int main(int argc, char const *argv[])
{
	int sock, new_sock;
	int opt = 1;
	struct sockaddr_in address;
	int addrlen = sizeof(address);
	int buffer;
	int rc;

	sock = socket(AF_INET, SOCK_STREAM, 0);
	if (!sock)
		error(-1, -1, "socket");

	rc = setsockopt(sock, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT,
			&opt, sizeof(opt));
	if (rc == -1)
		error(-1, -1, "setsockopt");

	address.sin_family = AF_INET;
	address.sin_addr.s_addr = INADDR_ANY;
	address.sin_port = htons(4242);

	rc = bind(sock, (struct sockaddr *)&address, sizeof(address));
	if (rc < 0)
		error(-1, -1, "bind");

	rc = listen(sock, 3);
	if (rc < 0)
		error(-1, -1, "listen");

	while (1) {
		new_sock = accept(sock, (struct sockaddr *)&address,
				(socklen_t *)&addrlen);
		if (new_sock < 0)
			error(-1, -1, "accept");

		rc = read(new_sock, &buffer, sizeof(buffer));
		close(new_sock);
	}
	return 0;
}
