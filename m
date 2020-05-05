Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753851C630D
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 23:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgEEV26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 17:28:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727785AbgEEV26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 17:28:58 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BF4F206A5;
        Tue,  5 May 2020 21:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588714137;
        bh=5/BTjp/n0KQrA6IRrVk66kijzLqf9GSaanDpQXL2EO0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MjEIEuhhyNNEVHWW4xHpfU7lqsKN2+Tle857n5AIo9+DH7thr9GIMnSD871SeFeai
         DQOOWX1Jw5K9JpBS7yReB8HDdMy5UlMzSk0OmVBQXXc0kSKC3hUzH6QBIAt4qLPboo
         GcRAv801idqEn3fmDBPIySvxMT/p4dAOOLagec6o=
Date:   Tue, 5 May 2020 14:28:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>
Subject: Re: [PATCH net-next 10/11] s390/qeth: allow reset via ethtool
Message-ID: <20200505142855.24b7c1bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <6788c6f1-52cb-c421-7251-500a391bb48b@linux.ibm.com>
References: <20200505162559.14138-1-jwi@linux.ibm.com>
        <20200505162559.14138-11-jwi@linux.ibm.com>
        <20200505102149.1fd5b9ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a19ccf27-2280-036c-057f-8e6d2319bb28@linux.ibm.com>
        <20200505112940.6fe70918@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <6788c6f1-52cb-c421-7251-500a391bb48b@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 May 2020 21:57:43 +0200 Julian Wiedmann wrote:
> > This is the comment from the uAPI header:
> > 
> > /* The reset() operation must clear the flags for the components which
> >  * were actually reset.  On successful return, the flags indicate the
> >  * components which were not reset, either because they do not exist
> >  * in the hardware or because they cannot be reset independently.  The
> >  * driver must never reset any components that were not requested.
> >  */
> > 
> > Now let's take ETH_RESET_PHY as an example. Surely you're not resetting
> > any PHY here, so that bit should not be cleared. Please look at the
> > bits and select the ones which make sense, add whatever is missing.
> >   
> 
> It's a virtual device, _none_ of them make much sense?! We better not be
> resetting any actual HW components, the other interfaces on the same
> adapter would be quite unhappy about that.

Well, then, you can't use the API in its current form. You can't say
none of the sub-options are applicable, but the sum of them does.

> Sorry for being dense, and I appreciate that the API leaves a lot of room
> for sophisticated partial resets where the driver/HW allows it.
> But it sounds like what you're suggesting is
> (1) we select a rather arbitrary set of components that _might_ represent a
>     full "virtual" reset, and then
> (2) expect the user to guess a super-set of these features. And not worry
>     when they selected too much, and this obscure PHY thing failed to reset.

No, please see the code I provided below, and read how the interface 
is supposed to work. I posted the code comment in my previous reply. 
I don't know what else I can do for you.

User can still pass "all" but you can't _clear_ all bits, 'cause you
didn't reset any PHY, MAC, etc.

> So I looked at gve's implementation and thought "yep, looks simple enough".

Ugh, yeah, gve is not a good example.

> But if we start asking users to interpret HW bits that hardly make any
> sense to them, we're worse off than with the existing custom sysfs trigger...

Actually - operationally, how do you expect people to use this reset?
Some user space system detects the NIC is in a bad state? Does the
interface communicate that via some log messages or such?

The commit message doesn't really explain the "why".

> > Then my suggestion would be something like:
> > 
> >   #define QETH_RESET_FLAGS (flag | flag | flag)
> > 
> >   if ((*flags & QETH_RESET_FLAGS) != QETH_RESET_FLAGS))
> > 	return -EINVAL;
> >   ...
> >   *flags &= ~QETH_RESET_FLAGS;
