Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3203F2DDA48
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 21:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730253AbgLQUpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 15:45:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:40746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbgLQUpq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 15:45:46 -0500
Date:   Thu, 17 Dec 2020 12:45:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608237906;
        bh=hu1PIHXgnMbM7Xzdw1Op6CMyMpMS8F4OPFXcL0IU7ZA=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=rsRDfX+1i7n/oBWhRFYZf/AEcXktV2uRl/54s0CB2V/7f+FOahRgEczFSQEBprOCm
         eJV7h6W6UxzPkfEhURmA2iLvSlK4NfQoxNkPotO/i3eFTc7dEOqwKUJQVIQUsfVzyl
         YE5iPdCVJI8YxtIwQj6e4oUrlDVg+ZvekyKhWSQLLkAzZEuDn6kLgmh3EeHDmpo4E1
         gshjBmY61/GrAyrNaFZ8wXy2Orvf3A6fr5XYX8n+Eo/0Ov/rWK6bw7dSJ0RgAz2jC3
         DpBVR+/orqYU1wQWjFWVjuXYjIKnlzKRqXx4FTpzZdnhiac74KAtWDvP3oQhaN246J
         WcyjZS/NjRe9Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net/sched: sch_taprio: reset child qdiscs before
 freeing them
Message-ID: <20201217124504.561c67c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <786e7a967a73f29995107412bc3506daf657c29a.camel@redhat.com>
References: <63b6d79b0e830ebb0283e020db4df3cdfdfb2b94.1608142843.git.dcaratti@redhat.com>
        <20201217110531.6fd60fe5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <786e7a967a73f29995107412bc3506daf657c29a.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Dec 2020 21:32:29 +0100 Davide Caratti wrote:
> hello Jakub, and thanks for checking!
> 
> On Thu, 2020-12-17 at 11:05 -0800, Jakub Kicinski wrote:
> > On Wed, 16 Dec 2020 19:33:29 +0100 Davide Caratti wrote:  
> > > +	if (q->qdiscs) {
> > > +		for (i = 0; i < dev->num_tx_queues && q->qdiscs[i]; i++)
> > > +			qdisc_reset(q->qdiscs[i]);  
> > 
> > Are you sure that we can't graft a NULL in the middle of the array?  
> 
> that should not happen, because child qdiscs are checked for being non-
> NULL when they are created:
> 
> https://elixir.bootlin.com/linux/v5.10/source/net/sched/sch_taprio.c#L1674
> 
> and then assigned to q->qdiscs[i]. So, there might be NULL elements of
> q->qdiscs[] in the middle of the array when taprio_reset() is called,
> but it should be ok to finish the loop when we encounter the first one:
> subsequent ones should be NULL as well.

Right, but that's init, look at taprio_graft(). The child qdiscs can be
replaced at any time. And the replacement can be NULL otherwise why
would graft check "if (new)"

