Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A07226E8A3A
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 08:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233787AbjDTGQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 02:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbjDTGQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 02:16:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A509546A5;
        Wed, 19 Apr 2023 23:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=wW0DLfkuxhOJTHn8csrZy8uKe/oAqpxqTHSHjbmQDXk=; b=foXj+W8bjMYBMeiIxvcDr0GYy2
        uxYKvKG2Iq1YUylO9P11nrg1Q4e5gLLDXr2dXuozjeAkV6fa3Eainbx4kcd8PujJyEdf07MRpq7kj
        QkXcnCbmtv798lzgVmgQtIMevwNX248Pb673Ltwebdu18fQPfpcRVhiI+nse6op8BTyi7liDx1wcY
        iaK8LQCm6+XV3aVDfkwE1SnglsmQeCbUWuU75v8Z4XNSiJItr3flD3/fwrqnjILzB6taI3CDkhZE/
        FnI67NOl8aqRqFQMi0I0L2J2X1lKdFSQTAvhdZd5RVSicUeylgNgagJySD817YPxQ5Im7qDWtwwDg
        ihB3HJOA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1ppNah-007AK9-2c;
        Thu, 20 Apr 2023 06:16:23 +0000
Date:   Wed, 19 Apr 2023 23:16:23 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH net-next] xsk: introduce xsk_dma_ops
Message-ID: <ZEDYt/EQJk39dTuK@infradead.org>
References: <20230417115610.7763a87c@kernel.org>
 <20230417115753.7fb64b68@kernel.org>
 <CACGkMEtPNPXFThHt4aNm4g-fC1DqTLcDnB_iBWb9-cAOHMYV_A@mail.gmail.com>
 <20230417181950.5db68526@kernel.org>
 <1681784379.909136-2-xuanzhuo@linux.alibaba.com>
 <20230417195400.482cfe75@kernel.org>
 <ZD4kMOym15pFcjq+@infradead.org>
 <20230417231947.3972f1a8@kernel.org>
 <ZD95RY9PjVRi7qz3@infradead.org>
 <d18eea7a-a71c-8de0-bde3-7ab000a77539@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d18eea7a-a71c-8de0-bde3-7ab000a77539@intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 03:14:48PM +0200, Alexander Lobakin wrote:
> >>> dma addresses and thus dma mappings are completely driver specific.
> >>> Upper layers have no business looking at them.
> 
> Here it's not an "upper layer". XSk core doesn't look at them or pass
> them between several drivers.

Same for upper layers :)  The just do abstract operations that can sit
on top of a variety of drivers.

> It maps DMA solely via the struct device
> passed from the driver and then just gets-sets addresses for this driver
> only. Just like Page Pool does for regular Rx buffers. This got moved to
> the XSk core to not repeat the same code pattern in each driver.

Which assumes that:

 a) a DMA mapping needs to be done at all
 b) it can be done using a struct device exposed to it
 c) that DMA mapping is actually at the same granularity that it
    operates on

all of which might not be true.

> >>From the original patchset I suspect it is dma mapping something very
> > long term and then maybe doing syncs on it as needed?
> 
> As I mentioned, XSk provides some handy wrappers to map DMA for drivers.
> Previously, XSk was supported by real hardware drivers only, but here
> the developer tries to add support to virtio-net. I suspect he needs to
> use DMA mapping functions different from which the regular driver use.

Yes,  For actual hardware virtio and some more complex virtualized
setups it works just like real hardware.  For legacy virtio there is 
no DMA maping involved at all.  Because of that all DMA mapping needs
to be done inside of virtio.

> So this is far from dma_map_ops, the author picked wrong name :D
> And correct, for XSk we map one big piece of memory only once and then
> reuse it for buffers, no inflight map/unmap on hotpath (only syncs when
> needed). So this mapping is longterm and is stored in XSk core structure
> assigned to the driver which this mapping was done for.
> I think Jakub thinks of something similar, but for the "regular" Rx/Tx,
> not only XDP sockets :)

FYI, dma_map_* is not intended for long term mappings, can lead
to starvation issues.  You need to use dma_alloc_* instead.  And
"you" in that case is as I said the driver, not an upper layer.
If it's just helper called by drivers and never from core code,
that's of course fine.
