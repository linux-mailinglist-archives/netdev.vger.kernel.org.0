Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 066E913626D
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 22:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgAIVZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 16:25:45 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57082 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728579AbgAIVZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 16:25:44 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ipfJ2-0006kW-9m; Thu, 09 Jan 2020 22:25:28 +0100
Date:   Thu, 9 Jan 2020 22:25:28 +0100
From:   Florian Westphal <fw@strlen.de>
To:     David Miller <davem@davemloft.net>
Cc:     mathew.j.martineau@linux.intel.com, netdev@vger.kernel.org,
        mptcp@lists.01.org, ast@kernel.org, daniel@iogearbox.net,
        bpf@vger.kernel.org
Subject: Re: [MPTCP] Re: [PATCH net-next v7 02/11] sock: Make sk_protocol a
 16-bit value
Message-ID: <20200109212528.GF795@breakpoint.cc>
References: <20200109155924.30122-1-mathew.j.martineau@linux.intel.com>
 <20200109155924.30122-3-mathew.j.martineau@linux.intel.com>
 <20200109.110514.747612850299504416.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109.110514.747612850299504416.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> wrote:
> From: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Date: Thu,  9 Jan 2020 07:59:15 -0800
> 
> > Match the 16-bit width of skbuff->protocol. Fills an 8-bit hole so
> > sizeof(struct sock) does not change.
> > 
> > Also take care of BPF field access for sk_type/sk_protocol. Both of them
> > are now outside the bitfield, so we can use load instructions without
> > further shifting/masking.
> > 
> > v5 -> v6:
> >  - update eBPF accessors, too (Intel's kbuild test robot)
> > v2 -> v3:
> >  - keep 'sk_type' 2 bytes aligned (Eric)
> > v1 -> v2:
> >  - preserve sk_pacing_shift as bit field (Eric)
> > 
> > Cc: Alexei Starovoitov <ast@kernel.org>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: bpf@vger.kernel.org
> > Co-developed-by: Paolo Abeni <pabeni@redhat.com>
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> > Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> > Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> 
> This is worrisome for me.
> 
> We have lots of places that now are going to be assigning  sk->sk_protocol
> into a u8 somewhere else.  A lot of them are ok because limits are enforced
> in various places, but for example:
> 
> net/ipv6/udp.c:	fl6.flowi6_proto = sk->sk_protocol;
> net/l2tp/l2tp_ip6.c:	fl6.flowi6_proto = sk->sk_protocol;
> 
> net/ipv6/inet6_connection_sock.c:	fl6->flowi6_proto = sk->sk_protocol;
> 
> net/ipv6/af_inet6.c:		fl6.flowi6_proto = sk->sk_protocol;
> net/ipv6/datagram.c:	fl6->flowi6_proto = sk->sk_protocol;
> 
> This is one just one small example situation, where flowi6_proto is a u8.

There are parts in the stack (e.g. in setsockopt code paths) that test
sk->sk_protocol vs. IPPROTO_TCP, then call tcp specific code under the sane
assumption that sk is a tcp_sock struct.

With 8bit sk_protocol, mptcp_sock structs (which is what kernel gets via
file descriptor number) would be treated as a tcp socket, because
"IPPROTO_MPTCP & 0xff" yields IPPROTO_TCP.

Changing IPPROTO_MPTCP to a value <= 255 could lead to conflicts with
real inet protocols in the future, so we can't redefine it to a 8bit
value.

If we keep sk_protocol as 8bit field, we will need to make sure that all
places testing sk_protocol == IPPROTO_TCP gain an additional sanity check
to tell tcp and mptcp sockets apart.  Moreover, any further changes to
kernel code would need same extra test, so this is a non-starter to me.

Alternatively we could change the first member of mptcp_sk struct from
inet_connection_sock to a full tcp_sock struct.  Thats roughly 1k increase
of mptcp_sock struct to ~ 3744 bytes, but then we would not have to
worry about mptcp sockets ending up in tcp code paths.

If you think such a size increase is ok I could give that solution a shot
and see what other problems with 8bit sk_protocol might remain.

Mat reported /sys/kernel/debug/tracing/trace lists mptcp sockets as
IPPROTO_TCP in the '8 bit sk_protocol' case, but if thats the only issue
this might have a smaller/acceptable "avoidance fix".
