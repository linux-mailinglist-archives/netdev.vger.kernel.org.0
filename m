Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10FB6294629
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 03:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439819AbgJUBMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 21:12:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393566AbgJUBMv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 21:12:51 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13B0220797;
        Wed, 21 Oct 2020 01:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603242770;
        bh=F0ZRb+mdfX6HmCXMGQeWnzuDZQ3tB6EJvop6Q2QwpJI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JfuuK2xZSaDTP5omlFgsr9bgUmDxwb2qXvvyM9Ur/QRMJhPAKMh7AA4gXRdalDgv3
         HIypV+nveSKFqwd2jhte5j41RRYpXsXZ7Pj5PhgT8nZZY5yQ9NIYeBdOIY8pY7kAqD
         GPukdNvCWfS1zWg2NzHHXpMSznvAbs3ROBxhnZuQ=
Date:   Tue, 20 Oct 2020 18:12:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Yunjian Wang <wangyunjian@huawei.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: Have netpoll bring-up DSA management interface
Message-ID: <20201020181247.7e1c161b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201019211916.j77jptfpryrhau4z@skbuf>
References: <20201019171746.991720-1-f.fainelli@gmail.com>
        <20201019200258.jrtymxikwrijkvpq@skbuf>
        <58b07285-bb70-3115-eb03-5e43a4abeae6@gmail.com>
        <20201019211916.j77jptfpryrhau4z@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 00:19:16 +0300 Vladimir Oltean wrote:
> On Mon, Oct 19, 2020 at 02:03:40PM -0700, Florian Fainelli wrote:
> > > Completely crazy and outlandish idea, I know, but what's wrong with
> > > doing this in DSA?  
> > 
> > I really do not have a problem with that approach however other stacked
> > devices like 802.1Q do not do that. It certainly scales a lot better to
> > do this within DSA rather than sprinkling DSA specific knowledge
> > throughout the network stack. Maybe for "configuration less" stacked
> > devices such as DSA, 802.1Q (bridge ports?), bond etc. it would be
> > acceptable to ensure that the lower device is always brought up?  
> 
> For upper interfaces with more than one lower (bridge, bond) I'm not so
> sure. For uppers with a single lower (DSA, 8021q), it's pretty much a
> no-brainer to me. Question is, where to code this? I think it's ok to
> leave it in DSA, then 8021q could copy it as well if there was a need.

FWIW no strong preference here. Maybe I'd lean slightly towards
Florian's approach since we can go to the always upping the CPU netdev
from that, if we start with auto-upping CPU netdev - user space may
depend on that in general so we can't go back.

But up to you folks, this seems like a DSA-specific problem, vlans don't
get created before user space is up (AFAIK), so there is no compelling
reason to change them in my mind.

Florian for you patch specifially - can't we use
netdev_for_each_lower_dev()?
