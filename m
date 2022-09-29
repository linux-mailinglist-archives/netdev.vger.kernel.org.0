Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3245EFF26
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 23:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiI2VPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 17:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiI2VPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 17:15:32 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02565E326;
        Thu, 29 Sep 2022 14:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BHyZXwz0JpdIs839aZuS4LVragG1ByLHmjarMItcZwU=; b=KOsF3K4ixph6tVuWA1nGXJ4JN1
        oreveL4oBOsfZ98hMXtlgpTWlYRQe9nZF4IIdbUuFc9aCHiQUub43l4guA73tEr5akI0p18O9OVzj
        xMpTcRpd9MwJwxdvcte9eL6rzE0iTh5Xtnn2Rh5ibQRD2m1e3MTPh5G0ZYSwleCdR0Sjk8GXhIlAj
        NgDuDttPXT5627G6g+6CiEOglO8MpPBbWFvro2WIl8uyjuX6/IgLADZWgt50g/csDCZgmL+oSaiSJ
        /6GYHWste/6KiaQ24RbUp4x76FhGjhbJDDORF7tHyIXIJQaHNDzVyO8q0smSnO7XJcmhya7EAQ/yE
        LcWu3AXg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1oe0sQ-0055y5-2H;
        Thu, 29 Sep 2022 21:15:27 +0000
Date:   Thu, 29 Sep 2022 22:15:26 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Laight <David.Laight@aculab.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 3/4] proc: Point /proc/net at /proc/thread-self/net
 instead of /proc/self/net
Message-ID: <YzYK7k3tgZy3Pwht@ZenIV>
References: <dacfc18d6667421d97127451eafe4f29@AcuMS.aculab.com>
 <CAHk-=wgS_XpzEL140ovgLwGv6yXvV7Pu9nKJbCuo5pnRfcEbvg@mail.gmail.com>
 <YzXo/DIwq65ypHNH@ZenIV>
 <YzXrOFpPStEwZH/O@ZenIV>
 <CAHk-=wjLgM06JrS21W4g2VquqCLab+qu_My67cv6xuH7NhgHpw@mail.gmail.com>
 <YzXzXNAgcJeJ3M0d@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzXzXNAgcJeJ3M0d@ZenIV>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 08:34:52PM +0100, Al Viro wrote:
> On Thu, Sep 29, 2022 at 12:05:32PM -0700, Linus Torvalds wrote:
> > On Thu, Sep 29, 2022 at 12:00 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > Which is insane, especially since the entire problem is due to wanting
> > > that directory to be different for different threads...
> > 
> > Absolutely. This is all due to Apparmor (a) basing things on pathnames
> > and (b) then getting those pathnames wrong.
> > 
> > Which is why I'm just suggesting we short-circuit the path-name part,
> > and not make this be a real symlink that actually walks a real path.
> > 
> > The proc <pid> handling uses "readlink" to make it *look* like a
> > symlink, but then "get_link" to actually look it up (and never walk it
> > as a path).
> > 
> > Something similar?
> 
> Apparmor takes mount+dentry and turns that into pathname.  Then acts
> upon the resulting string.  *AFTER* the original had been resolved.
> IOW, it doesn't see the symlink contents - only the location where the
> entire thing ends up.
> 
> AFAICS, the only way to make it STFU is either
> 	* fix the idiotic policy
> or
> 	* make the per-thread directory show up as /proc/<something>/net
> 
> As in "../.. from there lands you in /proc".  Because that's what
> apparmor does to generate the string it treats as the pathname...

FWIW, what e.g. debian profile for dhclient has is
  @{PROC}/@{pid}/net/dev      r,

Note that it's not
  @{PROC}/net/dev      r,

precisely because the rules are applied after the pathname got resolved.
*IF* we want that rule to allow opening /proc/net/dev, we'd better have
it yield a dentry in procfs that would have "dev" as ->d_name, with
its parent having "net" as ->d_name and its grandparent being the child
of procfs root with ->d_name containing decimal representation of PID.

Worse, original poster in _this_ thread wants the same /proc/net/dev to
to yield different files for different threads belonging to the same
process and we'd need _all_ of them to have identical chain of ->d_name
occuring on the way to root.
