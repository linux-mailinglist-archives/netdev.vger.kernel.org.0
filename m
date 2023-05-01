Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386CE6F2E60
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 06:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbjEAE2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 00:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjEAE2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 00:28:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC09EE56;
        Sun, 30 Apr 2023 21:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AEYbMSFzhhiMlFPh01t9v+62fsN5TBDtngScZaFw41c=; b=GKe5hDhykrlOLAIxiCDsQ7GNVy
        Cptq4NVoR+eipLScQ13IuZd3Zt8Y9q0Ab6DlrQfoqrBbY7NBxFoTG9OdQDsu3Aw2eOwFa/5qSgtjq
        c14IQA3NPh3FrD262E/3cwDb4jTLFMiV/Jku1ZMkx60GIv0NKDqO4ppby2ps4p7Ym22yDw92BA3yP
        lqM7ub+DFKHZzAdq14QV6/PpXzh4N7+5n7HhTvl0ri6HfVYyjXVXOTGdWRg4tFvRJ/6j9dd5xjgZc
        p5rFqds/jlzD7QdDUQQgxPBB0BX5G0/HxNbF+OHbfeFLDkWFEbluXRdvAx6iYQw1YAJLVhizJgrvO
        e3veDurQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1ptL97-00FENY-0s;
        Mon, 01 May 2023 04:28:17 +0000
Date:   Sun, 30 Apr 2023 21:28:17 -0700
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
Message-ID: <ZE8/4aB8zi7du+N+@infradead.org>
References: <1681784379.909136-2-xuanzhuo@linux.alibaba.com>
 <20230417195400.482cfe75@kernel.org>
 <ZD4kMOym15pFcjq+@infradead.org>
 <20230417231947.3972f1a8@kernel.org>
 <ZD95RY9PjVRi7qz3@infradead.org>
 <d18eea7a-a71c-8de0-bde3-7ab000a77539@intel.com>
 <ZEDYt/EQJk39dTuK@infradead.org>
 <ff3d588e-10ac-36dd-06af-d55a79424ede@intel.com>
 <ZEFlG9rINkutmpCT@infradead.org>
 <b791d25d-8417-06e5-8e8b-6a9d3195c807@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b791d25d-8417-06e5-8e8b-6a9d3195c807@intel.com>
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

On Thu, Apr 20, 2023 at 06:42:17PM +0200, Alexander Lobakin wrote:
> When there's no recycling of pages, then yes. And since recycling is
> done asynchronously, sometimes new allocations happen either way.
> Anyways, that was roughly a couple years ago right when you introduced
> dma_alloc_noncoherent(). Things might've been changed since then.
> I could try again while next is closed (i.e. starting this Sunday), the
> only thing I'd like to mention: Page Pool allocates pages via
> alloc_pages_bulk_array_node(). Bulking helps a lot (and PP uses bulks of
> 16 IIRC), explicit node setting helps when Rx queues are distributed
> between several nodes. We can then have one struct device for several nodes.
> As I can see, there's now no function to allocate in bulks and no
> explicit node setting option (e.g. mlx5 works around this using
> set_dev_node() + allocate + set_dev_node(orig_node)). Could such options
> be added in near future? That would help a lot switching to the
> functions intended for use when DMA mappings can stay for a long time.
> >From what I see from the code, that shouldn't be a problem (except for
> non-direct DMA cases, where we'd need to introduce new callbacks or
> extend the existing ones).

So the node hint is something we can triviall pass through, and
something the mlx5 maintainers should have done from the beginning
instead of this nasty hack.  Patches gladly accepted.

A alloc_pages_bulk_array_node-like allocator also seems doable, we
just need to make sure it has a decent fallback as I don't think
we can wire it up to all the crazy legacy iommu drivers.
