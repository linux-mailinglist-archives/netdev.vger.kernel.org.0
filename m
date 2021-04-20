Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E38365943
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 14:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbhDTMwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 08:52:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54312 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231766AbhDTMwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 08:52:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618923113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GZw2QV10ZPoSVV/r5DXbb6EIzcgNZJBaR0TDFr3TPLw=;
        b=QgnmqgWkmfo3y6JnA8X75Vaiy0Uxa7RaqxjRtaRhHFAPERB54XQa8Flgr5H9xb4jsuh26F
        3w6/Yhehgj5lZwA1tAXIxjKK0w9kkGTU7MgVZA+YcNlN660nNeTzyOfr0glnoZpjZO6NBk
        EAzffphPaoHShIL4CUxRCBtIKIg3/aU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-CmDtPpsENnC57rOZn9QEDQ-1; Tue, 20 Apr 2021 08:51:49 -0400
X-MC-Unique: CmDtPpsENnC57rOZn9QEDQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 087EF10BFFDA;
        Tue, 20 Apr 2021 12:51:47 +0000 (UTC)
Received: from krava (unknown [10.40.196.37])
        by smtp.corp.redhat.com (Postfix) with SMTP id 5E42560916;
        Tue, 20 Apr 2021 12:51:43 +0000 (UTC)
Date:   Tue, 20 Apr 2021 14:51:42 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCHv2 RFC bpf-next 0/7] bpf: Add support for ftrace probe
Message-ID: <YH7OXrjBIqvEZbsc@krava>
References: <20210413121516.1467989-1-jolsa@kernel.org>
 <CAEf4Bzazst1rBi4=LuP6_FnPXCRYBNFEtDnK3UVBj6Eo6xFNtQ@mail.gmail.com>
 <YHbd2CmeoaiLJj7X@krava>
 <CAEf4BzYyVj-Tjy9ZZdAU5nOtJ8_auvVobTT6pMqg8zPb9jj-Ow@mail.gmail.com>
 <20210415111002.324b6bfa@gandalf.local.home>
 <CAEf4BzY=yBZH2Aad1hNcqCt51u0+SmNdkD6NfJRVMzF7DsvG+A@mail.gmail.com>
 <20210415170007.31420132@gandalf.local.home>
 <20210417000304.fc987dc00d706e7551b29c04@kernel.org>
 <20210416124834.05862233@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416124834.05862233@gandalf.local.home>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 12:48:34PM -0400, Steven Rostedt wrote:
> On Sat, 17 Apr 2021 00:03:04 +0900
> Masami Hiramatsu <mhiramat@kernel.org> wrote:
> 
> > > Anyway, IIRC, Masami wasn't sure that the full regs was ever needed for the
> > > return (who cares about the registers on return, except for the return
> > > value?)  
> > 
> > I think kretprobe and ftrace are for a bit different usage. kretprobe can be
> > used for something like debugger. In that case, accessing full regs stack
> > will be more preferrable. (BTW, what the not "full regs" means? Does that
> > save partial registers?)
> 
> When the REGS flag is not set in the ftrace_ops (where kprobes uses the
> REGS flags), the regs parameter is not a full set of regs, but holds just
> enough to get access to the parameters. This just happened to be what was
> saved in the mcount/fentry trampoline, anyway, because tracing the start of
> the program, you had to save the arguments before calling the trace code,
> otherwise you would corrupt the parameters of the function being traced.
> 
> I just tweaked it so that by default, the ftrace callbacks now have access
> to the saved regs (call ftrace_regs, to not let a callback get confused and
> think it has full regs when it does not).
> 
> Now for the exit of a function, what does having the full pt_regs give you?
> Besides the information to get the return value, the rest of the regs are
> pretty much meaningless. Is there any example that someone wants access to
> the regs at the end of a function besides getting the return value?

for ebpf program attached to the function exit we need the functions's
arguments.. so original registers from time when the function was entered,
we don't need registers state at the time function is returning

as we discussed in another email, we could save input registers in
fgraph_ops entry handler and load them in exit handler before calling
ebpf program

jirka

