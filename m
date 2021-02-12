Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01C03197FA
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 02:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhBLB3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 20:29:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:38106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhBLB3i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 20:29:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9451C64DC3;
        Fri, 12 Feb 2021 01:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613093337;
        bh=+GDhLPd6Nrjz2g2+qUmCgLSHBapyly/U54/5mDPHtsA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RBNGddB9dVdjJrEarOXO1X7dG2K8P2CGgbrTBQZYjxN+U/lEzl8IP+RN8NE8DMRHI
         yDPmKOlPXtczCB8D3UiAfMOss8jKNHcTUzYbiuvdjq1r/R9DT0bR1bwBkVFWj4yb+8
         lQPedB9DePn0DOzOnFnftU51KHS6d2gTIQGbu2o9Y8EpH/eGSDrZ+lwu+bCtt2VHVY
         dWWEsy8R/pSrTmX5s4avoKsnk78gxG0iIZ9Tf1WMQlV8JDs9US8Zu3kAi5q6G2fSTd
         5YAP85Lm1yJ/jRxdIaiVt8zHMIBhePvG7kslJUir1vnst1A5WQwVq6TTRUdaR+Ho70
         rUkPN35Ke9vpQ==
Date:   Thu, 11 Feb 2021 17:28:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Wei Wang <weiwan@google.com>, David Ahern <dsahern@gmail.com>,
        stranche@codeaurora.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: Re: Refcount mismatch when unregistering netdevice from kernel
Message-ID: <20210211172856.3d913519@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAADnVQ+AbH0Xs_fF5mESb2i-TCL0T-inpAX+gtggDbHhA+9djA@mail.gmail.com>
References: <ca64de092db5a2ac80d22eaa9d662520@codeaurora.org>
        <56e72b72-685f-925d-db2d-d245c1557987@gmail.com>
        <CAEA6p_D+diS7jnpoGk6cncWL8qiAGod2EAp=Vcnc-zWNPg04Jg@mail.gmail.com>
        <307c2de1a2ddbdcd0a346c57da88b394@codeaurora.org>
        <CAEA6p_ArQdNp=hQCjrsnAo-Xy22d44b=2KdLp7zO7E7XDA4Fog@mail.gmail.com>
        <f10c733a-09f8-2c72-c333-41f9d53e1498@gmail.com>
        <6a314f7da0f41c899926d9e7ba996337@codeaurora.org>
        <839f0ad6-83c1-1df6-c34d-b844c52ba771@gmail.com>
        <9f25d75823a73c6f0f556f0905f931d1@codeaurora.org>
        <5905440c-163a-d13e-933e-c9273445a6ed@gmail.com>
        <CAEA6p_CfmJZuYy7msGm0hi813q92hO2daC_zEZhhj0y3FYJ4LA@mail.gmail.com>
        <CAADnVQ+AbH0Xs_fF5mESb2i-TCL0T-inpAX+gtggDbHhA+9djA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Feb 2021 11:21:26 -0800 Alexei Starovoitov wrote:
> On Tue, Jan 5, 2021 at 11:11 AM Wei Wang <weiwan@google.com> wrote:
> > On Mon, Jan 4, 2021 at 8:58 PM David Ahern <dsahern@gmail.com> wrote:  
> > > On 1/4/21 8:05 PM, stranche@codeaurora.org wrote:  
> > Ah, I see now. rt6_flush_exceptions is called by fib6_del_route, but
> > > that won't handle replace.
> > >
> > > If you look at fib6_purge_rt it already has a call to remove pcpu
> > > entries. This call to flush exceptions should go there and the existing
> > > one in fib6_del_route can be removed.
> > >  
> > Thanks for catching this!
> > Agree with this proposed fix.  
> 
> Looks like this fix never landed?
> Is it still needed or there was an alternative fix merged?

Wasn't it:

d8f5c29653c3 ("net: ipv6: fib: flush exceptions when purging route")

?
