Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB9A11B22A
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 16:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388019AbfLKPeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 10:34:10 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56290 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387713AbfLKPeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 10:34:08 -0500
Received: by mail-wm1-f65.google.com with SMTP id q9so7573102wmj.5
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 07:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lDDrszLPnilx0jPK4tk0qYbCjSVXUJ6eZqARRqvSAeg=;
        b=cyiouAHGRHlxa+ExJOaDN4saJmnsZWqRXLpcgxFvX7KE7V31+8c4w+/25P0g4Cxc2e
         N0Pj0hwJbF40DdM2bwzIilmoYeWcSXx4Swosr+et5TtXJ61mDvZRXUgDybMboJMHrEJs
         9rocHG17hoO1HJPZ+xLXnTFXjCct9FZwiX8pg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lDDrszLPnilx0jPK4tk0qYbCjSVXUJ6eZqARRqvSAeg=;
        b=CleKDuT0QCrPsFDLgQBDAtQIBQE9bRPj2hoGh0k5rprXaCTSOZJWUPZOY41PM4vmv5
         cXbnP1iykxQ1LbATXvpZ9VNfC640Bz7c/u78Qy6tYb4qjCtZ3wKSt98S/fckDzHT/vDY
         LWgWmFrU3Se7PrvVshlQmbZ0SDHGLiyTadCgcHaIt9e7BEIGXD01ZsuZbdPaXedRWLdP
         B8rsZADQuPbFpNPZZFlpMyXcrMYw2tBET7sF1jj3TcdO2JpH5jvfn+QUPBHW7fD8pQsS
         MK88SE7j7ueRqOLCDpJpZJAmvvMYHcty001y6/1zZfouYKGsMrRuHNNjXJzs4zgxaXTR
         xLdw==
X-Gm-Message-State: APjAAAUwBLK2KOWFE9BXCFis00WnGwPxKaHgsSyMgRcooFJTSL+++3so
        VJ4vkj/Pvq1JOJWnyIonLbHa2Rx69CaenQD9y4arnw==
X-Google-Smtp-Source: APXvYqxDyCcqFvBGR6AMAsi6IK0EYTM4K9QMD7DR1JrSdOHDM/CrSBaTQ2IwQvrXorVr6dfJUQZF6KlSeLNVAku2SeY=
X-Received: by 2002:a1c:7310:: with SMTP id d16mr368146wmb.165.1576078443944;
 Wed, 11 Dec 2019 07:34:03 -0800 (PST)
MIME-Version: 1.0
References: <20191201195728.4161537-1-aurelien@aurel32.net>
 <87zhgbe0ix.fsf@mpe.ellerman.id.au> <20191202093752.GA1535@localhost.localdomain>
 <CAFxkdAqg6RaGbRrNN3e_nHfHFR-xxzZgjhi5AnppTxxwdg0VyQ@mail.gmail.com> <20191210222553.GA4580@calabresa>
In-Reply-To: <20191210222553.GA4580@calabresa>
From:   Justin Forbes <jmforbes@linuxtx.org>
Date:   Wed, 11 Dec 2019 09:33:53 -0600
Message-ID: <CAFxkdAp6Up0qSyp0sH0O1yD+5W3LvY-+-iniBrorcz2pMV+y-g@mail.gmail.com>
Subject: Re: [PATCH] libbpf: fix readelf output parsing on powerpc with recent binutils
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org,
        Martin KaFai Lau <kafai@fb.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        debian-kernel@lists.debian.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 10, 2019 at 4:26 PM Thadeu Lima de Souza Cascardo
