Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC5F222C17
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 21:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbgGPToa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 15:44:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728788AbgGPTo3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 15:44:29 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89C8E2074B;
        Thu, 16 Jul 2020 19:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594928669;
        bh=tTsfr9spLBHrmem81RG3mKB+f9nWxRvuVOlj4RpL16k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P0XJDbI/vCOV4XjtoxXLzn9R06t3h5zmjIdZEu8m5xr1Hokf1nItFSEacfrRAQxQa
         Wf/mPZ+JHOGSEXusucf1wcT9LEl+7+Q0EGJnf4bJo9WfWeUWCGz3E6eT05MqmgpFck
         yTheFHanIWM7pQM62LSX+1NyhsPnBm6hRYGRmzic=
Date:   Thu, 16 Jul 2020 12:44:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, bpf@vger.kernel.org,
        ilias.apalodimas@linaro.org, brouer@redhat.com,
        echaudro@redhat.com, sameehj@amazon.com
Subject: Re: [PATCH 2/6] net: mvneta: move skb build after descriptors
 processing
Message-ID: <20200716124426.4f7c3a67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200716191251.GH2174@localhost.localdomain>
References: <cover.1594309075.git.lorenzo@kernel.org>
        <f5e95c08e22113d21e86662f1cf5ccce16ccbfca.1594309075.git.lorenzo@kernel.org>
        <20200715125844.567e5795@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200716191251.GH2174@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jul 2020 21:12:51 +0200 Lorenzo Bianconi wrote:
> > > +static struct sk_buff *
> > > +mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
> > > +		      struct xdp_buff *xdp, u32 desc_status)
> > > +{
> > > +	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> > > +	int i, num_frags = sinfo->nr_frags;
> > > +	skb_frag_t frags[MAX_SKB_FRAGS];
> > > +	struct sk_buff *skb;
> > > +
> > > +	memcpy(frags, sinfo->frags, sizeof(skb_frag_t) * num_frags);
> > > +
> > > +	skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
> > > +	if (!skb)
> > > +		return ERR_PTR(-ENOMEM);
> > > +
> > > +	page_pool_release_page(rxq->page_pool, virt_to_page(xdp->data));
> > > +
> > > +	skb_reserve(skb, xdp->data - xdp->data_hard_start);
> > > +	skb_put(skb, xdp->data_end - xdp->data);
> > > +	mvneta_rx_csum(pp, desc_status, skb);
> > > +
> > > +	for (i = 0; i < num_frags; i++) {
> > > +		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
> > > +				frags[i].bv_page, frags[i].bv_offset,
> > > +				skb_frag_size(&frags[i]), PAGE_SIZE);
> > > +		page_pool_release_page(rxq->page_pool, frags[i].bv_page);
> > > +	}
> > > +
> > > +	return skb;
> > > +}  
> > 
> > Here as well - is the plan to turn more of this function into common
> > code later on? Looks like most of this is not really driver specific.  
> 
> I agree. What about adding it when other drivers will add multi-buff support?
> (here we have even page_pool dependency)

I guess that's okay on the condition that you're going to be the one
adding the support to the next driver, or at least review it very
closely to make sure it's done.

In general vendors prove rather resistant to factoring code out, 
the snowflakes they feel they are.
