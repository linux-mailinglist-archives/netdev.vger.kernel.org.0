Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD522C9EB5
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 11:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729594AbgLAKFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 05:05:05 -0500
Received: from mx2.suse.de ([195.135.220.15]:43232 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727590AbgLAKFF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 05:05:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 023CDAF57;
        Tue,  1 Dec 2020 10:04:23 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 72B80603BA; Tue,  1 Dec 2020 11:04:22 +0100 (CET)
Date:   Tue, 1 Dec 2020 11:04:22 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Denis Kirjanov <kda@linux-powerpc.org>,
        Al Viro <viro@zeniv.linux.org.uk>, netdev@vger.kernel.org,
        davem@davemloft.net, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2] net/af_unix: don't create a path for a binded socket
Message-ID: <20201201100422.u4ymvdxbzymlkoqu@lion.mk-sys.cz>
References: <20201130132747.29332-1-kda@linux-powerpc.org>
 <20201130173000.60acd3cc@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130173000.60acd3cc@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 05:30:00PM -0800, Jakub Kicinski wrote:
> On Mon, 30 Nov 2020 16:27:47 +0300 Denis Kirjanov wrote:
> > in the case of the socket which is bound to an adress
                                                    ^ address
> > there is no sense to create a path in the next attempts
> > 
> > here is a program that shows the issue:
> > 
> > int main()
> > {
> >     int s;
> >     struct sockaddr_un a;
> > 
> >     s = socket(AF_UNIX, SOCK_STREAM, 0);
> >     if (s<0)
> >         perror("socket() failed\n");
> > 
> >     printf("First bind()\n");
> > 
> >     memset(&a, 0, sizeof(a));
> >     a.sun_family = AF_UNIX;
> >     strncpy(a.sun_path, "/tmp/.first_bind", sizeof(a.sun_path));
> > 
> >     if ((bind(s, (const struct sockaddr*) &a, sizeof(a))) == -1)
> >         perror("bind() failed\n");
> > 
> >     printf("Second bind()\n");
> > 
> >     memset(&a, 0, sizeof(a));
> >     a.sun_family = AF_UNIX;
> >     strncpy(a.sun_path, "/tmp/.first_bind_failed", sizeof(a.sun_path));
> > 
> >     if ((bind(s, (const struct sockaddr*) &a, sizeof(a))) == -1)
> >         perror("bind() failed\n");
> > }
> > 
> > kda@SLES15-SP2:~> ./test
> > First bind()
> > Second bind()
> > bind() failed
> > : Invalid argument
> > 
> > kda@SLES15-SP2:~> ls -la /tmp/.first_bind
> > .first_bind         .first_bind_failed
> > 
> > Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
> > 
> > v2: move a new patch creation after the address assignment check.
                      ^ path

> 
> It is a behavior change, but IDK if anyone can reasonably depend on
> current behavior for anything useful. Otherwise LGTM.

For the record, we already changed the error code in this case once by
commit 0fb44559ffd6 ("af_unix: move unix_mknod() out of bindlock"), this
should revert it to the original value. As far as I'm aware, only LTP
guys noticed back then. I tried to raise the question in this list but
nobody seemed to care so I didn't pursue.

Technically, both errors are correct as both "address already in use"
and "socket already bound" conditions are met and the manual page
(neither linux nor posix) doesn't seem to specify which should take
precedence.

Michal
