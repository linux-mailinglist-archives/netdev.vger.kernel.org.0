Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870E71FC23A
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 01:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgFPXUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 19:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgFPXUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 19:20:50 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10AFC06174E
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 16:20:50 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id w9so157271qtv.3
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 16:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pqIyQnUzXL5D4KsY5srH61fM06Ml//ffTL2G2f2q/+I=;
        b=nf1vgdPfxioxYb678T+PGpk3e9XZjrx5frEV88ZO9w+rxRFoN6I+vXrBwNxYikpAr0
         4qgGlVtlEm1kj9qbcVzkraXqYUMzoi+elLGivjtl1o7AP53OX7jUviC3GoXe90UuMEwL
         ZibG6EDWYTXBwiab8QOlX9NrGFuRo5RjsbMYMKJU01xxUK0GAqIE91/mWbKy8D4L+6ln
         6eLNLjfujVEODkbXUH+sCopGW5oQzR0pQ67ONMrtW+mPrBRzm0dJVRPP6dAwDzUHrNSi
         lHl7CD6cqUjZraEHRqeFrNewr9+8F8yXSWC7YxxtrFygZCRLsosptjVno/LwPr+wNZcJ
         3iBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pqIyQnUzXL5D4KsY5srH61fM06Ml//ffTL2G2f2q/+I=;
        b=AExlB4mkmRXmo6mCtNMyVUs7jNK8unjTH8IvHiu0isAi9JGJdWLfjKwONShXwpzlA3
         P7JLdjTF3BKqFa/ZshAs9kVDHWUQQ1dkIvXrJmj+iS4B3/0sLDh0KmvRcya/zVzJVrsL
         MmemngEC7pIv8Q8kkOvirqXXLJxZbqeWVNaixQAEIBUNoxL1KTDujcOEw+jLQMQ6MdZL
         C8zN+dKRZ/oS+Wirw8lJiS0YPpfZdsjH4M4XXJ34dNl2bslSiVmWJh+GwENSx233IVjj
         jkErt4t0Kg1R1t3ZBMghmR4yfqtjqC2UAIg0acVPx72heAX7FILBRCNo9vztUP8fBlUL
         cq3Q==
X-Gm-Message-State: AOAM531Tzf+NbBZArKKtjYNOH7MlNwX8QyChP4fo0TrrgbMSPoHSk2Uq
        Dl/sSYUXfFzZN3nf1TF3kgGdfAIU2u6t5mki+Wo2hNDg
X-Google-Smtp-Source: ABdhPJwD3v60Mm1RwFrItNO59U2z4MW3Y+zBVZD4ijXCaWBscZ76kjKPr6/TN7Q/V/cDiH0X8KSR88U3EhUcbxgFBI4=
X-Received: by 2002:ac8:4c89:: with SMTP id j9mr23961366qtv.326.1592349649706;
 Tue, 16 Jun 2020 16:20:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200616225256.246769-1-sdf@google.com> <CAADnVQLS7=UmT9ivyuUiq8i9ZJRUyPNhN0dvdeiF32sUi=A3NQ@mail.gmail.com>
In-Reply-To: <CAADnVQLS7=UmT9ivyuUiq8i9ZJRUyPNhN0dvdeiF32sUi=A3NQ@mail.gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 16 Jun 2020 16:20:38 -0700
Message-ID: <CAKH8qBso=z3Thz0pimhLOVvPd2iGMmMoPvUA3j4dZYe1ivr97g@mail.gmail.com>
Subject: Re: [PATCH bpf v4 1/2] bpf: don't return EINVAL from {get,set}sockopt
 when optlen > PAGE_SIZE
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 4:05 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Jun 16, 2020 at 3:53 PM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > Attaching to these hooks can break iptables because its optval is
> > usually quite big, or at least bigger than the current PAGE_SIZE limit.
> > David also mentioned some SCTP options can be big (around 256k).
> >
> > There are two possible ways to fix it:
> > 1. Increase the limit to match iptables max optval. There is, however,
> >    no clear upper limit. Technically, iptables can accept up to
> >    512M of data (not sure how practical it is though).
> >
> > 2. Bypass the value (don't expose to BPF) if it's too big and trigger
> >    BPF only with level/optname so BPF can still decide whether
> >    to allow/deny big sockopts.
> >
> > The initial attempt was implemented using strategy #1. Due to
> > listed shortcomings, let's switch to strategy #2. When there is
> > legitimate a real use-case for iptables/SCTP, we can consider increasing
> >  the PAGE_SIZE limit.
> >
> > To support the cases where len(optval) > PAGE_SIZE we can
> > leverage upcoming sleepable BPF work by providing a helper
> > which can do copy_from_user (sleepable) at the given offset
> > from the original large buffer.
> >
> > v4:
> > * use temporary buffer to avoid optval == optval_end == NULL;
> >   this removes the corner case in the verifier that might assume
> >   non-zero PTR_TO_PACKET/PTR_TO_PACKET_END.
>
> just replied with another idea in v3 thread...
Yeah, sorry about that, posted 5 mins before your reply :-( Sorry for the noise.
