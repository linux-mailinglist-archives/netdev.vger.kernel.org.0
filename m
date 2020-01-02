Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5C1912EB84
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 22:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgABVsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 16:48:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:58760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbgABVsW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jan 2020 16:48:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17DDD20863;
        Thu,  2 Jan 2020 21:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578001701;
        bh=2WXjLqQbps2a6F38F9m9ASGc4E7E4qO9KBQB0pZiS/s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ChnEJTAvI7DSzADhF4xt8jED3CPXr3vS4YW3KPb+PiK/qm9oKKW7Rer8Cq/42UYwo
         XnuAhVqELmoj3plWmKpRtqMrzCQWsLyvDmUcw4repVTJU+4yncndX/v4YWVLYRFa5v
         8EqDycQLYCLokgf9eMd7Bzpt2ELML+SwC5TEpI5s=
Date:   Thu, 2 Jan 2020 22:48:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Firo Yang <firo.yang@suse.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        rcu@vger.kernel.org, netdev@vger.kernel.org,
        lkft-triage@lists.linaro.org,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: [PATCH stable-4.19] tcp/dccp: fix possible race
 __inet_lookup_established()
Message-ID: <20200102214819.GA745235@kroah.com>
References: <CA+G9fYv3=oJSFodFp4wwF7G7_g5FWYRYbc4F0AMU6jyfLT689A@mail.gmail.com>
 <20200102212844.0D734E0095@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102212844.0D734E0095@unicorn.suse.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 02, 2020 at 10:28:44PM +0100, Michal Kubecek wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> [ Upstream commit 8dbd76e79a16b45b2ccb01d2f2e08dbf64e71e40 ]
> 
> Michal Kubecek and Firo Yang did a very nice analysis of crashes
> happening in __inet_lookup_established().
> 
> Since a TCP socket can go from TCP_ESTABLISH to TCP_LISTEN
> (via a close()/socket()/listen() cycle) without a RCU grace period,
> I should not have changed listeners linkage in their hash table.
> 
> They must use the nulls protocol (Documentation/RCU/rculist_nulls.txt),
> so that a lookup can detect a socket in a hash list was moved in
> another one.
> 
> Since we added code in commit d296ba60d8e2 ("soreuseport: Resolve
> merge conflict for v4/v6 ordering fix"), we have to add
> hlist_nulls_add_tail_rcu() helper.
> 
> stable-4.19: we also need to update code in __inet_lookup_listener() and
> inet6_lookup_listener() which has been removed in 5.0-rc1.
> 
> Fixes: 3b24d854cb35 ("tcp/dccp: do not touch listener sk_refcnt under synflood")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Michal Kubecek <mkubecek@suse.cz>
> Reported-by: Firo Yang <firo.yang@suse.com>
> Reviewed-by: Michal Kubecek <mkubecek@suse.cz>
> Link: https://lore.kernel.org/netdev/20191120083919.GH27852@unicorn.suse.cz/
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Thanks for the updated patches, all now queued up.

greg k-h
