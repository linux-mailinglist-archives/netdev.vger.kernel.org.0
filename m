Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45922E6C4E
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730063AbgL1Wzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:52030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729514AbgL1Val (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Dec 2020 16:30:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AE2E208B6;
        Mon, 28 Dec 2020 21:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609191000;
        bh=kMvIj1+r6ndWcRIOjeOQI8hp3HIIBGfLVRJ9slxtuUI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rvl9YEGOr5AGQg+LqFnm1xN0Hi5s75QWMiLsAO7gkzQw3fNcVa3i0DJXCqWM+7wQj
         kCGw7XHYhF7y7zzui5RwfZAEvxLIltux/8Pfy6kVvUdCYhMZmZ7j7XvCIZEIW+eWy6
         zMTsRPJnFgvJEICM+vMxLtBmycnapSDjTSj6l6x/7/I+QaMYSsj/Fri4e4HqSETgeF
         EoRsiXMOAhUzingDNM0zG+qt9Uwa+viJEGkZj1r1c7RiFJDJk8hn0gpGY7m9Fm5LTd
         tkxVgvTdGIAfaRJrYXk/JhF/fsvMXHpYJFfAMVxCePec00i/AGdzn9grISh7SJqDwv
         L5gMWBGgloYWA==
Date:   Mon, 28 Dec 2020 13:29:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Antoine Tenart <atenart@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net v3 0/4] net-sysfs: fix race conditions in the xps
 code
Message-ID: <20201228132959.5992a794@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAKgT0Ufm74TZc8bq12e8gk4uwBe40t0wZO7LJ5Uh8gXMxFr=wQ@mail.gmail.com>
References: <20201223212323.3603139-1-atenart@kernel.org>
        <CAKgT0Ufm74TZc8bq12e8gk4uwBe40t0wZO7LJ5Uh8gXMxFr=wQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Dec 2020 15:26:08 -0800 Alexander Duyck wrote:
> On Wed, Dec 23, 2020 at 1:23 PM Antoine Tenart <atenart@kernel.org> wrote:
> >
> > Hello all,
> >
> > This series fixes race conditions in the xps code, where out of bound
> > accesses can occur when dev->num_tc is updated, triggering oops. The
> > root cause is linked to locking issues. An explanation is given in each
> > of the commit logs.
> >
> > We had a discussion on the v1 of this series about using the xps_map
> > mutex instead of the rtnl lock. While that seemed a better compromise,
> > v2 showed the added complexity wasn't best for fixes. So we decided to
> > go back to v1 and use the rtnl lock.
> >
> > Because of this, the only differences between v1 and v3 are improvements
> > in the commit messages.
> >
> > Thanks!
> > Antoine
> >
> > Antoine Tenart (4):
> >   net-sysfs: take the rtnl lock when storing xps_cpus
> >   net-sysfs: take the rtnl lock when accessing xps_cpus_map and num_tc
> >   net-sysfs: take the rtnl lock when storing xps_rxqs
> >   net-sysfs: take the rtnl lock when accessing xps_rxqs_map and num_tc
> >
> >  net/core/net-sysfs.c | 65 ++++++++++++++++++++++++++++++++++++--------
> >  1 file changed, 53 insertions(+), 12 deletions(-)
> >  
> 
> The series looks fine to me. Not the prettiest in the case of showing
> the maps, but I don't think much can be done about that since we have
> to return an error type and release the rtnl_lock.
> 
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

Applied, thanks!