<cascardo@canonical.com> wrote:
>
> On Tue, Dec 10, 2019 at 12:58:33PM -0600, Justin Forbes wrote:
> > On Mon, Dec 2, 2019 at 3:37 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > >
> > > On Mon, Dec 02, 2019 at 04:53:26PM +1100, Michael Ellerman wrote:
> > > > Aurelien Jarno <aurelien@aurel32.net> writes:
> > > > > On powerpc with recent versions of binutils, readelf outputs an extra
> > > > > field when dumping the symbols of an object file. For example:
> > > > >
> > > > >     35: 0000000000000838    96 FUNC    LOCAL  DEFAULT [<localentry>: 8]     1 btf_is_struct
> > > > >
> > > > > The extra "[<localentry>: 8]" prevents the GLOBAL_SYM_COUNT variable to
> > > > > be computed correctly and causes the checkabi target to fail.
> > > > >
> > > > > Fix that by looking for the symbol name in the last field instead of the
> > > > > 8th one. This way it should also cope with future extra fields.
> > > > >
> > > > > Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> > > > > ---
> > > > >  tools/lib/bpf/Makefile | 4 ++--
> > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > >
> > > > Thanks for fixing that, it's been on my very long list of test failures
> > > > for a while.
> > > >
> > > > Tested-by: Michael Ellerman <mpe@ellerman.id.au>
> > >
> > > Looks good & also continues to work on x86. Applied, thanks!
> >
> > This actually seems to break horribly on PPC64le with binutils 2.33.1
> > resulting in:
> > Warning: Num of global symbols in sharedobjs/libbpf-in.o (32) does NOT
> > match with num of versioned symbols in libbpf.so (184). Please make
> > sure all LIBBPF_API symbols are versioned in libbpf.map.
> >
> > This is the only arch that fails, with x86/arm/aarch64/s390 all
> > building fine.  Reverting this patch allows successful build across
> > all arches.
> >
> > Justin
>
> Well, I ended up debugging this same issue and had the same fix as Jarno's when
> I noticed his fix was already applied.
>
> I just installed a system with the latest binutils, 2.33.1, and it still breaks
> without such fix. Can you tell what is the output of the following command on
> your system?
>
> readelf -s --wide tools/lib/bpf/sharedobjs/libbpf-in.o | cut -d "@" -f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' | awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $0}'
>

readelf -s --wide tools/lib/bpf/sharedobjs/libbpf-in.o | cut -d "@"
-f1 | sed 's/_v[0-9]_[0-9]_[0-9].*//' | awk '/GLOBAL/ && /DEFAULT/ &&
!/UND/ {print $0}'
   373: 00000000000141bc  1376 FUNC    GLOBAL DEFAULT    1
libbpf_num_possible_cpus [<localentry>: 8]
   375: 000000000001869c   176 FUNC    GLOBAL DEFAULT    1 btf__free
[<localentry>: 8]
   377: 000000000001093c    84 FUNC    GLOBAL DEFAULT    1
bpf_object__find_map_by_offset [<localentry>: 8]
   378: 0000000000016288   100 FUNC    GLOBAL DEFAULT    1
bpf_prog_get_next_id [<localentry>: 8]
   379: 00000000000103c0   104 FUNC    GLOBAL DEFAULT    1
bpf_map__priv [<localentry>: 8]
   380: 000000000000e158   180 FUNC    GLOBAL DEFAULT    1
bpf_object__pin [<localentry>: 8]
   381: 00000000000102f8   200 FUNC    GLOBAL DEFAULT    1
bpf_map__set_priv [<localentry>: 8]
   382: 000000000001874c   380 FUNC    GLOBAL DEFAULT    1 btf__new
[<localentry>: 8]
   384: 000000000002238c  1372 FUNC    GLOBAL DEFAULT    1 xsk_umem__create
   385: 00000000000106fc   116 FUNC    GLOBAL DEFAULT    1
bpf_map__next [<localentry>: 8]
   387: 00000000000162ec   100 FUNC    GLOBAL DEFAULT    1
bpf_map_get_next_id [<localentry>: 8]
   389: 000000000000f574    84 FUNC    GLOBAL DEFAULT    1
bpf_program__is_xdp [<localentry>: 8]
   390: 0000000000011e14   392 FUNC    GLOBAL DEFAULT    1
