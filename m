Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCB464EFB1
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 17:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbiLPQsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 11:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLPQsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 11:48:22 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C57186E9
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 08:48:20 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id r130so2431368oih.2
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 08:48:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tbekVvrYBD+/xI3UFUQuTz2ymo0bISsKhf+l37m0J+0=;
        b=iT9SkCPeQGfzWVOJFg9ltan1Se0x4+78t/HnlVENEumIuemVHT2y5oGKgOQyHLEP4n
         yvikBAke9SvRZESM8ivP76ngI8eDscT+I5kquRSwFUhv/NygZxy1il9ATmZuQGs+ePUQ
         kXUyXO/iiBrTHFLiHuvYWn1FGqMSPHtSZk2cs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tbekVvrYBD+/xI3UFUQuTz2ymo0bISsKhf+l37m0J+0=;
        b=45HlptKOqxaoWycKVGarF2LUoXxnDtt0PJ33DRAX99ilhOnJvI6XxRte9ZNNPt40md
         TqangqFVo1bFYfDG1xZQt6SoKCETZnXpg2BcQOxWFqfr+FPw6RytFLX5tn5CS7BKO7kX
         wVD/DuZciiMQ1rb+AhTWkqBsF/AuzpS+JMa5aTWT2+kdZJiJ4XzcqI4mHZm8Q8RC/BhG
         D6F00PqDQ7RlDW9VdGmryw0NeXdjRmUIaCqPCK+ghRmYUNZRzlfdkHqbD4E2KYT2AX/3
         XlgyBtL/tUPa0F8jWat4qacRxYjm9yBiwjiIImNKGXbEJze5mdBVVOB0ZhL2D4+F0oCB
         V6gg==
X-Gm-Message-State: ANoB5pmRrhLYCDpHoJdEkatKTMcVL/hOD+3mQSXaJw8JMyolP+mbZMNV
        HJazesgcVZLZ43wlvdpWQq7M2A==
X-Google-Smtp-Source: AA0mqf5Goosfi2/KS2mfUyhzk6c/Hg2t5j/932ShZLrCtoGZiG6aPN9JkTUsQBFyj2E5EW+GnnfiYw==
X-Received: by 2002:aca:210a:0:b0:35c:4baa:c3e5 with SMTP id 10-20020aca210a000000b0035c4baac3e5mr12412855oiz.28.1671209300088;
        Fri, 16 Dec 2022 08:48:20 -0800 (PST)
Received: from sbohrer-cf-dell ([24.28.97.120])
        by smtp.gmail.com with ESMTPSA id j9-20020a056808056900b0035a921f2093sm901122oig.20.2022.12.16.08.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 08:48:19 -0800 (PST)
Date:   Fri, 16 Dec 2022 10:48:07 -0600
From:   Shawn Bohrer <sbohrer@cloudflare.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, kernel-team@cloudflare.com
Subject: Re: Possible race with xsk_flush
Message-ID: <Y5yhR4x3GiuZi7P8@sbohrer-cf-dell>
References: <Y5pO+XL54ZlzZ7Qe@sbohrer-cf-dell>
 <CAJ8uoz2Q6rtSyVk-7jmRAhy_Zx7fN=OOepUX0kwUThDBf-eXfw@mail.gmail.com>
 <Y5u4dA01y9RjjdAW@sbohrer-cf-dell>
 <CAJ8uoz1GKvoaM0DCo1Ki8q=LHR1cjrNC=1BK7chTKKW9Po5F5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ8uoz1GKvoaM0DCo1Ki8q=LHR1cjrNC=1BK7chTKKW9Po5F5A@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 16, 2022 at 11:05:19AM +0100, Magnus Karlsson wrote:
> To summarize, we are expecting this ordering:
> 
> CPU 0 __xsk_rcv_zc()
> CPU 0 __xsk_map_flush()
> CPU 2 __xsk_rcv_zc()
> CPU 2 __xsk_map_flush()
> 
> But we are seeing this order:
> 
> CPU 0 __xsk_rcv_zc()
> CPU 2 __xsk_rcv_zc()
> CPU 0 __xsk_map_flush()
> CPU 2 __xsk_map_flush()
 
Yes exactly, and I think I've proved that this really is the order,
and the race is occurring.  See my cookie/poisoning below.

