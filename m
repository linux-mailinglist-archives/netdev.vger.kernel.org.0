Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD21281D90
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 23:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbgJBVWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 17:22:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgJBVWI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 17:22:08 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6ECEE206DB;
        Fri,  2 Oct 2020 21:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601673727;
        bh=p4MT7gm98X4afTszrDmaPoaehfQkTv5jXfXOgbRw6V8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yxg2sqVO3BPBpSlduwI+BLXBQsn0GdOw+D0gEfW6iNFmXmevWivqwVPUyBKoUIkbq
         kt//cBzNcsKGweER2ZVU4dpVvdjhwW+ogOjOv+SUVCKWbrMoR5gWcAKWd3N17dlCjL
         v8iY2MyYLWWZgtJJ8nz7uij48ZC+fBcfEwEju4x4=
Date:   Fri, 2 Oct 2020 14:22:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        jiri@resnulli.us, mkubecek@suse.cz, dsahern@kernel.org,
        pablo@netfilter.org
Subject: Re: [PATCH net-next v2 00/10] genetlink: support per-command policy
 dump
Message-ID: <20201002142205.5a16fb0f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201002141701.3a30c54c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201001225933.1373426-1-kuba@kernel.org>
        <d26ccd875ebac452321343cc9f6a9e8ef990efbf.camel@sipsolutions.net>
        <20201002074001.3484568a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1dacbe07dc89cd69342199e61aeead4475f3621c.camel@sipsolutions.net>
        <20201002075538.2a52dccb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <e350fbdadd8dfa07bef8a76631d8ec6a6c6e8fdf.camel@sipsolutions.net>
        <20201002080308.7832bcc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a69c92aac65c718b1bd80c8dc0cbb471cdd17d9b.camel@sipsolutions.net>
        <20201002080944.2f63ccf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <cc9594d16270aeb55f9f429a234ec72468403b93.camel@sipsolutions.net>
        <20201002135059.1657d673@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <47b6644999ce2946a262d5eac0c82e33057e7321.camel@sipsolutions.net>
        <6adbdd333e2db1ab9ac8f08e8ad3263d43bde55e.camel@sipsolutions.net>
        <20201002141701.3a30c54c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2 Oct 2020 14:17:01 -0700 Jakub Kicinski wrote:
> On Fri, 02 Oct 2020 23:00:15 +0200 Johannes Berg wrote:
> > On Fri, 2020-10-02 at 22:59 +0200, Johannes Berg wrote:  
> > > On Fri, 2020-10-02 at 13:50 -0700, Jakub Kicinski wrote:    
> > > > My thinking was that until kernel actually start using separate dump
> > > > policies user space can assume policy 0 is relevant. But yeah, merging
> > > > your changes first would probably be best.    
> > > 
> > > Works for me. I have it based on yours. Just updated my branch (top
> > > commit is 4d5045adfe90), but I'll probably only actually email it out
> > > once things are a bit more settled wrt. your changes.    
> > 
> > Forgot the link ...
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git/log/?h=genetlink-op-policy-export  
> 
> If it's not too late for you - do you want to merge the two series and
> post everything together? Perhaps squashing patch 10 into something if
> that makes sense?
> 
> You already seem to have it rebased.

FWIW earlier I said:

	if ((op.doit && nla_put_u32(skb, CTRL_whatever_DO, idx)) ||
	    (op.dumpit && nla_put_u32(skb, CTRL_whatever_DUMP, idx)))
		goto nla_put_failure;

 - we should probably also check GENL_DONT_VALIDATE_DUMP here?
