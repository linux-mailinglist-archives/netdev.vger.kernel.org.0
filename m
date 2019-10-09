Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC731D06EA
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 07:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730662AbfJIFhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 01:37:11 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39899 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730451AbfJIFhL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 01:37:11 -0400
Received: by mail-qt1-f193.google.com with SMTP id n7so1683637qtb.6;
        Tue, 08 Oct 2019 22:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rJBuqLgiutMEczdnWrQ6zOpsg3ZKdIeR1ad1Fo0miKM=;
        b=TglRhebqETaTOhpQN6mcil1MURROYBhhjGE7trtkHQGQAqpOei/QJDwY7chkj0gEtU
         twMY5sZPSmtWhCskPreJ0mb4UwXS8AhbPpkb36Ue+2HqLRYs2gupLR6MuNfHwioVtqi1
         pZLftUr08I/xYA/gW1onz2V92iR+vA21iIAJYeCwHto1xdglBypbxrMCjaVW3RNpKCXR
         MPfnHzXVDlbJZkPwMv7u44cH0Zz1H7uWDLWrzm6PwwBvx52xZa6HcU7AMQyv/b9Dabgo
         AA9HhLcsW2w5/V5EWoyNrntczeJ7sLq6s00Uyqpr5k0hvKq29XUvUBvMZrqDWuB6uqSe
         ofAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rJBuqLgiutMEczdnWrQ6zOpsg3ZKdIeR1ad1Fo0miKM=;
        b=Ki+Mtd7ikuYVCY5UjhQYO5kSYeFoixJd/Hi9JC10MGYPC2mHW6J80/tkZ20UoJ4Wy+
         ePAKdDOYJJ7CkGvNy5B32JCYFrD47/25udmO9WugswyC9DKnW9+4w/52JuBGaDSolk+E
         N4sX/ohxvZhgDnyeD0QJX4HujHwEvdqUj1tRpfS9zFmj3Y7FSKxazmfjbWVR/uXpxbOP
         L4jVahl3V+IUyT5nX+9iq/49lu4WukZ9S/YMW1DkrEHkai8ocT51c0JIayRLbl0Iqbbs
         Y91BKc/gvYifCbGju2uLSxuljiiufMA96z7nQelKIE2vAbvPdDGlvOJpW7EzJzosHyvH
         yx9A==
X-Gm-Message-State: APjAAAXspKZhbObRmRnP7uzwfhhUlMC5E47InZeNzKCVsPFmX1IVXggr
        G4ybZkS2Rozsby1xxhIHAz0jjkF5Lmjx0I0UBS4=
X-Google-Smtp-Source: APXvYqygG+0xuNCCZuprenJcn3Mt8dNF1w27hUa9xZeBffrCqn+YKuXCn+f9j6+Y4tuGTl35lgtdTcpN3APHQwgnNTg=
X-Received: by 2002:ac8:1c34:: with SMTP id a49mr1782350qtk.59.1570599429608;
 Tue, 08 Oct 2019 22:37:09 -0700 (PDT)
MIME-Version: 1.0
References: <20191005050314.1114330-1-ast@kernel.org> <20191005050314.1114330-11-ast@kernel.org>
In-Reply-To: <20191005050314.1114330-11-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Oct 2019 22:36:58 -0700
Message-ID: <CAEf4BzZS3kvunYnPu6x674H08DZKnuc37c9+m4p_2EjdNuDGSg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 10/10] selftests/bpf: add kfree_skb raw_tp test
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 4, 2019 at 10:04 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Load basic cls_bpf program.
> Load raw_tracepoint program and attach to kfree_skb raw tracepoint.
> Trigger cls_bpf via prog_test_run.
> At the end of test_run kernel will call kfree_skb
> which will trigger trace_kfree_skb tracepoint.
> Which will call our raw_tracepoint program.
> Which will take that skb and will dump it into perf ring buffer.
> Check that user space received correct packet.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

LGTM, few minor nits below.

