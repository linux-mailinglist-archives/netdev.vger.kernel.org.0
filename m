Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBEBC12070E
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 14:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbfLPNYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 08:24:45 -0500
Received: from www62.your-server.de ([213.133.104.62]:50920 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727601AbfLPNYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 08:24:45 -0500
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1igqMa-0002oF-ND; Mon, 16 Dec 2019 14:24:40 +0100
Date:   Mon, 16 Dec 2019 14:24:40 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Paul Chaignon <paul.chaignon@orange.com>
Cc:     bpf@vger.kernel.org, paul.chaignon@gmail.com,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next] bpftool: Fix compilation warning on shadowed
 variable
Message-ID: <20191216132440.GC14887@linux.fritz.box>
References: <20191216112733.GA28366@Omicron>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191216112733.GA28366@Omicron>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25665/Mon Dec 16 10:52:23 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 12:27:33PM +0100, Paul Chaignon wrote:
> The ident variable has already been declared at the top of the function
> and doesn't need to be re-declared.
> 
> Fixes: 985ead416df39 ("bpftool: Add skeleton codegen command")
> Signed-off-by: Paul Chaignon <paul.chaignon@orange.com>

One warning and one error in today's bpf-next tree's tooling. :/ This fixes
the former, applied, thanks!

[root@linux bpftool]# make

Auto-detecting system features:
...                        libbfd: [ on  ]
...        disassembler-four-args: [ on  ]
...                          zlib: [ on  ]

  CC       map_perf_ring.o
  CC       xlated_dumper.o
  CC       btf.o
  CC       tracelog.o
  CC       perf.o
  CC       cfg.o
  CC       btf_dumper.o
  CC       net.o
  CC       netlink_dumper.o
  CC       common.o
  CC       cgroup.o
  CC       gen.o
gen.c: In function ‘do_skeleton’:
gen.c:391:16: warning: declaration of ‘ident’ shadows a previous local [-Wshadow]
  391 |    const char *ident = get_map_ident(map);
      |                ^~~~~
gen.c:266:21: note: shadowed declaration is here
  266 |  const char *file, *ident;
      |                     ^~~~~
  CC       main.o
  CC       json_writer.o
  CC       prog.o
  CC       map.o
  CC       feature.o
  CC       jit_disasm.o
  CC       disasm.o
make[1]: Entering directory '/home/darkstar/trees/bpf-next/tools/lib/bpf'

Auto-detecting system features:
...                        libelf: [ on  ]
...                          zlib: [ on  ]
...                           bpf: [ on  ]

Parsed description of 117 helper function(s)
  MKDIR    staticobjs/
  CC       staticobjs/libbpf.o
  CC       staticobjs/bpf.o
  CC       staticobjs/nlattr.o
  CC       staticobjs/btf.o
btf.c: In function ‘btf__align_of’:
btf.c:303:21: error: declaration of ‘t’ shadows a previous local [-Werror=shadow]
  303 |   int i, align = 1, t;
      |                     ^
btf.c:283:25: note: shadowed declaration is here
  283 |  const struct btf_type *t = btf__type_by_id(btf, id);
      |                         ^
cc1: all warnings being treated as errors
  CC       staticobjs/libbpf_errno.o
  CC       staticobjs/str_error.o
  CC       staticobjs/netlink.o
  CC       staticobjs/bpf_prog_linfo.o
  CC       staticobjs/libbpf_probes.o
  CC       staticobjs/xsk.o
  CC       staticobjs/hashmap.o
  CC       staticobjs/btf_dump.o
  LD       staticobjs/libbpf-in.o
ld: cannot find staticobjs/btf.o: No such file or directory
make[2]: *** [/home/darkstar/trees/bpf-next/tools/build/Makefile.build:145: staticobjs/libbpf-in.o] Error 1
make[1]: *** [Makefile:182: staticobjs/libbpf-in.o] Error 2
make[1]: Leaving directory '/home/darkstar/trees/bpf-next/tools/lib/bpf'
make: *** [Makefile:32: /home/darkstar/trees/bpf-next/tools/lib/bpf/libbpf.a] Error 2