> Here is the veth NAPI poll loop:
> 
> static int veth_poll(struct napi_struct *napi, int budget)
> {
>     struct veth_rq *rq =
>     container_of(napi, struct veth_rq, xdp_napi);
>     struct veth_stats stats = {};
>     struct veth_xdp_tx_bq bq;
>     int done;
> 
>     bq.count = 0;
> 
>     xdp_set_return_frame_no_direct();
>     done = veth_xdp_rcv(rq, budget, &bq, &stats);
> 
>     if (done < budget && napi_complete_done(napi, done)) {
>         /* Write rx_notify_masked before reading ptr_ring */
>        smp_store_mb(rq->rx_notify_masked, false);
>        if (unlikely(!__ptr_ring_empty(&rq->xdp_ring))) {
>            if (napi_schedule_prep(&rq->xdp_napi)) {
>                WRITE_ONCE(rq->rx_notify_masked, true);
>                __napi_schedule(&rq->xdp_napi);
>             }
>         }
>     }
> 
>     if (stats.xdp_tx > 0)
>         veth_xdp_flush(rq, &bq);
>     if (stats.xdp_redirect > 0)
>         xdp_do_flush();
>     xdp_clear_return_frame_no_direct();
> 
>     return done;
> }
> 
> Something I have never seen before is that there is
> napi_complete_done() and a __napi_schedule() before xdp_do_flush().
> Let us check if this has something to do with it. So two suggestions
> to be executed separately:
> 
> * Put a probe at the __napi_schedule() above and check if it gets
> triggered before this problem
> * Move the "if (stats.xdp_redirect > 0) xdp_do_flush();" to just
> before "if (done < budget && napi_complete_done(napi, done)) {"
> 
> This might provide us some hints on what is going on.

Excellent observation, I haven't really looked at what
napi_complete_done() does yet.  I did notice it could call
__napi_schedule() and that seemed like it might be fine.  I'll also
note that veth_xdp_flush() can also ultimately call __napi_schedule().
I'll see what I can do to explore these ideas.
 
> > I've additionally updated my application to put a bad "cookie"
> > descriptor address back in the RX ring before updating the consumer
> > pointer.  My hope is that if we then ever receive that cookie it
> > proves the kernel raced and failed to update the correct address.

I guess this is more like poisoning the old descriptors rather than a
cookie.  This ran last night and one of my machines read back my
0xdeadbeefdeadbeef poisoned cookie value:

          iperf2-125483  [003] d.Z1. 792878.867088: __xsk_rcv_zc_L7: (__xsk_rcv_zc+0xa7/0x250) addr=0x8d4900 len=0x42 xs=0xffff8bbc542a5000 fq=0xffff8bbc1c464e40
          iperf2-125483  [003] d.Z1. 792878.867093: xsk_flush: (__xsk_map_flush+0x4e/0x180) xs=0xffff8bbc542a5000
          iperf2-125491  [001] d.Z1. 792878.867219: __xsk_rcv_zc_L7: (__xsk_rcv_zc+0xa7/0x250) addr=0xc79900 len=0x42 xs=0xffff8bbc542a5000 fq=0xffff8bbc1c464e40
          iperf2-125491  [001] d.Z1. 792878.867229: xsk_flush: (__xsk_map_flush+0x4e/0x180) xs=0xffff8bbc542a5000
          iperf2-125491  [001] d.Z1. 792878.867291: __xsk_rcv_zc_L7: (__xsk_rcv_zc+0xa7/0x250) addr=0x18e1900 len=0x42 xs=0xffff8bbc542a5000 fq=0xffff8bbc1c464e40
          iperf2-125483  [003] d.Z1. 792878.867441: __xsk_rcv_zc_L7: (__xsk_rcv_zc+0xa7/0x250) addr=0xc0a900 len=0x42 xs=0xffff8bbc542a5000 fq=0xffff8bbc1c464e40
          iperf2-125491  [001] d.Z1. 792878.867457: xsk_flush: (__xsk_map_flush+0x4e/0x180) xs=0xffff8bbc542a5000
 flowtrackd-zjTA-201813  [001] ..... 792878.867496: tracing_mark_write: ingress q:2 0x8d4900 FILL -> RX
 flowtrackd-zjTA-201813  [001] ..... 792878.867503: tracing_mark_write: ingress q:2 0xc79900 FILL -> RX
 flowtrackd-zjTA-201813  [001] ..... 792878.867506: tracing_mark_write: ingress q:2 0x18e1900 FILL -> RX
 flowtrackd-zjTA-201813  [001] ..... 792878.867524: tracing_mark_write: read invalid descriptor cookie: 0xdeadbeefdeadbeef

This shows what I've seen before where the xsk_flush() of CPU 1 runs
after (during?) __xsk_rcv_zc() of CPU 3.  In this trace we never see
the xsk_flush() from CPU 3 but I stop tracing when the bug occurs so
it probably just hasn't happened yet.

So at least to me this does confirm there is definitely a race here
where we can flush an updated producer pointer before the descriptor
address has been filled in.

--
Shawn
