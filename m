Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A16A165E9B
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 14:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbgBTNVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 08:21:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60081 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727943AbgBTNVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 08:21:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582204880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p8tD1Rou6nllvRI7yrVkQ0N4FlocP+SU0LH+QwKL7tA=;
        b=A8Enq3+8MVq6MwcWfVyqWreas7vf0jMQb58nZftVXHZ4DCO7s18z6zXpnUFBfRo+DuLv0E
        omGjkvqIqK/qXLKTVp+FDxWvfm3oOwP0Ls67h1wk0vxkTo7zYSYO0E2esr1K/9J0hdaBir
        ekzQ1Hqjgia+2t5O7tU6rYjGLnVMOy8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-96-m9OCglxENN2C00f1mHUZRw-1; Thu, 20 Feb 2020 08:21:18 -0500
X-MC-Unique: m9OCglxENN2C00f1mHUZRw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EAA9800D55;
        Thu, 20 Feb 2020 13:21:16 +0000 (UTC)
Received: from [10.36.116.253] (ovpn-116-253.ams2.redhat.com [10.36.116.253])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9827360BE1;
        Thu, 20 Feb 2020 13:21:10 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Andrii Nakryiko" <andrii.nakryiko@gmail.com>
Cc:     "Jakub Sitnicki" <jakub@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Martin Lau" <kafai@fb.com>, "Song Liu" <songliubraving@fb.com>,
        "Yonghong Song" <yhs@fb.com>, "Andrii Nakryiko" <andriin@fb.com>,
        "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>
Subject: Re: [PATCH bpf-next v4 2/3] libbpf: Add support for dynamic program
 attach target
Date:   Thu, 20 Feb 2020 14:21:08 +0100
Message-ID: <90FEACCF-CF15-4694-9F51-4E3F6817439F@redhat.com>
In-Reply-To: <CAEf4BzY3cwPvj9=wo_GJxN=1=5fJL1RuhjEfey3N09GOL0YYfw@mail.gmail.com>
References: <158194337246.104074.6407151818088717541.stgit@xdp-tutorial>
 <158194341424.104074.4927911845622583345.stgit@xdp-tutorial>
 <877e0jam7z.fsf@cloudflare.com>
 <CAEf4BzZ_H7_HVL0uDkxP2hvW7FC=9r_V4X2VzgB+uZMZcxP7aQ@mail.gmail.com>
 <94BE5B07-CFC8-426F-B993-28D01E46BAE5@redhat.com>
 <CAEf4BzY3cwPvj9=wo_GJxN=1=5fJL1RuhjEfey3N09GOL0YYfw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 19 Feb 2020, at 18:41, Andrii Nakryiko wrote:

> On Wed, Feb 19, 2020 at 3:06 AM Eelco Chaudron <echaudro@redhat.com> wr=
ote:
>>
>>
>>
>> On 18 Feb 2020, at 22:24, Andrii Nakryiko wrote:
>>
>>> On Tue, Feb 18, 2020 at 8:34 AM Jakub Sitnicki <jakub@cloudflare.com>
>>> wrote:
>>>>
>>>> Hey Eelco,
>>>>
>>>> On Mon, Feb 17, 2020 at 12:43 PM GMT, Eelco Chaudron wrote:
>>>>> Currently when you want to attach a trace program to a bpf program
>>>>> the section name needs to match the tracepoint/function semantics.
>>>>>
>>>>> However the addition of the bpf_program__set_attach_target() API
>>>>> allows you to specify the tracepoint/function dynamically.
>>>>>
>>>>> The call flow would look something like this:
>>>>>
>>>>>   xdp_fd =3D bpf_prog_get_fd_by_id(id);
>>>>>   trace_obj =3D bpf_object__open_file("func.o", NULL);
>>>>>   prog =3D bpf_object__find_program_by_title(trace_obj,
>>>>>                                            "fentry/myfunc");
>>>>>   bpf_program__set_expected_attach_type(prog, BPF_TRACE_FENTRY);
>>>>>   bpf_program__set_attach_target(prog, xdp_fd,
>>>>>                                  "xdpfilt_blk_all");
>>>>>   bpf_object__load(trace_obj)
>>>>>
>>>>> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>>>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>>>>> ---
>>>>>  tools/lib/bpf/libbpf.c   |   34 ++++++++++++++++++++++++++++++----
>>>>>  tools/lib/bpf/libbpf.h   |    4 ++++
>>>>>  tools/lib/bpf/libbpf.map |    2 ++
>>>>>  3 files changed, 36 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>>>>> index 514b1a524abb..0c25d78fb5d8 100644
>>>>> --- a/tools/lib/bpf/libbpf.c
>>>>> +++ b/tools/lib/bpf/libbpf.c
>>>>
>>>> [...]
>>>>
>>>>> @@ -8132,6 +8133,31 @@ void bpf_program__bpil_offs_to_addr(struct
>>>>> bpf_prog_info_linear *info_linear)
>>>>>       }
>>>>>  }
>>>>>
>>>>> +int bpf_program__set_attach_target(struct bpf_program *prog,
>>>>> +                                int attach_prog_fd,
>>>>> +                                const char *attach_func_name)
>>>>> +{
>>>>> +     int btf_id;
>>>>> +
>>>>> +     if (!prog || attach_prog_fd < 0 || !attach_func_name)
>>>>> +             return -EINVAL;
>>>>> +
>>>>> +     if (attach_prog_fd)
>>>>> +             btf_id =3D libbpf_find_prog_btf_id(attach_func_name,
>>>>> +                                              attach_prog_fd);
>>>>> +     else
>>>>> +             btf_id =3D __find_vmlinux_btf_id(prog->obj->btf_vmlin=
ux,
>>>>> +                                            attach_func_name,
>>>>> +
>>>>> prog->expected_attach_type);
>>>>> +
>>>>> +     if (btf_id <=3D 0)
>>>>> +             return btf_id;
>>>>
>>>> Looks like we can get 0 as return value on both error and success
>>>> (below)?  Is that intentional?
>>>
>>> Neither libbpf_find_prog_btf_id nor __find_vmlinux_btf_id are going t=
o
>>> return 0 on failure. But I do agree that if (btf_id < 0) check would
>>> be better here.
>>
>> Is see in theory btf__find_by_name_kind() could return 0:
>>
>>         if (kind =3D=3D BTF_KIND_UNKN || !strcmp(type_name, "void"))
>>                 return 0;
>>
>> But for our case, this will not happen and is invalid, so what about
>> just to make sure its future proof?:
>>
>>    if (btf_id <=3D 0)
>>          return btf_id ? btf_id : -ENOENT;
>
> I don't see how void can be the right attach type, so I'd keep it
> simple: if (btf_id < 0) return btf_id.
> If it so happens that 0 is returned, it will fail at attach time anyway=
s.

Ok, will send out a v5 later today=E2=80=A6

>>> With that minor nit:
>>>
>>> Acked-by: Andrii Nakryiko <andriin@fb.com>
>>>
>>>>
>>>>> +
>>>>> +     prog->attach_btf_id =3D btf_id;
>>>>> +     prog->attach_prog_fd =3D attach_prog_fd;
>>>>> +     return 0;
>>>>> +}
>>>>> +
>>>>>  int parse_cpu_mask_str(const char *s, bool **mask, int *mask_sz)
>>>>>  {
>>>>>       int err =3D 0, n, len, start, end =3D -1;
>>>>
>>>> [...]
>>