bpf_program__attach_tracepoint [<localentry>: 8]
   391: 0000000000016534   196 FUNC    GLOBAL DEFAULT    1
bpf_obj_get_info_by_fd [<localentry>: 8]
   392: 000000000000cf64   324 FUNC    GLOBAL DEFAULT    1
bpf_program__unpin_instance [<localentry>: 8]
   393: 000000000000d818   456 FUNC    GLOBAL DEFAULT    1
bpf_map__unpin [<localentry>: 8]
   395: 000000000000efe0    64 FUNC    GLOBAL DEFAULT    1 bpf_program__set_type
   396: 0000000000010e94   696 FUNC    GLOBAL DEFAULT    1
bpf_program__attach_perf_event [<localentry>: 8]
   397: 000000000001a774   136 FUNC    GLOBAL DEFAULT    1
btf_ext__reloc_func_info [<localentry>: 8]
   398: 0000000000014bc8   236 FUNC    GLOBAL DEFAULT    1
bpf_create_map_name [<localentry>: 8]
   402: 00000000000228e8   160 FUNC    GLOBAL DEFAULT    1 xsk_umem__create
   403: 0000000000021f1c    72 FUNC    GLOBAL DEFAULT    1 xsk_socket__fd
   404: 000000000001a8ec   536 FUNC    GLOBAL DEFAULT    1 btf__dedup
[<localentry>: 8]
   405: 000000000000eadc   180 FUNC    GLOBAL DEFAULT    1
bpf_program__set_priv [<localentry>: 8]
   409: 000000000000c540   144 FUNC    GLOBAL DEFAULT    1
bpf_object__open_file [<localentry>: 8]
   410: 00000000000121a8   416 FUNC    GLOBAL DEFAULT    1
bpf_program__attach_trace [<localentry>: 8]
   415: 000000000000d51c   764 FUNC    GLOBAL DEFAULT    1
bpf_map__pin [<localentry>: 8]
   416: 00000000000154d0   212 FUNC    GLOBAL DEFAULT    1
bpf_load_program [<localentry>: 8]
   418: 0000000000010810   192 FUNC    GLOBAL DEFAULT    1
bpf_object__find_map_by_name [<localentry>: 8]
   420: 0000000000012348   580 FUNC    GLOBAL DEFAULT    1
bpf_perf_event_read_simple [<localentry>: 8]
   421: 00000000000191e8   220 FUNC    GLOBAL DEFAULT    1
btf__finalize_data [<localentry>: 8]
   422: 0000000000010a80   724 FUNC    GLOBAL DEFAULT    1
bpf_prog_load_xattr [<localentry>: 8]
   423: 000000000000f688   108 FUNC    GLOBAL DEFAULT    1
bpf_program__set_tracing [<localentry>: 8]
   424: 0000000000018560   316 FUNC    GLOBAL DEFAULT    1
btf__find_by_name_kind [<localentry>: 8]
   426: 00000000000163b4   128 FUNC    GLOBAL DEFAULT    1
bpf_prog_get_fd_by_id [<localentry>: 8]
   427: 000000000001a884    52 FUNC    GLOBAL DEFAULT    1
btf_ext__func_info_rec_size
   428: 0000000000025654   480 FUNC    GLOBAL DEFAULT    1
btf_dump__new [<localentry>: 8]
   429: 0000000000010770   160 FUNC    GLOBAL DEFAULT    1
bpf_map__prev [<localentry>: 8]
   431: 0000000000011968   504 FUNC    GLOBAL DEFAULT    1
bpf_program__attach_uprobe [<localentry>: 8]
   432: 00000000000011ac   416 FUNC    GLOBAL DEFAULT    1
bpf_program__unload [<localentry>: 8]
   433: 000000000000ea50   140 FUNC    GLOBAL DEFAULT    1
bpf_program__prev [<localentry>: 8]
   434: 00000000000149cc   280 FUNC    GLOBAL DEFAULT    1
