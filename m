Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53F285D3F1
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfGBQLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:11:17 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:47644 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbfGBQLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 12:11:15 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190702161113euoutp0264a769c25c527dda14dc5474d1a9fbae~towGwtUN71363213632euoutp026
        for <netdev@vger.kernel.org>; Tue,  2 Jul 2019 16:11:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190702161113euoutp0264a769c25c527dda14dc5474d1a9fbae~towGwtUN71363213632euoutp026
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1562083873;
        bh=a8HGKzYKNXool+vEX2x7pJVwr8jr6vWsU+O/5m4+7Ow=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=ECjXj3mm2em7KBgbWRdgq5i0MErbX7DN/O+8mv8bv1nhFGjFRzZJWbS/t8ftL0CnC
         Q+aV3mqqUVP4vjKwV9+7CCs9+a380NsTSQ4tS6J6k+It3iceQxpOFs6wJjG/8gV3G0
         PX7hXt9WrLItNOAb3203lIO+sohfeGfM0jUa1Gz0=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190702161112eucas1p1b1f90c9d2c0ace564de4ebfb9020048d~towGEk8tN1274912749eucas1p1n;
        Tue,  2 Jul 2019 16:11:12 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 28.56.04325.0228B1D5; Tue,  2
        Jul 2019 17:11:12 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190702161111eucas1p2f78aa4e831708c23c5f1c2334c92d32d~towFR1fvx1600516005eucas1p2g;
        Tue,  2 Jul 2019 16:11:11 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190702161111eusmtrp2352c755cf3264a8cd427f8a2540ece28~towFDWSOg3001930019eusmtrp2-;
        Tue,  2 Jul 2019 16:11:11 +0000 (GMT)
X-AuditID: cbfec7f5-b8fff700000010e5-13-5d1b8220a1b0
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 48.0B.04140.F128B1D5; Tue,  2
        Jul 2019 17:11:11 +0100 (BST)
