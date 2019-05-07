Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F258D16319
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 13:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbfEGLv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 07:51:58 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:45165 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbfEGLv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 07:51:58 -0400
Received: by mail-ot1-f68.google.com with SMTP id a10so14569613otl.12;
        Tue, 07 May 2019 04:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=neGcq9TNm3/VXCL8J7LdzTwGn3D2FbvJykVms5Lu41A=;
        b=gSOliNBjp/XSI8gDXg2K0GAVlKgci1sYHiLoThct0MfiDn01M82D/EPgWGBMQA2OdA
         tNDdXFc9WmqXJj/oyhV0JNOZBzqfLRdGxDrSz/FPfC5eInnpXx9Brmqr9vYtP5NUp+Yq
         dAOSqM5lpGydksOvzp+ZweZSqBHFM506q+XtNXa1Ojs6uD1qbAIv4eg6xgf5FjvBy8Wx
         i/LdXRSnJhf8bNrcwl1oWTzXjUtAAjyZ48z7B6HsxqhnkVXM2GiL/yWkwVl2UL7x/S6X
         VZIePnBc4EUwaCUFCKw9ijFLu46vqDlVrj0NRpWPSy/J7hxBEK34ZyssiuE0UsDWVTy0
         1lGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=neGcq9TNm3/VXCL8J7LdzTwGn3D2FbvJykVms5Lu41A=;
        b=Hiat4SpPeu9d2TotisZFvE0++utng+tthnBHNHBubv17BHBXWQ+6C/PhFttTOdSXxx
         s69CGvBQYBpBG1MLzILW+qzhOdAaJ8bZ4ioq6XGqXLmEWIRUvkN5p3nSMZSajdj+Qcpm
         xEQeRrB1YMVDVAEW5F7A1SFoo1meCC9N2ck/E5Yf4T5TnjLX4sHEpOZYBi5NgJDrIEDv
         rTnVUdEEtU6gIgMJE1y+HO5pkQI5jIWk5fdnvtcCUdSWdQLDFyurUhNbSnHXSAz2m3YA
         yMcLwZE/Kdshv+8ASikFpQ+Rdz6pyS4ZNkqlpgmDMAW0cIWNJDh0M++J8imcE3QuBHNI
         1MCg==
X-Gm-Message-State: APjAAAWlaeMsTatbQLIrHvi3MvPEWVwaROyZbMk313Pw8kzZiHQ3sJBk
        aXCJ+G5i0GcgkIRsI0dP4OzjUGqloTuqCIE+y4E=
X-Google-Smtp-Source: APXvYqyj5wzsciVMjJq1SQjPsXjgx15H3lIoWpp13H8QzIxiClond30OIwsgjMMHJ0qlbQiMbEsxdqL3sbpVKQ516gg=
X-Received: by 2002:a9d:4e4:: with SMTP id 91mr21535730otm.62.1557229916835;
 Tue, 07 May 2019 04:51:56 -0700 (PDT)
