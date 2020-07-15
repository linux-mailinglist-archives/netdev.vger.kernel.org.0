Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22FB62215A2
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 21:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgGOT6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 15:58:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726650AbgGOT6q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 15:58:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC1962065F;
        Wed, 15 Jul 2020 19:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594843126;
        bh=kgLUYhenQ2s182M/0+H610d75MLJhx48t/EpB1gdcmg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lKchPb2+RzyaC1rzDN3xOG/MasPpXqSJ1R0eZwfsqMKsVNaBY7OVwDhrjtC7/BHTj
         SZAJFHoeJXORte+aFey289IMPWM4KFlzTQEfdP39to8y8pL7mif1Lp0mi0qOWfMgJX
         Co7r3Joezmkl7lsi8rH7oxqSrn2kySAKK2l8sZSM=
Date:   Wed, 15 Jul 2020 12:58:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, bpf@vger.kernel.org,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com,
        brouer@redhat.com, echaudro@redhat.com, sameehj@amazon.com
Subject: Re: [PATCH 2/6] net: mvneta: move skb build after descriptors
 processing
Message-ID: <20200715125844.567e5795@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f5e95c08e22113d21e86662f1cf5ccce16ccbfca.1594309075.git.lorenzo@kernel.org>
References: <cover.1594309075.git.lorenzo@kernel.org>
        <f5e95c08e22113d21e86662f1cf5ccce16ccbfca.1594309075.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Jul 2020 17:57:19 +0200 Lorenzo Bianconi wrote:
> +		frag->bv_offset = pp->rx_offset_correction;
> +		skb_frag_size_set(frag, data_len);
> +		frag->bv_page = page;
> +		sinfo->nr_frags++;

nit: please use the skb_frag_* helpers, in case we have to rename those
     fields again. You should also consider adding a helper for the
     operation of appending a frag, I bet most drivers will needs this.

> +static struct sk_buff *
> +mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
> +		      struct xdp_buff *xdp, u32 desc_status)
> +{
> +	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> +	int i, num_frags = sinfo->nr_frags;
> +	skb_frag_t frags[MAX_SKB_FRAGS];
> +	struct sk_buff *skb;
> +
> +	memcpy(frags, sinfo->frags, sizeof(skb_frag_t) * num_frags);
> +
> +	skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
> +	if (!skb)
> +		return ERR_PTR(-ENOMEM);
> +
> +	page_pool_release_page(rxq->page_pool, virt_to_page(xdp->data));
> +
> +	skb_reserve(skb, xdp->data - xdp->data_hard_start);
> +	skb_put(skb, xdp->data_end - xdp->data);
> +	mvneta_rx_csum(pp, desc_status, skb);
> +
> +	for (i = 0; i < num_frags; i++) {
> +		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
> +				frags[i].bv_page, frags[i].bv_offset,
> +				skb_frag_size(&frags[i]), PAGE_SIZE);
> +		page_pool_release_page(rxq->page_pool, frags[i].bv_page);
> +	}
> +
> +	return skb;
> +}

Here as well - is the plan to turn more of this function into common
code later on? Looks like most of this is not really driver specific.
