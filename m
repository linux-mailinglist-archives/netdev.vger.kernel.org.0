Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADBFC64E512
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 01:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiLPAPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 19:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiLPAPV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 19:15:21 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A9427DD4
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 16:15:19 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id v82so657424oib.4
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 16:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xjntjJNW8XDkRXK7YLXd7UDq0rE4A19WJe72lqEhvfY=;
        b=ROzZW/rksvddHyRkkl+uvMmqFb65687wSurey1W4WLEusmDqhn9oUW+/6ycg0i+M3D
         bUaBSoMDjeVmvOdAhAG6C+bgTY9FBgxUcI4Q/EFCtQ0yP0P+KkQOZqL3VQBGT6zMMcSb
         GIxwmTuDeBEWvezLX6ztmul1/qV1His5eXkvE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xjntjJNW8XDkRXK7YLXd7UDq0rE4A19WJe72lqEhvfY=;
        b=BJtcNU8WDVzBNvbmXmd64iKu/638/khZlVEf4XlQe4JceHpPcdjDiy1vjU57fJ9Dk9
         Wv3jKZEFWnwMoSndjlGF29taYH+NAsGDUYJGOeqBZEfC1pHvSMSG0Nyq+sHbWnROHt6g
         5B21kXz+T7AKwsjRoA0GKMHlYLk7IN2PuF/AVgpzqZNql2LNoFutnaDlyFqMTkz+SVus
         yo44kSlWi/aUXDqF8bnb8HECIYCweTyIPG7ww4C4EESRzOXxQfhUa7TJClrNOzyAkEm5
         uIlkD5JY25e480FlZ2iMRK6g4P5xyJ35NOTajgh3yUijPeZQaxQMeLnJ2lrkKZO4Okk/
         y9fg==
X-Gm-Message-State: ANoB5pkoBa2tKHP98bvq/iQpi+HjEkcfOXL2EzSSg3NO6RYtjWVPQ4eP
        VA/C10sAzHe4NmvChL4zdQjoo23Bt7C+r5P+
X-Google-Smtp-Source: AA0mqf5pjkNlYkiP448njcCpGoXWKWujnAcqliQbo734/BpNv4ht4UiaoL3RZ302T//+I65GZCUe9w==
X-Received: by 2002:a05:6808:16a8:b0:35a:56f5:860d with SMTP id bb40-20020a05680816a800b0035a56f5860dmr16647244oib.38.1671149718981;
        Thu, 15 Dec 2022 16:15:18 -0800 (PST)
Received: from sbohrer-cf-dell ([24.28.97.120])
        by smtp.gmail.com with ESMTPSA id q19-20020a056808201300b00342eade43d4sm149924oiw.13.2022.12.15.16.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 16:15:18 -0800 (PST)
Date:   Thu, 15 Dec 2022 18:14:44 -0600
From:   Shawn Bohrer <sbohrer@cloudflare.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, kernel-team@cloudflare.com
Subject: Re: Possible race with xsk_flush
Message-ID: <Y5u4dA01y9RjjdAW@sbohrer-cf-dell>
References: <Y5pO+XL54ZlzZ7Qe@sbohrer-cf-dell>
 <CAJ8uoz2Q6rtSyVk-7jmRAhy_Zx7fN=OOepUX0kwUThDBf-eXfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ8uoz2Q6rtSyVk-7jmRAhy_Zx7fN=OOepUX0kwUThDBf-eXfw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022 at 11:22:05AM +0100, Magnus Karlsson wrote:
> Thanks Shawn for your detailed bug report. The rings between user
> space and kernel space are single-producer/single-consumer, so in your
> case when both CPU0 and CPU2 are working on the fill ring and the Rx
> ring at the same time, this will indeed produce races. The intended
> design principle to protect against this is that only one NAPI context
> can access any given ring at any point in time and that the NAPI logic
> should prevent two instances of the same NAPI instance from running at
> the same time. So if that is not true for some reason, we would get a
> race like this. Another option is that one of the CPUs should really
> process another fill ring instead of the same.
> 
> Do you see the second socket being worked on when this happens?
> 
> Could you please share how you set up the two AF_XDP sockets?