Received: from [106.109.129.180] (unknown [106.109.129.180]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190702161110eusmtip2b71998b3870557ff479c940a6d3d626a~towEQ-IZX0136501365eusmtip2Q;
        Tue,  2 Jul 2019 16:11:10 +0000 (GMT)
Subject: Re: [PATCH bpf] xdp: fix race on generic receive path
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, bpf <bpf@vger.kernel.org>,
        xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
From:   Ilya Maximets <i.maximets@samsung.com>
Message-ID: <e71ae4be-76f7-8328-0c06-e2fe5459317d@samsung.com>
Date:   Tue, 2 Jul 2019 19:11:09 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <CAJ8uoz34wS-Ut=TiULN32Zs-terBkzSiEws65jsd=f4S_rp43Q@mail.gmail.com>
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHe3d2OZOOnU1zjxfMll+y0iSJ80G8UB9WQlpQVCK69KDLa5ta
        JtgU8bJQwxJzeVmZecsLY2kOL7TEOw5v4S1SkMpCQ52VKCu3Y+S33/P+n+d9//+HF8eEkxwn
        XJaQTMsTpHFirg27rW/LeMotyznsdMWmA2XamuNROzmtiNro7edS1c9/YlS5MZtNTeZu8ai+
        r9lcSt9chlET+nIu9To7k0XVGQZ2BY0D1V7UjQIIia5+hiXpUH/kSao7l1kS1fQ4JtE25HMl
        pQ8XMUmhrgFJNrSuIfhNG98oOk6WSsu9/CJsYiq7sjhJPW738rVNSInGRSqE40D6wPALFxWy
        wYVkHYJ8o4HFFCYE8yVDiCk2EDwzvmGrEN86UdldyLWwkKxFsDJ1jGlaQ2CuGmBZBDvSD4YL
        xzgWtie9YKRhgWNpwshBDCaavmAWgUuehKHGXmRhYnegYH3Kes4m3UHb22wdPkxehwmdfq9H
        AINlS1YXfPIyGLcXrS4wUgRZpnoOw0egfaUcY5yu8aC90YPh8zA8UbSXwA6+9et4DLvAn44q
        FsMP4FP2sjUykHkISg3mPcEfdN9HeZaFYeRxaNF7MbsLhB9dFxm0hekVAePAForbSjHmmIC8
        HCFzhztsv6vdM+YEM6sbvEdIrN6XS70vi3pfFvX/ZzWI3YBEdIoiPppWnEmg73oqpPGKlIRo
        z8jEeC3a/WvD5v7Nt6h755YBkTgSHyQ0Ic5hQo40VZEWb0CAY2J7oqfOMUxIREnT7tPyxHB5
        ShytMCBnnC0WEekHFkKFZLQ0mY6l6SRa/k9l4XwnJSLaws1Bv/27Xjp3Bqh7l4ZMl1bOXjhX
        dC3WtTpzRDOpm62JyFCVTBWYVuVRgfqItRupd7aOFq3GvrqK58jYglaf9EP+gtBRfo3wxC/O
        WKRbsN8U/7Z3zZUMZRD1VDbruP5ZpYwK9iWftLxXhiTNE9RjuqtYZK6o3Z4L/YAP5orZihip
        twcmV0j/AlEcF5pnAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsVy+t/xe7ryTdKxBm+Wy1p8+Xmb3eJP2wZG
        i89HjrNZLF74jdlizvkWFosr7T/ZLY69aGGz2LVuJrPF5V1z2CzWtDQyWaw4dAIosUDMYnv/
        PkYHXo8tK28yeeycdZfdY/Gel0weXTcuMXtsWtXJ5jG9+yGzR9+WVYwenzfJBXBE6dkU5ZeW
        pCpk5BeX2CpFG1oY6RlaWugZmVjqGRqbx1oZmSrp29mkpOZklqUW6dsl6GXM29vEWrBfoaJz
        01rGBsZL4l2MnBwSAiYS8/b1sXUxcnEICSxllNjy6yczREJK4sevC6wQtrDEn2tdUEXvGSUu
        HJjPBJIQFrCTON13EaxIREBf4syqB6wgRcwCp5kl3v6eygrRcY1R4tzeeWwgVWwCOhKnVh9h
        BLF5gbp7P10FW8cioCKx6cg6sEmiAhESfW2z2SBqBCVOznzCAmJzCgRKnP/9ECzOLKAu8Wfe
        JWYIW1yi6ctKVghbXmL72znMExiFZiFpn4WkZRaSlllIWhYwsqxiFEktLc5Nzy020itOzC0u
        zUvXS87P3cQIjOhtx35u2cHY9S74EKMAB6MSD6+Hn3SsEGtiWXFl7iFGCQ5mJRHe/SskY4V4
        UxIrq1KL8uOLSnNSiw8xmgI9N5FZSjQ5H5hs8kriDU0NzS0sDc2NzY3NLJTEeTsEDsYICaQn
        lqRmp6YWpBbB9DFxcEo1MK6W+6O+K6IxxsivMWP2R99JuVu85zMZrLAT/LRyS25Rvf/1XJ0f
        vJmvKkRnG91P8LpndmOu7duQ3tes+lLHdp3+ZP61KIhvwgYL6XyWT2HPxUp8GK2dA84nrZ9x
        7Mi/b6btLE0HTX6xatav99k79cck744XpouEzaqtTl9PMYtz9tcp1d32VomlOCPRUIu5qDgR
        ALrt9ET+AgAA
X-CMS-MailID: 20190702161111eucas1p2f78aa4e831708c23c5f1c2334c92d32d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190702143639eucas1p2b168c68c35b70aac75cad6c72ccc81ad
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190702143639eucas1p2b168c68c35b70aac75cad6c72ccc81ad
References: <CGME20190702143639eucas1p2b168c68c35b70aac75cad6c72ccc81ad@eucas1p2.samsung.com>
        <20190702143634.19688-1-i.maximets@samsung.com>
        <CAJ8uoz34wS-Ut=TiULN32Zs-terBkzSiEws65jsd=f4S_rp43Q@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.07.2019 18:01, Magnus Karlsson wrote:
> On Tue, Jul 2, 2019 at 4:36 PM Ilya Maximets <i.maximets@samsung.com> wrote:
>>
>> Unlike driver mode, generic xdp receive could be triggered
>> by different threads on different CPU cores at the same time
>> leading to the fill and rx queue breakage. For example, this
>> could happen while sending packets from two processes to the
>> first interface of veth pair while the second part of it is
>> open with AF_XDP socket.
>>
>> Need to take a lock for each generic receive to avoid race.
> 
> Thanks for this catch Ilya. Do you have any performance numbers you
> could share of the impact of adding this spin lock? The reason I ask
> is that if the impact is negligible, then let us just add it. But if
> it is too large, we might want to brain storm about some other
> possible solutions.

Hi. Unfortunately, I don't have a hardware for performance tests right
now, so I could run only tests over virtual interfaces like veth pair.
It'll be good if someone could check the performance with real HW.

Best regards, Ilya Maximets.

> 
> Thanks: Magnus
> 
>> Fixes: c497176cb2e4 ("xsk: add Rx receive functions and poll support")
>> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
>> ---
>>  include/net/xdp_sock.h |  2 ++
>>  net/xdp/xsk.c          | 32 +++++++++++++++++++++++---------
>>  2 files changed, 25 insertions(+), 9 deletions(-)
>>
>> diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
>> index d074b6d60f8a..ac3c047d058c 100644
>> --- a/include/net/xdp_sock.h
>> +++ b/include/net/xdp_sock.h
>> @@ -67,6 +67,8 @@ struct xdp_sock {
>>          * in the SKB destructor callback.
>>          */
>>         spinlock_t tx_completion_lock;
>> +       /* Protects generic receive. */
>> +       spinlock_t rx_lock;
>>         u64 rx_dropped;
>>  };
>>
>> diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
>> index a14e8864e4fa..19f41d2b670c 100644
>> --- a/net/xdp/xsk.c
>> +++ b/net/xdp/xsk.c
>> @@ -119,17 +119,22 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
>>  {
>>         u32 metalen = xdp->data - xdp->data_meta;
>>         u32 len = xdp->data_end - xdp->data;
>> +       unsigned long flags;
>>         void *buffer;
>>         u64 addr;
>>         int err;
>>
>> -       if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index)
>> -               return -EINVAL;
>> +       spin_lock_irqsave(&xs->rx_lock, flags);
>> +
>> +       if (xs->dev != xdp->rxq->dev || xs->queue_id != xdp->rxq->queue_index) {
>> +               err = -EINVAL;
>> +               goto out_unlock;
>> +       }
>>
>>         if (!xskq_peek_addr(xs->umem->fq, &addr) ||
>>             len > xs->umem->chunk_size_nohr - XDP_PACKET_HEADROOM) {
>> -               xs->rx_dropped++;
>> -               return -ENOSPC;
>> +               err = -ENOSPC;
>> +               goto out_drop;
>>         }
>>
>>         addr += xs->umem->headroom;
>> @@ -138,13 +143,21 @@ int xsk_generic_rcv(struct xdp_sock *xs, struct xdp_buff *xdp)
>>         memcpy(buffer, xdp->data_meta, len + metalen);
>>         addr += metalen;
>>         err = xskq_produce_batch_desc(xs->rx, addr, len);
>> -       if (!err) {
>> -               xskq_discard_addr(xs->umem->fq);
>> -               xsk_flush(xs);
>> -               return 0;
>> -       }
>> +       if (err)
>> +               goto out_drop;
>> +
>> +       xskq_discard_addr(xs->umem->fq);
>> +       xskq_produce_flush_desc(xs->rx);
>>
>> +       spin_unlock_irqrestore(&xs->rx_lock, flags);
>> +
>> +       xs->sk.sk_data_ready(&xs->sk);
>> +       return 0;
>> +
>> +out_drop:
>>         xs->rx_dropped++;
>> +out_unlock:
>> +       spin_unlock_irqrestore(&xs->rx_lock, flags);
>>         return err;
>>  }
>>
>> @@ -765,6 +778,7 @@ static int xsk_create(struct net *net, struct socket *sock, int protocol,
>>
>>         xs = xdp_sk(sk);
>>         mutex_init(&xs->mutex);
>> +       spin_lock_init(&xs->rx_lock);
>>         spin_lock_init(&xs->tx_completion_lock);
>>
>>         mutex_lock(&net->xdp.lock);
>> --
>> 2.17.1
