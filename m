Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B0C24ADE8
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 06:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgHTEht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 00:37:49 -0400
Received: from verein.lst.de ([213.95.11.211]:40359 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725772AbgHTEhs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 00:37:48 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2D19E68BEB; Thu, 20 Aug 2020 06:37:45 +0200 (CEST)
Date:   Thu, 20 Aug 2020 06:37:44 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     David Miller <davem@davemloft.net>
Cc:     hch@lst.de, kuba@kernel.org, colyli@suse.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bypass ->sendpage for slab pages
Message-ID: <20200820043744.GA4349@lst.de>
References: <20200819051945.1797088-1-hch@lst.de> <20200819.120709.1311664171016372891.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200819.120709.1311664171016372891.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 12:07:09PM -0700, David Miller wrote:
> Yes this fixes the problem, but it doesn't in any way deal with the
> callers who are doing this stuff.
> 
> They are all likely using sendpage because they expect that it will
> avoid the copy, for performance reasons or whatever.
> 
> Now it won't.
> 
> At least with Coly's patch set, the set of violators was documented
> and they could switch to allocating non-slab pages or calling
> sendmsg() or write() instead.
> 
> I hear talk about ABIs just doing the right thing, but when their
> value is increased performance vs. other interfaces it means that
> taking a slow path silently is bad in the long term.  And that's
> what this proposed patch here does.

If you look at who uses sendpage outside the networking layer itself
you see that it is basically block driver and file systems.  These
have no way to control what memory they get passed and have to deal
with everything someone throws at them.

So for these callers the requirements are in order of importance:

 (1) just send the damn page without generating weird OOPSes
 (2) do so as fast as possible
 (3) do so without requіring pointless boilerplate code

Any I think the current interface fails these requirements really badly.
Having a helper that just does the right thing would really help all of
these users, including those currently using raw ->sendpage over
kernel_sendpage.  If you don't like kernel_sendpage to just do the
right thing we could just add another helper, e.g.
kernel_sendpage_or_fallback, but that would seem a little pointless
to me.