Alex Forster sent more details on the configuration but just to
reiterate there are actually 8 AF_XDP sockets in this test setup.
There are two veth interfaces and each interface has four receive
queues.  We create one socket per interface/queue pair.  Our XDP
program redirects each packet to the correct AF_XDP socket based on
the queue number.

Yes there is often activity on other sockets near the time when the
bug occurs.  This is why I'm printing xs/fq, the socket address and
fill queue address, and printing the ingress/egress device name and
queue number in my prints.  This allows to match up the user space and
kernel space prints.  Additionally we are using a shared UMEM so
descriptors could move around between sockets though I've tried to
minimize this and in every case I've seen so far the mystery
descriptor was last used on the same socket and has also been in the
fill queue just not next in line.

> Are you using XDP_DRV mode in your tests?
> 
> > A couple more notes:
> > * The ftrace print order and timestamps seem to indicate that the CPU
> >   2 napi_poll is running before the CPU 0 xsk_flush().  I don't know
> >   if these timestamps can be trusted but it does imply that maybe this
> >   can race as I described.  I've triggered this twice with xsk_flush
> >   probes and both show the order above.
> > * In the 3 times I've triggered this it has occurred right when the
> >   softirq processing switches CPUs
> 
> This is interesting. Could you check, in some way, if you only have
> one core working on the fill ring before the softirq switching and
> then after that you have two? And if you have two, is that period
> transient?

I think what you are asking is why does the softirq processing switch
CPUs?  There is still a lot I don't fully understand here but I've
tried to understand this, if only to try to make it happen more
frequently and make this easier to reproduce.

In this test setup there is no hardware IRQ.  iperf2 sends the packet
and the CPU where iperf is running runs the veth softirq.  I'm not
sure how it picks which veth receive queue receives the packets, but
they end up distributed across the veth qeueus.  Additionally
__veth_xdp_flush() calls __napi_schedule().  This is called from
veth_xdp_xmit() which I think means that transmitting packets from
AF_XDP also schedules the softirq on the current CPU for that veth
queue.  What I definitely see is that if I pin both iperf and my
application to a single CPU all softirqs of all queues run on that
single CPU.  If I pin iperf2 to one core and my application to another
core I get softirqs for all veth queues on both cores.

In our test setup we aren't applying any cpu affinity.  iperf2 is
multi-threaded and can run on all 4 cores, and our application is
multithreaded and can run on all 4 cores.  The napi scheduling seems
to be per veth queue and yes I see those softirqs move and switch
between CPUs.  I don't however have anything that clearly shows it
running concurrently on two CPUs (The stretches of __xsk_rcv_zc are
all on one core before it switches).  The closest I have is the
several microseconds where it appears xsk_flush() overlaps at the end
of my traces.  I would think that if the napi locking didn't work at
all you'd see clear overlap.

From my experiments with CPU affinity I've updated my test setup to
frequently change the CPU affinity of iperf and our application on one
of my test boxes with hopes that it helps to reproduce but I have no
results so far.

> > * I've also triggered this before I added the xsk_flush() probe and
> >   in that case saw the kernel side additionally fill in the next
> >   expected descriptor, which in the example above would be 0xfe4100.
> >   This seems to indicate that my tracking is all still sane.
> > * This is fairly reproducible, but I've got 10 test boxes running and
> >   I only get maybe bug a day.
> >
> > Any thoughts on if the bug I described is actually possible,
> > alternative theories, or other things to test/try would be welcome.
> 
> I thought this would be impossible, but apparently not :-). We are
> apparently doing something wrong in the AF_XDP code or have the wrong
> assumptions in some situation, but I just do not know what at this
> point in time. Maybe it is veth that breaks some of our assumptions,
> who knows. But let us dig into it. I need your help here, because I
> think it will be hard for me to reproduce the issue.

Yeah if you have ideas on what to test I'll do my best to try them.

I've additionally updated my application to put a bad "cookie"
descriptor address back in the RX ring before updating the consumer
pointer.  My hope is that if we then ever receive that cookie it
proves the kernel raced and failed to update the correct address.

Thanks,
Shawn Bohrer
