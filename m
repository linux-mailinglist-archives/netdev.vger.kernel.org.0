Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96CF8310959
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 11:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbhBEKm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 05:42:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32263 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231320AbhBEKgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 05:36:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612521317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QJCCgzFVl3igOoCKJCJw9qlTMRXU0EBO0JvhKR9cbr4=;
        b=Nqo64f/M5NEgucfwgKE25EWJ+8333kMekSRz0MsWwyFhuG/Oxk2uLbFASHFcfq4D8qHlKs
        JN0dD3dksrNogCL/nFMgaMPRYS9dW5aJp3TBgnFJXqYaxUqEdxeOL2Rukw/+66+Q72qR4R
        DqSCDougZKczUcfmUlOlI4pKlXZU7nw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-299-30aKlXhpNzqfdjB4BQeMvg-1; Fri, 05 Feb 2021 05:35:14 -0500
X-MC-Unique: 30aKlXhpNzqfdjB4BQeMvg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9620E15720;
        Fri,  5 Feb 2021 10:35:11 +0000 (UTC)
Received: from krava (unknown [10.40.195.59])
        by smtp.corp.redhat.com (Postfix) with SMTP id 81A315C648;
        Fri,  5 Feb 2021 10:35:08 +0000 (UTC)
Date:   Fri, 5 Feb 2021 11:35:07 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/4] tools/resolve_btfids: Build libbpf and
 libsubcmd in separate directories
Message-ID: <YB0fW+zEPHa/XKsq@krava>
References: <20210129134855.195810-1-jolsa@redhat.com>
 <20210204211825.588160-1-jolsa@kernel.org>
 <20210204211825.588160-2-jolsa@kernel.org>
 <CAEf4BzYhnm2tfnuGWXDOAZZmYBnboSZ3JsWjDHM5ortCbaeEjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYhnm2tfnuGWXDOAZZmYBnboSZ3JsWjDHM5ortCbaeEjw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 04, 2021 at 04:39:38PM -0800, Andrii Nakryiko wrote:
> On Thu, Feb 4, 2021 at 1:20 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Setting up separate build directories for libbpf and libpsubcmd,
> > so it's separated from other objects and we don't get them mixed
> > in the future.
> >
> > It also simplifies cleaning, which is now simple rm -rf.
> >
> > Also there's no need for FEATURE-DUMP.libbpf and bpf_helper_defs.h
> > files in .gitignore anymore.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  tools/bpf/resolve_btfids/.gitignore |  2 --
> >  tools/bpf/resolve_btfids/Makefile   | 26 +++++++++++---------------
> >  2 files changed, 11 insertions(+), 17 deletions(-)
> >
> > diff --git a/tools/bpf/resolve_btfids/.gitignore b/tools/bpf/resolve_btfids/.gitignore
> > index a026df7dc280..25f308c933cc 100644
> > --- a/tools/bpf/resolve_btfids/.gitignore
> > +++ b/tools/bpf/resolve_btfids/.gitignore
> > @@ -1,4 +1,2 @@
> > -/FEATURE-DUMP.libbpf
> > -/bpf_helper_defs.h
> >  /fixdep
> >  /resolve_btfids
> > diff --git a/tools/bpf/resolve_btfids/Makefile b/tools/bpf/resolve_btfids/Makefile
> > index bf656432ad73..b780b3a9fb07 100644
> > --- a/tools/bpf/resolve_btfids/Makefile
> > +++ b/tools/bpf/resolve_btfids/Makefile
> > @@ -28,22 +28,22 @@ OUTPUT ?= $(srctree)/tools/bpf/resolve_btfids/
> >  LIBBPF_SRC := $(srctree)/tools/lib/bpf/
> >  SUBCMD_SRC := $(srctree)/tools/lib/subcmd/
> >
> > -BPFOBJ     := $(OUTPUT)/libbpf.a
> > -SUBCMDOBJ  := $(OUTPUT)/libsubcmd.a
> > +BPFOBJ     := $(OUTPUT)/libbpf/libbpf.a
> > +SUBCMDOBJ  := $(OUTPUT)/libsubcmd/libsubcmd.a
> >
> >  BINARY     := $(OUTPUT)/resolve_btfids
> >  BINARY_IN  := $(BINARY)-in.o
> >
> >  all: $(BINARY)
> >
> > -$(OUTPUT):
> > +$(OUTPUT) $(OUTPUT)/libbpf $(OUTPUT)/libsubcmd:
> >         $(call msg,MKDIR,,$@)
> > -       $(Q)mkdir -p $(OUTPUT)
> > +       $(Q)mkdir -p $(@)
> >
> > -$(SUBCMDOBJ): fixdep FORCE
> > -       $(Q)$(MAKE) -C $(SUBCMD_SRC) OUTPUT=$(OUTPUT)
> > +$(SUBCMDOBJ): fixdep FORCE | $(OUTPUT)/libsubcmd
> > +       $(Q)$(MAKE) -C $(SUBCMD_SRC) OUTPUT=$(abspath $(dir $@))/ $(abspath $@)
> >
> > -$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)
> > +$(BPFOBJ): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_SRC)/Makefile) | $(OUTPUT)/libbpf
> >         $(Q)$(MAKE) $(submake_extras) -C $(LIBBPF_SRC)  OUTPUT=$(abspath $(dir $@))/ $(abspath $@)
> >
> >  CFLAGS := -g \
> > @@ -57,23 +57,19 @@ LIBS = -lelf -lz
> >  export srctree OUTPUT CFLAGS Q
> >  include $(srctree)/tools/build/Makefile.include
> >
> > -$(BINARY_IN): fixdep FORCE
> > +$(BINARY_IN): fixdep FORCE | $(OUTPUT)
> >         $(Q)$(MAKE) $(build)=resolve_btfids
> >
> >  $(BINARY): $(BPFOBJ) $(SUBCMDOBJ) $(BINARY_IN)
> >         $(call msg,LINK,$@)
> >         $(Q)$(CC) $(BINARY_IN) $(LDFLAGS) -o $@ $(BPFOBJ) $(SUBCMDOBJ) $(LIBS)
> >
> > -libsubcmd-clean:
> > -       $(Q)$(MAKE) -C $(SUBCMD_SRC) OUTPUT=$(OUTPUT) clean
> > -
> > -libbpf-clean:
> > -       $(Q)$(MAKE) -C $(LIBBPF_SRC) OUTPUT=$(OUTPUT) clean
> > -
> > -clean: libsubcmd-clean libbpf-clean fixdep-clean
> > +clean: fixdep-clean
> >         $(call msg,CLEAN,$(BINARY))
> >         $(Q)$(RM) -f $(BINARY); \
> >         $(RM) -rf $(if $(OUTPUT),$(OUTPUT),.)/feature; \
> > +       $(RM) -rf $(OUTPUT)libbpf; \
> > +       $(RM) -rf $(OUTPUT)libsubcmd; \
> 
> If someone specifies OUTPUT=bla, you will attempt to delete blalibbpf,
> not bla/libbpf

will add missing '/', thanks

jirka

