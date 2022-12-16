Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7003564F54A
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 00:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbiLPXmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 18:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiLPXml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 18:42:41 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 021162F01A
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 15:42:40 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id v15-20020a9d69cf000000b006709b5a534aso2274612oto.11
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 15:42:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=46n84xBhSLGW7a5kDjXr+p8llGZj0FcKOugRcnHnrK8=;
        b=fZh+aIYcho7z9PSTNIbGN4xnciJJoI384MgbZPhuzY+c1QD+jF/tnbHf/D3W4JChiE
         5Wh4IK9z/HLke6MvjpWNcmXrzvwMiNvnx9U2Vhnn9vojv5+kqhzx5TkpOouNOFB5V2jZ
         FQ1RSgltv4kv2VeGYt7BzmUFNEYPzSpMY9TfE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=46n84xBhSLGW7a5kDjXr+p8llGZj0FcKOugRcnHnrK8=;
        b=r76Ew8o20JE9VMI4KJXjW9bfMVjriMZRPRpeNZGpSPAx9hFwyQttr8Vf+724ILSH6c
         Lpu3J3bvhQ5NsLZd8QpC6bk6NQFH8Cj3bCevcc5fXwnFLAOTZKSDhSOkAaKK1k/o0O7R
         hcBY/h1yNG4u1R0HBhe4CNFU3Ld7I7AtlT+FMf/7+at2d+RN/PKdoctHi//ri//RVrwV
         d7lfZ2ZO2RgU/lpX7XKECsoIr4tKeMjWKBf+s3dh8K1FdO9VOlFxkG330KBeNKv4h81n
         XBeslx4Ito0kixqzESJVdUVc250g2BlM3OaPa5futB+sYHxmVruB0gF0E3iihcL2Jwg9
         W5dw==
X-Gm-Message-State: ANoB5pmsVBMgV2LFrfIYi1NSyow21fGBBTvg99w/2ApSqxToYM33lkMy
        WfHx41bRzYccxs14r8q4C7zwrtu2FrpHD5dr
X-Google-Smtp-Source: AA0mqf4RuFSQaQOqXyDGzvDte2K8UMaxmJ4kunnrxmEw7Qa9KI/EH7X5E9H2171R1fSCjt97OXdCpw==
X-Received: by 2002:a9d:832:0:b0:671:4b44:8344 with SMTP id 47-20020a9d0832000000b006714b448344mr8812758oty.28.1671234159252;
        Fri, 16 Dec 2022 15:42:39 -0800 (PST)
Received: from sbohrer-cf-dell ([24.28.97.120])
        by smtp.gmail.com with ESMTPSA id j92-20020a9d17e5000000b00660fe564e12sm1458852otj.58.2022.12.16.15.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 15:42:38 -0800 (PST)
Date:   Fri, 16 Dec 2022 17:42:36 -0600
From:   Shawn Bohrer <sbohrer@cloudflare.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, kernel-team@cloudflare.com
Subject: Re: Possible race with xsk_flush
Message-ID: <Y50CbIe2efR/JMwz@sbohrer-cf-dell>
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
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

I've built a kernel moving xdp_do_flush() before napi_complete_done()
and will leave this running over the weekend.  I also spent a while
trying to understand the napi code to see if that reordering seemed
like it might cause the bug.  I'll admit I still don't fully undestand
the napi code or how the bug can happen.  We'll see if this appears to
fix the issue, but since it is somewhat hard to reproduce I'd love for
someone to be able to explain why it fixes it.

Thanks,
Shawn Bohrer
