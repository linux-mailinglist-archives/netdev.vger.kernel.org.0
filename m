Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821CB44701E
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 20:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234924AbhKFTcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 15:32:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232498AbhKFTcA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Nov 2021 15:32:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BC7960E8B;
        Sat,  6 Nov 2021 19:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636226959;
        bh=SSh/MjS6+Voc6TzAoE/tOg6RTP+gVHgAW32sKjAaUmo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SXqJNXbi7+Hpa/cw0Vjccw8nQKSQMJkl7lXbA/6SwRDWDbDUdXr4dkb1l/OrrhWmM
         5mV9ebOfySX0U7bmMYdjX838818NsWyoNOuRVTzFzU5sIjvQsPkgnfcOIoidXWI7MD
         i729Kuh7MinnyKWhzQi8i/6/in5NGXaDxb/JueMNDMEJNFQfmuzQdQIN0Bb9Hx2wa+
         otJLWnHuZj/6esupGjPv1MP+18cBZEl6KsvHNX9UJHbkHz8Y45eXbPNJ6gvPMBia8S
         IAlzvfSvQTAd27KrSeAxSSWFZ9dOUCo5stT+Z4RVgyPYFO5eoAlCiDZLnD93us3Cfn
         J38uz+wCDksTA==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id C4C0C410A2; Sat,  6 Nov 2021 16:29:16 -0300 (-03)
Date:   Sat, 6 Nov 2021 16:29:16 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next] perf build: Install libbpf headers locally when
 building
Message-ID: <YYbXjE1aAdNjI+aY@kernel.org>
References: <20211105020244.6869-1-quentin@isovalent.com>
 <CAEf4Bza_-vvOXPRZaJzi4YpU5Bfb=werLUFG=Au9DtaanbuArg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza_-vvOXPRZaJzi4YpU5Bfb=werLUFG=Au9DtaanbuArg@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Nov 05, 2021 at 11:38:50AM -0700, Andrii Nakryiko escreveu:
> On Thu, Nov 4, 2021 at 7:02 PM Quentin Monnet <quentin@isovalent.com> wrote:
> >
> > API headers from libbpf should not be accessed directly from the
> > library's source directory. Instead, they should be exported with "make
> > install_headers". Let's adjust perf's Makefile to install those headers
> > locally when building libbpf.
> >
> > Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> > ---
> > Note: Sending to bpf-next because it's directly related to libbpf, and
> > to similar patches merged through bpf-next, but maybe Arnaldo prefers to
> > take it?
> 
> Arnaldo would know better how to thoroughly test it, so I'd prefer to
> route this through perf tree. Any objections, Arnaldo?

