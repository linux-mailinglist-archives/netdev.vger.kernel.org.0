Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33EF15E366
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 14:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfGCMDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 08:03:13 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39953 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfGCMDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 08:03:12 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190703120310euoutp02ddcc98c9cce675e2ce1dbb1ee2c8b9d6~t5Az8zZQR1782417824euoutp02V
        for <netdev@vger.kernel.org>; Wed,  3 Jul 2019 12:03:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190703120310euoutp02ddcc98c9cce675e2ce1dbb1ee2c8b9d6~t5Az8zZQR1782417824euoutp02V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1562155390;
        bh=g8Riy6JBS+t00x7n3nd88i1ZZjkYP71PaA1lf7IyZE0=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=Rtsa2R8hcZC2ZXWp67y92qkRZiNa/9JtfEfBYvpe0/Z2nhv8yMAvu2wNdMpfIqzA1
         q5MfxR6PXP590ZrlXKtJFq6aOIDeeZkadElOFdALzE5cOWHhLX+57Vk5vKChZKNSQ7
         AACUj4Z3dp15ppP6BCO7GUEnrHPzknya2GdP4h9M=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190703120309eucas1p169076bd06a70cadfa0f188d0a79b7ae0~t5AzSj98D2486124861eucas1p1w;
        Wed,  3 Jul 2019 12:03:09 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id DC.95.04377.D799C1D5; Wed,  3
        Jul 2019 13:03:09 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190703120308eucas1p1e9619a56372825de84067a786f13a91b~t5AyirDjM2545525455eucas1p1v;
        Wed,  3 Jul 2019 12:03:08 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190703120308eusmtrp1fd1c76b35df1bd02aae85c768adaefd9~t5AyUgexL0302803028eusmtrp1K;
        Wed,  3 Jul 2019 12:03:08 +0000 (GMT)
X-AuditID: cbfec7f4-12dff70000001119-d8-5d1c997d9a0f
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 03.A6.04140.C799C1D5; Wed,  3
        Jul 2019 13:03:08 +0100 (BST)
