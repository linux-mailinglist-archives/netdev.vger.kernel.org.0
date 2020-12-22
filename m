Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E492E0CC6
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 16:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbgLVPcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 10:32:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54121 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727019AbgLVPcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 10:32:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608651046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yAkpHC4YXj0isQg/CwgoYzp4WFHdlaWA3PELAYzb/yA=;
        b=Ng9svGG185Y2I0GYxZhhocB7kavAngCXaNb0w7/kkR3jkz2p7RK8WVnwAsobiCzSVv3wGw
        IrmFYuKA9fxfc883h/CDzmzuKmUGpfNkI1346nygQOYIkkBcg8ghM5vbK3tVByOZMDHgu7
        izu3CcEcjdXKZ3TPy47xx+3P53DQGtM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-wgD7Fuc4OJWYkjTpBLSWNg-1; Tue, 22 Dec 2020 10:30:43 -0500
X-MC-Unique: wgD7Fuc4OJWYkjTpBLSWNg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08C84107ACE4;
        Tue, 22 Dec 2020 15:30:41 +0000 (UTC)
Received: from carbon (unknown [10.36.110.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DDC3260C68;
        Tue, 22 Dec 2020 15:30:33 +0000 (UTC)
Date:   Tue, 22 Dec 2020 16:30:32 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com, brouer@redhat.com
Subject: Re: [PATCH bpf-next V9 7/7] bpf/selftests: tests using
 bpf_check_mtu BPF-helper
Message-ID: <20201222163032.0529ab4d@carbon>
In-Reply-To: <CAEf4Bzbud5EWAo9E=95VzGeCZGLA9_MdQUrAc8unh3izXcd3AA@mail.gmail.com>
References: <160822594178.3481451.1208057539613401103.stgit@firesoul>
        <160822601093.3481451.9135115478358953965.stgit@firesoul>
        <CAEf4Bzbud5EWAo9E=95VzGeCZGLA9_MdQUrAc8unh3izXcd3AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Dec 2020 12:13:45 -0800
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:

> On Thu, Dec 17, 2020 at 9:30 AM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
> >
> > Adding selftest for BPF-helper bpf_check_mtu(). Making sure
> > it can be used from both XDP and TC.
> >
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > ---
> >  tools/testing/selftests/bpf/prog_tests/check_mtu.c |  204 ++++++++++++++++++++
> >  tools/testing/selftests/bpf/progs/test_check_mtu.c |  196 +++++++++++++++++++
> >  2 files changed, 400 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/check_mtu.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_check_mtu.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/check_mtu.c b/tools/testing/selftests/bpf/prog_tests/check_mtu.c
> > new file mode 100644
> > index 000000000000..b5d0c3a9abe8
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/check_mtu.c
> > @@ -0,0 +1,204 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2020 Jesper Dangaard Brouer */
> > +
> > +#include <linux/if_link.h> /* before test_progs.h, avoid bpf_util.h redefines */
> > +
> > +#include <test_progs.h>
> > +#include "test_check_mtu.skel.h"
> > +#include <network_helpers.h>
> > +
> > +#include <stdlib.h>
> > +#include <inttypes.h>
> > +
> > +#define IFINDEX_LO 1
> > +
> > +static __u32 duration; /* Hint: needed for CHECK macro */
> > +
> > +static int read_mtu_device_lo(void)
> > +{
> > +       const char *filename = "/sys/devices/virtual/net/lo/mtu";

I will change this to: /sys/class/net/lo/mtu

> > +       char buf[11] = {};
> > +       int value;
> > +       int fd;
> > +
> > +       fd = open(filename, 0, O_RDONLY);
> > +       if (fd == -1)
> > +               return -1;
> > +
> > +       if (read(fd, buf, sizeof(buf)) == -1)  
> 
> close fd missing here?

ack, fixed.

> > +               return -2;
> > +       close(fd);
> > +
> > +       value = strtoimax(buf, NULL, 10);
> > +       if (errno == ERANGE)
> > +               return -3;
> > +
> > +       return value;
> > +}
> > +
> > +static void test_check_mtu_xdp_attach(struct bpf_program *prog)
> > +{
> > +       int err = 0;
> > +       int fd;
> > +
> > +       fd = bpf_program__fd(prog);
> > +       err = bpf_set_link_xdp_fd(IFINDEX_LO, fd, XDP_FLAGS_SKB_MODE);
> > +       if (CHECK(err, "XDP-attach", "failed"))
> > +               return;
> > +
> > +       bpf_set_link_xdp_fd(IFINDEX_LO, -1, 0);  
> 
> can you please use bpf_link-based bpf_program__attach_xdp() which will
> provide auto-cleanup in case of crash?

Sure, that will be good for me to learn.

> also check that it succeeded?
> 
> > +}
> > +
> > +static void test_check_mtu_run_xdp(struct test_check_mtu *skel,
> > +                                  struct bpf_program *prog,
> > +                                  __u32 mtu_expect)
> > +{
> > +       const char *prog_name = bpf_program__name(prog);
> > +       int retval_expect = XDP_PASS;
> > +       __u32 mtu_result = 0;
> > +       char buf[256];
> > +       int err;
> > +
> > +       struct bpf_prog_test_run_attr tattr = {
> > +               .repeat = 1,
> > +               .data_in = &pkt_v4,
> > +               .data_size_in = sizeof(pkt_v4),
> > +               .data_out = buf,
> > +               .data_size_out = sizeof(buf),
> > +               .prog_fd = bpf_program__fd(prog),
> > +       };  
> 
> nit: it's a variable declaration, so keep it all in one block. There
> is also opts-based variant, which might be good to use here instead.
> 
> > +
> > +       memset(buf, 0, sizeof(buf));  
> 
> char buf[256] = {}; would make this unnecessary

ok.

> 
> > +
> > +       err = bpf_prog_test_run_xattr(&tattr);
> > +       CHECK_ATTR(err != 0 || errno != 0, "bpf_prog_test_run",
> > +                  "prog_name:%s (err %d errno %d retval %d)\n",
> > +                  prog_name, err, errno, tattr.retval);
> > +
> > +        CHECK(tattr.retval != retval_expect, "retval",  
> 
> whitespaces are off?

Yes, I noticed with scripts/checkpatch.pl.  And there are a couple
more, that I've already fixed.


> > +             "progname:%s unexpected retval=%d expected=%d\n",
> > +             prog_name, tattr.retval, retval_expect);
> > +
> > +       /* Extract MTU that BPF-prog got */
> > +       mtu_result = skel->bss->global_bpf_mtu_xdp;
> > +       CHECK(mtu_result != mtu_expect, "MTU-compare-user",
> > +             "failed (MTU user:%d bpf:%d)", mtu_expect, mtu_result);  
> 
> There is nicer ASSERT_EQ() macro for such cases:
> 
> ASSERT_EQ(mtu_result, mtu_expect, "MTU-compare-user"); it will format
> sensible error message automatically

Nice simplification :-)

> 
> > +}
> > +  
> 
> [...]

[... same ...] 

> [...]
> 
> > +
> > +void test_check_mtu(void)
> > +{
> > +       struct test_check_mtu *skel;
> > +       __u32 mtu_lo;
> > +
> > +       skel = test_check_mtu__open_and_load();
> > +       if (CHECK(!skel, "open and load skel", "failed"))
> > +               return; /* Exit if e.g. helper unknown to kernel */
> > +
> > +       if (test__start_subtest("bpf_check_mtu XDP-attach"))
> > +               test_check_mtu_xdp_attach(skel->progs.xdp_use_helper_basic);
> > +
> > +       test_check_mtu__destroy(skel);  
> 
> here it's not clear why you instantiate skeleton outside of
> test_check_mtu_xdp_attach() subtest. Can you please move it in? It
> will keep this failure local to that specific subtest, not the entire
> test. And is just cleaner, of course.

Sure will "move it in".  The intent was to fail the entire test if this
failed, but it is more clean to "move it in".

> > +
> > +       mtu_lo = read_mtu_device_lo();
> > +       if (CHECK(mtu_lo < 0, "reading MTU value", "failed (err:%d)", mtu_lo))  
> 
> ASSERT_OK() could be used here
> 
> > +               return;
> > +
> > +       if (test__start_subtest("bpf_check_mtu XDP-run"))
> > +               test_check_mtu_xdp(mtu_lo, 0);
> > +
> > +       if (test__start_subtest("bpf_check_mtu XDP-run ifindex-lookup"))
> > +               test_check_mtu_xdp(mtu_lo, IFINDEX_LO);
> > +
> > +       if (test__start_subtest("bpf_check_mtu TC-run"))
> > +               test_check_mtu_tc(mtu_lo, 0);
> > +
> > +       if (test__start_subtest("bpf_check_mtu TC-run ifindex-lookup"))
> > +               test_check_mtu_tc(mtu_lo, IFINDEX_LO);
> > +}  
> 
> [...]
> 
> > +
> > +       global_bpf_mtu_tc = mtu_len;
> > +       return retval;
> > +}
> > +
> > +SEC("classifier")  
> 
> nice use of the same SEC()'tion BPF programs!
> 
> 
> > +int tc_minus_delta(struct __sk_buff *ctx)
> > +{
> > +       int retval = BPF_OK; /* Expected retval on successful test */
> > +       __u32 ifindex = GLOBAL_USER_IFINDEX;
> > +       __u32 skb_len = ctx->len;
> > +       __u32 mtu_len = 0;
> > +       int delta;
> > +
> > +       /* Boarderline test case: Minus delta exceeding packet length allowed */
> > +       delta = -((skb_len - ETH_HLEN) + 1);
> > +
> > +       /* Minus length (adjusted via delta) still pass MTU check, other helpers
> > +        * are responsible for catching this, when doing actual size adjust
> > +        */
> > +       if (bpf_check_mtu(ctx, ifindex, &mtu_len, delta, 0))
> > +               retval = BPF_DROP;
> > +
> > +       global_bpf_mtu_xdp = mtu_len;
> > +       return retval;
> > +}



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

