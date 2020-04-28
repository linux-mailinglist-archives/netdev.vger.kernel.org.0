Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BECE11BBB92
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 12:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgD1KsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 06:48:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22234 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726359AbgD1KsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 06:48:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588070884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OvyIdT/nyn4SeqBAXEe8lj0zZMxz+9eIzwFpjLeY35o=;
        b=gboljsGkUQN1TfIeb0Caj5uFJReWPS30IYyiVTGXQFo2o6042uSJJ5ulhqHwQh+KgeX8xz
        ldvev8jA5j7rW2gRh9uS/iifFDpEl9bn+dK12cMcXNZiFO3FBJuvUDeFR0tynf3eqbjWpw
        3db/eetkHYgT2tU39IZMDvE1FB+xVl8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-MyxBkWVIMKuUT5zcHul9fQ-1; Tue, 28 Apr 2020 06:48:00 -0400
X-MC-Unique: MyxBkWVIMKuUT5zcHul9fQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35424468;
        Tue, 28 Apr 2020 10:47:58 +0000 (UTC)
Received: from [10.36.113.197] (ovpn-113-197.ams2.redhat.com [10.36.113.197])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2CB97611AF;
        Tue, 28 Apr 2020 10:47:56 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
Cc:     "Yonghong Song" <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Network Development" <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Martin KaFai Lau" <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>,
        "Andrii Nakryiko" <andriin@fb.com>
Subject: Re: [RFC PATCH bpf-next 0/3] bpf: add tracing for XDP programs using
 the BPF_PROG_TEST_RUN API
Date:   Tue, 28 Apr 2020 12:47:53 +0200
Message-ID: <78EFC9DD-48A2-49BB-8C76-1E6FDE808067@redhat.com>
In-Reply-To: <20200428040424.wvozrsy6uviz33ha@ast-mbp.dhcp.thefacebook.com>
References: <158453675319.3043.5779623595270458781.stgit@xdp-tutorial>
 <819b1b3a-c801-754b-e805-7ec8266e5dfa@fb.com>
 <D0164AC9-7AF7-4434-B6D1-0A761DC626FB@redhat.com>
 <fefda00a-1a08-3a53-efbc-93c36292b77d@fb.com>
 <CAADnVQ+SCu97cF5Li6nBBCkshjF45U-nPEO5jO8DQrY5PqPqyg@mail.gmail.com>
 <F97A3E80-9C99-49CF-84C5-F09C940F7029@redhat.com>
 <20200428040424.wvozrsy6uviz33ha@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; markup=markdown
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28 Apr 2020, at 6:04, Alexei Starovoitov wrote:

> On Fri, Apr 24, 2020 at 02:29:56PM +0200, Eelco Chaudron wrote:
>>
>>> Not working with JIT-ed code is imo red flag for the approach as=20
>>> well.
>>
>> How would this be an issue, this is for the debug path only, and if=20
>> the
>> jitted code behaves differently than the interpreter there is a=20
>> bigger
>> issue.
>
> They are different already. Like tail_calls cannot mix and match=20
> interpreter
> and JITed. Similar with bpf2bpf calls.
> And that difference will be growing further.
> At that time of doing bpf trampoline I considering dropping support=20
> for
> interpreter, but then figured out a relatively cheap way of keeping it=20
> alive.
> I expect next feature to not support interpreter.

If the goal is to face out the interpreter then I have to agree it does=20
not make sense to add this facility based on it=E2=80=A6

>>> When every insn is spamming the logs the only use case I can see
>>> is to feed the test program with one packet and read thousand lines
>>> dump.
>>> Even that is quite user unfriendly.
>>
>> The log was for the POC only, the idea is to dump this in a user=20
>> buffer, and
>> with the right tooling (bpftool prog run ... {trace}?) it can be=20
>> stored in
>> an ELF file together with the program, and input/output. Then it=20
>> would be
>> easy to dump the C and eBPF program interleaved as bpftool does. If=20
>> GDB
>> would support eBPF, the format I envision would be good enough to=20
>> support
>> the GDB record/replay functionality.
>
> For the case you have in mind no kernel changes are necessary.
> Just run the interpreter in user space.
> It can be embedded in gdb binary, for example.

I do not believe a user-space approach would work, as you need support=20
for all helpers (and make sure they behave specifically to the kernel=20
version), as well you need all maps/memory available.

> Especially if you don't want to affect production server you=20
> definitely
> don't want to run anything on that machine.

With affecting production server I was not hinting towards some=20
performance degradation/CPU/memory usage, but not affecting any of the=20
traffic streams by inserting another packet into the network.

> As support person just grab the prog, capture the traffic and debug
> on their own server.
>
>>
>>> How about enabling kprobe in JITed code instead?
>>> Then if you really need to trap and print regs for every instruction=20
>>> you
>>> can
>>> still do so by placing kprobe on every JITed insn.
>>
>> This would even be harder as you need to understand the=20
>> ASM(PPC/ARM/x86) to
>> eBPF mapping (registers/code), where all you are interested in is=20
>> eBPF (to
>> C).
>
> Not really. gdb-like tool will hide all that from users.

Potentially yes if we get support for this in any gdb-like tool.

>> This kprobe would also affect all the instances of the program=20
>> running in
>> the system, i.e. for XDP, it could be assigned to all interfaces in=20
>> the
>> system.
>
> There are plenty of ways to solve that.
> Such kprobe in a prog can be gated by test_run cmd only.
> Or the prog .text can be cloned into new one and kprobed there.

Ack

>> And for this purpose, you are only interested in the results of a run=20
>> for a
>> specific packet (in the XDP use case) using the BPF_RUN_API so you=20
>> are not
>> affecting any live traffic.
>
> The only way to not affect live traffic is to provide support on
> a different machine.

See above

>>> But in reality I think few kprobes in the prog will be enough
>>> to debug the program and XDP prog may still process millions of=20
>>> packets
>>> because your kprobe could be in error path and the user may want to
>>> capture only specific things when it triggers.
>>> kprobe bpf prog will execute in such case and it can capture=20
>>> necessary
>>> state from xdp prog, from packet or from maps that xdp prog is=20
>>> using.
>>> Some sort of bpf-gdb would be needed in user space.
>>> Obviously people shouldn't be writing such kprob-bpf progs that=20
>>> debug
>>> other bpf progs by hand. bpf-gdb should be able to generate them
>>> automatically.
>>
>> See my opening comment. What you're describing here is more when the=20
>> right
>> developer has access to the specific system. But this might not even=20
>> be
>> possible in some environments.
>
> All I'm saying that kprobe is a way to trace kernel.
> The same facility should be used to trace bpf progs.

perf doesn=E2=80=99t support tracing bpf programs, do you know of any too=
ls=20
that can, or you have any examples that would do this?

>>
>> Let me know if your opinion on this idea changes after reading this,=20
>> or what
>> else is needed to convince you of the need ;)
>
> I'm very much against hacking in-kernel interpreter into register
> dumping facility.

If the goal is to eventually remove the interpreter and not even adding=20
new features to it I agree it does not make sense to continue this way.

> Either use kprobe+bpf for programmatic tracing or intel's pt for pure
> instruction trace.

