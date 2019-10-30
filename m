Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71EC2E9F12
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 16:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbfJ3PcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 11:32:06 -0400
Received: from www62.your-server.de ([213.133.104.62]:38936 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727201AbfJ3PcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 11:32:06 -0400
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iPpx5-0004rK-TU; Wed, 30 Oct 2019 16:32:03 +0100
Date:   Wed, 30 Oct 2019 16:32:03 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Wenbo Zhang <ethercflow@gmail.com>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v4] bpf: add new helper fd2path for mapping a
 file descriptor to a pathname
Message-ID: <20191030153203.GA2675@pc-63.home>
References: <20191028141053.12267-1-ethercflow@gmail.com>
 <CAEf4BzY5XfX1_Txomnz1G4PCq=E4JSPVD+_BQ7qwn8=WM_imVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY5XfX1_Txomnz1G4PCq=E4JSPVD+_BQ7qwn8=WM_imVA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25618/Wed Oct 30 09:54:22 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 11:48:44AM -0700, Andrii Nakryiko wrote:
> On Mon, Oct 28, 2019 at 1:59 PM Wenbo Zhang <ethercflow@gmail.com> wrote:
> >
> > When people want to identify which file system files are being opened,
> > read, and written to, they can use this helper with file descriptor as
> > input to achieve this goal. Other pseudo filesystems are also supported.
> >
> > This requirement is mainly discussed here:
> >
> >   https://github.com/iovisor/bcc/issues/237
> >
> > v3->v4:
> > - fix missing fdput()
> > - move fd2path from kernel/bpf/trace.c to kernel/trace/bpf_trace.c
> > - move fd2path's test code to another patch
> >
> > v2->v3:
> > - remove unnecessary LOCKDOWN_BPF_READ
> > - refactor error handling section for enhanced readability
> > - provide a test case in tools/testing/selftests/bpf
> >
> > v1->v2:
> > - fix backward compatibility
> > - add this helper description
> > - fix signed-off name
> >
> > Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
> > ---
> >  include/uapi/linux/bpf.h       | 14 +++++++++++-
> >  kernel/trace/bpf_trace.c       | 40 ++++++++++++++++++++++++++++++++++
> >  tools/include/uapi/linux/bpf.h | 14 +++++++++++-
> >  3 files changed, 66 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 4af8b0819a32..124632b2a697 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -2775,6 +2775,17 @@ union bpf_attr {
> >   *             restricted to raw_tracepoint bpf programs.
> >   *     Return
> >   *             0 on success, or a negative error in case of failure.
> > + *
> > + * int bpf_fd2path(char *path, u32 size, int fd)
> 
> from what I can see, we don't have any BPF helper with this naming
> approach(2 -> to, 4 -> for, etc). How about something like
> bpf_get_file_path?
> 
> > + *     Description
> > + *             Get **file** atrribute from the current task by *fd*, then call
> > + *             **d_path** to get it's absolute path and copy it as string into
> > + *             *path* of *size*. The **path** also support pseudo filesystems
> > + *             (whether or not it can be mounted). The *size* must be strictly
> > + *             positive. On success, the helper makes sure that the *path* is
> > + *             NUL-terminated. On failure, it is filled with zeroes.
> > + *     Return
> > + *             0 on success, or a negative error in case of failure.
> 
> Mention that we actually return a positive number on success, which is
> a size of the string + 1 for NUL byte (the +1 is not true right now,
> but I think should be).
> 
> >   */
> >  #define __BPF_FUNC_MAPPER(FN)          \
> >         FN(unspec),                     \
> > @@ -2888,7 +2899,8 @@ union bpf_attr {
> >         FN(sk_storage_delete),          \
> >         FN(send_signal),                \
> >         FN(tcp_gen_syncookie),          \
> > -       FN(skb_output),
> > +       FN(skb_output),                 \
> > +       FN(fd2path),
> >
> >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> >   * function eBPF program intends to call
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index 571c25d60710..dd7b070df3d6 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -683,6 +683,44 @@ static const struct bpf_func_proto bpf_send_signal_proto = {
> >         .arg1_type      = ARG_ANYTHING,
> >  };
> >
> > +BPF_CALL_3(bpf_fd2path, char *, dst, u32, size, int, fd)
> > +{
> > +       struct fd f;
> > +       char *p;
> > +       int ret = -EINVAL;
> > +
> > +       /* Use fdget_raw instead of fdget to support O_PATH */
> > +       f = fdget_raw(fd);
> 
> I haven't followed previous discussions, so sorry if this was asked
> before. Can either fdget_raw or d_path sleep? Also, d_path seems to be
> relying on current, which in the interrupt context might not be what
> you really want. Have you considered these problems?
> 
> > +       if (!f.file)
> > +               goto error;
> > +
> > +       p = d_path(&f.file->f_path, dst, size);
> > +       if (IS_ERR_OR_NULL(p)) {
> > +               ret = PTR_ERR(p);
> 
> if p can really be NULL, you'd get ret == 0 here, which is probably
> not what you want.
> But reading d_path, it seems like it's either valid pointer or error,
> so just use IS_ERR above?
> 
> > +               goto error;
> > +       }
> > +
> > +       ret = strlen(p);
> > +       memmove(dst, p, ret);
> > +       dst[ret] = '\0';
> 
> I think returning number of useful bytes (including terminating NUL)
> is good and follows bpf_probe_read_str() convention. So ret++ here?
> 
> > +       goto end;
> > +
> > +error:
> > +       memset(dst, '0', size);
> > +end:
> > +       fdput(f);

Also I'd prefer fdget_*()'s error path not calling fdput(f).

> > +       return ret;
> > +}
> > +
> 
> [...]
