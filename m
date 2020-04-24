Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4020E1B74F8
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 14:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgDXMaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 08:30:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36804 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728138AbgDXMaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 08:30:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587731404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yvhdDT+AYnF1Zzo9qujwddDO+80lca7H6++h6WXn2Ho=;
        b=fIa2Um0hR5xGtNoIMMbsjhYVRRZeMjwis+d/5NHB2NJfTElfjtFcUT9qiUY51msPtJnKlW
        qXdA3lVEKYbChG4NI3MZNBjqjm5yyFkV+5x3oot/hzu7cP2X9ybgVn7Up32ASTIBK9r4l8
        UyYust7jAeF7Drhu+n+YgsLTSuLDVwQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-456-U3fRY_5fOLKe_JK8QBDtpw-1; Fri, 24 Apr 2020 08:30:02 -0400
X-MC-Unique: U3fRY_5fOLKe_JK8QBDtpw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1BCD107ACCD;
        Fri, 24 Apr 2020 12:30:00 +0000 (UTC)
Received: from [10.36.114.94] (ovpn-114-94.ams2.redhat.com [10.36.114.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AB478397;
        Fri, 24 Apr 2020 12:29:58 +0000 (UTC)
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
Date:   Fri, 24 Apr 2020 14:29:56 +0200
Message-ID: <F97A3E80-9C99-49CF-84C5-F09C940F7029@redhat.com>
In-Reply-To: <CAADnVQ+SCu97cF5Li6nBBCkshjF45U-nPEO5jO8DQrY5PqPqyg@mail.gmail.com>
References: <158453675319.3043.5779623595270458781.stgit@xdp-tutorial>
 <819b1b3a-c801-754b-e805-7ec8266e5dfa@fb.com>
 <D0164AC9-7AF7-4434-B6D1-0A761DC626FB@redhat.com>
 <fefda00a-1a08-3a53-efbc-93c36292b77d@fb.com>
 <CAADnVQ+SCu97cF5Li6nBBCkshjF45U-nPEO5jO8DQrY5PqPqyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20 Apr 2020, at 0:54, Alexei Starovoitov wrote:

> On Sun, Apr 19, 2020 at 12:02 AM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 4/16/20 5:45 AM, Eelco Chaudron wrote:
>>>
>>>
>>> On 23 Mar 2020, at 23:47, Yonghong Song wrote:
>>>
>>>> On 3/18/20 6:06 AM, Eelco Chaudron wrote:
>>>>> I sent out this RFC to get an idea if the approach suggested here
>>>>> would be something other people would also like to see. In 
>>>>> addition,
>>>>> this cover letter mentions some concerns and questions that need
>>>>> answers before we can move to an acceptable implementation.
>>>>>
>>>>> This patch adds support for tracing eBPF XDP programs that get
>>>>> executed using the __BPF_PROG_RUN syscall. This is done by 
>>>>> switching
>>>>> from JIT (if enabled) to executing the program using the 
>>>>> interpreter
>>>>> and record each executed instruction.
>
> sorry for delay. I only noticed these patches after Yonghong replied.

Hi Alexei, I have to disagree with most of your comments below :) 
However, I think it's due to not clearly stating the main use case I 
have in mind for this. This is not for a developer to be used to 
interactively debug an issue, but for an end-user/support person to get 
some initial data in a live environment without affecting any live 
traffic (assuming the XDP use case), as this tracing is only available 
using the BPF_PROG_RUN API. From my previous experience as an 
ASIC/Microcode network datapath engineer I have found that this kind of 
a debug output (how low level as it looks, but with the right tooling 
this should not be an issue) solves +/-80% of the cases I've worked on. 
The remaining 20% were almost always related to "user space" 
applications not populating tables, and other resources correctly.

> I think hacking interpreter to pr_info after every instruction is too
> much of a hack.

I agree if this would be for the normal interpreter path also, but this 
is a separate interpreter only used for the debug path.

> Not working with JIT-ed code is imo red flag for the approach as well.

How would this be an issue, this is for the debug path only, and if the 
jitted code behaves differently than the interpreter there is a bigger 
issue.

> When every insn is spamming the logs the only use case I can see
> is to feed the test program with one packet and read thousand lines 
> dump.
> Even that is quite user unfriendly.

The log was for the POC only, the idea is to dump this in a user buffer, 
and with the right tooling (bpftool prog run ... {trace}?) it can be 
stored in an ELF file together with the program, and input/output. Then 
it would be easy to dump the C and eBPF program interleaved as bpftool 
does. If GDB would support eBPF, the format I envision would be good 
enough to support the GDB record/replay functionality.


> How about enabling kprobe in JITed code instead?
> Then if you really need to trap and print regs for every instruction 
> you can
> still do so by placing kprobe on every JITed insn.

This would even be harder as you need to understand the ASM(PPC/ARM/x86) 
to eBPF mapping (registers/code), where all you are interested in is 
eBPF (to C).
This kprobe would also affect all the instances of the program running 
in the system, i.e. for XDP, it could be assigned to all interfaces in 
the system.
And for this purpose, you are only interested in the results of a run 
for a specific packet (in the XDP use case) using the BPF_RUN_API so you 
are not affecting any live traffic.

> But in reality I think few kprobes in the prog will be enough
> to debug the program and XDP prog may still process millions of 
> packets
> because your kprobe could be in error path and the user may want to
> capture only specific things when it triggers.
> kprobe bpf prog will execute in such case and it can capture necessary
> state from xdp prog, from packet or from maps that xdp prog is using.
> Some sort of bpf-gdb would be needed in user space.
> Obviously people shouldn't be writing such kprob-bpf progs that debug
> other bpf progs by hand. bpf-gdb should be able to generate them 
> automatically.

See my opening comment. What you're describing here is more when the 
right developer has access to the specific system. But this might not 
even be possible in some environments.


Let me know if your opinion on this idea changes after reading this, or 
what else is needed to convince you of the need ;)