bpf_create_map_node [<localentry>: 8]
   435: 000000000001a28c   116 FUNC    GLOBAL DEFAULT    1
btf_ext__free [<localentry>: 8]
   436: 000000000001668c   420 FUNC    GLOBAL DEFAULT    1
bpf_load_btf [<localentry>: 8]
   438: 0000000000013988  1564 FUNC    GLOBAL DEFAULT    1
bpf_program__get_prog_info_linear [<localentry>: 8]
   439: 000000000000e034   292 FUNC    GLOBAL DEFAULT    1
bpf_object__unpin_programs [<localentry>: 8]
   440: 000000000000ece0    88 FUNC    GLOBAL DEFAULT    1
bpf_program__fd [<localentry>: 8]
   441: 000000000000f634    84 FUNC    GLOBAL DEFAULT    1
bpf_program__is_perf_event [<localentry>: 8]
   442: 0000000000021094   304 FUNC    GLOBAL DEFAULT    1 bpf_prog_linfo__lfind
   444: 000000000000c764   324 FUNC    GLOBAL DEFAULT    1
bpf_object__unload [<localentry>: 8]
   449: 0000000000019558   692 FUNC    GLOBAL DEFAULT    1
btf__get_from_id [<localentry>: 8]
   453: 000000000000f088   108 FUNC    GLOBAL DEFAULT    1
bpf_program__set_socket_filter [<localentry>: 8]
   454: 0000000000015b24   148 FUNC    GLOBAL DEFAULT    1 bpf_obj_pin
[<localentry>: 8]
   456: 0000000000014cb4   336 FUNC    GLOBAL DEFAULT    1
bpf_create_map_in_map_node [<localentry>: 8]
   457: 0000000000015bb8   132 FUNC    GLOBAL DEFAULT    1 bpf_obj_get
[<localentry>: 8]
   458: 0000000000024050   436 FUNC    GLOBAL DEFAULT    1
xsk_socket__delete [<localentry>: 8]
   459: 000000000000106c    88 FUNC    GLOBAL DEFAULT    1
libbpf_set_print [<localentry>: 8]
   460: 000000000000f1b4    84 FUNC    GLOBAL DEFAULT    1
bpf_program__is_kprobe [<localentry>: 8]
   461: 0000000000012c6c   244 FUNC    GLOBAL DEFAULT    1
perf_buffer__new_raw [<localentry>: 8]
   462: 000000000000e74c   180 FUNC    GLOBAL DEFAULT    1
bpf_object__set_priv [<localentry>: 8]
   463: 000000000001046c    68 FUNC    GLOBAL DEFAULT    1 bpf_map__is_internal
   464: 000000000000e20c   828 FUNC    GLOBAL DEFAULT    1
bpf_object__close [<localentry>: 8]
   466: 0000000000010220    72 FUNC    GLOBAL DEFAULT    1 bpf_map__name
   467: 0000000000013fa4   268 FUNC    GLOBAL DEFAULT    1
bpf_program__bpil_addr_to_offs [<localentry>: 8]
   468: 000000000001f880   684 FUNC    GLOBAL DEFAULT    1
bpf_set_link_xdp_fd [<localentry>: 8]
   469: 000000000000f6f4    84 FUNC    GLOBAL DEFAULT    1
bpf_program__is_tracing [<localentry>: 8]
   470: 000000000000dce4   348 FUNC    GLOBAL DEFAULT    1
bpf_object__unpin_maps [<localentry>: 8]
   471: 000000000000efac    52 FUNC    GLOBAL DEFAULT    1 bpf_program__get_type
   472: 00000000000259a4   548 FUNC    GLOBAL DEFAULT    1
btf_dump__dump_type [<localentry>: 8]
   476: 0000000000018458   264 FUNC    GLOBAL DEFAULT    1
btf__find_by_name [<localentry>: 8]
   477: 000000000000dad0    52 FUNC    GLOBAL DEFAULT    1 bpf_map__is_pinned
   478: 000000000000f748    52 FUNC    GLOBAL DEFAULT    1
