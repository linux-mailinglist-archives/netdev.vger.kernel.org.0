Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368D61DE5BF
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 13:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbgEVLoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 07:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728469AbgEVLoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 07:44:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C36C061A0E;
        Fri, 22 May 2020 04:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qixK0Ok5LjJzLtlIqZRWTn3BuaZ1Y97zRlOZ39Oq9js=; b=P6IvguSq9Yegz1CsStKaYYtLo/
        1Nv8m8rx8orS0RpvYeRQSaGvjP+Qq6si7kfYhVUem1FPjF81j7+k9URLKD8jKdNcgG8CjiPSeJ1MO
        AkQmBLr/GCusJWG39W44W7lbEJK673nVztf3VxcFwq+eBaybxhsrZNCmE9GEfnapBWVFcRehO9Qbo
        /AdEbFB4DfiU5nvnQWS6Znpc5zeiPZe9vR+T1GlUlGN1+r73inTsPTMQPFptNRhfnPSV8zfM9uRUj
        Ecg/Yn2mEZmNqX+mlMY9x+rmuiUkVe6u8sSGGRRfDvFBHFHyrNg5VhpzKurjTi8vA0WM7UZxa/ni0
        e0CG+Njg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jc65d-0005yy-2M; Fri, 22 May 2020 11:43:49 +0000
Date:   Fri, 22 May 2020 04:43:48 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     adobriyan@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        ebiederm@xmission.com, bernd.edlinger@hotmail.de,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [External] Re: [PATCH] files: Use rcu lock to get the file
 structures for better performance
Message-ID: <20200522114348.GL28818@bombadil.infradead.org>
References: <20200521123835.70069-1-songmuchun@bytedance.com>
 <20200521164746.GD28818@bombadil.infradead.org>
 <CAMZfGtWn4xa-5-0rN2KJzUYioiOOUYX9BFcUDNZS85H11sYDEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZfGtWn4xa-5-0rN2KJzUYioiOOUYX9BFcUDNZS85H11sYDEA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 03:52:39PM +0800, Muchun Song wrote:
> On Fri, May 22, 2020 at 12:47 AM Matthew Wilcox <willy@infradead.org> wrote:
> > > @@ -160,14 +168,23 @@ static int proc_fd_link(struct dentry *dentry, struct path *path)
> > >               unsigned int fd = proc_fd(d_inode(dentry));
> > >               struct file *fd_file;
> > >
> > > -             spin_lock(&files->file_lock);
> > > +             rcu_read_lock();
> > > +again:
> > >               fd_file = fcheck_files(files, fd);
> > >               if (fd_file) {
> > > +                     if (!get_file_rcu(fd_file)) {
> > > +                             /*
> > > +                              * we loop to catch the new file
> > > +                              * (or NULL pointer).
> > > +                              */
> > > +                             goto again;
> > > +                     }
> > >                       *path = fd_file->f_path;
> > >                       path_get(&fd_file->f_path);
> > > +                     fput(fd_file);
> > >                       ret = 0;
> > >               }
> > > -             spin_unlock(&files->file_lock);
> > > +             rcu_read_unlock();
> >
> > Why is it an improvement to increment/decrement the refcount on the
> > struct file here, rather than take/release the spinlock?
> >
> 
> lock-free vs spinlock.

bananas vs oranges.

How do you think refcounts work?  How do you think spinlocks work?

> Do you think spinlock would be better than the lock-free method?
> Actually I prefer the rcu lock.

Why?  You don't seem to understand the tradeoffs.
