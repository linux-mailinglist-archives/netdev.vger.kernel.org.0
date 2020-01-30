Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1460C14DAD2
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 13:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbgA3Ml5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 07:41:57 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:10577 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726902AbgA3Ml4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 07:41:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1580388115; x=1611924115;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=RYelv+ZOHc2F4o+UOLMQUvM6WVUst1DmQxZ06rGG3Mk=;
  b=MW1puIL4VprB7eaaABxKj3RMJszHdrNM4u4ScxV24auG8zi6HJLIhbBa
   GKGRA1s/E7A7Zd0kkzxiLOyZNyUoO/DT5d6a5JaJci6m+ql38Mb4kLUYE
   5SLX/AgqDtr2r4jtLUhD8C7yPqvi6icquENgw3Y0eP7dvXY8UTszFEjj4
   k=;
IronPort-SDR: aeC/5RG4HaCQhPRg1bOmUwtsFtt5qsFjOM17qG7XJcl3e1uuYHAtBphOCE6SfInp3BrcuHiAct
 mCsRuAL4vdOQ==
X-IronPort-AV: E=Sophos;i="5.70,381,1574121600"; 
   d="scan'208";a="13617219"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 30 Jan 2020 12:41:44 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2c-4e7c8266.us-west-2.amazon.com (Postfix) with ESMTPS id BE21AA17BE;
        Thu, 30 Jan 2020 12:41:42 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Thu, 30 Jan 2020 12:41:42 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.160.153) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 30 Jan 2020 12:41:35 +0000
From:   <sjpark@amazon.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     <sjpark@amazon.com>, David Miller <davem@davemloft.net>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        <andriin@fb.com>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        <aams@amazon.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <dola@amazon.com>
Subject: Re: Re: Latency spikes occurs from frequent socket connections
Date:   Thu, 30 Jan 2020 13:41:21 +0100
Message-ID: <20200130124121.24587-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CANn89iJOK9UMQspgikPWb-NA6vmo+wQPB5q7hnWpHDSxYrUSnA@mail.gmail.com> (raw)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.153]
X-ClientProxiedBy: EX13D36UWA003.ant.amazon.com (10.43.160.237) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jan 2020 09:52:43 -0800 Eric Dumazet <edumazet@google.com> wrote:

> On Wed, Jan 29, 2020 at 9:14 AM <sjpark@amazon.com> wrote:
> >
> > Hello,
> >
> >
> > We found races in the kernel code that incur latency spikes.  We thus would
> > like to share our investigations and hear your opinions.
> >
> >
> > Problem Reproduce
> > =================
> >
> > You can reproduce the problem by compiling and running source code of
> > 'server.c' and 'client.c', which I pasted at the end of this mail, as below:
> >
> >     $ gcc -o client client.c
> >     $ gcc -o server server.c
> >     $ ./server &
> >     $ ./client
> >     ...
> >     port: 45150, lat: 1005320, avg: 229, nr: 1070811
> >     ...
> >
> 
> Thanks for the repro !

My pleasure :)

> 
[...]
> > Experimental Fix
> > ----------------
> >
> > We confirmed this is the case by logging and some experiments.  Further,
> > because the process of RST/ACK packet would stuck in front of the critical
> > section while the ACK is being processed inside the critical section in most
> > case, we add one more check of the RST/ACK inside the critical section.  In
> > detail, it's as below:
> >
> >     --- a/net/ipv4/tcp_ipv4.c
> >     +++ b/net/ipv4/tcp_ipv4.c
> >     @@ -1912,6 +1912,29 @@ int tcp_v4_rcv(struct sk_buff *skb)
> >             tcp_segs_in(tcp_sk(sk), skb);
> >             ret = 0;
> >             if (!sock_owned_by_user(sk)) {
> >     +               // While waiting for the socket lock, the sk may have
> >     +               // transitioned to FIN_WAIT2/TIME_WAIT so lookup the
> >     +               // twsk and if one is found reprocess the skb
> >     +               if (unlikely(sk->sk_state == TCP_CLOSE && !th->syn
> >     +                       && (th->fin || th->rst))) {
> >     +                       struct sock *sk2 = __inet_lookup_established(
> >     +                               net, &tcp_hashinfo,
> >     +                               iph->saddr, th->source,
> >     +                               iph->daddr, ntohs(th->dest),
> >     +                               inet_iif(skb), sdif);
> >     +                       if (sk2) {
> >     +                               if (sk2 == sk) {
> >     +                                       sock_put(sk2);
> >     +                               } else {
> >     +                                       bh_unlock_sock(sk);
> >     +                                       tcp_v4_restore_cb(skb);
> >     +                                       if (refcounted) sock_put(sk);
> >     +                                       sk = sk2;
> >     +                                       refcounted = true;
> >     +                                       goto process;
> >     +                               }
> >     +                       }
> >     +               }
> 
> 
> Here are my comments
> 
> 
> 1) This fixes IPv4 side only, so it can not be a proper fix.
> 
> 2) TCP is best effort. You can retry the lookup in ehash tables as
> many times you want, a race can always happen after your last lookup.
> 
>   Normal TCP flows going through a real NIC wont hit this race, since
> all packets for a given 4-tuple are handled by one cpu (RSS affinity)
> 
> Basically, the race here is that 2 packets for the same flow are
> handled by two cpus.
> Who wins the race is random, we can not enforce a particular order.

