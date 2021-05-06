Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD98E3757F9
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 17:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbhEFP4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 11:56:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53295 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235136AbhEFP4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 11:56:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620316541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cpTdnOAK/KKCv/bT7+AufTXsf9CDVRdAzsKCtsVHRRk=;
        b=N1Y35uY0wEBescUoNEYwOxalM7r0oNPhq7tQgTFh6SA5cYiVe4NtTyRZ1Zc6Jf2AEqSQyy
        D9GNq7WJ04/IjEXsE7BMCHBSptqmq/AIS+w3E4yYuD+rRMzmzPBqqiVzg6R/x4YeVarL2B
        EZm9rvIpiYpM+J4Z+O35Mp/IuCjaLs4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-ORp37RddOlSrYrMSaZW_Kg-1; Thu, 06 May 2021 11:55:39 -0400
X-MC-Unique: ORp37RddOlSrYrMSaZW_Kg-1
Received: by mail-wm1-f72.google.com with SMTP id b16-20020a7bc2500000b029014587f5376dso2388319wmj.1
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 08:55:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=cpTdnOAK/KKCv/bT7+AufTXsf9CDVRdAzsKCtsVHRRk=;
        b=JTMNUEjxekDk+/Z5TOA2J0xNS2Vshy7Hbxn2i1ZVecRUf//x5gSFAbzG+6jS+KONd+
         ZqVDgnMHyjFGZwQ7k01cRo8xQXjH9h4nlYdjQsucuegdoo4qYi61x/k2B/RRKZ8ypUhN
         BpZcnfkJGsGNfR/w3F/7J9XSxN7/8QoaU1VdmFNuBbg//zltID5lXWlOTKTaa+6Bkuxk
         i6PJHyMSIVaqjZxOJgMr+mKSfSbskld3n6Ll7iY5XSETprsQGy4qj1Y1buagiiq00QW7
         cXhxjBcsyp0k28HLD8uTiLyRXsVgMn6MSFf2n08Vvx7vbtnFVDRtlZTLd2MrFldgn89k
         ySgA==
X-Gm-Message-State: AOAM5313pb02w5NKlnmPieHzfkK6rIRg5Xv5TxYEXjDV/yxTHYKRarih
        x2hVQBSLorlZK5mewLdHPazTrYy3acUN6sz01SYOfyhiVgTiAIJ2LyfBPDSWf0C8PkBKQbSlklK
        GJ9qBVKEzapP0ET7E
X-Received: by 2002:adf:e811:: with SMTP id o17mr6254229wrm.71.1620316538141;
        Thu, 06 May 2021 08:55:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJztzaPB6zOP1m5NZGZy0plckLtI8JcS+Pg8SAFR+NW9NONOl/PUy2T31mVnDNVKw2MB7UbJgw==
X-Received: by 2002:adf:e811:: with SMTP id o17mr6254199wrm.71.1620316537936;
        Thu, 06 May 2021 08:55:37 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-108-140.dyn.eolo.it. [146.241.108.140])
        by smtp.gmail.com with ESMTPSA id s5sm4006200wmh.37.2021.05.06.08.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 08:55:37 -0700 (PDT)
Message-ID: <78da518b491d0ad87380786dddf465c98706a865.camel@redhat.com>
Subject: Re: [PATCH net 1/4] net: fix double-free on fraglist GSO skbs
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Date:   Thu, 06 May 2021 17:55:36 +0200
In-Reply-To: <CAF=yD-+XLDTzzBsPsMW-s9t0Ur3ux8w93VOAyHJ91E_cZLQS7w@mail.gmail.com>
References: <cover.1620223174.git.pabeni@redhat.com>
         <e5d4bacef76ef439b6eb8e7f4973161ca131dfee.1620223174.git.pabeni@redhat.com>
         <CAF=yD-+BAMU+ETz9MV--MR5NuCE9VrtNezDB3mAiBQR+5puZvQ@mail.gmail.com>
         <d6665869966936b79305de87aaddd052379038c4.camel@redhat.com>
         <CAF=yD-++8zxVKThLnPMdDOcR5Q+2dStne4=EKeKCD7pVyEc8UA@mail.gmail.com>
         <5276af7f06b4fd72e549e3b5aebdf41bef1a3784.camel@redhat.com>
         <CAF=yD-+XLDTzzBsPsMW-s9t0Ur3ux8w93VOAyHJ91E_cZLQS7w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-05-06 at 10:32 -0400, Willem de Bruijn wrote:
> On Thu, May 6, 2021 at 7:07 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > On Wed, 2021-05-05 at 13:30 -0400, Willem de Bruijn wrote:
> > > On Wed, May 5, 2021 at 1:28 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > On Wed, 2021-05-05 at 12:13 -0400, Willem de Bruijn wrote:
> > > > > On Wed, May 5, 2021 at 11:37 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > > > While segmenting a SKB_GSO_FRAGLIST GSO packet, if the destructor
> > > > > > callback is available, the skb destructor is invoked on each
> > > > > > aggregated packet via skb_release_head_state().
> > > > > > 
> > > > > > Such field (and the pairer skb->sk) is left untouched, so the same
> > > > > > destructor is invoked again when the segmented skbs are freed, leading
> > > > > > to double-free/UaF of the relevant socket.
> > > > > 
> > > > > Similar to skb_segment, should the destructor be swapped with the last
> > > > > segment and callback delayed, instead of called immediately as part of
> > > > > segmentation?
> > > > > 
> > > > >         /* Following permits correct backpressure, for protocols
> > > > >          * using skb_set_owner_w().
> > > > >          * Idea is to tranfert ownership from head_skb to last segment.
> > > > >          */
> > > > >         if (head_skb->destructor == sock_wfree) {
> > > > >                 swap(tail->truesize, head_skb->truesize);
> > > > >                 swap(tail->destructor, head_skb->destructor);
> > > > >                 swap(tail->sk, head_skb->sk);
> > > > >         }
> > > > 
> > > > My understanding is that one assumption in the original
> > > > SKB_GSO_FRAGLIST implementation was that SKB_GSO_FRAGLIST skbs are not
> > > > owned by any socket.
> > > > 
> > > > AFAICS the above assumption was true until:
> > > > 
> > > > commit c75fb320d482a5ce6e522378d137fd2c3bf79225
> > > > Author: Paolo Abeni <pabeni@redhat.com>
> > > > Date:   Fri Apr 9 13:04:37 2021 +0200
> > > > 
> > > >     veth: use skb_orphan_partial instead of skb_orphan
> > > > 
> > > > after that, if the skb is owned, skb->destructor is sock_efree(), so
> > > > the above code should not trigger.
> > > 
> > > Okay, great.
> > > 
> > > > More importantly SKB_GSO_FRAGLIST can only be applied if the inner-
> > > > most protocol is UDP, so
> > > > commit 432c856fcf45c468fffe2e5029cb3f95c7dc9475
> > > > and d6a4a10411764cf1c3a5dad4f06c5ebe5194488b should not be relevant.
> > > 
> > > I think the first does apply, as it applies to any protocol that uses
> > > sock_wfree, not just tcp_wfree? Anyway, the point is moot indeed.
> > 
> > If we want to be safe about future possible sock_wfree users, I think
> > the approach here should be different: in skb_segment(), tail-
> > > destructor is expected to be NULL, while skb_segment_list(), all the
> > list skbs can be owned by the same socket. Possibly we could open-
> > code skb_release_head_state(), omitting the skb orphaning part
> > for sock_wfree() destructor.
> > 
> > Note that the this is not currently needed - sock_wfree destructor
> > can't reach there.
> > 
> > Given all the above, I'm unsure if you are fine with (or at least do
> > not oppose to) the code proposed in this patch?
> 
> Yes. Thanks for clarifying, Paolo.

Thank you for reviewing!

@David, @Jakub: I see this series is already archived as "change
requested", should I repost?

Thanks!

Paolo

