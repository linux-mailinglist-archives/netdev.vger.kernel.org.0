Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1DC850FE90
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 15:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238717AbiDZNPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 09:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350771AbiDZNPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 09:15:00 -0400
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6452C63BD4
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 06:11:52 -0700 (PDT)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-2f7d19cac0bso74659677b3.13
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 06:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ywb0PCbOjM70meBYU3ljQqOZHc3gzkL6jPrDyfncQ/Y=;
        b=VHC2un/+gBqTBQH3hXTMJn0yaqn4hDTiYcoNmGJmNtPOnnBe93G5mxLM4feTiF9CTQ
         cxO9Cc4WfYcZGxpQmYNbNel4y0HpW0GxtcToznAunxKLFrDLwVkZYF5fnVsSPFCDysXp
         K8s4W5TH+oonf3towQb884/uax4BxLcsd2FY3Oy6HHGhQ0YqbliyclLzuxqfPaskXFBu
         oypwnsK9gQKuJ02FAyyIosYJt6TbeSSXwJDBj1zKWsQjXAdyMtBhbXty8BVZa2oTp/WB
         r/y/oVnDz4jEl6ExBpebT7cSKfYzW82DREV7Af73718yGa0c0lEcT1KwDmos8I6Yl9jW
         sCUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ywb0PCbOjM70meBYU3ljQqOZHc3gzkL6jPrDyfncQ/Y=;
        b=6ah+8+FCnpvV5pCCKg7Eh0XZ/vGgKVOBOo3QAaqzTdb8jPqHDvcpsp6lsG7PIwCNki
         nX05nJJK2ihS+P5xx20zj3DO16cm8O8TEMidP5F5lGjUOP4EJYKA2Pb5Aa5Vu8hPevvK
         LhxsqX5voygGqEuDCkWd57Jf7WUelHn8pBuOgdeUYTsrDIJg3TxLTnugtscZdcTB+pVg
         toBIxxPBgyswT0Y4PTj0dx8usY3i/pnLrxCbxiKfR5LqjCBj7g6eT2drK72toBJvnxjU
         SwarPBWLy71KOIIKtmZ048meAbtB+s+sncxIoCMSoakDjT5UtTA6RoAuzktDwyFy8MFg
         56NA==
X-Gm-Message-State: AOAM530jMzL/SqMmfW9yvWqusasIsnrKeuD8Bb8wZB7+Yc0AAQxG7Yma
        AQPislNok1ob/pyZ9wptjMFEi7NZkV6CvqdVkvkcotGCYxXIDPqS
X-Google-Smtp-Source: ABdhPJxGn8RCd3XWgAnBMdrD1XBlBZY90qLTsENyZGxrvSMuiLY6v2u01+K/jjSB/8vN6FRPDWy5pmHj4Adg9BWVtY4=
X-Received: by 2002:a81:2054:0:b0:2f4:dfb3:3e3 with SMTP id
 g81-20020a812054000000b002f4dfb303e3mr22502374ywg.332.1650978711339; Tue, 26
 Apr 2022 06:11:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220422201237.416238-1-eric.dumazet@gmail.com> <2c092f98a8fe1702173fe2b4999811dd2263faf3.camel@redhat.com>
In-Reply-To: <2c092f98a8fe1702173fe2b4999811dd2263faf3.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 26 Apr 2022 06:11:40 -0700
Message-ID: <CANn89iLuqGdbHkyUcTZd+Ww6vUxqNg0L4eC5Xt8bqLMDmDM18w@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] net: generalize skb freeing deferral to
 per-cpu lists
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 26, 2022 at 12:38 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
>
> Hello,
>
> I'm sorry for the late feedback. I have only a possibly relevant point
> below.
>
> On Fri, 2022-04-22 at 13:12 -0700, Eric Dumazet wrote:
> [...]
> > @@ -6571,6 +6577,28 @@ static int napi_threaded_poll(void *data)
> >       return 0;
> >  }
> >
> > +static void skb_defer_free_flush(struct softnet_data *sd)
> > +{
> > +     struct sk_buff *skb, *next;
> > +     unsigned long flags;
> > +
> > +     /* Paired with WRITE_ONCE() in skb_attempt_defer_free() */
> > +     if (!READ_ONCE(sd->defer_list))
> > +             return;
> > +
> > +     spin_lock_irqsave(&sd->defer_lock, flags);
> > +     skb = sd->defer_list;
>
> I *think* that this read can possibly be fused with the previous one,
> and another READ_ONCE() should avoid that.

Only the lockless read needs READ_ONCE()

For the one after spin_lock_irqsave(&sd->defer_lock, flags),
there is no need for any additional barrier.

If the compiler really wants to use multiple one-byte-at-a-time loads,
we are not going to fight, there might be good reasons for that.

(We do not want to spread READ_ONCE / WRITE_ONCE for all
loads/stores, as this has performance implications)

>
> BTW it looks like this version gives slightly better results than the
> previous one, perhpas due to the single-liked list usage?

Yes, this could be the case, or maybe it is because 10 runs are not enough
in a host with 32 RX queues, with a 50/50 split between the two NUMA nodes.

When reaching high throughput, every detail matters, like background usage on
the network, from monitoring and machine health daemons.

Thanks.
