Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58A42E566E
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 00:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfJYWUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 18:20:47 -0400
Received: from www62.your-server.de ([213.133.104.62]:47134 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfJYWUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 18:20:47 -0400
Received: from 33.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.33] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iO7wr-0006qG-4v; Sat, 26 Oct 2019 00:20:45 +0200
Date:   Sat, 26 Oct 2019 00:20:44 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 3/5] bpf: Add probe_read_{user,kernel} and
 probe_read_str_{user,kernel} helpers
Message-ID: <20191025222044.GE14547@pc-63.home>
References: <cover.1572010897.git.daniel@iogearbox.net>
 <c4d464c7b06a13b7b8c50fce02ef5e7c76111b33.1572010897.git.daniel@iogearbox.net>
 <CAEf4Bzb30P_jcWmjX-oo3VxRmPGyjDfULgQM0xz9JOmdgKkcRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bzb30P_jcWmjX-oo3VxRmPGyjDfULgQM0xz9JOmdgKkcRw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25613/Fri Oct 25 11:00:25 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 03:08:16PM -0700, Andrii Nakryiko wrote:
> On Fri, Oct 25, 2019 at 1:44 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > The current bpf_probe_read() and bpf_probe_read_str() helpers are broken
> > in that they assume they can be used for probing memory access for kernel
> > space addresses /as well as/ user space addresses.
> >
> > However, plain use of probe_kernel_read() for both cases will attempt to
> > always access kernel space address space given access is performed under
> > KERNEL_DS and some archs in-fact have overlapping address spaces where a
> > kernel pointer and user pointer would have the /same/ address value and
> > therefore accessing application memory via bpf_probe_read{,_str}() would
> > read garbage values.
> >
> > Lets fix BPF side by making use of recently added 3d7081822f7f ("uaccess:
> > Add non-pagefault user-space read functions"). Unfortunately, the only way
> > to fix this status quo is to add dedicated bpf_probe_read_{user,kernel}()
> > and bpf_probe_read_str_{user,kernel}() helpers. The bpf_probe_read{,_str}()
> > helpers are aliased to the *_kernel() variants to retain their current
> > behavior; for API consistency and ease of use the latter have been added
> > so that it is immediately *obvious* which address space the memory is being
> > probed on (user,kernel). The two *_user() variants attempt the access under
> > USER_DS set.
> >
> > Fixes: a5e8c07059d0 ("bpf: add bpf_probe_read_str helper")
> > Fixes: 2541517c32be ("tracing, perf: Implement BPF programs attached to kprobes")
> > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > ---
> >  include/uapi/linux/bpf.h       | 119 ++++++++++++++++++++---------
> >  kernel/trace/bpf_trace.c       | 133 ++++++++++++++++++++++-----------
> >  tools/include/uapi/linux/bpf.h | 119 ++++++++++++++++++++---------
> >  3 files changed, 253 insertions(+), 118 deletions(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 4af8b0819a32..b8ffb419df51 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -564,7 +564,11 @@ union bpf_attr {
> >   * int bpf_probe_read(void *dst, u32 size, const void *src)
> >   *     Description
> >   *             For tracing programs, safely attempt to read *size* bytes from
> > - *             address *src* and store the data in *dst*.
> > + *             kernel space address *src* and store the data in *dst*.
> > + *
> > + *             This helper is an alias to bpf_probe_read_kernel().
> > + *
> > + *             Generally, use bpf_probe_read_user() or bpf_probe_read_kernel() instead.
> >   *     Return
> >   *             0 on success, or a negative error in case of failure.
> >   *
> > @@ -1428,43 +1432,14 @@ union bpf_attr {
> >   *
> >   * int bpf_probe_read_str(void *dst, int size, const void *unsafe_ptr)
> 
> seems like an approriate time to standardize terminology. Should it be
> unsafe_ptr like here, or src like in bpf_probe_read description?

Makes sense, I'll go for unsafe_ptr in v2 as it feels more descriptive.

> >   *     Description
> > - *             Copy a NUL terminated string from an unsafe address
> > - *             *unsafe_ptr* to *dst*. The *size* should include the
> > - *             terminating NUL byte. In case the string length is smaller than
> > - *             *size*, the target is not padded with further NUL bytes. If the
> > - *             string length is larger than *size*, just *size*-1 bytes are
> > - *             copied and the last byte is set to NUL.
> > - *
> 
> [...]
> 
> >  #define __BPF_FUNC_MAPPER(FN)          \
> >         FN(unspec),                     \
> > @@ -2888,7 +2929,11 @@ union bpf_attr {
> >         FN(sk_storage_delete),          \
> >         FN(send_signal),                \
> >         FN(tcp_gen_syncookie),          \
> > -       FN(skb_output),
> > +       FN(skb_output),                 \
> > +       FN(probe_read_user),            \
> > +       FN(probe_read_kernel),          \
> > +       FN(probe_read_str_user),        \
> > +       FN(probe_read_str_kernel),
> 
> naming is subjective, but I'd go with probe_{user,kernel}_read[_str]
> scheme, but given bpf_probe_write_user and desire to stay consistent,
> I'd still stick to slightly different probe_read_{user,kernel}[_str]
> scheme.

Yeah, I'm fine with changing into probe_read_{user,kernel}[_str], and
it's still in line with bpf_probe_{read,write}_{user,kernel} helpers.

> >  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
> >   * function eBPF program intends to call
> > diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> > index 79919a26cd59..ff001b766799 100644
> > --- a/kernel/trace/bpf_trace.c
> > +++ b/kernel/trace/bpf_trace.c
> > @@ -138,12 +138,52 @@ static const struct bpf_func_proto bpf_override_return_proto = {
> >  };
> >  #endif
> >
> 
> [...]
