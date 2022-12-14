Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBA864D2AB
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 23:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiLNW72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 17:59:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiLNW72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 17:59:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D1845EF7
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 14:58:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671058716;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eYcGFWt3GTixmJISWu+c0RW0sUTrQZWf7rnoOaoeuWA=;
        b=GOu6CLnVFzuvXoloIPj42pVKaTbFOUpd3kZRlKx0hl07zxKnh0Gf8Zyur28JZGHVn5RXdK
        UpJFXHf7R6h3Vy+EXnt3iOJfwj9ex59y+oNe/0xnPOfa6KQBGI9Ngh/brJvCJ//1zweFqm
        UlKifMIogrdFDwamJt/40Uqi3w31aRE=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-400-Cxbp2ulgPJeFC_IPYnSV2w-1; Wed, 14 Dec 2022 17:58:35 -0500
X-MC-Unique: Cxbp2ulgPJeFC_IPYnSV2w-1
Received: by mail-ej1-f72.google.com with SMTP id qb2-20020a1709077e8200b007bf01e43797so12414720ejc.13
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 14:58:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eYcGFWt3GTixmJISWu+c0RW0sUTrQZWf7rnoOaoeuWA=;
        b=d9Ux7CAV2fQeXbo2lQq+Cj8X4uLG5VeBtbHEHEn01A7Ukr+o70gMT7CzlQJP6Jdgnj
         2tsumm8wT8qA1I5OVxhRpYTx1bdhf8zICZZ+nw4wOENYx/me5Bh1tGOBMVnrXhB/N/x+
         NnXEX4j17R5iDTHbNzkRybze0Ilv3GA7RQf42XVKM2EwBdKhDEeewpYVs/smUxz43Jrj
         rDW1tNOwLGZIY0VSgWCBmU0JGIihyqWdz17egbdt0QY79+3BeAipPC/XvKyfYh2n5eKT
         zlOhVtqVQ0whfYRpK0dJ0d1xu0yEQZKsumkdV8KAtHs1acFV2JGvYk7Qn4klhPPm3UZh
         r3lQ==
X-Gm-Message-State: ANoB5pnQFQTiYwb9yWN3i4stB09u3awNXF1qQgfBuUtMBE7YnJnOfr16
        7MSP/QTkFyBbS55K9kb8IRd0jcatRz/r1e+bVHuhfQMBoQ2FZrvpuB50z5EUEJNu1Z7o1dxFvuZ
        w3vMkiqKcGDEoYjQx
X-Received: by 2002:a05:6402:3906:b0:461:79d8:f51a with SMTP id fe6-20020a056402390600b0046179d8f51amr22163093edb.10.1671058714287;
        Wed, 14 Dec 2022 14:58:34 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6DKefQPfAunhO+v4YDQDUQECQfVxb3JkfSyBBtGyFOomg/M8byLO5XRRsrJH8r1TxkhmA9BA==
X-Received: by 2002:a05:6402:3906:b0:461:79d8:f51a with SMTP id fe6-20020a056402390600b0046179d8f51amr22163077edb.10.1671058713980;
        Wed, 14 Dec 2022 14:58:33 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id s19-20020a056402037300b0046c91fa5a4asm6903489edw.70.2022.12.14.14.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 14:58:33 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B3F3F82F64D; Wed, 14 Dec 2022 23:58:32 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Shuah Khan <shuah@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf v4 2/2] selftests/bpf: Add a test for using a cpumap
 from an freplace-to-XDP program
In-Reply-To: <CAEf4BzYMNgfmnKzAo==Rs8E-S6cTsVv4mj_17yfKmQ5S_KzXuQ@mail.gmail.com>
References: <20221214010517.668943-1-toke@redhat.com>
 <20221214010517.668943-2-toke@redhat.com>
 <CAEf4BzYMNgfmnKzAo==Rs8E-S6cTsVv4mj_17yfKmQ5S_KzXuQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 14 Dec 2022 23:58:32 +0100
