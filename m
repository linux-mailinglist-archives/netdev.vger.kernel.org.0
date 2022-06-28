Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4F9655E751
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346447AbiF1Nng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 09:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346848AbiF1Nnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 09:43:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1151CB09;
        Tue, 28 Jun 2022 06:43:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B55DB81E16;
        Tue, 28 Jun 2022 13:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93634C3411D;
        Tue, 28 Jun 2022 13:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656423806;
        bh=Mu07+NkAeIWQxqDrSfWHBkagAH3qiS5hRkhUS/KEB+8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J26wAUkMEANntFYIvZPSyjRIRDBcF+0CYhgasflX/sFmF3R2jSZgCYNFz3Ynufqqz
         nzeG/jqshDGe3knqrMZ6LXcKAICeN8pbhTN0uX0rgz8dRC1YlEMk7ISAYbSEGNsozr
         vMxbVtI/cVWlsFmtm6PBsVByLIwnivkOj1AJrkxj/wXQRhS/ln9VsFhQnbbn/n2PIn
         QzAw/V4dQkJ41Sn1oOGwbBEr5dwHr6L6ETynGtdZIr8NvIdrA2IOpy2Ggx+LW85NkG
         M7m209vEq9dxSuBiAncmEIgn4Mvu51957qmvXRBAQRo+OwPw3t5gNRgFO+Buf2FD6s
         0aBj8RlvROlWA==
Date:   Tue, 28 Jun 2022 15:43:17 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     Ralph Corderoy <ralph@inputplus.co.uk>,
        Matthew Wilcox <willy@infradead.org>,
        Nate Karstens <nate.karstens@garmin.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
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
        Eric Dumazet <edumazet@google.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH v2] Implement close-on-fork
Message-ID: <20220628134317.heagqm6dplf5vk7u@wittgenstein>
References: <20200515152321.9280-1-nate.karstens@garmin.com>
 <20220618114111.61EC71F981@orac.inputplus.co.uk>
 <Yq4qIxh5QnhQZ0SJ@casper.infradead.org>
 <20220619104228.A9789201F7@orac.inputplus.co.uk>
 <20220628131304.gbiqqxamg6pmvsxf@wittgenstein>
 <35d0facc934748f995c2e7ab695301f7@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <35d0facc934748f995c2e7ab695301f7@AcuMS.aculab.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 01:38:07PM +0000, David Laight wrote:
> From: Christian Brauner
> > Sent: 28 June 2022 14:13
> > 
> > On Sun, Jun 19, 2022 at 11:42:28AM +0100, Ralph Corderoy wrote:
> > > Hi Matthew, thanks for replying.
> > >
> > > > > The need for O_CLOFORK might be made more clear by looking at a
> > > > > long-standing Go issue, i.e. unrelated to system(3), which was started
> > > > > in 2017 by Russ Cox when he summed up the current race-condition
> > > > > behaviour of trying to execve(2) a newly created file:
> > > > > https://github.com/golang/go/issues/22315.
> > > >
> > > > The problem is that people advocating for O_CLOFORK understand its
> > > > value, but not its cost.  Other google employees have a system which
> > > > has literally millions of file descriptors in a single process.
> > > > Having to maintain this extra state per-fd is a cost they don't want
> > > > to pay (and have been quite vocal about earlier in this thread).
> > >
> > > So do you agree the userspace issue is best solved by *_CLOFORK and the
> > > problem is how to implement *_CLOFORK at an acceptable cost?
> > >
> > > OTOH David Laight was making suggestions on moving the load to the
> > > fork/exec path earlier in the thread, but OTOH Al Viro mentioned a
> > > ‘portable solution’, though that could have been to a specific issue
> > > rather than the more general case.
> > >
> > > How would you recommend approaching an acceptable cost is progressed?
> > > Iterate on patch versions?  Open a bugzilla.kernel.org for central
> > > tracking and linking from the other projects?  ..?
> > 
> > Quoting from that go thread
> > 
> > "If the OS had a "close all fds above x", we could use that. (I don't know of any that do, but it sure
> > would help.)"
> > 
> > So why can't this be solved with:
> > close_range(fd_first, fd_last, CLOSE_RANGE_CLOEXEC | CLOSE_RANGE_UNSHARE)?
> > e.g.
> > close_range(100, ~0U, CLOSE_RANGE_CLOEXEC | CLOSE_RANGE_UNSHARE)?
> 
> That is a relatively recent linux system call.
> Although it can be (mostly) emulated by reading /proc/fd
> - but that may not be mounted.
> 
> In any case another thread can open an fd between the close_range()
> and fork() calls.

The CLOSE_RANGE_UNSHARE gives the calling thread a private file
descriptor table before marking fs close-on-exec.

close_range(100, ~0U, CLOSE_RANGE_CLOEXEC | CLOSE_RANGE_UNSHARE)?
