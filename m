Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8260B19B9D7
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 03:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733213AbgDBBXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 21:23:24 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:49440 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732462AbgDBBXX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 21:23:23 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4C5354C9FB92A9B66279;
        Thu,  2 Apr 2020 09:23:17 +0800 (CST)
Received: from [127.0.0.1] (10.173.223.60) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 2 Apr 2020
 09:23:12 +0800
Subject: Re: [PATCH net v2] veth: xdp: use head instead of hard_start
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>
CC:     <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kuba@kernel.org>, <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <andriin@fb.com>, <jwi@linux.ibm.com>, <jianglidong3@jd.com>,
        <edumazet@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
References: <fb5ab568-9bc8-3145-a8db-3e975ccdf846@gmail.com>
 <20200331060641.79999-1-maowenan@huawei.com>
 <7a1d55ad-1427-67fe-f204-4d4a0ab2c4b1@gmail.com>
 <20200401181419.7acd2aa6@carbon>
From:   maowenan <maowenan@huawei.com>
Message-ID: <348d193e-cc68-3be4-ae39-dd73dbba635c@huawei.com>
Date:   Thu, 2 Apr 2020 09:23:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200401181419.7acd2aa6@carbon>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.223.60]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/4/2 0:15, Jesper Dangaard Brouer wrote:
> On Tue, 31 Mar 2020 15:16:22 +0900
> Toshiaki Makita <toshiaki.makita1@gmail.com> wrote:
> 
>> On 2020/03/31 15:06, Mao Wenan wrote:
>>> xdp.data_hard_start is equal to first address of
>>> struct xdp_frame, which is mentioned in
>>> convert_to_xdp_frame(). But the pointer hard_start
>>> in veth_xdp_rcv_one() is 32 bytes offset of frame,
>>> so it should use head instead of hard_start to
>>> set xdp.data_hard_start. Otherwise, if BPF program
>>> calls helper_function such as bpf_xdp_adjust_head, it
>>> will be confused for xdp_frame_end.  
>>
>> I think you should discuss this more with Jesper before
>> submitting v2.
>> He does not like this to be included now due to merge conflict risk.
>> Basically I agree with him that we don't need to hurry with this fix.
>>
>> Toshiaki Makita
>>
>>>
>>> Fixes: 9fc8d518d9d5 ("veth: Handle xdp_frames in xdp napi ring")
>>> Signed-off-by: Mao Wenan <maowenan@huawei.com>
>>> ---
>>>   v2: add fixes tag, as well as commit log.
>>>   drivers/net/veth.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
>>> index d4cbb9e8c63f..5ea550884bf8 100644
>>> --- a/drivers/net/veth.c
>>> +++ b/drivers/net/veth.c
>>> @@ -506,7 +506,7 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
>>>   		struct xdp_buff xdp;
>>>   		u32 act;
>>>   
>>> -		xdp.data_hard_start = hard_start;
>>> +		xdp.data_hard_start = head;
>>>   		xdp.data = frame->data;
>>>   		xdp.data_end = frame->data + frame->len;
>>>   		xdp.data_meta = frame->data - frame->metasize;
>>>   
> 
> Below is the patch that I have in my queue.  I've added a Reported-by
> tag to give you some credit, even-though I already had plans to fix
> this, as part of my XDP frame_sz work.
thanks for reported-by.
Actually the fault is found by reviewing veth code two weeks ago,
when I debugged another warning bpf_warn_invalid_xdp_action associated veth
module, and there is no chance to send such fix patch as quick.

> 
> 
> [PATCH RFC net-next] veth: adjust hard_start offset on redirect XDP frames
> 
> When native XDP redirect into a veth device, the frame arrives in the
> xdp_frame structure. It is then processed in veth_xdp_rcv_one(),
> which can run a new XDP bpf_prog on the packet. Doing so requires
> converting xdp_frame to xdp_buff, but the tricky part is that
> xdp_frame memory area is located in the top (data_hard_start) memory
> area that xdp_buff will point into.
> 
> The current code tried to protect the xdp_frame area, by assigning
> xdp_buff.data_hard_start past this memory. This results in 32 bytes
> less headroom to expand into via BPF-helper bpf_xdp_adjust_head().
> 
> This protect step is actually not needed, because BPF-helper
> bpf_xdp_adjust_head() already reserve this area, and don't allow
> BPF-prog to expand into it. Thus, it is safe to point data_hard_start
> directly at xdp_frame memory area.
> 
> Cc: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
> Fixes: 9fc8d518d9d5 ("veth: Handle xdp_frames in xdp napi ring")
> Reported-by: Mao Wenan <maowenan@huawei.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  drivers/net/veth.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 8cdc4415fa70..2edc04a8ab8e 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -493,13 +493,15 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
>  					struct veth_xdp_tx_bq *bq)
>  {
>  	void *hard_start = frame->data - frame->headroom;
> -	void *head = hard_start - sizeof(struct xdp_frame);
>  	int len = frame->len, delta = 0;
>  	struct xdp_frame orig_frame;
>  	struct bpf_prog *xdp_prog;
>  	unsigned int headroom;
>  	struct sk_buff *skb;
>  
> +	/* bpf_xdp_adjust_head() assures BPF cannot access xdp_frame area */
> +	hard_start -= sizeof(struct xdp_frame);
> +
>  	rcu_read_lock();
>  	xdp_prog = rcu_dereference(rq->xdp_prog);
>  	if (likely(xdp_prog)) {
> @@ -521,7 +523,6 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
>  			break;
>  		case XDP_TX:
>  			orig_frame = *frame;
> -			xdp.data_hard_start = head;
>  			xdp.rxq->mem = frame->mem;
>  			if (unlikely(veth_xdp_tx(rq->dev, &xdp, bq) < 0)) {
>  				trace_xdp_exception(rq->dev, xdp_prog, act);
> @@ -533,7 +534,6 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
>  			goto xdp_xmit;
>  		case XDP_REDIRECT:
>  			orig_frame = *frame;
> -			xdp.data_hard_start = head;
>  			xdp.rxq->mem = frame->mem;
>  			if (xdp_do_redirect(rq->dev, &xdp, xdp_prog)) {
>  				frame = &orig_frame;
> @@ -555,7 +555,7 @@ static struct sk_buff *veth_xdp_rcv_one(struct veth_rq *rq,
>  	rcu_read_unlock();
>  
>  	headroom = sizeof(struct xdp_frame) + frame->headroom - delta;
> -	skb = veth_build_skb(head, headroom, len, 0);
> +	skb = veth_build_skb(hard_start, headroom, len, 0);
>  	if (!skb) {
>  		xdp_return_frame(frame);
>  		goto err;
> 
> 


