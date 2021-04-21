Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2030336743C
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 22:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245665AbhDUUjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 16:39:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45518 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245655AbhDUUjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 16:39:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619037519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zUYluc5nkqVvhnOW0Db5r7ORc9CZudrMUJgCKSAH70U=;
        b=V0PwN3SBkd0IY8eluk4CAZV32JKUxixh7XIIFbfOrA+wzaNlsCT1WSSXXUdwEBJnBpI+7j
        NpkS/yshABQ86tZhbuBG7TkGpbUBi67mbK9MAyllb7OcIom60jauDhJZaFYirgt042KJrR
        TFlSQpnUWN/Y1PYejape+KDSuP8t+R0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-Da2ofseoMiq-4uHN0Cgmkw-1; Wed, 21 Apr 2021 16:38:38 -0400
X-MC-Unique: Da2ofseoMiq-4uHN0Cgmkw-1
Received: by mail-ed1-f71.google.com with SMTP id t11-20020aa7d4cb0000b0290382e868be07so15619003edr.20
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 13:38:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=zUYluc5nkqVvhnOW0Db5r7ORc9CZudrMUJgCKSAH70U=;
        b=QonhnHvwQ4VbDOgfDkjdfufXSTNxhWAohoBxO4gTrSumizsSjyRcd7PbdqEPuhVo2F
         zpBSTUSlpzMt+qgBqsZd5p7lgoZInfK8khc+vO33gZudQ9o99XpNH/cM06eEEApJwtEy
         zFObFo+LUR/LCF2pzVUaO2qvQCEjvlgpuF0bSbrZJ7/faO+GMM/FBNJaoj+uC3YvRR3R
         wjFYPipXCHd2KcBSRuMFtvyIv8dAIqq1qF7RU1RAyunIHtX80v4WRWn3l0eBgDIImjS3
         IlCJ7RKwS7SMTMK4Tsa3e9j37dBSita504xVCgXqV9A1ohK2TwKnrPEEnHLMFOMJOHkC
         N+qw==
X-Gm-Message-State: AOAM532soXf9jTdNcfJE5d7udzDNoZw9FNElwRGHt9xoB8lYQdy3LQw+
        EHlNfO3w11JIyftSSHK4z6YvbNzEBKmyGr11gplMdZ4ZRZawPfAtAMF3pNgTh4gE0O+/aI4//vV
        8o49NqhuRd9zfcs/6
X-Received: by 2002:a17:907:2ccf:: with SMTP id hg15mr34600533ejc.219.1619037516867;
        Wed, 21 Apr 2021 13:38:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwS6sN8UNCl7SZCqaY2pjigDfKNm2x8iwabrIXb3Qe1MzBxIq+yNsHHUhL67lhRyhgb9o1BTg==
X-Received: by 2002:a17:907:2ccf:: with SMTP id hg15mr34600507ejc.219.1619037516655;
        Wed, 21 Apr 2021 13:38:36 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id d5sm360563edt.49.2021.04.21.13.38.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 13:38:36 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5DF841802FE; Wed, 21 Apr 2021 22:38:35 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v3 3/3] libbpf: add selftests for TC-BPF API
In-Reply-To: <20210421195643.tduqyyfr5xubxfgn@apollo>
References: <20210420193740.124285-1-memxor@gmail.com>
 <20210420193740.124285-4-memxor@gmail.com>
 <CAEf4BzbQjWkVM-dy+ebSKzgO89_W9vMGz_ZYicXCfp5XD_d_1g@mail.gmail.com>
 <20210421195643.tduqyyfr5xubxfgn@apollo>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 21 Apr 2021 22:38:35 +0200
Message-ID: <87o8e7gypg.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:

> On Wed, Apr 21, 2021 at 11:54:18PM IST, Andrii Nakryiko wrote:
>> On Tue, Apr 20, 2021 at 12:37 PM Kumar Kartikeya Dwivedi
>> <memxor@gmail.com> wrote:
>> >
>> > This adds some basic tests for the low level bpf_tc_* API.
>> >
>> > Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>> > ---
>> >  .../selftests/bpf/prog_tests/test_tc_bpf.c    | 169 ++++++++++++++++++
>> >  .../selftests/bpf/progs/test_tc_bpf_kern.c    |  12 ++
>> >  2 files changed, 181 insertions(+)
>> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/test_tc_bpf=
.c
>>
>> we normally don't call prog_test's files with "test_" prefix, it can
>> be just tc_bpf.c (or just tc.c)
>>
>
> Ok, will rename.
>
>> >  create mode 100644 tools/testing/selftests/bpf/progs/test_tc_bpf_kern=
.c
>>
>> we also don't typically call BPF source code files with _kern suffix,
>> just test_tc_bpf.c would be more in line with most common case
>>
>
> Will rename.
>
>> >
>> > diff --git a/tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c b/to=
ols/testing/selftests/bpf/prog_tests/test_tc_bpf.c
>> > new file mode 100644
>> > index 000000000000..563a3944553c
>> > --- /dev/null
>> > +++ b/tools/testing/selftests/bpf/prog_tests/test_tc_bpf.c
>> > @@ -0,0 +1,169 @@
>> > +// SPDX-License-Identifier: GPL-2.0
>> > +
>> > +#include <linux/bpf.h>
>> > +#include <linux/err.h>
>> > +#include <linux/limits.h>
>> > +#include <bpf/libbpf.h>
>> > +#include <errno.h>
>> > +#include <stdio.h>
>> > +#include <stdlib.h>
>> > +#include <test_progs.h>
>> > +#include <linux/if_ether.h>
>> > +
>> > +#define LO_IFINDEX 1
>> > +
>> > +static int test_tc_internal(int fd, __u32 parent_id)
>> > +{
>> > +       DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle =3D 1, .priorit=
y =3D 10,
>> > +                           .class_id =3D TC_H_MAKE(1UL << 16, 1));
>> > +       struct bpf_tc_attach_id id =3D {};
>> > +       struct bpf_tc_info info =3D {};
>> > +       int ret;
>> > +
>> > +       ret =3D bpf_tc_attach(fd, LO_IFINDEX, parent_id, &opts, &id);
>> > +       if (!ASSERT_EQ(ret, 0, "bpf_tc_attach"))
>> > +               return ret;
>> > +
>> > +       ret =3D bpf_tc_get_info(LO_IFINDEX, parent_id, &id, &info);
>> > +       if (!ASSERT_EQ(ret, 0, "bpf_tc_get_info"))
>> > +               goto end;
>> > +
>> > +       if (!ASSERT_EQ(info.id.handle, id.handle, "handle mismatch") ||
>> > +           !ASSERT_EQ(info.id.priority, id.priority, "priority mismat=
ch") ||
>> > +           !ASSERT_EQ(info.id.handle, 1, "handle incorrect") ||
>> > +           !ASSERT_EQ(info.chain_index, 0, "chain_index incorrect") ||
>> > +           !ASSERT_EQ(info.id.priority, 10, "priority incorrect") ||
>> > +           !ASSERT_EQ(info.class_id, TC_H_MAKE(1UL << 16, 1),
>> > +                      "class_id incorrect") ||
>> > +           !ASSERT_EQ(info.protocol, ETH_P_ALL, "protocol incorrect"))
>> > +               goto end;
>> > +
>> > +       opts.replace =3D true;
>> > +       ret =3D bpf_tc_attach(fd, LO_IFINDEX, parent_id, &opts, &id);
>> > +       if (!ASSERT_EQ(ret, 0, "bpf_tc_attach in replace mode"))
>> > +               return ret;
>> > +
>> > +       /* Demonstrate changing attributes */
>> > +       opts.class_id =3D TC_H_MAKE(1UL << 16, 2);
>> > +
>> > +       ret =3D bpf_tc_attach(fd, LO_IFINDEX, parent_id, &opts, &id);
>> > +       if (!ASSERT_EQ(ret, 0, "bpf_tc attach in replace mode"))
>> > +               goto end;
>> > +
>> > +       ret =3D bpf_tc_get_info(LO_IFINDEX, parent_id, &id, &info);
>> > +       if (!ASSERT_EQ(ret, 0, "bpf_tc_get_info"))
>> > +               goto end;
>> > +
>> > +       if (!ASSERT_EQ(info.class_id, TC_H_MAKE(1UL << 16, 2),
>> > +                      "class_id incorrect after replace"))
>> > +               goto end;
>> > +       if (!ASSERT_EQ(info.bpf_flags & TCA_BPF_FLAG_ACT_DIRECT, 1,
>> > +                      "direct action mode not set"))
>> > +               goto end;
>> > +
>> > +end:
>> > +       ret =3D bpf_tc_detach(LO_IFINDEX, parent_id, &id);
>> > +       ASSERT_EQ(ret, 0, "detach failed");
>> > +       return ret;
>> > +}
>> > +
>> > +int test_tc_info(int fd)
>> > +{
>> > +       DECLARE_LIBBPF_OPTS(bpf_tc_opts, opts, .handle =3D 1, .priorit=
y =3D 10,
>> > +                           .class_id =3D TC_H_MAKE(1UL << 16, 1));
>> > +       struct bpf_tc_attach_id id =3D {}, old;
>> > +       struct bpf_tc_info info =3D {};
>> > +       int ret;
>> > +
>> > +       ret =3D bpf_tc_attach(fd, LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &=
opts, &id);
>> > +       if (!ASSERT_EQ(ret, 0, "bpf_tc_attach"))
>> > +               return ret;
>> > +       old =3D id;
>> > +
>> > +       ret =3D bpf_tc_get_info(LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &id=
, &info);
>> > +       if (!ASSERT_EQ(ret, 0, "bpf_tc_get_info"))
>> > +               goto end_old;
>> > +
>> > +       if (!ASSERT_EQ(info.id.handle, id.handle, "handle mismatch") ||
>> > +           !ASSERT_EQ(info.id.priority, id.priority, "priority mismat=
ch") ||
>> > +           !ASSERT_EQ(info.id.handle, 1, "handle incorrect") ||
>> > +           !ASSERT_EQ(info.chain_index, 0, "chain_index incorrect") ||
>> > +           !ASSERT_EQ(info.id.priority, 10, "priority incorrect") ||
>> > +           !ASSERT_EQ(info.class_id, TC_H_MAKE(1UL << 16, 1),
>> > +                      "class_id incorrect") ||
>> > +           !ASSERT_EQ(info.protocol, ETH_P_ALL, "protocol incorrect"))
>> > +               goto end_old;
>> > +
>> > +       /* choose a priority */
>> > +       opts.priority =3D 0;
>> > +       ret =3D bpf_tc_attach(fd, LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &=
opts, &id);
>> > +       if (!ASSERT_EQ(ret, 0, "bpf_tc_attach"))
>> > +               goto end_old;
>> > +
>> > +       ret =3D bpf_tc_get_info(LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &id=
, &info);
>> > +       if (!ASSERT_EQ(ret, 0, "bpf_tc_get_info"))
>> > +               goto end;
>> > +
>> > +       if (!ASSERT_NEQ(id.priority, old.priority, "filter priority mi=
smatch"))
>> > +               goto end;
>> > +       if (!ASSERT_EQ(info.id.priority, id.priority, "priority mismat=
ch"))
>> > +               goto end;
>> > +
>> > +end:
>> > +       ret =3D bpf_tc_detach(LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &id);
>> > +       ASSERT_EQ(ret, 0, "detach failed");
>> > +end_old:
>> > +       ret =3D bpf_tc_detach(LO_IFINDEX, BPF_TC_CLSACT_INGRESS, &old);
>> > +       ASSERT_EQ(ret, 0, "detach failed");
>> > +       return ret;
>> > +}
>> > +
>> > +void test_test_tc_bpf(void)
>>
>> test_test_ tautology, drop one test?
>>
>
> Ok.
>
>> > +{
>> > +       const char *file =3D "./test_tc_bpf_kern.o";
>>
>> please use BPF skeleton instead, see lots of other selftests doing
>> that already. You won't even need find_program_by_{name,title}, among
>> other things.
>>
>
> Sounds good, will change.
>
>> > +       struct bpf_program *clsp;
>> > +       struct bpf_object *obj;
>> > +       int cls_fd, ret;
>> > +
>> > +       obj =3D bpf_object__open(file);
>> > +       if (!ASSERT_OK_PTR(obj, "bpf_object__open"))
>> > +               return;
>> > +
>> > +       clsp =3D bpf_object__find_program_by_title(obj, "classifier");
>> > +       if (!ASSERT_OK_PTR(clsp, "bpf_object__find_program_by_title"))
>> > +               goto end;
>> > +
>> > +       ret =3D bpf_object__load(obj);
>> > +       if (!ASSERT_EQ(ret, 0, "bpf_object__load"))
>> > +               goto end;
>> > +
>> > +       cls_fd =3D bpf_program__fd(clsp);
>> > +
>> > +       system("tc qdisc del dev lo clsact");
>>
>> can this fail? also why is this necessary? it's still not possible to
>
> This is just removing any existing clsact qdisc since it will be setup by=
 the
> attach call, which is again removed later (where we do check if it fails,=
 if it
> does clsact qdisc was not setup, and something was wrong in that it retur=
ned 0
> when the attach point was one of the clsact hooks).
>
> We don't care about failure initially, since if it isn't present we'd jus=
t move
> on to running the test.
>
>> do anything with only libbpf APIs?
>>
>
> I don't think so, I can do the qdisc teardown using netlink in the selfte=
st,
> but that would mean duplicating a lot of code. I think expecting tc to be
> present on the system is a reasonable assumption for this test.

So this stems from the fact that bpf_tc_detach() doesn't clean up the
clsact qdisc that is added by bpf_tc_attach(). I think we should fix
this.

Andrii, Kumar and I discussed this, and concluded that the best we can
do from userspace right now is query the number of filters before remove
and if there's only one, also remove the clsact qdisc. This is racy in
that a new filter can be attached between the check and the remove, but
to fix that we need a way for the filter to take the ref on the qdisc.
Since something like this will be needed for a bpf_link attach mode as
well, we figured that can be added as part of such a series, and we'll
just do the best-effort thing now. WDYT?

-Toke

