Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59913752C5
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 13:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234618AbhEFLIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 07:08:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34635 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234569AbhEFLIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 07:08:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620299224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6mO+hImqmlFN+LeawI1UdUIeERFCHJgAAmffTzVAoBM=;
        b=aAN8r0mz/BBPhmethstJl+wz+hd91oMHGofDIZbdRgq8GVsITGFZVNuOnOgt0UbFaBvbae
        dQF7VH6OPomu7JtfAyxZaqYuoJSvWHXwHaNmSKY7a0eKVAPHhEHd+uK0C0BfRmyxgBSCn6
        cwAVrA/SlDGcwnuPVaU/wtL1eCzxprg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-gli4PWK5M3WmJkf4OOKHFA-1; Thu, 06 May 2021 07:07:03 -0400
X-MC-Unique: gli4PWK5M3WmJkf4OOKHFA-1
Received: by mail-wr1-f69.google.com with SMTP id r12-20020adfc10c0000b029010d83323601so2021737wre.22
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 04:07:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=6mO+hImqmlFN+LeawI1UdUIeERFCHJgAAmffTzVAoBM=;
        b=UrL+k0Z0+z7xrXfStVkmrcpHtzSsr5i3oz+TTRMOL5qSJvp0JFshzMIcAXwGRV2gjY
         ZmFI6UU8Vm+a2QghaJz3Xde6j2ong2+SxG3FjGhuHYX5ST1b2q25WiJU/3jhSh0T4iJD
         AZcQrMksVdmAtCOjzdG7dWNjVaVeO7WvJQY1zNcjCfLyqCeknoWhibwrPmeCjOXr21xD
         Q1A+zUhsw5WHv9BaFPS7vYKE7dyupJ69erJa3b8LgwkP7GjWE0LNBojcspK/28DU0C7l
         Kfl4MrgVKBppCyKGcDEIFFzpidwBNBa35fZofYqt5p++oo7ZMqERZiQMRx2sL2tkyUNV
         ODHg==
X-Gm-Message-State: AOAM530h0z8seybRpfGeduNVxZay7IkbciJXwHnOfZfmRsrjy9uUn2Ac
        ywdP6uNLFxy7uyFRlryeNDhDwZVuIcVLug1FUyKsleY9r3MeMBEJi20imyYr6sYCCqXWYn/DynV
        PW58iPE1NRhBquvoN
X-Received: by 2002:adf:da4f:: with SMTP id r15mr4255918wrl.411.1620299221740;
        Thu, 06 May 2021 04:07:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJK8yoDm+pGm7obMhtm6UozLVYeJ2SrRX6MdAJ0dTqa3tILmV77q244jfg9ch3UjI0NulzDg==
X-Received: by 2002:adf:da4f:: with SMTP id r15mr4255907wrl.411.1620299221550;
        Thu, 06 May 2021 04:07:01 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-108-140.dyn.eolo.it. [146.241.108.140])
        by smtp.gmail.com with ESMTPSA id m11sm3672480wri.44.2021.05.06.04.07.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 04:07:01 -0700 (PDT)
Message-ID: <5276af7f06b4fd72e549e3b5aebdf41bef1a3784.camel@redhat.com>
Subject: Re: [PATCH net 1/4] net: fix double-free on fraglist GSO skbs
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Date:   Thu, 06 May 2021 13:06:59 +0200
In-Reply-To: <CAF=yD-++8zxVKThLnPMdDOcR5Q+2dStne4=EKeKCD7pVyEc8UA@mail.gmail.com>
References: <cover.1620223174.git.pabeni@redhat.com>
         <e5d4bacef76ef439b6eb8e7f4973161ca131dfee.1620223174.git.pabeni@redhat.com>
         <CAF=yD-+BAMU+ETz9MV--MR5NuCE9VrtNezDB3mAiBQR+5puZvQ@mail.gmail.com>
         <d6665869966936b79305de87aaddd052379038c4.camel@redhat.com>
         <CAF=yD-++8zxVKThLnPMdDOcR5Q+2dStne4=EKeKCD7pVyEc8UA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-05-05 at 13:30 -0400, Willem de Bruijn wrote:
> On Wed, May 5, 2021 at 1:28 PM Paolo Abeni <pabeni@redhat.com> wrote:
> > On Wed, 2021-05-05 at 12:13 -0400, Willem de Bruijn wrote:
> > > On Wed, May 5, 2021 at 11:37 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > > > While segmenting a SKB_GSO_FRAGLIST GSO packet, if the destructor
> > > > callback is available, the skb destructor is invoked on each
> > > > aggregated packet via skb_release_head_state().
> > > > 
> > > > Such field (and the pairer skb->sk) is left untouched, so the same
> > > > destructor is invoked again when the segmented skbs are freed, leading
> > > > to double-free/UaF of the relevant socket.
> > > 
> > > Similar to skb_segment, should the destructor be swapped with the last
> > > segment and callback delayed, instead of called immediately as part of
> > > segmentation?
> > > 
> > >         /* Following permits correct backpressure, for protocols
> > >          * using skb_set_owner_w().
> > >          * Idea is to tranfert ownership from head_skb to last segment.
> > >          */
> > >         if (head_skb->destructor == sock_wfree) {
> > >                 swap(tail->truesize, head_skb->truesize);
> > >                 swap(tail->destructor, head_skb->destructor);
> > >                 swap(tail->sk, head_skb->sk);
> > >         }
> > 
> > My understanding is that one assumption in the original
> > SKB_GSO_FRAGLIST implementation was that SKB_GSO_FRAGLIST skbs are not
> > owned by any socket.
> > 
> > AFAICS the above assumption was true until:
> > 
> > commit c75fb320d482a5ce6e522378d137fd2c3bf79225
> > Author: Paolo Abeni <pabeni@redhat.com>
> > Date:   Fri Apr 9 13:04:37 2021 +0200
> > 
> >     veth: use skb_orphan_partial instead of skb_orphan
> > 
> > after that, if the skb is owned, skb->destructor is sock_efree(), so
> > the above code should not trigger.
> 
> Okay, great.
> 
> > More importantly SKB_GSO_FRAGLIST can only be applied if the inner-
> > most protocol is UDP, so
> > commit 432c856fcf45c468fffe2e5029cb3f95c7dc9475
> > and d6a4a10411764cf1c3a5dad4f06c5ebe5194488b should not be relevant.
> 
> I think the first does apply, as it applies to any protocol that uses
> sock_wfree, not just tcp_wfree? Anyway, the point is moot indeed.

If we want to be safe about future possible sock_wfree users, I think
the approach here should be different: in skb_segment(), tail-
>destructor is expected to be NULL, while skb_segment_list(), all the
list skbs can be owned by the same socket. Possibly we could open-
code skb_release_head_state(), omitting the skb orphaning part
for sock_wfree() destructor.

Note that the this is not currently needed - sock_wfree destructor
can't reach there.

Given all the above, I'm unsure if you are fine with (or at least do
not oppose to) the code proposed in this patch?

Thanks,

Paolo

