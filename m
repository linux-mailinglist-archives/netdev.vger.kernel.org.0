Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEEFC396E89
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 10:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233343AbhFAIIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 04:08:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233162AbhFAIIl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 04:08:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ECF86136E;
        Tue,  1 Jun 2021 08:06:57 +0000 (UTC)
Date:   Tue, 1 Jun 2021 10:06:54 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Changbin Du <changbin.du@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>
Subject: Re: [PATCH] nsfs: fix oops when ns->ops is not provided
Message-ID: <20210601080654.cl7caplm7rsagl6u@wittgenstein>
References: <20210531153410.93150-1-changbin.du@gmail.com>
 <20210531220128.26c0cb36@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210531220128.26c0cb36@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 31, 2021 at 10:01:28PM -0700, Jakub Kicinski wrote:
> On Mon, 31 May 2021 23:34:10 +0800 Changbin Du wrote:
> > We should not create inode for disabled namespace. A disabled namespace
> > sets its ns->ops to NULL. Kernel could panic if we try to create a inode
> > for such namespace.
> > 
> > Here is an example oops in socket ioctl cmd SIOCGSKNS when NET_NS is
> > disabled. Kernel panicked wherever nsfs trys to access ns->ops since the
> > proc_ns_operations is not implemented in this case.
> > 
> > [7.670023] Unable to handle kernel NULL pointer dereference at virtual address 00000010
> > [7.670268] pgd = 32b54000
> > [7.670544] [00000010] *pgd=00000000
> > [7.671861] Internal error: Oops: 5 [#1] SMP ARM
> > [7.672315] Modules linked in:
> > [7.672918] CPU: 0 PID: 1 Comm: systemd Not tainted 5.13.0-rc3-00375-g6799d4f2da49 #16
> > [7.673309] Hardware name: Generic DT based system
> > [7.673642] PC is at nsfs_evict+0x24/0x30
> > [7.674486] LR is at clear_inode+0x20/0x9c
> > 
> > So let's reject such request for disabled namespace.
> > 
> > Signed-off-by: Changbin Du <changbin.du@gmail.com>
> > Cc: <stable@vger.kernel.org>
> > Cc: Cong Wang <xiyou.wangcong@gmail.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: David Laight <David.Laight@ACULAB.COM>
> > ---
> >  fs/nsfs.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/fs/nsfs.c b/fs/nsfs.c
> > index 800c1d0eb0d0..6c055eb7757b 100644
> > --- a/fs/nsfs.c
> > +++ b/fs/nsfs.c
> > @@ -62,6 +62,10 @@ static int __ns_get_path(struct path *path, struct ns_common *ns)
> >  	struct inode *inode;
> >  	unsigned long d;
> >  
> > +	/* In case the namespace is not actually enabled. */
> > +	if (!ns->ops)
> > +		return -EOPNOTSUPP;
> > +
> >  	rcu_read_lock();
> >  	d = atomic_long_read(&ns->stashed);
> >  	if (!d)
> 
> I'm not sure why we'd pick runtime checks for something that can be
> perfectly easily solved at compilation time. Networking should not
> be asking for FDs for objects which don't exist.

Agreed!
This should be fixable by sm like:

diff --git a/net/socket.c b/net/socket.c
index 27e3e7d53f8e..2484466d96ad 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1150,10 +1150,12 @@ static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
                        break;
                case SIOCGSKNS:
                        err = -EPERM;
+#ifdef CONFIG_NET_NS
                        if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
                                break;

                        err = open_related_ns(&net->ns, get_net_ns);
+#endif
                        break;
                case SIOCGSTAMP_OLD:
                case SIOCGSTAMPNS_OLD:
