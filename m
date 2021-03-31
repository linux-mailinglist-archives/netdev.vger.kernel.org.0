Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412C234FCCB
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 11:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234541AbhCaJ3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 05:29:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234543AbhCaJ2e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 05:28:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45C62619AB;
        Wed, 31 Mar 2021 09:28:29 +0000 (UTC)
Date:   Wed, 31 Mar 2021 11:28:26 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Xie Yongji <xieyongji@bytedance.com>, hch@infradead.org,
        mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6 01/10] file: Export receive_fd() to modules
Message-ID: <20210331092826.giypig5zirgy7cig@wittgenstein>
References: <20210331080519.172-1-xieyongji@bytedance.com>
 <20210331080519.172-2-xieyongji@bytedance.com>
 <20210331091545.lr572rwpyvrnji3w@wittgenstein>
 <20210331092624.GI2088@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210331092624.GI2088@kadam>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 12:26:24PM +0300, Dan Carpenter wrote:
> On Wed, Mar 31, 2021 at 11:15:45AM +0200, Christian Brauner wrote:
> > On Wed, Mar 31, 2021 at 04:05:10PM +0800, Xie Yongji wrote:
> > > Export receive_fd() so that some modules can use
> > > it to pass file descriptor between processes without
> > > missing any security stuffs.
> > > 
> > > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > > ---
> > 
> > Yeah, as I said in the other mail I'd be comfortable with exposing just
> > this variant of the helper.
> > Maybe this should be a separate patch bundled together with Christoph's
> > patch to split parts of receive_fd() into a separate helper.
> > This would also allow us to simplify a few other codepaths in drivers as
> > well btw. I just took a hasty stab at two of them:
> > 
> > diff --git a/drivers/android/binder.c b/drivers/android/binder.c
> > index c119736ca56a..3c716bf6d84b 100644
> > --- a/drivers/android/binder.c
> > +++ b/drivers/android/binder.c
> > @@ -3728,8 +3728,9 @@ static int binder_apply_fd_fixups(struct binder_proc *proc,
> >         int ret = 0;
> > 
> >         list_for_each_entry(fixup, &t->fd_fixups, fixup_entry) {
> > -               int fd = get_unused_fd_flags(O_CLOEXEC);
> > +               int fd = receive_fd(fixup->file, O_CLOEXEC);
>                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Assignment duplicated on the next line.

I didn't this for immediate inclusion that's why I said "hasty" but
thank you! :)

Christian
