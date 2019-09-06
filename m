Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCF64ABB5E
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 16:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394640AbfIFOud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 10:50:33 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43094 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729121AbfIFOud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 10:50:33 -0400
Received: by mail-ed1-f65.google.com with SMTP id c19so6500543edy.10
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 07:50:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7i75m4S4o1OYA5WZtkRH9weu77DfvuXcVGboMqm9ZxE=;
        b=e4/4o2frKVkbjpu8lekn+hXRXB08X2KAtZbJluexRaMgmd8gkMAnDgpRiFmQ0Uz09E
         9Ck3O0HREiNPsyFM4I9oC5jIqubUHUU+THkYv3/KrfZNfO6HeuoMF4a17Tm4D01Aj2VF
         jX8ryzaebFfR93GPXVLCLsaCB4OA42cnytYKRJe6PJJn2EdvZya+YSebt/hKbpf/4saS
         2MaMWuSjR7R/aY3wjdRJLSahTQnWWda+lKn3tgMKc5+Ni8gkGSsCQqSU/UgrFhgYRiGe
         EOz+T6Zv4bQpbHL+0XfgwxZMmtTeJz3tVZn/wIFbtz3YyDYvEjpFx4vwYOaG9hiEk+06
         UCnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7i75m4S4o1OYA5WZtkRH9weu77DfvuXcVGboMqm9ZxE=;
        b=XqFgKEisT38u3BZhL6H47OqdxQdpjhcgviLWluNzf/ck0G+cIToVdd5XYqRubyyJk0
         JGKazchn6cTEt64kkeFp4OevQ+rMacU9+X3v4w6AVOpv/8kVfSScr/3+StOM5CrUChz2
         eFcN44fomkwGBvT2BFrbCFCxrjebVggTlGk1U1XSJpqCM1/aAWbKzKwi6bzbILMa1mps
         Z1p4+4wtkocXcFTmiye+wnyOyLLJ4ZIqGdNZf1SMuviTS63d5tWF1eafmlczIGvBBIHa
         PdeI0ykRnK88fEniBy/cjrherv5WH+SS/lznN8kK/k/qOtcnse41QBR2j0NrewkukwWN
         w1Pw==
X-Gm-Message-State: APjAAAWzEhYB5VuQo+PwXJD/k/UYHD0PUUXq7Ai++6leLckCgssm/0aC
        qDtI5c4T+43FnUFLojvsUc30exqLxvaOBcUbR0w=
X-Google-Smtp-Source: APXvYqxhO2X6VwQ0oW7ynzLpDYrzcGC5ztpuv9lUBoAi2tski8JkgoTTIU7EV4I++Jf6WugBxvA7mSeNIKep4n5zc04=
X-Received: by 2002:a50:fc12:: with SMTP id i18mr10285082edr.23.1567781431490;
 Fri, 06 Sep 2019 07:50:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190905183633.8144-1-shmulik.ladkani@gmail.com>
 <CAF=yD-J9Ax9f7BsGBFAaG=QU6CPVw6sSzBkZJOHRW-m6o49oyw@mail.gmail.com> <20190906094744.345d9442@pixies>
In-Reply-To: <20190906094744.345d9442@pixies>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 6 Sep 2019 10:49:55 -0400
Message-ID: <CAF=yD-JB6TMQuyaxzLX8=9CZZF+Zk5EmniSkx_F81bVc87XqJw@mail.gmail.com>
Subject: Re: [PATCH net] net: gso: Fix skb_segment splat when splitting
 gso_size mangled skb having linear-headed frag_list
To:     Shmulik Ladkani <shmulik@metanetworks.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, eyal@metanetworks.com,
        netdev <netdev@vger.kernel.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 6, 2019 at 2:47 AM Shmulik Ladkani <shmulik@metanetworks.com> wrote:
>
> On Thu, 5 Sep 2019 17:51:20 -0400
> Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
>
> > On Thu, Sep 5, 2019 at 2:36 PM Shmulik Ladkani <shmulik@metanetworks.com> wrote:
> > >
> > > +       if (mss != GSO_BY_FRAGS &&
> > > +           (skb_shinfo(head_skb)->gso_type & SKB_GSO_DODGY)) {
> > > +               /* gso_size is untrusted.
> > > +                *
> > > +                * If head_skb has a frag_list with a linear non head_frag
> > > +                * item, and head_skb's headlen does not fit requested
> > > +                * gso_size, fall back to copying the skbs - by disabling sg.
> > > +                *
> > > +                * We assume checking the first frag suffices, i.e if either of
> > > +                * the frags have non head_frag data, then the first frag is
> > > +                * too.
> > > +                */
> > > +               if (list_skb && skb_headlen(list_skb) && !list_skb->head_frag &&
> > > +                   (mss != skb_headlen(head_skb) - doffset)) {
> >
> > I thought the idea was to check skb_headlen(list_skb), as that is the
> > cause of the problem. Is skb_headlen(head_skb) a good predictor of
> > that? I can certainly imagine that it is, just not sure.
>
> Yes, 'mss != skb_headlen(HEAD_SKB)' seems to be a very good predictor,
> both for the test reproducer, and what's observered on a live system.
>
> We *CANNOT* use 'mss != skb_headlen(LIST_SKB)' as the test condition.
> The packet could have just a SINGLE frag_list member, and that member could
> be a "small remainder" not reaching the full mss size - so we could hit
> the test condition EVEN FOR NON gso_size mangled frag_list skbs -
> which is not desired.

The last segment. Yes, good point.

> Also, is we test 'mss != skb_headlen(list_skb)' and execute 'sg=false'
> ONLY IF 'list_skb' is *NOT* the last item, this is still bogus.
> Imagine a gso_size mangled packet having just head_skb and a single
> "small remainder" frag. This packet will hit the BUG_ON, as the
> 'sg=false' solution is now skipped according to the revised condition.

Right, I wouldn't suggest that.

But I wonder whether it is a given that head_skb has headlen.

Btw, it seems slightly odd to me tot test head_frag before testing
headlen in the v2 patch.
