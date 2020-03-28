Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 058941962E1
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 02:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbgC1BbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 21:31:03 -0400
Received: from www62.your-server.de ([213.133.104.62]:54556 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbgC1BbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 21:31:03 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jI0JL-0002SR-OL; Sat, 28 Mar 2020 02:30:55 +0100
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jI0JL-000W9f-Fi; Sat, 28 Mar 2020 02:30:55 +0100
Subject: Re: [PATCH bpf-next 3/7] bpf: add netns cookie and enable it for bpf
 cgroup hooks
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martynas Pumputis <m@lambda.lt>,
        Joe Stringer <joe@wand.net.nz>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
References: <cover.1585323121.git.daniel@iogearbox.net>
 <c47d2346982693a9cf9da0e12690453aded4c788.1585323121.git.daniel@iogearbox.net>
 <CAEf4BzbZiZwfae+B2gu4WkWVRoVkLJUYhFf0rorx0jVCf_kiQw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6c712f1a-60bc-d5c6-d6c3-311bb4df9faf@iogearbox.net>
Date:   Sat, 28 Mar 2020 02:30:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzbZiZwfae+B2gu4WkWVRoVkLJUYhFf0rorx0jVCf_kiQw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25764/Fri Mar 27 14:11:26 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/28/20 1:32 AM, Andrii Nakryiko wrote:
> On Fri, Mar 27, 2020 at 8:59 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>> In Cilium we're mainly using BPF cgroup hooks today in order to implement
>> kube-proxy free Kubernetes service translation for ClusterIP, NodePort (*),
>> ExternalIP, and LoadBalancer as well as HostPort mapping [0] for all traffic
>> between Cilium managed nodes. While this works in its current shape and avoids
>> packet-level NAT for inter Cilium managed node traffic, there is one major
>> limitation we're facing today, that is, lack of netns awareness.
>>
>> In Kubernetes, the concept of Pods (which hold one or multiple containers)
>> has been built around network namespaces, so while we can use the global scope
>> of attaching to root BPF cgroup hooks also to our advantage (e.g. for exposing
>> NodePort ports on loopback addresses), we also have the need to differentiate
>> between initial network namespaces and non-initial one. For example, ExternalIP
>> services mandate that non-local service IPs are not to be translated from the
>> host (initial) network namespace as one example. Right now, we have an ugly
>> work-around in place where non-local service IPs for ExternalIP services are
>> not xlated from connect() and friends BPF hooks but instead via less efficient
>> packet-level NAT on the veth tc ingress hook for Pod traffic.
>>
>> On top of determining whether we're in initial or non-initial network namespace
>> we also have a need for a socket-cookie like mechanism for network namespaces
>> scope. Socket cookies have the nice property that they can be combined as part
>> of the key structure e.g. for BPF LRU maps without having to worry that the
>> cookie could be recycled. We are planning to use this for our sessionAffinity
>> implementation for services. Therefore, add a new bpf_get_netns_cookie() helper
>> which would resolve both use cases at once: bpf_get_netns_cookie(NULL) would
>> provide the cookie for the initial network namespace while passing the context
>> instead of NULL would provide the cookie from the application's network namespace.
>> We're using a hole, so no size increase; the assignment happens only once.
>> Therefore this allows for a comparison on initial namespace as well as regular
>> cookie usage as we have today with socket cookies. We could later on enable
>> this helper for other program types as well as we would see need.
>>
>>    (*) Both externalTrafficPolicy={Local|Cluster} types
>>    [0] https://github.com/cilium/cilium/blob/master/bpf/bpf_sock.c
>>
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>> ---
>>   include/linux/bpf.h            |  1 +
>>   include/net/net_namespace.h    | 10 +++++++++
>>   include/uapi/linux/bpf.h       | 16 ++++++++++++++-
>>   kernel/bpf/verifier.c          | 16 +++++++++------
>>   net/core/filter.c              | 37 ++++++++++++++++++++++++++++++++++
>>   net/core/net_namespace.c       | 15 ++++++++++++++
>>   tools/include/uapi/linux/bpf.h | 16 ++++++++++++++-
>>   7 files changed, 103 insertions(+), 8 deletions(-)
>>
> 
> [...]
> 
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 745f3cfdf3b2..cb30b34d1466 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -3461,13 +3461,17 @@ static int check_func_arg(struct bpf_verifier_env *env, u32 regno,
>>                  expected_type = CONST_PTR_TO_MAP;
>>                  if (type != expected_type)
>>                          goto err_type;
>> -       } else if (arg_type == ARG_PTR_TO_CTX) {
>> +       } else if (arg_type == ARG_PTR_TO_CTX ||
>> +                  arg_type == ARG_PTR_TO_CTX_OR_NULL) {
>>                  expected_type = PTR_TO_CTX;
>> -               if (type != expected_type)
>> -                       goto err_type;
>> -               err = check_ctx_reg(env, reg, regno);
>> -               if (err < 0)
>> -                       return err;
>> +               if (!(register_is_null(reg) &&
>> +                     arg_type == ARG_PTR_TO_CTX_OR_NULL)) {
> 
> Other parts of check_func_arg() have different pattern that doesn't
> negate this complicated condition:
> 
> if (register_is_null(reg) && arg_type == ARG_PTR_TO_CTX_OR_NULL)
>      ;
> else {
>      ...
> }
> 
> It's marginally easier to follow, though still increases nestedness :(

Yeah, that looks a bit ugly tbh, but perhaps personal style/preference. I
tend to avoid such empty bodies.

>> +                       if (type != expected_type)
>> +                               goto err_type;
>> +                       err = check_ctx_reg(env, reg, regno);
>> +                       if (err < 0)
>> +                               return err;
>> +               }
>>          } else if (arg_type == ARG_PTR_TO_SOCK_COMMON) {
>>                  expected_type = PTR_TO_SOCK_COMMON;
>>                  /* Any sk pointer can be ARG_PTR_TO_SOCK_COMMON */
> 
> [...]
> 
>> +static const struct bpf_func_proto bpf_get_netns_cookie_sock_addr_proto = {
>> +       .func           = bpf_get_netns_cookie_sock_addr,
>> +       .gpl_only       = false,
>> +       .ret_type       = RET_INTEGER,
>> +       .arg1_type      = ARG_PTR_TO_CTX_OR_NULL,
> 
> Just for completeness sake, have you considered using two helpers -
> one accepting context and other accepting nothing instead of adding
> ARG_PTR_TO_CTX_OR_NULL? Would it be too bad?

I haven't considered it since it feels a bit too much churn to the helper
side for just this simple addition. Both helpers would be doing the same
and I would need to have it duplicated for sock_addr and sock once again
given we need it in both connect et al and bind contexts.

>> +};
>> +
> 
> [...]
> 
>> +static atomic64_t cookie_gen;
>> +
>> +u64 net_gen_cookie(struct net *net)
>> +{
>> +       while (1) {
>> +               u64 res = atomic64_read(&net->net_cookie);
>> +
>> +               if (res)
>> +                       return res;
>> +               res = atomic64_inc_return(&cookie_gen);
>> +               atomic64_cmpxchg(&net->net_cookie, 0, res);
> 
> you'll always do extra atomic64_read, even if you succeed on the first
> try. Why not:
> 
> while (1) {
>     u64 res = atomic64_read(&net->net_cookie);
>     if (res)
>         return res;
>     res = atomic64_inc_return(&cookie_gen);
>     if (atomic64_cmpxchg(&net->net_cookie, 0, res) == 0)
>        return res;
> }

Right, though it's on same CPU, so might not make too much of a noticeable
difference. I've used same scheme here as with socket cookies actually. I
thought about consolidating the generator into a separate function for both
as next step and reuse some of the ideas from get_next_ino() for batching to
optimize the atomic op cost, which should make a difference, but will do as
a separate patch.

>> +       }
>> +}
>> +
> 
> [...]
> 

