Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C861AC1AC
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 14:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636280AbgDPMp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 08:45:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31784 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2636238AbgDPMpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 08:45:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587041134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MV2bEo574pzJ3B0W4ffirdlVAA/eslNG/6SGnwVO9zw=;
        b=g4Tw1bdVdaTt0mL9Oj8Dh+E8hVFOr7BTL6JPoC4H7d0FEY6xWeHMckXVvPl6qesjuhIEky
        JVifUicNL5Q4G6Gzld5+YCzcSr6w4GmhST+WP0HnsSA03loJ0F+9BDKXTSu8Tc/KpcFaOn
        OpkX2QE2Lpoq+XjF9vlG8ff9ddNXIao=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-XO0Fg2ieO7qsSmJ1EX2xSw-1; Thu, 16 Apr 2020 08:45:32 -0400
X-MC-Unique: XO0Fg2ieO7qsSmJ1EX2xSw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB68B8024CD;
        Thu, 16 Apr 2020 12:45:30 +0000 (UTC)
Received: from [10.36.113.44] (ovpn-113-44.ams2.redhat.com [10.36.113.44])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 038925DA7D;
        Thu, 16 Apr 2020 12:45:28 +0000 (UTC)
From:   "Eelco Chaudron" <echaudro@redhat.com>
To:     "Yonghong Song" <yhs@fb.com>
Cc:     bpf@vger.kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, andriin@fb.com
Subject: Re: [RFC PATCH bpf-next 0/3] bpf: add tracing for XDP programs using
 the BPF_PROG_TEST_RUN API
Date:   Thu, 16 Apr 2020 14:45:26 +0200
Message-ID: <D0164AC9-7AF7-4434-B6D1-0A761DC626FB@redhat.com>
In-Reply-To: <819b1b3a-c801-754b-e805-7ec8266e5dfa@fb.com>
References: <158453675319.3043.5779623595270458781.stgit@xdp-tutorial>
 <819b1b3a-c801-754b-e805-7ec8266e5dfa@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; markup=markdown
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23 Mar 2020, at 23:47, Yonghong Song wrote:

> On 3/18/20 6:06 AM, Eelco Chaudron wrote:
>> I sent out this RFC to get an idea if the approach suggested here
>> would be something other people would also like to see. In addition,
>> this cover letter mentions some concerns and questions that need
>> answers before we can move to an acceptable implementation.
>>
>> This patch adds support for tracing eBPF XDP programs that get
>> executed using the __BPF_PROG_RUN syscall. This is done by switching
>> from JIT (if enabled) to executing the program using the interpreter
>> and record each executed instruction.
>
> Thanks for working on this! I think this is a useful feature
> to do semi single step in a safe environment. The initial input,
> e.g., packet or some other kernel context, may be captured
> in production error path. People can use this to easily
> do some post analysis. This feature can also be used for
> initial single-step debugging with better bpftool support.
>
>>
>> For now, the execution history is printed to the kernel ring buffer
>> using pr_info(), the final version should have enough data stored in=20
>> a
>> user-supplied buffer to reconstruct this output. This should probably
>> be part of bpftool, i.e. dump a similar output, and the ability to
>> store all this in an elf-like format for dumping/analyzing/replaying
>> at a later stage.
>>
>> This patch does not dump the XDP packet content before and after
>> execution, however, this data is available to the caller of the API.
>
> I would like to see the feature is implemented in a way to apply
> to all existing test_run program types and extensible to future
> program types.

Yes, this makes sense, but as I=E2=80=99m only familiar with the XDP part=
, I=20
focused on that.

> There are different ways to send data back to user. User buffer
> is one way, ring buffer is another way, seq_file can also be used.
> Performance is not a concern here, so we can choose the one with best
> usability.

As we need a buffer the easiest way would be to supply a user buffer. I=20
guess a raw perf buffer might also work, but the API might get=20
complex=E2=80=A6 I=E2=80=99ll dig into this a bit for the next RFC.

>>
>> The __bpf_prog_run_trace() interpreter is a copy of __bpf_prog_run()
>> and we probably need a smarter way to re-use the code rather than a
>> blind copy with some changes.
>
> Yes, reusing the code is a must. Using existing interpreter framework
> is the easiest for semi single step support.

Any idea how to do it cleanly? I guess I could move the interpreter code=20
out of the core file and include it twice.

>> Enabling the interpreter opens up the kernel for spectre variant 2,
>> guess that's why the BPF_JIT_ALWAYS_ON option was introduced (commit
>> 290af86629b2). Enabling it for debugging in the field does not sound
>> like an option (talking to people doing kernel distributions).
>> Any idea how to work around this (lfence before any call this will
>> slow down, but I guess for debugging this does not matter)? I need to
>> research this more as I'm no expert in this area. But I think this
>> needs to be solved as I see this as a show stopper. So any input is
>> welcome.
>
> lfence for indirect call is okay here for test_run. Just need to be
> careful to no introduce any performance penalty for non-test-run
> prog run.

My idea here was to do it at compile time and only if the interpreter=20
was disabled.

>>
>> To allow bpf_call support for tracing currently the general
>> interpreter is enabled. See the fixup_call_args() function for why
>> this is needed. We might need to find a way to fix this (see the=20
>> above
>> section on spectre).
>>
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>>

One final question did you (or anyone else) looked at the actual code=20
and have some tips, thinks look at?


I=E2=80=99ll try to do another RFC, cleaning up the duplicate interpreter=
=20
code, sent the actual trace data to userspace. Will hack some userspace=20
decoder together, or maybe even start integrating it in bpftool (if not=20
it will be part of the follow on RFC).

