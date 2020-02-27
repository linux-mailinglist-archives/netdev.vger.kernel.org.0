Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDE3D172C75
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 00:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729882AbgB0Xp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 18:45:56 -0500
Received: from www62.your-server.de ([213.133.104.62]:50790 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729796AbgB0Xp4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 18:45:56 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j7Sqe-0002lT-Nj; Fri, 28 Feb 2020 00:45:44 +0100
Received: from [85.7.42.192] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j7Sqe-000XAx-Cs; Fri, 28 Feb 2020 00:45:44 +0100
Subject: Re: [PATCH bpf-next v2 4/4] bpf: inet_diag: Dump bpf_sk_storages in
 inet_diag_dump()
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>, kernel-team@fb.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
References: <20200225230402.1974723-1-kafai@fb.com>
 <20200225230427.1976129-1-kafai@fb.com>
 <938a0461-fd8d-b4b9-4fef-95d46409c0d6@iogearbox.net>
 <20200227013448.srxy5kkpve7yheln@kafai-mbp>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <ca31484f-4656-fb3e-8982-6a068bcb0738@iogearbox.net>
Date:   Fri, 28 Feb 2020 00:45:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200227013448.srxy5kkpve7yheln@kafai-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25735/Thu Feb 27 20:18:16 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/27/20 2:34 AM, Martin KaFai Lau wrote:
> On Wed, Feb 26, 2020 at 06:21:33PM +0100, Daniel Borkmann wrote:
>> On 2/26/20 12:04 AM, Martin KaFai Lau wrote:
>>> This patch will dump out the bpf_sk_storages of a sk
>>> if the request has the INET_DIAG_REQ_SK_BPF_STORAGES nlattr.
>>>
>>> An array of SK_DIAG_BPF_STORAGE_REQ_MAP_FD can be specified in
>>> INET_DIAG_REQ_SK_BPF_STORAGES to select which bpf_sk_storage to dump.
>>> If no map_fd is specified, all bpf_sk_storages of a sk will be dumped.
>>>
>>> bpf_sk_storages can be added to the system at runtime.  It is difficult
>>> to find a proper static value for cb->min_dump_alloc.
>>>
>>> This patch learns the nlattr size required to dump the bpf_sk_storages
>>> of a sk.  If it happens to be the very first nlmsg of a dump and it
>>> cannot fit the needed bpf_sk_storages,  it will try to expand the
>>> skb by "pskb_expand_head()".
>>>
>>> Instead of expanding it in inet_sk_diag_fill(), it is expanded at a
>>> sleepable context in __inet_diag_dump() so __GFP_DIRECT_RECLAIM can
>>> be used.  In __inet_diag_dump(), it will retry as long as the
>>> skb is empty and the cb->min_dump_alloc becomes larger than before.
>>> cb->min_dump_alloc is bounded by KMALLOC_MAX_SIZE.  The min_dump_alloc
>>> is also changed from 'u16' to 'u32' to accommodate a sk that may have
>>> a few large bpf_sk_storages.
>>>
>>> The updated cb->min_dump_alloc will also be used to allocate the skb in
>>> the next dump.  This logic already exists in netlink_dump().
>>>
>>> Here is the sample output of a locally modified 'ss' and it could be made
>>> more readable by using BTF later:
>>> [root@arch-fb-vm1 ~]# ss --bpf-map-id 14 --bpf-map-id 13 -t6an 'dst [::1]:8989'
>>> State Recv-Q Send-Q Local Address:Port  Peer Address:PortProcess
>>> ESTAB 0      0              [::1]:51072        [::1]:8989
>>> 	 bpf_map_id:14 value:[ 3feb ]
>>> 	 bpf_map_id:13 value:[ 3f ]
>>> ESTAB 0      0              [::1]:51070        [::1]:8989
>>> 	 bpf_map_id:14 value:[ 3feb ]
>>> 	 bpf_map_id:13 value:[ 3f ]
>>>
>>> [root@arch-fb-vm1 ~]# ~/devshare/github/iproute2/misc/ss --bpf-maps -t6an 'dst [::1]:8989'
>>> State         Recv-Q         Send-Q                   Local Address:Port                    Peer Address:Port         Process
>>> ESTAB         0              0                                [::1]:51072                          [::1]:8989
>>> 	 bpf_map_id:14 value:[ 3feb ]
>>> 	 bpf_map_id:13 value:[ 3f ]
>>> 	 bpf_map_id:12 value:[ 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000... total:65407 ]
>>> ESTAB         0              0                                [::1]:51070                          [::1]:8989
>>> 	 bpf_map_id:14 value:[ 3feb ]
>>> 	 bpf_map_id:13 value:[ 3f ]
>>> 	 bpf_map_id:12 value:[ 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000... total:65407 ]
>>>
>>> Acked-by: Song Liu <songliubraving@fb.com>
>>> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
>>
>> Hmm, the whole approach is not too pleasant to be honest. I can see why you need
>> it since the regular sk_storage lookup only takes sock fd as a key and you don't
>> have it otherwise available from outside, but then dumping up to KMALLOC_MAX_SIZE
>> via netlink skb is not a great experience either. :( Also, are we planning to add
>> the BTF dump there in addition to bpftool? Thus resulting in two different lookup
>> APIs and several tools needed for introspection instead of one? :/ Also, how do we
>> dump task local storage maps in future? Does it need a third lookup interface?
>>
>> In your commit logs I haven't read on other approaches and why they won't work;
>> I was wondering, given sockets are backed by inodes, couldn't we have a variant
>> of iget_locked() (minus the alloc_inode() part from there) where you pass in ino
>> number to eventually get to the socket and then dump the map value associated with
>> it the regular way from bpf() syscall?
> Thanks for the feedback!
> 
> I think (1) dumping all sk(s) in a system is different from
> (2) dumping all sk of a bpf_sk_storage_map or lookup a particular
> sk from a bpf_sk_storage_map.

Yeah, it is; I was mostly brain-storming if there is a cleaner way for (1)
by having (2)b resolved as an intermediate step (1) can then build on, but
seems it's tricky w/o much extra infra.

[...]
> 
> or the netlink can return map_id only when the max-sized skb cannot fit
> all the bpf_sk_storages.  The userspace then do another syscall to
> lookup the data from each individual bpf_sk_storage_map and
> that requires to lookup side support with another key (non-fd).
> IMO, it is weird and a bit opposite of what bpf_sk_storage should be (fast
> bpf_sk_storage lookup while holding a sk).  The iteration API already
> holds the sk but instead it is asking the usespace to go back to find
> out the sk again in order to get the bpf_sk_storages.  I think that
> should be avoided if possible.
> 
> Regarding i_ino, after looking at sock_alloc() and get_next_ino(),
> hmmm...is it unique?

It would wrap around after 2^32 allocations, so scratch that thought,
iget_locked()/find_inode_fast()-based lookup usage must ensure it's unique.

> If it is, what is the different usecase between i_ino and
> sk->sk_cookie?

Agree that advantage of reusing diag is that you already hold the sk and
are able to iterate through all of them, the ugly part is having to place
the value data into netlink as an API along with all other socket data as
a, for better or worse, bpf sk map lookup/introspection interface given
there is no other way to have a fast and global (non-fd based) id->socket
lookup interface that we could reuse atm.

I was wondering about sk->sk_cookie as well, but it wouldn't make sense
to do a ss dump, get (sk cookie, map_id) from the dump and use that for
a bpf() lookup if we need to reiterate the diag tables once again in the
background just to get the storage data. And I presume it won't make sense
either to reuse the diag's walk as a stand-alone for a bpf sk storage dump
interface API via bpf() ... at least from ss tool side it would require a
correlation based on sk cookie. Not nice either ... so current approach
might indeed be the tradeoff. :/

Thanks,
Daniel
