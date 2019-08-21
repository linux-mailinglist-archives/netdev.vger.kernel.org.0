Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 712AA97FE5
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 18:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbfHUQWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 12:22:04 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56665 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbfHUQWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 12:22:03 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190821162200euoutp013a28a51a2b1a27a01b5e2b0e83fa2d60~8-JzXQtQk0066300663euoutp01U
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 16:22:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190821162200euoutp013a28a51a2b1a27a01b5e2b0e83fa2d60~8-JzXQtQk0066300663euoutp01U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1566404521;
        bh=o9OwLt9/WkSr9TsiZ22HcVerYaZHCMss002A6VSz+VY=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=dlf2Aish48wW/AClWjwKQHOvwBlhLFshRRAucjhm3z4caKEXMnG6sEQoEn8H2WExf
         byQd1bu3VU7Vz/NJjA0poZo9ihxf3IEB/2YUmlDfLS7wV9P7MG3a+6BK79Z59b3AdS
         HSfDDrZBWs9wkU8v3ZPv4kTmjxcHhyyqsuJmq3h8=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190821162159eucas1p22949f7d89eb3c051c42232f0528f322c~8-JyWCaAl0529205292eucas1p2A;
        Wed, 21 Aug 2019 16:21:59 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 89.F6.04309.7AF6D5D5; Wed, 21
        Aug 2019 17:21:59 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190821162158eucas1p2f45685b792cc1fae1d62becab15cda24~8-Jxdzpol0535005350eucas1p25;
        Wed, 21 Aug 2019 16:21:58 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190821162158eusmtrp11c7aa05bb3b12307c612da80565912b2~8-JxPW8QO1676516765eusmtrp1N;
        Wed, 21 Aug 2019 16:21:58 +0000 (GMT)
X-AuditID: cbfec7f4-ae1ff700000010d5-eb-5d5d6fa744e6
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 50.DD.04166.6AF6D5D5; Wed, 21
        Aug 2019 17:21:58 +0100 (BST)
