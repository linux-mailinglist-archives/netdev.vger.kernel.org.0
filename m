Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1202009E3
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 15:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732641AbgFSNXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 09:23:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43242 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731756AbgFSNXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 09:23:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592572999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L1AwqEJ4MmDGxGt/9nJYqgE/svdWUsuiQ5kUV1vA7nI=;
        b=beIZwwcWZH3t1VbJN/TkERR4Fb71Pcmm98wg8dq7FJSMR5OJIDyiY/mAzRR486NGxU6mx5
        6JycgakB4UyafEalnzZ5OlTeeDHcIsqkmFwp//nJbol5Lrv4Rvs6nEi84oniNAfLuKtoAH
        IZEwd1JJieljXAOfeZbRbbgPRpe8Etc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-494-9D-ubtciNxavkdxgpycpSg-1; Fri, 19 Jun 2020 09:23:15 -0400
X-MC-Unique: 9D-ubtciNxavkdxgpycpSg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4344A8035CE;
        Fri, 19 Jun 2020 13:23:12 +0000 (UTC)
Received: from krava (unknown [10.40.195.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B23B6109F;
        Fri, 19 Jun 2020 13:23:07 +0000 (UTC)
Date:   Fri, 19 Jun 2020 15:23:06 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 02/11] bpf: Compile btfid tool at kernel compilation start
Message-ID: <20200619132306.GG2465907@krava>
References: <20200616100512.2168860-1-jolsa@kernel.org>
 <20200616100512.2168860-3-jolsa@kernel.org>
 <5eebd1486e46b_6d292ad5e7a285b817@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5eebd1486e46b_6d292ad5e7a285b817@john-XPS-13-9370.notmuch>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 01:40:40PM -0700, John Fastabend wrote:
> Jiri Olsa wrote:
> > The btfid tool will be used during the vmlinux linking,
> > so it's necessary it's ready for it.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  Makefile           | 22 ++++++++++++++++++----
> >  tools/Makefile     |  3 +++
> >  tools/bpf/Makefile |  5 ++++-
> >  3 files changed, 25 insertions(+), 5 deletions(-)
> 
> This breaks the build for me. I fixed it with this but then I get warnings,
> 
> diff --git a/tools/bpf/btfid/btfid.c b/tools/bpf/btfid/btfid.c
> index 7cdf39bfb150..3697e8ae9efa 100644
> --- a/tools/bpf/btfid/btfid.c
> +++ b/tools/bpf/btfid/btfid.c
> @@ -48,7 +48,7 @@
>  #include <errno.h>
>  #include <linux/rbtree.h>
>  #include <linux/zalloc.h>
> -#include <btf.h>
> +#include <linux/btf.h>
>  #include <libbpf.h>
>  #include <parse-options.h>
> 
> Here is the error. Is it something about my setup? bpftool/btf.c uses
> <btf.h>. Because this in top-level Makefile we probably don't want to
> push extra setup onto folks.

ouch, I wonder it's because I have libbpf installed and the
setup got mixed up.. I'll erase and try to reproduce

thanks,
jirka

> 
> In file included from btfid.c:51:
> /home/john/git/bpf-next/tools/lib/bpf/btf.h: In function ‘btf_is_var’:
> /home/john/git/bpf-next/tools/lib/bpf/btf.h:254:24: error: ‘BTF_KIND_VAR’ undeclared (first use in this function); did you mean ‘BTF_KIND_PTR’?
>   return btf_kind(t) == BTF_KIND_VAR;
>                         ^~~~~~~~~~~~
>                         BTF_KIND_PTR
> /home/john/git/bpf-next/tools/lib/bpf/btf.h:254:24: note: each undeclared identifier is reported only once for each function it appears in
> /home/john/git/bpf-next/tools/lib/bpf/btf.h: In function ‘btf_is_datasec’:
> /home/john/git/bpf-next/tools/lib/bpf/btf.h:259:24: error: ‘BTF_KIND_DATASEC’ undeclared (first use in this function); did you mean ‘BTF_KIND_PTR’?
>   return btf_kind(t) == BTF_KIND_DATASEC;
>                         ^~~~~~~~~~~~~~~~
>                         BTF_KIND_PTR
> mv: cannot stat '/home/john/git/bpf-next/tools/bpf/btfid/.btfid.o.tmp': No such file or directory
> make[3]: *** [/home/john/git/bpf-next/tools/build/Makefile.build:97: /home/john/git/bpf-next/tools/bpf/btfid/btfid.o] Error 1
> make[2]: *** [Makefile:59: /home/john/git/bpf-next/tools/bpf/btfid/btfid-in.o] Error 2
> make[1]: *** [Makefile:71: bpf/btfid] Error 2
> make: *** [Makefile:1894: tools/bpf/btfid] Error 2
> 

