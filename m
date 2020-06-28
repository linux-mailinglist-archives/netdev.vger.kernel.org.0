Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC71920C9FD
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 21:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgF1Tsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 15:48:46 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39920 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbgF1Tsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 15:48:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593373724;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DpD5X5Cgo+kaE01lhn2JwsHFdpxxPz3nvzlkk6dhHC8=;
        b=RbvEhfcxBfAG1Z6V86kX9zuyuRVt1qZ9Fvp3p5VKsXzlxeZ8K9i734RISdZEqLjGInaVjr
        QVEpTmBWH2OwfhTSLm8MylSqyY51EN388s/05YY3a0Vn25tdjs99jArp0Nel01VNpCgrsq
        9K8VJJIr3hh5jYPdISQ0uU7b3X+9pd4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-J39CijDpOGGxfH_G7N9bVA-1; Sun, 28 Jun 2020 15:48:38 -0400
X-MC-Unique: J39CijDpOGGxfH_G7N9bVA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 686458015CE;
        Sun, 28 Jun 2020 19:48:36 +0000 (UTC)
Received: from krava (unknown [10.40.192.56])
        by smtp.corp.redhat.com (Postfix) with SMTP id 11EDA7CAC0;
        Sun, 28 Jun 2020 19:48:32 +0000 (UTC)
Date:   Sun, 28 Jun 2020 21:48:32 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v4 bpf-next 02/14] bpf: Compile resolve_btfids tool at
 kernel compilation start
Message-ID: <20200628194832.GC2988321@krava>
References: <20200625221304.2817194-1-jolsa@kernel.org>
 <20200625221304.2817194-3-jolsa@kernel.org>
 <CAEf4BzZw-asXypkTnzEEn7B86Yy3uUHZaj2qaUxd68hvpS73Eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZw-asXypkTnzEEn7B86Yy3uUHZaj2qaUxd68hvpS73Eg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 02:28:30PM -0700, Andrii Nakryiko wrote:
> On Thu, Jun 25, 2020 at 4:47 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > The resolve_btfids tool will be used during the vmlinux linking,
> > so it's necessary it's ready for it.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> 
> Not sure about clean target, but otherwise looks good to me.
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 
> >  Makefile           | 22 ++++++++++++++++++----
> >  tools/Makefile     |  3 +++
> >  tools/bpf/Makefile |  5 ++++-
> >  3 files changed, 25 insertions(+), 5 deletions(-)
> >
> 
> [...]
> 
> > diff --git a/tools/bpf/Makefile b/tools/bpf/Makefile
> > index 6df1850f8353..89ae235b790e 100644
> > --- a/tools/bpf/Makefile
> > +++ b/tools/bpf/Makefile
> > @@ -123,5 +123,8 @@ runqslower_install:
> >  runqslower_clean:
> >         $(call descend,runqslower,clean)
> >
> > +resolve_btfids:
> > +       $(call descend,resolve_btfids)
> > +
> 
> I think we talked about this. Did we decide that resolve_btfids_clean
> is not necessary?

nope, I said I'd add it and forgot ;-) will add in next version

thanks,
jirka

> 
> >  .PHONY: all install clean bpftool bpftool_install bpftool_clean \
> > -       runqslower runqslower_install runqslower_clean
> > +       runqslower runqslower_install runqslower_clean resolve_btfids
> > --
> > 2.25.4
> >
> 