Received: from [106.109.129.180] (unknown [106.109.129.180]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190821162157eusmtip1d58ee00e2fe90c2bf5e66e1a481b6ab0~8-JwZRz180228402284eusmtip1t;
        Wed, 21 Aug 2019 16:21:57 +0000 (GMT)
Subject: Re: [PATCH net] ixgbe: fix double clean of tx descriptors with xdp
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        William Tu <u9012063@gmail.com>
From:   Ilya Maximets <i.maximets@samsung.com>
Message-ID: <f7d0f7a5-e664-8b72-99c7-63275aff4c18@samsung.com>
Date:   Wed, 21 Aug 2019 19:21:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0Uc27+ucd=a_sgTmv5g7_+ZTg1zK4isYJ0H7YWQj3d=Ejg@mail.gmail.com>
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se1BMYRjG+/acPee00+a0oXcKsZMZGeUyZnyZphR/nBly+4tYbDrS1FZ2
        K6UxNelO9zGxYiIju8bIWkluY+kmFqmUIrcZrUq0GzWasJ0a/ff75nmf93mfmY8hZF/E7kxk
        TDyvjlFGyykJWdMwZvapilUoVgyfWoz/nO0msW2sm8bjWdUIWx83Urjy/E8Clz/PIHFP2xiF
        27LHaPznzW8xbujLoHDTjV6EX9WVU/iyqYnGDRVz8etWp3WzOKOuS8Td1r6lucq7FhGX19lK
        cAZ9LsU1H0vgyo5/ILih++0UV2DUI85qWLBVEirxD+ejIxN59fKAfZKDVzt+obh785NaK76I
        0tBbtzzkyAC7GgrvWMR5SMLI2MsIPmWaRMLDhkBrtkw9rAi+V2eLpy0TLwtoQahCUFR6acr/
        A4HpczuZhxjGld0I9fWE3TCbjQJ95bnJGYL9SMDZoWbKLlDsMnhy5TGys5QNgBHTIG1nkl0M
        A4ank2lz2B0w/P6RWJhxgebTn0k7O7Lb4Na7jkkmWDdIt+nEAnvCsZtnCHsYsMUMZHWPEvaD
        gN0A2acWCQ1c4WujkRZ4HrSUniAFToXeDAsSvDkIykwTIkEIBGO/mbbvIVhvuFa3XFgZBCOZ
        3gI6Q+egi3CBM5TUlE2FSiEnSybs8ILfD6sIgd2h65uVLkJy7Yxe2hldtDO6aP/HViBSj9z4
        BI0qgtesiuEP+2qUKk1CTITv/liVAf37fi0TjbZaVDceZkIsg+RO0iIfhUImViZqklUmBAwh
        ny1NKg9VyKThyuQjvDp2rzohmteYkAdDyt2kKQ7vd8nYCGU8H8Xzcbx6WhUxju5paMvO+WGZ
        Lu1HD7Xp+hKz/SIv1H709lgfXByoP/Qz/7inz/Cmko5rS/JbN+eu6SlUrr04us0vIDi8hzrv
        jwfS/VZIt3u+2EIF4XOqkFl8w54e92rklfrgpKH0WezWnf3d8eMLhxyud6QYDzjtDgsNCdPp
        LtiyLDUh0RUfvL6ezpX7muWk5qBy5VJCrVH+BYrQQBB6AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t/xu7rL8mNjDb6/1LD4P/c2i8WXn7fZ
        Lf60bWC0+HzkOJvF4oXfmC3mnG9hsbhz5SebxZX2n+wW/2/9ZrU49qKFzeLE5vuMFpd3zWGz
        WHHoBLvFsQViFtcv8Tjwe2xZeZPJY+esu+wei/e8ZPLounGJ2WPTqk42j5PNpR7Tux8ye7zf
        d5XNo2/LKkaPz5vkArii9GyK8ktLUhUy8otLbJWiDS2M9AwtLfSMTCz1DI3NY62MTJX07WxS
        UnMyy1KL9O0S9DLWXvvOWLBXtuLSgudMDYx3xbsYOTkkBEwk/l3sY+9i5OIQEljKKHF38kM2
        iISUxI9fF1ghbGGJP9e62CCK3jNKrDw/Gcjh4BAW8JY4epQZpEZEIFvixo8+VpAaZoEnzBJt
        /y4wQzRcYpL4N20+C0gVm4COxKnVRxhBbF4BO4mvh96yg9gsAqoSbzadAdsmKhAhcXjHLKga
        QYmTM5+A9XIKBEpsv3cNzGYWUJf4M+8SM4QtLtH0ZSUrhC0v0bx1NvMERqFZSNpnIWmZhaRl
        FpKWBYwsqxhFUkuLc9Nziw31ihNzi0vz0vWS83M3MQJjftuxn5t3MF7aGHyIUYCDUYmHd4Ju
        bKwQa2JZcWXuIUYJDmYlEd6KOVGxQrwpiZVVqUX58UWlOanFhxhNgZ6byCwlmpwPTEd5JfGG
        pobmFpaG5sbmxmYWSuK8HQIHY4QE0hNLUrNTUwtSi2D6mDg4pRoYE3asryvpNN3U5/ZtspC3
        wwWtXXVfLhSZdBVYtM47qdKT/sj5UozN1ahrpV9E0758+vzs37EX78rdvveVFmlPTFiiIT51
        8eOGF6GcF45Eb3WW6fiWPFXrZfkfefP8uebHVQ5rLreZk+66ccP/Nk++vL6Ekp5T+4N8bYpj
        F7mJM/AW7PkedPW8EktxRqKhFnNRcSIAFIcfWQ8DAAA=
X-CMS-MailID: 20190821162158eucas1p2f45685b792cc1fae1d62becab15cda24
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
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.08.2019 4:17, Alexander Duyck wrote:
> On Tue, Aug 20, 2019 at 8:58 AM Ilya Maximets <i.maximets@samsung.com> wrote:
>>
>> On 20.08.2019 18:35, Alexander Duyck wrote:
>>> On Tue, Aug 20, 2019 at 8:18 AM Ilya Maximets <i.maximets@samsung.com> wrote:
>>>>
>>>> Tx code doesn't clear the descriptor status after cleaning.
>>>> So, if the budget is larger than number of used elems in a ring, some
>>>> descriptors will be accounted twice and xsk_umem_complete_tx will move
>>>> prod_tail far beyond the prod_head breaking the comletion queue ring.
>>>>
>>>> Fix that by limiting the number of descriptors to clean by the number
>>>> of used descriptors in the tx ring.
>>>>
>>>> Fixes: 8221c5eba8c1 ("ixgbe: add AF_XDP zero-copy Tx support")
>>>> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
>>>
>>> I'm not sure this is the best way to go. My preference would be to
>>> have something in the ring that would prevent us from racing which I
>>> don't think this really addresses. I am pretty sure this code is safe
>>> on x86 but I would be worried about weak ordered systems such as
>>> PowerPC.
>>>
>>> It might make sense to look at adding the eop_desc logic like we have
>>> in the regular path with a proper barrier before we write it and after
>>> we read it. So for example we could hold of on writing the bytecount
>>> value until the end of an iteration and call smp_wmb before we write
>>> it. Then on the cleanup we could read it and if it is non-zero we take
>>> an smp_rmb before proceeding further to process the Tx descriptor and
>>> clearing the value. Otherwise this code is going to just keep popping
>>> up with issues.
>>
>> But, unlike regular case, xdp zero-copy xmit and clean for particular
>> tx ring always happens in the same NAPI context and even on the same
>> CPU core.
>>
>> I saw the 'eop_desc' manipulations in regular case and yes, we could
>> use 'next_to_watch' field just as a flag of descriptor existence,
>> but it seems unnecessarily complicated. Am I missing something?
>>
> 
> So is it always in the same NAPI context?. I forgot, I was thinking
> that somehow the socket could possibly make use of XDP for transmit.

AF_XDP socket only triggers tx interrupt on ndo_xsk_async_xmit() which
is used in zero-copy mode. Real xmit happens inside
ixgbe_poll()
 -> ixgbe_clean_xdp_tx_irq()
    -> ixgbe_xmit_zc()

This should be not possible to bound another XDP socket to the same netdev
queue.

It also possible to xmit frames in xdp_ring while performing XDP_TX/REDIRECT
actions. REDIRECT could happen from different netdev with different NAPI
context, but this operation is bound to specific CPU core and each core has
its own xdp_ring.

However, I'm not an expert here.
Björn, maybe you could comment on this?

> 
> As far as the logic to use I would be good with just using a value you
> are already setting such as the bytecount value. All that would need
> to happen is to guarantee that the value is cleared in the Tx path. So
> if you clear the bytecount in ixgbe_clean_xdp_tx_irq you could
> theoretically just use that as well to flag that a descriptor has been
> populated and is ready to be cleaned. Assuming the logic about this
> all being in the same NAPI context anyway you wouldn't need to mess
> with the barrier stuff I mentioned before.

Checking the number of used descs, i.e. next_to_use - next_to_clean,
makes iteration in this function logically equal to the iteration inside
'ixgbe_xsk_clean_tx_ring()'. Do you think we need to change the later
function too to follow same 'bytecount' approach? I don't like having
two different ways to determine number of used descriptors in the same file.

Best regards, Ilya Maximets.