Message-ID: <87359hfv8n.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Tue, Dec 13, 2022 at 5:05 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> This adds a simple test for inserting an XDP program into a cpumap that =
is
>> "owned" by an XDP program that was loaded as PROG_TYPE_EXT (as libxdp
>> does). Prior to the kernel fix this would fail because the map type
>> ownership would be set to PROG_TYPE_EXT instead of being resolved to
>> PROG_TYPE_XDP.
>>
>> v4:
>> - Use skeletons for selftest
>> v3:
>> - Update comment to better explain the cause
>> - Add Yonghong's ACK
>>
>> Acked-by: Yonghong Song <yhs@fb.com>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>  .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  | 54 +++++++++++++++++++
>>  .../selftests/bpf/progs/freplace_progmap.c    | 24 +++++++++
>>  2 files changed, 78 insertions(+)
>>  create mode 100644 tools/testing/selftests/bpf/progs/freplace_progmap.c
>>
>> diff --git a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c b/to=
ols/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
>> index d1e32e792536..efa1fc65840d 100644
>> --- a/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
>> +++ b/tools/testing/selftests/bpf/prog_tests/fexit_bpf2bpf.c
>> @@ -4,6 +4,8 @@
>>  #include <network_helpers.h>
>>  #include <bpf/btf.h>
>>  #include "bind4_prog.skel.h"
>> +#include "freplace_progmap.skel.h"
>> +#include "xdp_dummy.skel.h"
>>
>>  typedef int (*test_cb)(struct bpf_object *obj);
>>
>> @@ -500,6 +502,56 @@ static void test_fentry_to_cgroup_bpf(void)
>>         bind4_prog__destroy(skel);
>>  }
>>
>> +static void test_func_replace_progmap(void)
>> +{
>> +       struct bpf_cpumap_val value =3D { .qsize =3D 1 };
>> +       struct freplace_progmap *skel =3D NULL;
>> +       struct xdp_dummy *tgt_skel =3D NULL;
>> +       int err, tgt_fd;
>> +       __u32 key =3D 0;
>> +
>> +       skel =3D freplace_progmap__open();
>> +       if (!ASSERT_OK_PTR(skel, "prog_open"))
>> +               return;
>> +
>> +       tgt_skel =3D xdp_dummy__open_and_load();
>> +       if (!ASSERT_OK_PTR(tgt_skel, "tgt_prog_load"))
>> +               goto out;
>> +
>> +       tgt_fd =3D bpf_program__fd(tgt_skel->progs.xdp_dummy_prog);
>> +
>> +       /* Change the 'redirect' program type to be a PROG_TYPE_EXT
>> +        * with an XDP target
>> +        */
>> +       bpf_program__set_type(skel->progs.xdp_cpumap_prog, BPF_PROG_TYPE=
_EXT);
>> +       bpf_program__set_expected_attach_type(skel->progs.xdp_cpumap_pro=
g, 0);
>
> you shouldn't need this manual override if you mark xdp_cpumap_prog as
> SEC("freplace"), or am I missing something?

No, you're right; I guess I was just too focused on recreating the flow
we use in libxdp. Will fix!

>> +       err =3D bpf_program__set_attach_target(skel->progs.xdp_cpumap_pr=
og,
>> +                                            tgt_fd, "xdp_dummy_prog");
>> +       if (!ASSERT_OK(err, "set_attach_target"))
>> +               goto out;
>> +
>> +       err =3D freplace_progmap__load(skel);
>> +       if (!ASSERT_OK(err, "obj_load"))
>> +               goto out;
>> +
>> +       /* Prior to fixing the kernel, loading the PROG_TYPE_EXT 'redire=
ct'
>> +        * program above will cause the map owner type of 'cpumap' to be=
 set to
>> +        * PROG_TYPE_EXT. This in turn will cause the bpf_map_update_ele=
m()
>> +        * below to fail, because the program we are inserting into the =
map is
>> +        * of PROG_TYPE_XDP. After fixing the kernel, the initial owners=
hip will
>> +        * be correctly resolved to the *target* of the PROG_TYPE_EXT pr=
ogram
>> +        * (i.e., PROG_TYPE_XDP) and the map update will succeed.
>> +        */
>> +       value.bpf_prog.fd =3D bpf_program__fd(skel->progs.xdp_drop_prog);
>> +       err =3D bpf_map_update_elem(bpf_map__fd(skel->maps.cpu_map),
>> +                                 &key, &value, 0);
>> +       ASSERT_OK(err, "map_update");
>> +
>> +out:
>> +       xdp_dummy__destroy(tgt_skel);
>> +       freplace_progmap__destroy(skel);
>> +}
>> +
>>  /* NOTE: affect other tests, must run in serial mode */
>>  void serial_test_fexit_bpf2bpf(void)
>>  {
>> @@ -525,4 +577,6 @@ void serial_test_fexit_bpf2bpf(void)
>>                 test_func_replace_global_func();
>>         if (test__start_subtest("fentry_to_cgroup_bpf"))
>>                 test_fentry_to_cgroup_bpf();
>> +       if (test__start_subtest("func_replace_progmap"))
>> +               test_func_replace_progmap();
>>  }
>> diff --git a/tools/testing/selftests/bpf/progs/freplace_progmap.c b/tool=
s/testing/selftests/bpf/progs/freplace_progmap.c
>> new file mode 100644
>> index 000000000000..68174c3d7b37
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/freplace_progmap.c
>> @@ -0,0 +1,24 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +#include <linux/bpf.h>
>> +#include <bpf/bpf_helpers.h>
>> +
>> +struct {
>> +       __uint(type, BPF_MAP_TYPE_CPUMAP);
>> +       __uint(key_size, sizeof(__u32));
>> +       __uint(value_size, sizeof(struct bpf_cpumap_val));
>
> ok, another minor nit which you ignored, libbpf should be smart enough to=
 accept
>
> __type(key, __u32);
> __type(value, struct bpf_cpumap_val);
>
> And if it's not it would be good to know that it's not (and trivially
> fix it).

Ah, actually saw that comment on the previous version, and then
completely forgot about it when I was fixing things up. Sorry about
that; will change!

-Toke

