Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7040B39A10D
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 14:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhFCMfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 08:35:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54889 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229892AbhFCMfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 08:35:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622723633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x5NtUVUE03a6WWucGBbuNsprX88T5ZoyDg605ZeHb7o=;
        b=FJnSwOaEsWORYwiO7ziPUOjzuURd/boJplA3FUJbRNhj9Em9Cj31Ni5ienT9oPv2H4vvjN
        hu02AK5xBJQO/CJUkqhXFpkJZhnYPldXA19qzNdtBwr9PVRQvDMTLcboA9ypcU6pKSD2/4
        kBoWRG/jr56WifjHpjxJX7RsqvxNpWM=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-zrMIgBiqOVG_vhmr1KEMRQ-1; Thu, 03 Jun 2021 08:33:52 -0400
X-MC-Unique: zrMIgBiqOVG_vhmr1KEMRQ-1
Received: by mail-io1-f71.google.com with SMTP id x8-20020a6bda080000b029048654ffbae7so3700389iob.8
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 05:33:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=x5NtUVUE03a6WWucGBbuNsprX88T5ZoyDg605ZeHb7o=;
        b=Dp0cIPUvJm495P7Dh9IRILPSHgKilvpwsXnL9SU4GRKi6+FBwAppsthZW1ldtqdsbI
         3jINYlVn7eXGZGCRKXTrXEnmaFfinII4yUM77iV23wPrnIAjJiMzsuide/+SGj9ho430
         e3KirDNLzMTgUIZmrBfTWJSHm1b/G8eutSlQcoJd5p11dSyz/ee4mo7i8UXRlKz0LVUT
         iXwizOa727z3O3EQkQsC/em4C8Y4HakusrhTa8aaQtjNw9RoZKuWWKEUwKbmZAIOei9z
         bre5+YBKj1ssn8WjoKngyjIkNknf2fqj0tIseQ3K+KSejivtmkoe9ZCCFwT87/0LrACD
         ixfA==
X-Gm-Message-State: AOAM532i+JkMtDaVWHiGbYhUFOUsxsW+qSch3f6co9Tfhe0CoFXrqTIL
        tCI38cL74KSdPTUlk7qeANUw8MREFG3f/WkZyjFiAmij/qC4BzbqJIWO5bi4tCLx3PBAYGwYuAc
        Eg8TKuGbMuBF+vYRnv+Uq4cOwODr2GhIg
X-Received: by 2002:a05:6638:bc2:: with SMTP id g2mr6114857jad.119.1622723631213;
        Thu, 03 Jun 2021 05:33:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyWqoeJcY+vQe09Awc00pitHbN7SSsf+0/mIxZuSe1sHdQ1t/FIC4tKljBzzk3bcknzFuKn71W8Wx/ZtUgy+wA=
X-Received: by 2002:a05:6638:bc2:: with SMTP id g2mr6114800jad.119.1622723630584;
 Thu, 03 Jun 2021 05:33:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210603063430.6613-1-ihuguet@redhat.com> <20210603074419.2930-1-hdanton@sina.com>
In-Reply-To: <20210603074419.2930-1-hdanton@sina.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Thu, 3 Jun 2021 14:33:39 +0200
Message-ID: <CACT4oudUd2YuV=GFhz1asvwX8h_mGtqzjZygBD26Tj98cxfCpw@mail.gmail.com>
Subject: Re: [PATCH 1/2] net:cxgb3: replace tasklets with works
To:     Hillf Danton <hdanton@sina.com>
Cc:     rajur@chelsio.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ivan Vecera <ivecera@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 3, 2021 at 9:47 AM Hillf Danton <hdanton@sina.com> wrote:
>
> On Thu,  3 Jun 2021 08:34:29 +0200 Inigo Huguet wrote:
> >
> > Moreover, given that probably the ring is not empty yet, so the
> > DMA still has work to do, we don't need to be so fast to justify
> > using tasklets/softirq instead of running in a thread.
>
> [...]
>
> > -             tasklet_kill(&qs->txq[TXQ_OFLD].qresume_tsk);
> > -             tasklet_kill(&qs->txq[TXQ_CTRL].qresume_tsk);
> > +             cancel_work_sync(&qs->txq[TXQ_OFLD].qresume_task);
> > +             cancel_work_sync(&qs->txq[TXQ_OFLD].qresume_task);
>
> This is the last minute mark that figures are needed to support your
> reasoning above.

OFLD queue has length=3D1024, and CTRL queue length=3D256. If a queue is
so full that the next packet doesn't fit, driver "stop" that queue.
That means that it adds the new outcoming packets to a list of packets
which are pending from being enqueued. Packets which were already in
the queue keep being processed by the DMA. When the queue has half or
more of free space, pending packets are moved from the "pending" list
to the queue.

If the list got full in the first place, it was because the NIC was
processing the packets slower than the CPU was trying to send them.
Given that, it is reasonable to think that there is enough time to
enqueue the pending packets before the DMA and the NIC are able to
process the other half of data still in the queue. If for some reason
the situation has changed in the meanwhile, and now the NIC is capable
of sending the packets REALLY fast, and the queue gets empty before
the qresume_task is run, it will be a small delay only once, not many
times, so it is not a big problem. But honestly, I don't know if this
situation can really happen in practice.

In my opinion there are no drawbacks moving these tasks to threads,
and in exchange we avoid increasing latencies in softirq context.
Consider that there might be a high amount of packets pending of being
enqueued, and in these "resume" tasks pending packets keep being
enqueued until there are no more of them, or until the queue gets full
again. The "resume" task might run for quite a long time.

cancel_work_sync is only called when the interface is set to down
state or the module removed.

--
=C3=8D=C3=B1igo Huguet

