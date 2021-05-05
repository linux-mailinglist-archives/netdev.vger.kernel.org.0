Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3342837478F
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 20:05:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235254AbhEER6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234772AbhEER6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 13:58:25 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFF5CC061346
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 10:31:18 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id j17so1810104qtx.6
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 10:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uHFuH/MiPv3sQBSV0I3IV5ZN4VvzTdrTxOiwRGaLFbE=;
        b=Bp3OQ70qGDqkTvg2oKI398CcTVYi8f4fyZ26+hqAL6RfOG76hCygOAT9Vm7k0tA4uZ
         X3oqGx2MjN3it00DyfJ9YHtW/eNFwx36vv7uZ097k4FJy55zhHOaMsykqFzf9zOz/9wq
         iSdghZOnxMuTZDXlHQTY7H+QEbcejjaHDJheINkKPzIiVsVFhXz+bzWRGoV5sJdoKlEu
         glDrbD81AwEg00+YLPEPDd09kLh1juEWvTlyEdb05kveelmj65bll6JFxUpeGyDb9FBl
         +qS3QaskiIfDCr8eUji/GsgwRd+ascNpR8eJ12IbNNkLjBwo84bW7dS5gZRl/YHD2TJW
         FHhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uHFuH/MiPv3sQBSV0I3IV5ZN4VvzTdrTxOiwRGaLFbE=;
        b=HJGtZrIAW//MZ1ai+izksRPg2W7K5X16oBrptg9OXtTkv8aOZPR+qVmbVsfxDsk5IB
         WmLMnujQ8ULh/rjEg1nfe43zqYhjoGCa9vgq6wXm0MMmKDMrnxH526S3PmKh53y4JX34
         0g3DZpP5MYEY4tLeRhZHiXFupxLKTVbLzOa5HVnQugUUJ2Ni9FZVwdsUy4JsT5kVbnCr
         qIyt7eLzMvLX1UfLr2u7ru9vg9vIPs+kN3frdSP27DeDa/msVTIHE9t3P/I1osn0jbXU
         Xnf/s+RmjX9GKPpo2lHOzuNwcDmoeAZmo6PcdWk9pxLXWDq8Y5vrn6BytXuSDGZq1d4q
         FqmQ==
X-Gm-Message-State: AOAM532P2ILzv+uPfsCBsNrCqFFPhRfy+9XGs0V5Z6CaM01CBJ11htzj
        95ZsJ4sHutb6q+2AE/gUNOOGhj/ZHqrxvNnHxnQ=
X-Google-Smtp-Source: ABdhPJzUkgvGiD0PKqlH3mI+D5s/XYWVv4yfjXtcrF8JIM0nsHVVw7B6w4UlgjmSosJmvXm3oiT4DUZV+ix071MEwAw=
X-Received: by 2002:ac8:1014:: with SMTP id z20mr28168320qti.65.1620235877957;
 Wed, 05 May 2021 10:31:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1620223174.git.pabeni@redhat.com> <e5d4bacef76ef439b6eb8e7f4973161ca131dfee.1620223174.git.pabeni@redhat.com>
 <CAF=yD-+BAMU+ETz9MV--MR5NuCE9VrtNezDB3mAiBQR+5puZvQ@mail.gmail.com> <d6665869966936b79305de87aaddd052379038c4.camel@redhat.com>
In-Reply-To: <d6665869966936b79305de87aaddd052379038c4.camel@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 5 May 2021 13:30:41 -0400
Message-ID: <CAF=yD-++8zxVKThLnPMdDOcR5Q+2dStne4=EKeKCD7pVyEc8UA@mail.gmail.com>
Subject: Re: [PATCH net 1/4] net: fix double-free on fraglist GSO skbs
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 5, 2021 at 1:28 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Wed, 2021-05-05 at 12:13 -0400, Willem de Bruijn wrote:
> > On Wed, May 5, 2021 at 11:37 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > > While segmenting a SKB_GSO_FRAGLIST GSO packet, if the destructor
> > > callback is available, the skb destructor is invoked on each
> > > aggregated packet via skb_release_head_state().
> > >
> > > Such field (and the pairer skb->sk) is left untouched, so the same
> > > destructor is invoked again when the segmented skbs are freed, leading
> > > to double-free/UaF of the relevant socket.
> >
> > Similar to skb_segment, should the destructor be swapped with the last
> > segment and callback delayed, instead of called immediately as part of
> > segmentation?
> >
> >         /* Following permits correct backpressure, for protocols
> >          * using skb_set_owner_w().
> >          * Idea is to tranfert ownership from head_skb to last segment.
> >          */
> >         if (head_skb->destructor == sock_wfree) {
> >                 swap(tail->truesize, head_skb->truesize);
> >                 swap(tail->destructor, head_skb->destructor);
> >                 swap(tail->sk, head_skb->sk);
> >         }
>
> My understanding is that one assumption in the original
> SKB_GSO_FRAGLIST implementation was that SKB_GSO_FRAGLIST skbs are not
> owned by any socket.
>
> AFAICS the above assumption was true until:
>
> commit c75fb320d482a5ce6e522378d137fd2c3bf79225
> Author: Paolo Abeni <pabeni@redhat.com>
> Date:   Fri Apr 9 13:04:37 2021 +0200
>
>     veth: use skb_orphan_partial instead of skb_orphan
>
> after that, if the skb is owned, skb->destructor is sock_efree(), so
> the above code should not trigger.

Okay, great.

> More importantly SKB_GSO_FRAGLIST can only be applied if the inner-
> most protocol is UDP, so
> commit 432c856fcf45c468fffe2e5029cb3f95c7dc9475
> and d6a4a10411764cf1c3a5dad4f06c5ebe5194488b should not be relevant.

I think the first does apply, as it applies to any protocol that uses
sock_wfree, not just tcp_wfree? Anyway, the point is moot indeed.
