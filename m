Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5FAA231990
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 08:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgG2GaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 02:30:18 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:43300 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726290AbgG2GaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 02:30:18 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Jul 2020 02:30:16 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596004216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PPGYaK4xJdrEP87tE468dp8hHYYTvlGkgfQpKFXfJPc=;
        b=E1CiCBnvFv/oCP5R+Gi/FFnBVwcnitgoOn0LZbM8PStskPZe4Em79MYYXlOeDXl0iUTlNr
        XdCqugCtTNCpjbJctD76fNvybyHbbn6wcISjT+/R+At5W/xl+6UbUBnAUVQa6QBBhjmhT0
        BfbBF3iATQK6MJClcnURteNSbEwJsBc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-pi9APXFhPhKLFOGCIgXsNQ-1; Wed, 29 Jul 2020 02:24:04 -0400
X-MC-Unique: pi9APXFhPhKLFOGCIgXsNQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 30BC3106B242;
        Wed, 29 Jul 2020 06:24:03 +0000 (UTC)
Received: from [10.36.112.234] (ovpn-112-234.ams2.redhat.com [10.36.112.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3DC027854D;
        Wed, 29 Jul 2020 06:23:58 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Jiri Olsa" <jolsa@redhat.com>
Cc:     "Yonghong Song" <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, andriin@fb.com,
        toke@redhat.com
Subject: Re: fentry/fexit attach to EXT type XDP program does not work
Date:   Wed, 29 Jul 2020 08:23:56 +0200
Message-ID: <95AF8533-2C7D-4038-AD39-4C81DBF25551@redhat.com>
In-Reply-To: <20200727145313.GA1201271@krava>
References: <159162546868.10791.12432342618156330247.stgit@ebuild>
 <42b0c8d3-e855-7531-b01c-a05414360aff@fb.com>
 <88B08061-F85B-454C-9E9D-234154B9F000@redhat.com>
 <20200726122450.GC1175442@krava>
 <5CF6086F-412C-4934-9AC6-4B1821ADDF74@redhat.com>
 <20200727145313.GA1201271@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27 Jul 2020, at 16:53, Jiri Olsa wrote:

> On Mon, Jul 27, 2020 at 09:59:14AM +0200, Eelco Chaudron wrote:
>>
>>
>> On 26 Jul 2020, at 14:24, Jiri Olsa wrote:
>>
>>> On Tue, Jun 09, 2020 at 10:52:34AM +0200, Eelco Chaudron wrote:
>>>
>>> SNIP
>>>
>>>>>>    libbpf: failed to load object 'test_xdp_bpf2bpf'
>>>>>>    libbpf: failed to load BPF skeleton 'test_xdp_bpf2bpf': -4007
>>>>>>    test_xdp_fentry_ext:FAIL:__load ftrace skeleton failed
>>>>>>    #91 xdp_fentry_ext:FAIL
>>>>>>    Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
>>>>>>
>>>>>> Any idea what could be the case here? The same fentry/fexit =

>>>>>> attach
>>>>>> code works fine in the xdp_bpf2bpf.c tests case.
>>>>
>>>> <SNIP>
>>>>>
>>>>> I think this is not supported now. That is, you cannot attach a
>>>>> fentry
>>>>> trace
>>>>> to the EXT program. The current implementation for fentry
>>>>> program simply
>>>>> trying to find and match the signature of freplace program which =

>>>>> by
>>>>> default
>>>>> is a pointer to void.
>>>>>
>>>>> It is doable in that in kernel we could recognize to-be-attached
>>>>> program
>>>>> is
>>>>> a freplace and further trace down to find the real signature. The
>>>>> related
>>>>> kernel function is btf_get_prog_ctx_type(). You can try to
>>>>> implement by
>>>>> yourself
>>>>> or I can have a patch for this once bpf-next opens.
>>>>
>>>> I=E2=80=99m not familiar with this area of the code, so if you could=
 =

>>>> prepare
>>>> a patch
>>>> that would nice.
>>>> You can also send it to me before bpf-next opens and I can verify
>>>> it, and
>>>> clean up the self-test so it can be included as well.
>>>>
>>>
>>> hi,
>>> it seems that you cannot exten fentry/fexit programs,
>>> but it's possible to attach fentry/fexit to ext program.
>>>
>>>    /* Program extensions can extend all program types
>>>     * except fentry/fexit. The reason is the following.
>>>     * The fentry/fexit programs are used for performance
>>>     * analysis, stats and can be attached to any program
>>>     * type except themselves. When extension program is
>>>     * replacing XDP function it is necessary to allow
>>>     * performance analysis of all functions. Both original
>>>     * XDP program and its program extension. Hence
>>>     * attaching fentry/fexit to BPF_PROG_TYPE_EXT is
>>>     * allowed. If extending of fentry/fexit was allowed it
>>>     * would be possible to create long call chain
>>>     * fentry->extension->fentry->extension beyond
>>>     * reasonable stack size. Hence extending fentry is not
>>>     * allowed.
>>>     */
>>>
>>> I changed fexit_bpf2bpf.c test just to do a quick check
>>> and it seems to work:
>>
>> Hi Jiri this is exactly what I=E2=80=99m trying, however when you do t=
his =

>> where the
>> first argument is a pointer to some context data which you are =

>> accessing
>> it=E2=80=99s failing in the verifier.
>> This is a link to the original email, which has a test patch attached =

>> that
>> will show the failure when trying to load/attach the fentry function =

>> and
>> access the context:
>>
>> https://lore.kernel.org/bpf/159162546868.10791.12432342618156330247.st=
git@ebuild/
>
> ok, I tried to trace ext program with __sk_buff argument and I can see
> the issue as well.. can't acess the skb argument
>
> patch below fixes it for me, I can access the skb pointer and its data
> via probe read, like:
>
> 	SEC("fexit/new_get_skb_ifindex")
> 	int BPF_PROG(fexit_new_get_skb_ifindex, int val, struct __sk_buff =

> *skb, int var, int ret)
> 	{
> 		__u32 data;
> 		int err;
>
> 		bpf_printk("EXIT skb %p", skb);
> 		bpf_probe_read_kernel(&data, sizeof(data), &skb->data);
> 		bpf_printk("EXIT ret %d, data %p", err, data);
> 		return 0;
> 	}
>
> I think it should fix the xdp_md acess as well

Excellent patch ;) It works with xdp_md as well, and even better it does =

not require the bpf_probe_read_kernel(), so the test_xdp_bpf2bpf.c code =

just works.

Are you planning to send the patch upstream?

> jirka
>
>
> ---
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index ee36b7f60936..2145329f7b1b 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3828,6 +3828,10 @@ bool btf_ctx_access(int off, int size, enum =

> bpf_access_type type,
>  	}
>
>  	info->reg_type =3D PTR_TO_BTF_ID;
> +
> +	if (tgt_prog && tgt_prog->type =3D=3D BPF_PROG_TYPE_EXT)
> +		tgt_prog =3D tgt_prog->aux->linked_prog;
> +
>  	if (tgt_prog) {
>  		ret =3D btf_translate_to_vmlinux(log, btf, t, tgt_prog->type, arg);
>  		if (ret > 0) {

