Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20DC0965BD
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 17:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730384AbfHTP65 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 11:58:57 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40809 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728185AbfHTP65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 11:58:57 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190820155854euoutp02476249c7e33c4d0790badc274c6e2563~8rMWCCe-22130621306euoutp02E
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 15:58:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190820155854euoutp02476249c7e33c4d0790badc274c6e2563~8rMWCCe-22130621306euoutp02E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1566316734;
        bh=CbFw1FYPmKuFIfs+3P3Nw8J6PHgPzssp3xnaRpsQ7MI=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=LYMjJpIzm9Z1fs+NwQdRef+xyGZ1+fd26UqW06urb2Q/ap/gEFKh4xop8ZcEau2WE
         4X+qzIhWyccgPn6nyWHboj9Jkc8c+nIEsltXjs37bnnBRaxbVwym0WBX040pGvAiGn
         ObyE9zvJGzsjUfg7MzY2eToD7QFnqfAXPAKONlmg=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190820155853eucas1p1b905da453fbe240d665f5667cded4d01~8rMVQsvAb1333413334eucas1p1S;
        Tue, 20 Aug 2019 15:58:53 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id AB.91.04469.DB81C5D5; Tue, 20
        Aug 2019 16:58:53 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190820155852eucas1p158daac4dbb237d4951170a01a8525a4d~8rMUT7w0G0915909159eucas1p1Q;
        Tue, 20 Aug 2019 15:58:52 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190820155852eusmtrp1a9efcc498a537ff104906aee9fb3e9d1~8rMUE3aLs0042900429eusmtrp1o;
        Tue, 20 Aug 2019 15:58:52 +0000 (GMT)
X-AuditID: cbfec7f2-569ff70000001175-00-5d5c18bd9552
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 16.36.04166.CB81C5D5; Tue, 20
        Aug 2019 16:58:52 +0100 (BST)
