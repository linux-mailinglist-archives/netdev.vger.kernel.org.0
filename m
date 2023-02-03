Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF2F3688E18
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 04:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjBCDlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 22:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjBCDlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 22:41:00 -0500
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE61AEF94;
        Thu,  2 Feb 2023 19:40:58 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0VamyOqZ_1675395653;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VamyOqZ_1675395653)
          by smtp.aliyun-inc.com;
          Fri, 03 Feb 2023 11:40:54 +0800
Message-ID: <1675395211.6279888-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH 00/33] virtio-net: support AF_XDP zero copy
Date:   Fri, 3 Feb 2023 11:33:31 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
In-Reply-To: <5fda6140fa51b4d2944f77b9e24446e4625641e2.camel@redhat.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 02 Feb 2023 15:41:44 +0100, Paolo Abeni <pabeni@redhat.com> wrote:
> On Thu, 2023-02-02 at 19:00 +0800, Xuan Zhuo wrote:
> > XDP socket(AF_XDP) is an excellent bypass kernel network framework. The zero
> > copy feature of xsk (XDP socket) needs to be supported by the driver. The
> > performance of zero copy is very good. mlx5 and intel ixgbe already support
> > this feature, This patch set allows virtio-net to support xsk's zerocopy xmit
> > feature.
> >
> > Virtio-net did not support per-queue reset, so it was impossible to support XDP
> > Socket Zerocopy. At present, we have completed the work of Virtio Spec and
> > Kernel in Per-Queue Reset. It is time for Virtio-Net to complete the support for
> > the XDP Socket Zerocopy.
> >
> > Virtio-net can not increase the queue at will, so xsk shares the queue with
> > kernel.
> >
> > On the other hand, Virtio-Net does not support generate interrupt manually, so
> > when we wakeup tx xmit, we used some tips. If the CPU run by TX NAPI last time
> > is other CPUs, use IPI to wake up NAPI on the remote CPU. If it is also the
> > local CPU, then we wake up sofrirqd.
>
> Thank you for the large effort.
>
> Since this will likely need a few iterations, on next revision please
> do split the work in multiple chunks to help the reviewer efforts -
> from Documentation/process/maintainer-netdev.rst:
>
>  - don't post large series (> 15 patches), break them up
>
> In this case I guess you can split it in 1 (or even 2) pre-req series
> and another one for the actual xsk zero copy support.


OK.

I can split patch into multiple parts such as

* virtio core
* xsk
* virtio-net prepare
* virtio-net support xsk zerocopy

However, there is a problem, the virtio core part should enter the VHOST branch
of Michael. Then, should I post follow-up patches to which branch vhost or
next-next?

Thanks.


>
> Thanks!
>
> Paolo
>
