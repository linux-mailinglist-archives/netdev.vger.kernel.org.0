Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02FEE4A8C7F
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 20:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353785AbiBCTeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 14:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353787AbiBCTe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 14:34:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319D6C061401;
        Thu,  3 Feb 2022 11:34:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C485761986;
        Thu,  3 Feb 2022 19:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA739C340EB;
        Thu,  3 Feb 2022 19:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643916868;
        bh=utBZ91xC68wf/1RW1HInTpjbO0Sz/IMNNgG3iiovr04=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N9WGFcikIUFZYmrx0VZQ4hASyFON91A7LZEo9gPiqjcGNQk5M871vBVy1EDZ9lur2
         pyE5Ej3sPpL+PfAiFCtGFzry3fZa3q1VDoRo/WEiP3fEsfB+50ZmuAR1OK0dpxWR1v
         ZknSjQBMNQ2dcPVGkGF/0jElu0sRhs2/rlR+mOiHZnZZgEKlxawYvx1YS5r6AGZ0il
         Sco59xry+Xjof7qNWEjX8zIjpJ4+U8Bh4PGkzOrYr5NsAkNLxaMy281dowgIMtwpUs
         ZuOVACG0NIXjR3lwCP3aGdO/EQPxZQy9HzH2lj25mSRDxZVP01MbGzQP6afpToNGyk
         aI3uwybVmgk2Q==
Date:   Thu, 3 Feb 2022 11:34:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jeffrey Ji <jeffreyjilinux@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Brian Vazquez <brianvv@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, jeffreyji <jeffreyji@google.com>
Subject: Re: [PATCH v6 net-next] net-core: add InMacErrors counter
Message-ID: <20220203113426.49c70285@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iJqQwUVnh3SPZ7j4RGMhEZsBk3uT3wosAbb1aFSzoyS+A@mail.gmail.com>
References: <20220201222845.3640041-1-jeffreyji@google.com>
        <20220202205916.58f4a592@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iJqQwUVnh3SPZ7j4RGMhEZsBk3uT3wosAbb1aFSzoyS+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Feb 2022 10:13:59 -0800 Eric Dumazet wrote:
> > I had another thing and this still doesn't sit completely well
> > with me :(
> >
> > Shouldn't we count those drops as skb->dev->rx_dropped?
> > Commonly NICs will do such filtering and if I got it right
> > in struct rtnl_link_stats64 kdoc - report them as rx_dropped.
> > It'd be inconsistent if on a physical interface we count
> > these as rx_dropped and on SW interface (or with promisc enabled
> > etc.) in the SNMP counters.  
> 
> I like to see skb->dev->rx_dropped as a fallback-catch-all bucket
> for all cases we do not already have a more specific counter.

Indeed, it's a fallback so counting relatively common events like
unicast filtering into generic "drops" feels wrong. I heard complaints
that this is non-intuitive and makes debug harder in the past.

> > Or we can add a new link stat that NICs can use as well.  
> 
> Yes, this could be done, but we have to be careful about not hitting
> a single cache line, for the cases we receive floods of such messages
> on multiqueue NIC.
> (The single atomic in dev->rx_dropped) is suffering from this issue btw)

Even more of a reason to bite the bullet and move from the atomic
counters to pcpu stats?

> > In fact I'm not sure this is really a IP AKA L3 statistic,
> > it's the L2 address that doesn't match.
> >
> >
> > If everyone disagrees - should we at least rename the MIB counter
> > similarly to the drop reason? Experience shows that users call for
> > help when they see counters with Error in their name, I'd vote for
> > IpExtInDropOtherhost or some such. The statistic should also be
> > documented in Documentation/networking/snmp_counter.rst  