bpf_program__get_expected_attach_type
   479: 00000000000104f0   196 FUNC    GLOBAL DEFAULT    1
bpf_map__set_inner_map_fd [<localentry>: 8]
   480: 0000000000021ed4    72 FUNC    GLOBAL DEFAULT    1 xsk_umem__fd
   481: 00000000000101b8   104 FUNC    GLOBAL DEFAULT    1
bpf_map__def [<localentry>: 8]
   482: 0000000000015c3c   188 FUNC    GLOBAL DEFAULT    1
bpf_prog_attach [<localentry>: 8]
   483: 000000000000e6d8   116 FUNC    GLOBAL DEFAULT    1
bpf_object__btf_fd [<localentry>: 8]
   485: 000000000000db04   480 FUNC    GLOBAL DEFAULT    1
bpf_object__pin_maps [<localentry>: 8]
   487: 0000000000020bd0   772 FUNC    GLOBAL DEFAULT    1
bpf_prog_linfo__new [<localentry>: 8]
   488: 0000000000016050   388 FUNC    GLOBAL DEFAULT    1
bpf_prog_test_run_xattr [<localentry>: 8]
   490: 000000000001a8b8    52 FUNC    GLOBAL DEFAULT    1
btf_ext__line_info_rec_size
   492: 0000000000015aa4   128 FUNC    GLOBAL DEFAULT    1
bpf_map_freeze [<localentry>: 8]
   493: 00000000000194ac    72 FUNC    GLOBAL DEFAULT    1 btf__get_raw_data
   494: 000000000000ed70   300 FUNC    GLOBAL DEFAULT    1
bpf_program__set_prep [<localentry>: 8]
   497: 0000000000014e04   156 FUNC    GLOBAL DEFAULT    1
bpf_create_map_in_map [<localentry>: 8]
   501: 0000000000014ae4   228 FUNC    GLOBAL DEFAULT    1
bpf_create_map [<localentry>: 8]
   502: 000000000000f77c    64 FUNC    GLOBAL DEFAULT    1
bpf_program__set_expected_attach_type
   503: 000000000000f388   108 FUNC    GLOBAL DEFAULT    1
bpf_program__set_tracepoint [<localentry>: 8]
   504: 0000000000010428    68 FUNC    GLOBAL DEFAULT    1
bpf_map__is_offload_neutral
   505: 00000000000159fc   168 FUNC    GLOBAL DEFAULT    1
bpf_map_get_next_key [<localentry>: 8]
   506: 0000000000018328   304 FUNC    GLOBAL DEFAULT    1
btf__resolve_type [<localentry>: 8]
   507: 00000000000108d0   108 FUNC    GLOBAL DEFAULT    1
bpf_object__find_map_fd_by_name [<localentry>: 8]
   508: 000000000001580c   180 FUNC    GLOBAL DEFAULT    1
bpf_map_lookup_elem_flags [<localentry>: 8]
   511: 000000000000c4d8   104 FUNC    GLOBAL DEFAULT    1
bpf_object__open [<localentry>: 8]
   513: 000000000000f274    84 FUNC    GLOBAL DEFAULT    1
bpf_program__is_sched_cls [<localentry>: 8]
   514: 000000000001a4e0    72 FUNC    GLOBAL DEFAULT    1 btf_ext__get_raw_data
   515: 000000000000e5e4   100 FUNC    GLOBAL DEFAULT    1
bpf_object__name [<localentry>: 8]
   516: 00000000000158c0   168 FUNC    GLOBAL DEFAULT    1
bpf_map_lookup_and_delete_elem [<localentry>: 8]
   518: 00000000000228e8   160 FUNC    GLOBAL DEFAULT    1 xsk_umem__create
   520: 000000000002238c  1372 FUNC    GLOBAL DEFAULT    1 xsk_umem__create
   522: 000000000000e800   104 FUNC    GLOBAL DEFAULT    1
