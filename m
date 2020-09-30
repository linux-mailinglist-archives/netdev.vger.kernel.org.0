Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC7727F22C
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 21:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729780AbgI3TBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 15:01:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbgI3TBc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 15:01:32 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FEF620708;
        Wed, 30 Sep 2020 19:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601492491;
        bh=aQ6wZDgQOdp50CqzZxgsW57FQwyAunlqcDc9DpUHpOM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WAGOVcOULOqglJh62xiXgDIYUX9Mt4cKUyDSMOmv+Acowd/ZOGgjH82iqL8r0Wfxg
         m9UG9d5dCgu2x5DqkkWCOelA7RVU01hZNMhnMzIIS5A35e1n52ythv+Yqa+DQsL1FX
         nMtsi3+WFgm36BqHxeWNKORR9t0hi1i20FW7CNMw=
Date:   Wed, 30 Sep 2020 12:01:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Jiri Pirko <jiri@resnulli.us>, Michal Kubecek <mkubecek@suse.cz>,
        dsahern@kernel.org, pablo@netfilter.org, netdev@vger.kernel.org
Subject: Re: Genetlink per cmd policies
Message-ID: <20200930120129.620a49f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <23b4d301ee35380ac21c898c04baed9643bd3651.camel@sipsolutions.net>
References: <20200930084955.71a8c0ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <fce613c2b4c797de4be413afddf872fd6dae9ef8.camel@sipsolutions.net>
        <a772c03bfbc8cf8230df631fe2db6f2dd7b96a2a.camel@sipsolutions.net>
        <20200930094455.668b6bff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <23b4d301ee35380ac21c898c04baed9643bd3651.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Sep 2020 20:36:24 +0200 Johannes Berg wrote:
> On Wed, 2020-09-30 at 09:44 -0700, Jakub Kicinski wrote:
> 
> > I started with a get_policy() callback, but I didn't like it much.
> > Static data is much more pleasant for a client of the API IMHO.  
> 
> Yeah, true.
> 
> > What do you think about "ops light"? Insufficiently flexible?  
> 
> TBH, I'm not really sure how you'd do it?

There are very few users who actually access ops, I was thinking that
callers to genl_get_cmd() should declare a full struct genl_ops on the
stack (or in some context, not sure yet), and then genl_get_cmd() will
fill it in.

If family has full ops it will do a memcpy(); if the ops are "light" it
can assign the right pointers.

Plus it can propagate the policy and maxattr from family if needed in
both cases.

Don't have the code yet, but shouldnt take long to get a PoC...
