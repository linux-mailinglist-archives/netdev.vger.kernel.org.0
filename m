Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AAC75B1D5E
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 14:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbiIHMlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 08:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbiIHMle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 08:41:34 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20E6E290B
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 05:41:24 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id t184so26231315yba.4
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 05:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=bPN+x0uxb4RSLvHLOBiYMUwqbNvQelYuhia5mFDYPZI=;
        b=VB93Noe8Rl+dAVe1vfjhQznF5UuUdwf92pGlb7OLXfh9Idi4piFlEfttHLe0VYM1nb
         2dMK9x7uicmhaVndyZSARDyS6qvZSxAgwrDAMJ/0NRTJEwuR9rHbLBWFgDbk2W2vT2m0
         OqYdmqmYrVkIJPzmLtu2gsDjWWBkxPiPz4uBTab4aSPF7HEm+8YCr6briEugCdWgc3nA
         m++MlHhULQB8GA0CotnOUbc1m8yjLrg1m4E3XryP6kCBjmZObn0N5SUesH6XRECPgMdK
         Ku7nfoAr/nnFAIibp4QFdj+PBXRO69KLW/kgzZ/5euskSYpiuvSRtIaY0C7NmTCTkpWA
         kp5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=bPN+x0uxb4RSLvHLOBiYMUwqbNvQelYuhia5mFDYPZI=;
        b=y2m9Fll4YXKvuN3He6mhmoi3Lx5U2bOQm3P3Z7yfxR6+nRUpoOXIVoWegpwBKPO67A
         uVqSVEfxs9ZnnwkzXLoIUhJRB4Op5VUaj6m3+nXfcvOoFIHp0i4DL+f0zPyHyV9Gt/X8
         teFaAZvuyoVmbAACGkpB/gd+ViPwzQAq4nWEDoOeo5iA10bsVJFXHPgEmQAceizsEo8f
         aazG7Tks6WibzPn//dUPe70vWDacNtfEo/UE77b6GPpNV6DmgV4MdVCpkL0K4s6AB40Y
         y2pEcDNzdEFHLnOMnEVRgGwTUVb8ddEqoczRMeA6lH8LWkZJ7H11znWUyI94MnLqaAja
         +BMg==
X-Gm-Message-State: ACgBeo26RO11oYFdMndvQszsj9FT1g8bVilLbY2eR10np08AZqWRShhP
        yieJxZAckEcKeeWasILkH4M/zCPHxYQs1ezY5vTnWw==
X-Google-Smtp-Source: AA6agR4a7rI+WDE3hKacWnXaq7Y45tItZy0joZxRK6Fm52RPV8eQvhQQUviSvrewr6/DtXuEljeIeYmBhefYZ79gQF0=
X-Received: by 2002:a5b:888:0:b0:6ad:480c:9b66 with SMTP id
 e8-20020a5b0888000000b006ad480c9b66mr5652141ybq.231.1662640883561; Thu, 08
 Sep 2022 05:41:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220907122505.26953-1-wintera@linux.ibm.com> <CANn89iLP15xQjmPHxvQBQ=bWbbVk4_41yLC8o5E97TQWFmRioQ@mail.gmail.com>
 <375efe42-910d-69ae-e48d-cff0298dd104@linux.ibm.com>
In-Reply-To: <375efe42-910d-69ae-e48d-cff0298dd104@linux.ibm.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 8 Sep 2022 05:41:12 -0700
Message-ID: <CANn89iKjxMMDEcOCKiqWiMybiYVd7ZqspnEkT0-puqxrknLtRA@mail.gmail.com>
Subject: Re: [RFC net] tcp: Fix performance regression for request-response workloads
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     Alexandra Winter <wintera@linux.ibm.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        netdev <netdev@vger.kernel.org>, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 8, 2022 at 2:40 AM Christian Borntraeger
<borntraeger@linux.ibm.com> wrote:
>
> Am 07.09.22 um 18:06 schrieb Eric Dumazet:
> > On Wed, Sep 7, 2022 at 5:26 AM Alexandra Winter <wintera@linux.ibm.com> wrote:
> >>
> >> Since linear payload was removed even for single small messages,
> >> an additional page is required and we are measuring performance impact.
> >>
> >> 3613b3dbd1ad ("tcp: prepare skbs for better sack shifting")
> >> explicitely allowed "payload in skb->head for first skb put in the queue,
> >> to not impact RPC workloads."
> >> 472c2e07eef0 ("tcp: add one skb cache for tx")
> >> made that obsolete and removed it.
> >> When
> >> d8b81175e412 ("tcp: remove sk_{tr}x_skb_cache")
> >> reverted it, this piece was not reverted and not added back in.
> >>
> >> When running uperf with a request-response pattern with 1k payload
> >> and 250 connections parallel, we measure 13% difference in throughput
> >> for our PCI based network interfaces since 472c2e07eef0.
> >> (our IO MMU is sensitive to the number of mapped pages)
> >
> >
> >
> >>
> >> Could you please consider allowing linear payload for the first
> >> skb in queue again? A patch proposal is appended below.
> >
> > No.
> >
> > Please add a work around in your driver.
> >
> > You can increase throughput by 20% by premapping a coherent piece of
> > memory in which
> > you can copy small skbs (skb->head included)
> >
> > Something like 256 bytes per slot in the TX ring.
> >
>
> FWIW this regression was withthe standard mellanox driver (nothing s390 specific).

I did not claim this was s390 specific.

Only IOMMU mode.

I would rather not add back something which makes TCP stack slower
(more tests in fast path)
for the majority of us _not_ using IOMMU.

In our own tests, this trick of using linear skbs was only helping
benchmarks, not real workloads.

Many drivers have to map skb->head a second time if they contain TCP payload,
thus adding yet another corner case in their fast path.

- Typical RPC workloads are playing with TCP_NODELAY
- Typical bulk flows never have empty write queues...

Really, I do not want this optimization back, this is not worth it.

Again, a driver knows better if it is using IOMMU and if pathological
layouts can be optimized
to non SG ones, and using a pre-dma-map zone will also benefit pure
TCP ACK packets (which do not have any payload)

Here is the changelog of a patch I did for our GQ NIC (not yet
upstreamed, but will be soon)

...
   The problem is coming from gq_tx_clean() calling
    dma_unmap_single(q->dev, p->addr, -p->len, DMA_TO_DEVICE);

    This seems silly to perform possibly expensive IOMMU operations to
send small packets.
    (TCP pure acks are 86 bytes long in total for 99% of the cases)

    Idea of this patch is to pre-dma-map a memory zone to hold the
headers of the
    packet (if less than 128/256 bytes long)

    Then if the whole packet can be copied into this 128/256 bytes
zone, just copy it
    entirely.

    This permits to consume the small packets right away in ndo_start_xmit()
    while the skb (and associated socket sk_wmem_alloc) is hot, instead of later
    at TX completion time.
    This makes ACK packets cost much smaller, but also tiny TCP
packets (say, synthetic benchmarks)

    We enable this behavior only if IOMMU is used/forced on GQ,
    although we might use it regardless of IOMMU being used or not.
...
    To recap, there is a huge difference if we cross the 42 byte limit
: (for a 128 bytes zone per TX ring slot)

    iroa21:/home/edumazet# ./super_netperf 200 -H iroa23 -t TCP_RR -l
20 -- -r40,40
    2648141
    iroa21:/home/edumazet# ./super_netperf 200 -H iroa23 -t TCP_RR -l
20 -- -r44,44
     970691

    We might experiment with bigger GQ_TX_INLINE_HEADER_SIZE in the future ?
   ...
