Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D811BFE89
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 16:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgD3Ojg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 10:39:36 -0400
Received: from www62.your-server.de ([213.133.104.62]:49104 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbgD3Ojg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 10:39:36 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jUALS-00019n-Rb; Thu, 30 Apr 2020 16:39:22 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jUALS-000VFj-HK; Thu, 30 Apr 2020 16:39:22 +0200
Subject: Re: [PATCH bpf-next v2] bpf: bpf_{g,s}etsockopt for struct bpf_sock
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>, sdf@google.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
References: <20200429170524.217865-1-sdf@google.com>
 <640e7fd3-4059-5ff8-f9ed-09b1becd0f7b@iogearbox.net>
 <20200429233312.GB241848@google.com>
 <20200430022405.55gt7v3y7ckdkepx@ast-mbp.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c8ede994-b99e-81b7-3492-f69603b426b4@iogearbox.net>
Date:   Thu, 30 Apr 2020 16:39:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200430022405.55gt7v3y7ckdkepx@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25798/Thu Apr 30 14:03:33 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/20 4:24 AM, Alexei Starovoitov wrote:
> On Wed, Apr 29, 2020 at 04:33:12PM -0700, sdf@google.com wrote:
>> On 04/30, Daniel Borkmann wrote:
>>> On 4/29/20 7:05 PM, Stanislav Fomichev wrote:
>>>> Currently, bpf_getsocktop and bpf_setsockopt helpers operate on the
>>>> 'struct bpf_sock_ops' context in BPF_PROG_TYPE_SOCK_OPS program.
>>>> Let's generalize them and make the first argument be 'struct bpf_sock'.
>>>> That way, in the future, we can allow those helpers in more places.
>>>>
>>>> BPF_PROG_TYPE_SOCK_OPS still has the existing helpers that operate
>>>> on 'struct bpf_sock_ops', but we add new bpf_{g,s}etsockopt that work
>>>> on 'struct bpf_sock'. [Alternatively, for BPF_PROG_TYPE_SOCK_OPS,
>>>> we can enable them both and teach verifier to pick the right one
>>>> based on the context (bpf_sock_ops vs bpf_sock).]
>>>>
>>>> As an example, let's allow those 'struct bpf_sock' based helpers to
>>>> be called from the BPF_CGROUP_INET{4,6}_CONNECT hooks. That way
>>>> we can override CC before the connection is made.
>>>>
>>>> v2:
>>>> * s/BPF_PROG_TYPE_CGROUP_SOCKOPT/BPF_PROG_TYPE_SOCK_OPS/
>>>>
>>>> Acked-by: John Fastabend <john.fastabend@gmail.com>
>>>> Acked-by: Martin KaFai Lau <kafai@fb.com>
>>>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
>>> [...]
>>>> +BPF_CALL_5(bpf_setsockopt, struct sock *, sk,
>>>> +	   int, level, int, optname, char *, optval, int, optlen)
>>>> +{
>>>> +	u32 flags = 0;
>>>> +	return _bpf_setsockopt(sk, level, optname, optval, optlen, flags);
>>>> +}
>>>> +
>>>> +static const struct bpf_func_proto bpf_setsockopt_proto = {
>>>> +	.func		= bpf_setsockopt,
>>>> +	.gpl_only	= false,
>>>> +	.ret_type	= RET_INTEGER,
>>>> +	.arg1_type	= ARG_PTR_TO_SOCKET,
>>>> +	.arg2_type	= ARG_ANYTHING,
>>>> +	.arg3_type	= ARG_ANYTHING,
>>>> +	.arg4_type	= ARG_PTR_TO_MEM,
>>>> +	.arg5_type	= ARG_CONST_SIZE,
>>>> +};
>>>> +
>>>> +BPF_CALL_5(bpf_getsockopt, struct sock *, sk,
>>>> +	   int, level, int, optname, char *, optval, int, optlen)
>>>> +{
>>>> +	return _bpf_getsockopt(sk, level, optname, optval, optlen);
>>>> +}
>>>> +
>>>>    static const struct bpf_func_proto bpf_getsockopt_proto = {
>>>>    	.func		= bpf_getsockopt,
>>>>    	.gpl_only	= false,
>>>>    	.ret_type	= RET_INTEGER,
>>>> +	.arg1_type	= ARG_PTR_TO_SOCKET,
>>>> +	.arg2_type	= ARG_ANYTHING,
>>>> +	.arg3_type	= ARG_ANYTHING,
>>>> +	.arg4_type	= ARG_PTR_TO_UNINIT_MEM,
>>>> +	.arg5_type	= ARG_CONST_SIZE,
>>>> +};
>>>> +
>>> [...]
>>>> @@ -6043,6 +6098,22 @@ sock_addr_func_proto(enum bpf_func_id func_id,
>>> const struct bpf_prog *prog)
>>>>    		return &bpf_sk_storage_get_proto;
>>>>    	case BPF_FUNC_sk_storage_delete:
>>>>    		return &bpf_sk_storage_delete_proto;
>>>> +	case BPF_FUNC_setsockopt:
>>>> +		switch (prog->expected_attach_type) {
>>>> +		case BPF_CGROUP_INET4_CONNECT:
>>>> +		case BPF_CGROUP_INET6_CONNECT:
>>>> +			return &bpf_setsockopt_proto;
>>
>>> Hm, I'm not sure this is safe. In the sock_addr_func_proto() we also have
>>> other helpers callable from connect hooks like sk_lookup_{tcp,udp} which
>>> return a PTR_TO_SOCKET_OR_NULL, and now we can pass those sockets also
>>> into
>>> bpf_{get,set}sockopt() helper after lookup to change various sk related
>>> stuff
>>> but w/o being under lock. Doesn't the sock_owned_by_me() yell here at
>>> minimum
>>> (I'd expect so)?
>> Ugh, good point, I missed the fact that sk_lookup_{tcp,udp} are there
>> for sock_addr :-( I can try to do a simple test case to verify
>> that sock_owned_by_me triggers, but I'm pretty certain it should
>> (I've been calling bpf_{s,g}etsockopt for context socket so it's quiet).
>>
>> I don't think there is any helper similar to sock_owned_by_me() that
>> I can call to verify that the socket is held by current thread
>> (without the lockdep splat) and bail out?
>>
>> In this case, is something like adding new PTR_TO_LOCKED_SOCKET_OR_NULL
>> is the way to go? Any other ideas?
> 
> Looks like networking will benefit from sleepable progs too.
> We could have just did lock_sock() inside bpf_setsockopt
> before setting cong control.
> In the mean time how about introducing try_lock_sock()
> that will bail out if it cannot grab the lock?
> For most practical cases that would work and eventually we
> can convert it to full lock_sock ?

Right, also, worst case we could also go back to having ctx as input arg.

Thanks,
Daniel
