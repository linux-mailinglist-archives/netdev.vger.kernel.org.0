Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D5E29EA26
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 12:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbgJ2LJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 07:09:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57154 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727656AbgJ2LJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 07:09:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603969785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mUmBmibR91G10RNiRrOkfIxo1o/9rdeO2Vew3fkkmi4=;
        b=EV8fIBGQfam8FjUHs4UzoPxnMekaDf/0aXyD9hvum/0kBDWJ9acP/CWvyN/XSYgAJYkVco
        QQrqW4ODL2i+AdKqCVpCUkkRxcCgYcBml8jB6KdiNkNaPyv2KbOHUM0gf8uiZU4nYBK7hU
        45M3dleb+DAzpFTEhjkweDp8oZ6qSbo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-ll3KQL2rOH2KH7xjpiTcoA-1; Thu, 29 Oct 2020 07:09:44 -0400
X-MC-Unique: ll3KQL2rOH2KH7xjpiTcoA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 007DC10E2186;
        Thu, 29 Oct 2020 11:09:42 +0000 (UTC)
Received: from krava (unknown [10.40.193.60])
        by smtp.corp.redhat.com (Postfix) with SMTP id A64585B4AA;
        Thu, 29 Oct 2020 11:09:35 +0000 (UTC)
Date:   Thu, 29 Oct 2020 12:09:34 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [RFC bpf-next 00/16] bpf: Speed up trampoline attach
Message-ID: <20201029110934.GD3027684@krava>
References: <20201022082138.2322434-1-jolsa@kernel.org>
 <20201022093510.37e8941f@gandalf.local.home>
 <20201022141154.GB2332608@krava>
 <20201022104205.728dd135@gandalf.local.home>
 <20201027043014.ebzcbzospzsaptvu@ast-mbp.dhcp.thefacebook.com>
 <20201027142803.GJ2900849@krava>
 <20201028211325.vstp37ukcvoilmk3@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028211325.vstp37ukcvoilmk3@ast-mbp.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 02:13:25PM -0700, Alexei Starovoitov wrote:
> On Tue, Oct 27, 2020 at 03:28:03PM +0100, Jiri Olsa wrote:
> > On Mon, Oct 26, 2020 at 09:30:14PM -0700, Alexei Starovoitov wrote:
> > > On Thu, Oct 22, 2020 at 10:42:05AM -0400, Steven Rostedt wrote:
> > > > On Thu, 22 Oct 2020 16:11:54 +0200
> > > > Jiri Olsa <jolsa@redhat.com> wrote:
> > > > 
> > > > > I understand direct calls as a way that bpf trampolines and ftrace can
> > > > > co-exist together - ebpf trampolines need that functionality of accessing
> > > > > parameters of a function as if it was called directly and at the same
> > > > > point we need to be able attach to any function and to as many functions
> > > > > as we want in a fast way
> > > > 
> > > > I was sold that bpf needed a quick and fast way to get the arguments of a
> > > > function, as the only way to do that with ftrace is to save all registers,
> > > > which, I was told was too much overhead, as if you only care about
> > > > arguments, there's much less that is needed to save.
> > > > 
> > > > Direct calls wasn't added so that bpf and ftrace could co-exist, it was
> > > > that for certain cases, bpf wanted a faster way to access arguments,
> > > > because it still worked with ftrace, but the saving of regs was too
> > > > strenuous.
> > > 
> > > Direct calls in ftrace were done so that ftrace and trampoline can co-exist.
> > > There is no other use for it.
> > > 
> > > Jiri,
> > > could you please redo your benchmarking hardcoding ftrace_managed=false ?
> > > If going through register_ftrace_direct() is indeed so much slower
> > > than arch_text_poke() then something gotta give.
> > > Either register_ftrace_direct() has to become faster or users
> > > have to give up on co-existing of bpf and ftrace.
> > > So far not a single user cared about using trampoline and ftrace together.
> > > So the latter is certainly an option.
> > 
> > I tried that, and IIRC it was not much faster, but I don't have details
> > on that.. but it should be quick check, I'll do it
> > 
> > anyway later I realized that for us we need ftrace to stay, so I abandoned
> > this idea ;-) and started to check on how to keep them both together and
> > just make it faster
> > 
> > also currently bpf trampolines will not work without ftrace being
> > enabled, because ftrace is doing the preparation work during compile,
> > and replaces all the fentry calls with nop instructions and the
> > replace code depends on those nops...  so if we go this way, we would
> > need to make this preparation code generic
> 
> I didn't mean that part.
> I was talking about register_ftrace_direct() only.
> Could you please still do ftrace_managed=false experiment?
> Sounds like the time to attach/detach will stay the same?
> If so, then don't touch ftrace internals then. What's the point?

actually, there's some speedup.. by running:

  # perf stat --table -e cycles:k,cycles:u -r 10 ./src/bpftrace -ve 'kfunc:__x64_sys_s* { } i:ms:10 { print("exit\n"); exit();}'

I've got following numbers on base:

     3,463,157,566      cycles:k                                                      ( +-  0.14% )
     1,164,026,270      cycles:u                                                      ( +-  0.29% )

             # Table of individual measurements:
             37.61 (-12.20) #######
             49.35 (-0.46) #
             54.03 (+4.22) ##
             50.82 (+1.01) #
             46.87 (-2.94) ##
             53.10 (+3.29) ##
             58.27 (+8.46) ###
             64.85 (+15.04) #####
             47.37 (-2.44) ##
             35.83 (-13.98) ########

             # Final result:
             49.81 +- 2.76 seconds time elapsed  ( +-  5.54% )


and following numbers with the patch below:

     2,037,364,413      cycles:k        ( +-  0.52% )
     1,164,769,939      cycles:u        ( +-  0.19% )

             # Table of individual measurements:
             30.52 (-8.54) ######
             43.43 (+4.37) ###
             43.72 (+4.66) ###
             35.70 (-3.36) ##
             40.70 (+1.63) #
             43.51 (+4.44) ###
             26.44 (-12.62) ##########
             40.21 (+1.14) #
             43.32 (+4.25) ##
             43.09 (+4.03) ##

             # Final result:
             39.06 +- 1.95 seconds time elapsed  ( +-  4.99% )


it looks like even ftrace_managed=false could be faster
with batch update, which is not used, but there's support
for it via text_poke_bp_batch function

jirka


---
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 35c5887d82ff..0a241e6eac7d 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -111,6 +111,8 @@ static int is_ftrace_location(void *ip)
 {
 	long addr;
 
+	return 0;
+
 	addr = ftrace_location((long)ip);
 	if (!addr)
 		return 0;

