Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F506E5783
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 04:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbjDRCaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 22:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjDRCav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 22:30:51 -0400
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4875B35B7;
        Mon, 17 Apr 2023 19:30:49 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=20;SR=0;TI=SMTPD_---0VgNI19z_1681785044;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VgNI19z_1681785044)
          by smtp.aliyun-inc.com;
          Tue, 18 Apr 2023 10:30:45 +0800
Message-ID: <1681784379.909136-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net-next] xsk: introduce xsk_dma_ops
Date:   Tue, 18 Apr 2023 10:19:39 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Jakub Kicinski <kuba@kernel.org>
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
        Jason Wang <jasowang@redhat.com>
References: <20230417032750.7086-1-xuanzhuo@linux.alibaba.com>
 <ZDzKAD2SNe1q/XA6@infradead.org>
 <1681711081.378984-2-xuanzhuo@linux.alibaba.com>
 <20230417115610.7763a87c@kernel.org>
 <20230417115753.7fb64b68@kernel.org>
 <CACGkMEtPNPXFThHt4aNm4g-fC1DqTLcDnB_iBWb9-cAOHMYV_A@mail.gmail.com>
 <20230417181950.5db68526@kernel.org>
In-Reply-To: <20230417181950.5db68526@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Apr 2023 18:19:50 -0700, Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 18 Apr 2023 09:07:30 +0800 Jason Wang wrote:
> > > > Would you mind explaining this a bit more to folks like me who are not
> > > > familiar with VirtIO?  DMA API is supposed to hide the DMA mapping
> > > > details from the stack, why is it not sufficient here.
> >
> > The reason is that legacy virtio device don't use DMA(vring_use_dma_api()).
> >
> > The AF_XDP assumes DMA for netdev doesn't work in this case. We need a
> > way to make it work.
>
> Can we not push this down to be bus level? virtio has its own bus it
> can plug in whatever magic it wants into dma ops.

It is actually not possible.

[1] https://lore.kernel.org/virtualization/ZDUCDeYLqAwQVJe7@infradead.org/

>
> Doesn't have to be super fast for af_xdp's sake - for af_xdp dma mapping
> is on the control path. You can keep using the if (vring_use_dma_api())
> elsewhere for now if there is a perf concern.

Sorry, I don't particularly understand this passage.

Now, the question is if vring_use_dma_api() is false, then we cannot use DMA
API in AF_XDP.

The good news is that except for some of sync's operations, they are in the
control path. I think it is very small effect on performance. Because in most
case the sync is unnecessary.


>
> Otherwise it really seems like we're bubbling up a virtio hack into
> generic code :(

Can we understand the purpose of this matter to back the DMA operation to the
driver? Although I don't know if there are other drivers with similar
requirements.

Thanks.



