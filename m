Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE3AA13C255
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgAONM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:12:58 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35689 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgAONM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 08:12:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579093975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vkwac9ipxdwjGCmCWEvnGmzcnFiuL5QS83aF2p0l61Q=;
        b=TEQEIlL9CgBuOp71ae4LX8a0q5C/C2BRwBqbuaT5PwdIZx0UOhKo5HlhiCRkkOK20Y0eVg
        NJs8elP2fv9Aona6/MQBjhBme4Zlqam7FteCYzkzUMEiRHxKz8rt33TPYHiCiXm42rkeGB
        BUxHz4nvHV+klYwilVQEx1v2olz96Q8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-Zo8P_6BKNDOiDqkk_gRyXg-1; Wed, 15 Jan 2020 08:12:51 -0500
X-MC-Unique: Zo8P_6BKNDOiDqkk_gRyXg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B3D5800D41;
        Wed, 15 Jan 2020 13:12:50 +0000 (UTC)
Received: from [10.36.117.241] (ovpn-117-241.ams2.redhat.com [10.36.117.241])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C676484326;
        Wed, 15 Jan 2020 13:12:48 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Andrii Nakryiko" <andrii.nakryiko@gmail.com>,
        maciej.fijalkowski@intel.com
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2] selftests/bpf: Add a test for attaching a bpf
 fentry/fexit trace to an XDP program
Date:   Wed, 15 Jan 2020 14:12:46 +0100
Message-ID: <18AB9E9B-FB00-4BC6-BB6F-B7001340C064@redhat.com>
In-Reply-To: <CAEf4BzYmTBH5b0mNdJ1Sts1FzygSX_im+mupRhP5Eo7rgE6g-Q@mail.gmail.com>
References: <157901745600.30872.10096561620432101095.stgit@xdp-tutorial>
 <CAEf4BzYmTBH5b0mNdJ1Sts1FzygSX_im+mupRhP5Eo7rgE6g-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii and Maciej thanks for your reviews, I=E2=80=99ve addressed all you=
r=20
comments, and will send out a v3 soon=E2=80=A6

//Eelco

On 14 Jan 2020, at 19:49, Andrii Nakryiko wrote:

