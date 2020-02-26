Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1361705EB
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 18:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgBZRVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 12:21:45 -0500
Received: from www62.your-server.de ([213.133.104.62]:38092 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgBZRVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 12:21:45 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1j70NK-0001F8-IR; Wed, 26 Feb 2020 18:21:34 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1j70NK-000Suo-97; Wed, 26 Feb 2020 18:21:34 +0100
Subject: Re: [PATCH bpf-next v2 4/4] bpf: inet_diag: Dump bpf_sk_storages in
 inet_diag_dump()
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>, kernel-team@fb.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com
References: <20200225230402.1974723-1-kafai@fb.com>
 <20200225230427.1976129-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <938a0461-fd8d-b4b9-4fef-95d46409c0d6@iogearbox.net>
Date:   Wed, 26 Feb 2020 18:21:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200225230427.1976129-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25734/Tue Feb 25 15:06:17 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/26/20 12:04 AM, Martin KaFai Lau wrote:
> This patch will dump out the bpf_sk_storages of a sk
> if the request has the INET_DIAG_REQ_SK_BPF_STORAGES nlattr.
> 
> An array of SK_DIAG_BPF_STORAGE_REQ_MAP_FD can be specified in
> INET_DIAG_REQ_SK_BPF_STORAGES to select which bpf_sk_storage to dump.
> If no map_fd is specified, all bpf_sk_storages of a sk will be dumped.
> 
> bpf_sk_storages can be added to the system at runtime.  It is difficult
> to find a proper static value for cb->min_dump_alloc.
> 
> This patch learns the nlattr size required to dump the bpf_sk_storages
> of a sk.  If it happens to be the very first nlmsg of a dump and it
> cannot fit the needed bpf_sk_storages,  it will try to expand the
> skb by "pskb_expand_head()".
> 
> Instead of expanding it in inet_sk_diag_fill(), it is expanded at a
> sleepable context in __inet_diag_dump() so __GFP_DIRECT_RECLAIM can
> be used.  In __inet_diag_dump(), it will retry as long as the
> skb is empty and the cb->min_dump_alloc becomes larger than before.
> cb->min_dump_alloc is bounded by KMALLOC_MAX_SIZE.  The min_dump_alloc
> is also changed from 'u16' to 'u32' to accommodate a sk that may have
> a few large bpf_sk_storages.
> 
> The updated cb->min_dump_alloc will also be used to allocate the skb in
> the next dump.  This logic already exists in netlink_dump().
> 
> Here is the sample output of a locally modified 'ss' and it could be made
> more readable by using BTF later:
> [root@arch-fb-vm1 ~]# ss --bpf-map-id 14 --bpf-map-id 13 -t6an 'dst [::1]:8989'
> State Recv-Q Send-Q Local Address:Port  Peer Address:PortProcess
> ESTAB 0      0              [::1]:51072        [::1]:8989
> 	 bpf_map_id:14 value:[ 3feb ]
> 	 bpf_map_id:13 value:[ 3f ]
> ESTAB 0      0              [::1]:51070        [::1]:8989
> 	 bpf_map_id:14 value:[ 3feb ]
> 	 bpf_map_id:13 value:[ 3f ]
> 
> [root@arch-fb-vm1 ~]# ~/devshare/github/iproute2/misc/ss --bpf-maps -t6an 'dst [::1]:8989'
> State         Recv-Q         Send-Q                   Local Address:Port                    Peer Address:Port         Process
> ESTAB         0              0                                [::1]:51072                          [::1]:8989
> 	 bpf_map_id:14 value:[ 3feb ]
> 	 bpf_map_id:13 value:[ 3f ]
> 	 bpf_map_id:12 value:[ 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000... total:65407 ]
> ESTAB         0              0                                [::1]:51070                          [::1]:8989
> 	 bpf_map_id:14 value:[ 3feb ]
> 	 bpf_map_id:13 value:[ 3f ]
> 	 bpf_map_id:12 value:[ 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000... total:65407 ]
> 
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Hmm, the whole approach is not too pleasant to be honest. I can see why you need
it since the regular sk_storage lookup only takes sock fd as a key and you don't
have it otherwise available from outside, but then dumping up to KMALLOC_MAX_SIZE
via netlink skb is not a great experience either. :( Also, are we planning to add
the BTF dump there in addition to bpftool? Thus resulting in two different lookup
APIs and several tools needed for introspection instead of one? :/ Also, how do we
dump task local storage maps in future? Does it need a third lookup interface?

In your commit logs I haven't read on other approaches and why they won't work;
I was wondering, given sockets are backed by inodes, couldn't we have a variant
of iget_locked() (minus the alloc_inode() part from there) where you pass in ino
number to eventually get to the socket and then dump the map value associated with
it the regular way from bpf() syscall?

Thanks,
Daniel
