Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF8D27EF89
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731299AbgI3Qo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:44:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3Qo5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 12:44:57 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06F0D20759;
        Wed, 30 Sep 2020 16:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601484297;
        bh=l3N8ZMsIjdKMTQUpUGtdQwRQR4KG7boM3eIserBJi/U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RcolUQM0d7+r6oE0gXTiEdiGhGgkjoNWLKChpD1JWZmt/WNo/kPJ488u2syHfq/Xp
         ZKd5dONXXtfDFF+/wixd0oH12usGlb5soDGvdLZSy5nKZE1Yr+JHB2aY5aNGC7rB4w
         Pr6/STTHCTUkrf9f5u612Gf6rQIzdj51VQ4kLpQU=
Date:   Wed, 30 Sep 2020 09:44:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Jiri Pirko <jiri@resnulli.us>, Michal Kubecek <mkubecek@suse.cz>,
        dsahern@kernel.org, pablo@netfilter.org, netdev@vger.kernel.org
Subject: Re: Genetlink per cmd policies
Message-ID: <20200930094455.668b6bff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a772c03bfbc8cf8230df631fe2db6f2dd7b96a2a.camel@sipsolutions.net>
References: <20200930084955.71a8c0ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <fce613c2b4c797de4be413afddf872fd6dae9ef8.camel@sipsolutions.net>
        <a772c03bfbc8cf8230df631fe2db6f2dd7b96a2a.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Sep 2020 18:17:47 +0200 Johannes Berg wrote:
> On Wed, 2020-09-30 at 18:06 +0200, Johannes Berg wrote:
> > 
> > That's the historic info I guess - I'll take a look at ethtool later and
> > see what it's doing there.  
> 
> Oh, ok, I see how that works ... you *do* have a sort of common/aliased
> attribute inside each per-op family that then carries common sub-
> attributes. That can be linked into the policy.
> 
> I guess that's not a bad idea. I'd still prefer not to add
> maxattr/policy into the ops struct because like I said, that's a large
> amount of wasted space?
> 
> Perhaps then a "struct nla_policy *get_policy(int cmd, int *maxattr)"
> function (method) could work, and fall back to just "->policy" and"-
> >maxattr" if unset, and then you'd just have to write a few lines of  
> code for this case? Seems like overall that'd still be smaller than
> putting the pointer/maxattr into each and every op struct.

I started with a get_policy() callback, but I didn't like it much.
Static data is much more pleasant for a client of the API IMHO.

What do you think about "ops light"? Insufficiently flexible?
