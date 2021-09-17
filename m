Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB1440F8C1
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 15:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239274AbhIQNFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 09:05:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235210AbhIQNFE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 09:05:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1BC660F48;
        Fri, 17 Sep 2021 13:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631883822;
        bh=Zpqs4tz9LSG5D1zsE7TxY7t0vDwPKj/dDbqUqK/0F2Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G2Zw3EbJo/5JrGm5QUHv3divBA1bX88bgMI0RPSgQnvjwOIT5UdndwEQf95byvJiw
         w0UEMYc/012wLqPP8p0bU+O/rXkHT79jE6Q7AjvHrdRB0IJrsYLAnuVzWmYUeyedQO
         TLOyYpzG6bZpmQ21snCqRpB8qCh7ZBR9fJeyU67zkKJ6mZb98wdBibePOfuHoQ3/PB
         izprXbk2WrKEYuQd5pyfPPgSvWAiEaGQ44HA7aoWl8QofgnIfeyr3yUVZXQwBEdXok
         FtcKPtyR2p2rLuewCgvC1mWTRZHWO6m90TLWQcYubn+eKnexXlVHuSD0KeENtdoOsC
         aDiaCCvjrgnTQ==
Date:   Fri, 17 Sep 2021 06:03:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v14 bpf-next 10/18] bpf: add multi-buff support to the
 bpf_xdp_adjust_tail() API
Message-ID: <20210917060340.12e87d55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YURnxr89pcasiplc@lore-desk>
References: <cover.1631289870.git.lorenzo@kernel.org>
        <e07aa987d148c168f1ac95a315d45e24e58c54f5.1631289870.git.lorenzo@kernel.org>
        <20210916095544.50978cd0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YURnxr89pcasiplc@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Sep 2021 12:02:46 +0200 Lorenzo Bianconi wrote:
> > > +static inline unsigned int xdp_get_frag_tailroom(const skb_frag_t *frag)
> > > +{
> > > +	struct page *page = skb_frag_page(frag);
> > > +
> > > +	return page_size(page) - skb_frag_size(frag) - skb_frag_off(frag);
> > > +}  
> > 
> > How do we deal with NICs which can pack multiple skbs into a page frag?
> > skb_shared_info field to mark the end of last fragment? Just want to make 
> > sure there is a path to supporting such designs.  
> 
> I guess here, intead of using page_size(page) we can rely on xdp_buff->frame_sz
> or even on skb_shared_info()->xdp_frag_truesize (assuming all fragments from a
> given hw have the same truesize, but I think this is something we can rely on)
> 
> static inline unsigned int xdp_get_frag_tailroom(struct xdp_buff *xdp,
> 						 const skb_frag_t *frag)
> {
> 	return xdp->frame_sz - skb_frag_size(frag) - skb_frag_off(frag);
> }
> 
> what do you think?

Could work! We'd need to document the semantics of frame_sz for mb
frames clearly but I don't see why not. 
