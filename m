Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF633288582
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 10:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732913AbgJIIqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 04:46:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730726AbgJIIqn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 04:46:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7D79215A4;
        Fri,  9 Oct 2020 08:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602233203;
        bh=wDVSK9lDifu555hYLt/QcE1K+Rrce7ovaPwUry7eR9U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1GvnP2KovqKJ/n9WjwQvNaPfJPHa2OblOoJcaPU1QGZ4dTQlUmdw5ay8S/AUmNIfk
         NBEQEx1BQLZHuBYsHTWVZ37sKUN9P0G1tABbnC+PCnh4gwZP9fA8UF40JTf/bFxORl
         pSkgGCZe6oFXyZUrt+hdSh0bjojvydvgPCQwo7Cs=
Date:   Fri, 9 Oct 2020 10:47:29 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-kernel@vger.kernel.org, nstange@suse.de, ap420073@gmail.com,
        David.Laight@aculab.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, rafael@kernel.org
Subject: Re: [CRAZY-RFF] debugfs: track open files and release on remove
Message-ID: <20201009084729.GA406522@kroah.com>
References: <87v9fkgf4i.fsf@suse.de>
 <20201009095306.0d87c3aa13db.Ib3a7019bff15bb6308f6d259473a1648312a4680@changeid>
 <20201009080355.GA398994@kroah.com>
 <be61c6a38d0f6ca1aa0bc3f0cb45bbb216a12982.camel@sipsolutions.net>
 <20201009081624.GA401030@kroah.com>
 <1ec056cf3ec0953d2d1abaa05e37e89b29c7cc63.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ec056cf3ec0953d2d1abaa05e37e89b29c7cc63.camel@sipsolutions.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 09, 2020 at 10:19:02AM +0200, Johannes Berg wrote:
> On Fri, 2020-10-09 at 10:16 +0200, Greg KH wrote:
> > On Fri, Oct 09, 2020 at 10:06:14AM +0200, Johannes Berg wrote:
> > > We used to say the proxy_fops weren't needed and it wasn't an issue, and
> > > then still implemented it. Dunno. I'm not really too concerned about it
> > > myself, only root can hold the files open and remove modules ...
> > 
> > proxy_fops were needed because devices can be removed from the system at
> > any time, causing their debugfs files to want to also be removed.  It
> > wasn't because of unloading kernel code.
> 
> Indeed, that's true. Still, we lived with it for years.

Because no one wanted to fix the code, not because it was correct :)

> Anyway, like I said, I really just did this more to see that it _could_
> be done, not to suggest that it _should_ :-)

Agreed.

> I think adding the .owner everywhere would be good, and perhaps we can
> somehow put a check somewhere like
> 
> 	WARN_ON(is_module_address((unsigned long)fops) && !fops->owner);
> 
> to prevent the issue in the future?

That will fail for all of the debugfs_create_* operations, as there is
only one set of file operations for all of the different files created
with these calls.

Which, now that I remember it, is why we went down the proxy "solution"
in the first place :(

thanks,

greg k-h
