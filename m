Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508C11F7D7F
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 21:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgFLTYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 15:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgFLTYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 15:24:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CE8C03E96F;
        Fri, 12 Jun 2020 12:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XNIkzHywKoH/b5FoSCgmMlwYaQtQXQo8Xsv8G4L19+I=; b=JWOkDkykP2kWcImMSx7orhKPGu
        HQqxsoObXbcgFBrMCclC291CBzUDZx+2r9YIPj5QmzHGlljusdNWhWkt6AC8D25b5ACpf9qxNGPMF
        f63BTFa3uWqJy4FaDGSz4Xh7rhJ4r9uMrqhzkGE4orGEFDDXzGymYhPSnJtz5/lqSNqF3bEFleH8F
        iZIIcvEQlPD6tS8dtKPW88CcpSZ5YBV3xOYh88RSIxEzL+FbipCq/pC+XntBHNCTHzsTXGM9zEmWU
        EZgqeVnfWg6mVgRLnanPIeMXv4T1rolzFIX4uMCeBAwTlkYXQvqQTjLYt+DHwJnFjLV3cRYpXlcq2
        w2uGuFGA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jjpHu-0007JA-Bk; Fri, 12 Jun 2020 19:24:26 +0000
Date:   Fri, 12 Jun 2020 12:24:26 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] docs: mm/gup: pin_user_pages.rst: add a "case 5"
Message-ID: <20200612192426.GK8681@bombadil.infradead.org>
References: <20200529234309.484480-1-jhubbard@nvidia.com>
 <20200529234309.484480-2-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529234309.484480-2-jhubbard@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 04:43:08PM -0700, John Hubbard wrote:
> +CASE 5: Pinning in order to write to the data within the page
> +-------------------------------------------------------------
> +Even though neither DMA nor Direct IO is involved, just a simple case of "pin,
> +access page's data, unpin" can cause a problem. Case 5 may be considered a
> +superset of Case 1, plus Case 2, plus anything that invokes that pattern. In
> +other words, if the code is neither Case 1 nor Case 2, it may still require
> +FOLL_PIN, for patterns like this:
> +
> +Correct (uses FOLL_PIN calls):
> +    pin_user_pages()
> +    access the data within the pages
> +    set_page_dirty_lock()
> +    unpin_user_pages()
> +
> +INCORRECT (uses FOLL_GET calls):
> +    get_user_pages()
> +    access the data within the pages
> +    set_page_dirty_lock()
> +    put_page()

Why does this case need to pin?  Why can't it just do ...

	get_user_pages()
	lock_page(page);
	... modify the data ...
	set_page_dirty(page);
	unlock_page(page);

