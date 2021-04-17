Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8E6363280
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 23:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237127AbhDQV33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 17:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237090AbhDQV32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 17:29:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B278FC061574;
        Sat, 17 Apr 2021 14:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tdMd9G9wD3dHdDB049z0mEp3bwlE87mJ0J7o89xl/iU=; b=kjCBnWRnNfJ4jh1gNX/lQqFZaV
        PIt6sDdbkDGzgmh71GE65C7gRjevycey4DoCtbejN9tL9oy21OFCEaAalEL1tJX2o90jMIunwvzlT
        aw6WnoUC4xKa/S6Fo+ZMatucihabyUEWmzgS2fQA3KuKU2AamMDSAvwzszyCc5I4TnWdPWLrwWCKi
        rVT5becyLy4eWu5C3CPFKJcjpScabeN83QGn+BwxjvQCu6su18nAbnPuTOLaKIYZFme9zSXfjcKXe
        HVFpVtf65QAh/PF06VB9QUA3eZMEV6/SGt6UIGiIg++xfTnOleyRsiTg4gP470cAho43TKpegokfh
        QjMDTCHQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lXsUd-00BiOm-RD; Sat, 17 Apr 2021 21:28:45 +0000
Date:   Sat, 17 Apr 2021 22:28:43 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     "brouer@redhat.com" <brouer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "mcroce@linux.microsoft.com" <mcroce@linux.microsoft.com>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "arnd@kernel.org" <arnd@kernel.org>, "hch@lst.de" <hch@lst.de>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "mgorman@suse.de" <mgorman@suse.de>
Subject: Re: [PATCH 2/2] mm: Indicate pfmemalloc pages in compound_head
Message-ID: <20210417212843.GT2531743@casper.infradead.org>
References: <20210416230724.2519198-1-willy@infradead.org>
 <20210416230724.2519198-3-willy@infradead.org>
 <2a531a42f23e4046833e0feb8faef0b5@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a531a42f23e4046833e0feb8faef0b5@AcuMS.aculab.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 17, 2021 at 09:13:45PM +0000, David Laight wrote:
> >  		struct {	/* page_pool used by netstack */
> > -			/**
> > -			 * @dma_addr: might require a 64-bit value on
> > -			 * 32-bit architectures.
> > -			 */
> > +			unsigned long pp_magic;
> > +			unsigned long xmi;
> > +			unsigned long _pp_mapping_pad;
> >  			unsigned long dma_addr[2];
> >  		};
> 
> You've deleted the comment.

Yes.  It no longer added any value.  You can see dma_addr now occupies
two words.

> I also think there should be a comment that dma_addr[0]
> must be aliased to ->index.

That's not a requirement.  Moving the pfmemalloc indicator is a
requirement so that we _can_ use index, but there's no requirement about
how index is used.
