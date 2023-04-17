Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36BC36E5076
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 20:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbjDQS4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 14:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjDQS4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 14:56:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E258F;
        Mon, 17 Apr 2023 11:56:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1B356113D;
        Mon, 17 Apr 2023 18:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D22C433EF;
        Mon, 17 Apr 2023 18:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681757772;
        bh=jK/p0ZuXyKC4zJpZyUhpAtnVllicifPNHJk3dWBHiRo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ncv1WTUykCp7OUc3kuMzs42btKYArHvTXhRiP0npu2Ryl3izQnvXnTxd1B+8V7vPl
         rqqV6VYkxrEeZJUOG3QQrlpTY7CSt1dtwmMxuxLape8nkCLKSHCGEDAbfl0iH0ckVm
         /AqI69MhEM5KJBR1B6krOBg50zT5OxirQITJChOxNuQwHdZxzGxeKouYxlCyPUFiVi
         Ym9AmlM//JuEomZFsKzbC49549iRj0Y+ZznCPNH0z5cX8frznf27+SVfuadTSlRL/O
         D+e5yyfwK910bsQJ3yWcWK27X/qGO0RGGgUNnEen5uNZHFnB6iTwznCs5s6C4ly0ZU
         v1MyGsTuuqOww==
Date:   Mon, 17 Apr 2023 11:56:10 -0700
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
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: [PATCH net-next] xsk: introduce xsk_dma_ops
Message-ID: <20230417115610.7763a87c@kernel.org>
In-Reply-To: <1681711081.378984-2-xuanzhuo@linux.alibaba.com>
References: <20230417032750.7086-1-xuanzhuo@linux.alibaba.com>
        <ZDzKAD2SNe1q/XA6@infradead.org>
        <1681711081.378984-2-xuanzhuo@linux.alibaba.com>
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

On Mon, 17 Apr 2023 13:58:01 +0800 Xuan Zhuo wrote:
> On Sun, 16 Apr 2023 21:24:32 -0700, Christoph Hellwig <hch@infradead.org> wrote:
> > On Mon, Apr 17, 2023 at 11:27:50AM +0800, Xuan Zhuo wrote:  
> > > The purpose of this patch is to allow driver pass the own dma_ops to
> > > xsk.  
> >
> > Drivers have no business passing around dma_ops, or even knowing about
> > them.  
> 
> May misunderstand, here the "dma_ops" is not the "dma_ops" of DMA API.
> 
> I mean the callbacks for xsk to do dma.
> 
> Maybe, I should rename it in the next version.

Would you mind explaining this a bit more to folks like me who are not
familiar with VirtIO?  DMA API is supposed to hide the DMA mapping
details from the stack, why is it not sufficient here.
