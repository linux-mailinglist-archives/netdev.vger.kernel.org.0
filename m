Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDC9910B331
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 17:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfK0Q06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 11:26:58 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47017 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726514AbfK0Q06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 11:26:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574872016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K5j6toD0BFeVtaIARVqGdTgt6vile1DqjAIyA0acZ78=;
        b=L2mE3cL5onaoAKimLx+QOZlxeH4eyTz0mURO2ipNu+2ZtFpEgxU8qbsylimDMtLc03HkG7
        NgVBJt3oTScpaxA3Ej7jzcxZzPJlARL426P4OOkIMEQ3IumKjlBijEq79euarVEXg33+Hq
        Vwhc2wEWnrzyv0lDSIQ+X2qgYA8qNMM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-1MrmtW4TONip9Xmkn6yp9g-1; Wed, 27 Nov 2019 11:26:55 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3F2010C58DA;
        Wed, 27 Nov 2019 16:26:53 +0000 (UTC)
Received: from ovpn-118-152.ams2.redhat.com (unknown [10.36.118.152])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8414E5D9D6;
        Wed, 27 Nov 2019 16:26:49 +0000 (UTC)
Message-ID: <0b8d7447e129539aec559fa797c07047f5a6a1b2.camel@redhat.com>
Subject: Re: epoll_wait() performance
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        David Laight <David.Laight@ACULAB.COM>
Cc:     'Marek Majkowski' <marek@cloudflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Date:   Wed, 27 Nov 2019 17:26:48 +0100
In-Reply-To: <20191127164821.1c41deff@carbon>
References: <bc84e68c0980466096b0d2f6aec95747@AcuMS.aculab.com>
         <CAJPywTJYDxGQtDWLferh8ObjGp3JsvOn1om1dCiTOtY6S3qyVg@mail.gmail.com>
         <5f4028c48a1a4673bd3b38728e8ade07@AcuMS.aculab.com>
         <20191127164821.1c41deff@carbon>
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: 1MrmtW4TONip9Xmkn6yp9g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-11-27 at 16:48 +0100, Jesper Dangaard Brouer wrote:
> On Wed, 27 Nov 2019 10:39:44 +0000 David Laight <David.Laight@ACULAB.COM> wrote:
> 
> > ...
> > > > While using recvmmsg() to read multiple messages might seem a good idea, it is much
> > > > slower than recv() when there is only one message (even recvmsg() is a lot slower).
> > > > (I'm not sure why the code paths are so slow, I suspect it is all the copy_from_user()
> > > > and faffing with the user iov[].)
> > > > 
> > > > So using poll() we repoll the fd after calling recv() to find is there is a second message.
> > > > However the second poll has a significant performance cost (but less than using recvmmsg()).  
> > > 
> > > That sounds wrong. Single recvmmsg(), even when receiving only a
> > > single message, should be faster than two syscalls - recv() and
> > > poll().  
> > 
> > My suspicion is the extra two copy_from_user() needed for each recvmsg are a
> > significant overhead, most likely due to the crappy code that tries to stop
> > the kernel buffer being overrun.
> > 
> > I need to run the tests on a system with a 'home built' kernel to see how much
> > difference this make (by seeing how much slower duplicating the copy makes it).
> > 
> > The system call cost of poll() gets factored over a reasonable number of sockets.
> > So doing poll() on a socket with no data is a lot faster that the setup for recvmsg
> > even allowing for looking up the fd.
> > 
> > This could be fixed by an extra flag to recvmmsg() to indicate that you only really
> > expect one message and to call the poll() function before each subsequent receive.
> > 
> > There is also the 'reschedule' that Eric added to the loop in recvmmsg.
> > I don't know how much that actually costs.
> > In this case the process is likely to be running at a RT priority and pinned to a cpu.
> > In some cases the cpu is also reserved (at boot time) so that 'random' other code can't use it.
> > 
> > We really do want to receive all these UDP packets in a timely manner.
> > Although very low latency isn't itself an issue.
> > The data is telephony audio with (typically) one packet every 20ms.
> > The code only looks for packets every 10ms - that helps no end since, in principle,
> > only a single poll()/epoll_wait() call (on all the sockets) is needed every 10ms.
> 
> I have a simple udp_sink tool[1] that cycle through the different
> receive socket system calls.  I gave it a quick spin on a F31 kernel
> 5.3.12-300.fc31.x86_64 on a mlx5 100G interface, and I'm very surprised
> to see a significant regression/slowdown for recvMmsg.
> 
> $ sudo ./udp_sink --port 9 --repeat 1 --count $((10**7))
>           	run      count   	ns/pkt	pps		cycles	payload
> recvMmsg/32  	run:  0	10000000	1461.41	684270.96	5261	18	 demux:1
> recvmsg   	run:  0	10000000	889.82	1123824.84	3203	18	 demux:1
> read      	run:  0	10000000	974.81	1025841.68	3509	18	 demux:1
> recvfrom  	run:  0	10000000	1056.51	946513.44	3803	18	 demux:1
> 
> Normal recvmsg almost have double performance that recvmmsg.

For stream tests, the above is true, if the BH is able to push the
packets to the socket fast enough. Otherwise the recvmmsg() will make
the user space even faster, the BH will find the user space process
sleeping more often and the BH will have to spend more time waking-up
the process.

If a single receive queue is in use this condition is not easy to meet.

Before spectre/meltdown and others mitigations using connected sockets
and removing ct/nf was usually sufficient - at least in my scenarios -
to make BH fast enough. 

But it's no more the case, and I have to use 2 or more different
receive queues.

@David: If I read your message correctly, the pkt rate you are dealing
with is quite low... are we talking about tput or latency? I guess
latency could be measurably higher with recvmmsg() in respect to other
syscall. How do you measure the releative performances of recvmmsg()
and recv() ? with micro-benchmark/rdtsc()? Am I right that you are
usually getting a single packet per recvmmsg() call?

Thanks,

PAolo

