Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F39F39FEC9
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 20:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233933AbhFHSTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 14:19:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48329 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233651AbhFHSTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 14:19:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623176231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FgcNrFAjjDfM6kscY0HroHEpq/799D0mYtyjXFcJssg=;
        b=KLI/LlQfBcxH3f6cTiLoaZ9YqnoS54eKyF0WmMcpUFIR6kgqO7oLTPNmPh9M3erj487lwR
        stzOgl5mPoI2P5Pr/RJtTfJY2hRgEp4QqToh9gWDnmvbwE5Iwe9LJSxX7mq/hKBD5mAbQ/
        xopfDctOOa5lQJQOPZ1DUhEbAQlmtnU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-snZbmUCDPcKyjcBflb7kmw-1; Tue, 08 Jun 2021 14:17:08 -0400
X-MC-Unique: snZbmUCDPcKyjcBflb7kmw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1159D8189C6;
        Tue,  8 Jun 2021 18:17:05 +0000 (UTC)
Received: from krava (unknown [10.40.195.112])
        by smtp.corp.redhat.com (Postfix) with SMTP id 2B1D0620DE;
        Tue,  8 Jun 2021 18:17:01 +0000 (UTC)
Date:   Tue, 8 Jun 2021 20:17:00 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCH 13/19] bpf: Add support to link multi func tracing program
Message-ID: <YL+0HLQ9oSrNM7ip@krava>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-14-jolsa@kernel.org>
 <CAADnVQJV+0SjqUrTw+3Y02tFedcAaPKJS-W8sQHw5YT4XUW0hQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJV+0SjqUrTw+3Y02tFedcAaPKJS-W8sQHw5YT4XUW0hQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 08:42:32AM -0700, Alexei Starovoitov wrote:
> On Sat, Jun 5, 2021 at 4:11 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding support to attach multiple functions to tracing program
> > by using the link_create/link_update interface.
> >
> > Adding multi_btf_ids/multi_btf_ids_cnt pair to link_create struct
> > API, that define array of functions btf ids that will be attached
> > to prog_fd.
> >
> > The prog_fd needs to be multi prog tracing program (BPF_F_MULTI_FUNC).
> >
> > The new link_create interface creates new BPF_LINK_TYPE_TRACING_MULTI
> > link type, which creates separate bpf_trampoline and registers it
> > as direct function for all specified btf ids.
> >
> > The new bpf_trampoline is out of scope (bpf_trampoline_lookup) of
> > standard trampolines, so all registered functions need to be free
> > of direct functions, otherwise the link fails.
> 
> Overall the api makes sense to me.
> The restriction of multi vs non-multi is too severe though.
> The multi trampoline can serve normal fentry/fexit too.

so multi trampoline gets called from all the registered functions,
so there would need to be filter for specific ip before calling the
standard program.. single cmp/jnz might not be that bad, I'll check

> If ip is moved to the end (instead of start) the trampoline
> will be able to call into multi and normal fentry/fexit progs. Right?
> 

we could just skip ip arg when generating entry for normal programs 
and start from first argument address for %rdi

and it'd need to be transparent for current trampolines user API,
so I wonder there will be some hiccup ;-) let's see

thanks,
jirka

