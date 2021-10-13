Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2038A42BB79
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbhJMJ3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:29:02 -0400
Received: from www62.your-server.de ([213.133.104.62]:50600 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235222AbhJMJ3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 05:29:01 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1maaXD-000CYg-0y; Wed, 13 Oct 2021 11:26:51 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1maaXC-000Cpw-PW; Wed, 13 Oct 2021 11:26:50 +0200
Subject: Re: [PATCH net-next 4/4] net, neigh: Add NTF_MANAGED flag for managed
 neighbor entries
To:     Ido Schimmel <idosch@idosch.org>
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        dsahern@kernel.org, m@lambda.lt, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20211011121238.25542-1-daniel@iogearbox.net>
 <20211011121238.25542-5-daniel@iogearbox.net> <YWW4alF5eSUS0QVK@shredder>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <959fd23f-27ad-8b5b-930f-1eca1a9d8fcc@iogearbox.net>
Date:   Wed, 13 Oct 2021 11:26:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <YWW4alF5eSUS0QVK@shredder>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26321/Wed Oct 13 10:21:20 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/12/21 6:31 PM, Ido Schimmel wrote:
> On Mon, Oct 11, 2021 at 02:12:38PM +0200, Daniel Borkmann wrote:
>> Allow a user space control plane to insert entries with a new NTF_EXT_MANAGED
>> flag. The flag then indicates to the kernel that the neighbor entry should be
>> periodically probed for keeping the entry in NUD_REACHABLE state iff possible.
> 
> Nice idea
> 
>> The use case for this is targeting XDP or tc BPF load-balancers which use
>> the bpf_fib_lookup() BPF helper in order to piggyback on neighbor resolution
>> for their backends. Given they cannot be resolved in fast-path,
> 
> Out of curiosity, can you explain why that is? Because XDP is only fast
> path? At least that's what I understand from commit 87f5fc7e48dd ("bpf:
> Provide helper to do forwarding lookups in kernel FIB table") and it is
> similar to L3 offload

Yep, exactly this. The packet reaches the BPF program at XDP (or tc) layer, it
does the usual mangling e.g. to forward to backends in case of LB, and pushes
the packet back out via XDP_{TX,REDIRECT}. (There is no way we could (or should)
do the neighbor resolution slow path from there.)

>> a control plane inserts the L3 (without L2) entries manually into the
>> neighbor table and lets the kernel do the neighbor resolution either
>> on the gateway or on the backend directly in case the latter resides
>> in the same L2. This avoids to deal with L2 in the control plane and
>> to rebuild what the kernel already does best anyway.
> 
> Are you using 'fib_multipath_use_neigh' sysctl to avoid going through
> failed nexthops? Looking at how the bpf_fib_lookup() helper is
> implemented, seems that you can benefit from it in XDP

Thanks for the pointer, we don't use it yet, but that's a great idea!

>> NTF_EXT_MANAGED can be combined with NTF_EXT_LEARNED in order to avoid GC
>> eviction. The kernel then adds NTF_MANAGED flagged entries to a per-neighbor
>> table which gets triggered by the system work queue to periodically call
>> neigh_event_send() for performing the resolution. The implementation allows
>> migration from/to NTF_MANAGED neighbor entries, so that already existing
>> entries can be converted by the control plane if needed. Potentially, we could
>> make the interval for periodically calling neigh_event_send() configurable;
>> right now it's set to DELAY_PROBE_TIME which is also in line with mlxsw which
>> has similar driver-internal infrastructure c723c735fa6b ("mlxsw: spectrum_router:
>> Periodically update the kernel's neigh table"). In future, the latter could
>> possibly reuse the NTF_MANAGED neighbors as well.
> 
> Yes, mlxsw can set this flag on neighbours used for its nexthops. Looks
> like the use cases are similar: Avoid going to slow path, either from
> XDP or HW.

Yes, correct.

> In our HW the nexthop table is squashed together with the neighbour
> table, so that it provides {netdev, MAC} and not {netdev, IP} with which
> the kernel performs another lookup in its neighbour table. We want to
> avoid situations where we perform multipathing between valid and failed
> nexthop (basically, fib_multipath_use_neigh=1), so we only program valid
> nexthop. But it means that nothing will trigger the resolution of the
> failed nexthops, thus the need to probe the neighbours.

Makes sense. Given you have the setup/HW, if you have a chance to consolidate
the mlxsw logic with the new NTF_MANAGED entries, that would be awesome!

>> Example:
>>
>>    # ./ip/ip n replace 192.168.178.30 dev enp5s0 managed extern_learn
>>    # ./ip/ip n
>>    192.168.178.30 dev enp5s0 lladdr f4:8c:50:5e:71:9a managed extern_learn REACHABLE
>>    [...]
>>
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>> Acked-by: Roopa Prabhu <roopa@nvidia.com>
>> Link: https://linuxplumbersconf.org/event/11/contributions/953/
> 
> I was going to ask why not just default the kernel to resolve GW IPs (it
> knows them when the nexthops are configured), but then I saw slide 34. I
> guess that's what you meant by "... or on the backend directly in case
> the latter resides in the same L2"?

Yes, that's correct, not on all setups the backends are behind a GW.

Thanks,
Daniel
