Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8C6999AE
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 18:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387489AbfHVQ6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 12:58:45 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44515 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731320AbfHVQ6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 12:58:45 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190822165843euoutp0245fc72925f49bd3262ebfa47f94a3104~9TTIb-Y4R1561915619euoutp02P
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 16:58:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190822165843euoutp0245fc72925f49bd3262ebfa47f94a3104~9TTIb-Y4R1561915619euoutp02P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1566493123;
        bh=DWPKQlMQ+jod8joLVtkfrQK2+7Pe98yfIoE7LabdUfw=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=CeVs58/cmMXWvRda8I9axaJr69KjKBnYLxLt37Qv7Wv4q0MXVFrev4JuQ2b9XfDHQ
         Uj7AKLcKtLiJeCSmsbOYs5amuFPy0EZjz7XNiG7Tu8vCZ7eNqBjlBgSx5DcpMcPIpo
         7ezaPYywHrUzBEziJ0La8CabMNdjD+Q3o/xMK5xc=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190822165841eucas1p18126854da97c39f2a0fb6396e752b460~9TTHcjYbs2955929559eucas1p1R;
        Thu, 22 Aug 2019 16:58:41 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id E0.16.04374.1C9CE5D5; Thu, 22
        Aug 2019 17:58:41 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190822165840eucas1p254f3d07b75967a06651083ff270df922~9TTGaVhgQ2366923669eucas1p21;
        Thu, 22 Aug 2019 16:58:40 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190822165840eusmtrp16ac4849f6016c6e144f5720048783ca6~9TTGKT7LF0979109791eusmtrp12;
        Thu, 22 Aug 2019 16:58:40 +0000 (GMT)
X-AuditID: cbfec7f5-4ddff70000001116-7d-5d5ec9c16b69
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id F2.98.04117.0C9CE5D5; Thu, 22
        Aug 2019 17:58:40 +0100 (BST)
