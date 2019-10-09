Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75275D1444
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 18:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731793AbfJIQkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 12:40:01 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:51607 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731173AbfJIQkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 12:40:00 -0400
Received: from [192.168.1.110] (238.210.broadband10.iol.cz [90.177.210.238])
        (Authenticated sender: i.maximets@ovn.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id EF9A3200010;
        Wed,  9 Oct 2019 16:39:56 +0000 (UTC)
Subject: Re: [PATCH bpf] libbpf: fix passing uninitialized bytes to setsockopt
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
References: <20191009154238.15410-1-i.maximets@ovn.org>
 <CAEf4BzYtftYQaUa53pKE77cd5tnz3WDY2KDaixhT7XHQ8hyObg@mail.gmail.com>
From:   Ilya Maximets <i.maximets@ovn.org>
Message-ID: <6c1b8c0f-c317-e59e-de02-9b0afc2cb9a0@ovn.org>
Date:   Wed, 9 Oct 2019 18:39:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYtftYQaUa53pKE77cd5tnz3WDY2KDaixhT7XHQ8hyObg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.10.2019 18:29, Andrii Nakryiko wrote:
> On Wed, Oct 9, 2019 at 8:43 AM Ilya Maximets <i.maximets@ovn.org> wrote:
>>
>> 'struct xdp_umem_reg' has 4 bytes of padding at the end that makes
>> valgrind complain about passing uninitialized stack memory to the
>> syscall:
>>
>>    Syscall param socketcall.setsockopt() points to uninitialised byte(s)
>>      at 0x4E7AB7E: setsockopt (in /usr/lib64/libc-2.29.so)
>>      by 0x4BDE035: xsk_umem__create@@LIBBPF_0.0.4 (xsk.c:172)
>>    Uninitialised value was created by a stack allocation
>>      at 0x4BDDEBA: xsk_umem__create@@LIBBPF_0.0.4 (xsk.c:140)
>>
>> Padding bytes appeared after introducing of a new 'flags' field.
>>
>> Fixes: 10d30e301732 ("libbpf: add flags to umem config")
>> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
>> ---
>>   tools/lib/bpf/xsk.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
>> index a902838f9fcc..26d9db783560 100644
>> --- a/tools/lib/bpf/xsk.c
>> +++ b/tools/lib/bpf/xsk.c
>> @@ -139,7 +139,7 @@ int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
>>                              const struct xsk_umem_config *usr_config)
>>   {
>>          struct xdp_mmap_offsets off;
>> -       struct xdp_umem_reg mr;
>> +       struct xdp_umem_reg mr = {};
> 
> well, guess what, even with this explicit initialization, padding is
> not guaranteed to be initialized (and it's sometimes is not in
> practice, I ran into such problems), only since C11 standard it is
> specified that padding is also zero-initialized. You have to do memset
> to 0.

OK. Sure. I'll send v2.

> 
>>          struct xsk_umem *umem;
>>          socklen_t optlen;
>>          void *map;
>> --
>> 2.17.1
>>
