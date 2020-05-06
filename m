Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C824D1C6C4A
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 10:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728886AbgEFI5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 04:57:50 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22564 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728814AbgEFI5u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 04:57:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588755468;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yl7OAxvGIH897ejH+zHnHJaKaA8XauRnVd7h59WywxE=;
        b=AuTDvG+qP4VH5fKLnhdAr16NBOn7U+WD6/EF6TYgTBFAbkPsc/awDfwSVJ+OORk+baaMsH
        5CdnskRYUdL2jotBYaqieQlkD/DZDChpx/XeIIcIcIbz8giavS1fbcqw+xXccr4yS7goRZ
        maBFihCBSDtpSzfRplZj/bbboE5mkaU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-kHXNobeLMFW3Bst_oiNhDQ-1; Wed, 06 May 2020 04:57:34 -0400
X-MC-Unique: kHXNobeLMFW3Bst_oiNhDQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 89AC480183C;
        Wed,  6 May 2020 08:57:32 +0000 (UTC)
Received: from [10.36.113.103] (ovpn-113-103.ams2.redhat.com [10.36.113.103])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6397A5C1D6;
        Wed,  6 May 2020 08:57:27 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Andrii Nakryiko" <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Martin Lau" <kafai@fb.com>, "Song Liu" <songliubraving@fb.com>,
        "Yonghong Song" <yhs@fb.com>, "Andrii Nakryiko" <andriin@fb.com>,
        "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>
Subject: Re: [PATCH bpf-next v2] libbpf: fix probe code to return EPERM if
 encountered
Date:   Wed, 06 May 2020 10:57:24 +0200
Message-ID: <292BB732-5974-48E4-91EC-9482EF0E4600@redhat.com>
In-Reply-To: <CAEf4BzYHBisx0dLWn-Udp6saPqAA6ew_6W1BJ=zpcQOqWxPSPQ@mail.gmail.com>
References: <158858309381.5053.12391080967642755711.stgit@ebuild>
 <CAEf4BzYHBisx0dLWn-Udp6saPqAA6ew_6W1BJ=zpcQOqWxPSPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4 May 2020, at 20:43, Andrii Nakryiko wrote:

> On Mon, May 4, 2020 at 2:13 AM Eelco Chaudron <echaudro@redhat.com> =

> wrote:
>>
>> When the probe code was failing for any reason ENOTSUP was returned, =

>> even
>> if this was due to no having enough lock space. This patch fixes this =

>> by
>> returning EPERM to the user application, so it can respond and =

>> increase
>> the RLIMIT_MEMLOCK size.
>>
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>> ---
>> v2: Split bpf_object__probe_name() in two functions as suggested by =

>> Andrii
>
> Yeah, looks good, and this is good enough, so consider you have my
> ack. But I think we can further improve the experience by:
>
> 1. Changing existing "Couldn't load basic 'r0 =3D 0' BPF program."
> message to be something more meaningful and actionable for user. E.g.,
>
> "Couldn't load trivial BPF program. Make sure your kernel supports BPF
> (CONFIG_BPF_SYSCALL=3Dy) and/or that RLIMIT_MEMLOCK is set to big enoug=
h
> value."

I had pr_perm_msg() in the previous patch, but I forgot to put it back =

in :(
However your message looks way better, so I plan to send a v3 with the =

following:

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 6838e6d431ce..ad3043c5db13 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3170,8 +3170,10 @@ bpf_object__probe_loading(struct bpf_object *obj)
         ret =3D bpf_load_program_xattr(&attr, NULL, 0);
         if (ret < 0) {
                 cp =3D libbpf_strerror_r(errno, errmsg, sizeof(errmsg));=

-               pr_warn("Error in %s():%s(%d). Couldn't load basic 'r0 =3D=
 =

0' BPF program.\n",
-                       __func__, cp, errno);
+               pr_warn("Error in %s():%s(%d). Couldn't load trivial BPF =

"
+                       "program. Make sure your kernel supports BPF "
+                       "(CONFIG_BPF_SYSCALL=3Dy) and/or that =

RLIMIT_MEMLOCK is "
+                       "set to big enough value.\n", __func__, cp, =

errno);
                 return -errno;
         }
         close(ret);

> Then even complete kernel newbies can search for CONFIG_BPF_SYSCALL or
> RLIMIT_MEMLOCK and hopefully find useful discussions. We can/should
> add RLIMIT_MEMLOCK examples to some FAQ, probably as well (if it's not
> there already).

The xdp-tutorial repo has examples on how to set it to unlimited ;)
Also, the xdp-tool=E2=80=99s repo has some examples on how to dynamically=
 try =

to increase it, for examples:

http://172.16.1.201:8080/source/xref/xdp-tools/xdp-loader/xdp-loader.c?r=3D=
1926fc3d#198

> 2. I'd do bpf_object__probe_loading() before obj->loaded is set, so
> that user can have a loop of bpf_object__load() that bump
> RLIMIT_MEMLOCK in steps. After setting obj->loaded =3D true, user won't=

> be able to attemp loading again and will get "object should not be
> loaded twice\n".

Guess this was acked in Toke=E2=80=99s thread.

> [...]

