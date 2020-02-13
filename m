Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0674815C906
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 18:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727979AbgBMRAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 12:00:24 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:21625 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727851AbgBMRAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 12:00:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581613222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KSoTNA5A/Lx5C+MaQQE4MJfLQ1O7Tsrp3y3dTSpz15E=;
        b=UFCBYo+i3tr+WxbqIOys1aHeXIRlvPf+FlqwFrZJSVADDMgaTn2IEGOhfjrLUCyfWN2xv9
        2k3aYKPtOklAwet8fIyMDXJJYQ4mFzIYVaPz5zNohxWWWllzWevK7G49rw2Uzy4yS4CxfK
        9TADyRt0BmL1XzfVBt9HDqha1l1Tv+0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-Acb7qoWSOEqlTn3g64dRPg-1; Thu, 13 Feb 2020 12:00:19 -0500
X-MC-Unique: Acb7qoWSOEqlTn3g64dRPg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C17613F6;
        Thu, 13 Feb 2020 17:00:17 +0000 (UTC)
Received: from [10.36.116.194] (ovpn-116-194.ams2.redhat.com [10.36.116.194])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6020F26E77;
        Thu, 13 Feb 2020 17:00:06 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>
Cc:     bpf@vger.kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com
Subject: Re: [PATCH bpf-next v2] libbpf: Add support for dynamic program
 attach target
Date:   Thu, 13 Feb 2020 18:00:04 +0100
Message-ID: <47AD4CC2-4D14-419C-87FC-A86F5B7E0974@redhat.com>
In-Reply-To: <87h7zuh5am.fsf@toke.dk>
References: <158160616195.80320.5636088335810242866.stgit@xdp-tutorial>
 <87h7zuh5am.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 13 Feb 2020, at 16:32, Toke H=C3=B8iland-J=C3=B8rgensen wrote:

> Eelco Chaudron <echaudro@redhat.com> writes:
>
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
>
> Hmm, one question about the attach_prog_fd usage:
>
>> +int bpf_program__set_attach_target(struct bpf_program *prog,
>> +				   int attach_prog_fd,
>> +				   const char *attach_func_name)
>> +{
>> +	int btf_id;
>> +
>> +	if (!prog || attach_prog_fd < 0 || !attach_func_name)
>> +		return -EINVAL;
>> +
>> +	if (attach_prog_fd)
>> +		btf_id =3D libbpf_find_prog_btf_id(attach_func_name,
>> +						 attach_prog_fd);
>> +	else
>> +		btf_id =3D __find_vmlinux_btf_id(prog->obj->btf_vmlinux,
>> +					       attach_func_name,
>> +					       prog->expected_attach_type);
>
> This implies that no one would end up using fd 0 as a legitimate prog
> fd. This already seems to be the case for the existing code, but is=20
> that
> really a safe assumption? Couldn't a caller that closes fd 0 (for
> instance while forking) end up having it reused? Seems like this could
> result in weird hard-to-debug bugs?


Yes, in theory, this can happen but it has nothing to do with this=20
specific patch. The existing code already assumes that attach_prog_fd =3D=
=3D=20
0 means attach to a kernel function :(

