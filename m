Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBBB72BA03B
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 03:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbgKTCOI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 21:14:08 -0500
Received: from mga04.intel.com ([192.55.52.120]:44319 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726463AbgKTCOH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 21:14:07 -0500
IronPort-SDR: xfrB1+PzGLM71MI/bhRmZH7+8BqwnQijGnXRvU4kH55asgN84G/QYCGUNqc2UcuKlGSgK5WcRK
 c0NpmgATLF6g==
X-IronPort-AV: E=McAfee;i="6000,8403,9810"; a="168827765"
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="168827765"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2020 18:14:06 -0800
IronPort-SDR: V21RRoIMCFMvEp+LM3v1f9+MnOCBbOaD46zIIRRbMAndkvvN/vEZwOffUyeXCDaO1zfm14pOjk
 p4YF5HnRh2UQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,354,1599548400"; 
   d="scan'208";a="369015002"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Nov 2020 18:14:03 -0800
Date:   Fri, 20 Nov 2020 03:05:27 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 4/6] libbpf: add kernel module BTF support for
 CO-RE relocations
Message-ID: <20201120020527.GB26162@ranger.igk.intel.com>
References: <20201119232244.2776720-1-andrii@kernel.org>
 <20201119232244.2776720-5-andrii@kernel.org>
 <20201120004624.GA25728@ranger.igk.intel.com>
 <CAEf4BzbZihTe74R_mHU=6S0QcrXaKEFoubByP5HVRq6O-t6c-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbZihTe74R_mHU=6S0QcrXaKEFoubByP5HVRq6O-t6c-Q@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 05:24:43PM -0800, Andrii Nakryiko wrote:
> On Thu, Nov 19, 2020 at 4:55 PM Maciej Fijalkowski
> <maciej.fijalkowski@intel.com> wrote:
> >
> > On Thu, Nov 19, 2020 at 03:22:42PM -0800, Andrii Nakryiko wrote:
> > > Teach libbpf to search for candidate types for CO-RE relocations across kernel
> > > modules BTFs, in addition to vmlinux BTF. If at least one candidate type is
> > > found in vmlinux BTF, kernel module BTFs are not iterated. If vmlinux BTF has
> > > no matching candidates, then find all kernel module BTFs and search for all
> > > matching candidates across all of them.
> > >
> > > Kernel's support for module BTFs are inferred from the support for BTF name
> > > pointer in BPF UAPI.
> > >
> > > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > > ---
> > >  tools/lib/bpf/libbpf.c | 185 ++++++++++++++++++++++++++++++++++++++---
> > >  1 file changed, 172 insertions(+), 13 deletions(-)
> > >
> >
> > [...]
> >
> > > +static int probe_module_btf(void)
> > > +{
> > > +     static const char strs[] = "\0int";
> > > +     __u32 types[] = {
> > > +             /* int */
> > > +             BTF_TYPE_INT_ENC(1, BTF_INT_SIGNED, 0, 32, 4),
> > > +     };
> > > +     struct bpf_btf_info info;
> > > +     __u32 len = sizeof(info);
> > > +     char name[16];
> > > +     int fd, err;
> > > +
> > > +     fd = libbpf__load_raw_btf((char *)types, sizeof(types), strs, sizeof(strs));
> > > +     if (fd < 0)
> > > +             return 0; /* BTF not supported at all */
> > > +
> > > +     len = sizeof(info);
> >
> > nit: reinit of len
> >
> 
> oops, right, I'll remove it
> 
> 
> > > +     memset(&info, 0, sizeof(info));
> >
> > use len in memset
> 
> why?

Hm, just to make use of local var? We might argue that current version is
more readable, but then again I would question the len's existence.

Do whatever you want, these were just nits :)

> 
> >
> > > +     info.name = ptr_to_u64(name);
> > > +     info.name_len = sizeof(name);
> > > +
> > > +     /* check that BPF_OBJ_GET_INFO_BY_FD supports specifying name pointer;
> > > +      * kernel's module BTF support coincides with support for
> > > +      * name/name_len fields in struct bpf_btf_info.
> > > +      */
> > > +     err = bpf_obj_get_info_by_fd(fd, &info, &len);
> > > +     close(fd);
> > > +     return !err;
> > > +}
> >
> > [...]
