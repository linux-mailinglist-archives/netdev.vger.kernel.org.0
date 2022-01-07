Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98EA7487E32
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 22:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiAGVXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 16:23:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30561 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229849AbiAGVXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 16:23:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641590599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xd6bkhc0TPmGTIt0PTD4sayE2qLpiqib1COYaKHyNiU=;
        b=C8pQplvQikPm6GmNC1OIkUohtRiNNDYowv4s5/WymGbeBr7FIyouTwcqO2lLR6ffDwIW97
        ouucl3H1keo+uZKB23F9W3LrDIAPjfb/s2HUUlOFvwKHcfcmRBXM7T309w0TvhCXursxaE
        Cr07JRiVVb1KME/1tvLtsBO7Vc8zv7U=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-184-no3ybTtQPBO5m7ISrlTh2Q-1; Fri, 07 Jan 2022 16:23:18 -0500
X-MC-Unique: no3ybTtQPBO5m7ISrlTh2Q-1
Received: by mail-ed1-f70.google.com with SMTP id l14-20020aa7cace000000b003f7f8e1cbbdso5638144edt.20
        for <netdev@vger.kernel.org>; Fri, 07 Jan 2022 13:23:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=xd6bkhc0TPmGTIt0PTD4sayE2qLpiqib1COYaKHyNiU=;
        b=TJkidoZe7t5WHO1KCULJaImSWUWP+FNwL8Cx3T8woFR1xHiglF4He+L84eZLrdKsdy
         MzFVAvE6Cm7p97oWdXi1lQnWCjZAfy45VpexGmcD6fKc8h55rgs3Qpdra+4ldRKUco38
         K0gd3bs9wz13FsvOXpcG2/F4tGUkskcV394CD1gKCR71fKoZRVik3EOUOnz3E5GpA73a
         d2sgDo3UwQRFVnfnI96pPI/vLMcGNUKpJuaB+ZMTaidjtHwNbRIEs/NIN/gLZ7q3GyGg
         h1FufPBbO8CaLu8k/eZJCMKXSXzDphVF566XHEDh9NKpUKAadqPfuEOXXBBVQx00QimD
         wusQ==
X-Gm-Message-State: AOAM531FFeummx+tUP0DTHr7wt5jdpXyVsjA8hgSgBm3iCuVemDe1iRC
        MYHX86ebnKy/VGJEGrMQF0mmnGjUTPm11I2yFphKCyJVP+Lows87gg7zReVuz0ALFvh/RFyLnCz
        WYvtpPTQNLKx4lh/9
X-Received: by 2002:a17:906:5284:: with SMTP id c4mr50746900ejm.423.1641590596968;
        Fri, 07 Jan 2022 13:23:16 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz1MYSjs1AibqUucqU+YCP/OSRMoY+As78BWX/RoNcNYOOoShEhys6ruS0WMOnDGEPeeDzDgw==
X-Received: by 2002:a17:906:5284:: with SMTP id c4mr50746855ejm.423.1641590595914;
        Fri, 07 Jan 2022 13:23:15 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id kw22sm1723103ejc.132.2022.01.07.13.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 13:23:15 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 72956181F2A; Fri,  7 Jan 2022 22:23:14 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf 2/2] bpf/selftests: Add check for updating XDP
 bpf_link with wrong program type
In-Reply-To: <CAEf4BzadXK+DiiVEgkZNuDA8=QdVZGSqPsAia7g39GTnQqSpQg@mail.gmail.com>
References: <20220107183049.311134-1-toke@redhat.com>
 <20220107183049.311134-2-toke@redhat.com>
 <CAEf4BzadXK+DiiVEgkZNuDA8=QdVZGSqPsAia7g39GTnQqSpQg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 07 Jan 2022 22:23:14 +0100
