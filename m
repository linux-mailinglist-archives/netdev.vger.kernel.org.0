Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526C022E729
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 09:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgG0H70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 03:59:26 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45837 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726997AbgG0H70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 03:59:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595836764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A7ceEH/IBbRDzPjZ3zNLZhmuGKzt5NhIhx/7uw5Xh8A=;
        b=gW9V3x1SnGJhH+Sz12GBTWYEayDgIue+9UCpi1DrNKWL9WMG0iohqh7hYWc90V6WuHja51
        VWeCIgnOXPfslWx1gqkqPG/ean8jgv8PaVvL26GSKQA2TcW7Ln8S5KBCW1iSg3uF7ZYEWe
        Nneb8DuwFrpD3fLZUz4n93iOEGonf7Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-157-QRm6h8_PNq-KIyl_jytbmg-1; Mon, 27 Jul 2020 03:59:22 -0400
X-MC-Unique: QRm6h8_PNq-KIyl_jytbmg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D9338064B1;
        Mon, 27 Jul 2020 07:59:21 +0000 (UTC)
Received: from [10.36.112.170] (ovpn-112-170.ams2.redhat.com [10.36.112.170])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D9FD89507;
        Mon, 27 Jul 2020 07:59:16 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Jiri Olsa" <jolsa@redhat.com>
Cc:     "Yonghong Song" <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, andriin@fb.com,
        toke@redhat.com
Subject: Re: fentry/fexit attach to EXT type XDP program does not work
Date:   Mon, 27 Jul 2020 09:59:14 +0200
Message-ID: <5CF6086F-412C-4934-9AC6-4B1821ADDF74@redhat.com>
In-Reply-To: <20200726122450.GC1175442@krava>
References: <159162546868.10791.12432342618156330247.stgit@ebuild>
 <42b0c8d3-e855-7531-b01c-a05414360aff@fb.com>
 <88B08061-F85B-454C-9E9D-234154B9F000@redhat.com>
 <20200726122450.GC1175442@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26 Jul 2020, at 14:24, Jiri Olsa wrote:

> On Tue, Jun 09, 2020 at 10:52:34AM +0200, Eelco Chaudron wrote:
>
> SNIP
>
>>>>    libbpf: failed to load object 'test_xdp_bpf2bpf'
>>>>    libbpf: failed to load BPF skeleton 'test_xdp_bpf2bpf': -4007
>>>>    test_xdp_fentry_ext:FAIL:__load ftrace skeleton failed
>>>>    #91 xdp_fentry_ext:FAIL
>>>>    Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
>>>>
>>>> Any idea what could be the case here? The same fentry/fexit attach
>>>> code works fine in the xdp_bpf2bpf.c tests case.
>>
>> <SNIP>
>>>
>>> I think this is not supported now. That is, you cannot attach a =

>>> fentry
>>> trace
>>> to the EXT program. The current implementation for fentry program =

>>> simply
>>> trying to find and match the signature of freplace program which by
>>> default
>>> is a pointer to void.
>>>
>>> It is doable in that in kernel we could recognize to-be-attached =

>>> program
>>> is
>>> a freplace and further trace down to find the real signature. The
>>> related
>>> kernel function is btf_get_prog_ctx_type(). You can try to implement =

>>> by
>>> yourself
>>> or I can have a patch for this once bpf-next opens.
>>
>> I=E2=80=99m not familiar with this area of the code, so if you could =

>> prepare a patch
>> that would nice.
>> You can also send it to me before bpf-next opens and I can verify it, =

>> and
>> clean up the self-test so it can be included as well.
>>
>
> hi,
> it seems that you cannot exten fentry/fexit programs,
> but it's possible to attach fentry/fexit to ext program.
>
>    /* Program extensions can extend all program types
>     * except fentry/fexit. The reason is the following.
>     * The fentry/fexit programs are used for performance
>     * analysis, stats and can be attached to any program
>     * type except themselves. When extension program is
>     * replacing XDP function it is necessary to allow
>     * performance analysis of all functions. Both original
>     * XDP program and its program extension. Hence
>     * attaching fentry/fexit to BPF_PROG_TYPE_EXT is
>     * allowed. If extending of fentry/fexit was allowed it
>     * would be possible to create long call chain
>     * fentry->extension->fentry->extension beyond
>     * reasonable stack size. Hence extending fentry is not
>     * allowed.
>     */
>
> I changed fexit_bpf2bpf.c test just to do a quick check
> and it seems to work:

Hi Jiri this is exactly what I=E2=80=99m trying, however when you do this=
 =

where the first argument is a pointer to some context data which you are =

accessing it=E2=80=99s failing in the verifier.
This is a link to the original email, which has a test patch attached =

that will show the failure when trying to load/attach the fentry =

function and access the context:

https://lore.kernel.org/bpf/159162546868.10791.12432342618156330247.stgit=
@ebuild/

//Eelco

>
>   # echo > /sys/kernel/debug/tracing/trace
>   #  ./test_progs -t fexit_bpf2bpf
>   #25 fexit_bpf2bpf:OK
>   Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED
>   # cat /sys/kernel/debug/tracing/trace | tail -2
>            <...>-75365 [012] d... 313932.416780: bpf_trace_printk: =

> ENTRY val 123
>            <...>-75365 [012] d... 313932.416784: bpf_trace_printk: =

> EXIT  val 123, ret 1
>
< SNIP>

