Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5248968937D
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbjBCJVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:21:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbjBCJU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:20:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5750F627A5
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 01:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675415888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=epRfDPzeCVTwbxr7ZzaPb0BTAgrqd0oxNwKqq2k7gGE=;
        b=RlE+YKoeugIaQMJCwCxdcPZAVt2dxwWGToCI+Lw5eP5BjrTzKSUYRDD3j3o6qXvA2Cd1nY
        4jbMyko+RE5K64wXGrXmfoYP7d0qx8TL1jhm7q1+vHz9/6eO3gyYEN53p//PqEkgNSYpje
        PxD27d6Pt8ioWhbIEuA2fJXAFTu2Q50=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-212-PDs3Z3-CNZiQQPODJvYJQA-1; Fri, 03 Feb 2023 04:18:05 -0500
X-MC-Unique: PDs3Z3-CNZiQQPODJvYJQA-1
Received: by mail-ej1-f70.google.com with SMTP id d14-20020a170906c20e00b00889f989d8deso3482056ejz.15
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 01:18:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=epRfDPzeCVTwbxr7ZzaPb0BTAgrqd0oxNwKqq2k7gGE=;
        b=e2EC4+aCwj6oY4th/VWoxkJ/DwA4GvpDGq+rf0y4R/4ECBncoV7MX62RGwhdL1xCBm
         e5puuqPMAHdiz/R6CJtiEKbtsXyYvla6wjMhwPKYc+kdDrrsbIqaITzNVNeZvlGWEcna
         3+NhEy5u6mAgjMHQuShB9/w3VepubFvsexxBTYaw68ahEa7+EYUtVtff0b+PgwJ6lHm3
         Y46uQKNWP3qc6krLk7A3jsPe3/SOzgVJN4eLb56zBrp1f6g8YzVNHwx+oFw1YTrmGrmx
         aYwRgLs39p9UT0gEN5gnCMhwjqeGhCyqVB2sxYQxXLMHqg/tywneLtWY7u2vg3HHxLdD
         D4mQ==
X-Gm-Message-State: AO0yUKU3YlQKAuxtxhV0I74cUyI44ZO+tWg5Re9VvefkBUHfVBzerJJg
        FDMYEf6Dv8y/HKQMsgpFHowh2kCTkAFcQQjizUPqj2Nt987tKTpSmbm2NWNVvlTS0/p99p8fN6X
        ETGqXOpNs1NqBib1d
X-Received: by 2002:a17:906:4787:b0:884:37fd:bf4c with SMTP id cw7-20020a170906478700b0088437fdbf4cmr10854182ejc.19.1675415884879;
        Fri, 03 Feb 2023 01:18:04 -0800 (PST)
X-Google-Smtp-Source: AK7set/r1+CDvVLFdXnEssdesv7QuGqfhjJVfo5pd8868UK6ys7Bboue+Ipv1DMVtJdspKbRue9+hg==
X-Received: by 2002:a17:906:4787:b0:884:37fd:bf4c with SMTP id cw7-20020a170906478700b0088437fdbf4cmr10854167ejc.19.1675415884639;
        Fri, 03 Feb 2023 01:18:04 -0800 (PST)
Received: from redhat.com ([2.52.156.122])
        by smtp.gmail.com with ESMTPSA id t24-20020a1709066bd800b0088452ca0666sm1077211ejs.196.2023.02.03.01.18.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 01:18:04 -0800 (PST)
Date:   Fri, 3 Feb 2023 04:17:59 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 00/33] virtio-net: support AF_XDP zero copy
Message-ID: <20230203034212-mutt-send-email-mst@kernel.org>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
 <5fda6140fa51b4d2944f77b9e24446e4625641e2.camel@redhat.com>
 <1675395211.6279888-2-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1675395211.6279888-2-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 11:33:31AM +0800, Xuan Zhuo wrote:
> On Thu, 02 Feb 2023 15:41:44 +0100, Paolo Abeni <pabeni@redhat.com> wrote:
> > On Thu, 2023-02-02 at 19:00 +0800, Xuan Zhuo wrote:
> > > XDP socket(AF_XDP) is an excellent bypass kernel network framework. The zero
> > > copy feature of xsk (XDP socket) needs to be supported by the driver. The
> > > performance of zero copy is very good. mlx5 and intel ixgbe already support
> > > this feature, This patch set allows virtio-net to support xsk's zerocopy xmit
> > > feature.
> > >
> > > Virtio-net did not support per-queue reset, so it was impossible to support XDP
> > > Socket Zerocopy. At present, we have completed the work of Virtio Spec and
> > > Kernel in Per-Queue Reset. It is time for Virtio-Net to complete the support for
> > > the XDP Socket Zerocopy.
> > >
> > > Virtio-net can not increase the queue at will, so xsk shares the queue with
> > > kernel.
> > >
> > > On the other hand, Virtio-Net does not support generate interrupt manually, so
> > > when we wakeup tx xmit, we used some tips. If the CPU run by TX NAPI last time
> > > is other CPUs, use IPI to wake up NAPI on the remote CPU. If it is also the
> > > local CPU, then we wake up sofrirqd.
> >
> > Thank you for the large effort.
> >
> > Since this will likely need a few iterations, on next revision please
> > do split the work in multiple chunks to help the reviewer efforts -
> > from Documentation/process/maintainer-netdev.rst:
> >
> >  - don't post large series (> 15 patches), break them up
> >
> > In this case I guess you can split it in 1 (or even 2) pre-req series
> > and another one for the actual xsk zero copy support.
> 
> 
> OK.
> 
> I can split patch into multiple parts such as
> 
> * virtio core
> * xsk
> * virtio-net prepare
> * virtio-net support xsk zerocopy
> 
> However, there is a problem, the virtio core part should enter the VHOST branch
> of Michael. Then, should I post follow-up patches to which branch vhost or
> next-next?
> 
> Thanks.
> 

Here are some ideas on how to make the patchset smaller
and easier to merge:
- keep everything in virtio_net.c for now. We can split
  things out later, but this way your patchset will not
  conflict with every since change merged meanwhile.
  Also, split up needs to be done carefully with sane
  APIs between components, let's maybe not waste time
  on that now, do the split-up later.
- you have patches that add APIs then other
  patches use them. as long as it's only virtio net just
  add and use in a single patch, review is actually easier this way.
- we can try merging pre-requisites earlier, then patchset
  size will shrink.


> >
> > Thanks!
> >
> > Paolo
> >

