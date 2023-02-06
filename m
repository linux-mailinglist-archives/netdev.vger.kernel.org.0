Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87CF768B438
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 03:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjBFCqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 21:46:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBFCqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 21:46:54 -0500
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F8771A95C;
        Sun,  5 Feb 2023 18:46:51 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0VawTkZu_1675651606;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VawTkZu_1675651606)
          by smtp.aliyun-inc.com;
          Mon, 06 Feb 2023 10:46:47 +0800
Message-ID: <1675651276.3841548-3-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH 00/33] virtio-net: support AF_XDP zero copy
Date:   Mon, 6 Feb 2023 10:41:16 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
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
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
 <5fda6140fa51b4d2944f77b9e24446e4625641e2.camel@redhat.com>
 <1675395211.6279888-2-xuanzhuo@linux.alibaba.com>
 <20230203034212-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230203034212-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Feb 2023 04:17:59 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> On Fri, Feb 03, 2023 at 11:33:31AM +0800, Xuan Zhuo wrote:
> > On Thu, 02 Feb 2023 15:41:44 +0100, Paolo Abeni <pabeni@redhat.com> wrote:
> > > On Thu, 2023-02-02 at 19:00 +0800, Xuan Zhuo wrote:
> > > > XDP socket(AF_XDP) is an excellent bypass kernel network framework. The zero
> > > > copy feature of xsk (XDP socket) needs to be supported by the driver. The
> > > > performance of zero copy is very good. mlx5 and intel ixgbe already support
> > > > this feature, This patch set allows virtio-net to support xsk's zerocopy xmit
> > > > feature.
> > > >
> > > > Virtio-net did not support per-queue reset, so it was impossible to support XDP
> > > > Socket Zerocopy. At present, we have completed the work of Virtio Spec and
> > > > Kernel in Per-Queue Reset. It is time for Virtio-Net to complete the support for
> > > > the XDP Socket Zerocopy.
> > > >
> > > > Virtio-net can not increase the queue at will, so xsk shares the queue with
> > > > kernel.
> > > >
> > > > On the other hand, Virtio-Net does not support generate interrupt manually, so
> > > > when we wakeup tx xmit, we used some tips. If the CPU run by TX NAPI last time
> > > > is other CPUs, use IPI to wake up NAPI on the remote CPU. If it is also the
> > > > local CPU, then we wake up sofrirqd.
> > >
> > > Thank you for the large effort.
> > >
> > > Since this will likely need a few iterations, on next revision please
> > > do split the work in multiple chunks to help the reviewer efforts -
> > > from Documentation/process/maintainer-netdev.rst:
> > >
> > >  - don't post large series (> 15 patches), break them up
> > >
> > > In this case I guess you can split it in 1 (or even 2) pre-req series
> > > and another one for the actual xsk zero copy support.
> >
> >
> > OK.
> >
> > I can split patch into multiple parts such as
> >
> > * virtio core
> > * xsk
> > * virtio-net prepare
> > * virtio-net support xsk zerocopy
> >
> > However, there is a problem, the virtio core part should enter the VHOST branch
> > of Michael. Then, should I post follow-up patches to which branch vhost or
> > next-next?
> >
> > Thanks.
> >
>
> Here are some ideas on how to make the patchset smaller
> and easier to merge:
> - keep everything in virtio_net.c for now. We can split
>   things out later, but this way your patchset will not
>   conflict with every since change merged meanwhile.
>   Also, split up needs to be done carefully with sane
>   APIs between components, let's maybe not waste time
>   on that now, do the split-up later.
> - you have patches that add APIs then other
>   patches use them. as long as it's only virtio net just
>   add and use in a single patch, review is actually easier this way.

I will try to merge #16-#18 and #20-#23.


> - we can try merging pre-requisites earlier, then patchset
>   size will shrink.

Do you mean the patches of virtio core? Should we put these
patches to vhost branch?

Thanks.

>
>
> > >
> > > Thanks!
> > >
> > > Paolo
> > >
>
