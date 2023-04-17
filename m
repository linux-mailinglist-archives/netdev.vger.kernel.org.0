Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61E6D6E507A
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 20:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjDQS57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 14:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjDQS54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 14:57:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADEC149D9;
        Mon, 17 Apr 2023 11:57:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F4A2608D4;
        Mon, 17 Apr 2023 18:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E267FC433EF;
        Mon, 17 Apr 2023 18:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681757874;
        bh=udr4Upz+yZXKZFKa7Qrh2pGwU1/YrcqQ+ZDkRF6yS+w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m6PX32Wwmy+gjMeMPRHaoYlkRDPZRTpNTiMqOxuOUcXscBCZmZC0Z2Pgl9p2Blv8p
         2lQE3AfVQXtP/OdCgttN4YXbziSaL4fzWAqywjPTYeNbcFmb435JRQVE+JA6A25bmL
         ZMNsvNQz3uvqQWyRSZ1mHpvBj0iBgju2gpLvLDiKm3+6eYVSgjn7Q0thFqXsAEd1E7
         ZrhRR6RXATj8aE0ZhfzcbcyntMNV63BoCP6KHmePW9H7u5T9Ema2d8QwnARy9r4Qdi
         fICdohU1B90cfJloPQFIxWlwPxvi8ZNgIzz4KlJ+PxWVU1Y2ULP4pEXP7gl4/bCFxd
         gTTgRYEER1KEQ==
Date:   Mon, 17 Apr 2023 11:57:53 -0700
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
Message-ID: <20230417115753.7fb64b68@kernel.org>
In-Reply-To: <20230417115610.7763a87c@kernel.org>
References: <20230417032750.7086-1-xuanzhuo@linux.alibaba.com>
        <ZDzKAD2SNe1q/XA6@infradead.org>
        <1681711081.378984-2-xuanzhuo@linux.alibaba.com>
        <20230417115610.7763a87c@kernel.org>
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

On Mon, 17 Apr 2023 11:56:10 -0700 Jakub Kicinski wrote:
> > May misunderstand, here the "dma_ops" is not the "dma_ops" of DMA API.
> > 
> > I mean the callbacks for xsk to do dma.
> > 
> > Maybe, I should rename it in the next version.  
> 
> Would you mind explaining this a bit more to folks like me who are not
> familiar with VirtIO?  DMA API is supposed to hide the DMA mapping
> details from the stack, why is it not sufficient here.

Umm.. also it'd help to post the user of the API in the same series.
I only see the XSK changes, maybe if the virtio changes were in 
the same series I could answer my own question.
