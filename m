Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAADF6E5945
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 08:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbjDRGTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 02:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbjDRGTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 02:19:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612CB4EE9;
        Mon, 17 Apr 2023 23:19:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDC6562D0D;
        Tue, 18 Apr 2023 06:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5823FC433EF;
        Tue, 18 Apr 2023 06:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681798789;
        bh=2vlCfMnPi2r13qP/XTcsNufFl5hFcfFcLZ5jp+TdpTc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BybXNaoTpdft2Ul9XKiNY3W9ytTv7iPpjZ9kyfxzscFcplG+jCiL4oxFQB2uOkt6/
         Yl1uCrJepnrpssaTGmiswF5DNlidJhI01zXzJPi1YTcdYQ6XOPjRbTwuRtzOB86pHs
         54yIpvtkFBlID/n4r2tx879VzzzjkCnuvZMOFpOzJET4hguA/aUCXeBus1/C471B7/
         +wfEdRGuETg6g+DmfgGBk1uUMAqKXyCbHla958q9I2C6n3g7qGI5pNya9nS/ciqHG2
         w19lppyiNgqnfksUoxL9iwAmV1fI8c2twb6yriO8zhvm8ducs5s3rC2O0tEdhnC4IW
         VXjygtUYrxBFg==
Date:   Mon, 17 Apr 2023 23:19:47 -0700
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
Message-ID: <20230417231947.3972f1a8@kernel.org>
In-Reply-To: <ZD4kMOym15pFcjq+@infradead.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Apr 2023 22:01:36 -0700 Christoph Hellwig wrote:
> On Mon, Apr 17, 2023 at 07:54:00PM -0700, Jakub Kicinski wrote:
> > AF_XDP, io_uring, and increasing number of pinned memory / zero copy
> > implementations need to do DMA mapping outside the drivers.  
> 
> You can't just do dma mapping outside the driver, because there are
> drivers that do not require DMA mapping at all.  virtio is an example,
> but all the classic s390 drivers and some other odd virtualization
> ones are others.

What bus are the classic s390 on (in terms of the device model)?

> > I don't think it's reasonable to be bubbling up custom per-subsystem
> > DMA ops into all of them for the sake of virtio.  
> 
> dma addresses and thus dma mappings are completely driver specific.
> Upper layers have no business looking at them.

Damn, that's unfortunate. Thinking aloud -- that means that if we want 
to continue to pull memory management out of networking drivers to
improve it for all, cross-optimize with the rest of the stack and
allow various upcoming forms of zero copy -- then we need to add an
equivalent of dma_ops and DMA API locally in networking?
