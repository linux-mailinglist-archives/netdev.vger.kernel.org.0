Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFD96E8DCF
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 11:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbjDTJTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 05:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbjDTJTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 05:19:31 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E45270E;
        Thu, 20 Apr 2023 02:19:28 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0VgYNbDy_1681982363;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VgYNbDy_1681982363)
          by smtp.aliyun-inc.com;
          Thu, 20 Apr 2023 17:19:24 +0800
Message-ID: <1681981908.9700203-3-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next] xsk: introduce xsk_dma_ops
Date:   Thu, 20 Apr 2023 17:11:48 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Christoph Hellwig <hch@infradead.org>, netdev@vger.kernel.org,
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
        Jakub Kicinski <kuba@kernel.org>
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
In-Reply-To: <ZEDZaitjcX+egzvf@infradead.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Apr 2023 23:19:22 -0700, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Apr 19, 2023 at 09:45:06AM -0700, Jakub Kicinski wrote:
> > > Can you explain what the actual use case is?
> > >
> > > From the original patchset I suspect it is dma mapping something very
> > > long term and then maybe doing syncs on it as needed?
> >
> > In this case yes, pinned user memory, it gets sliced up into MTU sized
> > chunks, fed into an Rx queue of a device, and user can see packets
> > without any copies.
>
> How long is the life time of these mappings?  Because dma_map_*
> assumes a temporary mapping and not one that is pinned bascically
> forever.
>
> > Quite similar use case #2 is upcoming io_uring / "direct placement"
> > patches (former from Meta, latter for Google) which will try to receive
> > just the TCP data into pinned user memory.
>
> I don't think we can just long term pin user memory here.  E.g. for
> confidential computing cases we can't even ever do DMA straight to
> userspace.  I had that conversation with Meta's block folks who
> want to do something similar with io_uring and the only option is an
> an allocator for memory that is known DMAable, e.g. through dma-bufs.
>
> You guys really all need to get together and come up with a scheme
> that actually works instead of piling these hacks over hacks.

I think that cases Jakub mentioned are new requirements. From the perspective of
implementation, compared to this patch I submitted, if the DMA API can be
expanded, compatible with some special hardware, I think it is a good solution.

I know that the current design of DMA API only supports some physical hardware,
but can it be modified or expanded?

Still the previous idea, can we add a new ops (not dma_ops) in device? After the
driver configuration, so that the DMA API can be compatible with some special
hardware?


Thanks.




