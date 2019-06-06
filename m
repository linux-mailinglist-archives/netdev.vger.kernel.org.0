Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD5B3689D
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 02:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfFFAJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 20:09:46 -0400
Received: from www62.your-server.de ([213.133.104.62]:60870 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbfFFAJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 20:09:45 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1hYfyP-0004rE-TM; Thu, 06 Jun 2019 02:09:42 +0200
Received: from [178.197.249.21] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hYfyP-000MmV-Lx; Thu, 06 Jun 2019 02:09:41 +0200
Subject: Re: [PATCH bpf 1/2] bpf: fix unconnected udp hooks
To:     Martin Lau <kafai@fb.com>
Cc:     "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>,
        Andrey Ignatov <rdna@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Martynas Pumputis <m@lambda.lt>
References: <3d59d0458a8a3a050d24f81e660fcccde3479a05.1559767053.git.daniel@iogearbox.net>
 <20190605235451.lqas2jgbur2sre4z@kafai-mbp.dhcp.thefacebook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <bcdc5ced-5bf0-a9c2-eeaf-01459e1d5b62@iogearbox.net>
Date:   Thu, 6 Jun 2019 02:09:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20190605235451.lqas2jgbur2sre4z@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25471/Wed Jun  5 10:12:21 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/06/2019 01:54 AM, Martin Lau wrote:
> On Wed, Jun 05, 2019 at 10:40:49PM +0200, Daniel Borkmann wrote:
>> Intention of cgroup bind/connect/sendmsg BPF hooks is to act transparently
>> to applications as also stated in original motivation in 7828f20e3779 ("Merge
>> branch 'bpf-cgroup-bind-connect'"). When recently integrating the latter
>> two hooks into Cilium to enable host based load-balancing with Kubernetes,
>> I ran into the issue that pods couldn't start up as DNS got broken. Kubernetes
>> typically sets up DNS as a service and is thus subject to load-balancing.
>>
>> Upon further debugging, it turns out that the cgroupv2 sendmsg BPF hooks API
>> is currently insufficent and thus not usable as-is for standard applications
>> shipped with most distros. To break down the issue we ran into with a simple
>> example:
>>
>>   # cat /etc/resolv.conf
>>   nameserver 147.75.207.207
>>   nameserver 147.75.207.208
>>
>> For the purpose of a simple test, we set up above IPs as service IPs and
>> transparently redirect traffic to a different DNS backend server for that
>> node:
>>
>>   # cilium service list
>>   ID   Frontend            Backend
>>   1    147.75.207.207:53   1 => 8.8.8.8:53
>>   2    147.75.207.208:53   1 => 8.8.8.8:53
>>
>> The attached BPF program is basically selecting one of the backends if the
>> service IP/port matches on the cgroup hook. DNS breaks here, because the
>> hooks are not transparent enough to applications which have built-in msg_name
>> address checks:
>>
>>   # nslookup 1.1.1.1
>>   ;; reply from unexpected source: 8.8.8.8#53, expected 147.75.207.207#53
>>   ;; reply from unexpected source: 8.8.8.8#53, expected 147.75.207.208#53
>>   ;; reply from unexpected source: 8.8.8.8#53, expected 147.75.207.207#53
>>   [...]
>>   ;; connection timed out; no servers could be reached
>>
>>   # dig 1.1.1.1
>>   ;; reply from unexpected source: 8.8.8.8#53, expected 147.75.207.207#53
>>   ;; reply from unexpected source: 8.8.8.8#53, expected 147.75.207.208#53
>>   ;; reply from unexpected source: 8.8.8.8#53, expected 147.75.207.207#53
>>   [...]
>>
>>   ; <<>> DiG 9.11.3-1ubuntu1.7-Ubuntu <<>> 1.1.1.1
>>   ;; global options: +cmd
>>   ;; connection timed out; no servers could be reached
>>
>> For comparison, if none of the service IPs is used, and we tell nslookup
>> to use 8.8.8.8 directly it works just fine, of course:
>>
>>   # nslookup 1.1.1.1 8.8.8.8
>>   1.1.1.1.in-addr.arpa	name = one.one.one.one.
>>
>> In order to fix this and thus act more transparent to the application,
>> this needs reverse translation on recvmsg() side. A minimal fix for this
>> API is to add similar recvmsg() hooks behind the BPF cgroups static key
>> such that the program can track state and replace the current sockaddr_in{,6}
>> with the original service IP. From BPF side, this basically tracks the
>> service tuple plus socket cookie in an LRU map where the reverse NAT can
>> then be retrieved via map value as one example. Side-note: the BPF cgroups
>> static key should be converted to a per-hook static key in future.
>>
>> Same example after this fix:
>>
>>   # cilium service list
>>   ID   Frontend            Backend
>>   1    147.75.207.207:53   1 => 8.8.8.8:53
>>   2    147.75.207.208:53   1 => 8.8.8.8:53
>>
>> Lookups work fine now:
>>
>>   # nslookup 1.1.1.1
>>   1.1.1.1.in-addr.arpa    name = one.one.one.one.
>>
>>   Authoritative answers can be found from:
>>
>>   # dig 1.1.1.1
>>
>>   ; <<>> DiG 9.11.3-1ubuntu1.7-Ubuntu <<>> 1.1.1.1
>>   ;; global options: +cmd
>>   ;; Got answer:
>>   ;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 51550
>>   ;; flags: qr rd ra ad; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1
>>
>>   ;; OPT PSEUDOSECTION:
>>   ; EDNS: version: 0, flags:; udp: 512
>>   ;; QUESTION SECTION:
>>   ;1.1.1.1.                       IN      A
>>
>>   ;; AUTHORITY SECTION:
>>   .                       23426   IN      SOA     a.root-servers.net. nstld.verisign-grs.com. 2019052001 1800 900 604800 86400
>>
>>   ;; Query time: 17 msec
>>   ;; SERVER: 147.75.207.207#53(147.75.207.207)
>>   ;; WHEN: Tue May 21 12:59:38 UTC 2019
>>   ;; MSG SIZE  rcvd: 111
>>
>> And from an actual packet level it shows that we're using the back end
>> server when talking via 147.75.207.20{7,8} front end:
>>
>>   # tcpdump -i any udp
>>   [...]
>>   12:59:52.698732 IP foo.42011 > google-public-dns-a.google.com.domain: 18803+ PTR? 1.1.1.1.in-addr.arpa. (38)
>>   12:59:52.698735 IP foo.42011 > google-public-dns-a.google.com.domain: 18803+ PTR? 1.1.1.1.in-addr.arpa. (38)
>>   12:59:52.701208 IP google-public-dns-a.google.com.domain > foo.42011: 18803 1/0/0 PTR one.one.one.one. (67)
>>   12:59:52.701208 IP google-public-dns-a.google.com.domain > foo.42011: 18803 1/0/0 PTR one.one.one.one. (67)
>>   [...]
>>
>> In order to be flexible and to have same semantics as in sendmsg BPF
>> programs, we only allow return codes in [1,1] range. In the sendmsg case
>> the program is called if msg->msg_name is present which can be the case
>> in both, connected and unconnected UDP.
>>
>> The former only relies on the sockaddr_in{,6} passed via connect(2) if
>> passed msg->msg_name was NULL. Therefore, on recvmsg side, we act in similar
>> way to call into the BPF program whenever a non-NULL msg->msg_name was
>> passed independent of sk->sk_state being TCP_ESTABLISHED or not. Note
>> that for TCP case, the msg->msg_name is ignored in the regular recvmsg
>> path and therefore not relevant.
>>
>> For the case of ip{,v6}_recv_error() paths, picked up via MSG_ERRQUEUE,
>> the hook is not called. This is intentional as it aligns with the same
>> semantics as in case of TCP cgroup BPF hooks right now. This might be
>> better addressed in future through a different bpf_attach_type such
>> that this case can be distinguished from the regular recvmsg paths,
>> for example.
> LGTM.

Thanks a lot for the review!

> They are new hooks.  Should it belong to bpf-next instead?

Given this is currently broken in that one of the main users (DNS) does
not work with the current API, my preference really is on bpf to get this
sorted out and fixed.

>> Fixes: 1cedee13d25a ("bpf: Hooks for sys_sendmsg")
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>> Cc: Andrey Ignatov <rdna@fb.com>
>> Cc: Martynas Pumputis <m@lambda.lt>
>> ---
>>  include/linux/bpf-cgroup.h     |  8 ++++++++
>>  include/uapi/linux/bpf.h       |  2 ++
>>  kernel/bpf/syscall.c           |  8 ++++++++
>>  kernel/bpf/verifier.c          | 12 ++++++++----
>>  net/core/filter.c              |  2 ++
>>  net/ipv4/udp.c                 |  4 ++++
>>  net/ipv6/udp.c                 |  4 ++++
>>  tools/bpf/bpftool/cgroup.c     |  5 ++++-
>>  tools/include/uapi/linux/bpf.h |  2 ++
> Should the bpf.h sync to tools/ be in a separate patch?

I was thinking about it, but concluded for such small change, it's not
really worth it. If there's a strong opinion, I could do it, but I think
that 2-liner sync patch just adds noise.

> [ ... ]
> 
>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>> index 95f93544..d2c8a66 100644
>> --- a/kernel/bpf/verifier.c
>> +++ b/kernel/bpf/verifier.c
>> @@ -5361,9 +5361,12 @@ static int check_return_code(struct bpf_verifier_env *env)
>>  	struct tnum range = tnum_range(0, 1);
>>  
>>  	switch (env->prog->type) {
>> +	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
>> +		if (env->prog->expected_attach_type == BPF_CGROUP_UDP4_RECVMSG ||
>> +		    env->prog->expected_attach_type == BPF_CGROUP_UDP6_RECVMSG)
>> +			range = tnum_range(1, 1);
>>  	case BPF_PROG_TYPE_CGROUP_SKB:
>>  	case BPF_PROG_TYPE_CGROUP_SOCK:
>> -	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
>>  	case BPF_PROG_TYPE_SOCK_OPS:
>>  	case BPF_PROG_TYPE_CGROUP_DEVICE:
>>  	case BPF_PROG_TYPE_CGROUP_SYSCTL:
>> @@ -5380,16 +5383,17 @@ static int check_return_code(struct bpf_verifier_env *env)
>>  	}
>>  
>>  	if (!tnum_in(range, reg->var_off)) {
>> +		char tn_buf[48];
>> +
>>  		verbose(env, "At program exit the register R0 ");
>>  		if (!tnum_is_unknown(reg->var_off)) {
>> -			char tn_buf[48];
>> -
>>  			tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
>>  			verbose(env, "has value %s", tn_buf);
>>  		} else {
>>  			verbose(env, "has unknown scalar value");
>>  		}
>> -		verbose(env, " should have been 0 or 1\n");
>> +		tnum_strn(tn_buf, sizeof(tn_buf), range);
>> +		verbose(env, " should have been in %s\n", tn_buf);
> A heads up that it may have a confict with a bpf-next commit
> 5cf1e9145630 ("bpf: cgroup inet skb programs can return 0 to 3")

Yep, that should pretty much be resolved by a merge given the code is
the same if I'm not mistaken, but in any case looks trivial.

>>  		return -EINVAL;
>>  	}
>>  	return 0;

