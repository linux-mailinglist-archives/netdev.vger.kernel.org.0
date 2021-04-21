Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64513669A2
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 13:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238033AbhDULEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 07:04:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39827 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235098AbhDULEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 07:04:48 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210421110413epoutp0347522fe70db338648a72a8d160574af7~32rLxP6n72790027900epoutp03t
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 11:04:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210421110413epoutp0347522fe70db338648a72a8d160574af7~32rLxP6n72790027900epoutp03t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1619003053;
        bh=8Pq01BUL483TdsKHZV5pnNgvP6mfHqYqv7FHmyuUiiQ=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=kv1V0ji5Rz4GEtJyRQ5ejiSA4VmKoFKy4h62RixQAphjU1dnWUb21jTjROD6jywxm
         33GBL8MAnsKLE3GCPx+9scoUJPSMAJ/QU4tmHFUYjIU4gbYwIzSVIdElCVrNYGvkgM
         C2O0G+FXDnI4qoxnkXrS4AzoKqwRc2gDfhGvF7rY=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210421110411epcas2p15e6246a2bd917e712a24c9092df2e694~32rKsC0Iw1652016520epcas2p1Y;
        Wed, 21 Apr 2021 11:04:11 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.182]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4FQHk20Cfyz4x9Pw; Wed, 21 Apr
        2021 11:04:10 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        C3.39.09604.9A600806; Wed, 21 Apr 2021 20:04:09 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210421110409epcas2p43e7c9363550eb5863d5e4bd7273b513f~32rIOi2O41814118141epcas2p4t;
        Wed, 21 Apr 2021 11:04:09 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210421110409epsmtrp2d9663df72dc7c58eec50b6e81221ea37~32rIMspOa0461904619epsmtrp2u;
        Wed, 21 Apr 2021 11:04:09 +0000 (GMT)
