Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1863D1B49FD
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgDVQOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbgDVQOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:14:00 -0400
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [IPv6:2002:c35c:fd02::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 040F6C03C1A9;
        Wed, 22 Apr 2020 09:14:00 -0700 (PDT)
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jRI0N-008ZHc-IT; Wed, 22 Apr 2020 16:13:43 +0000
Date:   Wed, 22 Apr 2020 17:13:43 +0100
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
Message-ID: <20200422161343.GM23230@ZenIV.linux.org.uk>
References: <20200420071548.62112-1-nate.karstens@garmin.com>
 <20200422150107.GK23230@ZenIV.linux.org.uk>
 <20200422151815.GT5820@bombadil.infradead.org>
 <20200422160032.GL23230@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422160032.GL23230@ZenIV.linux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 05:00:32PM +0100, Al Viro wrote:

> *snort*
> 
> Alan Coopersmith in that thread:
> || https://lwn.net/Articles/785430/ suggests AIX, BSD, & MacOS have also defined
> || it, and though it's been proposed multiple times for Linux, never adopted there.
> 
> Now, look at the article in question.  You'll see that it should've been
> "someone's posting in the end of comments thread under LWN article says that
> apparently it exists on AIX, BSD, ..."
> 
> The strength of evidence aside, that got me curious; I have checked the
> source of FreeBSD, NetBSD and OpenBSD.  No such thing exists in either of
> their kernels, so at least that part can be considered an urban legend.
> 
> As for the original problem...  what kind of exclusion is used between
> the reaction to netlink notifications (including closing every socket,
> etc.) and actual IO done on those sockets?

Not an idle question, BTW - unlike Solaris we do NOT (and will not) have
close(2) abort IO on the same descriptor from another thread.  So if one
thread sits in recvmsg(2) while another does close(2), the socket will
*NOT* actually shut down until recvmsg(2) returns.
