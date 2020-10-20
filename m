Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56F9929337B
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 05:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391031AbgJTDPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 23:15:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391024AbgJTDPV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 23:15:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF34C223BF;
        Tue, 20 Oct 2020 03:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603163720;
        bh=+GDy+RWfsPaG4Za2HuIureFBbIKY3O2L49q9ESOtEeM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LguGcMGWUx7c7FJgPI08aj33A5Ayf5AXjewTjx3qFI3/T8tyG31F9E04c9B/tG7T/
         tuF7HLhbWJfh9yfszESfaswTPyeQdnV68Aje7YHUw25X8BfX9GjW9/w5fTYDUNHiZp
         chpEs6KCwjFKH9z7xg6S53kZLwoPe9oh0VtedO2E=
Date:   Mon, 19 Oct 2020 20:15:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Vincent Bernat <vincent@bernat.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        Andy Gospodarek <gospo@cumulusnetworks.com>
Subject: Re: [PATCH net-next v1] net: evaluate
 net.conf.ipvX.all.ignore_routes_with_linkdown
Message-ID: <20201019201518.4a48ef1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c23018cd-b382-7b0b-8166-71b5d04969c4@gmail.com>
References: <20201017125011.2655391-1-vincent@bernat.ch>
        <20201019175326.0e06b89d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c23018cd-b382-7b0b-8166-71b5d04969c4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Oct 2020 20:56:36 -0600 David Ahern wrote:
> On 10/19/20 6:53 PM, Jakub Kicinski wrote:
> > On Sat, 17 Oct 2020 14:50:11 +0200 Vincent Bernat wrote:  
> >> Introduced in 0eeb075fad73, the "ignore_routes_with_linkdown" sysctl
> >> ignores a route whose interface is down. It is provided as a
> >> per-interface sysctl. However, while a "all" variant is exposed, it
> >> was a noop since it was never evaluated. We use the usual "or" logic
> >> for this kind of sysctls.  
> >   
> >> Without this patch, the two last lines would fail on H1 (the one using
> >> the "all" sysctl). With the patch, everything succeeds as expected.
> >>
> >> Also document the sysctl in `ip-sysctl.rst`.
> >>
> >> Fixes: 0eeb075fad73 ("net: ipv4 sysctl option to ignore routes when nexthop link is down")
> >> Signed-off-by: Vincent Bernat <vincent@bernat.ch>  
> > 
> > I'm not hearing any objections, but I have two questions:
> >  - do you intend to merge it for 5.10 or 5.11? Because it has a fixes
> >    tag, yet it's marked for net-next. If we put it in 5.10 it may get
> >    pulled into stable immediately, knowing how things work lately.
> >  - we have other sysctls that use IN_DEV_CONF_GET(), 
> >    e.g. "proxy_arp_pvlan" should those also be converted?
> 
> The inconsistency with 'all' has been a major pain. In this case, I
> think it makes sense. Blindly changing all of them I suspect will lead
> to trouble. It is something reviewers should keep an eye on as sysctl
> settings get added.

Just saying.. if Vincent had the time to clean them all up _carefully_,
it'd be less likely we'll see another one added through copy & paste :)
