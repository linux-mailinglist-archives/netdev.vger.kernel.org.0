Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB5B432C4A7
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1450124AbhCDAPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:15:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389334AbhCCVhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 16:37:13 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D3EC061756
        for <netdev@vger.kernel.org>; Wed,  3 Mar 2021 13:36:05 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id k2so21989627ioh.5
        for <netdev@vger.kernel.org>; Wed, 03 Mar 2021 13:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nGmVks42vS+S7OW12Ssfu9opeTt4aGtiJwwc4G2Hx0s=;
        b=OKzoUJKEBpxj9wOVzNvRL0M9qmFGhCRmq6irrLysUcyetexbd8aLos3eNZv6xq4T68
         b41g12znP6CFCDULReZP5h0+cm/nso8B4OXm0wWhMsCp96OS0qWuSzzGS3YFdsdibeWi
         FdhSPWAf4NJuzQfXi/RsoYLtrHv+yRiIxuUf2heSJEod1JZ2EMYoGclBV2b0WTPEXxdW
         ZHFmpfgCK0jMFjoNkjDGsY2BZ6Dm2ueQ8ViWbw6jqitROoCSWIz3F2ps6eOcrVA55R99
         6G2cC/CPRczRMsbdRyaKqxEBYoWTtlc/36Ls/F+jMg5DpQHXP4zz4/tRN80efdgse3tg
         IIlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nGmVks42vS+S7OW12Ssfu9opeTt4aGtiJwwc4G2Hx0s=;
        b=nbN7ZeE+oS+SZuq9KpzEQZyn1BsO0ewEhS31+3fz/ixzurqBxxA4MrXej1ISCqtt7u
         rJmipm5AKA2p9o0ViHYKJzhVM/AJwro7CKZUGp2jfvBS2J39Ge3mI2lD8zAMrtzhDhCj
         ZtLvTQ0krvOeyQhdyNvkr7s2ulVSh+tWagxMXTxDhExmIUH86uPMXmdWK60cn0TZtreZ
         4SZW2D2HM6NbctN16U0ttDTg5bfrQUMhcjf4jzDl0zkAs8o8vkytrQVWS/MzYoAIotPd
         kfnQzyWapv51brwV1eP3aA/AzsOc48cN1FNd/tspvzJNMq6NekveGQkIVozdWUFEf92/
         KZbg==
X-Gm-Message-State: AOAM533YxYC5QJLrgrw8OiBqjzhAXZnPoBwNilKC9MUghgsg1XW6+Mvo
        aSjmRiMDl/mjuuNqHfI5zOklJ6VuRboNIyQqNJY=
X-Google-Smtp-Source: ABdhPJze11NFGRPF92kbYowLGzP75qCjjAhkAsHhnNTljyfvxcMYDTj2SCWRnytlnJdQEdpasx/YnuL7f/cIOancEL4=
X-Received: by 2002:a5d:81c8:: with SMTP id t8mr1115639iol.38.1614807364687;
 Wed, 03 Mar 2021 13:36:04 -0800 (PST)
MIME-Version: 1.0
References: <20210302060753.953931-1-kuba@kernel.org> <CANn89iLaQuCGeWOh7Hp8X9dL09FhPP8Nwj+zV=rhYX7Cq7efpg@mail.gmail.com>
In-Reply-To: <CANn89iLaQuCGeWOh7Hp8X9dL09FhPP8Nwj+zV=rhYX7Cq7efpg@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 3 Mar 2021 13:35:53 -0800
Message-ID: <CAKgT0UdXiFBW9oDwvsFPe_ZoGveHLGh6RXf55jaL6kOYPEh0Hg@mail.gmail.com>
Subject: Re: [PATCH net] net: tcp: don't allocate fast clones for fastopen SYN
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@fb.com>, Neil Spring <ntspring@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 2, 2021 at 1:37 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Mar 2, 2021 at 7:08 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > When receiver does not accept TCP Fast Open it will only ack
> > the SYN, and not the data. We detect this and immediately queue
> > the data for (re)transmission in tcp_rcv_fastopen_synack().
> >
> > In DC networks with very low RTT and without RFS the SYN-ACK
> > may arrive before NIC driver reported Tx completion on
> > the original SYN. In which case skb_still_in_host_queue()
> > returns true and sender will need to wait for the retransmission
> > timer to fire milliseconds later.
> >
> > Revert back to non-fast clone skbs, this way
> > skb_still_in_host_queue() won't prevent the recovery flow
> > from completing.
> >
> > Suggested-by: Eric Dumazet <edumazet@google.com>
> > Fixes: 355a901e6cf1 ("tcp: make connect() mem charging friendly")
>
> Hmmm, not sure if this Fixes: tag makes sense.
>
> Really, if we delay TX completions by say 10 ms, other parts of the
> stack will misbehave anyway.
>
> Also, backporting this patch up to linux-3.19 is going to be tricky.
>
> The real issue here is that skb_still_in_host_queue() can give a false positive.
>
> I have mixed feelings here, as you can read my answer :/
>
> Maybe skb_still_in_host_queue() signal should not be used when a part
> of the SKB has been received/acknowledged by the remote peer
> (in this case the SYN part).
>
> Alternative is that drivers unable to TX complete their skbs in a
> reasonable time should call skb_orphan()
>  to avoid skb_unclone() penalties (and this skb_still_in_host_queue() issue)
>
> If you really want to play and delay TX completions, maybe provide a
> way to disable skb_still_in_host_queue() globally,
> using a static key ?

The problem as I see it is that the original fclone isn't what we sent
out on the wire and that is confusing things. What we sent was a SYN
with data, but what we have now is just a data frame that hasn't been
put out on the wire yet.

I wonder if we couldn't get away with doing something like adding a
fourth option of SKB_FCLONE_MODIFIED that we could apply to fastopen
skbs? That would keep the skb_still_in_host queue from triggering as
we would be changing the state from SKB_FCLONE_ORIG to
SKB_FCLONE_MODIFIED for the skb we store in the retransmit queue. In
addition if we have to clone it again and the fclone reference count
is 1 we could reset it back to SKB_FCLONE_ORIG.
