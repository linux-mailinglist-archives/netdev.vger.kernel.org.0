Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DD02AA081
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgKFWqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:46:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:48568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728408AbgKFWqT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:46:19 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EDDA2087E;
        Fri,  6 Nov 2020 22:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604702778;
        bh=i44Y1P6laXQjWocSVI8b/5WYJYlsz/UZcBJas/yMZ2o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vth4ShWnNCxOWPEYFhf2r43v524rF425f5RaFDqL1jI6vPTRji6+99tlSgsuppDdN
         /lZ1qgzzWP8y94lmybwD/UTorsvVJCGuEZ0G1FglkDHJv32wAsSaxM+fAQSOGBfVlZ
         zOzeyCqGfqnU5vD5rlKtU6Yp2v6YjJGLAoAHeUiI=
Date:   Fri, 6 Nov 2020 14:46:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@infradead.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 0/4] remove compat_alloc_user_space()
Message-ID: <20201106144616.28d074a6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAK8P3a0soc41M-s0nd9xQgztyVCHNy8VJpQ9jmzi-N0Z0rGfRQ@mail.gmail.com>
References: <20201106173231.3031349-1-arnd@kernel.org>
        <CAK8P3a0soc41M-s0nd9xQgztyVCHNy8VJpQ9jmzi-N0Z0rGfRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Nov 2020 22:48:18 +0100 Arnd Bergmann wrote:
> On Fri, Nov 6, 2020 at 6:32 PM Arnd Bergmann <arnd@kernel.org> wrote:
> >
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > This is the third version of my seires, now spanning four patches
> > instead of two, with a new approach for handling struct ifreq
> > compatibility after I realized that my earlier approach introduces
> > additional problems.
> >
> > The idea here is to always push down the compat conversion
> > deeper into the call stack: rather than pretending to be
> > native mode with a modified copy of the original data on
> > the user space stack, have the code that actually works on
> > the data understand the difference between native and compat
> > versions.
> >
> > I have spent a long time looking at all drivers that implement
> > an ndo_do_ioctl callback to verify that my assumptions are
> > correct. This has led to a series of 29 additional patches
> > that I am not including here but will post separately, fixing
> > a number of bugs in SIOCDEVPRIVATE ioctls, removing dead
> > code, and splitting ndo_do_ioctl into two new ndo callbacks
> > for private and ethernet specific commands.  
> 
> I got a reply from the build bots that the version I sent was broken
> on 32-bit machines, so don't merge it just yet. Let me know if
> there are any other comments I should address before resending
> though.

Looks like patch 4 also breaks 64 bit allmodconfig build.

Beyond that - patches 1 and 4 warrant need a second look at:

	checkpatch.pl --strict --min-conf-desc-length=80
