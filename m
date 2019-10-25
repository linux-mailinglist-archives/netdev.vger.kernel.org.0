Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C86CDE5669
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 00:15:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfJYWPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 18:15:33 -0400
Received: from www62.your-server.de ([213.133.104.62]:45904 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfJYWPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 18:15:33 -0400
Received: from 33.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.33] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iO7rn-0005bL-57; Sat, 26 Oct 2019 00:15:31 +0200
Date:   Sat, 26 Oct 2019 00:15:30 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/5] uaccess: Add non-pagefault user-space write
 function
Message-ID: <20191025221530.GD14547@pc-63.home>
References: <cover.1572010897.git.daniel@iogearbox.net>
 <8e63f4005c7139d88c5c78e2a19f539b2a1ff988.1572010897.git.daniel@iogearbox.net>
 <CAEf4BzbTKeBabyb3C3Yj5iT8TQC7A7SeUAe=PafaKnqeA4zoVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbTKeBabyb3C3Yj5iT8TQC7A7SeUAe=PafaKnqeA4zoVQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25613/Fri Oct 25 11:00:25 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 02:53:07PM -0700, Andrii Nakryiko wrote:
> On Fri, Oct 25, 2019 at 1:44 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > Commit 3d7081822f7f ("uaccess: Add non-pagefault user-space read functions")
> > missed to add probe write function, therefore factor out a probe_write_common()
> > helper with most logic of probe_kernel_write() except setting KERNEL_DS, and
> > add a new probe_user_write() helper so it can be used from BPF side.
> >
> > Again, on some archs, the user address space and kernel address space can
> > co-exist and be overlapping, so in such case, setting KERNEL_DS would mean
> > that the given address is treated as being in kernel address space.
> >
> > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> 
> LGTM. See an EFAULT comment below, though.
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
> [...]
> 
> > +/**
> > + * probe_user_write(): safely attempt to write to a user-space location
> > + * @dst: address to write to
> > + * @src: pointer to the data that shall be written
> > + * @size: size of the data chunk
> > + *
> > + * Safely write to address @dst from the buffer at @src.  If a kernel fault
> > + * happens, handle that and return -EFAULT.
> > + */
> > +
> > +long __weak probe_user_write(void __user *dst, const void *src, size_t size)
> > +    __attribute__((alias("__probe_user_write")));
> 
> curious, why is there this dance of probe_user_write alias to
> __probe_user_write (and for other pairs of functions as well)?

Seems done by convention to allow archs to override the __weak marked
functions in order to add additional checks and being able to then call
into the __ prefixed variant.

> > +long __probe_user_write(void __user *dst, const void *src, size_t size)
> > +{
> > +       long ret = -EFAULT;
> 
> This initialization is not necessary, is it? Similarly in
> __probe_user_read higher in this file.

Not entirely sure what you mean. In both there's access_ok() check before
invoking the common helper.

> > +       mm_segment_t old_fs = get_fs();
> > +
> > +       set_fs(USER_DS);
> > +       if (access_ok(dst, size))
> > +               ret = probe_write_common(dst, src, size);
> > +       set_fs(old_fs);
> > +
> > +       return ret;
> > +}
> > +EXPORT_SYMBOL_GPL(probe_user_write);
> >
> >  /**
> >   * strncpy_from_unsafe: - Copy a NUL terminated string from unsafe address.
> > --
> > 2.21.0
> >
