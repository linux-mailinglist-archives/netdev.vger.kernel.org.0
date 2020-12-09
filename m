Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4478C2D377C
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 01:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731002AbgLIASX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 19:18:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:45980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730236AbgLIAST (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 19:18:19 -0500
Date:   Tue, 8 Dec 2020 16:17:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607473059;
        bh=aR3NSc04/tQeb9C4y2gVnnEowXp1WnWby+B6l9znpVc=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=DxIEACBQD9B4BxSSj0aORq/nbKDFCVbJNlV8wAh5n0N35IjHXX7CsmqG07ApzTHwL
         nPPEoY4u+scMSuilLBtLOmVMdHefRnQgGMKZ+ZQ+kY5UzRBElUXFxd4/xUzSMYGitD
         qnqFRLLzC6rAdU8NzRwYXxcDSJcofWU3GaBHRkURgGorjeCRM2R3+PWEz+gm4F/5nn
         GMUubz/iCDJ2nDPsXOt2xNN1HrE+m3dcIFIIWwV+RbuhshFemPfD6yMI6OH4Az6K8q
         541WixQbaRQypP+wziE0pt0uEctCEnvvdAa+bob6aKhugqDgAKrBTdCD2OwPPoe1CR
         uDd4CNv7qqxTQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Benc <jbenc@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [RFC PATCH net-next 05/13] net: bonding: hold the netdev lists
 lock when retrieving device statistics
Message-ID: <20201208161737.0dff3139@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201209000355.vv4gaj7sgi6kph27@skbuf>
References: <20201206235919.393158-1-vladimir.oltean@nxp.com>
        <20201206235919.393158-6-vladimir.oltean@nxp.com>
        <20201207010040.eriknpcidft3qul6@skbuf>
        <20201208155744.320d694b@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <20201209000355.vv4gaj7sgi6kph27@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Dec 2020 00:03:56 +0000 Vladimir Oltean wrote:
> On Tue, Dec 08, 2020 at 03:57:44PM -0800, Jakub Kicinski wrote:
> > On Mon, 7 Dec 2020 01:00:40 +0000 Vladimir Oltean wrote:  
> > > - ensuring through convention that user space always takes
> > >   net->netdev_lists_lock when calling dev_get_stats, and documenting
> > >   that, and therefore making it unnecessary to lock in bonding.  
> >
> > This seems like the better option to me. Makes the locking rules pretty
> > clear.  
> 
> It is non-obvious to me that top-level callers of dev_get_stats should
> hold a lock as specific as the one protecting the lists of network
> interfaces. In the vast majority of implementations of dev_get_stats,
> that lock would not actually protect anything, which would lead into
> just one more lock that is used for more than it should be. In my tree I
> had actually already switched over to mutex_lock_nested. Nonetheless, I
> am still open if you want to make the case that simplicity should prevail
> over specificity.

What are the locking rules you have in mind then? Caller may hold RTNL
or ifc mutex?

> But in that case, maybe we should just keep on using the RTNL mutex.

That's a wasted opportunity, RTNL lock is pretty busy.
