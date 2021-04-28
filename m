Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D3736D48C
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 11:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238043AbhD1JJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 05:09:53 -0400
Received: from www62.your-server.de ([213.133.104.62]:55294 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhD1JJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 05:09:52 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1lbgBt-0007y0-0E; Wed, 28 Apr 2021 11:09:05 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1lbgBs-000NdC-L2; Wed, 28 Apr 2021 11:09:04 +0200
Subject: Re: [PATCH bpf] xsk: fix for xp_aligned_validate_desc() when len ==
 chunk_size
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Network Development <netdev@vger.kernel.org>
References: <20210427121903.76556-1-xuanzhuo@linux.alibaba.com>
 <CAJ8uoz3fphwV9115NLpOi94w2N0j1Cn3DRJFJ2NvwA91zf+uBw@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <fbda6161-41a2-016f-a90f-f3fe5034f200@iogearbox.net>
Date:   Wed, 28 Apr 2021 11:09:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAJ8uoz3fphwV9115NLpOi94w2N0j1Cn3DRJFJ2NvwA91zf+uBw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26153/Tue Apr 27 13:09:27 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/21 10:00 AM, Magnus Karlsson wrote:
> On Tue, Apr 27, 2021 at 2:19 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
>>
>> When desc->len is equal to chunk_size, it is legal. But
>> xp_aligned_validate_desc() got "chunk_end" by desc->addr + desc->len
>> pointing to the next chunk during the check, which caused the check to
>> fail.
> 
> Thanks Xuan for the fix. Off-by-one error. A classic unfortunately.
> 
> Think your fix also makes it easier to understand the code too, so good.
> 
>> Fixes: 35fcde7f8deb ("xsk: support for Tx")
>> Fixes: bbff2f321a86 ("xsk: new descriptor addressing scheme")
> 
> Just did some quick research and it seems the bug was introduced in
> the bbff2f321a86 commit above, not the first one 35fcde7f8deb. Or am I
> mistaken?
> 
>> Fixes: 2b43470add8c ("xsk: Introduce AF_XDP buffer allocation API")
>> Fixes: 26062b185eee ("xsk: Explicitly inline functions and move definitions")
> 
> And in these two, the code was moved around first to a new function in
> 2b43470add8c, then this function was moved to a new file in
> 26062b185eee. I believe documenting this in your commit message would
> make life simpler for the nice people backporting this fix. Or is this
> implicit in the multiple Fixes tags? Could someone with more
> experience in these things comment please.

Fully agree with Magnus, providing more context in the commit message is
always appreciated. Xuan, please extend and resubmit. Thanks!

> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> 
>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>> ---
>>   net/xdp/xsk_queue.h | 7 +++----
>>   1 file changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
>> index 2823b7c3302d..40f359bf2044 100644
>> --- a/net/xdp/xsk_queue.h
>> +++ b/net/xdp/xsk_queue.h
>> @@ -128,13 +128,12 @@ static inline bool xskq_cons_read_addr_unchecked(struct xsk_queue *q, u64 *addr)
>>   static inline bool xp_aligned_validate_desc(struct xsk_buff_pool *pool,
>>                                              struct xdp_desc *desc)
>>   {
>> -       u64 chunk, chunk_end;
>> +       u64 chunk;
>>
>> -       chunk = xp_aligned_extract_addr(pool, desc->addr);
>> -       chunk_end = xp_aligned_extract_addr(pool, desc->addr + desc->len);
>> -       if (chunk != chunk_end)
>> +       if (desc->len > pool->chunk_size)
>>                  return false;
>>
>> +       chunk = xp_aligned_extract_addr(pool, desc->addr);
>>          if (chunk >= pool->addrs_cnt)
>>                  return false;
>>
>> --
>> 2.31.0
>>