MIME-Version: 1.0
References: <1556786363-28743-1-git-send-email-magnus.karlsson@intel.com> <20190506163135.blyqrxitmk5yrw7c@ast-mbp>
In-Reply-To: <20190506163135.blyqrxitmk5yrw7c@ast-mbp>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 7 May 2019 13:51:45 +0200
Message-ID: <CAJ8uoz2MFtoXwuhAp5A0teMmwU2v623pHf2k0WSFi0kovJYjtw@mail.gmail.com>
Subject: Re: [RFC bpf-next 0/7] busy poll support for AF_XDP sockets
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf@vger.kernel.org, Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jonathan Lemon <bsd@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 6, 2019 at 6:33 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, May 02, 2019 at 10:39:16AM +0200, Magnus Karlsson wrote:
> > This RFC proposes to add busy-poll support to AF_XDP sockets. With
> > busy-poll, the driver is executed in process context by calling the
> > poll() syscall. The main advantage with this is that all processing
> > occurs on a single core. This eliminates the core-to-core cache
> > transfers that occur between the application and the softirqd
> > processing on another core, that occurs without busy-poll. From a
> > systems point of view, it also provides an advatage that we do not
> > have to provision extra cores in the system to handle
> > ksoftirqd/softirq processing, as all processing is done on the single
> > core that executes the application. The drawback of busy-poll is that
> > max throughput seen from a single application will be lower (due to
> > the syscall), but on a per core basis it will often be higher as
> > the normal mode runs on two cores and busy-poll on a single one.
> >
> > The semantics of busy-poll from the application point of view are the
> > following:
> >
> > * The application is required to call poll() to drive rx and tx
> >   processing. There is no guarantee that softirq and interrupts will
> >   do this for you. This is in contrast with the current
> >   implementations of busy-poll that are opportunistic in the sense
> >   that packets might be received/transmitted by busy-poll or
> >   softirqd. (In this patch set, softirq/ksoftirqd will kick in at high
> >   loads just as the current opportunistic implementations, but I would
> >   like to get to a point where this is not the case for busy-poll
> >   enabled XDP sockets, as this slows down performance considerably and
> >   starts to use one more core for the softirq processing. The end goal
> >   is for only poll() to drive the napi loop when busy-poll is enabled
> >   on an AF_XDP socket. More about this later.)
> >
> > * It should be enabled on a per socket basis. No global enablement, i.e.
> >   the XDP socket busy-poll will not care about the current
> >   /proc/sys/net/core/busy_poll and busy_read global enablement
> >   mechanisms.
> >
> > * The batch size (how many packets that are processed every time the
> >   napi function in the driver is called, i.e. the weight parameter)
> >   should be configurable. Currently, the busy-poll size of AF_INET
> >   sockets is set to 8, but for AF_XDP sockets this is too small as the
> >   amount of processing per packet is much smaller with AF_XDP. This
> >   should be configurable on a per socket basis.
> >
> > * If you put multiple AF_XDP busy-poll enabled sockets into a poll()
> >   call the napi contexts of all of them should be executed. This is in
> >   contrast to the AF_INET busy-poll that quits after the fist one that
> >   finds any packets. We need all napi contexts to be executed due to
> >   the first requirement in this list. The behaviour we want is much more
> >   like regular sockets in that all of them are checked in the poll
> >   call.
> >
> > * Should be possible to mix AF_XDP busy-poll sockets with any other
> >   sockets including busy-poll AF_INET ones in a single poll() call
> >   without any change to semantics or the behaviour of any of those
> >   socket types.
> >
> > * As suggested by Maxim Mikityanskiy, poll() will in the busy-poll
> >   mode return POLLERR if the fill ring is empty or the completion
> >   queue is full.
> >
> > Busy-poll support is enabled by calling a new setsockopt called
> > XDP_BUSY_POLL_BATCH_SIZE that takes batch size as an argument. A value
> > between 1 and NAPI_WEIGHT (64) will turn it on, 0 will turn it off and
> > any other value will return an error.
> >
> > A typical packet processing rxdrop loop with busy-poll will look something
> > like this:
> >
> > for (i = 0; i < num_socks; i++) {
> >     fds[i].fd = xsk_socket__fd(xsks[i]->xsk);
> >     fds[i].events = POLLIN;
> > }
> >
> > for (;;) {
> >     ret = poll(fds, num_socks, 0);
> >     if (ret <= 0)
> >             continue;
> >
> >     for (i = 0; i < num_socks; i++)
> >         rx_drop(xsks[i], fds); /* The actual application */
> > }
> >
> > Need some advice around this issue please:
> >
> > In this patch set, softirq/ksoftirqd will kick in at high loads and
> > render the busy poll support useless as the execution is now happening
> > in the same way as without busy-poll support. Everything works from an
> > application perspective but this defeats the purpose of the support
> > and also consumes an extra core. What I would like to accomplish when
>
> Not sure what you mean by 'extra core' .
> The above poll+rx_drop is executed for every af_xdp socket
> and there are N cpus processing exactly N af_xdp sockets.
> Where is 'extra core'?
> Are you suggesting a model where single core will be busy-polling
> all af_xdp sockets? and then waking processing threads?
> or single core will process all sockets?
> I think the af_xdp model should be flexible and allow easy out-of-the-box
> experience, but it should be optimized for 'ideal' user that
> does the-right-thing from max packet-per-second point of view.
> I thought we've already converged on the model where af_xdp hw rx queues
> bind one-to-one to af_xdp sockets and user space pins processing
> threads one-to-one to af_xdp sockets on corresponding cpus...
> If so that's the model to optimize for on the kernel side
> while keeping all other user configurations functional.
>
> > XDP socket busy-poll is enabled is that softirq/ksoftirq is never
> > invoked for the traffic that goes to this socket. This way, we would
> > get better performance on a per core basis and also get the same
> > behaviour independent of load.
>
> I suspect separate rx kthreads of af_xdp socket processing is necessary
> with and without busy-poll exactly because of 'high load' case
> you've described.
> If we do this additional rx-kthread model why differentiate
> between busy-polling and polling?
>
> af_xdp rx queue is completely different form stack rx queue because
> of target dma address setup.
> Using stack's napi ksoftirqd threads for processing af_xdp queues creates
> the fairness issues. Isn't it better to have separate kthreads for them
> and let scheduler deal with fairness among af_xdp processing and stack?

