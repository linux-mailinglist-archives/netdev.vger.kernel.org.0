Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3668268F60
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 17:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgINPPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 11:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgINPO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 11:14:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975C4C061788;
        Mon, 14 Sep 2020 08:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qoTdF1K8QZfe59Hsr5727q9mC8g2Jr5rOYMLLk2l1RQ=; b=JD1+mg3m8jvSPy3g4VSjTLAnne
        36W7CEcoAjxEVt2IAtPzrSLLevxJXWdpbHQIw28Hd8heE9NT0eLFI3udQPI9fiPX78IfhNKa6ks+t
        B6qOI+lbhHblw0gjtrh7b4QFmisAWGkdYGLVZMa2FALPb3LmhFrZ/EhI1n0frpG3jT/9G2onhyqti
        +JAkxxX8vEDs8hVliKzd7NKSOO7+clLbM8f4UpsVvfAezc/NiKnlHpgaH4hmhufya8Q6/AXWqwdjv
        2yxTbv35hihTfi1UKALD5FKKVyct2R0rgRXAei//GMv4/Wl+PzWkc0P9X7kAFL7918W/mYBUUblZB
        Ej1HafoQ==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kHqB4-0003Xz-OV; Mon, 14 Sep 2020 15:13:58 +0000
Date:   Mon, 14 Sep 2020 16:13:58 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-parisc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 11/17] sgiseeq: convert to dma_alloc_noncoherent
Message-ID: <20200914151358.GQ6583@casper.infradead.org>
References: <20200914144433.1622958-1-hch@lst.de>
 <20200914144433.1622958-12-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914144433.1622958-12-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 04:44:27PM +0200, Christoph Hellwig wrote:
>  drivers/net/ethernet/i825xx/lasi_82596.c |  25 ++---
>  drivers/net/ethernet/i825xx/lib82596.c   | 114 ++++++++++++++---------
>  drivers/net/ethernet/i825xx/sni_82596.c  |   4 -
>  drivers/net/ethernet/seeq/sgiseeq.c      |  28 ++++--
>  drivers/scsi/53c700.c                    |   9 +-
>  5 files changed, 103 insertions(+), 77 deletions(-)

I think your patch slicing-and-dicing went wrong here ;-(
