Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED5235246A
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 02:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236250AbhDBAUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 20:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbhDBAUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 20:20:10 -0400
Received: from www62.your-server.de (www62.your-server.de [IPv6:2a01:4f8:d0a:276a::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB528C0613E6;
        Thu,  1 Apr 2021 17:20:10 -0700 (PDT)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lS7X8-0008fS-Ef; Fri, 02 Apr 2021 02:19:30 +0200
Received: from [85.7.101.30] (helo=pc-6.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lS7X7-0001gm-W8; Fri, 02 Apr 2021 02:19:30 +0200
Subject: Re: [PATCH bpf-next 3/5] libbpf: add low level TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
References: <20210325120020.236504-1-memxor@gmail.com>
 <20210325120020.236504-4-memxor@gmail.com>
 <CAEf4Bzbz9OQ_vfqyenurPV7XRVpK=zcvktwH2Dvj-9kUGL1e7w@mail.gmail.com>
 <20210328080648.oorx2no2j6zslejk@apollo>
 <CAEf4BzaMsixmrrgGv6Qr68Ytq8k9W+WP6m4Vdb1wDhDFBKStgw@mail.gmail.com>
 <48b99ccc-8ef6-4ba9-00f9-d7e71ae4fb5d@iogearbox.net>
 <20210331094400.ldznoctli6fljz64@apollo>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5d59b5ee-a21e-1860-e2e5-d03f89306fd8@iogearbox.net>
Date:   Fri, 2 Apr 2021 02:19:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210331094400.ldznoctli6fljz64@apollo>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/26127/Thu Apr  1 13:11:26 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/31/21 11:44 AM, Kumar Kartikeya Dwivedi wrote:
> On Wed, Mar 31, 2021 at 02:55:47AM IST, Daniel Borkmann wrote:
>> Do we even need the _block variant? I would rather prefer to take the chance
>> and make it as simple as possible, and only iff really needed extend with
>> other APIs, for example:
> 
> The block variant can be dropped, I'll use the TC_BLOCK/TC_DEV alternative which
> sets parent_id/ifindex properly.
> 
>>    bpf_tc_attach(prog_fd, ifindex, {INGRESS,EGRESS});
>>
>> Internally, this will create the sch_clsact qdisc & cls_bpf filter instance
>> iff not present yet, and attach to a default prio 1 handle 1, and _always_ in
>> direct-action mode. This is /as simple as it gets/ and we don't need to bother
>> users with more complex tc/cls_bpf internals unless desired. For example,
>> extended APIs could add prio/parent so that multi-prog can be attached to a
>> single cls_bpf instance, but even that could be a second step, imho.
> 
> I am not opposed to clsact qdisc setup if INGRESS/EGRESS is supplied (not sure
> how others feel about it).

What speaks against it? It would be 100% clear from API side where the prog is
being attached. Same as with tc cmdline where you specify 'ingress'/'egress'.

> We could make direct_action mode default, and similarly choose prio

To be honest, I wouldn't even support a mode from the lib/API side where direct_action
is not set. It should always be forced to true. Everything else is rather broken
setup-wise, imho, since it won't scale. We added direct_action a bit later to the
kernel than original cls_bpf, but if I would do it again today, I'd make it the
only available option. I don't see a reasonable use-case where you have it to false.

> as 1 by default instead of letting the kernel do it. Then you can just pass in
> NULL for bpf_tc_cls_opts and be close to what you're proposing. For protocol we
> can choose ETH_P_ALL by default too if the user doesn't set it.

Same here with ETH_P_ALL, I'm not sure anyone uses anything other than ETH_P_ALL,
so yes, that should be default.

> With these modifications, the equivalent would look like
> 	bpf_tc_cls_attach(prog_fd, TC_DEV(ifindex, INGRESS), NULL, &id);

Few things compared to bpf_tc_attach(prog_fd, ifindex, {INGRESS,EGRESS}):

1) nit, but why even 'cls' in the name. I think we shouldn't expose such old-days
    tc semantics to a user. Just bpf_tc_attach() is cleaner/simpler to understand.
2) What's the 'TC_DEV(ifindex, INGRESS)' macro doing exactly? Looks unnecessary,
    why not regular args to the API?
3) Exposed bpf_tc_attach() API could internally call a bpf_tc_attach_opts() API
    with preset defaults, and the latter could have all the custom bits if the user
    needs to go beyond the simple API, so from your bpf_tc_cls_attach() I'd also
    drop the NULL.
4) For the simple API I'd likely also drop the id (you could have a query API if
    needed).

> So as long as the user doesn't care about other details, they can just pass opts
> as NULL.

