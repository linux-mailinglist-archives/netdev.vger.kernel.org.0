Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40DF21C1086
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 11:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgEAJ4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 05:56:15 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43076 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728325AbgEAJ4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 05:56:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588326973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eAy8SCe/9ydqWgCfl9lh5fay1Ypq7aGYf5ZhZcirSyY=;
        b=hgH0XiGBK9kgCdNV7ePJoCxXv1OCwSGqh4Z0Wi3QocrG1Q2TDwPhfmAyVUt1+x7ltNIalX
        eS62L/9EoZcN/rK0l5L7o/am6qBqqwC4CFrZY2cT3pzXHipz3UpFcgWAraWEUSCmx1UrNc
        v12Acbk7nXLdsma1KGQtYrqmHEs/EKU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-NxxaCg39M9mbOVSXPTx_xg-1; Fri, 01 May 2020 05:56:09 -0400
X-MC-Unique: NxxaCg39M9mbOVSXPTx_xg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F049B107ACF2;
        Fri,  1 May 2020 09:56:06 +0000 (UTC)
Received: from [10.36.112.109] (ovpn-112-109.ams2.redhat.com [10.36.112.109])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 112F75D9CC;
        Fri,  1 May 2020 09:56:01 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Andrii Nakryiko" <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Martin Lau" <kafai@fb.com>, "Song Liu" <songliubraving@fb.com>,
        "Yonghong Song" <yhs@fb.com>, "Andrii Nakryiko" <andriin@fb.com>,
        "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>
Subject: Re: [PATCH bpf-next] libbpf: fix probe code to return EPERM if
 encountered
Date:   Fri, 01 May 2020 11:56:00 +0200
Message-ID: <5E1C3675-7D77-4A58-B2FD-CE92806DA363@redhat.com>
In-Reply-To: <CAEf4BzYeJxGuPC8rbsY5yvED8KNaq=7NULFPnwPdeEs==Srd1w@mail.gmail.com>
References: <158824221003.2338.9700507405752328930.stgit@ebuild>
 <CAEf4BzYeJxGuPC8rbsY5yvED8KNaq=7NULFPnwPdeEs==Srd1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 30 Apr 2020, at 20:12, Andrii Nakryiko wrote:

> On Thu, Apr 30, 2020 at 3:24 AM Eelco Chaudron <echaudro@redhat.com> 
> wrote:
>>
>> When the probe code was failing for any reason ENOTSUP was returned, 
>> even
>> if this was due to no having enough lock space. This patch fixes this 
>> by
>> returning EPERM to the user application, so it can respond and 
>> increase
>> the RLIMIT_MEMLOCK size.
>>
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>> ---
>>  tools/lib/bpf/libbpf.c |    7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index 8f480e29a6b0..a62388a151d4 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -3381,8 +3381,13 @@ bpf_object__probe_caps(struct bpf_object *obj)
>>
>>         for (i = 0; i < ARRAY_SIZE(probe_fn); i++) {
>>                 ret = probe_fn[i](obj);
>> -               if (ret < 0)
>> +               if (ret < 0) {
>>                         pr_debug("Probe #%d failed with %d.\n", i, 
>> ret);
>> +                       if (ret == -EPERM) {
>> +                               pr_perm_msg(ret);
>> +                               return ret;
>
> I think this is dangerous to do. This detection loop is not supposed
> to return error to user if any of the features are missing. I'd feel
> more comfortable if we split bpf_object__probe_name() into two tests:
> one testing trivial program and another testing same program with
> name. If the first one fails with EPERM -- then we can return error to
> user. If anything else fails -- that's ok. Thoughts?

Before sending the patch I briefly checked the existing probes and did 
not see any other code path that could lead to EPERM. But you are right 
that this might not be the case for previous kernels. So you suggest 
something like this?

diff --git a/src/libbpf.c b/src/libbpf.c
index ff91742..fd5fdee 100644
--- a/src/libbpf.c
+++ b/src/libbpf.c
@@ -3130,7 +3130,7 @@ int bpf_map__resize(struct bpf_map *map, __u32 
max_entries)
  }

  static int
-bpf_object__probe_name(struct bpf_object *obj)
+bpf_object__probe_loading(struct bpf_object *obj)
  {
         struct bpf_load_program_attr attr;
         char *cp, errmsg[STRERR_BUFSIZE];
@@ -3157,8 +3157,26 @@ bpf_object__probe_name(struct bpf_object *obj)
         }
         close(ret);

-       /* now try the same program, but with the name */
+       return 0;
+}

+static int
+bpf_object__probe_name(struct bpf_object *obj)
+{
+       struct bpf_load_program_attr attr;
+       struct bpf_insn insns[] = {
+               BPF_MOV64_IMM(BPF_REG_0, 0),
+               BPF_EXIT_INSN(),
+       };
+       int ret;
+
+       /* make sure loading with name works */
+
+       memset(&attr, 0, sizeof(attr));
+       attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
+       attr.insns = insns;
+       attr.insns_cnt = ARRAY_SIZE(insns);
+       attr.license = "GPL";
         attr.name = "test";
         ret = bpf_load_program_xattr(&attr, NULL, 0);
         if (ret >= 0) {
@@ -3328,6 +3346,11 @@ bpf_object__probe_caps(struct bpf_object *obj)
         };
         int i, ret;

+       if (bpf_object__probe_loading(obj) == -EPERM) {
+               pr_perm_msg(-EPERM);
+               return -EPERM;
+       }
+
         for (i = 0; i < ARRAY_SIZE(probe_fn); i++) {
                 ret = probe_fn[i](obj);
                 if (ret < 0)

Let me know, and I sent out a v2.

Cheers,

Eelco