Message-ID: <87v8yv8cl9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Fri, Jan 7, 2022 at 10:31 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Add a check to the xdp_link selftest that the kernel rejects replacing an
>> XDP program with a different program type on link update. Convert the
>> selftest to use the preferred ASSERT_* macros while we're at it.
>>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>  .../selftests/bpf/prog_tests/xdp_link.c       | 62 +++++++++----------
>>  .../selftests/bpf/progs/test_xdp_link.c       |  6 ++
>>  2 files changed, 37 insertions(+), 31 deletions(-)
>>
>> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_link.c b/tools/t=
esting/selftests/bpf/prog_tests/xdp_link.c
>> index 983ab0b47d30..8660e68383ea 100644
>> --- a/tools/testing/selftests/bpf/prog_tests/xdp_link.c
>> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_link.c
>> @@ -8,46 +8,47 @@
>>
>>  void serial_test_xdp_link(void)
>>  {
>> -       __u32 duration =3D 0, id1, id2, id0 =3D 0, prog_fd1, prog_fd2, e=
rr;
>>         DECLARE_LIBBPF_OPTS(bpf_xdp_set_link_opts, opts, .old_fd =3D -1);
>>         struct test_xdp_link *skel1 =3D NULL, *skel2 =3D NULL;
>> +       __u32 id1, id2, id0 =3D 0, prog_fd1, prog_fd2;
>>         struct bpf_link_info link_info;
>>         struct bpf_prog_info prog_info;
>>         struct bpf_link *link;
>> +       int err;
>>         __u32 link_info_len =3D sizeof(link_info);
>>         __u32 prog_info_len =3D sizeof(prog_info);
>>
>>         skel1 =3D test_xdp_link__open_and_load();
>> -       if (CHECK(!skel1, "skel_load", "skeleton open and load failed\n"=
))
>> +       if (!ASSERT_OK_PTR(skel1, "skel_load"))
>>                 goto cleanup;
>>         prog_fd1 =3D bpf_program__fd(skel1->progs.xdp_handler);
>>
>>         skel2 =3D test_xdp_link__open_and_load();
>> -       if (CHECK(!skel2, "skel_load", "skeleton open and load failed\n"=
))
>> +       if (!ASSERT_OK_PTR(skel2, "skel_load"))
>>                 goto cleanup;
>>         prog_fd2 =3D bpf_program__fd(skel2->progs.xdp_handler);
>>
>>         memset(&prog_info, 0, sizeof(prog_info));
>>         err =3D bpf_obj_get_info_by_fd(prog_fd1, &prog_info, &prog_info_=
len);
>> -       if (CHECK(err, "fd_info1", "failed %d\n", -errno))
>> +       if (!ASSERT_OK(err, "fd_info1"))
>>                 goto cleanup;
>>         id1 =3D prog_info.id;
>>
>>         memset(&prog_info, 0, sizeof(prog_info));
>>         err =3D bpf_obj_get_info_by_fd(prog_fd2, &prog_info, &prog_info_=
len);
>> -       if (CHECK(err, "fd_info2", "failed %d\n", -errno))
>> +       if (!ASSERT_OK(err, "fd_info2"))
>>                 goto cleanup;
>>         id2 =3D prog_info.id;
>>
>>         /* set initial prog attachment */
>>         err =3D bpf_set_link_xdp_fd_opts(IFINDEX_LO, prog_fd1, XDP_FLAGS=
_REPLACE, &opts);
>> -       if (CHECK(err, "fd_attach", "initial prog attach failed: %d\n", =
err))
>> +       if (!ASSERT_OK(err, "fd_attach"))
>>                 goto cleanup;
>>
>>         /* validate prog ID */
>>         err =3D bpf_get_link_xdp_id(IFINDEX_LO, &id0, 0);
>> -       CHECK(err || id0 !=3D id1, "id1_check",
>> -             "loaded prog id %u !=3D id1 %u, err %d", id0, id1, err);
>> +       if (!ASSERT_OK(err, "id1_check_err") || !ASSERT_EQ(id0, id1, "id=
1_check_val"))
>> +               goto cleanup;
>>
>>         /* BPF link is not allowed to replace prog attachment */
>>         link =3D bpf_program__attach_xdp(skel1->progs.xdp_handler, IFIND=
EX_LO);
>> @@ -62,7 +63,7 @@ void serial_test_xdp_link(void)
>>         /* detach BPF program */
>>         opts.old_fd =3D prog_fd1;
>>         err =3D bpf_set_link_xdp_fd_opts(IFINDEX_LO, -1, XDP_FLAGS_REPLA=
CE, &opts);
>> -       if (CHECK(err, "prog_detach", "failed %d\n", err))
>> +       if (!ASSERT_OK(err, "prog_detach"))
>>                 goto cleanup;
>>
>>         /* now BPF link should attach successfully */
>> @@ -73,24 +74,23 @@ void serial_test_xdp_link(void)
>>
>>         /* validate prog ID */
>>         err =3D bpf_get_link_xdp_id(IFINDEX_LO, &id0, 0);
>> -       if (CHECK(err || id0 !=3D id1, "id1_check",
>> -                 "loaded prog id %u !=3D id1 %u, err %d", id0, id1, err=
))
>> +       if (!ASSERT_OK(err, "id1_check_err") || !ASSERT_EQ(id0, id1, "id=
1_check_val"))
>>                 goto cleanup;
>>
>>         /* BPF prog attach is not allowed to replace BPF link */
>>         opts.old_fd =3D prog_fd1;
>>         err =3D bpf_set_link_xdp_fd_opts(IFINDEX_LO, prog_fd2, XDP_FLAGS=
_REPLACE, &opts);
>> -       if (CHECK(!err, "prog_attach_fail", "unexpected success\n"))
>> +       if (!ASSERT_ERR(err, "prog_attach_fail"))
>>                 goto cleanup;
>>
>>         /* Can't force-update when BPF link is active */
>>         err =3D bpf_set_link_xdp_fd(IFINDEX_LO, prog_fd2, 0);
>> -       if (CHECK(!err, "prog_update_fail", "unexpected success\n"))
>> +       if (!ASSERT_ERR(err, "prog_update_fail"))
>>                 goto cleanup;
>>
>>         /* Can't force-detach when BPF link is active */
>>         err =3D bpf_set_link_xdp_fd(IFINDEX_LO, -1, 0);
>> -       if (CHECK(!err, "prog_detach_fail", "unexpected success\n"))
>> +       if (!ASSERT_ERR(err, "prog_detach_fail"))
>>                 goto cleanup;
>>
>>         /* BPF link is not allowed to replace another BPF link */
>> @@ -110,40 +110,40 @@ void serial_test_xdp_link(void)
>>         skel2->links.xdp_handler =3D link;
>>
>>         err =3D bpf_get_link_xdp_id(IFINDEX_LO, &id0, 0);
>> -       if (CHECK(err || id0 !=3D id2, "id2_check",
>> -                 "loaded prog id %u !=3D id2 %u, err %d", id0, id1, err=
))
>> +       if (!ASSERT_OK(err, "id2_check_err") || !ASSERT_EQ(id0, id2, "id=
2_check_val"))
>>                 goto cleanup;
>>
>>         /* updating program under active BPF link works as expected */
>>         err =3D bpf_link__update_program(link, skel1->progs.xdp_handler);
>> -       if (CHECK(err, "link_upd", "failed: %d\n", err))
>> +       if (!ASSERT_OK(err, "link_upd"))
>>                 goto cleanup;
>>
>>         memset(&link_info, 0, sizeof(link_info));
>>         err =3D bpf_obj_get_info_by_fd(bpf_link__fd(link), &link_info, &=
link_info_len);
>> -       if (CHECK(err, "link_info", "failed: %d\n", err))
>> +       if (!ASSERT_OK(err, "link_info"))
>> +               goto cleanup;
>> +
>> +       if (!ASSERT_EQ(link_info.type, BPF_LINK_TYPE_XDP, "link_type") ||
>> +           !ASSERT_EQ(link_info.prog_id, id1, "link_prog_id") ||
>> +           !ASSERT_EQ(link_info.xdp.ifindex, IFINDEX_LO, "link_ifindex"=
))
>>                 goto cleanup;
>>
>> -       CHECK(link_info.type !=3D BPF_LINK_TYPE_XDP, "link_type",
>> -             "got %u !=3D exp %u\n", link_info.type, BPF_LINK_TYPE_XDP);
>> -       CHECK(link_info.prog_id !=3D id1, "link_prog_id",
>> -             "got %u !=3D exp %u\n", link_info.prog_id, id1);
>> -       CHECK(link_info.xdp.ifindex !=3D IFINDEX_LO, "link_ifindex",
>> -             "got %u !=3D exp %u\n", link_info.xdp.ifindex, IFINDEX_LO);
>
> these checks were done unconditionally (and all of them), even if one
> of the fails. Why did you do goto cleanup for those. Similarly below.
> It's much cleaner to just have three ASSERT_EQ() statements one after
> the other with no if() goto cleanup;

Because I figured the absence of a 'goto cleanup' was an oversight :)

Not sure why you think it's cleaner, but I don't have any strong opinion
about it either way, so I can respin get rid of the containing ifs if
you prefer...

-Toke

