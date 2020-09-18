Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3108426F9E2
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbgIRKFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:05:55 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57912 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726551AbgIRKFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 06:05:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600423551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WkpClEmXxT84vDpjsqvB+DVNHu1sfbMIG8xOfJiWTAw=;
        b=B5vjXDs1yeLh4Ew4xx+uFAIGu1+fqHOGTkiywxM5zcUNOKEXMdih/L5t8VsqRJ/VjC/yqq
        TfeiQl7X2kl6OtSrD8A7G95lf88RMvLLKA/maw4/GLPtFMzIuklo91hP8smHXv3twncQB6
        osz0QqjJkSOonuYr2cxW2mHfJls6NtE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-pG7bMC-GPxaN-W1VdCndGg-1; Fri, 18 Sep 2020 06:05:47 -0400
X-MC-Unique: pG7bMC-GPxaN-W1VdCndGg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FA621891E81;
        Fri, 18 Sep 2020 10:05:45 +0000 (UTC)
Received: from krava (ovpn-114-24.ams2.redhat.com [10.36.114.24])
        by smtp.corp.redhat.com (Postfix) with SMTP id 5A90D55771;
        Fri, 18 Sep 2020 10:05:43 +0000 (UTC)
Date:   Fri, 18 Sep 2020 12:05:42 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Seth Forshee <seth.forshee@canonical.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: resolve_btfids breaks kernel cross-compilation
Message-ID: <20200918100542.GD2514666@krava>
References: <20200916194733.GA4820@ubuntu-x1>
 <20200917080452.GB2411168@krava>
 <20200917083809.GE2411168@krava>
 <20200917091406.GF2411168@krava>
 <20200917125450.GC4820@ubuntu-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917125450.GC4820@ubuntu-x1>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 17, 2020 at 07:54:50AM -0500, Seth Forshee wrote:
> On Thu, Sep 17, 2020 at 11:14:06AM +0200, Jiri Olsa wrote:
> > On Thu, Sep 17, 2020 at 10:38:12AM +0200, Jiri Olsa wrote:
> > > On Thu, Sep 17, 2020 at 10:04:55AM +0200, Jiri Olsa wrote:
> > > > On Wed, Sep 16, 2020 at 02:47:33PM -0500, Seth Forshee wrote:
> > > > > The requirement to build resolve_btfids whenever CONFIG_DEBUG_INFO_BTF
> > > > > is enabled breaks some cross builds. For example, when building a 64-bit
> > > > > powerpc kernel on amd64 I get:
> > > > > 
> > > > >  Auto-detecting system features:
> > > > >  ...                        libelf: [ [32mon[m  ]
> > > > >  ...                          zlib: [ [32mon[m  ]
> > > > >  ...                           bpf: [ [31mOFF[m ]
> > > > >  
> > > > >  BPF API too old
> > > > >  make[6]: *** [Makefile:295: bpfdep] Error 1
> > > > > 
> > > > > The contents of tools/bpf/resolve_btfids/feature/test-bpf.make.output:
> > > > > 
> > > > >  In file included from /home/sforshee/src/u-k/unstable/tools/arch/powerpc/include/uapi/asm/bitsperlong.h:11,
> > > > >                   from /usr/include/asm-generic/int-ll64.h:12,
> > > > >                   from /usr/include/asm-generic/types.h:7,
> > > > >                   from /usr/include/x86_64-linux-gnu/asm/types.h:1,
> > > > >                   from /home/sforshee/src/u-k/unstable/tools/include/linux/types.h:10,
> > > > >                   from /home/sforshee/src/u-k/unstable/tools/include/uapi/linux/bpf.h:11,
> > > > >                   from test-bpf.c:3:
> > > > >  /home/sforshee/src/u-k/unstable/tools/include/asm-generic/bitsperlong.h:14:2: error: #error Inconsistent word size. Check asm/bitsperlong.h
> > > > >     14 | #error Inconsistent word size. Check asm/bitsperlong.h
> > > > >        |  ^~~~~
> > > > > 
> > > > > This is because tools/arch/powerpc/include/uapi/asm/bitsperlong.h sets
> > > > > __BITS_PER_LONG based on the predefinied compiler macro __powerpc64__,
> > > > > which is not defined by the host compiler. What can we do to get cross
> > > > > builds working again?
> > > > 
> > > > could you please share the command line and setup?
> > > 
> > > I just reproduced.. checking on fix
> > 
> > I still need to check on few things, but patch below should help
> 
> It does help with the word size problem, thanks.
> 
> > we might have a problem for cross builds with different endianity
> > than the host because libbpf does not support reading BTF data
> > with different endianity, and we get:
> > 
> >   BTFIDS  vmlinux
> > libbpf: non-native ELF endianness is not supported
> 
> Yes, I see this now when cross building for s390.

Andrii,
I read you might be already working on this?
  https://lore.kernel.org/bpf/CAEf4Bza9tZ-Jj0dj9Ne0fmxa95t=9XxxJR+Ce=6hDmw_d8uVFA@mail.gmail.com/

thanks,
jirka

> 
> Thanks,
> Seth
> 
> > 
> > jirka
> > 
> > 
> > ---
> > diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
> > index a88cd4426398..d3c818b8d8d3 100644
> > --- a/tools/bpf/resolve_btfids/Makefile
> > +++ b/tools/bpf/resolve_btfids/Makefile
> > @@ -1,5 +1,6 @@
> >  # SPDX-License-Identifier: GPL-2.0-only
> >  include ../../scripts/Makefile.include
> > +include ../../scripts/Makefile.arch
> >  
> >  ifeq ($(srctree),)
> >  srctree := $(patsubst %/,%,$(dir $(CURDIR)))
> > @@ -29,6 +30,7 @@ endif
> >  AR       = $(HOSTAR)
> >  CC       = $(HOSTCC)
> >  LD       = $(HOSTLD)
> > +ARCH     = $(HOSTARCH)
> >  
> >  OUTPUT ?= $(srctree)/tools/bpf/resolve_btfids/
> >  
> > 
> 

