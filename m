Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8313B168863
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 21:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgBUUfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 15:35:36 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:8344 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgBUUfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 15:35:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1582317333; x=1613853333;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=WTDPk6f1Cves3nb97KBPz1BVOW+OgCOIA3lnEX14YVo=;
  b=PYmpeVjVG3jgbpCdMR9ttLQpO2PK1QZHnpXYRdvW0iCt0zi/3ZZXrJXR
   bsC/wEpm6+eljUJIsPQDJksDxfpfAjIvIxhTRR9wVBxV9A1T109y1yAav
   MiUifdrl0vlZ7RyGV5qyEYdzpDCtljkDmk6eRk+gGGqyh3E5VgRRW9r3a
   M=;
IronPort-SDR: ZD1c3eJ/mjKfVPGXg+YrM8bvvtxVs8RAPxnbsEAaGht7lJoI9uZQwMfTFm3UonJhfX1ziVKV3w
 zWTH92xi36YQ==
X-IronPort-AV: E=Sophos;i="5.70,469,1574121600"; 
   d="scan'208";a="19109566"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 21 Feb 2020 20:35:32 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id 56979A2D6D;
        Fri, 21 Feb 2020 20:35:29 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 21 Feb 2020 20:35:29 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.235) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 21 Feb 2020 20:35:25 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <edumazet@google.com>
CC:     <davem@davemloft.net>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <kuznet@ms2.inr.ac.ru>, <netdev@vger.kernel.org>,
        <osa-contribution-log@amazon.com>, <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net-next 0/3] ImpArove bind(addr, 0) behaviour.
Date:   Sat, 22 Feb 2020 05:35:22 +0900
Message-ID: <20200221203522.25716-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <CANn89iK2LHmjHsQw4yYFy-WoKT6YnpRPOKJkEXzJuTEaG+ayNw@mail.gmail.com>
References: <CANn89iK2LHmjHsQw4yYFy-WoKT6YnpRPOKJkEXzJuTEaG+ayNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.235]
X-ClientProxiedBy: EX13D14UWC004.ant.amazon.com (10.43.162.99) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 20 Feb 2020 11:58:00 -0800
> On Thu, Feb 20, 2020 at 7:20 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> >
> > Currently we fail to bind sockets to ephemeral ports when all of the ports
> > are exhausted even if all sockets have SO_REUSEADDR enabled. In this case,
> > we still have a chance to connect to the different remote hosts.
> >
> > The second and third patches fix the behaviour to fully utilize all space
> > of the local (addr, port) tuples.
> >
> > Kuniyuki Iwashima (3):
> >   tcp: Remove unnecessary conditions in inet_csk_bind_conflict().
> >   tcp: bind(addr, 0) remove the SO_REUSEADDR restriction when ephemeral
> >     ports are exhausted.
> >   tcp: Prevent port hijacking when ports are exhausted
> >
> >  net/ipv4/inet_connection_sock.c | 36 ++++++++++++++++++++++-----------
> >  1 file changed, 24 insertions(+), 12 deletions(-)
> 
> I am travelling at the moment, so I can not really look at these
> patches with enough time.
> 
> I would appreciate it if you provide tests to demonstrate your patches are safe.
> 
> Thanks.

I wrote a program below and run without patches and with patches.
Without patches, we cannot reuse ports in any pattern. With patches, we can
reuse ports if all of the socket have SO_REUSEADDR enabled and the first
socket is not in TCP_LISTEN.

So, I am sorry that the description of my third patch is wrong.

>     In this case, we should be able to bind sockets to the same port only if
>     the user has the first listening socket on the port

Also, I succeeded to reuse ports if both sockets are in TCP_CLOSE and have
SO_REUSEADDR and SO_REUSEPORT enabled, and I succeeded to call listen for
both sockets. I think only this case is not safe, so let me check the
condition.

Thank you.

=====
#include <arpa/inet.h>
#include <errno.h>
#include <netinet/in.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>


char *str[] = {
	"both",
	"sk1",
	"sk2",
	"none",
};

#define render_opt(x, i) (x[i] && x[i+1] ? str[0] :	\
			  (x[i] ? str[1] :		\
			   (x[i+1]? str[2] : str[3])))

