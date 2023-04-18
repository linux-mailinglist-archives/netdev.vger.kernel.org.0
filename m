Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB376E5653
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 03:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjDRBTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 21:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjDRBTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 21:19:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFAA4687;
        Mon, 17 Apr 2023 18:19:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F11A76176F;
        Tue, 18 Apr 2023 01:19:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D932C433D2;
        Tue, 18 Apr 2023 01:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681780792;
        bh=Gw8442gUvyGjmr95ywhZc2ApESwvAsfYWaoAZ14Ba30=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BI66JhzlcE6tGTThIx7GVdXfBxoDLqA+UVgVB1agGTbkWfh41W0b3qQyZQqTEV4KJ
         dC+DziF/2ONeWyS5fCLK9jwc3CcAsVhEkr7rY9qm6QNHJUHddeNrl4F1LhdkFfMEBU
         CV2Vk/ZcqslRwsREm9sYunBDm6Dv9BlzwED/LKPjllO8/+v1hVp0Jj9G4BdDK1ricN
         xXRNkYpI+6NKI4RnjUuDxBNLs5Ep62WkPIxOrl4sOH2ZL3XpvHDtiKxvLkW76i2MfQ
         U+jHh13u3zjtryKt7SJ9pLDqlSwisPaon9cichOrqdhEnZ6YVYrDjHuBIK/iYV5Fwp
         zE08TLvoq4DGw==
Date:   Mon, 17 Apr 2023 18:19:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Christoph Hellwig <hch@infradead.org>, netdev@vger.kernel.org,
        =?UTF-8?B?QmrDtnJuIFTDtnBl?= =?UTF-8?B?bA==?= <bjorn@kernel.org>,
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
        Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH net-next] xsk: introduce xsk_dma_ops
Message-ID: <20230417181950.5db68526@kernel.org>
In-Reply-To: <CACGkMEtPNPXFThHt4aNm4g-fC1DqTLcDnB_iBWb9-cAOHMYV_A@mail.gmail.com>
References: <20230417032750.7086-1-xuanzhuo@linux.alibaba.com>
        <ZDzKAD2SNe1q/XA6@infradead.org>
        <1681711081.378984-2-xuanzhuo@linux.alibaba.com>
        <20230417115610.7763a87c@kernel.org>
        <20230417115753.7fb64b68@kernel.org>
        <CACGkMEtPNPXFThHt4aNm4g-fC1DqTLcDnB_iBWb9-cAOHMYV_A@mail.gmail.com>
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

On Tue, 18 Apr 2023 09:07:30 +0800 Jason Wang wrote:
> > > Would you mind explaining this a bit more to folks like me who are not
> > > familiar with VirtIO?  DMA API is supposed to hide the DMA mapping
> > > details from the stack, why is it not sufficient here.  
> 
> The reason is that legacy virtio device don't use DMA(vring_use_dma_api()).
> 
> The AF_XDP assumes DMA for netdev doesn't work in this case. We need a
> way to make it work.

Can we not push this down to be bus level? virtio has its own bus it
can plug in whatever magic it wants into dma ops.

Doesn't have to be super fast for af_xdp's sake - for af_xdp dma mapping
is on the control path. You can keep using the if (vring_use_dma_api())
elsewhere for now if there is a perf concern.

Otherwise it really seems like we're bubbling up a virtio hack into
generic code :(
