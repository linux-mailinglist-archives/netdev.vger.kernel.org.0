Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF4610676
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 11:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfEAJoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 05:44:39 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41396 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbfEAJoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 05:44:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=P89j+25lH0nkY1fWt1lCASyBoIOZxVLtI8SLGLQKKnI=; b=djDhol+MuXzIaHsOiQQZagWbU
        Xx6yR2Yh6NclihBk0gid4rBg40151OMAxcja6+m4NlbPXlqCgZOVrGzPNA4X9x9XF7vSlPfqUzPIf
        cDmjBsbjIQOVQ/XB/2jhQNg7vwXP1Ip+CUTyVyjrByL0FdPYncPF+NrexKTkWhpRLbDWSJ0bTcLjB
        rq/tDlQGDXKQ1KyZ1Rvcj3rP+zREmmN4uI6VyvQFhm/viSz9uUiz3svIYWfxyUvnrgDTWylY6XZ5+
        tbEoiyxq3lwuWHkxtmd1LrFPd1hNwyX+FvJE0wnRGwLWte7a/9nF0fHSV2YVCxLET9ipf0LwVUOAI
        bugHGBavA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hLln3-0004Ey-FU; Wed, 01 May 2019 09:44:37 +0000
Date:   Wed, 1 May 2019 02:44:37 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, hch@lst.de, netdev@vger.kernel.org
Subject: Re: [PATCH 0/5] Beginnings of skb_frag -> bio_vec conversion
Message-ID: <20190501094437.GA3698@bombadil.infradead.org>
References: <20190501041757.8647-1-willy@infradead.org>
 <639880c6-5703-857c-8a70-82fbb5a90238@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <639880c6-5703-857c-8a70-82fbb5a90238@gmail.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 01, 2019 at 04:14:41AM -0400, Eric Dumazet wrote:
> On 4/30/19 9:17 PM, Matthew Wilcox wrote:
> > It turns out there's a lot of accessors for the skb_frag, which would
> > make this conversion really easy if some drivers didn't bypass them.
> > This is what I've done so far; my laptop's not really beefy enough to
> > cope with changing skbuff.h too often ;-)
> 
> I guess the missing part here is the "why" all this is done ?
> 
> 32 bit hosts will have bigger skb_shared_info and this impacts sk_rcvbuf and sk_sndbuf limits.
> 
> 17 * 4 are 68 extra bytes per skb.

Right.  The plan is to replace get_user_pages() with get_user_bvec().  If
userspace has physically consecutive pages (and often it will, even when
not using THP), we can reduce the number of elements in the array at the
start.  So each skb_frag_t is larger, but you'll have fewer of them for a
large I/O.  Obviously this particularly benefits THP.

