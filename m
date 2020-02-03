Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4A6D150DFC
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 17:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730990AbgBCQsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 11:48:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:35010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728876AbgBCQsX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 11:48:23 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43B302051A;
        Mon,  3 Feb 2020 16:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580748502;
        bh=5qn3J44Ornr8FlQUwjr282VdrCAuOLfDuKSzs4n6BZA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jHHC5auk5GVPvV7ypPXeZw04FGKiNBJ4TFOPXdzcKyYknlfsJvLwQgdc9A/QIfX09
         VURU2Aqzv1k22fJB4lScrZeeDeeD3ynEZ5rLwaMKNAafrDm1zvpuAoZXXS9e8YVEDt
         Kw8PhzC38WjDhQfkT4dyHE+vmPCRbAFpr3Q2dKXw=
Date:   Mon, 3 Feb 2020 08:48:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Max Neunhoeffer <max@arangodb.com>
Cc:     netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Roman Penyaev <rpenyaev@suse.de>,
        Christopher Kohlhoff <chris.kohlhoff@clearpool.io>,
        viro@zeniv.linux.org.uk
Subject: Re: epoll_wait misses edge-triggered eventfd events: bug in Linux
 5.3 and 5.4
Message-ID: <20200203084821.7a672861@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200203151536.caf6n4b2ymvtssmh@tux>
References: <20200131135730.ezwtgxddjpuczpwy@tux>
        <20200201121647.62914697@cakuba.hsd1.ca.comcast.net>
        <20200203151536.caf6n4b2ymvtssmh@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Feb 2020 16:15:36 +0100, Max Neunhoeffer wrote:
> Dear Jakub and all,
> 
> I have done a git bisect and found that this commit introduced the epoll
> bug:
> 
> https://github.com/torvalds/linux/commit/a218cc4914209ac14476cb32769b31a556355b22
> 
> I Cc the author of the commit.

Awesome, thanks a lot for doing that! Hopefully Roman can take a look
soon. Breaking boost::asio seems like a pretty serious regression.

> This makes sense, since the commit introduces a new rwlock to reduce
> contention in ep_poll_callback. I do not fully understand the details
> but this sounds all very close to this bug.
> 
> I have also verified that the bug is still present in the latest master
> branch in Linus' repository.
> 
> Furthermore, Chris Kohlhoff has provided yet another reproducing program
> which is no longer using edge-triggered but standard level-triggered
> events and epoll_wait. This makes the bug all the more urgent, since
> potentially more programs could run into this problem and could end up
> with sleeping barbers.
> 
> I have added all the details to the bugzilla bugreport:
> 
>   https://bugzilla.kernel.org/show_bug.cgi?id=205933
> 
> Hopefully, we can resolve this now equipped with this amount of information.
> 
> Best regards,
>   Max.
> 
> On 20/02/01 12:16, Jakub Kicinski wrote:
> > On Fri, 31 Jan 2020 14:57:30 +0100, Max Neunhoeffer wrote:  
> > > Dear All,
> > > 
> > > I believe I have found a bug in Linux 5.3 and 5.4 in epoll_wait/epoll_ctl
> > > when an eventfd together with edge-triggered or the EPOLLONESHOT policy
> > > is used. If an epoll_ctl call to rearm the eventfd happens approximately
> > > at the same time as the epoll_wait goes to sleep, the event can be lost, 
> > > even though proper protection through a mutex is employed.
> > > 
> > > The details together with two programs showing the problem can be found
> > > here:
> > > 
> > >   https://bugzilla.kernel.org/show_bug.cgi?id=205933
> > > 
> > > Older kernels seem not to have this problem, although I did not test all
> > > versions. I know that 4.15 and 5.0 do not show the problem.
> > > 
> > > Note that this method of using epoll_wait/eventfd is used by
> > > boost::asio to wake up event loops in case a new completion handler
> > > is posted to an io_service, so this is probably relevant for many
> > > applications.
> > > 
> > > Any help with this would be appreciated.  
> > 
> > Could be networking related but let's CC FS folks just in case.
> > 
> > Would you be able to perform bisection to narrow down the search 
> > for a buggy change?  

