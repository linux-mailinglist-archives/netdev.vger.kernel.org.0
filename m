Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE21AC3883
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 17:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389310AbfJAPFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 11:05:33 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:39836 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731893AbfJAPFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 11:05:32 -0400
Received: by mail-io1-f68.google.com with SMTP id a1so48818919ioc.6
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 08:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kLi6B3R2AUi8onxaQeKwL7H33ILwFfoGZLnRyFZt4Xg=;
        b=edqlzy9xl1zwe86yXPrSbgosya3QL7tvhhopOYG4PoN+ziyQcU0jAYca1DZR4+KT7b
         ITgxpgbKfurhWwUIaJ9xM2FfDscfzSaceC5RBwAIHhhn0rChgE6WRkxrZGuy9VMSnFw5
         332DFC+ngtaDBDCR2HiOV47HPUZrjEgvNowYmaUprz1l5y0EexJIEWugqJu0eyaAZ8kO
         H8gD4bV2SNC1GqnvT38gJAUxgYQGhyStwu4IzU7NF5ltK9vsOixIe23qBrxVJUl5RJgF
         iFfmciXh3Xjvbl/jAECBZyKN9PQ+iHIClXfeVlNPZz0MXkhSEK6R2YDD3/tMRswTwpAX
         fsTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kLi6B3R2AUi8onxaQeKwL7H33ILwFfoGZLnRyFZt4Xg=;
        b=gnYI0sTpNNfUsdCujkfwGZfATavSS/HmLRc7WpUZ8XOVl2lCJgp72MIhS7/eiz6nTu
         mZ3IYLlrpSDGR6XM5VMwZ9WrbRamA9Us3j+UfErW/ubSWSrPn0h26Uouk99qwk528a3m
         VHHMkyF7sV6wwC8Gy6Ma6ji9w3gvMAn85YCqTx0DKXRkiXJ7pwoOFNojV3niTmrn8WFN
         LGGlcYOwcoHN+L0wQyfzic8zhbblfNLSnyQMIvw/yDsgmzBACMxuX54T1w3kqSxK5UTY
         lAcNP+JYrr6Xvthq1jtO8L0x5+G0IySPcES+dtcrhDzNsRuR1PXwf2ddeFPLHm+e/HZv
         qiUg==
X-Gm-Message-State: APjAAAUjfllt8C8vxV2LyNgky5YpvnTqPHBOIp6eFDKVJDduBEf71Xb6
        JnHGZ2LKNZNZYBv3Fdyo/Nm8ib/K4GdAs8uNBSQFAw==
X-Google-Smtp-Source: APXvYqweUInoR72met3ZYN1Gz0sitz4PHRNXa5AFwrJ+ZICfQlTjI8umTUnZXVSYM4Qx8BNDPDi9pKxSTnq7ezNQ8g8=
X-Received: by 2002:a6b:720a:: with SMTP id n10mr3571942ioc.64.1569942331909;
 Tue, 01 Oct 2019 08:05:31 -0700 (PDT)
MIME-Version: 1.0
References: <1569881518-21885-1-git-send-email-johunt@akamai.com>
 <1569881518-21885-2-git-send-email-johunt@akamai.com> <CAKgT0UfXYHDiz7uf51araHXTizRQpQgi8tDqNp6nX2YzeOoZ3A@mail.gmail.com>
 <5ba4beb7-2ad5-476a-403b-c37f6c761e08@akamai.com>
In-Reply-To: <5ba4beb7-2ad5-476a-403b-c37f6c761e08@akamai.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 1 Oct 2019 08:05:20 -0700
Message-ID: <CAKgT0UfN+OPPvkAwO5LuOjC3GZFghk459eCGu-o1GQAKAPMuJw@mail.gmail.com>
Subject: Re: [PATCH 2/2] udp: only do GSO if # of segs > 1
To:     Josh Hunt <johunt@akamai.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 1, 2019 at 7:36 AM Josh Hunt <johunt@akamai.com> wrote:
>
>
>
> On 9/30/19 4:56 PM, Alexander Duyck wrote:
> > On Mon, Sep 30, 2019 at 3:13 PM Josh Hunt <johunt@akamai.com> wrote:
> >>
> >> Prior to this change an application sending <= 1MSS worth of data and
> >> enabling UDP GSO would fail if the system had SW GSO enabled, but the
> >> same send would succeed if HW GSO offload is enabled. In addition to this
> >> inconsistency the error in the SW GSO case does not get back to the
> >> application if sending out of a real device so the user is unaware of this
> >> failure.
> >>
> >> With this change we only perform GSO if the # of segments is > 1 even
> >> if the application has enabled segmentation. I've also updated the
> >> relevant udpgso selftests.
> >>
> >> Fixes: bec1f6f69736 ("udp: generate gso with UDP_SEGMENT")
> >> Signed-off-by: Josh Hunt <johunt@akamai.com>
> >> ---
> >>   net/ipv4/udp.c                       |  5 +++--
> >>   net/ipv6/udp.c                       |  5 +++--
> >>   tools/testing/selftests/net/udpgso.c | 16 ++++------------
> >>   3 files changed, 10 insertions(+), 16 deletions(-)
> >>
> >> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> >> index be98d0b8f014..ac0baf947560 100644
> >> --- a/net/ipv4/udp.c
> >> +++ b/net/ipv4/udp.c
> >> @@ -821,6 +821,7 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
> >>          int is_udplite = IS_UDPLITE(sk);
> >>          int offset = skb_transport_offset(skb);
> >>          int len = skb->len - offset;
> >> +       int datalen = len - sizeof(*uh);
> >>          __wsum csum = 0;
> >>
> >>          /*
> >> @@ -832,7 +833,7 @@ static int udp_send_skb(struct sk_buff *skb, struct flowi4 *fl4,
> >>          uh->len = htons(len);
> >>          uh->check = 0;
> >>
> >> -       if (cork->gso_size) {
> >> +       if (cork->gso_size && datalen > cork->gso_size) {
> >>                  const int hlen = skb_network_header_len(skb) +
> >>                                   sizeof(struct udphdr);
> >>
> >
> > So what about the datalen == cork->gso_size case? That would only
> > generate one segment wouldn't it?
> >
> > Shouldn't the test really be "datalen < cork->gso_size"? That should
> > be the only check you need since if gso_size is 0 this statement would
> > always fail anyway.
> >
> > Thanks.
> >
> > - Alex
> >
>
> Alex thanks for the review. The intent of the patch is to only use GSO
> when the # of segs > 1. The two cases you've mentioned are when the # of
> segs == 1. In those cases we don't want to set gso_size and treat this
> as a non-GSO case, skipping the if block. Let me know if I misunderstood
> your points or you'd like further clarification.
>
> Thanks!
> Josh

Your right. Somehow I got the logic backwards in my head.

Thanks.

- Alex
