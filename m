Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A56651877
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 02:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbiLTBpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 20:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233053AbiLTBpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 20:45:13 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7802B18E25
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 17:32:10 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id k7-20020a056830168700b0067832816190so1547640otr.1
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 17:32:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jCdd0TCRxW5GJGrV1CmxgR8yL9iVMOmFsARvqXkwjCU=;
        b=KzF4ir59Az0okIapNS4jZkfGJ6OTglRnIYVMOFp28Uax2U8nrTt92HSJ3/BeSfD/O7
         +9xaWME26gtChMR6DScNlm/0MYQWRl0E2iNSpZWMN2UFhU4EahlTzhNqmjLNMQqjsyGJ
         1eBqpHxdeOgxRgimgSkB42bkS+AL7cc1WnM00=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jCdd0TCRxW5GJGrV1CmxgR8yL9iVMOmFsARvqXkwjCU=;
        b=IrZDJCBSfPCHhgbhuNnM1jFdow8COMRKwF9yoY1UT4PQP+RQ2WhHdODJm/kKsU2hjC
         FX/yF7R6KMBuUdImzRPO93uBYtQV6a+CyRH6KDlPNd7oqoxyvEcc2QXZONXyz8I8NrQe
         kf6Gl0HmyyGkkQ0TMV1hnqFVvTQEvdgcSYgNQEWzMr7xkMOxIT/zBEQ7QOZXZL2hRXtP
         JPYg/5EqfrnsYR7m0RDydbXryRv4zrK+rYt8+lPBvmMz9nvtPZaz/O0kIm8RLUWYUepu
         Cn7wx57hQPCzShA3Q3hEN/NTBE84VIHNKzrLKRljYqYEcer3A34GR0IouRQHw8SvOxTD
         G/kg==
X-Gm-Message-State: AFqh2kowgAEzRYIRddzqsDZ6LQQKzoVrvPnQM06qewjmh2/Pjp6AtK2q
        LN/XGcXVQ0/Jcmnbc5Suv0aRSQ==
X-Google-Smtp-Source: AMrXdXsN3tS7b6c8uKzWzS9TmvA3H/GYHmeeoZeSJcS1kvyBtAQlRxDV8d3UzAYndjYrhUep7uFSDA==
X-Received: by 2002:a05:6830:104f:b0:678:221e:1fef with SMTP id b15-20020a056830104f00b00678221e1fefmr3184117otp.32.1671499929558;
        Mon, 19 Dec 2022 17:32:09 -0800 (PST)
Received: from sbohrer-cf-dell ([24.28.97.120])
        by smtp.gmail.com with ESMTPSA id l12-20020a9d550c000000b0066c49ce8b77sm5012956oth.77.2022.12.19.17.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 17:32:08 -0800 (PST)
Date:   Mon, 19 Dec 2022 19:31:57 -0600
From:   Shawn Bohrer <sbohrer@cloudflare.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, kernel-team@cloudflare.com
Subject: Re: Possible race with xsk_flush
Message-ID: <Y6EQjd5w9Dfmy8ko@sbohrer-cf-dell>
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
> 
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

After staring at this code for way too long I finally made a
breakthrough!  I could not understand how this race could occur when
napi_poll() calls netpoll_poll_lock().  Here is netpoll_poll_lock():

```
  static inline void *netpoll_poll_lock(struct napi_struct *napi)
  {
    struct net_device *dev = napi->dev;

    if (dev && dev->npinfo) {
      int owner = smp_processor_id();

      while (cmpxchg(&napi->poll_owner, -1, owner) != -1)
        cpu_relax();

      return napi;
    }
    return NULL;
  }
```
If dev or dev->npinfo are NULL then it doesn't acquire a lock at all!
Adding some more trace points I see:

```
  iperf2-1325    [002] ..s1. 264246.626880: __napi_poll: (__napi_poll+0x0/0x150) n=0xffff91c885bff000 poll_owner=-1 dev=0xffff91c881d4e000 npinfo=0x0
  iperf2-1325    [002] d.Z1. 264246.626882: __xsk_rcv_zc_L7: (__xsk_rcv_zc+0x3b/0xc0) addr=0x1503100 len=0x42 xs=0xffff91c8bfe77000 fq=0xffff91c8c1a43f80 dev=0xffff91c881d4e000
  iperf2-1325    [002] d.Z1. 264246.626883: __xsk_rcv_zc_L7: (__xsk_rcv_zc+0x42/0xc0) addr=0x1503100 len=0x42 xs=0xffff91c8bfe77000 fq=0xffff91c8c1a43f80 dev=0xffff91c881d4e000
  iperf2-1325    [002] d.Z1. 264246.626884: xsk_flush: (__xsk_map_flush+0x32/0xb0) xs=0xffff91c8bfe77000 
```

Here you can see that poll_owner=-1 meaning the lock was never
acquired because npinfo is NULL.  This means that the same veth rx
queue can be napi_polled from multiple CPU and nothing stops it from
running concurrently.  They all look like this, just most of the time
there aren't concurrent napi_polls running for the same queue.  They
do however move around CPUs as I explained earlier.

I'll note that I've ran with your suggested change of moving
xdp_do_flush() before napi_complete_done() all weekend and I have not
reproduced the issue.  I don't know if that truly means the issue is
fixed by that change or not.  I suspect it does fix the issue because
it prevents the napi_struct from being scheduled again before the
first poll has completed, and nap_schedule_prep() ensures that only
one instance is ever running.

If we think this is the correct fix I'll let it run for another day or
two and prepare a patch.

Thanks,
Shawn Bohrer
