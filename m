Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D59B25B16F
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 18:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgIBQUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 12:20:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:59466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbgIBQUC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 12:20:02 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DA8A208B3;
        Wed,  2 Sep 2020 16:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599063601;
        bh=4ntTsfwJyBJsBW/1yKbNCcQAmv4C8p9X7jLoU6Hnuo8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BOY8U3iPghuQxwE3y0jQ6b7QlcoRNKN2TpJ9cBHK4BrUoUSrYP/CDg8RhMJT5gesa
         ZmRulHjspOaleiQY3Y4wg68/vgrreAn4rcw3Le3vq/SmwL4mJjJR8nSAcuLctYpnM/
         ih8hXsRD8z0UI7DGP1ZdwV1Q3ggq4mS2fDt3o7G4=
Date:   Wed, 2 Sep 2020 11:26:13 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] xsk: Fix null check on error return path
Message-ID: <20200902162613.GB31464@embeddedor>
References: <20200902150750.GA7257@embeddedor>
 <7b3d5e02-852e-189b-7c0e-9f9827fca730@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b3d5e02-852e-189b-7c0e-9f9827fca730@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 02, 2020 at 05:12:51PM +0200, Björn Töpel wrote:
> On 2020-09-02 17:07, Gustavo A. R. Silva wrote:
> > Currently, dma_map is being checked, when the right object identifier
> > to be null-checked is dma_map->dma_pages, instead.
> > 
> > Fix this by null-checking dma_map->dma_pages.
> > 
> > Addresses-Coverity-ID: 1496811 ("Logically dead code")
> > Fixes: 921b68692abb ("xsk: Enable sharing of dma mappings")
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> Nice catch!
> 
> Acked-by: Björn Töpel <bjorn.topel@intel.com>
> 

Thanks, Björn.

--
Gustavo

> > ---
> >   net/xdp/xsk_buff_pool.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
> > index 795d7c81c0ca..5b00bc5707f2 100644
> > --- a/net/xdp/xsk_buff_pool.c
> > +++ b/net/xdp/xsk_buff_pool.c
> > @@ -287,7 +287,7 @@ static struct xsk_dma_map *xp_create_dma_map(struct device *dev, struct net_devi
> >   		return NULL;
> >   	dma_map->dma_pages = kvcalloc(nr_pages, sizeof(*dma_map->dma_pages), GFP_KERNEL);
> > -	if (!dma_map) {
> > +	if (!dma_map->dma_pages) {
> >   		kfree(dma_map);
> >   		return NULL;
> >   	}
> > 
