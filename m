Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB7264D265
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 23:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiLNWcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 17:32:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiLNWcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 17:32:46 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9743135E
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 14:32:44 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id j16-20020a056830271000b0067202045ee9so2184381otu.7
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 14:32:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z/Dz4lNlQzItsfR5oTc9WYI4GhpikR1x6FAZ2lAn0dE=;
        b=ddpZoEvuuAvr1L1c+ol2Qv/XH5VtZu0E66PpRQHft5QauxWBnYXtyP3MH6CwlxX907
         HCOA6TONAg9AwR4T5Q3aTsJNaGu0Z/qMXTBIE2d0BSCRPfFP2nlO8WoMYdjsuD3APccO
         DVkL+m3zpsE8yTLtwPVYfnKlFseKNHvPir6V4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z/Dz4lNlQzItsfR5oTc9WYI4GhpikR1x6FAZ2lAn0dE=;
        b=sIAghsfwL+tEKVX5eheYaxC9zZcH9tVaIex95F4rDG9DdzpZApEWIfi2LCvu6wPqNK
         mByTaicYEZk4Cl+UJVNbSjJ7KmXT0c4goZ0Sn/k/9BLaxaf2++9idRl2e2YzY7n6pseA
         7FrDANJRV+MJG0ib+Buo7OlSTqqaoKR+NSjg5mHVS7umW07xzh8PVE2AYKzmEt2RQK8B
         SCh4HHYOWg4tVCuaqVi4IfMaDLSygB7o5lhoeahnb1AINXmTsBg3+8t52CE9ZttkVzNr
         9CT1k8x6X7AaWrRuUrhPWIfJtszSz8AjQu4XHMPwRXbp3/3J+oMMNiambtMFTeSL/6bi
         kJ3w==
X-Gm-Message-State: ANoB5plAFiMyuy/GNWLOAqi7dxoYCvdFpajyatAtNsJXQbs2yop/mq2h
        rFBu8Jh80u7C1dfiMqCgmcwSG9KfhRwLF93u
X-Google-Smtp-Source: AA0mqf5jNTAV8xL6Dltx3XcnqaZfqgwosATQDkkaYIupOn2jaVf/H5YMyxMw8c+4Pj0snq0iFYvmDw==
X-Received: by 2002:a9d:6a8e:0:b0:670:6247:fde1 with SMTP id l14-20020a9d6a8e000000b006706247fde1mr13406783otq.24.1671057163666;
        Wed, 14 Dec 2022 14:32:43 -0800 (PST)
Received: from sbohrer-cf-dell ([24.28.97.120])
        by smtp.gmail.com with ESMTPSA id o10-20020a9d6d0a000000b0067079fc1ac9sm2962085otp.44.2022.12.14.14.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 14:32:42 -0800 (PST)
Date:   Wed, 14 Dec 2022 16:32:25 -0600
From:   Shawn Bohrer <sbohrer@cloudflare.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     bjorn@kernel.org, magnus.karlsson@intel.com,
        kernel-team@cloudflare.com
Subject: Possible race with xsk_flush
Message-ID: <Y5pO+XL54ZlzZ7Qe@sbohrer-cf-dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I've been trying to track down a problem we've been seeing with
occasional corrupt packets using AF_XDP.  As you probably expect this
occurs because we end up with the same descriptor in ring multiple
times.  However, after lots of debugging and analyzing I think this is
actually caused by a kernel bug, though I still don't fully understand
what is happening.  This is currently being seen on kernel 5.15.77 and
I haven't done any testing to see if we see the same issue on newer
versions.

Inside my application I've written code to track and log as
descriptors are placed into the fill and tx queues, and when they are
pulled out of the rx and completion queues.  The transitions are
logged to /sys/kernel/debug/tracing/trace_marker.  Additionally I keep
my own VecDeque which mirrors the order descriptors are placed in the
fill queue and I verify that they come out of the rx queue in the same
order.  I do realize there are some cases where they might not come
out in the same order but I do not appear to be hitting that.

I then add several kprobes to track the kernel side with ftrace. Most
importantly are these probes:

This adds a probe on the call to xskq_prod_reserve_desc() this
actually creates two probes so you see two prints everytime it is hit:
perf probe -a '__xsk_rcv_zc:7 addr len xs xs->pool->fq'

This adds a probe on xsk_flush():
perf probe -a 'xsk_flush:0 xs'

