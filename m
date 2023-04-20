Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2CF6E994F
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 18:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbjDTQPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 12:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbjDTQPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 12:15:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6FC10F6;
        Thu, 20 Apr 2023 09:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8cylqzdP0hXk5+N5BXe5Y74wAIWGCOav7qKznB1OcHU=; b=XxVPm6LUtaULMeaI3bbiNdFmBk
        MT0gzQoFXxLpTVFqApMHWsr9uCibCIZH/Ar5VtYm4BE9U8TAoxiELgcvErBDkD1lFZQP73U2jvKK4
        MGYTVF3is9fL2r2XC/7Go/+1wV7CcRP4uV1sVx4d56ODJBNQEBRY89e+WYtlbgEXDo+ng9n4RW/eb
        dhYksqqCLXLJ7oXuPTIzGIA5/HATPY7lArpuLuhiyGunZX1pJYLx/7/P6zeUPXkL9rQiWzB3FXXE5
        ayJBzZCYD0s+XN4JcPD1Uv4CBypRW/SPmfLwW450ZLR5SNuxc9Q+ULPc9mrpfqhyOnTRrBd5zKiAT
        YlsP+2Yw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1ppWwO-008WEu-01;
        Thu, 20 Apr 2023 16:15:24 +0000
Date:   Thu, 20 Apr 2023 09:15:23 -0700
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
Message-ID: <ZEFlG9rINkutmpCT@infradead.org>
References: <CACGkMEtPNPXFThHt4aNm4g-fC1DqTLcDnB_iBWb9-cAOHMYV_A@mail.gmail.com>
 <20230417181950.5db68526@kernel.org>
 <1681784379.909136-2-xuanzhuo@linux.alibaba.com>
 <20230417195400.482cfe75@kernel.org>
 <ZD4kMOym15pFcjq+@infradead.org>
 <20230417231947.3972f1a8@kernel.org>
 <ZD95RY9PjVRi7qz3@infradead.org>
 <d18eea7a-a71c-8de0-bde3-7ab000a77539@intel.com>
 <ZEDYt/EQJk39dTuK@infradead.org>
 <ff3d588e-10ac-36dd-06af-d55a79424ede@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff3d588e-10ac-36dd-06af-d55a79424ede@intel.com>
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

On Thu, Apr 20, 2023 at 03:59:39PM +0200, Alexander Lobakin wrote:
> Hmm, currently almost all Ethernet drivers map Rx pages once and then
> just recycle them, keeping the original DMA mapping. Which means pages
> can have the same first mapping for very long time, often even for the
> lifetime of the struct device. Same for XDP sockets, the lifetime of DMA
> mappings equals the lifetime of sockets.
> Does it mean we'd better review that approach and try switching to
> dma_alloc_*() family (non-coherent/caching in our case)?

Yes, exactly.  dma_alloc_noncoherent can be used exactly as alloc_pages
+ dma_map_* by the driver (including the dma_sync_* calls on reuse), but
has a huge number of advantages.

> Also, I remember I tried to do that for one my driver, but the thing
> that all those functions zero the whole page(s) before returning them to
> the driver ruins the performance -- we don't need to zero buffers for
> receiving packets and spend a ton of cycles on it (esp. in cases when 4k
> gets zeroed each time, but your main body of traffic is 64-byte frames).

Hmm, the single zeroing when doing the initial allocation shows up
in these profiles?