Preliminary testing passed for 'BUILD_BPF_SKEL=1' with without
LIBBPF_DYNAMIC=1 (using the system's libbpf-devel to build perf), so far
so good, so I tentatively applied it, will see with the full set of
containers.

Thanks!

- Arnaldo
 
> > ---
> >  tools/perf/Makefile.perf | 24 +++++++++++++-----------
> >  1 file changed, 13 insertions(+), 11 deletions(-)
> >
> > diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> > index b856afa6eb52..3a81b6c712a9 100644
> > --- a/tools/perf/Makefile.perf
> > +++ b/tools/perf/Makefile.perf
> > @@ -241,7 +241,7 @@ else # force_fixdep
> >
> >  LIB_DIR         = $(srctree)/tools/lib/api/
> >  TRACE_EVENT_DIR = $(srctree)/tools/lib/traceevent/
> > -BPF_DIR         = $(srctree)/tools/lib/bpf/
> > +LIBBPF_DIR      = $(srctree)/tools/lib/bpf/
> >  SUBCMD_DIR      = $(srctree)/tools/lib/subcmd/
> >  LIBPERF_DIR     = $(srctree)/tools/lib/perf/
> >  DOC_DIR         = $(srctree)/tools/perf/Documentation/
> > @@ -293,7 +293,6 @@ strip-libs = $(filter-out -l%,$(1))
> >  ifneq ($(OUTPUT),)
> >    TE_PATH=$(OUTPUT)
> >    PLUGINS_PATH=$(OUTPUT)
> > -  BPF_PATH=$(OUTPUT)
> >    SUBCMD_PATH=$(OUTPUT)
> >    LIBPERF_PATH=$(OUTPUT)
> >  ifneq ($(subdir),)
> > @@ -305,7 +304,6 @@ else
> >    TE_PATH=$(TRACE_EVENT_DIR)
> >    PLUGINS_PATH=$(TRACE_EVENT_DIR)plugins/
> >    API_PATH=$(LIB_DIR)
> > -  BPF_PATH=$(BPF_DIR)
> >    SUBCMD_PATH=$(SUBCMD_DIR)
> >    LIBPERF_PATH=$(LIBPERF_DIR)
> >  endif
> > @@ -324,7 +322,10 @@ LIBTRACEEVENT_DYNAMIC_LIST_LDFLAGS = $(if $(findstring -static,$(LDFLAGS)),,$(DY
> >  LIBAPI = $(API_PATH)libapi.a
> >  export LIBAPI
> >
> > -LIBBPF = $(BPF_PATH)libbpf.a
> > +LIBBPF_OUTPUT = $(OUTPUT)libbpf
> > +LIBBPF_DESTDIR = $(LIBBPF_OUTPUT)
> > +LIBBPF_INCLUDE = $(LIBBPF_DESTDIR)/include
> > +LIBBPF = $(LIBBPF_OUTPUT)/libbpf.a
> >
> >  LIBSUBCMD = $(SUBCMD_PATH)libsubcmd.a
> >
> > @@ -829,12 +830,14 @@ $(LIBAPI)-clean:
> >         $(call QUIET_CLEAN, libapi)
> >         $(Q)$(MAKE) -C $(LIB_DIR) O=$(OUTPUT) clean >/dev/null
> >
> > -$(LIBBPF): FORCE
> > -       $(Q)$(MAKE) -C $(BPF_DIR) O=$(OUTPUT) $(OUTPUT)libbpf.a FEATURES_DUMP=$(FEATURE_DUMP_EXPORT)
> > +$(LIBBPF): FORCE | $(LIBBPF_OUTPUT)
> > +       $(Q)$(MAKE) -C $(LIBBPF_DIR) FEATURES_DUMP=$(FEATURE_DUMP_EXPORT) \
> > +               O= OUTPUT=$(LIBBPF_OUTPUT)/ DESTDIR=$(LIBBPF_DESTDIR) prefix= \
> > +               $@ install_headers
> >
> >  $(LIBBPF)-clean:
> >         $(call QUIET_CLEAN, libbpf)
> > -       $(Q)$(MAKE) -C $(BPF_DIR) O=$(OUTPUT) clean >/dev/null
> > +       $(Q)$(RM) -r -- $(LIBBPF_OUTPUT)
> >
> >  $(LIBPERF): FORCE
> >         $(Q)$(MAKE) -C $(LIBPERF_DIR) EXTRA_CFLAGS="$(LIBPERF_CFLAGS)" O=$(OUTPUT) $(OUTPUT)libperf.a
> > @@ -1036,14 +1039,13 @@ SKELETONS += $(SKEL_OUT)/bperf_cgroup.skel.h
> >
> >  ifdef BUILD_BPF_SKEL
> >  BPFTOOL := $(SKEL_TMP_OUT)/bootstrap/bpftool
> > -LIBBPF_SRC := $(abspath ../lib/bpf)
> > -BPF_INCLUDE := -I$(SKEL_TMP_OUT)/.. -I$(BPF_PATH) -I$(LIBBPF_SRC)/..
> > +BPF_INCLUDE := -I$(SKEL_TMP_OUT)/.. -I$(LIBBPF_INCLUDE)
> >
> > -$(SKEL_TMP_OUT):
> > +$(SKEL_TMP_OUT) $(LIBBPF_OUTPUT):
> >         $(Q)$(MKDIR) -p $@
> >
> >  $(BPFTOOL): | $(SKEL_TMP_OUT)
> > -       CFLAGS= $(MAKE) -C ../bpf/bpftool \
> > +       $(Q)CFLAGS= $(MAKE) -C ../bpf/bpftool \
> >                 OUTPUT=$(SKEL_TMP_OUT)/ bootstrap
> >
> >  VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)                           \
> > --
> > 2.32.0
> >

-- 

- Arnaldo
