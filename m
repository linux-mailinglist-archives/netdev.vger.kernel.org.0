Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896BB289FA5
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 11:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgJJJuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 05:50:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgJJJtf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Oct 2020 05:49:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C811206D4;
        Sat, 10 Oct 2020 09:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602322660;
        bh=qEv/8rJuvBzSsznkGBS33zRs2V4OUf+87LXb5YdX2+I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dtZ9I9J0vKwRPkDwHW8WBmWGDTM10AY88wBp3bLQBuvUHQRud+qp5DiL/ceFF3ejE
         3t7EPsC9kSZrsPO4mLwzAZTLmL8lRTvvvL3XCoWcyWWjN6hT3DuccOjsbqg7DAZPv0
         DSvR4/Tzh8rM1ajkCHEPzQzfwI5evgrJY9vwENbU=
Date:   Sat, 10 Oct 2020 11:38:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-kernel@vger.kernel.org, nstange@suse.de, ap420073@gmail.com,
        David.Laight@aculab.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, rafael@kernel.org
Subject: Re: [CRAZY-RFF] debugfs: track open files and release on remove
Message-ID: <20201010093824.GA986556@kroah.com>
References: <87v9fkgf4i.fsf@suse.de>
 <20201009095306.0d87c3aa13db.Ib3a7019bff15bb6308f6d259473a1648312a4680@changeid>
 <20201009080355.GA398994@kroah.com>
 <be61c6a38d0f6ca1aa0bc3f0cb45bbb216a12982.camel@sipsolutions.net>
 <20201009081624.GA401030@kroah.com>
 <1ec056cf3ec0953d2d1abaa05e37e89b29c7cc63.camel@sipsolutions.net>
 <20201009084729.GA406522@kroah.com>
 <01fcaf4985f57d97ac03fc0b7deb2c225a2fbca1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01fcaf4985f57d97ac03fc0b7deb2c225a2fbca1.camel@sipsolutions.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 09, 2020 at 10:48:09AM +0200, Johannes Berg wrote:
> On Fri, 2020-10-09 at 10:47 +0200, Greg KH wrote:
> 
> > > I think adding the .owner everywhere would be good, and perhaps we can
> > > somehow put a check somewhere like
> > > 
> > > 	WARN_ON(is_module_address((unsigned long)fops) && !fops->owner);
> > > 
> > > to prevent the issue in the future?
> > 
> > That will fail for all of the debugfs_create_* operations, as there is
> > only one set of file operations for all of the different files created
> > with these calls.
> 
> Why would it fail? Those have their fops in the core debugfs code, which
> might have a .owner assigned but is probably built-in anyway?

Bad choice of terms, it would "fail" in that this type of check would
never actually work because the debugfs code is built into the kernel,
and there is no module owner for it.  But the value it is referencing is
an address in a module.

> > Which, now that I remember it, is why we went down the proxy "solution"
> > in the first place :(
> 
> Not sure I understand. That was related more to (arbitrary) files having
> to be disappeared rather than anything else?

Isn't this the same issue?

thanks,

greg k-h
