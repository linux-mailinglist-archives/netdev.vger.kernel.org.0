Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9D0D98CE0
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 10:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731312AbfHVIF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 04:05:58 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:35499 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731257AbfHVIF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 04:05:58 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190822080556euoutp02139f36de320bf9a6e04439c8b77d867c~9MB9otoIg1424114241euoutp02l
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 08:05:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190822080556euoutp02139f36de320bf9a6e04439c8b77d867c~9MB9otoIg1424114241euoutp02l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1566461156;
        bh=4zxlvUFQ7kHa/ksIbQBsJoh28JPFEn+LcgjtZFtKCHY=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=ONNztFHtxctClNwYIDQtXTgHdMTa1iV/H7OkuxSEo9ECWjS0sJRD5zTuVXTBsC/Gu
         tf302rQHiFWN+ORTsNAk3PE9naHdW6UWMLeTrQyhpGPYRafMgQ0LsLwy2KID+mkeTy
         CkmPbpdgMP03hct31Hyr4wDwQQeKbCLUHIux/5wU=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190822080555eucas1p2cfd3d35e5146fdfbd8a2f18ec2b54549~9MB8nyJzw0411304113eucas1p2x;
        Thu, 22 Aug 2019 08:05:55 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 1E.B2.04374.3EC4E5D5; Thu, 22
        Aug 2019 09:05:55 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190822080554eucas1p2610b6e5b48679b6cc912eb5ced8b9502~9MB75AJy82378423784eucas1p2q;
        Thu, 22 Aug 2019 08:05:54 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190822080554eusmtrp23e970cb4e30bb13756c118f3d7af5245~9MB7qzioP3146831468eusmtrp2Z;
        Thu, 22 Aug 2019 08:05:54 +0000 (GMT)
X-AuditID: cbfec7f5-4f7ff70000001116-8f-5d5e4ce3aaff
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 93.1A.04166.2EC4E5D5; Thu, 22
        Aug 2019 09:05:54 +0100 (BST)
