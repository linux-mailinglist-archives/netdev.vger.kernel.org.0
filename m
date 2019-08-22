Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83C2A99932
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 18:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389964AbfHVQaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 12:30:21 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57209 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389955AbfHVQaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 12:30:20 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190822163018euoutp01e5815a1b317a03f1a99981f9406083f8~9S6U7YCtf2039820398euoutp01x
        for <netdev@vger.kernel.org>; Thu, 22 Aug 2019 16:30:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190822163018euoutp01e5815a1b317a03f1a99981f9406083f8~9S6U7YCtf2039820398euoutp01x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1566491418;
        bh=hOUF6Gzqf4+SSBY2i+OpEO1X4NBxnMXVxjifcFB2spM=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=FZc1smLqzb3zZa27YKCvH9TrAOzk3JBf+6VsRV9Edal7LQi5dQd86hVxMbYYIvJaO
         7CpBhaZqUQ6A+mmnPLHFXnLL3Mn+Xvsq3sbpvRGYtAHhiL2jn3zFTEguV4Hc8yE3Z4
         pKdFxxjM792eRFkGJbxaJTtoKS4S2bBsWMjtXNnM=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190822163017eucas1p274647b13d0f228bb3e37a4e455ef2831~9S6T1giVj2067120671eucas1p2I;
        Thu, 22 Aug 2019 16:30:17 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id B8.06.04469.813CE5D5; Thu, 22
        Aug 2019 17:30:16 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190822163016eucas1p126fb54c2234bdd541cfb0b4e41bb5684~9S6S0N6Mk2136721367eucas1p1X;
        Thu, 22 Aug 2019 16:30:16 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190822163015eusmtrp2776678612bd907e910c8d3db09280d07~9S6SkeoJu2926429264eusmtrp2G;
        Thu, 22 Aug 2019 16:30:15 +0000 (GMT)
X-AuditID: cbfec7f2-54fff70000001175-f2-5d5ec3185b42
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 7A.E6.04166.713CE5D5; Thu, 22
        Aug 2019 17:30:15 +0100 (BST)
