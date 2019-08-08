Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8E38860CD
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 13:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389773AbfHHLYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 07:24:38 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38772 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbfHHLYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 07:24:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yKx8HsTXj6XZn7iuc5HaQ9+PLFIorUNJbAQDDn/PTbM=; b=GkE76/rc4ycXvInL4Me2TzEqw
        GA1SKEhp5DfbC++bG7w75tp03iNDvOdMKxKzp1+NQVCT6XUCOxupeJbTSkL5afuVuf/wRpmTvcG0C
        yv7ec8pybFHRywHINtMVhCtzdiCaCpkOPemRfW6gihGnUgX4u7ipgbmn47uLp03Tdt85OI2iTLLMH
        WziEPXadw73/dswli1nXBDiGFM3+ykcFaJvmTfHOkC00pTzl+CjH9h3UdmItO0+kaON63aBV7YPIl
        9fVYnzXQtxedzX1jtEebPtaebuV1fiwSX+TCLV2pD+9hBzyblTUy62h0Qwa2P6ssr1yrY5lexxfzM
        WJYYOGBnw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hvgX5-0004JR-62; Thu, 08 Aug 2019 11:24:35 +0000
Date:   Thu, 8 Aug 2019 04:24:35 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        mark.einon@gmail.com, davem@davemloft.net, f.fainelli@gmail.com,
        andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: et131x: Use GFP_KERNEL instead of
 GFP_ATOMIC when allocating tx_ring->tcb_ring
Message-ID: <20190808112435.GF5482@bombadil.infradead.org>
References: <20190731073842.16948-1-christophe.jaillet@wanadoo.fr>
 <20190807222346.00002ba7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807222346.00002ba7@intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 07, 2019 at 10:23:46PM -0700, Jesse Brandeburg wrote:
> On Wed, 31 Jul 2019 09:38:42 +0200
> Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:
> 
> > There is no good reason to use GFP_ATOMIC here. Other memory allocations
> > are performed with GFP_KERNEL (see other 'dma_alloc_coherent()' below and
> > 'kzalloc()' in 'et131x_rx_dma_memory_alloc()')
> > 
> > Use GFP_KERNEL which should be enough.
> > 
> > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> Sure, but generally I'd say GFP_ATOMIC is ok if you're in an init path
> and you can afford to have the allocation thread sleep while memory is
> being found by the kernel.

That's not what GFP_ATOMIC means.  GFP_ATOMIC _will not_ sleep.  GFP_KERNEL
will.
