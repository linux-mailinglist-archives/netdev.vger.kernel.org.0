Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5AA29E755
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 10:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgJ2JaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 05:30:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43022 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726529AbgJ2JaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 05:30:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603963808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4WtPo2kYb8PT4NMd2QodJLeCtzpWhnuBUhWmU8TR5PM=;
        b=R0myDfgJFvkaTccc4xSeCv/sWnpskYkYiKz2dloaR+cXF6uFKYgefJxw/pmWY5HCqwqhF4
        2mJlyZLb9SK69odX0GWfHkrLmkcbLoGRA4WMlDW92w9/DiZlgE3qzco6yQu2GHbMI1s874
        FMMUcE40+OsVx1NVd5+TzJYX5jrgLvQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-CUMRERftNEqs5CFP2FMJcQ-1; Thu, 29 Oct 2020 05:30:04 -0400
X-MC-Unique: CUMRERftNEqs5CFP2FMJcQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 272FE1009B6D;
        Thu, 29 Oct 2020 09:30:02 +0000 (UTC)
Received: from krava (unknown [10.40.193.60])
        by smtp.corp.redhat.com (Postfix) with SMTP id 55E031975E;
        Thu, 29 Oct 2020 09:29:54 +0000 (UTC)
Date:   Thu, 29 Oct 2020 10:29:53 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [RFC bpf-next 07/16] kallsyms: Use rb tree for kallsyms name
 search
Message-ID: <20201029092953.GA3027684@krava>
References: <20201022082138.2322434-1-jolsa@kernel.org>
 <20201022082138.2322434-8-jolsa@kernel.org>
 <20201028182534.GS2900849@krava>
 <20201028211502.ishg56ogvjuj7t4w@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201028211502.ishg56ogvjuj7t4w@ast-mbp.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 02:15:02PM -0700, Alexei Starovoitov wrote:
> On Wed, Oct 28, 2020 at 07:25:34PM +0100, Jiri Olsa wrote:
> > On Thu, Oct 22, 2020 at 10:21:29AM +0200, Jiri Olsa wrote:
> > > The kallsyms_expand_symbol function showed in several bpf related
> > > profiles, because it's doing linear search.
> > > 
> > > Before:
> > > 
> > >  Performance counter stats for './src/bpftrace -ve kfunc:__x64_sys_s* \
> > >    { printf("test\n"); } i:ms:10 { printf("exit\n"); exit();}' (5 runs):
> > > 
> > >      2,535,458,767      cycles:k                         ( +-  0.55% )
> > >        940,046,382      cycles:u                         ( +-  0.27% )
> > > 
> > >              33.60 +- 3.27 seconds time elapsed  ( +-  9.73% )
> > > 
> > > Loading all the vmlinux symbols in rbtree and and switch to rbtree
> > > search in kallsyms_lookup_name function to save few cycles and time.
> > > 
> > > After:
> > > 
> > >  Performance counter stats for './src/bpftrace -ve kfunc:__x64_sys_s* \
> > >    { printf("test\n"); } i:ms:10 { printf("exit\n"); exit();}' (5 runs):
> > > 
> > >      2,199,433,771      cycles:k                         ( +-  0.55% )
> > >        936,105,469      cycles:u                         ( +-  0.37% )
> > > 
> > >              26.48 +- 3.57 seconds time elapsed  ( +- 13.49% )
> > > 
> > > Each symbol takes 160 bytes, so for my .config I've got about 18 MBs
> > > used for 115285 symbols.
> > > 
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > 
> > FYI there's init_kprobes dependency on kallsyms_lookup_name in early
> > init call, so this won't work as it is :-\ will address this in v2
> > 
> > also I'll switch to sorted array and bsearch, because kallsyms is not
> > dynamically updated
> 
> wait wat? kallsyms are dynamically updated. bpf adds and removes from it.
> You even worked on some of those patches :)

yes, it's tricky ;-) kallsyms_lookup_name function goes through builtin
(compiled in) symbols and "standard modules" symbols

we add bpf symbols as "pseudo module" symbol, which is not covered by
this function search, it is covered when displaying /proc/kallsyms
(check get_ksymbol_bpf function), same for ftrace and kprobe symbols

AFAICS we use kallsyms_lookup_name only to search builtin kernel symbols,
so we don't care it does not cover "pseudo modules"

now.. what's even more funny, is that if I switch to sort/bsearch,
performance is back on the same numbers as the current code :-\

jirka

