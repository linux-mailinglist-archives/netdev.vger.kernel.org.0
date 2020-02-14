Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB83715D2DD
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 08:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728914AbgBNHem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 02:34:42 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59896 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728779AbgBNHel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 02:34:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581665679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1vTB07YCHquUQRM8bojAgZpjMe0UTX9SMv5SiNm5LOI=;
        b=e8Eny1EfidtErfpAFV0MQmyCoOPlzf0MH+TbYpUjqDZV9S4t/oxqi33F/DMPswRYJMlra9
        V9gQgdqfSy1Q3ifjxEE7xFImtxN8iOSuRh8SLQhvR8inp8xmI7lsSQoU+1z3g63sJrnN6Y
        YTh7exEj+eXD1u/P1iUtinP8pXAGJDE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-gFvEo78qM1yO2J4hbv0WnQ-1; Fri, 14 Feb 2020 02:34:38 -0500
X-MC-Unique: gFvEo78qM1yO2J4hbv0WnQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2CE7D18B9F80;
        Fri, 14 Feb 2020 07:34:36 +0000 (UTC)
Received: from [10.36.116.117] (ovpn-116-117.ams2.redhat.com [10.36.116.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D6865DA87;
        Fri, 14 Feb 2020 07:34:31 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Andrii Nakryiko" <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Martin Lau" <kafai@fb.com>, "Song Liu" <songliubraving@fb.com>,
        "Yonghong Song" <yhs@fb.com>, "Andrii Nakryiko" <andriin@fb.com>,
        "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>
Subject: Re: [PATCH bpf-next v2] libbpf: Add support for dynamic program
 attach target
Date:   Fri, 14 Feb 2020 08:34:28 +0100
Message-ID: <E8D7E3C9-A0C8-4AFC-A7AE-BB6123E687C8@redhat.com>
In-Reply-To: <CAEf4Bzb59yjEMzs=n7pmbCB-L6RfmGDQiOwDFBoh54aSps4Vsg@mail.gmail.com>
References: <158160616195.80320.5636088335810242866.stgit@xdp-tutorial>
 <CAEf4Bzb59yjEMzs=n7pmbCB-L6RfmGDQiOwDFBoh54aSps4Vsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 13 Feb 2020, at 18:42, Andrii Nakryiko wrote:

> On Thu, Feb 13, 2020 at 7:05 AM Eelco Chaudron <echaudro@redhat.com>=20
> wrote:
>>
>> Currently when you want to attach a trace program to a bpf program
>> the section name needs to match the tracepoint/function semantics.
>>
>> However the addition of the bpf_program__set_attach_target() API
>> allows you to specify the tracepoint/function dynamically.
>>
>> The call flow would look something like this:
>>
>>   xdp_fd =3D bpf_prog_get_fd_by_id(id);
>>   trace_obj =3D bpf_object__open_file("func.o", NULL);
>>   prog =3D bpf_object__find_program_by_title(trace_obj,
>>                                            "fentry/myfunc");
>>   bpf_program__set_expected_attach_type(prog, BPF_TRACE_FENTRY);
>>   bpf_program__set_attach_target(prog, xdp_fd,
>>                                  "xdpfilt_blk_all");
>>   bpf_object__load(trace_obj)
>>
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>> ---
>
> API-wise this looks good, thanks! Please address feedback below and
> re-submit once bpf-next opens. Can you please also convert one of
> existing selftests using open_opts's attach_prog_fd to use this API
> instead to have a demonstration there?

Yes will update the one I added for bfp2bpf testing=E2=80=A6

>> v1 -> v2: Remove requirement for attach type name in API
>>
>>  tools/lib/bpf/libbpf.c   |   33 +++++++++++++++++++++++++++++++--
>>  tools/lib/bpf/libbpf.h   |    4 ++++
>>  tools/lib/bpf/libbpf.map |    1 +
>>  3 files changed, 36 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index 514b1a524abb..9b8cab995580 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -4939,8 +4939,8 @@ int bpf_program__load(struct bpf_program *prog,=20
>> char *license, __u32 kern_ver)
>>  {
>>         int err =3D 0, fd, i, btf_id;
>>
>> -       if (prog->type =3D=3D BPF_PROG_TYPE_TRACING ||
>> -           prog->type =3D=3D BPF_PROG_TYPE_EXT) {
>> +       if ((prog->type =3D=3D BPF_PROG_TYPE_TRACING ||
>> +            prog->type =3D=3D BPF_PROG_TYPE_EXT) &&=20
>> !prog->attach_btf_id) {
>>                 btf_id =3D libbpf_find_attach_btf_id(prog);
>>                 if (btf_id <=3D 0)
>>                         return btf_id;
>> @@ -8132,6 +8132,35 @@ void bpf_program__bpil_offs_to_addr(struct=20
>> bpf_prog_info_linear *info_linear)
>>         }
>>  }
>>
>> +int bpf_program__set_attach_target(struct bpf_program *prog,
>> +                                  int attach_prog_fd,
>> +                                  const char *attach_func_name)
>> +{
>> +       int btf_id;
>> +
>> +       if (!prog || attach_prog_fd < 0 || !attach_func_name)
>> +               return -EINVAL;
>> +
>> +       if (attach_prog_fd)
>> +               btf_id =3D libbpf_find_prog_btf_id(attach_func_name,
>> +                                                attach_prog_fd);
>> +       else
>> +               btf_id =3D=20
>> __find_vmlinux_btf_id(prog->obj->btf_vmlinux,
>> +                                              attach_func_name,
>> +                                             =20
>> prog->expected_attach_type);
>> +
>> +       if (btf_id <=3D 0) {
>> +               if (!attach_prog_fd)
>> +                       pr_warn("%s is not found in vmlinux BTF\n",
>> +                               attach_func_name);
>
> libbpf_find_attach_btf_id's error reporting is misleading (it always
> reports as if error happened with vmlinux BTF, even if attach_prog_fd
> 0). Could you please fix that and add better error reporting here
> for attach_prog_fd>0 case here?
>

I did not add log messages for the btf_id > 0 case as they are covered=20
in the libbpf_find_prog_btf_id() function. Please let me know if this is=20
not enough.

>> +               return btf_id;
>> +       }
>> +
>> +       prog->attach_btf_id =3D btf_id;
>> +       prog->attach_prog_fd =3D attach_prog_fd;
>> +       return 0;
>> +}
>> +
>>  int parse_cpu_mask_str(const char *s, bool **mask, int *mask_sz)
>>  {
>>         int err =3D 0, n, len, start, end =3D -1;
>> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
>> index 3fe12c9d1f92..02fc58a21a7f 100644
>> --- a/tools/lib/bpf/libbpf.h
>> +++ b/tools/lib/bpf/libbpf.h
>> @@ -334,6 +334,10 @@ LIBBPF_API void
>>  bpf_program__set_expected_attach_type(struct bpf_program *prog,
>>                                       enum bpf_attach_type type);
>>
>> +LIBBPF_API int
>> +bpf_program__set_attach_target(struct bpf_program *prog, int=20
>> attach_prog_fd,
>> +                              const char *attach_func_name);
>> +
>>  LIBBPF_API bool bpf_program__is_socket_filter(const struct=20
>> bpf_program *prog);
>>  LIBBPF_API bool bpf_program__is_tracepoint(const struct bpf_program=20
>> *prog);
>>  LIBBPF_API bool bpf_program__is_raw_tracepoint(const struct=20
>> bpf_program *prog);
>> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
>> index b035122142bb..8aba5438a3f0 100644
>> --- a/tools/lib/bpf/libbpf.map
>> +++ b/tools/lib/bpf/libbpf.map
>> @@ -230,6 +230,7 @@ LIBBPF_0.0.7 {
>>                 bpf_program__name;
>>                 bpf_program__is_extension;
>>                 bpf_program__is_struct_ops;
>> +               bpf_program__set_attach_target;
>
> This will have to go into LIBBPF_0.0.8 once bpf-next opens. Please
> rebase and re-send then.

Will do=E2=80=A6

>>                 bpf_program__set_extension;
>>                 bpf_program__set_struct_ops;
>>                 btf__align_of;
>>