When using ordinary poll() on an AF_XDP socket, the application will
run on one core and the driver processing will run on another in
softirq/ksoftirqd context. (Either due to explicit core and irq
pinning or due to the scheduler or irqbalance moving the two threads
apart.) In AF_XDP busy-poll mode of this RFC, I would like the
application and the driver processing to occur on a single core, thus
there is no "extra" driver core involved that need to be taken into
account when sizing and/or provisioning the system. The napi context
is in this mode invoked from syscall context when executing the poll
syscall from the application.

Executing the app and the driver on the same core could of course be
accomplished already today by pinning the application and the driver
interrupt to the same core, but that would not be that efficient due
to context switching between the two. A more efficient way would be to
call the napi loop from within the poll() syscall when you are inside
the kernel anyway. This is what the classical busy-poll mechanism
operating on AF_INET sockets does. Inside the poll() call, it executes
the napi context of the driver until it finds a packet (if it is rx)
and then returns to the application that then processes the packets. I
would like to adopt something quite similar for AF_XDP sockets. (Some
of the differences can be found at the top of the original post.)

From an API point of view with busy-poll of AF_XDP sockets, the user
would bind to a queue number and taskset its application to a specific
core and both the app and the driver execution would only occur on
that core. This is in my mind simpler than with regular poll or AF_XDP
using no syscalls on rx (i.e. current state), in which you bind to a
queue, taskset your application to a core and then you also have to
take care to route the interrupt of the queue you bound to to another
core that will execute the driver part in the kernel. So the model is
in both cases still one core - one socket - one napi. (Users can of
course create multiple sockets in an app if they desire.)

The main reasons I would like to introduce busy-poll for AF_XDP
sockets are:

* It is simpler to provision, see arguments above. Both application
  and driver runs efficiently on the same core.

* It is faster (on a per core basis) since we do not have any core to
  core communication. All header and descriptor transfers between
  kernel and application are core local which is much
  faster. Scalability will also be better. E.g., 64 bytes desc + 64
  bytes packet header = 128 bytes per packet less on the interconnect
  between cores. At 20 Mpps/core, this is ~20Gbit/s and with 20 cores
  this will be ~400Gbit/s of interconnect traffic less with busy-poll.

* It provides a way to seamlessly replace user-space drivers in DPDK
  with Linux drivers in kernel space. (Do not think I have to argue
  why this is a good idea on this list ;-).) The DPDK model is that
  application and driver run on the same core since they are both in
  user space. If we can provide the same model (both running
  efficiently on the same core, NOT drivers in user-space) with
  AF_XDP, it is easy for DPDK users to make the switch. Compare this
  to the current way where there are both application cores and
  driver/ksoftirqd cores. If a systems builder had 12 cores in his
  appliance box and they had 12 instances of a DPDK app, one on each
  core, how would he/she reason when repartitioning between
  application and driver cores? 8 application cores and 4 driver
  cores, or 6 of each? Maybe it is also packet dependent? Etc. Much
  simpler to migrate if we had an efficient way to run both of them on
  the same core.

Why no interrupt? That should have been: no interrupts enabled to
start with. We would like to avoid interrupts as much as possible
since when they trigger, we will revert to the non busy-poll model,
i.e. processing on two separate cores, and the advantages from above
will disappear. How to accomplish this?

* One way would be to create a napi context with the queue we have
  bound to but with no interrupt associated with it, or it being
  disabled. The socket would in that case only be able to receive and
  send packets when calling the poll() syscall. If you do not call
  poll(), you do not get any packets, nor are any packets sent. It
  would only be possible to support this with a poll() timeout value
  of zero. This would have the best performance

* Maybe we could support timeout values >0 by re-enabling the interrupt
  at some point. When calling poll(), the core would invoke the napi
  context repeatedly with the interrupt of that napi disabled until it
  found a packet, but max for a period of time up until the busy poll
  timeout (like regular busy poll today does). If that times out, we
  go up to the regular timeout of the poll() call and enable
  interrupts of the queue associated with the napi and put the process
  to sleep. Once woken up by an interrupt, the interrupt of the napi
  would be disabled again and control returned to the application. We
  would with this scheme process the vast majority of packets locally
  on a core with interrupts disabled and with good performance and
  only when we have low load and are sleeping/waiting in poll would we
  process some packets using interrupts on the core that the
  interrupt has been bound to.

I will produce some performance numbers for the various options and
post them in a follow up mail. We need some numbers to talk
around.

/Magnus

