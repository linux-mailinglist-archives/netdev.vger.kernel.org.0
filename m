Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885EF61001A
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 20:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235638AbiJ0SXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 14:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235586AbiJ0SXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 14:23:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57DDE4333C;
        Thu, 27 Oct 2022 11:23:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBBFA62418;
        Thu, 27 Oct 2022 18:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A52C433C1;
        Thu, 27 Oct 2022 18:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666894997;
        bh=J9JnUfcFNrF4jRVggLXQMWFImgx3+vGRcRHAGD32U30=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NFluZKLyKIgUH4tiiSuCbDJSgZvMDfp4rKckS9qBM5H6eUiAqEZ098aYF22PdqlvK
         ambl92JayvdEofWQ85XXWNZsd5IHVN9FUF/ut1PQLPBoCRsuuigg0+5oHMwvBWRQ0l
         MumdJrC2qmKMpdqdASg2h832EzeZUabVnFyEiTL05tsiCX7ruL4IfmUeOGpvyeO7Ay
         pm0w73XMcAyS5JElOJKso3PNXHN7j5LbD91T9F6aBnHtoqYkW8iT6GQT77NturCWmg
         gH584ls/GccnYpzkpEuioxGg8u9KqfuwLdsDZ5TLS7TwaGIK+nqemPZNEEG3wTb00S
         nWrfLCxfNe54Q==
Date:   Thu, 27 Oct 2022 11:23:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net] net: enetc: survive memory pressure without
 crashing
Message-ID: <20221027112316.377ccf10@kernel.org>
In-Reply-To: <20221027180209.qunyi4bdikbtqfho@skbuf>
References: <20221026121330.2042989-1-vladimir.oltean@nxp.com>
        <20221027105824.1c2157a2@kernel.org>
        <20221027180209.qunyi4bdikbtqfho@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Oct 2022 18:02:09 +0000 Vladimir Oltean wrote:
> On Thu, Oct 27, 2022 at 10:58:24AM -0700, Jakub Kicinski wrote:
> > On Wed, 26 Oct 2022 15:13:30 +0300 Vladimir Oltean wrote:  
> > > To fix this problem, memset the DMA coherent area used for RX buffer
> > > descriptors in enetc_dma_alloc_bdr(). This makes all BDs be "not ready"
> > > by default, which makes enetc_clean_rx_ring() exit early from the BD
> > > processing loop when there is no valid buffer available.  
> > 
> > IIRC dma_alloc_coherent() always zeros, and I'd guess there is a cocci
> > script that checks this judging but the number of "fixes" we got for
> > this in the past.
> > 
> > scripts/coccinelle/api/alloc/zalloc-simple.cocci ?  
> 
> Yeah, ok, fair, I guess only the producer/consumer indices were the problem,
> then. The "junk" I was seeing in the buffer descriptors was the "Ready"
> bit caused by the hardware thinking it owns all BDs when in fact it
> owned none of them.
> 
> Is there a chance the patch makes it for this week's PR if I amend it
> really quick?

Yeah, you got 15min :)
