Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6670C271D97
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 10:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgIUILW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 04:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbgIUILW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 04:11:22 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E6CEC061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 01:11:22 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id r25so14491531ioj.0
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 01:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LlIIJsBl6C7C1WRKfagWEHAxXUQGBUS8dNq6MjzRPjI=;
        b=b0Q7H0PtsEDxFfRrvv56hGyowU8mZDWGLmT+aycj/Upqa5CP5Q4P3ibDX4xU/Nikps
         SgENbjqA++YUfKJWzv2mYwKqjmd5bjGsX8kOTQcGH3MNkpUhLnu5nn7sW1hfGnY5fiGN
         PZzLEIP3TMoIc2glP+dSMvfwsTQTapdTwcl/OGuWQSSjXClOMyk5SUy01A5Ljx6QJ9Tt
         9UnvkwxFw7NpCBzfmSZi1qOTfclvjZ3GtS4064WEXg4ESkbQqL0H8fl78PMEirw1fb3Z
         bOfrvK5f+YAfm0JWjdrIe7T5uj39hdmqpPVQ/isPyMPDee4EO5yuWdMQnx86zOp6e8O7
         JlKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LlIIJsBl6C7C1WRKfagWEHAxXUQGBUS8dNq6MjzRPjI=;
        b=n89e3F8vpt8lczvBtl1M8ZUpbySJ4vpz9JIEqZEfuupq8oX6JX0YHu9KLBP4rRUtND
         fTiukmmCvBmHSZBkekWcmWbkcaNekhaxX7Ud955Mt+5omo5q9Wfg3/z/SoKSG5c29bes
         lXdGZ45BbgItxE0XXAS+YDEJLbWZ/hanHqZ5+wItjcktZ+8iaG5YooxJ/4KLLkWfjHWY
         iXUXHcDe4YkyQLkan+99VXiXjI4YXQN2QJQx+xMmLb6UDvR4ixrnKqTlFKpW5CaUv8TZ
         KXZG5CK8cAkb4aU0GkExxhb4y9gUdvE1pJCZmof3zwjn71UJYvSZJhMUW3+l1IbPzUl9
         xOKQ==
X-Gm-Message-State: AOAM533sQHLKHWc+1CRhvZ7m4oz024SZPSbJk2H4zzeuAbo/+jNFcVNb
        Jz/Imu6fSfaPiatVUTBGoFE8vhACix7+PfxSSvhIfg==
X-Google-Smtp-Source: ABdhPJwgdGMME3LCofoKrCUqayp8IlaYsq93DhlTXjrYkMb+ogfeI8cDqG01Fmo4vbaKaG36dV7Ie0gH8HoOdqnTPIQ=
X-Received: by 2002:a6b:3bd3:: with SMTP id i202mr35795034ioa.145.1600675881172;
 Mon, 21 Sep 2020 01:11:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200914172453.1833883-1-weiwan@google.com> <20200914172453.1833883-6-weiwan@google.com>
 <CAEA6p_BszGQafCo3NQG71dRNMTkh-fL2U9OMon2EALvFz=tSnw@mail.gmail.com>
In-Reply-To: <CAEA6p_BszGQafCo3NQG71dRNMTkh-fL2U9OMon2EALvFz=tSnw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 21 Sep 2020 10:11:09 +0200
Message-ID: <CANn89iJHQd7BPAed4Yi45t3wt5qT77c0EcF9RgQ4_ZCOULpeAg@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 5/6] net: process RPS/RFS work in kthread context
To:     Wei Wang <weiwan@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 12:45 AM Wei Wang <weiwan@google.com> wrote:
>
> On Mon, Sep 14, 2020 at 10:26 AM Wei Wang <weiwan@google.com> wrote:
> >
> > From: Paolo Abeni <pabeni@redhat.com>
> >
> > This patch adds the missing part to handle RFS/RPS in the napi thread
> > handler and makes sure RPS/RFS works properly when using kthread to do
> > napi poll.
> >
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > Signed-off-by: Wei Wang <weiwan@google.com>
> > ---
>
> With some more thoughts, I think this patch is not needed. RPS/RFS
> uses its own napi (sd->backlog) which currently does not have
> NAPI_STATE_THREADED set. So it is still being handled in softirq
> context by net_rx_action().
> I will remove this patch in the next version if no one objects.

The purpose of the patch was to make sure to kick the IPI

I think we need it, otherwise RPS/RFS might add a lot of jitter.


>
>
> >  net/core/dev.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index be676c21bdc4..ab8af727058b 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -6820,6 +6820,7 @@ static int napi_thread_wait(struct napi_struct *napi)
> >  static int napi_threaded_poll(void *data)
> >  {
> >         struct napi_struct *napi = data;
> > +       struct softnet_data *sd;
> >         void *have;
> >
> >         while (!napi_thread_wait(napi)) {
> > @@ -6835,6 +6836,12 @@ static int napi_threaded_poll(void *data)
> >                         __kfree_skb_flush();
> >                         local_bh_enable();
> >
> > +                       sd = this_cpu_ptr(&softnet_data);
> > +                       if (sd_has_rps_ipi_waiting(sd)) {
> > +                               local_irq_disable();
> > +                               net_rps_action_and_irq_enable(sd);
> > +                       }
> > +
> >                         if (!repoll)
> >                                 break;
> >
> > --
> > 2.28.0.618.gf4bc123cb7-goog
> >