> >
> > To accomplish this, the driver would need to create a napi context
> > containing the busy-poll enabled XDP socket queues (not shared with
> > any other traffic) that do not have an interrupt associated with
> > it.
>
> why no interrupt?
>
> >
> > Does this sound like an avenue worth pursuing and if so, should it be
> > part of this RFC/PATCH or separate?
> >
> > Epoll() is not supported at this point in time. Since it was designed
> > for handling a very large number of sockets, I thought it was better
> > to leave this for later if the need will arise.
> >
> > To do:
> >
> > * Move over all drivers to the new xdp_[rt]xq_info functions. If you
> >   think this is the right way to go forward, I will move over
> >   Mellanox, Netronome, etc for the proper patch.
> >
> > * Performance measurements
> >
> > * Test SW drivers like virtio, veth and tap. Actually, test anything
> >   that is not i40e.
> >
> > * Test multiple sockets of different types in the same poll() call
> >
> > * Check bisectability of each patch
> >
> > * Versioning of the libbpf interface since we add an entry to the
> >   socket configuration struct
> >
> > This RFC has been applied against commit 2b5bc3c8ebce ("r8169: remove manual autoneg restart workaround")
> >
> > Structure of the patch set:
> > Patch 1: Makes the busy poll batch size configurable inside the kernel
> > Patch 2: Adds napi id to struct xdp_rxq_info, adds this to the
> >          xdp_rxq_reg_info function and changes the interface and
> >        implementation so that we only need a single copy of the
> >        xdp_rxq_info struct that resides in _rx. Previously there was
> >        another one in the driver, but now the driver uses the one in
> >        _rx. All XDP enabled drivers are converted to these new
> >        functions.
> > Patch 3: Adds a struct xdp_txq_info with corresponding functions to
> >          xdp_rxq_info that is used to store information about the tx
> >        queue. The use of these are added to all AF_XDP enabled drivers.
> > Patch 4: Introduce a new setsockopt/getsockopt in the uapi for
> >          enabling busy_poll.
> > Patch 5: Implements busy poll in the xsk code.
> > Patch 6: Add busy-poll support to libbpf.
> > Patch 7: Add busy-poll support to the xdpsock sample application.
> >
> > Thanks: Magnus
> >
> > Magnus Karlsson (7):
> >   net: fs: make busy poll budget configurable in napi_busy_loop
> >   net: i40e: ixgbe: tun: veth: virtio-net: centralize xdp_rxq_info and
> >     add napi id
> >   net: i40e: ixgbe: add xdp_txq_info structure
> >   netdevice: introduce busy-poll setsockopt for AF_XDP
> >   net: add busy-poll support for XDP sockets
> >   libbpf: add busy-poll support to XDP sockets
> >   samples/bpf: add busy-poll support to xdpsock sample
> >
> >  drivers/net/ethernet/intel/i40e/i40e_ethtool.c |   2 -
> >  drivers/net/ethernet/intel/i40e/i40e_main.c    |   8 +-
> >  drivers/net/ethernet/intel/i40e/i40e_txrx.c    |  37 ++++-
> >  drivers/net/ethernet/intel/i40e/i40e_txrx.h    |   2 +-
> >  drivers/net/ethernet/intel/i40e/i40e_xsk.c     |   2 +-
> >  drivers/net/ethernet/intel/ixgbe/ixgbe.h       |   2 +-
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c  |  48 ++++--
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c   |   2 +-
> >  drivers/net/tun.c                              |  14 +-
> >  drivers/net/veth.c                             |  10 +-
> >  drivers/net/virtio_net.c                       |   8 +-
> >  fs/eventpoll.c                                 |   5 +-
> >  include/linux/netdevice.h                      |   1 +
> >  include/net/busy_poll.h                        |   7 +-
> >  include/net/xdp.h                              |  23 ++-
> >  include/net/xdp_sock.h                         |   3 +
> >  include/uapi/linux/if_xdp.h                    |   1 +
> >  net/core/dev.c                                 |  43 ++----
> >  net/core/xdp.c                                 | 103 ++++++++++---
> >  net/xdp/Kconfig                                |   1 +
> >  net/xdp/xsk.c                                  | 122 ++++++++++++++-
> >  net/xdp/xsk_queue.h                            |  18 ++-
> >  samples/bpf/xdpsock_user.c                     | 203 +++++++++++++++----------
> >  tools/include/uapi/linux/if_xdp.h              |   1 +
> >  tools/lib/bpf/xsk.c                            |  23 +--
> >  tools/lib/bpf/xsk.h                            |   1 +
> >  26 files changed, 495 insertions(+), 195 deletions(-)
> >
> > --
> > 2.7.4