Received: from [106.109.129.180] (unknown [106.109.129.180]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190822080553eusmtip2170b491e8fa5ca2ecbf729347cfc9810~9MB6yGR6m2361123611eusmtip24;
        Thu, 22 Aug 2019 08:05:53 +0000 (GMT)
Subject: Re: [Intel-wired-lan] [PATCH net] ixgbe: fix double clean of tx
 descriptors with xdp
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>, William Tu <u9012063@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        bpf <bpf@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Eelco Chaudron <echaudro@redhat.com>
From:   Ilya Maximets <i.maximets@samsung.com>
Message-ID: <54faa2f1-345d-b5b2-7e48-963876b62813@samsung.com>
Date:   Thu, 22 Aug 2019 11:05:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAJ+HfNjo0tpk2v_+85SuX7Jw797QwRA7uJBggPHtY=JznLC9Zg@mail.gmail.com>
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBKsWRmVeSWpSXmKPExsWy7djPc7qPfeJiDb7slLX4P/c2i8WXn7fZ
        Lc5PO8Vm8adtA6PF5yPH2SwWL/zGbDHnfAuLxZ0rP9ksrrT/ZLf4f+s3q8WxFy1sFpd3zWGz
        WHHoBLvFsQViFtcv8Tjwe2xZeZPJY+esu+wei/e8ZPLounGJ2WPTqk42j5PNpR7Tux8ye7zf
        d5XNo2/LKkaPz5vkAriiuGxSUnMyy1KL9O0SuDLWvtQvaNeueNfwi6mB8aNSFyMnh4SAicSV
        /susXYxcHEICKxglrjTPZIZwvjBKdL1+ApX5zCjx98oiZpiW7n1LmSASyxklTq37CVX1kVFi
        zqktjCBVwgLxEnPurWYCsUUEsiW+X5zKBlLELPCDWWLn7JNsIAk2AR2JU6uPgDXwCthJHFu1
        nx3EZhFQldgx/xHYOlGBCIlPDw6zQtQISpyc+YQFxOYUCJRY8KwXLM4sIC7R9GUllC0v0bx1
        NtgTEgK9HBKPp91kgbjbRWLj+i9QPwhLvDq+hR3ClpH4v3M+E4RdL3G/5SUjRHMHo8T0Q/+g
        EvYSW16fA2rgANqgKbF+lz6IKSHgKPG1VRPC5JO48VYQ4gQ+iUnbpjNDhHklOtqEIGaoSPw+
        uBzqACmJm+8+s09gVJqF5LFZSJ6ZheSZWQhrFzCyrGIUTy0tzk1PLTbOSy3XK07MLS7NS9dL
        zs/dxAhMf6f/Hf+6g3Hfn6RDjAIcjEo8vBN0Y2OFWBPLiitzDzFKcDArifBWzImKFeJNSays
        Si3Kjy8qzUktPsQozcGiJM5bzfAgWkggPbEkNTs1tSC1CCbLxMEp1cC4VP7sveunlms4nwoy
        XDlf/xS73LQv8z/pHO5bxfM5M3zehOY9JVesfWIkesPfuR+K2LqxWDFvyqN966YdqLnV2rld
        kOmNaMGkOZW8/XuZzwk9Dw32YtC8fUTWpDXCRqDjlzvzjIC+wiXF1rF5LwwYTl7RVsyaoOyr
        Xy5wTfb5jLgdcysfb+dXYinOSDTUYi4qTgQAk/YWrHsDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t/xe7qPfOJiDRovaVj8n3ubxeLLz9vs
        FuennWKz+NO2gdHi85HjbBaLF35jtphzvoXF4s6Vn2wWV9p/slv8v/Wb1eLYixY2i8u75rBZ
        rDh0gt3i2AIxi+uXeBz4PbasvMnksXPWXXaPxXteMnl03bjE7LFpVSebx8nmUo/p3Q+ZPd7v
        u8rm0bdlFaPH501yAVxRejZF+aUlqQoZ+cUltkrRhhZGeoaWFnpGJpZ6hsbmsVZGpkr6djYp
        qTmZZalF+nYJehlrX+oXtGtXvGv4xdTA+FGpi5GTQ0LARKJ731KmLkYuDiGBpYwSh65uYoNI
        SEn8+HWBFcIWlvhzrQssLiTwnlFi9n0wW1ggXmLOvdVMILaIQLZE09GLbCCDmAV+MUscf7kT
        aupUFomH+2+zg1SxCehInFp9hBHE5hWwkzi2aj9YnEVAVWLH/EfMILaoQITE4R2zoGoEJU7O
        fMICYnMKBEoseNYLdhGzgLrEn3mXmCFscYmmLyuh4vISzVtnM09gFJqFpH0WkpZZSFpmIWlZ
        wMiyilEktbQ4Nz232FCvODG3uDQvXS85P3cTIzDitx37uXkH46WNwYcYBTgYlXh4J+jGxgqx
        JpYVV+YeYpTgYFYS4a2YExUrxJuSWFmVWpQfX1Sak1p8iNEU6LmJzFKiyfnAZJRXEm9oamhu
        YWlobmxubGahJM7bIXAwRkggPbEkNTs1tSC1CKaPiYNTqoExRprjYBR334HdH2Ma51lsXvDi
        3cTVLlm5q4s5H0/2XHmuP0rw+qS6wzJCnLHi1xLOrjx9fklpwZNFDhpuN6dLdB99u2tmj9mv
        QpmAtjwtzoPFFg9e3p+8cvECFeHnbvMXPti0aMlT49+/DtpWceQtP71xneGdy0k7Zus8tDo7
        NSJ++Tk3gcv32ZVYijMSDbWYi4oTAc2jckYOAwAA
X-CMS-MailID: 20190822080554eucas1p2610b6e5b48679b6cc912eb5ced8b9502
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
        <CAJ+HfNjo0tpk2v_+85SuX7Jw797QwRA7uJBggPHtY=JznLC9Zg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.08.2019 10:12, Björn Töpel wrote:
> On Wed, 21 Aug 2019 at 18:57, Alexander Duyck <alexander.duyck@gmail.com> wrote:
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
> 
> +1. I'd prefer this as well!

Sounds good. I'll look in this direction.
But I'm not completely sure about 'budget' elimination. Wouldn't it cause
issues if we'll clean the whole ring at once? I mean maybe it'll be too long
to hold the CPU core for this amount of work.
We could re-work the code keeping the loop break on budget exhaustion.
What do you think?

> 
> 
> Cheers,
> Björn
> 
>> Thanks.
>>
>> - Alex
>> _______________________________________________
>> Intel-wired-lan mailing list
>> Intel-wired-lan@osuosl.org
>> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
> 
> 
