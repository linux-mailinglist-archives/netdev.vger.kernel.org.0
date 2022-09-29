Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC1E75EFDFF
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 21:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiI2TfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 15:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiI2Te5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 15:34:57 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3FC2CCB5;
        Thu, 29 Sep 2022 12:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/P0dMVsN1isqnLkFGaEvl0LKDg5OiTgpL3SenF9SLsk=; b=ZKv6CT3Lwrga/vMAK0j7qCsgvC
        gfsxGntozXVXzyAB1+joZa2CkMKvguoxQfDHjQXXvgbcB1qKvCR9Jj1GFYo+Gn/vvW+8lcZ64A1p0
        JfS1zRbi+oXFwSyBu/B2frwnhn/d6yUE19jimXr8rpi8Ww3iUsWX7LNC3aR9cB+KtcpSbFbrNc/yz
        jPLr4qHdlXiiI7tBInmXS/gXTnt2oaKpq524VwXVjLrZtlEAsc9Bzo3gEEw3IxajRlB0g3EXtjVWC
        o7UyaXHT+sfRLFqsbTT4QZRMPvstGPMfrYOCPyzo/I3xCOc/6mrSMF+3fWqjv2alM3dJvmiWTSy6f
        sbhAuQXA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
        id 1odzJ6-0054lU-0U;
        Thu, 29 Sep 2022 19:34:52 +0000
Date:   Thu, 29 Sep 2022 20:34:52 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Laight <David.Laight@aculab.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 3/4] proc: Point /proc/net at /proc/thread-self/net
 instead of /proc/self/net
Message-ID: <YzXzXNAgcJeJ3M0d@ZenIV>
References: <dacfc18d6667421d97127451eafe4f29@AcuMS.aculab.com>
 <CAHk-=wgS_XpzEL140ovgLwGv6yXvV7Pu9nKJbCuo5pnRfcEbvg@mail.gmail.com>
 <YzXo/DIwq65ypHNH@ZenIV>
 <YzXrOFpPStEwZH/O@ZenIV>
 <CAHk-=wjLgM06JrS21W4g2VquqCLab+qu_My67cv6xuH7NhgHpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjLgM06JrS21W4g2VquqCLab+qu_My67cv6xuH7NhgHpw@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 12:05:32PM -0700, Linus Torvalds wrote:
> On Thu, Sep 29, 2022 at 12:00 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Which is insane, especially since the entire problem is due to wanting
> > that directory to be different for different threads...
> 
> Absolutely. This is all due to Apparmor (a) basing things on pathnames
> and (b) then getting those pathnames wrong.
> 
> Which is why I'm just suggesting we short-circuit the path-name part,
> and not make this be a real symlink that actually walks a real path.
> 
> The proc <pid> handling uses "readlink" to make it *look* like a
> symlink, but then "get_link" to actually look it up (and never walk it
> as a path).
> 
> Something similar?

Apparmor takes mount+dentry and turns that into pathname.  Then acts
upon the resulting string.  *AFTER* the original had been resolved.
IOW, it doesn't see the symlink contents - only the location where the
entire thing ends up.

AFAICS, the only way to make it STFU is either
	* fix the idiotic policy
or
	* make the per-thread directory show up as /proc/<something>/net

As in "../.. from there lands you in /proc".  Because that's what
apparmor does to generate the string it treats as the pathname...
