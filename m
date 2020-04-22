Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65D541B48B7
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 17:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbgDVPe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 11:34:27 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58402 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726168AbgDVPe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 11:34:26 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 866D28EE19C;
        Wed, 22 Apr 2020 08:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1587569665;
        bh=4bdRD2Z19rQrjwriVaW9PfQmwVjc28+BZsVMjx2i8Hk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PrBv5i4NvrpBA8AnNmMReE20QVPztGgU72CBFUaFrCQwXLXAakN10ArYvrWADzCSw
         QcdGixmbSsellgvadaVGHAzYzyWNt7zGbMmXQpqSWYreMpWX8xxNwdvAYx/Tv3Haiu
         5ZEQOlOR8iN4ViK1CPUhgCFIKaUrMO28SCsZL7MA=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id we20aduEjjM5; Wed, 22 Apr 2020 08:34:25 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 55FC88EE0CE;
        Wed, 22 Apr 2020 08:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1587569665;
        bh=4bdRD2Z19rQrjwriVaW9PfQmwVjc28+BZsVMjx2i8Hk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PrBv5i4NvrpBA8AnNmMReE20QVPztGgU72CBFUaFrCQwXLXAakN10ArYvrWADzCSw
         QcdGixmbSsellgvadaVGHAzYzyWNt7zGbMmXQpqSWYreMpWX8xxNwdvAYx/Tv3Haiu
         5ZEQOlOR8iN4ViK1CPUhgCFIKaUrMO28SCsZL7MA=
Message-ID: <1587569663.3485.18.camel@HansenPartnership.com>
Subject: Re: Implement close-on-fork
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc:     Nate Karstens <nate.karstens@garmin.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Helge Deller <deller@gmx.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-parisc@vger.kernel.org,
        sparclinux@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Date:   Wed, 22 Apr 2020 08:34:23 -0700
In-Reply-To: <20200422151815.GT5820@bombadil.infradead.org>
References: <20200420071548.62112-1-nate.karstens@garmin.com>
         <20200422150107.GK23230@ZenIV.linux.org.uk>
         <20200422151815.GT5820@bombadil.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-04-22 at 08:18 -0700, Matthew Wilcox wrote:
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
> > What exactly the reasons are and why would we want to implement
> > that?
> > 
> > Pardon me, but going by the previous history, "The Austin Group
> > Says It's Good" is more of a source of concern regarding the
> > merits, general sanity and, most of all, good taste of a proposal.
> > 
> > I'm not saying that it's automatically bad, but you'll have to go
> > much deeper into the rationale of that change before your proposal
> > is taken seriously.
> 
> https://www.mail-archive.com/austin-group-l@opengroup.org/msg05324.ht
> ml
> might be useful

So the problem is an application is written in such a way that the time
window after it forks and before it execs can cause a file descriptor
based resource to be held when the application state thinks it should
have been released because of a mismatch in the expected use count?

Might it not be easier to rewrite the application for this problem
rather than the kernel?  Especially as the best justification in the
entire thread seems to be "because solaris had it".

James