Received: from [106.109.129.180] (unknown [106.109.129.180]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190822165839eusmtip2a1b3ad3fffae3823ff4dacc29e1c2c20~9TTFPfojm1207312073eusmtip2M;
        Thu, 22 Aug 2019 16:58:39 +0000 (GMT)
Subject: Re: [PATCH net v2] ixgbe: fix double clean of tx descriptors with
 xdp
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
Message-ID: <7e9e426c-92eb-ebf8-2447-6c804a0c7135@samsung.com>
Date:   Thu, 22 Aug 2019 19:58:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0Uf26P53EA4m503aehq3tWCX9b3C+17TW2Ursbue9Kp=_w@mail.gmail.com>
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTcRTH++3e3V2Hs5/T8mQvWBlopUYRNxAriLgQgv0TpfmYdTPTWeym
        vYhEV+o0H0Vpy9LQfBLpFEszoWl7ZCiZYvZAg8JH2UPXY222nFfJ/77nc76H7zlwaEI+Jval
        E5JPcupkZZKCkpLNRlvPxieW6Kjg0sw1jPPWG5Kx2t5IGMelesRMdZoopvzOT4Ip6dGQzNs+
        G8X0ZdokjPO1XcwYRzUUY24cQszL1hKKqTaYJYyxbCkz0Ou+YzHbVDMoYlt07yRseduYiNW+
        6iVYfW02xVoyUtiinPcE+7W9n2LzmmoRO6VfFS6NkIYc5pISUjl1UGis9Ohd20XRidGA0/mW
        CjINaVZrkRsNeAvYHW1Ii6S0HFcjGMyrkAiFFYEz20m4XHI8haCgdeX8hLEjnRJMVQi6v9nn
        iu8IKidaSJfLC4dD4eRL5NLeOAi6GnJJl4nAt0kozv0tcjUovAGe1XXOmmQ4FB5+HJnlJPaD
        Py/0lEsvwfthcrhDLHg8wXLjw2yAG94L1uuPZjmBfSDdWjOnV8ODiRLCFQY4m4ZflfkSYe9d
        8NjaKxa0F4ybmub4Cui6mksK+gIMacaQMJyFoMjwVyQ0tkPTp+6ZAXomwR/utwYJeCfkGEdI
        FwbsAa8mPIUdPOBKcxEhYBlkXZIL7rVgf1JFCNoXBr9MSQqQQrfgMt2Ca3QLrtH9zy1DZC3y
        4VJ4VTzHb07mTgXyShWfkhwfeOi4So9mHrDrr+nHQ9TuiDMgTCOFu8ysjY6Si5Wp/BmVAQFN
        KLxlqYUzSHZYeeYspz4eo05J4ngDWk6TCh/ZuUXDkXIcrzzJJXLcCU493xXRbr5piA0LThx2
        CzNtxmp7bMx03FYi9V5kf2zmSKOXozQtQnN2omCZqdgW7NfnEVA6DT3rnh/I2JfYoKiPXr+t
        7tRBbyZjUcJ4efA7Z2KsMiY9bfekf5yjwKwavVbNtfTvCRn8vLi5M+j7gIXfcLnjmH3oyFOt
        7vPX4Zta9cD5/GdifYaC5I8qNwUQal75D7HGVxZ8AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t/xe7oHTsbFGuw7K23xf+5tFosvP2+z
        W/xp28Bo8fnIcTaLxQu/MVvMOd/CYnHnyk82iyvtP9kt/t/6zWpx7EULm8WJzfcZLS7vmsNm
        seLQCXaLYwvELK5f4nHg99iy8iaTx85Zd9k9Fu95yeTRdeMSs8emVZ1sHiebSz2mdz9k9ni/
        7yqbR9+WVYwenzfJBXBF6dkU5ZeWpCpk5BeX2CpFG1oY6RlaWugZmVjqGRqbx1oZmSrp29mk
        pOZklqUW6dsl6GUs/dnKVPBCq6L/5BKWBsYW+S5GTg4JAROJY4eb2LoYuTiEBJYySjw9vYEJ
        IiEl8ePXBVYIW1jiz7UuqKL3jBLNW9eCJYQF/CR+Tl0O1iAioC9xemMPC0gRs8ACFom2Bx3M
        EB3XGCVmPFzOBlLFJqAjcWr1EUYQm1fATmLH0+dg3SwCqhK/Lm4CqxEViJA4vGMWVI2gxMmZ
        T1hAbE6BQIkv03aDbWYWUJf4M+8SM4QtLtH0ZSVUXF5i+9s5zBMYhWYhaZ+FpGUWkpZZSFoW
        MLKsYhRJLS3OTc8tNtIrTswtLs1L10vOz93ECIz6bcd+btnB2PUu+BCjAAejEg/via64WCHW
        xLLiytxDjBIczEoivGUTgUK8KYmVValF+fFFpTmpxYcYTYGem8gsJZqcD0xIeSXxhqaG5haW
        hubG5sZmFkrivB0CB2OEBNITS1KzU1MLUotg+pg4OKUaGHvXBytJHbxx+qgtq5fsRtY/GpmM
        Cww0FXS/bz14PmORP4NlfbeCWFnBi6f6/1ZZptf4PVEpuPr41JGqmVai124xhbKvdeU5c/bM
        1U2nIro10uOClHlU+HR79hkeUWp9XeYQ/3vj+ynaeWcuLOo7et/p+2LfY6+2GB8V6T00rTa8
        RNdtmYfbLCWW4oxEQy3mouJEAC8+QPMQAwAA
X-CMS-MailID: 20190822165840eucas1p254f3d07b75967a06651083ff270df922
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190822123045eucas1p125b6e106f0310bdb50e759ef41993a91
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190822123045eucas1p125b6e106f0310bdb50e759ef41993a91
References: <CGME20190822123045eucas1p125b6e106f0310bdb50e759ef41993a91@eucas1p1.samsung.com>
        <20190822123037.28068-1-i.maximets@samsung.com>
        <CAKgT0Uf26P53EA4m503aehq3tWCX9b3C+17TW2Ursbue9Kp=_w@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.08.2019 19:38, Alexander Duyck wrote:
> On Thu, Aug 22, 2019 at 5:30 AM Ilya Maximets <i.maximets@samsung.com> wrote:
>>
>> Tx code doesn't clear the descriptors' status after cleaning.
>> So, if the budget is larger than number of used elems in a ring, some
>> descriptors will be accounted twice and xsk_umem_complete_tx will move
>> prod_tail far beyond the prod_head breaking the comletion queue ring.
>>
>> Fix that by limiting the number of descriptors to clean by the number
>> of used descriptors in the tx ring.
>>
>> 'ixgbe_clean_xdp_tx_irq()' function refactored to look more like
>> 'ixgbe_xsk_clean_tx_ring()' since we don't need most of the
>> complications implemented in the regular 'ixgbe_clean_tx_irq()'
>> and we're allowed to directly use 'next_to_clean' and 'next_to_use'
>> indexes.
>>
>> Fixes: 8221c5eba8c1 ("ixgbe: add AF_XDP zero-copy Tx support")
>> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
>> ---
>>
>> Version 2:
>>   * 'ixgbe_clean_xdp_tx_irq()' refactored to look more like
>>     'ixgbe_xsk_clean_tx_ring()'.
>>
>>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 34 ++++++++------------
>>  1 file changed, 13 insertions(+), 21 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>> index 6b609553329f..d1297660e14a 100644
>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
>> @@ -633,22 +633,23 @@ static void ixgbe_clean_xdp_tx_buffer(struct ixgbe_ring *tx_ring,
>>  bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
>>                             struct ixgbe_ring *tx_ring, int napi_budget)
>>  {
>> +       u16 ntc = tx_ring->next_to_clean, ntu = tx_ring->next_to_use;
>>         unsigned int total_packets = 0, total_bytes = 0;
>> -       u32 i = tx_ring->next_to_clean, xsk_frames = 0;
>>         unsigned int budget = q_vector->tx.work_limit;
>>         struct xdp_umem *umem = tx_ring->xsk_umem;
>> -       union ixgbe_adv_tx_desc *tx_desc;
>> -       struct ixgbe_tx_buffer *tx_bi;
>> +       u32 xsk_frames = 0;
>>         bool xmit_done;
>>
>> -       tx_bi = &tx_ring->tx_buffer_info[i];
>> -       tx_desc = IXGBE_TX_DESC(tx_ring, i);
>> -       i -= tx_ring->count;
>> +       while (likely(ntc != ntu && budget)) {
> 
> I would say you can get rid of budget entirely. It was only really
> needed for the regular Tx case where you can have multiple CPUs
> feeding a single Tx queue and causing a stall. Since we have a 1:1
> mapping we should never have more than the Rx budget worth of packets
> to really process. In addition we can only make one pass through the
> ring since the ntu value is not updated while running the loop.

OK. Will remove.

> 
>> +               union ixgbe_adv_tx_desc *tx_desc;
>> +               struct ixgbe_tx_buffer *tx_bi;
>> +
>> +               tx_desc = IXGBE_TX_DESC(tx_ring, ntc);
>>
>> -       do {
>>                 if (!(tx_desc->wb.status & cpu_to_le32(IXGBE_TXD_STAT_DD)))
>>                         break;
>>
>> +               tx_bi = &tx_ring->tx_buffer_info[ntc];
> 
> Please don't move this logic into the loop. We were intentionally
> processing this outside of the loop once and then just doing the
> increments because it is faster that way. It takes several operations
> to compute tx_bi based on ntc, whereas just incrementing is a single
> operation.

OK.

> 
>>                 total_bytes += tx_bi->bytecount;
>>                 total_packets += tx_bi->gso_segs;
>>
>> @@ -659,24 +660,15 @@ bool ixgbe_clean_xdp_tx_irq(struct ixgbe_q_vector *q_vector,
>>
>>                 tx_bi->xdpf = NULL;
>>
>> -               tx_bi++;
>> -               tx_desc++;
>> -               i++;
>> -               if (unlikely(!i)) {
>> -                       i -= tx_ring->count;
> 
> So these two lines can probably just be replaced by:
> if (unlikely(ntc == tx_ring->count)) {
>         ntc = 0;

Sure.

> 
>> -                       tx_bi = tx_ring->tx_buffer_info;
>> -                       tx_desc = IXGBE_TX_DESC(tx_ring, 0);
>> -               }
>> -
>> -               /* issue prefetch for next Tx descriptor */
>> -               prefetch(tx_desc);
> 
> Did you just drop the prefetch?

I'll keep the prefetch in v3 because, as you fairly mentioned, it's not
related to this patch. However, I'm not sure if this prefetch makes any
sense here, because there is only one comparison operation between the
prefetch and the data usage:

 while (ntc != ntu) {
     if (!(tx_desc->wb.status ...
     <...>
     prefetch(tx_desc);
 }


> You are changing way too much with
> this patch. All you should need to do is replace i with ntc, replace
> the "do {" with "while (ntc != ntu) {", and remove the while at the
> end.
> 
>> +               ntc++;
>> +               if (unlikely(ntc == tx_ring->count))
>> +                       ntc = 0;
>>
>>                 /* update budget accounting */
>>                 budget--;
>> -       } while (likely(budget));
> 
> As I stated earlier, budget can be removed entirely.

Sure.

> 
>> +       }
>>
>> -       i += tx_ring->count;
>> -       tx_ring->next_to_clean = i;
>> +       tx_ring->next_to_clean = ntc;
>>
>>         u64_stats_update_begin(&tx_ring->syncp);
>>         tx_ring->stats.bytes += total_bytes;
>> --
>> 2.17.1
