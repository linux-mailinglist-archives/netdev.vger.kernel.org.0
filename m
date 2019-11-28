Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B80BF10C7C8
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 12:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfK1LMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 06:12:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35252 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726545AbfK1LMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Nov 2019 06:12:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574939543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0cRywjityWrbO6f+dCWuTxCiryKgAagA0J/Ea6HFqZY=;
        b=MzRksjKJnWp4AE4z6BbrcMbcwJk0KWywAJUdiIn9OOtky+v3QetQK0ckWWKUctYBvP3C6m
        DFsHVyI0T2atocDj7vikvkyhPrLsvWpMrvFiySngFEuewhkx49JunhJUYpAv738u9NeTxD
        7teyNDdkDTkhR3sRFyfxJhaG8cnWUNo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-3BbIUKpPOQeF4WC1iv1nUA-1; Thu, 28 Nov 2019 06:12:15 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5A88800D53;
        Thu, 28 Nov 2019 11:12:13 +0000 (UTC)
Received: from carbon (unknown [10.36.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 966F3600CA;
        Thu, 28 Nov 2019 11:12:07 +0000 (UTC)
Date:   Thu, 28 Nov 2019 12:12:05 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Marek Majkowski' <marek@cloudflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>, brouer@redhat.com
Subject: Re: epoll_wait() performance
Message-ID: <20191128121205.65c8dea1@carbon>
In-Reply-To: <5eecf41c7e124d7dbc0ab363d94b7d13@AcuMS.aculab.com>
References: <bc84e68c0980466096b0d2f6aec95747@AcuMS.aculab.com>
        <CAJPywTJYDxGQtDWLferh8ObjGp3JsvOn1om1dCiTOtY6S3qyVg@mail.gmail.com>
        <5f4028c48a1a4673bd3b38728e8ade07@AcuMS.aculab.com>
        <20191127164821.1c41deff@carbon>
        <5eecf41c7e124d7dbc0ab363d94b7d13@AcuMS.aculab.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 3BbIUKpPOQeF4WC1iv1nUA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Nov 2019 16:04:12 +0000
David Laight <David.Laight@ACULAB.COM> wrote:

> From: Jesper Dangaard Brouer
> > Sent: 27 November 2019 15:48
> > On Wed, 27 Nov 2019 10:39:44 +0000 David Laight <David.Laight@ACULAB.COM> wrote:
> >   
> > > ...  
> > > > > While using recvmmsg() to read multiple messages might seem a good idea, it is much
> > > > > slower than recv() when there is only one message (even recvmsg() is a lot slower).
> > > > > (I'm not sure why the code paths are so slow, I suspect it is all the copy_from_user()
> > > > > and faffing with the user iov[].)
> > > > >
> > > > > So using poll() we repoll the fd after calling recv() to find is there is a second message.
> > > > > However the second poll has a significant performance cost (but less than using recvmmsg()).  
> > > >
> > > > That sounds wrong. Single recvmmsg(), even when receiving only a
> > > > single message, should be faster than two syscalls - recv() and
> > > > poll().  
> > >
> > > My suspicion is the extra two copy_from_user() needed for each recvmsg are a
> > > significant overhead, most likely due to the crappy code that tries to stop
> > > the kernel buffer being overrun.
> > >
> > > I need to run the tests on a system with a 'home built' kernel to see how much
> > > difference this make (by seeing how much slower duplicating the copy makes it).
> > >
> > > The system call cost of poll() gets factored over a reasonable number of sockets.
> > > So doing poll() on a socket with no data is a lot faster that the setup for recvmsg
> > > even allowing for looking up the fd.
> > >
> > > This could be fixed by an extra flag to recvmmsg() to indicate that you only really
> > > expect one message and to call the poll() function before each subsequent receive.
> > >
> > > There is also the 'reschedule' that Eric added to the loop in recvmmsg.
> > > I don't know how much that actually costs.
> > > In this case the process is likely to be running at a RT priority and pinned to a cpu.
> > > In some cases the cpu is also reserved (at boot time) so that 'random' other code can't use it.
> > >
> > > We really do want to receive all these UDP packets in a timely manner.
> > > Although very low latency isn't itself an issue.
> > > The data is telephony audio with (typically) one packet every 20ms.
> > > The code only looks for packets every 10ms - that helps no end since, in principle,
> > > only a single poll()/epoll_wait() call (on all the sockets) is needed every 10ms.  
> > 
> > I have a simple udp_sink tool[1] that cycle through the different
> > receive socket system calls.  I gave it a quick spin on a F31 kernel
> > 5.3.12-300.fc31.x86_64 on a mlx5 100G interface, and I'm very surprised
> > to see a significant regression/slowdown for recvMmsg.
> > 
> > $ sudo ./udp_sink --port 9 --repeat 1 --count $((10**7))
> >           	run      count   	ns/pkt	pps		cycles	payload
> > recvMmsg/32	run:  0	10000000	1461.41	684270.96	5261	18	 demux:1
> > recvmsg   	run:  0	10000000	889.82	1123824.84	3203	18	 demux:1
> > read      	run:  0	10000000	974.81	1025841.68	3509	18	 demux:1
> > recvfrom  	run:  0	10000000	1056.51	946513.44	3803	18	 demux:1
> > 
> > Normal recvmsg almost have double performance that recvmmsg.
> >  recvMmsg/32 = 684,270 pps
> >  recvmsg     = 1,123,824 pps  
> 
> Can you test recv() as well?

Sure: https://github.com/netoptimizer/network-testing/commit/9e3c8b86a2d662

$ sudo taskset -c 1 ./udp_sink --port 9  --count $((10**6*2))
          	run      count   	ns/pkt	pps		cycles	payload
recvMmsg/32  	run:  0	 2000000	653.29	1530704.29	2351	18	 demux:1
recvmsg   	run:  0	 2000000	631.01	1584760.06	2271	18	 demux:1
read      	run:  0	 2000000	582.24	1717518.16	2096	18	 demux:1
recvfrom  	run:  0	 2000000	547.26	1827269.12	1970	18	 demux:1
recv      	run:  0	 2000000	547.37	1826930.39	1970	18	 demux:1

> I think it might be faster than read().

Slightly, but same speed as recvfrom.

Strangely recvMmsg is not that bad in this testrun, and it is on the
same kernel 5.3.12-300.fc31.x86_64 and hardware.  I have CPU pinned
udp_sink, as it if jumps to the CPU doing RX-NAPI it will be fighting
for CPU time with softirq (which have Eric mitigated a bit), and
results are bad and look like this:

[broadwell src]$ sudo taskset -c 5 ./udp_sink --port 9  --count $((10**6*2))
          	run      count   	ns/pkt	pps		cycles	payload
recvMmsg/32  	run:  0	 2000000	1252.44	798439.60	4508	18	 demux:1
recvmsg   	run:  0	 2000000	1917.65	521470.72	6903	18	 demux:1
read      	run:  0	 2000000	1817.31	550263.37	6542	18	 demux:1
recvfrom  	run:  0	 2000000	1742.44	573909.46	6272	18	 demux:1
recv      	run:  0	 2000000	1741.51	574213.08	6269	18	 demux:1


> [...]
> > Found some old results (approx v4.10-rc1):
> > 
> > [brouer@skylake src]$ sudo taskset -c 2 ./udp_sink --count $((10**7)) --port 9 --connect
> >  recvMmsg/32    run: 0 10000000 537.89  1859106.74      2155    21559353816
> >  recvmsg        run: 0 10000000 552.69  1809344.44      2215    22152468673
> >  read           run: 0 10000000 476.65  2097970.76      1910    19104864199
> >  recvfrom       run: 0 10000000 450.76  2218492.60      1806    18066972794  
> 
> That is probably nearer what I am seeing on a 4.15 Ubuntu 18.04 kernel.
> recvmmsg() and recvmsg() are similar - but both a lot slower then recv().

Notice tool can also test connect UDP sockets, which is done in above.
I did a quick run with --connect:

$ sudo taskset -c 1 ./udp_sink --port 9  --count $((10**6*2)) --connect
          	run      count   	ns/pkt	pps		cycles	payload
recvMmsg/32  	run:  0	 2000000	500.72	1997107.02	1802	18	 demux:1 c:1
recvmsg   	run:  0	 2000000	662.52	1509380.46	2385	18	 demux:1 c:1
read      	run:  0	 2000000	613.46	1630103.14	2208	18	 demux:1 c:1
recvfrom  	run:  0	 2000000	577.71	1730974.34	2079	18	 demux:1 c:1
recv      	run:  0	 2000000	578.27	1729305.35	2081	18	 demux:1 c:1

And now, recvMmsg is actually the fastest...?!


p.s.
DISPLAIMER: Do notice that this udp_sink tool is a network-overload
micro-benchmark, that does not represent the use-case you are
describing.
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

