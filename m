Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA0F55C766
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 04:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfGBChb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 22:37:31 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:47606 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfGBChb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 22:37:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gez4SF/55906ISMZCFzKeetHRlJz25pE1fVzyl25ZK4=; b=CQ9UUlEUfjeoRSZa6NyG3Ko5m
        9CsKr2beHRYBb0nlk2L8LqpaTYnVwQueHCWjpfT/jK/ekUXTcFkhiY3beZMiKrKghbrtb25oedcu4
        RLCLyMPVkC/UNJwBOJfbvk2sVloPHyW5m0TiYWaInkRzUWInUu9kBsubHA6OMgO6ptJYP1nJhbt/d
        NGHYXxDoc6r3SDkHdphY+y1sGsVdT6XAWCBIsu1l3tU+8f+3FRtzHbpL+Hm+IBpvKNG7MN5VDfwMo
        hseVgFkwr651j4qA8hNYhCPLL81+NTQWOYcoIwy7d/Pz+djttN4Gq54a/2QRB2N6foLgxUO7XVhUf
        CjjcCy8Yw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hi8fi-0007Qv-9g; Tue, 02 Jul 2019 02:37:30 +0000
Date:   Mon, 1 Jul 2019 19:37:30 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     David Miller <davem@davemloft.net>
Cc:     xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        dcaratti@redhat.com, chrism@mellanox.com
Subject: Re: [Patch net 0/3] idr: fix overflow cases on 32-bit CPU
Message-ID: <20190702023730.GA1729@bombadil.infradead.org>
References: <20190628180343.8230-1-xiyou.wangcong@gmail.com>
 <20190701.191600.1570499492484804858.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701.191600.1570499492484804858.davem@davemloft.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 07:16:00PM -0700, David Miller wrote:
> From: Cong Wang <xiyou.wangcong@gmail.com>
> Date: Fri, 28 Jun 2019 11:03:40 -0700
> 
> > idr_get_next_ul() is problematic by design, it can't handle
> > the following overflow case well on 32-bit CPU:
> > 
> > u32 id = UINT_MAX;
> > idr_alloc_u32(&id);
> > while (idr_get_next_ul(&id) != NULL)
> >  id++;
> > 
> > when 'id' overflows and becomes 0 after UINT_MAX, the loop
> > goes infinite.
> > 
> > Fix this by eliminating external users of idr_get_next_ul()
> > and migrating them to idr_for_each_entry_continue_ul(). And
> > add an additional parameter for these iteration macros to detect
> > overflow properly.
> > 
> > Please merge this through networking tree, as all the users
> > are in networking subsystem.
> 
> Series applied, thanks Cong.

Ugh, I don't even get the weekend to reply?

I think this is just a bad idea.  It'd be better to apply the conversion
patches to use XArray than fix up this crappy interface.  I didn't
reply before because I wanted to check those patches still apply and
post them as part of the response.  Now they're definitely broken and
need to be redone.
