Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A9F30B1C3
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 21:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhBAUzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 15:55:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:47176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229525AbhBAUzt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 15:55:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11FEC64ECC;
        Mon,  1 Feb 2021 20:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612212905;
        bh=fR5ypanDxbYu3TSpz/2DD42pTbNFRpUDs/iqubEEB0E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PZ/q5NQNFrsYDZdc5/CJEefVLdx7vsZjvjxOXjpzxskzE9/u3MIbHnOw9jbvXRVg3
         6aH5koXc29rlB4FL5IeqG+TddfnR6N+/WY+QL2+9sJ9s1Oin5FWoQ6Lv+B7PCXs+N9
         RtZh+ZObvbWBkbMOM6F61xj/xDWYJKfycPvK/kAWXkwUgHiEneYMurS4Rj9Qujr2FW
         QYD+01EkHpzlKKTu245vNDz520foeyGNFkFFcPZKL+aiuqd/gc+tIvMBx3gDfJHEsA
         WQkJ8e/8LbA3XObBDdEHbH6epjKC/pEI+XM3iX6reAdCbXwPN8GSRBYl7tI7+xf7tK
         hSik43Z+4D+IQ==
Date:   Mon, 1 Feb 2021 12:55:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: mhi-net: Add de-aggeration support
Message-ID: <20210201125504.7646de2a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAF=yD-KT0nPEV4CphRH3xVJhXqpK=FQHM-3TkK+88ZqA9afeFw@mail.gmail.com>
References: <1611589557-31012-1-git-send-email-loic.poulain@linaro.org>
        <20210129170129.0a4a682a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMZdPi_6tBkdQn+wakUmeMC+p8N3HStEja5ZfA3K-+x4DcM68g@mail.gmail.com>
        <CAF=yD-+UFHO8nKsB3Z7n-xhoFtXwge2GEZj-2+-7=EETLjYXFA@mail.gmail.com>
        <CAMZdPi_dMBDafAVoHbqwR9RDbtZSJpGd48oCMmL1qAgR+PCFGQ@mail.gmail.com>
        <CAF=yD-KT0nPEV4CphRH3xVJhXqpK=FQHM-3TkK+88ZqA9afeFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Feb 2021 13:33:05 -0500 Willem de Bruijn wrote:
> On Mon, Feb 1, 2021 at 11:41 AM Loic Poulain <loic.poulain@linaro.org> wrote:
> > On Mon, 1 Feb 2021 at 15:24, Willem de Bruijn wrote:  
> > > What is this path to rmnet, if not the usual xmit path / validate_xmit_skb?  
> >
> > I mean, not sure what to do exactly here, instead of using
> > skb_copy_expand to re-aggregate data from the different skbs, Jakub
> > suggests chaining the skbs instead (via 'frag_list' and 'next' pointer
> > I assume), and to push this chained skb to net core via netif_rx. In
> > that case, I assume the de-fragmentation/linearization will happen in
> > the net core, right? If the transported protocol is rmnet, the packet
> > is supposed to reach the rmnet_rx_handler at some point, but rmnet
> > only works with standard/linear skbs.  
> 
> If it has that limitation, the rx_handler should have a check and linearize.

Do you mean it's there or we should add it? 

> That is simpler than this skb_copy_expand, and as far as I can see no
> more expensive.

rx_handler is only used by uppers which are 100% SW. I think the right
path is to fix the upper, rather than add a check to the fastpath, no?

Perhaps all that's needed is a:

 pskb_may_pull(skb, sizeof(struct rmnet_map_header))

in rmnet? Hope I'm not missing some crucial point :)
