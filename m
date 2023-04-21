Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E76CF6EA4EC
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 09:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbjDUHhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 03:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbjDUHhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 03:37:10 -0400
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FD22722;
        Fri, 21 Apr 2023 00:37:08 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0VgbyT-R_1682062623;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VgbyT-R_1682062623)
          by smtp.aliyun-inc.com;
          Fri, 21 Apr 2023 15:37:03 +0800
Message-ID: <1682062264.418752-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next] xsk: introduce xsk_dma_ops
Date:   Fri, 21 Apr 2023 15:31:04 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>
References: <20230417032750.7086-1-xuanzhuo@linux.alibaba.com>
 <ZDzKAD2SNe1q/XA6@infradead.org>
 <1681711081.378984-2-xuanzhuo@linux.alibaba.com>
 <20230417115610.7763a87c@kernel.org>
 <20230417115753.7fb64b68@kernel.org>
 <CACGkMEtPNPXFThHt4aNm4g-fC1DqTLcDnB_iBWb9-cAOHMYV_A@mail.gmail.com>
 <20230417181950.5db68526@kernel.org>
 <1681784379.909136-2-xuanzhuo@linux.alibaba.com>
 <20230417195400.482cfe75@kernel.org>
 <ZD4kMOym15pFcjq+@infradead.org>
 <20230417231947.3972f1a8@kernel.org>
 <ZD95RY9PjVRi7qz3@infradead.org>
 <20230419094506.2658b73f@kernel.org>
 <ZEDZaitjcX+egzvf@infradead.org>
 <20230420071349.5e441027@kernel.org>
In-Reply-To: <20230420071349.5e441027@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Apr 2023 07:13:49 -0700, Jakub Kicinski <kuba@kernel.org> wrote:
> On Wed, 19 Apr 2023 23:19:22 -0700 Christoph Hellwig wrote:
> > > In this case yes, pinned user memory, it gets sliced up into MTU sized
> > > chunks, fed into an Rx queue of a device, and user can see packets
> > > without any copies.
> >
> > How long is the life time of these mappings?  Because dma_map_*
> > assumes a temporary mapping and not one that is pinned bascically
> > forever.
>
> Yeah, this one is "for ever".
>
> > > Quite similar use case #2 is upcoming io_uring / "direct placement"
> > > patches (former from Meta, latter for Google) which will try to receive
> > > just the TCP data into pinned user memory.
> >
> > I don't think we can just long term pin user memory here.  E.g. for
> > confidential computing cases we can't even ever do DMA straight to
> > userspace.  I had that conversation with Meta's block folks who
> > want to do something similar with io_uring and the only option is an
> > an allocator for memory that is known DMAable, e.g. through dma-bufs.
> >
> > You guys really all need to get together and come up with a scheme
> > that actually works instead of piling these hacks over hacks.
>
> Okay, that simplifies various aspects. We'll just used dma-bufs from
> the start in the new APIs.


I am not particularly familiar with dma-bufs. I want to know if this mechanism
can solve the problem of virtio-net.

I saw this framework, allowing the driver do something inside the ops of
dma-bufs.

If so, is it possible to propose a new patch based on dma-bufs?

Thanks.