Acked-by: Andrii Nakryiko <andriin@fb.com>


>  .../selftests/bpf/prog_tests/kfree_skb.c      | 90 +++++++++++++++++++
>  tools/testing/selftests/bpf/progs/kfree_skb.c | 76 ++++++++++++++++
>  2 files changed, 166 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/kfree_skb.c
>  create mode 100644 tools/testing/selftests/bpf/progs/kfree_skb.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/kfree_skb.c b/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
> new file mode 100644
> index 000000000000..238bc7024b36
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
> @@ -0,0 +1,90 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +
> +static void on_sample(void *ctx, int cpu, void *data, __u32 size)
> +{
> +       int ifindex = *(int *)data, duration = 0;
> +       struct ipv6_packet * pkt_v6 = data + 4;
> +
> +       if (ifindex != 1)
> +               /* spurious kfree_skb not on loopback device */
> +               return;
> +       if (CHECK(size != 76, "check_size", "size %d != 76\n", size))

compiler doesn't complain about %d and size being unsigned?

> +               return;
> +       if (CHECK(pkt_v6->eth.h_proto != 0xdd86, "check_eth",
> +                 "h_proto %x\n", pkt_v6->eth.h_proto))
> +               return;
> +       if (CHECK(pkt_v6->iph.nexthdr != 6, "check_ip",
> +                 "iph.nexthdr %x\n", pkt_v6->iph.nexthdr))
> +               return;
> +       if (CHECK(pkt_v6->tcp.doff != 5, "check_tcp",
> +                 "tcp.doff %x\n", pkt_v6->tcp.doff))
> +               return;
> +
> +       *(bool *)ctx = true;
> +}
> +
> +void test_kfree_skb(void)
> +{
> +       struct bpf_prog_load_attr attr = {
> +               .file = "./kfree_skb.o",
> +               .log_level = 2,
> +       };
> +
> +       struct bpf_object *obj, *obj2 = NULL;
> +       struct perf_buffer_opts pb_opts = {};
> +       struct perf_buffer *pb = NULL;
> +       struct bpf_link *link = NULL;
> +       struct bpf_map *perf_buf_map;
> +       struct bpf_program *prog;
> +       __u32 duration, retval;
> +       int err, pkt_fd, kfree_skb_fd;
> +       bool passed = false;
> +
> +       err = bpf_prog_load("./test_pkt_access.o", BPF_PROG_TYPE_SCHED_CLS, &obj, &pkt_fd);
> +       if (CHECK(err, "prog_load sched cls", "err %d errno %d\n", err, errno))
> +               return;
> +
> +       err = bpf_prog_load_xattr(&attr, &obj2, &kfree_skb_fd);
> +       if (CHECK(err, "prog_load raw tp", "err %d errno %d\n", err, errno))
> +               goto close_prog;
> +
> +       prog = bpf_object__find_program_by_title(obj2, "raw_tracepoint/kfree_skb");
> +       if (CHECK(!prog, "find_prog", "prog kfree_skb not found\n"))
> +               goto close_prog;
> +       link = bpf_program__attach_raw_tracepoint(prog, "kfree_skb");
> +       if (CHECK(IS_ERR(link), "attach_raw_tp", "err %ld\n", PTR_ERR(link)))
> +               goto close_prog;
> +
> +       perf_buf_map = bpf_object__find_map_by_name(obj2, "perf_buf_map");
> +       if (CHECK(!perf_buf_map, "find_perf_buf_map", "not found\n"))
> +               goto close_prog;
> +
> +       /* set up perf buffer */
> +       pb_opts.sample_cb = on_sample;
> +       pb_opts.ctx = &passed;
> +       pb = perf_buffer__new(bpf_map__fd(perf_buf_map), 1, &pb_opts);
> +       if (CHECK(IS_ERR(pb), "perf_buf__new", "err %ld\n", PTR_ERR(pb)))
> +               goto close_prog;
> +
> +       err = bpf_prog_test_run(pkt_fd, 1, &pkt_v6, sizeof(pkt_v6),
> +                               NULL, NULL, &retval, &duration);
> +       CHECK(err || retval, "ipv6",
> +             "err %d errno %d retval %d duration %d\n",
> +             err, errno, retval, duration);
> +
> +       /* read perf buffer */
> +       err = perf_buffer__poll(pb, 100);
> +       if (CHECK(err < 0, "perf_buffer__poll", "err %d\n", err))
> +               goto close_prog;
> +       /* make sure kfree_skb program was triggered
> +        * and it sent expected skb into ring buffer
> +        */
> +       CHECK_FAIL(!passed);
> +close_prog:
> +       perf_buffer__free(pb);
> +       if (!IS_ERR_OR_NULL(link))
> +               bpf_link__destroy(link);
> +       bpf_object__close(obj);
> +       bpf_object__close(obj2);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/kfree_skb.c b/tools/testing/selftests/bpf/progs/kfree_skb.c
> new file mode 100644
> index 000000000000..61f1abfc4f48
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/kfree_skb.c
> @@ -0,0 +1,76 @@
> +// SPDX-License-Identifier: GPL-2.0
> +// Copyright (c) 2019 Facebook
> +#include <linux/bpf.h>
> +#include "bpf_helpers.h"
> +
> +char _license[] SEC("license") = "GPL";
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
> +       __uint(key_size, sizeof(int));
> +       __uint(value_size, sizeof(int));
> +} perf_buf_map SEC(".maps");
> +
> +#define _(P) (__builtin_preserve_access_index(P))
> +
> +/* define few struct-s that bpf program needs to access */
> +struct callback_head {
> +       struct callback_head *next;
> +       void (*func)(struct callback_head *head);
> +};
> +struct dev_ifalias {
> +       struct callback_head rcuhead;
> +};
> +
> +struct net_device /* same as kernel's struct net_device */ {
> +       int ifindex;
> +       volatile struct dev_ifalias *ifalias;
> +};
> +
> +struct sk_buff {
> +       /* field names and sizes should match to those in the kernel */
> +        unsigned int            len,
> +                                data_len;
> +        __u16                   mac_len,
> +                                hdr_len;
> +        __u16                   queue_mapping;
> +       struct net_device *dev;
> +       /* order of the fields doesn't matter */
> +};
> +
> +/* copy arguments from
> + * include/trace/events/skb.h:
> + * TRACE_EVENT(kfree_skb,
> + *         TP_PROTO(struct sk_buff *skb, void *location),
> + *
> + * into struct below:
> + */
> +struct trace_kfree_skb {
> +       struct sk_buff *skb;
> +       void *location;
> +};
> +
> +SEC("raw_tracepoint/kfree_skb")
> +int trace_kfree_skb(struct trace_kfree_skb* ctx)
> +{
> +       struct sk_buff *skb = ctx->skb;
> +       struct net_device *dev;
> +       int ifindex;
> +       struct callback_head *ptr;
> +       void *func;

nit: style checker should have complained about missing empty line

> +       __builtin_preserve_access_index(({
> +               dev = skb->dev;
> +               ifindex = dev->ifindex;
> +               ptr = dev->ifalias->rcuhead.next;
> +               func = ptr->func;
> +       }));
> +
> +       bpf_printk("rcuhead.next %llx func %llx\n", ptr, func);
> +       bpf_printk("skb->len %d\n", _(skb->len));
> +       bpf_printk("skb->queue_mapping %d\n", _(skb->queue_mapping));
> +       bpf_printk("dev->ifindex %d\n", ifindex);
> +
> +       /* send first 72 byte of the packet to user space */
> +       bpf_skb_output(skb, &perf_buf_map, (72ull << 32) | BPF_F_CURRENT_CPU,
> +                      &ifindex, sizeof(ifindex));
> +       return 0;
> +}
> --
> 2.20.0
>
