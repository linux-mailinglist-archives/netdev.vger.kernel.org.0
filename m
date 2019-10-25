Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E791E56ED
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 01:09:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbfJYXJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 19:09:53 -0400
Received: from www62.your-server.de ([213.133.104.62]:58034 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbfJYXJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 19:09:53 -0400
Received: from 33.249.197.178.dynamic.dsl-lte-bonding.lssmb00p-msn.res.cust.swisscom.ch ([178.197.249.33] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iO8E7-0008Dg-UA; Sat, 26 Oct 2019 00:38:36 +0200
Date:   Sat, 26 Oct 2019 00:38:35 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: Re: [PATCH bpf-next 5/5] bpf, testing: Add selftest to read/write
 sockaddr from user space
Message-ID: <20191025223835.GF14547@pc-63.home>
References: <cover.1572010897.git.daniel@iogearbox.net>
 <19ce2c58465c5fab4c94f23450a8b8d5016a35bb.1572010897.git.daniel@iogearbox.net>
 <CAEf4BzajMmYLe8tY9NGV-34iYUFC_FrBp00a1uSgN-oW_F=+eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzajMmYLe8tY9NGV-34iYUFC_FrBp00a1uSgN-oW_F=+eg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25613/Fri Oct 25 11:00:25 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 03:14:49PM -0700, Andrii Nakryiko wrote:
> On Fri, Oct 25, 2019 at 1:44 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > Tested on x86-64 and Ilya was also kind enough to give it a spin on
> > s390x, both passing with probe_user:OK there. The test is using the
> > newly added bpf_probe_read_user() to dump sockaddr from connect call
> > into BPF map and overrides the user buffer via bpf_probe_write_user():
> >
> >   # ./test_progs
> >   [...]
> >   #17 pkt_md_access:OK
> >   #18 probe_user:OK
> >   #19 prog_run_xattr:OK
> >   [...]
> >
> > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > Tested-by: Ilya Leoshkevich <iii@linux.ibm.com>
> > ---
> >  .../selftests/bpf/prog_tests/probe_user.c     | 80 +++++++++++++++++++
> >  .../selftests/bpf/progs/test_probe_user.c     | 33 ++++++++
> >  2 files changed, 113 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/probe_user.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_probe_user.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/probe_user.c b/tools/testing/selftests/bpf/prog_tests/probe_user.c
> > new file mode 100644
> > index 000000000000..e37761bda8a4
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/probe_user.c
> > @@ -0,0 +1,80 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <test_progs.h>
> > +
> > +void test_probe_user(void)
> > +{
> > +#define kprobe_name "__sys_connect"
> > +       const char *prog_name = "kprobe/" kprobe_name;
> > +       const char *obj_file = "./test_probe_user.o";
> > +       DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
> > +               .relaxed_maps = true,
> 
> do we need relaxed_maps in this case?

Ah yeap, I'll remove. Test runs fine w/o it. Any particular reason you added it back in
928ca75e59d7 ("selftests/bpf: switch tests to new bpf_object__open_{file, mem}() APIs")?

> > +       );
> > +       int err, results_map_fd, sock_fd, duration;
> > +       struct sockaddr curr, orig, tmp;
> > +       struct sockaddr_in *in = (struct sockaddr_in *)&curr;
> > +       struct bpf_link *kprobe_link = NULL;
> > +       struct bpf_program *kprobe_prog;
> > +       struct bpf_object *obj;
> > +       static const int zero = 0;
> > +
> 
> [...]
> 
> > +
> > +struct {
> > +       __uint(type, BPF_MAP_TYPE_ARRAY);
> > +       __uint(max_entries, 1);
> > +       __type(key, int);
> > +       __type(value, struct sockaddr_in);
> > +} results_map SEC(".maps");
> > +
> > +SEC("kprobe/__sys_connect")
> > +int handle_sys_connect(struct pt_regs *ctx)
> > +{
> > +       void *ptr = (void *)PT_REGS_PARM2(ctx);
> > +       struct sockaddr_in old, new;
> > +       const int zero = 0;
> > +
> > +       bpf_probe_read_user(&old, sizeof(old), ptr);
> > +       bpf_map_update_elem(&results_map, &zero, &old, 0);
> 
> could have used global data and read directly into it :)

Hehe, yeah sure, though that we have covered separately. :-) Wasn't planning to
bug Ilya once again to recompile everything on his s390x box.

> > +       __builtin_memset(&new, 0xab, sizeof(new));
> > +       bpf_probe_write_user(ptr, &new, sizeof(new));
> > +
> > +       return 0;
> > +}
> > +
> > +char _license[] SEC("license") = "GPL";
> > --
> > 2.21.0
> >
