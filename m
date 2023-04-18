Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13B246E57A1
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 04:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjDRCyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 22:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbjDRCyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 22:54:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849714C1C;
        Mon, 17 Apr 2023 19:54:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2036662703;
        Tue, 18 Apr 2023 02:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C98C4339B;
        Tue, 18 Apr 2023 02:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681786442;
        bh=A5UbqkJH74U+HOfiKXEJs/6Xs7H9yMHkkcjKJvbrGq4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WAjAERvEWKW2p5v4cLQSHIKlMGymhkKb0oZO06KYIuD6Dzo2oi/82MWlsxQFT50GB
         gw9aBYB8s9HTOD5O8uMl/20YB01DlEeOH2bfiQc6+aB44QHYlpuq4Gx7f1rboK6N2U
         gfm05m3T2mcLAaiUglqDBh2QaIdhO1/mD800prINkFV0za8wlX52GQn8kJTBaG/8zx
         piJUc4DtQ6FRhaFK1m/2qp+H4rQj3eudpYdheRVtO1E57UNtpHaYqxs2XRS4FgXuyx
         FswYmtkQfjG8mhSmh38JSYmulOmXW6cjetDf+z4KpJgPm6yaaW7ENRxiUip5hf6U5W
         3lW9h326nbmjg==
Date:   Mon, 17 Apr 2023 19:54:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Christoph Hellwig <hch@infradead.org>, netdev@vger.kernel.org,
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
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH net-next] xsk: introduce xsk_dma_ops
Message-ID: <20230417195400.482cfe75@kernel.org>
In-Reply-To: <1681784379.909136-2-xuanzhuo@linux.alibaba.com>
References: <20230417032750.7086-1-xuanzhuo@linux.alibaba.com>
        <ZDzKAD2SNe1q/XA6@infradead.org>
        <1681711081.378984-2-xuanzhuo@linux.alibaba.com>
        <20230417115610.7763a87c@kernel.org>
        <20230417115753.7fb64b68@kernel.org>
        <CACGkMEtPNPXFThHt4aNm4g-fC1DqTLcDnB_iBWb9-cAOHMYV_A@mail.gmail.com>
        <20230417181950.5db68526@kernel.org>
        <1681784379.909136-2-xuanzhuo@linux.alibaba.com>
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

On Tue, 18 Apr 2023 10:19:39 +0800 Xuan Zhuo wrote:
> > Can we not push this down to be bus level? virtio has its own bus it
> > can plug in whatever magic it wants into dma ops.  
> 
> It is actually not possible.
> 
> [1] https://lore.kernel.org/virtualization/ZDUCDeYLqAwQVJe7@infradead.org/

Maybe Christoph, or Greg can comment.

AF_XDP, io_uring, and increasing number of pinned memory / zero copy
implementations need to do DMA mapping outside the drivers.
I don't think it's reasonable to be bubbling up custom per-subsystem
DMA ops into all of them for the sake of virtio.

> > Otherwise it really seems like we're bubbling up a virtio hack into
> > generic code :(  
> 
> Can we understand the purpose of this matter to back the DMA operation to the
> driver?

We understand what your code does.