bpf_object__priv [<localentry>: 8]
   523: 00000000000066c8   728 FUNC    GLOBAL DEFAULT    1
bpf_map__reuse_fd [<localentry>: 8]
   524: 000000000000da9c    52 FUNC    GLOBAL DEFAULT    1 bpf_map__get_pin_path
   525: 000000000000ffe8   392 FUNC    GLOBAL DEFAULT    1
libbpf_attach_type_by_name [<localentry>: 8]
   526: 000000000000e648    72 FUNC    GLOBAL DEFAULT    1 bpf_object__kversion
   527: 000000000000d330   492 FUNC    GLOBAL DEFAULT    1
bpf_program__unpin [<localentry>: 8]
   529: 00000000000126ac   336 FUNC    GLOBAL DEFAULT    1
perf_buffer__free [<localentry>: 8]
   532: 0000000000014fd8  1272 FUNC    GLOBAL DEFAULT    1
bpf_load_program_xattr [<localentry>: 8]
   533: 00000000000165f8   148 FUNC    GLOBAL DEFAULT    1
bpf_raw_tracepoint_open [<localentry>: 8]
   535: 000000000000c8a8   504 FUNC    GLOBAL DEFAULT    1
bpf_object__load_xattr [<localentry>: 8]
   537: 0000000000015e34   248 FUNC    GLOBAL DEFAULT    1
bpf_prog_query [<localentry>: 8]
   542: 000000000001a7fc   136 FUNC    GLOBAL DEFAULT    1
btf_ext__reloc_line_info [<localentry>: 8]
   543: 000000000000e9c4   140 FUNC    GLOBAL DEFAULT    1
bpf_program__next [<localentry>: 8]
   544: 0000000000019478    52 FUNC    GLOBAL DEFAULT    1 btf__fd
   545: 0000000000017f80   104 FUNC    GLOBAL DEFAULT    1 btf__type_by_id
   546: 000000000000c65c   264 FUNC    GLOBAL DEFAULT    1
bpf_object__open_buffer [<localentry>: 8]
   548: 0000000000015d8c   168 FUNC    GLOBAL DEFAULT    1
bpf_prog_detach2 [<localentry>: 8]
   549: 000000000000fadc   424 FUNC    GLOBAL DEFAULT    1
libbpf_find_vmlinux_btf_id [<localentry>: 8]
   550: 0000000000010170    72 FUNC    GLOBAL DEFAULT    1 bpf_map__fd
   552: 0000000000010990    80 FUNC    GLOBAL DEFAULT    1
libbpf_get_error [<localentry>: 8]
   554: 000000000000caa0   120 FUNC    GLOBAL DEFAULT    1
bpf_object__load [<localentry>: 8]
   556: 0000000000021960   848 FUNC    GLOBAL DEFAULT    1
bpf_probe_map_type [<localentry>: 8]
   557: 00000000000237a0  1912 FUNC    GLOBAL DEFAULT    1
xsk_socket__create [<localentry>: 8]
   559: 000000000000f960   380 FUNC    GLOBAL DEFAULT    1
libbpf_prog_type_by_name [<localentry>: 8]
   560: 0000000000005b14   192 FUNC    GLOBAL DEFAULT    1
bpf_object__find_program_by_title [<localentry>: 8]
   563: 000000000000f5c8   108 FUNC    GLOBAL DEFAULT    1
bpf_program__set_perf_event [<localentry>: 8]
   564: 000000000000ed38    56 FUNC    GLOBAL DEFAULT    1 bpf_program__size
   565: 000000000000f334    84 FUNC    GLOBAL DEFAULT    1
bpf_program__is_sched_act [<localentry>: 8]
   566: 00000000000156b0   180 FUNC    GLOBAL DEFAULT    1
bpf_map_update_elem [<localentry>: 8]
   568: 000000000000f4b4    84 FUNC    GLOBAL DEFAULT    1
