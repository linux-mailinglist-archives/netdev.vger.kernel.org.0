Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782CA6E7FDD
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 18:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbjDSQpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 12:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233061AbjDSQpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 12:45:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4798A83E2;
        Wed, 19 Apr 2023 09:45:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDDDD640DF;
        Wed, 19 Apr 2023 16:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BE9C433D2;
        Wed, 19 Apr 2023 16:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681922708;
        bh=usuHs7WWzGx30SJOsB+7vdP1xmHfJvvA9iRDFPMGcEA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fv8TXQzoH5tiCSpaoUcM9KXtHi+S5mruDUO+5WGhkKraiTP3OXFJW11oaTkqjo//4
         Mpv+9frdHij8HUjjOq2xsmFs6iaovoAmBZ+HukOb4DenoSK3VN/UXSKQXdtxJIz3bR
         4N2KLndDBUCBr3weL68idBbLUp/+SGjBAq8gvruBqj3iiHRRKOnGghkKnyA2qH+U1Q
         3MBz2RyjA3XrmvfVfFMags/gBsfnbBSI0G9XsldrVRuzaHHR9udt6omz33nzCW98a3
         GdNRycvhpOIfhD2AjBalygb00xZo7a9IuRyxc9KUwGBJh38uVhrQWWhH9yBEXNw3l6
         ANIk3WRv9Fyaw==
Date:   Wed, 19 Apr 2023 09:45:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
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
Message-ID: <20230419094506.2658b73f@kernel.org>
In-Reply-To: <ZD95RY9PjVRi7qz3@infradead.org>
References: <ZDzKAD2SNe1q/XA6@infradead.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Apr 2023 22:16:53 -0700 Christoph Hellwig wrote:
> On Mon, Apr 17, 2023 at 11:19:47PM -0700, Jakub Kicinski wrote:
> > Damn, that's unfortunate. Thinking aloud -- that means that if we want 
> > to continue to pull memory management out of networking drivers to
> > improve it for all, cross-optimize with the rest of the stack and
> > allow various upcoming forms of zero copy -- then we need to add an
> > equivalent of dma_ops and DMA API locally in networking?  
> 
> Can you explain what the actual use case is?
> 
> From the original patchset I suspect it is dma mapping something very
> long term and then maybe doing syncs on it as needed?

In this case yes, pinned user memory, it gets sliced up into MTU sized
chunks, fed into an Rx queue of a device, and user can see packets
without any copies.

Quite similar use case #2 is upcoming io_uring / "direct placement"
patches (former from Meta, latter for Google) which will try to receive
just the TCP data into pinned user memory.

And, as I think Olek mentioned, #3 is page_pool - which allocates 4k
pages, manages the DMA mappings, gives them to the device and tries 
to recycle back to the device once TCP is done with them (avoiding the
unmapping and even atomic ops on the refcount, as in the good case page
refcount is always 1). See page_pool_return_skb_page() for the
recycling flow.

In all those cases it's more flexible (and faster) to hide the DMA
mapping from the driver. All the cases are also opt-in so we don't need
to worry about complete oddball devices. And to answer your question in
all cases we hope mapping/unmapping will be relatively rare while
syncing will be frequent.

AFAIU the patch we're discussing implements custom dma_ops for case #1,
but the same thing will be needed for #2, and #3. Question to me is
whether we need netdev-wide net_dma_ops or device model can provide us
with a DMA API that'd work for SoC/PCIe/virt devices.
