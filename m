Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6062FE837
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 11:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729952AbhAUK5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 05:57:55 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:11422 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729612AbhAUKzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 05:55:23 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DLzlK6H6wzj9Nx;
        Thu, 21 Jan 2021 18:53:33 +0800 (CST)
Received: from [127.0.0.1] (10.69.30.204) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.498.0; Thu, 21 Jan 2021
 18:54:25 +0800
Subject: Re: [PATCH net-next v2 3/3] xsk: build skb by page
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>
CC:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <0461512be1925bece9bcda1b4924b09eaa4edd87.1611131344.git.xuanzhuo@linux.alibaba.com>
 <20210120135537.5184-1-alobakin@pm.me>
 <CAJ8uoz0=7UmJpqKGeb9BQp9qv_c6ioyxhtU4+B+j-Z01pc-BhQ@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <07aa9fdf-5074-37be-926c-e8e2e6a55665@huawei.com>
Date:   Thu, 21 Jan 2021 18:54:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAJ8uoz0=7UmJpqKGeb9BQp9qv_c6ioyxhtU4+B+j-Z01pc-BhQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/1/21 15:41, Magnus Karlsson wrote:
> On Wed, Jan 20, 2021 at 9:29 PM Alexander Lobakin <alobakin@pm.me> wrote:
>>
>> From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>> Date: Wed, 20 Jan 2021 16:30:56 +0800
>>
>>> This patch is used to construct skb based on page to save memory copy
>>> overhead.
>>>
>>> This function is implemented based on IFF_TX_SKB_NO_LINEAR. Only the
>>> network card priv_flags supports IFF_TX_SKB_NO_LINEAR will use page to
>>> directly construct skb. If this feature is not supported, it is still
>>> necessary to copy data to construct skb.
>>>
>>> ---------------- Performance Testing ------------
>>>
>>> The test environment is Aliyun ECS server.
>>> Test cmd:
>>> ```
>>> xdpsock -i eth0 -t  -S -s <msg size>
>>> ```
>>>
>>> Test result data:
>>>
>>> size    64      512     1024    1500
>>> copy    1916747 1775988 1600203 1440054
>>> page    1974058 1953655 1945463 1904478
>>> percent 3.0%    10.0%   21.58%  32.3%
>>>
>>> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
>>> Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
>>> ---
>>>  net/xdp/xsk.c | 104 ++++++++++++++++++++++++++++++++++++++++++++++++----------
>>>  1 file changed, 86 insertions(+), 18 deletions(-)
>>
>> Now I like the result, thanks!
>>
>> But Patchwork still display your series incorrectly (messages 0 and 1
>> are missing). I'm concerning maintainers may not take this in such
>> form. Try to pass the folder's name, not folder/*.patch to
>> git send-email when sending, and don't use --in-reply-to when sending
>> a new iteration.
> 
> Xuan,
> 
> Please make the new submission of the patch set a v3 even though you
> did not change the code. Just so we can clearly see it is the new
> submission.
> 
>>> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
>>> index 8037b04..40bac11 100644
>>> --- a/net/xdp/xsk.c
>>> +++ b/net/xdp/xsk.c
>>> @@ -430,6 +430,87 @@ static void xsk_destruct_skb(struct sk_buff *skb)
>>>       sock_wfree(skb);
>>>  }
>>>
>>> +static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
>>> +                                           struct xdp_desc *desc)
>>> +{
>>> +     u32 len, offset, copy, copied;
>>> +     struct sk_buff *skb;
>>> +     struct page *page;
>>> +     void *buffer;
>>> +     int err, i;
>>> +     u64 addr;
>>> +
>>> +     skb = sock_alloc_send_skb(&xs->sk, 0, 1, &err);
>>> +     if (unlikely(!skb))
>>> +             return ERR_PTR(err);
>>> +
>>> +     addr = desc->addr;
>>> +     len = desc->len;
>>> +
>>> +     buffer = xsk_buff_raw_get_data(xs->pool, addr);
>>> +     offset = offset_in_page(buffer);
>>> +     addr = buffer - xs->pool->addrs;
>>> +
>>> +     for (copied = 0, i = 0; copied < len; i++) {
>>> +             page = xs->pool->umem->pgs[addr >> PAGE_SHIFT];
>>> +
>>> +             get_page(page);
>>> +
>>> +             copy = min_t(u32, PAGE_SIZE - offset, len - copied);
>>> +
>>> +             skb_fill_page_desc(skb, i, page, offset, copy);
>>> +
>>> +             copied += copy;
>>> +             addr += copy;
>>> +             offset = 0;
>>> +     }
>>> +
>>> +     skb->len += len;
>>> +     skb->data_len += len;
>>> +     skb->truesize += len;
>>> +
>>> +     refcount_add(len, &xs->sk.sk_wmem_alloc);
>>> +
>>> +     return skb;
>>> +}
>>> +
>>> +static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
>>> +                                  struct xdp_desc *desc)
>>> +{
>>> +     struct sk_buff *skb = NULL;

It seems the above init is unnecessary, for the skb is always
set before being used.

>>> +
>>> +     if (xs->dev->priv_flags & IFF_TX_SKB_NO_LINEAR) {
>>> +             skb = xsk_build_skb_zerocopy(xs, desc);
>>> +             if (IS_ERR(skb))
>>> +                     return skb;
>>> +     } else {
>>> +             void *buffer;
>>> +             u32 len;
>>> +             int err;
>>> +
>>> +             len = desc->len;
>>> +             skb = sock_alloc_send_skb(&xs->sk, len, 1, &err);
>>> +             if (unlikely(!skb))
>>> +                     return ERR_PTR(err);
>>> +
>>> +             skb_put(skb, len);
>>> +             buffer = xsk_buff_raw_get_data(xs->pool, desc->addr);
>>> +             err = skb_store_bits(skb, 0, buffer, len);
>>> +             if (unlikely(err)) {
>>> +                     kfree_skb(skb);
>>> +                     return ERR_PTR(err);
>>> +             }
>>> +     }
>>> +
>>> +     skb->dev = xs->dev;
>>> +     skb->priority = xs->sk.sk_priority;
>>> +     skb->mark = xs->sk.sk_mark;
>>> +     skb_shinfo(skb)->destructor_arg = (void *)(long)desc->addr;
>>> +     skb->destructor = xsk_destruct_skb;
>>> +
>>> +     return skb;
>>> +}
>>> +
>>>  static int xsk_generic_xmit(struct sock *sk)
>>>  {
>>>       struct xdp_sock *xs = xdp_sk(sk);
>>> @@ -446,43 +527,30 @@ static int xsk_generic_xmit(struct sock *sk)
>>>               goto out;
>>>
>>>       while (xskq_cons_peek_desc(xs->tx, &desc, xs->pool)) {
>>> -             char *buffer;
>>> -             u64 addr;
>>> -             u32 len;
>>> -
>>>               if (max_batch-- == 0) {
>>>                       err = -EAGAIN;
>>>                       goto out;
>>>               }
>>>
>>> -             len = desc.len;
>>> -             skb = sock_alloc_send_skb(sk, len, 1, &err);
>>> -             if (unlikely(!skb))
>>> +             skb = xsk_build_skb(xs, &desc);
>>> +             if (IS_ERR(skb)) {
>>> +                     err = PTR_ERR(skb);
>>>                       goto out;
>>> +             }
>>>
>>> -             skb_put(skb, len);
>>> -             addr = desc.addr;
>>> -             buffer = xsk_buff_raw_get_data(xs->pool, addr);
>>> -             err = skb_store_bits(skb, 0, buffer, len);
>>>               /* This is the backpressure mechanism for the Tx path.
>>>                * Reserve space in the completion queue and only proceed
>>>                * if there is space in it. This avoids having to implement
>>>                * any buffering in the Tx path.
>>>                */
>>>               spin_lock_irqsave(&xs->pool->cq_lock, flags);
>>> -             if (unlikely(err) || xskq_prod_reserve(xs->pool->cq)) {
>>> +             if (xskq_prod_reserve(xs->pool->cq)) {
>>>                       spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
>>>                       kfree_skb(skb);
>>>                       goto out;
>>>               }
>>>               spin_unlock_irqrestore(&xs->pool->cq_lock, flags);
>>>
>>> -             skb->dev = xs->dev;
>>> -             skb->priority = sk->sk_priority;
>>> -             skb->mark = sk->sk_mark;
>>> -             skb_shinfo(skb)->destructor_arg = (void *)(long)desc.addr;
>>> -             skb->destructor = xsk_destruct_skb;
>>> -
>>>               err = __dev_direct_xmit(skb, xs->queue_id);
>>>               if  (err == NETDEV_TX_BUSY) {
>>>                       /* Tell user-space to retry the send */
>>> --
>>> 1.8.3.1
>>
>> Al
>>
> 
> .
> 