> On Tue, Jan 14, 2020 at 7:58 AM Eelco Chaudron <echaudro@redhat.com>=20
> wrote:
>>
>> Add a test that will attach a FENTRY and FEXIT program to the XDP=20
>> test
>> program. It will also verify data from the XDP context on FENTRY and
>> verifies the return code on exit.
>>
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>>
>> ---
>> v1 -> v2:
>>   - Changed code to use the BPF skeleton
>>   - Replace static volatile with global variable in eBPF code
>>
>>  .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |   69=20
>> ++++++++++++++++++++
>>  .../testing/selftests/bpf/progs/test_xdp_bpf2bpf.c |   44=20
>> +++++++++++++
>>  2 files changed, 113 insertions(+)
>>  create mode 100644=20
>> tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
>>  create mode 100644=20
>> tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
>>
>> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c=20
>> b/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
>> new file mode 100644
>> index 000000000000..e6e849df2632
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
>> @@ -0,0 +1,69 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +#include <test_progs.h>
>> +#include <net/if.h>
>> +#include "test_xdp.skel.h"
>> +#include "test_xdp_bpf2bpf.skel.h"
>> +
>> +void test_xdp_bpf2bpf(void)
>> +{
>> +
>
> extra line
>
>> +       struct test_xdp *pkt_skel =3D NULL;
>> +        struct test_xdp_bpf2bpf *ftrace_skel =3D NULL;
>
> something with indentation?
>
>> +       __u64 *ftrace_res;
>> +
>
> variable declarations shouldn't be split, probably?
>
>> +       struct vip key4 =3D {.protocol =3D 6, .family =3D AF_INET};
>> +       struct iptnl_info value4 =3D {.family =3D AF_INET};
>> +       char buf[128];
>> +       struct iphdr *iph =3D (void *)buf + sizeof(struct ethhdr);
>> +       __u32 duration =3D 0, retval, size;
>> +       int err, pkt_fd, map_fd;
>> +
>> +       /* Load XDP program to introspect */
>> +       pkt_skel =3D test_xdp__open_and_load();
>> +       if (CHECK(!pkt_skel, "pkt_skel_load", "test_xdp skeleton=20
>> failed\n"))
>> +               return;
>> +
>> +       pkt_fd =3D bpf_program__fd(pkt_skel->progs._xdp_tx_iptunnel);
>> +
>> +       map_fd =3D bpf_map__fd(pkt_skel->maps.vip2tnl);
>> +       bpf_map_update_elem(map_fd, &key4, &value4, 0);
>> +
>> +       DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
>> +                           .attach_prog_fd =3D pkt_fd,
>> +                          );
>
> DECLARE_LIBBPF_OPTS is a variable declaration, so should go together
> with all other declarations. Compiler should complain about this, but
> I guess selftests/bpf Makefile doesn't have necessary flags, that
> other kernel code has. You can declare opts first and then initialize
> some extra fields later:
>
> DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts);
>
> ... later in code ...
>
> opts.attach_prog_fd =3D pkt_fd;
>
>
>> +
>> +       ftrace_skel =3D test_xdp_bpf2bpf__open_opts(&opts);
>> +       if (CHECK(!ftrace_skel, "__open", "ftrace skeleton=20
>> failed\n"))
>> +         goto out;
>> +
>> +       if (CHECK(test_xdp_bpf2bpf__load(ftrace_skel), "__load",=20
>> "ftrace skeleton failed\n"))
>> +         goto out;
>
> for consistency with attach check below and for readability, move out
> load call into separate statement, it's easy to miss when it is inside
> CHECK()
>
>> +
>> +       err =3D test_xdp_bpf2bpf__attach(ftrace_skel);
>> +       if (CHECK(err, "ftrace_attach", "ftrace attach failed: %d\n",=20
>> err))
>> +               goto out;
>> +
>> +        /* Run test program */
>> +       err =3D bpf_prog_test_run(pkt_fd, 1, &pkt_v4, sizeof(pkt_v4),
>> +                               buf, &size, &retval, &duration);
>> +
>> +       CHECK(err || retval !=3D XDP_TX || size !=3D 74 ||
>> +             iph->protocol !=3D IPPROTO_IPIP, "ipv4",
>> +             "err %d errno %d retval %d size %d\n",
>> +             err, errno, retval, size);
>
> should it goto out here as well?
>
>> +
>> +       /* Verify test results */
>> +       ftrace_res =3D (__u64 *)ftrace_skel->bss;
>> +
>> +       if (CHECK(ftrace_res[0] !=3D if_nametoindex("lo"), "result",
>> +                 "fentry failed err %llu\n", ftrace_res[0]))
>> +               goto out;
>> +
>> +       if (CHECK(ftrace_res[1] !=3D XDP_TX, "result",
>> +                 "fexit failed err %llu\n", ftrace_res[1]))
>> +               goto out;
>
> why this casting? You can do access those variables much more
> naturally with ftrace_skel->bss->test_result_fentry and
> ftrace_skel->bss->test_result_fexit without making dangerous
> assumptions about their offsets within data section.
>
>
>> +
>> +out:
>> +       test_xdp__destroy(pkt_skel);
>> +       test_xdp_bpf2bpf__destroy(ftrace_skel);
>> +}
>> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c=20
>> b/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
>> new file mode 100644
>> index 000000000000..74c78b30ae07
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
>> @@ -0,0 +1,44 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +#include <linux/bpf.h>
>> +#include "bpf_helpers.h"
>> +#include "bpf_trace_helpers.h"
>> +
>> +struct net_device {
>> +       /* Structure does not need to contain all entries,
>> +        * as "preserve_access_index" will use BTF to fix this...
>> +        */
>> +       int ifindex;
>> +} __attribute__((preserve_access_index));
>> +
>> +struct xdp_rxq_info {
>> +       /* Structure does not need to contain all entries,
>> +        * as "preserve_access_index" will use BTF to fix this...
>> +        */
>> +       struct net_device *dev;
>> +       __u32 queue_index;
>> +} __attribute__((preserve_access_index));
>> +
>> +struct xdp_buff {
>> +       void *data;
>> +       void *data_end;
>> +       void *data_meta;
>> +       void *data_hard_start;
>> +       unsigned long handle;
>> +       struct xdp_rxq_info *rxq;
>> +} __attribute__((preserve_access_index));
>> +
>> +__u64 test_result_fentry =3D 0;
>> +BPF_TRACE_1("fentry/_xdp_tx_iptunnel", trace_on_entry,
>> +           struct xdp_buff *, xdp)
>
> BPF_TRACE_x is no more, see BPF_PROG and how it's used for=20
> fentry/fexit tests:
>
> SEC("fentry/_xdp_tx_iptunnel")
> int BPF_PROG(trace_on_entry, struct xdp_buff *xdp)
>
>> +{
>> +       test_result_fentry =3D xdp->rxq->dev->ifindex;
>> +       return 0;
>> +}
>> +
>> +__u64 test_result_fexit =3D 0;
>> +BPF_TRACE_2("fexit/_xdp_tx_iptunnel", trace_on_exit,
>> +           struct xdp_buff*, xdp, int, ret)
>> +{
>> +       test_result_fexit =3D ret;
>> +       return 0;
>> +}
>>

