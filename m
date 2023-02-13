Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1BB8694599
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 13:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbjBMMPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 07:15:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjBMMPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 07:15:44 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45F32725
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 04:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676290454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oeKUhJ47kuIa1giwunE6XHk8Ozo1R+YBkI35wsuG/UQ=;
        b=HVxH9oJ/GDqXupHWHM9EDJ4voGxh+5EpR6pdlr9BR1/BhHb4Kq//6wVGjKB02QZlZCGx+K
        7btDcIcNaysYdn7GdbymPVYHFEaGQSz3TF+SWIajh4YFVUsoHgmgzIpc/5aVsyw3L7Fsfg
        +CvlIR/+0V7Pg9xf8+155kDZOVE9ZOw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-114-5niVLVlhM76xEZKI4E6NZg-1; Mon, 13 Feb 2023 07:14:12 -0500
X-MC-Unique: 5niVLVlhM76xEZKI4E6NZg-1
Received: by mail-wm1-f70.google.com with SMTP id e38-20020a05600c4ba600b003dc434dabbdso9054132wmp.6
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 04:14:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oeKUhJ47kuIa1giwunE6XHk8Ozo1R+YBkI35wsuG/UQ=;
        b=HkUJjx/bxZJfdLmb1LVfezy6lJigt/wMJWIIk5mlQUxF8c/Hmi6trIlbXbn47sEwXC
         x3BnKZUptJ4nF/8KXwu8wTqosa7RrxiiLMRwsDYU1ea+5Tm5Sw1wlKBwleg9JA5s0zL3
         bL7+uFNvrzqOd4nyB2Z5d9BB4JGnoDqjkmG8+O/qIfIwBFsgSOn3qq+uwr2mc4sITTOP
         WkSk3tNDGwpWZi49V/tcz6DdmaEiutejnXa/vAUIWAAc+hRrUXP+E0fgq2YcPyhrp31p
         pEfIaAGuE//iDylIrNFHOmJkvGMZjr/m4B4G2HBI4Nv9IOR2SW4CVSFkUyRLKXentNJM
         ltww==
X-Gm-Message-State: AO0yUKXSp9xQkdVjQ/10M3gTSUQ4FVUSxzm8/P8B2N9wGMb+ZDBJno3R
        aXcAJpYHSEvgUOmGgbsS9K0v1ANl5o02V4lpiUxsSvM0WRDh/X74beBkkRnJyNt/eVlMuhRnIvD
        oBgSr1clWAJUMiDl/
X-Received: by 2002:a5d:6805:0:b0:2c5:5886:8505 with SMTP id w5-20020a5d6805000000b002c558868505mr2644568wru.53.1676290451747;
        Mon, 13 Feb 2023 04:14:11 -0800 (PST)
X-Google-Smtp-Source: AK7set8zRUxN2ig0D8GPy5vqM46LPVnmz4Mz8yPLO/l25VAgcGxc7IfVbeSwjm4uNe1CdrT8idz/FA==
X-Received: by 2002:a5d:6805:0:b0:2c5:5886:8505 with SMTP id w5-20020a5d6805000000b002c558868505mr2644557wru.53.1676290451543;
        Mon, 13 Feb 2023 04:14:11 -0800 (PST)
Received: from redhat.com ([2.52.132.212])
        by smtp.gmail.com with ESMTPSA id q14-20020a5d574e000000b002bfb02153d1sm10468168wrw.45.2023.02.13.04.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 04:14:10 -0800 (PST)
Date:   Mon, 13 Feb 2023 07:14:05 -0500
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
Message-ID: <20230213071148-mutt-send-email-mst@kernel.org>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
 <5fda6140fa51b4d2944f77b9e24446e4625641e2.camel@redhat.com>
 <1675395211.6279888-2-xuanzhuo@linux.alibaba.com>
 <20230203034212-mutt-send-email-mst@kernel.org>
 <1675651276.3841548-3-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1675651276.3841548-3-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 10:41:16AM +0800, Xuan Zhuo wrote:
> On Fri, 3 Feb 2023 04:17:59 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Fri, Feb 03, 2023 at 11:33:31AM +0800, Xuan Zhuo wrote:
> > > On Thu, 02 Feb 2023 15:41:44 +0100, Paolo Abeni <pabeni@redhat.com> wrote:
> > > > On Thu, 2023-02-02 at 19:00 +0800, Xuan Zhuo wrote:
> > > > > XDP socket(AF_XDP) is an excellent bypass kernel network framework. The zero
> > > > > copy feature of xsk (XDP socket) needs to be supported by the driver. The
> > > > > performance of zero copy is very good. mlx5 and intel ixgbe already support
> > > > > this feature, This patch set allows virtio-net to support xsk's zerocopy xmit
> > > > > feature.
> > > > >
> > > > > Virtio-net did not support per-queue reset, so it was impossible to support XDP
> > > > > Socket Zerocopy. At present, we have completed the work of Virtio Spec and
> > > > > Kernel in Per-Queue Reset. It is time for Virtio-Net to complete the support for
> > > > > the XDP Socket Zerocopy.
> > > > >
> > > > > Virtio-net can not increase the queue at will, so xsk shares the queue with
> > > > > kernel.
> > > > >
> > > > > On the other hand, Virtio-Net does not support generate interrupt manually, so
> > > > > when we wakeup tx xmit, we used some tips. If the CPU run by TX NAPI last time
> > > > > is other CPUs, use IPI to wake up NAPI on the remote CPU. If it is also the
> > > > > local CPU, then we wake up sofrirqd.
> > > >
> > > > Thank you for the large effort.
> > > >
> > > > Since this will likely need a few iterations, on next revision please
> > > > do split the work in multiple chunks to help the reviewer efforts -
> > > > from Documentation/process/maintainer-netdev.rst:
> > > >
> > > >  - don't post large series (> 15 patches), break them up
> > > >
> > > > In this case I guess you can split it in 1 (or even 2) pre-req series
> > > > and another one for the actual xsk zero copy support.
> > >
> > >
> > > OK.
> > >
> > > I can split patch into multiple parts such as
> > >
> > > * virtio core
> > > * xsk
> > > * virtio-net prepare
> > > * virtio-net support xsk zerocopy
> > >
> > > However, there is a problem, the virtio core part should enter the VHOST branch
> > > of Michael. Then, should I post follow-up patches to which branch vhost or
> > > next-next?
> > >
> > > Thanks.
> > >
> >
> > Here are some ideas on how to make the patchset smaller
> > and easier to merge:
> > - keep everything in virtio_net.c for now. We can split
> >   things out later, but this way your patchset will not
> >   conflict with every since change merged meanwhile.
> >   Also, split up needs to be done carefully with sane
> >   APIs between components, let's maybe not waste time
> >   on that now, do the split-up later.
> > - you have patches that add APIs then other
> >   patches use them. as long as it's only virtio net just
> >   add and use in a single patch, review is actually easier this way.
> 
> I will try to merge #16-#18 and #20-#23.

don't do the code reorg thing for now either.

leave this for later.

> 
> > - we can try merging pre-requisites earlier, then patchset
> >   size will shrink.
> 
> Do you mean the patches of virtio core? Should we put these
> patches to vhost branch?
> 
> Thanks.

I can merge patches 1-8, yes.
This patchset probably missed the merge window anyway.


> >
> >
> > > >
> > > > Thanks!
> > > >
> > > > Paolo
> > > >
> >

