Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEE60A39B1
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 16:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727904AbfH3O7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 10:59:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727751AbfH3O7i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 10:59:38 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70C352341B;
        Fri, 30 Aug 2019 14:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567177177;
        bh=yuEg/AYA1c6NUhWecZUlheoiYTGMOlPXr3slJwLMjBE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=u1JFAqN/QGD4Fr1TrQB0MS943k5rWA952cBRxVbOh9N0fjLhRovc2G1XoK6mDEGXl
         zQRqexm0Nzp2k5V9m7YyupViYZnXtEYln5bMhI0CMIUjUrnDUCChwEioFkGkCjYBXv
         Br+Hx3PpKg8ee/48k5R/YO9a0jdkk06ep3gGNN0A=
Subject: Re: [PATCH] seccomp: fix compilation errors in seccomp-bpf kselftest
To:     Alakesh Haloi <alakesh.haloi@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Cc:     linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuah <shuah@kernel.org>
References: <20190822215823.GA11292@ip-172-31-44-144.us-west-2.compute.internal>
 <30e993fe-de76-9831-7ecc-61fcbcd51ae0@kernel.org>
From:   shuah <shuah@kernel.org>
Message-ID: <b19f12c1-9d22-f366-ebb8-2ac0759bfebf@kernel.org>
Date:   Fri, 30 Aug 2019 08:59:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <30e993fe-de76-9831-7ecc-61fcbcd51ae0@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/30/19 8:09 AM, shuah wrote:
> On 8/22/19 3:58 PM, Alakesh Haloi wrote:
>> Without this patch we see following error while building and kselftest
>> for secccomp_bpf fails.
>>
>> seccomp_bpf.c:1787:20: error: ‘PTRACE_EVENTMSG_SYSCALL_ENTRY’ 
>> undeclared (first use in this function);
>> seccomp_bpf.c:1788:6: error: ‘PTRACE_EVENTMSG_SYSCALL_EXIT’ undeclared 
>> (first use in this function);
>>
>> Signed-off-by: Alakesh Haloi <alakesh.haloi@gmail.com>
>> ---
>>   tools/testing/selftests/seccomp/seccomp_bpf.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c 
>> b/tools/testing/selftests/seccomp/seccomp_bpf.c
>> index 6ef7f16c4cf5..2e619760fc3e 100644
>> --- a/tools/testing/selftests/seccomp/seccomp_bpf.c
>> +++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
>> @@ -1353,6 +1353,14 @@ TEST_F(precedence, log_is_fifth_in_any_order)
>>   #define PTRACE_EVENT_SECCOMP 7
>>   #endif
>> +#ifndef PTRACE_EVENTMSG_SYSCALL_ENTRY
>> +#define PTRACE_EVENTMSG_SYSCALL_ENTRY 1
>> +#endif
>> +
>> +#ifndef PTRACE_EVENTMSG_SYSCALL_EXIT
>> +#define PTRACE_EVENTMSG_SYSCALL_EXIT 2
>> +#endif
>> +
>>   #define IS_SECCOMP_EVENT(status) ((status >> 16) == 
>> PTRACE_EVENT_SECCOMP)
>>   bool tracer_running;
>>   void tracer_stop(int sig)
>>
> 
> Hi Kees,
> 
> Okay to apply this one for 5.4-rc1. Or is this going through bpf tree?
> If it is going through bpf tree:
> 
> Acked-by: Shuah Khan <skhan@linuxfoundation.org>
> 
> thanks,
> -- Shuah
> 

I saw your mail about Tycho's solution to be your preferred. Ignore this
message. I am applying Tycho's patch.

thanks,
-- Shuah