bpf_program__is_raw_tracepoint [<localentry>: 8]
   569: 000000000001890c  1468 FUNC    GLOBAL DEFAULT    1
btf__parse_elf [<localentry>: 8]
   570: 000000000000e690    72 FUNC    GLOBAL DEFAULT    1 bpf_object__btf
   571: 000000000000f448   108 FUNC    GLOBAL DEFAULT    1
bpf_program__set_raw_tracepoint [<localentry>: 8]
   578: 000000000000f2c8   108 FUNC    GLOBAL DEFAULT    1
bpf_program__set_sched_act [<localentry>: 8]
   579: 0000000000025834   368 FUNC    GLOBAL DEFAULT    1
btf_dump__free [<localentry>: 8]
   580: 000000000000f3f4    84 FUNC    GLOBAL DEFAULT    1
bpf_program__is_tracepoint [<localentry>: 8]
   581: 0000000000020ed4   448 FUNC    GLOBAL DEFAULT    1
bpf_prog_linfo__lfind_addr_func
   582: 00000000000164b4   128 FUNC    GLOBAL DEFAULT    1
bpf_btf_get_fd_by_id [<localentry>: 8]
   583: 00000000000192c4   436 FUNC    GLOBAL DEFAULT    1 btf__load
[<localentry>: 8]
   584: 000000000000f508   108 FUNC    GLOBAL DEFAULT    1
bpf_program__set_xdp [<localentry>: 8]
   587: 0000000000016830   372 FUNC    GLOBAL DEFAULT    1
bpf_task_fd_query [<localentry>: 8]
   591: 0000000000015cf8   148 FUNC    GLOBAL DEFAULT    1
bpf_prog_detach [<localentry>: 8]
   593: 000000000000c5d0   140 FUNC    GLOBAL DEFAULT    1
bpf_object__open_mem [<localentry>: 8]
   594: 0000000000015968   148 FUNC    GLOBAL DEFAULT    1
bpf_map_delete_elem [<localentry>: 8]
   595: 0000000000021cb0   548 FUNC    GLOBAL DEFAULT    1
bpf_probe_helper [<localentry>: 8]
   596: 0000000000011784   484 FUNC    GLOBAL DEFAULT    1
bpf_program__attach_kprobe [<localentry>: 8]
   597: 00000000000069a0   124 FUNC    GLOBAL DEFAULT    1 bpf_map__resize
   599: 0000000000020b20   176 FUNC    GLOBAL DEFAULT    1
bpf_prog_linfo__free [<localentry>: 8]
   601: 000000000000ee9c   272 FUNC    GLOBAL DEFAULT    1
bpf_program__nth_fd [<localentry>: 8]
   602: 0000000000010d54   144 FUNC    GLOBAL DEFAULT    1
bpf_link__destroy [<localentry>: 8]
   604: 00000000000102b0    72 FUNC    GLOBAL DEFAULT    1
bpf_map__btf_value_type_id
   606: 0000000000020070   184 FUNC    GLOBAL DEFAULT    1
bpf_get_link_xdp_id [<localentry>: 8]
   608: 000000000000d0a8   648 FUNC    GLOBAL DEFAULT    1
bpf_program__pin [<localentry>: 8]
   609: 000000000001f100   380 FUNC    GLOBAL DEFAULT    1
libbpf_strerror [<localentry>: 8]
   610: 00000000000104b0    64 FUNC    GLOBAL DEFAULT    1 bpf_map__set_ifindex
   611: 000000000000de40   500 FUNC    GLOBAL DEFAULT    1
bpf_object__pin_programs [<localentry>: 8]
   612: 000000000001fde0   476 FUNC    GLOBAL DEFAULT    1
bpf_get_link_xdp_info [<localentry>: 8]
   613: 0000000000015764   168 FUNC    GLOBAL DEFAULT    1
bpf_map_lookup_elem [<localentry>: 8]
   614: 000000000000d9e0   188 FUNC    GLOBAL DEFAULT    1