X-AuditID: b6c32a45-db3ff70000002584-20-608006a9c25d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        94.FE.08163.9A600806; Wed, 21 Apr 2021 20:04:09 +0900 (KST)
Received: from KORDO035731 (unknown [12.36.185.47]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210421110408epsmtip2c8b749fdf5823a8cf33535cdc019b82f~32rH5IJD32284722847epsmtip2F;
        Wed, 21 Apr 2021 11:04:08 +0000 (GMT)
From:   "Dongseok Yi" <dseok.yi@samsung.com>
To:     "'Yunsheng Lin'" <linyunsheng@huawei.com>,
        "'Willem de Bruijn'" <willemdebruijn.kernel@gmail.com>
Cc:     "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>,
        "'Miaohe Lin'" <linmiaohe@huawei.com>,
        "'Willem de Bruijn'" <willemb@google.com>,
        "'Paolo Abeni'" <pabeni@redhat.com>,
        "'Florian Westphal'" <fw@strlen.de>,
        "'Al Viro'" <viro@zeniv.linux.org.uk>,
        "'Guillaume Nault'" <gnault@redhat.com>,
        "'Steffen Klassert'" <steffen.klassert@secunet.com>,
        "'Yadu Kishore'" <kyk.segfault@gmail.com>,
        "'Marco Elver'" <elver@google.com>,
        "'Network Development'" <netdev@vger.kernel.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>, <namkyu78.kim@samsung.com>
In-Reply-To: <e84b4a2b-a009-7c8c-c6c7-57f82ab74a59@huawei.com>
Subject: RE: [PATCH net] net: fix use-after-free when UDP GRO with shared
 fraglist
Date:   Wed, 21 Apr 2021 20:04:08 +0900
Message-ID: <077f01d7369e$0d8a2950$289e7bf0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQGzSLyD0IId2D3HDIYy/7dNsmGIiACENc+NAWJEhNECbm6XgQEwXpGRAhEW9qYB/HcCxwICNbhPARtp2fuqoRVOgA==
X-Brightmail-Tracker: H4sIAAAAAAAAA01TbUxTVxje6b29vdSUXQvDE+ZcvYYYSMAWLTswUMIY3k3nmGOJW9T2Bu6g
        rl+2YNQ4VyciIKD1I4NSkDk+IjI+KimIgRjajSA1aNgYMLbFBYcK1Y0qlh/qaC/L+Pe873me
        5z3P+SAx6a9EJKnR53MmPaulCTHudEWj2MuERS0vH1Ui+3Ahjoo8XULkLL8CUOVchwjddlYI
        UavzEkAlzxpwNNJjJ5DFK0aWyeME+rEuAs0PzQJ0vcQvQsPPB4ToUadbhL5baBekUkzn5XEB
        c832m4ipcxQwhW6vkHE0lxDM476fCaaisxkwjhP1Qqb/WZ2Q8TnWMI4pryBzxWfa5DyOzeFM
        Mk6fbcjR6HNT6G0fq95RKRPkilhFInqLlulZHZdCp2/PjM3QaBfj0LIDrLZgsZXJms30hs3J
        JkNBPifLM5jzU2jOmKM1KhTGODOrMxfoc+OyDbokhVwer1xkqrV5l6YWCGMDe9Bd/wthAXMZ
        pSCEhNQm2DjRAUqBmJRS3QB6eiqXijkAiy5OE3zhA3C+YVRUCsig5NZCakAtpXoALL1h4vF9
        AC9c4AKYoGLgrO2kMIDDqVxYU+gKmmLUTRx6Zvx4YCGE2gzHbzwhAjiMyoJdrR4s4I9TUXBg
        8MNAW0IlwhaPH+PxSjhYNRWUYtSbsMtrx/gEMrhwr1HI98NhdUlR0Cac2gdvPg0NjIXU8RDY
        7vse8Px0OOv7fQmHwYcDnSIeR0Lfo16Cj/gVPHFqN68tA/CnPn4upDZC218nQYCDUdGwrWcD
        T18H3RNLOwuFxa7nSwclgcVFUh7S0PpExXtAeH/wHH4G0LZlsWzLYtmWRbH9P6oO4M0ggjOa
        dbmcOd6oWH7PDhB85THvdoNz3r/j+oGABP0AkhgdLvnjyyNqqSSHPXSYMxlUpgItZ+4HysVz
        tmKRr2UbFr+JPl+lUMYnJMgTlUiZEI/oVZIF7qhaSuWy+dwXHGfkTP/pBGRIpEXw9kzT+7fb
        bHvuTH9DQ/2fD10breLG9LKBVytCJTWW07Hn21GML2Hy2A73AfdMY1lqE17kxZpad7du1ZgE
        lXePvtFmHzv88hPv1aqhtOn5p3fpent12vjOvjuq9t7obDux/ZhzzarusL1R+xj/kRXnR14v
        3/KtUSR+cXZilwf0f5CRBcm4vZ9vWU9ewVos1uQ0/FBHx+AtTfGeF/tn8bXOTw+unh77mm2z
        Jj0Q69TtJH1v11TtmMOlrE2yrY6ajHg5VDsW1rtVHvmR7JUd67a5slpE+1vb/OtrHmh0ZOXo
        tZ1zw7Gnatdef++HoU3/NFadSaueOVsY8rjvapV/pAR2TXpo3JzHKmIwk5n9FzW2rPBuBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsWy7bCSvO5KtoYEg2NbOS3mnG9hsWg7s53V
        YlvvakaLGZ82sltc2NbHarFu2yJGi87vS1ksLu+aw2bR8JbLouFOM5vFsQViFt9Ov2G02N35
        g93i/N/jrBbvthxht1j8cwOTg4DHlpU3mTx2zrrL7rFgU6lHy5G3rB6bVnWyebzfd5XNo2/L
        KkaPTa1LWD0OfV/A6vF5k5zHpidvmQK4o7hsUlJzMstSi/TtErgyFj35yVawNLHiyJLrbA2M
        n9y6GDk4JARMJM7+dOhi5OQQEtjBKHH8FwtEWEJi12ZXkLCEgLDE/ZYjrF2MXEAlzxglfmx5
        yQaSYBPQkngzq50VxBYRSJe48vcpO0gRs8AVFomtDUeZITr6WSQe7T4I1sEpYCdx88AXMFtY
        IEhi/40NbCDbWARUJY6f9AcJ8wpYSqw584MZwhaUODnzCQuIzSygLdH7sJURwpaX2P52DjPE
        dQoSP58uY4WIi0jM7mxjBhkpIpAlceor3wRG4VlIJs1CMmkWkkmzkHQvYGRZxSiZWlCcm55b
        bFhglJdarlecmFtcmpeul5yfu4kRHNlaWjsY96z6oHeIkYmD8RCjBAezkgjv/dqaBCHelMTK
        qtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJpCeWpGanphakFsFkmTg4pRqYmIP/B+R9fxKUwMBy
        +R+X/SKfZDaxmkl8Sh81lxTY3TvNb5hWUnc0pCh/klbv/MA5gqUebwp5fyXZ1NtsEszz446R
        b7/T3biO3SaCY31DyedNOy7IJMg7sfjVpyWGpqusP6Gyv7o/jq8kR/x0jtnbh9qLJrEyd5Tn
        hbCVVpbxZFj/j+ON/XNM5PuWiZKrnvqvtf9i6Hi/+dWS4jlSjc9MAzm3cNvMzp+0M2Tt1dbj
        e6f+fhDP3jeltGiC0+u20yaTm3b5Sx/UWuyivKKM/Y2MzZ5D6+fcWnqY6dP3LB938dvHeVMj
        N78Tu1Nj45EftLWR4V1j+Wobl6Dmcs2ePK85Rwvdf6x1fjgpI8k3Q4mlOCPRUIu5qDgRAP1m
        mSdbAwAA
X-CMS-MailID: 20210421110409epcas2p43e7c9363550eb5863d5e4bd7273b513f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210104085750epcas2p1a5b22559d87df61ef3c8215ae0b470b5
References: <CGME20210104085750epcas2p1a5b22559d87df61ef3c8215ae0b470b5@epcas2p1.samsung.com>
        <1609750005-115609-1-git-send-email-dseok.yi@samsung.com>
        <CAF=yD-+bDdYg7X+WpP14w3fbv+JewySpdCbjdwWXB-syCwQ9uQ@mail.gmail.com>
        <017f01d6e3cb$698246a0$3c86d3e0$@samsung.com>
        <CAF=yD-Lg92JdpCU8CEQnutzi4VyS67_VNfAniRU=RxDvfYMruw@mail.gmail.com>
        <019b01d6e3dc$9a940330$cfbc0990$@samsung.com>
        <18999f48-7dc8-e859-8629-3b5cab764faa@huawei.com>
        <04f601d734b3$f5ca86c0$e15f9440$@samsung.com>
        <e84b4a2b-a009-7c8c-c6c7-57f82ab74a59@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 05:42:12PM +0800, Yunsheng Lin wrote:
> On 2021/4/19 8:35, Dongseok Yi wrote:
> > On Sat, Apr 17, 2021 at 11:44:35AM +0800, Yunsheng Lin wrote:
> >>
> >> On 2021/1/6 11:32, Dongseok Yi wrote:
> >>> On 2021-01-06 12:07, Willem de Bruijn wrote:
> >>>>
> >>>> On Tue, Jan 5, 2021 at 8:29 PM Dongseok Yi <dseok.yi@samsung.com> wrote:
> >>>>>
> >>>>> On 2021-01-05 06:03, Willem de Bruijn wrote:
> >>>>>>
> >>>>>> On Mon, Jan 4, 2021 at 4:00 AM Dongseok Yi <dseok.yi@samsung.com> wrote:
> >>>>>>>
> >>>>>>> skbs in frag_list could be shared by pskb_expand_head() from BPF.
> >>>>>>
> >>>>>> Can you elaborate on the BPF connection?
> >>>>>
> >>>>> With the following registered ptypes,
> >>>>>
> >>>>> /proc/net # cat ptype
> >>>>> Type Device      Function
> >>>>> ALL           tpacket_rcv
> >>>>> 0800          ip_rcv.cfi_jt
> >>>>> 0011          llc_rcv.cfi_jt
> >>>>> 0004          llc_rcv.cfi_jt
> >>>>> 0806          arp_rcv
> >>>>> 86dd          ipv6_rcv.cfi_jt
> >>>>>
> >>>>> BPF checks skb_ensure_writable between tpacket_rcv and ip_rcv
> >>>>> (or ipv6_rcv). And it calls pskb_expand_head.
> >>>>>
> >>>>> [  132.051228] pskb_expand_head+0x360/0x378
> >>>>> [  132.051237] skb_ensure_writable+0xa0/0xc4
> >>>>> [  132.051249] bpf_skb_pull_data+0x28/0x60
> >>>>> [  132.051262] bpf_prog_331d69c77ea5e964_schedcls_ingres+0x5f4/0x1000
> >>>>> [  132.051273] cls_bpf_classify+0x254/0x348
> >>>>> [  132.051284] tcf_classify+0xa4/0x180
> >>>>
> >>>> Ah, you have a BPF program loaded at TC. That was not entirely obvious.
> >>>>
> >>>> This program gets called after packet sockets with ptype_all, before
> >>>> those with a specific protocol.
> >>>>
> >>>> Tcpdump will have inserted a program with ptype_all, which cloned the
> >>>> skb. This triggers skb_ensure_writable -> pskb_expand_head ->
> >>>> skb_clone_fraglist -> skb_get.
> >>>>
> >>>>> [  132.051294] __netif_receive_skb_core+0x590/0xd28
> >>>>> [  132.051303] __netif_receive_skb+0x50/0x17c
> >>>>> [  132.051312] process_backlog+0x15c/0x1b8
> >>>>>
> >>>>>>
> >>>>>>> While tcpdump, sk_receive_queue of PF_PACKET has the original frag_list.
> >>>>>>> But the same frag_list is queued to PF_INET (or PF_INET6) as the fraglist
> >>>>>>> chain made by skb_segment_list().
> >>>>>>>
> >>>>>>> If the new skb (not frag_list) is queued to one of the sk_receive_queue,
> >>>>>>> multiple ptypes can see this. The skb could be released by ptypes and
> >>>>>>> it causes use-after-free.
> >>>>>>
> >>>>>> If I understand correctly, a udp-gro-list skb makes it up the receive
> >>>>>> path with one or more active packet sockets.
> >>>>>>
> >>>>>> The packet socket will call skb_clone after accepting the filter. This
> >>>>>> replaces the head_skb, but shares the skb_shinfo and thus frag_list.
> >>>>>>
> >>>>>> udp_rcv_segment later converts the udp-gro-list skb to a list of
> >>>>>> regular packets to pass these one-by-one to udp_queue_rcv_one_skb.
> >>>>>> Now all the frags are fully fledged packets, with headers pushed
> >>>>>> before the payload. This does not change their refcount anymore than
> >>>>>> the skb_clone in pf_packet did. This should be 1.
> >>>>>>
> >>>>>> Eventually udp_recvmsg will call skb_consume_udp on each packet.
> >>>>>>
> >>>>>> The packet socket eventually also frees its cloned head_skb, which triggers
> >>>>>>
> >>>>>>   kfree_skb_list(shinfo->frag_list)
> >>>>>>     kfree_skb
> >>>>>>       skb_unref
> >>>>>>         refcount_dec_and_test(&skb->users)
> >>>>>
> >>>>> Every your understanding is right, but
> >>>>>
> >>>>>>
> >>>>>>>
> >>>>>>> [ 4443.426215] ------------[ cut here ]------------
> >>>>>>> [ 4443.426222] refcount_t: underflow; use-after-free.
> >>>>>>> [ 4443.426291] WARNING: CPU: 7 PID: 28161 at lib/refcount.c:190
> >>>>>>> refcount_dec_and_test_checked+0xa4/0xc8
> >>>>>>> [ 4443.426726] pstate: 60400005 (nZCv daif +PAN -UAO)
> >>>>>>> [ 4443.426732] pc : refcount_dec_and_test_checked+0xa4/0xc8
> >>>>>>> [ 4443.426737] lr : refcount_dec_and_test_checked+0xa0/0xc8
> >>>>>>> [ 4443.426808] Call trace:
> >>>>>>> [ 4443.426813]  refcount_dec_and_test_checked+0xa4/0xc8
> >>>>>>> [ 4443.426823]  skb_release_data+0x144/0x264
> >>>>>>> [ 4443.426828]  kfree_skb+0x58/0xc4
> >>>>>>> [ 4443.426832]  skb_queue_purge+0x64/0x9c
> >>>>>>> [ 4443.426844]  packet_set_ring+0x5f0/0x820
> >>>>>>> [ 4443.426849]  packet_setsockopt+0x5a4/0xcd0
> >>>>>>> [ 4443.426853]  __sys_setsockopt+0x188/0x278
> >>>>>>> [ 4443.426858]  __arm64_sys_setsockopt+0x28/0x38
> >>>>>>> [ 4443.426869]  el0_svc_common+0xf0/0x1d0
> >>>>>>> [ 4443.426873]  el0_svc_handler+0x74/0x98
> >>>>>>> [ 4443.426880]  el0_svc+0x8/0xc
> >>>>>>>
> >>>>>>> Fixes: 3a1296a38d0c (net: Support GRO/GSO fraglist chaining.)
> >>>>>>> Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
> >>>>>>> ---
> >>>>>>>  net/core/skbuff.c | 20 +++++++++++++++++++-
> >>>>>>>  1 file changed, 19 insertions(+), 1 deletion(-)
> >>>>>>>
> >>>>>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> >>>>>>> index f62cae3..1dcbda8 100644
> >>>>>>> --- a/net/core/skbuff.c
> >>>>>>> +++ b/net/core/skbuff.c
> >>>>>>> @@ -3655,7 +3655,8 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
> >>>>>>>         unsigned int delta_truesize = 0;
> >>>>>>>         unsigned int delta_len = 0;
> >>>>>>>         struct sk_buff *tail = NULL;
> >>>>>>> -       struct sk_buff *nskb;
> >>>>>>> +       struct sk_buff *nskb, *tmp;
> >>>>>>> +       int err;
> >>>>>>>
> >>>>>>>         skb_push(skb, -skb_network_offset(skb) + offset);
> >>>>>>>
> >>>>>>> @@ -3665,11 +3666,28 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
> >>>>>>>                 nskb = list_skb;
> >>>>>>>                 list_skb = list_skb->next;
> >>>>>>>
> >>>>>>> +               err = 0;
> >>>>>>> +               if (skb_shared(nskb)) {
> >>>>>>
> >>>>>> I must be missing something still. This does not square with my
> >>>>>> understanding that the two sockets are operating on clones, with each
> >>>>>> frag_list skb having skb->users == 1.
> >>>>>>
> >>>>>> Unless the packet socket patch previously also triggered an
> >>>>>> skb_unclone/pskb_expand_head, as that call skb_clone_fraglist, which
> >>>>>> calls skb_get on each frag_list skb.
> >>>>>
> >>>>> A cloned skb after tpacket_rcv cannot go through skb_ensure_writable
> >>>>> with the original shinfo. pskb_expand_head reallocates the shinfo of
> >>>>> the skb and call skb_clone_fraglist. skb_release_data in
> >>>>> pskb_expand_head could not reduce skb->users of the each frag_list skb
> >>>>> if skb_shinfo(skb)->dataref == 2.
> >>>>>
> >>>>> After the reallocation, skb_shinfo(skb)->dataref == 1 but each frag_list
> >>>>> skb could have skb->users == 2.
> >>
> >> Hi, Dongseok
> >>    I understand there is liner head data shared between the frag_list skb in the
> >> cloned skb(cloned by pf_packet?) and original skb, which should not be shared
> >> when skb_segment_list() converts the frag_list skb into regular packet.
> >>
> >>    But both skb->users of original and cloned skb is one(skb_shinfo(skb)->dataref
> >> is one for both skb too), and skb->users of each fraglist skb is two because both
> >> original and cloned skb is linking to the same fraglist pointer, and there is
> >> "skb_shinfo(skb)->frag_list = NULL" for original skb in the begin of skb_segment_list(),
> >> if kfree_skb() is called with original skb, the fraglist skb will not be freed.
> >> If kfree_skb is called with original skb,cloned skb and each fraglist skb here, the
> >> reference counter for three of them seem right here, so why is there a refcount_t
> >> warning in the commit log? am I missing something obvious here?
> >>
> >> Sorry for bringing up this thread again.
> >
> > A skb which detects use-after-free was not a part of frag_list. Please
> > check the commit msg once again.
> 
> I checked the commit msg again, but still have not figured it out yet:)
> 
> So I tried to see if I understand the skb'reference counting correctly:
> 
> skb->user is used to reference counting the "struct sk_buff", and
> skb_shinfo(skb)->dataref is used to reference counting head data.
> 
> skb_clone(): allocate a sperate "struct sk_buff" but share the head data
>              with the original skb, so skb_shinfo()->dataref need
>              incrmenting.
> 
> pskb_expand_head(): allocate a sperate head data(which includes the space
>                     for skb_shinfo(skb)), since the original head data
> 		    and the new head data' skb_shinfo()->frag_list both
>                     point to the same fraglist skb, so each fraglist_skb's
> 		    skb->users need incrmenting, and original head data's
> 		    skb_shinfo() need decrmenting.
> 
> 
> So after pf_packet called skb_clone() and pskb_expand_head(), we have:
> 
>     old skb              new skb
>       |                     |
>       |                     |
> old head data         new head data
>         \                   /
>           \                /
>            \              /
>              \           /
>               \         /
>              fraglist_skb1 -> fraglist_skb2 -> fraglist_skb3 .....
> 
> So both old and new skb' skb->user is one, both old and new head data's
> skb_shinfo()->dataref is one, and both old and new head data'
> skb_shinfo()->frag_list points to fraglist_skb1, and each fraglist_skb's
> skb->user is two.
> 
> Each fraglist_skb points to a head data, and its skb_shinfo()->dataref
> is one too.
> 
> Suppose old skb is called with skb_segment_list(), without this patch,
> we have:
> 
>                          new skb
>                             |
>                             |
>                      new head data
>                             /
>                            /
>                           /
>                          /
>                         /
>        old skb -> fraglist_skb1 -> fraglist_skb2 -> fraglist_skb3 .....
>           |
>           |
>     old head data
> 
> And old skb and each fraglist_skb become a regular packet, so freeing
> the old skb, new skb and each fraglist_skb here do not seems to have
> any reference counting problem, because each fraglist_skb's skb->user
> is two, right?
> 
> >
> > Both sk_receive_queue of PF_PACKET and PF_INET (or PF_INET6) can have
> > a link for the same frag_skbs chain.
> 
> Does "frag_skbs chain" means fraglist_skb1? It seems only new head data's
> skb_shinfo()->frag_list points to fraglist_skb1

Yes, right.

> 
> 
> If a new skb (*not frags*) is
> > queued to one of the sk_receive_queue, multiple ptypes can see and
> > release this. It causes use-after-free.
> 
> Does "a new skb" mean each fraglist_skb after skb_segment_list()? Or other
> new incoming skb?

I mean a new incoming skb.

> 
> I am not so familiar with the PF_PACKET and PF_INET, so still have hard
> time figuring how the reference counting goes wrong here:)

Let's assume a new incoming skb that is added to the next of the last
fraglist_skb. The new incoming skb->user is *one*.

                         new skb
                            |
                            |
                     new head data
                            /
                           /
                          /
                         /
                        /
       old skb -> fraglist_skb1 -> fraglist_skb2 -> ... -> new incoming skb
          |
          |
    old head data

Let's skb_queue_purge from old skb. kfree_skb from old skb will free
2 skbs (marked as xxx1 and xxx2). What happened if kfree_skb(new skb)?

                         new skb
                            |
                            |
                     new head data
                            /
                           /
                          /
                         /
                        /
          xxx1 -> fraglist_skb1 -> fraglist_skb2 -> ... -> xxx2

It will try to free xxx2.

> 
> >
> >>
> >>>>
> >>>> Yes, that makes sense. skb_clone_fraglist just increments the
> >>>> frag_list skb's refcounts.
> >>>>
> >>>> skb_segment_list must create an unshared struct sk_buff before it
> >>>> changes skb data to insert the protocol headers.
> >>>>
> >
> >
> >
> > .
> >


