Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735D13B0C98
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbhFVSMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 14:12:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232761AbhFVSLw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 14:11:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E98960249;
        Tue, 22 Jun 2021 18:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624385376;
        bh=V3m07rt1zumMAyOQpUPnX4yfe8HBAm9o8d0mv0AkZvg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SayTk/KRk0Iy/60efAYO82KAW43gW6hYHukDxEwmhCUy5Xg3+6S/BTVWVtQEdS3sa
         ROYQXLHgbZepWKJwWP9Mx5au5fSCzWSUNkCO9cq+F1k7KI4DYDDe/T+J6WsWgIcdFA
         BSrbyKuPNiHSQjA/aHQHQjOE46Y7tZFhCeWoGIqio5Ji7gd0EZnE3uMpiXcwrQmC6X
         wQzyMK8wEGcX83dPB9QyLr2B42ApwXJ02H0Nw2MQssPIqduq4dbMuoVvnvw8B9EiMq
         nhJ/H14xyo24hX/lCwkWqb2yTAPzjKUZl/vWH7vnOByf++J+XfValj9OAcsEidyA3P
         ijjToY7HoUQcA==
Date:   Tue, 22 Jun 2021 11:09:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, willemb@google.com,
        dsahern@gmail.com, yoshfuji@linux-ipv6.org, Dave Jones <dsj@fb.com>
Subject: Re: [PATCH net-next] ip: avoid OOM kills with large UDP sends over
 loopback
Message-ID: <20210622110935.35318a30@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <462f87f4-cc90-1c0e-3a9f-c65c64781dc3@gmail.com>
References: <20210621231307.1917413-1-kuba@kernel.org>
        <8fe00e04-3a79-6439-6ec7-5e40408529e2@gmail.com>
        <20210622095422.5e078bd4@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <462f87f4-cc90-1c0e-3a9f-c65c64781dc3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Jun 2021 19:48:43 +0200 Eric Dumazet wrote:
> >> What about using 	sock_alloc_send_pskb(... PAGE_ALLOC_COSTLY_ORDER)
> >> (as we did in unix_dgram_sendmsg() for large packets), for SG enabled interfaces ?  
> > 
> > PAGE_ALLOC_COSTLY_ORDER in itself is more of a problem than a solution.
> > AFAIU the app sends messages primarily above the ~60kB mark, which is
> > above COSTLY, and those do not trigger OOM kills. All OOM kills we see
> > have order=3. Checking with Rik and Johannes W that's expected, OOM
> > killer is only invoked for allocations <= COSTLY, larger ones will just
> > return NULL and let us deal with it (e.g. by falling back).  
> 
> I  really thought alloc_skb_with_frags() was already handling low-memory-conditions.
> 
> (alloc_skb_with_frags() is called from sock_alloc_send_pskb())
> 
> If it is not, lets fix it, because af_unix sockets will have the same issue ?

af_unix seems to cap at SKB_MAX_ALLOC which is order 2, AFAICT.

Perhaps that's a good enough fix in practice given we see OOMs with
order=3 only?

I'll review callers of alloc_skb_with_frags() and see if they depend 
on the explicit geometry of the skb or we can safely fallback to pages.
