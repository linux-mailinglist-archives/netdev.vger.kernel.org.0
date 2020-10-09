Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E945288317
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 08:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731401AbgJIG7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 02:59:35 -0400
Received: from smtp-out.kfki.hu ([148.6.0.45]:55003 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbgJIG7e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 02:59:34 -0400
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Oct 2020 02:59:32 EDT
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id ED8B167400F2;
        Fri,  9 Oct 2020 08:52:39 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Fri,  9 Oct 2020 08:52:37 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp0.kfki.hu (Postfix) with ESMTP id 3F54B67400F1;
        Fri,  9 Oct 2020 08:52:37 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 12613340D5C; Fri,  9 Oct 2020 08:52:37 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 0D8E2340D07;
        Fri,  9 Oct 2020 08:52:37 +0200 (CEST)
Date:   Fri, 9 Oct 2020 08:52:37 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
X-X-Sender: kadlec@blackhole.kfki.hu
To:     Francesco Ruggeri <fruggeri@arista.com>
cc:     open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, fw@strlen.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v2] netfilter: conntrack: connection timeout after
 re-register
In-Reply-To: <CA+HUmGhBxBHU85oFfvoAyP=hG17DG2kgO67eawk1aXmSjehOWQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.23.453.2010090838430.19307@blackhole.kfki.hu>
References: <20201007193252.7009D95C169C@us180.sjc.aristanetworks.com> <CA+HUmGhBxBHU85oFfvoAyP=hG17DG2kgO67eawk1aXmSjehOWQ@mail.gmail.com>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Francesco,

On Thu, 8 Oct 2020, Francesco Ruggeri wrote:

> On Wed, Oct 7, 2020 at 12:32 PM Francesco Ruggeri <fruggeri@arista.com> wrote:
> >
> > If the first packet conntrack sees after a re-register is an outgoing 
> > keepalive packet with no data (SEG.SEQ = SND.NXT-1), td_end is set to 
> > SND.NXT-1. When the peer correctly acknowledges SND.NXT, tcp_in_window 
> > fails check III (Upper bound for valid (s)ack: sack <= 
> > receiver.td_end) and returns false, which cascades into 
> > nf_conntrack_in setting skb->_nfct = 0 and in later conntrack iptables 
> > rules not matching. In cases where iptables are dropping packets that 
> > do not match conntrack rules this can result in idle tcp connections 
> > to time out.
> >
> > v2: adjust td_end when getting the reply rather than when sending out
> >     the keepalive packet.
> >
> 
> Any comments?
> Here is a simple reproducer. The idea is to show that keepalive packets 
> in an idle tcp connection will be dropped (and the connection will time 
> out) if conntrack hooks are de-registered and then re-registered. The 
> reproducer has two files. client_server.py creates both ends of a tcp 
> connection, bounces a few packets back and forth, and then blocks on a 
> recv on the client side. The client's keepalive is configured to time 
> out in 20 seconds. This connection should not time out. test is a bash 
> script that creates a net namespace where it sets iptables rules for the 
> connection, starts client_server.py, and then clears and restores the 
> iptables rules (which causes conntrack hooks to be de-registered and 
> re-registered).

In my opinion an iptables restore should not cause conntrack hooks to be 
de-registered and re-registered, because important TCP initialization 
parameters cannot be "restored" later from the packets. Therefore the 
proper fix would be to prevent it to happen. Otherwise your patch looks OK 
to handle the case when conntrack is intentionally restarted.

Best regards,
Jozsef
 
> ================ file client_server.py
> #!/usr/bin/python
> 
> import socket
> 
> PORT=4446
> 
> # create server socket
> sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
> sock.bind(('localhost', PORT))
> sock.listen(1)
> 
> # create client socket
> cl_sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
> cl_sock.setsockopt(socket.SOL_SOCKET, socket.SO_KEEPALIVE, 1)
> cl_sock.setsockopt(socket.IPPROTO_TCP, socket.TCP_KEEPIDLE, 2)
> cl_sock.setsockopt(socket.IPPROTO_TCP, socket.TCP_KEEPINTVL, 2)
> cl_sock.setsockopt(socket.IPPROTO_TCP, socket.TCP_KEEPCNT, 10)
> cl_sock.connect(('localhost', PORT))
> 
> srv_sock, _ = sock.accept()
> 
> # Bounce a packet back and forth a few times
> buf = 'aaaaaaaaaaaa'
> for i in range(5):
>    cl_sock.send(buf)
>    buf = srv_sock.recv(100)
>    srv_sock.send(buf)
>    buf = cl_sock.recv(100)
>    print buf
> 
> # idle the connection
> try:
>    buf = cl_sock.recv(100)
> except socket.error, e:
>    print "Error: %s" % e
> 
> sock.close()
> cl_sock.close()
> srv_sock.close()
> 
> ============== file test
> #!/bin/bash
> 
> ip netns add dummy
> ip netns exec dummy ip link set lo up
> echo "Created namespace"
> 
> ip netns exec dummy iptables-restore <<END
> *filter
> :INPUT DROP [0:0]
> :FORWARD ACCEPT [0:0]
> :OUTPUT ACCEPT [0:0]
> -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
> -A INPUT -p tcp -m tcp --dport 4446 -j ACCEPT
> COMMIT
> END
> echo "Installed iptables rules"
> 
> ip netns exec dummy ./client_server.py &
> echo "Created tcp connection"
> sleep 2
> 
> ip netns exec dummy iptables-restore << END
> *filter
> :INPUT ACCEPT [0:0]
> :FORWARD ACCEPT [0:0]
> :OUTPUT ACCEPT [0:0]
> COMMIT
> END
> echo "Cleared iptables rules"
> sleep 4
> 
> ip netns exec dummy iptables-restore << END
> *filter
> :INPUT DROP [0:0]
> :FORWARD ACCEPT [0:0]
> :OUTPUT ACCEPT [0:0]
> -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
> -A INPUT -p tcp -m tcp --dport 4446 -j ACCEPT
> COMMIT
> END
> echo "Restored original iptables rules"
> 
> wait
> ip netns del dummy
> exit 0
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
