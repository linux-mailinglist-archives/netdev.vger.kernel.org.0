Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F60A334248
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 16:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhCJP50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 10:57:26 -0500
Received: from mail-yb1-f174.google.com ([209.85.219.174]:43600 "EHLO
        mail-yb1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232887AbhCJP5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 10:57:01 -0500
Received: by mail-yb1-f174.google.com with SMTP id u75so18308877ybi.10;
        Wed, 10 Mar 2021 07:57:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dEJc11B4/+2bfJrfS7rf4kPcL5WeVEcvu81H9/FuMu0=;
        b=OhW+dxM/nczj+2MayEE9BTK0/4WWJiKkxPcAq5qCHLtiHqwsRrtxa7f5IMPSJcb2ZK
         KokVb9Q0K62nUwenMEyFLtU8fh3JOY2bYpWETT3pjAFYMHIXY+gMQpCDUafRhs5uAkRD
         Oq+MtOPBjjGjmFFVqTA3HyrE9NOkKvUwxRDgYMXJMZUW7Tam6lrRoisU1lfAqmvoolAT
         BDbQrV0vBdxdAX43eNhXqedXgp1bkUmiBply4L3N9x3VhJjKN3b1puBntK0aTjj7DHyv
         1CObmkoqtS17d6sGuMR2Pj4hxb3ujsFxY2RBq2RhwysIvlz04Z+Cbdkyjm0AZRBxG2GN
         Oq7A==
X-Gm-Message-State: AOAM53237vuZr7Nb4ieCeCnoawgE91FhOJl2KIL4hRmHsmj5UvlsvY8z
        ACnNdkStPRTGrklnmAXh309LDQfaDzQIE3oM9Uc=
X-Google-Smtp-Source: ABdhPJx/dL0Da/AI4EYHUpFLSrQaSw8sfYutP8N6xpp8pI/hpj4wr3Z636HOH3IGTe4WRjE3TRsoVHUfhNznA0b1vKs=
X-Received: by 2002:a05:6902:4b2:: with SMTP id r18mr5096380ybs.226.1615391820211;
 Wed, 10 Mar 2021 07:57:00 -0800 (PST)
MIME-Version: 1.0
References: <20210309152354.95309-1-mailhol.vincent@wanadoo.fr>
 <20210309152354.95309-2-mailhol.vincent@wanadoo.fr> <CAA93jw5+wB=va5tqUpCiPu20N+pn8VcMxUdySSWoQE_zqH8Qtg@mail.gmail.com>
In-Reply-To: <CAA93jw5+wB=va5tqUpCiPu20N+pn8VcMxUdySSWoQE_zqH8Qtg@mail.gmail.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Thu, 11 Mar 2021 00:56:48 +0900
Message-ID: <CAMZ6RqJZnx1iVb=LZ5QtdLW+Y87d2w0wBkj1EmOrM6hZZujT3Q@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] dql: add dql_set_min_limit()
To:     Dave Taht <dave.taht@gmail.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can <linux-can@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Tom Herbert <therbert@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

Thanks for the comprehensive comments!

On Wed. 10 Mar 2021 at 04:44, Dave Taht <dave.taht@gmail.com> wrote:
>
> I note that "proof" is very much in the developer's opinion and
> limited testing base.
>
> Actual operational experience, as in a real deployment, with other applications,
> heavy context switching, or virtualization, might yield better results.

Agree. I was not thorough in my description, but what you pointed
here is actually what I had in mind (and what I did for my
driver).  Let me borrow your exemple and include those in the v2
of the patch.

> There's lots of defaults in the linux kernel that are just swags, the
> default NAPI and rx/tx ring buffer sizes being two where devs just
> copy/paste stuff, which either doesn't scale up, or doesn't scale
> down.
>
> This does not mean I oppose your patch! However I have two points I'd
> like to make
> regarding bql and dql in general that I have long longed be explored.
>
> 0) Me being an advocate of low latency in general, does mean that I
> have no problem
> and even prefer, starving the device rather than always keeping it busy.
>
> /me hides

Fully agree. The intent of this patch is for specific use cases
where setting a default dql.min_limit has minimum latency impact
for a noticeable throughput increase.

My use case is a CAN driver for a USB interface module. The
maximum PDU of CAN protocol is roughly 16 bytes, the USB maximum
packet size is 512 bytes. If I force dql.min_limit to be around
240 bytes (i.e. roughly 15 CAN frames), all 15 frames easily fit
in a single USB packet. Preparing a packet of 240 bytes is
relatively fast (small latency issue) but the gain of not having
to send 15 separate USB packets is huge (big throughput
increase).

My patch was really written for this specific context. However, I
am not knowledgeable enough on other network protocols to give
other examples where this new function could be applied (my blind
guess is that most of the protocol should *not* use it).

> 1) BQL is MIAD - multiplicative increase, additive decrease. While in
> practice so far this does not seem to matter much (and also measuring
> things down to "us" really hard), a stabler algorithm is AIMD. BQL
> often absorbs a large TSO burst - usually a minimum of 128k is
> observed on gbit, where a stabler state (without GSO) seemed to be
> around 40k on many of the chipsets I worked with, back when I was
> working in this area.
>
> (cake's gso-splitting also gets lower bql values in general, if you
> have enough cpu to run cake)
>
> 2) BQL + hardware mq is increasingly an issue in my mind in that, say,
> you are hitting
> 64 hw queues, each with 128k stored in there, is additive, where in
> order to service interrupts properly and keep the media busy might
> only require 128k total, spread across the active queues and flows. I
> have often thought that making BQL scale better to multiple hw queues
> by globally sharing the buffering state(s), would lead to lower
> latency, but
> also that probably sharing that state would be too high overhead.
>
> Having not worked out a solution to 2), and preferring to start with
> 1), and not having a whole lot of support for item 0) in the world, I
> just thought I'd mention it, in the hope
> someone might give it a go.

Thank you for the comments, however, I will be of small help
here. As mentioned above, my use cases are in bytes, not in
kilobytes. I lack experience here.

My experience is that BQL is not adapted for protocol with small
PDU and also not adapted for interfaces with a high
latency (e.g. USB) by default. But, modifying the dql.min_limit
solves it.

So, I let over people continue the discussion on points 1) and 2)


Yours sincerely,
Vincent