int main(void) {
	struct sockaddr_in local_addr;	
	char addr[] = "10.0.2.15";
	char ip_str[16];
	unsigned int port;
	int fd[2];
	int len = sizeof(local_addr);
	int error = 0;
	int reuseaddr, reuseport;
	int opts[16][4] = { /* SO_REUSEADDR 1,2  SO_REUSEPORT 1,2 */
		{0,0,0,0},
		{0,0,0,1},
		{0,0,1,0},
		{0,0,1,1},

		{0,1,0,0},
		{0,1,0,1},
		{0,1,1,0},
		{0,1,1,1},

		{1,0,0,0},
		{1,0,0,1},
		{1,0,1,0},
		{1,0,1,1},

		{1,1,0,0},
		{1,1,0,1},
		{1,1,1,0},
		{1,1,1,1}
	};
	int listen_opt[4][2] = {
		{0,0},
		{1,0},
		{0,1},
		{1,1}
	};

	printf("SO_REUSEADDR\tSO_REUSEPORT\tLISTEN\tADDR1\t\t\tADDR2\t\t\tRESULT\n");

	for (int i = 0; i < 16; i++) {
		for (int l = 0; l < 4; l++) {
			printf("%s\t\t%s\t\t%s\t",
			       render_opt(opts[i], 0),
			       render_opt(opts[i], 2),
			       render_opt(listen_opt[l], 0));

			for (int j = 0; j < 2; j++) {
				fd[j] = socket(AF_INET, SOCK_STREAM, 0);

				reuseaddr = opts[i][j];
				reuseport = opts[i][j + 2];
				setsockopt(fd[j], SOL_SOCKET, SO_REUSEADDR, &reuseaddr, sizeof(int));
				setsockopt(fd[j], SOL_SOCKET, SO_REUSEPORT, &reuseport, sizeof(int));

				memset(&local_addr, 0, sizeof(local_addr));
				local_addr.sin_family = AF_INET;
				local_addr.sin_addr.s_addr = inet_addr(addr);
				local_addr.sin_port = 0;

				error = bind(fd[j], (struct sockaddr *)&local_addr, len);

				memset(&local_addr, 0, sizeof(local_addr));
				getsockname(fd[j], (struct sockaddr *)&local_addr, &len);
				inet_ntop(AF_INET, &local_addr.sin_addr, ip_str, sizeof(ip_str));
				port = ntohs(local_addr.sin_port);

				printf("%s:%u\t\t", ip_str, port);

				if (error < 0)
					goto error;

				if (listen_opt[l][j] == 1) {
					error = listen(fd[j], 5);
					if (error < 0)
						goto error;
				}
			}

			printf("o\n");
			goto close;
		error:
			printf("x\t%d: %s\n", errno, strerror(errno));
		close:
			close(fd[0]);
			close(fd[1]);
		}
	}

	return 0;
}
=====


===Without patches===
# sysctl -w net.ipv4.ip_local_port_range="32768 32768"
[    9.830967] ip_local_port_range: prefer different parity for start/end values.
net.ipv4.ip_local_port_range = 32768 32768
# ./reuse
SO_REUSEADDR	SO_REUSEPORT	LISTEN	ADDR1			ADDR2			RESULT
none		none		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		none		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		none		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		none		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		sk2		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		sk2		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		sk2		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		sk2		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		sk1		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		sk1		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		sk1		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		sk1		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		both		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		both		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		both		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		both		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		none		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		none		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		none		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		none		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		sk2		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		sk2		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		sk2		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		sk2		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		sk1		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		sk1		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		sk1		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		sk1		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		both		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		both		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		both		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		both		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		none		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		none		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		none		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		none		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		sk2		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		sk2		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		sk2		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		sk2		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		sk1		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		sk1		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		sk1		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		sk1		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		both		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		both		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		both		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		both		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		none		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		none		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		none		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		none		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		sk2		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		sk2		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		sk2		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		sk2		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		sk1		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		sk1		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		sk1		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		sk1		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		both		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		both		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		both		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		both		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
=====================


===With patches===
# sysctl -w net.ipv4.ip_local_port_range="32768 32768"
[   21.732038] ip_local_port_range: prefer different parity for start/end values.
net.ipv4.ip_local_port_range = 32768 32768
# ./reuse
SO_REUSEADDR	SO_REUSEPORT	LISTEN	ADDR1			ADDR2			RESULT
none		none		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		none		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		none		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		none		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		sk2		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		sk2		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		sk2		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		sk2		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		sk1		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		sk1		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		sk1		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		sk1		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		both		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		both		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		both		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
none		both		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		none		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		none		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		none		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		none		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		sk2		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		sk2		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		sk2		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		sk2		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		sk1		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		sk1		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		sk1		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		sk1		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		both		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		both		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		both		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk2		both		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		none		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		none		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		none		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		none		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		sk2		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		sk2		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		sk2		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		sk2		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		sk1		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		sk1		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		sk1		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		sk1		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		both		none	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		both		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		both		sk2	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
sk1		both		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		none		none	10.0.2.15:32768		10.0.2.15:32768		o
both		none		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		none		sk2	10.0.2.15:32768		10.0.2.15:32768		o
both		none		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		sk2		none	10.0.2.15:32768		10.0.2.15:32768		o
both		sk2		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		sk2		sk2	10.0.2.15:32768		10.0.2.15:32768		o
both		sk2		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		sk1		none	10.0.2.15:32768		10.0.2.15:32768		o
both		sk1		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		sk1		sk2	10.0.2.15:32768		10.0.2.15:32768		o
both		sk1		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		both		none	10.0.2.15:32768		10.0.2.15:32768		o
both		both		sk1	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
both		both		sk2	10.0.2.15:32768		10.0.2.15:32768		o
both		both		both	10.0.2.15:32768		0.0.0.0:0		x	98: Address already in use
==================
