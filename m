Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A653E12E721
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 15:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbgABONX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 09:13:23 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47987 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728427AbgABONX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 09:13:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577974402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ag2JLgB6MWnezzVJRs86QwTCJWVo9Yhvt0qhzObIR9Y=;
        b=E9JQL4zxCMq5s1latY5Qm09kSHXM/gpnoKKtNpv7tRrtXWoYAIIXj9oUH/6U79HeGgZmrO
        ylcKO4duycL2QvWvqvKTUitNnkxOkAgdkodFbirMgidXx8XTUnHPqeVTuQPveln5RuzN45
        JGnSm97YGGUOTGe9+vqVE8ikND04HAs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-370-Ir9Eq76HOneKCW92U3vOHA-1; Thu, 02 Jan 2020 09:13:19 -0500
X-MC-Unique: Ir9Eq76HOneKCW92U3vOHA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB56A107ACC4;
        Thu,  2 Jan 2020 14:13:17 +0000 (UTC)
Received: from [10.36.116.211] (ovpn-116-211.ams2.redhat.com [10.36.116.211])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D2CE219C4F;
        Thu,  2 Jan 2020 14:13:16 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Andrii Nakryiko" <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next] selftests/bpf: Add a test for attaching a bpf
 fentry/fexit trace to an XDP program
Date:   Thu, 02 Jan 2020 15:13:15 +0100
Message-ID: <8F140E5A-2E29-4594-94BA-4D43B592A5B1@redhat.com>
In-Reply-To: <CAEf4BzYxDE5VoBiCaPwv=buUk87Cv0JF09usmQf0WvUceb8A5A@mail.gmail.com>
References: <157675340354.60799.13351496736033615965.stgit@xdp-tutorial>
 <CAEf4BzYxDE5VoBiCaPwv=buUk87Cv0JF09usmQf0WvUceb8A5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20 Dec 2019, at 0:02, Andrii Nakryiko wrote:

> On Thu, Dec 19, 2019 at 3:04 AM Eelco Chaudron <echaudro@redhat.com>=20
> wrote:
>>
>> Add a test that will attach a FENTRY and FEXIT program to the XDP=20
>> test
>> program. It will also verify data from the XDP context on FENTRY and
>> verifies the return code on exit.
>>
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>> ---
>>  .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |   95=20
>> ++++++++++++++++++++
>>  .../testing/selftests/bpf/progs/test_xdp_bpf2bpf.c |   44 +++++++++
>>  2 files changed, 139 insertions(+)
>>  create mode 100644=20
>> tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
>>  create mode 100644=20
>> tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
>>
>
> [...]
>
>> +       /* Load XDP program to introspect */
>> +       err =3D bpf_prog_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd)=
;
>
> Please use BPF skeleton for this test. It will make it significantly
> shorter and clearer. See other fentry_fexit selftest for example.
>

Trying to do this, however, I=E2=80=99m getting the following when trying=
 to=20
execute the test:

test_xdp_bpf2bpf:PASS:pkt_skel_load 0 nsec
libbpf: fentry/_xdp_tx_iptunnel is not found in vmlinux BTF
libbpf: failed to load object 'test_xdp_bpf2bpf'
libbpf: failed to load BPF skeleton 'test_xdp_bpf2bpf': -2
test_xdp_bpf2bpf:FAIL:ftrace_skel_load ftrace skeleton failed


My program is straight forward following the fentry_fexit.c example:

     pkt_skel =3D test_xdp__open_and_load();
     if (CHECK(!pkt_skel, "pkt_skel_load", "test_xdp skeleton=20
failed\n"))
         return;

     map_fd =3D bpf_map__fd(pkt_skel->maps.vip2tnl);
     bpf_map_update_elem(map_fd, &key4, &value4, 0);

     /* Load eBPF trace program */
     ftrace_skel =3D test_xdp_bpf2bpf__open_and_load();
     if (CHECK(!ftrace_skel, "ftrace_skel_load", "ftrace skeleton=20
failed\n"))
         goto out;

I assume this is due to the missing link from the XDP program to the=20
eBPF trace program.
Previously I did this trough:

+	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
+			    .attach_prog_fd =3D prog_fd,
+			   );
+
+	tracer_obj =3D bpf_object__open_file("./test_xdp_bpf2bpf.o", &opts);


If I use this approach as before it works, i.e.:

         DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts,
                             .attach_prog_fd =3D pkt_fd,
                            );

         ftrace_skel =3D test_xdp_bpf2bpf__open_opts(&opts);
         if (CHECK(!ftrace_skel, "__open_opts=E2=80=9D, "ftrace skeleton=20
failed\n"))
           goto out;
         if (CHECK(test_xdp_bpf2bpf__load(ftrace_skel), "__load",=20
"ftrace skeleton failed\n"))
           goto out;

But I do not see this in the fentry_fexit.c example, guess I might be=20
missing something that is right in front of me :(


[...]

