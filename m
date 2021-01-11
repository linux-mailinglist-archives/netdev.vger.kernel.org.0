Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54502F2156
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 22:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732793AbhAKVCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 16:02:11 -0500
Received: from www62.your-server.de ([213.133.104.62]:41410 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732725AbhAKVCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 16:02:04 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1kz4JT-0002MR-Hb; Mon, 11 Jan 2021 22:01:19 +0100
Received: from [85.7.101.30] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1kz4JT-0002bd-Ci; Mon, 11 Jan 2021 22:01:19 +0100
Subject: Re: [PATCH bpf-next 2/2] bpf: extend bind v4/v6 selftests for
 mark/prio/bindtoifindex
To:     Yonghong Song <yhs@fb.com>, ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <9dbbf51e7f6868b3e9c8610a8d49b4493fb1b50f.1610381606.git.daniel@iogearbox.net>
 <299c73acafd2c20d52624debb8a1e0019d85e6dd.1610381606.git.daniel@iogearbox.net>
 <1cf3b794-6b84-e6a4-bed3-6b72c480eafa@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1ba684dd-1fd8-7e71-4798-6abcfbb44eda@iogearbox.net>
Date:   Mon, 11 Jan 2021 22:01:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1cf3b794-6b84-e6a4-bed3-6b72c480eafa@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26046/Mon Jan 11 13:34:14 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/21 9:15 PM, Yonghong Song wrote:
> On 1/11/21 8:17 AM, Daniel Borkmann wrote:
>> Extend existing cgroup bind4/bind6 tests to add coverage for setting and
>> retrieving SO_MARK, SO_PRIORITY and SO_BINDTOIFINDEX at the bind hook.
>>
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> 
> Ack with a minor comments below.
> 
> Acked-by: Yonghong Song <yhs@fb.com>
> 
>> ---
>>   .../testing/selftests/bpf/progs/bind4_prog.c  | 41 +++++++++++++++++--
>>   .../testing/selftests/bpf/progs/bind6_prog.c  | 41 +++++++++++++++++--
>>   2 files changed, 74 insertions(+), 8 deletions(-)
>>
>> diff --git a/tools/testing/selftests/bpf/progs/bind4_prog.c b/tools/testing/selftests/bpf/progs/bind4_prog.c
>> index c6520f21f5f5..4479ac27b1d3 100644
>> --- a/tools/testing/selftests/bpf/progs/bind4_prog.c
>> +++ b/tools/testing/selftests/bpf/progs/bind4_prog.c
>> @@ -29,18 +29,47 @@ static __inline int bind_to_device(struct bpf_sock_addr *ctx)
>>       char veth2[IFNAMSIZ] = "test_sock_addr2";
>>       char missing[IFNAMSIZ] = "nonexistent_dev";
>>       char del_bind[IFNAMSIZ] = "";
>> +    int veth1_idx, veth2_idx;
>>       if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
>> -                &veth1, sizeof(veth1)))
>> +               &veth1, sizeof(veth1)))
>> +        return 1;
>> +    if (bpf_getsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
>> +               &veth1_idx, sizeof(veth1_idx)) || !veth1_idx)
>>           return 1;
>>       if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
>> -                &veth2, sizeof(veth2)))
>> +               &veth2, sizeof(veth2)))
>> +        return 1;
>> +    if (bpf_getsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
>> +               &veth2_idx, sizeof(veth2_idx)) || !veth2_idx ||
>> +        veth1_idx == veth2_idx)
>>           return 1;
>>       if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
>> -                &missing, sizeof(missing)) != -ENODEV)
>> +               &missing, sizeof(missing)) != -ENODEV)
>> +        return 1;
>> +    if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTOIFINDEX,
>> +               &veth1_idx, sizeof(veth1_idx)))
>>           return 1;
>>       if (bpf_setsockopt(ctx, SOL_SOCKET, SO_BINDTODEVICE,
>> -                &del_bind, sizeof(del_bind)))
>> +               &del_bind, sizeof(del_bind)))
>> +        return 1;
>> +
>> +    return 0;
>> +}
>> +
>> +static __inline int misc_opts(struct bpf_sock_addr *ctx, int opt)
>> +{
>> +    int old, tmp, new = 0xeb9f;
>> +
>> +    if (bpf_getsockopt(ctx, SOL_SOCKET, opt, &old, sizeof(old)) ||
>> +        old == new)
>> +        return 1;
> 
> Here, we assume old never equals to new. it would be good to add
> a comment to explicitly state this is true. Maybe in the future
> somebody will try to add more misc_opts which might have conflict
> here.

I thought it's obvious, but yes I can add a comment.

> Alternatively, you could pass in "new" values
> from user space with global variables for each option,
> but that may be an overkill.

Agree, that's overkill.

Thanks,
Daniel
