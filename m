Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9178015C083
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 15:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgBMOlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 09:41:19 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:53821 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725781AbgBMOlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 09:41:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581604877;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nh7A+i5hGvGRznwUm9e/CsaY5mKsbnQUgLtyPYJMw3U=;
        b=WVKDHgYBlKJSOs31AChy0GuUmAkkZtdrHpw91Gev6B3yfh65O8HOFPCrQm10vqiNweViBk
        Id4Oqs4e0pZyPotRY+jy2hW4xYVq6wlxd+UACM7qQ8CmZVCY4a9olFXXv7SSDLDE8xr0sO
        2xlmqhaaAN1gWi4PfzTuadEI4yW0cWs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-ztgeibA0N8CkCE6ukN-ADA-1; Thu, 13 Feb 2020 09:41:15 -0500
X-MC-Unique: ztgeibA0N8CkCE6ukN-ADA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BDC91B2C984;
        Thu, 13 Feb 2020 14:41:13 +0000 (UTC)
Received: from [10.36.116.194] (ovpn-116-194.ams2.redhat.com [10.36.116.194])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 477CE60BF1;
        Thu, 13 Feb 2020 14:41:08 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>
Cc:     "Andrii Nakryiko" <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Martin Lau" <kafai@fb.com>, "Song Liu" <songliubraving@fb.com>,
        "Yonghong Song" <yhs@fb.com>, "Andrii Nakryiko" <andriin@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: Add support for dynamic program attach
 target
Date:   Thu, 13 Feb 2020 15:41:06 +0100
Message-ID: <62B507DD-104D-4006-9FF0-204AD23B1505@redhat.com>
In-Reply-To: <871rqziicm.fsf@toke.dk>
References: <158151067149.71757.2222114135650741733.stgit@xdp-tutorial>
 <874kvwhs6u.fsf@toke.dk>
 <CAEf4BzYn3pVhqzj8PwRWxjWSJ16CS9d60zFtsS=OuA5ydPyp2Q@mail.gmail.com>
 <871rqziicm.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12 Feb 2020, at 22:52, Toke H=C3=B8iland-J=C3=B8rgensen wrote:

> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
>> On Wed, Feb 12, 2020 at 5:05 AM Toke H=C3=B8iland-J=C3=B8rgensen=20
>> <toke@redhat.com> wrote:
>>>
>>> Eelco Chaudron <echaudro@redhat.com> writes:
>>>
>>>> Currently when you want to attach a trace program to a bpf program
>>>> the section name needs to match the tracepoint/function semantics.
>>>>
>>>> However the addition of the bpf_program__set_attach_target() API
>>>> allows you to specify the tracepoint/function dynamically.
>>>>
>>>> The call flow would look something like this:
>>>>
>>>>   xdp_fd =3D bpf_prog_get_fd_by_id(id);
>>>>   trace_obj =3D bpf_object__open_file("func.o", NULL);
>>>>   prog =3D bpf_object__find_program_by_title(trace_obj,
>>>>                                            "fentry/myfunc");
>>>>   bpf_program__set_attach_target(prog, xdp_fd,
>>>>                                  "fentry/xdpfilt_blk_all");
>>>
>>> I think it would be better to have the attach type as a separate arg
>>> instead of encoding it in the function name. I.e., rather:
>>>
>>>    bpf_program__set_attach_target(prog, xdp_fd,
>>>                                   "xdpfilt_blk_all",=20
>>> BPF_TRACE_FENTRY);
>>
>> I agree about not specifying section name prefix (e.g., fentry/). But
>> disagree that expected attach type (BPF_TRACE_FENTRY) should be part
>> of this API. We already have bpf_program__set_expected_attach_type()
>> API, no need to duplicate it here.
>
> Ah yes, forgot about that; just keeping that and making this function
> name only is fine with me :)

Toke/Andrii,

Thanks for the feedback, will send out a v2 soon.

//Eelco