Received: from [106.109.129.180] (unknown [106.109.129.180]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190822163014eusmtip2e6ae918716aa14a03338431c59d73b6d~9S6Rpbg-J2946029460eusmtip2S;
        Thu, 22 Aug 2019 16:30:14 +0000 (GMT)
Subject: Re: [PATCH net] ixgbe: fix double clean of tx descriptors with xdp
To:     William Tu <u9012063@gmail.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
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
Message-ID: <5bcebb64-2bd8-902e-eebe-3a94f317b074@samsung.com>
Date:   Thu, 22 Aug 2019 19:30:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
        Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALDO+SaRNMvmXrQqOtNiRsOkgfOQAW4EA2yVgmeoGQto2zvfMQ@mail.gmail.com>
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHe3fOzs6Gs7dp+WBhtW4Y5qWszofQgqhD90AoFK2lp01y0zZd
        WR+yvM80NWG4FI0IaxXF8l4pzctmUpJprSxUMMrsullhieY8Sn77Pc//+T/v/4GXJmQfhL50
        vCaZ02oUCXJKQta2jz1bBy0x0cF/xjcyk+V9JDM61idixrPuIcbVaqOYa1d/EUxZVwbJvO0Z
        o5ie7DERM/nmr5Bp/5hBMfb7/Yh50VhGMTesdhHTXrmIedXtsXU+W33ztYBtML0TsdceDgtY
        g6ObYC3mXIrtSE9hjXmDBPutqZdiC6rNiHVZ/A5IIiVb4riEeD2nDQo7KlHVlTiESTWbTjfd
        clJp6E6AAYlpwKFQWpopMCAJLcM3ENRkDQr5YhRBgdVO8IULQafNRc5aftQ3zwhVCOoqe2f8
        PxB8ru+amqJpL7wb2toIt8EbrwDj8+/IPUNgCwnm0a/TmygcAE9utSI3S3EYlH9yIbeXxKvg
        Q164u70QHwbnQIuQH1kAHaVD01YxPgh9uZcpNxPYBy6M3hTyvBTSa65MhwNcREP59RLEp94O
        hRYHwbMXfLJVi3heApMNFQKez0F/xjDizTkIjNaJGSEcqkeeidzhCOwPdxuD3Ah4G/zM9OfR
        ExxfFvARPKG41kjwbSnkZMn4HSvh7+OqmQC+8PqrS1SI5KY5h5nmHGOac4zp/7OViDQjHy5F
        p1ZyuhANdypQp1DrUjTKwNhEtQVNfb/OCZuzHv3sPmZFmEZyD6ndEBMtEyr0ulS1FQFNyL2l
        +qKpljROkXqG0yYe0aYkcDorWkyTch/p2XkDUTKsVCRzJzguidPOqgJa7JuGBA82P61cHyEK
        zYiJxfdWqxqVcZqWveObvYI1HlnGPRtGyopH9nd9Pl6YFH2gYJ9X63C2IbXiN5dU1Uc1R5zL
        3Sk2ePbm73ipXx6xMflwy6qFjuiLJy892pWgRJHgOC/3N99WxTS/zI+KP+R96O4ZPBGq0i9a
        Fuu3xrkiSqjuH3ovJ3UqRchaQqtT/ANYMhJFegMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t/xe7rih+NiDc5NMLD4P/c2i8WXn7fZ
        Lf60bWC0+HzkOJvF4oXfmC3mnG9hsbhz5SebxZX2n+wW/2/9ZrU49qKFzeLE5vuMFpd3zWGz
        WHHoBLvFsQViFtcv8Tjwe2xZeZPJY+esu+wei/e8ZPLounGJ2WPTqk42j5PNpR7Tux8ye7zf
        d5XNo2/LKkaPz5vkArii9GyK8ktLUhUy8otLbJWiDS2M9AwtLfSMTCz1DI3NY62MTJX07WxS
        UnMyy1KL9O0S9DK2T7nBWrDVrGLf6k9sDYxrdboYOTkkBEwkPu7Yz9zFyMUhJLCUUeL1rw5W
        iISUxI9fF6BsYYk/17rYIIreM0r0HL3F3sXIwSEs4C1x9CgzSI2IgLLE9IsfGEFqmAW2sEhs
        3raCCSQhJDCRVeLwr1wQm01AR+LU6iOMIDavgJ3E3FefGUHmsAioSjzvtgcJiwpESBzeMQuq
        RFDi5MwnLCA2p0CgxO3OyWwgNrOAusSfeZeYIWxxiaYvK1khbHmJ5q2zmScwCs1C0j4LScss
        JC2zkLQsYGRZxSiSWlqcm55bbKhXnJhbXJqXrpecn7uJERjv24793LyD8dLG4EOMAhyMSjy8
        J7riYoVYE8uKK3MPMUpwMCuJ8JZNBArxpiRWVqUW5ccXleakFh9iNAX6bSKzlGhyPjAV5ZXE
        G5oamltYGpobmxubWSiJ83YIHIwREkhPLEnNTk0tSC2C6WPi4JRqYGxP6Zzh+r7CeG7FGy8/
        HtNJ/F43BRZ2RWzYuuXZ0ZY193/feX86UO8w91bBw2KpHJNSN8fdDBD7xu9VcI3rY20os3Wi
        mNG3junbLdNLY6Yder4x29dbZrJ92+Ge47s2LeJb8jC13/UX23eHMIEyr5M1E565OnyQ4NzC
        3PTWel0l0/87IiUp3UosxRmJhlrMRcWJAKyumBoNAwAA
X-CMS-MailID: 20190822163016eucas1p126fb54c2234bdd541cfb0b4e41bb5684
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
        <cbf7c51b-9ce7-6ef6-32c4-981258d4af4c@samsung.com>
        <CALDO+SaRNMvmXrQqOtNiRsOkgfOQAW4EA2yVgmeoGQto2zvfMQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.08.2019 19:07, William Tu wrote:
> On Thu, Aug 22, 2019 at 1:17 AM Ilya Maximets <i.maximets@samsung.com> wrote:
>>
>> On 22.08.2019 0:38, William Tu wrote:
>>> On Wed, Aug 21, 2019 at 9:57 AM Alexander Duyck
>>> <alexander.duyck@gmail.com> wrote:
>>>>
>>>> On Wed, Aug 21, 2019 at 9:22 AM Ilya Maximets <i.maximets@samsung.com> wrote:
>>>>>
>>>>> On 21.08.2019 4:17, Alexander Duyck wrote:
>>>>>> On Tue, Aug 20, 2019 at 8:58 AM Ilya Maximets <i.maximets@samsung.com> wrote:
>>>>>>>
>>>>>>> On 20.08.2019 18:35, Alexander Duyck wrote:
>>>>>>>> On Tue, Aug 20, 2019 at 8:18 AM Ilya Maximets <i.maximets@samsung.com> wrote:
>>>>>>>>>
>>>>>>>>> Tx code doesn't clear the descriptor status after cleaning.
>>>>>>>>> So, if the budget is larger than number of used elems in a ring, some
>>>>>>>>> descriptors will be accounted twice and xsk_umem_complete_tx will move
>>>>>>>>> prod_tail far beyond the prod_head breaking the comletion queue ring.
>>>>>>>>>
>>>>>>>>> Fix that by limiting the number of descriptors to clean by the number
>>>>>>>>> of used descriptors in the tx ring.
>>>>>>>>>
>>>>>>>>> Fixes: 8221c5eba8c1 ("ixgbe: add AF_XDP zero-copy Tx support")
>>>>>>>>> Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
>>>>>>>>
>>>>>>>> I'm not sure this is the best way to go. My preference would be to
>>>>>>>> have something in the ring that would prevent us from racing which I
>>>>>>>> don't think this really addresses. I am pretty sure this code is safe
>>>>>>>> on x86 but I would be worried about weak ordered systems such as
>>>>>>>> PowerPC.
>>>>>>>>
>>>>>>>> It might make sense to look at adding the eop_desc logic like we have
>>>>>>>> in the regular path with a proper barrier before we write it and after
>>>>>>>> we read it. So for example we could hold of on writing the bytecount
>>>>>>>> value until the end of an iteration and call smp_wmb before we write
>>>>>>>> it. Then on the cleanup we could read it and if it is non-zero we take
>>>>>>>> an smp_rmb before proceeding further to process the Tx descriptor and
>>>>>>>> clearing the value. Otherwise this code is going to just keep popping
>>>>>>>> up with issues.
>>>>>>>
>>>>>>> But, unlike regular case, xdp zero-copy xmit and clean for particular
>>>>>>> tx ring always happens in the same NAPI context and even on the same
>>>>>>> CPU core.
>>>>>>>
>>>>>>> I saw the 'eop_desc' manipulations in regular case and yes, we could
>>>>>>> use 'next_to_watch' field just as a flag of descriptor existence,
>>>>>>> but it seems unnecessarily complicated. Am I missing something?
>>>>>>>
>>>>>>
>>>>>> So is it always in the same NAPI context?. I forgot, I was thinking
>>>>>> that somehow the socket could possibly make use of XDP for transmit.
>>>>>
>>>>> AF_XDP socket only triggers tx interrupt on ndo_xsk_async_xmit() which
>>>>> is used in zero-copy mode. Real xmit happens inside
>>>>> ixgbe_poll()
>>>>>  -> ixgbe_clean_xdp_tx_irq()
>>>>>     -> ixgbe_xmit_zc()
>>>>>
>>>>> This should be not possible to bound another XDP socket to the same netdev
>>>>> queue.
>>>>>
>>>>> It also possible to xmit frames in xdp_ring while performing XDP_TX/REDIRECT
>>>>> actions. REDIRECT could happen from different netdev with different NAPI
>>>>> context, but this operation is bound to specific CPU core and each core has
>>>>> its own xdp_ring.
>>>>>
>>>>> However, I'm not an expert here.
>>>>> Björn, maybe you could comment on this?
>>>>>
>>>>>>
>>>>>> As far as the logic to use I would be good with just using a value you
>>>>>> are already setting such as the bytecount value. All that would need
>>>>>> to happen is to guarantee that the value is cleared in the Tx path. So
>>>>>> if you clear the bytecount in ixgbe_clean_xdp_tx_irq you could
>>>>>> theoretically just use that as well to flag that a descriptor has been
>>>>>> populated and is ready to be cleaned. Assuming the logic about this
>>>>>> all being in the same NAPI context anyway you wouldn't need to mess
>>>>>> with the barrier stuff I mentioned before.
>>>>>
>>>>> Checking the number of used descs, i.e. next_to_use - next_to_clean,
>>>>> makes iteration in this function logically equal to the iteration inside
>>>>> 'ixgbe_xsk_clean_tx_ring()'. Do you think we need to change the later
>>>>> function too to follow same 'bytecount' approach? I don't like having
>>>>> two different ways to determine number of used descriptors in the same file.
>>>>>
>>>>> Best regards, Ilya Maximets.
>>>>
>>>> As far as ixgbe_clean_xdp_tx_irq() vs ixgbe_xsk_clean_tx_ring(), I
>>>> would say that if you got rid of budget and framed things more like
>>>> how ixgbe_xsk_clean_tx_ring was framed with the ntc != ntu being
>>>> obvious I would prefer to see us go that route.
>>>>
>>>> Really there is no need for budget in ixgbe_clean_xdp_tx_irq() if you
>>>> are going to be working with a static ntu value since you will only
>>>> ever process one iteration through the ring anyway. It might make more
>>>> sense if you just went through and got rid of budget and i, and
>>>> instead used ntc and ntu like what was done in
>>>> ixgbe_xsk_clean_tx_ring().
>>>>
>>>> Thanks.
>>>>
>>>> - Alex
>>>
>>> Not familiar with the driver details.
>>> I tested this patch and the issue mentioned in OVS mailing list.
>>> https://www.mail-archive.com/ovs-dev@openvswitch.org/msg35362.html
>>> and indeed the problem goes away.
>>
>> Good. Thanks for testing!
>>
>>> But I saw a huge performance drop,
>>> my AF_XDP tx performance drops from >9Mpps to <5Mpps.
>>
>> I didn't expect so big performance difference with this change.
>> What is your test scenario?
> 
> I was using OVS with dual port NIC, setting one OpenFlow rule
> in_port=eth2 actions=output:eth3
> and eth2 for rx and measure eth3 tx
> 'sar -n DEV 1'  shows pretty huge drop on eth3 tx.

'sar' just parses net procfs to obtain interface stats, but interface stats
are not correct due to this bug (same packets accounted several times).

> 
>> Is it possible that you're accounting same
>> packet several times due to broken completion queue?
> 
> That's possible.
> Let me double check on your v2 patch.
> 
> @Eelco: do you also see some performance difference?
> 
> Regards,
> William
> 
>>
>> Looking at samples/bpf/xdpsock_user.c:complete_tx_only(), it accounts
>> sent packets (tx_npkts) by accumulating results of xsk_ring_cons__peek()
>> for completion queue, so it's not a trusted source of pps information.
>>
>> Best regards, Ilya Maximets.
>>
>>>
>>> Tested using kernel 5.3.0-rc3+
>>> 03:00.0 Ethernet controller: Intel Corporation Ethernet Controller
>>> 10-Gigabit X540-AT2 (rev 01)
>>> Subsystem: Intel Corporation Ethernet 10G 2P X540-t Adapter
>>> Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
>>> Stepping- SERR- FastB2B- DisINTx+
>>>
>>> Regards,
>>> William
> 
> 
