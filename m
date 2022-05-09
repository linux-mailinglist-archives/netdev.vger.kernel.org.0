Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2285C520215
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 18:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238894AbiEIQRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 12:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238834AbiEIQR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 12:17:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166C922440D;
        Mon,  9 May 2022 09:13:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6428B80D3A;
        Mon,  9 May 2022 16:13:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1669EC385B1;
        Mon,  9 May 2022 16:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652112812;
        bh=RoFKHeqEk/geLO7SW73vbblC/hMfUQ9ReFJXxyfrtos=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KiRwTwmJokUO5XNi1meSOLbwpdrNBYirYoPnZ+272OH8NjhRbe4McwgIav4SkxIea
         BrDoZASN61h/aoXcvrWnkDi8OU0hWk8TtMxgLBVSe7Vvou6fFFZ11Be4GmT6qkF6bK
         bETvvGk5p82wC7doJVDLz5DcsLeTRnVe61MXDu1CpYgE3yo0C+lAVoTbApH9G6nSub
         kYO3AFc9IDVioDqput1awyS1G3F/4S6zQ+LrkzX0UlPE/B3dbc1RJPUtB/0z1PQHaa
         W/gpjFF2JOCYSn5SrU4VewEijgUtS88Vm++qAOFf8GES2ru9tLoim7HjyaV1fOCoHj
         WAOy5qgt7S1Ng==
Date:   Mon, 9 May 2022 09:13:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        ilias.apalodimas@linaro.org, hawk@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, jbrouer@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net-next] Documentation: update networking/page_pool.rst
 with ethtool APIs
Message-ID: <20220509091330.4e8c6d05@kernel.org>
In-Reply-To: <YnkIJn2BhSzyfQjh@lunn.ch>
References: <2b0f8921096d45e1f279d1b7b99fe467f6f3dc6d.1652090091.git.lorenzo@kernel.org>
        <YnkIJn2BhSzyfQjh@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 May 2022 14:25:10 +0200 Andrew Lunn wrote:
> On Mon, May 09, 2022 at 12:00:01PM +0200, Lorenzo Bianconi wrote:
> > Update page_pool documentation with page_pool ethtool stats APIs.
> > 
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  Documentation/networking/page_pool.rst | 23 +++++++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> > 
> > diff --git a/Documentation/networking/page_pool.rst b/Documentation/networking/page_pool.rst
> > index 5db8c263b0c6..ef5e18cf7cdf 100644
> > --- a/Documentation/networking/page_pool.rst
> > +++ b/Documentation/networking/page_pool.rst
> > @@ -146,6 +146,29 @@ The ``struct page_pool_recycle_stats`` has the following fields:
> >    * ``ring_full``: page released from page pool because the ptr ring was full
> >    * ``released_refcnt``: page released (and not recycled) because refcnt > 1
> >  
> > +The following APIs can be used to report page_pool stats through ethtool and
> > +avoid code duplication in each driver:
> > +
> > +* page_pool_ethtool_stats_get_strings(): reports page_pool ethtool stats
> > +  strings according to the ``struct page_pool_stats``
> > +     * ``rx_pp_alloc_fast``
> > +     * ``rx_pp_alloc_slow``
> > +     * ``rx_pp_alloc_slow_ho``
> > +     * ``rx_pp_alloc_empty``
> > +     * ``rx_pp_alloc_refill``
> > +     * ``rx_pp_alloc_waive``
> > +     * ``rx_pp_recycle_cached``
> > +     * ``rx_pp_recycle_cache_full``
> > +     * ``rx_pp_recycle_ring``
> > +     * ``rx_pp_recycle_ring_full``
> > +     * ``rx_pp_recycle_released_ref``  
> 
> My knowledge of Sphinx is pretty poor. Is it possible to put this list
> next to the actual definition and cross reference it? When new
> counters are added, they are more likely to be added to the list, if
> the list is nearby.

We can render kdoc into documentation. Not sure what's most suitable
here.

BTW does ``struct xyz`` result in correct linking to the kdoc like
:c:type:`xyz` would or I think these days also pure struct xyz?