Received: from [106.109.129.180] (unknown [106.109.129.180]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190703120307eusmtip2181ec3e2a1c80f7d9b9abb0678a7db22~t5AxqCEQV1327713277eusmtip27;
        Wed,  3 Jul 2019 12:03:07 +0000 (GMT)
Subject: Re: [PATCH bpf] xdp: fix race on generic receive path
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
From:   Ilya Maximets <i.maximets@samsung.com>
Message-ID: <687d9498-87a9-11e5-dc53-f09f42d6371b@samsung.com>
Date:   Wed, 3 Jul 2019 15:03:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190702174014.005a3166@cakuba.netronome.com>
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIKsWRmVeSWpSXmKPExsWy7djP87q1M2ViDeYt4LP48vM2u8Wftg2M
        Fp+PHGezWLzwG7PFnPMtLBZX2n+yWxx70cJmsWvdTGaLy7vmsFmsOHQCKLZAzGJ7/z5GBx6P
        LStvMnnsnHWX3WPxnpdMHl03LjF7bFrVyeYxvfshs0ffllWMHp83yQVwRHHZpKTmZJalFunb
        JXBlHD7+kb3gFG/F8rtf2BsYb3N1MXJySAiYSDx89JCli5GLQ0hgBaPEsqdNUM4XRomNd64x
        QjifGSW+b2hhhmn5tH0zG0RiOaPEsZ0rWSGcj4wSG26sZQKpEhawkzjdd5EVxBYRMJT4dWMK
        mM0s8IdJ4uJrUxCbTUBH4tTqI4wgNi9Q/dIN91lAbBYBFYmXzw6yg9iiAhESl7fsgqoRlDg5
        8wlYDaeAtcTpKxAXMQuISzR9WQk1X15i+9s5zCAHSQi8ZZe496GVDeJsF4mHXRuYIGxhiVfH
        t7BD2DISpyf3sEDY9RL3W14yQjR3MEpMP/QPqsFeYsvrc0ANHEAbNCXW79IHMSUEHCXe7/WC
        MPkkbrwVhDiBT2LStunMEGFeiY42IYgZKhK/Dy6HhqGUxM13n9knMCrNQvLYLCTPzELyzCyE
        tQsYWVYxiqeWFuempxYb5aWW6xUn5haX5qXrJefnbmIEJrTT/45/2cG460/SIUYBDkYlHt4F
        AdKxQqyJZcWVuYcYJTiYlUR496+QjBXiTUmsrEotyo8vKs1JLT7EKM3BoiTOW83wIFpIID2x
        JDU7NbUgtQgmy8TBKdXAGKejp3Du8rs9TqWlj0S19otc2pqrICkqP2fBJXN++3/5Vsf4t0kX
        t6btW+b1+pvKG6eF+d5B1k7zfzRWMnwTt5ve+Xijpdy5xJim3ocT5pm/urzTp2Hiqg+M03Xm
        9JSWHpmgWTdFOFSl6p+jl/u9pCexJzurXrBftGm9nLK+fnvf+rBL+3z3K7EUZyQaajEXFScC
        ADJUi7JkAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t/xe7o1M2ViDS5tkrL48vM2u8Wftg2M
        Fp+PHGezWLzwG7PFnPMtLBZX2n+yWxx70cJmsWvdTGaLy7vmsFmsOHQCKLZAzGJ7/z5GBx6P
        LStvMnnsnHWX3WPxnpdMHl03LjF7bFrVyeYxvfshs0ffllWMHp83yQVwROnZFOWXlqQqZOQX
        l9gqRRtaGOkZWlroGZlY6hkam8daGZkq6dvZpKTmZJalFunbJehlHD7+kb3gFG/F8rtf2BsY
        b3N1MXJySAiYSHzavpmti5GLQ0hgKaPE0eu3mCESUhI/fl1ghbCFJf5c62IDsYUE3jNKvGr0
        ALGFBewkTvddBKsRETCU+HVjCivIIGaBP0wSf5adYISYeoBR4uSWp2BVbAI6EqdWH2EEsXmB
        upduuM8CYrMIqEi8fHaQHcQWFYiQ6GubzQZRIyhxcuYTsBpOAWuJ01dawK5jFlCX+DPvEpQt
        LtH0ZSUrhC0vsf3tHOYJjEKzkLTPQtIyC0nLLCQtCxhZVjGKpJYW56bnFhvpFSfmFpfmpesl
        5+duYgRG8bZjP7fsYOx6F3yIUYCDUYmH18NPOlaINbGsuDL3EKMEB7OSCO/+FZKxQrwpiZVV
        qUX58UWlOanFhxhNgZ6byCwlmpwPTDB5JfGGpobmFpaG5sbmxmYWSuK8HQIHY4QE0hNLUrNT
        UwtSi2D6mDg4pRoYDzfyrPrc/+a5r87M48yOItFOsy32zDd62v7QSsB87aYZr5++W6+e+K6w
        IC3eYMYH5viAo1cfXe0JMl/fblZTd3l26BXDwsTn2lt7rJ5pHmoXYXJqOPe0ziZ97fN2732n
        H7090Dz37H6PC9YVa2YtmuA+59ZK12kRG7v2n9r95ZjGIyf1qTKXjJRYijMSDbWYi4oTAQ/L
        3Hn4AgAA
X-CMS-MailID: 20190703120308eucas1p1e9619a56372825de84067a786f13a91b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190702143639eucas1p2b168c68c35b70aac75cad6c72ccc81ad
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190702143639eucas1p2b168c68c35b70aac75cad6c72ccc81ad
References: <CGME20190702143639eucas1p2b168c68c35b70aac75cad6c72ccc81ad@eucas1p2.samsung.com>
        <20190702143634.19688-1-i.maximets@samsung.com>
        <20190702174014.005a3166@cakuba.netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.07.2019 3:40, Jakub Kicinski wrote:
> On Tue,  2 Jul 2019 17:36:34 +0300, Ilya Maximets wrote:
>> Unlike driver mode, generic xdp receive could be triggered
>> by different threads on different CPU cores at the same time
>> leading to the fill and rx queue breakage. For example, this
>> could happen while sending packets from two processes to the
>> first interface of veth pair while the second part of it is
>> open with AF_XDP socket.
>>
>> Need to take a lock for each generic receive to avoid race.
>>
>> Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
>> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
> 
>> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
>> index a14e8864e4fa..19f41d2b670c 100644
>> --- a/net/xdp/xsk.c
>> +++ b/net/xdp/xsk.c
>> @@ -119,17 +119,22 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
>>  {
>>  	u32 metalen = xdp->data - xdp->data_meta;
>>  	u32 len = xdp->data_end - xdp->data;
>> +	unsigned long flags;
>>  	void *buffer;
>>  	u64 addr;
>>  	int err;
>>  
>> -	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index)
>> -		return -EINVAL;
>> +	spin_lock_irqsave(&xs->rx_lock, flags);
> 
> Why _irqsave, rather than _bh?

Yes, spin_lock_bh() is enough here. Will change in v2.
Thanks.

> 
>> +	if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index) {
>> +		err = -EINVAL;
>> +		goto out_unlock;
>> +	}
>>  
>>  	if (!xskq_peek_addr(xs->umem->fq, &addr) ||
>>  	    len > xs->umem->chunk_size_nohr - XDP_PACKET_HEADROOM) {
>> -		xs->rx_dropped++;
>> -		return -ENOSPC;
>> +		err = -ENOSPC;
>> +		goto out_drop;
>>  	}
>>  
>>  	addr += xs->umem->headroom;
> 
> 
> 
