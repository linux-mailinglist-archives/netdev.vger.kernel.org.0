Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70FAB270CDB
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 12:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgISKOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 06:14:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41117 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726097AbgISKOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 06:14:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600510452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aoVgzN6gz4PMJXa1bdz8RuSOTpnLg5Dub5S3R8LNFpM=;
        b=NpL+bbSbXy8qpeIl3LTCPaQO2NX7LMHra/DUa/lqaEl9ucHE6lfVl1kdg13y+19MeUjgjB
        a9PfBi5q0VSKs4YumFrBxj7U34Ynl9TCe0I4d6/bZ84dmhWCZZGLHmMrfJGYcbcadwwfGA
        A+4xKkRIuj7wfMC3BDQFhOxCQDVNBLI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-TZpLP7auMACDROxCVihLcw-1; Sat, 19 Sep 2020 06:14:11 -0400
X-MC-Unique: TZpLP7auMACDROxCVihLcw-1
Received: by mail-ej1-f71.google.com with SMTP id w10so3046808ejq.11
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 03:14:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=aoVgzN6gz4PMJXa1bdz8RuSOTpnLg5Dub5S3R8LNFpM=;
        b=Ba/XGRx5f5uTWWs0k1CnXrVPZCufLu2kHgif+vNkvF2Agijz1BmvIbYnXbOUiDPbqT
         OyNZ8v/7E4YP96Yy2uXkj0ODBSmDZBJ1WC9sJjZKFjX6EiyzYGoAsFtZvNDGdRnw2AZQ
         IpxWGbmW07PqujdB8xu8PtXMlko5oiybqUXZPMiZxCOkmQcIVUSDYzZ31UIpctdxMO0d
         9PEDSpooflZNRXgiOepEBHsdNwckb9IMYO6yac/VO4fu6jWC+RRQGHfSuApkNXGyXtIo
         pdk5gRE04iP6D8pZL6f/uSiOh5uYKn+ESon+3R3jEP0/fSQIixzQc28lphVsRJUIJS37
         9OBQ==
X-Gm-Message-State: AOAM532sgktRGGAztZX+6WpJLW5FKc98IDksziQpqFqY9wdRRl7P9mds
        t59E9WLESDRqcwlZlUOWl/ePGX6jJQPcqEQykAp7IatBjOkx4vyLj4nkyzkVUMEbSG8tDC31Gly
        YPlgSeVgslWxfxtWN
X-Received: by 2002:a50:93e2:: with SMTP id o89mr43022048eda.378.1600510449498;
        Sat, 19 Sep 2020 03:14:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwdl/PmWIJRkfi1tLx7cqcu5/2QxmFvjALeUEQ4br3jqXc5u2DTCLfvKaJovLbI87ZU+Cx87Q==
X-Received: by 2002:a50:93e2:: with SMTP id o89mr43022016eda.378.1600510449058;
        Sat, 19 Sep 2020 03:14:09 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id m6sm4124138ejb.85.2020.09.19.03.14.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 03:14:08 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 43F5B183A90; Sat, 19 Sep 2020 12:14:07 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v6 05/10] bpf: support attaching freplace
 programs to multiple attach points
In-Reply-To: <CAEf4BzajBMf9btVJLfOYNdEbBHgs1m5o=D5mDcmTV4gPYTf9-w@mail.gmail.com>
References: <160037400056.28970.7647821897296177963.stgit@toke.dk>
 <160037400605.28970.12030576233071570541.stgit@toke.dk>
 <CAEf4BzajBMf9btVJLfOYNdEbBHgs1m5o=D5mDcmTV4gPYTf9-w@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 19 Sep 2020 12:14:07 +0200
Message-ID: <871riyf500.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Thu, Sep 17, 2020 at 1:21 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>
>> This enables support for attaching freplace programs to multiple attach
>> points. It does this by amending the UAPI for bpf_link_Create with a tar=
get
>> btf ID that can be used to supply the new attachment point along with the
>> target program fd. The target must be compatible with the target that was
>> supplied at program load time.
>>
>> The implementation reuses the checks that were factored out of
>> check_attach_btf_id() to ensure compatibility between the BTF types of t=
he
>> old and new attachment. If these match, a new bpf_tracing_link will be
>> created for the new attach target, allowing multiple attachments to
>> co-exist simultaneously.
>>
>> The code could theoretically support multiple-attach of other types of
>> tracing programs as well, but since I don't have a use case for any of
>> those, there is no API support for doing so.
>>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>
> You patch set breaks at least bpf_iter tests:
>
> $ sudo ./test_progs -t bpf_iter
> ...
> #4 bpf_iter:FAIL
> Summary: 0/19 PASSED, 0 SKIPPED, 6 FAILED
>
> Please check and fix.

