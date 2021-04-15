Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 567E9361457
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 23:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbhDOVuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 17:50:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34923 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235892AbhDOVuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 17:50:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618523393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=93Xh1fQzZB4WywyUrX8ZKTZ4fRqnkDN1t1jedSnjsOA=;
        b=a6G7WCeKXK9ZZrvTloHkNMnGr9wDmpxNCnP66SkFWEvITHqUHb+787y18xSRs54Hc+KcZW
        f3yrPhl8ySkpDHBYGki3i3eGNSHIZKfEcGqK+gPOl+i2V5SANg3uUcxaTNyCpqf6A4SZhJ
        2ATERmj31RD1LW6m6YG8qwZlngNAdsc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-7FrbVqdSMbaqdns39uhbGA-1; Thu, 15 Apr 2021 17:49:51 -0400
X-MC-Unique: 7FrbVqdSMbaqdns39uhbGA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8B2DB10054F6;
        Thu, 15 Apr 2021 21:49:49 +0000 (UTC)
Received: from krava (unknown [10.40.196.6])
        by smtp.corp.redhat.com (Postfix) with SMTP id 1D2C359447;
        Thu, 15 Apr 2021 21:49:43 +0000 (UTC)
Date:   Thu, 15 Apr 2021 23:49:43 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
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
Message-ID: <YHi09yyqVEkZsn7p@krava>
References: <20210413121516.1467989-1-jolsa@kernel.org>
 <CAEf4Bzazst1rBi4=LuP6_FnPXCRYBNFEtDnK3UVBj6Eo6xFNtQ@mail.gmail.com>
 <YHbd2CmeoaiLJj7X@krava>
 <CAEf4BzYyVj-Tjy9ZZdAU5nOtJ8_auvVobTT6pMqg8zPb9jj-Ow@mail.gmail.com>
 <20210415111002.324b6bfa@gandalf.local.home>
 <YHh6YeOPh0HIlb3e@krava>
 <20210415141831.7b8fbe72@gandalf.local.home>
 <20210415142120.7427b4bd@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415142120.7427b4bd@gandalf.local.home>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 02:21:20PM -0400, Steven Rostedt wrote:
> On Thu, 15 Apr 2021 14:18:31 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > My last release of that code is here:
> > 
> >   https://lore.kernel.org/lkml/20190525031633.811342628@goodmis.org/
> > 
> > It allows you to "reserve data" to pass from the caller to the return, and
> > that could hold the arguments. See patch 15 of that series.
> 
> Note that implementation only lets you save up to 4 words on the stack, but
> that can be changed. Or you could have a separate shadow stack for saving
> arguments, and only pass the pointer to the location on the other stack
> where those arguments are.

right, I quickly checked on that and it looks exactly like
the thing we need

I'll try to rebase that on the current code and try to use
it with the bpf ftrace probe to see how it fits

any chance you could plan on reposting it? ;-)

thanks,
jirka