My AF_XDP application is bound to two multi-queue veth interfaces
(called 'ingress' and 'egress' in my prints) in a networking
namespace.  I'm then generating traffic with iperf and hping3 through
these interfaces.  When I see an out-of-order descriptor in my
application I dump the state of my internal VecDeque to the
trace_marker.  Here is an example of what I'm seeing which looks like
a kernel bug:

 // On CPU 0 we've removed descriptor 0xff0900 from the fill queue,
 // copied a packet, but have not put it in the rx queue yet
 flowtrackd-9chS-142014  [000] d.Z1. 609766.698512: __xsk_rcv_zc_L7: (__xsk_rcv_zc+0x9b/0x250) addr=0xff0900 len=0x42 xs=0xffff90fd32693c00 fq=0xffff90fd03d66380
 flowtrackd-9chS-142014  [000] d.Z1. 609766.698513: __xsk_rcv_zc_L7: (__xsk_rcv_zc+0xa7/0x250) addr=0xff0900 len=0x42 xs=0xffff90fd32693c00 fq=0xffff90fd03d66380
 // On CPU 2 we've removed descriptor 0x1000900 from the fill queue,
 // copied a packet, but have not put it in the rx queue yet
          iperf2-1217    [002] d.Z1. 609766.698523: __xsk_rcv_zc_L7: (__xsk_rcv_zc+0x9b/0x250) addr=0x1000900 len=0x42 xs=0xffff90fd32693c00 fq=0xffff90fd03d66380
          iperf2-1217    [002] d.Z1. 609766.698524: __xsk_rcv_zc_L7: (__xsk_rcv_zc+0xa7/0x250) addr=0x1000900 len=0x42 xs=0xffff90fd32693c00 fq=0xffff90fd03d66380
 // On CPU 0 xsk_flush is called on the socket
 flowtrackd-9chS-142014  [000] d.Z1. 609766.698528: xsk_flush: (__xsk_map_flush+0x4e/0x180) xs=0xffff90fd32693c00
 // My application receives 0xff0900 on the ingress interface queue 1
 flowtrackd-9chS-142014  [000] ..... 609766.698540: tracing_mark_write: ingress q:1 0xff0900 FILL -> RX
 // On CPU 2 xsk_flush is called on the socket
          iperf2-1217    [002] d.Z1. 609766.698545: xsk_flush: (__xsk_map_flush+0x4e/0x180) xs=0xffff90fd32693c00
 // My application receives 0xf61900 this is unexpected.  We expected
 // to receive 0x1000900 which is what you saw in the previous
 // __xsk_rcv_zc print.  0xf61900 is in the fill queue but it is far
 // away from our current position in the ring and I've trimmed the
 // print slightly to show that.
 flowtrackd-9chS-142014  [000] ..... 609766.698617: tracing_mark_write: ingress q:1 0xf61900 FILL -> RX: expected 0x1000900 remaining: [fe4100, f9c100, f8a100, ..., f61900

From reading the code I believe that the call to
xskq_prod_reserve_desc() inside __xsk_rcv_zc is the only place
descriptors are placed into the RX queue.  To me this means I should
see a print from my probe for the mystery 0xf61900 but we do not see
this print.  Instead we see the expected 0x1000900.  One theory I have
is that there could be a race where CPU 2 increments the cached_prod
pointer but has not yet updated the addr and len, CPU 0 calls
xsk_flush(), and now my application reads the old descriptor entry
from that location in the RX ring.  This would explain everything, but
the problem with this theory is that __xsk_rcv_zc() and xsk_flush()
are getting called from within napi_poll() and this appears to hold
the netpoll_poll_lock() for the whole time which I think should
prevent the race I just described.

A couple more notes:
* The ftrace print order and timestamps seem to indicate that the CPU
  2 napi_poll is running before the CPU 0 xsk_flush().  I don't know
  if these timestamps can be trusted but it does imply that maybe this
  can race as I described.  I've triggered this twice with xsk_flush
  probes and both show the order above.
* In the 3 times I've triggered this it has occurred right when the
  softirq processing switches CPUs
* I've also triggered this before I added the xsk_flush() probe and
  in that case saw the kernel side additionally fill in the next
  expected descriptor, which in the example above would be 0xfe4100.
  This seems to indicate that my tracking is all still sane.
* This is fairly reproducible, but I've got 10 test boxes running and
  I only get maybe bug a day.

Any thoughts on if the bug I described is actually possible,
alternative theories, or other things to test/try would be welcome.

Thanks,
Shawn Bohrer
