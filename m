Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2025EFF40
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 23:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiI2V1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 17:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiI2V1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 17:27:23 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8AB140F20;
        Thu, 29 Sep 2022 14:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=K7HkydYtQjNwz29N2ZiCUMTHJkR3b/p2rE+Pb09h/o4=; b=CcSGLj4sMlhvqOt1nNry4YXbLV
        5jUAawuSHfkDPsMHZXyM7tQ1XdWFhbEfsewPxBVdViE7Q/I9Gn0MQoV/fdRmpxgLrLJiGQj1iApIt
        eleBkwN0r3UpZRVYwwn7VB+328R4JzinwjtF45pv8JwwNGaP5mDz3unhJwwoIbf6TMdmEDyea/JmV
        4e3S/jaxfbCtFwp4ugft8Ck256yF6+Yj8WwdbTw6l8QjyAlM+lro0A1YuH6PgaFfbidVS/UNpWwnr
        +hJ0XdhrEbwkkzm9NwOOZQOhfjGcAR1YVv8+5a2OkFOguNyUx7RtWJrMxrIodNXHrNsfDDYe6iUDh
        pZ5uDLXA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1oe13v-00566n-2a;
        Thu, 29 Sep 2022 21:27:19 +0000
Date:   Thu, 29 Sep 2022 22:27:19 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Laight <David.Laight@aculab.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 3/4] proc: Point /proc/net at /proc/thread-self/net
 instead of /proc/self/net
Message-ID: <YzYNtzDPZH1YWflz@ZenIV>
References: <dacfc18d6667421d97127451eafe4f29@AcuMS.aculab.com>
 <CAHk-=wgS_XpzEL140ovgLwGv6yXvV7Pu9nKJbCuo5pnRfcEbvg@mail.gmail.com>
 <YzXo/DIwq65ypHNH@ZenIV>
 <YzXrOFpPStEwZH/O@ZenIV>
 <CAHk-=wjLgM06JrS21W4g2VquqCLab+qu_My67cv6xuH7NhgHpw@mail.gmail.com>
 <YzXzXNAgcJeJ3M0d@ZenIV>
 <CAHk-=wgiBBXeY9ioZ8GtsxAcd42c265zwN7bYVY=cir01OimzA@mail.gmail.com>
 <YzYMQDTAYCCax0WZ@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzYMQDTAYCCax0WZ@ZenIV>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 10:21:04PM +0100, Al Viro wrote:
> On Thu, Sep 29, 2022 at 02:13:57PM -0700, Linus Torvalds wrote:
> > On Thu, Sep 29, 2022 at 12:34 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > Apparmor takes mount+dentry and turns that into pathname.  Then acts
> > > upon the resulting string.  *AFTER* the original had been resolved.
> > 
> > Ok. So it would have to act like a bind mount.
> > 
> > Which is probably not too bad.
> > 
> > In fact, maybe it would be ok for this to act like a hardlink and just
> > fill in the inode - not safe for a filesystem in general due to the
> > whole rename loop issue, but for /proc it might be fine?
> 
> _Which_ hardlink?
> 
> Linus, where in dentry tree would you want it to be seen?  Because
> apparmor profile wants /proc/net/dev to land at /proc/<pid>/net/dev
> and will fail with anything else.
> 
> Do you really want multiple dentries with the same name in the same
> parent, refering to different directory inodes with different contents?
> 
> And that's different inodes with different contents - David's complaint
> is precisely about seeing the same thing for all threads and apparmor
> issue is with *NOT* seeing each of those things at the same location.

Put it another way:

David:
	when I'm opening /proc/net/whatever, I want its contents to match
	this thread's netns, not that of some other thread.
dhclient+apparmor:
	whatever you get from /proc/net/dev, it would better be at
	/proc/<pid>/net/dev, no matter which thread you happen to be.

It's not that we want to see the same thing in several places; it's that
we want to see *different* things in the same place.  Opposite to what
hardlinks or bindings would be about.
