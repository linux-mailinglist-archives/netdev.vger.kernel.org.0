Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E982D417E61
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 01:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239455AbhIXXoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 19:44:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232358AbhIXXoR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 19:44:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57A6F61212;
        Fri, 24 Sep 2021 23:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632526963;
        bh=6s1hS5Untl2+JJDSVN9cib3bTEm7YxZmSPA60nk/Cdg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mt8i1zH/jOrw0gqFOqGpPf1Lxi2x/anboN8s32cY9gDOR9nsQxRZ5QKJshYUkiGdr
         SaZpvOIG1e5VhjQ2Z5uY+0aeAq6Dgs3EBlaDuRWnU4wR4yfPPkOn4j5aEiJ5S42gzT
         KRcVz+HYqFS15Rdj7Bb72oQnR2ClBtmACdJrRzV/4cTIp4aWxljtavju2YA4Pouxd1
         86hc0vQSNmWDSs4AaWlOS2lXWamrCd1uISwea4hMKJ5ZyMfpQxFJ7T0cgDZ8HpP0FN
         1T3zNCSKuJJNAiKcu75tKvY0xf5ejqTf9wyr4pD1bY7BwI9hqvRfgh7djlWBKzGb4t
         NeFmto+YRZhBQ==
Date:   Fri, 24 Sep 2021 16:42:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yuchung Cheng <ycheng@google.com>
Cc:     Luke Hsiao <luke.w.hsiao@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Luke Hsiao <lukehsiao@google.com>
Subject: Re: [PATCH net-next] tcp: tracking packets with CE marks in BW rate
 sample
Message-ID: <20210924164242.1095c674@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAK6E8=dH8JYrKcO8tAUbzy6nT=w0eqjAZCnNwWg8qKUMqcwHbQ@mail.gmail.com>
References: <20210923211706.2553282-1-luke.w.hsiao@gmail.com>
        <20210924132005.264e4e2d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAK6E8=dH8JYrKcO8tAUbzy6nT=w0eqjAZCnNwWg8qKUMqcwHbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Sep 2021 16:30:28 -0700 Yuchung Cheng wrote:
> On Fri, Sep 24, 2021 at 1:20 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Thu, 23 Sep 2021 21:17:07 +0000 Luke Hsiao wrote:  
> > > From: Yuchung Cheng <ycheng@google.com>
> > >
> > > In order to track CE marks per rate sample (one round trip), TCP needs a
> > > per-skb header field to record the tp->delivered_ce count when the skb
> > > was sent. To make space, we replace the "last_in_flight" field which is
> > > used exclusively for NV congestion control. The stat needed by NV can be
> > > alternatively approximated by existing stats tcp_sock delivered and
> > > mss_cache.
> > >
> > > This patch counts the number of packets delivered which have CE marks in
> > > the rate sample, using similar approach of delivery accounting.  
> >
> > Is this expected to be used from BPF CC? I don't see a user..  
> Great question. Yes the commit message could be more clear that this
> intends for both ebpf-CC or other third party module that use ECN. For
> example bbr2 uses it heavily (bbr2 upstream WIP). This feature is
> useful for congestion control research which many use ECN as core
> signals now.

Interesting, thanks for explaining! :)
