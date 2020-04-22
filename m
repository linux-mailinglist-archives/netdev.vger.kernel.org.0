Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF031B4958
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgDVQBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbgDVQBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:01:07 -0400
X-Greylist: delayed 3563 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 22 Apr 2020 09:01:07 PDT
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B466C03C1A9;
        Wed, 22 Apr 2020 09:01:07 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jRHnc-008Yo8-Vd; Wed, 22 Apr 2020 16:00:33 +0000
Date:   Wed, 22 Apr 2020 17:00:32 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Nate Karstens <nate.karstens@garmin.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-parisc@vger.kernel.org,
        sparclinux@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: Re: Implement close-on-fork
Message-ID: <20200422160032.GL23230@ZenIV.linux.org.uk>
References: <20200420071548.62112-1-nate.karstens@garmin.com>
 <20200422150107.GK23230@ZenIV.linux.org.uk>
 <20200422151815.GT5820@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422151815.GT5820@bombadil.infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 08:18:15AM -0700, Matthew Wilcox wrote:
> On Wed, Apr 22, 2020 at 04:01:07PM +0100, Al Viro wrote:
> > On Mon, Apr 20, 2020 at 02:15:44AM -0500, Nate Karstens wrote:
> > > Series of 4 patches to implement close-on-fork. Tests have been
> > > published to https://github.com/nkarstens/ltp/tree/close-on-fork.
> > > 
> > > close-on-fork addresses race conditions in system(), which
> > > (depending on the implementation) is non-atomic in that it
> > > first calls a fork() and then an exec().
> > > 
> > > This functionality was approved by the Austin Common Standards
> > > Revision Group for inclusion in the next revision of the POSIX
> > > standard (see issue 1318 in the Austin Group Defect Tracker).
> > 
> > What exactly the reasons are and why would we want to implement that?
> > 
> > Pardon me, but going by the previous history, "The Austin Group Says It's
> > Good" is more of a source of concern regarding the merits, general sanity
> > and, most of all, good taste of a proposal.
> > 
> > I'm not saying that it's automatically bad, but you'll have to go much
> > deeper into the rationale of that change before your proposal is taken
> > seriously.
> 
> https://www.mail-archive.com/austin-group-l@opengroup.org/msg05324.html
> might be useful

*snort*

Alan Coopersmith in that thread:
|| https://lwn.net/Articles/785430/ suggests AIX, BSD, & MacOS have also defined
|| it, and though it's been proposed multiple times for Linux, never adopted there.

Now, look at the article in question.  You'll see that it should've been
"someone's posting in the end of comments thread under LWN article says that
apparently it exists on AIX, BSD, ..."

The strength of evidence aside, that got me curious; I have checked the
source of FreeBSD, NetBSD and OpenBSD.  No such thing exists in either of
their kernels, so at least that part can be considered an urban legend.

As for the original problem...  what kind of exclusion is used between
the reaction to netlink notifications (including closing every socket,
etc.) and actual IO done on those sockets?

