Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B44E698D64
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 10:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732205AbfHVIRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 04:17:24 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39865 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732193AbfHVIRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 04:17:23 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190822081721euoutp02970e40a405ef2d0c1517113932d524be~9ML7YsbM92118321183euoutp02B
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 08:17:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190822081721euoutp02970e40a405ef2d0c1517113932d524be~9ML7YsbM92118321183euoutp02B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1566461841;
        bh=eH3VAAcLRYwEU2jjSTk2TX56nvxFUZ0pGc8FxPpOx10=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=CEVkgJpqlmitBpoTgBdgpD1urSxXxgP1RWEgMET7Se53rVn9lWqKjUe4VOuZORI8p
         Df2leGzW26YMGIT/RYMpA5xO0Ca1PubjbS97oGoEcKcxlp6+5inMRm1AbCM3ie0B6a
         kfgcIElLShRfWRV4yXDrPk1YCN+szwKok24WbEUs=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190822081720eucas1p29ee1e2d981cc9fa43bf41c748e1d8f2e~9ML6khgqf2927229272eucas1p2M;
        Thu, 22 Aug 2019 08:17:20 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 53.84.04374.09F4E5D5; Thu, 22
        Aug 2019 09:17:20 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190822081719eucas1p13b7b5abe25b1838b38e77002a5daa5c3~9ML52Wn7g2311423114eucas1p1H;
        Thu, 22 Aug 2019 08:17:19 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190822081719eusmtrp118abc76009661efb2087d6ca197b26bf~9ML5nhRmO2148421484eusmtrp1n;
        Thu, 22 Aug 2019 08:17:19 +0000 (GMT)
X-AuditID: cbfec7f5-4ddff70000001116-cb-5d5e4f90955c
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id FE.1D.04117.F8F4E5D5; Thu, 22
        Aug 2019 09:17:19 +0100 (BST)
