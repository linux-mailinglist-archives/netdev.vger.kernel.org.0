Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEB1828A3BE
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731594AbgJJW4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731534AbgJJTyP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:54:15 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B84C0613A7;
        Sat, 10 Oct 2020 03:47:27 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kRCPK-002qrG-NC; Sat, 10 Oct 2020 12:47:22 +0200
Message-ID: <dd78ce5ae126de24a1e24c4e410f3ded69b8bc6a.camel@sipsolutions.net>
Subject: Re: [CRAZY-RFF] debugfs: track open files and release on remove
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, nstange@suse.de, ap420073@gmail.com,
        David.Laight@aculab.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, rafael@kernel.org
Date:   Sat, 10 Oct 2020 12:47:21 +0200
In-Reply-To: <20201010093824.GA986556@kroah.com>
References: <87v9fkgf4i.fsf@suse.de>
         <20201009095306.0d87c3aa13db.Ib3a7019bff15bb6308f6d259473a1648312a4680@changeid>
         <20201009080355.GA398994@kroah.com>
         <be61c6a38d0f6ca1aa0bc3f0cb45bbb216a12982.camel@sipsolutions.net>
         <20201009081624.GA401030@kroah.com>
         <1ec056cf3ec0953d2d1abaa05e37e89b29c7cc63.camel@sipsolutions.net>
         <20201009084729.GA406522@kroah.com>
         <01fcaf4985f57d97ac03fc0b7deb2c225a2fbca1.camel@sipsolutions.net>
         <20201010093824.GA986556@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-10-10 at 11:38 +0200, Greg KH wrote:
> On Fri, Oct 09, 2020 at 10:48:09AM +0200, Johannes Berg wrote:
> > On Fri, 2020-10-09 at 10:47 +0200, Greg KH wrote:
> > 
> > > > I think adding the .owner everywhere would be good, and perhaps we can
> > > > somehow put a check somewhere like
> > > > 
> > > > 	WARN_ON(is_module_address((unsigned long)fops) && !fops->owner);
> > > > 
> > > > to prevent the issue in the future?
> > > 
> > > That will fail for all of the debugfs_create_* operations, as there is
> > > only one set of file operations for all of the different files created
> > > with these calls.
> > 
> > Why would it fail? Those have their fops in the core debugfs code, which
> > might have a .owner assigned but is probably built-in anyway?
> 
> Bad choice of terms, it would "fail" in that this type of check would
> never actually work because the debugfs code is built into the kernel,
> and there is no module owner for it.  But the value it is referencing is
> an address in a module.

Ahh.

Yes and no. I mean, yes, the check wouldn't really work.

But OTOH, this is exactly what the proxy_fops protects against.

The _only_ thing that proxy_fops *doesn't* proxy is the ->release()
method.

If you have a debugfs file that's say debugfs_create_u32(), then the
code is all built into the kernel, and - if ->release() even exists, I
didn't check now - it would surely not dereference the pointer you gave
to debugfs_create_u32(). So as long as the file is debugfs_remove()d
before the pointer becomes invalid, there's no issue.

The check I'm proposing (and actually wrote in my separate RFC patch
that didn't seem quite as crazy) would basically protect the ->release()
method only, if needed. Everything else is handled by proxy_fops.

> > > Which, now that I remember it, is why we went down the proxy "solution"
> > > in the first place :(
> > 
> > Not sure I understand. That was related more to (arbitrary) files having
> > to be disappeared rather than anything else?
> 
> Isn't this the same issue?

Well, not exactly? The difference is that proxy_fops basically protects
the *value*, read/write/etc., but not ->release(). So it protects more
against bus unbind or the like, where the *device* disappears, rather
than the *code* disappearing.

Now, you still need to be careful that ->release() doesn't actually
access anything related to the device, of course. As long as we don't
have a general revoke() at least.

I guess in that sense this crazy patch actually makes things *better*
than the RFC patch because it *does* call the ->release() during
debugfs_remove() and therefore allows even ->release() to access data of
the device or other data structures that are being removed; whereas the
RFC patch I also sent doesn't protect that, it just protects the code
itself.

johannes