Huh, did notice something was broken, but they didn't when I reverted
the patch either, so I put it down to just the tests being broken. I'll
take another look :)

>>  include/linux/bpf.h            |    2 +
>>  include/uapi/linux/bpf.h       |    9 +++-
>>  kernel/bpf/syscall.c           |  101 +++++++++++++++++++++++++++++++++=
+------
>>  kernel/bpf/verifier.c          |    9 ++++
>>  tools/include/uapi/linux/bpf.h |    9 +++-
>>  5 files changed, 110 insertions(+), 20 deletions(-)
>>
>
> [...]
>
>> -static int bpf_tracing_prog_attach(struct bpf_prog *prog)
>> +static int bpf_tracing_prog_attach(struct bpf_prog *prog,
>> +                                  int tgt_prog_fd,
>> +                                  u32 btf_id)
>>  {
>>         struct bpf_link_primer link_primer;
>>         struct bpf_prog *tgt_prog =3D NULL;
>> +       struct bpf_trampoline *tr =3D NULL;
>>         struct bpf_tracing_link *link;
>> -       struct bpf_trampoline *tr;
>> +       struct btf_func_model fmodel;
>> +       u64 key =3D 0;
>> +       long addr;
>>         int err;
>>
>>         switch (prog->type) {
>> @@ -2589,6 +2595,28 @@ static int bpf_tracing_prog_attach(struct bpf_pro=
g *prog)
>
> bpf_tracing_prog_attach logic looks correct to me now, thanks.
>
>>                 goto out_put_prog;
>>         }
>>
>
> [...]
>
>> @@ -3934,6 +3986,16 @@ static int tracing_bpf_link_attach(const union bp=
f_attr *attr, struct bpf_prog *
>>         return -EINVAL;
>>  }
>>
>> +static int freplace_bpf_link_attach(const union bpf_attr *attr, struct =
bpf_prog *prog)
>
> Any reason to have this separate from tracing_bpf_link_attach? I'd
> merge them and do a simple switch inside, based on prog->type. It
> would also be easier to follow the flow if this expected_attach_type
> check was first and returned -EINVAL immediately at the top.

I created a different one function it had to be called at a different
place; don't mind combining them, though.

>> +{
>> +       if (attr->link_create.attach_type =3D=3D prog->expected_attach_t=
ype)
>> +               return bpf_tracing_prog_attach(prog,
>> +                                              attr->link_create.target_=
fd,
>> +                                              attr->link_create.target_=
btf_id);
>> +       return -EINVAL;
>> +
>
> nit: unnecessary empty line?
>
>> +}
>> +
>>  #define BPF_LINK_CREATE_LAST_FIELD link_create.iter_info_len
>>  static int link_create(union bpf_attr *attr)
>>  {
>> @@ -3944,18 +4006,25 @@ static int link_create(union bpf_attr *attr)
>>         if (CHECK_ATTR(BPF_LINK_CREATE))
>>                 return -EINVAL;
>>
>> -       ptype =3D attach_type_to_prog_type(attr->link_create.attach_type=
);
>> -       if (ptype =3D=3D BPF_PROG_TYPE_UNSPEC)
>> -               return -EINVAL;
>> -
>> -       prog =3D bpf_prog_get_type(attr->link_create.prog_fd, ptype);
>> +       prog =3D bpf_prog_get(attr->link_create.prog_fd);
>>         if (IS_ERR(prog))
>>                 return PTR_ERR(prog);
>>
>>         ret =3D bpf_prog_attach_check_attach_type(prog,
>>                                                 attr->link_create.attach=
_type);
>>         if (ret)
>> -               goto err_out;
>> +               goto out;
>> +
>> +       if (prog->type =3D=3D BPF_PROG_TYPE_EXT) {
>> +               ret =3D freplace_bpf_link_attach(attr, prog);
>> +               goto out;
>> +       }
>> +
>> +       ptype =3D attach_type_to_prog_type(attr->link_create.attach_type=
);
>> +       if (ptype =3D=3D BPF_PROG_TYPE_UNSPEC) {
>> +               ret =3D -EINVAL;
>> +               goto out;
>> +       }
>
> you seem to be missing a check that prog->type matches ptype,
> previously implicitly performed by bpf_prog_get_type(), no?

Ah yes, good catch! I played around with different versions of this, and
guess I forgot to put that check back in for this one...

-Toke

