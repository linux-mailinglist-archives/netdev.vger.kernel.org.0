Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44ED81163A7
	for <lists+netdev@lfdr.de>; Sun,  8 Dec 2019 20:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbfLHTxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Dec 2019 14:53:42 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39206 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbfLHTxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Dec 2019 14:53:42 -0500
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ie2ce-00081I-Ck; Sun, 08 Dec 2019 19:53:40 +0000
Date:   Sun, 8 Dec 2019 19:53:40 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Vladis Dronov <vdronov@redhat.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: fix use-after-free in __fput() when a chardev is
 removed but a file is still open
Message-ID: <20191208195340.GX4203@ZenIV.linux.org.uk>
References: <20191125125342.6189-1-vdronov@redhat.com>
 <20191208194907.GW4203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191208194907.GW4203@ZenIV.linux.org.uk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 08, 2019 at 07:49:07PM +0000, Al Viro wrote:
> On Mon, Nov 25, 2019 at 01:53:42PM +0100, Vladis Dronov wrote:
> > In a case when a chardev file (like /dev/ptp0) is open but an underlying
> > device is removed, closing this file leads to a use-after-free. This
> > reproduces easily in a KVM virtual machine:
> > 
> > # cat openptp0.c
> > int main() { ... fp = fopen("/dev/ptp0", "r"); ... sleep(10); }
> 
> > static void __fput(struct file *file)
> > {   ...
> >     if (file->f_op->release)
> >         file->f_op->release(inode, file); <<< cdev is kfree'd here
> 
> >     if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL &&
> >              !(mode & FMODE_PATH))) {
> >         cdev_put(inode->i_cdev); <<< cdev fields are accessed here
> > 
> > because of:
> > 
> > __fput()
> >   posix_clock_release()
> >     kref_put(&clk->kref, delete_clock) <<< the last reference
> >       delete_clock()
> >         delete_ptp_clock()
> >           kfree(ptp) <<< cdev is embedded in ptp
> >   cdev_put
> >     module_put(p->owner) <<< *p is kfree'd
> > 
> > The fix is to call cdev_put() before file->f_op->release(). This fix the
> > class of bugs when a chardev device is removed when its file is open, for
> > example:
> 
> And what's to prevent rmmod coming and freeing ->release code right as you
> are executing it?

FWIW, the bug here seems to be that the lifetime rules of cdev are fucked -
if it can get freed while its ->kobj is still alive, we have something
very wrong there.  IOW, you have ptp lifetime controlled by *TWO*
refcounts - that of clk and that of of cdev->kobj.  That's doesn't work.
Replace that kfree() with dropping a kobject reference, perhaps, so
that freeing would've been done by its release callback?
