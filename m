Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFC746B8B0
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 11:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234816AbhLGKW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 05:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhLGKW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 05:22:57 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A933C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 02:19:27 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1muXZA-0008Uj-5U; Tue, 07 Dec 2021 11:19:20 +0100
Date:   Tue, 7 Dec 2021 11:19:20 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        netdev@vger.kernel.org, Maxim Galaganov <max@internet.ru>,
        davem@davemloft.net, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 10/10] mptcp: support TCP_CORK and TCP_NODELAY
Message-ID: <20211207101920.GB30918@breakpoint.cc>
References: <20211203223541.69364-1-mathew.j.martineau@linux.intel.com>
 <20211203223541.69364-11-mathew.j.martineau@linux.intel.com>
 <20211206173023.72aca8f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206173023.72aca8f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
> On Fri,  3 Dec 2021 14:35:41 -0800 Mat Martineau wrote:
> > +static int mptcp_setsockopt_sol_tcp_nodelay(struct mptcp_sock *msk, sockptr_t optval,
> > +					    unsigned int optlen)
> > +{
> > +	struct mptcp_subflow_context *subflow;
> > +	struct sock *sk = (struct sock *)msk;
> > +	int val;
> > +
> > +	if (optlen < sizeof(int))
> > +		return -EINVAL;
> > +
> > +	if (copy_from_sockptr(&val, optval, sizeof(val)))
> > +		return -EFAULT;
> 
> Should we check that optval is not larger than sizeof(int) or if it is
> that the rest of the buffer is zero? Or for the old school options we
> should stick to the old school behavior?

My intent was to stick to tcp behaviour, i.e. no check on > sizeof(int)
or on "extra buffer" content.
