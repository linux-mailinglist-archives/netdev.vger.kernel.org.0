Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2232D361E64
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 13:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240748AbhDPLGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 07:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235120AbhDPLGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 07:06:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087F9C061574;
        Fri, 16 Apr 2021 04:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=q8yzRZdY2wah1G/yCTkxWNbB0jFfZUvqQ3uEjV6WRbg=; b=hh9zQfxDvG2X4xo9Vk3zOGv+gZ
        QKntKgbYQxOmJbb/qwMrADTgbL8yz3oUhd3HEVZJgrY81Z+RWvtUKKoC8013lyugG2k8O7umfbJam
        gAhDbhGAPve6oN0MKZsJdwlfW5fC1MWvd6G5LMajXM5TqmIFfFtrkgHcaAZHgvXMnGtFGhwT/4HmK
        CsjhiBL3nsVtLo7E7Dvy9fj8xomDDJge0rOCzwzXKycyeIlDt/8ml1XDq6Qx+KbmBhQ5d1+BhQ6W5
        Piq3UrI2NLCuHxk3SVM4ryUk+gw6UwwBM7IiZJ4NrS7iOhjfU6YhJB+tUEtO+rntTBicYBF62ikeR
        Oi9OJ1dA==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lXMIL-009rDn-92; Fri, 16 Apr 2021 11:06:01 +0000
Date:   Fri, 16 Apr 2021 12:05:53 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Arnd Bergmann <arnd@kernel.org>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/1] mm: Fix struct page layout on 32-bit systems
Message-ID: <20210416110553.GH2531743@casper.infradead.org>
References: <20210414101044.19da09df@carbon>
 <20210414115052.GS2531743@casper.infradead.org>
 <20210414211322.3799afd4@carbon>
 <20210414213556.GY2531743@casper.infradead.org>
 <a50c3156fe8943ef964db4345344862f@AcuMS.aculab.com>
 <20210415200832.32796445@carbon>
 <20210415182155.GD2531743@casper.infradead.org>
 <5179a01a462f43d6951a65de2a299070@AcuMS.aculab.com>
 <20210415222211.GG2531743@casper.infradead.org>
 <f51e1aa98cb94880a236d58c75c20994@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f51e1aa98cb94880a236d58c75c20994@AcuMS.aculab.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 07:32:35AM +0000, David Laight wrote:
> From: Matthew Wilcox <willy@infradead.org>
> > Sent: 15 April 2021 23:22
> > 
> > On Thu, Apr 15, 2021 at 09:11:56PM +0000, David Laight wrote:
> > > Isn't it possible to move the field down one long?
> > > This might require an explicit zero - but this is not a common
> > > code path - the extra write will be noise.
> > 
> > Then it overlaps page->mapping.  See emails passim.
> 
> The rules on overlaps make be wonder if every 'long'
> should be in its own union.

That was what we used to have.  It was worse.

> The comments would need to say when each field is used.
> It would, at least, make these errors less common.
> 
> That doesn't solve the 64bit dma_addr though.
> 
> Actually rather that word-swapping dma_addr on 32bit BE
> could you swap over the two fields it overlays with.
> That might look messy in the .h, but it doesn't require
> an accessor function to do the swap - easily missed.

No.
