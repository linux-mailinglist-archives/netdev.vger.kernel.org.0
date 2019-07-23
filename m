Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20DA8716D0
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 13:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389205AbfGWLR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 07:17:59 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56834 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfGWLR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 07:17:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dJV3JYX4XjkMoPg2ewDtERCo1QK28SRSTcMz2v9kNhQ=; b=ezOE5StUIg/H7Rj0+gMuU7Ur+
        cZAkZh/OCaxIB+QoQ1mpRuflygZFVK2jxGsQSQdHlgg7n6ECuNN9rbOJ6M/X3G/RvL69n5aMWIXAU
        ThrcQ2MF+bJHgt41pfRlNRjz/BGztlHRgmY6KnSV/vzrqeZmqv6s83AoPN2XdhGN6DExPvuopNf90
        UNfnJt0d4kyBJfxszxpNymoaE2DTkU6f3mzKwPh6IzU0HLOynyL43aw7vEDSSIOFrM+oGnLclmdVt
        aROQX+/Qdi4gpJ4chj+AhzelPHStkcP1vUR/l+R4IcJK44Wi7kq1NwOGlA8/FqST70x8/wHvyqHAp
        UeKFaMY/w==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hpsnr-0005AD-TX; Tue, 23 Jul 2019 11:17:55 +0000
Date:   Tue, 23 Jul 2019 04:17:55 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, hch@lst.de, netdev@vger.kernel.org
Subject: Re: [PATCH v3 2/7] net: Use skb accessors in network core
Message-ID: <20190723111755.GI363@bombadil.infradead.org>
References: <20190723030831.11879-1-willy@infradead.org>
 <20190723030831.11879-3-willy@infradead.org>
 <aa40f270-9f55-323a-2e94-5bd326a7a142@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa40f270-9f55-323a-2e94-5bd326a7a142@huawei.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 11:56:41AM +0800, Yunsheng Lin wrote:
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 6f1e31f674a3..e32081709a0d 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -2975,11 +2975,15 @@ skb_zerocopy(struct sk_buff *to, struct sk_buff *from, int len, int hlen)
> >  	skb_zerocopy_clone(to, from, GFP_ATOMIC);
> >  
> >  	for (i = 0; i < skb_shinfo(from)->nr_frags; i++) {
> > +		int size;
> > +
> >  		if (!len)
> >  			break;
> >  		skb_shinfo(to)->frags[j] = skb_shinfo(from)->frags[i];
> > -		skb_shinfo(to)->frags[j].size = min_t(int, skb_shinfo(to)->frags[j].size, len);
> > -		len -= skb_shinfo(to)->frags[j].size;
> > +		size = min_t(int, skb_frag_size(&skb_shinfo(to)->frags[j]),
> > +					len);
> 
> It seems skb_frag_size returns unsigned int here, maybe:
> 
> unsigned int size;
> 
> size = min_t(unsigned int, skb_frag_size(&skb_shinfo(to)->frags[j]),
> 
> The original code also do not seem to using the correct min_t, but
> perhaps it is better to clean that up too?

A signed size also doesn't make sense to me, but I wasn't sufficiently
certain to make that change.  Please feel free to send a followup patch
for people to consider.
