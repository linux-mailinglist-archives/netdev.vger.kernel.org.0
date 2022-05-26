Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D3B5350A0
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 16:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347653AbiEZO2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 10:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347639AbiEZO2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 10:28:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2B2C6E6D;
        Thu, 26 May 2022 07:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=k7apNoi1g1YhGHKMlKvo5ejDwWGQrfqPL3Ty5xTWm5Q=; b=jt2D3c7xgVZUKhGsBafhmm2sFE
        7iHXpIRdAmkRqKCTrByt8vvIu4Y3EGktUCpnmPTFxq5LEtvIgLU7neTQ7C/IsI99LeEY7HaXKuYy7
        5ZrEicxpMCl0i/enkPZwHxhNQ3wSCLz0PWMpopuxkJst9ua3Mey2ATEpeisJ/smtNzknhVcxsQdkT
        dSKtJhfNJpH19fcWEk13NeBfTP6RD6LPE68nShdvuaPUklK12w19DAh/i1OVAzpUZ0A5rCLZKasUp
        WeWqziAdu0JgzoPn8WlmbMtIWF1JBvKksSw7KZdNfdrklRu0O6zxydJrgJF+gvKG7sfmTWPCyIS6G
        yc+jDrmg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nuETR-001JAt-Fo; Thu, 26 May 2022 14:28:25 +0000
Date:   Thu, 26 May 2022 15:28:25 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jessica Clarke <jrtc27@jrtc27.com>,
        kernel test robot <lkp@intel.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-riscv@lists.infradead.org,
        linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-parport@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-mm@kvack.org, linux-fbdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, bpf@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, alsa-devel@alsa-project.org
Subject: Re: [linux-next:master] BUILD REGRESSION
 8cb8311e95e3bb58bd84d6350365f14a718faa6d
Message-ID: <Yo+OiR6abzVksVTM@casper.infradead.org>
References: <628ea118.wJYf60YnZco0hs9o%lkp@intel.com>
 <20220525145056.953631743a4c494aabf000dc@linux-foundation.org>
 <F0E25DFF-8256-48FF-8B88-C0E3730A3E5E@jrtc27.com>
 <20220525152006.e87d3fa50aca58fdc1b43b6a@linux-foundation.org>
 <Yo7U8kglHlcvQ0Ri@casper.infradead.org>
 <20220526084832.GC2146@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526084832.GC2146@kadam>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 11:48:32AM +0300, Dan Carpenter wrote:
> On Thu, May 26, 2022 at 02:16:34AM +0100, Matthew Wilcox wrote:
> > Bizarre this started showing up now.  The recent patch was:
> > 
> > -       info->alloced += compound_nr(page);
> > -       inode->i_blocks += BLOCKS_PER_PAGE << compound_order(page);
> > +       info->alloced += folio_nr_pages(folio);
> > +       inode->i_blocks += BLOCKS_PER_PAGE << folio_order(folio);
> > 
> > so it could tell that compound_order() was small, but folio_order()
> > might be large?
> 
> The old code also generates a warning on my test system.  Smatch thinks
> both compound_order() and folio_order() are 0-255.  I guess because of
> the "unsigned char compound_order;" in the struct page.

It'd be nice if we could annotate that as "contains a value between
1 and BITS_PER_LONG - PAGE_SHIFT".  Then be able to optionally enable
a checker that ensures that's true on loads/stores.  Maybe we need a
language that isn't C :-P  Ada can do this ... I don't think Rust can.
