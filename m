Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBCF46B8B8
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 11:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234983AbhLGKYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 05:24:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbhLGKYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 05:24:50 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A871C061746
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 02:21:20 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1muXb3-0008Vi-8d; Tue, 07 Dec 2021 11:21:17 +0100
Date:   Tue, 7 Dec 2021 11:21:17 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        davem@davemloft.net, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev
Subject: Re: [PATCH net-next 03/10] mptcp: add SIOCINQ, OUTQ and OUTQNSD
 ioctls
Message-ID: <20211207102117.GC30918@breakpoint.cc>
References: <20211203223541.69364-1-mathew.j.martineau@linux.intel.com>
 <20211203223541.69364-4-mathew.j.martineau@linux.intel.com>
 <20211206171648.4608911f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206171648.4608911f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
> On Fri,  3 Dec 2021 14:35:34 -0800 Mat Martineau wrote:
> > +		if (sk->sk_state == TCP_LISTEN)
> > +			return -EINVAL;
> > +
> > +		lock_sock(sk);
> > +		__mptcp_move_skbs(msk);
> > +		answ = mptcp_inq_hint(sk);
> > +		release_sock(sk);
> 
> The raciness is not harmful here?

Can you elaborate?  We can't prevent new data
from being queued after this, but it won't decrease
on its own either, i.e. we only guarantee that we have at
least answ bytes for read().
