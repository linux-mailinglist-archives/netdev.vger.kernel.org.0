Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECA8810B2AA
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 16:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfK0Psg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 10:48:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48613 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726926AbfK0Pse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 10:48:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574869712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9LGZDxyTRqw2OIYQYLZ7ycC0VZREwAlOJvMHQkzLvnU=;
        b=TA0gK6putxEOzhc5ZMsr9vM1GjZlR3KeUlF51gH5GZnOBTv0Xi1g69o6Hz2WhAbVl50jPh
        D32pZUWm4qEeEINAwSSouxAe7/hqHECsSPKXWh0N9p3TJBIywP3F7OfJFaL0CfV0Wu/Elt
        Bn24530SW4oxfc/Sw6sWWMnj4EtVyyA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-oUFNe13JP0e8UBdoYLoGQQ-1; Wed, 27 Nov 2019 10:48:29 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12B85800C7A;
        Wed, 27 Nov 2019 15:48:28 +0000 (UTC)
Received: from carbon (ovpn-200-26.brq.redhat.com [10.40.200.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 740A95C219;
        Wed, 27 Nov 2019 15:48:23 +0000 (UTC)
Date:   Wed, 27 Nov 2019 16:48:21 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Marek Majkowski' <marek@cloudflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>, brouer@redhat.com,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: epoll_wait() performance
Message-ID: <20191127164821.1c41deff@carbon>
In-Reply-To: <5f4028c48a1a4673bd3b38728e8ade07@AcuMS.aculab.com>
References: <bc84e68c0980466096b0d2f6aec95747@AcuMS.aculab.com>
        <CAJPywTJYDxGQtDWLferh8ObjGp3JsvOn1om1dCiTOtY6S3qyVg@mail.gmail.com>
        <5f4028c48a1a4673bd3b38728e8ade07@AcuMS.aculab.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: oUFNe13JP0e8UBdoYLoGQQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 27 Nov 2019 10:39:44 +0000 David Laight <David.Laight@ACULAB.COM> wrote:

> ...
> > > While using recvmmsg() to read multiple messages might seem a good idea, it is much
> > > slower than recv() when there is only one message (even recvmsg() is a lot slower).
> > > (I'm not sure why the code paths are so slow, I suspect it is all the copy_from_user()
> > > and faffing with the user iov[].)
> > >
> > > So using poll() we repoll the fd after calling recv() to find is there is a second message.
> > > However the second poll has a significant performance cost (but less than using recvmmsg()).  
> > 
> > That sounds wrong. Single recvmmsg(), even when receiving only a
> > single message, should be faster than two syscalls - recv() and
> > poll().  
> 
> My suspicion is the extra two copy_from_user() needed for each recvmsg are a
> significant overhead, most likely due to the crappy code that tries to stop
> the kernel buffer being overrun.
>
> I need to run the tests on a system with a 'home built' kernel to see how much
> difference this make (by seeing how much slower duplicating the copy makes it).
> 
> The system call cost of poll() gets factored over a reasonable number of sockets.
> So doing poll() on a socket with no data is a lot faster that the setup for recvmsg
> even allowing for looking up the fd.
> 
> This could be fixed by an extra flag to recvmmsg() to indicate that you only really
> expect one message and to call the poll() function before each subsequent receive.
> 
> There is also the 'reschedule' that Eric added to the loop in recvmmsg.
> I don't know how much that actually costs.
> In this case the process is likely to be running at a RT priority and pinned to a cpu.
> In some cases the cpu is also reserved (at boot time) so that 'random' other code can't use it.
> 
> We really do want to receive all these UDP packets in a timely manner.
> Although very low latency isn't itself an issue.
> The data is telephony audio with (typically) one packet every 20ms.
> The code only looks for packets every 10ms - that helps no end since, in principle,
> only a single poll()/epoll_wait() call (on all the sockets) is needed every 10ms.

I have a simple udp_sink tool[1] that cycle through the different
receive socket system calls.  I gave it a quick spin on a F31 kernel
5.3.12-300.fc31.x86_64 on a mlx5 100G interface, and I'm very surprised
to see a significant regression/slowdown for recvMmsg.

$ sudo ./udp_sink --port 9 --repeat 1 --count $((10**7))
          	run      count   	ns/pkt	pps		cycles	payload
recvMmsg/32  	run:  0	10000000	1461.41	684270.96	5261	18	 demux:1
recvmsg   	run:  0	10000000	889.82	1123824.84	3203	18	 demux:1
read      	run:  0	10000000	974.81	1025841.68	3509	18	 demux:1
recvfrom  	run:  0	10000000	1056.51	946513.44	3803	18	 demux:1

Normal recvmsg almost have double performance that recvmmsg.
 recvMmsg/32 = 684,270 pps
 recvmsg     = 1,123,824 pps

[1] https://github.com/netoptimizer/network-testing/blob/master/src/udp_sink.c
-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

For connected UDP socket:

$ sudo ./udp_sink --port 9 --repeat 1 --connect
          	run      count   	ns/pkt	pps		cycles	payload
recvMmsg/32  	run:  0	 1000000	1240.06	806411.73	4464	18	 demux:1 c:1
recvmsg   	run:  0	 1000000	768.80	1300724.75	2767	18	 demux:1 c:1
read      	run:  0	 1000000	823.40	1214478.40	2964	18	 demux:1 c:1
recvfrom  	run:  0	 1000000	889.19	1124616.11	3201	18	 demux:1 c:1


Found some old results (approx v4.10-rc1):

[brouer@skylake src]$ sudo taskset -c 2 ./udp_sink --count $((10**7)) --port 9 --connect
 recvMmsg/32    run: 0 10000000 537.89  1859106.74      2155    21559353816
 recvmsg        run: 0 10000000 552.69  1809344.44      2215    22152468673
 read           run: 0 10000000 476.65  2097970.76      1910    19104864199
 recvfrom       run: 0 10000000 450.76  2218492.60      1806    18066972794