bpf_map__set_pin_path [<localentry>: 8]
   616: 0000000000012000   424 FUNC    GLOBAL DEFAULT    1
bpf_program__attach_raw_tracepoint [<localentry>: 8]
   617: 0000000000023f18   312 FUNC    GLOBAL DEFAULT    1
xsk_umem__delete [<localentry>: 8]
   618: 000000000000eb90   104 FUNC    GLOBAL DEFAULT    1
bpf_program__priv [<localentry>: 8]
   619: 00000000000180e0   584 FUNC    GLOBAL DEFAULT    1
btf__resolve_size [<localentry>: 8]
   620: 00000000000155a4   268 FUNC    GLOBAL DEFAULT    1
bpf_verify_program [<localentry>: 8]
   621: 000000000000b8ec  1000 FUNC    GLOBAL DEFAULT    1
bpf_program__load [<localentry>: 8]
   623: 00000000000194f4   100 FUNC    GLOBAL DEFAULT    1 btf__name_by_offset
   624: 000000000000f148   108 FUNC    GLOBAL DEFAULT    1
bpf_program__set_kprobe [<localentry>: 8]
   625: 00000000000140b0   268 FUNC    GLOBAL DEFAULT    1
bpf_program__bpil_offs_to_addr [<localentry>: 8]
   626: 0000000000016434   128 FUNC    GLOBAL DEFAULT    1
bpf_map_get_fd_by_id [<localentry>: 8]
   627: 0000000000017f4c    52 FUNC    GLOBAL DEFAULT    1 btf__get_nr_types
   628: 00000000000215c0   340 FUNC    GLOBAL DEFAULT    1
bpf_probe_prog_type [<localentry>: 8]
   632: 000000000000c484    84 FUNC    GLOBAL DEFAULT    1
bpf_object__open_xattr [<localentry>: 8]
   633: 000000000000cda8   444 FUNC    GLOBAL DEFAULT    1
bpf_program__pin_instance [<localentry>: 8]
   635: 00000000000109e0   160 FUNC    GLOBAL DEFAULT    1
bpf_prog_load [<localentry>: 8]
   637: 0000000000015f2c   292 FUNC    GLOBAL DEFAULT    1
bpf_prog_test_run [<localentry>: 8]
   638: 00000000000136a4   312 FUNC    GLOBAL DEFAULT    1
perf_buffer__poll [<localentry>: 8]
   640: 0000000000010268    72 FUNC    GLOBAL DEFAULT    1
bpf_map__btf_key_type_id
   641: 000000000000f0f4    84 FUNC    GLOBAL DEFAULT    1
bpf_program__is_socket_filter [<localentry>: 8]
   643: 000000000001980c   968 FUNC    GLOBAL DEFAULT    1
btf__get_map_kv_tids [<localentry>: 8]
   645: 000000000001a300   480 FUNC    GLOBAL DEFAULT    1
btf_ext__new [<localentry>: 8]
   647: 0000000000012ab8   436 FUNC    GLOBAL DEFAULT    1
perf_buffer__new [<localentry>: 8]
   648: 000000000000f208   108 FUNC    GLOBAL DEFAULT    1
bpf_program__set_sched_cls [<localentry>: 8]
   649: 000000000000ec38   168 FUNC    GLOBAL DEFAULT    1
bpf_program__title [<localentry>: 8]
   650: 0000000000016350   100 FUNC    GLOBAL DEFAULT    1
bpf_btf_get_next_id [<localentry>: 8]
   653: 000000000001485c   368 FUNC    GLOBAL DEFAULT    1
bpf_create_map_xattr [<localentry>: 8]
   656: 000000000000e548   156 FUNC    GLOBAL DEFAULT    1
bpf_object__next [<localentry>: 8]
   657: 000000000000ebf8    64 FUNC    GLOBAL DEFAULT    1
bpf_program__set_ifindex