Thank you for the comments!  I personally agree with your opinions.

> 
> I would rather try to fix the issue more generically, without adding
> extra lookups as you did, since they might appear
> to reduce the race, but not completely fix it.
> 
> For example, the fact that the client side ignores the RST and
> retransmits a SYN after one second might be something that should be
> fixed.

I also agree with this direction.  It seems detecting this situation and
adjusting the return value of tcp_timeout_init() to a value much lower than the
one second would be a straightforward solution.  For a test, I modified the
function to return 1 (4ms for CONFIG_HZ=250) and confirmed the reproducer be
silent.  My following question is, how we can detect this situation in kernel?
However, I'm unsure how we can distinguish this specific case from other cases,
as everything is working as normal according to the TCP protocol.

Also, it seems the value is made to be adjustable from the user space using the
bpf callback, BPF_SOCK_OPS_TIMEOUT_INIT:

    BPF_SOCK_OPS_TIMEOUT_INIT,  /* Should return SYN-RTO value to use or
    				 * -1 if default value should be used
    				 */
 
Thus, it sounds like you are suggesting to do the detection and adjustment from
user space.  Am I understanding your point?  If not, please let me know.

> 
> 
> 
> 11:57:14.436259 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [S], seq
> 2560603644, win 65495, options [mss 65495,sackOK,TS val 953760623 ecr
> 0,nop,wscale 7], length 0
> 11:57:14.436266 IP 127.0.0.1.4242 > 127.0.0.1.45150: Flags [.], ack 5,
> win 512, options [nop,nop,TS val 953760623 ecr 953759375], length 0
> 11:57:14.436271 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [R], seq
> 2541101298, win 0, length 0
> 11:57:15.464613 IP 127.0.0.1.45150 > 127.0.0.1.4242: Flags [S], seq
> 2560603644, win 65495, options [mss 65495,sackOK,TS val 953761652 ecr
> 0,nop,wscale 7], length 0
> 
> 
> 
>                     skb_to_free = sk->sk_rx_skb_cache;
> >                     sk->sk_rx_skb_cache = NULL;
> >                     ret = tcp_v4_do_rcv(sk, skb);
> >
> > We applied this change to the kernel and confirmed that the latency spikes
> > disappeared with the reproduce program.
> >
> >
> > More Races
> > ----------
> >
> > Further, the man who found the code path and made the fix found another race
> > resulted from the commit ec94c2696f0b ("tcp/dccp: avoid one atomic operation
> > for timewait hashdance").  He believes the 'refcount_set()' should be done
> > before the 'spin_lock()', as it allows others to see the packet in the list but
> > ignore as the reference count is zero.  This race seems much rare than the
> > above one and thus we have no reproducible test for this, yet.
> 
> Again, TCP is best effort, seeing the refcount being 0 or not is
> absolutely fine.
> 
> The cpu reading the refcnt can always be faster than the cpu setting
> the refcount to non zero value, no matter how hard you try.
> 
> The rules are more like : we need to ensure all fields have
> stable/updated values before allowing other cpus to get the object.
> Therefore, writing a non zero refcount should happen last.

I personally agree on this, either.


Thanks,
SeongJae Park

> 
> Thanks.
[...]