Received: from [106.109.129.180] (unknown [106.109.129.180]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190822081718eusmtip28624971d74a2604a01884c8f1e9f78b1~9ML4wwYRV2944029440eusmtip2S;
        Thu, 22 Aug 2019 08:17:18 +0000 (GMT)
Subject: Re: [PATCH net] ixgbe: fix double clean of tx descriptors with xdp
To:     William Tu <u9012063@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Eelco Chaudron <echaudro@redhat.com>
From:   Ilya Maximets <i.maximets@samsung.com>
Message-ID: <cbf7c51b-9ce7-6ef6-32c4-981258d4af4c@samsung.com>
Date:   Thu, 22 Aug 2019 11:17:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALDO+SZCbxEEwCS6MyHk-Cp_LJ33N=QFqwZ8uRm0e-PBRgxRYw@mail.gmail.com>
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SWUwTURSGvZ3pzLRSGUqVE0RJGjVCFNwexsQ9mEz0wS0RRFCrjAWlVTqC
        ghsKoqJRcINWlJJqWHyAsEWQkFjKrjUCCopEVFDBoMEipJaIDgORt++e/57/nD85FKbskXpT
        UfpjnEGviVYTcry8zmlfnLZlT/iS69U+zNi9TpwZcnaSzGhKEWIctnqCseQMY0zWi2Scedfm
        JJi2i06SGXvrkjJ1X5MJpqHkPWJaK7MIJs/aQDJ15llMe4vbOne2NP+NhK0wdZGspapPwqZ2
        tGBsccFlgm1MimUzrnzA2B/Vrwj2WmkBYh3Fc7fKQ+WrIrjoqDjOELhmnzzym+MTOmoOPPHk
        dSuZiMoWpCIZBfQKaOqxkKlITinpPAQD5jZMfAwhGCl0TigOBMaXZnKypaLWiUQhF0FO9v2J
        lkEEH2tt0lREUZ70ZqitxYQGFb0dMqu6CIExOgmHF+kHBSboRdD0yIaE7wp6DZS4fIUyTs+H
        4Zyu8Vkz6RD42V0jFVhBe0CjsQcXWEZvg/SMdly09ILzQ/lSkX0hqewuJu55m4KmjtOCPdBB
        YCo6JZY9ob++dCKKDzTfvIqLfBbeJ/eNxwL6EoIM6x+JKKyF0m92UvDBaD8orAwULdfDrwt+
        Is6AjgEPcYEZcKM8AxPLCriUohQ95oHrae7EXt7w5ruDTENq05RYpilRTFOimP6PNSO8AHlx
        sbxOy/HL9dzxAF6j42P12oADR3TF6N/tNf+p//UYVY/utyKaQmo3Rdri8HClVBPHx+usCChM
        rVKcyAoNVyoiNPEJnOHIXkNsNMdb0WwKV3spTk7r3q2ktZpj3GGOO8oZJlUJJfNORDKVpe/V
        1Wm/5476uId1uYcFRcr1xhB70EjCzpWFp5d8WWZ7Wkhl5htbZTWfr4xoY1a32PyDn/n1Fm3s
        39S38GfbLonqgXvV82WGXsvw52bJliJ59qhR1zzdlu77cPBOWvoh14amxLjAmM1+t2rmrPTu
        PXM5mq8Ptq+N6+YPn9uxqV+N85Gapf6Ygdf8BZdSLFR3AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t/xe7r9/nGxBot2aln8n3ubxeLLz9vs
        Fn/aNjBafD5ynM1i8cJvzBZzzrewWNy58pPN4kr7T3aL/7d+s1oce9HCZnFi831Gi8u75rBZ
        rDh0gt3i2AIxi+uXeBz4PbasvMnksXPWXXaPxXteMnl03bjE7LFpVSebx8nmUo/p3Q+ZPd7v
        u8rm0bdlFaPH501yAVxRejZF+aUlqQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbmsVZGpkr6djYp
        qTmZZalF+nYJehmvPz9mLFigX7H72mX2Bsatal2MnBwSAiYSO4/+ZOxi5OIQEljKKNH+cB0b
        REJK4sevC6wQtrDEn2tdbBBF7xklDp36DdTBwSEs4C1x9CgzSI2IQJBEx5ZLrCA1zAKtLBKz
        FhxggWiYyiLR+nASO0gVm4COxKnVR8CaeQXsJDb/lgcJswioSnxbeBesRFQgQuLwjlmMIDav
        gKDEyZlPWEBsToFAiYnTr4PZzALqEn/mXWKGsMUlmr6sZIWw5SWat85mnsAoNAtJ+ywkLbOQ
        tMxC0rKAkWUVo0hqaXFuem6xkV5xYm5xaV66XnJ+7iZGYMRvO/Zzyw7GrnfBhxgFOBiVeHgn
        6MbGCrEmlhVX5h5ilOBgVhLhrZgTFSvEm5JYWZValB9fVJqTWnyI0RTouYnMUqLJ+cBklFcS
        b2hqaG5haWhubG5sZqEkztshcDBGSCA9sSQ1OzW1ILUIpo+Jg1OqgVFmR45g/nuFvO4W5kcs
        Zy4tXnL79LzTt019ligbLD5ZzH5AoiBN4VDoVP1nZ91Et8ziS/ZI3CG9Oahh06sXnHd25vMm
        hWjpTpihIBPza/qHDQH7tT5fWGH2Wbvh5sJvPF9P6C3aXHvQy/f3t7X/jBd8/ZcibTy9K/jc
        bP6lRy+3d8atjO0/Nc1ZiaU4I9FQi7moOBEAWMOQ/A4DAAA=
X-CMS-MailID: 20190822081719eucas1p13b7b5abe25b1838b38e77002a5daa5c3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190820151644eucas1p179d6d1da42bb6be0aad8f58ac46624ce
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190820151644eucas1p179d6d1da42bb6be0aad8f58ac46624ce
References: <CGME20190820151644eucas1p179d6d1da42bb6be0aad8f58ac46624ce@eucas1p1.samsung.com>
        <20190820151611.10727-1-i.maximets@samsung.com>
        <CAKgT0Udn0D0_f=SOH2wpBRWV_u4rb1Qe2h7gguXnRNzJ_VkRzg@mail.gmail.com>
        <625791af-c656-1e42-b60e-b3a5cedcb4c4@samsung.com>
        <CAKgT0Uc27+ucd=a_sgTmv5g7_+ZTg1zK4isYJ0H7YWQj3d=Ejg@mail.gmail.com>
        <f7d0f7a5-e664-8b72-99c7-63275aff4c18@samsung.com>
        <CAKgT0UcCKiM1Ys=vWxctprN7fzWcBCk-PCuKB-8=RThM=CqLSQ@mail.gmail.com>
        <CALDO+SZCbxEEwCS6MyHk-Cp_LJ33N=QFqwZ8uRm0e-PBRgxRYw@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.08.2019 0:38, William Tu wrote:
> On Wed, Aug 21, 2019 at 9:57 AM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:
>>
>> On Wed, Aug 21, 2019 at 9:22 AM Ilya Maximets <i.maximets@samsung.com> wrote:
>>>
>>> On 21.08.2019 4:17, Alexander Duyck wrote:
>>>> On Tue, Aug 20, 2019 at 8:58 AM Ilya Maximets <i.maximets@samsung.com> wrote:
>>>>>
>>>>> On 20.08.2019 18:35, Alexander Duyck wrote:
>>>>>> On Tue, Aug 20, 2019 at 8:18 AM Ilya Maximets <i.maximets@samsung.com> wrote:
>>>>>>>
>>>>>>> Tx code doesn't clear the descriptor status after cleaning.
>>>>>>> So, if the budget is larger than number of used elems in a ring, some
>>>>>>> descriptors will be accounted twice and xsk_umem_complete_tx will move
>>>>>>> prod_tail far beyond the prod_head breaking the comletion queue ring.
>>>>>>>
>>>>>>> Fix that by limiting the number of descriptors to clean by the number
>>>>>>> of used descriptors in the tx ring.
>>>>>>>
>>>>>>> Fixes: 8221c5eba8c1 ("ixgbe: add AF_XDP zero-copy Tx support")
>>>>>>> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
>>>>>>
>>>>>> I'm not sure this is the best way to go. My preference would be to
>>>>>> have something in the ring that would prevent us from racing which I
>>>>>> don't think this really addresses. I am pretty sure this code is safe
>>>>>> on x86 but I would be worried about weak ordered systems such as
>>>>>> PowerPC.
>>>>>>
>>>>>> It might make sense to look at adding the eop_desc logic like we have
>>>>>> in the regular path with a proper barrier before we write it and after
>>>>>> we read it. So for example we could hold of on writing the bytecount
>>>>>> value until the end of an iteration and call smp_wmb before we write
>>>>>> it. Then on the cleanup we could read it and if it is non-zero we take
>>>>>> an smp_rmb before proceeding further to process the Tx descriptor and
>>>>>> clearing the value. Otherwise this code is going to just keep popping
>>>>>> up with issues.
>>>>>
>>>>> But, unlike regular case, xdp zero-copy xmit and clean for particular
>>>>> tx ring always happens in the same NAPI context and even on the same
>>>>> CPU core.
>>>>>
>>>>> I saw the 'eop_desc' manipulations in regular case and yes, we could
>>>>> use 'next_to_watch' field just as a flag of descriptor existence,
>>>>> but it seems unnecessarily complicated. Am I missing something?
>>>>>
>>>>
>>>> So is it always in the same NAPI context?. I forgot, I was thinking
>>>> that somehow the socket could possibly make use of XDP for transmit.
>>>
>>> AF_XDP socket only triggers tx interrupt on ndo_xsk_async_xmit() which
>>> is used in zero-copy mode. Real xmit happens inside
>>> ixgbe_poll()
>>>  -> ixgbe_clean_xdp_tx_irq()
>>>     -> ixgbe_xmit_zc()
>>>
>>> This should be not possible to bound another XDP socket to the same netdev
>>> queue.
>>>
>>> It also possible to xmit frames in xdp_ring while performing XDP_TX/REDIRECT
>>> actions. REDIRECT could happen from different netdev with different NAPI
>>> context, but this operation is bound to specific CPU core and each core has
>>> its own xdp_ring.
>>>
>>> However, I'm not an expert here.
>>> Björn, maybe you could comment on this?
>>>
>>>>
>>>> As far as the logic to use I would be good with just using a value you
>>>> are already setting such as the bytecount value. All that would need
>>>> to happen is to guarantee that the value is cleared in the Tx path. So
>>>> if you clear the bytecount in ixgbe_clean_xdp_tx_irq you could
>>>> theoretically just use that as well to flag that a descriptor has been
>>>> populated and is ready to be cleaned. Assuming the logic about this
>>>> all being in the same NAPI context anyway you wouldn't need to mess
>>>> with the barrier stuff I mentioned before.
>>>
>>> Checking the number of used descs, i.e. next_to_use - next_to_clean,
>>> makes iteration in this function logically equal to the iteration inside
>>> 'ixgbe_xsk_clean_tx_ring()'. Do you think we need to change the later
>>> function too to follow same 'bytecount' approach? I don't like having
>>> two different ways to determine number of used descriptors in the same file.
>>>
>>> Best regards, Ilya Maximets.
>>
>> As far as ixgbe_clean_xdp_tx_irq() vs ixgbe_xsk_clean_tx_ring(), I
>> would say that if you got rid of budget and framed things more like
>> how ixgbe_xsk_clean_tx_ring was framed with the ntc != ntu being
>> obvious I would prefer to see us go that route.
>>
>> Really there is no need for budget in ixgbe_clean_xdp_tx_irq() if you
>> are going to be working with a static ntu value since you will only
>> ever process one iteration through the ring anyway. It might make more
>> sense if you just went through and got rid of budget and i, and
>> instead used ntc and ntu like what was done in
>> ixgbe_xsk_clean_tx_ring().
>>
>> Thanks.
>>
>> - Alex
> 
> Not familiar with the driver details.
> I tested this patch and the issue mentioned in OVS mailing list.
> https://www.mail-archive.com/ovs-dev@openvswitch.org/msg35362.html
> and indeed the problem goes away.

Good. Thanks for testing!

> But I saw a huge performance drop,
> my AF_XDP tx performance drops from >9Mpps to <5Mpps.

I didn't expect so big performance difference with this change.
What is your test scenario? Is it possible that you're accounting same
packet several times due to broken completion queue?

Looking at samples/bpf/xdpsock_user.c:complete_tx_only(), it accounts
sent packets (tx_npkts) by accumulating results of xsk_ring_cons__peek()
for completion queue, so it's not a trusted source of pps information.

Best regards, Ilya Maximets.

> 
> Tested using kernel 5.3.0-rc3+
> 03:00.0 Ethernet controller: Intel Corporation Ethernet Controller
> 10-Gigabit X540-AT2 (rev 01)
> Subsystem: Intel Corporation Ethernet 10G 2P X540-t Adapter
> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> 
> Regards,
> William