Received: from [106.109.129.180] (unknown [106.109.129.180]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190820155851eusmtip2ed5dc7bf8c7b3b303dc0f77c32003712~8rMTOSQpv2445024450eusmtip2i;
        Tue, 20 Aug 2019 15:58:51 +0000 (GMT)
Subject: Re: [PATCH net] ixgbe: fix double clean of tx descriptors with xdp
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        William Tu <u9012063@gmail.com>
From:   Ilya Maximets <i.maximets@samsung.com>
Message-ID: <625791af-c656-1e42-b60e-b3a5cedcb4c4@samsung.com>
Date:   Tue, 20 Aug 2019 18:58:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0Udn0D0_f=SOH2wpBRWV_u4rb1Qe2h7gguXnRNzJ_VkRzg@mail.gmail.com>
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa1BMYRjHvXsue1ptvW3RMzEaO9pxLRlmzgfCZMwxZlxmDE1aLE4XtdXs
        adPyQZNuksblw2ZnS0amizEqSZJiZTfWWArdmEIuaULXkYw4HUbffs/t/zz/d16GUH2g/JiY
        +CTeEK+LU9MKssY+7lp2ByK0yy/f0LCTBV0kOzLeJWd/ZlYgdrjJQbOXLo4RrNWVTrKvno/T
        7POscTk72TlBsfZP6TTbfL0bsa11VpottTXLWXvRbLatxX2dJ1dd1iHjblley7lL9X0yLqe9
        heCqyk/Q3MPjRs588g3BfW14QXN51eWIG66at00Rrlh9kI+LSeYNQSH7FNH26z+oxKIlKV0F
        qWQqej8/B7kxgFfCxOQ3ucgqXIrgSVFYDlL84REEX785SSkYRnDP/AzlIGZqonFALeVLEOR3
        nqekYBBBf8MFSmzyxpvhwQNCVPXBQeCszJ0SInAhCfm532VigcZL4dGVJiSyEofACev9qQES
        B0C9uZEWeRYOg6Ge+5TU4wUPz/eSIrvh7ZDuzJ1iAvtC2kgZJbE/3BywEuIywGcY6G0tkUs+
        N0B3xVNKYm/47Kj+m58LznOSEOBj0J3eh6ThbARm2y+ZVFgL1f1P5KIzAi+Ca3VB0kush9GM
        RRJ6QPuAl3SCB5ytMRNSWgnZmSpJYwFM3CshJPaDji/D8tNIbZlmzDLNjGWaGcv/tUWILEe+
        vFHQR/FCcDx/OFDQ6QVjfFTggQR9Ffrz+5y/HEO1aLRlvw1hBqndlbUdu7UqSpcsmPQ2BAyh
        9lGmWMO1KuVBnekIb0jYazDG8YINzWFIta/y6Iye3SocpUviY3k+kTf8q8oYN79UZIxMW/em
        kbxd6rapPCt5ZVrFxjVUqHPXwItD2iZod9qN+fqQd3Thju6beZULGUdgsV075rXlbWizZ32C
        xhb9cufWMM+2fD764+iSx7FDK1Yd1+/xGLy6Nm9E8dS/WNAUJ6UG1BIzm9gCy467Gletyd8U
        6d+bcarNHtHn8kGekWpSiNYFLyYMgu43v9rZZ3kDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t/xe7p7JGJiDZY9U7L4P/c2i8WXn7fZ
        Lf60bWC0+HzkOJvF4oXfmC3mnG9hsbhz5SebxZX2n+wW/2/9ZrU49qKFzeLE5vuMFpd3zWGz
        WHHoBLvFsQViFtcv8Tjwe2xZeZPJY+esu+wei/e8ZPLounGJ2WPTqk42j5PNpR7Tux8ye7zf
        d5XNo2/LKkaPz5vkArii9GyK8ktLUhUy8otLbJWiDS2M9AwtLfSMTCz1DI3NY62MTJX07WxS
        UnMyy1KL9O0S9DKObf7FWrBAu+L23AaWBsanil2MHBwSAiYS+98qdTFycQgJLGWU2L53ImMX
        IydQXErix68LrBC2sMSfa11sEEXvGSXudixmBWkWFvCWOHqUGaRGREBf4vTGHhaQGmaBBSwS
        bQ86mCEarjFKdDReBJvKJqAjcWr1ETCbV8BOonPOYbBuFgFViT3T97OB2KICERKHd8yCqhGU
        ODnzCQuIzSkQKNFyugfMZhZQl/gz7xIzhC0u0fRlJSuELS+x/e0c5gmMQrOQtM9C0jILScss
        JC0LGFlWMYqklhbnpucWG+oVJ+YWl+al6yXn525iBEb8tmM/N+9gvLQx+BCjAAejEg/vjpvR
        sUKsiWXFlbmHGCU4mJVEeCvmRMUK8aYkVlalFuXHF5XmpBYfYjQFem4is5Rocj4wGeWVxBua
        GppbWBqaG5sbm1koifN2CByMERJITyxJzU5NLUgtgulj4uCUamBUTr/LzbhUSOj5saA6t+lx
        fCttNN6wFytznZu6gk3793Hz/dP+JX0vYFzTZLh1X0ptdfbfhoOO9dldMv5LV2049lNjyxn1
        lfY6i2PFC1Z/s1nWnq+vGmOwi49RT3xyeqdRtXhh7fP0WTzSU3fKbzr2wvrqwreBPOELFN8G
        3QrYLvHn6t2rF7qUWIozEg21mIuKEwGKFk5dDgMAAA==
X-CMS-MailID: 20190820155852eucas1p158daac4dbb237d4951170a01a8525a4d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190820151644eucas1p179d6d1da42bb6be0aad8f58ac46624ce
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190820151644eucas1p179d6d1da42bb6be0aad8f58ac46624ce
References: <CGME20190820151644eucas1p179d6d1da42bb6be0aad8f58ac46624ce@eucas1p1.samsung.com>
        <20190820151611.10727-1-i.maximets@samsung.com>
        <CAKgT0Udn0D0_f=SOH2wpBRWV_u4rb1Qe2h7gguXnRNzJ_VkRzg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.08.2019 18:35, Alexander Duyck wrote:
> On Tue, Aug 20, 2019 at 8:18 AM Ilya Maximets <i.maximets@samsung.com> wrote:
>>
>> Tx code doesn't clear the descriptor status after cleaning.
>> So, if the budget is larger than number of used elems in a ring, some
>> descriptors will be accounted twice and xsk_umem_complete_tx will move
>> prod_tail far beyond the prod_head breaking the comletion queue ring.
>>
>> Fix that by limiting the number of descriptors to clean by the number
>> of used descriptors in the tx ring.
>>
>> Fixes: 8221c5eba8c1 ("ixgbe: add AF_XDP zero-copy Tx support")
>> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
> 
> I'm not sure this is the best way to go. My preference would be to
> have something in the ring that would prevent us from racing which I
> don't think this really addresses. I am pretty sure this code is safe
> on x86 but I would be worried about weak ordered systems such as
> PowerPC.
> 
> It might make sense to look at adding the eop_desc logic like we have
> in the regular path with a proper barrier before we write it and after
> we read it. So for example we could hold of on writing the bytecount
> value until the end of an iteration and call smp_wmb before we write
> it. Then on the cleanup we could read it and if it is non-zero we take
> an smp_rmb before proceeding further to process the Tx descriptor and
> clearing the value. Otherwise this code is going to just keep popping
> up with issues.

But, unlike regular case, xdp zero-copy xmit and clean for particular
tx ring always happens in the same NAPI context and even on the same
CPU core.

I saw the 'eop_desc' manipulations in regular case and yes, we could
use 'next_to_watch' field just as a flag of descriptor existence,
but it seems unnecessarily complicated. Am I missing something?

> 
>> ---
>>
>> Not tested yet because of lack of available hardware.
>> So, testing is very welcome.
>>
>>  drivers/net/ethernet/intel/ixgbe/ixgbe.h      | 10 ++++++++++
>>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 12 +-----------
>>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  |  6 ++++--
>>  3 files changed, 15 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
>> index 39e73ad60352..0befcef46e80 100644
>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
>> @@ -512,6 +512,16 @@ static inline u16 ixgbe_desc_unused(struct ixgbe_ring *ring)
>>         return ((ntc > ntu) ? 0 : ring->count) + ntc - ntu - 1;
>>  }
>>
>> +static inline u64 ixgbe_desc_used(struct ixgbe_ring *ring)
>> +{
>> +       unsigned int head, tail;
>> +
>> +       head = ring->next_to_clean;
>> +       tail = ring->next_to_use;
>> +
>> +       return ((head <= tail) ? tail : tail + ring->count) - head;
>> +}
>> +
>>  #define IXGBE_RX_DESC(R, i)        \
>>         (&(((union ixgbe_adv_rx_desc *)((R)->desc))[i]))
>>  #define IXGBE_TX_DESC(R, i)        \
>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
>> index 7882148abb43..d417237857d8 100644
>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
>> @@ -1012,21 +1012,11 @@ static u64 ixgbe_get_tx_completed(struct ixgbe_ring *ring)
>>         return ring->stats.packets;
>>  }
>>
>> -static u64 ixgbe_get_tx_pending(struct ixgbe_ring *ring)
>> -{
>> -       unsigned int head, tail;
>> -
>> -       head = ring->next_to_clean;
>> -       tail = ring->next_to_use;
>> -
>> -       return ((head <= tail) ? tail : tail + ring->count) - head;
>> -}
>> -
>>  static inline bool ixgbe_check_tx_hang(struct ixgbe_ring *tx_ring)
>>  {
>>         u32 tx_done = ixgbe_get_tx_completed(tx_ring);
>>         u32 tx_done_old = tx_ring->tx_stats.tx_done_old;
>> -       u32 tx_pending = ixgbe_get_tx_pending(tx_ring);
>> +       u32 tx_pending = ixgbe_desc_used(tx_ring);
>>
>>         clear_check_for_tx_hang(tx_ring);
>>
>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>> index 6b609553329f..7702efed356a 100644
>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>> @@ -637,6 +637,7 @@ bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
>>         u32 i = tx_ring->next_to_clean, xsk_frames = 0;
>>         unsigned int budget = q_vector->tx.work_limit;
>>         struct xdp_umem *umem = tx_ring->xsk_umem;
>> +       u32 used_descs = ixgbe_desc_used(tx_ring);
>>         union ixgbe_adv_tx_desc *tx_desc;
>>         struct ixgbe_tx_buffer *tx_bi;
>>         bool xmit_done;
>> @@ -645,7 +646,7 @@ bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
>>         tx_desc = IXGBE_TX_DESC(tx_ring, i);
>>         i -= tx_ring->count;
>>
>> -       do {
>> +       while (likely(budget && used_descs)) {
>>                 if (!(tx_desc->wb.status & cpu_to_le32(IXGBE_TXD_STAT_DD)))
>>                         break;
>>
>> @@ -673,7 +674,8 @@ bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
>>
>>                 /* update budget accounting */
>>                 budget--;
>> -       } while (likely(budget));
>> +               used_descs--;
>> +       }
>>
>>         i += tx_ring->count;
>>         tx_ring->next_to_clean = i;
>> --
>> 2.17.1
>>
> 
> 
